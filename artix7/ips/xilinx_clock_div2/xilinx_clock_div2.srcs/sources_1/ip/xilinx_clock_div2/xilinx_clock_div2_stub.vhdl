-- Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
-- Date        : Fri Jan 19 16:22:00 2018
-- Host        : fyh-OptiPlex-3020 running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/fyh/emmc_test/artix7-board/artix7/ips/xilinx_clock_div2/xilinx_clock_div2.srcs/sources_1/ip/xilinx_clock_div2/xilinx_clock_div2_stub.vhdl
-- Design      : xilinx_clock_div2
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xilinx_clock_div2 is
  Port ( 
    clk50_i : in STD_LOGIC;
    clk5_o : out STD_LOGIC;
    rstn_i : in STD_LOGIC;
    locked : out STD_LOGIC
  );

end xilinx_clock_div2;

architecture stub of xilinx_clock_div2 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk50_i,clk5_o,rstn_i,locked";
begin
end;
