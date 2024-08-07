module TensorMulFullRawFN( // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 47:7]
  input         io_a_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_a_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_a_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_a_sign, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input  [6:0]  io_a_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input  [11:0] io_a_sig, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_b_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_b_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_b_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input         io_b_sign, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input  [6:0]  io_b_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  input  [11:0] io_b_sig, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output        io_invalidExc, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output        io_rawOut_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output        io_rawOut_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output        io_rawOut_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output        io_rawOut_sign, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output [6:0]  io_rawOut_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
  output [21:0] io_rawOut_sig // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 49:16]
);
  wire  notSigNaN_invalidExc = io_a_isInf & io_b_isZero | io_a_isZero & io_b_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 58:60]
  wire [6:0] _common_sExpOut_T_2 = $signed(io_a_sExp) + $signed(io_b_sExp); // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 62:36]
  wire [23:0] _common_sigOut_T = io_a_sig * io_b_sig; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 63:35]
  wire  _io_invalidExc_T_2 = io_a_isNaN & ~io_a_sig[9]; // @[generators/hardfloat/hardfloat/src/main/scala/common.scala 82:46]
  wire  _io_invalidExc_T_5 = io_b_isNaN & ~io_b_sig[9]; // @[generators/hardfloat/hardfloat/src/main/scala/common.scala 82:46]
  assign io_invalidExc = _io_invalidExc_T_2 | _io_invalidExc_T_5 | notSigNaN_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 66:71]
  assign io_rawOut_isNaN = io_a_isNaN | io_b_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 70:35]
  assign io_rawOut_isInf = io_a_isInf | io_b_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 59:38]
  assign io_rawOut_isZero = io_a_isZero | io_b_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 60:40]
  assign io_rawOut_sign = io_a_sign ^ io_b_sign; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 61:36]
  assign io_rawOut_sExp = $signed(_common_sExpOut_T_2) - 7'sh20; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 62:48]
  assign io_rawOut_sig = _common_sigOut_T[21:0]; // @[generators/hardfloat/hardfloat/src/main/scala/MulRecFN.scala 63:46]
endmodule
module TensorRoundAnyRawFNToRecFN_ie5_is21_oe8_os24( // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 48:5]
  input         io_invalidExc, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input         io_in_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input         io_in_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input         io_in_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input         io_in_sign, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input  [6:0]  io_in_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input  [21:0] io_in_sig, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  output [32:0] io_out // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
);
  wire [8:0] _GEN_0 = {{2{io_in_sExp[6]}},io_in_sExp}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 104:25]
  wire [9:0] _sAdjustedExp_T = $signed(_GEN_0) + 9'she0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 104:25]
  wire [9:0] sAdjustedExp = {1'b0,$signed(_sAdjustedExp_T[8:0])}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 106:31]
  wire [26:0] adjustedSig = {io_in_sig, 5'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 114:22]
  wire  doShiftSigDown1 = adjustedSig[26]; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 120:57]
  wire [8:0] _GEN_1 = {{8'd0}, doShiftSigDown1}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 136:55]
  wire [8:0] common_expOut = sAdjustedExp[8:0] + _GEN_1; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 136:55]
  wire [22:0] common_fractOut = doShiftSigDown1 ? adjustedSig[25:3] : adjustedSig[24:2]; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 138:16]
  wire  isNaNOut = io_invalidExc | io_in_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 235:34]
  wire  signOut = isNaNOut ? 1'h0 : io_in_sign; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 250:22]
  wire [8:0] _expOut_T_1 = io_in_isZero ? 9'h1c0 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 253:18]
  wire [8:0] _expOut_T_2 = ~_expOut_T_1; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 253:14]
  wire [8:0] _expOut_T_3 = common_expOut & _expOut_T_2; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 252:24]
  wire [8:0] _expOut_T_11 = io_in_isInf ? 9'h40 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 265:18]
  wire [8:0] _expOut_T_12 = ~_expOut_T_11; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 265:14]
  wire [8:0] _expOut_T_13 = _expOut_T_3 & _expOut_T_12; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 264:17]
  wire [8:0] _expOut_T_18 = io_in_isInf ? 9'h180 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 277:16]
  wire [8:0] _expOut_T_19 = _expOut_T_13 | _expOut_T_18; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 276:15]
  wire [8:0] _expOut_T_20 = isNaNOut ? 9'h1c0 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 278:16]
  wire [8:0] expOut = _expOut_T_19 | _expOut_T_20; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 277:73]
  wire [22:0] _fractOut_T_2 = isNaNOut ? 23'h400000 : 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 281:16]
  wire [22:0] fractOut = isNaNOut | io_in_isZero ? _fractOut_T_2 : common_fractOut; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 280:12]
  wire [9:0] _io_out_T = {signOut,expOut}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 286:23]
  assign io_out = {_io_out_T,fractOut}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 286:33]
endmodule
module StallingPipe( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 56:7]
  input         clock, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 56:7]
  input         reset, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 56:7]
  input         io_stall, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  input         io_enq_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  input  [32:0] io_enq_bits_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  input  [32:0] io_enq_bits_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  input  [32:0] io_enq_bits_2, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  input  [32:0] io_enq_bits_3, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  output        io_deq_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  output [32:0] io_deq_bits_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  output [32:0] io_deq_bits_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  output [32:0] io_deq_bits_2, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  output [32:0] io_deq_bits_3 // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [63:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire  _v_T = ~io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:44]
  reg  v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
  reg [32:0] b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
  reg [32:0] b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
  reg [32:0] b_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
  reg [32:0] b_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
  assign io_deq_valid = v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 75:16]
  assign io_deq_bits_0 = b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 76:15]
  assign io_deq_bits_1 = b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 76:15]
  assign io_deq_bits_2 = b_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 76:15]
  assign io_deq_bits_3 = b_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 76:15]
  always @(posedge clock) begin
    if (reset) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
      v <= 1'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
    end else if (~io_stall) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
      v <= io_enq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
    end
    if (_v_T & io_enq_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
      b_0 <= io_enq_bits_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
    end
    if (_v_T & io_enq_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
      b_1 <= io_enq_bits_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
    end
    if (_v_T & io_enq_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
      b_2 <= io_enq_bits_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
    end
    if (_v_T & io_enq_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
      b_3 <= io_enq_bits_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
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
  v = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  b_0 = _RAND_1[32:0];
  _RAND_2 = {2{`RANDOM}};
  b_1 = _RAND_2[32:0];
  _RAND_3 = {2{`RANDOM}};
  b_2 = _RAND_3[32:0];
  _RAND_4 = {2{`RANDOM}};
  b_3 = _RAND_4[32:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StallingPipe_1( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 56:7]
  input         clock, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 56:7]
  input         reset, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 56:7]
  input         io_stall, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  input         io_enq_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  input  [32:0] io_enq_bits, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  output        io_deq_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  output [32:0] io_deq_bits // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  wire  _v_T = ~io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:44]
  reg  v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
  reg [32:0] b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
  assign io_deq_valid = v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 75:16]
  assign io_deq_bits = b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 76:15]
  always @(posedge clock) begin
    if (reset) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
      v <= 1'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
    end else if (~io_stall) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
      v <= io_enq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
    end
    if (_v_T & io_enq_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
      b <= io_enq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
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
  v = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  b = _RAND_1[32:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
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
module TensorRoundAnyRawFNToRecFN_ie8_is26_oe8_os24( // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 48:5]
  input         io_invalidExc, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input         io_in_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input         io_in_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input         io_in_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input         io_in_sign, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input  [9:0]  io_in_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  input  [26:0] io_in_sig, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
  output [32:0] io_out // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 58:16]
);
  wire  doShiftSigDown1 = io_in_sig[26]; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 120:57]
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
  wire [24:0] _GEN_4 = {{24'd0}, doShiftSigDown1}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 159:23]
  wire [24:0] _roundMask_T_74 = _roundMask_T_73 | _GEN_4; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 159:23]
  wire [26:0] roundMask = {_roundMask_T_74,2'h3}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 159:42]
  wire [27:0] _shiftedRoundMask_T = {1'h0,_roundMask_T_74,2'h3}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 162:41]
  wire [26:0] shiftedRoundMask = _shiftedRoundMask_T[27:1]; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 162:53]
  wire [26:0] _roundPosMask_T = ~shiftedRoundMask; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 163:28]
  wire [26:0] roundPosMask = _roundPosMask_T & roundMask; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 163:46]
  wire [26:0] _roundPosBit_T = io_in_sig & roundPosMask; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 164:40]
  wire  roundPosBit = |_roundPosBit_T; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 164:56]
  wire [26:0] _anyRoundExtra_T = io_in_sig & shiftedRoundMask; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 165:42]
  wire  anyRoundExtra = |_anyRoundExtra_T; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 165:62]
  wire [26:0] _roundedSig_T = io_in_sig | roundMask; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 174:32]
  wire [25:0] _roundedSig_T_2 = _roundedSig_T[26:2] + 25'h1; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 174:49]
  wire  _roundedSig_T_4 = ~anyRoundExtra; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 176:30]
  wire [25:0] _roundedSig_T_7 = roundPosBit & _roundedSig_T_4 ? roundMask[26:1] : 26'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 175:25]
  wire [25:0] _roundedSig_T_8 = ~_roundedSig_T_7; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 175:21]
  wire [25:0] _roundedSig_T_9 = _roundedSig_T_2 & _roundedSig_T_8; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 174:57]
  wire [26:0] _roundedSig_T_10 = ~roundMask; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 180:32]
  wire [26:0] _roundedSig_T_11 = io_in_sig & _roundedSig_T_10; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 180:30]
  wire [25:0] _roundedSig_T_16 = {{1'd0}, _roundedSig_T_11[26:2]}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 180:47]
  wire [25:0] roundedSig = roundPosBit ? _roundedSig_T_9 : _roundedSig_T_16; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 173:16]
  wire [2:0] _sRoundedExp_T_1 = {1'b0,$signed(roundedSig[25:24])}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 185:76]
  wire [9:0] _GEN_5 = {{7{_sRoundedExp_T_1[2]}},_sRoundedExp_T_1}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 185:40]
  wire [10:0] sRoundedExp = $signed(io_in_sExp) + $signed(_GEN_5); // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 185:40]
  wire [8:0] common_expOut = sRoundedExp[8:0]; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 187:37]
  wire [22:0] common_fractOut = doShiftSigDown1 ? roundedSig[23:1] : roundedSig[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 189:16]
  wire [3:0] _common_overflow_T = sRoundedExp[10:7]; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 196:30]
  wire  common_overflow = $signed(_common_overflow_T) >= 4'sh3; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 196:50]
  wire  common_totalUnderflow = $signed(sRoundedExp) < 11'sh6b; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 200:31]
  wire  isNaNOut = io_invalidExc | io_in_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 235:34]
  wire  commonCase = ~isNaNOut & ~io_in_isInf & ~io_in_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 237:61]
  wire  overflow = commonCase & common_overflow; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 238:32]
  wire  notNaN_isInfOut = io_in_isInf | overflow; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 248:32]
  wire  signOut = isNaNOut ? 1'h0 : io_in_sign; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 250:22]
  wire [8:0] _expOut_T_1 = io_in_isZero | common_totalUnderflow ? 9'h1c0 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 253:18]
  wire [8:0] _expOut_T_2 = ~_expOut_T_1; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 253:14]
  wire [8:0] _expOut_T_3 = common_expOut & _expOut_T_2; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 252:24]
  wire [8:0] _expOut_T_11 = notNaN_isInfOut ? 9'h40 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 265:18]
  wire [8:0] _expOut_T_12 = ~_expOut_T_11; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 265:14]
  wire [8:0] _expOut_T_13 = _expOut_T_3 & _expOut_T_12; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 264:17]
  wire [8:0] _expOut_T_18 = notNaN_isInfOut ? 9'h180 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 277:16]
  wire [8:0] _expOut_T_19 = _expOut_T_13 | _expOut_T_18; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 276:15]
  wire [8:0] _expOut_T_20 = isNaNOut ? 9'h1c0 : 9'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 278:16]
  wire [8:0] expOut = _expOut_T_19 | _expOut_T_20; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 277:73]
  wire [22:0] _fractOut_T_2 = isNaNOut ? 23'h400000 : 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 281:16]
  wire [22:0] fractOut = isNaNOut | io_in_isZero | common_totalUnderflow ? _fractOut_T_2 : common_fractOut; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 280:12]
  wire [9:0] _io_out_T = {signOut,expOut}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 286:23]
  assign io_out = {_io_out_T,fractOut}; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 286:33]
endmodule
module TensorRoundRawFNToRecFN_e8_s24( // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 295:5]
  input         io_invalidExc, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 299:16]
  input         io_in_isNaN, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 299:16]
  input         io_in_isInf, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 299:16]
  input         io_in_isZero, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 299:16]
  input         io_in_sign, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 299:16]
  input  [9:0]  io_in_sExp, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 299:16]
  input  [26:0] io_in_sig, // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 299:16]
  output [32:0] io_out // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 299:16]
);
  wire  roundAnyRawFNToRecFN_io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_sign; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 310:15]
  wire [9:0] roundAnyRawFNToRecFN_io_in_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 310:15]
  wire [26:0] roundAnyRawFNToRecFN_io_in_sig; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 310:15]
  wire [32:0] roundAnyRawFNToRecFN_io_out; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 310:15]
  TensorRoundAnyRawFNToRecFN_ie8_is26_oe8_os24 roundAnyRawFNToRecFN ( // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 310:15]
    .io_invalidExc(roundAnyRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundAnyRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundAnyRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundAnyRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundAnyRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundAnyRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundAnyRawFNToRecFN_io_in_sig),
    .io_out(roundAnyRawFNToRecFN_io_out)
  );
  assign io_out = roundAnyRawFNToRecFN_io_out; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 318:23]
  assign roundAnyRawFNToRecFN_io_invalidExc = io_invalidExc; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_isNaN = io_in_isNaN; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_in_isInf = io_in_isInf; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_in_isZero = io_in_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_in_sign = io_in_sign; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_in_sExp = io_in_sExp; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_in_sig = io_in_sig; // @[generators/hardfloat/hardfloat/src/main/scala/TensorRoundAnyRawFNToRecFN.scala 315:44]
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
  TensorRoundRawFNToRecFN_e8_s24 roundRawFNToRecFN ( // @[generators/hardfloat/hardfloat/src/main/scala/AddRecFN.scala 157:15]
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
module StallingPipe_2( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 56:7]
  input         clock, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 56:7]
  input         reset, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 56:7]
  input         io_stall, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  input         io_enq_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  input  [32:0] io_enq_bits_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  input  [32:0] io_enq_bits_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  output        io_deq_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  output [32:0] io_deq_bits_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
  output [32:0] io_deq_bits_1 // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 71:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  wire  _v_T = ~io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:44]
  reg  v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
  reg [32:0] b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
  reg [32:0] b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
  assign io_deq_valid = v; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 75:16]
  assign io_deq_bits_0 = b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 76:15]
  assign io_deq_bits_1 = b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 76:15]
  always @(posedge clock) begin
    if (reset) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
      v <= 1'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
    end else if (~io_stall) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
      v <= io_enq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 73:20]
    end
    if (_v_T & io_enq_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
      b_0 <= io_enq_bits_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
    end
    if (_v_T & io_enq_valid) begin // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
      b_1 <= io_enq_bits_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 74:20]
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
  v = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  b_0 = _RAND_1[32:0];
  _RAND_2 = {2{`RANDOM}};
  b_1 = _RAND_2[32:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module DotProductPipe( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 101:7]
  input         clock, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 101:7]
  input         reset, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 101:7]
  input         io_in_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  input  [16:0] io_in_bits_a_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  input  [16:0] io_in_bits_a_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  input  [16:0] io_in_bits_a_2, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  input  [16:0] io_in_bits_a_3, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  input  [16:0] io_in_bits_b_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  input  [16:0] io_in_bits_b_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  input  [16:0] io_in_bits_b_2, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  input  [16:0] io_in_bits_b_3, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  input  [32:0] io_in_bits_c, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  input         io_stall, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  output        io_out_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
  output [32:0] io_out_bits_data // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 110:14]
);
  wire  mul_0_io_a_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_a_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_a_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_a_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_0_io_a_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [11:0] mul_0_io_a_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_b_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_b_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_b_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_b_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_0_io_b_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [11:0] mul_0_io_b_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_rawOut_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_rawOut_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_rawOut_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_0_io_rawOut_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_0_io_rawOut_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [21:0] mul_0_io_rawOut_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_a_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_a_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_a_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_a_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_1_io_a_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [11:0] mul_1_io_a_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_b_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_b_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_b_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_b_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_1_io_b_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [11:0] mul_1_io_b_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_rawOut_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_rawOut_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_rawOut_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_1_io_rawOut_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_1_io_rawOut_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [21:0] mul_1_io_rawOut_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_a_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_a_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_a_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_a_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_2_io_a_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [11:0] mul_2_io_a_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_b_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_b_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_b_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_b_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_2_io_b_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [11:0] mul_2_io_b_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_rawOut_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_rawOut_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_rawOut_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_2_io_rawOut_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_2_io_rawOut_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [21:0] mul_2_io_rawOut_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_a_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_a_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_a_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_a_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_3_io_a_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [11:0] mul_3_io_a_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_b_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_b_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_b_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_b_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_3_io_b_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [11:0] mul_3_io_b_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_rawOut_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_rawOut_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_rawOut_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mul_3_io_rawOut_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [6:0] mul_3_io_rawOut_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire [21:0] mul_3_io_rawOut_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
  wire  mulOuts_roundRawFNToRecFN_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_io_in_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_io_in_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_io_in_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_io_in_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [6:0] mulOuts_roundRawFNToRecFN_io_in_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [21:0] mulOuts_roundRawFNToRecFN_io_in_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [32:0] mulOuts_roundRawFNToRecFN_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_1_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_1_io_in_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_1_io_in_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_1_io_in_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_1_io_in_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [6:0] mulOuts_roundRawFNToRecFN_1_io_in_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [21:0] mulOuts_roundRawFNToRecFN_1_io_in_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [32:0] mulOuts_roundRawFNToRecFN_1_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_2_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_2_io_in_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_2_io_in_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_2_io_in_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_2_io_in_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [6:0] mulOuts_roundRawFNToRecFN_2_io_in_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [21:0] mulOuts_roundRawFNToRecFN_2_io_in_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [32:0] mulOuts_roundRawFNToRecFN_2_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_3_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_3_io_in_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_3_io_in_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_3_io_in_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulOuts_roundRawFNToRecFN_3_io_in_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [6:0] mulOuts_roundRawFNToRecFN_3_io_in_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [21:0] mulOuts_roundRawFNToRecFN_3_io_in_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire [32:0] mulOuts_roundRawFNToRecFN_3_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
  wire  mulStageOut_p_clock; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  mulStageOut_p_reset; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  mulStageOut_p_io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  mulStageOut_p_io_enq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] mulStageOut_p_io_enq_bits_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] mulStageOut_p_io_enq_bits_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] mulStageOut_p_io_enq_bits_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] mulStageOut_p_io_enq_bits_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  mulStageOut_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] mulStageOut_p_io_deq_bits_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] mulStageOut_p_io_deq_bits_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] mulStageOut_p_io_deq_bits_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] mulStageOut_p_io_deq_bits_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  mulStageC_p_clock; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  mulStageC_p_reset; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  mulStageC_p_io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  mulStageC_p_io_enq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] mulStageC_p_io_enq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  mulStageC_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] mulStageC_p_io_deq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add1_0_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 161:38]
  wire [32:0] add1_0_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 161:38]
  wire [32:0] add1_0_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 161:38]
  wire [32:0] add1_1_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 161:38]
  wire [32:0] add1_1_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 161:38]
  wire [32:0] add1_1_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 161:38]
  wire  add1StageOut_p_clock; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add1StageOut_p_reset; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add1StageOut_p_io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add1StageOut_p_io_enq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add1StageOut_p_io_enq_bits_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add1StageOut_p_io_enq_bits_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add1StageOut_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add1StageOut_p_io_deq_bits_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add1StageOut_p_io_deq_bits_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add1StageC_p_clock; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add1StageC_p_reset; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add1StageC_p_io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add1StageC_p_io_enq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add1StageC_p_io_enq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add1StageC_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add1StageC_p_io_deq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add2_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 177:20]
  wire [32:0] add2_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 177:20]
  wire [32:0] add2_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 177:20]
  wire  add2StageOut_p_clock; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add2StageOut_p_reset; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add2StageOut_p_io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add2StageOut_p_io_enq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add2StageOut_p_io_enq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add2StageOut_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add2StageOut_p_io_deq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add2StageC_p_clock; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add2StageC_p_reset; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add2StageC_p_io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add2StageC_p_io_enq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add2StageC_p_io_enq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  add2StageC_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] add2StageC_p_io_deq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] acc_io_a; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 190:19]
  wire [32:0] acc_io_b; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 190:19]
  wire [32:0] acc_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 190:19]
  wire  accStageOut_p_clock; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  accStageOut_p_reset; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  accStageOut_p_io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  accStageOut_p_io_enq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] accStageOut_p_io_enq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire  accStageOut_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [32:0] accStageOut_p_io_deq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
  wire [6:0] rawZero__sExp = {1'b0,$signed(6'h0)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire [5:0] mulOuts_rawInA_exp = io_in_bits_a_0[15:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  mulOuts_rawInA_isZero = mulOuts_rawInA_exp[5:3] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  mulOuts_rawInA_isSpecial = mulOuts_rawInA_exp[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  mulOuts_rawInA__isNaN = mulOuts_rawInA_isSpecial & mulOuts_rawInA_exp[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  mulOuts_rawInA__isInf = mulOuts_rawInA_isSpecial & ~mulOuts_rawInA_exp[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  mulOuts_rawInA__sign = io_in_bits_a_0[16]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [6:0] mulOuts_rawInA__sExp = {1'b0,$signed(mulOuts_rawInA_exp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _mulOuts_rawInA_out_sig_T = ~mulOuts_rawInA_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [11:0] mulOuts_rawInA__sig = {1'h0,_mulOuts_rawInA_out_sig_T,io_in_bits_a_0[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  wire [5:0] mulOuts_rawInB_exp = io_in_bits_b_0[15:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  mulOuts_rawInB_isZero = mulOuts_rawInB_exp[5:3] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  mulOuts_rawInB_isSpecial = mulOuts_rawInB_exp[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  mulOuts_rawInB__isNaN = mulOuts_rawInB_isSpecial & mulOuts_rawInB_exp[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  mulOuts_rawInB__isInf = mulOuts_rawInB_isSpecial & ~mulOuts_rawInB_exp[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  mulOuts_rawInB__sign = io_in_bits_b_0[16]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [6:0] mulOuts_rawInB__sExp = {1'b0,$signed(mulOuts_rawInB_exp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _mulOuts_rawInB_out_sig_T = ~mulOuts_rawInB_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [11:0] mulOuts_rawInB__sig = {1'h0,_mulOuts_rawInB_out_sig_T,io_in_bits_b_0[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  wire [5:0] mulOuts_rawInA_exp_1 = io_in_bits_a_1[15:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  mulOuts_rawInA_isZero_1 = mulOuts_rawInA_exp_1[5:3] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  mulOuts_rawInA_isSpecial_1 = mulOuts_rawInA_exp_1[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  mulOuts_rawInA_1_isNaN = mulOuts_rawInA_isSpecial_1 & mulOuts_rawInA_exp_1[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  mulOuts_rawInA_1_isInf = mulOuts_rawInA_isSpecial_1 & ~mulOuts_rawInA_exp_1[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  mulOuts_rawInA_1_sign = io_in_bits_a_1[16]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [6:0] mulOuts_rawInA_1_sExp = {1'b0,$signed(mulOuts_rawInA_exp_1)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _mulOuts_rawInA_out_sig_T_4 = ~mulOuts_rawInA_isZero_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [11:0] mulOuts_rawInA_1_sig = {1'h0,_mulOuts_rawInA_out_sig_T_4,io_in_bits_a_1[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  wire [5:0] mulOuts_rawInB_exp_1 = io_in_bits_b_1[15:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  mulOuts_rawInB_isZero_1 = mulOuts_rawInB_exp_1[5:3] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  mulOuts_rawInB_isSpecial_1 = mulOuts_rawInB_exp_1[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  mulOuts_rawInB_1_isNaN = mulOuts_rawInB_isSpecial_1 & mulOuts_rawInB_exp_1[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  mulOuts_rawInB_1_isInf = mulOuts_rawInB_isSpecial_1 & ~mulOuts_rawInB_exp_1[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  mulOuts_rawInB_1_sign = io_in_bits_b_1[16]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [6:0] mulOuts_rawInB_1_sExp = {1'b0,$signed(mulOuts_rawInB_exp_1)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _mulOuts_rawInB_out_sig_T_4 = ~mulOuts_rawInB_isZero_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [11:0] mulOuts_rawInB_1_sig = {1'h0,_mulOuts_rawInB_out_sig_T_4,io_in_bits_b_1[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  wire [5:0] mulOuts_rawInA_exp_2 = io_in_bits_a_2[15:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  mulOuts_rawInA_isZero_2 = mulOuts_rawInA_exp_2[5:3] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  mulOuts_rawInA_isSpecial_2 = mulOuts_rawInA_exp_2[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  mulOuts_rawInA_2_isNaN = mulOuts_rawInA_isSpecial_2 & mulOuts_rawInA_exp_2[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  mulOuts_rawInA_2_isInf = mulOuts_rawInA_isSpecial_2 & ~mulOuts_rawInA_exp_2[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  mulOuts_rawInA_2_sign = io_in_bits_a_2[16]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [6:0] mulOuts_rawInA_2_sExp = {1'b0,$signed(mulOuts_rawInA_exp_2)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _mulOuts_rawInA_out_sig_T_8 = ~mulOuts_rawInA_isZero_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [11:0] mulOuts_rawInA_2_sig = {1'h0,_mulOuts_rawInA_out_sig_T_8,io_in_bits_a_2[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  wire [5:0] mulOuts_rawInB_exp_2 = io_in_bits_b_2[15:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  mulOuts_rawInB_isZero_2 = mulOuts_rawInB_exp_2[5:3] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  mulOuts_rawInB_isSpecial_2 = mulOuts_rawInB_exp_2[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  mulOuts_rawInB_2_isNaN = mulOuts_rawInB_isSpecial_2 & mulOuts_rawInB_exp_2[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  mulOuts_rawInB_2_isInf = mulOuts_rawInB_isSpecial_2 & ~mulOuts_rawInB_exp_2[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  mulOuts_rawInB_2_sign = io_in_bits_b_2[16]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [6:0] mulOuts_rawInB_2_sExp = {1'b0,$signed(mulOuts_rawInB_exp_2)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _mulOuts_rawInB_out_sig_T_8 = ~mulOuts_rawInB_isZero_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [11:0] mulOuts_rawInB_2_sig = {1'h0,_mulOuts_rawInB_out_sig_T_8,io_in_bits_b_2[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  wire [5:0] mulOuts_rawInA_exp_3 = io_in_bits_a_3[15:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  mulOuts_rawInA_isZero_3 = mulOuts_rawInA_exp_3[5:3] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  mulOuts_rawInA_isSpecial_3 = mulOuts_rawInA_exp_3[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  mulOuts_rawInA_3_isNaN = mulOuts_rawInA_isSpecial_3 & mulOuts_rawInA_exp_3[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  mulOuts_rawInA_3_isInf = mulOuts_rawInA_isSpecial_3 & ~mulOuts_rawInA_exp_3[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  mulOuts_rawInA_3_sign = io_in_bits_a_3[16]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [6:0] mulOuts_rawInA_3_sExp = {1'b0,$signed(mulOuts_rawInA_exp_3)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _mulOuts_rawInA_out_sig_T_12 = ~mulOuts_rawInA_isZero_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [11:0] mulOuts_rawInA_3_sig = {1'h0,_mulOuts_rawInA_out_sig_T_12,io_in_bits_a_3[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  wire [5:0] mulOuts_rawInB_exp_3 = io_in_bits_b_3[15:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  mulOuts_rawInB_isZero_3 = mulOuts_rawInB_exp_3[5:3] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  mulOuts_rawInB_isSpecial_3 = mulOuts_rawInB_exp_3[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  mulOuts_rawInB_3_isNaN = mulOuts_rawInB_isSpecial_3 & mulOuts_rawInB_exp_3[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  mulOuts_rawInB_3_isInf = mulOuts_rawInB_isSpecial_3 & ~mulOuts_rawInB_exp_3[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  mulOuts_rawInB_3_sign = io_in_bits_b_3[16]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [6:0] mulOuts_rawInB_3_sExp = {1'b0,$signed(mulOuts_rawInB_exp_3)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _mulOuts_rawInB_out_sig_T_12 = ~mulOuts_rawInB_isZero_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [11:0] mulOuts_rawInB_3_sig = {1'h0,_mulOuts_rawInB_out_sig_T_12,io_in_bits_b_3[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  TensorMulFullRawFN mul_0 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
    .io_a_isNaN(mul_0_io_a_isNaN),
    .io_a_isInf(mul_0_io_a_isInf),
    .io_a_isZero(mul_0_io_a_isZero),
    .io_a_sign(mul_0_io_a_sign),
    .io_a_sExp(mul_0_io_a_sExp),
    .io_a_sig(mul_0_io_a_sig),
    .io_b_isNaN(mul_0_io_b_isNaN),
    .io_b_isInf(mul_0_io_b_isInf),
    .io_b_isZero(mul_0_io_b_isZero),
    .io_b_sign(mul_0_io_b_sign),
    .io_b_sExp(mul_0_io_b_sExp),
    .io_b_sig(mul_0_io_b_sig),
    .io_invalidExc(mul_0_io_invalidExc),
    .io_rawOut_isNaN(mul_0_io_rawOut_isNaN),
    .io_rawOut_isInf(mul_0_io_rawOut_isInf),
    .io_rawOut_isZero(mul_0_io_rawOut_isZero),
    .io_rawOut_sign(mul_0_io_rawOut_sign),
    .io_rawOut_sExp(mul_0_io_rawOut_sExp),
    .io_rawOut_sig(mul_0_io_rawOut_sig)
  );
  TensorMulFullRawFN mul_1 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
    .io_a_isNaN(mul_1_io_a_isNaN),
    .io_a_isInf(mul_1_io_a_isInf),
    .io_a_isZero(mul_1_io_a_isZero),
    .io_a_sign(mul_1_io_a_sign),
    .io_a_sExp(mul_1_io_a_sExp),
    .io_a_sig(mul_1_io_a_sig),
    .io_b_isNaN(mul_1_io_b_isNaN),
    .io_b_isInf(mul_1_io_b_isInf),
    .io_b_isZero(mul_1_io_b_isZero),
    .io_b_sign(mul_1_io_b_sign),
    .io_b_sExp(mul_1_io_b_sExp),
    .io_b_sig(mul_1_io_b_sig),
    .io_invalidExc(mul_1_io_invalidExc),
    .io_rawOut_isNaN(mul_1_io_rawOut_isNaN),
    .io_rawOut_isInf(mul_1_io_rawOut_isInf),
    .io_rawOut_isZero(mul_1_io_rawOut_isZero),
    .io_rawOut_sign(mul_1_io_rawOut_sign),
    .io_rawOut_sExp(mul_1_io_rawOut_sExp),
    .io_rawOut_sig(mul_1_io_rawOut_sig)
  );
  TensorMulFullRawFN mul_2 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
    .io_a_isNaN(mul_2_io_a_isNaN),
    .io_a_isInf(mul_2_io_a_isInf),
    .io_a_isZero(mul_2_io_a_isZero),
    .io_a_sign(mul_2_io_a_sign),
    .io_a_sExp(mul_2_io_a_sExp),
    .io_a_sig(mul_2_io_a_sig),
    .io_b_isNaN(mul_2_io_b_isNaN),
    .io_b_isInf(mul_2_io_b_isInf),
    .io_b_isZero(mul_2_io_b_isZero),
    .io_b_sign(mul_2_io_b_sign),
    .io_b_sExp(mul_2_io_b_sExp),
    .io_b_sig(mul_2_io_b_sig),
    .io_invalidExc(mul_2_io_invalidExc),
    .io_rawOut_isNaN(mul_2_io_rawOut_isNaN),
    .io_rawOut_isInf(mul_2_io_rawOut_isInf),
    .io_rawOut_isZero(mul_2_io_rawOut_isZero),
    .io_rawOut_sign(mul_2_io_rawOut_sign),
    .io_rawOut_sExp(mul_2_io_rawOut_sExp),
    .io_rawOut_sig(mul_2_io_rawOut_sig)
  );
  TensorMulFullRawFN mul_3 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 125:33]
    .io_a_isNaN(mul_3_io_a_isNaN),
    .io_a_isInf(mul_3_io_a_isInf),
    .io_a_isZero(mul_3_io_a_isZero),
    .io_a_sign(mul_3_io_a_sign),
    .io_a_sExp(mul_3_io_a_sExp),
    .io_a_sig(mul_3_io_a_sig),
    .io_b_isNaN(mul_3_io_b_isNaN),
    .io_b_isInf(mul_3_io_b_isInf),
    .io_b_isZero(mul_3_io_b_isZero),
    .io_b_sign(mul_3_io_b_sign),
    .io_b_sExp(mul_3_io_b_sExp),
    .io_b_sig(mul_3_io_b_sig),
    .io_invalidExc(mul_3_io_invalidExc),
    .io_rawOut_isNaN(mul_3_io_rawOut_isNaN),
    .io_rawOut_isInf(mul_3_io_rawOut_isInf),
    .io_rawOut_isZero(mul_3_io_rawOut_isZero),
    .io_rawOut_sign(mul_3_io_rawOut_sign),
    .io_rawOut_sExp(mul_3_io_rawOut_sExp),
    .io_rawOut_sig(mul_3_io_rawOut_sig)
  );
  TensorRoundAnyRawFNToRecFN_ie5_is21_oe8_os24 mulOuts_roundRawFNToRecFN ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
    .io_invalidExc(mulOuts_roundRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(mulOuts_roundRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(mulOuts_roundRawFNToRecFN_io_in_isInf),
    .io_in_isZero(mulOuts_roundRawFNToRecFN_io_in_isZero),
    .io_in_sign(mulOuts_roundRawFNToRecFN_io_in_sign),
    .io_in_sExp(mulOuts_roundRawFNToRecFN_io_in_sExp),
    .io_in_sig(mulOuts_roundRawFNToRecFN_io_in_sig),
    .io_out(mulOuts_roundRawFNToRecFN_io_out)
  );
  TensorRoundAnyRawFNToRecFN_ie5_is21_oe8_os24 mulOuts_roundRawFNToRecFN_1 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
    .io_invalidExc(mulOuts_roundRawFNToRecFN_1_io_invalidExc),
    .io_in_isNaN(mulOuts_roundRawFNToRecFN_1_io_in_isNaN),
    .io_in_isInf(mulOuts_roundRawFNToRecFN_1_io_in_isInf),
    .io_in_isZero(mulOuts_roundRawFNToRecFN_1_io_in_isZero),
    .io_in_sign(mulOuts_roundRawFNToRecFN_1_io_in_sign),
    .io_in_sExp(mulOuts_roundRawFNToRecFN_1_io_in_sExp),
    .io_in_sig(mulOuts_roundRawFNToRecFN_1_io_in_sig),
    .io_out(mulOuts_roundRawFNToRecFN_1_io_out)
  );
  TensorRoundAnyRawFNToRecFN_ie5_is21_oe8_os24 mulOuts_roundRawFNToRecFN_2 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
    .io_invalidExc(mulOuts_roundRawFNToRecFN_2_io_invalidExc),
    .io_in_isNaN(mulOuts_roundRawFNToRecFN_2_io_in_isNaN),
    .io_in_isInf(mulOuts_roundRawFNToRecFN_2_io_in_isInf),
    .io_in_isZero(mulOuts_roundRawFNToRecFN_2_io_in_isZero),
    .io_in_sign(mulOuts_roundRawFNToRecFN_2_io_in_sign),
    .io_in_sExp(mulOuts_roundRawFNToRecFN_2_io_in_sExp),
    .io_in_sig(mulOuts_roundRawFNToRecFN_2_io_in_sig),
    .io_out(mulOuts_roundRawFNToRecFN_2_io_out)
  );
  TensorRoundAnyRawFNToRecFN_ie5_is21_oe8_os24 mulOuts_roundRawFNToRecFN_3 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 145:15]
    .io_invalidExc(mulOuts_roundRawFNToRecFN_3_io_invalidExc),
    .io_in_isNaN(mulOuts_roundRawFNToRecFN_3_io_in_isNaN),
    .io_in_isInf(mulOuts_roundRawFNToRecFN_3_io_in_isInf),
    .io_in_isZero(mulOuts_roundRawFNToRecFN_3_io_in_isZero),
    .io_in_sign(mulOuts_roundRawFNToRecFN_3_io_in_sign),
    .io_in_sExp(mulOuts_roundRawFNToRecFN_3_io_in_sExp),
    .io_in_sig(mulOuts_roundRawFNToRecFN_3_io_in_sig),
    .io_out(mulOuts_roundRawFNToRecFN_3_io_out)
  );
  StallingPipe mulStageOut_p ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
    .clock(mulStageOut_p_clock),
    .reset(mulStageOut_p_reset),
    .io_stall(mulStageOut_p_io_stall),
    .io_enq_valid(mulStageOut_p_io_enq_valid),
    .io_enq_bits_0(mulStageOut_p_io_enq_bits_0),
    .io_enq_bits_1(mulStageOut_p_io_enq_bits_1),
    .io_enq_bits_2(mulStageOut_p_io_enq_bits_2),
    .io_enq_bits_3(mulStageOut_p_io_enq_bits_3),
    .io_deq_valid(mulStageOut_p_io_deq_valid),
    .io_deq_bits_0(mulStageOut_p_io_deq_bits_0),
    .io_deq_bits_1(mulStageOut_p_io_deq_bits_1),
    .io_deq_bits_2(mulStageOut_p_io_deq_bits_2),
    .io_deq_bits_3(mulStageOut_p_io_deq_bits_3)
  );
  StallingPipe_1 mulStageC_p ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
    .clock(mulStageC_p_clock),
    .reset(mulStageC_p_reset),
    .io_stall(mulStageC_p_io_stall),
    .io_enq_valid(mulStageC_p_io_enq_valid),
    .io_enq_bits(mulStageC_p_io_enq_bits),
    .io_deq_valid(mulStageC_p_io_deq_valid),
    .io_deq_bits(mulStageC_p_io_deq_bits)
  );
  AddRecFN add1_0 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 161:38]
    .io_a(add1_0_io_a),
    .io_b(add1_0_io_b),
    .io_out(add1_0_io_out)
  );
  AddRecFN add1_1 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 161:38]
    .io_a(add1_1_io_a),
    .io_b(add1_1_io_b),
    .io_out(add1_1_io_out)
  );
  StallingPipe_2 add1StageOut_p ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
    .clock(add1StageOut_p_clock),
    .reset(add1StageOut_p_reset),
    .io_stall(add1StageOut_p_io_stall),
    .io_enq_valid(add1StageOut_p_io_enq_valid),
    .io_enq_bits_0(add1StageOut_p_io_enq_bits_0),
    .io_enq_bits_1(add1StageOut_p_io_enq_bits_1),
    .io_deq_valid(add1StageOut_p_io_deq_valid),
    .io_deq_bits_0(add1StageOut_p_io_deq_bits_0),
    .io_deq_bits_1(add1StageOut_p_io_deq_bits_1)
  );
  StallingPipe_1 add1StageC_p ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
    .clock(add1StageC_p_clock),
    .reset(add1StageC_p_reset),
    .io_stall(add1StageC_p_io_stall),
    .io_enq_valid(add1StageC_p_io_enq_valid),
    .io_enq_bits(add1StageC_p_io_enq_bits),
    .io_deq_valid(add1StageC_p_io_deq_valid),
    .io_deq_bits(add1StageC_p_io_deq_bits)
  );
  AddRecFN add2 ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 177:20]
    .io_a(add2_io_a),
    .io_b(add2_io_b),
    .io_out(add2_io_out)
  );
  StallingPipe_1 add2StageOut_p ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
    .clock(add2StageOut_p_clock),
    .reset(add2StageOut_p_reset),
    .io_stall(add2StageOut_p_io_stall),
    .io_enq_valid(add2StageOut_p_io_enq_valid),
    .io_enq_bits(add2StageOut_p_io_enq_bits),
    .io_deq_valid(add2StageOut_p_io_deq_valid),
    .io_deq_bits(add2StageOut_p_io_deq_bits)
  );
  StallingPipe_1 add2StageC_p ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
    .clock(add2StageC_p_clock),
    .reset(add2StageC_p_reset),
    .io_stall(add2StageC_p_io_stall),
    .io_enq_valid(add2StageC_p_io_enq_valid),
    .io_enq_bits(add2StageC_p_io_enq_bits),
    .io_deq_valid(add2StageC_p_io_deq_valid),
    .io_deq_bits(add2StageC_p_io_deq_bits)
  );
  AddRecFN acc ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 190:19]
    .io_a(acc_io_a),
    .io_b(acc_io_b),
    .io_out(acc_io_out)
  );
  StallingPipe_1 accStageOut_p ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 83:19]
    .clock(accStageOut_p_clock),
    .reset(accStageOut_p_reset),
    .io_stall(accStageOut_p_io_stall),
    .io_enq_valid(accStageOut_p_io_enq_valid),
    .io_enq_bits(accStageOut_p_io_enq_bits),
    .io_deq_valid(accStageOut_p_io_deq_valid),
    .io_deq_bits(accStageOut_p_io_deq_bits)
  );
  assign io_out_valid = accStageOut_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 203:16]
  assign io_out_bits_data = accStageOut_p_io_deq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 204:20]
  assign mul_0_io_a_isNaN = io_in_valid & mulOuts_rawInA__isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_0_io_a_isInf = io_in_valid & mulOuts_rawInA__isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_0_io_a_isZero = io_in_valid ? mulOuts_rawInA_isZero : 1'h1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_0_io_a_sign = io_in_valid & mulOuts_rawInA__sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_0_io_a_sExp = io_in_valid ? $signed(mulOuts_rawInA__sExp) : $signed(rawZero__sExp); // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_0_io_a_sig = io_in_valid ? mulOuts_rawInA__sig : 12'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_0_io_b_isNaN = io_in_valid & mulOuts_rawInB__isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_0_io_b_isInf = io_in_valid & mulOuts_rawInB__isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_0_io_b_isZero = io_in_valid ? mulOuts_rawInB_isZero : 1'h1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_0_io_b_sign = io_in_valid & mulOuts_rawInB__sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_0_io_b_sExp = io_in_valid ? $signed(mulOuts_rawInB__sExp) : $signed(rawZero__sExp); // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_0_io_b_sig = io_in_valid ? mulOuts_rawInB__sig : 12'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_1_io_a_isNaN = io_in_valid & mulOuts_rawInA_1_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_1_io_a_isInf = io_in_valid & mulOuts_rawInA_1_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_1_io_a_isZero = io_in_valid ? mulOuts_rawInA_isZero_1 : 1'h1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_1_io_a_sign = io_in_valid & mulOuts_rawInA_1_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_1_io_a_sExp = io_in_valid ? $signed(mulOuts_rawInA_1_sExp) : $signed(rawZero__sExp); // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_1_io_a_sig = io_in_valid ? mulOuts_rawInA_1_sig : 12'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_1_io_b_isNaN = io_in_valid & mulOuts_rawInB_1_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_1_io_b_isInf = io_in_valid & mulOuts_rawInB_1_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_1_io_b_isZero = io_in_valid ? mulOuts_rawInB_isZero_1 : 1'h1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_1_io_b_sign = io_in_valid & mulOuts_rawInB_1_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_1_io_b_sExp = io_in_valid ? $signed(mulOuts_rawInB_1_sExp) : $signed(rawZero__sExp); // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_1_io_b_sig = io_in_valid ? mulOuts_rawInB_1_sig : 12'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_2_io_a_isNaN = io_in_valid & mulOuts_rawInA_2_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_2_io_a_isInf = io_in_valid & mulOuts_rawInA_2_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_2_io_a_isZero = io_in_valid ? mulOuts_rawInA_isZero_2 : 1'h1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_2_io_a_sign = io_in_valid & mulOuts_rawInA_2_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_2_io_a_sExp = io_in_valid ? $signed(mulOuts_rawInA_2_sExp) : $signed(rawZero__sExp); // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_2_io_a_sig = io_in_valid ? mulOuts_rawInA_2_sig : 12'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_2_io_b_isNaN = io_in_valid & mulOuts_rawInB_2_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_2_io_b_isInf = io_in_valid & mulOuts_rawInB_2_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_2_io_b_isZero = io_in_valid ? mulOuts_rawInB_isZero_2 : 1'h1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_2_io_b_sign = io_in_valid & mulOuts_rawInB_2_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_2_io_b_sExp = io_in_valid ? $signed(mulOuts_rawInB_2_sExp) : $signed(rawZero__sExp); // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_2_io_b_sig = io_in_valid ? mulOuts_rawInB_2_sig : 12'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_3_io_a_isNaN = io_in_valid & mulOuts_rawInA_3_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_3_io_a_isInf = io_in_valid & mulOuts_rawInA_3_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_3_io_a_isZero = io_in_valid ? mulOuts_rawInA_isZero_3 : 1'h1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_3_io_a_sign = io_in_valid & mulOuts_rawInA_3_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_3_io_a_sExp = io_in_valid ? $signed(mulOuts_rawInA_3_sExp) : $signed(rawZero__sExp); // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_3_io_a_sig = io_in_valid ? mulOuts_rawInA_3_sig : 12'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 135:24]
  assign mul_3_io_b_isNaN = io_in_valid & mulOuts_rawInB_3_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_3_io_b_isInf = io_in_valid & mulOuts_rawInB_3_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_3_io_b_isZero = io_in_valid ? mulOuts_rawInB_isZero_3 : 1'h1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_3_io_b_sign = io_in_valid & mulOuts_rawInB_3_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_3_io_b_sExp = io_in_valid ? $signed(mulOuts_rawInB_3_sExp) : $signed(rawZero__sExp); // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mul_3_io_b_sig = io_in_valid ? mulOuts_rawInB_3_sig : 12'h0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 136:24]
  assign mulOuts_roundRawFNToRecFN_io_invalidExc = mul_0_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 147:39]
  assign mulOuts_roundRawFNToRecFN_io_in_isNaN = mul_0_io_rawOut_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_io_in_isInf = mul_0_io_rawOut_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_io_in_isZero = mul_0_io_rawOut_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_io_in_sign = mul_0_io_rawOut_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_io_in_sExp = mul_0_io_rawOut_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_io_in_sig = mul_0_io_rawOut_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_1_io_invalidExc = mul_1_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 147:39]
  assign mulOuts_roundRawFNToRecFN_1_io_in_isNaN = mul_1_io_rawOut_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_1_io_in_isInf = mul_1_io_rawOut_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_1_io_in_isZero = mul_1_io_rawOut_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_1_io_in_sign = mul_1_io_rawOut_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_1_io_in_sExp = mul_1_io_rawOut_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_1_io_in_sig = mul_1_io_rawOut_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_2_io_invalidExc = mul_2_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 147:39]
  assign mulOuts_roundRawFNToRecFN_2_io_in_isNaN = mul_2_io_rawOut_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_2_io_in_isInf = mul_2_io_rawOut_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_2_io_in_isZero = mul_2_io_rawOut_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_2_io_in_sign = mul_2_io_rawOut_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_2_io_in_sExp = mul_2_io_rawOut_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_2_io_in_sig = mul_2_io_rawOut_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_3_io_invalidExc = mul_3_io_invalidExc; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 147:39]
  assign mulOuts_roundRawFNToRecFN_3_io_in_isNaN = mul_3_io_rawOut_isNaN; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_3_io_in_isInf = mul_3_io_rawOut_isInf; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_3_io_in_isZero = mul_3_io_rawOut_isZero; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_3_io_in_sign = mul_3_io_rawOut_sign; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_3_io_in_sExp = mul_3_io_rawOut_sExp; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulOuts_roundRawFNToRecFN_3_io_in_sig = mul_3_io_rawOut_sig; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 149:39]
  assign mulStageOut_p_clock = clock;
  assign mulStageOut_p_reset = reset;
  assign mulStageOut_p_io_stall = io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 84:16]
  assign mulStageOut_p_io_enq_valid = io_in_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 85:20]
  assign mulStageOut_p_io_enq_bits_0 = mulOuts_roundRawFNToRecFN_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 156:{64,64}]
  assign mulStageOut_p_io_enq_bits_1 = mulOuts_roundRawFNToRecFN_1_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 156:{64,64}]
  assign mulStageOut_p_io_enq_bits_2 = mulOuts_roundRawFNToRecFN_2_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 156:{64,64}]
  assign mulStageOut_p_io_enq_bits_3 = mulOuts_roundRawFNToRecFN_3_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 156:{64,64}]
  assign mulStageC_p_clock = clock;
  assign mulStageC_p_reset = reset;
  assign mulStageC_p_io_stall = io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 84:16]
  assign mulStageC_p_io_enq_valid = io_in_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 85:20]
  assign mulStageC_p_io_enq_bits = io_in_bits_c; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 86:19]
  assign add1_0_io_a = mulStageOut_p_io_deq_bits_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 164:12]
  assign add1_0_io_b = mulStageOut_p_io_deq_bits_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 165:12]
  assign add1_1_io_a = mulStageOut_p_io_deq_bits_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 164:12]
  assign add1_1_io_b = mulStageOut_p_io_deq_bits_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 165:12]
  assign add1StageOut_p_clock = clock;
  assign add1StageOut_p_reset = reset;
  assign add1StageOut_p_io_stall = io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 84:16]
  assign add1StageOut_p_io_enq_valid = mulStageOut_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 85:20]
  assign add1StageOut_p_io_enq_bits_0 = add1_0_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 172:{71,71}]
  assign add1StageOut_p_io_enq_bits_1 = add1_1_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 172:{71,71}]
  assign add1StageC_p_clock = clock;
  assign add1StageC_p_reset = reset;
  assign add1StageC_p_io_stall = io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 84:16]
  assign add1StageC_p_io_enq_valid = mulStageOut_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 85:20]
  assign add1StageC_p_io_enq_bits = mulStageC_p_io_deq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 86:19]
  assign add2_io_a = add1StageOut_p_io_deq_bits_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 179:13]
  assign add2_io_b = add1StageOut_p_io_deq_bits_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 180:13]
  assign add2StageOut_p_clock = clock;
  assign add2StageOut_p_reset = reset;
  assign add2StageOut_p_io_stall = io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 84:16]
  assign add2StageOut_p_io_enq_valid = add1StageOut_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 85:20]
  assign add2StageOut_p_io_enq_bits = add2_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 86:19]
  assign add2StageC_p_clock = clock;
  assign add2StageC_p_reset = reset;
  assign add2StageC_p_io_stall = io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 84:16]
  assign add2StageC_p_io_enq_valid = add1StageOut_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 85:20]
  assign add2StageC_p_io_enq_bits = add1StageC_p_io_deq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 86:19]
  assign acc_io_a = add2StageOut_p_io_deq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 192:12]
  assign acc_io_b = add2StageC_p_io_deq_bits; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 194:12]
  assign accStageOut_p_clock = clock;
  assign accStageOut_p_reset = reset;
  assign accStageOut_p_io_stall = io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 84:16]
  assign accStageOut_p_io_enq_valid = add2StageOut_p_io_deq_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 85:20]
  assign accStageOut_p_io_enq_bits = acc_io_out; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 86:19]
endmodule
module TensorDotProductUnit( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 12:7]
  input         clock, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 12:7]
  input         reset, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 12:7]
  input         io_in_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  input  [15:0] io_in_bits_a_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  input  [15:0] io_in_bits_a_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  input  [15:0] io_in_bits_a_2, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  input  [15:0] io_in_bits_a_3, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  input  [15:0] io_in_bits_b_0, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  input  [15:0] io_in_bits_b_1, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  input  [15:0] io_in_bits_b_2, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  input  [15:0] io_in_bits_b_3, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  input  [31:0] io_in_bits_c, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  input         io_stall, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  output        io_out_valid, // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
  output [31:0] io_out_bits_data // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 24:14]
);
  wire  dpu_clock; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire  dpu_reset; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire  dpu_io_in_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [16:0] dpu_io_in_bits_a_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [16:0] dpu_io_in_bits_a_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [16:0] dpu_io_in_bits_a_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [16:0] dpu_io_in_bits_a_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [16:0] dpu_io_in_bits_b_0; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [16:0] dpu_io_in_bits_b_1; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [16:0] dpu_io_in_bits_b_2; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [16:0] dpu_io_in_bits_b_3; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [32:0] dpu_io_in_bits_c; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire  dpu_io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire  dpu_io_out_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [32:0] dpu_io_out_bits_data; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
  wire [31:0] _GEN_0 = {{16'd0}, io_in_bits_a_0}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire [31:0] _in1_T_2 = 32'hffff0000 | _GEN_0; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire  in1_rawIn_sign = _in1_T_2[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in1_rawIn_expIn = _in1_T_2[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in1_rawIn_fractIn = _in1_T_2[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
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
  wire [53:0] _GEN_80 = {{31'd0}, in1_rawIn_fractIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in1_rawIn_subnormFract_T = _GEN_80 << in1_rawIn_normDist; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in1_rawIn_subnormFract = {_in1_rawIn_subnormFract_T[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_1 = {{4'd0}, in1_rawIn_normDist}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T = _GEN_1 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_1 = in1_rawIn_isZeroExpIn ? _in1_rawIn_adjustedExp_T : {{1'd0}, in1_rawIn_expIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_2 = in1_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_2 = {{6'd0}, _in1_rawIn_adjustedExp_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in1_rawIn_adjustedExp_T_3 = 8'h80 | _GEN_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_3 = {{1'd0}, _in1_rawIn_adjustedExp_T_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in1_rawIn_adjustedExp = _in1_rawIn_adjustedExp_T_1 + _GEN_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero = in1_rawIn_isZeroExpIn & in1_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial = in1_rawIn_adjustedExp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn__isNaN = in1_rawIn_isSpecial & ~in1_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in1_rawIn__sExp = {1'b0,$signed(in1_rawIn_adjustedExp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T = ~in1_rawIn_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in1_rawIn_out_sig_T_2 = in1_rawIn_isZeroExpIn ? in1_rawIn_subnormFract : in1_rawIn_fractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in1_rawIn__sig = {1'h0,_in1_rawIn_out_sig_T,_in1_rawIn_out_sig_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_4 = in1_rawIn_isZero ? 3'h0 : in1_rawIn__sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_4 = {{2'd0}, in1_rawIn__isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_6 = _in1_T_4 | _GEN_4; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [32:0] _in1_T_11 = {in1_rawIn_sign,_in1_T_6,in1_rawIn__sExp[5:0],in1_rawIn__sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  in1_rawIn_sign_1 = _in1_T_2[15]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [4:0] in1_rawIn_expIn_1 = _in1_T_2[14:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [9:0] in1_rawIn_fractIn_1 = _in1_T_2[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn_1 = in1_rawIn_expIn_1 == 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn_1 = in1_rawIn_fractIn_1 == 10'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [3:0] _in1_rawIn_normDist_T_54 = in1_rawIn_fractIn_1[1] ? 4'h8 : 4'h9; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_55 = in1_rawIn_fractIn_1[2] ? 4'h7 : _in1_rawIn_normDist_T_54; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_56 = in1_rawIn_fractIn_1[3] ? 4'h6 : _in1_rawIn_normDist_T_55; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_57 = in1_rawIn_fractIn_1[4] ? 4'h5 : _in1_rawIn_normDist_T_56; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_58 = in1_rawIn_fractIn_1[5] ? 4'h4 : _in1_rawIn_normDist_T_57; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_59 = in1_rawIn_fractIn_1[6] ? 4'h3 : _in1_rawIn_normDist_T_58; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_60 = in1_rawIn_fractIn_1[7] ? 4'h2 : _in1_rawIn_normDist_T_59; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_61 = in1_rawIn_fractIn_1[8] ? 4'h1 : _in1_rawIn_normDist_T_60; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] in1_rawIn_normDist_1 = in1_rawIn_fractIn_1[9] ? 4'h0 : _in1_rawIn_normDist_T_61; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [24:0] _GEN_81 = {{15'd0}, in1_rawIn_fractIn_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [24:0] _in1_rawIn_subnormFract_T_2 = _GEN_81 << in1_rawIn_normDist_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [9:0] in1_rawIn_subnormFract_1 = {_in1_rawIn_subnormFract_T_2[8:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_5 = {{2'd0}, in1_rawIn_normDist_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in1_rawIn_adjustedExp_T_5 = _GEN_5 ^ 6'h3f; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in1_rawIn_adjustedExp_T_6 = in1_rawIn_isZeroExpIn_1 ? _in1_rawIn_adjustedExp_T_5 : {{1'd0},
    in1_rawIn_expIn_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_7 = in1_rawIn_isZeroExpIn_1 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_6 = {{3'd0}, _in1_rawIn_adjustedExp_T_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [4:0] _in1_rawIn_adjustedExp_T_8 = 5'h10 | _GEN_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_7 = {{1'd0}, _in1_rawIn_adjustedExp_T_8}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [5:0] in1_rawIn_adjustedExp_1 = _in1_rawIn_adjustedExp_T_6 + _GEN_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero_1 = in1_rawIn_isZeroExpIn_1 & in1_rawIn_isZeroFractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial_1 = in1_rawIn_adjustedExp_1[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn_1_isNaN = in1_rawIn_isSpecial_1 & ~in1_rawIn_isZeroFractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [6:0] in1_rawIn_1_sExp = {1'b0,$signed(in1_rawIn_adjustedExp_1)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T_4 = ~in1_rawIn_isZero_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [9:0] _in1_rawIn_out_sig_T_6 = in1_rawIn_isZeroExpIn_1 ? in1_rawIn_subnormFract_1 : in1_rawIn_fractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [11:0] in1_rawIn_1_sig = {1'h0,_in1_rawIn_out_sig_T_4,_in1_rawIn_out_sig_T_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_13 = in1_rawIn_isZero_1 ? 3'h0 : in1_rawIn_1_sExp[5:3]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_8 = {{2'd0}, in1_rawIn_1_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_15 = _in1_T_13 | _GEN_8; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [16:0] _in1_T_20 = {in1_rawIn_sign_1,_in1_T_15,in1_rawIn_1_sExp[2:0],in1_rawIn_1_sig[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  _in1_swizzledNaN_T_2 = &_in1_T_11[22:16]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 338:42]
  wire [32:0] in1_swizzledNaN = {_in1_T_11[32:29],_in1_swizzledNaN_T_2,_in1_T_11[27:24],_in1_T_20[15],_in1_T_11[22:16],
    _in1_T_20[16],_in1_T_20[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 336:26]
  wire  _in1_T_22 = &_in1_T_11[31:29]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 249:56]
  wire [32:0] _in1_T_23 = _in1_T_22 ? in1_swizzledNaN : _in1_T_11; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 344:8]
  wire [16:0] in1_floats_0 = {_in1_T_23[15],_in1_T_23[23],_in1_T_23[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 356:31]
  wire  in1_prev_isbox = &_in1_T_23[32:28]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 332:84]
  wire [16:0] _in1_T_24 = in1_prev_isbox ? 17'h0 : 17'he200; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:31]
  wire [31:0] _GEN_9 = {{16'd0}, io_in_bits_a_1}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire [31:0] _in1_T_27 = 32'hffff0000 | _GEN_9; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire  in1_rawIn_sign_2 = _in1_T_27[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in1_rawIn_expIn_2 = _in1_T_27[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in1_rawIn_fractIn_2 = _in1_T_27[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn_2 = in1_rawIn_expIn_2 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn_2 = in1_rawIn_fractIn_2 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in1_rawIn_normDist_T_85 = in1_rawIn_fractIn_2[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_86 = in1_rawIn_fractIn_2[2] ? 5'h14 : _in1_rawIn_normDist_T_85; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_87 = in1_rawIn_fractIn_2[3] ? 5'h13 : _in1_rawIn_normDist_T_86; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_88 = in1_rawIn_fractIn_2[4] ? 5'h12 : _in1_rawIn_normDist_T_87; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_89 = in1_rawIn_fractIn_2[5] ? 5'h11 : _in1_rawIn_normDist_T_88; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_90 = in1_rawIn_fractIn_2[6] ? 5'h10 : _in1_rawIn_normDist_T_89; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_91 = in1_rawIn_fractIn_2[7] ? 5'hf : _in1_rawIn_normDist_T_90; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_92 = in1_rawIn_fractIn_2[8] ? 5'he : _in1_rawIn_normDist_T_91; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_93 = in1_rawIn_fractIn_2[9] ? 5'hd : _in1_rawIn_normDist_T_92; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_94 = in1_rawIn_fractIn_2[10] ? 5'hc : _in1_rawIn_normDist_T_93; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_95 = in1_rawIn_fractIn_2[11] ? 5'hb : _in1_rawIn_normDist_T_94; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_96 = in1_rawIn_fractIn_2[12] ? 5'ha : _in1_rawIn_normDist_T_95; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_97 = in1_rawIn_fractIn_2[13] ? 5'h9 : _in1_rawIn_normDist_T_96; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_98 = in1_rawIn_fractIn_2[14] ? 5'h8 : _in1_rawIn_normDist_T_97; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_99 = in1_rawIn_fractIn_2[15] ? 5'h7 : _in1_rawIn_normDist_T_98; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_100 = in1_rawIn_fractIn_2[16] ? 5'h6 : _in1_rawIn_normDist_T_99; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_101 = in1_rawIn_fractIn_2[17] ? 5'h5 : _in1_rawIn_normDist_T_100; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_102 = in1_rawIn_fractIn_2[18] ? 5'h4 : _in1_rawIn_normDist_T_101; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_103 = in1_rawIn_fractIn_2[19] ? 5'h3 : _in1_rawIn_normDist_T_102; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_104 = in1_rawIn_fractIn_2[20] ? 5'h2 : _in1_rawIn_normDist_T_103; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_105 = in1_rawIn_fractIn_2[21] ? 5'h1 : _in1_rawIn_normDist_T_104; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in1_rawIn_normDist_2 = in1_rawIn_fractIn_2[22] ? 5'h0 : _in1_rawIn_normDist_T_105; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_82 = {{31'd0}, in1_rawIn_fractIn_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in1_rawIn_subnormFract_T_4 = _GEN_82 << in1_rawIn_normDist_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in1_rawIn_subnormFract_2 = {_in1_rawIn_subnormFract_T_4[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_10 = {{4'd0}, in1_rawIn_normDist_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_10 = _GEN_10 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_11 = in1_rawIn_isZeroExpIn_2 ? _in1_rawIn_adjustedExp_T_10 : {{1'd0},
    in1_rawIn_expIn_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_12 = in1_rawIn_isZeroExpIn_2 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_11 = {{6'd0}, _in1_rawIn_adjustedExp_T_12}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in1_rawIn_adjustedExp_T_13 = 8'h80 | _GEN_11; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_12 = {{1'd0}, _in1_rawIn_adjustedExp_T_13}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in1_rawIn_adjustedExp_2 = _in1_rawIn_adjustedExp_T_11 + _GEN_12; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero_2 = in1_rawIn_isZeroExpIn_2 & in1_rawIn_isZeroFractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial_2 = in1_rawIn_adjustedExp_2[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn_2_isNaN = in1_rawIn_isSpecial_2 & ~in1_rawIn_isZeroFractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in1_rawIn_2_sExp = {1'b0,$signed(in1_rawIn_adjustedExp_2)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T_8 = ~in1_rawIn_isZero_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in1_rawIn_out_sig_T_10 = in1_rawIn_isZeroExpIn_2 ? in1_rawIn_subnormFract_2 : in1_rawIn_fractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in1_rawIn_2_sig = {1'h0,_in1_rawIn_out_sig_T_8,_in1_rawIn_out_sig_T_10}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_29 = in1_rawIn_isZero_2 ? 3'h0 : in1_rawIn_2_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_13 = {{2'd0}, in1_rawIn_2_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_31 = _in1_T_29 | _GEN_13; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [32:0] _in1_T_36 = {in1_rawIn_sign_2,_in1_T_31,in1_rawIn_2_sExp[5:0],in1_rawIn_2_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  in1_rawIn_sign_3 = _in1_T_27[15]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [4:0] in1_rawIn_expIn_3 = _in1_T_27[14:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [9:0] in1_rawIn_fractIn_3 = _in1_T_27[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn_3 = in1_rawIn_expIn_3 == 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn_3 = in1_rawIn_fractIn_3 == 10'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [3:0] _in1_rawIn_normDist_T_116 = in1_rawIn_fractIn_3[1] ? 4'h8 : 4'h9; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_117 = in1_rawIn_fractIn_3[2] ? 4'h7 : _in1_rawIn_normDist_T_116; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_118 = in1_rawIn_fractIn_3[3] ? 4'h6 : _in1_rawIn_normDist_T_117; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_119 = in1_rawIn_fractIn_3[4] ? 4'h5 : _in1_rawIn_normDist_T_118; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_120 = in1_rawIn_fractIn_3[5] ? 4'h4 : _in1_rawIn_normDist_T_119; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_121 = in1_rawIn_fractIn_3[6] ? 4'h3 : _in1_rawIn_normDist_T_120; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_122 = in1_rawIn_fractIn_3[7] ? 4'h2 : _in1_rawIn_normDist_T_121; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_123 = in1_rawIn_fractIn_3[8] ? 4'h1 : _in1_rawIn_normDist_T_122; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] in1_rawIn_normDist_3 = in1_rawIn_fractIn_3[9] ? 4'h0 : _in1_rawIn_normDist_T_123; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [24:0] _GEN_83 = {{15'd0}, in1_rawIn_fractIn_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [24:0] _in1_rawIn_subnormFract_T_6 = _GEN_83 << in1_rawIn_normDist_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [9:0] in1_rawIn_subnormFract_3 = {_in1_rawIn_subnormFract_T_6[8:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_14 = {{2'd0}, in1_rawIn_normDist_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in1_rawIn_adjustedExp_T_15 = _GEN_14 ^ 6'h3f; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in1_rawIn_adjustedExp_T_16 = in1_rawIn_isZeroExpIn_3 ? _in1_rawIn_adjustedExp_T_15 : {{1'd0},
    in1_rawIn_expIn_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_17 = in1_rawIn_isZeroExpIn_3 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_15 = {{3'd0}, _in1_rawIn_adjustedExp_T_17}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [4:0] _in1_rawIn_adjustedExp_T_18 = 5'h10 | _GEN_15; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_16 = {{1'd0}, _in1_rawIn_adjustedExp_T_18}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [5:0] in1_rawIn_adjustedExp_3 = _in1_rawIn_adjustedExp_T_16 + _GEN_16; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero_3 = in1_rawIn_isZeroExpIn_3 & in1_rawIn_isZeroFractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial_3 = in1_rawIn_adjustedExp_3[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn_3_isNaN = in1_rawIn_isSpecial_3 & ~in1_rawIn_isZeroFractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [6:0] in1_rawIn_3_sExp = {1'b0,$signed(in1_rawIn_adjustedExp_3)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T_12 = ~in1_rawIn_isZero_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [9:0] _in1_rawIn_out_sig_T_14 = in1_rawIn_isZeroExpIn_3 ? in1_rawIn_subnormFract_3 : in1_rawIn_fractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [11:0] in1_rawIn_3_sig = {1'h0,_in1_rawIn_out_sig_T_12,_in1_rawIn_out_sig_T_14}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_38 = in1_rawIn_isZero_3 ? 3'h0 : in1_rawIn_3_sExp[5:3]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_17 = {{2'd0}, in1_rawIn_3_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_40 = _in1_T_38 | _GEN_17; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [16:0] _in1_T_45 = {in1_rawIn_sign_3,_in1_T_40,in1_rawIn_3_sExp[2:0],in1_rawIn_3_sig[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  _in1_swizzledNaN_T_10 = &_in1_T_36[22:16]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 338:42]
  wire [32:0] in1_swizzledNaN_1 = {_in1_T_36[32:29],_in1_swizzledNaN_T_10,_in1_T_36[27:24],_in1_T_45[15],_in1_T_36[22:16
    ],_in1_T_45[16],_in1_T_45[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 336:26]
  wire  _in1_T_47 = &_in1_T_36[31:29]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 249:56]
  wire [32:0] _in1_T_48 = _in1_T_47 ? in1_swizzledNaN_1 : _in1_T_36; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 344:8]
  wire [16:0] in1_floats_0_1 = {_in1_T_48[15],_in1_T_48[23],_in1_T_48[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 356:31]
  wire  in1_prev_isbox_1 = &_in1_T_48[32:28]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 332:84]
  wire [16:0] _in1_T_49 = in1_prev_isbox_1 ? 17'h0 : 17'he200; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:31]
  wire [31:0] _GEN_18 = {{16'd0}, io_in_bits_a_2}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire [31:0] _in1_T_52 = 32'hffff0000 | _GEN_18; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire  in1_rawIn_sign_4 = _in1_T_52[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in1_rawIn_expIn_4 = _in1_T_52[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in1_rawIn_fractIn_4 = _in1_T_52[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn_4 = in1_rawIn_expIn_4 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn_4 = in1_rawIn_fractIn_4 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in1_rawIn_normDist_T_147 = in1_rawIn_fractIn_4[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_148 = in1_rawIn_fractIn_4[2] ? 5'h14 : _in1_rawIn_normDist_T_147; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_149 = in1_rawIn_fractIn_4[3] ? 5'h13 : _in1_rawIn_normDist_T_148; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_150 = in1_rawIn_fractIn_4[4] ? 5'h12 : _in1_rawIn_normDist_T_149; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_151 = in1_rawIn_fractIn_4[5] ? 5'h11 : _in1_rawIn_normDist_T_150; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_152 = in1_rawIn_fractIn_4[6] ? 5'h10 : _in1_rawIn_normDist_T_151; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_153 = in1_rawIn_fractIn_4[7] ? 5'hf : _in1_rawIn_normDist_T_152; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_154 = in1_rawIn_fractIn_4[8] ? 5'he : _in1_rawIn_normDist_T_153; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_155 = in1_rawIn_fractIn_4[9] ? 5'hd : _in1_rawIn_normDist_T_154; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_156 = in1_rawIn_fractIn_4[10] ? 5'hc : _in1_rawIn_normDist_T_155; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_157 = in1_rawIn_fractIn_4[11] ? 5'hb : _in1_rawIn_normDist_T_156; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_158 = in1_rawIn_fractIn_4[12] ? 5'ha : _in1_rawIn_normDist_T_157; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_159 = in1_rawIn_fractIn_4[13] ? 5'h9 : _in1_rawIn_normDist_T_158; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_160 = in1_rawIn_fractIn_4[14] ? 5'h8 : _in1_rawIn_normDist_T_159; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_161 = in1_rawIn_fractIn_4[15] ? 5'h7 : _in1_rawIn_normDist_T_160; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_162 = in1_rawIn_fractIn_4[16] ? 5'h6 : _in1_rawIn_normDist_T_161; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_163 = in1_rawIn_fractIn_4[17] ? 5'h5 : _in1_rawIn_normDist_T_162; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_164 = in1_rawIn_fractIn_4[18] ? 5'h4 : _in1_rawIn_normDist_T_163; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_165 = in1_rawIn_fractIn_4[19] ? 5'h3 : _in1_rawIn_normDist_T_164; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_166 = in1_rawIn_fractIn_4[20] ? 5'h2 : _in1_rawIn_normDist_T_165; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_167 = in1_rawIn_fractIn_4[21] ? 5'h1 : _in1_rawIn_normDist_T_166; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in1_rawIn_normDist_4 = in1_rawIn_fractIn_4[22] ? 5'h0 : _in1_rawIn_normDist_T_167; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_84 = {{31'd0}, in1_rawIn_fractIn_4}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in1_rawIn_subnormFract_T_8 = _GEN_84 << in1_rawIn_normDist_4; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in1_rawIn_subnormFract_4 = {_in1_rawIn_subnormFract_T_8[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_19 = {{4'd0}, in1_rawIn_normDist_4}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_20 = _GEN_19 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_21 = in1_rawIn_isZeroExpIn_4 ? _in1_rawIn_adjustedExp_T_20 : {{1'd0},
    in1_rawIn_expIn_4}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_22 = in1_rawIn_isZeroExpIn_4 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_20 = {{6'd0}, _in1_rawIn_adjustedExp_T_22}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in1_rawIn_adjustedExp_T_23 = 8'h80 | _GEN_20; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_21 = {{1'd0}, _in1_rawIn_adjustedExp_T_23}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in1_rawIn_adjustedExp_4 = _in1_rawIn_adjustedExp_T_21 + _GEN_21; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero_4 = in1_rawIn_isZeroExpIn_4 & in1_rawIn_isZeroFractIn_4; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial_4 = in1_rawIn_adjustedExp_4[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn_4_isNaN = in1_rawIn_isSpecial_4 & ~in1_rawIn_isZeroFractIn_4; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in1_rawIn_4_sExp = {1'b0,$signed(in1_rawIn_adjustedExp_4)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T_16 = ~in1_rawIn_isZero_4; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in1_rawIn_out_sig_T_18 = in1_rawIn_isZeroExpIn_4 ? in1_rawIn_subnormFract_4 : in1_rawIn_fractIn_4; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in1_rawIn_4_sig = {1'h0,_in1_rawIn_out_sig_T_16,_in1_rawIn_out_sig_T_18}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_54 = in1_rawIn_isZero_4 ? 3'h0 : in1_rawIn_4_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_22 = {{2'd0}, in1_rawIn_4_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_56 = _in1_T_54 | _GEN_22; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [32:0] _in1_T_61 = {in1_rawIn_sign_4,_in1_T_56,in1_rawIn_4_sExp[5:0],in1_rawIn_4_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  in1_rawIn_sign_5 = _in1_T_52[15]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [4:0] in1_rawIn_expIn_5 = _in1_T_52[14:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [9:0] in1_rawIn_fractIn_5 = _in1_T_52[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn_5 = in1_rawIn_expIn_5 == 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn_5 = in1_rawIn_fractIn_5 == 10'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [3:0] _in1_rawIn_normDist_T_178 = in1_rawIn_fractIn_5[1] ? 4'h8 : 4'h9; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_179 = in1_rawIn_fractIn_5[2] ? 4'h7 : _in1_rawIn_normDist_T_178; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_180 = in1_rawIn_fractIn_5[3] ? 4'h6 : _in1_rawIn_normDist_T_179; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_181 = in1_rawIn_fractIn_5[4] ? 4'h5 : _in1_rawIn_normDist_T_180; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_182 = in1_rawIn_fractIn_5[5] ? 4'h4 : _in1_rawIn_normDist_T_181; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_183 = in1_rawIn_fractIn_5[6] ? 4'h3 : _in1_rawIn_normDist_T_182; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_184 = in1_rawIn_fractIn_5[7] ? 4'h2 : _in1_rawIn_normDist_T_183; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_185 = in1_rawIn_fractIn_5[8] ? 4'h1 : _in1_rawIn_normDist_T_184; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] in1_rawIn_normDist_5 = in1_rawIn_fractIn_5[9] ? 4'h0 : _in1_rawIn_normDist_T_185; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [24:0] _GEN_85 = {{15'd0}, in1_rawIn_fractIn_5}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [24:0] _in1_rawIn_subnormFract_T_10 = _GEN_85 << in1_rawIn_normDist_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [9:0] in1_rawIn_subnormFract_5 = {_in1_rawIn_subnormFract_T_10[8:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_23 = {{2'd0}, in1_rawIn_normDist_5}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in1_rawIn_adjustedExp_T_25 = _GEN_23 ^ 6'h3f; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in1_rawIn_adjustedExp_T_26 = in1_rawIn_isZeroExpIn_5 ? _in1_rawIn_adjustedExp_T_25 : {{1'd0},
    in1_rawIn_expIn_5}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_27 = in1_rawIn_isZeroExpIn_5 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_24 = {{3'd0}, _in1_rawIn_adjustedExp_T_27}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [4:0] _in1_rawIn_adjustedExp_T_28 = 5'h10 | _GEN_24; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_25 = {{1'd0}, _in1_rawIn_adjustedExp_T_28}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [5:0] in1_rawIn_adjustedExp_5 = _in1_rawIn_adjustedExp_T_26 + _GEN_25; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero_5 = in1_rawIn_isZeroExpIn_5 & in1_rawIn_isZeroFractIn_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial_5 = in1_rawIn_adjustedExp_5[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn_5_isNaN = in1_rawIn_isSpecial_5 & ~in1_rawIn_isZeroFractIn_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [6:0] in1_rawIn_5_sExp = {1'b0,$signed(in1_rawIn_adjustedExp_5)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T_20 = ~in1_rawIn_isZero_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [9:0] _in1_rawIn_out_sig_T_22 = in1_rawIn_isZeroExpIn_5 ? in1_rawIn_subnormFract_5 : in1_rawIn_fractIn_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [11:0] in1_rawIn_5_sig = {1'h0,_in1_rawIn_out_sig_T_20,_in1_rawIn_out_sig_T_22}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_63 = in1_rawIn_isZero_5 ? 3'h0 : in1_rawIn_5_sExp[5:3]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_26 = {{2'd0}, in1_rawIn_5_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_65 = _in1_T_63 | _GEN_26; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [16:0] _in1_T_70 = {in1_rawIn_sign_5,_in1_T_65,in1_rawIn_5_sExp[2:0],in1_rawIn_5_sig[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  _in1_swizzledNaN_T_18 = &_in1_T_61[22:16]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 338:42]
  wire [32:0] in1_swizzledNaN_2 = {_in1_T_61[32:29],_in1_swizzledNaN_T_18,_in1_T_61[27:24],_in1_T_70[15],_in1_T_61[22:16
    ],_in1_T_70[16],_in1_T_70[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 336:26]
  wire  _in1_T_72 = &_in1_T_61[31:29]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 249:56]
  wire [32:0] _in1_T_73 = _in1_T_72 ? in1_swizzledNaN_2 : _in1_T_61; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 344:8]
  wire [16:0] in1_floats_0_2 = {_in1_T_73[15],_in1_T_73[23],_in1_T_73[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 356:31]
  wire  in1_prev_isbox_2 = &_in1_T_73[32:28]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 332:84]
  wire [16:0] _in1_T_74 = in1_prev_isbox_2 ? 17'h0 : 17'he200; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:31]
  wire [31:0] _GEN_27 = {{16'd0}, io_in_bits_a_3}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire [31:0] _in1_T_77 = 32'hffff0000 | _GEN_27; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire  in1_rawIn_sign_6 = _in1_T_77[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in1_rawIn_expIn_6 = _in1_T_77[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in1_rawIn_fractIn_6 = _in1_T_77[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn_6 = in1_rawIn_expIn_6 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn_6 = in1_rawIn_fractIn_6 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in1_rawIn_normDist_T_209 = in1_rawIn_fractIn_6[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_210 = in1_rawIn_fractIn_6[2] ? 5'h14 : _in1_rawIn_normDist_T_209; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_211 = in1_rawIn_fractIn_6[3] ? 5'h13 : _in1_rawIn_normDist_T_210; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_212 = in1_rawIn_fractIn_6[4] ? 5'h12 : _in1_rawIn_normDist_T_211; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_213 = in1_rawIn_fractIn_6[5] ? 5'h11 : _in1_rawIn_normDist_T_212; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_214 = in1_rawIn_fractIn_6[6] ? 5'h10 : _in1_rawIn_normDist_T_213; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_215 = in1_rawIn_fractIn_6[7] ? 5'hf : _in1_rawIn_normDist_T_214; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_216 = in1_rawIn_fractIn_6[8] ? 5'he : _in1_rawIn_normDist_T_215; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_217 = in1_rawIn_fractIn_6[9] ? 5'hd : _in1_rawIn_normDist_T_216; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_218 = in1_rawIn_fractIn_6[10] ? 5'hc : _in1_rawIn_normDist_T_217; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_219 = in1_rawIn_fractIn_6[11] ? 5'hb : _in1_rawIn_normDist_T_218; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_220 = in1_rawIn_fractIn_6[12] ? 5'ha : _in1_rawIn_normDist_T_219; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_221 = in1_rawIn_fractIn_6[13] ? 5'h9 : _in1_rawIn_normDist_T_220; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_222 = in1_rawIn_fractIn_6[14] ? 5'h8 : _in1_rawIn_normDist_T_221; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_223 = in1_rawIn_fractIn_6[15] ? 5'h7 : _in1_rawIn_normDist_T_222; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_224 = in1_rawIn_fractIn_6[16] ? 5'h6 : _in1_rawIn_normDist_T_223; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_225 = in1_rawIn_fractIn_6[17] ? 5'h5 : _in1_rawIn_normDist_T_224; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_226 = in1_rawIn_fractIn_6[18] ? 5'h4 : _in1_rawIn_normDist_T_225; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_227 = in1_rawIn_fractIn_6[19] ? 5'h3 : _in1_rawIn_normDist_T_226; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_228 = in1_rawIn_fractIn_6[20] ? 5'h2 : _in1_rawIn_normDist_T_227; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in1_rawIn_normDist_T_229 = in1_rawIn_fractIn_6[21] ? 5'h1 : _in1_rawIn_normDist_T_228; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in1_rawIn_normDist_6 = in1_rawIn_fractIn_6[22] ? 5'h0 : _in1_rawIn_normDist_T_229; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_86 = {{31'd0}, in1_rawIn_fractIn_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in1_rawIn_subnormFract_T_12 = _GEN_86 << in1_rawIn_normDist_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in1_rawIn_subnormFract_6 = {_in1_rawIn_subnormFract_T_12[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_28 = {{4'd0}, in1_rawIn_normDist_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_30 = _GEN_28 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in1_rawIn_adjustedExp_T_31 = in1_rawIn_isZeroExpIn_6 ? _in1_rawIn_adjustedExp_T_30 : {{1'd0},
    in1_rawIn_expIn_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_32 = in1_rawIn_isZeroExpIn_6 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_29 = {{6'd0}, _in1_rawIn_adjustedExp_T_32}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in1_rawIn_adjustedExp_T_33 = 8'h80 | _GEN_29; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_30 = {{1'd0}, _in1_rawIn_adjustedExp_T_33}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in1_rawIn_adjustedExp_6 = _in1_rawIn_adjustedExp_T_31 + _GEN_30; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero_6 = in1_rawIn_isZeroExpIn_6 & in1_rawIn_isZeroFractIn_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial_6 = in1_rawIn_adjustedExp_6[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn_6_isNaN = in1_rawIn_isSpecial_6 & ~in1_rawIn_isZeroFractIn_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in1_rawIn_6_sExp = {1'b0,$signed(in1_rawIn_adjustedExp_6)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T_24 = ~in1_rawIn_isZero_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in1_rawIn_out_sig_T_26 = in1_rawIn_isZeroExpIn_6 ? in1_rawIn_subnormFract_6 : in1_rawIn_fractIn_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in1_rawIn_6_sig = {1'h0,_in1_rawIn_out_sig_T_24,_in1_rawIn_out_sig_T_26}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_79 = in1_rawIn_isZero_6 ? 3'h0 : in1_rawIn_6_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_31 = {{2'd0}, in1_rawIn_6_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_81 = _in1_T_79 | _GEN_31; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [32:0] _in1_T_86 = {in1_rawIn_sign_6,_in1_T_81,in1_rawIn_6_sExp[5:0],in1_rawIn_6_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  in1_rawIn_sign_7 = _in1_T_77[15]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [4:0] in1_rawIn_expIn_7 = _in1_T_77[14:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [9:0] in1_rawIn_fractIn_7 = _in1_T_77[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in1_rawIn_isZeroExpIn_7 = in1_rawIn_expIn_7 == 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in1_rawIn_isZeroFractIn_7 = in1_rawIn_fractIn_7 == 10'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [3:0] _in1_rawIn_normDist_T_240 = in1_rawIn_fractIn_7[1] ? 4'h8 : 4'h9; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_241 = in1_rawIn_fractIn_7[2] ? 4'h7 : _in1_rawIn_normDist_T_240; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_242 = in1_rawIn_fractIn_7[3] ? 4'h6 : _in1_rawIn_normDist_T_241; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_243 = in1_rawIn_fractIn_7[4] ? 4'h5 : _in1_rawIn_normDist_T_242; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_244 = in1_rawIn_fractIn_7[5] ? 4'h4 : _in1_rawIn_normDist_T_243; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_245 = in1_rawIn_fractIn_7[6] ? 4'h3 : _in1_rawIn_normDist_T_244; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_246 = in1_rawIn_fractIn_7[7] ? 4'h2 : _in1_rawIn_normDist_T_245; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in1_rawIn_normDist_T_247 = in1_rawIn_fractIn_7[8] ? 4'h1 : _in1_rawIn_normDist_T_246; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] in1_rawIn_normDist_7 = in1_rawIn_fractIn_7[9] ? 4'h0 : _in1_rawIn_normDist_T_247; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [24:0] _GEN_87 = {{15'd0}, in1_rawIn_fractIn_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [24:0] _in1_rawIn_subnormFract_T_14 = _GEN_87 << in1_rawIn_normDist_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [9:0] in1_rawIn_subnormFract_7 = {_in1_rawIn_subnormFract_T_14[8:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_32 = {{2'd0}, in1_rawIn_normDist_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in1_rawIn_adjustedExp_T_35 = _GEN_32 ^ 6'h3f; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in1_rawIn_adjustedExp_T_36 = in1_rawIn_isZeroExpIn_7 ? _in1_rawIn_adjustedExp_T_35 : {{1'd0},
    in1_rawIn_expIn_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in1_rawIn_adjustedExp_T_37 = in1_rawIn_isZeroExpIn_7 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_33 = {{3'd0}, _in1_rawIn_adjustedExp_T_37}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [4:0] _in1_rawIn_adjustedExp_T_38 = 5'h10 | _GEN_33; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_34 = {{1'd0}, _in1_rawIn_adjustedExp_T_38}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [5:0] in1_rawIn_adjustedExp_7 = _in1_rawIn_adjustedExp_T_36 + _GEN_34; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in1_rawIn_isZero_7 = in1_rawIn_isZeroExpIn_7 & in1_rawIn_isZeroFractIn_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in1_rawIn_isSpecial_7 = in1_rawIn_adjustedExp_7[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in1_rawIn_7_isNaN = in1_rawIn_isSpecial_7 & ~in1_rawIn_isZeroFractIn_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [6:0] in1_rawIn_7_sExp = {1'b0,$signed(in1_rawIn_adjustedExp_7)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in1_rawIn_out_sig_T_28 = ~in1_rawIn_isZero_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [9:0] _in1_rawIn_out_sig_T_30 = in1_rawIn_isZeroExpIn_7 ? in1_rawIn_subnormFract_7 : in1_rawIn_fractIn_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [11:0] in1_rawIn_7_sig = {1'h0,_in1_rawIn_out_sig_T_28,_in1_rawIn_out_sig_T_30}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in1_T_88 = in1_rawIn_isZero_7 ? 3'h0 : in1_rawIn_7_sExp[5:3]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_35 = {{2'd0}, in1_rawIn_7_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in1_T_90 = _in1_T_88 | _GEN_35; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [16:0] _in1_T_95 = {in1_rawIn_sign_7,_in1_T_90,in1_rawIn_7_sExp[2:0],in1_rawIn_7_sig[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  _in1_swizzledNaN_T_26 = &_in1_T_86[22:16]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 338:42]
  wire [32:0] in1_swizzledNaN_3 = {_in1_T_86[32:29],_in1_swizzledNaN_T_26,_in1_T_86[27:24],_in1_T_95[15],_in1_T_86[22:16
    ],_in1_T_95[16],_in1_T_95[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 336:26]
  wire  _in1_T_97 = &_in1_T_86[31:29]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 249:56]
  wire [32:0] _in1_T_98 = _in1_T_97 ? in1_swizzledNaN_3 : _in1_T_86; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 344:8]
  wire [16:0] in1_floats_0_3 = {_in1_T_98[15],_in1_T_98[23],_in1_T_98[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 356:31]
  wire  in1_prev_isbox_3 = &_in1_T_98[32:28]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 332:84]
  wire [16:0] _in1_T_99 = in1_prev_isbox_3 ? 17'h0 : 17'he200; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:31]
  wire [31:0] _GEN_36 = {{16'd0}, io_in_bits_b_0}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire [31:0] _in2_T_2 = 32'hffff0000 | _GEN_36; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire  in2_rawIn_sign = _in2_T_2[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in2_rawIn_expIn = _in2_T_2[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in2_rawIn_fractIn = _in2_T_2[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
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
  wire [53:0] _GEN_88 = {{31'd0}, in2_rawIn_fractIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in2_rawIn_subnormFract_T = _GEN_88 << in2_rawIn_normDist; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in2_rawIn_subnormFract = {_in2_rawIn_subnormFract_T[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_37 = {{4'd0}, in2_rawIn_normDist}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T = _GEN_37 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_1 = in2_rawIn_isZeroExpIn ? _in2_rawIn_adjustedExp_T : {{1'd0}, in2_rawIn_expIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_2 = in2_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_38 = {{6'd0}, _in2_rawIn_adjustedExp_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in2_rawIn_adjustedExp_T_3 = 8'h80 | _GEN_38; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_39 = {{1'd0}, _in2_rawIn_adjustedExp_T_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in2_rawIn_adjustedExp = _in2_rawIn_adjustedExp_T_1 + _GEN_39; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero = in2_rawIn_isZeroExpIn & in2_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial = in2_rawIn_adjustedExp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn__isNaN = in2_rawIn_isSpecial & ~in2_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in2_rawIn__sExp = {1'b0,$signed(in2_rawIn_adjustedExp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T = ~in2_rawIn_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in2_rawIn_out_sig_T_2 = in2_rawIn_isZeroExpIn ? in2_rawIn_subnormFract : in2_rawIn_fractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in2_rawIn__sig = {1'h0,_in2_rawIn_out_sig_T,_in2_rawIn_out_sig_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_4 = in2_rawIn_isZero ? 3'h0 : in2_rawIn__sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_40 = {{2'd0}, in2_rawIn__isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_6 = _in2_T_4 | _GEN_40; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [32:0] _in2_T_11 = {in2_rawIn_sign,_in2_T_6,in2_rawIn__sExp[5:0],in2_rawIn__sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  in2_rawIn_sign_1 = _in2_T_2[15]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [4:0] in2_rawIn_expIn_1 = _in2_T_2[14:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [9:0] in2_rawIn_fractIn_1 = _in2_T_2[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn_1 = in2_rawIn_expIn_1 == 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn_1 = in2_rawIn_fractIn_1 == 10'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [3:0] _in2_rawIn_normDist_T_54 = in2_rawIn_fractIn_1[1] ? 4'h8 : 4'h9; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_55 = in2_rawIn_fractIn_1[2] ? 4'h7 : _in2_rawIn_normDist_T_54; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_56 = in2_rawIn_fractIn_1[3] ? 4'h6 : _in2_rawIn_normDist_T_55; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_57 = in2_rawIn_fractIn_1[4] ? 4'h5 : _in2_rawIn_normDist_T_56; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_58 = in2_rawIn_fractIn_1[5] ? 4'h4 : _in2_rawIn_normDist_T_57; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_59 = in2_rawIn_fractIn_1[6] ? 4'h3 : _in2_rawIn_normDist_T_58; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_60 = in2_rawIn_fractIn_1[7] ? 4'h2 : _in2_rawIn_normDist_T_59; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_61 = in2_rawIn_fractIn_1[8] ? 4'h1 : _in2_rawIn_normDist_T_60; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] in2_rawIn_normDist_1 = in2_rawIn_fractIn_1[9] ? 4'h0 : _in2_rawIn_normDist_T_61; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [24:0] _GEN_89 = {{15'd0}, in2_rawIn_fractIn_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [24:0] _in2_rawIn_subnormFract_T_2 = _GEN_89 << in2_rawIn_normDist_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [9:0] in2_rawIn_subnormFract_1 = {_in2_rawIn_subnormFract_T_2[8:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_41 = {{2'd0}, in2_rawIn_normDist_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in2_rawIn_adjustedExp_T_5 = _GEN_41 ^ 6'h3f; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in2_rawIn_adjustedExp_T_6 = in2_rawIn_isZeroExpIn_1 ? _in2_rawIn_adjustedExp_T_5 : {{1'd0},
    in2_rawIn_expIn_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_7 = in2_rawIn_isZeroExpIn_1 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_42 = {{3'd0}, _in2_rawIn_adjustedExp_T_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [4:0] _in2_rawIn_adjustedExp_T_8 = 5'h10 | _GEN_42; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_43 = {{1'd0}, _in2_rawIn_adjustedExp_T_8}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [5:0] in2_rawIn_adjustedExp_1 = _in2_rawIn_adjustedExp_T_6 + _GEN_43; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero_1 = in2_rawIn_isZeroExpIn_1 & in2_rawIn_isZeroFractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial_1 = in2_rawIn_adjustedExp_1[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn_1_isNaN = in2_rawIn_isSpecial_1 & ~in2_rawIn_isZeroFractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [6:0] in2_rawIn_1_sExp = {1'b0,$signed(in2_rawIn_adjustedExp_1)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T_4 = ~in2_rawIn_isZero_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [9:0] _in2_rawIn_out_sig_T_6 = in2_rawIn_isZeroExpIn_1 ? in2_rawIn_subnormFract_1 : in2_rawIn_fractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [11:0] in2_rawIn_1_sig = {1'h0,_in2_rawIn_out_sig_T_4,_in2_rawIn_out_sig_T_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_13 = in2_rawIn_isZero_1 ? 3'h0 : in2_rawIn_1_sExp[5:3]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_44 = {{2'd0}, in2_rawIn_1_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_15 = _in2_T_13 | _GEN_44; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [16:0] _in2_T_20 = {in2_rawIn_sign_1,_in2_T_15,in2_rawIn_1_sExp[2:0],in2_rawIn_1_sig[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  _in2_swizzledNaN_T_2 = &_in2_T_11[22:16]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 338:42]
  wire [32:0] in2_swizzledNaN = {_in2_T_11[32:29],_in2_swizzledNaN_T_2,_in2_T_11[27:24],_in2_T_20[15],_in2_T_11[22:16],
    _in2_T_20[16],_in2_T_20[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 336:26]
  wire  _in2_T_22 = &_in2_T_11[31:29]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 249:56]
  wire [32:0] _in2_T_23 = _in2_T_22 ? in2_swizzledNaN : _in2_T_11; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 344:8]
  wire [16:0] in2_floats_0 = {_in2_T_23[15],_in2_T_23[23],_in2_T_23[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 356:31]
  wire  in2_prev_isbox = &_in2_T_23[32:28]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 332:84]
  wire [16:0] _in2_T_24 = in2_prev_isbox ? 17'h0 : 17'he200; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:31]
  wire [31:0] _GEN_45 = {{16'd0}, io_in_bits_b_1}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire [31:0] _in2_T_27 = 32'hffff0000 | _GEN_45; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire  in2_rawIn_sign_2 = _in2_T_27[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in2_rawIn_expIn_2 = _in2_T_27[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in2_rawIn_fractIn_2 = _in2_T_27[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn_2 = in2_rawIn_expIn_2 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn_2 = in2_rawIn_fractIn_2 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in2_rawIn_normDist_T_85 = in2_rawIn_fractIn_2[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_86 = in2_rawIn_fractIn_2[2] ? 5'h14 : _in2_rawIn_normDist_T_85; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_87 = in2_rawIn_fractIn_2[3] ? 5'h13 : _in2_rawIn_normDist_T_86; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_88 = in2_rawIn_fractIn_2[4] ? 5'h12 : _in2_rawIn_normDist_T_87; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_89 = in2_rawIn_fractIn_2[5] ? 5'h11 : _in2_rawIn_normDist_T_88; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_90 = in2_rawIn_fractIn_2[6] ? 5'h10 : _in2_rawIn_normDist_T_89; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_91 = in2_rawIn_fractIn_2[7] ? 5'hf : _in2_rawIn_normDist_T_90; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_92 = in2_rawIn_fractIn_2[8] ? 5'he : _in2_rawIn_normDist_T_91; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_93 = in2_rawIn_fractIn_2[9] ? 5'hd : _in2_rawIn_normDist_T_92; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_94 = in2_rawIn_fractIn_2[10] ? 5'hc : _in2_rawIn_normDist_T_93; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_95 = in2_rawIn_fractIn_2[11] ? 5'hb : _in2_rawIn_normDist_T_94; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_96 = in2_rawIn_fractIn_2[12] ? 5'ha : _in2_rawIn_normDist_T_95; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_97 = in2_rawIn_fractIn_2[13] ? 5'h9 : _in2_rawIn_normDist_T_96; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_98 = in2_rawIn_fractIn_2[14] ? 5'h8 : _in2_rawIn_normDist_T_97; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_99 = in2_rawIn_fractIn_2[15] ? 5'h7 : _in2_rawIn_normDist_T_98; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_100 = in2_rawIn_fractIn_2[16] ? 5'h6 : _in2_rawIn_normDist_T_99; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_101 = in2_rawIn_fractIn_2[17] ? 5'h5 : _in2_rawIn_normDist_T_100; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_102 = in2_rawIn_fractIn_2[18] ? 5'h4 : _in2_rawIn_normDist_T_101; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_103 = in2_rawIn_fractIn_2[19] ? 5'h3 : _in2_rawIn_normDist_T_102; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_104 = in2_rawIn_fractIn_2[20] ? 5'h2 : _in2_rawIn_normDist_T_103; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_105 = in2_rawIn_fractIn_2[21] ? 5'h1 : _in2_rawIn_normDist_T_104; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in2_rawIn_normDist_2 = in2_rawIn_fractIn_2[22] ? 5'h0 : _in2_rawIn_normDist_T_105; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_90 = {{31'd0}, in2_rawIn_fractIn_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in2_rawIn_subnormFract_T_4 = _GEN_90 << in2_rawIn_normDist_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in2_rawIn_subnormFract_2 = {_in2_rawIn_subnormFract_T_4[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_46 = {{4'd0}, in2_rawIn_normDist_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_10 = _GEN_46 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_11 = in2_rawIn_isZeroExpIn_2 ? _in2_rawIn_adjustedExp_T_10 : {{1'd0},
    in2_rawIn_expIn_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_12 = in2_rawIn_isZeroExpIn_2 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_47 = {{6'd0}, _in2_rawIn_adjustedExp_T_12}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in2_rawIn_adjustedExp_T_13 = 8'h80 | _GEN_47; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_48 = {{1'd0}, _in2_rawIn_adjustedExp_T_13}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in2_rawIn_adjustedExp_2 = _in2_rawIn_adjustedExp_T_11 + _GEN_48; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero_2 = in2_rawIn_isZeroExpIn_2 & in2_rawIn_isZeroFractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial_2 = in2_rawIn_adjustedExp_2[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn_2_isNaN = in2_rawIn_isSpecial_2 & ~in2_rawIn_isZeroFractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in2_rawIn_2_sExp = {1'b0,$signed(in2_rawIn_adjustedExp_2)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T_8 = ~in2_rawIn_isZero_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in2_rawIn_out_sig_T_10 = in2_rawIn_isZeroExpIn_2 ? in2_rawIn_subnormFract_2 : in2_rawIn_fractIn_2; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in2_rawIn_2_sig = {1'h0,_in2_rawIn_out_sig_T_8,_in2_rawIn_out_sig_T_10}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_29 = in2_rawIn_isZero_2 ? 3'h0 : in2_rawIn_2_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_49 = {{2'd0}, in2_rawIn_2_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_31 = _in2_T_29 | _GEN_49; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [32:0] _in2_T_36 = {in2_rawIn_sign_2,_in2_T_31,in2_rawIn_2_sExp[5:0],in2_rawIn_2_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  in2_rawIn_sign_3 = _in2_T_27[15]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [4:0] in2_rawIn_expIn_3 = _in2_T_27[14:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [9:0] in2_rawIn_fractIn_3 = _in2_T_27[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn_3 = in2_rawIn_expIn_3 == 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn_3 = in2_rawIn_fractIn_3 == 10'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [3:0] _in2_rawIn_normDist_T_116 = in2_rawIn_fractIn_3[1] ? 4'h8 : 4'h9; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_117 = in2_rawIn_fractIn_3[2] ? 4'h7 : _in2_rawIn_normDist_T_116; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_118 = in2_rawIn_fractIn_3[3] ? 4'h6 : _in2_rawIn_normDist_T_117; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_119 = in2_rawIn_fractIn_3[4] ? 4'h5 : _in2_rawIn_normDist_T_118; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_120 = in2_rawIn_fractIn_3[5] ? 4'h4 : _in2_rawIn_normDist_T_119; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_121 = in2_rawIn_fractIn_3[6] ? 4'h3 : _in2_rawIn_normDist_T_120; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_122 = in2_rawIn_fractIn_3[7] ? 4'h2 : _in2_rawIn_normDist_T_121; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_123 = in2_rawIn_fractIn_3[8] ? 4'h1 : _in2_rawIn_normDist_T_122; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] in2_rawIn_normDist_3 = in2_rawIn_fractIn_3[9] ? 4'h0 : _in2_rawIn_normDist_T_123; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [24:0] _GEN_91 = {{15'd0}, in2_rawIn_fractIn_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [24:0] _in2_rawIn_subnormFract_T_6 = _GEN_91 << in2_rawIn_normDist_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [9:0] in2_rawIn_subnormFract_3 = {_in2_rawIn_subnormFract_T_6[8:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_50 = {{2'd0}, in2_rawIn_normDist_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in2_rawIn_adjustedExp_T_15 = _GEN_50 ^ 6'h3f; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in2_rawIn_adjustedExp_T_16 = in2_rawIn_isZeroExpIn_3 ? _in2_rawIn_adjustedExp_T_15 : {{1'd0},
    in2_rawIn_expIn_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_17 = in2_rawIn_isZeroExpIn_3 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_51 = {{3'd0}, _in2_rawIn_adjustedExp_T_17}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [4:0] _in2_rawIn_adjustedExp_T_18 = 5'h10 | _GEN_51; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_52 = {{1'd0}, _in2_rawIn_adjustedExp_T_18}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [5:0] in2_rawIn_adjustedExp_3 = _in2_rawIn_adjustedExp_T_16 + _GEN_52; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero_3 = in2_rawIn_isZeroExpIn_3 & in2_rawIn_isZeroFractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial_3 = in2_rawIn_adjustedExp_3[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn_3_isNaN = in2_rawIn_isSpecial_3 & ~in2_rawIn_isZeroFractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [6:0] in2_rawIn_3_sExp = {1'b0,$signed(in2_rawIn_adjustedExp_3)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T_12 = ~in2_rawIn_isZero_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [9:0] _in2_rawIn_out_sig_T_14 = in2_rawIn_isZeroExpIn_3 ? in2_rawIn_subnormFract_3 : in2_rawIn_fractIn_3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [11:0] in2_rawIn_3_sig = {1'h0,_in2_rawIn_out_sig_T_12,_in2_rawIn_out_sig_T_14}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_38 = in2_rawIn_isZero_3 ? 3'h0 : in2_rawIn_3_sExp[5:3]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_53 = {{2'd0}, in2_rawIn_3_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_40 = _in2_T_38 | _GEN_53; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [16:0] _in2_T_45 = {in2_rawIn_sign_3,_in2_T_40,in2_rawIn_3_sExp[2:0],in2_rawIn_3_sig[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  _in2_swizzledNaN_T_10 = &_in2_T_36[22:16]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 338:42]
  wire [32:0] in2_swizzledNaN_1 = {_in2_T_36[32:29],_in2_swizzledNaN_T_10,_in2_T_36[27:24],_in2_T_45[15],_in2_T_36[22:16
    ],_in2_T_45[16],_in2_T_45[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 336:26]
  wire  _in2_T_47 = &_in2_T_36[31:29]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 249:56]
  wire [32:0] _in2_T_48 = _in2_T_47 ? in2_swizzledNaN_1 : _in2_T_36; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 344:8]
  wire [16:0] in2_floats_0_1 = {_in2_T_48[15],_in2_T_48[23],_in2_T_48[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 356:31]
  wire  in2_prev_isbox_1 = &_in2_T_48[32:28]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 332:84]
  wire [16:0] _in2_T_49 = in2_prev_isbox_1 ? 17'h0 : 17'he200; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:31]
  wire [31:0] _GEN_54 = {{16'd0}, io_in_bits_b_2}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire [31:0] _in2_T_52 = 32'hffff0000 | _GEN_54; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire  in2_rawIn_sign_4 = _in2_T_52[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in2_rawIn_expIn_4 = _in2_T_52[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in2_rawIn_fractIn_4 = _in2_T_52[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn_4 = in2_rawIn_expIn_4 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn_4 = in2_rawIn_fractIn_4 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in2_rawIn_normDist_T_147 = in2_rawIn_fractIn_4[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_148 = in2_rawIn_fractIn_4[2] ? 5'h14 : _in2_rawIn_normDist_T_147; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_149 = in2_rawIn_fractIn_4[3] ? 5'h13 : _in2_rawIn_normDist_T_148; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_150 = in2_rawIn_fractIn_4[4] ? 5'h12 : _in2_rawIn_normDist_T_149; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_151 = in2_rawIn_fractIn_4[5] ? 5'h11 : _in2_rawIn_normDist_T_150; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_152 = in2_rawIn_fractIn_4[6] ? 5'h10 : _in2_rawIn_normDist_T_151; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_153 = in2_rawIn_fractIn_4[7] ? 5'hf : _in2_rawIn_normDist_T_152; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_154 = in2_rawIn_fractIn_4[8] ? 5'he : _in2_rawIn_normDist_T_153; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_155 = in2_rawIn_fractIn_4[9] ? 5'hd : _in2_rawIn_normDist_T_154; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_156 = in2_rawIn_fractIn_4[10] ? 5'hc : _in2_rawIn_normDist_T_155; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_157 = in2_rawIn_fractIn_4[11] ? 5'hb : _in2_rawIn_normDist_T_156; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_158 = in2_rawIn_fractIn_4[12] ? 5'ha : _in2_rawIn_normDist_T_157; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_159 = in2_rawIn_fractIn_4[13] ? 5'h9 : _in2_rawIn_normDist_T_158; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_160 = in2_rawIn_fractIn_4[14] ? 5'h8 : _in2_rawIn_normDist_T_159; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_161 = in2_rawIn_fractIn_4[15] ? 5'h7 : _in2_rawIn_normDist_T_160; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_162 = in2_rawIn_fractIn_4[16] ? 5'h6 : _in2_rawIn_normDist_T_161; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_163 = in2_rawIn_fractIn_4[17] ? 5'h5 : _in2_rawIn_normDist_T_162; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_164 = in2_rawIn_fractIn_4[18] ? 5'h4 : _in2_rawIn_normDist_T_163; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_165 = in2_rawIn_fractIn_4[19] ? 5'h3 : _in2_rawIn_normDist_T_164; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_166 = in2_rawIn_fractIn_4[20] ? 5'h2 : _in2_rawIn_normDist_T_165; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_167 = in2_rawIn_fractIn_4[21] ? 5'h1 : _in2_rawIn_normDist_T_166; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in2_rawIn_normDist_4 = in2_rawIn_fractIn_4[22] ? 5'h0 : _in2_rawIn_normDist_T_167; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_92 = {{31'd0}, in2_rawIn_fractIn_4}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in2_rawIn_subnormFract_T_8 = _GEN_92 << in2_rawIn_normDist_4; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in2_rawIn_subnormFract_4 = {_in2_rawIn_subnormFract_T_8[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_55 = {{4'd0}, in2_rawIn_normDist_4}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_20 = _GEN_55 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_21 = in2_rawIn_isZeroExpIn_4 ? _in2_rawIn_adjustedExp_T_20 : {{1'd0},
    in2_rawIn_expIn_4}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_22 = in2_rawIn_isZeroExpIn_4 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_56 = {{6'd0}, _in2_rawIn_adjustedExp_T_22}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in2_rawIn_adjustedExp_T_23 = 8'h80 | _GEN_56; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_57 = {{1'd0}, _in2_rawIn_adjustedExp_T_23}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in2_rawIn_adjustedExp_4 = _in2_rawIn_adjustedExp_T_21 + _GEN_57; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero_4 = in2_rawIn_isZeroExpIn_4 & in2_rawIn_isZeroFractIn_4; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial_4 = in2_rawIn_adjustedExp_4[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn_4_isNaN = in2_rawIn_isSpecial_4 & ~in2_rawIn_isZeroFractIn_4; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in2_rawIn_4_sExp = {1'b0,$signed(in2_rawIn_adjustedExp_4)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T_16 = ~in2_rawIn_isZero_4; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in2_rawIn_out_sig_T_18 = in2_rawIn_isZeroExpIn_4 ? in2_rawIn_subnormFract_4 : in2_rawIn_fractIn_4; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in2_rawIn_4_sig = {1'h0,_in2_rawIn_out_sig_T_16,_in2_rawIn_out_sig_T_18}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_54 = in2_rawIn_isZero_4 ? 3'h0 : in2_rawIn_4_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_58 = {{2'd0}, in2_rawIn_4_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_56 = _in2_T_54 | _GEN_58; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [32:0] _in2_T_61 = {in2_rawIn_sign_4,_in2_T_56,in2_rawIn_4_sExp[5:0],in2_rawIn_4_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  in2_rawIn_sign_5 = _in2_T_52[15]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [4:0] in2_rawIn_expIn_5 = _in2_T_52[14:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [9:0] in2_rawIn_fractIn_5 = _in2_T_52[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn_5 = in2_rawIn_expIn_5 == 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn_5 = in2_rawIn_fractIn_5 == 10'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [3:0] _in2_rawIn_normDist_T_178 = in2_rawIn_fractIn_5[1] ? 4'h8 : 4'h9; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_179 = in2_rawIn_fractIn_5[2] ? 4'h7 : _in2_rawIn_normDist_T_178; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_180 = in2_rawIn_fractIn_5[3] ? 4'h6 : _in2_rawIn_normDist_T_179; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_181 = in2_rawIn_fractIn_5[4] ? 4'h5 : _in2_rawIn_normDist_T_180; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_182 = in2_rawIn_fractIn_5[5] ? 4'h4 : _in2_rawIn_normDist_T_181; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_183 = in2_rawIn_fractIn_5[6] ? 4'h3 : _in2_rawIn_normDist_T_182; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_184 = in2_rawIn_fractIn_5[7] ? 4'h2 : _in2_rawIn_normDist_T_183; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_185 = in2_rawIn_fractIn_5[8] ? 4'h1 : _in2_rawIn_normDist_T_184; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] in2_rawIn_normDist_5 = in2_rawIn_fractIn_5[9] ? 4'h0 : _in2_rawIn_normDist_T_185; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [24:0] _GEN_93 = {{15'd0}, in2_rawIn_fractIn_5}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [24:0] _in2_rawIn_subnormFract_T_10 = _GEN_93 << in2_rawIn_normDist_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [9:0] in2_rawIn_subnormFract_5 = {_in2_rawIn_subnormFract_T_10[8:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_59 = {{2'd0}, in2_rawIn_normDist_5}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in2_rawIn_adjustedExp_T_25 = _GEN_59 ^ 6'h3f; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in2_rawIn_adjustedExp_T_26 = in2_rawIn_isZeroExpIn_5 ? _in2_rawIn_adjustedExp_T_25 : {{1'd0},
    in2_rawIn_expIn_5}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_27 = in2_rawIn_isZeroExpIn_5 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_60 = {{3'd0}, _in2_rawIn_adjustedExp_T_27}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [4:0] _in2_rawIn_adjustedExp_T_28 = 5'h10 | _GEN_60; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_61 = {{1'd0}, _in2_rawIn_adjustedExp_T_28}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [5:0] in2_rawIn_adjustedExp_5 = _in2_rawIn_adjustedExp_T_26 + _GEN_61; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero_5 = in2_rawIn_isZeroExpIn_5 & in2_rawIn_isZeroFractIn_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial_5 = in2_rawIn_adjustedExp_5[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn_5_isNaN = in2_rawIn_isSpecial_5 & ~in2_rawIn_isZeroFractIn_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [6:0] in2_rawIn_5_sExp = {1'b0,$signed(in2_rawIn_adjustedExp_5)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T_20 = ~in2_rawIn_isZero_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [9:0] _in2_rawIn_out_sig_T_22 = in2_rawIn_isZeroExpIn_5 ? in2_rawIn_subnormFract_5 : in2_rawIn_fractIn_5; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [11:0] in2_rawIn_5_sig = {1'h0,_in2_rawIn_out_sig_T_20,_in2_rawIn_out_sig_T_22}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_63 = in2_rawIn_isZero_5 ? 3'h0 : in2_rawIn_5_sExp[5:3]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_62 = {{2'd0}, in2_rawIn_5_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_65 = _in2_T_63 | _GEN_62; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [16:0] _in2_T_70 = {in2_rawIn_sign_5,_in2_T_65,in2_rawIn_5_sExp[2:0],in2_rawIn_5_sig[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  _in2_swizzledNaN_T_18 = &_in2_T_61[22:16]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 338:42]
  wire [32:0] in2_swizzledNaN_2 = {_in2_T_61[32:29],_in2_swizzledNaN_T_18,_in2_T_61[27:24],_in2_T_70[15],_in2_T_61[22:16
    ],_in2_T_70[16],_in2_T_70[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 336:26]
  wire  _in2_T_72 = &_in2_T_61[31:29]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 249:56]
  wire [32:0] _in2_T_73 = _in2_T_72 ? in2_swizzledNaN_2 : _in2_T_61; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 344:8]
  wire [16:0] in2_floats_0_2 = {_in2_T_73[15],_in2_T_73[23],_in2_T_73[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 356:31]
  wire  in2_prev_isbox_2 = &_in2_T_73[32:28]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 332:84]
  wire [16:0] _in2_T_74 = in2_prev_isbox_2 ? 17'h0 : 17'he200; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:31]
  wire [31:0] _GEN_63 = {{16'd0}, io_in_bits_b_3}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire [31:0] _in2_T_77 = 32'hffff0000 | _GEN_63; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 431:23]
  wire  in2_rawIn_sign_6 = _in2_T_77[31]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [7:0] in2_rawIn_expIn_6 = _in2_T_77[30:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [22:0] in2_rawIn_fractIn_6 = _in2_T_77[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn_6 = in2_rawIn_expIn_6 == 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn_6 = in2_rawIn_fractIn_6 == 23'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [4:0] _in2_rawIn_normDist_T_209 = in2_rawIn_fractIn_6[1] ? 5'h15 : 5'h16; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_210 = in2_rawIn_fractIn_6[2] ? 5'h14 : _in2_rawIn_normDist_T_209; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_211 = in2_rawIn_fractIn_6[3] ? 5'h13 : _in2_rawIn_normDist_T_210; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_212 = in2_rawIn_fractIn_6[4] ? 5'h12 : _in2_rawIn_normDist_T_211; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_213 = in2_rawIn_fractIn_6[5] ? 5'h11 : _in2_rawIn_normDist_T_212; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_214 = in2_rawIn_fractIn_6[6] ? 5'h10 : _in2_rawIn_normDist_T_213; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_215 = in2_rawIn_fractIn_6[7] ? 5'hf : _in2_rawIn_normDist_T_214; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_216 = in2_rawIn_fractIn_6[8] ? 5'he : _in2_rawIn_normDist_T_215; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_217 = in2_rawIn_fractIn_6[9] ? 5'hd : _in2_rawIn_normDist_T_216; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_218 = in2_rawIn_fractIn_6[10] ? 5'hc : _in2_rawIn_normDist_T_217; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_219 = in2_rawIn_fractIn_6[11] ? 5'hb : _in2_rawIn_normDist_T_218; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_220 = in2_rawIn_fractIn_6[12] ? 5'ha : _in2_rawIn_normDist_T_219; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_221 = in2_rawIn_fractIn_6[13] ? 5'h9 : _in2_rawIn_normDist_T_220; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_222 = in2_rawIn_fractIn_6[14] ? 5'h8 : _in2_rawIn_normDist_T_221; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_223 = in2_rawIn_fractIn_6[15] ? 5'h7 : _in2_rawIn_normDist_T_222; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_224 = in2_rawIn_fractIn_6[16] ? 5'h6 : _in2_rawIn_normDist_T_223; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_225 = in2_rawIn_fractIn_6[17] ? 5'h5 : _in2_rawIn_normDist_T_224; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_226 = in2_rawIn_fractIn_6[18] ? 5'h4 : _in2_rawIn_normDist_T_225; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_227 = in2_rawIn_fractIn_6[19] ? 5'h3 : _in2_rawIn_normDist_T_226; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_228 = in2_rawIn_fractIn_6[20] ? 5'h2 : _in2_rawIn_normDist_T_227; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _in2_rawIn_normDist_T_229 = in2_rawIn_fractIn_6[21] ? 5'h1 : _in2_rawIn_normDist_T_228; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] in2_rawIn_normDist_6 = in2_rawIn_fractIn_6[22] ? 5'h0 : _in2_rawIn_normDist_T_229; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [53:0] _GEN_94 = {{31'd0}, in2_rawIn_fractIn_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in2_rawIn_subnormFract_T_12 = _GEN_94 << in2_rawIn_normDist_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in2_rawIn_subnormFract_6 = {_in2_rawIn_subnormFract_T_12[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_64 = {{4'd0}, in2_rawIn_normDist_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_30 = _GEN_64 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in2_rawIn_adjustedExp_T_31 = in2_rawIn_isZeroExpIn_6 ? _in2_rawIn_adjustedExp_T_30 : {{1'd0},
    in2_rawIn_expIn_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_32 = in2_rawIn_isZeroExpIn_6 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_65 = {{6'd0}, _in2_rawIn_adjustedExp_T_32}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in2_rawIn_adjustedExp_T_33 = 8'h80 | _GEN_65; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_66 = {{1'd0}, _in2_rawIn_adjustedExp_T_33}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in2_rawIn_adjustedExp_6 = _in2_rawIn_adjustedExp_T_31 + _GEN_66; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero_6 = in2_rawIn_isZeroExpIn_6 & in2_rawIn_isZeroFractIn_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial_6 = in2_rawIn_adjustedExp_6[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn_6_isNaN = in2_rawIn_isSpecial_6 & ~in2_rawIn_isZeroFractIn_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in2_rawIn_6_sExp = {1'b0,$signed(in2_rawIn_adjustedExp_6)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T_24 = ~in2_rawIn_isZero_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in2_rawIn_out_sig_T_26 = in2_rawIn_isZeroExpIn_6 ? in2_rawIn_subnormFract_6 : in2_rawIn_fractIn_6; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in2_rawIn_6_sig = {1'h0,_in2_rawIn_out_sig_T_24,_in2_rawIn_out_sig_T_26}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_79 = in2_rawIn_isZero_6 ? 3'h0 : in2_rawIn_6_sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_67 = {{2'd0}, in2_rawIn_6_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_81 = _in2_T_79 | _GEN_67; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [32:0] _in2_T_86 = {in2_rawIn_sign_6,_in2_T_81,in2_rawIn_6_sExp[5:0],in2_rawIn_6_sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  in2_rawIn_sign_7 = _in2_T_77[15]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [4:0] in2_rawIn_expIn_7 = _in2_T_77[14:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [9:0] in2_rawIn_fractIn_7 = _in2_T_77[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in2_rawIn_isZeroExpIn_7 = in2_rawIn_expIn_7 == 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in2_rawIn_isZeroFractIn_7 = in2_rawIn_fractIn_7 == 10'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [3:0] _in2_rawIn_normDist_T_240 = in2_rawIn_fractIn_7[1] ? 4'h8 : 4'h9; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_241 = in2_rawIn_fractIn_7[2] ? 4'h7 : _in2_rawIn_normDist_T_240; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_242 = in2_rawIn_fractIn_7[3] ? 4'h6 : _in2_rawIn_normDist_T_241; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_243 = in2_rawIn_fractIn_7[4] ? 4'h5 : _in2_rawIn_normDist_T_242; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_244 = in2_rawIn_fractIn_7[5] ? 4'h4 : _in2_rawIn_normDist_T_243; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_245 = in2_rawIn_fractIn_7[6] ? 4'h3 : _in2_rawIn_normDist_T_244; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_246 = in2_rawIn_fractIn_7[7] ? 4'h2 : _in2_rawIn_normDist_T_245; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in2_rawIn_normDist_T_247 = in2_rawIn_fractIn_7[8] ? 4'h1 : _in2_rawIn_normDist_T_246; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] in2_rawIn_normDist_7 = in2_rawIn_fractIn_7[9] ? 4'h0 : _in2_rawIn_normDist_T_247; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [24:0] _GEN_95 = {{15'd0}, in2_rawIn_fractIn_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [24:0] _in2_rawIn_subnormFract_T_14 = _GEN_95 << in2_rawIn_normDist_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [9:0] in2_rawIn_subnormFract_7 = {_in2_rawIn_subnormFract_T_14[8:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_68 = {{2'd0}, in2_rawIn_normDist_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in2_rawIn_adjustedExp_T_35 = _GEN_68 ^ 6'h3f; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in2_rawIn_adjustedExp_T_36 = in2_rawIn_isZeroExpIn_7 ? _in2_rawIn_adjustedExp_T_35 : {{1'd0},
    in2_rawIn_expIn_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in2_rawIn_adjustedExp_T_37 = in2_rawIn_isZeroExpIn_7 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_69 = {{3'd0}, _in2_rawIn_adjustedExp_T_37}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [4:0] _in2_rawIn_adjustedExp_T_38 = 5'h10 | _GEN_69; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_70 = {{1'd0}, _in2_rawIn_adjustedExp_T_38}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [5:0] in2_rawIn_adjustedExp_7 = _in2_rawIn_adjustedExp_T_36 + _GEN_70; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in2_rawIn_isZero_7 = in2_rawIn_isZeroExpIn_7 & in2_rawIn_isZeroFractIn_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in2_rawIn_isSpecial_7 = in2_rawIn_adjustedExp_7[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in2_rawIn_7_isNaN = in2_rawIn_isSpecial_7 & ~in2_rawIn_isZeroFractIn_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [6:0] in2_rawIn_7_sExp = {1'b0,$signed(in2_rawIn_adjustedExp_7)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in2_rawIn_out_sig_T_28 = ~in2_rawIn_isZero_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [9:0] _in2_rawIn_out_sig_T_30 = in2_rawIn_isZeroExpIn_7 ? in2_rawIn_subnormFract_7 : in2_rawIn_fractIn_7; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [11:0] in2_rawIn_7_sig = {1'h0,_in2_rawIn_out_sig_T_28,_in2_rawIn_out_sig_T_30}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in2_T_88 = in2_rawIn_isZero_7 ? 3'h0 : in2_rawIn_7_sExp[5:3]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_71 = {{2'd0}, in2_rawIn_7_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in2_T_90 = _in2_T_88 | _GEN_71; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [16:0] _in2_T_95 = {in2_rawIn_sign_7,_in2_T_90,in2_rawIn_7_sExp[2:0],in2_rawIn_7_sig[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  _in2_swizzledNaN_T_26 = &_in2_T_86[22:16]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 338:42]
  wire [32:0] in2_swizzledNaN_3 = {_in2_T_86[32:29],_in2_swizzledNaN_T_26,_in2_T_86[27:24],_in2_T_95[15],_in2_T_86[22:16
    ],_in2_T_95[16],_in2_T_95[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 336:26]
  wire  _in2_T_97 = &_in2_T_86[31:29]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 249:56]
  wire [32:0] _in2_T_98 = _in2_T_97 ? in2_swizzledNaN_3 : _in2_T_86; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 344:8]
  wire [16:0] in2_floats_0_3 = {_in2_T_98[15],_in2_T_98[23],_in2_T_98[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 356:31]
  wire  in2_prev_isbox_3 = &_in2_T_98[32:28]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 332:84]
  wire [16:0] _in2_T_99 = in2_prev_isbox_3 ? 17'h0 : 17'he200; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:31]
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
  wire [53:0] _GEN_96 = {{31'd0}, in3_rawIn_fractIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [53:0] _in3_rawIn_subnormFract_T = _GEN_96 << in3_rawIn_normDist; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [22:0] in3_rawIn_subnormFract = {_in3_rawIn_subnormFract_T[21:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [8:0] _GEN_72 = {{4'd0}, in3_rawIn_normDist}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in3_rawIn_adjustedExp_T = _GEN_72 ^ 9'h1ff; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [8:0] _in3_rawIn_adjustedExp_T_1 = in3_rawIn_isZeroExpIn ? _in3_rawIn_adjustedExp_T : {{1'd0}, in3_rawIn_expIn}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in3_rawIn_adjustedExp_T_2 = in3_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [7:0] _GEN_73 = {{6'd0}, _in3_rawIn_adjustedExp_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [7:0] _in3_rawIn_adjustedExp_T_3 = 8'h80 | _GEN_73; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [8:0] _GEN_74 = {{1'd0}, _in3_rawIn_adjustedExp_T_3}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [8:0] in3_rawIn_adjustedExp = _in3_rawIn_adjustedExp_T_1 + _GEN_74; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in3_rawIn_isZero = in3_rawIn_isZeroExpIn & in3_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in3_rawIn_isSpecial = in3_rawIn_adjustedExp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in3_rawIn__isNaN = in3_rawIn_isSpecial & ~in3_rawIn_isZeroFractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [9:0] in3_rawIn__sExp = {1'b0,$signed(in3_rawIn_adjustedExp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in3_rawIn_out_sig_T = ~in3_rawIn_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [22:0] _in3_rawIn_out_sig_T_2 = in3_rawIn_isZeroExpIn ? in3_rawIn_subnormFract : in3_rawIn_fractIn; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [24:0] in3_rawIn__sig = {1'h0,_in3_rawIn_out_sig_T,_in3_rawIn_out_sig_T_2}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in3_T_4 = in3_rawIn_isZero ? 3'h0 : in3_rawIn__sExp[8:6]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_75 = {{2'd0}, in3_rawIn__isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in3_T_6 = _in3_T_4 | _GEN_75; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [32:0] _in3_T_11 = {in3_rawIn_sign,_in3_T_6,in3_rawIn__sExp[5:0],in3_rawIn__sig[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  in3_rawIn_sign_1 = io_in_bits_c[15]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 44:18]
  wire [4:0] in3_rawIn_expIn_1 = io_in_bits_c[14:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 45:19]
  wire [9:0] in3_rawIn_fractIn_1 = io_in_bits_c[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 46:21]
  wire  in3_rawIn_isZeroExpIn_1 = in3_rawIn_expIn_1 == 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 48:30]
  wire  in3_rawIn_isZeroFractIn_1 = in3_rawIn_fractIn_1 == 10'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 49:34]
  wire [3:0] _in3_rawIn_normDist_T_54 = in3_rawIn_fractIn_1[1] ? 4'h8 : 4'h9; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in3_rawIn_normDist_T_55 = in3_rawIn_fractIn_1[2] ? 4'h7 : _in3_rawIn_normDist_T_54; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in3_rawIn_normDist_T_56 = in3_rawIn_fractIn_1[3] ? 4'h6 : _in3_rawIn_normDist_T_55; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in3_rawIn_normDist_T_57 = in3_rawIn_fractIn_1[4] ? 4'h5 : _in3_rawIn_normDist_T_56; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in3_rawIn_normDist_T_58 = in3_rawIn_fractIn_1[5] ? 4'h4 : _in3_rawIn_normDist_T_57; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in3_rawIn_normDist_T_59 = in3_rawIn_fractIn_1[6] ? 4'h3 : _in3_rawIn_normDist_T_58; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in3_rawIn_normDist_T_60 = in3_rawIn_fractIn_1[7] ? 4'h2 : _in3_rawIn_normDist_T_59; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _in3_rawIn_normDist_T_61 = in3_rawIn_fractIn_1[8] ? 4'h1 : _in3_rawIn_normDist_T_60; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] in3_rawIn_normDist_1 = in3_rawIn_fractIn_1[9] ? 4'h0 : _in3_rawIn_normDist_T_61; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [24:0] _GEN_97 = {{15'd0}, in3_rawIn_fractIn_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [24:0] _in3_rawIn_subnormFract_T_2 = _GEN_97 << in3_rawIn_normDist_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:33]
  wire [9:0] in3_rawIn_subnormFract_1 = {_in3_rawIn_subnormFract_T_2[8:0], 1'h0}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_76 = {{2'd0}, in3_rawIn_normDist_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in3_rawIn_adjustedExp_T_5 = _GEN_76 ^ 6'h3f; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 55:18]
  wire [5:0] _in3_rawIn_adjustedExp_T_6 = in3_rawIn_isZeroExpIn_1 ? _in3_rawIn_adjustedExp_T_5 : {{1'd0},
    in3_rawIn_expIn_1}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 54:10]
  wire [1:0] _in3_rawIn_adjustedExp_T_7 = in3_rawIn_isZeroExpIn_1 ? 2'h2 : 2'h1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_77 = {{3'd0}, _in3_rawIn_adjustedExp_T_7}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [4:0] _in3_rawIn_adjustedExp_T_8 = 5'h10 | _GEN_77; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_78 = {{1'd0}, _in3_rawIn_adjustedExp_T_8}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire [5:0] in3_rawIn_adjustedExp_1 = _in3_rawIn_adjustedExp_T_6 + _GEN_78; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 57:9]
  wire  in3_rawIn_isZero_1 = in3_rawIn_isZeroExpIn_1 & in3_rawIn_isZeroFractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 60:30]
  wire  in3_rawIn_isSpecial_1 = in3_rawIn_adjustedExp_1[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 61:57]
  wire  in3_rawIn_1_isNaN = in3_rawIn_isSpecial_1 & ~in3_rawIn_isZeroFractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 64:28]
  wire [6:0] in3_rawIn_1_sExp = {1'b0,$signed(in3_rawIn_adjustedExp_1)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 68:42]
  wire  _in3_rawIn_out_sig_T_4 = ~in3_rawIn_isZero_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:19]
  wire [9:0] _in3_rawIn_out_sig_T_6 = in3_rawIn_isZeroExpIn_1 ? in3_rawIn_subnormFract_1 : in3_rawIn_fractIn_1; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:33]
  wire [11:0] in3_rawIn_1_sig = {1'h0,_in3_rawIn_out_sig_T_4,_in3_rawIn_out_sig_T_6}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromFN.scala 70:27]
  wire [2:0] _in3_T_13 = in3_rawIn_isZero_1 ? 3'h0 : in3_rawIn_1_sExp[5:3]; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:15]
  wire [2:0] _GEN_79 = {{2'd0}, in3_rawIn_1_isNaN}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [2:0] _in3_T_15 = _in3_T_13 | _GEN_79; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 48:76]
  wire [16:0] _in3_T_20 = {in3_rawIn_sign_1,_in3_T_15,in3_rawIn_1_sExp[2:0],in3_rawIn_1_sig[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/recFNFromFN.scala 50:41]
  wire  _in3_swizzledNaN_T_2 = &_in3_T_11[22:16]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 338:42]
  wire [32:0] in3_swizzledNaN = {_in3_T_11[32:29],_in3_swizzledNaN_T_2,_in3_T_11[27:24],_in3_T_20[15],_in3_T_11[22:16],
    _in3_T_20[16],_in3_T_20[14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 336:26]
  wire  _in3_T_22 = &_in3_T_11[31:29]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 249:56]
  wire [32:0] _io_out_bits_data_T_1 = dpu_io_out_bits_data; // @[generators/rocket-chip/src/main/scala/util/package.scala 39:76]
  wire [8:0] io_out_bits_data_unrecoded_rawIn_exp = _io_out_bits_data_T_1[31:23]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  io_out_bits_data_unrecoded_rawIn_isZero = io_out_bits_data_unrecoded_rawIn_exp[8:6] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  io_out_bits_data_unrecoded_rawIn_isSpecial = io_out_bits_data_unrecoded_rawIn_exp[8:7] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  io_out_bits_data_unrecoded_rawIn__isNaN = io_out_bits_data_unrecoded_rawIn_isSpecial &
    io_out_bits_data_unrecoded_rawIn_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  io_out_bits_data_unrecoded_rawIn__isInf = io_out_bits_data_unrecoded_rawIn_isSpecial & ~
    io_out_bits_data_unrecoded_rawIn_exp[6]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  io_out_bits_data_unrecoded_rawIn__sign = _io_out_bits_data_T_1[32]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [9:0] io_out_bits_data_unrecoded_rawIn__sExp = {1'b0,$signed(io_out_bits_data_unrecoded_rawIn_exp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _io_out_bits_data_unrecoded_rawIn_out_sig_T = ~io_out_bits_data_unrecoded_rawIn_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [24:0] io_out_bits_data_unrecoded_rawIn__sig = {1'h0,_io_out_bits_data_unrecoded_rawIn_out_sig_T,
    _io_out_bits_data_T_1[22:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  wire  io_out_bits_data_unrecoded_isSubnormal = $signed(io_out_bits_data_unrecoded_rawIn__sExp) < 10'sh82; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 51:38]
  wire [4:0] io_out_bits_data_unrecoded_denormShiftDist = 5'h1 - io_out_bits_data_unrecoded_rawIn__sExp[4:0]; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 52:35]
  wire [23:0] _io_out_bits_data_unrecoded_denormFract_T_1 = io_out_bits_data_unrecoded_rawIn__sig[24:1] >>
    io_out_bits_data_unrecoded_denormShiftDist; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 53:42]
  wire [22:0] io_out_bits_data_unrecoded_denormFract = _io_out_bits_data_unrecoded_denormFract_T_1[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 53:60]
  wire [7:0] _io_out_bits_data_unrecoded_expOut_T_2 = io_out_bits_data_unrecoded_rawIn__sExp[7:0] - 8'h81; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 58:45]
  wire [7:0] _io_out_bits_data_unrecoded_expOut_T_3 = io_out_bits_data_unrecoded_isSubnormal ? 8'h0 :
    _io_out_bits_data_unrecoded_expOut_T_2; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 56:16]
  wire [7:0] _io_out_bits_data_unrecoded_expOut_T_5 = io_out_bits_data_unrecoded_rawIn__isNaN |
    io_out_bits_data_unrecoded_rawIn__isInf ? 8'hff : 8'h0; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 60:21]
  wire [7:0] io_out_bits_data_unrecoded_expOut = _io_out_bits_data_unrecoded_expOut_T_3 |
    _io_out_bits_data_unrecoded_expOut_T_5; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 60:15]
  wire [22:0] _io_out_bits_data_unrecoded_fractOut_T_1 = io_out_bits_data_unrecoded_rawIn__isInf ? 23'h0 :
    io_out_bits_data_unrecoded_rawIn__sig[22:0]; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 64:20]
  wire [22:0] io_out_bits_data_unrecoded_fractOut = io_out_bits_data_unrecoded_isSubnormal ?
    io_out_bits_data_unrecoded_denormFract : _io_out_bits_data_unrecoded_fractOut_T_1; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 62:16]
  wire [31:0] io_out_bits_data_unrecoded = {io_out_bits_data_unrecoded_rawIn__sign,io_out_bits_data_unrecoded_expOut,
    io_out_bits_data_unrecoded_fractOut}; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 66:12]
  wire [16:0] io_out_bits_data_prevRecoded = {_io_out_bits_data_T_1[15],_io_out_bits_data_T_1[23],_io_out_bits_data_T_1[
    14:0]}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 441:28]
  wire [5:0] io_out_bits_data_prevUnrecoded_rawIn_exp = io_out_bits_data_prevRecoded[15:10]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 51:21]
  wire  io_out_bits_data_prevUnrecoded_rawIn_isZero = io_out_bits_data_prevUnrecoded_rawIn_exp[5:3] == 3'h0; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 52:53]
  wire  io_out_bits_data_prevUnrecoded_rawIn_isSpecial = io_out_bits_data_prevUnrecoded_rawIn_exp[5:4] == 2'h3; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 53:53]
  wire  io_out_bits_data_prevUnrecoded_rawIn__isNaN = io_out_bits_data_prevUnrecoded_rawIn_isSpecial &
    io_out_bits_data_prevUnrecoded_rawIn_exp[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 56:33]
  wire  io_out_bits_data_prevUnrecoded_rawIn__isInf = io_out_bits_data_prevUnrecoded_rawIn_isSpecial & ~
    io_out_bits_data_prevUnrecoded_rawIn_exp[3]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 57:33]
  wire  io_out_bits_data_prevUnrecoded_rawIn__sign = io_out_bits_data_prevRecoded[16]; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 59:25]
  wire [6:0] io_out_bits_data_prevUnrecoded_rawIn__sExp = {1'b0,$signed(io_out_bits_data_prevUnrecoded_rawIn_exp)}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 60:27]
  wire  _io_out_bits_data_prevUnrecoded_rawIn_out_sig_T = ~io_out_bits_data_prevUnrecoded_rawIn_isZero; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:35]
  wire [11:0] io_out_bits_data_prevUnrecoded_rawIn__sig = {1'h0,_io_out_bits_data_prevUnrecoded_rawIn_out_sig_T,
    io_out_bits_data_prevRecoded[9:0]}; // @[generators/hardfloat/hardfloat/src/main/scala/rawFloatFromRecFN.scala 61:44]
  wire  io_out_bits_data_prevUnrecoded_isSubnormal = $signed(io_out_bits_data_prevUnrecoded_rawIn__sExp) < 7'sh12; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 51:38]
  wire [3:0] io_out_bits_data_prevUnrecoded_denormShiftDist = 4'h1 - io_out_bits_data_prevUnrecoded_rawIn__sExp[3:0]; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 52:35]
  wire [10:0] _io_out_bits_data_prevUnrecoded_denormFract_T_1 = io_out_bits_data_prevUnrecoded_rawIn__sig[11:1] >>
    io_out_bits_data_prevUnrecoded_denormShiftDist; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 53:42]
  wire [9:0] io_out_bits_data_prevUnrecoded_denormFract = _io_out_bits_data_prevUnrecoded_denormFract_T_1[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 53:60]
  wire [4:0] _io_out_bits_data_prevUnrecoded_expOut_T_2 = io_out_bits_data_prevUnrecoded_rawIn__sExp[4:0] - 5'h11; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 58:45]
  wire [4:0] _io_out_bits_data_prevUnrecoded_expOut_T_3 = io_out_bits_data_prevUnrecoded_isSubnormal ? 5'h0 :
    _io_out_bits_data_prevUnrecoded_expOut_T_2; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 56:16]
  wire [4:0] _io_out_bits_data_prevUnrecoded_expOut_T_5 = io_out_bits_data_prevUnrecoded_rawIn__isNaN |
    io_out_bits_data_prevUnrecoded_rawIn__isInf ? 5'h1f : 5'h0; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 60:21]
  wire [4:0] io_out_bits_data_prevUnrecoded_expOut = _io_out_bits_data_prevUnrecoded_expOut_T_3 |
    _io_out_bits_data_prevUnrecoded_expOut_T_5; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 60:15]
  wire [9:0] _io_out_bits_data_prevUnrecoded_fractOut_T_1 = io_out_bits_data_prevUnrecoded_rawIn__isInf ? 10'h0 :
    io_out_bits_data_prevUnrecoded_rawIn__sig[9:0]; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 64:20]
  wire [9:0] io_out_bits_data_prevUnrecoded_fractOut = io_out_bits_data_prevUnrecoded_isSubnormal ?
    io_out_bits_data_prevUnrecoded_denormFract : _io_out_bits_data_prevUnrecoded_fractOut_T_1; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 62:16]
  wire [15:0] io_out_bits_data_prevUnrecoded = {io_out_bits_data_prevUnrecoded_rawIn__sign,
    io_out_bits_data_prevUnrecoded_expOut,io_out_bits_data_prevUnrecoded_fractOut}; // @[generators/hardfloat/hardfloat/src/main/scala/fNFromRecFN.scala 66:12]
  wire  _io_out_bits_data_T_4 = &_io_out_bits_data_T_1[31:29]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 249:56]
  wire [15:0] _io_out_bits_data_T_6 = _io_out_bits_data_T_4 ? io_out_bits_data_prevUnrecoded :
    io_out_bits_data_unrecoded[15:0]; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 446:44]
  DotProductPipe dpu ( // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 44:19]
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
  assign io_out_valid = dpu_io_out_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 51:16]
  assign io_out_bits_data = {io_out_bits_data_unrecoded[31:16],_io_out_bits_data_T_6}; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 446:10]
  assign dpu_clock = clock;
  assign dpu_reset = reset;
  assign dpu_io_in_valid = io_in_valid; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 45:19]
  assign dpu_io_in_bits_a_0 = in1_floats_0 | _in1_T_24; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:26]
  assign dpu_io_in_bits_a_1 = in1_floats_0_1 | _in1_T_49; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:26]
  assign dpu_io_in_bits_a_2 = in1_floats_0_2 | _in1_T_74; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:26]
  assign dpu_io_in_bits_a_3 = in1_floats_0_3 | _in1_T_99; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:26]
  assign dpu_io_in_bits_b_0 = in2_floats_0 | _in2_T_24; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:26]
  assign dpu_io_in_bits_b_1 = in2_floats_0_1 | _in2_T_49; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:26]
  assign dpu_io_in_bits_b_2 = in2_floats_0_2 | _in2_T_74; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:26]
  assign dpu_io_in_bits_b_3 = in2_floats_0_3 | _in2_T_99; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 372:26]
  assign dpu_io_in_bits_c = _in3_T_22 ? in3_swizzledNaN : _in3_T_11; // @[generators/rocket-chip/src/main/scala/tile/FPU.scala 344:8]
  assign dpu_io_stall = io_stall; // @[generators/radiance/src/main/scala/radiance/core/TensorDPU.scala 49:16]
endmodule
