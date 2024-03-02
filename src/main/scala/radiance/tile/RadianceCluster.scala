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

  val numLsuLanes = 4
  val wordSize = 4
  val smemBanks = Seq.tabulate(numLsuLanes) { bankId =>
    // Banked-by-word (4 bytes)
    // base for bank 1: ff...000000|01|00
    // mask for bank 1; 00...111111|00|11
    // val base = 0xff000000L | (bankId * 4 /*wordSize*/ )
    // val mask = 0x00001fffL ^ ((numLsuLanes - 1) * 4 /*wordSize*/ )
    val base = 0xff000000L | (bankId * wordSize)
    val mask = 0x00ffffffL ^ ((numLsuLanes - 1) * wordSize)
    LazyModule(new TLRAM(AddressSet(base, mask), beatBytes = wordSize))
  }
  smemBanks.foreach(_.node := clbus.outwardNode)

  println(s"===== Cluster: nTotalTiles = ${nTotalTiles}")
  println(s"===== Cluster: nLeafTiles = ${nLeafTiles}")

  leafTiles.map { case (id, tile: RadianceTile) =>
    println(s"======= RadianceCluster: connecting cluster ${id} to clbus")
    clbus.inwardNode :=* tile.smemXbar.node
    // clbus.inwardNode :=* tile.smemNodes(0)
  }
}
