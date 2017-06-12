`timescale 1ns / 1ps 
`define PCB_CTRL_DELAY      0
//`define PCB_RDMASK_DELAY    1  
`define PCB_RDMASK_DELAY    0  

`define PCB_DQS_DELAY       0 
`define PCB_DQ_DATA_DELAY   0

/////////////////////////////////////

//`define PCB_CTRL_DELAY      2
//`define PCB_RDMASK_DELAY    4  

//`define PCB_DQS_DELAY       2
//`define PCB_DQ_DATA_DELAY   2

/////////////////////////////////////

//`define PCB_CTRL_DELAY      2.5
//`define PCB_RDMASK_DELAY    4  

//`define PCB_DQS_DELAY       2.5
//`define PCB_DQ_DATA_DELAY   2.5

/////////////////////////////////////


module wiredelay 
#(
  parameter Delay = 0
)
(
  inout A,
  inout B,
  input rstn
);  

  reg A_r;
  reg B_r;
  reg line_en;

  assign A = A_r;
  assign B = B_r;

  always @(*) begin
    if (!rstn) begin
      A_r <= 1'bz;
      B_r <= 1'bz;
      line_en <= 1'b0;
    end else begin 
      if (line_en) begin
        A_r <= #Delay B;
	B_r <= 1'bz;
      end else begin
        B_r <= #Delay A;
	A_r <= 1'bz;
      end
    end
  end

  always @(A or B) begin
    if (!rstn) begin
      line_en <= 1'b0;
    end else if (A !== A_r) begin
      line_en <= 1'b0;
    end else if (B_r !== B) begin
      line_en <= 1'b1;
    end else begin
      line_en <= line_en;
    end
  end
endmodule

