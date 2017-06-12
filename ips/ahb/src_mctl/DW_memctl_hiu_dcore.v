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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_hiu_dcore.v $ 
// $Revision: #3 $
//
// Abstract  : This module is the FIFO core of the Data FIFO.  It is a wrapper
// of the DW_fifo_s1_sf.  The interface is same as DW_fifo_s1_sf. The core
// improves the output data timing.
//
//============================================================================

// [condition coverage]
// 1. m_EMPTY == 1 and pop_req_n == 0 cannot happen at the same time.

// Naming Convensions
// ------------------
// Same I/O as DW_fifo_s1_sf.
// f_*: flip-flop
// n_*: D input to flop
// m_*: wire
// *_n: active low signal
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl_hiu_dcore( clk,          
                            rst_n,        
                            push_req_n,   
                            pop_req_n,    
                            diag_n,       
                            data_in,      
                            empty,        
                            almost_empty, 
                            half_full,    
                            almost_full,  
                            full,         
                            err_or,        
                            data_out,
                            i_two_to_one );   
                                          
   //-------------------------------------------------------------------------
   // Parameters
   //-------------------------------------------------------------------------
                                          
   parameter WIDTH = 8; // FIFO width
   parameter DEPTH = 4; // FIFO depth

   //-------------------------------------------------------------------------
   // Local Parameters
   //-------------------------------------------------------------------------

   parameter AE_LEVEL = 1;            // Almost empty level: fixed 
   parameter AF_LEVEL = 1;            // Almost full  level: fixed 
   parameter ERR_MODE = 0;            // Error mode:         fixed 
   parameter RST_MODE = 0;            // Reset mode:         fixed 

   parameter SF_DEPTH = DEPTH - 2;    // Sub FIFO depth            

   //-------------------------------------------------------------------------
   // I/O
   //-------------------------------------------------------------------------
   
   input              clk;            // Input clock                     
   input              rst_n;          // Reset input (async), active low 
   input              push_req_n;     // FIFO push request,   active low 
   input              pop_req_n;      // FIFO pop  request,   active low 
   input              diag_n;         // Diagnostic control,  active low 
   input  [WIDTH-1:0] data_in;        // FIFO data to push               
   output             empty;          // FIFO empty,          active high
   output             almost_empty;   // FIFO almost empty,   active high
   output             half_full;      // FIFO half full,      active high
   output             almost_full;    // FIFO almost full,    active high
   output             full;           // FIFO full,           active high
   output             err_or;         // FIFO error output,   active high
   output [WIDTH-1:0] data_out;       // FIFO data to pop
   input              i_two_to_one;   // 2:1 mode

   //-------------------------------------------------------------------------
   // Registers
   //-------------------------------------------------------------------------
   
   reg                f_buf_has_data; // f_buf_data has valid data to push
   wire               n_buf_has_data; // (next)
   reg  [WIDTH-1:0]   f_buf_data;     // input buffer
   reg                f_empty;        // FIFO empty
   wire               n_empty;        // (next)
   reg  [WIDTH-1:0]   f_data_out;     // output buffer
   wire [WIDTH-1:0]   n_data_out;     // (next)

   //-------------------------------------------------------------------------
   // Wires
   //-------------------------------------------------------------------------
   
   wire               m_buf_push_n;   // write enable of f_buf_data
   wire               m_sel_data_in;  // select data_in
   wire               m_sel_buf;      // select buffer
   wire               m_sel_sf;       // select sub FIFO
   wire               m_we;           // output buffer write enable
   wire               m_idle;         // output buffer is idle

   wire               m_sf_push_n;    // sub FIFO push
   wire               m_sf_pop_n;     // sub FIFO pop
   wire               m_sf_empty;     // sub FIFO empty
   wire               m_sf_aempty;    // sub FIFO almost empty
   wire               m_sf_hfull;     // sub FIFO half full
   wire               m_sf_afull;     // sub FIFO almost full
   wire               m_sf_full;      // sub FIFO full
   wire [WIDTH-1:0]   m_sf_data_out;  // sub FIFO output

   wire               m_buf_sf_empty; // both output buf & sub FIFO are empty

   //-------------------------------------------------------------------------
   // Sub-FIFO
   //-------------------------------------------------------------------------
   
   DW_memctl_fifo
    #( WIDTH, 
                    SF_DEPTH,
                    AE_LEVEL,
                    AF_LEVEL,
                    ERR_MODE,
                    RST_MODE ) // sub FIFO
   U_sub_fifo( .clk         ( clk           ),
               .rst_n       ( rst_n         ),
               .push_req_n  ( m_sf_push_n   ),
               .pop_req_n   ( m_sf_pop_n    ),
               .diag_n      ( diag_n        ),
               .data_in     ( f_buf_data    ),
               .empty       ( m_sf_empty    ),
               .almost_empty( m_sf_aempty   ),
               .half_full   ( m_sf_hfull    ),
               .almost_full ( m_sf_afull    ),
               .full        ( m_sf_full     ),
               .error       ( err_or        ),
               .data_out    ( m_sf_data_out ) );

   // Push Data to Input Buffer
   // -------------------------
   // Push data to the input buffer, unless 
   // - the data directly goes to the output buffer.

   assign m_buf_push_n = ! (! push_req_n && ! m_sel_data_in);

   always @ (posedge clk or negedge rst_n)
     if (rst_n == 1'b0)       f_buf_data <= { WIDTH { 1'b0 } };
     else if (! m_buf_push_n) f_buf_data <= data_in;

   // Valid Input Buffer Flag
   // -----------------------
   // Input buffer is valid, if
   // - data is pushed to the buffer, or
   // - the buffer has data but the sub FIFO is full and no pop.

   assign n_buf_has_data = ! m_buf_push_n ||
                           f_buf_has_data && m_sf_full && pop_req_n;

   always @ (posedge clk or negedge rst_n)
     if (rst_n == 1'b0) f_buf_has_data <= 1'b0;
     else                 f_buf_has_data <= n_buf_has_data;
   
   // Push Sub FIFO
   // -------------
   // Push buffered data to the sub FIFO, unless
   // - the sub FIFO is empty and    pop occurs, or
   // - the sub FIFO is full  and no pop occurs.
   
   // [condition coverage]
   // pop_req_n and ! pop_req_n are mutually exclusive.

   assign m_sf_push_n = ! (f_buf_has_data && 
                            ! (m_sf_empty && ! pop_req_n ||
                                m_sf_full  &&   pop_req_n));

   // Pop Sub FIFO
   // ------------
   // Pop sub FIFO, if 
   // - the sub FIFO has data and pop occurs.

   assign m_sf_pop_n = ! (! m_sf_empty && ! pop_req_n);


   // Select data_in
   // --------------
   // Select data_in, if 
   // - the whole FIFO is empty, or
   // - the input buffer and the sub FIFO are empty and pop occurs.

   assign m_sel_data_in = f_empty || m_buf_sf_empty && ! pop_req_n;

   // Select m_sf_data_out
   // --------------------
   // Select sub FIFO, if
   // - the sub FIFO is not empty
   
   assign m_sel_sf = ! m_sf_empty;

   // Output Data MUX
   // ---------------
   // The priority is (based on timing)
   // 1. data_in
   // 2. m_sf_data_out
   // 3. f_buf_data
   
   assign n_data_out = m_sel_data_in ? data_in       : 
                       m_sel_sf      ? m_sf_data_out : f_buf_data;

   assign m_we = f_empty && ! push_req_n || ! pop_req_n;
   assign m_idle = f_empty && push_req_n;

   always @ (posedge clk or negedge rst_n)
     if (rst_n == 1'b0) f_data_out <= { WIDTH { 1'b0 } };
     else if (m_we)     f_data_out <= n_data_out;
     else if (m_idle && `DYNAMIC_RAM_TYPE == 1) begin // DDR
        if (i_two_to_one) 
          f_data_out[WIDTH-1:2] <= 
                     { 4 { f_data_out[WIDTH-1:WIDTH -`H_DATA_WIDTH/4] } };
        else
          f_data_out[WIDTH-1:2] <= 
                     { 2 { f_data_out[WIDTH-1:WIDTH -`H_DATA_WIDTH/2] } };
     end

   assign data_out = f_data_out;

   // Set Empty at the Next Cycle
   // ---------------------------
   // The whole FIFO becomes empty, if
   // - empty and no push occurred, or
   // - the buffer and the sub FIFO are empty and pop occurred without push.
   
   assign m_buf_sf_empty = ! f_buf_has_data && m_sf_empty;
   
   assign n_empty = push_req_n && (f_empty ||
                                    m_buf_sf_empty && ! pop_req_n);

   always @ (posedge clk or negedge rst_n)
     if (rst_n == 1'b0) f_empty <= 1'b1;
     else                 f_empty <= n_empty;

   // Flags
   // -----
   // Only supports AE_LEVEL = AF_LEVEL = 1.
   
   assign empty        = f_empty;
   assign almost_empty = m_buf_sf_empty; // 0 or 1 data
   assign half_full    = m_sf_hfull;

   // [condition coverage]
   // f_buf_has_data and ! f_buf_has_data are mutually exclusive.
   
   assign almost_full  = ! f_buf_has_data && m_sf_full ||
                           f_buf_has_data && m_sf_afull;
   assign full         =   f_buf_has_data && m_sf_full;
   
endmodule // DW_memctl_hiu_dcore
