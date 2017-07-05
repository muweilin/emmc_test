
if { ![info exists ::env(XILINX_PART)] } {
  set ::env(XILINX_PART) "xc7a100tfgg484-2"
}

set partNumber $::env(XILINX_PART)

set ip_name h2x_bridge

create_project $ip_name . -part $partNumber

create_ip -name ahblite_axi_bridge -vendor xilinx.com -library ip -version 3.0 -module_name $ip_name

set_property -dict [list CONFIG.C_M_AXI_THREAD_ID_WIDTH {8} CONFIG.C_S_AHB_DATA_WIDTH {32} CONFIG.C_M_AXI_DATA_WIDTH {32} CONFIG.C_M_AXI_SUPPORTS_NARROW_BURST {1}] [get_ips $ip_name]

generate_target {instantiation_template} [get_files ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

generate_target all [get_files  ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

launch_run -jobs 8 ${ip_name}_synth_1

wait_on_run ${ip_name}_synth_1

open_run ${ip_name}_synth_1

write_verilog -force -mode funcsim ${ip_name}_funcsim.v

