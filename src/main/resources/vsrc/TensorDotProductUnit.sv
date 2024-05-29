module MulFullRawFN( // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 47:7]
  input         io_a_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_a_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_a_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_a_sign, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input  [9:0]  io_a_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input  [24:0] io_a_sig, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_b_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_b_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_b_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_b_sign, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input  [9:0]  io_b_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input  [24:0] io_b_sig, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output        io_invalidExc, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output        io_rawOut_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output        io_rawOut_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output        io_rawOut_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output        io_rawOut_sign, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output [9:0]  io_rawOut_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output [47:0] io_rawOut_sig // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
);
  wire  notSigNaN_invalidExc = io_a_isInf & io_b_isZero | io_a_isZero & io_b_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 58:60]
  wire [9:0] _common_sExpOut_T_2 = $signed(io_a_sExp) + $signed(io_b_sExp); // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 62:36]
  wire [49:0] _common_sigOut_T = io_a_sig * io_b_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 63:35]
  wire  _io_invalidExc_T_2 = io_a_isNaN & ~io_a_sig[22]; // @[generators/hardfloat/hardfloat/src/main/scala/common.scala 82:46]
  wire  _io_invalidExc_T_5 = io_b_isNaN & ~io_b_sig[22]; // @[generators/hardfloat/hardfloat/src/main/scala/common.scala 82:46]
  assign io_invalidExc = _io_invalidExc_T_2 | _io_invalidExc_T_5 | notSigNaN_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 66:71]
  assign io_rawOut_isNaN = io_a_isNaN | io_b_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 70:35]
  assign io_rawOut_isInf = io_a_isInf | io_b_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 59:38]
  assign io_rawOut_isZero = io_a_isZero | io_b_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 60:40]
  assign io_rawOut_sign = io_a_sign ^ io_b_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 61:36]
  assign io_rawOut_sExp = $signed(_common_sExpOut_T_2) - 10'sh100; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 62:48]
  assign io_rawOut_sig = _common_sigOut_T[47:0]; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 63:46]
endmodule
module MulRawFN( // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 75:7]
  input         io_a_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input         io_a_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input         io_a_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input         io_a_sign, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input  [9:0]  io_a_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input  [24:0] io_a_sig, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input         io_b_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input         io_b_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input         io_b_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input         io_b_sign, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input  [9:0]  io_b_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  input  [24:0] io_b_sig, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  output        io_invalidExc, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  output        io_rawOut_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  output        io_rawOut_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  output        io_rawOut_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  output        io_rawOut_sign, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  output [9:0]  io_rawOut_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
  output [26:0] io_rawOut_sig // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 77:16]
);
  wire  mulFullRaw_io_a_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire [9:0] mulFullRaw_io_a_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire [24:0] mulFullRaw_io_a_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire [9:0] mulFullRaw_io_b_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire [24:0] mulFullRaw_io_b_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire [9:0] mulFullRaw_io_rawOut_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  wire [47:0] mulFullRaw_io_rawOut_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
  MulFullRawFN mulFullRaw ( // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 84:28]
    .io_a_isNaN(mulFullRaw_io_a_isNaN),
    .io_a_isInf(mulFullRaw_io_a_isInf),
    .io_a_isZero(mulFullRaw_io_a_isZero),
    .io_a_sign(mulFullRaw_io_a_sign),
    .io_a_sExp(mulFullRaw_io_a_sExp),
    .io_a_sig(mulFullRaw_io_a_sig),
    .io_b_isNaN(mulFullRaw_io_b_isNaN),
    .io_b_isInf(mulFullRaw_io_b_isInf),
    .io_b_isZero(mulFullRaw_io_b_isZero),
    .io_b_sign(mulFullRaw_io_b_sign),
    .io_b_sExp(mulFullRaw_io_b_sExp),
    .io_b_sig(mulFullRaw_io_b_sig),
    .io_invalidExc(mulFullRaw_io_invalidExc),
    .io_rawOut_isNaN(mulFullRaw_io_rawOut_isNaN),
    .io_rawOut_isInf(mulFullRaw_io_rawOut_isInf),
    .io_rawOut_isZero(mulFullRaw_io_rawOut_isZero),
    .io_rawOut_sign(mulFullRaw_io_rawOut_sign),
    .io_rawOut_sExp(mulFullRaw_io_rawOut_sExp),
    .io_rawOut_sig(mulFullRaw_io_rawOut_sig)
  );
  assign io_invalidExc = mulFullRaw_io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 89:19]
  assign io_rawOut_isNaN = mulFullRaw_io_rawOut_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 90:15]
  assign io_rawOut_isInf = mulFullRaw_io_rawOut_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 90:15]
  assign io_rawOut_isZero = mulFullRaw_io_rawOut_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 90:15]
  assign io_rawOut_sign = mulFullRaw_io_rawOut_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 90:15]
  assign io_rawOut_sExp = mulFullRaw_io_rawOut_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 90:15]
  assign io_rawOut_sig = {mulFullRaw_io_rawOut_sig[47:22],|mulFullRaw_io_rawOut_sig[21:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 93:10]
  assign mulFullRaw_io_a_isNaN = io_a_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_isInf = io_a_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_isZero = io_a_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_sign = io_a_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_sExp = io_a_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_sig = io_a_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 86:21]
  assign mulFullRaw_io_b_isNaN = io_b_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_isInf = io_b_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_isZero = io_b_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_sign = io_b_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_sExp = io_b_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_sig = io_b_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 87:21]
endmodule
module RoundAnyRawFNToRecFN( // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 48:5]
  input         io_invalidExc, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 57:16]
  input         io_in_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 57:16]
  input         io_in_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 57:16]
  input         io_in_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 57:16]
  input         io_in_sign, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 57:16]
  input  [9:0]  io_in_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 57:16]
  input  [26:0] io_in_sig, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 57:16]
  output [32:0] io_out // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 57:16]
);
  wire  doShiftSigDown1 = io_in_sig[26]; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 119:57]
  wire [8:0] _roundMask_T_1 = ~io_in_sExp[8:0]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 52:21]
  wire  roundMask_msb = _roundMask_T_1[8]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 58:25]
  wire [7:0] roundMask_lsbs = _roundMask_T_1[7:0]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 59:26]
  wire  roundMask_msb_1 = roundMask_lsbs[7]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 58:25]
  wire [6:0] roundMask_lsbs_1 = roundMask_lsbs[6:0]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 59:26]
  wire  roundMask_msb_2 = roundMask_lsbs_1[6]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 58:25]
  wire [5:0] roundMask_lsbs_2 = roundMask_lsbs_1[5:0]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 59:26]
  wire [64:0] roundMask_shift = 65'sh10000000000000000 >>> roundMask_lsbs_2; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 76:56]
  wire [15:0] _GEN_0 = {{8'd0}, roundMask_shift[57:50]}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_7 = _GEN_0 & 16'hff; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_9 = {roundMask_shift[49:42], 8'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_11 = _roundMask_T_9 & 16'hff00; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_12 = _roundMask_T_7 | _roundMask_T_11; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _GEN_1 = {{4'd0}, _roundMask_T_12[15:4]}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_17 = _GEN_1 & 16'hf0f; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_19 = {_roundMask_T_12[11:0], 4'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_21 = _roundMask_T_19 & 16'hf0f0; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_22 = _roundMask_T_17 | _roundMask_T_21; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _GEN_2 = {{2'd0}, _roundMask_T_22[15:2]}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_27 = _GEN_2 & 16'h3333; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_29 = {_roundMask_T_22[13:0], 2'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_31 = _roundMask_T_29 & 16'hcccc; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_32 = _roundMask_T_27 | _roundMask_T_31; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _GEN_3 = {{1'd0}, _roundMask_T_32[15:1]}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_37 = _GEN_3 & 16'h5555; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_39 = {_roundMask_T_32[14:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_41 = _roundMask_T_39 & 16'haaaa; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [15:0] _roundMask_T_42 = _roundMask_T_37 | _roundMask_T_41; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [21:0] _roundMask_T_59 = {_roundMask_T_42,roundMask_shift[58],roundMask_shift[59],roundMask_shift[60],
    roundMask_shift[61],roundMask_shift[62],roundMask_shift[63]}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [21:0] _roundMask_T_60 = ~_roundMask_T_59; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 73:32]
  wire [21:0] _roundMask_T_61 = roundMask_msb_2 ? 22'h0 : _roundMask_T_60; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 73:21]
  wire [21:0] _roundMask_T_62 = ~_roundMask_T_61; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 73:17]
  wire [24:0] _roundMask_T_63 = {_roundMask_T_62,3'h7}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 68:58]
  wire [2:0] _roundMask_T_70 = {roundMask_shift[0],roundMask_shift[1],roundMask_shift[2]}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [2:0] _roundMask_T_71 = roundMask_msb_2 ? _roundMask_T_70 : 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 62:24]
  wire [24:0] _roundMask_T_72 = roundMask_msb_1 ? _roundMask_T_63 : {{22'd0}, _roundMask_T_71}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 67:24]
  wire [24:0] _roundMask_T_73 = roundMask_msb ? _roundMask_T_72 : 25'h0; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 62:24]
  wire [24:0] _GEN_4 = {{24'd0}, doShiftSigDown1}; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 158:23]
  wire [24:0] _roundMask_T_74 = _roundMask_T_73 | _GEN_4; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 158:23]
  wire [26:0] roundMask = {_roundMask_T_74,2'h3}; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 158:42]
  wire [27:0] _shiftedRoundMask_T = {1'h0,_roundMask_T_74,2'h3}; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 161:41]
  wire [26:0] shiftedRoundMask = _shiftedRoundMask_T[27:1]; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 161:53]
  wire [26:0] _roundPosMask_T = ~shiftedRoundMask; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 162:28]
  wire [26:0] roundPosMask = _roundPosMask_T & roundMask; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 162:46]
  wire [26:0] _roundPosBit_T = io_in_sig & roundPosMask; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 163:40]
  wire  roundPosBit = |_roundPosBit_T; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 163:56]
  wire [26:0] _anyRoundExtra_T = io_in_sig & shiftedRoundMask; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 164:42]
  wire  anyRoundExtra = |_anyRoundExtra_T; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 164:62]
  wire [26:0] _roundedSig_T = io_in_sig | roundMask; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 173:32]
  wire [25:0] _roundedSig_T_2 = _roundedSig_T[26:2] + 25'h1; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 173:49]
  wire  _roundedSig_T_4 = ~anyRoundExtra; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 175:30]
  wire [25:0] _roundedSig_T_7 = roundPosBit & _roundedSig_T_4 ? roundMask[26:1] : 26'h0; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 174:25]
  wire [25:0] _roundedSig_T_8 = ~_roundedSig_T_7; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 174:21]
  wire [25:0] _roundedSig_T_9 = _roundedSig_T_2 & _roundedSig_T_8; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 173:57]
  wire [26:0] _roundedSig_T_10 = ~roundMask; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 179:32]
  wire [26:0] _roundedSig_T_11 = io_in_sig & _roundedSig_T_10; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 179:30]
  wire [25:0] _roundedSig_T_16 = {{1'd0}, _roundedSig_T_11[26:2]}; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 179:47]
  wire [25:0] roundedSig = roundPosBit ? _roundedSig_T_9 : _roundedSig_T_16; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 172:16]
  wire [2:0] _sRoundedExp_T_1 = {1'b0,$signed(roundedSig[25:24])}; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 184:76]
  wire [9:0] _GEN_5 = {{7{_sRoundedExp_T_1[2]}},_sRoundedExp_T_1}; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 184:40]
  wire [10:0] sRoundedExp = $signed(io_in_sExp) + $signed(_GEN_5); // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 184:40]
  wire [8:0] common_expOut = sRoundedExp[8:0]; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 186:37]
  wire [22:0] common_fractOut = doShiftSigDown1 ? roundedSig[23:1] : roundedSig[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 188:16]
  wire [3:0] _common_overflow_T = sRoundedExp[10:7]; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 195:30]
  wire  common_overflow = $signed(_common_overflow_T) >= 4'sh3; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 195:50]
  wire  common_totalUnderflow = $signed(sRoundedExp) < 11'sh6b; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 199:31]
  wire  isNaNOut = io_invalidExc | io_in_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 234:34]
  wire  commonCase = ~isNaNOut & ~io_in_isInf & ~io_in_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 236:61]
  wire  overflow = commonCase & common_overflow; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 237:32]
  wire  notNaN_isInfOut = io_in_isInf | overflow; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 247:32]
  wire  signOut = isNaNOut ? 1'h0 : io_in_sign; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 249:22]
  wire [8:0] _expOut_T_1 = io_in_isZero | common_totalUnderflow ? 9'h1c0 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 252:18]
  wire [8:0] _expOut_T_2 = ~_expOut_T_1; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 252:14]
  wire [8:0] _expOut_T_3 = common_expOut & _expOut_T_2; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 251:24]
  wire [8:0] _expOut_T_11 = notNaN_isInfOut ? 9'h40 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 264:18]
  wire [8:0] _expOut_T_12 = ~_expOut_T_11; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 264:14]
  wire [8:0] _expOut_T_13 = _expOut_T_3 & _expOut_T_12; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 263:17]
  wire [8:0] _expOut_T_18 = notNaN_isInfOut ? 9'h180 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 276:16]
  wire [8:0] _expOut_T_19 = _expOut_T_13 | _expOut_T_18; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 275:15]
  wire [8:0] _expOut_T_20 = isNaNOut ? 9'h1c0 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 277:16]
  wire [8:0] expOut = _expOut_T_19 | _expOut_T_20; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 276:73]
  wire [22:0] _fractOut_T_2 = isNaNOut ? 23'h400000 : 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 280:16]
  wire [22:0] fractOut = isNaNOut | io_in_isZero | common_totalUnderflow ? _fractOut_T_2 : common_fractOut; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 279:12]
  wire [9:0] _io_out_T = {signOut,expOut}; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 285:23]
  assign io_out = {_io_out_T,fractOut}; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 285:33]
endmodule
module RoundRawFNToRecFN( // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 294:5]
  input         io_invalidExc, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 297:16]
  input         io_in_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 297:16]
  input         io_in_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 297:16]
  input         io_in_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 297:16]
  input         io_in_sign, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 297:16]
  input  [9:0]  io_in_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 297:16]
  input  [26:0] io_in_sig, // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 297:16]
  output [32:0] io_out // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 297:16]
);
  wire  roundAnyRawFNToRecFN_io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 308:15]
  wire  roundAnyRawFNToRecFN_io_in_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 308:15]
  wire  roundAnyRawFNToRecFN_io_in_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 308:15]
  wire  roundAnyRawFNToRecFN_io_in_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 308:15]
  wire  roundAnyRawFNToRecFN_io_in_sign; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 308:15]
  wire [9:0] roundAnyRawFNToRecFN_io_in_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 308:15]
  wire [26:0] roundAnyRawFNToRecFN_io_in_sig; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 308:15]
  wire [32:0] roundAnyRawFNToRecFN_io_out; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 308:15]
  RoundAnyRawFNToRecFN roundAnyRawFNToRecFN ( // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 308:15]
    .io_invalidExc(roundAnyRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundAnyRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundAnyRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundAnyRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundAnyRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundAnyRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundAnyRawFNToRecFN_io_in_sig),
    .io_out(roundAnyRawFNToRecFN_io_out)
  );
  assign io_out = roundAnyRawFNToRecFN_io_out; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 316:23]
  assign roundAnyRawFNToRecFN_io_invalidExc = io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 311:44]
  assign roundAnyRawFNToRecFN_io_in_isNaN = io_in_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_isInf = io_in_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_isZero = io_in_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_sign = io_in_sign; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_sExp = io_in_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_sig = io_in_sig; // @[generators/hardfloat/hardfloat/src/main/scala/RoundAnyRawFNToRecFN.scala 313:44]
endmodule
module MulRecFN( // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 100:7]
  input  [32:0] io_a, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 102:16]
  input  [32:0] io_b, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 102:16]
  output [32:0] io_out // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 102:16]
);
  wire  mulRawFN__io_a_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_a_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_a_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_a_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire [9:0] mulRawFN__io_a_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire [24:0] mulRawFN__io_a_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire [9:0] mulRawFN__io_b_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire [24:0] mulRawFN__io_b_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire [9:0] mulRawFN__io_rawOut_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire [26:0] mulRawFN__io_rawOut_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
  wire  roundRawFNToRecFN_io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 121:15]
  wire [9:0] roundRawFNToRecFN_io_in_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 121:15]
  wire [26:0] roundRawFNToRecFN_io_in_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 121:15]
  wire [32:0] roundRawFNToRecFN_io_out; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 121:15]
  wire [8:0] mulRawFN_io_a_exp = io_a[31:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  mulRawFN_io_a_isZero = mulRawFN_io_a_exp[8:6] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  mulRawFN_io_a_isSpecial = mulRawFN_io_a_exp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  _mulRawFN_io_a_out_sig_T = ~mulRawFN_io_a_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [1:0] _mulRawFN_io_a_out_sig_T_1 = {1'h0,_mulRawFN_io_a_out_sig_T}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:32]
  wire [8:0] mulRawFN_io_b_exp = io_b[31:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  mulRawFN_io_b_isZero = mulRawFN_io_b_exp[8:6] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  mulRawFN_io_b_isSpecial = mulRawFN_io_b_exp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  _mulRawFN_io_b_out_sig_T = ~mulRawFN_io_b_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [1:0] _mulRawFN_io_b_out_sig_T_1 = {1'h0,_mulRawFN_io_b_out_sig_T}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:32]
  MulRawFN mulRawFN_ ( // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 113:26]
    .io_a_isNaN(mulRawFN__io_a_isNaN),
    .io_a_isInf(mulRawFN__io_a_isInf),
    .io_a_isZero(mulRawFN__io_a_isZero),
    .io_a_sign(mulRawFN__io_a_sign),
    .io_a_sExp(mulRawFN__io_a_sExp),
    .io_a_sig(mulRawFN__io_a_sig),
    .io_b_isNaN(mulRawFN__io_b_isNaN),
    .io_b_isInf(mulRawFN__io_b_isInf),
    .io_b_isZero(mulRawFN__io_b_isZero),
    .io_b_sign(mulRawFN__io_b_sign),
    .io_b_sExp(mulRawFN__io_b_sExp),
    .io_b_sig(mulRawFN__io_b_sig),
    .io_invalidExc(mulRawFN__io_invalidExc),
    .io_rawOut_isNaN(mulRawFN__io_rawOut_isNaN),
    .io_rawOut_isInf(mulRawFN__io_rawOut_isInf),
    .io_rawOut_isZero(mulRawFN__io_rawOut_isZero),
    .io_rawOut_sign(mulRawFN__io_rawOut_sign),
    .io_rawOut_sExp(mulRawFN__io_rawOut_sExp),
    .io_rawOut_sig(mulRawFN__io_rawOut_sig)
  );
  RoundRawFNToRecFN roundRawFNToRecFN ( // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 121:15]
    .io_invalidExc(roundRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundRawFNToRecFN_io_in_sig),
    .io_out(roundRawFNToRecFN_io_out)
  );
  assign io_out = roundRawFNToRecFN_io_out; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 127:23]
  assign mulRawFN__io_a_isNaN = mulRawFN_io_a_isSpecial & mulRawFN_io_a_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  assign mulRawFN__io_a_isInf = mulRawFN_io_a_isSpecial & ~mulRawFN_io_a_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  assign mulRawFN__io_a_isZero = mulRawFN_io_a_exp[8:6] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  assign mulRawFN__io_a_sign = io_a[32]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  assign mulRawFN__io_a_sExp = {1'b0,$signed(mulRawFN_io_a_exp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  assign mulRawFN__io_a_sig = {_mulRawFN_io_a_out_sig_T_1,io_a[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  assign mulRawFN__io_b_isNaN = mulRawFN_io_b_isSpecial & mulRawFN_io_b_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  assign mulRawFN__io_b_isInf = mulRawFN_io_b_isSpecial & ~mulRawFN_io_b_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  assign mulRawFN__io_b_isZero = mulRawFN_io_b_exp[8:6] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  assign mulRawFN__io_b_sign = io_b[32]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  assign mulRawFN__io_b_sExp = {1'b0,$signed(mulRawFN_io_b_exp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  assign mulRawFN__io_b_sig = {_mulRawFN_io_b_out_sig_T_1,io_b[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  assign roundRawFNToRecFN_io_invalidExc = mulRawFN__io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 122:39]
  assign roundRawFNToRecFN_io_in_isNaN = mulRawFN__io_rawOut_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_isInf = mulRawFN__io_rawOut_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_isZero = mulRawFN__io_rawOut_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sign = mulRawFN__io_rawOut_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sExp = mulRawFN__io_rawOut_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sig = mulRawFN__io_rawOut_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 124:39]
endmodule
module AddRawFN( // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 47:7]
  input         io_a_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input         io_a_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input         io_a_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input         io_a_sign, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input  [9:0]  io_a_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input  [24:0] io_a_sig, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input         io_b_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input         io_b_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input         io_b_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input         io_b_sign, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input  [9:0]  io_b_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  input  [24:0] io_b_sig, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  output        io_invalidExc, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  output        io_rawOut_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  output        io_rawOut_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  output        io_rawOut_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  output        io_rawOut_sign, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  output [9:0]  io_rawOut_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
  output [26:0] io_rawOut_sig // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 49:16]
);
  wire  eqSigns = io_a_sign == io_b_sign; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 61:29]
  wire [9:0] sDiffExps = $signed(io_a_sExp) - $signed(io_b_sExp); // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 63:31]
  wire  _modNatAlignDist_T = $signed(sDiffExps) < 10'sh0; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 64:41]
  wire [9:0] _modNatAlignDist_T_3 = $signed(io_b_sExp) - $signed(io_a_sExp); // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 64:58]
  wire [9:0] _modNatAlignDist_T_4 = $signed(sDiffExps) < 10'sh0 ? $signed(_modNatAlignDist_T_3) : $signed(sDiffExps); // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 64:30]
  wire [4:0] modNatAlignDist = _modNatAlignDist_T_4[4:0]; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 64:81]
  wire [4:0] _isMaxAlign_T = sDiffExps[9:5]; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 66:19]
  wire  _isMaxAlign_T_6 = $signed(_isMaxAlign_T) != -5'sh1 | sDiffExps[4:0] == 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 67:51]
  wire  isMaxAlign = $signed(_isMaxAlign_T) != 5'sh0 & _isMaxAlign_T_6; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 66:45]
  wire [4:0] alignDist = isMaxAlign ? 5'h1f : modNatAlignDist; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 68:24]
  wire  _closeSubMags_T = ~eqSigns; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 69:24]
  wire  closeSubMags = ~eqSigns & ~isMaxAlign & modNatAlignDist <= 5'h1; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 69:48]
  wire  _close_alignedSigA_T = 10'sh0 <= $signed(sDiffExps); // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 73:18]
  wire [26:0] _close_alignedSigA_T_3 = {io_a_sig, 2'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 73:58]
  wire [26:0] _close_alignedSigA_T_4 = 10'sh0 <= $signed(sDiffExps) & sDiffExps[0] ? _close_alignedSigA_T_3 : 27'h0; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 73:12]
  wire [25:0] _close_alignedSigA_T_9 = {io_a_sig, 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 74:58]
  wire [25:0] _close_alignedSigA_T_10 = _close_alignedSigA_T & ~sDiffExps[0] ? _close_alignedSigA_T_9 : 26'h0; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 74:12]
  wire [26:0] _GEN_0 = {{1'd0}, _close_alignedSigA_T_10}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 73:68]
  wire [26:0] _close_alignedSigA_T_11 = _close_alignedSigA_T_4 | _GEN_0; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 73:68]
  wire [24:0] _close_alignedSigA_T_13 = _modNatAlignDist_T ? io_a_sig : 25'h0; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 75:12]
  wire [26:0] _GEN_1 = {{2'd0}, _close_alignedSigA_T_13}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 74:68]
  wire [26:0] _close_sSigSum_T = _close_alignedSigA_T_11 | _GEN_1; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 76:43]
  wire [25:0] _close_sSigSum_T_2 = {io_b_sig, 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 76:66]
  wire [26:0] _GEN_2 = {{1{_close_sSigSum_T_2[25]}},_close_sSigSum_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 76:50]
  wire [26:0] close_sSigSum = $signed(_close_sSigSum_T) - $signed(_GEN_2); // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 76:50]
  wire  _close_sigSum_T = $signed(close_sSigSum) < 27'sh0; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 77:42]
  wire [26:0] _close_sigSum_T_3 = 27'sh0 - $signed(close_sSigSum); // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 77:49]
  wire [26:0] _close_sigSum_T_4 = $signed(close_sSigSum) < 27'sh0 ? $signed(_close_sigSum_T_3) : $signed(close_sSigSum); // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 77:27]
  wire [25:0] close_sigSum = _close_sigSum_T_4[25:0]; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 77:79]
  wire  close_reduced2SigSum_reducedVec_0 = |close_sigSum[1:0]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_1 = |close_sigSum[3:2]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_2 = |close_sigSum[5:4]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_3 = |close_sigSum[7:6]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_4 = |close_sigSum[9:8]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_5 = |close_sigSum[11:10]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_6 = |close_sigSum[13:12]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_7 = |close_sigSum[15:14]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_8 = |close_sigSum[17:16]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_9 = |close_sigSum[19:18]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_10 = |close_sigSum[21:20]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_11 = |close_sigSum[23:22]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_12 = |close_sigSum[25:24]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 106:57]
  wire [5:0] close_reduced2SigSum_lo = {close_reduced2SigSum_reducedVec_5,close_reduced2SigSum_reducedVec_4,
    close_reduced2SigSum_reducedVec_3,close_reduced2SigSum_reducedVec_2,close_reduced2SigSum_reducedVec_1,
    close_reduced2SigSum_reducedVec_0}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 107:20]
  wire [12:0] close_reduced2SigSum = {close_reduced2SigSum_reducedVec_12,close_reduced2SigSum_reducedVec_11,
    close_reduced2SigSum_reducedVec_10,close_reduced2SigSum_reducedVec_9,close_reduced2SigSum_reducedVec_8,
    close_reduced2SigSum_reducedVec_7,close_reduced2SigSum_reducedVec_6,close_reduced2SigSum_lo}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 107:20]
  wire [3:0] _close_normDistReduced2_T_13 = close_reduced2SigSum[1] ? 4'hb : 4'hc; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _close_normDistReduced2_T_14 = close_reduced2SigSum[2] ? 4'ha : _close_normDistReduced2_T_13; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _close_normDistReduced2_T_15 = close_reduced2SigSum[3] ? 4'h9 : _close_normDistReduced2_T_14; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _close_normDistReduced2_T_16 = close_reduced2SigSum[4] ? 4'h8 : _close_normDistReduced2_T_15; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _close_normDistReduced2_T_17 = close_reduced2SigSum[5] ? 4'h7 : _close_normDistReduced2_T_16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _close_normDistReduced2_T_18 = close_reduced2SigSum[6] ? 4'h6 : _close_normDistReduced2_T_17; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _close_normDistReduced2_T_19 = close_reduced2SigSum[7] ? 4'h5 : _close_normDistReduced2_T_18; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _close_normDistReduced2_T_20 = close_reduced2SigSum[8] ? 4'h4 : _close_normDistReduced2_T_19; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _close_normDistReduced2_T_21 = close_reduced2SigSum[9] ? 4'h3 : _close_normDistReduced2_T_20; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _close_normDistReduced2_T_22 = close_reduced2SigSum[10] ? 4'h2 : _close_normDistReduced2_T_21; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _close_normDistReduced2_T_23 = close_reduced2SigSum[11] ? 4'h1 : _close_normDistReduced2_T_22; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] close_normDistReduced2 = close_reduced2SigSum[12] ? 4'h0 : _close_normDistReduced2_T_23; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] close_nearNormDist = {close_normDistReduced2, 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 81:53]
  wire [56:0] _GEN_7 = {{31'd0}, close_sigSum}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 82:38]
  wire [56:0] _close_sigOut_T = _GEN_7 << close_nearNormDist; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 82:38]
  wire [57:0] _close_sigOut_T_1 = {_close_sigOut_T, 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 82:59]
  wire [26:0] close_sigOut = _close_sigOut_T_1[26:0]; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 82:63]
  wire  close_totalCancellation = ~(|close_sigOut[26:25]); // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 83:35]
  wire  close_notTotalCancellation_signOut = io_a_sign ^ _close_sigSum_T; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 84:56]
  wire  far_signOut = _modNatAlignDist_T ? io_b_sign : io_a_sign; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 87:26]
  wire [24:0] _far_sigLarger_T_1 = _modNatAlignDist_T ? io_b_sig : io_a_sig; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 88:29]
  wire [23:0] far_sigLarger = _far_sigLarger_T_1[23:0]; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 88:66]
  wire [24:0] _far_sigSmaller_T_1 = _modNatAlignDist_T ? io_a_sig : io_b_sig; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 89:29]
  wire [23:0] far_sigSmaller = _far_sigSmaller_T_1[23:0]; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 89:66]
  wire [28:0] _far_mainAlignedSigSmaller_T = {far_sigSmaller, 5'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 90:52]
  wire [28:0] far_mainAlignedSigSmaller = _far_mainAlignedSigSmaller_T >> alignDist; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 90:56]
  wire [25:0] _far_reduced4SigSmaller_T = {far_sigSmaller, 2'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 91:60]
  wire  far_reduced4SigSmaller_reducedVec_0 = |_far_reduced4SigSmaller_T[3:0]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_1 = |_far_reduced4SigSmaller_T[7:4]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_2 = |_far_reduced4SigSmaller_T[11:8]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_3 = |_far_reduced4SigSmaller_T[15:12]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_4 = |_far_reduced4SigSmaller_T[19:16]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_5 = |_far_reduced4SigSmaller_T[23:20]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_6 = |_far_reduced4SigSmaller_T[25:24]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 123:57]
  wire [6:0] far_reduced4SigSmaller = {far_reduced4SigSmaller_reducedVec_6,far_reduced4SigSmaller_reducedVec_5,
    far_reduced4SigSmaller_reducedVec_4,far_reduced4SigSmaller_reducedVec_3,far_reduced4SigSmaller_reducedVec_2,
    far_reduced4SigSmaller_reducedVec_1,far_reduced4SigSmaller_reducedVec_0}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 124:20]
  wire [8:0] far_roundExtraMask_shift = 9'sh100 >>> alignDist[4:2]; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 76:56]
  wire [6:0] far_roundExtraMask = {far_roundExtraMask_shift[1],far_roundExtraMask_shift[2],far_roundExtraMask_shift[3],
    far_roundExtraMask_shift[4],far_roundExtraMask_shift[5],far_roundExtraMask_shift[6],far_roundExtraMask_shift[7]}; // @[generators/hardfloat/hardfloat/src/main/scala/primitives.scala 77:20]
  wire [6:0] _far_alignedSigSmaller_T_3 = far_reduced4SigSmaller & far_roundExtraMask; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 95:76]
  wire  _far_alignedSigSmaller_T_5 = |far_mainAlignedSigSmaller[2:0] | |_far_alignedSigSmaller_T_3; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 95:49]
  wire [26:0] far_alignedSigSmaller = {far_mainAlignedSigSmaller[28:3],_far_alignedSigSmaller_T_5}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 94:12]
  wire [26:0] _far_negAlignedSigSmaller_T = ~far_alignedSigSmaller; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 97:62]
  wire [27:0] _far_negAlignedSigSmaller_T_1 = {1'h1,_far_negAlignedSigSmaller_T}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 97:56]
  wire [27:0] far_negAlignedSigSmaller = _closeSubMags_T ? _far_negAlignedSigSmaller_T_1 : {{1'd0},
    far_alignedSigSmaller}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 97:39]
  wire [26:0] _far_sigSum_T = {far_sigLarger, 3'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 98:36]
  wire [27:0] _GEN_3 = {{1'd0}, _far_sigSum_T}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 98:41]
  wire [27:0] _far_sigSum_T_2 = _GEN_3 + far_negAlignedSigSmaller; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 98:41]
  wire [27:0] _GEN_4 = {{27'd0}, _closeSubMags_T}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 98:68]
  wire [27:0] far_sigSum = _far_sigSum_T_2 + _GEN_4; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 98:68]
  wire [26:0] _GEN_5 = {{26'd0}, far_sigSum[0]}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 99:67]
  wire [26:0] _far_sigOut_T_2 = far_sigSum[27:1] | _GEN_5; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 99:67]
  wire [27:0] _far_sigOut_T_3 = _closeSubMags_T ? far_sigSum : {{1'd0}, _far_sigOut_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 99:25]
  wire [26:0] far_sigOut = _far_sigOut_T_3[26:0]; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 99:83]
  wire  notSigNaN_invalidExc = io_a_isInf & io_b_isInf & _closeSubMags_T; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 102:57]
  wire  notNaN_isInfOut = io_a_isInf | io_b_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 103:38]
  wire  addZeros = io_a_isZero & io_b_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 104:32]
  wire  notNaN_specialCase = notNaN_isInfOut | addZeros; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 105:46]
  wire  _notNaN_signOut_T_1 = io_a_isInf & io_a_sign; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 109:39]
  wire  _notNaN_signOut_T_2 = eqSigns & io_a_sign | _notNaN_signOut_T_1; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 108:63]
  wire  _notNaN_signOut_T_3 = io_b_isInf & io_b_sign; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 110:39]
  wire  _notNaN_signOut_T_4 = _notNaN_signOut_T_2 | _notNaN_signOut_T_3; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 109:63]
  wire  _notNaN_signOut_T_9 = ~notNaN_specialCase; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 112:10]
  wire  _notNaN_signOut_T_12 = ~notNaN_specialCase & closeSubMags & ~close_totalCancellation; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 112:46]
  wire  _notNaN_signOut_T_13 = _notNaN_signOut_T_12 & close_notTotalCancellation_signOut; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 113:38]
  wire  _notNaN_signOut_T_14 = _notNaN_signOut_T_4 | _notNaN_signOut_T_13; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 111:63]
  wire  _notNaN_signOut_T_18 = _notNaN_signOut_T_9 & ~closeSubMags & far_signOut; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 114:47]
  wire [9:0] _common_sExpOut_T_2 = closeSubMags | _modNatAlignDist_T ? $signed(io_b_sExp) : $signed(io_a_sExp); // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 116:13]
  wire [4:0] _common_sExpOut_T_3 = closeSubMags ? close_nearNormDist : {{4'd0}, _closeSubMags_T}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 117:18]
  wire [5:0] _common_sExpOut_T_4 = {1'b0,$signed(_common_sExpOut_T_3)}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 117:66]
  wire [9:0] _GEN_6 = {{4{_common_sExpOut_T_4[5]}},_common_sExpOut_T_4}; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 117:13]
  wire  _io_invalidExc_T_2 = io_a_isNaN & ~io_a_sig[22]; // @[generators/hardfloat/hardfloat/src/main/scala/common.scala 82:46]
  wire  _io_invalidExc_T_5 = io_b_isNaN & ~io_b_sig[22]; // @[generators/hardfloat/hardfloat/src/main/scala/common.scala 82:46]
  assign io_invalidExc = _io_invalidExc_T_2 | _io_invalidExc_T_5 | notSigNaN_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 121:71]
  assign io_rawOut_isNaN = io_a_isNaN | io_b_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 125:35]
  assign io_rawOut_isInf = io_a_isInf | io_b_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 103:38]
  assign io_rawOut_isZero = addZeros | ~notNaN_isInfOut & closeSubMags & close_totalCancellation; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 106:37]
  assign io_rawOut_sign = _notNaN_signOut_T_14 | _notNaN_signOut_T_18; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 113:77]
  assign io_rawOut_sExp = $signed(_common_sExpOut_T_2) - $signed(_GEN_6); // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 117:13]
  assign io_rawOut_sig = closeSubMags ? close_sigOut : far_sigOut; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 118:28]
endmodule
module AddRecFN( // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 133:7]
  input  [32:0] io_a, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 135:16]
  input  [32:0] io_b, // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 135:16]
  output [32:0] io_out // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 135:16]
);
  wire  addRawFN__io_a_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_a_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_a_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_a_sign; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire [9:0] addRawFN__io_a_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire [24:0] addRawFN__io_a_sig; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_b_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_b_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_b_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_b_sign; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire [9:0] addRawFN__io_b_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire [24:0] addRawFN__io_b_sig; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_sign; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire [9:0] addRawFN__io_rawOut_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire [26:0] addRawFN__io_rawOut_sig; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
  wire  roundRawFNToRecFN_io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 157:15]
  wire [9:0] roundRawFNToRecFN_io_in_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 157:15]
  wire [26:0] roundRawFNToRecFN_io_in_sig; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 157:15]
  wire [32:0] roundRawFNToRecFN_io_out; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 157:15]
  wire [8:0] addRawFN_io_a_exp = io_a[31:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  addRawFN_io_a_isZero = addRawFN_io_a_exp[8:6] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  addRawFN_io_a_isSpecial = addRawFN_io_a_exp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  _addRawFN_io_a_out_sig_T = ~addRawFN_io_a_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [1:0] _addRawFN_io_a_out_sig_T_1 = {1'h0,_addRawFN_io_a_out_sig_T}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:32]
  wire [8:0] addRawFN_io_b_exp = io_b[31:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  addRawFN_io_b_isZero = addRawFN_io_b_exp[8:6] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  addRawFN_io_b_isSpecial = addRawFN_io_b_exp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  _addRawFN_io_b_out_sig_T = ~addRawFN_io_b_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [1:0] _addRawFN_io_b_out_sig_T_1 = {1'h0,_addRawFN_io_b_out_sig_T}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:32]
  AddRawFN addRawFN_ ( // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 147:26]
    .io_a_isNaN(addRawFN__io_a_isNaN),
    .io_a_isInf(addRawFN__io_a_isInf),
    .io_a_isZero(addRawFN__io_a_isZero),
    .io_a_sign(addRawFN__io_a_sign),
    .io_a_sExp(addRawFN__io_a_sExp),
    .io_a_sig(addRawFN__io_a_sig),
    .io_b_isNaN(addRawFN__io_b_isNaN),
    .io_b_isInf(addRawFN__io_b_isInf),
    .io_b_isZero(addRawFN__io_b_isZero),
    .io_b_sign(addRawFN__io_b_sign),
    .io_b_sExp(addRawFN__io_b_sExp),
    .io_b_sig(addRawFN__io_b_sig),
    .io_invalidExc(addRawFN__io_invalidExc),
    .io_rawOut_isNaN(addRawFN__io_rawOut_isNaN),
    .io_rawOut_isInf(addRawFN__io_rawOut_isInf),
    .io_rawOut_isZero(addRawFN__io_rawOut_isZero),
    .io_rawOut_sign(addRawFN__io_rawOut_sign),
    .io_rawOut_sExp(addRawFN__io_rawOut_sExp),
    .io_rawOut_sig(addRawFN__io_rawOut_sig)
  );
  RoundRawFNToRecFN roundRawFNToRecFN ( // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 157:15]
    .io_invalidExc(roundRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundRawFNToRecFN_io_in_sig),
    .io_out(roundRawFNToRecFN_io_out)
  );
  assign io_out = roundRawFNToRecFN_io_out; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 163:23]
  assign addRawFN__io_a_isNaN = addRawFN_io_a_isSpecial & addRawFN_io_a_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  assign addRawFN__io_a_isInf = addRawFN_io_a_isSpecial & ~addRawFN_io_a_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  assign addRawFN__io_a_isZero = addRawFN_io_a_exp[8:6] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  assign addRawFN__io_a_sign = io_a[32]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  assign addRawFN__io_a_sExp = {1'b0,$signed(addRawFN_io_a_exp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  assign addRawFN__io_a_sig = {_addRawFN_io_a_out_sig_T_1,io_a[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  assign addRawFN__io_b_isNaN = addRawFN_io_b_isSpecial & addRawFN_io_b_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  assign addRawFN__io_b_isInf = addRawFN_io_b_isSpecial & ~addRawFN_io_b_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  assign addRawFN__io_b_isZero = addRawFN_io_b_exp[8:6] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  assign addRawFN__io_b_sign = io_b[32]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  assign addRawFN__io_b_sExp = {1'b0,$signed(addRawFN_io_b_exp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  assign addRawFN__io_b_sig = {_addRawFN_io_b_out_sig_T_1,io_b[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  assign roundRawFNToRecFN_io_invalidExc = addRawFN__io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 158:39]
  assign roundRawFNToRecFN_io_in_isNaN = addRawFN__io_rawOut_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_isInf = addRawFN__io_rawOut_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_isZero = addRawFN__io_rawOut_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_sign = addRawFN__io_rawOut_sign; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_sExp = addRawFN__io_rawOut_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_sig = addRawFN__io_rawOut_sig; // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 160:39]
endmodule
module DotProductPipe( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 91:7]
  input         clock, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 91:7]
  input         reset, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 91:7]
  input         io_in_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  input  [32:0] io_in_bits_a_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  input  [32:0] io_in_bits_a_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  input  [32:0] io_in_bits_a_2, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  input  [32:0] io_in_bits_a_3, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  input  [32:0] io_in_bits_b_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  input  [32:0] io_in_bits_b_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  input  [32:0] io_in_bits_b_2, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  input  [32:0] io_in_bits_b_3, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  input  [32:0] io_in_bits_c, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  input         io_stall, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  output        io_out_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
  output [32:0] io_out_bits_data // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 95:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [63:0] _RAND_8;
  reg [63:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [63:0] _RAND_11;
  reg [63:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [63:0] _RAND_14;
`endif // RANDOMIZE_REG_INIT
  wire [32:0] mul_0_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_0_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_0_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_1_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_1_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_1_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_2_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_2_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_2_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_3_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_3_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] mul_3_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
  wire [32:0] add1_0_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 123:38]
  wire [32:0] add1_0_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 123:38]
  wire [32:0] add1_0_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 123:38]
  wire [32:0] add1_1_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 123:38]
  wire [32:0] add1_1_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 123:38]
  wire [32:0] add1_1_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 123:38]
  wire [32:0] add2_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 137:20]
  wire [32:0] add2_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 137:20]
  wire [32:0] add2_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 137:20]
  wire [32:0] acc_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 150:19]
  wire [32:0] acc_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 150:19]
  wire [32:0] acc_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 150:19]
  wire  _mulStageOut_stalling_pipe_v_T = ~io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:44]
  reg  mulStageOut_stalling_pipe_v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
  reg [32:0] mulStageOut_stalling_pipe_b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  reg [32:0] mulStageOut_stalling_pipe_b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  reg [32:0] mulStageOut_stalling_pipe_b_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  reg [32:0] mulStageOut_stalling_pipe_b_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  wire [32:0] _mulStageOut_WIRE_0 = mul_0_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 118:{64,64}]
  wire [32:0] _mulStageOut_WIRE_1 = mul_1_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 118:{64,64}]
  wire [32:0] _mulStageOut_WIRE_2 = mul_2_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 118:{64,64}]
  wire [32:0] _mulStageOut_WIRE_3 = mul_3_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 118:{64,64}]
  reg [32:0] mulStageC_stalling_pipe_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  reg  add1StageOut_stalling_pipe_v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
  reg [32:0] add1StageOut_stalling_pipe_b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  reg [32:0] add1StageOut_stalling_pipe_b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  wire [32:0] _add1StageOut_WIRE_0 = add1_0_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 132:{71,71}]
  wire [32:0] _add1StageOut_WIRE_1 = add1_1_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 132:{71,71}]
  reg [32:0] add1StageC_stalling_pipe_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  reg  add2StageOut_stalling_pipe_v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
  reg [32:0] add2StageOut_stalling_pipe_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  reg [32:0] add2StageC_stalling_pipe_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  reg  accStageOut_stalling_pipe_v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
  reg [32:0] accStageOut_stalling_pipe_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
  MulRecFN mul_0 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
    .io_a(mul_0_io_a),
    .io_b(mul_0_io_b),
    .io_out(mul_0_io_out)
  );
  MulRecFN mul_1 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
    .io_a(mul_1_io_a),
    .io_b(mul_1_io_b),
    .io_out(mul_1_io_out)
  );
  MulRecFN mul_2 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
    .io_a(mul_2_io_a),
    .io_b(mul_2_io_b),
    .io_out(mul_2_io_out)
  );
  MulRecFN mul_3 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 109:33]
    .io_a(mul_3_io_a),
    .io_b(mul_3_io_b),
    .io_out(mul_3_io_out)
  );
  AddRecFN add1_0 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 123:38]
    .io_a(add1_0_io_a),
    .io_b(add1_0_io_b),
    .io_out(add1_0_io_out)
  );
  AddRecFN add1_1 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 123:38]
    .io_a(add1_1_io_a),
    .io_b(add1_1_io_b),
    .io_out(add1_1_io_out)
  );
  AddRecFN add2 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 137:20]
    .io_a(add2_io_a),
    .io_b(add2_io_b),
    .io_out(add2_io_out)
  );
  AddRecFN acc ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 150:19]
    .io_a(acc_io_a),
    .io_b(acc_io_b),
    .io_out(acc_io_out)
  );
  assign io_out_valid = accStageOut_stalling_pipe_v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:21 74:17]
  assign io_out_bits_data = accStageOut_stalling_pipe_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:21 75:16]
  assign mul_0_io_a = io_in_bits_a_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 114:12]
  assign mul_0_io_b = io_in_bits_b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 115:12]
  assign mul_1_io_a = io_in_bits_a_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 114:12]
  assign mul_1_io_b = io_in_bits_b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 115:12]
  assign mul_2_io_a = io_in_bits_a_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 114:12]
  assign mul_2_io_b = io_in_bits_b_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 115:12]
  assign mul_3_io_a = io_in_bits_a_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 114:12]
  assign mul_3_io_b = io_in_bits_b_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 115:12]
  assign add1_0_io_a = mulStageOut_stalling_pipe_b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:21 75:16]
  assign add1_0_io_b = mulStageOut_stalling_pipe_b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:21 75:16]
  assign add1_1_io_a = mulStageOut_stalling_pipe_b_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:21 75:16]
  assign add1_1_io_b = mulStageOut_stalling_pipe_b_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:21 75:16]
  assign add2_io_a = add1StageOut_stalling_pipe_b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:21 75:16]
  assign add2_io_b = add1StageOut_stalling_pipe_b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:21 75:16]
  assign acc_io_a = add2StageOut_stalling_pipe_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:21 75:16]
  assign acc_io_b = add2StageC_stalling_pipe_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:21 75:16]
  always @(posedge clock) begin
    if (reset) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
      mulStageOut_stalling_pipe_v <= 1'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
    end else if (~io_stall) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
      mulStageOut_stalling_pipe_v <= io_in_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & io_in_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      mulStageOut_stalling_pipe_b_0 <= _mulStageOut_WIRE_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & io_in_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      mulStageOut_stalling_pipe_b_1 <= _mulStageOut_WIRE_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & io_in_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      mulStageOut_stalling_pipe_b_2 <= _mulStageOut_WIRE_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & io_in_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      mulStageOut_stalling_pipe_b_3 <= _mulStageOut_WIRE_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & io_in_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      mulStageC_stalling_pipe_b <= io_in_bits_c; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
    if (reset) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
      add1StageOut_stalling_pipe_v <= 1'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
    end else if (~io_stall) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
      add1StageOut_stalling_pipe_v <= mulStageOut_stalling_pipe_v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & mulStageOut_stalling_pipe_v) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      add1StageOut_stalling_pipe_b_0 <= _add1StageOut_WIRE_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & mulStageOut_stalling_pipe_v) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      add1StageOut_stalling_pipe_b_1 <= _add1StageOut_WIRE_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & mulStageOut_stalling_pipe_v) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      add1StageC_stalling_pipe_b <= mulStageC_stalling_pipe_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
    if (reset) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
      add2StageOut_stalling_pipe_v <= 1'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
    end else if (~io_stall) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
      add2StageOut_stalling_pipe_v <= add1StageOut_stalling_pipe_v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & add1StageOut_stalling_pipe_v) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      add2StageOut_stalling_pipe_b <= add2_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & add1StageOut_stalling_pipe_v) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      add2StageC_stalling_pipe_b <= add1StageC_stalling_pipe_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
    if (reset) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
      accStageOut_stalling_pipe_v <= 1'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
    end else if (~io_stall) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
      accStageOut_stalling_pipe_v <= add2StageOut_stalling_pipe_v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 72:24]
    end
    if (_mulStageOut_stalling_pipe_v_T & add2StageOut_stalling_pipe_v) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
      accStageOut_stalling_pipe_b <= acc_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:24]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  mulStageOut_stalling_pipe_v = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  mulStageOut_stalling_pipe_b_0 = _RAND_1[32:0];
  _RAND_2 = {2{`RANDOM}};
  mulStageOut_stalling_pipe_b_1 = _RAND_2[32:0];
  _RAND_3 = {2{`RANDOM}};
  mulStageOut_stalling_pipe_b_2 = _RAND_3[32:0];
  _RAND_4 = {2{`RANDOM}};
  mulStageOut_stalling_pipe_b_3 = _RAND_4[32:0];
  _RAND_5 = {2{`RANDOM}};
  mulStageC_stalling_pipe_b = _RAND_5[32:0];
  _RAND_6 = {1{`RANDOM}};
  add1StageOut_stalling_pipe_v = _RAND_6[0:0];
  _RAND_7 = {2{`RANDOM}};
  add1StageOut_stalling_pipe_b_0 = _RAND_7[32:0];
  _RAND_8 = {2{`RANDOM}};
  add1StageOut_stalling_pipe_b_1 = _RAND_8[32:0];
  _RAND_9 = {2{`RANDOM}};
  add1StageC_stalling_pipe_b = _RAND_9[32:0];
  _RAND_10 = {1{`RANDOM}};
  add2StageOut_stalling_pipe_v = _RAND_10[0:0];
  _RAND_11 = {2{`RANDOM}};
  add2StageOut_stalling_pipe_b = _RAND_11[32:0];
  _RAND_12 = {2{`RANDOM}};
  add2StageC_stalling_pipe_b = _RAND_12[32:0];
  _RAND_13 = {1{`RANDOM}};
  accStageOut_stalling_pipe_v = _RAND_13[0:0];
  _RAND_14 = {2{`RANDOM}};
  accStageOut_stalling_pipe_b = _RAND_14[32:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module TensorDotProductUnit( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 11:7]
  input         clock, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 11:7]
  input         reset, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 11:7]
  input         io_in_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  input  [31:0] io_in_bits_a_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  input  [31:0] io_in_bits_a_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  input  [31:0] io_in_bits_a_2, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  input  [31:0] io_in_bits_a_3, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  input  [31:0] io_in_bits_b_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  input  [31:0] io_in_bits_b_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  input  [31:0] io_in_bits_b_2, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  input  [31:0] io_in_bits_b_3, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  input  [31:0] io_in_bits_c, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  input         io_stall, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  output        io_out_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
  output [31:0] io_out_bits_data // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 17:14]
);
  wire  dpu_clock; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire  dpu_reset; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire  dpu_io_in_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire [32:0] dpu_io_in_bits_a_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire [32:0] dpu_io_in_bits_a_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire [32:0] dpu_io_in_bits_a_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire [32:0] dpu_io_in_bits_a_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire [32:0] dpu_io_in_bits_b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire [32:0] dpu_io_in_bits_b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire [32:0] dpu_io_in_bits_b_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire [32:0] dpu_io_in_bits_b_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire [32:0] dpu_io_in_bits_c; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire  dpu_io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire  dpu_io_out_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire [32:0] dpu_io_out_bits_data; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
  wire  in1_rawIn_sign = io_in_bits_a_0[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in1_rawIn_expIn = io_in_bits_a_0[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in1_rawIn_fractIn = io_in_bits_a_0[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn = in1_rawIn_expIn == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn = in1_rawIn_fractIn == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in1_rawIn_normDist_T_23 = in1_rawIn_fractIn[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_24 = in1_rawIn_fractIn[2] ? 5'h14 : _in1_rawIn_normDist_T_23; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_25 = in1_rawIn_fractIn[3] ? 5'h13 : _in1_rawIn_normDist_T_24; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_26 = in1_rawIn_fractIn[4] ? 5'h12 : _in1_rawIn_normDist_T_25; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_27 = in1_rawIn_fractIn[5] ? 5'h11 : _in1_rawIn_normDist_T_26; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_28 = in1_rawIn_fractIn[6] ? 5'h10 : _in1_rawIn_normDist_T_27; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_29 = in1_rawIn_fractIn[7] ? 5'hf : _in1_rawIn_normDist_T_28; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_30 = in1_rawIn_fractIn[8] ? 5'he : _in1_rawIn_normDist_T_29; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_31 = in1_rawIn_fractIn[9] ? 5'hd : _in1_rawIn_normDist_T_30; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_32 = in1_rawIn_fractIn[10] ? 5'hc : _in1_rawIn_normDist_T_31; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_33 = in1_rawIn_fractIn[11] ? 5'hb : _in1_rawIn_normDist_T_32; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_34 = in1_rawIn_fractIn[12] ? 5'ha : _in1_rawIn_normDist_T_33; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_35 = in1_rawIn_fractIn[13] ? 5'h9 : _in1_rawIn_normDist_T_34; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_36 = in1_rawIn_fractIn[14] ? 5'h8 : _in1_rawIn_normDist_T_35; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_37 = in1_rawIn_fractIn[15] ? 5'h7 : _in1_rawIn_normDist_T_36; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_38 = in1_rawIn_fractIn[16] ? 5'h6 : _in1_rawIn_normDist_T_37; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_39 = in1_rawIn_fractIn[17] ? 5'h5 : _in1_rawIn_normDist_T_38; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_40 = in1_rawIn_fractIn[18] ? 5'h4 : _in1_rawIn_normDist_T_39; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_41 = in1_rawIn_fractIn[19] ? 5'h3 : _in1_rawIn_normDist_T_40; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_42 = in1_rawIn_fractIn[20] ? 5'h2 : _in1_rawIn_normDist_T_41; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_43 = in1_rawIn_fractIn[21] ? 5'h1 : _in1_rawIn_normDist_T_42; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in1_rawIn_normDist = in1_rawIn_fractIn[22] ? 5'h0 : _in1_rawIn_normDist_T_43; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_36 = {{31'd0}, in1_rawIn_fractIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in1_rawIn_subnormFract_T = _GEN_36 << in1_rawIn_normDist; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in1_rawIn_subnormFract = {_in1_rawIn_subnormFract_T[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_0 = {{4'd0}, in1_rawIn_normDist}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T = _GEN_0 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_1 = in1_rawIn_isZeroExpIn ? _in1_rawIn_adjustedExp_T : {{1'd0}, in1_rawIn_expIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_2 = in1_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_1 = {{6'd0}, _in1_rawIn_adjustedExp_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in1_rawIn_adjustedExp_T_3 = 8'h80 | _GEN_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_2 = {{1'd0}, _in1_rawIn_adjustedExp_T_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in1_rawIn_adjustedExp = _in1_rawIn_adjustedExp_T_1 + _GEN_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero = in1_rawIn_isZeroExpIn & in1_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial = in1_rawIn_adjustedExp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn__isNaN = in1_rawIn_isSpecial & ~in1_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in1_rawIn__sExp = {1'b0,$signed(in1_rawIn_adjustedExp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T = ~in1_rawIn_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in1_rawIn_out_sig_T_2 = in1_rawIn_isZeroExpIn ? in1_rawIn_subnormFract : in1_rawIn_fractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in1_rawIn__sig = {1'h0,_in1_rawIn_out_sig_T,_in1_rawIn_out_sig_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_2 = in1_rawIn_isZero ? 3'h0 : in1_rawIn__sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_3 = {{2'd0}, in1_rawIn__isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_4 = _in1_T_2 | _GEN_3; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [9:0] _in1_T_7 = {in1_rawIn_sign,_in1_T_4,in1_rawIn__sExp[5:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 49:45]
  wire  in1_rawIn_sign_1 = io_in_bits_a_1[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in1_rawIn_expIn_1 = io_in_bits_a_1[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in1_rawIn_fractIn_1 = io_in_bits_a_1[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn_1 = in1_rawIn_expIn_1 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn_1 = in1_rawIn_fractIn_1 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in1_rawIn_normDist_T_67 = in1_rawIn_fractIn_1[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_68 = in1_rawIn_fractIn_1[2] ? 5'h14 : _in1_rawIn_normDist_T_67; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_69 = in1_rawIn_fractIn_1[3] ? 5'h13 : _in1_rawIn_normDist_T_68; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_70 = in1_rawIn_fractIn_1[4] ? 5'h12 : _in1_rawIn_normDist_T_69; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_71 = in1_rawIn_fractIn_1[5] ? 5'h11 : _in1_rawIn_normDist_T_70; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_72 = in1_rawIn_fractIn_1[6] ? 5'h10 : _in1_rawIn_normDist_T_71; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_73 = in1_rawIn_fractIn_1[7] ? 5'hf : _in1_rawIn_normDist_T_72; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_74 = in1_rawIn_fractIn_1[8] ? 5'he : _in1_rawIn_normDist_T_73; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_75 = in1_rawIn_fractIn_1[9] ? 5'hd : _in1_rawIn_normDist_T_74; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_76 = in1_rawIn_fractIn_1[10] ? 5'hc : _in1_rawIn_normDist_T_75; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_77 = in1_rawIn_fractIn_1[11] ? 5'hb : _in1_rawIn_normDist_T_76; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_78 = in1_rawIn_fractIn_1[12] ? 5'ha : _in1_rawIn_normDist_T_77; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_79 = in1_rawIn_fractIn_1[13] ? 5'h9 : _in1_rawIn_normDist_T_78; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_80 = in1_rawIn_fractIn_1[14] ? 5'h8 : _in1_rawIn_normDist_T_79; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_81 = in1_rawIn_fractIn_1[15] ? 5'h7 : _in1_rawIn_normDist_T_80; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_82 = in1_rawIn_fractIn_1[16] ? 5'h6 : _in1_rawIn_normDist_T_81; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_83 = in1_rawIn_fractIn_1[17] ? 5'h5 : _in1_rawIn_normDist_T_82; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_84 = in1_rawIn_fractIn_1[18] ? 5'h4 : _in1_rawIn_normDist_T_83; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_85 = in1_rawIn_fractIn_1[19] ? 5'h3 : _in1_rawIn_normDist_T_84; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_86 = in1_rawIn_fractIn_1[20] ? 5'h2 : _in1_rawIn_normDist_T_85; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_87 = in1_rawIn_fractIn_1[21] ? 5'h1 : _in1_rawIn_normDist_T_86; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in1_rawIn_normDist_1 = in1_rawIn_fractIn_1[22] ? 5'h0 : _in1_rawIn_normDist_T_87; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_37 = {{31'd0}, in1_rawIn_fractIn_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in1_rawIn_subnormFract_T_2 = _GEN_37 << in1_rawIn_normDist_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in1_rawIn_subnormFract_1 = {_in1_rawIn_subnormFract_T_2[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_4 = {{4'd0}, in1_rawIn_normDist_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_5 = _GEN_4 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_6 = in1_rawIn_isZeroExpIn_1 ? _in1_rawIn_adjustedExp_T_5 : {{1'd0},
    in1_rawIn_expIn_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_7 = in1_rawIn_isZeroExpIn_1 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_5 = {{6'd0}, _in1_rawIn_adjustedExp_T_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in1_rawIn_adjustedExp_T_8 = 8'h80 | _GEN_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_6 = {{1'd0}, _in1_rawIn_adjustedExp_T_8}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in1_rawIn_adjustedExp_1 = _in1_rawIn_adjustedExp_T_6 + _GEN_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero_1 = in1_rawIn_isZeroExpIn_1 & in1_rawIn_isZeroFractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial_1 = in1_rawIn_adjustedExp_1[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn_1_isNaN = in1_rawIn_isSpecial_1 & ~in1_rawIn_isZeroFractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in1_rawIn_1_sExp = {1'b0,$signed(in1_rawIn_adjustedExp_1)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T_4 = ~in1_rawIn_isZero_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in1_rawIn_out_sig_T_6 = in1_rawIn_isZeroExpIn_1 ? in1_rawIn_subnormFract_1 : in1_rawIn_fractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in1_rawIn_1_sig = {1'h0,_in1_rawIn_out_sig_T_4,_in1_rawIn_out_sig_T_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_12 = in1_rawIn_isZero_1 ? 3'h0 : in1_rawIn_1_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_7 = {{2'd0}, in1_rawIn_1_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_14 = _in1_T_12 | _GEN_7; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [9:0] _in1_T_17 = {in1_rawIn_sign_1,_in1_T_14,in1_rawIn_1_sExp[5:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 49:45]
  wire  in1_rawIn_sign_2 = io_in_bits_a_2[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in1_rawIn_expIn_2 = io_in_bits_a_2[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in1_rawIn_fractIn_2 = io_in_bits_a_2[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn_2 = in1_rawIn_expIn_2 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn_2 = in1_rawIn_fractIn_2 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in1_rawIn_normDist_T_111 = in1_rawIn_fractIn_2[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_112 = in1_rawIn_fractIn_2[2] ? 5'h14 : _in1_rawIn_normDist_T_111; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_113 = in1_rawIn_fractIn_2[3] ? 5'h13 : _in1_rawIn_normDist_T_112; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_114 = in1_rawIn_fractIn_2[4] ? 5'h12 : _in1_rawIn_normDist_T_113; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_115 = in1_rawIn_fractIn_2[5] ? 5'h11 : _in1_rawIn_normDist_T_114; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_116 = in1_rawIn_fractIn_2[6] ? 5'h10 : _in1_rawIn_normDist_T_115; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_117 = in1_rawIn_fractIn_2[7] ? 5'hf : _in1_rawIn_normDist_T_116; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_118 = in1_rawIn_fractIn_2[8] ? 5'he : _in1_rawIn_normDist_T_117; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_119 = in1_rawIn_fractIn_2[9] ? 5'hd : _in1_rawIn_normDist_T_118; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_120 = in1_rawIn_fractIn_2[10] ? 5'hc : _in1_rawIn_normDist_T_119; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_121 = in1_rawIn_fractIn_2[11] ? 5'hb : _in1_rawIn_normDist_T_120; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_122 = in1_rawIn_fractIn_2[12] ? 5'ha : _in1_rawIn_normDist_T_121; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_123 = in1_rawIn_fractIn_2[13] ? 5'h9 : _in1_rawIn_normDist_T_122; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_124 = in1_rawIn_fractIn_2[14] ? 5'h8 : _in1_rawIn_normDist_T_123; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_125 = in1_rawIn_fractIn_2[15] ? 5'h7 : _in1_rawIn_normDist_T_124; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_126 = in1_rawIn_fractIn_2[16] ? 5'h6 : _in1_rawIn_normDist_T_125; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_127 = in1_rawIn_fractIn_2[17] ? 5'h5 : _in1_rawIn_normDist_T_126; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_128 = in1_rawIn_fractIn_2[18] ? 5'h4 : _in1_rawIn_normDist_T_127; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_129 = in1_rawIn_fractIn_2[19] ? 5'h3 : _in1_rawIn_normDist_T_128; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_130 = in1_rawIn_fractIn_2[20] ? 5'h2 : _in1_rawIn_normDist_T_129; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_131 = in1_rawIn_fractIn_2[21] ? 5'h1 : _in1_rawIn_normDist_T_130; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in1_rawIn_normDist_2 = in1_rawIn_fractIn_2[22] ? 5'h0 : _in1_rawIn_normDist_T_131; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_38 = {{31'd0}, in1_rawIn_fractIn_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in1_rawIn_subnormFract_T_4 = _GEN_38 << in1_rawIn_normDist_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in1_rawIn_subnormFract_2 = {_in1_rawIn_subnormFract_T_4[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_8 = {{4'd0}, in1_rawIn_normDist_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_10 = _GEN_8 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_11 = in1_rawIn_isZeroExpIn_2 ? _in1_rawIn_adjustedExp_T_10 : {{1'd0},
    in1_rawIn_expIn_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_12 = in1_rawIn_isZeroExpIn_2 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_9 = {{6'd0}, _in1_rawIn_adjustedExp_T_12}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in1_rawIn_adjustedExp_T_13 = 8'h80 | _GEN_9; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_10 = {{1'd0}, _in1_rawIn_adjustedExp_T_13}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in1_rawIn_adjustedExp_2 = _in1_rawIn_adjustedExp_T_11 + _GEN_10; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero_2 = in1_rawIn_isZeroExpIn_2 & in1_rawIn_isZeroFractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial_2 = in1_rawIn_adjustedExp_2[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn_2_isNaN = in1_rawIn_isSpecial_2 & ~in1_rawIn_isZeroFractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in1_rawIn_2_sExp = {1'b0,$signed(in1_rawIn_adjustedExp_2)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T_8 = ~in1_rawIn_isZero_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in1_rawIn_out_sig_T_10 = in1_rawIn_isZeroExpIn_2 ? in1_rawIn_subnormFract_2 : in1_rawIn_fractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in1_rawIn_2_sig = {1'h0,_in1_rawIn_out_sig_T_8,_in1_rawIn_out_sig_T_10}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_22 = in1_rawIn_isZero_2 ? 3'h0 : in1_rawIn_2_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_11 = {{2'd0}, in1_rawIn_2_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_24 = _in1_T_22 | _GEN_11; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [9:0] _in1_T_27 = {in1_rawIn_sign_2,_in1_T_24,in1_rawIn_2_sExp[5:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 49:45]
  wire  in1_rawIn_sign_3 = io_in_bits_a_3[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in1_rawIn_expIn_3 = io_in_bits_a_3[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in1_rawIn_fractIn_3 = io_in_bits_a_3[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn_3 = in1_rawIn_expIn_3 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn_3 = in1_rawIn_fractIn_3 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in1_rawIn_normDist_T_155 = in1_rawIn_fractIn_3[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_156 = in1_rawIn_fractIn_3[2] ? 5'h14 : _in1_rawIn_normDist_T_155; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_157 = in1_rawIn_fractIn_3[3] ? 5'h13 : _in1_rawIn_normDist_T_156; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_158 = in1_rawIn_fractIn_3[4] ? 5'h12 : _in1_rawIn_normDist_T_157; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_159 = in1_rawIn_fractIn_3[5] ? 5'h11 : _in1_rawIn_normDist_T_158; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_160 = in1_rawIn_fractIn_3[6] ? 5'h10 : _in1_rawIn_normDist_T_159; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_161 = in1_rawIn_fractIn_3[7] ? 5'hf : _in1_rawIn_normDist_T_160; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_162 = in1_rawIn_fractIn_3[8] ? 5'he : _in1_rawIn_normDist_T_161; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_163 = in1_rawIn_fractIn_3[9] ? 5'hd : _in1_rawIn_normDist_T_162; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_164 = in1_rawIn_fractIn_3[10] ? 5'hc : _in1_rawIn_normDist_T_163; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_165 = in1_rawIn_fractIn_3[11] ? 5'hb : _in1_rawIn_normDist_T_164; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_166 = in1_rawIn_fractIn_3[12] ? 5'ha : _in1_rawIn_normDist_T_165; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_167 = in1_rawIn_fractIn_3[13] ? 5'h9 : _in1_rawIn_normDist_T_166; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_168 = in1_rawIn_fractIn_3[14] ? 5'h8 : _in1_rawIn_normDist_T_167; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_169 = in1_rawIn_fractIn_3[15] ? 5'h7 : _in1_rawIn_normDist_T_168; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_170 = in1_rawIn_fractIn_3[16] ? 5'h6 : _in1_rawIn_normDist_T_169; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_171 = in1_rawIn_fractIn_3[17] ? 5'h5 : _in1_rawIn_normDist_T_170; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_172 = in1_rawIn_fractIn_3[18] ? 5'h4 : _in1_rawIn_normDist_T_171; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_173 = in1_rawIn_fractIn_3[19] ? 5'h3 : _in1_rawIn_normDist_T_172; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_174 = in1_rawIn_fractIn_3[20] ? 5'h2 : _in1_rawIn_normDist_T_173; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_175 = in1_rawIn_fractIn_3[21] ? 5'h1 : _in1_rawIn_normDist_T_174; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in1_rawIn_normDist_3 = in1_rawIn_fractIn_3[22] ? 5'h0 : _in1_rawIn_normDist_T_175; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_39 = {{31'd0}, in1_rawIn_fractIn_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in1_rawIn_subnormFract_T_6 = _GEN_39 << in1_rawIn_normDist_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in1_rawIn_subnormFract_3 = {_in1_rawIn_subnormFract_T_6[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_12 = {{4'd0}, in1_rawIn_normDist_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_15 = _GEN_12 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_16 = in1_rawIn_isZeroExpIn_3 ? _in1_rawIn_adjustedExp_T_15 : {{1'd0},
    in1_rawIn_expIn_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_17 = in1_rawIn_isZeroExpIn_3 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_13 = {{6'd0}, _in1_rawIn_adjustedExp_T_17}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in1_rawIn_adjustedExp_T_18 = 8'h80 | _GEN_13; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_14 = {{1'd0}, _in1_rawIn_adjustedExp_T_18}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in1_rawIn_adjustedExp_3 = _in1_rawIn_adjustedExp_T_16 + _GEN_14; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero_3 = in1_rawIn_isZeroExpIn_3 & in1_rawIn_isZeroFractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial_3 = in1_rawIn_adjustedExp_3[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn_3_isNaN = in1_rawIn_isSpecial_3 & ~in1_rawIn_isZeroFractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in1_rawIn_3_sExp = {1'b0,$signed(in1_rawIn_adjustedExp_3)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T_12 = ~in1_rawIn_isZero_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in1_rawIn_out_sig_T_14 = in1_rawIn_isZeroExpIn_3 ? in1_rawIn_subnormFract_3 : in1_rawIn_fractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in1_rawIn_3_sig = {1'h0,_in1_rawIn_out_sig_T_12,_in1_rawIn_out_sig_T_14}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_32 = in1_rawIn_isZero_3 ? 3'h0 : in1_rawIn_3_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_15 = {{2'd0}, in1_rawIn_3_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_34 = _in1_T_32 | _GEN_15; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [9:0] _in1_T_37 = {in1_rawIn_sign_3,_in1_T_34,in1_rawIn_3_sExp[5:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 49:45]
  wire  in2_rawIn_sign = io_in_bits_b_0[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in2_rawIn_expIn = io_in_bits_b_0[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in2_rawIn_fractIn = io_in_bits_b_0[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn = in2_rawIn_expIn == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn = in2_rawIn_fractIn == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in2_rawIn_normDist_T_23 = in2_rawIn_fractIn[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_24 = in2_rawIn_fractIn[2] ? 5'h14 : _in2_rawIn_normDist_T_23; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_25 = in2_rawIn_fractIn[3] ? 5'h13 : _in2_rawIn_normDist_T_24; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_26 = in2_rawIn_fractIn[4] ? 5'h12 : _in2_rawIn_normDist_T_25; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_27 = in2_rawIn_fractIn[5] ? 5'h11 : _in2_rawIn_normDist_T_26; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_28 = in2_rawIn_fractIn[6] ? 5'h10 : _in2_rawIn_normDist_T_27; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_29 = in2_rawIn_fractIn[7] ? 5'hf : _in2_rawIn_normDist_T_28; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_30 = in2_rawIn_fractIn[8] ? 5'he : _in2_rawIn_normDist_T_29; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_31 = in2_rawIn_fractIn[9] ? 5'hd : _in2_rawIn_normDist_T_30; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_32 = in2_rawIn_fractIn[10] ? 5'hc : _in2_rawIn_normDist_T_31; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_33 = in2_rawIn_fractIn[11] ? 5'hb : _in2_rawIn_normDist_T_32; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_34 = in2_rawIn_fractIn[12] ? 5'ha : _in2_rawIn_normDist_T_33; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_35 = in2_rawIn_fractIn[13] ? 5'h9 : _in2_rawIn_normDist_T_34; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_36 = in2_rawIn_fractIn[14] ? 5'h8 : _in2_rawIn_normDist_T_35; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_37 = in2_rawIn_fractIn[15] ? 5'h7 : _in2_rawIn_normDist_T_36; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_38 = in2_rawIn_fractIn[16] ? 5'h6 : _in2_rawIn_normDist_T_37; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_39 = in2_rawIn_fractIn[17] ? 5'h5 : _in2_rawIn_normDist_T_38; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_40 = in2_rawIn_fractIn[18] ? 5'h4 : _in2_rawIn_normDist_T_39; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_41 = in2_rawIn_fractIn[19] ? 5'h3 : _in2_rawIn_normDist_T_40; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_42 = in2_rawIn_fractIn[20] ? 5'h2 : _in2_rawIn_normDist_T_41; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_43 = in2_rawIn_fractIn[21] ? 5'h1 : _in2_rawIn_normDist_T_42; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in2_rawIn_normDist = in2_rawIn_fractIn[22] ? 5'h0 : _in2_rawIn_normDist_T_43; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_40 = {{31'd0}, in2_rawIn_fractIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in2_rawIn_subnormFract_T = _GEN_40 << in2_rawIn_normDist; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in2_rawIn_subnormFract = {_in2_rawIn_subnormFract_T[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_16 = {{4'd0}, in2_rawIn_normDist}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T = _GEN_16 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_1 = in2_rawIn_isZeroExpIn ? _in2_rawIn_adjustedExp_T : {{1'd0}, in2_rawIn_expIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_2 = in2_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_17 = {{6'd0}, _in2_rawIn_adjustedExp_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in2_rawIn_adjustedExp_T_3 = 8'h80 | _GEN_17; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_18 = {{1'd0}, _in2_rawIn_adjustedExp_T_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in2_rawIn_adjustedExp = _in2_rawIn_adjustedExp_T_1 + _GEN_18; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero = in2_rawIn_isZeroExpIn & in2_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial = in2_rawIn_adjustedExp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn__isNaN = in2_rawIn_isSpecial & ~in2_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in2_rawIn__sExp = {1'b0,$signed(in2_rawIn_adjustedExp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T = ~in2_rawIn_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in2_rawIn_out_sig_T_2 = in2_rawIn_isZeroExpIn ? in2_rawIn_subnormFract : in2_rawIn_fractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in2_rawIn__sig = {1'h0,_in2_rawIn_out_sig_T,_in2_rawIn_out_sig_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_2 = in2_rawIn_isZero ? 3'h0 : in2_rawIn__sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_19 = {{2'd0}, in2_rawIn__isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_4 = _in2_T_2 | _GEN_19; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [9:0] _in2_T_7 = {in2_rawIn_sign,_in2_T_4,in2_rawIn__sExp[5:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 49:45]
  wire  in2_rawIn_sign_1 = io_in_bits_b_1[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in2_rawIn_expIn_1 = io_in_bits_b_1[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in2_rawIn_fractIn_1 = io_in_bits_b_1[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn_1 = in2_rawIn_expIn_1 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn_1 = in2_rawIn_fractIn_1 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in2_rawIn_normDist_T_67 = in2_rawIn_fractIn_1[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_68 = in2_rawIn_fractIn_1[2] ? 5'h14 : _in2_rawIn_normDist_T_67; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_69 = in2_rawIn_fractIn_1[3] ? 5'h13 : _in2_rawIn_normDist_T_68; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_70 = in2_rawIn_fractIn_1[4] ? 5'h12 : _in2_rawIn_normDist_T_69; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_71 = in2_rawIn_fractIn_1[5] ? 5'h11 : _in2_rawIn_normDist_T_70; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_72 = in2_rawIn_fractIn_1[6] ? 5'h10 : _in2_rawIn_normDist_T_71; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_73 = in2_rawIn_fractIn_1[7] ? 5'hf : _in2_rawIn_normDist_T_72; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_74 = in2_rawIn_fractIn_1[8] ? 5'he : _in2_rawIn_normDist_T_73; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_75 = in2_rawIn_fractIn_1[9] ? 5'hd : _in2_rawIn_normDist_T_74; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_76 = in2_rawIn_fractIn_1[10] ? 5'hc : _in2_rawIn_normDist_T_75; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_77 = in2_rawIn_fractIn_1[11] ? 5'hb : _in2_rawIn_normDist_T_76; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_78 = in2_rawIn_fractIn_1[12] ? 5'ha : _in2_rawIn_normDist_T_77; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_79 = in2_rawIn_fractIn_1[13] ? 5'h9 : _in2_rawIn_normDist_T_78; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_80 = in2_rawIn_fractIn_1[14] ? 5'h8 : _in2_rawIn_normDist_T_79; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_81 = in2_rawIn_fractIn_1[15] ? 5'h7 : _in2_rawIn_normDist_T_80; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_82 = in2_rawIn_fractIn_1[16] ? 5'h6 : _in2_rawIn_normDist_T_81; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_83 = in2_rawIn_fractIn_1[17] ? 5'h5 : _in2_rawIn_normDist_T_82; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_84 = in2_rawIn_fractIn_1[18] ? 5'h4 : _in2_rawIn_normDist_T_83; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_85 = in2_rawIn_fractIn_1[19] ? 5'h3 : _in2_rawIn_normDist_T_84; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_86 = in2_rawIn_fractIn_1[20] ? 5'h2 : _in2_rawIn_normDist_T_85; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_87 = in2_rawIn_fractIn_1[21] ? 5'h1 : _in2_rawIn_normDist_T_86; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in2_rawIn_normDist_1 = in2_rawIn_fractIn_1[22] ? 5'h0 : _in2_rawIn_normDist_T_87; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_41 = {{31'd0}, in2_rawIn_fractIn_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in2_rawIn_subnormFract_T_2 = _GEN_41 << in2_rawIn_normDist_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in2_rawIn_subnormFract_1 = {_in2_rawIn_subnormFract_T_2[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_20 = {{4'd0}, in2_rawIn_normDist_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_5 = _GEN_20 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_6 = in2_rawIn_isZeroExpIn_1 ? _in2_rawIn_adjustedExp_T_5 : {{1'd0},
    in2_rawIn_expIn_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_7 = in2_rawIn_isZeroExpIn_1 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_21 = {{6'd0}, _in2_rawIn_adjustedExp_T_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in2_rawIn_adjustedExp_T_8 = 8'h80 | _GEN_21; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_22 = {{1'd0}, _in2_rawIn_adjustedExp_T_8}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in2_rawIn_adjustedExp_1 = _in2_rawIn_adjustedExp_T_6 + _GEN_22; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero_1 = in2_rawIn_isZeroExpIn_1 & in2_rawIn_isZeroFractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial_1 = in2_rawIn_adjustedExp_1[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn_1_isNaN = in2_rawIn_isSpecial_1 & ~in2_rawIn_isZeroFractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in2_rawIn_1_sExp = {1'b0,$signed(in2_rawIn_adjustedExp_1)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T_4 = ~in2_rawIn_isZero_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in2_rawIn_out_sig_T_6 = in2_rawIn_isZeroExpIn_1 ? in2_rawIn_subnormFract_1 : in2_rawIn_fractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in2_rawIn_1_sig = {1'h0,_in2_rawIn_out_sig_T_4,_in2_rawIn_out_sig_T_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_12 = in2_rawIn_isZero_1 ? 3'h0 : in2_rawIn_1_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_23 = {{2'd0}, in2_rawIn_1_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_14 = _in2_T_12 | _GEN_23; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [9:0] _in2_T_17 = {in2_rawIn_sign_1,_in2_T_14,in2_rawIn_1_sExp[5:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 49:45]
  wire  in2_rawIn_sign_2 = io_in_bits_b_2[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in2_rawIn_expIn_2 = io_in_bits_b_2[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in2_rawIn_fractIn_2 = io_in_bits_b_2[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn_2 = in2_rawIn_expIn_2 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn_2 = in2_rawIn_fractIn_2 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in2_rawIn_normDist_T_111 = in2_rawIn_fractIn_2[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_112 = in2_rawIn_fractIn_2[2] ? 5'h14 : _in2_rawIn_normDist_T_111; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_113 = in2_rawIn_fractIn_2[3] ? 5'h13 : _in2_rawIn_normDist_T_112; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_114 = in2_rawIn_fractIn_2[4] ? 5'h12 : _in2_rawIn_normDist_T_113; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_115 = in2_rawIn_fractIn_2[5] ? 5'h11 : _in2_rawIn_normDist_T_114; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_116 = in2_rawIn_fractIn_2[6] ? 5'h10 : _in2_rawIn_normDist_T_115; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_117 = in2_rawIn_fractIn_2[7] ? 5'hf : _in2_rawIn_normDist_T_116; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_118 = in2_rawIn_fractIn_2[8] ? 5'he : _in2_rawIn_normDist_T_117; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_119 = in2_rawIn_fractIn_2[9] ? 5'hd : _in2_rawIn_normDist_T_118; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_120 = in2_rawIn_fractIn_2[10] ? 5'hc : _in2_rawIn_normDist_T_119; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_121 = in2_rawIn_fractIn_2[11] ? 5'hb : _in2_rawIn_normDist_T_120; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_122 = in2_rawIn_fractIn_2[12] ? 5'ha : _in2_rawIn_normDist_T_121; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_123 = in2_rawIn_fractIn_2[13] ? 5'h9 : _in2_rawIn_normDist_T_122; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_124 = in2_rawIn_fractIn_2[14] ? 5'h8 : _in2_rawIn_normDist_T_123; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_125 = in2_rawIn_fractIn_2[15] ? 5'h7 : _in2_rawIn_normDist_T_124; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_126 = in2_rawIn_fractIn_2[16] ? 5'h6 : _in2_rawIn_normDist_T_125; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_127 = in2_rawIn_fractIn_2[17] ? 5'h5 : _in2_rawIn_normDist_T_126; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_128 = in2_rawIn_fractIn_2[18] ? 5'h4 : _in2_rawIn_normDist_T_127; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_129 = in2_rawIn_fractIn_2[19] ? 5'h3 : _in2_rawIn_normDist_T_128; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_130 = in2_rawIn_fractIn_2[20] ? 5'h2 : _in2_rawIn_normDist_T_129; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_131 = in2_rawIn_fractIn_2[21] ? 5'h1 : _in2_rawIn_normDist_T_130; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in2_rawIn_normDist_2 = in2_rawIn_fractIn_2[22] ? 5'h0 : _in2_rawIn_normDist_T_131; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_42 = {{31'd0}, in2_rawIn_fractIn_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in2_rawIn_subnormFract_T_4 = _GEN_42 << in2_rawIn_normDist_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in2_rawIn_subnormFract_2 = {_in2_rawIn_subnormFract_T_4[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_24 = {{4'd0}, in2_rawIn_normDist_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_10 = _GEN_24 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_11 = in2_rawIn_isZeroExpIn_2 ? _in2_rawIn_adjustedExp_T_10 : {{1'd0},
    in2_rawIn_expIn_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_12 = in2_rawIn_isZeroExpIn_2 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_25 = {{6'd0}, _in2_rawIn_adjustedExp_T_12}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in2_rawIn_adjustedExp_T_13 = 8'h80 | _GEN_25; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_26 = {{1'd0}, _in2_rawIn_adjustedExp_T_13}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in2_rawIn_adjustedExp_2 = _in2_rawIn_adjustedExp_T_11 + _GEN_26; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero_2 = in2_rawIn_isZeroExpIn_2 & in2_rawIn_isZeroFractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial_2 = in2_rawIn_adjustedExp_2[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn_2_isNaN = in2_rawIn_isSpecial_2 & ~in2_rawIn_isZeroFractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in2_rawIn_2_sExp = {1'b0,$signed(in2_rawIn_adjustedExp_2)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T_8 = ~in2_rawIn_isZero_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in2_rawIn_out_sig_T_10 = in2_rawIn_isZeroExpIn_2 ? in2_rawIn_subnormFract_2 : in2_rawIn_fractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in2_rawIn_2_sig = {1'h0,_in2_rawIn_out_sig_T_8,_in2_rawIn_out_sig_T_10}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_22 = in2_rawIn_isZero_2 ? 3'h0 : in2_rawIn_2_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_27 = {{2'd0}, in2_rawIn_2_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_24 = _in2_T_22 | _GEN_27; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [9:0] _in2_T_27 = {in2_rawIn_sign_2,_in2_T_24,in2_rawIn_2_sExp[5:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 49:45]
  wire  in2_rawIn_sign_3 = io_in_bits_b_3[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in2_rawIn_expIn_3 = io_in_bits_b_3[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in2_rawIn_fractIn_3 = io_in_bits_b_3[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn_3 = in2_rawIn_expIn_3 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn_3 = in2_rawIn_fractIn_3 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in2_rawIn_normDist_T_155 = in2_rawIn_fractIn_3[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_156 = in2_rawIn_fractIn_3[2] ? 5'h14 : _in2_rawIn_normDist_T_155; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_157 = in2_rawIn_fractIn_3[3] ? 5'h13 : _in2_rawIn_normDist_T_156; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_158 = in2_rawIn_fractIn_3[4] ? 5'h12 : _in2_rawIn_normDist_T_157; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_159 = in2_rawIn_fractIn_3[5] ? 5'h11 : _in2_rawIn_normDist_T_158; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_160 = in2_rawIn_fractIn_3[6] ? 5'h10 : _in2_rawIn_normDist_T_159; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_161 = in2_rawIn_fractIn_3[7] ? 5'hf : _in2_rawIn_normDist_T_160; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_162 = in2_rawIn_fractIn_3[8] ? 5'he : _in2_rawIn_normDist_T_161; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_163 = in2_rawIn_fractIn_3[9] ? 5'hd : _in2_rawIn_normDist_T_162; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_164 = in2_rawIn_fractIn_3[10] ? 5'hc : _in2_rawIn_normDist_T_163; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_165 = in2_rawIn_fractIn_3[11] ? 5'hb : _in2_rawIn_normDist_T_164; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_166 = in2_rawIn_fractIn_3[12] ? 5'ha : _in2_rawIn_normDist_T_165; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_167 = in2_rawIn_fractIn_3[13] ? 5'h9 : _in2_rawIn_normDist_T_166; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_168 = in2_rawIn_fractIn_3[14] ? 5'h8 : _in2_rawIn_normDist_T_167; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_169 = in2_rawIn_fractIn_3[15] ? 5'h7 : _in2_rawIn_normDist_T_168; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_170 = in2_rawIn_fractIn_3[16] ? 5'h6 : _in2_rawIn_normDist_T_169; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_171 = in2_rawIn_fractIn_3[17] ? 5'h5 : _in2_rawIn_normDist_T_170; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_172 = in2_rawIn_fractIn_3[18] ? 5'h4 : _in2_rawIn_normDist_T_171; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_173 = in2_rawIn_fractIn_3[19] ? 5'h3 : _in2_rawIn_normDist_T_172; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_174 = in2_rawIn_fractIn_3[20] ? 5'h2 : _in2_rawIn_normDist_T_173; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_175 = in2_rawIn_fractIn_3[21] ? 5'h1 : _in2_rawIn_normDist_T_174; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in2_rawIn_normDist_3 = in2_rawIn_fractIn_3[22] ? 5'h0 : _in2_rawIn_normDist_T_175; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_43 = {{31'd0}, in2_rawIn_fractIn_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in2_rawIn_subnormFract_T_6 = _GEN_43 << in2_rawIn_normDist_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in2_rawIn_subnormFract_3 = {_in2_rawIn_subnormFract_T_6[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_28 = {{4'd0}, in2_rawIn_normDist_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_15 = _GEN_28 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_16 = in2_rawIn_isZeroExpIn_3 ? _in2_rawIn_adjustedExp_T_15 : {{1'd0},
    in2_rawIn_expIn_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_17 = in2_rawIn_isZeroExpIn_3 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_29 = {{6'd0}, _in2_rawIn_adjustedExp_T_17}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in2_rawIn_adjustedExp_T_18 = 8'h80 | _GEN_29; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_30 = {{1'd0}, _in2_rawIn_adjustedExp_T_18}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in2_rawIn_adjustedExp_3 = _in2_rawIn_adjustedExp_T_16 + _GEN_30; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero_3 = in2_rawIn_isZeroExpIn_3 & in2_rawIn_isZeroFractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial_3 = in2_rawIn_adjustedExp_3[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn_3_isNaN = in2_rawIn_isSpecial_3 & ~in2_rawIn_isZeroFractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in2_rawIn_3_sExp = {1'b0,$signed(in2_rawIn_adjustedExp_3)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T_12 = ~in2_rawIn_isZero_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in2_rawIn_out_sig_T_14 = in2_rawIn_isZeroExpIn_3 ? in2_rawIn_subnormFract_3 : in2_rawIn_fractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in2_rawIn_3_sig = {1'h0,_in2_rawIn_out_sig_T_12,_in2_rawIn_out_sig_T_14}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_32 = in2_rawIn_isZero_3 ? 3'h0 : in2_rawIn_3_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_31 = {{2'd0}, in2_rawIn_3_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_34 = _in2_T_32 | _GEN_31; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [9:0] _in2_T_37 = {in2_rawIn_sign_3,_in2_T_34,in2_rawIn_3_sExp[5:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 49:45]
  wire  in3_rawIn_sign = io_in_bits_c[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in3_rawIn_expIn = io_in_bits_c[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in3_rawIn_fractIn = io_in_bits_c[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in3_rawIn_isZeroExpIn = in3_rawIn_expIn == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in3_rawIn_isZeroFractIn = in3_rawIn_fractIn == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in3_rawIn_normDist_T_23 = in3_rawIn_fractIn[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_24 = in3_rawIn_fractIn[2] ? 5'h14 : _in3_rawIn_normDist_T_23; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_25 = in3_rawIn_fractIn[3] ? 5'h13 : _in3_rawIn_normDist_T_24; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_26 = in3_rawIn_fractIn[4] ? 5'h12 : _in3_rawIn_normDist_T_25; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_27 = in3_rawIn_fractIn[5] ? 5'h11 : _in3_rawIn_normDist_T_26; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_28 = in3_rawIn_fractIn[6] ? 5'h10 : _in3_rawIn_normDist_T_27; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_29 = in3_rawIn_fractIn[7] ? 5'hf : _in3_rawIn_normDist_T_28; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_30 = in3_rawIn_fractIn[8] ? 5'he : _in3_rawIn_normDist_T_29; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_31 = in3_rawIn_fractIn[9] ? 5'hd : _in3_rawIn_normDist_T_30; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_32 = in3_rawIn_fractIn[10] ? 5'hc : _in3_rawIn_normDist_T_31; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_33 = in3_rawIn_fractIn[11] ? 5'hb : _in3_rawIn_normDist_T_32; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_34 = in3_rawIn_fractIn[12] ? 5'ha : _in3_rawIn_normDist_T_33; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_35 = in3_rawIn_fractIn[13] ? 5'h9 : _in3_rawIn_normDist_T_34; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_36 = in3_rawIn_fractIn[14] ? 5'h8 : _in3_rawIn_normDist_T_35; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_37 = in3_rawIn_fractIn[15] ? 5'h7 : _in3_rawIn_normDist_T_36; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_38 = in3_rawIn_fractIn[16] ? 5'h6 : _in3_rawIn_normDist_T_37; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_39 = in3_rawIn_fractIn[17] ? 5'h5 : _in3_rawIn_normDist_T_38; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_40 = in3_rawIn_fractIn[18] ? 5'h4 : _in3_rawIn_normDist_T_39; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_41 = in3_rawIn_fractIn[19] ? 5'h3 : _in3_rawIn_normDist_T_40; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_42 = in3_rawIn_fractIn[20] ? 5'h2 : _in3_rawIn_normDist_T_41; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in3_rawIn_normDist_T_43 = in3_rawIn_fractIn[21] ? 5'h1 : _in3_rawIn_normDist_T_42; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in3_rawIn_normDist = in3_rawIn_fractIn[22] ? 5'h0 : _in3_rawIn_normDist_T_43; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_44 = {{31'd0}, in3_rawIn_fractIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in3_rawIn_subnormFract_T = _GEN_44 << in3_rawIn_normDist; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in3_rawIn_subnormFract = {_in3_rawIn_subnormFract_T[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_32 = {{4'd0}, in3_rawIn_normDist}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in3_rawIn_adjustedExp_T = _GEN_32 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in3_rawIn_adjustedExp_T_1 = in3_rawIn_isZeroExpIn ? _in3_rawIn_adjustedExp_T : {{1'd0}, in3_rawIn_expIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in3_rawIn_adjustedExp_T_2 = in3_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_33 = {{6'd0}, _in3_rawIn_adjustedExp_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in3_rawIn_adjustedExp_T_3 = 8'h80 | _GEN_33; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_34 = {{1'd0}, _in3_rawIn_adjustedExp_T_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in3_rawIn_adjustedExp = _in3_rawIn_adjustedExp_T_1 + _GEN_34; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in3_rawIn_isZero = in3_rawIn_isZeroExpIn & in3_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in3_rawIn_isSpecial = in3_rawIn_adjustedExp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in3_rawIn__isNaN = in3_rawIn_isSpecial & ~in3_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in3_rawIn__sExp = {1'b0,$signed(in3_rawIn_adjustedExp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in3_rawIn_out_sig_T = ~in3_rawIn_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in3_rawIn_out_sig_T_2 = in3_rawIn_isZeroExpIn ? in3_rawIn_subnormFract : in3_rawIn_fractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in3_rawIn__sig = {1'h0,_in3_rawIn_out_sig_T,_in3_rawIn_out_sig_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in3_T_2 = in3_rawIn_isZero ? 3'h0 : in3_rawIn__sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_35 = {{2'd0}, in3_rawIn__isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in3_T_4 = _in3_T_2 | _GEN_35; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [9:0] _in3_T_7 = {in3_rawIn_sign,_in3_T_4,in3_rawIn__sExp[5:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 49:45]
  wire [8:0] io_out_bits_data_rawIn_exp = dpu_io_out_bits_data[31:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  io_out_bits_data_rawIn_isZero = io_out_bits_data_rawIn_exp[8:6] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  io_out_bits_data_rawIn_isSpecial = io_out_bits_data_rawIn_exp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  io_out_bits_data_rawIn__isNaN = io_out_bits_data_rawIn_isSpecial & io_out_bits_data_rawIn_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  io_out_bits_data_rawIn__isInf = io_out_bits_data_rawIn_isSpecial & ~io_out_bits_data_rawIn_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  io_out_bits_data_rawIn__sign = dpu_io_out_bits_data[32]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [9:0] io_out_bits_data_rawIn__sExp = {1'b0,$signed(io_out_bits_data_rawIn_exp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _io_out_bits_data_rawIn_out_sig_T = ~io_out_bits_data_rawIn_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [24:0] io_out_bits_data_rawIn__sig = {1'h0,_io_out_bits_data_rawIn_out_sig_T,dpu_io_out_bits_data[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  wire  io_out_bits_data_isSubnormal = $signed(io_out_bits_data_rawIn__sExp) < 10'sh82; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 51:38]
  wire [4:0] io_out_bits_data_denormShiftDist = 5'h1 - io_out_bits_data_rawIn__sExp[4:0]; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 52:35]
  wire [23:0] _io_out_bits_data_denormFract_T_1 = io_out_bits_data_rawIn__sig[24:1] >> io_out_bits_data_denormShiftDist; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 53:42]
  wire [22:0] io_out_bits_data_denormFract = _io_out_bits_data_denormFract_T_1[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 53:60]
  wire [7:0] _io_out_bits_data_expOut_T_2 = io_out_bits_data_rawIn__sExp[7:0] - 8'h81; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 58:45]
  wire [7:0] _io_out_bits_data_expOut_T_3 = io_out_bits_data_isSubnormal ? 8'h0 : _io_out_bits_data_expOut_T_2; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 56:16]
  wire [7:0] _io_out_bits_data_expOut_T_5 = io_out_bits_data_rawIn__isNaN | io_out_bits_data_rawIn__isInf ? 8'hff : 8'h0
    ; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 60:21]
  wire [7:0] io_out_bits_data_expOut = _io_out_bits_data_expOut_T_3 | _io_out_bits_data_expOut_T_5; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 60:15]
  wire [22:0] _io_out_bits_data_fractOut_T_1 = io_out_bits_data_rawIn__isInf ? 23'h0 : io_out_bits_data_rawIn__sig[22:0]
    ; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 64:20]
  wire [22:0] io_out_bits_data_fractOut = io_out_bits_data_isSubnormal ? io_out_bits_data_denormFract :
    _io_out_bits_data_fractOut_T_1; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 62:16]
  wire [8:0] io_out_bits_data_hi = {io_out_bits_data_rawIn__sign,io_out_bits_data_expOut}; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 66:12]
  DotProductPipe dpu ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 35:19]
    .clock(dpu_clock),
    .reset(dpu_reset),
    .io_in_valid(dpu_io_in_valid),
    .io_in_bits_a_0(dpu_io_in_bits_a_0),
    .io_in_bits_a_1(dpu_io_in_bits_a_1),
    .io_in_bits_a_2(dpu_io_in_bits_a_2),
    .io_in_bits_a_3(dpu_io_in_bits_a_3),
    .io_in_bits_b_0(dpu_io_in_bits_b_0),
    .io_in_bits_b_1(dpu_io_in_bits_b_1),
    .io_in_bits_b_2(dpu_io_in_bits_b_2),
    .io_in_bits_b_3(dpu_io_in_bits_b_3),
    .io_in_bits_c(dpu_io_in_bits_c),
    .io_stall(dpu_io_stall),
    .io_out_valid(dpu_io_out_valid),
    .io_out_bits_data(dpu_io_out_bits_data)
  );
  assign io_out_valid = dpu_io_out_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 42:16]
  assign io_out_bits_data = {io_out_bits_data_hi,io_out_bits_data_fractOut}; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 66:12]
  assign dpu_clock = clock;
  assign dpu_reset = reset;
  assign dpu_io_in_valid = io_in_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 36:19]
  assign dpu_io_in_bits_a_0 = {_in1_T_7,in1_rawIn__sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  assign dpu_io_in_bits_a_1 = {_in1_T_17,in1_rawIn_1_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  assign dpu_io_in_bits_a_2 = {_in1_T_27,in1_rawIn_2_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  assign dpu_io_in_bits_a_3 = {_in1_T_37,in1_rawIn_3_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  assign dpu_io_in_bits_b_0 = {_in2_T_7,in2_rawIn__sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  assign dpu_io_in_bits_b_1 = {_in2_T_17,in2_rawIn_1_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  assign dpu_io_in_bits_b_2 = {_in2_T_27,in2_rawIn_2_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  assign dpu_io_in_bits_b_3 = {_in2_T_37,in2_rawIn_3_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  assign dpu_io_in_bits_c = {_in3_T_7,in3_rawIn__sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  assign dpu_io_stall = io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 40:16]
endmodule
