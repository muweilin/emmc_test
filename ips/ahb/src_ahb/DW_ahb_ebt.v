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
-- File :                       DW_ahb_ebt.v
-- Author:                      Ray Beechinor, Peter Gillen 
-- Date :                       $Date: 2011/09/14 $ 
-- Version      :               $Revision: #3 $ 
-- Abstract     :
--
-- Each time a new transfer begins on the bus, an internal counter is
-- loaded and decremented until either a new transfer begins or if the
-- count reaches 0 an interrupt is set indicating that a burst has been
-- terminated early. The set_ebt is used by the grant control to end
-- the burst and currently uses hready active when set_ebt is active to
-- end the burst.
--
*/
`include "DW_amba_constants.v" 
`include "DW_ahb_cc_constants.v"
`include "DW_ahb_constants.v"
module DW_ahb_ebt (
  hclk,
  hresetn,
  hready,
  ebtcount,
  ebten,
  clr_arbint,
  new_tfr,
  ltip,
  grant_changed,

  ahbarbint,
  set_ebt
);

  input       hclk;
  input       hresetn;
  input       hready;
// Value loaded, which is the maximum number of cycles a transfer is
// allowed to take before the burst is terminated
  input [9:0] ebtcount;
// When active, transfers can be terminated early
  input       ebten;
// The interrupt is cleared when a read to the terminated address
// location is performed
  input       clr_arbint;
// An idle or nonseq cycle is on the bus, indicating that a new burst 
// is beginning, the maximum number of cycles a transfer can take is
// therefore loaded into the internal counter
  input       new_tfr;
// Locked transfer in progress. Do not terminate
  input       ltip;
// Grant changed
  input       grant_changed;
// The internal count has timed-out and the master is told via interrupt
  output      ahbarbint;
// Whenever the count, times out the burst is ended and the interrupt
// from a previous burst could be still pending but the current burst
// still needs to be terminated. Used to force the bc_next value to 0
// to terminate the count
  output      set_ebt;            

  parameter I = 2'b00;
  parameter C = 2'b01;
  parameter T = 2'b11;

//
// Internal counter which is loaded with the maximum number of hclk
// cycles a burst is allowed to take each time a new transfer is
// started on the bus.
//
  reg  [9:0]  int_count;
  wire [9:0]  count;
//
// Interrupt signal that a burst has been terminated early.
//
  reg         int_ahbarbint;
//
// Combinatorial set_ebt. When one enters the T-state provided the
// early burst termination functionality is enabled then this signal
// is set causing set_ebt to be active.
//
  reg         comb_set_ebt;
//
// Register set_ebt. set_ebt is used when hready is active so the
// combinatorial set_ebt is registered if hready is low, extending
// the pulse. If hready is high then this signal is cleared.
//
  reg          int_reg_set_ebt;
  wire         reg_set_ebt;
      
  reg  [1:0]   int_current_state;   
  wire [1:0]   current_state;   
  reg  [1:0]   next_state;   


  always @ (posedge hclk or negedge hresetn)
  begin : stateMachine_PROC
    if (hresetn == 1'b0)
      int_current_state <= I;
    else
      int_current_state <= next_state;
  end
  assign current_state = (`EBTEN == 1'b1) ? int_current_state : I;

//
// Whenever early burst termination functionality is not enabled, the
// state machine remains in I-state. Early burst termination must be
// enabled and a new transfer burst must begin on the bus. A new 
// transfer is also an IDLE transfer or an INCR burst of unspecified
// length. Each time a new transfer begins the counter is loaded with
// the maximum number of allowed cycles. While the burst is running the
// counter is decremented for each cycle it takes, until it reaches 1
// where is causes the state machine to move from the C-state to the 
// T-state. Whenever in the T-state the current transfer needs to be
// terminated. If a new transfer begins one returns to the C-state to
// begin counting down again.
//

  always @ (current_state or
             ebten         or
             new_tfr       or
             count)
  begin : next_state_PROC
    case (current_state) 
      I :
        begin
          if ((ebten == 1'b1) && (new_tfr == 1'b1)) begin
            next_state = C;
          end else begin
            next_state = I;
          end
        end
           
      C :
        begin
          if (ebten == 1'b1) begin
            if (new_tfr == 1'b1) begin
              next_state = C;
            end else begin
              if (count == 10'b0000000001) begin
                next_state = T;
              end else begin
                next_state = C;
              end
            end
          end else begin
            next_state = I;
          end
        end

      T :
        begin
          if (ebten == 1'b1) begin
            if (new_tfr == 1'b1)
              next_state = C;
            else
              next_state = I;
          end else begin
            next_state = I;
          end
        end

        default : next_state = I;
      endcase
   end

//
// Each time a new transfer begins this counter is loaded with the 
// maximum number of cycles that are allowed for a burst. Then the
// counter counts down. When it reaches 1 the state machine moves
// from C-state to T-state causing the interrupt to be set that
// EBT should be terminated.
//
  always @ (posedge hclk or negedge hresetn)
  begin : count_PROC
    if (hresetn == 1'b0) begin
      int_count <= 10'b0;
    end else begin 
      if (current_state == T) begin
        int_count <= ebtcount;
      end else begin
        if (new_tfr == 1'b1) begin
          int_count <= ebtcount;
        end else begin
	  // leda W631 off
	  // W631: Assigning to self. This is harmless but can reduce
	  // simulation speed
          if (int_count == 10'b0) begin
            int_count <= int_count;
          end else begin
            int_count <= int_count - 10'b1;
          end
	  // leda W631 on
        end
      end
    end
  end
  assign count = (`EBTEN == 1'b1) ? int_count : 10'b0;

//
// If early burst termination functionality is not enabled then the
// interrupt from EBT is disabled. Whenever the count reaches 1 the
// state machine moves to T-state for at least 1-cycle when the count
// will be 0, thus setting the interrupt. The interrupt is only 
// cleared by reading the clear interrup location with the ahb_arbif
// register space. The interrupt bit could be set previously and was
// not serviced but this is a system design problem.
//
  always @ (posedge hclk or negedge hresetn)
  begin : ahbarbint_PROC
    if (hresetn == 1'b0) begin
      int_ahbarbint <= 1'b0;
    end else begin
      if (ebten == 1'b0) begin
        int_ahbarbint <= 1'b0;
      end else begin
        if ((set_ebt == 1'b1) && (hready == 1'b1) && (ltip == 1'b0) && (grant_changed == 1'b0)) begin
          int_ahbarbint <= 1'b1;
        end else begin
          if (clr_arbint == 1'b1) begin
            int_ahbarbint <= 1'b0;
          end
        end
      end
    end
  end
  assign ahbarbint = (`EBTEN == 1'b1) ? int_ahbarbint : 1'b0;

//
// One is only with the T-state for 1 cycle and whenever one is there
// then provided the early burst termination functionality is enabled
// then a pulse is generated on set_ebt. comb_set_ebt is one part of
// the set_ebt or.
//
  always @ (current_state or ebten)
  begin : comb_set_ebt_PROC
    if (current_state == T) begin
      comb_set_ebt = ebten;                
    end else begin
      comb_set_ebt = 1'b0;
    end
  end

//
// If hready is stalling a master by being low, then because the state
// machine will have moved from the T-state, the comb_set_ebt pulse
// needs to be registered and extended until it is valid when hready
// becomes active. Then it is cleared. If when comb_set_ebt is high and
// hready is also active then reg_set_ebt is not set as the comb_set_ebt
// pulse is used within the grant control design to terminate the burst.
//
  always @ (posedge hclk or negedge hresetn)
  begin : reg_set_ebt_PROC
    if (hresetn == 1'b0) begin
      int_reg_set_ebt <= 1'b0;
    end else begin
      if (ebten == 1'b1) begin
        if (hready == 1'b0) begin
          if (comb_set_ebt == 1'b1) begin
            int_reg_set_ebt <= 1'b1;
          end
        end else begin
          int_reg_set_ebt <= 1'b0;
        end
      end else begin
        int_reg_set_ebt <= 1'b0;
      end
    end
  end
  assign reg_set_ebt = (`EBTEN == 1'b1) ? int_reg_set_ebt : 1'b0;

//
// set_ebt is required when hready is a 1, need to extend the 
// comb_set_ebt with reg_set_ebt whenever this is the case.
//   
   assign set_ebt = comb_set_ebt | reg_set_ebt;
   
   
endmodule
