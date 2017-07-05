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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_intrcntl.v#14 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_intrcntl.v
// Description : DWC_mobile_storage Interrupt control
//               Detects interrupt in cdata_in[1] line for all the cards.
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_intrcntl(
   /*AUTOARG*/
  // Outputs
  sdio_interrupt,
  // Inputs
  creset_n, cclk_in, cclk_in_en, cp_card_num, cp_cmd_end_bit, resp_timeout,
  dp_card_wide_bus, rx_data_end_bit, tx_data_end_bit, tx_data_done, 
  rx_data_done, cp_stop_abort_cmd, response_done, auto_cmd_done,
  auto_stop_cmd, auto_stop_en, cclk_sample_en,card_int_n_dsync,dat_int_n_dsync,  cdata_in_r, dp_cdata_in,
  byte_countrem_zero, dp_open_ended_xfer, abort_read_data_r, suspend_data_cmd,
  tx_crcstbit_err, rx_data_timeout, data_trans_cmd, cp_data_cmd
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clock and Reset
  input                       creset_n;         // Card Reset - Active Low
  input                       cclk_in;          // CIU Clock
  input                       cclk_in_en;       // Clock enable

  // cmd path port
  input                 [3:0] cp_card_num;      // Card number
  input                       cp_cmd_end_bit;   // Command transmit end bit
  input                       resp_timeout;     // Response timeout,no data
  input                       auto_cmd_done;    // Auto command done
  input                       auto_stop_cmd;    // Command is auto stop
  input                       cp_stop_abort_cmd;// Stop abort command
  input                       response_done;    // Response done
  input                       cp_data_cmd;      // Cmd with data xfer
  
  
  // data path
  input                 [1:0] dp_card_wide_bus; // Card wide bus
  input                       rx_data_end_bit;  // Receive data block end bit
  input                       tx_data_end_bit;  // Transmit data block end bit
  input                       tx_data_done;     // Transmit data done
  input                       rx_data_done;     // Receive data done
  input                       dp_open_ended_xfer;// Open ended transfer
  input                       byte_countrem_zero; // Remaining byte count
  input                       auto_stop_en;     // Autostop generate enable
  input                       abort_read_data_r;// Abort read data registered
  input                       suspend_data_cmd; // Suspend command
  input                       tx_crcstbit_err;  // CRC status start bit error
  input                       rx_data_timeout;  // Read data timeout
  input                       data_trans_cmd;   // Data transfer command


  input                [15:0] cclk_sample_en;   // Clock sample enable
  //SDIO start
  input   [`NUM_CARD_BUS-1:0] card_int_n_dsync;  // Synchronized card INT# signal.
 input   [`NUM_CARD_BUS-1:0] dat_int_n_dsync;
 //SDIO ends
  // hold register port
  input [`NUM_CARD_BUS*8-1:0] cdata_in_r;       // Card Data Input

  input                 [7:0] dp_cdata_in;      // Card Data Input

  // BIU port
  output  [`NUM_CARD_BUS-1:0] sdio_interrupt;   // SDIO interrupts

  // interrupt state machine defines
  `define            INTR_IDLE         0   // idle
  `define            INTR_NOINT        1   // no interrput period
  `define            INTR_RXDTINT      2   // rx data intr betwn data block
  `define            INTR_TXDTINT      3   // tx data intr betwn data block
  `define            INTR_WAITIDLE1    4   // Wait 3 clocks before idle
  `define            INTR_WAITIDLE2    5   // Wait 2 clocks before idle
  `define            INTR_WAITIDLE3    6   // Wait 1 clocks before idle


  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  integer                     i,j;

  // Register
  reg                   [6:0] intr_cs;          // Intr state m/c current state
  reg                   [6:0] intr_ns;          // Intr state m/c next state
  reg                         intr_selectedcard_sync;// Intr for select card
 reg                         intr_selectedcard_async;// Intr for select card
 wire                         intr_selectedcard;// Intr for select card

  reg                  [15:0] cdata_in1;        // Cdata_in[1] for all the cards
 //SDIO 3.0 start
  reg                  [15:0] cdata_in2;        // Cdata_in[1] for all the cards even when clock is not on.
 //SDIO 3.0 ends
  reg                   [1:0] count_r;          // Count reg
  reg                         tx_data_done_r;   // TX data done registered
  reg                         tx_data_end_bit_r;// TX data end bit registered
  reg                         tx_data_end_bit_r1;//TX data end bit registered
  reg                         stop_cmd_end_bit; // Stop cmd end bit
  reg                         stop_cmd_end_bit_r;//Stop cmd end bit

  reg                   [3:0] cp_card_num_r;    // Card number
  reg                         cp_cmd_end_bit_r; // Cmd end bit registered
  reg                         cp_cmd_end_bit_r1;// Cmd end bit registered
  reg                         cp_cmd_end_bit_r2;// Cmd end bit registered

  // Wires
  wire                        counter_zero;      // Counter zero
  wire                        start_intr;        // Start interrupt
  wire                  [3:0] noint_sel;         // No intr period
  wire                  [1:0] intr_ns_sel;       // Intr next state select
  wire                        rx_start_bit;      // Rx start bit
  wire                        card_error;        // Card error
  wire                        data_resp_tmout;   // Resp timeout for data cmd
  wire                        auto_stop;         // Auto stop set
  
  
  //Registered tx_data_done and tx_data_end_bit
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        tx_data_done_r       <= 1'b0;
        tx_data_end_bit_r    <= 1'b0;
        tx_data_end_bit_r1   <= 1'b0;
        cp_card_num_r        <= 4'h0;
        cp_cmd_end_bit_r     <= 1'b0;
        cp_cmd_end_bit_r1    <= 1'b0;
        cp_cmd_end_bit_r2    <= 1'b0;
      end else begin
        if (cclk_in_en) begin
          tx_data_done_r     <= tx_data_done;
          tx_data_end_bit_r  <= tx_data_end_bit;
          tx_data_end_bit_r1 <= tx_data_end_bit_r;
          cp_card_num_r      <= cp_card_num;
          cp_cmd_end_bit_r   <= cp_cmd_end_bit;
          cp_cmd_end_bit_r1  <= cp_cmd_end_bit_r;
          cp_cmd_end_bit_r2  <= cp_cmd_end_bit_r1;
        end
      end
    end

  assign card_error = tx_crcstbit_err || rx_data_timeout ||
                      data_resp_tmout;
  assign data_resp_tmout = data_trans_cmd && resp_timeout;


  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        stop_cmd_end_bit     <= 1'b0;
        stop_cmd_end_bit_r   <= 1'b0;
      end else begin
        if (cclk_in_en && cp_stop_abort_cmd && cp_cmd_end_bit_r)
          stop_cmd_end_bit   <= 1'b1;
        else if (noint_sel[2] == 1'b1)
          stop_cmd_end_bit   <= 1'b0;

        if (cclk_in_en)
          stop_cmd_end_bit_r <= stop_cmd_end_bit;
      end
    end


  // Interrupt control state machine register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        intr_cs   <= 7'h1;
      else begin
        if (cclk_in_en)
          intr_cs <= intr_ns;
      end
    end


  assign rx_start_bit = (dp_card_wide_bus[1]) ? (~|dp_cdata_in) :
                        (dp_card_wide_bus == 2'b01) ? (~|dp_cdata_in[3:0]) :
                        ~dp_cdata_in[0];

  assign start_intr   = ((dp_card_wide_bus == 2'b01) || dp_card_wide_bus[1]) &&
                        cp_data_cmd && cp_cmd_end_bit_r2;
  assign auto_stop    = auto_stop_cmd || auto_stop_en;
  
  //Card read: Interrupt sampling between two blocks
  assign noint_sel[0] = (rx_data_end_bit && !stop_cmd_end_bit_r &&
                         (!byte_countrem_zero || dp_open_ended_xfer ||
                          auto_stop));

  //Card write: Interrupt sampling between two blocks
  assign noint_sel[1] = (tx_data_end_bit_r1 && !stop_cmd_end_bit &&
                         (!byte_countrem_zero || dp_open_ended_xfer ||
                          auto_stop));

  //Idle state after 2 clocks and start sampling interrupts
  assign noint_sel[2] = ((response_done && cp_stop_abort_cmd) ||
                         auto_cmd_done || card_error);

  //Idle state after 3 clocks and start sampling interrupts
  assign noint_sel[3] = ((rx_data_done && ((byte_countrem_zero &&
                         !dp_open_ended_xfer && !auto_stop) ||
                         abort_read_data_r)) ||
                         (tx_data_end_bit_r1 && byte_countrem_zero &&
                         !dp_open_ended_xfer && !auto_stop) ||
                         (tx_data_done && suspend_data_cmd));


  //Interrupt next state select logic in state INTR_NOINT
  assign intr_ns_sel[0] = noint_sel[0] | noint_sel[2] | noint_sel[3];
  assign intr_ns_sel[1] = noint_sel[1] | noint_sel[2] | noint_sel[3];

  // Interrupt control state machine combinational logic
  always @ (counter_zero or rx_start_bit or start_intr or intr_ns_sel or
            intr_cs or noint_sel or tx_crcstbit_err)
    begin : FSM_intr
      intr_ns = 7'h0;

      case (1'b1)
        intr_cs[`INTR_IDLE] :  begin
          if (start_intr)
            intr_ns[`INTR_NOINT] = 1'b1;
          else
            intr_ns[`INTR_IDLE]  = 1'b1;
        end

        intr_cs[`INTR_NOINT] : begin
          case (intr_ns_sel)
            2'b00   : intr_ns[`INTR_NOINT]   = 1'b1;
            2'b01   : intr_ns[`INTR_RXDTINT] = 1'b1;
            2'b10   : intr_ns[`INTR_TXDTINT] = 1'b1;
            default : begin
              if (noint_sel[2])
                intr_ns[`INTR_WAITIDLE2]     = 1'b1;
              else
                intr_ns[`INTR_WAITIDLE1]     = 1'b1;
            end
          endcase
        end

        intr_cs[`INTR_RXDTINT] : begin
          if (counter_zero || rx_start_bit)
            intr_ns[`INTR_NOINT]   = 1'b1;
          else
            intr_ns[`INTR_RXDTINT] = 1'b1;
        end

        intr_cs[`INTR_TXDTINT] : begin
          if (tx_crcstbit_err)
            intr_ns[`INTR_IDLE]   = 1'b1;
          else if (counter_zero)
            intr_ns[`INTR_NOINT]   = 1'b1;
          else
            intr_ns[`INTR_TXDTINT] = 1'b1;
        end

        intr_cs[`INTR_WAITIDLE1]: intr_ns[`INTR_WAITIDLE2] = 1'b1;

        intr_cs[`INTR_WAITIDLE2] : intr_ns[`INTR_WAITIDLE3] = 1'b1;

        intr_cs[`INTR_WAITIDLE3] : intr_ns[`INTR_IDLE] = 1'b1;

      endcase
    end


  // Interrupt control logic for selected card when card clock is on.
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        intr_selectedcard_sync   <= 1'b1;
      else begin
        if (cclk_in_en && intr_ns[`INTR_IDLE])
          intr_selectedcard_sync <= dp_cdata_in[1];
        else if (cclk_in_en)
          intr_selectedcard_sync <= ~((intr_ns[`INTR_TXDTINT] ||
                                  intr_ns[`INTR_RXDTINT]) &&
                                 ((count_r == 2'b01) && !rx_start_bit &&
                                  !dp_cdata_in[1]));
      end
    end

//SDIO 3.0 Start
  // Interrupt control logic for selected cards on DAT[1] line even in asynchronous period(card clock is off)
always @ (dat_int_n_dsync or intr_ns or cp_card_num)
    begin
        if (intr_ns[`INTR_IDLE])
                intr_selectedcard_async  = dat_int_n_dsync[cp_card_num];
    else 
            intr_selectedcard_async  = 1'b1;
  end
  

  
  // Interrupt control logic for all cards on DAT[1] line even in asynchronous period(card clock is off) 
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
           cdata_in2    <= {16{1'h1}};
      else begin
            cdata_in2             <= dat_int_n_dsync;
      cdata_in2[cp_card_num]<= intr_selectedcard_async; // The interrupt from the selected card will be assigned.   
    end                                                     // this is done so as to not to trigger interrupt for the selected 
   end                                                       // card outside of the sync + async period.

  // Combining the sync and the async interrupt of the selected cards. 
  assign intr_selectedcard = intr_selectedcard_sync & intr_selectedcard_async; 
//SDIO 3.0 ends

  // temporary cdata_in[1] for bus width matching
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        cdata_in1 <= {16{1'h1}};
      else begin
        cdata_in1 <= {16{1'b1}};
        for(i=0; i <= (`NUM_CARD_BUS-1); i=i+1) begin  // All cards which are getting clock can generate the interrupt.
          if (cclk_sample_en[i])
            cdata_in1[i] <= cdata_in_r[i*8 + 1];
        end
        cdata_in1[cp_card_num] <= intr_selectedcard; // The interrupt from the selected card only , both sync and async period.
      end
    end

  // For mmc only mode sdio_interrut would be assiged == 1 and interrupt control
  // detection logic would be removed since it would remain unused
//SDIO 3.0 start 
  assign sdio_interrupt[`NUM_CARD_BUS-1:0] = (`CARD_TYPE == 0) ?
                                             {`NUM_CARD_BUS{1'b0}}:
                                             ~(cdata_in1[`NUM_CARD_BUS-1:0] & cdata_in2[`NUM_CARD_BUS-1:0] & card_int_n_dsync[`NUM_CARD_BUS-1:0]);
//SDIO 3.0 ends
  // Local counter
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        count_r   <= {2{1'h1}};
      else begin
        if (cclk_in_en && intr_cs[`INTR_NOINT])
          count_r <= 2'b11;
        else if (cclk_in_en && (intr_ns[`INTR_RXDTINT]||intr_ns[`INTR_TXDTINT]))
          count_r <= count_r - 1;
      end
    end

  assign counter_zero = (count_r == 2'b0);

endmodule // DWC_mobile_storage_intrcntl
