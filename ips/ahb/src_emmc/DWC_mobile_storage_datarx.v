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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_datarx.v#56 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_datarx.v
// Description : DWC_mobile_storage data receive block
//            This block receives stream / block of data from the card data bus
//            and generates FIFO write cycle, also checks for received crc16 on
//            each data line. IF read wait is request if asserted Dat[2]
//            line deasserted until read_wait request signal is not deasserted.
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_datarx(
  /*AUTOARG*/
  // Outputs
  rx_data_end_bit, rx_byte_done, rx_data_crc_error, rx_data_endbit_err,
  fifo_push, rx_stop_clk, rx_bit_cnt_r, rx_data_done, rx_stbit_err,
  rx_data_timeout,rx_data_timeout_internal, c2b_fifo_wdata, rx_dat0_busy, rxdt_idle, assert_read_wait,
  rx_new_count, rx_load_counter, rx_dec_counter, rx_serial_data,
  rx_start_crc, rx_send_crc, abort_read_data_r, rx_data_done_r,
  boot_ack_error,rx_end_bit,bar_intr,boot_ack_timeout,boot_data_timeout,
 //SD_3.0 start
  ddr_rx_states,
 //MMC4_4 start
 ddr_8_rx_states,
 //MMC4_4 end
 start_rx_data,
 //SD_3.0 end
  // Inputs
  creset_n, cclk_in, cclk_in_en, fifo_full, fifo_almost_full, block_size,
  byte_count_rem, stop_data, transfer_mode, dp_card_wide_bus, dp_cdata_in,
//SD_3.0 start
  de_interleave,
//SD_3.0 end
  byte_countrem_zero, dp_open_ended_xfer, cp_stop_cmd_loaded, cp_cmd_end_bit,
  read_wait, data_timeout_cnt, data_expected, read_write_xfer,
  abort_read_data, resp_timeout, cp_resp_end_bit,
  count_r, counter_zero, read_ceata_device, dscrd_cur_xfer,
  b2c_cmd_control,exp_boot_ack,exp_boot_ack_pulse,exp_boot_data,exp_boot_data_pulse, 
  end_boot,end_boot_pulse,new_cmd_loaded,
 //MMC4_4 start
 serial_crc_1,
 serial_crc_2,
 cclk_in_en_8_ddr,
 cclk_in_en_ddr,
  cp_card_num,
 ddr_8_mode,
 ddr_8,
  stop_clk_ddr_8,
 atleast_empty,
  card_rd_threshold_en,
  //MMC4_4 end 
 //SD_3.0 start
   ddr,
   ddr_4_mode,
 //SD_3.0 end
        half_start_bit,
        start_bit_delayed
  );

  // input port defination
  input                     creset_n;            // Card Reset - Active Low
  input                     cclk_in;             // CIU Clock
  input                     cclk_in_en;          // Clock enable
  input                     fifo_full;           // FIFO full
  input                     fifo_almost_full;    // FIFO almost full

  input              [15:0] block_size;          // Size of data block
  input              [31:0] byte_count_rem;      // Data transfer byte count
  input                     stop_data;           // Stop/abort cmd end bit
  input                     transfer_mode;       // Transfer mode stream/block
  input               [1:0] dp_card_wide_bus;    // 1/4/8-bit card data bus.
  input               [7:0] dp_cdata_in;         // Card data bus input for NON DDR
 //SD_3.0 start
  input               [7:0] de_interleave;       // card data input for DDR
 //SD_3.0 end
 input                     byte_countrem_zero;  // Byte count zero
  input                     dp_open_ended_xfer;  // Open ended transfer
  input                     cp_stop_cmd_loaded;  // Stop command is loaded
  input                     cp_cmd_end_bit;      // Command end bit
  input                     read_wait;           // Read wait
  input              [23:0] data_timeout_cnt;    // Read data timeout
  input                     data_expected;       // Data transfer is expected
  input                     read_write_xfer;     // Read/write data transfer
  input                     abort_read_data;     // Abort read data to suspened
  input                     resp_timeout;        // Cmd response timeout
  input                     cp_resp_end_bit;     // Response end bit
  input                     read_ceata_device;   // CE-ATA Read data transfer 
  input                     dscrd_cur_xfer;      // Discard current transfer
                                                 // due to premature CCS
 //SD_3.0 start                        
  input              [28:0] b2c_cmd_control;
 //SD_3.0 end
  input                     exp_boot_ack;        //boot ack pattern expected indication
  input                     exp_boot_ack_pulse;  //Pulse indication of exp_boot_ack
  input                     exp_boot_data;       //Level indication of exp_boot_data
  input                     exp_boot_data_pulse; //Pulse indication of exp_boot_data
  input                     end_boot;            //end boot indication
  input                     end_boot_pulse;      //end boot indication pulse
  input                     new_cmd_loaded;
 //MMC4_4 start
 // crc16 interface
  input                [7:0] serial_crc_1;        // Serial crc16
 input                [7:0] serial_crc_2;        // Serial crc16
 input                     cclk_in_en_8_ddr;
 input                     cclk_in_en_ddr;
 input                [3:0] cp_card_num;
 input                     ddr_8_mode;
 input                     ddr_8;
  input                     stop_clk_ddr_8;
 input                     atleast_empty;
  input                     card_rd_threshold_en;

 //MMC4_4 end
 //SD_3.0 start
 input                     ddr;                 // 4-bit DDR indication
 input                     ddr_4_mode;                 // 4-bit DDR mode 
  //SD_3.0 end
        input                     half_start_bit;
        input                     start_bit_delayed;                  


  // output port defination
  output                    rx_data_end_bit;     // Data rx end bit.
  output                    rx_byte_done;        // Data rx byte done
  output                    rx_data_crc_error;   // Data rx crc status error
  output                    rx_data_endbit_err;  // Data block end bit error
  output                    fifo_push;           // Push data in FIFO
  output                    rx_stop_clk;         // Stop clock fifo empty
  output              [2:0] rx_bit_cnt_r;        // Data receive bit count
  output                    rx_data_done;        // Receive data done
  output                    rx_stbit_err;        // Data rx start bit error
  output                    rx_data_timeout;     // Data receive timeout + boot data start interrupt.
 output                    rx_data_timeout_internal; // Data receive timeout only.
  output[`F_DATA_WIDTH-1:0] c2b_fifo_wdata;      // FIFO write data
  output                    rx_dat0_busy;        // Dat0_busy
  output                    rxdt_idle;           // RX data idle
  output                    assert_read_wait;    // Assert read wait
  output                    abort_read_data_r;   // Abort read data registered
  output                    rx_data_done_r;      // Data done after fifo idle
  output                    boot_ack_error;      // Error in the boot acknowledgement.
  output                    rx_end_bit;          // rxdt_cs[`RXDT_ENDBIT]\
  output                    bar_intr;            // Boot ack received(BAR) interrupt
  output                    boot_ack_timeout;    // Boot Ack timeout
  output                    boot_data_timeout;   // Boot data timeout
 //SD_3.0 start
  output                    ddr_rx_states;       // Used as qualifier to 
                                                 // generate 4-bit DDR signal.
 //MMC4_4 start
 output                    ddr_8_rx_states;     // Indicates that RXFSM is 
                                                 // receiving data in 8-bit DDR
                                                 // mode.
  //MMC4_4 end
 output                    start_rx_data;
 //SD_3.0 end


  // counter interface
  input              [23:0] count_r;             // Counter
  input                     counter_zero;        // Counter zero
  output             [23:0] rx_new_count;        // New count
  output                    rx_load_counter;     // Load counter
  output                    rx_dec_counter;      // Dec counter

  
  output               [7:0] rx_serial_data;    // Serial data
  output                     rx_start_crc;      // Start crc16
  output                     rx_send_crc;       // Send crc16
  //output                     rx_serial_data_en; // Enable crc16 generation

  // data receive states defines
  `define      RXDT_IDLE       0      // Rx data idle
  `define      RXDT_STBIT      1      // Rx data start bit
  `define      RXDT_BLKDATA    2      // Rx data block
  `define      RXDT_STRDATA    3      // Rx data stream
  `define      RXDT_CRC16      4      // Rx data crc16
  `define      RXDT_ENDBIT     5      // Rx data end bit
  `define      RXDT_WAIT2CLK   6      // Rx wait for 2 clock
  `define      RXDT_BOOT_ACK   7      //
  `define      RXDT_STBIT_X    8      // DDR 8 bit 1/2 start bit MMC 4.5; Extra state to accomodate X after start bit in 8 bit DDR mode only. 


  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Registers
  reg                  [8:0] rxdt_cs;        // Data rx state m/c current state
  reg                  [8:0] rxdt_ns;        // Data rx state m/c next state
  reg                        stop_data_r;    // Register stop data
 reg                        stop_data_r1;    // Register stop data
 reg                        end_boot_r;
  reg                  [7:0] shift_byte_reg; // Data byte shift register
  reg    [`F_DATA_WIDTH-1:0] c2b_fifo_wdata; // FIFO write data
  wire                 [23:0] rx_new_count;   // New count                         
  reg                  [23:0] rx_new_count_data_phase;   // New count
  reg                  [23:0] rx_new_count_boot_phase;   // New count
  wire                        rx_load_counter_data;
  reg                         rx_load_counter_boot;
 reg                        second_end_bit;
 reg                        second_end_bit_r;
  reg                  [2:0] rx_bit_cnt_r;   // RX data bit count
 reg                        count_ddr;
 reg                        count_ddr_r;

 //MMC4_4 start
  reg                  [7:0] rx_data_crc_err_1;// RX data crc error
 reg                  [7:0] rx_data_crc_err_2;
 //MMC4_4 end
  reg                        rx_stbit_err;   // RX data start bit
  reg                        rx_byte_done_r;  // RX data byte done
  reg                        abort_read_data_r; // Read abort reg
  reg                        data_xfer_cmd;  // Data transfer command
  reg                        rx_data_done_l; // RX data done latched
  reg                  [2:0] boot_ack_r;
  reg                        wait_for_boot_data;
  reg                        wait_for_boot_ack;
  reg                        boot_ack_error;
  // Wires
  wire                 [7:0] rx_serial_data;   // Serial data
  wire                       rx_data_timeout;  // Interrupt to regb
 wire                       rx_data_timeout_internal; // Data timeout
  wire                       rx_data_endbit_err; // Data block end bit error
 wire                       rx_data_endbit_abort_err;
 wire                       rx_data_endbit_normal_err;
  wire                       start_rx_data;    // Start data rx
 wire                       start_rx_data_fifo;
  wire                       start_bit;        // RX data start bit
  wire                 [1:0] rx_sel;           // Mux select for state machine
  wire                 [1:0] new_count_sel;    // Mux select for new count
  wire                       rx_byte_done;     // RX data byte done
  wire                 [2:0] rx_bit_cnt_d;     // RX data bit count
  wire                       rx_data_crc_error;// RX data crc error
 //MMC4_4 start
 wire                 [7:0] rx_data_crc_err_w_1;// RX data crc error
 wire                 [7:0] rx_data_crc_err_w_2;
 wire                       rx_data_crc_error_1;
 wire                       rx_data_crc_error_2;
  wire                       cclk_in_en_8_bit_ddr;
  wire                       rx_stop_clk_new;
 //MMC4_4 end
  wire                 [2:0] rx_byte_done_cnt; // RX byte done count
  wire                       rx_data_done_r;   // Data done after fifo idle
  wire                       rx_data_done;     // RX data done
  wire                       rxfifo_idle;      // Rxfifo idle
  wire                 [2:0] card_width;       // Card width
  wire                       boot_ack_err;
  wire                       bar_intr;
  wire                       boot_end_bit_err;
  wire                       boot_data_st_intr;
  wire                       boot_crc_en;
  wire                       boot_ack_timeout;
  wire                       boot_data_timeout;
 wire                       boot_mode;

 //SD_3.0 start
  wire                 [7:0] real_data;
 //SD_3.0 end
 //wire                [15:0] fifo_depth;
  
 //MMC 4.5 start
 wire   full_start_bit;
 assign full_start_bit = !half_start_bit ;
  // MMC 4.5 ends
  assign boot_mode = b2c_cmd_control[24] | b2c_cmd_control[27];
  assign rx_end_bit  = rxdt_cs[`RXDT_ENDBIT];
  assign boot_crc_en = rxdt_cs[`RXDT_BOOT_ACK];
  //SD_3.0 start
 // This signal keeps the ddr active in the following states

  assign ddr_rx_states = rxdt_cs[`RXDT_STBIT] || rxdt_cs[`RXDT_BLKDATA] || rxdt_cs[`RXDT_CRC16] || (half_start_bit && rxdt_cs[`RXDT_ENDBIT]);
 //MMC4_4 start
 //The start bit, end bit will be of half clock cycle in 8 bit DDR mode of operation.
 // Hence the states RXDT_STBIT_X and RXDT_ENDBIT are added to the equation.
  assign ddr_8_rx_states = rxdt_cs[`RXDT_STBIT] || rxdt_cs[`RXDT_STBIT_X]  || rxdt_cs[`RXDT_BLKDATA] || rxdt_cs[`RXDT_CRC16] || (half_start_bit && rxdt_cs[`RXDT_ENDBIT]);
  //MMC4_4 end
 // During DDR mode nterleaved data is on the de_interleave signal and the  
 // dp_cdata_in contains the start bit and the CRC pattern(interleaved data + CRC).
 // During NON-DDR mode the dp_cdata_in is the only signal that has the start bit and the CRC pattern(normal data+CRC).
  
 assign real_data = ddr ? de_interleave : dp_cdata_in;
 
 //SD_3.0 end

 
  // Boot Ack pattern check
  assign boot_ack_err = exp_boot_ack & (count_r==0 & boot_ack_r != 3'b010 & rxdt_cs[`RXDT_ENDBIT]) | boot_end_bit_err;

  //Boot Ack received interrupt generation
  assign bar_intr = exp_boot_ack & (count_r ==0 & boot_ack_r == 3'b010 & rxdt_cs[`RXDT_ENDBIT]);

  //Boot Ack pattern end bit check
  assign boot_end_bit_err = exp_boot_ack & (~dp_cdata_in[0] & rxdt_cs[`RXDT_ENDBIT]);
  
  //Logic for generating boot data start interrupt
  always @ (posedge cclk_in or negedge creset_n) 
    begin
      if (~creset_n) 
         begin
           wait_for_boot_data  <= 1'b0;
           boot_ack_error <= 1'b0;
         end
      else 
         begin
           if (cclk_in_en) 
              begin
                boot_ack_error <= boot_ack_err;
                  if ((wait_for_boot_data & rxdt_cs[`RXDT_BLKDATA]) | b2c_cmd_control[26])
                     wait_for_boot_data <= 1'b0;
                  else if(((data_expected & b2c_cmd_control[24]) & new_cmd_loaded) | exp_boot_data_pulse | ((data_expected & b2c_cmd_control[27]) & new_cmd_loaded))
                     wait_for_boot_data <= 1'b1;
              end   
          end
    end
    
  assign boot_data_st_intr = rxdt_cs[`RXDT_BLKDATA] & wait_for_boot_data; 
  //This is DRTO interrupt which is already existing.
 // rx_data_timeout is used by the regb in interrupt status and hence contain the boot_data_st_intr 
  assign rx_data_timeout = boot_data_st_intr  | (rxdt_cs[`RXDT_STBIT] && counter_zero && ~start_bit && ~rx_stbit_err && ~read_ceata_device & !boot_mode);
  //rx_data_timeout_internal is used only for data timeout purpose and should not contain the boot_data_st_intr else a data timeout 
 //will be generated
 assign rx_data_timeout_internal = (rxdt_cs[`RXDT_STBIT] && counter_zero && ~start_bit && ~rx_stbit_err && ~read_ceata_device & !boot_mode);

  //Boot Data timeout will be used in IDMAC mode.
  assign boot_data_timeout = wait_for_boot_data & end_boot_pulse;

  //Boot Ack timeout will be used in IDMAC mode.
  assign boot_ack_timeout = wait_for_boot_ack & end_boot_pulse;
 
 //Logic for generating boot ack timeout. This will be used to update
 //in IDMAC mode while closing the descriptor.
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
         begin
           wait_for_boot_ack  <= 1'b0;
         end 
      else 
          begin
            if (cclk_in_en) 
               begin
                  if ((wait_for_boot_ack & rxdt_cs[`RXDT_BOOT_ACK] & count_r == 1)|| end_boot)
                     wait_for_boot_ack <= 1'b0;
                  else if(exp_boot_ack_pulse)
                     wait_for_boot_ack <= 1'b1;
               end
          end
    end
  
  //Boot ack error generation
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if(~creset_n)
        boot_ack_r   <= 3'h0;
      else 
         begin
            if(cclk_in_en & boot_crc_en)
               boot_ack_r <= {boot_ack_r[1:0],dp_cdata_in[0]};
         end
    end

  //Latch command as data transfer command
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        data_xfer_cmd   <= 1'b0;
      else 
         begin
           if (cp_cmd_end_bit && data_expected && !read_write_xfer && rxdt_cs[`RXDT_IDLE])
              data_xfer_cmd <= 1'b1;
           else if (cclk_in_en && cp_resp_end_bit)
              data_xfer_cmd <= 1'b0;
         end
    end

  // Data receive state machine register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        rxdt_cs     <= 9'h1;
      else 
         begin
           if (dscrd_cur_xfer)
              rxdt_cs     <= 9'h1;
 //MMC4_4 start
           else if (cclk_in_en_8_ddr)
 //MMC4_4 end
              rxdt_cs   <= rxdt_ns;
         end
    end

   always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
       count_ddr_r <= 1'b0; 
      else 
         count_ddr_r <= count_ddr; 
    end

  

  assign card_width[0] = (~(|dp_card_wide_bus));
  assign card_width[1] = (~dp_card_wide_bus[1] & dp_card_wide_bus[0]);
  assign card_width[2] = (dp_card_wide_bus[1]);
  //SD_3.0 start  
 // MMC4.5 start
 // DDR 4 bit mode:
 //                 If the start bit is 1   card clock cycle & sampled on the ANY edge then the start bit should be seen on dp_cdata_in[7:0]
 //                 If the start bit is 1/2 card clock cycle & sampled on the +ve edge then the start bit should be seen on dp_cdata_in[3:0]
 //                 If the start bit is 1/2 card clock cycle & sampled on the -ve edge then the start bit should be seen on dp_cdata_in[7:4]
 //DDR 8 bit mode:
 //                 If the start bit is 1   card clock cycle & sampled on the ANY edge then the start bit should be seen on dp_cdata_in[7:0]
 //                 for only 1 card clock cycle.
 //                 If the start bit is 1/2 card clock cycle & sampled on the +ve edge then the start bit should be seen on dp_cdata_in[3:0]
 //                 for only 1/2 card clock cycle.
 //                 If the start bit is 1/2 card clock cycle & sampled on the -ve edge then the start bit should be seen on dp_cdata_in[7:4]
 //                 for only 1/2 card clock cycle.
 //                 An extra state has been added to accomodate the 1/2 card clock cycle in 8 bit DDR mode.
  assign start_bit = wait_for_boot_ack ? (!dp_cdata_in[0]) : ((!dp_cdata_in[0] && card_width[0]) ||
                     ((           ( !(|dp_cdata_in[3:0]) && (card_width[1] && (!ddr || (!start_bit_delayed && ddr && half_start_bit)))) ||
                                  ( !(|dp_cdata_in[7:4]) && (card_width[1] && (!ddr || (start_bit_delayed && ddr && half_start_bit)))) ||
                                  (!(|dp_cdata_in) && (card_width[2] || (ddr && full_start_bit) ))                                         ) &&
                      ~rx_stbit_err));
  // MC 4.5 ends           
  //SD_3.0 end
  assign rx_sel[0] = (data_xfer_cmd && resp_timeout) || rx_data_timeout_internal
                     || stop_data || abort_read_data_r ||
                     (start_bit && transfer_mode);

  assign rx_sel[1] = (data_xfer_cmd && resp_timeout) || rx_data_timeout_internal
                     || stop_data || abort_read_data_r ||
                     (start_bit && !transfer_mode);


  assign rx_new_count = ((rxdt_cs[`RXDT_STBIT] && rxdt_ns[`RXDT_BOOT_ACK])) ? rx_new_count_boot_phase :  rx_new_count_data_phase;
  assign rx_load_counter =  ((rxdt_cs[`RXDT_STBIT] && rxdt_ns[`RXDT_BOOT_ACK])== 1'b1) ? rx_load_counter_boot : rx_load_counter_data; 

  // Data receive state machine combinational logic
  always @ (/*AUTOSENSE*/
            byte_countrem_zero or count_r or counter_zero or cp_cmd_end_bit
            or data_expected or dp_open_ended_xfer or read_wait
            or read_write_xfer or rx_byte_done or rx_data_endbit_err or boot_ack_err or rx_sel
            or rxdt_cs or stop_data or stop_data_r or exp_boot_ack or exp_boot_data
      or wait_for_boot_ack or end_boot or second_end_bit_r or end_boot_r or count_ddr_r or ddr_8_mode or full_start_bit or half_start_bit)
    begin : FSM_datarx
      rxdt_ns   = 9'h0;
      rx_new_count_boot_phase      = 0;
      rx_load_counter_boot         = 1'b0;
      second_end_bit               = 1'b0;
      count_ddr                    = 1'b0;
      case (1'b1)
        rxdt_cs[`RXDT_IDLE] :  
          begin
            if ((cp_cmd_end_bit | exp_boot_ack | exp_boot_data) && data_expected && !read_write_xfer)
               rxdt_ns[`RXDT_STBIT] = 1'b1;
            else
               rxdt_ns[`RXDT_IDLE]  = 1'b1;
          end

        rxdt_cs[`RXDT_STBIT] : 
           begin
              if(end_boot)
                 rxdt_ns[`RXDT_WAIT2CLK]         = 1'b1;
              else 
                 begin
                   case (rx_sel)
                     2'b00: rxdt_ns[`RXDT_STBIT]   = 1'b1;
                     2'b01: rxdt_ns[`RXDT_STRDATA] = 1'b1;
                     2'b10: 
                          begin
                             if(exp_boot_ack & wait_for_boot_ack) 
                                begin
                                   rxdt_ns[`RXDT_BOOT_ACK]   = 1'b1;
                                   rx_load_counter_boot      = 1'b1;
                                   rx_new_count_boot_phase   = 3;
                                end
                             else if (ddr_8_mode && !count_ddr_r && full_start_bit) 
                                begin
                                   rxdt_ns[`RXDT_STBIT]   = 1'b1;
                                   count_ddr = 1'b1;
                                end
                             else if (ddr_8_mode && half_start_bit) 
                                begin  // MMC 4.5 : 8 bit DDR start_bit = 1/2 card clock 
                                   rxdt_ns[`RXDT_STBIT_X]  = 1'b1;
                                end
                             else 
                                begin
                                   rxdt_ns[`RXDT_BLKDATA]    = 1'b1;
                                end
                          end  
                     default: rxdt_ns[`RXDT_IDLE]  = 1'b1;
                   endcase // case(rx_sel)
                 end
           end
    // MMC 4.5 :Extra state for 8 bit DDR start_bit = 1/2 card clock
     rxdt_cs[`RXDT_STBIT_X] : 
          begin
            if (stop_data)
                rxdt_ns[`RXDT_IDLE]   = 1'b1;
            else
                rxdt_ns[`RXDT_BLKDATA]= 1'b1;  
          end


        rxdt_cs[`RXDT_BOOT_ACK]  : 
          begin
            if(count_r == 1 | end_boot)
              rxdt_ns[`RXDT_ENDBIT]   = 1'b1;
            else
              rxdt_ns[`RXDT_BOOT_ACK] = 1'b1;
          end    

        rxdt_cs[`RXDT_BLKDATA] : 
          begin
            if (stop_data | end_boot)
              rxdt_ns[`RXDT_ENDBIT]   = 1'b1;
              // Last bit of the last byte is received
              // count_r will be become = 0 after one clock
            else if ((count_r == 1) && rx_byte_done)
              rxdt_ns[`RXDT_CRC16]    = 1'b1;
            else
              rxdt_ns[`RXDT_BLKDATA]  = 1'b1;
          end

        rxdt_cs[`RXDT_STRDATA] : 
          begin
            if (stop_data)
              rxdt_ns[`RXDT_ENDBIT]   = 1'b1;
            else
              rxdt_ns[`RXDT_STRDATA]  = 1'b1;
          end

        rxdt_cs[`RXDT_CRC16] : 
          begin
            if (counter_zero || stop_data || end_boot)
               rxdt_ns[`RXDT_ENDBIT]   = 1'b1;
            else
               rxdt_ns[`RXDT_CRC16]    = 1'b1;
          end

        //rxdt_cs[`RXDT_ENDBIT] : begin
       //  if (exp_boot_data && !byte_countrem_zero)
       //     rxdt_ns[`RXDT_STBIT]    =1'b1;
        //  else if (stop_data_r || stop_data ||
        //       (byte_countrem_zero && !dp_open_ended_xfer) ||
        //       rx_data_endbit_err)
        //     rxdt_ns[`RXDT_IDLE]     = 1'b1;
        //  else
        //     rxdt_ns[`RXDT_WAIT2CLK] = 1'b1;
        //end
 
        rxdt_cs[`RXDT_ENDBIT] : 
          begin
            if (exp_boot_data && !byte_countrem_zero)
              rxdt_ns[`RXDT_STBIT]    =1'b1;
            else if (end_boot) 
               begin
                 if (stop_data_r)
                   rxdt_ns[`RXDT_IDLE]  =1'b1;
                 else
                   rxdt_ns[`RXDT_ENDBIT] =1'b1;
               end
            else if (second_end_bit_r) 
               begin
                 second_end_bit = 1'b0; 
                 rxdt_ns[`RXDT_IDLE]  = 1'b1;
               end  
            else if(stop_data_r && !end_boot_r)  
               begin // cmd12 + ! boot abort
                 second_end_bit = 1'b1; 
                 rxdt_ns[`RXDT_ENDBIT]  = 1'b1;
               end
            else if (stop_data_r || stop_data ||
               (byte_countrem_zero && !dp_open_ended_xfer) ||
                 rx_data_endbit_err || boot_ack_err)
                 rxdt_ns[`RXDT_IDLE]     = 1'b1;
            else
                 rxdt_ns[`RXDT_WAIT2CLK] = 1'b1;
          end

        rxdt_cs[`RXDT_WAIT2CLK] : 
          begin
            if (stop_data || end_boot)
              rxdt_ns[`RXDT_IDLE]     = 1'b1;
            else if (~read_wait)
              rxdt_ns[`RXDT_STBIT]    = 1'b1;
            else
              rxdt_ns[`RXDT_WAIT2CLK] = 1'b1;
          end

      endcase
    end

 // assign rx_data_timeout = rxdt_cs[`RXDT_STBIT] && counter_zero &&
 //                          ~start_bit && ~rx_stbit_err && ~read_ceata_device;

  // Register read abort to detect one cycle pulse
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        abort_read_data_r <= 1'b0;
      else
        if (abort_read_data)
          abort_read_data_r <= 1'b1;
        else if (cclk_in_en && abort_read_data_r)
          abort_read_data_r <= 1'b0;
    end

//SD_3.0 start
  // RX data shift register logic
  always @(posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
         begin
           shift_byte_reg    <= 8'h0;
           c2b_fifo_wdata    <= {`F_DATA_WIDTH{1'b0}};
         end 
      else 
         begin
//SD_3.0 start
           if (cclk_in_en && (card_width[1] && !ddr) && rxdt_cs[`RXDT_BLKDATA])
//SD_3.0 end    
              shift_byte_reg  <= {shift_byte_reg[3:0],real_data[3:0]};
           else if (cclk_in_en && card_width[0] &&
                 (rxdt_cs[`RXDT_BLKDATA] || rxdt_cs[`RXDT_STRDATA]))
               shift_byte_reg  <= {shift_byte_reg[6:0],real_data[0]};
//SD_3.0 start
           if (cclk_in_en && rx_byte_done && (card_width[1] && !ddr)) 
             begin
 //SD_3.0 end
              `ifdef F_DATA_WIDTH_32
                case (rx_byte_done_cnt[1:0])
                  2'b00 :
                    c2b_fifo_wdata[7:0]   <= {shift_byte_reg[3:0],real_data[3:0]};
                  2'b01 :
                    c2b_fifo_wdata[15:8]  <= {shift_byte_reg[3:0],real_data[3:0]};
                  2'b10 :
                    c2b_fifo_wdata[23:16] <= {shift_byte_reg[3:0],real_data[3:0]};
                  default :
                    c2b_fifo_wdata[31:24] <= {shift_byte_reg[3:0],real_data[3:0]};
                endcase
              `else // if (`F_DATA_WIDTH == 64)
                case (rx_byte_done_cnt)
                  3'b000 :
                    c2b_fifo_wdata[7:0]   <= {shift_byte_reg[3:0],real_data[3:0]};
                  3'b001 :
                    c2b_fifo_wdata[15:8]  <= {shift_byte_reg[3:0],real_data[3:0]};
                  3'b010 :
                    c2b_fifo_wdata[23:16] <= {shift_byte_reg[3:0],real_data[3:0]};
                  3'b011 :
                    c2b_fifo_wdata[31:24] <= {shift_byte_reg[3:0],real_data[3:0]};
                  3'b100 :
                    c2b_fifo_wdata[39:32] <= {shift_byte_reg[3:0],real_data[3:0]};
                  3'b101 :
                    c2b_fifo_wdata[47:40] <= {shift_byte_reg[3:0],real_data[3:0]};
                  3'b110 :
                    c2b_fifo_wdata[55:48] <= {shift_byte_reg[3:0],real_data[3:0]};
                  default :
                    c2b_fifo_wdata[63:56] <= {shift_byte_reg[3:0],real_data[3:0]};
                endcase
              `endif
            end 
          else if (cclk_in_en && rx_byte_done && card_width[0]) 
            begin
              `ifdef F_DATA_WIDTH_32
                case (rx_byte_done_cnt[1:0])
                  2'b00 :
                    c2b_fifo_wdata[7:0]   <= {shift_byte_reg[6:0], real_data[0]};
                  2'b01 :
                    c2b_fifo_wdata[15:8]  <= {shift_byte_reg[6:0], real_data[0]};
                  2'b10 :
                    c2b_fifo_wdata[23:16] <= {shift_byte_reg[6:0], real_data[0]};
                  default :
                    c2b_fifo_wdata[31:24] <= {shift_byte_reg[6:0], real_data[0]};
                endcase
              `else // if (`F_DATA_WIDTH == 64)
                case (rx_byte_done_cnt)
                  3'b000 :
                    c2b_fifo_wdata[7:0]   <= {shift_byte_reg[6:0], real_data[0]};
                  3'b001 :
                    c2b_fifo_wdata[15:8]  <= {shift_byte_reg[6:0], real_data[0]};
                  3'b010 :
                    c2b_fifo_wdata[23:16] <= {shift_byte_reg[6:0], real_data[0]};
                  3'b011 :
                    c2b_fifo_wdata[31:24] <= {shift_byte_reg[6:0], real_data[0]};
                  3'b100 :
                    c2b_fifo_wdata[39:32] <= {shift_byte_reg[6:0], real_data[0]};
                  3'b101 :
                    c2b_fifo_wdata[47:40] <= {shift_byte_reg[6:0], real_data[0]};
                  3'b110 :
                    c2b_fifo_wdata[55:48] <= {shift_byte_reg[6:0], real_data[0]};
                  default :
                    c2b_fifo_wdata[63:56] <= {shift_byte_reg[6:0], real_data[0]};
                endcase
              `endif
     //SD_3.0 start
     //MMC4_4 start
           end 
         else if (/*cclk_in_en &&*/ cclk_in_en_8_ddr && rx_byte_done && (card_width[2] || ddr)) 
           begin
    //MMC4_4 end
    //SD_3.0 end
             `ifdef F_DATA_WIDTH_32
               case (rx_byte_done_cnt[1:0])
                 2'b00 :
                   c2b_fifo_wdata[7:0]   <= real_data;
                 2'b01 :
                   c2b_fifo_wdata[15:8]  <= real_data;
                 2'b10 :
                   c2b_fifo_wdata[23:16] <= real_data;
                 default :
                   c2b_fifo_wdata[31:24] <= real_data;
               endcase
             `else // if (`F_DATA_WIDTH == 64)
               case (rx_byte_done_cnt)
                 3'b000 :
                   c2b_fifo_wdata[7:0]   <= real_data;
                 3'b001 :
                   c2b_fifo_wdata[15:8]  <= real_data;
                 3'b010 :
                   c2b_fifo_wdata[23:16] <= real_data;
                 3'b011 :
                   c2b_fifo_wdata[31:24] <= real_data;
                 3'b100 :
                   c2b_fifo_wdata[39:32] <= real_data;
                 3'b101 :
                   c2b_fifo_wdata[47:40] <= real_data;
                 3'b110 :
                   c2b_fifo_wdata[55:48] <= real_data;
                 default :
                   c2b_fifo_wdata[63:56] <= real_data;
               endcase // case(rx_byte_done_cnt)
             `endif
           end
        end
    end
//SD_3.0 end
  assign new_count_sel[0] = rxdt_cs[`RXDT_STBIT] || rxdt_cs[`RXDT_STBIT_X];
  assign new_count_sel[1] = rxdt_cs[`RXDT_BLKDATA];
  // RX block data counter
 //MMC4_4 start
  always @ (/*AUTOSENSE*/block_size or data_timeout_cnt or new_count_sel or ddr_8 or count_ddr)
 //MMC4_4 end
    begin
      case (new_count_sel)
        2'b01: rx_new_count_data_phase = count_ddr ? 24'h0 : block_size;
   //MMC4_4 start
        2'b10: rx_new_count_data_phase = ddr_8 ? 24'h1F : 24'hF;  // crc16 after block data
   //MMC4_4 end
        default: rx_new_count_data_phase = data_timeout_cnt;
      endcase
  end
  // Load new count when
  // data timeout count or block size or crc16 or min accesss time
  assign rx_load_counter_data = (rxdt_cs[`RXDT_IDLE] && rxdt_ns[`RXDT_STBIT]) ||
                          //(rxdt_cs[`RXDT_STBIT] && count_ddr) ||
                           (rxdt_cs[`RXDT_STBIT] && start_bit) ||
                           ((count_r == 7'h1) && rx_byte_done &&
                            rxdt_cs[`RXDT_BLKDATA]) ||
                           (rxdt_cs[`RXDT_WAIT2CLK] &&
                            !read_wait);

  //Data rx block byte counter
  // when waiting for start bit or (byte done and receive data)
  // or crc16 or min access time.
  assign rx_dec_counter  = (rx_byte_done || rxdt_cs[`RXDT_CRC16] ||
                            rxdt_cs[`RXDT_STBIT] || rxdt_cs[`RXDT_BOOT_ACK]);

  // Register stop_data signal
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
        begin
          stop_data_r   <= 1'b0;
          stop_data_r1   <= 1'b0;
          end_boot_r    <= 1'b0;
        end 
      else 
        begin
          if (cclk_in_en) 
             begin
               stop_data_r <= stop_data;
               stop_data_r1 <= stop_data_r;
               end_boot_r  <= end_boot;
             end 
        end
    end

  //MMC4_4 start
  // Register data crc error
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
         begin
           rx_data_crc_err_1    <= 8'b0;
         end 
      else 
         begin
           if (cclk_in_en_ddr & rxdt_cs[`RXDT_STBIT])
             rx_data_crc_err_1  <= 8'b0;
           else if (cclk_in_en_ddr & rxdt_cs[`RXDT_CRC16]) 
             rx_data_crc_err_1  <= rx_data_crc_err_w_1;
         end
    end



   always @ (posedge cclk_in or negedge creset_n)
     begin
      if (~creset_n) 
         begin
           rx_data_crc_err_2    <= 8'b0;
         end 
      else 
         begin
           if (cclk_in_en & rxdt_cs[`RXDT_STBIT])
             rx_data_crc_err_2  <= 8'b0;
           else if (cclk_in_en & rxdt_cs[`RXDT_CRC16]) 
             rx_data_crc_err_2  <= rx_data_crc_err_w_2;
         end
     end
 

  
//SD_3.0 start
  assign rx_data_crc_err_w_1 = (card_width[2] || ddr) ? ({8{rxdt_cs[`RXDT_CRC16]}} &
 //SD_3.0 end
                             ((rx_serial_data ^ serial_crc_1) | rx_data_crc_err_1)) :
                             card_width[1] ? ({4{rxdt_cs[`RXDT_CRC16]}} &
                             ((rx_serial_data[3:0] ^ serial_crc_1[3:0]) |
                              rx_data_crc_err_1[3:0])) :
                             card_width[0] ? ({1{rxdt_cs[`RXDT_CRC16]}} &
                             ((rx_serial_data[0] ^ serial_crc_1[0]) |
                              rx_data_crc_err_1[0])) : 8'b0;
//SD_3.0 start
  assign rx_data_crc_error_1 = (card_width[2] || ddr) ? ((|rx_data_crc_err_1) &&
 //SD_3.0 end
                             rxdt_cs[`RXDT_ENDBIT]) : card_width[1] ?
                             ((|rx_data_crc_err_1[3:0]) && rxdt_cs[`RXDT_ENDBIT]) :
                             card_width[0] ? (rx_data_crc_err_1[0] &&
                             rxdt_cs[`RXDT_ENDBIT]) : 1'b0;


//CRC for DDR 8 bit mode
assign rx_data_crc_err_w_2 = (card_width[2] || ddr) ? ({8{rxdt_cs[`RXDT_CRC16]}} &
 //SD_3.0 end
                             ((rx_serial_data ^ serial_crc_2) | rx_data_crc_err_2)) :
                             card_width[1] ? ({4{rxdt_cs[`RXDT_CRC16]}} &
                             ((rx_serial_data[3:0] ^ serial_crc_2[3:0]) |
                              rx_data_crc_err_2[3:0])) :
                             card_width[0] ? ({1{rxdt_cs[`RXDT_CRC16]}} &
                             ((rx_serial_data[0] ^ serial_crc_2[0]) |
                              rx_data_crc_err_2[0])) : 8'b0;
//SD_3.0 start
  assign rx_data_crc_error_2 = (card_width[2] || ddr_4_mode) ? ((|rx_data_crc_err_2) &&
 //SD_3.0 end
                             rxdt_cs[`RXDT_ENDBIT]) : card_width[1] ?
                             ((|rx_data_crc_err_2[3:0]) && rxdt_cs[`RXDT_ENDBIT]) :
                             card_width[0] ? (rx_data_crc_err_2[0] &&
                             rxdt_cs[`RXDT_ENDBIT]) : 1'b0;
reg  ddr_8_r;

assign rx_data_crc_error =  ddr_8_r ? (rx_data_crc_error_1 || rx_data_crc_error_2) : rx_data_crc_error_2;
 always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
        begin
          ddr_8_r <= 1'b0;
        end 
      else 
        begin
          if (cclk_in_en) 
            begin
              ddr_8_r <= ddr_8;
            end
        end
    end


//MMC4_4 end

  // crc16 control logic
  assign rx_serial_data    = dp_cdata_in;
  assign rx_start_crc      = rxdt_cs[`RXDT_STBIT]  || rxdt_cs[`RXDT_STBIT_X];
  assign rx_send_crc       = rxdt_cs[`RXDT_CRC16];

  // byte done and bit counter
  assign rx_byte_done      = ((((rx_bit_cnt_r == 3'h7) & card_width[0]) ||
   //SD_3.0 start             
                               (card_width[2] || ddr) ||
                               ((card_width[1] & !ddr) & (rx_bit_cnt_r == 3'h4))) &&
   //SD_3.0 end
                              (!rxdt_cs[`RXDT_ENDBIT] &&
                               (rxdt_cs[`RXDT_BLKDATA] || rxdt_cs[`RXDT_STRDATA])));

  assign rx_data_end_bit   = rxdt_cs[`RXDT_ENDBIT];
  assign assert_read_wait  = read_wait && rxdt_cs[`RXDT_WAIT2CLK];

  // RX bit receive counter register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
         begin
           rx_byte_done_r   <= 1'b0;
           rx_bit_cnt_r     <= 3'b0;
           second_end_bit_r <= 1'b0;
         end 
      else 
         begin
           if (cclk_in_en) 
              begin
                rx_byte_done_r <= rx_byte_done;
                rx_bit_cnt_r   <= rx_bit_cnt_d;
                second_end_bit_r <= second_end_bit;
              end
         end
    end

  // RX data bit receive counter combination logic
  assign rx_bit_cnt_d     = !(rxdt_cs[`RXDT_BLKDATA] || rxdt_cs[`RXDT_STRDATA]) ?
          //SD_3.0 start             
                            3'h0 : (card_width[1] & !ddr) ? rx_bit_cnt_r + 3'h4 :
                            (card_width[0]) ? rx_bit_cnt_r + 3'h1 :
                            (card_width[2] || ddr) ? rx_bit_cnt_r : 3'h0;
          //SD_3.0 end
  // Start bit error for wide bus
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        rx_stbit_err   <= 1'b0;
      else 
        begin
          if (cclk_in_en && rxdt_cs[`RXDT_IDLE])
            rx_stbit_err <= 1'b0;
          else if (cclk_in_en && (card_width[1] || card_width[2]) &&
                 rxdt_cs[`RXDT_STBIT] &&
     //SD_3.0 start    
                 (~dp_cdata_in[0]) && (((|dp_cdata_in && (card_width[2] || (ddr && full_start_bit))) ||
                                       ((|dp_cdata_in[3:0] && (card_width[1] && (!ddr || (!start_bit_delayed && ddr && half_start_bit))))) ||
                    ((|dp_cdata_in[7:4] && (card_width[1] && (start_bit_delayed && ddr && half_start_bit)))) 
                    ) && !wait_for_boot_ack))
      //SD_3.0 end                
            rx_stbit_err <= 1'b1;
        end
    end

 
  
  assign start_rx_data_fifo  = rxdt_cs[`RXDT_STBIT] && start_bit;

  assign start_rx_data  = rxdt_cs[`RXDT_STBIT];

 //`ifdef F_DATA_WIDTH_32
  // assign fifo_depth  = `FIFO_DEPTH * 4;
 //`else 
  // assign fifo_depth  = `FIFO_DEPTH * 8;
 //`endif
 
  assign cclk_in_en_8_bit_ddr = cclk_in_en_8_ddr; 
  //assign rx_stop_clk =  (card_rd_threshold_en && (block_size <= fifo_depth)) ? (rx_stop_clk_new | (!atleast_empty && rxdt_cs[`RXDT_STBIT] )) : rx_stop_clk_new;
  assign rx_stop_clk =  (card_rd_threshold_en ) ? (rx_stop_clk_new | (!atleast_empty && rxdt_cs[`RXDT_STBIT] )) : rx_stop_clk_new;
 
 `ifdef EN_SV_ASSERTS
  // This property checks if the card clock i.e. cclk_out stops during a block of data during a read transfer.
   // Do not check this property during reset.
   property no_clock_stop;
   @(posedge cclk_in) 
      (creset_n != 0 && (card_rd_threshold_en == 1'b1 && rxdt_cs[`RXDT_BLKDATA] == 1'b1 && rx_stop_clk == 1'b1)) |-> not card_rd_threshold_en;
  endproperty

   card_clock_stopped: assert property (no_clock_stop) else $fatal("Card Clock stopped during a Data Block in a Read Transfer when CardRdThrEn=1");
 `endif 
  
  // FIFO write and clock stop module
  DWC_mobile_storage_rxfifowr
   U_DWC_mobile_storage_rxfifowr
    (/*AUTOINST*/
     // Outputs
     .fifo_push                         (fifo_push),
     .rx_stop_clk                       (rx_stop_clk_new),
     .rx_byte_done_cnt                  (rx_byte_done_cnt[2:0]),
     .rxfifo_idle                       (rxfifo_idle),
     // Inputs
     .creset_n                          (creset_n),
   //MMC4_4 start
     .cclk_in_en_8_ddr                  (cclk_in_en_8_bit_ddr),
   //MMC4_4 end
     .cclk_in                           (cclk_in),
     .cclk_in_en                        (cclk_in_en),
     .stop_data                         (stop_data),
     .fifo_full                         (fifo_full),
     .fifo_almost_full                  (fifo_almost_full),
     .start_rx_data                     (start_rx_data_fifo),
     .rx_byte_done                      (rx_byte_done),
     .dp_open_ended_xfer                (dp_open_ended_xfer),
     .byte_countrem_zero                (byte_countrem_zero),
     .abort_read_data_r                 (abort_read_data_r),
     .rx_data_endbit_err                (rx_data_endbit_err),
     .rx_data_timeout                   (rx_data_timeout_internal),
     .dp_card_wide_bus                  (dp_card_wide_bus),
     .dscrd_cur_xfer                    (dscrd_cur_xfer));

//SD_3.0 start
 assign rx_data_endbit_err = (second_end_bit || second_end_bit_r) ? rx_data_endbit_abort_err : rx_data_endbit_normal_err;
  assign rx_data_endbit_normal_err   = (end_boot?  (rxdt_cs[`RXDT_ENDBIT] && stop_data_r):
                                                   rxdt_cs[`RXDT_ENDBIT]) &&  
                                ((~dp_cdata_in[0] && card_width[0]) ||
                                 (~(&dp_cdata_in[3:0]) && (card_width[1] && (!ddr  || (!start_bit_delayed && ddr && half_start_bit )))) ||
                 (~(&dp_cdata_in[7:4]) && (card_width[1] && (!ddr  || (start_bit_delayed && ddr && half_start_bit )))) ||
                                 (~(&dp_cdata_in) && (card_width[2] || (ddr && full_start_bit))));

assign rx_data_endbit_abort_err   = rxdt_cs[`RXDT_ENDBIT] &&  second_end_bit_r &&
                                ((~dp_cdata_in[0] && card_width[0]) ||
                                 (~(&dp_cdata_in[3:0]) && (card_width[1] && (!ddr  || (!start_bit_delayed && ddr && half_start_bit )))) ||
                 (~(&dp_cdata_in[7:4]) && (card_width[1] && (!ddr  || (start_bit_delayed && ddr && half_start_bit )))) ||
                                 (~(&dp_cdata_in) && (card_width[2] || (ddr && full_start_bit))));

                 
//SD_3.0 end
  assign rx_dat0_busy         = 1'b0;

  assign rx_data_done         = (~rxdt_cs[`RXDT_IDLE] && rxdt_ns[`RXDT_IDLE] &&
                                ~(data_xfer_cmd && resp_timeout)) || 
                (rxdt_cs[`RXDT_IDLE] && end_boot_pulse);


  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
        begin
          rx_data_done_l   <= 1'b0;
        end 
      else 
        begin
          if (rx_data_done && !rx_data_done_l)
            rx_data_done_l <= 1'b1;
          else if (rx_data_done_r && cclk_in_en)
            rx_data_done_l <= 1'b0;
        end
    end

  //Data done signal after fifo state machine idle
  assign rx_data_done_r = rx_data_done_l && rxfifo_idle;

  assign rxdt_idle      = rxdt_cs[`RXDT_IDLE] && rxfifo_idle;

endmodule // DWC_mobile_storage_datarx
