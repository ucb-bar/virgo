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
import radiance.memory.RWSplitterNode

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

  val splitter_node = RWSplitterNode()

  unified_mem_read_node :=* TLWidthWidget(spad_data_len) :=* gemmini.spad_read_nodes
  unified_mem_write_node :=* TLWidthWidget(spad_data_len) :=* gemmini.spad_write_nodes
  unified_mem_write_node := gemmini.spad.spad_writer.node // this is the dma write node
  // unified_mem_read_node :=* TLWidthWidget(acc_data_len) :=* acc_read_nodes
  // unified_mem_write_node :=* TLWidthWidget(acc_data_len) :=* acc_write_nodes

  // assert(splitter_node.in.map(_._2.slave.slaves.flatMap(_.supports.get)))

  /* address = Seq(AddressSet(gemmini.spad_base, smem_depth * smem_width * smem_banks - 1)),
  supports = TLMasterToSlaveTransferSizes(
    get = TransferSizes(1, smem_width),
    putFull = TransferSizes(1, smem_width),
    putPartial = TransferSizes(1, smem_width)),*/

  unified_mem_read_node := TLWidthWidget(spad_data_len) := splitter_node
  unified_mem_write_node := TLWidthWidget(spad_data_len) := splitter_node

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
  splitter_node :=* TLWidthWidget(4) :=* clbus.outwardNode
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

  makeSmemBanks

  println(s"======== barrierSlaveNode: ${outer.barrierSlaveNode.in(0)._2.barrierIdBits}")
}
