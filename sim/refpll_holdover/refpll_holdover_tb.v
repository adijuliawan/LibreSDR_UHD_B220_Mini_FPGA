// Reference-loop holdover test (build 16.9): b205_ref_pll against a VCTCXO model and an ideal 10 MHz reference.
//
// The PFD runs at PFD Hz instead of 10 Hz, so one PFD period is 20000 clk cycles instead of 20M. The VCTCXO pull
// per DAC step and the lock tolerance are scaled by the same factor (SCALE = PFD/10), so the loop sees the same
// phase and frequency error counts per PFD period as on hardware: the dynamics match in PFD periods, and the
// DAC words match. "ppb" below means hardware-equivalent ppb (0.27 ppb per DAC step).
//
// Scenarios (doc 13 §5.12, handoff 2026-10-06-refloop-holdover-fix.md §5):
//   a  cold start from dac_def locks
//   b  UHD session open (clocks stop, then reset; por stays low): no dac_def write, narrow-band restart, no swing
//   e  reference removed for 50 PFD periods while the VCTCXO drifts: DAC holds the last locked word
//   f  VCTCXO far off at a session open: ld2x drops narrow-band, wide-band re-acquires
//   d  dac_def written while locked: hold_valid clears, the next session open starts from the new dac_def
//   c  por: the next start uses dac_def
// OLD=1 runs b205_ref_pll at 16.8 (c6b5e4c, made by run.sh) through the same sequence, for the before numbers.
`timescale 1ns/1fs
module refpll_holdover_tb;
    parameter OLD = 0;
    parameter PFD = 10000;
    localparam SCALE = PFD / 10;
    localparam real PFD_NS = 1.0e9 / PFD;
    localparam real PULL = 0.27e-9 * SCALE;    // fractional frequency per 16-bit DAC step
    localparam [15:0] DAC_DEF0 = 16'hA000;     // far from the VCTCXO centre, so a dac_def write is visible

    reg clk = 0, refclk = 0, ref = 0;
    reg clk_run = 1, ref_run = 1;
    reg reset = 1, por = 1;
    reg [15:0] dac_def = DAC_DEF0;
    real center = 45168.0;                     // 16'hB070: DAC word with zero frequency error
    reg [15:0] dac_reg = 16'h7fff;             // word in the DAC chip (updated at the end of each SPI frame)
    real frac;
    always @* frac = PULL * ($itor(dac_reg & 16'hfff0) - center);   // 12-bit DAC, as DAC_RES_BITS says

    // VCTCXO: refclk 40 MHz, clk = 5x through the main MMCM. Edges are scheduled on absolute times so the
    // frequency is exact to the fs rounding. clk_run models the MMCM held in reset (outputs stopped).
    real tc = 10.0, tr = 10.7, tref = 3.0;   // refclk edges 0.7 ns after clk edges (MMCM phase)
    initial forever begin tc = tc + 2.5 / (1.0 + frac); #(tc - $realtime); if (clk_run) clk = ~clk; end
    initial forever begin tr = tr + 12.5 / (1.0 + frac); #(tr - $realtime); if (clk_run) refclk = ~refclk; end
    initial forever begin tref = tref + 50.0; #(tref - $realtime); if (ref_run) ref = ~ref; else ref = 0; end

    wire [63:0] st;
    wire sclk, mosi, sync_n, lpps, locked_o;
    wire [31:0] dac_now, phase_err_now;
    wire [4:0] dbg;
    generate if (OLD) begin : g
        b205_ref_pll_old #(.PFD_FREQ_10MHZ(PFD), .LOCK_TOLERANCE_PPM(SCALE)) dut (
            .reset(reset), .clk(clk), .refclk(refclk), .ref(ref), .dac_def(dac_def), .force_fine(1'b0),
            .dac_now(dac_now), .phase_err_now(phase_err_now), .status(st), .lpps(lpps), .locked(locked_o),
            .dbg(dbg), .sclk(sclk), .mosi(mosi), .sync_n(sync_n));
        wire [15:0] hold_word = st[15:0];   // 16.8 has no held word: use the loop word
    end else begin : g
        b205_ref_pll #(.PFD_FREQ_10MHZ(PFD), .LOCK_TOLERANCE_PPM(SCALE)) dut (
            .reset(reset), .por(por), .clk(clk), .refclk(refclk), .ref(ref), .dac_def(dac_def), .force_fine(1'b0),
            .dac_now(dac_now), .phase_err_now(phase_err_now), .status(st), .lpps(lpps), .locked(locked_o),
            .dbg(dbg), .sclk(sclk), .mosi(mosi), .sync_n(sync_n));
        wire [15:0] hold_word = dut.hold_word;
    end endgenerate

    // locked and refclk_div have no initial value in the RTL; the FPGA powers them up at 0 (Vivado's default
    // INIT). Without this, refclk_div stays X in simulation and the N divider (phase detector) never runs.
    initial begin g.dut.locked = 1'b0; g.dut.refclk_div = 1'b0; end

    wire [15:0] daco = st[15:0];
    wire [8:0] lock_counter = st[40:32];
    wire locked = st[48], hold_valid = st[53], nb = st[54];

    // DAC chip: takes the word at the end of each SPI frame (SYNCH state)
    wire dac_frame_end = g.dut.dac.sena && (g.dut.dac.scnt == 5'b10011);
    always @(posedge clk) if (dac_frame_end) dac_reg <= g.dut.dac.ldat;

    // Window monitor
    reg mon = 0;
    integer daco_min, daco_max, dacw_min, dacw_max, n_def_writes, n_ld2x, nb_seen;
    reg [15:0] def_mask;
    task mon_start; begin
        daco_min = 65535; daco_max = 0; dacw_min = 65535; dacw_max = 0; n_def_writes = 0; n_ld2x = 0; nb_seen = 0;
        def_mask = dac_def & 16'hfff0; mon = 1;
    end endtask
    always @(posedge clk) if (mon && !reset) begin
        if (daco < daco_min) daco_min = daco;
        if (daco > daco_max) daco_max = daco;
        if (nb) nb_seen = 1;
    end
    always @(posedge clk) if (mon && dac_frame_end) begin
        if (g.dut.dac.ldat < dacw_min) dacw_min = g.dut.dac.ldat;
        if (g.dut.dac.ldat > dacw_max) dacw_max = g.dut.dac.ldat;
        if ((g.dut.dac.ldat & 16'hfff0) == def_mask) n_def_writes = n_def_writes + 1;
    end
    reg ld2x_d = 0;
    always @(posedge clk) begin ld2x_d <= g.dut.ld2x; if (mon && g.dut.ld2x && !ld2x_d) n_ld2x = n_ld2x + 1; end

    // Trace: one line per PFD update for the first trace_n updates after an event
    integer trace_n = 0;
    real t0 = 0.0;
    always @(posedge clk) if (g.dut.r_rising && trace_n > 0) begin
        trace_n = trace_n - 1;
        $display("trace %7.1f pfd  daco=%h dac=%h lock_cnt=%0d locked=%b hold=%b nb=%b ld2x=%b freq_err=%0d phase_err=%0d",
                 ($realtime - t0) / PFD_NS, daco, dac_reg, lock_counter, locked, hold_valid, nb, g.dut.ld2x,
                 $signed(dac_now), $signed(phase_err_now));
    end

    integer fails = 0;
    integer W, k, dd;
    task check(input cond, input [8*72-1:0] what); begin
        if (!cond) begin fails = fails + 1; $display("FAIL %0s", what); end
        else $display("ok   %0s", what);
    end endtask

    // Wait for locked; returns the time in PFD periods from t0, or -1
    real lock_pfd;
    task wait_locked(input integer max_pfd); real dl; begin
        dl = $realtime + max_pfd * PFD_NS; lock_pfd = -1.0;
        while (!locked && $realtime < dl) #1000;
        if (locked) lock_pfd = ($realtime - t0) / PFD_NS;
    end endtask

    // UHD session open: the MMCM stops the clocks; after it relocks, ref_pll_rst rises ~11 cycles later
    // (10-stage reset_sync) and stays high while clocks_ready counts (scaled here to 600 cycles).
    task session_open(input with_por); begin
        @(posedge clk); #1; clk_run = 0;
        #20000;
        clk_run = 1;
        repeat (11) @(posedge clk);
        reset <= 1; if (with_por) por <= 1;
        repeat (600) @(posedge clk);
        reset <= 0;
        @(posedge clk); por <= 0;
        t0 = $realtime;
    end endtask

    task report(input [8*24-1:0] name); begin
        $display("%0s: daco %h..%h (swing vs W %0d..%0d), DAC writes %h..%h, dac_def writes %0d, ld2x %0d, nb %0d, lock %0.1f pfd",
                 name, daco_min[15:0], daco_max[15:0], daco_min - W, daco_max - W, dacw_min[15:0], dacw_max[15:0],
                 n_def_writes, n_ld2x, nb_seen, lock_pfd);
    end endtask

    initial begin
        $display("refpll_holdover_tb OLD=%0d PFD=%0d Hz SCALE=%0d, VCTCXO centre %h, dac_def %h", OLD, PFD, SCALE,
                 $rtoi(center), dac_def);

        // a: cold start
        W = DAC_DEF0;
        repeat (200) @(posedge clk);
        mon_start; trace_n = 15;
        reset <= 0; @(posedge clk); por <= 0; t0 = $realtime;
        wait_locked(400);
        report("a cold start");
        check(lock_pfd > 0, "a: cold start locks");
        check(n_def_writes > 0, "a: cold start begins at dac_def");
        #(50 * PFD_NS); mon = 0;
        if (!OLD) check(hold_valid, "a: hold_valid after lock");

        // b: three session opens
        for (k = 0; k < 3; k = k + 1) begin
            W = g.hold_word;
            $display("b%0d: held word W=%h daco=%h", k, W[15:0], daco);
            mon_start; trace_n = (k == 0) ? 30 : 0;
            session_open(0);
            wait_locked(400);
            #(30 * PFD_NS);
            report("b session open");
            mon = 0;
            check(lock_pfd > 0, "b: relocks after session open");
            if (!OLD) begin
                check(n_def_writes == 0, "b: no dac_def write");
                check(nb_seen && n_ld2x == 0, "b: narrow-band restart, no ld2x");
                check(daco_min - W >= -16 && daco_max - W <= 16, "b: loop word within +-0x10 of W");
                check(dacw_min - W >= -32 && dacw_max - W <= 32, "b: DAC writes within +-0x20 of W");
            end
        end

        // e: reference lost for 50 PFD periods while the VCTCXO drifts by +0x40 (about 17 ppb), then back
        W = g.hold_word;
        $display("e: held word W=%h", W[15:0]);
        mon_start;
        ref_run = 0; center = center + 64.0;
        #(50 * PFD_NS);
        $display("e: during the loss DAC writes %h..%h, dac_def writes %0d, daco %h", dacw_min[15:0], dacw_max[15:0],
                 n_def_writes, daco);
        if (!OLD) check(n_def_writes == 0 && dacw_min - W >= -16 && dacw_max - W <= 16,
                        "e: DAC holds W while the reference is lost");
        ref_run = 1; t0 = $realtime; trace_n = 20;
        wait_locked(400);
        #(30 * PFD_NS);
        report("e ref loss");
        mon = 0;
        check(lock_pfd > 0, "e: relocks after the reference returns");
        if (!OLD) check(nb_seen && n_def_writes == 0, "e: restart from W, narrow-band");

        // f: VCTCXO 0x400 (about 280 ppb) away from the held word at a session open
        W = g.hold_word;
        center = center + 1024.0;
        mon_start; trace_n = 30;
        session_open(0);
        wait_locked(600);
        #(30 * PFD_NS);
        report("f far off");
        mon = 0;
        check(lock_pfd > 0, "f: re-acquires");
        dd = daco; dd = dd - $rtoi(center);
        check(dd >= -48 && dd <= 48, "f: locks near the new centre");
        if (!OLD) check(nb_seen && n_ld2x > 0, "f: narrow-band restart dropped by ld2x");

        if (!OLD) begin
            // d: dac_def write while locked
            #(50 * PFD_NS);
            check(hold_valid, "d: hold_valid before the dac_def write");
            dac_def = 16'hA100;
            #1000;
            check(!hold_valid, "d: dac_def write clears hold_valid");
            W = dac_def;
            mon_start;
            session_open(0);
            wait_locked(600);
            report("d dac_def write");
            mon = 0;
            check(n_def_writes > 0 && !nb_seen, "d: next start from the new dac_def, wide-band");

            // c: por
            #(50 * PFD_NS);
            check(hold_valid, "c: hold_valid before por");
            W = dac_def;
            mon_start;
            session_open(1);
            #(2 * PFD_NS);
            check(!hold_valid, "c: por clears hold_valid");
            wait_locked(600);
            report("c por");
            mon = 0;
            check(n_def_writes > 0 && !nb_seen, "c: start from dac_def after por");
        end

        if (OLD) $display("OLD run done (no pass criteria)");
        else if (fails == 0) $display("HOLDOVER PASS");
        else $display("HOLDOVER FAIL (%0d)", fails);
        $finish;
    end
endmodule
