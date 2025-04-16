// ============================================================
// simple_fixed_latency_pe.sv - Dummy Processing Element with configurable latency
// Each stage increments data
// ============================================================

module simple_fixed_latency_pe #(
  parameter int DATA_WIDTH = 32,
  parameter int LATENCY    = 2
)(
  input  logic clk,
  input  logic rst,

  basic_stream_if.sink   in_stream,
  basic_stream_if.source out_stream
);

  typedef struct packed {
    logic valid;
    logic [DATA_WIDTH-1:0] data;
  } pipeline_stage_t;

  pipeline_stage_t pipe [LATENCY+1];

  // Initial stage from input
  always_ff @(posedge clk) begin
    if (rst) begin
      pipe[0].valid <= 0;
      pipe[0].data  <= '0;
    end else begin
      if (in_stream.valid && in_stream.ready) begin
        pipe[0].valid <= 1;
        pipe[0].data  <= in_stream.data + 1;
      end else begin
        pipe[0].valid <= 0;
      end
    end
  end
     
  // Generated pipeline stages
  genvar i;
  generate
    for (i = 1; i <= LATENCY; i++) begin : pipeline
      always_ff @(posedge clk) begin
        if (rst) begin
          pipe[i].valid <= 0;
          pipe[i].data  <= '0;
        end else begin
          pipe[i].valid <= pipe[i-1].valid;
          pipe[i].data  <= pipe[i-1].data + 1;
        end
      end
    end
  endgenerate

  assign in_stream.ready  = !pipe[0].valid || out_stream.ready;
  assign out_stream.valid = pipe[LATENCY].valid;
  assign out_stream.data  = pipe[LATENCY].data;

endmodule
