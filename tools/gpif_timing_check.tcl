# Report-only GPIF/FX3 I/O timing (LibreSDRB220 doc 13, Phase 1 item A3).
#   build.tcl sources this after write_bitstream, on the open routed design;
#   standalone: vivado -mode batch -nojournal -source tools/gpif_timing_check.tcl -tclargs <routed.dcp>
# Applies FX3 synchronous Slave FIFO timing (CYUSB301X datasheet 001-52136 Rev *X, Tables 13 and 15) to the GPIF
# ports and prints the worst setup/hold slack per group. It is not in b210.xdc on purpose: the FPGA forwards
# IFCLK un-inverted with slow slew, as Ettus does on the B210 (DRIVE 8, SLEW SLOW), and against the FX3 worst case
# (tCO 7 ns, tCFLG 8 ns) that round trip doesn't close on paper, so it would turn WNS negative and hide real
# regressions. The interface works because the FX3's actual clock-to-out is well below the maximum.
#   FPGA -> FX3 (captured on IFCLK rise): tDS/tWRS/tRDS/tAS/tPES 2 ns setup, 0.5 ns hold
#   FX3 -> FPGA data: tCO max 7 ns, tDOH min 2 ns;  flags (CTL4/5): tCFLG max 8 ns, tCOH min 0 ns
if {[llength [current_design -quiet]] == 0} { open_checkpoint [lindex $argv 0] }
set ck gpif_ifclk
set gpif_out [get_ports {GPIF_D[*] GPIF_CTL0 GPIF_CTL1 GPIF_CTL2 GPIF_CTL3 GPIF_CTL7 GPIF_CTL11 GPIF_CTL12}]
set gpif_din [get_ports {GPIF_D[*]}]
set gpif_flg [get_ports {GPIF_CTL4 GPIF_CTL5}]
set_output_delay -clock $ck -max  2.0 $gpif_out
set_output_delay -clock $ck -min -0.5 $gpif_out
set_input_delay  -clock $ck -max  7.0 $gpif_din
set_input_delay  -clock $ck -min  2.0 $gpif_din
set_input_delay  -clock $ck -max  8.0 $gpif_flg
set_input_delay  -clock $ck -min  0.0 $gpif_flg
foreach {name dir ports} [list fpga_to_fx3 -to $gpif_out fx3_data_to_fpga -from $gpif_din fx3_flags_to_fpga -from $gpif_flg] {
    foreach d {max min} {
        set p [get_timing_paths $dir $ports -delay_type $d -max_paths 1]
        puts [format "GPIF vs FX3 datasheet: %-18s %-5s slack %s" $name [expr {$d eq "max" ? "setup" : "hold"}] [get_property SLACK $p]]
    }
}
