/*
------------------------------------------------------------------------
--
--                  (C) COPYRIGHT 2001-2011 SYNOPSYS, INC.
--                             ALL RIGHTS RESERVED
--
--  This software and the associated documentation are confidential and
--  proprietary to Synopsys, Inc.  Your use or disclosure of this
--  software is subject to the terms and conditions of a written
--  license agreement between you, or your company, and Synopsys, Inc.
--
--  The entire notice above must be reproduced on all authorized copies.
--
-- File :                       DW_ahb_dfltslv.v
-- Author:                      Ray Beechinor, Peter Gillen
-- Date :                       $Date: 2011/09/14 $ 
-- Version      :               $Revision: #3 $ 
-- Abstract     :               
--
-- AHB Default Slave, provides two-cycle 1'b1 response if a
-- non-existant address is accessed during a SEQ or NONSEQ transfer.
-- Provides a one-cycle OKAY response if a non-existant address is
-- accessed by an IDLE or BUSY transfer
--
*/
`include "DW_amba_constants.v" 
`include "DW_ahb_cc_constants.v"
`include "DW_ahb_constants.v"
module DW_ahb_dfltslv (
  hclk,
  hresetn,
  hready,
  htrans,
  hsel_none,
  hready_resp_none,
  hresp_none,
  hrdata_none
);
   
  // physical parameters
  parameter ahb_data_width = `AHB_DATA_WIDTH; // 32, 64, 128, 256

  input                        hclk;
  input                        hresetn;
  input                        hready;
  input [`HTRANS_WIDTH-1:0]    htrans;
  input                        hsel_none;

  output                       hready_resp_none;
  output [`HRESP_WIDTH-1:0]    hresp_none;
  output [ahb_data_width-1:0] hrdata_none;

  reg [`HRESP_WIDTH-1:0]       hresp_none;
  reg                          hready_resp_none;
  reg                          current_state;
  reg                          next_state;

  wire                         ahb_activity;


//
// Never expecting there to be any activity on the bus that is
// addressed to the default slave. If there is and it is recognised
// by ahb_activity, then this is a pre-cursor to sending an error
// response.
//
  assign ahb_activity = (((htrans == `SEQ) || (htrans == `NONSEQ)) &&
                         ((hsel_none == 1'b1) && (hready == 1'b1)));
   
//
// The Default Slave will only be selected if an attempt is made to 
// access a non-existant memory location.  If a SEQ or NONSEQ access
// is attempted, a two-cycle error response must be provided. 
// Otherwise (IDLE or BUSY transfers), provide an OKAY response
//
  always @ (current_state or ahb_activity)
  begin : next_state_PROC
    case (current_state)
      1'b0 : begin
        if (ahb_activity == 1'b1)
          next_state = 1'b1;
        else
          next_state = 1'b0;
      end
      default : begin
        next_state = 1'b0;
      end
    endcase
  end

  always @ (posedge hclk or negedge hresetn)
  begin : current_state_PROC
    if (hresetn == 1'b0)
      current_state <= 1'b0;
    else
      current_state <= next_state;
  end

//
// Under normal conditions always respond with hready active and an OKAY
// response. But when an error response is being sent then hready goes
// inactive for 1-cycle. The response is held for two cycles when it is
// an error response
//
  always @ (posedge hclk or negedge hresetn)
  begin : resp_PROC
    if (hresetn == 1'b0) begin
      hready_resp_none <= 1'b1;
      hresp_none       <= `OKAY;
    end else begin
      case (current_state)
        1'b0 : begin
          if (ahb_activity == 1'b1) begin
            hready_resp_none <= 1'b0;
            hresp_none       <= `ERROR;
          end else begin
            hready_resp_none <= 1'b1;
            hresp_none       <= `OKAY;
          end
        end
        default : begin
          hready_resp_none <= 1'b1;
          hresp_none       <= `ERROR;
        end
      endcase
    end
  end

//
// Whenever the device is selected the return data is always 0's
//
  assign hrdata_none = {ahb_data_width{1'b0}};

endmodule
                                        
                

