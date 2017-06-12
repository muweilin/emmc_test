// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "axi_bus.sv"
`include "apb_bus.sv"
`include "debug_bus.sv"
`include "config.sv"

module peripherals
  #(
    parameter AXI_ADDR_WIDTH       = 32,
    parameter AXI_DATA_WIDTH       = 64,
    parameter AXI_USER_WIDTH       = 6,
    parameter AXI_SLAVE_ID_WIDTH   = 6,
    parameter AXI_MASTER_ID_WIDTH  = 6,
    parameter ROM_START_ADDR       = 32'h10000
  )
  (

`ifdef HAPS
//    output logic [47: 0]   OBS_PIN,
    input  logic           clk4x_i,
`endif

    // Clock and Reset
    input logic clk_i,
    input logic clk2x_i,
    input logic rst_n,

    AXI_BUS.Master axi_spi_master,

    DEBUG_BUS.Master debug,

    input  logic             spi_clk_i,
    input  logic             testmode_i,
    input  logic             spi_cs_i,
    output logic [1:0]       spi_mode_o,
    output logic             spi_sdo0_o,
    output logic             spi_sdo1_o,
    output logic             spi_sdo2_o,
    output logic             spi_sdo3_o,
    input  logic             spi_sdi0_i,
    input  logic             spi_sdi1_i,
    input  logic             spi_sdi2_i,
    input  logic             spi_sdi3_i,

    AXI_BUS.Slave  slave,
    AXI_BUS.Slave  x2h,

    output logic              uart_tx,
    input  logic              uart_rx,
    output logic              uart_rts,
    output logic              uart_dtr,
    input  logic              uart_cts,
    input  logic              uart_dsr,

    output logic              uart1_tx,
    input  logic              uart1_rx,
    output logic              uart1_rts,
    output logic              uart1_dtr,
    input  logic              uart1_cts,
    input  logic              uart1_dsr,

    output logic              spi_master_clk,
    output logic              spi_master_csn0,
    output logic              spi_master_csn1,
    output logic              spi_master_csn2,
    output logic              spi_master_csn3,
    output logic       [1:0]  spi_master_mode,
    output logic              spi_master_sdo0,
    output logic              spi_master_sdo1,
    output logic              spi_master_sdo2,
    output logic              spi_master_sdo3,
    input  logic              spi_master_sdi0,
    input  logic              spi_master_sdi1,
    input  logic              spi_master_sdi2,
    input  logic              spi_master_sdi3,

    output logic              spi_master1_clk,
    output logic              spi_master1_csn0,
    output logic              spi_master1_csn1,
    output logic              spi_master1_csn2,
    output logic              spi_master1_csn3,
    output logic       [1:0]  spi_master1_mode,
    output logic              spi_master1_sdo0,
    output logic              spi_master1_sdo1,
    output logic              spi_master1_sdo2,
    output logic              spi_master1_sdo3,
    input  logic              spi_master1_sdi0,
    input  logic              spi_master1_sdi1,
    input  logic              spi_master1_sdi2,
    input  logic              spi_master1_sdi3,

    input  logic              scl_pad_i,
    output logic              scl_pad_o,
    output logic              scl_padoen_o,
    input  logic              sda_pad_i,
    output logic              sda_pad_o,
    output logic              sda_padoen_o,

    input  logic              scl1_pad_i,
    output logic              scl1_pad_o,
    output logic              scl1_padoen_o,
    input  logic              sda1_pad_i,
    output logic              sda1_pad_o,
    output logic              sda1_padoen_o,

    input  logic       [31:0] gpio_in,
    output logic       [31:0] gpio_out,
    output logic       [31:0] gpio_dir,
    output logic [31:0] [5:0] gpio_padcfg,

    input  logic              core_busy_i,
    output logic [31:0]       irq_o,
    input  logic              fetch_enable_i,
    output logic              fetch_enable_o,
    output logic              clk_gate_core_o,

    output logic [31:0] [5:0] pad_cfg_o,
    output logic       [31:0] pad_mux_o,
    output logic       [31:0] boot_addr_o,

    output logic [3:0]        pwm_o,

//**********AHB subsystem IOs**********//
//camera
	input  logic              cam_pclk,
	input  logic              cam_vsync,
	input  logic              cam_href,
	input  logic [ 7: 0]      cam_data,

//memctl
	output logic              memctl_s_scl,
	output logic [ 2: 0]      memctl_s_sa,
	//inout logic              s_sda,
	output logic              memctl_s_sda_out,
	output logic              memctl_s_sda_oe_n,
	input  logic              memctl_s_sda_in,
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
	//inout logic [ 1: 0]      s_dqs,
	//inout logic [15: 0]      s_dq,
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
	output logic [ 1: 0]      emmc_biu_volt_reg_1_2

  );

  localparam APB_ADDR_WIDTH  = 32;
  localparam APB_NUM_SLAVES  = 13;
//spis(0), uart(1), gpio(2), spim(3), timer(4), event(5), 
//i2c(6), uart1(7), spim1(8), i2c1(9), cam(10), ann(11), pwm(12)

  APB_BUS s_apb_bus();

  APB_BUS s_uart_bus();
  APB_BUS s_gpio_bus();
  APB_BUS s_spi_bus();
  APB_BUS s_timer_bus();
  APB_BUS s_event_unit_bus();
  APB_BUS s_i2c_bus();
  APB_BUS s_soc_ctrl_bus();
  APB_BUS s_debug_bus();

  APB_BUS s_uart1_bus();
  APB_BUS s_spi1_bus();
  APB_BUS s_i2c1_bus();
  APB_BUS s_pwm_bus();

  logic [1:0]   s_spim_event;
  logic [3:0]   timer_irq;
  logic [31:0]  peripheral_clock_gate_ctrl;
  logic [31:0]  clk_int;
  logic         s_uart_event;
  logic         i2c_event;
  logic         s_power_event;
  logic         s_gpio_event;

  logic         s_uart1_event;
  logic [1:0]   s_spim1_event;
  logic         i2c1_event;

  logic         ahb_int;
  logic         cam_int;
  logic         ann_int;
  logic         emmc_int;

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// Peripheral Clock Gating                                    ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  generate
     genvar i;
       for (i = 0; i < APB_NUM_SLAVES; i = i + 1) begin
        cluster_clock_gating core_clock_gate
        (
          .clk_o     ( clk_int[i]                    ),
          .en_i      ( peripheral_clock_gate_ctrl[i] ),
          .test_en_i ( testmode_i                    ),
          .clk_i     ( clk_i                         )
        );
      end
   endgenerate

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// AXI2AHB Subsystem                                          ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////
  AHB_SUBSYSTEM 
  ahb_subsystem_i 
   (

`ifdef HAPS
//    .OBS_PIN             (  OBS_PIN                   ),
    .hclk_4x             (  clk4x_i                   ),
`endif

   //camera
    .pclk                (  cam_pclk                  ),
    .vsync               (  cam_vsync                 ),
    .href                (  cam_href                  ),
    .data                (  cam_data                  ),
	
	//memctl
    .s_scl               (  memctl_s_scl              ),
    .s_sa                (  memctl_s_sa               ),
	//.s_sda(),
    .s_sda_out           (  memctl_s_sda_out          ),
    .s_sda_oe_n          (  memctl_s_sda_oe_n         ),
    .s_sda_in            (  memctl_s_sda_in           ),
    .s_ck_p              (  memctl_s_ck_p             ),
    .s_ck_n              (  memctl_s_ck_n             ),
    .s_sel_n	         (  memctl_s_sel_n            ),
    .s_cke		         (  memctl_s_cke              ),
    .s_ras_n	         (  memctl_s_ras_n            ),
    .s_cas_n	         (  memctl_s_cas_n            ),
    .s_we_n		         (  memctl_s_we_n             ),
    .s_addr		         (  memctl_s_addr             ),
    .s_bank_addr	     (  memctl_s_bank_addr        ),
    .s_dqm		         (  memctl_s_dqm              ),
	//.s_dqs(),
	//.s_dq(),
    .s_dout_oe           (  memctl_s_dout_oe          ),
    .s_dqs_wr            (  memctl_s_dqs_wr           ),
    .s_dqs_rd            (  memctl_s_dqs_rd           ),
    .s_dq_wr             (  memctl_s_dq_wr            ),
    .s_dq_rd             (  memctl_s_dq_rd            ),
    .s_rd_dqs_mask       (  memctl_s_rd_dqs_mask      ),
    .int_rd_dqs_mask     (  memctl_int_rd_dqs_mask    ),
	
	//eMMC
    .cclk_out            (  emmc_cclk_out             ),
    .ccmd_in             (  emmc_ccmd_in              ),
    .ccmd_out            (  emmc_ccmd_out             ),
    .ccmd_out_en         (  emmc_ccmd_out_en          ),
    .cdata_in	         (  emmc_cdata_in             ),
    .cdata_out		     (  emmc_cdata_out            ),
    .cdata_out_en        (  emmc_cdata_out_en         ),
    .card_detect_n       (  emmc_card_detect_n        ),
    .card_write_prt      (  emmc_card_write_prt       ),
    .card_power_en	     (  emmc_card_power_en        ),
    .card_volt_a	     (  emmc_card_volt_a          ),
    .card_volt_b	     (  emmc_card_volt_b          ),
    .ccmd_od_pullup_en_n (  emmc_ccmd_od_pullup_en_n  ),
                    
    .biu_volt_reg        (  sd_biu_volt_reg           ),
    .card_int_n          (  sdio_card_int_n           ),

    .back_end_power      (  sdio_back_end_power       ),

    .mmc_4_4_rst_n       (  mmc_4_4_rst_n             ),
    .biu_volt_reg_1_2    (  emmc_biu_volt_reg_1_2     ),

	//global
	.hclk                (  clk_i                     ),
	.hclk_2x             (  clk2x_i                   ),
	.hclk_cam            (  clk_int[10]               ),
	.hclk_ann            (  clk_int[11]               ),
	.hresetn             (  rst_n                     ),
	
	//AXI: Write Command Channel
	.awid	             (  x2h.aw_id                 ),
	.awaddr	             (  x2h.aw_addr               ),
	.awlen	             (  x2h.aw_len                ),
	.awsize	             (  x2h.aw_size               ),
	.awburst	         (  x2h.aw_burst              ),
	.awlock	             (  x2h.aw_lock               ),
    .awcache             (  x2h.aw_cache              ),
    .awprot              (  x2h.aw_prot               ),
    .awvalid             (  x2h.aw_valid              ),
    .awready             (  x2h.aw_ready              ),
	
	//AXI: Write Data Channel
    .wdata               (  x2h.w_data                ),
    .wstrb               (  x2h.w_strb                ),
    .wlast               (  x2h.w_last                ),
    .wvalid              (  x2h.w_valid               ),
    .wready              (  x2h.w_ready               ),
	
	//AXI: Write Response Channel
    .bid                 (  x2h.b_id                  ),
    .bresp               (  x2h.b_resp                ),
    .bvalid              (  x2h.b_valid               ),
    .bready              (  x2h.b_ready               ),
	
	//AXI: Read Command Channel
    .arid                (  x2h.ar_id                 ),
    .araddr              (  x2h.ar_addr               ),
    .arlen               (  x2h.ar_len                ),
    .arsize              (  x2h.ar_size               ),
    .arburst             (  x2h.ar_burst              ),
    .arlock              (  x2h.ar_lock               ),
    .arcache	         (  x2h.ar_cache              ),
    .arprot              (  x2h.ar_prot               ),
    .arvalid	         (  x2h.ar_valid              ),
    .arready             (  x2h.ar_ready              ),
	
	//AXI: Read Response Channel
    .rid                 (  x2h.r_id                  ),
    .rdata               (  x2h.r_data                ),
    .rresp               (  x2h.r_resp                ),
    .rlast               (  x2h.r_last                ),
    .rvalid              (  x2h.r_valid               ),
    .rready              (  x2h.r_ready               ),
	
	//interrupt
    .ahb_intr            (  ahb_int                   ),
    .Camera_intr         (  cam_int                   ),
    .ann_intr            (  ann_int                   ),
    .emmc_intr           (  emmc_int                  )
   );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// SPI Slave, AXI Master                                      ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  axi_spi_slave_wrap
  #(
    .AXI_ADDRESS_WIDTH  ( AXI_ADDR_WIDTH       ),
    .AXI_DATA_WIDTH     ( AXI_DATA_WIDTH       ),
    .AXI_USER_WIDTH     ( AXI_USER_WIDTH       ),
    .AXI_ID_WIDTH       ( AXI_MASTER_ID_WIDTH  )
  )
  axi_spi_slave_i
  (
    .clk_i      ( clk_int[0]     ),
    .rst_ni     ( rst_n          ),

    .test_mode  ( testmode_i     ),

    .axi_master ( axi_spi_master ),

    .spi_clk    ( spi_clk_i      ),
    .spi_cs     ( spi_cs_i       ),
    .spi_mode   ( spi_mode_o     ),
    .spi_sdo0   ( spi_sdo0_o     ),
    .spi_sdo1   ( spi_sdo1_o     ),
    .spi_sdo2   ( spi_sdo2_o     ),
    .spi_sdo3   ( spi_sdo3_o     ),
    .spi_sdi0   ( spi_sdi0_i     ),
    .spi_sdi1   ( spi_sdi1_i     ),
    .spi_sdi2   ( spi_sdi2_i     ),
    .spi_sdi3   ( spi_sdi3_i     )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// AXI2APB Bridge                                             ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  axi2apb_wrap
  #(
      .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
      .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
      .AXI_USER_WIDTH ( AXI_USER_WIDTH     ),
      .AXI_ID_WIDTH   ( AXI_SLAVE_ID_WIDTH ),
      .APB_ADDR_WIDTH ( APB_ADDR_WIDTH     )
  )
  axi2apb_i
  (
    .clk_i     ( clk_i      ),
    .rst_ni    ( rst_n      ),
    .test_en_i ( testmode_i ),

    .axi_slave ( slave      ),

    .apb_master( s_apb_bus  )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Bus                                                    ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  periph_bus_wrap
  #(
     .APB_ADDR_WIDTH( APB_ADDR_WIDTH ),
     .APB_DATA_WIDTH( 32             )
  )
  periph_bus_i
  (
     .clk_i             ( clk_i            ),
     .rst_ni            ( rst_n            ),

     .apb_slave         ( s_apb_bus        ),

     .uart_master       ( s_uart_bus       ),
     .gpio_master       ( s_gpio_bus       ),
     .spi_master        ( s_spi_bus        ),
     .timer_master      ( s_timer_bus      ),
     .event_unit_master ( s_event_unit_bus ),
     .i2c_master        ( s_i2c_bus        ),
     .soc_ctrl_master   ( s_soc_ctrl_bus   ),
     .debug_master      ( s_debug_bus      ),

     .uart1_master       ( s_uart1_bus     ),
     .spi1_master        ( s_spi1_bus      ),
     .i2c1_master        ( s_i2c1_bus      ),
     .pwm_master         ( s_pwm_bus       )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 0: APB UART interface                            ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb_uart i_apb_uart
  (
    .CLK      ( clk_int[1]   ),
    .RSTN     ( rst_n        ),

    .PSEL     ( s_uart_bus.psel    ),
    .PENABLE  ( s_uart_bus.penable    ),
    .PWRITE   ( s_uart_bus.pwrite     ),
    .PADDR    ( s_uart_bus.paddr[4:2] ),
    .PWDATA   ( s_uart_bus.pwdata     ),
    .PRDATA   ( s_uart_bus.prdata  ),
    .PREADY   ( s_uart_bus.pready  ),
    .PSLVERR  ( s_uart_bus.pslverr ),

    .INT      ( s_uart_event ),   //Interrupt output

    .OUT1N    (),                    //Output 1
    .OUT2N    (),                    //Output 2
    .RTSN     ( uart_rts    ),       //RTS output
    .DTRN     ( uart_dtr    ),       //DTR output
    .CTSN     ( uart_cts    ),       //CTS input
    .DSRN     ( uart_dsr    ),       //DSR input
    .DCDN     ( 1'b1        ),       //DCD input
    .RIN      ( 1'b1        ),       //RI input
    .SIN      ( uart_rx     ),
    .SOUT     ( uart_tx     )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 1: APB GPIO interface                            ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb_gpio apb_gpio_i
  (
    .HCLK       ( clk_int[2]   ),
    .HRESETn    ( rst_n        ),

    .PADDR      ( s_gpio_bus.paddr[11:0]),
    .PWDATA     ( s_gpio_bus.pwdata     ),
    .PWRITE     ( s_gpio_bus.pwrite     ),
    .PSEL       ( s_gpio_bus.psel       ),
    .PENABLE    ( s_gpio_bus.penable    ),
    .PRDATA     ( s_gpio_bus.prdata     ),
    .PREADY     ( s_gpio_bus.pready     ),
    .PSLVERR    ( s_gpio_bus.pslverr    ),

    .gpio_in      ( gpio_in       ),
    .gpio_out     ( gpio_out      ),
    .gpio_dir     ( gpio_dir      ),
    .gpio_padcfg  ( gpio_padcfg   ),
    .power_event  ( s_power_event ),
    .interrupt    ( s_gpio_event  )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 2: APB SPI Master interface                      ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb_spi_master
  #(
      .BUFFER_DEPTH(8)
  )
  apb_spi_master_i
  (
    .HCLK         ( clk_int[3]   ),
    .HRESETn      ( rst_n        ),

    .PADDR        ( s_spi_bus.paddr[11:0]),
    .PWDATA       ( s_spi_bus.pwdata     ),
    .PWRITE       ( s_spi_bus.pwrite     ),
    .PSEL         ( s_spi_bus.psel       ),
    .PENABLE      ( s_spi_bus.penable    ),
    .PRDATA       ( s_spi_bus.prdata     ),
    .PREADY       ( s_spi_bus.pready     ),
    .PSLVERR      ( s_spi_bus.pslverr    ),

    .events_o     ( s_spim_event ),

    .spi_clk      ( spi_master_clk  ),
    .spi_csn0     ( spi_master_csn0 ),
    .spi_csn1     ( spi_master_csn1 ),
    .spi_csn2     ( spi_master_csn2 ),
    .spi_csn3     ( spi_master_csn3 ),
    .spi_mode     ( spi_master_mode ),
    .spi_sdo0     ( spi_master_sdo0 ),
    .spi_sdo1     ( spi_master_sdo1 ),
    .spi_sdo2     ( spi_master_sdo2 ),
    .spi_sdo3     ( spi_master_sdo3 ),
    .spi_sdi0     ( spi_master_sdi0 ),
    .spi_sdi1     ( spi_master_sdi1 ),
    .spi_sdi2     ( spi_master_sdi2 ),
    .spi_sdi3     ( spi_master_sdi3 )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 3: Timer Unit                                    ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb_timer
  apb_timer_i
  (
    .HCLK       ( clk_int[4]   ),
    .HRESETn    ( rst_n        ),

    .PADDR      ( s_timer_bus.paddr[11:0]),
    .PWDATA     ( s_timer_bus.pwdata     ),
    .PWRITE     ( s_timer_bus.pwrite     ),
    .PSEL       ( s_timer_bus.psel       ),
    .PENABLE    ( s_timer_bus.penable    ),
    .PRDATA     ( s_timer_bus.prdata     ),
    .PREADY     ( s_timer_bus.pready     ),
    .PSLVERR    ( s_timer_bus.pslverr    ),

    .irq_o      ( timer_irq    )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 4: Event Unit                                    ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb_event_unit
  apb_event_unit_i
  (
    .clk_i            ( clk_i        ),
    .HCLK             ( clk_int[5]   ),
    .HRESETn          ( rst_n        ),

    .PADDR            ( s_event_unit_bus.paddr[11:0]),
    .PWDATA           ( s_event_unit_bus.pwdata     ),
    .PWRITE           ( s_event_unit_bus.pwrite     ),
    .PSEL             ( s_event_unit_bus.psel       ),
    .PENABLE          ( s_event_unit_bus.penable    ),
    .PRDATA           ( s_event_unit_bus.prdata     ),
    .PREADY           ( s_event_unit_bus.pready     ),
    .PSLVERR          ( s_event_unit_bus.pslverr    ),

    .irq_i            ( {timer_irq, s_spim_event, s_gpio_event, s_uart_event, i2c_event, s_spim1_event, s_uart1_event, i2c1_event, ahb_int, cam_int, ann_int, emmc_int, 15'b0} ), 
    .event_i          ( {timer_irq, s_spim_event, s_gpio_event, s_uart_event, i2c_event, s_spim1_event, s_uart1_event, i2c1_event, ahb_int, cam_int, ann_int, emmc_int, 15'b0} ),
    .irq_o            ( irq_o              ),

    .fetch_enable_i   ( fetch_enable_i     ),
    .fetch_enable_o   ( fetch_enable_o     ),
    .clk_gate_core_o  ( clk_gate_core_o    ),
    .core_busy_i      ( core_busy_i        )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 5: I2C                                           ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb_i2c
  apb_i2c_i
  (
    .HCLK         ( clk_int[6]    ),
    .HRESETn      ( rst_n         ),

    .PADDR        ( s_i2c_bus.paddr[11:0] ),
    .PWDATA       ( s_i2c_bus.pwdata      ),
    .PWRITE       ( s_i2c_bus.pwrite      ),
    .PSEL         ( s_i2c_bus.psel        ),
    .PENABLE      ( s_i2c_bus.penable     ),
    .PRDATA       ( s_i2c_bus.prdata      ),
    .PREADY       ( s_i2c_bus.pready      ),
    .PSLVERR      ( s_i2c_bus.pslverr     ),
    .interrupt_o  ( i2c_event     ),
    .scl_pad_i    ( scl_pad_i     ),
    .scl_pad_o    ( scl_pad_o     ),
    .scl_padoen_o ( scl_padoen_o  ),
    .sda_pad_i    ( sda_pad_i     ),
    .sda_pad_o    ( sda_pad_o     ),
    .sda_padoen_o ( sda_padoen_o  )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 6: PULPino control                               ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

    apb_pulpino
    #(
      .BOOT_ADDR ( ROM_START_ADDR )
    )
    apb_pulpino_i
    (
      .HCLK        ( clk_i        ),
      .HRESETn     ( rst_n        ),

      .PADDR       ( s_soc_ctrl_bus.paddr[11:0]),
      .PWDATA      ( s_soc_ctrl_bus.pwdata     ),
      .PWRITE      ( s_soc_ctrl_bus.pwrite     ),
      .PSEL        ( s_soc_ctrl_bus.psel       ),
      .PENABLE     ( s_soc_ctrl_bus.penable    ),
      .PRDATA      ( s_soc_ctrl_bus.prdata     ),
      .PREADY      ( s_soc_ctrl_bus.pready     ),
      .PSLVERR     ( s_soc_ctrl_bus.pslverr    ),

      .pad_cfg_o   ( pad_cfg_o                  ),
      .clk_gate_o  ( peripheral_clock_gate_ctrl ),
      .pad_mux_o   ( pad_mux_o                  ),
      .boot_addr_o ( boot_addr_o                )
    );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 7: APB2PER for debug                             ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb2per
  #(
    .PER_ADDR_WIDTH ( 15             ),
    .APB_ADDR_WIDTH ( APB_ADDR_WIDTH )
  )
  apb2per_debug_i
  (
    .clk_i                ( clk_i                   ),
    .rst_ni               ( rst_n                   ),

    .PADDR                ( s_debug_bus.paddr       ),
    .PWDATA               ( s_debug_bus.pwdata      ),
    .PWRITE               ( s_debug_bus.pwrite      ),
    .PSEL                 ( s_debug_bus.psel        ),
    .PENABLE              ( s_debug_bus.penable     ),
    .PRDATA               ( s_debug_bus.prdata      ),
    .PREADY               ( s_debug_bus.pready      ),
    .PSLVERR              ( s_debug_bus.pslverr     ),

    .per_master_req_o     ( debug.req               ),
    .per_master_add_o     ( debug.addr              ),
    .per_master_we_o      ( debug.we                ),
    .per_master_wdata_o   ( debug.wdata             ),
    .per_master_be_o      (                         ),
    .per_master_gnt_i     ( debug.gnt               ),

    .per_master_r_valid_i ( debug.rvalid            ),
    .per_master_r_opc_i   ( '0                      ),
    .per_master_r_rdata_i ( debug.rdata             )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 8: APB UART1 interface                           ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb_uart i_apb_uart1
  (
    .CLK      ( clk_int[7]   ),
    .RSTN     ( rst_n        ),

    .PSEL     ( s_uart1_bus.psel    ),
    .PENABLE  ( s_uart1_bus.penable    ),
    .PWRITE   ( s_uart1_bus.pwrite     ),
    .PADDR    ( s_uart1_bus.paddr[4:2] ),
    .PWDATA   ( s_uart1_bus.pwdata     ),
    .PRDATA   ( s_uart1_bus.prdata  ),
    .PREADY   ( s_uart1_bus.pready  ),
    .PSLVERR  ( s_uart1_bus.pslverr ),

    .INT      ( s_uart1_event ),   //Interrupt output

    .OUT1N    (),                    //Output 1
    .OUT2N    (),                    //Output 2
    .RTSN     ( uart1_rts    ),       //RTS output
    .DTRN     ( uart1_dtr    ),       //DTR output
    .CTSN     ( uart1_cts    ),       //CTS input
    .DSRN     ( uart1_dsr    ),       //DSR input
    .DCDN     ( 1'b1        ),       //DCD input
    .RIN      ( 1'b1        ),       //RI input
    .SIN      ( uart1_rx     ),
    .SOUT     ( uart1_tx     )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 9: APB SPI Master1 interface                     ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb_spi_master
  #(
      .BUFFER_DEPTH(8)
  )
  apb_spi_master1_i
  (
    .HCLK         ( clk_int[8]   ),
    .HRESETn      ( rst_n        ),

    .PADDR        ( s_spi1_bus.paddr[11:0]),
    .PWDATA       ( s_spi1_bus.pwdata     ),
    .PWRITE       ( s_spi1_bus.pwrite     ),
    .PSEL         ( s_spi1_bus.psel       ),
    .PENABLE      ( s_spi1_bus.penable    ),
    .PRDATA       ( s_spi1_bus.prdata     ),
    .PREADY       ( s_spi1_bus.pready     ),
    .PSLVERR      ( s_spi1_bus.pslverr    ),

    .events_o     ( s_spim1_event ),

    .spi_clk      ( spi_master1_clk  ),
    .spi_csn0     ( spi_master1_csn0 ),
    .spi_csn1     ( spi_master1_csn1 ),
    .spi_csn2     ( spi_master1_csn2 ),
    .spi_csn3     ( spi_master1_csn3 ),
    .spi_mode     ( spi_master1_mode ),
    .spi_sdo0     ( spi_master1_sdo0 ),
    .spi_sdo1     ( spi_master1_sdo1 ),
    .spi_sdo2     ( spi_master1_sdo2 ),
    .spi_sdo3     ( spi_master1_sdo3 ),
    .spi_sdi0     ( spi_master1_sdi0 ),
    .spi_sdi1     ( spi_master1_sdi1 ),
    .spi_sdi2     ( spi_master1_sdi2 ),
    .spi_sdi3     ( spi_master1_sdi3 )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 10: I2C1                                         ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb_i2c
  apb_i2c1_i
  (
    .HCLK         ( clk_int[9]    ),
    .HRESETn      ( rst_n         ),

    .PADDR        ( s_i2c1_bus.paddr[11:0] ),
    .PWDATA       ( s_i2c1_bus.pwdata      ),
    .PWRITE       ( s_i2c1_bus.pwrite      ),
    .PSEL         ( s_i2c1_bus.psel        ),
    .PENABLE      ( s_i2c1_bus.penable     ),
    .PRDATA       ( s_i2c1_bus.prdata      ),
    .PREADY       ( s_i2c1_bus.pready      ),
    .PSLVERR      ( s_i2c1_bus.pslverr     ),
    .interrupt_o  ( i2c1_event     ),
    .scl_pad_i    ( scl1_pad_i     ),
    .scl_pad_o    ( scl1_pad_o     ),
    .scl_padoen_o ( scl1_padoen_o  ),
    .sda_pad_i    ( sda1_pad_i     ),
    .sda_pad_o    ( sda1_pad_o     ),
    .sda_padoen_o ( sda1_padoen_o  )
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 11: PWM                                          ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////

  apb_pwm
  apb_pwm_i
  (
    .HCLK       ( clk_int[12]   ),
    .HRESETn    ( rst_n        ),

    .PADDR      ( s_pwm_bus.paddr[11:0]),
    .PWDATA     ( s_pwm_bus.pwdata     ),
    .PWRITE     ( s_pwm_bus.pwrite     ),
    .PSEL       ( s_pwm_bus.psel       ),
    .PENABLE    ( s_pwm_bus.penable    ),
    .PRDATA     ( s_pwm_bus.prdata     ),
    .PREADY     ( s_pwm_bus.pready     ),
    .PSLVERR    ( s_pwm_bus.pslverr    ),

    .pwm_o      ( pwm_o                )
  );

endmodule
