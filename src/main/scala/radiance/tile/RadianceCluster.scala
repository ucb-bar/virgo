// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import chisel3.util._
import freechips.rocketchip.diplomacy.{AddressSet, BufferParams, TransferSizes}
import freechips.rocketchip.prci.{ClockCrossingType, ClockSinkParameters}
import freechips.rocketchip.resources.BigIntHexContext
import freechips.rocketchip.subsystem._
import freechips.rocketchip.tilelink._
import org.chipsalliance.diplomacy.lazymodule._
import gemmini._
import midas.targetutils.SynthesizePrintf
import org.chipsalliance.cde.config.Parameters
import org.chipsalliance.diplomacy.{DisableMonitors, ValName}
import radiance.memory._
import radiance.subsystem.{RadianceFrameBufferKey, RadianceSharedMemKey}

import scala.collection.mutable.ArrayBuffer

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
  // val numLsuLanes = 4 // FIXME: hardcoded

 // must toSeq here, otherwise Iterable is lazy and will break diplomacy
  val gemminiTiles = leafTiles.values.filter(_.isInstanceOf[GemminiTile]).toSeq.asInstanceOf[Seq[GemminiTile]]
  val gemminis = gemminiTiles.map(_.gemmini)
  val gemminiConfigs = gemminis.map(_.config)

  if (gemminiConfigs.length > 1) {
    if (!(gemminiConfigs.tail.map(_.inputType == gemminiConfigs.head.inputType).reduce(_ && _))) {
      println("******** WARNING ********\n******** gemmini data types do not match\n******** WARNING ********")
    }
  }

  val radianceTiles = leafTiles.values.filter(_.isInstanceOf[RadianceTile]).toSeq.asInstanceOf[Seq[RadianceTile]]

  val numCoresInCluster = leafTiles.size - gemminis.size

  // **************************************
  //    ______  _________  ___
  //   / __/  |/  / __/  |/  /
  //  _\ \/ /|_/ / _// /|_/ /
  // /___/_/  /_/___/_/  /_/
  //
  // **************************************
  val unifiedMemReadNode = TLIdentityNode()
  val unifiedMemWriteNode = TLIdentityNode()

  val smemKey = p(RadianceSharedMemKey).get
  val wordSize = smemKey.wordSize
  val smemBase = smemKey.address
  val smemBanks = smemKey.numBanks
  val smemWidth = smemKey.numWords * smemKey.wordSize
  val smemDepth = smemKey.size / smemWidth / smemBanks
  val smemSubbanks = smemWidth / wordSize
  val smemSize = smemWidth * smemDepth * smemBanks

  gemminiConfigs.foreach { config =>
    assert(smemBanks == config.sp_banks && isPow2(smemBanks / config.sp_banks)) // TODO: should allow >=
    assert(smemWidth >= (config.sp_width / 8) && isPow2(smemWidth / (config.sp_width / 8)))
    assert(smemSize == config.sp_capacity.asInstanceOf[CapacityInKilobytes].kilobytes * 1024)
  }

  val strideByWord = true
  val filterAligned = true
  val disableMonitors = true // otherwise it generate 1k+ different tl monitors
  val serializeUnaligned = true

  def guardMonitors[T](callback: Parameters => T)(implicit p: Parameters): Unit = {
    if (disableMonitors) {
      DisableMonitors { callback }
    } else {
      callback(p)
    }
  }
  def connectOne[T <: TLNode](from: TLNode, to: () => T): T = {
    val t = to()
    guardMonitors { implicit p => t := from }
    t
  }
  def connectXbarName(from: TLNode, name: Option[String] = None,
                        policy: TLArbiter.Policy = TLArbiter.roundRobin): TLNexusNode = {
    val t = LazyModule(new TLXbar(policy))
    name.map(t.suggestName)
    guardMonitors { implicit p => t.node := from }
    t.node
  }
  def connectXbar(from: TLNode): TLNexusNode = {
    connectXbarName(from, None)
  }

  val radianceSmemFanout = radianceTiles.zipWithIndex.flatMap { case (tile, cid) =>
    tile.smemNodes.zipWithIndex.map { case (m, lid) =>
      val smemFanoutXbar = LazyModule(new TLXbar())
      smemFanoutXbar.suggestName(f"rad_smem_fanout_cl${thisClusterParams.clusterId}_c${cid}_l${lid}_xbar")
      smemFanoutXbar.node :=* m
      smemFanoutXbar.node
    }
  }

  require(isPow2(smemBanks))
  // collection of read and write managers for each sram (sub)bank
  val smemBankMgrs : Seq[Seq[TLManagerNode]] = if (strideByWord) {
    require(isPow2(smemSubbanks))
    (0 until smemBanks).flatMap { bid =>
      (0 until smemSubbanks).map { wid =>
        Seq(TLManagerNode(Seq(TLSlavePortParameters.v1(
          managers = Seq(TLSlaveParameters.v2(
            name = Some(f"sp_bank${bid}_word${wid}_read_mgr"),
            address = Seq(AddressSet(
              smemBase + (smemDepth * smemWidth * bid) + wordSize * wid,
              smemDepth * smemWidth - smemWidth + wordSize - 1
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
              smemBase + (smemDepth * smemWidth * bid) + wordSize * wid,
              smemDepth * smemWidth - smemWidth + wordSize - 1
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
    (0 until smemBanks).map { bank =>
      Seq(TLManagerNode(Seq(TLSlavePortParameters.v1(
        managers = Seq(TLSlaveParameters.v2(
          name = Some(f"sp_bank${bank}_read_mgr"),
          address = Seq(AddressSet(smemBase + (smemDepth * smemWidth * bank),
            smemDepth * smemWidth - 1)),
          supports = TLMasterToSlaveTransferSizes(
            get = TransferSizes(1, smemWidth)),
          fifoId = Some(0)
        )),
        beatBytes = smemWidth
      ))
      ), TLManagerNode(Seq(TLSlavePortParameters.v1(
        managers = Seq(TLSlaveParameters.v2(
          name = Some(f"sp_bank${bank}_write_mgr"),
          address = Seq(AddressSet(smemBase + (smemDepth * smemWidth * bank),
            smemDepth * smemWidth - 1)),
          supports = TLMasterToSlaveTransferSizes(
            putFull = TransferSizes(1, smemWidth),
            putPartial = TransferSizes(1, smemWidth)),
          fifoId = Some(0)
        )),
        beatBytes = smemWidth
      ))))
    }
  }

  val uniformPolicyNodes: Seq[ArrayBuffer[ArrayBuffer[ExtPolicyMasterNode]]] = // mutable
    Seq.fill(2)(ArrayBuffer.fill(smemBanks)(ArrayBuffer.fill(smemSubbanks)(null)))
  val uniformNodesIn: Seq[ArrayBuffer[ArrayBuffer[Seq[TLIdentityNode]]]] =
    Seq.fill(2)(ArrayBuffer.fill(smemBanks)(ArrayBuffer.fill(smemSubbanks)(Seq())))
  val uniformNodesOut: Seq[ArrayBuffer[ArrayBuffer[TLIdentityNode]]] =
    Seq.fill(2)(ArrayBuffer.fill(smemBanks)(ArrayBuffer.fill(smemSubbanks)(null)))

  val (uniformRNodes, uniformWNodes, _, _) =

  if (strideByWord) {
    def distAndDuplicate(nodes: Seq[TLNode], suffix: String): Seq[Seq[TLNexusNode]] = {
      val wordFanoutNodes = gemminis.zip(nodes).zipWithIndex.map { case ((gemmini, node), gemminiIdx) =>
        val spWidthBytes = gemmini.config.sp_width / 8
        val spSubbanks = spWidthBytes / wordSize
        val dist = DistributorNode(from = spWidthBytes, to = wordSize)
        guardMonitors { implicit p =>
          dist := node
        }
        val fanout = Seq.tabulate(spSubbanks) { w =>
          val buf = TLBuffer(BufferParams(1, false, true), BufferParams(0))
          buf := dist
          connectXbarName(buf, Some(s"spad_g${gemminiIdx}w${w}_fanout_$suffix"))
        }
        Seq.fill(smemWidth / spWidthBytes)(fanout).flatten // smem wider than spad, duplicate masters
      }
      // (gemmini, word) => (word, gemmini)
      wordFanoutNodes.transpose
    }

    // (banks, subbanks, gemminis)
    val spadReadNodes = Seq.fill(smemBanks)(distAndDuplicate(gemminis.map(_.spad_read_nodes), "r"))
    val spadWriteNodes = Seq.fill(smemBanks)(distAndDuplicate(gemminis.map(_.spad_write_nodes), "w"))
    val spadSpWriteNodesSingleBank = distAndDuplicate(gemminis.map(_.spad.spad_writer.node), "ws")
    val spadSpWriteNodes = Seq.fill(smemBanks)(spadSpWriteNodesSingleBank) // executed only once

    val (uniformRNodes, uniformWNodes, nonuniformRNodes, nonuniformWNodes):
      (Seq[Seq[Seq[TLNexusNode]]], Seq[Seq[Seq[TLNexusNode]]], Seq[TLNode], Seq[TLNode]) = if (filterAligned) {

      val numLsuLanes = radianceTiles.head.numLsuLanes
      val numLaneDupes = Math.max(1, smemSubbanks / numLsuLanes)
      val filterRange = Math.min(smemSubbanks, numLsuLanes)
      println(s"num_lsu_lanes ${numLsuLanes} num_lane_dupes ${numLaneDupes} filter_range ${filterRange}")

      // (subbank, sources, aligned) = rw node
      val (fAligned, fUnaligned) = if (numLsuLanes >= smemSubbanks) {
        val filterNodes: Seq[Seq[(TLNode, TLNode)]] = Seq.tabulate(numLaneDupes) { did =>
          Seq.tabulate(filterRange) { wid =>
            val trueWid = did * filterRange + wid
            val address = AddressSet(smemBase + wordSize * trueWid, (smemSize - 1) - (smemSubbanks - 1) * wordSize)

            radianceSmemFanout.grouped(numLsuLanes).toList.zipWithIndex.flatMap { case (lanes, cid) =>
              lanes.zipWithIndex.flatMap { case (lane, lid) =>
                if ((lid % filterRange) == wid) {
                  println(f"c${cid}_l${lid} connected to d${did}w${wid}")
                  val filterNode = AlignFilterNode(Seq(address))(p, ValName(s"filter_l${lid}_w${trueWid}"), info)
                  DisableMonitors { implicit p => filterNode := lane }
                  // Seq((aligned splitter, unaligned splitter))
                  Seq((
                    connectOne(filterNode, () =>
                      RWSplitterNode(address, s"aligned_splitter_c${cid}_l${lid}_w${trueWid}")),
                    connectOne(filterNode, () =>
                      RWSplitterNode(AddressSet.everything, s"unaligned_splitter_c${cid}_l${lid}"))
                  ))
                } else Seq()
              }
            }
          }
        }.flatten

        val fAligned = Seq.fill(2)(filterNodes.map(_.map(_._1).map(connectXbarName(_, Some("rad_aligned")))))
        val fUnaligned = if (serializeUnaligned) {
          Seq.fill(2) {
            val serializedNode = TLEphemeralNode()
            val serializedInXbar = LazyModule(new TLXbar())
            val serializedOutXbar = LazyModule(new TLXbar())
            serializedInXbar.suggestName("unaligned_serialized_in_xbar")
            serializedOutXbar.suggestName("unaligned_serialized_out_xbar")
            guardMonitors { implicit p =>
              filterNodes.foreach(_.map(_._2).foreach(serializedInXbar.node := _))
              serializedNode := serializedInXbar.node
              serializedOutXbar.node := serializedNode
            }
            Seq(serializedOutXbar.node)
          }
        } else {
          Seq.fill(2)(filterNodes.flatMap(_.map(_._2).map(connectXbar)))
        }
        (fAligned, fUnaligned)
      } else { // aligned: (subbanks, cores) = rw node
        // (lanes, cores) = filter_node
        val filterNodes = Seq.tabulate(filterRange) { wid =>
          val addresses = Seq.tabulate(numLaneDupes) { did =>
            AddressSet(smemBase + (did * filterRange + wid) * wordSize,
              (smemSize - 1) - (smemSubbanks - 1) * wordSize)
          }
          radianceSmemFanout.grouped(numLsuLanes).toSeq.zipWithIndex.map { case (lanes, cid) =>
            val lane = lanes(wid)
            val filterNode = AlignFilterNode(addresses)(p, ValName(s"filter_c${cid}_w${wid}"), info)
            guardMonitors { implicit p =>
              filterNode := lane
            }
            filterNode
          }
        }
        val fAlignedRw = Seq.tabulate(numLaneDupes) { did =>
          filterNodes.zipWithIndex.map { case (cores, lid) =>
            cores.zipWithIndex.map { case (fn, cid) =>
              val address = AddressSet(smemBase + (did * filterRange + lid) * wordSize,
                (smemSize - 1) - (smemSubbanks - 1) * wordSize)
              connectOne(fn, () => RWSplitterNode(address, s"aligned_split_c${cid}_l${lid}_d${did}"))
            }
          }
        }.flatten
        val fUnalignedRw = filterNodes.zipWithIndex.flatMap { case (cores, lid) =>
          cores.zipWithIndex.map { case (fn, cid) =>
            connectOne(fn, () => RWSplitterNode(AddressSet.everything, s"unaligned_split_c${cid}_l${lid}"))
          }
        }
        val fAligned = Seq.fill(2)(fAlignedRw.map(_.map(connectXbarName(_, Some("rad_aligned")))))

        val fUnaligned = if (serializeUnaligned) {
          Seq.fill(2) {
            val serializedNode = TLEphemeralNode()
            val serializedInXbar = TLXbar(nameSuffix = Some("unaligned_ser_in"))
            val serializedOutXbar = TLXbar(nameSuffix = Some("unaligned_ser_out"))
            guardMonitors { implicit p =>
              fUnalignedRw.foreach(serializedInXbar := _)
              serializedNode := serializedInXbar
              serializedOutXbar := serializedNode
            }
            Seq(serializedOutXbar)
          }
        } else {
          Seq.fill(2)(fUnalignedRw.map(connectXbar))
        }
        (fAligned, fUnaligned)
      }


      val uniformRNodes: Seq[Seq[Seq[TLNexusNode]]] = spadReadNodes.map { rb =>
        (rb zip fAligned.head).map { case (rw, fa) => rw ++ fa }
      }
      val uniformWNodes: Seq[Seq[Seq[TLNexusNode]]] = (spadWriteNodes zip spadSpWriteNodes).map { case (wb, wsb) =>
        (wb lazyZip wsb lazyZip fAligned.last).map {
          case (ww, wsw, fa) => ww ++ wsw ++ fa
        }
      }

      // all to all xbar
      val Seq(nonuniformRNodes, nonuniformWNodes) = fUnaligned

      (uniformRNodes, uniformWNodes, nonuniformRNodes, nonuniformWNodes)
    } else {
      val splitterNodes = radianceSmemFanout.map { connectOne(_, RWSplitterNode.apply) }
      // these nodes access an entire line simultaneously
      val uniformRNodes: Seq[Seq[Seq[TLNexusNode]]] = spadReadNodes
      val uniformWNodes: Seq[Seq[Seq[TLNexusNode]]] = (spadWriteNodes zip spadSpWriteNodes).map { case (wb, wsb) =>
        (wb zip wsb).map { case (ww, wsw) => ww ++ wsw }
      }
      // these nodes are random access
      val nonuniformRNodes: Seq[TLNode] = splitterNodes.map(connectXbarName(_, Some("rad_unaligned_r")))
      val nonuniformWNodes: Seq[TLNode] = splitterNodes.map(connectXbarName(_, Some("rad_unaligned_w")))

      (uniformRNodes, uniformWNodes, nonuniformRNodes, nonuniformWNodes)
    }

    guardMonitors { implicit p => radianceSmemFanout.foreach(clbus.inwardNode := _) }

    smemBankMgrs.grouped(smemSubbanks).zipWithIndex.foreach { case (bankMgrs, bid) =>
      bankMgrs.zipWithIndex.foreach { case (Seq(r, w), wid) =>
        // TODO: this should be a coordinated round robin
        val subbankRXbar = LazyModule(new TLXbar(TLArbiter.lowestIndexFirst))
        val subbankWXbar = LazyModule(new TLXbar(TLArbiter.lowestIndexFirst))
        subbankRXbar.suggestName(s"smem_b${bid}_w${wid}_r_xbar")
        subbankWXbar.suggestName(s"smem_b${bid}_w${wid}_w_xbar")

        guardMonitors { implicit p =>
          r := subbankRXbar.node
          w := subbankWXbar.node

          val urXbar = XbarWithExtPolicy(Some(s"ur_b${bid}_w${wid}"))
          val uwXbar = XbarWithExtPolicy(Some(s"uw_b${bid}_w${wid}"))
          val rPolicyNode = ExtPolicyMasterNode(uniformRNodes(bid)(wid).length)
          val wPolicyNode = ExtPolicyMasterNode(uniformWNodes(bid)(wid).length)
          urXbar.policySlaveNode := rPolicyNode
          uwXbar.policySlaveNode := wPolicyNode
          uniformPolicyNodes.head(bid)(wid) = rPolicyNode
          uniformPolicyNodes.last(bid)(wid) = wPolicyNode

          (Seq(urXbar, uwXbar) lazyZip uniformNodesIn lazyZip Seq(uniformRNodes, uniformWNodes))
            .foreach { case (xbar, idBuf, uNodes) =>

            idBuf(bid)(wid) = uNodes(bid)(wid).map { u =>
              val id = TLIdentityNode()
              xbar.node := id := u
              id
            }
          }

          // uniformWNodes(bid)(wid).foreach( uwXbar.node := _ )
          uniformNodesOut.head(bid)(wid) = TLIdentityNode()
          uniformNodesOut.last(bid)(wid) = TLIdentityNode()
          subbankRXbar.node := uniformNodesOut.head(bid)(wid) := urXbar.node
          subbankWXbar.node := uniformNodesOut.last(bid)(wid) := uwXbar.node

          nonuniformRNodes.foreach( subbankRXbar.node := _ )
          nonuniformWNodes.foreach( subbankWXbar.node := _ )
        }
      }
    }

    (Some(uniformRNodes), Some(uniformWNodes), Some(nonuniformRNodes), Some(nonuniformWNodes))
  } else {
    gemminis.foreach { gemmini =>
      unifiedMemReadNode :=* TLWidthWidget(smemWidth) :=* gemmini.spad_read_nodes
      unifiedMemWriteNode :=* TLWidthWidget(smemWidth) :=* gemmini.spad_write_nodes
      unifiedMemWriteNode := gemmini.spad.spad_writer.node // this is the dma write node
    }

    val splitterNode = RWSplitterNode()
    unifiedMemReadNode := TLWidthWidget(smemWidth) := splitterNode
    unifiedMemWriteNode := TLWidthWidget(smemWidth) := splitterNode

    radianceSmemFanout.foreach(clbus.inwardNode := _)
    splitterNode :=* TLWidthWidget(4) :=* clbus.outwardNode

    val smemRXbar = TLXbar()
    val smemWXbar = TLXbar()
    DisableMonitors { implicit p =>
      smemRXbar :=* TLWidthWidget(wordSize) :=* unifiedMemReadNode
      smemWXbar :=* TLWidthWidget(wordSize) :=* unifiedMemWriteNode
    }

    smemBankMgrs.foreach { mem =>
      require(mem.length == 2)
      mem.head := smemRXbar
      mem.last := smemWXbar
    }

    (None, None, None, None)
  }

  // *******************************************************
  //    ___  _______  _______  __ _________  ___   __   ____
  //   / _ \/ __/ _ \/  _/ _ \/ // / __/ _ \/ _ | / /  / __/
  //  / ___/ _// , _// // ___/ _  / _// , _/ __ |/ /___\ \
  // /_/  /___/_/|_/___/_/  /_//_/___/_/|_/_/ |_/____/___/
  //
  // *******************************************************

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
  TLRAM(AddressSet(smemKey.address + smemSize, numCoresInCluster * 0x200 - 1)) := traceTLNode :=
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

  def makeSmemBanks(): Unit = {
    def makeBuffer[T <: Data](mem: TwoPortSyncMem[T], rNode: TLBundle, rEdge: TLEdgeIn,
                               wNode: TLBundle, wEdge: TLEdgeIn): Unit = {
      mem.io.ren := rNode.a.fire

      val dataPipeIn = Wire(DecoupledIO(mem.io.rdata.cloneType))
      dataPipeIn.valid := RegNext(mem.io.ren)
      dataPipeIn.bits := mem.io.rdata

      val metadataPipeIn = Wire(DecoupledIO(new Bundle {
        val source = rNode.a.bits.source.cloneType
        val size = rNode.a.bits.size.cloneType
      }))
      metadataPipeIn.valid := mem.io.ren
      metadataPipeIn.bits.source := rNode.a.bits.source
      metadataPipeIn.bits.size := rNode.a.bits.size

      val sramReadBackupReg = RegInit(0.U.asTypeOf(Valid(mem.io.rdata.cloneType)))

      val dataPipeInst = Module(new Pipeline(dataPipeIn.bits.cloneType, 1)())
      dataPipeInst.io.in <> dataPipeIn
      val dataPipe = dataPipeInst.io.out
      val metadataPipe = Pipeline(metadataPipeIn, 2)
      assert((dataPipe.valid || sramReadBackupReg.valid) === metadataPipe.valid)

      // data pipe is filled, but D is not ready and SRAM read came back
      when (dataPipe.valid && !rNode.d.ready && dataPipeIn.valid) {
        assert(!dataPipeIn.ready) // we should fill backup reg only if data pipe is not enqueueing
        assert(!sramReadBackupReg.valid) // backup reg should be empty
        assert(!metadataPipeIn.ready) // metadata should be filled previous cycle
        sramReadBackupReg.valid := true.B
        sramReadBackupReg.bits := mem.io.rdata
      }.otherwise {
        assert(dataPipeIn.ready || !dataPipeIn.valid) // do not skip any response
      }

      assert(metadataPipeIn.fire || !mem.io.ren) // when requesting sram, metadata needs to be ready
      assert(rNode.d.fire === metadataPipe.fire) // metadata dequeues iff D fires

      // when D becomes ready, and data pipe has emptied, time for backup to empty
      when (rNode.d.ready && sramReadBackupReg.valid && !dataPipe.valid) {
        sramReadBackupReg.valid := false.B
      }
      // must empty backup before filling data pipe
      assert(!(sramReadBackupReg.valid && dataPipe.valid && dataPipeIn.fire))

      rNode.d.bits := rEdge.AccessAck(
        Mux(rNode.d.valid, metadataPipe.bits.source, 0.U),
        Mux(rNode.d.valid, metadataPipe.bits.size, 0.U),
        Mux(!dataPipe.valid, sramReadBackupReg.bits, dataPipe.bits).asUInt)
      rNode.d.valid := dataPipe.valid || sramReadBackupReg.valid
      // r node A is not ready only if D is not ready and both slots filled
      rNode.a.ready := rNode.d.ready && !(dataPipe.valid && sramReadBackupReg.valid)
      dataPipe.ready := rNode.d.ready
      metadataPipe.ready := rNode.d.ready

      // WRITE
      mem.io.wen := RegNext(wNode.a.fire)
      mem.io.wdata := RegNext(wNode.a.bits.data)
      mem.io.mask := RegNext(VecInit(wNode.a.bits.mask.asBools))

      val writeResp = Wire(Flipped(wNode.d.cloneType))
      writeResp.bits := wEdge.AccessAck(wNode.a.bits)
      writeResp.valid := wNode.a.valid
      wNode.a.ready := writeResp.ready
      wNode.d <> Queue(writeResp, 2)
    }

    // read OR write access counter for smem banks
    val smemBankMgrsGrouped = outer.smemBankMgrs.grouped(outer.smemSubbanks)
    val numBanks = smemBankMgrsGrouped.length
    val counterWidth = 32
    val smemReadsPerBankPerCycle  = Seq.fill(numBanks)(Seq.fill(outer.smemSubbanks)
                                                               (Wire(UInt(counterWidth.W))))
    val smemWritesPerBankPerCycle = Seq.fill(numBanks)(Seq.fill(outer.smemSubbanks)
                                                               (Wire(UInt(counterWidth.W))))
    val smemReadsPerCycle  = smemReadsPerBankPerCycle.map(_.reduce(_ + _)).reduce(_ + _)
    val smemWritesPerCycle = smemWritesPerBankPerCycle.map(_.reduce(_ + _)).reduce(_ + _)
    val smemReadCounter = RegInit(UInt(counterWidth.W), 0.U)
    val smemWriteCounter = RegInit(UInt(counterWidth.W), 0.U)
    smemReadCounter  := smemReadCounter + smemReadsPerCycle
    smemWriteCounter := smemWriteCounter + smemWritesPerCycle
    // smemReadsPerBankPerCycle.foreach(_.foreach(dontTouch(_)))
    dontTouch(smemReadCounter)
    dontTouch(smemWriteCounter)

    if (outer.strideByWord) {
      val uniformFires = Seq.fill(2)(VecInit.fill(outer.smemBanks)(VecInit.fill(outer.smemSubbanks)(false.B)))

      outer.smemBankMgrs.grouped(outer.smemSubbanks).zipWithIndex.foreach { case (bankMgrs, bid) =>
        // TODO move this loop out
        // val Seq(valid_r_sources, valid_w_sources) = uniform_xbar_nodes.map(_(bid)).map { words =>
        //   VecInit(words.map(_.out.map(_._1.a.valid)).transpose.map { words_with_same_idx =>
        //     VecInit(words_with_same_idx.toSeq).asUInt.orR
        //   }.toSeq).asUInt
        // }
        val wordSelects1h = Seq(
          Wire(UInt(outer.uniformNodesIn.head(bid).head.length.W)).suggestName(s"ws_r_b${bid}"),
          Wire(UInt(outer.uniformNodesIn.last(bid).head.length.W)).suggestName(s"ws_w_b${bid}"))
        val Seq(validRSources, validWSources) = outer.uniformNodesIn.zipWithIndex.map { case (banks, rw) =>
          VecInit(banks(bid).map(_.map(_.in.head._1.a.valid)).transpose.map { wordsInIdx =>
            VecInit(wordsInIdx.toSeq).asUInt.orR
          }.toSeq).asUInt.suggestName(s"valid_sources_rw${rw}_b${bid}")
        }

        assert(bankMgrs.flatten.size == 2/* read and write */ * outer.smemSubbanks)
        bankMgrs.zipWithIndex.foreach { case (Seq(r, w), wid) =>
          assert(!r.portParams.map(_.anySupportPutFull).reduce(_ || _))
          assert(!w.portParams.map(_.anySupportGet).reduce(_ || _))

          val memDepth = outer.smemDepth
          val memWidth = outer.smemWidth
          val wordWidth = outer.wordSize

          val mem = TwoPortSyncMem(
            n = memDepth,
            t = UInt((wordWidth * 8).W),
            mask_len = wordWidth // byte level mask
          )
          mem.suggestName(s"rad_smem_c${outer.thisClusterParams.clusterId}_b${bid}_w${wid}")

          val (rNode, rEdge) = r.in.head
          val (wNode, wEdge) = w.in.head

          // address format is
          // [ smem_base | bank_id | line_id | word_id | byte_offset ]
          // line_id is used to index into the SRAMs
          mem.io.raddr := (rNode.a.bits.address & (memDepth * memWidth - 1).U) >> log2Ceil(memWidth).U
          mem.io.waddr := RegNext((wNode.a.bits.address & (memDepth * memWidth - 1).U) >> log2Ceil(memWidth).U)

          assert((bid.U === ((rNode.a.bits.address & (memDepth * memWidth * outer.smemBanks - 1).U) >>
            log2Ceil(memDepth * memWidth).U).asUInt) || !rNode.a.valid, "bank id mismatch with request")
          assert((wid.U === ((rNode.a.bits.address & (memWidth - 1).U) >>
            log2Ceil(wordWidth).U).asUInt) || !rNode.a.valid, "word id mismatch with request")

          makeBuffer(mem, rNode, rEdge, wNode, wEdge)

          // add access counters to banks
          smemReadsPerBankPerCycle(bid)(wid)  := (rNode.a.fire === true.B)
          smemWritesPerBankPerCycle(bid)(wid) := (wNode.a.fire === true.B)

          // (uniform_fires zip Seq(uniform_r_nodes, uniform_w_nodes)).foreach { case (uf, n) =>
          //   uf(bid)(wid) := VecInit(n(bid)(wid).map(_.out.head._1.a.fire)).asUInt.orR
          (uniformFires zip outer.uniformNodesOut).foreach { case (uf, n) =>
            uf(bid)(wid) := n(bid)(wid).in.head._1.a.fire
          }
        }
        // use round robin to decide uniform select
        (wordSelects1h zip Seq(validRSources, validWSources)).zipWithIndex.foreach { case ((ws, vs), rw) =>
          ws := TLArbiter.roundRobin(vs.getWidth, vs, uniformFires(rw)(bid).asUInt.orR)
        }
        // mask valid into xbar to prevent triggering assertion
        // (wordSelects1h zip outer.uniformNodesIn).foreach { case (ws, ui) =>
        //   ui(bid).foreach { sources =>
        //     val inValid = sources.map(_.in.head._1.a.valid)
        //     val outValid = sources.map(_.out.head._1.a.valid)
        //     val wsActual = Mux((ws & VecInit(inValid).asUInt).orR,
        //       ws, TLArbiter.roundRobin(
        //         inValid.length, VecInit(inValid).asUInt, VecInit(sources.map(_.in.head._1.a.fire)).asUInt.orR))
        //     (inValid lazyZip outValid lazyZip wsActual.asBools).foreach { case (iv, ov, sel) =>
        //       ov := iv && sel // only present output valid if input is selected
        //     }
        //   }
        // }
        (wordSelects1h lazyZip outer.uniformPolicyNodes lazyZip outer.uniformNodesIn).foreach { case (ws, pn, ui) =>
          (pn(bid) zip ui(bid)).foreach { case (policies, sources) =>
            val inValid = sources.map(_.in.head._1.a.valid)
            val outValid = sources.map(_.out.head._1.a.valid)
            val hintHit = (ws & VecInit(inValid).asUInt).orR
            val wsActual = Mux(hintHit, ws, TLArbiter.lowestIndexFirst(
              inValid.length, VecInit(inValid).asUInt, hintHit && policies.out.head._1.actual(0)))
            (inValid lazyZip outValid lazyZip wsActual.asBools).foreach { case (iv, ov, sel) =>
              ov := iv && sel // only present output valid if input is selected
            }
          }
        }

        (outer.uniformPolicyNodes zip wordSelects1h).zipWithIndex.foreach { case ((nodesBw, ws), rw) =>
          nodesBw(bid).foreach { policy =>
            policy.out.head._1.hint := ws
          }
        }
      }

    } else {
      outer.smemBankMgrs.foreach { case Seq(r, w) =>
        val memDepth = outer.smemDepth
        val memWidth = outer.smemWidth

        val mem = TwoPortSyncMem(
          n = memDepth,
          t = UInt((memWidth * 8).W),
          mask_len = memWidth // byte level mask
        )

        val (rNode, rEdge) = r.in.head
        val (wNode, wEdge) = w.in.head

        mem.io.raddr := (rNode.a.bits.address ^ outer.smemBase.U) >> log2Ceil(memWidth).U
        mem.io.waddr := RegNext((wNode.a.bits.address ^ outer.smemBase.U) >> log2Ceil(memWidth).U)

        makeBuffer(mem, rNode, rEdge, wNode, wEdge)
      }
    }
  }

  makeSmemBanks()
}
