// Behavioural stand-ins for the Xilinx FIFO Generator IPs used by axi_fifo_2clk (first-word fall-through,
// independent clocks), for the gpif2_slave_fifo32 equivalence test only. Both modules under test share these,
// so any deterministic model will do; this one is not cycle-accurate to the IP's clock-crossing latency.
`timescale 1ns/1ps
module fifo_2clk_model #(parameter W = 72, parameter AW = 4) (
  input rst, input wr_clk, input [W-1:0] din, input wr_en, output full,
  input rd_clk, output [W-1:0] dout, input rd_en, output empty);
  reg [W-1:0] mem [0:(1<<AW)-1];
  reg [AW:0] wp = 0, rp = 0;
  assign full  = (wp - rp) == (1 << AW);
  assign empty = (wp == rp);
  assign dout  = mem[rp[AW-1:0]];
  always @(posedge wr_clk or posedge rst)
    if (rst) wp <= 0; else if (wr_en && !full) begin mem[wp[AW-1:0]] <= din; wp <= wp + 1'b1; end
  always @(posedge rd_clk or posedge rst)
    if (rst) rp <= 0; else if (rd_en && !empty) rp <= rp + 1'b1;
endmodule

module fifo_short_2clk (input rst, input wr_clk, input [71:0] din, input wr_en, output full, output [5:0] wr_data_count,
  input rd_clk, output [71:0] dout, input rd_en, output empty, output [5:0] rd_data_count);
  fifo_2clk_model #(.W(72), .AW(5)) m (.rst(rst), .wr_clk(wr_clk), .din(din), .wr_en(wr_en), .full(full),
    .rd_clk(rd_clk), .dout(dout), .rd_en(rd_en), .empty(empty));
  assign wr_data_count = 0; assign rd_data_count = 0;
endmodule

module fifo_4k_2clk (input rst, input wr_clk, input [71:0] din, input wr_en, output full, output [9:0] wr_data_count,
  input rd_clk, output [71:0] dout, input rd_en, output empty, output [9:0] rd_data_count,
  output wr_rst_busy, output rd_rst_busy);
  fifo_2clk_model #(.W(72), .AW(9)) m (.rst(rst), .wr_clk(wr_clk), .din(din), .wr_en(wr_en), .full(full),
    .rd_clk(rd_clk), .dout(dout), .rd_en(rd_en), .empty(empty));
  assign wr_data_count = 0; assign rd_data_count = 0; assign wr_rst_busy = 0; assign rd_rst_busy = 0;
endmodule
