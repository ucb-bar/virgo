package radiance.tile

import chisel3._
import chisel3.util._
import org.chipsalliance.diplomacy.lazymodule._
import org.chipsalliance.diplomacy.{DisableMonitors, ValName}
import org.chipsalliance.cde.config.Parameters
import radiance.memory._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.diplomacy.{AddressSet, BufferParams}
import freechips.rocketchip.subsystem.BaseClusterParams
import radiance.subsystem.RadianceSharedMemKey
import gemmini._

// virgo-specific tilelink nodes
// generic smem implementation is in RadianceSharedMem.scala
class VirgoSharedMemComponents(
  clusterParams: BaseClusterParams,
  gemminiTiles: Seq[GemminiTile],
  radianceTiles: Seq[RadianceTile],
)(implicit p: Parameters) extends RadianceSmemNodeProvider  {
  val smemKey = p(RadianceSharedMemKey).get
  val wordSize = smemKey.wordSize
  val smemBase = smemKey.address
  val smemBanks = smemKey.numBanks
  val smemWidth = smemKey.numWords * smemKey.wordSize
  val smemDepth = smemKey.size / smemWidth / smemBanks
  val smemSubbanks = smemWidth / wordSize
  val smemSize = smemWidth * smemDepth * smemBanks

  val gemminis = gemminiTiles.map(_.gemmini)
  val gemminiConfigs = gemminis.map(_.config)
  gemminiConfigs.foreach { config =>
    assert(smemBanks == config.sp_banks && isPow2(smemBanks / config.sp_banks))
    assert(smemWidth >= (config.sp_width / 8) && isPow2(smemWidth / (config.sp_width / 8)))
    assert(smemSize == config.sp_capacity.asInstanceOf[CapacityInKilobytes].kilobytes * 1024)
  }
  if (gemminiConfigs.length > 1) {
    if (!(gemminiConfigs.tail.map(_.inputType == gemminiConfigs.head.inputType).reduce(_ && _))) {
      println("******** WARNING ********\n******** gemmini data types do not match\n******** WARNING ********")
    }
  }

  val strideByWord = smemKey.strideByWord
  val filterAligned = smemKey.filterAligned
  val serializeUnaligned = smemKey.serializeUnaligned
  implicit val disableMonitors: Boolean = smemKey.disableMonitors // otherwise it generate 1k+ different tl monitors

  val radianceSmemFanout = radianceTiles.zipWithIndex.flatMap { case (tile, cid) =>
    tile.smemNodes.zipWithIndex.map { case (m, lid) =>
      val smemFanoutXbar = LazyModule(new TLXbar())
      smemFanoutXbar.suggestName(f"rad_smem_fanout_cl${clusterParams.clusterId}_c${cid}_l${lid}_xbar")
      smemFanoutXbar.node :=* m
      smemFanoutXbar.node
    }
  }
  val clBusClients: Seq[TLNode] = radianceSmemFanout

  val (uniformRNodes, uniformWNodes, nonuniformRNodes, nonuniformWNodes) =

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

    if (filterAligned) {
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
                  val filterNode = AlignFilterNode(Seq(address))(p, ValName(s"filter_l${lid}_w${trueWid}"))
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
          Seq.fill(2)(filterNodes.flatMap(_.map(_._2).map(connectXbar.apply)))
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
            val filterNode = AlignFilterNode(addresses)(p, ValName(s"filter_c${cid}_w${wid}"))
            guardMonitors { implicit p =>
              filterNode := lane
            }
            filterNode
          }
        }
        val fAlignedRW = Seq.tabulate(numLaneDupes) { did =>
          filterNodes.zipWithIndex.map { case (cores, lid) =>
            cores.zipWithIndex.map { case (fn, cid) =>
              val address = AddressSet(smemBase + (did * filterRange + lid) * wordSize,
                (smemSize - 1) - (smemSubbanks - 1) * wordSize)
              connectOne(fn, () => RWSplitterNode(address, s"aligned_split_c${cid}_l${lid}_d${did}"))
            }
          }
        }.flatten
        val fUnalignedRW = filterNodes.zipWithIndex.flatMap { case (cores, lid) =>
          cores.zipWithIndex.map { case (fn, cid) =>
            connectOne(fn, () => RWSplitterNode(AddressSet.everything, s"unaligned_split_c${cid}_l${lid}"))
          }
        }
        val fAligned = Seq.fill(2)(fAlignedRW.map(_.map(connectXbarName(_, Some("rad_aligned")))))

        val fUnaligned = if (serializeUnaligned) {
          Seq.fill(2) {
            val serializedNode = TLEphemeralNode()
            val serializedInXbar = TLXbar(nameSuffix = Some("unaligned_ser_in"))
            val serializedOutXbar = TLXbar(nameSuffix = Some("unaligned_ser_out"))
            guardMonitors { implicit p =>
              fUnalignedRW.foreach(serializedInXbar := _)
              serializedNode := serializedInXbar
              serializedOutXbar := serializedNode
            }
            Seq(serializedOutXbar)
          }
        } else {
          Seq.fill(2)(fUnalignedRW.map(connectXbar.apply))
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
  } else { // not stride by word
    val unifiedMemReadNode = TLIdentityNode()
    val unifiedMemWriteNode = TLIdentityNode()

    gemminis.foreach { gemmini =>
      unifiedMemReadNode :=* TLWidthWidget(smemWidth) :=* gemmini.spad_read_nodes
      unifiedMemWriteNode :=* TLWidthWidget(smemWidth) :=* gemmini.spad_write_nodes
      unifiedMemWriteNode := gemmini.spad.spad_writer.node // this is the dma write node
    }

    val splitterNode = RWSplitterNode()
    unifiedMemReadNode := TLWidthWidget(smemWidth) := splitterNode
    unifiedMemWriteNode := TLWidthWidget(smemWidth) := splitterNode

    val coreXbar = TLXbar()
    radianceSmemFanout.foreach(coreXbar := _)
    splitterNode :=* TLWidthWidget(4) :=* coreXbar

    (Seq.empty, Seq.empty, Seq(unifiedMemReadNode), Seq(unifiedMemWriteNode))
  }
}
