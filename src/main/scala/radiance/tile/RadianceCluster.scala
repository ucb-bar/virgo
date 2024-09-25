// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import chisel3.util._
import freechips.rocketchip.diplomacy.AddressSet
import freechips.rocketchip.prci.{ClockCrossingType, ClockSinkParameters}
import freechips.rocketchip.subsystem._
import freechips.rocketchip.tilelink._
import org.chipsalliance.diplomacy.lazymodule._
import midas.targetutils.SynthesizePrintf
import org.chipsalliance.cde.config.Parameters
import radiance.memory._
import radiance.subsystem.{RadianceFrameBufferKey, RadianceSharedMemKey}

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

 // must toSeq here, otherwise Iterable is lazy and will break diplomacy
  val gemminiTiles = leafTiles.values.filter(_.isInstanceOf[GemminiTile]).toSeq.asInstanceOf[Seq[GemminiTile]]
  val radianceTiles = leafTiles.values.filter(_.isInstanceOf[RadianceTile]).toSeq.asInstanceOf[Seq[RadianceTile]]

  // TODO: this probably needs to be instantiated inside the radiance shared mem module
  val virgoSharedMemComponents = new VirgoSharedMemComponents(thisClusterParams, gemminiTiles, radianceTiles)
  val sharedMemSystem = LazyModule(new RadianceSharedMem(virgoSharedMemComponents, clbus))

  val numCoresInCluster = leafTiles.size - gemminiTiles.size

  val smemKey = p(RadianceSharedMemKey).get
  val wordSize = smemKey.wordSize
  val smemBase = smemKey.address
  val smemBanks = smemKey.numBanks
  val smemWidth = smemKey.numWords * smemKey.wordSize
  val smemDepth = smemKey.size / smemWidth / smemBanks
  val smemSize = smemWidth * smemDepth * smemBanks

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
  TLRAM(AddressSet(smemBase + smemSize, numCoresInCluster * 0x200 - 1)) := traceTLNode :=
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
}
