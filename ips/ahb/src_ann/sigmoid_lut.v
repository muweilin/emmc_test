////////////////////////////////////////////////////////////////////////////////////
// File Name: sigmoid_lut.v
// Author: Thierry Moreau
// Email: moreau@uw.edu
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
`include "sigmoid.inc"
`include "npu.inc"
`include "macros.inc"   
`include "params.inc" 

module sigmoid_lut (
    input clk,
    input rst_n,
    input npu_en,
    input [SIGMODE_W-1:0] mode,
    input [ACC_WIDTH-1:0] din,
    input pu_din_valid,
    input input_data_en,
    output reg [7:0] dout,
    // ram-specific ports
    input [RAMDATA_W-1:0] ram_din,
    input [REGSEL_W-1:0]  ram_reg_adr,
    input [MEMSEL_W-1:0]  ram_mem_adr,
    input                 ram_we
);

// Include parameters
 

    // Sigmoid registers
    reg [SIGMODE_W-1:0] mode_dly;
    reg [DATA_WIDTH-1:0] d_small;
    reg NE;
    reg PSM;
    reg NSM;
    reg POF;
    reg NOF;

    // Steepness
    wire [ACC_WIDTH-1:0] scaled_din;
    assign scaled_din = {{SIG_LSHIFT{din[ACC_WIDTH-1]}},{din[ACC_WIDTH-1:SIG_LSHIFT]}};

    wire [INDEX_WIDTH-1:0] lut_index;
    assign lut_index =  scaled_din[ACC_WIDTH-1:PRECISION_SHIFT];

    // ===================
    // Sigmoid RAM
    // ===================
    wire [DATA_WIDTH-1:0]       lut_dout;
    wire [DATA_WIDTH-1:0]       lut_doutd;
    reg  [REGSEL_W-1:0]         reg_adr;  
    reg  [INDEX_WIDTH-1:0] lut_index_d;
    wire [MEMSEL_W-1:0]         mem_adr = ram_mem_adr;
    // RAM address mux
    always @(posedge clk or negedge rst_n)
    begin
    	if(!rst_n) 
    	lut_index_d<=0;
      else if(~npu_en)
      lut_index_d<=0;
    	else if(pu_din_valid || ~input_data_en)  
    	lut_index_d <= lut_index;
    end
    always @(*) begin
        if (ram_we)  reg_adr = ram_reg_adr;
       // else if(~npu_en)
        //    reg_adr = 0;
      else  if(pu_din_valid || ~input_data_en)  reg_adr = lut_index[LOG_SIG_LUT_DEPTH-1:0];
        else reg_adr = lut_index_d[LOG_SIG_LUT_DEPTH-1:0];//reg_adr = reg_adr;
    end
    
  //  always @(*) begin
  //      if (rst_n == 1'b0)  lut_dout = 0;
  //      else  if(pu_din_valid || ~input_data_en)   lut_dout = lut_doutd;;
  //  end
    // RAM instantiation
    ram512x8 #(
        .WIDTH(DATA_WIDTH),
        .DEPTH(SIG_LUT_DEPTH),
        .MEMSEL_W(MEMSEL_W),
        .REGSEL_W(REGSEL_W),
        .MEM_ADDR(SIG_RAM_ADR)
    ) sig_lut (
        .clk(clk),
        .mem_adr(mem_adr),
        .reg_adr(reg_adr),
        .din(ram_din[DATA_WIDTH-1:0]),
        .we(ram_we),
        .dout(lut_dout)
    );

    // Main Datapath
    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            mode_dly <= 0;
            d_small <= 0;
            NE <= 0;
            PSM <= 0;
            NSM <= 0;
            POF <= 0;
            NOF <= 0;
        
        end  else if(~npu_en)begin
        	 mode_dly <= 0;
            d_small <= 0;
            NE <= 0;
            PSM <= 0;
            NSM <= 0;
            POF <= 0;
            NOF <= 0;
        end
         else if(pu_din_valid || ~input_data_en) begin
            // latch mode
            mode_dly <= mode;

            // latch input
            d_small <= scaled_din[DATA_WIDTH+SIG_IN_PREC-SIG_OUT_PREC-1:SIG_IN_PREC-SIG_OUT_PREC];

            // positive overflow flag
            if ( !lut_index[17] && |lut_index[16:8])
                POF <= 1'b1;
            else
                POF <= 1'b0;
            // negative overflow flag
            if (lut_index[17] && ~&lut_index[16:8])
                NOF <= 1'b1;
            else
                NOF <= 1'b0;
            // positive small value flag
            if ($signed(lut_index) < PCUTOFF)
                PSM <= 1'b1;
            else
                PSM <= 1'b0;
            // positive small value flag
            if ($signed(lut_index) > NCUTOFF)
                NSM <= 1'b1;
            else
                NSM <= 1'b0;
            // negative flag
            NE <= din[ACC_WIDTH-1];
        end
    end

    // Used for non-symmetrical sigmoid
    wire [DATA_WIDTH:0] dout_p1;
    assign dout_p1 = {lut_dout[DATA_WIDTH-1],lut_dout[DATA_WIDTH-1:0]}+ONE;
    wire [DATA_WIDTH:0] dsmall_p1;
    assign dsmall_p1 = {d_small[DATA_WIDTH-1],d_small[DATA_WIDTH-1:0]}+ONE;

    // Output logic
    // Change output to be combinational reg
    // always @ (posedge clk) begin
    always @ (*) begin
        if (npu_en == 1'b0)
            dout = 0;
        else  //if(pu_din_valid || ~input_data_en) begin
            if (mode_dly[1:0] == SIGMODE_SYMMETRIC) begin
                if (POF == 1'b1)
                    dout = MAXVAL;
                else if (NOF == 1'b1)
                    dout = MINVAL;
                else if ((PSM==1'b1 & NE==1'b0) | (NSM==1'b1 & NE==1'b1))
                    dout = d_small;
                else
                    dout = lut_dout;
            end else if (mode_dly[1:0] == SIGMODE_SIGMOID) begin
                if (POF == 1'b1)
                    dout = MAXVAL;
                else if (NOF == 1'b1)
                    dout = 0;
                else if ((PSM==1'b1 & NE==1'b0) | (NSM==1'b1 & NE==1'b1))
                    dout = {1'b0, dsmall_p1[DATA_WIDTH-1:1]};
                else
                    dout = {1'b0, dout_p1[DATA_WIDTH-1:1]};
            end else begin // assume it is linear
                dout = d_small;
            end
      //  end
    end

endmodule
