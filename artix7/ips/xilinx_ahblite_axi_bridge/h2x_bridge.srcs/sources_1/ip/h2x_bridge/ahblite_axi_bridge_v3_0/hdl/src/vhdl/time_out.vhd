-------------------------------------------------------------------------------
-- time_out.vhd - entity/architecture pair
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
-- Filename:        time_out.vhd
-- Version:         v1.00a
-- Description:     This file contains the time out counter logic.
--
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--           -- ahblite_axi_bridge.vhd
--              -- ahblite_axi_bridge_pkg.vhd
--              -- ahblite_axi_control.vhd
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
use ieee.numeric_std.all;

library ahblite_axi_bridge_v3_0;
-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--Important Notes on AXI Valid/Ready Assertion
--------------------------------------------------------------------------------
-- a.Once VALID is asserted it must remain asserted until the handshake 
--  occurs.
-- b.If READY is asserted, it is permitted to deassert READY before 
--  VALID is asserted
----
-- Definition of Ports
--
-- System signals
-- AHB signals
--  S_AHB_HCLK               -- AHB Clock
--  S_AHB_HRESETN            -- AHB Reset Signal - active low
-- Control signals
--  core_is_idle             -- Core is in IDLE state
--  enable_timeout_cnt       -- To start timer count
-- AXI signals
--  M_AXI_BVALID             -- Write response valid - This signal indicates
--                              that a valid write response is available
--  last_axi_rd_sample       -- Read last. This signal indicates the 
--                           -- last transfer in a read burst
--  timeout_o                -- Signal indicating the timeout condition
-------------------------------------------------------------------------------
-- Generics & Signals Description
-------------------------------------------------------------------------------
entity time_out is
  generic (
    C_FAMILY              : string    := "virtex7";
    C_AHB_AXI_TIMEOUT     : integer   := 0
  );
  port (
  -- AHB Signals
     S_AHB_HCLK           : in  std_logic;                           
     S_AHB_HRESETN        : in  std_logic;                           
     core_is_idle         : in  std_logic;
     enable_timeout_cnt   : in  std_logic;
  -- For write transaction
     M_AXI_BVALID         : in  std_logic;
     wr_load_timeout_cntr : in std_logic;
  -- For read transaction  
     last_axi_rd_sample   : in  std_logic;
     rd_load_timeout_cntr : in std_logic;
  -- Time out signal
     timeout_o            : out std_logic
    );

end entity time_out;
-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

architecture RTL of time_out is
-------------------------------------------------------------------------------
-- PRAGMAS
-------------------------------------------------------------------------------

attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of RTL : architecture is "yes";

--------------------------------------------------------------------------------
-- Function clog2 - returns the integer ceiling of the base 2 logarithm of x,
--                  i.e., the least integer greater than or equal to log2(x).
--------------------------------------------------------------------------------
function clog2(x : positive) return natural is
  variable r  : natural := 0;
  variable rp : natural := 1; -- rp tracks the value 2**r
begin 
  while rp < x loop -- Termination condition T: x <= 2**r
    -- Loop invariant L: 2**(r-1) < x
    r := r + 1;
    if rp > integer'high - rp then exit; end if;  -- If doubling rp overflows
      -- the integer range, the doubled value would exceed x, so safe to exit.
    rp := rp + rp;
  end loop;
  -- L and T  <->  2**(r-1) < x <= 2**r  <->  (r-1) < log2(x) <= r
  return r; --
end clog2;

begin
-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Declare the signals/constants required when timeout module is required.
-- This is based on the generic choosen whether to implement the timeout logic
-- or not.
--------------------------------------------------------------------------------
 
  GEN_WDT : if (C_AHB_AXI_TIMEOUT /= 0) generate

     constant TIMEOUT_VALUE_TO_USE : integer := C_AHB_AXI_TIMEOUT;
     constant COUNTER_WIDTH        : integer := clog2(TIMEOUT_VALUE_TO_USE);
     constant TIMEOUT_VALUE_VECTOR : std_logic_vector(COUNTER_WIDTH-1 downto 0)
                                   := std_logic_vector(to_unsigned
                                      (TIMEOUT_VALUE_TO_USE-1,COUNTER_WIDTH));
     signal timeout_i              : std_logic;
     signal cntr_rst               : std_logic;
     signal cntr_load              : std_logic;
     signal cntr_enable            : std_logic;

  begin

--------------------------------------------------------------------------------
-- Reeset condition for counter
-- Counter is active high reset, Invert the IP reset.
--------------------------------------------------------------------------------
   cntr_rst    <= not S_AHB_HRESETN ;
--------------------------------------------------------------------------------
--  Load the counter when core is in IDLE state
--------------------------------------------------------------------------------
   cntr_load   <= core_is_idle         or
                  wr_load_timeout_cntr or 
                  rd_load_timeout_cntr;


--------------------------------------------------------------------------------
--Generate the enable signal for the timeout counter.
-- Start counting : When Write / Read addres is placed
-- Stop  counting : Write response detected / Last read data seen or
--                   counter expired.
--------------------------------------------------------------------------------
    COUNTER_ENABLE_REG : process (S_AHB_HCLK) is 
    begin
       if(S_AHB_HCLK'EVENT and S_AHB_HCLK='1')then
         if(S_AHB_HRESETN='0')then
           cntr_enable <= '0';
         else
           if( enable_timeout_cnt = '1' ) then
             cntr_enable <= '1';
           elsif( M_AXI_BVALID = '1' or last_axi_rd_sample ='1' or
                  timeout_i = '1') then
             cntr_enable <= '0';
           else
             cntr_enable <= cntr_enable;
           end if;
         end if;
       end if;
    end process COUNTER_ENABLE_REG;
--------------------------------------------------------------------------------
--Instantiation of the counter module.
-- To count the number of clock pulses lapsed after the transfer is initiated
-- on the AHB side.
--------------------------------------------------------------------------------
    WDT_COUNTER_MODULE : entity ahblite_axi_bridge_v3_0.counter_f
       generic map(
         C_NUM_BITS    =>  COUNTER_WIDTH,
         C_FAMILY      =>  C_FAMILY
           )
       port map(
         Clk           =>  S_AHB_HCLK,
         Rst           =>  cntr_rst,
         Load_In       =>  TIMEOUT_VALUE_VECTOR,
         Count_Enable  =>  cntr_enable,
         Count_Load    =>  cntr_load,
         Count_Down    =>  '1',
         Count_Out     =>  open,
         Carry_Out     =>  timeout_i
         );

--------------------------------------------------------------------------------
-- This process is used for registering timeout
-- This timeout signal is used in generating the ready to AHB with
-- error response
--------------------------------------------------------------------------------
    TIMEOUT_REG : process(S_AHB_HCLK) is
    begin
        if(S_AHB_HCLK'EVENT and S_AHB_HCLK='1')then
            if(S_AHB_HRESETN='0')then
                timeout_o <= '0';
            else
                timeout_o <= timeout_i;
            end if;
        end if;
    end process TIMEOUT_REG;
  end generate GEN_WDT;

--------------------------------------------------------------------------------
-- No timeout logic when C_AHB_AXI_TIMEOUT = 0
--------------------------------------------------------------------------------
   GEN_NO_WDT : if (C_AHB_AXI_TIMEOUT = 0) generate
   begin
        timeout_o <= '0';
   end generate GEN_NO_WDT;
end architecture RTL;
