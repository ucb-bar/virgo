package radiance.core

import chisel3._
import chisel3.stage.PrintFullStackTraceAnnotation
import chisel3.util._
import chiseltest._
import chiseltest.simulator.VerilatorFlags
import org.scalatest.flatspec.AnyFlatSpec

class MulAddTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "MulAddRecFNPipe"

  it should "do basic arithmetic" in {
    test(new MulAddRecFNPipe(2, 8, 23))
      // .withAnnotations(Seq(WriteVcdAnnotation))
      { c =>
        c.io.validin.poke(true.B)
        // 0: MADD
        // 1: MSUB
        // 2: NMSUB
        // 3: NMADD
        c.io.op.poke(0.U)
        // rounding mode (p.113 of spec)
        // 0: round to nearest, ties to even
        c.io.roundingMode.poke(0.U)
        c.io.detectTininess.poke(hardfloat.consts.tininess_beforeRounding)
        c.io.a.poke(0x3f800000.U/*2.0*/)
        c.io.b.poke(0x3f800000.U/*3.0*/)
        c.io.c.poke(0x00000000.U/*0.0*/)
        c.clock.step()
        c.io.validin.poke(false.B)
        c.io.validout.expect(false.B)
        c.clock.step()
        c.io.validout.expect(true.B)
        c.io.out.expect(0x40c00000.U/*6.0*/)
        c.clock.step()
        c.io.validout.expect(false.B)
      }
  }
}

