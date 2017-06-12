//
//Mux IO map, should use correctly
//
`define PIN0_SCL
//`define PIN0_UART1TX

`define PIN1_SDA
//`define PIN1_UART1RX

//`define PIN2_SPIM1SDO0
//`define PIN2_GPIO0_I
`define PIN2_GPIO0_O

//`define PIN3_SPIM1CSN0
//`define PIN3_GPIO1_I
`define PIN3_GPIO1_O

//`define PIN4_SPIM1SDI0
`define PIN4_VSYNC

//`define PIN5_PWM
`define PIN5_HREF

//`define PIN6_PWM
`define PIN6_CAMD7

//`define PIN7_PWM
`define PIN7_CAMD6

//`define PIN8_PWM
`define PIN8_CAMD5

//`define PIN9_GPIO2_I
//`define PIN9_GPIO2_O
`define PIN9_CAMD4

//`define PIN10_GPIO3_I
//`define PIN10_GPIO3_O
`define PIN10_CAMD3

//`define PIN11_GPIO4_I
//`define PIN11_GPIO4_O
`define PIN11_CAMD2

//`define PIN12_GPIO5_I
//`define PIN12_GPIO5_O
`define PIN12_CAMD1

//`define PIN13_GPIO6_I
//`define PIN13_GPIO6_O
`define PIN13_CAMD0

module io_tri
(
   input  logic i,
   output logic o,
   input  logic oe,
   inout  logic io
);

   assign io = oe ? i : 1'bZ;
   assign o  = io;

endmodule

