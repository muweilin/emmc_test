
`include "config.sv"

(* dont_touch = "yes"*) module clk_rst_gen
(
    input  logic                            clk_i,

    input  logic                            rstn_i,
    input  logic                            lock_i,

    input  logic                            testmode_i,

    output logic                            clk_o,
    output logic                            clk2x_o,

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


endmodule
