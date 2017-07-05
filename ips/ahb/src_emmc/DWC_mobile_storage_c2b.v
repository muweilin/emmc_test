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
// Date             :        $Date: 2012/03/21 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_c2b.v#14 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_c2b.v
// Description : This is the synchronizer which synchronizes signals
//               from Card domain in to BIU domain.
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_c2b(

  /*AUTOARG*/
  // Outputs
  cmd_taken, response_valid, response_err, response_done,
  ciu_data_trans_done, data_timeout, resp_timeout, data_crc_err,
  resp_crc_err, auto_cmd_done, rx_stbit_err, data_strv_err, rxend_nocrc_err,
  clr_abrt_read_data, clear_irq_response, card_detect_biu, card_write_prt_biu,
  gp_in_biu, sdio_interrupt, ciu_status, ciu_trans_bytes, clear_ciu_reset, 
  clr_clear_pointers, clr_send_ccsd,
  end_boot,boot_ack_tout,boot_data_tout,
 //SD_3.0 start
  volt_switch_int,
 //SD_3.0 ends
 // Inputs
  clk, reset_n, c2b_cmd_taken, c2b_response_valid, c2b_response_err,
  c2b_response_done, c2b_data_trans_done, c2b_data_timeout,
  c2b_resp_timeout, c2b_data_crc_err, c2b_resp_crc_err,
  c2b_auto_cmd_done, c2b_rx_stbit_err, c2b_data_strv_err, c2b_rxend_nocrc_err,
  abort_read_data, send_irq_response, card_detect_n, card_write_prt,
  gp_in, c2b_sdio_interrupt, c2b_cmd_fsm_state_3, c2b_cmd_fsm_state_2,
  c2b_cmd_fsm_state_1, c2b_cmd_fsm_state_0, c2b_ciu_status,
  c2b_trans_bytes, clear_cntrl0, clear_pointers, c2b_clr_send_ccsd
  ,c2b_end_boot,c2b_boot_ack_tout,c2b_boot_data_tout,
 //SD_3.0 start
  c2b_volt_switch_int
 //SD_3.0 ends
   );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  input                      clk;
  input                      reset_n;
  input                      c2b_cmd_taken;
  input                      c2b_response_valid;
  input                      c2b_response_err;
  input                      c2b_response_done;
  input                      c2b_data_trans_done;
  input                      c2b_data_timeout;
  input                      c2b_resp_timeout;
  input                      c2b_data_crc_err;
  input                      c2b_resp_crc_err;
  input                      c2b_auto_cmd_done;
  input                      c2b_rx_stbit_err;
  input                      c2b_data_strv_err;
  input                      c2b_rxend_nocrc_err;
  input                      abort_read_data;
  input                      send_irq_response;
  input     [`NUM_CARDS-1:0] card_detect_n;
  input     [`NUM_CARDS-1:0] card_write_prt;
  input                [7:0] gp_in;
  input  [`NUM_CARD_BUS-1:0] c2b_sdio_interrupt;
  input                      c2b_cmd_fsm_state_3;
  input                      c2b_cmd_fsm_state_2;
  input                      c2b_cmd_fsm_state_1;
  input                      c2b_cmd_fsm_state_0;
  input                [3:0] c2b_ciu_status;
  input               [31:0] c2b_trans_bytes;
  input                      clear_cntrl0;
  input                      clear_pointers;                      
  input                      c2b_clr_send_ccsd;
  input                      c2b_end_boot;
  input                      c2b_boot_ack_tout;
  input                      c2b_boot_data_tout;
 //SD_3.0 start
  input                      c2b_volt_switch_int;
 //SD_3.0 ends


  output                     cmd_taken;
  output                     response_valid;
  output                     response_err;
  output                     response_done;
  output                     ciu_data_trans_done;
  output                     data_timeout;
  output                     resp_timeout;
  output                     data_crc_err;
  output                     resp_crc_err;
  output                     auto_cmd_done;
  output                     rx_stbit_err;
  output                     data_strv_err;
  output                     rxend_nocrc_err;
  output                     clr_abrt_read_data;
  output                     clear_irq_response;
  output                     clear_ciu_reset;
  output                     clr_clear_pointers;
  output    [`NUM_CARDS-1:0] card_detect_biu;
  output    [`NUM_CARDS-1:0] card_write_prt_biu;
  output               [7:0] gp_in_biu;
  output [`NUM_CARD_BUS-1:0] sdio_interrupt;
  output               [7:0] ciu_status;
  output              [31:0] ciu_trans_bytes;
  output                     clr_send_ccsd;
  output                     end_boot;
  output                     boot_ack_tout;
  output                     boot_data_tout;
 //SD_3.0 start
  output                     volt_switch_int;
 //SD_3.0 ends


  // --------------------------------------
  // Wire Declaration
  // --------------------------------------
 //SD_3.0 start
  reg  [(68+2*`NUM_CARDS+`NUM_CARD_BUS)-1:0] c2b_stage0;
  reg  [(68+2*`NUM_CARDS+`NUM_CARD_BUS)-1:0] c2b_stage1;
  reg                   [`NUM_CARD_BUS+19:0] c2b_stage2;
  wire [(68+2*`NUM_CARDS+`NUM_CARD_BUS)-1:0] c2b_inputs;
 //SD_3.0 ends
  reg [1:0]                                  c2b_clear_reset_stage0;
  reg [1:0]                                  c2b_clear_reset_stage1;

  wire [1:0]                                 c2b_clear_reset;

  assign c2b_inputs = {card_detect_n, card_write_prt, gp_in, 
                      c2b_cmd_fsm_state_3, c2b_cmd_fsm_state_2,
                      c2b_cmd_fsm_state_1, c2b_cmd_fsm_state_0,
                      c2b_ciu_status, c2b_trans_bytes,
                    c2b_end_boot,c2b_boot_ack_tout,           
           c2b_boot_data_tout,
           //SD_3.0 start
                      c2b_volt_switch_int,
           //SD_3.0 ends
                      c2b_sdio_interrupt, c2b_cmd_taken, c2b_response_valid,
                      c2b_response_err, c2b_response_done, c2b_data_trans_done,
                      c2b_data_timeout, c2b_resp_timeout,
                      c2b_data_crc_err, c2b_resp_crc_err,
                      c2b_auto_cmd_done, c2b_rx_stbit_err,
                      c2b_data_strv_err, c2b_rxend_nocrc_err,
                      abort_read_data, send_irq_response, c2b_clr_send_ccsd};

 // For signals below end_boot          
  assign {end_boot,boot_ack_tout,boot_data_tout,
         //SD_3.0 start
          volt_switch_int,
     //SD_3.0 ends
     sdio_interrupt,
          cmd_taken, response_valid, response_err, response_done,
          ciu_data_trans_done, data_timeout, resp_timeout, data_crc_err,
          resp_crc_err, auto_cmd_done, rx_stbit_err, data_strv_err, 
          rxend_nocrc_err, clr_abrt_read_data,
          clear_irq_response,clr_send_ccsd} = 
     //SD_3.0 start
                    c2b_stage1[`NUM_CARD_BUS+19:0] ^ (c2b_stage2);
     //SD_3.0 ends      
  // For signals above end_boot
  assign {card_detect_biu, card_write_prt_biu, gp_in_biu, 
          ciu_status, ciu_trans_bytes} =
     //SD_3.0 start
          c2b_stage1[(68+2*`NUM_CARDS+`NUM_CARD_BUS)-1:`NUM_CARD_BUS+20];
          //SD_3.0 ends
  assign c2b_clear_reset = {~clear_cntrl0, clear_pointers};

  assign {clear_ciu_reset, clr_clear_pointers} = c2b_clear_reset_stage1;
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
    //SD_3.0 start
          c2b_stage0     <= {68+2*`NUM_CARDS+`NUM_CARD_BUS{1'b0}};
          c2b_stage1     <= {68+2*`NUM_CARDS+`NUM_CARD_BUS{1'b0}};
          c2b_stage2     <= {`NUM_CARD_BUS+20{1'b0}};              // NUM_CARD_BUS is for sdio_interrupt
    //SD_3.0 ends
          c2b_clear_reset_stage0 <= 2'b0;
          c2b_clear_reset_stage1 <= 2'b0;
        end
      else
        begin
          c2b_stage0     <= c2b_inputs;
          c2b_stage1     <= c2b_stage0;
     //SD_3.0 start
          c2b_stage2     <= c2b_stage1[`NUM_CARD_BUS+19:0];
     //SD_3.0 ends
          c2b_clear_reset_stage0 <= c2b_clear_reset;
          c2b_clear_reset_stage1 <= c2b_clear_reset_stage0;
        end
   end

endmodule
