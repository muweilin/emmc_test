

module busreq_sm (
		hclk,
		hreset,
		dma_en,
		req_done,
		full,
		wait_in,
		pre_ram,
		disable_rdreq,
		
		wrt_req_en,
		rd_req,
		wr_req,
		rd_update,
		wr_update
		);

input			hclk;
input			hreset;
input			dma_en;
input			req_done;
input			full;
input     wait_in;
input     disable_rdreq;
input     wrt_req_en;
input     pre_ram;

output      rd_req;
output			wr_req;
output			rd_update;	// Read Address Update
output			wr_update;	// Write Address Update

reg		[2:0]	state;
reg		[2:0]	nextstate;
wire			rd_req;
wire			wr_req;
wire			rd_update;
wire			wr_update;

// ******************************************************
// Parameter Definition for State
// ******************************************************
parameter         IDLE                = 3'b000;
parameter         INIT                = 3'b001;
parameter         WRREQ               = 3'b010;
parameter         RDREQ               = 3'b011;
parameter         WRDONE              = 3'b110;
parameter         RDDONE              = 3'b111;

assign rd_req = (state == RDREQ);
assign wr_req = (state == WRREQ);
assign rd_update = (state == RDDONE);
assign wr_update = (state == WRDONE);

always @(posedge hclk or negedge hreset)
	if (!hreset) begin
		state <=  IDLE;
	end
	else begin
		state <=  nextstate;
	end

always @(state or dma_en or full or req_done or disable_rdreq or wrt_req_en or wait_in or pre_ram)

	case(state)
		IDLE: 	if (dma_en)
						nextstate = INIT;
				else
						nextstate = IDLE;
		INIT:  	if(~dma_en)
						nextstate = IDLE;
				else if (wrt_req_en)
						nextstate = WRREQ;	
				else if (((~wait_in && !full)||~pre_ram) && ~disable_rdreq)
						nextstate = RDREQ;
				else 
						nextstate = INIT;
		WRREQ:  if (req_done)
						nextstate = WRDONE;
				else
						nextstate = WRREQ;
		RDREQ:  if (req_done)
						nextstate = RDDONE;
				else
						nextstate = RDREQ;
		WRDONE:	if(~dma_en)
						nextstate = IDLE;
				else if (((~wait_in && !full)||~pre_ram) && ~disable_rdreq) 
						nextstate = RDREQ;
				else
						nextstate = INIT;
		RDDONE: if(~dma_en)
						nextstate = IDLE;
				else if (wrt_req_en)
						nextstate = WRREQ;	
				else 
						nextstate = INIT;
		default:	nextstate = IDLE;
	endcase

endmodule
