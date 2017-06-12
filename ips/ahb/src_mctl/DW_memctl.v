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
// Abstract  : DW_memctl top module.
//
// Please refer to the databook for full details on the signals.
//
// These are found in the "Signal Description" section of the "Signals" chapter.
// There are details on the following
//   % Input Delays
//   % Output Delays
//   Any False Paths
//   Any Multicycle Paths
//   Any Asynchronous Signals
//
//============================================================================
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl( 


  /*AUTOARG*/
  // Outputs
  hready_resp, 
                 hresp, 
                 hrdata, 
                 s_ras_n, 
                 s_cas_n, 
                 s_cke, 
                 s_wr_data, 
                 s_addr, 
                 s_bank_addr, 
                 s_dout_valid, 
                 s_sel_n, 
                 s_dqm, 
                 s_we_n, 
                 s_dqs, 
                 s_sa, 
                 s_scl, 
                 s_rd_ready, 
                 s_rd_start, 
                 s_rd_pop, 
                 s_rd_end, 
                 s_rd_dqs_mask, 
                 s_cas_latency, 
                 s_read_pipe, 
                 s_sda_out, 
                 s_sda_oe_n, 
                 gpo,
                 debug_ad_bank_addr,
                 debug_ad_row_addr,
                 debug_ad_col_addr,
                 debug_ad_sf_bank_addr,
                 debug_ad_sf_row_addr, 
                 debug_ad_sf_col_addr,
                 debug_hiu_addr,
                 debug_sm_burst_done,
                 debug_sm_pop_n,
                 debug_sm_push_n,
                 debug_smc_cs,
                 debug_ref_req,                  
                 // Inputs
                 hclk, 
                 hclk_2x, 
                 hresetn, 
                 scan_mode, 
                 haddr, 
                 hsel_mem, 
                 hsel_reg, 
                 hwrite, 
                 htrans,
                 hsize, 
                 hburst, 
                 hready, 
                 hwdata, 
                 s_rd_data, 
                 s_sda_in, 
                 gpi, 
                 remap, 
                 power_down, 
                 clear_sr_dp,  
                 big_endian
                 ); 


  input                                 hclk;         // System Clock
  input                                 hclk_2x;      // 2x Clock for DDR
  input                                 hresetn;      // System Reset
  input                                 scan_mode;    // Test Mode
  input  [`H_ADDR_WIDTH-1:0]            haddr;        // AHB Address Bus
  input                                 hsel_mem;     // AHB Select - Memory
  input                                 hsel_reg;     // AHB Select - Register
  input                                 hwrite;       // AHB Transfer Direction
  input  [1:0]                          htrans;       // AHB Transfer Type
  input  [2:0]                          hsize;        // AHB Transfer Size
  input  [2:0]                          hburst;       // AHB Burst Type
  output                                hready_resp;  // AHB Transfer Done - Out
  input                                 hready;       // AHB Transfer Done - In
  output [1:0]                          hresp;        // AHB Transfer Response
  input  [`H_DATA_WIDTH-1:0]            hwdata;       // AHB Write Data
  output [`H_DATA_WIDTH-1:0]            hrdata;       // AHB Read Data
  output                                s_ras_n;      // SDRAM row addr. select
  output                                s_cas_n;      // SDRAM column addr. sel
  output                                s_cke;        // SDRAM clock enable
  input  [`S_RD_DATA_WIDTH-1:0]         s_rd_data;    // SDRAM read data
  output [`MAX_S_DATA_WIDTH-1:0]        s_wr_data;    // SDRAM write data
  output [`MAX_S_ADDR_WIDTH-1:0]        s_addr;       // SDRAM address
  output [`MAX_S_BANK_ADDR_WIDTH-1:0]   s_bank_addr;  // SDRAM bank address
  output [`MAX_S_DATA_WIDTH/8-1:0]      s_dout_valid; // SDRAM chip select
  output [`N_CS-1:0]                    s_sel_n;      // SDRAM chip select
  output [`MAX_S_DATA_WIDTH/8-1:0]      s_dqm;        // SDRAM data mask
  output [`NUM_DQS-1 :0]                s_dqs;        // Data strobe to SDRAM
  output                                s_we_n;       // SDRAM write enable  
  input                                 s_rd_ready;   // Data ready signal
  output                                s_rd_start;   // Read burst start
  output                                s_rd_pop;     // Data pop signal for 
                                                      // read data capture
  output                                s_rd_end;     // Read burst end
  output                                s_rd_dqs_mask;// Read dqs mask
  output [2:0]                          s_cas_latency;// SDRAM cas latency
  output [2:0]                          s_read_pipe;  // read pipe
  output [2:0]                          s_sa;         // Serial Presence Address
  output                                s_scl;        // Serial Presence Clock
  output                                s_sda_out;    // Serial Presence Data Out
  output                                s_sda_oe_n;   // Serial Presence Data Ena
  input                                 s_sda_in;     // Serial Presence Data In
                                                      // SyncFlash


                                                      // freq Synchronous flash
                                                      // Synchronous Flash

  input                                 remap;        // Address remap control in
  input                                 power_down;   // External power down in
  input                                 clear_sr_dp;  // clear the self_ref_rp bit
  input                                 big_endian;   // Endiansess control
  input [7:0]                           gpi;          // general purpose inputs
  output [7:0]                          gpo;          // general purpose outputs

  // Debug signals for testing / not to be connected
  output [`MAX_S_BANK_ADDR_WIDTH-1:0]   debug_ad_bank_addr;
  output [`MAX_S_ADDR_WIDTH-1:0]        debug_ad_row_addr;
  output [`MAX_S_ADDR_WIDTH-1:0]        debug_ad_col_addr;
  output [`MAX_S_BANK_ADDR_WIDTH-1:0]   debug_ad_sf_bank_addr;
  output [`MAX_S_ADDR_WIDTH-1:0]        debug_ad_sf_row_addr;
  output [`MAX_S_ADDR_WIDTH-1:0]        debug_ad_sf_col_addr;
  output [`H_ADDR_WIDTH-1:0]            debug_hiu_addr;
  output                                debug_sm_burst_done;
  output                                debug_sm_pop_n;
  output                                debug_sm_push_n;
  output [3:0]                          debug_smc_cs;
  output                                debug_ref_req;   

  // Internal Wires/Regs

  wire [1:0]                            hiu_req;
  wire                                  miu_burst_done;
  wire [`H_ADDR_WIDTH-1:0]              hiu_addr;
  wire [5:0]                            hiu_burst_size;
  wire                                  hiu_wrap_burst;
  wire                                  hiu_rw;
  wire [3:0]                            miu_col_width;
  wire [1:0]                            miu_data_width;

  wire [`S_RD_DATA_WIDTH-1:0]           hiu_data;
  wire                                  hiu_terminate;
  wire [3:0]                            hiu_haddr;
  wire [2:0]                            hiu_hsize;
  wire                                  miu_pop_n;

  wire [`S_RD_DATA_WIDTH-1:0]           miu_data;
  wire                                  miu_push_n;
  wire [`S_RD_DATA_WIDTH-1:0]           s_rd_data_int;
  wire [`MAX_SM_DATA_WIDTH-1:0]         sm_rd_data_int;
  wire                    [2:0]         sm_data_width_set0;
  wire [`M_DATA_WIDTH-1:0]              m_rd_data;
  wire [`M_DATA_WIDTH-1:0]              m_wr_data;
  wire                                  sm_access;
  wire [`S_RD_DATA_WIDTH-1:0]           s_rd_data;
  wire [`MAX_SM_DATA_WIDTH-1:0]         sm_rd_data;
  wire [`M_ADDR_WIDTH-1:0]              m_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0]          s_addr;
  wire                                  m_precharge_bit;
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0  ]   s_bank_addr;
  wire [2:0]                            s_sa;
  wire [`MAX_SM_ADDR_WIDTH-1:0]         sm_addr;
  wire [`MAX_SM_DATA_WIDTH/8-1:0]       sm_bs_n;
  wire [`MAX_SM_DATA_WIDTH-1:0]         sm_wr_data;
  wire [2:0]                            sm_wp_n;
  wire [`M_DATA_WIDTH/8-1:0]            m_dout_valid;
  wire [`MAX_SM_DATA_WIDTH/8-1:0]       sm_dout_valid;
  wire [`MAX_S_DATA_WIDTH/8-1:0]        s_dout_valid;
  wire [`NUM_DQS-1 :0]                  s_dqs;
  wire [`MAX_S_DATA_WIDTH/8-1:0]        s_dqm;
  wire [`MAX_S_DATA_WIDTH-1:0]          s_wr_data;
  wire [2:0]                            s_cas_latency;
  wire                                  power_down;
  wire                                  sf_power_down;
  wire                                  sm_power_down;
  wire                                  clear_sr_dp;
  wire                                  sf_clear_dp;
  wire                                  power_down_tmp;
  wire                                  sm_power_down_tmp;
  wire                                  sf_power_down_tmp;
  wire                                  clear_sr_dp_tmp;
  wire                                  sf_clear_dp_tmp;
  wire                                  scan_mode;
  wire                                  s_ebi_gnt;
  wire                                  sm_ebi_gnt;
  wire                                  s_ebi_gnt_int;
  wire                                  sm_ebi_gnt_int;
  wire [2:0]                            s_read_pipe;
  wire [2:0]                            sf_cas_latency;
  wire                                  hclk_2x;
  wire                                  sm_clken;
  wire                                  sm_ready;
  wire                                  s_sda_in;
  wire                                  s_rd_ready;
   
  // Debug signals
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0]     debug_ad_bank_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0]          debug_ad_row_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0]          debug_ad_col_addr;
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0]     debug_ad_sf_bank_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0]          debug_ad_sf_row_addr;
  wire [`MAX_S_ADDR_WIDTH-1:0]          debug_ad_sf_col_addr;  
  wire [`H_ADDR_WIDTH-1:0]              debug_hiu_addr;  
  wire                                  debug_sm_burst_done;
  wire                                  debug_sm_pop_n;
  wire                                  debug_sm_push_n;
  wire [3:0]                            debug_smc_cs;
  wire                                  debug_ref_req;
   
  //a registered reset.
  reg hresetn_r;
  
  assign debug_hiu_addr    = hiu_addr;

  assign s_rd_data_int     = (`ENABLE_DATABUS_SHARING) ? m_rd_data : s_rd_data;
  assign sm_rd_data_int    = (`ENABLE_DATABUS_SHARING) ? m_rd_data :sm_rd_data;
  assign sm_power_down_tmp = (`ENABLE_STATIC)? sm_power_down : 1'b0;
  assign power_down_tmp    = (`DYNAMIC_RAM_TYPE==6)? 1'b0 : power_down;
  assign sf_power_down_tmp = 1'b0;
  assign clear_sr_dp_tmp   = (`DYNAMIC_RAM_TYPE==6)? 1'b0 : clear_sr_dp;
  assign sf_clear_dp_tmp   = 1'b0;
  assign s_ebi_gnt_int     = (`EBI_INTERFACE && `DYNAMIC_RAM_TYPE!=6) ? s_ebi_gnt : 1'b0;
  assign sm_ebi_gnt_int    = (`EBI_INTERFACE && `ENABLE_STATIC) ? sm_ebi_gnt : 1'b0;


  DW_memctl_hiu
   U_hiu(
    // Outputs
    .hready_resp              (hready_resp),
    .hresp                    (hresp[1:0]),
    .hrdata                   (hrdata[`H_DATA_WIDTH-1:0]),
    .hiu_req                  (hiu_req),
    .hiu_addr                 (hiu_addr[`H_ADDR_WIDTH-1:0]),
    .hiu_burst_size           (hiu_burst_size[5:0]),
    .hiu_wrap_burst           (hiu_wrap_burst),
    .hiu_rw                   (hiu_rw),
    .hiu_data                 (hiu_data[`S_RD_DATA_WIDTH-1:0]),
    .hiu_terminate            (hiu_terminate),
    .hiu_haddr                (hiu_haddr),
    .hiu_hsize                (hiu_hsize),
    // Inputs
    .hclk                     (hclk),
    .hresetn                  (hresetn),
    .haddr                    (haddr[`H_ADDR_WIDTH-1:0]),
    .hsel_mem                 (hsel_mem),
    .hsel_reg                 (hsel_reg),
    .hwrite                   (hwrite),
    .htrans                   (htrans[1:0]),
    .hsize                    (hsize[2:0]),
    .hburst                   (hburst[2:0]),
    .hready                   (hready),
    .hwdata                   (hwdata[`H_DATA_WIDTH-1:0]),
    .miu_burst_done           (miu_burst_done),
    .miu_col_width            (miu_col_width[3:0]),
    .miu_data_width           (miu_data_width[1:0]),
    .miu_pop_n                (miu_pop_n),
    .miu_data                 (miu_data[`S_RD_DATA_WIDTH-1:0]),
    .miu_push_n               (miu_push_n),
    .big_endian               (big_endian));       

  DW_memctl_miu
   U_miu(
    // Outputs
    .miu_burst_done           (miu_burst_done),
    .miu_pop_n                (miu_pop_n),
    .miu_push_n               (miu_push_n),
    .miu_rd_data_out          (miu_data[`S_RD_DATA_WIDTH-1:0]),
    .miu_col_addr_width       (miu_col_width[3:0]),
    .miu_data_width           (miu_data_width[1:0]),
    .m_addr                   (m_addr[`M_ADDR_WIDTH-1:0]),
    .s_addr                   (s_addr[`MAX_S_ADDR_WIDTH-1:0]),
    .s_bank_addr              (s_bank_addr[`MAX_S_BANK_ADDR_WIDTH-1:0]),
    .s_ras_n                  (s_ras_n),
    .s_cas_n                  (s_cas_n),
    .s_sel_n                  (s_sel_n[`N_CS-1:0]),
    .s_cke                    (s_cke),
    .sf_cke                   (sf_cke),
    .s_we_n                   (s_we_n),
    .s_wr_data                (s_wr_data),
    .s_dqm                    (s_dqm),
    .s_dqs                    (s_dqs),
    .s_dout_valid             (s_dout_valid),
    .s_rd_start               (s_rd_start),
    .s_rd_pop                 (s_rd_pop),
    .s_rd_end                 (s_rd_end),
    .s_rd_dqs_mask            (s_rd_dqs_mask),
    .s_cas_latency            (s_cas_latency),
    .s_read_pipe              (s_read_pipe),
    .sf_cas_latency           (sf_cas_latency),
    .s_sa                     (s_sa[2:0]),
    .s_scl                    (s_scl),
    .s_rp_n                   (s_rp_n),
    .sm_adv_n                 (sm_adv_n),
    .sm_addr                  (sm_addr[`MAX_SM_ADDR_WIDTH-1:0]),
    .sm_oe_n                  (sm_oe_n),
    .sm_we_n                  (sm_we_n),
    .sm_bs_n                  (sm_bs_n[`MAX_SM_DATA_WIDTH/8-1:0]),
    .sm_dout_valid            (sm_dout_valid),
    .sm_rp_n                  (sm_rp_n),
    .sm_wp_n                  (sm_wp_n),
    .sm_wr_data               (sm_wr_data[`MAX_SM_DATA_WIDTH-1:0]),
    .sm_access                (sm_access),
    .s_ebi_req                (s_ebi_req),
    .sm_ebi_req               (sm_ebi_req),
    .m_dout_valid             (m_dout_valid),
    .m_wr_data                (m_wr_data),
    .m_precharge_bit          (m_precharge_bit),
    .debug_ad_bank_addr       (debug_ad_bank_addr[`MAX_S_BANK_ADDR_WIDTH-1:0]),
    .debug_ad_row_addr        (debug_ad_row_addr[`MAX_S_ADDR_WIDTH-1:0]),
    .debug_ad_col_addr        (debug_ad_col_addr[`MAX_S_ADDR_WIDTH-1:0]),
    .debug_ad_sf_bank_addr    (debug_ad_sf_bank_addr[`MAX_S_BANK_ADDR_WIDTH-1:0]),
    .debug_ad_sf_row_addr     (debug_ad_sf_row_addr[`MAX_S_ADDR_WIDTH-1:0]),
    .debug_ad_sf_col_addr     (debug_ad_sf_col_addr[`MAX_S_ADDR_WIDTH-1:0]),
    .debug_sm_burst_done      (debug_sm_burst_done),
    .debug_sm_pop_n           (debug_sm_pop_n),
    .debug_sm_push_n          (debug_sm_push_n),
    .debug_smc_cs             (debug_smc_cs[3:0]),
    .debug_ref_req            (debug_ref_req),
    // Inputs
    .hclk                     (hclk),
    .hclk_2x                  (hclk_2x),
    .hresetn                  (hresetn),
    .scan_mode                (scan_mode),
    .hiu_mem_req              (hiu_req[1]),
    .hiu_reg_req              (hiu_req[0]),
    .hiu_rw                   (hiu_rw),
    .hiu_addr                 (hiu_addr[`H_ADDR_WIDTH-1:0]),
    .hiu_burst_size           (hiu_burst_size[5:0]),
    .hiu_wrapped_burst        (hiu_wrap_burst),
    .hiu_terminate            (hiu_terminate),
    .hiu_haddr                (hiu_haddr),
    .hiu_hsize                (hiu_hsize),
    .hiu_wr_data              (hiu_data[`S_RD_DATA_WIDTH-1:0]),
    .s_rd_data                (s_rd_data_int[`S_RD_DATA_WIDTH-1:0]),
    .s_rd_ready               (s_rd_ready), 
    .s_sda_out                (s_sda_out),
    .s_sda_in                 (s_sda_in),
    .s_sda_oe_n               (s_sda_oe_n),
    .remap                    (remap),
    .sm_clken                 (sm_clken),
    .sm_ready                 (sm_ready),
    .sm_data_width_set0       (sm_data_width_set0),
    .sm_rd_data               (sm_rd_data_int[`MAX_SM_DATA_WIDTH-1:0]),
    .s_ebi_gnt                (s_ebi_gnt_int),
    .sm_ebi_gnt               (sm_ebi_gnt_int),
    .power_down               (power_down_tmp),
    .sf_power_down            (sf_power_down_tmp),
    .sm_power_down            (sm_power_down_tmp),
    .clear_sr_dp              (clear_sr_dp_tmp),
    .sf_clear_dp              (sf_clear_dp_tmp),
    .big_endian               (big_endian),
    .gpi                      (gpi),
    .gpo                      (gpo));


  // ****** DW_memctl Checkers - START ******** 

  // synopsys translate_off
  // synopsys translate_on

  // ****** DW_memctl Checkers - END ******** 


endmodule 

