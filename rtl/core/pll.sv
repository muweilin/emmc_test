
`include "config.sv"

(* dont_touch = "yes" *) module pll
(
    input  logic                            clk_i,
    input  logic  [1:0]                     div_i,
    input  logic                            rstn_i,
    input  logic                            pll_bps_i,

    output logic                            clk_o,
`ifdef HAPS
    output logic                            clk2x_o,
`endif
    output logic                            locked
);

`ifndef HAPS

  //----------------------------------------------------------------------------//
  // SMIC55LL PLL
  // CLK_OUT = XIN x M / N / NO
  // M = M7*128 + M6*64 + M5*32 + M4*16 + M3*8 + M2*4 + M1*2 + M0*1
  // N = N3*8 + N2*4 + N1*2 + N0*1
  // NO = 2^(OD1*2 + OD0*1)
  // XIN = 25MHz, M=1000_0000(128), N=0100(4), OD=01(NO=2)
  // XOUT = 400MHz
  //----------------------------------------------------------------------------//
   S55NLLPLLGS_ZP1500A
   ppl_i
   (
     .AVDD     (),
     .AVSS     (),
     .DVDD     (),
     .DVSS     (),
     .XIN      (    clk_i        ),
     .LKDT     (    locked       ),
     .CLK_OUT  (    clk_o        ),
     .N        (    4'b0100      ),
     .M        (    8'b10000000  ),
     .PDRST    (    ~rstn_i      ),
//   .OD       (    2'b01        ),
     .OD       (    div_i        ),
     .BP       (    pll_bps_i    ) 
   );

`else
  logic clk100;
  logic clk50;

 xilinx_clock_manager mmc_i
     (
      .clk100_i  (   clk_i     ), 
      .clk200_o  (   clk200    ), 
      .clk100_o  (   clk100    ), 
      .clk50_o   (   clk50     ), 
      .rstn_i    (   rstn_i    ), 
      .locked    (   locked    )
    );

 `ifdef CORE_50M 
   assign clk_o   = clk100;
   assign clk2x_o = clk200;
 `endif

 `ifdef CORE_25M 
   assign clk_o   = clk50;
   assign clk2x_o = clk100;
 `endif

`endif

endmodule
