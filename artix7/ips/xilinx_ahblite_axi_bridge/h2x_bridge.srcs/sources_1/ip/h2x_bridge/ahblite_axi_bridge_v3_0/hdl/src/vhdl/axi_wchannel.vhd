-------------------------------------------------------------------------------
-- axi_wchannel.vhd - entity/architecture pair
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
-- Filename:        axi_wchannel.vhd
-- Version:         v1.00a
-- Description:     This module generates the AXI write transactions based on 
--                  the control and ahb information received on ahb-side.
--
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
-- Definition of Ports
--
-- System signals
--
-- AHB signals
--  S_AHB_HCLK               -- AHB Clock
--  S_AHB_HRESETN            -- AHB Reset Signal - active low
--  S_AHB_HWDATA             -- AHB write data
--
-- AXI Write address channel signals
--  M_AXI_AWVALID            -- Write address valid - This signal indicates
--                              that valid write address & control information
--                              are available
--  M_AXI_AWREADY            -- Write address ready - This signal indicates
--                              that the slave is ready to accept an address
--                              and associated control signals
--
-- AXI Write data channel signals
--
--  M_AXI_WDATA              -- Write data bus  
--  M_AXI_WSTRB              -- Write strobes - These signals indicates which
--                              byte lanes to update in memory
--  M_AXI_WLAST              -- Write last. This signal indicates the last 
--                           -- transfer in a write burst
--  M_AXI_WVALID             -- Write valid - This signal indicates that valid
--                              write data and strobes are available
--  M_AXI_WREADY             -- Write ready - This signal indicates that the
--                              slave can accept the write data
-- AXI Write response channel signals
--
--  M_AXI_BVALID             -- Write response valid - This signal indicates
--                              that a valid write response is available
--  M_AXI_BRESP              -- Write response - This signal indicates the
--                              status of the write transaction
--  M_AXI_BREADY             -- Response ready - This signal indicates that
--                              the master can accept the response information
--  axi_wdata_done           -- Asserted when  WVALID = 1 and  WREADY = 1 
--  axi_bresp_ok             -- Asserted when  BVALID = 1
--  axi_bresp_err            -- Asserted when  BVALID = 1 and ERROR = 1
--  set_axi_waddr            -- To set write addr on AXI interface 
--  ahb_wnr                  -- To set first burst write data data on AXI
--                               interface
--  set_axi_wdata_burst      -- To set next burst write data data on AXI
--                               interface
--  ahb_hburst_single        -- Transfer on AHB is SINGLE
--  ahb_hburst_incr          -- Transfer on AHB is INCR
--  ahb_hburst_wrap4         -- Transfer on AHB is WRAP4
--  ahb_haddr_hsize          -- Lower 3-bits of ADDR and lower 2-bits of
--                               HSIZE to determine WSTRB intial value.
--  ahb_hsize                -- Lower 2-bits of HSIZE to determine 
--                              sub sequent values of WSTRB
--  valid_cnt_required       -- Required number of transfers for the selected
--  ahb_data_valid           -- Control signal indicating the data on the AHB
--                              can be used.
--  burst_term               -- Indicates burst termination on AHB side.
--  axi_wr_channel_ready     -- Write channel ready to accept data from AHB
--  timeout_i                -- Timeout signal from the timeout module
-------------------------------------------------------------------------------
-- Generics & Signals Description
-------------------------------------------------------------------------------

entity axi_wchannel is
  generic (
    C_FAMILY                      : string := "virtex7";
    C_S_AHB_ADDR_WIDTH            : integer range 32 to 32    := 32;
    C_M_AXI_ADDR_WIDTH            : integer range 32 to 32    := 32;
    C_S_AHB_DATA_WIDTH            : integer range 32 to 64    := 32;
    C_M_AXI_DATA_WIDTH            : integer range 32 to 64    := 32;
    C_M_AXI_THREAD_ID_WIDTH       : integer                   := 4;
    C_M_AXI_SUPPORTS_NARROW_BURST : integer range 0 to 1      := 0 
    );
  port (
  -- AHB Signals
     S_AHB_HCLK           : in    std_logic;                           
     S_AHB_HRESETN        : in    std_logic;                           
     S_AHB_HWDATA         : in    std_logic_vector
                                  (C_S_AHB_DATA_WIDTH-1 downto 0);

  -- AXI Write Address Channel Signals
     M_AXI_AWVALID        : out   std_logic;
     M_AXI_AWREADY        : in    std_logic;
  -- AXI Write Data Chanel Signals
     M_AXI_WDATA          : out   std_logic_vector
                                  (C_M_AXI_DATA_WIDTH-1 downto 0);
     M_AXI_WSTRB          : out   std_logic_vector
                                  ((C_M_AXI_DATA_WIDTH/8)-1 downto 0);
     M_AXI_WLAST          : out   std_logic;
     M_AXI_WVALID         : out   std_logic;
     M_AXI_WREADY         : in    std_logic;
    
  -- AXI Write Response Channel Signals
     M_AXI_BVALID         : in    std_logic;
     M_AXI_BRESP          : in    std_logic_vector(1 downto 0);
     M_AXI_BREADY         : out   std_logic;

  -- Control state machine
     axi_wdata_done       : out std_logic;    
     axi_bresp_ok         : out std_logic;    
     axi_bresp_err        : out std_logic;    
     set_axi_waddr        : in  std_logic; 
     ahb_wnr              : in  std_logic;
     set_axi_wdata_burst  : in  std_logic;
     ahb_hburst_single    : in  std_logic;
     ahb_hburst_incr      : in  std_logic;
     ahb_hburst_wrap4     : in  std_logic;
     ahb_haddr_hsize      : in  std_logic_vector( 4 downto 0);
     ahb_hsize            : in  std_logic_vector( 1 downto 0);
     valid_cnt_required   : in  std_logic_vector( 4 downto 0);
     burst_term_txer_cnt  : in  std_logic_vector( 4 downto 0);
     ahb_data_valid       : in  std_logic; 
  -- ahb_data_counter module
     burst_term_cur_cnt   : in  std_logic_vector(4 downto 0);
  -- ahb_if module
     burst_term           : in  std_logic;
     nonseq_txfer_pending : in  std_logic;
     init_pending_txfer   : in  std_logic;
     axi_wr_channel_ready : out std_logic;
     axi_wr_channel_busy  : out std_logic;
     placed_on_axi        : out std_logic;
     placed_in_local_buf  : out std_logic;
     timeout_detected     : out std_logic;
  -- Time out module
     timeout_i            : in  std_logic;
     wr_load_timeout_cntr : out std_logic 
    );

--Equivalent register for wdata
  --attribute equivalent_register_removal: string;
  --attribute equivalent_register_removal of axi_wchannel :entity is "no";
end entity axi_wchannel;
-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

architecture RTL of axi_wchannel is
-------------------------------------------------------------------------------
-- PRAGMAS
-------------------------------------------------------------------------------

attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of RTL : architecture is "yes";


-------------------------------------------------------------------------------
 -- Signal declarations(Description of each signal is given in their 
 --    implementation block
-------------------------------------------------------------------------------
signal M_AXI_AWVALID_i        : std_logic;
signal M_AXI_WVALID_i         : std_logic;   
signal M_AXI_WLAST_i          : std_logic;
signal M_AXI_WSTRB_i          : std_logic_vector
                                 ((C_M_AXI_DATA_WIDTH/8)-1 downto 0);
signal M_AXI_WDATA_i          : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
signal local_en               : std_logic;
signal local_wdata            : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
signal axi_cnt_required       : std_logic_vector( 4 downto 0);


signal M_AXI_BREADY_i         : std_logic;

signal axi_waddr_done_i       : std_logic;
signal axi_bresp_ok_i         : std_logic;
signal axi_bresp_err_i        : std_logic;
signal axi_wdata_done_i       : std_logic;

signal axi_write_cnt_i        : std_logic_vector( 4 downto 0);
signal axi_wr_channel_busy_i  : std_logic;
signal axi_wr_channel_ready_i : std_logic;
signal axi_wr_data_sampled_i  : std_logic;

signal next_wr_strobe         : std_logic_vector(1 downto 0);

signal msb_in_wrap4           : std_logic_vector(2 downto 0);
signal axi_penult_beat        : std_logic;
signal axi_last_beat          : std_logic;

-- Signals used during burst termination
signal ahb_data_valid_burst_term : std_logic;
signal dummy_on_axi_init         : std_logic;
signal dummy_on_axi_progress     : std_logic;
signal dummy_on_axi              : std_logic;

signal timeout_in_data_phase     : std_logic;
signal timeout_detected_i        : std_logic;
-- Signals used for counter
signal cntr_rst               : std_logic;
signal cntr_load              : std_logic;
signal cntr_enable            : std_logic;
signal wr_load_timeout_cntr_i : std_logic;
begin

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
    
--------------------------------------------------------------------------------
--O/P Signal assignements
--------------------------------------------------------------------------------
--Write Address Channel
  M_AXI_AWVALID  <= M_AXI_AWVALID_i;
--Write Data Channel
  M_AXI_WLAST    <= M_AXI_WLAST_i; 
  M_AXI_WVALID   <= M_AXI_WVALID_i;
  M_AXI_WSTRB    <= M_AXI_WSTRB_i;
  M_AXI_WDATA    <= M_AXI_WDATA_i;
-- time_out module
  wr_load_timeout_cntr <= wr_load_timeout_cntr_i;

--------------------------------------------------------------------------------
-- Reset ahb_data_valid when the data on AHB is either placed on AXI or 
-- Stored internally in the local buffer.
-- placed_on_axi:
--  We can place the data from AHB to AXI when there is valid data from
--  AHB interface,AXI interface is ready to accept this data and there is
--  no pending data in the local buffer which is to be transferred to AXI
--------------------------------------------------------------------------------
placed_on_axi  <= axi_wr_channel_ready_i and ahb_data_valid and  not local_en;

--------------------------------------------------------------------------------
-- placed_in_local_buf: Place in local buffer
--    a.Valid data from AHB and Local buffer is empty and Write channel is
--      busy
--    b.Valid data from AHB and Local buffer in not empty but Write channel is
--      about to take that message from local buffer meaning AXI channel is 
--      ready to receive new data.In such case,we have to transfer data from
--      local buffer to AXI interface and AHB data to local buffer.
--      Depicting the case (b) below how the data flow when both 
--        AHB and AXI channels are ready and there is data pending to be 
--        transferred in local buffer
--      =====  Just before AHB and AXI are getting ready at the same time
---        AHB    Local_buf   AXI
--               _________
--               |       | 
--               |       | 
--               | DEAD  | 
--               |       | 
--               |       | 
--               --------
--      =====  When  AHB  ready to give new data
---     ====== When  AXI  ready to accept new data
---        AHB    Local_buf   AXI
--               _________
--               |       | 
--               |       | 
--      CEED     | DEAD  | 
--               |       | 
--               |       | 
--               --------
--      =====  After successfull transfer
---        AHB    Local_buf   AXI
--               _________
--               |       | 
--               |       | 
--               | CEED  |   DEAD
--               |       | 
--               |       | 
--               --------
--------------------------------------------------------------------------------
  placed_in_local_buf <= ahb_data_valid and 
                         (    
                         (not local_en and axi_wr_channel_busy_i) or
                         (local_en     and axi_wr_channel_ready_i)
                         );

  axi_wr_channel_busy  <= axi_wr_channel_busy_i ;
  axi_wr_channel_ready <= axi_wr_channel_ready_i;
--------------------------------------------------------------------------------
-- Accept further data from AHB when no data is placed on AXI(WVALID = 0) or
--  the current data is accepted by AXI(WVALID =1 and WREADY = 1),which 
-- simplifies to WVALID=0 or WREADY =1 [a + a'b = a + b]
--------------------------------------------------------------------------------
  axi_wr_channel_ready_i <= (not M_AXI_WVALID_i) or M_AXI_WREADY;

--------------------------------------------------------------------------------
--Write channel is considered busy when a data placed on AXI(WVALID=1) and 
-- the slave is not able to accept the data(WREADY=0)
--------------------------------------------------------------------------------
  axi_wr_channel_busy_i <= M_AXI_WVALID_i and (not M_AXI_WREADY);

--------------------------------------------------------------------------------
--Current data is said to be accepted by the slave when WVALID=1 and WREADY=1
--------------------------------------------------------------------------------
  axi_wr_data_sampled_i  <=  M_AXI_WVALID_i and M_AXI_WREADY;

--------------------------------------------------------------------------------
--Write response Channel
--------------------------------------------------------------------------------
  M_AXI_BREADY   <= M_AXI_BREADY_i;

  axi_bresp_ok   <= axi_bresp_ok_i;
  axi_bresp_err  <= axi_bresp_err_i;
  axi_wdata_done <= axi_wdata_done_i;

--------------------------------------------------------------------------------
--Update the timeout if detected
-- Will be reset only upon  S_AHB_HRESETN
--------------------------------------------------------------------------------
  timeout_detected  <= timeout_detected_i;

--------------------------------------------------------------------------------
--Data phase is completed when WLAST is detected along with WREADY
-- Also force the data phase to complete when timeout detected.
--------------------------------------------------------------------------------
  axi_wdata_done_i  <= (M_AXI_WREADY and  M_AXI_WLAST_i ) or timeout_detected_i;

--------------------------------------------------------------------------------
-- Write response error detection,consider timeout also as error.
--------------------------------------------------------------------------------
  axi_bresp_err_i   <= '1' when ((M_AXI_BVALID = '1' and
                                 (M_AXI_BRESP  = AXI_RESP_SLVERR or
                                  M_AXI_BRESP  = AXI_RESP_DECERR )) or
                                 timeout_detected_i = '1') 
                           else '0';
--------------------------------------------------------------------------------
-- Write response OK detection.In control state machine,error response is
-- given high priority. So,no need to explicity check for OK response
--------------------------------------------------------------------------------
  axi_bresp_ok_i    <= M_AXI_BVALID;

--------------------------------------------------------------------------------
--Internal signal assignments
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Reeset condition for counter
-- Counter is active high reset, Invert the IP reset.
--------------------------------------------------------------------------------
  cntr_rst         <= not S_AHB_HRESETN;
--------------------------------------------------------------------------------
--Load the counter during start of the write transfer(during address phase)
--------------------------------------------------------------------------------
  cntr_load        <= set_axi_waddr;

--------------------------------------------------------------------------------
-- Increment counter for every transfer sampled by AXI.
--------------------------------------------------------------------------------
  cntr_enable      <= M_AXI_WVALID_i and M_AXI_WREADY;
 
-------------------------------------------------------------------------------
-- Load fresh value to timeout counter once a valid sample is detected on AXI
--  side
--------------------------------------------------------------------------------
  wr_load_timeout_cntr_i <= M_AXI_WVALID_i and M_AXI_WREADY;
--------------------------------------------------------------------------------
--dummy_on_axi: Signal to force write strobes to '0' during burst termination
-- on AHB side.
--------------------------------------------------------------------------------
  dummy_on_axi <= dummy_on_axi_init or dummy_on_axi_progress;

--------------------------------------------------------------------------------
--dummy_on_axi_init: A pulse generated to mark the start of dummy transfer on
-- AXI during burst termination.
-- Dummy transfers should start on AXI when all the AHB samples before
-- burst terminated sequence(IDL/NONSEQ) are successfully transfered on AXI.
-- Logic Description:Dummy transfer has to be initiated in two cases.
--   Pre-conditions: This should be burst_term case and there should be no
--     pending dummy transfers currently happening.
--   Now, when the current transfer count is 1 less than the ahbcount and will
--   incremented immmediately when the current data is sampled or
--   AXI data is already sampled and count reached the number of ahb transfers
--     when the burst terminated.
-- For Ex: For a INCR4 transfer,if we get the following sequence from AHB
--   NONSEQ,SEQ,SEQ,IDL. Here the burst is terminated with IDL instead of
--   getting the next SEQ transfer. So only for the last data beat on
--   AXI we should put WSTROBE as "0". All other transfers before the
--   terminated transfer should be sent with the appropriate write strobe
--   values. 
--------------------------------------------------------------------------------
  dummy_on_axi_init <= '1' when 
                           (burst_term = '1')                       and
                           (dummy_on_axi_progress = '0')            and
                           (
                             ((axi_write_cnt_i = burst_term_cur_cnt-1) and 
                              (axi_wr_data_sampled_i = '1')) or 
                             (axi_write_cnt_i = burst_term_cur_cnt)
                            )
                           else
                       '0';

--------------------------------------------------------------------------------
--dummy_on_axi_progress: Once the dummy trasfer started,till the end of
-- the current transfer ,rest of the transfers on AXI should have write strobes
-- 0. This signal is set when dummy_on_axi_init is detected and set till the
--  last data is sampled on the AXI
--------------------------------------------------------------------------------
  AXI_DUMMY_FOR_BURST_TERM_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        dummy_on_axi_progress <= '0';
      else
        if(dummy_on_axi_init = '1') then
          dummy_on_axi_progress <= '1';
        elsif(axi_wdata_done_i = '1') then
          dummy_on_axi_progress <= '0';
        else
          dummy_on_axi_progress <= dummy_on_axi_progress;
        end if;
      end if;
    end if;
  end process AXI_DUMMY_FOR_BURST_TERM_REG;

--------------------------------------------------------------------------------
--When burst is terminated with NONSEQ, this NONSEQ transfer has to be processed
-- after current transfer(burs_term with write strobes as '0') is completed on 
-- AXI. So,the data on AHB is valid and has to be processed after the current
-- transfer completed.
--------------------------------------------------------------------------------
  BURST_TERM_WITH_NONSEQ_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then  
        ahb_data_valid_burst_term <= '0';
      else
        if(nonseq_txfer_pending = '1') then
          ahb_data_valid_burst_term <= '1';
        elsif(init_pending_txfer = '1') then
          ahb_data_valid_burst_term <= '0';
        else
          ahb_data_valid_burst_term <= ahb_data_valid_burst_term;
        end if;
      end if;
    end if;
  end process BURST_TERM_WITH_NONSEQ_REG;

--------------------------------------------------------------------------------
-- Also latch the ahb_hsize which will be used for
--  write strobe generation.
--  next_wr_strobe : Used to set the further write strobe value during the 
--                   narrow transfer.
-- We cannot use directly the ahb_hsize,since the ahb_hsize will be updated
--  every time a NONSEQ is detected,this will be an issue if there is
--  currently a transfer going on AXI.(This will occur during burst termination
--  case.)
--------------------------------------------------------------------------------
  AXI_NEXT_WR_STROBE_REG : process (S_AHB_HCLK) is 
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        next_wr_strobe     <= (others => '0');
      else
        if(ahb_wnr = '1') then
          next_wr_strobe <= ahb_hsize;
        else
          next_wr_strobe <= next_wr_strobe;
        end if;
      end if;
    end if;
  end process AXI_NEXT_WR_STROBE_REG;

--------------------------------------------------------------------------------
--Address control on AXI interface
--This process places the address control information on the AXI interface
--------------------------------------------------------------------------------
  AXI_AWVALID_REG : process (S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        M_AXI_AWVALID_i <= '0';
      else
        if(set_axi_waddr = '1' ) then
          M_AXI_AWVALID_i <= '1';
        elsif(M_AXI_AWREADY = '1') then
          M_AXI_AWVALID_i <= '0';
        else
          M_AXI_AWVALID_i <= M_AXI_AWVALID_i;
        end if;
      end if;
    end if;
  end process AXI_AWVALID_REG;

--------------------------------------------------------------------------------
--Pulse to indicate the address information PLACED on AXI.
--------------------------------------------------------------------------------
  AXI_AWADDR_DONE_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        axi_waddr_done_i <= '0';
      else
        if(set_axi_waddr = '1') then
          axi_waddr_done_i <= '1';
        else
          axi_waddr_done_i <= '0';
        end if;
      end if;
    end if;
  end process AXI_AWADDR_DONE_REG;
--------------------------------------------------------------------------------
-- Data control on AXI Interface
-- M_AXI_WVALID,M_AXI_WDATA
-- Asssert wvalid when the valid data present on AHB interface or 
-- data stored in local buffer and not yet placed on AXI during back pressure
-- from AXI.
-- Allow WVALID to be asserted during burst termination
-- Allow WVALID to be asserted if the burst-terminated with the NONSEQ,after
--  the current transfer is completed on AXI
--  as this will be the valid data for the pending transfer.
--------------------------------------------------------------------------------
  AXI_WVALID_REG : process ( S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        M_AXI_WVALID_i <= '0';
      else
        if(axi_wdata_done_i = '1') then
          M_AXI_WVALID_i <= '0';
        elsif(M_AXI_WVALID_i = '1' and M_AXI_WREADY = '0') then
          M_AXI_WVALID_i <= M_AXI_WVALID_i;
        elsif((ahb_wnr = '1' or set_axi_wdata_burst = '1')and  --Normal txfers
             (ahb_data_valid = '1' or local_en       = '1' )) or 
             (dummy_on_axi = '1')                             or --complete
                                                                --current burst
              (ahb_wnr = '1' and ahb_data_valid_burst_term = '1') --Pending 
                                                      -- nonseq transfer
              then
          M_AXI_WVALID_i <= '1';
        else
          M_AXI_WVALID_i <= '0';
        end if;
      end if;
    end if; 
  end process AXI_WVALID_REG;

  AXI_WDATA_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        M_AXI_WDATA_i   <= (others => '0');
      elsif(local_en = '1' and axi_wr_channel_ready_i = '1') then
          M_AXI_WDATA_i   <= local_wdata;
      elsif (axi_wr_channel_ready_i = '1') then
          M_AXI_WDATA_i   <= S_AHB_HWDATA;
      end if;
    end if;
  end process AXI_WDATA_REG;

--------------------------------------------------------------------------------
--Local data storage
-- Store the data from AHB if there is back pressure from AXI and a valid 
-- transfer is placed by AHB.
--------------------------------------------------------------------------------
  AXI_LOCAL_EN_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        local_en <= '0';
      else
        if( (axi_wr_channel_busy_i = '1' and
             ahb_data_valid      = '1'  ) or
            (local_en = '1' and
             axi_wr_data_sampled_i = '1' and
             ahb_data_valid        = '1') 
            ) then
          local_en <= '1';
        elsif(M_AXI_WREADY = '1') then
          local_en <= '0';
        end if;
      end if;
    end if;
  end process AXI_LOCAL_EN_REG;
--------------------------------------------------------------------------------
--To minimize the logic for the storage,always load the AHB data to local buffer
-- but limit the storage when the local_en is active.
--------------------------------------------------------------------------------
  AXI_WDATA_LOCAL_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        local_wdata  <= (others => '0');
      else
        if ( local_en   = '0' or
             (local_en = '1' and 
              axi_wr_data_sampled_i = '1' and 
              ahb_data_valid = '1')
           ) then
          local_wdata   <= S_AHB_HWDATA;
        end if; 
      end if;
    end if;
  end process AXI_WDATA_LOCAL_REG;
 
--------------------------------------------------------------------------------
-- Write strobe control on AXI side based on 
--  DATA_WIDTH generic,HSIZE,HADDR.
-- Below is the truth table.
-- D_WIDTH     HSIZE         HADDR  WSTRB
-- 32         000--Byte        0    0001
-- 32         000--Byte        1    0010
-- 32         000--Byte        2    0100
-- 32         000--Byte        3    1000
-- 32         001--Halfword    0    0011
-- 32         001--Halfword    2    1100
-- 32         010--Word        0    1111
-- 64         000--Byte        0    0000_0001
-- 64         000--Byte        1    0000_0010
-- 64         000--Byte        2    0000_0100
-- 64         000--Byte        3    0000_1000
-- 64         000--Byte        4    0001_0000
-- 64         000--Byte        5    0010_0000
-- 64         000--Byte        6    0100_0000
-- 64         000--Byte        7    1000_0000
-- 64         001--Halfword    0    0000_0011
-- 64         001--Halfword    2    0000_1100
-- 64         001--Halfword    4    0011_0000
-- 64         001--Halfword    6    1100_0000
-- 64         010--Word        0    0000_1111
-- 64         010--Word        4    1111_0000
-- 64         011--Doubleword  0    1111_1111
-- Check for NARROW Transfer support generic
-- If narrow transfer not required,force all Write strobes to '1'
-- Else force all write strobes to '0' and update the required fields
--  based on the case index values.
--------------------------------------------------------------------------------
  NARROW_TRANSFER_OFF : if (C_M_AXI_SUPPORTS_NARROW_BURST = 0) generate
  begin
    AXI_WSTRB_REG : process ( S_AHB_HCLK ) is
    begin
      if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
        if(S_AHB_HRESETN = '0') then
          M_AXI_WSTRB_i <= (others => '1');
        else
          if(dummy_on_axi = '1') then
            M_AXI_WSTRB_i <= (others => '0');
          else
            M_AXI_WSTRB_i <= (others => '1');
          end if;
        end if;
      end if;
    end process AXI_WSTRB_REG;
  end generate NARROW_TRANSFER_OFF;

--------------------------------------------------------------------------------
--WSTRB generation when data width is 32 and Narrow burst is 1
-- Init value of WSTRB depends on the lower 2-addr bits and lower 2- hsize bits
--------------------------------------------------------------------------------
  NARROW_TRANSFER_ON_DATA_WIDTH_32 : if ( C_M_AXI_SUPPORTS_NARROW_BURST = 1 and
                                          C_M_AXI_DATA_WIDTH = 32) generate
  begin
    AXI_WSTRB_REG : process ( S_AHB_HCLK ) is
    begin
      if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
        if(S_AHB_HRESETN = '0') then
          M_AXI_WSTRB_i <= (others => '1');
        else
          if(dummy_on_axi = '1' ) then
            M_AXI_WSTRB_i <= (others => '0');
          elsif( ahb_wnr             = '1') then
            M_AXI_WSTRB_i <= (others => '0'); 
            case   ahb_haddr_hsize (3 downto 0) is
              --Byte
              when "0000" =>
                M_AXI_WSTRB_i(3 downto 0) <= "0001";
              when "0100" =>
                M_AXI_WSTRB_i(3 downto 0) <= "0010";
              when "1000" =>
                M_AXI_WSTRB_i(3 downto 0) <= "0100";
              when "1100" =>
                M_AXI_WSTRB_i(3 downto 0) <= "1000";
              --Halfword
              when "0001" =>
                M_AXI_WSTRB_i(3 downto 0)  <= "0011";
              when "1001" =>
                M_AXI_WSTRB_i(3 downto 0)  <= "1100";
              --Word
              when "0010" =>
                M_AXI_WSTRB_i(3 downto 0)  <= "1111";
              when others =>
                M_AXI_WSTRB_i <= (others => '1'); 
            end case;
          elsif( M_AXI_WVALID_i = '1' and M_AXI_WREADY = '1') then
            case next_wr_strobe is
              when "00" =>
                M_AXI_WSTRB_i(3 downto 0) <= M_AXI_WSTRB_i(2 downto 0)&
                                             M_AXI_WSTRB_i(3);
              when "01" =>
                M_AXI_WSTRB_i(3 downto 0) <= M_AXI_WSTRB_i(1 downto 0)&
                                             M_AXI_WSTRB_i(3 downto 2);
              when "10" => 
                M_AXI_WSTRB_i             <= M_AXI_WSTRB_i;
              when others =>
                M_AXI_WSTRB_i <= M_AXI_WSTRB_i; 
            end case;
          end if;
        end if;
      end if;
    end process AXI_WSTRB_REG;
  end generate NARROW_TRANSFER_ON_DATA_WIDTH_32;

--------------------------------------------------------------------------------
--WSTRB generation when data width is 64 and Narrow burst is 1
-- Init value of WSTRB depends on the lower 3-addr bits and lower 2- hsize bits
--------------------------------------------------------------------------------
  NARROW_TRANSFER_ON_DATA_WIDTH_64 : if ( C_M_AXI_SUPPORTS_NARROW_BURST = 1 and
                                          C_M_AXI_DATA_WIDTH = 64) generate
  begin
    AXI_WSTRB_REG : process ( S_AHB_HCLK ) is
    begin
      if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
        if(S_AHB_HRESETN = '0') then
          M_AXI_WSTRB_i <= (others => '1');
          msb_in_wrap4  <= (others => '0');
        else
          if(dummy_on_axi = '1' ) then
            M_AXI_WSTRB_i <= (others => '0');
            msb_in_wrap4  <= (others => '0');
          elsif( ahb_wnr             = '1') then
            M_AXI_WSTRB_i <= (others => '0'); 
            msb_in_wrap4  <= (others => '0');
            case   ahb_haddr_hsize  is
              --Byte
              when "00000" =>
                M_AXI_WSTRB_i(7 downto 0) <= "00000001";
                msb_in_wrap4  <=  "011";
              when "00100" =>
                M_AXI_WSTRB_i(7 downto 0) <= "00000010";
                msb_in_wrap4  <=  "011";
              when "01000" =>
                M_AXI_WSTRB_i(7 downto 0) <= "00000100";
                msb_in_wrap4  <=  "011";
              when "01100" =>
                M_AXI_WSTRB_i(7 downto 0) <= "00001000";
                msb_in_wrap4  <=  "011";
              when "10000" =>
                M_AXI_WSTRB_i(7 downto 0) <= "00010000";
                msb_in_wrap4  <=  "111";
              when "10100" =>
                M_AXI_WSTRB_i(7 downto 0) <= "00100000";
                msb_in_wrap4  <=  "111";
              when "11000" =>
                M_AXI_WSTRB_i(7 downto 0) <= "01000000";
                msb_in_wrap4  <=  "111";
              when "11100" =>
                M_AXI_WSTRB_i(7 downto 0) <= "10000000";
                msb_in_wrap4  <=  "111";
              --Halfword
              when "00001" =>
                M_AXI_WSTRB_i(7 downto 0)  <= "00000011";
              when "01001" =>
                M_AXI_WSTRB_i(7 downto 0)  <= "00001100";
              when "10001" =>
                M_AXI_WSTRB_i(7 downto 0)  <= "00110000";
              when "11001" =>
                M_AXI_WSTRB_i(7 downto 0)  <= "11000000";
              --Word
              when "00010" =>
                M_AXI_WSTRB_i(7 downto 0)  <= "00001111";
              when "10010" =>
                M_AXI_WSTRB_i(7 downto 0)  <= "11110000";
              --Double word
              when "00011" =>
                M_AXI_WSTRB_i(7 downto 0)  <= "11111111";
              when others =>
                M_AXI_WSTRB_i <= (others => '1'); 
            end case;
          elsif( M_AXI_WVALID_i = '1' and M_AXI_WREADY = '1') then
            case next_wr_strobe is
              when "00" =>
                if(ahb_hburst_wrap4 = '0') then
                  M_AXI_WSTRB_i(7 downto 0) <= M_AXI_WSTRB_i(6 downto 0)&
                                               M_AXI_WSTRB_i(7);
                else
                  if(msb_in_wrap4 = "111") then
                    M_AXI_WSTRB_i(7 downto 4) <= M_AXI_WSTRB_i(6 downto 4)&
                                                 M_AXI_WSTRB_i(7);
                  else
                    M_AXI_WSTRB_i(3 downto 0) <= M_AXI_WSTRB_i(2 downto 0)&
                                                 M_AXI_WSTRB_i(3);
                  end if;
                end if;
              when "01" =>
                M_AXI_WSTRB_i(7 downto 0) <= M_AXI_WSTRB_i(5 downto 0)&
                                             M_AXI_WSTRB_i(7 downto 6);
              when "10" =>
                M_AXI_WSTRB_i(7 downto 0) <= M_AXI_WSTRB_i(3 downto 0)&
                                             M_AXI_WSTRB_i(7 downto 4);
              when "11" => 
                M_AXI_WSTRB_i             <= M_AXI_WSTRB_i;
              -- coverage off
              when others =>
                M_AXI_WSTRB_i <= (others => '1'); 
              -- coverage on
            end case;
          end if;
        end if;
      end if;
    end process AXI_WSTRB_REG;
  end generate NARROW_TRANSFER_ON_DATA_WIDTH_64;

--------------------------------------------------------------------------------
--M_AXI_WLAST generation.This signal is generated to indicate the last
-- trnasfer of the burst
-- During penultimate beat of the transfer,assert WLAST if there is already
-- next valid transfer on AHB.
-- Else, asssert WLAST when next valid transfer on AHB is available.
-- Reset WLAST after the last data beat is sampled by the AXI slave.
-- Once set,do not change WLAST till this is sampled by slave.
-- During burst termination assert WVALID for the rest of the transfers.
-- WSTRB  is tied to all zeros when initiating dummy transfer because
-- of burst termination on the AHB interface.
--------------------------------------------------------------------------------
  AXI_WLAST_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        M_AXI_WLAST_i <= '0';
      else
        if(axi_waddr_done_i = '1' and 
           (ahb_hburst_single = '1' or
            ahb_hburst_incr   = '1')) then
          M_AXI_WLAST_i <= '1';
        elsif( M_AXI_WREADY = '0' and M_AXI_WLAST_i = '1') then
          M_AXI_WLAST_i <= M_AXI_WLAST_i;
        elsif( M_AXI_WREADY = '1' and M_AXI_WLAST_i = '1') then
          M_AXI_WLAST_i <= '0';
        elsif(axi_penult_beat   = '1' ) then
          M_AXI_WLAST_i <= (ahb_data_valid or local_en or burst_term )and 
                            axi_wr_data_sampled_i;
        elsif(axi_last_beat = '1') then
          M_AXI_WLAST_i <= (ahb_data_valid  or local_en or burst_term ); 
        else
          M_AXI_WLAST_i <= M_AXI_WLAST_i;
        end if;
      end if;
    end if;
  end process AXI_WLAST_REG;

--------------------------------------------------------------------------------
--Latch the requested count(no.of data to be transferred) when starting a new
-- transaction on AXI
--------------------------------------------------------------------------------
  AXI_CNT_REQUIRED_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        axi_cnt_required  <= (others => '0');
      else
        if(ahb_wnr = '1') then
          axi_cnt_required <= valid_cnt_required;
        else 
          axi_cnt_required <= axi_cnt_required;
        end if;
      end if;
    end if;
  end process AXI_CNT_REQUIRED_REG;
--------------------------------------------------------------------------------
--Generate a penultimate signal to assert WLAST when next valid ahb-sample
-- is received.
-- assert when axi_penult_beat when last but 1 data is placed(NOT ACCEPTED)
-- on the AXI interface.
-- If the subsequent beat is also a valid data from AHB,core can assert
-- WLAST.
-- If the subsequent beat in not a valid data from AHB,WLAST should be delayed
-- till valid data is seen on AHB.WLAST during such situations is taken care
-- using axi_last_beat signal generation
--------------------------------------------------------------------------------
  AXI_PENULT_BEAT_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        axi_penult_beat <= '0';
      else
        if(burst_term = '1') and
          (axi_write_cnt_i = burst_term_txer_cnt-2 ) then
          axi_penult_beat <= axi_wr_data_sampled_i;
        elsif(axi_write_cnt_i = axi_cnt_required-2 ) then
          axi_penult_beat <= axi_wr_data_sampled_i;
        elsif(axi_wr_data_sampled_i = '1') then
          axi_penult_beat <= '0';
        end if;
      end if;
    end if;
  end process AXI_PENULT_BEAT_REG;

--------------------------------------------------------------------------------
--Assert axi_last_beat when N-1 required samples are accepeted by AXI.
-- Now if a further valid data is seen on AHB,this becomes the last
-- transfer of the burst.
-- [NOTES]The generation of the axi_penult_beat and axi_last_beat 
-- improves the timing as the count comparision is done ahead of 1 
-- clock and a single bit is used in the WLAST generation logic.
--------------------------------------------------------------------------------
  AXI_LAST_BEAT_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        axi_last_beat <= '0';
      else
        if(burst_term = '1')and
          (axi_write_cnt_i = burst_term_txer_cnt-1 ) then
          axi_last_beat <= axi_wr_data_sampled_i;
        elsif(axi_write_cnt_i = axi_cnt_required-1 ) then
          axi_last_beat <= axi_wr_data_sampled_i;
        elsif(axi_wr_data_sampled_i = '1') then
          axi_last_beat <= '0';
        end if;
      end if;
    end if;
  end process AXI_LAST_BEAT_REG;
--------------------------------------------------------------------------------
--To count the valid transfer placed on the AXI interface
--------------------------------------------------------------------------------
  AXI_WRITE_CNT_MODULE : entity ahblite_axi_bridge_v3_0.counter_f
     generic map(
       C_NUM_BITS    =>  AXI_WRITE_CNT_WIDTH,
       C_FAMILY      =>  C_FAMILY
         )
     port map(
       Clk           =>  S_AHB_HCLK,
       Rst           =>  cntr_rst,
       Load_In       =>  "00000" ,
       Count_Enable  =>  cntr_enable,
       Count_Load    =>  cntr_load,
       Count_Down    =>  '0',
       Count_Out     =>  axi_write_cnt_i,
       Carry_Out     =>  open
       );
     
--------------------------------------------------------------------------------
-- M_AXI_BREADY generation: 
-- Convey to slave that the bridge is ready to accept the transfer response
-- after placing the address information.De-assert after the response is seen
-- from AXI slave interface or timed out beacuse on NO response from AXI slave. 
--------------------------------------------------------------------------------
  AXI_BREADY_REG : process ( S_AHB_HCLK ) is 
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        M_AXI_BREADY_i <= '0';
      else
        if(axi_waddr_done_i = '1') then
          M_AXI_BREADY_i <= '1';
        elsif(M_AXI_BVALID = '1' or timeout_detected_i = '1') then
          M_AXI_BREADY_i <= '0';
        else
          M_AXI_BREADY_i <= M_AXI_BREADY_i;
        end if;
      end if;
    end if;
  end process AXI_BREADY_REG;

--------------------------------------------------------------------------------
-- Latch the timeout_i if occured during DATA or BRESP phases
--------------------------------------------------------------------------------
  TIMEOUT_IN_DATAPHASE_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        timeout_detected_i <= '0';
      else
        if(timeout_i = '1') then
          timeout_detected_i <= '1';
        else
          timeout_detected_i <= timeout_detected_i;
        end if;
      end if;
    end if;
  end process TIMEOUT_IN_DATAPHASE_REG;
end architecture RTL;
