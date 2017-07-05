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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_txfiford.v#14 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_txfiford.v
// Description : DWC_mobile_storage_txfiford, generate FIFO read cycle for
//               Data transmit logic, FIFO FIFO get empty
//               and local data shift reg is empty stop_clk signal
//               will be asserted to stop the clock untill FIFO
//               becomes non empty
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_txfiford(
  /*AUTOARG*/
  // Outputs
  fifo_pop, data_load_en, tx_stop_clk,
  // Inputs
  creset_n, cclk_in, cclk_in_en,stop_data, fifo_empty, fifo_almost_empty,
 start_tx_data, tx_byte_done, tx_bit_cnt_r, dp_card_wide_bus,
 dp_open_ended_xfer, byte_countrem_zero, byte_count_rem, suspend_data_stop,
  count_r,
 //SD_3.0 start
  ddr,
 //SD_3.0 ends
 dscrd_cur_xfer
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clock and Reset
  input           creset_n;             // Card Reset - Active Low
  input           cclk_in;              // CIU Clock
  input           cclk_in_en;           // Clock enable
  // Input
  input           stop_data;            // Stop data transmission
  input           fifo_empty;           // FIFO empty
  input           fifo_almost_empty;    // FIFO almost empty
  input           start_tx_data;        // Start data transmission
  input           tx_byte_done;         // Data tranmission byte done
  input     [2:0] tx_bit_cnt_r;         // Data transmission bit count
  input     [1:0] dp_card_wide_bus;     // 1/4/8-bit data bus.
  input           dp_open_ended_xfer;   // Open ended data transfer
  input           byte_countrem_zero;   // Byte_count becomes zero
  input    [31:0] byte_count_rem;       // Transfer data bytes - down count
  input           suspend_data_stop;    // Suspend data stop
  input    [23:0] count_r;
 //SD_3.0 start
  input           ddr;
 //SD_3.0 ends
  input           dscrd_cur_xfer;       // Discard current transfer
                                        // due to premature CCS



  // Output
  output          fifo_pop;             // Pop data from FIFO
  output          data_load_en;         // Data transmission shift register
  output          tx_stop_clk;          // Stop clock for the selected card

  // FIFO read state defines
  `define     RDFIFO_IDLE       0       // Idle
  `define     RDFIFO_POP        1       // FIFO POP
  `define     RDFIFO_WAIT       2       // Wait for byte_count
  `define     RDFIFO_STOPCLK    3       // Stop clock FIFO empty

  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Registers
  reg       [3:0] rdfifo_cs;            // FIFO read state m/c current state
  reg       [3:0] rdfifo_ns;            // FIFO read state m/c next state
  reg       [2:0] tx_byte_done_cnt;     // Byte tx done count
  reg             fifo_pop_r;           // FIFO load reg
  reg             fifo_pop_r1;          // FIFO load reg
  reg             fifo_empty_stop_clk;  // FIFO empty stop clock
  reg             last_word_ld;         // Last word loaded
  reg             fifo_pop_tmp;         // Fifo_pop pulse of 1 cclk_in


  // Wires
  wire            read_next_word;       // Read next word
  wire            last_tx_bit;          // Last data tx bit remaining
  wire      [1:0] wait_sel;             // Mux select


  // FIFO read state machine register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        rdfifo_cs     <= 4'h1;
      else begin
        if (dscrd_cur_xfer)
            rdfifo_cs <= 4'h1;
        else if (cclk_in_en) begin
          if (stop_data || suspend_data_stop)
            rdfifo_cs <= 4'h1;
          else
            rdfifo_cs <= rdfifo_ns;
        end
      end
    end

  // register fifo pop to generate single cclk_in pulse
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        fifo_pop_r1 <= 1'b0;
      end else begin
        fifo_pop_r1 <= fifo_pop_r;
      end
    end

  // generate single cclk_in pop pulse
  assign fifo_pop = fifo_pop_r & ~(fifo_pop_r1);

  // Last data bit in shift register which is to be transmitted
  assign last_tx_bit = (tx_byte_done_cnt == `F_DATA_WIDTH/8-1) &&
                       (((tx_bit_cnt_r == 3'h7) && (dp_card_wide_bus == 2'b00)) ||
                        ((tx_bit_cnt_r == 3'h4) && (dp_card_wide_bus == 2'b01) && !ddr) ||
                        ((dp_card_wide_bus[1] && tx_byte_done))                 ||
            //SD_3.0 start
            ((tx_bit_cnt_r == 3'h7) && (dp_card_wide_bus == 2'b01) && ddr)); // For DDR mode only
            //SD_3.0 ends

  //Fifo_empty_stop_clk register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        fifo_empty_stop_clk   <= 1'b0;
      else begin
        if ((!fifo_empty) || rdfifo_cs[`RDFIFO_IDLE])
          fifo_empty_stop_clk <= 1'b0;
        else if (fifo_empty)
          fifo_empty_stop_clk <= 1'b1;
      end
    end


  // byte_counter_rem is checked  > 1 byte_count_rem is updated one clocked
  // after the whole byte is transmitted.
  assign read_next_word = ((byte_count_rem > 1) || dp_open_ended_xfer) &&
                          last_tx_bit;

  assign wait_sel[0]    = (byte_countrem_zero && !dp_open_ended_xfer) ||
                          read_next_word;

  assign wait_sel[1]    = (byte_countrem_zero && !dp_open_ended_xfer) ||
                          (fifo_empty_stop_clk  && tx_byte_done &&
                          (!last_word_ld || dp_open_ended_xfer));


  // FIFO read  state machine combinational logic
  always @ (/*AUTOSENSE*/ fifo_empty or rdfifo_cs
            or start_tx_data or wait_sel or fifo_empty_stop_clk)
    begin : FSM
      rdfifo_ns = 4'h0;

      case (1'b1)
        rdfifo_cs[`RDFIFO_IDLE] :  begin
          if (start_tx_data && (!fifo_empty))
            rdfifo_ns[`RDFIFO_POP]  = 1'b1;
          else
            rdfifo_ns[`RDFIFO_IDLE] = 1'b1;
        end

        rdfifo_cs[`RDFIFO_POP] : rdfifo_ns[`RDFIFO_WAIT] = 1'b1;

        rdfifo_cs[`RDFIFO_WAIT] :  begin
          case (wait_sel)
            2'b01 : rdfifo_ns[`RDFIFO_POP]     = 1'b1;
            2'b10 : rdfifo_ns[`RDFIFO_STOPCLK] = 1'b1;
            2'b11 : rdfifo_ns[`RDFIFO_IDLE]    = 1'b1;
            default : rdfifo_ns[`RDFIFO_WAIT]  = 1'b1;
          endcase
        end

//VCS coverage off
        rdfifo_cs[`RDFIFO_STOPCLK] : begin
          if (!fifo_empty_stop_clk) begin
     //MMC4_4 start
       case (wait_sel)
              2'b01 : rdfifo_ns[`RDFIFO_POP]     = 1'b1;
              2'b10 : rdfifo_ns[`RDFIFO_STOPCLK] = 1'b1;
              2'b11 : rdfifo_ns[`RDFIFO_IDLE]    = 1'b1;
              default : rdfifo_ns[`RDFIFO_WAIT]  = 1'b1;
            endcase 
     end
           // rdfifo_ns[`RDFIFO_WAIT]    = 1'b1;
      //MMC4_4 ends
          else
            rdfifo_ns[`RDFIFO_STOPCLK] = 1'b1;
        end
//VCS coverage on
      endcase
    end

  // Byte done count for FIFO READ.
  // register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        tx_byte_done_cnt     <= 3'h0;
      else begin
        if (cclk_in_en) begin
          if (rdfifo_cs[`RDFIFO_IDLE] || last_tx_bit)
            tx_byte_done_cnt <= 3'h0;
          else if ((tx_byte_done && !dp_card_wide_bus[1]) ||
                   (tx_byte_done && dp_card_wide_bus[1] &&
                    !(tx_byte_done_cnt == (`F_DATA_WIDTH/8-1))))
            tx_byte_done_cnt <= tx_byte_done_cnt + 3'b1;
        end
      end
    end

  // FIFO pop regiter to generate pulse
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        fifo_pop_r   <= 1'b0;
      end else begin
        if (cclk_in_en)
          fifo_pop_r <= rdfifo_ns[`RDFIFO_POP];
      end
    end

  //One cclk_in pulse of fifo_pop signal
  //Requirement of one cclk_in pulse to generate fifo_empty_stop_clk
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        fifo_pop_tmp   <= 1'b0;
      else begin
        if (cclk_in_en)
          fifo_pop_tmp <= rdfifo_ns[`RDFIFO_POP];
      end
    end

  assign data_load_en   = rdfifo_ns[`RDFIFO_POP];
//  assign fifo_pop       = fifo_pop_r;
  assign tx_stop_clk    = rdfifo_ns[`RDFIFO_STOPCLK];

  //Calculation of last fifo word loaded in shift register
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        last_word_ld     <= 1'b0;
      else begin
        if (fifo_pop_tmp) begin
          if ((byte_count_rem > 0) &&
              (byte_count_rem <= `F_DATA_WIDTH/8)) begin
            last_word_ld <= 1'b1;
          end else begin
            last_word_ld <= 1'b0;
          end
        end
      end
    end

endmodule // DWC_mobile_storage_txfiford
