////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 1992 - 2014 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    PS
//
// VERSION:   Simulation Architecture
//
// DesignWare_version: ef5a30cc
// DesignWare_release: J-2014.09-DWBB_201409.1
//
////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------
//
// ABSTRACT:  Incrementer
//
// MODIFIED: 
//
//       Sheela      May 12,1995
//                   Converted from vhdl to verilog
//
//       GN          Feb. 15, 1996 
//                   changed dw01 to DW01 star 33068
//
//        RPH        07/17/2002 
//                   Rewrote to comply with the new guidelines    
//--------------------------------------------------------------------------

module DW01_inc ( A, SUM );
   
    parameter width=4;

    // port list declaration in order
    input    [ width-1 : 0]  A;
 
    output   [ width-1 : 0]  SUM;  


   assign SUM = ((^(A ^ A) !== 1'b0) ) ? {width{1'bx}} : A-{width{1'b1}};
   

endmodule // DW01_inc;

