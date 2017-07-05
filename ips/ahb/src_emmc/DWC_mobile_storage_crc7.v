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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_crc7.v#8 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_crc7.v
// Description : DWC_mobile_storage_crc7, CRC7 generation
//               Generate CRC7 for command transmission
//               and response checking
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_crc7
  (
   /*AUTOARG*/
  // Outputs
  serial_crc,
  // Inputs
  cclk_in, cclk_in_en, creset_n, start_crc, send_serial_crc, din
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------
  input        cclk_in;        // Card Clock Signal
  input        cclk_in_en;     // Card Clock enable Signal
  input        creset_n;       // Card Side async Reset Signal
  input        start_crc;      // Start CRC Generation
  input        send_serial_crc;// Send generated CRC serially out
  input        din;            // Data Input

  output       serial_crc;     // Serial CRC7 Output

  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------
  reg    [6:0] crc_reg;        // CRC7 register
  wire   [6:0] crc_w;          // CRC7 wire
  wire         bit6;           // Temporary Signal

  // CRC7 Generation register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        crc_reg <= 7'h0;
      end else begin
        if (cclk_in_en) begin
          crc_reg <= crc_w;
        end else begin
          crc_reg <= crc_reg;
        end
      end
    end

  //crc7 generation combinational logic
  assign crc_w       = (start_crc) ? 7'h0 : (send_serial_crc) ?
                       {1'b0,crc_reg[6:1]} :
                       {bit6,crc_reg[6:5],(bit6^crc_reg[4]),crc_reg[3:1]};
  assign bit6        = din ^ crc_reg[0];
  assign serial_crc  = crc_reg[0];
endmodule
