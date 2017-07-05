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
// File Version     :        $Revision: #6 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_ahb_cgen.v#6 $ 
//
// -------------------------------------------------------------------------
// Filename    : DW_axi_x2h_ahb_cgen.v
// 
// Description : AHB Command generator. This "CGEN" module pulls AXI commands
//               from the Common CMD Queue and turns them into one or more
//               AHB commands, which are then passed to the "IF"
//               (DW_axi_x2h_ahb_if) module.
//
//               This CGEN module also pulls and processes data from the
//               WDFIFO. Skipping over sparse write data happens here.
//
//               DOWNSIZING happens here.
//
//               Write responses are sent from this CGEN module.
//-----------------------------------------------------------------------------
`include "DW_axi_x2h_cc_constants.v"
//`include ""
module DW_axi_x2h_ahb_cgen (


// Inputs

   clk, 
                            rst_n,
                            cmdq_addr, 
                            cmdq_id, 
                            cmdq_axi_size, 
                            cmdq_cache, 
                            cmdq_prot_2, 
                            cmdq_prot_0, 
                            cmdq_rw,
                            cmdq_try_size, 
                            cmdq_try_mask, 
                            cmdq_wrapmask, 
                            cmdq_axibytes, 
                            cmdq_axibytes_2b,
                            cmdq_2b_first, 
                            cmdq_frepcount, 
                            cmdq_valid,
                            wdfifo_wdata, 
                            wdfifo_wstrb, 
                            wdfifo_wlast,
                            wdfifo_valid,
                            hresp_rdy_int_n,
                            cpipe_cgen_ready, 
                            cpipe_cgen_xfr_pending,
                            if_cgen_wr_err, 
                            // Outputs
                            pop_cmdq, 
                            pop_wdfifo,
                            hwid_int, 
                            hwstatus_int, 
                            push_resp_int_n,
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
                            cgen_cpipe_axi_size
                            );


   input                              clk;
   input                              rst_n;

// Interface to Common CMD Queue (via the FPIPE)

   input    [`X2H_CMD_ADDR_WIDTH-1:0] cmdq_addr;
   input      [`X2H_AXI_ID_WIDTH-1:0] cmdq_id;
   input                        [2:0] cmdq_axi_size;
   input                        [1:0] cmdq_cache;
   input                              cmdq_prot_2;
   input                              cmdq_prot_0;
   input                              cmdq_rw;
 
   input                        [2:0] cmdq_try_size;       // Proposed size to
                                                           // read on AHB

   input                        [4:0] cmdq_try_mask;       // Mask to check address
                                                           // OK for size proposed

                                                           // factor

   input                       [11:0] cmdq_wrapmask;       // Mask used for wrapping
                                                           // and spotting wrap/1K
                                                           // boundaries.

   input                       [13:0] cmdq_axibytes;       // Byte count for AXI
                                                           // command

   input                       [13:0] cmdq_axibytes_2b;    // Byte count to wrap
                                                           // or 1K boundary

   input                              cmdq_2b_first;       // This command WILL
                                                           // hit a wrap or 1K
                                                           // boundary

   input           [`X2H_AXI_BLW-1:0] cmdq_frepcount;      // Repeat count for AXI

                                                           // FIXED command

   input                              cmdq_valid;
   output                             pop_cmdq;


// Interface to Write Data FIFO (via the FPIPE)

   input    [`X2H_AXI_DATA_WIDTH-1:0] wdfifo_wdata;
   input   [`X2H_AXI_WSTRB_WIDTH-1:0] wdfifo_wstrb;
   input                              wdfifo_wlast;

   input                              wdfifo_valid;
   output                             pop_wdfifo;


// Interface to Write Response FIFO

   input                              hresp_rdy_int_n;     // Low means: OK to push
   
   output     [`X2H_AXI_ID_WIDTH-1:0] hwid_int;
   output                       [1:0] hwstatus_int;

   output                             push_resp_int_n;     // Low-true PUSH


// CGEN-IF interface (mostly via CPIPE)

   output                             cgen_cpipe_valid;    // Tells IF that a valid
                                                           // AHB command is on the
                                                           // CGEN-IF interface

   input                              cpipe_cgen_ready;    // Indicates IF is accepting
                                                           // the current valid command.

   input                              cpipe_cgen_xfr_pending;
   input                              if_cgen_wr_err;
   
   output   [`X2H_CMD_ADDR_WIDTH-1:0] cgen_cpipe_ahb_haddr;
   output                             cgen_cpipe_ahb_hwrite;
   output                       [2:0] cgen_cpipe_ahb_hsize;
   output                       [2:0] cgen_cpipe_ahb_hburst;
   output                       [3:0] cgen_cpipe_ahb_hprot;
   output   [`X2H_AHB_DATA_WIDTH-1:0] cgen_cpipe_ahb_hwdata;

   output                             cgen_cpipe_nonseq_addr;
   output                             cgen_cpipe_axi_last;
   output                       [4:0] cgen_cpipe_rdfifo_req;

   output     [`X2H_AXI_ID_WIDTH-1:0] cgen_cpipe_axi_id;
   output                       [2:0] cgen_cpipe_axi_size;


   
   


   // FLIP-FLOPS:

   reg                               use_remainder;
   reg                               fixed_reload;

   reg                        [11:0] remainder_addr;
   reg                               wstrb_0_skipped;

   reg                        [13:0] remainder_axibytes;
   reg                        [13:0] remainder_axibytes_2b;
   reg                               remainder_2b_first;
   reg            [`X2H_AXI_BLW-1:0] remainder_frepcount;

   reg                               wresp_pending;
   reg                               got_write_err;

   // Not FFs... "next value" signals for FFs

   reg                               nxt_use_remainder;
   reg                               nxt_fixed_reload;

   reg                        [11:0] nxt_remainder_addr;
   reg                               set_wstrb_0_skipped;

   reg                        [13:0] nxt_remainder_axibytes;
   reg                        [13:0] nxt_remainder_axibytes_2b;
   reg                               nxt_remainder_2b_first;
   reg            [`X2H_AXI_BLW-1:0] nxt_remainder_frepcount;



   // Not FFs... module outputs implemented as "regs"
   
   reg                               cgen_cpipe_valid;
   reg     [`X2H_CMD_ADDR_WIDTH-1:0] cgen_cpipe_ahb_haddr;
   reg                               cgen_cpipe_ahb_hwrite;
   reg                         [2:0] cgen_cpipe_ahb_hsize;
   reg                         [2:0] cgen_cpipe_ahb_hburst;
   reg                         [3:0] cgen_cpipe_ahb_hprot;
   reg     [`X2H_AHB_DATA_WIDTH-1:0] cgen_cpipe_ahb_hwdata;

   reg                               cgen_cpipe_nonseq_addr;
   reg                               cgen_cpipe_axi_last;
   reg                         [4:0] cgen_cpipe_rdfifo_req;

   reg       [`X2H_AXI_ID_WIDTH-1:0] cgen_cpipe_axi_id;
   reg                         [2:0] cgen_cpipe_axi_size;



   // Not FFs... intramodule signals implemented as "regs"

   reg                               hold_local;
   reg                               time_to_pop_rd_cmd;
   reg                               time_to_pop_wdfifo;
   reg                               set_wlast_err;
   
   reg     [`X2H_CMD_ADDR_WIDTH-1:0] to_process_addr;
   reg                        [13:0] to_process_axibytes;
   reg                        [13:0] to_process_axibytes_2b;
   reg                               to_process_2b_first;
   reg            [`X2H_AXI_BLW-1:0] to_process_frepcount;

   reg                         [2:0] ahb_size;
   reg                         [4:1] ahb_bcount;
   reg                         [9:0] ahb_xbytes;
// leda NTL_CON13A off
// LMD: Non-driving internal net range
// LJ : All bits of the following signal are driving, this error seems to be a leda bug
   reg                         [5:0] xbytes_to_bump_axi;
// leda NTL_CON13A on

   reg                         [11:0] addr_plus_1;
   reg                         [11:0] addr_plus_2;
   reg                         [11:0] addr_plus_4;
   reg                         [11:0] addr_plus_8;
   reg                         [11:0] addr_plus_16;
   reg                         [11:0] addr_plus_32;
   reg                         [11:0] addr_plus_64;
   reg                         [11:0] addr_plus_128;
   reg                         [11:0] addr_plus_256;
   reg                         [11:0] addr_plus_512;

   reg                         [11:0] incremented_addr;


   wire                              hold_if;

   wire      [`X2H_AXI_ID_WIDTH-1:0] to_process_id;
   wire                        [2:0] to_process_axi_size;
   wire                        [2:0] to_process_try_size;
   wire                        [4:0] to_process_try_mask;
   wire                       [11:0] to_process_wrapmask;
   wire                        [1:0] to_process_cache;
   wire                              to_process_prot_2;
   wire                              to_process_prot_0;
   wire                              to_process_rw;



   wire                              wstrb_1;
   wire                        [2:0] wr_ahb_size;
   wire                        [5:0] wr_ahb_xbytes;
 
   wire                        [2:0] rd_ahb_size;
   wire                        [4:1] rd_ahb_bcount;
   wire                        [9:0] rd_ahb_xbytes;



  /////////////////////////////////////////////////////
  // HOLD_IF
  //
  // If this CGEN module issues a valid command to the IF
  // pretty much everything must wait until the IF accepts it

  assign hold_if = cgen_cpipe_valid & (~cpipe_cgen_ready);


  ////////////////////////////////
  // "remainder" registers
  ////////////////////////////////

  always @(posedge clk or negedge rst_n)
    if ( !rst_n )
      begin
        use_remainder          <= 1'b0;
        fixed_reload           <= 1'b0;
        remainder_addr         <= 12'h000;
        wstrb_0_skipped        <= 1'b0;
        remainder_axibytes     <= 14'h0000;
        remainder_axibytes_2b  <= 14'h0000;
        remainder_2b_first     <= 1'b0;
        remainder_frepcount    <= {`X2H_AXI_BLW{1'b0}};

      end
    else
      begin
        if ((~hold_local) & (~hold_if))
          begin
            use_remainder          <= nxt_use_remainder;
            fixed_reload           <= nxt_fixed_reload;
            remainder_addr         <= nxt_remainder_addr;
            wstrb_0_skipped        <= set_wstrb_0_skipped;
            remainder_axibytes     <= nxt_remainder_axibytes;
            remainder_axibytes_2b  <= nxt_remainder_axibytes_2b;
            remainder_2b_first     <= nxt_remainder_2b_first;
            remainder_frepcount    <= nxt_remainder_frepcount;
          end
      end


  /////////////////////////////////////////////////////
  // POP the Common CMD Queue
  //
  // For reads, basically pop an AXI command out as the
  // last AHB command associated with it gets sent to
  // the IF. For a write, wait until the write response
  // gets set (to keep the ID around until then).
  //

  assign pop_cmdq  =   time_to_pop_rd_cmd & (~hold_local) & (~hold_if)
                       | (~push_resp_int_n);


  /////////////////////////////////////////////////////
  // POP the Write Data FIFO
  //
  // POP the WDFIFO as each line gets completely
  // sent to the IF ("time_to_pop_wdfifo" is aware of
  // when there's a downshift)
  // 

  assign pop_wdfifo = time_to_pop_wdfifo & (~hold_local) & (~hold_if);



  /////////////////////////////////////////////////////////////////
  // TO_PROCESS_xxx
  //
  // An AXI command may require more than one AHB command to
  // complete it, for example if there is downsizing, or if the
  // AXI command is a length that's not supported on AHB.
  //
  // This is handled by the "to_process_xxx" signals. When a new
  // AXI command comes in, the "to_process_xxx" signals reflect
  // it's address, length, etc. The CGEN then issue the best AHB
  // command it can. If that AHB command doesn't complete the AXI
  // transfer, then the CGEN goes into "use_remainder" mode and the
  // "to_process_xxx" signals get modified to reflect how much of
  // the original AXI command is still left (this basically means
  // "to_process_addr" tends to go up and "to_process_len" tends
  // to go down).
  //
  /////////////////////////////////////////////////////////////////

  // For a lot of signals, the value "to_process" comes straight
  // out of the CMD Queue (or the "FPIPE")

  assign to_process_id         = cmdq_id;
  assign to_process_axi_size   = cmdq_axi_size;
  assign to_process_try_size   = cmdq_try_size;
  assign to_process_try_mask   = cmdq_try_mask;
  assign to_process_wrapmask   = cmdq_wrapmask;
  assign to_process_cache      = cmdq_cache;
  assign to_process_prot_2     = cmdq_prot_2;
  assign to_process_prot_0     = cmdq_prot_0;
  assign to_process_rw         = cmdq_rw;
   

  always @( use_remainder or fixed_reload
            or cmdq_addr or remainder_addr
            or cmdq_axibytes or remainder_axibytes
            or cmdq_axibytes_2b or remainder_axibytes_2b
            or cmdq_2b_first or remainder_2b_first
            or cmdq_frepcount or remainder_frepcount)
            
    begin : mux_to_process_PROC

     // The "next up" address. High bits (12 and up) always from the CMD Queue.
     //
     // If in "use_remainder", the low 12 bits of to_process_addr come from
     // a remainder register (which reflects any AHB transfers already issued
     // against the current AXI command)... UNLESS "fixed_reload" is true, in
     // this case use all bits from the CMD Queue (to start another repetition
     // of a "FIXED" transfer)
   
     to_process_addr  = cmdq_addr;
     if (use_remainder & (~fixed_reload))
       to_process_addr[11:0]  = remainder_addr;

     // Counters of how many bytes to transfer, and how many bytes
     // to the next wrap or 1K boundary. Also an indicator that
     // a wrap or 1K boundary will be hit before the command gets
     // over. These DO reload for each repetition of a FIXED command

     if (use_remainder & (~fixed_reload))
       begin
         to_process_axibytes     = remainder_axibytes;
         to_process_axibytes_2b  = remainder_axibytes_2b;
         to_process_2b_first     = remainder_2b_first;
       end
     else
       begin
         to_process_axibytes     = cmdq_axibytes;
         to_process_axibytes_2b  = cmdq_axibytes_2b;
         to_process_2b_first     = cmdq_2b_first;
       end

     // The repeat count for an AXI FIXED command. Obviously
     // this canNOT reload for each repetition. It gets decremented
     // below (a long ways below)

     if (~use_remainder)
       to_process_frepcount  = cmdq_frepcount;
     else
       to_process_frepcount  = remainder_frepcount;

  end // Of mux_to_process_PROC

DW_axi_x2h_ahb_cgen_logic
 U_cgen_logic (

  // Description : This is a submodule of the "CGEN". The logic for figuring
  //               out what AHB transfer to do next is here. This is a purely
  //               combinatorial submodule.
  //
  //               The reason this got split off from the "CGEN" is to allow
  //               the logic in here to be "flattened" during synthesis.

  // Inputs:

    .to_process_addr(to_process_addr[8:0]),
                                        .to_process_axibytes(to_process_axibytes),
                                        .to_process_axibytes_2b(to_process_axibytes_2b),
                                        .to_process_2b_first(to_process_2b_first),
                                        .to_process_axi_size(to_process_axi_size),
                                        .to_process_try_size(to_process_try_size),
                                        .to_process_try_mask(to_process_try_mask),
                                        .wdfifo_wstrb(wdfifo_wstrb),
                                        // Outputs:
                                        .wstrb_1(wstrb_1),
                                        .wr_ahb_size(wr_ahb_size),
                                        .wr_ahb_xbytes(wr_ahb_xbytes),
                                        .rd_ahb_size(rd_ahb_size),
                                        .rd_ahb_bcount(rd_ahb_bcount),
                                        .rd_ahb_xbytes(rd_ahb_xbytes)
                                        );




  /////////////////////////////////////////////////////////////////
  // HERE COMES A BIG ASYNC BLOCK
  //
  // the final stage of figuring out what AHB transfer to do is
  // here (it picks either "what to do for a write" or "what to do
  // for a read" provided by the CGEN_LOGIC submod).
  //
  // The, the heavy work here is to figure out what this does to
  // to_process_addr and to_process_len. And whether it's enough
  // to complete the AXI transfer.
  //
  // For writes, this block also deals with the WDFIFO.

  always @(*)

  begin : figure_next_AHB_PROC

   // "CGEN_CPIPE_VALID" tells the IF module that this CGEN module is 
   // sending it a valid AHB command. (Via the CPIPE module).
   //
   // NOTE: if "cgen_cpipe_valid" is 1 here, it may be set to "0" later
   // on (if writing, and the WDFIFO is empty, or WDATA is sparse).
   // If "cgen_cpipe_valid" is set to 0 here, it will remain 0.

   if (use_remainder)
     cgen_cpipe_valid = 1'b1;
   else if (   cmdq_valid
             & (~wresp_pending))
     cgen_cpipe_valid = 1'b1;
   else
     cgen_cpipe_valid = 1'b0;
   

   // "HOLD_LOCAL" says, the "remainder_xxx" registers should not be
   // advanced, and FIFOs not popped, at the next clock (there is also
   // something called "HOLD_IF").
   //
   // NOTE: if "hold_local" is 0 here, it may be set to "1" later
   // on (if writing, and the WDFIFO is empty).
   // But, if "hold_local" is set to 1 here, it will remain 1.
   //
   // AT THIS POINT, hold_local is just the opposite of "cgen_cpipe_valid"
   // but this may not be true by the end of this async block. Sparse data
   // will deassert cgen_cpipe_valid w/o turning on hold_local

   hold_local  = ~cgen_cpipe_valid;



   // By default, don't set this. May override below.

   set_wstrb_0_skipped     = 1'b0;


   if (to_process_rw)   // IT'S A WRITE
     begin

       // ALWAYS do 1 beat at a time for writes, as we crawl
       // through the WSTRBs
       //ahb_bcount     = 5'd1;
       ahb_bcount     = 4'd0;
       ahb_size       = wr_ahb_size;
       ahb_xbytes     = {4'b0, wr_ahb_xbytes};

       if (~wdfifo_valid)
         begin
           // WDFIFO empty. Turn off CGEN_CPIPE_VALID, assert HOLD_LOCAL
           cgen_cpipe_valid    = 1'b0;
           hold_local          = 1'b1;
         end

       else if (~wstrb_1)
         // WDFIFO has data, but the WSTRBs are 0.
         // Turn off CGEN_CPIPE_VALID (sparse data is not sent to the IF).
         // However, do NOT assert HOLD_LOCAL... want to advance
         // remainder_xxx and maybe pop the FIFO.
         begin
           cgen_cpipe_valid    = 1'b0;
           set_wstrb_0_skipped = 1'b1;
         end
     end
               
   else  // IT'S A READ
     begin
       ahb_bcount     = rd_ahb_bcount;
       ahb_size       = rd_ahb_size;
       ahb_xbytes     = rd_ahb_xbytes;
     end


   // "ahb_xbytes" is the number of bytes to be transferred on AHB by the
   // command currently being sent to the IF (for a burst read, it's just the
   // bytes for the first beat, not for the whole burst). Note that, due to the
   // rules of AHB, this will always be  a power of 2 (ie, one bit only will be set).
   //
   // In various places it's useful to be able to quickly calculate
   // if the AHB command being sent is going to advance the transfer past an
   // AXI beat (it might NOT if there's downsizing, or an unaligned start, or
   // some weirness due to sparse write data). So, prepare this mask
   // "xbytes_to_bump_axi" from the AXI transfer size and the current address.
   // If the "ahb_xbytes" is big enough to pass an AXI beat boundary, it will
   // catch one of the 1's in xbytes_to_bump_axi.
 
   if ((`X2H_AXI_DATA_WIDTH > 128) & (to_process_axi_size == `X2H_AMBA_SIZE_32BYTE))
     xbytes_to_bump_axi  = {1'b1,
                            to_process_addr[4],
                            &to_process_addr[4:3],
                            &to_process_addr[4:2],
                            &to_process_addr[4:1],
                            &to_process_addr[4:0]};
   else if ((`X2H_AXI_DATA_WIDTH > 64) & (to_process_axi_size == `X2H_AMBA_SIZE_16BYTE))
     xbytes_to_bump_axi  = {2'b01,
                            to_process_addr[3],
                            &to_process_addr[3:2],
                            &to_process_addr[3:1],
                            &to_process_addr[3:0]};
   else if ((`X2H_AXI_DATA_WIDTH > 32) & (to_process_axi_size == `X2H_AMBA_SIZE_8BYTE))
     xbytes_to_bump_axi  = {3'b001,
                            to_process_addr[2],
                            &to_process_addr[2:1],
                            &to_process_addr[2:0]};
   else if (to_process_axi_size[1])    // 4-byte
     xbytes_to_bump_axi  = {4'b0001,
                            to_process_addr[1],
                            &to_process_addr[1:0]};
   else if (to_process_axi_size[0])    // 2-byte
     xbytes_to_bump_axi  = {5'b0_0001,
                            to_process_addr[0]};
   else                                // 1-byte
     xbytes_to_bump_axi  = 6'b00_0001;
      


   // OK have figured out SIZE and LEN of burst to do on AHB.
   // I guess we should tell the IF about it...

   cgen_cpipe_ahb_haddr   = to_process_addr;
   cgen_cpipe_ahb_hwrite  = to_process_rw;
   cgen_cpipe_axi_id      = to_process_id;
   cgen_cpipe_axi_size    = to_process_axi_size;
   cgen_cpipe_ahb_hprot   = {to_process_cache[1:0],
                             to_process_prot_0,
                             ~to_process_prot_2};

   cgen_cpipe_ahb_hwdata  = wdata_mux_function( to_process_addr[4:0],
                                                wdfifo_wdata );

   cgen_cpipe_ahb_hsize   = ahb_size;

   if      (ahb_bcount[4])
     cgen_cpipe_ahb_hburst   = `X2H_AHB_HBURST_INCR16;
   else if (ahb_bcount[3])
     cgen_cpipe_ahb_hburst   = `X2H_AHB_HBURST_INCR8;
   else if (ahb_bcount[2])
     cgen_cpipe_ahb_hburst   = `X2H_AHB_HBURST_INCR4;
   else
     cgen_cpipe_ahb_hburst   = `X2H_AHB_HBURST_SINGLE;


   // Also tell the IF if this is an address that must be done as
   // a new NONSEQ, such as: new command, WRAP or 1K boundary, or
   // after skipping some 0 WSTRBs
   //
   // There are other cases where the IF needs to use a NONSEQ,
   // for example if we switch SIZE, or the IF has to go IDLE
   // between beats, but the IF is left to figure these out
   // for itself.
   
   if (~use_remainder | fixed_reload | wstrb_0_skipped)
     cgen_cpipe_nonseq_addr   = 1'b1;
   else
     // Figure out if this address needs to be a new NONSEQ because
     // it's starting up at a WRAP or 1K boundary.
     //
     // Remember, "to_process_wrapmask" is all-ones if there's no wrapping,
     // otherwise it's something like, for example: 0000_0000_0111 (for
     // wrapping at 8-byte boundary).
     //
     // So, if the bits of to_process_addr[9:0] which have corresponding
     // ONES in "to_process_wrapmask" are ALL ZEROES, this is either a
     // WRAP or 1K boundary.

     cgen_cpipe_nonseq_addr   = ~|(to_process_addr[9:0] & to_process_wrapmask[9:0]);



   // For a read, tell the IF how many RDFIFO pushes will
   // be needed to perform it.
 
       
       
       
     // AXI and AHB configured to the same size. So, there will never
     // be downsizing
       
     // NO downsize
     // 16-burst will take 16 places
     //  8-burst will take 8 places
     //  4-burst will take 4 place
     //  1-burst might take a place per xbytes_to_bump_axi
     begin
       cgen_cpipe_rdfifo_req = {ahb_bcount[4:1], 1'b0};
       if (|(rd_ahb_xbytes & {4'b0000, xbytes_to_bump_axi}))
         cgen_cpipe_rdfifo_req[0]  = 1'b1;
     end


   // OK, "ahb_xbytes" is the number of bytes to be transferred on AHB
   // See what this is going to do to the remainder_addr, the remainder_axibytes,
   // and the remainder_axibytes_2b
   //
   // NOTE THAT THIS WORKS THE SAME whether the transfer is actually
   // being sent to IF (by "cgen_cpipe_valid") or it's just a "dummy"
   // len/size to burn off some zero WSTRBs
   //
   // First the address. It would have been so easy to say:
   //
   //    incremented_addr =  to_process_addr[11:0] + {2'b00, ahb_xbytes};
   //
   // but since "ahb_xbytes" is kind of late, this creates a critical
   // path. Since "ahb_xbytes" is known to be a power of two, the following
   // turns out to be quicker:

   //leda W484 off
   //LMD:Possible loss of carry/borrow in addition/subtraction
   //LJ: Overflow will never happen.
   addr_plus_1    =   to_process_addr[11:0] + 1;
   //leda W484 on
   addr_plus_2    = {(to_process_addr[11:1] + 1), to_process_addr[0]};
   addr_plus_4    = {(to_process_addr[11:2] + 1), to_process_addr[1:0]};
   addr_plus_8    = {(to_process_addr[11:3] + 1), to_process_addr[2:0]};
   addr_plus_16   = {(to_process_addr[11:4] + 1), to_process_addr[3:0]};
   addr_plus_32   = {(to_process_addr[11:5] + 1), to_process_addr[4:0]};
   addr_plus_64   = {(to_process_addr[11:6] + 1), to_process_addr[5:0]};
   addr_plus_128  = {(to_process_addr[11:7] + 1), to_process_addr[6:0]};
   addr_plus_256  = {(to_process_addr[11:8] + 1), to_process_addr[7:0]};
    addr_plus_512  = {(to_process_addr[11:9] + 1), to_process_addr[8:0]};

   incremented_addr =   {12{ahb_xbytes[0]}} & addr_plus_1
                      | {12{ahb_xbytes[1]}} & addr_plus_2
                      | {12{ahb_xbytes[2]}} & addr_plus_4
                      | {12{ahb_xbytes[3]}} & addr_plus_8
                      | {12{ahb_xbytes[4]}} & addr_plus_16
                      | {12{ahb_xbytes[5]}} & addr_plus_32
                      | {12{ahb_xbytes[6]}} & addr_plus_64
                      | {12{ahb_xbytes[7]}} & addr_plus_128
                      | {12{ahb_xbytes[9]}} & addr_plus_512
                      | {12{ahb_xbytes[8]}} & addr_plus_256;

   // Note that if ahb_xbytes[9] is set, that indicates a 512-byte transfer
   // (16 beats x 32 bytes). Since this MUST complete the AXI command
   // anyway, it's not necessary to update the address in this case.

   // "to_process_wrapmask" is all-ones if there's no wrapping,
   // otherwise it's something like, for example: 0000_0000_1111 (for
   // wrapping at 16-byte boundary.
   //
   // So, "1" means: load this bit of remainder_addr with the INCREMENTED
   // value, but "0" means: recycle the unincremented "to_process_addr"

   nxt_remainder_addr   =     to_process_wrapmask[11:0] & incremented_addr[11:0]
                           | ~to_process_wrapmask[11:0] & to_process_addr[11:0];


   // Decrement the byte counters (one for the overall transfer, and the
   // other which counts the bytes to a possible wrap or 1K boundary)

   //leda W484 off
   //LMD:Possible loss of carry/borrow in addition/subtraction
   //LJ: underflow will never happen. Refer to description of ahb_xbytes.
   nxt_remainder_axibytes      = to_process_axibytes    - {4'h0,ahb_xbytes};
   nxt_remainder_axibytes_2b   = to_process_axibytes_2b - {4'h0,ahb_xbytes};
   //leda W484 on

   // Maintain this bit which tells if the transfer expects to hit
   // a WRAP or 1K boundary before completing. 

   if ({4'h0,ahb_xbytes} == to_process_axibytes_2b)
     nxt_remainder_2b_first  = 1'b0;
   else
     nxt_remainder_2b_first  = to_process_2b_first;


   // Is the current "ahb_xbytes" going to complete the "axibytes"?

   if ({4'h0,ahb_xbytes} == to_process_axibytes)

     // This AHB transfer is either going to complete the AXI
     // transfer, or it's going to complete one "repetition"
     // of a "FIXED" burst

     begin

       if (to_process_frepcount == 0)

         // Done with the AXI command. Want to NOT be in "use_remainder"
         // next time. Indicate to IF that this is the LAST AHB comand
         // of the AXI command.
         //
         // POP the command queue if the command was a read. For
         // writes, let the push of the write response also pop the
         // command queue, then the ID doesn't need to be bufferred.
         begin
           nxt_remainder_frepcount = to_process_frepcount;
           nxt_use_remainder       = 1'b0;
           nxt_fixed_reload        = 1'b0;
           cgen_cpipe_axi_last     = 1'b1;
           if (~to_process_rw)
             time_to_pop_rd_cmd      = 1'b1;
           else
             time_to_pop_rd_cmd      = 1'b0;
         end

       else

         // Done with one loop of a FIXED command (but not the last one)
         // Stay in "use_remainder", schedule a "fixed_reload" to happen
         // next. Don't POP yet.
         begin
           //leda W484 off
           //LMD:Possible loss of carry/borrow in addition/subtraction
           //LJ: Underflow will never happen. Condition taken care in previous IF statement.
           nxt_remainder_frepcount = to_process_frepcount - 1;
           //leda W484 on
           nxt_use_remainder       = 1'b1;
           nxt_fixed_reload        = 1'b1;
           cgen_cpipe_axi_last     = 1'b0;
           time_to_pop_rd_cmd      = 1'b0;
         end
     end

   else  // The len_change is not enough to complete the AXI transfer
         // (or the FIXED repetition)

     begin
       nxt_remainder_frepcount = to_process_frepcount;
       nxt_use_remainder       = 1'b1;
       nxt_fixed_reload        = 1'b0;
       cgen_cpipe_axi_last     = 1'b0;
       time_to_pop_rd_cmd      = 1'b0;
     end
     


   // WDFIFO tending.
   //
   // If writing, "len_change" will be 0 or 1. If 1, time to pop the
   // WDFIFO. This is also the time to defiantly check WLAST, it should
   // agree with the "cgen_cpipe_axi_last" just calculated...

   if (to_process_rw & (|(xbytes_to_bump_axi & wr_ahb_xbytes[5:0])))
     begin
       time_to_pop_wdfifo   = 1'b1;
       set_wlast_err        = wdfifo_valid
                              & (wdfifo_wlast != cgen_cpipe_axi_last);
     end
   else
     begin
       time_to_pop_wdfifo   = 1'b0;
       set_wlast_err        = 1'b0;
     end


  end // Of the big combinatorial block


  ///////////////////////////////////////////////////////////////////
  // WRITE RESPONSE GENERATION
  //
  // The FF "wresp_pending" gets set when the axi_last beat of a
  // write gets delivered to the IF. (I should say when it
  // POTENTIALLY gets delivered... if the axi_last transfer doesn't
  // go to IF because it's sparse, "~hold_local & ~hold_if" will still
  // be true when the beat gets processed, and the flip-flop will
  // still be set)

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         wresp_pending      <= 1'b0;
         got_write_err      <= 1'b0;
       end
     else
       begin
         if (to_process_rw & cgen_cpipe_axi_last & (~hold_local) & (~hold_if))
           wresp_pending      <= 1'b1;
         else if (~push_resp_int_n)
           wresp_pending      <= 1'b0;

         if (if_cgen_wr_err | set_wlast_err & (~hold_local) & (~hold_if))
           got_write_err      <= 1'b1;
         else if (~push_resp_int_n)
           got_write_err      <= 1'b0;
       end


   // Push the response when the "wresp_pending" is set, and
   // there are no AHB transfers still "pending" (this means:
   // none in the CPIPE, none in address phase, none in data 
   // phase, and none needing "retry"), and the response FIFO
   // is not completely full

   assign push_resp_int_n = ~(   wresp_pending
                               & (~cpipe_cgen_xfr_pending)
                               & (~hresp_rdy_int_n));


   // And here are the 2 items that get pushed into the RESP buffer:

// leda NTL_CON16 off
// LMD: Signal tied to logic 0/1
// LJ : Depending on the got_write_err qualifier the hw_status_int signal takes a value that is a constant.
   assign hwstatus_int    = got_write_err ? `X2H_AXI_RESP_SLVERR
                                          : `X2H_AXI_RESP_OKAY;
// leda NTL_CON16 on

   assign hwid_int        = to_process_id;






//wdata mux function. used to extract the valid data bits based on the address.
function [`X2H_AHB_DATA_WIDTH-1:0] wdata_mux_function;
  input [4:0] address;
  input [`X2H_AXI_DATA_WIDTH-1:0] wdfifo_wdata;

  reg [255:0]  wdata_256bit;
  begin
      
    wdata_mux_function = {`X2H_AHB_DATA_WIDTH{1'b0}};

    // Copy and repeat as needed to make temp
    // 256-bit version of AXI-wisth data:
      wdata_256bit = {(256/`X2H_AXI_DATA_WIDTH){wdfifo_wdata}};

      case (address[4:2])
        3'b111 :  wdata_mux_function = wdata_256bit[255:224];
        3'b110 :  wdata_mux_function = wdata_256bit[223:192];
        3'b101 :  wdata_mux_function = wdata_256bit[191:160];
        3'b100 :  wdata_mux_function = wdata_256bit[159:128];
        3'b011 :  wdata_mux_function = wdata_256bit[127:96];
        3'b010 :  wdata_mux_function = wdata_256bit[95:64];
        3'b001 :  wdata_mux_function = wdata_256bit[63:32];
        default : wdata_mux_function = wdata_256bit[31:0];
      endcase
  end
endfunction

endmodule


