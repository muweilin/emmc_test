-------------------------------------------------------------------------------
-- ahb_data_counter.vhd - entity/architecture pair
-------------------------------------------------------------------------------
-- ******************************************************************* 
-- ** (c) Copyright [2007] - [2011] Xilinx, Inc. All rights reserved.*
-- **                                                                *
-- ** This file contains confidential and proprietary information    *
-- ** of Xilinx, Inc. and is protected under U.S. and                *
-- ** international copyright and other intellectual property        *
-- ** laws.                                                          *
-- **                                                                *
-- ** DISCLAIMER                                                     *
-- ** This disclaimer is not a license and does not grant any        *
-- ** rights to the materials distributed herewith. Except as        *
-- ** otherwise provided in a valid license issued to you by         *
-- ** Xilinx, and to the maximum extent permitted by applicable      *
-- ** law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND        *
-- ** WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES    *
-- ** AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING      *
-- ** BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-         *
-- ** INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and       *
-- ** (2) Xilinx shall not be liable (whether in contract or tort,   *
-- ** including negligence, or under any other theory of             *
-- ** liability) for any loss or damage of any kind or nature        *
-- ** related to, arising under or in connection with these          *
-- ** materials, including for any direct, or any indirect,          *
-- ** special, incidental, or consequential loss or damage           *
-- ** (including loss of data, profits, goodwill, or any type of     *
-- ** loss or damage suffered as a result of any action brought      *
-- ** by a third party) even if such damage or loss was              *
-- ** reasonably foreseeable or Xilinx had been advised of the       *
-- ** possibility of the same.                                       *
-- **                                                                *
-- ** CRITICAL APPLICATIONS                                          *
-- ** Xilinx products are not designed or intended to be fail-       *
-- ** safe, or for use in any application requiring fail-safe        *
-- ** performance, such as life-support or safety devices or         *
-- ** systems, Class III medical devices, nuclear facilities,        *
-- ** applications related to the deployment of airbags, or any      *
-- ** other applications that could lead to death, personal          *
-- ** injury, or severe property or environmental damage             *
-- ** (individually and collectively, "Critical                      *
-- ** Applications"). Customer assumes the sole risk and             *
-- ** liability of any use of Xilinx products in Critical            *
-- ** Applications, subject only to applicable laws and              *
-- ** regulations governing limitations on product liability.        *
-- **                                                                *
-- ** THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS       *
-- ** PART OF THIS FILE AT ALL TIMES.                                *
-- ******************************************************************* 
--
-------------------------------------------------------------------------------
-- Filename:        ahb_data_counter.vhd
-- Version:         v1.00a
-- Description:     This file contains the support logic required
--                   for the state machine.These include
--                  a.AHB valid inputs sample counter
--                    This will count the number of valid data inputs
--                    received till now. This helps in controlling the
--                    HREADY signal which decides the either to allow for
--                    another data to be placed on the bus or not by the 
--                    AHB master.
--
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--           -- ahblite_axi_bridge.vhd
--              -- ahblite_axi_bridge_pkg.vhd
--              -- ahblite_axi_control.vhd
--              -- ahb_if.vhd
--              -- ahb_data_counter.vhd
--              -- axi_wchannel.vhd
--              -- axi_rchannel.vhd
--              -- time_out.vhd
--
-------------------------------------------------------------------------------
-- Author:      Kondalarao P( kpolise@xilinx.com ) 
-- History:
-- Kondalarao P          11/24/2010   Initial version
-- ^^^^^^^
-- ~~~~~~~
-------------------------------------------------------------------------------

-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x"
--      reset signals:                          "reset", "resetn"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_cmb"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


library ahblite_axi_bridge_v3_0;
use ahblite_axi_bridge_v3_0.ahblite_axi_bridge_pkg.all;

-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------
-- Definition of Ports
--
-- System signals
--                              Information
-- AHB signals
--  S_AHB_HCLK               -- AHB Clock
--  S_AHB_HRESETN            -- AHB Reset Signal - active low
--  ahb_valid_cnt            -- Gives the number of valid data sampled
--                              on the AHB interface after the transfer
--                              is initiated.
--  ahb_hburst_incr          -- Indicates INCR transfer on AHB side.
--  nonseq_detected          -- Valid NONSEQ transaction detected
--  seq_detected             -- Valid SEQ transaction detected
-------------------------------------------------------------------------------
-- Generics & Signals Description
-------------------------------------------------------------------------------

entity ahb_data_counter is
  generic (
   C_FAMILY                 : string    := "virtex7" 
   );
  port (
  -- AHB Signals
     S_AHB_HCLK        : in  std_logic;                           
     S_AHB_HRESETN     : in  std_logic;                           

  -- ahb_if module
     ahb_hwrite        : in  std_logic;
     ahb_hburst_incr   : in  std_logic;
     ahb_valid_cnt     : out std_logic_vector(4 downto 0);
     nonseq_detected   : in  std_logic;
     seq_detected      : in  std_logic
    );

end entity ahb_data_counter;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture RTL of ahb_data_counter is

-------------------------------------------------------------------------------
-- PRAGMAS
-------------------------------------------------------------------------------

attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of RTL : architecture is "yes";

-------------------------------------------------------------------------------
 -- Signal declarations(Description of each signal is given in their 
 --    implementation block
-------------------------------------------------------------------------------
signal ahb_valid_cnt_i        : std_logic_vector( 4 downto 0);
signal cntr_rst               : std_logic;
signal cntr_load              : std_logic;
signal cntr_load_in           : std_logic_vector(4 downto 0);
signal cntr_enable            : std_logic;
begin

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- I/O signal assignements
--------------------------------------------------------------------------------
-- Tracks the number of valid samples received for the current transfer
-- on the AHB side.
ahb_valid_cnt        <= ahb_valid_cnt_i; 
--------------------------------------------------------------------------------
--Internal signal assignments
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Reeset condition for counter
-- Counter is active high reset, Invert the IP reset.
--------------------------------------------------------------------------------
cntr_rst       <= not S_AHB_HRESETN;

--------------------------------------------------------------------------------
-- Load the counter when a NONSEQ is detected,as this is start of NEW
-- transfer
--------------------------------------------------------------------------------
cntr_load      <= nonseq_detected ;

--------------------------------------------------------------------------------
--Load an initial value of 1 as nonseq is detected.(1st sample
--  on the AHB is received.
--------------------------------------------------------------------------------
cntr_load_in   <= "00001" ;

--------------------------------------------------------------------------------
-- Enable condition for counter
-- Increment the counter whenever a valid sample on AHB is received.
--  Do NOT count for indefinite length INCR transfer.These are converted
--  to SINGLE transfers on AXI
--------------------------------------------------------------------------------
cntr_enable    <= ahb_hwrite   and 
                  seq_detected and (not ahb_hburst_incr);

--------------------------------------------------------------------------------
--AHB valid inputs sample counter
-- Set the counter to 1 when NONSEQ is detected.
-- Increment for every sequential transfer there after,except
-- for the indefinite length increment transfer.
--------------------------------------------------------------------------------
  AHB_SAMPLE_CNT_MODULE : entity ahblite_axi_bridge_v3_0.counter_f
     generic map(
       C_NUM_BITS    =>  AHB_SAMPLE_CNT_WIDTH,
       C_FAMILY      =>  C_FAMILY
         )
     port map(
       Clk           =>  S_AHB_HCLK     ,
       Rst           =>  cntr_rst       ,
       Load_In       =>  cntr_load_in   ,
       Count_Enable  =>  cntr_enable    ,
       Count_Load    =>  cntr_load      ,
       Count_Down    =>  '0'            ,
       Count_Out     =>  ahb_valid_cnt_i,
       Carry_Out     =>  open
       );
end architecture RTL;
