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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_c2b2clk.v#13 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_c2b2clk.v
// Description : DWC_mobile_storage_c2b2clk, generate a output which will be valid for
//               2 clocks after input goes high and output are registered
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_c2b2clk(
  /*AUTOARG*/
  // Outputs
  c2b_cmd_taken, c2b_response_valid, c2b_response_err, c2b_response_done,
 //SD_3.0 start
 c2b_volt_switch_int,
 //SD_3.0 ends
  c2b_data_trans_done, c2b_data_timeout, c2b_resp_timeout, c2b_data_crc_err,
  c2b_resp_crc_err, c2b_auto_cmd_done, c2b_rx_stbit_err, c2b_data_strv_err,
  c2b_rxend_nocrc_err, c2b_sdio_interrupt, c2b_clr_send_ccsd,
  c2b_end_boot,c2b_boot_ack_tout,c2b_boot_data_tout,
  // Inputs
  cclk_in, creset_n, cmd_taken, response_valid, response_err, response_done,
 //SD_3.0 start
  volt_switch_int,
 //SD_3.0 ends
  data_trans_done, rx_data_timeout, resp_timeout, data_crc_err, resp_crc_err,
  auto_cmd_done, rx_stbit_err, data_strv_err, rxend_txnocrc_err,
  sdio_interrupt, clr_send_ccsd
  ,end_boot,boot_ack_tout,boot_data_tout
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clock and Reset
  input        cclk_in;              // Card Clock Signal
  input        creset_n;             // Reset active low

  // Inputs
  input        cmd_taken;            // Command taken by command path
  input        response_valid;       // Response valid - data and addr
  input        response_err;         // Response error
  input        response_done;        // Response done - (or command done)
 //SD_3.0 start
 input        volt_switch_int;
 //SD_3.0 ends
  input        data_trans_done;      // Data transfer done
  input        rx_data_timeout;      // Read data timeout error
  input        resp_timeout;         // Response timeout error
  input        data_crc_err;         // Data crc error
  input        resp_crc_err;         // Response crc error
  input        auto_cmd_done;        // Auto stop command done
  input        rx_stbit_err;         // Read data Start bit error
  input        data_strv_err;        // Data starvation error
  input        rxend_txnocrc_err;    //rx data end_bit/txdata no crc
  input [`NUM_CARD_BUS-1:0] sdio_interrupt;       // SDIO interrupt
  input        clr_send_ccsd;        // Clear the send_ccsd bit
  input        end_boot;
  input        boot_ack_tout;
  input        boot_data_tout;

  // Outputs
  output       c2b_cmd_taken;            // Command taken by command path
  output       c2b_response_valid;       // Response valid - data and addr
  output       c2b_response_err;         // Response error
  output       c2b_response_done;        // Response done - (or command done)
 //SD_3.0 start
  output       c2b_volt_switch_int;
 //SD_3.0 ends
  output       c2b_data_trans_done;      // Data transfer done
  output       c2b_data_timeout;         // Read data timeout error
  output       c2b_resp_timeout;         // Response timeout error
  output       c2b_data_crc_err;         // Data crc error
  output       c2b_resp_crc_err;         // Response crc error
  output       c2b_auto_cmd_done;        // Auto stop command done
  output       c2b_rx_stbit_err;         // Read data Start bit error
  output       c2b_data_strv_err;        // Data starvation error
  output       c2b_rxend_nocrc_err;      // Rxdataend_bit/txdatanocrc
  output [`NUM_CARD_BUS-1:0] c2b_sdio_interrupt;      // SDIO interrupt
  output       c2b_clr_send_ccsd;        // Clear the send_ccsd bit
  output       c2b_end_boot;
  output       c2b_boot_ack_tout;
  output       c2b_boot_data_tout;


  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Registers
  reg [`NUM_CARD_BUS+17:0] in_r;                  // Input reg vector
  reg [`NUM_CARD_BUS+17:0] out_r;                 // Output reg vector

  // Wire      
 //SD_3.0 start
  wire  [`NUM_CARD_BUS+17:0] in_w;           // Input wire
  wire  [`NUM_CARD_BUS+17:0] in_pulse;       // Input pulse wire
  //SD_3.0 ends
  integer i;

  //----------------------------------------------------------------------
  //        Output waveform of this block
  //            _    _    _    _    _    _    _    _    _    _
  // cclk_in __| |__| |__| |__| |__| |__| |__| |__| |__| |__| |__|
  //            ___________________                ______________
  //      in __/                   \______________/
  //            ____
  // or   in __/    \____________________________________________
  //            ____                               ____
  //in_pulse___/    \_____________________________/    \_________
  //
  //                 __________________________________
  //    out_________/                                  \_________
  //
  //----------------------------------------------------------------------
  assign in_w = {end_boot, boot_ack_tout,boot_data_tout,sdio_interrupt, clr_send_ccsd, data_strv_err, 
                rxend_txnocrc_err, rx_stbit_err, auto_cmd_done, resp_crc_err,
                data_crc_err, resp_timeout, rx_data_timeout,
                data_trans_done, response_done,
        //SD_3.0 start
        volt_switch_int, 
        // SD_3.0 ends
        response_err,
                response_valid, cmd_taken};

  assign {c2b_end_boot,c2b_boot_ack_tout,c2b_boot_data_tout,c2b_sdio_interrupt, c2b_clr_send_ccsd, c2b_data_strv_err, 
         c2b_rxend_nocrc_err, c2b_rx_stbit_err, c2b_auto_cmd_done, 
  c2b_resp_crc_err, c2b_data_crc_err, c2b_resp_timeout, 
  c2b_data_timeout, c2b_data_trans_done, c2b_response_done,
  //SD_3.0 start
   c2b_volt_switch_int, 
  //SD_3.0 ends
  c2b_response_err, c2b_response_valid, c2b_cmd_taken} = out_r;
 
  assign in_pulse  = in_w & ~in_r;

  always @(posedge cclk_in or negedge creset_n)
    begin
      if(~creset_n) 
        begin
          in_r        <= {`NUM_CARD_BUS+18{1'b0}};
          out_r       <= {`NUM_CARD_BUS+18{1'b0}};
        end 
      else 
        begin
          in_r        <= in_w;
          for(i=0; i < (`NUM_CARD_BUS+18); i=i+1)
            if(in_pulse[i]) 
              out_r[i] <= ~out_r[i];
        end
    end

endmodule // DWC_mobile_storage_c2b2clk
