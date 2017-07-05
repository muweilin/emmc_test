if { ![info exists ::env(XILINX_PART)] } {
  set ::env(XILINX_PART) "xc7a100tfgg484-2"
}

set partNumber $::env(XILINX_PART)

set ip_name xilinx_clock_manager

create_project $ip_name . -part $partNumber

create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name $ip_name

#set_property -dict [list CONFIG.USE_DYN_RECONFIG {false} CONFIG.PRIM_IN_FREQ {100.000} CONFIG.CLKOUT2_USED {true} CONFIG.CLKOUT3_USED {true} CONFIG.CLKOUT4_USED {true} CONFIG.CLKOUT5_USED {true} CONFIG.CLKOUT6_USED {true} CONFIG.PRIMARY_PORT {clk100_i} CONFIG.CLK_OUT1_PORT {clk300_o} CONFIG.CLK_OUT2_PORT {clk200_o} CONFIG.CLK_OUT3_PORT {clk150_o} CONFIG.CLK_OUT4_PORT {clk100_o} CONFIG.CLK_OUT5_PORT {clk50_o} CONFIG.CLK_OUT6_PORT {clk25_o} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {300.000} CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {150.000} CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {100.000} CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {50.000} CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {25.000} CONFIG.LOCKED_PORT {locked} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.RESET_PORT {rstn_i}] [get_ips $ip_name]
set_property -dict [list CONFIG.USE_DYN_RECONFIG {false} CONFIG.PRIM_IN_FREQ {100.000}  CONFIG.PRIMARY_PORT {clk100_i} CONFIG.CLK_OUT1_PORT {clk50_o}  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000}  CONFIG.LOCKED_PORT {locked} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.RESET_PORT {rstn_i}] [get_ips $ip_name]

generate_target {instantiation_template} [get_files ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

generate_target all [get_files  ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

launch_run -jobs 8 ${ip_name}_synth_1

wait_on_run ${ip_name}_synth_1

open_run ${ip_name}_synth_1

write_verilog -force -mode funcsim ${ip_name}_funcsim.v
