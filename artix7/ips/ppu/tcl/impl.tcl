set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

###############
#### clock ####
###############
set_property PACKAGE_PIN   R4        [get_ports clk_p]
set_property IOSTANDARD DIFF_SSTL15  [get_ports clk_p]

###############
#### reset ####
###############
set_property PACKAGE_PIN   T6      [get_ports rst_n]
set_property IOSTANDARD LVCMOS15   [get_ports rst_n]

################
#### memctl ####
################
set_property PACKAGE_PIN   M21     [get_ports memctl_s_ck_p]
set_property PACKAGE_PIN   L21     [get_ports memctl_s_ck_n]
set_property PACKAGE_PIN   G20     [get_ports memctl_s_sel_n]
set_property PACKAGE_PIN   K22     [get_ports memctl_s_cke]
set_property PACKAGE_PIN   E22     [get_ports memctl_s_ras_n]
set_property PACKAGE_PIN   D22     [get_ports memctl_s_cas_n]
set_property PACKAGE_PIN   G22     [get_ports memctl_s_we_n]
set_property PACKAGE_PIN   B21     [get_ports {memctl_s_addr[0]}]
set_property PACKAGE_PIN   A21     [get_ports {memctl_s_addr[1]}]
set_property PACKAGE_PIN   M17     [get_ports {memctl_s_addr[2]}]
set_property PACKAGE_PIN   F21     [get_ports {memctl_s_addr[3]}]
set_property PACKAGE_PIN   H17     [get_ports {memctl_s_addr[4]}]
set_property PACKAGE_PIN   K19     [get_ports {memctl_s_addr[5]}]
set_property PACKAGE_PIN   H18     [get_ports {memctl_s_addr[6]}]
set_property PACKAGE_PIN   N22     [get_ports {memctl_s_addr[7]}]
set_property PACKAGE_PIN   H22     [get_ports {memctl_s_addr[8]}]
set_property PACKAGE_PIN   M22     [get_ports {memctl_s_addr[9]}]
set_property PACKAGE_PIN   H20     [get_ports {memctl_s_addr[10]}]
set_property PACKAGE_PIN   K21     [get_ports {memctl_s_addr[11]}]
set_property PACKAGE_PIN   J22     [get_ports {memctl_s_addr[12]}]
set_property PACKAGE_PIN   G21     [get_ports {memctl_s_addr[13]}]
set_property PACKAGE_PIN   D21     [get_ports {memctl_s_bank_addr[0]}]
set_property PACKAGE_PIN   E21     [get_ports {memctl_s_bank_addr[1]}]
set_property PACKAGE_PIN   K14     [get_ports {memctl_s_dqm[0]}]
set_property PACKAGE_PIN   M16     [get_ports {memctl_s_dqm[1]}]
set_property PACKAGE_PIN   K13     [get_ports {memctl_s_dqs[0]}]
set_property PACKAGE_PIN   M15     [get_ports {memctl_s_dqs[1]}]
set_property PACKAGE_PIN   J20     [get_ports {memctl_s_dq[0]}]
set_property PACKAGE_PIN   J21     [get_ports {memctl_s_dq[1]}]
set_property PACKAGE_PIN   G13     [get_ports {memctl_s_dq[2]}]
set_property PACKAGE_PIN   H13     [get_ports {memctl_s_dq[3]}]
set_property PACKAGE_PIN   J15     [get_ports {memctl_s_dq[4]}]
set_property PACKAGE_PIN   H15     [get_ports {memctl_s_dq[5]}]
set_property PACKAGE_PIN   H14     [get_ports {memctl_s_dq[6]}]
set_property PACKAGE_PIN   J14     [get_ports {memctl_s_dq[7]}]
set_property PACKAGE_PIN   L15     [get_ports {memctl_s_dq[8]}]
set_property PACKAGE_PIN   L14     [get_ports {memctl_s_dq[9]}]
set_property PACKAGE_PIN   K16     [get_ports {memctl_s_dq[10]}]
set_property PACKAGE_PIN   L16     [get_ports {memctl_s_dq[11]}]
set_property PACKAGE_PIN   J17     [get_ports {memctl_s_dq[12]}]
set_property PACKAGE_PIN   K17     [get_ports {memctl_s_dq[13]}]
set_property PACKAGE_PIN   L13     [get_ports {memctl_s_dq[14]}]
set_property PACKAGE_PIN   M13     [get_ports {memctl_s_dq[15]}]
set_property PACKAGE_PIN   L19     [get_ports memctl_s_rd_dqs_mask]
set_property PACKAGE_PIN   L20     [get_ports memctl_int_rd_dqs_mask]

set_property IOSTANDARD  LVCMOS18        [get_ports memctl_s_ck_p]
set_property IOSTANDARD  LVCMOS18        [get_ports memctl_s_ck_n]
set_property IOSTANDARD  LVCMOS18        [get_ports memctl_s_sel_n]
set_property IOSTANDARD  LVCMOS18        [get_ports memctl_s_cke]
set_property IOSTANDARD  LVCMOS18        [get_ports memctl_s_ras_n]
set_property IOSTANDARD  LVCMOS18        [get_ports memctl_s_cas_n]
set_property IOSTANDARD  LVCMOS18        [get_ports memctl_s_we_n]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[0]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[1]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[2]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[3]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[4]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[5]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[6]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[7]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[8]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[9]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[10]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[11]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[12]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_addr[13]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_bank_addr[0]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_bank_addr[1]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dqm[0]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dqm[1]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dqs[0]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dqs[1]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[0]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[1]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[2]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[3]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[4]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[5]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[6]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[7]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[8]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[9]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[10]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[11]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[12]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[13]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[14]}]
set_property IOSTANDARD  LVCMOS18        [get_ports {memctl_s_dq[15]}]
set_property IOSTANDARD  LVCMOS18        [get_ports memctl_s_rd_dqs_mask]
set_property IOSTANDARD  LVCMOS18        [get_ports memctl_int_rd_dqs_mask]

##########
## uart ##
##########
#J7.1: B13_L16_P
set_property PACKAGE_PIN  W15        [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33   [get_ports uart_tx]

#J7.2: B13_L16_N
set_property PACKAGE_PIN  W16      [get_ports uart_rx]
set_property IOSTANDARD  LVCMOS33       [get_ports uart_rx]


##########
## gpio ##
##########
#J1.18
set_property PACKAGE_PIN  AB15     [get_ports gpio0]
set_property IOSTANDARD  LVCMOS33      [get_ports gpio0]

####################
##    SPI flash   ##
####################
set_property PACKAGE_PIN  G16      [get_ports spi_sck]
set_property IOSTANDARD  LVCMOS18        [get_ports spi_sck]

set_property PACKAGE_PIN  J19      [get_ports spi_csn]
set_property IOSTANDARD  LVCMOS18        [get_ports spi_csn]
#IO0
set_property PACKAGE_PIN  G17      [get_ports spi_sdo]
set_property IOSTANDARD  LVCMOS18        [get_ports spi_sdo]
#IO1
set_property PACKAGE_PIN  H19      [get_ports spi_sdi]
set_property IOSTANDARD  LVCMOS18        [get_ports spi_sdi]
#IO2: G15, LVCMOS18
#IO3: G18, LVCMOS18

####################
##    I2C EEPROM  ##
####################
set_property PACKAGE_PIN  T16      [get_ports sda]
set_property IOSTANDARD  LVCMOS33        [get_ports sda]

set_property PACKAGE_PIN  U16      [get_ports scl]
set_property IOSTANDARD  LVCMOS33        [get_ports scl]


launch_runs impl_1
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

# report area utilization
report_utilization -hierarchical -hierarchical_depth 1 -file fpga_top_utilization_summary.txt
report_utilization -hierarchical -hierarchical_depth 2 -cells top_i -file top_utilization.txt

report_timing_summary -file fpga_top_timing_summary.txt
report_timing         -file fpga_top_timing.txt         -max_paths 10

# output Verilog netlist + SDC for timing simulation
write_verilog -force -mode timesim -cell top_i simu/top_impl.v
write_sdf     -force -cell top_i simu/top_impl.sdf

