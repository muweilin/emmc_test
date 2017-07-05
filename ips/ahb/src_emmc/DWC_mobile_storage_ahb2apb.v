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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_ahb2apb.v#8 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_ahb2apb.v
// Description : AHB to APB gasket designed for interfacing DWC_mobile_storage to AHB.
//               This gasket makes use of the two non APB sideband features 
//               provided in the DWC_mobile_storage interface: BYTE-ENABLES support and 
//               one clock burst access to FIFO area by keeping "penable" active
//               continuously. This Gasket can be used as a generic AHB to APB 
//               Gasket (no sideband burst feature) by setting the "FOR_SD_MMC" 
//               parameter to 1'b0; 
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_ahb2apb (
 /*AUTOARG*/
  // Outputs
  hready_resp, hresp, hrdata, psel, penable, pwrite, paddr, pbe, 
  pwdata, 
  // Inputs
  clk, reset_n, haddr, hsel, hwrite, htrans, hsize, hburst, hready, 
  hwdata, hbig_endian, prdata
  );

  parameter FOR_SD_MMC      = 1'b1;  // 1 clock burst support for fifo area
  parameter BYTE_EN_SUPPORT = 1'b1;  // Byte-enable Support, else pbe = 1's

 
  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  // Clock and Reset
  input                         clk;           // System Clock
  input                         reset_n;       // System Reset - Active Low

  // AHB
  input     [`H_ADDR_WIDTH-1:0] haddr;         // AHB Address Bus
  input                         hsel;          // AHB Device Select
  input                         hwrite;        // AHB Transfer Direction
  input                   [1:0] htrans;        // AHB Transfer Type
  input                   [2:0] hsize;         // AHB Transfer Size
  input                   [2:0] hburst;        // AHB Burst Type
  output                        hready_resp;   // AHB Transfer Done - Out
  input                         hready;        // AHB Transfer Done - In
  output                  [1:0] hresp;         // AHB Transfer Response
  input     [`H_DATA_WIDTH-1:0] hwdata;        // AHB Write Data
  output    [`H_DATA_WIDTH-1:0] hrdata;        // AHB Read Data
  input                         hbig_endian;   // AHB Big Indian Mode

  // APB
  output                        psel;          // APB Peripheral Select Signal
  output                        penable;       // APB Strobe Signal
  output                        pwrite;        // APB Write Signal
  output    [`H_ADDR_WIDTH-1:0] paddr;         // APB Address bus
  output  [`H_DATA_WIDTH/8-1:0] pbe;           // APB Byte Enable
  output    [`H_DATA_WIDTH-1:0] pwdata;        // APB Write data Bus
  input     [`H_DATA_WIDTH-1:0] prdata;        // APB Read Data Bus



  //-------------------------------------------------------------------------
  // AMBA specification local parameters
  //-------------------------------------------------------------------------

  parameter                  IDLE   = 2'b00,      // AMBA HTRANS
                             BUSY   = 2'b01,
                             NONSEQ = 2'b10,
                             SEQ    = 2'b11;

  parameter                  SINGLE = 3'b000,     // AMBA HBURST
                             INCR   = 3'b001,
                             WRAP4  = 3'b010,
                             INCR4  = 3'b011,
                             WRAP8  = 3'b100,
                             INCR8  = 3'b101,
                             WRAP16 = 3'b110,
                             INCR16 = 3'b111;

  parameter                  OKAY  = 2'b00,       // AMBA HRESP
                             ERROR = 2'b01,
                             RETRY = 2'b10,
                             SPLIT = 2'b11;
 
  parameter                  BYTE       = 3'b000, //   8 bits, AMBA HSIZE
                             HALFWORD   = 3'b001, //  16 bits
                             WORD       = 3'b010, //  32 bits
                             DOUBLEWORD = 3'b011, //  64 bits
                             FOURWORD   = 3'b100; // 128 bits

  // Port Register Declarations
  reg                        pwrite;
  reg                        psel;
  reg    [`H_ADDR_WIDTH-1:0] paddr;
  reg    [`H_DATA_WIDTH-1:0] pwdata;
  reg    [`H_DATA_WIDTH-1:0] hrdata;
  reg  [`H_DATA_WIDTH/8-1:0] pbe;         

  // Internal Register Declarations
  reg                  [3:0] current_state; // State-Machine Current State
  reg                  [3:0] next_state;    // State-Machine next State
  reg  [`H_DATA_WIDTH/8-1:0] next_pbe;      // Next Byte Enable
  reg                        big_endian;    // Registered hbig_endian
  reg                        prev_fifosel;  // Previous Cycle FIFO was selected
  reg                        prev_hwrite;   // Previous hwrite
  // Internal Wires Declarations
  wire                       fifo_addr;     // FIFO Data Address Range
  wire                       dev_sel;       // Device Selected
  wire                [63:0] iwdata;        // Internal Write Data
  wire                [63:0] irdata;        // Internal Read Data

 
  // Internal temporary Data assignments, to work around parameterized data
  // bus sizing 
  assign iwdata[`H_DATA_WIDTH-1:0] = hwdata[`H_DATA_WIDTH-1:0];
  assign irdata[`H_DATA_WIDTH-1:0] = prdata[`H_DATA_WIDTH-1:0];

  // Internal decodeds 
  assign fifo_addr   = |haddr[`H_ADDR_WIDTH-1:8];
  assign dev_sel     = hready & hsel & (htrans == NONSEQ || htrans == SEQ);

  // Output assignments
  assign hready_resp = ~current_state[1];
  assign penable     = current_state[2];
  assign hresp       = OKAY;

  // Next Byte Enable Generation
  always @ (hsize or haddr)
    begin
      if(`H_DATA_WIDTH == 16)
        case(hsize)
          BYTE:     next_pbe = 2'b01 << haddr[0];
          default:  next_pbe = 2'b11;
        endcase
      else if(`H_DATA_WIDTH == 32)
        case(hsize)
          BYTE:     next_pbe = 4'b0001 << haddr[1:0];
          HALFWORD: next_pbe = haddr[1]? 4'b1100 : 4'b0011;
          default:  next_pbe = 4'b1111;
        endcase
      else // if(`H_DATA_WIDTH == 64)
        case(hsize)
          BYTE:     next_pbe = 8'b0000_0001 << haddr[2:0];
          HALFWORD: next_pbe = 8'b0000_0011 << {haddr[2:1], 1'b0};
          WORD:     next_pbe = haddr[2]? 8'b1111_0000 : 8'b0000_1111; 
          default:  next_pbe = 8'b1111_1111;
        endcase
    end

 // Endianness fix for pwdata Generation 
  always @ (hwdata or iwdata or big_endian)
    begin
      if(~big_endian)      // Little Endian
        pwdata = hwdata;
      else                 // Big    Endian
        if(`H_DATA_WIDTH == 16)
          pwdata = {iwdata[7:0], iwdata[15:8]}; 
        else if(`H_DATA_WIDTH == 32)
          pwdata = {iwdata[7:0], iwdata[15:8], iwdata[23:16], iwdata[31:24]}; 
        else 
          pwdata = {iwdata[7:0],   iwdata[15:8],  iwdata[23:16], iwdata[31:24],
                    iwdata[39:32], iwdata[47:40], iwdata[55:48], iwdata[63:56]};
    end 

  // Endianness fix for hrdata Generation
  always @ (prdata or irdata or big_endian)
    begin
      if(~big_endian)      // Little Endian
        hrdata = prdata;
      else                 // Big    Endian
        if(`H_DATA_WIDTH == 16)
          hrdata = {irdata[7:0], irdata[15:8]};
        else if(`H_DATA_WIDTH == 32)
          hrdata = {irdata[7:0], irdata[15:8], irdata[23:16], irdata[31:24]};
        else
          hrdata = {irdata[7:0],   irdata[15:8],  irdata[23:16], irdata[31:24],
                    irdata[39:32], irdata[47:40], irdata[55:48], irdata[63:56]};

    end 

  // paddr, pwrite, pbe, and psel Generation 
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          paddr  <= {`H_ADDR_WIDTH{1'b0}};
          pwrite <= 1'b0;
          pbe    <= (BYTE_EN_SUPPORT == 1'b1)? {`H_DATA_WIDTH/8{1'b0}} :
                                               {`H_DATA_WIDTH/8{1'b1}} ;
        end
      else
        begin
          if(hready)
            begin
              paddr  <= haddr;
              pwrite <= hwrite;
              pbe    <= (BYTE_EN_SUPPORT == 1'b1)? next_pbe :
                                                   {`H_DATA_WIDTH/8{1'b1}};
            end
        end
    end


  // Simple State Machine to track the AHB cycles. Made one hot, so some
  // of the states can be directly assigned to outputs.

  always @ (current_state or dev_sel or hready or hsel or fifo_addr or
            htrans or prev_fifosel or prev_hwrite or hwrite)
    begin
      next_state = 4'b0001;
      case(1'b1)
        current_state[0]: if(dev_sel) 
                            next_state = 4'b0010; 
                          else
                            next_state = 4'b0001; 
 
        current_state[1]: next_state = 4'b0100;
      
        current_state[2]: if(dev_sel & fifo_addr & prev_fifosel & 
                            (hwrite == prev_hwrite) & (FOR_SD_MMC == 1'b1))
                            next_state = 4'b0100;
                          else if(hsel & hready & fifo_addr & prev_fifosel &
                           (htrans == BUSY) & (hwrite == prev_hwrite) &
                           (FOR_SD_MMC == 1'b1))
                            next_state = 4'b1000;
                          else if(dev_sel)
                            next_state = 4'b0010;
                          else
                            next_state = 4'b0001;

        current_state[3]: if(dev_sel & fifo_addr)
                            next_state = 4'b0100; 
                          else if(dev_sel) 
                            next_state = 4'b0010; 
                          else if(hready & (~hsel | (htrans == IDLE)))
                            next_state = 4'b0001; 
                          else 
                            next_state = 4'b1000; 
      endcase 
    end
                              
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          current_state <= 4'b0001;
          psel          <= 1'b0;
          prev_fifosel  <= 1'b0;
          prev_hwrite   <= 1'b0;
          big_endian    <= 1'b0;
        end
      else
        begin
          current_state   <= next_state;
          psel            <= next_state[1] | next_state[2] | next_state[3];
          if(hready)
            begin
              prev_fifosel  <= dev_sel & fifo_addr;
              prev_hwrite   <= hwrite;
            end
          if(next_state[1])
            big_endian    <= hbig_endian;
        end
    end

      
endmodule // 

 
