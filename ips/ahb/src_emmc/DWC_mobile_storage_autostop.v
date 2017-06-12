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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_autostop.v#11 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_autostop.v
// Description : DWC_mobile_storage_autostop,
//               This module generate auto stop command request if Auto stop
//               is enabled, load_stop_cmd_req signal is asserted to match
//               command end and data end after the requested number of
//               transfered.
//
//               Block read = if block size <= 4 (16 for 4 bit)
//                            auto stop is send after byte count becomes "0"
//                      else auto stop is aligned with data block end bit
//               Block write = if block size <= 3 (12 for 4 bit)
//                            auto stop is send after byte count becomes "0"
//                      else auto stop is aligned with end bit of crc status.
//
//               Stream read = if byte_count < 6 - auto stop is send
//                             after start bit is received
//                       else When byte_count_rem = 6
//
//               Stream write = Stop command is sent such that
//                              no extra byte/s are transmitted.
//
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_autostop(
  /*AUTOARG*/
  // Outputs
  dp_load_stop_cmd_req,
  // Inputs
  creset_n, cclk_in, cclk_in_en, stop_data, dp_card_wide_bus, block_size,
  byte_count_rem, byte_countrem_zero, auto_stop_en,
  cp_load_data_par_r, transfer_mode, dp_cdata_in, read_write_xfer,
  data_done_tmp, txdt_stop_load_req, resp_timeout, data_trans_cmd
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clock and Reset
  input                   creset_n;          // Card Reset - Active Low
  input                   cclk_in;           // CIU Clock
  input                   cclk_in_en;        // clock enable

  // Input
  input                   stop_data;         // Stop data transmission
  input             [1:0] dp_card_wide_bus;  // 1/4/8-bit data bus.
  input            [15:0] block_size;        // Data transfer block size
  input            [31:0] byte_count_rem;    // Byte_count
  input                   byte_countrem_zero;// Byte_counter becomes zero
  input                   auto_stop_en;      // Auto stop enabled
  input                   cp_load_data_par_r;// Reg load data parameter
  input                   transfer_mode;     // Xfer mode block/stream
  input             [7:0] dp_cdata_in;       // Card data input lines
  input                   read_write_xfer;   // Read/write transfer
  input                   data_done_tmp;     // Data Xfer done
  input                   txdt_stop_load_req;// Stop load request
  input                   resp_timeout;      // Response timeout
  input                   data_trans_cmd;    // Data transfer command


  // To cmdpath
  output                  dp_load_stop_cmd_req;// Load stop command request

  // Defines for autostop states
  `define               AS_IDLE              0 // Autostop idle
  `define               AS_WAITCHKBYTE       1 // Autostop check byte count
  `define               AS_WAITBYTEZERO      2 // Wait for byte_count zero
  `define               AS_WAITSTOPLD        3 // Load autostop cmd req
  `define               AS_WAITSREQ_STBIT    4 // Wait for rx data start bit

  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Register
  reg                 [4:0] as_cs;            // Autostop state m/c current st
  reg                 [4:0] as_ns;            // Autostop state m/c next state
  reg                 [5:0] limit_block_size; // Byte count limit for autostop
  reg                 [1:0] idle_sel_r;


  // Wires
  wire                [5:0] limit_block_size_w;// Byte count limit for autostop
  wire                [1:0] idle_sel;          // Mux sel for state mchine


  // Autostop state machine register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        as_cs        <= 5'h1; // idle
      else begin
        if (cclk_in_en &&
            (stop_data || data_done_tmp ||
             (data_trans_cmd && resp_timeout)))
          as_cs      <= 5'h1;
        else if (cclk_in_en | ((idle_sel_r != idle_sel)))
          as_cs      <= as_ns;
      end
    end

  // 4:1 mux select lines for idle state transition
  assign idle_sel[0]    = ((block_size <= limit_block_size) && !transfer_mode)|
                          (byte_count_rem == limit_block_size);
  assign idle_sel[1]    = ((byte_count_rem < 6) && transfer_mode) ||
                          (byte_count_rem == limit_block_size);

  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        idle_sel_r <= 2'h0;
      else begin
        idle_sel_r <= idle_sel;
      end
    end

  // FIFO read  state machine combinational logic
  always @ (/*AUTOSENSE*/ as_cs or auto_stop_en
            or byte_countrem_zero or cp_load_data_par_r or dp_cdata_in
            or idle_sel or read_write_xfer or txdt_stop_load_req)
    begin : FSM_autostop
      as_ns = 5'h0;

      case (1'b1)
        as_cs[`AS_IDLE] :  begin
          if (cp_load_data_par_r && auto_stop_en)
            as_ns[`AS_WAITCHKBYTE]  = 1'b1;
          else
            as_ns[`AS_IDLE]         = 1'b1;
        end

        as_cs[`AS_WAITCHKBYTE] : begin
          case (idle_sel)
            2'b01 : as_ns[`AS_WAITBYTEZERO]   = 1'b1;
            2'b10 : as_ns[`AS_WAITSREQ_STBIT] = 1'b1;
            2'b11 : as_ns[`AS_WAITSTOPLD]     = 1'b1;
            default : as_ns[`AS_WAITCHKBYTE]  = 1'b1;
          endcase
        end

        as_cs[`AS_WAITBYTEZERO] : begin
          if (byte_countrem_zero)
            as_ns[`AS_WAITSTOPLD]   = 1'b1;
          else
            as_ns[`AS_WAITBYTEZERO] = 1'b1;
        end

        as_cs[`AS_WAITSREQ_STBIT] : begin
          if (((~dp_cdata_in[0]) && (~read_write_xfer)) // rx strm data st bit
              || txdt_stop_load_req)    // write stream FIFO not empty
            as_ns[`AS_WAITSTOPLD]     = 1'b1;
          else
            as_ns[`AS_WAITSREQ_STBIT] = 1'b1;
        end

        as_cs[`AS_WAITSTOPLD] : as_ns[`AS_IDLE] = 1'b1;
      endcase
    end

  // Output  assignments
  assign dp_load_stop_cmd_req = as_cs[`AS_WAITSTOPLD];

  assign limit_block_size_w   = (transfer_mode) ? 6 : 
                                ((dp_card_wide_bus[1]) ?
                                ((2 + (!read_write_xfer))*8) :
                                (dp_card_wide_bus == 2'b01) ?
                                ((2 + (!read_write_xfer))*4) :
                                (2 + (!read_write_xfer)));

  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) begin
        limit_block_size <= 6'h0;
      end else begin
        if (cclk_in_en)
          limit_block_size <= limit_block_size_w;
      end
    end

endmodule // DWC_mobile_storage_autostop
