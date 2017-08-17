//
`include "config.sv"

module top
(
    input  logic              sys_clk_p,
    input  logic              sys_clk_n,
    input  logic              rstn_i,
    input  logic              testmode_i,
    input  logic              fetch_enable_i,
 //   output logic             xclk,

   //SPI Slave
    input  logic              spi_clk_i,
    input  logic              spi_cs_i,
    output logic              spi_sdo0_o,
    output logic              spi_sdo1_o,
    output logic              spi_sdo2_o,
    output logic              spi_sdo3_o,
    input  logic              spi_sdi0_i,
    input  logic              spi_sdi1_i,
    input  logic              spi_sdi2_i,
    input  logic              spi_sdi3_i,

    //SPI Master
    output logic              spi_master_clk_o,
    output logic              spi_master_csn0_o,
    output logic              spi_master_csn1_o,
    output logic              spi_master_csn2_o,
    output logic              spi_master_csn3_o,
    output logic              spi_master_sdo0_o,
    output logic              spi_master_sdo1_o,
    output logic              spi_master_sdo2_o,
    output logic              spi_master_sdo3_o,
    input  logic              spi_master_sdi0_i,
    input  logic              spi_master_sdi1_i,
    input  logic              spi_master_sdi2_i,
    input  logic              spi_master_sdi3_i,

    output logic              spi_master1_clk_o,
    output logic              spi_master1_csn0_o,
    output logic              spi_master1_csn1_o,
    output logic              spi_master1_csn2_o,
    output logic              spi_master1_csn3_o,
    output logic              spi_master1_sdo0_o,
    output logic              spi_master1_sdo1_o,
    output logic              spi_master1_sdo2_o,
    output logic              spi_master1_sdo3_o,
    input  logic              spi_master1_sdi0_i,
    input  logic              spi_master1_sdi1_i,
    input  logic              spi_master1_sdi2_i,
    input  logic              spi_master1_sdi3_i,

    //uart
    output logic              uart_tx,
    input  logic              uart_rx,

    output logic              uart1_tx,
    input  logic              uart1_rx,

    //I2C
    inout  wire               scl,
    inout  wire               sda,
    inout  wire               scl1,
    inout  wire               sda1,
    //gpio
    inout  wire    [31:0]     gpio,   
    //pwm
    output logic   [3:0]      pwm_o,

    //camera
    input logic              cam_pclk,
    input logic              cam_vsync,
    input logic              cam_href,
    input logic  [ 7: 0]     cam_data,
    //eMMC
	output logic [ 1: 0]      emmc_cclk_out,
	inout wire   [ 1: 0]      emmc_ccmd,
	inout wire   [15: 0]      emmc_cdata,
	input logic  [ 1: 0]      emmc_card_detect_n,
	input logic  [ 1: 0]      emmc_card_write_prt,
	input  logic [ 1: 0]      sdio_card_int_n,
	output logic [ 1: 0]      mmc_4_4_rst_n,

   //ddr3 sdram if
    output logic              init_calib_complete,

    inout  wire    [31:0]     ddr3_dq,
    inout  wire    [3:0]      ddr3_dqs_n,
    inout  wire    [3:0]      ddr3_dqs_p,
    output logic   [14:0]     ddr3_addr,
    output logic   [2:0]      ddr3_ba,
    output logic              ddr3_ras_n,
    output logic              ddr3_cas_n,
    output logic              ddr3_we_n,
    output logic              ddr3_reset_n,
    output logic              ddr3_ck_p,
    output logic              ddr3_ck_n,
    output logic              ddr3_cke,
    output logic              ddr3_cs_n,
    output logic   [3:0]      ddr3_dm,
    output logic              ddr3_odt,
    //jtag
    input  logic             tck_i,
    input  logic             trstn_i,
    input  logic             tms_i,
    input  logic             tdi_i,
    output logic             tdo_o,

///////////////////////////////////////////
////             PPU0                 ////
//////////////////////////////////////////
    input  logic             c0_testmode_i,
    input  logic             c0_fetch_enable_i,
   //SPI Slave
    input  logic             c0_spi_clk_i,
    input  logic             c0_spi_cs_i,
    output logic             c0_spi_sdo0_o,
    output logic             c0_spi_sdo1_o,
    output logic             c0_spi_sdo2_o,
    output logic             c0_spi_sdo3_o,
    input  logic             c0_spi_sdi0_i,
    input  logic             c0_spi_sdi1_i,
    input  logic             c0_spi_sdi2_i,
    input  logic             c0_spi_sdi3_i,

    //SPI Master
    output logic             c0_spim_clk_o,
    output logic             c0_spim_csn0_o,
    output logic             c0_spim_csn1_o,
    output logic             c0_spim_csn2_o,
    output logic             c0_spim_csn3_o,
    output logic             c0_spim_sdo0_o,
    output logic             c0_spim_sdo1_o,
    output logic             c0_spim_sdo2_o,
    output logic             c0_spim_sdo3_o,
    input  logic             c0_spim_sdi0_i,
    input  logic             c0_spim_sdi1_i,
    input  logic             c0_spim_sdi2_i,
    input  logic             c0_spim_sdi3_i,

    output  logic            c0_uart_tx,
    input  logic             c0_uart_rx,

    inout  wire              c0_scl,
    inout  wire              c0_sda,
    inout  wire  [31:0]      c0_gpio,

    output logic [3:0]       c0_pwm_o,
    //jtag
    input  logic             c0_tck_i,
    input  logic             c0_trstn_i,
    input  logic             c0_tms_i,
    input  logic             c0_tdi_i,
    output logic             c0_tdo_o
   );

    logic             core_scl_pad_i;
    logic             core_scl_pad_o;
    logic             core_scl_padoen_o;
    logic             core_sda_pad_i;
    logic             core_sda_pad_o;
    logic             core_sda_padoen_o;

    logic             core_scl1_pad_i;
    logic             core_scl1_pad_o;
    logic             core_scl1_padoen_o;
    logic             core_sda1_pad_i;
    logic             core_sda1_pad_o;
    logic             core_sda1_padoen_o;

    logic [31: 0]     core_gpio_in;
    logic [31: 0]     core_gpio_out;
    logic [31: 0]     core_gpio_dir;
    //eMMC
    logic [ 1: 0]     core_emmc_ccmd_in;
    logic [ 1: 0]     core_emmc_ccmd_out;
    logic [ 1: 0]     core_emmc_ccmd_out_en;
	                    
    logic [15: 0]     core_emmc_cdata_in;
    logic [15: 0]     core_emmc_cdata_out;
    logic [15: 0]     core_emmc_cdata_out_en;

    logic             pll0_clk;
    logic             pll0_locked;
    logic             core0_scl_pad_i;
    logic             core0_scl_pad_o;
    logic             core0_scl_padoen_o;
    logic             core0_sda_pad_i;
    logic             core0_sda_pad_o;
    logic             core0_sda_padoen_o;
    logic [31: 0]     core0_gpio_in;
    logic [31: 0]     core0_gpio_out;
    logic [31: 0]     core0_gpio_dir;

///////////////////////////////////////////
////                                  ////
////             PPU                  ////
////                                  ////
//////////////////////////////////////////
  ppu_top
  ppu_top_i
   (
    .sys_clk_p                (  sys_clk_p  ),
    .sys_clk_n                (  sys_clk_n  ),
    .sys_rst_n                (  rstn_i     ),

    .testmode_i               (  testmode_i     ),
    .fetch_enable_i           (  fetch_enable_i ),
    //spi slave
    .spi_clk_i                (  spi_clk_i  ),
    .spi_cs_i                 (  spi_cs_i   ),
    .spi_sdo0_o               (  spi_sdo0_o ),
    .spi_sdo1_o               (  spi_sdo1_o ),
    .spi_sdo2_o               (  spi_sdo2_o ),
    .spi_sdo3_o               (  spi_sdo3_o ),
    .spi_sdi0_i               (  spi_sdi0_i ),
    .spi_sdi1_i               (  spi_sdi1_i ),
    .spi_sdi2_i               (  spi_sdi2_i ),
    .spi_sdi3_i               (  spi_sdi3_i ),
    //spi master
    .spi_master_clk_o         (  spi_master_clk_o  ), 
    .spi_master_csn0_o        (  spi_master_csn0_o ),
    .spi_master_csn1_o        (  spi_master_csn1_o ),
    .spi_master_csn2_o        (  spi_master_csn2_o ),
    .spi_master_csn3_o        (  spi_master_csn3_o ),
    .spi_master_sdo0_o        (  spi_master_sdo0_o ),
    .spi_master_sdo1_o        (  spi_master_sdo1_o ),
    .spi_master_sdo2_o        (  spi_master_sdo2_o ),
    .spi_master_sdo3_o        (  spi_master_sdo3_o ),
    .spi_master_sdi0_i        (  spi_master_sdi0_i ),
    .spi_master_sdi1_i        (  spi_master_sdi1_i ),
    .spi_master_sdi2_i        (  spi_master_sdi2_i ),
    .spi_master_sdi3_i        (  spi_master_sdi3_i ),
    //spi master 1
    .spi_master1_clk_o         (  spi_master1_clk_o  ), 
    .spi_master1_csn0_o        (  spi_master1_csn0_o ),
    .spi_master1_csn1_o        (  spi_master1_csn1_o ),
    .spi_master1_csn2_o        (  spi_master1_csn2_o ),
    .spi_master1_csn3_o        (  spi_master1_csn3_o ),
    .spi_master1_sdo0_o        (  spi_master1_sdo0_o ),
    .spi_master1_sdo1_o        (  spi_master1_sdo1_o ),
    .spi_master1_sdo2_o        (  spi_master1_sdo2_o ),
    .spi_master1_sdo3_o        (  spi_master1_sdo3_o ),
    .spi_master1_sdi0_i        (  spi_master1_sdi0_i ),
    .spi_master1_sdi1_i        (  spi_master1_sdi1_i ),
    .spi_master1_sdi2_i        (  spi_master1_sdi2_i ),
    .spi_master1_sdi3_i        (  spi_master1_sdi3_i ),
    //uart
    .uart_tx                  (  uart_tx   ),
    .uart_rx                  (  uart_rx   ),
    .uart1_tx                 (  uart1_tx  ),
    .uart1_rx                 (  uart1_rx  ),

    //I2C
    .scl_pad_i                ( core_scl_pad_i     ),
    .scl_pad_o                ( core_scl_pad_o     ),
    .scl_padoen_o             ( core_scl_padoen_o  ),
    .sda_pad_i                ( core_sda_pad_i     ),
    .sda_pad_o                ( core_sda_pad_o     ), 
    .sda_padoen_o             ( core_sda_padoen_o  ),

    .scl1_pad_i               ( core_scl1_pad_i     ),
    .scl1_pad_o               ( core_scl1_pad_o     ),
    .scl1_padoen_o            ( core_scl1_padoen_o  ),
    .sda1_pad_i               ( core_sda1_pad_i     ),
    .sda1_pad_o               ( core_sda1_pad_o     ), 
    .sda1_padoen_o            ( core_sda1_padoen_o  ),

    //gpio
    .gpio_in                  (  core_gpio_in       ),
    .gpio_out                 (  core_gpio_out      ),
    .gpio_dir                 (  core_gpio_dir      ),

    //pwm
    .pwm_o                    (  pwm_o              ),

   //camera
    .cam_pclk                (  cam_pclk                  ),
    .cam_vsync               (  cam_vsync                 ),
    .cam_href                (  cam_href                  ),
    .cam_data                (  cam_data                  ),
	
	//eMMC
    .emmc_cclk_out            (  emmc_cclk_out             ),
    .emmc_ccmd_in             (  core_emmc_ccmd_in         ),
    .emmc_ccmd_out            (  core_emmc_ccmd_out        ),
    .emmc_ccmd_out_en         (  core_emmc_ccmd_out_en     ),
    .emmc_cdata_in	          (  core_emmc_cdata_in        ),
    .emmc_cdata_out		      (  core_emmc_cdata_out       ),
    .emmc_cdata_out_en        (  core_emmc_cdata_out_en    ),
    .emmc_card_detect_n       (  emmc_card_detect_n        ),
    .emmc_card_write_prt      (  emmc_card_write_prt       ),
    .emmc_card_power_en	      (   ),
    .emmc_card_volt_a	      (   ),
    .emmc_card_volt_b	      (   ),
    .emmc_ccmd_od_pullup_en_n (   ),
                    
    .sd_biu_volt_reg          (   ),

    .sdio_card_int_n          (  sdio_card_int_n           ),
    .sdio_back_end_power      (   ),

    .mmc_4_4_rst_n            (  mmc_4_4_rst_n             ),
    .emmc_biu_volt_reg_1_2    (   ),

     //ddr3
    .ddr3_addr                (ddr3_addr              ),  // output [14:0]		ddr3_addr
    .ddr3_ba                  (ddr3_ba                ),  // output [2:0]		ddr3_ba
    .ddr3_cas_n               (ddr3_cas_n             ),  // output			ddr3_cas_n
    .ddr3_ck_n                (ddr3_ck_n              ),  // output [0:0]		ddr3_ck_n
    .ddr3_ck_p                (ddr3_ck_p              ),  // output [0:0]		ddr3_ck_p
    .ddr3_cke                 (ddr3_cke               ),  // output [0:0]		ddr3_cke
    .ddr3_ras_n               (ddr3_ras_n             ),  // output			ddr3_ras_n
    .ddr3_reset_n             (ddr3_reset_n           ),  // output			ddr3_reset_n
    .ddr3_we_n                (ddr3_we_n              ),  // output			ddr3_we_n
    .ddr3_dq                  (ddr3_dq                ),  // inout [31:0]		ddr3_dq
    .ddr3_dqs_n               (ddr3_dqs_n             ),  // inout [3:0]		ddr3_dqs_n
    .ddr3_dqs_p               (ddr3_dqs_p             ),  // inout [3:0]		ddr3_dqs_p
	.ddr3_cs_n                (ddr3_cs_n              ),  // output [0:0]		ddr3_cs_n
    .ddr3_dm                  (ddr3_dm                ),  // output [3:0]		ddr3_dm
    .ddr3_odt                 (ddr3_odt               ),  // output [0:0]		ddr3_odt

    .init_calib_complete      (init_calib_complete    ),  // output			init_calib_complete 

     //jtag
    .tck_i                    (  tck_i   ),
    .trstn_i                  (  trstn_i ),
    .tms_i                    (  tms_i   ),
    .tdi_i                    (  tdi_i   ),
    .tdo_o                    (  tdo_o   ),
    .clk_int (clk_int),
   // .clk_div2 (xclk),
    .rstn_int (rstn_int)
  );

  triBuf
  #(.IOPUT_NUM (1))
  tribuf_scl
   (
    .core_in  ( core_scl_pad_o   ),
    .core_out ( core_scl_pad_i   ),
    .core_oe  ( ~core_scl_padoen_o ),
    .io_inout ( scl   )
  );

  triBuf
  #(.IOPUT_NUM (1))
  tribuf_sda
   (
    .core_in  ( core_sda_pad_o   ),
    .core_out ( core_sda_pad_i   ),
    .core_oe  ( ~core_sda_padoen_o ),
    .io_inout ( sda   )
  );

  triBuf
  #(.IOPUT_NUM (1))
  tribuf_scl1
   (
    .core_in  ( core_scl1_pad_o   ),
    .core_out ( core_scl1_pad_i   ),
    .core_oe  ( ~core_scl1_padoen_o ),
    .io_inout ( scl1   )
  );

  triBuf
  #(.IOPUT_NUM (1))
  tribuf_sda1
   (
    .core_in  ( core_sda1_pad_o   ),
    .core_out ( core_sda1_pad_i   ),
    .core_oe  ( ~core_sda1_padoen_o ),
    .io_inout ( sda1   )
  );

  triBuf
  #(.IOPUT_NUM (32))
  tribuf_gpio
   (
    .core_in  ( core_gpio_out ),
    .core_out ( core_gpio_in  ),
    .core_oe  ( core_gpio_dir ),
    .io_inout ( gpio          )
  );

  triBuf
  #(.IOPUT_NUM (2))
  tribuf_emmc_ccmd
   (
    .core_in  ( core_emmc_ccmd_out ),
    .core_out ( core_emmc_ccmd_in  ),
    .core_oe  ( core_emmc_ccmd_out_en ),
    .io_inout ( emmc_ccmd          )
  );

  triBuf
  #(.IOPUT_NUM (16))
  tribuf_emmc_cdata
   (
    .core_in  ( core_emmc_cdata_out    ),
    .core_out ( core_emmc_cdata_in     ),
    .core_oe  ( core_emmc_cdata_out_en ),
    .io_inout ( emmc_cdata             )
  );

///////////////////////////////////////////
////                                  ////
////          PLL0 + PPU0             ////
////                                  ////
//////////////////////////////////////////


//pll0
//  pll0_i
//   (
//    .sys_clk_p        (  sys_clk_p  ),
//    .sys_clk_n        (  sys_clk_n  ),
//    .rstn_i           (  rstn_i     ),
//
//    .clk_o            (  pll0_clk    ),
//    .locked           (  pll0_locked )
//   );
//

//clk_div2 clk_div2_i( 
//   .clk    (ui_clk),
//   .rst_n  (ui_rst  ), 
//   .clk_out(ppu0_clk)
//);

  ppu0_top
  ppu0_top_i
   (
    .clk                      (  clk_int      ),
    .rst_n                    ( rstn_int        ),
    .lock                     (  1'b1  ),

    .testmode_i               (  c0_testmode_i     ),
    .fetch_enable_i           (  c0_fetch_enable_i ),
    //spi slave
    .spi_clk_i                (  c0_spi_clk_i  ),
    .spi_cs_i                 (  c0_spi_cs_i   ),
    .spi_sdo0_o               (  c0_spi_sdo0_o ),
    .spi_sdo1_o               (  c0_spi_sdo1_o ),
    .spi_sdo2_o               (  c0_spi_sdo2_o ),
    .spi_sdo3_o               (  c0_spi_sdo3_o ),
    .spi_sdi0_i               (  c0_spi_sdi0_i ),
    .spi_sdi1_i               (  c0_spi_sdi1_i ),
    .spi_sdi2_i               (  c0_spi_sdi2_i ),
    .spi_sdi3_i               (  c0_spi_sdi3_i ),
    //uart
    .uart_tx                  (  c0_uart_tx  ),
    .uart_rx                  (  c0_uart_rx  ),
    //SPI master
    .spi_master_clk_o         ( c0_spim_clk_o  ),
    .spi_master_csn0_o        ( c0_spim_csn0_o ),
    .spi_master_csn1_o        ( c0_spim_csn1_o ),
    .spi_master_csn2_o        ( c0_spim_csn2_o ),
    .spi_master_csn3_o        ( c0_spim_csn3_o ),
    .spi_master_sdo0_o        ( c0_spim_sdo0_o ),
    .spi_master_sdo1_o        ( c0_spim_sdo1_o ),
    .spi_master_sdo2_o        ( c0_spim_sdo2_o ),
    .spi_master_sdo3_o        ( c0_spim_sdo3_o ),
    .spi_master_sdi0_i        ( c0_spim_sdi0_i ),
    .spi_master_sdi1_i        ( c0_spim_sdi1_i ),
    .spi_master_sdi2_i        ( c0_spim_sdi2_i ),
    .spi_master_sdi3_i        ( c0_spim_sdi3_i ),
    //I2C
    .scl_pad_i                ( core0_scl_pad_i     ),
    .scl_pad_o                ( core0_scl_pad_o     ),
    .scl_padoen_o             ( core0_scl_padoen_o  ),
    .sda_pad_i                ( core0_sda_pad_i     ),
    .sda_pad_o                ( core0_sda_pad_o     ),
    .sda_padoen_o             ( core0_sda_padoen_o  ),
    //gpio
    .gpio_in                  ( core0_gpio_in       ),
    .gpio_out                 ( core0_gpio_out      ),
    .gpio_dir                 ( core0_gpio_dir      ),
     //pwm
    .pwm_o                    ( c0_pwm_o            ),
     //jtag
    .tck_i                    ( c0_tck_i            ),
    .trstn_i                  ( c0_trstn_i          ),
    .tms_i                    ( c0_tms_i            ),
    .tdi_i                    ( c0_tdi_i            ),
    .tdo_o                    ( c0_tdo_o            )
  );

  triBuf
  #(.IOPUT_NUM (1))
  tribuf_c0_scl
   (
    .core_in  ( core0_scl_pad_o   ),
    .core_out ( core0_scl_pad_i   ),
    .core_oe  ( ~core0_scl_padoen_o ),
    .io_inout ( c0_scl   )
  );

  triBuf
  #(.IOPUT_NUM (1))
  tribuf_c0_sda
   (
    .core_in  ( core0_sda_pad_o   ),
    .core_out ( core0_sda_pad_i   ),
    .core_oe  ( ~core0_sda_padoen_o ),
    .io_inout ( c0_sda   )
  );

  triBuf
  #(.IOPUT_NUM (32))
  tribuf_c0_gpio
   (
    .core_in  ( core0_gpio_out ),
    .core_out ( core0_gpio_in  ),
    .core_oe  ( core0_gpio_dir ),
    .io_inout ( c0_gpio        )
  );

endmodule

