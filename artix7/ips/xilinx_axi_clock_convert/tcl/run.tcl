if { ![info exists ::env(XILINX_PART)] } {
  set ::env(XILINX_PART) "xc7a100tfgg484-2"
}

set partNumber $::env(XILINX_PART)

set ip_name xilinx_axi_clock_converter

create_project $ip_name . -part $partNumber

create_ip -name axi_clock_converter -vendor xilinx.com -library ip  -module_name $ip_name
set_property -dict [list CONFIG.ID_WIDTH {16}] [get_ips $ip_name]

generate_target {instantiation_template} [get_files ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

generate_target all [get_files  ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

launch_run -jobs 8 ${ip_name}_synth_1

wait_on_run ${ip_name}_synth_1

open_run ${ip_name}_synth_1

write_verilog -force -mode funcsim ${ip_name}_funcsim.v
