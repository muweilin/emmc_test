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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_clk_mux_2x1.v#6 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_mux_2x1.v
// Description : DWC_mobile_storage Clock Mux
//               Clock selection between 2 input clocks
//               
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_clk_mux_2x1(
  /*AUTOARG*/
  // Outputs
  out_clk,
  // Inputs
  in0_clk, in1_clk, clk_sel
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clocks
  input                        in0_clk;          // Clock0 input
  input                        in1_clk;          // Clock1 input

  //Mux select
  input                        clk_sel;          // clock select

  output                       out_clk;          // clock output

  wire                         out_clk;

  assign out_clk = clk_sel? in1_clk:in0_clk; 

endmodule // DWC_mobile_storage_mux_2x1
