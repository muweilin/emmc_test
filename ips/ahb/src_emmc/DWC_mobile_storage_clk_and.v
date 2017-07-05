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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_clk_and.v#6 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_clk_and.v
// Description : DWC_mobile_storage Clock AND gate
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_clk_and(
  /*AUTOARG*/
  // Outputs
  Y,
  // Inputs
  A, B
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clocks
  input                        A;          // Clock0 input
  input                        B;          // Clock1 input

  output                       Y;          // clock output

  wire                         Y;

  assign Y = A & B;
endmodule // DWC_mobile_storage_and
