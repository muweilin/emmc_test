module triBuf
#(
  parameter  IOPUT_NUM  = 1
)
(
   input  [IOPUT_NUM-1:0] core_in,
   output [IOPUT_NUM-1:0] core_out,
   input  [IOPUT_NUM-1:0] core_oe,
   inout  [IOPUT_NUM-1:0] io_inout
);
  generate
     genvar i;
       for (i = 0; i < IOPUT_NUM; i = i + 1) begin
        triBufSlice triBufSlice_i
        (
          .core_in  ( core_in[i]  ),
          .core_out ( core_out[i] ),
          .core_oe  ( core_oe[i]  ),
          .io_inout ( io_inout[i] )
        );
      end
  endgenerate

endmodule



module triBufSlice
(
   input  core_in,
   output core_out,
   input  core_oe,
   inout  io_inout
);

    assign io_inout = core_oe ? core_in : 1'bZ;
    assign core_out = io_inout;

endmodule
