//  ------------------------------------------------------------------------
//
//                    (C) COPYRIGHT 2005 - 2013 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
//  This software and the associated documentation are confidential and
//  proprietary to Synopsys, Inc.  Your use or disclosure of this
//  software is subject to the terms and conditions of a written
//  license agreement between you, or your company, and Synopsys, Inc.
//
// The entire notice above must be reproduced on all authorized copies.
//
//  ------------------------------------------------------------------------

//--                                                                        
// Release version :  2.70a
// Date             :        $Date: 2013/02/21 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage.v#49 $
//--                                                                        
//------------------------------------------------------------------------
// Filename  : DWC_mobile_storage.v
// Description: DWC_mobile_storage, top level module which istantiates the main blocks:
//              Bus Interface Unit (BIU) and the Card Interface Unit (CIU).
//              In addition this block also instantiates the Card domain to 
//              BIU and BIU to Card doamin synchronizer and AHB2APB gasket. 
//
//              The FIFO's dual ported (synchronous-read & synchronous-write)
//              ram is also instantiated in this block. This ram will normally
//              get synthesized into flops. If a larger ram is used (>2kb), it
//              is recommeded that the user replace this ram with Fab specific
//              dual port ram. 
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage(

  // CLOCKS and RESET
  clk,
                          reset_n,
                          cclk_in,
                          cclk_in_sample,
                          cclk_in_drv,
                          // AHB Slave 
                          haddr,
                          hsel,
                          hwrite,
                          htrans,
                          hsize, 
                          hburst, 
                          hready,
                          hwdata, 
                          hbig_endian, 
                          hrdata, 
                          hready_resp, 
                          hresp, 
                          // AHB Master
                          m_hreq, 
                          m_hgrant,
                          m_haddr,
                          m_htrans,
                          m_hwrite,
                          m_hsize,
                          m_hburst, 
                          m_hwdata,
                          m_hready, 
                          m_hresp,
                          m_hrdata, 
                          m_hbig_endian,
                          // INTERRUPT SIGNALS
                          interrupt, 
                          raw_ints,
                          int_mask_n, 
                          int_enable, 
                          // GENERAL PURPOSE INPUT/OUTPUT
                          gp_out, 
                          gp_in,
                          // DEBUG & SCAN
                          debug_status, 
                          scan_mode, 
                          // CARD-INTERFACE
                          cclk_out, 
                          ccmd_out,
                          ccmd_in, 
                          ccmd_out_en, 
                          ccmd_od_pullup_en_n, 
                          card_detect_n,
                          card_power_en,
                          card_volt_a,
                          card_volt_b,
                          card_write_prt, 
                          cdata_out, 
                          cdata_in, 
                          cdata_out_en,
                          //SD_3.0 start
                          //Voltage buffer inputs
                          biu_volt_reg,        
                          //SD_3.0 ends
                          //eMMC 4.5 start
                          //Voltage buffer inputs
                          biu_volt_reg_1_2,        
                          ext_clk_mux_ctrl,
                          clk_drv_phase_ctrl,
                          clk_smpl_phase_ctrl,
                          //eMMC 4.5 ends
                          //MMC4_4 start
                          rst_n,
                          //MMC4_4 ends
                          //SDIO3.0 start
                          card_int_n,
                          back_end_power//SDIO3.0 ends
                          
                          );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  // CLOCKS and RESET 
  input                        clk;             // System Clock
  input                        reset_n;         // System Reset - Active Low
  input                        cclk_in;         // Card Clock In
  input                        cclk_in_sample;  // Card Inputs Sample Clock
  input                        cclk_in_drv;     // Card outputs Driving Clock
                                                // Hold time fixing

  // APB WITH SIDEBAND FEATURES


  // AHB slave
  input    [`H_ADDR_WIDTH-1:0] haddr;           // AHB Address Bus
  input                        hsel;            // AHB Device Select
  input                        hwrite;          // AHB Transfer Direction
  input                  [1:0] htrans;          // AHB Transfer Type
  input                  [2:0] hsize;           // AHB Transfer Size
  input                  [2:0] hburst;          // AHB Burst Type
  input                        hready;          // AHB Transfer Done - In
  input    [`H_DATA_WIDTH-1:0] hwdata;          // AHB Write Data
  input                        hbig_endian;     // AHB Big Endian Mode
  output   [`H_DATA_WIDTH-1:0] hrdata;          // AHB Read Data
  output                       hready_resp;     // AHB Transfer Done - Out
  output                 [1:0] hresp;           // AHB Transfer Response

  input                        m_hgrant;        // Grant from Arbiter
  input                        m_hready;        // Ready from slave
  input                  [1:0] m_hresp;         // Response from slave
  input    [`H_DATA_WIDTH-1:0] m_hrdata;        // Read data from slave
  input                        m_hbig_endian;   // Big Endian format
  output                       m_hreq;          // Request
  output   [`M_ADDR_WIDTH-1:0] m_haddr;         // Address
  output                 [1:0] m_htrans;        // Transfer Attribute
  output                       m_hwrite;        // Read/write indication
  output                 [2:0] m_hsize;         // Size of transfer
  output                 [2:0] m_hburst;        // Burst type indication
  output   [`H_DATA_WIDTH-1:0] m_hwdata;        // Write data

  // EXTERNAL FIFO-RAM 

  // DW-DMA 

  // GENERIC-DMA

  // INTERRUPT SIGNALS 
  output                       interrupt;       // Combined System Interrupt
  output                [31:0] raw_ints;        // Raw Interrupts - for debug
  output                [31:0] int_mask_n;      // Int. Mask Register-for debug
  output                       int_enable;      // Global Int. enable-for debug

  // GENERAL PURPOSE INPUT/OUTPUT
  input                  [7:0] gp_in;           // General Purpose Input
  output                [15:0] gp_out;          // General Purpose Output

  // DEBUG & SCAN 
  input                        scan_mode;       // Scan mode 


  `ifdef INTERNAL_DMAC_YES

     `ifdef M_ADDR_WIDTH_32
        output              [1154:0] debug_status;    // Debug and Status Ports
     `else  //64 bit address bus
        output              [1250:0] debug_status;    // Debug and Status Ports
     `endif

  `endif



  `ifdef INTERNAL_DMAC_NO

  output               [962:0] debug_status;    // Debug and Status Ports

  `endif

 
  // CARD INTERFACE 
  output   [`NUM_CARD_BUS-1:0] cclk_out;        // Card Clock Out 
  input    [`NUM_CARD_BUS-1:0] ccmd_in;         // Card Cmd Input
  output   [`NUM_CARD_BUS-1:0] ccmd_out;        // Card Cmd Output
  output   [`NUM_CARD_BUS-1:0] ccmd_out_en;     // Card Cmd Output Enable
  output                   ccmd_od_pullup_en_n; // Card Cmd Open-Drain Pullup 
  input       [`NUM_CARDS-1:0] card_detect_n;   // Card Detect - Active Low
  output      [`NUM_CARDS-1:0] card_power_en;   // Individual Card Power Enable
  output                 [3:0] card_volt_a;     // Card Regulator Voltage-A Ctl 
  output                 [3:0] card_volt_b;     // Card Regulator Voltage-B Ctl
  input  [`NUM_CARD_BUS*8-1:0] cdata_in;        // Card Data Input
  output [`NUM_CARD_BUS*8-1:0] cdata_out;       // Card Data Output
  output [`NUM_CARD_BUS*8-1:0] cdata_out_en;    // Card Data Output Enable
  input       [`NUM_CARDS-1:0] card_write_prt;  // Card Write Protect
                                                // Enable
  //SD_3.0 start
 // Output buffer inputs
 output [`NUM_CARD_BUS-1:0]biu_volt_reg;       // Voltage select signal.Input for the buffer. 
  //SD_3.0 ends

  //eMMC 4.5 start
 // Output buffer inputs
 output [`NUM_CARD_BUS-1:0]biu_volt_reg_1_2;       // Voltage select signal.Input for the buffer. 
        output [1:0]  ext_clk_mux_ctrl;
        output [6:0] clk_drv_phase_ctrl;
        output [6:0] clk_smpl_phase_ctrl;
  //eMMC 4.5 ends

 //MMC4_4 start
  output [`NUM_CARD_BUS-1:0]rst_n;              //H/W reset for MMC4.4 cards
 //MMC4_4 ends
 //SDIO 3.0 start
  input  [`NUM_CARD_BUS-1:0]card_int_n;         // Interrupt pin for eSDIO devices; INT#
 output [`NUM_CARD_BUS-1:0] back_end_power;    // Back end power for applications on the card.1 per card. 
 //SDIO 3.0 ends
  // --------------------------------------
  // Wire Declaration
  // --------------------------------------
  wire                         psel;            // APB Peripheral Select Signal
  wire                         penable;         // APB Strobe Signal
  wire                         pwrite;          // APB Write Signal
  wire     [`H_ADDR_WIDTH-1:0] paddr;           // APB Address bus
  wire   [`H_DATA_WIDTH/8-1:0] pbe;             // APB Byte Enable - sideband
  wire     [`H_DATA_WIDTH-1:0] pwdata;          // APB Write data Bus
  wire     [`H_DATA_WIDTH-1:0] prdata;          // APB Read Data Bus
 `ifdef AREA_OPTIMIZATION 
  wire                   [7:0] gp_in;           // General Purpose Input
  assign gp_in = 0;
 `endif

  wire                  [15:0] gp_out;          // General Purpose Output

  `ifdef INTERNAL_DMAC_YES

     `ifdef M_ADDR_WIDTH_32
        wire              [1154:0] debug_status;    // Debug and Status Ports
        wire               [191:0] dmac_debug_reg;  // DMAC Debug ports
     `else  //64 bit address bus
        wire              [1250:0] debug_status;    // Debug and Status Ports
        wire               [287:0] dmac_debug_reg;  // DMAC Debug ports
     `endif
  //wire                [1154:0] debug_status;    // Debug and Status Ports
  //wire                 [191:0] dmac_debug_reg;  // DMAC Debug ports

  `endif



  `ifdef INTERNAL_DMAC_NO

  wire                 [962:0] debug_status;    // Debug and Status Ports

  `endif


  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire                  abort_read_data;        // From DWC_mobile_storage_b2c.v
  wire                  ceata_intr_status;      // From DWC_mobile_storage_b2c.v
  wire                  send_ccsd;              // From DWC_mobile_storage_b2c.v
  wire                  send_auto_stop_ccsd;    // From DWC_mobile_storage_b2c.v
  wire                  auto_cmd_done;          // From DWC_mobile_storage_c2b.v
  wire                  b2c_abort_read_data;    // From DWC_mobile_storage_biu.v
  wire                  b2c_ceata_intr_status;  // From DWC_mobile_storage_biu.v
  wire                  b2c_send_ccsd;          // From DWC_mobile_storage_biu.v  
  wire                  b2c_send_auto_stop_ccsd;// From DWC_mobile_storage_biu.v  
  wire [15:0]           b2c_block_size;         // From DWC_mobile_storage_biu.v
  wire [31:0]           b2c_byte_count;         // From DWC_mobile_storage_biu.v
  wire [`NUM_CARD_BUS-1:0]b2c_card_type;        // From DWC_mobile_storage_biu.v
  wire [`NUM_CARD_BUS*2-1:0]b2c_card_width;     // From DWC_mobile_storage_biu.v
  wire [`NUM_CARD_BUS-1:0]b2c_cclk_enable;      // From DWC_mobile_storage_biu.v
  wire [`NUM_CARD_BUS-1:0]b2c_cclk_low_power;   // From DWC_mobile_storage_biu.v
  wire                  b2c_clear_pointers;     // From DWC_mobile_storage_biu.v
 //SD_3.0 start
 wire [`NUM_CARD_BUS-1:0]b2c_ddr_reg;          // From DWC_mobile_storage_biu.v
 //SD_3.0 ends
  wire                  b2c_half_start_bit;     // From DWC_mobile_storage_biu.v
  wire [((`NUM_CARD_BUS*2)-1):0] b2c_enable_shift ;     // From DWC_mobile_storage_biu.v
  wire                  half_start_bit;         // From DWC_mobile_storage_b2c.v
  wire [((`NUM_CARD_BUS*2)-1):0] enable_shift ;     // From DWC_mobile_storage_biu.v
  wire                  clr_clk1_pointers;      // From DWC_mobile_storage_biu.v
  wire [31:0]           b2c_clk_divider;        // From DWC_mobile_storage_biu.v
  wire [31:0]           b2c_clk_source;         // From DWC_mobile_storage_biu.v
  wire [31:0]           b2c_cmd_argument;       // From DWC_mobile_storage_biu.v
 //SD_3.0 start
  wire [29:0]           b2c_cmd_control;        // From DWC_mobile_storage_biu.v
 //SD_3.0 ends
  wire                  enable_boot;            // From DWC_mobile_storage_biu.v
  wire                  alternative_boot_mode;  // From DWC_mobile_storage_biu.v
  wire                  boot_ack_timeout;       // From DWC_mobile_storage_biu.v
  wire                  boot_data_timeout;      // From DWC_mobile_storage_biu.v
  wire                  end_boot;               // From DWC_mobile_storage_c2b.v
  wire                  boot_ack_tout;          // From DWC_mobile_storage_c2b.v
  wire                  boot_data_tout;         // From DWC_mobile_storage_c2b.v
  wire                  c2b_end_boot;           // From DWC_mobile_storage_ciu.v
  wire                  c2b_boot_ack_tout;      // From DWC_mobile_storage_ciu.v
 //SD_3.0 start
  wire                  c2b_volt_switch_int;    // From DWC_mobile_storage_ciu.v
 //SD_3.0 ends
 //MMC4_4 start
  wire  [`NUM_CARD_BUS-1:0] rst_n_biu;          // From DWC_mobile_storage_biu.v
 //MMC4_4 ends
  wire                  c2b_boot_data_tout;     // From DWC_mobile_storage_ciu.v
  wire                  b2c_cmd_start;          // From DWC_mobile_storage_biu.v
  wire                  b2c_creset_n;           // From DWC_mobile_storage_biu.v
  wire [23:0]           b2c_data_tmout_cnt;     // From DWC_mobile_storage_biu.v
  wire                  b2c_od_pullup_en_n;     // From DWC_mobile_storage_biu.v
  wire                  b2c_read_wait;          // From DWC_mobile_storage_biu.v
  wire [7:0]            b2c_resp_tmout_cnt;     // From DWC_mobile_storage_biu.v
  wire                  b2c_send_irq_resp;      // From DWC_mobile_storage_biu.v
  wire                  biu_fifo_pop;           // From DWC_mobile_storage_biu.v
  wire                  biu_fifo_push;          // From DWC_mobile_storage_biu.v
  wire [`F_DATA_WIDTH-1:0] biu_fifo_wdata;       // From DWC_mobile_storage_biu.v
  wire [`F_COUNT_WIDTH-1:0] biu_greater_than_thresh;// From DWC_mobile_storage_biu.v
  wire [`F_COUNT_WIDTH-1:0] biu_less_equal_thresh;// From DWC_mobile_storage_biu.v
  wire                  c2b_auto_cmd_done;      // From DWC_mobile_storage_ciu.v
  wire                  c2b_ciu_fifo_pop;       // From DWC_mobile_storage_ciu.v
  wire                  c2b_ciu_fifo_push;      // From DWC_mobile_storage_ciu.v
  wire [3:0]            c2b_ciu_status;         // From DWC_mobile_storage_ciu.v
  wire                  c2b_cmd_fsm_state_0;    // From DWC_mobile_storage_ciu.v
  wire                  c2b_cmd_fsm_state_1;    // From DWC_mobile_storage_ciu.v
  wire                  c2b_cmd_fsm_state_2;    // From DWC_mobile_storage_ciu.v
  wire                  c2b_cmd_fsm_state_3;    // From DWC_mobile_storage_ciu.v
  wire                  c2b_cmd_taken;          // From DWC_mobile_storage_ciu.v
  wire                  c2b_data_crc_err;       // From DWC_mobile_storage_ciu.v
  wire                  c2b_data_strv_err;      // From DWC_mobile_storage_ciu.v
  wire                  c2b_data_timeout;       // From DWC_mobile_storage_ciu.v
  wire                  c2b_data_trans_done;    // From DWC_mobile_storage_ciu.v
  wire [`F_DATA_WIDTH-1:0] c2b_fifo_wdata;      // From DWC_mobile_storage_ciu.v
  wire                  c2b_resp_crc_err;       // From DWC_mobile_storage_ciu.v
  wire                  c2b_resp_timeout;       // From DWC_mobile_storage_ciu.v
  wire [1:0]            c2b_response_addr;      // From DWC_mobile_storage_ciu.v
  wire [37:0]           c2b_response_data;      // From DWC_mobile_storage_ciu.v
  wire                  c2b_response_done;      // From DWC_mobile_storage_ciu.v
  wire                  c2b_response_err;       // From DWC_mobile_storage_ciu.v
  wire                  c2b_response_valid;     // From DWC_mobile_storage_ciu.v
  wire                  c2b_rx_stbit_err;       // From DWC_mobile_storage_ciu.v
  wire                  c2b_rxend_nocrc_err;    // From DWC_mobile_storage_ciu.v
  wire [`NUM_CARD_BUS-1:0]c2b_sdio_interrupt;   // From DWC_mobile_storage_ciu.v
  wire [31:0]           c2b_trans_bytes;        // From DWC_mobile_storage_ciu.v
  wire [31:0]           c2b_trans_bytes_bin;    // From DWC_mobile_storage_ciu.v
  wire                  c2b_clr_send_ccsd;      // From DWC_mobile_storage_ciu.v
  wire [`NUM_CARDS-1:0] card_detect_biu;        // From DWC_mobile_storage_c2b.v
  wire [`NUM_CARDS-1:0] card_write_prt_biu;     // From DWC_mobile_storage_c2b.v
  wire [7:0]            ciu_status;             // From DWC_mobile_storage_c2b.v
  wire [31:0]           ciu_trans_bytes;        // From DWC_mobile_storage_c2b.v
  wire                  clear_irq_response;     // From DWC_mobile_storage_c2b.v
  wire                  clear_ciu_reset;        // From DWC_mobile_storage_c2b.v
  wire                  clr_clear_pointers;     // From DWC_mobile_storage_c2b.v
  wire                  clr_send_ccsd;          // From DWC_mobile_storage_c2b.v
  wire                  clear_pointers;         // From DWC_mobile_storage_b2c.v
  wire                  clr_abrt_read_data;     // From DWC_mobile_storage_c2b.v
  wire                  cmd_start;              // From DWC_mobile_storage_b2c.v
  wire                  creset_n;               // From DWC_mobile_storage_b2c.v
  wire                  clear_cntrl0;           // From DWC_mobile_storage_b2c.v
  wire                  data_crc_err;           // From DWC_mobile_storage_c2b.v
  wire                  data_strv_err;          // From DWC_mobile_storage_c2b.v
  wire                  data_timeout;           // From DWC_mobile_storage_c2b.v
 //SD_3.0 start
  wire [959:0]          debug_registers;        // From DWC_mobile_storage_biu.v
 //SD_3.0 ends
  wire [7:0]            gp_in_biu;              // From DWC_mobile_storage_c2b.v
  wire                  read_wait;              // From DWC_mobile_storage_b2c.v
  wire                  resp_crc_err;           // From DWC_mobile_storage_c2b.v
  wire                  resp_timeout;           // From DWC_mobile_storage_c2b.v
  wire                  response_done;          // From DWC_mobile_storage_c2b.v
  wire                  response_err;           // From DWC_mobile_storage_c2b.v
  wire                  response_valid;         // From DWC_mobile_storage_c2b.v
  wire                  rx_stbit_err;           // From DWC_mobile_storage_c2b.v
  wire                  rxend_nocrc_err;        // From DWC_mobile_storage_c2b.v
  wire [`NUM_CARD_BUS-1:0]sdio_interrupt;       // From DWC_mobile_storage_c2b.v
 //SD_3.0 start
  wire                  volt_switch_int;        // From DWC_mobile_storage_c2b.v
 //SD_3.0 ends
  wire                  send_irq_response;      // From DWC_mobile_storage_b2c.v
  wire                  sync_od_pullup_en_n;    // From DWC_mobile_storage_b2c.v
  wire                  creset_n_sample;        // From DWC_mobile_storage_b2c.v
  wire                  creset_n_drv;           // From DWC_mobile_storage_b2c.v
  // End of automatics

  wire                  biu_less_or_equal;     // From U_DWC_mobile_storage_b2c
  wire                  biu_greater_than;      // From U_DWC_mobile_storage_b2c
  wire                  ciu_fifo_full;         // From U_DWC_mobile_storage_b2c
  wire                  ciu_fifo_empty;        // From U_DWC_mobile_storage_b2c
  wire                  ciu_fifo_almost_full;  // From U_DWC_mobile_storage_b2c
  wire                  ciu_fifo_almost_empty; // From U_DWC_mobile_storage_b2c
  wire                  biu_almost_empty;      // From U_DWC_mobile_storage_b2c
  wire                  biu_almost_full;       // From U_DWC_mobile_storage_b2c
  wire                  biu_empty;             // From U_DWC_mobile_storage_b2c
  wire                  biu_full;              // From U_DWC_mobile_storage_b2c
  wire [`F_DATA_WIDTH-1:0] ciu_fifo_rdata;     // From DWC_mobile_storage_biu.v
  wire [`F_DATA_WIDTH-1:0] biu_fifo_rdata;     // From DWC_mobile_storage_ciu.v
  wire [`F_COUNT_WIDTH-1:0] biu_count;         // From DWC_mobile_storage_ciu.v
 wire                   atleast_empty;        // From DWC_mobile_storage_2clk_fifoctl.v

  // Wires
  wire                       ram_rd1_n;          // DSSRAM active low read-1   
  wire                       ram_cs1_n;          // DSSRAM active low chipsel-1
  wire                       ram_wr1_n;          // DSSRAM active low write-1 
  wire   [`R_ADDR_WIDTH-1:0] ram_addr1;          // DSSRAM address-1
  wire   [`F_DATA_WIDTH-1:0] ram_wr_data1;       // DSSRAM write output data-1 
  wire   [`F_DATA_WIDTH-1:0] ram_rd_data1;       // DSSRAM read input data-1 
  wire                       ram_rd2_n;          // DSSRAM active low read-1   
  wire                       ram_cs2_n;          // DSSRAM active low chipsel-1
  wire                       ram_wr2_n;          // DSSRAM active low write-1 
  wire   [`R_ADDR_WIDTH-1:0] ram_addr2;          // DSSRAM address-1
  wire   [`F_DATA_WIDTH-1:0] ram_wr_data2;       // DSSRAM write output data-1 
  wire   [`F_DATA_WIDTH-1:0] ram_rd_data2;       // DSSRAM read input data-1 

  wire                           ge_dma_ack;     // DMA Tx burst end
  wire  [`GE_DMA_DATA_WIDTH-1:0] ge_dma_rdata;   // DMA Input Data
  wire  [`GE_DMA_DATA_WIDTH-1:0] ge_dma_wdata;   // DMA Output Data
  wire                           ge_dma_req;     // Transmit FIFO DMA Request
  wire                           ge_dma_done;    // DMA Trans. FIFO Last Tranfer
  wire                           ge_dma_write;   // 1-DMA Due to Transmit; 0-rcv
  wire                     [4:0] ge_dma_card_num;// Current Card In Use, 
  `ifdef NO_GENERIC_DMA 
  assign ge_dma_ack   = 1'b0;
  assign ge_dma_rdata = 0;
  `endif

  wire                       dw_dma_ack;      // DMA Tx burst end
  wire                       dw_dma_req;      // Transmit FIFO DMA Request
  wire                       dw_dma_single;   // DMA TRansmit FIFO Single 
  wire                       dw_dma_write;    // 1-DMA Due to Transmit; 0-rcv
  wire                 [4:0] dw_dma_card_num; // Current Card In Use 


  `ifdef INTERNAL_DMAC_YES

  wire                       m_hreq;
  wire  [`M_ADDR_WIDTH-1:0]  m_haddr;
  wire                [1:0]  m_htrans;
  wire                       m_hwrite;
  wire                [2:0]  m_hsize;
  wire                [2:0]  m_hburst;
  wire  [`H_DATA_WIDTH-1:0]  m_hwdata;
  wire  [`H_DATA_WIDTH-1:0]  dmac_csr_rdata;
  wire                       dmac_csr_sel;
  wire                       use_internal_dmac;  
  wire                [2:0]  pbl;
  wire  [`H_DATA_WIDTH-1:0]  biu_csr_rdata; // FIFO read data
  wire                       push1;
  wire                       pop1;
  wire  [`F_DATA_WIDTH-1:0]  fifo_din1;
  wire                       dmac_fifo_pop;
  wire                       dmac_fifo_push;
  wire  [`F_DATA_WIDTH-1:0]  dmac_fifo_wdata;
  wire                       fifo_ptr_rst;
  wire                       biu_interrupt;
  wire                       dmac_biu_intr;
 
   
  assign interrupt = dmac_biu_intr; 


  `endif



  `ifdef NO_NON_DW_DMA
  `ifdef NO_DW_DMA
  assign dw_dma_ack   = 1'b0;
  `endif
  `endif

  wire                       cclk_in_drv ;    // Card outputs drive clock

  `ifdef MMC_ONLY 
  wire      [`NUM_CARDS-1:0] card_write_prt;  // Card Write Protect
  assign card_write_prt = {`NUM_CARDS{1'b0}};
  `endif

  wire ciu_data_trans_done, cmd_taken;

  

  // Debug Port

 `ifdef INTERNAL_DMAC_YES

  assign debug_status = {dmac_debug_reg,ciu_data_trans_done, cmd_taken, 
                         b2c_cmd_start, debug_registers};

  `endif



  `ifdef INTERNAL_DMAC_NO

  assign debug_status = {ciu_data_trans_done, cmd_taken, 
                         b2c_cmd_start, debug_registers};

   `endif


  assign ccmd_od_pullup_en_n = b2c_od_pullup_en_n;

 wire card_rd_threshold_en;                         // From DWC_mobile_storage_biu.v
 wire busy_clr_int_mask ; 
 wire [`F_BYTE_WIDTH-1:0] card_rd_threshold_size;     // From DWC_mobile_storage_biu.v
  wire biu_card_rd_thres_en;
  wire [3:0]   cp_card_num;
  
 assign biu_card_rd_thres_en = card_rd_threshold_en;


  // AHB Bus Interface Unit


  `ifdef BUS_TYPE_AHB

  DWC_mobile_storage_ahb2apb
   U_DWC_mobile_storage_ahb2apb 
    (/*AUTOINST*/
     // Outputs
     .hready_resp                       (hready_resp),
     .hresp                             (hresp[1:0]),
     .hrdata                            (hrdata[`H_DATA_WIDTH-1:0]),
     .psel                              (psel),
     .penable                           (penable),
     .pwrite                            (pwrite),
     .paddr                             (paddr[`H_ADDR_WIDTH-1:0]),
     .pbe                               (pbe[`H_DATA_WIDTH/8-1:0]),
     .pwdata                            (pwdata[`H_DATA_WIDTH-1:0]),
     // Inputs
     .clk                               (clk),
     .reset_n                           (reset_n),
     .haddr                             (haddr[`H_ADDR_WIDTH-1:0]),
     .hsel                              (hsel),
     .hwrite                            (hwrite),
     .htrans                            (htrans[1:0]),
     .hsize                             (hsize[2:0]),
     .hburst                            (hburst[2:0]),
     .hready                            (hready),
     .hwdata                            (hwdata[`H_DATA_WIDTH-1:0]),
     .hbig_endian                       (hbig_endian),
     .prdata                            (prdata[`H_DATA_WIDTH-1:0]));


  `endif


  // DMAC/BIU arbiration

  `ifdef INTERNAL_DMAC_YES


  DWC_mobile_storage_dmac_if
   U_DWC_mobile_storage_dmac_if 
    (
     // Outputs
     .prdata_muxed_o                   (prdata),
     .push1_o                          (push1),
     .pop1_o                           (pop1),
     .fifo_din1_o                      (fifo_din1),
     // Inputs 
     .use_internal_dmac_i              (use_internal_dmac),
     .biu_fifo_pop_i                   (biu_fifo_pop),
     .biu_fifo_push_i                  (biu_fifo_push),
     .biu_fifo_wdata_i                 (biu_fifo_wdata),
     .prdata_i                         (biu_csr_rdata),
     .dmac_csr_sel_i                   (dmac_csr_sel),
     .dmac_csr_rdata_i                 (dmac_csr_rdata),
     .dmac_fifo_pop_i                  (dmac_fifo_pop),
     .dmac_fifo_push_i                 (dmac_fifo_push),
     .dmac_fifo_wdata_i                (dmac_fifo_wdata),
     .scan_mode                        (scan_mode));



  DWC_mobile_storage_dmac_ahb
   U_DWC_mobile_storage_dmac_ahb 
   (
     .hreq_o                           (m_hreq), 
     .haddr_o                          (m_haddr), 
     .htrans_o                         (m_htrans),
     .hwrite_o                         (m_hwrite), 
     .hsize_o                          (m_hsize), 
     .hburst_o                         (m_hburst), 
     .hwdata_o                         (m_hwdata),
     .dmac_csr_rdata_o                 (dmac_csr_rdata), 
     .dmac_ack_o                       (dw_dma_ack), 
     .dmac_fifo_push_o                 (dmac_fifo_push),
     .dmac_fifo_pop_o                  (dmac_fifo_pop), 
     .dmac_fifo_wdata_o                (dmac_fifo_wdata), 
     .dmac_csr_sel_o                   (dmac_csr_sel), 
     .dmac_biu_intr_o                  (dmac_biu_intr), 
     .fifo_rst_o                       (fifo_ptr_rst),
     .dmac_debug_reg                   (dmac_debug_reg),

     .hclk_i                           (clk),
     .hreset_n_i                       (reset_n),
     .hgrant_i                         (m_hgrant),
     .hready_i                         (m_hready), 
     .hresp_i                          (m_hresp),
     .hrdata_i                         (m_hrdata),
     .dmac_csr_psel_i                  (psel), 
     .dmac_csr_penable_i               (penable), 
     .dmac_csr_paddr_i                 (paddr), 
     .dmac_csr_pben_i                  (pbe),
     .dmac_csr_pwrite_i                (pwrite), 
     .dmac_csr_wdata_i                 (pwdata), 
     .pbl_i                            (pbl), 
     .dmac_req_i                       (dw_dma_req), 
     .new_cmd_i                        (b2c_cmd_start), 
     .data_expected_i                  (b2c_cmd_control[9]),
     .data_w_rn_i                      (b2c_cmd_control[10]), 
     .abort_cmd_i                      (b2c_cmd_control[14]), 
     .end_bit_err_i                    (raw_ints[15]), 
     .resp_tout_i                      (raw_ints[8]),
     .resp_crc_err_i                   (raw_ints[6]), 
     .st_bit_err_i                     (raw_ints[13]), 
     .data_rd_tout_i                   (raw_ints[9]), 
     .data_crc_err_i                   (raw_ints[7]), 
     .resp_err_i                       (raw_ints[1]), 
     .cmd_done_i                       (raw_ints[2]), 
     .dto_i                            (raw_ints[3]), 
     .fifo_rst_i                       (clr_clk1_pointers), 
     .dmac_fifo_rdata_i                (biu_fifo_rdata), 
     .big_endian_i                     (m_hbig_endian),
     .bytecnt_i                        (b2c_byte_count),
     .biu_interrupt_i                  (biu_interrupt),
     .int_enable_i                     (int_enable),
     .fifo_empty_i                     (biu_empty),
     .send_ccsd_i                      (b2c_send_ccsd),
     .scan_mode                        (scan_mode),
     .enable_boot                      (enable_boot),  
     .alternative_boot_mode            (alternative_boot_mode),
     .end_boot_i                       (b2c_cmd_control[26]),
   .biu_card_rd_thres_en             (biu_card_rd_thres_en),
     .boot_ack_timeout                 (boot_ack_tout),
     .boot_data_timeout                (boot_data_tout));


  `endif


  // Bus Interface Unit
  DWC_mobile_storage_biu
   U_DWC_mobile_storage_biu 
    (/*AUTOINST*/
     // Outputs

  `ifdef INTERNAL_DMAC_YES

     .prdata                            (biu_csr_rdata[`H_DATA_WIDTH-1:0]),
     .use_internal_dmac                 (use_internal_dmac),
     .dw_dma_trans_size                 (pbl),
     .fifo_ptr_rst                      (fifo_ptr_rst),
     .interrupt                         (biu_interrupt),
     .dmac_push                         (dmac_fifo_push),
     .dmac_pop                          (dmac_fifo_pop),

  `endif



     .dw_dma_req                        (dw_dma_req),
     .dw_dma_single                     (dw_dma_single),
     .dw_dma_write                      (dw_dma_write),
     .dw_dma_card_num                   (dw_dma_card_num[4:0]),
     .ge_dma_wdata                      (ge_dma_wdata[`GE_DMA_DATA_WIDTH-1:0]),
     .ge_dma_req                        (ge_dma_req),
     .ge_dma_done                       (ge_dma_done),
     .ge_dma_write                      (ge_dma_write),
     .ge_dma_card_num                   (ge_dma_card_num[4:0]),
     .raw_ints                          (raw_ints[31:0]),
     .int_mask_n                        (int_mask_n[31:0]),
     .int_enable                        (int_enable),
   //SD_3.0 start
     .debug_registers                   (debug_registers[959:0]),
   //SD_3.0 ends
     .gp_out                            (gp_out[15:0]),
     .card_power_en                     (card_power_en[`NUM_CARDS-1:0]),
     .card_volt_a                       (card_volt_a[3:0]),
     .card_volt_b                       (card_volt_b[3:0]),
     .b2c_od_pullup_en_n                (b2c_od_pullup_en_n),
     .b2c_clk_divider                   (b2c_clk_divider[31:0]),
     .b2c_clk_source                    (b2c_clk_source[31:0]),
     .b2c_block_size                    (b2c_block_size[15:0]),
     .b2c_byte_count                    (b2c_byte_count[31:0]),
     .b2c_data_tmout_cnt                (b2c_data_tmout_cnt[23:0]),
     .b2c_resp_tmout_cnt                (b2c_resp_tmout_cnt[7:0]),
   //SD_3.0 start
     .b2c_cmd_control                   (b2c_cmd_control[29:0]),
   //SD_3.0 ends
     .enable_boot                       (enable_boot),
     .alternative_boot_mode             (alternative_boot_mode),
     .b2c_cmd_argument                  (b2c_cmd_argument[31:0]),
     .b2c_creset_n                      (b2c_creset_n),
     .b2c_cmd_start                     (b2c_cmd_start),
     .b2c_read_wait                     (b2c_read_wait),
     .b2c_cclk_enable                   (b2c_cclk_enable[`NUM_CARD_BUS-1:0]),
     .b2c_cclk_low_power                (b2c_cclk_low_power[`NUM_CARD_BUS-1:0]),
     .b2c_card_width                    (b2c_card_width[`NUM_CARD_BUS*2-1:0]),
     .b2c_card_type                     (b2c_card_type[`NUM_CARD_BUS-1:0]),
     .b2c_send_irq_resp                 (b2c_send_irq_resp),
     .b2c_abort_read_data               (b2c_abort_read_data),
     .b2c_ceata_intr_status             (b2c_ceata_intr_status),
     .b2c_send_ccsd                     (b2c_send_ccsd),
     .b2c_send_auto_stop_ccsd           (b2c_send_auto_stop_ccsd),
     .b2c_clear_pointers                (b2c_clear_pointers),
   //SD_3.0 start
   .biu_volt_reg                      (biu_volt_reg[`NUM_CARD_BUS-1:0]),
   .b2c_ddr_reg                       (b2c_ddr_reg[`NUM_CARD_BUS-1:0]),
   //SD_3.0 ends
                 //eMMC 4.5 start
                 .ext_clk_mux_ctrl                  (ext_clk_mux_ctrl),
                 .clk_drv_phase_ctrl                (clk_drv_phase_ctrl),
                 .clk_smpl_phase_ctrl               (clk_smpl_phase_ctrl),
   .biu_volt_reg_1_2                  (biu_volt_reg_1_2[`NUM_CARD_BUS-1:0]),
                 .b2c_half_start_bit                (b2c_half_start_bit) ,
                 .b2c_enable_shift                 (b2c_enable_shift) ,
                 //eMMC 4.5 ends
   //MMC4_4 start
     .rst_n                             (rst_n_biu[`NUM_CARD_BUS-1:0]),
   //MMC4_4 ends
     //SDIO 3.0 starts
   .back_end_power                    (back_end_power[`NUM_CARD_BUS-1:0]),
   //SDIO 3.0 ends
     .clr_clk1_pointers                 (clr_clk1_pointers),
     .biu_fifo_wdata                    (biu_fifo_wdata[`F_DATA_WIDTH-1:0]),
     .biu_fifo_pop                      (biu_fifo_pop),
     .biu_fifo_push                     (biu_fifo_push),
     .biu_less_equal_thresh             (biu_less_equal_thresh),
     .biu_greater_than_thresh           (biu_greater_than_thresh),
     .card_rd_threshold_en              (card_rd_threshold_en),
     .busy_clr_int_mask                 (busy_clr_int_mask),
     .card_rd_threshold_size            (card_rd_threshold_size),

     // Inputs
     .clk                               (clk),
     .reset_n                           (reset_n),
     .psel                              (psel),
     .penable                           (penable),
     .pwrite                            (pwrite),
     .paddr                             (paddr[`H_ADDR_WIDTH-1:0]),
     .pbe                               (pbe[`H_DATA_WIDTH/8-1:0]),
     .pwdata                            (pwdata[`H_DATA_WIDTH-1:0]),
     .dw_dma_ack                        (dw_dma_ack),
     .ge_dma_ack                        (ge_dma_ack),
     .ge_dma_rdata                      (ge_dma_rdata[`GE_DMA_DATA_WIDTH-1:0]),
     .card_detect_biu                   (card_detect_biu[`NUM_CARDS-1:0]),
     .card_write_prt_biu                (card_write_prt_biu[`NUM_CARDS-1:0]),
     .gp_in_biu                         (gp_in_biu[7:0]),
     .sdio_interrupt                    (sdio_interrupt[`NUM_CARD_BUS-1:0]),
   //SD_3.0 start
   .volt_switch_int                   (volt_switch_int),
   //SD_3.0 ends
     .c2b_response_data                 (c2b_response_data[37:0]),
     .c2b_response_addr                 (c2b_response_addr[1:0]),
     .c2b_trans_bytes_bin               (c2b_trans_bytes_bin[31:0]),
     .cmd_taken                         (cmd_taken),
     .response_valid                    (response_valid),
     .response_err                      (response_err),
     .response_done                     (response_done),
     .ciu_data_trans_done               (ciu_data_trans_done),
     .data_timeout                      (data_timeout),
     .resp_timeout                      (resp_timeout),
     .data_crc_err                      (data_crc_err),
     .resp_crc_err                      (resp_crc_err),
     .ciu_status                        (ciu_status[7:0]),
     .auto_cmd_done                     (auto_cmd_done),
     .rx_stbit_err                      (rx_stbit_err),
     .data_strv_err                     (data_strv_err),
     .rxend_nocrc_err                   (rxend_nocrc_err),
     .ciu_trans_bytes                   (ciu_trans_bytes[31:0]),
     .clr_abrt_read_data                (clr_abrt_read_data),
     .clear_irq_response                (clear_irq_response),
     .clear_ciu_reset                   (clear_ciu_reset),
     .clr_clear_pointers                (clr_clear_pointers),
     .biu_fifo_rdata                    (biu_fifo_rdata[`F_DATA_WIDTH-1:0]),
     .biu_count                         (biu_count[`F_COUNT_WIDTH-1:0]),
     .biu_almost_empty                  (biu_almost_empty),
     .biu_almost_full                   (biu_almost_full),
     .biu_empty                         (biu_empty),
     .biu_full                          (biu_full),
     .biu_less_or_equal                 (biu_less_or_equal),
     .biu_greater_than                  (biu_greater_than),
     .clr_send_ccsd                     (clr_send_ccsd),
     .scan_mode                         (scan_mode));


  // Card Interface Unit
  DWC_mobile_storage_ciu
   U_DWC_mobile_storage_ciu 
    (/*AUTOINST*/
     // Outputs
     .cdata_out                         (cdata_out[`NUM_CARD_BUS*8-1:0]),
     .cdata_out_en                      (cdata_out_en[`NUM_CARD_BUS*8-1:0]),
     .ccmd_out                          (ccmd_out[`NUM_CARD_BUS-1:0]),
     .ccmd_out_en                       (ccmd_out_en[`NUM_CARD_BUS-1:0]),
     .cclk_out                          (cclk_out[`NUM_CARD_BUS-1:0]),
     .c2b_cmd_taken                     (c2b_cmd_taken),
     .c2b_response_valid                (c2b_response_valid),
     .c2b_response_err                  (c2b_response_err),
     .c2b_response_done                 (c2b_response_done),
     .c2b_data_trans_done               (c2b_data_trans_done),
     .c2b_data_timeout                  (c2b_data_timeout),
     .c2b_resp_timeout                  (c2b_resp_timeout),
     .c2b_data_crc_err                  (c2b_data_crc_err),
     .c2b_resp_crc_err                  (c2b_resp_crc_err),
     .c2b_ciu_fifo_pop                  (c2b_ciu_fifo_pop),
     .c2b_ciu_fifo_push                 (c2b_ciu_fifo_push),
     .c2b_fifo_wdata                    (c2b_fifo_wdata[`F_DATA_WIDTH-1:0]),
     .c2b_response_data                 (c2b_response_data[37:0]),
     .c2b_response_addr                 (c2b_response_addr[1:0]),
     .c2b_ciu_status                    (c2b_ciu_status[3:0]),
     .c2b_sdio_interrupt                (c2b_sdio_interrupt[`NUM_CARD_BUS-1:0]),
     .c2b_trans_bytes                   (c2b_trans_bytes[31:0]),
     .c2b_trans_bytes_bin               (c2b_trans_bytes_bin[31:0]),
     .c2b_rx_stbit_err                  (c2b_rx_stbit_err),
     .c2b_auto_cmd_done                 (c2b_auto_cmd_done),
     .c2b_data_strv_err                 (c2b_data_strv_err),
     .c2b_rxend_nocrc_err               (c2b_rxend_nocrc_err),
     .c2b_cmd_fsm_state_3               (c2b_cmd_fsm_state_3),
     .c2b_cmd_fsm_state_2               (c2b_cmd_fsm_state_2),
     .c2b_cmd_fsm_state_1               (c2b_cmd_fsm_state_1),
     .c2b_cmd_fsm_state_0               (c2b_cmd_fsm_state_0),
     .c2b_clr_send_ccsd                 (c2b_clr_send_ccsd),
     .c2b_boot_ack_tout                 (c2b_boot_ack_tout),
     .c2b_boot_data_tout                (c2b_boot_data_tout),
     .c2b_end_boot                      (c2b_end_boot),
   //SD_3.0 start
     .c2b_volt_switch_int               (c2b_volt_switch_int),
   //SD_3.0 ends
      // Inputs
     .cclk_in                           (cclk_in),
     .cclk_in_drv                       (cclk_in_drv),
     .cclk_in_sample                    (cclk_in_sample),
     .creset_n                          (creset_n),
     .creset_n_sample                   (creset_n_sample),
     .creset_n_drv                      (creset_n_drv),
   .cp_card_num                       (cp_card_num[3:0]),  
     .cdata_in                          (cdata_in[`NUM_CARD_BUS*8-1:0]),
     .ccmd_in                           (ccmd_in[`NUM_CARD_BUS-1:0]),
     .cmd_start                         (cmd_start),
     .read_wait                         (read_wait),
   //SD_3.0 start
     .b2c_cmd_control                   (b2c_cmd_control[29:0]),
   .b2c_ddr_reg                       (b2c_ddr_reg[`NUM_CARD_BUS-1:0]),
   //SD_3.0 ends
     .enable_boot                       (enable_boot),
     .alternative_boot_mode             (alternative_boot_mode),
     .b2c_cmd_argument                  (b2c_cmd_argument[31:0]),
     .b2c_cclk_enable                   (b2c_cclk_enable[`NUM_CARD_BUS-1:0]),
     .b2c_cclk_low_power                (b2c_cclk_low_power[`NUM_CARD_BUS-1:0]),
     .b2c_card_width                    (b2c_card_width[`NUM_CARD_BUS*2-1:0]),
     .b2c_card_type                     (b2c_card_type[`NUM_CARD_BUS-1:0]),
    //MMC4_4 start
     .b2c_card_rd_threshold_en          (card_rd_threshold_en),
     .busy_clr_int_mask                 (busy_clr_int_mask),
      //MMC4_4 ends
   //SDIO 3.0 start
     .card_int_n                        (card_int_n[`NUM_CARD_BUS-1:0]),
   //SDIO 3.0 ends
      //eMMC 4.5 start
      .half_start_bit                  (half_start_bit),
      .enable_shift                    (enable_shift),  
      //eMMC 4.5 end

     .atleast_empty                     (atleast_empty),
     .fifo_full                         (ciu_fifo_full),
     .fifo_empty                        (ciu_fifo_empty),
     .fifo_almost_full                  (ciu_fifo_almost_full),
     .fifo_almost_empty                 (ciu_fifo_almost_empty),
     .b2c_fifo_rdata                    (ciu_fifo_rdata[`F_DATA_WIDTH-1:0]),
     .b2c_clk_divider                   (b2c_clk_divider[31:0]),
     .b2c_clk_source                    (b2c_clk_source[31:0]),
     .b2c_block_size                    (b2c_block_size[15:0]),
     .b2c_byte_count                    (b2c_byte_count[31:0]),
     .b2c_data_tmout_cnt                (b2c_data_tmout_cnt[23:0]),
     .b2c_resp_tmout_cnt                (b2c_resp_tmout_cnt[7:0]),
     .send_irq_response                 (send_irq_response),
     .abort_read_data                   (abort_read_data),
     .ceata_intr_status                 (ceata_intr_status),
     .send_ccsd                         (send_ccsd),
     .send_auto_stop_ccsd               (send_auto_stop_ccsd),
     .sync_od_pullup_en_n               (sync_od_pullup_en_n),
     .scan_mode                         (scan_mode));


  // BIU Clock Domain to Card Domain Synchronizer 
  DWC_mobile_storage_b2c
   U_DWC_mobile_storage_b2c 
    (/*AUTOINST*/
     // Outputs
     .clear_pointers                    (clear_pointers),
     .creset_n                          (creset_n),
     .clear_cntrl0                      (clear_cntrl0),
     .cmd_start                         (cmd_start),
     .read_wait                         (read_wait),
     .sync_od_pullup_en_n               (sync_od_pullup_en_n),
     .abort_read_data                   (abort_read_data),
     .send_irq_response                 (send_irq_response),
     .ceata_intr_status                 (ceata_intr_status),
     .send_ccsd                         (send_ccsd),
     .send_auto_stop_ccsd               (send_auto_stop_ccsd),
   //MMC4_4 start
     .rst_n                             (rst_n[`NUM_CARD_BUS-1:0]),
   //MMC4_4 ends
     .half_start_bit                    (half_start_bit),
     .enable_shift                      (enable_shift),
     .creset_n_sample                   (creset_n_sample),
     .creset_n_drv                      (creset_n_drv),

     // Inputs
     .cclk_in                           (cclk_in),
     .reset_n                           (reset_n),
     .scan_mode                         (scan_mode),
     .b2c_clear_pointers                (b2c_clear_pointers),
     .b2c_creset_n                      (b2c_creset_n),
     .b2c_cmd_start                     (b2c_cmd_start),
     .b2c_read_wait                     (b2c_read_wait),
     .b2c_od_pullup_en_n                (b2c_od_pullup_en_n),
     .b2c_abort_read_data               (b2c_abort_read_data),
     .b2c_send_irq_resp                 (b2c_send_irq_resp),
     .b2c_ceata_intr_status             (b2c_ceata_intr_status),
     .b2c_send_ccsd                     (b2c_send_ccsd),
   //MMC4_4 start
     .rst_n_biu                         (rst_n_biu),
   //MMC4_4 ends
     .b2c_half_start_bit                (b2c_half_start_bit),
     .b2c_enable_shift                 (b2c_enable_shift),
     .cclk_in_sample                    (cclk_in_sample),
     .cclk_in_drv                       (cclk_in_drv),
     .b2c_send_auto_stop_ccsd           (b2c_send_auto_stop_ccsd));

  // Card Clock Domain to BIU Domain Synchronizer 
  DWC_mobile_storage_c2b
   U_DWC_mobile_storage_c2b 
    (/*AUTOINST*/
     // Outputs
     .cmd_taken                         (cmd_taken),
     .response_valid                    (response_valid),
     .response_err                      (response_err),
     .response_done                     (response_done),
     .ciu_data_trans_done               (ciu_data_trans_done),
     .data_timeout                      (data_timeout),
     .resp_timeout                      (resp_timeout),
     .data_crc_err                      (data_crc_err),
     .resp_crc_err                      (resp_crc_err),
     .auto_cmd_done                     (auto_cmd_done),
     .rx_stbit_err                      (rx_stbit_err),
     .data_strv_err                     (data_strv_err),
     .rxend_nocrc_err                   (rxend_nocrc_err),
     .clr_abrt_read_data                (clr_abrt_read_data),
     .clear_irq_response                (clear_irq_response),
     .clear_ciu_reset                   (clear_ciu_reset),
     .clr_clear_pointers                (clr_clear_pointers),
     .card_detect_biu                   (card_detect_biu[`NUM_CARDS-1:0]),
     .card_write_prt_biu                (card_write_prt_biu[`NUM_CARDS-1:0]),
     .gp_in_biu                         (gp_in_biu[7:0]),
     .sdio_interrupt                    (sdio_interrupt[`NUM_CARD_BUS-1:0]),
     .ciu_status                        (ciu_status[7:0]),
     .ciu_trans_bytes                   (ciu_trans_bytes[31:0]),
     .clr_send_ccsd                     (clr_send_ccsd),
     .end_boot                          (end_boot),
     .boot_ack_tout                     (boot_ack_tout), 
     .boot_data_tout                    (boot_data_tout),
   //SD_3.0 start
     .volt_switch_int                   (volt_switch_int),
   //SD_3.0 ends

     // Inputs
     .clk                               (clk),
     .reset_n                           (reset_n),
     .c2b_cmd_taken                     (c2b_cmd_taken),
     .c2b_response_valid                (c2b_response_valid),
     .c2b_response_err                  (c2b_response_err),
     .c2b_response_done                 (c2b_response_done),
     .c2b_data_trans_done               (c2b_data_trans_done),
     .c2b_data_timeout                  (c2b_data_timeout),
     .c2b_resp_timeout                  (c2b_resp_timeout),
     .c2b_data_crc_err                  (c2b_data_crc_err),
     .c2b_resp_crc_err                  (c2b_resp_crc_err),
     .c2b_auto_cmd_done                 (c2b_auto_cmd_done),
     .c2b_rx_stbit_err                  (c2b_rx_stbit_err),
     .c2b_data_strv_err                 (c2b_data_strv_err),
     .c2b_rxend_nocrc_err               (c2b_rxend_nocrc_err),
     .abort_read_data                   (abort_read_data),
     .send_irq_response                 (send_irq_response),
     .card_detect_n                     (card_detect_n[`NUM_CARDS-1:0]),
     .card_write_prt                    (card_write_prt[`NUM_CARDS-1:0]),
     .gp_in                             (gp_in[7:0]),
     .c2b_sdio_interrupt                (c2b_sdio_interrupt[`NUM_CARD_BUS-1:0]),
     .c2b_cmd_fsm_state_3               (c2b_cmd_fsm_state_3),
     .c2b_cmd_fsm_state_2               (c2b_cmd_fsm_state_2),
     .c2b_cmd_fsm_state_1               (c2b_cmd_fsm_state_1),
     .c2b_cmd_fsm_state_0               (c2b_cmd_fsm_state_0),
     .c2b_ciu_status                    (c2b_ciu_status[3:0]),
     .clear_cntrl0                      (clear_cntrl0),
     .clear_pointers                    (clear_pointers),
     .c2b_clr_send_ccsd                 (c2b_clr_send_ccsd),
     .c2b_end_boot                      (c2b_end_boot),
     .c2b_boot_ack_tout                 (c2b_boot_ack_tout),
   //SD_3.0 start
     .c2b_volt_switch_int               (c2b_volt_switch_int),
   //SD_3.0 ends
     .c2b_boot_data_tout                (c2b_boot_data_tout),
     .c2b_trans_bytes                   (c2b_trans_bytes[31:0]));

  // 2 clock FIFO Controller
  DWC_mobile_storage_2clk_fifoctl
   #(`RAM_DEPTH, `F_DATA_WIDTH) U_DWC_mobile_storage_fifoctl 
    (
     .clk1                                   (clk),
     .reset1_n                               (reset_n),

  `ifdef INTERNAL_DMAC_YES

     .pop1                                   (pop1),
     .push1                                  (push1),
     .fifo_din1                              (fifo_din1),

  `endif



     .fifo_dout1                             (biu_fifo_rdata),
     .ram_rd_data1                           (ram_rd_data1),
     .ram_cs1_n                              (ram_cs1_n),
     .ram_wr1_n                              (ram_wr1_n),
     .ram_rd1_n                              (ram_rd1_n),
     .ram_addr1                              (ram_addr1),
     .ram_wr_data1                           (ram_wr_data1),
     .count1                                 (biu_count),
     .empty1                                 (biu_empty),
     .full1                                  (biu_full),
     .almost_empty1                          (biu_almost_empty),
     .almost_full1                           (biu_almost_full),
     .less_or_equal1                         (biu_less_or_equal),
     .greater_than1                          (biu_greater_than),
     .clear_pointers1                        (clr_clk1_pointers),
     .less_equal_thresh1                     (biu_less_equal_thresh),
     .greater_than_thresh1                   (biu_greater_than_thresh),
     .clk2                                   (cclk_in),
     .reset2_n                               (creset_n),
     .pop2                                   (c2b_ciu_fifo_pop),
     .push2                                  (c2b_ciu_fifo_push),
     .fifo_din2                              (c2b_fifo_wdata[`F_DATA_WIDTH-1:0]),
     .fifo_dout2                             (ciu_fifo_rdata),
     .ram_rd_data2                           (ram_rd_data2),
     .ram_cs2_n                              (ram_cs2_n),
     .ram_wr2_n                              (ram_wr2_n),
     .ram_rd2_n                              (ram_rd2_n),
     .ram_addr2                              (ram_addr2),
     .ram_wr_data2                           (ram_wr_data2),
   .atleast_empty                          (atleast_empty),
     .empty2                                 (ciu_fifo_empty),
     .full2                                  (ciu_fifo_full),
     .almost_empty2                          (ciu_fifo_almost_empty),
     .almost_full2                           (ciu_fifo_almost_full),
   .card_rd_threshold_size                 (card_rd_threshold_size),
     .clear_pointers2                        (clear_pointers),
     .less_equal_thresh2                     ({`F_COUNT_WIDTH{1'b0}}),
     .greater_than_thresh2                   ({`F_COUNT_WIDTH{1'b0}}));


  // Instantiation for Transmit/Receive Dual Port Synchronous Ram 

  `ifdef FIFO_RAM_INSIDE_CORE

  DWC_mobile_storage_2clk_dssram
   #(`RAM_DEPTH, `F_DATA_WIDTH) U_DWC_mobile_storage_dssram 
    (
     // Outputs
     .ram_rd_data1                           (ram_rd_data1),
     .ram_rd_data2                           (ram_rd_data2),
     // Inputs
     .clk1                                   (clk),
     .ram_cs1_n                              (ram_cs1_n),
     .ram_wr1_n                              (ram_wr1_n),
     .ram_rd1_n                              (ram_rd1_n),
     .ram_addr1                              (ram_addr1),
     .ram_wr_data1                           (ram_wr_data1),
     .clk2                                   (cclk_in),
     .ram_cs2_n                              (ram_cs2_n),
     .ram_wr2_n                              (ram_wr2_n),
     .ram_rd2_n                              (ram_rd2_n),
     .ram_addr2                              (ram_addr2),
     .ram_wr_data2                           (ram_wr_data2)
    );


   `endif


endmodule // DWC_mobile_storage
