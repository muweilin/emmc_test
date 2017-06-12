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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_clkmux_interleave.v#9 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_clkmux_interleave.v
// Description : DWC_mobile_storage clk mux and data interleaving Block
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_clkmux_interleave(
//Outputs
cdata_out_int,
//Input
toggle,
cdata_out_1,
ddr);

//ouput
output        [`NUM_CARD_BUS*8-1:0]cdata_out_int;


//Input
input           [`NUM_CARD_BUS-1:0]toggle;
input         [`NUM_CARD_BUS*8-1:0]cdata_out_1;
input                              ddr;

//Wire
reg            [`NUM_CARD_BUS-1:0] mux_sel1;

//register
reg           [`NUM_CARD_BUS*8-1:0]cdata_out_int;

integer                            i,k,l;

always @(toggle or ddr) begin
    for (i=0; i<= (`NUM_CARD_BUS-1); i=i+1) begin
      if(ddr == 1'b1)
          mux_sel1[i] = toggle[i];
    else 
      mux_sel1[i] = 1'b1;
  end
end  

always @(cdata_out_1 or mux_sel1 ) begin
    //for cdata_out_1[7:4];
    for(k=4;k<=`NUM_CARD_BUS*8-1;k=k+8)  begin//4,12,20,28......
        cdata_out_int[k]    =  cdata_out_1[k];   //[7:4] , [15:12] , [23:20]
    cdata_out_int[k+1]  =  cdata_out_1[k+1];
    cdata_out_int[k+2]  =  cdata_out_1[k+2];
    cdata_out_int[k+3]  =  cdata_out_1[k+3];
  //for cdata_out_1[3:0];
  end
    for(l=0;l<=(`NUM_CARD_BUS-1)*8;l=l+8) begin //0,8,16,24.......
        cdata_out_int[l]    =  mux_sel1[l/8] ? cdata_out_1[l]   : cdata_out_1[l+4]; //[3:0] , [11:8] , [19:16]  : [7:4] , [15:12]
    cdata_out_int[l+1]  =  mux_sel1[l/8] ? cdata_out_1[l+1] : cdata_out_1[l+5];
    cdata_out_int[l+2]  =  mux_sel1[l/8] ? cdata_out_1[l+2] : cdata_out_1[l+6];
    cdata_out_int[l+3]  =  mux_sel1[l/8] ? cdata_out_1[l+3] : cdata_out_1[l+7];
   end
end                     
  
endmodule



