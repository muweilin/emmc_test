`include "config.sv"

module cluster_clock_gating
(
    input  logic clk_i,
    input  logic en_i,
    input  logic test_en_i,
    output logic clk_o
  );

`ifdef HAPS 
  // no clock gates in FPGA flow
  assign clk_o = clk_i;
`else
  `ifdef SMIC_SYNTHESIS
      CLKLANQHDV4 hand_icg(.CK(clk_i), .TE(test_en_i), .E(en_i), .Q(clk_o));
  `else
  logic clk_en;

  always_latch
  begin
     if (clk_i == 1'b0)
       clk_en <= en_i | test_en_i;
  end

  assign clk_o = clk_i & clk_en;
  `endif
`endif

endmodule
