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
// Date             :        $Date: 2012/06/01 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_biu.v#37 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_biu.v
// Description : DWC_mobile_storage Bus Interface Unit. Thi unit has the following 
//               functions:
//                 - Controls the Register and FIFO Units
//                 - Handles DATA bus tansfer size mismatch between 
//                   the FIFO/Registers and the HOST/DMA buses. 
//                 - Generates the card-detect interrupt
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_biu(
  /*AUTOARG*/
  // Outputs
  prdata, dw_dma_req, dw_dma_single, dw_dma_write, dw_dma_card_num, 
  ge_dma_wdata, ge_dma_req, ge_dma_done, ge_dma_write, 
  ge_dma_card_num, interrupt, raw_ints, int_mask_n, int_enable, debug_registers,
  gp_out, card_power_en, card_volt_a, card_volt_b, b2c_od_pullup_en_n, 
  b2c_clk_divider, b2c_clk_source, b2c_block_size, 
  b2c_byte_count, b2c_data_tmout_cnt, b2c_resp_tmout_cnt, 
  b2c_cmd_control, 
  enable_boot,
  alternative_boot_mode,
  b2c_cmd_argument, b2c_creset_n, b2c_cmd_start, 
  b2c_read_wait, b2c_cclk_enable, b2c_cclk_low_power, b2c_card_width, 
  b2c_card_type, b2c_send_irq_resp, b2c_abort_read_data, b2c_ceata_intr_status,
  b2c_send_ccsd, b2c_send_auto_stop_ccsd, b2c_clear_pointers,
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
  rst_n,
 card_rd_threshold_en,
 busy_clr_int_mask,
 card_rd_threshold_size,
 //MMC4_4 ends
  //SDIO 3.0 start
  back_end_power, 
 //SDIO 3.0 ends 
  biu_fifo_wdata, biu_fifo_pop, biu_fifo_push, biu_less_equal_thresh, 
  biu_greater_than_thresh,clr_clk1_pointers,

  `ifdef INTERNAL_DMAC_YES

  use_internal_dmac,
  dw_dma_trans_size,
  fifo_ptr_rst,
  dmac_push,
  dmac_pop,

  `endif

 
  // Inputs
  clk, reset_n, psel, penable, pwrite, paddr, pbe, pwdata, 
  dw_dma_ack, ge_dma_ack, ge_dma_rdata, card_detect_biu, 
  card_write_prt_biu, gp_in_biu, sdio_interrupt,
 //SD_3.0 start
  volt_switch_int,
 //SD_3.0 ends
  c2b_response_data, c2b_response_addr, cmd_taken, response_valid, 
  response_err, response_done, ciu_data_trans_done, data_timeout, 
  resp_timeout, data_crc_err, resp_crc_err, c2b_trans_bytes_bin,
  ciu_status, auto_cmd_done, rx_stbit_err, data_strv_err,
  rxend_nocrc_err, ciu_trans_bytes, clr_abrt_read_data, clear_irq_response, 
  biu_count, biu_almost_empty, biu_almost_full, biu_empty, biu_full,
  biu_greater_than, biu_less_or_equal, biu_fifo_rdata, clear_ciu_reset,
  clr_clear_pointers, clr_send_ccsd, scan_mode
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  // Host Clock and Reset
  input                        clk;             // System Clock 
  input                        reset_n;         // System Reset - Active Low

  // APB With Sideband
  input                        psel;            // APB Peripheral Select Signal
  input                        penable;         // APB Strobe Signal
  input                        pwrite;          // APB Write Signal
  input    [`H_ADDR_WIDTH-1:0] paddr;           // APB Address bus
  input  [`H_DATA_WIDTH/8-1:0] pbe;             // APB Byte Enable
  input    [`H_DATA_WIDTH-1:0] pwdata;          // APB Write data Bus
  output   [`H_DATA_WIDTH-1:0] prdata;          // APB Read Data Bus

  // DW-DMA
  input                        dw_dma_ack;      // DW-DMA Ack
  output                       dw_dma_req;      // DW-DMA Request
  output                       dw_dma_single;   // DW-DMA Single Request 
  output                       dw_dma_write;    // DW-DMA Write to memory
  output                 [4:0] dw_dma_card_num; // DW-DMA Current Card In Use

  // Generic-DMA
  input                           ge_dma_ack;      // GE-DMA Ack
  input  [`GE_DMA_DATA_WIDTH-1:0] ge_dma_rdata;    // GE-DMA Input Read Data
  output [`GE_DMA_DATA_WIDTH-1:0] ge_dma_wdata;    // GE-DMA Output Write Data
  output                          ge_dma_req;      // GE-DMA Request
  output                          ge_dma_done;     // GE-DMA Transfer Done
  output                          ge_dma_write;    // DW-DMA Write to memory
  output                    [4:0] ge_dma_card_num; // GE-DMA Current Card In Use

  // Interrupt Control
  output                       interrupt;       // Combined System Interrupt
  output                [31:0] raw_ints;        // Raw Interrupts - for debug
  output                [31:0] int_mask_n;      // Int mask Register-for debug 
  output                       int_enable;      // Global Int Enable-for debug
 //SD_3.0 start
  output               [959:0] debug_registers; // All Register-for debug 
 //SD_3.0 ends

  // Card Interface
  input       [`NUM_CARDS-1:0] card_detect_biu;      // Card Detect - Sync
  input       [`NUM_CARDS-1:0] card_write_prt_biu;   // Write Protect - Sync

  // General Purpose Input/Output
  input                  [7:0] gp_in_biu;            // General Purpose Input
  output                [15:0] gp_out;               // General Purpose Output

  output      [`NUM_CARDS-1:0] card_power_en;        // Indivi. Card Power Ena
  output                 [3:0] card_volt_a;          // Card Regulator Volt-A
  output                 [3:0] card_volt_b;          // Card Regulator Volt-B
  output                       b2c_od_pullup_en_n;   // Command Pullup Control

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
  output                       b2c_clear_pointers;  // Clear FIFO Pointers
 //SD_3.0 start
 output   [`NUM_CARD_BUS-1:0] biu_volt_reg;
 output   [`NUM_CARD_BUS-1:0] b2c_ddr_reg;
 //SD_3.0 ends
        //eMMC 4.5 start
        output      [1:0]       ext_clk_mux_ctrl;
        output      [6:0]       clk_drv_phase_ctrl;
        output      [6:0]       clk_smpl_phase_ctrl;

 output   [`NUM_CARD_BUS-1:0] biu_volt_reg_1_2;
 output                   b2c_half_start_bit;
 output   [((`NUM_CARD_BUS*2)-1):0] b2c_enable_shift;
        //eMMC 4.5 ends 
 //MMC4_4 start
  output   [`NUM_CARD_BUS-1:0] rst_n;
  output                       card_rd_threshold_en;
  output                       busy_clr_int_mask ;
  output   [`F_BYTE_WIDTH-1:0] card_rd_threshold_size;
 
 //MMC4_4 ends
  //SDIO 3.0 start
  output   [`NUM_CARD_BUS-1:0] back_end_power; // Back end power for applications on the card.1 per card. 
 //SDIO 3.0 ends

  output                       clr_clk1_pointers;   // Clear only clk1 pointers

  // From CIU
  input    [`NUM_CARD_BUS-1:0] sdio_interrupt;       // SDIO Interrupts
 //SD_3.0 start
 input                        volt_switch_int;      //interrupts during voltage switch proceedure.
  //SD_3.0 ends
  input                 [37:0] c2b_response_data;    // Response Data
  input                  [1:0] c2b_response_addr;    // Response Address
  input                 [31:0] c2b_trans_bytes_bin;  // Trans Byte Count-binary 
  input                        cmd_taken;            // Command Taken
  input                        response_valid;       // Response Valid
  input                        response_err;         // Response Error
  input                        response_done;        // Response Done
  input                        ciu_data_trans_done;  // CIU Data Transfer Done
  input                        data_timeout;         // Data Timeout
  input                        resp_timeout;         // Response Timeout
  input                        data_crc_err;         // Data CRC Error
  input                        resp_crc_err;         // Response CRC Error
  input   [7:0]                ciu_status;           // CIU Status
  input                        auto_cmd_done;        // Auto Command Done
  input                        rx_stbit_err;         // Incorrect Data Start
  input                        data_strv_err;        // Data starvation error
  input                        rxend_nocrc_err;      // Rx end bit/no crc error
  input                 [31:0] ciu_trans_bytes;      // CIU Transfered Bytes

  // Loop Back Clear Flags From b2c - c2b
  input                        clr_abrt_read_data;   // Abort Read Data Taken
  input                        clear_irq_response;   // Send IRQ Response Taken
  input                        clear_ciu_reset;      // CIU Reset Done.
  input                        clr_clear_pointers;   // FIFO Controller Reset Done.
  input                        clr_send_ccsd;        // Clear send_ccsd bit
   
  // To and From FIFO 
  output   [`F_DATA_WIDTH-1:0] biu_fifo_wdata;       // FIFO Data in - BIU
  output                       biu_fifo_pop;         // FIFO Pop - BIU
  output                       biu_fifo_push;        // FIFO Push - BIU
  output  [`F_COUNT_WIDTH-1:0] biu_less_equal_thresh;   // FIFO less_equal_thres
  output  [`F_COUNT_WIDTH-1:0] biu_greater_than_thresh; // FIFO great_than_thres
  input    [`F_DATA_WIDTH-1:0] biu_fifo_rdata;       // FIFO Data Out - BIU
  input   [`F_COUNT_WIDTH-1:0] biu_count;           // FIFO Count
  input                        biu_almost_empty;    // FIFO almost_empty Flag
  input                        biu_almost_full;     // FIFO almost_full Flag
  input                        biu_empty;           // FIFO empty Flag
  input                        biu_full;            // FIFO full Flag
  input                        biu_greater_than;    // FIFO greater than flag
  input                        biu_less_or_equal;   // FIFO less than equ flag 

  // Misc
  input                        scan_mode;            // Scan Mode bypass

  `ifdef INTERNAL_DMAC_YES

  output                       use_internal_dmac;
  output                [2:0]  dw_dma_trans_size;
  input                        fifo_ptr_rst;
  input                        dmac_push;
  input                        dmac_pop;

  `endif



  // --------------------------------------
  // Register/Wire Declaration
  // --------------------------------------
 
  reg                   [7:0] byte_en;             // Byte Enable
  reg                  [63:0] regb_wdata;          // Register Write Data
  reg                  [63:0] fifo_rdata;          // Host FIFO read Data
  reg                  [15:0] ge_dma_tmp_data;     // Temp. data match DAM Reg 
  reg                   [7:0] fbyte_en;            // Host FIFO Byte Enable
  reg                  [63:0] f_wdata;             // Host FIFO Write Data
  reg                  [55:0] host_tmp_data;       // Host Temp Host Data
  reg                   [1:0] fifo_low_addr;       // Host Lower FIFO Address

  wire                  [2:0] dw_dma_trans_size;   // DMA Trans. size
  wire    [`F_DATA_WIDTH-1:0] biu_fifo_wdata;      // FIFO Data in - BIU
  wire    [`F_DATA_WIDTH-1:0] biu_fifo_rdata;      // FIFO Data Out - BIU
  wire                        biu_fifo_pop;        // FIFO Pop - BIU
  wire                        biu_fifo_push;       // FIFO Push - BIU
  wire                        host_pop;            // Host FIFO Pop
  wire                        host_push;           // Host FIFO Push
 
  wire                        regb_write_en;       // Host Register Write
  wire                        regb_read_en;        // Host Register Read
  wire                        regb_read_en_dly;    // Host Register Read-penable
  wire                        write_en;            // Host Write Enable
  wire                        read_en;             // Host Read Enable

  wire                        fifo_decode;         // FIFO Address Decode
  reg                         fifo_select;         // FIFO Select
  wire                        fifo_write_en;       // FIFO Write from host/dwdma
  wire                        fifo_read_en;        // FIFO read from host/dwdma
  wire                        fifo_under;          // FIFO UnderRun
  wire                        fifo_over;           // FIFO OverRun
  wire                        host_2_fifo_inc;     // Host To FIFO Transfer 
 
  wire                  [7:0] ipbe;                // Internal bit-extended pbe
  wire    [`F_DATA_WIDTH-1:0] ge_dma_fifo_wdata;   // GE-DMA FIFO Write Data
  wire    [`F_DATA_WIDTH-1:0] ge_dma_wdata_tmp;    // GE-DMA FIFO Write Data
  wire                 [15:0] ge_dma_wdata_16;     // GE-DMA FIFO WData in 16bit
  wire                 [63:0] host_fifo_wdata_64;  // Host FIFO Write Data-64
  wire                 [31:0] host_fifo_wdata_32;  // Host FIFO Write Data-32
  wire                 [63:0] host_fifo_wdata_tmp; // Host FIFO Write Data Tmp
  wire    [`F_DATA_WIDTH-1:0] host_fifo_wdata;     // Host FIFO Write Data
  wire                 [63:0] biu_fifo_rdata_tmp;  // Bit-Extended FIFO Output 
  wire                        dma_req;             // DMA request
  wire                        dma_ack;             // DMA acknowledge 

  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire                  card_detect_int;     // From U_cdet of DWC_mobile_storage_cdet.v
  wire                  data_trans_done;     // From U_dma of DWC_mobile_storage_dma.v
  wire [23:0]           debounce_count;      // From U_regb of DWC_mobile_storage_regb.v
  wire                  dma_enabled;         // From U_regb of DWC_mobile_storage_regb.v
  wire                  dma_reset;           // From U_regb of DWC_mobile_storage_regb.v
  wire                  ciu_reset;           // From U_regb of DWC_mobile_storage_regb.v
  wire                  ge_dma_addr0;        // From U_dma of DWC_mobile_storage_dma.v
  wire                  ge_dma_pop;          // From U_dma of DWC_mobile_storage_dma.v
  wire                  ge_dma_push;         // From U_dma of DWC_mobile_storage_dma.v
  wire [`H_DATA_WIDTH-1:0] regb_rdata;  // From U_regb of DWC_mobile_storage_regb.v
  wire [31:0]           trans_fifo_cnt; // From U_regb of DWC_mobile_storage_regb.v
  // End of automatics

 `ifdef INTERNAL_DMAC_YES

  wire                       use_internal_dmac;

  `endif


           

  assign ipbe                  = {{(8-(`H_DATA_WIDTH/8)){1'b0}},pbe};
  assign fifo_decode           = |paddr[`H_ADDR_WIDTH-1:9];
  assign write_en              = psel &  penable &  pwrite;
  assign read_en               = psel & ~penable & !pwrite;
  assign regb_write_en         = write_en & !fifo_decode;
  assign regb_read_en          = read_en  & !fifo_decode;
  assign regb_read_en_dly      = psel & penable & !pwrite & !fifo_decode;

  assign fifo_write_en         = write_en & fifo_decode;
  assign fifo_read_en          = psel & penable & !pwrite & fifo_decode;

  `ifdef INTERNAL_DMAC_YES
  assign fifo_under            =  (biu_count == 0) & dmac_pop;
  assign fifo_over             =  (biu_count == `FIFO_DEPTH) & dmac_push;
  `endif

  `ifdef INTERNAL_DMAC_NO
  assign fifo_under            =  (biu_count == 0) & fifo_read_en;
  assign fifo_over             =  (biu_count == `FIFO_DEPTH) & fifo_write_en;
  `endif

  // Final FIFO Push/Pop/Wdata
  assign biu_fifo_push   = ge_dma_push | host_push;
  assign biu_fifo_pop    = ge_dma_pop  | host_pop;
  assign biu_fifo_wdata  = ge_dma_push?   ge_dma_fifo_wdata : host_fifo_wdata;


  `ifdef INTERNAL_DMAC_YES

  assign host_2_fifo_inc =  host_push | host_pop | dmac_push | dmac_pop;

  `endif



  // FIFO Status to CIU
  assign dma_req               = (`DMA_INTERFACE == 1 || `DMA_INTERFACE == 3)? dw_dma_req : ge_dma_req;
  assign dma_ack               = (`DMA_INTERFACE == 1 || `DMA_INTERFACE == 3)? dw_dma_ack : ge_dma_ack;


  // Host Read Data
  assign prdata = fifo_select? fifo_rdata[`H_DATA_WIDTH-1:0] : regb_rdata;

  // Registered FIFO Select
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        fifo_select <= 1'b0;
      else
        begin
          if(fifo_decode & psel)
            fifo_select <= 1'b1;
          else
            fifo_select <= 1'b0;
        end
    end

  // Register Byte Enable Control & Register Write-Data
  always @ (paddr or ipbe or pwdata)
    begin
      if(`H_DATA_WIDTH == 16) 
        begin
          case(paddr[2:1])
            2'b00   : byte_en = 8'b0000_0011 & {4{ipbe[1:0]}};
            2'b01   : byte_en = 8'b0000_1100 & {4{ipbe[1:0]}};
            2'b10   : byte_en = 8'b0011_0000 & {4{ipbe[1:0]}};
            default : byte_en = 8'b1100_0000 & {4{ipbe[1:0]}};
          endcase
          regb_wdata = {4{pwdata[`H_DATA_WIDTH-1:0]}};
        end
      else if(`H_DATA_WIDTH == 32) 
        begin
          case(paddr[2])
            1'b0    : byte_en = 8'b0000_1111 & {2{ipbe[3:0]}};
            default : byte_en = 8'b1111_0000 & {2{ipbe[3:0]}};
          endcase
          regb_wdata = {2{pwdata[`H_DATA_WIDTH-1:0]}};
        end

      else //  H_DATA_WIDTH = 64 
        begin
          byte_en = ipbe;
          regb_wdata = pwdata[`H_DATA_WIDTH-1:0];
        end
    end


  // When FIFO-Data Width is not equal to the Host Data Width  
  // Temorary buffers are used to store the data. Also since partial
  // writes to FIFO is allowd, the same temporary buffers are used to store the
  // lower bytes till the higher byte data arrives. During both read
  // and write FIFO data is poped/pushed only when the higher-byte data
  // is accessed. If H_DATA_WIDTH is greater than F_DATA_WIDTH, only 
  // the lower F_DATA_WIDTH of host data bus is used. 
  // This logic is common for both normal Host access and DW-DMA access

  assign biu_fifo_rdata_tmp = biu_fifo_rdata;
  assign host_push = fifo_write_en & (((`F_DATA_WIDTH == 64) & fbyte_en[7]) |
                     ((`F_DATA_WIDTH == 32) & fbyte_en[3]));
  assign host_pop  = fifo_read_en  & (((`F_DATA_WIDTH == 64) & fbyte_en[7]) |
                     ((`F_DATA_WIDTH == 32) & fbyte_en[3]));

  // Lower FIFO address generation to support H_DATA_WIDTH != F_DATA_WIDTH
  // condition
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
         fifo_low_addr <= 2'b00;
      else
        begin
          if(b2c_clear_pointers)
            fifo_low_addr <= 2'b00;
          else if((fifo_write_en | fifo_read_en) & (
            ((`F_DATA_WIDTH == 32) &  ipbe[1]) | ((`F_DATA_WIDTH == 64) & (
            ((`H_DATA_WIDTH == 16) & ipbe[1]) |
                 ((`H_DATA_WIDTH == 32) & ipbe[3])))))
            fifo_low_addr <= fifo_low_addr + 2'b01;
        end
    end


  // Byte Enable generation to support partial bus access.
  // Write and read Data genration 
  always @ (fifo_low_addr or ipbe or pwdata or biu_fifo_rdata_tmp)
    begin
      if(`F_DATA_WIDTH == 64)
        begin
          if(`H_DATA_WIDTH == 16)
            begin
              case(fifo_low_addr)
                2'b00   : fbyte_en = 8'b0000_0011 & {4{ipbe[1:0]}};
                2'b01   : fbyte_en = 8'b0000_1100 & {4{ipbe[1:0]}};
                2'b10   : fbyte_en = 8'b0011_0000 & {4{ipbe[1:0]}};
                default : fbyte_en = 8'b1100_0000 & {4{ipbe[1:0]}};
              endcase

              case(fifo_low_addr)
                2'b00   : fifo_rdata = biu_fifo_rdata_tmp[15:0];
                2'b01   : fifo_rdata = biu_fifo_rdata_tmp[31:16];
                2'b10   : fifo_rdata = biu_fifo_rdata_tmp[47:32];
                default : fifo_rdata = biu_fifo_rdata_tmp[63:48];
              endcase

              f_wdata = {4{pwdata[`H_DATA_WIDTH-1:0]}};
            end
          else if(`H_DATA_WIDTH == 32)
            begin
              case(fifo_low_addr[0])
                1'b0    : fbyte_en = 8'b0000_1111 & {2{ipbe[3:0]}};
                default : fbyte_en = 8'b1111_0000 & {2{ipbe[3:0]}};
              endcase

              case(fifo_low_addr[0])
                1'b0    : fifo_rdata = biu_fifo_rdata_tmp[31:0];
                default : fifo_rdata = biu_fifo_rdata_tmp[63:32];
              endcase

              f_wdata = {2{pwdata[`H_DATA_WIDTH-1:0]}};
            end
          else // (H_DATA_WIDTH == 64)
            begin
              fbyte_en   = ipbe;
              fifo_rdata = biu_fifo_rdata_tmp;
              f_wdata    = pwdata[`H_DATA_WIDTH-1:0];
            end
        end
      else // F_DATA_WIDTH==32
        begin
          if(`H_DATA_WIDTH == 16)
            begin
              case(fifo_low_addr[0])
                1'b0    : fbyte_en = {4'b0,{4'b0011 & {2{ipbe[1:0]}}}};
                default : fbyte_en = {4'b0,{4'b1100 & {2{ipbe[1:0]}}}};
              endcase

              case(fifo_low_addr[0])
                1'b0    : fifo_rdata = biu_fifo_rdata_tmp[15:0];
                default : fifo_rdata = biu_fifo_rdata_tmp[31:16];
              endcase

              f_wdata = {32'b0,{2{pwdata[15:0]}}};
            end
          else if(`H_DATA_WIDTH == 32)
            begin
              fbyte_en   = {4'b0,ipbe[3:0]};
              f_wdata    = {32'b0,pwdata[`H_DATA_WIDTH-1:0]};
              fifo_rdata = biu_fifo_rdata_tmp[31:0];
            end
          else // (H_DATA_WIDTH == 64)
            begin
              fbyte_en   = {4'b0,ipbe[3:0]};
              f_wdata    = pwdata[`H_DATA_WIDTH-1:0];
              fifo_rdata = biu_fifo_rdata_tmp[31:0];
            end
        end
    end


  // Temporary buffers to collect partial write-data
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
         host_tmp_data <= 56'h0;
      else
        begin
          if(fifo_write_en)
            begin 
              if(fbyte_en[0])
                host_tmp_data[7:0]   <= f_wdata[7:0];
              if(fbyte_en[1])
                host_tmp_data[15:8]  <= f_wdata[15:8];
              if(fbyte_en[2])
                host_tmp_data[23:16] <= f_wdata[23:16];
              if(fbyte_en[3])
                host_tmp_data[31:24] <= f_wdata[31:24];
              if(fbyte_en[4])
                host_tmp_data[39:32] <= f_wdata[39:32];
              if(fbyte_en[5])
                host_tmp_data[47:40] <= f_wdata[47:40];
              if(fbyte_en[6])
                host_tmp_data[55:48] <= f_wdata[55:48];
            end
        end
    end

  // FIFO Write data from Host
  assign host_fifo_wdata_64 = {f_wdata[63:56],
                           (fbyte_en[6]? f_wdata[55:48] : host_tmp_data[55:48]),
                           (fbyte_en[5]? f_wdata[47:40] : host_tmp_data[47:40]),
                           (fbyte_en[4]? f_wdata[39:32] : host_tmp_data[39:32]),
                           (fbyte_en[3]? f_wdata[31:24] : host_tmp_data[31:24]),
                           (fbyte_en[2]? f_wdata[23:16] : host_tmp_data[23:16]),
                           (fbyte_en[1]? f_wdata[15:8]  : host_tmp_data[15:8]),
                           (fbyte_en[0]? f_wdata[7:0]   : host_tmp_data[7:0]) };

  // FIFO Write Data from Host
  assign host_fifo_wdata_32 = {f_wdata[31:24],
                           (fbyte_en[2]? f_wdata[23:16] : host_tmp_data[23:16]),
                           (fbyte_en[1]? f_wdata[15:8]  : host_tmp_data[15:8]),
                           (fbyte_en[0]? f_wdata[7:0]   : host_tmp_data[7:0]) };

  assign host_fifo_wdata_tmp = (`F_DATA_WIDTH == 64)? host_fifo_wdata_64 :
                                                      host_fifo_wdata_32;

  assign host_fifo_wdata = host_fifo_wdata_tmp[`F_DATA_WIDTH-1:0];



  // General purpose DMA FIFO interface logic. Write/Read Data steering
  // and temporay buffer logic to support F_DATA_WIDTH != GE_DMA_DMA_WIDTH.
  // The only combination is GE_DMA_DATA_WIDTH = 16 and F_DATA_WIDTH = 32 

 `ifdef GENERIC_DMA

      assign ge_dma_fifo_wdata = (`GE_DMA_DATA_WIDTH == 16)?
                                    {{(`F_DATA_WIDTH - 32){1'b0}} , ge_dma_rdata[15:0] , ge_dma_tmp_data} :
                                   { {(`F_DATA_WIDTH - `GE_DMA_DATA_WIDTH){1'b0}} , ge_dma_rdata};
      assign ge_dma_wdata_16  = (ge_dma_addr0 == 1'b0)? biu_fifo_rdata[15:0] :
                                                       biu_fifo_rdata[31:16];

      assign ge_dma_wdata_tmp = (`GE_DMA_DATA_WIDTH != 16)?  biu_fifo_rdata : 
                                                             ge_dma_wdata_16;

      assign ge_dma_wdata     = ge_dma_wdata_tmp[`GE_DMA_DATA_WIDTH-1:0]; 
  
  `else
      assign ge_dma_fifo_wdata ={(`F_DATA_WIDTH){1'b0}};
      assign ge_dma_wdata_16  =0;
      assign ge_dma_wdata_tmp ={(`F_DATA_WIDTH){1'b0}};
      assign ge_dma_wdata ={(`GE_DMA_DATA_WIDTH){1'b0}};    

 `endif



  // Store the low-address access data in to a temporary buffer
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
         ge_dma_tmp_data <= 16'h0;
      else
        begin
          if(ge_dma_ack & ge_dma_req)
            ge_dma_tmp_data  <= ge_dma_rdata[15:0];
        end
    end


  // Register Bank Unit
  DWC_mobile_storage_regb
   U_DWC_mobile_storage_regb
    (
     // Outputs
     .regb_rdata                        (regb_rdata[`H_DATA_WIDTH-1:0]),
     .interrupt                         (interrupt),
     .raw_ints                          (raw_ints[31:0]),
     .int_mask_n                        (int_mask_n[31:0]),
     .int_enable                        (int_enable),
     .debug_registers                   (debug_registers),
     .debounce_count                    (debounce_count[23:0]),
     .gp_out                            (gp_out[15:0]),
     .card_power_en                     (card_power_en[`NUM_CARDS-1:0]),
     .card_volt_a                       (card_volt_a[3:0]),
     .card_volt_b                       (card_volt_b[3:0]),
     .b2c_od_pullup_en_n                (b2c_od_pullup_en_n),
     .less_equal_thresh                 (biu_less_equal_thresh[`F_COUNT_WIDTH-1:0]),
     .greater_than_thresh               (biu_greater_than_thresh),
     .dw_dma_trans_size                 (dw_dma_trans_size[2:0]),
     .clear_pointers                    (b2c_clear_pointers),
     .clr_clk1_pointers                 (clr_clk1_pointers),
     .dma_reset                         (dma_reset),
     .ciu_reset                         (ciu_reset),
     .dma_enabled                       (dma_enabled),
     .trans_fifo_cnt                    (trans_fifo_cnt[31:0]),
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
   //SD_3.0 start
   .biu_volt_reg                      (biu_volt_reg[`NUM_CARD_BUS-1:0]),
   .b2c_ddr_reg                       (b2c_ddr_reg[`NUM_CARD_BUS-1:0]),
   //SD_3.0 ends
                 //eMMC 4.5 start
                 .ext_clk_mux_ctrl                  (ext_clk_mux_ctrl),
                 .clk_drv_phase_ctrl                (clk_drv_phase_ctrl),
                 .clk_smpl_phase_ctrl               (clk_smpl_phase_ctrl),
   .biu_volt_reg_1_2                  (biu_volt_reg_1_2[`NUM_CARD_BUS-1:0]),
                 .b2c_half_start_bit                (b2c_half_start_bit),
                 .b2c_enable_shift                 (b2c_enable_shift),
                 //eMMC 4.5 ends
   //MMC4_4 start
     .rst_n                             (rst_n[`NUM_CARD_BUS-1:0]),
   .card_rd_threshold_en              (card_rd_threshold_en),
   .busy_clr_int_mask                 (busy_clr_int_mask),
   .card_rd_threshold_size            (card_rd_threshold_size),
   //MMC4_4 ends
   //SDIO 3.0 starts
   .back_end_power                    (back_end_power[`NUM_CARD_BUS-1:0]),
   //SDIO 3.0 ends


     `ifdef INTERNAL_DMAC_YES

     .use_internal_dmac                 (use_internal_dmac),
     .fifo_ptr_rst                      (fifo_ptr_rst),

     `endif


     // Inputs
     .clk                               (clk),
     .reset_n                           (reset_n),
     .byte_en                           (byte_en[7:0]),
     .regb_wdata                        (regb_wdata[63:0]),
     .paddr                             (paddr[`H_ADDR_WIDTH-1:0]),
     .regb_write_en                     (regb_write_en),
     .regb_read_en                      (regb_read_en),
     .regb_read_en_dly                  (regb_read_en_dly),
     .card_detect_int                   (card_detect_int),
     .card_detect_biu                   (card_detect_biu[`NUM_CARDS-1:0]),
     .card_write_prt_biu                (card_write_prt_biu[`NUM_CARDS-1:0]),
     .gp_in_biu                         (gp_in_biu[7:0]),
     .full                              (biu_full),
     .empty                             (biu_empty),
     .almost_full                       (biu_almost_full),
     .almost_empty                      (biu_almost_empty),
     .less_or_equal                     (biu_less_or_equal),
     .greater_than                      (biu_greater_than),
     .count                             (biu_count[`F_COUNT_WIDTH-1:0]),
     .fifo_over                         (fifo_over),
     .fifo_under                        (fifo_under),
     .dma_req                           (dma_req),
     .dma_ack                           (dma_ack),
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
     .data_trans_done                   (data_trans_done),
     .data_timeout                      (data_timeout),
     .resp_timeout                      (resp_timeout),
     .data_crc_err                      (data_crc_err),
     .resp_crc_err                      (resp_crc_err),
     .host_2_fifo_inc                   (host_2_fifo_inc),
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
     .clr_send_ccsd                     (clr_send_ccsd),
     .scan_mode                         (scan_mode));

  // Card Detect Interrupt 
  DWC_mobile_storage_cdet
   U_DWC_mobile_storage_cdet
    (/*AUTOINST*/
     // Outputs
     .card_detect_int                   (card_detect_int),
     // Inputs
     .clk                               (clk),
     .reset_n                           (reset_n),
     .debounce_count                    (debounce_count[23:0]),
     .card_detect_biu                   (card_detect_biu[`NUM_CARDS-1:0]));


  // DMA Control Unit
  DWC_mobile_storage_dma
   U_DWC_mobile_storage_dma
    (
     // Outputs
     .dw_dma_req                        (dw_dma_req),
     .dw_dma_single                     (dw_dma_single),
     .dw_dma_write                      (dw_dma_write),
     .dw_dma_card_num                   (dw_dma_card_num[4:0]),
     .ge_dma_req                        (ge_dma_req),
     .ge_dma_done                       (ge_dma_done),
     .ge_dma_write                      (ge_dma_write),
     .ge_dma_card_num                   (ge_dma_card_num[4:0]),
     .ge_dma_push                       (ge_dma_push),
     .ge_dma_pop                        (ge_dma_pop),
     .ge_dma_addr0                      (ge_dma_addr0),
     .data_trans_done                   (data_trans_done),
     // Inputs
     .clk                               (clk),
     .reset_n                           (reset_n),
     .ciu_reset                         (ciu_reset),
     .dma_reset                         (dma_reset),
     .dw_dma_ack                        (dw_dma_ack),
     .ge_dma_ack                        (ge_dma_ack),
     .dma_enabled                       (dma_enabled),
     .greater_than                      (biu_greater_than),
     .less_or_equal                     (biu_less_or_equal),
     .almost_empty                      (biu_almost_empty),
     .almost_full                       (biu_almost_full),
     .empty                             (biu_empty),
     .full                              (biu_full),
     .cmd_taken                         (cmd_taken),
     .b2c_cmd_control                   (b2c_cmd_control[27:0]),
     .count                             (biu_count[`F_COUNT_WIDTH-1:0]),
     .trans_fifo_cnt                    (trans_fifo_cnt[31:0]),
     .b2c_byte_count                    (b2c_byte_count[31:0]),
     .ciu_data_trans_done               (ciu_data_trans_done),
     .resp_timeout                      (resp_timeout),

  `ifdef INTERNAL_DMAC_YES

     .use_internal_dmac                 (use_internal_dmac),

     `endif

     .dw_dma_trans_size                 (dw_dma_trans_size[2:0]));

endmodule // 

 
