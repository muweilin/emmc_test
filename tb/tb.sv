`include "config.sv"
`include "tb_jtag_pkg.sv"
`include "wiredelay.v"
`include "tb_camera_pkg.sv"
`include "pin_map.sv"

`ifndef HAPS
 `define CLK_PERIOD  40.00ns // 25 MHz: input for SN55PLL. PLL will generate 200MHz
// `define CLK_PERIOD  5ns // Bypass PLL. 200 MHz from board to soc
`else
 `define CLK_PERIOD  10.00ns // 100 MHz: input for Xilinx MMCL.
`endif

 `define CAM_CLK_PERIOD  40.00ns // 25 MHz camera clock

`ifndef HAPS
 `define BAUDRATE      250000
// `define BAUDRATE      125000

`else
  `ifdef CORE_50M
    `define BAUDRATE   62500
  `endif
  `ifdef CORE_25M
    `define BAUDRATE   31250
  `endif
`endif

`define EXIT_SUCCESS  0
`define EXIT_FAIL     1
`define EXIT_ERROR   -1
//`define SPILOOP


module tb;
  timeunit      1ns;
  timeprecision 1ps;

  // +MEMLOAD= valid values are "SPI", "PRELOAD", "" (no load of L2)
  // +RUNMODE= valid values are "STANDALONE", "DEPENDENT"
//  parameter  SPI           = "QUAD";    // valid values are "SINGLE", "QUAD"
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

  logic         uart1_tx;
  logic         uart1_rx;
  logic         s_uart1_dtr;
  logic         s_uart1_rts;

  tri1          scl_io;
  tri1          sda_io;

  logic [31:0]  gpio_in = '0;
  logic [31:0]  gpio_dir;
  logic [31:0]  gpio_out;

  logic [31:0]  recv_data;

  logic         cam_pclk   = 1'b0;
  logic         cam_vsync;
  logic         cam_href;
  logic [7:0]   cam_data;

  logic        s_ck_p_sdram;
  logic        s_ck_p_soc;

  logic        s_ck_n_sdram;
  logic        s_ck_n_soc;

  logic        s_cke_sdram;
  logic        s_cke_soc;

  logic [1:0]  s_dqm_sdram;
  logic [1:0]  s_dqm_soc;            

  logic        s_sel_n_sdram;
  logic        s_sel_n_soc;    

  logic        s_ras_n_sdram;
  logic        s_ras_n_soc;  

  logic        s_cas_n_sdram;
  logic        s_cas_n_soc;

  logic        s_we_n_sdram;
  logic        s_we_n_soc;      

  logic [15:0] s_addr_sdram;
  logic [15:0] s_addr_soc; 

  logic  [1:0] s_bank_addr_sdram;
  logic  [1:0] s_bank_addr_soc; 

//  tri0   [1:0] s_dqs_sdram;
//  tri0   [1:0] s_dqs_soc;

//  tri0  [15:0] s_dq_sdram;
//  tri0  [15:0] s_dq_soc;

  wire   [1:0] s_dqs_sdram;
  wire   [1:0] s_dqs_soc;

  wire  [15:0] s_dq_sdram;
  wire  [15:0] s_dq_soc;

  logic        int_rd_dqs_mask_soc;
  logic        s_rd_dqs_mask_soc;

  logic [3:0]   pwm;

  wire         pin0;
  wire         pin1;
  wire         pin2;
  wire         pin3;
  wire         pin4;
  wire         pin5;
  wire         pin6;
  wire         pin7;
  wire         pin8;
  wire         pin9;
  wire         pin10;
  wire         pin11;
  wire         pin12;
  wire         pin13;

//  integer i_mem_addr;

  jtag_i jtag_if();

  adv_dbg_if_t adv_dbg_if = new(jtag_if);

  assign #`PCB_CTRL_DELAY    s_ck_p_sdram      =  s_ck_p_soc;
  assign #`PCB_CTRL_DELAY    s_ck_n_sdram      =  s_ck_n_soc;
  assign #`PCB_CTRL_DELAY    s_cke_sdram       =  s_cke_soc;
  assign #`PCB_CTRL_DELAY    s_dqm_sdram       =  s_dqm_soc;            
  assign #`PCB_CTRL_DELAY    s_sel_n_sdram     =  s_sel_n_soc;    
  assign #`PCB_CTRL_DELAY    s_ras_n_sdram     =  s_ras_n_soc;  
  assign #`PCB_CTRL_DELAY    s_cas_n_sdram     =  s_cas_n_soc;    
  assign #`PCB_CTRL_DELAY    s_we_n_sdram      =  s_we_n_soc;      
  assign #`PCB_CTRL_DELAY    s_addr_sdram      =  s_addr_soc; 
  assign #`PCB_CTRL_DELAY    s_bank_addr_sdram =  s_bank_addr_soc; 
  assign #`PCB_RDMASK_DELAY  int_rd_dqs_mask_soc  =  s_rd_dqs_mask_soc;

   genvar dqwd;
   generate
      for (dqwd = 0; dqwd < 16; dqwd = dqwd + 1 ) begin : dq_wire_delay
	 wiredelay #
	   (
            .Delay    (`PCB_DQ_DATA_DELAY)
	    )
	 dq_delay_i
	   (
            .A           ( s_dq_soc[dqwd]   ),
            .B           ( s_dq_sdram[dqwd] ),
            .rstn        ( s_rst_n          )
	    );
      end
   endgenerate
   
   genvar dqswd;
   generate
      for (dqswd = 0; dqswd < 2; dqswd = dqswd + 1 ) begin : dqs_wire_delay
	 wiredelay #
	   (
            .Delay   (`PCB_DQS_DELAY)
	    )
	 dqs_delay_i
	   (
            .A           ( s_dqs_soc[dqswd]   ),
            .B           ( s_dqs_sdram[dqswd] ),
            .rstn        ( s_rst_n            )
	    );
      end
   endgenerate

  mobile_ddr lpddr_i 
  (
    .Dq         ( s_dq_soc        ), //tri
    .Dqs        ( s_dqs_soc       ), //tri
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

  camera_emu camera_emu_i
  (
    .cam_pclk   ( cam_pclk  ),
    .cam_rstn   ( s_rst_n   ),
    .cam_vsync  ( cam_vsync ),
    .cam_href   ( cam_href  ),
    .cam_data   ( cam_data  )
  );

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

  // use 8N1
  uart_bus
  #(
    .BAUD_RATE(`BAUDRATE),
    .PARITY_EN(0),
    .ID(1)
  )
  uart1
  (
    .rx         ( uart1_rx ),
    .tx         ( uart1_tx ),
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


  logic   spi_master1_sdo0;
  logic   spi_master1_sdi0;
  logic   spi_master1_clk;
  logic   spi_master1_csn0;

  tri   flash_sdo;
  tri   flash_sdi;
  tri   flash_rstn;  

  assign flash_sdi = spi_master1_sdo0;
  assign spi_master1_sdi0 = flash_sdo;
  assign flash_rstn = s_rst_n;

  s25fs128s spiflash_i
  (

    .SI       ( flash_sdi   ),
    .SO       ( flash_sdo   ),
        // Controls
    .SCK      ( spi_master1_clk ),
    .CSNeg    ( spi_master1_csn0 ),
    .RESETNeg ( flash_rstn),
    .WPNeg    ( )
  );


`ifdef SPILOOP
//looptest
  logic        spim_sdi;
  logic        spim_sdo;
  logic        spim_clk;
  logic        spim_csn;

  logic        spis_sdo;
  logic        spis_sdi;
  logic        spis_clk;
  logic        spis_csn;

  assign spis_clk = spim_clk;
  assign spis_csn = spim_csn;

  assign spis_sdi = spim_sdo;
  assign spim_sdi = spis_sdo;
`endif

top top_i
 (
//common
     .clk_i             (  s_clk   ),
     .div_pll_i         (  2'b01   ),
     .pll_bps_i         (  1'b0    ),
     .rstn_i            (  s_rst_n ),
//ppu
     .testmode_i        ( 1'b0          ),
     .fetch_enable_i    ( fetch_enable  ),
    //SPI Master
`ifdef SPILOOP
     .spi_master_clk_o  ( spim_clk     ),
     .spi_master_csn0_o ( spim_csn     ),
     .spi_master_sdo0_o ( spim_sdo     ),
     .spi_master_sdi0_i ( spim_sdi     ),
`else
     .spi_master_clk_o  ( spi_master.clk     ),
     .spi_master_csn0_o ( spi_master.csn     ),
     .spi_master_sdo0_o ( spi_master.sdo[0]  ),
     .spi_master_sdi0_i ( spi_master.sdi[0]  ),
 `endif
     //uart
     .uart_tx           ( uart_rx      ),
     .uart_rx           ( uart_tx      ),
    //memctl
	 .memctl_s_ck_p          ( s_ck_p_soc          ),
	 .memctl_s_ck_n          ( s_ck_n_soc          ),
	 .memctl_s_sel_n         ( s_sel_n_soc         ),
	 .memctl_s_cke           ( s_cke_soc           ),
	 .memctl_s_ras_n         ( s_ras_n_soc         ),
	 .memctl_s_cas_n         ( s_cas_n_soc         ),
	 .memctl_s_we_n          ( s_we_n_soc          ),
	 .memctl_s_addr          ( s_addr_soc          ),
	 .memctl_s_bank_addr     ( s_bank_addr_soc     ),
	 .memctl_s_dqm           ( s_dqm_soc           ),
	 .memctl_s_dqs           ( s_dqs_soc           ),  //tri
	 .memctl_s_dq            ( s_dq_soc            ),  //tri
	 .memctl_s_rd_dqs_mask   ( s_rd_dqs_mask_soc   ),
	 .memctl_int_rd_dqs_mask ( int_rd_dqs_mask_soc ),
     //eMMC
	 .emmc_cclk_out          ( ),
	 .emmc_ccmd              ( ), //tri
	 .emmc_cdata             ( ), //tri
	 .emmc_card_detect_n     ( ),
	 .emmc_card_write_prt    ( ),
	 .sdio_card_int_n        ( ),
	 .mmc_4_4_rst_n          ( ),

     //Mux Pins
     `ifdef PIN0_SCL
     .PIN0_scl_uart1tx        ( scl_io ),
     `else
     .PIN0_scl_uart1tx        ( pin0  ),
     `endif

     `ifdef PIN1_SDA
     .PIN1_sda_uart1rx        ( sda_io ),
     `else
     .PIN1_sda_uart1rx        ( pin1  ),
     `endif

     .PIN2_spim1sdo0_gpio0    ( pin2  ),
     .PIN3_spim1csn0_gpio1    ( pin3  ),
     .PIN4_spim1sdi0_vsync    ( pin4  ),
     .PIN5_pwm0_href          ( pin5  ),
     .PIN6_pwm1_camdata7      ( pin6  ),
     .PIN7_pwm2_camdata6      ( pin7  ),
     .PIN8_pwm3_camdata5      ( pin8  ),
     .PIN9_gpio2_camdata4    ( pin9  ),
     .PIN10_gpio3_camdata3    ( pin10 ),
     .PIN11_gpio4_camdata2    ( pin11 ),
     .PIN12_gpio5_camdata1    ( pin12 ),
     .PIN13_gpio6_camdata0    ( pin13 ),

     .spim1clk ( spi_master1_clk ),
     .pclk     ( cam_pclk        ),
/////////////////////////////////////
///           ppu0               ////
/////////////////////////////////////
     .c0_testmode_i     ( 1'b0 ),
     .c0_fetch_enable_i ( 1'b0 ),

     .c0_uart_tx        ( ),
     .c0_uart_rx        ( ),

    //PIN0
     .c0_PIN0_spimclk_scl   ( ),
    //PIN1
     .c0_PIN1_spimcsn_sda   ( ),
    //PIN2
     .c0_PIN2_spimsdo_gpio0 ( ),
    //PIN3
     .c0_PIN3_spimsdi_gpio1 ( ),
   //PIN4
     .c0_PIN4_pwm0_gpio2    ( ),
   //PIN5
     .c0_PIN5_pwm1_gpio3    ( ),
   //PIN6
     .c0_PIN6_pwm2_gpio4    ( ),
   //PIN7
     .c0_PIN7_pwm3_gpio5    ( ),
///
/////////////////////////////////////
///    shared part               ////
/////////////////////////////////////
     .select_c0_i       ( 1'b0 ),
    //SPI Slave

`ifdef SPILOOP
     .spi_clk_i         ( spis_clk   ),
  .c0_spi_cs_i          ( 1'b1       ),
     .spi_cs_i          ( spis_csn   ),
     .spi_sdo0_o        ( spis_sdo   ),
     .spi_sdi0_i        ( spis_sdi   ),
`else
     .spi_clk_i         ( spi_sck    ),
  .c0_spi_cs_i          ( 1'b1       ),
     .spi_cs_i          ( spi_csn    ),
     .spi_sdo0_o        ( spi_sdi0   ),
     .spi_sdi0_i        ( spi_sdo0   ),
`endif
     //jtag
     .tck_i             ( jtag_if.tck     ),
     .trstn_i           ( jtag_if.trstn   ),
     .tms_i             ( jtag_if.tms     ),
     .tdi_i             ( jtag_if.tdi     ),
     .tdo_o             ( jtag_if.tdo     )
   );

  AXI_slave_monitor AXI_slave_monitor_i();

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


  logic use_qspi;

  logic [31:0] memwd;

  if(TEST == "ANN") begin
  `include "init_mem.v"
  end

  initial
  begin
    int i;

  `ifdef HAPS 
    `ifdef CORE_50M    
      $display("PPU(FPGA) Simulation @ 50MHz");
    `endif
    `ifdef CORE_25M    
      $display("PPU(FPGA) Simulation @ 25MHz");
    `endif
  `else 
      $display("PPU(ASIC) Simulation @ 200MHz");
  `endif


    if(!$value$plusargs("MEMLOAD=%s", memload))
      memload = "PRELOAD";

    if(!$value$plusargs("RUNMODE=%s", runmode))
      runmode = "DEPENDENT";

    `ifdef HAPS
      memload = "SPI";
    `endif

    `ifdef SPILOOP
      memload = "PRELOAD";
      $display("spi selfloop testing...");
    `endif

    $display("Using MEMLOAD : %s", memload);
    $display("Using RUNMODE : %s", runmode);

    use_qspi = SPI == "QUAD" ? 1'b1 : 1'b0;

    s_rst_n      = 1'b0;
    fetch_enable = 1'b0;

    #500ns;

    s_rst_n = 1'b1;

    //wait until system rst goes up
    wait(top_i.ppu_top_i.clk_rst_gen_i.rstn_o) 

    //wait(top_i.ppu_top_i.peripherals_i.ahb_subsystem_i.DW_memctl_top.FstTestComplete==1);

    #500ns;
    if (use_qspi)
      spi_enable_qpi();

/*
    if (runmode != "STANDALONE")
    begin
      // Configure JTAG and set boot address
      adv_dbg_if.jtag_reset();
      adv_dbg_if.jtag_softreset();
      adv_dbg_if.init();
//      adv_dbg_if.axi4_write32(32'h1A10_6008, 1, 32'h2600_0000);//memctl not initialized
      adv_dbg_if.axi4_write32(32'h1A10_6008, 1, 32'h1_0000);
    end

    if (memload == "PRELOAD")
    begin
      // preload memories
      mem_preload();
    end
    else
    begin
      //spi_load(use_qspi);
      lpddr_load();
      //spi_check(use_qspi);
      lpddr_check();
    end
*/

   lpddr_load();
   lpddr_check();


    #200ns;
      fetch_enable = 1'b1;

   if(TEST == "DEBUG") begin
      debug_tests();
    end else if (TEST == "MEM_DPI") begin
      mem_dpi(4567);
    end else if (TEST == "ARDUINO_UART") begin
      if (~gpio_out[6])
        wait(gpio_out[6]);
      uart.send_char(8'h65);
    end else if (TEST == "MUX_GPIO") begin
      // Here test for IO mux gpio
      #5ms;
      gpio_in[0]=1'b1;
      gpio_in[1]=1'b1;
      gpio_in[2]=1'b1;
      gpio_in[3]=1'b1;
      gpio_in[4]=1'b1;
      gpio_in[5]=1'b1;
      gpio_in[6]=1'b1;
      #2ms;
      gpio_in[0]=1'b0;
      gpio_in[1]=1'b0;
      gpio_in[2]=1'b0;
      gpio_in[3]=1'b0;
      gpio_in[4]=1'b0;
      gpio_in[5]=1'b0;
      gpio_in[6]=1'b0;
      #2ms;
      gpio_in[0]=1'b1;
      gpio_in[1]=1'b1;
      gpio_in[2]=1'b1;
      gpio_in[3]=1'b1;
      gpio_in[4]=1'b0;
      gpio_in[5]=1'b0;
      gpio_in[6]=1'b0;
      #2ms;
      gpio_in[0]=1'b0;
      gpio_in[1]=1'b0;
      gpio_in[2]=1'b0;
      gpio_in[3]=1'b0;
      gpio_in[4]=1'b1;
      gpio_in[5]=1'b1;
      gpio_in[6]=1'b1;
    end else if (TEST == "ARDUINO_GPIO") begin
      // Here test for GPIO Starts
      #50us;
      gpio_in[4]=1'b1;
      #10us;
      gpio_in[4]=1'b0;
      #10us;
      gpio_in[4]=1'b1;
      gpio_in[6]=1'b1;
    end else if (TEST == "ARDUINO_SHIFT") begin
      if (~gpio_out[6])
        wait(gpio_out[6]);

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
      if (~gpio_out[6])
        wait(gpio_out[6]);
      #50us;
      gpio_in[4]=1'b1;
      #500us;
      gpio_in[4]=1'b0;
      #1ms;
      gpio_in[4]=1'b1;
      #500us;
      gpio_in[4]=1'b0;
    end else if (TEST == "ARDUINO_INT") begin
      if (~gpio_out[6])
        wait(gpio_out[6]);
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


//    #1000000us;

    // end of computation
    if (~gpio_out[0])
      wait(gpio_out[0]);

    spi_check_return_codes(exit_status);

    $fflush();
    $stop();
  end

  // TODO: this is a hack, do it properly!
  `include "tb_spi_pkg.sv"
  `include "tb_lpddr_pkg.sv"
  `include "tb_smic_ram_pkg.sv"
  `include "spi_debug_test.svh"
  `include "mem_dpi.svh"
  `include "pin_map.svh"

endmodule

