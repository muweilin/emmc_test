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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_ahb_cgen_logic.v#6 $ 
//
// -------------------------------------------------------------------------
// Filename    : DW_axi_x2h_ahb_cgen_logic.v
// 
// Description : This is a submodule of the "CGEN". The logic for figuring
//               out what AHB transfer to do next is here. This is a purely
//               combinatorial submodule.
//
//               The reason this got split off from the "CGEN" is to allow
//               the logic in here to be "flattened" during synthesis.
//-----------------------------------------------------------------------------
`include "DW_axi_x2h_cc_constants.v"
module DW_axi_x2h_ahb_cgen_logic (

// Inputs:

   to_process_addr,
                                  to_process_axibytes,
                                  to_process_axibytes_2b,
                                  to_process_2b_first,
                                  to_process_axi_size,
                                  to_process_try_size,
                                  to_process_try_mask,
                                  wdfifo_wstrb,
                                  // Outputs:
                                  wstrb_1,
                                  wr_ahb_size,
                                  wr_ahb_xbytes,
                                  rd_ahb_size,
                                  rd_ahb_bcount,
                                  rd_ahb_xbytes
                                  );


  input                        [8:0] to_process_addr;
  input                       [13:0] to_process_axibytes;
  input                       [13:0] to_process_axibytes_2b;
  input                              to_process_2b_first;
  input                        [2:0] to_process_axi_size;
  input                        [2:0] to_process_try_size;
  input                        [4:0] to_process_try_mask;
  input   [`X2H_AXI_WSTRB_WIDTH-1:0] wdfifo_wstrb;
    
  output                             wstrb_1;
  output                       [2:0] wr_ahb_size;
  output                       [5:0] wr_ahb_xbytes;

  output                       [2:0] rd_ahb_size;
  output                       [4:1] rd_ahb_bcount;
  output                       [9:0] rd_ahb_xbytes;


  // NO FLIP-FLOPS HERE
  // But, all the outputs, plus a couple of internal signals,
  // are coded as "regs"

  reg            wstrb_1;
  reg      [2:0] wr_ahb_size;
  reg      [5:0] wr_ahb_xbytes;

  reg      [2:0] rd_ahb_size;
  wire     [4:1] rd_ahb_bcount;
  reg      [9:0] rd_ahb_xbytes;
  //leda NTL_CON13A off
  //LMD: non driving internal net Range
  //LJ: The signal LSbit of this signal is not used. Functionally it is not required.
  reg      [4:0] rd_ahb_bcount_int;
  //leda NTL_CON13A on

  assign rd_ahb_bcount = rd_ahb_bcount_int[4:1];

  // THIS BLOCK figures out what to do assuming the transfer is a write.
  // The concept of "what to do" basically means figuring out what SIZE
  // to process, and whether to process it sparse or not. There is no
  // "bcount" calculated here since writes are always processed 1 beat
  // at a time (so no need for the "burst count")

  always @(*)

    begin:WR_AHB_SIZE_PROC
   
      // The "CHECK_WSTRB_FUNCTION" does 2 things:
      //
      // First, whether the WSTRB for the NEXT BYTE OUT is 0 or 1
      // is returned to "wsrtb_1".
      //
      // Second, the function returns a how-many-bytes-can-be-processed
      // count ("wr_ahb_xbytes"), representing how many WSTRBs in a row
      // have the same value (all 0s or all 1's), and also reflecting the
      // address alignment. This is how many bytes can be written or skipped.
      //
      // If "wstrb_1" is true, indicating that the current bytes are to be
      // written to AHB, then the "wr_ahb_xbytes" returend is automatically
      // downsized to AHB if necessary.

      { wstrb_1, wr_ahb_xbytes } = check_wstrb_function( to_process_addr[4:0],
                                                         wdfifo_wstrb,
                                                         to_process_axi_size );

       // Had the function return "wr_ahb_xbytes" because this is needed
       // as early as possible. Here the less-crucial SIZE code for the
       // AHB bus is derived from wr_ahb_xbytes
       //
       // WR_AHB_XBYTES  --> WR_AHB_SIZE
       //       00_0001       000 (1 byte)
       //       00_0010       001 (2 byte)
       //       00_0100       010 (4 byte)
       //       00_1000       011 (8 byte)
       //       01_0000       100 (16 byte)
       //       10_0000       101 (32 byte)

       wr_ahb_size[2] = wr_ahb_xbytes[5] | wr_ahb_xbytes[4];
       wr_ahb_size[1] = wr_ahb_xbytes[3] | wr_ahb_xbytes[2];
       wr_ahb_size[0] = wr_ahb_xbytes[5] | wr_ahb_xbytes[3] | wr_ahb_xbytes[1];

    end


  // IN PARALLEL, THIS BLOCK figures out what to do assuming the transfer
  // is a read. Again, "what to do" means what SIZE of read to do on AHB,
  // and for reads also involves deciding whether to do an INCR4, INCR8, or
  // INCR16 (or just to read beat-by-beat).

  always @(*)

    begin: RD_AHB_SIZE_PROC
       // Would like to do a read of the "try_size", but got to make sure
       // the address is aligned. "try_mask" helps do this. For example,
       // try mask is 00111 if try_size is 8-byte transfer, 00011 if try_size
       // is 4-byte transfer. Address is aligned for try_size if address bits
       // corresponding to by 1s in try_size are ALL ZERO

       if (|(to_process_addr[4:0] & to_process_try_mask))
         begin
           // Found some 1s in low address bits. The address is unaligned.
           // Do a 1-beat read, of the biggest size possible.

           rd_ahb_bcount_int   = 5'd1;

           if      (to_process_addr[0])
             begin
               rd_ahb_size   = `X2H_AMBA_SIZE_1BYTE;
               rd_ahb_xbytes  = 10'd1;
             end
           else if (to_process_addr[1])
             begin
               rd_ahb_size   = `X2H_AMBA_SIZE_2BYTE;
               rd_ahb_xbytes  = 10'd2;
             end
           else if (to_process_addr[2])
             begin
               rd_ahb_size   = `X2H_AMBA_SIZE_4BYTE;
               rd_ahb_xbytes  = 10'd4;
             end
           else if (to_process_addr[3])
             begin
               rd_ahb_size   = `X2H_AMBA_SIZE_8BYTE;
               rd_ahb_xbytes  = 10'd8;
             end
           else
             begin
               rd_ahb_size   = `X2H_AMBA_SIZE_16BYTE;
               rd_ahb_xbytes  = 10'd16;
             end
         end

       else 
         begin

           // current address IS aligned to "to_process_try_size", can
           // actually do transfers of this wonderful size...

           rd_ahb_size  = to_process_try_size;

           // ... and even think about doing BURSTS. There's quite a lot
           // of work done by the "CHOOSE_BCOUNT_FUNCTION" to pick the
           // best AHB burst to do at the current time.

           rd_ahb_bcount_int = choose_bcount_function(to_process_axibytes,
                                                  to_process_axibytes_2b,
                                                  to_process_2b_first,
                                                  to_process_addr[8:0],
                                                  to_process_try_size, 2'b00);

           // Last generate RD_AHB_XBYTES.

           if ((`X2H_AHB_DATA_WIDTH > 128) & (to_process_try_size == `X2H_AMBA_SIZE_32BYTE))
             rd_ahb_xbytes  = ({5'b00000, rd_ahb_bcount_int} << 5);
           else if ((`X2H_AHB_DATA_WIDTH > 64) & (to_process_try_size == `X2H_AMBA_SIZE_16BYTE))
             rd_ahb_xbytes  = ({5'b00000, rd_ahb_bcount_int} << 4);
           else if ((`X2H_AHB_DATA_WIDTH > 32) & (to_process_try_size == `X2H_AMBA_SIZE_8BYTE))
             rd_ahb_xbytes  = ({5'b00000, rd_ahb_bcount_int} << 3);
           else if (to_process_try_size[1])   // 4-byte transfers 
             rd_ahb_xbytes  = ({5'b00000, rd_ahb_bcount_int} << 2);
           else if (to_process_try_size[0])   // 2-byte transfers
             rd_ahb_xbytes  = ({5'b00000, rd_ahb_bcount_int} << 1);
           else                               // 1-byte transfers
             rd_ahb_xbytes  = {5'b00000, rd_ahb_bcount_int};
         end

    end




// Analyzes WSTRB. Sees if next-up WSTRB is 0 or 1, then sees
// how many in a row match that.
function [6:0] check_wstrb_function;

  input [4:0] start_address;
  input [`X2H_AXI_WSTRB_WIDTH-1:0] wstrb;
  input [2:0] axi_size;

  reg   [31:0] shifted_wstrb;
  reg   [5:0]  write_xbytes;
  begin

      shifted_wstrb = {{(32-`X2H_AXI_WSTRB_WIDTH){1'b0}}, wstrb} >> start_address[1:0];

    write_xbytes = 6'd1;
    // GOT to be good for at least 1 byte.
    //
    // But, if the "axi_size" was more than 1 byte,
    // and the start_address is aligned, and the
    // "shifted_wstrb" has either 2 ones or 2 zeroes
    // in a row, can do a 2-byter.
    //
    // And if you can do a 2-byter, maybe you can do
    // a 4-byter.
    //
    // And if you can do a 4-byter, maybe you can do
    // a 8-byter. Etc. Basically work in as far as you can.
    //
    // This is written to only test for AXI transfers up to
    // the width of the AXI data bus. So, if `X2H_AXI_DATA_WIDTH
    // is not terribly wide some of the farther-in clauses
    // become "if (0)" type situations, which the synthesis tool
    // should be able to disregard.
    //
    // Also, this will only return a size wider than the AHB bus
    // is configured if "shifted_wstrb[0]" is ZERO (which means
    // the next-out data is sparse). Thus the size returned is
    // automatically downsized to the AHB bus size, but only if
    // it needs to be.

    if (   (axi_size > `X2H_AMBA_SIZE_1BYTE)
         & (start_address[0] == 1'b0)
         & (shifted_wstrb[1] == shifted_wstrb[0]) )
      begin
        write_xbytes = 6'd2;
        if (   (axi_size > `X2H_AMBA_SIZE_2BYTE)
             & (start_address[1]   == 1'b0)
             & (shifted_wstrb[3:2] == shifted_wstrb[1:0]) )
          begin
            write_xbytes = 6'd4;
            if (    (`X2H_AXI_DATA_WIDTH > 32)
                 & ((`X2H_AHB_DATA_WIDTH > 32) | (~shifted_wstrb[0]))
                 & (axi_size > `X2H_AMBA_SIZE_4BYTE)
                 & (start_address[2]   == 1'b0)
                 & (shifted_wstrb[7:4] == shifted_wstrb[3:0]) )
              begin
                write_xbytes = 6'd8;
                if (    (`X2H_AXI_DATA_WIDTH > 64)
                     & ((`X2H_AHB_DATA_WIDTH > 64) | (~shifted_wstrb[0]))
                     & (axi_size > `X2H_AMBA_SIZE_8BYTE)
                     & (start_address[3]    == 1'b0)
                     & (shifted_wstrb[15:8] == shifted_wstrb[7:0]) )
                  begin
                    write_xbytes = 6'd16;
                    if (    (`X2H_AXI_DATA_WIDTH > 128)
                         & ((`X2H_AHB_DATA_WIDTH > 128) | (~shifted_wstrb[0]))
                         & (axi_size > `X2H_AMBA_SIZE_16BYTE)
                         & (start_address[4]     == 1'b0)
                         & (shifted_wstrb[31:16] == shifted_wstrb[15:0]) )
                      begin
                        write_xbytes = 6'd32;
                      end
                  end
              end
          end
      end

    // This function returns two things glommed together. First, a 1-bit
    // indication of whether "1" or "0" WSTRB were found. Then, a 6-bit
    // "byte count" indicating how many bytes can be processed together
    // (meaning how many have the same WSTRB value, also taking the address
    // alignment and AHB size into account)

    check_wstrb_function = { shifted_wstrb[0], write_xbytes };

  end
endfunction




   // Figure out how long a burst to do on AHB (16, 8, 4, or 1)
   // ONLY used for reads, ONLY used when address is aligned to the
   // desired transfer size.
function [4:0] choose_bcount_function;

   input [13:0] to_process_axibytes;
   input [13:0] to_process_axibytes_2b;
   input        to_process_2b_first;
   input  [8:0] to_process_addr;
   input  [2:0] to_process_try_size;
   input  [1:0] to_process_ds_factor_int;


   reg   [13:0] byte_count;
   reg   [13:0] transfer_count;
   reg    [3:0] shifted_address;

   reg          burst16_ok;
   reg          burst8_ok;
   reg          burst4_ok;

   reg          need_16;
   reg          need_8;
   reg          need_4;
   reg          need_2;
   reg          need_1;

   reg          align_16;
   reg          align_8;
   reg          align_4;
   reg          align_2;


   begin

     // Step 1: select either the byte count to complete the transfer, or
     //         the byte count to reach a wrap or 1K boundary.

     if (to_process_2b_first)
       byte_count = to_process_axibytes_2b;
     else
       byte_count = to_process_axibytes;


     // Step 2: shift the selected byte count to the right to figure
     //         out how many transfers of the "try_size" would be needed
     //         to transfer that many bytes. Note that: once a transfer
     //         gets aligned to the "try_size", it must be true that the
     //         bits of the byte_count getting shifter away are all zeroes.
     //         This is due to the nature of AXI reads which may start
     //         unaligned but always end on a boundary of the transfer size.
     //
     //         ALSO here, a shifted_address is created. This is used below
     //         to judge how the current address is aligned to MULTIPLES of
     //         the "try_size"

     if ((`X2H_AHB_DATA_WIDTH > 128) & (to_process_try_size == `X2H_AMBA_SIZE_32BYTE))
       begin
         transfer_count  = {5'b0, byte_count[13:5]};
         shifted_address = to_process_addr[8:5];
       end
     else if ((`X2H_AHB_DATA_WIDTH > 64) & (to_process_try_size == `X2H_AMBA_SIZE_16BYTE))
       begin
         transfer_count  = {4'b0, byte_count[13:4]};
         shifted_address = to_process_addr[7:4];
       end
     else if ((`X2H_AHB_DATA_WIDTH > 32) & (to_process_try_size == `X2H_AMBA_SIZE_8BYTE))
       begin
         transfer_count  = {3'b0, byte_count[13:3]};
         shifted_address = to_process_addr[6:3];
       end
     else if (to_process_try_size[1])   // must be 4-byte
       begin
         transfer_count  = {2'b0, byte_count[13:2]};
         shifted_address = to_process_addr[5:2];
       end
     else if (to_process_try_size[0])   // must be 2-byte
       begin
         transfer_count  = {1'b0, byte_count[13:1]};
         shifted_address = to_process_addr[4:1];
       end
     else
       begin
         transfer_count  = byte_count[13:0];
         shifted_address = to_process_addr[3:0];
       end


     // Step 3: figure out what length bursts are allowable, based on
     //         the configured depth of the RDFIFO (the configured
     //         depth, not the current space available!!) and
     //         the "downsize factor" of the current transfer.
     //
     //         For bursts of 16 and 8, do NOT allow them if the RDFIFO
     //         is exactly deep enough to hold one burst. Otherwise the
     //         RDFIFO will have to drain completely between bursts; it
     //         won't "stream". So, if the RDFIFO is exactly deep enough
     //         to hold a burst of 8, better to use bursts of 4 instead.
     //
     //         But, allow bursts of 4 even if the RDFIFO can only hold
     //         exactly one, because the next step down is to SINGLEs
     //         and/or undefined-length INCRs





       begin   // No DOWNSHIFT (1:1)
         burst16_ok  = (`X2H_READ_BUFFER_DEPTH > 16);
         burst8_ok   = (`X2H_READ_BUFFER_DEPTH > 8);
         burst4_ok   = (`X2H_READ_BUFFER_DEPTH > 3);
       end


     // Step 4: derive all kinds of temporary variables to indicate what
     //         AHB transfers will eventually be needed to work off the
     //         current "transfer_count", and also how the SHIFTED_address
     //         is aligned

     need_16  =  |transfer_count[13:4];
     need_8   =  transfer_count[3] | (need_16 & (~burst16_ok));
     need_4   =  transfer_count[2] | (need_8  & (~burst8_ok));
     need_2   =  transfer_count[1] | (need_4  & (~burst4_ok));
     need_1   =  transfer_count[0];

     align_16 = ~|shifted_address[3:0];
     align_8  = ~|shifted_address[2:0];
     align_4  = ~|shifted_address[1:0];
     align_2  = ~shifted_address[0];


     // Step 5: considering what AHB transfers will eventually be
     //         needed, and the current alignment, try to issue the AHB
     //         bursts in a way that keeps them as well-aligned as possible.
     //
     //         For example, if a 16-burst and 2 singles are needed,
     //         could either do
     //         a) 16-burst, single, single
     //         b) single, 16-burst, single
     //         c) single, single, 16-burst

     if ( need_16 & burst16_ok
          & (   align_16
              | align_8 & (~need_8)
              | align_4 & (~need_8) & (~need_4)
              | align_2 & (~need_8) & (~need_4) & (~need_2)
              |           (~need_8) & (~need_4) & (~need_2) & (~need_1)))

       choose_bcount_function = 5'd16;

     else if ( need_8 & burst8_ok
               & (   align_8
                   | align_4 & (~need_4)
                   | align_2 & (~need_4) & (~need_2)
                   |           (~need_4) & (~need_2) & (~need_1)))

       choose_bcount_function = 5'd8;

     else if ( need_4 & burst4_ok
               & (   align_4
                   | align_2 & (~need_2)
                   |           (~need_2) & (~need_1)))

       choose_bcount_function = 5'd4;

     else

       choose_bcount_function = 5'd1;

   end
endfunction


endmodule



