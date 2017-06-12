
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
// Filename    : DW_axi_x2h_bcm21.v
// Revision    : $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_bcm21.v#9 $
// Author      : Doug Lee    2/20/05
// Description : DW_axi_x2h_bcm21.v Verilog module for DWbb
//
// DesignWare IP ID: c66b8a7b
//
////////////////////////////////////////////////////////////////////////////////


// leda NTL_CDC01 off
// LMD: Clock domain crossing is found and no global synchronization is detected
// LJ: This module is configured so that special synchronization schemes are implemented.  So, disable LEDA from reporting this error.
// leda NTL_CDC01_3 off
// LMD: Complex synchronizer detected
// LJ: The complex synchronizer was checked and works as intended.  So, disable LEDA from reporting this warning.
module DW_axi_x2h_bcm21 (
    clk_d,
    rst_d_n,
    init_d_n,
    data_s,
    test,
    data_d
    );

parameter WIDTH        = 1;  // RANGE 1 to 1024
parameter F_SYNC_TYPE  = 2;  // RANGE 0 to 4
parameter TST_MODE     = 0;  // RANGE 0 to 2
// leda W175 off
// LMD: Parameter is defined but not used
// LJ: This parameter is known to be unused for the synthesizable code.  So, disable LEDA from reporting this warning.
parameter VERIF_EN     = 1;  // RANGE 0 to 5
// leda W175 on
// leda W175 off
// LMD: Parameter is defined but not used
// LJ: This parameter is known to be unused for the synthesizable code.  So, disable LEDA from reporting this warning.
parameter SVA_TYPE     = 1;
// leda W175 on


input			clk_d;      // clock input from destination domain
input			rst_d_n;    // active low asynchronous reset from destination domain
input			init_d_n;   // active low synchronous reset from destination domain
// leda NTL_CDC03 off
// LMD: Divergence found in clock domain crossing path
// LJ: Devergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
input  [WIDTH-1:0]      data_s;     // data to be synchronized from source domain
// leda NTL_CDC03 on
input                   test;       // test input
// leda NTL_CDC03 off
// LMD: Divergence found in clock domain crossing path
// LJ: Devergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
output [WIDTH-1:0]      data_d;     // data synchronized to destination domain

// leda NTL_CON13A off
// LMD: Non driving internal net Range
// LJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
wire   [WIDTH-1:0]      data_s_int;
// leda NTL_CON13A on
// leda NTL_CDC03 on


// leda DCVER_192 off
// LMD: Initial statement not supported
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda W430 off
// LMD: Initial statement is not synthesizable
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda W599 off
// LMD: Initial construct is not supported by Synopsys
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda W159 off
// LMD: Constant condition expression
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda B_2000 off
// LMD: System tasks are not allowed
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
`ifndef SMIC_SYNTHESIS
`ifndef DWC_DISABLE_CDC_METHOD_REPORTING
  initial begin
    if ((F_SYNC_TYPE > 0)&&(F_SYNC_TYPE < 8))
       $display("Information: *** Instance %m module is using the <Double Register Synchronizer (1)> Clock Domain Crossing Method ***");
  end

`ifdef DW_REPORT_SYNC_PARAMS
  initial begin
    if ((F_SYNC_TYPE & 7) > 0)
          $display("Information: *** Instance %m is configured as follows: WIDTH is: %0d, F_SYNC_TYPE is: %0d, TST_MODE is: %0d ***", WIDTH, (F_SYNC_TYPE & 7), TST_MODE);
  end
`endif
`endif
`endif
// leda DCVER_192 on
// leda W430 on
// leda W599 on
// leda W159 on
// leda B_2000 on



`ifdef SMIC_SYNTHESIS
  assign data_s_int = data_s;
`else
  `ifdef DW_MODEL_MISSAMPLES
// leda DCVER_192 off
// LMD: Initial statement not supported
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda W430 off
// LMD: Initial statement is not synthesizable
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda W599 off
// LMD: Initial construct is not supported by Synopsys
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda W159 off
// LMD: Constant condition expression
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
// leda B_2000 off
// LMD: System tasks are not allowed
// LJ: Some statements that are not synthesizable or are not supported are intentionally used around here, so disabling leda for this rule.
  initial begin
    $display("Information: %m: *** Running with DW_MODEL_MISSAMPLES defined, VERIF_EN is: %0d ***",
			VERIF_EN);
  end

reg     [WIDTH-1:0]     test_hold_ms;
wire			hclk_odd;
reg  [WIDTH-1:0]	last_data_dyn, data_s_delta_t;
reg  [WIDTH-1:0]	last_data_s, last_data_s_q, last_data_s_qq;
wire [WIDTH-1:0]	data_s_sel_0, data_s_sel_1;
reg  [WIDTH-1:0]	data_select; initial data_select = 0;
reg  [WIDTH-1:0]	data_select_2; initial data_select_2 = 0;

  always @ (negedge clk_d or negedge rst_d_n) begin : PROC_test_hold_ms_registers
    if (rst_d_n == 1'b0) begin
      test_hold_ms        <= {WIDTH{1'b0}};
`ifndef DWC_NO_CDC_INIT
    end else if (init_d_n == 1'b0) begin
      test_hold_ms        <= {WIDTH{1'b0}};
`endif
    end else begin
      test_hold_ms        <= data_s;
    end
  end
reg			init_dly_n;


  always @ (posedge hclk_odd or data_s or rst_d_n) begin : PROC_catch_last_data
    data_s_delta_t <= data_s & {WIDTH{rst_d_n}} & {WIDTH{init_dly_n}};
    last_data_dyn <= data_s_delta_t & {WIDTH{rst_d_n}} & {WIDTH{init_dly_n}};
  end // PROC_catch_last_data

generate if ((VERIF_EN % 2) == 1) begin : GEN_HO_VE_EVEN
  assign hclk_odd = clk_d;
end else begin : GEN_HO_VE_ODD
  assign hclk_odd = ~clk_d;
end
endgenerate

  always @ (posedge clk_d or negedge rst_d_n) begin : PROC_missample_hist_even
    if (rst_d_n == 1'b0) begin
      last_data_s_q  <= {WIDTH{1'b0}};
      init_dly_n     <= 1'b1;
    end else if (init_d_n == 1'b0) begin
      last_data_s_q  <= {WIDTH{1'b0}};
      init_dly_n     <= 1'b0;
    end else begin
      last_data_s_q <= last_data_s;
      init_dly_n     <= 1'b1;
    end
  end // PROC_missample_hist_even

  always @ (posedge hclk_odd or negedge rst_d_n) begin : PROC_missample_hist_odd
    if (rst_d_n == 1'b0) begin
      last_data_s <= {WIDTH{1'b0}};
      last_data_s_qq  <= {WIDTH{1'b0}};
    end else if (init_d_n == 1'b0) begin
      last_data_s <= {WIDTH{1'b0}};
      last_data_s_qq  <= {WIDTH{1'b0}};
    end else begin
      last_data_s <= data_s;
      last_data_s_qq <= last_data_s_q;
    end
  end // PROC_missample_hist_odd

  always @ (data_s or last_data_s) begin : PROC_mk_next_data_select
    if (data_s != last_data_s) begin
      data_select = wide_random(WIDTH);

      if ((VERIF_EN == 2) || (VERIF_EN == 3))
	data_select_2 = wide_random(WIDTH);
      else
	data_select_2 = {WIDTH{1'b0}};
    end
  end  // PROC_mk_next_data_select

  assign data_s_sel_0 = (VERIF_EN < 1)? data_s : ((data_s & ~data_select) | (last_data_dyn & data_select));

  assign data_s_sel_1 = (VERIF_EN < 2)? {WIDTH{1'b0}} : ((last_data_s_q & ~data_select) | (last_data_s_qq & data_select));

  assign data_s_int = ((data_s_sel_0 & ~data_select_2) | (data_s_sel_1 & data_select_2));

// { START Latency Accurate modeling
  initial begin : set_setup_hold_delay_PROC
    `ifndef DW_HOLD_MUX_DELAY
      `define DW_HOLD_MUX_DELAY  1
      if (((F_SYNC_TYPE & 7) == 2) && (VERIF_EN == 5))
        $display("Information: %m: *** Warning: `DW_HOLD_MUX_DELAY is not defined so it is being set to: %0d ***", `DW_HOLD_MUX_DELAY);
    `endif

    `ifndef DW_SETUP_MUX_DELAY
      `define DW_SETUP_MUX_DELAY  1
      if (((F_SYNC_TYPE & 7) == 2) && (VERIF_EN == 5))
        $display("Information: %m: *** Warning: `DW_SETUP_MUX_DELAY is not defined so it is being set to: %0d ***", `DW_SETUP_MUX_DELAY);
    `endif
  end // set_setup_hold_delay_PROC

  initial begin
    if (((F_SYNC_TYPE & 7) == 2) && (VERIF_EN == 5))
      $display("Information: %m: *** Running with Latency Accurate MISSAMPLES defined, VERIF_EN is: %0d ***", VERIF_EN);
  end

  reg [WIDTH-1:0] setup_mux_ctrl, hold_mux_ctrl;
  initial setup_mux_ctrl = {WIDTH{1'b0}};
  initial hold_mux_ctrl  = {WIDTH{1'b0}};
  
  wire [WIDTH-1:0] data_s_q;
  reg clk_d_q;
  initial clk_d_q = 1'b0;
  reg [WIDTH-1:0] setup_mux_out, d_muxout;
  reg [WIDTH-1:0] d_ff1, d_ff2;
  integer i,j,k;
  
  
  //Delay the destination clock
  always @ (posedge clk_d)
  #`DW_HOLD_MUX_DELAY clk_d_q = 1'b1;

  always @ (negedge clk_d)
  #`DW_HOLD_MUX_DELAY clk_d_q = 1'b0;
  
  //Delay the source data
  assign #`DW_SETUP_MUX_DELAY data_s_q = (!rst_d_n) ? {WIDTH{1'b0}}:data_s;

  //setup_mux_ctrl controls the data entering the flip flop 
  always @ (data_s or data_s_q or setup_mux_ctrl)
  begin
    for (i=0;i<=WIDTH-1;i=i+1) begin
      if (setup_mux_ctrl[i])
        setup_mux_out[i] = data_s_q[i];
      else
        setup_mux_out[i] = data_s[i];
    end
  end

  always @ (posedge clk_d_q or negedge rst_d_n)
  begin
    if (rst_d_n == 1'b0)
      d_ff2 <= {WIDTH{1'b0}};
    else if (init_d_n == 1'b0)
      d_ff2 <= {WIDTH{1'b0}};
    else if (test == 1'b1)
      d_ff2 <= (TST_MODE == 1) ? test_hold_ms : data_s;
    else
      d_ff2 <= setup_mux_out;
  end

  always @ (posedge clk_d or negedge rst_d_n)
  begin
    if (rst_d_n == 1'b0) begin
      d_ff1          <= {WIDTH{1'b0}};
      setup_mux_ctrl <= {WIDTH{1'b0}};
      hold_mux_ctrl  <= {WIDTH{1'b0}};
    end
    else if (init_d_n == 1'b0) begin
      d_ff1          <= {WIDTH{1'b0}};
      setup_mux_ctrl <= {WIDTH{1'b0}};
      hold_mux_ctrl  <= {WIDTH{1'b0}};
    end
    else begin
      if (test == 1'b1)
        d_ff1        <= (TST_MODE == 1) ? test_hold_ms : data_s;
      else
        d_ff1        <= setup_mux_out;
      setup_mux_ctrl <= wide_random(WIDTH);  //randomize mux_ctrl
      hold_mux_ctrl  <= wide_random(WIDTH);  //randomize mux_ctrl
    end
  end


//hold_mux_ctrl decides the clock triggering the flip-flop
always @(hold_mux_ctrl or d_ff2 or d_ff1) begin
      for (k=0;k<=WIDTH-1;k=k+1) begin
        if (hold_mux_ctrl[k])
          d_muxout[k] = d_ff2[k];
        else
          d_muxout[k] = d_ff1[k];
      end
end
// END Latency Accurate modeling }


 //Assertions
`ifdef DWC_BCM_SNPS_ASSERT_ON
`ifndef SMIC_SYNTHESIS
generate if ((F_SYNC_TYPE == 2) && (VERIF_EN == 5)) begin : GEN_ASSERT_FST2_VE5
  sequence p_num_d_chng;
  @ (posedge clk_d) 1'b1 ##0 (data_s != d_ff1); //Number of times input data changed
  endsequence
  
  sequence p_num_d_chng_hmux1;
  @ (posedge clk_d) 1'b1 ##0 ((data_s != d_ff1) && (|(hold_mux_ctrl & (data_s ^ d_ff1)))); //Number of times hold_mux_ctrl was asserted when the input data changed
  endsequence
  
  sequence p_num_d_chng_smux1;
  @ (posedge clk_d) 1'b1 ##0 ((data_s != d_ff1) && (|(setup_mux_ctrl & (data_s ^ d_ff1)))); //Number of times setup_mux_ctrl was asserted when the input data changed
  endsequence
  
  sequence p_hold_vio;
  reg [WIDTH-1:0]temp_var, temp_var1;
  @ (posedge clk_d) (((data_s != d_ff1) && (|(hold_mux_ctrl & (data_s ^ d_ff1)))), temp_var = data_s, temp_var1 =(hold_mux_ctrl & (data_s ^ d_ff1))) ##1 ((data_d & temp_var1) == (temp_var & temp_var1));
          //Number of times output data was advanced due to hold violation
  endsequence
  
  sequence p_setup_vio;
  reg [WIDTH-1:0]temp_var, temp_var1;
  @ (posedge clk_d) (((data_s != d_ff1) && (|(setup_mux_ctrl & (data_s ^ d_ff1)))), temp_var = data_s, temp_var1 =(setup_mux_ctrl & (data_s ^ d_ff1))) ##2 ((data_d & temp_var1) != (temp_var & temp_var1));
          //Number of times output data was delayed due to setup violation
  endsequence

  cp_num_d_chng           :
 cover property  (p_num_d_chng);    
  cp_num_d_chng_hld_mux1  :
 cover property  (p_num_d_chng_hmux1);
  cp_num_d_chng_set_mux1  :
 cover property  (p_num_d_chng_smux1);
  cp_hold_vio             :
 cover property  (p_hold_vio);
  cp_setup_vio            :
 cover property  (p_setup_vio);        
 end
endgenerate
`endif // SYNTHESIS
`endif // DWC_BCM_SNPS_ASSERT_ON

  function [WIDTH-1:0] wide_random;
    input [31:0]        in_width;   // should match "WIDTH" parameter -- need one input to satisfy Verilog function requirement

    reg   [WIDTH-1:0]   temp_result;
    reg   [31:0]        rand_slice;
    integer             i, j, base;


    begin
      temp_result = $random;
      if (((WIDTH / 32) + 1) > 1) begin
        for (i=1 ; i < ((WIDTH / 32) + 1) ; i=i+1) begin
          base = i << 5;
          rand_slice = $random;
          for (j=0 ; ((j < 32) && (base+j < in_width)) ; j=j+1) begin
            temp_result[base+j] = rand_slice[j];
          end
        end
      end

      wide_random = temp_result;
    end
  endfunction  // wide_random

  initial begin : seed_random_PROC
    integer seed, init_rand;
    `ifdef DW_MISSAMPLE_SEED
      seed = `DW_MISSAMPLE_SEED;
    `else
      seed = 32'h0badbeef;
    `endif

    init_rand = $random(seed);
  end // seed_random_PROC

// leda DCVER_192 on
// leda W430 on
// leda W599 on
// leda W159 on
// leda B_2000 on
  `else
  assign data_s_int = data_s;
  `endif
`endif


generate
    if ((F_SYNC_TYPE & 7) == 0) begin : GEN_FST0
      if (TST_MODE == 1) begin : GEN_DATAD_FST0_TM1
        reg    [WIDTH-1:0]      test_hold;
// leda S_2C_R off
// LMD: Use rising edge flipflop
// LJ: The module was intentionally implemented to use negative edge clocking flip-flops cells.  So, disable LEDA from reporting this error.
        always @ (negedge clk_d or negedge rst_d_n) begin : test_hold_registers_PROC
// leda S_2C_R on
          if (rst_d_n == 1'b0) begin
            test_hold        <= {WIDTH{1'b0}};
          end else if (init_d_n == 1'b0) begin
            test_hold        <= {WIDTH{1'b0}};
          end else begin
// leda NTL_CLK05 off
// LMD: Asynchronous inputs to a clock system are not clocked twice
// LJ: This module is configured so that the following asynch signals are clocked by 2 flip-flops with different clock edges of the same clock.  So, disable LEDA from reporting this error.
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
            test_hold        <= data_s;
// leda NTL_CDC09 on
// leda NTL_CLK05 on
          end
        end

// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
        assign data_d  = (test == 1'b1) ? test_hold : data_s;
// leda NTL_CDC02 on
      end else begin : GEN_DATAD_FST0_TM_NE_1
        assign data_d  =  data_s;
      end
    end
    if ((F_SYNC_TYPE & 7) == 1) begin : GEN_FST1
         reg    [WIDTH-1:0]      sample_meta_n;
         reg    [WIDTH-1:0]      sample_syncl;
         wire   [WIDTH-1:0]      next_sample_syncm1;
         wire   [WIDTH-1:0]      next_sample_syncl;

// leda S_2C_R off
// LMD: Use rising edge flipflop
// LJ: The module was intentionally implemented to use negative edge clocking flip-flops cells.  So, disable LEDA from reporting this error.
         always @ (negedge clk_d or negedge rst_d_n) begin : negedge_registers_PROC
// leda S_2C_R on
// spyglass disable_block STARC-1.3.1.3
// spyglass disable_block STARC05-1.3.1.3
// SMD: Asynchronous reset/preset signals must not be used as non-reset/preset or synchronous reset/preset signals
// SJ: Synchronizer FFs required to have reset to initialize system
           if (rst_d_n == 1'b0) begin
// spyglass enable_block STARC05-1.3.1.3
// spyglass enable_block STARC-1.3.1.3
             sample_meta_n    <= {WIDTH{1'b0}};
// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
           end else if (init_d_n == 1'b0) begin
// leda NTL_CDC02 on
             sample_meta_n    <= {WIDTH{1'b0}};
           end else begin
// leda NTL_CLK05 off
// LMD: Asynchronous inputs to a clock system are not clocked twice
// LJ: This module is configured so that the following asynch signals are clocked by 2 flip-flops with different clock edges of the same clock.  So, disable LEDA from reporting this error.
// leda NTL_CDC15 off
// LMD: A handshake synchronizer must implement the handshake protocol and data stability correctly
// LJ: The handshake protocol and data stability are checked and guarunteed.  So, disable LEDA from reporting this warning.
// leda NTL_CDC06 off
// LMD: CDC control signal must be stable enough
// LJ: CDC control signal is checked and stable.  So, disable LEDA from reporting this warning.
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
             sample_meta_n    <= data_s_int;
// leda NTL_CDC09 on
// leda NTL_CDC06 on
// leda NTL_CDC15 on
// leda NTL_CLK05 on
           end
         end

         assign next_sample_syncm1 = sample_meta_n;
         assign next_sample_syncl = next_sample_syncm1;

         always @ (posedge clk_d or negedge rst_d_n) begin : posedge_registers_PROC
// spyglass disable_block STARC-1.3.1.3
// spyglass disable_block STARC05-1.3.1.3
// SMD: Asynchronous reset/preset signals must not be used as non-reset/preset or synchronous reset/preset signals
// SJ: Synchronizer FFs required to have reset to initialize system
           if (rst_d_n == 1'b0) begin
// spyglass enable_block STARC05-1.3.1.3
// spyglass enable_block STARC-1.3.1.3
             sample_syncl     <= {WIDTH{1'b0}};
// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
           end else if (init_d_n == 1'b0) begin
// leda NTL_CDC02 on
             sample_syncl     <= {WIDTH{1'b0}};
           end else begin
// leda NTL_CDC01_0 off
// LMD: Flip-flop synchronizer detected
// LJ: The flip-flop synchronizer was checked and works as intended.  So, disable LEDA from reporting this warning.
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
// leda NTL_CDC00 off
// LMD: Clock domain crossing detected
// LJ: The clock domain crossing is intentional and proper synchronization scheme is implemented.  So, disable LEDA from reporting this warning.
             sample_syncl     <= next_sample_syncl;
// leda NTL_CDC00 on
// leda NTL_CDC09 on
// leda NTL_CDC01_0 on
           end
         end

         assign data_d = sample_syncl;
    end
    if ((F_SYNC_TYPE & 7) == 2) begin : GEN_FST2
         reg    [WIDTH-1:0]      sample_meta;
         reg    [WIDTH-1:0]      sample_syncl;
         wire   [WIDTH-1:0]      next_sample_meta;
         wire   [WIDTH-1:0]      next_sample_syncm1;
         wire   [WIDTH-1:0]      next_sample_syncl;

  if (TST_MODE == 1) begin : GEN_TST_MODE1
    reg    [WIDTH-1:0]      test_hold;

// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
    assign next_sample_meta      = (test == 1'b0) ? data_s_int : test_hold;
// leda NTL_CDC02 on

// leda S_2C_R off
// LMD: Use rising edge flipflop
// LJ: The module was intentionally implemented to use negative edge clocking flip-flops cells.  So, disable LEDA from reporting this error.
    always @ (negedge clk_d or negedge rst_d_n) begin : test_hold_registers_PROC
// leda S_2C_R on
      if (rst_d_n == 1'b0) begin
        test_hold        <= {WIDTH{1'b0}};
      end else if (init_d_n == 1'b0) begin
        test_hold        <= {WIDTH{1'b0}};
      end else begin
// leda NTL_CLK05 off
// LMD: Asynchronous inputs to a clock system are not clocked twice
// LJ: This module is configured so that the following asynch signals are clocked by 2 flip-flops with different clock edges of the same clock.  So, disable LEDA from reporting this error.
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
        test_hold        <= data_s;
// leda NTL_CDC09 on
// leda NTL_CLK05 on
      end
    end
  end else begin : GEN_TST_MODE0
// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
    assign next_sample_meta      = (test == 1'b0) ? data_s_int : data_s;
// leda NTL_CDC02 on
  end


`ifdef SMIC_SYNTHESIS
         assign next_sample_syncm1 = sample_meta;
`else
  `ifdef DW_MODEL_MISSAMPLES
    if (((F_SYNC_TYPE & 7) == 2) && (VERIF_EN == 5)) begin : GEN_NXT_SMPL_SM1_FST2_VE5
         assign next_sample_syncm1 = d_muxout;
    end else begin : GEN_NXT_SMPL_SM1_ELSE
         assign next_sample_syncm1 = sample_meta;
    end
  `else
         assign next_sample_syncm1 = sample_meta;
  `endif
`endif
         assign next_sample_syncl = next_sample_syncm1;
         always @ (posedge clk_d or negedge rst_d_n) begin : posedge_registers_PROC
// spyglass disable_block STARC-1.3.1.3
// spyglass disable_block STARC05-1.3.1.3
// SMD: Asynchronous reset/preset signals must not be used as non-reset/preset or synchronous reset/preset signals
// SJ: Synchronizer FFs required to have reset to initialize system
           if (rst_d_n == 1'b0) begin
// spyglass enable_block STARC05-1.3.1.3
// spyglass enable_block STARC-1.3.1.3
             sample_meta     <= {WIDTH{1'b0}};
             sample_syncl     <= {WIDTH{1'b0}};
// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
           end else if (init_d_n == 1'b0) begin
// leda NTL_CDC02 on
             sample_meta     <= {WIDTH{1'b0}};
             sample_syncl     <= {WIDTH{1'b0}};
           end else begin
// leda NTL_CLK05 off
// LMD: Asynchronous inputs to a clock system are not clocked twice
// LJ: This module is configured so that the following asynch signals are clocked by 2 flip-flops with different clock edges of the same clock.  So, disable LEDA from reporting this error.
// leda NTL_CDC14 off
// LMD: Control and data signals of a MUX (logic) synchronizer must be stable enough
// LJ: Control and data signals of synchronizers are checked and stable.  So, disable LEDA from reporting this warning.
// leda NTL_CDC15 off
// LMD: A handshake synchronizer must implement the handshake protocol and data stability correctly
// LJ: The handshake protocol and data stability are checked and guarunteed.  So, disable LEDA from reporting this warning.
// leda NTL_CDC06 off
// LMD: CDC control signal must be stable enough
// LJ: CDC control signal is checked and stable.  So, disable LEDA from reporting this warning.
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
             sample_meta     <= next_sample_meta;
// leda NTL_CDC09 on
// leda NTL_CDC06 on
// leda NTL_CDC15 on
// leda NTL_CDC14 on
// leda NTL_CLK05 on
// leda NTL_CDC01_0 off
// LMD: Flip-flop synchronizer detected
// LJ: The flip-flop synchronizer was checked and works as intended.  So, disable LEDA from reporting this warning.
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
// leda NTL_CDC00 off
// LMD: Clock domain crossing detected
// LJ: The clock domain crossing is intentional and proper synchronization scheme is implemented.  So, disable LEDA from reporting this warning.
             sample_syncl     <= next_sample_syncl;
// leda NTL_CDC00 on
// leda NTL_CDC09 on
// leda NTL_CDC01_0 on
           end
         end

         assign data_d = sample_syncl;
    end
    if ((F_SYNC_TYPE & 7) == 3) begin : GEN_FST3
         reg    [WIDTH-1:0]      sample_meta;
         reg    [WIDTH-1:0]      sample_syncm1;
         reg    [WIDTH-1:0]      sample_syncl;
         wire   [WIDTH-1:0]      next_sample_meta;
         wire   [WIDTH-1:0]      next_sample_syncm1;
         wire   [WIDTH-1:0]      next_sample_syncl;

  if (TST_MODE == 1) begin : GEN_TST_MODE1
    reg    [WIDTH-1:0]      test_hold;

// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
    assign next_sample_meta      = (test == 1'b0) ? data_s_int : test_hold;
// leda NTL_CDC02 on

// leda S_2C_R off
// LMD: Use rising edge flipflop
// LJ: The module was intentionally implemented to use negative edge clocking flip-flops cells.  So, disable LEDA from reporting this error.
    always @ (negedge clk_d or negedge rst_d_n) begin : test_hold_registers_PROC
// leda S_2C_R on
      if (rst_d_n == 1'b0) begin
        test_hold        <= {WIDTH{1'b0}};
      end else if (init_d_n == 1'b0) begin
        test_hold        <= {WIDTH{1'b0}};
      end else begin
// leda NTL_CLK05 off
// LMD: Asynchronous inputs to a clock system are not clocked twice
// LJ: This module is configured so that the following asynch signals are clocked by 2 flip-flops with different clock edges of the same clock.  So, disable LEDA from reporting this error.
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
        test_hold        <= data_s;
// leda NTL_CDC09 on
// leda NTL_CLK05 on
      end
    end
  end else begin : GEN_TST_MODE0
// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
    assign next_sample_meta      = (test == 1'b0) ? data_s_int : data_s;
// leda NTL_CDC02 on
  end


         assign next_sample_syncm1 = sample_meta;
         assign next_sample_syncl  = sample_syncm1;
         always @ (posedge clk_d or negedge rst_d_n) begin : posedge_registers_PROC
// spyglass disable_block STARC-1.3.1.3
// spyglass disable_block STARC05-1.3.1.3
// SMD: Asynchronous reset/preset signals must not be used as non-reset/preset or synchronous reset/preset signals
// SJ: Synchronizer FFs required to have reset to initialize system
           if (rst_d_n == 1'b0) begin
// spyglass enable_block STARC05-1.3.1.3
// spyglass enable_block STARC-1.3.1.3
             sample_meta     <= {WIDTH{1'b0}};
             sample_syncm1    <= {WIDTH{1'b0}};
             sample_syncl     <= {WIDTH{1'b0}};
// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
           end else if (init_d_n == 1'b0) begin
// leda NTL_CDC02 on
             sample_meta     <= {WIDTH{1'b0}};
             sample_syncm1    <= {WIDTH{1'b0}};
             sample_syncl     <= {WIDTH{1'b0}};
           end else begin
// leda NTL_CDC01_0 off
// LMD: Flip-flop synchronizer detected
// LJ: The flip-flop synchronizer was checked and works as intended.  So, disable LEDA from reporting this warning.
// leda NTL_CLK05 off
// LMD: Asynchronous inputs to a clock system are not clocked twice
// LJ: This module is configured so that the following asynch signals are clocked by 2 flip-flops with different clock edges of the same clock.  So, disable LEDA from reporting this error.
// leda NTL_CDC14 off
// LMD: Control and data signals of a MUX (logic) synchronizer must be stable enough
// LJ: Control and data signals of synchronizers are checked and stable.  So, disable LEDA from reporting this warning.
// leda NTL_CDC15 off
// LMD: A handshake synchronizer must implement the handshake protocol and data stability correctly
// LJ: The handshake protocol and data stability are checked and guarunteed.  So, disable LEDA from reporting this warning.
// leda NTL_CDC06 off
// LMD: CDC control signal must be stable enough
// LJ: CDC control signal is checked and stable.  So, disable LEDA from reporting this warning.
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
             sample_meta     <= next_sample_meta;
// leda NTL_CDC09 on
// leda NTL_CDC06 on
// leda NTL_CDC15 on
// leda NTL_CDC14 on
// leda NTL_CLK05 on
             sample_syncm1    <= next_sample_syncm1;
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
// leda NTL_CDC00 off
// LMD: Clock domain crossing detected
// LJ: The clock domain crossing is intentional and proper synchronization scheme is implemented.  So, disable LEDA from reporting this warning.
             sample_syncl     <= next_sample_syncl;
// leda NTL_CDC00 on
// leda NTL_CDC09 on
// leda NTL_CDC01_0 on
           end
         end

         assign data_d = sample_syncl;
    end
    if ((F_SYNC_TYPE & 7) == 4) begin : GEN_FST4
         reg    [WIDTH-1:0]      sample_meta;
         reg    [WIDTH-1:0]      sample_syncm1;
         reg    [WIDTH-1:0]      sample_syncm2;
         reg    [WIDTH-1:0]      sample_syncl;
         wire   [WIDTH-1:0]      next_sample_meta;
         wire   [WIDTH-1:0]      next_sample_syncm1;
         wire   [WIDTH-1:0]      next_sample_syncm2;
         wire   [WIDTH-1:0]      next_sample_syncl;

  if (TST_MODE == 1) begin : GEN_TST_MODE1
    reg    [WIDTH-1:0]      test_hold;

// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
    assign next_sample_meta      = (test == 1'b0) ? data_s_int : test_hold;
// leda NTL_CDC02 on

// leda S_2C_R off
// LMD: Use rising edge flipflop
// LJ: The module was intentionally implemented to use negative edge clocking flip-flops cells.  So, disable LEDA from reporting this error.
    always @ (negedge clk_d or negedge rst_d_n) begin : test_hold_registers_PROC
// leda S_2C_R on
      if (rst_d_n == 1'b0) begin
        test_hold        <= {WIDTH{1'b0}};
      end else if (init_d_n == 1'b0) begin
        test_hold        <= {WIDTH{1'b0}};
      end else begin
// leda NTL_CLK05 off
// LMD: Asynchronous inputs to a clock system are not clocked twice
// LJ: This module is configured so that the following asynch signals are clocked by 2 flip-flops with different clock edges of the same clock.  So, disable LEDA from reporting this error.
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
        test_hold        <= data_s;
// leda NTL_CDC09 on
// leda NTL_CLK05 on
      end
    end
  end else begin : GEN_TST_MODE0
// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
    assign next_sample_meta      = (test == 1'b0) ? data_s_int : data_s;
// leda NTL_CDC02 on
  end


         assign next_sample_syncm1 = sample_meta;
         assign next_sample_syncm2 = sample_syncm1;
         assign next_sample_syncl  = sample_syncm2;
         always @ (posedge clk_d or negedge rst_d_n) begin : posedge_registers_PROC
// spyglass disable_block STARC-1.3.1.3
// spyglass disable_block STARC05-1.3.1.3
// SMD: Asynchronous reset/preset signals must not be used as non-reset/preset or synchronous reset/preset signals
// SJ: Synchronizer FFs required to have reset to initialize system
           if (rst_d_n == 1'b0) begin
// spyglass enable_block STARC05-1.3.1.3
// spyglass enable_block STARC-1.3.1.3
             sample_meta     <= {WIDTH{1'b0}};
             sample_syncm1    <= {WIDTH{1'b0}};
             sample_syncm2    <= {WIDTH{1'b0}};
             sample_syncl     <= {WIDTH{1'b0}};
// leda NTL_CDC02 off
// LMD: Convergence found in clock domain crossing path
// LJ: Convergence found here doesn't cause problems.  So, disable LEDA from reporting this warning.
           end else if (init_d_n == 1'b0) begin
// leda NTL_CDC02 on
             sample_meta     <= {WIDTH{1'b0}};
             sample_syncm1    <= {WIDTH{1'b0}};
             sample_syncm2    <= {WIDTH{1'b0}};
             sample_syncl     <= {WIDTH{1'b0}};
           end else begin
// leda NTL_CDC01_0 off
// LMD: Flip-flop synchronizer detected
// LJ: The flip-flop synchronizer was checked and works as intended.  So, disable LEDA from reporting this warning.
// leda NTL_CLK05 off
// LMD: Asynchronous inputs to a clock system are not clocked twice
// LJ: This module is configured so that the following asynch signals are clocked by 2 flip-flops with different clock edges of the same clock.  So, disable LEDA from reporting this error.
// leda NTL_CDC14 off
// LMD: Control and data signals of a MUX (logic) synchronizer must be stable enough
// LJ: Control and data signals of synchronizers are checked and stable.  So, disable LEDA from reporting this warning.
// leda NTL_CDC15 off
// LMD: A handshake synchronizer must implement the handshake protocol and data stability correctly
// LJ: The handshake protocol and data stability are checked and guarunteed.  So, disable LEDA from reporting this warning.
// leda NTL_CDC06 off
// LMD: CDC control signal must be stable enough
// LJ: CDC control signal is checked and stable.  So, disable LEDA from reporting this warning.
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
             sample_meta     <= next_sample_meta;
// leda NTL_CDC09 on
// leda NTL_CDC06 on
// leda NTL_CDC15 on
// leda NTL_CDC14 on
// leda NTL_CLK05 on
             sample_syncm1    <= next_sample_syncm1;
             sample_syncm2    <= next_sample_syncm2;
// leda NTL_CDC09 off
// LMD: CDC control signal is part of a bus
// LJ: Either the bus is not a real CDC signal or part of a MUX synchronizer.  So, disable LEDA from reporting this warning.
// leda NTL_CDC00 off
// LMD: Clock domain crossing detected
// LJ: The clock domain crossing is intentional and proper synchronization scheme is implemented.  So, disable LEDA from reporting this warning.
             sample_syncl     <= next_sample_syncl;
// leda NTL_CDC00 on
// leda NTL_CDC09 on
// leda NTL_CDC01_0 on
           end
         end

         assign data_d = sample_syncl;
    end
endgenerate

// leda NTL_CDC01_3 on
// leda NTL_CDC01 on


`ifdef DWC_BCM_SNPS_ASSERT_ON
`ifndef SMIC_SYNTHESIS 
  generate
    if (SVA_TYPE == 1) begin : GEN_SVATP_EQ_1
      DW_axi_x2h_sva01 #(WIDTH, (F_SYNC_TYPE & 7)) P_SYNC_HS (.*);
    end
    if (SVA_TYPE == 2) begin : GEN_SVATP_EQ_2
      DW_axi_x2h_sva05 #(WIDTH, (F_SYNC_TYPE & 7)) P_SYNC_GC (.*);
    end
  endgenerate
`endif // SYNTHESIS
`endif // DWC_BCM_SNPS_ASSERT_ON
endmodule
