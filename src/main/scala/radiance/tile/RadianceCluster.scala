// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import chisel3.util._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.prci.ClockSinkParameters
import freechips.rocketchip.subsystem._
import freechips.rocketchip.tilelink._
import gemmini._
import org.chipsalliance.cde.config.Parameters
import radiance.memory._

case class RadianceClusterParams(
  val clusterId: Int,
  val clockSinkParams: ClockSinkParameters = ClockSinkParameters()
) extends InstantiableClusterParams[RadianceCluster] {
  val baseName = "radiance_cluster"
  val uniqueName = s"${baseName}_$clusterId"
  def instantiate(crossing: HierarchicalElementCrossingParamsLike, lookup: LookupByClusterIdImpl)(implicit p: Parameters): RadianceCluster = {
    new RadianceCluster(this, crossing.crossingType, lookup)
  }
}

class RadianceCluster (
  thisClusterParams: RadianceClusterParams,
  crossing: ClockCrossingType,
  lookup: LookupByClusterIdImpl
)(implicit p: Parameters) extends Cluster(thisClusterParams, crossing, lookup) {
  // cluster-local bus, used for shared memory traffic that never leaves the
  // confines of a cluster
  val clbus = tlBusWrapperLocationMap(CLBUS(clusterId))

  clbus.clockGroupNode := allClockGroupsNode

  // Instantiate cluster-local shared memory scratchpad
  //
  // Instantiate the same number of banks as there are lanes.
  // val numLsuLanes = 4 // FIXME: hardcoded
  val wordSize = 4

  val gemminis = leafTiles.values.filter(_.isInstanceOf[GemminiTile]).asInstanceOf[Iterable[GemminiTile]]
  require(gemminis.size == 1, "there should be one and only one gemmini per cluster")
  val gemmini = gemminis.head.gemmini
  val gemminiTile = gemminis.head
  // val gemminiConfig = thisClusterParams.gemminiConfig.get // TODO: handle None gracefully
  val gemminiConfig = gemmini.config

  val max_write_width_bytes = gemminiConfig.dma_buswidth / 8

  val radianceTiles = leafTiles.values.filter(_.isInstanceOf[RadianceTile]).asInstanceOf[Iterable[RadianceTile]]

  val numCores = leafTiles.size - gemminis.size

  // **************************************
  //    ______  _________  ___
  //   / __/  |/  / __/  |/  /
  //  _\ \/ /|_/ / _// /|_/ /
  // /___/_/  /_/___/_/  /_/
  //
  // **************************************

  // TODO: parametrize bank configuration
  // TODO: move rw split node to separate file
  // TODO: stride by word
  val unified_mem_read_node = TLIdentityNode()
  val unified_mem_write_node = TLIdentityNode()

  val spad_data_len = gemminiConfig.sp_width / 8
  val acc_data_len = gemminiConfig.sp_width / gemminiConfig.inputType.getWidth * gemminiConfig.accType.getWidth / 8

  val smem_base = gemminiConfig.tl_ext_mem_base
  val smem_width = spad_data_len
  val smem_depth = gemminiConfig.sp_bank_entries * spad_data_len / smem_width
  val smem_banks = gemminiConfig.sp_banks
  val smem_subbanks = smem_width / wordSize
  val smem_size = smem_width * smem_depth * smem_banks

  val stride_by_word = true

  val radiance_smem_fanout = radianceTiles.flatMap {
    _.smemNodes.map { m =>
      val smem_fanout_xbar = TLXbar()
      smem_fanout_xbar :=* m
      smem_fanout_xbar
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

  if (stride_by_word) {
    val spad_read_nodes = Seq.fill(smem_banks) {
      val r_dist = DistributorNode(from = smem_width, to = wordSize)
      r_dist := gemmini.spad_read_nodes
      Seq.fill(smem_subbanks) {
        val id_node = TLIdentityNode()
        id_node := r_dist
        id_node
      }
    }
    val spad_write_nodes = Seq.fill(smem_banks) {
      val w_dist = DistributorNode(from = smem_width, to = wordSize)
      w_dist := gemmini.spad_write_nodes
      Seq.fill(smem_subbanks) {
        val id_node = TLIdentityNode()
        id_node := w_dist
        id_node
      }
    }
    val ws_dist = DistributorNode(from = smem_width, to = wordSize)
    ws_dist := gemmini.spad.spad_writer.node // this is the dma write node
    val spad_sp_write_nodes = Seq.fill(smem_subbanks) {
      val ws_xbar = TLXbar() // fanout to 4 banks
      ws_xbar := ws_dist
      ws_xbar
    }

    // spad_read_nodes.flatten.foreach(node => unified_mem_read_node :=* node)
    // spad_write_nodes.flatten.foreach(node => unified_mem_write_node :=* node)
    // spad_sp_write_nodes.foreach(node => unified_mem_write_node :=* node)
    // unified_mem_write_node :=* DistributorNode(from = smem_width, to = wordSize) :=* gemmini.spad.spad_writer.node // this is the dma write node
    // unified_mem_read_node :=* TLWidthWidget(acc_data_len) :=* acc_read_nodes
    // unified_mem_write_node :=* TLWidthWidget(acc_data_len) :=* acc_write_nodes

    // these nodes access an entire line simultaneously
    val uniform_r_nodes: Seq[Seq[Seq[TLNode]]] = spad_read_nodes.map { rb =>
      rb.map { rw => Seq(rw) }
    }
    val uniform_w_nodes: Seq[Seq[Seq[TLNode]]] = spad_write_nodes.map { wb =>
      (wb zip spad_sp_write_nodes).map { case (ww, sw) => Seq(ww, sw) }
    }

    val splitter_nodes = radiance_smem_fanout.map { m =>
      val splitter_node = RWSplitterNode()
      splitter_node := m
      splitter_node
    }

    radiance_smem_fanout.foreach(clbus.inwardNode := _)

    // these nodes are random access
    val nonuniform_r_nodes: Seq[TLNode] = splitter_nodes.map { s =>
      val nu_r_xbar = TLXbar()
      nu_r_xbar := s
      nu_r_xbar
    }.toSeq
    val nonuniform_w_nodes: Seq[TLNode] = splitter_nodes.map { s =>
      val nu_w_xbar = TLXbar()
      nu_w_xbar := s
      nu_w_xbar
    }.toSeq

    smem_bank_mgrs.grouped(smem_subbanks).zipWithIndex.foreach { case (bank_mgrs, bid) =>
      bank_mgrs.zipWithIndex.foreach { case (Seq(r, w), wid) =>
        // TODO: this should be a coordinated round robin
        val subbank_r_xbar = TLXbar(TLArbiter.lowestIndexFirst)
        val subbank_w_xbar = TLXbar(TLArbiter.lowestIndexFirst)
        r := subbank_r_xbar
        w := subbank_w_xbar
        uniform_r_nodes(bid)(wid).foreach( subbank_r_xbar := _ )
        uniform_w_nodes(bid)(wid).foreach( subbank_w_xbar := _ )

        nonuniform_r_nodes.foreach( subbank_r_xbar := _ )
        nonuniform_w_nodes.foreach( subbank_w_xbar := _ )
      }
    }
  } else {
    unified_mem_read_node :=* TLWidthWidget(spad_data_len) :=* gemmini.spad_read_nodes
    unified_mem_write_node :=* TLWidthWidget(spad_data_len) :=* gemmini.spad_write_nodes
    unified_mem_write_node := gemmini.spad.spad_writer.node // this is the dma write node

    val splitter_node = RWSplitterNode()
    unified_mem_read_node := TLWidthWidget(spad_data_len) := splitter_node
    unified_mem_write_node := TLWidthWidget(spad_data_len) := splitter_node

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
  }

  // connect tile smem nodes to xbar, and xbar to banks
  // val smem_xbar = TLXbar()
  gemminiTile.slaveNode :=* TLWidthWidget(4) :=* clbus.outwardNode

  assert(smem_size == 0x4000, "fix me")
  // printf and perf counter buffer
  TLRAM(AddressSet(x"ff000000" + smem_size, numCores * 0x200 - 1)) := TLFragmenter(4, 4) := clbus.outwardNode

  // Diplomacy sink nodes for cluster-wide barrier sync signal
  val barrierSlaveNode = BarrierSlaveNode(numCores)

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

  // Memory-mapped register for barrier sync
  val regDevice = new SimpleDevice("radiance-cluster-barrier-reg",
                                   Seq(s"radiance-cluster-barrier-reg${clusterId}"))
  val regNode = TLRegisterNode(
    address = Seq(AddressSet(0xff004f00L, 0xff)),
    device = regDevice,
    beatBytes = wordSize,
    concurrency = 1)
  regNode := clbus.outwardNode

  nodes.foreach({ node =>
      println(s"======= RadianceCluster node.name: ${node.name}")
  })

  override lazy val module = new RadianceClusterModuleImp(this)
}

class RadianceClusterModuleImp(outer: RadianceCluster) extends ClusterModuleImp(outer) {
  println(s"======= RadianceCluster: clbus inward edges = ${outer.clbus.inwardNode.inward.inputs.length}")
  println(s"======= RadianceCluster: clbus name = ${outer.clbus.busName}")

  // @cleanup: This assumes barrier params on all edges are the same, i.e. all
  // cores are configured to have the same barrier id range.  While true, might
  // be better to actually assert this
  val barrierParam = outer.barrierSlaveNode.in(0)._2
  println(s"======= barrierParam: ${barrierParam}")
  val synchronizer = Module(new BarrierSynchronizer(barrierParam))
  (synchronizer.io.reqs zip outer.barrierSlaveNode.in).foreach { case (req, (b, _)) =>
    req <> b.req
    b.resp <> synchronizer.io.resp // broadcast
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
      assert(!(sram_read_backup_reg.valid && data_pipe.valid && data_pipe_in.fire)) // must empty backup before filling data pipe

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
      mem.io.wen := w_node.a.fire
      mem.io.wdata := w_node.a.bits.data
      mem.io.mask := w_node.a.bits.mask.asBools
      w_node.a.ready := w_node.d.ready// && (mem.io.waddr =/= mem.io.raddr)
      w_node.d.valid := w_node.a.valid
      w_node.d.bits := w_edge.AccessAck(w_node.a.bits)
    }

    if (outer.stride_by_word) {
      outer.smem_bank_mgrs.grouped(outer.smem_subbanks).zipWithIndex.foreach { case (bank_mgrs, bid) =>
        assert(bank_mgrs.flatten.size == 2 * outer.smem_subbanks)
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
          mem.io.waddr := (w_node.a.bits.address & (mem_depth * mem_width - 1).U) >> log2Ceil(mem_width).U

          assert((bid.U === ((r_node.a.bits.address & (mem_depth * mem_width * outer.smem_banks - 1).U) >>
            log2Ceil(mem_depth * mem_width).U).asUInt) || !r_node.a.valid, "bank id mismatch with request")
          assert((wid.U === ((r_node.a.bits.address & (mem_width - 1).U) >>
            log2Ceil(word_width).U).asUInt) || !r_node.a.valid, "word id mismatch with request")

          make_buffer(mem, r_node, r_edge, w_node, w_edge)
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
        mem.io.waddr := (w_node.a.bits.address ^ outer.smem_base.U) >> log2Ceil(mem_width).U

        make_buffer(mem, r_node, r_edge, w_node, w_edge)
      }
    }
  }

  makeSmemBanks()

  println(s"======== barrierSlaveNode: ${outer.barrierSlaveNode.in(0)._2.barrierIdBits}")
}
