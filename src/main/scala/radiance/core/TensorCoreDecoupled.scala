// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.core

import chisel3._
import chisel3.util._
import org.chipsalliance.cde.config.Parameters
import org.chipsalliance.diplomacy.lazymodule.{LazyModule, LazyModuleImp}
import freechips.rocketchip.tilelink._
import freechips.rocketchip.diplomacy.{IdRange, AddressSet}
import freechips.rocketchip.unittest.{UnitTest, UnitTestModule}
import radiance.memory.SourceGenerator

case class TensorTilingParams(
  // Dimension of the SMEM tile
  m: Int = 16,
  n: Int = 16,
  k: Int = 16,
  // Dimension of the compute tile.  This is determined by the number of MAC
  // units
  mc: Int = 4,
  nc: Int = 4,
  kc: Int = 4
)

class TensorCoreDecoupled(
    val numWarps: Int,
    val numLanes: Int,
    val numSourceIds: Int,
    val tilingParams: TensorTilingParams
) extends Module {
  val numWarpBits = log2Ceil(numWarps)
  val wordSize = 4 // TODO FP16
  val sourceWidth = log2Ceil(numSourceIds)
  val dataWidth = numLanes * wordSize * 8/*bits*/ // TODO FP16

  val io = IO(new Bundle {
    val initiate = Flipped(Decoupled(new Bundle {
      val wid = UInt(numWarpBits.W)
    }))
    val writeback = Decoupled(new Bundle {
      val last = Bool()
      val wid = UInt(numWarpBits.W)
      val data = Vec(numLanes, UInt((wordSize * 8/*bits*/).W))
    })
    val respA = Flipped(Decoupled(new TensorMemResp(sourceWidth, dataWidth)))
    val respB = Flipped(Decoupled(new TensorMemResp(sourceWidth, dataWidth)))
    val reqA = Decoupled(new TensorMemReq(sourceWidth))
    val reqB = Decoupled(new TensorMemReq(sourceWidth))
  })
  dontTouch(io)

  class TensorMemReq(
    sourceWidth: Int
  ) extends Bundle {
    val source = UInt(sourceWidth.W)
    val address = UInt(32.W)
  }
  class TensorMemResp(
    sourceWidth: Int,
    dataWidth: Int
  ) extends Bundle {
    val source = UInt(sourceWidth.W)
    val data = UInt(dataWidth.W)
  }
  // mem response after translation from TL source to set/step tag
  class TensorMemRespWithTag(
    dataWidth: Int
  ) extends Bundle {
    val tag = new TensorMemTag
    val data = UInt(dataWidth.W)
  }

  // FSM
  // ---
  // This drives the overall pipeline of memory requests, dot-product unit
  // operations and regfile writeback.

  object TensorState extends ChiselEnum {
    val idle = Value(0.U)
    val run = Value(1.U)
    // All set/step sequencing is complete and the tensor core is holding the
    // result data until downstream writeback is ready.
    // FIXME: is this necessary if writeback is decoupled with queues?
    val finish = Value(2.U)
  }
  val state = RegInit(TensorState.idle)
  val busy = RegInit(false.B)
  // Holds the warp id the core is currently working on.  Note that we only
  // support one outstanding warp request
  val warpReg = RegInit(0.U(numWarpBits.W))

  // sets: k iteration
  val numSets = (tilingParams.k / tilingParams.kc)
  val setBits = log2Ceil(numSets)
  // steps: i-j iteration
  val numSteps = (tilingParams.m * tilingParams.n) / (tilingParams.mc * tilingParams.nc)
  val stepBits = log2Ceil(numSteps)
  val lastSet = ((1 << setBits) - 1)
  val lastStep = ((1 << stepBits) - 1)
  def setDone(set: UInt) = (set === lastSet.U)
  def stepDone(step: UInt) = (step === lastStep.U)

  // set and step being currently accessed in the acc/ex frontend
  val setAccess = RegInit(0.U(setBits.W))
  val stepAccess = RegInit(0.U(stepBits.W))
  dontTouch(setAccess)
  dontTouch(stepAccess)

  when(io.initiate.fire) {
    val wid = io.initiate.bits.wid
    busy := true.B
    warpReg := wid
    setAccess := 0.U
    stepAccess := 0.U
    when(io.writeback.fire) {
      assert(
        io.writeback.bits.wid =/= wid,
        "unsupported concurrent initiate and writeback to the same warp"
      )
    }
  }
  when(io.writeback.fire) {
    busy := false.B
  }

  // serialize every HGMMA request
  io.initiate.ready := !busy

  // Memory traffic generation
  // -------------------------
  //
  val genReq = (state === TensorState.run)

  class TensorMemTag extends Bundle {
    val set = UInt(setBits.W)
    val step = UInt(stepBits.W)
  }
  // use concatenation of set/step as the memory request source.  This will get
  // translated to the actual TL sourcewidth in sourceGen.
  val tag = Wire(new TensorMemTag)
  tag.set := setAccess
  tag.step := stepAccess

  val respATagged = Wire(Decoupled(new TensorMemRespWithTag(dataWidth)))
  val respBTagged = Wire(Decoupled(new TensorMemRespWithTag(dataWidth)))
  Seq((io.reqA, (io.respA, respATagged)), (io.reqB, (io.respB, respBTagged))).foreach {
    case (req, (resp, respTagged)) => {
      val sourceGen = Module(new SourceGenerator(
        log2Ceil(numSourceIds),
        metadata = Some(tag)
      ))

      sourceGen.io.gen := req.fire
      sourceGen.io.meta := tag
      req.valid := genReq
      req.bits.address := 0.U // FIXME
      req.bits.source := sourceGen.io.id.bits

      sourceGen.io.reclaim.valid := resp.fire
      sourceGen.io.reclaim.bits := resp.bits.source

      // translate source
      respTagged.valid := resp.valid
      respTagged.bits.tag := sourceGen.io.peek
      respTagged.bits.data := resp.bits.data
      resp.ready := respTagged.ready
    }
  }

  // only advance to the next step if we fired mem requests for both A and B
  val firedABReg = RegInit(VecInit(false.B, false.B))
  val firedABNow = VecInit((Seq(io.reqA, io.reqB) zip firedABReg).map {
    case (req, fired) => { when (req.fire) { fired := true.B } }
    req.fire
  })
  val firedAB = (firedABNow.asUInt | firedABReg.asUInt)
  val nextStepAccess = firedAB.andR
  // clear out firedABReg every step.  this will overwrite the previous fired
  // write upon the last fire out of A and B
  when (nextStepAccess) {
    firedABReg := Seq(false.B, false.B)
  }

  // Execute stage
  // -------------
  // Backend of the decoupled access/execute pipeline.
  //
  // set and step being currently executed in the acc/ex backend
  val setExecute = RegInit(0.U(setBits.W))
  val stepExecute = RegInit(0.U(stepBits.W))
  dontTouch(setExecute)
  dontTouch(stepExecute)

  val respQueueDepth = 4 // FIXME: parameterize
  val respQueueA = Queue(respATagged, respQueueDepth)
  val respQueueB = Queue(respBTagged, respQueueDepth)

  require(respQueueA.bits.data.widthOption.get ==
          io.writeback.bits.data.widthOption.get,
    "response data width does not match the writeback data width")

  val bothQueueValid = (respQueueA.valid && respQueueB.valid)
  // assume in-order response and that A/B responses are always aligned; this
  // might be too strong an assumption depending on the backing memory
  when (bothQueueValid) {
    assert((respQueueA.bits.tag.set === respQueueB.bits.tag.set) &&
           (respQueueA.bits.tag.step === respQueueB.bits.tag.step),
           "A and B response queue pointing to different set/steps. " ++
           "This might indicate memory response coming back out-of-order.")
  }
  // dequeue is synchronized between A and B
  // FIXME: this need to change to dpu_ready
  val deqResp = bothQueueValid && io.writeback.ready
  respQueueA.ready := deqResp
  respQueueB.ready := deqResp
  // FIXME: this need to change to dpu_fire
  val nextStepExecute = io.writeback.fire

  io.writeback.valid := bothQueueValid
  io.writeback.bits.wid := warpReg
  io.writeback.bits.last := setDone(setExecute) && stepDone(stepExecute)

  // FIXME: debug dummy: pipe A directly to writeback
  val groupedRespA = respQueueA.bits.data
                     .asBools.grouped(wordSize * 8/*bits*/)
                     .map(VecInit(_).asUInt)
  (io.writeback.bits.data zip groupedRespA).foreach { case (wb, data) =>
    wb := data
  }

  // State transition
  // ----------------
  //
  // set/step sequencing logic

  def sequenceSetStep(set: UInt, step: UInt, nextStep: Bool) = {
    when (nextStep) {
      step := (step + 1.U) & lastStep.U
      when (stepDone(step)) {
        set := (set + 1.U) & lastSet.U
      }
    }
  }
  sequenceSetStep(setAccess, stepAccess, nextStepAccess)
  sequenceSetStep(setExecute, stepExecute, nextStepExecute)

  switch(state) {
    is(TensorState.idle) {
      when(io.initiate.fire) {
        state := TensorState.run
      }
    }
    is(TensorState.run) {
      when (setDone(setAccess) && stepDone(stepAccess) && nextStepAccess) {
        when (state === TensorState.run) {
          state := TensorState.finish
        }
      }
    }
    is(TensorState.finish) {
      when(io.writeback.fire) {
        state := TensorState.idle
      }
    }
  }

  // Writeback queues
  // ----------------
  // These queues hold the metadata necessary for register
  // writeback.

  // val queueDepth = 2
  // val widQueue = Queue(io.initiate, queueDepth, pipe = (queueDepth == 1))
  // val rdQueue = Queue(io.initiate, queueDepth, pipe = (queueDepth == 1))
}

// synthesizable unit tests

// wraps TensorCoreDecoupled with a TileLink client node for use in a Diplomacy
// graph.
class TensorCoreDecoupledTL(implicit p: Parameters) extends LazyModule {
  val numSrcIds = 4

  // node with two edges; one for A and one for B matrix
  val node = TLClientNode(Seq(
    TLMasterPortParameters.v2(
      Seq(TLMasterParameters.v2(
        name = "TensorCoreDecoupledMatrixANode",
        sourceId = IdRange(0, numSrcIds)
      ))
    ),
    TLMasterPortParameters.v2(
      Seq(TLMasterParameters.v2(
        name = "TensorCoreDecoupledMatrixBNode",
        sourceId = IdRange(0, numSrcIds)
      ))
    )
  ))

  lazy val module = new TensorCoreDecoupledTLImp(this)
}

class TensorCoreDecoupledTLImp(outer: TensorCoreDecoupledTL)
    extends LazyModuleImp(outer) with UnitTestModule {
  require(outer.node.out.length == 2/*A and B*/)

  val tensor = Module(new TensorCoreDecoupled(
                      8, 8, outer.numSrcIds , TensorTilingParams()))
  val wordSize = 4 // FIXME: hardcoded

  val zip = Seq((outer.node.out(0), tensor.io.reqA),
                (outer.node.out(1), tensor.io.reqB))
  zip.foreach { case ((tl, edge), req) =>
    tl.a.valid := req.valid
    val (legal, bits) = edge.Get(
      fromSource = req.bits.source,
      toAddress = req.bits.address,
      lgSize = log2Ceil(wordSize).U
    )
    tl.a.bits := bits
    req.ready := tl.a.ready
    when(tl.a.fire) {
      assert(legal, "illegal TL req gen")
    }
  }

  // TODO: dedup A and B
  val (tlOutA, _) = outer.node.out(0)
  val (tlOutB, _) = outer.node.out(1)
  tensor.io.respA.valid := tlOutA.d.valid
  tensor.io.respA.bits.data := tlOutA.d.bits.data
  tensor.io.respA.bits.source := tlOutA.d.bits.source
  tlOutA.d.ready := tensor.io.respA.ready
  tensor.io.respB.valid := tlOutB.d.valid
  tensor.io.respB.bits.data := tlOutB.d.bits.data
  tensor.io.respB.bits.source := tlOutB.d.bits.source
  tlOutB.d.ready := tensor.io.respB.ready

  tensor.io.initiate.valid := io.start
  tensor.io.initiate.bits.wid := 0.U // FIXME
  tensor.io.writeback.ready := true.B

  io.finished := tensor.io.writeback.valid && tensor.io.writeback.bits.last
}

// a minimal Diplomacy graph with a tensor core and a TLRAM
class TensorCoreDecoupledTLRAM(implicit p: Parameters) extends LazyModule {
  val tensor = LazyModule(new TensorCoreDecoupledTL)
  val xbar = LazyModule(new TLXbar)
  val ram = LazyModule(new TLRAM(
    address = AddressSet(0x0000, 0xffffff),
    beatBytes = 32 // FIXME: hardcoded
  ))

  ram.node :=* xbar.node :=* tensor.node

  lazy val module = new Impl
  class Impl extends LazyModuleImp(this) with UnitTestModule {
    tensor.module.io.start := io.start
    io.finished := tensor.module.io.finished
  }
}

// unit test harness
class TensorCoreDecoupledTest(timeout: Int = 500000)(implicit p: Parameters)
    extends UnitTest(timeout) {
  val dut = Module(LazyModule(new TensorCoreDecoupledTLRAM).module)
  dut.io.start := io.start
  io.finished := dut.io.finished
}
