
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
// Filename    : DW_axi_x2h_bcm57.v
// Revision    : $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_bcm57.v#8 $
// Author      : Rick Kelly    April 26, 2004
// Description : DW_axi_x2h_bcm57.v Verilog module for DWbb
//
// DesignWare IP ID: ec4bebb1
//
////////////////////////////////////////////////////////////////////////////////



  module DW_axi_x2h_bcm57 (
	clk,
	rst_n,
	init_n,
	wr_n,
	data_in,
	wr_addr,
        rd_addr,
	data_out
	);

   parameter DATA_WIDTH = 4;	// RANGE 1 to 256
   parameter DEPTH = 8;		// RANGE 2 to 256
   parameter MEM_MODE = 0;	// RANGE 0 to 3
   parameter ADDR_WIDTH = 3;	// RANGE 1 to 8

   input 			clk;		// clock input
   input 			rst_n;		// active low async. reset
   input 			init_n;		// active low sync. reset
   input 			wr_n;		// active low RAM write enable
   input [DATA_WIDTH-1:0]	data_in;	// RAM write data input bus
   input [ADDR_WIDTH-1:0]	wr_addr;	// RAM write address bus
   input [ADDR_WIDTH-1:0]	rd_addr;	// RAM read address bus

   output [DATA_WIDTH-1:0]	data_out;	// RAM read data output bus


// leda NTL_CON32 off
// LMD: Change of net does not affect any output
// LJ: This signal has been verified to affect the output(s) as expected.  So disable LEDA from reporting an error. 
   reg [DATA_WIDTH-1:0]		mem [0 : DEPTH-1];
// leda NTL_CON32 on

  wire [ADDR_WIDTH-1:0]		write_addr;
  wire                          wr_n_int;
  wire				write_en_n;
  wire [DATA_WIDTH-1:0]		write_data;
  wire [ADDR_WIDTH-1:0]		read_addr;
  wire [DATA_WIDTH-1:0]		read_data;

  localparam [ADDR_WIDTH-1:0]   MAX_ADDR = DEPTH-1;
   
generate
  if ( DEPTH != (1 << ADDR_WIDTH) ) begin : GEN_NONPWR2_DPTH
// leda FM_2_22 off
// LMD: Possible range overflow
// LJ: The variable used for indexing is bounded and guaranteed not to go beyond the upper range of the array/vector.  So, disable LEDA from reporting this warning.
// If read address is out of range of RAM DEPTH, then produce all zeros for read data
    assign read_data = (rd_addr <= MAX_ADDR) ? mem[read_addr] : {DATA_WIDTH{1'b0}};
// leda FM_2_22 on

    assign wr_n_int = (wr_addr <= MAX_ADDR) ? wr_n : 1'b1;
  end else begin : GEN_PWR2_DPTH
    assign read_data = mem[read_addr];
    assign wr_n_int = wr_n;
  end
endgenerate

  always @ (posedge clk or negedge rst_n) begin : mem_array_regs_PROC
// leda S_7R_B off
// LMD: No integer declarations are allowed in sequential blocks 
// LJ: In cases where memory arrays need to be accessed, the use of an indexing 'integer' variable is allowed.
    integer i;
// leda S_7R_B on
    if (rst_n == 1'b0) begin
// leda G_5214_2 off
// LMD: Use Vector operations on arrays rather than for loops
// LJ: The use of a 'for' loop here is allowed in this case due to the nature of this design.
      for (i=0 ; i < DEPTH ; i=i+1)
// leda G_5214_2 on
	mem[i] <= {DATA_WIDTH{1'b0}};
    end else if (init_n == 1'b0) begin
// leda G_5214_2 off
// LMD: Use Vector operations on arrays rather than for loops
// LJ: The use of a 'for' loop here is allowed in this case due to the nature of this design.
      for (i=0 ; i < DEPTH ; i=i+1)
// leda G_5214_2 on
	mem[i] <= {DATA_WIDTH{1'b0}};
    end else begin
      if (write_en_n == 1'b0)
// leda FM_2_22 off
// LMD: Possible range overflow
// LJ: The variable used for indexing is bounded and guaranteed not to go beyond the upper range of the array/vector.  So, disable LEDA from reporting this warning.
	mem[write_addr] <= write_data;
// leda FM_2_22 on
    end
  end

generate
  if ((MEM_MODE & 1) == 1) begin : GEN_RDDAT_REG
    reg [DATA_WIDTH-1:0] data_out_pipe;

    always @ (posedge clk or negedge rst_n) begin : retiming_rddat_reg_PROC
      if (rst_n == 1'b0) begin
	data_out_pipe <= {DATA_WIDTH{1'b0}};
      end else if (init_n == 1'b0) begin
	data_out_pipe <= {DATA_WIDTH{1'b0}};
      end else begin
	data_out_pipe <= read_data;
      end
    end

    assign data_out = data_out_pipe;
  end else begin : GEN_MM_NE_1
    assign data_out = read_data;
  end
endgenerate

generate
  if ((MEM_MODE & 2) == 2) begin : GEN_INPT_REGS
    reg                  we_pipe;
    reg [ADDR_WIDTH-1:0] wr_addr_pipe;
    reg [DATA_WIDTH-1:0] data_in_pipe;
    reg [ADDR_WIDTH-1:0] rd_addr_pipe;

    always @ (posedge clk or negedge rst_n) begin : retiming_regs_PROC
      if (rst_n == 1'b0) begin
	we_pipe <= 1'b0;
	wr_addr_pipe <= {ADDR_WIDTH{1'b0}};
	data_in_pipe <= {DATA_WIDTH{1'b0}};
	rd_addr_pipe <= {ADDR_WIDTH{1'b0}};
      end else if (init_n == 1'b0) begin
	we_pipe <= 1'b0;
	wr_addr_pipe <= {ADDR_WIDTH{1'b0}};
	data_in_pipe <= {DATA_WIDTH{1'b0}};
	rd_addr_pipe <= {ADDR_WIDTH{1'b0}};
      end else begin
	we_pipe <= wr_n_int;
	wr_addr_pipe <= wr_addr;
	data_in_pipe <= data_in;
	rd_addr_pipe <= rd_addr;
      end
    end

    assign write_en_n = we_pipe;
    assign write_data = data_in_pipe;
    assign write_addr = wr_addr_pipe;
    assign read_addr  = rd_addr_pipe;
  end else begin : GEN_MM_NE_2
    assign write_en_n = wr_n_int;
    assign write_data = data_in;
    assign write_addr = wr_addr;
    assign read_addr  = rd_addr;
  end
endgenerate



endmodule
