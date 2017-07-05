
`ifdef C0_PIN0_SPIMCLK
  io_tri 
  c0_pin0_tri
  (
    .i ( ), 
    .o ( spi_master_clk ),
    .oe( 1'b0  ),
    .io( c0_pin0  )
  );
`endif

`ifdef C0_PIN1_SPIMCSN
  io_tri 
  c0_pin1_tri
  (
    .i ( ), 
    .o ( spi_master_csn0 ),
    .oe( 1'b0  ),
    .io( c0_pin1  )
  );
`endif

`ifdef C0_PIN2_SPIMSDO
  io_tri 
  c0_pin2_tri0
  (
    .i ( ), 
    .o ( spi_master_sdo0 ),
    .oe( 1'b0  ),
    .io( c0_pin2  )
  );
`endif

`ifdef C0_PIN2_GPIO0_I
  io_tri 
  c0_pin2_tri1
  (
    .i ( gpio_in[0] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( c0_pin2  )
  );
`endif

`ifdef C0_PIN2_GPIO0_O
  io_tri 
  c0_pin2_tri2
  (
    .i ( ), 
    .o ( gpio_out[0]),
    .oe( 1'b0  ),
    .io( c0_pin2  )
  );
`endif

`ifdef C0_PIN3_SPIMSDI
  io_tri 
  c0_pin3_tri0
  (
    .i ( spi_master_sdi0 ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( c0_pin3  )
  );
`endif

`ifdef C0_PIN3_GPIO1_I
  io_tri 
  c0_pin3_tri1
  (
    .i ( gpio_in[1] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( c0_pin3  )
  );
`endif

`ifdef C0_PIN3_GPIO1_O
  io_tri 
  c0_pin3_tri2
  (
    .i ( ), 
    .o ( gpio_out[1]),
    .oe( 1'b0  ),
    .io( c0_pin3  )
  );
`endif


`ifdef C0_PIN4_PWM
  io_tri 
  c0_pin4_tri0
  (
    .i ( ), 
    .o ( pwm[0]),
    .oe( 1'b0     ),
    .io( c0_pin4  )
  );
`endif

`ifdef C0_PIN4_GPIO2_I
  io_tri 
  c0_pin4_tri1
  (
    .i ( gpio_in[2] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( c0_pin4  )
  );
`endif

`ifdef C0_PIN4_GPIO2_O
  io_tri 
  c0_pin4_tri2
  (
    .i ( ), 
    .o ( gpio_out[2]),
    .oe( 1'b0  ),
    .io( c0_pin4  )
  );
`endif

`ifdef C0_PIN5_PWM 
  io_tri 
  c0_pin5_tri0
  (
    .i ( ), 
    .o ( pwm[1]),
    .oe( 1'b0     ),
    .io( c0_pin5  )
  );
`endif

`ifdef C0_PIN5_GPIO3_I
  io_tri 
  c0_pin5_tri1
  (
    .i ( gpio_in[3] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( c0_pin5  )
  );
`endif

`ifdef C0_PIN5_GPIO3_O
  io_tri 
  c0_pin5_tri2
  (
    .i ( ), 
    .o ( gpio_out[3]),
    .oe( 1'b0  ),
    .io( c0_pin5  )
  );
`endif

`ifdef C0_PIN6_PWM 
  io_tri 
  c0_pin6_tri0
  (
    .i ( ), 
    .o ( pwm[2]),
    .oe( 1'b0     ),
    .io( c0_pin6  )
  );
`endif

`ifdef C0_PIN6_GPIO4_I
  io_tri 
  c0_pin6_tri1
  (
    .i ( gpio_in[4] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( c0_pin6  )
  );
`endif

`ifdef C0_PIN6_GPIO4_O
  io_tri 
  c0_pin6_tri2
  (
    .i ( ), 
    .o ( gpio_out[4]),
    .oe( 1'b0  ),
    .io( c0_pin6  )
  );
`endif

`ifdef C0_PIN7_PWM
  io_tri 
  c0_pin7_tri0
  (
    .i ( ), 
    .o ( pwm[3]),
    .oe( 1'b0     ),
    .io( c0_pin7  )
  );
`endif

`ifdef C0_PIN7_GPIO5_I
  io_tri 
  c0_pin7_tri1
  (
    .i ( gpio_in[5] ), 
    .o ( ),
    .oe( 1'b1  ),
    .io( c0_pin7  )
  );
`endif

`ifdef C0_PIN7_GPIO5_O
  io_tri 
  c0_pin7_tri2
  (
    .i ( ), 
    .o ( gpio_out[5]),
    .oe( 1'b0  ),
    .io( c0_pin7  )
  );
`endif


