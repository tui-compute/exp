// ============================================================
// axi_stream_to_dispatcher_writer.sv - AXI-Stream to basic_stream_if
// ============================================================
`timescale 1ns/1ps
module axi_stream_to_dispatcher_writer #(
  parameter DATA_WIDTH = 32
)(
  input  logic clk,
  input  logic rst,

  // AXI-Stream input
  input  logic                   s_axis_tvalid,
  output logic                   s_axis_tready,
  input  logic [DATA_WIDTH-1:0] s_axis_tdata,

  // basic_stream_if output
  basic_stream_if.source write_stream
);
  logic sending;
  logic [DATA_WIDTH-1:0] buffer;

  assign write_stream.valid = sending;
  assign write_stream.data  = buffer;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      sending <= 0;
      s_axis_tready <= 1;
    end else begin
      if (s_axis_tvalid && s_axis_tready) begin
        buffer <= s_axis_tdata;
        sending <= 1;
        s_axis_tready <= 0;
      end else if (sending && write_stream.ready) begin
        sending <= 0;
        s_axis_tready <= 1;
      end
    end
  end
endmodule

