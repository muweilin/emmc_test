
`include "config.sv"

module pll0
(
    input  logic              sys_clk_p,
    input  logic              sys_clk_n,
    input  logic              rstn_i,

    output logic              clk_o,
    output logic              locked
);


  xilinx_clock_manager xlnx_clock_manager_inst
   (
    .clk200_i_p    (  sys_clk_p   ),    // input clk200_i_p
    .clk200_i_n    (  sys_clk_n   ),    // input clk200_i_n
    .rstn_i        (  rstn_i      ), // input rstn_i

    // Clock out ports
    .clk50_o       (  clk_o       ),     // output clk50_o
    .locked        (  locked      )      // output locked
   );

endmodule
