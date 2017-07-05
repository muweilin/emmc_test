
//`include "r128a32_25um.v"

module fifo (
	clock,
	reset,
        clear,
	block_size,
	wait_in,
	//wait_out,
	push,
	pop,
	full,
	empty,
	din,
	dout
);

input 			clock;
input 			reset;
input                   clear;
input 			push;
input 			pop;
output 			full;
output 			empty;
output      wait_in;
//output      wait_out;
input 	[31:0] 	din;
output 	[31:0] 	dout;
input   [4:0]   block_size;

wire 	[31:0] 	dout;

reg 	[3:0] 	wptr;
reg 	[3:0] 	rptr;
reg   [3:0]   input_cnt;
reg   [3:0]   input_cnt_d;
reg				last_op;
reg   [31:0] mem [15:0];

wire			full;
wire			empty;
 
always @(posedge clock or negedge reset)
	if (!reset)
		last_op <= 1'b0;
   else if (clear)
    last_op <= 1'b0;
    else begin
        if (!empty && pop && !push)
		  last_op <= 1'b0;
	    else if (!full && push && !pop)
		  last_op <= 1'b1;
	end

always @(posedge clock or negedge reset)
	if (!reset)
	begin
		  rptr <= 4'b0000;
		  wptr <= 4'b0000;
		  input_cnt <= 4'b0;
		end else if(clear)
		begin
		  rptr <= 4'b0000;
		  wptr <= 4'b0000;
		  input_cnt <= 4'b0;
		end
	else begin
	input_cnt <= input_cnt_d;
	if (!empty && pop) 
	begin
		rptr <=  rptr + 4'b1;
		//input_cnt = input_cnt - 1;
		end
		
  if (!full && push)
	begin
		wptr <=  wptr + 4'b1;
		//input_cnt = input_cnt + 1;
		end
end

always @(*) begin
    if (pop && push && !full && !empty) begin
        input_cnt_d = input_cnt;
    end else if (!full && push) begin
        input_cnt_d = input_cnt + 4'b1;
    end else if (!empty && pop && input_cnt != 0) begin
        input_cnt_d = input_cnt -  4'b1;
    end else begin
        input_cnt_d = input_cnt;
    end
end

assign empty = (rptr ==	wptr) && !last_op;
assign full = (wptr == rptr) && last_op;
assign wait_in = (5'd16 - input_cnt) < block_size ? 1'b1 : 1'b0;
//assign wait_out = input_cnt < block_size ? 1:0;
assign dout = mem[{rptr[3:0]}];

always @ (posedge clock)
begin
	if(!full && push)
	mem[{wptr[3:0]}] <= din;
end
 

endmodule





