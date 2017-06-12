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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_hiu_afifo.v $ 
// $Revision: #3 $
//
// Abstract  : This module is the Address FIFO of the HIU.  It stores the 
// memory burst start address/register address, and burst dependent controls.
// For an AHB wrapping burst, two addresses are pushed at the same time. It
// also generates HIU request to the MIU.
//
//============================================================================

// Naming Conventions
// ------------------
// h*:    AMBA AHB signal
// hiu_*: HIU output to MIU
// i_*:   input
// o_*:   output
// f_*:   flip-flop
// n_*:   D input to flop
// m_*:   wire
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl_hiu_afifo( hclk,        
                            hresetn,      
                            i_push1_n,   
                            i_push2_n,   
                            i_pop_n,     
                            i_data1,     
                            i_data2,     
                            o_ready,     
                            hiu_req,     
                            o_new_req,   
                            o_dummy_req,
                            o_data );

   //-------------------------------------------------------------------------
   // I/O
   //-------------------------------------------------------------------------

   input                         hclk;        // AMBA HCLK                    
   input                         hresetn;     // AMBA HRESETn
   input                         i_push1_n;   // FIFO push req 1 (low active)
   input                         i_push2_n;   // FIFO push req 2 (low active)
   input                         i_pop_n;     // FIFO pop  req   (low active)
   input  [`AFIFO_IN_WIDTH-1:0]  i_data1;     // FIFO input data 1
   input  [`AFIFO_IN_WIDTH-1:0]  i_data2;     // FIFO input data 2
   output                        o_ready;     // FIFO ready
   output [1:0]                  hiu_req;     // Memory/register access req
   output                        o_new_req;   // New MIU request pulse
   output                        o_dummy_req; // MIU dummy request
   output [`AFIFO_OUT_WIDTH-1:0] o_data;      // FIFO output data

   //-------------------------------------------------------------------------
   // Registers
   //-------------------------------------------------------------------------

   reg [`AFIFO_IN_WIDTH-1:0]     f_data2;         // data2 buffer
   reg                           f_push2_pending; // push2 status
   reg                           f_core_ready;    // FIFO core ready
   wire                          n_core_ready;    // (next)
   reg                           f_new_req;       // new MIU request pulse
   wire                          n_new_req;       // (next)
   reg                           f_clr_pers;      // clear persistence
   reg 				                   f_ready;         // FIFO ready

   //-------------------------------------------------------------------------
   // Wires
   //-------------------------------------------------------------------------

   wire [1:0] 			             m_hiu_req;
   wire                          m_push2_n;  // core FIFO push request 2
   wire                          m_pop_n;    // core FIFO pop  request
   wire                          m_empty;    // core FIFO empty
   wire                          m_aempty;   // core FIFO almost empty
   wire 			                   m_hfull;    // core FIFO half   full
   wire                          m_afull;    // core FIFO almost full
   wire                          m_full;     // core FIFO full
   wire                          m_error;    // core FIFO error
   wire [`AFIFO_IN_WIDTH:0]      m_data1_in; // AFIFO_IN_WIDTH + 1
   wire [`AFIFO_IN_WIDTH:0]      m_data2_in; // AFIFO_IN_WIDTH + 1
   wire [`AFIFO_IN_WIDTH:0]      m_data_in;  // AFIFO_IN_WIDTH + 1
   wire [`AFIFO_IN_WIDTH:0]      m_data_out; // AFIFO_IN_WIDTH + 1
   wire                          m_push_n;   // core FIFO push req (1 or 2)
   wire                          m_pers;     // persistence flag bit

   //-------------------------------------------------------------------------
   // FIFO core
   //-------------------------------------------------------------------------
   
   DW_memctl_hiu_acore
    #( `AFIFO_IN_WIDTH + 1, // width (w/persistence flag)
                          `ADDR_FIFO_DEPTH )   // depth
   U_acore( .clk         ( hclk       ),
            .rst_n       ( hresetn    ),
            .push_req_n  ( m_push_n   ),
            .pop_req_n   ( m_pop_n    ),
            .diag_n      ( 1'b1       ), // inactive
            .data_in     ( m_data_in  ),
            .empty       ( m_empty    ),
            .almost_empty( m_aempty   ),
            .half_full   ( m_hfull    ), // unused
            .almost_full ( m_afull    ),
            .full        ( m_full     ),
            .err_or      ( m_error    ),
            .data_out    ( m_data_out ) );

   //-------------------------------------------------------------------------
   // FIFO Monitor
   //-------------------------------------------------------------------------
   
   // synopsys translate_off
   // synopsys translate_on

   //-------------------------------------------------------------------------
   // Internal signals
   //-------------------------------------------------------------------------
   
   assign m_push_n = i_push1_n && m_push2_n;      // either push1 or push2
   assign m_pers   = m_data_out[`AFIFO_IN_WIDTH]; // persistence flag bit

   // Data2 and Push2 Handling
   // ------------------------
   // Register push2 and data2, when new push2 request is issued.
   // Clear the push2 pending flag when actual push to the core FIFO happened.
   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0)      f_push2_pending <= 1'b0;
     else begin 
	     if (i_push2_n == 1'b0)      f_push2_pending <= 1'b1; // register push
	     else if (m_push2_n == 1'b0) f_push2_pending <= 1'b0; // push2 done
     end
   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0)   f_data2 <= { `AFIFO_IN_WIDTH { 1'b0 } };
     else if (! i_push2_n) f_data2 <= i_data2; // enable the data2 write

   // Persistence Flag
   // ----------------
   // If another push1 occurs while push2 is pending, it means the wrapping
   // burst has terminated at the first data.
   // In this case, ignore the saved data (f_data2) and push new data 
   // (i_data1) with a persistence flag.
   // The termination at the first wrapping forces the MIU to pop address 
   // twice.
   // The first miu_pop_n pops the active address.
   // The second miu_pop_n is ignored because of the persistence flag.
   // The pending flag of push2 will be cleared by m_push2_n (the new push1 
   // means f_core_ready is high).
   // If the next request is also wrapping burst, i_push2_n sets the pending
   // flag again.

   assign m_data1_in = { (f_push2_pending && ! i_push1_n ? 1'b1 : 1'b0),
                         i_data1 };
   assign m_data2_in = { 1'b0, f_data2 }; // never be persistent
   assign m_data_in  = ! i_push1_n ? m_data1_in : m_data2_in;

   // Core FIFO Push
   // --------------
   // The push1 is guaranteed to be accepted because the FIFO status is 
   // checked before issuing it.
   // On the other hand, the push2 has to check the Addr FIFO status before 
   // push, because the FIFO may become full after the push1.

   assign m_push2_n = ! (f_push2_pending && f_core_ready);

   // Core FIFO Pop
   // -------------
   // If persistence flag is on and clear persistence is off, no pop.
   // Otherwise (no persistence flag or clear persistence), do pop if any.
   // The clear persistence toggles every time persistent data is asked to be
   // popped.

   assign m_pop_n = o_dummy_req ? 1 : i_pop_n;

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0)           f_clr_pers <= 1'b0;
     else if (! i_pop_n && m_pers) f_clr_pers <= ! f_clr_pers;
   
   // FIFO Output
   // -----------
   // Discard persistence flag (m_pers=m_data_out[`AFIFO_IN_WIDTH]) and
   // type of request (m_data_out[1:0]).
   // If dummy request, force hiu_wrapped_burst to 0 because the dummy request
   // has to pretend to be the second wrapping.

   assign o_data = { m_data_out[`AFIFO_IN_WIDTH-1:11], 1'b0, m_data_out[9:4],
                     (o_dummy_req ? 1'b0 : m_data_out[3]),
                     m_data_out[2] };
   
   // Internal FIFO Ready
   // -------------------
   // The FIFO core is NOT ready at the next cycle, if
   // - almost full and push, but no pop, or
   // - full and no pop, or
   // - full and pop, but push.

   assign n_core_ready = ! (m_afull && ! m_push_n &&   m_pop_n ||
                             m_full  &&                 m_pop_n ||
                             m_full  && ! m_push_n && ! m_pop_n);

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) f_core_ready <= 1'b1;
     else                   f_core_ready <= n_core_ready;

   // External FIFO Ready
   // -------------------
   // If the FIFO core is full and a push 2 is pending, the o_ready will be 
   // low even though f_core_ready will become high (n_core_ready is high), 
   // because the available spot will be taken by the pending push.
   // In this case, HREADY would become low due to 2 address pushes of WRAP4,
   // if there is no IDLE.  However, because of IDLE, the HREADY is forced to
   // be high.  This causes address FIFO overflow.  To prevent this, 
   // use m_afull instead of m_full, then the IDLE will be extended.

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0)
       f_ready <= 1'b1;
     else
       f_ready <= n_core_ready; 

   assign o_ready = f_ready && ! (m_afull && f_push2_pending); 

   // HIU Request
   // -----------
   // If dummy request, turn down the hiu_req.
   
   assign m_hiu_req[1] = ! m_empty && m_data_out[0] == 1 && ! o_dummy_req;
   assign m_hiu_req[0] = ! m_empty && m_data_out[0] == 0 && ! o_dummy_req;

   assign hiu_req = m_hiu_req;

   // New HIU Request Pulse
   // ---------------------
   // MIU will have a new request, if
   // - a new address is pushed to the empty FIFO, or
   // - an address is popped from the FIFO (but cannot be from the almost 
   //   empty FIFO because the FIFO will become empty (in this case no new 
   //   address will be sent)), or
   // - an address is popped from almost empty FIFO, but push occurs at the
   //   same time.

   assign n_new_req =   m_empty  && ! m_push_n ||            // first req
                      ! m_aempty && ! i_pop_n  ||            // req from FIFO
                        m_aempty && ! i_pop_n && ! m_push_n; // req from in
 
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) f_new_req <= 1'b0;
     else                   f_new_req <= n_new_req;

   assign o_new_req   = f_new_req;
   assign o_dummy_req = m_pers && ! f_clr_pers; // persistent req be ignored
   
endmodule // DW_memctl_hiu_afifo
