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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_miu_refctl.v $ 
// $Revision: #3 $
//
// Abstract  : This subblock provides, every t_ref clock cycles, a request to
// the SDRAM Control State Machine to trigger a refresh cycle
//
//============================================================================
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module  DW_memctl_miu_refctl
  (
  clk,                  
  hresetn,                
  auto_refresh_en,      
  ref_ack,   
  t_ref,                 
  ref_req              
  );  

  // inputs
  input        clk;              // System Clock
  input        hresetn;          // System reset signal
  input        auto_refresh_en;  // enables the auto refresh mode         
  input        ref_ack;          // refresh acknoledgement from control logic
  input [15:0] t_ref;            // number of clock cycles between refresh
  
  // output
  output       ref_req;           // refresh request
  
  // internal reg/wire declarations
  reg 	       ref_req;
  reg [1:0]    current_state;
  reg [1:0]    next_state;
  reg [15:0]   count;
  reg [15:0]   count_next;
  reg 	       ref_req_next;
  
  wire [15:0]  t_ref_md; 
  
  parameter    
	       IDLE_STATE = 0,
	       INC_COUNT  = 1,
	       WAIT_ACK   = 2;
  
  
  assign       t_ref_md = t_ref;

  // ------------------------------------------------------------------------
  //  combinational process calculates next state
  // ------------------------------------------------------------------------

  always @ (current_state or auto_refresh_en or ref_ack or count or 
            t_ref_md)
    begin: COMBO_PROC
      case (current_state) 
        IDLE_STATE : begin
          count_next 	 = 0;
          ref_req_next 	 = 1'b0;
          if (auto_refresh_en)
            begin
              next_state = INC_COUNT;
            end
          else
            next_state   = IDLE_STATE; 
        end
  
        INC_COUNT : begin
          if (auto_refresh_en == 1'b0)
            begin
              next_state     = IDLE_STATE;
              count_next     = 0;
              ref_req_next   = 0;
            end
          else
            begin
            if (count == t_ref_md-1)
              begin
	              count_next     = 0;
                ref_req_next   = 1'b1;
                next_state     = WAIT_ACK;
              end
            else 
              begin
		            count_next     = count + 1;
                ref_req_next   = 1'b0;
                next_state     = INC_COUNT;
              end
            end  
        end
    
        default : begin
          if (auto_refresh_en == 1'b0)
            begin
              count_next     = 0;
              ref_req_next   = 1'b0;
              next_state     = IDLE_STATE;
            end
          else
            begin      
            if ((ref_ack) && (count < t_ref_md-1))
              begin
                ref_req_next   = 0;
                count_next     = count + 1;
                next_state     = INC_COUNT;          
              end
            else
              begin
		            count_next     = count + 1;    
                ref_req_next   = 1'b1;
                next_state     = WAIT_ACK;
              end
            end      
        end
      endcase
  end // COMBO_PROC


  //
  //  synchronous process updates current state
  //

  always @ (posedge clk or negedge hresetn)
    begin : SYNC_PROC
      if(hresetn == 1'b0)
        begin
          current_state <= IDLE_STATE;
          count         <= 0;
          ref_req       <= 0;
        end
      else
        begin
          current_state <= next_state;
          count         <= count_next;
          ref_req       <= ref_req_next;
        end
    end // SYNC_PROC  

endmodule
