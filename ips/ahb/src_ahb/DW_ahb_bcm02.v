
////////////////////////////////////////////////////////////////////////////////
//
//                  (C) COPYRIGHT 2004 - 2011 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
//  This software and the associated documentation are confidential and
//  proprietary to Synopsys, Inc.  Your use or disclosure of this
//  software is subject to the terms and conditions of a written
//  license agreement between you, or your company, and Synopsys, Inc.
//
//  The entire notice above must be reproduced on all authorized copies.
//
// Filename    : DW_ahb_bcm02.v
// Author      : Rick Kelly 10/7/04
// Description : DW_ahb_bcm02.v Verilog module for DWbb
//
// DesignWare IP ID: 6909e2df
//
////////////////////////////////////////////////////////////////////////////////





module DW_ahb_bcm02(
	a,
	sel,
	mux
	);

   parameter	A_WIDTH    = 8;  // width of input array
   parameter 	SEL_WIDTH  = 2;  // width of selection index
   parameter 	MUX_WIDTH  = 2;  // width of selected output
   
   input [A_WIDTH-1:0] a;	// input array to select from
   input [SEL_WIDTH-1:0] sel;	// selection index

   output [MUX_WIDTH-1:0] mux;	// selected output

   
  function [MUX_WIDTH-1:0] func_mux_any ;
    input [MUX_WIDTH*A_WIDTH/MUX_WIDTH-1:0]	a;	// input bus
    input [SEL_WIDTH-1:0]  	sel;	// select
    reg   [MUX_WIDTH-1:0]	z;
    // leda FM_2_35 off
    reg   [31:0]		i, j, k;
    // leda FM_2_35 on
    begin
      z = {MUX_WIDTH {1'b0}};
      k = 0;
      for (i=0 ; i<A_WIDTH/MUX_WIDTH ; i=i+1) begin
	if (i == sel) begin
	  for (j=0 ; j<MUX_WIDTH ; j=j+1) begin
	    z[j] = a[j + k];
	  end // for (j
	end // if
	k = k + MUX_WIDTH;
      end // for (i
      func_mux_any  = z;
    end
  endfunction

  assign mux = func_mux_any (a, sel);

   
endmodule
