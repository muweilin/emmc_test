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
// Date             :        $Date: 2013/04/01 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_cmdpath.v#42 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_cmdpath.v
// Description : DWC_mobile_storage Command path block
//               Loads new command from BIU or irq response or
//               auto stop command and registers it.
//               Transmit command and receives response if any
//               Also generates crc7 for send command and
//               checking response crc7.
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_cmdpath(
  /*AUTOARG*/
  // Outputs
  response_valid, response_err, response_done, resp_timeout, resp_crc_err,
  c2b_response_data, c2b_response_addr, auto_cmd_done,
  cmd_taken, cp_card_num, cp_cmd_idle, cp_cmd_idle_lp, cmd_fsm_state,
 //SD_3.0 start
  volt_switch_int,
 //SD_3.0 ends
  cp_ccmd_out, cp_ccmd_out_en, cp_cmd_end_bit, cp_resp_end_bit,
  cp_stop_cmd_loaded, cp_load_data_par, cp_cmd_suspend, cp_stop_abort_cmd,
  auto_stop_cmd, clk_enable, clk_low_power, clk_divider, clk_source,
  cp_cmd_crc7_end, cp_data_cmd, ccs_expected, cmd_compl_signal,
  read_ceata_device, clr_send_ccsd,
  exp_boot_ack,exp_boot_ack_pulse,exp_boot_data,exp_boot_data_pulse, 
  end_boot,end_boot_pulse,new_cmd_load,
  // Inputs
  cclk_in, cclk_in_en,creset_n, cmd_start,
  b2c_cmd_argument, b2c_resp_tmout_cnt, send_irq_response,
  sync_od_pullup_en_n, b2c_cclk_enable, b2c_cclk_low_power, b2c_clk_divider,
  b2c_clk_source, cp_ccmd_in, dp_load_stop_cmd_req, dp_data_idle,
  dp_open_ended_xfer, safe_clk_change, send_ccsd, send_auto_stop_ccsd,
  update_clk_only, wait_prvdatacmp
  ,b2c_cmd_control,
 //SD_3.0 start
 dp_cdata_in,
 //SD_3.0 ends
 boot_ack_err,rx_byte_count_rem_zero,rx_end_bit,
  bar_intr
    );
  
  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clock and Reset
  input                     cclk_in;             // Clock
  input                     cclk_in_en;          // Clock enable
  input                     creset_n;            // Card Reset - Active Low

  // From BIU
  input                     cmd_start;           // Cmd start
  input              [31:0] b2c_cmd_argument;    // Cmd arguments
  input               [7:0] b2c_resp_tmout_cnt;  // Resp timeout cnt
  input                     send_irq_response;   // Send IRQ response
  input                     sync_od_pullup_en_n; // Open drain pullup enable
  input [`NUM_CARD_BUS-1:0] b2c_cclk_enable;     // Card clock enable
  input [`NUM_CARD_BUS-1:0] b2c_cclk_low_power;  // Card low power enable
  input              [31:0] b2c_clk_divider;     // Clock divider value
  input              [31:0] b2c_clk_source;      // Card clock source
  input                     send_ccsd;           // Send CCSD to CE-ATA device
  input                     send_auto_stop_ccsd; // Send auto stop after CCSD
  input                     update_clk_only;     // Cclk_in registered b2c_cmd_control[21]
  input                     wait_prvdatacmp;     // Cclk_in registered b2c_cmd_control[13]
 //SD_3.0 start
  input              [28:0] b2c_cmd_control;
 input              [3:0]  dp_cdata_in;
 //SD_3.0 ends
  input                     boot_ack_err;        // Boot ack error indication
  input                     rx_byte_count_rem_zero; //Rx byte count
  input                     rx_end_bit;             //rxdt_cs[`RXDT_ENDBIT]
  input                     bar_intr;               //BAR interrupt

  // outputs to BIU
  output                    response_valid;      // Response valid
  output                    response_err;        // Response error
  output                    response_done;       // Cmd/resp done
  output                    resp_timeout;        // Response timeout occured
  output                    resp_crc_err;        // Response crc error
  output             [37:0] c2b_response_data;   // Response data
  output              [1:0] c2b_response_addr;   // Response addr
  output                    auto_cmd_done;       // Auto stop command done
  output                    cmd_taken;           // New command taken

  output              [3:0] cp_card_num;         // Card number
  output                    cp_cmd_idle;         // Command path is idle
  output                    cp_cmd_idle_lp;      // Cmd path idle low_power
  output              [3:0] cmd_fsm_state;       // Command FSM state
 //SD_3.0 start
  output                    volt_switch_int;     // Voltage switch trigger
 //SD_3.0 ends


  //  Card Interface
  input                     cp_ccmd_in;          // Card Cmd Input
  output                    cp_ccmd_out;         // Card Cmd Output
  output                    cp_ccmd_out_en;      // Card Cmd Output Enable

  // Data Path Ports
  input                     dp_load_stop_cmd_req;// Load auto stop cmd
  input                     dp_data_idle;        // Data path idle
  input                     dp_open_ended_xfer;  // Open ended data Xfer
  output                    cp_cmd_end_bit;      // Cmd transmit end bit
  output                    cp_resp_end_bit;     // Resp receive end bit
  output                    cp_stop_cmd_loaded;  // Autostop cmd loaded
  output                    cp_load_data_par;    // Load data parameters
  output                    cp_cmd_suspend;      // Cmd is SUSPEND
  output                    cp_stop_abort_cmd;   // Cmd is stop/to abort
  output                    auto_stop_cmd;       // Cmd is auto stop
  output                    cp_cmd_crc7_end;     // Last bit of CRC7 of cmd
  output                    cp_data_cmd;         // Cmd with data xfer
  output                    ccs_expected;        // CCS Expected for the cur cmd.
  output                    cmd_compl_signal;    // CCS from CE-ATA device
  output                    read_ceata_device;   // CE_ATA Read access
  output                    clr_send_ccsd;       // Clear the send_ccsd in BIU
  output                    exp_boot_ack;        // Level indication of boot ack pattern expected to datarx block
  output                    exp_boot_ack_pulse;  // Pulse indication of exp_boot_ack to datarx block
  output                    exp_boot_data;       // Level indication of exp_boot_data to datarx block
  output                    exp_boot_data_pulse; // Pulse indication of exp_boot_data to datarx block
  output                    end_boot;            // end boot indication to datarx block
  output                    end_boot_pulse;      // end boot indication pulse to datarx block
  output                    new_cmd_load;
  // Clock control
  input                     safe_clk_change;     // Safe Clock Change
  output             [15:0] clk_enable;          // Card clock enable
  output             [15:0] clk_low_power;       // Card clock low power
  output             [31:0] clk_divider;         // Clock divider
  output             [31:0] clk_source;          // Card clk source

  // command transmit states defines
  `define      CP_IDLE                  0    // Cmd path idle
  `define      TXCMD_ISEQ               1    // Send init sequence
  `define      TXCMD_STBIT              2    // Tx cmd start bit
  `define      TXCMD_TXBIT              3    // Tx cmd tx bit
  `define      TXCMD_PAR                4    // Tx cmd index + arg
  `define      TXCMD_CRC7               5    // Tx cmd crc7
  `define      TXCMD_ENDBIT             6    // Tx cmd end bit
  `define      RXRESP_STBIT             7    // Rx resp start bit
  `define      RXRESP_IRQRESP           8    // Rx resp IRQ resp
  `define      RXRESP_TXBIT             9    // Rx resp tx bit
  `define      RXRESP_CMDIDX            10   // Rx resp cmd idx
  `define      RXRESP_DATA              11   // Rx resp data
  `define      RXRESP_CRC7              12   // Rx resp crc7
  `define      RXRESP_ENDBIT            13   // Rx resp end bit
  `define      CPWAIT_NCC               14   // Cmd path wait ncc
  `define      CPWAIT_CRT               15   // Wait cmd to resp turnaround
  `define      CPWAIT_CCS               16   // Wait CCS from CE-ATA device
  `define      CPSEND_CCSD              17   // Send CCSD to CE-ATA device
  `define      CP_BOOT                  18   // Mandatory boot mode
 //SD_3.0 start
 `define      CP_VOLT_SWITCH_1         19   // Checks for CMD and DAT lines to be low.
 `define      CP_VOLT_SWITCH_2         20   // Check for CMD and DAT line to be high.
 //SD_3.0 ends

  // parameters for irq response and auto stop command
  parameter    IRQ_RESP_CMD_CONTROL  = 16'h28;   // R5 {0 + cmd_idx = 6'h28}
  parameter    IRQ_RESP_CMD_ARGUMENT = 32'h0;    // RCA=0x0 + Not define
  parameter    STOP_CMD_CONTROL      = 16'h414c; // {0100,3'b101,cmd_idx=6'hc}
  parameter    STOP_CMD_ARGUMENT     = 32'h0; // Stuff bits

  // command decode parameters
  parameter    GOIRQ_CMD_IDX         = 6'h28;   // CMD40
  parameter    SUSPEND_CMD_IDX       = 6'h34;   // CMD52 - fn = 0
  parameter    SUSPEND_CMD_FN        = 4'h8;    // CMD52 - r/w = 1'b1, fn=3'h0
  parameter    SUSPEND_CMD_REGADDR   = 17'h0c;  // CMD52 - reg addr = 0x0C

  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Registers
 //SD_3.0 start
  reg             [20:0] cp_cs;           // Cmd path state m/c current state
  reg             [20:0] cp_ns;           // Cmd path state m/c next state
 //SD_3.0 ends
  reg                    exp_boot_ack_pulse;
  reg                    exp_boot_data_pulse;
  reg             [37:0] shift_reg;       // Command shift register
  reg              [3:0] cp_card_num;        // Card number
  reg                    send_init_seq;      // Send init seq
  reg                    wait_prvdata_comp;  // Wait prv data complete
  reg                    check_response_crc; // Check crc resp
  reg                    response_length;    // Resp short/long
  reg                    response_expected;  // Response expected
  reg              [7:0] resp_timeout_cnt;   // Resp timeout count
  reg              [5:0] cmd_idx;            // Cmd index
  reg             [31:0] cmd_arg;            // Cmd argument
  reg             [15:0] clk_enable;         // Card clock enable
 //SD_3.0 start
 reg             [15:0] clk_enable_r;         // Card clock enable registered.
 //SD_3.0 ends
  reg             [15:0] clk_low_power;      // Card clock low power
  reg             [31:0] clk_divider;        // Clock divider
  reg             [31:0] clk_source;         // Card clk source
  reg                    ld_stop_cmd_req_r1; // Load autostop req r1
  reg                    load_stop_cmd_req_r;// Load autostop req reg
  reg                    load_cmd_r;         // load_cmd reg
  reg                    cmd_taken_toggle;   // cmd_taken toggle
  reg                    load_clk_par_req_r; // Load clk par reg
  reg                    irq_resp_req_r;     // IRQ resp request reg
  reg                    cp_stop_abort_cmd;  // Cmd is stop/to abort
  reg              [1:0] response_addr_reg;  // Response addr reg
  reg             [37:0] c2b_response_data;  // Response data
  reg              [1:0] c2b_response_addr;  // Response addr
  reg                    resp_txbit_err;     // Response tx bit error
  reg                    rx_resp_crc_err;    // Response crc error reg
  reg                    cp_cmd_end_bit;     // Comand end bit
  reg                    cp_cmd_end_bit_r1;  // Comand end bit r1
  reg                    new_cmd_loaded;     // New command is loaded
  reg                    cp_cmd_suspend;     // Cmd is SUSPEND
  reg                    cp_cmd_goirq;       // Cmd is GO IRQ STATE
  reg                    cmd_irq_resp;       // Cmd is irq resp
  reg                    auto_stop_cmd;      // Cmd is auto stop
  reg              [7:0] new_count;          // Counter new value
  reg                    load_counter;       // Load new counter value
  reg              [7:0] count_r;            // Down counter - count
  reg                    response_valid;     // Response valid reg
  reg              [4:0] cmd_fsm_state_w;    // Command FSM state combinational
  reg              [3:0] cmd_fsm_state;      // Command FSM state registered
  reg                    load_irq_resp_r;    // Load IRQ resp registered
  reg                    stop_cmd_req_r;     // Stop command request registered
  reg                    cp_data_cmd;        // Cmd with data xfer
  reg                    ccs_expected;       // CCS from CE-ATA is expected 
  reg                    read_ceata_device;  // Read data transfer command
  reg                    tnrc_elapsed;       // tNRC cycles elapsed after Response.
  reg                    exp_boot_ack;
  reg                    exp_boot_ack_r;     // Registered version of exp_boot_ack.
  reg                    exp_boot_data;
  reg                    exp_boot_data_r;    // Registered version of exp_boot_data
 reg                    man_boot_mode;      // flag for mandatory boot mode after exiting CP_BOOT state.
  reg                    man_boot_mode_r;    // Registered version of man_boot_mode
 //SD_3.0 start
 reg                    volt_switch_int;
 reg                    switch_flag_en;
 reg                    switch_flag;
 //SD_3.0 ends
  // Wires
  wire                   start_bit_n;        // Send start bit
  wire                   tx_bit;             // Send transmit bit
  wire                   serial_data;        // Serial data
  wire                   serial_crc;         // Serial crc7
  wire                   din;                // serial datain to crc7 module
  wire                   cmd_out;            // Command out wire
  wire             [1:0] response_addr;      // Response addr
  wire                   response_err;       // Response received error
  wire                   counter_zero;       // Down-counter = 0
  wire                   load_cmd;           // Load cmd wire
  wire                   load_new_cmd;       // Load new cmd
  wire                   load_clk_par;       // Load clock parameters
  wire                   block_cmd;          // Block new cmd
  wire                   load_cmd_par;       // Load new cmd parameters
  wire                   load_stop_cmd;      // Load auto stop
  wire                   wait_prvdatacmp_new;// New cmd wait prv data
  wire                   int_cmd_start;      // Internal cmd start
  wire                   load_irq_resp;      // Load irq resp
  wire                   irq_resp_req;       // Irq resp request
  wire                   load_clk_par_req;   // Load clk par req
  wire            [31:0] cmd_control;        // Command control par
  wire            [31:0] cmd_argument;       // Command argument
  wire             [4:0] shift_reg_sel;      // Shift reg select line
  wire            [37:0] shift_reg_d;        // Command shift register
  wire                   response_valid_w;   // Response valid wire
  wire                   start_crc;          // Start CRC wire
  wire                   send_serial_crc;    // Send serial CRC wire
  wire                   stop_cmd_req;       // Stop cmd request
  wire                   ccsd_done;          // CCSD send to CE-ATA device
  wire                   okay_to_send_ccsd;  // Okay to send CCSD while waiting for CCS
  wire            [15:0] b2c_cmd_control_wire; // To accomodate the registered 
                                               // b2c_cmd_control[13]
  wire                   dis_boot;             
  wire                   enable_boot;
  wire                   expect_boot_ack;
 wire                   boot_mode;
  reg                    end_boot_r;
//SD_3.0 start
  wire                   voltage_switch;
 wire                   voltage_switch_error_2;
 reg          voltage_switch_error_2_r;
//SD_3.0 ends
 

 assign enable_boot = b2c_cmd_control[24];
 assign new_cmd_load = new_cmd_loaded;
 assign end_boot = end_boot_r;
 assign expect_boot_ack = b2c_cmd_control[25];
 assign boot_mode = b2c_cmd_control[27];
 //SD_3.0 start
 assign voltage_switch = b2c_cmd_control[28];
 //SD_3.0 ends

 //Genaration of end_boot_r, end_boot signal
 always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
         begin
           end_boot_r   <= 1'b0;
         end 
      else 
        begin
          if (new_cmd_loaded) 
            begin
              end_boot_r <= 1'b0;
            end
          else if (cclk_in_en & cp_cs[`TXCMD_ENDBIT]) 
            begin
              end_boot_r <= dis_boot;
            end
        end   
    end
  
 assign end_boot_pulse = cp_cs[`TXCMD_ENDBIT] & dis_boot;

 //exp_boot_ack_r and exp_boot_data_r and man_boot_mode_r flags
 always @ (posedge cclk_in or negedge creset_n)
 begin
   if (~creset_n) 
      begin
        exp_boot_ack_r   <= 1'b0;
        exp_boot_data_r  <= 1'b0;
        man_boot_mode_r  <= 1'b0;
      end  
   else 
      begin
        if (new_cmd_loaded) 
           begin
             exp_boot_ack_r   <= 1'b0;
             exp_boot_data_r  <= 1'b0;
             man_boot_mode_r  <= man_boot_mode;
           end
        else if (cclk_in_en) 
           begin
             exp_boot_ack_r   <= exp_boot_ack;
             exp_boot_data_r  <= exp_boot_data;
             man_boot_mode_r  <= man_boot_mode;
           end
      end  
 end

  //----------------------------------------------------
  // Command Path Register Logic
  //----------------------------------------------------

  // Generated cmd taken toggle
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
         begin
           load_cmd_r          <= 1'b0;
           cmd_taken_toggle    <= 1'b0;
         end 
      else 
         begin
           load_cmd_r          <= load_cmd;
           if (load_new_cmd || load_clk_par)
              cmd_taken_toggle  <= ~cmd_taken_toggle;
         end
    end

  // Generation of new command pulse
  assign int_cmd_start = cmd_start ^ cmd_taken_toggle;
  assign load_new_cmd  = load_cmd && ~load_cmd_r;
 //CP_BOOT is also checked in the condition below since application
 //can decide to end the boot process at any time. In mandatory boot
 //mode the cp_cs FSM will not be idle state when the boot mode is in
 //progress
  //CP_VOLT_SWITCH_1  is for start error(cmd & dat line not going low)
  //CP_VOLT_SWITCH_2  is for normal transfer.
  assign load_cmd      = int_cmd_start && (cp_cmd_idle | cp_cs[`CP_BOOT] | (voltage_switch &&  (cp_cs[`CP_VOLT_SWITCH_1] || cp_cs[`CP_VOLT_SWITCH_2] ))) && ~block_cmd &&
                         ~update_clk_only;


  assign block_cmd     = ((wait_prvdatacmp_new  && !dp_data_idle &&
                           !dp_open_ended_xfer) || load_stop_cmd_req_r);



  // Load irq resp parameter pulse logic
  assign load_irq_resp = irq_resp_req && ~irq_resp_req_r;
  assign irq_resp_req  = send_irq_response && cp_cs[`RXRESP_IRQRESP]
                         && cp_ccmd_in;

  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
         begin
           load_stop_cmd_req_r   <= 1'b0;
           ld_stop_cmd_req_r1    <= 1'b0;
           irq_resp_req_r        <= 1'b0;
           load_irq_resp_r       <= 1'b0;
           stop_cmd_req_r        <= 1'b0;
           tnrc_elapsed          <= 1'b0;
         end 
      else  
         begin
           ld_stop_cmd_req_r1    <= load_stop_cmd_req_r && cp_cmd_idle;
           irq_resp_req_r        <= irq_resp_req;
           stop_cmd_req_r        <= (dp_load_stop_cmd_req || (send_auto_stop_ccsd && cp_cs[`CPSEND_CCSD]));

           if (load_stop_cmd)
             load_stop_cmd_req_r <= 1'b0;
           else if (stop_cmd_req)
             load_stop_cmd_req_r <= 1'b1;

           if(load_irq_resp)
             load_irq_resp_r     <= 1'b1;
           else if (cclk_in_en && load_irq_resp_r)
             load_irq_resp_r     <= 1'b0;
 
           if (cp_cs[`RXRESP_ENDBIT] && ccs_expected)
             tnrc_elapsed        <= 1'b0;
           else if (cp_cs[`CPWAIT_CCS] && counter_zero)
             tnrc_elapsed        <= 1'b1;
         end
    end

  // Stop command parameter pulse
  assign load_stop_cmd = (load_stop_cmd_req_r && cp_cmd_idle &&
                          ~ld_stop_cmd_req_r1);

  assign load_cmd_par  = load_stop_cmd || load_irq_resp || load_new_cmd;

  assign stop_cmd_req  = (dp_load_stop_cmd_req || (send_auto_stop_ccsd && cp_cs[`CPSEND_CCSD])) && ~stop_cmd_req_r;

  // Load clock parameter pulse
  assign load_clk_par      = load_clk_par_req && ~load_clk_par_req_r;
  assign load_clk_par_req  = int_cmd_start    &&  update_clk_only &&
                             (safe_clk_change | (voltage_switch && (cp_cs[`CP_VOLT_SWITCH_1] || cp_cs[`CP_VOLT_SWITCH_2] )) );


  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        load_clk_par_req_r   <= 1'b0;
      end else begin
        load_clk_par_req_r   <= load_clk_par_req;
      end
    end

  // Selecting new/stop/irq command parameter
  assign b2c_cmd_control_wire = {b2c_cmd_control[15:14], wait_prvdatacmp, b2c_cmd_control[12:0]};

  assign cmd_control[15:0] = (load_irq_resp)  ?  IRQ_RESP_CMD_CONTROL :
                             (load_stop_cmd)  ?  STOP_CMD_CONTROL :
                                                 b2c_cmd_control_wire;
  assign cmd_control[20:16]= ((load_irq_resp) || (load_stop_cmd)) ?
                               cp_card_num   :  b2c_cmd_control[20:16];
  assign cmd_control[23:22]= ((load_irq_resp) || (load_stop_cmd)) ?
                               2'b00   :  b2c_cmd_control[23:22];
  assign cmd_argument      = (load_irq_resp)  ?  IRQ_RESP_CMD_ARGUMENT :
                             (load_stop_cmd)  ?  STOP_CMD_ARGUMENT :
                                                 b2c_cmd_argument;
  assign wait_prvdatacmp_new = cmd_control[13];

  // Check for sending CCSD 
  assign okay_to_send_ccsd  = send_ccsd && tnrc_elapsed && cp_ccmd_in;

  // Register command parameters
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
        begin
          cp_card_num           <= 4'h0;
          send_init_seq         <= 1'b0;
          cp_stop_abort_cmd     <= 1'b0;
          wait_prvdata_comp     <= 1'b0;
          check_response_crc    <= 1'b0;
          response_length       <= 1'b0;
          response_expected     <= 1'b0;
          resp_timeout_cnt      <= 8'h0;
          cmd_idx               <= 6'h0;
          cmd_arg               <= 32'h0;
          cmd_irq_resp          <= 1'b0;
          cp_cmd_goirq          <= 1'b0;
          cp_cmd_suspend        <= 1'b0;
          auto_stop_cmd         <= 1'b0;
          cp_data_cmd           <= 1'b0;
          ccs_expected          <= 1'b0;
          read_ceata_device     <= 1'b0;
        end 
      else 
        begin
          if (load_cmd_par == 1'b1) 
             begin
               ccs_expected       <= cmd_control[23];
               read_ceata_device  <= cmd_control[22];
               if (`CARD_TYPE == 0)
                 cp_card_num      <= 4'b0;
               else
                 cp_card_num      <= cmd_control[19:16];

               send_init_seq       <= cmd_control[15];
               cp_stop_abort_cmd   <= cmd_control[14];
               wait_prvdata_comp   <= cmd_control[13];
               check_response_crc  <= cmd_control[8];
               response_length     <= cmd_control[7];
               response_expected   <= cmd_control[6];
               resp_timeout_cnt    <= b2c_resp_tmout_cnt;
               cmd_idx             <= cmd_control[5:0];
               cmd_arg             <= cmd_argument;
               // cmd decode
               auto_stop_cmd       <= load_stop_cmd;
               cp_cmd_goirq        <= (cmd_control[5:0]  == GOIRQ_CMD_IDX);
               cp_cmd_suspend      <= ((cmd_control[5:0] == SUSPEND_CMD_IDX) &&
                                      (cmd_argument[31:28] == SUSPEND_CMD_FN) &&
                                      (cmd_argument[25:9]  == SUSPEND_CMD_REGADDR));
               cmd_irq_resp        <= irq_resp_req;
               cp_data_cmd         <= cmd_control[9];
             end
        end
    end

  // Clock control parameter register
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        clk_enable             <= 16'h0;
        clk_low_power          <= 16'h0;
        clk_divider            <= 32'h0;
        clk_source             <= 32'h0;
      end else begin
        if (load_clk_par == 1'b1) begin
          clk_enable           <= b2c_cclk_enable;
          clk_low_power        <= b2c_cclk_low_power;
          clk_divider          <= b2c_clk_divider;
          clk_source           <= b2c_clk_source;
        end
      end
    end

  //SD_3.0 start
  //Registering clk_enable to detect edge.
    always @ (posedge cclk_in or negedge creset_n)
      begin
        if (~creset_n)
          clk_enable_r          <= 16'h0;
        else 
          begin
            clk_enable_r          <= clk_enable;
          end   
       end
  //SD_3.0 ends

  assign cmd_taken          = load_new_cmd || load_clk_par;
  assign cp_stop_cmd_loaded = load_stop_cmd;

  // Loaded all data parameters when data path is free
  // does not check for data_expected for new cmd
  assign cp_load_data_par   = !load_stop_cmd && dp_data_idle && load_cmd_par;

  //----------------------------------------------------------------------
  // Command Path state machine
  //----------------------------------------------------------------------

  // Command path state machine register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        cp_cs   <= 18'h1;
      else begin
        if (cclk_in_en)
          cp_cs <= cp_ns;
      end
    end

  // command path combinational logic
  // command transmit state machine combinational logic
  always @ (/*AUTOSENSE*/ count_r
            or counter_zero or cp_ccmd_in or cp_cmd_goirq or cp_cs
            or load_irq_resp or load_irq_resp_r or new_cmd_loaded or
            resp_timeout_cnt or response_expected or response_length
            or send_init_seq or ccs_expected or okay_to_send_ccsd or 
            exp_boot_ack_r or exp_boot_data_r or enable_boot
            or expect_boot_ack or boot_mode or boot_ack_err or dis_boot
            or man_boot_mode_r or rx_byte_count_rem_zero or rx_end_bit 
            or switch_flag or clk_enable or clk_enable_r 
            or dp_cdata_in or cp_card_num or voltage_switch or voltage_switch_error_2_r)
    begin : FSM_cp
      cp_ns        = {18{1'b0}};
      new_count    = 8'h0;
      load_counter = 1'b0;
      exp_boot_ack        = exp_boot_ack_r;
      exp_boot_data       = exp_boot_data_r;
      exp_boot_ack_pulse  = 1'b0;
      exp_boot_data_pulse = 1'b0;
      man_boot_mode       = man_boot_mode_r;
      //SD_3.0 start
      volt_switch_int     = 1'b0;
      switch_flag_en         = 1'b0;
      //SD_3.0 ends
      case (1'b1)
        cp_cs[`CP_IDLE] : 
          begin // command path idle
            new_count             = 8'h4f; // Init seq count=80
            load_counter          = 1'b1;
            if(new_cmd_loaded & enable_boot) 
               begin
                 cp_ns[`CP_BOOT]     = 1'b1;
                 new_count           = 8'd73;
                 load_counter        = 1;
               end  
            else if (new_cmd_loaded && send_init_seq )
                cp_ns[`TXCMD_ISEQ]  = 1'b1;
            else if (new_cmd_loaded)
                cp_ns[`TXCMD_STBIT] = 1'b1;
             else
                cp_ns[`CP_IDLE]     = 1'b1;
          end


       cp_cs[`CP_BOOT] : 
          begin // Mandatory boot mode
            if((new_cmd_loaded && dis_boot) || // Mandatory abort
            ((rx_byte_count_rem_zero && rx_end_bit) && dis_boot) || // Mandatory normal 
            boot_ack_err) //Mandatory Ack error 
               begin
                 //rx_boot_data_end     = 1;
                 cp_ns[`TXCMD_ENDBIT] = 1;
                 man_boot_mode = 1'b1;
               end
            else if(count_r == 1) 
              begin
                exp_boot_ack        = expect_boot_ack;
                exp_boot_ack_pulse  = expect_boot_ack & !exp_boot_ack_r;
                exp_boot_data       = !expect_boot_ack;
                exp_boot_data_pulse = !expect_boot_ack & !exp_boot_data_r;
                cp_ns[`CP_BOOT]     = 1'b1;
              end
            else 
              begin
                exp_boot_ack        = exp_boot_ack_r;
                exp_boot_data       = exp_boot_data_r;
                cp_ns[`CP_BOOT]     = 1'b1;
              end
          end     


        cp_cs[`TXCMD_ISEQ] : 
           begin // send initialization sequence
             if (counter_zero)
               cp_ns[`TXCMD_STBIT] = 1'b1;
             else
               cp_ns[`TXCMD_ISEQ]  = 1'b1;
           end

        // send start bit
        cp_cs[`TXCMD_STBIT] : cp_ns[`TXCMD_TXBIT] = 1'b1;


        // send tx bit
        cp_cs[`TXCMD_TXBIT] : 
           begin
             cp_ns[`TXCMD_PAR]     = 1'b1;
             new_count             = 8'h25;  // cmdidx + cmd arg
             load_counter          = 1'b1;
           end

        // send command parameters (cmd index + arguments)
        cp_cs[`TXCMD_PAR] : 
           begin
              if (counter_zero) 
                begin
                  cp_ns[`TXCMD_CRC7]  = 1'b1;
                  new_count           = 8'h6; // crc7
                  load_counter        = 1'b1;
                end 
              else
                cp_ns[`TXCMD_PAR]   = 1'b1;
            end

        // send CRC7 response
        cp_cs[`TXCMD_CRC7] : 
          begin
            if (counter_zero)
              cp_ns[`TXCMD_ENDBIT] = 1'b1;
            else
              cp_ns[`TXCMD_CRC7]   = 1'b1;
          end

        // send command end bit
        cp_cs[`TXCMD_ENDBIT] : 
          begin
            if(dis_boot) 
              begin
                exp_boot_ack        = 1'b0;
                exp_boot_ack_pulse  = 1'b0;
                exp_boot_data       = 1'b0;
                exp_boot_data_pulse = 1'b0;
              end 
            else if (boot_mode == 1'b1) 
              begin       
                exp_boot_ack        = expect_boot_ack;
                exp_boot_ack_pulse  = expect_boot_ack;
                exp_boot_data       = !expect_boot_ack;
                exp_boot_data_pulse = !expect_boot_ack;
              end

            if (response_expected) 
              begin
                cp_ns[`CPWAIT_CRT]  = 1'b1;
                new_count           = 8'h2;
                load_counter        = 1'b1;
              end 
            else 
              begin
                cp_ns[`CPWAIT_NCC]  = 1'b1;
                if(man_boot_mode_r == 1'b1) 
                  begin
                    new_count           = 8'h37; // ncc count
                    load_counter        = 1'b1;  
                  end 
                else 
                  begin
                    new_count           = 8'h7; // ncc count
                    load_counter        = 1'b1;
                  end    
              end
        end

        // wait for command to response turn around time
        cp_cs[`CPWAIT_CRT]:
           begin
             if (counter_zero && cp_cmd_goirq)
               cp_ns[`RXRESP_IRQRESP] = 1'b1;
             else if (counter_zero) 
                begin
                  cp_ns[`RXRESP_STBIT]   = 1'b1;
                  new_count              = resp_timeout_cnt;
                  load_counter           = 1'b1;
                end 
             else
               cp_ns[`CPWAIT_CRT]     = 1'b1;
           end

        // wait for IRQ response or send_irq_resp request
        cp_cs[`RXRESP_IRQRESP] :
          begin
            if (~cp_ccmd_in)
              cp_ns[`RXRESP_TXBIT]   = 1'b1;
            else if (load_irq_resp || load_irq_resp_r)
              cp_ns[`TXCMD_STBIT]    = 1'b1;
            else
              cp_ns[`RXRESP_IRQRESP] = 1'b1;
          end

        // wait for response start bit
        cp_cs[`RXRESP_STBIT] :
          begin
            if (~cp_ccmd_in)
              cp_ns[`RXRESP_TXBIT]   = 1'b1;
            else if (counter_zero) 
              begin // response timeout
                cp_ns[`CPWAIT_NCC]     = 1'b1;
                new_count              = 8'h7; // ncc count
                load_counter           = 1'b1;
              end 
            else
              cp_ns[`RXRESP_STBIT]   = 1'b1;
          end

        // receive response tx bit
        cp_cs[`RXRESP_TXBIT] : 
          begin
            cp_ns[`RXRESP_CMDIDX]    = 1'b1;
            new_count                = 8'h5;
            load_counter             = 1'b1;
          end

        // receive response cmd index
        cp_cs[`RXRESP_CMDIDX] :
          begin
            if (counter_zero)
              cp_ns[`RXRESP_DATA]   = 1'b1;
            else
              cp_ns[`RXRESP_CMDIDX] = 1'b1;

            // long response
            if (counter_zero) 
              begin
                if (response_length) 
                  begin
                    new_count           = 8'h7f;
                    load_counter        = 1'b1;
                    // short response
                  end
                else 
                  begin
                    new_count           = 8'h1f;
                    load_counter        = 1'b1;
                  end
              end
          end

        // Receive response data
        cp_cs[`RXRESP_DATA] : 
          begin
            if (counter_zero) 
              begin
                cp_ns[`RXRESP_CRC7]   = 1'b1;
                new_count             = 8'h6; // crc7
                load_counter          = 1'b1;
              // Checking count_r = 1 since only 127 bits should be received
              end 
            else if ((count_r == 8'h1) && response_length)
              cp_ns[`RXRESP_ENDBIT] = 1'b1; // no crc7 for long reponse
            else
              cp_ns[`RXRESP_DATA]   = 1'b1;
          end

        // receive response crc7
        cp_cs[`RXRESP_CRC7] : 
          begin
              if (counter_zero)
                cp_ns[`RXRESP_ENDBIT] = 1'b1;
              else
                cp_ns[`RXRESP_CRC7]   = 1'b1;
            end

        // receive response end bit
        cp_cs[`RXRESP_ENDBIT] :
          begin
            if (ccs_expected)
               begin
                 cp_ns[`CPWAIT_CCS]  = 1'b1;
                 new_count           = 8'h7;
                 load_counter        = 1'b1;
               end
            else 
               begin  
                 cp_ns[`CPWAIT_NCC]   = 1'b1;
                 new_count            = 8'h7;
                 load_counter         = 1'b1;
               end
          end

         // wait for CCS from CE-ATA device
         cp_cs[`CPWAIT_CCS] : 
           begin
             if (~cp_ccmd_in) 
                begin
                  cp_ns[`CPWAIT_NCC]      = 1'b1;
                  new_count               = 8'h7;
                  load_counter            = 1'b1;
                end 
             else if (okay_to_send_ccsd) 
                begin
                  cp_ns[`CPSEND_CCSD]     = 1'b1;
                  new_count               = 8'h4;
                  load_counter            = 1'b1;
                end
             else
               cp_ns[`CPWAIT_CCS]      = 1'b1;
           end

        cp_cs[`CPSEND_CCSD] :
          begin
            if (counter_zero)
               begin
                  cp_ns[`CPWAIT_NCC]      = 1'b1;
                  new_count               = 8'h7;
                  load_counter            = 1'b1;
               end
            else
              cp_ns[`CPSEND_CCSD]     = 1'b1;
         end

 // wait for tNCC time
        cp_cs[`CPWAIT_NCC] :
          begin
            if (counter_zero)
              cp_ns[`CP_IDLE]       = 1'b1;
      //SD_3.0 start
            else if(voltage_switch == 1'b1)
              cp_ns[`CP_VOLT_SWITCH_1] = 1'b1; 
     //SD_3.0 ends
            else
              cp_ns[`CPWAIT_NCC]    = 1'b1;
          end
        //SD_3.0 start
  //Proper voltage switch sequence_1: Looking for the CMD and DAT line to go low.
  //Voltage Switch failed: The app does not get a volt_switch_int and times out.
  //Causing the app to switch off the card clk and generate a power cycle(reset).
         cp_cs[`CP_VOLT_SWITCH_1] :
           begin
             if((cp_ccmd_in == 1'b0) && (dp_cdata_in==4'b0000)) 
               begin //Proper voltage switch sequence_1
                 cp_ns[`CP_VOLT_SWITCH_2] = 1'b1;
                 volt_switch_int = 1'b1;
               end  
             else if((cp_ccmd_in == 1'b1) || |dp_cdata_in[3:0]) //Voltage switch failed.
               cp_ns[`CP_IDLE] = 1'b1;    
             else
               cp_ns[`CP_VOLT_SWITCH_1] = 1'b1;
           end  
  //Proper voltage switch sequence_2: 1st we look for the falling edge of the clk enable, for the 5ms timer 
  // and set a flag "switch_flag". Then we wait till we get the CMD and DAT lines go high.
  //Voltage Switch failed: The app does not get a volt_switch_int and times out, and would then switch off the clk.
  // If the core finds a  falling edge of the clk enable and the "switch_flag" is set 
  // this would state that an error has occured and Voltage Switch has failed
        cp_cs[`CP_VOLT_SWITCH_2] : 
          begin
            if((clk_enable[cp_card_num]== 1'b0 && clk_enable_r[cp_card_num]== 1'b1 ) && !switch_flag)
               begin //detect card clk being switched off
                 switch_flag_en = 1'b1;                                                                          // for the 5 ms timer.
                 cp_ns[`CP_VOLT_SWITCH_2] = 1'b1;
               end
            else if((cp_ccmd_in == 1'b1) && (dp_cdata_in==4'b1111) && switch_flag && !voltage_switch_error_2_r)
               begin  //Proper voltage switch
                 cp_ns[`CP_IDLE] = 1'b1; 
                 volt_switch_int = 1'b1;
                 switch_flag_en = 1'b0; 
               end
            else if((cp_ccmd_in == 1'b1) && (dp_cdata_in==4'b1111) && switch_flag && voltage_switch_error_2_r)
               begin //Voltage Switch failed 2nd
                 cp_ns[`CP_IDLE] = 1'b1;                                      
                 switch_flag_en = 1'b0;
               end 
            else if((cp_ccmd_in == 1'b1) && (dp_cdata_in==4'b1111) && !switch_flag) 
               begin  //After voltge switch is over succesfully
                 cp_ns[`CP_IDLE] = 1'b1;                                                      //Also after voltage switch has failed.
                 switch_flag_en = 1'b0;                                                 // Helps to go to the IDLE state.
               end
            else
               begin 
                 cp_ns[`CP_VOLT_SWITCH_2] = 1'b1;                   
                 switch_flag_en = switch_flag;
               end   
    //SD_3.0 ends
           end 
      endcase
    end

  // shift register logic
  // single 38 bit shift register is shared for
  // sending command and receiving response
  assign shift_reg_sel[0] = cp_cs[`TXCMD_TXBIT];
  assign shift_reg_sel[1] = cp_cs[`TXCMD_PAR] || cp_cs[`CPSEND_CCSD];
  assign shift_reg_sel[2] = cp_cs[`RXRESP_CMDIDX];
  assign shift_reg_sel[3] = (cp_cs[`RXRESP_DATA] || (cp_cs[`RXRESP_ENDBIT]
                                                     && response_length));
  assign shift_reg_sel[4] = (cp_cs[`CPWAIT_CCS] && okay_to_send_ccsd);

  assign  shift_reg_d     = {cmd_idx,cmd_arg}      & {38{shift_reg_sel[0]}} |
                            {shift_reg[36:0],1'b0} & {38{shift_reg_sel[1]}} |
                            {shift_reg[36:32],cp_ccmd_in,shift_reg[31:0]} &
                            {38{shift_reg_sel[2]}} |
                            {shift_reg[37:32],shift_reg[30:0],cp_ccmd_in} &
                            {38{shift_reg_sel[3]}} |
       {6'b000011, 32'hFFFF_FFFF} & {38{shift_reg_sel[4]}};

  // Register response addr,data with response valid, etc
  always @(posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
         begin
           c2b_response_addr    <= 2'h0;
           c2b_response_data    <= 38'h0;
           response_addr_reg    <= 2'b0;
           rx_resp_crc_err      <= 1'b0;
           cp_cmd_end_bit_r1    <= 1'b0;
           cp_cmd_end_bit       <= 1'b0;
           new_cmd_loaded       <= 1'b0;
           shift_reg            <= 38'h0;
           resp_txbit_err       <= 1'b0;
           response_valid       <= 1'b0;
         end 
       else 
         begin
           response_addr_reg    <= response_addr;

           if (cclk_in_en && (|shift_reg_sel))
             shift_reg          <= shift_reg_d;

           if (load_cmd_par)
             new_cmd_loaded     <= 1'b1;
           else if (cclk_in_en && new_cmd_loaded)
             new_cmd_loaded     <= 1'b0;

           if (cclk_in_en) 
              begin
                cp_cmd_end_bit_r1  <= cp_cmd_end_bit;
                cp_cmd_end_bit     <= cp_cs[`TXCMD_ENDBIT];
                response_valid     <= response_valid_w;
              end

           if (cclk_in_en && response_valid_w)
              begin
                c2b_response_addr  <= response_addr_reg;
                c2b_response_data  <= shift_reg_d;
              end

           if (cclk_in_en && cp_cs[`CP_IDLE])
             rx_resp_crc_err    <= 1'b0;
           else if (cclk_in_en && cp_cs[`RXRESP_CRC7])
             rx_resp_crc_err    <= ((cp_ccmd_in ^ serial_crc) || rx_resp_crc_err);

           // response txbit err
           if (cclk_in_en && cp_cs[`RXRESP_TXBIT])
             resp_txbit_err     <= cp_ccmd_in; // check tx bit error
           else if (cclk_in_en && cp_cs[`CPWAIT_NCC])
             resp_txbit_err     <= 1'b0; // clear error
        end
    end

  //Required for suspend command during card write
  assign cp_cmd_crc7_end = (count_r == 8'h2) && cp_cs[`TXCMD_CRC7];

  // Command Completion Signal to the data path to indiacte data_trans_done
  assign cmd_compl_signal = cp_cs[`CPWAIT_CCS] && ~cp_ccmd_in;

  // command transmit combination logic
  assign start_bit_n   = ~(cp_cs[`TXCMD_STBIT] || (cp_cs[`TXCMD_TXBIT] &&
                          cmd_irq_resp));

  // when irq response is send out tx_bit should be = 0
  assign tx_bit        = cp_cs[`TXCMD_TXBIT] && !cmd_irq_resp ;
  assign serial_data   = (start_bit_n && shift_reg[37]) || tx_bit ||
                         cp_cs[`TXCMD_ENDBIT];

  assign cmd_out       = (((cp_cs[`TXCMD_CRC7]) ? serial_crc :
                           serial_data) ||
                          cp_cs[`CP_IDLE] || cp_cs[`TXCMD_ISEQ] ||
                          cp_cs[`CPWAIT_NCC] || cp_cs[`CPWAIT_CRT] ||
                          cp_cs[`RXRESP_IRQRESP] || cp_cs[`RXRESP_STBIT] ||
                          cp_cs[`RXRESP_TXBIT] || cp_cs[`RXRESP_CMDIDX] ||
                          cp_cs[`RXRESP_DATA] || cp_cs[`RXRESP_CRC7] ||
                          cp_cs[`RXRESP_ENDBIT] || cp_cs[`CPWAIT_CCS]);


  // open drain output driver according to
  assign cp_ccmd_out_en = (cmd_irq_resp || ~sync_od_pullup_en_n) ? ~cmd_out :
                          (cp_cs[`TXCMD_ISEQ] || cp_cs[`TXCMD_STBIT] ||
                           cp_cs[`TXCMD_TXBIT] || cp_cs[`TXCMD_PAR] ||
                           cp_cs[`TXCMD_CRC7] || cp_cs[`TXCMD_ENDBIT] ||
                           (cp_cs[`CPWAIT_NCC] & !voltage_switch)  || cp_cs[`CP_IDLE] || 
                        cp_cs[`CPSEND_CCSD] || cp_cs[`CP_BOOT] );

  assign cp_ccmd_out    = (cmd_irq_resp || ~sync_od_pullup_en_n) ? 1'b0 :
                           cmd_out;

  assign cp_cmd_idle    = cp_cs[`CP_IDLE];
  assign cp_cmd_idle_lp = cp_cs[`CP_IDLE] && cp_ns[`CP_IDLE];

  // To syncronize with response end bit
  assign resp_crc_err   = rx_resp_crc_err && cp_cs[`RXRESP_ENDBIT] &&
                          check_response_crc;

  assign response_valid_w = (cp_cs[`RXRESP_DATA]   && (count_r[4:0] == 5'h0) ||
                            (cp_cs[`RXRESP_ENDBIT] && response_length));
  assign response_addr    = (auto_stop_cmd) ? 2'b01 : count_r[6:5];

  assign response_err     = cp_cs[`RXRESP_ENDBIT] &&
                            (resp_txbit_err     || ~cp_ccmd_in ||
                             ((shift_reg[37:32]  != cmd_idx) &&
                              (check_response_crc && !response_length)));

  // response timeout occured
  assign resp_timeout     = bar_intr | (cp_cs[`RXRESP_STBIT] && counter_zero && cp_ccmd_in);
  //Give response done(command done) at the end of CP_WAIT.
 //SD_3.0 start
 assign response_done    = !auto_stop_cmd && (((cp_cs[`CP_VOLT_SWITCH_2] && volt_switch_int) ||
                           (cp_cs[`CP_VOLT_SWITCH_2] && switch_flag && (clk_enable[cp_card_num]== 1'b0 && clk_enable_r[cp_card_num]== 1'b1)) ||
                           (cp_cs[`CPWAIT_NCC] && counter_zero && dis_boot) ||
                           (!ccs_expected && cp_cs[`CPWAIT_NCC] && counter_zero && !dis_boot) ||
                            (ccs_expected && cp_cs[`CPWAIT_CCS] && !tnrc_elapsed) || ccsd_done));
 assign voltage_switch_error_2 =  cp_cs[`CP_VOLT_SWITCH_2] && switch_flag && (clk_enable[cp_card_num]== 1'b0 && clk_enable_r[cp_card_num]== 1'b1);            
 //SD_3.0 ends
 // assign dis_boot         = b2c_cmd_register[26] | (rx_byte_count_remzero & rx_end_bit) | (b2c_cmd_register[26] & cp_ns[`TXCMD_ENDBIT]);       
  assign dis_boot         = b2c_cmd_control[26] | (rx_byte_count_rem_zero & rx_end_bit) | (b2c_cmd_control[26] & cp_cs[`TXCMD_ENDBIT]);       
  // response_done should be de-asserted after the response indication for CMD. While the FSM is 
  // in CPWAIT_CCS it may require to assert the response_done twice (one for the normal response 
  // and the other for CCSD indication (CCS& send_ccsd happening on the same clock cycle))  

  assign auto_cmd_done    = auto_stop_cmd && cp_cs[`CPWAIT_NCC];
  assign cp_resp_end_bit  = cp_cs[`RXRESP_ENDBIT];


  assign din              = (cp_cs[`TXCMD_STBIT] || cp_cs[`TXCMD_TXBIT] ||
                             cp_cs[`TXCMD_PAR]) ? cmd_out : cp_ccmd_in;

  assign counter_zero     = (count_r == 8'h0);
  
  assign ccsd_done        = (cp_cs[`CPSEND_CCSD] && counter_zero) || 
                            (send_ccsd && cp_cs[`CPWAIT_CCS] && ~cp_ccmd_in);

  assign clr_send_ccsd    = ccsd_done; 

  // Local command path counter
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        count_r <= {8{1'h1}};
      else begin
        if (cclk_in_en && load_counter)
          count_r <= new_count;
        else if (cclk_in_en)
          count_r <= count_r - 1;
      end
    end

  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        cmd_fsm_state <= 4'h0;
      else
        cmd_fsm_state <= cmd_fsm_state_w[3:0];
    end

//SD_3.0 start
  always @ (posedge cclk_in or negedge creset_n)
     begin
      if (~creset_n)
         begin
           switch_flag <= 1'b0;
           voltage_switch_error_2_r <= 1'b0;
         end 
      else 
         begin
           switch_flag <= switch_flag_en;
           if(voltage_switch_error_2)
               voltage_switch_error_2_r <= 1'b1;
           else if (cp_cs[`CP_IDLE])
               voltage_switch_error_2_r <= 1'b0;  
         end 
     end

//SD_3.0 ends
  

  always @ (cp_cs)
    begin
      cmd_fsm_state_w = 5'h0;
      case (1'b1)
        cp_cs[`CP_IDLE]       : cmd_fsm_state_w = 5'b00000;
        cp_cs[`TXCMD_ISEQ]    : cmd_fsm_state_w = 5'b00001;
        cp_cs[`TXCMD_STBIT]   : cmd_fsm_state_w = 5'b00010;
        cp_cs[`TXCMD_TXBIT]   : cmd_fsm_state_w = 5'b00011;
        cp_cs[`TXCMD_PAR]     : cmd_fsm_state_w = 5'b00100;
        cp_cs[`TXCMD_CRC7]    : cmd_fsm_state_w = 5'b00101;
        cp_cs[`TXCMD_ENDBIT]  : cmd_fsm_state_w = 5'b00110;
        cp_cs[`RXRESP_STBIT]  : cmd_fsm_state_w = 5'b00111;
        cp_cs[`RXRESP_IRQRESP]: cmd_fsm_state_w = 5'b01000;
        cp_cs[`RXRESP_TXBIT]  : cmd_fsm_state_w = 5'b01001;
        cp_cs[`RXRESP_CMDIDX] : cmd_fsm_state_w = 5'b01010;
        cp_cs[`RXRESP_DATA]   : cmd_fsm_state_w = 5'b01011;
        cp_cs[`RXRESP_CRC7]   : cmd_fsm_state_w = 5'b01100;
        cp_cs[`RXRESP_ENDBIT] : cmd_fsm_state_w = 5'b01101;
        cp_cs[`CPWAIT_NCC]    : cmd_fsm_state_w = 5'b01110;
        cp_cs[`CPWAIT_CRT]    : cmd_fsm_state_w = 5'b01111;
        cp_cs[`CPWAIT_CCS]    : cmd_fsm_state_w = 5'b10000;
        cp_cs[`CPSEND_CCSD]   : cmd_fsm_state_w = 5'b10001;
      endcase
    end

  //CRC7 calculation start
  assign start_crc         = cp_cs[`RXRESP_TXBIT] || cp_cs[`TXCMD_STBIT];
  assign send_serial_crc   = cp_cs[`RXRESP_CRC7] || cp_cs[`TXCMD_CRC7];

  // crc7 generation module
  DWC_mobile_storage_crc7
    U_DWC_mobile_storage_crc7
    (
     // Outputs
     .serial_crc      (serial_crc),
     // Inputs
     .cclk_in         (cclk_in),
     .cclk_in_en      (cclk_in_en),
     .creset_n        (creset_n),
     .start_crc       (start_crc),
     .send_serial_crc (send_serial_crc),
     .din             (din));

endmodule // DWC_mobile_storage_cmdpath
