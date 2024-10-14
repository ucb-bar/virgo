// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.core

import chisel3._
import chisel3.util._

class TensorCoreDecoupled(val numWarps: Int, val numLanes: Int) extends Module {
  val numWarpBits = log2Ceil(numWarps)
  val wordSize = 4 // TODO FP16
  val dataWidth = numLanes * wordSize // TODO FP16

  val io = IO(new Bundle{
    val initiate = Flipped(Decoupled(new Bundle{
      val wid = UInt(numWarpBits.W)
    }))
    val dataA = Flipped(Decoupled(new TensorMemResp(dataWidth)))
    val dataB = Flipped(Decoupled(new TensorMemResp(dataWidth)))
    val addressA = Decoupled(new TensorMemReq)
    val addressB = Decoupled(new TensorMemReq)
    val writeback = Decoupled(new Bundle{
      val wid = UInt(numWarpBits.W)
      val last = Bool()
    })
  })

  // FSM
  //
  val state = RegInit(TensorState.idle)
  // TODO: just transition every cycle for now
  state := (state match {
    case TensorState.idle => Mux(io.initiate.fire, TensorState.smemRead, state)
    case TensorState.smemRead => TensorState.compute
    case TensorState.compute => TensorState.writeback
    case TensorState.writeback => {
      // hold until writeback is cleared
      Mux(io.writeback.ready, TensorState.idle, state)
    }
    case _ => TensorState.idle
  })

  // TODO
  io.dataA.ready := true.B
  io.dataB.ready := true.B
  io.addressA.valid := false.B
  io.addressB.valid := false.B
  io.addressA.bits := DontCare
  io.addressB.bits := DontCare
  io.initiate.ready := true.B
  io.writeback.valid := true.B
  io.writeback.bits := DontCare
}

class TensorMemReq extends Bundle {
  // TODO: tag
  val address = UInt(32.W)
}
class TensorMemResp(val dataWidth: Int) extends Bundle {
  // TODO: tag
  val data = UInt(32.W)
}


object TensorState extends ChiselEnum {
  val idle      = Value(0.U)
  val smemRead  = Value(1.U)
  val compute   = Value(2.U)
  val writeback = Value(3.U)
}
