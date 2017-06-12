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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_2clk_fifoctl.v#16 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_2clk_fifoctl.v
// Description : This is a dual clock FIFO controller implemented using dual  
//               port (synchronous read and synchronous write port) ram. Since 
//               gray counters are used for fast pointer transfers the FIFO
//               depth need to be in 2's power.
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_2clk_fifoctl (
  /*AUTOARG*/
  // Outputs
  empty1, empty2, full1, full2, almost_empty1, almost_full1,
  almost_empty2, almost_full2, less_or_equal1, less_or_equal2, 
  greater_than1, greater_than2, count1, count2, fifo_dout1, 
  fifo_dout2, ram_cs1_n, ram_wr1_n, ram_rd1_n, ram_addr1, 
  ram_wr_data1, ram_cs2_n, ram_wr2_n, ram_rd2_n, ram_addr2, 
  ram_wr_data2,atleast_empty, 
  // Inputs
  clk1, clk2, reset1_n, reset2_n, clear_pointers1, clear_pointers2, 
  push1, push2, pop1, pop2, less_equal_thresh1, less_equal_thresh2, 
  greater_than_thresh1, greater_than_thresh2, fifo_din1, fifo_din2, 
  ram_rd_data1, ram_rd_data2, card_rd_threshold_size
  );

  // Module Parameters 
  parameter DEPTH = 16;
  parameter DATA_WIDTH = 32;

  // Derived Parameters
  parameter      log2 = DEPTH == 2 ? 1 :
                        DEPTH == 4 ? 2 :
                        DEPTH == 8 ? 3 :
                        DEPTH == 16 ? 4 :
                        DEPTH == 32 ? 5 :
                        DEPTH == 64 ? 6 :
                        DEPTH == 128 ? 7 :
                        DEPTH == 256 ? 8 :
                        DEPTH == 512 ? 9 :
                        DEPTH == 1024 ? 10 : 
                        DEPTH == 2048 ? 11 : 12;

  // FIFO Input Output Ports
  input                    clk1;                 // system clock-1
  input                    clk2;                 // system clock-2
  input                    reset1_n;             // system reset - active low-1
  input                    reset2_n;             // system reset - active low-2
  input                    clear_pointers1;      // Clear Pointers-1 
  input                    clear_pointers2;      // Clear Pointers-2 
  input                    push1;                // push fifo data-1
  input                    push2;                // push fifo data-2
  input                    pop1;                 // pop fifo data-1
  input                    pop2;                 // pop fifo data-2
  input           [log2:0] less_equal_thresh1;   // less or equal threshhold-1
  input           [log2:0] less_equal_thresh2;   // less or equal threshhold-2
  input           [log2:0] greater_than_thresh1; // greater than threshhold -1
  input           [log2:0] greater_than_thresh2; // greater than threshhold-2 
  input   [DATA_WIDTH-1:0] fifo_din1;            // fifo input data-1
  input   [DATA_WIDTH-1:0] fifo_din2;            // fifo input data-2

  output                   empty1;               // fifo empty-1
  output                   empty2;               // fifo empty-2
  output                   full1;                // fifo full-1
  output                   full2;                // fifo full-2
  output                   almost_empty1;        // fifo almost empty-1
  output                   almost_empty2;        // fifo almost empty-2
  output                   almost_full1;         // fifo almost full-1
  output                   almost_full2;         // fifo almost full-2
  output                   less_or_equal1;       // <= less or equal-1
  output                   less_or_equal2;       // <= less or equal-2
  output                   greater_than1;        // >= greater than-1
  output                   greater_than2;        // >= greater than-2
  output          [log2:0] count1;               // Fifo Count-1 
  output          [log2:0] count2;               // Fifo Count-2 
  output  [DATA_WIDTH-1:0] fifo_dout1;           // fifo output data-1
  output  [DATA_WIDTH-1:0] fifo_dout2;           // fifo output data-2

  // DUAL Port Synchronous Ram Ports
  output                   ram_cs1_n;            // ram chipsel-1 - active low
  output                   ram_wr1_n;            // ram write-1 - active low
  output                   ram_rd1_n;            // ram read-1 - active low
  output        [log2-1:0] ram_addr1;            // ram address-1
  output  [DATA_WIDTH-1:0] ram_wr_data1;         // ram write data-1 
  input   [DATA_WIDTH-1:0] ram_rd_data1;         // ram read data-1 

  output                   ram_cs2_n;            // ram chipsel-2 - active low
  output                   ram_wr2_n;            // ram write-2 - active low
  output                   ram_rd2_n;            // ram read-2 - active low
  output        [log2-1:0] ram_addr2;            // ram address-2
  output  [DATA_WIDTH-1:0] ram_wr_data2;         // ram write data-2
 output                   atleast_empty;
  input   [DATA_WIDTH-1:0] ram_rd_data2;         // ram read data-2 
 input [`F_BYTE_WIDTH-1:0]card_rd_threshold_size;

  // gray2bin 
  function [log2:0] gray2bin;
    input  [log2:0] gray;

    integer i;

    begin
      gray2bin[log2] = gray[log2];
      for (i=(log2-1); i >=0; i = i-1)
        gray2bin[i] = gray2bin[i+1] ^ gray[i];
    end
  endfunction


  // bin2gray
  function [log2:0] bin2gray;
    input  [log2:0] bina;

    begin
       bin2gray  = {bina[log2], (bina[log2:1] ^ bina[log2-1:0])};
    end
  endfunction


  reg     [DATA_WIDTH-1:0] fifo_dout1;          
  reg             [log2:0] wr_ptr1;
  reg             [log2:0] wr_ptr1_gry;
  reg             [log2:0] rd_ptr1;
  reg             [log2:0] rd_ptr1_gry;
  reg             [log2:0] wr_ptr_gry_from_clk2_d;
  reg             [log2:0] wr_ptr_gry_from_clk2_2d;
  reg             [log2:0] wr_ptr_from_clk2_3d;
  reg             [log2:0] wr_ptr_from_clk2_nxt;
  reg             [log2:0] wr_ptr_from_clk2;
  reg             [log2:0] rd_ptr_gry_from_clk2_d;
  reg             [log2:0] rd_ptr_gry_from_clk2_2d;
  reg             [log2:0] rd_ptr_from_clk2_nxt;
  reg             [log2:0] rd_ptr_from_clk2;
  wire            [log2:0] wr_ptr1_nxt;
  wire            [log2:0] rd_ptr1_nxt;
  wire            [log2:0] wr_ptr_from_clk2_erly;
  wire            [log2:0] rd_ptr_from_clk2_erly;

  reg             [log2:0] wr_ptr2;
  reg             [log2:0] wr_ptr2_gry;
  reg             [log2:0] rd_ptr2;
  reg             [log2:0] rd_ptr2_gry;
  reg             [log2:0] wr_ptr_gry_from_clk1_d;
  reg             [log2:0] wr_ptr_gry_from_clk1_2d;
  reg             [log2:0] wr_ptr_from_clk1_nxt;
  reg             [log2:0] wr_ptr_from_clk1;
  reg             [log2:0] rd_ptr_gry_from_clk1_d;
  reg             [log2:0] rd_ptr_gry_from_clk1_2d;
  reg             [log2:0] rd_ptr_from_clk1_nxt;
  reg             [log2:0] rd_ptr_from_clk1;
  reg             [log2:0] count1;               // Fifo Count-1 
  reg             [log2:0] count2;               // Fifo Count-2 
  wire            [log2:0] wr_ptr2_nxt;
  wire            [log2:0] rd_ptr2_nxt;
  wire            [log2:0] wr_ptr_from_clk1_erly;
  wire            [log2:0] rd_ptr_from_clk1_erly;
  reg                      empty1_erly3;               
  wire                     empty1_erly3_nxt;               

  wire                     safe_push1;          // No push when full
  wire                     safe_push2;          // No push when full
  wire                     safe_pop1;           // No pop when empty
  wire                     safe_pop2;           // No pop when empty
  wire                     empty1_erly1;
  wire                     empty1_erly2;
  wire                     empty2_erly;

  wire          [log2+1:0] count_at1_nxt;               // Fifo Count-1 
  wire          [log2+1:0] count_at2_nxt;               // Fifo Count-1 
  wire          [log2+1:0] count_frm1_nxt;              // Fifo Count-1 
  wire          [log2+1:0] count_frm2_nxt;              // Fifo Count-1 
  wire          [log2+1:0] adj_diff;            // Adjusted Difference
 wire   [`F_BYTE_WIDTH:0] space_avail_bytes;   //Space available in the fifo in bytes rounded off to the highest dword. 
                           //1 extra bit to handle the Subtraction

  assign almost_empty1     = count1 == 1;
  assign almost_empty2     = count2 == 1;
  assign almost_full1      = (count1 == (DEPTH-1));
  assign almost_full2      = (count2 == (DEPTH-1));
 //convert to bytes
 `ifdef F_DATA_WIDTH_32
  assign space_avail_bytes = ((DEPTH - count2) << 2);
  `else // if (`F_DATA_WIDTH == 64)
  assign space_avail_bytes = ((DEPTH - count2) << 3);
 `endif
  assign atleast_empty     = (space_avail_bytes[`F_BYTE_WIDTH-1:0] >= card_rd_threshold_size);

  assign full1             = count1 == DEPTH;
  assign full2             = count2 == DEPTH;
  assign empty1            = count1 == 0;
  assign empty2            = count2 == 0;

  assign less_or_equal1    = (count1 <= less_equal_thresh1);
  assign greater_than1     = (count1 > greater_than_thresh1);
  assign less_or_equal2    = (count2 <= less_equal_thresh2);
  assign greater_than2     = (count2 > greater_than_thresh2);
 
  assign safe_push1        = push1;
  assign safe_push2        = push2; 
  assign safe_pop1         = pop1;        
  assign safe_pop2         = pop2;       

  assign count_at2_nxt     = (wr_ptr2_nxt >= rd_ptr_from_clk1_nxt) ?
                               (wr_ptr2_nxt - rd_ptr_from_clk1_nxt) :
                               ((2*DEPTH) - (rd_ptr_from_clk1_nxt-wr_ptr2_nxt));
  assign count_frm2_nxt    = (wr_ptr_from_clk2_nxt >= rd_ptr1_nxt) ?
                               (wr_ptr_from_clk2_nxt - rd_ptr1_nxt) :
                               ((2*DEPTH) - (rd_ptr1_nxt-wr_ptr_from_clk2_nxt));
  assign count_at1_nxt     = (wr_ptr1_nxt >= rd_ptr_from_clk2_nxt) ?
                               (wr_ptr1_nxt - rd_ptr_from_clk2_nxt) :
                               ((2*DEPTH) - (rd_ptr_from_clk2_nxt-wr_ptr1_nxt));
  assign count_frm1_nxt    = (wr_ptr_from_clk1_nxt >= rd_ptr2_nxt) ?
                               (wr_ptr_from_clk1_nxt - rd_ptr2_nxt) :
                               ((2*DEPTH) - (rd_ptr2_nxt-wr_ptr_from_clk1_nxt));

  assign ram_wr_data1      = fifo_din1;
  assign ram_wr_data2      = fifo_din2;
  assign fifo_dout2        = ram_rd_data2;

  assign empty1_erly1      = (rd_ptr1[log2:0] == wr_ptr_from_clk2_3d[log2:0]);
  assign empty1_erly2      = (rd_ptr1[log2:0] == wr_ptr_from_clk2_nxt[log2:0]);

  assign empty2_erly       = (rd_ptr2[log2:0] == wr_ptr_from_clk1_nxt[log2:0]);

  // Early empty flags are used to enable the read to pipeline data
  // and also data can be poped on the same clock empty goes inactive. 
  assign ram_rd1_n         = (empty1_erly3 & empty1_erly1 & empty1_erly2 & 
                             (count1==0)) || ~ram_wr1_n;
  assign ram_rd2_n         = (empty2 & empty2_erly & (count2==0)) || ~ram_wr2_n ;  
  assign ram_wr1_n         = ~safe_push1;
  assign ram_wr2_n         = ~safe_push2;
  assign ram_cs1_n         = ram_wr1_n & ram_rd1_n;
  assign ram_cs2_n         = ram_wr2_n & ram_rd2_n;


  // synopsys translate_off
  `ifdef DWC_mobile_storage_CHECKER_ON
  always @ (posedge clk1)
    begin
      if((push1 & full1) | (pop1 & empty1))
        $display("DWC_mobile_storage_CHECKER Warning : clk1 Fifo Overflow/UnderFlow at %t",
                 $time);
    end        
  always @ (posedge clk2)
    begin
      if((push2 & full2) | (pop2 & empty2))
        $display("DWC_mobile_storage_CHECKER Warning : clk2 Fifo Overflow/UnderFlow at %t",
                 $time);
    end        
  `endif
  // synopsys translate_on


  assign adj_diff = (wr_ptr_from_clk2_3d > rd_ptr1)? 
                         (wr_ptr_from_clk2_3d - rd_ptr1):
                         ((2*DEPTH) - (rd_ptr1 - wr_ptr_from_clk2_3d));

  // Clock Domain 1 Pointers
  assign wr_ptr1_nxt = safe_push1?  (wr_ptr1 + 1) : wr_ptr1;
  assign rd_ptr1_nxt = safe_pop1?   (rd_ptr1 + 1) : rd_ptr1;
  assign ram_addr1   = safe_push1?                      wr_ptr1[log2-1:0] : 
                      (safe_pop1 & ~empty1_erly3_nxt & adj_diff >2)? (rd_ptr1[log2-1:0] + 2) :
                      (~empty1_erly1 & empty1_erly2)?   rd_ptr1[log2-1:0] :
                      (adj_diff > 1)? (rd_ptr1[log2-1:0]+1):
                                                       (rd_ptr1[log2-1:0]);

  // AHB Side Ram Data is registered  before being send to AHB bus
  // to meet high AHB frequency requirement.
  always @ (posedge clk1 or negedge reset1_n)
    begin 
      if(~reset1_n)
        fifo_dout1 <= 0;
      else
        if((~empty1_erly2 & empty1_erly3) | safe_pop1)
          fifo_dout1 <= ram_rd_data1;
    end
 
  
  assign empty1_erly3_nxt = clear_pointers1 | 
                           (rd_ptr1_nxt == wr_ptr_from_clk2_nxt);

  always @ (posedge clk1 or negedge reset1_n)
    begin 
      if(~reset1_n)
        begin 
          wr_ptr1          <= 0;
          wr_ptr1_gry      <= 0;
          rd_ptr1          <= 0;
          rd_ptr1_gry      <= 0;
          count1           <= 0;
          empty1_erly3     <= 1'b1;
        end
    else
      begin
        wr_ptr1        <= clear_pointers1? 0 : wr_ptr1_nxt;
        wr_ptr1_gry    <= clear_pointers1? 0 : bin2gray(wr_ptr1_nxt);
        rd_ptr1        <= clear_pointers1? 0 : rd_ptr1_nxt;
        rd_ptr1_gry    <= clear_pointers1? 0 : bin2gray(rd_ptr1_nxt);
        count1         <= clear_pointers1? 0 : 
                          (wr_ptr1_nxt == rd_ptr_from_clk2_nxt)? 
                                       count_frm2_nxt : count_at1_nxt;
        empty1_erly3   <= empty1_erly3_nxt;
      end 
   end 

  assign wr_ptr_from_clk2_erly = gray2bin(wr_ptr_gry_from_clk2_2d);
  assign rd_ptr_from_clk2_erly = gray2bin(rd_ptr_gry_from_clk2_2d);

  // transported pointers from clk2 domain
  // Two additional pipelines in wr_ptr_gry_from_clk2, so that
  // data from ram can be registered in a temporary before being passed
  // to the AHB bus  
  always @ (posedge clk1 or negedge reset1_n)
    begin
      if(~reset1_n)
        begin
          wr_ptr_gry_from_clk2_d  <= 0;
          wr_ptr_gry_from_clk2_2d <= 0;
          wr_ptr_from_clk2_3d     <= 0;
          wr_ptr_from_clk2_nxt    <= 0;
          wr_ptr_from_clk2        <= 0;

          rd_ptr_gry_from_clk2_d  <= 0;
          rd_ptr_gry_from_clk2_2d <= 0;
          rd_ptr_from_clk2_nxt    <= 0;
          rd_ptr_from_clk2        <= 0;
        end
      else 
        begin
          wr_ptr_gry_from_clk2_d  <= clear_pointers1? 0: wr_ptr2_gry;
          wr_ptr_gry_from_clk2_2d <= clear_pointers1? 0: wr_ptr_gry_from_clk2_d;
          wr_ptr_from_clk2_3d     <= clear_pointers1? 0: wr_ptr_from_clk2_erly;
          wr_ptr_from_clk2_nxt    <= clear_pointers1? 0: wr_ptr_from_clk2_3d;
          wr_ptr_from_clk2        <= clear_pointers1? 0: wr_ptr_from_clk2_nxt;

          rd_ptr_gry_from_clk2_d  <= clear_pointers1? 0: rd_ptr2_gry;
          rd_ptr_gry_from_clk2_2d <= clear_pointers1? 0: rd_ptr_gry_from_clk2_d;
          rd_ptr_from_clk2_nxt    <= clear_pointers1? 0: rd_ptr_from_clk2_erly;
          rd_ptr_from_clk2        <= clear_pointers1? 0: rd_ptr_from_clk2_nxt;
        end
    end
 
  // Clock Domain 2 Pointers
  assign wr_ptr2_nxt = safe_push2? (wr_ptr2 + 1) : wr_ptr2;
  assign rd_ptr2_nxt = safe_pop2?  (rd_ptr2 + 1) : rd_ptr2;
  assign ram_addr2   = safe_push2? wr_ptr2[log2-1:0] : rd_ptr2[log2-1:0];

  always @ (posedge clk2 or negedge reset2_n)
    begin
      if(~reset2_n)
        begin
          wr_ptr2          <= 0;
          wr_ptr2_gry      <= 0;
          rd_ptr2          <= 0;
          rd_ptr2_gry      <= 0;
          count2           <= 0;
        end
    else
      begin
        wr_ptr2        <= clear_pointers2? 0 : wr_ptr2_nxt;
        wr_ptr2_gry    <= clear_pointers2? 0 : bin2gray(wr_ptr2_nxt);
        rd_ptr2        <= clear_pointers2? 0 : rd_ptr2_nxt;
        rd_ptr2_gry    <= clear_pointers2? 0 : bin2gray(rd_ptr2_nxt);
        count2         <= clear_pointers2? 0 : 
                          (wr_ptr2_nxt == rd_ptr_from_clk1_nxt)? 
                                  count_frm1_nxt : count_at2_nxt;
      end
   end

  assign wr_ptr_from_clk1_erly = gray2bin(wr_ptr_gry_from_clk1_2d);
  assign rd_ptr_from_clk1_erly = gray2bin(rd_ptr_gry_from_clk1_2d);

  // transported pointers from clk1 domain
  // One extra pipeline in the controller to support pipelined flags 
  // to support 350+ MHz AHB frequency 
  always @ (posedge clk2 or negedge reset2_n)
    begin
      if(~reset2_n)
        begin
          wr_ptr_gry_from_clk1_d  <= 0;
          wr_ptr_gry_from_clk1_2d <= 0;
          wr_ptr_from_clk1_nxt    <= 0;
          wr_ptr_from_clk1        <= 0;

          rd_ptr_gry_from_clk1_d  <= 0;
          rd_ptr_gry_from_clk1_2d <= 0;
          rd_ptr_from_clk1_nxt    <= 0;
          rd_ptr_from_clk1        <= 0;
        end
      else 
        begin
          wr_ptr_gry_from_clk1_d  <= clear_pointers2? 0: wr_ptr1_gry;
          wr_ptr_gry_from_clk1_2d <= clear_pointers2? 0: wr_ptr_gry_from_clk1_d;
          wr_ptr_from_clk1_nxt    <= clear_pointers2? 0: wr_ptr_from_clk1_erly;
          wr_ptr_from_clk1        <= clear_pointers2? 0: wr_ptr_from_clk1_nxt;

          rd_ptr_gry_from_clk1_d  <= clear_pointers2? 0: rd_ptr1_gry;
          rd_ptr_gry_from_clk1_2d <= clear_pointers2? 0: rd_ptr_gry_from_clk1_d;
          rd_ptr_from_clk1_nxt    <= clear_pointers2? 0: rd_ptr_from_clk1_erly;
          rd_ptr_from_clk1        <= clear_pointers2? 0: rd_ptr_from_clk1_nxt;
        end
   end

endmodule

