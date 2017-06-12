////////////////////////////////////////////////////////////////////////////////////
// File Name: acc_fifo.v
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


  
module acc_fifo (
    input                   CLK,
    input                   RST_N,
    input                   npu_en,
    input [ACC_WIDTH-1:0]   din,
    input                   enq,
    input                   deq,
    output [ACC_WIDTH-1:0]  dout,
    output                  empty
);

  

    // Sigmoid FIFO inputs
    wire [ACC_WIDTH-1:0]    accf_din;
    wire                    accf_enq;
    wire                    accf_deq;
    // Sigmoid FIFO outputs
    wire [ACC_WIDTH-1:0]    accf_dout;
    wire                    accf_full;
    wire                    accf_empty;

    // Sigmoid FIFO input logic
    assign accf_din         = din;
    assign accf_enq         = enq;
    assign accf_deq         = deq & ~accf_empty;

    // Output logic
    assign empty            = accf_empty & ~enq;
    assign dout             = accf_dout;

    wire [SIGFIFO_CNT_W:0] accf_count;
    fifo_fwf_128x26 #(
        .WIDTH(ACC_WIDTH),
        .DEPTH(ACCFIFO_DEPTH),
        .AW(ACCFIFO_CNT_W))
    sig_fifo (
       .clk(CLK),
       .npu_en(npu_en),
       .rst_n(RST_N),
       .wr_en(accf_enq),
       .rd_en(accf_deq),
       .din(accf_din),
       .dout(accf_dout),
       .empty(accf_empty),
       .full(accf_full),
       .data_count(accf_count)
    );

endmodule
