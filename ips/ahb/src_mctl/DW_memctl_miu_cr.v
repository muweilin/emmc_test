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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_miu_cr.v $ 
// $Revision: #4 $
//
// Abstract  : This module holds the Timing and control registers for the
// SDRAM controller as well as the registers for chip selcts. This module is
// always enabled irrespective of the parameter ENABLE_SDRAM
//
//============================================================================
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
  module DW_memctl_miu_cr (
                         hclk,
                         hresetn,                
                         hiu_reg_req,               
                         hiu_rw,                  
                         hiu_addr,               
                         hiu_burst_size,
                         hiu_data_mask,           
                         init_done,              
                         sync_fl_pdr_done,
                         clear_self_ref_rp,
                         clear_sf_dp,
                         mode_reg_done,
                         sf_mode_reg_done,
                         exn_mode_reg_done,
                         clear_fl_op,
                         big_endian,
                         smcr_selected,
                         sd_in_dpd_mode,
                           //Data Inputs
                         hiu_wr_data,             
                           //Control Outputs
                         req_done,                
                         push_n,    
                         pop_n,    
                         do_self_ref_rp,         
                         do_initialize,           
                         do_power_down,           
                         delayed_precharge,      
                         ref_all_before_sr, 
                         ref_all_after_sr,      
                         row_addr_width,        
                         col_addr_width,        
                         bank_addr_width,      
                         sdram_data_width, 
                         s_data_width_early, 
                         mask_reg0,          
                         mask_reg1,        
                         mask_reg2,       
                         mask_reg3,      
                         mask_reg4,     
                         mask_reg5,    
                         mask_reg6,   
                         mask_reg7,  
                         cas_latency, 
                         t_ras_min,           
                         t_rcd, 
                         t_rp,  
                         t_wr, 
                         t_rcar, 
                         t_xsr,
                         t_init, 
                         num_init_ref,                          
                         t_rc,  
                         t_ref, 
                         chipsel_register0,
                         chipsel_register1,
                         chipsel_register2,
                         chipsel_register3,
                         chipsel_register4,
                         chipsel_register5,
                         chipsel_register6,
                         chipsel_register7,
                         alias_register0, 
                         alias_register1,
                         remap_register0,  
                         remap_register1, 
                         s_sa,   
                         s_scl,  
                         s_sda_in,
                         s_sda_out, 
                         s_sda_oe_n, 
                         read_pipe,
                         mode_reg_update,
                         software_sequence,
                         sd_in_sf_mode,
                         sf_in_dp_mode,
                         sf_trpdr,
                         exn_mode_value,
                         exn_mode_reg_update,
                         operation_code,
                         flash_operation,
                         num_open_banks,
                         s_ready_valid,
                         t_wtr,
                         gpi,
                         gpo,
                         sf_t_rcd,
                         sf_cas_latency,
                         sf_t_rc,
                         sf_row_addr_width,
                         sf_col_addr_width,
                         sf_bank_addr_width,
                         do_sf_power_down,
                         do_sf_deep_pwr_dn,
                         sf_mode_reg_update,
                         mobile_sdram_dpd_en,
                         //Data outputs
                         wr_data2_smcr,
                         mask2_smcr,
                         rd_data_out
                         );

  input                        hclk;             // AHB Clock            
  input                        hresetn;          // AHB Asynchronous Reset.
  input                        hiu_reg_req;      // Reg access request from HIU
  input                        hiu_rw;           // Register Read/Write fromHIU
  input  [7:0]                 hiu_addr;         // Register address from HIU. 
  input  [5:0]                 hiu_burst_size;   // Burst size from HIU.
  input                        init_done;        // Initialize done from ctl
  input                        sync_fl_pdr_done; // SyncFlash power down done.
  input                        clear_self_ref_rp;// Clears sctlr[1]
  input                        clear_sf_dp;      // Clears sfctlr[1]
  input                        big_endian;       // Endianness selection
  input                        smcr_selected;    // SMCR registers selected
  input                        mode_reg_done;    // Mode reg update done
  input                        sf_mode_reg_done; // Clears sfctlr[2]
  input                        exn_mode_reg_done;// Exn mode reg update done
  input                        clear_fl_op;      // Clears the flash_op bit
  output                       req_done;         // Read/Write transfer done   
  output                       push_n;           // Push signal to hiu for read
  output                       pop_n;            // Pop signal to HIU for write
  output                       do_self_ref_rp;   // Self Refresh request to sdc
  output                       do_initialize;    // Init req to sdc
  output                       do_power_down;    // Power down req to sdc
  output [3:0]                 row_addr_width;   // Row_addr_width programmed
  output [3:0]                 col_addr_width;   // col_addr_width programmed
  output [1:0]                 bank_addr_width;  // bank_addr_width prog
  output [1:0]                 sdram_data_width; // Programmed value
  output [10:0]                mask_reg0;        // Chip Slelct0 mask register
  output [10:0]                mask_reg1;        // Chip Select1 mask register
  output [10:0]                mask_reg2;        // Chip Select2 mask register
  output [10:0]                mask_reg3;        // Chip Select3 mask register
  output [10:0]                mask_reg4;        // Chip select4 mask register
  output [10:0]                mask_reg5;        // Chip select5 mask register
  output [10:0]                mask_reg6;        // Chip select6 mask register
  output [10:0]                mask_reg7;        // Chip select7 mask register
  output [2:0]                 cas_latency;      // cas latency info to DMC
  output [3:0]                 t_ras_min;        // Active to Precharge Mintime
  output [2:0]                 t_rcd;            // ACTIVE to RD or WR delay
  output [2:0]                 t_rp;             // Precharge period
  output [1:0]                 t_wr;             // Last Data in to precharge
  output [3:0]                 t_rcar;           // Auto refresh period
  output [8:0]                 t_xsr;            // Self Refresh Exit time
  output [15:0]                t_init;           // SDRAM Initialisation time
  output [3:0]                 num_init_ref;     // Inital auto refresh
  output [3:0]                 t_rc;             // Active to Active Cmd period
  output [15:0]                t_ref;            // Num of cycles between ref
  output [2:0]                 s_sa;             // SPD address
  output                       s_scl;            // SPD clock
  output                       s_sda_out;        // SPD Data out
  output                       s_sda_oe_n;       // SPD Output Enable
  input                        s_sda_in;         // SPD  Data in
  output [`H_ADDR_WIDTH-1:16]  chipsel_register0;// Chip Select register 0
  output [`H_ADDR_WIDTH-1:16]  chipsel_register1;// Chip Select register 1   
  output [`H_ADDR_WIDTH-1:16]  chipsel_register2;// Chip Select register 2  
  output [`H_ADDR_WIDTH-1:16]  chipsel_register3;// Chip Select register 3   
  output [`H_ADDR_WIDTH-1:16]  chipsel_register4;// Chip Select register 4   
  output [`H_ADDR_WIDTH-1:16]  chipsel_register5;// Chip Select register 5   
  output [`H_ADDR_WIDTH-1:16]  chipsel_register6;// Chip Select register 6   
  output [`H_ADDR_WIDTH-1:16]  chipsel_register7;// Chip Select register 7   
  output [`H_ADDR_WIDTH-1:16]  alias_register0;  // Alias register 0
  output [`H_ADDR_WIDTH-1:16]  alias_register1;  // Alias register 1
  output [`H_ADDR_WIDTH-1:16]  remap_register0;  // Remap register 0
  output [`H_ADDR_WIDTH-1:16]  remap_register1;  // Remap register 1
  input  [`S_RD_DATA_WIDTH-1:0  ] hiu_wr_data;  // Register wr data from HIU
  input  [`H_DATA_WIDTH/8-1:0] hiu_data_mask;    // Mask signal from HIU.
  output [`S_RD_DATA_WIDTH-1:0  ] rd_data_out;  // Register read data from HIU
  output                       delayed_precharge;// Delayed precharge to sdc
  output                       ref_all_before_sr;// Controls ref before
  output                       ref_all_after_sr; // Controls ref after sr
  output [2:0]                 read_pipe;        // Read pipe programmed value
  output                       mode_reg_update;  // Update mode register
  output                       software_sequence;// Software pmg for SyncFl
  input                        sd_in_sf_mode;    // Indicates SDRAM in Selfref
  input                        sf_in_dp_mode;    // Valid only in SDRM+SF mode
  output [15:0]                sf_trpdr;         // SyncFlash trpdr register
  output [12:0]                exn_mode_value;   // EXN_MODE_REG value
  output [11:0]                operation_code;   // SYFLASH copcode
  output                       flash_operation;  // SyFlash Operation
  output [4:0]                 num_open_banks;   // Number of banks open
  output                       s_ready_valid;    // Use s_ready to latch data
  output [1:0]                 t_wtr;            // Write to read delay for DDR
  output [31:0]                wr_data2_smcr;    // Register write data to SMCR
  output [3:0]                 mask2_smcr;       // Write data mask to SMCR
  input [7:0]                  gpi;              // GPI's
  output [7:0]                 gpo;              // GPO's
  output [1:0]                 s_data_width_early;  // To sdc
  output                       exn_mode_reg_update; // Update Exn mode register
  output [2:0]                 sf_t_rcd;        // Only in SyncFlash-SDRAM mode
  output [2:0]                 sf_cas_latency;  // Only in SyncFlash-SDRAM mode
  output [3:0]                 sf_t_rc;         // Only in SyncFlash-SDRAM mode
  output [3:0]                 sf_row_addr_width;//Only in SyncFlash-SDRAM mode
  output [3:0]                 sf_col_addr_width;//Only in SyncFlash-SDRAM mode
  output [1:0]                 sf_bank_addr_width;//Only in SyncFlash-SDRAM mode
  output                       do_sf_power_down; //Only in SyncFlash-SDRAM mode
  output                       do_sf_deep_pwr_dn; //Only in SyncFlash-SDRAM mode
  output                       sf_mode_reg_update;//Only in SyncFlash-SDRAM mode

  // Mobile-DDR specific
  output                       mobile_sdram_dpd_en; // DPD enable
  input                        sd_in_dpd_mode;      // DPD status
           
  reg l_half_word;
  reg m_half_word;
  reg rd_l_half_word;
  reg rd_m_half_word;
  reg [2:0] cr_ns;
  reg [2:0] cr_cs;
  reg [20:0] sconr;
  reg [31:0] stmg0r;
  reg [21:0] stmg1r;
  reg [20:0] sctlr;
  reg [12:0]  syflash_opcode;
  reg [12:0] exn_mode_reg;
  reg [31:0] srefr;
  reg [`H_ADDR_WIDTH-1:0] scslr0;
  reg [`H_ADDR_WIDTH-1:0] scslr1;
  reg [`H_ADDR_WIDTH-1:0] scslr2;
  reg [`H_ADDR_WIDTH-1:0] scslr3;
  reg [`H_ADDR_WIDTH-1:0] scslr4;
  reg [`H_ADDR_WIDTH-1:0] scslr5;
  reg [`H_ADDR_WIDTH-1:0] scslr6;
  reg [`H_ADDR_WIDTH-1:0] scslr7;
  reg [`H_ADDR_WIDTH-1:0] csalias0;
  reg [`H_ADDR_WIDTH-1:0] csalias1;
  reg [`H_ADDR_WIDTH-1:0] csremap0;
  reg [`H_ADDR_WIDTH-1:0] csremap1;
  reg [10:0] smskr0;
  reg [10:0] smskr1;
  reg [10:0] smskr2;
  reg [10:0] smskr3;
  reg [10:0] smskr4;
  reg [10:0] smskr5;
  reg [10:0] smskr6;
  reg [10:0] smskr7;
  reg [9:0] sfconr;
  reg [4:0]  sfctlr;
  reg [9:0] sftmgr;
  reg pop_n;
  reg push_n_int;
  reg req_done;
  reg s_sda_d;
  reg s_sda_d1;
  reg cr_wr;
  reg [1:0] sdram_data_width ;
  reg [31:0] cs_reg_data_out ;
  reg [63:0] h_wr_data_int1;
  reg [31:0] h_wr_data_int;
  reg [31:0] h_wr_data_i;
  reg [63:0] h_rd_data_int1;
  reg [127:0] h_rd_data_int;
  reg [7:0] h_mask_int1;
  reg [3:0] h_mask_int;
  reg [3:0] h_mask_i;
  reg [1:0] s_data_width_early;
  reg [31:0] reg_rd_data_out ;
  reg [4:0] open_banks_o;
  reg [2:0] cas_latency_o;
  reg [2:0] sf_cas_latency_o;
  reg disable_dw_write;


  //---------------------------------------------------
  // Dummy select signal for Register address above A4
  //---------------------------------------------------

  wire dummy_sel ;

  //-------------------------------------------------
  // Select signals for SCONR l_sel - lower 16 bits
  // select is used 16 bit . h_sel is upper 16 bits
  //------------------------------------------------

  wire sconr_sel ;
  wire sconr_l_sel;
  wire sconr_h_sel ;

  //-------------------------------------------------
  // Select signals for SFCONR l_sel - lower 16 bits
  //------------------------------------------------

  wire sfconr_sel ;
  wire sfconr_l_sel;

  //-------------------------------------------------
  // Select signals for SFCTLR l_sel - lower 16 bits
  //------------------------------------------------

  wire sfctlr_sel ;
  wire sfctlr_l_sel;


  //-------------------------------------------------
  // Select signals for STMG0R l_sel - lower 16 bits
  // select is used 16 bit . h_sel is upper 16 bits
  //------------------------------------------------

  wire stmg0r_sel ;
  wire stmg0r_l_sel;
  wire stmg0r_h_sel;

  //-------------------------------------------------
  // Select signals for SFTMGR l_sel - lower 16 bits
  // select is used 16 bit . h_sel is upper 16 bits
  //------------------------------------------------

  wire sftmgr_sel ;
  wire sftmgr_l_sel;
  wire sftmgr_h_sel;

  //-------------------------------------------------
  // Select signals for STMG0R l_sel - lower 16 bits
  // select is used 16 bit . h_sel is upper 16 bits
  //------------------------------------------------

  wire stmg1r_sel;
  wire stmg1r_l_sel;
  wire stmg1r_h_sel;

  //-------------------------------------------------
  // Select signals for SCTLR l_sel - lower 16 bits
  //------------------------------------------------

  wire sctlr_sel;
  wire sctlr_l_sel;
  wire sctlr_h_sel;

  // ------------------------------------------------
  // Select signals for SREDR. l_sel and h_sel are 
  // used during 16 bit read/write
  // ------------------------------------------------

  wire srefr_sel;
  wire srefr_l_sel;
  wire srefr_h_sel;

  // ------------------------------------------------
  // Select signals for SCSLR0 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire scslr0_low_sel;
  wire scslr0_low_h_sel;
  wire scslr0_low_l_sel;
  wire scslr0_high_sel;
  wire scslr0_high_l_sel;
  wire scslr0_high_h_sel;

  // ------------------------------------------------
  // Select signals for SCSLR1 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire scslr1_low_sel;
  wire scslr1_low_h_sel;
  wire scslr1_low_l_sel;
  wire scslr1_high_sel;
  wire scslr1_high_l_sel;
  wire scslr1_high_h_sel;

  // ------------------------------------------------
  // Select signals for SCSLR2 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire scslr2_low_sel;
  wire scslr2_low_h_sel;
  wire scslr2_low_l_sel;
  wire scslr2_high_sel;
  wire scslr2_high_l_sel;
  wire scslr2_high_h_sel;

  // ------------------------------------------------
  // Select signals for SCSLR3 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire scslr3_low_sel;
  wire scslr3_low_h_sel;
  wire scslr3_low_l_sel;
  wire scslr3_high_sel;
  wire scslr3_high_l_sel;
  wire scslr3_high_h_sel;

  // ------------------------------------------------
  // Select signals for SCSLR4 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire scslr4_low_sel;
  wire scslr4_low_h_sel;
  wire scslr4_low_l_sel;
  wire scslr4_high_sel;
  wire scslr4_high_l_sel;
  wire scslr4_high_h_sel;

  // ------------------------------------------------
  // Select signals for SCSLR5 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire scslr5_low_sel;
  wire scslr5_low_h_sel;
  wire scslr5_low_l_sel;
  wire scslr5_high_sel;
  wire scslr5_high_l_sel;
  wire scslr5_high_h_sel;

  // ------------------------------------------------
  // Select signals for SCSLR6 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire scslr6_low_sel;
  wire scslr6_low_h_sel;
  wire scslr6_low_l_sel;
  wire scslr6_high_sel;
  wire scslr6_high_l_sel;
  wire scslr6_high_h_sel;

  // ------------------------------------------------
  // Select signals for SCSLR7 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire scslr7_low_sel;
  wire scslr7_low_h_sel;
  wire scslr7_low_l_sel;
  wire scslr7_high_sel;
  wire scslr7_high_l_sel;
  wire scslr7_high_h_sel;

  // ------------------------------------------------
  // Select signals for CSALIAS0 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire csalias0_low_sel;
  wire csalias0_low_h_sel;
  wire csalias0_low_l_sel;
  wire csalias0_high_sel;
  wire csalias0_high_l_sel;
  wire csalias0_high_h_sel;

  // ------------------------------------------------
  // Select signals for CSALIAS1 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire csalias1_low_sel;
  wire csalias1_low_h_sel;
  wire csalias1_low_l_sel;
  wire csalias1_high_sel;
  wire csalias1_high_l_sel;
  wire csalias1_high_h_sel;

  // ------------------------------------------------
  // Select signals for CSREMAP0 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire csremap0_low_sel;
  wire csremap0_low_h_sel;
  wire csremap0_low_l_sel;
  wire csremap0_high_sel;
  wire csremap0_high_l_sel;
  wire csremap0_high_h_sel;

  // ------------------------------------------------
  // Select signals for CSREMAP1 l_sel and h_sel are
  // used during 16 bit read/write
  // ------------------------------------------------

  wire csremap1_low_sel;
  wire csremap1_low_h_sel;
  wire csremap1_low_l_sel;
  wire csremap1_high_sel;
  wire csremap1_high_l_sel;
  wire csremap1_high_h_sel;

  //-------------------------------------------------
  // Select signals for Component Identification
  // Registers
  //------------------------------------------------

   wire memctl_comp_type_sel;
   wire memctl_comp_version_sel;
   wire memctl_comp_params_1_sel;
   wire memctl_comp_params_2_sel;
   

  //-----------------------------------------
  // Selects for Mask Registers
  //-----------------------------------------


  wire smskr0_sel;
  wire smskr0_l_sel;

  wire smskr1_sel;
  wire smskr1_l_sel;

  wire smskr2_sel;
  wire smskr2_l_sel;

  wire smskr3_sel;
  wire smskr3_l_sel;

  wire smskr4_sel;
  wire smskr4_l_sel;

  wire smskr5_sel;
  wire smskr5_l_sel;

  wire smskr6_sel;
  wire smskr6_l_sel;

  wire smskr7_sel;
  wire smskr7_l_sel;

  wire push_n;
  wire cr_reg_sel;
  wire cr_rd;
  wire do_self_ref_rp;     
  wire do_sf_power_down;
  wire do_sf_deep_pwr_dn;
  wire do_initialize;     
  wire do_power_down;                                  
  wire delayed_precharge;  
  wire init_done;  
  wire [3:0] row_addr_width;        
  wire [3:0] col_addr_width;       
  wire [1:0] bank_addr_width;      
  wire [2:0] cas_latency;     
  wire [3:0] t_ras_min;           
  wire [2:0] t_rcd;           
  wire [2:0] t_rp;                
  wire [1:0] t_wr;                 
  wire [3:0] t_rcar;                       
  wire [8:0] t_xsr;                          
  wire [15:0] t_init;                                
  wire [3:0] num_init_ref;               
  wire [3:0] t_rc;       
  wire [15:0] t_ref;                
  wire [2:0]  sf_t_rcd;   
  wire [2:0]  sf_cas_latency;
  wire [3:0]  sf_t_rc;    
  wire [3:0] sf_row_addr_width;
  wire [3:0] sf_col_addr_width;
  wire [1:0] sf_bank_addr_width;


  wire [`H_ADDR_WIDTH-1:16] chipsel_register0;
  wire [`H_ADDR_WIDTH-1:16] chipsel_register1;       
  wire [`H_ADDR_WIDTH-1:16] chipsel_register2;      
  wire [`H_ADDR_WIDTH-1:16] chipsel_register3;      
  wire [`H_ADDR_WIDTH-1:16] chipsel_register4;      
  wire [`H_ADDR_WIDTH-1:16] chipsel_register5;      
  wire [`H_ADDR_WIDTH-1:16] chipsel_register6;      
  wire [`H_ADDR_WIDTH-1:16] chipsel_register7;
  wire [`H_ADDR_WIDTH-1:16] alias_register0;
  wire [`H_ADDR_WIDTH-1:16] alias_register1;
  wire [`H_ADDR_WIDTH-1:16] remap_register0;
  wire [`H_ADDR_WIDTH-1:16] remap_register1;
  wire [31:0] rd_data_out_int ;
  wire [`S_RD_DATA_WIDTH-1:0] rd_data_out ;
  wire mobile_sdram_dpd_en; 

  //----------------------------------------------------------
  // Byte write signals for chip select0
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire scslr0_low_byte3_wr;
  wire scslr0_low_byte2_wr;
  wire scslr0_low_byte1_wr;
  wire scslr0_low_hbyte3_wr;
  wire scslr0_low_hbyte2_wr;
  wire scslr0_low_lbyte1_wr;

  wire scslr0_high_byte3_wr;
  wire scslr0_high_byte2_wr;
  wire scslr0_high_byte1_wr;
  wire scslr0_high_byte0_wr;
  wire scslr0_high_hbyte3_wr;
  wire scslr0_high_hbyte2_wr;
  wire scslr0_high_lbyte1_wr;
  wire scslr0_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for chip select1
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire scslr1_low_byte3_wr;
  wire scslr1_low_byte2_wr;
  wire scslr1_low_byte1_wr;
  wire scslr1_low_hbyte3_wr;
  wire scslr1_low_hbyte2_wr;
  wire scslr1_low_lbyte1_wr;

  wire scslr1_high_byte3_wr;
  wire scslr1_high_byte2_wr;
  wire scslr1_high_byte1_wr;
  wire scslr1_high_byte0_wr;
  wire scslr1_high_hbyte3_wr;
  wire scslr1_high_hbyte2_wr;
  wire scslr1_high_lbyte1_wr;
  wire scslr1_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for chip select2
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire scslr2_low_byte3_wr;
  wire scslr2_low_byte2_wr;
  wire scslr2_low_byte1_wr;
  wire scslr2_low_hbyte3_wr;
  wire scslr2_low_hbyte2_wr;
  wire scslr2_low_lbyte1_wr;

  wire scslr2_high_byte3_wr;
  wire scslr2_high_byte2_wr;
  wire scslr2_high_byte1_wr;
  wire scslr2_high_byte0_wr;
  wire scslr2_high_hbyte3_wr;
  wire scslr2_high_hbyte2_wr;
  wire scslr2_high_lbyte1_wr;
  wire scslr2_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for chip select3
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire scslr3_low_byte3_wr;
  wire scslr3_low_byte2_wr;
  wire scslr3_low_byte1_wr;
  wire scslr3_low_hbyte3_wr;
  wire scslr3_low_hbyte2_wr;
  wire scslr3_low_lbyte1_wr;

  wire scslr3_high_byte3_wr;
  wire scslr3_high_byte2_wr;
  wire scslr3_high_byte1_wr;
  wire scslr3_high_byte0_wr;
  wire scslr3_high_hbyte3_wr;
  wire scslr3_high_lbyte1_wr;
  wire scslr3_high_hbyte2_wr;
  wire scslr3_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for chip select4
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire scslr4_low_byte3_wr;
  wire scslr4_low_byte2_wr;
  wire scslr4_low_byte1_wr;
  wire scslr4_low_hbyte3_wr;
  wire scslr4_low_hbyte2_wr;
  wire scslr4_low_lbyte1_wr;

  wire scslr4_high_byte3_wr;
  wire scslr4_high_byte2_wr;
  wire scslr4_high_byte1_wr;
  wire scslr4_high_byte0_wr;
  wire scslr4_high_hbyte3_wr;
  wire scslr4_high_hbyte2_wr;
  wire scslr4_high_lbyte1_wr;
  wire scslr4_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for chip select5
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire scslr5_low_byte2_wr;
  wire scslr5_low_byte3_wr;
  wire scslr5_low_byte1_wr;
  wire scslr5_low_hbyte3_wr;
  wire scslr5_low_hbyte2_wr;
  wire scslr5_low_lbyte1_wr;

  wire scslr5_high_byte3_wr;
  wire scslr5_high_byte2_wr;
  wire scslr5_high_byte1_wr;
  wire scslr5_high_byte0_wr;
  wire scslr5_high_hbyte3_wr;
  wire scslr5_high_hbyte2_wr;
  wire scslr5_high_lbyte1_wr;
  wire scslr5_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for chip select6
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire scslr6_low_byte3_wr;
  wire scslr6_low_byte2_wr;
  wire scslr6_low_byte1_wr;
  wire scslr6_low_hbyte3_wr;
  wire scslr6_low_hbyte2_wr;
  wire scslr6_low_lbyte1_wr;

  wire scslr6_high_byte3_wr;
  wire scslr6_high_byte2_wr;
  wire scslr6_high_byte1_wr;
  wire scslr6_high_byte0_wr;
  wire scslr6_high_hbyte2_wr;
  wire scslr6_high_hbyte3_wr;
  wire scslr6_high_lbyte1_wr;
  wire scslr6_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for chip select7
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire scslr7_low_byte3_wr;
  wire scslr7_low_byte2_wr;
  wire scslr7_low_byte1_wr;
  wire scslr7_low_hbyte3_wr;
  wire scslr7_low_hbyte2_wr;
  wire scslr7_low_lbyte1_wr;

  wire scslr7_high_byte3_wr;
  wire scslr7_high_byte2_wr;
  wire scslr7_high_byte1_wr;
  wire scslr7_high_byte0_wr;
  wire scslr7_high_hbyte3_wr;
  wire scslr7_high_hbyte2_wr;
  wire scslr7_high_lbyte1_wr;
  wire scslr7_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for csalias0 register
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire csalias0_low_byte3_wr;
  wire csalias0_low_byte2_wr;
  wire csalias0_low_byte1_wr;
  wire csalias0_low_hbyte3_wr;
  wire csalias0_low_hbyte2_wr;
  wire csalias0_low_lbyte1_wr;

  wire csalias0_high_byte3_wr;
  wire csalias0_high_byte2_wr;
  wire csalias0_high_byte1_wr;
  wire csalias0_high_byte0_wr;
  wire csalias0_high_hbyte3_wr;
  wire csalias0_high_lbyte0_wr;
  wire csalias0_high_lbyte1_wr;
  wire csalias0_high_hbyte2_wr;

  //----------------------------------------------------------
  // Byte write signals for csalias1 register
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire csalias1_low_byte3_wr;
  wire csalias1_low_byte2_wr;
  wire csalias1_low_byte1_wr;
  wire csalias1_low_hbyte3_wr;
  wire csalias1_low_hbyte2_wr;
  wire csalias1_low_lbyte1_wr;

  wire csalias1_high_byte3_wr;
  wire csalias1_high_byte2_wr;
  wire csalias1_high_byte1_wr;
  wire csalias1_high_byte0_wr;
  wire csalias1_high_hbyte3_wr;
  wire csalias1_high_hbyte2_wr;
  wire csalias1_high_lbyte1_wr;
  wire csalias1_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for csreamp0 register
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire csremap0_low_byte3_wr;
  wire csremap0_low_byte2_wr;
  wire csremap0_low_byte1_wr;
  wire csremap0_low_hbyte3_wr;
  wire csremap0_low_hbyte2_wr;
  wire csremap0_low_lbyte1_wr;

  wire csremap0_high_byte3_wr;
  wire csremap0_high_byte2_wr;
  wire csremap0_high_byte1_wr;
  wire csremap0_high_byte0_wr;
  wire csremap0_high_hbyte3_wr;
  wire csremap0_high_hbyte2_wr;
  wire csremap0_high_lbyte1_wr;
  wire csremap0_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for csreamp1 register
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire csremap1_low_byte3_wr;
  wire csremap1_low_byte2_wr;
  wire csremap1_low_byte1_wr;
  wire csremap1_low_hbyte3_wr;
  wire csremap1_low_hbyte2_wr;
  wire csremap1_low_lbyte1_wr;

  wire csremap1_high_byte3_wr;
  wire csremap1_high_byte2_wr;
  wire csremap1_high_byte1_wr;
  wire csremap1_high_byte0_wr;
  wire csremap1_high_hbyte3_wr;
  wire csremap1_high_hbyte2_wr;
  wire csremap1_high_lbyte1_wr;
  wire csremap1_high_lbyte0_wr;

  //----------------------------------------------------------
  // Byte write signals for sconr register
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire sconr_lbyte0_wr;
  wire sconr_lbyte1_wr;
  wire sconr_hbyte2_wr;
  wire sconr_byte0_wr;
  wire sconr_byte1_wr;
  wire sconr_byte2_wr;

  wire sfconr_lbyte0_wr;
  wire sfconr_lbyte1_wr;
  wire sfconr_byte0_wr;
  wire sfconr_byte1_wr;

  wire sfctlr_lbyte0_wr;
  wire sfctlr_byte0_wr;

  //----------------------------------------------------------
  // Byte write signals for stmg0r register
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire stmg0r_lbyte0_wr;
  wire stmg0r_lbyte1_wr;
  wire stmg0r_hbyte2_wr;
  wire stmg0r_hbyte3_wr;
  wire stmg0r_byte0_wr;
  wire stmg0r_byte1_wr;
  wire stmg0r_byte2_wr;
  wire stmg0r_byte3_wr;

  wire sftmgr_lbyte0_wr;
  wire sftmgr_lbyte1_wr;
  wire sftmgr_byte0_wr;
  wire sftmgr_byte1_wr;

  //----------------------------------------------------------
  // Byte write signals for stmg1r register
  // byte1-3 - for writes to bytes 1-3 when s_data_width !=16
  // l/hbyte1-3 for writes to bytes 1-3 when s_data_width==16
  //----------------------------------------------------------

  wire stmg1r_lbyte0_wr;
  wire stmg1r_lbyte1_wr;
  wire stmg1r_hbyte2_wr;
  wire stmg1r_byte0_wr;
  wire stmg1r_byte1_wr;
  wire stmg1r_byte2_wr;

  wire sctlr_lbyte0_wr;
  wire sctlr_lbyte1_wr;
  wire sctlr_hbyte2_wr;
  wire sctlr_byte0_wr;
  wire sctlr_byte1_wr;
  wire sctlr_byte2_wr;

  wire srefr_lbyte0_wr;
  wire srefr_lbyte1_wr;
  wire srefr_hbyte2_wr;
  wire srefr_hbyte3_wr;
  wire srefr_byte0_wr;
  wire srefr_byte1_wr;
  wire srefr_byte2_wr;
  wire srefr_byte3_wr;


  wire smskr0_lbyte0_wr;
  wire smskr0_lbyte1_wr;
  wire smskr0_byte0_wr;
  wire smskr0_byte1_wr;

  wire smskr1_lbyte0_wr;
  wire smskr1_lbyte1_wr;
  wire smskr1_byte0_wr;
  wire smskr1_byte1_wr;

  wire smskr2_lbyte0_wr;
  wire smskr2_lbyte1_wr;
  wire smskr2_byte0_wr;
  wire smskr2_byte1_wr;

  wire smskr3_lbyte0_wr;
  wire smskr3_lbyte1_wr;
  wire smskr3_byte0_wr;
  wire smskr3_byte1_wr;

  wire smskr4_lbyte0_wr;
  wire smskr4_lbyte1_wr;
  wire smskr4_byte0_wr;
  wire smskr4_byte1_wr;

  wire smskr5_lbyte0_wr;
  wire smskr5_lbyte1_wr;
  wire smskr5_byte0_wr;
  wire smskr5_byte1_wr;

  wire smskr6_lbyte0_wr;
  wire smskr6_lbyte1_wr;
  wire smskr6_byte0_wr;
  wire smskr6_byte1_wr;

  wire smskr7_lbyte0_wr;
  wire smskr7_lbyte1_wr;
  wire smskr7_byte0_wr;
  wire smskr7_byte1_wr;

  //------------------------------------------------------------------
  // EXN_MODE_REG register selects
  //------------------------------------------------------------------

  wire exn_mode_reg_sel;
  wire exn_mode_reg_l_sel;

  //------------------------------------------------------------------
  // EXN_MODE_REG byte write signals.hbyte and lbyte are used during
  // 16 bit writes
  //------------------------------------------------------------------

  wire exn_mode_reg_lbyte0_wr;
  wire exn_mode_reg_lbyte1_wr;
  wire exn_mode_reg_byte0_wr;
  wire exn_mode_reg_byte1_wr;

  //------------------------------------------------------------------
  // EXN_MODE_REG register selects
  //------------------------------------------------------------------

  wire syflash_opcode_sel;
  wire syflash_opcode_l_sel;


  //------------------------------------------------------------------
  // EXN_MODE_REG byte write signals.hbyte and lbyte are used during
  // 16 bit writes
  //------------------------------------------------------------------

  wire syflash_opcode_lbyte0_wr;
  wire syflash_opcode_lbyte1_wr;
  wire syflash_opcode_byte0_wr;
  wire syflash_opcode_byte1_wr;

  wire [4:0] mem_size0;
  wire [4:0] mem_size1;
  wire [4:0] mem_size2;
  wire [4:0] mem_size3;
  wire [4:0] mem_size4;
  wire [4:0] mem_size5;
  wire [4:0] mem_size6;
  wire [4:0] mem_size7;
  wire [2:0] mem_type0;
  wire [2:0] mem_type1;
  wire [2:0] mem_type2;
  wire [2:0] mem_type3;
  wire [2:0] mem_type4;
  wire [2:0] mem_type5;
  wire [2:0] mem_type6;
  wire [2:0] mem_type7;
  wire [2:0] reg_select0;
  wire [2:0] reg_select1;
  wire [2:0] reg_select2;
  wire [2:0] reg_select3;
  wire [2:0] reg_select4;
  wire [2:0] reg_select5;
  wire [2:0] reg_select6;
  wire [2:0] reg_select7;

  wire [`H_ADDR_WIDTH-1:0] scslr0_addr;
  wire [`H_ADDR_WIDTH-1:0] scslr1_addr;
  wire [`H_ADDR_WIDTH-1:0] scslr2_addr;
  wire [`H_ADDR_WIDTH-1:0] scslr3_addr;
  wire [`H_ADDR_WIDTH-1:0] scslr4_addr;
  wire [`H_ADDR_WIDTH-1:0] scslr5_addr;
  wire [`H_ADDR_WIDTH-1:0] scslr6_addr;
  wire [`H_ADDR_WIDTH-1:0] scslr7_addr;
  wire [`H_ADDR_WIDTH-1:0] csalias0_addr;
  wire [`H_ADDR_WIDTH-1:0] csalias1_addr;
  wire [`H_ADDR_WIDTH-1:0] csremap0_addr;
  wire [`H_ADDR_WIDTH-1:0] csremap1_addr;

  wire [3:0] mask;

  wire clr_sctlr_bitone;
  wire [1:0]  data_width_default;
  wire [31:0] sconr_default;
  wire [31:0] sfconr_default;
  wire [31:0] stmg0r_default;
  wire [31:0] sftmgr_default;
  wire [31:0] stmg1r_default;
  wire [31:0] memctl_comp_params_1_default;
  wire [31:0] memctl_comp_params_2_default;
  wire [31:0] sctlr_default;
   
  wire        sf_mode_reg_update;

  wire disable_write;


  assign clr_sctlr_bitone = (clear_self_ref_rp | sync_fl_pdr_done);

  // --------------------------------------------------------------
  // Select signals l_sel and h_sel are used during 16 bit writes.
  // l_half_word and m_half_word are generated in the state machine
  //---------------------------------------------------------------

  //--------------------------------------------------------
  // Dummy Select signal for Address ranges above AC
  //--------------------------------------------------------

  assign dummy_sel    = (hiu_addr[7:2] > `EXN_MODE_REG_ADDR);

  //--------------------------------
  // SCONR Selects
  //--------------------------------

  assign sconr_sel    = (hiu_addr[7:2] == `CONFIG_REG_ADDR);
  assign sconr_l_sel  = sconr_sel   && (l_half_word==1);
  assign sconr_h_sel  = sconr_sel   && (m_half_word==1);


  //--------------------------------
  // STMG0R Selects
  //--------------------------------

  assign stmg0r_sel   = (hiu_addr[7:2] == `SDRAM_TIMING_REG0_ADDR);
  assign stmg0r_l_sel = stmg0r_sel && (l_half_word==1);
  assign stmg0r_h_sel = stmg0r_sel && (m_half_word==1);

  //--------------------------------
  // STMG1R Selects
  //--------------------------------

  // Timing Reg1 Select .Used for reads and 32 bit writes
  assign stmg1r_sel   = (hiu_addr[7:2] == `SDRAM_TIMING_REG1_ADDR);
  assign stmg1r_l_sel = stmg1r_sel && (l_half_word==1);
  assign stmg1r_h_sel = stmg1r_sel && (m_half_word==1);

  //--------------------------------
  // SCTLR Selects
  //--------------------------------

  assign sctlr_sel    = (hiu_addr[7:2] == `CONTROL_REG_ADDR);
  assign sctlr_l_sel  = sctlr_sel  && (l_half_word==1);
  assign sctlr_h_sel  = sctlr_sel  && (m_half_word==1);

  //--------------------------------
  // SREFR Selects
  //--------------------------------
  assign srefr_sel    = (hiu_addr[7:2] == `REFRESH_REG_ADDR);
  assign srefr_l_sel  = srefr_sel  && (l_half_word==1);
  assign srefr_h_sel  = srefr_sel  && (m_half_word==1);

  //--------------------------------
  // Select signals for SCSLR0
  //--------------------------------

  assign scslr0_low_sel    = (hiu_addr[7:2]  == `CHIPSEL_REG0_LOW_ADDR);
  assign scslr0_low_h_sel  = scslr0_low_sel  && (m_half_word==1);
  assign scslr0_low_l_sel  = scslr0_low_sel  && (l_half_word==1);
  assign scslr0_high_sel   = (hiu_addr[7:2]  == `CHIPSEL_REG0_HIGH_ADDR);
  assign scslr0_high_l_sel = scslr0_high_sel && (l_half_word==1);
  assign scslr0_high_h_sel = scslr0_high_sel && (m_half_word==1);

  //--------------------------------
  // Select signals for SCSLR1
  //--------------------------------

  assign scslr1_low_sel    = (hiu_addr[7:2]  == `CHIPSEL_REG1_LOW_ADDR);
  assign scslr1_low_h_sel  = scslr1_low_sel  && (m_half_word==1);
  assign scslr1_low_l_sel  = scslr1_low_sel  && (l_half_word==1);
  assign scslr1_high_sel   = (hiu_addr[7:2]  == `CHIPSEL_REG1_HIGH_ADDR);
  assign scslr1_high_l_sel = scslr1_high_sel && (l_half_word==1);
  assign scslr1_high_h_sel = scslr1_high_sel && (m_half_word==1);

  //--------------------------------
  // Select signals for SCSLR2
  //--------------------------------

  assign scslr2_low_sel    = (hiu_addr[7:2]  == `CHIPSEL_REG2_LOW_ADDR);
  assign scslr2_low_h_sel  = scslr2_low_sel  && (m_half_word==1);
  assign scslr2_low_l_sel  = scslr2_low_sel  && (l_half_word==1);
  assign scslr2_high_sel   = (hiu_addr[7:2]  == `CHIPSEL_REG2_HIGH_ADDR);
  assign scslr2_high_l_sel = scslr2_high_sel && (l_half_word==1);
  assign scslr2_high_h_sel = scslr2_high_sel && (m_half_word==1);

  //--------------------------------
  // Select signals for SCSLR3
  //--------------------------------

  assign scslr3_low_sel    = (hiu_addr[7:2]  == `CHIPSEL_REG3_LOW_ADDR);
  assign scslr3_low_h_sel  = scslr3_low_sel  && (m_half_word==1);
  assign scslr3_low_l_sel  = scslr3_low_sel  && (l_half_word==1);
  assign scslr3_high_sel   = (hiu_addr[7:2]  == `CHIPSEL_REG3_HIGH_ADDR);
  assign scslr3_high_l_sel = scslr3_high_sel && (l_half_word==1);
  assign scslr3_high_h_sel = scslr3_high_sel && (m_half_word==1);

  //--------------------------------
  //Select signals for SCSLR4
  //--------------------------------

  assign scslr4_low_sel    = (hiu_addr[7:2]  == `CHIPSEL_REG4_LOW_ADDR);
  assign scslr4_low_h_sel  = scslr4_low_sel  && (m_half_word==1);
  assign scslr4_low_l_sel  = scslr4_low_sel  && (l_half_word==1);
  assign scslr4_high_sel   = (hiu_addr[7:2]  == `CHIPSEL_REG4_HIGH_ADDR);
  assign scslr4_high_l_sel = scslr4_high_sel && (l_half_word==1);
  assign scslr4_high_h_sel = scslr4_high_sel && (m_half_word==1);

  //--------------------------------
  // Select signals for SCSLR5
  //--------------------------------

  assign scslr5_low_sel    = (hiu_addr[7:2]  == `CHIPSEL_REG5_LOW_ADDR);
  assign scslr5_low_h_sel  = scslr5_low_sel  && (m_half_word==1);
  assign scslr5_low_l_sel  = scslr5_low_sel  && (l_half_word==1);
  assign scslr5_high_sel   = (hiu_addr[7:2]  == `CHIPSEL_REG5_HIGH_ADDR);
  assign scslr5_high_l_sel = scslr5_high_sel && (l_half_word==1);
  assign scslr5_high_h_sel = scslr5_high_sel && (m_half_word==1);

  //--------------------------------
  // Select signals for SCSLR6
  //--------------------------------

  assign scslr6_low_sel    = (hiu_addr[7:2]  == `CHIPSEL_REG6_LOW_ADDR);
  assign scslr6_low_h_sel  = scslr6_low_sel  && (m_half_word==1);
  assign scslr6_low_l_sel  = scslr6_low_sel  && (l_half_word==1);
  assign scslr6_high_sel   = (hiu_addr[7:2]  == `CHIPSEL_REG6_HIGH_ADDR);
  assign scslr6_high_l_sel = scslr6_high_sel && (l_half_word==1);
  assign scslr6_high_h_sel = scslr6_high_sel && (m_half_word==1);

  //--------------------------------
  // Select signals for scslr7
  //--------------------------------

  assign scslr7_low_sel    = (hiu_addr[7:2]  == `CHIPSEL_REG7_LOW_ADDR);
  assign scslr7_low_h_sel  = scslr7_low_sel  && (m_half_word==1);
  assign scslr7_low_l_sel  = scslr7_low_sel  && (l_half_word==1);
  assign scslr7_high_sel   = (hiu_addr[7:2]  == `CHIPSEL_REG7_HIGH_ADDR);
  assign scslr7_high_l_sel = scslr7_high_sel && (l_half_word==1);
  assign scslr7_high_h_sel = scslr7_high_sel && (m_half_word==1);

  //--------------------------------
  // CSALIAS0 Register selects
  //--------------------------------

  assign csalias0_low_sel   = (hiu_addr[7:2] == `CHIPSEL0_LOW_ALIAS_REG_ADDR);
  assign csalias0_low_h_sel = csalias0_low_sel   && (m_half_word==1);
  assign csalias0_low_l_sel = csalias0_low_sel   && (l_half_word==1);
  assign csalias0_high_sel  = (hiu_addr[7:2] == `CHIPSEL0_HIGH_ALIAS_REG_ADDR);
  assign csalias0_high_l_sel = csalias0_high_sel && (l_half_word==1);
  assign csalias0_high_h_sel = csalias0_high_sel && (m_half_word==1);

  //--------------------------------
  // CSALIAS1 Register selects
  //--------------------------------

  assign csalias1_low_sel   = (hiu_addr[7:2] == `CHIPSEL1_LOW_ALIAS_REG_ADDR);
  assign csalias1_low_h_sel = csalias1_low_sel && (m_half_word==1);
  assign csalias1_low_l_sel = csalias1_low_sel && (l_half_word==1);
  assign csalias1_high_sel  = (hiu_addr[7:2] == `CHIPSEL1_HIGH_ALIAS_REG_ADDR);
  assign csalias1_high_l_sel = csalias1_high_sel && (l_half_word==1);
  assign csalias1_high_h_sel = csalias1_high_sel && (m_half_word==1);

  //--------------------------------
  // CSREMAP0 Register selects
  //--------------------------------

  assign csremap0_low_sel   = (hiu_addr[7:2] == `CHIPSEL0_LOW_REMAP_REG_ADDR);
  assign csremap0_low_h_sel = csremap0_low_sel && (m_half_word==1);
  assign csremap0_low_l_sel = csremap0_low_sel && (l_half_word==1);
  assign csremap0_high_sel  = (hiu_addr[7:2] == `CHIPSEL0_HIGH_REMAP_REG_ADDR);
  assign csremap0_high_l_sel = csremap0_high_sel && (l_half_word==1);
  assign csremap0_high_h_sel = csremap0_high_sel && (m_half_word==1);

  //--------------------------------
  // CSREMAP1 Register Selects
  //--------------------------------

  assign csremap1_low_sel   = (hiu_addr[7:2] == `CHIPSEL1_LOW_REMAP_REG_ADDR);
  assign csremap1_low_h_sel = csremap1_low_sel  && (m_half_word==1);
  assign csremap1_low_l_sel = csremap1_low_sel  && (l_half_word==1);
  assign csremap1_high_sel  = (hiu_addr[7:2] == `CHIPSEL1_HIGH_REMAP_REG_ADDR);
  assign csremap1_high_l_sel = csremap1_high_sel && (l_half_word==1);
  assign csremap1_high_h_sel = csremap1_high_sel && (m_half_word==1);

  //--------------------------------
  // SMSKR0 Selects
  //--------------------------------

  assign smskr0_sel    = (hiu_addr[7:2] == `MASK_REG_ADDR1);
  assign smskr0_l_sel  = smskr0_sel  && (l_half_word==1);

  //--------------------------------
  // SMSKR1 Selects
  //--------------------------------

  assign smskr1_sel    = (hiu_addr[7:2] == `MASK_REG_ADDR2);
  assign smskr1_l_sel  = smskr1_sel  && (l_half_word==1);

  //--------------------------------
  // SMSKR2 Selects
  //--------------------------------

  assign smskr2_sel    = (hiu_addr[7:2] == `MASK_REG_ADDR3);
  assign smskr2_l_sel  = smskr2_sel  && (l_half_word==1);

  //--------------------------------
  // SMSKR3 Selects
  //--------------------------------

  assign smskr3_sel    = (hiu_addr[7:2] == `MASK_REG_ADDR4);
  assign smskr3_l_sel  = smskr3_sel  && (l_half_word==1);

  //--------------------------------
  // SMSKR4 Selects
  //--------------------------------

  assign smskr4_sel    = (hiu_addr[7:2] == `MASK_REG_ADDR5);
  assign smskr4_l_sel  = smskr4_sel  && (l_half_word==1);

  //--------------------------------
  // SMSKR5 Selects
  //--------------------------------

  assign smskr5_sel    = (hiu_addr[7:2] == `MASK_REG_ADDR6);
  assign smskr5_l_sel  = smskr5_sel  && (l_half_word==1);

  //--------------------------------
  // SMSKR6 Selects
  //--------------------------------

  assign smskr6_sel    = (hiu_addr[7:2] == `MASK_REG_ADDR7);
  assign smskr6_l_sel  = smskr6_sel  && (l_half_word==1);

  //--------------------------------
  // SMSKR7 Selects
  //--------------------------------

  assign smskr7_sel    = (hiu_addr[7:2] == `MASK_REG_ADDR8);
  assign smskr7_l_sel  = smskr7_sel  && (l_half_word==1);

  //------------------------------------------------------------------
  // EXN_MODE_REG register Byte writes
  //------------------------------------------------------------------

  assign syflash_opcode_lbyte0_wr = syflash_opcode_l_sel & cr_wr & mask[0];
  assign syflash_opcode_lbyte1_wr = syflash_opcode_l_sel & cr_wr & mask[1];
  assign syflash_opcode_byte0_wr  = syflash_opcode_sel & cr_wr & mask[0];
  assign syflash_opcode_byte1_wr = syflash_opcode_sel & cr_wr & mask[1];

  //------------------------------------------------------------------
  // EXN_MODE_REG registr select signals
  //------------------------------------------------------------------

  assign syflash_opcode_sel = (hiu_addr[7:2] == `SYFLASH_OPCODE_REG_ADDR);
  assign syflash_opcode_l_sel = syflash_opcode_sel & (l_half_word == 1);

  //--------------------------------
  // SFCONR Selects
  //--------------------------------

  assign sfconr_sel = (hiu_addr[7:2] == `SFCONR_REG_ADDR);
  assign sfconr_l_sel = sfconr_sel && (l_half_word==1);

  //--------------------------------
  // SFCTLR Selects
  //--------------------------------

  assign sfctlr_sel = (hiu_addr[7:2] == `SFCTLR_REG_ADDR);
  assign sfctlr_l_sel = sfctlr_sel && (l_half_word==1);

  //--------------------------------
  // SFTMGR Selects
  //--------------------------------
  
  assign sftmgr_sel   = (hiu_addr[7:2] == `SYNCFLASH_TIMING_REG_ADDR);
  assign sftmgr_l_sel = sftmgr_sel && (l_half_word==1);
  assign sftmgr_h_sel = sftmgr_sel && (m_half_word==1); 

  //--------------------------------
  // Component Identification Registers Selects
  //--------------------------------

   assign memctl_comp_type_sel     = (hiu_addr[7:2] == `MEMCTL_COMP_TYPE_ADDR);
   assign memctl_comp_version_sel  = (hiu_addr[7:2] == `MEMCTL_COMP_VERSION_ADDR);
   assign memctl_comp_params_1_sel = (hiu_addr[7:2] == `MEMCTL_COMP_PARAMS_1_ADDR);
   assign memctl_comp_params_2_sel = (hiu_addr[7:2] == `MEMCTL_COMP_PARAMS_2_ADDR);

   
  assign push_n        = push_n_int;

  // Register select.
  assign cr_reg_sel    = hiu_reg_req & !smcr_selected ;

  // Register Reads
  assign cr_rd = cr_reg_sel && hiu_rw ;


 assign wr_data2_smcr = h_wr_data_int;
 assign mask2_smcr    = h_mask_int;

  //-------------------------------------------------------------------------
  // Register Read Data
  // Case 1 :- Memory Data Width is 16 (2:1 case)
  //           CR_IDLE->CR_16RD1->CR_16RD2->CR_IDLE
  //           Give lower 16 bits in CR_IDLE,upper 16 bits otherwise
  //
  // Case 2 :- Memory Data Width 32, AHB data width 64 ( 2:1 case)
  //           CR_IDLE->CR_21RD1->CR_21RD2->CR_IDLE
  //           Give lower 32 bits in CR_IDLE , upper 32 bits otherwise
  //
  // Case 3 :- Memory Data Width 64, AHB data width 128 ( 2:1 case)
  //           CR_IDLE->CR_21RD1->CR_21RD2->CR_IDLE
  //           Give lower 64 bits in CR_IDLE, upper 64 bits otherwise
  //
  // Default :- 1:1 case
  //--------------------------------------------------------------------------

  assign rd_data_out = (sdram_data_width==0 && rd_l_half_word) ?
                       h_rd_data_int[15:0] : 
                       (sdram_data_width==0 && rd_m_half_word) ? 
                       h_rd_data_int[31:16] :
                       (sdram_data_width==3 && `H_DATA_WIDTH==128) ?
                       h_rd_data_int :
                       (sdram_data_width==2 && `H_DATA_WIDTH==128) ?
                       h_rd_data_int1 :
                       h_rd_data_int;

  //----------------------------------------------------------------------
  // byte1_wr, byte2_wr, byte3_wr are used during 32 bit writes
  // hbyte*_wr lbyte*_wr are used during 16 bit writes.
  //----------------------------------------------------------------------

  //----------------------------------------------------------------------
  // SCSLR0 byte write signals
  //----------------------------------------------------------------------

  assign scslr0_low_byte3_wr   = scslr0_low_sel   & cr_wr & mask[3];
  assign scslr0_low_byte2_wr   = scslr0_low_sel   & cr_wr & mask[2];
  assign scslr0_low_byte1_wr   = scslr0_low_sel   & cr_wr & mask[1];
  assign scslr0_low_hbyte3_wr  = scslr0_low_h_sel & cr_wr & mask[3] ;
  assign scslr0_low_hbyte2_wr  = scslr0_low_h_sel & cr_wr & mask[2] ;
  assign scslr0_low_lbyte1_wr  = scslr0_low_l_sel & cr_wr & mask[1] ;

  assign scslr0_high_byte3_wr  = scslr0_high_sel   & cr_wr & mask[3] ;
  assign scslr0_high_byte2_wr  = scslr0_high_sel   & cr_wr & mask[2] ;
  assign scslr0_high_byte1_wr  = scslr0_high_sel   & cr_wr & mask[1] ;
  assign scslr0_high_byte0_wr  = scslr0_high_sel   & cr_wr & mask[0] ;
  assign scslr0_high_hbyte3_wr = scslr0_high_h_sel & cr_wr & mask[3] ;
  assign scslr0_high_hbyte2_wr = scslr0_high_h_sel & cr_wr & mask[2] ;
  assign scslr0_high_lbyte1_wr = scslr0_high_l_sel & cr_wr & mask[1] ;
  assign scslr0_high_lbyte0_wr = scslr0_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------------------------------------------
  // SCSLR1 byte write signals
  //----------------------------------------------------------------------

  assign scslr1_low_byte3_wr   = scslr1_low_sel   & cr_wr & mask[3] ;
  assign scslr1_low_byte2_wr   = scslr1_low_sel   & cr_wr & mask[2] ;
  assign scslr1_low_byte1_wr   = scslr1_low_sel   & cr_wr & mask[1] ;
  assign scslr1_low_hbyte3_wr  = scslr1_low_h_sel & cr_wr & mask[3] ;
  assign scslr1_low_hbyte2_wr  = scslr1_low_h_sel & cr_wr & mask[2] ;
  assign scslr1_low_lbyte1_wr  = scslr1_low_l_sel & cr_wr & mask[1] ;

  assign scslr1_high_byte3_wr  = scslr1_high_sel   & cr_wr & mask[3] ;
  assign scslr1_high_byte2_wr  = scslr1_high_sel   & cr_wr & mask[2] ;
  assign scslr1_high_byte1_wr  = scslr1_high_sel   & cr_wr & mask[1] ;
  assign scslr1_high_byte0_wr  = scslr1_high_sel   & cr_wr & mask[0] ;
  assign scslr1_high_hbyte3_wr = scslr1_high_h_sel & cr_wr & mask[3] ;
  assign scslr1_high_hbyte2_wr = scslr1_high_h_sel & cr_wr & mask[2] ;
  assign scslr1_high_lbyte1_wr = scslr1_high_l_sel & cr_wr & mask[1] ;
  assign scslr1_high_lbyte0_wr = scslr1_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------------------------------------------
  // SCSLR2 byte write signals
  //----------------------------------------------------------------------

  assign scslr2_low_byte3_wr   = scslr2_low_sel   & cr_wr & mask[3] ;
  assign scslr2_low_byte2_wr   = scslr2_low_sel   & cr_wr & mask[2] ;
  assign scslr2_low_byte1_wr   = scslr2_low_sel   & cr_wr & mask[1] ;
  assign scslr2_low_hbyte3_wr  = scslr2_low_h_sel & cr_wr & mask[3] ;
  assign scslr2_low_hbyte2_wr  = scslr2_low_h_sel & cr_wr & mask[2] ;
  assign scslr2_low_lbyte1_wr  = scslr2_low_l_sel & cr_wr & mask[1] ;

  assign scslr2_high_byte3_wr  = scslr2_high_sel   & cr_wr & mask[3] ;
  assign scslr2_high_byte2_wr  = scslr2_high_sel   & cr_wr & mask[2] ;
  assign scslr2_high_byte1_wr  = scslr2_high_sel   & cr_wr & mask[1];
  assign scslr2_high_byte0_wr  = scslr2_high_sel   & cr_wr & mask[0] ;
  assign scslr2_high_hbyte3_wr = scslr2_high_h_sel & cr_wr & mask[3] ;
  assign scslr2_high_hbyte2_wr = scslr2_high_h_sel & cr_wr & mask[2] ;
  assign scslr2_high_lbyte1_wr = scslr2_high_l_sel & cr_wr & mask[1] ;
  assign scslr2_high_lbyte0_wr = scslr2_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------------------------------------------
  // SCSLR3 byte write signals
  //----------------------------------------------------------------------

  assign scslr3_low_byte3_wr   = scslr3_low_sel    & cr_wr & mask[3] ;
  assign scslr3_low_byte2_wr   = scslr3_low_sel    & cr_wr & mask[2] ;
  assign scslr3_low_byte1_wr   = scslr3_low_sel    & cr_wr & mask[1] ;
  assign scslr3_low_hbyte3_wr  = scslr3_low_h_sel  & cr_wr & mask[3] ;
  assign scslr3_low_hbyte2_wr  = scslr3_low_h_sel  & cr_wr & mask[2] ;
  assign scslr3_low_lbyte1_wr  = scslr3_low_l_sel  & cr_wr & mask[1] ;

  assign scslr3_high_byte3_wr  = scslr3_high_sel   & cr_wr & mask[3] ;
  assign scslr3_high_byte2_wr  = scslr3_high_sel   & cr_wr & mask[2] ;
  assign scslr3_high_byte1_wr  = scslr3_high_sel   & cr_wr & mask[1] ;
  assign scslr3_high_byte0_wr  = scslr3_high_sel   & cr_wr & mask[0] ;
  assign scslr3_high_hbyte3_wr = scslr3_high_h_sel & cr_wr & mask[3] ;
  assign scslr3_high_hbyte2_wr = scslr3_high_h_sel & cr_wr & mask[2] ;
  assign scslr3_high_lbyte1_wr = scslr3_high_l_sel & cr_wr & mask[1] ;
  assign scslr3_high_lbyte0_wr = scslr3_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------------------------------------------
  // SCSLR4 byte write signals
  //----------------------------------------------------------------------

  assign scslr4_low_byte3_wr   = scslr4_low_sel   & cr_wr & mask[3] ;
  assign scslr4_low_byte2_wr   = scslr4_low_sel   & cr_wr & mask[2] ;
  assign scslr4_low_byte1_wr   = scslr4_low_sel   & cr_wr & mask[1] ;
  assign scslr4_low_hbyte3_wr  = scslr4_low_h_sel & cr_wr & mask[3] ;
  assign scslr4_low_hbyte2_wr  = scslr4_low_h_sel & cr_wr & mask[2] ;
  assign scslr4_low_lbyte1_wr  = scslr4_low_l_sel & cr_wr & mask[1] ;

  assign scslr4_high_byte3_wr  = scslr4_high_sel   & cr_wr & mask[3] ;
  assign scslr4_high_byte2_wr  = scslr4_high_sel   & cr_wr & mask[2] ;
  assign scslr4_high_byte1_wr  = scslr4_high_sel   & cr_wr & mask[1] ;
  assign scslr4_high_byte0_wr  = scslr4_high_sel   & cr_wr & mask[0] ;
  assign scslr4_high_hbyte3_wr = scslr4_high_h_sel & cr_wr & mask[3] ;
  assign scslr4_high_hbyte2_wr = scslr4_high_h_sel & cr_wr & mask[2] ;
  assign scslr4_high_lbyte1_wr = scslr4_high_l_sel & cr_wr & mask[1] ;
  assign scslr4_high_lbyte0_wr = scslr4_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------------------------------------------
  // SCSLR5 byte write signals
  //----------------------------------------------------------------------

  assign scslr5_low_byte3_wr  = scslr5_low_sel   & cr_wr & mask[3] ;
  assign scslr5_low_byte2_wr  = scslr5_low_sel   & cr_wr & mask[2] ;
  assign scslr5_low_byte1_wr  = scslr5_low_sel   & cr_wr & mask[1] ;
  assign scslr5_low_hbyte3_wr = scslr5_low_h_sel & cr_wr & mask[3] ;
  assign scslr5_low_hbyte2_wr = scslr5_low_h_sel & cr_wr & mask[2] ;
  assign scslr5_low_lbyte1_wr = scslr5_low_l_sel & cr_wr & mask[1] ;

  assign scslr5_high_byte3_wr  = scslr5_high_sel   & cr_wr & mask[3] ;
  assign scslr5_high_byte2_wr  = scslr5_high_sel   & cr_wr & mask[2] ;
  assign scslr5_high_byte1_wr  = scslr5_high_sel   & cr_wr & mask[1] ;
  assign scslr5_high_byte0_wr  = scslr5_high_sel   & cr_wr & mask[0] ;
  assign scslr5_high_hbyte3_wr = scslr5_high_h_sel & cr_wr & mask[3] ;
  assign scslr5_high_hbyte2_wr = scslr5_high_h_sel & cr_wr & mask[2] ;
  assign scslr5_high_lbyte1_wr = scslr5_high_l_sel & cr_wr & mask[1] ;
  assign scslr5_high_lbyte0_wr = scslr5_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------------------------------------------
  // SCSLR6 byte write signals
  //----------------------------------------------------------------------

  assign scslr6_low_byte3_wr   = scslr6_low_sel    & cr_wr & mask[3] ;
  assign scslr6_low_byte2_wr   = scslr6_low_sel    & cr_wr & mask[2] ;
  assign scslr6_low_byte1_wr   = scslr6_low_sel    & cr_wr & mask[1] ;
  assign scslr6_low_hbyte3_wr  = scslr6_low_h_sel  & cr_wr & mask[3] ;
  assign scslr6_low_hbyte2_wr  = scslr6_low_h_sel  & cr_wr & mask[2] ;
  assign scslr6_low_lbyte1_wr  = scslr6_low_l_sel  & cr_wr & mask[1] ;

  assign scslr6_high_byte3_wr  = scslr6_high_sel   & cr_wr & mask[3] ;
  assign scslr6_high_byte2_wr  = scslr6_high_sel   & cr_wr & mask[2] ;
  assign scslr6_high_byte1_wr  = scslr6_high_sel   & cr_wr & mask[1] ;
  assign scslr6_high_byte0_wr  = scslr6_high_sel   & cr_wr & mask[0] ;
  assign scslr6_high_hbyte3_wr = scslr6_high_h_sel & cr_wr & mask[3] ;
  assign scslr6_high_hbyte2_wr = scslr6_high_h_sel & cr_wr & mask[2] ;
  assign scslr6_high_lbyte1_wr = scslr6_high_l_sel & cr_wr & mask[1] ;
  assign scslr6_high_lbyte0_wr = scslr6_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------------------------------------------
  // SCSLR7 byte write signals
  //----------------------------------------------------------------------

  assign scslr7_low_byte3_wr   = scslr7_low_sel     & cr_wr & mask[3] ;
  assign scslr7_low_byte2_wr   = scslr7_low_sel     & cr_wr & mask[2] ;
  assign scslr7_low_byte1_wr   = scslr7_low_sel     & cr_wr & mask[1] ;
  assign scslr7_low_hbyte3_wr  = scslr7_low_h_sel   & cr_wr & mask[3] ;
  assign scslr7_low_hbyte2_wr  = scslr7_low_h_sel   & cr_wr & mask[2] ;
  assign scslr7_low_lbyte1_wr  = scslr7_low_l_sel   & cr_wr & mask[1] ;

  assign scslr7_high_byte3_wr  = scslr7_high_sel   & cr_wr & mask[3] ;
  assign scslr7_high_byte2_wr  = scslr7_high_sel   & cr_wr & mask[2] ;
  assign scslr7_high_byte1_wr  = scslr7_high_sel   & cr_wr & mask[1] ;
  assign scslr7_high_byte0_wr  = scslr7_high_sel   & cr_wr & mask[0] ;
  assign scslr7_high_hbyte3_wr = scslr7_high_h_sel & cr_wr & mask[3] ;
  assign scslr7_high_hbyte2_wr = scslr7_high_h_sel & cr_wr & mask[2] ;
  assign scslr7_high_lbyte1_wr = scslr7_high_l_sel & cr_wr & mask[1] ;
  assign scslr7_high_lbyte0_wr = scslr7_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------
  // CSALIAS0 & CASALIAS01 Byte writes
  //----------------------------------

  assign csalias0_low_byte3_wr  = csalias0_low_sel   & cr_wr & mask[3] ;
  assign csalias0_low_byte2_wr  = csalias0_low_sel   & cr_wr & mask[2] ;
  assign csalias0_low_byte1_wr  = csalias0_low_sel   & cr_wr & mask[1] ;
  assign csalias0_low_hbyte3_wr = csalias0_low_h_sel & cr_wr & mask[3] ;
  assign csalias0_low_hbyte2_wr = csalias0_low_h_sel & cr_wr & mask[2] ;
  assign csalias0_low_lbyte1_wr = csalias0_low_l_sel & cr_wr & mask[1] ;

  assign csalias0_high_byte3_wr  = csalias0_high_sel   & cr_wr & mask[3] ;
  assign csalias0_high_byte2_wr  = csalias0_high_sel   & cr_wr & mask[2] ;
  assign csalias0_high_byte1_wr  = csalias0_high_sel   & cr_wr & mask[1] ;
  assign csalias0_high_byte0_wr  = csalias0_high_sel   & cr_wr & mask[0] ;
  assign csalias0_high_hbyte3_wr = csalias0_high_h_sel & cr_wr & mask[3] ;
  assign csalias0_high_hbyte2_wr = csalias0_high_h_sel & cr_wr & mask[2] ;
  assign csalias0_high_lbyte1_wr = csalias0_high_l_sel & cr_wr & mask[1] ;
  assign csalias0_high_lbyte0_wr = csalias0_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------
  // CSALIAS1 & CASALIAS11 Byte writes
  //----------------------------------

  assign csalias1_low_byte3_wr  = csalias1_low_sel   & cr_wr & mask[3] ;
  assign csalias1_low_byte2_wr  = csalias1_low_sel   & cr_wr & mask[2] ;
  assign csalias1_low_byte1_wr  = csalias1_low_sel   & cr_wr & mask[1] ;
  assign csalias1_low_hbyte3_wr = csalias1_low_h_sel & cr_wr & mask[3] ;
  assign csalias1_low_hbyte2_wr = csalias1_low_h_sel & cr_wr & mask[2] ;
  assign csalias1_low_lbyte1_wr = csalias1_low_l_sel & cr_wr & mask[1] ;

  assign csalias1_high_byte3_wr  = csalias1_high_sel    & cr_wr & mask[3] ;
  assign csalias1_high_byte2_wr  = csalias1_high_sel    & cr_wr & mask[2] ;
  assign csalias1_high_byte1_wr  = csalias1_high_sel    & cr_wr & mask[1] ;
  assign csalias1_high_byte0_wr  = csalias1_high_sel    & cr_wr & mask[0] ;
  assign csalias1_high_hbyte3_wr = csalias1_high_h_sel  & cr_wr & mask[3] ;
  assign csalias1_high_hbyte2_wr = csalias1_high_h_sel  & cr_wr & mask[2] ;
  assign csalias1_high_lbyte1_wr = csalias1_high_l_sel  & cr_wr & mask[1] ;
  assign csalias1_high_lbyte0_wr =  csalias1_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------
  // CSREMAP0 & CAREMAP01 Byte writes
  //----------------------------------

  assign csremap0_low_byte3_wr  = csremap0_low_sel   & cr_wr & mask[3] ;
  assign csremap0_low_byte2_wr  = csremap0_low_sel   & cr_wr & mask[2] ;
  assign csremap0_low_byte1_wr  = csremap0_low_sel   & cr_wr & mask[1] ;
  assign csremap0_low_hbyte3_wr = csremap0_low_h_sel & cr_wr & mask[3] ;
  assign csremap0_low_hbyte2_wr = csremap0_low_h_sel & cr_wr & mask[2] ;
  assign csremap0_low_lbyte1_wr = csremap0_low_l_sel & cr_wr & mask[1] ;

  assign csremap0_high_byte3_wr  = csremap0_high_sel & cr_wr & mask[3] ;
  assign csremap0_high_byte2_wr  = csremap0_high_sel & cr_wr & mask[2] ;
  assign csremap0_high_byte1_wr  = csremap0_high_sel & cr_wr & mask[1] ;
  assign csremap0_high_byte0_wr  = csremap0_high_sel & cr_wr & mask[0] ;
  assign csremap0_high_hbyte3_wr = csremap0_high_h_sel & cr_wr & mask[3] ;
  assign csremap0_high_hbyte2_wr = csremap0_high_h_sel & cr_wr & mask[2] ;
  assign csremap0_high_lbyte1_wr = csremap0_high_l_sel & cr_wr & mask[1] ;
  assign csremap0_high_lbyte0_wr = csremap0_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------
  // CSREMAP1 & CSREMAP11 Byte writes
  //----------------------------------

  assign csremap1_low_byte3_wr  = csremap1_low_sel & cr_wr & mask[3] ;
  assign csremap1_low_byte2_wr  = csremap1_low_sel & cr_wr & mask[2] ;
  assign csremap1_low_byte1_wr  = csremap1_low_sel & cr_wr & mask[1] ;
  assign csremap1_low_hbyte3_wr = csremap1_low_h_sel & cr_wr & mask[3] ;
  assign csremap1_low_hbyte2_wr = csremap1_low_h_sel & cr_wr & mask[2] ;
  assign csremap1_low_lbyte1_wr = csremap1_low_l_sel & cr_wr & mask[1] ;

  assign csremap1_high_byte3_wr  = csremap1_high_sel & cr_wr & mask[3] ;
  assign csremap1_high_byte2_wr  = csremap1_high_sel & cr_wr & mask[2] ;
  assign csremap1_high_byte1_wr  = csremap1_high_sel & cr_wr & mask[1] ;
  assign csremap1_high_byte0_wr  = csremap1_high_sel & cr_wr & mask[0] ;
  assign csremap1_high_hbyte3_wr = csremap1_high_h_sel & cr_wr & mask[3] ;
  assign csremap1_high_hbyte2_wr = csremap1_high_h_sel & cr_wr & mask[2] ;
  assign csremap1_high_lbyte1_wr = csremap1_high_l_sel & cr_wr & mask[1] ;
  assign csremap1_high_lbyte0_wr = csremap1_high_l_sel & cr_wr & mask[0] ;

  //----------------------------------------------------------------------
  // SCONR byte write signals
  //----------------------------------------------------------------------

  assign sconr_lbyte0_wr = sconr_l_sel & cr_wr & mask[0];
  assign sconr_lbyte1_wr = sconr_l_sel & cr_wr & mask[1];
  assign sconr_hbyte2_wr = sconr_h_sel & cr_wr & mask[2];
  assign sconr_byte0_wr  = sconr_sel & cr_wr & mask[0];
  assign sconr_byte1_wr  = sconr_sel & cr_wr & mask[1];
  assign sconr_byte2_wr  = sconr_sel & cr_wr & mask[2];

  //----------------------------------------------------------------------
  // SFCONR byte write signals
  //----------------------------------------------------------------------
 
  assign sfconr_lbyte0_wr = sfconr_l_sel & cr_wr & mask[0];
  assign sfconr_lbyte1_wr = sfconr_l_sel & cr_wr & mask[1];
  assign sfconr_byte0_wr  = sfconr_sel & cr_wr & mask[0];
  assign sfconr_byte1_wr  = sfconr_sel & cr_wr & mask[1];

  //----------------------------------------------------------------------
  // SFCTLR byte write signals
  //----------------------------------------------------------------------
 
  assign sfctlr_lbyte0_wr = sfctlr_l_sel & cr_wr & mask[0];
  assign sfctlr_byte0_wr  = sfctlr_sel & cr_wr & mask[0];

  //----------------------------------------------------------------------
  // SFTMGR byte write signals
  //----------------------------------------------------------------------

  assign sftmgr_lbyte0_wr = sftmgr_l_sel & cr_wr & mask[0];
  assign sftmgr_lbyte1_wr = sftmgr_l_sel & cr_wr & mask[1];
  assign sftmgr_byte0_wr  = sftmgr_sel & cr_wr & mask[0];
  assign sftmgr_byte1_wr  = sftmgr_sel & cr_wr & mask[1];

  //----------------------------------------------------------------------
  // STMG0R byte write signals
  //----------------------------------------------------------------------

  assign stmg0r_lbyte0_wr = stmg0r_l_sel & cr_wr & mask[0];
  assign stmg0r_lbyte1_wr = stmg0r_l_sel & cr_wr & mask[1];
  assign stmg0r_hbyte2_wr = stmg0r_h_sel & cr_wr & mask[2];
  assign stmg0r_hbyte3_wr = stmg0r_h_sel & cr_wr & mask[3];
  assign stmg0r_byte0_wr = stmg0r_sel & cr_wr & mask[0];
  assign stmg0r_byte1_wr = stmg0r_sel & cr_wr & mask[1];
  assign stmg0r_byte2_wr = stmg0r_sel & cr_wr & mask[2];
  assign stmg0r_byte3_wr = stmg0r_sel & cr_wr & mask[3];

  //----------------------------------------------------------------------
  // STMG1R byte write signals
  //----------------------------------------------------------------------

  assign stmg1r_lbyte0_wr = stmg1r_l_sel & cr_wr & mask[0];
  assign stmg1r_lbyte1_wr = stmg1r_l_sel & cr_wr & mask[1];
  assign stmg1r_hbyte2_wr = stmg1r_h_sel & cr_wr & mask[2];
  assign stmg1r_byte0_wr = stmg1r_sel & cr_wr & mask[0];
  assign stmg1r_byte1_wr = stmg1r_sel & cr_wr & mask[1];
  assign stmg1r_byte2_wr = stmg1r_sel & cr_wr & mask[2];

  //----------------------------------------------------------------------
  // SCTLR byte write signals
  //----------------------------------------------------------------------

  assign sctlr_lbyte0_wr = sctlr_l_sel & cr_wr & mask[0];
  assign sctlr_lbyte1_wr = sctlr_l_sel & cr_wr & mask[1];
  assign sctlr_hbyte2_wr = sctlr_h_sel & cr_wr & mask[2];
  assign sctlr_byte0_wr  = sctlr_sel & cr_wr & mask[0];
  assign sctlr_byte1_wr  = sctlr_sel & cr_wr & mask[1];
  assign sctlr_byte2_wr  = sctlr_sel & cr_wr & mask[2];

  //----------------------------------------------------------------------
  // SREFR byte write signals
  //----------------------------------------------------------------------

  assign srefr_lbyte0_wr = srefr_l_sel & cr_wr & mask[0];
  assign srefr_lbyte1_wr = srefr_l_sel & cr_wr & mask[1];
  assign srefr_hbyte2_wr = srefr_h_sel & cr_wr & mask[2];
  assign srefr_hbyte3_wr = srefr_h_sel & cr_wr & mask[3];
  assign srefr_byte0_wr  = srefr_sel & cr_wr & mask[0];
  assign srefr_byte1_wr  = srefr_sel & cr_wr & mask[1];
  assign srefr_byte2_wr  = srefr_sel & cr_wr & mask[2];
  assign srefr_byte3_wr  = srefr_sel & cr_wr & mask[3];

  //----------------------------------------------------------------------
  // SMSKr0 byte write signals
  //----------------------------------------------------------------------

  assign smskr0_lbyte0_wr = smskr0_l_sel & cr_wr & mask[0];
  assign smskr0_lbyte1_wr = smskr0_l_sel & cr_wr & mask[1];
  assign smskr0_byte0_wr  = smskr0_sel & cr_wr & mask[0];
  assign smskr0_byte1_wr  = smskr0_sel & cr_wr & mask[1];

  //----------------------------------------------------------------------
  // SMSKR1 byte write signals
  //----------------------------------------------------------------------

  assign smskr1_lbyte0_wr = smskr1_l_sel & cr_wr & mask[0];
  assign smskr1_lbyte1_wr = smskr1_l_sel & cr_wr & mask[1];
  assign smskr1_byte0_wr  = smskr1_sel & cr_wr & mask[0];
  assign smskr1_byte1_wr  = smskr1_sel & cr_wr & mask[1];

  //----------------------------------------------------------------------
  // SMSKR2 byte write signals
  //----------------------------------------------------------------------

  assign smskr2_lbyte0_wr = smskr2_l_sel & cr_wr & mask[0];
  assign smskr2_lbyte1_wr = smskr2_l_sel & cr_wr & mask[1];
  assign smskr2_byte0_wr  = smskr2_sel & cr_wr & mask[0];
  assign smskr2_byte1_wr  = smskr2_sel & cr_wr & mask[1];

  //----------------------------------------------------------------------
  // SMSKR3 byte write signals
  //----------------------------------------------------------------------

  assign smskr3_lbyte0_wr = smskr3_l_sel & cr_wr & mask[0];
  assign smskr3_lbyte1_wr = smskr3_l_sel & cr_wr & mask[1];
  assign smskr3_byte0_wr  = smskr3_sel & cr_wr & mask[0];
  assign smskr3_byte1_wr  = smskr3_sel & cr_wr & mask[1];

  //----------------------------------------------------------------------
  // SMSKR4 byte write signals
  //----------------------------------------------------------------------

  assign smskr4_lbyte0_wr = smskr4_l_sel & cr_wr & mask[0];
  assign smskr4_lbyte1_wr = smskr4_l_sel & cr_wr & mask[1];
  assign smskr4_byte0_wr  = smskr4_sel & cr_wr & mask[0];
  assign smskr4_byte1_wr  = smskr4_sel & cr_wr & mask[1];

  //----------------------------------------------------------------------
  // SMSKR5 byte write signals
  //----------------------------------------------------------------------

  assign smskr5_lbyte0_wr = smskr5_l_sel & cr_wr & mask[0];
  assign smskr5_lbyte1_wr = smskr5_l_sel & cr_wr & mask[1];
  assign smskr5_byte0_wr  = smskr5_sel & cr_wr & mask[0];
  assign smskr5_byte1_wr  = smskr5_sel & cr_wr & mask[1];

  //----------------------------------------------------------------------
  // SMSKR6 byte write signals
  //----------------------------------------------------------------------

  assign smskr6_lbyte0_wr = smskr6_l_sel & cr_wr & mask[0];
  assign smskr6_lbyte1_wr = smskr6_l_sel & cr_wr & mask[1];
  assign smskr6_byte0_wr  = smskr6_sel & cr_wr & mask[0];
  assign smskr6_byte1_wr  = smskr6_sel & cr_wr & mask[1];

  //----------------------------------------------------------------------
  // SMSKR7 byte write signals
  //----------------------------------------------------------------------

  assign smskr7_lbyte0_wr = smskr7_l_sel & cr_wr & mask[0];
  assign smskr7_lbyte1_wr = smskr7_l_sel & cr_wr & mask[1];
  assign smskr7_byte0_wr  = smskr7_sel & cr_wr & mask[0];
  assign smskr7_byte1_wr  = smskr7_sel & cr_wr & mask[1];

  //------------------------------------------------------------------
  // EXN_MODE_REG register Byte writes
  //------------------------------------------------------------------

  assign exn_mode_reg_lbyte0_wr = exn_mode_reg_l_sel & cr_wr & mask[0];
  assign exn_mode_reg_lbyte1_wr = exn_mode_reg_l_sel & cr_wr & mask[1];
  assign exn_mode_reg_byte0_wr  = exn_mode_reg_sel & cr_wr & mask[0];
  assign exn_mode_reg_byte1_wr  = exn_mode_reg_sel & cr_wr & mask[1];

  //------------------------------------------------------------------
  // EXN_MODE_REG registr select signals
  //------------------------------------------------------------------

  assign exn_mode_reg_sel = (hiu_addr[7:2] == `EXN_MODE_REG_ADDR);
  assign exn_mode_reg_l_sel = exn_mode_reg_sel & (l_half_word == 1);

  // SyncFlash_trpdr and t_init share
  assign sf_trpdr          = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `T_INIT : stmg1r[15:0];

  assign exn_mode_value    = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `EXTENDED_MODE_REG :exn_mode_reg;

  assign operation_code    = syflash_opcode[11:0];
  assign flash_operation   = syflash_opcode[12];
  assign do_initialize     = sctlr[0];
  assign do_self_ref_rp    = sctlr[1];
  assign do_power_down     = sctlr[2];
  assign delayed_precharge = sctlr[3];
  assign ref_all_before_sr = sctlr[4];
  assign ref_all_after_sr  = sctlr[5];
  assign read_pipe         = sctlr[8:6];
  assign mode_reg_update   = sctlr[9];


  assign software_sequence = sctlr[10];
  assign sf_mode_reg_update = sfctlr[2] ;
  assign do_sf_power_down  = sfctlr[1];
  assign do_sf_deep_pwr_dn = sfctlr[0];

  assign num_open_banks    = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `OPEN_BANKS :open_banks_o;

  assign s_ready_valid     = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `S_READY_VALID: sctlr[17];

  assign exn_mode_reg_update=sctlr[18];
  
  assign mobile_sdram_dpd_en = sctlr[19];

  assign sf_row_addr_width = `HARD_WIRE_SYNCFLASH_PARAMETERS==1 ?
                             `SF_ROW_ADDR_WIDTH-1 :sfconr[5:2];

  assign sf_col_addr_width = `HARD_WIRE_SYNCFLASH_PARAMETERS==1 ?
                             `SF_COL_ADDR_WIDTH-1 :sfconr[9:6];

  assign sf_bank_addr_width = `HARD_WIRE_SYNCFLASH_PARAMETERS==1 ?
                             `SF_BANK_ADDR_WIDTH-1 :sfconr[1:0];

  assign row_addr_width    = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `S_ROW_ADDR_WIDTH-1 :sconr[8:5];

  assign col_addr_width    = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `S_COL_ADDR_WIDTH-1 :sconr[12:9];

  assign bank_addr_width   = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `S_BANK_ADDR_WIDTH-1:sconr[4:3];

  assign s_sa              = sconr[17:15];
  assign s_scl             = sconr[18];
  assign s_sda_out         = sconr[19];
  assign s_sda_oe_n        = sconr[20];


  assign mem_size0         = `BLOCK_SIZE0;
  assign mem_size1         = `BLOCK_SIZE1;
  assign mem_size2         = `BLOCK_SIZE2;
  assign mem_size3         = `BLOCK_SIZE3;
  assign mem_size4         = `BLOCK_SIZE4;
  assign mem_size5         = `BLOCK_SIZE5;
  assign mem_size6         = `BLOCK_SIZE6;
  assign mem_size7         = `BLOCK_SIZE7;
  assign mem_type0         = `CHIP_SELECT0_MEM ;
  assign mem_type1         = `CHIP_SELECT1_MEM;
  assign mem_type2         = `CHIP_SELECT2_MEM;
  assign mem_type3         = `CHIP_SELECT3_MEM;
  assign mem_type4         = `CHIP_SELECT4_MEM;
  assign mem_type5         = `CHIP_SELECT5_MEM;
  assign mem_type6         = `CHIP_SELECT6_MEM;
  assign mem_type7         = `CHIP_SELECT7_MEM;
  assign reg_select0       = `REG_SELECT0 ;
  assign reg_select1       = `REG_SELECT1;
  assign reg_select2       = `REG_SELECT2;
  assign reg_select3       = `REG_SELECT3;
  assign reg_select4       = `REG_SELECT4;
  assign reg_select5       = `REG_SELECT5;
  assign reg_select6       = `REG_SELECT6;
  assign reg_select7       = `REG_SELECT7;

  assign scslr0_addr       = `CHIP_SELECT0_BASE_ADDRESS;
  assign scslr1_addr       = `CHIP_SELECT1_BASE_ADDRESS;
  assign scslr2_addr       = `CHIP_SELECT2_BASE_ADDRESS;
  assign scslr3_addr       = `CHIP_SELECT3_BASE_ADDRESS;
  assign scslr4_addr       = `CHIP_SELECT4_BASE_ADDRESS;
  assign scslr5_addr       = `CHIP_SELECT5_BASE_ADDRESS;
  assign scslr6_addr       = `CHIP_SELECT6_BASE_ADDRESS;
  assign scslr7_addr       = `CHIP_SELECT7_BASE_ADDRESS;
  assign csalias0_addr     = `CHIP_SELECT0_ALIAS_ADDRESS;
  assign csalias1_addr     = `CHIP_SELECT1_ALIAS_ADDRESS;
  assign csremap0_addr     = `CHIP_SELECT0_REMAP_ADDRESS;
  assign csremap1_addr     = `CHIP_SELECT1_REMAP_ADDRESS;

  //--------------------------------------------------
  // Bits 4:0 specifies block size and 
  // bits 6:5 specifies the memory type.
  //--------------------------------------------------

  assign mask_reg0         = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                             {reg_select0,mem_type0,mem_size0} :smskr0[10:0];
  assign mask_reg1         = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                             {reg_select1,mem_type1,mem_size1} :
                             `N_CS > 1 ? smskr1[10:0] : 0;
  assign mask_reg2         = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                             {reg_select2,mem_type2,mem_size2} :
                              `N_CS > 2 ? smskr2[10:0] : 0;
  assign mask_reg3         = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                             {reg_select3,mem_type3,mem_size3} :
                              `N_CS > 3 ? smskr3[10:0] : 0;
  assign mask_reg4         = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                             {reg_select4,mem_type4,mem_size4} :
                              `N_CS > 4 ? smskr4[10:0] : 0;
  assign mask_reg5         = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                             {reg_select5,mem_type5,mem_size5} :
                              `N_CS > 5 ? smskr5[10:0] : 0;
  assign mask_reg6         = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                             {reg_select6,mem_type6,mem_size6} :
                              `N_CS > 6 ? smskr6[10:0] : 0;
  assign mask_reg7         = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                             {reg_select7,mem_type7,mem_size7} :
                              `N_CS > 7 ? smskr7[10:0] : 0;

  assign cas_latency       = `HARD_WIRE_SDRAM_PARAMETERS==1 ?
                             `CAS_LATENCY : cas_latency_o;


  assign sf_t_rcd          = `HARD_WIRE_SYNCFLASH_PARAMETERS==1 ?
                             `SF_T_RCD-1 : 3'b000;

  assign sf_cas_latency    = `HARD_WIRE_SYNCFLASH_PARAMETERS==1 ?
                             `SF_CAS_LATENCY : 3'b000;

  assign sf_t_rc           = `HARD_WIRE_SYNCFLASH_PARAMETERS==1 ?
                             `SF_T_RC-1 : 4'b0000;

  assign t_ras_min         = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `T_RAS_MIN-1 :stmg0r[5:2];

  assign t_rcd             = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `T_RCD-1 :stmg0r[8:6];

  assign t_rp              = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `T_RP-1 :stmg0r[11:9];

  assign t_wr              = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `T_WR-1 :stmg0r[13:12];

  assign t_rcar            = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `T_RCAR-1:stmg0r[17:14];

  assign t_xsr             = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `T_XSR-1 :{stmg0r[31:27],stmg0r[21:18]};

  assign t_rc              = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `T_RC-1 :stmg0r[25:22];

  assign t_init            = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `T_INIT :stmg1r[15:0];

  assign num_init_ref      = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `NUM_INIT_REF-1 :stmg1r[19:16];

  assign t_wtr             = `HARD_WIRE_SDRAM_PARAMETERS==1 ? 
                             `T_WTR-1 :stmg1r[21:20];

  assign t_ref             = srefr[15:0];
  assign gpo               = srefr[23:16];

  assign chipsel_register0 = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                              scslr0_addr[`H_ADDR_WIDTH-1:16] :
                              `N_CS>1 ? scslr0[`H_ADDR_WIDTH-1:16] :0;

  assign chipsel_register1 = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                              scslr1_addr[`H_ADDR_WIDTH-1:16] :
                              `N_CS>1 ? scslr1[`H_ADDR_WIDTH-1:16] :0;

  assign chipsel_register2 = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                              scslr2_addr[`H_ADDR_WIDTH-1:16] :
                              `N_CS>2 ? scslr2[`H_ADDR_WIDTH-1:16] :0;

  assign chipsel_register3 = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                              scslr3_addr[`H_ADDR_WIDTH-1:16] :
                              `N_CS>3 ? scslr3[`H_ADDR_WIDTH-1:16] :0;

  assign chipsel_register4 = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                              scslr4_addr[`H_ADDR_WIDTH-1:16] :
                              `N_CS>4 ? scslr4[`H_ADDR_WIDTH-1:16] :0;

  assign chipsel_register5 = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                              scslr5_addr[`H_ADDR_WIDTH-1:16] :
                              `N_CS>5 ? scslr5[`H_ADDR_WIDTH-1:16] :0;

  assign chipsel_register6 = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                              scslr6_addr[`H_ADDR_WIDTH-1:16] :
                              `N_CS>6 ? scslr6[`H_ADDR_WIDTH-1:16] :0;

  assign chipsel_register7 = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ? 
                              scslr7_addr[`H_ADDR_WIDTH-1:16] :
                              `N_CS>7 ? scslr7[`H_ADDR_WIDTH-1:16] :0;

  assign alias_register0   = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ?
                              csalias0_addr[`H_ADDR_WIDTH-1:16] :
                              (`CHIP_SEL0_ALIAS_ENABLE ==1) ? 
                              csalias0[`H_ADDR_WIDTH-1:16] : 0;

  assign alias_register1   = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ?
                              csalias1_addr[`H_ADDR_WIDTH-1:16] :
                              (`CHIP_SEL1_ALIAS_ENABLE ==1) ? 
                              csalias1[`H_ADDR_WIDTH-1:16] : 0;

  assign remap_register0   = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ?
                              csremap0_addr[`H_ADDR_WIDTH-1:16] : 
                              (`CHIP_SEL0_REMAP_ENABLE ==1) ? 
                              csremap0[`H_ADDR_WIDTH-1:16] : 0;

  assign remap_register1   = `HARD_WIRE_CIPSELECT_PARAMETRS ==1 ?
                              csremap1_addr[`H_ADDR_WIDTH-1:16] : 
                              (`CHIP_SEL1_REMAP_ENABLE ==1) ? 
                              csremap1[`H_ADDR_WIDTH-1:16] : 0;

  assign mask = ~h_mask_int;

  assign data_width_default = (`DYNAMIC_RAM_TYPE ==1) ?
                       (`S_DATA_WIDTH == 8 ? 0 : `S_DATA_WIDTH ==16 ? 1 :
                        `S_DATA_WIDTH == 32 ? 2 : 3) :
                       (`S_DATA_WIDTH == 16 ? 0 : `S_DATA_WIDTH ==32 ? 1 :
                        `S_DATA_WIDTH == 64 ? 2 : 3);


  assign sconr_default[31:21] = 0;
  assign sconr_default[20:15] = sconr[20:15];
  assign sconr_default[14:13] = data_width_default;
  assign sconr_default[12:9] = `S_COL_ADDR_WIDTH-1;
  assign sconr_default[8:5] = `S_ROW_ADDR_WIDTH-1;
  assign sconr_default[4:3] = `S_BANK_ADDR_WIDTH-1;
  assign sconr_default[2:0] = 0;


  assign sfconr_default[31:10] = 0;
  assign sfconr_default[9:6] = `SF_COL_ADDR_WIDTH-1;
  assign sfconr_default[5:2] = `SF_ROW_ADDR_WIDTH-1;
  assign sfconr_default[1:0] = `SF_BANK_ADDR_WIDTH-1;

  assign sftmgr_default[2:0]   = `SF_CAS_LATENCY-1;
  assign sftmgr_default[5:3]   = `SF_T_RCD-1;
  assign sftmgr_default[9:6] = `SF_T_RC-1;
  assign sftmgr_default[31:10] = 22'h000000;

  assign {stmg0r_default[26],stmg0r_default[1:0]}   = `CAS_LATENCY-1;
  assign stmg0r_default[5:2]   = `T_RAS_MIN-1;
  assign stmg0r_default[8:6]   = `T_RCD-1;
  assign stmg0r_default[11:9]  = `T_RP-1;
  assign stmg0r_default[13:12] = `T_WR-1;
  assign stmg0r_default[17:14] = `T_RCAR-1;
  assign {stmg0r_default[31:27],stmg0r_default[21:18]} = `T_XSR-1;
  assign stmg0r_default[25:22] = `T_RC-1;


  assign stmg1r_default[15:0]  =`T_INIT;
  assign stmg1r_default[19:16] =`NUM_INIT_REF-1;
  assign stmg1r_default[21:20] =`T_WTR-1;
  assign stmg1r_default[31:22] =10'h000;

   assign memctl_comp_params_1_default[31:21] = 0;
   assign memctl_comp_params_1_default[20] = `USE_MOBILE_DDR;
   assign memctl_comp_params_1_default[19] = `CHIP_SEL1_REMAP_ENABLE;
   assign memctl_comp_params_1_default[18] = `CHIP_SEL0_REMAP_ENABLE;
   assign memctl_comp_params_1_default[17] = `CHIP_SEL1_ALIAS_ENABLE;
   assign memctl_comp_params_1_default[16] = `CHIP_SEL0_ALIAS_ENABLE;
   assign memctl_comp_params_1_default[15] = `HARD_WIRE_SYNCFLASH_PARAMETERS;
   assign memctl_comp_params_1_default[14] = `HARD_WIRE_STATIC_PARAMETERS;
   assign memctl_comp_params_1_default[13] = `HARD_WIRE_SDRAM_PARAMETERS;
   assign memctl_comp_params_1_default[12] = `HARD_WIRE_CIPSELECT_PARAMETRS;
   assign memctl_comp_params_1_default[11] = `VER_1_2A_COMPATIABLE_MODE;
   assign memctl_comp_params_1_default[10:8] = `N_CS - 1;   
   assign memctl_comp_params_1_default[7] = `ENABLE_STATIC;
   assign memctl_comp_params_1_default[6:4] = `DYNAMIC_RAM_TYPE;
   assign memctl_comp_params_1_default[3] = 0;
   assign memctl_comp_params_1_default[2] = (`H_ADDR_WIDTH == 32) ? 0 : 
                                                         /* 64 */   1 ;
   assign memctl_comp_params_1_default[1:0] = (`H_DATA_WIDTH == 32) ? 0 :
	                                      (`H_DATA_WIDTH == 64) ? 1 : 
                                                          /* 128 */   2 ;
   
   assign memctl_comp_params_2_default[31:16] = 0;
   assign memctl_comp_params_2_default[15:13] = (`MAX_SM_DATA_WIDTH == 8)  ? 0 :
                                                (`MAX_SM_DATA_WIDTH == 16) ? 1 :
	                                        (`MAX_SM_DATA_WIDTH == 32) ? 2 :
                                                (`MAX_SM_DATA_WIDTH == 64) ? 3 :  
                                                                 /* 128 */   4 ;
   assign memctl_comp_params_2_default[12:8] = `MAX_SM_ADDR_WIDTH - 11;
   assign memctl_comp_params_2_default[7:5] = (`MAX_S_DATA_WIDTH == 8)  ? 0 :
	                                      (`MAX_S_DATA_WIDTH == 16) ? 1 :
	                                      (`MAX_S_DATA_WIDTH == 32) ? 2 :
	                                      (`MAX_S_DATA_WIDTH == 64) ? 3 :
                                                              /* 128 */   4 ;
   assign memctl_comp_params_2_default[4:3] = `MAX_S_BANK_ADDR_WIDTH - 1;
   assign memctl_comp_params_2_default[2:0] = `MAX_S_ADDR_WIDTH - 11;
   
  assign sctlr_default[31:21] = 0;
  assign sctlr_default[20:18] = sctlr[20:18];
  assign sctlr_default[17]    = `S_READY_VALID;
  assign sctlr_default[16:12] = `OPEN_BANKS-1;
  assign sctlr_default[11:0]  = sctlr[11:0];
   
  assign disable_write = (`VER_1_2A_COMPATIABLE_MODE == 0) ? 0 : 1;



  //--------------------------------------------------------------
  // hiu_data_mask from the address decoder is w.r.t H_DATA_WIDTH
  // So checking for sdram_data_width is not required.h_mask_int1
  // and h_mask_int are intermmediate values.
  // Mask is active low in this module .
  //-------------------------------------------------------------
  // leda W456 off
  // leda C_2C_R off
  // leda W502 off
  always@(hiu_addr or hiu_data_mask or h_mask_int1 or big_endian)
    begin
      h_mask_int1=0;
      h_mask_i=0;
      case(`H_DATA_WIDTH)
        128: begin
          if (!big_endian) begin
            h_mask_int1=!hiu_addr[3]?hiu_data_mask[`H_DATA_WIDTH/16-1:0]:
                         hiu_data_mask[`H_DATA_WIDTH/8-1:`H_DATA_WIDTH/16];
            h_mask_i =!hiu_addr[2]?h_mask_int1[3:0]:
                         h_mask_int1[`H_DATA_WIDTH/16-1:`H_DATA_WIDTH/32];
          end
          else begin
            h_mask_int1=hiu_addr[3]?hiu_data_mask[`H_DATA_WIDTH/16-1:0]:
                         hiu_data_mask[`H_DATA_WIDTH/8-1:`H_DATA_WIDTH/16];
            h_mask_i =hiu_addr[2]?h_mask_int1[3:0]:
                         h_mask_int1[`H_DATA_WIDTH/16-1:`H_DATA_WIDTH/32];
          end
        end
        64: begin
          if (!big_endian) 
            h_mask_i =!hiu_addr[2]?hiu_data_mask[3:0]:
                         hiu_data_mask[`H_DATA_WIDTH/8-1:`H_DATA_WIDTH/16];
          else
            h_mask_i =hiu_addr[2]?hiu_data_mask[3:0]:
                         hiu_data_mask[`H_DATA_WIDTH/8-1:`H_DATA_WIDTH/16];
        end
        default: begin
           h_mask_i = hiu_data_mask;
        end
      endcase
    end

  // ------ Possible cases of data widths ----------------------------
  //
  //  Case 1. H_DATA_WIDTH=128 
  //
  //   15 14  13  12  11  10  9  8  7  6  5  4  3  2  1  0  (Bytes)
  //   ----------------------------------------------------
  //  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   |   |
  //   ----------------------------------------------------
  // 
  // h_addr[3] determines wheather to take lower/upper 64 bits.
  // h_addr[2] determines wheather to take lower/upper 32 bits.
  // h_wr_data_int1 holds the intermmediate 64 bit data
  // h_wr_data_int  holds tha actual 32 bits data to be written.
  //
  // Case 2:- H_DATA_WIDTH=64
  //          Here one needs to decide only between lower/upper 32 bits.
  //          so Only h_addr[2] is used.
  // Case 3:- H_DATA_WIDTH = 32
  //          In this case hiu_wr_data is taken directly.
  //----------------------------------------------------------------------



  always@(hiu_wr_data or h_wr_data_int1 or hiu_addr or sdram_data_width or
           big_endian)
  begin: PROCESS_2
    integer u;
    h_wr_data_int1=0;
    h_wr_data_i=0;
     case(`H_DATA_WIDTH)
      128:begin        
        case(sdram_data_width) 
          2'h3: begin
            if (big_endian==0) begin
              if ((hiu_addr[3] ==0) || (`S_RD_DATA_WIDTH != 128)) begin
                for(u=0;u<=63;u=u+1)
                  h_wr_data_int1[u] = hiu_wr_data[u];
              end
              else begin
                for(u=64;u<=127;u=u+1)
                  h_wr_data_int1[u-64] = hiu_wr_data[u];
              end
              if (hiu_addr[2] == 0) begin
                 for(u=0;u<=31;u=u+1)
                   h_wr_data_i[u] = h_wr_data_int1[u];
              end
              else begin
                for(u=32;u<=63;u=u+1)
                  h_wr_data_i[u-32] = h_wr_data_int1[u];
              end
             end   // Little endian
             else begin   // big endian
               if ((hiu_addr[3] ==1) || (`S_RD_DATA_WIDTH != 128)) begin
                 for(u=0;u<=63;u=u+1)
                   h_wr_data_int1[u] = hiu_wr_data[u];
               end
               else begin
                 for(u=64;u<=127;u=u+1)
                   h_wr_data_int1[u-64] = hiu_wr_data[u];
               end
               if (hiu_addr[2] == 1) begin
                  for(u=0;u<=31;u=u+1)
                    h_wr_data_i[u] = h_wr_data_int1[u];
               end
               else begin
                 for(u=32;u<=63;u=u+1)
                   h_wr_data_i[u-32] = h_wr_data_int1[u];
               end
             end   // big endian
           end
          default : begin
            h_wr_data_int1 = hiu_wr_data ;
            if (big_endian==0) begin 
               for(u=0;u<=31;u=u+1) 
                 h_wr_data_i[u] = !hiu_addr[2] ?h_wr_data_int1[u] :
                                     h_wr_data_int1[32+u];
                end   // Little endian
            else begin   // Big endian
                for(u=0;u<=31;u=u+1) 
                   h_wr_data_i[u] = hiu_addr[2] ?h_wr_data_int1[u] :
                                      h_wr_data_int1[32+u];
                end   // Big endian
            end
          endcase
        end
    64: begin
        case(sdram_data_width) 
           2'h2: begin   // Data width in ratio 1:1 
             if (big_endian==0) begin
                if ((hiu_addr[2]==0) || (`S_RD_DATA_WIDTH != 64)) begin
                  for(u=0;u<=31;u=u+1)
                    h_wr_data_i[u] = hiu_wr_data[u];
                end
                else begin
                  for(u=32;u<=63;u=u+1)
                    h_wr_data_i[u-32] = hiu_wr_data[u];
                end
             end   //Little endian
             else begin   // Big endian
                if ((hiu_addr[2]==1) || (`S_RD_DATA_WIDTH != 64)) begin
                  for(u=0;u<=31;u=u+1)
                    h_wr_data_i[u] = hiu_wr_data[u];
                end
                else begin
                  for(u=32;u<=63;u=u+1)
                    h_wr_data_i[u-32] = hiu_wr_data[u];
                end
              end   //Big endian
           end
       default : begin
           h_wr_data_i =hiu_wr_data;
           end
      endcase
        end
       
    default : begin
        h_wr_data_i=hiu_wr_data;
        end
    endcase
  end

  //---------------------------------------------------------------
  // Data from the HIU needs to be byte swapped for the big_endian 
  // cases. Also the Masks need to be swapped
  //----------------------------------------------------------------

  always@(h_wr_data_i or big_endian or h_mask_i or sdram_data_width)
    begin
      if (sdram_data_width ==0) begin // 2:1
          if (big_endian) begin
             h_wr_data_int[7:0]   = h_wr_data_i[15:8];
             h_wr_data_int[15:8]  = h_wr_data_i[7:0];
             h_wr_data_int[31:16] = 16'h0000;
             h_mask_int = {h_mask_i[0],h_mask_i[1],h_mask_i[2],h_mask_i[3]};
             end
          else begin
             h_wr_data_int = h_wr_data_i;
             h_mask_int = h_mask_i;
             end
          end
        else  begin // 1:1
          if (big_endian) begin
             h_wr_data_int[7:0]   = h_wr_data_i[31:24];
             h_wr_data_int[15:8]  = h_wr_data_i[23:16];
             h_wr_data_int[23:16] = h_wr_data_i[15:8];
             h_wr_data_int[31:24] = h_wr_data_i[7:0]; 
             h_mask_int = {h_mask_i[0],h_mask_i[1],h_mask_i[2],h_mask_i[3]};
             end
           else begin
             h_wr_data_int = h_wr_data_i;
             h_mask_int = h_mask_i;
             end
         end
   end

  //------------------------------------------------------------
  // Intermmediate Read data. Again one needs to decide between 
  // Lower/Upper 64 bits ( h_addr[3])  and Lower/Upper 32 bits
  // (h_addr[2])
  //                 -------------------------------
  // h_rd_data_int  |f|e|d|c|b|a|9|8|7|6|5|4|3|2|1|0| (bytes)
  //                 -------------------------------
  //                                 ---------------
  // h_rd_data_int1                 |7|6|5|4|3|2|1|0| (bytes)
  //                                 ---------------
  //                                         -------
  // reg_rd_data_out                        |3|2|1|0| (bytes)
  //                                         -------
  //-----------------------------------------------------------

  always@(reg_rd_data_out or h_rd_data_int1 or hiu_addr or big_endian
          or sdram_data_width)
  begin: PROCESS_3
    integer t;
    h_rd_data_int1=0;
    h_rd_data_int=0;
  case(`H_DATA_WIDTH)
    128:begin
      if (big_endian==0) begin //LITTLE_ENDIAN
         if (!hiu_addr[2])
           for(t=0;t<=31;t=t+1) h_rd_data_int1[t]=reg_rd_data_out[t];
         else
           for(t=0;t<=31;t=t+1) h_rd_data_int1[32+t]=reg_rd_data_out[t];
         if (!hiu_addr[3])
           for(t=0;t<=63;t=t+1) h_rd_data_int[t]=h_rd_data_int1[t];
         else
           for(t=0;t<=63;t=t+1) h_rd_data_int[64+t]=h_rd_data_int1[t];
       end // //LITTLE ENDIAN
       else begin // BIG ENDIAN
           if (hiu_addr[2])
             for(t=0;t<=31;t=t+1) h_rd_data_int1[t]=reg_rd_data_out[t];
           else
             for(t=0;t<=31;t=t+1) h_rd_data_int1[32+t]=reg_rd_data_out[t];
           if (hiu_addr[3])
             for(t=0;t<=63;t=t+1) h_rd_data_int[t]=h_rd_data_int1[t];
           else
             for(t=0;t<=63;t=t+1) h_rd_data_int[64+t]=h_rd_data_int1[t];
       end // BIG ENDIAN
    end
    64: begin
      if (sdram_data_width == 2)  // 2:1 
        if (big_endian==0) begin  // LITTLE ENDIAN
          if (!hiu_addr[2])
            for(t=0;t<=31;t=t+1) h_rd_data_int[t]=reg_rd_data_out[t];
          else
            for(t=0;t<=31;t=t+1) h_rd_data_int[32+t]=reg_rd_data_out[t];
        end // LITTLE ENDIAN
        else begin // BIG ENDIAN
          if (hiu_addr[2])
            for(t=0;t<=31;t=t+1) h_rd_data_int[t]=reg_rd_data_out[t];
          else
            for(t=0;t<=31;t=t+1) h_rd_data_int[32+t]=reg_rd_data_out[t];
        end // BIG ENDIAN
      else
       h_rd_data_int=reg_rd_data_out;
    end //64
    default : begin
       h_rd_data_int=reg_rd_data_out;
       end
    endcase
  end
  // leda W502 on
  // leda C_2C_R on
  // leda W456 on


  //-----------------------------------------------------------------
  // SDRAM Config register SCONR Address 00
  // Bits 2:0   - NOT USED
  // Bits 4:3   - SDRAM bank address width
  // Bits 8:5   - SDRAM row address width
  // Bits 12:9  - SDRAM column address width
  // Bit  13    - SDRAM data width Ratio
  // Bit  14    - Unused
  // Bits 17:15 - Serial Presence Detect Address bits
  // Bit  18    - Serial Presence Detect Clock
  // Bit  19    - Serial Presence detect data
  // Bit  20    - Serial Presence detect data enable
  //----------------------------------------------------------------- 

  always@(posedge hclk or negedge hresetn)
  begin: SCONR_PROC
    integer p;
    if (!hresetn) begin
      sconr[2:0]    <=3'b000;
      sconr[4:3]    <=`S_BANK_ADDR_WIDTH-1;
      sconr[8:5]    <=`S_ROW_ADDR_WIDTH-1;
      sconr[12:9]   <=`S_COL_ADDR_WIDTH-1;
      sconr[14:13]  <= (`DYNAMIC_RAM_TYPE ==1) ? 
                       (`S_DATA_WIDTH == 8 ? 0 : `S_DATA_WIDTH ==16 ? 1 :
                        `S_DATA_WIDTH == 32 ? 2 : 3) : 
                       (`S_DATA_WIDTH == 16 ? 0 : `S_DATA_WIDTH ==32 ? 1 :
                        `S_DATA_WIDTH == 64 ? 2 : 3);
      sconr[20:15]  <=6'b111000;
      end
  else begin
     if (sdram_data_width ==0)  begin
         sconr[7:0]   <= sconr_lbyte0_wr ? h_wr_data_int[7:0] : sconr[7:0];
         sconr[12:8]  <= sconr_lbyte1_wr ?  h_wr_data_int[12:8] : sconr[12:8];
         sconr[14:13] <= (sconr_lbyte1_wr && !disable_dw_write) ? 
                          h_wr_data_int[14:13] : sconr[14:13];
         sconr[15]    <= sconr_lbyte1_wr ? h_wr_data_int[15] : sconr[15];
         sconr[20:16] <= sconr_hbyte2_wr ? h_wr_data_int[4:0] : sconr[20:16];
         end
       else  begin
         sconr[7:0]   <= (sconr_byte0_wr) ? h_wr_data_int[7:0]:sconr[7:0];
         sconr[12:8]  <= (sconr_byte1_wr) ? h_wr_data_int[12:8]:sconr[12:8];
         sconr[14:13] <= (sconr_byte1_wr && !disable_dw_write) ? 
                          h_wr_data_int[14:13]:sconr[14:13];
         sconr[15]    <= (sconr_byte1_wr) ? h_wr_data_int[15]:sconr[15];
         if (sconr_byte2_wr && `S_RD_DATA_WIDTH>16)
            for (p=20;p>=16;p=p-1) sconr[p]<=h_wr_data_int[p];
         else
             for (p=20;p>=16;p=p-1) sconr[p]<=sconr[p];
         end
    end
  end

  //-------------------------------------------------------------------------
  // Disable writes to SCONR[14:13] for illegal programming of data widths
  //-------------------------------------------------------------------------
  always@ (h_wr_data_int or sconr_byte1_wr or sconr_lbyte1_wr or sdram_data_width)
    begin
      case (`H_DATA_WIDTH)
        32: begin
          if ((sconr_lbyte1_wr || (sconr_byte1_wr && sdram_data_width !=0)) && 
             (h_wr_data_int[14:13] == 2 || h_wr_data_int[14:13] == 3))
             disable_dw_write = 1'b1;
          else
             disable_dw_write = 1'b0;
          end
        64 : begin
           if (sconr_byte1_wr && (h_wr_data_int[14:13] == 0 || 
               h_wr_data_int[14:13] == 3))
             disable_dw_write = 1'b1;
           else 
             disable_dw_write = 1'b0;
           end
        default : begin
           if (sconr_byte1_wr && (h_wr_data_int[14:13] == 0 || 
               h_wr_data_int[14:13] == 1))
             disable_dw_write = 1'b1;
           else
             disable_dw_write = 1'b0;
           end
       endcase
    end

  // ----------------------------------------------------------------------
  // SDRAM Timing Register0 STMGR0 Address 04
  // Bits 2:0   - Cas Latency
  // Bits 6:3   - t_ras_min ( Min delay between ACTIVE and PRECHARGE commands)
  // Bits 9:7   - t_tcd ( Minimum delay between ACRIVE and READ/WRITE command)
  // Bits 12:10 - t_rp (Precharge Period)
  // Bit  14:13 - t_wr (Last data in to Precharge delay)
  // Bits 18:15 - t_rcar (Auto refresh Period)
  // Bits 27:19 - t_xsr (Exit self refresh to ACTIVE/AUTO_REFRESH time)
  // Bits 31:28 - t_rc  (ACTIVE to ACTIVE command period)
  //-----------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: STMG0R_PROC
    integer l;
    if (!hresetn) begin
        {stmg0r[26],stmg0r[1:0]}   <= `CAS_LATENCY-1;
        stmg0r[5:2]   <= `T_RAS_MIN-1;
        stmg0r[8:6]   <= `T_RCD-1;
        stmg0r[11:9] <= `T_RP-1;
        stmg0r[13:12]    <= `T_WR-1;
        stmg0r[17:14] <= `T_RCAR-1;
        {stmg0r[31:27],stmg0r[21:18]} <= `T_XSR-1;
        stmg0r[25:22] <= `T_RC-1;
      end
  else
     if (sdram_data_width ==0)  begin
         stmg0r[7:0]  <=(stmg0r_lbyte0_wr) ? h_wr_data_int[7:0]:stmg0r[7:0];
         stmg0r[15:8] <=(stmg0r_lbyte1_wr) ? h_wr_data_int[15:8]:stmg0r[15:8];
         stmg0r[23:16]<=(stmg0r_hbyte2_wr) ? h_wr_data_int[7:0]:stmg0r[23:16];
         stmg0r[31:24]<=(stmg0r_hbyte3_wr) ? h_wr_data_int[15:8]:stmg0r[31:24];
        end
     else   begin
         stmg0r[7:0]  <=(stmg0r_byte0_wr) ? h_wr_data_int[7:0]:stmg0r[7:0];
         stmg0r[15:8] <=(stmg0r_byte1_wr) ? h_wr_data_int[15:8]:stmg0r[15:8];
         if (stmg0r_byte2_wr && `S_RD_DATA_WIDTH>16)
             for(l=23;l>=16;l=l-1) stmg0r[l]<=h_wr_data_int[l];
         else for(l=23;l>=16;l=l-1) stmg0r[l] <= stmg0r[l];
         if (stmg0r_byte3_wr && `S_RD_DATA_WIDTH>16)
             for(l=31;l>=24;l=l-1) stmg0r[l]<=h_wr_data_int[l];
         else for(l=31;l>=24;l=l-1) stmg0r[l]<= stmg0r[l];
          end
  end

  //------------------------------------------------------------------------
  // SDRAM Timing Register1 STMG1R Address 08
  // Bits 15:0  - SDRAM Initialization time T_INIT
  // Bits 19:16 - Number of auto refresh during initialization ( num_init_ref) 
  // Bit  21:20 - t_wtr - Internal write to read delay for DDR
  //------------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: STMG1R_PROC
   integer m;
   if (!hresetn)  begin
       stmg1r[15:0]  <=`T_INIT;
       stmg1r[19:16] <=`NUM_INIT_REF-1;
       stmg1r[21:20] <=`T_WTR-1;
     end
   else
       if (sdram_data_width ==0)  begin
          stmg1r[7:0]  <=(stmg1r_lbyte0_wr) ? h_wr_data_int[7:0]:stmg1r[7:0];
          stmg1r[15:8] <=(stmg1r_lbyte1_wr) ? h_wr_data_int[15:8]:stmg1r[15:8];
          stmg1r[21:16]<=(stmg1r_hbyte2_wr) ? h_wr_data_int[5:0]:stmg1r[21:16];
          end
        else  begin
          stmg1r[7:0] <=(stmg1r_byte0_wr) ? h_wr_data_int[7:0]:stmg1r[7:0];
          stmg1r[15:8] <=(stmg1r_byte1_wr) ? h_wr_data_int[15:8]:stmg1r[15:8];
          if (stmg1r_byte2_wr && `S_RD_DATA_WIDTH>16) 
              for(m=21;m>=16;m=m-1) stmg1r[m]<=h_wr_data_int[m];
          end
  end 


  // ---------------------------------------------------------------------
  // SDRAM Control Register SCTLR Address 0C
  // Bit 0      - Initialize SDRAM.
  // Bit 1      - Self_refresh mode fo SDRAM/Deep power down mode for SyncFlash
  // Bit 2      - Power down mode.
  // Bit 3      - Precharge Algorithm.
  // Bit 4      - Controls All_row/Songle_row refresh before self refresh
  // Bit 5      - Controls All_row/Single_row refresh after self refresh.
  // Bits 8:6   - SDRAM read pipe
  // Bit 9      - Set Mode Register request
  // Bit 10     - SyncFlash software sequence
  // Bit 11     - SDRAM Self Refresh status/SyncFlash in deep power down mode status
  // Bits 16:12 - Number of open banks
  // Bit 17     - s_ready_valid - s_ready should be used to latch data
  // Bit 18     - Exn mode reg request valid
  // Bit 19     - Exn Mode register update
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SCTLR_PROC
    if (!hresetn) begin
      sctlr[0]     <= 1'b1;
      sctlr[1]     <= (`DYNAMIC_RAM_TYPE == 2) ? 1'b1 : 1'b0;
      sctlr[5:2]   <= 4'b0010;
      sctlr[8:6]   <= `READ_PIPE;
      sctlr[11:9]  <= 3'b0;
      sctlr[16:12] <= `OPEN_BANKS-1;
      sctlr[17]    <= `S_READY_VALID;
      sctlr[20:18] <= 3'b0;
    end
    else begin
      sctlr[11] <= sd_in_sf_mode;
      sctlr[20] <= sd_in_dpd_mode;
      if (sdram_data_width ==0) begin
        sctlr[0]      <= init_done ? 1'b0 :
                         (sctlr_lbyte0_wr) ? h_wr_data_int[0]: sctlr[0];
        sctlr[1]      <= clr_sctlr_bitone ? 1'b0 :
                         (sctlr_lbyte0_wr) ? h_wr_data_int[1] : sctlr[1];
        sctlr[5:2]    <= (sctlr_lbyte0_wr) ? h_wr_data_int[5:2] :
                         sctlr[5:2];
        sctlr[7:6]    <= (sctlr_lbyte0_wr && !disable_write) ? 
                          h_wr_data_int[7:6] : sctlr[7:6];
        sctlr[8]      <= (sctlr_lbyte1_wr && !disable_write) ? 
                          h_wr_data_int[8] : sctlr[8];
        sctlr[9]      <= mode_reg_done ? 1'b0 :sctlr_lbyte1_wr ? 
                         h_wr_data_int[9]: sctlr[9];
        sctlr[10]     <= sctlr_lbyte1_wr ? h_wr_data_int[10] : sctlr[10];
        sctlr[15:12]  <= sctlr_lbyte1_wr ? h_wr_data_int[15:12]:
                         sctlr[15:12];
        sctlr[17:16]  <= sctlr_hbyte2_wr ? h_wr_data_int[1:0]:
                         sctlr[17:16];
        sctlr[18]     <= exn_mode_reg_done ? 1'b0 :
                         sctlr_hbyte2_wr ? h_wr_data_int[2]: sctlr[18];
        if (sctlr_hbyte2_wr)
          sctlr[19]   <= h_wr_data_int[3];
      end
      else begin
        sctlr[0]     <= init_done ? 1'b0 : sctlr_byte0_wr ? h_wr_data_int[0] :
                        sctlr[0];
        sctlr[1]     <= clr_sctlr_bitone ? 1'b0 : sctlr_byte0_wr ? 
                        h_wr_data_int[1] : sctlr[1];
        sctlr[5:2]   <= (sctlr_byte0_wr) ? h_wr_data_int[5:2]:sctlr[5:2];
        sctlr[7:6]   <= (sctlr_byte0_wr && !disable_write) ? 
                         h_wr_data_int[7:6]:sctlr[7:6];

        sctlr[8]     <= (sctlr_byte1_wr && !disable_write) ? 
                         h_wr_data_int[8] : sctlr[8];

        sctlr[9]     <= mode_reg_done ? 1'b0 : sctlr_byte1_wr ? 
                        h_wr_data_int[9] : sctlr[9];

        sctlr[10]    <= (sctlr_byte1_wr) ? h_wr_data_int[10]:sctlr[10];

        sctlr[15:12] <= (sctlr_byte1_wr) ? h_wr_data_int[15:12]:sctlr[15:12];

        sctlr[17:16] <= (sctlr_byte2_wr) ? h_wr_data_int[17:16]:sctlr[17:16];

        sctlr[18]    <= exn_mode_reg_done ? 1'b0 : 
                        (sctlr_byte2_wr) ? h_wr_data_int[18] : sctlr[18];
        if (sctlr_byte2_wr)
          sctlr[19]  <= h_wr_data_int[19];
      end
    end
  end

  
  //---------------------------------------------------------------------
  // In order to make sure that a value of 0-15 for num_open_banks
  // corresponds to 1-16 open banks. This is done for compatability
  // with DW_memctl 1.2A. If the user had programmed 0 for unused
  // bits , the the number of open banks should be 1.
  // Same for cas latency.
  // 0-3  - Cas latency 1-4clock
  // 4    - 1.5 Clocks
  // 5    - 2.5 clocks
  // 6-7  - Unused
  //----------------------------------------------------------------------

  always@ (posedge hclk or negedge hresetn)
  begin
   if (!hresetn)  begin
      open_banks_o <= `OPEN_BANKS-1;
      cas_latency_o <= `CAS_LATENCY;
      end
   else begin
      open_banks_o <= sctlr[16:12] + 5'b00001;
      cas_latency_o <= {stmg0r[26],stmg0r[1:0]} + 3'b001;
      end
  end

  always@(posedge hclk or negedge hresetn)
  begin
   if (!hresetn)  begin
      sf_cas_latency_o <= `SF_CAS_LATENCY;
      end
   else begin
      sf_cas_latency_o <=sftmgr[2:0] + 3'b001;
      end
  end


  // ---------------------------------------------------------------------
  // SDRAM Refresh Register SREFR Address 10
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SREFR_PROC
   if (!hresetn) begin
      srefr[15:0]         <=`T_REF;
      srefr[31:16]        <= 16'h0000;
    end
   else begin
     srefr[31:24] <= gpi;
     if (sdram_data_width ==0)  begin
       srefr[7:0] <=(srefr_lbyte0_wr) ? h_wr_data_int[7:0]:srefr[7:0];
       srefr[15:8] <=(srefr_lbyte1_wr) ? h_wr_data_int[15:8]:srefr[15:8];
       srefr[23:16] <=(srefr_hbyte2_wr) ? h_wr_data_int[7:0]:srefr[23:16];
     end
     else begin
       srefr[7:0] <=(srefr_byte0_wr) ? h_wr_data_int[7:0]:srefr[7:0];
       srefr[15:8] <=(srefr_byte1_wr) ? h_wr_data_int[15:8]:srefr[15:8];
       srefr[23:16] <=(srefr_byte2_wr) ? h_wr_data_int[23:16]:srefr[23:16];
     end
   end
  end


  // ---------------------------------------------------------------------
  // Chip Select Registers SCSLR0_LOW - SCSLR7_LOW Address 14-30
  // Chip Select Registers SCSLR0_HIGH - SCSLR7_HIGH Address 34-50
  // ---------------------------------------------------------------------

// leda FM_1_7 off // Signal assigned more than once in a single flow of control (coding style for scslr* assignment)
  always@(posedge hclk or negedge hresetn)
  begin: SCSLR1_PROC 
    integer i;
    integer k;
    if(!hresetn) begin  
        scslr0 <= `CHIP_SELECT0_BASE_ADDRESS;
        scslr1 <= `CHIP_SELECT1_BASE_ADDRESS;
        scslr2 <= `CHIP_SELECT2_BASE_ADDRESS;
        scslr3 <= `CHIP_SELECT3_BASE_ADDRESS;
        scslr4 <= `CHIP_SELECT4_BASE_ADDRESS;
        scslr5 <= `CHIP_SELECT5_BASE_ADDRESS;
        scslr6 <= `CHIP_SELECT6_BASE_ADDRESS;
        scslr7 <= `CHIP_SELECT7_BASE_ADDRESS;
      end
    else begin  
        scslr0[15:0] <= 16'h0000;
        scslr1[15:0] <= 16'h0000;
        scslr2[15:0] <= 16'h0000;
        scslr3[15:0] <= 16'h0000;
        scslr4[15:0] <= 16'h0000;
        scslr5[15:0] <= 16'h0000;
        scslr6[15:0] <= 16'h0000;
        scslr7[15:0] <= 16'h0000;
     if (sdram_data_width ==0)  begin  

             // SCSLR0 Lower 32 bit writes

           if (scslr0_low_hbyte2_wr) 
                scslr0[23:16]<=h_wr_data_int[7:0]  ;
           if (scslr0_low_hbyte3_wr) 
                scslr0[31:24]<=h_wr_data_int[15:8] ;

             // SCSLR0 Upper 32 bits writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr0_high_lbyte0_wr  && `H_ADDR_WIDTH >32) 
              for(k=32;k<=39;k=k+1) begin scslr0[k]<=h_wr_data_int[k-32]; end
           if (scslr0_high_lbyte1_wr  && `H_ADDR_WIDTH >32) 
              for(k=40;k<=47;k=k+1) begin scslr0[k]<=h_wr_data_int[k-32]; end
           if (scslr0_high_hbyte2_wr  && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr0[k]<=h_wr_data_int[k-48]; end
           if (scslr0_high_hbyte3_wr  && `H_ADDR_WIDTH >32) 
              for(k=56;k<=63;k=k+1) begin scslr0[k]<=h_wr_data_int[k-48]; end
// VCS coverage on
             
              // SCSLR1 Lower 32 bit writes

           if (scslr1_low_hbyte2_wr) 
                scslr1[23:16]<=h_wr_data_int[7:0]  ;
           if (scslr1_low_hbyte3_wr) 
                scslr1[31:24]<=h_wr_data_int[15:8] ;

              // SCSLR1 Upper 32 bit writes
              
// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr1_high_lbyte0_wr && `H_ADDR_WIDTH >32) 
              for(k=32;k<=39;k=k+1) begin scslr1[k]<=h_wr_data_int[k-32];end
           if (scslr1_high_lbyte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr1[k]<=h_wr_data_int[k-32];end
           if (scslr1_high_hbyte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr1[k]<=h_wr_data_int[k-48];end
           if (scslr1_high_hbyte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr1[k]<=h_wr_data_int[k-48];end
// VCS coverage on

              // SCSLR2 Lower 32 bit writes

           if (scslr2_low_hbyte2_wr) 
                scslr2[23:16]<=h_wr_data_int[7:0]  ;
           if (scslr2_low_hbyte3_wr) 
                scslr2[31:24]<=h_wr_data_int[15:8] ;

              // SCSLR2 Upper 32 bits writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr2_high_lbyte0_wr && `H_ADDR_WIDTH >32) 
              for(k=32;k<=39;k=k+1) begin scslr2[k]<=h_wr_data_int[k-32];end
           if (scslr2_high_lbyte1_wr && `H_ADDR_WIDTH >32) 
              for(k=40;k<=47;k=k+1) begin scslr2[k]<=h_wr_data_int[k-32];end
           if (scslr2_high_hbyte2_wr && `H_ADDR_WIDTH >32) 
              for(k=48;k<=55;k=k+1) begin scslr2[k]<=h_wr_data_int[k-48];end
           if (scslr2_high_hbyte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr2[k]<=h_wr_data_int[k-48]; end
// VCS coverage on
              
              // SCSLR3 Lower 32 bits write

           if (scslr3_low_hbyte2_wr) 
                scslr3[23:16]<=h_wr_data_int[7:0]  ;
           if (scslr3_low_hbyte3_wr) 
                scslr3[31:24]<=h_wr_data_int[15:8] ;

              // SCSLR3 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr3_high_lbyte0_wr && `H_ADDR_WIDTH >32)
              for(k=32;k<=39;k=k+1) begin scslr3[k]<=h_wr_data_int[k-32];end
           if (scslr3_high_lbyte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr3[k]<=h_wr_data_int[k-32]; end
           if (scslr3_high_hbyte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr3[k]<=h_wr_data_int[k-48];end
           if (scslr3_high_hbyte3_wr && `H_ADDR_WIDTH >32) 
              for(k=56;k<=63;k=k+1) begin scslr3[k]<=h_wr_data_int[k-48];end
// VCS coverage on

              // SCSLR4 Lower 32 bit writes

           if (scslr4_low_hbyte2_wr) 
                scslr4[23:16]<=h_wr_data_int[7:0]  ;
           if (scslr4_low_hbyte3_wr)
                scslr4[31:24]<=h_wr_data_int[15:8] ;

              // SCSLR4 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr4_high_lbyte0_wr && `H_ADDR_WIDTH >32) 
              for(k=32;k<=39;k=k+1) begin scslr4[k]<=h_wr_data_int[k-32];end
           if (scslr4_high_lbyte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr4[k]<=h_wr_data_int[k-32];end
           if (scslr4_high_hbyte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr4[k]<=h_wr_data_int[k-48];end
           if (scslr4_high_hbyte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr4[k]<=h_wr_data_int[k-48];end
// VCS coverage on

              // SCSLR5 Lower 32 bit writes

           if (scslr5_low_hbyte2_wr)
                scslr5[23:16]<=h_wr_data_int[7:0]  ;
           if (scslr5_low_hbyte3_wr) 
                scslr5[31:24]<=h_wr_data_int[15:8] ;

              // SCSLR5 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr5_high_lbyte0_wr && `H_ADDR_WIDTH >32) 
              for(k=32;k<=39;k=k+1) begin scslr5[k]<=h_wr_data_int[k-32];end
           if (scslr5_high_lbyte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr5[k]<=h_wr_data_int[k-32];end
           if (scslr5_high_hbyte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr5[k]<=h_wr_data_int[k-48];end
           if (scslr5_high_hbyte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr5[k]<=h_wr_data_int[k-48];end
// VCS coverage on

              // SCSLR6 Lower 32 bit writes

           if (scslr6_low_hbyte2_wr)
                scslr6[23:16]<=h_wr_data_int[7:0]  ;
           if (scslr6_low_hbyte3_wr) 
                scslr6[31:24]<=h_wr_data_int[15:8] ;

              // SCSLR6 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr6_high_lbyte0_wr && `H_ADDR_WIDTH >32)
              for(k=32;k<=39;k=k+1) begin scslr6[k]<=h_wr_data_int[k-32];end
           if (scslr6_high_lbyte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr6[k]<=h_wr_data_int[k-32];end
           if (scslr6_high_hbyte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr6[k]<=h_wr_data_int[k-48];end
           if (scslr6_high_hbyte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr6[k]<=h_wr_data_int[k-48];end
// VCS coverage on

              // SCSLR7 Lower 32 bit writes

           if (scslr7_low_hbyte2_wr) 
                scslr7[23:16]<=h_wr_data_int[7:0]  ;
           if (scslr7_low_hbyte3_wr) 
                scslr7[31:24]<=h_wr_data_int[15:8] ;

              // SCSLR7 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr7_high_lbyte0_wr && `H_ADDR_WIDTH >32) 
              for(k=32;k<=39;k=k+1) begin scslr7[k]<=h_wr_data_int[k-32];end
           if (scslr7_high_lbyte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr7[k]<=h_wr_data_int[k-32];end
           if (scslr7_high_hbyte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr7[k]<=h_wr_data_int[k-48]; end
           if (scslr7_high_hbyte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr7[k]<=h_wr_data_int[k-48];end
// VCS coverage on

        end

        else  begin   // sdram_data_width !=16

            // `S_RD_DATA_WIDTH is checked here to remove compile time warnings

              // SCSLR0 Lower 32 bit writes

           if (scslr0_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                   for(i=15;i>=11;i=i-1) scslr0[i] <= h_wr_data_int[i] ;
           if (scslr0_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                   for(i=23;i>=16;i=i-1) scslr0[i] <= h_wr_data_int[i] ;
           if (scslr0_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                   for(i=31;i>=24;i=i-1) scslr0[i] <= h_wr_data_int[i] ;

              // SCSLR0 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr0_high_byte0_wr && `H_ADDR_WIDTH >32)
              for(k=32;k<=39;k=k+1) begin scslr0[k]<=h_wr_data_int[k-32];end
           if (scslr0_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr0[k]<=h_wr_data_int[k-32];end
           if (scslr0_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr0[k]<=h_wr_data_int[k-32];end
           if (scslr0_high_byte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr0[k]<=h_wr_data_int[k-32];end
// VCS coverage on

              // SCSLR1 Lower 32 bit writes

           if (scslr1_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=15;i>=11;i=i-1) scslr1[i]<=h_wr_data_int[i] ;
           if (scslr1_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=23;i>=16;i=i-1) scslr1[i]<=h_wr_data_int[i] ;
           if (scslr1_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=31;i>=24;i=i-1) scslr1[i]<=h_wr_data_int[i] ;

              // SCSLR1 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr1_high_byte0_wr && `H_ADDR_WIDTH >32)
              for(k=32;k<=39;k=k+1) begin scslr1[k]<=h_wr_data_int[k-32];end
           if (scslr1_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr1[k]<=h_wr_data_int[k-32];end
           if (scslr1_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr1[k]<=h_wr_data_int[k-32];end
           if (scslr1_high_byte3_wr && `H_ADDR_WIDTH >32) 
              for(k=56;k<=63;k=k+1) begin scslr1[k]<=h_wr_data_int[k-32];end
// VCS coverage on

              // SCSLR2 Lower 32 bit writes

           if (scslr2_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=15;i>=11;i=i-1) scslr2[i]<=h_wr_data_int[i] ;
           if (scslr2_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=23;i>=16;i=i-1) scslr2[i]<=h_wr_data_int[i] ;
           if (scslr2_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=31;i>=24;i=i-1) scslr2[i]<=h_wr_data_int[i] ;

              // SCSLR2 Upper 32 bit write

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr2_high_byte0_wr && `H_ADDR_WIDTH >32)
              for(k=32;k<=39;k=k+1) begin scslr2[k]<=h_wr_data_int[k-32]; end
           if (scslr2_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr2[k]<=h_wr_data_int[k-32]; end
           if (scslr2_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr2[k]<=h_wr_data_int[k-32]; end
           if (scslr2_high_byte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr2[k]<=h_wr_data_int[k-32]; end
// VCS coverage on

              //SCSLR3 Lower 32bit writes

           if (scslr3_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=15;i>=11;i=i-1) scslr3[i]<=h_wr_data_int[i] ;
           if (scslr3_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=23;i>=16;i=i-1) scslr3[i]<=h_wr_data_int[i] ;
           if (scslr3_low_byte3_wr  && `S_RD_DATA_WIDTH>16)
                  for(i=31;i>=24;i=i-1) scslr3[i]<=h_wr_data_int[i] ;

             // SCSLR3 Upper 32 bits writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr3_high_byte0_wr && `H_ADDR_WIDTH >32)
              for(k=32;k<=39;k=k+1) begin scslr3[k]<=h_wr_data_int[k-32];end
           if (scslr3_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr3[k]<=h_wr_data_int[k-32]; end
           if (scslr3_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr3[k]<=h_wr_data_int[k-32];end
           if (scslr3_high_byte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr3[k]<=h_wr_data_int[k-32];end
// VCS coverage on

             // SCSLR4 Lower 32 bit writes

           if (scslr4_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=15;i>=11;i=i-1) scslr4[i]<=h_wr_data_int[i] ;
           if (scslr4_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=23;i>=16;i=i-1) scslr4[i]<=h_wr_data_int[i] ;
           if (scslr4_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=31;i>=24;i=i-1) scslr4[i]<=h_wr_data_int[i] ;
  
             // SCSLR4 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr4_high_byte0_wr && `H_ADDR_WIDTH >32)
              for(k=32;k<=39;k=k+1) begin scslr4[k]<=h_wr_data_int[k-32];end
           if (scslr4_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr4[k]<=h_wr_data_int[k-32];end
           if (scslr4_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr4[k]<=h_wr_data_int[k-32];end
           if (scslr4_high_byte3_wr && `H_ADDR_WIDTH >32) 
              for(k=56;k<=63;k=k+1) begin scslr4[k]<=h_wr_data_int[k-32];end
// VCS coverage on

             // SCSLR5 Lower 32 bit writes

           if (scslr5_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=15;i>=11;i=i-1) scslr5[i] <= h_wr_data_int[i] ;
           if (scslr5_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=23;i>=16;i=i-1) scslr5[i] <= h_wr_data_int[i] ;
           if (scslr5_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=31;i>=24;i=i-1)scslr5[i] <= h_wr_data_int[i] ;

             // SCSLR5 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr5_high_byte0_wr && `H_ADDR_WIDTH >32)
              for(k=32;k<=39;k=k+1) begin scslr5[k]<=h_wr_data_int[k-32];end
           if (scslr5_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr5[k]<=h_wr_data_int[k-32];end
           if (scslr5_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr5[k]<=h_wr_data_int[k-32];end
           if (scslr5_high_byte3_wr && `H_ADDR_WIDTH >32) 
              for(k=56;k<=63;k=k+1) begin scslr5[k]<=h_wr_data_int[k-32];end
// VCS coverage on

             // SCSLR6 Lower 32 bit writes

           if (scslr6_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=15;i>=11;i=i-1)scslr6[i]<=h_wr_data_int[i] ;
           if (scslr6_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=23;i>=16;i=i-1)scslr6[i]<=h_wr_data_int[i] ;
           if (scslr6_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=31;i>=24;i=i-1)scslr6[i]<= h_wr_data_int[i] ;

             // SCSLR6 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr6_high_byte0_wr && `H_ADDR_WIDTH >32) 
              for(k=32;k<=39;k=k+1) begin scslr6[k]<=h_wr_data_int[k-32];end
           if (scslr6_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr6[k]<=h_wr_data_int[k-32];end
           if (scslr6_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr6[k]<=h_wr_data_int[k-32];end
           if (scslr6_high_byte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr6[k]<=h_wr_data_int[k-32];end
// VCS coverage on

              // SCSLr7 Lower 32 bit writes

           if (scslr7_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=15;i>=11;i=i-1)scslr7[i]<= h_wr_data_int[i] ;
           if (scslr7_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=23;i>=16;i=i-1)scslr7[i]<= h_wr_data_int[i] ;
           if (scslr7_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                  for(i=31;i>=24;i=i-1)scslr7[i]<= h_wr_data_int[i] ;

              // SCSLR7 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (scslr7_high_byte0_wr && `H_ADDR_WIDTH >32) 
              for(k=32;k<=39;k=k+1) begin scslr7[k]<=h_wr_data_int[k-32];end
           if (scslr7_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(k=40;k<=47;k=k+1) begin scslr7[k]<=h_wr_data_int[k-32];end
           if (scslr7_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(k=48;k<=55;k=k+1) begin scslr7[k]<=h_wr_data_int[k-32];end
           if (scslr7_high_byte3_wr && `H_ADDR_WIDTH >32)
              for(k=56;k<=63;k=k+1) begin scslr7[k]<=h_wr_data_int[k-32];end
// VCS coverage on

          end
    end   // else
  end  

  // ---------------------------------------------------------------------
  // Alias Registers CSALIAS0_LOW Address 74 , CSALIAS0_HIGH Address-7C
  // CSALIAS1_LOW Address 78 , CSALIAS1_HIGH Address-80
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: CSALIAS0_PROC 
  integer h;
  integer q;
    if(!hresetn)  begin
      csalias0 <= `CHIP_SELECT0_ALIAS_ADDRESS;
      csalias1 <= `CHIP_SELECT1_ALIAS_ADDRESS;
      end
  else  begin
      csalias0[15:0] <= 16'h0000;
      csalias1[15:0] <= 16'h0000;
      if (sdram_data_width ==0) begin

             // CSALIAS0 Lower 32 bit writes

           if (csalias0_low_hbyte2_wr)
                csalias0[23:16]<=h_wr_data_int[7:0]  ;
           if (csalias0_low_hbyte3_wr) 
                csalias0[31:24]<=h_wr_data_int[15:8] ;

             // CSALIAS0 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (csalias0_high_lbyte0_wr && `H_ADDR_WIDTH >32) 
                 for(h=32;h<=39;h=h+1) 
                    begin csalias0[h]<=h_wr_data_int[h-32];  end
           if (csalias0_high_lbyte1_wr && `H_ADDR_WIDTH >32) 
                 for(h=40;h<=47;h=h+1) 
                    begin csalias0[h]<=h_wr_data_int[h-32]; end
           if (csalias0_high_hbyte2_wr && `H_ADDR_WIDTH >32)
                 for(h=48;h<=55;h=h+1) 
                    begin csalias0[h]<=h_wr_data_int[h-48];end
           if (csalias0_high_hbyte3_wr && `H_ADDR_WIDTH >32) 
              for(h=56;h<=63;h=h+1) 
                  begin csalias0[h]<=h_wr_data_int[h-48];end
// VCS coverage on

              // CSALIAS1 Lower 32 bit writes

           if (csalias1_low_hbyte2_wr) 
                csalias1[23:16]<=h_wr_data_int[7:0]  ;
           if (csalias1_low_hbyte3_wr) 
                csalias1[31:24]<=h_wr_data_int[15:8] ;

              // CSLAIAS1 Upper 32 bit Writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (csalias1_high_lbyte0_wr && `H_ADDR_WIDTH >32) 
                 for(h=32;h<=39;h=h+1) 
                     begin csalias1[h]<=h_wr_data_int[h-32];  end
           if (csalias1_high_lbyte1_wr && `H_ADDR_WIDTH >32) 
                 for(h=40;h<=47;h=h+1) 
                     begin csalias1[h]<=h_wr_data_int[h-32]; end
           if (csalias1_high_hbyte2_wr && `H_ADDR_WIDTH >32)
              for(h=48;h<=55;h=h+1) 
                  begin csalias1[h]<=h_wr_data_int[h-48];end
           if (csalias1_high_hbyte3_wr && `H_ADDR_WIDTH >32) 
              for(h=56;h<=63;h=h+1) 
                  begin csalias1[h]<=h_wr_data_int[h-48];end
// VCS coverage on

      end
      else begin

            // `S_RD_DATA_WIDTH is checked here to remove compile time warnings

             // CSALIAS0 Lower 32 bit writes

           if (csalias0_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                   for(q=15;q>=11;q=q-1) csalias0[q] <= h_wr_data_int[q] ;
           if (csalias0_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                   for(q=23;q>=16;q=q-1) csalias0[q] <= h_wr_data_int[q] ;
           if (csalias0_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                   for(q=31;q>=24;q=q-1) csalias0[q] <= h_wr_data_int[q] ;

             // CSALIAS0 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (csalias0_high_byte0_wr && `H_ADDR_WIDTH >32)
               for(h=32;h<=39;h=h+1) begin csalias0[h]<=h_wr_data_int[h-32];end
           if (csalias0_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(h=40;h<=47;h=h+1) begin csalias0[h]<=h_wr_data_int[h-32];end
           if (csalias0_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(h=48;h<=55;h=h+1) begin csalias0[h]<=h_wr_data_int[h-32];end
           if (csalias0_high_byte3_wr && `H_ADDR_WIDTH >32)
              for(h=56;h<=63;h=h+1) begin csalias0[h]<=h_wr_data_int[h-32];end
// VCS coverage on

             // CSALIAS1 Lower 32 bit writes


           if (csalias1_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                   for(q=15;q>=11;q=q-1) csalias1[q] <= h_wr_data_int[q] ;
           if (csalias1_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                   for(q=23;q>=16;q=q-1) csalias1[q] <= h_wr_data_int[q] ;
           if (csalias1_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                   for(q=31;q>=24;q=q-1) csalias1[q] <= h_wr_data_int[q] ;

              // CSALIAS1 Upper 32 bit writes

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (csalias1_high_byte0_wr && `H_ADDR_WIDTH >32)
              for(h=32;h<=39;h=h+1) begin csalias1[h]<=h_wr_data_int[h-32];end
           if (csalias1_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(h=40;h<=47;h=h+1) begin csalias1[h]<=h_wr_data_int[h-32];end
           if (csalias1_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(h=48;h<=55;h=h+1) begin csalias1[h]<=h_wr_data_int[h-32];end
           if (csalias1_high_byte3_wr && `H_ADDR_WIDTH >32)
              for(h=56;h<=63;h=h+1) begin csalias1[h]<=h_wr_data_int[h-32];end
// VCS coverage on


           end
   end
  end


  // ---------------------------------------------------------------------
  // Remap Registers CSREMAP0_LOW Address 84 , CSREMAP0_HIGH Address-8C
  // CSREMAP1_LOW Address 88 , CSREMAP1_HIGH Address-90
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: CSREMAP_PROC 
    integer g;
    integer r;
    if(!hresetn)  begin
       csremap0 <= `CHIP_SELECT0_REMAP_ADDRESS;
       csremap1 <= `CHIP_SELECT1_REMAP_ADDRESS;
      end
    else begin  
      csremap0[15:0] <= 16'h0000;
      csremap1[15:0] <= 16'h0000;
      if (sdram_data_width ==0) begin
           if (csremap0_low_hbyte2_wr) 
                csremap0[23:16]<=h_wr_data_int[7:0]  ;
           if (csremap0_low_hbyte3_wr) 
                csremap0[31:24]<=h_wr_data_int[15:8] ;
// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (csremap0_high_lbyte0_wr && `H_ADDR_WIDTH >32) 
              for(g=32;g<=39;g=g+1) csremap0[g]<=h_wr_data_int[g-32];
           if (csremap0_high_lbyte1_wr && `H_ADDR_WIDTH >32) 
              for(g=40;g<=47;g=g+1) csremap0[g]<=h_wr_data_int[g-32];
           if (csremap0_high_hbyte2_wr && `H_ADDR_WIDTH >32)
              for(g=48;g<=55;g=g+1) csremap0[g]<=h_wr_data_int[g-48];
           if (csremap0_high_hbyte3_wr && `H_ADDR_WIDTH >32) 
              for(g=56;g<=63;g=g+1)  csremap0[g]<=h_wr_data_int[g-48];
// VCS coverage on


           if (csremap1_low_hbyte2_wr)
                csremap1[23:16]<=h_wr_data_int[7:0]  ;
           if (csremap1_low_hbyte3_wr) 
                csremap1[31:24]<=h_wr_data_int[15:8] ;
// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (csremap1_high_lbyte0_wr && `H_ADDR_WIDTH >32) 
              for(g=32;g<=39;g=g+1)csremap1[g]<=h_wr_data_int[g-32];
           if (csremap1_high_lbyte1_wr && `H_ADDR_WIDTH >32) 
              for(g=40;g<=47;g=g+1) csremap1[g]<=h_wr_data_int[g-32];
           if (csremap1_high_hbyte2_wr && `H_ADDR_WIDTH >32)
              for(g=48;g<=55;g=g+1) csremap1[g]<=h_wr_data_int[g-48];
           if (csremap1_high_hbyte3_wr && `H_ADDR_WIDTH >32) 
              for(g=56;g<=63;g=g+1) csremap1[g]<=h_wr_data_int[g-48];
// VCS coverage on

      end
      else begin

            // `S_RD_DATA_WIDTH is checked here to remove compile time warnings

           if (csremap0_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                   for(r=15;r>=11;r=r-1) csremap0[r] <= h_wr_data_int[r] ;
           if (csremap0_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                   for(r=23;r>=16;r=r-1) csremap0[r] <= h_wr_data_int[r] ;
           if (csremap0_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                   for(r=31;r>=24;r=r-1) csremap0[r] <= h_wr_data_int[r] ;
// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (csremap0_high_byte0_wr && `H_ADDR_WIDTH >32)
              for(g=32;g<=39;g=g+1) csremap0[g]<=h_wr_data_int[g-32];
           if (csremap0_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(g=40;g<=47;g=g+1)  csremap0[g]<=h_wr_data_int[g-32];
           if (csremap0_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(g=48;g<=55;g=g+1) csremap0[g]<=h_wr_data_int[g-32];
           if (csremap0_high_byte3_wr && `H_ADDR_WIDTH >32)
              for(g=56;g<=63;g=g+1)  csremap0[g]<=h_wr_data_int[g-32];
// VCS coverage on


           if (csremap1_low_byte1_wr  && `S_RD_DATA_WIDTH>16) 
                   for(r=15;r>=11;r=r-1) csremap1[r] <= h_wr_data_int[r] ;
           if (csremap1_low_byte2_wr  && `S_RD_DATA_WIDTH>16) 
                   for(r=23;r>=16;r=r-1) csremap1[r] <= h_wr_data_int[r] ;
           if (csremap1_low_byte3_wr  && `S_RD_DATA_WIDTH>16) 
                   for(r=31;r>=24;r=r-1) csremap1[r] <= h_wr_data_int[r] ;

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
           if (csremap1_high_byte0_wr && `H_ADDR_WIDTH >32)
              for(g=32;g<=39;g=g+1)  csremap1[g]<=h_wr_data_int[g-32];
           if (csremap1_high_byte1_wr && `H_ADDR_WIDTH >32)
              for(g=40;g<=47;g=g+1)  csremap1[g]<=h_wr_data_int[g-32];
           if (csremap1_high_byte2_wr && `H_ADDR_WIDTH >32)
              for(g=48;g<=55;g=g+1) csremap1[g]<=h_wr_data_int[g-32];
           if (csremap1_high_byte3_wr && `H_ADDR_WIDTH >32)
              for(g=56;g<=63;g=g+1)  csremap1[g]<=h_wr_data_int[g-32];
// VCS coverage on


           end
    end
  end
// leda FM_1_7 on  


  // ---------------------------------------------------------------------
  // Mask Register0 Address 0x54
  // Bits 4:0  - Memory size
  // Bits 7:5  - Memory type (0-SDRAM,1-SRAM,2-FLASH,3-ROM)
  // Bits 10:8 - Register Select. (0-Set0, 1-Set1, 2-Set2)
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SMSKR0_PROC
   if (!hresetn) begin
        smskr0[4:0]  <=`BLOCK_SIZE0;
        smskr0[7:5]  <=`CHIP_SELECT0_MEM;
        smskr0[10:8]  <=`REG_SELECT0;
    end
   else
     if (sdram_data_width ==0) begin
       if (smskr0_lbyte0_wr) smskr0[7:0]<=h_wr_data_int[7:0];
       if (smskr0_lbyte1_wr) smskr0[10:8]<=h_wr_data_int[10:8];
       end
     else begin
       if (smskr0_byte0_wr) smskr0[7:0]<=h_wr_data_int[7:0];
       if (smskr0_byte1_wr) smskr0[10:8]<=h_wr_data_int[10:8];
       end
    end

  // ---------------------------------------------------------------------
  // Mask Register1 Address 0x58
  // Bits 4:0  - Memory size
  // Bits 7:5  - Memory type (0-SDRAM,1-SRAM,2-FLASH,3-ROM)
  // Bits 10:8 - Register Select. (0-Set0, 1-Set1, 2-Set2)
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SMSKR1_PROC
   if (!hresetn) begin
       smskr1[4:0]  <=`BLOCK_SIZE1;
       smskr1[7:5]  <=`CHIP_SELECT1_MEM;
       smskr1[10:8]  <=`REG_SELECT1;
   end
 else
   if (sdram_data_width ==0) begin
      if (smskr1_lbyte0_wr) smskr1[7:0] <=h_wr_data_int[7:0];
      if (smskr1_lbyte1_wr) smskr1[10:8] <=h_wr_data_int[10:8];
      end
   else begin
      if (smskr1_byte0_wr) smskr1[7:0] <=h_wr_data_int[7:0];
      if (smskr1_byte1_wr) smskr1[10:8] <=h_wr_data_int[10:8];
      end
  end

  // ---------------------------------------------------------------------
  // Mask Register2 Address 0x5C
  // Bits 4:0  - Memory size
  // Bits 7:5  - Memory type (0-SDRAM,1-SRAM,2-FLASH,3-ROM)
  // Bits 10:8 - Register Select. (0-Set0, 1-Set1, 2-Set2)
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SMSKR2_PROC
   if (!hresetn) begin
        smskr2[4:0]  <=`BLOCK_SIZE2;
        smskr2[7:5]  <=`CHIP_SELECT2_MEM;
        smskr2[10:8]  <=`REG_SELECT2;
    end
   else
     if (sdram_data_width ==0) begin
        if (smskr2_lbyte0_wr) smskr2[7:0] <=h_wr_data_int[7:0];
        if (smskr2_lbyte1_wr) smskr2[10:8] <=h_wr_data_int[10:8];
        end
     else begin
        if (smskr2_byte0_wr) smskr2[7:0] <=h_wr_data_int[7:0];
        if (smskr2_byte1_wr) smskr2[10:8] <=h_wr_data_int[10:8];
        end
    end

  // ---------------------------------------------------------------------
  // Mask Register3 Address 0x60
  // Bits 4:0  - Memory size
  // Bits 7:5  - Memory type (0-SDRAM,1-SRAM,2-FLASH,3-ROM)
  // Bits 10:8 - Register Select. (0-Set0, 1-Set1, 2-Set2)
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SMSKR3_PROC
   if (!hresetn) begin
        smskr3[4:0]  <=`BLOCK_SIZE3;
        smskr3[7:5]  <=`CHIP_SELECT3_MEM;
        smskr3[10:8]  <=`REG_SELECT3;
    end
   else
     if (sdram_data_width ==0) begin
        if (smskr3_lbyte0_wr) smskr3[7:0] <=h_wr_data_int[7:0];
        if (smskr3_lbyte1_wr) smskr3[10:8] <=h_wr_data_int[10:8];
        end
     else begin
        if (smskr3_byte0_wr) smskr3[7:0] <=h_wr_data_int[7:0];
        if (smskr3_byte1_wr) smskr3[10:8] <=h_wr_data_int[10:8];
        end
  end

  // ---------------------------------------------------------------------
  // Mask Register4 Address 0x64
  // Bits 4:0  - Memory size
  // Bits 7:5  - Memory type (0-SDRAM,1-SRAM,2-FLASH,3-ROM)
  // Bits 10:8 - Register Select. (0-Set0, 1-Set1, 2-Set2)
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SMSKR4_PROC
   if (!hresetn) begin
        smskr4[4:0]  <=`BLOCK_SIZE4;
        smskr4[7:5]  <=`CHIP_SELECT4_MEM;
        smskr4[10:8]  <=`REG_SELECT4;
    end
   else
     if (sdram_data_width ==0) begin
        if (smskr4_lbyte0_wr) smskr4[7:0] <=h_wr_data_int[7:0];
        if (smskr4_lbyte1_wr) smskr4[10:8] <=h_wr_data_int[10:8];
        end
     else begin
        if (smskr4_byte0_wr) smskr4[7:0] <=h_wr_data_int[7:0];
        if (smskr4_byte1_wr) smskr4[10:8] <=h_wr_data_int[10:8];
        end
   end

  // ---------------------------------------------------------------------
  // Mask Register5 Address 0x68
  // Bits 4:0  - Memory size
  // Bits 7:5  - Memory type (0-SDRAM,1-SRAM,2-FLASH,3-ROM)
  // Bits 10:8 - Register Select. (0-Set0, 1-Set1, 2-Set2)
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SMSKR5_PROC
   if (!hresetn) begin
        smskr5[4:0]  <=`BLOCK_SIZE5;
        smskr5[7:5]  <=`CHIP_SELECT5_MEM;
        smskr5[10:8]  <=`REG_SELECT5;
    end
   else
     if (sdram_data_width ==0) begin
        if (smskr5_lbyte0_wr) smskr5[7:0] <=h_wr_data_int[7:0];
        if (smskr5_lbyte1_wr) smskr5[10:8] <=h_wr_data_int[10:8];
        end
     else begin
        if (smskr5_byte0_wr) smskr5[7:0] <=h_wr_data_int[7:0];
        if (smskr5_byte1_wr) smskr5[10:8] <=h_wr_data_int[10:8];
        end
  end

  // ---------------------------------------------------------------------
  // Mask Register6 Address 0x6C
  // Bits 4:0  - Memory size
  // Bits 7:5  - Memory type (0-SDRAM,1-SRAM,2-FLASH,3-ROM)
  // Bits 10:8 - Register Select. (0-Set0, 1-Set1, 2-Set2)
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SMSKR6_PROC
   if (!hresetn) begin
        smskr6[4:0]  <=`BLOCK_SIZE6;
        smskr6[7:5]  <=`CHIP_SELECT6_MEM;
        smskr6[10:8]  <=`REG_SELECT6;
    end
   else
     if (sdram_data_width ==0) begin
       if (smskr6_lbyte0_wr) smskr6[7:0] <=h_wr_data_int[7:0];
       if (smskr6_lbyte1_wr) smskr6[10:8] <=h_wr_data_int[10:8];
       end
     else begin
       if (smskr6_byte0_wr) smskr6[7:0] <=h_wr_data_int[7:0];
       if (smskr6_byte1_wr) smskr6[10:8] <=h_wr_data_int[10:8];
       end
  end

  // ---------------------------------------------------------------------
  // Mask Register7 Address 0x70
  // Bits 4:0  - Memory size
  // Bits 7:5  - Memory type (0-SDRAM,1-SRAM,2-FLASH,3-ROM)
  // Bits 10:8 - Register Select. (0-Set0, 1-Set1, 2-Set2)
  // ---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SMSKR7_PROC
   if (!hresetn) begin
        smskr7[4:0]  <=`BLOCK_SIZE7;
        smskr7[7:5]  <=`CHIP_SELECT7_MEM;
        smskr7[10:8]  <=`REG_SELECT7;
        end
   else
     if (sdram_data_width ==0) begin
        if (smskr7_lbyte0_wr) smskr7[7:0] <=h_wr_data_int[7:0];
        if (smskr7_lbyte1_wr) smskr7[10:8] <=h_wr_data_int[10:8];
        end
     else begin
        if (smskr7_byte0_wr) smskr7[7:0] <=h_wr_data_int[7:0];
        if (smskr7_byte1_wr) smskr7[10:8] <=h_wr_data_int[10:8];
        end
   end



  // ---------------------------------------------------------------------
  // EXTENSION MODE REGISTER 
  // ---------------------------------------------------------------------

 always@(posedge hclk or negedge hresetn)
  begin: EXN_MODE_REG_PROC
    if (!hresetn) begin
         // leda W163 off
         exn_mode_reg[12:0]   <= `EXTENDED_MODE_REG;
         // leda W163 on
       end
    else
        if (sdram_data_width ==0) begin
            exn_mode_reg[7:0]<=(exn_mode_reg_lbyte0_wr) ? h_wr_data_int[7:0] :
                               exn_mode_reg[7:0];
            exn_mode_reg[12:8]<=(exn_mode_reg_lbyte1_wr) ? h_wr_data_int[12:8]:
                                exn_mode_reg[12:8];
            end
        else  begin
            exn_mode_reg[7:0]<=(exn_mode_reg_byte0_wr) ? h_wr_data_int[7:0] :
                               exn_mode_reg[7:0];
            exn_mode_reg[12:8]<=(exn_mode_reg_byte1_wr) ? h_wr_data_int[12:8] :
                                exn_mode_reg[12:8];
        end
  end //EXN_MODE_REG_PROC

 
  // ---------------------------------------------------------------------
  // SYNCFLASH OPCODE Register
  // ---------------------------------------------------------------------
 always@(posedge hclk or negedge hresetn)
  begin: SYFLASH_OPCODE_PROC
    if (!hresetn) begin
      syflash_opcode[12:0]   <= 13'h 0000; 
    end
    else begin
     if (sdram_data_width ==0) begin
        syflash_opcode[7:0]<=(syflash_opcode_lbyte0_wr) ? 
                             h_wr_data_int[7:0] : syflash_opcode[7:0];

        syflash_opcode[12:8]<=clear_fl_op ? {1'b0,syflash_opcode[11:8]} :
                              (syflash_opcode_lbyte1_wr) ? 
                              h_wr_data_int[12:8]: syflash_opcode[12:8];
        end
     else begin
        syflash_opcode[7:0] <=(syflash_opcode_byte0_wr) ? 
                              h_wr_data_int[7:0] : syflash_opcode[7:0];

        syflash_opcode[12:8]<=clear_fl_op ? {1'b0,syflash_opcode[11:8]} : 
                              (syflash_opcode_byte1_wr) ? 
                              h_wr_data_int[12:8]: syflash_opcode[12:8];
        end
    end 
  end //SYFLASH_OPCODE_PROC

  // ---------------------------------------------------------------------
  // SYNCFLASH Configuration Register SFCONR (Address 32'hxxxx_xxB0)
  // This register is valid only when the controller controls both the 
  // SDRAM and the SYncFlash ( DYNAMIC_RAM_TYPE == 4 or 5 ). This register
  // is not used if DW_memctl is controlling only one type of dynamic memory.
  // 
  // Bits 1:0 - SyncFlash Bank address width.
  // Bits 5:2 - SyncFlash Row address width.
  // Bits 9:6 - SyncFlash Column address width.
  // Bits 31:10 - Unused
  // ---------------------------------------------------------------------
  always@(posedge hclk or negedge hresetn)
    begin:SFCONR_PROC
      if (!hresetn) begin
         sfconr[1:0] <= `SF_BANK_ADDR_WIDTH-1;
         sfconr[5:2] <= `SF_ROW_ADDR_WIDTH-1;
         sfconr[9:6] <= `SF_COL_ADDR_WIDTH-1;
      end
      else begin
         if (sdram_data_width == 0) begin
            sfconr[7:0]  <= sfconr_lbyte0_wr ? h_wr_data_int[7:0] : sfconr[7:0];
            sfconr[9:8] <= sfconr_lbyte1_wr ? h_wr_data_int[9:8] : sfconr[9:8];
         end // sdram_data_width == 0
         else begin
            sfconr[7:0]  <= sfconr_byte0_wr ? h_wr_data_int[7:0] : sfconr[7:0];
            sfconr[9:8] <= sfconr_byte1_wr ? h_wr_data_int[9:8] : sfconr[9:8];
         end // data_width !=0
      end
    end // always

  // ---------------------------------------------------------------------
  // SYNCFLASH Control register SFCTLR ( Address 32'hxxxx_xxB4)
  // This register is valid only when the controller is driving s SyncFlash.
  //
  // Bit 0 - SyncFlash deep power down mode set bit
  // Bit 1 - SyncFlash power down mode
  // Bit 2 - SyncFlash mode register set bit
  // Bit 3 - SyncFlash software sequence.
  // Bit 4 - SyncFlash deep power down mode status bit
  // Bits 31:5 - Unused
  // ---------------------------------------------------------------------
  always@(posedge hclk or negedge hresetn)
    begin:SFCTLR_PROC
      if (!hresetn) begin
         sfctlr[0] <= 1'b1;
         sfctlr[4:1]<=4'b0000;
      end
      else begin
        sfctlr[4] <= sf_in_dp_mode;
        if (sdram_data_width == 0)  begin
           sfctlr[0] <= (sync_fl_pdr_done | clear_sf_dp) ? 1'b0 :
                        sfctlr_lbyte0_wr ? h_wr_data_int[0] : sfctlr[0];
           sfctlr[1] <= sfctlr_lbyte0_wr ? h_wr_data_int[1] : sfctlr[1];
           sfctlr[2] <= sf_mode_reg_done ? 1'b0 : sfctlr_lbyte0_wr ?
                        h_wr_data_int[2] : sfctlr[2];
           sfctlr[3] <= sfctlr_lbyte0_wr ? h_wr_data_int[3] : sfctlr[3];
        end // sdram_data_width == 0
        else begin
           sfctlr[0] <= (sync_fl_pdr_done | clear_sf_dp) ? 1'b0 :
                        sfctlr_byte0_wr ? h_wr_data_int[0] : sfctlr[0];
           sfctlr[1] <= sfctlr_byte0_wr ? h_wr_data_int[1] : sfctlr[1];
           sfctlr[2] <= sf_mode_reg_done ? 1'b0 : sfctlr_byte0_wr ?
                        h_wr_data_int[2] : sfctlr[2];
           sfctlr[3] <= sfctlr_byte0_wr ? h_wr_data_int[3] : sfctlr[3];
        end // else
      end // else
  end // always

  // ---------------------------------------------------------------------
  // SYNCFLASH Timing Register SFTMGR (Address 32'hxxxx_xxB8)
  // This register is valid only when the controller controls both the
  // SDRAM and the SYncFlash ( DYNAMIC_RAM_TYPE == 4 or 5 ). This register
  // is not used if DW_memctl is controlling only one type of dynamic memory.
  //
  // Bits 2:0   - Cas Latency
  // Bits 5:3   - t_rcd ( Minimum delay between ACRIVE and READ/WRITE command)
  // Bits 9:6   - t_rc (ACTIVE to ACTIVE command period)
  // Bits 31:10 - Unused
  // 
  // ---------------------------------------------------------------------
  always@(posedge hclk or negedge hresetn)
  begin: SFTMGR_PROC
    if (!hresetn) begin
        sftmgr[2:0]   <= `SF_CAS_LATENCY-1;
        sftmgr[5:3]   <= `SF_T_RCD-1;
        sftmgr[9:6]   <= `SF_T_RC-1;
      end
  else
     if (sdram_data_width ==0)  begin
         sftmgr[7:0]  <=(sftmgr_lbyte0_wr) ? h_wr_data_int[7:0]:sftmgr[7:0];
         sftmgr[9:8] <=(sftmgr_lbyte1_wr) ? h_wr_data_int[9:8]:sftmgr[9:8];
        end // if
     else   begin
         sftmgr[7:0]  <=(sftmgr_byte0_wr) ? h_wr_data_int[7:0]:sftmgr[7:0];
         sftmgr[9:8] <=(sftmgr_byte1_wr) ? h_wr_data_int[9:8]:sftmgr[9:8];
     end // else
  end // always

  // Double registering of s_sda_in   input
  always@(posedge hclk or negedge hresetn)
  begin: SPD_PROC
   if (!hresetn) begin
      s_sda_d     <=1'b0;
      s_sda_d1    <=1'b0;
    end
    else begin
      s_sda_d    <=s_sda_in;
      s_sda_d1   <=s_sda_d;
     end
  end


  always@(posedge hclk or negedge hresetn)
  begin: DATA_WIDTH_PROC
   if (!hresetn) begin
      sdram_data_width  <= (`DYNAMIC_RAM_TYPE ==1) ?
                       (`S_DATA_WIDTH == 8 ? 0 : `S_DATA_WIDTH ==16 ? 1 :
                        `S_DATA_WIDTH == 32 ? 2 : 3) :
                       (`S_DATA_WIDTH == 16 ? 0 : `S_DATA_WIDTH ==32 ? 1 :
                        `S_DATA_WIDTH == 64 ? 2 : 3);

      end
   else begin
     if (cr_cs == `CR_WR_DONE && `HARD_WIRE_SDRAM_PARAMETERS==0)
            sdram_data_width <=sconr[14:13];
     else
          sdram_data_width <=sdram_data_width;
     end
  end

  // leda C_2C_R off
  // leda W456 off
  always@(sconr)
    begin
      if (`HARD_WIRE_SDRAM_PARAMETERS==0)
          s_data_width_early = sconr[14:13];
      else
        if (`DYNAMIC_RAM_TYPE ==1)
          s_data_width_early = (`S_DATA_WIDTH ==64) ? 2'b11 :
                             (`S_DATA_WIDTH ==32) ? 2'b10:
                             (`S_DATA_WIDTH ==16) ? 2'b01: 2'b00;
        else
          s_data_width_early = (`S_DATA_WIDTH ==128) ? 2'b11 :
                             (`S_DATA_WIDTH ==64) ? 2'b10:
                             (`S_DATA_WIDTH ==32) ? 2'b01: 2'b00;
    end
  // leda C_2C_R on
  // leda W456 on

  //---------------------------------------------------------------------
  // Sequential part of the state machine
  //---------------------------------------------------------------------

  always@(posedge hclk or negedge hresetn)
  begin: SEQ_CS_PROC
   if (!hresetn) begin
      cr_cs         <=`CR_IDLE;
      end
    else begin
      cr_cs      <=cr_ns;
      end
  end

  //------------------------------------------------------------------------
  // Register Read/Write State Machine
  //-------------------------------------------------------------------------

  // leda C_2C_R off
  // leda W456 off
  // leda W502 off
  always@(cr_cs or cr_reg_sel or sdram_data_width or cr_wr or hiu_rw or
           big_endian or hiu_addr or hiu_burst_size)
    begin : STATE_PROC
      pop_n          =  1'b1;
      push_n_int     =  1'b1;
      req_done       =  1'b0;
      l_half_word    =  1'b0;
      m_half_word    =  1'b0;
      cr_wr          =  1'b0;
      rd_l_half_word =  1'b0;
      rd_m_half_word =  1'b0;
      case(cr_cs)
        `CR_IDLE : begin
           if(cr_reg_sel ==1) 
             if((sdram_data_width ==0) && (`H_DATA_WIDTH==32) && hiu_rw) begin 
                // 16 bit reads
                rd_l_half_word = (hiu_burst_size ==2) ? ~big_endian : 
                                  hiu_addr[1] ^~ big_endian;
                rd_m_half_word = (hiu_burst_size ==2) ? big_endian : 
                                  hiu_addr[1] ^ big_endian;
                cr_ns          = `CR_16RD1;
                push_n_int     = 1'b0;
                end
             else if((sdram_data_width ==0) && (`H_DATA_WIDTH==32) && 
                      !hiu_rw) begin   // 16 bit writes
                cr_ns = `CR_16WR1;
                end
             else  begin
                cr_ns=`CR_DONE;
                push_n_int=!hiu_rw;
                end
           else
             cr_ns=`CR_IDLE;
        end // CR_IDLE
        `CR_16RD1 : begin
           cr_ns=hiu_burst_size ==2 ?  `CR_16RD2 : `CR_DONE;
         end
        `CR_16RD2 : begin
           rd_l_half_word = big_endian;
           rd_m_half_word = ~big_endian;
           push_n_int=1'b0;
           cr_ns=`CR_DONE;
        end
        `CR_16WR1 : begin
           l_half_word= hiu_burst_size ==2 ? 1'b1 :~hiu_addr[1];
           m_half_word= hiu_burst_size ==2 ? 1'b0 : hiu_addr[1];
           cr_wr=1'b1;
           pop_n=1'b0;
           cr_ns=hiu_burst_size ==2 ? `CR_16WR2 : `CR_WR_DONE;
           req_done = 1'b0;
        end
        `CR_16WR2 : begin
           cr_wr=1'b1;
           l_half_word= 1'b0;
           m_half_word= 1'b1;
           pop_n=1'b0;
           req_done=1'b0;
           cr_ns=`CR_WR_DONE;
        end      
        `CR_DONE : begin
           cr_wr=~hiu_rw;
           req_done=hiu_rw;
           cr_ns=hiu_rw ? `CR_IDLE : `CR_WR_DONE;
           pop_n=~cr_wr;
        end
        `CR_WR_DONE : begin
           cr_ns = `CR_IDLE;
           pop_n=1;
           req_done=1'b1;
        end
        default: begin
          cr_ns=cr_cs;
          pop_n=1'b1;
          push_n_int=1'b1;
          req_done=1'b0;
          rd_l_half_word=1'b0;
          rd_m_half_word=1'b0;
        end
      endcase
    end
  // leda W502 on
  // leda W456 on
  // leda C_2C_R on
 
 

  always@(rd_data_out_int or big_endian)
   begin
    if (big_endian) begin
      reg_rd_data_out[7:0]   = rd_data_out_int[31:24];
      reg_rd_data_out[15:8]  = rd_data_out_int[23:16];
      reg_rd_data_out[23:16] = rd_data_out_int[15:8];
      reg_rd_data_out[31:24] = rd_data_out_int[7:0];
      end
    else
      reg_rd_data_out = rd_data_out_int;
   end


  assign rd_data_out_int = sconr_sel ? (`HARD_WIRE_SDRAM_PARAMETERS ==0 ?
                       {11'h000,sconr[20],s_sda_d1,sconr[18:15],
                       sconr[14:3],3'b000}: sconr_default) :
            stmg0r_sel ? (`HARD_WIRE_SDRAM_PARAMETERS ==0 ?
                       stmg0r : stmg0r_default) :
            stmg1r_sel ? (`HARD_WIRE_SDRAM_PARAMETERS ==0 ? 
                       {10'h000,stmg1r } : stmg1r_default) :
            sctlr_sel  ? (`HARD_WIRE_SDRAM_PARAMETERS ==0 ?
                       {11'h0,sctlr[20:0]} : sctlr_default) :
            srefr_sel  ? srefr :
            syflash_opcode_sel ? {19'h00000,syflash_opcode} :
            exn_mode_reg_sel ? (`HARD_WIRE_SDRAM_PARAMETERS ==0 ?
                      {19'h00000,exn_mode_reg} : `EXTENDED_MODE_REG) :
            (sfctlr_sel && (`DYNAMIC_RAM_TYPE == 4 | `DYNAMIC_RAM_TYPE == 5)) ?
                      {27'h0000000,sfctlr}:
            (sfconr_sel && (`DYNAMIC_RAM_TYPE == 4 | `DYNAMIC_RAM_TYPE == 5)) ?
                      (`HARD_WIRE_SYNCFLASH_PARAMETERS ==0 ? {22'h000000,sfconr} : sfconr_default) :
            (sftmgr_sel && (`DYNAMIC_RAM_TYPE == 4 | `DYNAMIC_RAM_TYPE == 5)) ?
                      (`HARD_WIRE_SYNCFLASH_PARAMETERS ==0 ? {16'h0000,sftmgr} : sftmgr_default) :
            (smskr0_sel && `N_CS>0) ? 
                    (`HARD_WIRE_CIPSELECT_PARAMETRS ==0 ? {21'h000000,smskr0} :
                      {reg_select0,mem_type0,mem_size0}):
            (smskr1_sel && `N_CS>1) ? (`HARD_WIRE_CIPSELECT_PARAMETRS ==0 ?
                      {21'h000000,smskr1} : {reg_select1,mem_type1,mem_size1}):
            (smskr2_sel && `N_CS>2) ? (`HARD_WIRE_CIPSELECT_PARAMETRS ==0 ? 
                      {21'h000000,smskr2} :{reg_select2,mem_type2,mem_size2}):
            (smskr3_sel && `N_CS>3) ? (`HARD_WIRE_CIPSELECT_PARAMETRS ==0 ?
                      {21'h000000,smskr3} :{reg_select3,mem_type3,mem_size3}):
            (smskr4_sel && `N_CS>4) ? (`HARD_WIRE_CIPSELECT_PARAMETRS ==0 ?
                      {21'h000000,smskr4} : {reg_select4,mem_type4,mem_size4}):
            (smskr5_sel && `N_CS>5) ? (`HARD_WIRE_CIPSELECT_PARAMETRS ==0 ? 
                      {21'h000000,smskr5}  :{reg_select5,mem_type5,mem_size5}):
            (smskr6_sel && `N_CS>6) ? (`HARD_WIRE_CIPSELECT_PARAMETRS ==0 ? 
                      {21'h000000,smskr6} : {reg_select6,mem_type6,mem_size6}):
            (smskr7_sel && `N_CS>7) ? (`HARD_WIRE_CIPSELECT_PARAMETRS ==0 ? 
                      {21'h000000,smskr7} :{reg_select7,mem_type7,mem_size7}):
	    memctl_comp_type_sel ? `MEMCTL_COMP_TYPE:
	    memctl_comp_version_sel ? `MEMCTL_COMP_VERSION:
	    memctl_comp_params_1_sel ? memctl_comp_params_1_default:
            memctl_comp_params_2_sel ? memctl_comp_params_2_default:	     
            cs_reg_data_out;

  //--------------------------------------------------------------------
  //Read data assignment from chip select registers.In the case of 
  //H_ADDR_WIDTH=64, and depending on the chip selcts both the lowe and
  //upper 32 bit chip select registers are active.
  //When H_ADDR_WIDTH is 32 only the lower 32 bit chip select registers
  //are active.
  //The two cases (H_ADDR_WIDTH=64/32) are coded seperately.
  //--------------------------------------------------------------------


  always@(scslr0_low_sel or scslr1_low_sel or scslr2_low_sel or 
        scslr3_low_sel or scslr4_low_sel or scslr5_low_sel or 
        scslr6_low_sel or scslr0_high_sel or scslr1_high_sel or 
        scslr2_high_sel or scslr3_high_sel or scslr4_high_sel or
        scslr5_high_sel or scslr6_high_sel or scslr7_low_sel or 
        scslr7_high_sel or scslr0 or scslr1 or scslr2 or scslr3 or
        scslr4 or scslr5 or scslr6 or scslr7 or csalias0_low_sel or
        csalias0_high_sel or csalias1_low_sel or csalias1_high_sel or
        csremap0_low_sel or csremap0_high_sel or csremap1_low_sel or 
        csremap1_high_sel or csalias0 or csalias1 or csremap0 or csremap1 or
        scslr0_addr or scslr1_addr or scslr2_addr or scslr3_addr or 
        scslr4_addr or scslr5_addr or scslr6_addr or scslr7_addr or 
        csalias0_addr or csalias1_addr or csremap0_addr or csremap1_addr)
  begin: PROCESS_4
     integer j;
     integer n;
     cs_reg_data_out=32'h00000000;
     if (`HARD_WIRE_CIPSELECT_PARAMETRS ==0) begin

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
      if (`H_ADDR_WIDTH ==64) begin
        if(scslr0_low_sel && `N_CS>1)
           cs_reg_data_out[31:16]=scslr0[31:16];
        else if(scslr0_high_sel && `N_CS >1) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin 
             cs_reg_data_out[j]=scslr0[n];
             j=j-1;
           end
        end
        else if(scslr1_low_sel && `N_CS>1)
           cs_reg_data_out[31:16]=scslr1[31:16];
        else if(scslr1_high_sel && `N_CS>1) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr1[n];
             j=j-1;
           end
        end
        else if(scslr2_low_sel && `N_CS>2)
           cs_reg_data_out[31:16]=scslr2[31:16];
        else if(scslr2_high_sel && `N_CS>2) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr2[n];
             j=j-1;
           end
        end
        else if(scslr3_low_sel && `N_CS>3)
           cs_reg_data_out[31:16]=scslr3[31:16];
        else if(scslr3_high_sel && `N_CS>3) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr3[n];
             j=j-1;
           end
        end
        else if(scslr4_low_sel && `N_CS>4)
           cs_reg_data_out[31:16]=scslr4[31:16];
        else if(scslr4_high_sel && `N_CS>4) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr4[n];
             j=j-1;
             end
           end
        else if(scslr5_low_sel && `N_CS>5)
           cs_reg_data_out[31:16]=scslr5[31:16];
        else if(scslr5_high_sel && `N_CS>5) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr5[n];
             j=j-1;
           end
        end
        else if(scslr6_low_sel && `N_CS>6)
           cs_reg_data_out[31:16]=scslr6[31:16];
        else if(scslr6_high_sel && `N_CS>6) begin                
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr6[n];
             j=j-1;
           end
        end
        else if(scslr7_low_sel && `N_CS>7)
           cs_reg_data_out[31:16]=scslr7[31:16];
        else if(scslr7_high_sel && `N_CS>7)  begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr7[n];
             j=j-1;
           end
        end
        else if(csalias0_low_sel && `CHIP_SEL0_ALIAS_ENABLE)
           cs_reg_data_out[31:0]={csalias0[31:16], 5'b0};
        else if(csalias0_high_sel && `CHIP_SEL0_ALIAS_ENABLE)begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=csalias0[n];
             j=j-1;
           end
        end
        else if(csalias1_low_sel && `CHIP_SEL1_ALIAS_ENABLE)
           cs_reg_data_out[31:0]={csalias1[31:16], 5'b0};
        else if(csalias1_high_sel && `CHIP_SEL1_ALIAS_ENABLE) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=csalias1[n];
             j=j-1;
           end
        end
        else if(csremap0_low_sel && `CHIP_SEL0_REMAP_ENABLE)
           cs_reg_data_out[31:0]={csremap0[31:16], 5'b0};
        else if(csremap0_high_sel && `CHIP_SEL0_REMAP_ENABLE) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=csremap0[n];
             j=j-1;
           end
        end
        else if(csremap1_low_sel && `CHIP_SEL1_REMAP_ENABLE)
           cs_reg_data_out[31:0]={csremap1[31:16], 5'b0};
        else if(csremap1_high_sel && `CHIP_SEL1_REMAP_ENABLE) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=csremap1[n];
             j=j-1;
           end
        end
        else 
           cs_reg_data_out=32'h00000000;
     end // H_ADDR_WIDTH=64
// VCS coverage on

     else 
        cs_reg_data_out[31:16] = (scslr0_low_sel && `N_CS>1) ? scslr0[31:16]:
                             (scslr1_low_sel && `N_CS>1) ? scslr1[31:16] :
                             (scslr2_low_sel && `N_CS>2) ? scslr2[31:16] :
                             (scslr3_low_sel && `N_CS>3) ? scslr3[31:16] :
                             (scslr4_low_sel && `N_CS>4) ? scslr4[31:16] :
                             (scslr5_low_sel && `N_CS>5) ? scslr5[31:16] :
                             (scslr6_low_sel && `N_CS>6) ? scslr6[31:16] :
                             (scslr7_low_sel && `N_CS>7) ? scslr7[31:16] :
                             (csalias0_low_sel && `CHIP_SEL0_ALIAS_ENABLE==1) ?
                              csalias0[31:16]:
                             (csalias1_low_sel && `CHIP_SEL1_ALIAS_ENABLE==1) ?
                              csalias1[31:16]:
                             (csremap0_low_sel && `CHIP_SEL0_REMAP_ENABLE==1) ?
                              csremap0[31:16]:
                             (csremap1_low_sel && `CHIP_SEL1_REMAP_ENABLE==1) ?
                                 csremap1[31:16]: 0;

     end // HARD_WIRE_CIPSELECT_PARAMETRS ==0
     else begin

// NOTE: H_ADDR_WIDTH > 32 is not currently supported
// VCS coverage off
     if (`H_ADDR_WIDTH ==64) begin
        if(scslr0_low_sel && `N_CS>1)
           cs_reg_data_out[31:16]=scslr0_addr[31:16];
        else if(scslr0_high_sel && `N_CS >1) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin 
             cs_reg_data_out[j]=scslr0_addr[n];
             j=j-1;
           end
        end
        else if(scslr1_low_sel && `N_CS>1)
           cs_reg_data_out[31:16]=scslr1_addr[31:16];
        else if(scslr1_high_sel && `N_CS>1) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr1_addr[n];
             j=j-1;
           end
        end
        else if(scslr2_low_sel && `N_CS>2)
           cs_reg_data_out[31:16]=scslr2_addr[31:16];
        else if(scslr2_high_sel && `N_CS>2) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr2_addr[n];
             j=j-1;
           end
        end
        else if(scslr3_low_sel && `N_CS>3)
           cs_reg_data_out[31:16]=scslr3_addr[31:16];
        else if(scslr3_high_sel && `N_CS>3) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr3_addr[n];
             j=j-1;
           end
        end
        else if(scslr4_low_sel && `N_CS>4)
           cs_reg_data_out[31:16]=scslr4_addr[31:16];
        else if(scslr4_high_sel && `N_CS>4) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr4_addr[n];
             j=j-1;
             end
           end
        else if(scslr5_low_sel && `N_CS>5)
           cs_reg_data_out[31:16]=scslr5_addr[31:16];
        else if(scslr5_high_sel && `N_CS>5) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr5_addr[n];
             j=j-1;
           end
        end
        else if(scslr6_low_sel && `N_CS>6)
           cs_reg_data_out[31:16]=scslr6_addr[31:16];
        else if(scslr6_high_sel && `N_CS>6) begin                
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr6_addr[n];
             j=j-1;
           end
        end
        else if(scslr7_low_sel && `N_CS>7)
           cs_reg_data_out[31:16]=scslr7_addr[31:16];
        else if(scslr7_high_sel && `N_CS>7)  begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=scslr7_addr[n];
             j=j-1;
           end
        end
        else if(csalias0_low_sel && `CHIP_SEL0_ALIAS_ENABLE)
           cs_reg_data_out[31:0]={csalias0_addr[31:16], 5'b0};
        else if(csalias0_high_sel && `CHIP_SEL0_ALIAS_ENABLE)begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=csalias0_addr[n];
             j=j-1;
           end
        end
        else if(csalias1_low_sel && `CHIP_SEL1_ALIAS_ENABLE)
           cs_reg_data_out[31:0]={csalias1_addr[31:16], 5'b0};
        else if(csalias1_high_sel && `CHIP_SEL1_ALIAS_ENABLE) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=csalias1_addr[n];
             j=j-1;
           end
        end
        else if(csremap0_low_sel && `CHIP_SEL0_REMAP_ENABLE)
           cs_reg_data_out[31:0]={csremap0_addr[31:16], 5'b0};
        else if(csremap0_high_sel && `CHIP_SEL0_REMAP_ENABLE) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=csremap0_addr[n];
             j=j-1;
           end
        end
        else if(csremap1_low_sel && `CHIP_SEL1_REMAP_ENABLE)
           cs_reg_data_out[31:0]={csremap1_addr[31:16], 5'b0};
        else if(csremap1_high_sel && `CHIP_SEL1_REMAP_ENABLE) begin
           j=`H_ADDR_WIDTH-33;
           for(n=`H_ADDR_WIDTH-1;n>=32;n=n-1) begin
             cs_reg_data_out[j]=csremap1_addr[n];
             j=j-1;
           end
        end
        else 
           cs_reg_data_out=32'h00000000;
     end // H_ADDR_WIDTH=64
// VCS coverage on

     else 
        cs_reg_data_out[31:16] = scslr0_low_sel ? scslr0_addr[31:16]:
                                 scslr1_low_sel ? scslr1_addr[31:16] :
                                 scslr2_low_sel ? scslr2_addr[31:16] :
                                 scslr3_low_sel ? scslr3_addr[31:16] :
                                 scslr4_low_sel ? scslr4_addr[31:16] :
                                 scslr5_low_sel ? scslr5_addr[31:16] :
                                 scslr6_low_sel ? scslr6_addr[31:16] :
                                 scslr7_low_sel ? scslr7_addr[31:16] :
                                 csalias0_low_sel ? csalias0_addr[31:16]:
                                 csalias1_low_sel ? csalias1_addr[31:16]:
                                 csremap0_low_sel ? csremap0_addr[31:16]:
                                 csremap1_addr[31:16];

    end
   end
  endmodule

