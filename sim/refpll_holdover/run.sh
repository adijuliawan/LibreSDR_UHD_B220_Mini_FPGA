#!/usr/bin/env bash
# Reference-loop holdover test (16.9) with xsim: the working tree's b205_ref_pll, then 16.8's for comparison.
#   source ~/Xilinx/vivado_env.sh; sim/refpll_holdover/run.sh [ref_commit=c6b5e4c] [pfd_hz=10000]
set -euo pipefail
REF=${1:-c6b5e4c}; PFD=${2:-10000}
ROOT=$(cd "$(dirname "$0")/../.." && pwd); S=$ROOT/src/libresdr_b210.srcs/sources_1
T=$S/imports/lib/esdr_b210/top
W=$ROOT/build_out/refpll_holdover; mkdir -p "$W"; cd "$W"
# 16.8's module with the PFD rate and lock tolerance turned into parameters (same defaults), no other change
git -C "$ROOT" show "$REF:src/libresdr_b210.srcs/sources_1/imports/lib/esdr_b210/top/b205_ref_pll.v" \
  | sed -e 's/^module b205_ref_pll(/module b205_ref_pll_old #(parameter PFD_FREQ_PPS=1, parameter PFD_FREQ_10MHZ=10, parameter LOCK_TOLERANCE_PPM=1)(/' \
        -e '/^ *localparam PFD_FREQ_PPS=1;/d' -e '/^ *localparam PFD_FREQ_10MHZ=10;/d' -e '/^ *localparam LOCK_TOLERANCE_PPM=1;/d' \
  > ref_b205_ref_pll.v
grep -q 'module b205_ref_pll_old #' ref_b205_ref_pll.v
xvlog ref_b205_ref_pll.v "$T/b205_ref_pll.v" "$T/DACx311_auto_spi.v" "$S/new/delta_sigma_dac.v" \
  "$ROOT/sim/refpll_holdover/refpll_holdover_tb.v" > xvlog.log 2>&1 || { grep -E "ERROR" xvlog.log | head; exit 1; }
rc=0
for OLD in 1 0; do
  xelab -debug off --timescale 1ns/1fs -generic_top "OLD=$OLD" -generic_top "PFD=$PFD" refpll_holdover_tb \
    -s tb_old$OLD > xelab_old$OLD.log 2>&1 || { grep -E "ERROR" xelab_old$OLD.log | head; exit 1; }
  xsim tb_old$OLD -R > xsim_old$OLD.log 2>&1 || true
  echo "=== OLD=$OLD ($( [ $OLD = 1 ] && echo "16.8 at $REF" || echo "working tree"))"
  grep -vE "^(trace|INFO|Time resolution|source|##|run|quit|exit|\\$|\*\*\*\*)" xsim_old$OLD.log | grep -v '^ *$' || true
done
grep -q "HOLDOVER PASS" xsim_old0.log
