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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_2clk_dssram.v#8 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_2clk_dssram.v
// Description : Two clock dual port synchronous SRAM. Both the read and write
//               ports are synchronous.  
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_2clk_dssram (
  /*AUTOARG*/
  // Outputs
  ram_rd_data1, ram_rd_data2, 
  // Inputs
  clk1, ram_cs1_n, ram_wr1_n, ram_rd1_n, ram_addr1, ram_wr_data1,
  clk2, ram_cs2_n, ram_wr2_n, ram_rd2_n, ram_addr2, ram_wr_data2 
  ); 

  parameter DEPTH      = 16;           // default to 16 deep RAM
  parameter DATA_WIDTH = 32;           // default to 32 bit word.


  parameter ADDR_WIDTH = DEPTH <= 2 ? 1 :
                         DEPTH <= 4 ? 2 :
                         DEPTH <= 8 ? 3 :
                         DEPTH <= 16 ? 4 :
                         DEPTH <= 32 ? 5 :
                         DEPTH <= 64 ? 6 :
                         DEPTH <= 128 ? 7 :
                         DEPTH <= 256 ? 8 :
                         DEPTH <= 512 ? 9 :
                         DEPTH <= 1024 ? 10 : 
                         DEPTH <= 2048 ? 11 : 12;


  input                   clk1;                   // system clock
  input                   ram_cs1_n;              // active low chip select
  input                   ram_wr1_n;              // active low write enable 
  input                   ram_rd1_n;              // active low read 
  input  [ADDR_WIDTH-1:0] ram_addr1;              // read address 
  input  [DATA_WIDTH-1:0] ram_wr_data1;           // write input data
  output [DATA_WIDTH-1:0] ram_rd_data1;           // read output data

  input                   clk2;                   // system clock
  input                   ram_cs2_n;              // active low chip select
  input                   ram_wr2_n;              // active low write enable 
  input                   ram_rd2_n;              // active low read 
  input  [ADDR_WIDTH-1:0] ram_addr2;              // read address 
  input  [DATA_WIDTH-1:0] ram_wr_data2;           // write input data
  output [DATA_WIDTH-1:0] ram_rd_data2;           // read output data


 `ifdef FIFO_RAM_INSIDE_CORE 
  reg    [DATA_WIDTH-1:0] mem_array1 [DEPTH-1:0]; // Memory Array
  reg    [DATA_WIDTH-1:0] mem_array2 [DEPTH-1:0]; // Memory Array
  reg    [ADDR_WIDTH-1:0] ram_addr1_tmp;          // registered read address
  reg    [ADDR_WIDTH-1:0] ram_addr2_tmp;          // registered read address

  assign ram_rd_data1 = mem_array2[ram_addr1_tmp];
  assign ram_rd_data2 = mem_array1[ram_addr2_tmp];

  always @ (posedge clk1)
    begin
      if(!ram_cs1_n & !ram_wr1_n)
        mem_array1[ram_addr1] <= ram_wr_data1;

      if(!ram_cs1_n & ram_wr1_n)
        ram_addr1_tmp <= ram_addr1;
      // synopsys translate_off
      else
        ram_addr1_tmp <= {ADDR_WIDTH{1'bx}};
      // synopsys translate_on
    end

  always @ (posedge clk2)
    begin
      if(!ram_cs2_n & !ram_wr2_n)
        mem_array2[ram_addr2] <= ram_wr_data2;

      if(!ram_cs2_n & ram_wr2_n)
        ram_addr2_tmp <= ram_addr2;
      // synopsys translate_off
      else
        ram_addr2_tmp <= {ADDR_WIDTH{1'bx}};
      // synopsys translate_on
    end

 `else
  reg    [DATA_WIDTH-1:0] mem_array [DEPTH-1:0]; // Memory Array
  reg    [DATA_WIDTH-1:0] ram_rd_data1;          // read output data
  reg    [DATA_WIDTH-1:0] ram_rd_data2;          // read output data
  always @ (posedge clk1)
    begin
      if(!ram_cs1_n & !ram_wr1_n)
        mem_array[ram_addr1] <= ram_wr_data1;

      if(!ram_cs1_n & !ram_rd1_n)
        ram_rd_data1 <=  mem_array[ram_addr1];
      else
        ram_rd_data1 <= {DATA_WIDTH{1'bx}};
    end

  always @ (posedge clk2)
    begin
      if(!ram_cs2_n & !ram_wr2_n)
        mem_array[ram_addr2] <= ram_wr_data2;

      if(!ram_cs2_n & !ram_rd2_n)
        ram_rd_data2 <=  mem_array[ram_addr2];
      else
        ram_rd_data2 <= {DATA_WIDTH{1'bx}};
    end
 `endif

  // synopsys translate_off
  always @ (posedge clk1 or posedge clk2)  
    begin
      if(~ram_cs1_n && ~ram_cs2_n && ~ram_wr1_n && ~ram_wr2_n && 
        (ram_addr1 == ram_addr2))
        $display("DWC_mobile_storage_CHECKER Warning : Both Clock Domains Writting to Same Memory Loacation at %t", $time);
      if(~ram_cs1_n && ~ram_cs2_n && ~ram_wr1_n && ~ram_rd2_n && 
        (ram_addr1 == ram_addr2))
        $display("DWC_mobile_storage_CHECKER Warning : Clock1 Write and Clock2 Read Same Memory Loacation at %t", $time);
      if(~ram_cs1_n && ~ram_cs2_n && ~ram_wr2_n && ~ram_rd1_n && 
        (ram_addr1 == ram_addr2))
        $display("DWC_mobile_storage_CHECKER Warning : Clock2 Write and Clock1 Read Same Memory Loacation at %t", $time);
    end
  // synopsys translate_on

  endmodule
