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
// Date             :        $Date: 2013/04/16 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_datatx.v#40 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_datatx.v
// Description : DWC_mobile_storage data transmit block
//             : Transmitts data stream and data block
//             : on card data line in wide bus and single data line bus
//             : Also generates crc16 and transmits it during data block
//             : transfer . Checks crc status for data block transfer
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_datatx(
  /*AUTOARG*/
  // Outputs
  dp_cdata_out, dp_cdata_out_en, tx_data_end_bit, tx_byte_done, tx_bit_cnt_r,
  tx_data_crc_error, tx_crcstbit_err, txdt_idle, tx_data_done, tx_dat0_busy,
  tx_stop_clk, fifo_pop, tx_new_count, tx_load_counter, tx_dec_counter,
  tx_serial_data, tx_start_crc, tx_send_crc, tx_serial_data_en,
  txdt_stop_load_req, suspend_data_cmd,
 //SD_3.0 start
  ddr_tx_states,
 //SD_3.0 ends
  // Inputs
  creset_n, cclk_in, cclk_in_en, fifo_rdata, fifo_empty, fifo_almost_empty,
  stop_data, cp_stop_cmd_loaded, cp_cmd_suspend, cp_resp_end_bit,
  dp_card_wide_bus, block_size, byte_count_rem,
  data_expected, transfer_mode, dp_open_ended_xfer, byte_countrem_zero,
  read_write_xfer, dp_cdata_in, count_r, counter_zero, serial_crc,
  assert_read_wait, cp_cmd_crc7_end, dscrd_cur_xfer,
 //MMC4_4 start
 cclk_in_en_8_ddr,
 ddr_8,cclk_in_en_ddr,
  ddr_8_tx_states,
 //MMC4_4 ends
 //SD_3.0 start
 ddr, ddr_4_mode,
  ddr_8_mode
 //SD_3.0 ends
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // CIU clock and Reset
  input                     creset_n;           // Card Reset - Active Low
  input                     cclk_in;            // CIU Clock
  input                     cclk_in_en;         // Clock enable

  // From BIU
  input              [63:0] fifo_rdata;         // FIFO Read data
  input                     fifo_empty;         // FIFO empty
  input                     fifo_almost_empty;  // FIFO almost empty


  // From cmdpath
  input                     stop_data;          // Stop/abort cmd end bit
  input                     cp_stop_cmd_loaded; // Stop cmd is loaded
  input                     cp_cmd_suspend;     // Suspend command
  input                     cp_resp_end_bit;    // Cmd response end bit
  input                     cp_cmd_crc7_end;    // Last bit of CRC7 of cmd

  // From data_path register
  input               [1:0] dp_card_wide_bus;   // 1/4/8-bit card data bus.
  input              [15:0] block_size;         // Block_size of transfer
  input              [31:0] byte_count_rem;     // Data transfer byte count
  input                     data_expected;      // Data transfer command
  input                     transfer_mode;      // Transfer mode stream/block
  input                     dp_open_ended_xfer; // Open ended transfer
  input                     byte_countrem_zero; // Byte count zero
  input                     read_write_xfer;    // Read/write data transfer

  // Card Interface
  input               [7:0] dp_cdata_in;        // Card data bus input
  output              [7:0] dp_cdata_out;       // Card Data Output
  output              [7:0] dp_cdata_out_en;    // Card Data Output

  // output port defination
  output                    tx_data_end_bit;    // Data tx end bit.
  output                    tx_byte_done;       // Data tx byte done
  output              [2:0] tx_bit_cnt_r;       // Data tx bit counter
  output                    tx_data_crc_error;  // Data tx crc status error
  output                    tx_crcstbit_err;    // Data tx crc status stbit err
  output                    txdt_idle;          // Data tx idle
  output                    tx_data_done;       // Data tx done
  output                    tx_dat0_busy;       // Dat0 busy
  output                    tx_stop_clk;        // Stop clock
  output                    fifo_pop;           // POP FIFO
  output                    suspend_data_cmd;   // Suspend cmd sent
 output                    ddr_tx_states;      // Used as qualifier to generate DDR signal.


  // counter interface
  input              [23:0] count_r;            // Counter
  input                     counter_zero;       // Counter zero
  output             [23:0] tx_new_count;       // New count
  output                    tx_load_counter;    // Load counter
  output                    tx_dec_counter;     // Dec counter

  // crc16 interface
  input               [7:0] serial_crc;        // Serial crc16
  output              [7:0] tx_serial_data;    // Serial data
  output                    tx_start_crc;      // Start crc16
  output                    tx_send_crc;       // Send crc16
  output                    tx_serial_data_en; // Enable crc16 generation
  output                    txdt_stop_load_req;// Stop cmd req for stream

  //misc
  input                     assert_read_wait;  // Assert read_wait
  input                     dscrd_cur_xfer;    // Discad current transfer
                                               // due to premature CCS
 //MMC4_4 start                       
  input                     cclk_in_en_8_ddr;
 input                     ddr_8;
  input                     cclk_in_en_ddr;
  output                    ddr_8_tx_states;
 //MMC4_4 ends
 //SD_3.0 start
  input                     ddr;               //Trigger for DDR
 input                     ddr_4_mode;
  input                     ddr_8_mode;
   //SD_3.0 ends


  // Data transmit state defines
  `define       TXDT_IDLE         0      // Tx data idle
  `define       TXDT_WFE          1      // Wait FIFO Empty
  `define       TXDT_STBIT        2      // Tx data start bit
  `define       TXDT_BLKDATA      3      // Tx data block
  `define       TXDT_CRC16        4      // Tx data crc16
  `define       TXDT_ENDBIT       5      // Tx data endbit
  `define       TXDT_RXCRC        6      // Rx crc status
  `define       TXDT_CHKBUSY      7      // Check Dat0 busy
  `define       TXDT_STRDATA      8      // Tx stream data
  `define       TXDT_SRACK        9      // stop req ack received
  `define       TXDT_WAITNWR      10     // Wait NWR
  `define       TXDT_WFE1         11     // Wait FIFO Empty 1 clk
  `define       TXDT_WFE2         12     // Wait FIFO Empty 1 clk
  `define       TXDT_WFE3         13     // Wait FIFO Empty 1 clk
  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Registers
  reg                [13:0] txdt_cs;        // Data tx state m/c current state
  reg                [13:0] txdt_ns;        // Data tx state m/c next state
  reg   [`F_DATA_WIDTH-1:0] shift_reg;          // Data shift register
  reg                       stop_data_r;        // Stop data xfer
  reg                       suspend_data_cmd;   // Suspend cmd
  reg                [23:0] tx_new_count;       // New count
  reg                       tx_load_counter;    // Load counter
  reg                       stop_cmd_loaded;    // Stop cmd loaded
  reg                       assert_read_wait_r; // Assert read wait registered
  reg                 [2:0] tx_bit_cnt_r;       // Bit count reg
  reg                 [2:0] rx_crc_r;           // RX crc
 //SD_3.0 start
  reg                       ddr_r1;
 reg                       ddr_r2;
 //MMC4_4 start
 reg                       ddr_8_r1;
 reg                       ddr_8_r2;
  reg                       set_ddr_8_r1;
  reg                       clr_ddr_8_r1;
  //MMC4_4 ends
 //SD_3.0 ends

  // Wires
  wire                      data_load_en;     // Load shift reg with new data
  wire                [7:0] tx_serial_data;   // TX serial data
 reg                         tx_crcstbit_err;  // CRC status start bit erro
 reg                         tx_data_crc_error; 
  wire                [2:0] shift_sel;        // Shift register select
  wire                      tx_byte_done;     // Byte transfer done
  wire                [5:0] wait_count;       // Wait count stop cmd loaded to
  wire                      start_tx_data;    // Start fifo pop
  wire                      suspend_data_stop;// Suspend data stop
  wire                [2:0] tx_bit_cnt_d;     // Bit count wire
  wire                [2:0] card_width;       // Card width
  wire                      cclk_in_en_txfiford;


  // Data transmit state machine register logic
    always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        txdt_cs     <= 14'h1; // idle
      else begin
        if (dscrd_cur_xfer)
          txdt_cs     <= 14'h1; // idle
  //MMC4_4 start   
        else if (ddr_8_mode? (cclk_in_en | cclk_in_en_ddr) : cclk_in_en)
  //MMC4_4 ends
          txdt_cs   <= txdt_ns;
      end
    end

  assign card_width[0] = (~(|dp_card_wide_bus));
  assign card_width[1] = (~dp_card_wide_bus[1] & dp_card_wide_bus[0]);
  assign card_width[2] = (dp_card_wide_bus[1]);
 //SD_3.0 start
  assign ddr_tx_states = txdt_cs[`TXDT_WFE] | txdt_cs[`TXDT_WFE3]| txdt_cs[`TXDT_BLKDATA] | txdt_cs[`TXDT_CRC16] | txdt_cs[`TXDT_ENDBIT] | txdt_cs[`TXDT_WAITNWR];

  assign ddr_8_tx_states = txdt_cs[`TXDT_STBIT] | txdt_cs[`TXDT_BLKDATA] | txdt_cs[`TXDT_CRC16] | txdt_cs[`TXDT_ENDBIT];
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
        begin
          ddr_r1   <= 1'b0;
          ddr_r2   <= 1'b0;
    ////MMC4_4 start
          ddr_8_r1   <= 1'b0;
          ddr_8_r2   <= 1'b0;
    //MMC4_4 ends
        end   
      else 
        begin 
          if(cclk_in_en) 
             begin
               ddr_r1  <= ddr;
               ddr_r2  <= ddr_r1;
             end
               if (clr_ddr_8_r1)
                 ddr_8_r1  <= 1'b0;
               else if (set_ddr_8_r1)
                 ddr_8_r1  <= 1'b1;

               if(cclk_in_en_ddr)
                 ddr_8_r2   <= ddr_8_r1;
        end  
   end
 //SD_3.0 ends

  // State machine combinational logic
  always @ (/*AUTOSENSE*/
            block_size or byte_count_rem or byte_countrem_zero or count_r
            or counter_zero or cp_resp_end_bit or data_expected or dp_cdata_in
            or dp_open_ended_xfer or fifo_empty or read_write_xfer
            or stop_cmd_loaded or stop_data or stop_data_r or suspend_data_cmd
            or transfer_mode or tx_byte_done or tx_crcstbit_err or txdt_cs
            or wait_count or ddr or ddr_r1 or ddr_r2 
      //MMC4_4 start
      or ddr_8_r1 or ddr_8_r2 or ddr_8 or cclk_in_en_ddr or 
            cclk_in_en or ddr_8_mode)
      //MMC4_4 ends
    begin : FSM_datatx
      txdt_ns           = 14'h0;
      tx_new_count      = 24'h0;
      tx_load_counter   = 1'b0;
      set_ddr_8_r1      = 1'b0;
      clr_ddr_8_r1      = 1'b0;
      case (1'b1)
        txdt_cs[`TXDT_IDLE] : 
          begin
            if (data_expected && cp_resp_end_bit && read_write_xfer)
              txdt_ns[`TXDT_WFE2]   = 1'b1; // check fifo_empty/wait
            else
              txdt_ns[`TXDT_IDLE]   = 1'b1;
          end

        txdt_cs[`TXDT_WFE2] : txdt_ns[`TXDT_WFE1] = 1'b1;

        txdt_cs[`TXDT_WFE1] : txdt_ns[`TXDT_WFE]  = 1'b1;

        txdt_cs[`TXDT_WFE] : 
          begin
            if (stop_data)
              txdt_ns[`TXDT_IDLE]     = 1'b1;

            // This condition is required for stream write transfer
            // when byte_count < 6.
            else if (transfer_mode && (byte_count_rem < 6)
                     && !dp_open_ended_xfer && stop_cmd_loaded) 
               begin
                 txdt_ns[`TXDT_SRACK]    = 1'b1;  // stop acked received
                 tx_new_count            = {18'h0,wait_count};
                 tx_load_counter         = 1'b1;
               end 
            else if ((fifo_empty || ~dp_cdata_in[0]) ||
                         (transfer_mode && (byte_count_rem < 6)
                          && !dp_open_ended_xfer))
                 txdt_ns[`TXDT_WFE]      = 1'b1;
            else
                 txdt_ns[`TXDT_WFE3]     = 1'b1;
          end

        txdt_cs[`TXDT_WFE3]: 
          begin
            if (stop_data)
              txdt_ns[`TXDT_IDLE] = 1'b1;
           else 
             begin
       //MMC4_4 start
               if(ddr) 
                 begin
                   txdt_ns[`TXDT_STBIT] = 1'b1;
                   tx_new_count      = 24'h1;
                   tx_load_counter   = 1'b1;
                 end  
               else if (ddr_8_mode) 
                 begin
                   if (cclk_in_en_ddr) 
                     begin
                       txdt_ns[`TXDT_STBIT] = 1'b1;
                       tx_new_count      = 24'h1;
                       tx_load_counter   = 1'b1;
                     end
                   else
                      txdt_ns[`TXDT_WFE3] = 1'b1;
                 end
               else 
                 txdt_ns[`TXDT_STBIT] = 1'b1;
             end 
          end

        txdt_cs[`TXDT_WAITNWR] : 
          begin
            if (stop_data)
              begin
                txdt_ns[`TXDT_IDLE]    = 1'b1;
                clr_ddr_8_r1           = 1'b1;
              end
            else 
              begin
                if (ddr_8_mode) 
                   begin
                     if (cclk_in_en_ddr & ddr_8_r2) 
                       begin
                         clr_ddr_8_r1           = 1'b1;
                         txdt_ns[`TXDT_STBIT]   = 1'b1;
                       end
                     else
                       txdt_ns[`TXDT_WAITNWR] = 1'b1;
                   end
                else
                  txdt_ns[`TXDT_STBIT]   = 1'b1;
              end

             set_ddr_8_r1 = cclk_in_en_ddr & ddr_8_mode;
          end

        txdt_cs[`TXDT_CHKBUSY] : 
          begin
            if ((byte_countrem_zero && (!dp_open_ended_xfer))
                || stop_data || suspend_data_cmd)
              txdt_ns[`TXDT_IDLE]    = 1'b1;
            else if (dp_cdata_in[0]) 
              begin
                txdt_ns[`TXDT_WAITNWR] = 1'b1;
              end
            else
              txdt_ns[`TXDT_CHKBUSY] = 1'b1;
          end

        txdt_cs[`TXDT_STBIT] : 
          begin
            if (stop_data)
              begin
                txdt_ns[`TXDT_ENDBIT]  = 1'b1;
                clr_ddr_8_r1           = 1'b1;
             end
            else if (transfer_mode)      // stream data transfer
              txdt_ns[`TXDT_STRDATA] = 1'b1;
      //MMC4_4 start
            else if(ddr_8_mode ? (ddr_8_r1 & cclk_in_en) : 
                               (((counter_zero && ddr_r2) || !ddr_r1)))
     //MMC4_4 ends
              begin
                txdt_ns[`TXDT_BLKDATA] = 1'b1;
                tx_new_count           = {8'h0,block_size};
                tx_load_counter        = 1'b1;
                clr_ddr_8_r1           = 1'b1;
              end
            else 
              begin
                txdt_ns[`TXDT_STBIT] = 1'b1;
              end 

            set_ddr_8_r1 = (cclk_in_en_ddr & ddr_8_mode);
          end

        txdt_cs[`TXDT_BLKDATA] : 
          begin
            if (stop_data)
              txdt_ns[`TXDT_ENDBIT]  = 1'b1;
            else if ((count_r == 1) && tx_byte_done) 
              begin
                txdt_ns[`TXDT_CRC16]   = 1'b1;
      //MMC4_4 start
                if(ddr_8)
                  tx_new_count    = 24'h1f;
                else
                  tx_new_count           = 24'hf;
      //MMC4_4 ends
                  tx_load_counter        = 1'b1;
              end 
            else
              txdt_ns[`TXDT_BLKDATA] = 1'b1;
          end

        txdt_cs[`TXDT_CRC16] : 
           begin
             if (stop_data)
               txdt_ns[`TXDT_ENDBIT] = 1'b1;
             else if (counter_zero)
               txdt_ns[`TXDT_ENDBIT] = 1'b1;
             else
               txdt_ns[`TXDT_CRC16]  = 1'b1;
           end

        txdt_cs[`TXDT_ENDBIT] : 
          begin
          // stop_data_r indicate data the data transfer is terminate
          // by stop/abort command and txdt_cs should go to idle
          // after transmission of data end bit
            if (stop_data_r || stop_data)
              txdt_ns[`TXDT_IDLE]   = 1'b1;
            else 
              begin
                if (ddr_8_mode) 
                  begin
                    if (cclk_in_en) 
                       begin
                         txdt_ns[`TXDT_RXCRC]  = 1'b1;
                         tx_new_count          = 24'h15;
                         tx_load_counter       = 1'b1;
                       end
                    else
                       txdt_ns[`TXDT_ENDBIT]  = 1'b1;
                  end
                else 
                  begin
                    txdt_ns[`TXDT_RXCRC]  = 1'b1;
                    //SD_3.0 start
                    tx_new_count          = 24'h15;
                    //SD_3.0 ends
                    tx_load_counter       = 1'b1;
                  end
              end
          end

        txdt_cs[`TXDT_RXCRC] : 
          begin
            if (tx_crcstbit_err || stop_data)
              txdt_ns[`TXDT_IDLE]    = 1'b1;
            else if (counter_zero)
              txdt_ns[`TXDT_CHKBUSY] = 1'b1;
            else
              txdt_ns[`TXDT_RXCRC]   = 1'b1;
          end

        txdt_cs[`TXDT_STRDATA] :
          begin
            if (stop_data)
              txdt_ns[`TXDT_ENDBIT] = 1'b1;
            else
              txdt_ns[`TXDT_STRDATA] = 1'b1;
          end

        // wait for start bit of stop command
        // to start bit of stream write data
        txdt_cs[`TXDT_SRACK] :
          begin
            if (counter_zero)
              txdt_ns[`TXDT_STBIT]   = 1'b1;
            else
              txdt_ns[`TXDT_SRACK]   = 1'b1;
          end

      endcase
    end

  assign wait_count = ((3'h6 - byte_count_rem[2:0])*8) - 2;

  // Data shift register combination logic
  //  4:1 mux and a decode for select lines
 //SD_3.0 start
 //card_width[2] and ddr trigger togather.
  assign shift_sel[0] = data_load_en || ((txdt_cs[`TXDT_BLKDATA] ||
                                          txdt_cs[`TXDT_STRDATA]) &&
                                         (card_width[0] & !ddr));
  assign shift_sel[1] = data_load_en || ((txdt_cs[`TXDT_BLKDATA] ||
                                          txdt_cs[`TXDT_STRDATA]) &&
                                         (card_width[1] & !ddr));
  assign shift_sel[2] = data_load_en || ((txdt_cs[`TXDT_BLKDATA]) &&
                                         (card_width[2] || ddr));
  //SD_3.0 ends
  // Register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
         begin
           stop_data_r          <= 1'b0;
           shift_reg            <= {`F_DATA_WIDTH{1'b0}};
           suspend_data_cmd     <= 1'b0;
           stop_cmd_loaded      <= 1'b0;
           assert_read_wait_r   <= 1'b0;
         end 
      else 
         begin
           if (cclk_in_en)
              begin
                stop_data_r        <= stop_data;
                assert_read_wait_r <= assert_read_wait;
              end
        //SD_3.0 start
    //MMC4_4 start
        if(ddr_8_mode? (cclk_in_en | cclk_in_en_ddr) : cclk_in_en) 
           begin
    //MMC4_4 ends
             if(shift_sel == 3'b001)
               shift_reg  <= {shift_reg[`F_DATA_WIDTH-2:0],1'b0}; // shift '1'
             else if(shift_sel == 3'b010)
               shift_reg  <= {shift_reg[`F_DATA_WIDTH-5:0],4'b0}; // shift '4'
             else if(shift_sel == 3'b100)
               shift_reg  <= {shift_reg[`F_DATA_WIDTH-9:0],8'b0}; // shift '8' for ddr + card width=8 bit wide
             else if(shift_sel == 3'b111 & !ddr) 
                begin //non-ddr bit arrengement in shift register
                  if (`F_DATA_WIDTH == 64) 
                     begin
                       shift_reg <= {fifo_rdata[7:0],fifo_rdata[15:8],fifo_rdata[23:16],
                                    fifo_rdata[31:24],fifo_rdata[39:32],fifo_rdata[47:40],
                                    fifo_rdata[55:48],fifo_rdata[63:56]};
                     end 
                  else 
                     begin
                       shift_reg <= {fifo_rdata[7:0],fifo_rdata[15:8],fifo_rdata[23:16],
                                 fifo_rdata[31:24]};
                     end
                end
             else if(shift_sel == 3'b111 & ddr) 
                begin //ddr bit arrengement in shift register
                  if (`F_DATA_WIDTH == 64) 
                     begin
                       shift_reg <= {fifo_rdata[7:4],fifo_rdata[15:12],fifo_rdata[3:0],
                                    fifo_rdata[11:8],fifo_rdata[23:20],fifo_rdata[31:28],
                       fifo_rdata[19:16],fifo_rdata[27:24],fifo_rdata[39:36],
                       fifo_rdata[47:44],fifo_rdata[35:32],fifo_rdata[43:40],
                       fifo_rdata[55:52],fifo_rdata[63:60],fifo_rdata[51:48],
                       fifo_rdata[59:56]};
                     end 
                  else 
                    begin
                      shift_reg <= {fifo_rdata[7:4],fifo_rdata[15:12],fifo_rdata[3:0],
                                   fifo_rdata[11:8],fifo_rdata[23:20],fifo_rdata[31:28],
                     fifo_rdata[19:16],fifo_rdata[27:24]};
                    end
                end
           end
        //SD_3.0 ends
        if (cclk_in_en && cp_cmd_suspend && cp_cmd_crc7_end)
          suspend_data_cmd   <= 1'b1;
        else if (txdt_cs[`TXDT_IDLE])
          suspend_data_cmd   <= 1'b0;

        if (cp_stop_cmd_loaded)
          stop_cmd_loaded    <= 1'b1;
        else if (cclk_in_en)
          stop_cmd_loaded    <= 1'b0;
      end
    end

  assign suspend_data_stop = (txdt_cs[`TXDT_CHKBUSY] && suspend_data_cmd);


  // Data transmit logic
  // serial data 8/4/1 and Start_bit or end_bit or
  // data P-bit driving - idle || wait for data or wait NWR or wait stop ack
 // In ddr mode 8 bits get selected even though the card width is 4 bit wide
 // i.e. card_width[1]
 //SD_3.0 start
  assign tx_serial_data = (((card_width[2] || ddr) ?
                            shift_reg[`F_DATA_WIDTH-1:`F_DATA_WIDTH-8] :
                            (card_width[1]) ?
                            {4'b0, shift_reg[`F_DATA_WIDTH-1:`F_DATA_WIDTH-4]} :
                            {8{shift_reg[`F_DATA_WIDTH-1]}}) &
                           {8{~txdt_cs[`TXDT_STBIT]}}) |
                            ({8{txdt_cs[`TXDT_ENDBIT] || txdt_cs[`TXDT_IDLE]||
                                txdt_cs[`TXDT_WFE] || txdt_cs[`TXDT_WAITNWR] ||
                                txdt_cs[`TXDT_SRACK] || txdt_cs[`TXDT_WFE3] ||
                                txdt_cs[`TXDT_WFE1] || txdt_cs[`TXDT_WFE2] ||
                                txdt_cs[`TXDT_RXCRC] || txdt_cs[`TXDT_CHKBUSY]}});
   //SD_3.0 ends
  
//   `ifdef MMC_ONLY
//   assign dp_cdata_out[0]     = (txdt_cs[`TXDT_CRC16]) ? serial_crc[0] :
//                                                         tx_serial_data[0];
//   `else
  assign dp_cdata_out[1:0]   = ((txdt_cs[`TXDT_CRC16]) ? serial_crc[1:0] :
                                                         tx_serial_data[1:0]);

  assign dp_cdata_out[2]     = (((txdt_cs[`TXDT_CRC16]) ? serial_crc[2] :
                                 tx_serial_data[2]) && ~assert_read_wait);


  assign dp_cdata_out[7:3]   = ((txdt_cs[`TXDT_CRC16]) ? serial_crc[7:3] :
                                tx_serial_data[7:3]);

  assign dp_cdata_out_en[1]  = dp_cdata_out_en[0] && (card_width[1]
                                                      || card_width[2]);

  assign dp_cdata_out_en[2]  = (dp_cdata_out_en[0] &&
                                (card_width[1] || card_width[2])) ||
                               (assert_read_wait_r || assert_read_wait);

  assign dp_cdata_out_en[3]  = dp_cdata_out_en[0] && (card_width[1]
                                                      || card_width[2]);
//SD_3.0 start
  assign dp_cdata_out_en[7:4] = {4{dp_cdata_out_en[0] && (card_width[2])}};
//SD_3.0 ends
//   `endif

  assign dp_cdata_out_en[0]   = (txdt_cs[`TXDT_WFE] && dp_cdata_in[0]) ||
                                txdt_cs[`TXDT_STBIT]   ||
                                txdt_cs[`TXDT_BLKDATA] ||
                                txdt_cs[`TXDT_CRC16]   ||
                                txdt_cs[`TXDT_STRDATA] ||
                                txdt_cs[`TXDT_ENDBIT]  ||
                                txdt_cs[`TXDT_SRACK]   ||
                                txdt_cs[`TXDT_WFE3]    ||
                                txdt_cs[`TXDT_WAITNWR];

  //Data tx logic counter assignments
  assign tx_dec_counter      = (( txdt_cs[`TXDT_BLKDATA] ||
                                 txdt_cs[`TXDT_STRDATA]) &&
                                tx_byte_done) || txdt_cs[`TXDT_CRC16] ||
                                txdt_cs[`TXDT_RXCRC] ||
                                txdt_cs[`TXDT_SRACK] || txdt_cs[`TXDT_STBIT];

  // CRC16 control logic
  assign tx_start_crc        = txdt_cs[`TXDT_STBIT];
  assign tx_send_crc         = txdt_cs[`TXDT_CRC16];
  assign tx_serial_data_en   = txdt_cs[`TXDT_BLKDATA];
  assign tx_data_end_bit     = txdt_cs[`TXDT_ENDBIT];
  assign txdt_idle           = txdt_cs[`TXDT_IDLE];

  // This request is send to auto stop module to send auto stop request
  // for stream write when byte_count < 6.
  assign txdt_stop_load_req  = txdt_cs[`TXDT_WFE] &&
                               !fifo_empty && transfer_mode &&
                               (byte_count_rem < 6) && !dp_open_ended_xfer;

  assign tx_data_done        = (~txdt_cs[`TXDT_IDLE] && txdt_ns[`TXDT_IDLE]);

  assign tx_dat0_busy        = ((txdt_cs[`TXDT_CHKBUSY] || txdt_cs[`TXDT_WFE])
                                && ~dp_cdata_in[0]);

  // Data transmit bit counter
  // tx_byte_done is compared == 6 since tx_bit_cnt_r == registered value
 //SD_3.0 start
  assign tx_byte_done = (((card_width[0] && tx_bit_cnt_r == 3'h7) ||
                          (card_width[1] && (tx_bit_cnt_r == 3'h4)) ||
                          ((card_width[2] || ddr) && txdt_cs[`TXDT_BLKDATA])) &&
                         !(txdt_cs[`TXDT_ENDBIT]));

  assign tx_bit_cnt_d  = !(txdt_cs[`TXDT_STRDATA] || txdt_cs[`TXDT_BLKDATA]) ?
                            3'h0 : (card_width[2] || ddr) ? 3'h7 :
                            (card_width[1]) ? tx_bit_cnt_r + 3'h4 :
                            (card_width[0]) ? tx_bit_cnt_r + 3'h1 : 0;
//SD_3.0 ends

  // TX bit counter
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        tx_bit_cnt_r   <= 3'b0;
      else 
        begin
          if (cclk_in_en) 
             begin
               tx_bit_cnt_r <= tx_bit_cnt_d;
             end
        end
    end


  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        rx_crc_r   <= 3'h0;
      else 
        begin
          if (cclk_in_en)
            rx_crc_r <= {rx_crc_r[1:0],dp_cdata_in[0]};
        end
    end

//SD_3.0 start
// CRC status logic has been changes such that the CRC staus can come any where between 2 to 8 clk cycles.
// Below changes are mode to habdle that.
  `define       CRC_IDLE           0
  `define       CRC_START_BIT      1      // Wait FIFO Empty
 `define       CRC_BIT_0          2
 `define       CRC_BIT_01         3
 `define       CRC_BIT_010        4
  `define       CRC_END_BIT        5      // Tx data start bit
   reg          [5:0]crcst_cs;
  reg          [5:0]crcst_ns;
  reg           crc_error;
  
   always @ (posedge cclk_in or negedge creset_n)
     begin
       if (~creset_n)
         crcst_cs     <= 5'h1; // idle
       else 
         begin
           if(cclk_in_en)
              crcst_cs   <= crcst_ns;
         end
     end

  always @(txdt_cs or count_r or crcst_cs)
    begin
       if (crcst_cs[`CRC_START_BIT] & ((txdt_cs[`TXDT_RXCRC] && (count_r==0)) | txdt_cs[`TXDT_IDLE]))
         tx_crcstbit_err      = 1'b1;
        else
         tx_crcstbit_err      = 1'b0;
     end

 always @ (dp_cdata_in or count_r or txdt_cs or crcst_cs or txdt_ns or ddr or ddr_4_mode or ddr_8_mode)
    begin : FSM_crcst
      crcst_ns          = {1'b0,4'h0};
      crc_error         = 1'b0;
      tx_data_crc_error = 1'b0;

      case (1'b1)
        crcst_cs[`CRC_IDLE] : 
          begin
    // moves out of IDLe only when the  txdt state machine moves from CRC END BIT to CRC status state.
            if((txdt_ns[`TXDT_RXCRC]) && (txdt_cs[`TXDT_ENDBIT])) 
              begin
                crcst_ns[`CRC_START_BIT] = 1'b1;
              end
            else 
               crcst_ns[`CRC_IDLE] = 1'b1;
          end  

        crcst_cs[`CRC_START_BIT] :  
           begin
             if(txdt_cs[`TXDT_RXCRC] && (dp_cdata_in[0]== 1'b0) &&  (((ddr_4_mode | ddr_8_mode) && (count_r <= 24'h12) && (count_r > 24'h4)) || (!(ddr_4_mode | ddr_8_mode) && (count_r > 3) && (count_r < 24'h13)))) 
                begin
                    crcst_ns[`CRC_BIT_0] = 1'b1;
                end
             else if ((txdt_cs[`TXDT_RXCRC] && (count_r==0)) | txdt_cs[`TXDT_IDLE])
                begin
                  crcst_ns[`CRC_IDLE]  = 1'b1;
                end
             else 
               begin
                 crcst_ns[`CRC_START_BIT]  = 1'b1;
               end
           end
    
        crcst_cs[`CRC_BIT_0]: 
           begin
              if(txdt_cs[`TXDT_RXCRC] && (dp_cdata_in[0]== 1'b0)) 
                begin
                  crcst_ns[`CRC_BIT_01] = 1'b1;
                end
              else 
                begin
                 crcst_ns[`CRC_IDLE] = 1'b1;
                 tx_data_crc_error   = 1'b1;
                end
           end

    crcst_cs[`CRC_BIT_01]:
       begin
         if(txdt_cs[`TXDT_RXCRC] && (dp_cdata_in[0]== 1'b1)) 
           begin
             crcst_ns[`CRC_BIT_010] = 1'b1;
           end
         else 
           begin
             crcst_ns[`CRC_IDLE] = 1'b1;
             tx_data_crc_error   = 1'b1;
           end   
       end

    crcst_cs[`CRC_BIT_010]: 
       begin
         if(txdt_cs[`TXDT_RXCRC] && (dp_cdata_in[0]== 1'b0)) 
            begin
              crcst_ns[`CRC_END_BIT] = 1'b1;
            end
         else 
            begin
              crcst_ns[`CRC_IDLE] = 1'b1;
              tx_data_crc_error   = 1'b1;
            end   
       end
    
    crcst_cs[`CRC_END_BIT]:
       begin
         if(txdt_cs[`TXDT_RXCRC] && (dp_cdata_in[0]== 1'b1))
           begin
             crcst_ns[`CRC_IDLE] = 1'b1;
           end   
         else 
           begin
             crcst_ns[`CRC_IDLE] = 1'b1;
             tx_data_crc_error = 1'b1; 
           end   
       end
    endcase 
  end
        
        
//SD_3.0 ends
  

  assign start_tx_data = txdt_cs[`TXDT_WFE] && dp_cdata_in[0];

  assign cclk_in_en_txfiford = ddr_8_mode ? (cclk_in_en | cclk_in_en_ddr): cclk_in_en;

  // FIFO Read module
  DWC_mobile_storage_txfiford
   U_DWC_mobile_storage_txfiford
    (
     // Outputs
     .fifo_pop                          (fifo_pop),
     .data_load_en                      (data_load_en),
     .tx_stop_clk                       (tx_stop_clk),
     // Inputs
     .creset_n                          (creset_n),
     .cclk_in                           (cclk_in),
     .cclk_in_en                        (cclk_in_en_txfiford),
     .stop_data                         (stop_data),
     .fifo_empty                        (fifo_empty),
     .fifo_almost_empty                 (fifo_almost_empty),
     .start_tx_data                     (start_tx_data),
     .tx_byte_done                      (tx_byte_done),
     .tx_bit_cnt_r                      (tx_bit_cnt_r[2:0]),
     .dp_card_wide_bus                  (dp_card_wide_bus),
     .dp_open_ended_xfer                (dp_open_ended_xfer),
     .byte_countrem_zero                (byte_countrem_zero),
     .suspend_data_stop                 (suspend_data_stop),
     .byte_count_rem                    (byte_count_rem[31:0]),
     .count_r                           (count_r),
   //SD_3.0 start
     .ddr                               (ddr),
   //SD_3.0 ends
     .dscrd_cur_xfer                    (dscrd_cur_xfer));

endmodule // DWC_mobile_storage_datatx
