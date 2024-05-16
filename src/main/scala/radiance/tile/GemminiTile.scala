// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import chisel3.util._
import chisel3.experimental.BundleLiterals._
import freechips.rocketchip.diplomacy.{BigIntHexContext, ClockCrossingType, DisableMonitors, LazyModule, SimpleDevice}
import freechips.rocketchip.prci.ClockSinkParameters
import freechips.rocketchip.rocket._
import freechips.rocketchip.subsystem.{CanAttachTile, HierarchicalElementCrossingParamsLike, RocketCrossingParams}
import freechips.rocketchip.tile._
import freechips.rocketchip.tilelink._
import gemmini._
import org.chipsalliance.cde.config.Parameters
import radiance.subsystem.{GPUMemParams, GPUMemory}

case class GemminiCoreParams(
  useVM: Boolean = false,
  useHypervisor: Boolean = false,
  useUser: Boolean = false,
  useSupervisor: Boolean = false,
  useDebug: Boolean = false,
  useAtomics: Boolean = false,
  useAtomicsOnlyForIO: Boolean = false,
  useCompressed: Boolean = false,
  useRVE: Boolean = false,
  mulDiv: Option[MulDivParams] = None,
  fpu: Option[FPUParams] = None,
  fetchWidth: Int = 1,
  decodeWidth: Int = 1,
  retireWidth: Int = 1,
  instBits: Int = 0,
  nLocalInterrupts: Int = 0,
  nPMPs: Int = 0,
  nBreakpoints: Int = 0,
  useBPWatch: Boolean = false,
  nPerfCounters: Int = 0,
  haveBasicCounters: Boolean = false,
  haveFSDirty: Boolean = false,
  misaWritable: Boolean = false,
  haveCFlush: Boolean = false,
  nL2TLBEntries: Int = 0,
  mtvecInit: Option[BigInt] = Some(BigInt(0)),
  mtvecWritable: Boolean = false,
  nL2TLBWays: Int = 0,
  lrscCycles: Int = 8,
  mcontextWidth: Int = 0,
  scontextWidth: Int = 0,
  useNMI: Boolean = false,
  nPTECacheEntries: Int = 0,
  traceHasWdata: Boolean = false,
  useConditionalZero: Boolean = false,
  bootFreqHz: BigInt = 0,
  pmpGranularity: Int = 0) extends CoreParams {
}

case class GemminiTileParams(
    tileId: Int = 0,
    gemminiConfig: GemminiArrayConfig[Float, Float, Float]
) extends InstantiableTileParams[GemminiTile] {
  def instantiate(crossing: HierarchicalElementCrossingParamsLike, lookup: LookupByHartIdImpl)(
      implicit p: Parameters
  ): GemminiTile = {
    new GemminiTile(this, crossing, lookup)
  }
  val core = GemminiCoreParams()
  val name = Some("radiance_gemmini_tile")
  val clockSinkParams = ClockSinkParameters()
  val blockerCtrlAddr = None
  val icache = None
  val dcache = Some(DCacheParams(
    nSets = 1, nWays = 1, nMSHRs = 0,
    nTLBSets = 0, nTLBWays = 1
  ))
  val btb = None
  val baseName = name.get
  val uniqueName = s"${baseName}_$tileId"
}

case class GemminiTileAttachParams(
  tileParams: GemminiTileParams,
  crossingParams: RocketCrossingParams,
) extends CanAttachTile { type TileType = GemminiTile }

class GemminiTile private (
    val gemminiParams: GemminiTileParams,
    crossing: ClockCrossingType,
    lookup: LookupByHartIdImpl,
    q: Parameters
) extends BaseTile(gemminiParams, crossing, lookup, q)
    with SinksExternalInterrupts
    with SourcesExternalNotifications {

  def this(params: GemminiTileParams, crossing: HierarchicalElementCrossingParamsLike,
      lookup: LookupByHartIdImpl)(implicit p: Parameters) =
    this(params, crossing.crossingType, lookup, p)

  val cpuDevice: SimpleDevice = new SimpleDevice("gemmini", Nil)

  val intOutwardNode = None
  val slaveNode = TLIdentityNode()
  val masterNode = visibilityNode
  // val statusNode = BundleBridgeSource(() => new GroundTestStatus)

  val accSlaveNode = AccSlaveNode()

  tlOtherMastersNode := tlMasterXbar.node
  masterNode :=* tlOtherMastersNode
  DisableMonitors { implicit p => tlSlaveXbar.node :*= slaveNode }

  // TODO: evaluate if gemmini write node is required at all
  val gemmini = LazyModule(new Gemmini(gemminiParams.gemminiConfig))
  val base = p(GPUMemory()) match {
    case Some(GPUMemParams(baseAddr, _)) => baseAddr
    case _ => BigInt(0)
  }
  // tlMasterXbar.node :=* AddressOrNode(base) :=* gemmini.atlNode
  // tlOtherMastersNode :=* AddressOrNode(base) :=* gemmini.tlNode
  tlMasterXbar.node :=* gemmini.atlNode
  tlOtherMastersNode :=* gemmini.tlNode
  gemmini.stlNode := tlSlaveXbar.node

  require(!gemmini.config.sp_singleported, "external scratchpad must be dual ported")

  override lazy val module = new GemminiTileModuleImp(this)
}

class GemminiTileModuleImp(outer: GemminiTile) extends BaseTileModuleImp(outer) {

  def tieOffGemminiRocc: Unit = {
    val gemmini_io = outer.gemmini.module.io
    gemmini_io.ptw <> DontCare
    gemmini_io.mem <> DontCare
    gemmini_io.resp <> DontCare
    gemmini_io.fpu_req.ready := false.B
    gemmini_io.fpu_resp.valid := false.B
    gemmini_io.fpu_resp.bits := DontCare
    gemmini_io.exception := DontCare
  }

  tieOffGemminiRocc

  val accSlave = outer.accSlaveNode.in.head._1

  val instCounter = Counter(4)
  val ciscValid = RegInit(false.B)
  val ciscArgs = RegInit(0.U(24.W))
  val ciscId = RegInit(0.U(8.W))
  val ciscInstT = new Bundle {
    val inst = UInt(32.W)
    val rs1 = UInt(64.W)
    val rs2 = UInt(64.W)
  }
  val ciscInst = Wire(ciscInstT)

  when (accSlave.cmd.valid) {
    ciscValid := true.B
    ciscId := accSlave.cmd.bits(7, 0)
    ciscArgs := accSlave.cmd.bits(31, 8)
    instCounter.reset()
  }

  def microcodeEntry[T <: Data](insts: Seq[T]): T = {
    when (instCounter.value === (insts.size - 1).U) {
      ciscValid := false.B
      instCounter.reset()
    }.otherwise {
      instCounter.inc()
    }
    VecInit(insts)(instCounter.value)
  }

  ciscInst := 0.U.asTypeOf(ciscInstT)
  // val boundsInst = ciscInstT.Lit(_.inst -> 0x1220b07b.U, _.rs1 -> 0.U, _.rs2 -> x"4_00040004".U)
  // val spadQuartile = 0x80
  val boundsInst = ciscInstT.Lit(_.inst -> 0x1220b07b.U, _.rs1 -> 0.U, _.rs2 -> x"8_00080008".U)
  val spadQuartile = 0x200
  when (ciscValid) {
    assert(!accSlave.cmd.valid, "cisc state machine already busy")
    switch (ciscId) {
      is (0.U) {
        ciscInst := microcodeEntry(Seq(
          ciscInstT.Lit(_.inst -> 0x1220b07b.U, _.rs1 -> 0.U, _.rs2 -> x"8_00080008".U), // set I, J, K
          ciscInstT.Lit(_.inst -> 0x3020b07b.U, _.rs1 -> 0.U, _.rs2 -> 0x600.U),           // set A, B address
          ciscInstT.Lit(_.inst -> 0x1020b07b.U, _.rs1 -> 0.U, _.rs2 -> x"0_000002b8".U) // set skip, acc
        ))
      }
      is (2.U) {
        ciscInst := microcodeEntry(Seq(boundsInst,
          ciscInstT.Lit(_.inst -> 0x3020b07b.U, _.rs1 -> (spadQuartile * 1).U, _.rs2 -> (spadQuartile * 4).U),
          ciscInstT.Lit(_.inst -> 0x1020b07b.U, _.rs1 -> 0x1.U, _.rs2 -> x"0_000002b8".U)
        ))
      }
      is (1.U) {
        ciscInst := microcodeEntry(Seq(boundsInst,
          ciscInstT.Lit(_.inst -> 0x3020b07b.U, _.rs1 -> 0.U, _.rs2 -> (spadQuartile * 3).U),
          ciscInstT.Lit(_.inst -> 0x1020b07b.U, _.rs1 -> 0x1.U, _.rs2 -> x"0_000002b8".U)
        ))
      }
      is (8.U) {
        val inst = Wire(ciscInstT)
        inst.inst := 0x1820b07b.U
        inst.rs1 := ciscArgs(7, 0)
        inst.rs2 := ciscArgs(15, 8)
        ciscInst := microcodeEntry(Seq(inst))
      }
      is (9.U) {
        ciscInst := microcodeEntry(Seq(boundsInst,
          ciscInstT.Lit(_.inst -> 0x1020b07b.U, _.rs1 -> 0.U, _.rs2 -> 0x278.U),
        ))
      }
      is (10.U) {
        ciscInst := microcodeEntry(Seq(boundsInst,
          ciscInstT.Lit(_.inst -> 0x3020b07b.U, _.rs1 -> 0.U, _.rs2 -> (spadQuartile * 3).U),
          ciscInstT.Lit(_.inst -> 0x1020b07b.U, _.rs1 -> 0x1.U, _.rs2 -> x"0_000002e0".U)
        ))
      }
      is (11.U) {
        ciscInst := microcodeEntry(Seq(boundsInst,
          ciscInstT.Lit(_.inst -> 0x3020b07b.U, _.rs1 -> (spadQuartile * 1).U, _.rs2 -> (spadQuartile * 4).U),
          ciscInstT.Lit(_.inst -> 0x1020b07b.U, _.rs1 -> 0x1.U, _.rs2 -> x"0_000002e0".U)
        ))
      }
      is (16.U) {
        ciscInst := microcodeEntry(Seq(
          ciscInstT.Lit(_.inst -> 0x0020b07b.U, _.rs1 -> x"3f800000_00080101".U, _.rs2 -> 0.U),
          ciscInstT.Lit(_.inst -> 0x0020b07b.U, _.rs1 -> x"3f800000_00010004".U, _.rs2 -> x"10000_00000000".U),
          ciscInstT.Lit(_.inst -> 0x0020b07b.U, _.rs1 -> 0x2.U, _.rs2 -> x"3f800000_00000000".U)
        ))
      }
    }
  }

  val gemminiIO = outer.gemmini.module.io.cmd
  gemminiIO.bits.status := 0.U.asTypeOf(gemminiIO.bits.status)
  gemminiIO.bits.inst := ciscInst.inst.asTypeOf(gemminiIO.bits.inst)
  gemminiIO.bits.rs1 := ciscInst.rs1
  gemminiIO.bits.rs2 := ciscInst.rs2
  gemminiIO.valid := ciscValid
  assert(gemminiIO.ready || !gemminiIO.valid)

  accSlave.status := RegNext(outer.gemmini.module.io.busy).asUInt

  outer.traceSourceNode.bundle := DontCare
  outer.traceSourceNode.bundle.insns foreach (_.valid := false.B)

  // hacky, but cluster will AND the cease signals from all tiles, and we want
  // the core tiles to determine cluster cease not Gemmini
  outer.reportCease(Some(true.B))
}
