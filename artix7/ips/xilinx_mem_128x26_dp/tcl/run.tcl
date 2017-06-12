
if { ![info exists ::env(XILINX_PART)] } {
  set ::env(XILINX_PART) "xc7a100tfgg484-2"
}

set partNumber $::env(XILINX_PART)

set ip_name xilinx_mem_128x26_dp

create_project $ip_name . -part $partNumber

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $ip_name

set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Write_Width_A {26} CONFIG.Write_Depth_A {128} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Collision_Warnings {NONE} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Read_Width_A {26} CONFIG.Write_Width_B {26} CONFIG.Read_Width_B {26} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Port_B_Enable_Rate {100}] [get_ips ${ip_name}]

generate_target all [get_files ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

launch_run -jobs 8 ${ip_name}_synth_1

wait_on_run ${ip_name}_synth_1
