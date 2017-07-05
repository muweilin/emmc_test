////////////////////////////////////////////////////////////////////////////////////
// File Name: params.inc
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
`ifndef PARAMS_INC
`define PARAMS_INC
// Top-level Parameters
//`include "npu.inc"

// Derived params
localparam LOG_PE           = ((NUM_PE) <= 1) ? 0 :
                              ((NUM_PE) <= 2) ? 1 :
                              ((NUM_PE) <= 4) ? 2 :
                              ((NUM_PE) <= 8) ? 3 :
                              ((NUM_PE) <= 16) ? 4 :
                              ((NUM_PE) <= 32) ? 5 :
                              ((NUM_PE) <= 64) ? 6 : 0;
localparam MAX_ID           = NUM_PE-1;

// RAM depth parameters
// ======================
// weight caches (weight and offset)
localparam WE_ADDR_SPACE        = WEIGHT_COUNT_MAX;
localparam LOG_WE_ADDR_SPACE    = LOG_WEIGTH_COUNT_MAX;
localparam WEIGHT_RAM_DEPTH     = WE_ADDR_SPACE/NUM_PE;
localparam WEIGHT_ADDR_W        = LOG_WE_ADDR_SPACE-LOG_PE;
// instruction memory
localparam IM_RAM_DEPTH         = INPUT_NEURONS_MAX;
localparam IM_ADDR_WIDTH        = LOG_INPUT_NEURONS_MAX;
// sigmoid fifo
localparam SIGFIFO_DEPTH        = 128;  //OUTPUT_NEURONS_MAX;
localparam SIGFIFO_CNT_W        = 7;    //LOG_OUTPUT_NEURONS_MAX;
// acc fifo
localparam ACCFIFO_DEPTH        = 128; //OUTPUT_NEURONS_MAX;
localparam ACCFIFO_CNT_W        = 7;   //LOG_OUTPUT_NEURONS_MAX;
// input fifo
localparam IFIFO_DEPTH          = 512; //INPUT_NEURONS_MAX;
localparam IFIFO_CNT_W          = 9;   //LOG_INPUT_NEURONS_MAX;
localparam IFIFO_THRSHLD        = 1;
// output fifo
localparam OFIFO_DEPTH          = 521; //OUTPUT_NEURONS_MAX;
localparam OFIFO_CNT_W          = 9;   //LOG_OUTPUT_NEURONS_MAX;

// Microcode
localparam IM_SRC_WIDTH         = 1; //  source bits
localparam IM_LST_WIDTH         = 1; //  last bit
localparam IM_DST_WIDTH         = 3; //  destination bits
localparam IM_MADD_WIDTH        = LOG_OUTPUT_NEURONS_MAX; //  number of multiply and add - limit of 64 neurons per layer
localparam IM_PEID_WIDTH        = LOG_INPUT_NEURONS_MAX; // pe ID - limit to 1024 neurons
// Derived indices
localparam IM_SRC_IDX           = 0;
localparam IM_LST_IDX           = IM_SRC_IDX+IM_SRC_WIDTH;
localparam IM_DST_IDX           = IM_LST_IDX+IM_LST_WIDTH;
localparam IM_MADD_IDX          = IM_DST_IDX+IM_DST_WIDTH;
localparam IM_PEID_IDX          = IM_MADD_IDX+IM_MADD_WIDTH;
// Full IM WIDTH
localparam IM_WIDTH             = IM_SRC_WIDTH+IM_LST_WIDTH+IM_DST_WIDTH+IM_MADD_WIDTH+IM_PEID_WIDTH;

// RAM addresses
localparam IM_RAM_ADR       = 4'b0001;
localparam SIG_RAM_ADR      = 4'b0010;
localparam BIAS_RAM_ADR     = 4'b0011;
localparam WEIGHT_RAM_ADR   = 4'b0100;

// RAM-related bus widths
localparam RAMDATA_W  = IM_WIDTH;
localparam MEMSEL_W   = 3+LOG_PE;
localparam REGSEL_W   = LOG_WE_ADDR_SPACE;

// PE Command related widths
localparam PECMD_LST_WIDTH      = IM_LST_WIDTH; // last bit
localparam PECMD_DST_WIDTH      = IM_DST_WIDTH; // destination bits
localparam PECMD_MADD_WIDTH     = IM_MADD_WIDTH; // number of multiply and add
localparam PECMD_PEID_WIDTH     = LOG_PE; // pe ID
localparam PECMD_ACCSEL_WIDTH   = 1; // accumulator select
// Derived indices
localparam PECMD_LST_IDX        = 0;
localparam PECMD_DST_IDX        = PECMD_LST_IDX+PECMD_LST_WIDTH;
localparam PECMD_MADD_IDX       = PECMD_DST_IDX+PECMD_DST_WIDTH;
localparam PECMD_PEID_IDX       = PECMD_MADD_IDX+PECMD_MADD_WIDTH;
localparam PECMD_ACCSEL_IDX     = PECMD_PEID_IDX+PECMD_PEID_WIDTH;
// Full PECMD WIDTH
localparam PECMD_WIDTH          = PECMD_LST_WIDTH+PECMD_DST_WIDTH+PECMD_MADD_WIDTH+PECMD_PEID_WIDTH+PECMD_ACCSEL_WIDTH;

// Instruction decoding
localparam IM_LAST_NEURON    = 1'b1;

localparam IM_DINSEL_DIN     = 1'b0;
localparam IM_DINSEL_SIG     = 1'b1;

localparam IM_DSTSEL_NONE    = 3'b000;
localparam IM_DSTSEL_SIG0    = 3'b001;
localparam IM_DSTSEL_SIG1    = 3'b010;
localparam IM_DSTSEL_SIG2    = 3'b011;
localparam IM_DSTSEL_OSIG0   = 3'b101;
localparam IM_DSTSEL_OSIG1   = 3'b110;
localparam IM_DSTSEL_OSIG2   = 3'b111;

// Sigmoid Parameters
//`include "sigmoid.inc"
`endif
