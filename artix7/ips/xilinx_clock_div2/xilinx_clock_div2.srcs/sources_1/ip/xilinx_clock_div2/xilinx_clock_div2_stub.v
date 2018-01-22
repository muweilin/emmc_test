// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Fri Jan 19 16:22:00 2018
// Host        : fyh-OptiPlex-3020 running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/fyh/emmc_test/artix7-board/artix7/ips/xilinx_clock_div2/xilinx_clock_div2.srcs/sources_1/ip/xilinx_clock_div2/xilinx_clock_div2_stub.v
// Design      : xilinx_clock_div2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module xilinx_clock_div2(clk50_i, clk5_o, rstn_i, locked)
/* synthesis syn_black_box black_box_pad_pin="clk50_i,clk5_o,rstn_i,locked" */;
  input clk50_i;
  output clk5_o;
  input rstn_i;
  output locked;
endmodule
