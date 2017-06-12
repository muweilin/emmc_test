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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_hiu_rbuf.v $ 
// $Revision: #3 $
//
// Abstract  : This module is the Read Buffer of the HIU.  It acts as a
// pre-fetch buffer if AHB master cannot take the data due to BUSY. It also
// combines two SDRAM data to make one AMBA data if the AMBA/SDRAM data width
// ratio is 2:1.
//
//============================================================================

// Naming Conventions
// ------------------
// h*:  AMBA AHB signal
// i_*: input
// o_*: output
// f_*: flip-flop
// n_*: D input to flop
// m_*: wire
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl_hiu_rbuf( hclk,         
                           hresetn,       
                           i_start,      
                           i_done,       
                           i_busy,       
                           i_push_n,     
                           i_pop_n,      
                           i_sel_buf,    
                           i_data,       
                           i_two_to_one, 
			   i_double,
                           o_ready,      
                           o_overflow,   
                           hrdata,
			   big_endian );

   //-------------------------------------------------------------------------
   // I/O
   //-------------------------------------------------------------------------
   
   input                        hclk;           // AMBA HCLK
   input                        hresetn;        // AMBA HRESETn
   input                        i_start;        // Read burst start
   input                        i_done;         // Read burst done
   input                        i_busy;         // AMBA BUSY
   input                        i_push_n;       // Read data push req
   input                        i_pop_n;        // Read data pop  req
   input                        i_sel_buf;      // Buffer data select
   input [`S_RD_DATA_WIDTH-1:0] i_data;         // Read data
   input                        i_two_to_one;   // 2:1 mode
   input 			                  i_double;       // double push flag
   output                       o_ready;        // Read buffer ready
   output                       o_overflow;     // Read buffer overflow
   output [`H_DATA_WIDTH-1:0] 	hrdata;         // AMBA HRDATA
   input 			                  big_endian;     // Big endian mode

   reg                          o_ready;
   reg [`H_DATA_WIDTH-1:0] 	    hrdata;

   //-------------------------------------------------------------------------
   // Registers
   //-------------------------------------------------------------------------

   reg                          f_1st_half;   // first half flag for 2:1
   reg [`H_DATA_WIDTH/2-1:0]   	f_top_data;   // data pre-fetch buf (top)
   reg [`H_DATA_WIDTH/2-1:0]   	f_btm_data;   // data pre-fetch buf (bottom)

   //-------------------------------------------------------------------------
   // Wires
   //-------------------------------------------------------------------------
   
   wire 		                   	m_push_btm;   // push bottom flag
   wire [`H_DATA_WIDTH/2-1:0] 	i_btm_data;   // bottom half data

   //-------------------------------------------------------------------------
   // FSM
   //-------------------------------------------------------------------------
   
   parameter S_RB_IDLE = 2'h0, // idle
             S_RB_WAIT = 2'h1, // wait for read data
             S_RB_BUSY = 2'h2; // AMBA BUSY occurred
   
   reg [1:0] f_rbuf_state, n_rbuf_state; // Read Buf state

   always @ (f_rbuf_state or
              i_start      or
	            i_double     or
              f_1st_half   or
              i_push_n     or
              i_done       or
              o_overflow   or
              i_busy) begin
      o_ready      = 1; // o_ready is 1 even during reset
      n_rbuf_state = f_rbuf_state;
      case (f_rbuf_state)
        S_RB_IDLE:
          if (i_start) n_rbuf_state = S_RB_WAIT; // wait for push
        S_RB_WAIT:
          if (! i_double ||        // not double push, or
               ! f_1st_half) begin // double push second half
             if (! i_push_n) begin
                if (i_start) ; // new read burst (eg. SINGLE), stay here.
                else if (i_done)     n_rbuf_state = S_RB_IDLE;
                else if (o_overflow) n_rbuf_state = S_RB_IDLE;
                else if (i_busy)     n_rbuf_state = S_RB_BUSY;
                // else, stay here
             end else       // no push (yet) - need this even after burst
               o_ready = 0; // (eg. SRAM read pushes data sporadically)
          end else // 2:1 first half
            o_ready = 0; // data is not fully ready
        default: // S_RB_BUSY: // o_ready = 1
          if (i_start)         n_rbuf_state = S_RB_WAIT;
          else if (i_done)     n_rbuf_state = S_RB_IDLE;
          else if (o_overflow) n_rbuf_state = S_RB_IDLE;
          else if (! i_busy)   n_rbuf_state = S_RB_WAIT; // SEQ
          // else (BUSY), stay here
      endcase
   end

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) f_rbuf_state <= S_RB_IDLE;
     else                   f_rbuf_state <= n_rbuf_state;

   // First Half Flag
   // ---------------
   // Reset the flag every time new read burst starts.  
   // The reset makes sure the flag is refreshed each time,
   // because the previous burst may have been terminated at odd number.
   // Toggle only if 2:1 mode (mode may change on the fly).

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0)                   f_1st_half <= 1'b1;
     else begin
	     if (i_start)                         f_1st_half <= 1'b1;
	     else if (i_two_to_one && ! i_push_n) f_1st_half <= ! f_1st_half;
     end

   assign m_push_btm = big_endian ? ! f_1st_half : f_1st_half;
   assign i_btm_data = i_data[`H_DATA_WIDTH/2-1:0];
   
   // Pre-fetch data for BUSY termination.
   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) begin
        f_top_data <= { (`H_DATA_WIDTH / 2) { 1'b0 } };
        f_btm_data <= { (`H_DATA_WIDTH / 2) { 1'b0 } };
     end else begin
	     if (! i_push_n) begin
         if (! i_two_to_one) { f_top_data, f_btm_data } <= i_data; // 1:1
	       else if (! i_double) // not double push
	         { f_top_data, f_btm_data } <= { i_btm_data, i_btm_data };
         else begin // 2:1
           if (m_push_btm) f_btm_data <= i_data;
           else              f_top_data <= i_data;
         end
	     end
     end
   
   // Data output MUX

   always @ (i_sel_buf    or
	            f_top_data   or
	            f_btm_data   or
              i_two_to_one or
	            i_double     or
              i_data       or
	            big_endian   or
              i_btm_data)
     if (i_sel_buf)          hrdata = { f_top_data, f_btm_data };
     else begin
       if (! i_two_to_one)  hrdata = i_data; // 1:1, bypass f_*_data
	     else if (! i_double) hrdata = { i_btm_data, i_btm_data };
       else if (big_endian) hrdata = { f_top_data, i_btm_data };
	     else                   hrdata = { i_btm_data, f_btm_data };
     end

   // Read Data Overflow
   // ------------------
   // Overflow occurs if data is pushed from the MIU, but no pop occurred at
   // the AMBA side at the same time.

   assign o_overflow = i_pop_n && // no pop
		       (i_double ? (! i_push_n && ! f_1st_half) : 
			     ! i_push_n);
   
endmodule // DW_memctl_hiu_rbuf
