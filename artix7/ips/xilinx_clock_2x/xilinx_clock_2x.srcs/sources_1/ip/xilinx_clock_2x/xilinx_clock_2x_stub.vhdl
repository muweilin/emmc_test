-- Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
-- Date        : Thu Jul  6 17:18:50 2017
-- Host        : wusystem-server running 64-bit Ubuntu 14.04.5 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/hetingting/artix7-board/artix7/ips/xilinx_clock_2x/xilinx_clock_2x.srcs/sources_1/ip/xilinx_clock_2x/xilinx_clock_2x_stub.vhdl
-- Design      : xilinx_clock_2x
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xilinx_clock_2x is
  Port ( 
    clk_i : in STD_LOGIC;
    clk2x_o : out STD_LOGIC;
    rstn_i : in STD_LOGIC
  );

end xilinx_clock_2x;

architecture stub of xilinx_clock_2x is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_i,clk2x_o,rstn_i";
begin
end;
