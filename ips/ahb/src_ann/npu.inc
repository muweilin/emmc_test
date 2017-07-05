`ifndef NPU_INC
`define NPU_INC

localparam NUM_PE                  = 8;
localparam PER                     = 10;
localparam NPU_TEST_SIZE           = 3000;
localparam TIMEOUT                 = 1200000000;
localparam INPUT_SIZE              = 64;
localparam OUTPUT_SIZE             = 4;
localparam HIDDEN_NEURONS          = 10;
localparam IF_WIDTH                = 32;
localparam IF_RATIO                = 4;
localparam LOG_IF_RATIO            = 2;
localparam ACC_WIDTH               = 26;
localparam DATA_WIDTH              = 8;
localparam WEIGHT_WIDTH            = 8;
localparam DATA_DEC_WIDTH          = 7;
localparam DATA_INT_WIDTH          = 0;
localparam WGHT_DEC_WIDTH          = 7;
localparam WGHT_INT_WIDTH          = 0;
localparam INPUT_NEURONS_MAX       = 1024;
localparam LOG_INPUT_NEURONS_MAX   = 10;
localparam OUTPUT_NEURONS_MAX      = 64;
localparam LOG_OUTPUT_NEURONS_MAX  = 6;
localparam WEIGHT_COUNT_MAX        = 16384;
localparam LOG_WEIGTH_COUNT_MAX    = 14;

`endif
