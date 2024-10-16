package radiance.tile

import chisel3._
import chisel3.util._
import org.chipsalliance.diplomacy.lazymodule._
import org.chipsalliance.cde.config.Parameters
import freechips.rocketchip.tilelink._
import freechips.rocketchip.diplomacy.{AddressSet, TransferSizes}
import gemmini.Pipeline
import radiance.subsystem.RadianceSharedMemKey
import radiance.memory._
import scala.collection.mutable.ArrayBuffer

abstract class RadianceSmemNodeProvider {
  val uniformRNodes: Seq[Seq[Seq[TLNexusNode]]]
  val uniformWNodes: Seq[Seq[Seq[TLNexusNode]]]
  val nonuniformRNodes: Seq[TLNode]
  val nonuniformWNodes: Seq[TLNode]
  val clBusClients: Seq[TLNode]
}

abstract class RadianceSmemNodeProviderImp[T <: RadianceSmemNodeProvider](val outer: T) {}

class RadianceSharedMem[T <: RadianceSmemNodeProvider](
    provider: () => T,
    val providerImp: Option[(T) => RadianceSmemNodeProviderImp[T]],
    clbus: TLBusWrapper
  )(implicit p: Parameters) extends LazyModule {
  val smemKey = p(RadianceSharedMemKey).get
  val wordSize = smemKey.wordSize
  val smemBase = smemKey.address
  val smemBanks = smemKey.numBanks
  val smemWidth = smemKey.numWords * smemKey.wordSize
  val smemDepth = smemKey.size / smemWidth / smemBanks
  val smemSubbanks = smemWidth / wordSize
  val smemSize = smemWidth * smemDepth * smemBanks
  val strideByWord = smemKey.strideByWord

  require(isPow2(smemBanks))

  val smNodes = provider()
  val (uniformRNodes, uniformWNodes, nonuniformRNodes, nonuniformWNodes) =
    (smNodes.uniformRNodes, smNodes.uniformWNodes, smNodes.nonuniformRNodes, smNodes.nonuniformWNodes)

  implicit val disableMonitors = smemKey.disableMonitors // otherwise it generate 1k+ different tl monitors

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

  if (strideByWord) {
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

          uniformNodesOut.head(bid)(wid) = TLIdentityNode()
          uniformNodesOut.last(bid)(wid) = TLIdentityNode()
          subbankRXbar.node := uniformNodesOut.head(bid)(wid) := urXbar.node
          subbankWXbar.node := uniformNodesOut.last(bid)(wid) := uwXbar.node

          nonuniformRNodes.foreach( subbankRXbar.node :=* _ )
          nonuniformWNodes.foreach( subbankWXbar.node :=* _ )
        }
      }
    }
  } else { // not stride by word
    val smemRXbar = TLXbar()
    val smemWXbar = TLXbar()

    guardMonitors { implicit p =>
      (uniformRNodes.flatten.flatten ++ nonuniformRNodes).foreach {
        smemRXbar :=* TLWidthWidget(wordSize) :=* _
      }
      (uniformWNodes.flatten.flatten ++ nonuniformWNodes).foreach {
        smemWXbar :=* TLWidthWidget(wordSize) :=* _
      }
    }

    smemBankMgrs.foreach { mem =>
      require(mem.length == 2)
      mem.head := smemRXbar
      mem.last := smemWXbar
    }
  } // stride by word

  guardMonitors { implicit p => smNodes.clBusClients.foreach(clbus.inwardNode := _) }

  lazy val module = new RadianceSharedMemImp(this)
}

class RadianceSharedMemImp[T <: RadianceSmemNodeProvider](outer: RadianceSharedMem[T]) extends LazyModuleImp(outer) {

  val smNodesImp = outer.providerImp.map(impFn => impFn(outer.smNodes))

  def makeBuffer[U <: Data](mem: TwoPortSyncMem[U], rNode: TLBundle, rEdge: TLEdgeIn,
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
    mem.io.mask := RegNext(wNode.a.bits.mask)

    val writeResp = Wire(Flipped(wNode.d.cloneType))
    writeResp.bits := wEdge.AccessAck(wNode.a.bits)
    writeResp.valid := wNode.a.valid
    wNode.a.ready := writeResp.ready
    wNode.d <> Queue(writeResp, 2)
  }

  // read/write access counter for smem banks
  val Seq(smemReadsPerCycle, smemWritesPerCycle) = outer.smemBankMgrs.transpose.map { rw =>
    VecInit(rw.map(_.in.head._1.a.fire.asUInt)).reduceTree(_ +& _)
  }
  val smemReadCounter = RegInit(0.U(32.W))
  val smemWriteCounter = RegInit(0.U(32.W))
  smemReadCounter := smemReadCounter +& smemReadsPerCycle
  smemWriteCounter := smemWriteCounter +& smemWritesPerCycle
  dontTouch(smemReadCounter)
  dontTouch(smemWriteCounter)

  if (outer.strideByWord) {
    val uniformFires = Seq.fill(2)(VecInit.fill(outer.smemBanks)(VecInit.fill(outer.smemSubbanks)(false.B)))

    outer.smemBankMgrs.grouped(outer.smemSubbanks).zipWithIndex.foreach { case (bankMgrs, bid) =>
      // have a uniform hint to all subbanks in a bank
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
        )
        // TODO: bring in cluster id
        // mem.suggestName(s"rad_smem_cl${outer.thisClusterParams.clusterId}_b${bid}_w${wid}")

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

        (uniformFires zip outer.uniformNodesOut).foreach { case (uf, n) =>
          uf(bid)(wid) := n(bid)(wid).in.head._1.a.fire
        }
      }
      // use round robin to decide uniform select
      (wordSelects1h zip Seq(validRSources, validWSources)).zipWithIndex.foreach { case ((ws, vs), rw) =>
        ws := TLArbiter.roundRobin(vs.getWidth, vs, uniformFires(rw)(bid).asUInt.orR)
      }
      // mask valid into xbar to prevent triggering assertion
      (wordSelects1h lazyZip outer.uniformPolicyNodes lazyZip outer.uniformNodesIn).foreach { case (ws, pn, ui) =>
        (pn(bid) zip ui(bid)).foreach { case (policies, sources) =>
          val inValid = sources.map(_.in.head._1.a.valid)
          val outValid = sources.map(_.out.head._1.a.valid)

          // we mirror the selection in XbarWithExtPolicy
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
      )

      val (rNode, rEdge) = r.in.head
      val (wNode, wEdge) = w.in.head

      mem.io.raddr := (rNode.a.bits.address ^ outer.smemBase.U) >> log2Ceil(memWidth).U
      mem.io.waddr := RegNext((wNode.a.bits.address ^ outer.smemBase.U) >> log2Ceil(memWidth).U)

      makeBuffer(mem, rNode, rEdge, wNode, wEdge)
    }
  }

}
