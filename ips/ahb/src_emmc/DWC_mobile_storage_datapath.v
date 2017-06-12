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
// Date             :        $Date: 2013/01/22 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_datapath.v#32 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_datapath.v
// Description : DWC_mobile_storage Data Path block
//               Registers data parameters
//               Data transit and data recieved modules
//               are instantiated for data transfer
//               crc16 module and byte counter is shared
//               by data rx and data tx modules.
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_datapath(
  /*AUTOARG*/
  // Outputs
  data_trans_done, rx_data_timeout,rx_data_timeout_internal , data_crc_err, fifo_pop, fifo_push,
  c2b_fifo_wdata, rx_stbit_err, c2b_trans_bytes, tx_crcstbit_err,
  rx_data_endbit_err, dp_data_idle, dp_cdata_out, dp_cdata_out_en,
  dp_load_stop_cmd_req, dp_open_ended_xfer, transfer_mode, data_timeout_cnt,
  dp_stop_clk, tx_data_done, rx_data_done, rx_data_end_bit, tx_data_end_bit,
  dp_card_wide_bus, read_write_xfer, tx_dat0_busy, rx_dat0_busy,
  byte_countrem_zero, auto_stop_en, abort_read_data_r, suspend_data_cmd,
  data_trans_cmd, c2b_trans_bytes_bin,
  boot_ack_error,rx_end_bit,bar_intr,boot_ack_timeout,boot_data_timeout,
  //SD_3.0 start
  ddr_rx_states,
 //MMC4_4 start
 ddr_8_rx_states, no_clock_stop_ddr_8,
  ddr_8_tx_states,
 //MMC4_4 end
 ddr_tx_states, start_rx_data,
  //SD_3.0 end
  // Inputs
  cclk_in, cclk_in_en, creset_n, read_wait, b2c_card_width,
  fifo_full, fifo_empty, fifo_almost_full, fifo_almost_empty, 
  fifo_rdata, b2c_block_size, b2c_byte_count, b2c_data_tmout_cnt, 
  abort_read_data, dp_cdata_in,
 //MMC4_4 start
 ddr_8, cclk_in_en_8_ddr,cp_card_num, toggle, cclk_in_en_ddr, stop_clk_ddr_8,card_rd_threshold_en,
  stop_clk_in_en,atleast_empty,
 //MMC4_4 end
 //SD_3.0 start
  de_interleave,
 //SD_3.0 end
 cp_cmd_end_bit, cp_resp_end_bit, cp_cmd_suspend, resp_timeout, 
  cp_load_data_par, cp_stop_cmd_loaded, cp_stop_abort_cmd,
  cp_cmd_crc7_end, ccs_expected, read_ceata_device, cmd_compl_signal, 
  data_expected_r, b2c_cmd_control,
 //SD_3.0 start
 ddr,ddr_4_mode,ddr_8_mode,
  //SD_3.0 end
        //eMMC 4.5 start
        half_start_bit,
        //eMMC 4.5 end
 exp_boot_ack,exp_boot_ack_pulse,exp_boot_data,exp_boot_data_pulse, 
  end_boot,end_boot_pulse,new_cmd_loaded,start_bit_delayed
  );

  // -----------------l---------------------
  // Input and Output lPort Declaration
  // --------------------------------------

  // Clock and Reset
  input                      cclk_in;          // Clock
  input                      cclk_in_en;       // Clock enable
  input                      creset_n;         // Card Reset - Active Low

  // inputs from BIU
  input                      read_wait;        // Read Wait
  input[`NUM_CARD_BUS*2-1:0] b2c_card_width;   // Card width
  input                      fifo_full;        // FIFO full
  input                      fifo_empty;       // FIFO empty
  input                      fifo_almost_full; // FIFO almost full
  input                      fifo_almost_empty;// FIFO almost empty

  input               [63:0] fifo_rdata;       // FIFO read data
  input               [15:0] b2c_block_size;   // Data transfer block size
  input               [31:0] b2c_byte_count;   // Data transfer byte count
  input               [23:0] b2c_data_tmout_cnt; // Read data timeout
  input                      abort_read_data;  // Abort read data
 //SD_3.0 start
  input               [28:0] b2c_cmd_control;  // Command control register
  input                      ddr;              // Indicates 4-bit DDR mode of operation during data transfer
 input                      ddr_4_mode;       // Indicates 4-bit DDR mode of operation in full transfer
  input                      ddr_8_mode;       // Indicates 8-bit DDR mode of operation
 //MMC4_4 start
 input                      ddr_8;            // Indicates the data to/from the card 
                                               // is in 8-bit DDR format
 input                      cclk_in_en_8_ddr; // Multiplexed cclk_in_en or cclk_in_en_ddr
 input            [3:0]     cp_card_num;
 input  [`NUM_CARD_BUS-1:0] toggle;
  input                      cclk_in_en_ddr;   // 
  input                      stop_clk_ddr_8;   // Stop clock signal used only in 8-bit
                                               // DDR mode
  input                      stop_clk_in_en;   // Stop clock signal used only in 8-bit
                                               // DDR mode. This is same as stop_clk_ddr_8
                                               // but delayed version
 input                      card_rd_threshold_en;
                       
 //MMC4_4 end
 //SD_3.0 start
  input                     exp_boot_ack;        //boot ack pattern expected indication
  input                     exp_boot_ack_pulse;  //Pulse indication of exp_boot_ack
  input                     exp_boot_data;       //Level indication of exp_boot_data
  input                     exp_boot_data_pulse; //Pulse indication of exp_boot_data
  input                     end_boot;            //end boot indication
  input                     end_boot_pulse;      //end boot indication pulse
  input                     new_cmd_loaded;
  input                     atleast_empty;
 //MMC 4.5 start
  input                     start_bit_delayed;
  input                     half_start_bit;
  //MMC 4.5 ends
  // outputs to BIU
  output                     data_trans_done;     // Data transfer done
  output                     rx_data_timeout;     // Read data time out occured + boot data start
 output                     rx_data_timeout_internal; //Read data time out only
  output                     data_crc_err;        // Data crc error
  output                     fifo_pop;            // FIFO pop
  output                     fifo_push;           // FIFO push
  output [`F_DATA_WIDTH-1:0] c2b_fifo_wdata;      // FIFO write data
  output                     rx_stbit_err;        // Read data start incorrect
  output              [31:0] c2b_trans_bytes;     // Transfered byte count-gray
  output              [31:0] c2b_trans_bytes_bin; // Transf byte count-binary
  output                     tx_crcstbit_err;     // No crc status start bit
  output                     rx_data_endbit_err;  // RX data end bit error
  output                     dp_data_idle;        // Data path idle

  //  Card Interface
  input                [7:0] dp_cdata_in;        // Card Data Input during non DDR
 input                [7:0] de_interleave;      // card data input during DDR.
  output               [7:0] dp_cdata_out;       // Card Data Output
  output               [7:0] dp_cdata_out_en;    // Card Data Output Enable

  // Command Path Ports
  input                      cp_cmd_end_bit;     // Command tx end bit
  input                      cp_resp_end_bit;    // Response end bit
  input                      cp_cmd_suspend;     // Command suspend
  input                      resp_timeout;       // Cmd response timeout
  input                      cp_load_data_par;   // Load data paramaters
  input                      cp_stop_cmd_loaded; // Auto stop cmd is loaded
  input                      cp_stop_abort_cmd;  // Command stop/io abort
  input                      cp_cmd_crc7_end;    // Last bit of CRC7 of cmd
  input                      ccs_expected;       // CCS expected for the cur cmd
  input                      read_ceata_device;  // CE-ATA Read data transfer
  input                      cmd_compl_signal;   // CCS from CE-ATA device
  input                      data_expected_r;    // Cclk_in registered b2c_cmd_control[9]


  // output
  output                     dp_load_stop_cmd_req;// Load stop command req
  output                     dp_open_ended_xfer;  // Open ended transfer
  output                     transfer_mode;       // Data transfer type

  // clock control interface
  output              [23:0] data_timeout_cnt;    // Data timeout
  output                     dp_stop_clk;         // Stop clock

  // interrupt control port
  output                     tx_data_done;        // TX data transfer done
  output                     rx_data_done;        // RX data transfer done
  output                     rx_data_end_bit;     // Receive data end bit
  output                     tx_data_end_bit;     // Transmit data end bit
  output               [1:0] dp_card_wide_bus;    // Card bus width
  output                     read_write_xfer;     // Read/write data transfer
  output                     byte_countrem_zero;  // Byte_cnt becomes zero
  output                     auto_stop_en ;       // Autostop generate enable
  output                     abort_read_data_r;   // Abort read data registered
  output                     suspend_data_cmd;    // Suspend command
  output                     data_trans_cmd;      // Data transfer command
  output                    boot_ack_error;      // Error in the boot acknowledgement.
  output                    rx_end_bit;          // rxdt_cs[`RXDT_ENDBIT]\
  output                    bar_intr;            // Boot ack received(BAR) interrupt
  output                    boot_ack_timeout;    // Boot Ack timeout
  output                    boot_data_timeout;   // Boot data timeout                   
//SD_3.0 start
  output                    ddr_rx_states;       // Output from datarx block. used as a qualifier to generate DDR signal.
 //MMC4_4 start
 output                    ddr_8_rx_states;     // Indicates that RXFSM is receiving 8-bit
                                                 // DDR data.
  output                    ddr_8_tx_states;     // Indicates that TXFSM is transmitting 8-bit
                                                 // DDR data.
  output                    no_clock_stop_ddr_8; // Indication to clkcntl module not to stop
                                                 // the clock while receiving CRC16 during read
                                                 // from card
  //MMC4_4 end
 output                    ddr_tx_states;       // Output from datarx block. used as a qualifier 
                                                 // to generate 4-bit DDR signal. 
 
 output                    start_rx_data;
//SD_3.0 end

  // CIU status siganls
  output                     tx_dat0_busy;        // Card data busy busy
  output                     rx_dat0_busy;        // Card data busy busy

  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Registers
  reg                        transfer_mode;     // Stream/block data transfer
  reg                        read_write_xfer;   // Read/write data transfer
  reg                        send_auto_stop;    // Send auto stop command
  reg                        data_expected;     // Data expected
  reg                  [1:0] dp_card_wide_bus;  // Card width
  reg                 [15:0] block_size;        // Data transfer block size
  reg                 [31:0] byte_count_rem;    // Data transfer byte count
  reg                 [23:0] data_timeout_cnt;  // Read data timeout
  reg                        dp_open_ended_xfer;// Open ended data Xfer
  reg                        cp_load_data_par_r;// Load load par reg
  reg                 [31:0] c2b_trans_bytes;   // Xfer byte count-gray
  reg                 [31:0] c2b_trans_bytes_bin; // Data transfer bytes-binary
  reg                 [31:0] card_width_tmp;    // Card width tmp
  reg                 [23:0] count_r;           // Data path counter reg
  reg                        cp_cmd_end_bit_r;  // Registered cmd end bit
  reg                        cp_cmd_end_bit_r1; // Registered cmd end bit
  reg                        data_trans_cmd;    // Command with data transfer
  reg                        data_trans_done;   // Data transfer done

  wire                       stop_data;         // Stop data Xfer stop cmd
  wire                       stop_data_w;       // Stop data (unregistered)
  wire                       rx_data_done;      // RX data done
  wire                       rx_data_done_r;    // RX data done after fifo idle
  wire                       rx_byte_done;      // RX byte done
  wire                 [7:0] serial_data;       // Serial data
 //MMC4_4 start
 wire                  [7:0] serial_data_1;       // Serial data
  wire                  [7:0] serial_data_2;       // Serial data
  //MMC4_4 end
  wire                       byte_countrem_zero;// Byte count remaining
  wire                       auto_stop_en ;     // Autostop generate enable
  wire                       dp_data_idle;      // Data path idle


  // wire for tx state machine counter
  wire                       counter_zero;    // Counter zero
  wire                [23:0] new_count;       // New count
  wire                [23:0] tx_new_count;    // New count
  wire                       tx_load_counter; // Load counter
  wire                       tx_dec_counter;  // Dec counter
  wire                [23:0] rx_new_count;    // New count
  wire                       rx_load_counter; // Load counter
  wire                       rx_dec_counter;  // Dec counter

  // reg/wires for crc16
  reg                   [7:0] serial_crc;      // Serial crc16
 //MMC4_4 start
 wire                  [7:0] serial_crc_1;      // Serial crc16
 wire                  [7:0] serial_crc_2;      // Serial crc16
  wire                        cclk_in_en_crc1;
  wire                        cclk_in_en_crc2;
  //MMC4_4 end

  wire                 [7:0] tx_serial_data;  // TX serial data
  wire                       tx_start_crc;    // TX start crc16
  wire                       tx_send_crc;     // TX send crc16
  wire                 [7:0] rx_serial_data;  // RX serial data
  wire                       rx_start_crc;    // RX start crc16
  wire                       rx_send_crc;     // RX send crc16
  wire                [31:0] trans_bytes_inc; // Transfer byte + 1
  wire                       start_crc;       // Start CRC wire
  wire                       send_crc;        // Send CRC wire
  wire                 [3:0] sel_card_num;    // Selected card number
  wire                       data_done_tmp;  // Data transfer done


  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire                  assert_read_wait;       // From U_DWC_mobile_storage_datarx
  wire [2:0]            rx_bit_cnt_r;           // From U_DWC_mobile_storage_datarx
  wire                  rx_data_crc_error;      // From U_DWC_mobile_storage_datarx
  wire                  rx_stop_clk;            // From U_DWC_mobile_storage_datarx
  wire                  rxdt_idle;              // From U_DWC_mobile_storage_datarx
  wire                  abort_read_data_r;      // From U_DWC_mobile_storage_datarx
  wire [2:0]            tx_bit_cnt_r;           // From U_DWC_mobile_storage_datatx
  wire                  tx_byte_done;           // From U_DWC_mobile_storage_datatx
  wire                  tx_data_crc_error;      // From U_DWC_mobile_storage_datatx
  wire                  tx_serial_data_en;      // From U_DWC_mobile_storage_datatx
  wire                  tx_stop_clk;            // From U_DWC_mobile_storage_datatx
  wire                  txdt_idle;              // From U_DWC_mobile_storage_datatx
  wire                  txdt_stop_load_req;     // From U_DWC_mobile_storage_datatx
  wire                  dscrd_cur_xfer;
  wire                  start_bit_delayed;

  // End of automatics
  integer               i;

  // Register load data parameters
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        cp_load_data_par_r   <= 1'b0;
        cp_cmd_end_bit_r     <= 1'b0;
        cp_cmd_end_bit_r1    <= 1'b0;
      end else begin
        if (cp_load_data_par)
          cp_load_data_par_r <= 1'b1;
        else if (cclk_in_en)
          cp_load_data_par_r <= 1'b0;

        if (cclk_in_en) begin
          cp_cmd_end_bit_r   <= cp_cmd_end_bit;
          cp_cmd_end_bit_r1  <= cp_cmd_end_bit_r;
        end
      end
    end

  assign sel_card_num = b2c_cmd_control[19:16];

  //Data parameter register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        transfer_mode        <= 1'b0;
        read_write_xfer      <= 1'b0;
        send_auto_stop       <= 1'b0;
        dp_card_wide_bus     <= 2'b0;
        block_size           <= 16'h0;
        data_timeout_cnt     <= {24{1'h1}};
        dp_open_ended_xfer   <= 1'b0;
      end else begin
        if (cp_load_data_par) begin
          transfer_mode      <= b2c_cmd_control[11];
          read_write_xfer    <= b2c_cmd_control[10];
          send_auto_stop     <= b2c_cmd_control[12];
          dp_card_wide_bus[0] <= card_width_tmp[sel_card_num];
          dp_card_wide_bus[1] <= card_width_tmp[sel_card_num+`NUM_CARD_BUS];
          block_size         <= b2c_block_size;
          data_timeout_cnt   <= b2c_data_tmout_cnt;
          dp_open_ended_xfer <= (b2c_byte_count == 0);
        end
      end
    end

  // Data transfer expected is set according to new command
  // and reset when data transfer is done.
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        data_expected     <= 1'b0;
        data_trans_cmd    <= 1'b0;
        data_trans_done   <= 1'b0;
      end else begin
        if (cp_load_data_par)
          data_expected        <= b2c_cmd_control[9];
        else if (data_done_tmp)
          data_expected        <= 1'b0;

        if (cp_cmd_end_bit && data_expected && dp_data_idle)
          data_trans_cmd <= 1'b1;
        else if (cclk_in_en && cp_resp_end_bit)
          data_trans_cmd <= 1'b0;

        if (ccs_expected)
          data_trans_done <= cclk_in_en && cmd_compl_signal;
        else
          data_trans_done  <= ((ddr_8_mode? (cclk_in_en | cclk_in_en_ddr) : cclk_in_en) && 
                               (rx_data_done_r || tx_data_done));
      end
    end

  // In case CCS is received from the device, when the byte 
  // count is still not exhausted, then the Data Tx & Rx FSMs
  // have to be sent to idle
  assign dscrd_cur_xfer = |(byte_count_rem) & data_trans_done;

  // Temporary matching of b2c_card_width to card_width_tmp
  always @ (/*AUTOSENSE*/ b2c_card_width)
    begin
      card_width_tmp = 32'b0;
      card_width_tmp[`NUM_CARD_BUS*2-1:0] = b2c_card_width[`NUM_CARD_BUS*2-1:0];
    end

  assign auto_stop_en      = data_expected && send_auto_stop;

  assign stop_data_w       = cp_stop_abort_cmd &&  cp_cmd_end_bit;
  assign stop_data         = cp_stop_abort_cmd &&  cp_cmd_end_bit_r1;

  assign dp_data_idle      = txdt_idle         &&  rxdt_idle;
  assign data_crc_err      = tx_data_crc_error ||  rx_data_crc_error;

  assign data_done_tmp     = rx_data_done      ||  tx_data_done;
  assign dp_stop_clk       = tx_stop_clk       ||  rx_stop_clk;

  // Data transmit module
  DWC_mobile_storage_datatx
    U_DWC_mobile_storage_datatx
    (/*AUTOINST*/
     // Outputs
     .dp_cdata_out                      (dp_cdata_out),
     .dp_cdata_out_en                   (dp_cdata_out_en),
     .tx_data_end_bit                   (tx_data_end_bit),
     .tx_byte_done                      (tx_byte_done),
     .tx_bit_cnt_r                      (tx_bit_cnt_r[2:0]),
     .tx_data_crc_error                 (tx_data_crc_error),
     .tx_crcstbit_err                   (tx_crcstbit_err),
     .txdt_idle                         (txdt_idle),
     .tx_data_done                      (tx_data_done),
     .tx_dat0_busy                      (tx_dat0_busy),
     .tx_stop_clk                       (tx_stop_clk),
     .fifo_pop                          (fifo_pop),
     .tx_new_count                      (tx_new_count[23:0]),
     .tx_load_counter                   (tx_load_counter),
     .tx_dec_counter                    (tx_dec_counter),
     .tx_serial_data                    (tx_serial_data),
     .tx_start_crc                      (tx_start_crc),
     .tx_send_crc                       (tx_send_crc),
     .tx_serial_data_en                 (tx_serial_data_en),
     .suspend_data_cmd                  (suspend_data_cmd),
     .txdt_stop_load_req                (txdt_stop_load_req),
   //SD_3.0 start
   .ddr_tx_states                     (ddr_tx_states),
   //SD_3.0 end
   .ddr_8_tx_states                   (ddr_8_tx_states),
     // Inputs
     .creset_n                          (creset_n),
     .cclk_in                           (cclk_in),
     .cclk_in_en                        (cclk_in_en),
     .fifo_rdata                        (fifo_rdata),
     .fifo_empty                        (fifo_empty),
     .fifo_almost_empty                 (fifo_almost_empty),
     .stop_data                         (stop_data_w),
     .cp_stop_cmd_loaded                (cp_stop_cmd_loaded),
     .cp_cmd_suspend                    (cp_cmd_suspend),
     .cp_resp_end_bit                   (cp_resp_end_bit),
     .dp_card_wide_bus                  (dp_card_wide_bus),
     .block_size                        (block_size[15:0]),
     .byte_count_rem                    (byte_count_rem[31:0]),
     .data_expected                     (data_expected),
     .transfer_mode                     (transfer_mode),
     .dp_open_ended_xfer                (dp_open_ended_xfer),
     .byte_countrem_zero                (byte_countrem_zero),
     .read_write_xfer                   (read_write_xfer),
     .dp_cdata_in                       (dp_cdata_in),
     .count_r                           (count_r[23:0]),
     .counter_zero                      (counter_zero),
     .serial_crc                        (serial_crc),
     .cp_cmd_crc7_end                   (cp_cmd_crc7_end),
     .assert_read_wait                  (assert_read_wait),
     .dscrd_cur_xfer                    (dscrd_cur_xfer),
   //MMC4_4 start
   .cclk_in_en_8_ddr                  (cclk_in_en_8_ddr),
   .cclk_in_en_ddr                    (cclk_in_en_ddr),
   .ddr_8                             (ddr_8),
   //MMC4_4 end
   //SD_3.0 start
   .ddr                               (ddr),
   .ddr_4_mode                        (ddr_4_mode),
     .ddr_8_mode                        (ddr_8_mode));
   //SD_3.0 end

  // Data receive module
  DWC_mobile_storage_datarx
   U_DWC_mobile_storage_datarx
    (/*AUTOINST*/
     // Outputs
     .rx_data_end_bit                   (rx_data_end_bit),
     .rx_byte_done                      (rx_byte_done),
     .rx_data_crc_error                 (rx_data_crc_error),
     .rx_data_endbit_err                (rx_data_endbit_err),
     .fifo_push                         (fifo_push),
     .rx_stop_clk                       (rx_stop_clk),
     .rx_bit_cnt_r                      (rx_bit_cnt_r[2:0]),
     .rx_data_done                      (rx_data_done),
     .rx_data_done_r                    (rx_data_done_r),
     .rx_stbit_err                      (rx_stbit_err),
     .rx_data_timeout                   (rx_data_timeout),
   .rx_data_timeout_internal          (rx_data_timeout_internal),
     .c2b_fifo_wdata                    (c2b_fifo_wdata[`F_DATA_WIDTH-1:0]),
     .rx_dat0_busy                      (rx_dat0_busy),
     .rxdt_idle                         (rxdt_idle),
     .assert_read_wait                  (assert_read_wait),
     .rx_new_count                      (rx_new_count[23:0]),
     .rx_load_counter                   (rx_load_counter),
     .rx_dec_counter                    (rx_dec_counter),
     .rx_serial_data                    (rx_serial_data),
     .rx_start_crc                      (rx_start_crc),
     .rx_send_crc                       (rx_send_crc),
     .abort_read_data_r                 (abort_read_data_r),
     .boot_ack_error                    (boot_ack_error),      
     .rx_end_bit                        (rx_end_bit),  
     .bar_intr                          (bar_intr),
     .boot_ack_timeout                  (boot_ack_timeout),
     .boot_data_timeout                 (boot_data_timeout),
   //SD_3.0 start
   .ddr_rx_states                     (ddr_rx_states),
   //MMC4_4 start
   .ddr_8_rx_states                   (ddr_8_rx_states),
     .stop_clk_ddr_8                    (stop_clk_ddr_8),
   //MMC4_4 end
     .start_rx_data                     (start_rx_data),
   //SD_3.0 end
     // Inputs
   //MMC4_4 start
   .cclk_in_en_8_ddr                  (cclk_in_en_8_ddr),
   .cclk_in_en_ddr                    (cclk_in_en_ddr),
   .cp_card_num                       (cp_card_num[3:0]),
   //MMC4_4 end
     .creset_n                          (creset_n),
     .cclk_in                           (cclk_in),
     .cclk_in_en                        (cclk_in_en),
     .fifo_full                         (fifo_full),
     .fifo_almost_full                  (fifo_almost_full),
     .block_size                        (block_size[15:0]),
     .byte_count_rem                    (byte_count_rem[31:0]),
     .stop_data                         (stop_data),
     .transfer_mode                     (transfer_mode),
     .dp_card_wide_bus                  (dp_card_wide_bus),
     .dp_cdata_in                       (dp_cdata_in),
   //SD_3.0 start
     .de_interleave                     (de_interleave),
   //SD_3.0 end
     .byte_countrem_zero                (byte_countrem_zero),
     .dp_open_ended_xfer                (dp_open_ended_xfer),
     .cp_stop_cmd_loaded                (cp_stop_cmd_loaded),
     .cp_cmd_end_bit                    (cp_cmd_end_bit),
     .read_wait                         (read_wait),
     .data_timeout_cnt                  (data_timeout_cnt[23:0]),
     .data_expected                     (data_expected),
     .read_write_xfer                   (read_write_xfer),
     .abort_read_data                   (abort_read_data),
     .resp_timeout                      (resp_timeout),
     .cp_resp_end_bit                   (cp_resp_end_bit),
     .count_r                           (count_r[23:0]),
     .counter_zero                      (counter_zero),
   .read_ceata_device                 (read_ceata_device),
     .dscrd_cur_xfer                    (dscrd_cur_xfer),
     .b2c_cmd_control                   (b2c_cmd_control),
     .exp_boot_ack                      (exp_boot_ack),
     .exp_boot_ack_pulse                (exp_boot_ack_pulse),
     .exp_boot_data                     (exp_boot_data),
     .exp_boot_data_pulse               (exp_boot_data_pulse), 
     .end_boot                          (end_boot),
     .end_boot_pulse                    (end_boot_pulse),
     .new_cmd_loaded                    (new_cmd_loaded),
   //MMC4_4 start
   .ddr_8_mode                        (ddr_8_mode),
   .ddr_8                             (ddr_8),
     .serial_crc_1                      (serial_crc_1),
   .serial_crc_2                      (serial_crc_2),
     .card_rd_threshold_en              (card_rd_threshold_en),
    .atleast_empty                     (atleast_empty),
   //MMC4_4 end
   //SD_3.0 start
      .ddr                               (ddr),
      .ddr_4_mode                        (ddr_4_mode),
   //SD_3.0 end
   //MMC 4.5 start
      .half_start_bit                   (half_start_bit),
      .start_bit_delayed                (start_bit_delayed)      
);
    //MMC 4.5 ends

  // Auto stop generation module
  DWC_mobile_storage_autostop
   U_DWC_mobile_storage_autostop
    (/*AUTOINST*/
     // Outputs
     .dp_load_stop_cmd_req              (dp_load_stop_cmd_req),
     // Inputs
     .creset_n                          (creset_n),
     .cclk_in                           (cclk_in),
     .cclk_in_en                        (cclk_in_en),
     .stop_data                         (stop_data),
     .dp_card_wide_bus                  (dp_card_wide_bus),
     .block_size                        (block_size[15:0]),
     .byte_count_rem                    (byte_count_rem[31:0]),
     .byte_countrem_zero                (byte_countrem_zero),
     .auto_stop_en                      (auto_stop_en),
     .cp_load_data_par_r                (cp_load_data_par_r),
     .transfer_mode                     (transfer_mode),
     .dp_cdata_in                       (dp_cdata_in),
     .read_write_xfer                   (read_write_xfer),
     .data_done_tmp                     (data_done_tmp),
     .resp_timeout                      (resp_timeout),
     .data_trans_cmd                    (data_trans_cmd),
     .txdt_stop_load_req                (txdt_stop_load_req));

  // data byte counter
  assign byte_countrem_zero = (byte_count_rem == 0);

  //In case of stream read and autostop expected card may drive
  //extra bytes on the bus(byte_cnt<22). The transferred byte count
  //should not increase more than expected byte count.
  assign trans_bytes_inc    = (!dp_open_ended_xfer && byte_countrem_zero) ?
                              c2b_trans_bytes_bin : c2b_trans_bytes_bin + 1;

  // CIU transfer byte counter
  always @(posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        c2b_trans_bytes_bin <= 32'h0;
        byte_count_rem      <= 32'h0;
        c2b_trans_bytes     <= 32'h0;
      end else begin
        if (cp_load_data_par && data_expected_r)
          begin
            c2b_trans_bytes_bin <= 32'h0;
            c2b_trans_bytes     <= 32'h0;
          end else if (cclk_in_en && (tx_byte_done || rx_byte_done))
            begin
              // binary  counter
              c2b_trans_bytes_bin <= trans_bytes_inc;
              // binary to gray converter
              c2b_trans_bytes     <= {trans_bytes_inc[31],
                                     (trans_bytes_inc[31:1] ^
                                      trans_bytes_inc[30:0])};
            end
        // bytes remaining counter
        if (cp_load_data_par)
          byte_count_rem  <= b2c_byte_count; 
    //MMC4_4 start
        else if (/*cclk_in_en && */(cclk_in_en_8_ddr && tx_byte_done) ||
                 (cclk_in_en_8_ddr  & rx_byte_done)
                 && !byte_countrem_zero)
    //MMC4_4 end     
          byte_count_rem  <= byte_count_rem - 1;

      end
    end

  // Data path counter, common for datatx and datarx module
  assign new_count    = (txdt_idle) ? rx_new_count : tx_new_count;
  assign counter_zero = (count_r == 24'h0);

  always @(posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        count_r        <= {24{1'h1}};
      else begin
   //MMC4_4 start
        if (/*cclk_in_en && */ cclk_in_en_8_ddr &&
            (tx_load_counter || rx_load_counter))
          count_r      <= new_count;
        else if (/*cclk_in_en && */ (cclk_in_en_8_ddr && tx_dec_counter) || 
                 (cclk_in_en_8_ddr  & rx_dec_counter))
          count_r      <= count_r - 1;
      end
    end
     //MMC4_4 end
  assign serial_data = (tx_serial_data_en) ? tx_serial_data : rx_serial_data;
  assign start_crc   = tx_start_crc || rx_start_crc;
  assign send_crc    = tx_send_crc || rx_send_crc;

  //This is required only while receiving 16-bit CRC from the card in
  //8-bit DDR mode
  //While checking for the received CRC16, clock to the card is not stopped
  //This is because the order of enables have to be restarted in the same
  //way in which they were stopped. 
  assign no_clock_stop_ddr_8 = rx_send_crc; 
 //MMC4_4 start

  wire toggle_l;
 assign toggle_l = toggle[sel_card_num];

 always@(toggle_l or serial_crc_1 or serial_crc_2  or ddr_8)
 begin
   if(ddr_8) 
  begin
      if(toggle_l)
          serial_crc =  serial_crc_1;
   else   
          serial_crc =  serial_crc_2;
  end
 else 
    serial_crc =  serial_crc_2;
 end   

  //The enables below are generated in order to handle the timing
  //for CRC generation when stop clock is asserted.
  assign cclk_in_en_crc1 = read_write_xfer? cclk_in_en_ddr :  
                                            cclk_in_en_ddr & !stop_clk_in_en;

  assign cclk_in_en_crc2 = read_write_xfer? cclk_in_en: 
                                            ddr_8_mode? (cclk_in_en  | 
                                                        (cclk_in_en_ddr & stop_clk_in_en)):
                                            cclk_in_en;
  // common crc16 generator module
  // for data transmit and data receive
 //crc16_1 is only used in 8 bit DDR mode.
 
  DWC_mobile_storage_crc16
    U_DWC_mobile_storage_crc16_1
    (
     // Outputs
     .serial_crc           (serial_crc_1),
     // Inputs
     .cclk_in              (cclk_in),
     .cclk_in_en           (cclk_in_en_crc1),
     .creset_n             (creset_n),
     .start_crc            (start_crc),
     .send_crc             (send_crc),
     .din                  (serial_data));
 //Only crc16_2 is used for 1,4,8 bit SDR and 4 bit DDR mode.
 //crc16_2 is used for DDR 8 bit along with crc16_1
 DWC_mobile_storage_crc16
   U_DWC_mobile_storage_crc16_2
    (
     // Outputs
     .serial_crc           (serial_crc_2),
     // Inputs
     .cclk_in              (cclk_in),
     .cclk_in_en           (cclk_in_en_crc2),
     .creset_n             (creset_n),
     .start_crc            (start_crc),
     .send_crc             (send_crc),
     .din                  (serial_data));
  
   //MMC4_4 end

endmodule // DWC_mobile_storage_datapath
