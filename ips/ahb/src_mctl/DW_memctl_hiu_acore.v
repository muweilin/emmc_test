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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_hiu_acore.v $ 
// $Revision: #3 $
//
// Abstract  : This module is the FIFO core of the Address FIFO.  It is a 
// wrapper of the DW_fifo_s1_sf.  The function is similar to the DW_fifo_s1_sf
// except dual push capability.  The core improves the input data and push timing.
//
//============================================================================

// [condition coverage]
// 1. m_OBUF_EMPTY == 1 & pop_req_n == 0 cannot be covered.
//    To achieve this condition, the following sequences are necessary which 
//    is unable to happen.
//    1. the FIFO is empty
//    2. push address
//    3. pop address at the next cycle, which means hiu_req and miu_burst_done
//       happens at the same time.
// 2. m_OBUF_EMPTY == 1 and m_sf_empty == 0 cannot happen at the same time.
// 3. ADDR_FIFO_DEPTH must be deeper than 4 to cover m_sf_afull = 0 and 
//    m_sf_pop_n == 0.  Otherwise the FIFO core is always almost full (full-2)
//    if it has data.
// 4. m_sf_full == 1, m_sf_push_n ==0, and m_sf_pop_n == 1 cannot happen
//    because of FIFO overflow.

// Naming Convensions
// ------------------
// Same I/O as DW_fifo_s1_sf except push_req[12]_n and data[12]_n.
// f_*: flip-flop
// n_*: D input to flop
// m_*: wire
// *_n: active low signal
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl_hiu_acore( clk,          
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
                            data_out );   

   //-------------------------------------------------------------------------
   // Parameters
   //-------------------------------------------------------------------------

   parameter WIDTH = 8; // FIFO width
   parameter DEPTH = 4; // FIFO depth

   //-------------------------------------------------------------------------
   // Local Parameters
   //-------------------------------------------------------------------------

   parameter AE_LEVEL = 1;           // Almost empty level: fixed
   parameter AF_LEVEL = 1;           // Almost full  level: fixed
   parameter ERR_MODE = 0;           // Error mode:         fixed
   parameter RST_MODE = 0;           // Reset mode:         fixed
   
   parameter SF_DEPTH = DEPTH - 1;   // Sub FIFO depth
   parameter SF_AF_LEVEL = 2;        // Sub FIFO almost full level

   //-------------------------------------------------------------------------
   // I/O
   //-------------------------------------------------------------------------
   
   input              clk;           // Input clock                     
   input              rst_n;         // Reset input (async), active low 
   input              push_req_n;    // FIFO push request,   active low 
   input              pop_req_n;     // FIFO pop  request,   active low 
   input              diag_n;        // Diagnostic control,  active low 
   input [WIDTH-1:0]  data_in;       // FIFO data to push             
   output             empty;         // FIFO empty,          active high
   output             almost_empty;  // FIFO almost empty,   active high
   output             half_full;     // FIFO half full,      active high
   output             almost_full;   // FIFO almost full,    active high
   output             full;          // FIFO full,           active high
   output             err_or;        // FIFO error output,   active high
   output [WIDTH-1:0] data_out;      // FIFO data to pop                

   //-------------------------------------------------------------------------
   // Registers
   //-------------------------------------------------------------------------

   reg                f_push_req_n;  // one cycle delay copy of push_req_n
   reg                f_obuf_empty;  // output buffer empty flag
   wire               n_obuf_empty;  // (next)
   reg  [WIDTH-1:0]   f_ibuf;        // input buffer
   reg  [WIDTH-1:0]   f_obuf;        // output buffer
   wire [WIDTH-1:0]   n_obuf;        // (next)
   reg                f_afull;       // sub FIFO almost full (full-1)
   wire               n_afull;       // (next)

   //-------------------------------------------------------------------------
   // Wires
   //-------------------------------------------------------------------------

   wire               m_sf_push_n;   // sub FIFO push
   wire               m_sf_pop_n;    // sub FIFO pop
   wire               m_sf_empty;    // sub FIFO empty
   wire               m_sf_aempty;   // sub FIFO almost empty
   wire               m_sf_hfull;    // sub FIFO half full
   wire               m_sf_afull;    // sub FIFO almost full (full-2)
   wire               m_sf_full;     // sub FIFO full
   wire [WIDTH-1:0]   m_sf_data_out; // sub FIFO output

   wire               m_obuf_push_n; // output buffer push request, active low

   //-------------------------------------------------------------------------
   // Sub-FIFO
   //-------------------------------------------------------------------------
   
   DW_memctl_fifo
    #( WIDTH, 
                    SF_DEPTH,
                    AE_LEVEL,
                    SF_AF_LEVEL,
                    ERR_MODE,
                    RST_MODE ) // sub FIFO
   U_sub_fifo( .clk         ( clk           ),
               .rst_n       ( rst_n         ),
               .push_req_n  ( m_sf_push_n   ),
               .pop_req_n   ( m_sf_pop_n    ),
               .diag_n      ( diag_n        ),
               .data_in     ( f_ibuf        ),
               .empty       ( m_sf_empty    ),
               .almost_empty( m_sf_aempty   ),
               .half_full   ( m_sf_hfull    ),
               .almost_full ( m_sf_afull    ),
               .full        ( m_sf_full     ),
               .error       ( err_or        ),
               .data_out    ( m_sf_data_out ) );

   // Push Data to Input Buffer
   // -------------------------
   // Always push data to the input buffer.

   always @ (posedge clk or negedge rst_n)
     if (rst_n == 1'b0) f_ibuf <= { WIDTH { 1'b0 } };
     else                 f_ibuf <= data_in;
   
   // Push Request
   // ------------
   // Register push request.

   always @ (posedge clk or negedge rst_n)
     if (rst_n == 1'b0) f_push_req_n <= 1'b1;
     else                 f_push_req_n <= push_req_n;

   // Push Sub FIFO
   // -------------
   // Push data from input buffer to the sub FIFO, if
   // - push, and
   // - the sub FIFO is not empty, or
   // - the output buffer has data and the sub FIFO is empty,
   //   but no pop occurs.
   
   assign m_sf_push_n = ! (! f_push_req_n && 
                            (! m_sf_empty || ! f_obuf_empty && pop_req_n));

   // Pop Sub FIFO
   // ------------
   // Pop sub FIFO, if 
   // - the sub FIFO has data and pop occurs.

   assign m_sf_pop_n = ! (! m_sf_empty && ! pop_req_n);

   // Push Data to Output Buffer
   // --------------------------
   // Push data to the output buffer, if
   // - the sub FIFO has data and pop occurs, or
   // - the sub FIFO is empty and push occurs, AND
   // - the output buffer is empty and no pop, or
   // - the output buffer has data and pop occurs.

   // [condition coverage]
   // m_sf_empty   and ! m_sf_empty   are mutually exclusive.
   // f_obuf_empty and ! f_obuf_empty are mutually exclusive.
   
   assign m_obuf_push_n = ! (! m_sf_empty && ! pop_req_n ||
                                m_sf_empty && ! f_push_req_n && 
                              (f_obuf_empty &&   pop_req_n || 
                                ! f_obuf_empty && ! pop_req_n));

   assign n_obuf = m_sf_empty ? f_ibuf : m_sf_data_out;

   always @ (posedge clk or negedge rst_n)
     if (rst_n == 1'b0)        f_obuf <= { WIDTH { 1'b0 } };
     else if (! m_obuf_push_n) f_obuf <= n_obuf;
       
   // Output Buffer Empty
   // -------------------
   // The output buffer is empty, if
   // - the buffer is empty and no push, or
   // - the buffer has data but pop occurred without feeding data.
   
   // [condition coverage]
   // f_obuf_empty and ! f_obuf_empty are mutually exclusive.

   assign n_obuf_empty = 
            f_obuf_empty && m_obuf_push_n ||
          ! f_obuf_empty && m_sf_empty && f_push_req_n && ! pop_req_n;

   always @ (posedge clk or negedge rst_n)
     if (rst_n == 1'b0) f_obuf_empty <= 1'b1;
     else                 f_obuf_empty <= n_obuf_empty;
   
   assign data_out = f_obuf_empty ? f_ibuf : f_obuf;

   // Flags
   // -----
   // Only support AE_LEVEL=AF_LEVEL=1.
   // almost_empty must be f_obuf_empty or no push, otherwise
   // more than 1 data is in the FIFO.
   
   // [condition coverage]
   // m_sf_push_n and ! m_sf_push_n are mutually exclusive.
   
   assign n_afull = m_sf_afull && ! m_sf_push_n && m_sf_pop_n ||
                    f_afull    && ! m_sf_push_n               ||
                    f_afull    &&   m_sf_push_n && m_sf_pop_n ||
                    m_sf_full;

   always @ (posedge clk or negedge rst_n)
     if (rst_n == 1'b0) f_afull <= 1'b0;
     else                 f_afull <= n_afull;

   assign empty        = m_sf_empty &&   f_obuf_empty && f_push_req_n;
   assign almost_empty = m_sf_empty && (f_obuf_empty || f_push_req_n);
   assign half_full    = m_sf_hfull;
   assign almost_full  = f_afull   || m_sf_afull && ! f_push_req_n;
   assign full         = m_sf_full || f_afull    && ! f_push_req_n;
endmodule // DW_memctl_hiu_acore
