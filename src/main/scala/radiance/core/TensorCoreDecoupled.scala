// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.core

import chisel3._
import chisel3.util._
import org.chipsalliance.cde.config.Parameters
import org.chipsalliance.diplomacy.lazymodule.{LazyModule, LazyModuleImp}
import freechips.rocketchip.tilelink._
import freechips.rocketchip.diplomacy.AddressSet
import freechips.rocketchip.unittest.{UnitTest, UnitTestModule}

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

// wraps TensorCoreDecoupled with TileLink client node for use in a Diplomacy
// network.
class TensorCoreDecoupledTL(implicit p: Parameters) extends LazyModule {
  val node = TLClientNode(Seq(TLMasterPortParameters.v2(
    Seq(TLMasterParameters.v2(
      name = "TensorCoreDecoupledClientNode",
      // sourceId : TODO
    ))
  )))

  lazy val module = new TensorCoreDecoupledTLImp(this)
}

class TensorCoreDecoupledTLImp(outer: TensorCoreDecoupledTL)
    extends LazyModuleImp(outer) with UnitTestModule {
  val tensor = Module(new TensorCoreDecoupled(8, 8, TensorTilingParams()))

  require(outer.node.out.length == 1)

  val (tlOut, edge) = outer.node.out(0)
  tlOut.a.valid := tensor.io.reqA.valid
  tlOut.a.bits.address := tensor.io.reqA.bits.address
  tlOut.a.bits.source := 0.U // TODO: tensor.io.reqA.bits.source
  tensor.io.respA.valid := tlOut.d.valid
  tensor.io.respA.bits.data := tlOut.d.bits.data
  // TODO: tensor.io.respA.bits.source := tlOut.d.bits.source

  tensor.io.initiate.valid := io.start
  tensor.io.initiate.bits.wid := 0.U
  // TODO
  tensor.io.respA.valid := false.B
  tensor.io.respA.bits := DontCare
  tensor.io.respB.valid := false.B
  tensor.io.respB.bits := DontCare
  tensor.io.reqA.ready := true.B
  tensor.io.reqB.ready := true.B
  tensor.io.writeback.ready := true.B

  io.finished := tensor.io.writeback.valid
}

// a minimal Diplomacy graph with a tensor core and a TLRAM
class TensorCoreDecoupledTLRAM(implicit p: Parameters) extends LazyModule {
  val tensor = LazyModule(new TensorCoreDecoupledTL)
  val ram = LazyModule(new TLRAM(
    address = AddressSet(0x0000, 0xffffff),
    beatBytes = 32 // FIXME: hardcoded
  ))

  ram.node :=* tensor.node

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
