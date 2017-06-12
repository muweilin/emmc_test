////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 1999 - 2014 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Reto Zimmermann        8/25/99
//
// VERSION:   Simulation Architecture
//
// DesignWare_version: d771edd1
// DesignWare_release: J-2014.09-DWBB_201409.1
//
////////////////////////////////////////////////////////////////////////////////
//---------------------------------------------------------------------------
//
// ABSTRACT: Minimum/maximum value detector/selector
//           - This component determines and selects the minimum or maximum
//             value out of NUM_INPUTS inputs.  The inputs must be merged into
//             one single input vector A.
//           - TC determines whether the inputs are unsigned ('0') of signed
//             ('1').
//           - Min_Max determines whether the minimum ('0') or the maximum
//             ('1') is determined.
//           - Value outputs the minimum/maximum value.
//           - Index tells which input it the minimum/maximum.
//
//  MODIFIED: 
//           RPH        07/17/2002 
//                      Added parameter checking
//---------------------------------------------------------------------------

//`define width 8
//`define num_inputs 2

module DW_minmax (a ,tc ,min_max ,value ,index);

`define DW_n (num_inputs)
`define DW_ind_width ((`DW_n>4096)? ((`DW_n>262144)? ((`DW_n>2097152)? ((`DW_n>8388608)? 24 : ((`DW_n> 4194304)? 23 : 22)) : ((`DW_n>1048576)? 21 : ((`DW_n>524288)? 20 : 19))) : ((`DW_n>32768)? ((`DW_n>131072)?  18 : ((`DW_n>65536)? 17 : 16)) : ((`DW_n>16384)? 15 : ((`DW_n>8192)? 14 : 13)))) : ((`DW_n>64)? ((`DW_n>512)?  ((`DW_n>2048)? 12 : ((`DW_n>1024)? 11 : 10)) : ((`DW_n>256)? 9 : ((`DW_n>128)? 8 : 7))) : ((`DW_n>8)? ((`DW_n> 32)? 6 : ((`DW_n>16)? 5 : 4)) : ((`DW_n>4)? 3 : ((`DW_n>2)? 2 : 1)))))
  parameter width = 8;
  parameter num_inputs = 5;


   
  input [num_inputs*width-1 : 0] a;
  input tc;
  input min_max;
  output [width-1 : 0] value;
  output [`DW_ind_width-1 : 0] index;
   


  wire [num_inputs*width-1 : 0] a;
  wire tc;
  wire min_max;
  reg [width-1 : 0] value;
  reg [`DW_ind_width-1 : 0] index;
  wire [width-1 : 0] value_minus;
  wire [width-1 : 0] value_maxus; 
  wire [width-1 : 0] value_mins ;
  wire [width-1 : 0] value_maxs ;
  
  wire [width-1 : 0] value_minus_0;
  wire [width-1 : 0] value_maxus_0; 
  wire [width-1 : 0]  value_mins_0 ;
  wire [width-1 : 0]  value_maxs_0 ;
  wire [width-1 : 0] value_minus_1;
  wire [width-1 : 0] value_maxus_1; 
  wire [width-1 : 0]  value_mins_1 ;
  wire [width-1 : 0]  value_maxs_1 ;
  wire [width-1 : 0] value_minus_2;
  wire [width-1 : 0] value_maxus_2; 
  wire [width-1 : 0]  value_mins_2 ;
  wire [width-1 : 0]  value_maxs_2 ;
 // wire [width-1 : 0] value_minus_3;
 // wire [width-1 : 0] value_maxus_3; 
 // wire [width-1 : 0]  value_mins_3 ;
 // wire [width-1 : 0]  value_maxs_3 ;
  
  wire [`DW_ind_width-1 : 0] index_minus;
  wire [`DW_ind_width-1 : 0] index_maxus;
  wire [`DW_ind_width-1 : 0] index_mins ;
  wire [`DW_ind_width-1 : 0] index_maxs ;
  
  wire  index_minus_0;
  wire  index_maxus_0;
  wire  index_mins_0 ;
  wire  index_maxs_0 ;
  wire  index_minus_1;
  wire  index_maxus_1;
  wire  index_mins_1 ;
  wire  index_maxs_1 ;
  wire  index_minus_2;
  wire  index_maxus_2;
  wire  index_mins_2 ;
  wire  index_maxs_2 ;
  wire  index_minus_3;
  wire  index_maxus_3;
  wire  index_mins_3 ;
  wire  index_maxs_3 ;
  
  generate
  
  if(num_inputs == 5)
  begin
  wire [15:0] a0;
  wire [15:0] a1; 
  wire [7:0] a2; 
  
 
  
  assign a0 = a[15:0];
  assign a1 = a[31:16];
  assign a2 = a[39:32];
 // assign a4 = a[31:24];
 // assign a5 = a[40:32];
 
  min_unsigned #(.width(width)) U10(a0,value_minus_0,index_minus_0);
  min_unsigned #(.width(width)) U11(a1,value_minus_1,index_minus_1);
  min_unsigned #(.width(width)) U12({value_minus_1,value_minus_0},value_minus_2,index_minus_2);
  min_unsigned #(.width(width)) U13({a2,value_minus_2},value_minus,index_minus_3);
  
  assign index_minus = index_minus_3 ? 3'b100 : (index_minus_2 ? (index_minus_1 ? 3'b011 : 3'b010):(index_minus_0 ? 3'b001 : 3'b000));
  
  max_unsigned #(.width(width)) U20(a0,value_maxus_0,index_maxus_0);
  max_unsigned #(.width(width)) U21(a1,value_maxus_1,index_maxus_1);
  max_unsigned #(.width(width)) U22({value_maxus_1,value_maxus_0},value_maxus_2,index_maxus_2);
  max_unsigned #(.width(width)) U23({a2,value_maxus_2},value_maxus,index_maxus_3);
  
  assign index_maxus = index_maxus_3 ? 3'b100 : (index_maxus_2 ? (index_maxus_1 ? 3'b011 : 3'b010):(index_maxus_0 ? 3'b001 : 3'b000));
  
 // max_unsigned U2(a,value_maxus,index_maxus);
  
  min_signed #(.width(width)) U30(a0,value_mins_0,index_mins_0);
  min_signed #(.width(width)) U31(a1,value_mins_1,index_mins_1);
  min_signed #(.width(width)) U32({value_mins_1,value_mins_0},value_mins_2,index_mins_2);
  min_signed #(.width(width)) U33({a2,value_mins_2},value_mins,index_mins_3);
  
  assign index_mins = index_mins_3 ? 3'b100 : (index_mins_2 ? (index_mins_1 ? 3'b011 : 3'b010):(index_mins_0 ? 3'b001 : 3'b000));
  
  //min_signed U3(a,value_mins,index_mins);
  
  max_signed #(.width(width)) U40(a0,value_maxs_0,index_maxs_0);
  max_signed #(.width(width)) U41(a1,value_maxs_1,index_maxs_1);
  max_signed #(.width(width)) U42({value_maxs_1,value_maxs_0},value_maxs_2,index_maxs_2);
  max_signed #(.width(width)) U43({a2,value_maxs_2},value_maxs,index_maxs_3);
  
  assign index_maxs = index_maxs_3 ? 3'b100 : (index_maxs_2 ? (index_maxs_1 ? 3'b011 : 3'b010):(index_maxs_0 ? 3'b001 : 3'b000));
  //max_signed U4(a,value_maxs,index_maxs);
 
  end else begin
   wire [5:0] a0;
  wire [5:0] a1; 
  //wire [7:0] a2; 
  
 
  
  assign a0 = a[5:0];
  assign a1 = a[11:6];
 // assign a2 = a[39:32];
 // assign a4 = a[31:24];
 // assign a5 = a[40:32];
  

  min_unsigned #(.width(width)) U10(a0,value_minus_0,index_minus_0);
  min_unsigned #(.width(width)) U11(a1,value_minus_1,index_minus_1);
  min_unsigned #(.width(width)) U12({value_minus_1,value_minus_0},value_minus,index_minus_2);
 // min_unsigned U13({a2,value_minus_2},value_minus,index_minus_3);
  
  assign index_minus =index_minus_2 ? (index_minus_1 ? 2'b11 : 2'b10):(index_minus_0 ? 2'b01 : 2'b00);
  
  max_unsigned #(.width(width)) U20(a0,value_maxus_0,index_maxus_0);
  max_unsigned #(.width(width)) U21(a1,value_maxus_1,index_maxus_1);
  max_unsigned #(.width(width)) U22({value_maxus_1,value_maxus_0},value_maxus,index_maxus_2);
 // max_unsigned U23({a2,value_maxus_2},value_maxus,index_maxus_3);
  
  assign index_maxus = index_maxus_2 ? (index_maxus_1 ? 2'b11 : 2'b10):(index_maxus_0 ? 2'b01 : 2'b00);
  
 // max_unsigned U2(a,value_maxus,index_maxus);
  
  min_signed #(.width(width)) U30(a0,value_mins_0,index_mins_0);
  min_signed #(.width(width)) U31(a1,value_mins_1,index_mins_1);
  min_signed #(.width(width)) U32({value_mins_1,value_mins_0},value_mins,index_mins_2);
 // min_signed U33({a2,value_mins_2},value_mins,index_mins_3);
  
  assign index_mins = index_mins_2 ? (index_mins_1 ? 2'b11 : 2'b10):(index_mins_0 ? 2'b01 : 2'b00);
  
  //min_signed U3(a,value_mins,index_mins);
  
  max_signed #(.width(width)) U40(a0,value_maxs_0,index_maxs_0);
  max_signed #(.width(width)) U41(a1,value_maxs_1,index_maxs_1);
  max_signed #(.width(width)) U42({value_maxs_1,value_maxs_0},value_maxs,index_maxs_2);
 // max_signed U43({a2,value_maxs_2},value_maxs,index_maxs_3);
  
  assign index_maxs = index_maxs_2 ? (index_maxs_1 ? 2'b11 : 2'b10):(index_maxs_0 ? 2'b01 : 2'b00);
  //max_signed U4(a,value_maxs,index_maxs);
 end
 endgenerate
  
  
  
  always @(*)
    begin
      value = {width{1'b0}};
      index = {`DW_ind_width{1'b0}};
      if (tc == 1'b0) begin 
	if (min_max == 1'b0) begin 
	    value = value_minus;
	    index = index_minus;
	end
	else if (min_max == 1'b1) begin 
	  //max_unsigned (a, value, index);
	    value = value_maxus;
	    index = index_maxus;
	end
      end 
      else if (tc == 1'b1) begin
	if (min_max == 1'b0) begin 
	 // min_signed (a, value, index);
	    value = value_mins;
	    index = index_mins;
	end
	else if (min_max == 1'b1) begin
	 // max_signed (a, value, index);
	    value = value_maxs;
	    index = index_maxs;
	end
      end
    end 



endmodule


 module min_unsigned(a,value,index);
 
  parameter width = 8;
  parameter num_inputs = 2;

    input [num_inputs*width-1 : 0] a;
    output [width-1 : 0] value;
    output  index;
    
    wire [width-1 : 0] a_high;
    
    assign a_high = a >> width;
    assign value = a_high < a[width-1 : 0] ? a_high : a[width-1 : 0];
    assign index = a_high < a[width-1 : 0] ? 1 : 0;
    
  endmodule

  module min_signed(a,value,index);
  
   parameter width = 8;
  parameter num_inputs = 2;

    input [num_inputs*width-1 : 0] a;
    output [width-1 : 0] value;
    output  index;
   
    
    wire [width-1 : 0] a_high;
    wire [width-1 : 0] a_signH;
    wire [width-1 : 0] a_signL;
    wire [width-1 : 0] value_tmp; 
    
    
    assign a_signL = {~a[width-1],a[width-2:0]};
    assign a_high  = a >> width;
    assign a_signH = {~a_high[width-1],a_high[width-2:0]};
    assign value_tmp = a_signH < a_signL ? a_signH : a_signL;
    assign index     = a_signH < a_signL ? 1 : 0;
    assign value     = {~value_tmp[width-1],value_tmp[width-2:0]};
    
	
  endmodule

  module max_unsigned(a,value,index);
  
   parameter width = 8;
  parameter num_inputs = 2;

    input [num_inputs*width-1 : 0] a;
    output [width-1 : 0] value;
    output  index;
    wire [width-1 : 0] a_high;
    
    assign a_high = a >> width;
    assign value = ((a_high > a[width-1 : 0])|| (a_high == a[width-1 : 0])) ? a_high : a[width-1 : 0];
    assign index = ((a_high > a[width-1 : 0])|| (a_high == a[width-1 : 0])) ? 1 : 0;
    
  endmodule

  module max_signed(a,value,index);
  
   parameter width = 3;
  parameter num_inputs = 4;

    input [num_inputs*width-1 : 0] a;
    output [width-1 : 0] value;
    output index;
    
    wire [width-1 : 0] a_high;
    wire [width-1 : 0] a_signH;
    wire [width-1 : 0] a_signL;
    wire [width-1 : 0] value_tmp; 
    
    
    assign a_signL = {~a[width-1],a[width-2:0]};
    assign a_high  = a >> width;
    assign a_signH = {~a_high[width-1],a_high[width-2:0]};
    assign value_tmp = (a_signH > a_signL)|| (a_signH == a_signL) ? a_signH : a_signL;
    assign index     = (a_signH > a_signL)|| (a_signH == a_signL)? 1 : 0;
    assign value     = {~value_tmp[width-1],value_tmp[width-2:0]};
    
  endmodule

`undef DW_n
`undef DW_ind_width 