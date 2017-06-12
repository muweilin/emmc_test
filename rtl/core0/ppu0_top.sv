// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "axi_bus.sv"
`include "debug_bus.sv"
`include "config.sv"

`define AXI_ADDR_WIDTH         32
`define AXI_DATA_WIDTH         32
`define AXI_ID_MASTER_WIDTH     2
`define AXI_ID_SLAVE_WIDTH      4
`define AXI_USER_WIDTH          1

module ppu0_top
  (
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
    //uart
    output logic              uart_tx,
    input  logic              uart_rx,
    // JTAG signals
    input  logic              tck_i,
    input  logic              trstn_i,
    input  logic              tms_i,
    input  logic              tdi_i,
    output logic              tdo_o,

    //PIN0
    output logic              spimclk_scl_o,
    input logic               spimclk_scl_i,
    output logic              spimclk_scl_oe,

    //PIN1
    output logic              spimcsn_sda_o,
    input logic               spimcsn_sda_i,
    output logic              spimcsn_sda_oe,

    //PIN2
    output logic              spimsdo_gpio0_o,
    input logic               spimsdo_gpio0_i,
    output logic              spimsdo_gpio0_oe,

    //PIN3
    output logic              spimsdi_gpio1_o,
    input logic               spimsdi_gpio1_i,
    output logic              spimsdi_gpio1_oe,

   //PIN4
    output logic              pwm0_gpio2_o,
    input logic               pwm0_gpio2_i,
    output logic              pwm0_gpio2_oe,

   //PIN5
    output logic              pwm1_gpio3_o,
    input logic               pwm1_gpio3_i,
    output logic              pwm1_gpio3_oe,

   //PIN6
    output logic              pwm2_gpio4_o,
    input logic               pwm2_gpio4_i,
    output logic              pwm2_gpio4_oe,

   //PIN7
    output logic              pwm3_gpio5_o,
    input logic               pwm3_gpio5_i,
    output logic              pwm3_gpio5_oe

  );

  logic        clk_int;

  logic        fetch_enable_int;
  logic        core_busy_int;
  logic        clk_gate_core_int;
  logic [31:0] irq_to_core_int;

  logic        rstn_int;
  logic [31:0] boot_addr_int;

  logic              spi_master_clk_o;
  logic              spi_master_csn0_o;
  logic              spi_master_sdo0_o;
  logic              spi_master_sdi0_i;

  logic              scl_pad_i;
  logic              scl_pad_o;
  logic              scl_padoen_o;
  logic              sda_pad_i;
  logic              sda_pad_o;
  logic              sda_padoen_o;
  logic       [31:0] gpio_in;
  logic       [31:0] gpio_out;
  logic       [31:0] gpio_dir;
  logic   [3:0]      pwm_o;
  logic [31:0] [5:0] pad_cfg_o;


  AXI_BUS
  #(
    .AXI_ADDR_WIDTH ( `AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( `AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( `AXI_ID_SLAVE_WIDTH ),
    .AXI_USER_WIDTH ( `AXI_USER_WIDTH     )
  )
  slaves[2:0]();

  AXI_BUS
  #(
    .AXI_ADDR_WIDTH ( `AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH ( `AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH   ( `AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH ( `AXI_USER_WIDTH      )
  )
  masters[2:0]();

  DEBUG_BUS
  debug();

  //----------------------------------------------------------------------------//
  // Clock and reset generation
  //----------------------------------------------------------------------------//
  clk_rst_gen0
  clk_rst_gen0_i
  (
      .clk_i            ( clk              ),
      .rstn_i           ( rst_n            ),
      .lock_i           ( lock             ),
      .testmode_i       ( testmode_i       ),
      .pll_bps_i        ( pll_bps_i        ),
      .clk_o            ( clk_int          ),
      .rstn_o           ( rstn_int         )
    );

  //----------------------------------------------------------------------------//
  // Core region
  //----------------------------------------------------------------------------//
  core_region0
  #(
    .AXI_ADDR_WIDTH       ( `AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH       ( `AXI_DATA_WIDTH      ),
    .AXI_ID_MASTER_WIDTH  ( `AXI_ID_MASTER_WIDTH ),
    .AXI_ID_SLAVE_WIDTH   ( `AXI_ID_SLAVE_WIDTH  ),
    .AXI_USER_WIDTH       ( `AXI_USER_WIDTH      )
  )
  core_region0_i
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
    .dbg_master     ( masters[1]        ),
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
  peripherals0
  #(
    .AXI_ADDR_WIDTH      ( `AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH      ( `AXI_DATA_WIDTH      ),
    .AXI_SLAVE_ID_WIDTH  ( `AXI_ID_SLAVE_WIDTH  ),
    .AXI_MASTER_ID_WIDTH ( `AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH      ( `AXI_USER_WIDTH      )
  )
  peripherals0_i
  (
    .clk_i           ( clk_int           ),
    .rst_n           ( rstn_int          ),

    .axi_spi_master  ( masters[2]        ),
    .debug           ( debug             ),

    .testmode_i      ( testmode_i        ),

    .spi_clk_i       ( spi_clk_i         ),
    .spi_cs_i        ( spi_cs_i          ),
    .spi_mode_o      ( ),
    .spi_sdo0_o      ( spi_sdo0_o        ),
    .spi_sdo1_o      ( ),
    .spi_sdo2_o      ( ),
    .spi_sdo3_o      ( ),
    .spi_sdi0_i      ( spi_sdi0_i       ),
    .spi_sdi1_i      ( 1'b0 ),
    .spi_sdi2_i      ( 1'b0 ),
    .spi_sdi3_i      ( 1'b0 ),

    .slave           ( slaves[2]         ),

    .uart_tx         ( uart_tx           ),
    .uart_rx         ( uart_rx           ),
    .uart_rts        ( ),
    .uart_dtr        ( ),
    .uart_cts        ( 1'b1 ),
    .uart_dsr        ( 1'b1 ),

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

    .scl_pad_i       ( scl_pad_i         ),
    .scl_pad_o       ( scl_pad_o         ),
    .scl_padoen_o    ( scl_padoen_o      ),
    .sda_pad_i       ( sda_pad_i         ),
    .sda_pad_o       ( sda_pad_o         ),
    .sda_padoen_o    ( sda_padoen_o      ),

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

    .pwm_o           ( pwm_o             )
  );


  //----------------------------------------------------------------------------//
  // Axi node
  //----------------------------------------------------------------------------//

  axi_node_intf_wrap
  #(
    .NB_MASTER      ( 3                    ),
    .NB_SLAVE       ( 3                    ),
    .AXI_ADDR_WIDTH ( `AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH ( `AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH   ( `AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH ( `AXI_USER_WIDTH      )
  )
  axi_interconnect0_i
  (
    .clk       ( clk_int    ),
    .rst_n     ( rstn_int   ),
    .test_en_i ( testmode_i ),

    .master    ( slaves     ),
    .slave     ( masters    ),

    .start_addr_i ( { 32'h1A10_0000, 32'h0010_0000, 32'h0000_0000 } ),
    .end_addr_i   ( { 32'h1A11_FFFF, 32'h001F_FFFF, 32'h000F_FFFF } ) // 128KB : 1MB : 1MB
  );

  //----------------------------------------------------------------------------//
  //  Pin mux logic
  //----------------------------------------------------------------------------//
  //PIN0
  iomux
  io_mux_spimclk_scl
  (
      .chip_in0   (  spi_master_clk_o ),
      .chip_in1   (  scl_pad_o        ),

      .chip_out0  ( ),
      .chip_out1  (  scl_pad_i        ),

      .chip_dir0  (  `DIR_OUTPUT       ),
      .chip_dir1  (  ~scl_padoen_o     ),

      .io_cfg     (  pad_cfg_o[0][0]   ),

      .io_out     (  spimclk_scl_o   ),
      .io_in      (  spimclk_scl_i   ),
      .io_dir     (  spimclk_scl_oe  ) 
);
  //PIN1
  iomux
  io_mux_spimcsn_sda
  (
      .chip_in0   (  spi_master_csn0_o ),
      .chip_in1   (  sda_pad_o        ),

      .chip_out0  ( ),
      .chip_out1  (  sda_pad_i        ),

      .chip_dir0  (  `DIR_OUTPUT       ),
      .chip_dir1  (  ~sda_padoen_o     ),

      .io_cfg     (  pad_cfg_o[1][0]   ),

      .io_out     (  spimcsn_sda_o   ),
      .io_in      (  spimcsn_sda_i   ),
      .io_dir     (  spimcsn_sda_oe  ) 
);
  //PIN2
  iomux
  io_mux_spimsdo_gpio0
  (
      .chip_in0   (  spi_master_sdo0_o ),
      .chip_in1   (  gpio_out[0]       ),

      .chip_out0  ( ),
      .chip_out1  (  gpio_in[0]        ),

      .chip_dir0  (  `DIR_OUTPUT       ),
      .chip_dir1  (  gpio_dir[0]       ),

      .io_cfg     (  pad_cfg_o[2][0]   ),

      .io_out     (  spimsdo_gpio0_o  ),
      .io_in      (  spimsdo_gpio0_i  ),
      .io_dir     (  spimsdo_gpio0_oe ) 
);

  //PIN3
  iomux
  io_mux_spimsdi_gpio1
  (
      .chip_in0   ( 1'b0 ),
      .chip_in1   ( gpio_out[1]          ),

      .chip_out0  ( spi_master_sdi0_i    ),
      .chip_out1  ( gpio_in[1]           ),

      .chip_dir0  (  `DIR_INPUT          ),
      .chip_dir1  (  gpio_dir[1]         ),

      .io_cfg     (  pad_cfg_o[3][0]     ),

      .io_out     (  spimsdi_gpio1_o  ),
      .io_in      (  spimsdi_gpio1_i  ),
      .io_dir     (  spimsdi_gpio1_oe ) 
);
  //PIN4
  iomux
  io_mux_pwm0_gpio2
  (
      .chip_in0   (  pwm_o[0]          ),
      .chip_in1   (  gpio_out[2]       ),

      .chip_out0  ( ),
      .chip_out1  (  gpio_in[2]        ),

      .chip_dir0  (  `DIR_OUTPUT       ),
      .chip_dir1  (  gpio_dir[2]       ),

      .io_cfg     (  pad_cfg_o[4][0]  ),

      .io_out     (  pwm0_gpio2_o      ),
      .io_in      (  pwm0_gpio2_i      ),
      .io_dir     (  pwm0_gpio2_oe     ) 
);
  //PIN5
  iomux
  io_mux_pwm1_gpio3
  (
      .chip_in0   (  pwm_o[1]          ),
      .chip_in1   (  gpio_out[3]       ),

      .chip_out0  ( ),
      .chip_out1  (  gpio_in[3]        ),

      .chip_dir0  (  `DIR_OUTPUT       ),
      .chip_dir1  (  gpio_dir[3]       ),

      .io_cfg     (  pad_cfg_o[5][0]  ),

      .io_out     (  pwm1_gpio3_o      ),
      .io_in      (  pwm1_gpio3_i      ),
      .io_dir     (  pwm1_gpio3_oe     ) 
);
  //PIN6
  iomux
  io_mux_pwm2_gpio4
  (
      .chip_in0   (  pwm_o[2]          ),
      .chip_in1   (  gpio_out[4]       ),

      .chip_out0  ( ),
      .chip_out1  (  gpio_in[4]        ),

      .chip_dir0  (  `DIR_OUTPUT       ),
      .chip_dir1  (  gpio_dir[4]       ),

      .io_cfg     (  pad_cfg_o[6][0]  ),

      .io_out     (  pwm2_gpio4_o      ),
      .io_in      (  pwm2_gpio4_i      ),
      .io_dir     (  pwm2_gpio4_oe     ) 
);
  //PIN7
  iomux
  io_mux_pwm3_gpio5
  (
      .chip_in0   (  pwm_o[3]          ),
      .chip_in1   (  gpio_out[5]       ),

      .chip_out0  ( ),
      .chip_out1  (  gpio_in[5]        ),

      .chip_dir0  (  `DIR_OUTPUT       ),
      .chip_dir1  (  gpio_dir[5]       ),

      .io_cfg     (  pad_cfg_o[7][0]  ),

      .io_out     (  pwm3_gpio5_o      ),
      .io_in      (  pwm3_gpio5_i      ),
      .io_dir     (  pwm3_gpio5_oe     ) 
);

endmodule

