
//PIN0
`ifdef PIN0_UART1TX 
  io_tri 
  pin0_tri
  (
    .i ( ), 
    .o ( uart1_rx ),
    .oe( 1'b0     ),
    .io( pin0     )
  );
`endif

//PIN1
`ifdef PIN1_UART1RX
  io_tri 
  pin1_tri
  (
    .i ( uart1_tx ), 
    .o ( ),
    .oe( 1'b1     ),
    .io( pin1     )
  );
`endif

//PIN2
`ifdef PIN2_GPIO0_I
  io_tri 
  pin2_tri0
  (
    .i ( gpio_in[0] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin2  )
  );
`endif

`ifdef PIN2_GPIO0_O
  io_tri 
  pin2_tri1
  (
    .i ( ), 
    .o ( gpio_out[0]),
    .oe( 1'b0  ),
    .io( pin2  )
  );
`endif

`ifdef PIN2_SPIM1SDO0
  io_tri 
  pin2_tri2
  (
    .i ( ), 
    .o ( spi_master1_sdo0 ),
    .oe( 1'b0  ),
    .io( pin2  )
  );
`endif

//PIN3
`ifdef PIN3_SPIM1CSN0
  io_tri 
  pin3_tri
  (
    .i ( ), 
    .o ( spi_master1_csn0 ),
    .oe( 1'b0  ),
    .io( pin3  )
  );
`endif

`ifdef PIN3_GPIO1_I
  io_tri 
  pin3_tri0
  (
    .i ( gpio_in[1] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin3  )
  );
`endif

`ifdef PIN3_GPIO1_O
  io_tri 
  pin3_tri1
  (
    .i ( ), 
    .o ( gpio_out[1]),
    .oe( 1'b0  ),
    .io( pin3  )
  );
`endif


//PIN4
`ifdef PIN4_SPIM1SDI0
  io_tri 
  pin4_tri0
  (
    .i ( spi_master1_sdi0 ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin4  )
  );
`endif

`ifdef PIN4_VSYNC
  io_tri 
  pin4_tri1
  (
    .i ( cam_vsync ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin4  )
  );
`endif


//PIN5
`ifdef PIN5_PWM
  io_tri 
  pin5_tri0
  (
    .i ( ), 
    .o ( pwm[0]),
    .oe( 1'b0  ),
    .io( pin5 )
  );
`endif

`ifdef PIN5_HREF
  io_tri 
  pin5_tri1
  (
    .i ( cam_href ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin5  )
  );
`endif

//PIN6
`ifdef PIN6_PWM
  io_tri 
  pin6_tri0
  (
    .i ( ), 
    .o ( pwm[1]),
    .oe( 1'b0  ),
    .io( pin6 )
  );
`endif

`ifdef PIN6_CAMD7
  io_tri 
  pin6_tri1
  (
    .i ( cam_data[7] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin6  )
  );
`endif

//PIN7
`ifdef PIN7_PWM
  io_tri 
  pin7_tri0
  (
    .i ( ), 
    .o ( pwm[2]),
    .oe( 1'b0  ),
    .io( pin7 )
  );
`endif

`ifdef PIN7_CAMD6
  io_tri 
  pin7_tri1
  (
    .i ( cam_data[6] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin7  )
  );
`endif

//PIN8
`ifdef PIN8_PWM
  io_tri 
  pin8_tri0
  (
    .i ( ), 
    .o ( pwm[3]),
    .oe( 1'b0  ),
    .io( pin8 )
  );
`endif

`ifdef PIN8_CAMD5
  io_tri 
  pin8_tri1
  (
    .i ( cam_data[5] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin8  )
  );
`endif

//PIN9
`ifdef PIN9_CAMD4
  io_tri 
  pin9_tri0
  (
    .i ( cam_data[4] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin9 )
  );
`endif

`ifdef PIN9_GPIO2_I
  io_tri 
  pin9_tri1
  (
    .i ( gpio_in[2] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin9 )
  );
`endif

`ifdef PIN9_GPIO2_O
  io_tri 
  pin9_tri2
  (
    .i ( ), 
    .o ( gpio_out[2]),
    .oe( 1'b0  ),
    .io( pin9 )
  );
`endif

//PIN10
`ifdef PIN10_CAMD3
  io_tri 
  pin10_tri0
  (
    .i ( cam_data[3] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin10 )
  );
`endif

`ifdef PIN10_GPIO3_I
  io_tri 
  pin10_tri1
  (
    .i ( gpio_in[3] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin10 )
  );
`endif

`ifdef PIN10_GPIO3_O
  io_tri 
  pin10_tri2
  (
    .i ( ), 
    .o ( gpio_out[3]),
    .oe( 1'b0  ),
    .io( pin10 )
  );
`endif

//PIN11
`ifdef PIN11_CAMD2
  io_tri 
  pin11_tri0
  (
    .i ( cam_data[2] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin11 )
  );
`endif

`ifdef PIN11_GPIO4_I
  io_tri 
  pin11_tri1
  (
    .i ( gpio_in[4] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin11 )
  );
`endif

`ifdef PIN11_GPIO4_O
  io_tri 
  pin11_tri2
  (
    .i ( ), 
    .o ( gpio_out[4]),
    .oe( 1'b0  ),
    .io( pin11 )
  );
`endif

//PIN12
`ifdef PIN12_CAMD1
  io_tri 
  pin12_tri0
  (
    .i ( cam_data[1] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin12 )
  );
`endif

`ifdef PIN12_GPIO5_I
  io_tri 
  pin12_tri1
  (
    .i ( gpio_in[5] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin12 )
  );
`endif

`ifdef PIN12_GPIO5_O
  io_tri 
  pin12_tri2
  (
    .i ( ), 
    .o ( gpio_out[5]),
    .oe( 1'b0  ),
    .io( pin12 )
  );
`endif

//PIN13
`ifdef PIN13_CAMD0
  io_tri 
  pin13_tri0
  (
    .i ( cam_data[0] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin13 )
  );
`endif

`ifdef PIN13_GPIO6_I
  io_tri 
  pin13_tri1
  (
    .i ( gpio_in[6] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( pin13 )
  );
`endif

`ifdef PIN13_GPIO6_O
  io_tri 
  pin13_tri2
  (
    .i ( ), 
    .o ( gpio_out[6]),
    .oe( 1'b0  ),
    .io( pin13 )
  );
`endif

