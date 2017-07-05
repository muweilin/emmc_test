
`include "config.sv"

module clk_rst_gen0
(
    input  logic                            clk_i,
    input  logic                            rstn_i,
    input  logic                            lock_i,

    input  logic                            testmode_i,

    output logic                            clk_o,
    output logic                            rstn_o
);

   assign clk_o = clk_i;

  //----------------------------------------------------------------------------//
  // Reset synchronizer
  //----------------------------------------------------------------------------//
  rstgen_lock i_rst_gen_ppu0
  (
      // PAD FRAME SIGNALS
      .clk_i               ( clk_i           ),
      .rst_ni              ( rstn_i          ),
      .lock                ( lock_i          ),

      // TEST MODE
      .test_mode_i         ( testmode_i      ),

      // OUTPUT RESET
      .rst_no              ( rstn_o          )
  );


endmodule
