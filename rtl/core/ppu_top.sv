
`include "axi_bus.sv"
`include "debug_bus.sv"
`include "config.sv"

`define AXI_ADDR_WIDTH         32
`define AXI_DATA_WIDTH         32
`define AXI_ID_MASTER_WIDTH     4 
`define AXI_ID_SLAVE_WIDTH     16 
`define AXI_USER_WIDTH          1
//`define DEBUG
module ppu_top
  (
    input  logic              sys_clk_p,
    input  logic              sys_clk_n,
    input  logic              sys_rst_n,

    output logic              ui_clk_o,
    output logic              ui_rstn_o,
    output logic              ui_clk_locked_o,

    input  logic              testmode_i,
    input  logic              fetch_enable_i,

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

    output logic              uart_tx,
    input  logic              uart_rx,

    output logic              uart1_tx,
    input  logic              uart1_rx,

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

    //SPI Master 1
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
    
    //I2C
    input logic               scl_pad_i,
    output logic              scl_pad_o,
    output logic              scl_padoen_o,
    input logic               sda_pad_i,
    output logic              sda_pad_o,
    output logic              sda_padoen_o,

    //I2C1
    input logic               scl1_pad_i,
    output logic              scl1_pad_o,
    output logic              scl1_padoen_o,
    input logic               sda1_pad_i,
    output logic              sda1_pad_o,
    output logic              sda1_padoen_o,

    //GPIO
    input  logic   [31:0]     gpio_in,
    output logic   [31:0]     gpio_out,
    output logic   [31:0]     gpio_dir,

    output logic   [3:0]      pwm_o,

    // JTAG signals
    input  logic              tck_i,
    input  logic              trstn_i,
    input  logic              tms_i,
    input  logic              tdi_i,
    output logic              tdo_o,

//**********AHB subsystem IOs**********//
//camera
    input logic              cam_pclk,
    input logic              cam_vsync,
    input logic              cam_href,
    input logic  [ 7: 0]     cam_data,
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
    output logic              clk_int,
    output logic              rstn_int
  );

 // logic        clk_int;
  logic        clk2x_int;

  logic        ui_clk;
  logic        ui_rst;
  logic        mmcm_locked;

  logic        fetch_enable_int;
  logic        core_busy_int;
  logic        clk_gate_core_int;
  logic [31:0] irq_to_core_int;

 // logic        rstn_int;
  logic [31:0] boot_addr_int;

  AXI_BUS
  #(
    .AXI_ADDR_WIDTH ( `AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( `AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( `AXI_ID_SLAVE_WIDTH ),
    .AXI_USER_WIDTH ( `AXI_USER_WIDTH     )
  )
  slaves[4:0]();

  AXI_BUS
  #(
    .AXI_ADDR_WIDTH ( `AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH ( `AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH   ( `AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH ( `AXI_USER_WIDTH      )
  )
  masters[4:0]();

  DEBUG_BUS
  debug();

  //----------------------------------------------------------------//
  // Clock and reset generation
  //----------------------------------------------------------------------------//
  clk_rst_gen
  clk_rst_gen_i
  (
      .clk_i            ( ui_clk           ),

      .rstn_i           ( ~ui_rst          ),
      .lock_i           ( mmcm_locked      ),

      .testmode_i       ( testmode_i       ),

      .clk_o              ( clk_int          ),
      .clk2x_o          ( clk2x_int        ),

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
    .spi_sdo1_o      ( spi_sdo1_o        ),
    .spi_sdo2_o      ( spi_sdo2_o        ),
    .spi_sdo3_o      ( spi_sdo3_o        ),
    .spi_sdi0_i      ( spi_sdi0_i        ),
    .spi_sdi1_i      ( spi_sdi1_i        ),
    .spi_sdi2_i      ( spi_sdi2_i        ),
    .spi_sdi3_i      ( spi_sdi3_i        ),

    .slave           ( slaves[2]         ),
    .x2h             ( slaves[3]         ),
    .h2x             ( masters[4]        ),

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
    .spi_master_csn1 ( spi_master_csn1_o ),
    .spi_master_csn2 ( spi_master_csn2_o ),
    .spi_master_csn3 ( spi_master_csn3_o ),
    .spi_master_mode ( ),
    .spi_master_sdo0 ( spi_master_sdo0_o ),
    .spi_master_sdo1 ( spi_master_sdo1_o ),
    .spi_master_sdo2 ( spi_master_sdo2_o ),
    .spi_master_sdo3 ( spi_master_sdo3_o ),
    .spi_master_sdi0 ( spi_master_sdi0_i ),
    .spi_master_sdi1 ( spi_master_sdi1_i ),
    .spi_master_sdi2 ( spi_master_sdi2_i ),
    .spi_master_sdi3 ( spi_master_sdi3_i ),

    .spi_master1_clk  ( spi_master1_clk_o  ),
    .spi_master1_csn0 ( spi_master1_csn0_o ),
    .spi_master1_csn1 ( spi_master1_csn1_o),
    .spi_master1_csn2 ( spi_master1_csn2_o),
    .spi_master1_csn3 ( spi_master1_csn3_o),
    .spi_master1_mode ( ),
    .spi_master1_sdo0 ( spi_master1_sdo0_o ),
    .spi_master1_sdo1 ( spi_master1_sdo1_o),
    .spi_master1_sdo2 ( spi_master1_sdo2_o),
    .spi_master1_sdo3 ( spi_master1_sdo3_o),
    .spi_master1_sdi0 ( spi_master1_sdi0_i ),
    .spi_master1_sdi1 ( spi_master1_sdi1_i ),
    .spi_master1_sdi2 ( spi_master1_sdi2_i ),
    .spi_master1_sdi3 ( spi_master1_sdi3_i ),

    .scl_pad_i       ( scl_pad_i         ),
    .scl_pad_o       ( scl_pad_o         ),
    .scl_padoen_o    ( scl_padoen_o      ),
    .sda_pad_i       ( sda_pad_i         ),
    .sda_pad_o       ( sda_pad_o         ),
    .sda_padoen_o    ( sda_padoen_o      ),

    .scl1_pad_i       ( scl1_pad_i         ),
    .scl1_pad_o       ( scl1_pad_o         ),
    .scl1_padoen_o    ( scl1_padoen_o      ),
    .sda1_pad_i       ( sda1_pad_i         ),
    .sda1_pad_o       ( sda1_pad_o         ),
    .sda1_padoen_o    ( sda1_padoen_o      ),

    .gpio_in         ( gpio_in           ),
    .gpio_out        ( gpio_out          ),
    .gpio_dir        ( gpio_dir          ),
    .gpio_padcfg     ( ),

    .core_busy_i     ( core_busy_int     ),
    .irq_o           ( irq_to_core_int   ),
    .fetch_enable_i  ( fetch_enable_i    ),
    .fetch_enable_o  ( fetch_enable_int  ),
    .clk_gate_core_o ( clk_gate_core_int ),

    .pad_cfg_o       ( ),
    .pad_mux_o       ( ),
    .boot_addr_o     ( boot_addr_int     ),

    .pwm_o           ( pwm_o             ),

//**********AHB subsystem IOs**********//
   //camera
    .cam_pclk                (  cam_pclk                ),
    .cam_vsync               (  cam_vsync                 ),
    .cam_href                (  cam_href                  ),
    .cam_data                (  cam_data                  ),
	
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


//ddr3 sdram if
  assign ui_clk_o = ui_clk;
  assign ui_rstn_o = ~ui_rst;
  assign ui_clk_locked_o = mmcm_locked;

  xilin_ddr3_if_wrap
  #(
    .AXI_ADDR_WIDTH      ( `AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH      ( `AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH        ( `AXI_ID_SLAVE_WIDTH  )
  )
  ddr3_if_inst
    (
    //input clock/reset from board
    .sys_clk_p                      (sys_clk_p              ),
    .sys_clk_n                      (sys_clk_n              ),
    .sys_rst_n                      (sys_rst_n              ),
    .clk_int(clk_int),
    .rstn_i(rstn_int), 
    //input reset_n to interface logic
    .rstn                           (rstn_int               ),
    //output clock/reset to other parts of SoC
    .ui_clk                         (ui_clk                 ),
    .ui_rst                         (ui_rst                 ),
    .mmcm_locked                    (mmcm_locked            ),
    // Memory interface ports
    .init_calib_complete            (init_calib_complete    ),

    .ddr3_addr                      (ddr3_addr              ),
    .ddr3_ba                        (ddr3_ba                ),
    .ddr3_cas_n                     (ddr3_cas_n             ),
    .ddr3_ck_n                      (ddr3_ck_n              ),
    .ddr3_ck_p                      (ddr3_ck_p              ),
    .ddr3_cke                       (ddr3_cke               ),
    .ddr3_ras_n                     (ddr3_ras_n             ),
    .ddr3_reset_n                   (ddr3_reset_n           ),
    .ddr3_we_n                      (ddr3_we_n              ),
    .ddr3_dq                        (ddr3_dq                ),
    .ddr3_dqs_n                     (ddr3_dqs_n             ),
    .ddr3_dqs_p                     (ddr3_dqs_p             ),
    .ddr3_cs_n                      (ddr3_cs_n              ),
    .ddr3_dm                        (ddr3_dm                ),
    .ddr3_odt                       (ddr3_odt               ),
    // axi slave interface
    .ddr3_axi_slave                 (slaves[4]              ) 
    );


  //----------------------------------------------------------------------------//
  // Axi node
  //----------------------------------------------------------------------------//

  axi_node_intf_wrap
  #(
    .NB_MASTER      ( 5                    ),
    .NB_SLAVE       ( 5                    ),
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

    .start_addr_i ( {32'h3001_0000, 32'h2800_1000, 32'h1A10_0000, 32'h3000_0000, 32'h0000_0000 } ), //DDR3, AHB, APB, D-RAM, I-RAM
    .end_addr_i   ( {32'h6FFF_FFFF, 32'h2800_FFFF, 32'h1A11_FFFF, 32'h3000_FFFF, 32'h000F_FFFF } )
//  .start_addr_i ( {32'h2001_0000, 32'h1A10_0000, 32'h0010_0000, 32'h0000_0000 } ),
//  .end_addr_i   ( {32'h2800_FFFF, 32'h1A11_FFFF, 32'h001F_FFFF, 32'h000F_FFFF } )
//  .start_addr_i ( { 32'h1A10_0000, 32'h0010_0000, 32'h0000_0000 } ),
//  .end_addr_i   ( { 32'h1A11_FFFF, 32'h001F_FFFF, 32'h000F_FFFF } ) // 128KB : 1MB : 1MB
  );
//`ifdef DEBUG
//xilinx_ila_debug xilinx_ila_debug_inst (
//        .clk(clk2x_int), // input wire clk
//        .probe0(clk_int), // input wire [0:0]  probe0
//        .probe1(rstn_int ), // input wire [31:0]  probe1
//        .probe2(init_calib_complete), // input wire [0:0]  probe2
//        .probe3(mmcm_locked), // input wire [31:0]  probe3
//        .probe4(uart_tx), // input wire [0:0]  probe4
//        .probe5(uart_rx)
//);
//
//`endif
endmodule

