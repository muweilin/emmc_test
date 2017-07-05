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
// Date             :        $Date: 2013/06/03 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_muxdemux.v#70 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_muxdemux.v
// Description : DWC_mobile_storage Mux De-mux Block
//              Registers all the outputs and and inputs on posedge cclk_in
//              qualified cclk_in_en. Card inputs are mux using the card_num
//              and all the outputs are demux - outputs from the
//              command path and data path are routed to card output
//              selected by card_num and others are deactived.
//              All the outputs are register using cclk_in_drv if
//              Hold Register is implemented , Where as all the inputs
//              are first sampled on cclk_in_sample and then register
//              on posedge of cclk_in and qualified by delayed cclk_in_en
//------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_muxdemux(
  /*AUTOARG*/
   // Outputs
   ccmd_out, ccmd_out_en, cdata_out, cdata_out_en, cp_ccmd_in, dp_cdata_in,
   cdata_in_r,
  //SD_3.0 start
   de_interleave_r,
  //SDIO 3.0 start
  card_int_n_dsync,
  dat_int_n_dsync,
  busy_clear_int,
  //SDIO 3.0 ends
  //SD_3.0 ends
   // Inputs
   cclk_in, cclk_in_en, 
  //SD_3.0 start
   cclk_in_en_ddr,
  //SD_3.0 ends
  creset_n, creset_n_sample, creset_n_drv, cclk_in_drv, cclk_in_sample, 
   ccmd_in, cdata_in, cp_card_num, cp_ccmd_out, cp_ccmd_out_en, dp_cdata_out,
   dp_cdata_out_en, cclk_sample_en_cmd, cclk_sample_en_data,
  //SD_3.0 start
   cclk_sample_en_ddr,
   //SD_3.0 ends
  scan_mode,
         stop_clk_neg_out,
  use_hold_reg,
  //SDIO start
   card_int_n,
  //SDIO ends
   //SD_3.0 start
  toggle_n_hold,
  start_rx_data,
  ddr,
  //MMC4_4 start
  cclk_in_en_8_ddr,
  //MMC4_4 ends
  divided_clk,
  //SD_3.0 ends
  half_start_bit,
  enable_shift,
  start_bit_delayed,
  tx_data_done,
  new_cmd_load,
  read_or_write_cmd,
  data_expected
  
   );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------

  // Clock and Reset
  input                        cclk_in;            // Clock
  input                        cclk_in_en;         // Clock enable
 //SD_3.0 start
  input                        cclk_in_en_ddr;     // Clock enable
 //SD_3.0 ends
  input                        creset_n;           // Card Reset - Active Low
  input                        creset_n_sample;    // Reset for Sample clock
  input                        creset_n_drv;       // Reset for Drive clock
  input                        cclk_in_drv;        // Output driver Clock
  input                        cclk_in_sample;     // Input sampler clock
  input                 [15:0] cclk_sample_en_cmd; // Clock sample enable
  input                 [15:0] cclk_sample_en_data;// Clock sample enable
 //SD_3.0 start
  input               [15:0] cclk_sample_en_ddr; // Clock sample enable for negetive edge flopping 
                                                // for input data path only  
 //SD_3.0 ends

  input                        scan_mode;        // Scan mode input
  input    [`NUM_CARD_BUS-1:0] stop_clk_neg_out ;
 //SD_3.0 start
 input    [`NUM_CARD_BUS-1:0] toggle_n_hold;
 input                        start_rx_data;
 input                        ddr;
 //MMC4_4 start                               
 input                        cclk_in_en_8_ddr;
  //MMC4_4 ends
 input                        divided_clk;   // tells if a divided or undivided clk is being used.
 //SD_3.0 ends
  input                        use_hold_reg;  //Control signal from regb which is used to bypass the hold_reg
  //SDIO 3.0 start
  input   [`NUM_CARD_BUS-1:0] card_int_n;
 //SDIO 3.0 ends
  input                        half_start_bit;  
  input    [((`NUM_CARD_BUS*2)-1):0] enable_shift ;
  //card interface
  input    [`NUM_CARD_BUS-1:0] ccmd_in;          // Card Cmd Input
  input  [`NUM_CARD_BUS*8-1:0] cdata_in;         // Card Data Input

  input                        tx_data_done;
  input                        new_cmd_load;
  input                        read_or_write_cmd; // From CMD register
  input                        data_expected;      // From CMD register

  output   [`NUM_CARD_BUS-1:0] ccmd_out;         // Card Cmd Output
  output   [`NUM_CARD_BUS-1:0] ccmd_out_en;      // Card Cmd Output Enable
  output [`NUM_CARD_BUS*8-1:0] cdata_out;        // Card Data Output
  output [`NUM_CARD_BUS*8-1:0] cdata_out_en;     // Card Data Output
  output                       busy_clear_int;

  // cmd path port
  input                  [3:0] cp_card_num;       // Card number
  input                        cp_ccmd_out;       // Card Cmd Output
  input                        cp_ccmd_out_en;    // Card Cmd Output Enable
  output                       cp_ccmd_in;        // Card Cmd Input

  // data path port
  input                  [7:0] dp_cdata_out;      // Card Data Output
  input                  [7:0] dp_cdata_out_en;   // Card Data Output
 //SD_3.0 start
  output                 [7:0] dp_cdata_in;       // Card Data Input ;
                                                 // In DDR mode this has the start bit and the CRC pattern
                         // In normal mode this has both start bits , data and CRC pattern
 output                 [7:0] de_interleave_r;   // In DDR mode this contains the data, in NON-DDR this is un used.
  //SD_3.0 ends
 //SDIO start
  output   [`NUM_CARD_BUS-1:0] card_int_n_dsync;   // Synchronized card_in lines; INT# lines,
 output   [`NUM_CARD_BUS-1:0] dat_int_n_dsync;    // Synchronized DAT[1] lines; specially for Asynchronous interrupt.
 //SDIO ends

//   input       [`CARD_TYPE*3:0] dp_cdata_out;      // Card Data Output
//   input       [`CARD_TYPE*3:0] dp_cdata_out_en;   // Card Data Output
//   output                 [3:0] dp_cdata_in;       // Card Data Input

  // interrupt control
  output [`NUM_CARD_BUS*8-1:0] cdata_in_r;        // Register inputs
  output  start_bit_delayed;



  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  integer                      i,j,k,l,m,n,p;

  // Registers
  reg      [`NUM_CARD_BUS-1:0] hr_ccmd_out;        // Card Cmd Reg
  reg      [`NUM_CARD_BUS-1:0] hr_ccmd_out_en;     // Card Cmd Reg Enable
  reg    [`NUM_CARD_BUS*8-1:0] hr_cdata_out;       // Card Data Reg
  reg    [`NUM_CARD_BUS*8-1:0] hr_cdata_out_en;    // Card Data Reg
 //devashihs start
  reg    [`NUM_CARD_BUS*8-1:0] hr_cdata_out_n_ddr;      // Card Data Reg
  reg    [`NUM_CARD_BUS*8-1:0] hr_cdata_out_en_n_ddr;   // Card Data R
  reg    [`NUM_CARD_BUS*8-1:0] hr_cdata_out_ddr;        // Card Data Reg
  reg    [`NUM_CARD_BUS*8-1:0] hr_cdata_out_en_ddr;     // Card Data R
  //SD_3.0 ends
  //SDIO 3.0 start
  reg   [`NUM_CARD_BUS-1:0] dat_int_n;                  // DAT[1] line
 //SDIO 3.0 ends
  reg    [1:0] enable_shift_mux_sel ;
  // register all the inputs
  reg                          cp_ccmd_in;         // Card Cmd Input
  reg                    [7:0] dp_cdata_in;        // Card Data Input
  reg      [`NUM_CARD_BUS-1:0] ccmd_in_sample;     // Card Cmd Input
  reg    [`NUM_CARD_BUS*8-1:0] cdata_in_sample;    // Card Data Input after muxing from cdata_in_sample_1 & cdata_in_sample_2 
  //SD_3.0 start
  reg    [`NUM_CARD_BUS*8-1:0] cdata_in_sample_2;    // Card Data Input sampled at negedge
  reg    [`NUM_CARD_BUS*8-1:0] cdata_in_sample_1;    // Card Data Input sampled at posedge
  reg                    [3:0] r1;
  reg                    [3:0] r2;
  reg                    [3:0] r3;
  reg                    [3:0] r4;
  reg                    [3:0] r5;
  reg                    [3:0] r6;
  reg                    [7:0] cdata_in_tmp2;
  reg                          ddr_count;
  reg                          ddr_r;               // delayed to work with hold register using cclk_in_drv
  //MMC4_4 start
  reg                          ddr_r1;              // delayed using cclk_in
  reg                          ddr_r2;             //delayed twice using cclk_in_drv
  //MMC4_4 ends
  //SD_3.0 start
  reg                    [7:0] de_interleave;
  reg                    [7:0] de_interleave_r;
  reg                          start_bit_delayed;  //Indicates that the start_bit and data has been delayed by >0.5clk and < 1clk during a Read Transfer
  //SD_3.0 ends
  reg    [`NUM_CARD_BUS*8-1:0] cdata_in_r;          // register data inputs
  reg      [`NUM_CARD_BUS-1:0] cclk_out_en_neg;     // cclk enable for +ve edge FF input path
  reg      [`NUM_CARD_BUS-1:0] cclk_out_en_pos;     // cclk enable for -ve edge FF input path
  reg      [`NUM_CARD_BUS-1:0] cclk_out_en_cmd;//  CMD enables 
  reg      [`NUM_CARD_BUS-1:0] cclk_out_en_data;// Data enables 


  reg      [`NUM_CARD_BUS-1:0] cclk_out_en_neg_cmd; // cclk enable for +ve edge FF input path
  reg      [`NUM_CARD_BUS-1:0] cclk_out_en_neg_data;// cclk enable for +ve edge FF input path
  reg      [`NUM_CARD_BUS-1:0] cclk_out_en_pos_cmd;
  reg      [`NUM_CARD_BUS-1:0] cclk_out_en_nneg_cmd;
  reg      [`NUM_CARD_BUS-1:0] cclk_out_en_pos_data;
  reg      [`NUM_CARD_BUS-1:0] cclk_out_en_nneg_data;


  // temporary registers
  reg                   [15:0] ccmd_out_tmp;      // Temp cmd out reg
  reg                   [15:0] ccmd_out_en_tmp;   // Temp cmd out enable reg
  reg    [`NUM_CARD_BUS*8-1:0] cdata_out_tmp;     // Temp data out reg
  reg    [`NUM_CARD_BUS*8-1:0] cdata_out_en_tmp;  // Temp data out enable reg
//   reg                   [63:0] cdata_out_tmp;     // Temp data out reg
//   reg                   [63:0] cdata_out_en_tmp;  // Temp data out enable reg
  reg                    [7:0] cdata_in_tmp1;     // Temp data input reg
 
//SD_3.0 start
`ifdef HOLD_REGISTER
  reg   [`NUM_CARD_BUS*8-1:0]  hr_cdata_out_r;    // Output HOLD register
  wire  [`NUM_CARD_BUS*8-1:0] cdata_out_1;       // Card Data Reg
   reg   [`NUM_CARD_BUS-1:0]   toggle_n_hold1;    // card clk delayed with cclk_in_drv
  wire  [`NUM_CARD_BUS-1:0]   toggle_n_hold2;    // generated  cclk_in_drv
  reg   [`NUM_CARD_BUS-1:0]   toggle3;           // used to generate toggle_n_hold2
  reg   [`NUM_CARD_BUS-1:0]   toggle4;           // used to generate toggle_n_hold
`else
 wire   [`NUM_CARD_BUS*8-1:0] cdata_out_1;       // Card Data wire
 
`endif
  wire                         cclk_in_en_2;     // This selects between normal enable and ddr anable.
 wire   [`NUM_CARD_BUS-1:0]   toggle;
                                          
 reg [`NUM_CARD_BUS-1:0]   toggle_anded_stopclk; // Signal to stop toggle from toggling when clock is stopeed.
                                                           // This helps avoid toggling of cdata_out in ddr 4-bit mode.
//SD_3.0 ends

  // Wires
  wire                  [15:0] ccmd_in_tmp;       // Temp cmd in
  wire   [`NUM_CARD_BUS*8-1:0] cdata_in_tmp;      // Temp data in
  wire                   [7:0] dp_cdata_out_tmp;  // Temp data out
  wire                   [7:0] dp_cdata_out_en_tmp;// Temp data out enable
  wire                   [6:0] card_num_mul4;     // Temp data out
  wire                   [6:0] card_num_mul4_p1;  // Temp data out
  wire                   [6:0] card_num_mul4_p2;  // Temp data out
  wire                   [6:0] card_num_mul4_p3;  // Temp data out
  wire                   [6:0] card_num_mul4_p4;  // Temp data out
  wire                   [6:0] card_num_mul4_p5;  // Temp data out
  wire                   [6:0] card_num_mul4_p6;  // Temp data out
  wire                   [6:0] card_num_mul4_p7;  // Temp data out
  wire                         cclk_out_en_clk;
 wire                         cclk_in_sample_gen;
 wire                         cclk_in_ddr_gen; //clock generated from cclk_in_ddr needed for -ve edge FF used for DDR
  wire                         cclk_in_ddr;     //clock generated cclk_in or cclk_in_drv used for DDR FF's


  wire                         creset_n_ddr;
 //MMC 4.5 start 
 wire full_start_bit ;

 assign full_start_bit = !half_start_bit;
 //MMC 4.5 ends
  assign dp_cdata_out_tmp    = dp_cdata_out;
  assign dp_cdata_out_en_tmp = dp_cdata_out_en;
  assign card_num_mul4       = {cp_card_num, 3'b000};
  assign card_num_mul4_p1    = card_num_mul4 + 1'b1;
  assign card_num_mul4_p2    = card_num_mul4 + 2'b10;
  assign card_num_mul4_p3    = card_num_mul4 + 2'b11;
  assign card_num_mul4_p4    = card_num_mul4 + 3'b100;
  assign card_num_mul4_p5    = card_num_mul4 + 3'b101;
  assign card_num_mul4_p6    = card_num_mul4 + 3'b110;
  assign card_num_mul4_p7    = card_num_mul4 + 3'b111;

//Generating stop_clk_neg_out on cclk_in_drv
  reg    [`NUM_CARD_BUS-1:0] stop_clk_neg_out_drv ;
 always @ (posedge cclk_in_drv or negedge creset_n)
    begin
      if (~creset_n) 
          stop_clk_neg_out_drv  <=   {`NUM_CARD_BUS{1'b1}};
      else
          stop_clk_neg_out_drv  <= stop_clk_neg_out;
     end   

  //Controlling toggle based on stop_clk_neg_drv
   always @(stop_clk_neg_out_drv or toggle)
     begin
       for (i=0;i<`NUM_CARD_BUS;i=i+ 1)
          begin
            if (stop_clk_neg_out_drv[i])
              toggle_anded_stopclk[i]  = toggle[i];
            else
              toggle_anded_stopclk[i]  = 1'b0;
          end
     end
//SD_3.0 start
  //This is the main selection between the normal mode of working and the ddr mode of working.
  assign cclk_in_en_2 = ddr ? cclk_in_en_ddr : cclk_in_en;

  DWC_mobile_storage_clkmux_interleave
   U_DWC_mobile_storage_clkmux_interleave
  (
 //Outputs
   .cdata_out_int(cdata_out[`NUM_CARD_BUS*8-1:0]),
 //Inputs
   .toggle       (toggle_anded_stopclk[`NUM_CARD_BUS-1:0]),
   .cdata_out_1  (cdata_out_1[`NUM_CARD_BUS*8-1:0]),
    .ddr          (ddr)
  );


 // The clock input to the DDR register is selected between cclk_in and clk_in_drv 
 // depending on if the Hold Register is bypassed or not.
 `ifdef HOLD_REGISTER
   DWC_mobile_storage_clk_mux_2x1
    U_drv_clk_mux_2x1_ddr
   (
     .in0_clk(cclk_in),
     .in1_clk(cclk_in_drv),
     .clk_sel(use_hold_reg),
     .out_clk(cclk_in_ddr)
   );
 `else
   assign cclk_in_ddr  = cclk_in_drv;
 `endif

  //use creset_n_drv for the ddr output FF's because when hreset or soft reset is asserted the value of use_hold_reg
  //will become 1'b1 and so cclk_in_ddr will be equal to cclk_in_drv after reset.
  assign creset_n_ddr = creset_n_drv;
 
 
 `ifdef IMPLEMENT_SCAN_MUX
    DWC_mobile_storage_clk_mux_2x1
     U_scan_clk_mux_2x1_ddr_gen
    (
      .in0_clk(cclk_in_ddr),
      .in1_clk(~cclk_in_ddr),
      .clk_sel(scan_mode),
      .out_clk(cclk_in_ddr_gen)
    );

 
   DWC_mobile_storage_clk_mux_2x1
    U_scan_clk_mux_2x1_sample
   (
     .in0_clk(cclk_in_sample),
     .in1_clk(~cclk_in_sample),
     .clk_sel(scan_mode),
     .out_clk(cclk_in_sample_gen)
   );
  
 `else
    assign cclk_in_ddr_gen = cclk_in_ddr;
  assign cclk_in_sample_gen = cclk_in_sample;
 `endif  




 //MMC4_4 start
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
        begin
          hr_ccmd_out           <=   {`NUM_CARD_BUS{1'b1}};
          hr_ccmd_out_en        <=   {`NUM_CARD_BUS{1'b0}}; // disable output
        end
      else 
        begin
          if (cclk_in_en) 
            begin
              if (`CARD_TYPE == 0) 
                begin // only for MMC mode
                   hr_ccmd_out       <= cp_ccmd_out;
                   hr_ccmd_out_en    <= cp_ccmd_out_en;
                end 
              else 
                begin           // for SD Mode
                  hr_ccmd_out       <= ccmd_out_tmp[`NUM_CARD_BUS-1:0];
                  hr_ccmd_out_en    <= ccmd_out_en_tmp[`NUM_CARD_BUS-1:0];
                end
            end
        end
    end
  // MMC4_4 ends
  // output register logic for [7:4] in non ddr mode
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
        begin
          for(k=4;k<=`NUM_CARD_BUS*8-1;k=k+8) 
            begin  //4,12,20,28......
              hr_cdata_out_n_ddr[k]            <=   1'b1; //[7:4] , [15:12] , [23:20].....
              hr_cdata_out_n_ddr[k+1]          <=   1'b1; 
              hr_cdata_out_n_ddr[k+2]          <=   1'b1; 
              hr_cdata_out_n_ddr[k+3]          <=   1'b1; 
              hr_cdata_out_en_n_ddr[k]         <=   1'b0; // disable outputs //[7:4] , [15:12] , [23:20].....
              hr_cdata_out_en_n_ddr[k+1]       <=   1'b0; 
              hr_cdata_out_en_n_ddr[k+2]       <=   1'b0;
              hr_cdata_out_en_n_ddr[k+3]       <=   1'b0;      
            end 
         end 
      else 
         begin
   //MMC4_4 start
           if (/*cclk_in_en*/ cclk_in_en_8_ddr)
              begin
    //MMC4_4 ends
                if (`CARD_TYPE == 0) 
                   begin // only for MMC mode
                     for(k=4;k<=`NUM_CARD_BUS*8-1;k=k+8) 
                       begin //4,12,20,28......
                         hr_cdata_out_n_ddr[k]        <= dp_cdata_out[0];    //[7:4] , [15:12] , [23:20].....
                         hr_cdata_out_n_ddr[k+1]      <= dp_cdata_out[1];
                         hr_cdata_out_n_ddr[k+2]      <= dp_cdata_out[2];
                         hr_cdata_out_n_ddr[k+3]      <= dp_cdata_out[3];
                         hr_cdata_out_en_n_ddr[k]     <= dp_cdata_out_en[0]; //[7:4] , [15:12] , [23:20].....
                         hr_cdata_out_en_n_ddr[k+1]   <= dp_cdata_out_en[1];
                         hr_cdata_out_en_n_ddr[k+2]   <= dp_cdata_out_en[2];
                         hr_cdata_out_en_n_ddr[k+3]   <= dp_cdata_out_en[3];
                       end 
                   end 
                else 
                  begin           // for SD Mode
                    for(k=4;k<=`NUM_CARD_BUS*8-1;k=k+8)
                       begin  //4,12,20,28......
                         hr_cdata_out_n_ddr[k]         <= cdata_out_tmp[k];   //[7:4] , [15:12] , [23:20].....
                         hr_cdata_out_n_ddr[k+1]       <= cdata_out_tmp[k+1]; 
                         hr_cdata_out_n_ddr[k+2]       <= cdata_out_tmp[k+2]; 
                         hr_cdata_out_n_ddr[k+3]       <= cdata_out_tmp[k+3]; 
                         hr_cdata_out_en_n_ddr[k]      <= cdata_out_en_tmp[k];//[7:4] , [15:12] , [23:20].....
                         hr_cdata_out_en_n_ddr[k+1]    <= cdata_out_en_tmp[k+1];
                         hr_cdata_out_en_n_ddr[k+2]    <= cdata_out_en_tmp[k+2];
                         hr_cdata_out_en_n_ddr[k+3]    <= cdata_out_en_tmp[k+3];        
                       end   
                  end
              end
         end
    end

  //output register logic for [7:4] in ddr mode
  always @ (negedge cclk_in_ddr_gen or negedge creset_n_ddr)
    begin
      if (~creset_n_ddr) 
        begin
          for(k=4;k<=`NUM_CARD_BUS*8-1;k=k+8)
            begin  //4,12,20,28......
              hr_cdata_out_ddr[k]            <=   1'b1; //[7:4] , [15:12] , [23:20].....
              hr_cdata_out_ddr[k+1]          <=   1'b1; 
              hr_cdata_out_ddr[k+2]          <=   1'b1; 
              hr_cdata_out_ddr[k+3]          <=   1'b1; 
              hr_cdata_out_en_ddr[k]         <=   1'b0; // disable outputs //[7:4] , [15:12] , [23:20].....
              hr_cdata_out_en_ddr[k+1]       <=   1'b0; 
              hr_cdata_out_en_ddr[k+2]       <=   1'b0;
              hr_cdata_out_en_ddr[k+3]       <=   1'b0;      
            end 
        end 
      else 
        begin
          if (cclk_in_en_2) 
            begin
              if (`CARD_TYPE == 0) 
                 begin // only for MMC mode
                   for(k=4;k<=`NUM_CARD_BUS*8-1;k=k+8)
                     begin //4,12,20,28......
                       hr_cdata_out_ddr[k]        <= dp_cdata_out[0];    //[7:4] , [15:12] , [23:20].....
                       hr_cdata_out_ddr[k+1]      <= dp_cdata_out[1];
                       hr_cdata_out_ddr[k+2]      <= dp_cdata_out[2];
                       hr_cdata_out_ddr[k+3]      <= dp_cdata_out[3];
                       hr_cdata_out_en_ddr[k]     <= dp_cdata_out_en[0]; //[7:4] , [15:12] , [23:20].....
                       hr_cdata_out_en_ddr[k+1]   <= dp_cdata_out_en[1];
                       hr_cdata_out_en_ddr[k+2]   <= dp_cdata_out_en[2];
                       hr_cdata_out_en_ddr[k+3]   <= dp_cdata_out_en[3];
                     end 
                 end 
              else 
                begin           // for SD Mode
                  for(k=4;k<=`NUM_CARD_BUS*8-1;k=k+8) 
                    begin  //4,12,20,28......
                      hr_cdata_out_ddr[k]         <= cdata_out_tmp[k];   //[7:4] , [15:12] , [23:20].....
                      hr_cdata_out_ddr[k+1]       <= cdata_out_tmp[k+1]; 
                      hr_cdata_out_ddr[k+2]       <= cdata_out_tmp[k+2]; 
                      hr_cdata_out_ddr[k+3]       <= cdata_out_tmp[k+3]; 
                      hr_cdata_out_en_ddr[k]      <= cdata_out_en_tmp[k];//[7:4] , [15:12] , [23:20].....
                      hr_cdata_out_en_ddr[k+1]    <= cdata_out_en_tmp[k+1];
                      hr_cdata_out_en_ddr[k+2]    <= cdata_out_en_tmp[k+2];
                      hr_cdata_out_en_ddr[k+3]    <= cdata_out_en_tmp[k+3];        
                    end   
                end
        end
      end
    end

  
    
  // output register logic for [3:0] bits for non ddr only
    always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
         begin
           for(l=0;l<=`NUM_CARD_BUS*8-1;l=l+8) 
             begin                 //0,8,16,24.......
               hr_cdata_out_n_ddr[l]            <=   1'b1; //[3:0] , [11:8] , [19:16].....
               hr_cdata_out_n_ddr[l+1]          <=   1'b1; 
               hr_cdata_out_n_ddr[l+2]          <=   1'b1;
               hr_cdata_out_n_ddr[l+3]          <=   1'b1;
               hr_cdata_out_en_n_ddr[l]         <=   1'b0; // disable outputs //[3:0] , [11:8] , [19:16]......
               hr_cdata_out_en_n_ddr[l+1]       <=   1'b0;
               hr_cdata_out_en_n_ddr[l+2]       <=   1'b0;
               hr_cdata_out_en_n_ddr[l+3]       <=   1'b0;
             end 
         end 
      else 
        begin
   //MMC4_4 starts
          if (/*cclk_in_en*/cclk_in_en_8_ddr) 
             begin
   //MMC4_4 ends 
               if (`CARD_TYPE == 0) 
                 begin // only for MMC mode
                   for(l=0;l<=`NUM_CARD_BUS*8-1;l=l+8) 
                     begin             //0,8,16,24.......
                       hr_cdata_out_n_ddr[l]        <= dp_cdata_out[0];//[3:0] , [11:8] , [19:16].....
                       hr_cdata_out_n_ddr[l+1]      <= dp_cdata_out[1];
                       hr_cdata_out_n_ddr[l+2]      <= dp_cdata_out[2];
                       hr_cdata_out_n_ddr[l+3]      <= dp_cdata_out[3];
                       hr_cdata_out_en_n_ddr[l]     <= dp_cdata_out_en[0];//[3:0] , [11:8] , [19:16].....
                       hr_cdata_out_en_n_ddr[l+1]   <= dp_cdata_out_en[1];
                       hr_cdata_out_en_n_ddr[l+2]   <= dp_cdata_out_en[2];
                       hr_cdata_out_en_n_ddr[l+3]   <= dp_cdata_out_en[3];
                     end 
                 end
               else 
                 begin           // for SD Mode
            //hr_cdata_out      <= cdata_out_tmp[`NUM_CARD_BUS*8-1:0];
            //hr_cdata_out_en   <= cdata_out_en_tmp[`NUM_CARD_BUS*8-1:0];
                   for(l=0;l<=`NUM_CARD_BUS*8-1;l=l+8) 
                     begin             //0,8,16,24.......
                       hr_cdata_out_n_ddr[(l)]        <= cdata_out_tmp[l];//[3:0] , [11:8] , [19:16].....
                       hr_cdata_out_n_ddr[(l)+1]      <= cdata_out_tmp[l+1];
                       hr_cdata_out_n_ddr[(l)+2]      <= cdata_out_tmp[l+2];
                       hr_cdata_out_n_ddr[(l)+3]      <= cdata_out_tmp[l+3];
                       hr_cdata_out_en_n_ddr[(l)]     <= cdata_out_en_tmp[l];//[3:0] , [11:8] , [19:16].....
                       hr_cdata_out_en_n_ddr[(l)+1]   <= cdata_out_en_tmp[l+1];
                       hr_cdata_out_en_n_ddr[(l)+2]   <= cdata_out_en_tmp[l+2];
                       hr_cdata_out_en_n_ddr[(l)+3]   <= cdata_out_en_tmp[l+3];       
                     end   
                 end
             end
        end
    end

  

  // output register logic for [3:0] bits for ddr only
   always @ (negedge cclk_in_ddr_gen or negedge creset_n_ddr)
    begin
      if (~creset_n_ddr) 
        begin
          for(n=0;n<=`NUM_CARD_BUS*8-1;n=n+8)
            begin                 //0,8,16,24.......
              hr_cdata_out_ddr[n]            <=   1'b1; //[3:0] , [11:8] , [19:16].....
              hr_cdata_out_ddr[n+1]          <=   1'b1; 
              hr_cdata_out_ddr[n+2]          <=   1'b1;
              hr_cdata_out_ddr[n+3]          <=   1'b1;
              hr_cdata_out_en_ddr[n]         <=   1'b0; // disable outputs //[3:0] , [11:8] , [19:16]......
              hr_cdata_out_en_ddr[n+1]       <=   1'b0;
              hr_cdata_out_en_ddr[n+2]       <=   1'b0;
              hr_cdata_out_en_ddr[n+3]       <=   1'b0;
            end 
        end 
      else 
        begin
          if (cclk_in_en) 
             begin
               if (`CARD_TYPE == 0) 
                 begin // only for MMC mode
                   for(n=0;n<=`NUM_CARD_BUS*8-1;n=n+8) 
                      begin             //0,8,16,24.......
                        hr_cdata_out_ddr[n]        <= dp_cdata_out[0];//[3:0] , [11:8] , [19:16].....
                        hr_cdata_out_ddr[n+1]      <= dp_cdata_out[1];
                        hr_cdata_out_ddr[n+2]      <= dp_cdata_out[2];
                        hr_cdata_out_ddr[n+3]      <= dp_cdata_out[3];
                        hr_cdata_out_en_ddr[n]     <= dp_cdata_out_en[0];//[3:0] , [11:8] , [19:16].....
                        hr_cdata_out_en_ddr[n+1]   <= dp_cdata_out_en[1];
                        hr_cdata_out_en_ddr[n+2]   <= dp_cdata_out_en[2];
                        hr_cdata_out_en_ddr[n+3]   <= dp_cdata_out_en[3];
                      end 
                 end 
               else
                 begin           // for SD Mode
            //hr_cdata_out      <= cdata_out_tmp[`NUM_CARD_BUS*8-1:0];
            //hr_cdata_out_en   <= cdata_out_en_tmp[`NUM_CARD_BUS*8-1:0];
                   for(n=0;n<=`NUM_CARD_BUS*8-1;n=n+8)
                      begin             //0,8,16,24.......
                        hr_cdata_out_ddr[n]        <= cdata_out_tmp[n];//[3:0] , [11:8] , [19:16].....
                        hr_cdata_out_ddr[n+1]      <= cdata_out_tmp[n+1];
                        hr_cdata_out_ddr[n+2]      <= cdata_out_tmp[n+2];
                        hr_cdata_out_ddr[n+3]      <= cdata_out_tmp[n+3];
                        hr_cdata_out_en_ddr[n]     <= cdata_out_en_tmp[n];//[3:0] , [11:8] , [19:16].....
                        hr_cdata_out_en_ddr[n+1]   <= cdata_out_en_tmp[n+1];
                        hr_cdata_out_en_ddr[n+2]   <= cdata_out_en_tmp[n+2];
                        hr_cdata_out_en_ddr[n+3]   <= cdata_out_en_tmp[n+3];       
                      end   
                 end
        end
      end
    end
   

   //mux which selects between MSB or LSB of DDR or non DDR signals.
  always @(ddr or ddr_r2 or use_hold_reg or hr_cdata_out_n_ddr or hr_cdata_out_en_n_ddr or hr_cdata_out_en_ddr or hr_cdata_out_ddr)
    begin
      for(m=0;m<=`NUM_CARD_BUS*8-1;m=m+8) 
        begin
       // Start Bit and End bit for 1.5clk cycles
          if(ddr | (ddr_r2 & use_hold_reg)) 
             begin
               hr_cdata_out_en[m]   =  hr_cdata_out_en_ddr[m];
               hr_cdata_out_en[m+1] =  hr_cdata_out_en_ddr[m+1];
               hr_cdata_out_en[m+2] =  hr_cdata_out_en_ddr[m+2];
               hr_cdata_out_en[m+3] = hr_cdata_out_en_ddr[m+3];
               hr_cdata_out_en[m+4] =  hr_cdata_out_en_ddr[m+4];
               hr_cdata_out_en[m+5] =  hr_cdata_out_en_ddr[m+5];
               hr_cdata_out_en[m+6] =  hr_cdata_out_en_ddr[m+6];
               hr_cdata_out_en[m+7] = hr_cdata_out_en_ddr[m+7];
               hr_cdata_out[m]      =  hr_cdata_out_ddr[m];
               hr_cdata_out[m+1]    =  hr_cdata_out_ddr[m+1];
               hr_cdata_out[m+2]    =  hr_cdata_out_ddr[m+2];
               hr_cdata_out[m+3]    =  hr_cdata_out_ddr[m+3];
               hr_cdata_out[m+4]    =  hr_cdata_out_ddr[m+4];
               hr_cdata_out[m+5]    =  hr_cdata_out_ddr[m+5];
               hr_cdata_out[m+6]    =  hr_cdata_out_ddr[m+6];
               hr_cdata_out[m+7]    =  hr_cdata_out_ddr[m+7];
             end   
          else 
             begin
               hr_cdata_out_en[m]   =  hr_cdata_out_en_n_ddr[m];
               hr_cdata_out_en[m+1] =  hr_cdata_out_en_n_ddr[m+1];
               hr_cdata_out_en[m+2] =  hr_cdata_out_en_n_ddr[m+2];
               hr_cdata_out_en[m+3] = hr_cdata_out_en_n_ddr[m+3];
               hr_cdata_out_en[m+4] =  hr_cdata_out_en_n_ddr[m+4];
               hr_cdata_out_en[m+5] =  hr_cdata_out_en_n_ddr[m+5];
               hr_cdata_out_en[m+6] =  hr_cdata_out_en_n_ddr[m+6];
               hr_cdata_out_en[m+7] = hr_cdata_out_en_n_ddr[m+7];
               hr_cdata_out[m]      =  hr_cdata_out_n_ddr[m]; 
               hr_cdata_out[m+1]    =  hr_cdata_out_n_ddr[m+1];
               hr_cdata_out[m+2]    =  hr_cdata_out_n_ddr[m+2];
               hr_cdata_out[m+3]    =  hr_cdata_out_n_ddr[m+3];
               hr_cdata_out[m+4]    =  hr_cdata_out_n_ddr[m+4]; 
               hr_cdata_out[m+5]    =  hr_cdata_out_n_ddr[m+5];
               hr_cdata_out[m+6]    =  hr_cdata_out_n_ddr[m+6];
               hr_cdata_out[m+7]    =  hr_cdata_out_n_ddr[m+7];
             end  
     end
  end
 
//SD_3.0 ends

//SDIO start
// INT pin being sampled at every clock edge even when the card clock is off.
   DWC_mobile_storage_bcm21
     #(`NUM_CARD_BUS,2,0,0) SYNC_CARD_INTERRUPT
    (
      .clk_d      (cclk_in),
      .rst_d_n    (creset_n),
      .init_d_n   (1'b1),
      .data_s     (card_int_n),
      .test       (1'b0),
      .data_d     (card_int_n_dsync)
   );
//Combo to select only DAT[1] line of each card.   
   always @ (cdata_in)
    begin
           for (p=0; p<= (`NUM_CARD_BUS-1); p=p+1) begin
                dat_int_n[p]  = cdata_in[p*8+1];  //Selecting only the DAT[1] lines of all the cards.
      end
    end  
   
  DWC_mobile_storage_bcm21
    #(`NUM_CARD_BUS,2,0,0) SYNC_DATA_INTERRUPT
    (
      .clk_d      (cclk_in),
      .rst_d_n    (creset_n),
      .init_d_n   (1'b1),
      .data_s     (dat_int_n),
      .test       (1'b0),
      .data_d     (dat_int_n_dsync)
   );
//SDIO ends

  // Output de-mux combinational logic
  always @ (/*AUTOSENSE*/ card_num_mul4 or card_num_mul4_p1
            or card_num_mul4_p2 or card_num_mul4_p3 or card_num_mul4_p4
            or card_num_mul4_p5 or card_num_mul4_p6 or card_num_mul4_p7
            or cp_card_num or cp_ccmd_out or cp_ccmd_out_en
            or dp_cdata_out_en_tmp or dp_cdata_out_tmp)
    begin
      ccmd_out_tmp                    = {`NUM_CARD_BUS{1'b1}};
      ccmd_out_en_tmp                 = {`NUM_CARD_BUS{1'b0}};
      cdata_out_tmp                   = {`NUM_CARD_BUS*8{1'b1}};
      cdata_out_en_tmp                = {`NUM_CARD_BUS*8{1'b0}};

      ccmd_out_tmp[cp_card_num]       = cp_ccmd_out;
      ccmd_out_en_tmp[cp_card_num]    = cp_ccmd_out_en;

      cdata_out_tmp[card_num_mul4]    = dp_cdata_out_tmp[0];
      cdata_out_tmp[card_num_mul4_p1] = dp_cdata_out_tmp[1];
      cdata_out_tmp[card_num_mul4_p2] = dp_cdata_out_tmp[2];
      cdata_out_tmp[card_num_mul4_p3] = dp_cdata_out_tmp[3];
      cdata_out_tmp[card_num_mul4_p4] = dp_cdata_out_tmp[4];
      cdata_out_tmp[card_num_mul4_p5] = dp_cdata_out_tmp[5];
      cdata_out_tmp[card_num_mul4_p6] = dp_cdata_out_tmp[6];
      cdata_out_tmp[card_num_mul4_p7] = dp_cdata_out_tmp[7];

      cdata_out_en_tmp[card_num_mul4]    = dp_cdata_out_en_tmp[0];
      cdata_out_en_tmp[card_num_mul4_p1] = dp_cdata_out_en_tmp[1];
      cdata_out_en_tmp[card_num_mul4_p2] = dp_cdata_out_en_tmp[2];
      cdata_out_en_tmp[card_num_mul4_p3] = dp_cdata_out_en_tmp[3];
      cdata_out_en_tmp[card_num_mul4_p4] = dp_cdata_out_en_tmp[4];
      cdata_out_en_tmp[card_num_mul4_p5] = dp_cdata_out_en_tmp[5];
      cdata_out_en_tmp[card_num_mul4_p6] = dp_cdata_out_en_tmp[6];
      cdata_out_en_tmp[card_num_mul4_p7] = dp_cdata_out_en_tmp[7];
    end


//MMC4_4 start
    always @ (posedge cclk_in or negedge creset_n)
      begin
        if (~creset_n)
           ddr_r1  <=  1'b0;
        else if(cclk_in_en)
           ddr_r1  <= ddr;
      end
//MMC4_4 ends

  // Input mux
  // input register
  always @ (/*AUTOSENSE*/ ccmd_in_sample
 //SD_3.0 start
            or ddr or ddr_r1 or ccmd_in_tmp or cdata_in_sample or cdata_in_tmp1 or cp_card_num or cdata_in_tmp2)
  //SD_3.0 ends
    begin
      if (`CARD_TYPE == 0) 
        begin
          cp_ccmd_in   = ccmd_in_sample;
          dp_cdata_in  = cdata_in_sample[`NUM_CARD_BUS*8-1:0];
        end 
      else 
        begin
          cp_ccmd_in   = ccmd_in_tmp[cp_card_num];
    //SD_3.0 start
          if(!(ddr | ddr_r1))
              dp_cdata_in  = cdata_in_tmp1;
          else 
              dp_cdata_in  = cdata_in_tmp2;
          //SD_3.0 ends
        end
      cdata_in_r     = cdata_in_sample[`NUM_CARD_BUS*8-1:0];
    end

  //input data mux combinational logic
  always @ (/*AUTOSENSE*/card_num_mul4 or card_num_mul4_p1
            or card_num_mul4_p2 or card_num_mul4_p3 or card_num_mul4_p4
            or card_num_mul4_p5 or card_num_mul4_p6 or card_num_mul4_p7
            or cdata_in_tmp)
    begin
      cdata_in_tmp1[0]   = cdata_in_tmp[card_num_mul4];
      cdata_in_tmp1[1]   = cdata_in_tmp[card_num_mul4_p1];
      cdata_in_tmp1[2]   = cdata_in_tmp[card_num_mul4_p2];
      cdata_in_tmp1[3]   = cdata_in_tmp[card_num_mul4_p3];
      cdata_in_tmp1[4]   = cdata_in_tmp[card_num_mul4_p4];
      cdata_in_tmp1[5]   = cdata_in_tmp[card_num_mul4_p5];
      cdata_in_tmp1[6]   = cdata_in_tmp[card_num_mul4_p6];
      cdata_in_tmp1[7]   = cdata_in_tmp[card_num_mul4_p7];
    end

  assign ccmd_in_tmp     = {{(16-`NUM_CARD_BUS){1'b0}}, ccmd_in_sample};
  assign cdata_in_tmp    = cdata_in_sample;
 

  // Hold register is implemented here
 //SD_3.0 start
`ifdef HOLD_REGISTER
   // add a register on each output and use cclk_in_drv
   reg [`NUM_CARD_BUS-1:0]    ccmd_out_drv;      // Card Cmd Reg
   reg [`NUM_CARD_BUS-1:0]    ccmd_out_en_drv;   // Card Cmd reg Enable
   reg [`NUM_CARD_BUS*8-1:0]  cdata_out_en_drv;  // Card Data enable HOLD Reg
  wire [`NUM_CARD_BUS*8-1:0] cdata_out_en;    // For HOLD in DDR mode.
 
  always @ (posedge cclk_in_drv or negedge creset_n_drv)
    begin
      if (~creset_n_drv) 
        begin
          ccmd_out_drv        <=   {`NUM_CARD_BUS{1'b1}};
          ccmd_out_en_drv     <=   {`NUM_CARD_BUS{1'b0}}; // disable output
          hr_cdata_out_r      <=   {`NUM_CARD_BUS*8{1'b1}};
          cdata_out_en_drv    <=   {`NUM_CARD_BUS*8{1'b0}}; // disable output
          ddr_r               <=   1'b0;                    // ddr signal delayed for hold register only
          ddr_r2              <=   1'b0; 
        end 
       else 
         begin
           ccmd_out_drv        <= hr_ccmd_out;
           ccmd_out_en_drv     <= hr_ccmd_out_en;
           hr_cdata_out_r      <= hr_cdata_out;
           cdata_out_en_drv    <= hr_cdata_out_en;
           ddr_r               <= ddr;
           ddr_r2              <= ddr_r;
         end
    end

    //assign  cdata_out_1 = (ddr | ddr_r) ? hr_cdata_out : hr_cdata_out_r;
   //assign  cdata_out_en = (ddr | ddr_r | ddr_r2) ? hr_cdata_out_en : cdata_out_en_drv;
  
  // For DDR use hr_cdata_out even when Hold register is present
  assign  cdata_out_1 = (ddr | ddr_r | ~use_hold_reg) ? hr_cdata_out : hr_cdata_out_r;
   assign  cdata_out_en = (ddr | ddr_r | ddr_r2 | ~use_hold_reg) ? hr_cdata_out_en : cdata_out_en_drv;
  // Bypass Hold register for cmd line
    assign  ccmd_out = (use_hold_reg) ? ccmd_out_drv : hr_ccmd_out;
  assign  ccmd_out_en = (use_hold_reg) ? ccmd_out_en_drv : hr_ccmd_out_en;

  
   // mux_sel signal with delayed clock
  // toggle_n_hold is generated from cclk_out
  // and is same as cclk_out; This is for divided 
  //clock only
  always @ (posedge cclk_in_drv or negedge creset_n_drv)
    begin
      if (~creset_n_drv)
        toggle_n_hold1 <= 1'b0;
      else 
        toggle_n_hold1 <= toggle_n_hold;
    end
  
 // mux_sel signal with delayed clock but undivided clock
  always@(posedge cclk_in_drv or negedge creset_n_drv)
   begin
     if (~creset_n_drv) 
       begin
         for (i=0; i<= (`NUM_CARD_BUS-1); i=i+1)
           toggle3[i] <= 1'b1; 
       end
     else 
        begin  
          for (i=0; i<= (`NUM_CARD_BUS-1); i=i+1)
            toggle3[i]  <= ~toggle3[i];
        end    
   end
   
   always@(negedge cclk_in_drv or negedge creset_n_drv)
     begin
       if (~creset_n_drv) 
          begin
            for (i=0; i<= (`NUM_CARD_BUS-1); i=i+1)
              toggle4[i] <= 1'b0; 
          end
      else 
         begin  
           for (i=0; i<= (`NUM_CARD_BUS-1); i=i+1)
             toggle4[i]  <= ~toggle4[i];
         end    
     end
   //toggle_n_hold2 is a replica of cclk_in_drv fed to the clkmux_interleave module as the mux select signal for DDR 4 bit mode. 
  assign  toggle_n_hold2 = (toggle3 ^ toggle4);

      
 // If hold register is not required then use the toggle_n_hold signal for DDR
 // If using a divided clk use toggle_n_hold1 else use the toggle_n_hold which is the same as cclk_out
 assign toggle = use_hold_reg ? (divided_clk ? toggle_n_hold1 : toggle_n_hold2): (toggle_n_hold); 
    
`else // no hold register direct output assignment
  assign ccmd_out       = hr_ccmd_out;
  assign ccmd_out_en    = hr_ccmd_out_en;
  assign cdata_out_1    = hr_cdata_out;
  assign cdata_out_en   = hr_cdata_out_en;

 assign toggle = toggle_n_hold;
`endif
   //SD_3.0 ends
`ifdef IMPLEMENT_SCAN_MUX
  //For scan mode, the cclk_out_en_neg flops work on the posedge of cclk_in
  DWC_mobile_storage_clk_mux_2x1
   U_scan_clk_mux_2x1
  (
    .in0_clk(cclk_in),
    .in1_clk(~cclk_in),
    .clk_sel(scan_mode),
    .out_clk(cclk_out_en_clk)
  );
`else
  assign cclk_out_en_clk = cclk_in;
`endif 


//Default Enables (-ve edge to -ve edge)
// -5 to 5, 15 to 25,35 to 45 etc.
  always @ (negedge cclk_out_en_clk or  negedge creset_n )
    begin
      if(~creset_n)
        begin
          cclk_out_en_neg_cmd <= {`NUM_CARD_BUS{1'b1}};
          cclk_out_en_neg_data <= {`NUM_CARD_BUS{1'b1}};
        end
      else
        begin
          cclk_out_en_neg_cmd <= cclk_sample_en_cmd;
          cclk_out_en_neg_data<= cclk_sample_en_data;
        end
    end
//Enables from +ve edge to +edge
//0 to 10,20 to 30, 40 to 50
  always @ (posedge cclk_out_en_clk or  negedge creset_n )
    begin
      if(~creset_n)
        begin
          cclk_out_en_pos_cmd <= {`NUM_CARD_BUS{1'b1}};
          cclk_out_en_pos_data <= {`NUM_CARD_BUS{1'b1}};
        end
      else
        begin
          cclk_out_en_pos_cmd <= cclk_out_en_neg_cmd;
          cclk_out_en_pos_data <= cclk_out_en_neg_data;
        end
    end
//Shifted enables (-ve edge to -ve edge)
// 5 to 15, 25 to 35,45 to 55 etc.

  always @ (negedge cclk_out_en_clk or  negedge creset_n )
    begin
      if(~creset_n)
        begin
          cclk_out_en_nneg_cmd <= {`NUM_CARD_BUS{1'b1}};
          cclk_out_en_nneg_data <= {`NUM_CARD_BUS{1'b1}};
        end
      else
        begin
          cclk_out_en_nneg_cmd <= cclk_out_en_neg_cmd;
          cclk_out_en_nneg_data <= cclk_out_en_neg_data;
        end
    end


  always @ (enable_shift or cclk_out_en_neg_cmd or cclk_out_en_pos_cmd or cclk_out_en_nneg_cmd or
            cclk_out_en_neg_data or cclk_out_en_pos_data or cclk_out_en_nneg_data )
    begin
      for (i=0; i <=`NUM_CARD_BUS-1;i=i+1)
        begin
          enable_shift_mux_sel = {enable_shift[i*2+1] , enable_shift[i*2]};
          //case (enable_shift_mux_sel[i])
          case (enable_shift_mux_sel)
            2'b00   : begin
                        cclk_out_en_cmd[i] = cclk_out_en_neg_cmd[i];
                        cclk_out_en_data[i] = cclk_out_en_neg_data[i];
                      end
            2'b01   : begin
                        cclk_out_en_cmd[i] = cclk_out_en_pos_cmd[i];
                        cclk_out_en_data[i] = cclk_out_en_pos_data[i];
                      end
            2'b10   : begin 
                        cclk_out_en_cmd[i] = cclk_out_en_nneg_cmd[i];
                        cclk_out_en_data[i] = cclk_out_en_nneg_data[i];
                      end
            default : begin 
                        cclk_out_en_cmd[i] = cclk_out_en_neg_cmd[i];
                        cclk_out_en_data[i] = cclk_out_en_neg_data[i];
                      end
          endcase
        end
     end

always @ (cclk_sample_en_ddr)
    begin
        cclk_out_en_pos = cclk_sample_en_ddr;
    end



  // Sample and register all the inputs on cclk_in_sample clock for ODD data in DDR
 //SD_3.0 start
  always @ (posedge cclk_in_sample or negedge creset_n_sample)
    begin
      if (~creset_n_sample) 
         begin
           if (`CARD_TYPE == 0) 
              begin //MMC only mode
                ccmd_in_sample   <= {(`NUM_CARD_BUS){1'b1}};
                cdata_in_sample_1[`NUM_CARD_BUS*8-1:0] <= {(`NUM_CARD_BUS*8){1'b1}};
              end 
           else 
              begin
                for (i=0; i<= `NUM_CARD_BUS*8-1; i=i+8) 
                  begin
                    ccmd_in_sample[i/8]      <= 1'b1;
                    cdata_in_sample_1[i]   <= 1'b1;
                    cdata_in_sample_1[i+1] <= 1'b1;
                    cdata_in_sample_1[i+2] <= 1'b1;
                    cdata_in_sample_1[i+3] <= 1'b1;
                    cdata_in_sample_1[i+4] <= 1'b1;
                    cdata_in_sample_1[i+5] <= 1'b1;
                    cdata_in_sample_1[i+6] <= 1'b1;
                    cdata_in_sample_1[i+7] <= 1'b1;
                end
              end
         end
      else 
        begin
          if (`CARD_TYPE == 0) 
             begin //MMC only mode
               if (cclk_out_en_cmd[0])
                  begin
                    ccmd_in_sample[0]   <= ccmd_in[0];
                    cdata_in_sample_1[`NUM_CARD_BUS*8-1:0] <= cdata_in[`NUM_CARD_BUS*8-1:0];
                  end
             end 
          else 
             begin
               for (i=0; i<= `NUM_CARD_BUS*8-1; i=i+8)
                  begin
                    if (cclk_out_en_cmd[i/8]) 
                      begin
                        ccmd_in_sample[i/8]      <= ccmd_in[i/8];
                      end
                  end
               for (i=0; i<= `NUM_CARD_BUS*8-1; i=i+8) 
                  begin
                    if (cclk_out_en_data[i/8]) 
                      begin
                        cdata_in_sample_1[i]   <= cdata_in[i];
                        cdata_in_sample_1[i+1] <= cdata_in[i+1];
                        cdata_in_sample_1[i+2] <= cdata_in[i+2];
                        cdata_in_sample_1[i+3] <= cdata_in[i+3];
                        cdata_in_sample_1[i+4] <= cdata_in[i+4];
                        cdata_in_sample_1[i+5] <= cdata_in[i+5];
                        cdata_in_sample_1[i+6] <= cdata_in[i+6];
                        cdata_in_sample_1[i+7] <= cdata_in[i+7];
                      end
                  end
             end
        end
    end
  
  // Sampling of the neg edge clock data is done here. For EVEN data in DDR 
  always @ (negedge cclk_in_sample_gen or negedge creset_n_sample)
    begin
      if (~creset_n_sample) 
         begin
           for (i=0; i<= `NUM_CARD_BUS*8-1; i=i+8) 
             begin
               cdata_in_sample_2[i]   <= 1'b1;
               cdata_in_sample_2[i+1] <= 1'b1;
               cdata_in_sample_2[i+2] <= 1'b1;
               cdata_in_sample_2[i+3] <= 1'b1;
               cdata_in_sample_2[i+4] <= 1'b1;
               cdata_in_sample_2[i+5] <= 1'b1;
               cdata_in_sample_2[i+6] <= 1'b1;
               cdata_in_sample_2[i+7] <= 1'b1;
             end
         end
      else 
         begin
           for (i=0; i<= `NUM_CARD_BUS*8-1; i=i+8)
             begin
               if (cclk_out_en_pos[i/8]) 
                  begin
                    cdata_in_sample_2[i]   <= cdata_in[i];   // cdata_in_sample_2[0] = cdata_in[0]; cdata_in_sample_2[8] = cdata_in[8];...
                    cdata_in_sample_2[i+1] <= cdata_in[i+1]; // cdata_in_sample_2[1] = cdata_in[1]; cdata_in_sample_2[9] = cdata_in[9];...
                    cdata_in_sample_2[i+2] <= cdata_in[i+2]; // cdata_in_sample_2[2] = cdata_in[2]; cdata_in_sample_2[10] = cdata_in[10];...
                    cdata_in_sample_2[i+3] <= cdata_in[i+3]; // cdata_in_sample_2[3] = cdata_in[3]; cdata_in_sample_2[11] = cdata_in[11];...
                    cdata_in_sample_2[i+4] <= cdata_in[i+4]; // cdata_in_sample_2[4] = cdata_in[4]; cdata_in_sample_2[12] = cdata_in[12];...
                    cdata_in_sample_2[i+5] <= cdata_in[i+5]; // cdata_in_sample_2[5] = cdata_in[5]; cdata_in_sample_2[13] = cdata_in[13];...
                    cdata_in_sample_2[i+6] <= cdata_in[i+6]; // cdata_in_sample_2[6] = cdata_in[6]; cdata_in_sample_2[14] = cdata_in[14];...
                    cdata_in_sample_2[i+7] <= cdata_in[i+7]; // cdata_in_sample_2[7] = cdata_in[7]; cdata_in_sample_2[15] = cdata_in[15];...
                  end
             end
          end
    end

  // Input mux
  // input register
  always @ (cdata_in_sample_1 or cdata_in_sample_2 or ddr)  // sample_2 has the 1st MSB sample_1 has the 2nd MSB
    begin
     for (i=0; i<= `NUM_CARD_BUS*8-1; i=i+8) 
       begin
         cdata_in_sample[i]     = cdata_in_sample_1[i];     // lower 4 bits [3:0] are assigned directly.
         cdata_in_sample[i+1]   = cdata_in_sample_1[i+1];   // carrying the ODD data of DDR 50 sampled at +ve edge
         cdata_in_sample[i+2]   = cdata_in_sample_1[i+2];
         cdata_in_sample[i+3]   = cdata_in_sample_1[i+3];
         cdata_in_sample[i+4]   = ddr ? cdata_in_sample_2[i]   : cdata_in_sample_1[i+4];
         cdata_in_sample[i+5]   = ddr ? cdata_in_sample_2[i+1] : cdata_in_sample_1[i+5]; 
         cdata_in_sample[i+6]   = ddr ? cdata_in_sample_2[i+2] : cdata_in_sample_1[i+6];
         cdata_in_sample[i+7]   = ddr ? cdata_in_sample_2[i+3] : cdata_in_sample_1[i+7];
      end
    end

   always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n) 
         begin
           r1 <= 4'hf;
           r2 <= 4'hf;
           r3 <= 4'hf;
           r4 <= 4'hf;
           r5 <= 4'hf;
           r6 <= 4'hf;
         end 
      else 
         begin
           if(cclk_in_en) 
             begin
               r1 <=  cdata_in_tmp1[3:0];  // has the MSB of 1st nibble
               r2 <=  cdata_in_tmp1[7:4];  // has the MSB of the 2nd nibb;e
               r3 <=  r1;// has the MSB of 1st nibble
               r4 <=  r2;// has the MSB of 2nd nibble
               r5 <=  r3;// has the MSB of 1st nibble
               r6 <=  r4;// has the MSB of 2nd nibble
             end
         end
    end
  

 always @ (posedge cclk_in or negedge creset_n)
  begin
    if (~creset_n) 
       begin
         start_bit_delayed <= 1'b0;
         ddr_count <= 1'b0;
       end 
    else if(cclk_in_en) 
        begin //the Start bit of the block can come only 2 card clks after start_rx_data goes high i.e. 2 clks after the end bit of the CMD. So reset start_bit_delayed here.
      if (start_rx_data && r1 == 4'hf && r2 == 4'hf && r3 == 4'hf && r4 == 4'hf && r5 == 4'hf && r6 == 4'hf)
         begin //reset start_bit_delayed before the start bit of the new block.
           start_bit_delayed <= 1'b0;
         end
      else if (full_start_bit && start_rx_data && (r3==4'h0) && (r4 == 4'h0) && (r5 == 4'hf) && (r6 == 4'hf))
         begin // Start bit is in r3 and r4 register
           start_bit_delayed <= 1'b0;
           ddr_count <= 1'b0;
         end  
      else if (full_start_bit && start_rx_data && (r1 == 4'h0) && (r3==4'hf) && (r4 == 4'h0) && (r5 == 4'hf) && (r6 == 4'hf)) 
         begin // Start bit is in r1 and r4 register
           start_bit_delayed <= 1'b1;
           ddr_count <= 1'b1;
         end  //MMC 4.5 start 
   /*The start bit is only 1/2 clock cycle and hence only r3 is checked and r4 is not checked. When the 1/2 start bit is sampled with +ve edge if will get loaded r1->r3 */
      else if (half_start_bit && start_rx_data && (r3==4'h0) &&  (r5 == 4'hf) && (r6 == 4'hf))
         begin // Start bit is in r3  register
           start_bit_delayed <= 1'b0;
           ddr_count <= 1'b0;
         end 
   /*The start bit is only 1/2 clock cycle and hence only r4 is checked. When the 1/2 start bit is sampled with -ve edge if will get loaded r2->r4 */
      else if (half_start_bit && start_rx_data && (r3==4'hf) && (r4 == 4'h0)  && (r5 == 4'hf) && (r6 == 4'hf))
         begin // Start bit is in r4 register
           start_bit_delayed <= 1'b1;
           ddr_count <= 1'b1;
         end
      //MMC 4.5 ends
      else 
         begin   
           ddr_count <= ~ddr_count;
         end  
     end 
 end
  // This goes to the FIFO
   always @ (ddr_count or r1 or r2 or r3 or r6 or r4 or r5 or start_bit_delayed)
     begin
       if (!start_bit_delayed) 
          begin
            //This goes to the CRC checker and generates the start_bit
            cdata_in_tmp2[7:4] = r6;
            cdata_in_tmp2[3:0] = r5;
            if(!ddr_count) 
               begin
                 de_interleave[7:4] = r3;  // MSB
                 de_interleave[3:0] = r1;  // LSB
               end 
            else 
               begin
                 de_interleave[7:4] = r6;  // MSB
                 de_interleave[3:0] = r4;  // LSB
               end 
          end
       else 
          begin
            //This goes to the CRC checker and generates the start_bit
            cdata_in_tmp2[7:4] = r6;
            cdata_in_tmp2[3:0] = r3;
            if(!ddr_count) 
               begin
                 de_interleave[7:4] = r3;  // MSB
                 de_interleave[3:0] = r1;  // LSB
               end 
            else 
               begin
                 de_interleave[7:4] = r4;  // MSB
                 de_interleave[3:0] = r2;  // LSB
               end 
          end
     end
 
 //regsitering the data to align with the CRC 
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        de_interleave_r <= 1'b0;
      else 
        begin
          if (cclk_in_en)
            de_interleave_r <=  de_interleave;
          else 
             de_interleave_r <=  de_interleave_r;
        end    
    end 

//###################################
// Logic to detect completion of busy after a write data transfer command, so that firmware does not have to  
// keep on polling on the busy clear bit and instead gets a second interrupt after DTO interrupt to confirm busy completion
// 

// Busy clear logic detection states after write data transfer command 
`define      BUSY_IDLE       0      // Busy Idle state  (default state)
`define      BUSY_COUNT      1      // Wait state before sampling busy. 
`define      BUSY_CHK        2      // Sample dp_cdata_in[0] to check if busy is indicated by the card .
`define      BUSY_WT_CLEAR   3      // After detection of busy in BUSY_CHK state wait for busy to clear in this state 
`define      BUSY_GEN_INT    4      // After busy de-assertion generate interrrupt in this state 
`define      BUSY_WT_COUNT    3'b110
reg    [4:0] busy_cs;        // BUSY_CLEAR state m/c current state
reg    [4:0] busy_ns;        // BUSY_CLEAR state m/c next state
reg    [2:0] busy_counter;        // Counter to wait for number of cycles before sampling busy after DTO 
reg    wr_data_xfr_cmd_issued_r ;
wire   wr_data_xfr_cmd_issued ;
reg    busy_clear_int_i;

// Detect loading of write data transfer command
assign wr_data_xfr_cmd_issued = new_cmd_load ?( read_or_write_cmd & data_expected) :1'b0; 

always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        wr_data_xfr_cmd_issued_r <= 1'b0;
      else 
        begin
          if (cclk_in_en & !wr_data_xfr_cmd_issued_r)
             wr_data_xfr_cmd_issued_r <=  wr_data_xfr_cmd_issued;
          else if (busy_clear_int_i)
             wr_data_xfr_cmd_issued_r <=1'b0;
          else 
             wr_data_xfr_cmd_issued_r <=  wr_data_xfr_cmd_issued_r;
        end    
    end 

//After DTO wait for some defined number of cycles before starting to sample busy.
always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        busy_counter <= 3'b0;
      else 
        begin
          if (busy_cs[`BUSY_IDLE] & busy_ns[`BUSY_COUNT] )
             busy_counter <= 3'b0;
          else if (cclk_in_en)
             busy_counter <= busy_counter + 3'b001; 
        end    
    end 

// BUSY_CLEAR state machine register logic
  always @ (posedge cclk_in or negedge creset_n)
    begin
      if (~creset_n)
        busy_cs   <= 5'h1;
      else begin
        if (cclk_in_en)
          busy_cs <= busy_ns;
      end
    end
// BUSY_CLEAR state machine combinational logic
always @ (/*AUTOSENSE*/
          wr_data_xfr_cmd_issued_r or busy_cs or busy_counter or tx_data_done or dp_cdata_in
          )
   begin:FSM_BUSY_CLEAR
      busy_ns = 3'h0;
      busy_clear_int_i = 1'b0;
      
      case (1'b1)
         busy_cs[`BUSY_IDLE] :
           begin
              if (wr_data_xfr_cmd_issued_r & tx_data_done)
                 busy_ns[`BUSY_COUNT] = 1'b1;
              else
                 busy_ns[`BUSY_IDLE] = 1'b1;
           end
         busy_cs[`BUSY_COUNT] :
           begin
              if (busy_counter == `BUSY_WT_COUNT)
                 busy_ns[`BUSY_CHK] = 1'b1;
              else
                 busy_ns[`BUSY_COUNT] = 1'b1;
           end
         busy_cs[`BUSY_CHK] :
           begin
              if (!(dp_cdata_in[0])) 
                 busy_ns[`BUSY_WT_CLEAR] = 1'b1;
              else
                 busy_ns[`BUSY_GEN_INT] = 1'b1;
           end
         busy_cs[`BUSY_WT_CLEAR] :
           begin
              if (dp_cdata_in[0])
                busy_ns[`BUSY_GEN_INT] = 1'b1;
              else
                busy_ns[`BUSY_WT_CLEAR] = 1'b1;
           end
         busy_cs[`BUSY_GEN_INT] :
           begin
              busy_clear_int_i = 1'b1; 
              busy_ns[`BUSY_IDLE] = 1'b1;
           end

      endcase
    end
assign busy_clear_int = busy_clear_int_i;

endmodule // DWC_mobile_storage_muxdemux
