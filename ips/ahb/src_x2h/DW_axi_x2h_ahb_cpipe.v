// ---------------------------------------------------------------------
//
//  ------------------------------------------------------------------------
//
//                    (C) COPYRIGHT 2005 - 2014 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
//  This software and the associated documentation are confidential and
//  proprietary to Synopsys, Inc.  Your use or disclosure of this
//  software is subject to the terms and conditions of a written
//  license agreement between you, or your company, and Synopsys, Inc.
//
// The entire notice above must be reproduced on all authorized copies.
//
//  ------------------------------------------------------------------------

// 
// Release version :  2.01a
// File Version     :        $Revision: #5 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_ahb_cpipe.v#5 $ 
//
// -------------------------------------------------------------------------
// Filename    : DW_axi_x2h_ahb_cpipe.v
//
// Description : Pipeline stage between AHB CGEN and AHB IF. This puts
//               a register between the AHB HREADY signal and the POP signals
//               of the CMD Queue and WDFIFO.
//
//               This module looks at X2H_AHB_BUFFER_POP_MODE.
//               The pipelining is only put in optionally according to this.
//
//-----------------------------------------------------------------------------
`include "DW_axi_x2h_cc_constants.v"
module DW_axi_x2h_ahb_cpipe (

// Inputs

                             clk,
                             rst_n,
                             cgen_cpipe_valid,
                             cgen_cpipe_ahb_haddr, 
                             cgen_cpipe_ahb_hwrite,
                             cgen_cpipe_ahb_hsize, 
                             cgen_cpipe_ahb_hburst,
                             cgen_cpipe_ahb_hprot, 
                             cgen_cpipe_ahb_hwdata,
                             cgen_cpipe_nonseq_addr,
                             cgen_cpipe_axi_last,
                             cgen_cpipe_rdfifo_req,
                             cgen_cpipe_axi_id, 
                             cgen_cpipe_axi_size,
                             if_cpipe_ready, 
                             if_cpipe_xfr_pending,
                             // Outputs
                             cpipe_cgen_ready, 
                             cpipe_cgen_xfr_pending,
                             cpipe_if_valid,
                             cpipe_if_ahb_haddr, 
                             cpipe_if_ahb_hwrite,
                             cpipe_if_ahb_hsize, 
                             cpipe_if_ahb_hburst,
                             cpipe_if_ahb_hprot, 
                             cpipe_if_ahb_hwdata,
                             cpipe_if_nonseq_addr,
                             cpipe_if_axi_last,
                             cpipe_if_rdfifo_req,
                             cpipe_if_axi_id, 
                             cpipe_if_axi_size
                             );


   input                              clk;
   input                              rst_n;

   // Interface to CGEN

   input                              cgen_cpipe_valid;

   output                             cpipe_cgen_ready;
   output                             cpipe_cgen_xfr_pending;

   input    [`X2H_CMD_ADDR_WIDTH-1:0] cgen_cpipe_ahb_haddr;
   input                              cgen_cpipe_ahb_hwrite;
   input                        [2:0] cgen_cpipe_ahb_hsize;
   input                        [2:0] cgen_cpipe_ahb_hburst;
   input                        [3:0] cgen_cpipe_ahb_hprot;
   input    [`X2H_AHB_DATA_WIDTH-1:0] cgen_cpipe_ahb_hwdata;

   input                              cgen_cpipe_nonseq_addr;
   input                              cgen_cpipe_axi_last;  
   input                        [4:0] cgen_cpipe_rdfifo_req;

   input      [`X2H_AXI_ID_WIDTH-1:0] cgen_cpipe_axi_id;
   input                        [2:0] cgen_cpipe_axi_size;


   // Interface to IF

   output                             cpipe_if_valid;
 
   input                              if_cpipe_ready;
   input                              if_cpipe_xfr_pending;

   output   [`X2H_CMD_ADDR_WIDTH-1:0] cpipe_if_ahb_haddr;
   output                             cpipe_if_ahb_hwrite;
   output                       [2:0] cpipe_if_ahb_hsize;
   output                       [2:0] cpipe_if_ahb_hburst;
   output                       [3:0] cpipe_if_ahb_hprot;
   output   [`X2H_AHB_DATA_WIDTH-1:0] cpipe_if_ahb_hwdata;

   output                             cpipe_if_nonseq_addr;
   output                             cpipe_if_axi_last;
   output                       [4:0] cpipe_if_rdfifo_req;

   output     [`X2H_AXI_ID_WIDTH-1:0] cpipe_if_axi_id;
   output                       [2:0] cpipe_if_axi_size;



   // THESE ARE FLIP-FLOPS:

   reg                             if_cpipe_ready_q;
   reg                             saved_valid;

   reg   [`X2H_CMD_ADDR_WIDTH-1:0] saved_ahb_haddr;
   reg                             saved_ahb_hwrite;
   reg                       [2:0] saved_ahb_hsize;
   reg                       [2:0] saved_ahb_hburst;
   reg                       [3:0] saved_ahb_hprot;
   reg   [`X2H_AHB_DATA_WIDTH-1:0] saved_ahb_hwdata;

   reg                             saved_nonseq_addr;
   reg                             saved_axi_last;
   reg     [`X2H_AXI_ID_WIDTH-1:0] saved_axi_id;
   reg                       [4:0] saved_rdfifo_req;

   reg                       [2:0] saved_axi_size;

   reg                             use_saved; //This is not a Flipflop.



   // These are NOT FLIP-FLOPS:

   reg                             cpipe_cgen_ready;
   reg                             cpipe_if_valid;
 
   reg   [`X2H_CMD_ADDR_WIDTH-1:0] cpipe_if_ahb_haddr;
   reg                             cpipe_if_ahb_hwrite;
   reg                       [2:0] cpipe_if_ahb_hsize;
   reg                       [2:0] cpipe_if_ahb_hburst;
   reg                       [3:0] cpipe_if_ahb_hprot;
   reg   [`X2H_AHB_DATA_WIDTH-1:0] cpipe_if_ahb_hwdata;

   reg                             cpipe_if_nonseq_addr;
   reg                             cpipe_if_axi_last;
   reg                       [4:0] cpipe_if_rdfifo_req;

   reg     [`X2H_AXI_ID_WIDTH-1:0] cpipe_if_axi_id;
   reg                       [2:0] cpipe_if_axi_size;

   reg                             cpipe_cgen_xfr_pending;



   //use of blocking assignments prevent assignment before read issue
   always @(*)
     
     begin:CPIPE_IF_PROC

       // In a normal version of this type of cirecuit, the "ready"
       // going back would look like this:
       //
       // cpipe_cgen_ready    =   cgen_cpipe_valid & ~saved_valid
       //                       | if_cpipe_ready_q & cgen_cpipe_valid;
       //
       // In other words, if the CGEN is showing VALID but the
       // saved_valid is not yet true, send an early response to
       // advance the CGEN, and subsequently send the ready signals
       // from IF, DELAYED BY ONE CLOCK, but only if the CGEN is
       // still showing valid.
       //
       // In this particular application, it doesn't hurt to assert
       // READY back to the CGEN if its VALID is not asserted, so this
       // term can be left out.

       cpipe_cgen_ready    =   ~saved_valid | if_cpipe_ready_q;

       // If there's something valid in the "saved" registers, use
       // that (aka, send that to the IF). BUT, if IF_CPIPE_READY
       // was asserted in the last clock, it means the IF took what
       // was in saved and we now need to show it the new command
       // from CGEN.

       use_saved           = saved_valid & (~if_cpipe_ready_q);

       if (use_saved)
         begin
           cpipe_if_valid        = saved_valid;
           cpipe_if_ahb_haddr    = saved_ahb_haddr;
           cpipe_if_ahb_hwrite   = saved_ahb_hwrite;
           cpipe_if_ahb_hsize    = saved_ahb_hsize;
           cpipe_if_ahb_hburst   = saved_ahb_hburst;
           cpipe_if_ahb_hprot    = saved_ahb_hprot;
           cpipe_if_ahb_hwdata   = saved_ahb_hwdata;
           cpipe_if_nonseq_addr  = saved_nonseq_addr;
           cpipe_if_axi_last     = saved_axi_last;
           cpipe_if_rdfifo_req   = saved_rdfifo_req;
           cpipe_if_axi_id       = saved_axi_id;
           cpipe_if_axi_size     = saved_axi_size;
         end
       else
         begin
           cpipe_if_valid        = cgen_cpipe_valid;
           cpipe_if_ahb_haddr    = cgen_cpipe_ahb_haddr;
           cpipe_if_ahb_hwrite   = cgen_cpipe_ahb_hwrite;
           cpipe_if_ahb_hsize    = cgen_cpipe_ahb_hsize;
           cpipe_if_ahb_hburst   = cgen_cpipe_ahb_hburst;
           cpipe_if_ahb_hprot    = cgen_cpipe_ahb_hprot;
           cpipe_if_ahb_hwdata   = cgen_cpipe_ahb_hwdata;
           cpipe_if_nonseq_addr  = cgen_cpipe_nonseq_addr;
           cpipe_if_axi_last     = cgen_cpipe_axi_last;
           cpipe_if_rdfifo_req   = cgen_cpipe_rdfifo_req;
           cpipe_if_axi_id       = cgen_cpipe_axi_id;
           cpipe_if_axi_size     = cgen_cpipe_axi_size;
         end

       // The "xfr_pending" signal is fed back from IF to CGEN to
       // allow the CGEN to make sure all outstanding transfers are
       // done before sending the write response to AXI.
       // Don't forget about something in the "saved" registers!

       cpipe_cgen_xfr_pending  = if_cpipe_xfr_pending
                                 | use_saved;
     end  // always block

   always @(posedge clk or negedge rst_n)
   begin: SAVED_AHB_PROC
     if ( !rst_n )
       begin
         if_cpipe_ready_q     <= 1'b0;
         saved_valid          <= 1'b0;
         saved_ahb_haddr      <= {`X2H_CMD_ADDR_WIDTH{1'b0}};
         saved_ahb_hwrite     <= 1'b0;
         saved_ahb_hsize      <= 3'b000;
         saved_ahb_hburst     <= 3'b000;
         saved_ahb_hprot      <= 4'b0000;
         saved_ahb_hwdata     <= {`X2H_AHB_DATA_WIDTH{1'b0}};
         saved_nonseq_addr    <= 1'b0;
         saved_axi_last       <= 1'b0;
         saved_rdfifo_req     <= 5'b00000;
         saved_axi_id         <= {`X2H_AXI_ID_WIDTH{1'b0}};
         saved_axi_size       <= 3'b0;
       end
     else
       begin

         // Never going to load anything into these FFs if not in
         // "pipeline" mode... this should make them disappear
         // after synthesis

         // the READY from IF loads into this FF every clock
         if_cpipe_ready_q     <= if_cpipe_ready;

         // If "use_saved", hold the current value, otherwise
         // load from the CGEN inputs
         if (~use_saved)
           begin
             saved_valid          <= cgen_cpipe_valid;
             saved_ahb_haddr      <= cgen_cpipe_ahb_haddr;
             saved_ahb_hwrite     <= cgen_cpipe_ahb_hwrite;
             saved_ahb_hsize      <= cgen_cpipe_ahb_hsize;
             saved_ahb_hburst     <= cgen_cpipe_ahb_hburst;
             saved_ahb_hprot      <= cgen_cpipe_ahb_hprot;
             saved_ahb_hwdata     <= cgen_cpipe_ahb_hwdata;
             saved_nonseq_addr    <= cgen_cpipe_nonseq_addr;
             saved_axi_last       <= cgen_cpipe_axi_last;
             saved_rdfifo_req     <= cgen_cpipe_rdfifo_req;
             saved_axi_id         <= cgen_cpipe_axi_id;
             saved_axi_size       <= cgen_cpipe_axi_size;
           end
       end // end else
   end //end always block

endmodule


