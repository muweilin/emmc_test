
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
// Filename    : DW_axi_x2h_bcm07.v
// Revision    : $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_bcm07.v#8 $
// Author      : Vikas Gokhale       5/17/04
// Description : DW_axi_x2h_bcm07.v Verilog module for DWbb
//
// DesignWare IP ID: b8fa71d4
//
////////////////////////////////////////////////////////////////////////////////



module DW_axi_x2h_bcm07(
	clk_push,
	rst_push_n,
	init_push_n,
	push_req_n,
	push_empty,
	push_ae,
	push_hf,
	push_af,
	push_full,
	push_error,
	push_word_count,
	we_n,
	wr_addr,

	clk_pop,
	rst_pop_n,
	init_pop_n,
	pop_req_n,
	pop_empty,
	pop_ae,
	pop_hf,
	pop_af,
	pop_full,
	pop_error,
	pop_word_count,
	rd_addr,
	test
	);

parameter DEPTH		=  8;	// RANGE 4 to 16777216
parameter ADDR_WIDTH	=  3;	// RANGE 2 to 24
parameter COUNT_WIDTH	=  4;	// RANGE 3 to 25
parameter PUSH_AE_LVL	=  2;	// RANGE 1 to DEPTH-1
parameter PUSH_AF_LVL	=  2;	// RANGE 1 to DEPTH-1
parameter POP_AE_LVL	=  2;	// RANGE 1 to DEPTH-1
parameter POP_AF_LVL	=  2;	// RANGE 1 to DEPTH-1
parameter ERR_MODE	=  0;	// RANGE 0 to 1
parameter PUSH_SYNC	=  2;	// RANGE 1 to 4
parameter POP_SYNC	=  2;	// RANGE 1 to 4
parameter TST_MODE	=  0;	// RANGE 0 to 1
parameter EARLY_PUSH_STAT =  0;   // RANGE 0 to 15
parameter EARLY_POP_STAT  =  0;   // RANGE 0 to 15
   
   

input  				clk_push;	// Push domain clk input
input  				rst_push_n;	// Push domain active low async reset
input  				init_push_n;	// Push domain active low sync reset
input  				push_req_n;	// Push domain active high push reqest
output 				push_empty;	// Push domain Empty status flag
output 				push_ae;	// Push domain Almost Empty status flag
output 				push_hf;	// Push domain Half full status flag
output 				push_af;	// Push domain Almost full status flag
output 				push_full;	// Push domain Full status flag
output 				push_error;	// Push domain Error status flag
output [COUNT_WIDTH-1 : 0]      push_word_count;// Push domain word count
output 				we_n;		// Push domain active low RAM write enable
output [ADDR_WIDTH-1 : 0]	wr_addr;	// Push domain RAM write address

input  				clk_pop;	// Pop domain clk input
input  				rst_pop_n;	// Pop domain active low async reset
input  				init_pop_n;	// Pop domain active low sync reset
input  				pop_req_n;	// Pop domain active high pop request
output 				pop_empty;	// Pop domain Empty status flag
output 				pop_ae;		// Pop domain Almost Empty status flag
output 				pop_hf;		// Pop domain Half full status flag
output 				pop_af;		// Pop domain Almost full status flag
output 				pop_full;	// Pop domain Full status flag
output 				pop_error;	// Pop domain Error status flag
output [COUNT_WIDTH-1 : 0]	pop_word_count;	// Pop domain word count
output [ADDR_WIDTH-1 : 0]	rd_addr;	// Pop domain RAM read address

input  				test;		// Scan test control input

// leda NTL_CON13A off
// LMD: Non driving internal net Range
// LJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
wire 				reg_push_empty;	        // Registered Push domain Empty status flag
wire 				reg_push_full;        	// Registered Push domain Full status flag
wire 				reg_push_error;	        // Registered Push domain Error status flag
wire   [COUNT_WIDTH-1 : 0]      reg_push_word_count;    // Registered Push domain word count
wire 				early_push_empty_n;	// Unregistered Push domain Empty status flag (active-low)
wire 				early_push_full;	// Unregistered Push domain Full status flag
wire 				early_push_error;	// Unregistered Push domain Error status flag
wire   [COUNT_WIDTH-1 : 0]      early_push_word_count;  // Unregistered Push domain word count

wire 				reg_pop_empty;	        // Registered Pop domain Empty status flag
wire 				reg_pop_full;        	// Registered Pop domain Full status flag
wire 				reg_pop_error;	        // Registered Pop domain Error status flag
wire   [COUNT_WIDTH-1 : 0]      reg_pop_word_count;     // Registered Pop domain word count
wire 				early_pop_empty_n;	// Unregistered Pop domain Empty status flag (active-low)
wire 				early_pop_full;	        // Unregistered Pop domain Full status flag
wire 				early_pop_error;	// Unregistered Pop domain Error status flag
wire   [COUNT_WIDTH-1 : 0]      early_pop_word_count;   // Unregistered Pop domain word count
// leda NTL_CON13A on

// leda NTL_CDC03 off
// LMD: Divergence found in clock domain crossing path
// LJ: Devergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
wire [COUNT_WIDTH-1 : 0]        push_addr_g;

wire [COUNT_WIDTH-1 : 0]        pop_addr_g;
// leda NTL_CDC03 on


// leda DCVER_192 off
// LMD: Initial statement not supported
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda W430 off
// LMD: Initial statement is not synthesizable
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda W599 off
// LMD: Initial construct is not supported by Synopsys
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda W159 off
// LMD: Constant condition expression
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda B_2000 off
// LMD: System tasks are not allowed
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
`ifndef SMIC_SYNTHESIS
`ifndef DWC_DISABLE_CDC_METHOD_REPORTING
  initial begin
    if ((POP_SYNC > 0)&&(POP_SYNC < 8))
       $display("Information: *** Instance %m module is using the <Dual Clock FIFO Controller (11)> Clock Domain Crossing Method ***");
  end

`endif
`endif
// leda DCVER_192 on
// leda W430 on
// leda W599 on
// leda W159 on
// leda B_2000 on

  assign we_n = push_full | push_req_n;

DW_axi_x2h_bcm05
 #(DEPTH, ADDR_WIDTH, COUNT_WIDTH, PUSH_AE_LVL, PUSH_AF_LVL, ERR_MODE, PUSH_SYNC, 1, TST_MODE ) U_PUSH_FIFOFCTL(
  .clk(clk_push),
  .rst_n(rst_push_n),
  .init_n(init_push_n),
  .inc_req_n(push_req_n),
  .other_addr_g(pop_addr_g),
  .word_count(reg_push_word_count),
  .empty(reg_push_empty),
  .almost_empty(push_ae),
  .half_full(push_hf),
  .almost_full(push_af),
  .full(reg_push_full),
  .error(reg_push_error),
  .this_addr(wr_addr),
  .this_addr_g(push_addr_g),
 
  .next_word_count(early_push_word_count),
  .next_empty_n(early_push_empty_n),
  .next_full(early_push_full),
  .next_error(early_push_error),

  .test(test)
  );

DW_axi_x2h_bcm05
 #(DEPTH, ADDR_WIDTH, COUNT_WIDTH, POP_AE_LVL, POP_AF_LVL, ERR_MODE, POP_SYNC, 0, TST_MODE ) U_POP_FIFOFCTL(
  .clk(clk_pop),
  .rst_n(rst_pop_n),
  .init_n(init_pop_n),
  .inc_req_n(pop_req_n),
  .other_addr_g(push_addr_g),
  .word_count(reg_pop_word_count),
  .empty(reg_pop_empty),
  .almost_empty(pop_ae),
  .half_full(pop_hf),
  .almost_full(pop_af),
  .full(reg_pop_full),
  .error(reg_pop_error),
  .this_addr(rd_addr),
  .this_addr_g(pop_addr_g),
 
  .next_word_count(early_pop_word_count),
  .next_empty_n(early_pop_empty_n),
  .next_full(early_pop_full),
  .next_error(early_pop_error),

  .test(test)
  );

generate
  if ((EARLY_PUSH_STAT & 1) == 1) begin : GEN_EARLY_PSH_EMPTY
    wire   early_push_empty;
    assign early_push_empty = ~early_push_empty_n;
    assign push_empty = early_push_empty;
  end else begin : GEN_REG_PSH_EMPTY
    assign push_empty = reg_push_empty;
  end
  if ((EARLY_PUSH_STAT & 2) == 2) begin : GEN_EARLY_PSH_FULL
    assign push_full = early_push_full;
  end else begin : GEN_REG_PSH_FULL
    assign push_full = reg_push_full;
  end
  if ((EARLY_PUSH_STAT & 4) == 4) begin : GEN_EARLY_PSH_WC
    assign push_word_count = early_push_word_count;
  end else begin :  GEN_REG_PSH_WC
    assign push_word_count = reg_push_word_count;
  end
  if ((EARLY_PUSH_STAT & 8) == 8) begin : GEN_EARLY_PSH_ERR
    assign push_error = early_push_error;
  end else begin : GEN_REG_PSH_ERR
    assign push_error = reg_push_error;
  end

  if ((EARLY_POP_STAT & 1) == 1) begin : GEN_EARLY_POP_EMPTY
    wire   early_pop_empty;
    assign early_pop_empty = ~early_pop_empty_n;
    assign pop_empty = early_pop_empty;
  end else begin : GEN_REG_POP_EMPTY
    assign pop_empty = reg_pop_empty;
  end
  if ((EARLY_POP_STAT & 2) == 2) begin : GEN_EARLY_POP_FULL
    assign pop_full = early_pop_full;
  end else begin : GEN_REG_POP_FULL
    assign pop_full = reg_pop_full;
  end
  if ((EARLY_POP_STAT & 4) == 4) begin : GEN_EARLY_POP_WC
    assign pop_word_count = early_pop_word_count;
  end else begin : GEN_REG_POP_WC
    assign pop_word_count = reg_pop_word_count;
  end
  if ((EARLY_POP_STAT & 8) == 8) begin : GEN_EARLY_POP_ERR
    assign pop_error = early_pop_error;
  end else begin : GEN_REG_POP_ERR
    assign pop_error = reg_pop_error;
  end
endgenerate
endmodule
