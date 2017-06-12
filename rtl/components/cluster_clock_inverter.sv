`include "config.sv"

module cluster_clock_inverter
(
    input  logic clk_i,
    output logic clk_o
  );

`ifdef SMIC_SYNTHESIS
    CLKNHDV10 hand_ck_inv(.I(clk_i), .ZN(clk_o) );
`else
    assign clk_o = ~clk_i;
`endif

endmodule
