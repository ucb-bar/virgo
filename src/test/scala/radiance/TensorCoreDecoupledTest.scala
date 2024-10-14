package radiance.core

import chisel3._
import chisel3.util._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class TensorCoreDecoupledTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "TensorCoreDecoupled"

  it should "do the right thing" in {
    test(new TensorCoreDecoupled(8, 8))
      { c =>
        c.io.initiate.valid.poke(true.B)
        c.io.dataA.valid.poke(false.B)
        c.io.dataA.bits.data.poke(0.U)
        c.io.dataB.valid.poke(false.B)
        c.io.dataB.bits.data.poke(0.U)
        c.clock.step()
        c.io.writeback.valid.expect(true.B)
      }
  }
}
