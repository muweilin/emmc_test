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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_regb.v#53 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_regb.v
// Description : DWC_mobile_storage Register Bank Unit. This implements all the registers
//               in the design. In addition has the interrupt generaion logic 
//               and read-data coherency registers for the byte-counters. 
//               This unit generates the command and control inputs signals
//               to the CIU block. 
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_regb(
  /*AUTOARG*/
  // Outputs
  regb_rdata, interrupt, raw_ints, int_mask_n, int_enable, debug_registers,
  debounce_count, gp_out, card_power_en, card_volt_a, card_volt_b, 
  b2c_od_pullup_en_n, less_equal_thresh, greater_than_thresh, 
  dw_dma_trans_size, clear_pointers, dma_reset, ciu_reset, dma_enabled, 
  trans_fifo_cnt, b2c_clk_divider, b2c_clk_source, b2c_block_size, 
  b2c_byte_count, b2c_data_tmout_cnt, b2c_resp_tmout_cnt,
  b2c_cmd_control,enable_boot,alternative_boot_mode, 
  b2c_cmd_argument, b2c_creset_n, b2c_cmd_start, 
  b2c_read_wait, b2c_cclk_enable, b2c_cclk_low_power, b2c_card_width, 
  b2c_card_type,  b2c_send_irq_resp, b2c_abort_read_data, 
  b2c_ceata_intr_status, b2c_send_ccsd, b2c_send_auto_stop_ccsd,
 //SD_3.0 start
 biu_volt_reg,b2c_ddr_reg,
 //SD_3.0 ends
        //eMMC 4.5 start
        ext_clk_mux_ctrl,
        clk_drv_phase_ctrl,
        clk_smpl_phase_ctrl,
        biu_volt_reg_1_2,
        b2c_half_start_bit,
        b2c_enable_shift,
      
        //eMMC 4.5 ends
 //MMC4_4 start
  rst_n,card_rd_threshold_en,busy_clr_int_mask, card_rd_threshold_size,
 //MMC4_4 ends
 //SDIO 3.0 start
  back_end_power, 
 //SDIO 3.0 ends
  clr_clk1_pointers,


  `ifdef INTERNAL_DMAC_YES

  use_internal_dmac,
  fifo_ptr_rst,

  `endif

  // Inputs
  clk, reset_n, byte_en, regb_wdata, paddr, regb_write_en, regb_read_en,
  regb_read_en_dly, card_detect_int, card_detect_biu, card_write_prt_biu, 
  gp_in_biu, full, empty, almost_full, almost_empty, less_or_equal, 
  greater_than, count, fifo_over, fifo_under, dma_req, dma_ack, sdio_interrupt,
//SD_3.0 start
  volt_switch_int,
//SD_3.0 ends
  c2b_response_data, c2b_response_addr, cmd_taken, response_valid, 
  response_err, response_done, data_trans_done, data_timeout, 
  c2b_trans_bytes_bin, resp_timeout, data_crc_err, resp_crc_err, 
  host_2_fifo_inc, ciu_status, auto_cmd_done, rx_stbit_err, data_strv_err, 
  rxend_nocrc_err, ciu_trans_bytes, clr_abrt_read_data, clear_irq_response, 
  clear_ciu_reset, clr_clear_pointers, clr_send_ccsd, scan_mode
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  // Host Clock and Reset
  input                        clk;                // System Clock 
  input                        reset_n;            // System Reset - Active Low

  // Write/Read Control and Data 
  input                  [7:0] byte_en;            // Byte Enable
  input                 [63:0] regb_wdata;         // Register Write Data
  input    [`H_ADDR_WIDTH-1:0] paddr;              // Register Address
  input                        regb_write_en;      // Register Write Enable
  input                        regb_read_en;       // Register Read Enable
  input                        regb_read_en_dly;   // Reg. Read Enable-penable
  output   [`H_DATA_WIDTH-1:0] regb_rdata;         // Register Read Data

  // Interrupt Control
  output                       interrupt;          // Combined System Interrupt
  output                [31:0] raw_ints;           // Raw Interrupts - for debug
  output                [31:0] int_mask_n;         // Int mask Reg - for debug
  output                       int_enable;         // Global Int Ena - for debug
 //SD_3.0 start
  output               [959:0] debug_registers;    // All Registers - For debug
  //SD_3.0 ends

  // Card Detect & Write Protect
  output                [23:0] debounce_count;     // Debounce Counter Value
  input                        card_detect_int;    // Card Detect Interrupt
  input       [`NUM_CARDS-1:0] card_detect_biu;    // Card Detect - Sync
  input       [`NUM_CARDS-1:0] card_write_prt_biu; // Write Protect - Sync

  // General Purpose Input/Output
  input                  [7:0] gp_in_biu;          // General Purpose Input-Sync
  output                [15:0] gp_out;             // General Purpose Output

  // Card Interface
  output      [`NUM_CARDS-1:0] card_power_en;       // Individual Card Power Ena
  output                 [3:0] card_volt_a;         // Card Regulator Volt-A 
  output                 [3:0] card_volt_b;         // Card Regulator Volt-B 
  output                       b2c_od_pullup_en_n;  // Command Pullup Control 
  output  [`F_COUNT_WIDTH-1:0] less_equal_thresh;   // FIFO LessEq Threshhold
  output  [`F_COUNT_WIDTH-1:0] greater_than_thresh; // FIFO Great Threshhold 
  output                 [2:0] dw_dma_trans_size;   // DMA Multiple Trans. Size

  // FIFO Flags
  input                        full;                 // FIFO full Flag
  input                        empty;                // FIFO empty Flag
  input                        almost_full;          // FIFO almost_full Flag
  input                        almost_empty;         // FIFO almost_empty Flag
  input                        less_or_equal;        // FIFO less_or_equal Flag
  input                        greater_than;         // FIFO greater_than
  input   [`F_COUNT_WIDTH-1:0] count;                // FIFO Count
  input                        fifo_over;            // FIFO OverFlow
  input                        fifo_under;           // FIFO UnderFlow

  // To FIFO-Ctl and DMA-Ctl
  input                        dma_req;              // DMA request status
  input                        dma_ack;              // DMA Acknowledgement
  output                       clear_pointers;       // Clear FIFO Pointers
  output                       clr_clk1_pointers;    // Clear only clk1 domain ptrs
  output                       dma_reset;            // DMA Reset
  output                       ciu_reset;            // CIU Reset
  output                       dma_enabled;          // DMA Enabled
  output                [31:0] trans_fifo_cnt;       // Transferred FIFO Bytes


  // To CIU
  output                [31:0] b2c_clk_divider;      // Clock divider value
  output                [31:0] b2c_clk_source;       // Clock source
  output                [15:0] b2c_block_size;       // Data block size
  output                [31:0] b2c_byte_count;       // Data byte count
  output                [23:0] b2c_data_tmout_cnt;   // Data Timeout Count
  output                 [7:0] b2c_resp_tmout_cnt;   // Response Timeout Count
 //SD_3.0 start
  output                [29:0] b2c_cmd_control;      // Command Control
 //SD_3.0 ends
  output                       enable_boot;          // Enable the boot
  output                       alternative_boot_mode;// Alternative boot mode
  output                [31:0] b2c_cmd_argument;     // Command Arguments
  output                       b2c_creset_n;         // CIU Reset 
  output                       b2c_cmd_start;        // Command Start 
  output                       b2c_read_wait;        // Read Wait
  output   [`NUM_CARD_BUS-1:0] b2c_cclk_enable;      // Card Clock Enable
  output   [`NUM_CARD_BUS-1:0] b2c_cclk_low_power;   // Clock Low Power Control
  output [`NUM_CARD_BUS*2-1:0] b2c_card_width;       // Card Bus Width
  output   [`NUM_CARD_BUS-1:0] b2c_card_type;        // Card Type
  output                       b2c_send_irq_resp;    // Send IRQ Response
  output                       b2c_abort_read_data;  // Abort Read Data
  output                       b2c_ceata_intr_status;// CE-ATA device interrupt status
  output                       b2c_send_ccsd;        // Send CCSD to CE-ATA device
  output                       b2c_send_auto_stop_ccsd;  // Send internal AUTO STOP after the CCSD
 //SD_3.0 start
  output   [`NUM_CARD_BUS-1:0] biu_volt_reg;// Volt reg
 output   [`NUM_CARD_BUS-1:0] b2c_ddr_reg; // ddr register 
 //SD_3.0 ends
        //eMMC 4.5 start

  output      [1:0]       ext_clk_mux_ctrl;
  output      [6:0]       clk_drv_phase_ctrl;
  output      [6:0]       clk_smpl_phase_ctrl;
  output   [`NUM_CARD_BUS-1:0] biu_volt_reg_1_2;// Volt reg
  output                  b2c_half_start_bit; 
  output   [((`NUM_CARD_BUS*2)-1):0]  b2c_enable_shift; 
        //eMMC 4.5 ends
  //MMC4_4 start
  output   [`NUM_CARD_BUS-1:0] rst_n; // H/W reset
 output                       card_rd_threshold_en; // read Threshhold enable
 output                       busy_clr_int_mask ; 
 output   [`F_BYTE_WIDTH-1:0]   card_rd_threshold_size;    // read threshold size
 //MC4_4 ends
  //SDIO 3.0 start
  output   [`NUM_CARD_BUS-1:0] back_end_power; // Back end power for applications on the card.1 per card. 
 //SDIO 3.0 ends

 
  // From CIU
  input    [`NUM_CARD_BUS-1:0] sdio_interrupt;       // SDIO Interrupts
 //SD_3.0 start
  input                        volt_switch_int;      //Interrupts generated during voltage switching mechanism.
 //SD_3.0 ends
  input                 [37:0] c2b_response_data;    // Response Data
  input                  [1:0] c2b_response_addr;    // Response Address
  input                 [31:0] c2b_trans_bytes_bin;  // Trans. Byte Count-binary
  input                        cmd_taken;            // Command Taken
  input                        response_valid;       // Response Valid
  input                        response_err;         // Response Error
  input                        response_done;        // Response Done
  input                        data_trans_done;      // Data Transfer Done
  input                        data_timeout;         // Data Timeout
  input                        resp_timeout;         // Response Timeout
  input                        data_crc_err;         // Data CRC Error
  input                        resp_crc_err;         // Response CRC Error
  input                        host_2_fifo_inc;      // Host to FIFO Transfer 
  input   [7:0]                ciu_status;           // CIU Status
  input                        auto_cmd_done;        // Auto Command Done
  input                        rx_stbit_err;         // Incorrect Data Start 
  input                        data_strv_err;        // Data starvation error 
  input                        rxend_nocrc_err;      // Rx end bit/no crc error 
  input                 [31:0] ciu_trans_bytes;      // CIU Transfered Bytes

  // Loop Back Clear Flags From b2c - c2b  
  input                        clr_abrt_read_data;   // Abort Read Data Taken
  input                        clear_irq_response;   // Send IRQ Response Taken
  input                        clear_ciu_reset;      // CIU Reset done
  input                        clr_clear_pointers;   // FIFO Controller reset
  input                        clr_send_ccsd;        // Clear the send_ccsd bit

  // Misc
  input                        scan_mode;            // Scan Mode pin for bypass


  `ifdef INTERNAL_DMAC_YES

  output use_internal_dmac;
  input  fifo_ptr_rst;

  `endif


  `define SD_VERSION_ID        32'h5342270a          
                               //   2.50a version

  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  integer       j; 

  // Registers
  reg               [31:0] pwren;           // Power-Enable Reg
  reg               [31:0] cntrl;           // Control Reg
  reg               [31:0] clksrc;          // Clock Source Reg
  reg               [31:0] clkdiv;          // CLock Divider Reg
  reg               [31:0] tmout;           // Timeout Reg 
  reg               [31:0] clkena;          // CLock Enable Reg
  reg               [15:0] blksiz;          // Block Size Reg 
  reg               [31:0] bytcnt;          // Byte Count Reg
  reg               [31:0] fifoth;          // FIFO Threshhold Reg
  reg               [31:0] intmsk;          // Interrupt Mask
  reg               [31:0] cmd;             // Command Reg
  reg               [31:0] cmdarg;          // Command Argument Reg
  reg               [31:0] resp0;           // Response-0 Reg 
  reg               [31:0] resp1;           // Response-1 Reg
  reg               [31:0] resp2;           // Response-2 Reg
  reg               [31:0] resp3;           // Response-3 Reg
  reg               [31:0] rawints;         // Raw Interrupt Reg 
  reg               [31:0] ctype;           // Card Type Reg
  reg               [15:0] gp_out;          // General Purpose Output
  reg               [31:0] trans_fifo_cnt;  // Transferrd FIFO Bytes Reg 
  reg               [31:0] trans_crd_cnt1;  // Transferrd CIU Byte Reg
  reg               [23:0] debnce;          // Debounce Reg
  reg               [31:0] uid;             // User ID Reg 
  reg               [31:0] cardthrctl;      // Card Threshold Control Reg 
 //SD_3.0 start
  reg               [31:0] uhs_reg;         // Volt_reg + DDR reg
 //SD_3.0 ends

 //eMMC 4.5 start
  reg               [31:0] uhs_reg_ext;         // MMC_Volt_reg to support 3.3,1.8 and 1.2V  
  reg               [31:0] enable_shift;     
  reg               [`NUM_CARD_BUS-1:0] half_start_bit ;         // Register to support 0.5,1 START/END bit. 
 //eMMC 4.5 ends

 //MMC4_4 start
  reg               [`NUM_CARD_BUS-1:0] card_reset;      //Hardware reset
 wire                     card_rd_threshold_en ;
 wire                     busy_clr_int_mask ;
 wire              [`F_BYTE_WIDTH-1:0] card_rd_threshold_size ;
 //MMC4_4 ends
 //SDIO 3.0 starts 
  reg               [15:0] back_end_power_r;      // backend power registers
 //SDIo 3.0 ends
  reg               [63:0] new_reg; //Dummy register

  reg                [5:0] response_index;  // Response Index
  reg                      b2c_cmd_start;   // Command Start
  reg                      interrupt;       // Interrupt
  reg  [`H_DATA_WIDTH-1:0] regb_rdata;      // Register Read Data
  reg               [63:0] mux_rdata;       // Register Read Before Mux 
  reg                      trans_in_prog;   // Data Tranafer In progress
  reg                      trans_write_in_prog;   // Write Tranafer In progress
  reg               [15:0] trans_bytcnt_tmp_data; // Coherency Register 
  reg                      dma_ack_sync;          // DMA Acknowledgement - reg
  reg [`NUM_CARD_BUS*2-1:0] b2c_card_width;       // Card Bus Width

  wire              [31:0] trans_crd_cnt;  // Transferrd CIU Byte Reg
  wire              [31:0] status;         // Status Register
  wire              [31:0] hcon;           // Hardware Configuration Register
  wire               [5:0] addr_width;     // Address Bus Width
  wire               [4:0] number_cards;   // Number of Cards
  wire              [23:0] debounce_count; // Debounce Count
  wire   [31-`NUM_CARDS:0] card_num_zero;  // Unused Bits to "0"
  wire              [12:0] extended_count; // 13-bit extended count
  wire              [11:0] fifo_depth_min1;// FFIO Depth-1
  wire              [31:0] trans_crd_cnt_mx;  // Transferred Card Bytes  
  wire              [31:0] trans_fifo_cnt_mx; // Transferred FIFO Bytes
  wire              [31:0] g2b;               // Gray to Bin output
  wire              [31:0] g2b4, g2b3, g2b2, g2b1; // Temp. Gray to Bin 

  wire                     rawints_write;         // Raw Int Reg Write
  wire                     cmd_write;             // Command Reg Write
  wire                     rawints_read;          // Raw Int Reg Read
  wire                     cntrl_write;           // Control Reg Write 

  wire                     half_full;             // FIFO half_full
  wire                     half_empty;            // FIFO half_empty
  wire              [31:0] masked_ints;           // Masked Interrupts
  wire                     auto_clear_int;        // Auto Clear Interrupt
  wire              [15:0] std_interrupt;         // Standard Interrupt Sources
  wire                     int_enable;            // Interrupt Enabled
  wire                     clear_pointers;        // Clear FIFO Pointers
  wire                     clr_clk1_pointers;     // Clear only clk1 domain ptrs
 //SD_3.0 start
  wire             [959:0] debug_registers;       // All Registers 
 //SD_3.0 ends
  wire                     hrdware_lock_error;    // Hardware Lock Error

  wire              [15:0] sdio_interrupt_tmp;     // Zero Prefixed SDIO Ints 
  wire              [15:0] b2c_card_type_tmp;      // Zero Prefixed Card Type
  wire              [15:0] b2c_card_width_tmp;     // Zero Prefixed Card Width 
  wire              [15:0] b2c_cclk_low_power_tmp; // Zero Prefixed Low Power
  wire              [15:0] b2c_cclk_enable_tmp;    // Zero Prefixed Clk Enable
  wire [`NUM_CARD_BUS-1:0] card_width_lo;          // Card Bus Width
  wire                     enable_boot;            // Boot enable
  wire                     alternative_boot_mode;  // Alternative boot mode
 wire                     boot_mode;              // Signal to represent that boot mode is on.
  wire              [3:0] cp_card_num;
  integer                  i;

  
  // Address Decodes
  assign rawints_write   = regb_write_en & (paddr[8:3] == 6'b001000);
  assign cntrl_write     = regb_write_en & (paddr[8:3] == 6'b000000);
  assign cmd_write       = regb_write_en & (paddr[8:3] == 6'b000101);
  assign rawints_read    = regb_read_en  & (paddr[8:3] == 6'b001000) & 
                           auto_clear_int;

  // Register Assignment to Control Signals
  assign less_equal_thresh     = (fifoth[`F_COUNT_WIDTH-1:0] & 13'h0fff);
  assign greater_than_thresh   = (fifoth[`F_COUNT_WIDTH+15:16] & 13'h0fff);
  assign dw_dma_trans_size     = fifoth[30:28];

  assign debounce_count        = debnce[23:0];
  assign b2c_clk_source        = (`NUM_CLK_DIVIDERS == 1 || `CARD_TYPE == 0 )? 
                                 32'h0 : clksrc;

 `ifdef CLK_DIV_4
  assign b2c_clk_divider       = (`CARD_TYPE == 0)? {24'h0, clkdiv[7:0]} : 
                                                            clkdiv ; 
 `else
  assign b2c_clk_divider       = (`CARD_TYPE == 0)? {24'h0, clkdiv[7:0]} : 
                                            {{(4-`NUM_CLK_DIVIDERS){8'h0}},
                                            clkdiv[`NUM_CLK_DIVIDERS*8-1:0]};
 `endif

  assign b2c_cclk_enable       = (`CARD_TYPE == 0)? clkena[0]  :
                                                    clkena[`NUM_CARD_BUS-1:0];
  assign b2c_cclk_low_power    = (`CARD_TYPE == 0)? clkena[16] :
                                                    clkena[`NUM_CARD_BUS+15:16];


 `ifdef INTERNAL_DMAC_YES

  assign use_internal_dmac = cntrl[25];

 `endif


  assign b2c_od_pullup_en_n    = ~cntrl[24];
  assign card_volt_b           = cntrl[23:20];
  assign card_volt_a           = cntrl[19:16];
  assign b2c_ceata_intr_status = cntrl[11];
  assign b2c_send_auto_stop_ccsd  = cntrl[10];
  assign b2c_send_ccsd         = cntrl[9];
  assign b2c_abort_read_data   = cntrl[8];
  assign b2c_send_irq_resp     = cntrl[7];
  assign b2c_read_wait         = cntrl[6];
  assign dma_enabled           = cntrl[5] & (`DMA_INTERFACE != 0);
  assign int_enable            = cntrl[4];
  assign auto_clear_int        = cntrl[3];
  assign dma_reset             = cntrl[2];
  assign clear_pointers        = cntrl[1];
  assign b2c_creset_n          = reset_n & ~cntrl[0];
  assign ciu_reset             = cntrl[0];

  assign clr_clk1_pointers     = cntrl[1] | clr_clear_pointers;
  assign card_power_en         = pwren[`NUM_CARDS-1:0];
  assign card_width_lo         = ctype[`NUM_CARD_BUS-1:0];
  assign b2c_card_type         = ctype[`NUM_CARD_BUS+15:16];
  assign b2c_block_size        = blksiz[15:0];
  assign b2c_byte_count        = bytcnt[31:0];
  assign b2c_data_tmout_cnt    = tmout[31:8];
  assign b2c_resp_tmout_cnt    = tmout[7:0];
  assign b2c_cmd_argument      = cmdarg;
 //SD_3.0 start
  assign b2c_cmd_control       = cmd[29:0];
 //SD_3.0 ends
  assign enable_boot           = cmd[24];
  assign alternative_boot_mode = cmd[27]; 
  assign boot_mode             = alternative_boot_mode || enable_boot;
  //SD_3.0 start
 assign biu_volt_reg           = uhs_reg[`NUM_CARD_BUS-1:0];
 assign b2c_ddr_reg            = uhs_reg[`NUM_CARD_BUS+15:16];
 //SD_3.0 ends
  //eMMC 4.5 start
        assign ext_clk_mux_ctrl              = uhs_reg_ext[31:30];
        assign clk_drv_phase_ctrl            = uhs_reg_ext[29:23]; 
        assign clk_smpl_phase_ctrl           = uhs_reg_ext[22:16]; 
 assign biu_volt_reg_1_2              = uhs_reg_ext[`NUM_CARD_BUS-1:0];
        assign cp_card_num                   = (`CARD_TYPE==0)? {4'b0} : cmd[19:16] ;
 assign b2c_half_start_bit            = half_start_bit[cp_card_num];
  //eMMC 4.5 ends
 assign b2c_enable_shift = enable_shift;

 //MMC_4_4 start
  assign rst_n                 = card_reset[`NUM_CARD_BUS-1:0]; 
 assign card_rd_threshold_en  = cardthrctl[0];
 assign busy_clr_int_mask     = cardthrctl[1]; // This bit will mask the busy clear int. User will need to set this bit to receive busy clear int.
 assign card_rd_threshold_size= cardthrctl[`F_BYTE_WIDTH+15:16]; 
 //MMC_4_4 ends
 //SDIO 3.0 start
 assign back_end_power        = back_end_power_r[`NUM_CARD_BUS-1:0];
  //SDIo 3.0 ends

  // For un-used-Bit Read-0 Optimization 
  assign b2c_card_type_tmp      = {{(16-`NUM_CARD_BUS){1'b0}},b2c_card_type};   
  assign b2c_card_width_tmp     = {{(16-`NUM_CARD_BUS){1'b0}},card_width_lo};   
  assign b2c_cclk_low_power_tmp = {{(16-`NUM_CARD_BUS){1'b0}},b2c_cclk_low_power};       
  assign b2c_cclk_enable_tmp    = {{(16-`NUM_CARD_BUS){1'b0}},b2c_cclk_enable};   
  assign card_num_zero          = 0; 

  assign extended_count         = {{(13-`F_COUNT_WIDTH){1'b0}},count};
  assign fifo_depth_min1        = `FIFO_DEPTH - 1;
  assign half_full              = (count >= `FIFO_DEPTH/2);
  assign half_empty             = (count <= `FIFO_DEPTH/2);
  assign status                 = {dma_req, dma_ack_sync, extended_count, 
                                  response_index,
                                  ~ciu_status[1], ciu_status[3], 
                                  ciu_status[2],  ciu_status[7:4],
                                  full, empty, less_or_equal, greater_than};
  assign addr_width             = `H_ADDR_WIDTH -1;
  assign number_cards           = `NUM_CARDS - 1;
  assign hcon                   = {4'b0000, 
                                  ((`M_ADDR_WIDTH == 32)?1'b0 : 1'b1),
                                  ((`AREA_OPTIMIZED == 1)? 1'b1 : 1'b0),
                                  ((`NUM_CLK_DIVIDERS == 1)? 2'b00 :
                                   (`NUM_CLK_DIVIDERS == 2)? 2'b01 : 
                                   (`NUM_CLK_DIVIDERS == 3)? 2'b10 : 2'b11),
                                  ((`SET_CLK_FALSE_PATH==1)? 1'b1 : 1'b0),
                                  ((`IMPLEMENT_HOLD_REG==1)? 1'b1 : 1'b0),
                                  ((`FIFO_RAM_INSIDE==1)? 1'b1 : 1'b0),
                                  ((`GE_DMA_DATA_WIDTH==16)? 3'b000 :
                                   (`GE_DMA_DATA_WIDTH==32)? 3'b001 : 3'b010),
                                  ((`DMA_INTERFACE == 0)? 2'b00 : (`DMA_INTERFACE == 1)? 2'b01 : (`DMA_INTERFACE == 2) ? 2'b10 : 2'b11),
                                  addr_width,
                                  ((`H_DATA_WIDTH==16)? 3'b000 :
                                   (`H_DATA_WIDTH==32)? 3'b001 : 3'b010),
                                  ((`H_BUS_TYPE==0)? 1'b0 : 1'b1),
                                  number_cards,
                                  ((`CARD_TYPE==0)? 1'b0 : 1'b1)};


  always @ (card_width_lo or b2c_card_type)
    begin
      for(i=0; i < `NUM_CARD_BUS; i=i+1) 
        begin
          b2c_card_width[i]   = card_width_lo[i];
          b2c_card_width[i+`NUM_CARD_BUS] = b2c_card_type[i];
        end
    end

/*
  always @ (card_width_lo or b2c_card_type)
    begin
      for(i=0; i < `NUM_CARD_BUS; i=i+1) 
        begin
          b2c_card_width[i*2]   = card_width_lo[i];
          b2c_card_width[i*2+1] = b2c_card_type[i];
        end
    end
*/


  // Register Read Data Corrected to H_DATA_WIDTH
  always @ (posedge clk or negedge reset_n)
    begin
      if(reset_n == 1'b0)
        regb_rdata <= {`H_DATA_WIDTH{1'b0}};
      else begin
        if(regb_read_en)
          begin
            if(`H_DATA_WIDTH == 16)
              case(paddr[2:1])
                2'b00   : regb_rdata <= mux_rdata[15:0];
                2'b01   : regb_rdata <= mux_rdata[31:16];
                2'b10   : regb_rdata <= mux_rdata[47:32];
                default : regb_rdata <= mux_rdata[63:48];
              endcase
            else if(`H_DATA_WIDTH == 32)
              case(paddr[2])
                1'b0    : regb_rdata <= mux_rdata[31:0];
                default : regb_rdata <= mux_rdata[63:32];
              endcase
            else
              regb_rdata <= mux_rdata;
          end
        end
    end
 
  // Register read data. Read-data is supplied in such a way that DC will
  // optimize unused register bits depending upon configuration 
  always @ (/*AUTOSENSE*/ b2c_card_type_tmp
            or b2c_card_width_tmp or b2c_cclk_enable_tmp
            or b2c_cclk_low_power_tmp or b2c_clk_divider
            or b2c_clk_source or blksiz or bytcnt or card_detect_biu
            or card_num_zero or card_power_en or card_write_prt_biu
            or cmd or cmdarg or cntrl or debnce or fifoth or gp_in_biu
            or gp_out or int_mask_n or masked_ints or paddr or raw_ints
            or resp0 or resp1 or resp2 or resp3 or status or tmout
            or trans_crd_cnt_mx or trans_fifo_cnt_mx or uid or hcon or card_reset 
      or card_rd_threshold_en or busy_clr_int_mask or card_rd_threshold_size or back_end_power_r 
    //SD_3.0,eMMC 4.5 start
          or uhs_reg or uhs_reg_ext or half_start_bit or enable_shift)
  //SD_3.0 eMMC 4.5 ends
  begin
      case(paddr[8:3])

 `ifdef INTERNAL_DMAC_YES

        6'h00  : mux_rdata  = {card_num_zero, card_power_en, 6'h0,
                               cntrl[25:0]};

 `endif



        6'h01  : mux_rdata  = {b2c_clk_source, b2c_clk_divider}; 
        6'h02  : mux_rdata  = {tmout, b2c_cclk_low_power_tmp, 
                              b2c_cclk_enable_tmp};
        6'h03  : mux_rdata  = {16'h0, blksiz[15:0], b2c_card_type_tmp,
                               b2c_card_width_tmp};
        6'h04  : mux_rdata  = {int_mask_n, bytcnt};
        6'h05  : mux_rdata  = {cmd, cmdarg};
        6'h06  : mux_rdata  = {resp1, resp0};
        6'h07  : mux_rdata  = {resp3, resp2};
        6'h08  : mux_rdata  = {raw_ints, masked_ints};
        6'h09  : mux_rdata  = {1'b0, fifoth[30:16], 4'h0, fifoth[11:0], status};
        6'h0a  : mux_rdata  = {card_num_zero, card_write_prt_biu, 
                              card_num_zero, card_detect_biu };
        6'h0b  : mux_rdata  = {trans_crd_cnt_mx, (`AREA_OPTIMIZED==1)? 32'h0 : 
                                                 {8'h0, gp_out, gp_in_biu}};
        6'h0c  : mux_rdata  = {8'h0, debnce[23:0], trans_fifo_cnt_mx};
        6'h0d  : mux_rdata  = {`SD_VERSION_ID, (`AREA_OPTIMIZED==1)? 32'h0:uid};
        //SD_3.0 start
        6'h0e  : mux_rdata  = {uhs_reg, hcon}; 
        //SD_3.0 ends
        6'h0f  : mux_rdata  = {48'h0,{(16-`NUM_CARD_BUS){1'b0}},card_reset[`NUM_CARD_BUS-1:0]};
    //SDIO 3.0 starts
        6'h20  : mux_rdata  = {16'h0,back_end_power_r,{(16-`F_BYTE_WIDTH){1'b0}},card_rd_threshold_size,14'h0,busy_clr_int_mask,card_rd_threshold_en}; 
    //SDIO 3.0 ends
        //eMMC 4.5 start
        6'h21  : mux_rdata  = {16'h0,{(16-`NUM_CARD_BUS){1'b0}},half_start_bit[`NUM_CARD_BUS-1:0],uhs_reg_ext}; 
        //eMMC 4.5 ends
        6'h22   : mux_rdata  = {32'h0,{(32-(`NUM_CARD_BUS)*2){1'b0}},enable_shift[((`NUM_CARD_BUS*2)-1):0]};

        default : mux_rdata  = 64'h0;
      endcase
    end


 `ifdef INTERNAL_DMAC_YES

  assign debug_registers = {
 //SD_3.0 start
                           uhs_reg,
 //SD_3.0 ends
                           hcon, 
                           `SD_VERSION_ID, 
                           ((`AREA_OPTIMIZED==1)? 32'h0 : uid), 
                           8'h0, debnce[23:0], 
                           trans_fifo_cnt,
                           trans_crd_cnt, ((`AREA_OPTIMIZED==1)? 32'h0 : 
                           {8'h0, gp_out, gp_in_biu}),
                           card_num_zero, card_write_prt_biu, 
                           card_num_zero, card_detect_biu,
                           1'b0, fifoth[30:16], 4'h0, fifoth[11:0], 
                           status,
                           raw_ints, 
                           masked_ints, 
                           resp3, 
                           resp2, 
                           resp1,
                           resp0,
                           cmd, 
                           cmdarg,
                           int_mask_n, 
                           8'h0, bytcnt[23:0],
                           16'h0, blksiz[15:0], 
                           b2c_card_width_tmp, b2c_card_type_tmp,
                           tmout, 
                           b2c_cclk_low_power_tmp, b2c_cclk_enable_tmp,
                           b2c_clk_source, 
                           b2c_clk_divider,
                           card_num_zero, card_power_en, 
                           6'h0, cntrl[25:0]};

 `endif



                         
  // Register writes. Interrupt, response, control, and command registers 
  // are outside this block since they are controlled by multiple sources 
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          pwren   <= 32'h0;
          clkdiv  <= 32'h0;
          clksrc  <= 32'h0;
          clkena  <= 32'h0;
          tmout   <= 32'hffff_ff40;
          fifoth  <= {4'h0, fifo_depth_min1, 4'h0, 12'h0};
          blksiz  <= 16'h200;
          bytcnt  <= 32'h200;
          intmsk  <= 32'h0;
          cmdarg  <= 32'h0;
          ctype   <= 32'h0;
          gp_out  <= 16'h0;
          debnce  <= 24'hffffff;
          uid     <= `UID_REG;
           //SD_3.0 start
           uhs_reg <= 32'h0;
           //SD_3.0 ends
           //eMMC 4.5 start
           uhs_reg_ext <= 32'h0;
           enable_shift <= 32'h0;
           half_start_bit <= {(`NUM_CARD_BUS){1'b0}};
           //eMMC 4.5 ends
           //MMC4_4 start
           card_reset <= {(`NUM_CARD_BUS){1'b1}};
           cardthrctl <= 32'h0; 
           //MMC4_4 ends
           //SDIO 3.0 start
           back_end_power_r <= 16'h0;
           //SDIO 3.0 ends
         end
       else
         begin
           if(regb_write_en & ~paddr[7]  & ~paddr[8]) // Address range decoded 00 - 7F ; 80 - FF for IDMAC
             begin
             case(paddr[6:3])
               4'h0 : begin 
                         if(byte_en[7]) 
                           pwren[31:24]  <= regb_wdata[63:56];  
                         if(byte_en[6]) 
                           pwren[23:16]  <= regb_wdata[55:48];  
                         if(byte_en[5]) 
                           pwren[15:8]   <= regb_wdata[47:40];  
                         if(byte_en[4]) 
                           pwren[7:0]    <= regb_wdata[39:32]; 
                       end 

               4'h1 : if(~cmd[31]) 
                        begin 
                         if(byte_en[7]) 
                           clksrc[31:24] <= regb_wdata[63:56];  
                         if(byte_en[6]) 
                           clksrc[23:16] <= regb_wdata[55:48];  
                         if(byte_en[5]) 
                           clksrc[15:8]  <= regb_wdata[47:40];  
                         if(byte_en[4]) 
                           clksrc[7:0]   <= regb_wdata[39:32]; 
                         if(byte_en[3]) 
                           clkdiv[31:24] <= regb_wdata[31:24];  
                         if(byte_en[2]) 
                           clkdiv[23:16] <= regb_wdata[23:16];  
                         if(byte_en[1]) 
                           clkdiv[15:8]  <= regb_wdata[15:8]; 
                         if(byte_en[0]) 
                           clkdiv[7:0]   <= regb_wdata[7:0]; 
                       end 

               4'h2 : if(~cmd[31])
                        begin
                         if(byte_en[7])
                           tmout[31:24]  <= regb_wdata[63:56];
                         if(byte_en[6])
                           tmout[23:16]  <= regb_wdata[55:48];
                         if(byte_en[5])
                           tmout[15:8]   <= regb_wdata[47:40];
                         if(byte_en[4])
                           tmout[7:0]    <= regb_wdata[39:32];
                         if(byte_en[3])
                           clkena[31:24] <= regb_wdata[31:24];
                         if(byte_en[2])
                           clkena[23:16] <= regb_wdata[23:16];
                         if(byte_en[1])
                           clkena[15:8]  <= regb_wdata[15:8];
                         if(byte_en[0])
                           clkena[7:0]   <= regb_wdata[7:0];
                        end 

               4'h3 : begin
                        if(~cmd[31])
                          begin
                           /*if(byte_en[7])
                             blksiz[31:24] <= regb_wdata[63:56];
                           if(byte_en[6])
                             blksiz[23:16] <= regb_wdata[55:48];*/
                           if(byte_en[5])
                             blksiz[15:8]  <= regb_wdata[47:40];
                           if(byte_en[4])
                             blksiz[7:0]   <= regb_wdata[39:32];
                          end

                         if(byte_en[3])
                           ctype[31:24]  <= regb_wdata[31:24];
                         if(byte_en[2])
                           ctype[23:16]  <= regb_wdata[23:16];
                         if(byte_en[1])
                           ctype[15:8]   <= regb_wdata[15:8];
                         if(byte_en[0])
                           ctype[7:0]    <= regb_wdata[7:0];

                        end 

               4'h4 : begin
                         if(byte_en[7])
                           intmsk[31:24] <= regb_wdata[63:56];
                         if(byte_en[6])
                           intmsk[23:16] <= regb_wdata[55:48];
                         if(byte_en[5])
                           intmsk[15:8]  <= regb_wdata[47:40];
                         if(byte_en[4])
                           intmsk[7:0]   <= regb_wdata[39:32];
                         if(~cmd[31])
                            begin
                             if(byte_en[3])
                               bytcnt[31:24] <= regb_wdata[31:24];
                             if(byte_en[2])
                               bytcnt[23:16] <= regb_wdata[23:16];
                             if(byte_en[1])
                               bytcnt[15:8]  <= regb_wdata[15:8];
                             if(byte_en[0])
                               bytcnt[7:0]   <= regb_wdata[7:0];
                            end
                       end 

               4'h5 : if(~cmd[31])
                        begin
                         if(byte_en[3])
                           cmdarg[31:24] <= regb_wdata[31:24];
                         if(byte_en[2])
                           cmdarg[23:16] <= regb_wdata[23:16];
                         if(byte_en[1])
                           cmdarg[15:8]  <= regb_wdata[15:8];
                         if(byte_en[0])
                           cmdarg[7:0]   <= regb_wdata[7:0];
                        end

               4'h9 : begin               
                         if(byte_en[7])
                           fifoth[31:24] <= regb_wdata[63:56];
                         if(byte_en[6])
                           fifoth[23:16] <= regb_wdata[55:48];
                         if(byte_en[5])
                           fifoth[15:8]  <= regb_wdata[47:40];
                         if(byte_en[4])
                           fifoth[7:0]   <= regb_wdata[39:32];
                       end

               4'hb : begin               
                         if(byte_en[2])
                           gp_out[15:8]  <= regb_wdata[23:16];
                         if(byte_en[1])
                           gp_out[7:0]   <= regb_wdata[15:8];
                       end

               4'hc : begin 
                         if(byte_en[6])
                           debnce[23:16] <= regb_wdata[55:48];
                         if(byte_en[5])
                           debnce[15:8]  <= regb_wdata[47:40];
                         if(byte_en[4])
                           debnce[7:0]   <= regb_wdata[39:32];
                       end

               4'hd : begin               
                         if(byte_en[3])
                           uid[31:24]    <= regb_wdata[31:24];
                         if(byte_en[2])
                           uid[23:16]    <= regb_wdata[23:16];
                         if(byte_en[1])
                           uid[15:8]     <= regb_wdata[15:8];
                         if(byte_en[0])
                           uid[7:0]      <= regb_wdata[7:0];
                       end
               //SD_3.0 start
        4'he : begin
                  if(byte_en[7])
                           uhs_reg[31:24]    <= regb_wdata[63:56];
                         if(byte_en[6])
                           uhs_reg[23:16]    <= regb_wdata[55:48];
                         if(byte_en[5])
                           uhs_reg[15:8]     <= regb_wdata[47:40];
                         if(byte_en[4])
                           uhs_reg[7:0]      <= regb_wdata[39:32];
               end  
       //SD_3.0 ends    
       //MMC4_4 start    
        4'hf :  begin   
                         for (i=0;i<`NUM_CARD_BUS;i=i+1) begin
                           if(byte_en[0] & i < 8)
                             card_reset[i] <= regb_wdata[i];
                           if(byte_en[1] & i >= 8)
                             card_reset[i] <= regb_wdata[i];
                         end
                end
        //MMC4_4 ends                     
             endcase
             end

       if(regb_write_en & paddr[8])  // Address Range decoded 100 - 1FF
             begin
             case(paddr[7:3])
                
        5'h00 : begin 
                         if(byte_en[5]) 
                           back_end_power_r[15:8]   <= regb_wdata[47:40];  
                         if(byte_en[4]) 
                           back_end_power_r[7:0]   <= regb_wdata[39:32]; 
                         if(byte_en[3]) 
                           cardthrctl[31:24] <= regb_wdata[31:24];  
                         if(byte_en[2]) 
                           cardthrctl[23:16] <= regb_wdata[23:16];  
                         if(byte_en[1]) 
                           cardthrctl[15:8]  <= regb_wdata[15:8]; 
                         if(byte_en[0]) 
                           cardthrctl[7:0]   <= regb_wdata[7:0]; 
                end
         //eMMC 4.5 start
        5'h01 : begin 
                    //emmc_ddr_reg
                         
                         for (i=0;i<`NUM_CARD_BUS;i=i+1) begin
                           if(byte_en[4] & i < 8)
                             half_start_bit[i] <= regb_wdata[i+32];
                           if(byte_en[5] & i >= 8)
                             half_start_bit[i] <= regb_wdata[i+32];
                         end


                     //uhs_reg_ext
                         if(byte_en[3]) 
                           uhs_reg_ext[31:24] <= regb_wdata[31:24];  
                         if(byte_en[2]) 
                           uhs_reg_ext[23:16] <= regb_wdata[23:16];  
                         if(byte_en[1]) 
                           uhs_reg_ext[15:8]  <= regb_wdata[15:8]; 
                         if(byte_en[0]) 
                           uhs_reg_ext[7:0]   <= regb_wdata[7:0]; 
                       end
        5'h02 : begin 


                     //enable_shift
                         if(byte_en[3]) 
                           enable_shift[31:24] <= regb_wdata[31:24];  
                         if(byte_en[2]) 
                           enable_shift[23:16] <= regb_wdata[23:16];  
                         if(byte_en[1]) 
                           enable_shift[15:8]  <= regb_wdata[15:8]; 
                         if(byte_en[0]) 
                           enable_shift[7:0]   <= regb_wdata[7:0]; 
                       end
       endcase
       end
        //eMMC 4.5 end

         end // else of if(~reset_n)
    end// always

  // Control and Command Registers and command-start
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          b2c_cmd_start <= 1'b0;
          cmd           <= 32'h20000000;
          cntrl         <= 32'h0;
        end
      else
        begin
          // Command Register
          if(ciu_reset)
            b2c_cmd_start <= 1'b0;
          else if(~cmd[31] & cmd_write & byte_en[7] & regb_wdata[63])
            b2c_cmd_start <= ~b2c_cmd_start;

          if(cmd_taken | ciu_reset)
            begin
              cmd[31] <= 1'b0;
            end
          else if(~cmd[31] & cmd_write)
            begin
              if(byte_en[7])
                cmd[31:24]    <= regb_wdata[63:56];
              if(byte_en[6])
                cmd[23:16]    <= regb_wdata[55:48];
              if(byte_en[5])
                cmd[15:8]     <= regb_wdata[47:40];
              if(byte_en[4])
                cmd[7:0]      <= regb_wdata[39:32];
            end

          // Control Reg
          if(cntrl_write)
            begin
              if(byte_en[3]) 
                cntrl[31:24]  <= regb_wdata[31:24];  
              if(byte_en[2]) 
                cntrl[23:16]  <= regb_wdata[23:16];  
              if(byte_en[1]) 
                cntrl[15:11]   <= regb_wdata[15:11]; 
              if(byte_en[0])
                cntrl[5:3]    <= regb_wdata[5:3]; 
            end

          if (cntrl[2])
            cntrl[2] <= 1'b0;
          else if (byte_en[0] && cntrl_write)
            cntrl[2] <= regb_wdata[2];

          if (clr_clear_pointers)
            cntrl[1] <= 1'b0;
          else if (byte_en[0] && cntrl_write && ~cntrl[1])
            cntrl[1] <= regb_wdata[1];
 

          `ifdef INTERNAL_DMAC_YES

          else if (fifo_ptr_rst)
            cntrl[1] <= 1'b1;

          `endif 


          if (clear_ciu_reset)
            cntrl[0] <= 1'b0;
          else if (byte_en[0] && cntrl_write && ~cntrl[0])
            cntrl[0] <= regb_wdata[0];

          if(ciu_reset | clr_send_ccsd)
            cntrl[10] <= 1'b0;
          else if(cntrl_write & byte_en[1])
            cntrl[10] <= regb_wdata[10];

          if(ciu_reset | clr_send_ccsd)
            cntrl[9] <= 1'b0;
          else if(cntrl_write & byte_en[1])
            cntrl[9] <= regb_wdata[9];

          if(ciu_reset | clr_abrt_read_data)
            cntrl[8] <= 1'b0;
          else if(cntrl_write & byte_en[1] & ~cntrl[8])
            cntrl[8] <= regb_wdata[8];

          if(ciu_reset | clear_irq_response)
            cntrl[7] <= 1'b0;
          else if(cntrl_write & byte_en[0] & ~cntrl[7])
            cntrl[7] <= regb_wdata[7];

          if(ciu_reset)
            cntrl[6] <= 1'b0;
          else if(cntrl_write & byte_en[0])
            cntrl[6] <= regb_wdata[6];
        end
    end


  // Response Data and Index Registers
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          resp0          <= 32'h0;
          resp1          <= 32'h0;
          resp2          <= 32'h0;
          resp3          <= 32'h0;
          response_index <= 6'h0;
        end
      else
        begin
          if(response_valid)
            begin
              case(c2b_response_addr)
                2'b00 : begin
                          resp0           <= c2b_response_data[31:0];
                          response_index  <= c2b_response_data[37:32];
                        end
                2'b01 : begin
                          resp1           <= c2b_response_data[31:0];
                          response_index  <= c2b_response_data[37:32];
                        end
                2'b10 : resp2             <= c2b_response_data[31:0];
              default : begin
                          resp3           <= c2b_response_data[31:0];
                          response_index  <= c2b_response_data[37:32];
                        end
              endcase
            end
        end
    end


  // Interrupt Generation 
  assign sdio_interrupt_tmp = {{(16-`NUM_CARD_BUS){1'b0}},sdio_interrupt}; // Assign unused-bits to "0" 
  assign int_mask_n         = (`CARD_TYPE==0)? {16'h0, intmsk[15:0]} : intmsk;
  assign raw_ints           = (`CARD_TYPE==0)? {16'h0, rawints[15:0]}: rawints;
  assign masked_ints        = raw_ints & int_mask_n;

  assign hrdware_lock_error = (regb_write_en & cmd[31] & (
                              (paddr[8:3] == 6'h1) |
                              (paddr[8:3] == 6'h2) |
                              (paddr[8:3] == 6'h3) |
                              ((paddr[8:3] == 6'h4) & |byte_en[3:0]) |
                              (paddr[8:3] == 6'h5)));

  assign std_interrupt = {rxend_nocrc_err, auto_cmd_done,
                         rx_stbit_err, hrdware_lock_error,
             //SD_3.0 start
                         (fifo_under | fifo_over), (data_strv_err | volt_switch_int),
             //SD_3.0 ends
                         data_timeout, resp_timeout,
                         data_crc_err, resp_crc_err,
                         (greater_than & trans_in_prog & ~trans_write_in_prog),
                         (less_or_equal & trans_in_prog & trans_write_in_prog),
                         data_trans_done, response_done,
                         response_err, card_detect_int};

  // Set the raw-interrupt register on arrival, clear when software
  // clears them by either writting "1" to a bit or when auto-clear is
  // and register read happens 
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          rawints             <= 32'h0;
          interrupt           <= 1'b0;
          trans_in_prog       <= 1'b0;
          trans_write_in_prog <= 1'b0;
        end
      else
        begin

           interrupt <= |(masked_ints) & int_enable;
 
           for(j=31; j >= 24; j= j-1)
             begin 
               if(sdio_interrupt_tmp[j-16])
                 rawints[j] <= 1'b1; 
               else if(rawints_write & byte_en[7] & regb_wdata[j+32])
                 rawints[j] <= 1'b0;
             end

           for(j=23; j >= 16; j= j-1)
             begin
               if(sdio_interrupt_tmp[j-16])
                 rawints[j] <= 1'b1;
               else if(rawints_write & byte_en[6] & regb_wdata[j+32])
                 rawints[j] <= 1'b0; 
             end

           for(j=15; j >= 8; j= j-1)
             begin
               if(std_interrupt[j])
                 rawints[j] <= 1'b1;
               else if(rawints_write & byte_en[5] & regb_wdata[j+32]) 
                 rawints[j] <= 1'b0; 
             end

           for(j=7; j >= 0; j= j-1)
             begin
               if(std_interrupt[j])
                 rawints[j] <= 1'b1;
               else if(rawints_write & byte_en[4] & regb_wdata[j+32]) 
                 rawints[j] <= 1'b0; 
             end

          if((ciu_reset & ~dma_enabled) | (dma_reset & dma_enabled) |
            (data_trans_done) | 
            ((resp_timeout & !boot_mode) & b2c_cmd_control[9] & ~b2c_cmd_control[21]))
            begin
              trans_in_prog       <= 1'b0;
              trans_write_in_prog <= 1'b0;
            end
          else if(cmd_taken & b2c_cmd_control[9] & ~b2c_cmd_control[21])
            begin
              trans_in_prog       <= 1'b1;
              trans_write_in_prog <= b2c_cmd_control[10];
            end
        end
    end

 
  // CIU domain to BIU domain Counter gray2bin Conversion
  // There are 3 implemnetations provided; The Default is Fast,
  // if you want to use another type uncomment it and comment 
  // the Fast.

  // 1. Fast type - Following is meant only for 2**n Gary to Bin;  
  assign g2b4     = ciu_trans_bytes ^ {16'h0, ciu_trans_bytes[31:16]};
  assign g2b3     = g2b4 ^ {8'h00, g2b4[31:8]};
  assign g2b2     = g2b3 ^ {4'h0,  g2b3[31:4]};
  assign g2b1     = g2b2 ^ {2'b00, g2b2[31:2]};
  assign g2b      = g2b1 ^ {1'b0, g2b1[31:1]};

  /*  <<------- Start Comment
  // 2. Ripple Type - Low area, slow; DC may even automatically build parallel 
  //                  XOR trees for timing driven designs; need not be 2**n
  reg [31:0] g2b_slow;
  integer i;
 
  assign g2b = g2b_slow; 
  always (ciu_trans_bytes)
    begin
      g2b_slow[31] = ciu_trans_bytes[31];
      for (i=30; i >=0; i = i+1) 
        g2b_slow[i] = g2b_slow[i+1] ^ ciu_trans_bytes[i];
    end
  */

  /*  <<------- Start Comment
  // 3. Using DesignWare - General puspose; need not be 2**n; DC would pick 
  //                       automatically a fast/slow version depending upon 
  //                       user constrain. Need DesignWare License
  DW_gray2bin #(32) U_DW_gray2bin 
    (
     .g(ciu_trans_bytes),
     .b(g2b)
     );
  */

  // Pending FIFO-Count Logic
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          trans_crd_cnt1     <= 32'h0;
          trans_fifo_cnt     <= 32'h0;
        end
      else
        begin
          if(trans_in_prog)
            trans_crd_cnt1      <=  g2b; 

          if((cmd_taken & b2c_cmd_control[9] & ~b2c_cmd_control[21]) | 
            ciu_reset)
            trans_fifo_cnt     <= 32'h0;
          else if(host_2_fifo_inc)
            trans_fifo_cnt <= trans_fifo_cnt + ((`F_DATA_WIDTH == 32)? 32'h4 :
                                                                       32'h8);
        end
    end


 // When Area-OPTIMIZATION is enabled un-synchronized byte count from 
 // CIU is used. To avoid metastability it is qualified with "Transfer
 // in progress". In AREA-OPTIMIZATION  mode this register should be used 
 // only after data transfer in done 
 
 assign trans_crd_cnt  = (`AREA_OPTIMIZED == 0)? trans_crd_cnt1 :
                            (trans_in_prog)? 32'h0 : c2b_trans_bytes_bin;

 // Coherecy Read Register For the 32-bit Counters in H_DATA_WIDTH == 16 Mode 
  assign trans_crd_cnt_mx  = (`H_DATA_WIDTH == 16)? 
                                {trans_bytcnt_tmp_data, trans_crd_cnt[15:0]} :
                                trans_crd_cnt;
 
  assign trans_fifo_cnt_mx = (`H_DATA_WIDTH == 16)? 
                                {trans_bytcnt_tmp_data, trans_fifo_cnt[15:0]} :
                                trans_fifo_cnt;

  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
         trans_bytcnt_tmp_data <= 16'h0;
      else
        begin
          if(regb_read_en_dly)
            if(paddr[8:1] == 8'b0010_1110)
              trans_bytcnt_tmp_data <= trans_crd_cnt[31:16];
            else if(paddr[8:1] == 8'b011_0000)
              trans_bytcnt_tmp_data <= trans_fifo_cnt[31:16];
        end
    end

  // Misc 
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        dma_ack_sync <= 1'b0;
      else
        dma_ack_sync <= dma_ack;
    end

endmodule // 

 
