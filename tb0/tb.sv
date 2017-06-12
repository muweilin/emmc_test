`include "config.sv"
`include "tb_jtag_pkg.sv"
`include "pin_map.sv"

`ifndef HAPS
 `define CLK_PERIOD  40.00ns // 25 MHz: input for SN55PLL. PLL will generate 80MHz
// `define CLK_PERIOD  12.5ns // 80 MHz: input for SN55PLL. PLL bypass
`else
 `define CLK_PERIOD  10.00ns // 100 MHz: input for Xilinx MMCL.
`endif

`ifndef HAPS
 `define BAUDRATE   100000 
`else
 `ifdef CORE0_50M
  `define BAUDRATE   62500
 `endif

 `ifdef CORE0_100M
  `define BAUDRATE   125000 
 `endif
`endif

`define EXIT_SUCCESS  0
`define EXIT_FAIL     1
`define EXIT_ERROR   -1

module tb;
  timeunit      1ns;
  timeprecision 1ps;

  // +MEMLOAD= valid values are "SPI", "PRELOAD", "" (no load of L2)
  // +RUNMODE= valid values are "STANDALONE", "DEPENDENT"
  parameter  SPI           = "SINGLE";    // valid values are "SINGLE", "QUAD"
  parameter  TEST          = ""; //valid values are "" (NONE), "DEBUG"

  int           exit_status = `EXIT_ERROR; // modelsim exit code, will be overwritten when successful

  string        memload;
  string        runmode;

  logic         s_clk   = 1'b0;
  logic         s_rst_n = 1'b0;

  logic         fetch_enable = 1'b0;

  logic [1:0]   padmode_spi_master;
  logic         spi_sck   = 1'b0;
  logic         spi_csn   = 1'b1;
  logic [1:0]   spi_mode;
  logic         spi_sdo0;
  logic         spi_sdo1;
  logic         spi_sdo2;
  logic         spi_sdo3;
  logic         spi_sdi0;
  logic         spi_sdi1;
  logic         spi_sdi2;
  logic         spi_sdi3;

  logic         uart_tx;
  logic         uart_rx;

  logic         scl_pad_i;
  logic         scl_pad_o;
  logic         scl_padoen_o;

  logic         sda_pad_i;
  logic         sda_pad_o;
  logic         sda_padoen_o;
  
  logic [3:0]   pwm;

  tri1          scl_io;
  tri1          sda_io;
  
  wire          c0_pin0;
  wire          c0_pin1;
  wire          c0_pin2;
  wire          c0_pin3;
  wire          c0_pin4;
  wire          c0_pin5;
  wire          c0_pin6;
  wire          c0_pin7;

  logic [31:0]  gpio_in = '0;
  logic [31:0]  gpio_dir;
  logic [31:0]  gpio_out;

  logic [31:0]  recv_data;

  integer i_mem_addr;

  jtag_i jtag_if();

  adv_dbg_if_t adv_dbg_if = new(jtag_if);

  // use 8N1
  uart_bus
  #(
    .BAUD_RATE(`BAUDRATE),
    .PARITY_EN(0),
    .ID(0)
  )
  uart
  (
    .rx         ( uart_rx ),
    .tx         ( uart_tx ),
    .rx_en      ( 1'b1    )
  );

  spi_slave
  spi_master();

  i2c_eeprom_model
  #(
    .ADDRESS ( 7'b1010_000 )
  )
  i2c_eeprom_model_i
  (
    .scl_io ( scl_io  ),
    .sda_io ( sda_io  ),
    .rst_ni ( s_rst_n )
  );

  logic   spi_master_sdo0;
  logic   spi_master_sdi0;
  logic   spi_master_clk;
  logic   spi_master_csn0;

  tri   flash_sdo;
  tri   flash_sdi;
  tri   flash_rstn;  

  assign flash_sdi = spi_master_sdo0;
  assign spi_master_sdi0 = flash_sdo;
  assign flash_rstn = s_rst_n;

  s25fs128s spiflash_i
  (

    .SI       ( flash_sdi   ),
    .SO       ( flash_sdo   ),
        // Controls
    .SCK      ( spi_master_clk ),
    .CSNeg    ( spi_master_csn0 ),
    .RESETNeg ( flash_rstn),
    .WPNeg    ( )
  );

  top top0_i
 (
`ifdef HAPS
     .OBS_PIN                 ( ),
`endi 
//common
     .clk_i                    (  s_clk   ),
     .div_pll_i                (  2'b11   ),
     .pll_bps_i                (  1'b0    ),
     .rstn_i                   (  s_rst_n ),
//ppu
     .testmode_i        ( 1'b0  ),
     .fetch_enable_i    ( 1'b0  ),

     .spi_master_clk_o  ( ),
     .spi_master_csn0_o ( ),
     .spi_master_sdo0_o ( ),
     .spi_master_sdi0_i ( ),
     //uart
     .uart_tx           ( ),
     .uart_rx           ( ),
    //memctl
	 .memctl_s_ck_p          ( ),
	 .memctl_s_ck_n          ( ),
	 .memctl_s_sel_n         ( ),
	 .memctl_s_cke           ( ),
	 .memctl_s_ras_n         ( ),
	 .memctl_s_cas_n         ( ),
	 .memctl_s_we_n          ( ),
	 .memctl_s_addr          ( ),
	 .memctl_s_bank_addr     ( ),
	 .memctl_s_dqm           ( ),
	 .memctl_s_dqs           ( ),  //tri
	 .memctl_s_dq            ( ),  //tri
	 .memctl_s_rd_dqs_mask   ( ),
	 .memctl_int_rd_dqs_mask ( ),
     //eMMC
	 .emmc_cclk_out          ( ),
	 .emmc_ccmd              ( ), //tri
	 .emmc_cdata             ( ), //tri
	 .emmc_card_detect_n     ( ),
	 .emmc_card_write_prt    ( ),
	 .sdio_card_int_n        ( ),
	 .mmc_4_4_rst_n          ( ),

     //Mux Pins
     .PIN0_scl_uart1tx        ( ),
     .PIN1_sda_uart1rx        ( ),
     .PIN2_spim1sdo0_gpio0     ( ),
     .PIN3_spim1csn0_gpio1    ( ),
     .PIN4_spim1sdi0_vsync    ( ),
     .PIN5_pwm0_href          ( ),
     .PIN6_pwm1_camdata7      ( ),
     .PIN7_pwm2_camdata6      ( ),
     .PIN8_pwm3_camdata5      ( ),
     .PIN9_gpio2_camdata4    ( ),
     .PIN10_gpio3_camdata3    ( ),
     .PIN11_gpio4_camdata2    ( ),
     .PIN12_gpio5_camdata1    ( ),
     .PIN13_gpio6_camdata0    ( ),

     .spim1clk ( ),
     .pclk     ( ),

/////////////////////////////////////
///           ppu0               ////
/////////////////////////////////////
     .c0_testmode_i     ( 1'b0 ),
     .c0_fetch_enable_i ( fetch_enable ),

     .c0_uart_tx        ( uart_rx ),
     .c0_uart_rx        ( uart_tx ),

    //PIN0
    `ifdef C0_PIN0_SCL
    .c0_PIN0_spimclk_scl    (  scl_io  ),
    `else
    .c0_PIN0_spimclk_scl    (  c0_pin0 ),
    `endif

    //PIN1
    `ifdef C0_PIN1_SDA
    .c0_PIN1_spimcsn_sda    (  sda_io  ),
    `else
    .c0_PIN1_spimcsn_sda    (  c0_pin1 ),
    `endif

    //PIN2
    .c0_PIN2_spimsdo_gpio0  (  c0_pin2 ),
    //PIN3
    .c0_PIN3_spimsdi_gpio1  (  c0_pin3 ),
   //PIN4
    .c0_PIN4_pwm0_gpio2     (  c0_pin4 ),
   //PIN5
    .c0_PIN5_pwm1_gpio3     (  c0_pin5 ),
   //PIN6
    .c0_PIN6_pwm2_gpio4     (  c0_pin6 ),
   //PIN7
    .c0_PIN7_pwm3_gpio5     (  c0_pin7 ),

/////////////////////////////////////
///    shared part               ////
/////////////////////////////////////
     .select_c0_i       ( 1'b1 ),
    //SPI Slave

     .spi_clk_i         ( spi_sck    ),
  .c0_spi_cs_i          ( spi_csn    ),
     .spi_cs_i          ( 1'b1   ),
     .spi_sdo0_o        ( spi_sdi0   ),
     .spi_sdi0_i        ( spi_sdo0   ),

     //jtag
     .tck_i             ( jtag_if.tck     ),
     .trstn_i           ( jtag_if.trstn   ),
     .tms_i             ( jtag_if.tms     ),
     .tdi_i             ( jtag_if.tdi     ),
     .tdo_o             ( jtag_if.tdo     )
   );


  generate
    begin
      initial
      begin
        #(`CLK_PERIOD/2);
        s_clk = 1'b1;
        forever s_clk = #(`CLK_PERIOD/2) ~s_clk;
      end
    end
  endgenerate

  logic use_qspi;

  initial
  begin
    int i;

  `ifdef HAPS 
    `ifdef CORE0_50M    
      $display("PPU0(FPGA) Simulation @ 50MHz");
    `endif
    `ifdef CORE0_100M    
      $display("PPU0(FPGA) Simulation @ 100MHz");
    `endif
  `else 
      $display("PPU0(ASIC) Simulation @ 80MHz");
  `endif

    if(!$value$plusargs("MEMLOAD=%s", memload))
      memload = "PRELOAD";

    if(!$value$plusargs("RUNMODE=%s", runmode))
      runmode = "DEPENDENT";

    `ifdef HAPS
      memload = "SPI";
    `endif

    $display("Using MEMLOAD : %s", memload);
    $display("Using RUNMODE : %s", runmode);

    use_qspi = SPI == "QUAD" ? 1'b1 : 1'b0;

    s_rst_n      = 1'b0;
    fetch_enable = 1'b0;

    #500ns;

    s_rst_n = 1'b1;

    //wait until system rst goes up
    wait(top0_i.ppu0_top_i.clk_rst_gen0_i.rstn_o) 

    #500ns;
    if (use_qspi)
      spi_enable_qpi();


    if (runmode != "STANDALONE")
    begin
      /* Configure JTAG and set boot address */
      adv_dbg_if.jtag_reset();
      adv_dbg_if.jtag_softreset();
      adv_dbg_if.init();
      adv_dbg_if.axi4_write32(32'h1A10_6008, 1, 32'h0000_0000);
    end

    if (memload == "PRELOAD")
    begin
      // preload memories
      mem_preload();
    end
    else
    begin
      spi_load(use_qspi);
      spi_check(use_qspi);
    end

    #200ns;
      fetch_enable = 1'b1;
    

   if(TEST == "DEBUG") begin
      debug_tests();
    end else if (TEST == "MEM_DPI") begin
      mem_dpi(4567);
    end else if (TEST == "MUX_GPIO") begin
      // Here test for IO mux gpio
      #5ms;
      gpio_in[0]=1'b1;
      gpio_in[1]=1'b1;
      gpio_in[2]=1'b1;
      gpio_in[3]=1'b1;
      gpio_in[4]=1'b1;
      gpio_in[5]=1'b1;
      #2ms;
      gpio_in[0]=1'b0;
      gpio_in[1]=1'b0;
      gpio_in[2]=1'b0;
      gpio_in[3]=1'b0;
      gpio_in[4]=1'b0;
      gpio_in[5]=1'b0;

      #2ms;
      gpio_in[0]=1'b1;
      gpio_in[1]=1'b1;
      gpio_in[2]=1'b1;
      gpio_in[3]=1'b1;
      gpio_in[4]=1'b0;
      gpio_in[5]=1'b0;

      #2ms;
      gpio_in[0]=1'b0;
      gpio_in[1]=1'b0;
      gpio_in[2]=1'b0;
      gpio_in[3]=1'b0;
      gpio_in[4]=1'b1;
      gpio_in[5]=1'b1;

    end else if (TEST == "ARDUINO_UART") begin
      if (~gpio_out[0])
        wait(gpio_out[0]);
      uart.send_char(8'h65);
    end else if (TEST == "ARDUINO_GPIO") begin
      // Here  test for GPIO Starts
      #50us;
      gpio_in[4]=1'b1;
      #10us;
      gpio_in[4]=1'b0;
      #10us;
      gpio_in[4]=1'b1;
      gpio_in[7]=1'b1;
    end else if (TEST == "ARDUINO_SHIFT") begin
      if (~gpio_out[0])
        wait(gpio_out[0]);

      gpio_in[3]=1'b1;
      //#5us;
      #650ns;
      gpio_in[3]=1'b1;
      //#5us;
      #650ns;
      gpio_in[3]=1'b0;
      //#5us;
      #650ns;
      gpio_in[3]=1'b0;
      //#5us;
      #650ns;
      gpio_in[3]=1'b1;
      //#5us;
      #650ns;
      gpio_in[3]=1'b0;
      //#5us;
      #650ns;
      gpio_in[3]=1'b0;
      //#5us;
      #650ns;
      gpio_in[3]=1'b1;
      //#5us;
      #650ns;
    end else if (TEST == "ARDUINO_PULSEIN") begin
      if (~gpio_out[0])
        wait(gpio_out[0]);
      #50us;
      gpio_in[4]=1'b1;
      #500us;
      gpio_in[4]=1'b0;
      #1ms;
      gpio_in[4]=1'b1;
      #500us;
      gpio_in[4]=1'b0;
    end else if (TEST == "ARDUINO_INT") begin
      if (~gpio_out[0])
        wait(gpio_out[0]);
      #50us;
      gpio_in[1]=1'b1;
      #20us;
      gpio_in[1]=1'b0;
      #20us;
      gpio_in[1]=1'b1;
      #20us;
      gpio_in[2]=1'b1;
      #20us;
    end else if (TEST == "ARDUINO_SPI") begin
      for(i = 0; i < 2; i++) begin
        spi_master.wait_csn(1'b0);
        spi_master.send(0, {>>{8'h38}});
      end
    end

//    #1000000ms;

    // end of computation
    if (~gpio_out[0])
      wait(gpio_out[0]);

    spi_check_return_codes(exit_status);

    $fflush();
    $stop();
  end

  // TODO: this is a hack, do it properly!
  `include "uart.sv" //Why this include is missed? Lei
  `include "tb_spi_pkg.sv"
  `include "tb_smic_ram_pkg.sv"
  `include "spi_debug_test.svh"
  `include "mem_dpi.svh"
  `include "pin_map.svh"

endmodule

