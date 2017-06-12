`timescale 1ns / 1ps

// Ram module for NPU memories,
// to be used during synthesis testing
//
// MEMSEL_W number of MSB's are used to select the memory,
// and the remaining REGSEL_W number of bits are used for
// addressing registers
//
`include "config.sv"
module ram1024x21 #(
  parameter DEPTH = 1024,
  parameter WIDTH = 21,
  parameter MEMSEL_W = 6,
  parameter REGSEL_W = 11,
  parameter MEM_ADDR = 3'b000
)(
  dout,
  mem_adr,
  reg_adr,
  clk,
  din,
  we
);

// Outputs
output [WIDTH-1:0]    dout;    // RAM data output

// Inputs
input [MEMSEL_W-1:0]  mem_adr; // memory selection address
input [REGSEL_W-1:0]  reg_adr; // register selection address
input                 clk;     // clock
input [WIDTH-1:0]     din;     // mem data input
input                 we;      // write enable (active high)

wire  [23:0] dout_reg;
wire   wea;
assign   wea = (mem_adr==MEM_ADDR&&we)?1'b1:1'b0;



assign dout = dout_reg[WIDTH-1:0];
`ifdef HAPS 
  xilinx_mem_1024x24
  ram_uut
  (
    .clka   ( clk                    ),
    .ena    ( 1'b1                   ),
    .addra  ( reg_adr ),
    .dina   ( {3'b0,din}             ),
    .douta  ( dout_reg               ),
    .wea    ( wea       )
  );

`else
ram_1024x24  ram_uut(
        .Q(dout_reg),       //Data outputs
			  .CLK(clk),     //clock input
			  .CEN(1'b0),     //enable
			  .WEN(~wea),     //write enable
			  .A(reg_adr),       //Address inputs
			  .D({3'b0,din})        //Data inputs
);

`endif


endmodule
