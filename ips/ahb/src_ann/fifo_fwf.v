////////////////////////////////////////////////////////////////////////////////////
// File Name: fifo_fwf.v
// Author: Sung Min Kim
// Email: sungk9@uw.edu
//
// Copyright (c) 2012-2016 University of Washington
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// -       Redistributions of source code must retain the above copyright notice,
//         this list of conditions and the following disclaimer.
// -       Redistributions in binary form must reproduce the above copyright notice,
//         this list of conditions and the following disclaimer in the documentation
//         and/or other materials provided with the distribution.
// -       Neither the name of the University of Washington nor the names of its
//         contributors may be used to endorse or promote products derived from this
//         software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE UNIVERSITY OF WASHINGTON AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE UNIVERSITY OF WASHINGTON OR CONTRIBUTORS BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
// OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`include "macros.inc"
`include "config.sv"
module fifo_fwf #(
    parameter WIDTH=32,
    parameter DEPTH=512,
    parameter AW = 9,
    parameter DW = WIDTH
)(
    output  [DW-1:0]    dout,
    output              full,
    output              empty,
    output  [AW:0]      data_count,
    input   [DW-1:0]    din,
    input               rd_en,
    input               wr_en,
    input               clk,
    input               rst_n,
    input               npu_en
);

reg npu_en_g;
always @(posedge clk or negedge rst_n) begin
if(!rst_n) npu_en_g <= 0;
 else   npu_en_g <= npu_en;
end


// =====================================================
//       read/write address pointers & flag management
// =====================================================
// address pointers
/*reg [width-1:0] name;\
    w_type [width-1:0] name_d;\
    always@(posedge clk or negedge rst) begin\
    if(!rst) name <= init;\
    else name <= name_d;\
    end*/
 
  reg [AW-1:0]  r_pt        ;
  reg [AW-1:0]  w_pt        ;
  reg           empty_flag  ;
  reg           full_flag   ;
  reg           rd_prev     ;
  reg           wr_prev     ;
  reg           first_read  ;
  reg [AW-1:0]  r_pt2       ;
  reg [AW:0 ]   d_count_reg ;
  reg           fw          ;
  reg           fw_count    ;
  reg [DW-1:0]  buf1_dout   ;
  reg [DW-1:0]  buf2_dout   ;
 
  reg [AW-1:0]  r_pt_d        ;
  reg [AW-1:0]  w_pt_d        ;
  reg           empty_flag_d  ;
  reg           full_flag_d   ;
  reg           rd_prev_d     ;
  reg           wr_prev_d     ;
  reg           first_read_d  ;
  reg [AW-1:0]  r_pt2_d       ;
  reg [AW:0 ]   d_count_reg_d ;
  reg           fw_d          ;
  reg           fw_count_d    ;
  reg [DW-1:0]  buf1_dout_d   ;
  reg [DW-1:0]  buf2_dout_d   ;
 
  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
    r_pt       <= 0;
    w_pt       <= 0;
    empty_flag <= 1;
    full_flag  <= 0;
    rd_prev    <= 0;
    wr_prev    <= 0;
    first_read <= 0;
    r_pt2      <= 0;
    d_count_reg<= 0;
    fw         <= 1;
    fw_count   <= 0;
    buf1_dout  <= 0;
    buf2_dout  <= 0;
       
    end else if(~npu_en)
    begin
      r_pt       <= 0;
      w_pt       <= 0;
      empty_flag <= 1;
      full_flag  <= 0;
      rd_prev    <= 0;
      wr_prev    <= 0;
      first_read <= 0;
      r_pt2      <= 0;
      d_count_reg<= 0;
      fw         <= 1;
      fw_count   <= 0;
      buf1_dout  <= 0;
      buf2_dout  <= 0;
    end
    else begin
    	r_pt       <= r_pt_d       ;
      w_pt       <= w_pt_d       ;
      empty_flag <= empty_flag_d ;
      full_flag  <= full_flag_d  ;
      rd_prev    <= rd_prev_d    ;
      wr_prev    <= wr_prev_d    ;
      first_read <= first_read_d ;
      r_pt2      <= r_pt2_d      ;
      d_count_reg<= d_count_reg_d;
      fw         <= fw_d         ;
      fw_count   <= fw_count_d   ;
      buf1_dout  <= buf1_dout_d  ;
      buf2_dout  <= buf2_dout_d  ;
    end
    end

// read pointer management
always @(*) begin
    if (rd_en && !empty && !empty_flag_d) begin
        r_pt_d  = r_pt  + {{(AW-1){1'b0}}, 1'b1};
        r_pt2_d = r_pt2 + {{(AW-1){1'b0}}, 1'b1};
       first_read_d = first_read;  
    end else begin
        r_pt_d = r_pt;
        if(wr_en == 1'b1 &&  empty==1'b1 && first_read == 1'b0) begin
          r_pt2_d = 1;
          first_read_d = 1'b1;
         // $display("this module is execure!:%x",$time);
        end else begin
          r_pt2_d = r_pt2;
          first_read_d = first_read;
        end
    end
end

// write pointer management
always @(*) begin
    if (wr_en && !full_flag && !full_flag_d) begin
        w_pt_d = w_pt + {{(AW-1'b1){1'b0}}, 1'b1};
    end else begin
        w_pt_d = w_pt;
    end
end

// remember the most recent R/W operations
always @(*) begin
    if (rd_en  && !empty) begin
        rd_prev_d = 1'b1;
    end else begin
        rd_prev_d = 1'b0;
    end
end

always @(*) begin
    if (wr_en && !full) begin
        wr_prev_d = 1'b1;
    end else begin
        wr_prev_d = 1'b0;
    end
end

// determine empty and full flags
always @(*) begin
    if (r_pt == w_pt && rd_prev && wr_prev) begin
        empty_flag_d = empty_flag;
        full_flag_d  = full_flag;
    end else if (r_pt == w_pt && !rd_prev && !wr_prev) begin
        empty_flag_d = empty_flag;
        full_flag_d  = full_flag;
    end else if (r_pt == w_pt && !rd_prev && wr_prev) begin
        empty_flag_d = 1'b0;
        full_flag_d  = 1'b1;
    end else if (r_pt == w_pt && rd_prev && !wr_prev) begin
        empty_flag_d = 1'b1;
        full_flag_d  = 1'b0;
    end else begin
        empty_flag_d = 1'b0;
        full_flag_d  = 1'b0;
    end
end

assign full  = full_flag_d;

// ======================
//      data counter
// ======================


always @(*) begin
    if (rd_en && wr_en && !full && !empty) begin
        d_count_reg_d = d_count_reg;
    end else if (!full && wr_en) begin
        d_count_reg_d = d_count_reg + {{(AW+1){1'b0}}, 1'b1};
    end else if (!empty && rd_en && d_count_reg > 0) begin
        d_count_reg_d = d_count_reg - {{(AW+1){1'b0}}, 1'b1};
    end else begin
        d_count_reg_d = d_count_reg;
    end
end

//assign #(0.1) data_count = d_count_reg;
assign data_count = d_count_reg;
// =======================
//      memory block
// =======================
//reg  [DW-1:0] mem [DEPTH-1:0];
wire [DW-1:0] mem_din;
wire [DW-1:0] mem_dout;
wire [DW-1:0] mem_dout_d;
wire mem_wr_en;
wire [AW-1:0] mem_wr_adx;
wire [AW-1:0] mem_rd_adx;
integer i;


/**
// write behavior
always @(posedge
    if(srst_g) begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] <= {DW{1'b0}};
        end
    end else begin
        if (mem_wr_en) begin
            mem[mem_wr_adx] <= mem_din;
        end
    end
end

// read behavior
assign mem_dout = mem[mem_rd_adx];
*/
 // use tool generates ram to replace above RAM
 // bramA use to write data,QA is null, AA is mem_wr_adx, DA is mem_din
 // bramB use to reade data,QB is mem_dout,AB is mem_rd_adx, DB is null
`ifdef HAPS 
 xilinx_mem_512x32_dp  ram512x32_inst(
        .douta  (     ), //bramA data outputs
        .doutb  (     mem_dout_d), //bramB data outputs
 			  .clka(  clk), //bramA clock
 			  .clkb(  clk), //bramB clock
 			  .ena(  1'b1), //bramA enable
 			  .enb(  1'b1), //bramB enable
 			  .wea(  mem_wr_en), //bramA write
 			  .web(  1'b0), //bramB write
 			  .addra  (    mem_wr_adx),   //bramA address
 			  .addrb  (    mem_rd_adx),   //bramB address
 			  .dina  (    mem_din),   //bramA data
 			  .dinb  ( 32'b0 ));  //bramb data
`else
 ram_512x32  ram512x32_inst(
        .QA(     ), //bramA data outputs
        .QB(     mem_dout_d), //bramB data outputs
 			  .CLKA(  clk), //bramA clock
 			  .CLKB(  clk), //bramB clock
 			  .CENA(  ~mem_wr_en), //bramA enable
 			  .CENB(  1'b0), //bramB enable
 			  .WENA(  ~mem_wr_en), //bramA write
 			  .WENB(  1'b1), //bramB write
 			  .AA(    mem_wr_adx),   //bramA address
 			  .AB(    mem_rd_adx),   //bramB address
 			  .DA(    mem_din),   //bramA data
 			  .DB(    32'b0));  //bramb data
`endif 			  
assign mem_dout = (empty==1'b0) ? mem_dout_d:0;

// ================
//       FWF Hack
// ================


always @(*) begin
        buf1_dout_d = mem_dout;
        buf2_dout_d = buf1_dout;
end

always @(*) begin
    if (!fw && empty && wr_en) begin
        fw_d <= 1'b1;
    end else if (fw_count) begin
        fw_d <= 1'b0;
    end else begin
        fw_d <= fw;
    end
end

always @(*) begin
    if (fw && !fw_count) begin
        fw_count_d <= 1'b1;
    end else begin
        fw_count_d <= 1'b0;
    end
end

assign empty = fw ? 1'b1 : empty_flag_d;
assign dout =  fw ? buf1_dout_d : mem_dout;

// ===========================
//      memory interface
// ===========================
reg wr_en_reg;

always @(*) begin
    if (!full && wr_en) begin
        wr_en_reg = 1'b1;
    end else begin
        wr_en_reg = 1'b0;
    end
end

assign mem_wr_en = npu_en_g == 1'b0 ? 1'b1 :wr_en_reg;
assign mem_wr_adx = w_pt_d;
assign mem_rd_adx = r_pt2_d;
assign mem_din = npu_en_g  == 1'b0 ?   0: din;

endmodule
