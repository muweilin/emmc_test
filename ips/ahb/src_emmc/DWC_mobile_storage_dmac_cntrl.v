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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_dmac_cntrl.v#41 $
//--                                                                        
//--------------------------------------------------------------------------
//-- MODULE: DWC_mobile_storage_dmac_csr
//--
//-- DESCRIPTION: This is the CSR for the Internal DMAC
//--              This contains the status and control registers for DMAC.
//--
//--              The DMAC CSR consists of a native APB like interface to access
//--              the registers.
//--
//----------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_dmac_cntrl(
  // Outputs
  fsm_state_o, fbe_code_o, fbe_o, desc_unavail_o, /*dir_bit_err_o,*/
  rx_int_o, tx_int_o, curr_desc_addr_o, curr_buf_addr_o, start_xfer_o,
  addr_o, rd_wrn_o, burst_cnt_o, xfer_size_o, wdata_o, eod_o,
  fixed_burst_o, dmac_fifo_push_o, dmac_fifo_pop_o, dmac_fifo_wdata_o,
  dmac_ack_o, fifo_rst_o,card_err_sumry_o, update_status_o,

  // Inputs
  clk, reset_n, dmac_en_i, pbl_i, swr_rst_i, poll_dmnd_i, dsc_list_start_i,
  csr_fixed_burst_i,  dsc_skp_len_i, ahm_wdata_pop_i, ahm_rdata_i, 
  ahm_rdata_push_i, ahm_xfer_done_i, ahm_error_i, dmac_fifo_rdata_i, dmac_req_i, 
  new_cmd_i, data_expected_i, data_w_rn_i, abort_cmd_i, fifo_rst_i, end_bit_err_i,
  resp_tout_i, resp_crc_err_i, st_bit_err_i, data_rd_tout_i, data_crc_err_i, 
  resp_err_i,cmd_done_i,dto_i, bytecnt_i, card_err_sumry_i, fifo_empty_i,
  send_ccsd_i,scan_mode,biu_card_rd_thres_en,
  enable_boot,alternative_boot_mode,end_boot_i,boot_ack_timeout,boot_data_timeout    
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  // Host Clock and Reset
  input                        clk;                // System Clock 
  input                        reset_n;            // System Reset - Active Low

  // Interface to DMAC CSR
  output                [3:0]  fsm_state_o;        // Encoded FSM State
  output                [2:0]  fbe_code_o;         // Fatal Bus Error code
  output                       fbe_o;              // Fatal Bus Error Interrupt 
  output                       desc_unavail_o;     // Descriptor Unavailable intr
//output                       dir_bit_err_o;      // Dir bit error
  output                       rx_int_o;           // Receive interrupt
  output                       tx_int_o;           // Transmit interrupt
  output  [`M_ADDR_WIDTH-1:0]  curr_desc_addr_o;   // Current Descriptor address
  output  [`M_ADDR_WIDTH-1:0]  curr_buf_addr_o;    // Current Buffer Address
  output                       update_status_o;    // Update for status
  output                       card_err_sumry_o;   // Card Error Summary

  input                        dmac_en_i;          // DMAC enable
  input                 [2:0]  pbl_i;              // Programmable Burst Length
  input                        swr_rst_i;          // Software reset
  input                        poll_dmnd_i;        // Poll Demand pulse
  input   [`M_ADDR_WIDTH-1:0]  dsc_list_start_i;   // Descriptor list start addr
  input                        csr_fixed_burst_i;  // Fixed Burst indication 
  input                 [4:0]  dsc_skp_len_i;      // Descriptor skip length
  input                        card_err_sumry_i;   // Error summary from DMAC CSR
         
  // Interface to AHM
  output                       start_xfer_o;       // Start Transfer 
  output   [`M_ADDR_WIDTH-1:0] addr_o;             // Address
  output                       rd_wrn_o;           // 1 - Read, 0 - Write
  output                [7:0]  burst_cnt_o;        // Burst Count
  output                       xfer_size_o;        // Transfer size for 32-bit
  output  [`H_DATA_WIDTH-1:0]  wdata_o;            // Write data
  output                       eod_o;              // End of data
  output                       fixed_burst_o;      // Fixed Burst indication

  input                        ahm_wdata_pop_i;    // Pop indication
  input   [`H_DATA_WIDTH-1:0]  ahm_rdata_i;        // Read data
  input                        ahm_rdata_push_i;   // Push indication
  input                        ahm_xfer_done_i;    // Transfer Done
  input                        ahm_error_i;        // Error

  // Interface to 2clk_fifoctl
  input    [`F_DATA_WIDTH-1:0] dmac_fifo_rdata_i;  // FIFO Read Data in

  // Interface to DMAC Interface 
  output                       dmac_fifo_push_o;   // Push indication to FIFO
  output                       dmac_fifo_pop_o;    // Pop indication to FIFO
  output   [`F_DATA_WIDTH-1:0] dmac_fifo_wdata_o;  // FIFO Write Data Out 

  // Interface to BIU
  output                       dmac_ack_o;         // Acknowledgement to dmac_req_i
  output                       fifo_rst_o;         // FIFO reset

  input                        dmac_req_i;         // DMA Request
  input                        new_cmd_i;          // New command 
  input                        data_expected_i;    // Data command
  input                        data_w_rn_i;        // 1 - Write, 0 - Read
  input                        abort_cmd_i;        // Abort command
  input                        fifo_rst_i;         // FIFO reset completion
  input                        end_bit_err_i;      // End bit error
  input                        resp_tout_i;        // Response Time out
  input                        resp_crc_err_i;     // Response CRC error
  input                        st_bit_err_i;       // Start bit error
  input                        data_rd_tout_i;     // Data Read timeout
  input                        data_crc_err_i;     // Data CRC error
  input                        resp_err_i;         // Response error
  input                        cmd_done_i;         // Command done
  input                        dto_i;              // Data transfer over
  input                 [31:0] bytecnt_i;          // Byte count information
  input                        fifo_empty_i;       // FIFO empty condition
  input                        send_ccsd_i;        // Send CCSD

  input                        scan_mode;          // Scan Mode
  input                        enable_boot;        //Enable boot indication
  input                        alternative_boot_mode;
  input                        end_boot_i;         // Synchronized pulse signal from cmdpath block
  input                        boot_ack_timeout;   // Synchronized pulse signal from datarx block
  input                        boot_data_timeout;  // Synchronized pulse signal from datarx block
  input                        biu_card_rd_thres_en;

  // DMAC states defines
  `define      DMAC_IDLE             0    // Idle
  `define      DMA_STOP              1    // Poll Demand wait
  `define      DESC_RD               2    // Descriptor Read
  `define      DESC_CHK              3    // Descriptor check
  `define      DMA_RD_REQ_WAIT       4    // Wait for read request
  `define      DMA_WR_REQ_WAIT       5    // Wait for write request
  `define      DMA_RD                6    // Write to host mem
  `define      DMA_WR                7    // Read from host mem
  `define      DESC_CLOSE            8    // Close Descriptor

  // Parameters
  parameter    AHB_FBE_WR  = 3'b001;
  parameter    AHB_FBE_RD  = 3'b010;
  parameter    AHB_FBE_RSV = 3'b111;


  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Flip-Flops
  `ifdef H_DATA_WIDTH_16
  reg                      push_16bit_r;          // Push Flag
  reg                      pop_16bit_r;           // Pop Flag
  reg               [15:0] fifo_tmp_data_r;       // Temporary FIFO data
  `else 
  wire                     push_16bit_r;
  wire                     pop_16bit_r;
  wire              [15:0] fifo_tmp_data_r;
  `endif
  reg                      new_cmd_r;             // New command Flag
  reg               [8:0] dmac_cs;               // Current FSM state
  reg                      scnd_buf_r;            // Dual buffer Flag
  reg  [`M_ADDR_WIDTH-1:0] dsc_addr_r;            // Desc addr Reg
  reg  [`M_ADDR_WIDTH-1:0] dsc_close_addr_r;      // Closing Desc addr Reg
  reg  [`M_ADDR_WIDTH-1:0] buf_addr_r;            // Buffer addr Reg
  reg                [7:0] beat_cnt_r;            // Beat count Reg
  reg               [12:0] xfer_cnt_r;            // Transfer count Reg
  reg                      start_xfer_r;          // Start Transfer Reg
  reg               [31:0] desc0_r;               // Desc0 Reg
  reg               [31:0] desc1_r;               // Desc1 Reg
  reg  [`M_ADDR_WIDTH-1:0] desc2_r;               // Desc2 Reg
  reg  [`M_ADDR_WIDTH-1:0] desc3_r;               // Desc3 Reg
  reg  [`M_ADDR_WIDTH-1:0] curr_desc_addr_r;      // Current address register
  reg                      data_w_rn_r;           // Data Read/Write Reg
  reg                      dto_r;                 // DTO registered
  reg                      ahm_error_r;           // AHM error registered
  reg                      fbe_code_wr;           // FBE error occured when write
  reg                      fbe_code_rd;           // FBE error occured when read
  reg                      cmd_done_r;            // Command Done registered
  reg                      extra_push_pop_r;      // Extra push/pop for 16bit 
                                                  // h_datawidth
  reg                      send_ccsd_r;           // send_ccsd registered

  //Reg Nets
  reg                [7:0] burst_cnt;             // Burst count
  reg               [12:0] rmng_xfer_cnt;         // Remaining Transfer count
  reg               [8:0] dmac_ns;               // Next State
  reg                      start_xfer;            // Start transfer
  reg                      ld_desc_addr_start;    // Load start desc addr
  reg                      ld_dsc_rd_bt_cnt;      // Load desc beat count 
  reg                      fbe;                   // Fatal bus error pulse
  reg                [2:0] fbe_code;              // Fatal bus err code
  reg                      update_status;         // update status pulse
  reg                      fbe_update_status;     // FBE update status pulse
  reg                      clr;                   // Clear signal for ahm_error_r
  reg                      fifo_rst;              // FIFO reset
  reg                      desc_unavail;          // Improper own bit
//reg                      dir_bit_err;           // Direction bit err
  reg                      ld_buf1_cnt;           // Load buffer1 count
  reg                      ld_buf2_cnt;           // Load buffer2 count
  reg                      ld_buf1_addr;          // Load buffer1 addr
  reg                      ld_buf2_addr;          // Load buffer2 addr
  reg                      dmac_ack;              // Dma Ack
  reg                      tgl_scnd_buf;          // Second buffer flag
  reg                      tx_int;                // Tx interrupt
  reg                      rx_int;                // Rx interrupt
  reg                      ld_desc_addr_skip;     // Load skip addr
  reg                      ld_desc_addr_next;     // Load next addr
  reg                [3:0] fsm_state;             // Encoded FSM state
  reg                [7:0] pbl;                   // Programmable Burst length
  reg                      xfer_cnt_over;         // Transfer count over

  //Wires
  wire               [3:0] desc_beat_cnt;         // Desc Beat Count
  wire                     new_cmd;               // New Command pulse
  wire [`M_ADDR_WIDTH-1:0] addr;                  // Address to AHM
  wire                     rd_wrn;                // Read/Write to AHM
  wire [`H_DATA_WIDTH-1:0] wdata;                 // Write data to AHM
  wire                     dmac_fifo_push;        // FIFO push indication
  wire [`F_DATA_WIDTH-1:0] dmac_fifo_wdata;       // Write data to FIFO
  wire                     dmac_fifo_pop;         // FIFO pop indication
  wire [`F_DATA_WIDTH-1:0] dmac_fifo_rdata;       // Read data to FIFO
  //wire              [31:0] dsc_skp_len_int;       // Intermediate skip length
  wire                     own_bit;
  wire                     end_of_ring;
  wire                     scnd_addr_chnd;
  wire                     first_desc;
  wire                     last_desc;
  wire                     intr_on_compl;
//wire                     dir_bit;
  wire              [12:0] buf1_size;
  wire              [12:0] buf2_size;
  wire [`M_ADDR_WIDTH-1:0] buf1_addr_ptr;
  wire [`M_ADDR_WIDTH-1:0] buf2_addr_ptr;
  wire [`M_ADDR_WIDTH-1:0] next_desc_ptr;
  wire                     dsc_err;
  wire                     extra_push_pop_cond;

  `ifdef H_DATA_WIDTH_16
  wire              [15:0] wdata_close;
  `endif

  `ifdef H_DATA_WIDTH_32
  wire              [31:0] wdata_close;
  `endif

  `ifdef H_DATA_WIDTH_64
  wire              [63:0] wdata_close;
  `endif
  wire                     boot_mode;


  //Outputs 

  assign fsm_state_o       = fsm_state;
  assign fbe_code_o        = fbe_code;
  assign fbe_o             = fbe;
  assign desc_unavail_o    = desc_unavail;
//assign dir_bit_err_o     = dir_bit_err;
  assign rx_int_o          = rx_int;
  assign tx_int_o          = tx_int;
  assign curr_desc_addr_o  = curr_desc_addr_r;
  assign curr_buf_addr_o   = buf_addr_r;
  assign start_xfer_o      = start_xfer_r;
  assign addr_o            = addr;
  assign rd_wrn_o          = rd_wrn;
  assign burst_cnt_o       = burst_cnt;
  assign xfer_size_o       = 1'b0;
  assign wdata_o           = wdata;
  assign eod_o             = 1'b0;
  assign fixed_burst_o     = csr_fixed_burst_i;
  assign dmac_fifo_push_o  = dmac_fifo_push & data_w_rn_r;
  assign dmac_fifo_pop_o   = dmac_fifo_pop & ~data_w_rn_r;
  assign dmac_fifo_wdata_o = dmac_fifo_wdata;
  assign dmac_ack_o        = dmac_ack;
  assign fifo_rst_o        = fifo_rst;
  assign card_err_sumry_o  = end_bit_err_i  | (resp_tout_i & !boot_mode) |
                             resp_crc_err_i | (st_bit_err_i & !data_w_rn_r)    |
                             (data_rd_tout_i  & !boot_mode)| data_crc_err_i |
                             resp_err_i;
  assign update_status_o   = update_status | fbe_update_status;
  assign boot_mode         = enable_boot | alternative_boot_mode;
  //----------------------------------------------------------------------
  // Descriptor fields
  //----------------------------------------------------------------------
  
  //DES0
  assign own_bit        = desc0_r[31];
  assign end_of_ring    = desc0_r[5];
  assign scnd_addr_chnd = desc0_r[4]; // Second address is chained
  assign first_desc     = desc0_r[3];
  assign last_desc      = desc0_r[2];
  assign intr_on_compl  = desc0_r[1]; // Interrupt on completion
//assign dir_bit        = desc0_r[0];

  //DES1
  assign buf2_size      = desc1_r[25:13];
  assign buf1_size      = desc1_r[12:0];

  //DES2
  assign buf1_addr_ptr  = desc2_r;

  //DES3
  assign buf2_addr_ptr  = desc3_r;
  assign next_desc_ptr  = desc3_r;


  //----------------------------------------------------------------------
  // Signals to AHM
  //----------------------------------------------------------------------

  assign addr = (dmac_cs[`DESC_RD])?dsc_addr_r:
                (dmac_cs[`DESC_CLOSE])?dsc_close_addr_r:buf_addr_r;

  assign rd_wrn = dmac_cs[`DESC_RD] | dmac_cs[`DMA_RD];


  always @(dmac_cs or desc_beat_cnt or rmng_xfer_cnt or
           pbl or abort_cmd_i or send_ccsd_r or end_boot_i or biu_card_rd_thres_en)
    begin
      if (dmac_cs[`DESC_RD])
        burst_cnt = {4'h0,desc_beat_cnt};
      else if (dmac_cs[`DESC_CLOSE])
        burst_cnt = 8'h0;
      else if (((end_boot_i | abort_cmd_i)) | send_ccsd_r)
        burst_cnt = 8'h0;
      else if (rmng_xfer_cnt > pbl)
        burst_cnt = pbl;
      else
        burst_cnt = 8'h0;
    end

  assign wdata = (dmac_cs[`DESC_CLOSE])?wdata_close:dmac_fifo_rdata;

  `ifdef H_DATA_WIDTH_16
  assign wdata_close = {1'b0,(card_err_sumry_i | card_err_sumry_o),desc0_r[29:16]};
  `endif

  `ifdef H_DATA_WIDTH_32
  assign wdata_close = {1'b0,(card_err_sumry_i | card_err_sumry_o),desc0_r[29:0]};
  `endif

  `ifdef H_DATA_WIDTH_64
  assign wdata_close = {desc1_r[31:0],1'b0,(card_err_sumry_i | card_err_sumry_o),
                        desc0_r[29:0]};
  `endif

  //----------------------------------------------------------------------
  // Signals to/from FIFO Controller
  //----------------------------------------------------------------------

  // For a 16-bit H_DATA_WIDTH, the 2 bytes need to be stored before 
  // pushing to the FIFO since the FIFO will be 32 bits wide in this 
  // configuration
  
  `ifdef H_DATA_WIDTH_16
  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        push_16bit_r <= 1'b0;
      else begin
        if (dmac_cs[`DESC_CHK] & first_desc)
          push_16bit_r <= 1'b0;
        else if (dmac_cs[`DMA_RD] & ahm_rdata_push_i)
          push_16bit_r <= ~push_16bit_r;
      end
    end

  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        fifo_tmp_data_r <= 16'h0;
      else begin
        if (ahm_rdata_push_i & ~push_16bit_r)
          fifo_tmp_data_r <= ahm_rdata_i;
      end
    end

  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        pop_16bit_r <= 1'b0;
      else begin
        if (dmac_cs[`DESC_CHK] & first_desc)
          pop_16bit_r <= 1'b0;
        else if (dmac_cs[`DMA_WR] & ahm_wdata_pop_i)
          pop_16bit_r <= ~pop_16bit_r;
      end
    end
  `else
    assign push_16bit_r = 1'b0;
    assign pop_16bit_r  = 1'b0;
    assign fifo_tmp_data_r = 16'h0;
  `endif

  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        extra_push_pop_r <= 1'b0;
      else begin
        if (new_cmd & dmac_cs[`DMAC_IDLE]) begin
          if (bytecnt_i[1:0] == 2'b01 || bytecnt_i[1:0] == 2'b10)
            extra_push_pop_r <= 1'b1;
          else 
            extra_push_pop_r <= 1'b0;
        end
      end
    end


  assign extra_push_pop_cond = (xfer_cnt_over & ahm_xfer_done_i & 
                                 last_desc & extra_push_pop_r) & 
                               ((scnd_addr_chnd) | 
                                ((~scnd_addr_chnd & scnd_buf_r) |
                                 ( ~scnd_addr_chnd & ~scnd_buf_r & ~(|buf2_size))) |
                               (bytecnt_i <= 32'h0000_0002));

  assign dmac_fifo_push = (`H_DATA_WIDTH == 16)? dmac_cs[`DMA_RD] & 
                                                 ((push_16bit_r & 
                                                   ahm_rdata_push_i & 
                                                   ~xfer_cnt_over) | 
                                                  extra_push_pop_cond):
                                                (dmac_cs[`DMA_RD] & ahm_rdata_push_i);

  assign dmac_fifo_wdata = (`H_DATA_WIDTH == 16)?({ahm_rdata_i,fifo_tmp_data_r}):
                                                 (ahm_rdata_i);

  assign dmac_fifo_pop = (`H_DATA_WIDTH == 16)? dmac_cs[`DMA_WR] & 
                                                 ((pop_16bit_r & 
                                                   ahm_wdata_pop_i & 
                                                   ~xfer_cnt_over) | 
                                                  extra_push_pop_cond):
                                                (dmac_cs[`DMA_WR] & ahm_wdata_pop_i);

  `ifdef H_DATA_WIDTH_16
  assign dmac_fifo_rdata = (pop_16bit_r)? {{(`F_DATA_WIDTH-16){1'b0}},( dmac_fifo_rdata_i[31:16])}:
                                       {{(`F_DATA_WIDTH-16){1'b0}}, (dmac_fifo_rdata_i[15:0])};
  `else
  assign dmac_fifo_rdata = dmac_fifo_rdata_i;
  `endif

  //----------------------------------------------------------------------
  // desc_beat_cnt signal generation
  //----------------------------------------------------------------------

  // desc_beat_cnt = ((16 * 8)/`H_DATA_WIDTH) - 1;

`ifdef M_ADDR_WIDTH_32
  assign desc_beat_cnt = (`H_DATA_WIDTH == 16)? 4'h7:
                         (`H_DATA_WIDTH == 32)? 4'h3:
                                                4'h1;
`else
  assign desc_beat_cnt = (`H_DATA_WIDTH == 16)? 4'hF:
                         (`H_DATA_WIDTH == 32)? 4'h7:
                                                4'h3;
`endif

  //----------------------------------------------------------------------
  // Remaining transfer count (rmng_xfer_cnt) signal generation
  // rmng_xfer_cnt value is adjusted for H_DATA_WIDTH
  //----------------------------------------------------------------------
  always @(xfer_cnt_r)
    begin
      case (`H_DATA_WIDTH)
        16      : rmng_xfer_cnt = ({1'h0,xfer_cnt_r[12:1]}+{12'h0,xfer_cnt_r[0]});
        32      : rmng_xfer_cnt = ({2'h0,xfer_cnt_r[12:2]}+{11'h0,xfer_cnt_r[1:0]});
        default : rmng_xfer_cnt = ({3'h0,xfer_cnt_r[12:3]}+{10'h0,xfer_cnt_r[2:0]});
      endcase
    end

  //----------------------------------------------------------------------
  // new_cmd signal generation
  //----------------------------------------------------------------------

  // new_cmd_i toggles when every new command is loaded.
  // Hence an xor operation is used to generate a new_cmd pulse.

  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        new_cmd_r <= 1'b0;
      else 
        new_cmd_r <= new_cmd_i;
    end

  assign new_cmd = new_cmd_i ^ new_cmd_r;


  //----------------------------------------------------------------------
  // data_w_rn_r signal generation
  //----------------------------------------------------------------------

  // data_w_rn_r signal holds the read/write condition

  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        data_w_rn_r <= 1'b0;
      else begin
        if (new_cmd & data_expected_i)
          data_w_rn_r <= data_w_rn_i;
      end
    end

  //----------------------------------------------------------------------
  // dto_r signal generation
  //----------------------------------------------------------------------

  // dto_r signal indicates that a dto has occured
  // This signal is used during abort conditions.

  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        dto_r <= 1'b0;
      else begin
        if (new_cmd & data_expected_i)
          dto_r <= 1'b0;
        else if (dto_i)
          dto_r <= 1'b1;
      end
    end

  //----------------------------------------------------------------------
  // ahm_error_r signal capture
  //----------------------------------------------------------------------

  // This flag will ensure that the application is notified of FBE
  // only after the card has sent its response or a response timeout
  // occurs

  always @(posedge clk or negedge reset_n)
    begin
      if(~reset_n) begin
        ahm_error_r <= 1'b0;
        fbe_code_rd <= 1'b0;
        fbe_code_wr <= 1'b0;
      end
      else 
        begin
          if (clr) begin
            ahm_error_r <= 1'b0;
            fbe_code_rd <= 1'b0;
            fbe_code_wr <= 1'b0;
          end
          else if (ahm_error_i) begin
            ahm_error_r <= 1'b1;

            if (dmac_cs[`DESC_RD] || dmac_cs[`DMA_RD])
              fbe_code_wr <= 1'b1;
            else if (dmac_cs[`DMA_WR] || dmac_cs[`DESC_CLOSE])
              fbe_code_rd <= 1'b1;
          end
        end
    end

  always @(posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        cmd_done_r <= 1'b0;
      else 
        begin
          if (new_cmd & data_expected_i)
            cmd_done_r <= 1'b0;
          else if (cmd_done_i)
            cmd_done_r <= 1'b1;
        end
    end

  //----------------------------------------------------------------------
  // send_ccsd_r generation
  //----------------------------------------------------------------------
  always @(posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        send_ccsd_r <= 1'b0;
      else 
        begin
          if (new_cmd & data_expected_i)
            send_ccsd_r <= 1'b0;
          else if (send_ccsd_i)
            send_ccsd_r <= 1'b1;
        end
    end

  //----------------------------------------------------------------------
  // fbe,fbe_code generation
  //----------------------------------------------------------------------
  always @(ahm_error_r or cmd_done_r or 
           fbe_code_wr or fbe_code_rd)
    begin
      if (ahm_error_r & cmd_done_r) begin
        fbe = 1'b1;
        fbe_update_status = 1'b1;
        fbe_code = AHB_FBE_RSV;
        clr = 1;

        if (fbe_code_rd)
          fbe_code = AHB_FBE_RD;
        else if (fbe_code_wr)
          fbe_code = AHB_FBE_WR;
      end
      else begin
        fbe                = 1'b0;
        fbe_update_status  = 1'b0;
        fbe_code           = AHB_FBE_RSV;
        clr                = 0;
      end

    end

  //----------------------------------------------------------------------
  // Command Path state machine
  //----------------------------------------------------------------------

  // Command Path Sequential Logic
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        dmac_cs <= 9'h1;
      else begin
        if (swr_rst_i | ahm_error_i)
          dmac_cs <= {8'h0,1'b1};
        else
          dmac_cs <= dmac_ns;
      end
    end

  // Command Path Combinational Logic
  always @ (new_cmd or data_expected_i or dmac_en_i or
            poll_dmnd_i or beat_cnt_r or
            ahm_xfer_done_i or first_desc or own_bit or
            /*dir_bit or */ data_w_rn_r or fifo_rst_i or 
            cmd_done_r or resp_tout_i or resp_crc_err_i or
            dmac_req_i or data_rd_tout_i or abort_cmd_i or
            xfer_cnt_over or scnd_addr_chnd or dto_r or
            scnd_buf_r or intr_on_compl or last_desc or 
            ahm_wdata_pop_i or dmac_cs or buf2_size or
            send_ccsd_r or fifo_empty_i or card_err_sumry_i
      or end_boot_i or boot_mode)
    begin : FSM_DMAC_NS

      //The default values for control signals
      dmac_ns            = {9{1'b0}};
      start_xfer         = 1'b0;
      ld_desc_addr_start = 1'b0;
      ld_dsc_rd_bt_cnt   = 1'b0;
      update_status      = 1'b0;
      fifo_rst           = 1'b0;
      desc_unavail       = 1'b0;
//    dir_bit_err        = 1'b0;
      ld_buf1_cnt        = 1'b0;
      ld_buf2_cnt        = 1'b0;
      ld_buf1_addr       = 1'b0;
      ld_buf2_addr       = 1'b0;
      dmac_ack           = 1'b0;
      tgl_scnd_buf       = 1'b0;
      tx_int             = 1'b0;
      rx_int             = 1'b0;
      ld_desc_addr_skip  = 1'b0;
      ld_desc_addr_next  = 1'b0;

      case (1'b1)

        dmac_cs[`DMAC_IDLE] : begin // idle
          if (new_cmd & data_expected_i & dmac_en_i) begin
            start_xfer         = 1'b1;
            ld_desc_addr_start = 1'b1;
            ld_dsc_rd_bt_cnt   = 1'b1;
            fifo_rst           = 1'b1;
            dmac_ns[`DESC_RD]  = 1'b1;
          end
          else
            dmac_ns[`DMAC_IDLE] = 1'b1;
        end

        dmac_cs[`DMA_STOP] : begin // Descriptor process Stop
          if (poll_dmnd_i) begin
            start_xfer         = 1'b1;
            ld_dsc_rd_bt_cnt   = 1'b1;
            dmac_ns[`DESC_RD]  = 1'b1;
          end
          else
            dmac_ns[`DMA_STOP]     = 1'b1;
        end

        dmac_cs[`DESC_RD] : begin // Descriptor Read
          if (ahm_xfer_done_i) begin
            dmac_ns[`DESC_CHK] = 1'b1;
          end
          else
            dmac_ns[`DESC_RD]  = 1'b1;
        end

        dmac_cs[`DESC_CHK] : begin // Descriptor check
          if (~own_bit) begin 
            update_status               = 1'b1;
            desc_unavail                = 1'b1;
            dmac_ns[`DMA_STOP]              = 1'b1;
          end
//        else if (dir_bit != data_w_rn_r) begin
//          update_status               = 1'b1;
//          dir_bit_err                 = 1'b1;
//          start_xfer                  = 1'b1;
//          dmac_ns[`DESC_CLOSE]        = 1'b1;
//        end
          else if (~fifo_rst_i) begin
            if (cmd_done_r) begin
              if (((resp_tout_i & !boot_mode) | resp_crc_err_i | 
                  card_err_sumry_i) & data_expected_i) begin
                start_xfer                = 1'b1;
                dmac_ns[`DESC_CLOSE]      = 1'b1;
              end
              else begin
                if (data_w_rn_r)
                  dmac_ns[`DMA_RD_REQ_WAIT] = 1'b1;
                else 
                  dmac_ns[`DMA_WR_REQ_WAIT] = 1'b1;
              end
            end
         // In case of read operation, there is a possibility
         // that the FIFO may become full due to read data
         // from card even before cmd_done_i is completely
         // received and the clock stops. To overcome this 
         // deadlock, the condition below is added.
            else if (~data_w_rn_r & dmac_req_i)
              dmac_ns[`DMA_WR_REQ_WAIT] = 1'b1;
            else 
              dmac_ns[`DESC_CHK]        = 1'b1;
          // Load the new byte cnt value
            ld_buf1_cnt                 = 1'b1;
            ld_buf1_addr                = 1'b1;
          end
          else 
            dmac_ns[`DESC_CHK]          = 1'b1;
        end

        // wait for dw_dma_req for FIFO write
        // For CEATA, the application may set send ccsd
        // and send_auto_stop_bit if it wants to abort
        // the current transfer.
        dmac_cs[`DMA_RD_REQ_WAIT] : begin         
          if ((abort_cmd_i & dto_r) |
              (send_ccsd_r & dto_r))begin
            start_xfer = 1'b1;
            dmac_ns[`DESC_CLOSE]      = 1'b1;
          end
          else if (dmac_req_i) begin
            start_xfer = 1'b1;
            dmac_ns[`DMA_RD]          = 1'b1;
          end
          else 
            dmac_ns[`DMA_RD_REQ_WAIT] = 1'b1;
        end

        // wait for dw_dma_req for FIFO Read
        dmac_cs[`DMA_WR_REQ_WAIT] : begin         

      // For card read abort, dto will be generated only if
      // the FIFO is emptied.
      // or if application sends ccsd and autocmd12 before
      // read data timeout occurs.
          if ((end_boot_i & dto_r) | (abort_cmd_i & dto_r) | 
              (send_ccsd_r & fifo_empty_i & dto_r))begin
            start_xfer  = 1'b1;
            dmac_ns[`DESC_CLOSE]      = 1'b1;
          end
          else if (cmd_done_r & data_expected_i &
              ((resp_tout_i & !boot_mode)| resp_crc_err_i | 
                             (data_rd_tout_i & !boot_mode))) begin
            start_xfer                = 1'b1;
            dmac_ns[`DESC_CLOSE]      = 1'b1;
          end
          else if (dmac_req_i | (send_ccsd_r & ~fifo_empty_i)) begin
            start_xfer = 1'b1;
            dmac_ns[`DMA_WR]          = 1'b1;
          end
          else 
            dmac_ns[`DMA_WR_REQ_WAIT] = 1'b1;
        end


      // Perform a Read on AHB and write to FIFO
        dmac_cs[`DMA_RD] : begin
          if (xfer_cnt_over && beat_cnt_r == 8'h0 &&
                   ahm_xfer_done_i) begin
            dmac_ack                  = 1'b1;
            tgl_scnd_buf              = 1'b1;
            case (scnd_addr_chnd)
            //Dual Buffer
              0: begin
                if (~scnd_buf_r && |buf2_size) begin
                  ld_buf2_addr = 1'b1;
                  ld_buf2_cnt  = 1'b1;
                  dmac_ns[`DMA_RD_REQ_WAIT] = 1'b1;
                end
                else begin
                  start_xfer                = 1'b1;
                  dmac_ns[`DESC_CLOSE]      = 1'b1;
                end
              end
            //Chained
              1: begin
                  start_xfer                = 1'b1;
                  dmac_ns[`DESC_CLOSE]      = 1'b1;
              end
            endcase
          end
          else if (beat_cnt_r == 8'h0 && ahm_xfer_done_i)begin
            dmac_ns[`DMA_RD_REQ_WAIT]       = 1'b1;
            dmac_ack                        = 1'b1;
          end
          else
            dmac_ns[`DMA_RD]                = 1'b1;
        end

      // Perform a Write on AHB and Read to FIFO
        dmac_cs[`DMA_WR] : begin
          if(xfer_cnt_over && beat_cnt_r == 8'h0 &&
                  ahm_xfer_done_i ) begin
            dmac_ack                  = 1'b1;
            tgl_scnd_buf = 1'b1;
            case (scnd_addr_chnd)
            //Dual Buffer
              0: begin
                if (~scnd_buf_r && |buf2_size) begin
                  ld_buf2_addr = 1'b1;
                  ld_buf2_cnt  = 1'b1;
                  dmac_ns[`DMA_WR_REQ_WAIT] = 1'b1;
                end
                else begin
                  start_xfer             = 1'b1;
                  dmac_ns[`DESC_CLOSE]   = 1'b1;
                end
              end
            //Chained
              1: begin
                  start_xfer             = 1'b1;
                  dmac_ns[`DESC_CLOSE] = 1'b1;
              end
            endcase
          end
          else if (beat_cnt_r == 8'h0 && ahm_xfer_done_i) begin
            dmac_ns[`DMA_WR_REQ_WAIT]  = 1'b1;
            dmac_ack                   = 1'b1;
          end
          else
            dmac_ns[`DMA_WR]           = 1'b1;
        end

        dmac_cs[`DESC_CLOSE] : begin
        //ahm_wdata_pop_i indicates the own bit is closed
          if(ahm_wdata_pop_i) begin
            update_status = 1'b1;

      if (data_w_rn_r)
        tx_int = ~intr_on_compl; 
            else
              rx_int = ~intr_on_compl;
          end
          if (((abort_cmd_i | end_boot_i) & ahm_xfer_done_i & fifo_empty_i & dto_r) |
              (send_ccsd_r & fifo_empty_i & dto_r & ahm_xfer_done_i))
       
            dmac_ns[`DMAC_IDLE]     = 1'b1;
          else if (ahm_xfer_done_i) begin
            case(scnd_addr_chnd)
        //Dual Buffer Structure
              1'b0 : begin
                if (~last_desc) begin
                  start_xfer        = 1'b1;
                  ld_desc_addr_skip = 1'b1;
                  ld_dsc_rd_bt_cnt  = 1'b1;
                  dmac_ns[`DESC_RD] = 1'b1;
                end
                else
                  dmac_ns[`DMAC_IDLE] = 1'b1;
              end
        //Chain Structure
              1'b1 : begin
                if (~last_desc) begin
                  start_xfer        = 1'b1;
                ld_desc_addr_next = 1'b1;
                  ld_dsc_rd_bt_cnt  = 1'b1;
                  dmac_ns[`DESC_RD] = 1'b1;
                end
                else
                  dmac_ns[`DMAC_IDLE] = 1'b1;
              end
            endcase
          end
          else
            dmac_ns[`DESC_CLOSE]     = 1'b1;
        end

      endcase
    end

  //----------------------------------------------------------------------
  // Decode logic of the FSM
  //----------------------------------------------------------------------

  //assign fixed_burst = (`H_DATA_WIDTH == 64)? 1'b0: csr_fixed_burst_i;
  

  //----------------------------------------------------------------------
  // Flag to assert whether both the buffers are read in dual_buffer mode
  //----------------------------------------------------------------------
  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        scnd_buf_r <= 1'b0;
      else begin
        if (~dsc_err && first_desc && dmac_cs[`DESC_RD])
          scnd_buf_r <= 1'b0;
        else if (tgl_scnd_buf)
          scnd_buf_r <= ~scnd_buf_r;
      end
    end
  
  //assign dsc_err = dir_bit_err | desc_unavail;
  assign dsc_err = desc_unavail;

  //----------------------------------------------------------------------
  // Descriptor address generation logic
  //----------------------------------------------------------------------
  
  //assign dsc_skp_len_int = dsc_addr_r + 32'h0000_0010; //Fixed value of 16 bytes

  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        dsc_addr_r <= {{`M_ADDR_WIDTH{1'b0}}};
      else begin
        if (swr_rst_i)
          dsc_addr_r <= {{`M_ADDR_WIDTH{1'b0}}};
        else if (ld_desc_addr_start | 
                 (ld_desc_addr_skip & end_of_ring & ~scnd_addr_chnd))
          dsc_addr_r <= dsc_list_start_i;
        //For a chained descriptor structure
        else if (ld_desc_addr_next)
          dsc_addr_r <= desc3_r;
        //For a dual-buffer structure
        else if (ld_desc_addr_skip) begin
          if (`H_DATA_WIDTH == 16)
            dsc_addr_r <= dsc_addr_r + {{(`M_ADDR_WIDTH-6){1'b0}},dsc_skp_len_i,1'b0};
          else if (`H_DATA_WIDTH == 32)
            dsc_addr_r <= dsc_addr_r + {{(`M_ADDR_WIDTH-7){1'b0}},dsc_skp_len_i,2'b00};
          else 
            dsc_addr_r <= dsc_addr_r + {{(`M_ADDR_WIDTH-8){1'b0}},dsc_skp_len_i,3'b000};
        end
        else if (dmac_cs[`DESC_RD] && ahm_rdata_push_i) begin
          if (`H_DATA_WIDTH == 16) 
            dsc_addr_r <= dsc_addr_r + 32'h2;
          else if (`H_DATA_WIDTH == 32) 
            dsc_addr_r <= dsc_addr_r + 32'h4;
          else if (`H_DATA_WIDTH == 64) 
            dsc_addr_r <= dsc_addr_r + 32'h8;
        end
        else if (poll_dmnd_i)
            dsc_addr_r <= curr_desc_addr_r;
      end
    end

  //----------------------------------------------------------------------
  // Current Descriptor address storage
  //----------------------------------------------------------------------
  
  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        curr_desc_addr_r <= {{`M_ADDR_WIDTH{1'b0}}};
      else begin
        if (swr_rst_i)
          curr_desc_addr_r <= {{`M_ADDR_WIDTH{1'b0}}};
        else if (ld_desc_addr_start | 
                 (ld_desc_addr_skip & end_of_ring & ~scnd_addr_chnd))
          curr_desc_addr_r <= dsc_list_start_i;
        //For a chained descriptor structure
        else if (ld_desc_addr_next)
          curr_desc_addr_r <= desc3_r;
        else if (ld_desc_addr_skip) begin
          if (`H_DATA_WIDTH == 16)
             `ifdef M_ADDR_WIDTH_32
            curr_desc_addr_r <= curr_desc_addr_r + {{(`M_ADDR_WIDTH-6){1'b0}},dsc_skp_len_i,1'b0}
                                                 + 32'h00000010;
             `else
            curr_desc_addr_r <= curr_desc_addr_r + {{(`M_ADDR_WIDTH-6){1'b0}},dsc_skp_len_i,1'b0}
                                                 + 32'h00000020;
             `endif

          else if (`H_DATA_WIDTH == 32)
            `ifdef M_ADDR_WIDTH_32
               curr_desc_addr_r <= curr_desc_addr_r + {{(`M_ADDR_WIDTH-7){1'b0}},dsc_skp_len_i,2'b00} 
                                                 + 32'h00000010;
            `else
               curr_desc_addr_r <= curr_desc_addr_r + {{(`M_ADDR_WIDTH-7){1'b0}},dsc_skp_len_i,2'b00} 
                                                 + 32'h00000020;
            `endif
          else 
            `ifdef M_ADDR_WIDTH_32
               curr_desc_addr_r <= curr_desc_addr_r + {{(`M_ADDR_WIDTH-8){1'b0}},dsc_skp_len_i,3'b000} 
                                                 + 32'h00000010;
            `else
               curr_desc_addr_r <= curr_desc_addr_r + {{(`M_ADDR_WIDTH-8){1'b0}},dsc_skp_len_i,3'b000} 
                                                 + 32'h00000020;
            `endif
        end

      end
    end


 // Register which maintains the desc addr to be closed
  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        dsc_close_addr_r <= {{`M_ADDR_WIDTH{1'b0}}};
      else begin
        if (swr_rst_i)
          dsc_close_addr_r <= {{`M_ADDR_WIDTH{1'b0}}};
        else if (ld_desc_addr_start) begin
          if (`H_DATA_WIDTH == 16)
            dsc_close_addr_r <= dsc_list_start_i + 32'h2;
          else
            dsc_close_addr_r <= dsc_list_start_i;
        end
        //For a chained descriptor structure
        else if (ld_desc_addr_next)
          if (`H_DATA_WIDTH == 16)
            dsc_close_addr_r <= desc3_r + 32'h2;
          else
            dsc_close_addr_r <= desc3_r;
        //For a dual-buffer structure
        else if (ld_desc_addr_skip & ~end_of_ring) begin
          if (`H_DATA_WIDTH == 16)
            dsc_close_addr_r <= dsc_addr_r + {{(`M_ADDR_WIDTH-6){1'b0}},dsc_skp_len_i,1'b0} 
                                           + 32'h2;
          else if (`H_DATA_WIDTH == 32)
            dsc_close_addr_r <= dsc_addr_r + {{(`M_ADDR_WIDTH-7){1'b0}},dsc_skp_len_i,2'b00};
          else
            dsc_close_addr_r <= dsc_addr_r + {{(`M_ADDR_WIDTH-8){1'b0}},dsc_skp_len_i,3'b000};
        end
        else if (ld_desc_addr_skip & end_of_ring) 
          if (`H_DATA_WIDTH == 16)
            dsc_close_addr_r <= dsc_list_start_i + 32'h2;
          else
            dsc_close_addr_r <= dsc_list_start_i ;
      end
    end

  //----------------------------------------------------------------------
  // Buffer address generation logic
  //----------------------------------------------------------------------
  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        buf_addr_r <= {{`M_ADDR_WIDTH{1'b0}}};
      else begin
        if (swr_rst_i)
          buf_addr_r <= {{`M_ADDR_WIDTH{1'b0}}};
        else if (ld_buf1_addr)
          buf_addr_r <= buf1_addr_ptr;
        //For a chained descriptor structure
        else if (ld_buf2_addr)
          buf_addr_r <= buf2_addr_ptr;
        else if ((dmac_cs[`DMA_RD] & ahm_rdata_push_i) ||
                 (dmac_cs[`DMA_WR] & ahm_wdata_pop_i)) begin
          if (`H_DATA_WIDTH == 16) 
            buf_addr_r <= buf_addr_r + 32'h2;
          else if (`H_DATA_WIDTH == 32) 
            buf_addr_r <= buf_addr_r + 32'h4;
          else if (`H_DATA_WIDTH == 64) 
            buf_addr_r <= buf_addr_r + 32'h8;
        end
      end
    end

  //----------------------------------------------------------------------
  // PBL decode generation logic
  //----------------------------------------------------------------------
  always @(dmac_cs or pbl_i)
    begin
      if (dmac_cs[`DESC_CLOSE])
        pbl = 8'b0000_0000;
      else begin
        case (pbl_i) 
          3'b000  : pbl = 8'b0000_0000;
          3'b001  : pbl = 8'b0000_0011;
          3'b010  : pbl = 8'b0000_0111;
          3'b011  : pbl = 8'b0000_1111;
          3'b100  : pbl = 8'b0001_1111;
          3'b101  : pbl = 8'b0011_1111;
          3'b110  : pbl = 8'b0111_1111;
          default : pbl = 8'b1111_1111;
        endcase
      end
    end

  //----------------------------------------------------------------------
  // Input logic for the FSM
  //----------------------------------------------------------------------
  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        beat_cnt_r <= 8'h0;
      else begin
        if (ld_dsc_rd_bt_cnt)
          beat_cnt_r <= {4'h0,desc_beat_cnt};
        else if ( |beat_cnt_r & 
                 ((dmac_cs[`DESC_RD] && ahm_rdata_push_i) ||
                  (dmac_cs[`DMA_WR] && ahm_wdata_pop_i) || 
                  (dmac_cs[`DMA_RD] && ahm_rdata_push_i)))
          beat_cnt_r <= beat_cnt_r - 8'h1;
        else if (dmac_cs[`DMA_RD_REQ_WAIT] || 
                 dmac_cs[`DMA_WR_REQ_WAIT] || 
                 ((abort_cmd_i | end_boot_i | send_ccsd_r) & start_xfer_r))
          beat_cnt_r <= burst_cnt;
      end
    end

  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        xfer_cnt_r <= 13'h0;
      else begin
        if (ld_buf1_cnt) begin
          if (`H_DATA_WIDTH == 16)
            xfer_cnt_r <= {buf1_size[12:1],1'b0}   +
                          {12'h000,buf1_size[0],1'b0};
          else if (`H_DATA_WIDTH == 32)
            xfer_cnt_r <= {buf1_size[12:2],2'b00}  +
                          {11'h000,|buf1_size[1:0],2'b00};
          else if (`H_DATA_WIDTH == 64)
            xfer_cnt_r <= {buf1_size[12:3],3'b000} +
                          {10'h000,|buf1_size[2:0],3'b000};
        end
        else if (ld_buf2_cnt) begin
          if (`H_DATA_WIDTH == 16)
            xfer_cnt_r <= {buf2_size[12:1],1'b0}   + 
                          {12'h000,buf2_size[0],1'b0};
          else if (`H_DATA_WIDTH == 32)
            xfer_cnt_r <= {buf2_size[12:2],2'b00}  + 
                          {11'h000,|buf2_size[1:0],2'b00};
          else if (`H_DATA_WIDTH == 64)
            xfer_cnt_r <= {buf2_size[12:3],3'b000} + 
                          {10'h000,|buf2_size[2:0],3'b000};
        end
        else if ((dmac_cs[`DMA_RD] && ahm_rdata_push_i) ||
                 (dmac_cs[`DMA_WR] && ahm_wdata_pop_i)) begin
          if (`H_DATA_WIDTH == 16) 
            xfer_cnt_r <= xfer_cnt_r - 13'h2;
          else if (`H_DATA_WIDTH == 32) 
            xfer_cnt_r <= xfer_cnt_r - 13'h4;
          else if (`H_DATA_WIDTH == 64) 
            xfer_cnt_r <= xfer_cnt_r - 13'h8;
        end
      end
    end

  always @(xfer_cnt_r)
    begin

      if (xfer_cnt_r == 12'h000)
        xfer_cnt_over = 1'b1;
      else
        xfer_cnt_over = 1'b0;
/*      if (`H_DATA_WIDTH == 16) 
        // 2 or less
        xfer_cnt_over <= (xfer_cnt_r[12:1] == 12'h0) |
                         (xfer_cnt_r[12:0] == 12'h002);
      else if (`H_DATA_WIDTH == 32) 
        // 4 or less
        xfer_cnt_over <= (xfer_cnt_r[12:2] == 11'h0) |
                         (xfer_cnt_r[12:0] == 11'h004);
      else if (`H_DATA_WIDTH == 64) 
        // 8 or less
        xfer_cnt_over <= (xfer_cnt_r[12:3] == 10'h0) |
                         (xfer_cnt_r[12:0] == 10'h008);
*/
    end

  // start_xfer_r generation
  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n)
        start_xfer_r <= 1'b0;
      else 
        start_xfer_r <= start_xfer;
    end

   // For 32-bit Configuration following is mapping of Descriptor Elements in the databook
      // desc0_r = DES0
      // desc1_r = DES1
      // desc2_r = DES2
      // desc3_r = DES3
   // For 64-bit Configuration following is mapping of Descriptor Elements in the databook
      // desc0_r = DES0
      // desc1_r = DES2
      // desc2_r = DES5 DES4
      // desc3_r = DES7 DES6
  // Descriptor registers to hold 4 descriptors
  always @(posedge clk or negedge reset_n)
    begin
      if (~reset_n) begin
        desc0_r <= 32'h0; 
        desc1_r <= 32'h0;
        desc2_r <= {{`M_ADDR_WIDTH{1'b0}}};
        desc3_r <= {{`M_ADDR_WIDTH{1'b0}}};
      end
      else begin
        if (dmac_cs[`DMAC_IDLE] | dmac_cs[`DMA_STOP]) begin
          desc0_r <= 32'h0;
          desc1_r <= 32'h0;
          desc2_r <= {{`M_ADDR_WIDTH{1'b0}}};
          desc3_r <= {{`M_ADDR_WIDTH{1'b0}}};
        end
        else if (dmac_cs[`DESC_RD] && ahm_rdata_push_i) begin
          if (`H_DATA_WIDTH == 16) begin
            `ifdef M_ADDR_WIDTH_32
                if (beat_cnt_r == 32'h7) desc0_r[15:0]  <= ahm_rdata_i;
                if (beat_cnt_r == 32'h6) desc0_r[31:16] <= ahm_rdata_i;
                if (beat_cnt_r == 32'h5) desc1_r[15:0]  <= ahm_rdata_i;
                if (beat_cnt_r == 32'h4) desc1_r[31:16] <= ahm_rdata_i;
                if (beat_cnt_r == 32'h3) desc2_r[15:0]  <= ahm_rdata_i;
                if (beat_cnt_r == 32'h2) desc2_r[31:16] <= ahm_rdata_i;
                if (beat_cnt_r == 32'h1) desc3_r[15:0]  <= ahm_rdata_i;
                if (beat_cnt_r == 32'h0) desc3_r[31:16] <= ahm_rdata_i;
             `else
                if (beat_cnt_r == 32'hF) desc0_r[15:0]  <= ahm_rdata_i;
                if (beat_cnt_r == 32'hE) desc0_r[31:16] <= ahm_rdata_i;
                if (beat_cnt_r == 32'hB) desc1_r[15:0]  <= ahm_rdata_i;
                if (beat_cnt_r == 32'hA) desc1_r[31:16] <= ahm_rdata_i;
                if (beat_cnt_r == 32'h7) desc2_r[15:0]  <= ahm_rdata_i;
                if (beat_cnt_r == 32'h6) desc2_r[31:16] <= ahm_rdata_i;
                if (beat_cnt_r == 32'h5) desc2_r[47:32] <= ahm_rdata_i;
                if (beat_cnt_r == 32'h4) desc2_r[63:48] <= ahm_rdata_i;
                if (beat_cnt_r == 32'h3) desc3_r[15:0]  <= ahm_rdata_i;
                if (beat_cnt_r == 32'h2) desc3_r[31:16] <= ahm_rdata_i;
                if (beat_cnt_r == 32'h1) desc3_r[47:32] <= ahm_rdata_i;
                if (beat_cnt_r == 32'h0) desc3_r[63:48] <= ahm_rdata_i;
             `endif
          end
          else if (`H_DATA_WIDTH == 32) begin
            `ifdef M_ADDR_WIDTH_32
               if (beat_cnt_r == 32'h3) desc0_r <= ahm_rdata_i;
               if (beat_cnt_r == 32'h2) desc1_r <= ahm_rdata_i;
               if (beat_cnt_r == 32'h1) desc2_r <= ahm_rdata_i;
               if (beat_cnt_r == 32'h0) desc3_r <= ahm_rdata_i;
            `else
               if (beat_cnt_r == 32'h7) desc0_r <= ahm_rdata_i;
               if (beat_cnt_r == 32'h5) desc1_r <= ahm_rdata_i;
               if (beat_cnt_r == 32'h3) desc2_r[31:0] <= ahm_rdata_i;
               if (beat_cnt_r == 32'h2) desc2_r[63:32] <= ahm_rdata_i;
               if (beat_cnt_r == 32'h1) desc3_r[31:0] <= ahm_rdata_i;
               if (beat_cnt_r == 32'h0) desc3_r[63:32] <= ahm_rdata_i;
            `endif   
          end
          else if (`H_DATA_WIDTH == 64) begin
            `ifdef M_ADDR_WIDTH_32
               if (beat_cnt_r == 32'h1) {desc1_r,desc0_r} <= ahm_rdata_i;
               if (beat_cnt_r == 32'h0) {desc3_r,desc2_r} <= ahm_rdata_i;
            `else
               if (beat_cnt_r == 32'h3) {desc0_r}       <= ahm_rdata_i[31:0];
               if (beat_cnt_r == 32'h2) {desc1_r}       <= ahm_rdata_i[31:0];
               if (beat_cnt_r == 32'h1) {desc2_r}       <= ahm_rdata_i;
               if (beat_cnt_r == 32'h0) {desc3_r}       <= ahm_rdata_i;
            `endif
          end
        end
      end
    end


  //FSM State Encoding
  always @ (dmac_cs)
    begin
      case (1'b1)
        dmac_cs[`DMAC_IDLE]        : fsm_state = 4'b0000;
        dmac_cs[`DMA_STOP]        : fsm_state = 4'b0001;
        dmac_cs[`DESC_RD]         : fsm_state = 4'b0010;
        dmac_cs[`DESC_CHK]        : fsm_state = 4'b0011;
        dmac_cs[`DMA_RD_REQ_WAIT] : fsm_state = 4'b0100;
        dmac_cs[`DMA_WR_REQ_WAIT] : fsm_state = 4'b0101;
        dmac_cs[`DMA_RD]          : fsm_state = 4'b0110;
        dmac_cs[`DMA_WR]          : fsm_state = 4'b0111;
        dmac_cs[`DESC_CLOSE]      : fsm_state = 4'b1000;
        default                   : fsm_state = 4'b1111;
      endcase
    end

endmodule // 







