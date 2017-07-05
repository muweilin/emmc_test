-------------------------------------------------------------------------------
-- ahb_if.vhd - entity/architecture pair
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
-- Filename:        ahb_if.vhd
-- Version:         v1.00a
-- Description:     This modules interfaces with the AHB side of the 
--                  bridge and generates/receives AHB signals.
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
-- Definition of Ports
--
-- System signals
-- AHB signals
--  S_AHB_HCLK               -- AHB Clock
--  S_AHB_HRESETN            -- AHB Reset Signal - active low
--  S_AHB_HADDR              -- AHB address bus
--  S_AHB_HSEL               -- Slave select signal for AHB interface
--  S_AHB_HTRANS             -- Indicates the type of the current transfer
--  S_AHB_HSIZE              -- Indicates the size of the transfer 
--  S_AHB_HWRITE             -- Direction indicates an AHB write access when
--                              high and an AHB read access when low
--  S_AHB_HBURST             -- Indicates if the transfer forms part of a burst
--  S_AHB_HREADY_IN          -- Ready signal from the system 
--  S_AHB_HREADY_OUT         -- Ready, AHB slave uses this signal to 
--                               qualify the input signals
--  S_AHB_HPROT              -- This signal indicates the normal,
--                              privileged, or secure protection level of the
--                              transaction and whether the transaction is a
--                              data access or an instruction access.
--  S_AHB_HRESP              -- This signal indicates transfer response.
--  S_AHB_HRDATA             -- AHB read data driven by slave  
-- 
--  ahb_if module
--  core_is_idle             -- Core is in IDLE state
--  nonseq_detected          -- Valid NONSEQ transaction detected
--  seq_detected             -- Valid SEQ transaction detected
--  busy_detected            -- Valid BUSY transaction detected
--  set_hready               -- Assert HREADY_OUT   
--  reset_hready             -- De-assert HREADY_OUT
--  set_hresp_err            -- Assert HRESP as ERROR
--  reset_hresp_err          -- De-assert HRESP as ERROR 

-- Write channel signals
--  M_AXI_AWID               -- Write address ID. This signal is the 
--                           -- identification tag for the write 
--                           -- address group of signals
--  M_AXI_AWLEN              -- Burst length. The burst length gives the
--                           -- exact number of transfers in a burst
--  M_AXI_AWSIZE             -- Burst size. This signal indicates the 
--                           -- size of each transfer in the burst
--  M_AXI_AWBURST            -- Burst type. The burst type, coupled with 
--                           -- the size information, details how the 
--                           -- address for each transfer within the 
--                           -- burst is calculated
--  M_AXI_AWCACHE            -- Cache type. This signal indicates the 
--                           -- bufferable,cacheable, write-through, 
--                           -- write-back,and allocate attributes of the 
--                           -- transaction 
--  M_AXI_AWADDR             -- Write address bus - The write address bus gives
--                              the address of the first transfer in a write
--                              burst transaction - fixed to 32
--  M_AXI_AWPROT             -- Protection type - This signal indicates the
--                              normal, privileged, or secure protection level
--                              of the transaction and whether the transaction
--                              is a data access or an instruction access
--  M_AXI_AWLOCK             -- Lock type. This signal provides additional 
                             -- information about the atomic characteristics
                             -- of the transfer
--  burst_term               -- Indicates burst termination on AHB side.
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
--  M_AXI_ARID               -- Read address ID. This signal is the 
--                           -- identification tag for the read address 
--                           -- group of signals
--  M_AXI_ARLEN              -- Burst length. The burst length gives the exact
--                           --  number of transfers in a burst
--  M_AXI_ARSIZE             -- Burst size. This signal indicates the size of 
                             -- each transfer in the burst
--  M_AXI_ARBURST            -- Burst type. The burst type, coupled with the 
--                           -- size information, details how the address for
                             -- each transfer within the burst is calculated
--  M_AXI_ARPROT             -- Protection type - This signal provides
--                              protection unit information for the transaction
--  M_AXI_ARCACHE            -- Cache type. This signal provides additional 
--                           --  information about the cacheable 
--                           --  characteristics of the transfer
--  M_AXI_ARADDR             -- Read address - The read address bus gives the
--                              initial address of a read burst transaction
--  M_AXI_ARLOCK             -- Lock type. This signal provides additional 
                             -- information about the atomic characteristics
                             -- of the transfer
--  txer_rdata_to_ahb        -- Read valid and can be captured - This signal 
--                              indicates that the required read data is
--                              available and the read
--                              transfer can complete
--  timeout_i                -- Timeout signal from the timeout module
-------------------------------------------------------------------------------
-- Generics & Signals Description
-------------------------------------------------------------------------------

entity ahb_if is
  generic (
    C_S_AHB_ADDR_WIDTH           : integer range 32 to 32  := 32;
    C_M_AXI_ADDR_WIDTH           : integer range 32 to 32  := 32;
    C_S_AHB_DATA_WIDTH           : integer range 32 to 64  := 32;
    C_M_AXI_DATA_WIDTH           : integer range 32 to 64  := 32;
    C_M_AXI_THREAD_ID_WIDTH      : integer                 := 4;  
    C_M_AXI_NON_SECURE           : integer                 := 1  
  );
  port (
  -- AHB Signals
     S_AHB_HCLK             : in  std_logic;                           
     S_AHB_HRESETN          : in  std_logic;                           
     S_AHB_HADDR            : in  std_logic_vector
                                  (C_S_AHB_ADDR_WIDTH-1 downto 0);
     S_AHB_HSEL             : in  std_logic;
     S_AHB_HTRANS           : in  std_logic_vector(1 downto 0); 
     S_AHB_HSIZE            : in  std_logic_vector(2 downto 0); 
     S_AHB_HWRITE           : in  std_logic; 
     S_AHB_HBURST           : in  std_logic_vector(2 downto 0 );
     S_AHB_HREADY_IN        : in  std_logic;  
     S_AHB_HREADY_OUT       : out std_logic; 
     S_AHB_HPROT            : in  std_logic_vector(3 downto 0); 
     S_AHB_HRESP            : out std_logic;
     S_AHB_HRDATA           : out std_logic_vector
                                  (C_S_AHB_DATA_WIDTH-1 downto 0 );
  -- AHB interface module 
     core_is_idle           : in  std_logic;
     ahb_valid_cnt          : in  std_logic_vector(4 downto 0);
     ahb_hwrite             : out std_logic;
  -- control module
     nonseq_detected        : out std_logic;
     seq_detected           : out std_logic;
     busy_detected          : out std_logic;
     set_hready             : in  std_logic;
     reset_hready           : in  std_logic;
     set_hresp_err          : in  std_logic;
     reset_hresp_err        : in  std_logic;
     nonseq_txfer_pending   : out std_logic;
     idle_txfer_pending     : out std_logic;
     burst_term_hwrite      : out std_logic;
     burst_term_single_incr : out std_logic;
     init_pending_txfer     : in  std_logic;
  
  -- AXI Write channel 
     M_AXI_AWID             : out std_logic_vector 
                                  (C_M_AXI_THREAD_ID_WIDTH-1 downto 0);
     M_AXI_AWLEN            : out std_logic_vector (7 downto 0);
     M_AXI_AWSIZE           : out std_logic_vector (2 downto 0);
     M_AXI_AWBURST          : out std_logic_vector (1 downto 0);
     M_AXI_AWCACHE          : out std_logic_vector (3 downto 0);
     M_AXI_AWADDR           : out std_logic_vector
                                  (C_M_AXI_ADDR_WIDTH-1 downto 0);
     M_AXI_AWPROT           : out std_logic_vector(2 downto 0);
     M_AXI_AWLOCK           : out std_logic;
     axi_wdata_done         : in  std_logic;    
     timeout_detected       : in  std_logic;
     last_axi_rd_sample     : in  std_logic;
     burst_term             : out std_logic;
     ahb_hburst_single      : out std_logic;
     ahb_hburst_incr        : out std_logic;
     ahb_hburst_wrap4       : out std_logic;
     ahb_haddr_hsize        : out std_logic_vector( 4 downto 0);
     ahb_hsize              : out std_logic_vector( 1 downto 0);
     valid_cnt_required     : out std_logic_vector(4 downto 0);
     burst_term_txer_cnt    : out std_logic_vector(4 downto 0);
     burst_term_cur_cnt     : out std_logic_vector(4 downto 0);
     ahb_data_valid         : out std_logic;
  
     placed_on_axi          : in  std_logic;
     placed_in_local_buf    : in  std_logic;
  -- AXI Read channel 
     M_AXI_ARID             : out std_logic_vector 
                                  (C_M_AXI_THREAD_ID_WIDTH-1 downto 0);
     M_AXI_ARLEN            : out std_logic_vector(7 downto 0);
     M_AXI_ARSIZE           : out std_logic_vector(2 downto 0);
     M_AXI_ARBURST          : out std_logic_vector(1 downto 0);
     M_AXI_ARPROT           : out std_logic_vector(2 downto 0);
     M_AXI_ARCACHE          : out std_logic_vector(3 downto 0);
     M_AXI_ARADDR           : out std_logic_vector
                                  (C_M_AXI_ADDR_WIDTH-1 downto 0);
     M_AXI_ARLOCK           : out std_logic;
     txer_rdata_to_ahb      : in  std_logic;
     M_AXI_RDATA            : in  std_logic_vector
                                 (C_M_AXI_DATA_WIDTH-1 downto 0 ) 
    );

end entity ahb_if;
-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

architecture RTL of ahb_if is
-------------------------------------------------------------------------------
-- PRAGMAS
-------------------------------------------------------------------------------

attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of RTL : architecture is "yes";


-------------------------------------------------------------------------------
 -- Signal declarations(Description of each signal is given in their 
 --    implementation block
-------------------------------------------------------------------------------
signal S_AHB_HREADY_OUT_i       : std_logic;
signal S_AHB_HRESP_i            : std_logic;
signal S_AHB_HRDATA_i           : std_logic_vector
                                   (C_S_AHB_DATA_WIDTH-1 downto 0 ); 
signal S_AHB_HBURST_i           : std_logic_vector ( 2 downto 0);
signal S_AHB_HSIZE_i            : std_logic_vector ( 2 downto 0);

signal valid_cnt_required_i     : std_logic_vector( 4 downto 0);
signal burst_term_txer_cnt_i    : std_logic_vector( 4 downto 0);
signal burst_term_cur_cnt_i     : std_logic_vector( 4 downto 0);
signal ahb_data_valid_i         : std_logic;
signal burst_term_i             : std_logic;
signal dummy_txfer_in_progress  : std_logic;
signal nonseq_detected_i        : std_logic;
signal seq_detected_i           : std_logic;
signal busy_detected_i          : std_logic;
signal idle_detected_i          : std_logic;
signal ahb_hburst_single_i      : std_logic;
signal ahb_hburst_incr_i        : std_logic;
signal ahb_hburst_wrap4_i       : std_logic;
signal ongoing_burst            : std_logic; 
signal ahb_burst_done           : std_logic;
signal ahb_penult_beat          : std_logic;
signal seq_rd_in_incr           : std_logic;
signal burst_term_with_nonseq   : std_logic;
signal burst_term_with_idle     : std_logic;
signal ahb_wr_burst_done        : std_logic;
signal ahb_done_axi_in_progress : std_logic; 
signal nonseq_txfer_pending_i   : std_logic;

--signal AXI_AID_i       : std_logic_vector  
--                            (C_M_AXI_THREAD_ID_WIDTH-1 downto 0);
signal AXI_ALEN_i      : std_logic_vector (7 downto 0);
signal AXI_ASIZE_i     : std_logic_vector (2 downto 0);
signal AXI_ABURST_i    : std_logic_vector (1 downto 0);
signal AXI_APROT_i     : std_logic_vector(2 downto 0);
signal AXI_ACACHE_i    : std_logic_vector (3 downto 0);
signal AXI_AADDR_i     : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
--signal AXI_ALOCK_i     : std_logic;
begin

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
    
--------------------------------------------------------------------------------
-- I/O signal assignements
--------------------------------------------------------------------------------
S_AHB_HREADY_OUT     <= S_AHB_HREADY_OUT_i;
S_AHB_HRESP          <= S_AHB_HRESP_i;
S_AHB_HRDATA         <= S_AHB_HRDATA_i;
valid_cnt_required   <= valid_cnt_required_i;
burst_term_txer_cnt  <= burst_term_txer_cnt_i;
burst_term_cur_cnt   <= burst_term_cur_cnt_i;
ahb_data_valid       <= ahb_data_valid_i;
burst_term           <= burst_term_i;
nonseq_detected      <= nonseq_detected_i;
seq_detected         <= seq_detected_i;
busy_detected        <= busy_detected_i;
ahb_hburst_single    <= ahb_hburst_single_i;
ahb_hburst_incr      <= ahb_hburst_incr_i;
ahb_hburst_wrap4     <= ahb_hburst_wrap4_i;


--------------------------------------------------------------------------------
-- Address control information for write and read channel.
-- Address control information is set using the same flop output
-- for both channels, corresponding WVALID will be asserted 
-- based on read or write transaction.(This minimises the flops required
-- on both the channels)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Write channel assignment
--------------------------------------------------------------------------------
M_AXI_AWID       <= (others => '0' );       
M_AXI_AWLEN      <= AXI_ALEN_i;      
M_AXI_AWSIZE     <= AXI_ASIZE_i;     
M_AXI_AWBURST    <= AXI_ABURST_i;    
M_AXI_AWPROT     <= AXI_APROT_i;     
M_AXI_AWCACHE    <= AXI_ACACHE_i;    
M_AXI_AWADDR     <= AXI_AADDR_i;     
M_AXI_AWLOCK     <= '0' ;  

--------------------------------------------------------------------------------
--Signals used to determine the initial and sub-sequent value for WSTRB
-- signals in write channel
--------------------------------------------------------------------------------
ahb_haddr_hsize  <= AXI_AADDR_i(2 downto 0)&S_AHB_HSIZE_i(1 downto 0);
ahb_hsize        <= S_AHB_HSIZE_i(1 downto 0);

--------------------------------------------------------------------------------
-- Read channel assignment
--------------------------------------------------------------------------------
M_AXI_ARID       <= (others => '0' );       
M_AXI_ARLEN      <= AXI_ALEN_i;      
M_AXI_ARSIZE     <= AXI_ASIZE_i;     
M_AXI_ARBURST    <= AXI_ABURST_i;    
M_AXI_ARPROT     <= AXI_APROT_i;     
M_AXI_ARCACHE    <= AXI_ACACHE_i;    
M_AXI_ARADDR     <= AXI_AADDR_i;     
M_AXI_ARLOCK     <= '0' ;     
--------------------------------------------------------------------------------
-- Signal to assert when a valid nonseq transfer on AHB interface is detected.
--------------------------------------------------------------------------------
nonseq_detected_i  <= '1' when 
                          ( S_AHB_HREADY_IN = '1' and 
                            S_AHB_HSEL      = '1' and
                            S_AHB_HTRANS    = NONSEQ)
                          else '0';
--------------------------------------------------------------------------------
-- Signal to assert when a valid seq transfer on AHB interface is detected.
--------------------------------------------------------------------------------
seq_detected_i     <= '1' when 
                          ( S_AHB_HREADY_IN = '1' and
                            S_AHB_HSEL      = '1' and
                            S_AHB_HTRANS    = SEQ)
                          else '0';

--------------------------------------------------------------------------------
-- Signal to assert when a valid busy transfer on AHB interface is detected.
--------------------------------------------------------------------------------
busy_detected_i     <= '1' when 
                          ( S_AHB_HREADY_IN = '1' and
                            S_AHB_HSEL      = '1' and
                            S_AHB_HTRANS    = BUSY)
                          else '0';

--------------------------------------------------------------------------------
-- Signal to assert when a valid idle transfer on AHB interface is detected
--------------------------------------------------------------------------------
idle_detected_i      <= '1' when 
                          ( S_AHB_HREADY_IN = '1' and
                            S_AHB_HSEL      = '1' and
                            S_AHB_HTRANS    = IDLE)
                          else '0';
 
--------------------------------------------------------------------------------
--Sample the HWRITE signal to be used by other modules 
--------------------------------------------------------------------------------
ahb_hwrite <= S_AHB_HWRITE;
 
--------------------------------------------------------------------------------
-- Required number of ahb-samples for a given burst are received
-- when the penultimate beat is set and next valid sequential transfer
-- is detected.
--------------------------------------------------------------------------------
ahb_burst_done <= ahb_penult_beat and seq_detected_i;

--------------------------------------------------------------------------------
--Do not receive further samples from when the required number of samples
-- for the current transfer are received and AXI is still processing the
-- transfer
--------------------------------------------------------------------------------
ahb_wr_burst_done <= (S_AHB_HWRITE and 
                     ahb_burst_done )  or ahb_done_axi_in_progress ;

--------------------------------------------------------------------------------
--Treat INCR READ transfer as SINGLE transfers on AXI.So limit AHB to place
-- further till the current SEQ transfer is processed by AXI
--------------------------------------------------------------------------------
seq_rd_in_incr <= seq_detected_i  and (not S_AHB_HWRITE)  and ahb_hburst_incr_i;

--------------------------------------------------------------------------------
--Burst transfer terminated due new NONSEQ on AHB
--------------------------------------------------------------------------------
burst_term_with_nonseq <= ongoing_burst and nonseq_detected_i;

--------------------------------------------------------------------------------
--Burst transfer terminated due new IDLE on AHB
--------------------------------------------------------------------------------
burst_term_with_idle  <= ongoing_burst and idle_detected_i;

--------------------------------------------------------------------------------
-- Burst is said to be ongoing,once the core started operating
--  (core_is_idle = '0') ,required number of samples from AHB
--  interface are not yet received, for any of the valid burst types.
--  Burst termination for INCR (indefinite length increment) is 
--  considered seperately.For indefinite length increment burst
--  termination,core does not need to send/receive the dummy transfer
--  on AXI,as INCR transfer is mapped to SINGLE transfer on AXI 
--------------------------------------------------------------------------------
ongoing_burst  <= '1' when
            (core_is_idle = '0' and 
             (ahb_burst_done = '0'   or
              ahb_done_axi_in_progress = '0')
            ) else '0';

--------------------------------------------------------------------------------
--Signal to indicate that the burst terminated with NONSEQ and this transfer
-- has to be serviced after the current burst termination transfer is completed.
--------------------------------------------------------------------------------
  nonseq_txfer_pending <= nonseq_txfer_pending_i;

--------------------------------------------------------------------------------
--Sample AHB signals required 
-- These signals are sampled at the start of the transfer and are valid
-- through out the transfer.
-- The sampled signals are used during burst trasfers to count
-- valid number of samples,initialize WSTRB signals etc.,
--------------------------------------------------------------------------------
   AHB_BURST_SIZE_PROT_REG : process ( S_AHB_HCLK ) is 
   begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        S_AHB_HBURST_i <= (others => '0');
        S_AHB_HSIZE_i  <= (others => '0');
        ahb_hburst_single_i <= '0';
        ahb_hburst_incr_i   <= '0';
        ahb_hburst_wrap4_i  <= '0';
      else
        if (S_AHB_HTRANS    = NONSEQ) then
          S_AHB_HBURST_i <= S_AHB_HBURST;
          S_AHB_HSIZE_i  <= S_AHB_HSIZE;
          if(S_AHB_HBURST = SINGLE) then
            ahb_hburst_single_i <= '1'; 
          else
            ahb_hburst_single_i <= '0';
          end if; 
          if(S_AHB_HBURST = INCR) then
            ahb_hburst_incr_i <= '1'; 
          else
            ahb_hburst_incr_i <= '0';
          end if; 
          if(S_AHB_HBURST = WRAP4) then
            ahb_hburst_wrap4_i <= '1'; 
          else
            ahb_hburst_wrap4_i <= '0';
          end if; 
        else 
          S_AHB_HBURST_i      <= S_AHB_HBURST_i;
          S_AHB_HSIZE_i       <= S_AHB_HSIZE_i;
          ahb_hburst_single_i <= ahb_hburst_single_i;
          ahb_hburst_incr_i   <= ahb_hburst_incr_i  ;
          ahb_hburst_wrap4_i  <= ahb_hburst_wrap4_i ;
        end if;
      end if;
    end if;
   end process AHB_BURST_SIZE_PROT_REG;

--------------------------------------------------------------------------------
--valid_cnt_required:To set the valid count required count for
-- INCR4/8/16 and WRAP 4/8/16 transfers
-- This count is the required number of samples to be received
-- from the AHB side for the current burst.
--------------------------------------------------------------------------------
  VALID_COUNTER_REG : process ( S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        valid_cnt_required_i <= (others => '0');
      else
        if( nonseq_detected_i = '1' ) then
          case S_AHB_HBURST is 
            when INCR4|WRAP4 =>
              valid_cnt_required_i <= INCR_WRAP_4;
            when INCR8|WRAP8 =>
              valid_cnt_required_i <= INCR_WRAP_8;
            when INCR16|WRAP16 =>
              valid_cnt_required_i <= INCR_WRAP_16;
            when others =>
              valid_cnt_required_i <= (others => '0');
          end case;
        else 
          valid_cnt_required_i <= valid_cnt_required_i;
        end if;
      end if;
    end if;
  end process VALID_COUNTER_REG;

--------------------------------------------------------------------------------
-- ahb_data_valid:Generated to indicate the AXI write channel that
-- the valid data present on AHB bus.
--------------------------------------------------------------------------------
  AHB_DATA_VALID_REG : process (S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        ahb_data_valid_i <= '0';
      else
        if (nonseq_detected_i = '1' or seq_detected_i = '1')then
          ahb_data_valid_i <= '1';
        elsif(busy_detected_i     = '1' or 
              idle_detected_i     = '1' or
              placed_on_axi       = '1' or
              placed_in_local_buf = '1'
              ) then
          ahb_data_valid_i <= '0';
        end if;
      end if;
    end if;
  end process AHB_DATA_VALID_REG;

--------------------------------------------------------------------------------
--To detect the penultimate beat of the AHB burst transfer
-- Hold this detection till the next valid sequential transfer is 
-- detected.
--------------------------------------------------------------------------------
  AHB_PENULT_BEAT_REG : process ( S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        ahb_penult_beat <= '0';
      else
        if(ahb_valid_cnt = valid_cnt_required_i-1) then
          ahb_penult_beat <= seq_detected_i;
        elsif(seq_detected_i    = '1' or -- Normal txfers
              nonseq_detected_i = '1' or -- Burst-term
              idle_detected_i   = '1'    -- Burst-term
             ) then
          ahb_penult_beat <= '0';
        end if;
      end if;
    end if;
  end process AHB_PENULT_BEAT_REG;

--------------------------------------------------------------------------------
--To limit acceptance of further samples from AHB after
-- required number of samples for the current burst are received
-- and the transfer on the AXI is in progress
--------------------------------------------------------------------------------
  AHB_DONE_AXI_PENDING_REG : process ( S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        ahb_done_axi_in_progress <= '0';
      else
        if(ahb_burst_done = '1') then
          ahb_done_axi_in_progress <= '1';
        elsif(axi_wdata_done = '1') then
          ahb_done_axi_in_progress <= '0';
        end if;
      end if;
    end if;
  end process AHB_DONE_AXI_PENDING_REG;

--------------------------------------------------------------------------------
--HREADY signal generation: 
-- set_hready and reset_hready are generated from the state machine
-- Before resetting,check for if the current placed transfer on AHB is busy 
-- transfer,in which case bridge needs to zero wait state response to BUSY
-- transfer.
-- To reset on sequential detection during writes and during reads
--  of indefinite length increment trasfer is controlled explicity.
-- When the required number of samples received for a particular burst during 
-- writes,HREADY is forced low till the response is given from the AXI interface
-- During timeout detection close the transaction with ERROR response.
--------------------------------------------------------------------------------
  AHB_HREADY_REG : process ( S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        S_AHB_HREADY_OUT_i <= '1';
      else
        if((timeout_detected = '0') and 
           (seq_rd_in_incr         = '1' or 
            ahb_wr_burst_done      = '1' or
            nonseq_txfer_pending_i = '1' or
            burst_term_with_nonseq = '1'
           )
          ) then
          S_AHB_HREADY_OUT_i <= '0';
        elsif( timeout_detected     = '0' and 
               burst_term_with_idle = '1' ) then
          S_AHB_HREADY_OUT_i <= '1';
        elsif(reset_hready = '1' ) then
          S_AHB_HREADY_OUT_i <= busy_detected_i;
        elsif(set_hready  = '1') then
          S_AHB_HREADY_OUT_i <= '1';
        else
          S_AHB_HREADY_OUT_i <= S_AHB_HREADY_OUT_i;
        end if;
      end if;
    end if;  
  end process AHB_HREADY_REG;

--------------------------------------------------------------------------------
-- HRESP is controlled based on the ERROR detection from AXI interface.
-- In all other cases HRESP is driven as OK.
--------------------------------------------------------------------------------
  AHB_HRESP_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then 
        S_AHB_HRESP_i <= AHB_HRESP_OKAY;
      else
        if(reset_hresp_err = '1') then
          S_AHB_HRESP_i <= AHB_HRESP_OKAY;
        elsif(set_hresp_err = '1') then
          S_AHB_HRESP_i <= AHB_HRESP_ERROR;
        else
          S_AHB_HRESP_i <= S_AHB_HRESP_i;
        end if; 
      end if;
    end if;
  end process AHB_HRESP_REG;
 
--------------------------------------------------------------------------------
--S_AHB_HRDATA: Present RDATA to AHB when valid 
--------------------------------------------------------------------------------
  AHB_HRDATA_REG : process (S_AHB_HCLK ) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        S_AHB_HRDATA_i  <= (others => '0');
      else
        if(txer_rdata_to_ahb = '1') then
          S_AHB_HRDATA_i  <= M_AXI_RDATA;
        end if;
      end if;
    end if;
  end process AHB_HRDATA_REG;
 
--------------------------------------------------------------------------------
--Qualifier for pending transfer when burst terminated with 
-- NONSEQ transfer
-- set was given high priority than the reset of this signal.
-- This will ensure,NONSEQ transfer initiated after 
-- the burst is terminated with IDLE transfer.
-- For IDLE transfer,no need to rise any requests on the AXI side,giving
-- HREADY = 1 to AHB for IDLE is enough.
--------------------------------------------------------------------------------
  AHB_PENDING_NONSEQ_REG : process(S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        nonseq_txfer_pending_i <= '0';
      else
        if(burst_term_with_nonseq = '1') then
          nonseq_txfer_pending_i <= '1';
        elsif(init_pending_txfer = '1') then
          nonseq_txfer_pending_i <= '0';
        end if;
      end if;
    end if;
  end process AHB_PENDING_NONSEQ_REG;
 
--------------------------------------------------------------------------------
--Qualifier for pending transfer when burst terminated with 
-- IDLE transfer
-- Reset is given high priority. Once the IDLE is detected,any number of
-- IDLE transfers after that is not required to be monitored.
-- Reset when the AXI side current trasfer is completed with dummy transfers.
-- If a NONSEQ after the burst termination by IDLE is detected,this will be 
-- handled in the AHB_PENDING_NONSEQ_REG process 
--------------------------------------------------------------------------------
  AHB_PENDING_IDLE_REG : process(S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        idle_txfer_pending <= '0';
      else
        if(init_pending_txfer = '1') then
          idle_txfer_pending <= '0';
        elsif(burst_term_with_idle = '1') then
          idle_txfer_pending <= '1';
        end if;
      end if;
    end if;
  end process AHB_PENDING_IDLE_REG;
 
--------------------------------------------------------------------------------
--Save transfer count for burst termination transfer
-- burst_term_txer_cnt_i: Total transfer required on AXI.
-- This count is used to generate WLAST,if the burst terminated 
-- due to NONSEQ 
-- No need to reset the cnt,again update with a fresh count 
-- when another termination is detected
-- burst_term_cur_cnt_i: Current number of AHB sample received before burst
--  termination
--------------------------------------------------------------------------------
  AHB_BURST_TERM_CNT_REG : process(S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        burst_term_txer_cnt_i <= (others => '0');
        burst_term_cur_cnt_i  <= (others => '0');
      else
        if(ongoing_burst = '1' and  burst_term_i = '0' and
             (nonseq_detected_i = '1' or
              idle_detected_i   = '1')) then
          burst_term_txer_cnt_i <= valid_cnt_required_i;
          burst_term_cur_cnt_i  <= ahb_valid_cnt;
        end if;
      end if;
    end if;
  end process AHB_BURST_TERM_CNT_REG;

--------------------------------------------------------------------------------
--Save the next transfer qualifiers when the burst is terminated
-- with NONSEQ transfer
-- Only two qualifiers are required to initiated the transfer when a burst
-- is terminated by NONSEQ transfer
--------------------------------------------------------------------------------
  AHB_BURST_TERM_QUALS_REG : process(S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
         burst_term_hwrite <= '0';
         burst_term_single_incr <= '0';
      else
        if(burst_term_with_nonseq = '1') then
          burst_term_hwrite <= S_AHB_HWRITE;
          if(S_AHB_HBURST = SINGLE or 
             S_AHB_HBURST = INCR ) then
           burst_term_single_incr <= '1';
          end if;
        end if;
      end if;
    end if;
  end process AHB_BURST_TERM_QUALS_REG;

--------------------------------------------------------------------------------
--Burst termination detection logic.
-- This signal is used in the axi write channel to force
-- write strobse to '0' when the burst termination is detected.
-- During read,this burst_term is used to swallow the read data from AXI
-- by not sending these to AHB.
--------------------------------------------------------------------------------
  AHB_BURST_TERM_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        burst_term_i <= '0';
      else
        if( axi_wdata_done          = '1' or  -- WRITE
            dummy_txfer_in_progress = '1' or  -- WRITE
            last_axi_rd_sample      = '1' or  -- READ
            (init_pending_txfer      = '1' and burst_term_i = '1') -- Initiated
                                            --pending txfers if any  
          ) then 
          burst_term_i <= '0';
        elsif(ongoing_burst = '1' and (idle_detected_i = '1' or
              nonseq_detected_i = '1')) then
          burst_term_i <= '1';
        end if;
      end if;
    end if;
  end process AHB_BURST_TERM_REG;

--------------------------------------------------------------------------------
--This process detects the dummy transfer progress in AXI
-- during burst termination
--------------------------------------------------------------------------------
  AXI_DUMMY_TXFER_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        dummy_txfer_in_progress <= '0';
      else
        if(axi_wdata_done = '1' ) then
          dummy_txfer_in_progress <= burst_term_i;
        elsif(init_pending_txfer = '1') then
          dummy_txfer_in_progress <= '0';
        end if;
      end if;
    end if;
  end process AXI_DUMMY_TXFER_REG;

--------------------------------------------------------------------------------
-- Below set of process blocks for  
-- generating AW* and AR* control signals(except AWVALID and ARVALID).
-- The same flop output is used by both read and write channels.
-- The validity of signals will be based on the AWVALID or ARVALID.
--------------------------------------------------------------------------------
--  AXI_A_ID_LOCK_REG : process (S_AHB_HCLK) is
--  begin
--    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
--      if(S_AHB_HRESETN = '0') then
--        AXI_AID_i <= (others => '0');
--        AXI_ALOCK_i <= '0';
--      else
--        AXI_AID_i <= (others => '0');
--        AXI_ALOCK_i <= '0';
--      end if;
--    end if;
--  end process AXI_A_ID_LOCK_REG;

  AXI_ALEN_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        AXI_ALEN_i <= (others => '0');
      else
        if( nonseq_detected_i = '1' or 
           (seq_detected_i = '1' and ahb_hburst_incr_i = '1')) then
          case S_AHB_HBURST is
            when WRAP4|INCR4 =>
              AXI_ALEN_i(3 downto 0)   <= AXI_ARWLEN_4;
            when WRAP8|INCR8 =>
              AXI_ALEN_i(3 downto 0)   <= AXI_ARWLEN_8;
            when WRAP16|INCR16 =>
              AXI_ALEN_i(3 downto 0)   <= AXI_ARWLEN_16;
            when others =>
              AXI_ALEN_i(3 downto 0)   <= AXI_ARWLEN_1;
          end case;
        end if;
      end if;
    end if;
  end process AXI_ALEN_REG;

  AXI_ASIZE_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        AXI_ASIZE_i   <= (others => '0');
      else
        AXI_ASIZE_i   <= S_AHB_HSIZE;
      end if;
    end if;
  end process AXI_ASIZE_REG;

  AXI_ABURST_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        AXI_ABURST_i <= (others => '0');
      else
        if( nonseq_detected_i = '1' or 
           (seq_detected_i = '1' and ahb_hburst_incr_i = '1')) then
          case S_AHB_HBURST is
            when WRAP4|WRAP8|WRAP16 =>
              AXI_ABURST_i <= AXI_ARWBURST_WRAP;
            when others =>
              AXI_ABURST_i <= AXI_ARWBURST_INCR;
          end case;
        end if;
      end if;
    end if;
  end process AXI_ABURST_REG;


 GEN_1_PROT_CACHE_REG_NON_SECURE : if C_M_AXI_NON_SECURE = 1 generate

  AXI_A_PROT_CACHE_REG_NON_SECURE : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        AXI_APROT_i <= "010";
        AXI_ACACHE_i <= "0011";
      else
        if( nonseq_detected_i = '1' or 
           (seq_detected_i = '1' and ahb_hburst_incr_i = '1')) then
          AXI_APROT_i(2)  <= not S_AHB_HPROT(0);
          AXI_APROT_i(1)  <= '1';
          AXI_APROT_i(0)  <=     S_AHB_HPROT(1);
          AXI_ACACHE_i(3) <= '0';
          AXI_ACACHE_i(2) <= '0';
          AXI_ACACHE_i(1) <= S_AHB_HPROT(3);
          AXI_ACACHE_i(0) <=     S_AHB_HPROT(2);
        end if;
      end if;
    end if;
  end process AXI_A_PROT_CACHE_REG_NON_SECURE;

 end generate GEN_1_PROT_CACHE_REG_NON_SECURE;

GEN_2_PROT_CACHE_REG_NON_SECURE : if C_M_AXI_NON_SECURE = 0 generate

  AXI_A_PROT_CACHE_REG_SECURE : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        AXI_APROT_i <= "000";
        AXI_ACACHE_i <= "0011";
      else
        if( nonseq_detected_i = '1' or 
           (seq_detected_i = '1' and ahb_hburst_incr_i = '1')) then
          AXI_APROT_i(2)  <= not S_AHB_HPROT(0);
          AXI_APROT_i(1)  <= '0';
          AXI_APROT_i(0)  <=     S_AHB_HPROT(1);
          AXI_ACACHE_i(3) <= '0';
          AXI_ACACHE_i(2) <= '0';
          AXI_ACACHE_i(1) <=  S_AHB_HPROT(3);
          AXI_ACACHE_i(0) <=     S_AHB_HPROT(2);
        end if;
      end if;
    end if;
  end process AXI_A_PROT_CACHE_REG_SECURE;

 end generate GEN_2_PROT_CACHE_REG_NON_SECURE;

  AXI_AADDR_REG : process (S_AHB_HCLK) is
  begin
    if (S_AHB_HCLK'event and S_AHB_HCLK = '1') then
      if(S_AHB_HRESETN = '0') then
        AXI_AADDR_i  <= (others => '0');
      else
        if( nonseq_detected_i = '1' or 
           (seq_detected_i = '1' and ahb_hburst_incr_i = '1')) then
          AXI_AADDR_i  <= S_AHB_HADDR;
        end if;
      end if;
    end if;
  end process AXI_AADDR_REG;
end architecture RTL;
