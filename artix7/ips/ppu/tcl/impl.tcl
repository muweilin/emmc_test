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


##########
## uart ##
##########
#J7.1: B13_L16_P
set_property PACKAGE_PIN  W15        [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33   [get_ports uart_tx]

#J7.2: B13_L16_N
set_property PACKAGE_PIN  W16      [get_ports uart_rx]
set_property IOSTANDARD  LVCMOS33       [get_ports uart_rx]




####################
##    SPI  master flash   ##
####################
set_property PACKAGE_PIN   G16    [get_ports spi_master_clk_o]
set_property IOSTANDARD  LVCMOS18        [get_ports spi_master_clk_o]

set_property PACKAGE_PIN    J19    [get_ports spi_master_csn0_o]
set_property IOSTANDARD  LVCMOS18        [get_ports spi_master_csn0_o]
#IO0
set_property PACKAGE_PIN   G17    [get_ports spi_master_sdo0_o]
set_property IOSTANDARD  LVCMOS18        [get_ports spi_master_sdo0_o]
#IO1
set_property PACKAGE_PIN     H19   [get_ports spi_master_sdi0_i]
set_property IOSTANDARD  LVCMOS18        [get_ports spi_master_sdi0_i]
#IO2: G15, LVCMOS18
#IO3: G18, LVCMOS18





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

