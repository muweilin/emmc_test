//
//Mux IO map, should use correctly
//

`define C0_PIN0_SPIMCLK
//`define C0_PIN0_SCL

`define C0_PIN1_SPIMCSN
//`define C0_PIN1_SDA

//`define C0_PIN2_SPIMSDO
//`define C0_PIN2_GPIO0_I
`define C0_PIN2_GPIO0_O

`define C0_PIN3_SPIMSDI
//`define C0_PIN3_GPIO1_I
//`define C0_PIN3_GPIO1_O

//`define C0_PIN4_PWM
`define C0_PIN4_GPIO2_I
//`define C0_PIN4_GPIO2_O

//`define C0_PIN5_PWM
`define C0_PIN5_GPIO3_I
//`define C0_PIN5_GPIO3_O

//`define C0_PIN6_PWM
`define C0_PIN6_GPIO4_I
//`define C0_PIN6_GPIO4_O

//`define C0_PIN7_PWM
`define C0_PIN7_GPIO5_I
//`define C0_PIN7_GPIO5_O


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

