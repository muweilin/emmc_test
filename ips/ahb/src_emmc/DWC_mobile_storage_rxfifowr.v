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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_rxfifowr.v#10 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_rxfifowr.v
// Description : DWC_mobile_storage_rxfifowr, Generate FIFO write logic for/
//               Data receive logic and clock stop logic
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_rxfifowr(
  /*AUTOARG*/
  // Outputs
  fifo_push, rx_stop_clk, rx_byte_done_cnt, rxfifo_idle,
  // Inputs
  creset_n, cclk_in, cclk_in_en, stop_data, fifo_full, fifo_almost_full,
  start_rx_data, rx_byte_done, dp_open_ended_xfer, byte_countrem_zero,
 //MMC4_4 start
 cclk_in_en_8_ddr,
 //MMC4_4 ends
  abort_read_data_r, rx_data_timeout, rx_data_endbit_err, dp_card_wide_bus,
  dscrd_cur_xfer
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clock and Reset
  input            creset_n;           // Card Reset - Active Low
  input            cclk_in;            // CIU Clock
  input            cclk_in_en;         // Clock enable

  // Input
  input            stop_data;          // Stop data transmission
  input            fifo_full;          // FIFO full
  input            fifo_almost_full;   // FIFO almost full
  input            start_rx_data;      // Start data transmission
  input            rx_byte_done;       // Data tranmission byte done
  input            dp_open_ended_xfer; // Open ended transfer
  input            byte_countrem_zero; // Byte_counter is zero
  input            abort_read_data_r;  // Read abort data(suspend)
  input            rx_data_timeout;    // Read data timeout
  input            rx_data_endbit_err; // Data block end bit error
  input      [1:0] dp_card_wide_bus;   // Card width
  input            dscrd_cur_xfer;     // Discard current transfer
                                       // due to premature CCS
 //MMC4_4 start                   
  input             cclk_in_en_8_ddr; 
  //MMC4_4 ends

  // Output
  output           fifo_push;          // Push data from FIFO
  output           rx_stop_clk;        // Stop clock for the selected card
  output     [2:0] rx_byte_done_cnt;   // Rx byte done count
  output           rxfifo_idle;        // Rx fifo idle

  // FIFO Write State defines
  `define     WRFIFO_IDLE        0     // IDLE
  `define     WRFIFO_WAIT        1     // Wait for byte_count
  `define     WRFIFO_PUSH        2     // PUSH FIFO
  `define     WRFIFO_STOPCLK     3     // STOP clk FIFO FULL
  `define     WRFIFO_LASTPUSH    4     // PUSH last byte/s in FIFO

  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Registers
  reg        [4:0] wrfifo_cs;          // FIFO write  state m/c current state
  reg        [4:0] wrfifo_ns;          // FIFO write state m/c next state
  reg        [2:0] rx_byte_done_cnt;   // Data byte rx count
  reg              fifo_push_r;        // FIFO PUSH
  reg              fifo_push_r1;       // FIFO PUSH

  reg        [2:0] fifo_push_cnt;      // FIFO push count
  reg              rx_stop_abort;      // Stop fifowr state machine

  // Wires
  wire             write_next_word;    // Write next word
  wire       [1:0] wait_sel;           // Select line for 4:1 mux
  wire             fifo_push_w;        // Push FIFO

  // FIFO write machine register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        wrfifo_cs        <= 5'h1;
      else begin
        if (dscrd_cur_xfer)
          wrfifo_cs        <= 5'h1;
   //MMC4_4 start  
        else /*if (cclk_in_en)*/ if(cclk_in_en_8_ddr)
   //MMC4_4 ends
          wrfifo_cs      <= wrfifo_ns;
      end
    end


  // register fifo_push_r to generate single cclk_in pulse
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        fifo_push_r1 <= 1'b0;
      end else begin
        fifo_push_r1 <= fifo_push_r;
      end
    end

  // generate single cclk_in push pulse
  assign fifo_push = fifo_push_r & ~(fifo_push_r1);

  //suspend, abort and data timeout action
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        rx_stop_abort    <= 1'b0;
      else begin
        if (cclk_in_en &&
            (stop_data || abort_read_data_r ||
             rx_data_timeout || rx_data_endbit_err))
          rx_stop_abort  <= 1'b1;
        else if (wrfifo_cs[`WRFIFO_IDLE])
          rx_stop_abort  <= 1'b0;
      end
    end

  assign write_next_word    = (rx_byte_done_cnt == `F_DATA_WIDTH/8-1) &&
                              rx_byte_done;

  assign wait_sel[0]        = ((byte_countrem_zero && !dp_open_ended_xfer) ||
                               rx_stop_abort || write_next_word );
  assign wait_sel[1]        = ((byte_countrem_zero && !dp_open_ended_xfer) ||
                               rx_stop_abort || fifo_full);

  // FIFO write state machine combinational logic
  always @ (/*AUTOSENSE*/ fifo_full or fifo_push_r or rx_byte_done
            or rx_byte_done_cnt or start_rx_data or wait_sel
            or wrfifo_cs)
    begin : FSM_wrfifo
      wrfifo_ns = 5'h0;

      case (1'b1)
        wrfifo_cs[`WRFIFO_IDLE] :  begin
          if (start_rx_data)
            wrfifo_ns[`WRFIFO_WAIT] = 1'b1;
          else
            wrfifo_ns[`WRFIFO_IDLE] = 1'b1;
        end

        wrfifo_cs[`WRFIFO_WAIT] : begin
          case (wait_sel)
            2'b01 : wrfifo_ns[`WRFIFO_PUSH]     = 1'b1;
            2'b10 : wrfifo_ns[`WRFIFO_STOPCLK]  = 1'b1;
            2'b11 : begin
              if (fifo_full)
                wrfifo_ns[`WRFIFO_STOPCLK]  = 1'b1;
              else
                wrfifo_ns[`WRFIFO_LASTPUSH] = 1'b1;
            end

            default : wrfifo_ns[`WRFIFO_WAIT]   = 1'b1;
          endcase
        end

        wrfifo_cs[`WRFIFO_PUSH] : wrfifo_ns[`WRFIFO_WAIT] = 1'b1;

//VCS coverage off
        wrfifo_cs[`WRFIFO_STOPCLK] : begin
          if (!fifo_full)
            wrfifo_ns[`WRFIFO_WAIT]    = 1'b1;
          else
            wrfifo_ns[`WRFIFO_STOPCLK] = 1'b1;
        end
//VCS coverage on
        
        wrfifo_cs[`WRFIFO_LASTPUSH] : begin
          if (fifo_push_r || ((rx_byte_done_cnt == 0) && ~rx_byte_done))
            wrfifo_ns[`WRFIFO_IDLE]     = 1'b1;
          else
            wrfifo_ns[`WRFIFO_LASTPUSH] = 1'b1;
        end

      endcase
    end

  // Byte done count for FIFO READ.
  // register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        rx_byte_done_cnt      <= 3'h0;
      else begin
   //MMC4_4 start
       // if (cclk_in_en) begin
    if (cclk_in_en_8_ddr) begin
    //MMC4_4 ends
          if (wrfifo_ns[`WRFIFO_PUSH] || wrfifo_ns[`WRFIFO_IDLE])
            rx_byte_done_cnt  <= 3'h0;
          else if (rx_byte_done)
            rx_byte_done_cnt  <= rx_byte_done_cnt + 3'b1;
        //end                    
    end
      end
    end

  assign fifo_push_w    = (wrfifo_ns[`WRFIFO_PUSH]) ||
                          (wrfifo_ns[`WRFIFO_LASTPUSH] &&
                           ((rx_byte_done_cnt > 0) ||
                            ((rx_byte_done_cnt == 0) && rx_byte_done)) &&
                           (fifo_push_cnt == 0));

  assign rx_stop_clk    = (wrfifo_ns[`WRFIFO_STOPCLK]);

  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        fifo_push_r      <= 1'b0;
      end else begin
   //MMC4_4 start
        //if (cclk_in_en) begin
    if (cclk_in_en_8_ddr) begin
   //MMC4_4 ends 
          fifo_push_r    <= fifo_push_w;
     end
        //end
      end
    end

  // In case the transfer count does not align on fifo data
  // width boundary, it is done so with additional stuff bits.
  // In such a case fifo_push is done either after 4 or 8
  // clocks.
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        fifo_push_cnt     <= 3'b0;
      else begin
        if (cclk_in_en) begin
          if (dp_card_wide_bus[1]) begin
            if (fifo_push_w && (fifo_push_cnt != 3'b011))
              fifo_push_cnt <= 3'b011;
            else if (fifo_push_cnt > 0)
              fifo_push_cnt <= fifo_push_cnt - 1;
          end else begin // if (1/4 bit mode)
          if (fifo_push_r && (fifo_push_cnt != 3'b111))
            fifo_push_cnt <= 3'b111;
          else if (fifo_push_cnt > 0)
            fifo_push_cnt <= fifo_push_cnt - 1;
          end
        end
      end
    end

  assign rxfifo_idle = wrfifo_cs[`WRFIFO_IDLE];

endmodule // DWC_mobile_storage_rxfifowr
