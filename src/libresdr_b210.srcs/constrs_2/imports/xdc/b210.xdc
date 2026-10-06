set_false_path -to [get_pins [list {b200_core/radio_0/ctrl_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_0/ctrl_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_0/resp_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_0/resp_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_0/rx_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_0/rx_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_0/tx_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_0/tx_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_0/vita_time_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_0/vita_time_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_1/ctrl_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_1/ctrl_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_1/resp_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_1/resp_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_1/rx_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_1/rx_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_1/tx_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_1/tx_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_1/vita_time_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/radio_1/vita_time_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/sync_pps_ref/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {b200_core/time_sync_synchronizer/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {bus_sync/reset_double_sync/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {radio_sync/reset_double_sync/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {ref_pll_sync/reset_double_sync/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {slave_fifo32/fifo64_to_gpif2_resp/cross_clock_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {slave_fifo32/fifo64_to_gpif2_resp/cross_clock_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {slave_fifo32/fifo64_to_gpif2_rx/cross_clock_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {slave_fifo32/fifo64_to_gpif2_rx/cross_clock_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {slave_fifo32/gpif2_to_fifo64_ctrl/cross_clock_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {slave_fifo32/gpif2_to_fifo64_ctrl/cross_clock_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {slave_fifo32/gpif2_to_fifo64_tx/cross_clock_fifo/i_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {slave_fifo32/gpif2_to_fifo64_tx/cross_clock_fifo/o_rst_sync_i/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {sync_10m_cdc/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {sync_ext_ref_locked/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {sync_is10meg/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {sync_pps_ext/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {u_libresdr_b210_io/sychronizer_radio_rst/synchronizer_false_path/stages[0].value_reg[0][0]/D} \
          {u_libresdr_b210_io/synchronizer_mimo/synchronizer_false_path/stages[0].value_reg[0][0]/D}]]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33 DRIVE 4 SLEW SLOW} [get_ports CLK_40M_DAC_nSYNC]
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS33 DRIVE 4 SLEW SLOW} [get_ports CLK_40M_DAC_SCLK]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33 DRIVE 4 SLEW SLOW} [get_ports CLK_40M_DAC_DIN]
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports PPS_IN_EXT]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports CLK_40MHz_FPGA]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports CLKIN_10MHz]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33} [get_ports REF_CLK_REQ]
set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS33} [get_ports PPS_LED_inv]
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33} [get_ports REF_LOCKED_inv]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[0]}]
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[1]}]
set_property -dict {PACKAGE_PIN A1 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[2]}]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[3]}]
set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[4]}]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[5]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[6]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[7]}]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[8]}]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[9]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[10]}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[11]}]
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[12]}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[13]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[14]}]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[15]}]
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[16]}]
set_property -dict {PACKAGE_PIN M5 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[17]}]
set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[18]}]
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[19]}]
set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[20]}]
set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[21]}]
set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[22]}]
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[23]}]
set_property -dict {PACKAGE_PIN P4 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[24]}]
set_property -dict {PACKAGE_PIN L6 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[25]}]
set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[26]}]
set_property -dict {PACKAGE_PIN L4 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[27]}]
set_property -dict {PACKAGE_PIN K4 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[28]}]
set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[29]}]
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[30]}]
set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {GPIF_D[31]}]
# IFCLK (FX3 PCLK) with fast slew: the forwarded clock then reaches the FX3 about 1 ns earlier relative to the slow-slew
# GPIF data, which the round trip needs against the FX3 worst case (tools/gpif_timing_check.tcl; LibreSDRB220 doc 13).
# Ettus uses DRIVE 8 SLEW SLOW on the B210. Drive stays at the LVCMOS18 default (12 mA).
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports IFCLK]
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports GPIF_CTL0]
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports GPIF_CTL1]
set_property -dict {PACKAGE_PIN J6 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports GPIF_CTL2]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports GPIF_CTL3]
set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports GPIF_CTL7]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports GPIF_CTL11]
set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports GPIF_CTL12]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33} [get_ports FPGA_RXD0]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS33} [get_ports FPGA_TXD0]
set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33 SLEW SLOW} [get_ports {fp_gpio[0]}]
set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS33 SLEW SLOW} [get_ports {fp_gpio[1]}]
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33 SLEW SLOW} [get_ports {fp_gpio[2]}]
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33 SLEW SLOW} [get_ports {fp_gpio[3]}]
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33 SLEW SLOW} [get_ports {fp_gpio[4]}]
set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVCMOS33 SLEW SLOW} [get_ports {fp_gpio[5]}]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS33 SLEW SLOW} [get_ports {fp_gpio[6]}]
set_property -dict {PACKAGE_PIN AB13 IOSTANDARD LVCMOS33 SLEW SLOW} [get_ports {fp_gpio[7]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports LED_RX1_inv]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports LED_RX2_inv]
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports LED_TXRX1_TX_inv]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports LED_TXRX2_RX_inv]
set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVCMOS33} [get_ports LED_TXRX1_RX_inv]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports LED_TXRX2_TX_inv]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports LED_RX1_R]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports LED_RX1_B]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports LED_RX2_R]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports LED_RX2_B]
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS33} [get_ports LED_TXRX1_B]
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports LED_TXRX2_B]
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports LED_USER_R]
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33} [get_ports REF_IS_10M_detect_inv]
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports CAT_RESETn]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports CAT_EN_AGC]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports CAT_EN]
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports CAT_TXnRX]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports CAT_SYNC]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports CAT_SPI_CLK]
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports CAT_SPI_DI]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS18} [get_ports {CAT_CTL_OUT[0]}]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS18} [get_ports {CAT_CTL_OUT[1]}]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS18} [get_ports {CAT_CTL_OUT[2]}]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS18} [get_ports {CAT_CTL_OUT[3]}]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS18} [get_ports {CAT_CTL_OUT[4]}]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS18} [get_ports {CAT_CTL_OUT[5]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS18} [get_ports {CAT_CTL_OUT[6]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS18} [get_ports {CAT_CTL_OUT[7]}]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {CAT_CTL_IN[0]}]
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {CAT_CTL_IN[1]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {CAT_CTL_IN[2]}]
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS18 SLEW SLOW} [get_ports {CAT_CTL_IN[3]}]
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[0]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[1]}]
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[2]}]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[3]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[4]}]
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[5]}]
set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[6]}]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[7]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[8]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[9]}]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[10]}]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS18} [get_ports {CAT_P1_D[11]}]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[0]}]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[1]}]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[2]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[3]}]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[4]}]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[5]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[6]}]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[7]}]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[8]}]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[9]}]
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[10]}]
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS18} [get_ports {CAT_P0_D[11]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS18} [get_ports CAT_DCLK_P]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports CAT_RX_FR_P]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS18} [get_ports CAT_TX_FR_P]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS18} [get_ports CAT_FBCLK_P]
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33} [get_ports SFDX1_RX]
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS33} [get_ports SFDX1_TX]
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33} [get_ports SFDX2_RX]
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33} [get_ports SFDX2_TX]
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS33} [get_ports SRX1_RX]
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports SRX1_TX]
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS33} [get_ports SRX2_RX]
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS33} [get_ports SRX2_TX]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports tx_enable1]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33} [get_ports tx_enable2]
# AD9361 DATA_CLK. Max 61.44 MHz: DATA_CLK = master clock in 1R1T, 2x master clock (<= 30.72 MHz) in 2R2T.
# Same period as Ettus B200 timing.ucf and AD9361 tCP min (UG-570 Table 49). Was 12.500 (80 MHz).
create_clock -period 16.276 -name CAT_DCLK_P [get_ports CAT_DCLK_P]
#create_clock -period 16.000 -name radio_clk [get_nets radio_clk]









# #### FX3 Lines ##############################################################
# GPIF Data lines

set_property PACKAGE_PIN H5 [get_ports FX3_EXTINT]
set_property IOSTANDARD LVCMOS18 [get_ports FX3_EXTINT]
# FX3 CTRL
set_property PACKAGE_PIN H3 [get_ports GPIF_CTL4]
set_property IOSTANDARD LVCMOS18 [get_ports GPIF_CTL4]
set_property PACKAGE_PIN J4 [get_ports GPIF_CTL5]
set_property IOSTANDARD LVCMOS18 [get_ports GPIF_CTL5]
set_property PACKAGE_PIN K6 [get_ports GPIF_CTL6]
set_property IOSTANDARD LVCMOS18 [get_ports GPIF_CTL6]
set_property PACKAGE_PIN P5 [get_ports GPIF_CTL8]
set_property IOSTANDARD LVCMOS18 [get_ports GPIF_CTL8]
set_property PACKAGE_PIN J5 [get_ports GPIF_CTL9]
set_property IOSTANDARD LVCMOS18 [get_ports GPIF_CTL9]


#debug uart
#GPIO



# LED







# CAT

# SPI
set_property PACKAGE_PIN H14 [get_ports CAT_SPI_EN]
set_property IOSTANDARD LVCMOS18 [get_ports CAT_SPI_EN]
set_property SLEW SLOW [get_ports CAT_SPI_EN]
set_property PULLTYPE PULLUP [get_ports CAT_SPI_EN]
set_property PACKAGE_PIN G16 [get_ports CAT_SPI_DO]
set_property IOSTANDARD LVCMOS18 [get_ports CAT_SPI_DO]

# Control Lines


# TX Bus P1

# Rx Bus P0


# Frame syncs

## RF Hardware Control



set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

###############################################################################
# Clock definitions
###############################################################################

# External 10 MHz reference input — drives clk_wiz_0 MMCM
create_clock -period 100.000 -name clk_10mhz [get_ports CLKIN_10MHz]

###############################################################################
# Asynchronous inputs — handled by synchronizers in RTL
###############################################################################

# PPS_IN_EXT is an asynchronous external pulse (1 Hz or absent).
# It is double-synchronized into ref_pll_clk in libresdr_b210.v.
set_false_path -from [get_ports PPS_IN_EXT]

###############################################################################
# Clock domain crossings
###############################################################################

# sync_200M (from 10 MHz MMCM) and ref_pll_clk (from 40 MHz MMCM) are
# physically unrelated 200 MHz clocks. CDC is handled by synchronizers.
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins clk_wiz_0_10M_detect/inst/mmcm_adv_inst/CLKOUT0]] -group [get_clocks -of_objects [get_pins u_gen_clocks_main/inst/mmcm_adv_inst/CLKOUT2]]

# Generic false path for all synchronizer_impl instances (standard UHD pattern)
set_false_path -to [get_pins -hierarchical -filter {NAME =~ */synchronizer_false_path/stages[0].value_reg[0][*]/D}]

###############################################################################
# Existing cross-domain false paths
###############################################################################

set_false_path -from [get_clocks CAT_DCLK_P] -to [get_clocks -of_objects [get_pins u_gen_clocks_main/inst/mmcm_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks CAT_DCLK_P] -to [get_clocks -of_objects [get_pins u_libresdr_b210_io/BUFR_inst/O]]
set_false_path -from [get_clocks -of_objects [get_pins u_gen_clocks_main/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks CAT_DCLK_P]
set_false_path -from [get_clocks -of_objects [get_pins u_gen_clocks_main/inst/mmcm_adv_inst/CLKOUT2]] -to [get_clocks CAT_DCLK_P]
set_false_path -from [get_clocks -of_objects [get_pins u_libresdr_b210_io/BUFR_inst/O]] -to [get_clocks -of_objects [get_pins u_gen_clocks_main/inst/mmcm_adv_inst/CLKOUT1]]

set_property PACKAGE_PIN W22 [get_ports scl]
set_property PACKAGE_PIN W21 [get_ports sda]
set_property IOSTANDARD LVCMOS18 [get_ports scl]
set_property IOSTANDARD LVCMOS18 [get_ports sda]

set_false_path -from [get_clocks -of_objects [get_pins u_gen_clocks_main/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins u_libresdr_b210_io/BUFR_inst/O]]

# --- GPIF / FX3 interface (Phase 1, LibreSDRB220 doc 13) ---------------------------------------------
# Ettus constrains the same RTL on the B210 with `INST "GPIF_*" IOB = TRUE` (fpga/usrp3/top/b200/timing.ucf):
# every GPIF register sits in the I/O block, so interface timing is fixed by silicon and doesn't depend on
# placement. The B220 port dropped this, which made each build's GPIF timing a placement lottery.
set_property IOB TRUE [get_ports {GPIF_D[*] GPIF_CTL*}]
# The FPGA forwards gpif_clk to the FX3 through ODDR_inst; name it so I/O timing shows up in the reports.
create_generated_clock -name gpif_ifclk -source [get_pins ODDR_inst/C] -divide_by 1 [get_ports IFCLK]

# --- AD9361 data port, CMOS DDR 1.8 V (Phase 1, LibreSDRB220 doc 13) -----------------------------------
# UHD sees this board as a B210 (product 2) and programs the AD9361 interface with rx_data_delay = tx_data_delay
# = 0xF and both clock delays 0 (b200_impl.cpp, b200_ad9361_client_t::get_digital_interface_timing). AD9361 delay
# steps are about 0.3 ns/LSB (typical only, no min/max given), so 0xF is about 4.5 ns; we allow +-1 ns around it.
# Chip timing (AD9361 datasheet CMOS 1.8 V table, UG-570 Table 49): tDDRX 0..1.5 ns (DATA_CLK -> Rx data),
# tDDDV 0..1.0 ns (DATA_CLK -> RX_FRAME), tSTX 1 ns / tHTX 0 ns (Tx data vs FB_CLK), tMP 45..55 % of tCP.
# Capture scheme (libresdr_b205_io.v): RX data/frame go straight into IDDR (SAME_EDGE) on the BUFR copy of DATA_CLK;
# TX data/frame and FB_CLK come from ODDRs on the same clock, so TX is edge-aligned with FB_CLK.
# In both directions each word is captured by the clock edge after the one that launched it (T/2 later): setup is
# checked rise->fall and fall->rise, hold rise->rise and fall->fall; the other edge pairs are false paths.
set cat_t     16.276
set cat_dcd   [expr {0.05 * $cat_t}]
set cat_dly   4.5
set cat_dtol  1.0
set cat_brd   0.1

# RX: data and frame change cat_dly + [0, tDDRX] after each DATA_CLK edge at the pins.
create_clock -period $cat_t -name cat_dclk_virt
set cat_rx [get_ports {CAT_P0_D[*] CAT_RX_FR_P}]
set_input_delay -clock cat_dclk_virt -max [expr {$cat_dly + $cat_dtol + 1.5 + $cat_dcd + $cat_brd}] $cat_rx
set_input_delay -clock cat_dclk_virt -min [expr {$cat_dly - $cat_dtol - $cat_brd}] $cat_rx
set_input_delay -clock cat_dclk_virt -max [expr {$cat_dly + $cat_dtol + 1.5 + $cat_dcd + $cat_brd}] $cat_rx -clock_fall -add_delay
set_input_delay -clock cat_dclk_virt -min [expr {$cat_dly - $cat_dtol - $cat_brd}] $cat_rx -clock_fall -add_delay
set_false_path -setup -rise_from [get_clocks cat_dclk_virt] -rise_to [get_clocks CAT_DCLK_P]
set_false_path -setup -fall_from [get_clocks cat_dclk_virt] -fall_to [get_clocks CAT_DCLK_P]
set_false_path -hold  -rise_from [get_clocks cat_dclk_virt] -fall_to [get_clocks CAT_DCLK_P]
set_false_path -hold  -fall_from [get_clocks cat_dclk_virt] -rise_to [get_clocks CAT_DCLK_P]

# TX: the AD9361 delays Tx data by cat_dly inside the chip, so at its pins it needs data from tSTX + cat_dly
# before to tHTX - cat_dly after (i.e. cat_dly before) the capturing FB_CLK edge.
create_generated_clock -name cat_fbclk -source [get_pins u_libresdr_b210_io/oddr_clk/C] -divide_by 1 [get_ports CAT_FBCLK_P]
set cat_tx [get_ports {CAT_P1_D[*] CAT_TX_FR_P}]
set_output_delay -clock cat_fbclk -max [expr {1.0 + $cat_dly + $cat_dtol + $cat_dcd + $cat_brd}] $cat_tx
set_output_delay -clock cat_fbclk -min [expr {$cat_dly - $cat_dtol - $cat_brd}] $cat_tx
set_output_delay -clock cat_fbclk -max [expr {1.0 + $cat_dly + $cat_dtol + $cat_dcd + $cat_brd}] $cat_tx -clock_fall -add_delay
set_output_delay -clock cat_fbclk -min [expr {$cat_dly - $cat_dtol - $cat_brd}] $cat_tx -clock_fall -add_delay
set_false_path -setup -rise_from [get_clocks CAT_DCLK_P] -rise_to [get_clocks cat_fbclk]
set_false_path -setup -fall_from [get_clocks CAT_DCLK_P] -fall_to [get_clocks cat_fbclk]
set_false_path -hold  -rise_from [get_clocks CAT_DCLK_P] -fall_to [get_clocks cat_fbclk]
set_false_path -hold  -fall_from [get_clocks CAT_DCLK_P] -rise_to [get_clocks cat_fbclk]

# AD9361 control pins: tied to constants (CTL_IN, EN, EN_AGC, TXnRX, SYNC), a slow reset, async lock status into a
# synchronizer (CTL_OUT), and SPI. SPI is bit-banged from bus_clk registers at a divided rate (simple_spi_core), so
# every SPI edge is many bus_clk cycles apart. None of these is timed against a clock.
set_false_path -to   [get_ports {CAT_CTL_IN[*] CAT_EN CAT_EN_AGC CAT_TXnRX CAT_SYNC CAT_RESETn CAT_SPI_CLK CAT_SPI_DI CAT_SPI_EN}]
set_false_path -from [get_ports {CAT_CTL_OUT[*] CAT_SPI_DO}]

# --- Slow or static board I/O -------------------------------------------------------------------------------
# LEDs, RF switch and PA enables (radio_clk ATR, settle in us), VCTCXO DAC SPI (ref_pll_clk, auto-SPI), front-panel
# GPIO and UART, EEPROM I2C, reference status, the FX3 serial settings bus (GPIF_CTL6/8), FX3 reset (GPIF_CTL9)
# and FX3_EXTINT. Ettus leaves these unconstrained on the B210 too; the false paths make check_timing list only
# what is really left.
set_false_path -to [get_ports {LED_* SFDX* SRX* tx_enable* CLK_40M_DAC_* REF_CLK_REQ REF_IS_10M_detect_inv REF_LOCKED_inv PPS_LED_inv fp_gpio[*] FPGA_RXD0 FPGA_TXD0 scl sda}]
set_false_path -from [get_ports {fp_gpio[*] FPGA_RXD0 FPGA_TXD0 sda GPIF_CTL6 GPIF_CTL8 GPIF_CTL9 FX3_EXTINT}]
