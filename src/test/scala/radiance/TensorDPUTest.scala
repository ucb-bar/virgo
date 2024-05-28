package radiance.core

import chisel3._
import chisel3.stage.PrintFullStackTraceAnnotation
import chisel3.util._
import chiseltest._
import chiseltest.simulator.VerilatorFlags
import org.chipsalliance.cde.config.Parameters
import freechips.rocketchip.tile
import org.scalatest.flatspec.AnyFlatSpec

class MulAddTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "MulAddRecFNPipe"

  val t = tile.FType.S
  it should "do basic arithmetic" in {
    test(new MulAddRecFNPipe(2, t.exp, t.sig))
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
        c.io.a.poke(0x3f800000.U)
        c.io.b.poke(0x3f800000.U)
        c.io.c.poke(0x00000000.U)
        c.clock.step()
        c.io.validin.poke(false.B)
        c.io.validout.expect(false.B)
        c.clock.step()
        c.io.validout.expect(true.B)
        c.io.out.expect(0x40c00000.U)
        c.clock.step()
        c.io.validout.expect(false.B)
      }
  }
}

class DPUPipeTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "DPUPipe"

  implicit val p: Parameters = Parameters.empty

  it should "pass" in {
    test(new DPUPipe)
      // .withAnnotations(Seq(WriteVcdAnnotation))
      { fma =>
        fma.io.in.valid.poke(true.B)
        fma.io.in.bits.a.poke(0x40000000L.U(64.W))
        fma.io.in.bits.b.poke(0x40400000L.U(64.W))
        fma.io.in.bits.c.poke(0x3f800000L.U(64.W))
        fma.clock.step()
        fma.io.in.valid.poke(true.B)
        fma.io.in.bits.a.poke(0x40000000L.U(64.W))
        fma.io.in.bits.b.poke(0x3f800000L.U(64.W))
        fma.io.in.bits.c.poke(0x3f800000L.U(64.W))
        fma.clock.step()
        fma.io.in.valid.poke(false.B)
        fma.io.out.valid.expect(true.B)
        fma.io.out.bits.data.expect(0x40e00000L.U)
        fma.clock.step()
        // pipelined back-to-back response
        fma.io.out.valid.expect(true.B)
        fma.io.out.bits.data.expect(0x40400000L.U)
      }
  }
}

