`ifndef SIGMOID_INC
`define SIGMOID_INC

// Sigmoid Mode
localparam SIGMODE_W             = 3;
localparam SIGMODE_LINEAR        = 2'b01;
localparam SIGMODE_SIGMOID       = 2'b10;
localparam SIGMODE_SYMMETRIC     = 2'b11;

//////////////////////////////////////
// Automatically derived parameters //
//////////////////////////////////////

// Simulation Params
localparam SIGTB_LOG_TEST_SIZE   = 8;
localparam SIGTB_TEST_SIZE       = 256;
localparam SIGTB_UUT_DELAY       = 1;

// Values
localparam signed NMAX           = -18'd255;
localparam signed MAXVAL         = 8'h7f;
localparam signed MINVAL         = 8'h80;
localparam signed NCUTOFF        = -18'd19;
localparam signed ONE            = 9'h080;
localparam signed PCUTOFF        = 18'd19;
localparam signed PMAX           = 18'd255;

// Sigmoid Bus Widths
localparam SIG_LUT_DEPTH         = 512;
localparam LUT_PRECISION         = 6;
localparam PRECISION_SHIFT       = 8;
localparam SIG_LSHIFT            = 1;
localparam LOG_SIG_LUT_DEPTH     = 9;
localparam INDEX_WIDTH           = 18;
localparam SIG_IN_PREC           = 14;
localparam SIG_OUT_PREC          = 7;

`endif
