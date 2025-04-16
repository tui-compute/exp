// ============================================================
// collector.sv - Stream collector with circular input buffers
// ============================================================

module collector #(
  parameter NUM_BANKS   = 2,
  parameter DATA_WIDTH  = 32,
  parameter DEPTH       = 64,
  parameter STRIDE      = 8
)(
  input  logic clk,
  input  logic rst,

  basic_stream_if.sink   in_streams [NUM_BANKS],
  basic_stream_if.source out_stream
);

  localparam PTR_WIDTH      = $clog2(DEPTH);
  localparam BANK_SEL_WIDTH = $clog2(NUM_BANKS);
  localparam STRIDE_WIDTH   = $clog2(STRIDE);

  logic [DATA_WIDTH-1:0] buffer [NUM_BANKS][DEPTH];
  logic [PTR_WIDTH-1:0]  wr_ptr [NUM_BANKS];
  logic [PTR_WIDTH-1:0]  rd_ptr [NUM_BANKS];

  logic [BANK_SEL_WIDTH-1:0] current_bank;
  logic [STRIDE_WIDTH-1:0]   data_count;

  // Input buffering using generate block
  genvar i;
  generate
    for (i = 0; i < NUM_BANKS; i++) begin : input_buffering
      always_ff @(posedge clk) begin
        if (rst) begin
          wr_ptr[i] <= 0;
        end else begin
          in_streams[i].ready <= 1;
          if (in_streams[i].valid && in_streams[i].ready) begin
            buffer[i][wr_ptr[i]] <= in_streams[i].data;
            wr_ptr[i] <= wr_ptr[i] + 1;
          end
        end
      end
    end
  endgenerate

  // Output logic (round-robin, STRIDE from each buffer)
  always_ff @(posedge clk) begin
    if (rst) begin
      for (int i = 0; i < NUM_BANKS; i++) begin
        rd_ptr[i] <= 0;
      end
      data_count <= 0;
      current_bank <= 0;
      out_stream.valid <= 0;
    end else begin
      out_stream.valid <= 0;
      if (wr_ptr[current_bank] != rd_ptr[current_bank]) begin
        out_stream.data <= buffer[current_bank][rd_ptr[current_bank]];
        out_stream.valid <= 1;
        if (out_stream.ready) begin
          rd_ptr[current_bank] <= rd_ptr[current_bank] + 1;
          if (data_count == STRIDE - 1) begin
            data_count <= 0;
            current_bank <= (current_bank == NUM_BANKS - 1) ? 0 : current_bank + 1;
          end else begin
            data_count <= data_count + 1;
          end
        end
      end
    end
  end
endmodule
