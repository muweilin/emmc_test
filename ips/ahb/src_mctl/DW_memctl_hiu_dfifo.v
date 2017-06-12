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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_hiu_dfifo.v $ 
// $Revision: #3 $
//
// Abstract  : This module is the Data FIFO of the HIU.  It stores write data
// and data dependent controls.  It also generates write early termination and
// FIFO underflow alert.
//
//============================================================================

// TWO_TO_ONE - 0=1:1, 1=2:1 AMBA/SDRAM bus ratio

`define TWO_TO_ONE ( ( `H_DATA_WIDTH / `S_RD_DATA_WIDTH ) >> 1 )

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
module DW_memctl_hiu_dfifo( hclk,          
                            hresetn,        
                            i_push_n,      
                            i_pop_n,       
                            i_data,        
                            o_ready,       
                            o_uflow_alert, 
                            o_wr_term,     
                            o_data,
			                      big_endian,
                            i_two_to_one );      

   //-------------------------------------------------------------------------
   // I/O
   //-------------------------------------------------------------------------
   
   input                         hclk;          // AMBA HCLK
   input                         hresetn;       // AMBA HRESETn
   input                         i_push_n;      // FIFO push request
   input                         i_pop_n;       // FIFO pop  request
   input [`DFIFO_IN_WIDTH-1:0]   i_data;        // FIFO input data
   output                        o_ready;       // FIFO ready
   output                        o_uflow_alert; // FIFO underflow alert
   output                        o_wr_term;     // Normal early wr termination
   output [`DFIFO_OUT_WIDTH-1:0] o_data;        // FIFO output data
   input 			                   big_endian;    // Big endian mode
   input                         i_two_to_one;  // 2:1 mode

   reg    [`DFIFO_OUT_WIDTH-1:0] o_data;

   //-------------------------------------------------------------------------
   // Registers
   //-------------------------------------------------------------------------
   
   reg                           f_1st_half; // first half flag for 2:1 mode

   //-------------------------------------------------------------------------
   // Wires
   //-------------------------------------------------------------------------
   
   wire                          m_tm;          // write termination flag
   wire 			                   m_dp;          // double pop flag
   wire                          m_pop_n;       // core FIFO pop request
   wire                          m_empty;       // core FIFO empty
   wire                          m_aempty;      // core FIFO almost empty
   wire                          m_hfull;       // core FIFO half   full
   wire                          m_afull;       // core FIFO almost full
   wire                          m_full;        // core FIFO full
   wire                          m_error;       // core FIFO error
   wire [`DFIFO_IN_WIDTH-1:0]    m_data_out;    // core FIFO output

   //-------------------------------------------------------------------------
   // For readability, define some signals
   //-------------------------------------------------------------------------
   
   wire [`H_DATA_WIDTH/2-1:0] 	 m_top_data;    // top    half data
   wire [`H_DATA_WIDTH/2-1:0] 	 m_btm_data;    // bottom half data

   assign m_top_data = m_data_out[`DFIFO_IN_WIDTH-1:
				  `DFIFO_IN_WIDTH-`H_DATA_WIDTH/2];
   assign m_btm_data = m_data_out[`DFIFO_IN_WIDTH-`H_DATA_WIDTH/2-1:2];

   //-------------------------------------------------------------------------
   // FIFO core
   //-------------------------------------------------------------------------
   
   DW_memctl_hiu_dcore
    #( `DFIFO_IN_WIDTH,    // width
                          `WRITE_FIFO_DEPTH ) // depth
   U_dcore( .clk         ( hclk         ),
            .rst_n       ( hresetn      ),
            .push_req_n  ( i_push_n     ),
            .pop_req_n   ( m_pop_n      ),
            .diag_n      ( 1'b1         ), // inactive
            .data_in     ( i_data       ),
            .empty       ( m_empty      ),
            .almost_empty( m_aempty     ),
            .half_full   ( m_hfull      ), // unused
            .almost_full ( m_afull      ),
            .full        ( m_full       ),
            .err_or      ( m_error      ),
            .data_out    ( m_data_out   ),
            .i_two_to_one( i_two_to_one ) );

   //-------------------------------------------------------------------------
   // FIFO Monitor
   //-------------------------------------------------------------------------
   
   // synopsys translate_off
   // synopsys translate_on

   // First Half Flag
   // ---------------
   // Toggle only if double pop flag is on.
   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) f_1st_half <= 1'b1;
     else begin
	     if (m_dp) begin
	       if (! i_pop_n) f_1st_half <= ! f_1st_half;
	     end else            f_1st_half <= 1'b1; // single pop mode
     end

   // FIFO Pop
   // --------
   // If double pop, pop only at the second half.
   // Otherwise, use pop as is.

   assign m_pop_n = m_dp ? (f_1st_half || i_pop_n) : i_pop_n;

   // FIFO ready
   // ----------
   // The FIFO is NOT ready, if
   // - almost full, and push but no pop, or
   // - full, and no pop, or
   // - full, and pop and push.
   // The FIFO ready has to be a combinatorial logic output because the next
   // cycle push is determined by the current HREADY.
   // This may cause one waste cycle.

   assign o_ready = ! (m_afull && ! i_push_n || m_full);

   // FIFO Underflow Alert (FIFO Becomes Empty at the Next Cycle)
   // -----------------------------------------------------------
   // - First, let's see the following scheme.
   //   - assign o_underflow = m_empty && ! m_pop_n; // empty and pop
   // - The above scheme is too late to flag the underflow because in this 
   //   case, the terminate signal needs to be issued at the same cycle and 
   //   it ends up with a combinational loop from m_pop_n->terminate->m_pop_n.
   // - To solve this problem, the underflow is flaged one cycle ahead to 
   //   alert the FIFO may become empty at the next cycle.
   // - The alert is asserted, if
   //   - the FIFO is empty and no push
   //     -> the FIFO will be empty at the next cycle too
   //   - the FIFO is almost empty and pop occurred without push
   //     -> the FIFO will be empty at the next cycle
   // - The BUSY handler in the control module determines if the current cycle
   //   is the last cycle of the burst or not.
   //   If it's not the last, the control module terminates the burst at the
   //   next cycle.
   // - Note that this scheme may be too pessimistic especially for SRAM 
   //   access because the m_pop_n may be 1 (no pop) at the next cycle.
   //   In that case the underflow won't occur.
   // - Though it's not optimal from the performance point of view, it is 
   //   still a valid operation.

   assign o_uflow_alert = m_empty  && i_push_n || // empty and no push
                          m_aempty && ! m_pop_n && i_push_n;

   assign o_wr_term = m_tm && ! i_pop_n; // normal write termination.

   always @ (m_dp       or
              f_1st_half or
              m_top_data or
              m_btm_data)
     if (`TWO_TO_ONE == 0) begin // 1:1
        if (m_dp && ! f_1st_half) // double pop second half
	        o_data = { m_top_data, m_top_data };
        else //      ~~~~~~~~~~ dummy to lighten load
          o_data = { m_top_data, m_btm_data };
     end else begin // 2:1
        if (f_1st_half) o_data = m_btm_data; // pop bottom
        else              o_data = m_top_data; // pop top
     end

   assign m_dp = m_data_out[1]; // double pop flag
   assign m_tm = m_dp && f_1st_half ? 1'b0 : m_data_out[0];

endmodule // DW_memctl_hiu_dfifo
