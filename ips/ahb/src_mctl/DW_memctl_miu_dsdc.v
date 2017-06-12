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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_miu_dsdc.v $ 
// $Revision: #5 $
//
// Abstract  : This module is a subblock  of  the  DW_memctl_miu. It receives
// DDR SDRAM access requests from the HIU and generates appropriate control 
// signals  to the DDR SDRAM. It also  controls  the SDRAM initialization,
// auto refresh,  self refresh  and power down.
//
//============================================================================
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl_miu_dsdc(hclk,
                          hresetn,
                          hiu_req,
                          hiu_rw,
                          hiu_burst_size,
                          hiu_wrapped_burst,
                          hiu_terminate,
                          miu_burst_done,
                          miu_pop_n,
                          miu_push_n,
                          s_addr,
                          s_bank_addr,
                          s_ras_n,
                          s_cas_n,
                          s_cs_n,
                          s_cke,
                          s_we_n,
                          pre_dqm,
                          pre_dqs,
                          pre_amble,
                          s_dout_valid,
                          s_rd_ready,
                          s_rd_start,
                          s_rd_pop,
                          s_rd_end,
                          pre_rd_dqs_mask,
                          power_down,
                          auto_ref_en,
                          ref_req,
                          ref_ack,
                          chip_slct_n,
                          bank_addr,
                          row_addr,
                          col_addr,
                          data_mask,
                          s_row_addr_width,
                          num_open_bank,
                          extended_mode_reg,
                          s_ready_valid,
                          read_pipe,
                          t_cas_latency,
                          t_ras_min,
                          t_rcd,
                          t_rp,
                          t_rc,
                          t_wr,
                          t_wtr,
                          t_rcar,
                          t_xsr,
                          t_init,
                          num_init_ref,
                          initialize,
                          self_refresh_mode,
                          power_down_mode,
                          mode_reg_update,
                          ext_mode_reg_update,
                          precharge_algorithm,
                          ref_all_before_sr,
                          ref_all_after_sr,
                          init_done,
                          mode_reg_done,
                          ext_mode_reg_done,
                          sd_in_sf_mode,
                          sdram_ebi_req,
                          sdram_ebi_gnt,
                          mobile_sdram_dpd_en,
                          sd_in_dpd_mode,
                          debug_access_ns,
                          debug_operation_ns
);

  parameter DATA_WIDTH_BYTE  = `MAX_S_DATA_WIDTH / 4;
  parameter MAX_NUM_BANK     = 1 << `MAX_S_BANK_ADDR_WIDTH;

  input                               hclk;
  input                               hresetn;
 
  // interface with HIU
  input                               hiu_req;           // transfer request
  input                               hiu_rw;            // read/write
  input [5:0]                         hiu_burst_size;    // burst size
  input                               hiu_wrapped_burst; // wrapped burst
  input                               hiu_terminate;     // terminate
  output                              miu_burst_done;    // burst done
  output                              miu_pop_n;         // pop data from HIU
  output                              miu_push_n;        // push data to HIU
 
  // interface with DDR SDRAM
  output [`MAX_S_ADDR_WIDTH-1:0]      s_addr;            // row/col addr
  output [`MAX_S_BANK_ADDR_WIDTH-1:0] s_bank_addr;       // bank addr
  output                              s_ras_n;           // row addr strobe
  output                              s_cas_n;           // col addr strobe
  output [`N_CS-1:0]                  s_cs_n;            // chip select
  output                              s_cke;             // clock enable
  output                              s_we_n;            // write enable
  output [DATA_WIDTH_BYTE-1:0]        pre_dqm;           // data mask
  output                              pre_dqs;           // data strobe 
  output                              pre_amble;         // write preamble
  output [`MAX_S_DATA_WIDTH/8-1:0]    s_dout_valid;      // data out valid
 
  // interface with read data capture unit
  input                               s_rd_ready;        // data ready
  output                              s_rd_start;        // read burst start
  output                              s_rd_pop;          // data pop signal
  output                              s_rd_end;          // read burst end
  output                              pre_rd_dqs_mask;   // mask for read dqs 

  // external input pins
  input                               power_down;        // power down request

  // interface with refctl
  output                              auto_ref_en;       // auto ref enable
  input                               ref_req;           // refresh request
  output                              ref_ack;           // ref acknowledge
 
  // interface with addrdec
  input [`N_CS-1:0]                   chip_slct_n;       // chip select
  input [`MAX_S_BANK_ADDR_WIDTH-1:0]  bank_addr;         // bank address
  input [`MAX_S_ADDR_WIDTH-1:0]       row_addr;          // row address
  input [`MAX_S_ADDR_WIDTH-1:0]       col_addr;          // column address
  input [`H_DATA_WIDTH/8-1:0]         data_mask;         // data mask

  // interface with miu_reg
  input [3:0]                         s_row_addr_width;  // row addr width
  input [4:0]                         num_open_bank;     // No. of open bank 
  input [12:0]                        extended_mode_reg; // extended mode reg
  input                               s_ready_valid;     // using ready signal 
  input [2:0]                         read_pipe;         // delay in clk cycles
                                                         // on read data path
  input [2:0]                         t_cas_latency;     // cas latency.
  input [3:0]                         t_ras_min;         // minimum active to
                                                         // precharge time
  input [2:0]                         t_rcd;             // RAS to CAS delay
  input [2:0]                         t_rp;              // precharge period
  input [3:0]                         t_rc;              // same bank active
                                                         // to active delay
  input [1:0]                         t_wr;              // data in to
                                                         // precharge delay
  input [1:0]                         t_wtr;             // wr to rd delay
  input [3:0]                         t_rcar;            // auto ref period
  input [8:0]                         t_xsr;             // exit self ref time
  input [15:0]                        t_init;            // time to hold SDRAM
                                                         // inputs stable
                                                         // after power on
  input [3:0]                         num_init_ref;      // No. of auto
                                                         // refreshes during
                                                         // initialization
  input                               initialize;        // initialize request
  input                               self_refresh_mode; // self ref request
  input                               power_down_mode;   // power down req
  input                               mode_reg_update;   // update mode reg 
  input                               ext_mode_reg_update;
  input                               precharge_algorithm;
  input                               ref_all_before_sr;
  input                               ref_all_after_sr;
  input                               mobile_sdram_dpd_en; // Mobile DDR Deep
                                                           // Power Down (DPD)
                                                           // enable.
  output                              init_done;         // init finished
  output                              mode_reg_done;     // mode reg updated
  output                              ext_mode_reg_done; // extended mode reg
                                                         // updated 
  output                              sd_in_sf_mode;     // SDRAM in self ref

  // interface with EBI
  input                               sdram_ebi_gnt;     // EBI grant
  output                              sdram_ebi_req;     // EBI request
   
  // Mobile-DDR specific
  output                              sd_in_dpd_mode;    // DPD status

 // debug interface
  output [4:0]                        debug_access_ns;
  output [4:0]                        debug_operation_ns;    

  // registers for outputs to SDRAM
  reg                                 s_cke;             // clock enable
  reg                                 s_cke_nxt;
  reg [`MAX_S_ADDR_WIDTH-1:0]         s_addr;            // row/col addr
  reg [`MAX_S_ADDR_WIDTH-1:0]         s_addr_nxt_o;     
  reg [`MAX_S_ADDR_WIDTH-1:0]         s_addr_nxt_a;  
  reg [`MAX_S_BANK_ADDR_WIDTH-1:0]    s_bank_addr;       // bank addr
  reg [`MAX_S_BANK_ADDR_WIDTH-1:0]    s_bank_addr_nxt_o; 
  reg [`MAX_S_BANK_ADDR_WIDTH-1:0]    s_bank_addr_nxt_a; 
  reg [`N_CS-1 : 0]                   s_cs_n;            // chip select
  reg [`N_CS-1 : 0]                   s_cs_nxt_o;       
  reg [`N_CS-1 : 0]                   s_cs_nxt_a;       
  reg [DATA_WIDTH_BYTE-1:0]           pre_dqm;           // data mask
  reg [DATA_WIDTH_BYTE-1:0]           s_dqm_nxt;             
  reg                                 pre_amble;         // write preamble
  reg                                 pre_amble_nxt;
  reg                                 s_ras_n;           // row addr strobe
  reg                                 s_ras_nxt_o;
  reg                                 s_ras_nxt_a;
  reg                                 s_cas_n;           // col addr strobe
  reg                                 s_cas_nxt_o;
  reg                                 s_cas_nxt_a;
  reg                                 s_we_n;            // write enable
  reg                                 s_we_nxt_o;
  reg                                 s_we_nxt_a;
  reg [`MAX_S_DATA_WIDTH/8-1:0]       s_dout_valid;      // data output valid
  reg                                 s_dout_valid_nxt;

  // registers for outputs to read data capture unit
  reg                                 s_rd_start;
  reg                                 s_rd_start_nxt;
  reg                                 s_rd_pop;
  reg                                 s_rd_end;
  reg                                 s_rd_end_nxt;
  reg                                 pre_rd_dqs_mask; 

  // registers for outputs to HIU
  reg                                 miu_pop_n;         // write data enable
  reg                                 miu_pop_n_nxt;
  reg                                 miu_push_n;        // read data enable
  reg                                 miu_push_n_nxt;
  reg                                 burst_done;
 
  // registers for outputs to MIU_refctl
  reg                                 auto_ref_en;       // auto ref enable
  reg                                 auto_ref_en_nxt;
  reg                                 ref_ack;           // refresh ack
  reg                                 ref_ack_nxt_o;
  reg                                 ref_ack_nxt_a;
 
  // registered input signals 
  reg [`N_CS-1:0]                     r_chip_slct;
  reg [`N_CS-1:0]                     r_chip_slct_nxt;
  reg [`MAX_S_BANK_ADDR_WIDTH-1:0]    r_bank_addr;
  reg [`MAX_S_BANK_ADDR_WIDTH-1:0]    r_bank_addr_nxt;
  reg [`MAX_S_ADDR_WIDTH-1:0]         r_row_addr;
  reg [`MAX_S_ADDR_WIDTH-1:0]         r_row_addr_nxt;
  reg [`MAX_S_ADDR_WIDTH-1:0]         r_col_addr;
  reg [`MAX_S_ADDR_WIDTH-1:0]         r_col_addr_nxt;
  reg                                 r_rw;
  reg                                 r_rw_nxt;
  reg [5:0]                           r_burst_size;
  reg [5:0]                           r_burst_size_nxt;
  reg                                 r_wrapped_burst;
  reg                                 r_wrapped_burst_nxt;
  reg [`H_DATA_WIDTH/8-1:0]           r_data_mask;
  reg [`H_DATA_WIDTH/8-1:0]           r_data_mask_nxt;
  reg                                 terminate;

  // internal counters, flags and control signals
  reg [3:0]                           cas_latency_cnt;
  reg                                 load_cas_latency_cnt;
  reg [4:0]                           term_cnt;
  reg [4:0]                           term_cnt_nxt;
  reg [2:0]                           rcd_cnt;
  reg                                 load_rcd_cnt;
  reg [2:0]                           rp_cnt1;
  reg [2:0]                           rp_cnt1_nxt;
  reg [2:0]                           rp_cnt2;
  reg [2:0]                           rp_cnt2_nxt; 
  reg [2:0]                           wr_cnt;
  reg [2:0]                           wr_cnt_nxt;
  reg [2:0]                           wtr_cnt;
  reg [2:0]                           wtr_cnt_nxt;
  reg [3:0]                           rcar_cnt1;
  reg [3:0]                           rcar_cnt1_nxt;
  reg [3:0]                           rcar_cnt2;
  reg [3:0]                           rcar_cnt2_nxt;
  reg [8:0]                           xsr_cnt;
  reg                                 load_xsr_cnt;
  reg [1:0]                           mrd_cnt;
  reg                                 load_mrd_cnt;
  reg [15:0]                          init_cnt;
  reg                                 load_init_cnt;
  reg [3:0]                           num_init_ref_cnt;
  reg [3:0]                           num_init_ref_cnt_nxt;
  reg [`MAX_S_ADDR_WIDTH-1:0]         i_col_addr;
  reg [`MAX_S_ADDR_WIDTH-1:0]         i_col_addr_nxt;
  reg [`MAX_S_ADDR_WIDTH-1:0]         row_cnt;
  reg [`MAX_S_ADDR_WIDTH-1:0]         row_cnt_nxt;
  reg [5:0]                           cas_cnt;
  reg [5:0]                           cas_cnt_nxt;
  reg [5:0]                           data_cnt;
  reg [5:0]                           data_cnt_nxt;
  reg [3:0]                           i_cas_latency;
  reg                                 early_term_flag;
  reg                                 early_term_flag_nxt;
  reg                                 init_done;
  reg                                 mode_reg_done;
  reg                                 ext_mode_reg_done;
  reg                                 sd_in_sf_mode;
  reg                                 operation_done;
  reg                                 operation_req;
  reg [3:0]                           bm_ras_cnt [MAX_NUM_BANK-1:0];
  reg [3:0]                           bm_rc_cnt [MAX_NUM_BANK-1:0];
  reg [`MAX_S_ADDR_WIDTH-1:0]         bm_row_addr [MAX_NUM_BANK-1:0];
  reg [4:0]                           bm_bank_age [15:0];
  reg [MAX_NUM_BANK-1:0]              bm_bank_status;
  reg [4:0]                           bm_num_open_bank;
  reg [MAX_NUM_BANK-1:0]              bm_open_bank;
  reg                                 bm_open_any;
  reg [MAX_NUM_BANK-1:0]              bm_close_bank;
  reg                                 bm_close_any;
  reg [`MAX_S_BANK_ADDR_WIDTH-1:0]    close_bank_addr;
  reg [`MAX_S_BANK_ADDR_WIDTH-1:0]    r_close_bank_addr;
  reg [`MAX_S_ADDR_WIDTH-1:0]         bm_row_addr_nxt; 
  reg [3:0]                           bm_ras_cnt_max;
  reg                                 bm_close_all;
  reg                                 r_bm_close_all;
  reg [15:0]                          r_bm_open_bank;
  reg [15:0]                          r_bm_close_bank;
  reg                                 i_dqs;
  reg                                 i_dqs_nxt;
  reg                                 i_dqs_d;
  reg                                 sdram_access;
  reg                                 sdram_access_nxt;
  reg                                 hiu_req_d;
  reg                                 wrapped_pop_flag;
  reg                                 wrapped_pop_flag_nxt; 
  reg [2:0]                           delta_delay;
  reg [2:0]                           delta_delay_nxt;                          
  reg                                 data_flag;
  reg                                 data_flag_nxt;
  reg                                 write_start;
  reg                                 write_start_nxt;
  reg                                 ebi_req_op;  
  reg                                 ebi_req_op_nxt;
  reg                                 ebi_prech_req_a;
  reg                                 ebi_prech_req_nxt_a;
  reg                                 dout_valid_flag;
  reg                                 dout_valid_flag_nxt;
  reg                                 pre_amble_mute;
  reg                                 pre_amble_mute_nxt; 
  reg                                 dqs_mask_end;
  reg                                 dqs_mask_end_nxt;
   
  // Mobile-DDR specific
  reg                                 sd_in_dpd_mode_nxt;
  reg                                 sd_in_dpd_mode;
 
  wire [`MAX_S_ADDR_WIDTH-1:0]        open_row_addr;
  wire [47:0]                         comb_lsb_age;
  wire [79:0]                         joint_bank_age;
  wire [15:0]                         ext_bank_status;
  wire [3:0]                          current_ras_cnt;
  wire [3:0]                          current_rc_cnt;
  wire [3:0]                          oldest_bank_ras_cnt;
  wire [2:0]                          oldest_age;
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0]   oldest_bank;
  wire                                trans_req;
  wire [3:0]                          cas_latency;
  reg [3:0]                           r_cas_latency;
  wire [`MAX_S_ADDR_WIDTH:0]          num_row;
  wire [2:0]                          t_rp_minus_1;

  wire [2:0]                          t_xp;
  reg [2:0]                           t_xp_cnt;
  wire                                t_xp_load, t_xp_expired;
  
  assign t_rp_minus_1 = (t_rp > 0) ? t_rp - 1 : 0;


  //-----------------------------------------------------------------------
  // State definition of memory operation FSM
  //-----------------------------------------------------------------------
  // states for SDRAM initialization
  `define IN_START_DSDC 0          // load t_init_counter
  `define IN_WAIT_DSDC 1           // hold SDRAM input stable for t_init
  `define IN_CKE_DSDC 2            // start to drive cke high 
  `define IN_PREC1_DSDC 3          // precharge all banks
  `define IN_LD_EMR_DSDC 4         // load extended mode register  
  `define IN_LD_MR1_DSDC 5         // load mode register
  `define IN_PREC2_DSDC 6          // precharge all banks
  `define IN_REF_DSDC 7            // issue num_init_ref auto refreshes
  `define IN_LD_MR2_DSDC 8         // load mode register

  // states for SDRAM self refresh
  `define SR_EN_RF_DSDC 9          // auto refresh before entering self refresh
  `define SELF_REF_DSDC 10         // self refresh 
  `define SR_EXIT_DSDC 11          // exit self refresh
  `define SR_EX_RF_DSDC 12         // auto refresh after exiting self refresh

  // states for SDRAM power down
  `define POWER_DOWN_DSDC 13       // power down
  `define PD_EXIT_WAIT_DSDC 21     // power down exit wait before any command
  `define PD_RF_EXIT_DSDC 14       // exit power down
  `define PD_REF_DSDC 15           // auto refresh during power down

  // states for mode register update
  `define LOAD_MR_DSDC 16          // load mode register
  `define LOAD_EMR_DSDC 17         // load extended mode register

  `define OP_IDLE_DSDC 18          // ready for memory operation
  `define OP_WAIT_DSDC 19          // wait for memory access 

  // states for Mobile DDR Deep Power Down (DPD)
  `define DEEP_POWER_DOWN_DSDC 20  // SDRAM in DPD

   localparam ST_OPERATION_SIZE = 5;
   reg [ST_OPERATION_SIZE-1:0]        operation_cs, operation_ns; // SDRAM operation FSM
   wire [4:0]                         debug_operation_ns;
   assign debug_operation_ns = operation_ns;
   
   localparam [ST_OPERATION_SIZE-1:0] IN_START_DSDC = `IN_START_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] IN_WAIT_DSDC = `IN_WAIT_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] IN_CKE_DSDC = `IN_CKE_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] IN_PREC1_DSDC = `IN_PREC1_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] IN_LD_EMR_DSDC = `IN_LD_EMR_DSDC;   
   localparam [ST_OPERATION_SIZE-1:0] IN_LD_MR1_DSDC = `IN_LD_MR1_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] IN_PREC2_DSDC = `IN_PREC2_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] IN_REF_DSDC = `IN_REF_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] IN_LD_MR2_DSDC = `IN_LD_MR2_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] SR_EN_RF_DSDC = `SR_EN_RF_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] SELF_REF_DSDC = `SELF_REF_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] SR_EXIT_DSDC = `SR_EXIT_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] SR_EX_RF_DSDC = `SR_EX_RF_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] POWER_DOWN_DSDC = `POWER_DOWN_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] PD_EXIT_WAIT_DSDC = `PD_EXIT_WAIT_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] PD_RF_EXIT_DSDC = `PD_RF_EXIT_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] PD_REF_DSDC = `PD_REF_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] LOAD_MR_DSDC = `LOAD_MR_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] LOAD_EMR_DSDC = `LOAD_EMR_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] OP_IDLE_DSDC = `OP_IDLE_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] OP_WAIT_DSDC = `OP_WAIT_DSDC;
   localparam [ST_OPERATION_SIZE-1:0] DEEP_POWER_DOWN_DSDC = `DEEP_POWER_DOWN_DSDC;
     
  //-----------------------------------------------------------------------
  // State definition of memory access FSM
  //----------------------------------------------------------------------- 
  `define WAIT_DSDC 0              // wait for memory operation
  `define IDLE_DSDC 1              // ready for memory access
  `define ACT_DSDC 2               // row activate 
  `define READ_DSDC 3              // read command
  `define R_DATA_DSDC 4            // read data / read command 
  `define R_TERM_DSDC 5            // read termination 
  `define R_RAS_DSDC 6             // wait for t_ras_min
  `define R_PREC_DSDC 7            // immediate precharge after read
  `define WRITE_DSDC 8             // write command / write data
  `define W_POP_DSDC 9             // wait after write
  `define W_WR_RAS_DSDC 11         // wait t_wr and t_ras_min
  `define W_PREC_DSDC 12           // immediate precharge after write
  `define W_RF_WR_DSDC 13          // wait t_wr for refresh-interrupted write  
  `define INT_RF_PREC_DSDC 14      // row precharge for refresh-interrupted r/w 
  `define INT_REF_DSDC 15          // auto refresh during unspecified-length r/w
  `define PREC_DSDC 16             // precharge for page miss 
  `define AUTO_REF_DSDC 10         // auto refresh
  `define RW_IDLE_DSDC 17          // idle state to improve burt_done timing

   localparam ST_ACCESS_SIZE = 5;
   reg [ST_ACCESS_SIZE-1:0]     access_cs, access_ns; // SDRAM access FSM
   wire [4:0]                   debug_access_ns;
   assign debug_access_ns = access_ns;   
   
   localparam [ST_ACCESS_SIZE-1:0] WAIT_DSDC = `WAIT_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] IDLE_DSDC = `IDLE_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] ACT_DSDC = `ACT_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] READ_DSDC = `READ_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] R_DATA_DSDC = `R_DATA_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] R_TERM_DSDC = `R_TERM_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] R_RAS_DSDC = `R_RAS_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] R_PREC_DSDC = `R_PREC_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] WRITE_DSDC = `WRITE_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] W_POP_DSDC = `W_POP_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] W_WR_RAS_DSDC = `W_WR_RAS_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] W_PREC_DSDC = `W_PREC_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] W_RF_WR_DSDC = `W_RF_WR_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] INT_RF_PREC_DSDC = `INT_RF_PREC_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] INT_REF_DSDC = `INT_REF_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] PREC_DSDC = `PREC_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] AUTO_REF_DSDC = `AUTO_REF_DSDC;
   localparam [ST_ACCESS_SIZE-1:0] RW_IDLE_DSDC = `RW_IDLE_DSDC;
 
   
  // set mode register delay, fixed according to JEDEC standard
  `define T_MRD_DSDC 2 

  //-----------------------------------------------------------------------
  // FSM sequential logic
  //-----------------------------------------------------------------------
  always @(posedge hclk or negedge hresetn)
  begin: CTLSEQ_PROC
    if (hresetn == 1'b0) begin
      access_cs             <= `WAIT_DSDC;
      operation_cs          <= `IN_START_DSDC;
        // Mobile DDR SDRAM requires CKE/DQM held high during init sequence.
        s_cke               <= 1'b1;
        pre_dqm             <= {DATA_WIDTH_BYTE{1'b1}};
      s_cs_n                <= {`N_CS{1'b1}};
      s_ras_n               <= 1'b1;
      s_cas_n               <= 1'b1;
      s_we_n                <= 1'b1;
      s_addr                <= 0;
      s_bank_addr           <= 0;
      pre_amble             <= 1'b1; 
      i_dqs                 <= 1'b1;
      i_dqs_d               <= 1'b1;
      s_dout_valid          <= {(`MAX_S_DATA_WIDTH/8){1'b1}};
      miu_pop_n             <= 1'b1;
      miu_push_n            <= 1'b1;
      auto_ref_en           <= 1'b0;
      ref_ack               <= 1'b0;
      rcar_cnt1             <= 4'b0;
      rcar_cnt2             <= 4'b0;
      rp_cnt1               <= 3'b0;
      rp_cnt2               <= 3'b0;
      term_cnt              <= 5'b0;
      wr_cnt                <= 3'b0;
      wtr_cnt               <= 3'b0;
      num_init_ref_cnt      <= 4'b0;
      row_cnt               <= 0;
      cas_cnt               <= 6'b0;
      data_cnt              <= 6'b0;
      r_chip_slct           <= 0;
      r_bank_addr           <= 0;
      r_row_addr            <= 0;
      r_col_addr            <= 0;
      r_rw                  <= 1; 
      r_burst_size          <= 6'b0;
      r_wrapped_burst       <= 1'b0;
      r_data_mask           <= 0;
      r_cas_latency         <= 4'b0;
      i_col_addr            <= 0;
      early_term_flag       <= 0;
      wrapped_pop_flag      <= 1'b0;
      delta_delay           <= 3'b0;
      data_flag             <= 1'b0;
      hiu_req_d             <= 1'b0;
      write_start           <= 1'b0;
      ebi_req_op            <= 1'b0;
      ebi_prech_req_a       <= 1'b0;
      dout_valid_flag       <= 1'b0;
      pre_amble_mute        <= 1'b0;
      terminate             <= 1'b0;
      r_bm_open_bank        <= 16'b0;
      r_bm_close_bank       <= 16'b0;
      r_close_bank_addr     <= 0; 
      r_bm_close_all        <= 1'b0;
      sdram_access          <= 1'b0;
      s_rd_start            <= 1'b0;
      s_rd_pop              <= 1'b0;
      s_rd_end              <= 1'b0;
      dqs_mask_end          <= 1'b0;
      sd_in_dpd_mode        <= 1'b0;
    end
    else begin
      access_cs             <= access_ns;
      operation_cs          <= operation_ns;
      s_cke                 <= s_cke_nxt;
      s_cs_n                <= s_cs_nxt_o & s_cs_nxt_a;
      s_ras_n               <= s_ras_nxt_o & s_ras_nxt_a;
      s_cas_n               <= s_cas_nxt_o & s_cas_nxt_a;
      s_we_n                <= s_we_nxt_o & s_we_nxt_a;
      s_addr                <= s_addr_nxt_o | s_addr_nxt_a;
      s_bank_addr           <= s_bank_addr_nxt_o | s_bank_addr_nxt_a;
      pre_dqm               <= (hiu_terminate & !r_rw) ? 
                               {DATA_WIDTH_BYTE{1'b1}} : s_dqm_nxt;
      pre_amble             <= pre_amble_nxt;
      i_dqs                 <= i_dqs_nxt;
      i_dqs_d               <= i_dqs;
      s_dout_valid          <= s_dout_valid_nxt ? 
                               {(`MAX_S_DATA_WIDTH/8){1'b1}} :
                               {(`MAX_S_DATA_WIDTH/8){1'b0}};
      miu_pop_n             <= miu_pop_n_nxt | hiu_terminate;
      miu_push_n            <= miu_push_n_nxt | hiu_terminate;
      auto_ref_en           <= auto_ref_en_nxt;
      ref_ack               <= ref_ack_nxt_o | ref_ack_nxt_a;
      rcar_cnt1             <= rcar_cnt1_nxt;
      rcar_cnt2             <= rcar_cnt2_nxt; 
      rp_cnt1               <= rp_cnt1_nxt;
      rp_cnt2               <= rp_cnt2_nxt;
      wr_cnt                <= wr_cnt_nxt;
      wtr_cnt               <= wtr_cnt_nxt;
      term_cnt              <= term_cnt_nxt;
      num_init_ref_cnt      <= num_init_ref_cnt_nxt;
      row_cnt               <= row_cnt_nxt;
      cas_cnt               <= cas_cnt_nxt;
      data_cnt              <= data_cnt_nxt;
      r_chip_slct           <= r_chip_slct_nxt;
      r_bank_addr           <= r_bank_addr_nxt;
      r_row_addr            <= r_row_addr_nxt;
      r_col_addr            <= r_col_addr_nxt;
      r_rw                  <= r_rw_nxt;
      r_burst_size          <= r_burst_size_nxt;
      r_wrapped_burst       <= r_wrapped_burst_nxt;
      r_data_mask           <= r_data_mask_nxt;
      r_cas_latency         <= cas_latency;
      i_col_addr            <= i_col_addr_nxt;
      early_term_flag       <= early_term_flag_nxt;
      wrapped_pop_flag      <= wrapped_pop_flag_nxt;
      delta_delay           <= delta_delay_nxt;
      data_flag             <= data_flag_nxt;
      hiu_req_d             <= hiu_req;
      write_start           <= write_start_nxt;
      ebi_req_op            <= ebi_req_op_nxt;
      ebi_prech_req_a       <= ebi_prech_req_nxt_a;
      dout_valid_flag       <= dout_valid_flag_nxt;
      pre_amble_mute        <= pre_amble_mute_nxt; 
      terminate             <= hiu_terminate;
      r_bm_open_bank        <= bm_open_bank;
      r_bm_close_bank       <= bm_close_bank;
      r_close_bank_addr     <= close_bank_addr;
      r_bm_close_all        <= bm_close_all;
      sdram_access          <= sdram_access_nxt;
      s_rd_start            <= s_rd_start_nxt;
      s_rd_pop              <= ~(miu_push_n_nxt | hiu_terminate);
      s_rd_end              <= s_rd_end_nxt;
      dqs_mask_end          <= dqs_mask_end_nxt;
      sd_in_dpd_mode        <= sd_in_dpd_mode_nxt;
    end
  end

  //-----------------------------------------------------------------------
  // Combinational logic of the operation FSM
  //-----------------------------------------------------------------------
  // leda W456 off
  // leda C_2C_R off
  always @(*)
  begin: OPCOMB_PROC

    // default values
    operation_ns           = operation_cs;
    operation_done         = 1'b0;
    rp_cnt1_nxt            = 3'b0;
    rcar_cnt1_nxt          = 1'b0;
    load_mrd_cnt           = 1'b0;
    load_init_cnt          = 1'b0;
    load_xsr_cnt           = 1'b0;
    auto_ref_en_nxt        = 1'b1;
    num_init_ref_cnt_nxt   = 4'h0;
    row_cnt_nxt            = 0;
    s_cke_nxt              = s_cke;
    s_cs_nxt_o             = {`N_CS{1'b1}};
    s_bank_addr_nxt_o      = 0;
    s_addr_nxt_o           = 0;
    s_ras_nxt_o            = 1'b1;
    s_cas_nxt_o            = 1'b1;
    s_we_nxt_o             = 1'b1;
    ref_ack_nxt_o          = 1'b0;
    init_done              = 1'b0;
    mode_reg_done          = 1'b0; 
    ext_mode_reg_done      = 1'b0;
    sd_in_sf_mode          = 1'b0;
    ebi_req_op_nxt         = 1'b0;
    sd_in_dpd_mode_nxt     = sd_in_dpd_mode;

    case(operation_cs)
    
      // load t_init counter
      `IN_START_DSDC: begin
        auto_ref_en_nxt   = 1'b0;
        load_init_cnt     = 1'b1;
        operation_ns      = `IN_WAIT_DSDC;
      end

      // hold SDRAM input stable for t_init
      `IN_WAIT_DSDC: begin
        auto_ref_en_nxt  = 1'b0;
        if (init_cnt == 0) begin                 // t_init met, go to `IN_CKE_DSDC 
          s_cke_nxt      = 1'b1;
          operation_ns   = `IN_CKE_DSDC;
        end
      end
     
      // bring s_cke to high
      `IN_CKE_DSDC: begin
        if(`EBI_INTERFACE == 1 && `ENABLE_ADDRBUS_SHARING == 0)
        begin                                  // request for EBI
          ebi_req_op_nxt    = 1;
          if(sdram_ebi_gnt & ebi_req_op) begin // EBI granted
            auto_ref_en_nxt   = 1'b0;
            s_cs_nxt_o        = {`N_CS{1'b0}};  
            s_ras_nxt_o       = 1'b0;
            s_we_nxt_o        = 1'b0; 
            s_addr_nxt_o      = (`A8_FOR_PRECHARGE == 1) ?
                                {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}};
            rp_cnt1_nxt       = t_rp;
            operation_ns      = `IN_PREC1_DSDC;
          end
        end
        else begin
          auto_ref_en_nxt   = 1'b0;
          s_cs_nxt_o        = {`N_CS{1'b0}};
          s_ras_nxt_o       = 1'b0;
          s_we_nxt_o        = 1'b0;
          s_addr_nxt_o      = (`A8_FOR_PRECHARGE == 1) ?
                              {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}};
          rp_cnt1_nxt       = t_rp;
          operation_ns      = `IN_PREC1_DSDC;
        end
      end  

      // precharge all SDRAM banks
      `IN_PREC1_DSDC: begin
        auto_ref_en_nxt   = 1'b0;  
        if(rp_cnt1 == 0) begin                   // t_rp met                   
          if(`EBI_INTERFACE == 1) begin          // request EBI interface
            ebi_req_op_nxt  = 1;
            if(sdram_ebi_gnt & ebi_req_op) begin // EBI granted    
                // Mobile DDR SDRAM, go to refresh state 
                s_cs_nxt_o           = {`N_CS{1'b0}};
                s_ras_nxt_o          = 1'b0;
                s_cas_nxt_o          = 1'b0;
                rcar_cnt1_nxt        = t_rcar;
                num_init_ref_cnt_nxt = num_init_ref;
                operation_ns         = `IN_REF_DSDC;
            end
          end
          else begin
              // Mobile DDR SDRAM, go to refresh state 
              s_cs_nxt_o           = {`N_CS{1'b0}};
              s_ras_nxt_o          = 1'b0;
              s_cas_nxt_o          = 1'b0;
              rcar_cnt1_nxt        = t_rcar;
              num_init_ref_cnt_nxt = num_init_ref;
              operation_ns         = `IN_REF_DSDC;
          end
        end
        else                                     // count for t_rp
          rp_cnt1_nxt = rp_cnt1 - 1; 
      end

      // load extended mode register
      `IN_LD_EMR_DSDC: begin
        auto_ref_en_nxt   = 1'b0;
        if(mrd_cnt == 0) begin
            // Mobile DDR SDRAM init sequence complete, go to wait state.
            init_done          = 1'b1;
            operation_done     = 1'b1;
            sd_in_dpd_mode_nxt = 1'b0; // Clear DPD status
            operation_ns       = `OP_WAIT_DSDC;
        end
        if(`EBI_INTERFACE == 1)
          ebi_req_op_nxt   = 1;
      end         

      // load mode register and reset DLL
      `IN_LD_MR1_DSDC: begin
        auto_ref_en_nxt  = 1'b0;
        if(mrd_cnt == 0) begin                   // t_mrd met, go to precharge 
          s_cs_nxt_o     = {`N_CS{1'b0}};        // all banks
          s_ras_nxt_o    = 1'b0;
          s_we_nxt_o     = 1'b0;
          s_addr_nxt_o   = (`A8_FOR_PRECHARGE == 1) ?
                           {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
          rp_cnt1_nxt    = t_rp;
          operation_ns   = `IN_PREC2_DSDC;
        end
        if(`EBI_INTERFACE == 1 && `ENABLE_ADDRBUS_SHARING == 0)
          ebi_req_op_nxt   = 1;
      end
   
      // precharge all SDRAM banks
      `IN_PREC2_DSDC: begin
        auto_ref_en_nxt   = 1'b0;
        if(rp_cnt1 == 0) begin                   // go to refresh stage
          s_cs_nxt_o             = {`N_CS{1'b0}};
          s_ras_nxt_o            = 1'b0;
          s_cas_nxt_o            = 1'b0;
          rcar_cnt1_nxt          = t_rcar;
          num_init_ref_cnt_nxt   = num_init_ref;
          operation_ns           = `IN_REF_DSDC;
        end
        else
          rp_cnt1_nxt            = rp_cnt1 - 1;
      end

      // issue num_init_ref auto refreshes.
      `IN_REF_DSDC: begin
        auto_ref_en_nxt   = 1'b0;
        if(rcar_cnt1 > 0) begin                  // wait for t_rcar
          rcar_cnt1_nxt          = rcar_cnt1 - 1;
          num_init_ref_cnt_nxt   = num_init_ref_cnt;
        end
        else if (num_init_ref_cnt > 0) begin     // count for num_init_ref
          s_cs_nxt_o             = {`N_CS{1'b0}};
          s_ras_nxt_o            = 1'b0;
          s_cas_nxt_o            = 1'b0;
          rcar_cnt1_nxt          = t_rcar;
          num_init_ref_cnt_nxt   = num_init_ref_cnt - 1;
        end
        else begin                               // refreshes done
          if(`EBI_INTERFACE == 1) begin          // request EBI interface
            ebi_req_op_nxt  = 1;
            if(sdram_ebi_gnt & ebi_req_op) begin // EBI granted, load mode reg
              s_cs_nxt_o          = {`N_CS{1'b0}};  
              s_ras_nxt_o         = 1'b0;
              s_cas_nxt_o         = 1'b0;
              s_we_nxt_o          = 1'b0;
              s_bank_addr_nxt_o   = 2'b00;
              s_addr_nxt_o        = {6'b000000, t_cas_latency, 1'b0, 3'b010};
              load_mrd_cnt        = 1'b1;
              operation_ns        = `IN_LD_MR2_DSDC;
            end
          end
          else begin                             // go to load mode reg
            s_cs_nxt_o          = {`N_CS{1'b0}};
            s_ras_nxt_o         = 1'b0;
            s_cas_nxt_o         = 1'b0;
            s_we_nxt_o          = 1'b0;
            s_bank_addr_nxt_o   = 2'b00;
            s_addr_nxt_o        = {6'b000000, t_cas_latency, 1'b0, 3'b010};
            load_mrd_cnt        = 1'b1;
            operation_ns        = `IN_LD_MR2_DSDC;
          end
        end
      end

      // load mode register and without resetting DLL
      `IN_LD_MR2_DSDC: begin
        auto_ref_en_nxt   = 1'b0;
        if(mrd_cnt == 0 && xsr_cnt == 0) begin   // initialization done
            // Mobile DDR SDRAM, go to load ext mode reg state 
            s_cs_nxt_o          = {`N_CS{1'b0}};
            s_ras_nxt_o         = 1'b0;
            s_cas_nxt_o         = 1'b0;
            s_we_nxt_o          = 1'b0;
            s_bank_addr_nxt_o   = 2'b10; 
            s_addr_nxt_o        = extended_mode_reg; 
            load_mrd_cnt        = 1'b1; 
            operation_ns        = `IN_LD_EMR_DSDC;
        end
      end

      // wait for SDRAM operation request
      `OP_WAIT_DSDC: begin
        if(operation_req == 1'b1)                // new operation request
          operation_ns   = `OP_IDLE_DSDC;
      end
      
      // ready to accept operation request
      `OP_IDLE_DSDC: begin
        if(initialize) begin                     // initialization request
            // Mobile DDR SDRAM requires CKE held high during init sequence.
            s_cke_nxt       = 1'b1;
          auto_ref_en_nxt   = 1'b0;
          load_init_cnt     = 1'b1; 
          operation_ns      = `IN_WAIT_DSDC;
        end
        else if(power_down || power_down_mode) begin
          // power-down request
            // Mobile DDR SDRAM enabled.
            if (mobile_sdram_dpd_en) begin
              // Deep Power Down sequence requested.
              // Access Statemachine precharges all open banks before passing
              // control to Operation Statemachine, when power-down requested
              // Go to Deep Power Down state.
              s_cs_nxt_o         = {`N_CS{1'b0}};
              s_we_nxt_o         = 1'b0;
              s_cke_nxt                = 1'b0;      
              sd_in_dpd_mode_nxt = 1'b1; // Set DPD status
              operation_ns       = `DEEP_POWER_DOWN_DSDC;
            end
            else begin
              // Standard power down sequence requested.
              // Go to standard power down state.
              s_cke_nxt         = 1'b0;
              operation_ns      = `POWER_DOWN_DSDC;
            end
        end
        else if(self_refresh_mode) begin         // self-refresh request
          auto_ref_en_nxt   = 1'b0;
          s_cs_nxt_o        = {`N_CS{1'b0}};    
          s_ras_nxt_o       = 1'b0;
          s_cas_nxt_o       = 1'b0;
          rcar_cnt1_nxt     = t_rcar;
          row_cnt_nxt       = ref_all_before_sr ? num_row : 0;
          operation_ns      = `SR_EN_RF_DSDC;
        end
        else if(mode_reg_update) begin           // set-mode-reg request
          if(`EBI_INTERFACE == 1) begin          // request for EBI
            ebi_req_op_nxt    = 1;
            if(sdram_ebi_gnt) begin              // EBI granted
              s_cs_nxt_o        = {`N_CS{1'b0}};
              s_ras_nxt_o       = 1'b0;
              s_cas_nxt_o       = 1'b0;
              s_we_nxt_o        = 1'b0;
              s_bank_addr_nxt_o = 2'b00;
              s_addr_nxt_o      = {t_cas_latency, 1'b0, 3'b010};
              load_mrd_cnt      = 1'b1;
              operation_ns      = `LOAD_MR_DSDC;
            end
          end
          else begin
            s_cs_nxt_o        = {`N_CS{1'b0}};
            s_ras_nxt_o       = 1'b0;
            s_cas_nxt_o       = 1'b0;
            s_we_nxt_o        = 1'b0;
            s_bank_addr_nxt_o = 2'b00;
            s_addr_nxt_o      = {t_cas_latency, 1'b0, 3'b010};
            load_mrd_cnt      = 1'b1;
            operation_ns      = `LOAD_MR_DSDC;
          end
        end 
        else if(ext_mode_reg_update) begin       // set-ext-mode-reg request
          if(`EBI_INTERFACE == 1) begin          // request for EBI
            ebi_req_op_nxt    = 1;
            if(sdram_ebi_gnt) begin              // EBI granted
              s_cs_nxt_o          = {`N_CS{1'b0}};
              s_ras_nxt_o         = 1'b0;
              s_cas_nxt_o         = 1'b0;
              s_we_nxt_o          = 1'b0;
                // Mobile DDR extended mode reg bank address
                s_bank_addr_nxt_o = 2'b10;
              s_addr_nxt_o        = extended_mode_reg;
              load_mrd_cnt        = 1'b1;
              operation_ns        = `LOAD_EMR_DSDC;
            end
          end
          else begin
            s_cs_nxt_o          = {`N_CS{1'b0}};
            s_ras_nxt_o         = 1'b0;
            s_cas_nxt_o         = 1'b0;
            s_we_nxt_o          = 1'b0;
              // Mobile DDR extended mode reg bank address
              s_bank_addr_nxt_o = 2'b10;
            s_addr_nxt_o        = extended_mode_reg;
            load_mrd_cnt        = 1'b1;
            operation_ns        = `LOAD_EMR_DSDC;
          end
        end
      end 
   
      // SDRAM in power down mode.
      `POWER_DOWN_DSDC: begin
         if(trans_req || (!power_down && !power_down_mode) || ref_req) begin
          s_cke_nxt        = 1'b1;      // exit power down
          operation_ns     = `PD_EXIT_WAIT_DSDC;
        end
      end

      `PD_EXIT_WAIT_DSDC: begin
         // Wait here until t_xp is satisfied
         if (t_xp_expired && ref_req) begin
            operation_ns     = `PD_RF_EXIT_DSDC;
         end else if (t_xp_expired) begin
            operation_done   = 1'b1;
            operation_ns     = `OP_WAIT_DSDC;
         end
      end
      
      // temporary exit from power down for auto refresh
      `PD_RF_EXIT_DSDC: begin
        s_cs_nxt_o       = {`N_CS{1'b0}};
        s_ras_nxt_o      = 1'b0;
        s_cas_nxt_o      = 1'b0;
        ref_ack_nxt_o    = 1'b1;
        rcar_cnt1_nxt    = t_rcar;
        operation_ns     = `PD_REF_DSDC;
      end

      // SDRAM auto refresh during power-down mode
      `PD_REF_DSDC: begin
        if(rcar_cnt1 == 0) begin                 // auto ref done, go back to
          s_cke_nxt       = 1'b0;                // power down
          operation_ns    = `POWER_DOWN_DSDC;
        end
        else                                     // wait for t_rcar
          rcar_cnt1_nxt   = rcar_cnt1 - 1;
      end

      // auto refresh to one/all row(s) before entering self refresh
      `SR_EN_RF_DSDC: begin
        if(rcar_cnt1 > 0) begin                  // wait for t_rcar
          rcar_cnt1_nxt     = rcar_cnt1 - 1;
          auto_ref_en_nxt   = 1'b0;
          row_cnt_nxt       = row_cnt;
        end
        else begin
          if(!self_refresh_mode) begin           // exit self ref, go to idle
            operation_done    = 1'b1;
            operation_ns      = `OP_WAIT_DSDC;
          end
          else if(row_cnt > 0) begin             // count for No. of rows
            s_cs_nxt_o        = {`N_CS{1'b0}};
            auto_ref_en_nxt   = 1'b0;
            s_ras_nxt_o       = 1'b0;
            s_cas_nxt_o       = 1'b0;
            rcar_cnt1_nxt     = t_rcar;
            row_cnt_nxt       = row_cnt - 1;
          end
          else begin                             // go to self refresh mode
            s_cs_nxt_o        = {`N_CS{1'b0}};
            s_cke_nxt         = 1'b0;       
            auto_ref_en_nxt   = 1'b0;
            s_ras_nxt_o       = 1'b0;
            s_cas_nxt_o       = 1'b0;
            operation_ns      = `SELF_REF_DSDC;
          end
        end
      end
 
       // SDRAM in self refresh mode
      `SELF_REF_DSDC: begin
        auto_ref_en_nxt   = 1'b0;
        sd_in_sf_mode     = 1'b1;
        if(!self_refresh_mode) begin             // request to exit self ref
          s_cke_nxt       = 1'b1;
          load_xsr_cnt    = 1'b1;
          operation_ns    = `SR_EXIT_DSDC;
        end
      end

      // exit from the self refresh mode
      `SR_EXIT_DSDC: begin
        auto_ref_en_nxt  = 1'b0;
        if(xsr_cnt == 0) begin                   // go to exiting auto refresh
          s_cs_nxt_o     = {`N_CS{1'b0}};
          s_ras_nxt_o    = 1'b0;
          s_cas_nxt_o    = 1'b0;
          rcar_cnt1_nxt  = t_rcar;
          row_cnt_nxt    = ref_all_after_sr ? num_row : 0;
          operation_ns   = `SR_EX_RF_DSDC;
        end
      end

      // auto refresh to one/all row(s) after exiting self refresh
      `SR_EX_RF_DSDC: begin
        if(rcar_cnt1 > 0) begin                  // wait for t_rcar
          rcar_cnt1_nxt     = rcar_cnt1 - 1;
          auto_ref_en_nxt   = 1'b0;
          row_cnt_nxt       = row_cnt;
        end
        else if (row_cnt > 0) begin              // count for No. of rows
          auto_ref_en_nxt   = 1'b0;
          s_cs_nxt_o        = {`N_CS{1'b0}};
          s_ras_nxt_o       = 1'b0;
          s_cas_nxt_o       = 1'b0;
          rcar_cnt1_nxt     = t_rcar;
          row_cnt_nxt       = row_cnt - 1;
        end
        else begin                               // auto refreshes done
          operation_done    = 1'b1;
          operation_ns      = `OP_WAIT_DSDC;
        end
      end
     
      // load mode register
      `LOAD_MR_DSDC: begin
        auto_ref_en_nxt   = 1'b0;
        if(mrd_cnt == 0) begin                   // mode reg setting done
          mode_reg_done   = 1'b1;
          operation_done  = 1'b1;
          operation_ns    = `OP_WAIT_DSDC;
        end
      end 

     // load extended mode register
      `LOAD_EMR_DSDC: begin
        auto_ref_en_nxt       = 1'b0;
        if(mrd_cnt == 0) begin                   // ext mode reg setting done
          ext_mode_reg_done   = 1'b1;
          operation_done      = 1'b1;
          operation_ns        = `OP_WAIT_DSDC;
        end
      end 

        // Mobile DDR Deep Power Down mode
        `DEEP_POWER_DOWN_DSDC: begin
          auto_ref_en_nxt = 1'b0;
          if(!power_down && !power_down_mode) begin
            // Exit Deep Power Down mode.
            // Mobile DDR SDRAM requires re-initialisation after DPD.
            // Go to initialisation start state.
            s_cke_nxt     = 1'b1;      
            operation_ns        = `IN_START_DSDC;
          end
        end
        
     // default state
     default: operation_ns    = `OP_WAIT_DSDC;

    endcase
  end


  //-----------------------------------------------------------------------
  // Combinational logic of the access FSM
  //-----------------------------------------------------------------------
  // leda W502 off
  always @(*)
  begin: ACCOMB_PROC
    // default values
    access_ns                = access_cs;
    s_cs_nxt_a               = {`N_CS{1'b1}}; 
    s_ras_nxt_a              = 1'b1;
    s_cas_nxt_a              = 1'b1;
    s_we_nxt_a               = 1'b1;
    s_dqm_nxt                = 0;
    pre_amble_nxt            = 1'b1; 
    s_bank_addr_nxt_a        = 0;
    s_addr_nxt_a             = 0;
    s_dout_valid_nxt         = 1'b1;
    i_dqs_nxt                = 1'b1;
    r_chip_slct_nxt          = r_chip_slct;
    r_bank_addr_nxt          = r_bank_addr;
    r_row_addr_nxt           = r_row_addr;
    r_col_addr_nxt           = r_col_addr;
    r_rw_nxt                 = r_rw;
    r_burst_size_nxt         = r_burst_size;
    r_wrapped_burst_nxt      = r_wrapped_burst;
    r_data_mask_nxt          = r_data_mask;
    i_col_addr_nxt           = 0;
    miu_pop_n_nxt            = 1'b1;
    miu_push_n_nxt           = 1'b1;
    burst_done               = 1'b0;
    ref_ack_nxt_a            = 1'b0;
    load_cas_latency_cnt     = 1'b0;
    term_cnt_nxt             = 5'b0;
    load_rcd_cnt             = 1'b0;
    rp_cnt2_nxt              = 3'b0;
    wr_cnt_nxt               = 3'b0;
    wtr_cnt_nxt              = 3'b0;
    rcar_cnt2_nxt            = 4'b0;
    cas_cnt_nxt              = 6'b0;
    data_cnt_nxt             = 6'b0;
    bm_close_all             = 1'b0;
    bm_open_bank             = 0;
    bm_open_any              = 1'b0;
    bm_close_bank            = 0;
    bm_close_any             = 1'b0;
    close_bank_addr          = 0;
    bm_row_addr_nxt          = 0;
    early_term_flag_nxt      = early_term_flag;
    wrapped_pop_flag_nxt     = 1'b0;
    delta_delay_nxt          = delta_delay;
    data_flag_nxt            = data_flag;
    write_start_nxt          = 1'b0;
    sdram_access_nxt         = 1'b0;
    ebi_prech_req_nxt_a      = 1'b0;
    operation_req            = 1'b0;
    dout_valid_flag_nxt      = 1'b0;
    pre_amble_mute_nxt       = 1'b0;
    s_rd_start_nxt           = 1'b0;
    s_rd_end_nxt             = 1'b0;
    dqs_mask_end_nxt         = 1'b0;

    case(access_cs)

      // wait for the memroy operation
      `WAIT_DSDC: begin
          // Mobile DDR SDRAM requires DQM held high during init sequence.
          s_dqm_nxt = {DATA_WIDTH_BYTE{1'b1}};
        if(operation_done)                       // operation done, ready for
          access_ns = `IDLE_DSDC;                     // memory access
      end       

      // memory ready for access
      `IDLE_DSDC: begin
        if(ref_req) begin                        // auto refresh request
          if(~(|bm_bank_status)) begin           // all bank idle
            s_cs_nxt_a       = {`N_CS{1'b0}};
            s_ras_nxt_a      = 1'b0;
            s_cas_nxt_a      = 1'b0;
            ref_ack_nxt_a    = 1'b1;
            access_ns        = `AUTO_REF_DSDC;
            rcar_cnt2_nxt    = (t_rcar > 0) ? t_rcar - 1 : 0;
          end
          else if(bm_ras_cnt_max == 0 && wr_cnt == 0) 
          begin                                  // t_ras and t_wr met
            if(`EBI_INTERFACE == 1 && `ENABLE_ADDRBUS_SHARING == 0)
            begin                                // request for EBI
              ebi_prech_req_nxt_a    = 1'b1;
              if(sdram_ebi_gnt & ebi_prech_req_a) begin // EBI granted
                s_cs_nxt_a     = {`N_CS{1'b0}};
                s_ras_nxt_a    = 1'b0;
                s_we_nxt_a     = 1'b0;
                s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                                 {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
                bm_close_all   = 1'b1;
                access_ns      = `PREC_DSDC;
                rp_cnt2_nxt    = t_rp_minus_1;
              end
            end
            else begin
              s_cs_nxt_a     = {`N_CS{1'b0}};
              s_ras_nxt_a    = 1'b0;
              s_we_nxt_a     = 1'b0;
              s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                               {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}};
              bm_close_all   = 1'b1;
              access_ns      = `PREC_DSDC;
              rp_cnt2_nxt    = t_rp_minus_1;
            end
          end
        end         
        else if(mode_reg_update || ext_mode_reg_update || 
          self_refresh_mode || initialize) begin // operation request
          if(~(|bm_bank_status)) begin           // all bank idle
            operation_req   = 1'b1;
            access_ns       = `WAIT_DSDC;
          end
          else if(bm_ras_cnt_max == 0 && wr_cnt == 0) 
          begin                                  // t_ras and t_wr met
            if(`EBI_INTERFACE == 1 && `ENABLE_ADDRBUS_SHARING == 0)
            begin                                // request for EBI
              ebi_prech_req_nxt_a    = 1'b1;
              if(sdram_ebi_gnt & ebi_prech_req_a) begin // EBI granted            
                s_cs_nxt_a     = {`N_CS{1'b0}};
                s_ras_nxt_a    = 1'b0;
                s_we_nxt_a     = 1'b0;
                s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                                 {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
                bm_close_all   = 1'b1;
                access_ns      = `PREC_DSDC;
                rp_cnt2_nxt    = t_rp_minus_1;
              end
            end
            else begin
              s_cs_nxt_a     = {`N_CS{1'b0}};
              s_ras_nxt_a    = 1'b0;
              s_we_nxt_a     = 1'b0;
              s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                               {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}};
              bm_close_all   = 1'b1;
              access_ns      = `PREC_DSDC;
              rp_cnt2_nxt    = t_rp_minus_1;
            end
          end
        end
        else if(trans_req) begin                 // data transfer request
          data_cnt_nxt         = r_cas_latency + hiu_burst_size;
          r_rw_nxt             = hiu_rw;
          r_wrapped_burst_nxt  = hiu_wrapped_burst;
          r_burst_size_nxt     = hiu_burst_size;
          r_data_mask_nxt      = data_mask;
          r_bank_addr_nxt      = bank_addr;
          r_row_addr_nxt       = row_addr;
          r_col_addr_nxt       = col_addr;
          i_col_addr_nxt       = col_addr;
          if(hiu_burst_size > 0)
            cas_cnt_nxt         = hiu_burst_size - 1;
          if(r_chip_slct != chip_slct_n) begin   // new chip sel
            if(~(|bm_bank_status)) begin         // all bank idle
              s_cs_nxt_a               = chip_slct_n;
              s_ras_nxt_a              = 1'b0;
              s_bank_addr_nxt_a        = bank_addr;
              s_addr_nxt_a             = row_addr;
              r_chip_slct_nxt          = chip_slct_n;
              load_rcd_cnt             = 1'b1;
              bm_open_bank[bank_addr]  = 1'b1;
              bm_open_any              = 1'b1;
              bm_row_addr_nxt          = row_addr;
              sdram_access_nxt         = 1'b1;
              access_ns                = `ACT_DSDC;
            end
            else if(bm_ras_cnt_max == 0 && wr_cnt == 0) 
            begin                                // t_ras and t_wr met
              s_cs_nxt_a     = r_chip_slct;
              s_ras_nxt_a    = 1'b0;
              s_we_nxt_a     = 1'b0;
              s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                               {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
              bm_close_all   = 1'b1;
              access_ns      = `PREC_DSDC;
              rp_cnt2_nxt    = t_rp_minus_1;
            end
          end
          else if(~(|bm_bank_status)) begin      // same chip, all bank idle
            if(current_rc_cnt == 0) begin        // t_rc met, go to activate
              s_cs_nxt_a               = chip_slct_n;
              s_ras_nxt_a              = 1'b0;
              s_bank_addr_nxt_a        = bank_addr;
              s_addr_nxt_a             = row_addr; 
              r_chip_slct_nxt          = chip_slct_n;
              load_rcd_cnt             = 1'b1;
              bm_open_bank[bank_addr]  = 1'b1;
              bm_open_any              = 1'b1;
              bm_row_addr_nxt          = row_addr;
              sdram_access_nxt         = 1'b1;
              access_ns                = `ACT_DSDC;
            end
          end
          else begin                            
            if(bm_bank_status[bank_addr] == 1'b1) 
            begin                                // bank open
              if(open_row_addr ==row_addr) begin // page hit
                if(hiu_rw) begin                 // read request
                  if(wtr_cnt == 0) begin         // t_wtr met
                    r_chip_slct_nxt        = chip_slct_n;
                    if(!dout_valid_flag)
                      s_dout_valid_nxt     = 1'b0;
                    if(hiu_wrapped_burst && hiu_burst_size == 1)
                      access_ns            = `RW_IDLE_DSDC;
                    else begin
                      s_cs_nxt_a           = chip_slct_n;
                      s_cas_nxt_a          = 1'b0;
                      s_bank_addr_nxt_a    = bank_addr;
                      s_addr_nxt_a         = (`A8_FOR_PRECHARGE == 1) ?
                                             {col_addr[`MAX_S_ADDR_WIDTH-1:8], 
                                             1'b0,col_addr[7:0]} : 
                                             {col_addr[`MAX_S_ADDR_WIDTH-1:10],
                                             1'b0,col_addr[9:0]};
                      sdram_access_nxt     = 1'b1;
                      s_rd_start_nxt       = 1'b1;
                      load_cas_latency_cnt = 1'b1; 
                      access_ns            = `READ_DSDC;
                    end
                  end
                end
                else begin                       // write request
                  r_chip_slct_nxt       = chip_slct_n;
                  if(hiu_burst_size == 1)
                    access_ns           = `RW_IDLE_DSDC;
                  else begin
                    s_cs_nxt_a          = chip_slct_n;
                    s_cas_nxt_a                 = 1'b0;
                    s_bank_addr_nxt_a   = bank_addr;
                    s_addr_nxt_a        = (`A8_FOR_PRECHARGE == 1) ?
                                          {col_addr[`MAX_S_ADDR_WIDTH-1:8], 
                                          1'b0,col_addr[7:0]} : 
                                          {col_addr[`MAX_S_ADDR_WIDTH-1:10],
                                          1'b0,col_addr[9:0]}; 
                    sdram_access_nxt    = 1'b1;
                    s_we_nxt_a          = 1'b0;
                    miu_pop_n_nxt       = 1'b0;
                    i_dqs_nxt           = 1'b0;
                    write_start_nxt     = 1'b1;
                    s_dqm_nxt           = data_mask;
                    access_ns           = `WRITE_DSDC;
                    if(!pre_amble_mute)
                      pre_amble_nxt     = 1'b0; 
                  end
                end
              end 
              else begin                         // page miss 
                if(current_ras_cnt == 0 && wr_cnt == 0) 
                begin                            // t_ras and t_wr met
                  s_cs_nxt_a                 = chip_slct_n;
                  s_ras_nxt_a                = 1'b0;
                  s_we_nxt_a                 = 1'b0;
                  s_bank_addr_nxt_a          = bank_addr;
                  s_addr_nxt_a               = 0;
                  bm_close_bank[bank_addr]   = 1'b1 ;
                  bm_close_any               = 1'b1;
                  close_bank_addr            = bank_addr;
                  access_ns                  = `PREC_DSDC;
                  rp_cnt2_nxt                = t_rp_minus_1;
                end    
              end 
            end
            else begin                           // bank close
              if(bm_num_open_bank < num_open_bank) 
              begin                              // num_open_bank not met
                if(current_rc_cnt == 0) begin    // t_rc met, activate new row
                  s_cs_nxt_a               = chip_slct_n;
                  s_ras_nxt_a              = 1'b0;
                  s_bank_addr_nxt_a        = bank_addr;
                  s_addr_nxt_a             = row_addr;
                  r_chip_slct_nxt          = chip_slct_n;
                  load_rcd_cnt             = 1'b1;
                  bm_open_bank[bank_addr]  = 1'b1;
                  bm_open_any              = 1'b1;
                  bm_row_addr_nxt          = row_addr;
                  sdram_access_nxt         = 1'b1;
                  access_ns                = `ACT_DSDC;  
                end 
              end
              else begin                         // num_open_bank met
                if(oldest_bank_ras_cnt == 0 && wr_cnt == 0) 
                begin                            // t_ras and t_wr met
                  s_cs_nxt_a                   = chip_slct_n;
                  s_ras_nxt_a                  = 1'b0;
                  s_we_nxt_a                   = 1'b0;
                  s_bank_addr_nxt_a            = oldest_bank;
                  s_addr_nxt_a                 = 0;
                  bm_close_bank[oldest_bank]   = 1'b1 ;
                  bm_close_any                 = 1'b1;
                  close_bank_addr              = oldest_bank;
                  access_ns                    = `PREC_DSDC;
                  rp_cnt2_nxt                  = t_rp_minus_1;
                end
              end
            end
          end
        end
        else if(power_down || power_down_mode) 
        begin                                    // power-down request
          if(~(|bm_bank_status)) begin           // all bank idle
            operation_req  = 1'b1;
            access_ns      = `WAIT_DSDC;
          end
          else if(bm_ras_cnt_max == 0 && wr_cnt == 0) 
          begin                                  // t_ras and t_wr met
            if(`EBI_INTERFACE == 1 && `ENABLE_ADDRBUS_SHARING == 0)
            begin                                // request for EBI
              ebi_prech_req_nxt_a    = 1'b1;
              if(sdram_ebi_gnt & ebi_prech_req_a) begin // EBI granted
                s_cs_nxt_a     = {`N_CS{1'b0}};
                s_ras_nxt_a    = 1'b0;
                s_we_nxt_a     = 1'b0;
                s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                                 {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
                bm_close_all   = 1'b1;
                access_ns      = `PREC_DSDC;
                rp_cnt2_nxt    = t_rp_minus_1;
              end
            end
            else begin
              s_cs_nxt_a     = {`N_CS{1'b0}};
              s_ras_nxt_a    = 1'b0;
              s_we_nxt_a     = 1'b0;
              s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                               {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}};
              bm_close_all   = 1'b1;
              access_ns      = `PREC_DSDC;
              rp_cnt2_nxt    = t_rp_minus_1;
            end
          end
        end
        if(wtr_cnt > 0) begin
          wtr_cnt_nxt           = wtr_cnt - 1;
          dout_valid_flag_nxt   = dout_valid_flag;  
        end
        if(wr_cnt > 0)
          wr_cnt_nxt  = wr_cnt - 1;
      end
      
      // auto refresh state
      `AUTO_REF_DSDC: begin
        if(rcar_cnt2 == 0)                       // refresh done, go to idle
          access_ns       = `IDLE_DSDC;
        else                                     // wait for t_rcar
          rcar_cnt2_nxt   = rcar_cnt2 - 1;
      end

      // precharge state 
      `PREC_DSDC: begin
        if(rp_cnt2 == 0)                         // precharge done, go to idle
          access_ns       = `IDLE_DSDC;
        else                                     // wait for t_rp
          rp_cnt2_nxt     = rp_cnt2 - 1;
      end 

      // one-clock extra idle state to improve burst_done timing
      `RW_IDLE_DSDC: begin
        s_cs_nxt_a           = r_chip_slct;
        s_cas_nxt_a          = 1'b0;
        s_bank_addr_nxt_a    = r_bank_addr;
        s_addr_nxt_a         = (`A8_FOR_PRECHARGE == 1) ?
                               {r_col_addr[`MAX_S_ADDR_WIDTH-1:8], 
                               1'b0,r_col_addr[7:0]} : 
                               {r_col_addr[`MAX_S_ADDR_WIDTH-1:10],
                               1'b0,r_col_addr[9:0]};
        i_col_addr_nxt       = r_col_addr;
        sdram_access_nxt     = 1'b1;
        burst_done           = 1'b1; 
        if(r_rw) begin                 // read request
          s_rd_start_nxt        = 1'b1;
          load_cas_latency_cnt  = 1'b1;
          access_ns             = `READ_DSDC;
          if(!dout_valid_flag)
            s_dout_valid_nxt    = 1'b0;
        end
        else begin                       // write request
          s_we_nxt_a            = 1'b0;
          miu_pop_n_nxt         = 1'b0;
          i_dqs_nxt             = 1'b0;
          write_start_nxt       = 1'b1;
          s_dqm_nxt             = r_data_mask;
          access_ns             = `WRITE_DSDC;
          if(!pre_amble_mute)
            pre_amble_nxt       = 1'b0;
        end
      end

      // row activation state
      `ACT_DSDC: begin
        sdram_access_nxt      = 1'b1;
        if(rcd_cnt == 0) begin                   // t_rcd met
          s_cs_nxt_a          = r_chip_slct;
          s_cas_nxt_a         = 1'b0;
          s_bank_addr_nxt_a   = r_bank_addr;
          s_addr_nxt_a        = (`A8_FOR_PRECHARGE == 1) ?
                                {r_col_addr[`MAX_S_ADDR_WIDTH-1:8], 
                                1'b0,r_col_addr[7:0]} : 
                                {r_col_addr[`MAX_S_ADDR_WIDTH-1:10],
                                1'b0,r_col_addr[9:0]}; 
          i_col_addr_nxt      = r_col_addr;
          data_cnt_nxt        = r_cas_latency + r_burst_size;
          if(r_burst_size > 0)
            cas_cnt_nxt       = r_burst_size - 1;
          if(r_rw) begin                         // read access
            s_dout_valid_nxt       = 1'b0;
            s_rd_start_nxt         = 1'b1;
            load_cas_latency_cnt   = 1'b1;
            access_ns              = `READ_DSDC;
            if(r_wrapped_burst && r_burst_size == 1)
              burst_done           = 1'b1;
          end
          else begin                             // write access
            s_we_nxt_a             = 1'b0;
            miu_pop_n_nxt          = 1'b0;
            i_dqs_nxt              = 1'b0;
            pre_amble_nxt          = 1'b0;
            write_start_nxt        = 1'b1;
            s_dqm_nxt              = r_data_mask;
            access_ns              = `WRITE_DSDC;
            if(r_burst_size == 1)
              burst_done           = 1'b1;
          end
        end
      end

      // read state
      `READ_DSDC: begin
        s_dout_valid_nxt  = 1'b0;
        i_col_addr_nxt    = i_col_addr + 2;
        sdram_access_nxt  = 1'b1;
        if(r_burst_size == 0) begin              // unspecified-length read
          if(cas_latency_cnt == 0) begin        
            if(!s_ready_valid || (s_ready_valid && s_rd_ready)) 
            begin                                // data available 
              miu_push_n_nxt   = 1'b0;
              access_ns        = `R_DATA_DSDC;
            end
            else                                 // wait for s_rd_ready
              delta_delay_nxt  = delta_delay + 1;
          end
          if(i_col_addr[1] == 1'b1) begin        // new memory burst
            s_cs_nxt_a         = r_chip_slct;
            s_cas_nxt_a        = 1'b0;
            s_bank_addr_nxt_a  = r_bank_addr;
            s_addr_nxt_a       = (`A8_FOR_PRECHARGE == 1) ?
                                 {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:8], 
                                 1'b0,i_col_addr_nxt[7:0]} : 
                                 {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:10],
                                 1'b0,i_col_addr_nxt[9:0]}; 
          end
        end
        else if(r_wrapped_burst == 1'b1) begin   // wrapped read
          if(cas_cnt == 0) begin                 // first part done, start
            s_cs_nxt_a            = r_chip_slct; // second part
            s_cas_nxt_a           = 1'b0;
            s_bank_addr_nxt_a     = r_bank_addr;
            s_addr_nxt_a          = (`A8_FOR_PRECHARGE == 1) ?
                                    {col_addr[`MAX_S_ADDR_WIDTH-1:8], 
                                    1'b0,col_addr[7:0]} : 
                                    {col_addr[`MAX_S_ADDR_WIDTH-1:10],
                                    1'b0,col_addr[9:0]};
            r_burst_size_nxt      = hiu_burst_size;
            r_col_addr_nxt        = col_addr; 
            r_wrapped_burst_nxt   = hiu_wrapped_burst;
            i_col_addr_nxt        = col_addr; 
            cas_cnt_nxt           = hiu_burst_size - 1;
            if(cas_latency_cnt == 0) begin
              if(!s_ready_valid || (s_ready_valid && s_rd_ready)) 
              begin                              // data available
                miu_push_n_nxt  = 1'b0;
                data_cnt_nxt    = (hiu_burst_size +r_cas_latency) +delta_delay;
                access_ns       = `R_DATA_DSDC;
              end
              else begin                         // wait for s_rd_ready
                delta_delay_nxt = delta_delay + 1;
                data_cnt_nxt    = (hiu_burst_size + r_cas_latency) +
                                  (delta_delay +1);
              end
            end
            else
              data_cnt_nxt      = (hiu_burst_size + r_cas_latency) + delta_delay;
          end
          else begin                             // count for burst size
            cas_cnt_nxt      = cas_cnt - 1;
            if(cas_cnt == 1)
              burst_done     = 1'b1;
            if(cas_latency_cnt == 0) begin      
              if(!s_ready_valid || (s_ready_valid && s_rd_ready)) 
              begin                              // data available
                miu_push_n_nxt   = 1'b0;
                data_cnt_nxt     = data_cnt - 1;
                access_ns        = `R_DATA_DSDC;
              end
              else begin                         // wait for s_rd_ready
                data_cnt_nxt     = data_cnt;
                delta_delay_nxt  = delta_delay + 1;
              end
            end
            else
              data_cnt_nxt     = data_cnt - 1;
            if(i_col_addr[1] == 1'b1) begin      // new memory burst
              s_cs_nxt_a          = r_chip_slct;
              s_cas_nxt_a         = 1'b0;
              s_bank_addr_nxt_a   = r_bank_addr;
              s_addr_nxt_a        = (`A8_FOR_PRECHARGE == 1) ?
                                    {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:8], 
                                    1'b0,i_col_addr_nxt[7:0]} : 
                                    {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:10],
                                    1'b0,i_col_addr_nxt[9:0]}; 
            end
          end
        end
        else begin                               // fixed-length read
          data_cnt_nxt  = data_cnt - 1;          
          if(cas_cnt == 0) begin                 // burst done
            dqs_mask_end_nxt   = 1'b1;
            if(precharge_algorithm) begin        // delayed precharge
              if(i_col_addr[1] == 1'b0) begin    // issue term command
                s_cs_nxt_a     = r_chip_slct;
                s_we_nxt_a     = 1'b0;
              end
              term_cnt_nxt   = r_cas_latency;
              access_ns      = `R_TERM_DSDC;
              if(cas_latency_cnt == 0) begin
                if(!s_ready_valid || (s_ready_valid && s_rd_ready)) 
                begin                            // data available
                  miu_push_n_nxt   = 1'b0; 
                  data_flag_nxt    = 1'b1;
                  term_cnt_nxt     = r_cas_latency + delta_delay;
                end
                else begin                       // wait for s_rd_ready
                  delta_delay_nxt  = delta_delay + 1;
                  term_cnt_nxt     = r_cas_latency + (delta_delay + 1); 
                end
              end
            end
            else begin                           // immediate precharge
              if(bm_ras_cnt_max > 0) begin       // t_ras not met
                access_ns          = `R_RAS_DSDC;
                if(cas_latency_cnt == 0) begin 
                  if(!s_ready_valid || (s_ready_valid && s_rd_ready)) 
                  begin                          // data available
                    miu_push_n_nxt   = 1'b0;
                    data_cnt_nxt     = data_cnt - 1;
                    data_flag_nxt    = 1'b1;
                  end
                  else begin                     // wait for s_rd_ready
                    data_cnt_nxt     = data_cnt;
                    delta_delay_nxt  = delta_delay + 1;
                  end
                end 
                else
                  data_cnt_nxt       = data_cnt - 1;
              end
              else begin                         // t_ras met
                s_cs_nxt_a     = r_chip_slct;
                s_ras_nxt_a    = 1'b0;
                s_we_nxt_a     = 1'b0;
                s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                                 {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
                term_cnt_nxt   = r_cas_latency;
                bm_close_all   = 1'b1;
                access_ns      = `R_PREC_DSDC;
                rp_cnt2_nxt    = t_rp_minus_1;
                if(cas_latency_cnt == 0) begin 
                  if(!s_ready_valid || (s_ready_valid && s_rd_ready)) 
                  begin                          // data available
                    miu_push_n_nxt   = 1'b0;
                    data_cnt_nxt     = data_cnt - 1;
                    term_cnt_nxt     = r_cas_latency + delta_delay;
                    data_flag_nxt    = 1'b1;
                  end
                  else begin                     // wait for s_rd_ready
                    data_cnt_nxt     = data_cnt;
                    term_cnt_nxt     = r_cas_latency + (delta_delay + 1);
                  end
                end
                else
                  data_cnt_nxt       = data_cnt - 1;
              end
            end
          end
          else begin                             // count for burst size
            cas_cnt_nxt     = cas_cnt - 1;
            if(cas_latency_cnt == 0) begin      
              if(!s_ready_valid || (s_ready_valid && s_rd_ready)) 
              begin                              // data available
                miu_push_n_nxt   = 1'b0;
                data_cnt_nxt     = data_cnt - 1;
                access_ns        = `R_DATA_DSDC;
              end
              else begin                         // wait for s_rd_ready
                delta_delay_nxt  = delta_delay + 1;
                data_cnt_nxt     = data_cnt;
              end
            end
            else
              data_cnt_nxt       = data_cnt - 1;
            if(i_col_addr[1] == 1'b1) begin      // new memory burst
              s_cs_nxt_a         = r_chip_slct;
              s_cas_nxt_a        = 1'b0;
              s_bank_addr_nxt_a  = r_bank_addr;
              s_addr_nxt_a       = (`A8_FOR_PRECHARGE == 1) ? 
                                   {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:8], 
                                   1'b0,i_col_addr_nxt[7:0]} : 
                                   {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:10],
                                   1'b0,i_col_addr_nxt[9:0]}; 
            end
          end 
        end
      end
      
      // read data state
      `R_DATA_DSDC: begin
        s_dout_valid_nxt   = 1'b0;
        i_col_addr_nxt     = i_col_addr + 2;
        sdram_access_nxt   = 1'b1;
        if(r_burst_size == 0) begin              // unspecified-length read
          if(terminate) begin                    // burst early-terminated
            early_term_flag_nxt   = 1'b1;
            if(precharge_algorithm) begin        // delayed precharge
              if(i_col_addr[1] == 1'b0) begin    // issue term command
                s_cs_nxt_a     = r_chip_slct;
                s_we_nxt_a     = 1'b0;
              end
              term_cnt_nxt     = r_cas_latency + delta_delay;
              access_ns        = `R_TERM_DSDC;
            end
            else begin                           // immediate precharge
              if(bm_ras_cnt_max > 0)             // t_ras not met
                access_ns      = `R_RAS_DSDC;
              else begin                         // t_ras met
                s_cs_nxt_a     = r_chip_slct;
                s_ras_nxt_a    = 1'b0;
                s_we_nxt_a     = 1'b0;
                s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                                 {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
                term_cnt_nxt   = r_cas_latency + delta_delay;
                bm_close_all   = 1'b1;
                access_ns      = `R_PREC_DSDC;
                rp_cnt2_nxt    = t_rp_minus_1;
              end
            end
          end 
          else if(ref_req && (bm_ras_cnt_max == 0) &&
                        (i_col_addr[1] == 1'b1)) begin       // auto refresh request
            s_cs_nxt_a            = {`N_CS{1'b0}};
            s_ras_nxt_a           = 1'b0;
            s_we_nxt_a            = 1'b0;
            s_addr_nxt_a          = (`A8_FOR_PRECHARGE == 1) ?
                                    {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
            miu_push_n_nxt        = 1'b0;
            r_col_addr_nxt        = i_col_addr + 2;
            term_cnt_nxt          = r_cas_latency + delta_delay;
            rp_cnt2_nxt           = t_rp;
            bm_close_all          = 1'b1;
            access_ns             = `INT_RF_PREC_DSDC;
            dqs_mask_end_nxt      = 1'b1;
          end
          else begin                             // stay in data state
            miu_push_n_nxt = 1'b0;
            if(i_col_addr[1] == 1'b1) begin      // new memory burst
              s_cs_nxt_a          = r_chip_slct;
              s_cas_nxt_a         = 1'b0;
              s_bank_addr_nxt_a   = r_bank_addr;
              s_addr_nxt_a        = (`A8_FOR_PRECHARGE == 1) ? 
                                    {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:8], 
                                    1'b0,i_col_addr_nxt[7:0]} : 
                                    {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:10],
                                    1'b0,i_col_addr_nxt[9:0]}; 
            end
          end
        end
        else if(r_wrapped_burst == 1'b1) begin   // wrapped burst
          if(terminate) begin                    // burst early-terminated
            early_term_flag_nxt   = 1'b1;
            if(cas_cnt > 0)
              burst_done       = 1'b1;
            if(precharge_algorithm) begin        // delayed precharge
              if(i_col_addr[1] == 1'b0) begin    // issue term command
                s_cs_nxt_a     = r_chip_slct;
                s_we_nxt_a     = 1'b0;
              end
              term_cnt_nxt     = r_cas_latency + delta_delay;
              access_ns        = `R_TERM_DSDC;
            end
            else begin                           // immediate precharge
              if(bm_ras_cnt_max > 0)             // t_ras not met
                access_ns      = `R_RAS_DSDC;
              else begin                         // t_ras met
                s_cs_nxt_a     = r_chip_slct;
                s_ras_nxt_a    = 1'b0;
                s_we_nxt_a     = 1'b0;
                s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                                 {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
                term_cnt_nxt   = r_cas_latency + delta_delay;
                bm_close_all   = 1'b1;
                access_ns      = `R_PREC_DSDC;
                rp_cnt2_nxt    = t_rp_minus_1;
              end
            end 
          end
          else begin
            if(cas_cnt > 0) begin                // count for burst size
              miu_push_n_nxt        = 1'b0;
              cas_cnt_nxt           = cas_cnt - 1;
              if(i_col_addr[1] == 1'b1) begin    // new memory burst
                s_cs_nxt_a          = r_chip_slct;
                s_cas_nxt_a         = 1'b0;
                s_bank_addr_nxt_a   = r_bank_addr;
                s_addr_nxt_a        = (`A8_FOR_PRECHARGE == 1) ? 
                                      {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:8], 
                                      1'b0,i_col_addr_nxt[7:0]} : 
                                      {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:10],
                                      1'b0,i_col_addr_nxt[9:0]}; 
              end
              if(cas_cnt == 1)
                burst_done          = 1'b1;
            end
            else begin                           // first part done, start
              s_cs_nxt_a          = r_chip_slct; // second part
              s_cas_nxt_a         = 1'b0;    
              s_bank_addr_nxt_a   = r_bank_addr;
              s_addr_nxt_a        = (`A8_FOR_PRECHARGE == 1) ? 
                                    {col_addr[`MAX_S_ADDR_WIDTH-1:8], 
                                    1'b0,col_addr[7:0]} : 
                                    {col_addr[`MAX_S_ADDR_WIDTH-1:10],
                                    1'b0,col_addr[9:0]}; 
              miu_push_n_nxt      = 1'b0;
              r_col_addr_nxt      = col_addr; 
              i_col_addr_nxt      = col_addr; 
              r_wrapped_burst_nxt = hiu_wrapped_burst;
              r_burst_size_nxt    = hiu_burst_size;
              cas_cnt_nxt         = hiu_burst_size - 1;
              data_cnt_nxt        = (hiu_burst_size + r_cas_latency) + delta_delay; 
            end
          end
        end
        else begin                               // fixed-length burst
          if(terminate) begin                    // burst early-terminated
            early_term_flag_nxt   = 1'b1;
            if(precharge_algorithm) begin        // delayed precharge
              if(i_col_addr[1] == 1'b0) begin    // issue term command
                s_cs_nxt_a    = r_chip_slct;
                s_we_nxt_a    = 1'b0;
              end
              term_cnt_nxt    = r_cas_latency + delta_delay;
              access_ns       = `R_TERM_DSDC;
            end
            else begin                           // immediate precharge
              if(bm_ras_cnt_max > 0)             // t_ras not met
                access_ns      = `R_RAS_DSDC;
              else begin                         // t_ras met
                s_cs_nxt_a     = r_chip_slct;
                s_ras_nxt_a    = 1'b0;
                s_we_nxt_a     = 1'b0;
                s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                                 {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}};
                term_cnt_nxt   = r_cas_latency + delta_delay;
                bm_close_all   = 1'b1;
                access_ns      = `R_PREC_DSDC;
                rp_cnt2_nxt    = t_rp_minus_1;
              end
            end
          end
          else begin
            miu_push_n_nxt          = 1'b0;
            data_cnt_nxt            = data_cnt - 1;
            if(cas_cnt > 0) begin                // count for burst size
              cas_cnt_nxt           = cas_cnt - 1;
              if(i_col_addr[1] == 1'b1) begin    // new memory burst
                s_cs_nxt_a          = r_chip_slct;
                s_cas_nxt_a         = 1'b0;
                s_bank_addr_nxt_a   = r_bank_addr;
                s_addr_nxt_a        = (`A8_FOR_PRECHARGE == 1) ? 
                                      {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:8], 
                                      1'b0,i_col_addr_nxt[7:0]} : 
                                      {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:10],
                                      1'b0,i_col_addr_nxt[9:0]}; 
              end
            end
            else begin                           // burst done
              dqs_mask_end_nxt = 1'b1;
              if(precharge_algorithm) begin      // delayed precharge
                if(i_col_addr[1] == 1'b0) begin  
                  s_cs_nxt_a   = r_chip_slct;
                  s_we_nxt_a   = 1'b0;
                end
                term_cnt_nxt   = r_cas_latency + delta_delay;
                data_flag_nxt  = 1'b1; 
                access_ns      = `R_TERM_DSDC;
              end
              else begin                         // immediate precharge
                data_flag_nxt    = 1'b1;
                if(bm_ras_cnt_max > 0)           // t_ras not met
                  access_ns      = `R_RAS_DSDC;
                else begin                       // t_ras met
                  s_cs_nxt_a     = r_chip_slct;
                  s_ras_nxt_a    = 1'b0;
                  s_we_nxt_a     = 1'b0;
                  s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                                   {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
                  term_cnt_nxt   = r_cas_latency + delta_delay;
                  bm_close_all   = 1'b1;
                  access_ns      = `R_PREC_DSDC;
                  rp_cnt2_nxt    = t_rp_minus_1;
                end
              end
            end
          end
        end
      end
 
      // terminate read burst
      `R_TERM_DSDC: begin
        s_dout_valid_nxt   = 1'b0;
        if(early_term_flag) begin                // early termination
          if(term_cnt > 0) begin                 // wait for residue data
            term_cnt_nxt       = term_cnt - 1;
            sdram_access_nxt   = 1'b1;
          end
          else begin                             // burst terminated
            s_rd_end_nxt           = 1'b1;
            early_term_flag_nxt    = 1'b0;
            delta_delay_nxt        = 3'b0;
            data_flag_nxt          = 1'b0;
            burst_done             = 1'b1;
            access_ns              = `IDLE_DSDC;
          end
        end
        else begin                               // normal termination
          if(data_flag) begin                    // data availalbe
            if(term_cnt > 0) begin               // wait for residue data
              term_cnt_nxt       = term_cnt - 1;
              sdram_access_nxt   = 1'b1;
              miu_push_n_nxt     = 1'b0;
            end
            else begin                           // burst terminated     
              s_rd_end_nxt       = 1'b1; 
              burst_done         = 1'b1;
              delta_delay_nxt    = 3'b0;
              data_flag_nxt      = 1'b0;
              access_ns          = `IDLE_DSDC;
            end
          end
          else begin                             // wait for data
            sdram_access_nxt   = 1'b1;
            if(cas_latency_cnt == 0) begin
              if(!s_ready_valid || (s_ready_valid && s_rd_ready)) 
              begin                              // data available
                data_flag_nxt    = 1'b1;
                term_cnt_nxt     = term_cnt - 1;
                miu_push_n_nxt   = 1'b0;
              end
              else                               // wait for data ready
                term_cnt_nxt     = term_cnt;
            end
            else
              term_cnt_nxt       = term_cnt - 1;
          end
        end
      end
  
      // wait for t_ras_min before precharge
      `R_RAS_DSDC: begin
        sdram_access_nxt     = 1'b1;
        s_dout_valid_nxt     = 1'b0;
        if(early_term_flag) begin                // early termination
          if(bm_ras_cnt_max == 0) begin          // t_ras met
            s_cs_nxt_a     = r_chip_slct;
            s_ras_nxt_a    = 1'b0;
            s_we_nxt_a     = 1'b0;
            s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                             {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
            term_cnt_nxt   = r_cas_latency + delta_delay;
            bm_close_all   = 1'b1;
            access_ns      = `R_PREC_DSDC;
            rp_cnt2_nxt    = t_rp_minus_1;
          end
        end
        else begin                               // normal termination
          if(data_flag) begin                    // data available
            if(data_cnt > 0) begin
              data_cnt_nxt     = data_cnt - 1;
              miu_push_n_nxt   = 1'b0;
            end
            if(bm_ras_cnt_max == 0) begin        // t_ras met
              s_cs_nxt_a     = r_chip_slct;
              s_ras_nxt_a    = 1'b0;
              s_we_nxt_a     = 1'b0;
              s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                               {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
              term_cnt_nxt   = r_cas_latency + delta_delay;
              bm_close_all   = 1'b1;
              access_ns      = `R_PREC_DSDC;
              rp_cnt2_nxt    = t_rp_minus_1;
            end
          end
          else begin                             // wait for data
            if(cas_latency_cnt == 0) begin
              if(!s_ready_valid || (s_ready_valid && s_rd_ready)) 
              begin                              // data available
                data_cnt_nxt     = data_cnt - 1;
                miu_push_n_nxt   = 1'b0;
                data_flag_nxt    = 1'b1;
              end
              else begin                         // wait for data ready
                data_cnt_nxt     = data_cnt;
                delta_delay_nxt  = delta_delay + 1;
              end 
            end
            else 
              data_cnt_nxt   = data_cnt - 1;
            if(bm_ras_cnt_max == 0) begin        // t_mas met
              s_cs_nxt_a     = r_chip_slct;
              s_ras_nxt_a    = 1'b0;
              s_we_nxt_a     = 1'b0;
              s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                               {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
              term_cnt_nxt   = r_cas_latency + delta_delay;
              bm_close_all   = 1'b1;
              access_ns      = `R_PREC_DSDC;
              rp_cnt2_nxt    = t_rp_minus_1;
            end
          end
        end 
      end
 
      // immediate precharge after read
      `R_PREC_DSDC: begin
        s_dout_valid_nxt   = 1'b0;
        if(early_term_flag) begin                // early termination
          if(term_cnt == 0 && rp_cnt2 ==0) begin // precharge done, go to idle
            s_rd_end_nxt         = 1'b1;
            burst_done           = 1'b1;
            early_term_flag_nxt  = 1'b0;
            delta_delay_nxt      = 3'b0;
            data_flag_nxt        = 1'b0;
            access_ns            = `IDLE_DSDC;
          end
          else begin                             // wait for t_rp and data
            sdram_access_nxt     = 1'b1;
            if(term_cnt > 0)
              term_cnt_nxt       = term_cnt - 1;
            if(rp_cnt2 > 0)
              rp_cnt2_nxt        = rp_cnt2 - 1;
          end 
        end
        else begin                               // normal termination
          if(data_flag) begin                    // data available
            if(data_cnt > 0) begin
              data_cnt_nxt       = data_cnt - 1;
              miu_push_n_nxt     = 1'b0;
            end
            if(term_cnt ==0 && rp_cnt2==0) begin // precharge done, go to idle
              s_rd_end_nxt       = 1'b1;
              burst_done         = 1'b1;
              delta_delay_nxt    = 3'b0;
              data_flag_nxt      = 1'b0;
              access_ns          = `IDLE_DSDC;
            end
            else begin                           // wait for t_rp and data
              sdram_access_nxt   = 1'b1;
              if(term_cnt > 0)
                term_cnt_nxt     = term_cnt - 1;
              if(rp_cnt2 > 0)
                rp_cnt2_nxt      = rp_cnt2 - 1;
            end
          end
          else begin                             // wait for data valid
            sdram_access_nxt     = 1'b1;
            if(rp_cnt2 > 0)
              rp_cnt2_nxt        = rp_cnt2 - 1;
            if(cas_latency_cnt == 0) begin
              if(!s_ready_valid || (s_ready_valid && s_rd_ready)) 
              begin                              // data available
                miu_push_n_nxt   = 1'b0;
                data_flag_nxt    = 1'b1;
                term_cnt_nxt     = term_cnt - 1;
                data_cnt_nxt     = data_cnt - 1;
              end
              else begin                         // wait for data ready
                term_cnt_nxt     = term_cnt;
                data_cnt_nxt     = data_cnt;
              end
            end
            else begin                           // wait for cas_latency
              data_cnt_nxt       = data_cnt - 1;
              term_cnt_nxt       = (term_cnt > 0) ? (term_cnt-1) : 0;
            end 
          end
        end
      end

      // write state
      `WRITE_DSDC: begin
        sdram_access_nxt      = 1'b1;
        i_col_addr_nxt        = i_col_addr + 2;
        if(r_burst_size == 0) begin              // unspecified-length write
          if(terminate) begin                    // burst early-terminated
            burst_done          = 1'b1; 
            wr_cnt_nxt          = t_wr + 1;
            wtr_cnt_nxt         = t_wtr + 1; 
            if(precharge_algorithm) begin        // delayed precharge
              if(i_col_addr[1] == 1'b0 || write_start == 1'b1) begin
                s_dqm_nxt             = {DATA_WIDTH_BYTE{1'b1}};  
                i_dqs_nxt             = 1'b0;
                dout_valid_flag_nxt   = 1'b1;
                pre_amble_mute_nxt    = 1'b1;
              end
              access_ns        = `IDLE_DSDC;
            end
            else begin                           // immediate precharge
              access_ns        = `W_WR_RAS_DSDC;
              if(i_col_addr[1] == 1'b0 || write_start == 1'b1) begin
                s_dqm_nxt      = {DATA_WIDTH_BYTE{1'b1}}; 
                i_dqs_nxt      = 1'b0;
              end
            end
          end
          else if(ref_req && (bm_ras_cnt_max == 0) && (i_col_addr[1] == 1'b1)
            && (write_start == 1'b0)) begin      // auto refresh request
            r_col_addr_nxt     = i_col_addr + 2;
            wr_cnt_nxt         = t_wr + 1;
            access_ns          = `W_RF_WR_DSDC;
          end
          else begin                             // stay in write state
            miu_pop_n_nxt   = 1'b0;
            i_dqs_nxt       = 1'b0; 
            if(i_col_addr[1] == 1'b1) begin      // new memory burst
              s_cs_nxt_a          = r_chip_slct;
              s_cas_nxt_a         = 1'b0;
              s_we_nxt_a          = 1'b0;
              s_bank_addr_nxt_a   = r_bank_addr;
              s_addr_nxt_a        = (`A8_FOR_PRECHARGE == 1) ? 
                                    {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:8], 
                                    1'b0,i_col_addr_nxt[7:0]} : 
                                    {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:10],
                                    1'b0,i_col_addr_nxt[9:0]};
            end
          end  
        end
        else if(r_wrapped_burst == 1'b1) begin   // wrapped write
          if(terminate) begin                    // burst early-terminated
            burst_done         = 1'b1;
            wr_cnt_nxt         = t_wr + 1;
            wtr_cnt_nxt        = t_wtr + 1;
            if(precharge_algorithm) begin        // delayed precharge
              if(i_col_addr[1] == 1'b0 || write_start == 1'b1) begin
                s_dqm_nxt             = {DATA_WIDTH_BYTE{1'b1}};
                i_dqs_nxt             = 1'b0;
                dout_valid_flag_nxt   = 1'b1;
                pre_amble_mute_nxt    = 1'b1;
              end
              if(cas_cnt > 0)
                access_ns      = `W_POP_DSDC;
              else
                access_ns      = `IDLE_DSDC;
            end
            else begin                           // immediate precharge
              access_ns        = `W_WR_RAS_DSDC;
              if(i_col_addr[1] == 1'b0 || write_start == 1'b1) begin
                s_dqm_nxt   = {DATA_WIDTH_BYTE{1'b1}};
                i_dqs_nxt   = 1'b0;
              end
              if(cas_cnt > 0)
                wrapped_pop_flag_nxt  = 1'b1;
            end
          end
          else begin
            miu_pop_n_nxt   = 1'b0;
            if(cas_cnt > 0) begin                // count for burst size
              cas_cnt_nxt   = cas_cnt - 1;
              i_dqs_nxt     = 1'b0;
              if(i_col_addr[1] == 1'b1) begin    // new memory burst
                s_cs_nxt_a          = r_chip_slct;
                s_cas_nxt_a         = 1'b0;
                s_we_nxt_a          = 1'b0;
                s_bank_addr_nxt_a   = r_bank_addr;
                s_addr_nxt_a        = (`A8_FOR_PRECHARGE == 1) ? 
                                      {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:8], 
                                      1'b0,i_col_addr_nxt[7:0]} : 
                                      {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:10],
                                      1'b0,i_col_addr_nxt[9:0]}; 
              end
              if(cas_cnt == 1)
                burst_done          = 1'b1;
            end
            else begin                           // start the second part 
              s_cs_nxt_a            = r_chip_slct;
              s_cas_nxt_a           = 1'b0;  
              s_bank_addr_nxt_a     = r_bank_addr;
              s_addr_nxt_a          = (`A8_FOR_PRECHARGE == 1) ? 
                                      {col_addr[`MAX_S_ADDR_WIDTH-1:8], 
                                      1'b0,col_addr[7:0]} : 
                                      {col_addr[`MAX_S_ADDR_WIDTH-1:10],
                                      1'b0,col_addr[9:0]}; 
              r_wrapped_burst_nxt   = hiu_wrapped_burst;
              r_burst_size_nxt      = hiu_burst_size;
              r_data_mask_nxt       = data_mask;
              r_col_addr_nxt        = col_addr; 
              i_col_addr_nxt        = col_addr; 
              cas_cnt_nxt           = hiu_burst_size - 1;
              s_we_nxt_a            = 1'b0;
              s_dqm_nxt             = data_mask;
              miu_pop_n_nxt         = 1'b0;
              i_dqs_nxt             = 1'b0;
              write_start_nxt       = 1'b1;
              if(hiu_burst_size == 1)
                burst_done          = 1'b1;
            end
          end
        end
        else begin                               // fixed-length write
          if(terminate) begin                    // burst early-terminated
            wr_cnt_nxt    = t_wr + 1;
            wtr_cnt_nxt   = t_wtr + 1;
            if(precharge_algorithm) begin        // delayed precharge
              if(i_col_addr[1] == 1'b0 || write_start == 1'b1) begin
                s_dqm_nxt             = {DATA_WIDTH_BYTE{1'b1}};
                i_dqs_nxt             = 1'b0;
                dout_valid_flag_nxt   = 1'b1;
                pre_amble_mute_nxt    = 1'b1;
              end
              access_ns        = `IDLE_DSDC;
            end
            else begin                           // immediate precharge
              access_ns        = `W_WR_RAS_DSDC;
              if(i_col_addr[1] == 1'b0 || write_start == 1'b1) begin
                s_dqm_nxt   = {DATA_WIDTH_BYTE{1'b1}};
                i_dqs_nxt   = 1'b0;
              end
            end
            if(cas_cnt > 0)
              burst_done    = 1'b1;
          end
          else begin
            if(cas_cnt > 0) begin                // count for burst size
              miu_pop_n_nxt   = 1'b0;
              i_dqs_nxt       = 1'b0;
              cas_cnt_nxt     = cas_cnt - 1;
              if(i_col_addr[1] == 1'b1) begin    // new memory burst
                s_cs_nxt_a        = r_chip_slct;
                s_cas_nxt_a       = 1'b0;
                s_we_nxt_a        = 1'b0;
                s_bank_addr_nxt_a = r_bank_addr;
                s_addr_nxt_a      = (`A8_FOR_PRECHARGE == 1) ? 
                                    {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:8], 
                                    1'b0,i_col_addr_nxt[7:0]} : 
                                    {i_col_addr_nxt[`MAX_S_ADDR_WIDTH-1:10],
                                    1'b0,i_col_addr_nxt[9:0]}; 
              end
              if(cas_cnt == 1)
                burst_done        = 1'b1;
            end
            else begin                           // burst done
              r_wrapped_burst_nxt   = hiu_wrapped_burst;
              r_burst_size_nxt      = hiu_burst_size;
              r_data_mask_nxt       = data_mask;
              r_bank_addr_nxt       = bank_addr;
              r_row_addr_nxt        = row_addr;
              r_col_addr_nxt        = col_addr;
              i_col_addr_nxt        = col_addr;
              if(hiu_burst_size > 0)
                cas_cnt_nxt         = hiu_burst_size - 1;
              if(power_down || power_down_mode || self_refresh_mode
                || initialize || ref_req) begin  // memory operation request
                wr_cnt_nxt    = t_wr + 1; 
                wtr_cnt_nxt   = t_wtr + 1;
                access_ns     = `IDLE_DSDC;
                if(i_col_addr[1] == 1'b0 || write_start == 1'b1) begin
                  s_dqm_nxt             = {DATA_WIDTH_BYTE{1'b1}}; 
                  i_dqs_nxt             = 1'b0;
                  dout_valid_flag_nxt   = 1'b1;
                  pre_amble_mute_nxt    = 1'b1;
                end
              end
              else if(trans_req && r_chip_slct == chip_slct_n &&
                bm_bank_status[bank_addr] == 1'b1 && open_row_addr == row_addr
                && !hiu_rw) begin                // page hit write
                if(hiu_burst_size == 1) begin
                  access_ns           = `RW_IDLE_DSDC;
                  if(i_col_addr[1] == 1'b0 || write_start == 1'b1) begin
                    s_dqm_nxt             = {DATA_WIDTH_BYTE{1'b1}};
                    i_dqs_nxt             = 1'b0;
                    dout_valid_flag_nxt   = 1'b1;
                    pre_amble_mute_nxt    = 1'b1;
                  end
                end
                else begin
                  s_cs_nxt_a          = r_chip_slct;
                  s_cas_nxt_a         = 1'b0;
                  s_bank_addr_nxt_a   = bank_addr;
                  s_addr_nxt_a        = (`A8_FOR_PRECHARGE == 1) ? 
                                        {col_addr[`MAX_S_ADDR_WIDTH-1:8], 
                                        1'b0,col_addr[7:0]} : 
                                        {col_addr[`MAX_S_ADDR_WIDTH-1:10],
                                        1'b0,col_addr[9:0]}; 
                  s_we_nxt_a          = 1'b0;
                  miu_pop_n_nxt       = 1'b0; 
                  write_start_nxt     = 1'b1;
                  s_dqm_nxt           = data_mask;
                  i_dqs_nxt           = 1'b0;
                end
              end      
              else begin
                wr_cnt_nxt      = t_wr + 1;
                wtr_cnt_nxt     = t_wtr + 1;
                if(precharge_algorithm) begin    // delayed precharge
                  if(i_col_addr[1] == 1'b0 || write_start == 1'b1) begin
                    s_dqm_nxt             = {DATA_WIDTH_BYTE{1'b1}};
                    i_dqs_nxt             = 1'b0;
                    dout_valid_flag_nxt   = 1'b1;
                    pre_amble_mute_nxt    = 1'b1;
                  end
                  access_ns        = `IDLE_DSDC;
                end
                else begin                       // immediate precharge
                  access_ns        = `W_WR_RAS_DSDC;
                  if(i_col_addr[1] == 1'b0 || write_start == 1'b1) begin
                    s_dqm_nxt   = {DATA_WIDTH_BYTE{1'b1}};
                    i_dqs_nxt   = 1'b0;
                  end
                end
              end
            end 
          end 
        end 
      end

      // pop the second part of a wrapped write
      `W_POP_DSDC: begin
        burst_done              = 1'b1;
        access_ns               = `IDLE_DSDC;
        wtr_cnt_nxt             = wtr_cnt - 1;
        dout_valid_flag_nxt     = dout_valid_flag;
        wr_cnt_nxt              = wr_cnt - 1;
      end 

      // wait for t_wr and t_ras_min before precharge
      `W_WR_RAS_DSDC: begin
        sdram_access_nxt = 1'b1;
        if(wrapped_pop_flag)
          burst_done     = 1'b1;
        if(wr_cnt == 0 && bm_ras_cnt_max == 0) 
        begin                                    // t_wr and t_ras met
          if(`EBI_INTERFACE == 1 && `ENABLE_ADDRBUS_SHARING == 0)
          begin                                  // request for EBI
            ebi_prech_req_nxt_a    = 1'b1;
            if(sdram_ebi_gnt & ebi_prech_req_a) begin // EBI granted  
              s_cs_nxt_a     = r_chip_slct;
              s_ras_nxt_a    = 1'b0;
              s_we_nxt_a     = 1'b0;
              s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                               {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
              bm_close_all   = 1'b1;
              access_ns      = `W_PREC_DSDC;
              rp_cnt2_nxt    = t_rp_minus_1;
            end
          end
          else begin 
            s_cs_nxt_a     = r_chip_slct;
            s_ras_nxt_a    = 1'b0;
            s_we_nxt_a     = 1'b0;
            s_addr_nxt_a   = (`A8_FOR_PRECHARGE == 1) ?
                             {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}};
            bm_close_all   = 1'b1;
            access_ns      = `W_PREC_DSDC;
            rp_cnt2_nxt    = t_rp_minus_1;
          end
        end
        else begin                               // wait for t_wr / t_ras
          if(wr_cnt > 0)
            wr_cnt_nxt   = wr_cnt - 1;
        end
      end

      // immediate precharge after write
      `W_PREC_DSDC: begin
        if(rp_cnt2 == 0)                         // precharge done, go to idle
          access_ns     = `IDLE_DSDC;
        else                                     // wait for t_rp
          rp_cnt2_nxt   = rp_cnt2 - 1;
      end

      // write recovery for write interupted by auto refresh
      `W_RF_WR_DSDC: begin
        sdram_access_nxt       = 1'b1;
        if(wr_cnt == 0) begin                    // t_wr met, go to precharge
          s_cs_nxt_a           = {`N_CS{1'b0}};
          s_ras_nxt_a          = 1'b0;
          s_we_nxt_a           = 1'b0;
          s_addr_nxt_a         = (`A8_FOR_PRECHARGE == 1) ?
                                 {1'b1, {8{1'b0}}} : {1'b1, {10{1'b0}}}; 
          bm_close_all         = 1'b1;
          access_ns            = `INT_RF_PREC_DSDC;
          rp_cnt2_nxt          = t_rp;
        end
        else
          wr_cnt_nxt           = wr_cnt - 1;
      end

      // precharge for auto refresh during unspecified-length burst
      `INT_RF_PREC_DSDC: begin
        sdram_access_nxt      = 1'b1;
        if(r_rw == 1'b1) begin                   // read interrupted 
          s_dout_valid_nxt    = 1'b0;
          if(term_cnt == 0) begin
            if(rp_cnt2 == 0) begin               // go to refresh state
              s_cs_nxt_a         = {`N_CS{1'b0}};
              s_ras_nxt_a        = 1'b0;
              s_cas_nxt_a        = 1'b0;
              s_rd_end_nxt       = 1'b1;
              delta_delay_nxt    = 3'b0;
              data_flag_nxt      = 1'b0;
              ref_ack_nxt_a      = 1'b1;
              rcar_cnt2_nxt      = t_rcar;
              if(terminate) begin
                burst_done       = 1'b1;
                access_ns        = `AUTO_REF_DSDC;
              end
              else
                access_ns        = `INT_REF_DSDC;
            end
            else                                 // wait for t_rp
              rp_cnt2_nxt        = rp_cnt2 - 1;
          end
          else begin                             // wait for residue data
            term_cnt_nxt         = term_cnt - 1;
            miu_push_n_nxt       = 1'b0;
            if(rp_cnt2 > 0)
              rp_cnt2_nxt        = rp_cnt2 - 1;
          end
        end
        else begin                               // write interrupted 
          if(rp_cnt2 == 0) begin                 // go to refresh state
            s_cs_nxt_a         = {`N_CS{1'b0}};
            s_ras_nxt_a        = 1'b0;
            s_cas_nxt_a        = 1'b0;
            ref_ack_nxt_a      = 1'b1;
            rcar_cnt2_nxt      = t_rcar;
            access_ns          = `INT_REF_DSDC;
          end
          else                                   // wait for t_rp
            rp_cnt2_nxt        = rp_cnt2 - 1;
        end 
      end
      
      // auto refresh during unspecified-length burst
      `INT_REF_DSDC: begin
        sdram_access_nxt      = 1'b1;
        if(rcar_cnt2 == 0) begin                 // refresh done, resume burst
          s_cs_nxt_a                = r_chip_slct;
          s_ras_nxt_a               = 1'b0;
          s_bank_addr_nxt_a         = r_bank_addr;
          s_addr_nxt_a              = r_row_addr;
          load_rcd_cnt              = 1'b1;
          bm_open_bank[bank_addr]   = 1'b1; 
          bm_open_any               = 1'b1;
          bm_row_addr_nxt           = r_row_addr;
          access_ns                 = `ACT_DSDC;
        end
        else
          rcar_cnt2_nxt             = rcar_cnt2 - 1;
      end  
    
      // default state 
      default: 
        access_ns     = `IDLE_DSDC; 
    endcase
  end
  // leda W456 on
  // leda C_2C_R on
  // leda W456 on

  //-------------------------------------------------------------------
  // SDRAM timing counters
  //-------------------------------------------------------------------
  // cas latency counter 
  always @(posedge hclk or negedge hresetn) begin
    if(hresetn == 1'b0) 
      cas_latency_cnt     <= 4'b0;
    else begin
      if(load_cas_latency_cnt)
        cas_latency_cnt   <= cas_latency;
      else if(cas_latency_cnt > 0)
        cas_latency_cnt   <= cas_latency_cnt - 1;
      else
        cas_latency_cnt   <= cas_latency_cnt;
    end
  end

  // t_rcd counter
  always @(posedge hclk or negedge hresetn) begin
    if(hresetn == 1'b0) 
      rcd_cnt     <= 3'b0;
    else begin
      if(load_rcd_cnt)
        rcd_cnt   <= t_rcd;
      else if(rcd_cnt > 0)
        rcd_cnt   <= rcd_cnt - 1;
      else
        rcd_cnt   <= rcd_cnt;
    end
  end  

  // t_xsr counter
  always @(posedge hclk or negedge hresetn) begin
    if(hresetn == 1'b0)
      xsr_cnt     <= 9'b0;
    else begin
      if(load_xsr_cnt)
        xsr_cnt   <= t_xsr;
      else if(xsr_cnt > 0)
        xsr_cnt   <= xsr_cnt - 1;
      else
        xsr_cnt   <= xsr_cnt;
    end
  end

  // t_mrd counter
  always @(posedge hclk or negedge hresetn) begin
    if(hresetn == 1'b0)
      mrd_cnt     <= 2'b0;
    else begin
      if(load_mrd_cnt)
        mrd_cnt   <= `T_MRD_DSDC;
      else if(mrd_cnt > 0)
        mrd_cnt   <= mrd_cnt - 1;
      else
        mrd_cnt   <= mrd_cnt;
    end
  end

  // t_init counter
  always @(posedge hclk or negedge hresetn) begin
    if(hresetn == 1'b0)
      init_cnt     <= 16'b0;
    else begin
      if(load_init_cnt)
        init_cnt   <= t_init;
      else if(init_cnt > 0)
        init_cnt   <= init_cnt - 1;
      else
        init_cnt   <= init_cnt;
    end
  end

  // mask signal for the DDR-SDRAM dqs signal
  always @(posedge hclk or negedge hresetn) begin
    if(hresetn == 1'b0)
      pre_rd_dqs_mask   <= 1'b0;
    else begin
      if(s_rd_start)
        pre_rd_dqs_mask <= 1'b1;
      else if(hiu_terminate | dqs_mask_end)
        pre_rd_dqs_mask <= 1'b0; 
      else
        pre_rd_dqs_mask <= pre_rd_dqs_mask;
    end
  end

   // t_xp counter
   assign t_xp = `T_XP - 2;
   assign t_xp_load = ({operation_cs, operation_ns} == {POWER_DOWN_DSDC, PD_EXIT_WAIT_DSDC}) ?
                      1'b1 : 1'b0;
   always @(posedge hclk or negedge hresetn)
   begin: t_xp_cnt_SEQ_PROC
      if(hresetn == 1'b0)
        t_xp_cnt <= 3'b0;
      else begin
         if (t_xp_load)
           t_xp_cnt <= t_xp;
         else if (t_xp_cnt > 0)
           t_xp_cnt <= t_xp_cnt - 1;
         else
           t_xp_cnt <= t_xp_cnt;
      end
   end   
   assign t_xp_expired = (t_xp_cnt==0) ? 1'b1: 1'b0;
   
   
  //--------------------------------------------------------------
  // internal control signals
  //--------------------------------------------------------------  
  assign pre_dqs          = i_dqs & i_dqs_d;
  assign num_row          = (1 << (s_row_addr_width + 1)) - 1;
  assign cas_latency      = i_cas_latency + (read_pipe + `WRITE_PIPE);
  assign miu_burst_done   = burst_done;

  // cas latency decoding
  always @(t_cas_latency) begin
    case(t_cas_latency)
      3'b001: i_cas_latency    = 1;
      3'b010: i_cas_latency    = 2;
      3'b100: i_cas_latency    = 4;
      3'b101: i_cas_latency    = 2;
      3'b111: i_cas_latency    = 4;
      default: i_cas_latency   = 3;
    endcase
  end

  // EBI handling 
  assign sdram_ebi_req  = hiu_req | hiu_req_d | ebi_req_op | ebi_prech_req_a; 
  assign trans_req      = (`EBI_INTERFACE == 1) ? (hiu_req & sdram_ebi_gnt) :
                          hiu_req;

  //-------------------------------------------------------------------------
  //                      page bank management
  // The following logic keeps track of the status and timing information
  // of each SDRAM bank, which is used by the state machine to make decision.
  //-------------------------------------------------------------------------
  always @(posedge hclk or negedge hresetn) begin: PROCESS_8
    integer i;
    if(hresetn == 1'b0) begin
      bm_ras_cnt_max       <= 4'b0;
      bm_num_open_bank     <= 5'b0;
      for(i=0; i<(1<<`MAX_S_BANK_ADDR_WIDTH); i=i+1) begin
        bm_ras_cnt[i]      <= 4'b0;
        bm_rc_cnt[i]       <= 4'b0;
        bm_row_addr[i]     <= {`MAX_S_ADDR_WIDTH{1'b0}};
        bm_bank_status[i]  <= 1'b0;
      end
    end
    else begin
      bm_ras_cnt_max       <= bm_open_any ? t_ras_min :
                              (bm_ras_cnt_max > 0) ? bm_ras_cnt_max - 1 :
                              bm_ras_cnt_max;
      bm_num_open_bank     <= bm_open_any ? bm_num_open_bank + 1 :
                              bm_close_all ? 0 :
                              bm_close_any ? bm_num_open_bank - 1 :
                              bm_num_open_bank;
      for(i=0; i<(1<<`MAX_S_BANK_ADDR_WIDTH); i=i+1) begin
        bm_ras_cnt[i]      <= bm_open_bank[i] ? t_ras_min :
                              (bm_ras_cnt[i] == 0) ? 0 : bm_ras_cnt[i] - 1;
        bm_rc_cnt[i]       <= bm_open_bank[i] ? t_rc :
                              (bm_rc_cnt[i] == 0) ? 0 : bm_rc_cnt[i] - 1; 
        bm_row_addr[i]     <= bm_open_bank[i] ? bm_row_addr_nxt : 
                              bm_row_addr[i];
        bm_bank_status[i]  <= bm_open_bank[i] ? 1'b1 :
                              (bm_close_bank[i] || bm_close_all) ? 1'b0 : 
                              bm_bank_status[i];
      end
    end
  end

// leda FM_1_2 off // Usage of complex arithmetic operations. Coding style
// leda W468 off // Index variable is too short. bm_bank_age[r_close_bank_addr] 
  always @(posedge hclk or negedge hresetn) begin: PROCESS_9
    integer j;
    if(hresetn == 1'b0) begin
      for(j=0; j<16; j=j+1)
        bm_bank_age[j]     <= 5'b0;
    end
    else begin
      for(j=0; j<16; j=j+1) begin
        if(|r_bm_open_bank)
          bm_bank_age[j] <= r_bm_open_bank[j] ? 5'b1 :
                            !ext_bank_status[j] ? 5'b0 : bm_bank_age[j]+1;
        else if(r_bm_close_all)
          bm_bank_age[j] <= 5'b0;
        else if(|r_bm_close_bank)
          bm_bank_age[j] <= r_bm_close_bank[j] ? 5'b0 :
                           !ext_bank_status[j] ? 5'b0 :
                           (bm_bank_age[j] > bm_bank_age[r_close_bank_addr]) ?
                           bm_bank_age[j]-1 : bm_bank_age[j];
        else
          bm_bank_age[j] <= bm_bank_age[j];
      end
    end
  end
// leda W468 on
// leda FM_1_2 on

  assign open_row_addr         = bm_row_addr[bank_addr];
  assign current_ras_cnt       = bm_ras_cnt[bank_addr];
  assign current_rc_cnt        = bm_rc_cnt[bank_addr];
  assign oldest_bank_ras_cnt   = bm_ras_cnt[oldest_bank];
  assign ext_bank_status       = bm_bank_status;

  assign joint_bank_age = {bm_bank_age[15], bm_bank_age[14], bm_bank_age[13],
                           bm_bank_age[12], bm_bank_age[11], bm_bank_age[10],
                           bm_bank_age[9],  bm_bank_age[8],  bm_bank_age[7],
                           bm_bank_age[6],  bm_bank_age[5],  bm_bank_age[4],
                           bm_bank_age[3],  bm_bank_age[2],  bm_bank_age[1],
                           bm_bank_age[0]};

  assign comb_lsb_age = {joint_bank_age[77:75], joint_bank_age[72:70],
                         joint_bank_age[67:65], joint_bank_age[62:60],
                         joint_bank_age[57:55], joint_bank_age[52:50],
                         joint_bank_age[47:45], joint_bank_age[42:40],
                         joint_bank_age[37:35], joint_bank_age[32:30],
                         joint_bank_age[27:25], joint_bank_age[22:20],
                         joint_bank_age[17:15], joint_bank_age[12:10],
                         joint_bank_age[7:5],   joint_bank_age[2:0]};

  DW_memctl_bcm01
   #(3, MAX_NUM_BANK, `MAX_S_BANK_ADDR_WIDTH) U_minmax1_dwbb 
                                           (.a(comb_lsb_age[MAX_NUM_BANK*3-1:0]),
                                           .tc(1'b0),
                                           .min_max(1'b1),
                                           .value(oldest_age),
                                           .index(oldest_bank));
   
endmodule
