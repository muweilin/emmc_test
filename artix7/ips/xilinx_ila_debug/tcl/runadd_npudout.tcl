
if { ![info exists ::env(XILINX_PART)] } {
  set ::env(XILINX_PART) "xc7v2000tflg1925-1"
}

set partNumber $::env(XILINX_PART)

set ip_name xilinx_ila_debug

create_project $ip_name . -part $partNumber

create_ip -name ila -vendor xilinx.com -library ip -module_name $ip_name


set_property -dict [list CONFIG.C_DATA_DEPTH {32768} CONFIG.C_NUM_OF_PROBES {16} CONFIG.C_INPUT_PIPE_STAGES {5} CONFIG.C_PROBE15_WIDTH {32} CONFIG.C_PROBE14_WIDTH {32} CONFIG.C_PROBE13_WIDTH {1} CONFIG.C_PROBE12_WIDTH {1} CONFIG.C_PROBE11_WIDTH {32} CONFIG.C_PROBE10_WIDTH {32} CONFIG.C_PROBE9_WIDTH {2} CONFIG.C_PROBE8_WIDTH {1} CONFIG.C_PROBE7_WIDTH {6} CONFIG.C_PROBE6_WIDTH {14} CONFIG.C_PROBE5_WIDTH {21} CONFIG.C_PROBE4_WIDTH {1} CONFIG.C_PROBE3_WIDTH {32} CONFIG.C_PROBE2_WIDTH {1} CONFIG.C_PROBE1_WIDTH {32} CONFIG.C_PROBE0_WIDTH {1}] [get_ips ${ip_name}]

generate_target all [get_files ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] ./$ip_name.srcs/sources_1/ip/$ip_name/$ip_name.xci]

launch_run -jobs 8 ${ip_name}_synth_1

wait_on_run ${ip_name}_synth_1
