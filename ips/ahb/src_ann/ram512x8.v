`timescale 1ns / 1ps

// Ram module for NPU memories,
// to be used during synthesis testing
//
// MEMSEL_W number of MSB's are used to select the memory,
// and the remaining REGSEL_W number of bits are used for
// addressing registers
//
`include "config.sv"
module ram512x8 #(
  parameter DEPTH = 512,
  parameter WIDTH = 8,
  parameter MEMSEL_W = 6,
  parameter REGSEL_W = 9,
  parameter MEM_ADDR = 3'b010
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




wire [1:0]      wen_mux_sel;
wire [1:0]      wea_mux_sel;
wire [2*8-1:0]  dout_mux_sel;
wire [1:0]      cen_v;
wire we_n;
reg Mux;

//genvar i;




assign cen_v = ~{{2{((mem_adr == MEM_ADDR)|~we)}}&{reg_adr[8]==1,
                            reg_adr[8]==0}};

assign we_n = ~we;

// Output assignment
// for ( i = 0 ;i < 8; i = i+1) begin
//   assign dout = wen_mux_sel[i] ? dout_mux_sel[(i+1)*8-1:i*8] : 8'bz;
// end
// assign dout =  wen_mux_sel==0 ? 0: 8'bz;
always@(posedge clk)
begin
    Mux <= reg_adr[10:8] ;
  
end
assign dout = (Mux==0) ? dout_mux_sel[7:0]: dout_mux_sel[15:8];

`ifdef HAPS 
  xilinx_mem_256x8 ram_part0(
    .douta  (dout_mux_sel[7:0]),         //Data outputs
    .clka   (clk),       //clock input
    .ena    (~cen_v[0]),       // enable
    .wea    (~we_n),       //write enable
    .addra  (reg_adr[7:0]),         //Address inputs
    .dina   (din)          //Data inputs
  );
  xilinx_mem_256x8 ram_part1(
      .douta  (dout_mux_sel[15:8]),         //Data outputs
      .clka   (clk),       //clock input
      .ena    (~cen_v[1]),       // enable
      .wea    (~we_n),       //write enable
      .addra  (reg_adr[7:0]),         //Address inputs
      .dina   (din)          //Data inputs
    );
`else

ram_256x8 ram_part0(
    .Q(dout_mux_sel[7:0]),         //Data outputs
    .CLK(clk),       //clock input
    .CEN(cen_v[0]),       // enable
    .WEN(we_n),       //write enable
    .A(reg_adr[7:0]),         //Address inputs
    .D(din)          //Data inputs
  );

ram_256x8 ram_part1(
      .Q(dout_mux_sel[15:8]),         //Data outputs
      .CLK(clk),       //clock input
      .CEN(cen_v[1]),       // enable
      .WEN(we_n),       //write enable
      .A(reg_adr[7:0]),         //Address inputs
      .D(din)          //Data inputs
    );
`endif


endmodule
