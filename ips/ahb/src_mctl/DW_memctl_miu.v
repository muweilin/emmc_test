//============================================================================
//
//                   (C) COPYRIGHT 2001-2011 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc.  Your use or disclosure of this
// software is subject to the terms and conditions of a written
// license agreement between you, or your company, and Synopsys, Inc.
//
// The entire notice above must be reproduced on all authorized copies
//
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_miu.v $ 
// $Revision: #5 $
//
// Abstract  : This is the top level module for the Memory controller unit.
// This has the instantiations for the Static and the SDRAM controller state
// machines and also the Control register block. The other modules
// instantiated in this are the address decoder, the addrmux and the dmc.The
// addrmux module will be enabled only when the parameter
// ENABLE_ADDRBUS_SHARING is set to 1.
//
//============================================================================
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
  module DW_memctl_miu(
                     hclk, 
                     hclk_2x,
                     hresetn,
                     scan_mode,
                     //interface with HIU
                     hiu_mem_req,          
                     hiu_reg_req,         
                     hiu_rw,             
                     hiu_burst_size,    
                     hiu_wrapped_burst, 
                     hiu_terminate,     
                     hiu_addr,          
                     hiu_haddr,
                     hiu_hsize,
                     hiu_wr_data,      
                     s_rd_data,       
                     miu_burst_done, 
                     miu_pop_n,   
                     miu_push_n, 
                     miu_col_addr_width,     
                     miu_data_width,        
                     m_addr,               
                     s_addr,              
                     s_bank_addr,        
                     s_ras_n,           
                     s_cas_n,          
                     s_sel_n,         
                     s_cke,          
                     sf_cke,
                     s_we_n,        
                     s_wr_data,
                     s_dqm,        
                     s_dout_valid,
                     s_rd_ready,
                     s_rd_start,
                     s_rd_pop,
                     s_rd_end, 
                     s_rd_dqs_mask,
                     s_cas_latency,
                     s_read_pipe,
                     sf_cas_latency,
                     s_sa,    
                     s_scl,    
                     s_dqs,
                     s_rp_n,
                     s_sda_out, 
                     s_sda_in,   
                     s_sda_oe_n,  
                     // Interface with Static Memories
                     sm_addr,     
                     sm_oe_n,    
                     sm_we_n,   
                     sm_bs_n,  
                     sm_dout_valid,    
                     sm_rp_n,         
                     sm_wp_n,    
                     sm_adv_n,
                     sm_rd_data,   
                     sm_wr_data,    
                     remap,          
                     sm_clken,
                     sm_ready,
                     sm_data_width_set0,
                     // Signal for data bus sharing
                     sm_access,
                     m_wr_data,
                     m_dout_valid,
                     m_precharge_bit,
                     // EBI Interface
                     s_ebi_req,        
                     s_ebi_gnt,     
                     sm_ebi_req,     
                     sm_ebi_gnt,      
                     // Power management
                     power_down,       
                     sf_power_down,
                     sm_power_down,
                     clear_sr_dp,
                     sf_clear_dp,
                     big_endian,
                     miu_rd_data_out,
                     gpi,     
                     gpo,
                                                   // DEBUG
                     debug_ad_bank_addr,
                     debug_ad_row_addr,
                     debug_ad_col_addr,
                     debug_ad_sf_bank_addr,
                     debug_ad_sf_row_addr,
                     debug_ad_sf_col_addr,
                     debug_sm_burst_done,
                     debug_sm_pop_n,
                     debug_sm_push_n,
                     debug_smc_cs,
                     debug_ref_req   );


  input                 hclk;             // AHB Clock
  input                 hclk_2x;          // 2x clock for DDR
  input                 hresetn;          // AHB Asynchronous reset.
  input                 scan_mode;        // Test Mode 
  input                 hiu_mem_req;      // SDRAM read/write request 
                                          // from the HIU.
  input                 hiu_reg_req;      // Register read/write request 
                                          // from the HIU
  input                 hiu_rw;           // Read/write signal from HIU
                                          // for memory/register access
  input  [5:0]          hiu_burst_size;   // Size of an SDRAM Read/Write access
  input                 hiu_wrapped_burst;// Indicates if the corresponding
                                          // burst is wrapped or not.
  input                 hiu_terminate;    // Terminate the ongoing SDRAM burst.
                                          // Current data is invalid.
  input [3:0]           hiu_haddr;        // HADDR[3:0]
  input [2:0]           hiu_hsize;        // HSIZE[2:0]
  output                miu_burst_done;   // Done signal to HIU indicating 
                                          // that an SDRAM access or register 
                                          // read/write access is done
  output                miu_pop_n;        // Pop signal to the Writedata buffer
                                          // This signal is valid
                                          // for both SDRAM write as well as 
                                          // Register write operations.
  output                miu_push_n;       // write signal to the HIU readbuffer
                                          // This signal is valid 
                                          // for both SDRAM read as well as
                                          // register read operations.
  output [3:0]          miu_col_addr_width;//Programmed value of column 
                                          // address width.
  output [1:0]          miu_data_width;   // Programmed value of sdram 
                                          // data width.
  output                s_ras_n;          // Row address strobe to the SDRAM.
  output                s_cas_n;          // Column address strobe to SDRAM 
  output [`N_CS-1:0]    s_sel_n;          // Chip select to the SDRAM.
  output                s_cke;            // Clock enable input to the SDRAM. 
  output                sf_cke;           // Clock enable input to the SyncFlash
  output                s_we_n;           // Write enebale input to the SDRAM.
  output[`MAX_S_DATA_WIDTH-1:0]s_wr_data; // Write data to SDRAM
  output[`MAX_S_DATA_WIDTH/8-1:0]s_dqm;   // Data mask to SDRAM
  output[`MAX_S_DATA_WIDTH/8-1:0]s_dout_valid;     // Data enebale input to the 
                                          // tristate buffer
  input                 s_rd_ready;       // Data ready signal
  output                s_rd_start;       // Read burst start
  output                s_rd_pop;         // Data pop signal for data capture  
  output                s_rd_end;         // Read burst end 
  output                s_rd_dqs_mask;    // Read dqs mask
  output [2:0]          s_cas_latency;    // SDRAM cas latency
  output [2:0]          s_read_pipe;      // Read pipe
  output [2:0]          sf_cas_latency;   // SyncFlash case latency
  output [2:0]          s_sa;             // Serial Presence Detect address
  output                s_scl;            // Serial Presence Detect clock 
  output [`NUM_DQS-1:0] s_dqs;            // Data Strobe for DDR
  output                s_rp_n;           // Reset/Power down for SyncFlash
  output                s_sda_out;        // Serial Presence Detect Data Out
  output                s_sda_oe_n;       // Serial Presence Detect Data enable
  input                 s_sda_in;         // Serial Presence Detect Data In
  input                 remap;            // Address remap control input
  input                 sm_clken;         // Clock enable for low freq Syncflash
  input                 sm_ready;         // Data ready from memory
  input           [2:0] sm_data_width_set0; // Set0 Boot Data Width 
  output                sm_oe_n;          // Static Memory Output Enable  
  output                sm_we_n;          // Write enable  
  output[`MAX_SM_DATA_WIDTH/8-1:0]sm_dout_valid;    // data output valid
  output                sm_rp_n;          // flash Reset/Power down
  output [2:0]          sm_wp_n;          // Flash write protection
  output                sm_access;        // Indicates Static memory access
  output                sm_adv_n;         // Address valid forSynchronous Flash
 
  // EBI Interface Signals

  output                s_ebi_req;        // SDRAM req to EBI INterface
  input                 s_ebi_gnt;        // EBI grant for SDRAM ctl
  output                sm_ebi_req;       // STATIC req to EBI INterface
  input                 sm_ebi_gnt;       // EBI grant for static control

  //Power Management signals

  input                 power_down;       // Power down input from the external
                                          // power management unit.
  input                 sf_power_down;    // SyncFlash power down input 
  input                 sm_power_down;    // Static memory power down input
  input                 clear_sr_dp;      // Clear the self_ref_rp bit
  input                 sf_clear_dp;      // Clear SyncFlash dp bit

  input  [`H_ADDR_WIDTH-1:0]         hiu_addr;     // Address input from HIU
  input  [`S_RD_DATA_WIDTH-1:0]      hiu_wr_data;  // Write data from the fifo
  input  [`S_RD_DATA_WIDTH-1:0]      s_rd_data;    // Read data from SDRAM.
  output [`S_RD_DATA_WIDTH-1:0]      miu_rd_data_out;// Read dataout to the HIU
  output [`M_ADDR_WIDTH-1:0]         m_addr;       // Shared memory address bus
                                                   // SDRAM Interface signals
  output [`MAX_S_ADDR_WIDTH-1:0]     s_addr;       // Addessoutput to the SDRAM
  output [`MAX_S_BANK_ADDR_WIDTH-1:0] s_bank_addr; // BAnk address output 
                                                   // to the SDRAM.
  output [`MAX_SM_ADDR_WIDTH-1:0]    sm_addr;      // Static Memory address
  output [`MAX_SM_DATA_WIDTH/8-1:0]  sm_bs_n;      // Byte enables
  input  [`MAX_SM_DATA_WIDTH-1:0]    sm_rd_data;   // ReadData from StatiMemory
  output [`MAX_SM_DATA_WIDTH-1:0]    sm_wr_data;   // writeData to StaticMemory
  output [`M_DATA_WIDTH-1:0]         m_wr_data;    // Shared Mode writeData
  output [`M_DATA_WIDTH/8-1:0]       m_dout_valid; // Shared - data outpt valid 
  output                             m_precharge_bit; // Shared Mode SDRAM addr-10
  input                              big_endian;   // Endianness
  input  [7:0]                       gpi;          // general purpose inputs
  output [7:0]                       gpo;          // general purpose outputs

  //debug ports
  output [`MAX_S_BANK_ADDR_WIDTH-1:0] debug_ad_bank_addr; 
  output [`MAX_S_ADDR_WIDTH-1:0] debug_ad_row_addr;  
  output [`MAX_S_ADDR_WIDTH-1:0] debug_ad_col_addr;  
  output [`MAX_S_BANK_ADDR_WIDTH-1:0] debug_ad_sf_bank_addr;
  output [`MAX_S_ADDR_WIDTH-1:0] debug_ad_sf_row_addr; 
  output [`MAX_S_ADDR_WIDTH-1:0] debug_ad_sf_col_addr; 

  output debug_sm_burst_done;
  output debug_sm_pop_n;
  output debug_sm_push_n; 
  output [3:0] debug_smc_cs;
  output debug_ref_req;
   
  reg  [`N_CS-1:0]             s_sel_n_int;
  reg  [`S_RD_DATA_WIDTH-1:0]  miu_rd_data_reg;
  reg                          cr_push_reg_n;
  reg                          sm_power_down_r;

  wire [`MAX_S_ADDR_WIDTH-1:0] ad_row_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0] ad_col_addr;
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0] ad_bank_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0] ad_sf_row_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0] ad_sf_col_addr;
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0] ad_sf_bank_addr;
  wire [3:0]                   cr_row_addr_width;
  wire [3:0]                   cr_col_addr_width;
  wire [3:0]                   cr_sf_row_addr_width;
  wire [3:0]                   cr_sf_col_addr_width;
  wire [2:0]                   cr_cas_latency;
  wire [2:0]                   cr_sf_cas_latency;
  wire [3:0]                   cr_t_ras_min;
  wire [2:0]                   cr_t_rcd;
  wire [2:0]                   cr_sf_t_rcd;
  wire [2:0]                   cr_t_rp;
  wire [3:0]                   cr_t_rc;
  wire [3:0]                   cr_sf_t_rc;
  wire [1:0]                   cr_t_wr;
  wire [1:0]                   cr_t_wtr;
  wire [3:0]                   cr_t_rcar;
  wire [8:0]                   cr_t_xsr;
  wire [15:0]                  cr_t_init;
  wire [3:0]                   cr_num_init_ref;
  wire [15:0]                  cr_t_ref;
  wire [1:0]                   cr_sdram_data_width;
  wire [1:0]                   cr_sdram_dwidth;
  wire [1:0]                   sdram_dwidth_const;
  wire [1:0]                   ddr_dwidth_const;
  wire [1:0]                   sdr_dwidth_const;
  wire [1:0]                   cr_s_data_width_early;
  wire [8:0]                   smcr_data_width;
  wire [2:0]                   sm_data_width_i;
  wire [8:0]                   smcr_data_width_early;
  wire [10:0]                  cr_block_size1;
  wire [10:0]                  cr_block_size2;
  wire [10:0]                  cr_block_size3;
  wire [10:0]                  cr_block_size4;
  wire [10:0]                  cr_block_size5;
  wire [10:0]                  cr_block_size6;
  wire [10:0]                  cr_block_size7;
  wire [10:0]                  cr_block_size8;
  wire [`H_ADDR_WIDTH-1:16]    cr_scslr1;
  wire [`H_ADDR_WIDTH-1:16]    cr_scslr2;
  wire [`H_ADDR_WIDTH-1:16]    cr_scslr3;
  wire [`H_ADDR_WIDTH-1:16]    cr_scslr4;
  wire [`H_ADDR_WIDTH-1:16]    cr_scslr5;
  wire [`H_ADDR_WIDTH-1:16]    cr_scslr6;
  wire [`H_ADDR_WIDTH-1:16]    cr_scslr7;
  wire [`H_ADDR_WIDTH-1:16]    cr_scslr8;
  wire [`H_ADDR_WIDTH-1:16]    cr_alias_reg0;
  wire [`H_ADDR_WIDTH-1:16]    cr_alias_reg1;
  wire [`H_ADDR_WIDTH-1:16]    cr_remap_reg0;
  wire [`H_ADDR_WIDTH-1:16]    cr_remap_reg1;
  wire [`S_RD_DATA_WIDTH-1:0]  cr_reg_data_out;
  wire [1:0]                   cr_bank_addr_width;
  wire [1:0]                   cr_sf_bank_addr_width; 
  wire                         ctl_burst_done;
  wire                         sd_burst_done;
  wire                         sf_burst_done;
  wire                         cr_req_done;
  wire                         ctl_pop_n;
  wire                         sd_pop_n;
  wire                         sf_pop_n;
  wire                         cr_pop_n;
  wire                         cr_push_n;
  wire                         ctl_push_n;
  wire                         sd_push_n;
  wire                         sf_push_n;
  wire                         smcr_push_n;
  wire                         sm_push_n;
  wire                         smcr_pop_n;
  wire                         sm_pop_n;
  wire [`S_RD_DATA_WIDTH-1:0]  sm_rd_data_out;
  wire                         smcr_req_done;
  wire                         sm_burst_done;
  wire [`N_CS-1:0]             ad_static_chip_select;
  wire [5:0]                   smcr_t_rc_set0;
  wire [1:0]                   smcr_t_as_set0;
  wire [1:0]                   smcr_t_wr_set0;
  wire [5:0]                   smcr_t_wp_set0;
  wire [2:0]                   smcr_t_bta_set0;
  wire [3:0]                   smcr_t_prc_set0;
  wire [11:0]                  smcr_t_rpd;
  wire                         smcr_page_mode_set0;
  wire [1:0]                   smcr_page_size_set0;
  wire [5:0]                   smcr_t_rc_set1;
  wire [1:0]                   smcr_t_as_set1;
  wire [1:0]                   smcr_t_wr_set1;
  wire [5:0]                   smcr_t_wp_set1;
  wire [2:0]                   smcr_t_bta_set1;
  wire [3:0]                   smcr_t_prc_set1;
  wire                         smcr_page_mode_set1;
  wire [1:0]                   smcr_page_size_set1;
  wire [5:0]                   smcr_t_rc_set2;
  wire [1:0]                   smcr_t_as_set2;
  wire [1:0]                   smcr_t_wr_set2;
  wire [5:0]                   smcr_t_wp_set2;
  wire [2:0]                   smcr_t_bta_set2;
  wire [3:0]                   smcr_t_prc_set2;
  wire                         smcr_page_mode_set2;
  wire [1:0]                   smcr_page_size_set2;
  wire [1:0]                   ad_timing_select;
  wire [`S_RD_DATA_WIDTH-1:0]  smcr_rd_data_out;
  wire [`N_CS-1:0]             sm_chip_select;
  wire [`N_CS-1:0]             sm_chip_select_i;
  wire [`N_CS-1:0]             ctl_chip_select;
  wire [`MAX_SM_ADDR_WIDTH-1:0] ad_sm_addr;
  wire [`N_CS-1:0]             ad_sdram_chip_select;
  wire [`N_CS-1:0]             ad_syncflash_chip_select;
  wire [`N_CS-1:0]             ad_sdram_type;
  wire                         cr_do_power_down;
  wire                         ad_sdram_req;
  wire                         sdram_req_i;
  wire                         smcr_flash_power_down;
  wire                         ad_flash_access;
  wire                         flash_pd_rp;
  wire                         dmc_burst_done;
  wire                         dmc_pop_n;
  wire                         dmc_push_n; 
  wire                         ad_static_mem_req;
  wire [2:0]                   smcr_write_protect_mode;
  wire                         mem_req_no_chipsel;
  wire                         sdram_req_while_sdram_sr;
  wire                         sf_req_while_sf_dp;
  wire                         flash_req_while_flash_pd;
  wire                         syncflash_nonsingle_operation;
  wire                         hiu_dummy_req;
  wire                         ctl_auto_ref_en;
  wire                         ctl_auto_ref_en_i;
  wire                         ref_ref_req;
  wire                         ctl_ref_ack;
  wire                         ctl_ref_ack_i;
  wire                         cr_do_initialize;
  wire                         cr_delayed_precharge;
  wire                         cr_ref_all_before_sr;
  wire                         cr_ref_all_after_sr;
  wire                         ctl_init_done;
  wire                         ctl_mode_reg_done;
  wire                         ctl_ext_mode_reg_done;
  wire                         ctl_ext_mode_reg_done_i;
  wire                         ctl_sd_in_sf_mode;
  wire                         sfctl_clear_fl_op;
  wire                         sfctl_clear_fl_op_i;
  wire                         sfctl_pdr_done;
  wire                         sfctl_pdr_done_i;
  wire                         sm_set_flash_rp;
  wire                         smcr_set_flash_rp;
  wire  [`H_DATA_WIDTH/8-1:0]  ad_data_mask;
  wire  [`H_DATA_WIDTH/8-1:0]  ad_cr_data_mask;
  wire  [2:0]                  cr_read_pipe;
  wire  [15:0]                 cr_sf_trpdr;
  wire                         cr_mode_reg_update;
  wire  [12:0]                 cr_exn_mode_value;
  wire                         cr_exn_mode_reg_update; 
  wire  [4:0]                  cr_num_open_banks;
  wire  [1:0]                  smcr_sm_read_pipe_set0;
  wire  [1:0]                  smcr_sm_read_pipe_set1;
  wire  [1:0]                  smcr_sm_read_pipe_set2;
  wire  [11:0]                 cr_operation_code;
  wire                         cr_s_ready_valid;
  wire                         cr_software_sequence;
  wire                         cr_flash_operation;
  wire                         cr_do_self_ref_rp;
  wire [`MAX_S_DATA_WIDTH/4-1:0] pre_dqm;
  wire                         pre_dqs; 
  wire                         pre_amble;
  wire                         pre_rd_dqs_mask;
  wire [`MAX_S_DATA_WIDTH-1:0] ddr_wr_data; 
  wire  [31:0]                 cr_wr_data2_smcr;
  wire  [3:0]                  cr_mask2_smcr;
  wire                         reg_req_i;
  wire                         smcr_smcr_selected;
  wire                         smcr_smcr_selected_i;
  wire[`MAX_S_DATA_WIDTH/8-1:0] sd_dout_valid;
  wire[`MAX_S_DATA_WIDTH/8-1:0] sf_dout_valid;
  wire                         sd_rd_start;
  wire                         sf_rd_start;
  wire                         sd_rd_pop;
  wire                         sf_rd_pop;
  wire                         sd_rd_end;
  wire                         sf_rd_end;
  wire                         sd_rd_dqs_mask;
  wire                         sf_rd_dqs_mask;
  wire                         sd_ras_n;
  wire                         sf_ras_n;
  wire                         sd_cas_n;
  wire                         sf_cas_n;
  wire                         sd_we_n;
  wire                         sf_we_n;
  wire [`N_CS-1:0]             sd_chip_select;
  wire [`N_CS-1:0]             sf_chip_select;
  wire                         sd_access;
  wire                         sf_access;
  wire [7:0]                   sdram_select;
  wire [7:0]                   syncflash_select;
  wire                         sf_req;
  wire                         sd_req;
  wire                         sd_arb_req;
  wire                         sf_arb_req;
  wire                         sd_ebi_req;
  wire                         sf_ebi_req;
  wire                         ad_syncflash_req;
  wire                         cr_do_sf_dp;
  wire                         sf_cke_i;
  wire                         cr_sf_in_dp_mode; 
  wire                         ctl_sf_mode_reg_done;
  wire                         mobile_sdram_dpd_en;
  wire                         sd_in_dpd_mode;
  wire                         cr_sd_in_dpd_mode;
  wire                         sdram_req_while_sdram_dpd;

  wire[`MAX_S_DATA_WIDTH/8-1:0]      ctl_s_dqm;
  wire[`MAX_S_DATA_WIDTH/8-1:0]      sd_dqm;
  wire[`MAX_S_DATA_WIDTH/8-1:0]      sf_dqm;  
  wire [`MAX_S_ADDR_WIDTH-1:0]       s_addr;     
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0]  s_bank_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0]       ctl_s_addr;       
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0]  ctl_s_bank_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0]       sd_addr;
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0]  sd_bank_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0]       sf_addr;
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0]  sf_bank_addr;

  integer i;

  //debug wires
  wire debug_sm_burst_done;
  wire debug_sm_pop_n;
  wire debug_sm_push_n; 
  wire [3:0] debug_smc_cs;  //
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0] debug_ad_bank_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0] debug_ad_row_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0] debug_ad_col_addr;
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0] debug_ad_sf_bank_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0] debug_ad_sf_row_addr; 
  wire [`MAX_S_ADDR_WIDTH-1:0] debug_ad_sf_col_addr; 
  wire debug_ref_req;
   
  wire sm_clken;
  wire sm_ready;
   
  assign debug_ad_bank_addr = ad_bank_addr;
  assign debug_ad_row_addr = ad_row_addr;
  assign debug_ad_col_addr = ad_col_addr;
  assign debug_ad_sf_bank_addr = ad_sf_bank_addr;
  assign debug_ad_sf_row_addr = ad_sf_row_addr;
  assign debug_ad_sf_col_addr = ad_sf_col_addr; 

  assign debug_sm_burst_done = sm_burst_done;
  assign debug_sm_pop_n = sm_pop_n;
  assign debug_sm_push_n = sm_push_n;

  // arbitration FSM states for SDRAM and SyncFlash
  `define SD_GNT 0           // SDRAM request granted
  `define SF_GNT 1           // SyncFlash granted 

  // Output Signals 
  assign s_wr_data     = (`DYNAMIC_RAM_TYPE == 1)? ddr_wr_data : hiu_wr_data; 
  assign m_wr_data     = (sm_access)? sm_wr_data : s_wr_data;
  assign m_dout_valid  = (sm_access)? sm_dout_valid : s_dout_valid;  
  assign m_addr        = (sm_access)? sm_addr : s_addr;

  assign m_precharge_bit  = (`A8_FOR_PRECHARGE == 1) ? s_addr[8] : s_addr[10];
  assign s_cas_latency    = cr_cas_latency;
  assign sf_cas_latency   = cr_sf_cas_latency;
  assign s_read_pipe      = cr_read_pipe;
  assign sf_cke           = (`DYNAMIC_RAM_TYPE ==4 | `DYNAMIC_RAM_TYPE ==5) ?
                          sf_cke_i : 1'b0;

  //----------------------------------------------------------------
  // Request to SDRAM while SDRAM in Deep Power Down. This will
  // result in a Dummy Memory Controller response.
  //----------------------------------------------------------------

  assign sdram_req_while_sdram_dpd = sd_in_dpd_mode & ad_sdram_req;
  
  //----------------------------------------------------------------
  // Hiu request with no memory base address match. This will result
  // in dummy cycles
  //----------------------------------------------------------------

  assign mem_req_no_chipsel = hiu_mem_req & ~ad_static_mem_req & ~ad_sdram_req 
                              & ~ad_syncflash_req;

  //----------------------------------------------------------------
  // Request to the SDRAM(SyncFlash) while it is in self refresh mode
  // (deep power down mode). This will result in dummy ready to the AHB.
  //----------------------------------------------------------------

  assign sdram_req_while_sdram_sr = cr_do_self_ref_rp & ad_sdram_req;
  assign sf_req_while_sf_dp =(`DYNAMIC_RAM_TYPE ==4 | `DYNAMIC_RAM_TYPE ==5) & 
                             cr_do_sf_dp & ad_syncflash_req; 

  //----------------------------------------------------------------
  // Request to the FLASH while it is in power down mode. This will
  // result in dummy ready to the AHB
  //----------------------------------------------------------------
  assign flash_req_while_flash_pd = (smcr_flash_power_down | sm_power_down) 
                                    & ad_static_mem_req & ad_flash_access;

  //----------------------------------------------------------------
  // AHB non-single write to SyncFlash. This will result in dummy
  // ready to the AHB. 
  //----------------------------------------------------------------
  assign syncflash_nonsingle_operation = ((`DYNAMIC_RAM_TYPE == 2) & 
                         (cr_flash_operation | hiu_rw == 1'b0) 
                         & (hiu_burst_size != 1) & ad_sdram_req) |
                         ((`DYNAMIC_RAM_TYPE ==4 | `DYNAMIC_RAM_TYPE ==5) &  
                         (cr_flash_operation | hiu_rw == 1'b0)
                         & (hiu_burst_size != 1) & ad_syncflash_req); 

  //----------------------------------------------------------------
  // Request to the Dummy ccycle generator block.
  //----------------------------------------------------------------

  assign hiu_dummy_req = (mem_req_no_chipsel | sdram_req_while_sdram_sr |
                          sf_req_while_sf_dp | flash_req_while_flash_pd | 
                          sdram_req_while_sdram_dpd |
                          syncflash_nonsingle_operation) & 
                          ((`ENABLE_STATIC==1) ? ~sm_access : 1'b1);

  //----------------------------------------------------------------
  // Memory or Register cycle done signal to HIU
  //----------------------------------------------------------------

  assign miu_burst_done = (`ENABLE_STATIC==1 && `DYNAMIC_RAM_TYPE !=6) ?
                          ctl_burst_done | cr_req_done | smcr_req_done |
                          sm_burst_done | dmc_burst_done : 
                        (`ENABLE_STATIC==0 && `DYNAMIC_RAM_TYPE !=6) ?
                          ctl_burst_done |cr_req_done |dmc_burst_done : 
                          cr_req_done | smcr_req_done |sm_burst_done | 
                          dmc_burst_done;


  //----------------------------------------------------------------
  // Pop signal to the data fifo in HIU for memory/register writes
  //----------------------------------------------------------------

  assign miu_pop_n      = (`ENABLE_STATIC==1 && `DYNAMIC_RAM_TYPE !=6) ?
                            ctl_pop_n & cr_pop_n & smcr_pop_n
                            & sm_pop_n & dmc_pop_n : 
                          (`ENABLE_STATIC==0 && `DYNAMIC_RAM_TYPE !=6) ?
                            ctl_pop_n & cr_pop_n & dmc_pop_n :
                            cr_pop_n & smcr_pop_n & sm_pop_n & dmc_pop_n;
  

  //----------------------------------------------------------------
  // Pop signal to the data fifo in HIU for memory/register Reads
  //----------------------------------------------------------------

  assign miu_push_n     = (`ENABLE_STATIC==1 && `DYNAMIC_RAM_TYPE !=6) ?
                           ctl_push_n & cr_push_reg_n & sm_push_n & dmc_push_n:
                           (`ENABLE_STATIC==0 && `DYNAMIC_RAM_TYPE !=6)? 
                             ctl_push_n & cr_push_reg_n & dmc_push_n :
                             sm_push_n & cr_push_reg_n & dmc_push_n; 
  

  assign miu_rd_data_out = (`DYNAMIC_RAM_TYPE ==6) ? miu_rd_data_reg :
                             !ctl_push_n ? s_rd_data :miu_rd_data_reg;
                                    
  
  assign miu_col_addr_width = (`DYNAMIC_RAM_TYPE !=6) ? cr_col_addr_width : 0;

  assign sdr_dwidth_const = `S_DATA_WIDTH == 16 ? 2'b00 : `S_DATA_WIDTH == 32 ?
                            2'b01 : `S_DATA_WIDTH == 64 ? 2'b10 : 2'b11;

  assign ddr_dwidth_const = `S_DATA_WIDTH == 8 ? 2'b00 : 
                            `S_DATA_WIDTH == 16 ? 2'b01:
                            `S_DATA_WIDTH == 32 ? 2'b10 : 2'b11;

  assign sdram_dwidth_const = (`DYNAMIC_RAM_TYPE ==6) ? ((`H_DATA_WIDTH==32) ?
                              2'b01 : (`H_DATA_WIDTH==64) ? 2'b10 :2'b11) :
                              ((`DYNAMIC_RAM_TYPE ==1) ? ddr_dwidth_const : 
                              sdr_dwidth_const);

  assign cr_sdram_dwidth = (`HARD_WIRE_SDRAM_PARAMETERS==1)? sdram_dwidth_const:
                           (`DYNAMIC_RAM_TYPE !=6) ? cr_sdram_data_width :
                           (`H_DATA_WIDTH==32) ? 2'b01 :
                           (`H_DATA_WIDTH==64) ? 2'b10 :2'b11;

  assign miu_data_width      = cr_sdram_dwidth;
  assign s_sel_n             = s_sel_n_int;
  assign sfctl_pdr_done_i    = (`DYNAMIC_RAM_TYPE ==2 || `DYNAMIC_RAM_TYPE ==4 
                               || `DYNAMIC_RAM_TYPE ==5) ? sfctl_pdr_done :1'b0;
  assign sfctl_clear_fl_op_i = (`DYNAMIC_RAM_TYPE ==2 || `DYNAMIC_RAM_TYPE ==4 
                               || `DYNAMIC_RAM_TYPE ==5) ? sfctl_clear_fl_op :1'b0;

  assign reg_req_i   = (`ENABLE_STATIC==1) ? (hiu_reg_req & !sm_access) : 
                                                             hiu_reg_req;
  assign sdram_req_i = (`ENABLE_STATIC==1) ? (ad_sdram_req & !sm_access) : 
                                                             ad_sdram_req;
  assign flash_pd_rp = smcr_set_flash_rp & !sm_power_down_r;

  // sm_data_width assignment depending on sm_timing_select

  assign sm_data_width_i = ad_timing_select == 0 ? smcr_data_width[2:0] :
                           ad_timing_select == 1 ? smcr_data_width[5:3] : 
                           smcr_data_width[8:6];

  assign smcr_smcr_selected_i = (`ENABLE_STATIC==1) ? smcr_smcr_selected : 1'b0;

  assign sm_chip_select_i = (`ENABLE_STATIC==1) ? sm_chip_select : {`N_CS{1'b1}};

  assign ctl_auto_ref_en  = ((`DYNAMIC_RAM_TYPE==2) || (`DYNAMIC_RAM_TYPE==6))?
                                                     1'b0 : ctl_auto_ref_en_i; 
  assign ctl_ext_mode_reg_done = ((`DYNAMIC_RAM_TYPE==2) || 
                                 (`DYNAMIC_RAM_TYPE==6))? 1'b0 : 
                                 ctl_ext_mode_reg_done_i;
  assign ctl_ref_ack = ((`DYNAMIC_RAM_TYPE == 2) || (`DYNAMIC_RAM_TYPE == 6)) ?
                                                        1'b0 : ctl_ref_ack_i;

  always@(posedge hclk or negedge hresetn)
  begin
   if (!hresetn) begin
      miu_rd_data_reg<=0;
      cr_push_reg_n  <=1'b1;
   end
   else begin
     if (`ENABLE_STATIC==0) begin
       miu_rd_data_reg <= cr_reg_data_out ;
       cr_push_reg_n <= cr_push_n ;
       end
     else begin
       miu_rd_data_reg <= (!cr_push_n) ? cr_reg_data_out :
                          (!smcr_push_n) ? smcr_rd_data_out :
                            sm_rd_data_out; 
       cr_push_reg_n <= cr_push_n & smcr_push_n;
     end
   end
  end
   
  always@(posedge hclk or negedge hresetn)
  begin
    if(!hresetn)
      sm_power_down_r <= 1'b0;
    else
      sm_power_down_r <= sm_power_down;
  end 

  always@(ad_sdram_type or ctl_chip_select or sm_chip_select_i)
  begin:COMB_PROC
    for(i=0;i<=`N_CS-1;i=i+1)
      s_sel_n_int[i]= ad_sdram_type[i] ? ctl_chip_select[i] : 
                      sm_chip_select_i[i];
  end


  // Instantiation of the SDRAM control  unit
  



 wire [4:0] dsdc_debug_access_ns, dsdc_debug_operation_ns;

  DW_memctl_miu_dsdc
    U_dsdc (
    .hclk                 (hclk),
    .hresetn              (hresetn),
    .hiu_req              (sdram_req_i),
    .hiu_rw               (hiu_rw),
    .hiu_burst_size       (hiu_burst_size),
    .hiu_wrapped_burst    (hiu_wrapped_burst),
    .hiu_terminate        (hiu_terminate),
    .miu_burst_done       (ctl_burst_done),
    .miu_pop_n            (ctl_pop_n),
    .miu_push_n           (ctl_push_n),
    .s_addr               (s_addr),
    .s_bank_addr          (s_bank_addr),
    .s_ras_n              (s_ras_n),
    .s_cas_n              (s_cas_n),
    .s_cs_n               (ctl_chip_select),
    .s_cke                (s_cke),
    .s_we_n               (s_we_n),
    .pre_dqm              (pre_dqm),
    .pre_dqs              (pre_dqs),
    .pre_amble            (pre_amble),
    .s_dout_valid         (s_dout_valid),
    .s_rd_ready           (s_rd_ready),
    .s_rd_start           (s_rd_start),
    .s_rd_pop             (s_rd_pop),
    .s_rd_end             (s_rd_end),
    .pre_rd_dqs_mask      (pre_rd_dqs_mask),
    .power_down           (power_down),
    .auto_ref_en          (ctl_auto_ref_en_i),
    .ref_req              (ref_ref_req),
    .ref_ack              (ctl_ref_ack_i),
    .chip_slct_n          (ad_sdram_chip_select),
    .bank_addr            (ad_bank_addr),
    .row_addr             (ad_row_addr),
    .col_addr             (ad_col_addr),
    .data_mask            (ad_data_mask),
    .s_row_addr_width     (cr_row_addr_width),
    .num_open_bank        (cr_num_open_banks),
    .extended_mode_reg    (cr_exn_mode_value),
    .s_ready_valid        (cr_s_ready_valid),
    .read_pipe            (cr_read_pipe),
    .t_cas_latency        (cr_cas_latency),
    .t_ras_min            (cr_t_ras_min),
    .t_rcd                (cr_t_rcd),
    .t_rp                 (cr_t_rp),
    .t_rc                 (cr_t_rc),
    .t_wr                 (cr_t_wr),
    .t_wtr                (cr_t_wtr),
    .t_rcar               (cr_t_rcar),
    .t_xsr                (cr_t_xsr),
    .t_init               (cr_t_init),
    .num_init_ref         (cr_num_init_ref),
    .initialize           (cr_do_initialize),
    .self_refresh_mode    (cr_do_self_ref_rp),
    .power_down_mode      (cr_do_power_down),
    .mode_reg_update      (cr_mode_reg_update),
    .ext_mode_reg_update  (cr_exn_mode_reg_update),
    .precharge_algorithm  (cr_delayed_precharge),
    .ref_all_before_sr    (cr_ref_all_before_sr),
    .ref_all_after_sr     (cr_ref_all_after_sr),
    .init_done            (ctl_init_done),
    .mode_reg_done        (ctl_mode_reg_done),
    .ext_mode_reg_done    (ctl_ext_mode_reg_done_i),
    .sd_in_sf_mode        (ctl_sd_in_sf_mode),
    .sdram_ebi_gnt        (s_ebi_gnt),
    .sdram_ebi_req        (s_ebi_req),
    .mobile_sdram_dpd_en  (mobile_sdram_dpd_en),
    .sd_in_dpd_mode       (sd_in_dpd_mode),
    .debug_access_ns      (dsdc_debug_access_ns),
    .debug_operation_ns   (dsdc_debug_operation_ns) 
  );


  // Instantiation of the DDR SDRAM write data, dqm and dqs generation unit

  DW_memctl_miu_ddrwr
   U_ddrwr (
    .hclk                 (hclk),
    .hresetn              (hresetn),
    .hclk_2x              (hclk_2x),
    .scan_mode            (scan_mode),
    .pre_dqm              (pre_dqm),
    .pre_dqs              (pre_dqs),
    .pre_amble            (pre_amble),
    .pre_rd_dqs_mask      (pre_rd_dqs_mask),
    .s_data_width         (cr_s_data_width_early),
    .cas_latency          (cr_cas_latency),
    .hiu_wr_data          (hiu_wr_data),
    .s_wr_data            (ddr_wr_data),
    .s_dqm                (s_dqm),
    .s_dqs                (s_dqs),
    .s_rd_dqs_mask        (s_rd_dqs_mask)
  ); 

  assign cr_sd_in_dpd_mode = sd_in_dpd_mode;




  assign cr_sf_in_dp_mode = 1'b0;
  assign ctl_sf_mode_reg_done = 1'b0;





  // Instantiation of the Control register Unit.



  DW_memctl_miu_cr
    U_cr (
   .hclk                  (hclk),          
   .hresetn               (hresetn),        
   .hiu_reg_req           (reg_req_i),       
   .hiu_rw                (hiu_rw),            
   .hiu_addr              ({hiu_addr[7:4],hiu_haddr[3:0]}),          
   .hiu_burst_size        (hiu_burst_size),
   .hiu_data_mask         (ad_cr_data_mask),
   .init_done             (ctl_init_done),         
   .sync_fl_pdr_done      (sfctl_pdr_done_i),
   .clear_self_ref_rp     (clear_sr_dp),
   .clear_sf_dp           (sf_clear_dp),
   .clear_fl_op           (sfctl_clear_fl_op_i),
   .mode_reg_done         (ctl_mode_reg_done),
   .exn_mode_reg_done     (ctl_ext_mode_reg_done),
   .big_endian            (big_endian),
   .smcr_selected         (smcr_smcr_selected_i),
   .hiu_wr_data           (hiu_wr_data),       
   .req_done              (cr_req_done),          
   .push_n                (cr_push_n),           
   .pop_n                 (cr_pop_n),            
   .do_self_ref_rp        (cr_do_self_ref_rp),   
   .do_initialize         (cr_do_initialize),   
   .do_power_down         (cr_do_power_down),
   .delayed_precharge     (cr_delayed_precharge), 
   .ref_all_before_sr     (cr_ref_all_before_sr),
   .ref_all_after_sr      (cr_ref_all_after_sr),
   .row_addr_width        (cr_row_addr_width),  
   .col_addr_width        (cr_col_addr_width),  
   .bank_addr_width       (cr_bank_addr_width), 
   .sf_row_addr_width     (cr_sf_row_addr_width),
   .sf_col_addr_width     (cr_sf_col_addr_width),
   .sf_bank_addr_width    (cr_sf_bank_addr_width),
   .sdram_data_width      (cr_sdram_data_width),
   .s_data_width_early    (cr_s_data_width_early),
   .mask_reg0             (cr_block_size1),      
   .mask_reg1             (cr_block_size2),      
   .mask_reg2             (cr_block_size3),      
   .mask_reg3             (cr_block_size4),      
   .mask_reg4             (cr_block_size5),      
   .mask_reg5             (cr_block_size6),      
   .mask_reg6             (cr_block_size7),      
   .mask_reg7             (cr_block_size8),      
   .cas_latency           (cr_cas_latency),     
   .t_ras_min             (cr_t_ras_min),       
   .t_rcd                 (cr_t_rcd),           
   .t_rp                  (cr_t_rp),            
   .t_wr                  (cr_t_wr),            
   .t_rcar                (cr_t_rcar), 
   .t_xsr                 (cr_t_xsr),  
   .t_init                (cr_t_init), 
   .num_init_ref          (cr_num_init_ref),
   .t_rc                  (cr_t_rc), 
   .t_ref                 (cr_t_ref),
   .chipsel_register0     (cr_scslr1),
   .chipsel_register1     (cr_scslr2),
   .chipsel_register2     (cr_scslr3),
   .chipsel_register3     (cr_scslr4),
   .chipsel_register4     (cr_scslr5),
   .chipsel_register5     (cr_scslr6),
   .chipsel_register6     (cr_scslr7),
   .chipsel_register7     (cr_scslr8),
   .alias_register0       (cr_alias_reg0),
   .alias_register1       (cr_alias_reg1),
   .remap_register0       (cr_remap_reg0),
   .remap_register1       (cr_remap_reg1),
   .s_sa                  (s_sa),
   .s_scl                 (s_scl),
   .s_sda_in              (s_sda_in),
   .s_sda_out             (s_sda_out),
   .s_sda_oe_n            (s_sda_oe_n),
   .read_pipe             (cr_read_pipe),
   .mode_reg_update       (cr_mode_reg_update),
   .software_sequence     (cr_software_sequence),
   .sd_in_sf_mode         (ctl_sd_in_sf_mode),
   .sf_trpdr              (cr_sf_trpdr),
   .exn_mode_value        (cr_exn_mode_value),
   .exn_mode_reg_update   (cr_exn_mode_reg_update),
   .operation_code        (cr_operation_code),
   .flash_operation       (cr_flash_operation),
   .num_open_banks        (cr_num_open_banks),
   .s_ready_valid         (cr_s_ready_valid),
   .t_wtr                 (cr_t_wtr),
   .gpi                   (gpi),
   .gpo                   (gpo),
   .sf_t_rcd              (cr_sf_t_rcd),
   .sf_cas_latency        (cr_sf_cas_latency),
   .sf_t_rc               (cr_sf_t_rc),
   .do_sf_power_down      (cr_do_sf_power_down),
   .do_sf_deep_pwr_dn     (cr_do_sf_dp),
   .sf_in_dp_mode         (cr_sf_in_dp_mode),
   .sf_mode_reg_update    (cr_sf_mode_reg_update),
   .sf_mode_reg_done      (ctl_sf_mode_reg_done),
   .wr_data2_smcr         (cr_wr_data2_smcr),
   .mask2_smcr            (cr_mask2_smcr),
   .rd_data_out           (cr_reg_data_out),
   .mobile_sdram_dpd_en   (mobile_sdram_dpd_en),
   .sd_in_dpd_mode        (cr_sd_in_dpd_mode)
  );

  
  // Instantiation of the Address decoder Unit.

  DW_memctl_miu_addrdec
   U_addrdec (
    .hclk                 (hclk),          
    .hresetn              (hresetn),        
    .hiu_mem_req          (hiu_mem_req),
    .h_addr               (hiu_addr),                   
    .col_addr_width_prog  (cr_col_addr_width),      
    .hiu_haddr            (hiu_haddr),
    .hiu_hsize            (hiu_hsize),
    .row_addr_width_prog  (cr_row_addr_width),      
    .bank_addr_width_prog (cr_bank_addr_width),     
    .sf_bank_addr_width_prog (cr_sf_bank_addr_width),
    .sf_row_addr_width_prog  (cr_sf_row_addr_width),
    .sf_col_addr_width_prog  (cr_sf_col_addr_width),
    .s_data_width_prog    (cr_sdram_dwidth),        
    .big_endian           (big_endian),
    .sm_data_width_prog   (sm_data_width_i),        
    .mem_block_size0      (cr_block_size1),           
    .mem_block_size1      (cr_block_size2),           
    .mem_block_size2      (cr_block_size3),           
    .mem_block_size3      (cr_block_size4),           
    .mem_block_size4      (cr_block_size5),           
    .mem_block_size5      (cr_block_size6),           
    .mem_block_size6      (cr_block_size7),           
    .mem_block_size7      (cr_block_size8),           
    .chip_sel_reg0        ({cr_scslr1, 5'b0}),            
    .chip_sel_reg1        ({cr_scslr2, 5'b0}),            
    .chip_sel_reg2        ({cr_scslr3, 5'b0}),            
    .chip_sel_reg3        ({cr_scslr4, 5'b0}),            
    .chip_sel_reg4        ({cr_scslr5, 5'b0}),            
    .chip_sel_reg5        ({cr_scslr6, 5'b0}),            
    .chip_sel_reg6        ({cr_scslr7, 5'b0}),            
    .chip_sel_reg7        ({cr_scslr8, 5'b0}),            
    .alias_reg0           ({cr_alias_reg0, 5'b0}),
    .alias_reg1           ({cr_alias_reg1, 5'b0}),
    .remap_reg0           ({cr_remap_reg0, 5'b0}),
    .remap_reg1           ({cr_remap_reg1, 5'b0}),
    .row_addr             (ad_row_addr),                 
    .col_addr             (ad_col_addr),                 
    .bank_addr            (ad_bank_addr),                
    .sf_row_addr          (ad_sf_row_addr),
    .sf_col_addr          (ad_sf_col_addr),
    .sf_bank_addr         (ad_sf_bank_addr),
    .sm_addr              (ad_sm_addr),
    .sm_timing_select     (ad_timing_select),
    .sdram_req            (ad_sdram_req),
    .syncflash_req        (ad_syncflash_req),
    .static_mem_req       (ad_static_mem_req),
    .do_initialize        (cr_do_initialize),
    .flash_access         (ad_flash_access),
    .sdram_chip_select    (ad_sdram_chip_select),
    .syncflash_chip_select (ad_syncflash_chip_select),
    .sdram_select         (sdram_select),
    .syncflash_select     (syncflash_select),
    .remap                (remap),
    .sdram_type           (ad_sdram_type),
    .data_mask            (ad_data_mask),
    .cr_data_mask         (ad_cr_data_mask),
    .static_chip_select   (ad_static_chip_select)     
  ); 


  DW_memctl_miu_refctl
   U_refctl (
    .clk                  (hclk),                 
    .hresetn              (hresetn),  
    .auto_refresh_en      (ctl_auto_ref_en),   
    .ref_ack              (ctl_ref_ack),             
    .t_ref                (cr_t_ref), 
    .ref_req              (ref_ref_req) 
  ); 


   assign debug_ref_req = ref_ref_req;
   






  DW_memctl_miu_dmc
   U_dmc (
    .hclk                 (hclk),
    .hresetn              (hresetn),
    .hiu_req              (hiu_dummy_req),
    .hiu_rw               (hiu_rw),
    .hiu_burst_size       (hiu_burst_size),
    .hiu_wrapped_burst    (hiu_wrapped_burst),
    .hiu_terminate        (hiu_terminate),
    .miu_burst_done       (dmc_burst_done),
    .miu_pop_n            (dmc_pop_n),
    .miu_push_n           (dmc_push_n)
   );


  endmodule 







