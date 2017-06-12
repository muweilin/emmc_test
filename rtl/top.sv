// TOP : 109 pins
//
`include "config.sv"

module top
(
///////////////////////////////////////////
//         Common: 5 pins            //////
///////////////////////////////////////////
    input  logic              clk_i,
    input  logic [1:0]        div_pll_i,
    input  logic              pll_bps_i,
    input  logic              rstn_i,

///////////////////////////////////////////
////        PPU: 81 pins              ////
//////////////////////////////////////////
    //misc (2 pins)
    input  logic              testmode_i,
    input  logic              fetch_enable_i,

    //SPI Master(4 pins)
    output logic              spi_master_clk_o,
    output logic              spi_master_csn0_o,
    output logic              spi_master_sdo0_o,
    input  logic              spi_master_sdi0_i,
    //uart(2 pins)
    output logic              uart_tx,
    input  logic              uart_rx,

    //memctl(47 pins)
	output logic              memctl_s_ck_p,
	output logic              memctl_s_ck_n,
	output logic              memctl_s_sel_n,
	output logic              memctl_s_cke,
	output logic              memctl_s_ras_n,
	output logic              memctl_s_cas_n,
	output logic              memctl_s_we_n,
	output logic [15: 0]      memctl_s_addr,
	output logic [ 1: 0]      memctl_s_bank_addr,
	output logic [ 1: 0]      memctl_s_dqm,
	inout  wire  [ 1: 0]      memctl_s_dqs,               //tri pulldown
	inout  wire  [15: 0]      memctl_s_dq,                //tri pulldown
	output logic              memctl_s_rd_dqs_mask,
	input  logic              memctl_int_rd_dqs_mask,

    //eMMC(10 pins)
	output logic              emmc_cclk_out,
	inout  wire               emmc_ccmd,          //tri pullup
	inout  wire  [3: 0]       emmc_cdata,         //tri pullup
	input logic               emmc_card_detect_n,
	input logic               emmc_card_write_prt,
//	output logic              emmc_ccmd_od_pullup_en_n,
	input  logic              sdio_card_int_n,
	output logic              mmc_4_4_rst_n,


    //14 muxed pins
    //PIN0
    inout wire   PIN0_scl_uart1tx,
    //PIN1
    inout wire   PIN1_sda_uart1rx,
    //PIN2
    inout wire   PIN2_spim1sdo0_gpio0,
    //PIN3
    inout wire   PIN3_spim1csn0_gpio1,
    //PIN4
    inout wire   PIN4_spim1sdi0_vsync,
    //PIN5
    inout wire   PIN5_pwm0_href,
    //PIN6
    inout wire   PIN6_pwm1_camdata7,
    //PIN7
    inout wire   PIN7_pwm2_camdata6,
    //PIN8
    inout wire   PIN8_pwm3_camdata5,
    //PIN9
    inout wire   PIN9_gpio2_camdata4,
    //PIN10
    inout wire   PIN10_gpio3_camdata3,
    //PIN11
    inout wire   PIN11_gpio4_camdata2,
    //PIN12
    inout wire   PIN12_gpio5_camdata1,
    //PIN13
    inout wire   PIN13_gpio6_camdata0,

    //2 extra clock pins
    output logic              spim1clk,
    input  logic              pclk,

///////////////////////////////////////////
////         PPU0: 12 pins            ////
//////////////////////////////////////////
    input  logic             c0_testmode_i,
    input  logic             c0_fetch_enable_i,

    output  logic            c0_uart_tx,
    input  logic             c0_uart_rx,

    //PIN0
    inout wire               c0_PIN0_spimclk_scl,
    //PIN1
    inout wire               c0_PIN1_spimcsn_sda,
    //PIN2
    inout wire               c0_PIN2_spimsdo_gpio0,
    //PIN3
    inout wire               c0_PIN3_spimsdi_gpio1,
   //PIN4
    inout wire               c0_PIN4_pwm0_gpio2,
   //PIN5
    inout wire               c0_PIN5_pwm1_gpio3,
   //PIN6
    inout wire               c0_PIN6_pwm2_gpio4,
   //PIN7
    inout wire               c0_PIN7_pwm3_gpio5,

///////////////////////////////////////////
////      Shared part: 11 pins         ////
//////////////////////////////////////////
    input logic              select_c0_i,

   //SPI Slave(5 pins)
    input  logic             spi_cs_i,     //ppu
    input  logic             c0_spi_cs_i,  //ppu0
    input  logic             spi_clk_i,
    output logic             spi_sdo0_o,
    input  logic             spi_sdi0_i,

    //jtag(5 pins)
    input  logic             tck_i,
    input  logic             trstn_i,
    input  logic             tms_i,
    input  logic             tdi_i,
    output logic             tdo_o
   );

    logic              shared_clk_i;
    logic              shared_rstn_i;

    logic  [1:0]       shared_div_pll_i;
    logic              shared_pll_bps_i;

`ifdef HAPS
    logic              pll_clk2x;
`endif

    logic              pll_clk;
    logic              pll_locked;

    logic              core_testmode_i;
    logic              core_fetch_enable_i;

    //SPI Master
    logic              core_spi_master_clk_o;
    logic              core_spi_master_csn0_o;
    logic              core_spi_master_sdo0_o;
    logic              core_spi_master_sdi0_i;

    logic              core_uart_tx;
    logic              core_uart_rx;

    //memctl
    logic              core_memctl_s_ck_p;
    logic              core_memctl_s_ck_n;
    logic              core_memctl_s_sel_n;
    logic              core_memctl_s_cke;
    logic              core_memctl_s_ras_n;
    logic              core_memctl_s_cas_n;
    logic              core_memctl_s_we_n;
    logic [15: 0]      core_memctl_s_addr;
    logic [ 1: 0]      core_memctl_s_bank_addr;
    logic [ 1: 0]      core_memctl_s_dqm;

    logic [ 1: 0]      core_memctl_s_dout_oe;
    logic [ 1: 0]      core_memctl_s_dqs_wr;
    logic [ 1: 0]      core_memctl_s_dqs_rd;
    logic [15: 0]      core_memctl_s_dq_wr;
    logic [15: 0]      core_memctl_s_dq_rd;

    logic              core_memctl_s_rd_dqs_mask;
    logic              core_memctl_int_rd_dqs_mask;

    //eMMC
    logic [ 1: 0]      core_emmc_cclk_out;
	                    
    logic [ 1: 0]      core_emmc_ccmd_in;
    logic [ 1: 0]      core_emmc_ccmd_out;
    logic [ 1: 0]      core_emmc_ccmd_out_en;
	                    
    logic [15: 0]      core_emmc_cdata_in;
    logic [15: 0]      core_emmc_cdata_out;
    logic [15: 0]      core_emmc_cdata_out_en;
	                    
    logic [ 1: 0]      core_emmc_card_detect_n;
    logic [ 1: 0]      core_emmc_card_write_prt;
	                    
    logic [ 1: 0]      core_sdio_card_int_n;
    logic [ 1: 0]      core_mmc_4_4_rst_n;


    logic              core_scl_uart1tx_o;
    logic              core_sda_uart1rx_o;
    logic              core_spim1sdo0_gpio0_o;
    logic              core_spim1csn0_gpio1_o;
    logic              core_spim1sdi0_vsync_o;
    logic              core_pwm0_href_o;
    logic              core_pwm1_camdata7_o;
    logic              core_pwm2_camdata6_o;
    logic              core_pwm3_camdata5_o;
    logic              core_gpio2_camdata4_o;
    logic              core_gpio3_camdata3_o;
    logic              core_gpio4_camdata2_o;
    logic              core_gpio5_camdata1_o;
    logic              core_gpio6_camdata0_o;

    logic              core_scl_uart1tx_oe;
    logic              core_sda_uart1rx_oe;
    logic              core_spim1sdo0_gpio0_oe;
    logic              core_spim1csn0_gpio1_oe;
    logic              core_spim1sdi0_vsync_oe;
    logic              core_pwm0_href_oe;
    logic              core_pwm1_camdata7_oe;
    logic              core_pwm2_camdata6_oe;
    logic              core_pwm3_camdata5_oe;
    logic              core_gpio2_camdata4_oe;
    logic              core_gpio3_camdata3_oe;
    logic              core_gpio4_camdata2_oe;
    logic              core_gpio5_camdata1_oe;
    logic              core_gpio6_camdata0_oe;

    logic              core_scl_uart1tx_i;
    logic              core_sda_uart1rx_i;
    logic              core_spim1sdo0_gpio0_i;
    logic              core_spim1csn0_gpio1_i;
    logic              core_spim1sdi0_vsync_i;
    logic              core_pwm0_href_i;
    logic              core_pwm1_camdata7_i;
    logic              core_pwm2_camdata6_i;
    logic              core_pwm3_camdata5_i;
    logic              core_gpio2_camdata4_i;
    logic              core_gpio3_camdata3_i;
    logic              core_gpio4_camdata2_i;
    logic              core_gpio5_camdata1_i;
    logic              core_gpio6_camdata0_i;

    logic              core_spim1clk;
    logic              core_pclk;

    logic              pll0_clk;
    logic              pll0_locked;

    logic              core0_testmode_i;
    logic              core0_fetch_enable_i;

    logic              core0_uart_tx;
    logic              core0_uart_rx;

    logic              core0_spimclk_scl_o;
    logic              core0_spimcsn_sda_o;
    logic              core0_spimsdo_gpio0_o;
    logic              core0_spimsdi_gpio1_o;
    logic              core0_pwm0_gpio2_o;
    logic              core0_pwm1_gpio3_o;
    logic              core0_pwm2_gpio4_o;
    logic              core0_pwm3_gpio5_o;

    logic              core0_spimclk_scl_oe;
    logic              core0_spimcsn_sda_oe;
    logic              core0_spimsdo_gpio0_oe;
    logic              core0_spimsdi_gpio1_oe;
    logic              core0_pwm0_gpio2_oe;
    logic              core0_pwm1_gpio3_oe;
    logic              core0_pwm2_gpio4_oe;
    logic              core0_pwm3_gpio5_oe;

    logic              core0_spimclk_scl_i;
    logic              core0_spimcsn_sda_i;
    logic              core0_spimsdo_gpio0_i;
    logic              core0_spimsdi_gpio1_i;
    logic              core0_pwm0_gpio2_i;
    logic              core0_pwm1_gpio3_i;
    logic              core0_pwm2_gpio4_i;
    logic              core0_pwm3_gpio5_i;

// shared select
    logic              core_select_c0_i;

    logic              core_spi_cs_i;
    logic              core0_spi_cs_i;

    logic              shared_spi_clk_i;
    logic              shared_spi_sdi0_i;
    logic              shared_spi_sdo0_o;

    logic              core_spi_sdo0_o;
    logic              core0_spi_sdo0_o;

    // JTAG signals
    logic              shared_tck_i;
    logic              shared_trstn_i;
    logic              shared_tms_i;
    logic              shared_tdi_i;
    logic              shared_tdo_o;
    logic              core_tdo_o;
    logic              core0_tdo_o;
    logic              core_trstn_i;
    logic              core0_trstn_i;

///////////////////////////////////////////
////                                  ////
////          PLL + PPU               ////
////                                  ////
//////////////////////////////////////////
  pll
  pll_i
   (
    .clk_i             ( shared_clk_i     ),
    .div_i             ( shared_div_pll_i ),
    .rstn_i            ( shared_rstn_i    ),
    .pll_bps_i         ( shared_pll_bps_i ),

    .clk_o             ( pll_clk        ),

`ifdef HAPS
    .clk2x_o           ( pll_clk2x      ),
`endif

    .locked            ( pll_locked     )
   );

  ppu_top
  ppu_top_i
   (

`ifdef HAPS
//    .OBS_PIN                  (  OBS_PIN      ),
    .clk2x                    (  pll_clk2x    ),
`endif

    .clk                      (  pll_clk      ),
    .rst_n                    (  shared_rstn_i  ),
    .lock                     (  pll_locked   ),
    .pll_bps_i                (  shared_pll_bps_i ),
    .testmode_i               (  core_testmode_i     ),
    .fetch_enable_i           (  core_fetch_enable_i ),
    //spi slave
    .spi_clk_i                (  shared_spi_clk_i  ),
    .spi_cs_i                 (  core_spi_cs_i   ),
    .spi_sdo0_o               (  core_spi_sdo0_o ),
    .spi_sdi0_i               (  shared_spi_sdi0_i ),
    //spi master
    .spi_master_clk_o         (  core_spi_master_clk_o  ), 
    .spi_master_csn0_o        (  core_spi_master_csn0_o ),
    .spi_master_sdo0_o        (  core_spi_master_sdo0_o ),
    .spi_master_sdi0_i        (  core_spi_master_sdi0_i ),
    //uart
    .uart_tx                  (  core_uart_tx  ),
    .uart_rx                  (  core_uart_rx  ),
     //jtag
    .tck_i                    (  shared_tck_i   ),
    .trstn_i                  (  core_trstn_i ),
    .tms_i                    (  shared_tms_i   ),
    .tdi_i                    (  shared_tdi_i   ),
    .tdo_o                    (  core_tdo_o   ),
	//memctl
    .memctl_s_ck_p            (  core_memctl_s_ck_p             ),
    .memctl_s_ck_n            (  core_memctl_s_ck_n             ),
    .memctl_s_sel_n           (  core_memctl_s_sel_n            ),
    .memctl_s_cke             (  core_memctl_s_cke              ),
    .memctl_s_ras_n	          (  core_memctl_s_ras_n            ),
    .memctl_s_cas_n	          (  core_memctl_s_cas_n            ),
    .memctl_s_we_n		      (  core_memctl_s_we_n             ),
    .memctl_s_addr		      (  core_memctl_s_addr             ),
    .memctl_s_bank_addr	      (  core_memctl_s_bank_addr        ),
    .memctl_s_dqm		      (  core_memctl_s_dqm              ),
    .memctl_s_dout_oe         (  core_memctl_s_dout_oe          ),
    .memctl_s_dqs_wr          (  core_memctl_s_dqs_wr           ),
    .memctl_s_dqs_rd          (  core_memctl_s_dqs_rd           ),
    .memctl_s_dq_wr           (  core_memctl_s_dq_wr            ),
    .memctl_s_dq_rd           (  core_memctl_s_dq_rd            ),
    .memctl_s_rd_dqs_mask     (  core_memctl_s_rd_dqs_mask      ),
    .memctl_int_rd_dqs_mask   (  core_memctl_int_rd_dqs_mask    ),
	//eMMC
    .emmc_cclk_out            (  core_emmc_cclk_out             ),
    .emmc_ccmd_in             (  core_emmc_ccmd_in              ),
    .emmc_ccmd_out            (  core_emmc_ccmd_out             ),
    .emmc_ccmd_out_en         (  core_emmc_ccmd_out_en          ),
    .emmc_cdata_in	          (  core_emmc_cdata_in             ),
    .emmc_cdata_out		      (  core_emmc_cdata_out            ),
    .emmc_cdata_out_en        (  core_emmc_cdata_out_en         ),
    .emmc_card_detect_n       (  core_emmc_card_detect_n        ),
    .emmc_card_write_prt      (  core_emmc_card_write_prt       ),
    .emmc_card_power_en	      (  ),
    .emmc_card_volt_a	      (  ),
    .emmc_card_volt_b	      (  ),
    .emmc_ccmd_od_pullup_en_n (  ),
    .sd_biu_volt_reg          (  ),
    .sdio_card_int_n          (  core_sdio_card_int_n           ),
    .sdio_back_end_power      (  ),
    .mmc_4_4_rst_n            (  core_mmc_4_4_rst_n             ),
    .emmc_biu_volt_reg_1_2    (  ),

    //PIN0
    .scl_uart1tx_o        (  core_scl_uart1tx_o   ),
    .scl_uart1tx_i        (  core_scl_uart1tx_i   ),
    .scl_uart1tx_oe       (  core_scl_uart1tx_oe  ),
    //PIN1
    .sda_uart1rx_o        (  core_sda_uart1rx_o   ),
    .sda_uart1rx_i        (  core_sda_uart1rx_i   ),
    .sda_uart1rx_oe       (  core_sda_uart1rx_oe  ),
    //PIN2
    .spim1sdo0_gpio0_o    (  core_spim1sdo0_gpio0_o  ),
    .spim1sdo0_gpio0_i    (  core_spim1sdo0_gpio0_i  ),
    .spim1sdo0_gpio0_oe   (  core_spim1sdo0_gpio0_oe ),
    //PIN3
    .spim1csn0_gpio1_o    (  core_spim1csn0_gpio1_o  ),
    .spim1csn0_gpio1_i    (  core_spim1csn0_gpio1_i  ),
    .spim1csn0_gpio1_oe   (  core_spim1csn0_gpio1_oe ),
    //PIN4
    .spim1sdi0_vsync_o    (  core_spim1sdi0_vsync_o  ),
    .spim1sdi0_vsync_i    (  core_spim1sdi0_vsync_i  ),
    .spim1sdi0_vsync_oe   (  core_spim1sdi0_vsync_oe ),
    //PIN5
    .pwm0_href_o          (  core_pwm0_href_o  ),
    .pwm0_href_i          (  core_pwm0_href_i  ),
    .pwm0_href_oe         (  core_pwm0_href_oe ),
    //PIN6
    .pwm1_camdata7_o      (  core_pwm1_camdata7_o  ),
    .pwm1_camdata7_i      (  core_pwm1_camdata7_i  ),
    .pwm1_camdata7_oe     (  core_pwm1_camdata7_oe ),
    //PIN7
    .pwm2_camdata6_o      (  core_pwm2_camdata6_o  ),
    .pwm2_camdata6_i      (  core_pwm2_camdata6_i  ),
    .pwm2_camdata6_oe     (  core_pwm2_camdata6_oe ),
    //PIN8
    .pwm3_camdata5_o      (  core_pwm3_camdata5_o  ),
    .pwm3_camdata5_i      (  core_pwm3_camdata5_i  ),
    .pwm3_camdata5_oe     (  core_pwm3_camdata5_oe ),
    //PIN9
    .gpio2_camdata4_o     (  core_gpio2_camdata4_o  ),
    .gpio2_camdata4_i     (  core_gpio2_camdata4_i  ),
    .gpio2_camdata4_oe    (  core_gpio2_camdata4_oe ),
    //PIN10
    .gpio3_camdata3_o     (  core_gpio3_camdata3_o  ),
    .gpio3_camdata3_i     (  core_gpio3_camdata3_i  ),
    .gpio3_camdata3_oe    (  core_gpio3_camdata3_oe ),
    //PIN11
    .gpio4_camdata2_o     (  core_gpio4_camdata2_o  ),
    .gpio4_camdata2_i     (  core_gpio4_camdata2_i  ),
    .gpio4_camdata2_oe    (  core_gpio4_camdata2_oe ),
    //PIN12
    .gpio5_camdata1_o     (  core_gpio5_camdata1_o  ),
    .gpio5_camdata1_i     (  core_gpio5_camdata1_i  ),
    .gpio5_camdata1_oe    (  core_gpio5_camdata1_oe ),
    //PIN13
    .gpio6_camdata0_o     (  core_gpio6_camdata0_o  ),
    .gpio6_camdata0_i     (  core_gpio6_camdata0_i  ),
    .gpio6_camdata0_oe    (  core_gpio6_camdata0_oe ),

    .spi_master1_clk_o    (  core_spim1clk          ),
    .cam_pclk_i           (  core_pclk              )
  );


////  IO bufs  ////
  udfIBUF_clk_rstn 
  ibuf_clk
  (
    .core_out ( shared_clk_i ),
    .io_in    (        clk_i )
  );

  udfIBUF_clk_rstn
  ibuf_rstn
  (
    .core_out ( shared_rstn_i ),
    .io_in    (        rstn_i )
  );

  udfIBUF_io_up
  #(.INPUT_NUM (2))
  ibuf_pll_div
  (
    .core_out ( shared_div_pll_i ),
    .io_in    (        div_pll_i )
  );

  udfIBUF_io_up
  ibuf_pll_bps
  (
    .core_out ( shared_pll_bps_i ),
    .io_in    (        pll_bps_i )
  );

  udfIBUF_io_dn 
  ibuf_testmode
  (
    .core_out ( core_testmode_i ),
    .io_in    (      testmode_i )
  );

  udfIBUF_io_dn
  ibuf_fetch_en
  (
    .core_out ( core_fetch_enable_i ),
    .io_in    (      fetch_enable_i )
  );

  udfOBUF_clk
  obuf_spim_clk  
  (
    .io_out (      spi_master_clk_o ),
    .core_in( core_spi_master_clk_o )
  );

  udfOBUF_io
  obuf_spim_cs
  (
    .io_out (      spi_master_csn0_o ),
    .core_in( core_spi_master_csn0_o )
  );

  udfOBUF_io
  obuf_spim
  (
    .io_out (      spi_master_sdo0_o ),
    .core_in( core_spi_master_sdo0_o )
  );

  udfIBUF_io_dn
  ibuf_spim
  (
    .core_out ( core_spi_master_sdi0_i ),
    .io_in    (      spi_master_sdi0_i )
  );

  udfOBUF_io
  obuf_uart
  (
    .io_out (      uart_tx ),
    .core_in( core_uart_tx )
  );

  udfIBUF_io_dn
  ibuf_uart
  (
    .core_out ( core_uart_rx ),
    .io_in    (      uart_rx )
  );

//memctl
  udfOBUF_clk
  #(.OUTPUT_NUM (2))
  obuf_memctl_ck  
  (
    .io_out ( {     memctl_s_ck_p,      memctl_s_ck_n} ),
    .core_in( {core_memctl_s_ck_p, core_memctl_s_ck_n} )
  );

  udfOBUF_io
  #(.OUTPUT_NUM (23))
  obuf_memctl_cmd
  (
    .io_out ( {     memctl_s_sel_n,      memctl_s_cke,      memctl_s_ras_n,      memctl_s_cas_n,      memctl_s_we_n,      memctl_s_addr,      memctl_s_bank_addr} ),
    .core_in( {core_memctl_s_sel_n, core_memctl_s_cke, core_memctl_s_ras_n, core_memctl_s_cas_n, core_memctl_s_we_n, core_memctl_s_addr, core_memctl_s_bank_addr})
  );

  udfOBUF_io
  #(.OUTPUT_NUM (2))
  obuf_memctl_dqm
  (
    .io_out (      memctl_s_dqm ),
    .core_in( core_memctl_s_dqm )
  );

  TriBUF_dn
  #(.IOPUT_NUM (2))
  tribuf_memctl_dqs
   (
    .core_in  ( core_memctl_s_dqs_wr   ),
    .core_out ( core_memctl_s_dqs_rd    ),
    .core_oe  ( core_memctl_s_dout_oe ),
    .io_inout ( memctl_s_dqs   )
  );

  TriBUF_z
  #(.IOPUT_NUM (16))
  tribuf_memctl_dq
   (
    .core_in  ( core_memctl_s_dq_wr  ),
    .core_out ( core_memctl_s_dq_rd  ),
    .core_oe  ( { {8{core_memctl_s_dout_oe[1]}}, {8{core_memctl_s_dout_oe[0]}} } ),
    .io_inout ( memctl_s_dq   )
  );

  udfOBUF_io
  obuf_memctl_rd_dqs
  (
    .io_out (      memctl_s_rd_dqs_mask ),
    .core_in( core_memctl_s_rd_dqs_mask )
  );

  udfIBUF_io_dn
  ibuf_memctl_int_rd_dqs
  (
    .core_out ( core_memctl_int_rd_dqs_mask ),
    .io_in    (      memctl_int_rd_dqs_mask )
  );

//eMMC
  udfOBUF_clk
  obuf_emmc_cclk
  (
    .io_out (      emmc_cclk_out    ),
    .core_in( core_emmc_cclk_out[0] )
  );

  TriBUF_up
  tribuf_emmc_ccmd
   (
    .core_in  ( core_emmc_ccmd_out[0]    ),
    .core_out ( core_emmc_ccmd_in[0]     ),
    .core_oe  ( core_emmc_ccmd_out_en[0] ),
    .io_inout (      emmc_ccmd           )
  );

  TriBUF_up
  #(.IOPUT_NUM (4))
  tribuf_emmc_cdata
   (
    .core_in  ( core_emmc_cdata_out[3:0]    ),
    .core_out ( core_emmc_cdata_in[3:0]     ),
    .core_oe  ( core_emmc_cdata_out_en[3:0] ),
    .io_inout (      emmc_cdata             )
  );

  udfIBUF_io_up
  ibuf_emmc_card_detect
  (
    .core_out ( core_emmc_card_detect_n[0] ),
    .io_in    (      emmc_card_detect_n    )
  );

  udfIBUF_io_up
  ibuf_emmc_write_prt
  (
    .core_out ( core_emmc_card_write_prt[0] ),
    .io_in    (      emmc_card_write_prt    )
  );

  udfIBUF_io_up
  ibuf_sdio_card_int
  (
    .core_out ( core_sdio_card_int_n[0] ),
    .io_in    (      sdio_card_int_n    )
  );

  udfOBUF_clk
  obuf_mmc_rst
  (
    .io_out  (      mmc_4_4_rst_n    ),
    .core_in ( core_mmc_4_4_rst_n[0] )
  );

//emmc[1] unconnected
  assign  core_emmc_ccmd_in[1]        = 1'b1;
                   
  assign  core_emmc_cdata_in[15:4]    = 12'hFFF;

  assign  core_emmc_card_detect_n[1]  = 1'b1 ;

  assign  core_emmc_card_write_prt[1] = 1'b1 ;

  assign  core_sdio_card_int_n[1]     = 1'b1 ;


  TriBUF_z
  #(.IOPUT_NUM (14))
  tribuf_mux_io_pins
   (
    .core_in  ( {
    core_scl_uart1tx_o,
    core_sda_uart1rx_o,
    core_spim1sdo0_gpio0_o,
    core_spim1csn0_gpio1_o,
    core_spim1sdi0_vsync_o,
    core_pwm0_href_o,
    core_pwm1_camdata7_o,
    core_pwm2_camdata6_o,
    core_pwm3_camdata5_o,
    core_gpio2_camdata4_o,
    core_gpio3_camdata3_o,
    core_gpio4_camdata2_o,
    core_gpio5_camdata1_o,
    core_gpio6_camdata0_o
    } ),

    .core_out  ( {
    core_scl_uart1tx_i,
    core_sda_uart1rx_i,
    core_spim1sdo0_gpio0_i,
    core_spim1csn0_gpio1_i,
    core_spim1sdi0_vsync_i,
    core_pwm0_href_i,
    core_pwm1_camdata7_i,
    core_pwm2_camdata6_i,
    core_pwm3_camdata5_i,
    core_gpio2_camdata4_i,
    core_gpio3_camdata3_i,
    core_gpio4_camdata2_i,
    core_gpio5_camdata1_i,
    core_gpio6_camdata0_i
    } ),

    .core_oe  ( {
    core_scl_uart1tx_oe,
    core_sda_uart1rx_oe,
    core_spim1sdo0_gpio0_oe,
    core_spim1csn0_gpio1_oe,
    core_spim1sdi0_vsync_oe,
    core_pwm0_href_oe,
    core_pwm1_camdata7_oe,
    core_pwm2_camdata6_oe,
    core_pwm3_camdata5_oe,
    core_gpio2_camdata4_oe,
    core_gpio3_camdata3_oe,
    core_gpio4_camdata2_oe,
    core_gpio5_camdata1_oe,
    core_gpio6_camdata0_oe
    } ),

    .io_inout  ( {
    PIN0_scl_uart1tx,
    PIN1_sda_uart1rx,
    PIN2_spim1sdo0_gpio0,
    PIN3_spim1csn0_gpio1,
    PIN4_spim1sdi0_vsync,
    PIN5_pwm0_href,
    PIN6_pwm1_camdata7,
    PIN7_pwm2_camdata6,
    PIN8_pwm3_camdata5,
    PIN9_gpio2_camdata4,
    PIN10_gpio3_camdata3,
    PIN11_gpio4_camdata2,
    PIN12_gpio5_camdata1,
    PIN13_gpio6_camdata0
    } )
  );

  udfOBUF_clk
  obuf_spim1_clk
  (
    .io_out  (      spim1clk    ),
    .core_in ( core_spim1clk    )
  );

  udfIBUF_clk_rstn 
  ibuf_pclk
  (
    .core_out ( core_pclk ),
    .io_in    (      pclk )
  );
///////////////////////////////////////////
////                                  ////
////          PLL0 + PPU0             ////
////                                  ////
//////////////////////////////////////////
  pll0
  pll0_i
   (
    .clk_i             (  shared_clk_i       ),
    .div_i             (  shared_div_pll_i ),
    .rstn_i            (  shared_rstn_i      ),
    .pll_bps_i         (  shared_pll_bps_i ),

    .clk_o             (  pll0_clk  ),
    .locked            (  pll0_locked )
   );

  ppu0_top
  ppu0_top_i
   (
    .clk                      (  pll0_clk      ),
    .rst_n                    (  shared_rstn_i   ),
    .lock                     (  pll0_locked   ),
    .pll_bps_i                (  shared_pll_bps_i ),

    .testmode_i               (  core0_testmode_i     ),
    .fetch_enable_i           (  core0_fetch_enable_i ),
    //spi slave
    .spi_clk_i                (  shared_spi_clk_i  ),
    .spi_cs_i                 (  core0_spi_cs_i   ),
    .spi_sdo0_o               (  core0_spi_sdo0_o ),
    .spi_sdi0_i               (  shared_spi_sdi0_i ),
    //uart
    .uart_tx                  (  core0_uart_tx  ),
    .uart_rx                  (  core0_uart_rx  ),
     //jtag
    .tck_i                    (  shared_tck_i   ),
    .trstn_i                  (  core0_trstn_i ),
    .tms_i                    (  shared_tms_i   ),
    .tdi_i                    (  shared_tdi_i   ),
    .tdo_o                    (  core0_tdo_o   ),
    //PIN0
    .spimclk_scl_o            (  core0_spimclk_scl_o ),
    .spimclk_scl_i            (  core0_spimclk_scl_i ),
    .spimclk_scl_oe           (  core0_spimclk_scl_oe),

    //PIN1
    .spimcsn_sda_o            (  core0_spimcsn_sda_o  ),
    .spimcsn_sda_i            (  core0_spimcsn_sda_i  ),
    .spimcsn_sda_oe           (  core0_spimcsn_sda_oe ), 

    //PIN2
    .spimsdo_gpio0_o          (  core0_spimsdo_gpio0_o ),
    .spimsdo_gpio0_i          (  core0_spimsdo_gpio0_i ),
    .spimsdo_gpio0_oe         (  core0_spimsdo_gpio0_oe),

    //PIN3
    .spimsdi_gpio1_o          (  core0_spimsdi_gpio1_o ),
    .spimsdi_gpio1_i          (  core0_spimsdi_gpio1_i ),
    .spimsdi_gpio1_oe         (  core0_spimsdi_gpio1_oe),

   //PIN4
    .pwm0_gpio2_o             (  core0_pwm0_gpio2_o  ),
    .pwm0_gpio2_i             (  core0_pwm0_gpio2_i  ),
    .pwm0_gpio2_oe            (  core0_pwm0_gpio2_oe ),

   //PIN5
    .pwm1_gpio3_o             (  core0_pwm1_gpio3_o  ),
    .pwm1_gpio3_i             (  core0_pwm1_gpio3_i  ),
    .pwm1_gpio3_oe            (  core0_pwm1_gpio3_oe ),

   //PIN6
    .pwm2_gpio4_o             (  core0_pwm2_gpio4_o  ),
    .pwm2_gpio4_i             (  core0_pwm2_gpio4_i  ),
    .pwm2_gpio4_oe            (  core0_pwm2_gpio4_oe ),

   //PIN7
    .pwm3_gpio5_o             (  core0_pwm3_gpio5_o  ),
    .pwm3_gpio5_i             (  core0_pwm3_gpio5_i  ),
    .pwm3_gpio5_oe            (  core0_pwm3_gpio5_oe )
  );

  udfIBUF_io_dn
  ibuf_testmode_core0
  (
    .core_out ( core0_testmode_i ),
    .io_in    (    c0_testmode_i )
  );

  udfIBUF_io_dn
  ibuf_fetch_en_core0
  (
    .core_out ( core0_fetch_enable_i ),
    .io_in    (    c0_fetch_enable_i )
  );

  udfOBUF_io
  obuf_uart_core0
  (
    .io_out (    c0_uart_tx ),
    .core_in( core0_uart_tx )
  );

  udfIBUF_io_dn
  ibuf_uart_core0
  (
    .core_out ( core0_uart_rx ),
    .io_in    (    c0_uart_rx )
  );


  TriBUF_sl
  tribuf_mux_io_clk_pins_core0
   (
     .core_in  ( core0_spimclk_scl_o  ), 
     .core_out ( core0_spimclk_scl_i  ), 
     .core_oe  ( core0_spimclk_scl_oe ),
     .io_inout ( c0_PIN0_spimclk_scl  ) 
   );

  TriBUF_z
  #(.IOPUT_NUM (7))
  tribuf_mux_io_pins_core0
   (
    .core_in  ( {
    core0_spimcsn_sda_o, 
    core0_spimsdo_gpio0_o, 
    core0_spimsdi_gpio1_o, 
    core0_pwm0_gpio2_o, 
    core0_pwm1_gpio3_o, 
    core0_pwm2_gpio4_o, 
    core0_pwm3_gpio5_o
    } ),

    .core_out ( {
    core0_spimcsn_sda_i, 
    core0_spimsdo_gpio0_i, 
    core0_spimsdi_gpio1_i, 
    core0_pwm0_gpio2_i, 
    core0_pwm1_gpio3_i, 
    core0_pwm2_gpio4_i, 
    core0_pwm3_gpio5_i
    } ),

    .core_oe  ( {
    core0_spimcsn_sda_oe, 
    core0_spimsdo_gpio0_oe, 
    core0_spimsdi_gpio1_oe, 
    core0_pwm0_gpio2_oe, 
    core0_pwm1_gpio3_oe, 
    core0_pwm2_gpio4_oe, 
    core0_pwm3_gpio5_oe} ),

    .io_inout ( {
    c0_PIN1_spimcsn_sda, 
    c0_PIN2_spimsdo_gpio0, 
    c0_PIN3_spimsdi_gpio1, 
    c0_PIN4_pwm0_gpio2, 
    c0_PIN5_pwm1_gpio3, 
    c0_PIN6_pwm2_gpio4, 
    c0_PIN7_pwm3_gpio5
    } )
  );

//
//  Shared part
//
  udfIBUF_io_dn
  ibuf_select_c0
  (
    .core_out ( core_select_c0_i ),
    .io_in    (      select_c0_i )
  );

//spi slave
  udfIBUF_io_up
  ibuf_spi_cs
  (
    .core_out ( core_spi_cs_i ),
    .io_in    (      spi_cs_i )
  ); //ppu spi cs

  udfIBUF_io_up
  ibuf_spi_cs_core0
  (
    .core_out ( core0_spi_cs_i ),
    .io_in    (    c0_spi_cs_i )
  ); //ppu0 spi cs

  udfIBUF_clk_rstn 
  ibuf_spi_clk
  (
    .core_out ( shared_spi_clk_i ),
    .io_in    (        spi_clk_i )
  ); //ppu/ppu0 shared spi clk

  udfIBUF_io_dn
  ibuf_spi
  (
    .core_out ( shared_spi_sdi0_i ),
    .io_in    (        spi_sdi0_i )
  ); //ppu/ppu0 shared spi sdi


  //output muxed
  assign shared_spi_sdo0_o = ( core_select_c0_i == 1'b1 )? core0_spi_sdo0_o : core_spi_sdo0_o ;

  udfOBUF_io
  obuf_shared_spi
  (
    .io_out  (        spi_sdo0_o ),
    .core_in ( shared_spi_sdo0_o )
  );

//jtag
  udfIBUF_clk_rstn
  #(.INPUT_NUM (2))
  ibuf_jtag_clk_rstn
  (
    .core_out ( {shared_tck_i, shared_trstn_i} ),
    .io_in    ( {       tck_i,        trstn_i} )
  );

  assign core_trstn_i  = ( core_select_c0_i == 1'b0 )? shared_trstn_i : 1'b0; 
  assign core0_trstn_i = ( core_select_c0_i == 1'b1 )? shared_trstn_i : 1'b0; 

  udfIBUF_io_up
  #(.INPUT_NUM (2))
  ibuf_jtag
  (
    .core_out ( {shared_tms_i, shared_tdi_i} ),
    .io_in    ( {       tms_i,        tdi_i} )
  );

  //output muxed
  assign shared_tdo_o = ( core_select_c0_i == 1'b1 )? core0_tdo_o : core_tdo_o ; 

  udfOBUF_io
  obuf_jtag_shared  
  (
    .io_out (        tdo_o ),
    .core_in( shared_tdo_o )
  );


endmodule

