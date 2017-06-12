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
// Date             :        $Date: 2013/02/21 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_dmac_ahb.v#15 $
//--                                                                        
//--------------------------------------------------------------------------
//-- MODULE: DWC_mobile_storage_dmac_ahb
//--
//-- DESCRIPTION: This is the top level module for the Internal DMAC
//--              DMAC CSR and AHB Master instantiations
//--              This contains ONLY instantiations
//--
//----------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_dmac_ahb(
  // Outputs
  hreq_o, haddr_o, htrans_o, hwrite_o, hsize_o, hburst_o, hwdata_o,
  dmac_csr_rdata_o, dmac_csr_sel_o, dmac_ack_o, dmac_fifo_push_o,
  dmac_fifo_pop_o, dmac_fifo_wdata_o, dmac_biu_intr_o, fifo_rst_o, 
  dmac_debug_reg,

  // Inputs
  hclk_i, hreset_n_i, hgrant_i, hready_i, hresp_i, hrdata_i,
  dmac_csr_psel_i, dmac_csr_penable_i, dmac_csr_paddr_i, dmac_csr_pben_i,
  dmac_csr_pwrite_i, dmac_csr_wdata_i, pbl_i, dmac_req_i, new_cmd_i, 
  data_expected_i, data_w_rn_i, abort_cmd_i, end_bit_err_i, resp_tout_i,
  resp_crc_err_i, st_bit_err_i, data_rd_tout_i, data_crc_err_i, 
  resp_err_i, cmd_done_i, dto_i, fifo_rst_i, dmac_fifo_rdata_i, big_endian_i,
  bytecnt_i,biu_interrupt_i,int_enable_i,fifo_empty_i,send_ccsd_i,scan_mode,
  enable_boot,        
  alternative_boot_mode,
  end_boot_i,
  boot_ack_timeout,
  biu_card_rd_thres_en,

  boot_data_timeout
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  // Host Clock and Reset
  input                        hclk_i;             // System Clock 
  input                        hreset_n_i;         // System Reset - Active Low

  // Interface to AHB
  output                       hreq_o;             // Request
  output  [`M_ADDR_WIDTH-1:0]  haddr_o;            // Address
  output                [1:0]  htrans_o;           // Transfer attribute
  output                       hwrite_o;           // Read/Write
  output                [2:0]  hsize_o;            // Size
  output                [2:0]  hburst_o;           // Burst
  output  [`H_DATA_WIDTH-1:0]  hwdata_o;           // Write data

  input                        hgrant_i;           // Grant
  input                        hready_i;           // Data Ready
  input                 [1:0]  hresp_i;            // Response
  input   [`H_DATA_WIDTH-1:0]  hrdata_i;           // Read data

  // Interface to DMAC_IF
  output  [`H_DATA_WIDTH-1:0]  dmac_csr_rdata_o;   // DMAC CSR read data
  output                       dmac_csr_sel_o;     // DMAC CSR select out

  input                        dmac_csr_psel_i;    // DMAC CSR select in
  input                        dmac_csr_penable_i; // DMAC CSR enable
  input   [`H_ADDR_WIDTH-1:0]  dmac_csr_paddr_i;   // DMAC CSR address
  input [`H_DATA_WIDTH/8-1:0]  dmac_csr_pben_i;    // Byte enables
  input                        dmac_csr_pwrite_i;  // Register Read/Write
  input   [`H_DATA_WIDTH-1:0]  dmac_csr_wdata_i;   // DMAC CSR write data
  input                        big_endian_i;       // Big Endian configuration

  // Interface to BIU
  output                       dmac_ack_o;         // Acknowledgement to dmac_req_i
  output                       fifo_rst_o;         // FIFO reset

  input                 [2:0]  pbl_i;              // PBL
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
  input                        biu_interrupt_i;    // BIU interrupt
  input                        int_enable_i;       // Interrupt Enable
  input                        fifo_empty_i;       // FIFO empty condition
  input                        send_ccsd_i;        // Send CCSD indication

  // Interface to 2clk_fifoctl
  input    [`F_DATA_WIDTH-1:0] dmac_fifo_rdata_i;  // FIFO Read Data in

  // Interface to DMAC Interface 
  output                       dmac_fifo_push_o;   // Push indication to FIFO
  output                       dmac_fifo_pop_o;    // Pop indication to FIFO
  output   [`F_DATA_WIDTH-1:0] dmac_fifo_wdata_o;  // FIFO Write Data Out 

  output                       dmac_biu_intr_o;    // Combined BIU and DMAC Intr

`ifdef M_ADDR_WIDTH_32
  output              [191:0]  dmac_debug_reg;     // Debug registers port
`else  //64-bit address bus
  output             [287:0] dmac_debug_reg;
`endif


  input                        scan_mode;          // Scan mode

  input                        enable_boot;        
  input                        alternative_boot_mode;
  input                        end_boot_i;
  input                        boot_ack_timeout;
  input                        boot_data_timeout;
 input                        biu_card_rd_thres_en;
                    

  // --------------------------------------
  // Wire Declaration
  // --------------------------------------

  //Output wires
  wire                       hreq_o;
  wire  [`M_ADDR_WIDTH-1:0]  haddr_o;
  wire                [1:0]  htrans_o;
  wire                       hwrite_o;
  wire                [2:0]  hsize_o;
  wire                [2:0]  hburst_o;
  wire  [`H_DATA_WIDTH-1:0]  hwdata_o;
  wire  [`H_DATA_WIDTH-1:0]  dmac_csr_rdata_o;
  wire                       dmac_csr_sel_o;
  wire                       dmac_ack_o;
  wire                       fifo_rst_o;
  wire                       dmac_fifo_push_o;
  wire                       dmac_fifo_pop_o;
  wire  [`F_DATA_WIDTH-1:0]  dmac_fifo_wdata_o;
  wire                       dmac_biu_intr_o;


  //Connecting wires
  wire                       hreq;
  wire  [`M_ADDR_WIDTH-1:0]  haddr;
  wire                [1:0]  htrans;
  wire                       hwrite;
  wire                [2:0]  hsize;
  wire                [2:0]  hburst;
  wire  [`H_DATA_WIDTH-1:0]  hwdata;
  wire  [`H_DATA_WIDTH-1:0]  dmac_csr_rdata;
  wire                       dmac_csr_sel;
  wire                       dmac_ack;
  wire                       dmac_fifo_push;
  wire                       dmac_fifo_pop;
  wire  [`F_DATA_WIDTH-1:0]  dmac_fifo_wdata;

  wire                       start_xfer;
  wire  [`M_ADDR_WIDTH-1:0]  addr;
  wire                       rd_wrn;
  wire                       xfer_size;
  wire                       csr_fixed_burst;
  wire                       fixed_burst;
  wire  [`H_DATA_WIDTH-1:0]  wdata;
  wire  [`H_DATA_WIDTH-1:0]  ahm_rdata;
  wire                       eod;
  wire                       ahm_rdata_push;
  wire                       ahm_wdata_pop;
  wire                       ahm_xfer_done;
  wire                       ahm_error;

  wire                [3:0]  fsm_state;
  wire                [2:0]  fbe_code;
  wire                       fbe;
  wire                       desc_unavail;
//wire                       dir_bit_err;
  wire                       rx_int;
  wire                       tx_int;
  wire  [`M_ADDR_WIDTH-1:0]  curr_desc_addr;
  wire  [`M_ADDR_WIDTH-1:0]  curr_buf_addr;
  wire                       fifo_rst_out;
  wire                       card_err_sumry;
  wire                       card_err_sumry_csr;
  wire                       update_status;

  wire                       dmac_en;
  wire                       swr_rst;
  wire                       poll_dmnd;
  wire  [`M_ADDR_WIDTH-1:0]  dsc_list_start_addr;
  wire                [4:0]  dsc_skp_len;
  wire                [7:0]  burst_cnt;

`ifdef M_ADDR_WIDTH_32
  wire             [191:0] dmac_debug_reg;
`else  //64-bit address bus
  wire             [287:0] dmac_debug_reg;
`endif

  wire                       dmac_intr;

  // Output assignments
  assign  hreq_o            = hreq;
  assign  haddr_o           = haddr;
  assign  htrans_o          = htrans;
  assign  hwrite_o          = hwrite;
  assign  hsize_o           = hsize;
  assign  hburst_o          = hburst;
  assign  hwdata_o          = hwdata;
  assign  dmac_csr_rdata_o  = dmac_csr_rdata;
  assign  dmac_csr_sel_o    = dmac_csr_sel;
  assign  dmac_ack_o        = dmac_ack;
  assign  fifo_rst_o        = fifo_rst_out;
  assign  dmac_fifo_push_o  = dmac_fifo_push;
  assign  dmac_fifo_pop_o   = dmac_fifo_pop;
  assign  dmac_fifo_wdata_o = dmac_fifo_wdata;
  assign  dmac_biu_intr_o   = (dmac_intr | biu_interrupt_i)
                              & int_enable_i;

  //AHM Instantiation
  DWC_mobile_storage_ahb_ahm
   U_DWC_mobile_storage_ahb_ahm 
    (
     .hclk_i                     (hclk_i),
     .hreset_n                   (hreset_n_i),
     .hgrant_i                   (hgrant_i),
     .hready_i                   (hready_i),
     .hresp_i                    (hresp_i),
     .hrdata_i                   (hrdata_i),
     .sca_data_endianness        (big_endian_i),
     .hreq_o                     (hreq),
     .haddr_o                    (haddr),
     .htrans_o                   (htrans),
     .hwrite_o                   (hwrite),
     .hsize_o                    (hsize),
     .hburst_o                   (hburst),
     .hwdata_o                   (hwdata),
     .mdc_start_xfer             (start_xfer),
     .mdc_addr                   (addr),
     .mdc_rd_wrn                 (rd_wrn),
     .mdc_burst_count            (burst_cnt),
     .mdc_xfer_size              (xfer_size),
     .mdc_fixed_burst            (fixed_burst),
     .mdc_wdata                  (wdata),
     .mdc_eof                    (eod),
     .ahm_rdata                  (ahm_rdata),
     .ahm_rdata_push             (ahm_rdata_push),
     .ahm_wdata_pop              (ahm_wdata_pop),
     .ahm_xfer_done              (ahm_xfer_done),
     .ahm_error                  (ahm_error),
     .scan_mode                  (scan_mode));

  //DMA CNTRL Instantiation
  DWC_mobile_storage_dmac_cntrl
   U_DWC_mobile_storage_dmac_cntrl
    (
     .fsm_state_o                (fsm_state),
     .fbe_code_o                 (fbe_code), 
     .fbe_o                      (fbe), 
     .desc_unavail_o             (desc_unavail), 
//   .dir_bit_err_o              (dir_bit_err),
     .rx_int_o                   (rx_int), 
     .tx_int_o                   (tx_int), 
     .curr_desc_addr_o           (curr_desc_addr), 
     .curr_buf_addr_o            (curr_buf_addr), 
     .start_xfer_o               (start_xfer),
     .addr_o                     (addr), 
     .rd_wrn_o                   (rd_wrn), 
     .burst_cnt_o                (burst_cnt), 
     .xfer_size_o                (xfer_size), 
     .wdata_o                    (wdata), 
     .eod_o                      (eod),
     .fixed_burst_o              (fixed_burst), 
     .dmac_fifo_push_o           (dmac_fifo_push), 
     .dmac_fifo_pop_o            (dmac_fifo_pop),
     .dmac_fifo_wdata_o          (dmac_fifo_wdata),
     .dmac_ack_o                 (dmac_ack), 
     .fifo_rst_o                 (fifo_rst_out),
     .card_err_sumry_o           (card_err_sumry), 
     .update_status_o            (update_status),
     .card_err_sumry_i           (card_err_sumry_csr),
     .clk                        (hclk_i),
     .reset_n                    (hreset_n_i),
     .dmac_en_i                  (dmac_en),
     .pbl_i                      (pbl_i), 
     .swr_rst_i                  (swr_rst), 
     .poll_dmnd_i                (poll_dmnd), 
     .dsc_list_start_i           (dsc_list_start_addr),
   .biu_card_rd_thres_en                   (biu_card_rd_thres_en),

     .csr_fixed_burst_i          (csr_fixed_burst),  
     .dsc_skp_len_i              (dsc_skp_len), 
     .ahm_wdata_pop_i            (ahm_wdata_pop), 
     .ahm_rdata_i                (ahm_rdata), 
     .ahm_rdata_push_i           (ahm_rdata_push), 
     .ahm_xfer_done_i            (ahm_xfer_done), 
     .ahm_error_i                (ahm_error), 
     .dmac_fifo_rdata_i          (dmac_fifo_rdata_i), 
     .dmac_req_i                 (dmac_req_i), 
     .new_cmd_i                  (new_cmd_i), 
     .data_expected_i            (data_expected_i), 
     .data_w_rn_i                (data_w_rn_i), 
     .abort_cmd_i                (abort_cmd_i), 
     .fifo_rst_i                 (fifo_rst_i), 
     .end_bit_err_i              (end_bit_err_i),
     .resp_tout_i                (resp_tout_i), 
     .resp_crc_err_i             (resp_crc_err_i), 
     .st_bit_err_i               (st_bit_err_i), 
     .data_rd_tout_i             (data_rd_tout_i), 
     .data_crc_err_i             (data_crc_err_i), 
     .resp_err_i                 (resp_err_i),
     .cmd_done_i                 (cmd_done_i),
     .dto_i                      (dto_i),
     .bytecnt_i                  (bytecnt_i),
     .fifo_empty_i               (fifo_empty_i),
     .send_ccsd_i                (send_ccsd_i),
     .scan_mode                  (scan_mode),
     .enable_boot                (enable_boot),        
     .alternative_boot_mode      (alternative_boot_mode),
     .end_boot_i                 (end_boot_i),
     .boot_ack_timeout           (boot_ack_timeout),
     .boot_data_timeout          (boot_data_timeout));

  //DMAC CSR instantiation
  DWC_mobile_storage_dmac_csr
   U_DWC_mobile_storage_dmac_csr 
    (
     .dmac_intr_o                (dmac_intr), 
     .dmac_csr_rdata_o           (dmac_csr_rdata), 
     .dmac_csr_sel_o             (dmac_csr_sel), 
     .dmac_en_o                  (dmac_en), 
     .fixed_burst_o              (csr_fixed_burst),
     .swr_rst_o                  (swr_rst), 
     .poll_dmnd_o                (poll_dmnd), 
     .dsc_list_start_o           (dsc_list_start_addr), 
     .dsc_skp_len_o              (dsc_skp_len), 
     .card_err_sumry_o           (card_err_sumry_csr),
     .dmac_debug_reg             (dmac_debug_reg),
     .clk                        (hclk_i), 
     .reset_n                    (hreset_n_i), 
     .dmac_csr_psel_i            (dmac_csr_psel_i), 
     .dmac_csr_penable_i         (dmac_csr_penable_i),
     .dmac_csr_paddr_i           (dmac_csr_paddr_i),
     .dmac_csr_pben_i            (dmac_csr_pben_i),
     .dmac_csr_pwrite_i          (dmac_csr_pwrite_i),
     .dmac_csr_wdata_i           (dmac_csr_wdata_i),
     .pbl_i                      (pbl_i),
     .fsm_state_i                (fsm_state),
     .fbe_code_i                 (fbe_code),
     .fbe_i                      (fbe),
     .desc_unavail_i             (desc_unavail),
//   .dir_bit_err_i              (dir_bit_err),
     .rx_int_i                   (rx_int),
     .tx_int_i                   (tx_int),
     .curr_desc_addr_i           (curr_desc_addr),
     .curr_buf_addr_i            (curr_buf_addr),
     .card_err_sumry_i           (card_err_sumry),
     .update_status_i            (update_status),
     .scan_mode                  (scan_mode));
 
endmodule // 

