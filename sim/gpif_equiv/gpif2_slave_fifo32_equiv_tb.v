// Equivalence test for the 16.8 GPIF change (LibreSDRB220 doc 13 / handoff 2026-10-06-gpif-iob-fix):
// gpif2_slave_fifo32_ref (the 16.7 module, from git) and gpif2_slave_fifo32 (with the IOB pin flops) get the
// same random stimulus, and every pin and AXI output is compared on every cycle from the first reset on,
// through several mid-run resets. (Before the first reset xsim holds uninitialised registers at X where the
// FPGA has INIT 0; the power-up values are checked on the synthesized netlist instead, see the handoff.) Also checks that the new tristate flops equal ~sloe and that no data
// pin ever sees FPGA and FX3 driving at once (X on the bus). Run with run.sh.
`timescale 1ns/1ps
module gpif2_slave_fifo32_equiv_tb;
  parameter CYCLES = 400000;
  parameter SEED   = 1;

  reg clk = 0; always #5 clk = ~clk;          // gpif_clk = bus_clk = 100 MHz, as in libresdr_b210.v
  reg rst = 0;

  // FX3 side: flags and the data it drives while SLOE# (sloe) is low
  reg [1:0]  gpif_ctl = 2'b00;
  reg [31:0] fx3_data = 0;
  // AXI stimulus
  reg [63:0] rx_tdata = 0, resp_tdata = 0;
  reg        rx_tlast = 0, rx_tvalid = 0, resp_tlast = 0, resp_tvalid = 0;
  reg        tx_tready = 0, ctrl_tready = 0;

  wire [31:0] bus_r, bus_n;
  wire        sloe_r, slrd_r, slwr_r, slcs_r, pktend_r, sloe_n, slrd_n, slwr_n, slcs_n, pktend_n;
  wire [1:0]  fifoadr_r, fifoadr_n;
  wire [63:0] tx_tdata_r, ctrl_tdata_r, tx_tdata_n, ctrl_tdata_n;
  wire        tx_tlast_r, tx_tvalid_r, ctrl_tlast_r, ctrl_tvalid_r, rx_tready_r, resp_tready_r;
  wire        tx_tlast_n, tx_tvalid_n, ctrl_tlast_n, ctrl_tvalid_n, rx_tready_n, resp_tready_n;

  assign bus_r = sloe_r ? 32'bz : fx3_data;     // FX3 drives when SLOE# is asserted (low)
  assign bus_n = sloe_n ? 32'bz : fx3_data;

  gpif2_slave_fifo32_ref #(.DATA_RX_FIFO_SIZE(14), .DATA_TX_FIFO_SIZE(14)) dut_r (
    .gpif_clk(clk), .gpif_rst(rst), .gpif_enb(1'b1), .gpif_d(bus_r), .gpif_ctl(gpif_ctl),
    .sloe(sloe_r), .slrd(slrd_r), .slwr(slwr_r), .slcs(slcs_r), .pktend(pktend_r), .fifoadr(fifoadr_r),
    .fifo_clk(clk), .fifo_rst(rst),
    .tx_tdata(tx_tdata_r), .tx_tlast(tx_tlast_r), .tx_tvalid(tx_tvalid_r), .tx_tready(tx_tready),
    .rx_tdata(rx_tdata), .rx_tlast(rx_tlast), .rx_tvalid(rx_tvalid), .rx_tready(rx_tready_r),
    .ctrl_tdata(ctrl_tdata_r), .ctrl_tlast(ctrl_tlast_r), .ctrl_tvalid(ctrl_tvalid_r), .ctrl_tready(ctrl_tready),
    .resp_tdata(resp_tdata), .resp_tlast(resp_tlast), .resp_tvalid(resp_tvalid), .resp_tready(resp_tready_r));

  gpif2_slave_fifo32 #(.DATA_RX_FIFO_SIZE(14), .DATA_TX_FIFO_SIZE(14)) dut_n (
    .gpif_clk(clk), .gpif_rst(rst), .gpif_enb(1'b1), .gpif_d(bus_n), .gpif_ctl(gpif_ctl),
    .sloe(sloe_n), .slrd(slrd_n), .slwr(slwr_n), .slcs(slcs_n), .pktend(pktend_n), .fifoadr(fifoadr_n),
    .fifo_clk(clk), .fifo_rst(rst),
    .tx_tdata(tx_tdata_n), .tx_tlast(tx_tlast_n), .tx_tvalid(tx_tvalid_n), .tx_tready(tx_tready),
    .rx_tdata(rx_tdata), .rx_tlast(rx_tlast), .rx_tvalid(rx_tvalid), .rx_tready(rx_tready_n),
    .ctrl_tdata(ctrl_tdata_n), .ctrl_tlast(ctrl_tlast_n), .ctrl_tvalid(ctrl_tvalid_n), .ctrl_tready(ctrl_tready),
    .resp_tdata(resp_tdata), .resp_tlast(resp_tlast), .resp_tvalid(resp_tvalid), .resp_tready(resp_tready_n));

  wire [255:0] sig_r = {sloe_r, slrd_r, slwr_r, slcs_r, pktend_r, fifoadr_r, bus_r, tx_tdata_r, tx_tlast_r, tx_tvalid_r,
                        ctrl_tdata_r, ctrl_tlast_r, ctrl_tvalid_r, rx_tready_r, resp_tready_r};
  wire [255:0] sig_n = {sloe_n, slrd_n, slwr_n, slcs_n, pktend_n, fifoadr_n, bus_n, tx_tdata_n, tx_tlast_n, tx_tvalid_n,
                        ctrl_tdata_n, ctrl_tlast_n, ctrl_tvalid_n, rx_tready_n, resp_tready_n};

  integer cyc = 0, errors = 0, seed;
  integer n_read = 0, n_write = 0, n_pktend = 0, n_tx = 0, n_ctrl = 0, n_rx = 0, n_resp = 0, n_turn = 0;
  integer rx_left = 0, resp_left = 0, flag_hold = 0;
  reg sloe_prev = 0, armed = 0;

  // Compare after the clock edge has settled
  always @(posedge clk) if (rst) armed <= 1;
  always @(negedge clk) if (armed) begin
    cyc = cyc + 1;
    if (sig_r !== sig_n) begin
      errors = errors + 1;
      if (errors <= 10) $display("MISMATCH cyc %0d rst %b: ref %h new %h", cyc, rst, sig_r, sig_n);
    end
    if (dut_n.gpif_t !== {32{~sloe_r}}) begin
      errors = errors + 1;
      if (errors <= 10) $display("TRISTATE cyc %0d: gpif_t %h but ~sloe_ref = %b", cyc, dut_n.gpif_t, ~sloe_r);
    end
    if (^bus_r === 1'bx || ^bus_n === 1'bx) begin
      errors = errors + 1;
      if (errors <= 10) $display("BUS X/Z cyc %0d: ref %h new %h (contention or undriven)", cyc, bus_r, bus_n);
    end
    if (!rst) begin
      n_read   = n_read   + (sloe_r == 0);
      n_write  = n_write  + (slwr_r == 0);
      n_pktend = n_pktend + (pktend_r == 0);
      n_tx     = n_tx     + (tx_tvalid_r && tx_tready);
      n_ctrl   = n_ctrl   + (ctrl_tvalid_r && ctrl_tready);
      n_rx     = n_rx     + (rx_tvalid && rx_tready_r);
      n_resp   = n_resp   + (resp_tvalid && resp_tready_r);
      n_turn   = n_turn   + (sloe_r != sloe_prev);
    end
    sloe_prev = sloe_r;
  end

  parameter DEBUG = 0;
  always @(negedge clk) if (DEBUG && armed && cyc < 400 && cyc % 10 == 0)
    $display("dbg cyc %0d state %0d fifoadr %0d local_ready %b read_go %b write_go %b ctl %b rdy1 %b wm1 %b data_rx_tvalid %b ctrl_rx_tvalid %b tx_space %b",
             cyc, dut_r.state, dut_r.fifoadr, dut_r.local_fifo_ready, dut_r.read_ready_go, dut_r.write_ready_go, gpif_ctl,
             dut_r.fx3_ready1, dut_r.fx3_wmark1, dut_r.data_rx_tvalid, dut_r.ctrl_rx_tvalid, dut_r.data_tx_fifo_has_space);

  // Stimulus, driven just after the rising edge (AXI rules: hold tdata/tlast while tvalid && !tready)
  always @(posedge clk) begin
    #1;
    fx3_data <= $unsigned($random(seed));
    if (flag_hold == 0) begin
      gpif_ctl  <= $unsigned($random(seed));                 // ready/watermark change now and then
      flag_hold = 2 + ($unsigned($random(seed)) % 60);
    end else flag_hold = flag_hold - 1;
    tx_tready   <= ($unsigned($random(seed)) % 8) != 0;
    ctrl_tready <= ($unsigned($random(seed)) % 4) != 0;
    if (!rx_tvalid || rx_tready_r) begin
      if (rx_left == 0) rx_left = 1 + ($unsigned($random(seed)) % 400);
      rx_tvalid <= ($unsigned($random(seed)) % 10) < 7;
      rx_tdata  <= {$unsigned($random(seed)), $unsigned($random(seed))};
      rx_tlast  <= (rx_left == 1);
      if (rx_tvalid && rx_tready_r) rx_left = rx_left - 1;
    end
    if (!resp_tvalid || resp_tready_r) begin
      if (resp_left == 0) resp_left = 2 + ($unsigned($random(seed)) % 4);
      resp_tvalid <= ($unsigned($random(seed)) % 20) == 0;
      resp_tdata  <= {$unsigned($random(seed)), $unsigned($random(seed))};
      resp_tlast  <= (resp_left == 1);
      if (resp_tvalid && resp_tready_r) resp_left = resp_left - 1;
    end
  end

  initial begin
    seed = SEED;
    repeat (50) @(posedge clk);                   // power-up: compare before any reset
    rst = 1; repeat (20) @(posedge clk); rst = 0;
    repeat (CYCLES / 3) @(posedge clk);
    rst = 1; repeat (7) @(posedge clk); rst = 0;   // mid-run resets, like a UHD session restart
    repeat (CYCLES / 3) @(posedge clk);
    rst = 1; repeat (3) @(posedge clk); rst = 0;
    repeat (CYCLES / 3) @(posedge clk);
    $display("cycles %0d | reads(sloe=0) %0d, writes(slwr=0) %0d, pktend %0d, bus turnarounds %0d | AXI beats tx %0d ctrl %0d rx %0d resp %0d",
             cyc, n_read, n_write, n_pktend, n_turn, n_tx, n_ctrl, n_rx, n_resp);
    if (errors == 0 && n_read > 1000 && n_write > 1000 && n_turn > 100) $display("EQUIVALENCE PASS");
    else $display("EQUIVALENCE FAIL: %0d mismatches (or too little activity)", errors);
    $finish;
  end
endmodule
