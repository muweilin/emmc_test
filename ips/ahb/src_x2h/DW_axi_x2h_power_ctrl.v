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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_power_ctrl.v#6 $ 
//
// -------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2h_power_ctrl
// Created     : Fri Jan 1, 2005  16:30:00 GMT
// Description : AXI-to-AHB bridge power control.
//               Constantly keeps a count (up to 15) of outstanding write and
//               read transactions. If a low power request comes, it will not
//               be honored until all outstanding transactions complete
//             
//-----------------------------------------------------------------------------
  
`include "DW_axi_x2h_cc_constants.v"
module DW_axi_x2h_power_ctrl (/*AUTOARG*/
  // Outputs
  cactive, csysack, csysack_ns, 
  // Inputs
  aclk, aresetn, bready, bvalid, rvalid, rready, rlast, 
  rd_push_cmd_queue_n, wr_push_cmd_queue_n, csysreq
  );

  input aclk;
  input aresetn;
  input bready;              // master is ready for end of a write transfer 
  input bvalid;              // end of the slaves write transfer
  input rvalid;              // slave indicating read data
  input rready;              // AXI master is accepting the read data
  input rlast;               // indication to AXI master that this is the last data
  input rd_push_cmd_queue_n; // pushing a read to the AHB slave side
  input wr_push_cmd_queue_n; // pushing a write to the AHB slave side
  input csysreq;             // request from AXI for a low-power ack
  output cactive;            // indicates that this device can do a low-power
  output csysack;            // acknowledge that this device is inactive 
                             // and ready for the clk to be removed
  output csysack_ns;         // unregistered
  
  wire csysreq_local_ns;
  reg  csysreq_local;
  wire cactive_int;

  wire aresetn_int;
  wire bready_int;
  wire bvalid_int;
  wire rvalid_int;
  wire rready_int;
  wire rlast_int;
  wire rd_push_cmd_queue_n_int;
  wire wr_push_cmd_queue_n_int;
  wire csysreq_int;
  assign aresetn_int = `X2H_AXI_LOW_POWER ? aresetn : 1'b0;
  assign bready_int  = `X2H_AXI_LOW_POWER ? bready : 1'b0;
  assign bvalid_int  = `X2H_AXI_LOW_POWER ? bvalid : 1'b0;
  assign rvalid_int  = `X2H_AXI_LOW_POWER ? rvalid : 1'b0;
  assign rready_int  = `X2H_AXI_LOW_POWER ? rready : 1'b0;
  assign rlast_int   = `X2H_AXI_LOW_POWER ? rlast : 1'b0;
  assign rd_push_cmd_queue_n_int = `X2H_AXI_LOW_POWER ? rd_push_cmd_queue_n : 1'b1;
  assign wr_push_cmd_queue_n_int = `X2H_AXI_LOW_POWER ? wr_push_cmd_queue_n : 1'b1;
  assign csysreq_int    = `X2H_AXI_LOW_POWER ? csysreq : 1'b1;

  reg  csysack_lth;
  
  //
  //               Power control
  //
  // Monitor all operations for completion
 
  // the transaction counts (read and write are seperate counts) are 
  // limited to 127 each. Since the maximum allowed cmd buffer depth is 32
  // this assures a count of the outstanding reads and writes will not 
  // overflow the counts. 
  
  parameter DW_CONT_MSB = 6; //`define DW_cont_msb 6 
  
  reg [DW_CONT_MSB:0]                    ativ_writes_ns, ativ_reads_ns;
  reg [DW_CONT_MSB:0]                    ativ_writes, ativ_reads;
  
  wire axi_slave_active_ns;  
  
  assign cactive_int = cactive;
  
  //leda W484 off
  //LMD:Possible loss of carry/borrow in addition/subtraction
  //LJ: Under/Over-flow will never happen functionally.

  // count of outstanding writes
  // increment count when pushing a write on the command queue
  // decrement count when bvaild response is reconized with bready
  always @(*)
    begin: ACTIVE_CNTS_PROC
      ativ_writes_ns = ativ_writes;
      case ({wr_push_cmd_queue_n_int,bvalid_int,bready_int})
        3'b000, 3'b001, 3'b010: begin 
        // pushing the cmd queue and no response
          ativ_writes_ns = ativ_writes + 1;
        end
        3'b111: begin 
        // responding and no push this is for cases where BREADY is held on
          ativ_writes_ns = ativ_writes - 1;
        end
        default: begin 
        // all others do nothing to the count
          ativ_writes_ns = ativ_writes;
        end
      endcase // case({wr_push_cmd_queue_n,BVALID,BREADY})
      
  // count of outstanding reads
  // increment on push to command queue
  // decrement when read responds with last
      case ({rd_push_cmd_queue_n_int,rvalid_int,rready_int,rlast_int})
        4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110:  begin  
          // pushing 
          ativ_reads_ns = ativ_reads + 1;
          
        end                         
        4'b1111: begin
          // No new AXI read ( no push on cmd queue)
          //last read response only                            
            ativ_reads_ns = ativ_reads - 1;
        end
        default: begin // anything else is a noop
          ativ_reads_ns = ativ_reads;
        end
      endcase // case({rd_push_cmd_queue_n,RVALID,RREADY,RLAST})
    end // block: ACTIVE_CNTS
  //leda W484 on
                
  // if either writes or reads have not completed the AXI Slave is active 
  assign  axi_slave_active_ns = ((ativ_writes_ns != 0) || (ativ_reads_ns != 0));

  assign  csysreq_local_ns = csysreq_int;

  // outputs base on the low power option being set
  assign  cactive    = `X2H_AXI_LOW_POWER ? csysreq_local : 1'b1;

  wire tmp_val;
  assign tmp_val = ~((axi_slave_active_ns == 1'b0) && (cactive_int == 1'b0));
  assign csysack_ns = `X2H_AXI_LOW_POWER ? tmp_val : 1'b1;  
  assign  csysack    = `X2H_AXI_LOW_POWER ? csysack_lth : 1'b1;
  
  // leda NTL_CLK05 off
  // LMD: All synchronous inputs to a clock system must be clocked twice.
  // LJ: NTL_CLK05: Data must be registered by 2 or more flipflops when crossing clock domain
  // path from read data fifo to csysack_lth , rlast from rdata fifo used
  // in path. Data from fifo is only used when fifo is not empty, and empty
  // signal is synchronised.
  always @(posedge aclk or negedge aresetn_int)
    if (aresetn_int == 1'b0)
      begin
        csysack_lth <= 1'b1;
        ativ_writes <= {(DW_CONT_MSB+1){1'b0}};
        ativ_reads <= {(DW_CONT_MSB+1){1'b0}}; 
        csysreq_local <= 1'b1; 
      end
    else
      begin
        csysack_lth <=  csysack_ns;
        ativ_writes <= ativ_writes_ns ;
        ativ_reads <= ativ_reads_ns;
        csysreq_local <=  csysreq_local_ns;
      end // else: !if(aresetn_int == 1'b0)
  // leda NTL_CLK05 on

endmodule // DW_axi_x2h_power_ctrl

