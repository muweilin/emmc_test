
if { ![info exists ::env(XILINX_PART)] } {
  set ::env(XILINX_PART) "xc7a100tfgg484-2"
}

set partNumber $::env(XILINX_PART)

set ip_name xilinx_ila_debug

create_project $ip_name . -part $partNumber

create_ip -name ila -vendor xilinx.com -library ip -module_name $ip_name


set_property -dict [list CONFIG.C_DATA_DEPTH {8192} CONFIG.C_NUM_OF_PROBES {3} CONFIG.C_INPUT_PIPE_STAGES {5}  CONFIG.C_PROBE1_WIDTH {1} CONFIG.C_PROBE1_WIDTH {1} CONFIG.C_PROBE1_WIDTH {4}] [get_ips ${ip_name}]

generate_target all [get_files ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

launch_run -jobs 8 ${ip_name}_synth_1

wait_on_run ${ip_name}_synth_1
