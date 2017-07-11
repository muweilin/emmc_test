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
####################
##    SPI slave flash   ##
####################
#set_property PACKAGE_PIN   L12      [get_ports spi_sck]
#set_property IOSTANDARD  LVCMOS18        [get_ports spi_sck]
#
#set_property PACKAGE_PIN  T19      [get_ports spi_csn]
#set_property IOSTANDARD  LVCMOS18        [get_ports spi_csn]
##IO0
#set_property PACKAGE_PIN   P22      [get_ports spi_sdo0]
#set_property IOSTANDARD  LVCMOS18        [get_ports spi_sdo0]
##IO1
#set_property PACKAGE_PIN  R22      [get_ports spi_sdi0]
#set_property IOSTANDARD  LVCMOS18        [get_ports spi_sdi0]

####################
##    I2C EEPROM  ##
####################
set_property PACKAGE_PIN  T16      [get_ports sda_io]
set_property IOSTANDARD  LVCMOS33        [get_ports sda_io]

set_property PACKAGE_PIN  U16      [get_ports scl_io]
set_property IOSTANDARD  LVCMOS33        [get_ports scl_io]

####################
##    emmc  ##
####################
set_property PACKAGE_PIN   R16      [get_ports emmc_cclk_out]
set_property IOSTANDARD  LVCMOS33        [get_ports emmc_cclk_out]

set_property PACKAGE_PIN  R17      [get_ports emmc_ccmd]
set_property IOSTANDARD  LVCMOS33        [get_ports emmc_ccmd]

#set_property PACKAGE_PIN   P17      [get_ports sdio_card_int_n]
#set_property IOSTANDARD  LVCMOS33        [get_ports sdio_card_int_n]

set_property PACKAGE_PIN  P15      [get_ports emmc_cdata[0]]
set_property IOSTANDARD  LVCMOS33        [get_ports emmc_cdata[0]]

set_property PACKAGE_PIN  N17      [get_ports emmc_cdata[1]]
set_property IOSTANDARD  LVCMOS33        [get_ports emmc_cdata[1]]

set_property PACKAGE_PIN  P20      [get_ports emmc_cdata[2]]
set_property IOSTANDARD  LVCMOS33        [get_ports emmc_cdata[2]]

set_property PACKAGE_PIN  P16      [get_ports emmc_cdata[3]]
set_property IOSTANDARD  LVCMOS33        [get_ports emmc_cdata[3]]



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

