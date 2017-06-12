`include "tb_camera_pkg.sv"
`include "pin_map.sv"

`define CLK_PERIOD  10.00ns // 100 MHz: input for Xilinx MMCL.
 `define CAM_CLK_PERIOD  40.00ns // 25 MHz camera clock

`define BAUDRATE0   62500
`define BAUDRATE1   31250

module tb;
  timeunit      1ns;
  timeprecision 1ps;

  logic         s_clk_p, s_clk_n;
  logic         s_rst_n;


  logic         uart_tx;
  logic         uart_rx;
//  logic         c0_uart_tx;
//  logic         c0_uart_rx;

  logic        s_ck_p_sdram;
  logic        s_ck_n_sdram;
  logic        s_cke_sdram;
  logic [1:0]  s_dqm_sdram;
  wire  [1:0]  s_dqs_sdram;
  wire  [15:0] s_dq_sdram;
  logic        s_sel_n_sdram;
  logic        s_ras_n_sdram;
  logic        s_cas_n_sdram;
  logic        s_we_n_sdram;
  logic [13:0] s_addr_sdram;
  logic  [1:0] s_bank_addr_sdram;

  logic        int_rd_dqs_mask_sdram;
  logic        s_rd_dqs_mask_sdram;

  logic         cam_pclk   = 1'b0;
  logic         cam_vsync;
  logic         cam_href;
  logic [7:0]   cam_data;


  // use 8N1
  uart_bus
  #(
    .BAUD_RATE(`BAUDRATE0),
    .PARITY_EN(0),
    .ID(0)
  )
  uart
  (
    .rx         ( uart_rx ),
    .tx         ( uart_tx ),
    .rx_en      ( 1'b1    )
  );

  // use 8N1
//  uart_bus
//  #(
//    .BAUD_RATE(`BAUDRATE0),
//    .PARITY_EN(0),
//    .ID(1)
//  )
//  uart1
//  (
//    .rx         ( c0_uart_rx ),
//    .tx         ( c0_uart_tx ),
//    .rx_en      ( 1'b1    )
//  );


  mobile_ddr lpddr_i 
  (
    .Dq         ( s_dq_sdram        ), //tri
    .Dqs        ( s_dqs_sdram      ), //tri
    .Addr       ( s_addr_sdram      ), 
    .Ba         ( s_bank_addr_sdram ), 
    .Clk        ( s_ck_p_sdram      ), 
    .Clk_n      ( s_ck_n_sdram      ), 
    .Cke        ( s_cke_sdram       ), 
    .Cs_n       ( s_sel_n_sdram     ), 
    .Ras_n      ( s_ras_n_sdram     ), 
    .Cas_n      ( s_cas_n_sdram     ), 
    .We_n       ( s_we_n_sdram      ), 
    .Dm         ( s_dqm_sdram       )
  );

assign #0 int_rd_dqs_mask_sdram  =  s_rd_dqs_mask_sdram;

 camera_emu camera_emu_i
  (
    .cam_pclk   ( cam_pclk  ),
    .cam_rstn   ( s_rst_n   ),
    .cam_vsync  ( cam_vsync ),
    .cam_href   ( cam_href  ),
    .cam_data   ( cam_data  )
  );

 fpga_top fpga_top_i (

  .clk_p    ( s_clk_p ),
  .clk_n    ( s_clk_n ),   
  .rst_n    ( s_rst_n ),

  .spim_clk ( ),
  .spim_csn ( ),
  .spim_sdo ( ),
  .spim_sdi ( ),

  .uart_tx  ( uart_rx ),
  .uart_rx  ( uart_tx ),

 .memctl_s_ck_p          ( s_ck_p_sdram          ),
 .memctl_s_ck_n          ( s_ck_n_sdram          ),
 .memctl_s_sel_n         ( s_sel_n_sdram         ),
 .memctl_s_cke           ( s_cke_sdram           ),
 .memctl_s_ras_n         ( s_ras_n_sdram         ),
 .memctl_s_cas_n         ( s_cas_n_sdram         ),
 .memctl_s_we_n          ( s_we_n_sdram          ),
 .memctl_s_addr          ( s_addr_sdram          ),
 .memctl_s_bank_addr     ( s_bank_addr_sdram     ),
 .memctl_s_dqm           ( s_dqm_sdram           ),
 .memctl_s_dqs           ( s_dqs_sdram           ),  //tri
 .memctl_s_dq            ( s_dq_sdram            ),  //tri
 .memctl_s_rd_dqs_mask   ( s_rd_dqs_mask_sdram   ),
 .memctl_int_rd_dqs_mask ( int_rd_dqs_mask_sdram ),

 .gpio0 (  ),
 .gpio1 (  ),
 .pclk  ( cam_pclk ),
 .vsync ( pin4 ),
 .href  ( pin5 ),
 .cam7  ( pin6 ),
 .cam6  ( pin7 ),
 .cam5  ( pin8 ),
 .cam4  ( pin9 ),
 .cam3  ( pin10 ),
 .cam2  ( pin11 ),
 .cam1  ( pin12 ),
 .cam0  ( pin13 ),

 .c0_uart_tx ( ),
 .c0_uart_rx ( ),
 .c0_gpio0   ( ),
 .c0_gpio1   ( ),
 .c0_gpio2   ( ),
 .c0_gpio3   ( )

 );


  generate
    begin
      initial
      begin
        #(`CLK_PERIOD/2);
        s_clk_p = 1'b1;
        forever s_clk_p = #(`CLK_PERIOD/2) ~s_clk_p;
      end
    end
  endgenerate

  assign s_clk_n = ~s_clk_p;

  generate
    begin
      initial
      begin
        #(`CAM_CLK_PERIOD/2);
        cam_pclk = 1'b1;
        forever cam_pclk = #(`CAM_CLK_PERIOD/2) ~cam_pclk;
      end
    end
  endgenerate

  initial
  begin
    s_rst_n  = 1'b0;

    lpddr_load();
    lpddr_check();

    #500ns;
    s_rst_n  = 1'b1;

    #1000000us;

    $fflush();
    $stop();
  end

//  initial
//  begin
//    $dumpfile("sdram-signals.vcd");
//    $dumpvars(1, fpga_top_i);
//  end

`include "tb_lpddr_pkg.sv"
`include "pin_map.svh"

endmodule


