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
// Date             :        $Date: 2012/07/23 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_clkcntl.v#29 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_clkcntl.v
// Description : DWC_mobile_storage Clock control
//               Clock divider and card clock generation according
//               to clock divider and clock source register setting.
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_clkcntl(
  /*AUTOARG*/
  // Outputs
  cclk_in_en,
 //SD_3.0 start
  cclk_in_en_ddr,
 divided_clk,
 //SD_3.0 end
 safe_clk_change, cclk_out, data_strv_err, cclk_sample_en,
 //SD_3.0 start
  cclk_sample_en_ddr,
 //SD_3.0 end
  // Inputs
  cclk_in, creset_n, clk_enable, clk_low_power, clk_divider, clk_source,
  cp_card_num, cp_cmd_idle_lp, dp_stop_clk, dp_data_idle,
  stop_clk_ddr_8,stop_clk_in_en,
  data_timeout_cnt, cdata_in_r,scan_mode,
 //MMC_4_4 start
  no_clock_stop_ddr_8,ddr_8_mode,stop_clk_neg_out
 //MMC_4_4 end 
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clock and Reset
  input                        cclk_in;          // Clock input
  input                        creset_n;         // Reset

  output                       cclk_in_en;       // Clock enable
 //SD_3.0 start
  output                       cclk_in_en_ddr;   // Clock enable

 output                       divided_clk;      // tell if the current clk is divided or not.
 //SD_3.0 end

  // Inputs from command path
  input                 [15:0] clk_enable;       // Card clock enable
  input                 [15:0] clk_low_power;    // Clock low power
  input                 [31:0] clk_divider;      // Clock divider
  input                 [31:0] clk_source;       // Clock source
  input                  [3:0] cp_card_num;      // Card selected
  input                        cp_cmd_idle_lp;   // Command idle
  output                       safe_clk_change;  // Safe Clock Change

  //Data path port
  input                        dp_stop_clk;      // Stop clock data throttling
  input                        dp_data_idle;     // Data path idle
  input                 [23:0] data_timeout_cnt; // Data timeout count

  //From muxdemux logic
  input  [`NUM_CARD_BUS*8-1:0] cdata_in_r;       // Card Data Input
  input                        scan_mode;        // Scan mode
  input                        no_clock_stop_ddr_8; // Indication not to
                                                    // stop the clock when
                                                    // CRC16 is received.
  input                        ddr_8_mode;       // Indicates 8-bit DDR
                                                 // mode of operation
  // Card interface
  output   [`NUM_CARD_BUS-1:0] cclk_out;         // Card Clock Out

  // To BIU
  output                       data_strv_err;    // Data stravation error

  output                [15:0] cclk_sample_en;   // Clock sample enable
 //SD_3.0 start
  output               [15:0] cclk_sample_en_ddr;   // Clock sample enable
 //SD_3.0 end
 //MMC_4_4 start
  output                       stop_clk_ddr_8;   // Stop clock indication, used
  output                       stop_clk_in_en;   // in 8-bit DDR mode only.
 //MMC_4_4 end
  output  [`NUM_CARD_BUS-1:0]  stop_clk_neg_out;  // Output signal to be used in muxdemux module 


  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  integer i, j, k, l, m, n;

  // Registers
  reg               [15:0] clk_out_en;           // Clock out en for each card
 //SD_3.0 start
 
  reg               [15:0] clk_out_en_ddr;       // Clock out en for each card in ddr mode
 //SD_3.0 end
  reg               [15:0] stop_clk_neg;         // Stop clock
  wire [`NUM_CARD_BUS-1:0] cclk_out;             // Card clock out
  reg               [15:0] clk_bypass;           // Clock bypass
  wire              [15:0] clk_out_tmp;          // Clk_out emp
  reg                [7:0] clk_count [3:0];      // Clock count array

  wire               [7:0] clk_count_0;
  wire               [7:0] clk_count_1;
  wire               [7:0] clk_count_2;
  wire               [7:0] clk_count_3;
  //8 bit DDr start
  reg              [7:0] clk_count_ddr [3:0];      // Clock count array
 //8 bit ddr end
 
 //SD_3.0 start
  wire               [1:0] current_clk_source;
 reg                [7:0] current_clk_div;
 wire                     divided_clk;
 wire                     divided_by_two; 
 //SD_3.0 end
  reg                [7:0] clk_div_counter [3:0];// Clk div counter array
 reg                [7:0] clk_div_counter_ddr [3:0];// Clk div counter array

  reg                [3:0] clk_div_out;          // Clk div out
 reg                [3:0] clk_div_out_ddr;          // Clk div out

  reg                [3:0] clk_div_bypass;       // Clk div bypass
 //8 bit ddr start
  reg                [3:0] clk_div_bypass_ddr;       // Clk div bypass
 //8 bit ddr end
  reg               [15:0] stop_clk_data;        // Stop clk data
 //SD_3.0 start
 reg               [15:0] stop_clk_data_1;        // Stop clk data
 reg               [15:0] stop_clk_data_1_r;        // Stop clk data
 reg               [15:0] stop_clk_data_2;        // Stop clk data
 wire              [15:0] stop_clk_data_3;        // Stop clk data
  reg               [15:0] stop_clk_data_4;        // Stop clk data for ddr_8 bit only.

  wire              [15:0] stop_clk_data_ddr;        // Stop clk data
  reg              [15:0] cclk_sample_en_ddr_test;
 //SD_3.0 end
  reg                [2:0] low_pwr_cntr [15:0];  // Clk low power counter array
  reg               [15:0] low_pwr_cntr_zero;    // Clk low power counter zero
  reg               [15:0] card_not_idle;        // Card not idle
  reg               [23:0] data_strv_cntr;       // Data starvation counter


  // Wires
  wire                     all_clk_disable;     // All clk disable
  wire               [3:0] clk_div_cntr_zero;   // Clk div counter zero
  wire               [3:0] clk_div_cntr_zero_ddr;   // Clk div counter zero

 
  wire               [3:0] clk_div_en;          // Clk div enable
 //SD_3.0 start
  wire               [3:0] clk_div_en_ddr;      // Clk div enable for ddr only

 wire                     cclk_in_enable;      // Clk enable for selected card
 wire                     cclk_in_enable_ddr; // Clk enable for selected card for ddr
 //SD_3.0 end
  wire                     stop_clk_tmp;        // Posedge stop clock
  wire                     stop_clk_in_en;
   wire                    stop_clk_tmp_ddr;        // Posedge stop clock

  reg              [15:0] cclk_sample_en;       // Clock sample enable
 reg              [15:0] cclk_sample_en_ddr;       // Clock sample enable

  wire                    cclk_in_or_scan;
  wire             [15:0] cclk_in_outtmp,cclk_out_int;
  wire                    stop_clk;
 wire                    cclk_out_en_clk;
  wire                    stop_clk_ddr_8;
 reg                     no_clock_stop_ddr_8_r;
  // Create temp. array
  always @ (clk_divider)
  begin
    {clk_count[3], clk_count[2], clk_count[1], clk_count[0]} = clk_divider;
  end

  assign clk_count_0 = clk_count[0];
  assign clk_count_1 = clk_count[1];
  assign clk_count_2 = clk_count[2];
  assign clk_count_3 = clk_count[3];

 always @ (clk_count_0 or clk_count_1 or
            clk_count_2 or clk_count_3)
  begin
    clk_count_ddr[3] = clk_count_3 >> 1;
   clk_count_ddr[2] = clk_count_2 >> 1;
    clk_count_ddr[1] = clk_count_1 >> 1;
    clk_count_ddr[0] = clk_count_0 >> 1;
 end 

  

  assign cclk_in_en      = cclk_in_enable && ~stop_clk_tmp;
  assign cclk_in_enable  = clk_out_en[cp_card_num];

 //SD_3.0 start
  assign cclk_in_en_ddr      = cclk_in_enable_ddr && ~stop_clk_tmp_ddr;
  assign cclk_in_enable_ddr  = clk_out_en_ddr[cp_card_num];


 //SD_3.0 end


  always @ (clk_out_en or clk_out_en_ddr or stop_clk_data or clk_enable
            or low_pwr_cntr_zero or clk_low_power or stop_clk_data_ddr)
    begin
     cclk_sample_en     =  clk_out_en & ~(stop_clk_data | ~(clk_enable) |
                           (low_pwr_cntr_zero & clk_low_power));
     //SD_3.0 start

    //cclk_sample_en_ddr     =  clk_out_en_ddr & ~(stop_clk_data | ~(clk_enable) |
     //                      (low_pwr_cntr_zero & clk_low_power));  
    cclk_sample_en_ddr     =  clk_out_en_ddr & ~(stop_clk_data_ddr | ~(clk_enable) |
                            (low_pwr_cntr_zero & clk_low_power));
                                                                                                        
      cclk_sample_en_ddr_test     =  clk_out_en_ddr & ~(~(clk_enable) |
                            (low_pwr_cntr_zero & clk_low_power));

   //SD_3.0 end
    end

  //SD_3.0 start
`ifdef IMPLEMENT_SCAN_MUX   
    DWC_mobile_storage_clk_mux_2x1
     U_scan_clk_mux_2x1_new
   (
     .in0_clk(cclk_in),
     .in1_clk(~cclk_in),
     .clk_sel(scan_mode),
     .out_clk(cclk_out_en_clk)
   );
 `else
    assign cclk_out_en_clk = cclk_in;
 `endif 
 
  reg  [`NUM_CARD_BUS-1:0]cclk_out_en_neg;
       always @ (negedge cclk_out_en_clk or  negedge creset_n )
     begin
       if(~creset_n)
         cclk_out_en_neg <= {`NUM_CARD_BUS{1'b1}};
       else
         cclk_out_en_neg <= cclk_sample_en;
     end
  // for undivided clk and div by 2
   always @(posedge cclk_in or negedge creset_n)         
   begin
     if(~creset_n)
       stop_clk_data_1 <= 16'h0000;
     else if(cclk_sample_en_ddr_test[cp_card_num] && stop_clk_data[cp_card_num])
       stop_clk_data_1[cp_card_num] <= 1'b1;
     else if(cclk_out_en_neg[cp_card_num] && !stop_clk_data[cp_card_num])
       stop_clk_data_1[cp_card_num] <= 1'b0;
   end
 always @(posedge cclk_in or negedge creset_n)         
   begin
     if(~creset_n)
       stop_clk_data_4 <= 16'h0000;
     else if(!cclk_sample_en_ddr_test[cp_card_num] && stop_clk_data[cp_card_num])
       stop_clk_data_4[cp_card_num] <= 1'b1;
     else if(cclk_out_en_neg[cp_card_num] && !stop_clk_data[cp_card_num])
       stop_clk_data_4[cp_card_num] <= 1'b0;
   end

  
  // for divided clk, when division is greater than 2      
   always @(negedge cclk_out_en_clk or negedge creset_n)         
   begin
     if(~creset_n)
       stop_clk_data_2 <= 16'h0000;
     else if(cclk_sample_en_ddr_test[cp_card_num] && stop_clk_data[cp_card_num])
       stop_clk_data_2[cp_card_num] <= 1'b1;
     else if(cclk_out_en_neg[cp_card_num] && !stop_clk_data[cp_card_num])
       stop_clk_data_2[cp_card_num] <= 1'b0;
   end
  // Delayed so that the enables is generated for full clk   
   always @(posedge cclk_in or negedge creset_n)    
     begin
       if(~creset_n)
         begin
           stop_clk_data_1_r <= 16'h0000;
           no_clock_stop_ddr_8_r <= 1'b0;
         end
      else 
        begin
          stop_clk_data_1_r <= stop_clk_data_1;
          no_clock_stop_ddr_8_r <=  no_clock_stop_ddr_8;
        end
  end
    // Done so as to generate stop_clk_data_3; stop clk for div >2 with 1/2 clk delay.
   assign stop_clk_data_3 = (stop_clk_data_2 & (stop_clk_data_1 | stop_clk_data_1_r));  

   assign stop_clk_data_ddr = ddr_8_mode ? stop_clk_data_4 :(!divided_clk || divided_by_two) ? stop_clk_data_1 : stop_clk_data_3 ;     
                                        
   //SD_3.0 end

  assign all_clk_disable = ~(|clk_enable);
  assign safe_clk_change = (&low_pwr_cntr_zero);

  // 4 Clock-Dividers generating the clock, clock-enable, and clock
  // bypass information

  // Generate these in assign statements instead in a loop, since you can't
  // have a array in the combinational block sensitive list
  assign clk_div_cntr_zero[0] = (clk_div_counter[0] == 8'h0);
  assign clk_div_cntr_zero[1] = (clk_div_counter[1] == 8'h0);
  assign clk_div_cntr_zero[2] = (clk_div_counter[2] == 8'h0);
  assign clk_div_cntr_zero[3] = (clk_div_counter[3] == 8'h0);

  assign clk_div_cntr_zero_ddr[0] = (clk_div_counter_ddr[0] == 8'h0);
  assign clk_div_cntr_zero_ddr[1] = (clk_div_counter_ddr[1] == 8'h0);
  assign clk_div_cntr_zero_ddr[2] = (clk_div_counter_ddr[2] == 8'h0);
  assign clk_div_cntr_zero_ddr[3] = (clk_div_counter_ddr[3] == 8'h0);

  assign clk_div_en = clk_div_bypass | ((clk_div_cntr_zero |
                      {4{all_clk_disable}}) & ~clk_div_out);

 //SD_3.0 start
 // clk_div_en_ddr triggers when the clk_div_cntr_zero turns zero and the clk_div_out
 // is high. this would mean that the clk_div_en_ddr signal would be high for the
 // negetive egde of the card clock 
  assign clk_div_en_ddr = clk_div_bypass | ((clk_div_cntr_zero |
                      {4{all_clk_disable}}) & clk_div_out);
           
 //SD_3.0 end

  always @(posedge cclk_in or negedge creset_n)
    begin
      if(~creset_n)
        begin
          clk_div_bypass     <= 4'h0;
     clk_div_bypass_ddr <= 4'h0;
          clk_div_out        <= 4'h0;
     clk_div_out_ddr    <= 4'h0;
          clk_div_counter[0] <= 8'h0;
          clk_div_counter[1] <= 8'h0;
          clk_div_counter[2] <= 8'h0;
          clk_div_counter[3] <= 8'h0;
     clk_div_counter_ddr[0] <= 8'h0;
          clk_div_counter_ddr[1] <= 8'h0;
          clk_div_counter_ddr[2] <= 8'h0;
          clk_div_counter_ddr[3] <= 8'h0;
        end
      else
        begin
          for(i=0; i <= 3; i=i+1)
            begin
              clk_div_bypass[i] <= (clk_count[i] == 8'h0);
       clk_div_bypass_ddr[i] <= (clk_count_ddr[i] == 8'h0);

              if(clk_div_cntr_zero[i] | all_clk_disable)
                begin
                  clk_div_counter[i] <= clk_count[i] - 1;
                  clk_div_out[i]     <= ~clk_div_out[i];
                end
              else
                begin
                  clk_div_counter[i] <= clk_div_counter[i] - 1;
                  clk_div_out[i]     <= clk_div_out[i];
                end
        
              if(clk_div_cntr_zero_ddr[i] | all_clk_disable)
                begin
                  clk_div_counter_ddr[i] <= clk_count_ddr[i] - 1;
                  clk_div_out_ddr[i]     <= ~clk_div_out_ddr[i];
                end
              else
                begin
                  clk_div_counter_ddr[i] <= clk_div_counter_ddr[i] - 1;
                  clk_div_out_ddr[i]     <= clk_div_out_ddr[i];
                end        
            end
        end
    end
  //SD_3.0 start
  // To detect if divided or undivided clk is used.
 assign current_clk_source = {clk_source[cp_card_num*2+1],clk_source[cp_card_num*2]};
 
  always @ (clk_divider or current_clk_source)
    begin
      case (current_clk_source)
        2'b00: current_clk_div = clk_divider[7:0];
        2'b01: current_clk_div = clk_divider[15:8];
        2'b10: current_clk_div = clk_divider[23:16];
        default: current_clk_div = clk_divider[31:24];
      endcase
    end
  assign divided_clk =  (current_clk_div == 8'h00) ? 1'b0 : 1'b1;
 assign divided_by_two = (current_clk_div == 8'h01) ? 1'b1 : 1'b0;

  // For each one the 16-clocks, select the output from a clock-divider
  always @ (clk_source or clk_div_bypass or clk_div_en or clk_div_en_ddr )
    begin
      for(j=0; j <= 15; j=j+1)
        begin
//          clk_out_tmp[j] = clk_div_out[{clk_source[j*2+1],clk_source[j*2]}];
          clk_bypass[j]  = clk_div_bypass[{clk_source[j*2+1],clk_source[j*2]}];
          clk_out_en[j]  = clk_div_en[{clk_source[j*2+1],clk_source[j*2]}];
     clk_out_en_ddr[j]  = clk_div_en_ddr[{clk_source[j*2+1],clk_source[j*2]}];
        end
    end
//SD_3.0 end
  // Final clock out generation

/* always @ (stop_clk_neg or clk_bypass or clk_out_tmp or cclk_in or scan_mode)
    begin
      for(k=0; k < `NUM_CARD_BUS; k=k+1)
        cclk_out[k]  = stop_clk_neg[k] & (clk_bypass[k]? (cclk_in | scan_mode) :
                                                          clk_out_tmp[k]);
    end
*/
 assign stop_clk_neg_out = stop_clk_neg;

  //Instantiate clk OR logic
  DWC_mobile_storage_clk_or
   U_clk_or
  (
    .A(cclk_in),
    .B(scan_mode),
    .Y(cclk_in_or_scan)
  );

  //Card 0 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_0
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[1:0]),
    .out_clk(clk_out_tmp[0])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_0
  (
    .in0_clk(clk_out_tmp[0]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[0]),
    .out_clk(cclk_in_outtmp[0])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and0
  (
    .A(stop_clk_neg[0]),
    .B(cclk_in_outtmp[0]),
    .Y(cclk_out_int[0])
  );

  //Card 1 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_1
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[3:2]),
    .out_clk(clk_out_tmp[1])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_1
  (
    .in0_clk(clk_out_tmp[1]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[1]),
    .out_clk(cclk_in_outtmp[1])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and1
  (
    .A(stop_clk_neg[1]),
    .B(cclk_in_outtmp[1]),
    .Y(cclk_out_int[1])
  );

  //Card 2 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_2
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[5:4]),
    .out_clk(clk_out_tmp[2])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_2
  (
    .in0_clk(clk_out_tmp[2]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[2]),
    .out_clk(cclk_in_outtmp[2])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and2
  (
    .A(stop_clk_neg[2]),
    .B(cclk_in_outtmp[2]),
    .Y(cclk_out_int[2])
  );

  //Card 3 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_3
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[7:6]),
    .out_clk(clk_out_tmp[3])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_3
  (
    .in0_clk(clk_out_tmp[3]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[3]),
    .out_clk(cclk_in_outtmp[3])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and3
  (
    .A(stop_clk_neg[3]),
    .B(cclk_in_outtmp[3]),
    .Y(cclk_out_int[3])
  );

  //Card 4 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_4
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[9:8]),
    .out_clk(clk_out_tmp[4])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_4
  (
    .in0_clk(clk_out_tmp[4]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[4]),
    .out_clk(cclk_in_outtmp[4])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and4
  (
    .A(stop_clk_neg[4]),
    .B(cclk_in_outtmp[4]),
    .Y(cclk_out_int[4])
  );

  //Card 5 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_5
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[11:10]),
    .out_clk(clk_out_tmp[5])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_5
  (
    .in0_clk(clk_out_tmp[5]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[5]),
    .out_clk(cclk_in_outtmp[5])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and5
  (
    .A(stop_clk_neg[5]),
    .B(cclk_in_outtmp[5]),
    .Y(cclk_out_int[5])
  );

  //Card 6 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_6
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[13:12]),
    .out_clk(clk_out_tmp[6])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_6
  (
    .in0_clk(clk_out_tmp[6]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[6]),
    .out_clk(cclk_in_outtmp[6])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and6
  (
    .A(stop_clk_neg[6]),
    .B(cclk_in_outtmp[6]),
    .Y(cclk_out_int[6])
  );

  //Card 7 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_7
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[15:14]),
    .out_clk(clk_out_tmp[7])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_7
  (
    .in0_clk(clk_out_tmp[7]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[7]),
    .out_clk(cclk_in_outtmp[7])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and7
  (
    .A(stop_clk_neg[7]),
    .B(cclk_in_outtmp[7]),
    .Y(cclk_out_int[7])
  );

  //Card 8 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_8
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[17:16]),
    .out_clk(clk_out_tmp[8])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_8
  (
    .in0_clk(clk_out_tmp[8]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[8]),
    .out_clk(cclk_in_outtmp[8])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and8
  (
    .A(stop_clk_neg[8]),
    .B(cclk_in_outtmp[8]),
    .Y(cclk_out_int[8])
  );

  //Card 9 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_9
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[19:18]),
    .out_clk(clk_out_tmp[9])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_9
  (
    .in0_clk(clk_out_tmp[9]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[9]),
    .out_clk(cclk_in_outtmp[9])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and9
  (
    .A(stop_clk_neg[9]),
    .B(cclk_in_outtmp[9]),
    .Y(cclk_out_int[9])
  );

  //Card 10 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_10
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[21:20]),
    .out_clk(clk_out_tmp[10])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_10
  (
    .in0_clk(clk_out_tmp[10]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[10]),
    .out_clk(cclk_in_outtmp[10])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and10
  (
    .A(stop_clk_neg[10]),
    .B(cclk_in_outtmp[10]),
    .Y(cclk_out_int[10])
  );

  //Card 11 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_11
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[23:22]),
    .out_clk(clk_out_tmp[11])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_11
  (
    .in0_clk(clk_out_tmp[11]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[11]),
    .out_clk(cclk_in_outtmp[11])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and11
  (
    .A(stop_clk_neg[11]),
    .B(cclk_in_outtmp[11]),
    .Y(cclk_out_int[11])
  );

  //Card 12 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_12
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[25:24]),
    .out_clk(clk_out_tmp[12])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_12
  (
    .in0_clk(clk_out_tmp[12]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[12]),
    .out_clk(cclk_in_outtmp[12])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and12
  (
    .A(stop_clk_neg[12]),
    .B(cclk_in_outtmp[12]),
    .Y(cclk_out_int[12])
  );

  //Card 13 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_13
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[27:26]),
    .out_clk(clk_out_tmp[13])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_13
  (
    .in0_clk(clk_out_tmp[13]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[13]),
    .out_clk(cclk_in_outtmp[13])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and13
  (
    .A(stop_clk_neg[13]),
    .B(cclk_in_outtmp[13]),
    .Y(cclk_out_int[13])
  );

  //Card 14 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_14
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[29:28]),
    .out_clk(clk_out_tmp[14])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_14
  (
    .in0_clk(clk_out_tmp[14]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[14]),
    .out_clk(cclk_in_outtmp[14])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and14
  (
    .A(stop_clk_neg[14]),
    .B(cclk_in_outtmp[14]),
    .Y(cclk_out_int[14])
  );

  //Card 15 clock logic
  //Instantiate clk mux4x1
  DWC_mobile_storage_clk_mux_4x1
   U_clk_mux_4x1_15
  (
    .in0_clk(clk_div_out[0]),
    .in1_clk(clk_div_out[1]),
    .in2_clk(clk_div_out[2]),
    .in3_clk(clk_div_out[3]),
    .clk_sel(clk_source[31:30]),
    .out_clk(clk_out_tmp[15])
  );
  //Instantiate clk mux2x1
  DWC_mobile_storage_clk_mux_2x1
   U_clk_mux_2x1_15
  (
    .in0_clk(clk_out_tmp[15]),
    .in1_clk(cclk_in_or_scan),
    .clk_sel(clk_bypass[15]),
    .out_clk(cclk_in_outtmp[15])
  );
  //Instantiate clk AND logic 
  DWC_mobile_storage_clk_and
   U_clk_and15
  (
    .A(stop_clk_neg[15]),
    .B(cclk_in_outtmp[15]),
    .Y(cclk_out_int[15])
  );


  assign cclk_out[`NUM_CARD_BUS-1:0] = cclk_out_int[`NUM_CARD_BUS-1:0];

  // Low-Power Mode Clock Trun-off Counter
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if(~creset_n)
        begin
          for(m=0; m <= 15; m=m+1)
            begin
              low_pwr_cntr[m]      <= 3'b111;
              low_pwr_cntr_zero[m] <= 1'b0;
            end
        end
      else
        begin
          for(m=0; m <= 15; m=m+1)
            begin
              low_pwr_cntr_zero[m] <= (low_pwr_cntr[m] == 3'b000);
              if(clk_out_en[m])
                begin
                  if(card_not_idle[m])
                    low_pwr_cntr[m] <= 3'b111;
                  else if(~(low_pwr_cntr[m] == 3'b000))
                    low_pwr_cntr[m] <= low_pwr_cntr[m] - 1;
                end
            end
        end
    end

  // Stop Clock Generation
  always @ (cp_card_num or dp_stop_clk or cp_cmd_idle_lp or dp_data_idle
            or cdata_in_r or no_clock_stop_ddr_8 or no_clock_stop_ddr_8_r)
    begin
      stop_clk_data              = 16'h0;
      stop_clk_data[cp_card_num] = dp_stop_clk & !(no_clock_stop_ddr_8| no_clock_stop_ddr_8_r);

      card_not_idle              = 16'h0;
      for (l=0; l<`NUM_CARD_BUS; l=l+1)
        begin
          if (l == cp_card_num)
            card_not_idle[l] = ~cp_cmd_idle_lp | ~dp_data_idle |
                               ~cdata_in_r[l*8];
          else
            card_not_idle[l] = ~cdata_in_r[l*8];
        end
    end

  //For scan mode, the stop_clk_neg flops work on the posedge of cclk_in
`ifdef IMPLEMENT_SCAN_MUX 
  DWC_mobile_storage_clk_mux_2x1
   U_scan_clk_mux_2x1
  (
    .in0_clk(cclk_in),
    .in1_clk(~cclk_in),
    .clk_sel(scan_mode),
    .out_clk(stop_clk)
  );
 `else
   assign stop_clk = cclk_in;
 `endif  


  // Negative edge triggred stop-clock signal to gate the clocks
    always @ (negedge stop_clk or negedge creset_n)
      begin
        if(~creset_n)
          stop_clk_neg <= 16'hffff;
        else
          for(n=0; n <= 15; n=n+1)
            if(clk_out_en[n])
              stop_clk_neg[n] <= ~(stop_clk_data[n] | ~clk_enable[n] |
                                  (low_pwr_cntr_zero[n] & clk_low_power[n]));
      end


  assign  stop_clk_tmp = stop_clk_data[cp_card_num] | ~clk_enable[cp_card_num] |
                         (low_pwr_cntr_zero[cp_card_num] &
                          clk_low_power[cp_card_num]) & !(no_clock_stop_ddr_8|no_clock_stop_ddr_8_r);
    
  assign stop_clk_in_en = stop_clk_tmp & ddr_8_mode;
  assign  stop_clk_tmp_ddr = stop_clk_data_ddr[cp_card_num] | ~clk_enable[cp_card_num] |
                         (low_pwr_cntr_zero[cp_card_num] &
                          clk_low_power[cp_card_num]) & !(no_clock_stop_ddr_8|no_clock_stop_ddr_8_r);
  assign stop_clk_ddr_8 = stop_clk_tmp_ddr & ddr_8_mode;
  // Data starvation logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if(~creset_n)
        data_strv_cntr   <= 24'h0;
      else begin
        if (~dp_stop_clk)
          data_strv_cntr <= data_timeout_cnt;
        else if (cclk_in_enable && ~(data_strv_cntr == 0))
          data_strv_cntr <= data_strv_cntr - 1;
      end
    end
  assign data_strv_err = (data_strv_cntr == 0) && dp_stop_clk;

endmodule // DWC_mobile_storage_clkcntl
