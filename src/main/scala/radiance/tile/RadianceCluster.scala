// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import chisel3.util._

import org.chipsalliance.cde.config.{Field, Parameters}
import freechips.rocketchip.subsystem._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.diplomacy.{LazyModule, AddressSet, ClockCrossingType}
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

  // HACK: This is a work around the normal bus connecting API by downcasting
  // tile and directly accessing the node inside that is not exposed as a
  // master in HierarchicalElementCrossingParamsLike.
  val tile = leafTiles(0).asInstanceOf[RadianceTile]
  val perSmemPortXbars = Seq.fill(tile.smemNodes.size) { LazyModule(new TLXbar) }

  // Tie corresponding smem ports from every tile into a single port using
  // Xbars so that the number of ports going into the sharedmem do not scale
  // with the number of tiles.
  leafTiles.foreach { case (id, tile: RadianceTile) =>
    (perSmemPortXbars zip tile.smemNodes).foreach {
      case (xbar, node) => xbar.node := node
    }
    // tile.smemNodes.foreach (clbus.inwardNode := _)
  }
  perSmemPortXbars.foreach { clbus.inwardNode := _.node }

  override lazy val module = new RadianceClusterModuleImp(this)
}

class RadianceClusterModuleImp(outer: RadianceCluster) extends ClusterModuleImp(outer) {
  outer.leafTiles.foreach { case (id, tile: RadianceTile) =>
    // println(s"======= RadianceCluster: tile.smemXbar.node.edge = ${tile.smemXbar.node.out.size}")
    println(s"======= RadianceCluster: clbus inward edges = ${outer.clbus.inwardNode.inward.inputs.size}")
    println(s"======= RadianceCluster: clbus name = ${outer.clbus.busName}")
  }

  outer.perSmemPortXbars(0).node.out(0)._2.slave.slaves(0).address.foreach { addrSet =>
    println(s"====== perSmemPortXbars(0).slaves(0).addr: ${addrSet.toString()}")
  }
  outer.perSmemPortXbars(0).node.out(0)._2.master.masters(0).visibility.foreach { addrSet =>
    println(s"====== perSmemPortXbars(0).masters(0).addr: ${addrSet.toString()}")
  }
}
