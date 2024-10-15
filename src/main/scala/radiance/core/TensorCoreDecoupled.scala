// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.core

import chisel3._
import chisel3.util._

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

  // TODO: just transition every cycle for now
  def nextState(state: TensorState.Type) = state match {
    case TensorState.idle      => Mux(io.initiate.fire, TensorState.run, state)
    case TensorState.run  => TensorState.finish
    case TensorState.finish => {
      // hold until writeback is cleared
      Mux(io.writeback.ready, TensorState.idle, state)
    }
    case _ => TensorState.idle
  }
  state := nextState(state)

  // state table for every warp id
  // sets: k iteration
  val numSets = (tilingParams.k / tilingParams.kc)
  val setBits = log2Ceil(numSets)
  // steps: i-j iteration
  val numSteps = (tilingParams.m * tilingParams.n) / (tilingParams.mc * tilingParams.nc)
  val stepBits = log2Ceil(numSteps)
  val setReg = RegInit(0.U(setBits.W))
  val stepReg = RegInit(0.U(setBits.W))
  // val tableRow = Valid(new Bundle {
  //   val set = UInt(setBits.W)
  //   val step = UInt(stepBits.W)
  // })

  when(io.initiate.fire) {
    val wid = io.initiate.bits.wid
    busy := true.B
    warpReg := wid
    setReg := 0.U
    stepReg := 0.U
    when(io.writeback.fire) {
      assert(io.writeback.bits.wid =/= wid,
        "unsupported concurrent initiate and writeback to the same warp")
    }
  }
  when (io.writeback.fire) {
    busy := false.B
  }

  io.initiate.ready := !busy

  // Writeback queues
  // ----------------
  // These queues hold the metadata necessary for register
  // writeback.

  // val queueDepth = 2
  // val widQueue = Queue(io.initiate, queueDepth, pipe = (queueDepth == 1))
  // val rdQueue = Queue(io.initiate, queueDepth, pipe = (queueDepth == 1))

  // Output logic
  // ------------

  io.writeback.valid := (state === TensorState.finish)
  io.writeback.bits.wid := warpReg
  io.writeback.bits.last := false.B // TODO

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
