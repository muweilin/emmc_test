`include "config.sv"

module cluster_clock_mux2
(
    input  logic clk0_i,
    input  logic clk1_i,
    input  logic clk_sel_i,
    output logic clk_o
  );

`ifdef SMIC_SYNTHESIS
    CKMUX2HDV4 hand_ck_mux(.I0(clk0_i), .I1(clk1_i), .S(clk_sel_i), .Z(clk_o));
`else

  always_comb
  begin
    if (clk_sel_i == 1'b0)
      clk_o = clk0_i;
    else
      clk_o = clk1_i;
  end

`endif

endmodule
