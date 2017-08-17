
`include "config.sv"

(* dont_touch = "yes"*) module clk_rst_gen
(
    input  logic                            clk_i,

    input  logic                            rstn_i,
    input  logic                            lock_i,

    input  logic                            testmode_i,

    output logic                            clk_o,
    output logic                            clk2x_o,
   // output logic                            clk_div2,

    output logic                            rstn_o
);


  assign clk2x_o = clk_i;

  xilinx_clock_manager xilinx_clock_manager_inst
   (
   // Clock in ports
    .clk100_i(clk_i),      // input clk100_i
    // Clock out ports
    .clk50_o(clk_o),     // output clk50_o
    // Status and control signals
    .rstn_i(rstn_i), // input rstn_i
    .locked(locked));      // output locked

  //----------------------------------------------------------------------------//
  // Reset synchronizer
  //----------------------------------------------------------------------------//
  rstgen_lock i_rst_gen_ppu
  (
      // PAD FRAME SIGNALS
      .clk_i               ( clk_o           ),
      .rst_ni              ( rstn_i          ),
      .lock                ( locked          ),

      // TEST MODE
      .test_mode_i         ( testmode_i      ),

      // OUTPUT RESET
      .rst_no              ( rstn_o          )
  );

//xilinx_clock_div2 xilinx_clock_div2_i
//   (
   // Clock in ports
//    .clk50_i(clk_o),      // input clk50_i
    // Clock out ports
//    .clk5_o(clk_div2),     // output clk5_o
    // Status and control signals
//    .rstn_i(rstn_i), // input rstn_i
//    .locked(locked2));      // output locked
//clk_div2 clk_divider_u( 
//   .clk(clk_o),
//   .rst_n(rstn_o), 
//   .clk_out(clk_div2)
//);

endmodule
