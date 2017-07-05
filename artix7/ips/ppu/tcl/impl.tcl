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

#################
##### memctl ####
#################
#set_property PACKAGE_PIN    C2    [get_ports ddr3_dq[0] ]
#set_property PACKAGE_PIN    G1    [get_ports ddr3_dq[1] ]
#set_property PACKAGE_PIN    A1    [get_ports ddr3_dq[2] ]
#set_property PACKAGE_PIN    F3    [get_ports ddr3_dq[3] ]
#set_property PACKAGE_PIN    B2    [get_ports ddr3_dq[4] ]
#set_property PACKAGE_PIN    F1    [get_ports ddr3_dq[5] ]
#set_property PACKAGE_PIN    B1    [get_ports ddr3_dq[6] ]
#set_property PACKAGE_PIN    E2    [get_ports ddr3_dq[7] ]
#set_property PACKAGE_PIN    H3    [get_ports ddr3_dq[8] ]
#set_property PACKAGE_PIN    G3    [get_ports ddr3_dq[9] ]
#set_property PACKAGE_PIN    H2    [get_ports ddr3_dq[10]]
#set_property PACKAGE_PIN    H5    [get_ports ddr3_dq[11]]
#set_property PACKAGE_PIN    J1    [get_ports ddr3_dq[12]]
#set_property PACKAGE_PIN    J5    [get_ports ddr3_dq[13]]
#set_property PACKAGE_PIN    K1    [get_ports ddr3_dq[14]]
#set_property PACKAGE_PIN    H4    [get_ports ddr3_dq[15]]
#set_property PACKAGE_PIN    L4    [get_ports ddr3_dq[16]]
#set_property PACKAGE_PIN    M3    [get_ports ddr3_dq[17]]
#set_property PACKAGE_PIN    L3    [get_ports ddr3_dq[18]]
#set_property PACKAGE_PIN    J6    [get_ports ddr3_dq[19]]
#set_property PACKAGE_PIN    K3    [get_ports ddr3_dq[20]]
#set_property PACKAGE_PIN    K6    [get_ports ddr3_dq[21]]
#set_property PACKAGE_PIN    J4    [get_ports ddr3_dq[22]]
#set_property PACKAGE_PIN    L5    [get_ports ddr3_dq[23]]
#set_property PACKAGE_PIN    P1    [get_ports ddr3_dq[24]]
#set_property PACKAGE_PIN    N4    [get_ports ddr3_dq[25]]
#set_property PACKAGE_PIN    R1    [get_ports ddr3_dq[26]  ]
#set_property PACKAGE_PIN    N2    [get_ports ddr3_dq[27]  ]
#set_property PACKAGE_PIN    M6    [get_ports ddr3_dq[28]  ]
#set_property PACKAGE_PIN    N5    [get_ports ddr3_dq[29]  ]
#set_property PACKAGE_PIN    P6    [get_ports ddr3_dq[30]  ]
#set_property PACKAGE_PIN    P2    [get_ports ddr3_dq[31]  ]
#set_property PACKAGE_PIN    D2    [get_ports ddr3_dm[0]   ]
#set_property PACKAGE_PIN    G2    [get_ports ddr3_dm[1]   ]
#set_property PACKAGE_PIN    M2    [get_ports ddr3_dm[2]   ]
#set_property PACKAGE_PIN    M5    [get_ports ddr3_dm[3]   ]
#set_property PACKAGE_PIN    E1    [get_ports ddr3_dqs_p[0]]
#set_property PACKAGE_PIN    D1    [get_ports ddr3_dqs_n[0]]
#set_property PACKAGE_PIN    K2    [get_ports ddr3_dqs_p[1]]
#set_property PACKAGE_PIN    J2    [get_ports ddr3_dqs_n[1]]
#set_property PACKAGE_PIN    M1    [get_ports ddr3_dqs_p[2]]
#set_property PACKAGE_PIN    L1    [get_ports ddr3_dqs_n[2]]
#set_property PACKAGE_PIN    P5    [get_ports ddr3_dqs_p[3]]
#set_property PACKAGE_PIN    P4    [get_ports ddr3_dqs_n[3]]
#set_property PACKAGE_PIN    V3    [get_ports ddr3_addr[14]]
#set_property PACKAGE_PIN    U1    [get_ports ddr3_addr[13]]
#set_property PACKAGE_PIN    Y2    [get_ports ddr3_addr[12]]
#set_property PACKAGE_PIN    W2    [get_ports ddr3_addr[11]]
#set_property PACKAGE_PIN    Y1    [get_ports ddr3_addr[10]]
#set_property PACKAGE_PIN    U2    [get_ports ddr3_addr[9]]
#set_property PACKAGE_PIN    V2    [get_ports ddr3_addr[8]]
#set_property PACKAGE_PIN    T1    [get_ports ddr3_addr[7]]
#set_property PACKAGE_PIN    W1     [get_ports ddr3_addr[6]]
#set_property PACKAGE_PIN    U3     [get_ports ddr3_addr[5]]
#set_property PACKAGE_PIN    AB1    [get_ports ddr3_addr[4]]
#set_property PACKAGE_PIN    AB5    [get_ports ddr3_addr[3]]
#set_property PACKAGE_PIN    AA5    [get_ports ddr3_addr[2]]
#set_property PACKAGE_PIN    AB2    [get_ports ddr3_addr[1]]
#set_property PACKAGE_PIN    AA4    [get_ports ddr3_addr[0]]
#set_property PACKAGE_PIN    Y4     [get_ports ddr3_ba[2]  ]
#set_property PACKAGE_PIN    Y3     [get_ports ddr3_ba[1]  ]
#set_property PACKAGE_PIN    AA3    [get_ports ddr3_ba[0]  ]
#set_property PACKAGE_PIN    R3     [get_ports ddr3_ck_p[0]]
#set_property PACKAGE_PIN    R2     [get_ports ddr3_ck_n[0]]
#set_property PACKAGE_PIN    V4     [get_ports ddr3_ras_n  ]
#set_property PACKAGE_PIN    W4     [get_ports ddr3_cas_n  ]
#set_property PACKAGE_PIN    AA1    [get_ports ddr3_we_n   ]
#set_property PACKAGE_PIN    W6     [get_ports ddr3_reset_n]
#set_property PACKAGE_PIN    T5     [get_ports ddr3_cke[0] ]
#set_property PACKAGE_PIN    U5     [get_ports ddr3_odt[0] ]
#set_property PACKAGE_PIN    AB3    [get_ports ddr3_cs_n[0]]
#
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[0] ]      
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[1] ]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[2] ]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[3] ]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[4] ]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[5] ]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[6] ]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[7] ]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[8] ]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[9] ]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[10]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[11]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[12]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[13]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[14]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[15]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[16]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[17]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[18]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[19]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[20]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[21]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[22]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[23]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[24]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[25]]    
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[26]  ]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[27]  ]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[28]  ]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[29]  ]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[30]  ]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dq[31]  ]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dm[0]   ]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dm[1]   ]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dm[2]   ]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_dm[3]   ]  
#set_property IOSTANDARD  DIFF_SSTL15  [get_ports ddr3_dqs_p[0]]  
#set_property IOSTANDARD  DIFF_SSTL15  [get_ports ddr3_dqs_n[0]]  
#set_property IOSTANDARD  DIFF_SSTL15  [get_ports ddr3_dqs_p[1]]  
#set_property IOSTANDARD  DIFF_SSTL15  [get_ports ddr3_dqs_n[1]]  
#set_property IOSTANDARD  DIFF_SSTL15  [get_ports ddr3_dqs_p[2]]  
#set_property IOSTANDARD  DIFF_SSTL15  [get_ports ddr3_dqs_n[2]]  
#set_property IOSTANDARD  DIFF_SSTL15  [get_ports ddr3_dqs_p[3]]  
#set_property IOSTANDARD  DIFF_SSTL15  [get_ports ddr3_dqs_n[3]]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_addr[14]]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_addr[13]]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_addr[12]]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_addr[11]]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_addr[10]]  
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_addr[9]]   
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_addr[8]]   
#set_property IOSTANDARD  SSTL15       [get_ports ddr3_addr[7]]   
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_addr[6]]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_addr[5]]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_addr[4]]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_addr[3]]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_addr[2]]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_addr[1]]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_addr[0]]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_ba[2]  ]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_ba[1]  ]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_ba[0]  ]  
#set_property IOSTANDARD  DIFF_SSTL15   [get_ports ddr3_ck_p[0]]  
#set_property IOSTANDARD  DIFF_SSTL15   [get_ports ddr3_ck_n[0]]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_ras_n  ]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_cas_n  ]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_we_n   ]  
#set_property IOSTANDARD  LVCMOS15      [get_ports ddr3_reset_n]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_cke[0] ]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_odt[0] ]  
#set_property IOSTANDARD  SSTL15        [get_ports ddr3_cs_n[0]]  

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
set_property PACKAGE_PIN  G17      [get_ports spi_sdo0]
set_property IOSTANDARD  LVCMOS18        [get_ports spi_sdo0]
#IO1
set_property PACKAGE_PIN  H19      [get_ports spi_sdi0]
set_property IOSTANDARD  LVCMOS18        [get_ports spi_sdi0]
#IO2: G15, LVCMOS18
#IO3: G18, LVCMOS18

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

set_property PACKAGE_PIN   P17      [get_ports sdio_card_int_n]
set_property IOSTANDARD  LVCMOS33        [get_ports sdio_card_int_n]

set_property PACKAGE_PIN  N13      [get_ports emmc_cdata[0]]
set_property IOSTANDARD  LVCMOS33        [get_ports emmc_cdata[0]]

set_property PACKAGE_PIN  P15      [get_ports emmc_cdata[1]]
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

