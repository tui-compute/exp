// ============================================================
// dispatcher.sv - Stream dispatcher (without debug interface)
// ============================================================

module dispatcher #(
  parameter NUM_BANKS   = 2,
  parameter DEPTH       = 64,
  parameter DATA_WIDTH  = 32,
  parameter STRIDE      = 8
)(
  input  logic clk,
  input  logic rst,

  basic_stream_if.sink   write_stream,
  basic_stream_if.source read_stream [NUM_BANKS]
);

  localparam PTR_WIDTH      = $clog2(DEPTH);
  localparam BANK_SEL_WIDTH = $clog2(NUM_BANKS);
  localparam STRIDE_WIDTH   = $clog2(STRIDE);

  logic [DATA_WIDTH-1:0] mem [NUM_BANKS][DEPTH];
  logic [PTR_WIDTH-1:0]  wr_ptr [NUM_BANKS];
  logic [PTR_WIDTH-1:0]  rd_ptr [NUM_BANKS];

  logic empty [NUM_BANKS];
  
  logic [BANK_SEL_WIDTH-1:0] bank_sel;
  logic [STRIDE_WIDTH-1:0]   data_count;

  // Write logic
  always_ff @(posedge clk) begin
    if (rst) begin
      for (int i = 0; i < NUM_BANKS; i++) begin
        wr_ptr[i] <= 0;
      end
      data_count <= 0;
      bank_sel   <= 0;
    end else begin
      if (write_stream.valid && write_stream.ready) begin
        mem[bank_sel][wr_ptr[bank_sel]] <= write_stream.data;
        wr_ptr[bank_sel] <= wr_ptr[bank_sel] + 1;

        if (data_count == STRIDE - 1) begin
          data_count <= 0;
          bank_sel <= (bank_sel == NUM_BANKS - 1) ? 0 : bank_sel + 1;
        end else begin
          data_count <= data_count + 1;
        end
      end
    end
  end

  assign write_stream.ready = 1;
    
  // Read logic
  genvar b;
  generate
    for (b = 0; b < NUM_BANKS; b++) begin : read_ports
      always_ff @(posedge clk) begin
        if (rst) begin
          rd_ptr[b] <= 0;
        end else begin
          if (~empty[b]) begin                     
              if (read_stream[b].valid && read_stream[b].ready)
                rd_ptr[b] <= rd_ptr[b] + 1;
           end else begin
                // nop
           end
        end
    
      end
    
      assign read_stream[b].valid   = (~empty[b]);
        
      assign read_stream[b].data    = mem[b][rd_ptr[b]];
    
    end
  endgenerate

  // Generate empty
  genvar e;
  generate
    for (e = 0; e < NUM_BANKS; e++) begin : empty_gen
        assign empty[e] = (rd_ptr[e] == wr_ptr[e]) ;
    end
  endgenerate
   
endmodule
