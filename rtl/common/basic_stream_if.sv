// ============================================================
// basic_stream_if.sv - Simple streaming interface
// ============================================================
`timescale 1ns/1ps
interface basic_stream_if #(parameter DATA_WIDTH = 32);
  logic valid;
  logic ready;
  logic [DATA_WIDTH-1:0] data;

  modport source (
    output valid,
    input  ready,
    output data
  );

  modport sink (
    input  valid,
    output ready,
    input  data
  );
endinterface

