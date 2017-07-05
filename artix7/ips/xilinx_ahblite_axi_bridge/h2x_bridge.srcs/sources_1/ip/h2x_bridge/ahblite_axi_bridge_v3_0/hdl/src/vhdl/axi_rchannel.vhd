-------------------------------------------------------------------------------
-- axi_rchannel.vhd - entity/architecture pair
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
-- Filename:        axi_rchannel.vhd
-- Version:         v1.00a
-- Description:     This module generates the AXI read transactions based on 
--                  the control and ahb information received on ahb-side.
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
-- Kondalarao P          12/22/2010   Initial version
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

--
-- Definition of Generics
--
-- System Parameters
--
--  C_S_AHB_ADDR_WIDTH         -- Width of AHBLite address bus
--  C_M_AXI_ADDR_WIDTH         -- Width of AXI address bus
--  C_M_AXI_DATA_WIDTH         -- Width of AXI data buse
--  C_M_AXI_THREAD_ID_WIDTH    -- ID width of read and write channels 
--
-- Definition of Ports
--
-- AHB signals
--  S_AHB_HCLK               -- AHB Clock
--  S_AHB_HRESETN            -- AHB Reset Signal - active low

-- AHB interface signals
--  seq_detected             -- Valid SEQ transaction detected
--  busy_detected            -- Valid BUSY transaction detected
--  rvalid_rready            -- Read valid and can be captured - This signal 
--                              indicates that the required read data is
--                              available and the read
--                              transfer can complete
-- AXI Read address channel signals
--
--  M_AXI_ARVALID            -- Read address valid - This signal indicates,
--                              when HIGH, that the read address and control
--                              information is valid and will remain stable
--                              until the address acknowledge signal,ARREADY,
--                              is high.
--  M_AXI_ARREADY            -- Read address ready - This signal indicates
--                              that the slave is ready to accept an address
--                              and associated control signals:
--
-- AXI Read data channel signals
--
--  M_AXI_RVALID             -- Read valid - This signal indicates that the
--                              required read data is available and the read
--                              transfer can complete
--  M_AXI_RLAST              -- Read last. This signal indicates the 
--                           -- last transfer in a read burst
--  M_AXI_RREADY             -- Read ready - This signal indicates that the
--                              master can accept the read data and response
--                              information
-- Control signals based on state machine states.
--  set_axi_raddr            -- To set read addr on AXI interface
-- Timeout module.

-------------------------------------------------------------------------------
-- Generics & Signals Description
-------------------------------------------------------------------------------

entity axi_rchannel is
  generic (
    C_S_AHB_ADDR_WIDTH            : integer range 32 to 32    := 32;
    C_M_AXI_ADDR_WIDTH            : integer range 32 to 32    := 32;
    C_M_AXI_DATA_WIDTH            : integer range 32 to 64    := 32;
    C_M_AXI_THREAD_ID_WIDTH       : integer                   := 4 
    );
  port (
  -- AHB Signals
     S_AHB_HCLK            : in  std_logic;                           
     S_AHB_HRESETN         : in  std_logic;                           
  -- AHB interface signals
     seq_detected          : in  std_logic;
     busy_detected         : in  std_logic;
     rvalid_rready         : out std_logic;
     axi_rresp_err         : out std_logic_vector(1 downto 0);
     txer_rdata_to_ahb     : out std_logic;

  -- AXI Read Address Channel Signals
     M_AXI_ARVALID         : out std_logic;
     M_AXI_ARREADY         : in  std_logic;
  -- AXI Read Data Channel Signals
     M_AXI_RVALID          : in  std_logic;
     M_AXI_RLAST           : in  std_logic;
     M_AXI_RRESP           : in  std_logic_vector(1 downto 0);
     M_AXI_RREADY          : out std_logic;
  -- Timeout module
     rd_load_timeout_cntr  : out std_logic;
  -- AHB interface module.
     set_hresp_err         : in  std_logic;
  -- Control signals to/from state machine block
     last_axi_rd_sample    : out std_logic;
     set_axi_raddr         : in  std_logic 
    );

end entity axi_rchannel;
-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

architecture RTL of axi_rchannel is

-------------------------------------------------------------------------------
-- PRAGMAS
-------------------------------------------------------------------------------

attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of RTL : architecture is "yes";

-------------------------------------------------------------------------------
 -- Signal declarations(Description of each signal is given in their 
 --    implementation block
-------------------------------------------------------------------------------
signal M_AXI_ARVALID_i        : std_logic;
signal M_AXI_RREADY_i         : std_logic;
signal ahb_rd_txer_pending    : std_logic;
signal ahb_rd_req             : std_logic;
signal axi_rd_avlbl           : std_logic;
signal axi_rlast_valid        : std_logic;
signal axi_last_avlbl         : std_logic;
signal axi_rresp_avlbl        : std_logic_vector(1 downto 0);
signal seq_detected_d1        : std_logic;    
signal bridge_rd_in_progress  : std_logic;
signal rdata_placed_on_ahb    : std_logic;
signal rd_load_timeout_cntr_i : std_logic;
begin

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
    
--------------------------------------------------------------------------------
--O/P signal assignments
--------------------------------------------------------------------------------
  M_AXI_ARVALID        <= M_AXI_ARVALID_i;
  M_AXI_RREADY         <= M_AXI_RREADY_i;
  rd_load_timeout_cntr <= rd_load_timeout_cntr_i;
--------------------------------------------------------------------------------
-- Sample RDATA when a new sample is detected(RVALID and RREADY are '1'
--------------------------------------------------------------------------------
  rvalid_rready    <=  ((M_AXI_RREADY_i and 
                         M_AXI_RVALID   and
                         not busy_detected   and
                         not ahb_rd_txer_pending) or 
                        (ahb_rd_req and axi_rd_avlbl ));
  
  txer_rdata_to_ahb <= (M_AXI_RREADY_i and M_AXI_RVALID) ;

  -- RLAST is valid only when RVALID is high.This prevent spurious RLASTs 
  -- generated
  axi_rlast_valid   <=  (M_AXI_RLAST and M_AXI_RVALID);

  last_axi_rd_sample <= (axi_rlast_valid and not ahb_rd_txer_pending) or 
                         axi_last_avlbl ;

--------------------------------------------------------------------------------
-- Load fresh value to timeout counter once a valid sample is detected on AXI
--  side
--------------------------------------------------------------------------------
  rd_load_timeout_cntr_i <= (M_AXI_RREADY_i and M_AXI_RVALID);
--------------------------------------------------------------------------------
--Combinatorial block sampling the RRESP 
-- RRESP should be updated with the response from AXI when there are pending 
-- transfers created due to BUSY transfers in between the current transfer.
-- For cases where BUSY transfers are initiated, updated the axi_rresp_err
-- with the value captured when the axi_rd_avlbl is set.
--------------------------------------------------------------------------------
  AXI_RRESP_CMB :  process (M_AXI_RREADY_i      ,
                            M_AXI_RVALID        ,
                            ahb_rd_txer_pending ,
                            busy_detected       ,
                            M_AXI_RRESP         ,
                            ahb_rd_req          ,
                            axi_rd_avlbl        ,
                            axi_rresp_avlbl     
                           ) is
  begin
    if (M_AXI_RREADY_i      = '1' and 
        M_AXI_RVALID        = '1' and 
        busy_detected       = '0' and 
        ahb_rd_txer_pending = '0') then
       axi_rresp_err <= M_AXI_RRESP;
    elsif(ahb_rd_req   = '1' and 
          axi_rd_avlbl = '1' ) then
       axi_rresp_err <= axi_rresp_avlbl;
    else
       axi_rresp_err <= (others => '0');
    end if;
  end process AXI_RRESP_CMB;
--------------------------------------------------------------------------------
--Place address control ARVALID on AXI for read transactions
-- Reset after the address is accepted by AXI Slave.
--------------------------------------------------------------------------------
  AXI_ARVALID_REG : process (S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        M_AXI_ARVALID_i <= '0';
      else
        if(set_axi_raddr = '1' ) then
          M_AXI_ARVALID_i <= '1';
        elsif(M_AXI_ARREADY = '1') then
          M_AXI_ARVALID_i <= '0';
        else
          M_AXI_ARVALID_i <= M_AXI_ARVALID_i;
        end if;
      end if;
    end if;
  end process AXI_ARVALID_REG;

--------------------------------------------------------------------------------
--M_AXI_RREADY signal generation to accept the Read data from AXI interface
-- Start accepting read data after the address is placed on AXI. 
-- Stop accepting of the AHB is not ready to receive the data,conveying this
-- by giving BUSY transfers.
-- Start accepting againg if the SEQ transfer on AHB is detected after the 
-- BUSY transfer.
--------------------------------------------------------------------------------
  AXI_RREADY_REG : process ( S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        M_AXI_RREADY_i <= '0';
      else
        if( M_AXI_ARVALID_i = '1' and M_AXI_ARREADY = '1' ) then
          M_AXI_RREADY_i <= '1';
        elsif((axi_rlast_valid = '1' and M_AXI_RREADY_i = '1') or 
           busy_detected = '1' or
           set_hresp_err = '1' or
           (ahb_rd_txer_pending  = '1' and M_AXI_RVALID = '1' and
                                           M_AXI_RREADY_i = '1') or
            axi_rd_avlbl = '1') then
          M_AXI_RREADY_i <= '0';
         elsif(
                (seq_detected = '1') or
                (axi_rd_avlbl = '0' and ahb_rd_txer_pending = '1')
               ) then 
          M_AXI_RREADY_i <= '1';
        else
          M_AXI_RREADY_i <= M_AXI_RREADY_i;
        end if;
      end if;
    end if;
  end process AXI_RREADY_REG;

--------------------------------------------------------------------------------
--Additional processes to consider the back pressure from AHB by giving busy 
-- transfers in between the read transaction
--------------------------------------------------------------------------------
-- Logic description: 
--  a.Ensure the current request is read
--  b.Hunt for any BUSY transfer from AHB during the read transfer progress
--    phase.
--  c.Once detected - 2 possible case can happen at this instance
--      c.1: Read data from AXI is also received at the same time as busy 
--           detected. So donot allow axi interface to accepte more data
--           by keeping AXI_RREADY low.
--      c.2: Read is not yet available. Allow AXI interface to accept ONE
--           new data by asserting AXI_RREADY 
--  d.Now we need to ensure 2 conditions to happens
--    d.1 There is new sequential request is initiated from AHB and
--    d.2 Read data is available from AXI(following steps c.1 and c.2)
--  e.Once the conditions in (d) are satisfied,transfer the read data from
--    AHB to AXI
--    transfer
-- Following process acheives this functionality
--------------------------------------------------------------------------------

  BRIDGE_RD_IN_PROGRESS_REG: process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        bridge_rd_in_progress <= '0';
      else
        if(M_AXI_ARVALID_i = '1') then
          bridge_rd_in_progress <= '1';
        elsif(axi_rlast_valid = '1' and M_AXI_RREADY_i = '1') then
          bridge_rd_in_progress <= '0';
        else
          bridge_rd_in_progress <= bridge_rd_in_progress;
        end if;
      end if;
    end if;
  end process BRIDGE_RD_IN_PROGRESS_REG;

  AHB_RD_REQ_PENDING_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        ahb_rd_txer_pending <= '0';
      else
        if(ahb_rd_req = '1' and axi_rd_avlbl = '1') then
          ahb_rd_txer_pending <= '0';
        elsif(busy_detected = '1' and bridge_rd_in_progress = '1') then
          ahb_rd_txer_pending <= '1';
        else
          ahb_rd_txer_pending <= ahb_rd_txer_pending;
        end if;
      end if;
    end if;
  end process AHB_RD_REQ_PENDING_REG;

  AHB_RD_REQ_REG : process (S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        ahb_rd_req <= '0';
      else
        if(axi_rd_avlbl        = '1' and
           ahb_rd_txer_pending = '1' and 
           ahb_rd_req          = '1') then
          ahb_rd_req <= '0';
        elsif(seq_detected = '1' and seq_detected_d1 = '0') then
          ahb_rd_req <= ahb_rd_txer_pending;
        else 
          ahb_rd_req <= ahb_rd_req;
        end if;
      end if;
    end if;
  end process AHB_RD_REQ_REG;
 
  AXI_RD_DATA_AVLBL_REG: process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        axi_rd_avlbl    <= '0';
        axi_last_avlbl  <= '0';
        axi_rresp_avlbl <= (others => '0');
      else
        if(ahb_rd_req = '1' and axi_rd_avlbl = '1') then
          axi_rd_avlbl    <= '0';
          axi_last_avlbl  <= '0';
          axi_rresp_avlbl <= (others => '0');
        elsif((ahb_rd_txer_pending = '1' 
           or busy_detected = '1'
          ) and
              (M_AXI_RREADY_i = '1' and M_AXI_RVALID = '1')) then 
          axi_rd_avlbl   <= '1';
          axi_last_avlbl <= axi_rlast_valid;
          axi_rresp_avlbl<= M_AXI_RRESP;
        else
          axi_rd_avlbl   <= axi_rd_avlbl;
          axi_last_avlbl <= axi_last_avlbl;
          axi_rresp_avlbl<= axi_rresp_avlbl;
        end if;
      end if;
    end if;
  end process AXI_RD_DATA_AVLBL_REG;
 
  RDATA_SAMPLED_TO_AXI_REG: process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        rdata_placed_on_ahb <= '0';
      else
        if(busy_detected = '1' and
           (M_AXI_RREADY_i = '1' and M_AXI_RVALID = '1')) then 
          rdata_placed_on_ahb <= '1';
        elsif(ahb_rd_txer_pending = '0') then
          rdata_placed_on_ahb <= '0';
        else
          rdata_placed_on_ahb <= rdata_placed_on_ahb;
        end if; 
      end if;
    end if;
  end process RDATA_SAMPLED_TO_AXI_REG;

  SEQ_DETECTED_D1_REG: process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        seq_detected_d1 <= '0';
      else
        seq_detected_d1 <= seq_detected;
      end if;
    end if;
  end process  SEQ_DETECTED_D1_REG;
end architecture RTL;
