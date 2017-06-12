
`include "config.sv"
//******************************************************************//
//                    _________
//             ----->|__div2__|---> clk_o
//            |    
//----clk_i---|------------------> clk2x_0
//            |    ____________
//            |---|_prescalar_|--> clk_div_o
//
//*****************************************************************//

(* dont_touch = "yes"*) module clk_rst_gen
(
    input  logic                            clk_i,

`ifdef HAPS
    input  logic                            clk2x_i, //200MHz, clk_i = 100Mhz
`endif

    input  logic                            rstn_i,
    input  logic                            lock_i,

    input  logic                            testmode_i,
    input  logic                            pll_bps_i,

    output logic                            clk_o,
    output logic                            clk2x_o,

`ifdef HAPS
    output logic                            clk4x_o,
`endif

    output logic                            rstn_o

//    input  logic [1:0]                      div_i, 
//    output logic                            clk_div_o
);

`ifdef HAPS
  assign clk4x_o = clk2x_i;
`endif

  assign clk2x_o = clk_i;

  clk_div2
  clk_div2_i
  ( 
     .clk     (  clk_i     ),//400Mhz
     .rst_n   (  rstn_i    ), 
     .clk_out (  clk_o     ) //200Mhz
  );


  //----------------------------------------------------------------------------//
  // Reset synchronizer
  //----------------------------------------------------------------------------//
  rstgen_lock i_rst_gen_ppu
  (
      // PAD FRAME SIGNALS
      .clk_i               ( clk_o           ),
      .rst_ni              ( rstn_i          ),
      .lock                ( lock_i          ),

      // TEST MODE
      .test_mode_i         ( testmode_i      ),
      .pll_bps_i           ( pll_bps_i       ),

      // OUTPUT RESET
      .rst_no              ( rstn_o          )
  );


endmodule
