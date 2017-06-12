
(* dont_touch = "yes" *) module fpga_top(

  clk_p,
  clk_n,
  rst_n,

  spi_sck,
  spi_csn,
  spi_sdo,
  spi_sdi,

  uart_tx,
  uart_rx,

  scl,
  sda,

  memctl_s_ck_p,
  memctl_s_ck_n,
  memctl_s_sel_n,
  memctl_s_cke,
  memctl_s_ras_n,
  memctl_s_cas_n,
  memctl_s_we_n,
  memctl_s_addr,
  memctl_s_bank_addr,
  memctl_s_dqm,
  memctl_s_dqs,    
  memctl_s_dq,   
  memctl_s_rd_dqs_mask,
  memctl_int_rd_dqs_mask,

  gpio0
//  gpio1,
//  pclk,
//  vsync,
//  href,
//  cam7,
//  cam6,
//  cam5,
//  cam4,
//  cam3,
//  cam2,
//  cam1,
//  cam0,

//  c0_uart_tx,
//  c0_uart_rx,
//  c0_gpio0,
//  c0_gpio1,
//  c0_gpio2,
//  c0_gpio3

 );

  // Clock and Reset
  input         clk_p;
  input         clk_n;
  input         rst_n;

  output        spi_sck;
  output        spi_csn;
  output        spi_sdo;
  input         spi_sdi;
  //uart
  output        uart_tx;
  input         uart_rx;
  inout         gpio0;
  //i2c eeprom
  inout         scl;
  inout         sda;

  output        memctl_s_ck_p;
  output        memctl_s_ck_n;
  output        memctl_s_sel_n;
  output        memctl_s_cke;
  output        memctl_s_ras_n;
  output        memctl_s_cas_n;
  output        memctl_s_we_n;
  output [13: 0]  memctl_s_addr;
  output [ 1: 0]  memctl_s_bank_addr;
  output [ 1: 0]  memctl_s_dqm;
  inout  [ 1: 0]  memctl_s_dqs;    
  inout  [15: 0]  memctl_s_dq;    
  output        memctl_s_rd_dqs_mask;
  input         memctl_int_rd_dqs_mask;
/*
  inout         gpio0;
  inout         gpio1;

  input         pclk;
  inout         vsync;
  inout         href;
  inout         cam7;
  inout         cam6;
  inout         cam5;
  inout         cam4;
  inout         cam3;
  inout         cam2;
  inout         cam1;
  inout         cam0;

  //uart
  output        c0_uart_tx;
  input         c0_uart_rx;
  inout         c0_gpio0;
  inout         c0_gpio1;
  inout         c0_gpio2;
  inout         c0_gpio3;
*/

  wire clk;
//  wire [15:0] wire_memctl_s_addr;

//  assign memctl_s_addr = wire_memctl_s_addr[13:0];

// IBUFGDS: Differential Global Clock Input Buffer
// 7 Series
// Xilinx HDL Libraries Guide, version 14.5
IBUFGDS #(.DIFF_TERM("TRUE"), // Differential Termination
          .IOSTANDARD("DEFAULT")
) IBUFGDS_inst (
  .O  (  clk    ), // Clock buffer output
  .I  (  clk_p  ), // Diff_p clock buffer input (connect directly to top-level port)
  .IB (  clk_n  ) // Diff_n clock buffer input (connect directly to top-level port)
);
// End of IBUFGDS_inst instantiation

  // PPU SoC
top top_i
 (
//common
     .clk_i             ( clk   ),
     .div_pll_i         ( 2'b01 ),
     .pll_bps_i         ( 1'b0  ),
     .rstn_i            ( rst_n ),
//ppu
     .testmode_i        ( 1'b0  ),
     .fetch_enable_i    ( 1'b1  ),
    //SPI Master

     .spi_master_clk_o  ( spi_sck ),
     .spi_master_csn0_o ( spi_csn ),
     .spi_master_sdo0_o ( spi_sdo ),
     .spi_master_sdi0_i ( spi_sdi ),

     //uart
     .uart_tx           ( uart_tx ),
     .uart_rx           ( uart_rx ),
    //memctl
	 .memctl_s_ck_p          ( memctl_s_ck_p  ),
	 .memctl_s_ck_n          ( memctl_s_ck_n  ),
	 .memctl_s_sel_n         ( memctl_s_sel_n ),
	 .memctl_s_cke           ( memctl_s_cke  ),
	 .memctl_s_ras_n         ( memctl_s_ras_n ),
	 .memctl_s_cas_n         ( memctl_s_cas_n ),
	 .memctl_s_we_n          ( memctl_s_we_n  ),
	 .memctl_s_addr          ( memctl_s_addr  ),
	 .memctl_s_bank_addr     ( memctl_s_bank_addr ),
	 .memctl_s_dqm           ( memctl_s_dqm  ),
	 .memctl_s_dqs           ( memctl_s_dqs  ),  //tri
	 .memctl_s_dq            ( memctl_s_dq  ),  //tri
	 .memctl_s_rd_dqs_mask   ( memctl_s_rd_dqs_mask  ),
	 .memctl_int_rd_dqs_mask ( memctl_int_rd_dqs_mask ),
     //eMMC
	 .emmc_cclk_out          ( ),
	 .emmc_ccmd              ( ), //tri
	 .emmc_cdata             ( ), //tri
	 .emmc_card_detect_n     ( ),
	 .emmc_card_write_prt    ( ),
	 .sdio_card_int_n        ( ),
	 .mmc_4_4_rst_n          ( ),

     //Mux Pins
     .PIN0_scl_uart1tx        ( scl ),
     .PIN1_sda_uart1rx        ( sda ),
     .PIN2_spim1sdo0_gpio0    ( gpio0 ),
     .PIN3_spim1csn0_gpio1    (  ),
     .PIN4_spim1sdi0_vsync    (  ),
     .PIN5_pwm0_href          (   ),
     .PIN6_pwm1_camdata7      (   ),
     .PIN7_pwm2_camdata6      (   ),
     .PIN8_pwm3_camdata5      (  ),
     .PIN9_gpio2_camdata4     (   ),
     .PIN10_gpio3_camdata3    (   ),
     .PIN11_gpio4_camdata2    ( ),
     .PIN12_gpio5_camdata1    (  ),
     .PIN13_gpio6_camdata0    (  ),

     .spim1clk                (  ),
     .pclk                    ( ),

/////////////////////////////////////
///           ppu0               ////
/////////////////////////////////////
     .c0_testmode_i     ( 1'b0 ),
     .c0_fetch_enable_i ( 1'b1 ),

     .c0_uart_tx        (  ),
     .c0_uart_rx        ( ),
//     .c0_uart_tx        (  ),
//     .c0_uart_rx        (  ),

     .c0_PIN0_spimclk_scl   ( ),
     .c0_PIN1_spimcsn_sda   ( ),
     .c0_PIN2_spimsdo_gpio0 (),
     .c0_PIN3_spimsdi_gpio1 ( ),
     .c0_PIN4_pwm0_gpio2    ( ),
     .c0_PIN5_pwm1_gpio3    ( ),
     .c0_PIN6_pwm2_gpio4    ( ),
     .c0_PIN7_pwm3_gpio5    ( ),

/////////////////////////////////////
///    shared part               ////
/////////////////////////////////////
     .select_c0_i       ( 1'b1 ),

    //SPI Slave
     .spi_clk_i         (  ),
  .c0_spi_cs_i          (  ),
     .spi_cs_i          (  ),
     .spi_sdo0_o        (  ),
     .spi_sdi0_i        (  ),

     //jtag
     .tck_i             (  ),
     .trstn_i           (  ),
     .tms_i             (  ),
     .tdi_i             (  ),
     .tdo_o             (  )
   );

endmodule

