`include "config.sv"

module udfIBUF_clk_rstn
#(
  parameter  INPUT_NUM  = 1
)
( 
  input  [INPUT_NUM-1:0]   io_in,
  output [INPUT_NUM-1:0]   core_out
);

`ifndef HAPS
  generate
     genvar i;
       for (i = 0; i < INPUT_NUM; i = i + 1) begin
           PISDR pisdr_i
           (
             .PAD  ( io_in[i]    ),
             .IE   ( 1'b1        ),
             .C    ( core_out[i] )
           );
      end
  endgenerate
`else
  assign core_out = io_in;
`endif

endmodule

module udfIBUF_io_dn
#(
  parameter  INPUT_NUM  = 1
)
(
  input  [INPUT_NUM-1:0]   io_in,
  output [INPUT_NUM-1:0]   core_out
);

`ifndef HAPS
  generate
     genvar i;
       for (i = 0; i < INPUT_NUM; i = i + 1) begin
           PICDR picdr_i
           (
             .PAD  ( io_in[i]    ),
             .IE   ( 1'b1        ),
             .C    ( core_out[i] ),
             .REN  ( 1'b0        )
           );
      end
  endgenerate
`else
  assign core_out = io_in;
`endif

endmodule

module udfIBUF_io_up
#(
  parameter  INPUT_NUM  = 1
)
(
  input  [INPUT_NUM-1:0]   io_in,
  output [INPUT_NUM-1:0]   core_out
);

`ifndef HAPS
  generate
     genvar i;
       for (i = 0; i < INPUT_NUM; i = i + 1) begin
           PICUR picur_i
           (
             .PAD  ( io_in[i]    ),
             .IE   ( 1'b1        ),
             .C    ( core_out[i] ),
             .REN  ( 1'b0        )
           );
      end
  endgenerate
`else
  assign core_out = io_in;
`endif

endmodule


module udfOBUF_clk
#(
  parameter  OUTPUT_NUM  = 1
)
(
  input  [OUTPUT_NUM-1:0]  core_in,
  output [OUTPUT_NUM-1:0]  io_out
);

`ifndef HAPS
  generate
     genvar i;
       for (i = 0; i < OUTPUT_NUM; i = i + 1) begin
           PBCDL8R pbcdl_i
           (
             .PAD  ( io_out[i]  ),
             .IE   ( 1'b0       ),
             .OEN  ( 1'b0       ),
             .REN  ( 1'b1       ),
             .I    ( core_in[i] ),
             .C    ( )
           );
      end
  endgenerate
`else
  assign io_out = core_in;
`endif

endmodule


module udfOBUF_io
#(
  parameter  OUTPUT_NUM  = 1
)
(
  input  [OUTPUT_NUM-1:0]  core_in,
  output [OUTPUT_NUM-1:0]  io_out
);

`ifndef HAPS
  generate
     genvar i;
       for (i = 0; i < OUTPUT_NUM; i = i + 1) begin
           PBCD4R pbcd_i
           (
             .PAD  ( io_out[i]  ),
             .IE   ( 1'b0       ),
             .OEN  ( 1'b0       ),
             .REN  ( 1'b1       ),
             .I    ( core_in[i] ),
             .C    ( )
           );
      end
  endgenerate
`else
  assign io_out = core_in;
`endif

endmodule


module TriBUF_dn
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
        TriBufSlice_dn TriBufSlice_dn_i
        (
          .core_in  ( core_in[i]  ),
          .core_out ( core_out[i] ),
          .core_oe  ( core_oe[i]  ),
          .io_inout ( io_inout[i] )
        );
      end
  endgenerate

endmodule

module TriBufSlice_dn
(
   input  core_in,
   output core_out,
   input  core_oe,
   inout  io_inout
);

`ifndef HAPS
    PBCD4R pbcd_tri_i
    (
      .PAD  ( io_inout  ),
      .IE   ( ~core_oe  ),
      .OEN  ( ~core_oe  ),
      .REN  ( 1'b0      ),
      .I    ( core_in   ),
      .C    ( core_out  )
    );
`else
    assign io_inout = core_oe ? core_in : 1'bZ;
    assign core_out = io_inout;
`endif

endmodule


module TriBUF_up
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
        TriBufSlice_up TriBufSlice_up_i
        (
          .core_in  ( core_in[i]  ),
          .core_out ( core_out[i] ),
          .core_oe  ( core_oe[i]  ),
          .io_inout ( io_inout[i] )
        );
      end
  endgenerate

endmodule

module TriBufSlice_up
(
   input  core_in,
   output core_out,
   input  core_oe,
   inout  io_inout
);

`ifndef HAPS
    PBCU4R pbcu_tri_i
    (
      .PAD  ( io_inout  ),
      .IE   ( ~core_oe  ),
      .OEN  ( ~core_oe  ),
      .REN  ( 1'b0      ),
      .I    ( core_in   ),
      .C    ( core_out  )
    );
`else
    assign io_inout = core_oe ? core_in : 1'bZ;
    assign core_out = io_inout;
`endif

endmodule

module TriBUF_z
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
        TriBufSlice_z TriBufSlice_z_i
        (
          .core_in  ( core_in[i]  ),
          .core_out ( core_out[i] ),
          .core_oe  ( core_oe[i]  ),
          .io_inout ( io_inout[i] )
        );
      end
  endgenerate

endmodule

module TriBufSlice_z
(
   input  core_in,
   output core_out,
   input  core_oe,
   inout  io_inout
);

`ifndef HAPS
    PBCD4R pbcd_tri_i
    (
      .PAD  ( io_inout  ),
      .IE   ( ~core_oe  ),
      .OEN  ( ~core_oe  ),
      .REN  ( 1'b1      ),
      .I    ( core_in   ),
      .C    ( core_out  )
    );
`else
    assign io_inout = core_oe ? core_in : 1'bZ;
    assign core_out = io_inout;
`endif

endmodule


module TriBUF_sl
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
        TriBufSlice_sl TriBufSlice_sl_i
        (
          .core_in  ( core_in[i]  ),
          .core_out ( core_out[i] ),
          .core_oe  ( core_oe[i]  ),
          .io_inout ( io_inout[i] )
        );
      end
  endgenerate

endmodule

module TriBufSlice_sl
(
   input  core_in,
   output core_out,
   input  core_oe,
   inout  io_inout
);

`ifndef HAPS
    PBCDL8R pbcdl_sl_i
    (
      .PAD  ( io_inout  ),
      .IE   ( ~core_oe  ),
      .OEN  ( ~core_oe  ),
      .REN  ( 1'b1      ),
      .I    ( core_in   ),
      .C    ( core_out  )
    );
`else
    assign io_inout = core_oe ? core_in : 1'bZ;
    assign core_out = io_inout;
`endif

endmodule
