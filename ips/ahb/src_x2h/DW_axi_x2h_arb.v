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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_arb.v#7 $ 
//
// -------------------------------------------------------------------------
// Created     : Fri Jan 7 20:00:00 GMT 2005
// Description : AXI-to-AHB bridge arbritation on reads and writes.
//               Simple write leads read on first conflict then alternates
//               until no conflict.
//               Support for low-power
//               The readys to the AXI will be blocked during CSYSACK active
//               also the pushes to the fifos are disabled.
//   
//-----------------------------------------------------------------------------
`include "DW_axi_x2h_cc_constants.v"  

module DW_axi_x2h_arb (/*AUTOARG*/
  // Outputs
  wvalid_gtd, wready, awvalid_gtd, arvalid_gtd, awready, arready, 
  // Inputs
  aclk, aresetn, wvalid, 
  awvalid,
  arvalid, 
  wready_int, cmd_queue_rdy_n, cmd_push_af
  );
  input aclk;
  input aresetn;
  input wvalid;
  input awvalid;         // AXI write address valid
  input arvalid;         // AXI read address valid

  
  input wready_int;      // write data wready from the slave controller
  input cmd_queue_rdy_n; // cmd queue is ready for a push 
  input cmd_push_af;     // only one location in cmd queue is left
  
  output wvalid_gtd;     // will pass this on when arbritated
  output wready;         // ready to axi on a write
  output awvalid_gtd;    // to slave control for pushing fifo on when arbritated
  output arvalid_gtd;    // to slave control will pass this on when arbritated
  output awready;        // ready to axi on a write address
  output arready;        // ready to axi on a read address
                                                 
  reg [2:0]                               arb_state;
  reg [2:0]                               arb_next_state;
  reg awvalid_int; //arvalid_int;
  reg rdy_push, rdy_push_af;
  // using one hot here
parameter [2:0] IDLE        = 3'b000;
parameter [2:0] WREADY      = 3'b001;
parameter [2:0] RREADY      = 3'b010;
parameter [2:0] RREADY_PEND = 3'b100;

  // combinatoral
  always @(*)
    begin:RDY_PUSH_PROC
      awvalid_int = awvalid;
//      arvalid_int = arvalid;
      
  // Give the cmd queue status
  // push_rdy indicates that the CMD Queue has space available and
  // the low power is not about to go active
  // rdy_push_af is used when transitioning from a ready imeadiatly 
  // to the other ready
  // have to check to see if the fifo will have space after current ready
  // and have to check if the low-power ack is not going to be asserted
      rdy_push = ~cmd_queue_rdy_n;
      rdy_push_af = cmd_push_af;
    end // always @ (...

  assign awready = arb_state[0];
  assign arready = arb_state[1];

  // the gtd are the a_valids sent on to the bridge
  assign awvalid_gtd =awready;
  assign arvalid_gtd =arready; 

  // state machine for arbritating the write read conflict
  // machine will be activated only when a confilict arises
  // a write will go first then read
  // when the conflict doesn't exist the sm will go back to idle 
  // This will assure that if write(s) and reads(s) occur at the same cycle
  // the following will occur
  // 1) following inactivity, write then read
  // 2) continuing with read alternating with write
  // 3) No activity will return to write fist
  
  always @(arb_state or arvalid or awvalid or awvalid_int
           or rdy_push or rdy_push_af)
    begin:ARB_STATES_PROC
      arb_next_state = arb_state;   
        case(arb_state)
          IDLE: // Idle wvalid always first
             begin
              arb_next_state = IDLE;
              if (rdy_push == 1'b1)
                begin
                  if (awvalid == 1'b1)
                    arb_next_state = WREADY;
                  else
                    if (arvalid == 1'b1) 
                      arb_next_state = RREADY;
                    else
                      arb_next_state = arb_state;
                end
              end
           WREADY: // Issue WREADY if rvalid go on to issue rready
                    // since the cmd queue is being pushed check if almost full 
                    // then its about to fill then defer
              begin
                if (arvalid == 1'b1)
                  begin
                    if (rdy_push_af == 1'b0)
                      arb_next_state = RREADY;
                    else 
                      arb_next_state = RREADY_PEND;
                  end
                else arb_next_state = IDLE; //awready just issued so have to wait 
                                             // one clock before checking on write
              end // case: WREADY
         RREADY: // issue RREADY wvalid goes next first
                  // when here a push is going on, look at the almost full as the FIFO being filled
            begin
              if (awvalid_int == 1'b1)
                begin
                  if (rdy_push_af == 1'b0)  arb_next_state = WREADY;
                  else arb_next_state = IDLE;
                end
              else arb_next_state = IDLE; // have to wait for current rwready to go away
            end // case: RREADY
         RREADY_PEND:
            begin
              if (rdy_push == 1'b1)  arb_next_state = RREADY;
              else arb_next_state = RREADY_PEND;
            end  
          default: arb_next_state = IDLE;
        endcase // case(arb_state)
    end // block: ARB_STATES
       
 // Gate off any write data transfers when powered down
  assign wvalid_gtd =  wvalid;// && csysack;
  assign wready = wready_int;// && csysack;
//  assign wvalid_gtd =  wvalid && csysack;
//  assign wready = wready_int && csysack;
  
  //
  // FF's
  //        
  // leda NTL_CLK05 off
  // LMD: All synchronous inputs to a clock system must be clocked twice. 
  // LJ: NTL_CLK05: Data must be registered by 2 or more flipflops when crossing
  // clock domain path from rlast in read data fifo to here when legacy low power
  // interface exists. Path is only active when fifo is non empty.
  always @(posedge aclk or negedge aresetn)
    if (aresetn == 1'b0)
      begin
        arb_state <= IDLE;
       end
    else
      begin
        arb_state <= arb_next_state;
      end
  // leda NTL_CLK05 on
  
endmodule







