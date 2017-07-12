
(* dont_touch = "yes" *) module fpga_top(

  clk_p,
  clk_n,
  rst_n,

  spi_master_clk_o ,
  spi_master_csn0_o,
  spi_master_sdo0_o,
  spi_master_sdi0_i,
  
 // spi_sck,
 // spi_csn,
 // spi_sdo0,
 // spi_sdi0,

  uart_tx,
  uart_rx,

  scl_io,
  sda_io,
  scl_io1,
  sda_io1,

   ddr3_dq   ,
  ddr3_dqs_n ,
  ddr3_dqs_p ,
  ddr3_addr  ,
  ddr3_ba    ,
  ddr3_ras_n ,
  ddr3_cas_n ,
   ddr3_we_n  ,
  ddr3_reset_n    ,
 ddr3_ck_p   ,
 ddr3_ck_n   ,
  ddr3_cke    ,
 ddr3_cs_n   ,
  ddr3_dm     ,
 ddr3_odt    ,
 
  emmc_cclk_out,     
  emmc_ccmd,         
  emmc_cdata,        
// emmc_card_detect_n, 
/// emmc_card_write_prt,
//  sdio_card_int_n,   
//  mmc_4_4_rst_n;     


  gpio,
//  gpio1,
  pclk,
  vsync,
  href,
  cam_d

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

 // input        spi_sck;
 // output        spi_csn;
 // output        spi_sdo0;
 // input         spi_sdi0;
  //uart
  output        uart_tx;
  input         uart_rx;
  inout  wire    [31:0]     gpio;
  //i2c eeprom
  inout         scl_io;
  inout         sda_io;

  inout         scl_io1;
  inout         sda_io1;
  
   inout  wire    [31:0]     ddr3_dq;
    inout  wire    [3:0]      ddr3_dqs_n;
    inout  wire    [3:0]      ddr3_dqs_p;
    output wire   [14:0]     ddr3_addr;
    output wire   [2:0]      ddr3_ba;
    output wire              ddr3_ras_n;
    output wire              ddr3_cas_n;
    output wire              ddr3_we_n;
    output wire              ddr3_reset_n;
    output wire              ddr3_ck_p;
    output wire              ddr3_ck_n;
    output wire              ddr3_cke;
    output wire              ddr3_cs_n;
    output wire   [3:0]      ddr3_dm;
    output wire              ddr3_odt;
    
   output wire        emmc_cclk_out;
	 inout wire        emmc_ccmd;
	 inout wire   [3: 0]        emmc_cdata;
	 
	output  spi_master_clk_o ;
	output  spi_master_csn0_o;
	output  spi_master_sdo0_o;
	input   spi_master_sdi0_i;
//	input logic  [ 1: 0]      emmc_card_detect_n,
//	input logic  [ 1: 0]      emmc_card_write_prt,
	// input  wire        sdio_card_int_n;
	// output logic [ 1: 0]        mmc_4_4_rst_n;
/*
  inout         gpio0;
  inout         gpio1;
*/
  input         pclk;
  input         vsync;
  input         href;
  input  [7:0]  cam_d;

/*
  //uart
  output        c0_uart_tx;
  input         c0_uart_rx;
  inout         c0_gpio0;
  inout         c0_gpio1;
  inout         c0_gpio2;
  inout         c0_gpio3;
*/

  wire clk;
 // wire [31:0] gpio;
 
  //wire spi_sdi0 ; 
  wire spi_sdi1 ; 
  wire spi_sdi2 ; 
  wire spi_sdi3 ; 
 // wire spi_sdo0 ;
  wire spi_sdo1 ;
  wire spi_sdo2 ;
  wire spi_sdo3 ; 
  
//  assign  gpio0 = gpio[0];
//  wire [15:0] wire_memctl_s_addr;

//  assign memctl_s_addr = wire_memctl_s_addr[13:0];

// IBUFGDS: Differential Global Clock Input Buffer
// 7 Series
// Xilinx HDL Libraries Guide, version 14.5

  // PPU SoC
  
 top  top_i
(
     .sys_clk_p         ( clk_p         ),
     .sys_clk_n         ( clk_n        ),
     .rstn_i            ( rst_n       ),
     .testmode_i        ( 1'b0          ),
     .fetch_enable_i    ( 1'b1  ),

   //SPI Slave
     .spi_clk_i         ( spi_sck       ),
     .spi_cs_i          ( spi_csn       ),
     .spi_sdo0_o        ( spi_sdo0      ),
     .spi_sdo1_o        ( spi_sdo1      ),
     .spi_sdo2_o        ( spi_sdo2      ),
     .spi_sdo3_o        ( spi_sdo3      ),
     .spi_sdi0_i        ( spi_sdi0      ),
     .spi_sdi1_i        ( spi_sdi1      ),
     .spi_sdi2_i        ( spi_sdi2      ),
     .spi_sdi3_i        ( spi_sdi3      ),

    //SPI Master
     .spi_master_clk_o  ( spi_master_clk_o ),
     .spi_master_csn0_o (spi_master_csn0_o  ),
     .spi_master_csn1_o (  ),
     .spi_master_csn2_o (  ),
     .spi_master_csn3_o (  ),
     .spi_master_sdo0_o (spi_master_sdo0_o  ),
     .spi_master_sdo1_o (  ),
     .spi_master_sdo2_o (  ),
     .spi_master_sdo3_o (  ),
     .spi_master_sdi0_i ( spi_master_sdi0_i ),
     .spi_master_sdi1_i (  ),
     .spi_master_sdi2_i (  ),
     .spi_master_sdi3_i (  ),

     .spi_master1_clk_o  (  ),
     .spi_master1_csn0_o ( ),
     .spi_master1_csn1_o (  ),
     .spi_master1_csn2_o (  ),
     .spi_master1_csn3_o (  ),
     .spi_master1_sdo0_o (  ),
     .spi_master1_sdo1_o (  ),
     .spi_master1_sdo2_o (  ),
     .spi_master1_sdo3_o (  ),
     .spi_master1_sdi0_i (),
     .spi_master1_sdi1_i (  ),
     .spi_master1_sdi2_i (  ),
     .spi_master1_sdi3_i (  ),

    //uart
     .uart_tx           ( uart_tx  ),
     .uart_rx           ( uart_rx  ),

     .uart1_tx          ( ),
     .uart1_rx          (  ),

    //I2C
     .scl               ( scl_io ),
     .sda               ( sda_io ),
     .scl1              ( scl_io1  ),
     .sda1              ( sda_io1  ),
    //gpio
     .gpio              ( gpio   ),   
    //pwm
     .pwm_o             (     ),

    //camera
     .cam_pclk          ( pclk  ),
     .cam_vsync         ( vsync ),
     .cam_href          ( href  ),
     .cam_data          ( cam_d ),

     //eMMC
	 .emmc_cclk_out          ( emmc_cclk_out  ),// R16
	 .emmc_ccmd              ( emmc_ccmd  ), //tri R17
	 .emmc_cdata             ( emmc_cdata  ), //tri data0 N13 data1 P15 data2 P20  data3 P16
	 .emmc_card_detect_n     ( 1'b0  ),
	 .emmc_card_write_prt    ( 1'b0  ),
	 .sdio_card_int_n        ( 1'b1  ),//P17
	 .mmc_4_4_rst_n          (   ),

   //ddr3 sdram if
     .ddr3_dq                  (  ddr3_dq     ),
     .ddr3_dqs_n               (  ddr3_dqs_n  ),
     .ddr3_dqs_p               (  ddr3_dqs_p  ),
     .ddr3_addr                (  ddr3_addr   ),
     .ddr3_ba                  (  ddr3_ba      ),
     .ddr3_ras_n               (  ddr3_ras_n  ),
     .ddr3_cas_n               (  ddr3_cas_n  ),
     .ddr3_we_n                (  ddr3_we_n   ),
     .ddr3_reset_n             (  ddr3_reset_n       ),
     .ddr3_ck_p               (  ddr3_ck_p   ),
     .ddr3_ck_n               (  ddr3_ck_n   ),
     .ddr3_cke                 (  ddr3_cke    ),
     .ddr3_cs_n               (  ddr3_cs_n   ),    
     .ddr3_dm                  (  ddr3_dm     ),    
     .ddr3_odt                (  ddr3_odt    ),

     .init_calib_complete    (   ),

     //jtag
     .tck_i              (    ),
     .trstn_i            (    ),
     .tms_i              (    ),
     .tdi_i              (    ),
     .tdo_o              (    ),

///////////////////////////////////////////
////             PPU0                 ////
//////////////////////////////////////////
     .c0_testmode_i     ( 1'b0 ),
     .c0_fetch_enable_i ( 1'b1 ),
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
   

endmodule

