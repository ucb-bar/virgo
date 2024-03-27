// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import chisel3.util._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.prci.ClockSinkParameters
import freechips.rocketchip.regmapper.RegField
import freechips.rocketchip.subsystem._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util.BundleField
import gemmini._
import org.chipsalliance.cde.config.Parameters

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
  val max_data_len = spad_data_len // max acc_data_len
  val smem_base = gemminiConfig.tl_ext_mem_base
  val smem_depth = gemminiConfig.sp_bank_entries * spad_data_len / max_data_len
  val smem_width = max_data_len
  val smem_banks = gemminiConfig.sp_banks
  val smem_subbanks = 1

  unified_mem_read_node :=* TLWidthWidget(spad_data_len) :=* gemmini.spad_read_nodes
  // unified_mem_read_node :=* TLWidthWidget(acc_data_len) :=* acc_read_nodes
  unified_mem_write_node :=* TLWidthWidget(spad_data_len) :=* gemmini.spad_write_nodes
  // unified_mem_write_node :=* TLWidthWidget(acc_data_len) :=* acc_write_nodes
  unified_mem_write_node := gemmini.spad.spad_writer.node // this is the dma write node

  // this node accepts both read and write requests,
  // splits & arbitrates them into one client node per type of operation
  // it keeps the read and write channels fully separate to allow parallel processing
  val unified_mem_node = TLNexusNode(
    clientFn = { seq =>
      val in_mapping = TLXbar.mapInputIds(seq)
      val read_src_range = IdRange(in_mapping.map(_.start).min, in_mapping.map(_.end).max)
      assert((read_src_range.start == 0) && isPow2(read_src_range.end))
      val write_src_range = read_src_range.shift(read_src_range.size)
      val visibilities = seq.flatMap(_.masters.flatMap(_.visibility))
      val vis_min = visibilities.map(_.base).min
      val vis_max = visibilities.map{ x => x.base + x.mask }.max
      val vis_mask = vis_max - vis_min
      require(isPow2(vis_mask + 1) || vis_mask == -1)
      println(f"combined visibilities of unified memory node clients: ${vis_min}, ${vis_mask}")

      seq(0).v1copy(
        echoFields = BundleField.union(seq.flatMap(_.echoFields)),
        requestFields = BundleField.union(seq.flatMap(_.requestFields)),
        responseKeys = seq.flatMap(_.responseKeys).distinct,
        minLatency = seq.map(_.minLatency).min,
        clients = Seq(
          TLMasterParameters.v1(
            name = "unified_mem_read_client",
            sourceId = read_src_range,
            visibility = Seq(AddressSet(vis_min, vis_mask)),
            supportsProbe = TransferSizes.mincover(seq.map(_.anyEmitClaims.get)),
            supportsGet = TransferSizes.mincover(seq.map(_.anyEmitClaims.get)),
            supportsPutFull = TransferSizes.none,
            supportsPutPartial = TransferSizes.none
          ),
          TLMasterParameters.v1(
            name = "unified_mem_write_client",
            sourceId = write_src_range,
            visibility = Seq(AddressSet(vis_min, vis_mask)),
            supportsProbe = TransferSizes.mincover(
              seq.map(_.anyEmitClaims.putFull) ++seq.map(_.anyEmitClaims.putPartial)),
            supportsGet = TransferSizes.none,
            supportsPutFull = TransferSizes.mincover(seq.map(_.anyEmitClaims.putFull)),
            supportsPutPartial = TransferSizes.mincover(seq.map(_.anyEmitClaims.putPartial))
          )
        )
      )
    },
    managerFn = { seq =>
      // val fifoIdFactory = TLXbar.relabeler()
      seq(0).v1copy(
        responseFields = BundleField.union(seq.flatMap(_.responseFields)),
        requestKeys = seq.flatMap(_.requestKeys).distinct,
        minLatency = seq.map(_.minLatency).min,
        endSinkId = TLXbar.mapOutputIds(seq).map(_.end).max,
        managers = Seq(TLSlaveParameters.v2(
          name = Some(f"unified_mem_manager"),
          address = Seq(AddressSet(gemmini.spad_base, smem_depth * smem_width * smem_banks - 1)),
          supports = TLMasterToSlaveTransferSizes(
            get = TransferSizes(1, smem_width),
            putFull = TransferSizes(1, smem_width),
            putPartial = TransferSizes(1, smem_width)),
          fifoId = Some(0)
        ))
      )
    }
  )

  unified_mem_read_node := TLWidthWidget(spad_data_len) := unified_mem_node
  unified_mem_write_node := TLWidthWidget(spad_data_len) := unified_mem_node

  val stride_by_word = false
  // collection of read and write managers for each sram (sub)bank
  val smem_bank_mgrs : Seq[Seq[TLManagerNode]] = if (stride_by_word) {
    assert(false, "TODO under construction")
    // assert((config.sp_capacity match { case CapacityInKilobytes(kb) => kb * 1024}) ==
    //   gemmini.config.sp_bank_entries * spad_data_len / max_data_len * gemmini.config.sp_banks * max_data_len)
    (0 until gemminiConfig.sp_banks).map { bank =>
      LazyModule(new TLRAM(
        address = AddressSet(max_data_len * bank,
          ((gemminiConfig.sp_bank_entries * spad_data_len / max_data_len - 1) * gemminiConfig.sp_banks + bank)
            * max_data_len + (max_data_len - 1)),
        beatBytes = max_data_len
      ))
    }.map(x => Seq(x.node))
  } else {
    require(isPow2(smem_banks))
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
      ))),
        TLManagerNode(Seq(TLSlavePortParameters.v1(
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

  val smem_r_xbar = TLXbar()
  val smem_w_xbar = TLXbar()
  smem_r_xbar :=* unified_mem_read_node
  smem_w_xbar :=* unified_mem_write_node

  smem_bank_mgrs.foreach { mem =>
    require(mem.length == 2)
    mem.head := smem_r_xbar
    mem.last := TLFragmenter(spad_data_len, max_write_width_bytes) := smem_w_xbar
  }

  // connect tile smem nodes to xbar, and xbar to banks
  // val smem_xbar = TLXbar()
  unified_mem_node :=* TLWidthWidget(4) :=* clbus.outwardNode
  gemminiTile.slaveNode :=* TLWidthWidget(4) :=* clbus.outwardNode
  // printf and perf counter buffer FIXME: make configurable
  TLRAM(AddressSet(x"ff004000", numCores * 0x200 - 1)) := TLFragmenter(4, 4) := clbus.outwardNode

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
    tile.smemNodes.foreach(clbus.inwardNode := _)
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
  def makeSmemBanks: Unit = {
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

      // READ
      mem.io.ren := r_node.a.fire
      mem.io.raddr := (r_node.a.bits.address ^ outer.smem_base.U) >> log2Ceil(mem_width).U

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
      assert(data_pipe_in.valid === data_pipe_in.fire)

      r_node.d.bits := r_edge.AccessAck(
        Mux(r_node.d.valid, metadata_pipe.bits.source, 0.U),
        Mux(r_node.d.valid, metadata_pipe.bits.size, 0.U),
        Mux(!data_pipe.valid, sram_read_backup_reg.bits, data_pipe.bits))
      r_node.d.valid := data_pipe.valid || sram_read_backup_reg.valid
      // r node A is not ready only if D is not ready and both slots filled
      r_node.a.ready := r_node.d.ready && !(data_pipe.valid && sram_read_backup_reg.valid)
      data_pipe.ready := r_node.d.ready
      metadata_pipe.ready := r_node.d.ready

      // WRITE
      mem.io.wen := w_node.a.fire
      mem.io.waddr := (w_node.a.bits.address ^ outer.smem_base.U) >> log2Ceil(mem_width).U
      mem.io.wdata := w_node.a.bits.data
      mem.io.mask := w_node.a.bits.mask.asBools
      w_node.a.ready := w_node.d.ready// && (mem.io.waddr =/= mem.io.raddr)
      w_node.d.valid := w_node.a.valid
      w_node.d.bits := w_edge.AccessAck(w_node.a.bits)
    }
  }

  def connectUnifiedMemNode: Unit = {
    val u_out = outer.unified_mem_node.out
    val u_in = outer.unified_mem_node.in
    assert(u_out.length == 2)
    println(f"gemmini unified memory node has ${u_in.length} incoming client(s)")

    val r_out = u_out.head
    val w_out = u_out.last

    val in_src = TLXbar.mapInputIds(u_in.map(_._2.client))
    val in_src_size = in_src.map(_.end).max
    assert(isPow2(in_src_size)) // should be checked already, but just to be sure

    // arbitrate all reads into one read while assigning source prefix, same for write
    val a_arbiter_in = (u_in zip in_src).map { case ((in_node, _), src_range) =>
      val in_r: DecoupledIO[TLBundleA] =
        WireDefault(0.U.asTypeOf(Decoupled(new TLBundleA(in_node.a.bits.params.copy(
          sourceBits = log2Up(in_src_size) + 1
        )))))
      val in_w: DecoupledIO[TLBundleA] = WireDefault(0.U.asTypeOf(in_r.cloneType))

      val req_is_read = in_node.a.bits.opcode === TLMessages.Get

      (Seq(in_r.bits.user, in_r.bits.address, in_r.bits.opcode, in_r.bits.size,
        in_r.bits.mask, in_r.bits.param, in_r.bits.data)
        zip Seq(in_node.a.bits.user, in_node.a.bits.address, in_node.a.bits.opcode, in_node.a.bits.size,
        in_node.a.bits.mask, in_node.a.bits.param, in_node.a.bits.data))
        .foreach { case (x, y) => x := y }
      in_r.bits.source := in_node.a.bits.source | src_range.start.U | Mux(req_is_read, 0.U, in_src_size.U)
      in_w.bits := in_r.bits

      in_r.valid := in_node.a.valid && req_is_read
      in_w.valid := in_node.a.valid && !req_is_read
      in_node.a.ready := Mux(req_is_read, in_r.ready, in_w.ready)

      (in_r, in_w)
    }
    // we cannot use round robin because it might reorder requests, even from the same client
    val (a_arbiter_in_r_nodes, a_arbiter_in_w_nodes) = a_arbiter_in.unzip
    TLArbiter.lowest(r_out._2, r_out._1.a, a_arbiter_in_r_nodes:_*)
    TLArbiter.lowest(w_out._2, w_out._1.a, a_arbiter_in_w_nodes:_*)

    def trim(id: UInt, size: Int): UInt = if (size <= 1) 0.U else id(log2Ceil(size)-1, 0) // from Xbar
    // for each unified mem node client, arbitrate read/write responses on d channel
    (u_in zip in_src).zipWithIndex.foreach { case (((in_node, in_edge), src_range), i) =>
      // assign d channel back based on source, invalid if source prefix mismatch
      val resp = Seq(r_out._1.d, w_out._1.d)
      val source_match = resp.zipWithIndex.map { case (r, i) =>
        (r.bits.source(r.bits.source.getWidth - 1) === i.U(1.W)) && // MSB indicates read(0)/write(1)
          src_range.contains(trim(r.bits.source, in_src_size))
      }
      val d_arbiter_in = resp.map(r => WireDefault(
        0.U.asTypeOf(Decoupled(new TLBundleD(r.bits.params.copy(
          sourceBits = in_node.d.bits.source.getWidth,
          sizeBits = in_node.d.bits.size.getWidth
        ))))
      ))

      (d_arbiter_in lazyZip resp lazyZip source_match).foreach { case (arb_in, r, sm) =>
        (Seq(arb_in.bits.user, arb_in.bits.opcode, arb_in.bits.data, arb_in.bits.param,
          arb_in.bits.sink, arb_in.bits.denied, arb_in.bits.corrupt)
          zip Seq(r.bits.user, r.bits.opcode, r.bits.data, r.bits.param,
          r.bits.sink, r.bits.denied, r.bits.corrupt))
          .foreach { case (x, y) => x := y }
        arb_in.bits.source := trim(r.bits.source, 1 << in_node.d.bits.source.getWidth) // we can trim b/c isPow2(prefix)
        arb_in.bits.size := trim(r.bits.size, 1 << in_node.d.bits.size.getWidth) // FIXME: check truncation

        arb_in.valid := r.valid && sm
        r.ready := arb_in.ready
      }

      TLArbiter.robin(in_edge, in_node.d, d_arbiter_in:_*)
    }
  }

  makeSmemBanks
  connectUnifiedMemNode

  println(s"======== barrierSlaveNode: ${outer.barrierSlaveNode.in(0)._2.barrierIdBits}")
}
