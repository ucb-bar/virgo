package radiance.core

import chisel3._
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
      // .withAnnotations(Seq(VerilatorBackendAnnotation, WriteFstAnnotation))
      // .withAnnotations(Seq(WriteVcdAnnotation))
      { c =>
        c.io.in.valid.poke(true.B)
        c.io.in.bits.a(0).poke(0x40000000L.U(64.W))
        c.io.in.bits.a(1).poke(0x40000000L.U(64.W))
        c.io.in.bits.a(2).poke(0x40000000L.U(64.W))
        c.io.in.bits.a(3).poke(0x40000000L.U(64.W))
        c.io.in.bits.b(0).poke(0x40000000L.U(64.W))
        c.io.in.bits.b(1).poke(0x40000000L.U(64.W))
        c.io.in.bits.b(2).poke(0x40000000L.U(64.W))
        c.io.in.bits.b(3).poke(0x40000000L.U(64.W))
        c.clock.step()
        c.io.in.valid.poke(false.B)
        c.clock.step()
        c.clock.step()
        c.io.out.valid.expect(true.B)
        c.io.out.bits.data.expect(0x40e00000L.U)
        c.clock.step()
        c.io.out.valid.expect(false.B)
      }
  }
}

