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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_b2c.v#19 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_b2c.v
// Description : This is the synchronizer which synchronizes signals
//               from BIU domain in to card domain.
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_b2c(

  /*AUTOARG*/
  // Outputs
  clear_pointers, creset_n,cmd_start,clear_cntrl0, read_wait,  sync_od_pullup_en_n,
  abort_read_data, send_irq_response, ceata_intr_status, send_ccsd, send_auto_stop_ccsd,rst_n,
  half_start_bit,enable_shift, creset_n_sample, creset_n_drv,
  // Inputs
  cclk_in, reset_n, scan_mode, b2c_clear_pointers, b2c_creset_n, 
  b2c_cmd_start, b2c_read_wait, b2c_od_pullup_en_n, b2c_abort_read_data, 
  b2c_send_irq_resp, b2c_ceata_intr_status, b2c_send_ccsd,rst_n_biu, b2c_send_auto_stop_ccsd,
  b2c_half_start_bit,b2c_enable_shift, cclk_in_sample, cclk_in_drv
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  input                   cclk_in;
  input                   cclk_in_sample;
  input                   cclk_in_drv;
  input                   reset_n;
  input                   scan_mode;

  input                   b2c_clear_pointers;
  input                   b2c_creset_n;          // Card Reset - Active Low
  input                   b2c_cmd_start;
  input                   b2c_read_wait;
  input                   b2c_od_pullup_en_n;
  input                   b2c_abort_read_data;
  input                   b2c_send_irq_resp;
  input                   b2c_ceata_intr_status; // CE-ATA device interrupt status
  input                   b2c_send_ccsd;         // Send CCSD to CE-ATA device
  input                   b2c_half_start_bit;
  input [((`NUM_CARD_BUS*2)-1):0]b2c_enable_shift;
 //MMC4_4 start
  input [`NUM_CARD_BUS-1:0]rst_n_biu;
 //MMC4_4 ends
  input                   b2c_send_auto_stop_ccsd; // Send internal AUTO STOP after the CCSD
 
  output                  clear_pointers;
  output                  creset_n;              // Card Reset - Active Low
  output                  clear_cntrl0 ;         // Signal to clear cntrl[0] 
  output                  creset_n_sample;       // Sample clk Reset - Active Low
  output                  creset_n_drv;          // Drive clk Reset - Active Low
  output                  cmd_start;
  output                  read_wait;
  output                  sync_od_pullup_en_n;
  output                  abort_read_data;
  output                  send_irq_response;
  output                  ceata_intr_status;
  output                  send_ccsd;
  output                  send_auto_stop_ccsd;
  output                  half_start_bit;
  output [((`NUM_CARD_BUS*2)-1):0]enable_shift ;

 //MMC4_4 start
  output [`NUM_CARD_BUS-1:0]rst_n;
 //MMC4_4 ends

  // --------------------------------------
  // Wire Declaration
  // --------------------------------------
  
  reg                   b2c_stage0_creset_n;
  reg                   b2c_stage1_creset_n;
  reg                   b2c_stage0_creset_n_sample;
  reg                   b2c_stage1_creset_n_sample;
  reg                   b2c_stage0_creset_n_drv;
  reg                   b2c_stage1_creset_n_drv;
  reg             [`NUM_CARD_BUS+8:0] b2c_stage0;
  reg             [`NUM_CARD_BUS+8:0] b2c_stage1;
  wire            [`NUM_CARD_BUS+8:0] b2c_inputs;

// Clk reset synchronization made correct.
  assign creset_n =  scan_mode ? reset_n : b2c_stage1_creset_n;

// Escape the scan mux to get rid of the following DFT warning
//Warning: Clock reset_n connects to data input (D) of DFF U_DWC_mobile_storage_c2b/c2b_clear_reset_stage0_reg[1]. (D10-1)
  assign clear_cntrl0 = b2c_stage1_creset_n;
  assign creset_n_sample =  scan_mode ? reset_n : b2c_stage1_creset_n_sample;
  assign creset_n_drv =  scan_mode ? reset_n : b2c_stage1_creset_n_drv;
 
 always @ (posedge cclk_in or negedge b2c_creset_n)
   begin
     if(~b2c_creset_n)
       begin
          b2c_stage0_creset_n <= 1'b0;
          b2c_stage1_creset_n <= 1'b0;
       end
     else
              begin
          b2c_stage0_creset_n <= 1'b1;
          b2c_stage1_creset_n <= b2c_stage0_creset_n;
              end
          end   

 always @ (posedge cclk_in_sample or negedge b2c_creset_n)
   begin
     if(~b2c_creset_n)
       begin
          b2c_stage0_creset_n_sample <= 1'b0;
        b2c_stage1_creset_n_sample <= 1'b0;
     end
    else
       begin
          b2c_stage0_creset_n_sample <= 1'b1;
        b2c_stage1_creset_n_sample <= b2c_stage0_creset_n_sample;
     end
  end   

 always @ (posedge cclk_in_drv or negedge b2c_creset_n)
   begin
     if(~b2c_creset_n)
       begin
          b2c_stage0_creset_n_drv <= 1'b0;
        b2c_stage1_creset_n_drv <= 1'b0;
     end
    else
       begin
          b2c_stage0_creset_n_drv <= 1'b1;
        b2c_stage1_creset_n_drv <= b2c_stage0_creset_n_drv;
     end
  end   

  assign b2c_inputs = {rst_n_biu,b2c_clear_pointers, b2c_cmd_start, b2c_read_wait, 
                      b2c_od_pullup_en_n, b2c_abort_read_data,
                      b2c_send_irq_resp, b2c_ceata_intr_status,
        b2c_send_ccsd, b2c_send_auto_stop_ccsd};
//rst_n is the hardware reset to the eMMC CARD. This signal is treated as a normal data signal within the core.
// hence it is synchronized using a data synchronizer. The reset value is set to 1 as the signal is active low for
// the card.
  assign {rst_n,clear_pointers, cmd_start, read_wait, sync_od_pullup_en_n, 
         abort_read_data, send_irq_response, ceata_intr_status,
  send_ccsd, send_auto_stop_ccsd} = b2c_stage1; 

  always @ (posedge cclk_in or negedge creset_n)
    begin
      if(~creset_n)
        begin
      b2c_stage0[`NUM_CARD_BUS+8:9] <= {`NUM_CARD_BUS{1'b1}};
          b2c_stage1[`NUM_CARD_BUS+8:9] <= {`NUM_CARD_BUS{1'b1}};
          b2c_stage0[8:0] <= {9{1'b0}};
          b2c_stage1[8:0] <= {9{1'b0}};
        end
      else
        begin
          b2c_stage0 <= b2c_inputs;
          b2c_stage1 <= b2c_stage0;
        end
    end
 
//Synchronizer for half_start_bit. Note that this is a static signal so as such
//synchronizer is not required. However adding it to reduce any CDC tool related erors.

  DWC_mobile_storage_bcm21
    #(1,2,0,0) HALF_START_BIT_SYNC
    (
      .clk_d      (cclk_in),
      .rst_d_n    (creset_n),
      .init_d_n   (1'b1),
      .data_s     (b2c_half_start_bit),
      .test       (1'b0),
      .data_d     (half_start_bit)
   );

//Synchronizer for enable_shift. Note that this is a static signal so as such
//synchronizer is not required. However adding it to reduce any CDC tool related erors.

  DWC_mobile_storage_bcm21
    #({`NUM_CARD_BUS*2},2,0,0) ENABLE_SHIFT_SYNC
    (
      .clk_d      (cclk_in),
      .rst_d_n    (creset_n),
      .init_d_n   (1'b1),
      .data_s     (b2c_enable_shift),
      .test       (1'b0),
      .data_d     (enable_shift)
   );

     
endmodule 
