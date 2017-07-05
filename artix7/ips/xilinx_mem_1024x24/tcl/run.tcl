
if { ![info exists ::env(XILINX_PART)] } {
  set ::env(XILINX_PART) "xc7a100tfgg484-2"
}

set partNumber $::env(XILINX_PART)

set ip_name xilinx_mem_1024x24

create_project $ip_name . -part $partNumber

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $ip_name

set_property -dict [list CONFIG.Write_Width_A {24} CONFIG.Write_Depth_A {1024} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Read_Width_A {24} CONFIG.Write_Width_B {24} CONFIG.Read_Width_B {24}] [get_ips ${ip_name}]

generate_target all [get_files ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

launch_run -jobs 8 ${ip_name}_synth_1

wait_on_run ${ip_name}_synth_1

open_run ${ip_name}_synth_1

write_verilog -force -mode funcsim ${ip_name}_funcsim.v
