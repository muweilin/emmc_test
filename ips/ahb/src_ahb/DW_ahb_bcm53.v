
////////////////////////////////////////////////////////////////////////////////
//
//                  (C) COPYRIGHT 2004 - 2011 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
//  This software and the associated documentation are confidential and
//  proprietary to Synopsys, Inc.  Your use or disclosure of this
//  software is subject to the terms and conditions of a written
//  license agreement between you, or your company, and Synopsys, Inc.
//
//  The entire notice above must be reproduced on all authorized copies.
//
// Filename    : DW_ahb_bcm53.v
// Author      : James Feagans     May 20, 2004
// Description : DW_ahb_bcm53.v Verilog module for DWbb
//
// DesignWare IP ID: 3814c4fd
//
////////////////////////////////////////////////////////////////////////////////


`include "DW_amba_constants.v" 
`include "DW_ahb_cc_constants.v"
`include "DW_ahb_constants.v"

  module DW_ahb_bcm53 (
	clk,
	rst_n,
	init_n,
	enable,
	request,
	prior,
	lock,
	mask,
       
	parked,
	granted,
	locked,
	grant,
	grant_index
);

                          
  parameter N           = 4;  // RANGE 2 TO 32
  parameter P_WIDTH     = 2;  // RANGE 1 TO 5
  parameter PARK_MODE   = 1;  // RANGE 0 OR 1
  parameter PARK_INDEX  = 0;  // RANGE 0 TO 31
  parameter OUTPUT_MODE = 1;  // RANGE 0 OR 1
  parameter INDEX_WIDTH = 2;  // RANGE 1 to 5


  input				clk;	 // Clock input
  input				rst_n;	 // active low reset
  input				init_n;	 // active low reset
  input				enable;	 // active high register enable
  input  [N-1: 0]		request; // client request bus
  input  [P_WIDTH*N-1: 0]	prior;	 // client priority bus
  input  [N-1: 0]		lock;	 // client lock bus
  input  [N-1: 0]		mask;	 // client mask bus
  
  output			parked;	 // arbiter parked status flag
  output			granted; // arbiter granted status flag
  output			locked;	 // arbiter locked status flag
  output [N-1: 0]		grant;	 // one-hot client grant bus
  output [INDEX_WIDTH-1: 0]	grant_index; //	 index of current granted client


  reg [1:0] current_state, next_state;
  wire [1:0] st_vec;

  wire   [N-1: 0] next_grant;
  wire   [INDEX_WIDTH-1: 0] next_grant_index;
  wire   next_parked, next_granted, next_locked;

  reg    [N-1: 0] grant_int;
  reg    [INDEX_WIDTH-1: 0] grant_index_int;
  reg    parked_int, granted_int, locked_int;

  reg    [INDEX_WIDTH-1: 0] temp_prior, temp2_prior;

  wire   [(P_WIDTH+INDEX_WIDTH+1)-1: 0] maxp1_priority;
  wire   [INDEX_WIDTH-1: 0] max_prior;
  wire   [N-1: 0] masked_req;
  wire   active_request;

  reg [7:0] i1, j1, k1, l1, i2, j2, k2, i3, l3;


  reg    [(N*INDEX_WIDTH)-1: 0] int_priority;

  reg    [(N*INDEX_WIDTH)-1: 0] decr_prior;

  reg    [(N*(P_WIDTH+INDEX_WIDTH+1))-1: 0] priority_vec;

  reg    [(N*(P_WIDTH+INDEX_WIDTH+1))-1: 0] muxed_pri_vec;

  reg    [(N*INDEX_WIDTH)-1: 0] next_prior;

  wire   [INDEX_WIDTH-1: 0] current_index;
  wire [P_WIDTH+INDEX_WIDTH:00] current_value;                 

  wire   [N-1: 0] temp_gnt;

  wire   [N-1: 0] p_index, p_index_temp;

  assign maxp1_priority = {P_WIDTH+INDEX_WIDTH+1{1'b1}};
  assign max_prior = {INDEX_WIDTH{1'b1}};

  assign masked_req = request & ~mask;

  assign active_request = |masked_req;

  assign next_locked = |(grant_int & lock);

  assign next_granted = next_locked | active_request;

  assign next_parked = ~next_granted;

  always @(prior or int_priority)
  begin
    for (i1=0 ; i1<N ; i1=i1+1) begin
      for (j1=0 ; j1<(P_WIDTH+INDEX_WIDTH+1) ; j1=j1+1) begin
        if (j1 == (P_WIDTH+INDEX_WIDTH+1) - 1'b1) begin
          priority_vec[i1*(P_WIDTH+INDEX_WIDTH+1)+j1] = 1'b0;
        end
        else if (j1 >= INDEX_WIDTH) begin
          priority_vec[i1*(P_WIDTH+INDEX_WIDTH+1)+j1] = prior[i1*P_WIDTH+(j1-(INDEX_WIDTH))];
        end
        else begin
          priority_vec[i1*(P_WIDTH+INDEX_WIDTH+1)+j1] = int_priority[i1*INDEX_WIDTH+j1];
        end
      end
    end
  end

  always @(priority_vec or masked_req or maxp1_priority)
  begin
    for (k1=0 ; k1<N ; k1=k1+1) begin
      for (l1=0 ; l1<(P_WIDTH+INDEX_WIDTH+1) ; l1=l1+1) begin
	muxed_pri_vec[k1*(P_WIDTH+INDEX_WIDTH+1)+l1] = (masked_req[k1]) ?
          priority_vec[k1*(P_WIDTH+INDEX_WIDTH+1)+l1]: maxp1_priority[l1];
      end
    end
  end

  always @(int_priority)
  begin
    for (i2=0 ; i2<N ; i2=i2+1) begin

      for (j2=0 ; j2<INDEX_WIDTH ; j2=j2+1) begin
        temp_prior[j2] = int_priority[i2*INDEX_WIDTH+j2];
      end

      temp2_prior = temp_prior - 1'b1;

      for (k2=0 ; k2<INDEX_WIDTH ; k2=k2+1) begin
        decr_prior[i2*INDEX_WIDTH+k2] = temp2_prior[k2];
      end

    end
  end


  assign st_vec = {next_parked, next_locked};

  always @(current_state or st_vec)
  begin
    case (current_state)
    2'b00: begin
      case (st_vec)
      2'b00: next_state = 2'b10;
      2'b10: next_state = 2'b01;
      default: next_state = 2'b00;
      endcase
    end
    2'b01: begin
      case (st_vec)
      2'b00: next_state = 2'b10;
      2'b01: next_state = 2'b11;
      default: next_state = 2'b01;
      endcase
    end
    2'b10: begin
      case (st_vec)
      2'b01: next_state = 2'b11;
      2'b10: next_state = 2'b01;
      default: next_state = 2'b10;
      endcase
    end
    default: begin
      case (st_vec)
      2'b00: next_state = 2'b10;
      2'b10: next_state = 2'b01;
      default: next_state = 2'b11;
      endcase
    end
    endcase
  end

  always @(current_state or masked_req or next_grant or int_priority or
                    next_locked or decr_prior or max_prior)
  begin
    for (i3=0 ; i3<N ; i3=i3+1) begin
      for (l3=0 ; l3<INDEX_WIDTH ; l3=l3+1) begin
        case (current_state)
        2'b00: begin
          if (masked_req[i3]) begin
            if (next_grant[i3]) begin
              next_prior[i3*INDEX_WIDTH+l3] = max_prior[l3];
            end
            else begin
              next_prior[i3*INDEX_WIDTH+l3] = decr_prior[i3*INDEX_WIDTH+l3];
            end
          end
          else begin
            next_prior[i3*INDEX_WIDTH+l3] = max_prior[l3];
          end
        end
        2'b01: begin
          if (next_locked) begin
            if (masked_req[i3]) begin
              if (next_grant[i3]) begin
                next_prior[i3*INDEX_WIDTH+l3] = int_priority[i3*INDEX_WIDTH+l3];
              end
              else begin
                next_prior[i3*INDEX_WIDTH+l3] = decr_prior[i3*INDEX_WIDTH+l3];
              end
            end
            else begin
              next_prior[i3*INDEX_WIDTH+l3] = max_prior[l3];
            end
          end
          else begin
            if (masked_req[i3]) begin
              if (next_grant[i3]) begin
                next_prior[i3*INDEX_WIDTH+l3] = max_prior[l3];
              end
              else begin
                next_prior[i3*INDEX_WIDTH+l3] = decr_prior[i3*INDEX_WIDTH+l3];
              end
            end
            else begin
              next_prior[i3*INDEX_WIDTH+l3] = max_prior[l3];
            end
          end
        end
        default: begin
          if (next_locked) begin
            if (masked_req[i3] == 1'b0) begin
              next_prior[i3*INDEX_WIDTH+l3] = max_prior[l3];
            end
            else begin
              next_prior[i3*INDEX_WIDTH+l3] = int_priority[i3*INDEX_WIDTH+l3];
            end
          end
          else begin
            if (masked_req[i3] == 1'b0) begin
              next_prior[i3*INDEX_WIDTH+l3] = max_prior[l3];
            end
            else begin
              if (next_grant[i3]) begin
                next_prior[i3*INDEX_WIDTH+l3] = max_prior[l3];
              end
              else begin
                next_prior[i3*INDEX_WIDTH+l3] = decr_prior[i3*INDEX_WIDTH+l3];
              end
            end
          end
        end
        endcase
      end
    end
  end

  DW_ahb_bcm01
   #(P_WIDTH+INDEX_WIDTH+1, N, INDEX_WIDTH) U_minmax(
	.a(muxed_pri_vec),
	.tc(1'b0),
	.min_max(1'b0),
	.value(current_value),
	.index(current_index) );

  
  function [N-1:0] func_decode;
    input [INDEX_WIDTH-1:0]		A;	// input
    reg   [N-1:0]		z;
    reg   [31:0]		i;
    begin
      z = {N{1'b0}};
      for (i=0 ; i<N ; i=i+1) begin
	if (i == A) begin
	  z [i] = 1'b1;
	end // if
      end // for (i
      func_decode = z;
    end
  endfunction

  assign temp_gnt = func_decode(current_index);

  
  function [N-1:0] func_decode_p_index;
    input [INDEX_WIDTH-1:0]		A;	// input
    reg   [N-1:0]		z;
    reg   [31:0]		i;
    begin
      z = {N{1'b0}};
      for (i=0 ; i<N ; i=i+1) begin
	if (i == A) begin
	  z [i] = 1'b1;
	end // if
      end // for (i
      func_decode_p_index = z;
    end
  endfunction

  assign p_index_temp = func_decode_p_index(PARK_INDEX);

  assign p_index = (PARK_MODE == 0) ? {N{1'b0}}: p_index_temp;

  
  function [N-1:0] func_mux;
    input [N*4-1:0]	a;	// input bus
    input [2-1:0]  	sel;	// select
    reg   [N-1:0]	z;
    // leda FM_2_35 off
    reg   [31:0]		i, j, k;
    // leda FM_2_35 on
    begin
      z = {N {1'b0}};
      k = 0;
      for (i=0 ; i<4 ; i=i+1) begin
	if (i == sel) begin
	  for (j=0 ; j<N ; j=j+1) begin
	    z[j] = a[j + k];
	  end // for (j
	end // if
	k = k + N;
      end // for (i
      func_mux = z;
    end
  endfunction

  assign next_grant = func_mux(({grant_int,p_index,grant_int,temp_gnt}), ({next_parked,next_locked}));



  
  function [INDEX_WIDTH-1:0] func_binenc;
    input [N-1:0]		a;	// input
    reg   [INDEX_WIDTH-1:0]		z;
    reg   [31:0]		i,j;
    begin
      z = {INDEX_WIDTH{1'b1}};
      for (i=N ; i > 0 ; i=i-1) begin
        j = i-1;
	if (a[j] == 1'b1)
	  z = j [INDEX_WIDTH-1:0];
      end // for (i
      func_binenc = z;
    end
  endfunction

  assign next_grant_index = func_binenc(next_grant);


  always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) begin
      current_state       <= 2'b00;
      int_priority        <= {N*INDEX_WIDTH{1'b1}};
      grant_index_int     <= {INDEX_WIDTH{1'b1}};
      parked_int          <= 1'b0;
      granted_int         <= 1'b0;
      locked_int          <= 1'b0;
      grant_int           <= {N{1'b0}};
    end else if (init_n == 1'b0) begin
      current_state       <= 2'b00;
      int_priority        <= {N*INDEX_WIDTH{1'b1}};
      grant_index_int     <= {INDEX_WIDTH{1'b1}};
      parked_int          <= 1'b0;
      granted_int         <= 1'b0;
      locked_int          <= 1'b0;
      grant_int           <= {N{1'b0}};
    end else if (enable) begin
      current_state       <= next_state;
      int_priority        <= next_prior;
      grant_index_int     <= next_grant_index;
      parked_int          <= next_parked;
      granted_int         <= next_granted;
      locked_int          <= next_locked;
      grant_int           <= next_grant;
    end
  end

  assign grant       = (OUTPUT_MODE == 0) ? next_grant :
                        grant_int;
  assign grant_index = (OUTPUT_MODE == 0) ? next_grant_index :
                        grant_index_int;
  assign granted     = (OUTPUT_MODE == 0) ? next_granted : 
	                granted_int;
  assign parked      = (PARK_MODE == 0) ? 1'b0:
                         (OUTPUT_MODE == 0) ? next_parked : 
	                  parked_int;
  assign locked      = (OUTPUT_MODE == 0) ? next_locked : 
	                locked_int;

endmodule
