
create_clock -period 5.000 [get_ports clk_p]
create_clock -period 41.000 [get_ports pclk]


create_generated_clock -name cclk -source [get_pins top_i/ppu_top_i/clk_rst_gen_i/xilinx_clock_manager_inst/clk100_i] -divide_by 2 [get_pins top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_cclk_reg/Q]


create_generated_clock -name sample -source [get_pins top_i/ppu_top_i/clk_rst_gen_i/xilinx_clock_manager_inst/clk100_i] -divide_by 2 [get_pins top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_cclk_sample_reg/Q]


create_generated_clock -name cclk_drv -source [get_pins top_i/ppu_top_i/clk_rst_gen_i/xilinx_clock_manager_inst/clk100_i] -divide_by 2 [get_pins top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_cclk_drv_reg/Q]

set_false_path -from cclk_drv -to clk_pll_i

set_false_path -from clk50_o_xilinx_clock_manager_1 -to cclk

set_false_path -from clk50_o_xilinx_clock_manager_1 -to clk_pll_i

set_false_path -from clk50_o_xilinx_clock_manager_1 -to cclk_drv
set_false_path -from cclk_drv -to cclk

set_false_path -from cclk -to cclk_drv

set_false_path -from cclk -to sample

set_false_path -from sample -to cclk

set_false_path -from sample -to clk_pll_i

############## NET - IOSTANDARD ##################


# PadFunction: IO_L2P_T0_AD12P_35
set_property SLEW FAST [get_ports {ddr3_dq[0]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[0]}]

# PadFunction: IO_L5P_T0_AD13P_35
set_property SLEW FAST [get_ports {ddr3_dq[1]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[1]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[1]}]

# PadFunction: IO_L1N_T0_AD4N_35
set_property SLEW FAST [get_ports {ddr3_dq[2]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[2]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[2]}]

# PadFunction: IO_L6P_T0_35
set_property SLEW FAST [get_ports {ddr3_dq[3]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[3]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[3]}]

# PadFunction: IO_L2N_T0_AD12N_35
set_property SLEW FAST [get_ports {ddr3_dq[4]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[4]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[4]}]

# PadFunction: IO_L5N_T0_AD13N_35
set_property SLEW FAST [get_ports {ddr3_dq[5]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[5]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[5]}]

# PadFunction: IO_L1P_T0_AD4P_35
set_property SLEW FAST [get_ports {ddr3_dq[6]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[6]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[6]}]

# PadFunction: IO_L4P_T0_35
set_property SLEW FAST [get_ports {ddr3_dq[7]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[7]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[7]}]

# PadFunction: IO_L11P_T1_SRCC_35
set_property SLEW FAST [get_ports {ddr3_dq[8]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[8]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[8]}]

# PadFunction: IO_L11N_T1_SRCC_35
set_property SLEW FAST [get_ports {ddr3_dq[9]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[9]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[9]}]

# PadFunction: IO_L8P_T1_AD14P_35
set_property SLEW FAST [get_ports {ddr3_dq[10]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[10]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[10]}]

# PadFunction: IO_L10N_T1_AD15N_35
set_property SLEW FAST [get_ports {ddr3_dq[11]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[11]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[11]}]

# PadFunction: IO_L7N_T1_AD6N_35
set_property SLEW FAST [get_ports {ddr3_dq[12]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[12]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[12]}]

# PadFunction: IO_L10P_T1_AD15P_35
set_property SLEW FAST [get_ports {ddr3_dq[13]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[13]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[13]}]

# PadFunction: IO_L7P_T1_AD6P_35
set_property SLEW FAST [get_ports {ddr3_dq[14]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[14]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[14]}]

# PadFunction: IO_L12P_T1_MRCC_35
set_property SLEW FAST [get_ports {ddr3_dq[15]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[15]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[15]}]

# PadFunction: IO_L18N_T2_35
set_property SLEW FAST [get_ports {ddr3_dq[16]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[16]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[16]}]

# PadFunction: IO_L16P_T2_35
set_property SLEW FAST [get_ports {ddr3_dq[17]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[17]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[17]}]

# PadFunction: IO_L14P_T2_SRCC_35
set_property SLEW FAST [get_ports {ddr3_dq[18]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[18]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[18]}]

# PadFunction: IO_L17N_T2_35
set_property SLEW FAST [get_ports {ddr3_dq[19]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[19]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[19]}]

# PadFunction: IO_L14N_T2_SRCC_35
set_property SLEW FAST [get_ports {ddr3_dq[20]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[20]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[20]}]

# PadFunction: IO_L17P_T2_35
set_property SLEW FAST [get_ports {ddr3_dq[21]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[21]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[21]}]

# PadFunction: IO_L13N_T2_MRCC_35
set_property SLEW FAST [get_ports {ddr3_dq[22]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[22]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[22]}]

# PadFunction: IO_L18P_T2_35
set_property SLEW FAST [get_ports {ddr3_dq[23]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[23]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[23]}]

# PadFunction: IO_L20N_T3_35
set_property SLEW FAST [get_ports {ddr3_dq[24]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[24]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[24]}]

# PadFunction: IO_L19P_T3_35
set_property SLEW FAST [get_ports {ddr3_dq[25]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[25]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[25]}]

# PadFunction: IO_L20P_T3_35
set_property SLEW FAST [get_ports {ddr3_dq[26]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[26]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[26]}]

# PadFunction: IO_L22N_T3_35
set_property SLEW FAST [get_ports {ddr3_dq[27]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[27]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[27]}]

# PadFunction: IO_L23P_T3_35
set_property SLEW FAST [get_ports {ddr3_dq[28]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[28]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[28]}]

# PadFunction: IO_L24N_T3_35
set_property SLEW FAST [get_ports {ddr3_dq[29]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[29]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[29]}]

# PadFunction: IO_L24P_T3_35
set_property SLEW FAST [get_ports {ddr3_dq[30]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[30]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[30]}]

# PadFunction: IO_L22P_T3_35
set_property SLEW FAST [get_ports {ddr3_dq[31]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[31]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dq[31]}]

# PadFunction: IO_L6N_T0_VREF_34
set_property SLEW FAST [get_ports {ddr3_addr[14]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[14]}]
set_property PACKAGE_PIN V3 [get_ports {ddr3_addr[14]}]

# PadFunction: IO_L1N_T0_34
set_property SLEW FAST [get_ports {ddr3_addr[13]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[13]}]
set_property PACKAGE_PIN U1 [get_ports {ddr3_addr[13]}]

# PadFunction: IO_L4N_T0_34
set_property SLEW FAST [get_ports {ddr3_addr[12]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[12]}]
set_property PACKAGE_PIN Y2 [get_ports {ddr3_addr[12]}]

# PadFunction: IO_L4P_T0_34
set_property SLEW FAST [get_ports {ddr3_addr[11]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[11]}]
set_property PACKAGE_PIN W2 [get_ports {ddr3_addr[11]}]

# PadFunction: IO_L5N_T0_34
set_property SLEW FAST [get_ports {ddr3_addr[10]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[10]}]
set_property PACKAGE_PIN Y1 [get_ports {ddr3_addr[10]}]

# PadFunction: IO_L2P_T0_34
set_property SLEW FAST [get_ports {ddr3_addr[9]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[9]}]
set_property PACKAGE_PIN U2 [get_ports {ddr3_addr[9]}]

# PadFunction: IO_L2N_T0_34
set_property SLEW FAST [get_ports {ddr3_addr[8]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[8]}]
set_property PACKAGE_PIN V2 [get_ports {ddr3_addr[8]}]

# PadFunction: IO_L1P_T0_34
set_property SLEW FAST [get_ports {ddr3_addr[7]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[7]}]
set_property PACKAGE_PIN T1 [get_ports {ddr3_addr[7]}]

# PadFunction: IO_L5P_T0_34
set_property SLEW FAST [get_ports {ddr3_addr[6]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[6]}]
set_property PACKAGE_PIN W1 [get_ports {ddr3_addr[6]}]

# PadFunction: IO_L6P_T0_34
set_property SLEW FAST [get_ports {ddr3_addr[5]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[5]}]
set_property PACKAGE_PIN U3 [get_ports {ddr3_addr[5]}]

# PadFunction: IO_L7N_T1_34
set_property SLEW FAST [get_ports {ddr3_addr[4]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[4]}]
set_property PACKAGE_PIN AB1 [get_ports {ddr3_addr[4]}]

# PadFunction: IO_L10N_T1_34
set_property SLEW FAST [get_ports {ddr3_addr[3]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[3]}]
set_property PACKAGE_PIN AB5 [get_ports {ddr3_addr[3]}]

# PadFunction: IO_L10P_T1_34
set_property SLEW FAST [get_ports {ddr3_addr[2]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[2]}]
set_property PACKAGE_PIN AA5 [get_ports {ddr3_addr[2]}]

# PadFunction: IO_L8N_T1_34
set_property SLEW FAST [get_ports {ddr3_addr[1]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[1]}]
set_property PACKAGE_PIN AB2 [get_ports {ddr3_addr[1]}]

# PadFunction: IO_L11N_T1_SRCC_34
set_property SLEW FAST [get_ports {ddr3_addr[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[0]}]
set_property PACKAGE_PIN AA4 [get_ports {ddr3_addr[0]}]

# PadFunction: IO_L11P_T1_SRCC_34
set_property SLEW FAST [get_ports {ddr3_ba[2]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[2]}]
set_property PACKAGE_PIN Y4 [get_ports {ddr3_ba[2]}]

# PadFunction: IO_L9P_T1_DQS_34
set_property SLEW FAST [get_ports {ddr3_ba[1]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[1]}]
set_property PACKAGE_PIN Y3 [get_ports {ddr3_ba[1]}]

# PadFunction: IO_L9N_T1_DQS_34
set_property SLEW FAST [get_ports {ddr3_ba[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[0]}]
set_property PACKAGE_PIN AA3 [get_ports {ddr3_ba[0]}]

# PadFunction: IO_L12P_T1_MRCC_34
set_property SLEW FAST [get_ports ddr3_ras_n]
set_property IOSTANDARD SSTL15 [get_ports ddr3_ras_n]
set_property PACKAGE_PIN V4 [get_ports ddr3_ras_n]

# PadFunction: IO_L12N_T1_MRCC_34
set_property SLEW FAST [get_ports ddr3_cas_n]
set_property IOSTANDARD SSTL15 [get_ports ddr3_cas_n]
set_property PACKAGE_PIN W4 [get_ports ddr3_cas_n]

# PadFunction: IO_L7P_T1_34
set_property SLEW FAST [get_ports ddr3_we_n]
set_property IOSTANDARD SSTL15 [get_ports ddr3_we_n]
set_property PACKAGE_PIN AA1 [get_ports ddr3_we_n]

# PadFunction: IO_L15P_T2_DQS_34
set_property SLEW FAST [get_ports ddr3_reset_n]
set_property IOSTANDARD LVCMOS15 [get_ports ddr3_reset_n]
set_property PACKAGE_PIN W6 [get_ports ddr3_reset_n]

# PadFunction: IO_L14P_T2_SRCC_34
set_property SLEW FAST [get_ports ddr3_cke]
set_property IOSTANDARD SSTL15 [get_ports ddr3_cke]
set_property PACKAGE_PIN T5 [get_ports ddr3_cke]

# PadFunction: IO_L14N_T2_SRCC_34
set_property SLEW FAST [get_ports ddr3_odt]
set_property IOSTANDARD SSTL15 [get_ports ddr3_odt]
set_property PACKAGE_PIN U5 [get_ports ddr3_odt]

# PadFunction: IO_L8P_T1_34
set_property SLEW FAST [get_ports ddr3_cs_n]
set_property IOSTANDARD SSTL15 [get_ports ddr3_cs_n]
set_property PACKAGE_PIN AB3 [get_ports ddr3_cs_n]

# PadFunction: IO_L4N_T0_35
set_property SLEW FAST [get_ports {ddr3_dm[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[0]}]
set_property PACKAGE_PIN D2 [get_ports {ddr3_dm[0]}]

# PadFunction: IO_L8N_T1_AD14N_35
set_property SLEW FAST [get_ports {ddr3_dm[1]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[1]}]
set_property PACKAGE_PIN G2 [get_ports {ddr3_dm[1]}]

# PadFunction: IO_L16N_T2_35
set_property SLEW FAST [get_ports {ddr3_dm[2]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[2]}]
set_property PACKAGE_PIN M2 [get_ports {ddr3_dm[2]}]

# PadFunction: IO_L23N_T3_35
set_property SLEW FAST [get_ports {ddr3_dm[3]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[3]}]
set_property PACKAGE_PIN M5 [get_ports {ddr3_dm[3]}]

# PadFunction: IO_L13P_T2_MRCC_34

# PadFunction: IO_L13N_T2_MRCC_34

# PadFunction: IO_L3P_T0_DQS_AD5P_35
set_property SLEW FAST [get_ports {ddr3_dqs_p[0]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_p[0]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_dqs_p[0]}]

# PadFunction: IO_L3N_T0_DQS_AD5N_35
set_property SLEW FAST [get_ports {ddr3_dqs_n[0]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_n[0]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_dqs_n[0]}]
set_property PACKAGE_PIN D1 [get_ports {ddr3_dqs_n[0]}]
set_property PACKAGE_PIN E1 [get_ports {ddr3_dqs_p[0]}]

# PadFunction: IO_L9P_T1_DQS_AD7P_35
set_property SLEW FAST [get_ports {ddr3_dqs_p[1]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_p[1]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_dqs_p[1]}]

# PadFunction: IO_L9N_T1_DQS_AD7N_35
set_property SLEW FAST [get_ports {ddr3_dqs_n[1]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_n[1]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_dqs_n[1]}]
set_property PACKAGE_PIN J2 [get_ports {ddr3_dqs_n[1]}]
set_property PACKAGE_PIN K2 [get_ports {ddr3_dqs_p[1]}]

# PadFunction: IO_L15P_T2_DQS_35
set_property SLEW FAST [get_ports {ddr3_dqs_p[2]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_p[2]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_dqs_p[2]}]

# PadFunction: IO_L15N_T2_DQS_35
set_property SLEW FAST [get_ports {ddr3_dqs_n[2]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_n[2]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_dqs_n[2]}]
set_property PACKAGE_PIN L1 [get_ports {ddr3_dqs_n[2]}]
set_property PACKAGE_PIN M1 [get_ports {ddr3_dqs_p[2]}]

# PadFunction: IO_L21P_T3_DQS_35
set_property SLEW FAST [get_ports {ddr3_dqs_p[3]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_p[3]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_dqs_p[3]}]

# PadFunction: IO_L21N_T3_DQS_35
set_property SLEW FAST [get_ports {ddr3_dqs_n[3]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_n[3]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_dqs_n[3]}]
set_property PACKAGE_PIN P5 [get_ports {ddr3_dqs_p[3]}]
set_property PACKAGE_PIN P4 [get_ports {ddr3_dqs_n[3]}]

# PadFunction: IO_L3P_T0_DQS_34
set_property SLEW FAST [get_ports ddr3_ck_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports ddr3_ck_p]

# PadFunction: IO_L3N_T0_DQS_34
set_property SLEW FAST [get_ports ddr3_ck_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports ddr3_ck_n]
set_property PACKAGE_PIN R3 [get_ports ddr3_ck_p]
set_property PACKAGE_PIN R2 [get_ports ddr3_ck_n]



current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
current_instance -quiet
set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
current_instance -quiet
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
current_instance -quiet
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
current_instance -quiet
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
current_instance -quiet
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
current_instance -quiet
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
current_instance -quiet
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]

## set_property LOC PHASER_IN_PHY_X1Y7 [get_cells  -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
## set_property LOC PHASER_IN_PHY_X1Y6 [get_cells  -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
## set_property LOC PHASER_IN_PHY_X1Y5 [get_cells  -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
current_instance -quiet
set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
current_instance -quiet
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
current_instance -quiet
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]
current_instance -quiet
set_property LOC PHASER_IN_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_in_gen.phaser_in}]



current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
current_instance -quiet
set_property LOC OUT_FIFO_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
current_instance -quiet
set_property LOC OUT_FIFO_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
current_instance -quiet
set_property LOC OUT_FIFO_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
current_instance -quiet
set_property LOC OUT_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/out_fifo}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
current_instance -quiet
set_property LOC OUT_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/out_fifo}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
current_instance -quiet
set_property LOC OUT_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/out_fifo}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]
current_instance -quiet
set_property LOC OUT_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/out_fifo}]

current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
current_instance -quiet
set_property LOC IN_FIFO_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/in_fifo_gen.in_fifo}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
current_instance -quiet
set_property LOC IN_FIFO_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/in_fifo_gen.in_fifo}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
current_instance -quiet
set_property LOC IN_FIFO_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/in_fifo_gen.in_fifo}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]
current_instance -quiet
set_property LOC IN_FIFO_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/in_fifo_gen.in_fifo}]

current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
current_instance -quiet
set_property LOC PHY_CONTROL_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phy_control_i}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]
current_instance -quiet
set_property LOC PHY_CONTROL_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phy_control_i}]

current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
current_instance -quiet
set_property LOC PHASER_REF_X1Y1 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/phaser_ref_i}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]
current_instance -quiet
set_property LOC PHASER_REF_X1Y2 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/phaser_ref_i}]

current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
current_instance -quiet
set_property LOC OLOGIC_X1Y143 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/ddr_byte_group_io/*slave_ts}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
current_instance -quiet
set_property LOC OLOGIC_X1Y131 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/ddr_byte_group_io/*slave_ts}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
current_instance -quiet
set_property LOC OLOGIC_X1Y119 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/ddr_byte_group_io/*slave_ts}]
current_instance top_i/ppu_top_i/ddr3_if_inst/xilinx_ddr3_if_inst
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]
current_instance -quiet
set_property LOC OLOGIC_X1Y107 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/ddr_byte_group_io/*slave_ts}]



set_multicycle_path -setup -from [get_cells -hier -filter {NAME =~ */mc0/mc_read_idle_r_reg}] -to [get_cells -hier -filter {NAME =~ */input_[?].iserdes_dq_.iserdesdq}] 6

set_multicycle_path -hold -from [get_cells -hier -filter {NAME =~ */mc0/mc_read_idle_r_reg}] -to [get_cells -hier -filter {NAME =~ */input_[?].iserdes_dq_.iserdesdq}] 5



set_false_path -through [get_pins -filter {NAME =~ */DQSFOUND} -of [get_cells -hier -filter {REF_NAME == PHASER_IN_PHY}]]

set_multicycle_path -setup -start -through [get_pins -filter {NAME =~ */OSERDESRST} -of [get_cells -hier -filter {REF_NAME == PHASER_OUT_PHY}]] 2
set_multicycle_path -hold -start -through [get_pins -filter {NAME =~ */OSERDESRST} -of [get_cells -hier -filter {REF_NAME == PHASER_OUT_PHY}]] 1

set_max_delay -datapath_only -from [get_cells -hier -filter {NAME =~ *temp_mon_enabled.u_tempmon/* && IS_SEQUENTIAL}] -to [get_cells -hier -filter {NAME =~ *temp_mon_enabled.u_tempmon/device_temp_sync_r1*}] 20.000
set_max_delay -datapath_only -from [get_cells -hier *rstdiv0_sync_r1_reg*] -to [get_pins -filter {NAME =~ */RESET} -of [get_cells -hier -filter {REF_NAME == PHY_CONTROL}]] 5.000

set_max_delay -datapath_only -from [get_cells -hier -filter {NAME =~ *ddr3_infrastructure/rstdiv0_sync_r1_reg*}] -to [get_cells -hier -filter {NAME =~ *temp_mon_enabled.u_tempmon/xadc_supplied_temperature.rst_r1*}] 20.000


set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property IOSTANDARD LVCMOS33 [get_ports sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports sda1_io]
set_property IOSTANDARD LVCMOS33 [get_ports scl1_io]
set_max_delay -from [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage/U_DWC_mobile_storage_biu/U_DWC_mobile_storage_regb/uhs_reg_ext_reg[24]/C}] -to [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_clk_drv_phase_ctrl_reg[1]/D}] 2.600


set_max_delay -from [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage/U_DWC_mobile_storage_biu/U_DWC_mobile_storage_regb/uhs_reg_ext_reg[30]/C}] -to [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_ext_clk_mux_ctrl_reg[0]/D}] 2.900

set_max_delay -from [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage/U_DWC_mobile_storage_biu/U_DWC_mobile_storage_regb/uhs_reg_ext_reg[26]/C}] -to [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_clk_drv_phase_ctrl_reg[3]/D}] 2.900


set_max_delay -from [get_clocks clk50_o_xilinx_clock_manager_1] -to [get_clocks clk_pll_i] 3.000

set_max_delay -from [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage/U_DWC_mobile_storage_biu/U_DWC_mobile_storage_regb/uhs_reg_ext_reg[19]/C}] -to [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_clk_smpl_phase_ctrl_reg[3]/D}] 2.900

set_max_delay -from [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage/U_DWC_mobile_storage_biu/U_DWC_mobile_storage_regb/uhs_reg_ext_reg[19]/C}] -to [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_clk_smpl_phase_ctrl_reg[3]/D}] 2.900
set_max_delay -from [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage/U_DWC_mobile_storage_biu/U_DWC_mobile_storage_regb/uhs_reg_ext_reg[23]/C}] -to [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_clk_drv_phase_ctrl_reg[0]/D}] 2.900

set_max_delay -from [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage/U_DWC_mobile_storage_biu/U_DWC_mobile_storage_regb/uhs_reg_ext_reg[19]/C}] -to [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_clk_smpl_phase_ctrl_reg[3]/D}] 2.920


set_property IOSTANDARD LVCMOS33 [get_ports emmc_cclk_out]
set_property IOSTANDARD LVCMOS33 [get_ports emmc_ccmd]
set_property IOSTANDARD LVCMOS33 [get_ports {emmc_cdata[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {emmc_cdata[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {emmc_cdata[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {emmc_cdata[3]}]
set_max_delay -from [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage/U_DWC_mobile_storage_biu/U_DWC_mobile_storage_regb/uhs_reg_ext_reg[19]/C}] -to [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_clk_smpl_phase_ctrl_reg[3]/D}] 2.700
set_max_delay -from [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage/U_DWC_mobile_storage_biu/U_DWC_mobile_storage_regb/uhs_reg_ext_reg[18]/C}] -to [get_pins {top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DWC_mobile_storage_top/DWC_mobile_storage_clk_ctrl/r_clk_smpl_phase_ctrl_reg[2]/D}] 3.000

####################
##    GPIO  ############
####################
#gpio0-5 use for lcd 
set_property PACKAGE_PIN N14 [get_ports {gpio[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[0]}]
#gpio0-5 use for lcd 
set_property PACKAGE_PIN N13 [get_ports {gpio[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[1]}]
#gpio0-5 use for lcd
set_property PACKAGE_PIN D16 [get_ports {gpio[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[2]}]
#gpio0-5 use for lcd
set_property PACKAGE_PIN E17 [get_ports {gpio[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[3]}]
#gpio0-5 use for lcd 
set_property PACKAGE_PIN R14 [get_ports {gpio[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[4]}]
#gpio0-5 use for lcd 
set_property PACKAGE_PIN P14 [get_ports {gpio[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[5]}]

set_property PACKAGE_PIN AB22 [get_ports {gpio[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[6]}]

set_property PACKAGE_PIN R18 [get_ports {gpio[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[7]}]

set_property PACKAGE_PIN C15 [get_ports {gpio[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[8]}]

set_property PACKAGE_PIN V15 [get_ports {gpio[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[9]}]

set_property PACKAGE_PIN U15 [get_ports {gpio[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[10]}]

set_property PACKAGE_PIN V17 [get_ports {gpio[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[11]}]

set_property PACKAGE_PIN B17 [get_ports {gpio[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[12]}]

set_property PACKAGE_PIN AB21 [get_ports {gpio[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[13]}]

set_property PACKAGE_PIN AA20 [get_ports {gpio[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[14]}]

set_property PACKAGE_PIN AA21 [get_ports {gpio[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[15]}]

set_property PACKAGE_PIN AA19 [get_ports {gpio[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[16]}]

set_property PACKAGE_PIN AB20 [get_ports {gpio[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[17]}]

set_property PACKAGE_PIN AB18 [get_ports {gpio[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[18]}]

set_property PACKAGE_PIN AA18 [get_ports {gpio[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[19]}]

set_property PACKAGE_PIN Y17 [get_ports {gpio[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[20]}]

set_property PACKAGE_PIN T20 [get_ports {gpio[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[21]}]

set_property PACKAGE_PIN E18 [get_ports {gpio[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[22]}]

set_property PACKAGE_PIN A20 [get_ports {gpio[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[23]}]

set_property PACKAGE_PIN A18 [get_ports {gpio[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[24]}]

set_property PACKAGE_PIN F19 [get_ports {gpio[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[25]}]

set_property PACKAGE_PIN A19 [get_ports {gpio[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[26]}]

set_property PACKAGE_PIN F20 [get_ports {gpio[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[27]}]

set_property PACKAGE_PIN D20 [get_ports {gpio[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[28]}]

set_property PACKAGE_PIN C22 [get_ports {gpio[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[29]}]

set_property PACKAGE_PIN C20 [get_ports {gpio[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[30]}]

set_property PACKAGE_PIN B22 [get_ports {gpio[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[31]}]

#J6-25
set_property PACKAGE_PIN F18 [get_ports {cam_d[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_d[0]}]
#J6-26
set_property PACKAGE_PIN B20 [get_ports {cam_d[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_d[1]}]
#J6-23
set_property PACKAGE_PIN C19 [get_ports {cam_d[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_d[2]}]
#J6-24
set_property PACKAGE_PIN D19 [get_ports {cam_d[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_d[3]}]
#J6-21
set_property PACKAGE_PIN C18 [get_ports {cam_d[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_d[4]}]
#J6-22
set_property PACKAGE_PIN E19 [get_ports {cam_d[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_d[5]}]
#J6-17
set_property PACKAGE_PIN B18 [get_ports {cam_d[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_d[6]}]
#J6-18
set_property PACKAGE_PIN C17 [get_ports {cam_d[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_d[7]}]

#J6-16
set_property PACKAGE_PIN D17 [get_ports pclk]
set_property IOSTANDARD LVCMOS33 [get_ports pclk]
#J6-14
set_property PACKAGE_PIN A14 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]
#j6-13
set_property PACKAGE_PIN A16 [get_ports href]
set_property IOSTANDARD LVCMOS33 [get_ports href]

#J6-12
set_property PACKAGE_PIN A13 [get_ports scl1_io]
#J6-11
set_property PACKAGE_PIN A15 [get_ports sda1_io]

set_property PACKAGE_PIN T16 [get_ports sda_io]
set_property PACKAGE_PIN U16 [get_ports scl_io]
set_property PACKAGE_PIN R16 [get_ports emmc_cclk_out]
set_property PACKAGE_PIN R17 [get_ports emmc_ccmd]
set_property PACKAGE_PIN P15 [get_ports {emmc_cdata[0]}]
set_property PACKAGE_PIN P20 [get_ports {emmc_cdata[2]}]
set_property PACKAGE_PIN P16 [get_ports {emmc_cdata[3]}]
set_property PACKAGE_PIN N17 [get_ports {emmc_cdata[1]}]

set_property PULLUP true [get_ports scl_io]
set_property PULLUP true [get_ports sda_io]

set_property PULLUP true [get_ports scl1_io]
set_property PULLUP true [get_ports sda1_io]

###############
#### clock ####
###############
set_property PACKAGE_PIN R4 [get_ports clk_p]
set_property PACKAGE_PIN T4 [get_ports clk_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_p]

###############
#### reset ####
###############
set_property PACKAGE_PIN T6 [get_ports rst_n]
set_property IOSTANDARD LVCMOS15 [get_ports rst_n]


##########
## uart ##
##########
#J7.1: B13_L16_P
set_property PACKAGE_PIN W15 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]

#J7.2: B13_L16_N
set_property PACKAGE_PIN W16 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]




####################
##    SPI  master flash   ##
####################
set_property PACKAGE_PIN G16 [get_ports spi_master_clk_o]
set_property IOSTANDARD LVCMOS18 [get_ports spi_master_clk_o]

set_property PACKAGE_PIN J19 [get_ports spi_master_csn0_o]
set_property IOSTANDARD LVCMOS18 [get_ports spi_master_csn0_o]
#IO0
set_property PACKAGE_PIN G17 [get_ports spi_master_sdo0_o]
set_property IOSTANDARD LVCMOS18 [get_ports spi_master_sdo0_o]
#IO1
set_property PACKAGE_PIN H19 [get_ports spi_master_sdi0_i]
set_property IOSTANDARD LVCMOS18 [get_ports spi_master_sdi0_i]
#IO2: G15, LVCMOS18
#IO3: G18, LVCMOS18

####################
##    SPI  master 1   ##
####################
#CLK J7-1
set_property PACKAGE_PIN E16 [get_ports spi1_master_clk_o]
#CS J7-6
set_property PACKAGE_PIN C14 [get_ports spi1_master_csn0_o]
#MISO J7-5
set_property PACKAGE_PIN B15 [get_ports spi1_master_sdi0_i]
#MOSI J7-2
set_property PACKAGE_PIN F16 [get_ports spi1_master_sdo0_o]

set_property IOSTANDARD LVCMOS33 [get_ports spi1_master_clk_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi1_master_csn0_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi1_master_sdi0_i]
set_property IOSTANDARD LVCMOS33 [get_ports spi1_master_sdo0_o]

####################
##    SPI  slave    ##
####################

#J7-7
set_property PACKAGE_PIN W11 [get_ports spi_sck]
#J7-8
set_property PACKAGE_PIN W12 [get_ports spi_csn]
#J7-9
set_property PACKAGE_PIN Y11 [get_ports spi_sdo0]
#J7-10
set_property PACKAGE_PIN Y12 [get_ports spi_sdi0]

set_property IOSTANDARD LVCMOS33 [get_ports spi_sck]
set_property IOSTANDARD LVCMOS33 [get_ports spi_csn]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sdo0]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sdi0]

set_false_path -from [get_clocks clk50_o_xilinx_clock_manager_1] -to [get_clocks pclk]


set_false_path -from [get_clocks pclk] -to [get_clocks clk50_o_xilinx_clock_manager_1]

