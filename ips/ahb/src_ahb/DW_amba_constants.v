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
-- File :                       DW_amba_constants.v
-- Author:                      Chris Gilbert
-- Date :                       $Date: 2011/09/14 $ 
-- Version      :               $Revision: #3 $ 
-- Abstract     :               Global DW_ocb definitions.
--                              This file contains definitions of all
--                              the AMBA Rev 2 control definitions,
--                              and some general purpose definitions.
--
*/

// AMBA Bus constant definitions


// Name:         HBURST_WIDTH
// Default:      3
// Values:       -2147483648, ..., 2147483647
// 
// Burst Bus Width
`define HBURST_WIDTH 3

`define HMASTER_WIDTH 4
`define HPROT_WIDTH 4
`define HRESP_WIDTH 2
`define HSIZE_WIDTH 3
`define HSPLIT_WIDTH 16
`define HTRANS_WIDTH 2

/* HBURST values */
`define SINGLE       3'b000
`define INCR         3'b001
`define WRAP4        3'b010
`define INCR4        3'b011
`define WRAP8        3'b100
`define INCR8        3'b101
`define WRAP16       3'b110
`define INCR16       3'b111

/* HRESP values */
`define OKAY  2'b00
`define ERROR 2'b01
`define RETRY 2'b10
`define SPLIT 2'b11

/* HSIZE values */
`define BYTE         3'b000     // 8    bits
`define HWORD        3'b001     // 16   bits
`define WORD         3'b010     // 32   bits
`define LWORD        3'b011     // 64   bits
`define DWORD        3'b100     // 128  bits
`define WORD4        3'b101     // 256  bits
`define WORD8        3'b110     // 512  bits
`define WORD16       3'b111     // 1024 bits

/* HTRANS values */
`define IDLE       2'b00
`define BUSY       2'b01
`define NONSEQ     2'b10
`define SEQ        2'b11

/* HWRITE/PWRITE values */
`define READ       1'b0
`define WRITE      1'b1

/* other useful definitions */
/* generic definitions */
`define TRUE       1'b1
`define FALSE      1'b0

`define zero8      8'b0
`define zero16     16'b0
`define zero32     32'b0

/* Define 1KBYTE block size */
`define KBYTE 1024
