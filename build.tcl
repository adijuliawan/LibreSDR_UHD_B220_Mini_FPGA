# LibreSDR B220 Mini FPGA — Vivado batch build script (2025.1 on Linux; also works with the Docker/2025.2 setup)
#
# Usage:
#   source ~/Xilinx/2025.1/Vivado/settings64.sh
#   vivado -mode batch -source build.tcl [-tclargs <output_dir>]      # default output: ./build_out
#
# NOTE: Uses in-process synth_design / opt_design / place_design / route_design
# instead of launch_runs, because launch_runs spawns child processes that crash
# under Rosetta x86_64 emulation (libudev realloc bug in license manager).

###############################################################################
# Rosetta workaround: WebTalk telemetry is disabled via the environment
# variable XILINX_LOCAL_USER_DATA=no (set in run.vivado.sh).
# HAPRWebtalkHelper calls udev_enumerate_scan_devices which crashes under
# Rosetta with "realloc(): invalid pointer" / "mremap_chunk(): invalid pointer".
# config_webtalk was removed in Vivado 2025.x — use env var only.
###############################################################################

###############################################################################
# Suppress known-harmless warnings to reduce log noise (~350 lines removed)
###############################################################################
# Board parts for non-installed FPGA families (we only have Artix-7)
set_msg_config -id {Board 49-26} -suppress
# Unconnected debug/VIO probe ports (not instantiated in the design)
set_msg_config -id {Synth 8-7129} -suppress
# Constant-driven output ports (LEDs, AD9361 config — by design)
set_msg_config -id {Synth 8-3917} -suppress
# Unconnected port count mismatches (upstream Ettus coding style)
set_msg_config -id {Synth 8-7071} -suppress
set_msg_config -id {Synth 8-7023} -suppress

# The dev PC is a shared lab host: cap Vivado at 4 threads (run the build under `nice -n 19` too).
set_param general.maxThreads 4

set script_dir [file dirname [file normalize [info script]]]
set src_dir    ${script_dir}/src
set xpr_file   ${src_dir}/libresdr_b210.xpr
if {[llength $argv] > 0} { set output_dir [file normalize [lindex $argv 0]] } else { set output_dir ${script_dir}/build_out }
file mkdir ${output_dir}

# ---- Open project ----
puts "Opening project: ${xpr_file}"
open_project ${xpr_file}

# ---- Upgrade IP cores if locked (2025.1 -> 2025.2) ----
foreach ip [get_ips] {
    if {[get_property IS_LOCKED $ip]} {
        puts "  Upgrading locked IP: [get_property NAME $ip]"
        upgrade_ip $ip
    }
}

# Always regenerate targets — ensures IP synthesis outputs exist even if
# IPs were already upgraded (e.g. from a previous run that was interrupted).
puts "Generating IP targets..."
generate_target all [get_ips]

# Synthesize IPs individually. synth_ip emits CRITICAL WARNING [Vivado 12-5447]
# "not supported in project mode" but actually works fine. Without this,
# synth_design can't find the IP modules for in-process elaboration.
set_msg_config -id {Vivado 12-5447} -suppress
foreach ip [get_ips] {
    puts "  Synthesizing IP: [get_property NAME $ip]"
    synth_ip $ip
}

# ---- Synthesis (in-process) ----
puts "Running synthesis (in-process)..."
synth_design -top libresdr_b210 -part xc7a200tfbg484-2

puts "Synthesis complete."
report_utilization -file ${output_dir}/post_synth_utilization.rpt
puts "Post-synth utilization written to ${output_dir}/post_synth_utilization.rpt"

# ---- Implementation (in-process) ----
puts "Running optimization..."
opt_design

puts "Running placement (directive: ExtraTimingOpt)..."
place_design -directive ExtraTimingOpt

puts "Running physical optimization..."
phys_opt_design -directive AggressiveExplore

puts "Running routing..."
route_design

puts "Implementation complete."

# ---- Reports ----
report_timing_summary -file ${output_dir}/timing_summary.rpt
report_utilization    -file ${output_dir}/utilization.rpt
report_drc            -file ${output_dir}/drc.rpt
report_methodology    -file ${output_dir}/methodology.rpt
report_power          -file ${output_dir}/power.rpt

report_io             -file ${output_dir}/io.rpt
report_clock_interaction -file ${output_dir}/clock_interaction.rpt
check_timing -verbose -file ${output_dir}/check_timing.rpt
write_checkpoint -force ${output_dir}/routed.dcp

# AD9361 I/O timing (b210.xdc I/O delays; LibreSDRB220 doc 13). Worst setup and hold path for each direction.
# GPIF is checked separately at the end (tools/gpif_timing_check.tcl, report-only).
set fh [open ${output_dir}/io_timing.rpt w]; close $fh
foreach {name ports} {
    cat_rx  {CAT_P0_D[*] CAT_RX_FR_P}
    cat_tx  {CAT_P1_D[*] CAT_TX_FR_P}
} {
    set p [get_ports $ports]
    set dir [expr {$name eq "cat_rx" ? "-from" : "-to"}]
    foreach d {max min} {
        set path [get_timing_paths $dir $p -delay_type $d -max_paths 1 -nworst 1]
        set s [expr {[llength $path] ? [get_property SLACK $path] : "unconstrained"}]
        puts "I/O timing ${name} [expr {$d eq "max" ? "setup" : "hold"}]: ${s}"
        report_timing $dir $p -delay_type $d -max_paths 1 -input_pins -append -file ${output_dir}/io_timing.rpt
    }
}
# Ports still without a delay or exception. Expected: only the GPIF bus (34 in, 38 out), see the GPIF check below.
foreach chk {no_input_delay no_output_delay} {
    set f [open ${output_dir}/check_timing.rpt]; set txt [read $f]; close $f
    if {[regexp "checking ${chk} \\((\\d+)\\)" $txt -> n]} { puts "check_timing ${chk}: ${n}" }
}

# GPIF registers must sit in IOBs (b210.xdc: IOB TRUE), as Ettus does for the B210 (LibreSDRB220 doc 13).
set gpif_ff [get_cells -hier -filter {IS_SEQUENTIAL && NAME =~ "*gpif*"}]
set in_iob 0
set fh [open ${output_dir}/gpif_iob.txt w]
foreach c $gpif_ff {
    set site [get_sites -quiet -of_objects $c]
    set st [expr {$site eq "" ? "-" : [get_property SITE_TYPE $site]}]
    if {[string match "*LOGIC*" $st]} { incr in_iob; puts $fh "IOB    $st  $c" }
}
close $fh
puts "GPIF registers placed in IOB sites: ${in_iob} (list in gpif_iob.txt)"

puts "Reports written to ${output_dir}/"

# ---- Check timing ----
set wns [get_property SLACK [get_timing_paths -max_paths 1 -setup]]
set whs [get_property SLACK [get_timing_paths -max_paths 1 -hold]]
puts "Timing: WNS=${wns} WHS=${whs}"
if {$wns < 0} {
    puts "WARNING: Negative WNS — setup timing violation(s)!"
}
if {$whs < 0} {
    puts "WARNING: Negative WHS — hold timing violation(s)!"
}

# ---- Bitstream ----
puts "Generating bitstream..."
write_bitstream -force -bin_file ${output_dir}/libresdr_b210

# Report-only: GPIF against FX3 datasheet worst case. Adds I/O delays to the in-memory design after the bitstream.
source ${script_dir}/tools/gpif_timing_check.tcl

puts ""
puts "========================================="
puts "Build complete. Outputs in ${output_dir}/"
puts "========================================="
puts "  libresdr_b210.bit  — FPGA bitstream"
puts "  timing_summary.rpt — Timing analysis"
puts "  utilization.rpt    — Resource usage"
puts "  drc.rpt            — Design rule checks"
puts "  methodology.rpt    — Methodology checks"
puts "  power.rpt          — Power estimate"
puts "========================================="
exit 0
