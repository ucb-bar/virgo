// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import org.chipsalliance.cde.config.{Parameters}
import freechips.rocketchip.diplomacy.{SimpleDevice, LazyModule, ClockCrossingType}
import freechips.rocketchip.rocket._
import freechips.rocketchip.tile._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.subsystem.{HierarchicalElementCrossingParamsLike, CanAttachTile}
import freechips.rocketchip.prci.{ClockSinkParameters}
import radiance.memory._

case class FuzzerTileParams(
    core: VortexCoreParams = VortexCoreParams(), // TODO: remove this
    useVxCache: Boolean = false,
    tileId: Int = 0,
) extends InstantiableTileParams[FuzzerTile] {
  def instantiate(crossing: HierarchicalElementCrossingParamsLike, lookup: LookupByHartIdImpl)(
      implicit p: Parameters
  ): FuzzerTile = {
    new FuzzerTile(this, crossing, lookup)
  }
  val clockSinkParams = ClockSinkParameters()
  val blockerCtrlAddr = None
  val icache = None
  val dcache = None
  val btb = None
  val baseName = "radiance_fuzzer_tile"
  val uniqueName = s"${baseName}_$tileId"
}

case class FuzzerTileAttachParams(
  tileParams: FuzzerTileParams,
  crossingParams: HierarchicalElementCrossingParamsLike
) extends CanAttachTile { type TileType = FuzzerTile }

class FuzzerTile private (
    val fuzzerParams: FuzzerTileParams,
    crossing: ClockCrossingType,
    lookup: LookupByHartIdImpl,
    q: Parameters
) extends BaseTile(fuzzerParams, crossing, lookup, q)
    with SinksExternalInterrupts
    with SourcesExternalNotifications {
  def this(
      params: FuzzerTileParams,
      crossing: HierarchicalElementCrossingParamsLike,
      lookup: LookupByHartIdImpl
  )(implicit p: Parameters) =
    this(params, crossing.crossingType, lookup, p)

  val cpuDevice: SimpleDevice = new SimpleDevice("fuzzer", Nil)

  val intOutwardNode = None
  val slaveNode: TLInwardNode = TLIdentityNode()
  val masterNode = visibilityNode
  // val statusNode = BundleBridgeSource(() => new GroundTestStatus)

  require(p(CoalescerKey).isDefined, "FuzzerTile requires coalescer key to be defined")
  val coalParam = p(CoalescerKey).get
  val coalescer = LazyModule(new CoalescingUnit(coalParam))
  val fuzzer = LazyModule(new MemFuzzer(coalParam))

  coalescer.cpuNode :=* TLWidthWidget(4) :=* fuzzer.node
  masterNode :=* coalescer.aggregateNode

  override lazy val module = new FuzzerTileModuleImp(this)
}

class FuzzerTileModuleImp(outer: FuzzerTile) extends BaseTileModuleImp(outer) {
  outer.reportCease(Some(outer.fuzzer.module.io.finished))
}
