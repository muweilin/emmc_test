
module clk_div2( 
   clk,
   rst_n, 
   clk_out
);
   
   input  clk;
   input  rst_n;
   output clk_out;

   reg    clk_out;
 
  always @(negedge rst_n or posedge clk)
    if (!rst_n)
      clk_out <= 0;
    else   
      clk_out <= ~clk_out;

endmodule // clk_div2
