// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import chisel3.util._
import freechips.rocketchip.diplomacy.{AddressSet, BufferParams, TransferSizes}
import freechips.rocketchip.prci.{ClockCrossingType, ClockSinkParameters}
import freechips.rocketchip.resources.BigIntHexContext
import freechips.rocketchip.subsystem._
import freechips.rocketchip.tilelink._
import org.chipsalliance.diplomacy.lazymodule._
import gemmini._
import midas.targetutils.SynthesizePrintf
import org.chipsalliance.cde.config.Parameters
import org.chipsalliance.diplomacy.{DisableMonitors, ValName}
import radiance.memory._
import radiance.subsystem.{RadianceFrameBufferKey, RadianceSharedMemKey}

import scala.collection.mutable.ArrayBuffer

case class RadianceClusterParams(
  val clusterId: Int,
  val clockSinkParams: ClockSinkParameters = ClockSinkParameters()
) extends InstantiableClusterParams[RadianceCluster] {
  val baseName = "radiance_cluster"
  val uniqueName = s"${baseName}_$clusterId"
  def instantiate(crossing: HierarchicalElementCrossingParamsLike, lookup: LookupByClusterIdImpl)
                 (implicit p: Parameters): RadianceCluster = {
    new RadianceCluster(this, crossing.crossingType, lookup)
  }
}

class RadianceCluster (
  thisClusterParams: RadianceClusterParams,
  crossing: ClockCrossingType,
  lookup: LookupByClusterIdImpl
)(implicit p: Parameters) extends Cluster(thisClusterParams, crossing, lookup) {
  // Instantiate cluster-local shared memory scratchpad
  //
  // Instantiate the same number of banks as there are lanes.
  // val numLsuLanes = 4 // FIXME: hardcoded

 // must toSeq here, otherwise Iterable is lazy and will break diplomacy
  val gemminiTiles = leafTiles.values.filter(_.isInstanceOf[GemminiTile]).toSeq.asInstanceOf[Seq[GemminiTile]]
  val gemminis = gemminiTiles.map(_.gemmini)
  val gemminiConfigs = gemminis.map(_.config)

  if (gemminiConfigs.length > 1) {
    if (!(gemminiConfigs.tail.map(_.inputType == gemminiConfigs.head.inputType).reduce(_ && _))) {
      println("******** WARNING ********\n******** gemmini data types do not match\n******** WARNING ********")
    }
  }

  val radianceTiles = leafTiles.values.filter(_.isInstanceOf[RadianceTile]).toSeq.asInstanceOf[Seq[RadianceTile]]

  val numCoresInCluster = leafTiles.size - gemminis.size

  // **************************************
  //    ______  _________  ___
  //   / __/  |/  / __/  |/  /
  //  _\ \/ /|_/ / _// /|_/ /
  // /___/_/  /_/___/_/  /_/
  //
  // **************************************

  val unified_mem_read_node = TLIdentityNode()
  val unified_mem_write_node = TLIdentityNode()

  val smem_key = p(RadianceSharedMemKey).get
  val wordSize = smem_key.wordSize
  val smem_base = smem_key.address
  val smem_banks = smem_key.numBanks
  val smem_width = smem_key.numWords * smem_key.wordSize
  val smem_depth = smem_key.size / smem_width / smem_banks
  val smem_subbanks = smem_width / wordSize
  val smem_size = smem_width * smem_depth * smem_banks

  gemminiConfigs.foreach { config =>
    assert(smem_banks == config.sp_banks && isPow2(smem_banks / config.sp_banks)) // TODO: should allow >=
    assert(smem_width >= (config.sp_width / 8) && isPow2(smem_width / (config.sp_width / 8)))
    assert(smem_size == config.sp_capacity.asInstanceOf[CapacityInKilobytes].kilobytes * 1024)
  }

  val stride_by_word = true
  val filter_aligned = true
  val disable_monitors = true // otherwise it generate 1k+ different tl monitors
  val serialize_unaligned = true

  def guard_monitors[T](callback: Parameters => T)(implicit p: Parameters): Unit = {
    if (disable_monitors) {
      DisableMonitors { callback }
    } else {
      callback(p)
    }
  }
  def connect_one[T <: TLNode](from: TLNode, to: () => T): T = {
    val t = to()
    guard_monitors { implicit p => t := from }
    t
  }
  def connect_xbar_name(from: TLNode, name: Option[String] = None,
                        policy: TLArbiter.Policy = TLArbiter.roundRobin): TLNexusNode = {
    val t = LazyModule(new TLXbar(policy))
    name.map(t.suggestName)
    guard_monitors { implicit p => t.node := from }
    t.node
  }
  def connect_xbar(from: TLNode): TLNexusNode = {
    connect_xbar_name(from, None)
  }

  val radiance_smem_fanout = radianceTiles.zipWithIndex.flatMap { case (tile, cid) =>
    tile.smemNodes.zipWithIndex.map { case (m, lid) =>
      val smem_fanout_xbar = LazyModule(new TLXbar())
      smem_fanout_xbar.suggestName(f"rad_smem_fanout_cl${thisClusterParams.clusterId}_c${cid}_l${lid}_xbar")
      smem_fanout_xbar.node :=* m
      smem_fanout_xbar.node
    }
  }

  require(isPow2(smem_banks))
  // collection of read and write managers for each sram (sub)bank
  val smem_bank_mgrs : Seq[Seq[TLManagerNode]] = if (stride_by_word) {
    require(isPow2(smem_subbanks))
    (0 until smem_banks).flatMap { bid =>
      (0 until smem_subbanks).map { wid =>
        Seq(TLManagerNode(Seq(TLSlavePortParameters.v1(
          managers = Seq(TLSlaveParameters.v2(
            name = Some(f"sp_bank${bid}_word${wid}_read_mgr"),
            address = Seq(AddressSet(
              smem_base + (smem_depth * smem_width * bid) + wordSize * wid,
              smem_depth * smem_width - smem_width + wordSize - 1
            )),
            supports = TLMasterToSlaveTransferSizes(
              get = TransferSizes(wordSize, wordSize)),
            fifoId = Some(0)
          )),
          beatBytes = wordSize
        ))
        ), TLManagerNode(Seq(TLSlavePortParameters.v1(
          managers = Seq(TLSlaveParameters.v2(
            name = Some(f"sp_bank${bid}_word${wid}_write_mgr"),
            address = Seq(AddressSet(
              smem_base + (smem_depth * smem_width * bid) + wordSize * wid,
              smem_depth * smem_width - smem_width + wordSize - 1
            )),
            supports = TLMasterToSlaveTransferSizes(
              putFull = TransferSizes(wordSize, wordSize),
              putPartial = TransferSizes(wordSize, wordSize)),
            fifoId = Some(0)
          )),
          beatBytes = wordSize
        ))))
      }
    }
  } else {
    (0 until smem_banks).map { bank =>
      Seq(TLManagerNode(Seq(TLSlavePortParameters.v1(
        managers = Seq(TLSlaveParameters.v2(
          name = Some(f"sp_bank${bank}_read_mgr"),
          address = Seq(AddressSet(smem_base + (smem_depth * smem_width * bank),
            smem_depth * smem_width - 1)),
          supports = TLMasterToSlaveTransferSizes(
            get = TransferSizes(1, smem_width)),
          fifoId = Some(0)
        )),
        beatBytes = smem_width
      ))
      ), TLManagerNode(Seq(TLSlavePortParameters.v1(
        managers = Seq(TLSlaveParameters.v2(
          name = Some(f"sp_bank${bank}_write_mgr"),
          address = Seq(AddressSet(smem_base + (smem_depth * smem_width * bank),
            smem_depth * smem_width - 1)),
          supports = TLMasterToSlaveTransferSizes(
            putFull = TransferSizes(1, smem_width),
            putPartial = TransferSizes(1, smem_width)),
          fifoId = Some(0)
        )),
        beatBytes = smem_width
      ))))
    }
  }

  val uniform_policy_nodes: Seq[ArrayBuffer[ArrayBuffer[ExtPolicyMasterNode]]] = // mutable
    Seq.fill(2)(ArrayBuffer.fill(smem_banks)(ArrayBuffer.fill(smem_subbanks)(null)))
  val uniform_nodes_in: Seq[ArrayBuffer[ArrayBuffer[Seq[TLIdentityNode]]]] =
    Seq.fill(2)(ArrayBuffer.fill(smem_banks)(ArrayBuffer.fill(smem_subbanks)(Seq())))
  val uniform_nodes_out: Seq[ArrayBuffer[ArrayBuffer[TLIdentityNode]]] =
    Seq.fill(2)(ArrayBuffer.fill(smem_banks)(ArrayBuffer.fill(smem_subbanks)(null)))

  val (uniform_r_nodes, uniform_w_nodes, _, _) =

  if (stride_by_word) {
    def dist_and_duplicate(nodes: Seq[TLNode], suffix: String): Seq[Seq[TLNexusNode]] = {
      val word_fanout_nodes = gemminis.zip(nodes).zipWithIndex.map { case ((gemmini, node), gemmini_idx) =>
        val sp_width_bytes = gemmini.config.sp_width / 8
        val sp_subbanks = sp_width_bytes / wordSize
        val dist = DistributorNode(from = sp_width_bytes, to = wordSize)
        guard_monitors { implicit p =>
          dist := TLBuffer(BufferParams(1, false, true), BufferParams(0)) := node
        }
        val fanout = Seq.tabulate(sp_subbanks) { w =>
          connect_xbar_name(dist, Some(s"spad_g${gemmini_idx}w${w}_fanout_$suffix"))
        }
        Seq.fill(smem_width / sp_width_bytes)(fanout).flatten // smem wider than spad, duplicate masters
      }
      // (gemmini, word) => (word, gemmini)
      word_fanout_nodes.transpose
    }

    // (banks, subbanks, gemminis)
    val spad_read_nodes = Seq.fill(smem_banks)(dist_and_duplicate(gemminis.map(_.spad_read_nodes), "r"))
    val spad_write_nodes = Seq.fill(smem_banks)(dist_and_duplicate(gemminis.map(_.spad_write_nodes), "w"))
    val spad_sp_write_nodes_single_bank = dist_and_duplicate(gemminis.map(_.spad.spad_writer.node), "ws")
    val spad_sp_write_nodes = Seq.fill(smem_banks)(spad_sp_write_nodes_single_bank) // executed only once

    val (uniform_r_nodes, uniform_w_nodes, nonuniform_r_nodes, nonuniform_w_nodes):
      (Seq[Seq[Seq[TLNexusNode]]], Seq[Seq[Seq[TLNexusNode]]], Seq[TLNode], Seq[TLNode]) = if (filter_aligned) {

      val num_lanes = radianceTiles.head.numCoreLanes
      val num_lsu_lanes = radianceTiles.head.numLsuLanes
      assert(num_lanes >= smem_subbanks)

      // since num lanes >= num subbanks, should be only one filter node per core/lane
      val filter_nodes: Seq[Seq[(TLNode, TLNode)]] = Seq.tabulate(smem_subbanks) { wid =>
        val address = AddressSet(smem_base + wordSize * wid, (smem_size - 1) - (smem_subbanks - 1) * wordSize)

        radiance_smem_fanout.grouped(num_lsu_lanes).toList.zipWithIndex.flatMap { case (lanes, cid) =>
          lanes.zipWithIndex.flatMap { case (lane, lid) =>
            if ((lid % smem_subbanks) == wid) {
              println(f"c${cid}_l${lid} connected to w${wid}")
              val filter_node = AlignFilterNode(Seq(address))(p, valName = ValName(s"filter_l${lid}_w$wid"), info)
              DisableMonitors { implicit p => filter_node := lane }
              // Seq((aligned splitter, unaligned splitter))
              Seq((connect_one(filter_node, () => RWSplitterNode(address, s"aligned_splitter_c${cid}_l${lid}_w$wid")),
                connect_one(filter_node, () => RWSplitterNode(AddressSet.everything, s"unaligned_splitter_c${cid}_l${lid}_w$wid"))))
            } else Seq()
          }
        }
      }
      val f_aligned = Seq.fill(2)(filter_nodes.map(_.map(_._1).map(connect_xbar_name(_, Some("rad_aligned")))))

      val f_unaligned = if (serialize_unaligned) {
        Seq.fill(2) {
          val serialized_node = TLEphemeralNode()
          val serialized_in_xbar = LazyModule(new TLXbar())
          val serialized_out_xbar = LazyModule(new TLXbar())
          serialized_in_xbar.suggestName("unaligned_serialized_in_xbar")
          serialized_out_xbar.suggestName("unaligned_serialized_out_xbar")
          guard_monitors { implicit p =>
            filter_nodes.foreach(_.map(_._2).foreach(serialized_in_xbar.node := _))
            serialized_node := serialized_in_xbar.node
            serialized_out_xbar.node := serialized_node
          }
          Seq(serialized_out_xbar.node)
        }
      } else {
        Seq.fill(2)(filter_nodes.flatMap(_.map(_._2).map(connect_xbar)))
      }

      val uniform_r_nodes: Seq[Seq[Seq[TLNexusNode]]] = spad_read_nodes.map { rb =>
        (rb zip f_aligned.head).map { case (rw, fa) => rw ++ fa }
      }
      val uniform_w_nodes: Seq[Seq[Seq[TLNexusNode]]] = (spad_write_nodes zip spad_sp_write_nodes).map { case (wb, wsb) =>
        (wb lazyZip wsb lazyZip f_aligned.last).map {
          case (ww, wsw, fa) => ww ++ wsw ++ fa
        }
      }

      // all to all xbar
      val Seq(nonuniform_r_nodes, nonuniform_w_nodes) = f_unaligned

      (uniform_r_nodes, uniform_w_nodes, nonuniform_r_nodes, nonuniform_w_nodes)
    } else {
      val splitter_nodes = radiance_smem_fanout.map { connect_one(_, RWSplitterNode.apply) }
      // these nodes access an entire line simultaneously
      val uniform_r_nodes: Seq[Seq[Seq[TLNexusNode]]] = spad_read_nodes
      val uniform_w_nodes: Seq[Seq[Seq[TLNexusNode]]] = (spad_write_nodes zip spad_sp_write_nodes).map { case (wb, wsb) =>
        (wb zip wsb).map { case (ww, wsw) => ww ++ wsw }
      }
      // these nodes are random access
      val nonuniform_r_nodes: Seq[TLNode] = splitter_nodes.map(connect_xbar_name(_, Some("rad_unaligned_r")))
      val nonuniform_w_nodes: Seq[TLNode] = splitter_nodes.map(connect_xbar_name(_, Some("rad_unaligned_w")))

      (uniform_r_nodes, uniform_w_nodes, nonuniform_r_nodes, nonuniform_w_nodes)
    }

    guard_monitors { implicit p => radiance_smem_fanout.foreach(clbus.inwardNode := _) }

    smem_bank_mgrs.grouped(smem_subbanks).zipWithIndex.foreach { case (bank_mgrs, bid) =>
      bank_mgrs.zipWithIndex.foreach { case (Seq(r, w), wid) =>
        // TODO: this should be a coordinated round robin
        val subbank_r_xbar = LazyModule(new TLXbar(TLArbiter.lowestIndexFirst))
        val subbank_w_xbar = LazyModule(new TLXbar(TLArbiter.lowestIndexFirst))
        subbank_r_xbar.suggestName(s"smem_b${bid}_w${wid}_r_xbar")
        subbank_w_xbar.suggestName(s"smem_b${bid}_w${wid}_w_xbar")

        guard_monitors { implicit p =>
          r := subbank_r_xbar.node
          w := subbank_w_xbar.node

          val ur_xbar = XbarWithExtPolicy(Some("ur"))
          val uw_xbar = XbarWithExtPolicy(Some("uw"))
          val r_policy_node = ExtPolicyMasterNode(uniform_r_nodes(bid)(wid).length)
          val w_policy_node = ExtPolicyMasterNode(uniform_w_nodes(bid)(wid).length)
          ur_xbar.policySlaveNode := r_policy_node
          uw_xbar.policySlaveNode := w_policy_node
          uniform_policy_nodes.head(bid)(wid) = r_policy_node
          uniform_policy_nodes.last(bid)(wid) = w_policy_node

          (Seq(ur_xbar, uw_xbar) lazyZip uniform_nodes_in lazyZip Seq(uniform_r_nodes, uniform_w_nodes))
            .foreach { case (xbar, id_buf, u_nodes) =>

            id_buf(bid)(wid) = u_nodes(bid)(wid).map { u =>
              val id = TLIdentityNode()
              xbar.node := id := u
              id
            }
          }

          // uniform_w_nodes(bid)(wid).foreach( uw_xbar.node := _ )
          uniform_nodes_out.head(bid)(wid) = TLIdentityNode()
          uniform_nodes_out.last(bid)(wid) = TLIdentityNode()
          subbank_r_xbar.node := uniform_nodes_out.head(bid)(wid) := ur_xbar.node
          subbank_w_xbar.node := uniform_nodes_out.last(bid)(wid) := uw_xbar.node

          nonuniform_r_nodes.foreach( subbank_r_xbar.node := _ )
          nonuniform_w_nodes.foreach( subbank_w_xbar.node := _ )
        }
      }
    }

    (Some(uniform_r_nodes), Some(uniform_w_nodes), Some(nonuniform_r_nodes), Some(nonuniform_w_nodes))
  } else {
    gemminis.foreach { gemmini =>
      unified_mem_read_node :=* TLWidthWidget(smem_width) :=* gemmini.spad_read_nodes
      unified_mem_write_node :=* TLWidthWidget(smem_width) :=* gemmini.spad_write_nodes
      unified_mem_write_node := gemmini.spad.spad_writer.node // this is the dma write node
    }

    val splitter_node = RWSplitterNode()
    unified_mem_read_node := TLWidthWidget(smem_width) := splitter_node
    unified_mem_write_node := TLWidthWidget(smem_width) := splitter_node

    radiance_smem_fanout.foreach(clbus.inwardNode := _)
    splitter_node :=* TLWidthWidget(4) :=* clbus.outwardNode

    val smem_r_xbar = TLXbar()
    val smem_w_xbar = TLXbar()
    DisableMonitors { implicit p =>
      smem_r_xbar :=* TLWidthWidget(wordSize) :=* unified_mem_read_node
      smem_w_xbar :=* TLWidthWidget(wordSize) :=* unified_mem_write_node
    }

    smem_bank_mgrs.foreach { mem =>
      require(mem.length == 2)
      mem.head := smem_r_xbar
      mem.last := smem_w_xbar
    }

    (None, None, None, None)
  }

  // *******************************************************
  //    ___  _______  _______  __ _________  ___   __   ____
  //   / _ \/ __/ _ \/  _/ _ \/ // / __/ _ \/ _ | / /  / __/
  //  / ___/ _// , _// // ___/ _  / _// , _/ __ |/ /___\ \
  // /_/  /___/_/|_/___/_/  /_//_/___/_/|_/_/ |_/____/___/
  //
  // *******************************************************

  val radianceAccSlaveNodes = Seq.fill(numCoresInCluster)(AccSlaveNode())
  (radianceAccSlaveNodes zip radianceTiles).foreach { case (a, r) => a := r.accMasterNode }
  val gemminiAccMasterNodes = gemminiTiles.map { tile =>
    val masterNode = AccMasterNode()
    tile.accSlaveNode := masterNode
    masterNode
  }
  gemminiTiles.foreach { _.slaveNode :=* TLWidthWidget(4) :=* clbus.outwardNode }

  val traceTLNode = TLAdapterNode(clientFn = c => c, managerFn = m => m)
  // printf and perf counter buffer
  TLRAM(AddressSet(smem_key.address + smem_size, numCoresInCluster * 0x200 - 1)) := traceTLNode :=
    TLBuffer() := TLFragmenter(4, 4) := clbus.outwardNode

  p(RadianceFrameBufferKey).foreach { key =>
    val fb = LazyModule(new FrameBuffer(key.baseAddress, key.width, key.size, key.validAddress, key.fbName))
    fb.node := TLBuffer() := TLFragmenter(4, 4) := clbus.outwardNode
  }

  // Diplomacy sink nodes for cluster-wide barrier sync signal
  val barrierSlaveNode = BarrierSlaveNode(numCoresInCluster)

  // HACK: This is a workaround of the CanAttachTile bus connecting API that
  // works by downcasting tile and directly accessing the node inside that is
  // not exposed as a master in HierarchicalElementCrossingParamsLike.
  // val tile = leafTiles(0).asInstanceOf[RadianceTile]
  // val perSmemPortXbars = Seq.fill(tile.smemNodes.size) { LazyModule(new TLXbar) }

  // Tie corresponding smem ports from every tile into a single port using
  // Xbars so that the number of ports going into the sharedmem do not scale
  // with the number of tiles.
  radianceTiles.foreach { tile =>
    // (perSmemPortXbars zip tile.smemNodes).foreach {
    //   case (xbar, node) => xbar.node := node
    // }
    barrierSlaveNode := tile.barrierMasterNode
  }
  // perSmemPortXbars.foreach { clbus.inwardNode := _.node }

  override lazy val module = new RadianceClusterModuleImp(this)
}

class RadianceClusterModuleImp(outer: RadianceCluster) extends ClusterModuleImp(outer) {
  println(s"======= RadianceCluster: clbus inward edges = ${outer.clbus.inwardNode.inward.inputs.length}")
  println(s"======= RadianceCluster: clbus name = ${outer.clbus.busName}")

  // @cleanup: This assumes barrier params on all edges are the same, i.e. all
  // cores are configured to have the same barrier id range.  While true, might
  // be better to actually assert this
  val barrierParam = outer.barrierSlaveNode.in.head._2
  val synchronizer = Module(new BarrierSynchronizer(barrierParam))
  (synchronizer.io.reqs zip outer.barrierSlaveNode.in).foreach { case (req, (b, _)) =>
    req <> b.req
    b.resp <> synchronizer.io.resp // broadcast
  }

  val coreAccs = outer.radianceAccSlaveNodes.map(_.in.head._1)
  val gemminiAccs = outer.gemminiAccMasterNodes.map(_.out.head._1)
  // val gemminiTileAcc = outer.gemminiTile.accSlaveNode.in.head._1

  // gemminiTileAcc.cmd := gemminiAcc.cmd
  // gemminiAcc.status := gemminiTileAcc.status

  gemminiAccs.zipWithIndex.foreach { case (g, gi) =>
    val active = coreAccs.map(acc => acc.cmd.valid && (acc.dest() === gi.U))
    val selected = PriorityEncoder(active)
    g.cmd.bits := VecInit(coreAccs.map(_.cmd.bits))(selected) & g.mask
    g.cmd.valid := VecInit(active).reduceTree(_ || _)
  }

  // this might need some more tweaking (e.g. bitmask instead of or)
  coreAccs.foreach(_.status := VecInit(gemminiAccs.map(_.status)).reduceTree(_ | _))

  (outer.traceTLNode.in.map(_._1) zip outer.traceTLNode.out.map(_._1)).foreach { case (i, o) =>
    o.a <> i.a
    i.d <> o.d

    when (i.a.fire) {
      when (i.a.bits.opcode === TLMessages.PutFullData || i.a.bits.opcode === TLMessages.PutPartialData) {
        SynthesizePrintf(printf(s"TRACEWR ${outer.traceTLNode.name}: %x %x %x\n", i.a.bits.address, i.a.bits.data, i.a.bits.mask))
      }
    }
  }

  // TODO: remove Pipeline dependency of gemmini
  def makeSmemBanks(): Unit = {
    def make_buffer[T <: Data](mem: TwoPortSyncMem[T], r_node: TLBundle, r_edge: TLEdgeIn,
                               w_node: TLBundle, w_edge: TLEdgeIn): Unit = {
      mem.io.ren := r_node.a.fire

      val data_pipe_in = Wire(DecoupledIO(mem.io.rdata.cloneType))
      data_pipe_in.valid := RegNext(mem.io.ren)
      data_pipe_in.bits := mem.io.rdata

      val metadata_pipe_in = Wire(DecoupledIO(new Bundle {
        val source = r_node.a.bits.source.cloneType
        val size = r_node.a.bits.size.cloneType
      }))
      metadata_pipe_in.valid := mem.io.ren
      metadata_pipe_in.bits.source := r_node.a.bits.source
      metadata_pipe_in.bits.size := r_node.a.bits.size

      val sram_read_backup_reg = RegInit(0.U.asTypeOf(Valid(mem.io.rdata.cloneType)))

      val data_pipe_inst = Module(new Pipeline(data_pipe_in.bits.cloneType, 1)())
      data_pipe_inst.io.in <> data_pipe_in
      val data_pipe = data_pipe_inst.io.out
      val metadata_pipe = Pipeline(metadata_pipe_in, 2)
      assert((data_pipe.valid || sram_read_backup_reg.valid) === metadata_pipe.valid)

      // data pipe is filled, but D is not ready and SRAM read came back
      when (data_pipe.valid && !r_node.d.ready && data_pipe_in.valid) {
        assert(!data_pipe_in.ready) // we should fill backup reg only if data pipe is not enqueueing
        assert(!sram_read_backup_reg.valid) // backup reg should be empty
        assert(!metadata_pipe_in.ready) // metadata should be filled previous cycle
        sram_read_backup_reg.valid := true.B
        sram_read_backup_reg.bits := mem.io.rdata
      }.otherwise {
        assert(data_pipe_in.ready || !data_pipe_in.valid) // do not skip any response
      }

      assert(metadata_pipe_in.fire || !mem.io.ren) // when requesting sram, metadata needs to be ready
      assert(r_node.d.fire === metadata_pipe.fire) // metadata dequeues iff D fires

      // when D becomes ready, and data pipe has emptied, time for backup to empty
      when (r_node.d.ready && sram_read_backup_reg.valid && !data_pipe.valid) {
        sram_read_backup_reg.valid := false.B
      }
      // must empty backup before filling data pipe
      assert(!(sram_read_backup_reg.valid && data_pipe.valid && data_pipe_in.fire))

      r_node.d.bits := r_edge.AccessAck(
        Mux(r_node.d.valid, metadata_pipe.bits.source, 0.U),
        Mux(r_node.d.valid, metadata_pipe.bits.size, 0.U),
        Mux(!data_pipe.valid, sram_read_backup_reg.bits, data_pipe.bits).asUInt)
      r_node.d.valid := data_pipe.valid || sram_read_backup_reg.valid
      // r node A is not ready only if D is not ready and both slots filled
      r_node.a.ready := r_node.d.ready && !(data_pipe.valid && sram_read_backup_reg.valid)
      data_pipe.ready := r_node.d.ready
      metadata_pipe.ready := r_node.d.ready

      // WRITE
      mem.io.wen := RegNext(w_node.a.fire)
      mem.io.wdata := RegNext(w_node.a.bits.data)
      mem.io.mask := RegNext(VecInit(w_node.a.bits.mask.asBools))

      val write_resp = Wire(Flipped(w_node.d.cloneType))
      write_resp.bits := w_edge.AccessAck(w_node.a.bits)
      write_resp.valid := w_node.a.valid
      w_node.a.ready := write_resp.ready
      w_node.d <> Queue(write_resp, 2)
    }

    // read OR write access counter for smem banks
    val smem_bank_mgrs_grouped = outer.smem_bank_mgrs.grouped(outer.smem_subbanks)
    val numBanks = smem_bank_mgrs_grouped.length
    val counterWidth = 32
    val smemReadsPerBankPerCycle  = Seq.fill(numBanks)(Seq.fill(outer.smem_subbanks)
                                                               (Wire(UInt(counterWidth.W))))
    val smemWritesPerBankPerCycle = Seq.fill(numBanks)(Seq.fill(outer.smem_subbanks)
                                                               (Wire(UInt(counterWidth.W))))
    val smemReadsPerCycle  = smemReadsPerBankPerCycle.map(_.reduce(_ + _)).reduce(_ + _)
    val smemWritesPerCycle = smemWritesPerBankPerCycle.map(_.reduce(_ + _)).reduce(_ + _)
    val smemReadCounter = RegInit(UInt(counterWidth.W), 0.U)
    val smemWriteCounter = RegInit(UInt(counterWidth.W), 0.U)
    smemReadCounter  := smemReadCounter + smemReadsPerCycle
    smemWriteCounter := smemWriteCounter + smemWritesPerCycle
    // smemReadsPerBankPerCycle.foreach(_.foreach(dontTouch(_)))
    dontTouch(smemReadCounter)
    dontTouch(smemWriteCounter)

    if (outer.stride_by_word) {
      val (uniform_r_nodes, uniform_w_nodes) = (outer.uniform_r_nodes.get, outer.uniform_w_nodes.get)
      val uniform_fires = Seq.fill(2)(VecInit.fill(outer.smem_banks)(VecInit.fill(outer.smem_subbanks)(false.B)))
      val word_selects_1h = Seq.fill(2)(VecInit.fill(outer.smem_banks)(0.U))

      outer.smem_bank_mgrs.grouped(outer.smem_subbanks).zipWithIndex.foreach { case (bank_mgrs, bid) =>
        // TODO move this loop out
        // val Seq(valid_r_sources, valid_w_sources) = uniform_xbar_nodes.map(_(bid)).map { words =>
        //   VecInit(words.map(_.out.map(_._1.a.valid)).transpose.map { words_with_same_idx =>
        //     VecInit(words_with_same_idx.toSeq).asUInt.orR
        //   }.toSeq).asUInt
        // }
        val Seq(valid_r_sources, valid_w_sources) = outer.uniform_nodes_in.map { banks =>
          banks(bid).map(_.map(_.in.head._1.a.valid)).transpose.map { words_in_idx =>
            VecInit(words_in_idx.toSeq).asUInt.orR
          }
        }

        assert(bank_mgrs.flatten.size == 2/* read and write */ * outer.smem_subbanks)
        bank_mgrs.zipWithIndex.foreach { case (Seq(r, w), wid) =>
          assert(!r.portParams.map(_.anySupportPutFull).reduce(_ || _))
          assert(!w.portParams.map(_.anySupportGet).reduce(_ || _))

          val mem_depth = outer.smem_depth
          val mem_width = outer.smem_width
          val word_width = outer.wordSize

          val mem = TwoPortSyncMem(
            n = mem_depth,
            t = UInt((word_width * 8).W),
            mask_len = word_width // byte level mask
          )
          mem.suggestName(s"rad_smem_c${outer.thisClusterParams.clusterId}_b${bid}_w${wid}")

          val (r_node, r_edge) = r.in.head
          val (w_node, w_edge) = w.in.head

          // address format is
          // [ smem_base | bank_id | line_id | word_id | byte_offset ]
          // line_id is used to index into the SRAMs
          mem.io.raddr := (r_node.a.bits.address & (mem_depth * mem_width - 1).U) >> log2Ceil(mem_width).U
          mem.io.waddr := RegNext((w_node.a.bits.address & (mem_depth * mem_width - 1).U) >> log2Ceil(mem_width).U)

          assert((bid.U === ((r_node.a.bits.address & (mem_depth * mem_width * outer.smem_banks - 1).U) >>
            log2Ceil(mem_depth * mem_width).U).asUInt) || !r_node.a.valid, "bank id mismatch with request")
          assert((wid.U === ((r_node.a.bits.address & (mem_width - 1).U) >>
            log2Ceil(word_width).U).asUInt) || !r_node.a.valid, "word id mismatch with request")

          make_buffer(mem, r_node, r_edge, w_node, w_edge)

          // add access counters to banks
          smemReadsPerBankPerCycle(bid)(wid)  := (r_node.a.fire === true.B)
          smemWritesPerBankPerCycle(bid)(wid) := (w_node.a.fire === true.B)

          // (uniform_fires zip Seq(uniform_r_nodes, uniform_w_nodes)).foreach { case (uf, n) =>
          //   uf(bid)(wid) := VecInit(n(bid)(wid).map(_.out.head._1.a.fire)).asUInt.orR
          // }
          (uniform_fires zip outer.uniform_nodes_out).foreach { case (uf, n) =>
            uf(bid)(wid) := n(bid)(wid).in.head._1.a.fire
          }
        }

        println(f"valid r_sources ${valid_r_sources.length}, ${valid_r_sources}")
        (word_selects_1h zip Seq(valid_r_sources, valid_w_sources)).zipWithIndex.foreach { case ((ws, vs), rw) =>
          ws(bid) := TLArbiter.roundRobin(vs.length, VecInit(vs.toSeq).asUInt, uniform_fires(rw)(bid).asUInt.orR)
        }
      }

      (outer.uniform_policy_nodes zip word_selects_1h).zipWithIndex.foreach { case ((nodes_bw, ws_b), rw) =>
        (nodes_bw zip ws_b).zipWithIndex.foreach { case ((nodes_w, ws), bid) =>
          nodes_w.foreach { _.out.head._1 := ws }
        }
      }
    } else {
      outer.smem_bank_mgrs.foreach { case Seq(r, w) =>
        val mem_depth = outer.smem_depth
        val mem_width = outer.smem_width

        val mem = TwoPortSyncMem(
          n = mem_depth,
          t = UInt((mem_width * 8).W),
          mask_len = mem_width // byte level mask
        )

        val (r_node, r_edge) = r.in.head
        val (w_node, w_edge) = w.in.head

        mem.io.raddr := (r_node.a.bits.address ^ outer.smem_base.U) >> log2Ceil(mem_width).U
        mem.io.waddr := RegNext((w_node.a.bits.address ^ outer.smem_base.U) >> log2Ceil(mem_width).U)

        make_buffer(mem, r_node, r_edge, w_node, w_edge)
      }
    }
  }

  makeSmemBanks()
}
