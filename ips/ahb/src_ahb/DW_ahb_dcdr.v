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
-- File :                       DW_ahb_dcdr.v
-- Author:                      Ray Beechinor, Peter Gillen 
-- Date :                       $Date: 2011/09/14 $ 
-- Version      :               $Revision: #3 $ 
-- Abstract     :               
--
-- Implements the AHB decoder from a specified address range for each
-- peripheral. Need to expand the functionality to include the addition
-- of multiple address ranges for a selected peripheral
--
*/
`include "DW_amba_constants.v" 
`include "DW_ahb_cc_constants.v"
`include "DW_ahb_constants.v"
module DW_ahb_dcdr (
  haddr,
  remap_n,
  hsel
);

  // physical parameters
  parameter haddr_width = `HADDR_WIDTH;       // 32, 64

  // memory map parameters
  parameter r1_n_sa_1 = 32'h0;
  parameter r1_n_ea_1 = 32'h0;
  parameter r1_n_sa_2 = 32'h0;
  parameter r1_n_ea_2 = 32'h0;

  input  [haddr_width-1:0]   haddr;
// There are two modes of operation, normal or boot mode and one
// can configure the address map differently for both so that say
// the interrupt service routines are at address 0, etc
  input                       remap_n;
  output [`INTERNAL_HSEL-1:0] hsel;

  wire [15:0]                 hsel_norm;
  wire [15:0]                 hsel_remap_n;
  wire [`NUM_IAHB_SLAVES:0]   hsel_int; 
 
  reg                         hsel_none;
  integer                     i;

//
// Generate the normal addresses. 
// VISIBLE_x and MR_Nx and MR_Bx are all
// static signals
// Slaves can have two regions of address within the address map
// if they so choose.
//
  assign hsel_norm[0] = (`AHB_HAS_ARBIF == 1) ? 
    (((haddr >= `R1_N_SA_0) && (haddr <= `R1_N_EA_0))) : 1'b0;

  assign hsel_norm[1] = (
     (((haddr >= r1_n_sa_1) && (haddr <= r1_n_ea_1)) ||
      ((haddr >= `R2_N_SA_1) && (haddr <= `R2_N_EA_1) &&
       (`MR_N1 >= 3'b001)) ||
      ((haddr >= `R3_N_SA_1) && (haddr <= `R3_N_EA_1) &&
       (`MR_N1 >= 3'b010)) ||
      ((haddr >= `R4_N_SA_1) && (haddr <= `R4_N_EA_1) &&
       (`MR_N1 >= 3'b011)) ||
      ((haddr >= `R5_N_SA_1) && (haddr <= `R5_N_EA_1) &&
       (`MR_N1 >= 3'b100)) ||
      ((haddr >= `R6_N_SA_1) && (haddr <= `R6_N_EA_1) &&
       (`MR_N1 >= 3'b101)) ||
      ((haddr >= `R7_N_SA_1) && (haddr <= `R7_N_EA_1) &&
       (`MR_N1 >= 3'b110)) ||
      ((haddr >= `R8_N_SA_1) && (haddr <= `R8_N_EA_1) &&
       (`MR_N1 == 3'b111))) &&
     (`VISIBLE_1 != 2'b10));

  assign hsel_norm[2] = (
     (((haddr >= r1_n_sa_2) && (haddr <= r1_n_ea_2)) ||
      ((haddr >= `R2_N_SA_2) && (haddr <= `R2_N_EA_2) &&
       (`MR_N2 == 1'b1))) &&
     (`VISIBLE_2 != 2'b10));

  assign hsel_norm[3] = (
     (((haddr >= `R1_N_SA_3) && (haddr <= `R1_N_EA_3)) ||
      ((haddr >= `R2_N_SA_3) && (haddr <= `R2_N_EA_3) &&
       (`MR_N3 == 1'b1))) &&
     (`VISIBLE_3 != 2'b10));

  assign hsel_norm[4] = (
     (((haddr >= `R1_N_SA_4) && (haddr <= `R1_N_EA_4)) ||
      ((haddr >= `R2_N_SA_4) && (haddr <= `R2_N_EA_4) &&
       (`MR_N4 == 1'b1))) &&
     (`VISIBLE_4 != 2'b10));

  assign hsel_norm[5] = (
     (((haddr >= `R1_N_SA_5) && (haddr <= `R1_N_EA_5)) ||
      ((haddr >= `R2_N_SA_5) && (haddr <= `R2_N_EA_5) &&
       (`MR_N5 == 1'b1))) &&
     (`VISIBLE_5 != 2'b10));

  assign hsel_norm[6] = (
     (((haddr >= `R1_N_SA_6) && (haddr <= `R1_N_EA_6)) ||
      ((haddr >= `R2_N_SA_6) && (haddr <= `R2_N_EA_6) &&
       (`MR_N6 == 1'b1))) &&
     (`VISIBLE_6 != 2'b10));

  assign hsel_norm[7] = (
     (((haddr >= `R1_N_SA_7) && (haddr <= `R1_N_EA_7)) ||
      ((haddr >= `R2_N_SA_7) && (haddr <= `R2_N_EA_7) &&
       (`MR_N7 == 1'b1))) &&
     (`VISIBLE_7 != 2'b10));

  assign hsel_norm[8] = (
     (((haddr >= `R1_N_SA_8) && (haddr <= `R1_N_EA_8)) ||
      ((haddr >= `R2_N_SA_8) && (haddr <= `R2_N_EA_8) &&
       (`MR_N8 == 1'b1))) &&
     (`VISIBLE_8 != 2'b10));

  assign hsel_norm[9] = (
     (((haddr >= `R1_N_SA_9) && (haddr <= `R1_N_EA_9)) ||
      ((haddr >= `R2_N_SA_9) && (haddr <= `R2_N_EA_9) &&
       (`MR_N9 == 1'b1))) &&
     (`VISIBLE_9 != 2'b10));

  assign hsel_norm[10] = (
     (((haddr >= `R1_N_SA_10) && (haddr <= `R1_N_EA_10)) ||
      ((haddr >= `R2_N_SA_10) && (haddr <= `R2_N_EA_10) &&
       (`MR_N10 == 1'b1))) &&
     (`VISIBLE_10 != 2'b10));

  assign hsel_norm[11] = (
     (((haddr >= `R1_N_SA_11) && (haddr <= `R1_N_EA_11)) ||
      ((haddr >= `R2_N_SA_11) && (haddr <= `R2_N_EA_11) &&
       (`MR_N11 == 1'b1))) &&
     (`VISIBLE_11 != 2'b10));

  assign hsel_norm[12] = (
     (((haddr >= `R1_N_SA_12) && (haddr <= `R1_N_EA_12)) ||
      ((haddr >= `R2_N_SA_12) && (haddr <= `R2_N_EA_12) &&
       (`MR_N12 == 1'b1))) &&
     (`VISIBLE_12 != 2'b10));

  assign hsel_norm[13] = (
     (((haddr >= `R1_N_SA_13) && (haddr <= `R1_N_EA_13)) ||
      ((haddr >= `R2_N_SA_13) && (haddr <= `R2_N_EA_13) &&
       (`MR_N13 == 1'b1))) &&
     (`VISIBLE_13 != 2'b10));

  assign hsel_norm[14] = (
     (((haddr >= `R1_N_SA_14) && (haddr <= `R1_N_EA_14)) ||
      ((haddr >= `R2_N_SA_14) && (haddr <= `R2_N_EA_14) &&
       (`MR_N14 == 1'b1))) &&
     (`VISIBLE_14 != 2'b10));

  assign hsel_norm[15] = (
     (((haddr >= `R1_N_SA_15) && (haddr <= `R1_N_EA_15)) ||
      ((haddr >= `R2_N_SA_15) && (haddr <= `R2_N_EA_15) &&
       (`MR_N15 == 1'b1))) &&
     (`VISIBLE_15 != 2'b10));

//
// Generate the remap addresses
//

  assign hsel_remap_n[0] = (`AHB_HAS_ARBIF == 1) ? 
    (((haddr >= `R1_B_SA_0) && (haddr <= `R1_B_EA_0))) : 1'b0;

  assign hsel_remap_n[1] = (
     (((haddr >= `R1_B_SA_1) && (haddr <= `R1_B_EA_1)) ||
      ((haddr >= `R2_B_SA_1) && (haddr <= `R2_B_EA_1) &&
       (`MR_B1 >= 3'b001)) ||
      ((haddr >= `R3_B_SA_1) && (haddr <= `R3_B_EA_1) &&
       (`MR_B1 >= 3'b010)) ||
      ((haddr >= `R4_B_SA_1) && (haddr <= `R4_B_EA_1) &&
       (`MR_B1 >= 3'b011)) ||
      ((haddr >= `R5_B_SA_1) && (haddr <= `R5_B_EA_1) &&
       (`MR_B1 >= 3'b100)) ||
      ((haddr >= `R6_B_SA_1) && (haddr <= `R6_B_EA_1) &&
       (`MR_B1 >= 3'b101)) ||
      ((haddr >= `R7_B_SA_1) && (haddr <= `R7_B_EA_1) &&
       (`MR_B1 >= 3'b110)) ||
      ((haddr >= `R8_B_SA_1) && (haddr <= `R8_B_EA_1) &&
       (`MR_B1 == 3'b111))) &&
     (`VISIBLE_1 != 2'b 01));

  assign hsel_remap_n[2] = (
     (((haddr >= `R1_B_SA_2) && (haddr <= `R1_B_EA_2)) ||
      ((haddr >= `R2_B_SA_2) && (haddr <= `R2_B_EA_2) &&
       (`MR_B2 == 1'b1))) &&
     (`VISIBLE_2 != 2'b 01));

  assign hsel_remap_n[3] = (
     (((haddr >= `R1_B_SA_3) && (haddr <= `R1_B_EA_3)) ||
      ((haddr >= `R2_B_SA_3) && (haddr <= `R2_B_EA_3) &&
       (`MR_B3 == 1'b1))) &&
     (`VISIBLE_3 != 2'b 01));

  assign hsel_remap_n[4] = (
     (((haddr >= `R1_B_SA_4) && (haddr <= `R1_B_EA_4)) ||
      ((haddr >= `R2_B_SA_4) && (haddr <= `R2_B_EA_4) &&
       (`MR_B4 == 1'b1))) &&
     (`VISIBLE_4 != 2'b 01));

  assign hsel_remap_n[5] = (
     (((haddr >= `R1_B_SA_5) && (haddr <= `R1_B_EA_5)) ||
      ((haddr >= `R2_B_SA_5) && (haddr <= `R2_B_EA_5) &&
       (`MR_B5 == 1'b1))) &&
     (`VISIBLE_5 != 2'b 01));

  assign hsel_remap_n[6] = (
     (((haddr >= `R1_B_SA_6) && (haddr <= `R1_B_EA_6)) ||
      ((haddr >= `R2_B_SA_6) && (haddr <= `R2_B_EA_6) &&
       (`MR_B6 == 1'b1))) &&
     (`VISIBLE_6 != 2'b 01));

  assign hsel_remap_n[7] = (
     (((haddr >= `R1_B_SA_7) && (haddr <= `R1_B_EA_7)) ||
      ((haddr >= `R2_B_SA_7) && (haddr <= `R2_B_EA_7) &&
       (`MR_B7 == 1'b1))) &&
     (`VISIBLE_7 != 2'b 01));

  assign hsel_remap_n[8] = (
     (((haddr >= `R1_B_SA_8) && (haddr <= `R1_B_EA_8)) ||
      ((haddr >= `R2_B_SA_8) && (haddr <= `R2_B_EA_8) &&
       (`MR_B8 == 1'b1))) &&
     (`VISIBLE_8 != 2'b 01));

  assign hsel_remap_n[9] = (
     (((haddr >= `R1_B_SA_9) && (haddr <= `R1_B_EA_9)) ||
      ((haddr >= `R2_B_SA_9) && (haddr <= `R2_B_EA_9) &&
       (`MR_B9 == 1'b1))) &&
     (`VISIBLE_9 != 2'b 01));

  assign hsel_remap_n[10] = (
     (((haddr >= `R1_B_SA_10) && (haddr <= `R1_B_EA_10)) ||
      ((haddr >= `R2_B_SA_10) && (haddr <= `R2_B_EA_10) &&
       (`MR_B10 == 1'b1))) &&
     (`VISIBLE_10 != 2'b 01));

  assign hsel_remap_n[11] = (
     (((haddr >= `R1_B_SA_11) && (haddr <= `R1_B_EA_11)) ||
      ((haddr >= `R2_B_SA_11) && (haddr <= `R2_B_EA_11) &&
       (`MR_B11 == 1'b1))) &&
     (`VISIBLE_11 != 2'b 01));

  assign hsel_remap_n[12] = (
     (((haddr >= `R1_B_SA_12) && (haddr <= `R1_B_EA_12)) ||
      ((haddr >= `R2_B_SA_12) && (haddr <= `R2_B_EA_12) &&
       (`MR_B12 == 1'b1))) &&
     (`VISIBLE_12 != 2'b 01));

  assign hsel_remap_n[13] = (
     (((haddr >= `R1_B_SA_13) && (haddr <= `R1_B_EA_13)) ||
      ((haddr >= `R2_B_SA_13) && (haddr <= `R2_B_EA_13) &&
       (`MR_B13 == 1'b1))) &&
     (`VISIBLE_13 != 2'b 01));

  assign hsel_remap_n[14] = (
     (((haddr >= `R1_B_SA_14) && (haddr <= `R1_B_EA_14)) ||
      ((haddr >= `R2_B_SA_14) && (haddr <= `R2_B_EA_14) &&
       (`MR_B14 == 1'b1))) &&
     (`VISIBLE_14 != 2'b 01));

  assign hsel_remap_n[15] = (
     (((haddr >= `R1_B_SA_15) && (haddr <= `R1_B_EA_15)) ||
      ((haddr >= `R2_B_SA_15) && (haddr <= `R2_B_EA_15) &&
       (`MR_B15 == 1'b1))) &&
     (`VISIBLE_15 != 2'b 01));

//
// extract the active slice from the fully configured bus provided
// one is in normal or remap mode
//
  assign hsel_int = remap_n ? hsel_norm[`NUM_IAHB_SLAVES:0] : 
       hsel_remap_n[`NUM_IAHB_SLAVES:0];

//
// Determine hsel_none, provided no other hsel's are active
//
  always @(hsel_int)
  begin : hsel_none_PROC
    hsel_none = 1'b1;
    for (i=0; i<=`NUM_IAHB_SLAVES; i=i+1) begin
      if (hsel_int[i] == 1'b1)
        hsel_none = 1'b0;
    end
  end

  assign hsel[`NUM_IAHB_SLAVES:0] = hsel_int;
  assign hsel[`NUM_IAHB_SLAVES+1] = hsel_none;
   
endmodule 
