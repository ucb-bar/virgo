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
    val tilingParams: TensorTilingParams,
    val numFPRegs: Int = 32
) extends Module {
  val numWarpBits = log2Ceil(numWarps)
  val wordSize = 4 // TODO FP16
  val wordSizeInBits = wordSize * 8 // TODO FP16
  val sourceWidth = log2Ceil(numSourceIds)
  val dataWidth = numLanes * wordSizeInBits // TODO FP16
  val numFPRegBits = log2Ceil(numFPRegs)

  val io = IO(new Bundle {
    val initiate = Flipped(Decoupled(new Bundle {
      val wid = UInt(numWarpBits.W)
    }))
    val writeback = Decoupled(new Bundle {
      val last = Bool()
      val wid = UInt(numWarpBits.W)
      val rd = UInt(numFPRegBits.W)
      val data = Vec(numLanes, UInt((wordSizeInBits).W))
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
  // we need full 4x4 A tile to fire DPU, but since the memory width is 8
  // words, we need 2 cycles to read A.  `substep` tells which cycle we're at.
  val substepAccess = RegInit(0.U(1.W))
  dontTouch(setAccess)
  dontTouch(stepAccess)
  dontTouch(substepAccess)

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

  // TODO: @perf: Instead of waiting until the last writeback, release busy as
  // soon as the access frontend is complete so that there's a better chance to
  // saturate the backend with back-to-back HGMMAs.  This would require sending
  // the 'wid' register to backend instead of having it shared with the
  // frontend.
  when(io.writeback.fire && io.writeback.bits.last) {
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
    val substep = UInt(1.W)
  }
  // use concatenation of set/step as the memory request source.  This will get
  // translated to the actual TL sourcewidth in sourceGen.
  val tag = Wire(new TensorMemTag)
  tag.set := setAccess
  tag.step := stepAccess
  tag.substep := substepAccess

  val respATagged = Wire(Decoupled(new TensorMemRespWithTag(dataWidth)))
  val respBTagged = Wire(Decoupled(new TensorMemRespWithTag(dataWidth)))
  Seq((io.reqA, (io.respA, respATagged)),
      (io.reqB, (io.respB, respBTagged))).zipWithIndex.foreach {
    case ((req, (resp, respTagged)), i) => {
      val sourceGen = Module(new SourceGenerator(
        log2Ceil(numSourceIds),
        metadata = Some(tag)
      ))

      sourceGen.io.gen := req.fire
      sourceGen.io.meta := tag
      req.valid := genReq
      // FIXME: bogus address
      // req.bits.address := (if (i == 0) 0.U else 0x100.U) // avoids bank conflict for A and B
      req.bits.address := 0.U
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
  // TODO: @perf: too strict? should be able to have A and B progress
  // separately
  val firedABReg = RegInit(VecInit(false.B, false.B))
  val firedABNow = VecInit((Seq(io.reqA, io.reqB) zip firedABReg).map {
    case (req, fired) => { when (req.fire) { fired := true.B } }
    req.fire
  })
  val firedAB = (firedABNow.asUInt | firedABReg.asUInt)
  val nextSubstepAccess = firedAB.andR
  val nextStepAccess = nextSubstepAccess && (substepAccess === 1.U)
  // clear out firedABReg every substep
  when (nextSubstepAccess) {
    firedABReg := Seq(false.B, false.B)
    substepAccess := substepAccess + 1.U
  }
  require(substepAccess.widthOption.get == 1, "there should be only two substeps")

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

  val substepExecute = RegInit(0.U(1.W))
  when (respQueueA.fire) {
    substepExecute := substepExecute + 1.U
  }
  dontTouch(substepExecute)

  // Do pipelining for the A operand so that we obtain the full 4x4 A tile
  // ready for compute.  The pipeline is two-stage:
  //   - stage one (halfAQueue) for assembling the full A tile from half-tiles
  //     coming from the resp queue, and
  //   - stage two (fullAQueue) for holding the full A tile until it gets
  //     matched with two 4x2 B tiles, and compute is complete.
  //
  // Note that the half-tile assembly is unnecessary for B since the B tile is
  // only 4x2.
  // Also send the set/step tag along the pipe for alignment check.

  // note combinationally coupled ready with `pipe`
  val halfAQueue = Module(new Queue(
    chiselTypeOf(respQueueA.bits), entries = 1, pipe = true
  ))
  halfAQueue.io.enq.valid := respQueueA.valid && (substepExecute === 0.U)
  halfAQueue.io.enq.bits := respQueueA.bits

  // substep == 0 data goes to the LSB
  val fullAEnqData = Cat(respQueueA.bits.data, halfAQueue.io.deq.bits.data)
  require(fullAEnqData.widthOption.get == dataWidth * 2,
          "assumes 2-cycle read for a full compute tile of A")
  // only use the lower halfA's tag.  substep will be incorrect.
  val fullAEnqTag = halfAQueue.io.deq.bits.tag
  val fullAQueue = Module(new Queue(
    new TensorMemRespWithTag(dataWidth * 2), entries = 1, pipe = true
  ))
  // hold first half A data for the first substep
  halfAQueue.io.deq.ready := respQueueA.valid && (substepExecute === 1.U) &&
                             fullAQueue.io.enq.ready
  fullAQueue.io.enq.valid := respQueueA.valid && (substepExecute === 1.U) &&
                             halfAQueue.io.deq.valid
  fullAQueue.io.enq.bits.data := fullAEnqData
  fullAQueue.io.enq.bits.tag := fullAEnqTag

  val operandsValid = fullAQueue.io.deq.valid && respQueueB.valid
  val operandA = fullAQueue.io.deq.bits.data
  val operandB = respQueueB.bits.data
  val dpuReady = Wire(Bool())
  val dpuFire = operandsValid && dpuReady
  val substepCompute = RegInit(0.U(1.W))
  when (dpuFire) {
    substepCompute := substepCompute + 1.U
  }

  // hold full A until two-cycle compute is done
  fullAQueue.io.deq.ready := dpuFire && (substepCompute === 1.U)
  val nextStepExecute = dpuFire && (substepCompute === 1.U)

  // respQueueA output arbitrates to either halfAQueue or fullAQueue depending
  // on the substep
  respQueueA.ready := MuxCase(false.B,
                              Seq((substepExecute === 0.U) -> halfAQueue.io.enq.ready,
                                  (substepExecute === 1.U) -> fullAQueue.io.enq.ready))
  respQueueB.ready := dpuFire
  dontTouch(respQueueA)
  dontTouch(respQueueB)

  // assert that the DPU is computing with operands of the same set/step
  //
  // this assumes that memory responses come back in-order.  this might be too
  // strong an assumption depending on the backing memory
  def assertAligned = {
    when (dpuFire) {
      assert((fullAQueue.io.deq.bits.tag.set === respQueueB.bits.tag.set) &&
             (fullAQueue.io.deq.bits.tag.step === respQueueB.bits.tag.step),
        "A and B operands are pointing to different set/steps. " ++
        "This might indicate memory response coming back out-of-order.")
    }
  }
  assertAligned

  // Dot-product unit
  //
  // 4x2 four-element DPUs summing up to 32 MACs in total
  val dpus = Seq.fill(4)(Seq.fill(2)(
    Module(new TensorDotProductUnit(half = false))
  ))
  // operandA is 4x4 in K-major
  val operandADimensional =
    operandA.asBools.grouped(wordSizeInBits).map(VecInit(_).asUInt).toSeq
    .grouped(4).toSeq
  println(s"operandA: ${fullAQueue.io.deq.bits.data.widthOption.get} bits")
  println(s"A: ${operandADimensional.length}, ${operandADimensional(0).length}")
  assert(operandADimensional.length == tilingParams.mc &&
         operandADimensional(0).length == tilingParams.kc,
         "operand width doesn't agree with tiling parameter")
  // operandB is 2x4, i.e. 4x2 in N-major
  val operandBDimensional =
    operandB.asBools.grouped(wordSizeInBits).map(VecInit(_).asUInt).toSeq
    .grouped(4).toSeq
  println(s"B: ${operandBDimensional.length}, ${operandBDimensional(0).length}")
  val ncSubstep = tilingParams.nc / 2
  assert(tilingParams.mc * ncSubstep == numLanes,
         "substep tile size doesn't match writeback throughput")
  assert(operandBDimensional.length == ncSubstep &&
         operandBDimensional(0).length == tilingParams.kc,
         "operand width doesn't agree with tiling parameter")

  for (m <- 0 until tilingParams.mc) {
    for (n <- 0 until ncSubstep) {
      dpus(m)(n).io.in.valid := dpuFire
      dpus(m)(n).io.in.bits.a := operandADimensional(m)
      dpus(m)(n).io.in.bits.b := operandBDimensional(n)
      dpus(m)(n).io.in.bits.c := 0.U // FIXME: bogus accum data
      // dpu ready couples with writeback backpressure
      dpus(m)(n).io.stall := !io.writeback.ready
    }
  }
  dpuReady := !dpus(0)(0).io.stall
  dontTouch(dpuFire)
  dontTouch(dpuReady)

  val dpuValids = dpus.flatMap(_.map(_.io.out.valid))
  val dpuValid = dpuValids.reduce(_ && _)
  def assertDPU = {
    val dpuStalls = dpus.flatMap(_.map(_.io.stall))
    assert(dpuStalls.reduce(_ && _) === dpuStalls.reduce(_ || _),
      "stall signals of DPUs went unaligned")
    assert(dpuValids.reduce(_ && _) === dpuValids.reduce(_ || _),
      "valid signals of DPUs went unaligned")
  }
  assertDPU

  // flatten DPU output into 1D array in M-major order
  val flattenedDPUOut = (0 until ncSubstep).flatMap { n =>
    (0 until tilingParams.mc).map { m =>
      dpus(m)(n).io.out.bits.data
    }
  }
  io.writeback.bits.data := flattenedDPUOut

  def rdGen(set: UInt, step: UInt): UInt = {
    // each step produces 4x4 output tile, written by 8 threads with 2 regs per
    // thread
    require(numLanes == 8, "currently assumes 8-wide warps")
    (Cat(set, step) >> 1/*2 regs/thread*/)
    // FIXME: add substep here
  }

  io.writeback.valid := dpuValid
  io.writeback.bits.wid := warpReg
  io.writeback.bits.rd := rdGen(setExecute, stepExecute)
  io.writeback.bits.last := setDone(setExecute) && stepDone(stepExecute)

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
  val wordSize = 4 // @cleanup: hardcoded

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
  tensor.io.initiate.bits.wid := 0.U // TODO
  tensor.io.writeback.ready := true.B

  io.finished := tensor.io.writeback.valid && tensor.io.writeback.bits.last
}

// a minimal Diplomacy graph with a tensor core and a TLRAM
class TensorCoreDecoupledTLRAM(implicit p: Parameters) extends LazyModule {
  val tensor = LazyModule(new TensorCoreDecoupledTL)
  val xbar = LazyModule(new TLXbar)
  val ram = LazyModule(new TLRAM(
    address = AddressSet(0x0000, 0xffffff),
    beatBytes = 32 // @cleanup: hardcoded
  ))

  ram.node :=* xbar.node :=* tensor.node

  lazy val module = new Impl
  class Impl extends LazyModuleImp(this) with UnitTestModule {
    tensor.module.io.start := io.start
    io.finished := tensor.module.io.finished
  }
}

// two separate TLRAMs for A and B for full throughput
class TensorCoreDecoupledTwoTLRAM(implicit p: Parameters) extends LazyModule {
  val tensor = LazyModule(new TensorCoreDecoupledTL)
  val xbar = LazyModule(new TLXbar)
  val ramA = LazyModule(new TLRAM(
    address = AddressSet(0x000, 0xfffeff),
    beatBytes = 32 // @cleanup: hardcoded
  ))
  val ramB = LazyModule(new TLRAM(
    address = AddressSet(0x100, 0xfffeff),
    beatBytes = 32 // @cleanup: hardcoded
  ))

  xbar.node :=* tensor.node
  ramA.node := xbar.node
  ramB.node := xbar.node

  lazy val module = new Impl
  class Impl extends LazyModuleImp(this) with UnitTestModule {
    tensor.module.io.start := io.start
    io.finished := tensor.module.io.finished
  }
}

// unit test harness
class TensorCoreDecoupledTest(timeout: Int = 500000)(implicit p: Parameters)
    extends UnitTest(timeout) {
  // val dut = Module(LazyModule(new TensorCoreDecoupledTLRAM).module)
  val dut = Module(LazyModule(new TensorCoreDecoupledTwoTLRAM).module)
  dut.io.start := io.start
  io.finished := dut.io.finished
}
