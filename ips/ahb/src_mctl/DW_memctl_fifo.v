//============================================================================
//
//                   (C) COPYRIGHT 2001-2011 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc.  Your use or disclosure of this
// software is subject to the terms and conditions of a written
// license agreement between you, or your company, and Synopsys, Inc.
//
// The entire notice above must be reproduced on all authorized copies
//
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_fifo.v $ 
// $Revision: #4 $
//
// Abstract  : DW_memctl, synchronous write, and asynchronous read FIFO. 
// combinational flags and read-data.
//
//============================================================================
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl_fifo (
    data_in ,clk ,rst_n ,push_req_n ,pop_req_n ,diag_n, empty ,full, 
    half_full, almost_full ,almost_empty, data_out, error );

  parameter width = 32;
  parameter depth = 16;
  parameter ae_level = 1;
  parameter af_level = 1;
  parameter err_mode = 0;
  parameter rst_mode = 0;
 
  parameter log_2 = (depth <= 2 ? 1 :
                      (depth <= 4 ? 2 :
                        (depth <= 8 ? 3 :
                          (depth <= 16 ? 4 :
                            (depth <= 32 ? 5 :
                              (depth <= 64 ? 6 :
                                (depth <= 128 ? 7 :
                                  (depth <= 256 ? 8 :
                                    (depth <= 512 ? 9 :
                                      (depth <= 1024 ? 10 : 11))))))))));

  parameter log2_p1 = (depth < 2 ? 1 :
                        (depth < 4 ? 2 :
                          (depth < 8 ? 3 :
                            (depth < 16 ? 4 :
                              (depth < 32 ? 5 :
                                (depth < 64 ? 6 :
                                  (depth < 128 ? 7 :
                                    (depth < 256 ? 8 :
                                      (depth < 512 ? 9 :
                                        (depth < 1024 ? 10 : 11))))))))));

  input  [width-1 : 0] data_in;
  input                clk;
  input                rst_n;
  input                push_req_n;
  input                pop_req_n;
  input                diag_n;

  output               empty;
  output               full;
  output               half_full;   // >= depth/2
  output               almost_empty;          // 1 entry
  output               almost_full;           // depth - 1 entries
  output               error;   
  output [width-1 : 0] data_out;

  reg  [width-1 : 0]     mem[depth-1 : 0];
  reg  [log_2-1 : 0]     in_ptr;
  reg  [log_2-1 : 0]     out_ptr;
  reg  [log2_p1-1 : 0]   count;
  reg                    error_int;

  wire                 push_req_en;
  wire                 pop_req_en;

  assign data_out            = mem[out_ptr]; 
  assign empty               = (count == 0);
  assign full                = (count == depth);
  assign almost_empty        = (count <= ae_level);
  assign almost_full         = (count >= (depth - af_level));
  assign half_full           = (count  >=  depth/2);
  assign push_req_en         = ~push_req_n & (~full | pop_req_en); 
  assign pop_req_en          = ~pop_req_n & ~empty; 
  assign error   = error_int;

  always @ (posedge clk or negedge rst_n)
    begin : mem_SEQ_PROC
      integer i;
      if(~rst_n) begin
        for(i=0; i<depth; i=i+1) begin
          mem[i] <= 0;
        end
      end else begin
        if(push_req_en) begin
          mem[in_ptr] <= data_in;
        end
      end
    end 

  always @ (posedge clk or negedge rst_n)
    begin 
      if(~rst_n)
        begin
          in_ptr   <=  0 ;
          out_ptr  <=  0 ;
          count    <=  0 ;
        end
    else
      begin
        if(push_req_en)
          begin 
            if(in_ptr == depth-1)
              in_ptr     <= 0;
            else
              in_ptr     <= (in_ptr + 1);
          end 
        if(pop_req_en)
          begin
            if(out_ptr == depth-1)
              out_ptr    <= 0;
            else
              out_ptr    <= (out_ptr + 1);
          end
        if(push_req_en && ~pop_req_en)
          count          <= (count + 1);
        else if(~push_req_en && pop_req_en)
          count          <= (count - 1);
      end 
   end 

 always @ (posedge clk or negedge rst_n)
    begin 
      if(~rst_n)
         error_int <= 0;
    else
      error_int <= (~pop_req_n & empty) | (~push_req_n & full & pop_req_n);
 end
endmodule

