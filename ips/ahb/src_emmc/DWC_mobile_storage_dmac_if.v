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
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_dmac_if.v#8 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_dmac_if.v
// Description : DWC_mobile_storage Data interface for Internal DMAC
//               functions:
//                 - Resolves the write data coming from Ahb2Apb and the 
//                   internal DMAC
//                 - Resolves the read data going to Ahb2Apb from BIU and
//                   internal DMAC
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_dmac_if (
  // Outputs
  prdata_muxed_o,push1_o,pop1_o,fifo_din1_o,
 
  // Inputs
  use_internal_dmac_i,biu_fifo_pop_i,biu_fifo_push_i,
  biu_fifo_wdata_i,prdata_i,dmac_csr_sel_i,dmac_csr_rdata_i,
  dmac_fifo_pop_i,dmac_fifo_push_i,dmac_fifo_wdata_i,scan_mode
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  // Interface to AHB2APB 
  output   [`H_DATA_WIDTH-1:0] prdata_muxed_o;

  // Interface to BIU
  input                        use_internal_dmac_i; // Control signal from BIU
  input                        biu_fifo_pop_i;      // BIU to FIFO pop signal
  input                        biu_fifo_push_i;     // BIU to FIFO push signal
  input    [`F_DATA_WIDTH-1:0] biu_fifo_wdata_i;    // FIFO to BIU data 
  input    [`H_DATA_WIDTH-1:0] prdata_i;            // Read data from BIU

  // Interface to DMAC CSR
  input                        dmac_csr_sel_i;      // DMAC CSR selection
  input    [`H_DATA_WIDTH-1:0] dmac_csr_rdata_i;    // DMAC CSR Read data

  // Interface to FIFO Controller
  output                       push1_o;             // Push to FIFO controller
  output                       pop1_o;              // Pop to FIFO controller
  output   [`F_DATA_WIDTH-1:0] fifo_din1_o;         // Write data to FIFO

  // Interface to DMAC
  input                        dmac_fifo_push_i;    // Push to FIFO controller
  input                        dmac_fifo_pop_i;     // Pop to FIFO controller
  input    [`F_DATA_WIDTH-1:0] dmac_fifo_wdata_i;   // Write data to FIFO from DMAC

  input                        scan_mode;           // Scan mode


  // --------------------------------------
  // Register/Wire Declaration
  // --------------------------------------
 
  wire    [`F_DATA_WIDTH-1:0] dmac_fifo_wdata_i;    // Write data to FIFO
  wire    [`H_DATA_WIDTH-1:0] prdata_muxed_o;  // Write data to AHB2APB

  assign push1_o      = (use_internal_dmac_i)?dmac_fifo_push_i:
                                              biu_fifo_push_i;

  assign pop1_o       = (use_internal_dmac_i)?dmac_fifo_pop_i:
                                              biu_fifo_pop_i;

  assign fifo_din1_o  = (use_internal_dmac_i)?dmac_fifo_wdata_i:
                                              biu_fifo_wdata_i;

  assign prdata_muxed_o = (dmac_csr_sel_i)?dmac_csr_rdata_i:
                                           prdata_i;

endmodule // 
