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
// File Version     :        $Revision: #7 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_slave.v#7 $ 
//
// -------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2h_slave.v
// Created     : Thurs Dec 23 15:00:00 GMT 2004
// Description : AXI Slave
//               Top Level of the AXI Slave controls
//               
//----------------------------------------------------------------------------


/*********************************************************************/
/*                                                                   */
/*                  AXI_SLAVE module                                 */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

`include "DW_axi_x2h_cc_constants.v"
module DW_axi_x2h_slave(/*AUTOARG*/
  // Outputs
//  awready, 
  wready, 
                        bid, 
                        bresp, 
                        bvalid,
                        cmd_queue_wd, 
                        push_cmd_queue_n, 
                        pop_resp_n, 
                        write_buffer_wd, 
                        push_write_buffer_n, 
                        rid, 
                        rdata, 
                        rresp, 
                        rlast, 
                        rvalid, 
                        //  arready,
                        pop_data_int_n, 
                        // Inputs
                        awid, 
                        awaddr, 
                        awlen, 
                        awsize, 
                        awburst, 
                        awlock, 
                        awcache, 
                        awprot, 
                        awvalid, 
                        //  `ifdef X2H_AXI3_INTERFACE
                        //  wid, 
                        //  `endif
                        wdata, 
                        wstrb, 
                        wlast, 
                        wvalid, 
                        bready, 
                        cmd_queue_rdy_n, 
                        response_avail_n, 
                        pop_resp_word, 
                        write_buff_rdy_n, 
                        arid, 
                        araddr, 
                        arlen, 
                        arsize, 
                        arburst, 
                        arlock, 
                        arcache, 
                        arprot, 
                        arvalid, 
                        rready, 
                        arstatus_int, 
                        arid_int, 
                        arlast_int, 
                        ardata_int, 
                        arvalid_int_n
                        );
 
  // Signals user for the AXI master reading refer to sec 2.5
  //   AMBA AXI Protocol v1.0 from ARM              
  input [`X2H_AXI_ID_WIDTH-1:0]            awid;    // id to slave
  input [`X2H_AXI_ADDR_WIDTH-1:0]          awaddr;
  input [`X2H_AXI_BLW-1:0]                 awlen;
  input [2:0]                              awsize;
  input [1:0]                              awburst;
  input [`X2H_AXI_LTW-1:0]                 awlock;
  input [1:0]                              awcache;
  input [1:0]                              awprot;
  input                                    awvalid;
//  output                                   awready;
//  `ifdef X2H_AXI3_INTERFACE
//  input [`X2H_AXI_ID_WIDTH-1:0]            wid;
//  `endif
  input [`X2H_AXI_DATA_WIDTH-1:0]          wdata;
  input [`X2H_AXI_WSTRB_WIDTH-1:0]         wstrb;
  input                                    wlast;
  input                                    wvalid;
 
  output                                   wready;
  output [`X2H_AXI_ID_WIDTH-1:0]           bid;
  output [1:0]                             bresp;
  output                                   bvalid;
  input                                    bready;

   
  // these are used for the command queue
  output [`X2H_CMD_QUEUE_WIDTH-1:0] cmd_queue_wd;
  output                            push_cmd_queue_n;
  input                             cmd_queue_rdy_n;
  //  the response buffer
  input                          response_avail_n;
  input [`X2H_AXI_ID_WIDTH+1:0]  pop_resp_word;   // ID plus two bit status
  output                         pop_resp_n;
 
  //the write buffer
  output [`X2H_AXI_WDFIFO_WIDTH-1:0] write_buffer_wd;  // include the WSTRB and LAST
  output                             push_write_buffer_n;
  input                              write_buff_rdy_n;
  
  input [`X2H_AXI_ID_WIDTH-1:0]    arid;    // id to slave
  input [`X2H_AXI_ADDR_WIDTH-1:0]  araddr;  
  input [`X2H_AXI_BLW-1:0]         arlen;
  input [2:0]                      arsize;
  input [1:0]                      arburst;
  input [`X2H_AXI_LTW-1:0]         arlock;
  input [1:0]                      arcache;
  input [1:0]                      arprot;
  input                            arvalid;
  input                            rready;   // ready to accept read data
  
  /* signals returned from the slave */
  output [`X2H_AXI_ID_WIDTH-1:0]    rid;
  output [`X2H_AXI_DATA_WIDTH-1:0]  rdata;
  output [1:0]                      rresp;
  output                            rlast;
  output                            rvalid; 
//  output                            arready;

 // the read data fifo
  input [1:0]                      arstatus_int;
  input [`X2H_AXI_ID_WIDTH-1:0]    arid_int;
  input                            arlast_int;
  input [`X2H_AXI_DATA_WIDTH-1:0]  ardata_int;
  output                           pop_data_int_n;
  input                            arvalid_int_n;

  
  reg                               push_cmd_queue_n;
  reg    [`X2H_CMD_QUEUE_WIDTH-1:0] cmd_queue_wd;
  wire [`X2H_AXI_ID_WIDTH-1:0]     bid;
  wire [1:0]                       bresp;  
  wire [`X2H_AXI_WDFIFO_WIDTH-1:0] write_buffer_wd;  // include the WSTRB and LAST

  // write cmd queue
  wire  [`X2H_CMD_QUEUE_WIDTH-1:0]  wr_cmd_queue_wd, rd_cmd_queue_wd;
  // Write address and read address channel locks
  wire [1:0] awlock_c;
  wire [1:0] arlock_c;
  wire       wr_push_comm_cmd_q_n;
  wire       rd_push_comm_cmd_q_n;

//-------------------------------------------------------------------------
//         Lock signals for Write and Read address channels
//If AXI3 passes the same lock signal from primary port
//If AXI4 concatenate MSB bit as '0' to make compatible with 
// with AXI4 Lock specification
//--------------------------------------------------------------------------

  //leda NTL_CON16 off
  //LMD: Nets or cell pins should not be tied to logic 0 / logic 1
  //LJ: In case of AXI4 interface the MSB of the lock_c signals are tied to zero to make it compatible with AXI4 lock specification.
    assign awlock_c = {1'b0,awlock};
    assign arlock_c = {1'b0,arlock};
  //leda NTL_CON16 on
//----------------------------------------------------------------------------- 
//                  The RESPONSE for writes                       
// passes the responses from the response buffer to the AXI       
// and the Write Data Buffer                                      
//-----------------------------------------------------------------------------
  
  // Issuing the response
  // loop on the Response Buffer upon seeing it not empty 
  // pass on the ID and error code. Keep poping until empty
  // hold the bvalid and response until bready

  // set up so all the outputs are registered out of the fifo
  assign bvalid =  (response_avail_n == 1'b0);
  assign bresp = pop_resp_word[`X2H_AXI_ID_WIDTH+1:`X2H_AXI_ID_WIDTH];
  assign bid   = pop_resp_word[`X2H_AXI_ID_WIDTH-1:0];
  assign pop_resp_n = ~((response_avail_n == 1'b0) && (bready == 1'b1));

//-----------------------------------------------------------------------------
// 
//               AXI Slave Write Control
//               Controls for writting. Pushing the command queue
//               and pushing data fromthe AXI-W into the write data buffer
//-----------------------------------------------------------------------------     


  //           command queue operations
  // send the the AWREADY if the
  // command queue is ready, as soon as the AWVALID shows up 
 
  assign wr_push_comm_cmd_q_n = ~((cmd_queue_rdy_n == 1'b0) && (awvalid == 1'b1));
  //leda NTL_CON16 off
  //LMD: Nets or cell pins should not be tied to logic 0 / logic 1
  //LJ: LSB of the write cmd_q is always 1'b1.
  assign wr_cmd_queue_wd = {awaddr[`X2H_CMD_ADDR_WIDTH-1:0],awid,awlen,awsize,awburst,awlock_c,
                            awcache[1:0],awprot[1],awprot[0],1'b1};
  //leda NTL_CON16 on
//  assign awready = ~cmd_queue_rdy_n;

  // select which is to go to the command queue
  // the push commands come from the external arbritation
  always @(*)
    begin:SLAVE_CMD_Q_PROC
    /* this will be used to arb the pushes from read and write */
    /* there will be no conflicts between read and write */
      push_cmd_queue_n = wr_push_comm_cmd_q_n & rd_push_comm_cmd_q_n;
      if ( rd_push_comm_cmd_q_n != 1) cmd_queue_wd = rd_cmd_queue_wd;
      else cmd_queue_wd = wr_cmd_queue_wd;
    end  

  //           write data buffer
  // push the write data buffer anytime the AXI is writting and
  // the write data buffer is not full
  assign push_write_buffer_n = ~((write_buff_rdy_n == 1'b0) && (wvalid == 1'b1));
  assign write_buffer_wd = {wdata,wstrb,wlast};
  assign wready = ~write_buff_rdy_n;
    
//-----------------------------------------------------------------------------
// 
//              AXI Slave Read Controls
//                                                                  
//              Two independent operations:                                       
//                  1) Push Commands                                                  
//                     Monitor the AXI for a read operation. Upon sensing ARVALID    
//                     push the command queue and return ARREADY                      
//                  2) Monitor the Read Data Buffer and as long as it is not empty    
//                     pop its contents and present it to the AXI                      
//
//-----------------------------------------------------------------------------

//
//         Pushing the command queue
//
// push the command queue whenever the AXI-R comes
// if the command queue is available
// as soon as the ARVALID shows up send the the ARREADY 
  assign rd_push_comm_cmd_q_n = ~((cmd_queue_rdy_n == 1'b0) && (arvalid == 1'b1));
  //leda NTL_CON16 off
  //LMD: Nets or cell pins should not be tied to logic 0 / logic 1
  //LJ: LSB of the read cmd_q is always 1'b0.
  assign rd_cmd_queue_wd = {araddr[`X2H_CMD_ADDR_WIDTH-1:0],arid,arlen,arsize,arburst,arlock_c,
                            arcache[1:0],arprot[1],arprot[0],1'b0};
  //leda NTL_CON16 on
//  assign arready = ~cmd_queue_rdy_n;
  
//
//   The Read DATA Buffer 
//   as long as the read buffer contains anything keep popping it
//   and putting the contents out to the AXI
// 

  // As long as there is something in the Read Data Buffer issue RVALID
  assign rvalid = ~arvalid_int_n;
  // Pop the Read Data Buffer when its not empty and the AXI has issued RREADY
  assign pop_data_int_n = ~((rready == 1'b1) && (arvalid_int_n == 1'b0));
  
  assign rdata = ardata_int;
  assign rid = arid_int;
  assign rresp = arstatus_int;
  assign rlast = arlast_int;

endmodule // DW_axi_x2h_slave

