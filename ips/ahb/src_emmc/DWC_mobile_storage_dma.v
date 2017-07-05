//  ------------------------------------------------------------------------
//
//                    (C) COPYRIGHT 2005 - 2013 SYNOPSYS, INC.
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

//--                     
// Release version :  2.70a
// Date             :        $Date: 2012/03/21 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_dma.v#19 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_dma.v
// Description : DWC_mobile_storage DMA Controller Unit. This unit handles all the 
//               controls between the core and the DW-DMA and the GE-DMA.
//               The DMA data path is implemented in the BIU unit. In addition, 
//               DMA mode, it delays the data-transfer-done interrupt till 
//               all the DMA cycles get completed.   
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_dma(
  /*AUTOARG*/
  // Outputs
  dw_dma_req, dw_dma_single, dw_dma_write, dw_dma_card_num, 
  ge_dma_req, ge_dma_done, ge_dma_write, ge_dma_card_num, 
  ge_dma_push, ge_dma_pop, ge_dma_addr0, data_trans_done, 
  // Inputs
  clk, reset_n, ciu_reset, dma_reset, dw_dma_ack, ge_dma_ack, 
  dma_enabled, greater_than, less_or_equal, almost_empty, 
  almost_full, empty, full, cmd_taken, b2c_cmd_control, count, 
  trans_fifo_cnt, b2c_byte_count, ciu_data_trans_done, resp_timeout,

  `ifdef INTERNAL_DMAC_YES 

  use_internal_dmac,

  `endif

  dw_dma_trans_size
  );


  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  // Host Clock and Reset
  input                        clk;             // System Clock
  input                        reset_n;         // System Reset - Active Low
  input                        ciu_reset;       // CIU Reset
  input                        dma_reset;       // Card Doamin Reset

  // DW-DMA
  input                        dw_dma_ack;      // DW-DMA Ack
  output                       dw_dma_req;      // DW-DMA Request
  output                       dw_dma_single;   // DW-DMA Single Request 
  output                       dw_dma_write;    // DW-DMA Write to memory
  output                 [4:0] dw_dma_card_num; // DW-DMA Current Card In Use

  // Generic-DMA
  input                        ge_dma_ack;      // GE-DMA Ack
  output                       ge_dma_req;      // GE-DMA Request
  output                       ge_dma_done;     // GE-DMA Transfer Done
  output                       ge_dma_write;    // DW-DMA Write to memory
  output                 [4:0] ge_dma_card_num; // GE-DMA Current Card In Use

  // To BIU
  output                       ge_dma_push;     // GE-DMA FIFO Push
  output                       ge_dma_pop;      // GE-DMA FIFO Pop
  output                       ge_dma_addr0;    // GE-DMA Address0


  // Misc.
  output                       data_trans_done; // Data Transfer Done
  input                        dma_enabled;     // DMA Enabled
  input                        greater_than;    // FIFO greater_than Flag
  input                        less_or_equal;   // FIFO less_or_equal Flag
  input                        almost_empty;    // FIFO almost_empty Flag
  input                        almost_full;     // FIFO almost_full Flag
  input                        empty;           // FIFO empty Flag
  input                        full;            // FIFO full Flag
  input                        cmd_taken;       // Command Taken By CIU
  input                 [27:0] b2c_cmd_control; // Command Control
  input   [`F_COUNT_WIDTH-1:0] count;           // FIFO Count
  input                 [31:0] trans_fifo_cnt;  // Transfered Bytes from FIFO
  input                 [31:0] b2c_byte_count;  // Transfered Bytes by Card
  input                        ciu_data_trans_done;// CIU Data Transfer Done
  input                        resp_timeout;       // Response Timeout 
  input                  [2:0] dw_dma_trans_size;  // DMA Multiple Trans. Size
                                                   // SRC/DEST_MSIZE of DW_dmac

 // IDMAC only

  `ifdef INTERNAL_DMAC_YES 

  input                        use_internal_dmac; // Signal stating if transfer is using IDMAC or slave

  `endif




  // Reg/Wire Declaration
`ifdef GENERIC_DMA
  reg                          ge_dma_req;         // GE-DMA Request
  reg                          ge_dma_addr0;       // GE-DMA Address0
  reg                          ge_dma_done;        // GE-DMA Data Done 
`else
  wire                         ge_dma_req;         // GE-DMA Request
  wire                         ge_dma_addr0;       // GE-DMA Address0
  wire                         ge_dma_done;        // GE-DMA Data Done 
`endif
  reg                          dw_dma_req;         // DW-DMA Request
  reg                          dw_dma_single;      // DW-DMA Single Request
  reg                    [4:0] dma_card_num;       // DMA Current Card Sel 
  reg                          dma_write;          // DMA Write Cycle
  reg                          data_trans_in_prog; // Data Trans. in prog
  reg                          dma_data_trans_done;// DMA Data Done
  reg                          undefined_length;   // Undefined Length DMA
  reg                   [31:0] reg_byte_count;     // Registered Byte Count 
  reg                          dw_burst_wr_conti;  // Write Burst Continuation 
  reg                          dw_burst_rd_conti;  // Read Burst Continuation 
  reg                          dma_write_card_done;// DMA Write - Card Done
                                                   // Read Data/FIFO Need
                                                   // To be flushed 

  wire      [`F_COUNT_WIDTH:0] count_adj;          // FIFO count adjusted
                                                   // to DMA Data Width 
  wire                         cmd_taken_quali;    // GE-DMA Enabled
  wire                         ge_dma_enabled;     // GE-DMA Enabled 
  wire                         dw_dma_enabled;     // DW-DMA Enabled
  wire                         non_dw_dma_enabled; // NON-DW-DMA Enabled
  wire                         byte_count_zero;    // Undefined Length DMA
  wire                         nxt_byte_gt_eq;     // NEXT DMA Cycle Will .. 
  wire                         byte_gt_eq;         // Transferred All bytes
  wire                         single_only;        // Single Transfer Only condi
  wire                         write_single;       // Single Transfers - write 
  wire                         write_burst;        // Burst Transfers - write 
  wire                         read_single;        // Single Transfers - read 
  wire                         read_burst;         // Burst Transfers - read 
  wire                         single_condi;       // Single Transfer Condition
  wire                  [31:0] pending_bytes;      // Pending Bytes to be Trans
  wire                   [8:0] trans_count;        // DMA Multiple Trans Count
  wire                  [11:0] trans_count_byte;   // DMA Multiple Trans Count
  wire    [`F_COUNT_WIDTH-1:0] tmp_fifo_depth;     // FIFO Depth 
  wire    [`F_COUNT_WIDTH-1:0] unfilled_count;     // Unfilled FIFO count 
  wire      [`F_COUNT_WIDTH:0] unfill_count_adj;   // Unfilled FIFO count-Bytes 

  // Encode DW_dmac SRC/DEST_MSIZE Variable to Transfer Count
  assign trans_count      = (dw_dma_trans_size == 3'b000) ? 9'd1 :
                            (dw_dma_trans_size == 3'b001) ? 9'd4 :
                            (dw_dma_trans_size == 3'b010) ? 9'd8 :
                            (dw_dma_trans_size == 3'b011) ? 9'd16 :
                            (dw_dma_trans_size == 3'b100) ? 9'd32 :
                            (dw_dma_trans_size == 3'b101) ? 9'd64 :
                            (dw_dma_trans_size == 3'b110) ? 9'd128 : 9'd256;

  assign trans_count_byte = (`H_DATA_WIDTH==16)? (trans_count << 1) :
                            (`H_DATA_WIDTH==32)? (trans_count << 2) :
                                                 (trans_count << 3) ;

  assign count_adj        = (`H_DATA_WIDTH==16)? count << 1 : {1'b0,count};
  assign tmp_fifo_depth   = `FIFO_DEPTH;
  assign unfilled_count   = tmp_fifo_depth - count;
  assign unfill_count_adj = (`H_DATA_WIDTH==16)? unfilled_count << 1 : 
                                                 {1'b0,unfilled_count};


  `ifdef INTERNAL_DMAC_YES

  assign write_burst      = (dma_write & (count_adj > trans_count)); 

  `endif



  assign read_burst       = (~dma_write & (unfill_count_adj >= trans_count)); 
  assign single_only      = (dw_dma_trans_size == 3'b000); 
  assign write_single     = (dma_write & (count_adj < trans_count)); 
  assign read_single      = (~dma_write & (pending_bytes < trans_count_byte) &
                            ~undefined_length & ~byte_gt_eq); 
  assign single_condi     = single_only | write_single | read_single;

  assign cmd_taken_quali  = cmd_taken & b2c_cmd_control[9] & 
                           ~b2c_cmd_control[21];

  assign dw_dma_write     = dma_write;
  assign dw_dma_card_num  = dma_card_num;


  `ifdef INTERNAL_DMAC_YES

  assign dw_dma_enabled   = 1'b1;

  `endif



  assign non_dw_dma_enabled  = dma_enabled & (`DMA_INTERFACE == 3);
   
  assign ge_dma_write     = dma_write;
  assign ge_dma_card_num  = dma_card_num;
  assign ge_dma_enabled   = dma_enabled & (`DMA_INTERFACE == 2);
  assign ge_dma_push      = ge_dma_addr0 & ge_dma_ack & ge_dma_req & ~dma_write;
  assign ge_dma_pop       = ge_dma_addr0 & ge_dma_ack & ge_dma_req &  dma_write;

  assign byte_count_zero  = (b2c_byte_count == 32'h0);
  assign nxt_byte_gt_eq   = ((trans_fifo_cnt + `DMA_BUS_BYTES) >= 
                            reg_byte_count);
  assign byte_gt_eq       = (trans_fifo_cnt >= reg_byte_count);
  assign pending_bytes    = reg_byte_count - trans_fifo_cnt;


  `ifdef INTERNAL_DMAC_YES

  assign data_trans_done  = (use_internal_dmac)? dma_data_trans_done : 
                                           ciu_data_trans_done;


  `endif




  // Temporary Signals tracking the DMA progress
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          dma_card_num           <= 5'h0;
          dma_write              <= 1'b0;
          data_trans_in_prog     <= 1'b0;
          dma_write_card_done    <= 1'b0;
          undefined_length       <= 1'b0;
          reg_byte_count         <= 32'h0;
          dma_data_trans_done    <= 1'b0;
        end
      else
        begin
          if(cmd_taken_quali) 
            begin
              dma_card_num      <= b2c_cmd_control[20:16];
              dma_write         <= ~b2c_cmd_control[10];
              undefined_length  <= byte_count_zero;
              reg_byte_count    <= b2c_byte_count;
            end


          if(dma_reset | ciu_reset | ciu_data_trans_done |
            ((resp_timeout & !(b2c_cmd_control[27] | b2c_cmd_control[24]))& b2c_cmd_control[9] & ~b2c_cmd_control[21]))
            data_trans_in_prog <= 1'b0;
          else if(cmd_taken_quali)


            `ifdef INTERNAL_DMAC_YES

            data_trans_in_prog <= 1'b1;

            `endif




          `ifdef INTERNAL_DMAC_YES

          if(dma_reset | ciu_reset | cmd_taken_quali)
            dma_write_card_done <= 1'b0;
          else if(ciu_data_trans_done & dma_write)  // read from card
            dma_write_card_done <= 1'b1;
          else if(dma_write_card_done & empty)
            dma_write_card_done <= 1'b0;

          `endif


        

          `ifdef INTERNAL_DMAC_YES

          if(dma_reset | dma_data_trans_done)
            dma_data_trans_done <= 1'b0;
          else if(ciu_data_trans_done & ~dma_write)   // Write to card
            dma_data_trans_done <= 1'b1;
          else if(dma_write_card_done & empty)
            dma_data_trans_done <= 1'b1;

          `endif



        end
    end

  // DesignWare/NONDw DMA related 
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          dw_dma_single     <= 1'b0;
          dw_dma_req        <= 1'b0;
          dw_burst_wr_conti <= 1'b0;
          dw_burst_rd_conti <= 1'b0;
        end
      else
        begin
            if(dma_reset | cmd_taken_quali | (dw_dma_req & dw_dma_ack))
              begin
                dw_dma_req        <= 1'b0;
                dw_dma_single     <= 1'b0;
                dw_burst_wr_conti <= ~dma_reset & ~cmd_taken_quali & 
                                     dma_write & write_burst; 
                dw_burst_rd_conti <= ~dma_reset & ~cmd_taken_quali & 
                                     ~dma_write & read_burst;
              end 

`ifdef DW_DMA
            else if(~dw_dma_req & ~dw_dma_ack & dw_dma_enabled & 
              ((data_trans_in_prog & 
                ((dma_write & (greater_than  | dw_burst_wr_conti)) |
                (~dma_write & (less_or_equal | dw_burst_rd_conti) &
                              (undefined_length | ~byte_gt_eq)) |
                (read_single & (less_or_equal | dw_burst_rd_conti)))) |
              (dma_write_card_done & ~empty)))
              begin 
                dw_dma_req    <= 1'b1;
                dw_dma_single <= 1'b0;
              end
`endif

`ifdef NON_DW_DMA
           else if(~dw_dma_req & ~dw_dma_single & ~dw_dma_ack & non_dw_dma_enabled &
              dma_write_card_done & ~empty & write_single)
              begin 
                dw_dma_req    <= 1'b1;
                dw_dma_single <= 1'b1;
              end
           else if(~dw_dma_req & ~dw_dma_single & ~dw_dma_ack & non_dw_dma_enabled &
              ((data_trans_in_prog & 
                ((dma_write & (greater_than  | dw_burst_wr_conti)) |
                (~dma_write & (less_or_equal | dw_burst_rd_conti) &
                              (undefined_length | ~byte_gt_eq)) |
                (read_single & (less_or_equal | dw_burst_rd_conti)))) |
              (dma_write_card_done & ~empty)))
              begin 
                dw_dma_req    <= 1'b1;
                dw_dma_single <= 1'b0;
              end
`endif
      end
    end

`ifdef GENERIC_DMA
  // Generic DMA Interface Related
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          ge_dma_addr0  <= 1'b0;
          ge_dma_req    <= 1'b0; 
          ge_dma_done   <= 1'b0;
        end
      else
        begin
         if(`GE_DMA_DATA_WIDTH != 16)
            ge_dma_addr0 <= 1'b1;
         else
           begin
             if(dma_reset | cmd_taken_quali | ~ge_dma_enabled )
               ge_dma_addr0 <= 1'b0;
             else if(ge_dma_ack & ge_dma_req)
               ge_dma_addr0 <= ~ge_dma_addr0;
           end

          if(ge_dma_done == 1'b1)
            ge_dma_done <= 1'b0;
          else if(dma_reset & data_trans_in_prog)
            ge_dma_done <= 1'b1;
          else if(dma_reset)
            ge_dma_done <= 1'b0;
          else if(ciu_data_trans_done & dma_enabled & ~dma_write)
            ge_dma_done <= 1'b1;
          else if(dma_write_card_done & empty)
            ge_dma_done <= 1'b1;


          if(dma_reset | cmd_taken_quali)
            ge_dma_req    <= 1'b0;
          else if(ge_dma_req & ge_dma_ack & 
              ((dma_write & (almost_empty | empty) & ge_dma_addr0) | 
              (~dma_write & ge_dma_addr0 & ~undefined_length & nxt_byte_gt_eq) |
              (~dma_write & (almost_full | full) & ge_dma_addr0)))
            ge_dma_req    <= 1'b0;
          else if(~ge_dma_req & ge_dma_enabled & ((data_trans_in_prog & 
              ((dma_write & greater_than) | 
              (~dma_write & less_or_equal & undefined_length) |
              (~dma_write & less_or_equal & ~undefined_length & ~byte_gt_eq)))|
              ( dma_write_card_done & ~empty)))
            ge_dma_req   <= 1'b1;
        end
    end
`else
    assign ge_dma_addr0 = 1'b0;
    assign ge_dma_req   = 1'b0; 
    assign ge_dma_done  = 1'b0;
`endif
 
endmodule  

