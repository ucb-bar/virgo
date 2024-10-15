// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.core

import chisel3._
import chisel3.util._
import org.chipsalliance.cde.config.Parameters
import freechips.rocketchip.unittest.UnitTest

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
    val tilingParams: TensorTilingParams
) extends Module {
  val numWarpBits = log2Ceil(numWarps)
  val wordSize = 4 // TODO FP16
  val dataWidth = numLanes * wordSize // TODO FP16

  val io = IO(new Bundle {
    val initiate = Flipped(Decoupled(new Bundle {
      val wid = UInt(numWarpBits.W)
    }))
    val writeback = Decoupled(new Bundle {
      val wid = UInt(numWarpBits.W)
      val last = Bool()
    })
    val respA = Flipped(Decoupled(new TensorMemResp(dataWidth)))
    val respB = Flipped(Decoupled(new TensorMemResp(dataWidth)))
    val reqA = Decoupled(new TensorMemReq)
    val reqB = Decoupled(new TensorMemReq)
  })
  dontTouch(io)

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
  val set = RegInit(0.U(setBits.W))
  val step = RegInit(0.U(stepBits.W))

  when(io.initiate.fire) {
    val wid = io.initiate.bits.wid
    busy := true.B
    warpReg := wid
    set := 0.U
    step := 0.U
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

  // set/step sequencing logic
  val nextStep = true.B // TODO
  val lastSet = ((1 << setBits) - 1)
  val lastStep = ((1 << stepBits) - 1)
  val setDone = (set === lastSet.U)
  val stepDone = (step === lastStep.U)
  when (nextStep) {
    step := (step + 1.U) & lastStep.U
    when (stepDone) {
      set  := (set + 1.U)  & lastSet.U
    }
  }

  // state transition logic
  switch(state) {
    is(TensorState.idle) {
      when(io.initiate.fire) {
        state := TensorState.run
      }
    }
    is(TensorState.run) {
      when (setDone && stepDone && nextStep) {
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

  io.initiate.ready := !busy
  io.writeback.valid := (state === TensorState.finish)
  io.writeback.bits.wid := warpReg
  io.writeback.bits.last := false.B // TODO

  // Writeback queues
  // ----------------
  // These queues hold the metadata necessary for register
  // writeback.

  // val queueDepth = 2
  // val widQueue = Queue(io.initiate, queueDepth, pipe = (queueDepth == 1))
  // val rdQueue = Queue(io.initiate, queueDepth, pipe = (queueDepth == 1))

  // FIXME
  io.respA.ready := true.B
  io.respB.ready := true.B
  io.reqA.valid := false.B
  io.reqB.valid := false.B
  io.reqA.bits := DontCare
  io.reqB.bits := DontCare
}

class TensorMemReq extends Bundle {
  // TODO: tag
  val address = UInt(32.W)
}
class TensorMemResp(val dataWidth: Int) extends Bundle {
  // TODO: tag
  val data = UInt(32.W)
}

// synthesizable unit tests

class TensorCoreDecoupledTest(timeout: Int = 500000)(implicit p: Parameters)
    extends UnitTest(timeout) {
  val dut = Module(new TensorCoreDecoupled(8, 8, TensorTilingParams()))
  dut.io.initiate.valid := io.start
  dut.io.initiate.bits.wid := 0.U
  // TODO
  dut.io.respA.valid := false.B
  dut.io.respA.bits := DontCare
  dut.io.respB.valid := false.B
  dut.io.respB.bits := DontCare
  dut.io.reqA.ready := true.B
  dut.io.reqB.ready := true.B
  dut.io.writeback.ready := true.B

  io.finished := dut.io.writeback.valid
}
