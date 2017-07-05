-------------------------------------------------------------------------------
-- ahblite_axi_bridge_pkg.vhd - entity/architecture pair
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
-- Filename:        ahblite_axi_bridge_pkg.vhd
-- Version:         v1.00a
-- Description:     This file contains the constants used across 
--                  different files in the IP
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

package ahblite_axi_bridge_pkg is

--------------------------------------------------------------------------------
--Constants declerations
--------------------------------------------------------------------------------
                         -- AHB SIDE --
--------------------------------------------------------------------------------
-- Constants for Burst operation
--------------------------------------------------------------------------------
  constant SINGLE  : std_logic_vector := "000";
  constant INCR    : std_logic_vector := "001";
  constant WRAP4   : std_logic_vector := "010";
  constant INCR4   : std_logic_vector := "011";
  constant WRAP8   : std_logic_vector := "100";
  constant INCR8   : std_logic_vector := "101";
  constant WRAP16  : std_logic_vector := "110";
  constant INCR16  : std_logic_vector := "111";

--------------------------------------------------------------------------------
-- Constants for Transfer type
--------------------------------------------------------------------------------
  constant IDLE   : std_logic_vector := "00";
  constant BUSY   : std_logic_vector := "01";
  constant NONSEQ : std_logic_vector := "10";
  constant SEQ    : std_logic_vector := "11";

--------------------------------------------------------------------------------
--Constants for Burst counts
--------------------------------------------------------------------------------
  constant INCR_WRAP_4  : std_logic_vector := "00011";
  constant INCR_WRAP_8  : std_logic_vector := "00111";
  constant INCR_WRAP_16 : std_logic_vector := "01111";

--------------------------------------------------------------------------------
--Constant for ahb valid data sample counter width
--------------------------------------------------------------------------------
  constant AHB_SAMPLE_CNT_WIDTH : integer := 5;

--------------------------------------------------------------------------------
--Constants for AHB response
--------------------------------------------------------------------------------
  constant AHB_HRESP_OKAY  : std_logic := '0';
  constant AHB_HRESP_ERROR : std_logic := '1';

--------------------------------------------------------------------------------
                         -- AXI SIDE --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Constants for Length on axi interface.
--------------------------------------------------------------------------------
  constant AXI_ARWLEN_1  : std_logic_vector := "0000";
  constant AXI_ARWLEN_4  : std_logic_vector := "0011";
  constant AXI_ARWLEN_8  : std_logic_vector := "0111";
  constant AXI_ARWLEN_16 : std_logic_vector := "1111";

--------------------------------------------------------------------------------
--Constant for axi_write counter width
--------------------------------------------------------------------------------
  constant  AXI_WRITE_CNT_WIDTH : integer := 5; 

--------------------------------------------------------------------------------
--Constants for BURST in AXI side interface
-- Same constants for read and write interfaces.
--------------------------------------------------------------------------------
  constant AXI_ARWBURST_FIXED : std_logic_vector := "00";
  constant AXI_ARWBURST_INCR  : std_logic_vector := "01";
  constant AXI_ARWBURST_WRAP  : std_logic_vector := "10";
  constant AXI_ARWBURST_RSVD  : std_logic_vector := "11";

--------------------------------------------------------------------------------
--Constants for AXI response
--------------------------------------------------------------------------------
  constant AXI_RESP_OKAY   : std_logic_vector := "00";
  constant AXI_RESP_SLVERR : std_logic_vector := "10";
  constant AXI_RESP_DECERR : std_logic_vector := "11";

end package ahblite_axi_bridge_pkg;

package body ahblite_axi_bridge_pkg is
  -- No functions defined.
end package body ahblite_axi_bridge_pkg;
