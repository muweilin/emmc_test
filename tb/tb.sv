`include "config.sv"
`include "tb_jtag_pkg.sv"
`include "ddr3_sim_parameters.vh"
`include "wiredly.v"
`include "tb_camera_pkg.sv"

`define CLK_PERIOD  5.00ns // 200 MHz: input for Xilinx MIG/MMCL.

`define CAM_CLK_PERIOD  40.00ns // 25 MHz camera clock


//`define BAUDRATE   93750  //ppu  83.333Mhz
//`define BAUDRATE   62500  //ppu0 50MHz
`define BAUDRATE   62500  //ppu 100MHz

`define EXIT_SUCCESS  0
`define EXIT_FAIL     1
`define EXIT_ERROR   -1


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

logic [31:0]          ddr_datarb;

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

  tri1          scl_io;
  tri1          sda_io;

  logic [31:0]  recv_data;

  logic         cam_pclk   = 1'b0;
  logic         cam_vsync;
  logic         cam_href;
  logic [7:0]   cam_data;

  logic [3:0]   pwm;

  wire  [31:0]  gpio;
  

  //**************************************************************************//
  // Memory Models instantiations: Adopted from Xilinx MIG
  //**************************************************************************//

  wire                      ddr3_reset_n;
  wire [DQ_WIDTH-1:0]       ddr3_dq_fpga;
  wire [DQS_WIDTH-1:0]      ddr3_dqs_p_fpga;
  wire [DQS_WIDTH-1:0]      ddr3_dqs_n_fpga;
  wire [ROW_WIDTH-1:0]      ddr3_addr_fpga;
  wire [3-1:0]              ddr3_ba_fpga;
  wire                      ddr3_ras_n_fpga;
  wire                      ddr3_cas_n_fpga;
  wire                      ddr3_we_n_fpga;
  wire [1-1:0]              ddr3_cke_fpga;
  wire [1-1:0]              ddr3_ck_p_fpga;
  wire [1-1:0]              ddr3_ck_n_fpga;
  wire [(CS_WIDTH*1)-1:0]   ddr3_cs_n_fpga;    
  wire [DM_WIDTH-1:0]       ddr3_dm_fpga;
  wire [ODT_WIDTH-1:0]      ddr3_odt_fpga;
  
  wire                      init_calib_complete;

  reg [(CS_WIDTH*1)-1:0]    ddr3_cs_n_sdram_tmp;
  reg [DM_WIDTH-1:0]        ddr3_dm_sdram_tmp;
  reg [ODT_WIDTH-1:0]       ddr3_odt_sdram_tmp;
    
  wire [DQ_WIDTH-1:0]       ddr3_dq_sdram;
  reg [ROW_WIDTH-1:0]       ddr3_addr_sdram [0:1];
  reg [3-1:0]               ddr3_ba_sdram [0:1];
  reg                       ddr3_ras_n_sdram;
  reg                       ddr3_cas_n_sdram;
  reg                       ddr3_we_n_sdram;
  wire [(CS_WIDTH*1)-1:0]   ddr3_cs_n_sdram;
  wire [ODT_WIDTH-1:0]      ddr3_odt_sdram;
  reg [1-1:0]               ddr3_cke_sdram;
  wire [DM_WIDTH-1:0]       ddr3_dm_sdram;
  wire [DQS_WIDTH-1:0]      ddr3_dqs_p_sdram;
  wire [DQS_WIDTH-1:0]      ddr3_dqs_n_sdram;
  reg [1-1:0]               ddr3_ck_p_sdram;
  reg [1-1:0]               ddr3_ck_n_sdram;


  // Wire Delay
  always @( * ) begin
    ddr3_ck_p_sdram      <=  #(TPROP_PCB_CTRL) ddr3_ck_p_fpga;
    ddr3_ck_n_sdram      <=  #(TPROP_PCB_CTRL) ddr3_ck_n_fpga;
    ddr3_addr_sdram[0]   <=  #(TPROP_PCB_CTRL) ddr3_addr_fpga;
    ddr3_addr_sdram[1]   <=  #(TPROP_PCB_CTRL) (CA_MIRROR == "ON") ?
                                                 {ddr3_addr_fpga[ROW_WIDTH-1:9],
                                                  ddr3_addr_fpga[7], ddr3_addr_fpga[8],
                                                  ddr3_addr_fpga[5], ddr3_addr_fpga[6],
                                                  ddr3_addr_fpga[3], ddr3_addr_fpga[4],
                                                  ddr3_addr_fpga[2:0]} :
                                                 ddr3_addr_fpga;
    ddr3_ba_sdram[0]     <=  #(TPROP_PCB_CTRL) ddr3_ba_fpga;
    ddr3_ba_sdram[1]     <=  #(TPROP_PCB_CTRL) (CA_MIRROR == "ON") ?
                                                 {ddr3_ba_fpga[3-1:2],
                                                  ddr3_ba_fpga[0],
                                                  ddr3_ba_fpga[1]} :
                                                 ddr3_ba_fpga;
    ddr3_ras_n_sdram     <=  #(TPROP_PCB_CTRL) ddr3_ras_n_fpga;
    ddr3_cas_n_sdram     <=  #(TPROP_PCB_CTRL) ddr3_cas_n_fpga;
    ddr3_we_n_sdram      <=  #(TPROP_PCB_CTRL) ddr3_we_n_fpga;
    ddr3_cke_sdram       <=  #(TPROP_PCB_CTRL) ddr3_cke_fpga;
  end
    

  always @( * )
    ddr3_cs_n_sdram_tmp   <=  #(TPROP_PCB_CTRL) ddr3_cs_n_fpga;
  assign ddr3_cs_n_sdram =  ddr3_cs_n_sdram_tmp;

  always @( * )
    ddr3_dm_sdram_tmp <=  #(TPROP_PCB_DATA) ddr3_dm_fpga;//DM signal generation
  assign ddr3_dm_sdram = ddr3_dm_sdram_tmp;

  always @( * )
    ddr3_odt_sdram_tmp  <=  #(TPROP_PCB_CTRL) ddr3_odt_fpga;
  assign ddr3_odt_sdram =  ddr3_odt_sdram_tmp;
    

// Controlling the bi-directional BUS

  genvar dqwd;
  generate
    for (dqwd = 1;dqwd < DQ_WIDTH;dqwd = dqwd+1) begin : dq_delay
      WireDelay #
       (
        .Delay_g    (TPROP_PCB_DATA),
        .Delay_rd   (TPROP_PCB_DATA_RD),
        .ERR_INSERT ("OFF")
       )
      u_delay_dq
       (
        .A             (ddr3_dq_fpga[dqwd]),
        .B             (ddr3_dq_sdram[dqwd]),
        .reset         (s_rst_n),
        .phy_init_done (init_calib_complete)
       );
    end
    // For ECC ON case error is inserted on LSB bit from DRAM to FPGA
     WireDelay #
       (
        .Delay_g    (TPROP_PCB_DATA),
        .Delay_rd   (TPROP_PCB_DATA_RD),
        .ERR_INSERT (ERR_INSERT)
       )
      u_delay_dq_0
       (
        .A             (ddr3_dq_fpga[0]),
        .B             (ddr3_dq_sdram[0]),
        .reset         (s_rst_n),
        .phy_init_done (init_calib_complete)
       );
  endgenerate

  genvar dqswd;
  generate
    for (dqswd = 0;dqswd < DQS_WIDTH;dqswd = dqswd+1) begin : dqs_delay
      WireDelay #
       (
        .Delay_g    (TPROP_DQS),
        .Delay_rd   (TPROP_DQS_RD),
        .ERR_INSERT ("OFF")
       )
      u_delay_dqs_p
       (
        .A             (ddr3_dqs_p_fpga[dqswd]),
        .B             (ddr3_dqs_p_sdram[dqswd]),
        .reset         (s_rst_n),
        .phy_init_done (init_calib_complete)
       );

      WireDelay #
       (
        .Delay_g    (TPROP_DQS),
        .Delay_rd   (TPROP_DQS_RD),
        .ERR_INSERT ("OFF")
       )
      u_delay_dqs_n
       (
        .A             (ddr3_dqs_n_fpga[dqswd]),
        .B             (ddr3_dqs_n_sdram[dqswd]),
        .reset         (s_rst_n),
        .phy_init_done (init_calib_complete)
       );
    end
  endgenerate
  //wire delay end
/*
/* general case
/*
  genvar r,i;
  generate
    for (r = 0; r < CS_WIDTH; r = r + 1) begin: mem_rnk
      if(DQ_WIDTH/16) begin: mem
        for (i = 0; i < NUM_COMP; i = i + 1) begin: gen_mem
          ddr3_model u_comp_ddr3
            (
             .rst_n   (ddr3_reset_n),
             .ck      (ddr3_ck_p_sdram),
             .ck_n    (ddr3_ck_n_sdram),
             .cke     (ddr3_cke_sdram[r]),
             .cs_n    (ddr3_cs_n_sdram[r]),
             .ras_n   (ddr3_ras_n_sdram),
             .cas_n   (ddr3_cas_n_sdram),
             .we_n    (ddr3_we_n_sdram),
             .dm_tdqs (ddr3_dm_sdram[(2*(i+1)-1):(2*i)]),
             .ba      (ddr3_ba_sdram[r]),
             .addr    (ddr3_addr_sdram[r]),
             .dq      (ddr3_dq_sdram[16*(i+1)-1:16*(i)]),
             .dqs     (ddr3_dqs_p_sdram[(2*(i+1)-1):(2*i)]),
             .dqs_n   (ddr3_dqs_n_sdram[(2*(i+1)-1):(2*i)]),
             .tdqs_n  (),
             .odt     (ddr3_odt_sdram[r])
             );
        end
      end
      if (DQ_WIDTH%16) begin: gen_mem_extrabits
        ddr3_model u_comp_ddr3
          (
           .rst_n   (ddr3_reset_n),
           .ck      (ddr3_ck_p_sdram),
           .ck_n    (ddr3_ck_n_sdram),
           .cke     (ddr3_cke_sdram[r]),
           .cs_n    (ddr3_cs_n_sdram[r]),
           .ras_n   (ddr3_ras_n_sdram),
           .cas_n   (ddr3_cas_n_sdram),
           .we_n    (ddr3_we_n_sdram),
           .dm_tdqs ({ddr3_dm_sdram[DM_WIDTH-1],ddr3_dm_sdram[DM_WIDTH-1]}),
           .ba      (ddr3_ba_sdram[r]),
           .addr    (ddr3_addr_sdram[r]),
           .dq      ({ddr3_dq_sdram[DQ_WIDTH-1:(DQ_WIDTH-8)],
                      ddr3_dq_sdram[DQ_WIDTH-1:(DQ_WIDTH-8)]}),
           .dqs     ({ddr3_dqs_p_sdram[DQS_WIDTH-1],
                      ddr3_dqs_p_sdram[DQS_WIDTH-1]}),
           .dqs_n   ({ddr3_dqs_n_sdram[DQS_WIDTH-1],
                      ddr3_dqs_n_sdram[DQS_WIDTH-1]}),
           .tdqs_n  (),
           .odt     (ddr3_odt_sdram[r])
           );
      end
    end
  endgenerate
*/

          ddr3_model ddr3_l
            (
             .rst_n   (ddr3_reset_n          ),
             .ck      (ddr3_ck_p_sdram       ),
             .ck_n    (ddr3_ck_n_sdram       ),
             .cke     (ddr3_cke_sdram[0]     ),
             .cs_n    (ddr3_cs_n_sdram[0]    ),
             .ras_n   (ddr3_ras_n_sdram      ),
             .cas_n   (ddr3_cas_n_sdram      ),
             .we_n    (ddr3_we_n_sdram       ),
             .dm_tdqs (ddr3_dm_sdram[1:0]    ),
             .ba      (ddr3_ba_sdram[0]      ),
             .addr    (ddr3_addr_sdram[0]    ),
             .dq      (ddr3_dq_sdram[15:0]   ),
             .dqs     (ddr3_dqs_p_sdram[1:0] ),
             .dqs_n   (ddr3_dqs_n_sdram[1:0] ),
             .tdqs_n  (),
             .odt     (ddr3_odt_sdram[0])
             );

          ddr3_model ddr3_u
            (
             .rst_n   (ddr3_reset_n          ),
             .ck      (ddr3_ck_p_sdram       ),
             .ck_n    (ddr3_ck_n_sdram       ),
             .cke     (ddr3_cke_sdram[0]     ),
             .cs_n    (ddr3_cs_n_sdram[0]    ),
             .ras_n   (ddr3_ras_n_sdram      ),
             .cas_n   (ddr3_cas_n_sdram      ),
             .we_n    (ddr3_we_n_sdram       ),
             .dm_tdqs (ddr3_dm_sdram[3:2]    ),
             .ba      (ddr3_ba_sdram[0]      ),
             .addr    (ddr3_addr_sdram[0]    ),
             .dq      (ddr3_dq_sdram[31:16]  ),
             .dqs     (ddr3_dqs_p_sdram[3:2] ),
             .dqs_n   (ddr3_dqs_n_sdram[3:2] ),
             .tdqs_n  (),
             .odt     (ddr3_odt_sdram[0])
             );


  //**************************************************************************//
  // Memory Models instantiations: END
  //**************************************************************************//


  //**************************************************************************//
  // JTAG Model instantiations
  //**************************************************************************//

  jtag_i jtag_if();

  adv_dbg_if_t adv_dbg_if = new(jtag_if);

  //**************************************************************************//
  // Camera Model instantiations
  //**************************************************************************//

  camera_emu camera_emu_i
  (
    .cam_pclk   ( cam_pclk  ),
    .cam_rstn   ( s_rst_n   ),
    .cam_vsync  ( cam_vsync ),
    .cam_href   ( cam_href  ),
    .cam_data   ( cam_data  )
  );

  //**************************************************************************//
  // UART Model instantiations
  //**************************************************************************//

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

  //**************************************************************************//
  // SPI Master Model instantiations
  //**************************************************************************//

  spi_slave
  spi_master();

  //**************************************************************************//
  // I2C EEPROM Model instantiations
  //**************************************************************************//

  i2c_eeprom_model
  #(
    .ADDRESS ( 7'b1010_000 )
  )
  i2c_eeprom_model_i
  (
    .scl_io ( scl1_io  ),

    .sda_io ( sda1_io  ),
    .rst_ni ( s_rst_n )
  );

  //**************************************************************************//
  // SPI Flash Model instantiations
  //**************************************************************************//

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

 //**************************************************************************//
  // SoC instantiations
  //**************************************************************************//

 top  top_tb
(
     .sys_clk_p         ( s_clk         ),
     .sys_clk_n         ( ~s_clk        ),
     .rstn_i            ( s_rst_n       ),
     .testmode_i        ( 1'b0          ),
     .fetch_enable_i    ( fetch_enable  ),

   //SPI Slave
     .spi_clk_i         ( spi_sck       ),
     .spi_cs_i          ( spi_csn       ),
     .spi_sdo0_o        ( spi_sdi0      ),
     .spi_sdo1_o        ( spi_sdi1      ),
     .spi_sdo2_o        ( spi_sdi2      ),
     .spi_sdo3_o        ( spi_sdi3      ),
     .spi_sdi0_i        ( spi_sdo0      ),
     .spi_sdi1_i        ( spi_sdo1      ),
     .spi_sdi2_i        ( spi_sdo2      ),
     .spi_sdi3_i        ( spi_sdo3      ),

    //SPI Master
     .spi_master_clk_o  ( spi_master.clk     ),
     .spi_master_csn0_o ( spi_master.csn     ),
     .spi_master_csn1_o (  ),
     .spi_master_csn2_o (  ),
     .spi_master_csn3_o (  ),
     .spi_master_sdo0_o ( spi_master.sdo[0]  ),
     .spi_master_sdo1_o (  ),
     .spi_master_sdo2_o (  ),
     .spi_master_sdo3_o (  ),
     .spi_master_sdi0_i ( spi_master.sdi[0]  ),
     .spi_master_sdi1_i (  ),
     .spi_master_sdi2_i (  ),
     .spi_master_sdi3_i (  ),

     .spi_master1_clk_o  ( spi_master1_clk ),
     .spi_master1_csn0_o ( spi_master1_csn0 ),
     .spi_master1_csn1_o (  ),
     .spi_master1_csn2_o (  ),
     .spi_master1_csn3_o (  ),
     .spi_master1_sdo0_o ( spi_master1_sdo0 ),
     .spi_master1_sdo1_o (  ),
     .spi_master1_sdo2_o (  ),
     .spi_master1_sdo3_o (  ),
     .spi_master1_sdi0_i ( spi_master1_sdi0 ),
     .spi_master1_sdi1_i (  ),
     .spi_master1_sdi2_i (  ),
     .spi_master1_sdi3_i (  ),

    //uart
     .uart_tx           ( uart_rx  ),
     .uart_rx           ( uart_tx  ),

     .uart1_tx          ( uart1_rx ),
     .uart1_rx          ( uart1_tx ),

    //I2C
     .scl               ( scl_io ),
     .sda               ( sda_io ),
     .scl1              ( scl1_io ),
     .sda1              ( sda1_io ),
    //gpio
     .gpio              ( gpio   ),   
    //pwm
     .pwm_o             ( pwm    ),

    //camera
     .cam_pclk          ( cam_pclk  ),
     .cam_vsync         ( cam_vsync ),
     .cam_href          ( cam_href  ),
     .cam_data          ( cam_data  ),

     //eMMC
	 .emmc_cclk_out          (   ),
	 .emmc_ccmd              (   ), //tri
	 .emmc_cdata             (   ), //tri
	 .emmc_card_detect_n     (   ),
	 .emmc_card_write_prt    (   ),
	 .sdio_card_int_n        (   ),
	 .mmc_4_4_rst_n          (   ),

   //ddr3 sdram if
     .ddr3_dq                (  ddr3_dq_fpga     ),
     .ddr3_dqs_n             (  ddr3_dqs_n_fpga  ),
     .ddr3_dqs_p             (  ddr3_dqs_p_fpga  ),
     .ddr3_addr              (  ddr3_addr_fpga   ),
     .ddr3_ba                (  ddr3_ba_fpga     ),
     .ddr3_ras_n             (  ddr3_ras_n_fpga  ),
     .ddr3_cas_n             (  ddr3_cas_n_fpga  ),
     .ddr3_we_n              (  ddr3_we_n_fpga   ),
     .ddr3_reset_n           (  ddr3_reset_n     ),
     .ddr3_ck_p              (  ddr3_ck_p_fpga   ),
     .ddr3_ck_n              (  ddr3_ck_n_fpga   ),
     .ddr3_cke               (  ddr3_cke_fpga    ),
     .ddr3_cs_n              (  ddr3_cs_n_fpga   ),
    
     .ddr3_dm                (  ddr3_dm_fpga     ),
    
     .ddr3_odt               (  ddr3_odt_fpga    ),

     .init_calib_complete    (  init_calib_complete ),

     //jtag
     .tck_i             ( jtag_if.tck     ),
     .trstn_i           ( jtag_if.trstn   ),
     .tms_i             ( jtag_if.tms     ),
     .tdi_i             ( jtag_if.tdi     ),
     .tdo_o             ( jtag_if.tdo     ),

///////////////////////////////////////////
////             PPU0                 ////
//////////////////////////////////////////
     .c0_testmode_i     ( 1'b0 ),
     .c0_fetch_enable_i ( 1'b0 ),
   //SPI Slave
     .c0_spi_clk_i      (  ),
     .c0_spi_cs_i       (  ),
     .c0_spi_sdo0_o     (  ),
     .c0_spi_sdo1_o     (  ),
     .c0_spi_sdo2_o     (  ),
     .c0_spi_sdo3_o     (  ),
     .c0_spi_sdi0_i     (  ),
     .c0_spi_sdi1_i     (  ),
     .c0_spi_sdi2_i     (  ),
     .c0_spi_sdi3_i     (  ),

    //SPI Master
     .c0_spim_clk_o      (  ),
     .c0_spim_csn0_o     (  ),
     .c0_spim_csn1_o     (  ),
     .c0_spim_csn2_o     (  ),
     .c0_spim_csn3_o     (  ),
     .c0_spim_sdo0_o     (  ),
     .c0_spim_sdo1_o     (  ),
     .c0_spim_sdo2_o     (  ),
     .c0_spim_sdo3_o     (  ),
     .c0_spim_sdi0_i     (  ),
     .c0_spim_sdi1_i     (  ),
     .c0_spim_sdi2_i     (  ),
     .c0_spim_sdi3_i     (  ),

     .c0_uart_tx     (  ),
     .c0_uart_rx     (  ),

     .c0_scl       (  ),
     .c0_sda       (  ),
     .c0_gpio      (  ),

     .c0_pwm_o     (  ),
    //jtag
     .c0_tck_i     (  ),
     .c0_trstn_i   (  ),
     .c0_tms_i     (  ),
     .c0_tdi_i     (  ),
     .c0_tdo_o     (  )
   );


//  AXI_slave_monitor AXI_slave_monitor_i();

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

    $display("PPU(FPGA) Simulation @ 100MHz");

    if(!$value$plusargs("MEMLOAD=%s", memload))
      memload = "PRELOAD";

    if(!$value$plusargs("RUNMODE=%s", runmode))
      runmode = "DEPENDENT";

    $display("Using MEMLOAD : %s", memload);
    $display("Using RUNMODE : %s", runmode);

    use_qspi = SPI == "QUAD" ? 1'b1 : 1'b0;

    s_rst_n      = 1'b0;
    fetch_enable = 1'b0;

    #RESET_PERIOD

    s_rst_n = 1'b1;

    //wait until memctl init done
    wait(init_calib_complete) 
    $display("DDR3 INIT DONE");

    #500ns;
    if (use_qspi)
      spi_enable_qpi();

   ddr3_load();
   ddr3_check();


   #200ns;
     $display("Load complete. Enable fetch");
     fetch_enable = 1'b1;
/*
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
*/


    #1000000us;
/*
    // end of computation
    if (~gpio_out[0])
      wait(gpio_out[0]);

    spi_check_return_codes(exit_status);
*/
    $fflush();
    $stop();
  end

  // TODO: this is a hack, do it properly!
  `include "tb_spi_pkg.sv"
  `include "tb_ddr3_pkg.sv"
  `include "tb_smic_ram_pkg.sv"
  `include "spi_debug_test.svh"
  `include "mem_dpi.svh"

endmodule

