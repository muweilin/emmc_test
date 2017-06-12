/*
------------------------------------------------------------------------
--
--                    (C) COPYRIGHT 2001-2011 SYNOPSYS, INC.
--                             ALL RIGHTS RESERVED
--
--  This software and the associated documentation are confidential and
--  proprietary to Synopsys, Inc.  Your use or disclosure of this
--  software is subject to the terms and conditions of a written
--  license agreement between you, or your company, and Synopsys, Inc.
--
--  The entire notice above must be reproduced on all authorized copies.
--
-- File :                       DW_ahb_gating.v
-- Author:                      Peter Gillen 
-- Date :                       $Date: 2011/09/14 $ 
-- Version      :               $Revision: #3 $ 
-- Abstract     :               
--
-- Depending on the configuration the grants can be generated from one
-- of two arbitration sources. This module controls which source wins.
-- =====================================================================
*/
`include "DW_amba_constants.v" 
`include "DW_ahb_cc_constants.v"
`include "DW_ahb_constants.v"
module DW_ahb_gating (
  wten,
  grant,
  grant_3t,
  parked,
  parked_3t,
  grant_2t,
  parked_2t
);

  input                       wten;
  input  [`NUM_AHB_MASTERS:0] grant;
  input  [`NUM_AHB_MASTERS:0] grant_3t;
  input                       parked;
  input                       parked_3t;

  output [`NUM_AHB_MASTERS:0] grant_2t;
  output                      parked_2t;

  reg    [`NUM_AHB_MASTERS:0] grant_2t;
  reg                         parked_2t;

//
// Always give the grant to the lower tiered arbiter unless the
// weighted token arbitration scheme is implemented then only give
// the grant from this upper arbiter when it is not parked and when
// the weighted token arbitration is enabled.
// Two conditions : Weighted token implemented
//                : Weighted token enabled
//
  always @(wten or parked_3t or grant_3t or grant)
  begin
    grant_2t = grant;
    if (`AHB_WTEN == 1) begin
      if ((wten == 1'b1) && (parked_3t == 1'b0)) begin
        grant_2t = grant_3t;
      end
    end
  end

//
// Whenever the weighted token priority scheme is used then
// the arbiter is parked when both arbiters are parked.
// When the weighted token priority scheme is not used then
// the arbiter is parked when the lower level arbiter is parked.
// Even when the weighted token priority scheme is used it may
// not be enabled so it then needs to behave as if it did not have
// the scheme
//
  always @(wten or parked_3t or parked)
  begin
    parked_2t = parked;
    if (`AHB_WTEN == 1) begin
      if (wten == 1'b1) begin
        parked_2t = parked && parked_3t;
      end
    end
  end

endmodule
