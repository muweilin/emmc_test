// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Thu Jul  6 17:18:50 2017
// Host        : wusystem-server running 64-bit Ubuntu 14.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/hetingting/artix7-board/artix7/ips/xilinx_clock_2x/xilinx_clock_2x.srcs/sources_1/ip/xilinx_clock_2x/xilinx_clock_2x_stub.v
// Design      : xilinx_clock_2x
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module xilinx_clock_2x(clk_i, clk2x_o, rstn_i)
/* synthesis syn_black_box black_box_pad_pin="clk_i,clk2x_o,rstn_i" */;
  input clk_i;
  output clk2x_o;
  input rstn_i;
endmodule
