`include "SimDefaults.vh"

import "DPI-C" function void memfuzz_init(
  input longint num_lanes
);

// Make sure to sync the parameters for:
// (1) import "DPI-C" declaration
// (2) C function declaration
// (3) DPI function calls inside initial/always blocks
import "DPI-C" function void memfuzz_generate
(
  input  bit     vec_a_ready[`MAX_NUM_LANES],
  output bit     vec_a_valid[`MAX_NUM_LANES],
  output longint vec_a_address[`MAX_NUM_LANES],
  output bit     vec_d_ready[`MAX_NUM_LANES],
  output bit     finished
);

module SimMemFuzzer #(parameter NUM_LANES = 4) (
  input clock,
  input reset,

  input  [NUM_LANES-1:0]                       a_ready,
  output [NUM_LANES-1:0]                       a_valid,
  output [`SIMMEM_DATA_WIDTH*NUM_LANES-1:0]    a_address,
  output [NUM_LANES-1:0]                       a_is_store,
  output [`SIMMEM_LOGSIZE_WIDTH*NUM_LANES-1:0] a_size,
  output [`SIMMEM_DATA_WIDTH*NUM_LANES-1:0]    a_data,
  output [NUM_LANES-1:0]                       d_ready,
  output                                       finished
);
  // need to be in ascending order to match with C indexing
  // C array sizes are static, so need to use MAX_NUM_LANES
  bit                      __out_a_ready [0:`MAX_NUM_LANES-1];
  bit                      __in_a_valid   [0:`MAX_NUM_LANES-1];
  longint                  __in_a_address [0:`MAX_NUM_LANES-1];
  bit                      __in_a_is_store [0:`MAX_NUM_LANES-1];
  reg [`SIMMEM_LOGSIZE_WIDTH-1:0] __in_a_size [0:`MAX_NUM_LANES-1];
  longint                  __in_a_data [0:`MAX_NUM_LANES-1];
  bit                      __in_d_ready   [0:`MAX_NUM_LANES-1];
  bit                      __in_finished;

  genvar g;
  generate
    for (g = 0; g < NUM_LANES; g = g + 1) begin
      assign __out_a_ready[g] = a_ready[g];
      assign a_valid[g] = __in_a_valid[g];
      assign a_address[`SIMMEM_DATA_WIDTH*g +: `SIMMEM_DATA_WIDTH]  = __in_a_address[g];

      assign a_is_store[g] = __in_a_is_store[g];
      assign a_size[`SIMMEM_LOGSIZE_WIDTH*g +: `SIMMEM_LOGSIZE_WIDTH] = __in_a_size[g];
      assign a_data[`SIMMEM_DATA_WIDTH*g +: `SIMMEM_DATA_WIDTH] = __in_a_data[g];
    end
  endgenerate
  assign finished = __in_finished;

  initial begin
    memfuzz_init(NUM_LANES);
  end

  // negedge is important here; the DPI logic is essentially functioning as
  // a combinational logic, so we want to reflect the signal change from DPI
  // at the *current* cycle, not the next.
  always @(negedge clock) begin
    if (reset) begin
      for (integer tid = 0; tid < NUM_LANES; tid = tid + 1) begin
        __in_a_valid[tid]    = 1'b0;
        __in_a_address[tid]  = `SIMMEM_DATA_WIDTH'b0;

        __in_a_is_store[tid] = 1'b0;
        __in_a_size[tid]     = `SIMMEM_LOGSIZE_WIDTH'b0;
        __in_a_data[tid]     = `SIMMEM_DATA_WIDTH'b0;
        __in_d_ready[tid]    = 1'b0;
      end
      __in_finished = 1'b0;
    end else begin
      memfuzz_generate(
        __out_a_ready,
        __in_a_valid,
        __in_a_address,
        __in_d_ready,
        __in_finished
      );
      for (integer tid = 0; tid < NUM_LANES; tid = tid + 1) begin
        $display("verilog: %04d valid[%d]=%d, address[%d]=%d",
          $time, tid, __in_a_valid[tid], tid, __in_a_address[tid]);
      end

      if ($time >= 32'd200000) begin
        $finish;
      end
    end
  end
endmodule
