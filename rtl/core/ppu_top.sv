
`include "axi_bus.sv"
`include "debug_bus.sv"
`include "config.sv"

`define AXI_ADDR_WIDTH         32
`define AXI_DATA_WIDTH         32
`define AXI_ID_MASTER_WIDTH     2
`define AXI_ID_SLAVE_WIDTH     16 
`define AXI_USER_WIDTH          1

module ppu_top
  (
`ifdef HAPS
//    output logic [47: 0]   OBS_PIN,
    input  logic             clk2x,
`endif

    // Clock and Reset
    input logic               clk,
    input logic               rst_n,
    input logic               lock,

    input logic               pll_bps_i,
    input  logic              testmode_i,
    input  logic              fetch_enable_i,

    //SPI Slave
    input  logic              spi_clk_i,
    input  logic              spi_cs_i,
    output logic              spi_sdo0_o,
    input  logic              spi_sdi0_i,

    //SPI Master
    output logic              spi_master_clk_o,
    output logic              spi_master_csn0_o,
    output logic              spi_master_sdo0_o,
    input  logic              spi_master_sdi0_i,

    output logic              uart_tx,
    input  logic              uart_rx,

    // JTAG signals
    input  logic              tck_i,
    input  logic              trstn_i,
    input  logic              tms_i,
    input  logic              tdi_i,
    output logic              tdo_o,

//**********AHB subsystem IOs**********//
//memctl
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
	output logic [ 1: 0]      memctl_s_dout_oe,
	output logic [ 1: 0]      memctl_s_dqs_wr,
	input logic  [ 1: 0]      memctl_s_dqs_rd,
	output logic [15: 0]      memctl_s_dq_wr,
	input logic  [15: 0]      memctl_s_dq_rd,
	output logic              memctl_s_rd_dqs_mask,
	input  logic              memctl_int_rd_dqs_mask,

//eMMC
	output logic [ 1: 0]      emmc_cclk_out,
	                    
	input logic  [ 1: 0]      emmc_ccmd_in,
	output logic [ 1: 0]      emmc_ccmd_out,
	output logic [ 1: 0]      emmc_ccmd_out_en,
	                    
	input logic  [15: 0]      emmc_cdata_in,
	output logic [15: 0]      emmc_cdata_out,
	output logic [15: 0]      emmc_cdata_out_en,
	                    
	input logic  [ 1: 0]      emmc_card_detect_n,
	input logic  [ 1: 0]      emmc_card_write_prt,
	                    
	output logic [ 1: 0]      emmc_card_power_en,
	output logic [ 3: 0]      emmc_card_volt_a,
	output logic [ 3: 0]      emmc_card_volt_b,
	output logic              emmc_ccmd_od_pullup_en_n,
	output logic [ 1: 0]      sd_biu_volt_reg,
	input  logic [ 1: 0]      sdio_card_int_n,
	output logic [ 1: 0]      sdio_back_end_power,
	output logic [ 1: 0]      mmc_4_4_rst_n,
	output logic [ 1: 0]      emmc_biu_volt_reg_1_2,
    
    //PIN0
    output logic   scl_uart1tx_o,
    input logic    scl_uart1tx_i,
    output logic   scl_uart1tx_oe,
    //PIN1
    output logic   sda_uart1rx_o,
    input logic    sda_uart1rx_i,
    output logic   sda_uart1rx_oe,
    //PIN2
    output logic   spim1sdo0_gpio0_o,
    input logic    spim1sdo0_gpio0_i,
    output logic   spim1sdo0_gpio0_oe,
    //PIN3
    output logic   spim1csn0_gpio1_o,
    input logic    spim1csn0_gpio1_i,
    output logic   spim1csn0_gpio1_oe,
    //PIN4
    output logic   spim1sdi0_vsync_o,
    input logic    spim1sdi0_vsync_i,
    output logic   spim1sdi0_vsync_oe,
    //PIN5
    output logic   pwm0_href_o,
    input logic    pwm0_href_i,
    output logic   pwm0_href_oe,
    //PIN6
    output logic   pwm1_camdata7_o,
    input logic    pwm1_camdata7_i,
    output logic   pwm1_camdata7_oe,
    //PIN7
    output logic   pwm2_camdata6_o,
    input logic    pwm2_camdata6_i,
    output logic   pwm2_camdata6_oe,
    //PIN8
    output logic   pwm3_camdata5_o,
    input logic    pwm3_camdata5_i,
    output logic   pwm3_camdata5_oe,
    //PIN9
    output logic   gpio2_camdata4_o,
    input logic    gpio2_camdata4_i,
    output logic   gpio2_camdata4_oe,
    //PIN10
    output logic   gpio3_camdata3_o,
    input logic    gpio3_camdata3_i,
    output logic   gpio3_camdata3_oe,
    //PIN11
    output logic   gpio4_camdata2_o,
    input logic    gpio4_camdata2_i,
    output logic   gpio4_camdata2_oe,
    //PIN12
    output logic   gpio5_camdata1_o,
    input logic    gpio5_camdata1_i,
    output logic   gpio5_camdata1_oe,
    //PIN13
    output logic   gpio6_camdata0_o,
    input logic    gpio6_camdata0_i,
    output logic   gpio6_camdata0_oe,

    output logic   spi_master1_clk_o,
    input logic    cam_pclk_i
  );

  logic        clk_int;
  logic        clk2x_int;

`ifdef HAPS
  logic        clk4x_int;
`endif

  logic        fetch_enable_int;
  logic        core_busy_int;
  logic        clk_gate_core_int;
  logic [31:0] irq_to_core_int;

  logic        rstn_int;
  logic [31:0] boot_addr_int;

  logic        spi_master1_csn0_o;
  logic        spi_master1_sdo0_o;
  logic        spi_master1_sdi0_i;

  logic        scl_pad_i;
  logic        scl_pad_o;
  logic        scl_padoen_o;
  logic        sda_pad_i;
  logic        sda_pad_o;
  logic        sda_padoen_o;

  logic        uart1_tx;
  logic        uart1_rx;

//  logic        cam_pclk;
  logic        cam_vsync;
  logic        cam_href;
  logic [7:0]  cam_data;


  logic [31:0] gpio_in;
  logic [31:0] gpio_out;
  logic [31:0] gpio_dir;
    
  logic [31:0] [5:0] pad_cfg_o;

  logic [3:0]  pwm_o;


  AXI_BUS
  #(
    .AXI_ADDR_WIDTH ( `AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( `AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( `AXI_ID_SLAVE_WIDTH ),
    .AXI_USER_WIDTH ( `AXI_USER_WIDTH     )
  )
//  slaves[2:0]();
  slaves[3:0]();

  AXI_BUS
  #(
    .AXI_ADDR_WIDTH ( `AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH ( `AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH   ( `AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH ( `AXI_USER_WIDTH      )
  )
  masters[3:0]();

  DEBUG_BUS
  debug();

  //----------------------------------------------------------------------------//
  // Clock and reset generation
  //----------------------------------------------------------------------------//
  clk_rst_gen
  clk_rst_gen_i
  (
      .clk_i            ( clk              ),

`ifdef HAPS
      .clk2x_i          ( clk2x            ),
`endif

      .rstn_i           ( rst_n            ),
      .lock_i           ( lock             ),

      .testmode_i       ( testmode_i       ),
      .pll_bps_i        ( pll_bps_i        ),

      .clk_o            ( clk_int          ),
      .clk2x_o          ( clk2x_int        ),

`ifdef HAPS
      .clk4x_o          ( clk4x_int        ),
`endif

      .rstn_o           ( rstn_int         )
    );

  //----------------------------------------------------------------------------//
  // Core region
  //----------------------------------------------------------------------------//
  core_region
  #(
    .AXI_ADDR_WIDTH       ( `AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH       ( `AXI_DATA_WIDTH      ),
    .AXI_ID_MASTER_WIDTH  ( `AXI_ID_MASTER_WIDTH ),
    .AXI_ID_SLAVE_WIDTH   ( `AXI_ID_SLAVE_WIDTH  ),
    .AXI_USER_WIDTH       ( `AXI_USER_WIDTH      )
  )
  core_region_i
  (
    .clk            ( clk_int           ),
    .rst_n          ( rstn_int          ),

    .testmode_i     ( testmode_i        ),
    .fetch_enable_i ( fetch_enable_int  ),
    .irq_i          ( irq_to_core_int   ),
    .core_busy_o    ( core_busy_int     ),
    .clock_gating_i ( clk_gate_core_int ),
    .boot_addr_i    ( boot_addr_int     ),

    .core_master    ( masters[0]        ),
    .core_master_inst(masters[1]        ),
    .dbg_master     ( masters[2]        ),
    .data_slave     ( slaves[1]         ),
    .instr_slave    ( slaves[0]         ),
    .debug          ( debug             ),

    .tck_i          ( tck_i             ),
    .trstn_i        ( trstn_i           ),
    .tms_i          ( tms_i             ),
    .tdi_i          ( tdi_i             ),
    .tdo_o          ( tdo_o             )
  );

  //----------------------------------------------------------------------------//
  // Peripherals
  //----------------------------------------------------------------------------//
  peripherals
  #(
    .AXI_ADDR_WIDTH      ( `AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH      ( `AXI_DATA_WIDTH      ),
    .AXI_SLAVE_ID_WIDTH  ( `AXI_ID_SLAVE_WIDTH  ),
    .AXI_MASTER_ID_WIDTH ( `AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH      ( `AXI_USER_WIDTH      )
  )
  peripherals_i
  (

`ifdef HAPS
//    .OBS_PIN         ( OBS_PIN           ),
    .clk4x_i         ( clk4x_int         ),
`endif

    .clk_i           ( clk_int           ),
    .clk2x_i         ( clk2x_int         ),
    .rst_n           ( rstn_int          ),

    .axi_spi_master  ( masters[3]        ),
    .debug           ( debug             ),

    .spi_clk_i       ( spi_clk_i         ),
    .testmode_i      ( testmode_i        ),
    .spi_cs_i        ( spi_cs_i          ),
    .spi_mode_o      ( ),
    .spi_sdo0_o      ( spi_sdo0_o        ),
    .spi_sdo1_o      ( ),
    .spi_sdo2_o      ( ),
    .spi_sdo3_o      ( ),
    .spi_sdi0_i      ( spi_sdi0_i        ),
    .spi_sdi1_i      ( 1'b0 ),
    .spi_sdi2_i      ( 1'b0 ),
    .spi_sdi3_i      ( 1'b0 ),

    .slave           ( slaves[2]         ),
    .x2h             ( slaves[3]         ),

    .uart_tx         ( uart_tx           ),
    .uart_rx         ( uart_rx           ),
    .uart_rts        ( ),
    .uart_dtr        ( ),
    .uart_cts        ( 1'b1 ),
    .uart_dsr        ( 1'b1 ),

    .uart1_tx        ( uart1_tx          ),
    .uart1_rx        ( uart1_rx          ),
    .uart1_rts       ( ),
    .uart1_dtr       ( ),
    .uart1_cts       ( 1'b1 ),
    .uart1_dsr       ( 1'b1 ),

    .spi_master_clk  ( spi_master_clk_o  ),
    .spi_master_csn0 ( spi_master_csn0_o ),
    .spi_master_csn1 ( ),
    .spi_master_csn2 ( ),
    .spi_master_csn3 ( ),
    .spi_master_mode ( ),
    .spi_master_sdo0 ( spi_master_sdo0_o ),
    .spi_master_sdo1 ( ),
    .spi_master_sdo2 ( ),
    .spi_master_sdo3 ( ),
    .spi_master_sdi0 ( spi_master_sdi0_i ),
    .spi_master_sdi1 ( 1'b0 ),
    .spi_master_sdi2 ( 1'b0 ),
    .spi_master_sdi3 ( 1'b0 ),

    .spi_master1_clk  ( spi_master1_clk_o  ),
    .spi_master1_csn0 ( spi_master1_csn0_o ),
    .spi_master1_csn1 ( ),
    .spi_master1_csn2 ( ),
    .spi_master1_csn3 ( ),
    .spi_master1_mode ( ),
    .spi_master1_sdo0 ( spi_master1_sdo0_o ),
    .spi_master1_sdo1 ( ),
    .spi_master1_sdo2 ( ),
    .spi_master1_sdo3 ( ),
    .spi_master1_sdi0 ( spi_master1_sdi0_i ),
    .spi_master1_sdi1 ( 1'b0 ),
    .spi_master1_sdi2 ( 1'b0 ),
    .spi_master1_sdi3 ( 1'b0 ),

    .scl_pad_i       ( scl_pad_i         ),
    .scl_pad_o       ( scl_pad_o         ),
    .scl_padoen_o    ( scl_padoen_o      ),
    .sda_pad_i       ( sda_pad_i         ),
    .sda_pad_o       ( sda_pad_o         ),
    .sda_padoen_o    ( sda_padoen_o      ),

    .scl1_pad_i      ( 1'b0 ),
    .scl1_pad_o      ( ),
    .scl1_padoen_o   ( ),
    .sda1_pad_i      ( 1'b0 ),
    .sda1_pad_o      ( ),
    .sda1_padoen_o   ( ),

    .gpio_in         ( gpio_in           ),
    .gpio_out        ( gpio_out          ),
    .gpio_dir        ( gpio_dir          ),
    .gpio_padcfg     ( ),

    .core_busy_i     ( core_busy_int     ),
    .irq_o           ( irq_to_core_int   ),
    .fetch_enable_i  ( fetch_enable_i    ),
    .fetch_enable_o  ( fetch_enable_int  ),
    .clk_gate_core_o ( clk_gate_core_int ),

    .pad_cfg_o       ( pad_cfg_o         ),
    .pad_mux_o       ( ),
    .boot_addr_o     ( boot_addr_int     ),

    .pwm_o           ( pwm_o             ),

//**********AHB subsystem IOs**********//
   //camera
    .cam_pclk                (  cam_pclk_i                ),
    .cam_vsync               (  cam_vsync                 ),
    .cam_href                (  cam_href                  ),
    .cam_data                (  cam_data                  ),
	
	//memctl
    .memctl_s_scl             ( ),
    .memctl_s_sa              ( ),
    .memctl_s_sda_out         ( ),
    .memctl_s_sda_oe_n        ( ),
    .memctl_s_sda_in          (  1'b0 ),
    .memctl_s_ck_p            (  memctl_s_ck_p             ),
    .memctl_s_ck_n            (  memctl_s_ck_n             ),
    .memctl_s_sel_n           (  memctl_s_sel_n            ),
    .memctl_s_cke             (  memctl_s_cke              ),
    .memctl_s_ras_n	          (  memctl_s_ras_n            ),
    .memctl_s_cas_n	          (  memctl_s_cas_n            ),
    .memctl_s_we_n		      (  memctl_s_we_n             ),
    .memctl_s_addr		      (  memctl_s_addr             ),
    .memctl_s_bank_addr	      (  memctl_s_bank_addr        ),
    .memctl_s_dqm		      (  memctl_s_dqm              ),
	//.s_dqs(),
	//.s_dq(),
    .memctl_s_dout_oe         (  memctl_s_dout_oe          ),
    .memctl_s_dqs_wr          (  memctl_s_dqs_wr           ),
    .memctl_s_dqs_rd          (  memctl_s_dqs_rd           ),
    .memctl_s_dq_wr           (  memctl_s_dq_wr            ),
    .memctl_s_dq_rd           (  memctl_s_dq_rd            ),
    .memctl_s_rd_dqs_mask     (  memctl_s_rd_dqs_mask      ),
    .memctl_int_rd_dqs_mask   (  memctl_int_rd_dqs_mask    ),
	
	//eMMC
    .emmc_cclk_out            (  emmc_cclk_out             ),
    .emmc_ccmd_in             (  emmc_ccmd_in              ),
    .emmc_ccmd_out            (  emmc_ccmd_out             ),
    .emmc_ccmd_out_en         (  emmc_ccmd_out_en          ),
    .emmc_cdata_in	          (  emmc_cdata_in             ),
    .emmc_cdata_out		      (  emmc_cdata_out            ),
    .emmc_cdata_out_en        (  emmc_cdata_out_en         ),
    .emmc_card_detect_n       (  emmc_card_detect_n        ),
    .emmc_card_write_prt      (  emmc_card_write_prt       ),
    .emmc_card_power_en	      (  emmc_card_power_en        ),
    .emmc_card_volt_a	      (  emmc_card_volt_a          ),
    .emmc_card_volt_b	      (  emmc_card_volt_b          ),
    .emmc_ccmd_od_pullup_en_n (  emmc_ccmd_od_pullup_en_n  ),
                    
    .sd_biu_volt_reg          (  sd_biu_volt_reg           ),

    .sdio_card_int_n          (  sdio_card_int_n           ),
    .sdio_back_end_power      (  sdio_back_end_power       ),

    .mmc_4_4_rst_n            (  mmc_4_4_rst_n             ),
    .emmc_biu_volt_reg_1_2    (  emmc_biu_volt_reg_1_2     )
  );


  //----------------------------------------------------------------------------//
  // Axi node
  //----------------------------------------------------------------------------//

  axi_node_intf_wrap
  #(
    .NB_MASTER      ( 4                    ),
    .NB_SLAVE       ( 4                    ),
    .AXI_ADDR_WIDTH ( `AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH ( `AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH   ( `AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH ( `AXI_USER_WIDTH      )
  )
  axi_interconnect_i
  (
    .clk       ( clk_int    ),
    .rst_n     ( rstn_int   ),
    .test_en_i ( testmode_i ),

    .master    ( slaves     ),
    .slave     ( masters    ),

    .start_addr_i ( {32'h2001_0000, 32'h1A10_0000, 32'h2000_0000, 32'h0000_0000 } ), //AHB, APB, D-RAM, I-RAM
    .end_addr_i   ( {32'h2800_FFFF, 32'h1A11_FFFF, 32'h2000_FFFF, 32'h000F_FFFF } )
//  .start_addr_i ( {32'h2001_0000, 32'h1A10_0000, 32'h0010_0000, 32'h0000_0000 } ),
//  .end_addr_i   ( {32'h2800_FFFF, 32'h1A11_FFFF, 32'h001F_FFFF, 32'h000F_FFFF } )
//  .start_addr_i ( { 32'h1A10_0000, 32'h0010_0000, 32'h0000_0000 } ),
//  .end_addr_i   ( { 32'h1A11_FFFF, 32'h001F_FFFF, 32'h000F_FFFF } ) // 128KB : 1MB : 1MB
  );

  //----------------------------------------------------------------------------//
  //  Pin mux logic
  //----------------------------------------------------------------------------//
//PIN0
  iomux
  io_mux_scl_uart1tx
  (
      .chip_in0   (  scl_pad_o        ),
      .chip_in1   (  uart1_tx         ),

      .chip_out0  (  scl_pad_i        ),
      .chip_out1  ( ),

      .chip_dir0  (  ~scl_padoen_o    ),
      .chip_dir1  (  `DIR_OUTPUT      ),

      .io_cfg     (  pad_cfg_o[0][0]  ),

      .io_out     (  scl_uart1tx_o    ),
      .io_in      (  scl_uart1tx_i    ),
      .io_dir     (  scl_uart1tx_oe   ) 
);
//PIN1
  iomux
  io_mux_sda_uart1rx
  (
      .chip_in0   (  sda_pad_o        ),
      .chip_in1   (  1'b0 ),

      .chip_out0  (  sda_pad_i        ),
      .chip_out1  (  uart1_rx         ),

      .chip_dir0  (  ~sda_padoen_o    ),
      .chip_dir1  (  `DIR_INPUT       ),

      .io_cfg     (  pad_cfg_o[1][0]  ),

      .io_out     (  sda_uart1rx_o    ),
      .io_in      (  sda_uart1rx_i    ),
      .io_dir     (  sda_uart1rx_oe   ) 
);
//PIN2
  iomux
  io_mux_spim1sdo0_gpio0
  (
      .chip_in0   (  spi_master1_sdo0_o   ),
      .chip_in1   (  gpio_out[0]         ),

      .chip_out0  (         ),
      .chip_out1  (  gpio_in[0]          ),

      .chip_dir0  (  `DIR_OUTPUT         ),
      .chip_dir1  (  gpio_dir[0]         ),

      .io_cfg     (  pad_cfg_o[2][0]     ),

      .io_out     (  spim1sdo0_gpio0_o    ),
      .io_in      (  spim1sdo0_gpio0_i    ),
      .io_dir     (  spim1sdo0_gpio0_oe   ) 
);
//PIN3
  iomux
  io_mux_spim1csn0_gpio1
  (
      .chip_in0   (  spi_master1_csn0_o ),
      .chip_in1   (  gpio_out[1]        ),

      .chip_out0  ( ),
      .chip_out1  (  gpio_in[1]         ),

      .chip_dir0  (  `DIR_OUTPUT        ),
      .chip_dir1  (  gpio_dir[1]        ),

      .io_cfg     (  pad_cfg_o[3][0]    ),

      .io_out     (  spim1csn0_gpio1_o  ),
      .io_in      (  spim1csn0_gpio1_i  ),
      .io_dir     (  spim1csn0_gpio1_oe ) 
);
//PIN4
  iomux
  io_mux_spim1sdi0_vsync
  (
      .chip_in0   (  1'b0 ),
      .chip_in1   (  1'b0 ),

      .chip_out0  ( spi_master1_sdi0_i   ),
      .chip_out1  ( cam_vsync            ),

      .chip_dir0  ( `DIR_INPUT           ),
      .chip_dir1  ( `DIR_INPUT           ),

      .io_cfg     (  pad_cfg_o[4][0]     ),

      .io_out     (  spim1sdi0_vsync_o   ),
      .io_in      (  spim1sdi0_vsync_i   ),
      .io_dir     (  spim1sdi0_vsync_oe  ) 
);
//PIN5
  iomux
  io_mux_pwm0_href
  (
      .chip_in0   (  pwm_o[0]         ),
      .chip_in1   (  1'b0 ),

      .chip_out0  ( ),
      .chip_out1  (  cam_href         ),

      .chip_dir0  (  `DIR_OUTPUT      ),
      .chip_dir1  (  `DIR_INPUT       ),

      .io_cfg     (  pad_cfg_o[5][0]  ),

      .io_out     (  pwm0_href_o      ),
      .io_in      (  pwm0_href_i      ),
      .io_dir     (  pwm0_href_oe     ) 
);
//PIN6
  iomux
  io_mux_pwm1_camdata7
  (
      .chip_in0   (  pwm_o[1]          ),
      .chip_in1   (  1'b0 ),

      .chip_out0  ( ),
      .chip_out1  (  cam_data[7]       ),

      .chip_dir0  (  `DIR_OUTPUT       ),
      .chip_dir1  (  `DIR_INPUT        ),

      .io_cfg     (  pad_cfg_o[6][0]   ),

      .io_out     (  pwm1_camdata7_o   ),
      .io_in      (  pwm1_camdata7_i   ),
      .io_dir     (  pwm1_camdata7_oe  ) 
);
//PIN7
  iomux
  io_mux_pwm2_camdata6
  (
      .chip_in0   (  pwm_o[2]          ),
      .chip_in1   (  1'b0 ),

      .chip_out0  ( ),
      .chip_out1  (  cam_data[6]       ),

      .chip_dir0  (  `DIR_OUTPUT       ),
      .chip_dir1  (  `DIR_INPUT        ),

      .io_cfg     (  pad_cfg_o[7][0]   ),

      .io_out     (  pwm2_camdata6_o   ),
      .io_in      (  pwm2_camdata6_i   ),
      .io_dir     (  pwm2_camdata6_oe  ) 
);
//PIN8
  iomux
  io_mux_pwm3_camdata5
  (
      .chip_in0   (  pwm_o[3]           ),
      .chip_in1   (  1'b0 ),

      .chip_out0  ( ),
      .chip_out1  (  cam_data[5]        ),

      .chip_dir0  (  `DIR_OUTPUT        ),
      .chip_dir1  (  `DIR_INPUT         ),

      .io_cfg     (  pad_cfg_o[8][0]    ),

      .io_out     (  pwm3_camdata5_o   ),
      .io_in      (  pwm3_camdata5_i   ),
      .io_dir     (  pwm3_camdata5_oe  ) 
);
//PIN9
  iomux
  io_mux_gpio2_camdata4
  (
      .chip_in0   (  gpio_out[2]       ),
      .chip_in1   (  1'b0 ),

      .chip_out0  (  gpio_in[2]        ),
      .chip_out1  (  cam_data[4]       ),

      .chip_dir0  (  gpio_dir[2]       ),
      .chip_dir1  (  `DIR_INPUT        ),

      .io_cfg     (  pad_cfg_o[9][0]  ),

      .io_out     (  gpio2_camdata4_o  ),
      .io_in      (  gpio2_camdata4_i  ),
      .io_dir     (  gpio2_camdata4_oe ) 
);
//PIN10
  iomux
  io_mux_gpio3_camdata3
  (
      .chip_in0   (  gpio_out[3]       ),
      .chip_in1   (  1'b0 ),

      .chip_out0  (  gpio_in[3]        ),
      .chip_out1  (  cam_data[3]       ),

      .chip_dir0  (  gpio_dir[3]       ),
      .chip_dir1  (  `DIR_INPUT        ),

      .io_cfg     (  pad_cfg_o[10][0]  ),

      .io_out     (  gpio3_camdata3_o  ),
      .io_in      (  gpio3_camdata3_i  ),
      .io_dir     (  gpio3_camdata3_oe ) 
); 
//PIN11
  iomux
  io_mux_gpio4_camdata2
  (
      .chip_in0   (  gpio_out[4]       ),
      .chip_in1   (  1'b0 ),

      .chip_out0  (  gpio_in[4]        ),
      .chip_out1  (  cam_data[2]       ),

      .chip_dir0  (  gpio_dir[4]       ),
      .chip_dir1  (  `DIR_INPUT        ),

      .io_cfg     (  pad_cfg_o[11][0]  ),

      .io_out     (  gpio4_camdata2_o  ),
      .io_in      (  gpio4_camdata2_i  ),
      .io_dir     (  gpio4_camdata2_oe ) 
);
//PIN12
  iomux
  io_mux_gpio5_camdata1
  (
      .chip_in0   (  gpio_out[5]       ),
      .chip_in1   (  1'b0 ),

      .chip_out0  (  gpio_in[5]        ),
      .chip_out1  (  cam_data[1]       ),

      .chip_dir0  (  gpio_dir[5]       ),
      .chip_dir1  (  `DIR_INPUT        ),

      .io_cfg     (  pad_cfg_o[12][0]  ),

      .io_out     (  gpio5_camdata1_o  ),
      .io_in      (  gpio5_camdata1_i  ),
      .io_dir     (  gpio5_camdata1_oe ) 
); 
//PIN13
  iomux
  io_mux_gpio6_camdata0
  (
      .chip_in0   (  gpio_out[6]       ),
      .chip_in1   (  1'b0 ),

      .chip_out0  (  gpio_in[6]        ),
      .chip_out1  (  cam_data[0]       ),

      .chip_dir0  (  gpio_dir[6]       ),
      .chip_dir1  (  `DIR_INPUT        ),

      .io_cfg     (  pad_cfg_o[13][0]  ),

      .io_out     (  gpio6_camdata0_o  ),
      .io_in      (  gpio6_camdata0_i  ),
      .io_dir     (  gpio6_camdata0_oe ) 
); 

endmodule

