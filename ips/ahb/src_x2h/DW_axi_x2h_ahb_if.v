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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_ahb_if.v#6 $ 
//
// -------------------------------------------------------------------------
// Filename    : DW_axi_x2h_ahb_if.v
//
// Description : Final interface to AHB. Gets told what to do by the CGEN
//               (via the CPIPE, for timing), and deals with AHB.
//
//               This module can be configured for either full AHB or AHB-Lite
//               operation (this is done by "ifdef X2H_AHB_LITE_TRUE"
//               statements.)
//
//               This IF module writes to the RDFIFO.
//
//               However, this IF module does NOT interface to the WDFIFO or
//               or the Write Response Buffer. (The CGEN module does instead.)
//-----------------------------------------------------------------------------
`include "DW_axi_x2h_cc_constants.v"
module DW_axi_x2h_ahb_if (

// Inputs

   clk, 
                          rst_n,
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
                          cpipe_if_axi_size,
                          mhgrant,
                          mhready, 
                          mhresp, 
                          mhrdata,
                          hrdata_push_cnt,
                          // Outputs
                          if_cpipe_ready, 
                          if_cpipe_xfr_pending,
                          if_cgen_wr_err, 
                          mhbusreq,
                          mhaddr, 
                          mhsize, 
                          mhtrans,
                          mhburst, 
                          mhwrite, 
                          mhprot, 
                          mhwdata,
                          hrid_int, 
                          hrdata_int, 
                          hrstatus_int, 
                          hrlast_int, 
                          push_data_int_n
                          );



   input                              clk;
   input                              rst_n;

   // Interface to CGEN (mostly via CPIPE)

   input                              cpipe_if_valid;

   output                             if_cpipe_ready;


   input    [`X2H_CMD_ADDR_WIDTH-1:0] cpipe_if_ahb_haddr;
   input                              cpipe_if_ahb_hwrite;
   input                        [2:0] cpipe_if_ahb_hsize;
   input                        [2:0] cpipe_if_ahb_hburst;
   input                        [3:0] cpipe_if_ahb_hprot;
   input    [`X2H_AHB_DATA_WIDTH-1:0] cpipe_if_ahb_hwdata;

   input                              cpipe_if_nonseq_addr;
   input                              cpipe_if_axi_last;
   input                        [4:0] cpipe_if_rdfifo_req;

   input      [`X2H_AXI_ID_WIDTH-1:0] cpipe_if_axi_id;
   input                        [2:0] cpipe_if_axi_size;

   output                             if_cpipe_xfr_pending;
   output                             if_cgen_wr_err;




   // The AHB signals

   input                              mhgrant;

   input                              mhready;
   input                        [1:0] mhresp;
   input    [`X2H_AHB_DATA_WIDTH-1:0] mhrdata;


   output                             mhbusreq;


   output   [`X2H_AHB_ADDR_WIDTH-1:0] mhaddr;
   output                       [2:0] mhsize;
   output                       [1:0] mhtrans;
   output                       [2:0] mhburst;
   output                             mhwrite;

   output                       [3:0] mhprot;
   output   [`X2H_AHB_DATA_WIDTH-1:0] mhwdata;


   // Interface to the RDFIFO

   input                        [7:0] hrdata_push_cnt;

   output     [`X2H_AXI_ID_WIDTH-1:0] hrid_int;
   output   [`X2H_AXI_DATA_WIDTH-1:0] hrdata_int;
   output                             hrlast_int;
   output                       [1:0] hrstatus_int;

   output                             push_data_int_n;





   // THESE ARE FLIP-FLOPS:

   reg                       [1:0] if_state;
   reg                       [3:0] burst_rem;

   reg   [`X2H_CMD_ADDR_WIDTH-1:0] mhaddr_reg;
   reg                       [2:0] mhsize;
   reg                       [1:0] mhtrans;
   reg                       [2:0] mhburst;
   reg                             mhwrite;
   reg                       [3:0] mhprot;
   reg   [`X2H_AHB_DATA_WIDTH-1:0] aphase_wdata;
   reg                             aphase_write;
   reg                             aphase_read;
   reg                             aphase_push_read;
   reg     [`X2H_AXI_ID_WIDTH-1:0] aphase_axi_id;
   reg                             aphase_axi_last;
   reg                       [2:0] dphase_size;
   reg     [`X2H_AXI_ID_WIDTH-1:0] dphase_axi_id;
   reg                             pushed;
   reg     [`X2H_AXI_ID_WIDTH-1:0] new_aphase_axi_id;


   reg   [`X2H_AHB_DATA_WIDTH-1:0] mhwdata;
   reg                             dphase_write;
   reg                             dphase_read;
   reg                             dphase_push_read;
   reg                             dphase_axi_last;

   reg                             push_rdfifo;
   reg     [`X2H_AXI_ID_WIDTH-1:0] hrid_int;
   reg   [`X2H_AXI_DATA_WIDTH-1:0] hrdata_int;
   reg                       [1:0] hrstatus_int;
   reg                             hrlast_int;


   // These will be flip-flops if "X2H_PASS_LOCK" is set




   // These are NOT flip-flops:

   wire   [`X2H_AHB_ADDR_WIDTH-1:0] mhaddr;

   reg                       [1:0] new_if_state;
   reg                       [3:0] new_burst_rem;

   reg                             set_hbusreq;
   reg                             clr_hbusreq;
//   reg                             set_hlock;
//   reg                             clr_hlock;
   reg                             adv_cgen_if_myhready;

   reg                       [1:0] pending_rdfifo_push_count;
   reg                       [8:0] adjusted_rdfifo_count;
   reg                             rdfifo_has_16;
   reg                             rdfifo_has_8;
   reg                             rdfifo_has_4;
   reg                             rdfifo_has_2;
   reg                             rdfifo_has_1;
   reg                             rdfifo_ok_to_start;

   reg                       [9:0] next_baddr;
   reg                             next_baddr_read_push;
   reg                             next_haddr_read_push;


   reg   [`X2H_CMD_ADDR_WIDTH-1:0] new_mhaddr_reg;
   reg                       [2:0] new_mhsize;
   reg                       [1:0] new_mhtrans;
   reg                       [2:0] new_mhburst;
   reg                             new_mhwrite;
   reg                       [3:0] new_mhprot;
   reg   [`X2H_AHB_DATA_WIDTH-1:0] new_aphase_wdata;
   reg                             new_aphase_write;
   reg                             new_aphase_read;
   reg                             new_aphase_push_read;
   reg                             new_aphase_axi_last;



   wire                            mhgrant_int;
   wire                            mhgrant_is_hanging;

   wire  [`X2H_CMD_ADDR_WIDTH-1:0] dphase_addr_fb;
   wire                            dphase_mhwrite_fb;
   wire                      [3:0] dphase_mhprot_fb;

   wire  [`X2H_AXI_DATA_WIDTH-1:0] new_hrdata_int;
   wire                      [1:0] new_hrstatus_int;



   // If not AHB-Lite, the full address gets carried into dphase
   // for possible recycling.

   wire  [`X2H_CMD_ADDR_WIDTH-1:0] dphase_addr_in;
   reg   [`X2H_CMD_ADDR_WIDTH-1:0] dphase_addr;

   // AND, tons more stuff is added for dealing with SPLIT and RETRY

   // THESE ARE FLIP-FLOPS (added for AHB-Heavy)

   reg                             mhbusreq_reg;
   reg                             mhbusreq_delayed;

   reg                             dphase_mhwrite;
   reg                       [3:0] dphase_mhprot;
   reg                       [1:0] dphase_otrans;
   reg                             dphase_oincr;

   reg                             retry_hold_wdata_reg;

   reg                             rss_1st_write;
   reg                             rss_1st_read;
   reg                             rss_1st_push_read;
   reg                       [1:0] rss_1st_otrans;
   reg                             rss_1st_oincr;

   reg                             rss_2nd_write;
   reg                             rss_2nd_read;
   reg                             rss_2nd_push_read;
   reg                       [1:0] rss_2nd_otrans;
   reg                       [2:0] rss_2nd_oburst;

   reg                       [1:0] if_retry_state;

   // These are NON-flip-flop regs (added for AHB-Heavy)

   reg                             retry_set_hbusreq_reg;
   reg                             retry_clr_hbusreq_reg;

   reg                       [1:0] nxt_if_retry_state;

   reg                       [1:0] working_retry_trans;
   reg                       [2:0] working_retry_burst;

   reg                             retry_swap_addr_reg;

   reg                       [1:0] retry_mhtrans_reg;
   reg                       [2:0] retry_mhburst_reg;
   reg                             retry_aphase_write_reg;
   reg                             retry_aphase_read_reg;
   reg                             retry_aphase_push_read_reg;




   // Note: these RETRY-associated wires do stay around for
   // AHB-Lite, but they all get tied to 0

   wire                            my_retry;
   wire                            retry_active;

   wire                            retry_set_hbusreq;
   wire                            retry_clr_hbusreq;

   wire                            retry_swap_addr;
   wire                      [1:0] retry_mhtrans;
   wire                      [2:0] retry_mhburst;
   wire                            retry_aphase_write;
   wire                            retry_aphase_read;
   wire                            retry_aphase_push_read;
   wire                            retry_hold_wdata;




   parameter  ST_IF_NEW_CGEN       = 2'b00;
   parameter  ST_IF_AFTER_BURST    = 2'b01;
   parameter  ST_IF_BURST          = 2'b10;


   parameter  ST_IF_RETRY_IDLE     = 2'b00;
   parameter  ST_IF_RETRY_1        = 2'b01;
   parameter  ST_IF_RETRY_2        = 2'b10;
   parameter  ST_IF_RETRY_3        = 2'b11;



////////////////////////////////////////////////////////
// ARBITRATION

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         mhbusreq_reg       <= 1'b0;
         mhbusreq_delayed   <= 1'b0;
       end
     else
       begin
         if (   my_retry   )
           mhbusreq_reg       <= 1'b1;
         else if (retry_active & retry_clr_hbusreq & mhready & mhgrant)
           mhbusreq_reg       <= 1'b0;
         else if (retry_active & retry_set_hbusreq)
           mhbusreq_reg       <= 1'b1;
         else if (~retry_active & clr_hbusreq & mhready & mhgrant)
           mhbusreq_reg       <= 1'b0;
         else if (~retry_active & set_hbusreq)
           mhbusreq_reg       <= 1'b1;

         if (mhready)
           mhbusreq_delayed   <= mhbusreq_reg;
       end

   assign mhbusreq    = mhbusreq_reg;
   assign mhgrant_int = mhgrant;

   assign mhgrant_is_hanging  = mhbusreq_delayed & (~mhbusreq_reg);




////////////////////////////////////////////////////////
// MHTRANS and MHBURST

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       mhtrans            <= `X2H_AHB_HTRANS_IDLE;
     else
       begin
         if (mhready & (~mhgrant_int) | my_retry)
           mhtrans            <= `X2H_AHB_HTRANS_IDLE;
         else
	 if (~retry_active & mhready)
           mhtrans            <= new_mhtrans;
         else if (retry_active & mhready)
           mhtrans            <= retry_mhtrans;
       end

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       mhburst            <= `X2H_AHB_HBURST_SINGLE;
     else
       begin
         if (~retry_active & mhready & mhgrant_int)
           mhburst            <= new_mhburst;
         else 
	 if (retry_active & mhready)
           mhburst            <= retry_mhburst;
       end


////////////////////////////////////////////////////////
// "ACTION BITS"

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         aphase_write       <= 1'b0;
         aphase_read        <= 1'b0;
         aphase_push_read   <= 1'b0;
       end
     else
       begin
         if (mhready & (~mhgrant_int) | my_retry)
           begin
             aphase_write       <= 1'b0;
             aphase_read        <= 1'b0;
             aphase_push_read   <= 1'b0;
           end
         else if (~retry_active & mhready)
           begin
             aphase_write       <= new_aphase_write;
             aphase_read        <= new_aphase_read;
             aphase_push_read   <= new_aphase_push_read;
           end
         else if (retry_active & mhready)
           begin
             aphase_write       <= retry_aphase_write;
             aphase_read        <= retry_aphase_read;
             aphase_push_read   <= retry_aphase_push_read;
           end
       end


   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         dphase_write       <= 1'b0;
         dphase_read        <= 1'b0;
         dphase_push_read   <= 1'b0;
       end
     else
       begin
         if (my_retry)
           begin
             dphase_write       <= 1'b0;
             dphase_read        <= 1'b0;
             dphase_push_read   <= 1'b0;
           end
         else if (mhready)
           begin
             dphase_write       <= aphase_write;
             dphase_read        <= aphase_read;
             dphase_push_read   <= aphase_push_read;
           end
       end


////////////////////////////////////////////////////////
// ADDRESS, SIZE, "PROT", etc
// those characteristics of each transfer which do
// NOT change even if the transfer gets RETRY

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         mhaddr_reg         <= {`X2H_CMD_ADDR_WIDTH{1'b0}};
         mhsize             <= 3'b000;
         mhwrite            <= 1'b0;
         mhprot             <= 4'b0000;
         aphase_axi_id      <= {`X2H_AXI_ID_WIDTH{1'b0}};
         aphase_axi_last    <= 1'b0;
       end
     else
       begin
         if (~retry_active & mhready & mhgrant_int)
           begin
             mhaddr_reg         <= new_mhaddr_reg;
             mhsize             <= new_mhsize;
             mhwrite            <= new_mhwrite;
             mhprot             <= new_mhprot;
             aphase_axi_id      <= new_aphase_axi_id;
             aphase_axi_last    <= new_aphase_axi_last;
           end
         else if (retry_active & mhready & retry_swap_addr)
           begin
             mhsize             <= dphase_size;
//`ifndef X2H_AHB_LITE_TRUE
             mhaddr_reg         <= dphase_addr_fb;
             mhwrite            <= dphase_mhwrite_fb;
             mhprot             <= dphase_mhprot_fb;
//`else
//             mhaddr_reg         <= {`X2H_CMD_ADDR_WIDTH{1'b0}}; //dphase_addr_fb;
//             mhwrite            <= 1'b0;      //dphase_mhwrite_fb;
//             mhprot             <= 4'b0000;   //dphase_mhprot_fb;
//`endif
             aphase_axi_id      <= dphase_axi_id;
             aphase_axi_last    <= dphase_axi_last;
           end
       end

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         dphase_addr       <= {`X2H_CMD_ADDR_WIDTH{1'b0}};
         dphase_size       <= 3'b000;
         dphase_axi_id     <= {`X2H_AXI_ID_WIDTH{1'b0}};
         dphase_axi_last   <= 1'b0;
       end
     else
       begin
         if ((~retry_active | retry_swap_addr) & mhready)
           begin
             dphase_addr       <= dphase_addr_in;
             dphase_size       <= mhsize;
             dphase_axi_id     <= aphase_axi_id;
             dphase_axi_last   <= aphase_axi_last;
           end
       end



   assign  dphase_addr_in     = mhaddr_reg;

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         dphase_mhwrite    <= 1'b0;
         dphase_mhprot     <= 4'b0;
         dphase_otrans     <= 2'b0;
         dphase_oincr      <= 1'b0;
       end
     else
       begin
         if ((~retry_active | retry_swap_addr) & mhready)
           begin
             dphase_mhwrite    <= mhwrite;
             dphase_mhprot     <= mhprot;
             dphase_otrans     <= mhtrans;
             if (mhburst == `X2H_AHB_HBURST_INCR)
               dphase_oincr      <= 1'b1;
             else
               dphase_oincr      <= 1'b0;
           end
       end

   assign  dphase_addr_fb     = dphase_addr;
   assign  dphase_mhwrite_fb  = dphase_mhwrite;
   assign  dphase_mhprot_fb   = dphase_mhprot;




   // mhaddr_reg is only 64-bit if the entire path is 64-bit.
   // Otherwise, it's 32-bit but might need to be extended
   // for AHB
//   always @(mhaddr_reg)
//     begin
//       if ( (`X2H_CMD_ADDR_WIDTH == 32) & (`X2H_AXI_ADDR_WIDTH == 64) )
//         mhaddr  = {32'b0, mhaddr_reg};
//       else
//         mhaddr  = mhaddr_reg;
//     end

    assign mhaddr = mhaddr_reg;
/*
   always @(mhaddr_reg)
     begin
       if (`X2H_AHB_ADDR_WIDTH == 64)
         begin
           if (`X2H_AXI_ADDR_WIDTH == 64)
             mhaddr  =  mhaddr_reg;
           else
             mhaddr  = {{(64-`X2H_AXI_ADDR_WIDTH){1'b0}},mhaddr_reg};
         end
       else
         mhaddr  = mhaddr_reg;
     end
*/

////////////////////////////////////////////////////////
// WRITE DATA

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       aphase_wdata       <= {`X2H_AHB_DATA_WIDTH{1'b0}};
     else
       begin
         if (~retry_active & mhready & mhgrant_int)
           aphase_wdata       <= new_aphase_wdata;
       end

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       mhwdata           <= {`X2H_AHB_DATA_WIDTH{1'b0}};
     else
       begin
         if (~retry_hold_wdata & mhready)
           mhwdata           <= aphase_wdata;
       end


////////////////////////////////////////////////////////
// REGISTERS for "main" state machine
// The IF state and etc get updated when the main state
// machine successfully puts something into address phase
// but does NOT advance when "mhgrant & mhready" is not
// true, or when the bridge is dealing with a RETRY

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         if_state           <= ST_IF_NEW_CGEN;
         burst_rem          <= 4'b0000;
       end

     else
       begin
         if (mhready & mhgrant_int & (~my_retry) & (~retry_active))
           begin
             if_state           <= new_if_state;
             burst_rem          <= new_burst_rem;
           end
       end


// The "adv_cgen_if_myhready" also gets sent to actually advance the CGEN
// under the same conditions that the IF state and etc advance

assign if_cpipe_ready   = adv_cgen_if_myhready & mhready
                          & mhgrant_int
			  & (~my_retry) & (~retry_active);



////////////////////////////////////////////////////////
// LOGIC for the main state machine. This figures out
// the next "new_" transfer to put into the address
// phase

always @(*)

  begin : next_move_PROC

    new_if_state          = if_state;
    new_burst_rem         = burst_rem;

    set_hbusreq           = 1'b0;
    clr_hbusreq           = 1'b0;
//    set_hlock             = 1'b0;
//    clr_hlock             = 1'b0;

    new_mhaddr_reg        = mhaddr_reg;
    new_mhsize            = mhsize;
    new_mhburst           = mhburst;
    new_mhwrite           = mhwrite;
    new_mhprot            = mhprot;
    new_aphase_wdata      = aphase_wdata;

    new_aphase_write      = 1'b0;
    new_aphase_read       = 1'b0;
    new_aphase_push_read  = 1'b0;

    new_aphase_axi_id     = aphase_axi_id;
    new_aphase_axi_last   = 1'b0;

    adv_cgen_if_myhready  = 1'b0;



    //leda W484 off
    //LMD:Possible loss of carry/borrow in addition/subtraction
    //LJ: Overflow will never happen. push_rdfifo takes a value of 1 only when "push_read" completes the data phase.
    pending_rdfifo_push_count =   {1'b0, aphase_push_read}
                                + {1'b0, dphase_push_read}
                                + {1'b0, push_rdfifo};
    //leda W484 on

    // The TRUE count of what's in the read FIFO, including any reads
    // launched to AHB that aren't yet reflected in the FIFO's count

    //leda W484 off
    //LMD:Possible loss of carry/borrow in addition/subtraction
    //LJ: Overflow will never happen.
    adjusted_rdfifo_count = {1'b0, hrdata_push_cnt}
                            + {7'b000000, pending_rdfifo_push_count};
    //leda W484 on


    // Is there enough FIFO space to START a proposed read command?
    //
    // The CGEN sends warning about how much space is required
    // (because of downshifting, it's not the same as the burst
    // length). The bad news is that this indication (cpipe_if_rdfifo_req)
    // comes hideously late. The good news is, it will always be a
    // power of 2. So, can kind of pre-analyze how many spaces are
    // available and then quickly combine that with cpipe_if_rdfifo_req

    if (   (`X2H_READ_BUFFER_DEPTH > 15)
         & (adjusted_rdfifo_count < (`X2H_READ_BUFFER_DEPTH - 15)) )
      rdfifo_has_16  = 1'b1;
    else
      rdfifo_has_16  = 1'b0;

    if (   (`X2H_READ_BUFFER_DEPTH > 7)
         & (adjusted_rdfifo_count < (`X2H_READ_BUFFER_DEPTH - 7)) )
      rdfifo_has_8   = 1'b1;
    else
      rdfifo_has_8   = 1'b0;

    if (   (`X2H_READ_BUFFER_DEPTH > 3)
         & (adjusted_rdfifo_count < (`X2H_READ_BUFFER_DEPTH - 3)) )
      rdfifo_has_4   = 1'b1;
    else
      rdfifo_has_4   = 1'b0;

    if (   (`X2H_READ_BUFFER_DEPTH > 1)
         & (adjusted_rdfifo_count < (`X2H_READ_BUFFER_DEPTH - 1)) )
      rdfifo_has_2   = 1'b1;
    else
      rdfifo_has_2   = 1'b0;

    if (adjusted_rdfifo_count < `X2H_READ_BUFFER_DEPTH)
      rdfifo_has_1   = 1'b1;
    else
      rdfifo_has_1   = 1'b0;

    if ( cpipe_if_rdfifo_req[4] & (~rdfifo_has_16)
         | cpipe_if_rdfifo_req[3] & (~rdfifo_has_8)
         | cpipe_if_rdfifo_req[2] & (~rdfifo_has_4)
         | cpipe_if_rdfifo_req[1] & (~rdfifo_has_2)
         | cpipe_if_rdfifo_req[0] & (~rdfifo_has_1) )

      rdfifo_ok_to_start    = 1'b0;

    else
      rdfifo_ok_to_start    = 1'b1;



    // For use during bursts, figure out the next burst address,
    // and whether or not it's going to involve a RDFIFO push

    //leda W484 off
    //LMD:Possible loss of carry/borrow in addition/subtraction
    //LJ: Overflow will never happen.
    next_baddr  = mhaddr_reg[9:0] + (10'd1 << mhsize);
    //leda W484 on

    next_baddr_read_push  = nxt_rd_push_function( next_baddr[4:0],
                                                  mhsize,
                                                  cpipe_if_axi_size );

    next_haddr_read_push  = nxt_rd_push_function( cpipe_if_ahb_haddr[4:0],
                                                  cpipe_if_ahb_hsize,
                                                  cpipe_if_axi_size );
    case (if_state)

      ST_IF_NEW_CGEN,
      ST_IF_AFTER_BURST :

        begin
          new_if_state          = ST_IF_NEW_CGEN;

          if ( cpipe_if_valid
               & (~mhgrant_is_hanging)
               & (cpipe_if_ahb_hwrite | rdfifo_ok_to_start))

            begin
              // Got a valid command. Either it's a WRITE (which carries
              // the data with it), or the RDFIFO is OK to do a read.
              // In either case, get started.

              if (cpipe_if_ahb_hburst == `X2H_AHB_HBURST_SINGLE)

                begin
                  // Processing for commands that come from CGEN as
                  // singles. All writes and some reads fall into this
                  // category. THIS BLOCK determines whether to put them
                  // on AHB as SINGLES or with an undefined-length INCR

                  set_hbusreq           = 1'b1;
                  if (cpipe_if_axi_last)
                    clr_hbusreq           = 1'b1;

                  // Might want to send as SEQ of INCR
                  if (   (mhburst == `X2H_AHB_HBURST_INCR)
                       & (mhtrans != `X2H_AHB_HTRANS_IDLE)
                       & (mhsize == cpipe_if_ahb_hsize)
                       & (~cpipe_if_nonseq_addr)
                       & (if_state != ST_IF_AFTER_BURST))
                    begin
                      new_mhtrans           = `X2H_AHB_HTRANS_SEQ;
                      new_mhburst           = `X2H_AHB_HBURST_INCR;
                    end

                  // Or as NONSEQ of INCR
                  else if ( (~cpipe_if_axi_last) )
                    begin
                      new_mhtrans           = `X2H_AHB_HTRANS_NONSEQ;
                      new_mhburst           = `X2H_AHB_HBURST_INCR;
                    end

                  // Otherwise, just do a SINGLE
                  else
                    begin
                      new_mhtrans           = `X2H_AHB_HTRANS_NONSEQ;
                      new_mhburst           = `X2H_AHB_HBURST_SINGLE;
                    end

                  // This single might be the "axi_last". Also,
                  // it's time to tell the CGEN we are taking this command.

                  new_aphase_axi_last   = cpipe_if_axi_last;
                  adv_cgen_if_myhready  = 1'b1;
                end

              else  // cpipe_if_ahb_hburst is not "`X2H_AHB_HBURST_SINGLE"

                begin
                  // But, STILL inside the clause where there is a new, valid
                  // command from CGEN. It's not single, so must be a burst read.
                  // Have already checked that the RDFIFO is good to go.

                  set_hbusreq           = 1'b1;
                  clr_hbusreq           = 1'b1;

                  new_mhtrans           = `X2H_AHB_HTRANS_NONSEQ;
                  new_mhburst           = cpipe_if_ahb_hburst;

                  if (cpipe_if_ahb_hburst == `X2H_AHB_HBURST_INCR16)
                    new_burst_rem         = 4'd15;
                  else if (cpipe_if_ahb_hburst == `X2H_AHB_HBURST_INCR8)
                    new_burst_rem         = 4'd7;
                  else if (cpipe_if_ahb_hburst == `X2H_AHB_HBURST_INCR4)
                    new_burst_rem         = 4'd3;

                  new_if_state          = ST_IF_BURST;
                end


              // Do this the same on any ready-to-go command, whether it's
              // a single or a burst...

              new_mhaddr_reg        = cpipe_if_ahb_haddr;
              new_mhsize            = cpipe_if_ahb_hsize;
              new_mhwrite           = cpipe_if_ahb_hwrite;
              new_mhprot            = cpipe_if_ahb_hprot;
              new_aphase_wdata      = cpipe_if_ahb_hwdata;
              new_aphase_axi_id     = cpipe_if_axi_id;

              if (cpipe_if_ahb_hwrite)
                new_aphase_write      = 1'b1;
              else
                begin
                  new_aphase_read       = 1'b1;
                  new_aphase_push_read  = next_haddr_read_push;
                end
            end

          else // no command to do from cgen... not VALID, or
               // a read that needs more RDFIFO space to start
            begin
              clr_hbusreq           = 1'b1;
              new_mhtrans           = `X2H_AHB_HTRANS_IDLE;
            end
        end

      ST_IF_BURST :

        begin

          // Will initially come here as the NONSEQ to start a
          // fixed-length read goes out. May complete the burst,
          // or may have to "rebuild" due to RETRY or SPLIT or an
          // Early Burst Termination. First thing to do is find
          // out if this happened:

          if (   (mhburst != `X2H_AHB_HBURST_SINGLE)
               & (mhburst != `X2H_AHB_HBURST_INCR)
               & (mhtrans != `X2H_AHB_HTRANS_IDLE))

            // ORIGINAL FIXED-LENGTH BURST still in progress
            // Continue with SEQ

            begin

              // Set all this "new" stuff, but none of it's going to
              // happen until we get (mhgrant & mhready)

              new_mhtrans           = `X2H_AHB_HTRANS_SEQ;
              new_mhaddr_reg[9:0]   = next_baddr;
              new_aphase_read       = 1'b1;
              new_aphase_push_read  = next_baddr_read_push;

              //leda W484 off
              //LMD:Possible loss of carry/borrow in addition/subtraction
              //LJ: Underflow will never happen. Taken care by state machine.
              new_burst_rem         = burst_rem - 1;
              //leda W484 on

              if (burst_rem == 1)
                begin
                  new_aphase_axi_last   = cpipe_if_axi_last;
                  adv_cgen_if_myhready  = 1'b1;
                  new_if_state          = ST_IF_AFTER_BURST;
                end
            end


          else if (   (mhburst == `X2H_AHB_HBURST_SINGLE)
                    | (mhtrans == `X2H_AHB_HTRANS_IDLE))

            // REBUILDING - NEXT OUT: NONSEQ

            begin

              set_hbusreq           = 1'b1;
              new_mhtrans           = `X2H_AHB_HTRANS_NONSEQ;
              new_mhaddr_reg[9:0]   = next_baddr;

                new_mhburst           = `X2H_AHB_HBURST_INCR;

              new_aphase_read       = 1'b1;
              new_aphase_push_read  = next_baddr_read_push;

              //leda W484 off
              //LMD:Possible loss of carry/borrow in addition/subtraction
              //LJ: Underflow will never happen. Taken care by state machine.
              new_burst_rem         = burst_rem - 1;
              //leda W484 on

              if (burst_rem == 1)
                begin
                  new_aphase_axi_last   = cpipe_if_axi_last;
                  if (cpipe_if_axi_last)
                    clr_hbusreq           = 1'b1;
                  adv_cgen_if_myhready  = 1'b1;
                  new_if_state          = ST_IF_AFTER_BURST;
                end
            end


          else

            // REBUILDING - NEXT OUT: SEQ of INCR

            begin

              new_mhtrans           = `X2H_AHB_HTRANS_SEQ;
              new_mhaddr_reg[9:0]   = next_baddr;

              new_aphase_read       = 1'b1;
              new_aphase_push_read  = next_baddr_read_push;

              //leda W484 off
              //LMD:Possible loss of carry/borrow in addition/subtraction
              //LJ: Underflow will never happen. Taken care by state machine.
              new_burst_rem         = burst_rem - 1;
              //leda W484 on

              if (burst_rem == 1)
                begin
                  new_aphase_axi_last   = cpipe_if_axi_last;
                  if (cpipe_if_axi_last)
                    clr_hbusreq           = 1'b1;
                  adv_cgen_if_myhready  = 1'b1;
                  new_if_state          = ST_IF_AFTER_BURST;
                end
            end
        end


      default :

        new_mhtrans   = `X2H_AHB_HTRANS_IDLE;
        // Should never get into default state:
        /* ova
           bind assert_never #(0,1,"OVA ERROR: IF SM in undefined state")
                              OVA_check_ifsm (clk, rst_n,
                              (   (if_state != ST_IF_NEW_CGEN)
                                & (if_state != ST_IF_BURST)
                                & (if_state != ST_IF_AFTER_BURST)));
        */

    endcase

  end  // of "next_move_PROC"



assign if_cpipe_xfr_pending   =   aphase_write | aphase_read
                                | dphase_write | dphase_read
                                | retry_active;



////////////////////////////////////////////////////////
// RETRY


   assign my_retry         = (dphase_write | dphase_read)
                             & (   (mhresp == `X2H_AHB_RESP_RETRY)
                                 | (mhresp == `X2H_AHB_RESP_SPLIT));

   assign retry_active     = (if_retry_state != ST_IF_RETRY_IDLE);

   assign retry_set_hbusreq        = retry_set_hbusreq_reg;
   assign retry_clr_hbusreq        = retry_clr_hbusreq_reg;

   assign retry_swap_addr          = retry_swap_addr_reg;

   assign retry_mhtrans            = retry_mhtrans_reg;
   assign retry_mhburst            = retry_mhburst_reg;
   assign retry_aphase_write       = retry_aphase_write_reg;
   assign retry_aphase_read        = retry_aphase_read_reg;
   assign retry_aphase_push_read   = retry_aphase_push_read_reg;

   // Once you get a RETRY, freeze the WDATA in place until
   // an "action bit" again gets set in the dphase

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       retry_hold_wdata_reg   <= 1'b0;
     else
       begin
         if (my_retry)
           retry_hold_wdata_reg   <= 1'b1;
         else if (dphase_write | dphase_read)
           retry_hold_wdata_reg   <= 1'b0;
       end

   assign retry_hold_wdata         = retry_hold_wdata_reg
                                     & (~dphase_write)
                                     & (~dphase_read);


   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         rss_1st_write      <= 1'b0;
         rss_1st_read       <= 1'b0;
         rss_1st_push_read  <= 1'b0;
         rss_1st_otrans     <= `X2H_AHB_HTRANS_IDLE;
         rss_1st_oincr      <= 1'b0;

         rss_2nd_write      <= 1'b0;
         rss_2nd_read       <= 1'b0;
         rss_2nd_push_read  <= 1'b0;
         rss_2nd_otrans     <= `X2H_AHB_HTRANS_IDLE;
         rss_2nd_oburst     <= `X2H_AHB_HBURST_SINGLE;
       end
     else
       begin
         if (~retry_active & my_retry)
           begin
             rss_1st_write      <= dphase_write;
             rss_1st_read       <= dphase_read;
             rss_1st_push_read  <= dphase_push_read;
             rss_1st_otrans     <= dphase_otrans;
             rss_1st_oincr      <= dphase_oincr;

             rss_2nd_write      <= aphase_write;
             rss_2nd_read       <= aphase_read;
             rss_2nd_push_read  <= aphase_push_read;
             rss_2nd_otrans     <= mhtrans;
             rss_2nd_oburst     <= mhburst;
           end
       end


   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       if_retry_state     <= ST_IF_RETRY_IDLE;
     else
       if_retry_state     <= nxt_if_retry_state;

always @(*)

  begin : retry_logic_PROC

    // Set "defaults"

    retry_set_hbusreq_reg     = 1'b0;
    retry_clr_hbusreq_reg     = 1'b0;

    nxt_if_retry_state        = if_retry_state;

    working_retry_trans       = `X2H_AHB_HTRANS_NONSEQ;
    working_retry_burst       = `X2H_AHB_HBURST_SINGLE;

    retry_swap_addr_reg           = 1'b0;

    retry_mhtrans_reg             = `X2H_AHB_HTRANS_IDLE;
    retry_mhburst_reg             = `X2H_AHB_HBURST_SINGLE;
    retry_aphase_write_reg        = 1'b0;
    retry_aphase_read_reg         = 1'b0;
    retry_aphase_push_read_reg    = 1'b0;

    case (if_retry_state)

      // NOTE: the "IDLE" state is now handled as the "default",
      // to avoid getting a warning from DC

      //  ST_IF_RETRY_IDLE :
      //
      //    if (my_retry)
      //      // Note: "my_retry" automatically turns on HBUSREQ
      //      nxt_if_retry_state        = ST_IF_RETRY_1;

      ST_IF_RETRY_1 :

        // Come here after the first clock of a RETRY response.
        // At the same time as HTRANS gets forced to IDLE.
        // Want to put the "RETRY" transfer back into address phase.
        // ASAP. On the next clock if possible, but need bus ownership.

        begin
          // Will for sure be going with a "NONSEQ" on the RETRY, but
          // the burst needs some figuring out.

          working_retry_trans       = `X2H_AHB_HTRANS_NONSEQ;

          if (rss_2nd_otrans == `X2H_AHB_HTRANS_SEQ)

            begin
              // If the 2nd HTRANS was SEQ, this indicates
              // that the first and second transfers
              // were members of a burst.

              if (rss_1st_otrans == `X2H_AHB_HTRANS_NONSEQ)
                // The retry came on the very start of the burst
                // (the nonseq). Can repeat the same burst.
                // If the burst was not an INCR then it was some
                // fixed-length burst, and it's appropriate to
                // drop BUSREQ when it restarts
                begin
                  working_retry_burst       = rss_2nd_oburst;
                  if (rss_2nd_oburst != `X2H_AHB_HBURST_INCR)
                    retry_clr_hbusreq_reg         = 1'b1;
                end

              // Otherwise the retry happened in the middle of
              // a burst, "rebuild" w/ INCR or SINGLEs
              else
                working_retry_burst       = `X2H_AHB_HBURST_INCR;
            end

          else
            // The "rss_2nd_otrans" was not SEQ... so the first
            // and second (if any) transfers weren't members
            // of a burst. If the first one was originally issued as
            // and INCR, do so again, otherwise issue it as a SINGLE.
            if (rss_1st_oincr)
              working_retry_burst       = `X2H_AHB_HBURST_INCR;
            else
              working_retry_burst       = `X2H_AHB_HBURST_SINGLE;

          if (mhready & mhgrant)
            begin
              retry_swap_addr_reg           = 1'b1;

              retry_mhtrans_reg             = working_retry_trans;
              retry_mhburst_reg             = working_retry_burst;
              retry_aphase_write_reg        = rss_1st_write;
              retry_aphase_read_reg         = rss_1st_read;
              retry_aphase_push_read_reg    = rss_1st_push_read;

              if (rss_2nd_write | rss_2nd_read)
                nxt_if_retry_state            = ST_IF_RETRY_2;
              else
                begin
                  nxt_if_retry_state            = ST_IF_RETRY_IDLE;
                  if (dphase_axi_last)
                    retry_clr_hbusreq_reg         = 1'b1;
                end
            end
        end  // "ST_IF_RETRY_1"


      ST_IF_RETRY_2 :

        // OK, got the "RETRY" transfer back into address phase.
        // But, there's another transfer behind it which also has
        // to be reissued. Again, on the next clock if possible,
        // but need bus ownership.

        begin

          if (rss_2nd_otrans == `X2H_AHB_HTRANS_NONSEQ)
            begin
              working_retry_trans       = `X2H_AHB_HTRANS_NONSEQ;
              working_retry_burst       = rss_2nd_oburst;
            end

          else
            begin
              working_retry_burst       = mhburst;
              if (mhburst == `X2H_AHB_HBURST_SINGLE)
                working_retry_trans       = `X2H_AHB_HTRANS_NONSEQ;
              else
                working_retry_trans       = `X2H_AHB_HTRANS_SEQ;
            end

          // If the 2nd thing out is the start of a fixed-length burst,
          // or if it's the "axi_last", schedule a turn-off of BUSREQ
          // (it will only turn off if HREADY and HGRANT are true)
          if (   dphase_axi_last
               | (working_retry_burst == `X2H_AHB_HBURST_INCR4)
               | (working_retry_burst == `X2H_AHB_HBURST_INCR8)
               | (working_retry_burst == `X2H_AHB_HBURST_INCR16) )
            retry_clr_hbusreq_reg         = 1'b1;

          if (mhready)
            begin
              retry_swap_addr_reg           = 1'b1;

              if (mhgrant)
                begin
                  retry_mhtrans_reg             = working_retry_trans;
                  retry_mhburst_reg             = working_retry_burst;
                  retry_aphase_write_reg        = rss_2nd_write;
                  retry_aphase_read_reg         = rss_2nd_read;
                  retry_aphase_push_read_reg    = rss_2nd_push_read;
                  nxt_if_retry_state            = ST_IF_RETRY_IDLE;
                end

              else   // Lost MHGRANT
                     // HTRANS will automatically go to IDLE
                begin
                  retry_set_hbusreq_reg         = 1'b1;
                  nxt_if_retry_state            = ST_IF_RETRY_3;
                end
            end
        end // "ST_IF_RETRY_2"


      ST_IF_RETRY_3 :

        // Wow, something like this could only happen to the AHB master.
        // Had two things to retry, and managed to get the first one out but
        // then lost arb before getting the second one out.
        //
        // Note that the first one is in data phase now and it could get
        // another retry. In this case, go back to RETRY_1.
        //
        // Otherwise, wait until we do get HGRANT and then issue a NONSEQ.
        // If the "rss_2nd_otrans" (original HTRANS) was a NONSEQ, can go
        // with the original burst. Otherwise the original HTRANS must have
        // been a SEQ, we are in some kind of "rebuild" situation. Go with
        // INCR if allowed, otherwise SINGLE.

        begin

          working_retry_trans       = `X2H_AHB_HTRANS_NONSEQ;

          if (rss_2nd_otrans == `X2H_AHB_HTRANS_NONSEQ)
            working_retry_burst       = rss_2nd_oburst;
          else
            working_retry_burst       = `X2H_AHB_HBURST_INCR;

          // If the 2nd thing out is the start of a fixed-length burst,
          // or if it's the "axi_last", schedule a turn-off of BUSREQ
          // (it will only turn off if HREADY and HGRANT are true)
          if (   aphase_axi_last
               | (working_retry_burst == `X2H_AHB_HBURST_INCR4)
               | (working_retry_burst == `X2H_AHB_HBURST_INCR8)
               | (working_retry_burst == `X2H_AHB_HBURST_INCR16) )
            retry_clr_hbusreq_reg         = 1'b1;

          if (my_retry)
            nxt_if_retry_state        = ST_IF_RETRY_1;

          else if (mhready & mhgrant)
            begin
              retry_mhtrans_reg             = working_retry_trans;
              retry_mhburst_reg             = working_retry_burst;
              retry_aphase_write_reg        = rss_2nd_write;
              retry_aphase_read_reg         = rss_2nd_read;
              retry_aphase_push_read_reg    = rss_2nd_push_read;
              nxt_if_retry_state            = ST_IF_RETRY_IDLE;
            end
        end // "ST_IF_RETRY_3"

      default :  // aka "ST_IF_RETRY_IDLE"
        begin
          if (my_retry)
            // Note: "my_retry" automatically turns on HBUSREQ
            nxt_if_retry_state    = ST_IF_RETRY_1;
          else
            nxt_if_retry_state    = ST_IF_RETRY_IDLE;
        end

    endcase
  end  // Of "retry_logic_PROC" logic associated with "RETRY" state machine

  // Should never get into any undefined state
  /* ova
     bind assert_never #(0,1,"OVA ERROR: RETRY SM in undefined state")
                        OVA_check_rtysm (clk, rst_n,
                        (   (if_retry_state != ST_IF_RETRY_IDLE)
                          & (if_retry_state != ST_IF_RETRY_1)
                          & (if_retry_state != ST_IF_RETRY_2)
                          & (if_retry_state != ST_IF_RETRY_3)));
  */






assign if_cgen_wr_err  = dphase_write & (mhresp == `X2H_AHB_RESP_ERROR);


////////////////////////////////////////////////////////
// RDFIFO interface

  assign new_hrdata_int  = rdata_function( hrdata_int, mhrdata,
                                           push_rdfifo, pushed,
                                           dphase_addr[4:0], dphase_size );

  assign new_hrstatus_int  = rresp_function( hrstatus_int, mhresp,
                                             push_rdfifo, pushed );


   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         push_rdfifo   <= 1'b0;
         hrid_int      <= {`X2H_AXI_ID_WIDTH{1'b0}};
         hrdata_int    <= {`X2H_AXI_DATA_WIDTH{1'b0}};
         hrstatus_int  <= 2'b00;
         hrlast_int    <= 1'b0;
         pushed        <= 1'b0;
       end
     else
       begin

         // push_rdfifo loads EVERY CLOCK, but only loads a
         // 1 when a "push_read" completes the data phase
         push_rdfifo     <= dphase_push_read
                            & mhready
                            & (mhresp != `X2H_AHB_RESP_RETRY)
                            & (mhresp != `X2H_AHB_RESP_SPLIT);

         // Data and response ONLY load when a read completes
         // the data phase, but they load on ANY read, not just
         // a "push_read".
         if (dphase_read & mhready)
           begin
             hrid_int      <= dphase_axi_id;
             hrdata_int    <= new_hrdata_int;
             hrstatus_int  <= new_hrstatus_int;
             hrlast_int    <= dphase_axi_last;
           end

         // When stuff gets pushed to the RDFIFO, it's essential to
         // clean out "rdfifo_resp", and seems kind of nice to clean
         // out "hrdata_int". Yet, these only change at all on
         // HREADY cycles. So, if need be, remember that a push
         // happened until the next HREADY cycle comes.
         if (dphase_read & mhready)
           pushed          <= 1'b0;
         else if (push_rdfifo)
           pushed          <= 1'b1;
       end


   // Module output name, per spec...

   assign push_data_int_n    = ~push_rdfifo;


// ASSERTIONS
//
`ifndef SMIC_SYNTHESIS
   // Derive some independent regs to indicate when this AHB
   // master owns the address phase, data phase.

   reg  my_aphase, my_dphase;

   always @(posedge clk or negedge rst_n)
     if ( !rst_n )
       begin
         my_aphase      <= 1'b0;
         my_dphase      <= 1'b0;
       end
     else if (mhready)
       begin
         my_aphase      <= mhgrant_int;
         my_dphase      <= my_aphase;
       end


   // Basic sanity checks of aphase_read/write "action bits" vs bus ownership...
   /* ova
   bind assert_never #(0,1,"OVA ERROR: aphase_write illegally asserted")
                      OVA_check_aw (clk, rst_n,
                      (aphase_write & ~my_aphase));

   bind assert_never #(0,1,"OVA ERROR: aphase_read illegally asserted")
                      OVA_check_ar (clk, rst_n,
                      (aphase_read & ~my_aphase));

   bind assert_never #(0,1,"OVA ERROR: aphase_push_read illegally asserted")
                      OVA_check_apr (clk, rst_n,
                      (aphase_push_read & ~aphase_read));
   */


   // Basic sanity checks of dphase_read/write "action bits" vs bus ownership...
   /* ova
   bind assert_never #(0,1,"OVA ERROR: dphase_write illegally asserted")
                      OVA_check_dw (clk, rst_n,
                      (dphase_write & ~my_dphase));

   bind assert_never #(0,1,"OVA ERROR: dphase_read illegally asserted")
                      OVA_check_dr (clk, rst_n,
                      (dphase_read & ~my_dphase));

   bind assert_never #(0,1,"OVA ERROR: dphase_push_read illegally asserted")
                      OVA_check_dpr (clk, rst_n,
                      (dphase_push_read & ~dphase_read));
   */


   // Never get a RETRY or SPLIT when not expecting it.
   // Only check first cycle of 2-cycle response since that's all
   // "my_retry" is expected to last
   /* ova
   bind assert_never #(0,1,"OVA ERROR: RETRY at unexpected time")
                      OVA_check_rty (clk, rst_n,
                      ((mhresp == `X2H_AHB_RESP_RETRY) & ~mhready
                       & my_dphase & ~my_retry));

   bind assert_never #(0,1,"OVA ERROR: SPLIT at unexpected time")
                      OVA_check_spt (clk, rst_n,
                      ((mhresp == `X2H_AHB_RESP_SPLIT) & ~mhready
                       & my_dphase & ~my_retry));
   */


`endif



function [`X2H_AXI_DATA_WIDTH-1:0] rdata_function;
  input [`X2H_AXI_DATA_WIDTH-1:0] current_rdata_reg;
  input [`X2H_AHB_DATA_WIDTH-1:0] ahb_rdata;
  input push_rdfifo;
  input pushed_rdfifo;
  input [4:0] addr;
  input [2:0] size;

  reg [31:0]  byte_enab;
  reg [255:0] ahb_in_256;
  reg [`X2H_AXI_DATA_WIDTH-1:0] working_reg;
    //leda FM_2_35 off
    //LMD: Use fully assigned variables in the function.
    //LJ: This is not an issue. The implementation is as required.
  integer     i, j;
    //leda FM_2_35 on
  begin




      case (size)
        `X2H_AMBA_SIZE_4BYTE  : byte_enab = 32'h0000_000F;
        `X2H_AMBA_SIZE_2BYTE  : byte_enab = 32'h0000_0003 << addr[1:0];
        default :               byte_enab = 32'h0000_0001 << addr[1:0];
      endcase

    // Repeat AHB RDATA to make 256-bit version
      ahb_in_256 = {(256/`X2H_AHB_DATA_WIDTH){ahb_rdata}};

    // "Normally", retain current values of any bytes not updated.
    working_reg = current_rdata_reg;

    // Update bytes per "byte_enab". If this word is being/has been
    // pushed to the RDFIFO, zero out any bytes that aren't being
    // written

    for (i = 0; i < `X2H_AXI_WSTRB_WIDTH; i = i+1)
      begin
        if (byte_enab[i])
          for (j = 8*i; j < 8*i+8; j = j+1)
            working_reg[j] = ahb_in_256[j];
        else if (push_rdfifo | pushed_rdfifo)
          for (j = 8*i; j < 8*i+8; j = j+1)
            working_reg[j] = 1'b0;
      end

    rdata_function = working_reg;
  end
endfunction


//rresp function definition.
function [1:0] rresp_function;
  input [1:0] old_rresp;
  input [1:0] ahb_hresp;
  input push_rdfifo;
  input pushed_rdfifo;

  begin
    if (ahb_hresp == `X2H_AHB_RESP_ERROR)
      rresp_function = `X2H_AXI_RESP_SLVERR;
    else if (push_rdfifo | pushed_rdfifo)
      rresp_function = `X2H_AXI_RESP_OKAY;
    else
      rresp_function = old_rresp;
  end
endfunction



//next_rd_push function definition.
function nxt_rd_push_function;
  input [4:0] ahb_addr;
  input [2:0] ahb_size;
  input [2:0] axi_size;

  reg [4:0] masked_addr;

  begin
    case (ahb_size)
      `X2H_AMBA_SIZE_1BYTE  :  masked_addr = ahb_addr | 5'b00000;
      `X2H_AMBA_SIZE_2BYTE  :  masked_addr = ahb_addr | 5'b00001;
      `X2H_AMBA_SIZE_4BYTE  :  masked_addr = ahb_addr | 5'b00011;
      `X2H_AMBA_SIZE_8BYTE  :  masked_addr = ahb_addr | 5'b00111;
      `X2H_AMBA_SIZE_16BYTE :  masked_addr = ahb_addr | 5'b01111;
      default :                masked_addr = ahb_addr | 5'b11111;
    endcase

    case (axi_size)
      `X2H_AMBA_SIZE_1BYTE  :  masked_addr = masked_addr | 5'b11111;
      `X2H_AMBA_SIZE_2BYTE  :  masked_addr = masked_addr | 5'b11110;
      `X2H_AMBA_SIZE_4BYTE  :  masked_addr = masked_addr | 5'b11100;
      `X2H_AMBA_SIZE_8BYTE  :  masked_addr = masked_addr | 5'b11000;
      `X2H_AMBA_SIZE_16BYTE :  masked_addr = masked_addr | 5'b10000;
      default :                masked_addr = masked_addr | 5'b00000;
    endcase

    if (masked_addr == 5'b11111)
      nxt_rd_push_function = 1'b1;
    else
      nxt_rd_push_function = 1'b0;
  end
endfunction


endmodule



