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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_clk_mux_4x1.v#7 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_mux_4x1.v
// Description : DWC_mobile_storage Clock Mux
//               Clock divider and card clock generation according
//               to clock divider and clock source register setting mux.
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_clk_mux_4x1(
  /*AUTOARG*/
  // Outputs
  out_clk,
  // Inputs
  in0_clk, in1_clk, in2_clk, in3_clk, clk_sel
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clocks
  input                        in0_clk;          // Clock0 input
  input                        in1_clk;          // Clock1 input
  input                        in2_clk;          // Clock2 input
  input                        in3_clk;          // Clock3 input

  //Mux select
  input                 [1:0]  clk_sel;          // clock select

  output                       out_clk;          // clock output

  reg                          out_clk;

  always @ (in0_clk or in1_clk or in2_clk or in3_clk or clk_sel)
    begin
      case (clk_sel)
        2'b00: out_clk = in0_clk;
        2'b01: out_clk = in1_clk;
        2'b10: out_clk = in2_clk;
        default: out_clk = in3_clk;
      endcase
    end
 
endmodule // DWC_mobile_storage_mux_4x1
