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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_miu_dmc.v $ 
// $Revision: #3 $
//
// Abstract  : This module is a subblock of the DW_memctl_miu. During SDRAM or
// Flash power-down, or when  there is an  AHB  data  transfer request but the 
// address cann't be mapped, this module generates fake response  to the the
// hiu without accessing  external  memory in order to  keep AHB bus from
// hanging.
//
//============================================================================
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl_miu_dmc( hclk,
                          hresetn,
                          hiu_req,
                          hiu_rw,
                          hiu_burst_size,
                          hiu_wrapped_burst,
                          hiu_terminate,
                          miu_burst_done,
                          miu_pop_n,
                          miu_push_n);

  input       hclk;
  input       hresetn;
  
  // interface with HIU
  input       hiu_req;                       // HIU data transfer request
  input       hiu_rw;                        // 0: write, 1: read
  input [5:0] hiu_burst_size;                // burst size
  input       hiu_wrapped_burst;             // 1: wrapped burst
  input       hiu_terminate;                 // burst terminate
  output      miu_burst_done;                // burst done
  output      miu_pop_n;                     // pop data from HIU
  output      miu_push_n;                    // push data to HIU

  reg 	      miu_burst_done;
  reg [2:0]   dmc_cs;                        // state register
  reg [2:0]   dmc_ns;
  reg [5:0]   data_cnt;                      // burst size counter
  reg [5:0]   data_cnt_nxt;
  reg 	      miu_pop_n;                     // data pop to HIU
  reg 	      miu_pop_n_nxt;
  reg 	      miu_push_n;                    // data push to HIU
  reg 	      miu_push_n_nxt;
  reg         terminate;

  //------------------------------------------------------------------------
  //FSM states
  //------------------------------------------------------------------------
  `define DM_IDLE 0                          // idle state
  `define DM_READ 1                          // read state
  `define DM_WRITE 2                         // write state
  `define DM_WAIT 3                          // wait for wrapped second part
  `define DM_TERM 4                          // burst terminate state

  //------------------------------------------------------------------------
  // FSM sequential logic
  //------------------------------------------------------------------------
  always @(posedge hclk or negedge hresetn)
  begin: DMCSEQ_PROC
    if(hresetn == 1'b0) begin
      dmc_cs 	    <= `DM_IDLE;
      miu_pop_n     <= 1'b1;
      miu_push_n    <= 1'b1;
      data_cnt 	    <= 6'b000000;
      terminate     <= 1'b0; 
    end
    else begin
      dmc_cs 	    <= dmc_ns;
      miu_pop_n     <= miu_pop_n_nxt | hiu_terminate;
      miu_push_n    <= miu_push_n_nxt | hiu_terminate;
      data_cnt 	    <= data_cnt_nxt;
      terminate     <= hiu_terminate;
    end
  end

  always @(
    dmc_cs or
    hiu_req or
    hiu_rw or
    hiu_burst_size or
    hiu_wrapped_burst or
    terminate or
    data_cnt) 
  begin: DMCCON_PROC
    dmc_ns 	     = dmc_cs;
    miu_pop_n_nxt    = 1'b1;
    miu_push_n_nxt   = 1'b1;
    miu_burst_done   = 1'b0;
    data_cnt_nxt     = 6'b000000;

    case(dmc_cs)

      // idle state
      `DM_IDLE: begin
        if(hiu_req) begin                        // HIU transfer request
          if(hiu_rw == 1'b1) begin               // read req, go to DM_READ
            dmc_ns 	     = `DM_READ;
            miu_push_n_nxt   = 1'b0;
          end
          else begin                        // write req, go to DM_WRITE
            dmc_ns 	     = `DM_WRITE;
            miu_pop_n_nxt    = 1'b0;
          end 
          if(hiu_burst_size > 0)
            data_cnt_nxt     = hiu_burst_size - 1;
        end
      end

      // read state
      `DM_READ: begin
        if(hiu_burst_size == 0) begin            // unspecified-length read
          if(terminate) begin                    // burst early-terminated
            dmc_ns 	         = `DM_IDLE;
            miu_burst_done   = 1'b1;
          end
          else                                   // stay in DM_READ
            miu_push_n_nxt   = 1'b0;
        end
        else if(hiu_wrapped_burst) begin         // wrapped read 
          if(terminate) begin                    // burst early-terminated
            dmc_ns 	         = `DM_TERM;
            miu_burst_done   = 1'b1;
          end
          else if(data_cnt == 0) begin           // burst done
            dmc_ns 	         = `DM_WAIT;
            miu_burst_done   = 1'b1;
          end
          else begin                             // count for burst size
            miu_push_n_nxt   = 1'b0;
            data_cnt_nxt     = data_cnt - 1;
          end
        end
        else begin                               // fixed-length read
          if(terminate) begin                    // burst early-terminated
            dmc_ns           = `DM_IDLE;
            miu_burst_done   = 1'b1;
          end
          else if(data_cnt == 0) begin           // burst done
            dmc_ns           = `DM_IDLE;
            miu_burst_done   = 1'b1;
          end
          else begin                              // count for burst size
            miu_push_n_nxt   = 1'b0;
            data_cnt_nxt     = data_cnt - 1;
          end
        end
      end

      // write state
      `DM_WRITE: begin
        if(hiu_burst_size == 0) begin            // unspecified-length write
          if(terminate) begin                    // burst early-terminated
            dmc_ns 	         = `DM_IDLE;
            miu_burst_done   = 1'b1;
          end
          else                                   // stay in DM_WRITE
            miu_pop_n_nxt    = 1'b0;
        end
        else if(hiu_wrapped_burst) begin         // wrapped write 
          if(terminate) begin                    // burst early-terminated
            dmc_ns 	         = `DM_TERM;
            miu_burst_done   = 1'b1;
          end
          else if(data_cnt == 0) begin           // burst done
            dmc_ns           = `DM_WAIT;
            miu_burst_done   = 1'b1;
          end
          else begin                             // count for burst size
            miu_pop_n_nxt    = 1'b0;
            data_cnt_nxt     = data_cnt - 1;
          end
        end
        else begin                               // fixed-length write
          if(terminate) begin                    // burst early-terminated
            dmc_ns           = `DM_IDLE;
            miu_burst_done   = 1'b1;
          end
          else if(data_cnt == 0) begin           // burst done
            dmc_ns 	         = `DM_IDLE;
            miu_burst_done   = 1'b1;
          end
          else begin                             // count for burst size
            miu_pop_n_nxt    = 1'b0;
            data_cnt_nxt     = data_cnt - 1;
          end
        end 
      end

      // wait for the second part of the wrapped burst
      `DM_WAIT: begin
        if(terminate) begin
          dmc_ns             = `DM_IDLE;
          miu_burst_done     = 1'b1;
        end  
        else begin
          if(hiu_rw == 1'b1) begin               // read req, go to DM_READ
            dmc_ns           = `DM_READ;
            miu_push_n_nxt   = 1'b0;
          end
          else begin                             // write req, go to DM_WRITE
            dmc_ns           = `DM_WRITE;
            miu_pop_n_nxt    = 1'b0;
          end
          if(hiu_burst_size > 0)
            data_cnt_nxt     = hiu_burst_size - 1;
        end
      end 

      // burst termination state
      `DM_TERM: begin
        miu_burst_done       = 1'b1;   
        dmc_ns               = `DM_IDLE;
      end

      // default state
      default: dmc_ns        = `DM_IDLE;
    endcase
  end

endmodule                                        // end of DW_memctl_miu_dmc

  
