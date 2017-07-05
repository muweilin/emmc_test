// ---------------------------------------------------------------------
//
//  ------------------------------------------------------------------------
//
//                    (C) COPYRIGHT 2005 - 2014 SYNOPSYS, INC.
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

// 
// Release version :  2.01a
// File Version     :        $Revision: #6 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_cmd_queue.v#6 $ 
//
// -------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2h_cmd_queue.v
// 
// Created     : Tues Dec 21 20:00:00 GMT 2004
// Description : Connects to the DWbb fifo control and the registers
//               Allows for a single or two clocks, selects fifo based on 
//               clocking
//               The AXI side pushes with the acmd_queue_wd_int
//   
//-----------------------------------------------------------------------------
`include "DW_axi_x2h_cc_constants.v"
module DW_axi_x2h_cmd_queue(/*AUTOARG*/
  // Outputs
  acmd_rdy_int_n, 
                            push_af, 
                            hcmd_queue_wd_int, 
                            hcmd_rdy_int_n, 
                            // Inputs
                            clk_axi, 
                            acmd_queue_wd_int, 
                            push_acmd_int_n, 
                            pop_hcmd_int_n, 
                            push_rst_n
                            );            // async reset
  // requires the following to be defined
//  X2H_CMD_QUEUE_WIDTH   total width of cmd queue word;
//  X2H_CMD_QUEUE_DEPTH   DEPTH of the FIFO

//  X2H_CLK_MODE          0 = Async Clocks implies FIFO with 2 or 3 push and pop sync 
//                        1 = Sync Clocks  imnplies FIFO with 1 push and pop sync
//                        2 = single clock implies a single clock fifo
    // if X2H_CLK_MODE=0 the following will be used
//  X2H_SYNC_MODE         number of clocks used in both the push and pop sections when asynchronous clocking     
  input                              clk_axi;
  input [`X2H_CMD_QUEUE_WIDTH-1:0]   acmd_queue_wd_int;    // consisting of all the inputs
  input                              push_acmd_int_n;
  output                             acmd_rdy_int_n;
  output                             push_af;
  
  input                              pop_hcmd_int_n;
  output [`X2H_CMD_QUEUE_WIDTH-1:0]  hcmd_queue_wd_int;
  output                             hcmd_rdy_int_n;

  input                              push_rst_n;
  
  reg                                we_n, acmd_rdy_int_n,hcmd_rdy_int_n;
  reg                                push_af;
  
  parameter DEPTH = `X2H_CMD_QUEUE_DEPTH;
  parameter FIFO_WIDTH = `X2H_CMD_QUEUE_WIDTH;

// push and pop syncs for dual clock systems.
// if the clocks are sync use 1 reg between domains
// if async use the constraint
// set up all the widths and depths assume here that the DEPTH cannot exceed 256
parameter COUNT_WIDTH           = `CMDQ_CW; //((DEPTH <= 2) ? 2 :(DEPTH <= 4) ? 3 :(DEPTH <= 8) ? 4 :(DEPTH <= 16) ? 5:(DEPTH <= 32) ? 6:(DEPTH <= 64) ? 7:(DEPTH <= 128) ? 8:9);
parameter DW_ADDR_WIDTH         = (COUNT_WIDTH-1);
   // if FIFO is  dual-clocked adjusting the RAM DEPTH for odd and non-power of 2 compatibility with the control
//parameter DW_EFFECTIVE_DEPTH_S1 = DEPTH;
//parameter DW_EFFECTIVE_DEPTH_S2 = `CMDQ_EFF_DEPTH_S2; // ((DEPTH == (1 << DW_ADDR_WIDTH))? DEPTH : DEPTH + ((DEPTH & 1) ? 1: 2));
parameter DW_EFFECTIVE_DEPTH = `CMDQ_EFF_DEPTH; //((`X2H_CLK_MODE==2) ? DW_EFFECTIVE_DEPTH_S1 : DW_EFFECTIVE_DEPTH_S2);

  reg [DW_ADDR_WIDTH-1:0] wr_addr,rd_addr;
  wire                      mem_rst_n;

  assign                    mem_rst_n = push_rst_n;
  parameter PUSH_AE_LVL = 2;
  parameter TST_MODE    = 0;       // scan test input not connected
  
  reg clk_push;

  wire [DW_ADDR_WIDTH-1:0]   s1_rd_addr; //Signal used only when X2H_CLK_MODE==2.
  wire [DW_ADDR_WIDTH-1:0]   s1_wr_addr; //Signal used only when X2H_CLK_MODE==2.
  wire                       s1_acmd_rdy_int_n; //Signal used only when X2H_CLK_MODE==2.
  wire                       s1_hcmd_rdy_int_n;
  wire                       s1_push_af;
  wire                       s1_we_n;
  reg                        s1_rst_n;
  wire [DW_ADDR_WIDTH-1:0]   af_thresh;
  wire [DW_ADDR_WIDTH-1:0]   ae_level;
  //leda NTL_CON16 off
  //LMD: Nets or cell pins should not be tied to logic 0 / logic 1
  //LJ: These signals take a constant value based on the configuration. 
 
  //leda B_3208 off
  //LMD: Unequal length LHS and RHS in assignment
  //LJ: This is the intended implementation.
  assign                     af_thresh = DW_EFFECTIVE_DEPTH-1;
  //leda B_3208 on
  assign                     ae_level = PUSH_AE_LVL;
  //leda NTL_CON16 on

  //leda NTL_CON13A off
  //LMD: non driving internal net
  //LJ: unused signals from the bcm06 module.
  wire                       almost_empty_unconn;
  wire                       half_full_unconn;
  wire                       error_unconn;
  wire [DW_ADDR_WIDTH-1:0]  wrd_count_unconn;
  wire                       nxt_empty_n_unconn;
  wire                       nxt_full_unconn;
  wire                       nxt_error_unconn;
  //leda NTL_CON13A on



// call fifo Controller
  DW_axi_x2h_bcm06
   #(DEPTH,TST_MODE, DW_ADDR_WIDTH)
      U_CMD_FIFO_CONTROL_S1(
                .clk(clk_axi),
                .rst_n(s1_rst_n),
                .init_n(1'b1),
                .full(s1_acmd_rdy_int_n),
                .empty(s1_hcmd_rdy_int_n),
                .af_thresh(af_thresh),                        
                .diag_n(1'b1),
                .ae_level(ae_level),
                .push_req_n(push_acmd_int_n),
                .pop_req_n(pop_hcmd_int_n),
                .we_n(s1_we_n),
                .almost_full(s1_push_af),                           
                .wr_addr(s1_wr_addr),
                .rd_addr(s1_rd_addr),
                .almost_empty(almost_empty_unconn),
                .half_full(half_full_unconn),
                .error(error_unconn),
                .wrd_count(wrd_count_unconn),
                .nxt_empty_n(nxt_empty_n_unconn),
                .nxt_full(nxt_full_unconn),
                .nxt_error(nxt_error_unconn)                         
                 );

  

  
  always @(*)
    begin:CLK_MODE_PROC
         s1_rst_n = push_rst_n; 
         // the RAM
         we_n = s1_we_n;
         rd_addr = s1_rd_addr;
         wr_addr = s1_wr_addr;          
          // going out
         acmd_rdy_int_n = s1_acmd_rdy_int_n;
         hcmd_rdy_int_n = s1_hcmd_rdy_int_n;
         push_af = s1_push_af;
          // clocking single clock use the axi
         clk_push = clk_axi;
    end // always @ (...
  //      
  // The RAM
  DW_axi_x2h_bcm57
   #(FIFO_WIDTH,DW_EFFECTIVE_DEPTH,0,DW_ADDR_WIDTH)
     U_CMD_FIFO_RAM(.init_n(1'b1),                    
                    .clk(clk_push),
                    .rst_n(mem_rst_n),
                    .wr_n(we_n),
                    .rd_addr(rd_addr),
                    .wr_addr(wr_addr),
                    .data_in(acmd_queue_wd_int),
                    .data_out(hcmd_queue_wd_int)
                      );
  
//`include "../../src/DW_axi_x2h_fifo_report.inc"

endmodule // comm_cmd_queue

