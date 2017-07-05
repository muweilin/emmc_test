
//  ------------------------------------------------------------------------
//
//                    (C) COPYRIGHT 2005 - 2014 SYNOPSYS, INC.
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

//
// Filename    : DW_axi_x2h_bcm05.v
// Revision    : $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_bcm05.v#7 $
// Author      : Vikas Gokhale       5/17/04
// Description : DW_axi_x2h_bcm05.v Verilog module for DWbb
//
// DesignWare IP ID: d058735a
//
////////////////////////////////////////////////////////////////////////////////


module DW_axi_x2h_bcm05(
	clk,
	rst_n,
	init_n,
	inc_req_n,
	other_addr_g,
	word_count,
	empty,
	almost_empty,
	half_full,
	almost_full,
	full,
	error,
	this_addr,
	this_addr_g,
	next_word_count,
	next_empty_n,
	next_full,
	next_error,

	test
	);

parameter DEPTH		=  8;	// RANGE 4 to 16777216
parameter ADDR_WIDTH	=  3;	// RANGE 2 to 24
parameter COUNT_WIDTH	=  4;	// RANGE 3 to 25
parameter AE_LVL	=  2;	// RANGE 1 to DEPTH-1
parameter AF_LVL	=  2;	// RANGE 1 to DEPTH-1
parameter ERR_MODE	=  0;	// RANGE 0 to 1
parameter SYNC_DEPTH	=  2;	// RANGE 1 to 3
parameter IO_MODE	=  1;	// RANGE 0 to 1

parameter TST_MODE	=  0;	// RANGE 0 to 1
   
localparam VERIF_EN     = 1;


input  				      clk;		// clock inptu
input  				      rst_n;		// active low async reset
input  				      init_n;		// active low sync. reset
input  				      inc_req_n;	// active high request to advance
// leda NTL_CDC03 off
// LMD: Divergence found in clock domain crossing path
// LJ: Devergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
input  [COUNT_WIDTH-1 : 0]	      other_addr_g;	// Gray pointer form oppos. I/F
// leda NTL_CDC03 on
output [COUNT_WIDTH-1 : 0]	      word_count;	// Local word count output
output 				      empty;		// Empty status flag
output 				      almost_empty;	// Almost Empty status flag
output 				      half_full;	// Half full status flag
output 				      almost_full;	// Almost full status flag
output 				      full;		// Full status flag
output 				      error;		// Error status flag
output [ADDR_WIDTH-1 : 0]	      this_addr;	// Local RAM address
// leda NTL_CDC03 off
// LMD: Divergence found in clock domain crossing path
// LJ: Devergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
output [COUNT_WIDTH-1 : 0]	      this_addr_g;	// Gray coded pointer to other domain
// leda NTL_CDC03 on
output [COUNT_WIDTH-1 : 0]	      next_word_count;	// Look ahead word count
output 				      next_empty_n;	// Look ahead empty flag (active low)
output 				      next_full;	// Look ahead full flag
output 				      next_error;	// Look ahead error flag

input  				      test;		// Scan test control input


 
localparam [COUNT_WIDTH-1 : 0] A_EMPTY_VECTOR  = AE_LVL;
localparam [COUNT_WIDTH-1 : 0] A_FULL_VECTOR   = DEPTH - AF_LVL;
localparam [COUNT_WIDTH-1 : 0] HLF_FULL_VECTOR = (DEPTH+1)/2;
localparam [COUNT_WIDTH-1 : 0] FULL_COUNT_BUS  = DEPTH;
localparam [COUNT_WIDTH-1 : 0] BUS_LOW         = 0;
// leda W161 off
// LMD: Constant expression in conditional select
// LJ: When assigning a constant to a localparam this warning should be ignored because the result of the expression evaluation is a constant anyway. 
localparam [COUNT_WIDTH-1 : 0] RESIDUAL_VALUE_BUS = ((1 << COUNT_WIDTH ) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                           ((DEPTH + 2) - (DEPTH & 1))) );
localparam [COUNT_WIDTH-1 : 0] OFFSET_RESIDUAL_BUS = (((((1 << COUNT_WIDTH ) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                           ((DEPTH + 2) - (DEPTH & 1))) ))/2 ));
localparam [COUNT_WIDTH-1 : 0] START_VALUE_BUS = ((((1 << COUNT_WIDTH ) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                           ((DEPTH + 2) - (DEPTH & 1))) ))/2 );
localparam [COUNT_WIDTH-1 : 0] END_VALUE_BUS = ((1 << COUNT_WIDTH ) -  1 - (((((1 << COUNT_WIDTH ) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                           ((DEPTH + 2) - (DEPTH & 1))) ))/2 )));
// leda W161 on
localparam [COUNT_WIDTH-1 : 0] COUNT_SIZED_ONE = 1;
localparam [ADDR_WIDTH-1 : 0]  ADDR_SIZED_ONE  = 1;
// leda W161 off
// LMD: Constant expression in conditional select
// LJ: When assigning a constant to a localparam this warning should be ignored because the result of the expression evaluation is a constant anyway. 
localparam [ADDR_WIDTH-1 : 0]  MODULUSM1 = (DEPTH==(1 << (COUNT_WIDTH-1)))? 0 :
					    DEPTH + 1 - (DEPTH & 1);
// leda W161 on

wire [COUNT_WIDTH-1 : 0] start_value_gray_bus;
// leda NTL_CON16 off
// LMD: Nets or cell pins should not be tied to logic 0 or logic 1
// LJ: In order to pad some operands to the right size, extra constant zeros or ones are added to MSB or LSB positions of operands. 
  assign start_value_gray_bus  = (START_VALUE_BUS  ^ (START_VALUE_BUS >> 1));
// leda NTL_CON16 on

wire [COUNT_WIDTH-1 : 0]              next_count_int;
// leda NTL_CON32 off
// LMD: Change of net does not affect any output
// LJ: This signal has been verified to affect the output(s) as expected.  So disable LEDA from reporting an error. 
wire [ADDR_WIDTH-1 : 0]               next_this_addr_int;
// leda NTL_CON32 on
wire [COUNT_WIDTH-1 : 0]              next_this_addr_g_int;
wire                                  next_empty_int;
wire                                  next_almost_empty_int;
wire                                  next_half_full_int;
wire                                  next_almost_full_int;
wire                                  next_full_int;

wire                                  next_almost_empty;
wire                                  next_half_full;
wire                                  next_almost_full;
wire                                  error_seen;
// leda NTL_CON32 off
// LMD: Change of net does not affect any output
// LJ: This signal has been verified to affect the output(s) as expected.  So disable LEDA from reporting an error. 
wire                                  next_error_int;
// leda NTL_CON32 on

wire [COUNT_WIDTH-1 : 0]              count;

wire                                  next_empty;

wire [COUNT_WIDTH-1 : 0]              raw_sync;
// leda NTL_CON13A off
// LMD: Non driving internal net Range
// LJ: All bits of the signal have been examined and determined to drive internally as expected.  However, this signal goes into a 'for-loop' structure that Leda finds difficult to trace and can produce false errors.
wire [COUNT_WIDTH-1 : 0]              other_addr_g_sync;
// leda NTL_CON13A on

wire [COUNT_WIDTH-1 : 0]              next_this_addr_g;
wire [COUNT_WIDTH-1 : 0]              other_addr_decoded;

wire                                  advance;
// leda NTL_CON13A off
// LMD: Non driving internal net Range
// LJ: Many arithmetic calculations are done for a given precision, but only some of the MSB or LSBs are of interest to compute the final result.
wire [COUNT_WIDTH   : 0]              succesive_count_big;
// leda NTL_CON13A on
wire [COUNT_WIDTH-1 : 0]              succesive_count;
// leda NTL_CON13A off
// LMD: Non driving internal net Range
// LJ: Many arithmetic calculations are done for a given precision, but only some of the MSB or LSBs are of interest to compute the final result.
wire [ADDR_WIDTH   : 0]               succesive_addr_big;
// leda NTL_CON13A on
// leda NTL_CON32 off
// LMD: Change of net does not affect any output
// LJ: This signal has been verified to affect the output(s) as expected.  So disable LEDA from reporting an error. 
wire [ADDR_WIDTH-1 : 0]               succesive_addr;
// leda NTL_CON32 on

wire [COUNT_WIDTH-1 : 0]              advanced_count;
reg  [COUNT_WIDTH-1 : 0]              next_word_count_int;
wire [ADDR_WIDTH-1 : 0]               next_this_addr;

// leda NTL_CON13A off
// LMD: Non driving internal net Range
// LJ: Many arithmetic calculations are done for a given precision, but only some of the MSB or LSBs are of interest to compute the final result.
wire [COUNT_WIDTH : 0]                temp1;
// leda NTL_CON13A on

wire [COUNT_WIDTH-1 : 0]              wrd_count_p1;

wire [COUNT_WIDTH-1 : 0]              wr_addr;
wire [COUNT_WIDTH-1 : 0]              rd_addr;

wire                                  at_end;
// leda NTL_CON13A off
// LMD: Non driving internal net Range
// LJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
wire                                  at_end_n;
// leda NTL_CON13A on

reg [COUNT_WIDTH-1 : 0]               count_int;
// leda NTL_CON32 off
// LMD: Change of net does not affect any output
// LJ: This signal has been verified to affect the output(s) as expected.  So disable LEDA from reporting an error. 
reg [ADDR_WIDTH-1 : 0]                this_addr_int;
// leda NTL_CON32 on
// leda NTL_CDC03 off
// LMD: Divergence found in clock domain crossing path
// LJ: Devergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
reg [COUNT_WIDTH-1 : 0]               this_addr_g_int;
// leda NTL_CDC03 on
reg [COUNT_WIDTH-1 : 0]               word_count_int;
 
reg                                   empty_int;
reg                                   almost_empty_int;
reg                                   half_full_int;
reg                                   almost_full_int;
reg                                   full_int;
reg                                   error_int;


 

  assign next_almost_empty     = (next_word_count_int <= A_EMPTY_VECTOR) ? 1'b1 : 1'b0;
  assign next_half_full        = (next_word_count_int >= HLF_FULL_VECTOR) ? 1'b1 : 1'b0; 
  assign next_almost_full      = (next_word_count_int >= A_FULL_VECTOR) ? 1'b1 : 1'b0; 
  assign next_empty            = (next_word_count_int == BUS_LOW) ? 1'b1 : 1'b0; 
  assign next_full_int         = (next_word_count_int == FULL_COUNT_BUS) ? 1'b1 : 1'b0; 

  assign error_seen            = !inc_req_n && at_end;

generate
  if (ERR_MODE == 0) begin : GEN_em_eq_0
    assign next_error_int        = error_seen || error_int;
  end else begin :		GET_em_ne_0
    assign next_error_int        = error_seen;
  end
endgenerate

  assign next_count_int        = advanced_count ^ START_VALUE_BUS;
  assign next_this_addr_int    = next_this_addr;
  assign next_this_addr_g_int  = next_this_addr_g ^ start_value_gray_bus;
  assign next_empty_int        = ~next_empty;
  assign next_almost_empty_int = ~next_almost_empty;
  assign next_half_full_int    = next_half_full;
  assign next_almost_full_int  = next_almost_full;
 

  always @ (posedge clk or negedge rst_n) begin : a1000_PROC
     if (!rst_n) begin
       count_int <=  {COUNT_WIDTH{1'b0}};
       this_addr_int <=  {ADDR_WIDTH{1'b0}};
       this_addr_g_int <=  {COUNT_WIDTH{1'b0}};
       word_count_int <=  {COUNT_WIDTH{1'b0}};
       empty_int <=  1'b0;
       almost_empty_int <=  1'b0;
       half_full_int <=  1'b0;
       almost_full_int <=  1'b0;
       full_int <=  1'b0;
       error_int <=  1'b0;
     end else if (!init_n) begin
       count_int <=  {COUNT_WIDTH{1'b0}};
       this_addr_int <=  {ADDR_WIDTH{1'b0}};
       this_addr_g_int <=  {COUNT_WIDTH{1'b0}};
       word_count_int <=  {COUNT_WIDTH{1'b0}};
       empty_int <=  1'b0;
       almost_empty_int <=  1'b0;
       half_full_int <=  1'b0;
       almost_full_int <=  1'b0;
       full_int <=  1'b0;
       error_int <=  1'b0;
     end else begin
       count_int <=  next_count_int ;
       this_addr_int <=  next_this_addr_int ;
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
// leda NTL_CDC00 off
// LMD: Clock domain crossing detected
// LJ: The clock domain crossing is intentional and proper synchronization scheme is implemented.  So, disable LEDA from reporting this warning.
       this_addr_g_int <=  next_this_addr_g_int ;
// leda NTL_CDC09 on
// leda NTL_CDC00 on
       word_count_int <=  next_word_count_int ;
       empty_int <=  next_empty_int;
       almost_empty_int <=  next_almost_empty_int;
       half_full_int <=  next_half_full_int;
       almost_full_int <=  next_almost_full_int;
       full_int <=  next_full_int;
       error_int <=  next_error_int;
     end
    end

  assign other_addr_g_sync  = raw_sync ^ start_value_gray_bus;

  assign count              = count_int ^ START_VALUE_BUS;
  assign word_count         = word_count_int;

  assign empty              = ~empty_int;
  assign almost_empty       = ~almost_empty_int;
  assign half_full          = half_full_int;
  assign almost_full        = almost_full_int;
  assign full               = full_int;
  assign error              = error_int;

generate
  if (IO_MODE == 0) begin :	GEN_iom_eq_0
    assign at_end         = ~empty_int;
    assign at_end_n       =  empty_int;
    assign rd_addr        = advanced_count;
    assign wr_addr        = other_addr_decoded;
  end else begin :		GEN_iom_ne_0
    assign at_end         =  full_int;
    assign at_end_n       = ~full_int;
    assign rd_addr        = other_addr_decoded;
    assign wr_addr        = advanced_count;
  end
endgenerate

  assign next_word_count    = init_n ? next_word_count_int : ({COUNT_WIDTH{1'b0}});
  assign next_empty_n       = ~next_empty && init_n;
  assign next_full          = next_full_int && init_n;
  assign next_error         = next_error_int && init_n;


  DW_axi_x2h_bcm21
   #(COUNT_WIDTH, SYNC_DEPTH+8, 0, VERIF_EN, 2) U_sync(
    .clk_d(clk),
    .rst_d_n(rst_n),
    .init_d_n(init_n),
    .data_s(other_addr_g),
    .test(1'b0),
    .data_d(raw_sync) );

  // Gray Code encoder
  
  function [COUNT_WIDTH-1:0] func_bin2gray ;
    input [COUNT_WIDTH-1:0]		f_b;	// input
    begin 
      func_bin2gray  = f_b ^ ( f_b >> 1 ); 
    end
  endfunction

  assign next_this_addr_g = func_bin2gray ( advanced_count );

  // Gray Code decoder
  
  function [COUNT_WIDTH-1:0] func_gray2bin ;
    input [COUNT_WIDTH-1:0]		f_g;	// input
    reg   [COUNT_WIDTH-1:0]		f_b;
    integer			f_i;
    begin 
      f_b = {COUNT_WIDTH{1'b0}};
// leda G_5214_2 off
// LMD: Use Vector operations on arrays rather than for loops
// LJ: The use of a 'for' loop here is allowed in this case due to the nature of this design.
      for (f_i=COUNT_WIDTH-1 ; f_i >= 0 ; f_i=f_i-1) begin
// leda G_5214_2 on
        if (f_i < COUNT_WIDTH-1)
// leda FM_2_36 off
// LMD: Signal is read before being assigned
// LJ: The vector was fully initialized before being accessed a bit at a time.  So, disable LEDA from reporting this warning.
// leda FM_2_22 off
// LMD: Possible range overflow
// LJ: The variable used for indexing is bounded and guaranteed not to go beyond the upper range of the array/vector.  So, disable LEDA from reporting this warning.
	  f_b[f_i] = f_g[f_i] ^ f_b[f_i+1];
// leda FM_2_22 on
// leda FM_2_36 on
	else
	  f_b[f_i] = f_g[f_i];
      end // for (i
      func_gray2bin  = f_b; 
    end
  endfunction

  assign other_addr_decoded = func_gray2bin ( other_addr_g_sync );
 
  assign advance            = ~inc_req_n && (~at_end);

  assign advanced_count = (advance == 1'b1)? succesive_count : count;
  assign next_this_addr = (advance == 1'b1)? succesive_addr : this_addr_int;

// leda B_3208 off
// LMD: Unequal length LHS and RHS in assignment 
// LJ: In most cases, the expressions in the code are written such that the LHS result is one bit larger than the RHS operands (or they should be at the very least). This is the most conservative approach in having one more bit on the left-hand side (LHS) than the two operands of an expression on the right-hand side (RHS).
  assign temp1              = wr_addr - rd_addr;
// leda B_3208 on
  assign wrd_count_p1       = temp1[COUNT_WIDTH-1 : 0];


// leda B_3208 off
// LMD: Unequal length LHS and RHS in assignment 
// LJ: In most cases, the expressions in the code are written such that the LHS result is one bit larger than the RHS operands (or they should be at the very least). This is the most conservative approach in having one more bit on the left-hand side (LHS) than the two operands of an expression on the right-hand side (RHS).
  assign succesive_count_big = count+COUNT_SIZED_ONE;
  assign succesive_addr_big  = this_addr_int+ADDR_SIZED_ONE;
// leda B_3208 on

generate
  if ((1 << ADDR_WIDTH) != DEPTH) begin : GEN_NXT_W_CNT_NOT_PWR2
    always @( wrd_count_p1 or rd_addr or wr_addr) begin : mk_this_addr_PROC
      reg [COUNT_WIDTH : 0] next_word_count_int_big;

      if (rd_addr > wr_addr)
// leda B_3208 off
// LMD: Unequal length LHS and RHS in assignment 
// LJ: In most cases, the expressions in the code are written such that the LHS result is one bit larger than the RHS operands (or they should be at the very least). This is the most conservative approach in having one more bit on the left-hand side (LHS) than the two operands of an expression on the right-hand side (RHS).
        next_word_count_int_big = wrd_count_p1 - RESIDUAL_VALUE_BUS;
// leda B_3208 on
      else
// leda B_3208 off
// LMD: Unequal length LHS and RHS in assignment 
// LJ: In most cases, the expressions in the code are written such that the LHS result is one bit larger than the RHS operands (or they should be at the very least). This is the most conservative approach in having one more bit on the left-hand side (LHS) than the two operands of an expression on the right-hand side (RHS).
        next_word_count_int_big = wrd_count_p1;
// leda B_3208 on

      next_word_count_int = next_word_count_int_big[COUNT_WIDTH-1 : 0];
    end

    assign succesive_count = (this_addr_int != MODULUSM1)? succesive_count_big[COUNT_WIDTH-1:0] :
							START_VALUE_BUS;
    assign succesive_addr  = (this_addr_int != MODULUSM1)? succesive_addr_big[ADDR_WIDTH-1:0]  :
							BUS_LOW[ADDR_WIDTH-1 : 0];
    assign this_addr       = this_addr_int;
  end

  if ((1 << ADDR_WIDTH) == DEPTH) begin : GEN_NXT_W_CNT_PWR2
    always @( wrd_count_p1 ) begin : a1001_PROC
	next_word_count_int = wrd_count_p1;
    end

    assign succesive_count = succesive_count_big[COUNT_WIDTH-1:0];
    assign succesive_addr  = succesive_addr_big[ADDR_WIDTH-1:0];
    assign this_addr       = count[ADDR_WIDTH-1 : 0];
  end
endgenerate

    
generate
  if (TST_MODE != 0) begin : GEN_LATCH_addr_g
    reg [COUNT_WIDTH-1:0] this_addr_g_ltch;
    always @ (clk or this_addr_g_int) begin : LATCH_addr_g_PROC
      if (clk == 1'b0)
// leda NTL_STR47 off
// LMD: Do not use latch Range:[range]
// LJ: This module is intentionally implemented with latches.  So, disable LEDA from reporting this error.
	this_addr_g_ltch <= this_addr_g_int;
// leda NTL_STR47 on
    end // LATCH_addr_g_PROC

// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
    assign this_addr_g = (test==1'b1)? this_addr_g_ltch : this_addr_g_int;
// leda NTL_CDC02 on
  end else begin : GEN_DIRECT_addr_g
    assign this_addr_g = this_addr_g_int;
  end
endgenerate


endmodule
