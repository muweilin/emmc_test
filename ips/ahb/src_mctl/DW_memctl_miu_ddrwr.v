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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_miu_ddrwr.v $ 
// $Revision: #3 $
//
// Abstract  : This module is a subblock of the DW_memctl_miu. It receives
// 1x-clock write data, data mask and data strobe signals, and generates
// 2x-clock write data, data mask and data strobe signals to the DDR SDRAM.
//
//============================================================================
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl_miu_ddrwr (hclk,
                            hresetn,
                            hclk_2x,
                            scan_mode,
                            pre_dqm,
                            pre_dqs,
                            pre_amble,
                            pre_rd_dqs_mask,
                            s_data_width,
                            cas_latency,
                            hiu_wr_data,
                            s_wr_data,
                            s_dqm,
                            s_dqs,
                            s_rd_dqs_mask);

  // input signals
  input 			                     hclk;            // AHB clock
  input 			                     hresetn;         // AHB reset
  input 			                     hclk_2x;         // 2x clock
  input 			                     scan_mode;       // Scan Mode 
  input [`MAX_S_DATA_WIDTH/4-1:0]  pre_dqm;         // internal dqm signal
  input 			                     pre_dqs;         // internal dqs signal
  input 			                     pre_amble;       // write pre_amble;
  input 			                     pre_rd_dqs_mask; // internal read dqs mask
  input [1:0] 			               s_data_width;    // memory data width
  input [2:0] 			               cas_latency;     // cas latency
  input [`MAX_S_DATA_WIDTH*2-1:0]  hiu_wr_data;     // write data from HIU

  // output signals
  output [`MAX_S_DATA_WIDTH-1:0]   s_wr_data;       // DDR-SDRAM write data
  output [`MAX_S_DATA_WIDTH/8-1:0] s_dqm;           // DDR-SDRAM dqm
  output [`NUM_DQS-1 :0] 	         s_dqs;           // DDR-SDRAM dqs
  output 			                     s_rd_dqs_mask;   // mask for read dqs
  
  reg [`MAX_S_DATA_WIDTH-1 : 0]    s_wr_data;       
  reg [`MAX_S_DATA_WIDTH-1 : 0]    ddr_wr_data;
  reg [`MAX_S_DATA_WIDTH/8-1:0]    s_dqm;
  reg [`MAX_S_DATA_WIDTH/8-1:0]    ddr_dqm;
  reg [`NUM_DQS-1 :0] 		         s_dqs;
  reg [63:0] 			                 wr_data_lo;
  reg [63:0] 			                 wr_data_hi;
  reg [7:0] 			                 s_dqm_lo;
  reg [7:0] 			                 s_dqm_hi;
  reg [`MAX_S_DATA_WIDTH*2-1:0]    r_wr_data;
  reg [`MAX_S_DATA_WIDTH/4-1:0]    r_pre_dqm;
  reg [5:0] 			                 rd_dqs_mask_d;
  reg 				                     s_rd_dqs_mask;
  reg 				                     r_dqs;
  reg 				                     r_pre_dqs_hclk_2x;
  reg [`NUM_DQS-1 :0] 		         i2_dqs;

  wire [`NUM_DQS-1 :0] 		         i_dqs;
  wire [127:0] 			               i_wr_data;
  wire [15:0] 			               i_dqm;
  wire                             test_fix;
  wire 				                     i_dqs_extended;
  // leda DFT_002 off
  wire hclk_2x_scan_clk;
  // leda DFT_002 on
 
  integer 			                   i;

  //-----------------------------------------------------------
  // generate 2x-clock mask signal for the dqs during read
  //-----------------------------------------------------------
  always @(posedge hclk_2x or negedge hresetn) begin
    if(hresetn == 1'b0) 
      rd_dqs_mask_d       <= 6'b000000;
    else begin
      rd_dqs_mask_d[0]    <= pre_rd_dqs_mask;
      for(i=1; i<=5; i=i+1)
        rd_dqs_mask_d[i]  <= rd_dqs_mask_d[i-1];
    end
  end

  always @(posedge hclk_2x or negedge hresetn) begin
    if(hresetn == 1'b0)
      s_rd_dqs_mask               <= 1'b0;
    else begin
      case(cas_latency) 
        3'b001: s_rd_dqs_mask 	  <= pre_rd_dqs_mask;
        3'b010: s_rd_dqs_mask 	  <= rd_dqs_mask_d[1];
        3'b011: s_rd_dqs_mask 	  <= rd_dqs_mask_d[3];
        3'b100: s_rd_dqs_mask 	  <= rd_dqs_mask_d[5];
        3'b101: s_rd_dqs_mask 	  <= rd_dqs_mask_d[0];
        3'b110: s_rd_dqs_mask 	  <= rd_dqs_mask_d[2];
        3'b111: s_rd_dqs_mask 	  <= rd_dqs_mask_d[4];
        default: s_rd_dqs_mask 	  <= rd_dqs_mask_d[3]; 
      endcase
    end
  end

  //-----------------------------------------------------------
  // generate 2x-clock dqs signal during write 
  //-----------------------------------------------------------
  always @(posedge hclk_2x or negedge hresetn) begin
    if(hresetn == 1'b0) begin
      r_dqs             <= 1'b1;
      r_pre_dqs_hclk_2x <= 1'b1;
    end
    else begin
      r_dqs             <= pre_dqs ? 1'b1 : ~r_dqs;
      r_pre_dqs_hclk_2x <= pre_dqs;
    end
  end

  //-----------------------------------------------------------
  // Extend write post-amble by 1 hclk_2x cycle.
  // This will not be visible at the SDRAM as it will be masked by
  // the tristate enable timing. It was added to prevent an additional
  // s_dqs edge after the write post-amble period, in the case where
  // the tristate enable signal does not disable the s_dqs output driver
  // in time to mask the s_dqs signal rising edge after the write
  // post-amble period (the s_dqs signal defaults to 1'b1).
  // s_dqs was not changed to default to 1'b0 to avoid altering legacy
  // s_dqs write pre-amble functionality.
  //-----------------------------------------------------------
  assign i_dqs_extended = (pre_dqs && !r_pre_dqs_hclk_2x) ? 1'b0 : r_dqs;
  
  assign i_dqs = {`NUM_DQS{pre_amble && i_dqs_extended}}; 
 
  always @(posedge hclk_2x or negedge hresetn) begin
    if(hresetn == 1'b0) begin
      i2_dqs 	<= {`NUM_DQS{1'b1}};
      s_dqs 	<= {`NUM_DQS{1'b1}};
    end
    else begin 
      i2_dqs 	<= i_dqs;
      s_dqs 	<= i2_dqs; 
    end
  end

  //-----------------------------------------------------------
  // generate 2x-clock write data and dqm 
  //-----------------------------------------------------------
  // leda W389 off
  always @(posedge hclk or negedge hresetn) begin
    if(hresetn == 1'b0) begin
      r_wr_data    <= 0;
        // Mobile DDR SDRAM requires DQM held high during init sequence.
        r_pre_dqm  <= {`MAX_S_DATA_WIDTH/4{1'b1}};
    end
    else begin
      r_wr_data    <= hiu_wr_data;
      r_pre_dqm    <= pre_dqm;
    end
  end
  // leda W389 on
 
  assign i_wr_data   = r_wr_data;
  assign i_dqm 	     = r_pre_dqm;

  always @(
    s_data_width or
    i_wr_data or
    i_dqm) 
  begin
    wr_data_lo = i_wr_data[63:0];
    wr_data_hi = i_wr_data[127:64];
    s_dqm_lo 	 = i_dqm[7:0];
    s_dqm_hi 	 = i_dqm[15:8];
    case(s_data_width)
      2'b00: begin
        wr_data_lo[7:0]  = i_wr_data[7:0];
        wr_data_hi[7:0]  = i_wr_data[15:8];
        s_dqm_lo[0] 	   = i_dqm[0];
        s_dqm_hi[0] 	   = i_dqm[1];
      end
      2'b01: begin
        wr_data_lo[15:0] = i_wr_data[15:0];
        wr_data_hi[15:0] = i_wr_data[31:16];
        s_dqm_lo[1:0] 	 = i_dqm[1:0];
        s_dqm_hi[1:0] 	 = i_dqm[3:2];
      end
      2'b10: begin
        wr_data_lo[31:0] = i_wr_data[31:0];
        wr_data_hi[31:0] = i_wr_data[63:32];
        s_dqm_lo[3:0] 	 = i_dqm[3:0];
        s_dqm_hi[3:0] 	 = i_dqm[7:4];
      end
      2'b11: begin
        wr_data_lo[63:0] = i_wr_data[63:0];
        wr_data_hi[63:0] = i_wr_data[127:64];
        s_dqm_lo[7:0] 	 = i_dqm[7:0];
        s_dqm_hi[7:0] 	 = i_dqm[15:8];
      end
    endcase
  end        

  assign test_fix = (scan_mode)?  r_dqs : hclk;

  always @(posedge hclk_2x or negedge hresetn) begin
    if(hresetn == 1'b0) begin
      ddr_wr_data  <= 0;
        // Mobile DDR SDRAM requires DQM held high during init sequence.
        ddr_dqm    <= {`MAX_S_DATA_WIDTH/8{1'b1}};
    end
    else begin
      ddr_wr_data  <= (test_fix)? wr_data_lo[`MAX_S_DATA_WIDTH-1:0] : 
                                  wr_data_hi[`MAX_S_DATA_WIDTH-1:0];
      ddr_dqm      <= (test_fix)? s_dqm_lo[`MAX_S_DATA_WIDTH/8-1:0] : 
                                  s_dqm_hi[`MAX_S_DATA_WIDTH/8-1:0];
    end
  end

  // leda W389 off
  // need to use a posedge clock for scan mode
  assign hclk_2x_scan_clk = (scan_mode) ? hclk_2x : ~hclk_2x;
  // delay write data and dqm by half 2x clock to be edge-aligned with dqs
  // leda DFT_003 off
  // leda S_1C_R off
  // leda S_2C_R off
  // leda W396 off
  // leda W401 off
  always @(posedge hclk_2x_scan_clk or negedge hresetn)
  begin
    if(!hresetn)
    begin
        s_wr_data <= 0;
          // Mobile DDR SDRAM requires DQM held high during init sequence.
          s_dqm    <= {`MAX_S_DATA_WIDTH/8{1'b1}};
    end
    else
    begin
        s_wr_data <= ddr_wr_data;
        s_dqm     <= ddr_dqm;
    end
  end
  // leda W401 on
  // leda W396 on
  // leda S_2C_R on
  // leda S_1C_R on
  // leda DFT_003 on
  // leda W389 on

endmodule //end of DW_memctl_miu_ddrwr
