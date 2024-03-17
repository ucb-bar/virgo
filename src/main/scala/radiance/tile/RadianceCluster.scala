// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import chisel3.experimental.SourceInfo
import chisel3.util._

import org.chipsalliance.cde.config.{Field, Parameters}
import freechips.rocketchip.subsystem._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper.RegField
import freechips.rocketchip.prci.ClockSinkParameters

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
  val numLsuLanes = 4 // FIXME: hardcoded
  val wordSize = 4
  val smemBanks = Seq.tabulate(numLsuLanes) { bankId =>
    // Banked-by-word (4 bytes)
    // base for bank 1: ff...000000|01|00
    // mask for bank 1; 00...111111|00|11
    val base = 0xff000000L | (bankId * wordSize)
    val mask = 0x00001fffL ^ ((numLsuLanes - 1) * wordSize)
    LazyModule(new TLRAM(AddressSet(base, mask), beatBytes = wordSize))
  }
  smemBanks.foreach(_.node := clbus.outwardNode)

  val numCores = leafTiles.size

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
  leafTiles.foreach { case (id, tile: RadianceTile) =>
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
    address = Seq(AddressSet(0xff003f00L, 0xff)),
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
  outer.leafTiles.foreach { case (id, tile: RadianceTile) =>
    // println(s"======= RadianceCluster: tile.smemXbar.node.edge = ${tile.smemXbar.node.out.size}")
    println(s"======= RadianceCluster: clbus inward edges = ${outer.clbus.inwardNode.inward.inputs.length}")
    println(s"======= RadianceCluster: clbus name = ${outer.clbus.busName}")
  }

  outer.barrierSlaveNode.in.foreach { case (b, e) =>
    b.req.ready := true.B // barrier module is always ready
    b.resp.valid := 0.U
    b.resp.bits.barrierId := 0.U
  }

  auto.elements.foreach({case (name, _) =>
      println(s"======= RadianceCluster.elements.name: ${name}")
  })

  val numCores = outer.leafTiles.size
  val numBarriers = 4 // FIXME: hardcoded
  val allSyncedRegs = Seq.fill(numBarriers)(Wire(UInt(32.W)))
  val perCoreSyncedRegs = Seq.fill(numBarriers)(Seq.fill(numCores)(RegInit(0.U(32.W))))
  (allSyncedRegs zip perCoreSyncedRegs).foreach{ case (all, per) =>
    all := per.reduce((x0, x1) => (x0 =/= 0.U) && (x1 =/= 0.U))

    val allPassed = per.map(_ === 2.U).reduce(_ && _)
    when(allPassed) {
      per.foreach(_ := 0.U)
    }

    dontTouch(all)
  }
  // FIXME: 4 cores per cluster hardcoded
  outer.regNode.regmap(
    0x00 -> Seq(RegField.r(32, allSyncedRegs(0))),
    0x04 -> Seq(RegField(32, perCoreSyncedRegs(0)(0))),
    0x08 -> Seq(RegField(32, perCoreSyncedRegs(0)(1))),
    0x10 -> Seq(RegField.r(32, allSyncedRegs(1))),
    0x14 -> Seq(RegField(32, perCoreSyncedRegs(1)(0))),
    0x18 -> Seq(RegField(32, perCoreSyncedRegs(1)(1))),
    0x20 -> Seq(RegField.r(32, allSyncedRegs(2))),
    0x24 -> Seq(RegField(32, perCoreSyncedRegs(2)(0))),
    0x28 -> Seq(RegField(32, perCoreSyncedRegs(2)(1))),
    0x30 -> Seq(RegField.r(32, allSyncedRegs(3))),
    0x34 -> Seq(RegField(32, perCoreSyncedRegs(3)(0))),
    0x38 -> Seq(RegField(32, perCoreSyncedRegs(3)(1))),
  )

  println(s"======== barrierSlaveNode: ${outer.barrierSlaveNode.in(0)._2.barrierIdBits}")
}

case class EmptyParams()

case class BarrierParams(
  barrierIdBits: Int,
  numCoreBits: Int
)

class BarrierRequestBits(
  param: BarrierParams
) extends Bundle {
  val barrierId = UInt(param.barrierIdBits.W)
  val sizeMinusOne = UInt(param.numCoreBits.W)
  val coreId = UInt(param.numCoreBits.W)
}

class BarrierResponseBits(
  param: BarrierParams
) extends Bundle {
  val barrierId = UInt(param.barrierIdBits.W)
}

class BarrierBundle(param: BarrierParams) extends Bundle {
  val req = Decoupled(new BarrierRequestBits(param))
  val resp = Flipped(Decoupled(new BarrierResponseBits(param)))
}

// FIXME Separate BarrierEdgeParams from BarrierParams
object BarrierNodeImp extends SimpleNodeImp[BarrierParams, EmptyParams, BarrierParams, BarrierBundle] {
  def edge(pd: BarrierParams, pu: EmptyParams, p: Parameters, sourceInfo: SourceInfo) = {
    // barrier parameters flow strictly downward from the master node
    pd
  }
  def bundle(e: BarrierParams) = new BarrierBundle(e)
  // FIXME render
  def render(e: BarrierParams) = RenderedEdge(colour = "ffffff", label = "X")
}

case class BarrierMasterNode(val srcParams: BarrierParams)(implicit valName: ValName)
    extends SourceNode(BarrierNodeImp)(Seq(srcParams))
case class BarrierSlaveNode(val numEdges: Int)(implicit valName: ValName)
    extends SinkNode(BarrierNodeImp)(Seq.fill(numEdges)(EmptyParams()))
