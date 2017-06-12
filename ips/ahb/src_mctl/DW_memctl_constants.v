//============================================================================
//
//                   (C) COPYRIGHT 2001-2011 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc.  Your use or disclosure of this
// software is subject to the terms and conditions of a written
// license agreement between you, or your company, and Synopsys, Inc.
//
// The entire notice above must be reproduced on all authorized copies
//
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_constants.v $ 
// $Revision: #3 $
//
// Abstract  : This module defines constants for the DW_memctl.
//
//=============================================================================

`define  CONFIG_REG_ADDR           8'h00  // 00
`define  SDRAM_TIMING_REG0_ADDR    8'h01  // 04
`define  SDRAM_TIMING_REG1_ADDR    8'h02  // 08
`define  CONTROL_REG_ADDR          8'h03  // 0C
`define  REFRESH_REG_ADDR          8'h04  // 10
`define  CHIPSEL_REG0_LOW_ADDR     8'h05  // 14
`define  CHIPSEL_REG1_LOW_ADDR     8'h06  // 18
`define  CHIPSEL_REG2_LOW_ADDR     8'h07  // 1C
`define  CHIPSEL_REG3_LOW_ADDR     8'h08  // 20
`define  CHIPSEL_REG4_LOW_ADDR     8'h09  // 24
`define  CHIPSEL_REG5_LOW_ADDR     8'h0A  // 28
`define  CHIPSEL_REG6_LOW_ADDR     8'h0B  // 2C
`define  CHIPSEL_REG7_LOW_ADDR     8'h0C  // 30
`define  CHIPSEL_REG0_HIGH_ADDR    8'h0D  // 34
`define  CHIPSEL_REG1_HIGH_ADDR    8'h0E  // 38
`define  CHIPSEL_REG2_HIGH_ADDR    8'h0F  // 3C
`define  CHIPSEL_REG3_HIGH_ADDR    8'h10  // 40
`define  CHIPSEL_REG4_HIGH_ADDR    8'h11  // 44
`define  CHIPSEL_REG5_HIGH_ADDR    8'h12  // 48
`define  CHIPSEL_REG6_HIGH_ADDR    8'h13  // 4C
`define  CHIPSEL_REG7_HIGH_ADDR    8'h14  // 50
`define  MASK_REG_ADDR1            8'h15  // 54
`define  MASK_REG_ADDR2            8'h16  // 58
`define  MASK_REG_ADDR3            8'h17  // 5C
`define  MASK_REG_ADDR4            8'h18  // 60
`define  MASK_REG_ADDR5            8'h19  // 64
`define  MASK_REG_ADDR6            8'h1A  // 68
`define  MASK_REG_ADDR7            8'h1B  // 6C
`define  MASK_REG_ADDR8            8'h1C  // 70
`define  CHIPSEL0_LOW_ALIAS_REG_ADDR  8'h1D  // 74
`define  CHIPSEL1_LOW_ALIAS_REG_ADDR  8'h1E  // 78
`define  CHIPSEL0_HIGH_ALIAS_REG_ADDR 8'h1F  // 7C
`define  CHIPSEL1_HIGH_ALIAS_REG_ADDR 8'h20  // 80
`define  CHIPSEL0_LOW_REMAP_REG_ADDR  8'h21  // 84
`define  CHIPSEL1_LOW_REMAP_REG_ADDR  8'h22  // 88
`define  CHIPSEL0_HIGH_REMAP_REG_ADDR 8'h23  // 8C
`define  CHIPSEL1_HIGH_REMAP_REG_ADDR 8'h24  // 90
`define  SMTMGR_SET0_REG_ADDR         8'h25  // 94
`define  SMTMGR_SET1_REG_ADDR         8'h26  // 98
`define  SMTMGR_SET2_REG_ADDR         8'h27  // 9C
`define  FLASH_TRPDR_REG_ADDR         8'h28  // a0
`define  SMCTLR_REG_ADDR              8'h29  // a4
`define  SYFLASH_OPCODE_REG_ADDR      8'h2a  // a8
`define  EXN_MODE_REG_ADDR            8'h2b  // ac
`define  SFCONR_REG_ADDR              8'h2c  // b0  
`define  SFCTLR_REG_ADDR              8'h2d  // b4
`define  SYNCFLASH_TIMING_REG_ADDR    8'h2e  // b8
`define  MEMCTL_COMP_TYPE_ADDR        8'h3f  // fc
`define  MEMCTL_COMP_VERSION_ADDR     8'h3e  // f8
`define  MEMCTL_COMP_PARAMS_1_ADDR    8'h3d  // f4
`define  MEMCTL_COMP_PARAMS_2_ADDR    8'h3c  // f0

`define CR_IDLE      3'h0
`define CR_16RD1     3'h1
`define CR_16RD2     3'h2
`define CR_16WR1     3'h3
`define CR_16WR2     3'h4
`define CR_WR_DONE   3'h5
`define CR_DONE      3'h6
`define SMCR_IDLE    3'h0
`define SMCR_16RD1   3'h1
`define SMCR_16RD2   3'h2
`define SMCR_16WR1   3'h3
`define SMCR_16WR2   3'h4
`define SMCR_WR_DONE 3'h5
`define SMCR_DONE    3'h6

//----------{ HIU parameters }------------------------------------------------

// Addr FIFO Parameters
//
//    AFIFO_IN_WIDTH                AFIFO_OUT_WIDTH
//    --------------------------    -----------------------------------
//    haddr[3:0] 4                  hiu_haddr          4
//    hsize      3                  hiu_hsize          3
//    addr       H_ADDR_WIDTH       hiu_addr           H_ADDR_WIDTH
//    b_size     6                  hiu_burst_size     6
//    wb         1                  hiu_wrapped_burst  1
//    rw         1                  hiu_rw             1
//    sel        2
//    --------------------------    -----------------------------------
//

`define AFIFO_IN_WIDTH  ( `H_ADDR_WIDTH + 17 )
`define AFIFO_OUT_WIDTH ( `H_ADDR_WIDTH + 15 )

//
// Data FIFO Parameters
//
//    DFIFO_IN_WIDTH                DFIFO_OUT_WIDTH
//    --------------------------    -----------------------------------
//    data    H_DATA_WIDTH          hiu_data  S_RD_DATA_WIDTH
//    dp      1
//    tm      1
//    --------------------------    -----------------------------------
//

`define DFIFO_IN_WIDTH       ( `H_DATA_WIDTH + 2 )
`define DFIFO_OUT_WIDTH      `S_RD_DATA_WIDTH

//----------{ end of HIU parameters }-----------------------------------------
