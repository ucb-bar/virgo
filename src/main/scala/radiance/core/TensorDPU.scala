// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.core

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile

class DPUPipe extends Module with tile.HasFPUParameters {
  val fLen = 32
  val minFLen = 32
  def xLen = 32

  val io = IO(new Bundle {
    val in = Flipped(Valid(new Bundle {
      val a = Bits((fLen).W)
      val b = Bits((fLen).W)
      val c = Bits((fLen).W)
    }))
    val out = Valid(new Bundle {
      val data = Bits((fLen+1).W)
    })
  })

  val t = tile.FType.S

  val in1 = recode(io.in.bits.a, S)
  val in2 = recode(io.in.bits.b, S)
  val in3 = recode(io.in.bits.c, S)

  val fma = Module(new MulAddRecFNPipe(2, t.exp, t.sig))
  fma.io.validin := io.in.valid
  fma.io.op := 0.U // FIXME
  fma.io.roundingMode := 0.U // FIXME
  fma.io.detectTininess := hardfloat.consts.tininess_afterRounding
  fma.io.a := unbox(in1, S, Some(tile.FType.S))
  fma.io.b := unbox(in2, S, Some(tile.FType.S))
  fma.io.c := unbox(in3, S, Some(tile.FType.S))

  io.out.valid := fma.io.validout
  io.out.bits.data := ieee(box(fma.io.out, S))
}

class MulAddRecFNPipe(latency: Int, expWidth: Int, sigWidth: Int) extends Module {
  require(latency <= 2)

  val io = IO(new Bundle {
    val validin = Input(Bool())
    val op = Input(Bits(2.W))
    val a = Input(Bits((expWidth + sigWidth + 1).W))
    val b = Input(Bits((expWidth + sigWidth + 1).W))
    val c = Input(Bits((expWidth + sigWidth + 1).W))
    val roundingMode   = Input(UInt(3.W))
    val detectTininess = Input(UInt(1.W))
    val out = Output(Bits((expWidth + sigWidth + 1).W))
    val exceptionFlags = Output(Bits(5.W))
    val validout = Output(Bool())
  })

  //------------------------------------------------------------------------
  //------------------------------------------------------------------------

  val mulAddRecFNToRaw_preMul = Module(new hardfloat.MulAddRecFNToRaw_preMul(expWidth, sigWidth))
  val mulAddRecFNToRaw_postMul = Module(new hardfloat.MulAddRecFNToRaw_postMul(expWidth, sigWidth))

  mulAddRecFNToRaw_preMul.io.op := io.op
  mulAddRecFNToRaw_preMul.io.a  := io.a
  mulAddRecFNToRaw_preMul.io.b  := io.b
  mulAddRecFNToRaw_preMul.io.c  := io.c

  val mulAddResult =
      (mulAddRecFNToRaw_preMul.io.mulAddA *
           mulAddRecFNToRaw_preMul.io.mulAddB) +&
          mulAddRecFNToRaw_preMul.io.mulAddC

  val valid_stage0 = Wire(Bool())
  val roundingMode_stage0 = Wire(UInt(3.W))
  val detectTininess_stage0 = Wire(UInt(1.W))

  val postmul_regs = if(latency>0) 1 else 0
  mulAddRecFNToRaw_postMul.io.fromPreMul   := Pipe(io.validin, mulAddRecFNToRaw_preMul.io.toPostMul, postmul_regs).bits
  mulAddRecFNToRaw_postMul.io.mulAddResult := Pipe(io.validin, mulAddResult, postmul_regs).bits
  mulAddRecFNToRaw_postMul.io.roundingMode := Pipe(io.validin, io.roundingMode, postmul_regs).bits
  roundingMode_stage0                      := Pipe(io.validin, io.roundingMode, postmul_regs).bits
  detectTininess_stage0                    := Pipe(io.validin, io.detectTininess, postmul_regs).bits
  valid_stage0                             := Pipe(io.validin, false.B, postmul_regs).valid

  //------------------------------------------------------------------------
  //------------------------------------------------------------------------

  val roundRawFNToRecFN = Module(new hardfloat.RoundRawFNToRecFN(expWidth, sigWidth, 0))

  val round_regs = if(latency==2) 1 else 0
  roundRawFNToRecFN.io.invalidExc         := Pipe(valid_stage0, mulAddRecFNToRaw_postMul.io.invalidExc, round_regs).bits
  roundRawFNToRecFN.io.in                 := Pipe(valid_stage0, mulAddRecFNToRaw_postMul.io.rawOut, round_regs).bits
  roundRawFNToRecFN.io.roundingMode       := Pipe(valid_stage0, roundingMode_stage0, round_regs).bits
  roundRawFNToRecFN.io.detectTininess     := Pipe(valid_stage0, detectTininess_stage0, round_regs).bits
  io.validout                             := Pipe(valid_stage0, false.B, round_regs).valid

  roundRawFNToRecFN.io.infiniteExc := false.B

  io.out            := roundRawFNToRecFN.io.out
  io.exceptionFlags := roundRawFNToRecFN.io.exceptionFlags
}
