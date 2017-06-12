/*
------------------------------------------------------------------------
--
--                    (C) COPYRIGHT 2004-2011 SYNOPSYS, INC.
--                           ALL RIGHTS RESERVED
--
--  This software and the associated documentation are confidential and
--  proprietary to Synopsys, Inc.  Your use or disclosure of this
--  software is subject to the terms and conditions of a written
--  license agreement between you, or your company, and Synopsys, Inc.
--
--  The entire notice above must be reproduced on all authorized copies.
--
-- File :                       DW_ahb_constants.v
-- Author:                      Ray Beechinor 
-- Date :                       $Date: 2011/09/14 $ 
-- Version      :               $Revision: #3 $ 
-- Abstract     :               Auxiliary Parameter File for DW_ahb
--                              and associated files.  Contains
--                              parameters used in DW_ahb 
--                              which are not
--                              directly configured by the user 
--                              in coreConsultant
--
*/


// Name:         VISIBLE_0
// Default:      3
// Values:       -2147483648, ..., 2147483647
// 
// Visibility Control of Arbiter Slave
`define VISIBLE_0 3


// Name:         HSEL_ONLY_S0
// Default:      0
// Values:       -2147483648, ..., 2147483647
// 
// Generate Only Hsel for Arbiter Slave
`define HSEL_ONLY_S0 0


// Name:         ALIAS_S0
// Default:      0
// Values:       -2147483648, ..., 2147483647
// 
// Slave Alias for Arbiter
`define ALIAS_S0 0


// Name:         SPLIT_CAPABLE_0
// Default:      0
// Values:       -2147483648, ..., 2147483647
// 
// Is Arbiter Split-capable?
`define SPLIT_CAPABLE_0 0


// Name:         NUM_INT_MASTERS
// Default:      5 (work.DW_ahb_cc_constants.v.NUM_AHB_MASTERS+1)
// Values:       2, ..., 16
// 
// Internal Master PortCount
`define NUM_INT_MASTERS 5


// Name:         NUM_INT_SLAVES
// Default:      6 (work.DW_ahb_cc_constants.v.NUM_IAHB_SLAVES+1)
// Values:       2, ..., 31
// 
// Internal Master PortCount
`define NUM_INT_SLAVES 6


// Name:         HRESPBUS_WIDTH
// Default:      12 ((work.DW_ahb_cc_constants.v.NUM_IAHB_SLAVES+1)*2)
// Values:       2, ..., 62
// 
// Internal HTRANS Bus Width
`define HRESPBUS_WIDTH 12


// Name:         HTRANSBUS_WIDTH
// Default:      10 ((work.DW_ahb_cc_constants.v.NUM_AHB_MASTERS+1)*2)
// Values:       2, ..., 32
// 
// Internal HTRANS Bus Width
`define HTRANSBUS_WIDTH 10


// Name:         HSIZEBUS_WIDTH
// Default:      15 ((work.DW_ahb_cc_constants.v.NUM_AHB_MASTERS+1)*3)
// Values:       3, ..., 48
// 
// HSIZE Address Bus Width
`define HSIZEBUS_WIDTH 15


// Name:         HBURSTBUS_WIDTH
// Default:      15 ((work.DW_ahb_cc_constants.v.NUM_AHB_MASTERS+1)*3)
// Values:       3, ..., 48
// 
// HBURST Address Bus Width
`define HBURSTBUS_WIDTH 15


// Name:         HPROTBUS_WIDTH
// Default:      20 ((work.DW_ahb_cc_constants.v.NUM_AHB_MASTERS+1)*4)
// Values:       4, ..., 96
// 
// HPROT Address Bus Width
`define HPROTBUS_WIDTH 20


// Name:         HWRITEBUS_WIDTH
// Default:      5 (work.DW_ahb_cc_constants.v.NUM_AHB_MASTERS+1)
// Values:       1, ..., 16
// 
// HWRITE Address Bus Width
`define HWRITEBUS_WIDTH 5


// Name:         HREADY_WIDTH
// Default:      6 (work.DW_ahb_cc_constants.v.NUM_IAHB_SLAVES+1)
// Values:       1, ..., 32
// 
// HWRITE Address Bus Width
`define HREADY_WIDTH 6


// Name:         INTERNAL_HSEL
// Default:      7 (work.DW_ahb_cc_constants.v.NUM_IAHB_SLAVES+2)
// Values:       -2147483648, ..., 2147483647
// 
// InternalBusWidth
`define INTERNAL_HSEL 7


// Name:         SPLITBUS_WIDTH
// Default:      80 (work.DW_ahb_cc_constants.v.NUM_IAHB_SLAVES*16)
// Values:       -2147483648, ..., 2147483647
// 
// HWRITE Address Bus Width
`define SPLITBUS_WIDTH 80


// Name:         BUS_AHB_CCL_WIDTH
// Default:      480 (work.DW_ahb_cc_constants.v.AHB_CCL_WIDTH*15)
// Values:       -2147483648, ..., 2147483647
// 
// Bussed Counter Width
`define BUS_AHB_CCL_WIDTH 480

`define NC_NB_NP_O  4'b0000
`define NC_NB_NP_D  4'b0001
`define NC_NB_P_O   4'b0010
`define NC_NB_P_D   4'b0011

`define NC_B_NP_O   4'b0100
`define NC_B_NP_D   4'b0101
`define NC_B_P_O    4'b0110
`define NC_B_P_D    4'b0111

`define C_NB_NP_O   4'b1000
`define C_NB_NP_D   4'b1001
`define C_NP_P_O    4'b1010
`define C_NP_P_D    4'b1011

`define C_B_NP_O    4'b1100
`define C_B_NP_D    4'b1101
`define C_B_P_O     4'b1110
`define C_B_P_D     4'b1111
