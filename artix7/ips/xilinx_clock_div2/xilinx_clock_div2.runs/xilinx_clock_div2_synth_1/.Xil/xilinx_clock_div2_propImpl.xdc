set_property SRC_FILE_INFO {cfile:/home/fyh/emmc_test/artix7-board/artix7/ips/xilinx_clock_div2/xilinx_clock_div2.srcs/sources_1/ip/xilinx_clock_div2/xilinx_clock_div2.xdc rfile:../../../xilinx_clock_div2.srcs/sources_1/ip/xilinx_clock_div2/xilinx_clock_div2.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:56 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk50_i]] 0.2
