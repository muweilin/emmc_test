////////////////////////////////////////////////////////////////////////////////////
// File Name: sigmoid.v
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

module new_sigmoid (
    input                   CLK,
    input                   RST_N,
    input                   npu_en,
    input [2:0]             mode,
    input [ACC_WIDTH-1:0]   din,
    input                   enq,
    input                   deq,
    input                   dout_ack,
    input pu_din_valid ,
    input input_data_en,
    output [DATA_WIDTH-1:0] dout,
    output                  dout_valid,
    output [DATA_WIDTH-1:0] pu_dout,
    output                  pu_dout_valid,
    // ram-specific ports
    input [RAMDATA_W-1:0] ram_din,
    input [REGSEL_W-1:0]  ram_reg_adr,
    input [MEMSEL_W-1:0]  ram_mem_adr,
    input                 ram_we
);

 //   parameter SIG_INIT      = "mif/sigmoid.mif";

reg  [ACC_WIDTH -1 :0]    din_reg         ;
reg  [2:0]                sig_en_hid_dly  ;
reg  [2:0]                sig_en_out_dly  ;
reg                       sigf_enq        ;
reg                       dout_sel        ;
reg  [SIGFIFO_CNT_W-1:0]  fifo_counter    ;
reg                       output_valid    ;
reg  [ACC_WIDTH-1:0]      pu_output       ;


reg  [ACC_WIDTH -1 :0]           din_reg_d ;
reg  [2:0]                sig_en_hid_dly_d ;
reg  [2:0]                sig_en_out_dly_d ;
reg                             sigf_enq_d ;
reg                             dout_sel_d ;
reg  [SIGFIFO_CNT_W-1:0]    fifo_counter_d ;
reg                         output_valid_d ;
reg  [ACC_WIDTH-1:0]           pu_output_d ;

    // reset inversion
   // wire RST;
   // assign RST = ~RST_N;
    always@(posedge CLK or negedge RST_N) begin
    if(!RST_N) 
    begin
    	
    	din_reg          <= 0;  
    	sig_en_hid_dly   <= 0;
    	sig_en_out_dly   <= 0;     
    	sigf_enq         <= 0;
    	dout_sel         <= 0;  
    	fifo_counter     <= 0;
    	output_valid     <= 0;
    	pu_output        <= 0;
 
    	     	
    end
    else if(~npu_en)
    begin
      din_reg          <= 0;  
    	sig_en_hid_dly   <= 0;
    	sig_en_out_dly   <= 0;     
    	sigf_enq         <= 0;
    	dout_sel         <= 0;  
    	fifo_counter     <= 0;
    	output_valid     <= 0;
    	pu_output        <= 0;
    //output_valid     <=  0; 
    //sig_en_out_dly   <= 0; 
    end
    else if(pu_din_valid || ~input_data_en)
    begin
    	din_reg          <=        din_reg_d;  
    	sig_en_hid_dly   <= sig_en_hid_dly_d;
    	sig_en_out_dly   <= sig_en_out_dly_d;     
    	sigf_enq         <=       sigf_enq_d;
    	dout_sel         <=       dout_sel_d;  
    	fifo_counter     <=   fifo_counter_d;
    	output_valid     <=   output_valid_d;
      pu_output        <=      pu_output_d;
    
    
    end
  
    
    end
    


    // Sigmoid enable
    wire                    sig_en_hid;
    wire                    sig_en_out;
    // Sigmoid inputs/outputs
    wire [ACC_WIDTH-1:0]    sig_in;
    wire [SIGMODE_W-1:0]    sig_mode;
    wire [DATA_WIDTH-1:0]   sig_out;
    // Sigmoid FIFO inputs
    wire [DATA_WIDTH-1:0]   sigf_din;
    wire                    sigf_deq;
    // Sigmoid FIFO outputs
    wire [DATA_WIDTH-1:0]   sigf_dout;
    wire                    sigf_full;
    wire                    sigf_empty;
    // Use sigmoid (signal is unused)
    wire                    use_sigmoid;

    // Use sigmoid unit
    assign use_sigmoid      = enq & mode[1];

    // Hidden layer sigmoid
    assign sig_en_hid       = enq & ~mode[2];

    // Output layer sigmoid
    assign sig_en_out       = enq & mode[2];

    // Sigmoid input logic
    assign sig_in           = (enq == 1'b1) ? din : 0;
    assign sig_mode         = (enq == 1'b1) ? mode : 0;

    // Sigmoid FIFO input logic
    assign sigf_din         = sig_out;
    assign sigf_deq         = deq & ~sigf_empty;

    // Output logic
    assign dout             = sigf_dout;
    assign dout_valid       = output_valid;
    assign pu_dout          = pu_output;
    assign pu_dout_valid    = sig_en_out_dly[1];

    // Delay signals
    always @ (*) begin

        // Data in reg
        din_reg_d               = din;

        // Sigmoid fifo enq
        sigf_enq_d              = mode==IM_DSTSEL_SIG1 || mode==IM_DSTSEL_SIG2 ;

        // Delay signals using shift registers
        sig_en_hid_dly_d        = {sig_en_hid_dly[1:0],sig_en_hid};
        sig_en_out_dly_d        = {sig_en_out_dly[1:0],sig_en_out};

        // Output logic
        dout_sel_d              = (mode==IM_DSTSEL_OSIG0) ? 1'b1 : 1'b0;
        pu_output_d             = (dout_sel==1'b1) ? din_reg[DATA_WIDTH+WGHT_DEC_WIDTH+SIG_LSHIFT-1:WGHT_DEC_WIDTH+SIG_LSHIFT] : sig_out;

        // Output valid computation
        output_valid_d          = output_valid;
        if (sig_en_hid_dly[1]==1'b1) begin
            if (dout_ack==1'b1) begin
                fifo_counter_d          =   fifo_counter;
            end else begin
                fifo_counter_d          =   fifo_counter + 1;
                if (fifo_counter==0)
                    output_valid_d      = 1'b1;
            end
        end else begin
            if (dout_ack==1'b1) begin
                fifo_counter_d          =   fifo_counter - 1;
                if (fifo_counter==1)
                    output_valid_d      = 1'b0;
            end else begin
                fifo_counter_d          =   fifo_counter;
            end
        end
    end

    // Sigmoid unit instantiation
    sigmoid_lut sig (
        .clk(CLK),
        .rst_n(RST_N),
        .npu_en(npu_en),
        .mode(sig_mode),
        .din(sig_in),
        .dout(sig_out),
        .pu_din_valid (pu_din_valid ),
        .input_data_en(input_data_en),
        // ram-specific ports
        .ram_din(ram_din),
        .ram_reg_adr(ram_reg_adr),
        .ram_mem_adr(ram_mem_adr),
        .ram_we(ram_we)
    );

    // Sigmoid FIFO instatiation
    wire [SIGFIFO_CNT_W:0] sigf_count;
    fifo_fwf_128x8 #(
         .WIDTH(DATA_WIDTH),
         .DEPTH(SIGFIFO_DEPTH),
         .AW(SIGFIFO_CNT_W))
    sig_fifo (
       .clk(CLK),
       .npu_en(npu_en),
       .rst_n(RST_N),
       .wr_en(sigf_enq),
       .rd_en(sigf_deq),
       .din(sigf_din),
       .dout(sigf_dout),
       .empty(sigf_empty),
       .full(sigf_full),
       .data_count(sigf_count)
    );

endmodule
