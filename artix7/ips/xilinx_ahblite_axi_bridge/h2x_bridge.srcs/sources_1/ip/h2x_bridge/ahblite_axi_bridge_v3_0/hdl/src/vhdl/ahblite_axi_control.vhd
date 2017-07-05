-------------------------------------------------------------------------------
-- ahblite_axi_control.vhd - entity/architecture pair
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
-- Filename:        ahblite_axi_control.vhd
-- Version:         v1.00a
-- Description:     This file contains the fsm which tracks, controls
--                   the transfer flow from ahblite interface to axi 
--                   interface.Considers burst termination,
--                   timeout condition for axi slave not responding.
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

--
-- Definition of Generics
--
-- System Parameters
-- C_FAMILY                   -- FPGA Family for which the ahblite_axi_control
--                                is targetted
-- Definition of Ports
--
-- AHB signals
--  S_AHB_HCLK               -- AHB Clock
--  S_AHB_HRESETN            -- AHB Reset Signal - active low
--  S_AHB_HWRITE             -- Direction indicates an AHB write access when
--                              high and an AHB read access when low
--  axi_wr_channel_ready     -- Write channel ready to accept data from AHB
--  axi_wdata_done           -- Asserted when  WVALID = 1 and  WREADY = 1 
--  rvalid_rready            -- RDATA valid
--  last_axi_rd_sample       -- Last read data
--  axi_rresp_err            -- Read response
--  axi_bresp_ok             -- Asserted when  BVALID = 1
--  axi_bresp_err            -- Asserted when  BVALID = 1 and ERROR = 1
--  set_axi_raddr            -- To set read addr on AXI interface
--  set_axi_waddr            -- To set write addr on AXI interface 
--  ahb_wnr                  -- To set first burst write data data on AXI
--                               interface
--  set_axi_wdata_burst      -- To set next burst write data data on AXI
--                               interface
--  set_axi_rdata            -- To set read data on AXI interface
--  timeout_i                -- Timeout signal from the timeout module
--  enable_timeout_cnt       -- To start timer count
--  core_is_idle             -- Core is in IDLE state
--  set_hready               -- Assert S_AHB_HREADY_OUT on AHB interface
--  reset_hready             -- De-assert S_AHB_HREADY_OUT on AHB interface
--  set_hresp_err            -- Assert HRESP as ERROR
--  reset_hresp_err          -- De-assert HRESP as ERROR 
--  axi_bresp_ready          -- Response received from AXI for the current
--                              transfer
--  nonseq_detected          -- Valid NONSEQ transaction detected
--  seq_detected             -- Valid SEQ transaction detected
--  ahb_hburst_single        -- Transfer on AHB is SINGLE
--  ahb_hburst_incr          -- Transfer on AHB is INCR
-------------------------------------------------------------------------------
-- Generics & Signals Description
-------------------------------------------------------------------------------

entity ahblite_axi_control is
  port (
  -- AHB Signals
     S_AHB_HCLK            : in  std_logic;                           
     S_AHB_HRESETN         : in  std_logic;                           
     S_AHB_HWRITE          : in  std_logic;
     S_AHB_HBURST          : in  std_logic_vector(2 downto 0 );
  -- AXI Write/Read channels
     axi_wr_channel_ready  : in  std_logic;
     axi_wr_channel_busy   : in  std_logic;
     axi_wdata_done        : in  std_logic;
     rvalid_rready         : in  std_logic;
     last_axi_rd_sample    : in  std_logic;
     axi_rresp_err         : in  std_logic_vector(1 downto 0);
     axi_bresp_ok          : in  std_logic;
     axi_bresp_err         : in  std_logic;
     set_axi_raddr         : out std_logic;
     set_axi_waddr         : out std_logic; 
     ahb_wnr               : out std_logic;
     set_axi_wdata_burst   : out std_logic;
     set_axi_rdata         : out std_logic;
  -- timout module
     timeout_i             : in  std_logic;
     enable_timeout_cnt    : out std_logic;
  -- AHB interface  module 
     core_is_idle          : out std_logic;
     set_hready            : out std_logic;
     reset_hready          : out std_logic;
     set_hresp_err         : out std_logic;
     reset_hresp_err       : out std_logic;
     nonseq_txfer_pending  : in  std_logic;
     idle_txfer_pending    : in  std_logic;
     burst_term_hwrite     : in  std_logic;
     burst_term_single_incr: in  std_logic;
     init_pending_txfer    : out std_logic;
     axi_bresp_ready       : out std_logic;
     nonseq_detected       : in  std_logic;
     seq_detected          : in  std_logic;
     ahb_hburst_single     : in  std_logic;
     ahb_hburst_incr       : in  std_logic 
    );
end entity ahblite_axi_control;
-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

architecture RTL of ahblite_axi_control is

-------------------------------------------------------------------------------
-- PRAGMAS
-------------------------------------------------------------------------------

attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of RTL : architecture is "yes";

--------------------------------------------------------------------------------
-- State Machine Type Decleration
--------------------------------------------------------------------------------
  type CTL_SM_TYPE is ( 
                      CTL_IDLE     ,
                      CTL_ADDR     ,
                      CTL_WRITE    ,
                      CTL_READ     ,
                      CTL_READ_ERR ,
                      CTL_BRESP    ,
                      CTL_BRESP_ERR                  
                      );

-------------------------------------------------------------------------------
 -- Signal declarations(Description of each signal is given in their 
 --    implementation block
-------------------------------------------------------------------------------
  signal ctl_sm_ns            : CTL_SM_TYPE;
  signal ctl_sm_cs            : CTL_SM_TYPE;
  signal ahb_wnr_i            : std_logic;
  signal M_AXI_RLAST_reg      : std_logic;
  signal enable_timeout_cnt_i : std_logic;
  signal set_axi_waddr_i      : std_logic;
  signal hburst_single_incr   : std_logic;

begin

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Sample WRITE/READ request.Used to assert first data beat during WRITE 
-- transfers.
--------------------------------------------------------------------------------
  ahb_wnr       <= ahb_wnr_i;

--------------------------------------------------------------------------------
--To assert AWVALID for WRITE transfer.
--------------------------------------------------------------------------------
  set_axi_waddr <= set_axi_waddr_i;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--To limit hready for SINGLE and INCR transfers in the address phase.
-- The registerd signals ahb_hburst_incr and ahb_hburst_single will not be
-- available while placing the address on AXI.So use the HBURST signal from
-- the AHB interface is used during address phases,other phases use the
-- registered version of the signal.
--------------------------------------------------------------------------------
  hburst_single_incr <= '1' when (S_AHB_HBURST = SINGLE or 
                                  S_AHB_HBURST = INCR ) else
                        '0';
 
--------------------------------------------------------------------------------
-- Control state machine:
-- This state machine generates the control signals to transfer
--   the read/writes from AHB to AXI interface.
-- Generates control signals to assert/deassert control
--   signals on AHB and AXI side interfaces.
-- Generates control signals to sample/provide data.
-- Considers the time out of AXI side slave not responding to the 
--   request, ensures clean termination of the request on AHB side.
--------------------------------------------------------------------------------
 
  CTL_SM : process (
                   ctl_sm_cs             ,
                   nonseq_detected       ,
                   seq_detected          ,
                   S_AHB_HWRITE          ,
                   hburst_single_incr    ,
                   nonseq_txfer_pending  , 
                   idle_txfer_pending    ,
                   burst_term_hwrite     ,
                   burst_term_single_incr, 
                   ahb_hburst_incr       ,
                   ahb_hburst_single     ,
                   ahb_wnr_i             ,
                   axi_wr_channel_ready  ,
                   axi_wr_channel_busy   ,
                   axi_wdata_done        ,
                   timeout_i             ,
                   rvalid_rready         ,
                   last_axi_rd_sample    ,
                   M_AXI_RLAST_reg       ,
                   axi_rresp_err         ,
                   axi_bresp_ok          ,     
                   axi_bresp_err           
                   ) is
  begin
    ctl_sm_ns              <= ctl_sm_cs;
    core_is_idle           <= '0';
    set_hready             <= '0';
    reset_hready           <= '0';
    set_hresp_err          <= '0';
    reset_hresp_err        <= '0';
    
    set_axi_waddr_i        <= '0';
    set_axi_wdata_burst    <= '0';
    axi_bresp_ready        <= '0';
    init_pending_txfer     <= '0';
    set_axi_raddr          <= '0';
    set_axi_rdata          <= '0';

    enable_timeout_cnt_i   <= '0';
    case ctl_sm_cs is
    --------------------------------------------------------------------------
    --IDLE: Hunt for fresh transaction. 
    -- Flush all the previous transaction responses
    -- Start counting number of clocks the new transaction is taking to 
    -- timeout if the timeout module is activated.
    --------------------------------------------------------------------------
      when CTL_IDLE =>
        core_is_idle    <= '1';
        reset_hresp_err <= '1'; --Reset HRESP ERR if aleady set because of 
                                -- previous transfer.
        if( nonseq_detected = '1' or 
           (seq_detected = '1' and ahb_hburst_incr = '1')) then
          ctl_sm_ns <= CTL_ADDR; 
          set_axi_raddr   <= not S_AHB_HWRITE;
          set_axi_waddr_i <=     S_AHB_HWRITE;
          reset_hready  <= (not S_AHB_HWRITE ) or
                           (S_AHB_HWRITE and 
                            (hburst_single_incr));
          enable_timeout_cnt_i <= '1';
        end if; 
      
    --------------------------------------------------------------------------
    --Qualify the current transaction(WRITE/READ)
    -- If there is pending transfer which caused due to burst termination,
    -- service such transactions,convey that the pending transaction is being
    -- processed(init_pending_txfer).
    --  There is no check performed to set init_pending_txfer as resetting
    -- the pending transfer qualifiers even if no pending transfers,will not
    -- effect the core operation. This reduces some logic.   
    --------------------------------------------------------------------------
      when CTL_ADDR => 
        init_pending_txfer <= '1'; -- Process pending txfers
                                   -- if any
        if (ahb_wnr_i = '1') then
          ctl_sm_ns     <= CTL_WRITE;
          set_hready    <= '1';
          reset_hready  <= (not S_AHB_HWRITE ) or
                           (S_AHB_HWRITE and 
                            (ahb_hburst_single or 
                            ahb_hburst_incr));
        else 
          ctl_sm_ns <= CTL_READ;
          set_axi_rdata <= '1';
        end if;

    --------------------------------------------------------------------------
    -- Qualify if this is a burst transfer or a signle transfer
    -- set/reset hready based considering back pressure from 
    --  AHB by giving BUSY cycles during the transfer
    --  AXI by keeping WREADY low.
    -- Transition to BRESP when all the AHB samples are successfully placed
    -- and sampled by AXI.
    --------------------------------------------------------------------------
      when CTL_WRITE => 
        set_axi_wdata_burst <= (not ahb_hburst_single) and
                               (not ahb_hburst_incr);
        reset_hready        <= ahb_hburst_single  or 
                               ahb_hburst_incr    or
                               axi_wr_channel_busy   ;
        set_hready          <= axi_wr_channel_ready;
        if (axi_wdata_done = '1') then
          ctl_sm_ns <= CTL_BRESP;
        end if;  

    --------------------------------------------------------------------------
    -- Check if there pending transfers need to be address,which can occur
    --  burst termination.
    -- For normal transfers,pass read data and corresponding response for
    -- each data beat respecting the protocol requirement to have 2 clock
    --  cycle error response on AHB interface.
    -- Limit accepting read data from AXI by keeping RREADY low when
    -- AHB is not able to sample the current read data.
    --------------------------------------------------------------------------
      when CTL_READ => 
        if(nonseq_txfer_pending = '1' or
           nonseq_detected      = '1') then
          if(rvalid_rready = '1' and last_axi_rd_sample = '1') then
            ctl_sm_ns <= CTL_ADDR;
            -- For nonseq_txfer_pending case use burst_term*
            -- For nonseq_detected      case use S_AHB_* signals
            -- No need to explicitly check nonseq is the pending or
            -- the current,as both cases lead to CTL_ADDR
            -- burst_term* signals are 1 clock delayed versions of the S_AHB*
            set_axi_raddr   <= not ( burst_term_hwrite or
                                     S_AHB_HWRITE);
            set_axi_waddr_i <=     burst_term_hwrite or
                                   S_AHB_HWRITE;
            reset_hready  <= (not burst_term_hwrite or
                              not S_AHB_HWRITE)     or
                             ((burst_term_hwrite    or
                               S_AHB_HWRITE)          and 
                              (burst_term_single_incr or
                               hburst_single_incr));
            enable_timeout_cnt_i <= '1';
            init_pending_txfer   <= '1';
          end if;
        elsif(idle_txfer_pending = '1') then
          if(rvalid_rready = '1' and last_axi_rd_sample = '1') then
            ctl_sm_ns         <= CTL_IDLE;
            set_hready        <= '1';
            reset_hresp_err   <= '1';
            init_pending_txfer<= '1';
          end if;
        elsif(((rvalid_rready = '1' ) and
            (axi_rresp_err = AXI_RESP_SLVERR or
              axi_rresp_err = AXI_RESP_DECERR)) or timeout_i = '1') then
            reset_hready <= '1';
            set_hresp_err <= '1';
            ctl_sm_ns       <= CTL_READ_ERR;
        elsif(rvalid_rready = '1') then
            if(last_axi_rd_sample = '1') then
             ctl_sm_ns <= CTL_IDLE;
            end if;
           set_hready <= '1';
           reset_hresp_err <= '1';
        else
           reset_hready <= '1';
           reset_hresp_err <= '1'; --Reset HRESP ERR if aleady set because of 
                                   -- previous transfer.
        end if;


    --------------------------------------------------------------------------
    -- Respect the protocol requirement to have 2 cycle error response on AHB
    -- while presenting a error response.
    -- Move to IDLE if the current error reponse is for last transfer
    -- of the read burst.
    -- Move to READ to accept furnther data after processing the current
    -- data with error response
    --------------------------------------------------------------------------
      when CTL_READ_ERR => 
        set_hready <= '1';
        set_hresp_err <= '1';
        if (M_AXI_RLAST_reg = '1') then
          ctl_sm_ns <= CTL_IDLE;
        else
          ctl_sm_ns <= CTL_READ;
        end if; 

    --------------------------------------------------------------------------
    -- Check if there pending transfers need to be address,which can occur
    --  burst termination.
    -- Respect the protocol requirement to have 2 cycle error response on AHB
    -- while presenting a error response.
    -- Move to IDLE if no pending transfers and hunt for a fresh transfer.
    --------------------------------------------------------------------------
      when CTL_BRESP => 
        if(axi_bresp_ok = '1' and
           (nonseq_txfer_pending = '1' or
            nonseq_detected      = '1')) then
          ctl_sm_ns <= CTL_ADDR;
          -- For nonseq_txfer_pending case use burst_term*
          -- For nonseq_detected      case use S_AHB_* signals
          -- No need to explicitly check nonseq is the pending or
          -- the current,as both cases lead to CTL_ADDR
          -- burst_term* signals are 1 clock delayed versions of the S_AHB*
          set_axi_raddr   <= not burst_term_hwrite or
                             not S_AHB_HWRITE;
          set_axi_waddr_i <=     burst_term_hwrite or
                                 S_AHB_HWRITE;
          reset_hready  <= (not burst_term_hwrite or
                            not S_AHB_HWRITE)     or
                           ((burst_term_hwrite    or
                             S_AHB_HWRITE)          and 
                            (burst_term_single_incr or
                             hburst_single_incr));
          enable_timeout_cnt_i <= '1';
          init_pending_txfer   <= '1';
        elsif(axi_bresp_ok = '1' and
           idle_txfer_pending = '1') then
           ctl_sm_ns         <= CTL_IDLE;
           set_hready        <= '1';
           reset_hresp_err   <= '1';
           init_pending_txfer<= '1';
        elsif (axi_bresp_err = '1') then
          ctl_sm_ns <= CTL_BRESP_ERR;
          axi_bresp_ready   <= '1';
          reset_hready      <= '1';
          set_hresp_err     <= '1';
        elsif(axi_bresp_ok = '1') then
          ctl_sm_ns         <= CTL_IDLE;
          set_hready        <= '1';
          reset_hresp_err   <= '1';
        end if; 

    --------------------------------------------------------------------------
    -- Respect the protocol requirement to have 2 cycle error response on AHB
    -- while presenting a error response.
    --------------------------------------------------------------------------
      when CTL_BRESP_ERR => 
        ctl_sm_ns         <= CTL_IDLE;
        axi_bresp_ready   <= '1';
        set_hready        <= '1';
        set_hresp_err     <= '1';

    --------------------------------------------------------------------------
    -- State machine will not reach others as all the possible combinations
    -- are explicitly mapped . State machines either retains in the current
    -- state or move to any valid state if a specified condition is met.
    --------------------------------------------------------------------------
      -- coverage off
      when others =>
        ctl_sm_ns <= CTL_IDLE; 
      -- coverate on 
    end case;
  end process CTL_SM;

--------------------------------------------------------------------------------
--Register the signals required,along with the current state
-- M_AXI_RLAST_reg used during ERROR response for last read transfer.
-- enable_timeout_cnt: To enable the timeout counter after the trasfer is
-- initiated on AXI.
--------------------------------------------------------------------------------
  CTL_SM_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        ctl_sm_cs          <= CTL_IDLE;
        ahb_wnr_i          <= '0';
        M_AXI_RLAST_reg    <= '0';
        enable_timeout_cnt <= '0';
      else
        ctl_sm_cs          <= ctl_sm_ns;
        ahb_wnr_i          <= set_axi_waddr_i;
        M_AXI_RLAST_reg    <= last_axi_rd_sample;
        enable_timeout_cnt <= enable_timeout_cnt_i;
      end if;
    end if;
  end process CTL_SM_REG;
end architecture RTL;
