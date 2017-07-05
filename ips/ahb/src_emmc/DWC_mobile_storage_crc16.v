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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_crc16.v#8 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_crc16.v
// Description : DWC_mobile_storage_crc16, CRC16 generation -
//               This module generates crc16 for serial
//               data input on assertion of start_crc
//               and outputs crc16 serially out on assertion on of send_crc.
//               CRC16 is simultaneously computed for 4 data line
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_crc16
  (
  /*AUTOARG*/
  // Outputs
  serial_crc,
  // Inputs
  cclk_in, cclk_in_en, creset_n, start_crc, send_crc, din
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------
  input         cclk_in;       // Card clock Signal
  input         cclk_in_en;    // Card clock enable Signal
  input         creset_n;      // Card Side async Reset Signal
  input         start_crc;     // Start CRC Generation
  input         send_crc;      // Send generated CRC serially out
  input   [7:0] din;           // Data Input
  output  [7:0] serial_crc;    // Serial CRC16 Output

  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Registers
  reg    [15:0] crc0;           // CRC16 register
  reg    [15:0] crc1;           // CRC16 register
  reg    [15:0] crc2;           // CRC16 register
  reg    [15:0] crc3;           // CRC16 register
  reg    [15:0] crc4;           // CRC16 register
  reg    [15:0] crc5;           // CRC16 register
  reg    [15:0] crc6;           // CRC16 register
  reg    [15:0] crc7;           // CRC16 register

  // Wires
  wire   [15:0] crc0_w;         // CRC16 wire
  wire   [15:0] crc1_w;         // CRC16 wire
  wire   [15:0] crc2_w;         // CRC16 wire
  wire   [15:0] crc3_w;         // CRC16 wire
  wire   [15:0] crc4_w;         // CRC16 wire
  wire   [15:0] crc5_w;         // CRC16 wire
  wire   [15:0] crc6_w;         // CRC16 wire
  wire   [15:0] crc7_w;         // CRC16 wire
  wire    [7:0] bit15;          // Temporary crc bit15 Signal

  // CRC16 Generation register logic
  always @(posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        crc0   <= 16'h0;
        crc1   <= 16'h0;
        crc2   <= 16'h0;
        crc3   <= 16'h0;
        crc4   <= 16'h0;
        crc5   <= 16'h0;
        crc6   <= 16'h0;
        crc7   <= 16'h0;
      end else begin
        if (cclk_in_en == 1'b1) begin
          crc0 <= crc0_w;
          crc1 <= crc1_w;
          crc2 <= crc2_w;
          crc3 <= crc3_w;
          crc4 <= crc4_w;
          crc5 <= crc5_w;
          crc6 <= crc6_w;
          crc7 <= crc7_w;
        end
      end
    end

  // crc16 generation and output combinational logic
  // CRC16 is simultaneously for 8 data bits
  assign bit15[0]  = din[0] ^ crc0[0];
  assign crc0_w    = (start_crc) ? 16'h0 : (send_crc) ? {1'b0,crc0[15:1]}:
                     {bit15[0], crc0[15:12], (bit15[0] ^ crc0[11]),
                      crc0[10:5], (bit15[0] ^ crc0[4]), crc0[3:1]};

  assign bit15[1]  = din[1] ^ crc1[0];
  assign crc1_w    = (start_crc) ? 16'h0 : (send_crc) ? {1'b0,crc1[15:1]}:
                     {bit15[1], crc1[15:12], (bit15[1] ^ crc1[11]),
                      crc1[10:5], (bit15[1] ^ crc1[4]), crc1[3:1]};

  assign bit15[2]  = din[2] ^ crc2[0];
  assign crc2_w    = (start_crc) ? 16'h0 : (send_crc) ? {1'b0,crc2[15:1]}:
                     {bit15[2], crc2[15:12], (bit15[2] ^ crc2[11]),
                      crc2[10:5], (bit15[2] ^ crc2[4]), crc2[3:1]};

  assign bit15[3]  = din[3] ^ crc3[0];
  assign crc3_w    = (start_crc) ? 16'h0 : (send_crc) ? {1'b0,crc3[15:1]}:
                     {bit15[3], crc3[15:12], (bit15[3] ^ crc3[11]),
                      crc3[10:5], (bit15[3] ^ crc3[4]), crc3[3:1]};

  assign bit15[4]  = din[4] ^ crc4[0];
  assign crc4_w    = (start_crc) ? 16'h0 : (send_crc) ? {1'b0,crc4[15:1]}:
                     {bit15[4], crc4[15:12], (bit15[4] ^ crc4[11]),
                      crc4[10:5], (bit15[4] ^ crc4[4]), crc4[3:1]};

  assign bit15[5]  = din[5] ^ crc5[0];
  assign crc5_w    = (start_crc) ? 16'h0 : (send_crc) ? {1'b0,crc5[15:1]}:
                     {bit15[5], crc5[15:12], (bit15[5] ^ crc5[11]),
                      crc5[10:5], (bit15[5] ^ crc5[4]), crc5[3:1]};

  assign bit15[6]  = din[6] ^ crc6[0];
  assign crc6_w    = (start_crc) ? 16'h0 : (send_crc) ? {1'b0,crc6[15:1]}:
                     {bit15[6], crc6[15:12], (bit15[6] ^ crc6[11]),
                      crc6[10:5], (bit15[6] ^ crc6[4]), crc6[3:1]};

  assign bit15[7]  = din[7] ^ crc7[0];
  assign crc7_w    = (start_crc) ? 16'h0 : (send_crc) ? {1'b0,crc7[15:1]}:
                     {bit15[7], crc7[15:12], (bit15[7] ^ crc7[11]),
                      crc7[10:5], (bit15[7] ^ crc7[4]), crc7[3:1]};

  assign serial_crc = {crc7[0],crc6[0],crc5[0],crc4[0],crc3[0],crc2[0],
                       crc1[0],crc0[0]};
  // output MSbit of generated crc16 for serial transmission
endmodule // DWC_mobile_storage_crc16
