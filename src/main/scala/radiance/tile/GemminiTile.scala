// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import freechips.rocketchip.diplomacy.{ClockCrossingType, DisableMonitors, LazyModule, SimpleDevice}
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
    gemmini_io.cmd <> DontCare
    gemmini_io.cmd.valid := false.B
    gemmini_io.resp <> DontCare
    gemmini_io.fpu_req.ready := false.B
    gemmini_io.fpu_resp.valid := false.B
    gemmini_io.fpu_resp.bits := DontCare
    gemmini_io.exception := DontCare
  }

  tieOffGemminiRocc

  // hacky, but cluster will AND the cease signals from all tiles, and we want
  // the core tiles to determine cluster cease not Gemmini
  outer.reportCease(Some(true.B))
}
