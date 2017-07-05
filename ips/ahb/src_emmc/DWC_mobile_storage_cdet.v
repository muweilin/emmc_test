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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_cdet.v#8 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_cdet.v
// Description : DWC_mobile_storage Card Detect Interrupt Unit. This module looks 
//               for any change in the card_detect signals and filters any
//               card insertion/removal de-bounces associated with it and 
//               generate one interrupt to the host.
//               The host should keep a copy of previous card_detect status and
//               on receiving this interrupt, read in the new card_detect inputs
//               and XOR them to find which card(s) has created the interrupt.  
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_cdet(
  /*AUTOARG*/
  // Outputs
  card_detect_int, 
  // Inputs
  clk, reset_n, debounce_count, card_detect_biu
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  input                        clk;             // System Clock
  input                        reset_n;         // System Reset - Active Low
  input                 [23:0] debounce_count;  // De-bounce counter value 
  input       [`NUM_CARDS-1:0] card_detect_biu; // Card Detect Signals  

  // Interrupt 
  output                       card_detect_int; // Card Detect Interrupt

  // Reg/wire declaration
  wire                         card_detect_chg;      // Card Detect Change
  wire                         count_zero;           // Count is Zero
  reg                    [2:0] current_state;        // State Machine Output
  reg                   [23:0] count;                // Debounce Count Value
  reg         [`NUM_CARDS-1:0] card_detect_biu_sync; // Card Detect Sync
  reg                    [3:0] cdet_mask;            // 4 clock delayed reset 


  assign card_detect_int = current_state[2];
  assign count_zero      = (count == 24'h0);
  assign card_detect_chg = cdet_mask[3] &
                           (|(card_detect_biu ^ card_detect_biu_sync));

  // Card-Detect Synchronizer For Card Detect Change and card-detect mask
  // to detect any change just after reset
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          card_detect_biu_sync <= 0;
          cdet_mask <= 4'h0;
        end
      else
        begin
          card_detect_biu_sync <= card_detect_biu;
          cdet_mask <= {cdet_mask[2:0], 1'b1};
        end
    end

  // De-Bounce Count down 
  always @ (posedge clk or negedge reset_n)
     begin
       if(~reset_n)
         begin
           count     <= 24'h0; 
         end
       else
         begin
           if(card_detect_chg)
             count <= debounce_count;
           else if(~current_state[0])
             count <= count - 1;
         end
     end

  // State Machine to track the card-detection 
  always @ (posedge clk or negedge reset_n)
     begin
       if(~reset_n)
         current_state <= 3'b001;
       else
         begin
           case(1'b1)
              current_state[0]: if(card_detect_chg)
                                  current_state <= 3'b010;
                                else        
                                  current_state <= 3'b001;
              current_state[1]: if(card_detect_chg) 
                                  current_state <= 3'b010;
                                else if(count_zero)       
                                  current_state <= 3'b100;
                                else        
                                  current_state <= 3'b010;
              current_state[2]: if(card_detect_chg)
                                  current_state <= 3'b010;
                                else        
                                  current_state <= 3'b001;
           endcase
         end
     end
 
endmodule  

