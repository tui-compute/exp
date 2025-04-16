// ============================================================
// dispatcher_debug_if.sv - Debug interface for observation and control
// ============================================================
`timescale 1ns/1ps
interface dispatcher_debug_if #(
  parameter NUM_BANKS      = 4,
  parameter PTR_WIDTH      = 8,
  parameter STRIDE_WIDTH   = 3,
  parameter BANK_SEL_WIDTH = $clog2(NUM_BANKS)
);
  // Status signals
  logic [BANK_SEL_WIDTH-1:0] bank_sel;
  logic [STRIDE_WIDTH-1:0]   data_count;
  logic [PTR_WIDTH-1:0]      wr_ptr [NUM_BANKS];
  logic [PTR_WIDTH-1:0]      rd_ptr [NUM_BANKS];

  // Debug control
  logic reset_wr_ptr;
  logic reset_rd_ptr;
  logic stop_writes;
  logic continue_writes;
  logic step_write;

  modport monitor (
    input  bank_sel,
    input  data_count,
    input  wr_ptr,
    input  rd_ptr
  );

  modport control (
    output reset_wr_ptr,
    output reset_rd_ptr,
    output stop_writes,
    output continue_writes,
    output step_write
  );
endinterface

