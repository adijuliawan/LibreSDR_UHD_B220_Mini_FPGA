#!/usr/bin/env bash
# Equivalence test: gpif2_slave_fifo32 at <ref commit> vs the working tree, with xsim.
#   source ~/Xilinx/vivado_env.sh; sim/gpif_equiv/run.sh [ref_commit=16661ef] [cycles=400000] [seed=1]
set -euo pipefail
REF=${1:-16661ef}; CYC=${2:-400000}; SEED=${3:-1}; DEBUG=${DEBUG:-0}
ROOT=$(cd "$(dirname "$0")/../.." && pwd); L=$ROOT/src/libresdr_b210.srcs/sources_1/imports/lib
W=$ROOT/build_out/gpif_equiv; mkdir -p "$W"; cd "$W"
git -C "$ROOT" show "$REF:src/libresdr_b210.srcs/sources_1/imports/lib/gpif2/gpif2_slave_fifo32.v" \
  | sed 's/^module gpif2_slave_fifo32\b/module gpif2_slave_fifo32_ref/' > ref_gpif2_slave_fifo32.v
xvlog -i "$L/control" ref_gpif2_slave_fifo32.v "$L/gpif2/gpif2_slave_fifo32.v" "$L/gpif2/gpif2_to_fifo64.v" \
  "$L/gpif2/fifo64_to_gpif2.v" "$L/gpif2/gpif2_error_checker.v" "$L"/fifo/axi_*.v "$L/fifo_200/axi_fifo_legacy.v" \
  "$L/control/synchronizer.v" "$L/control/synchronizer_impl.v" "$L/control/ram_2port.v" \
  "$ROOT/sim/gpif_equiv/fifo_ip_stubs.v" "$ROOT/sim/gpif_equiv/gpif2_slave_fifo32_equiv_tb.v" \
  "$XILINX_VIVADO/data/verilog/src/glbl.v" > xvlog.log 2>&1 \
  || { grep -E "ERROR" xvlog.log | head; exit 1; }
xelab -debug off --timescale 1ns/1ps -generic_top "CYCLES=$CYC" -generic_top "SEED=$SEED" -generic_top "DEBUG=$DEBUG" -L unisims_ver gpif2_slave_fifo32_equiv_tb glbl -s equiv > xelab.log 2>&1 \
  || { grep -E "ERROR" xelab.log | head; exit 1; }
xsim equiv -R > xsim.log 2>&1 || true
grep -E "^dbg|MISMATCH|TRISTATE|BUS X|cycles|EQUIVALENCE" xsim.log
grep -q "EQUIVALENCE PASS" xsim.log
