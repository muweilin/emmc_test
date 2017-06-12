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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_ciu.v#70 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_ciu.v
// Description : DWC_mobile_storage Card Interface Unit
//               Card interface unit top module
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_ciu(
   /*AUTOARG*/
  // Outputs
  cdata_out, cdata_out_en, ccmd_out, ccmd_out_en, cclk_out, c2b_cmd_taken,
  c2b_response_valid, c2b_response_err, c2b_response_done,
  c2b_data_trans_done, c2b_data_timeout, c2b_resp_timeout, c2b_data_crc_err,
  c2b_resp_crc_err, c2b_ciu_fifo_pop, c2b_ciu_fifo_push, c2b_fifo_wdata,
  c2b_response_data, c2b_response_addr, c2b_ciu_status,
  c2b_sdio_interrupt, c2b_trans_bytes, c2b_trans_bytes_bin,
  c2b_rx_stbit_err, c2b_auto_cmd_done, c2b_data_strv_err,
  c2b_rxend_nocrc_err, c2b_cmd_fsm_state_3, c2b_cmd_fsm_state_2,
  c2b_cmd_fsm_state_1, c2b_cmd_fsm_state_0, c2b_clr_send_ccsd,
  c2b_boot_ack_tout,c2b_boot_data_tout,c2b_end_boot,
 //SD_3.0 start
  c2b_volt_switch_int,
 //SD_3.0 end
       //eMMC 4.5 start
       //eMMC 4.5 end
  // Inputs
  cclk_in, cclk_in_drv, cclk_in_sample, creset_n, cdata_in, ccmd_in,
  cmd_start, read_wait, b2c_cmd_control, creset_n_sample, creset_n_drv,
 //SD_3.0 start
 b2c_ddr_reg,
 //SD_3.0 end
 //MMC4_4 start
  b2c_card_rd_threshold_en,
  busy_clr_int_mask, //Synchronizer not required as this is one time config signal
  //MMC4_4 ends
 //SDIO 3.0 start
 card_int_n,
 //SDIo 3.0 ends
        //eMMC 4.5 start
        half_start_bit,
        enable_shift,
        //eMMC 4.5 ends
 enable_boot,alternative_boot_mode,
  b2c_cmd_argument, b2c_cclk_enable,
  b2c_cclk_low_power, b2c_card_width, b2c_card_type, fifo_full, fifo_empty,
  fifo_almost_full, fifo_almost_empty, b2c_fifo_rdata, b2c_clk_divider,
  b2c_clk_source, b2c_block_size, b2c_byte_count, b2c_data_tmout_cnt,
  b2c_resp_tmout_cnt, send_irq_response, abort_read_data, ceata_intr_status,
  send_ccsd, send_auto_stop_ccsd, sync_od_pullup_en_n, atleast_empty,cp_card_num,scan_mode
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Card Clock and Reset
  input                        cclk_in;         // Card Clock
  input                        cclk_in_drv;     // Delayed Card Clock
  input                        cclk_in_sample;  // Delayed Card Clock
  input                        creset_n;        // Card Reset - Active Low
  input                        creset_n_sample; // Sample clock reset
  input                        creset_n_drv;    // Drive clock reset

  //  Card Interface
  input  [`NUM_CARD_BUS*8-1:0] cdata_in;        // Card Data Input
  input    [`NUM_CARD_BUS-1:0] ccmd_in;         // Card Cmd Input
  output [`NUM_CARD_BUS*8-1:0] cdata_out;       // Card Data Output
  output [`NUM_CARD_BUS*8-1:0] cdata_out_en;    // Card Data Output
  output   [`NUM_CARD_BUS-1:0] ccmd_out;        // Card Cmd Output
  output   [`NUM_CARD_BUS-1:0] ccmd_out_en;     // Card Cmd Output Enable
  output   [`NUM_CARD_BUS-1:0] cclk_out;        // Card Clock Out
   // BIU 2 CIU
  input                        cmd_start;       // command start/valid
  input                        read_wait;       // read wait
 //SD_3.0 start
  input                 [29:0] b2c_cmd_control; // command control params
 input    [`NUM_CARD_BUS-1:0] b2c_ddr_reg;
 //SD_3.0 end
 //MMC4_4 start
 input                        b2c_card_rd_threshold_en;
 input                        busy_clr_int_mask;
  //MMC4_4 ends
  //SDIO 3.0 start
  input    [`NUM_CARD_BUS-1:0] card_int_n;      // Card INT# line. Active low signal.
 //SDIO 3.0 ends
  input                      half_start_bit;
  input    [((`NUM_CARD_BUS*2)-1):0]enable_shift; // card clock enable
  input                        enable_boot;     
  input                        alternative_boot_mode;
  input                 [31:0] b2c_cmd_argument;// command arguments
  input    [`NUM_CARD_BUS-1:0] b2c_cclk_enable; // card clock enable
  input    [`NUM_CARD_BUS-1:0] b2c_cclk_low_power; // card low power enable
  input  [`NUM_CARD_BUS*2-1:0] b2c_card_width;  // Card bus width
  input    [`NUM_CARD_BUS-1:0] b2c_card_type;   // card type
  input                        fifo_full;       // FIFO full
  input                        fifo_empty;      // FIFO empty
  input                        fifo_almost_full;// FIFO almost full
  input                        fifo_almost_empty;//FIFO almost empty

  input    [`F_DATA_WIDTH-1:0] b2c_fifo_rdata;     // FIFO read data
  input                 [31:0] b2c_clk_divider;     // Clock divider value
  input                 [31:0] b2c_clk_source;      // Card clock source
  input                 [15:0] b2c_block_size;      // Data block size
  input                 [31:0] b2c_byte_count;      // Data byte count
  input                 [23:0] b2c_data_tmout_cnt;  // Read Data timeout
  input                  [7:0] b2c_resp_tmout_cnt;  // Command response timeout
  input                        send_irq_response;   // Host send IRQ response
  input                        abort_read_data;     // abort read data
  input                        sync_od_pullup_en_n; // Open-drain pullup enable
  input                        scan_mode;           // Scan mode
  input                        ceata_intr_status;   // CE-ATA device interrupt status
  input                        send_ccsd;           // Send CCSD to CE-ATA device.
  input                        send_auto_stop_ccsd; // Send internal STOP Coomand after the CCSD.
 input                        atleast_empty;



  // CIU 2 BIU
  output                       c2b_cmd_taken;        // command taken
  output                       c2b_response_valid;   // response valid
  output                       c2b_response_err;     // response error
  output                       c2b_response_done;    // cmd/response done
  output                       c2b_data_trans_done;  // data transfer done
  output                       c2b_data_timeout;     // Read data timeout error
  output                       c2b_resp_timeout;     // response timeout error
  output                       c2b_data_crc_err;     // data crc error
  output                       c2b_resp_crc_err;     // response crc error
  output                       c2b_ciu_fifo_pop;     // pop FIFO
  output                       c2b_ciu_fifo_push;    // push FIFO
  output   [`F_DATA_WIDTH-1:0] c2b_fifo_wdata;       // FIFO write data
  output                [37:0] c2b_response_data;    // response data
  output                 [1:0] c2b_response_addr;    // response address
  output                 [3:0] c2b_ciu_status;       // CIU Block status
  output   [`NUM_CARD_BUS-1:0] c2b_sdio_interrupt;   // SDIO interrupts
  output                [31:0] c2b_trans_bytes;      // transfer byte count-gray
  output                [31:0] c2b_trans_bytes_bin;  // transfer byte count-bina
  output                       c2b_rx_stbit_err;     // read data start bit err
  output                       c2b_auto_cmd_done;    // auto stop command done
  output                       c2b_data_strv_err;    // data starvation error
  output                       c2b_rxend_nocrc_err;  // rx end bit/no crc stbit
  output                       c2b_cmd_fsm_state_3;  // Command FSM state
  output                       c2b_cmd_fsm_state_2;  // Command FSM state
  output                       c2b_cmd_fsm_state_1;  // Command FSM state
  output                       c2b_cmd_fsm_state_0;  // Command FSM state
  output                       c2b_clr_send_ccsd;    // Clear the send_ccsd bit 
  output                       c2b_boot_ack_tout;    // Boot Ack timeout
  output                       c2b_boot_data_tout;   // Boot data timeout 
  output                       c2b_end_boot;
  wire    [`NUM_CARD_BUS-1:0] stop_clk_neg_out;     // Signal to be used in muxdemux module for anding with toggle 

 //SD_3.0 start
 output                       c2b_volt_switch_int; // Interrupt generated during the voltage switching. 
  //SD_3.0 end
  output [3:0]            cp_card_num;  
  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Wires
  wire                  [63:0] fifo_rdata;        // FIFO read data
  wire                         rxend_txnocrc_err; // read endbit/ write no crc
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire                  auto_cmd_done;          // From U_DWC_mobile_storage_cmdpath
  wire                  auto_stop_cmd;          // From U_DWC_mobile_storage_cmdpath
  wire                  auto_stop_en;           // From U_DWC_mobile_storage_datapath
  wire                  cclk_in_en;             // From U_DWC_mobile_storage_clkcntl
 //SD_3.0 start
 wire                  cclk_in_en_ddr;         // From U_DWC_mobile_storage_clkcntl
 wire                  cclk_in_en_8_ddr; 
 wire                  divided_clk;            // From U_DWC_mobile_storage_clkcntl
 
 //SD_3.0 end
  wire [`NUM_CARD_BUS*8-1:0]cdata_in_r;         // From U_DWC_mobile_storage_muxdemux
 //SDIO start
  wire  [`NUM_CARD_BUS-1:0] card_int_n_dsync;    // From U_DWC_mobile_storage_muxdemux
 wire  [`NUM_CARD_BUS-1:0] dat_int_n_dsync;     // From U_DWC_mobile_storage_muxdemux
 wire                   busy_clear_int ;         //From U_DWC_mobile_storage_muxdemux

 //SDIO ends

  wire [31:0]           clk_divider;            // From U_DWC_mobile_storage_cmdpath
  wire [15:0]           clk_enable;             // From U_DWC_mobile_storage_cmdpath
  wire [15:0]           clk_low_power;          // From U_DWC_mobile_storage_cmdpath
 //SD_3.0 start
  wire [15:0]           cclk_sample_en_ddr;     // From U_DWC_mobile_storage_clkcntl
 wire                  volt_switch_int;        // From U_DWC_mobile_storage_cmdpath
 //SD_3.0 end


  wire [31:0]           clk_source;             // From U_DWC_mobile_storage_cmdpath
  wire [3:0]            cmd_fsm_state;          // From U_DWC_mobile_storage_cmdpath
  wire                  cmd_taken;              // From U_DWC_mobile_storage_cmdpath
  wire [3:0]            cp_card_num;            // From U_DWC_mobile_storage_cmdpath
  wire                  cp_ccmd_in;             // From U_DWC_mobile_storage_muxdemux
  wire                  cp_ccmd_out;            // From U_DWC_mobile_storage_cmdpath
  wire                  cp_ccmd_out_en;         // From U_DWC_mobile_storage_cmdpath
  wire                  cp_cmd_end_bit;         // From U_DWC_mobile_storage_cmdpath
  wire                  cp_cmd_idle;            // From U_DWC_mobile_storage_cmdpath
  wire                  cp_cmd_idle_lp;         // From U_DWC_mobile_storage_cmdpath
  wire                  cp_cmd_crc7_end;        // From U_DWC_mobile_storage_cmdpath
  wire                  cp_data_cmd;            // From U_DWC_mobile_storage_cmdpath
  wire                  cp_cmd_suspend;         // From U_DWC_mobile_storage_cmdpath
  wire                  cp_load_data_par;       // From U_DWC_mobile_storage_cmdpath
  wire                  cp_resp_end_bit;        // From U_DWC_mobile_storage_cmdpath
  wire                  cp_stop_abort_cmd;      // From U_DWC_mobile_storage_cmdpath
  wire                  cp_stop_cmd_loaded;     // From U_DWC_mobile_storage_cmdpath
  wire                  ccs_expected;           // From U_DWC_mobile_storage_cmdpath
  wire                  cmd_compl_signal;       // From U_DWC_mobile_storage_cmdpath
  wire                  read_ceata_device;      // From U_DWC_mobile_storage_cmdpath
  wire                  data_crc_err;           // From U_DWC_mobile_storage_datapath
  wire                  data_strv_err;          // From U_DWC_mobile_storage_clkcntl
  wire [23:0]           data_timeout_cnt;       // From U_DWC_mobile_storage_datapath
  wire                  data_trans_done;        // From U_DWC_mobile_storage_datapath
  wire [1:0]            dp_card_wide_bus;       // From U_DWC_mobile_storage_datapath
  wire [7:0]            dp_cdata_in;            // From U_DWC_mobile_storage_muxdemux
 //SD_3.0 start
  wire [7:0]            de_interleave;          // From U_DWC_mobile_storage_muxdemux 
 // SD_3.0 end
  wire [7:0]            dp_cdata_out;           // From U_DWC_mobile_storage_datapath
  wire [7:0]            dp_cdata_out_en;        // From U_DWC_mobile_storage_datapath
  wire                  dp_data_idle;           // From U_DWC_mobile_storage_datapath
  wire                  dp_load_stop_cmd_req;   // From U_DWC_mobile_storage_datapath
  wire                  dp_open_ended_xfer;     // From U_DWC_mobile_storage_datapath
  wire                  byte_countrem_zero;     // From U_DWC_mobile_storage_datapath
  wire                  dp_stop_clk;            // From U_DWC_mobile_storage_datapath
  wire                  read_write_xfer;        // From U_DWC_mobile_storage_datapath
  wire                  abort_read_data_r;      // From U_DWC_mobile_storage_datapath
  wire                  suspend_data_cmd;       // From U_DWC_mobile_storage_datapath
  wire                  data_trans_cmd;         // From U_DWC_mobile_storage_datapath
  wire                  resp_crc_err;           // From U_DWC_mobile_storage_cmdpath
  wire                  resp_timeout;           // From U_DWC_mobile_storage_cmdpath
  wire                  response_done;          // From U_DWC_mobile_storage_cmdpath
  wire                  response_err;           // From U_DWC_mobile_storage_cmdpath
  wire                  response_valid;         // From U_DWC_mobile_storage_cmdpath
  wire                  clr_send_ccsd;          // From U_DWC_mobile_storage_cmdpath
  wire                  rx_dat0_busy;           // From U_DWC_mobile_storage_datapath
  wire                  rx_data_done;           // From U_DWC_mobile_storage_datapath
  wire                  rx_data_end_bit;        // From U_DWC_mobile_storage_datapath
  wire                  rx_data_endbit_err;     // From U_DWC_mobile_storage_datapath
  wire                  rx_data_timeout;        // From U_DWC_mobile_storage_datapath
 wire                  rx_data_timeout_internal;//From U_DWC_mobile_storage_datapath
  wire                  rx_stbit_err;           // From U_DWC_mobile_storage_datapath
  wire                  safe_clk_change;        // From U_DWC_mobile_storage_clkcntl
  wire [`NUM_CARD_BUS-1:0] sdio_interrupt;      // From U_DWC_mobile_storage_intrcntl
  wire                  transfer_mode;          // From U_DWC_mobile_storage_datapath
  wire                  tx_crcstbit_err;        // From U_DWC_mobile_storage_datapath
  wire                  tx_dat0_busy;           // From U_DWC_mobile_storage_datapath
  wire                  tx_data_done;           // From U_DWC_mobile_storage_datapath
  wire                  tx_data_end_bit;        // From U_DWC_mobile_storage_datapath
 wire                  boot_ack_timeout;       // From U_DWC_mobile_storage_datapath
 wire                  boot_data_timeout;      // From U_DWC_mobile_storage_datapath
 //SD_3.0 start
 wire                  ddr_rx_states;          // From U_DWC_mobile_storage_datapath
 wire                  ddr_tx_states;          // From U_DWC_mobile_storage_datapath
 wire                  start_rx_data;
 
  wire                  stop_clk_in_en;          // From U_DWC_mobile_storage_clkcntl
  wire                  stop_clk_ddr_8;          // From U_DWC_mobile_storage_clkcntl
  wire                  no_clock_stop_ddr_8;     // From U_DWC_mobile_storage_clkcntl
 //SD_3.0 end
  // End of automatics

  reg             [3:0] c2b_ciu_status;         // CIU Block status

  reg                   card_rd_threshold_en_r; // cclk_in registered card_rd_threshold_en bit qualified with CMD bit[31]
  wire                  use_hold_reg;           // Cclk_in registered b2c_cmd_control[29]
  reg                   use_hold_reg_tmp;           //  A temp signal to be bypassed in scan mode
  reg                   update_clk_only;        // Cclk_in registered b2c_cmd_control[21]
  reg                   wait_prvdatacmp;        // Cclk_in registered b2c_cmd_control[13]
  reg                   data_expected_r;        // CClk_in registered b2c_cmd_control[9]
  reg                   read_or_write_cmd_r;      // CClk_in registered b2c_cmd_control[10]
  reg                   cmd_start_del1;         // 1 CClk_in delayed cmd_start signal
  reg                   cmd_start_del2;         // 2 CClk_in delayed cmd_start signal

  wire                  detect_new_cmd;         // cmd_start is a toggle bit, detect 
                                                // the toggle to register the b2c_cmd_control

 //SD_3.0 start
  wire   [`NUM_CARD_BUS-1:0] cclk_out;        // Card Clock Out
  wire    [`NUM_CARD_BUS-1:0] toggle;
  reg    [`NUM_CARD_BUS-1:0] toggle1;
  reg    [`NUM_CARD_BUS-1:0] toggle2;
  wire   [`NUM_CARD_BUS-1:0] cclk_out_int;

 //SD_3.0 end
  wire  exp_boot_ack;                         
  wire  exp_boot_ack_pulse;                  
  wire  exp_boot_data;                          
  wire  exp_boot_data_pulse;                
  wire  end_boot;                              
  wire  end_boot_pulse;                         

  wire boot_ack_error;         
  wire rx_end_bit;             
  wire bar_intr;               
  wire new_cmd_load;
 //SD_3.0 start
  wire ddr;
  //MMC_4_4 start
 wire ddr_8;
 wire ddr_4_mode;
  wire ddr_8_mode;
  wire ddr_8_rx_states;
  wire ddr_8_tx_states;
  wire [15:0] cclk_sample_en_temp;
  wire [15:0] cclk_sample_en_data;
  wire [15:0] cclk_sample_en_cmd;
  wire start_bit_delayed;
  reg rx_stbit_err_busy_clear_int_r;
  //MMC_4_4 end 
 integer                   i,j;
 //SD_3.0 end

 //SD_3.0 start
 //Generating DDR signal.This is the generated only 
 //when the RX and TX state machines are in the BLKDATA state 
 //or in the CRC16 state.

  //MMC4_4 Start
  //generating the ddr signal only for 4 bit mode
  assign ddr = (b2c_ddr_reg[cp_card_num] && (ddr_rx_states | ddr_tx_states)) && 
               (!b2c_card_type[cp_card_num] &&  b2c_card_width[cp_card_num]);

  assign ddr_8 = (b2c_ddr_reg[cp_card_num] && (ddr_8_rx_states | ddr_8_tx_states)) &&
                 (b2c_card_type[cp_card_num]);

  assign ddr_4_mode = (b2c_ddr_reg[cp_card_num] & !b2c_card_type[cp_card_num] &&  b2c_card_width[cp_card_num]);
  assign ddr_8_mode = (b2c_ddr_reg[cp_card_num] & b2c_card_type[cp_card_num]);

  //cclk_in_en_8_ddr is the enable used to sample at double the cclk_out speeed.
  assign cclk_in_en_8_ddr = ddr_8 ? (cclk_in_en_ddr | cclk_in_en ) : cclk_in_en;
  // to support min-max and to avoid the glitch when pos and neg enables switch cclk_in_en_8_ddr is tied to zero
  // ddr_8 signal already takes care of appropriate states etc. So having enable always '1' should not be an issue.
  //assign cclk_in_en_8_ddr = ddr_8 ? 1'b1 : cclk_in_en;

  //cclk_sample_en_data & cclk_in_en_8_ddr are same, but generated separately
  //Note the cclk_sample_en_temp and cclk_in_en are same in Non 8-bit DDR mode 
  assign cclk_sample_en_data = ddr_8 ? (cclk_sample_en_ddr | cclk_sample_en_temp) :
                                        cclk_sample_en_temp;  
  assign cclk_sample_en_cmd = cclk_sample_en_temp;

  //Note the  cclk_sample_en_data is 16 bit wide and the cclk_in_en & cclk_in_en_ddr 
  //are 1 bit wide.
  //MMC4_4 end

////////////////////////////////////////////////////////////////////
// KAM ADD START
genvar gen_index;
 generate 
    for (gen_index=0 ; gen_index<= (`NUM_CARD_BUS-1) ; gen_index=gen_index+1)
      begin:toggle_gen
   
   always@(posedge cclk_out[gen_index] or negedge creset_n)
     begin
       if (~creset_n) 
                  toggle1[gen_index] <= 1'b0; 
             else 
           toggle1[gen_index]  <= ~toggle1[gen_index];
     end   

          //Scan mux to be implemented for scanning negative edge flop in scan mode.
          `ifdef IMPLEMENT_SCAN_MUX   
                 assign cclk_out_int[gen_index] = scan_mode? (!cclk_out[gen_index]):cclk_out[gen_index];
           `else
                  assign cclk_out_int[gen_index] = cclk_out[gen_index];
           `endif 

          always@(negedge cclk_out_int[gen_index] or negedge creset_n)
     begin
       if (~creset_n) 
                    toggle2[gen_index] <= 1'b0; 
       else 
             toggle2[gen_index]  <= ~toggle2[gen_index];
     end 
      end
endgenerate
//Ex-ORing output of posedge and negedge flop to generate a signal same as clock
                    assign toggle = toggle1 ^ toggle2;
// KAM ADD END
/////////////////////////////////////////////////////////////////////////
// //SD_3.0 end

 
 //SD_3.0 end

  // register card data lines for checking busy
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        c2b_ciu_status <= 4'h0;
      end else begin
        c2b_ciu_status <= {(dp_data_idle? ~dp_cdata_in[0] :
                                          (tx_dat0_busy | rx_dat0_busy)),
                          ((`CARD_TYPE == 0) ? 1'b1 : dp_cdata_in[3]),
                          dp_data_idle, cp_cmd_idle};
      end
    end

  assign detect_new_cmd = cmd_start ^ cmd_start_del1;
  
  
  // Hold the BIU b2c_cmd_control bits with synchronized cmd_start signal
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
       cmd_start_del1            <= 1'b0;
       cmd_start_del2            <= 1'b0;
       update_clk_only           <= 1'b0;
       use_hold_reg_tmp          <= 1'b1;//Reset value of 1'b1 to match the reset value of the corresponding register bit CMD[29] in regb
       card_rd_threshold_en_r    <= 1'b0;
       wait_prvdatacmp           <= 1'b0;
       data_expected_r           <= 1'b0;
       read_or_write_cmd_r       <= 1'b0;
      end else begin
        cmd_start_del1 <= cmd_start;
        cmd_start_del2 <= cmd_start_del1;

        if (detect_new_cmd) begin
          use_hold_reg_tmp        <= b2c_cmd_control[29];
          update_clk_only         <= b2c_cmd_control[21];
          wait_prvdatacmp         <= b2c_cmd_control[13];
          data_expected_r         <= b2c_cmd_control[9];
          read_or_write_cmd_r     <= b2c_cmd_control[10];
          card_rd_threshold_en_r  <= b2c_card_rd_threshold_en;
 end
      end
    end
  
assign use_hold_reg = scan_mode ? 1'b0 : use_hold_reg_tmp; 

  assign fifo_rdata        = {{(64-`F_DATA_WIDTH){1'b0}},b2c_fifo_rdata[`F_DATA_WIDTH-1:0]};
  assign rxend_txnocrc_err = rx_data_endbit_err || tx_crcstbit_err;

  assign {c2b_cmd_fsm_state_3, c2b_cmd_fsm_state_2, 
         c2b_cmd_fsm_state_1, c2b_cmd_fsm_state_0}  = cmd_fsm_state;
 
 
  // command path module
  DWC_mobile_storage_cmdpath
   U_DWC_mobile_storage_cmdpath
    (/*AUTOINST*/
     // Outputs
     .response_valid                    (response_valid),
     .response_err                      (response_err),
     .response_done                     (response_done),
     .resp_timeout                      (resp_timeout),
     .resp_crc_err                      (resp_crc_err),
     .c2b_response_data                 (c2b_response_data[37:0]),
     .c2b_response_addr                 (c2b_response_addr[1:0]),
     .auto_cmd_done                     (auto_cmd_done),
     .cmd_taken                         (cmd_taken),
     .cp_card_num                       (cp_card_num[3:0]),
     .cp_cmd_idle                       (cp_cmd_idle),
     .cp_cmd_idle_lp                    (cp_cmd_idle_lp),
     .cmd_fsm_state                     (cmd_fsm_state[3:0]),
     .cp_ccmd_out                       (cp_ccmd_out),
     .cp_ccmd_out_en                    (cp_ccmd_out_en),
     .cp_cmd_end_bit                    (cp_cmd_end_bit),
     .cp_resp_end_bit                   (cp_resp_end_bit),
     .cp_stop_cmd_loaded                (cp_stop_cmd_loaded),
     .cp_load_data_par                  (cp_load_data_par),
     .cp_cmd_suspend                    (cp_cmd_suspend),
     .cp_stop_abort_cmd                 (cp_stop_abort_cmd),
     .auto_stop_cmd                     (auto_stop_cmd),
     .clk_enable                        (clk_enable[15:0]),
     .clk_low_power                     (clk_low_power[15:0]),
     .clk_divider                       (clk_divider[31:0]),
     .clk_source                        (clk_source[31:0]),
     .cp_cmd_crc7_end                   (cp_cmd_crc7_end),
     .cp_data_cmd                       (cp_data_cmd),
     .ccs_expected                      (ccs_expected),
     .cmd_compl_signal                  (cmd_compl_signal),
     .read_ceata_device                 (read_ceata_device),
     .clr_send_ccsd                     (clr_send_ccsd),
     .exp_boot_ack                      (exp_boot_ack),      
     .exp_boot_ack_pulse                (exp_boot_ack_pulse),
     .exp_boot_data                     (exp_boot_data),
     .exp_boot_data_pulse               (exp_boot_data_pulse),
     .end_boot                          (end_boot),
     .end_boot_pulse                    (end_boot_pulse),
     .new_cmd_load                      (new_cmd_load),
   //SD_3.0 start
     .volt_switch_int                   (volt_switch_int),
   //SD_3.0 end
     // Inputs
     .cclk_in                           (cclk_in),
     .cclk_in_en                        (cclk_in_en),
     .creset_n                          (creset_n),
     .cmd_start                         (cmd_start_del2),
   //SD_3.0 start
     .b2c_cmd_control                   (b2c_cmd_control[28:0]),
   .dp_cdata_in                       (dp_cdata_in[3:0]),
   //SD_3.0 end
     .boot_ack_err                      (boot_ack_error),
     .rx_byte_count_rem_zero            (byte_countrem_zero),
     .rx_end_bit                        (rx_end_bit),
     .bar_intr                          (bar_intr),
     .b2c_cmd_argument                  (b2c_cmd_argument[31:0]),
     .b2c_resp_tmout_cnt                (b2c_resp_tmout_cnt[7:0]),
     .send_irq_response                 (send_irq_response),
     .sync_od_pullup_en_n               (sync_od_pullup_en_n),
     .b2c_cclk_enable                   (b2c_cclk_enable[`NUM_CARD_BUS-1:0]),
     .b2c_cclk_low_power                (b2c_cclk_low_power[`NUM_CARD_BUS-1:0]),
     .b2c_clk_divider                   (b2c_clk_divider[31:0]),
     .b2c_clk_source                    (b2c_clk_source[31:0]),
     .cp_ccmd_in                        (cp_ccmd_in),
     .dp_load_stop_cmd_req              (dp_load_stop_cmd_req),
     .dp_data_idle                      (dp_data_idle),
     .dp_open_ended_xfer                (dp_open_ended_xfer),
     .safe_clk_change                   (safe_clk_change),
     .send_ccsd                         (send_ccsd),
     .send_auto_stop_ccsd               (send_auto_stop_ccsd),
     .update_clk_only                   (update_clk_only),
     .wait_prvdatacmp                   (wait_prvdatacmp));

  // data path block
  DWC_mobile_storage_datapath
   U_DWC_mobile_storage_datapath
    (/*AUTOINST*/
     // Outputs
     .data_trans_done                   (data_trans_done),
     .rx_data_timeout                   (rx_data_timeout),
   .rx_data_timeout_internal          (rx_data_timeout_internal),
     .data_crc_err                      (data_crc_err),
     .fifo_pop                          (c2b_ciu_fifo_pop),
     .fifo_push                         (c2b_ciu_fifo_push),
     .c2b_fifo_wdata                    (c2b_fifo_wdata[`F_DATA_WIDTH-1:0]),
     .rx_stbit_err                      (rx_stbit_err),
     .c2b_trans_bytes                   (c2b_trans_bytes[31:0]),
     .c2b_trans_bytes_bin               (c2b_trans_bytes_bin[31:0]),
     .tx_crcstbit_err                   (tx_crcstbit_err),
     .rx_data_endbit_err                (rx_data_endbit_err),
     .dp_data_idle                      (dp_data_idle),
     .dp_cdata_out                      (dp_cdata_out),
     .dp_cdata_out_en                   (dp_cdata_out_en),
     .dp_load_stop_cmd_req              (dp_load_stop_cmd_req),
     .dp_open_ended_xfer                (dp_open_ended_xfer),
     .byte_countrem_zero                (byte_countrem_zero),
     .transfer_mode                     (transfer_mode),
     .data_timeout_cnt                  (data_timeout_cnt[23:0]),
     .dp_stop_clk                       (dp_stop_clk),
     .tx_data_done                      (tx_data_done),
     .rx_data_done                      (rx_data_done),
     .rx_data_end_bit                   (rx_data_end_bit),
     .tx_data_end_bit                   (tx_data_end_bit),
     .dp_card_wide_bus                  (dp_card_wide_bus),
     .read_write_xfer                   (read_write_xfer),
     .tx_dat0_busy                      (tx_dat0_busy),
     .rx_dat0_busy                      (rx_dat0_busy),
     .auto_stop_en                      (auto_stop_en),
     .abort_read_data_r                 (abort_read_data_r),
     .suspend_data_cmd                  (suspend_data_cmd),
     .data_trans_cmd                    (data_trans_cmd),
     .boot_ack_error                    (boot_ack_error),      
     .rx_end_bit                        (rx_end_bit),
     .bar_intr                          (bar_intr),
     .boot_ack_timeout                  (boot_ack_timeout), 
     .boot_data_timeout                 (boot_data_timeout),
   //SD_3.0 start
   .ddr_rx_states                     (ddr_rx_states),
   //MMC4_4 start
   .ddr_8_rx_states                   (ddr_8_rx_states),
   .ddr_8_tx_states                   (ddr_8_tx_states),
     .no_clock_stop_ddr_8               (no_clock_stop_ddr_8),
   //MMC4_4 end
    .ddr_tx_states                     (ddr_tx_states),
   .start_rx_data                     (start_rx_data),
   //SD_3.0 end
     // Inputs
     .cclk_in                           (cclk_in),
     .cclk_in_en                        (cclk_in_en),
   //MMC4_4 start
     .cclk_in_en_8_ddr                  (cclk_in_en_8_ddr),
   .cp_card_num                       (cp_card_num[3:0]),
   //MMC4_4 end
     .creset_n                          (creset_n),
     .read_wait                         (read_wait),
     .b2c_card_width                    (b2c_card_width[`NUM_CARD_BUS*2-1:0]),
     .fifo_full                         (fifo_full),
     .fifo_empty                        (fifo_empty),
     .fifo_almost_full                  (fifo_almost_full),
     .fifo_almost_empty                 (fifo_almost_empty),
     .fifo_rdata                        (fifo_rdata),
     .b2c_block_size                    (b2c_block_size[15:0]),
     .b2c_byte_count                    (b2c_byte_count[31:0]),
     .b2c_data_tmout_cnt                (b2c_data_tmout_cnt[23:0]),
     .abort_read_data                   (abort_read_data),
   //SD_3.0 start
     .b2c_cmd_control                   (b2c_cmd_control[28:0]),
   .ddr                               (ddr),
   //MMC4_4 start
   .ddr_8                             (ddr_8),
   .ddr_4_mode                        (ddr_4_mode), 
     .ddr_8_mode                        (ddr_8_mode),
     .card_rd_threshold_en              (card_rd_threshold_en_r),
   //MMC4_4 end
   //SD_3.0 end
     .half_start_bit                    (half_start_bit),
     .exp_boot_ack                      (exp_boot_ack),        
     .exp_boot_ack_pulse                (exp_boot_ack_pulse),   
     .exp_boot_data                     (exp_boot_data),        
     .exp_boot_data_pulse               (exp_boot_data_pulse),  
     .end_boot                          (end_boot),            
     .end_boot_pulse                    (end_boot_pulse),       
     .new_cmd_loaded                    (new_cmd_load),
     .dp_cdata_in                       (dp_cdata_in),
   //SD_3.0 start
     .de_interleave                     (de_interleave),
   //SD_3.0 end
     .cp_cmd_end_bit                    (cp_cmd_end_bit),
     .cp_resp_end_bit                   (cp_resp_end_bit),
     .cp_cmd_suspend                    (cp_cmd_suspend),
     .resp_timeout                      (resp_timeout),
     .cp_load_data_par                  (cp_load_data_par),
     .cp_cmd_crc7_end                   (cp_cmd_crc7_end),
     .cp_stop_cmd_loaded                (cp_stop_cmd_loaded),
     .cp_stop_abort_cmd                 (cp_stop_abort_cmd),
     .ccs_expected                      (ccs_expected),
     .cmd_compl_signal                  (cmd_compl_signal),
     .read_ceata_device                 (read_ceata_device),
   //MMC4_4 start
   .toggle                            (toggle),
     .cclk_in_en_ddr                    (cclk_in_en_ddr),
     .stop_clk_ddr_8                    (stop_clk_ddr_8),
     .stop_clk_in_en                    (stop_clk_in_en),
   .atleast_empty                     (atleast_empty),
   //MMC4_4 end
     .data_expected_r                   (data_expected_r),
      .start_bit_delayed                 (start_bit_delayed));

  // Clock control block
  DWC_mobile_storage_clkcntl
   U_DWC_mobile_storage_clkcntl
    (/*AUTOINST*/
     // Outputs
     .cclk_in_en                        (cclk_in_en),
   //SD_3.0 start
     .cclk_in_en_ddr                    (cclk_in_en_ddr),
   .divided_clk                       (divided_clk),
   //SD_3.0 end
   //MMC4_4 start 
     .cclk_sample_en                    (cclk_sample_en_temp[15:0]),
   //MMC4_4 end
   //SD_3.0 start
     .cclk_sample_en_ddr                (cclk_sample_en_ddr[15:0]),
   //SD_3.0 end
     .safe_clk_change                   (safe_clk_change),
     .cclk_out                          (cclk_out[`NUM_CARD_BUS-1:0]),
     .data_strv_err                     (data_strv_err),
     .stop_clk_neg_out                  (stop_clk_neg_out),
     // Inputs
     .cclk_in                           (cclk_in),
     .creset_n                          (creset_n),
     .clk_enable                        (clk_enable[15:0]),
     .clk_low_power                     (clk_low_power[15:0]),
     .clk_divider                       (clk_divider[31:0]),
     .clk_source                        (clk_source[31:0]),
     .cp_card_num                       (cp_card_num[3:0]),
     .cp_cmd_idle_lp                    (cp_cmd_idle_lp),
     .dp_stop_clk                       (dp_stop_clk),
     .dp_data_idle                      (dp_data_idle),
     .cdata_in_r                        (cdata_in_r[`NUM_CARD_BUS*8-1:0]),
     .data_timeout_cnt                  (data_timeout_cnt[23:0]),
     .stop_clk_ddr_8                    (stop_clk_ddr_8),
     .stop_clk_in_en                    (stop_clk_in_en),
     .no_clock_stop_ddr_8               (no_clock_stop_ddr_8),
     .ddr_8_mode                        (ddr_8_mode),
     .scan_mode                         (scan_mode));

  // Interrupt control module
  DWC_mobile_storage_intrcntl
   U_DWC_mobile_storage_intrcntl
    (/*AUTOINST*/
     // Outputs
     .sdio_interrupt                    (sdio_interrupt[`NUM_CARD_BUS-1:0]),
     // Inputs
     .creset_n                          (creset_n),
     .cclk_in                           (cclk_in),
     .cclk_in_en                        (cclk_in_en),
     .cp_card_num                       (cp_card_num[3:0]),
     .cp_cmd_end_bit                    (cp_cmd_end_bit),
     .resp_timeout                      (resp_timeout),
     .auto_cmd_done                     (auto_cmd_done),
     .auto_stop_cmd                     (auto_stop_cmd),
     .auto_stop_en                      (auto_stop_en),
     .dp_card_wide_bus                  (dp_card_wide_bus),
     .rx_data_end_bit                   (rx_data_end_bit),
     .tx_data_end_bit                   (tx_data_end_bit),
     .tx_data_done                      (tx_data_done),
     .rx_data_done                      (rx_data_done),
     .cp_stop_abort_cmd                 (cp_stop_abort_cmd),
     .response_done                     (response_done),
     .dp_open_ended_xfer                (dp_open_ended_xfer),
     .byte_countrem_zero                (byte_countrem_zero),
     .abort_read_data_r                 (abort_read_data_r),
     .cclk_sample_en                    (cclk_sample_en_temp[15:0]),

     .suspend_data_cmd                  (suspend_data_cmd),
     .tx_crcstbit_err                   (tx_crcstbit_err),
     .rx_data_timeout                   (rx_data_timeout_internal),
     .data_trans_cmd                    (data_trans_cmd),
   //SDIO start
     .card_int_n_dsync                   (card_int_n_dsync[`NUM_CARD_BUS-1:0]),
   .dat_int_n_dsync                    (dat_int_n_dsync[`NUM_CARD_BUS-1:0]),
     //SDIO ends
     .cdata_in_r                        (cdata_in_r[`NUM_CARD_BUS*8-1:0]),
     .cp_data_cmd                       (cp_data_cmd),
     .dp_cdata_in                       (dp_cdata_in));

  // mux De-mux module
  DWC_mobile_storage_muxdemux
   U_DWC_mobile_storage_muxdemux
    (/*AUTOINST*/
     // Outputs
     .ccmd_out                          (ccmd_out[`NUM_CARD_BUS-1:0]),
     .ccmd_out_en                       (ccmd_out_en[`NUM_CARD_BUS-1:0]),
     .cdata_out                         (cdata_out[`NUM_CARD_BUS*8-1:0]),
     .cdata_out_en                      (cdata_out_en[`NUM_CARD_BUS*8-1:0]),
     .cp_ccmd_in                        (cp_ccmd_in),
     .dp_cdata_in                       (dp_cdata_in),
   //SD_3.0 start
   .de_interleave_r                   (de_interleave),
   //SD_3.0 end
   //SDIO start
     .card_int_n_dsync                   (card_int_n_dsync[`NUM_CARD_BUS-1:0]),
   .dat_int_n_dsync                    (dat_int_n_dsync[`NUM_CARD_BUS-1:0]),
   //SDIO ends
     .cdata_in_r                        (cdata_in_r[`NUM_CARD_BUS*8-1:0]),
     .start_bit_delayed                 (start_bit_delayed),
     .busy_clear_int                    (busy_clear_int),
     // Inputs
     .cclk_in                           (cclk_in),
     .cclk_in_en                        (cclk_in_en),
     .cclk_in_en_ddr                    (cclk_in_en_ddr), 
   .start_rx_data                     (start_rx_data),
   .divided_clk                       (divided_clk),
   //SD_3.0 end
     .creset_n                          (creset_n),
     .creset_n_sample                   (creset_n_sample),
     .creset_n_drv                      (creset_n_drv),
     .cclk_in_drv                       (cclk_in_drv),
     .cclk_in_sample                    (cclk_in_sample),
     .cclk_sample_en_cmd                (cclk_sample_en_cmd[15:0]),
     .cclk_sample_en_data               (cclk_sample_en_data[15:0]),
    //SD_3.0 start
     .cclk_sample_en_ddr                (cclk_sample_en_ddr[15:0]),
   //SD_3.0 end
     .ccmd_in                           (ccmd_in[`NUM_CARD_BUS-1:0]),
     .cdata_in                          (cdata_in[`NUM_CARD_BUS*8-1:0]),
     .cp_card_num                       (cp_card_num[3:0]),
     .cp_ccmd_out                       (cp_ccmd_out),
     .cp_ccmd_out_en                    (cp_ccmd_out_en),
     .dp_cdata_out                      (dp_cdata_out),
     .dp_cdata_out_en                   (dp_cdata_out_en),
     .scan_mode                         (scan_mode),
     .stop_clk_neg_out                  (stop_clk_neg_out),
   .use_hold_reg                      (use_hold_reg),
     .half_start_bit                    (half_start_bit),
     .enable_shift                      (enable_shift),
   //SDIO 3.0 start
     .card_int_n                        (card_int_n[`NUM_CARD_BUS-1:0]),
   //SDIO 3.0 ends
   //SD_3.0 start
   .toggle_n_hold                     (toggle[`NUM_CARD_BUS-1:0]),
     //MMC4_4 start 
   .cclk_in_en_8_ddr                  (cclk_in_en_8_ddr),
   //MMC4_4 end 
   .ddr                               (ddr),
   .tx_data_done                      (tx_data_done),
   .new_cmd_load                      (new_cmd_load),
   .read_or_write_cmd                 (read_or_write_cmd_r),
   .data_expected                     (data_expected_r));
   //SD_3.0 end 

  // CIU to BIU 2 clock extender
  DWC_mobile_storage_c2b2clk
   U_DWC_mobile_storage_c2b2clk
    (
     /*AUTOINST*/
     // Outputs
     .c2b_cmd_taken                     (c2b_cmd_taken),
     .c2b_response_valid                (c2b_response_valid),
     .c2b_response_err                  (c2b_response_err),
     .c2b_response_done                 (c2b_response_done),
   .c2b_volt_switch_int               (c2b_volt_switch_int),
     .c2b_data_trans_done               (c2b_data_trans_done),
     .c2b_data_timeout                  (c2b_data_timeout),
     .c2b_resp_timeout                  (c2b_resp_timeout),
     .c2b_data_crc_err                  (c2b_data_crc_err),
     .c2b_resp_crc_err                  (c2b_resp_crc_err),
     .c2b_auto_cmd_done                 (c2b_auto_cmd_done),
     .c2b_rx_stbit_err                  (c2b_rx_stbit_err),
     .c2b_data_strv_err                 (c2b_data_strv_err),
     .c2b_rxend_nocrc_err               (c2b_rxend_nocrc_err),
     .c2b_sdio_interrupt                (c2b_sdio_interrupt[`NUM_CARD_BUS-1:0]),
     .c2b_clr_send_ccsd                 (c2b_clr_send_ccsd),
     .c2b_end_boot                      (c2b_end_boot),
     .c2b_boot_ack_tout                 (c2b_boot_ack_tout),
     .c2b_boot_data_tout                (c2b_boot_data_tout),
     // Inputs
     .cclk_in                           (cclk_in),
     .creset_n                          (creset_n),
     .cmd_taken                         (cmd_taken),
     .response_valid                    (response_valid),
     .response_err                      (response_err),
     .response_done                     (response_done),
   //SD_3.0 start
     .volt_switch_int                   (volt_switch_int),
   //SD_3.0 end
     .data_trans_done                   (data_trans_done),
     .rx_data_timeout                   (rx_data_timeout),
     .resp_timeout                      (resp_timeout),
     .data_crc_err                      (data_crc_err),
     .resp_crc_err                      (resp_crc_err),
     .auto_cmd_done                     (auto_cmd_done),
     .rx_stbit_err                      (rx_stbit_err_busy_clear_int_r),
     .data_strv_err                     (data_strv_err),
     .rxend_txnocrc_err                 (rxend_txnocrc_err),
     .sdio_interrupt                    (sdio_interrupt[`NUM_CARD_BUS-1:0]),
     .clr_send_ccsd                     (clr_send_ccsd),
     .end_boot                          (end_boot),
     .boot_ack_tout                     (boot_ack_timeout), 
     .boot_data_tout                    (boot_data_timeout));
 //Adding a register before it goes to Synchronizer to eliminate any glitches.
 always@(posedge cclk_in or negedge creset_n)
    begin
        if (~creset_n)
           rx_stbit_err_busy_clear_int_r <= 1'b0;
        else
           rx_stbit_err_busy_clear_int_r <= rx_stbit_err|(busy_clear_int & busy_clr_int_mask);
     end

  // ****** DWC_mobile_storage Checkers - START ********

  // synopsys translate_off
  `ifdef DWC_mobile_storage_CHECKER_ON

  //------------------------------------------
  // Command line checking
  //------------------------------------------
   
  //Note: The cmd and data output signals (ccmd_out_en, ccmd_out, cdata_out_en and cdata_out)
  // are registered with cclk_in_drv when use_hold_reg == 1'b1.
  // So in the Checkers below, when  use_hold_reg = 1'b1 wait for one cclk_in_drv before checking the output signals.
  wire [3:0] active_card_num;
  reg [3:0]  act_card_num_tmp;
  reg        scan_mode_tmp;
  reg        creset_tmp;
  
  //Command path state defines
   `define      CP_IDLE_CHK                0    // Cmd path idle
   `define      TXCMD_ISEQ_CHK             1    // Send init sequence
   `define      CPWAIT_NCC_CHK             14   // Cmd path wait ncc
   `define      CPWAIT_CRT_CHK             15   // Wait cmd to resp turnaround

  assign     active_card_num = U_DWC_mobile_storage_cmdpath.cp_card_num;

  initial begin
    $display ("*** Starting DWC_mobile_storage_CHECKER. @ %t *** \n", $time);
  end

  //Checking of P bit driving on command line in IDLE state
  initial begin
    forever begin
      if (U_DWC_mobile_storage_cmdpath.cp_cs[`CP_IDLE_CHK] && ~scan_mode && 
          ~U_DWC_mobile_storage_cmdpath.cmd_irq_resp && sync_od_pullup_en_n && 
          creset_n) begin
        act_card_num_tmp = active_card_num;
        scan_mode_tmp = scan_mode;
        @ (posedge cclk_out[active_card_num]);
     //#(6); //Testbench specific delay 
        if ((act_card_num_tmp == active_card_num) && (scan_mode_tmp == scan_mode) &&
            ~U_DWC_mobile_storage_cmdpath.cmd_irq_resp && sync_od_pullup_en_n &&
            creset_n && ~creset_tmp) begin
           
        if (use_hold_reg) begin 
          @ (posedge cclk_in_drv);
               #(1);
               if (act_card_num_tmp == active_card_num) begin
                 if ((!((ccmd_out[active_card_num]) && (ccmd_out_en[active_card_num]))))
                  $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err when command path is in IDLE state. @ %t *** \n", $time);
              end
            end else begin
             #(1);
             if (act_card_num_tmp == active_card_num) begin
         if ((!((ccmd_out[active_card_num]) && (ccmd_out_en[active_card_num]))))
                $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err when command path is in IDLE state. @ %t *** \n", $time);
              end 
            end

       
        end else
          @ (posedge cclk_in);
      end else
        @ (posedge cclk_in);
      
      creset_tmp = 1'b0;
    end
  end

  //For reset pulse less than one clock
  always @ (negedge creset_n)
    creset_tmp = 1'b1;
  
  //Checking of P bit driving on command line in WAIT_NCC state
  initial begin
    forever begin
      if (U_DWC_mobile_storage_cmdpath.cp_cs[`CPWAIT_NCC_CHK] && 
          ~U_DWC_mobile_storage_cmdpath.cmd_irq_resp && sync_od_pullup_en_n) begin
        act_card_num_tmp = active_card_num;
        @ (posedge cclk_out[active_card_num]);
        //#(6); //Testbench specific delay
        if ((act_card_num_tmp == active_card_num) &&
            ~U_DWC_mobile_storage_cmdpath.cmd_irq_resp && sync_od_pullup_en_n) begin
       if (use_hold_reg) begin 
          @ (posedge cclk_in_drv);
               #(1);
               if ((!((ccmd_out[active_card_num]) && (ccmd_out_en[active_card_num])))&& ~U_DWC_mobile_storage_cmdpath.voltage_switch)
                 $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err when command path is in WAIT_NCC state. @ %t *** \n", $time);
     end else begin
              #(1); 
           if ((!((ccmd_out[active_card_num]) && (ccmd_out_en[active_card_num])))&& ~U_DWC_mobile_storage_cmdpath.voltage_switch)
                 $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err when command path is in WAIT_NCC state. @ %t *** \n", $time);
       end
        end else
          @ (posedge cclk_in);
      end else
        @ (posedge cclk_in);
    end
  end

  //Checking of INIT sequence 
  initial begin
    forever begin
      if (U_DWC_mobile_storage_cmdpath.cp_cs[`TXCMD_ISEQ_CHK] && 
          ~U_DWC_mobile_storage_cmdpath.cmd_irq_resp && sync_od_pullup_en_n) begin
        act_card_num_tmp = active_card_num;
        @ (posedge cclk_out[active_card_num]);
        //#(6); //Testbench specific delay 
        if ((act_card_num_tmp == active_card_num) &&
            ~U_DWC_mobile_storage_cmdpath.cmd_irq_resp && sync_od_pullup_en_n) begin
           if (use_hold_reg) begin 
          @ (posedge cclk_in_drv);
               #(1);
               if (!((ccmd_out[active_card_num]) && (ccmd_out_en[active_card_num])))
               $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during INIT sequence. @ %t *** \n", $time);
       end else begin
              #(1);
           if (!((ccmd_out[active_card_num]) && (ccmd_out_en[active_card_num])))
               $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during INIT sequence. @ %t *** \n", $time);
         end 
        end else
          @ (posedge cclk_in);
      end else
        @ (posedge cclk_in);
    end
  end

  //Open drain mode checking 
  initial begin
    repeat (3) @ (posedge cclk_in);
    forever begin
      if (U_DWC_mobile_storage_cmdpath.cmd_irq_resp || ~sync_od_pullup_en_n) begin
        act_card_num_tmp = active_card_num;
        @ (posedge cclk_out[active_card_num]);
       // #(6); //Testbench specific delay 
       @ (posedge cclk_in);
    if ((act_card_num_tmp == active_card_num) &&
            (U_DWC_mobile_storage_cmdpath.cmd_irq_resp || ~sync_od_pullup_en_n) && creset_n && ~creset_tmp) begin
          if (ccmd_out[active_card_num])
            $display ("DWC_mobile_storage_CHECKER ERROR : Macrocell is not driving 0 on cmd line during open drain mode. @ %t *** \n", $time);
        end  else
          @ (posedge cclk_in);
      end else
        @ (posedge cclk_in);
    end
  end


  //Checking of driving High-Z on cmd line after driving the end bit of command
  initial begin
    forever begin
      if (U_DWC_mobile_storage_cmdpath.cp_cs[`CPWAIT_CRT_CHK]) begin
        act_card_num_tmp = active_card_num;
        @ (posedge cclk_out[active_card_num]);
        //#(6); //Testbench specific delay 
        if (act_card_num_tmp == active_card_num) begin
       if (use_hold_reg) begin 
          @ (posedge cclk_in_drv);
               #(1);
               if (ccmd_out_en[active_card_num])
                 $display ("DWC_mobile_storage_CHECKER ERROR : Macrocell is not driving High-Z after command end bit. @ %t *** \n", $time);
      end else begin
                #(1);
             if (ccmd_out_en[active_card_num])
                 $display ("DWC_mobile_storage_CHECKER ERROR : Macrocell is not driving High-Z after command end bit. @ %t *** \n", $time);
            end
       end else
          @ (posedge cclk_in);
      end else
        @ (posedge cclk_in);
    end
  end

  //------------------------------------------
  //Data line checking
  //------------------------------------------
  reg [3:0]  act_card_num_tmp1;

  //Data transmit state defines
  `define       TXDT_WFE_CHK         1  // Wait FIFO Empty
  `define       TXDT_WFE3_CHK        13 // Wait FIFO Empty 1 clk


  //P bit driving on dataline before driving write data.
  initial begin
    forever begin      
      if (U_DWC_mobile_storage_datapath.U_DWC_mobile_storage_datatx.txdt_cs[`TXDT_WFE_CHK] &&
          U_DWC_mobile_storage_datapath.dp_cdata_in[0] && !ddr_8_mode) begin
        act_card_num_tmp1 = active_card_num;
        @ (posedge cclk_out[active_card_num]);
        //#(6); //Testbench specific delay 
        if (act_card_num_tmp1 == active_card_num) begin
      if (use_hold_reg) begin 
         @ (posedge cclk_in_drv);
             #(1);

              if (`CARD_TYPE == 0) begin //MMC only mode
                if (!(cdata_out_en[0] && cdata_out[0]))
                  $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE state. @ %t *** \n", $time);
              end else begin //SD mode
                 if (!(cdata_out_en[active_card_num*8] && cdata_out[active_card_num*8]))
                   $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE state. @ %t *** \n", $time);
                 //For 4 bit mode
                 if (U_DWC_mobile_storage_datapath.dp_card_wide_bus == 2'b01) begin
                   if(!(cdata_out_en[active_card_num*8 + 1] && cdata_out[active_card_num*8 + 1] &&
                        cdata_out_en[active_card_num*8 + 2] && cdata_out[active_card_num*8 + 2] &&
                        cdata_out_en[active_card_num*8 + 3] && cdata_out[active_card_num*8 + 3]))
                     $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE state during 4 bit mode. @ %t *** \n", $time);
                 end
                 //For 8 bit mode
                 if (U_DWC_mobile_storage_datapath.dp_card_wide_bus[1]) begin
                   if(!(cdata_out_en[active_card_num*8 + 1] && cdata_out[active_card_num*8 + 1] &&
                        cdata_out_en[active_card_num*8 + 2] && cdata_out[active_card_num*8 + 2] &&
                        cdata_out_en[active_card_num*8 + 3] && cdata_out[active_card_num*8 + 3] &&
                        cdata_out_en[active_card_num*8 + 4] && cdata_out[active_card_num*8 + 4] &&
                        cdata_out_en[active_card_num*8 + 4] && cdata_out[active_card_num*8 + 4] &&
                        cdata_out_en[active_card_num*8 + 5] && cdata_out[active_card_num*8 + 5] &&
                        cdata_out_en[active_card_num*8 + 6] && cdata_out[active_card_num*8 + 6] &&
                        cdata_out_en[active_card_num*8 + 7] && cdata_out[active_card_num*8 + 7]))
                     $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE state during 8 bit mode. @ %t *** \n", $time);
                 end
       end 
      end else 
      begin
            #(1);
            if (`CARD_TYPE == 0) begin //MMC only mode
              if (!(cdata_out_en[0] && cdata_out[0]))
                $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE state. @ %t *** \n", $time);
            end else begin //SD mode
              if (!(cdata_out_en[active_card_num*8] && cdata_out[active_card_num*8]))
                $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE state. @ %t *** \n", $time);
              //For 4 bit mode
              if (U_DWC_mobile_storage_datapath.dp_card_wide_bus == 2'b01) begin
                if(!(cdata_out_en[active_card_num*8 + 1] && cdata_out[active_card_num*8 + 1] &&
                     cdata_out_en[active_card_num*8 + 2] && cdata_out[active_card_num*8 + 2] &&
                     cdata_out_en[active_card_num*8 + 3] && cdata_out[active_card_num*8 + 3]))
                  $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE state during 4 bit mode. @ %t *** \n", $time);
              end
              //For 8 bit mode
              if (U_DWC_mobile_storage_datapath.dp_card_wide_bus[1]) begin
                if(!(cdata_out_en[active_card_num*8 + 1] && cdata_out[active_card_num*8 + 1] &&
                     cdata_out_en[active_card_num*8 + 2] && cdata_out[active_card_num*8 + 2] &&
                     cdata_out_en[active_card_num*8 + 3] && cdata_out[active_card_num*8 + 3] &&
                     cdata_out_en[active_card_num*8 + 4] && cdata_out[active_card_num*8 + 4] &&
                     cdata_out_en[active_card_num*8 + 4] && cdata_out[active_card_num*8 + 4] &&
                     cdata_out_en[active_card_num*8 + 5] && cdata_out[active_card_num*8 + 5] &&
                     cdata_out_en[active_card_num*8 + 6] && cdata_out[active_card_num*8 + 6] &&
                     cdata_out_en[active_card_num*8 + 7] && cdata_out[active_card_num*8 + 7]))
                  $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE state during 8 bit mode. @ %t *** \n", $time);
              end
            end
          end
        end else
          @ (posedge cclk_in);
      end else
        @ (posedge cclk_in);
    end
  end

  initial begin
    forever begin
      if (U_DWC_mobile_storage_datapath.U_DWC_mobile_storage_datatx.txdt_cs[`TXDT_WFE3_CHK] && !ddr_8_mode) begin
        act_card_num_tmp1 = active_card_num;
        @ (posedge cclk_out[active_card_num]);
        //#(6); //Testbench specific delay 
        if (act_card_num_tmp1 == active_card_num) begin
     if (use_hold_reg) begin 
         @ (posedge cclk_in_drv);
             #(1);

              if (`CARD_TYPE == 0) begin //MMC only mode
                if (!(cdata_out_en[0] && cdata_out[0]))
                  $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE3 state. @ %t *** \n", $time);
              end else begin //SD mode
                if (!(cdata_out_en[active_card_num*8] && cdata_out[active_card_num*8]))
                  $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE3 state. @ %t *** \n", $time);
                //For 4 bit mode
                if (U_DWC_mobile_storage_datapath.dp_card_wide_bus == 2'b01) begin
                  if(!(cdata_out_en[active_card_num*8 + 1] && cdata_out[active_card_num*8 + 1] &&
                       cdata_out_en[active_card_num*8 + 2] && cdata_out[active_card_num*8 + 2] &&
                       cdata_out_en[active_card_num*8 + 3] && cdata_out[active_card_num*8 + 3]))
                    $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE3 state during 4 bit mode. @ %t *** \n", $time);
                end
                //For 8 bit mode
                if (U_DWC_mobile_storage_datapath.dp_card_wide_bus[1]) begin
                  if(!(cdata_out_en[active_card_num*8 + 1] && cdata_out[active_card_num*8 + 1] &&
                       cdata_out_en[active_card_num*8 + 2] && cdata_out[active_card_num*8 + 2] &&
                       cdata_out_en[active_card_num*8 + 3] && cdata_out[active_card_num*8 + 3] &&
                       cdata_out_en[active_card_num*8 + 4] && cdata_out[active_card_num*8 + 4] &&
                       cdata_out_en[active_card_num*8 + 5] && cdata_out[active_card_num*8 + 5] &&
                       cdata_out_en[active_card_num*8 + 6] && cdata_out[active_card_num*8 + 6] &&
                       cdata_out_en[active_card_num*8 + 7] && cdata_out[active_card_num*8 + 7]))
                    $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE3 state during 8 bit mode. @ %t *** \n", $time);
                end
              end

           end else
      begin
             #(1);
             if (`CARD_TYPE == 0) begin //MMC only mode
                if (!(cdata_out_en[0] && cdata_out[0]))
                  $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE3 state. @ %t *** \n", $time);
              end else begin //SD mode
                if (!(cdata_out_en[active_card_num*8] && cdata_out[active_card_num*8]))
                  $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE3 state. @ %t *** \n", $time);
                //For 4 bit mode
                if (U_DWC_mobile_storage_datapath.dp_card_wide_bus == 2'b01) begin
                  if(!(cdata_out_en[active_card_num*8 + 1] && cdata_out[active_card_num*8 + 1] &&
                       cdata_out_en[active_card_num*8 + 2] && cdata_out[active_card_num*8 + 2] &&
                       cdata_out_en[active_card_num*8 + 3] && cdata_out[active_card_num*8 + 3]))
                    $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE3 state during 4 bit mode. @ %t *** \n", $time);
                end
                //For 8 bit mode
                if (U_DWC_mobile_storage_datapath.dp_card_wide_bus[1]) begin
                  if(!(cdata_out_en[active_card_num*8 + 1] && cdata_out[active_card_num*8 + 1] &&
                       cdata_out_en[active_card_num*8 + 2] && cdata_out[active_card_num*8 + 2] &&
                       cdata_out_en[active_card_num*8 + 3] && cdata_out[active_card_num*8 + 3] &&
                       cdata_out_en[active_card_num*8 + 4] && cdata_out[active_card_num*8 + 4] &&
                       cdata_out_en[active_card_num*8 + 5] && cdata_out[active_card_num*8 + 5] &&
                       cdata_out_en[active_card_num*8 + 6] && cdata_out[active_card_num*8 + 6] &&
                       cdata_out_en[active_card_num*8 + 7] && cdata_out[active_card_num*8 + 7]))
                    $display ("DWC_mobile_storage_CHECKER ERROR : P bit driving err during card write in WFE3 state during 8 bit mode. @ %t *** \n", $time);
                end
              end
           end
      
        end else
          @ (posedge cclk_in);
      end else
        @ (posedge cclk_in);
    end
  end
 
 `endif
  // synopsys translate_on
  // ****** DWC_mobile_storage Checkers - END ********

  
endmodule // DWC_mobile_storage_ciu
