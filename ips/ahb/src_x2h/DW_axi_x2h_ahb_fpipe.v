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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_ahb_fpipe.v#6 $ 
//
// -------------------------------------------------------------------------
// Filename    : DW_axi_x2h_ahb_fpipe.v
// 
// Description : AHB FIFO pipeline. OPTIONALLY provides banks of flip-flops
//               to retime info coming from the Command Queue and Write
//               Data buffer.
//
//-----------------------------------------------------------------------------
`include "DW_axi_x2h_cc_constants.v"
module DW_axi_x2h_ahb_fpipe (

// Inputs

                             clk,
                             rst_n,
                             hcmd_queue_wd_int, 
                             hcmd_rdy_int_n,
                             hwword_int, 
                             hwdata_rdy_int_n,
                             pop_cmdq, 
                             pop_wdfifo,
                             // Outputs
                             pop_hcmd_int_n, 
                             pop_wdata_int_n,
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
                             wdfifo_valid
                             );


   input                              clk;
   input                              rst_n;

// Interface to Common CMD Queue

   input   [`X2H_CMD_QUEUE_WIDTH-1:0] hcmd_queue_wd_int;   // Contains several fields

   input                              hcmd_rdy_int_n;      // Low means not empty

   output                             pop_hcmd_int_n;      // Low-true POP


// Interface to Write Data FIFO

   input  [`X2H_AXI_WDFIFO_WIDTH-1:0] hwword_int;          // DATA, WSTRB, LAST

   input                              hwdata_rdy_int_n;    // Low means not empty

   output                             pop_wdata_int_n;     // Low-true POP


// Interface to CGEN module... CMD Queue signals

   output   [`X2H_CMD_ADDR_WIDTH-1:0] cmdq_addr;           // These fields are
   output     [`X2H_AXI_ID_WIDTH-1:0] cmdq_id;             // straight out of the
   output                       [2:0] cmdq_axi_size;       // Command Queue
   output                       [1:0] cmdq_cache;
   output                             cmdq_prot_2;
   output                             cmdq_prot_0;
   output                             cmdq_rw;

                                                           // Processed by FPIPE:

   output                       [2:0] cmdq_try_size;       // Proposed size to
                                                           // read on AHB

   output                       [4:0] cmdq_try_mask;       // Mask to check address
                                                           // OK for size proposed

                                                           // factor

   output                      [11:0] cmdq_wrapmask;       // Mask used for wrapping
                                                           // and spotting wrap/1K
                                                           // boundaries.

   output                      [13:0] cmdq_axibytes;       // Byte count for AXI
                                                           // command

   output                      [13:0] cmdq_axibytes_2b;    // Byte count to wrap
                                                           // or 1K boundary

   output                             cmdq_2b_first;       // This command WILL
                                                           // hit a wrap or 1K
                                                           // boundary

   output          [`X2H_AXI_BLW-1:0] cmdq_frepcount;      // Repeat count for AXI
                                                           // FIXED command

   output                             cmdq_valid;
   input                              pop_cmdq;


// Interface to CGEN module... Write Data FIFO signals

   output   [`X2H_AXI_DATA_WIDTH-1:0] wdfifo_wdata;
   output  [`X2H_AXI_WSTRB_WIDTH-1:0] wdfifo_wstrb;
   output                             wdfifo_wlast;

   output                             wdfifo_valid;
   input                              pop_wdfifo;



   // ALL the outputs are coded as "regs"

   reg                              pop_hcmd_int_n;
   reg                              pop_wdata_int_n;

   reg    [`X2H_CMD_ADDR_WIDTH-1:0] cmdq_addr;
   reg      [`X2H_AXI_ID_WIDTH-1:0] cmdq_id;
   reg                        [2:0] cmdq_axi_size;
   reg                        [1:0] cmdq_cache;
   reg                              cmdq_prot_2;
   reg                              cmdq_prot_0;
   reg                              cmdq_rw;
   reg                        [2:0] cmdq_try_size;
   reg                        [4:0] cmdq_try_mask;
   reg                       [11:0] cmdq_wrapmask;
   reg                       [13:0] cmdq_axibytes;
   reg                       [13:0] cmdq_axibytes_2b;
   reg                              cmdq_2b_first;
   reg           [`X2H_AXI_BLW-1:0] cmdq_frepcount;

   reg                              cmdq_valid;

   reg    [`X2H_AXI_DATA_WIDTH-1:0] wdfifo_wdata;
   reg   [`X2H_AXI_WSTRB_WIDTH-1:0] wdfifo_wstrb;
   reg                              wdfifo_wlast;
   reg                              wdfifo_valid;



   // FLIP-FLOPS (potentially... depends on configuration):

  //leda NTL_CON13A off
  //LMD: non driving internal net
  //LJ: Range 5-6. Bits 5,6 are not used when PASS_LOCK is disabled.

  //leda NTL_CON32 off
  //LMD: Change on net has no effect on any of the outputs
  //LJ: Range 5-6. Bits 5,6 are not used when PASS_LOCK is disabled.
   reg    [`X2H_CMD_QUEUE_WIDTH-1:0] saved_hcmd_wd;
  //leda NTL_CON32 on
  //leda NTL_CON13A on
   reg                               saved_hcmd_rdy;
   reg                               pop_hcmd_pipeone_q;

   reg     [`X2H_CMD_ADDR_WIDTH-1:0] ff_addr;
   reg       [`X2H_AXI_ID_WIDTH-1:0] ff_id;
   reg                         [2:0] ff_axi_size;
   reg                         [1:0] ff_cache;
   reg                               ff_prot_2;
   reg                               ff_prot_0;
   reg                               ff_rw;
   reg                         [2:0] ff_try_ahb_size;
   reg                         [4:0] ff_try_ahb_mask;
   reg                        [11:0] ff_wrapmask;
   reg                        [13:0] ff_axibytes;
   reg                        [13:0] ff_axibytes_2b;
   reg                               ff_2b_first;
   reg            [`X2H_AXI_BLW-1:0] ff_frepcount;

   reg                               ff_cmdq_valid;

   reg   [`X2H_AXI_WDFIFO_WIDTH-1:0] ff_hwword;
   reg                               ff_wdfifo_valid;

   // Internal signals NOT flip-flops, coded as "regs":

  //leda NTL_CON13A off
  //LMD: non driving internal net
  //LJ: Range 5-6. Bits 5,6 are not used when PASS_LOCK is disabled.
   reg  [`X2H_CMD_QUEUE_WIDTH-1:0] hcmd_wd_pipeone;
  //leda NTL_CON13A on
   reg                             hcmd_pipeone_rdy;
   reg                             pop_hcmd_pipeone;
   reg                             pipeone_use_saved;

   reg   [`X2H_CMD_ADDR_WIDTH-1:0] raw_addr;
   reg                       [2:0] raw_size;
   reg          [`X2H_AXI_BLW-1:0] raw_frepcount;
   reg          [`X2H_AXI_BLW-1:0] raw_len;
   reg                      [12:0] blen;
   reg                       [2:0] try_ahb_size;
   reg                       [4:0] try_ahb_mask;
   reg                      [11:0] wrapmask;
   reg                      [13:0] blen_2b;
   reg                             blen_2b_is_less;
   reg                      [13:0] blen_plus_1;
   reg                      [13:0] blen_2b_plus_1;






   // ==========================================================================
   // Here is a first stage of pipelining.
   //
   // The purpose of this is to pass the pop_cmdq signal through a flip-flop
   // before sending it to the Command Queue (because, it's late from the CGEN)
   //use of blocking assignments means signal is assigned before it is read
   always @(*)

     begin:S_HCMD_PROC
           // This signal tells what to do in THIS clock... either
           // pass through a new value from the CMD Queue, or use
           // the value from the "saved_xxx" flip-flops

           pipeone_use_saved = saved_hcmd_rdy & (~pop_hcmd_pipeone_q);

           if (pipeone_use_saved)
             begin
               hcmd_wd_pipeone   = saved_hcmd_wd;
               hcmd_pipeone_rdy  = saved_hcmd_rdy;
             end
           else
             begin
               hcmd_wd_pipeone   = hcmd_queue_wd_int;
               hcmd_pipeone_rdy  = ~hcmd_rdy_int_n;
             end

           // This is the (negative-true) POP signal going to the
           // Command Queue. Assert it if the Command Queue output is
           // valid but "saved_hcmd_rdy" is not (yet) set. Later, when
           // the pop signals come from the rest of the AHB section,
           // send the registered version to the Command Queue, but
           // only if its output is still valid.

           pop_hcmd_int_n = ~(   (~hcmd_rdy_int_n) & (~saved_hcmd_rdy)
                               | pop_hcmd_pipeone_q & (~hcmd_rdy_int_n));

     end

   // Flip-flops associated with first pipeline stage
   always @(posedge clk or negedge rst_n)
   begin:S_SAVED_HCMD_PROC
     if ( !rst_n )
       begin
         saved_hcmd_wd      <= {`X2H_CMD_QUEUE_WIDTH{1'b0}};
         saved_hcmd_rdy     <= 1'b0;
         pop_hcmd_pipeone_q <= 1'b0;
       end
     else
      // Never going to load anything into these FFs if not in
      // "pipeline" mode... this should make them disappear
      // after synthesis

       begin
         if (~pipeone_use_saved)
           begin
             saved_hcmd_wd      <= hcmd_queue_wd_int;
             saved_hcmd_rdy     <= ~hcmd_rdy_int_n;
           end
         pop_hcmd_pipeone_q <= pop_hcmd_pipeone;
       end
   end  // always block

   // ==========================================================================
   // Next, do some pre-processing of the command

   always @(*)
     begin:HCMD_POST_PROC

       // Pull address and size fields out of CMDQ word

       raw_addr = hcmd_wd_pipeone[`X2H_CMD_QUEUE_WIDTH-1:12+`X2H_AXI_BLW+`X2H_AXI_ID_WIDTH];
       raw_size = hcmd_wd_pipeone[11:9];

       // According to "burst type" from CMDQ word, steer "len" from
       // CMDQ word into either a "len" or a "fixed repeat count"

       if ( hcmd_wd_pipeone[8:7] == `X2H_AXI_BURST_FIXED )
         begin
           raw_frepcount = hcmd_wd_pipeone[`X2H_CMD_QUEUE_WIDTH-(`X2H_CMD_ADDR_WIDTH+`X2H_AXI_ID_WIDTH+1):12];
           raw_len       = {`X2H_AXI_BLW{1'b0}};
         end
       else
         begin
           raw_len       = hcmd_wd_pipeone[`X2H_CMD_QUEUE_WIDTH-(`X2H_CMD_ADDR_WIDTH+`X2H_AXI_ID_WIDTH+1):12];
           raw_frepcount = {`X2H_AXI_BLW{1'b0}};
         end


       if ((`X2H_AXI_DATA_WIDTH > 128) & (raw_size == `X2H_AMBA_SIZE_32BYTE))
         begin
           blen = {raw_len, ~raw_addr[4:0]};

               try_ahb_size = `X2H_AMBA_SIZE_4BYTE;
               try_ahb_mask = 5'b00011;

         end

       else if ((`X2H_AXI_DATA_WIDTH > 64) & (raw_size == `X2H_AMBA_SIZE_16BYTE))
         begin
           blen = {1'b0, raw_len, ~raw_addr[3:0]};

               try_ahb_size = `X2H_AMBA_SIZE_4BYTE;
               try_ahb_mask = 5'b00011;

         end

       else if ((`X2H_AXI_DATA_WIDTH > 32) & (raw_size == `X2H_AMBA_SIZE_8BYTE))
         begin
           blen = {2'b0, raw_len, ~raw_addr[2:0]};

               try_ahb_size = `X2H_AMBA_SIZE_4BYTE;
               try_ahb_mask = 5'b00011;

         end

       else if (raw_size == `X2H_AMBA_SIZE_4BYTE)
         begin
           blen = {3'b0, raw_len, ~raw_addr[1:0]};

           try_ahb_size = `X2H_AMBA_SIZE_4BYTE;
           try_ahb_mask = 5'b00011;
         end

       else if (raw_size == `X2H_AMBA_SIZE_2BYTE)
         begin
           blen = {4'b0, raw_len, ~raw_addr[0]};

           try_ahb_size = `X2H_AMBA_SIZE_2BYTE;
           try_ahb_mask = 5'b00001;
         end

       else
         begin
           blen = {5'b0, raw_len};

           try_ahb_size = `X2H_AMBA_SIZE_1BYTE;
           try_ahb_mask = 5'b00000;
         end


       wrapmask  = wrapmask_function( hcmd_wd_pipeone[8:7],
                                      {{(`X2H_AXI_BLW - 4){1'b0}}, hcmd_wd_pipeone[15:12]},
                                      hcmd_wd_pipeone[11:9] );


       //leda NTL_CON16 off
       //LMD: Nets or cell pins should not be tied to logic 0 / logic 1
       //LJ: MS 4 bits are tied to zeros to retain the bit width.
       blen_2b = {4'h0, wrapmask[9:0] & (~raw_addr[9:0])};
       //leda NTL_CON16 on

       if (blen_2b < {1'b0, blen})
         blen_2b_is_less  = 1'b1;
       else
         blen_2b_is_less  = 1'b0;

       // The biggest possible "blen_plus_1" is 512 (resulting
       // from a 16-beat, 32-byte-wide AXI transfer). It takes
       // 10 bits to represent this.
       //
       // There could be more than 512 bytes to the next 1K boundary.
       // If there is, it doesn't matter since the end of transfer
       // will be reached first. Therefore, "blen_2b_plus_1" is also
       // taken out as a 10-bit value.

       //leda W484 off
       //LMD:Possible loss of carry/borrow in addition/subtraction
       //LJ: Overflow will never happen.
       blen_plus_1        = {1'b0, blen} + 1;
       blen_2b_plus_1     = blen_2b + 1;
       //leda W484 on

     end



   // ==========================================================================
   // Now there is another stage of pipelining. The purpose of this
   // is to re-register the command info (including the results of the
   // pre-processing done above) before passing it to the CGEN

   always @(*)

     begin:CMD_Q_PROC

       cmdq_addr          = ff_addr;
       cmdq_id            = ff_id;
       cmdq_axi_size      = ff_axi_size;
       cmdq_cache         = ff_cache;
       cmdq_prot_2        = ff_prot_2;
       cmdq_prot_0        = ff_prot_0;
       cmdq_rw            = ff_rw;
       cmdq_try_size      = ff_try_ahb_size;
       cmdq_try_mask      = ff_try_ahb_mask;
       cmdq_wrapmask      = ff_wrapmask;
       cmdq_axibytes      = ff_axibytes;
       cmdq_axibytes_2b   = ff_axibytes_2b;
       cmdq_2b_first      = ff_2b_first;
       cmdq_frepcount     = ff_frepcount;

       cmdq_valid         = ff_cmdq_valid;

       // When something first shows up in the Command Queue,
       // "pop" it as it loads into the flip-flops. Then, when
       // the CGEN pops it out of the flip-flops, also pass this
       // pop to the Command Queue, but only if it's still 
       // indicating its ouput is valid

       pop_hcmd_pipeone   = hcmd_pipeone_rdy & (~ff_cmdq_valid | pop_cmdq);

       // WDFIFO signal pipelining works the same way...

       wdfifo_wdata       = ff_hwword[`X2H_AXI_WDFIFO_WIDTH-1:`X2H_AXI_WSTRB_WIDTH+1];
       wdfifo_wstrb       = ff_hwword[`X2H_AXI_WSTRB_WIDTH:1];
       wdfifo_wlast       = ff_hwword[0];

       wdfifo_valid       = ff_wdfifo_valid;

       pop_wdata_int_n    = ~( ~hwdata_rdy_int_n & (~ff_wdfifo_valid | pop_wdfifo) );


     end

   always @(posedge clk or negedge rst_n)
   begin:FF_SIG_PROC
     if ( !rst_n )
       begin
         ff_addr            <= {`X2H_CMD_ADDR_WIDTH{1'b0}};
         ff_id              <= {`X2H_AXI_ID_WIDTH{1'b0}};
         ff_axi_size        <= 3'b000;
         ff_cache           <= 2'b0;
         ff_prot_2          <= 1'b0;
         ff_prot_0          <= 1'b0;
         ff_rw              <= 1'b0;
         ff_try_ahb_size    <= 3'b000;
         ff_try_ahb_mask    <= 5'b00000;
         ff_wrapmask        <= 12'h000;
         ff_axibytes        <= 14'h0000;
         ff_axibytes_2b     <= 14'h0000;
         ff_2b_first        <= 1'b0;
         ff_frepcount       <= {`X2H_AXI_BLW{1'b0}};
         ff_cmdq_valid      <= 1'b0;

         ff_hwword          <= {`X2H_AXI_WDFIFO_WIDTH{1'b0}};
         ff_wdfifo_valid    <= 1'b0;
       end
     else
       begin

       // After that, load the CMD Queue pipelining flip-flops
       // anytime the CGEN takes a command (pop_cmdq), and
       // also when something is "ready" from the CMD Queue but the
       // "ff_cmdq_valid" does not yet reflect it.

         if (pop_cmdq | hcmd_pipeone_rdy & (~ff_cmdq_valid))

           begin
             ff_addr           <= raw_addr;
             ff_id             <= hcmd_wd_pipeone[`X2H_CMD_QUEUE_WIDTH-(`X2H_CMD_ADDR_WIDTH+1):12+`X2H_AXI_BLW];
             ff_axi_size       <= raw_size;
             ff_cache          <= hcmd_wd_pipeone[4:3];
             ff_prot_2         <= hcmd_wd_pipeone[2];
             ff_prot_0         <= hcmd_wd_pipeone[1];
             ff_rw             <= hcmd_wd_pipeone[0];
             ff_try_ahb_size   <= try_ahb_size;
             ff_try_ahb_mask   <= try_ahb_mask;
             ff_wrapmask       <= wrapmask;
             ff_axibytes       <= blen_plus_1;
             ff_axibytes_2b    <= blen_2b_plus_1;
             ff_2b_first       <= blen_2b_is_less;
             ff_frepcount      <= raw_frepcount;
             ff_cmdq_valid     <= hcmd_pipeone_rdy;
           end

       // Similarly, load the write data pipelining flip-flops anytime
       // the CGEN pops a line of write data, or when the WDFIFO
       // is "ready" but "ff_wdfifo_valid" shows as false.

         if (pop_wdfifo | (~hwdata_rdy_int_n) & (~ff_wdfifo_valid))

           begin
             ff_hwword          <= hwword_int;
             ff_wdfifo_valid    <= ~hwdata_rdy_int_n;
           end

       end
   end //always block
//wrapmask function definition.
function [11:0] wrapmask_function;

  input [1:0] axi_burst_type;
  input [`X2H_AXI_BLW-1:0] axi_burst_len;
  input [2:0] axi_burst_size;

    //leda FM_2_35 off
    //LMD: Use fully assigned variables in the function.
    //LJ: This is not an issue. The implementation is as required.
  reg   [8:0] slider;
    //leda FM_2_35 on
  reg   [8:0] buildup;

  // The "wrapmask" looks something like, for example:
  // 0000_0000_1111 if the WRAP boundary is 16 bytes
  // 0000_0000_0111 if the WRAP boundary is 8 bytes
  //
  // 0000_0000_0001 is the smallest... a 2 beat x 1 byte WRAP
  //
  // 0001_1111_1111 is the biggest possible WRAP, that is a 512-byte
  //                wrap boundary (16 beats x 32 bytes)
  // 
  // Because it's convenient where the wrapmask is used, a wrapmask
  // of 1111_1111_1111 is returned when there is to be no wrapping

  begin
    if ( axi_burst_type != `X2H_AXI_BURST_WRAP )
      wrapmask_function = 12'b1111_1111_1111;
    else
      begin
        // AXI burst type is wrap.
        // Note that LEN is required to be 1, 3, 7, or F for AXI WRAP bursts

        slider = {{(9-`X2H_AXI_BLW){1'b0}}, axi_burst_len} << axi_burst_size;
        buildup = 9'h000;

        buildup[8] =  slider[8];
        buildup[7] = |slider[8:7];
        buildup[6] = |slider[8:6];
        buildup[5] = |slider[8:5];
        buildup[4] = |slider[8:4];
        buildup[3] = |slider[8:3];
        buildup[2] = |slider[8:2];
        buildup[1] = |slider[8:1];
        buildup[0] = 1'b1;
        
        wrapmask_function = { 3'b000, buildup };

      end
  end
endfunction



endmodule




