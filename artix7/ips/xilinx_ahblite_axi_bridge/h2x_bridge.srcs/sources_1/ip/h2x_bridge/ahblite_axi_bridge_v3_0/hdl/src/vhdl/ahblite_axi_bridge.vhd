-------------------------------------------------------------------------------
-- ahblite_axi_bridge.vhd - entity/architecture pair
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
-- Filename:        ahblite_axi_bridge.vhd
-- Version:         v1.00a
-- Description:     The AHB lite to AXI bridge translates AHB lite
--                  transactions into AXI  transactions. It functions as a
--                  AHB lite slave on the AHB port and an AXI master on
--                  the AXI interface.
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
-- Author:  Kondalarao P( kpolise@xilinx.com )      
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

-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------

--
-- Definition of Generics
--
-- System Parameters
-- C_FAMILY                   -- FPGA Family for which the ahblite_axi_bridge is
--                            -- targetted
-- C_INSTANCE                 -- Instance name in the system.
-- C_S_AHB_ADDR_WIDTH         -- Width of AHBLite address bus
-- C_M_AXI_ADDR_WIDTH         -- Width of AXI address bus
-- C_S_AHB_DATA_WIDTH         -- Width of AHBLite data buse
-- C_M_AXI_DATA_WIDTH         -- Width of AXI data buse
-- C_M_AXI_SUPPORTS_NARROW_BURST  -- Generic to select narrow transfer support.
--                                0 - No Narrow transfer support.
--                                1 - Narrow transfer supported.
-- C_M_AXI_NON_SECURE         -- make the ARCACHE/AWCACHE(1) = '1' else '0'
-- AXI Parameters
--
-- C_M_AXI_PROTOCOL           -- axi4lite protocol
-- C_M_AXI_THREAD_ID_WIDTH           -- ID width of read and write channels 
--
-- AHBLite Parameters
--
-- C_AHB_AXI_TIMEOUT          -- Timeout value to count for AXI slave not
--                            -- responding with BVALID during write response
--                            -- or RVALID during read data phases.
--
-- Definition of Ports
--
-- AHB signals
--  s_ahb_hclk               -- AHB Clock
--  s_ahb_hresetn            -- AHB Reset Signal - active low
--  s_ahb_hsel               -- Slave select signal for AHB interface
--  s_ahb_haddr              -- AHB address bus
--  s_ahb_hprot              -- This signal indicates the normal,
--                              privileged, or secure protection level of the
--                              transaction and whether the transaction is a
--                              data access or an instruction access.
--  s_ahb_htrans             -- Indicates the type of the current transfer
--  s_ahb_hsize              -- Indicates the size of the transfer 
--  s_ahb_hwrite             -- Direction indicates an AHB write access when
--                              high and an AHB read access when low
--  s_ahb_hburst             -- Indicates if the transfer forms part of a burst
--  s_ahb_hwdata             -- AHB write data
--  s_ahb_hready_out         -- Ready, the AHB slave uses this signal to
--                              extend an AHB transfer
--  s_ahb_hready_in          -- Ready signal from the system 
--  s_ahb_hrdata             -- AHB read data driven by slave  
--  s_ahb_hresp              -- This signal indicates transfer response.

-- AXI Signals
--
--  m_axi_aclk               -- AXI Clock
--  m_axi_aresetn            -- AXI Reset Signal - active low
--
-- Axi write address channel signals
--  m_axi_awid               -- Write address ID. This signal is the
--                           -- identification tag for the write address 
--                           -- group of signals
--  m_axi_awlen              -- Burst length. The burst length gives the 
--                           -- exact number of transfers in a burst
--  m_axi_awsize             -- Burst size. This signal indicates the size 
--                           -- of each transfer in the burst
--  m_axi_awburst            -- Burst type. The burst type, coupled with
--                           -- the size information, details how the address 
--                           -- for each transfer within the burst is calculated
--  m_axi_awaddr             -- Write address bus - The write address bus gives
--                              the address of the first transfer in a write
--                              burst transaction - fixed to 32
--  m_axi_awcache            -- Cache type. This signal indicates 
--                           -- the bufferable,cacheable, write-through, 
--                           -- write-back,and allocate attributes of the
--                           -- transaction 
--  m_axi_awprot             -- Protection type - This signal indicates the
--                              normal, privileged, or secure protection level
--                              of the transaction and whether the transaction
--                              is a data access or an instruction access
--  m_axi_awvalid            -- Write address valid - This signal indicates
--                              that valid write address & control information
--                              are available
--  m_axi_awready            -- Write address ready - This signal indicates
--                              that the slave is ready to accept an address
--                              and associated control signals
--  m_axi_awlock             -- Lock type. This signal provides additional 
                             -- information about the atomic characteristics
                             -- of the transfer
--
-- Axi write data channel signals
--
--  m_axi_wdata              -- Write data bus  
--  m_axi_wstrb              -- Write strobes - These signals indicates which
--                              byte lanes to update in memory
--  m_axi_wlast              -- Write last. This signal indicates the last 
--                           -- transfer in a write burst
--  m_axi_wvalid             -- Write valid - This signal indicates that valid
--                              write data and strobes are available
--  m_axi_wready             -- Write ready - This signal indicates that the
--                              slave can accept the write data
-- Axi write response channel signals
--
--  m_axi_bid                -- Response ID. The identification tag of the 
--                           -- write response
--  m_axi_bresp              -- Write response - This signal indicates the
--                              status of the write transaction
--  m_axi_bvalid             -- Write response valid - This signal indicates
--                              that a valid write response is available
--  m_axi_bready             -- Response ready - This signal indicates that
--                              the master can accept the response information
--
-- Axi read address channel signals
--
--  m_axi_arid               -- Read address ID. This signal is the 
--                           -- identification tag for the read address group 
--                           -- of signals
--  m_axi_araddr             -- Read address - The read address bus gives the
--                              initial address of a read burst transaction
--  m_axi_arprot             -- Protection type - This signal provides
--                              protection unit information for the transaction
--  m_axi_arcache            -- Cache type. This signal provides additional 
--                              information about the cacheable 
--                           -- characteristics of the transfer
--  m_axi_arvalid            -- Read address valid - This signal indicates,
--                              when HIGH, that the read address and control
--                              information is valid and will remain stable
--                              until the address acknowledge signal,ARREADY,
--                              is high.
--  m_axi_arlen              -- Burst length. The burst length gives the 
--                           -- exact number of transfers in a burst
--  m_axi_arsize             -- Burst size. This signal indicates the size of i
                             -- each transfer in the burst
--  m_axi_arburst            -- Burst type. The burst type, coupled with the 
--                           -- size information, details how the address for
                             -- each transfer within the burst is calculated
--  m_axi_arlock             -- Lock type. This signal provides additional 
                             -- information about the atomic characteristics
                             -- of the transfer
--  m_axi_arready            -- Read address ready - This signal indicates
--                              that the slave is ready to accept an address
--                              and associated control signals:
--
-- Axi read data channel signals
--
--  m_axi_rid                -- Read ID tag. This signal is the ID tag of 
                             -- the read data group of signals
--  m_axi_rdata              -- Read data bus - fixed to 32
--  m_axi_rresp              -- Read response - This signal indicates the
--                              status of the read transfer
--  m_axi_rvalid             -- Read valid - This signal indicates that the
--                              required read data is available and the read
--                              transfer can complete
--  m_axi_rlast              -- Read last. This signal indicates the 
--                           -- last transfer in a read burst
--  m_axi_rready             -- Read ready - This signal indicates that the
--                              master can accept the read data and response
--                              information
-------------------------------------------------------------------------------
-- Generics & Signals Description
-------------------------------------------------------------------------------

entity ahblite_axi_bridge is
  generic (
    C_FAMILY                      : string                    := "virtex7";
    C_INSTANCE                    : string                    := "ahblite_axi_bridge_inst";
    C_M_AXI_SUPPORTS_NARROW_BURST : integer range 0 to 1      := 0;
    C_S_AHB_ADDR_WIDTH            : integer range 32 to 32    := 32;
    C_M_AXI_ADDR_WIDTH            : integer range 32 to 32    := 32;
    C_S_AHB_DATA_WIDTH            : integer range 32 to 64    := 32;
    C_M_AXI_DATA_WIDTH            : integer range 32 to 64    := 32;
    C_M_AXI_PROTOCOL              : string                    := "AXI4";
    C_M_AXI_THREAD_ID_WIDTH       : integer                   := 4;
    C_AHB_AXI_TIMEOUT             : integer                   := 0; 
    C_M_AXI_NON_SECURE             : integer                   := 1 
    );
  port (
  -- AHB Signals
     s_ahb_hclk        : in  std_logic;                           
     s_ahb_hresetn     : in  std_logic;                           
     s_ahb_hsel        : in  std_logic;
       
     --S_AHB_HADDR       : in  std_logic_vector(C_S_AHB_ADDR_WIDTH-1 downto 0); 
     s_ahb_haddr       : in  std_logic_vector(32-1 downto 0); 
     s_ahb_hprot       : in  std_logic_vector(3 downto 0); 
     s_ahb_htrans      : in  std_logic_vector(1 downto 0); 
     s_ahb_hsize       : in  std_logic_vector(2 downto 0); 
     s_ahb_hwrite      : in  std_logic; 
     s_ahb_hburst      : in  std_logic_vector(2 downto 0 );
     s_ahb_hwdata      : in  std_logic_vector(C_S_AHB_DATA_WIDTH-1 downto 0 );

     s_ahb_hready_out  : out std_logic; 
     s_ahb_hready_in   : in  std_logic; 
                      
     s_ahb_hrdata      : out std_logic_vector(C_S_AHB_DATA_WIDTH-1 downto 0 );
     s_ahb_hresp       : out std_logic;

  -- AXI signals
--    m_axi_aclk         : out std_logic;
--    m_axi_aresetn      : out std_logic;

  -- AXI Write Address Channel Signals
    m_axi_awid         : out std_logic_vector 
                             (C_M_AXI_THREAD_ID_WIDTH-1 downto 0);
    m_axi_awlen        : out std_logic_vector (7 downto 0);
    m_axi_awsize       : out std_logic_vector (2 downto 0);
    m_axi_awburst      : out std_logic_vector (1 downto 0);
    m_axi_awcache      : out std_logic_vector (3 downto 0);
    --M_AXI_AWADDR       : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    m_axi_awaddr       : out std_logic_vector(32-1 downto 0);
    m_axi_awprot       : out std_logic_vector(2 downto 0);
    m_axi_awvalid      : out std_logic;
    m_axi_awready      : in  std_logic;
    m_axi_awlock       : out std_logic;
 -- AXI Write Data Channel Signals
    m_axi_wdata        : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    m_axi_wstrb        : out std_logic_vector
                             ((C_M_AXI_DATA_WIDTH/8)-1 downto 0);
    m_axi_wlast        : out std_logic;
    m_axi_wvalid       : out std_logic;
    m_axi_wready       : in  std_logic;
    
 -- AXI Write Response Channel Signals
    m_axi_bid          : in  std_logic_vector 
                             (C_M_AXI_THREAD_ID_WIDTH-1 downto 0);
    m_axi_bresp        : in  std_logic_vector(1 downto 0);
    m_axi_bvalid       : in  std_logic;
    m_axi_bready       : out std_logic;

 -- AXI Read Address Channel Signals
    m_axi_arid         : out std_logic_vector 
                             (C_M_AXI_THREAD_ID_WIDTH-1 downto 0);
    m_axi_arlen        : out std_logic_vector(7 downto 0);
    m_axi_arsize       : out std_logic_vector(2 downto 0);
    m_axi_arburst      : out std_logic_vector(1 downto 0);
    m_axi_arprot       : out std_logic_vector(2 downto 0);
    m_axi_arcache      : out std_logic_vector(3 downto 0);
    m_axi_arvalid      : out std_logic;
    --M_AXI_ARADDR       : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    m_axi_araddr       : out std_logic_vector(32-1 downto 0);
    m_axi_arlock       : out std_logic;
    m_axi_arready      : in  std_logic;
 -- AXI Read Data Channel Sigals
    m_axi_rid          : in  std_logic_vector 
                             (C_M_AXI_THREAD_ID_WIDTH-1 downto 0);
    m_axi_rdata        : in  std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    m_axi_rresp        : in  std_logic_vector(1 downto 0);
    m_axi_rvalid       : in  std_logic;
    m_axi_rlast        : in  std_logic;
    m_axi_rready       : out std_logic
    );

end entity ahblite_axi_bridge;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

architecture RTL of ahblite_axi_bridge is
-------------------------------------------------------------------------------
-- PRAGMAS
-------------------------------------------------------------------------------

attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of RTL : architecture is "yes";



-------------------------------------------------------------------------------
 -- Signal declarations
-------------------------------------------------------------------------------
signal axi_wdata_done         : std_logic;
signal axi_bresp_ok           : std_logic;
signal axi_bresp_err          : std_logic;
signal set_axi_raddr          : std_logic;
signal set_axi_waddr          : std_logic;
signal ahb_wnr                : std_logic;
signal set_axi_wdata_burst    : std_logic;
signal set_axi_rdata          : std_logic;

signal core_is_idle           : std_logic;
signal set_hready             : std_logic;
signal reset_hready           : std_logic;
signal set_hresp_err          : std_logic;
signal reset_hresp_err        : std_logic;
signal nonseq_txfer_pending   : std_logic;
signal idle_txfer_pending     : std_logic;
signal burst_term_hwrite      : std_logic;
signal burst_term_single_incr : std_logic;
signal init_pending_txfer     : std_logic;
signal axi_bresp_ready        : std_logic;
signal rvalid_rready          : std_logic;
signal axi_rresp_err          : std_logic_vector( 1 downto 0);
signal txer_rdata_to_ahb      : std_logic;

signal nonseq_detected        : std_logic;
signal seq_detected           : std_logic;
signal busy_detected          : std_logic;
signal ahb_valid_cnt          : std_logic_vector(4 downto 0);
signal ahb_hwrite             : std_logic;
signal ahb_hburst_single      : std_logic;
signal ahb_hburst_incr        : std_logic;
signal ahb_hburst_wrap4       : std_logic;
signal ahb_haddr_hsize        : std_logic_vector( 4 downto 0);
signal ahb_hsize              : std_logic_vector( 1 downto 0);
signal valid_cnt_required     : std_logic_vector( 4 downto 0);
signal burst_term_txer_cnt    : std_logic_vector( 4 downto 0);
signal burst_term_cur_cnt     : std_logic_vector( 4 downto 0);
signal ahb_data_valid         : std_logic;
    
signal last_axi_rd_sample     : std_logic;

signal timeout_o              : std_logic;
signal wr_load_timeout_cntr   : std_logic;
signal rd_load_timeout_cntr   : std_logic;
signal enable_timeout_cnt     : std_logic;

signal burst_term             : std_logic;
signal axi_wr_channel_ready   : std_logic;
signal axi_wr_channel_busy    : std_logic;
signal placed_on_axi          : std_logic;
signal placed_in_local_buf    : std_logic;
signal timeout_detected       : std_logic;

begin

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
 
--------------------------------------------------------------------------------
--m_axi_aclk and m_axi_aresetn are tied to s_ahb_hclk and s_ahb_hresetn
-- respectively
--------------------------------------------------------------------------------
--  m_axi_aclk     <= s_ahb_hclk;
--  m_axi_aresetn  <= s_ahb_hresetn;
    
-------------------------------------------------------------------------------
-- Instantiate the control module
-------------------------------------------------------------------------------
  AHBLITE_AXI_CONTROL : entity ahblite_axi_bridge_v3_0.ahblite_axi_control
  port map
  ( 
  -- AHB Signals
     S_AHB_HCLK             =>    s_ahb_hclk              ,
     S_AHB_HRESETN          =>    s_ahb_hresetn           ,
     S_AHB_HWRITE           =>    s_ahb_hwrite            ,
     S_AHB_HBURST           =>    s_ahb_hburst            ,
  -- AXI Write/Read channels 
     axi_wr_channel_ready   =>    axi_wr_channel_ready    ,
     axi_wr_channel_busy    =>    axi_wr_channel_busy     ,
     axi_wdata_done         =>    axi_wdata_done          ,
     rvalid_rready          =>    rvalid_rready           ,
     last_axi_rd_sample     =>    last_axi_rd_sample      ,
     axi_rresp_err          =>    axi_rresp_err           ,
     axi_bresp_ok           =>    axi_bresp_ok            ,
     axi_bresp_err          =>    axi_bresp_err           ,
     set_axi_raddr          =>    set_axi_raddr           ,
     set_axi_waddr          =>    set_axi_waddr           ,
     ahb_wnr                =>    ahb_wnr                 ,
     set_axi_wdata_burst    =>    set_axi_wdata_burst     ,
     set_axi_rdata          =>    set_axi_rdata           ,
 -- Timeout module    
     enable_timeout_cnt     =>    enable_timeout_cnt      ,
     timeout_i              =>    timeout_o               ,
  -- For AHB interface module  
     core_is_idle           =>    core_is_idle            ,
     set_hready             =>    set_hready              ,
     reset_hready           =>    reset_hready            ,
     set_hresp_err          =>    set_hresp_err           ,
     reset_hresp_err        =>    reset_hresp_err         ,
     nonseq_txfer_pending   =>    nonseq_txfer_pending    ,
     idle_txfer_pending     =>    idle_txfer_pending      ,
     burst_term_hwrite      =>    burst_term_hwrite       ,
     burst_term_single_incr =>    burst_term_single_incr  ,
     init_pending_txfer     =>    init_pending_txfer      ,
     axi_bresp_ready        =>    axi_bresp_ready         ,
     nonseq_detected        =>    nonseq_detected         ,
     seq_detected           =>    seq_detected            ,
     ahb_hburst_single      =>    ahb_hburst_single       ,
     ahb_hburst_incr        =>    ahb_hburst_incr    
  ); -- ahblite_axi_control

--------------------------------------------------------------------------------
-- ahb interface instantiation
--------------------------------------------------------------------------------
  AHB_IF :entity ahblite_axi_bridge_v3_0.ahb_if
  generic map (
    C_M_AXI_ADDR_WIDTH            => C_M_AXI_ADDR_WIDTH     ,         
    C_S_AHB_ADDR_WIDTH            => C_S_AHB_ADDR_WIDTH     ,         
    C_S_AHB_DATA_WIDTH            => C_S_AHB_DATA_WIDTH     , 
    C_M_AXI_DATA_WIDTH            => C_M_AXI_DATA_WIDTH     ,
    C_M_AXI_THREAD_ID_WIDTH       => C_M_AXI_THREAD_ID_WIDTH,   
    C_M_AXI_NON_SECURE            => C_M_AXI_NON_SECURE     
  )
  port map
  (
   -- AHB Signals 
      S_AHB_HCLK             =>      s_ahb_hclk             ,
      S_AHB_HRESETN          =>      s_ahb_hresetn          ,
      S_AHB_HADDR            =>      s_ahb_haddr            ,
      S_AHB_HSEL             =>      s_ahb_hsel             ,
      S_AHB_HTRANS           =>      s_ahb_htrans           ,
      S_AHB_HSIZE            =>      s_ahb_hsize            ,
      S_AHB_HWRITE           =>      s_ahb_hwrite           ,
      S_AHB_HBURST           =>      s_ahb_hburst           ,
      S_AHB_HREADY_IN        =>      s_ahb_hready_in        ,
      S_AHB_HREADY_OUT       =>      s_ahb_hready_out       ,
      S_AHB_HPROT            =>      s_ahb_hprot            ,
      S_AHB_HRESP            =>      s_ahb_hresp            ,
      S_AHB_HRDATA           =>      s_ahb_hrdata           ,
   -- AXI-AW Channel
      M_AXI_AWID             =>      m_axi_awid             ,
      M_AXI_AWLEN            =>      m_axi_awlen            ,
      M_AXI_AWSIZE           =>      m_axi_awsize           ,
      M_AXI_AWBURST          =>      m_axi_awburst          ,
      M_AXI_AWCACHE          =>      m_axi_awcache          ,
      M_AXI_AWADDR           =>      m_axi_awaddr           ,
      M_AXI_AWPROT           =>      m_axi_awprot           ,
      M_AXI_AWLOCK           =>      m_axi_awlock           ,
   -- AXI-AR Channel
      M_AXI_ARID             =>      m_axi_arid             ,
      M_AXI_ARLEN            =>      m_axi_arlen            ,
      M_AXI_ARSIZE           =>      m_axi_arsize           ,
      M_AXI_ARBURST          =>      m_axi_arburst          ,
      M_AXI_ARPROT           =>      m_axi_arprot           ,
      M_AXI_ARCACHE          =>      m_axi_arcache          ,
      M_AXI_ARADDR           =>      m_axi_araddr           ,
      M_AXI_ARLOCK           =>      m_axi_arlock           ,
   -- AHB interface module  
      core_is_idle           =>      core_is_idle           ,
      ahb_valid_cnt          =>      ahb_valid_cnt          ,
      ahb_hwrite             =>      ahb_hwrite             ,
      nonseq_detected        =>      nonseq_detected        ,
      seq_detected           =>      seq_detected           ,
      busy_detected          =>      busy_detected          ,
      set_hready             =>      set_hready             ,
      reset_hready           =>      reset_hready           ,
      set_hresp_err          =>      set_hresp_err          ,
      reset_hresp_err        =>      reset_hresp_err        ,
      nonseq_txfer_pending   =>      nonseq_txfer_pending   ,
      idle_txfer_pending     =>      idle_txfer_pending     ,
      burst_term_hwrite      =>      burst_term_hwrite      ,
      burst_term_single_incr =>      burst_term_single_incr ,
      init_pending_txfer     =>      init_pending_txfer     ,
   -- AXI Write/Read channels 
      axi_wdata_done         =>      axi_wdata_done         ,
      timeout_detected       =>      timeout_detected       ,
      last_axi_rd_sample     =>      last_axi_rd_sample     ,
      burst_term             =>      burst_term             , 
      ahb_hburst_single      =>      ahb_hburst_single      ,
      ahb_hburst_incr        =>      ahb_hburst_incr        , 
      ahb_hburst_wrap4       =>      ahb_hburst_wrap4       , 
      ahb_haddr_hsize        =>      ahb_haddr_hsize        ,
      ahb_hsize              =>      ahb_hsize              ,
      valid_cnt_required     =>      valid_cnt_required     ,
      burst_term_txer_cnt    =>      burst_term_txer_cnt    ,
      burst_term_cur_cnt     =>      burst_term_cur_cnt     ,
      ahb_data_valid         =>      ahb_data_valid         ,
      placed_on_axi          =>      placed_on_axi          ,
      placed_in_local_buf    =>      placed_in_local_buf    ,
      txer_rdata_to_ahb      =>      txer_rdata_to_ahb      ,
      M_AXI_RDATA            =>      m_axi_rdata          
  ); -- ahb_if

--------------------------------------------------------------------------------
--AHB data counter to count the number of valid(NONSEQ or SEQ) samples
-- received during a burst.
--------------------------------------------------------------------------------
  AHB_DATA_COUNTER : entity ahblite_axi_bridge_v3_0.ahb_data_counter
  port map
  (
  -- AHB Signals
     S_AHB_HCLK         =>      s_ahb_hclk         ,
     S_AHB_HRESETN      =>      s_ahb_hresetn      ,
  -- ahb_if module
     ahb_hwrite         =>      ahb_hwrite         ,
     ahb_hburst_incr    =>      ahb_hburst_incr    ,
     nonseq_detected    =>      nonseq_detected    ,
     seq_detected       =>      seq_detected       ,
     ahb_valid_cnt      =>      ahb_valid_cnt       
  ); -- ahb_data_counter

--------------------------------------------------------------------------------
--axi_wchannel instantiation
--------------------------------------------------------------------------------
  AXI_WCHANNEL : entity ahblite_axi_bridge_v3_0.axi_wchannel
  generic map (
    C_S_AHB_ADDR_WIDTH            => C_S_AHB_ADDR_WIDTH           ,         
    C_M_AXI_ADDR_WIDTH            => C_M_AXI_ADDR_WIDTH           ,         
    C_S_AHB_DATA_WIDTH            => C_S_AHB_DATA_WIDTH           ,
    C_M_AXI_DATA_WIDTH            => C_M_AXI_DATA_WIDTH           ,
    C_M_AXI_THREAD_ID_WIDTH       => C_M_AXI_THREAD_ID_WIDTH      ,
    C_M_AXI_SUPPORTS_NARROW_BURST => C_M_AXI_SUPPORTS_NARROW_BURST
              )
  port map
  (
  -- AHB Signals
     S_AHB_HCLK          =>      s_ahb_hclk          ,
     S_AHB_HRESETN       =>      s_ahb_hresetn       ,
     S_AHB_HWDATA        =>      s_ahb_hwdata        ,
  -- AXI Write Address Channel Signals
     M_AXI_AWVALID       =>     m_axi_awvalid        ,
     M_AXI_AWREADY       =>     m_axi_awready        ,
  -- AXI Write Data Channel Signals
     M_AXI_WDATA         =>     m_axi_wdata          ,
     M_AXI_WSTRB         =>     m_axi_wstrb          ,
     M_AXI_WLAST         =>     m_axi_wlast          ,
     M_AXI_WVALID        =>     m_axi_wvalid         ,
     M_AXI_WREADY        =>     m_axi_wready         ,
  -- AXI Write Response Channel signals
     M_AXI_BVALID        =>     m_axi_bvalid         ,
     M_AXI_BRESP         =>     m_axi_bresp          ,
     M_AXI_BREADY        =>     m_axi_bready         ,
  -- Control signals to/from  state machine 
     axi_wdata_done      =>     axi_wdata_done       ,
     axi_bresp_ok        =>     axi_bresp_ok         ,
     axi_bresp_err       =>     axi_bresp_err        ,
     set_axi_waddr       =>     set_axi_waddr        ,
     ahb_wnr             =>     ahb_wnr              ,
     set_axi_wdata_burst =>     set_axi_wdata_burst  ,
  -- ahb_if module
     ahb_hburst_single   =>     ahb_hburst_single    ,
     ahb_hburst_incr     =>     ahb_hburst_incr      ,
     ahb_hburst_wrap4    =>     ahb_hburst_wrap4     , 
     ahb_haddr_hsize     =>     ahb_haddr_hsize      ,
     ahb_hsize           =>     ahb_hsize            ,
     valid_cnt_required  =>     valid_cnt_required   ,
     burst_term_txer_cnt =>     burst_term_txer_cnt  ,
     ahb_data_valid      =>     ahb_data_valid       ,
     burst_term_cur_cnt  =>     burst_term_cur_cnt   ,
     burst_term          =>     burst_term           ,
     nonseq_txfer_pending=>     nonseq_txfer_pending ,
     init_pending_txfer  =>     init_pending_txfer   ,
     axi_wr_channel_ready=>     axi_wr_channel_ready ,
     axi_wr_channel_busy =>     axi_wr_channel_busy  ,
     placed_on_axi       =>     placed_on_axi        ,
     placed_in_local_buf =>     placed_in_local_buf  ,
     timeout_detected    =>     timeout_detected     ,
     timeout_i           =>     timeout_o            , 
     wr_load_timeout_cntr=>     wr_load_timeout_cntr              
  ); -- axi_wchannel

--------------------------------------------------------------------------------
--axi_rchannel instantiation
--------------------------------------------------------------------------------
  AXI_RCHANNEL : entity ahblite_axi_bridge_v3_0.axi_rchannel
  generic map (
    C_S_AHB_ADDR_WIDTH            => C_S_AHB_ADDR_WIDTH           ,         
    C_M_AXI_ADDR_WIDTH            => C_M_AXI_ADDR_WIDTH           ,         
    C_M_AXI_DATA_WIDTH            => C_M_AXI_DATA_WIDTH           ,
    C_M_AXI_THREAD_ID_WIDTH       => C_M_AXI_THREAD_ID_WIDTH        
  )
  port map (
  -- AHB Signals 
    S_AHB_HCLK            =>      s_ahb_hclk          ,
    S_AHB_HRESETN         =>      s_ahb_hresetn       ,
  -- AHB interface signals
    seq_detected          =>      seq_detected        , 
    busy_detected         =>      busy_detected       ,
    rvalid_rready         =>      rvalid_rready       ,
    axi_rresp_err         =>      axi_rresp_err       ,
    txer_rdata_to_ahb     =>      txer_rdata_to_ahb   ,
  -- AXI Read Address Channel Signals 
    M_AXI_ARVALID         =>     m_axi_arvalid        ,
    M_AXI_ARREADY         =>     m_axi_arready        ,
  -- AXI Read Data Channel Signals 
    M_AXI_RVALID          =>     m_axi_rvalid         ,
    M_AXI_RLAST           =>     m_axi_rlast          ,
    M_AXI_RRESP           =>     m_axi_rresp          ,
    M_AXI_RREADY          =>     m_axi_rready         ,
  -- Timeout module
     rd_load_timeout_cntr =>     rd_load_timeout_cntr , 
  -- AHB interface module
    set_hresp_err         =>     set_hresp_err        ,
    last_axi_rd_sample    =>     last_axi_rd_sample   ,
  -- Control signals to/from state machine block 
    set_axi_raddr         =>     set_axi_raddr       
  ); -- axi_rchannel

--------------------------------------------------------------------------------
--time_out module instantiation
--------------------------------------------------------------------------------
  TIME_OUT : entity ahblite_axi_bridge_v3_0.time_out
  generic map (
    C_FAMILY              => C_FAMILY       ,
    C_AHB_AXI_TIMEOUT     => C_AHB_AXI_TIMEOUT
    )
  port map
  ( 
    S_AHB_HCLK           => s_ahb_hclk           ,
    S_AHB_HRESETN        => s_ahb_hresetn        ,
    enable_timeout_cnt   => enable_timeout_cnt   ,
    M_AXI_BVALID         => m_axi_bvalid         ,
    wr_load_timeout_cntr => wr_load_timeout_cntr ,
    last_axi_rd_sample   => last_axi_rd_sample   ,
    rd_load_timeout_cntr => rd_load_timeout_cntr ,
    core_is_idle         => core_is_idle         ,
    timeout_o            => timeout_o       
  ); -- time_out
end architecture RTL;
