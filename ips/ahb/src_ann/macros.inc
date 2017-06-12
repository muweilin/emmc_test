`ifndef MACROS_INC
`define MACROS_INC

//`define XILINX_IP
`timescale 1ns/1ns  
`define LOGIC   1 
`define BIDIR   2 
`define INCELL  3 
`define CLOCK   4 
`define HSCK    5 
`define CLOCKB  6 
`define ESPXCLKIN  7 
`define HSCKMUX 8 
`define IOCONTROL 9 

`define LOG2(x) \
 ((x) == 1) ? 0 : \
 ((x) == 2) ? 1 : \
 ((x) == 4) ? 2 : \
 ((x) == 8) ? 3 : \
 ((x) == 16) ? 4 : \
 ((x) == 32) ? 5 : \
 ((x) == 64) ? 6 : \
 ((x) == 128) ? 7 : \
 ((x) == 256) ? 8 : \
 ((x) == 512) ? 9 : \
 ((x) == 1024) ? 10 : \
 ((x) == 2048) ? 11 : \
 ((x) == 4096) ? 12 : \
 ((x) == 8192) ? 13 : \
 ((x) == 16384) ? 14 : \
 ((x) == 32768) ? 15 : \
 ((x) == 65536) ? 16 : \
 ((x) == 131072) ? 17 : \
 ((x) == 262144) ? 18 : \
 ((x) == 524288) ? 19 : \
 ((x) == 1048576) ? 20 : \
 ((x) == 2097152) ? 21 : \
 ((x) == 4194304) ? 22 : \
 ((x) == 8388608) ? 23 : \
 ((x) == 16777216) ? 24 : \
 ((x) == 33554432) ? 25 : \
 ((x) == 67108864) ? 26 : \
 ((x) == 134217728) ? 27 : \
 ((x) == 268435456) ? 28 : \
 ((x) == 536870912) ? 29 : \
 ((x) == 1073741824) ? 30 : \
 ((x) == 2147483648) ? 31 : -1 // this should break simulators or synthesis tools

`define MAKE_CONST(width, val) localparam [width-1:0] width``_``val = val;

`define MSP_CLOCK_GATE(gated_clk, cg_inst, ungated_clk, clk_en, scan_en)\
    `ifdef CLOCK_GATING\
        wire gated_clk;\
        omsp_clock_gate cg_inst (.gclk(gated_clk), .clk (ungated_clk), .enable(clk_en), .scan_enable(scan_en));\
    `else\
        wire gated_clk = ungated_clk;\
    `endif

`define REG(name, name_d, w_type, width, init)\
    reg [width-1:0] name;\
    w_type [width-1:0] name_d;\
    always@(posedge CLK or negedge RST_N) begin\
    if(!RST_N) name <= init;\
    else name <= name_d; \
    end

`define REG_ASR(name, name_d, w_type, width, init, clk, rst)\
    reg [width-1:0] name;\
    w_type [width-1:0] name_d;\
    always@(posedge clk or negedge rst) begin\
    if(!rst) name <= init;\
    else name <= name_d;\
    end

`define REG_ASR_S(name, name_d, w_type, sign, width, init, clk, rst)\
    reg sign [width-1:0] name;\
    w_type sign [width-1:0] name_d;\
    always@(posedge clk or posedge rst) begin\
    if(rst) name <= init;\
    else name <= name_d;\
    end

`define LATCH(D, Q, clk)\
    reg D,Q;\
    always@(*) begin\
    if(clk) Q <= D;\
    end


`define CREG(name, width)\
    reg [width-1:0] name;

`define WIRE(name, width)\
    wire [width-1:0] name;

/*
`define ZERO(name, width)\
    wire [width-1:0] name;\
    parameter name``_zero = 0;\
    assign name = name``_zero[width-1:0];


`define COUNTER(name, w_type, width, init)\
    reg [width-1:0] name;\
    w_type [width-1:0] name``_inc;\
    w_type [width-1:0] name``_dec;\
    always@(posedge CLK) begin\
    if(RST_N) begin\
        name <= name + name``_inc - name``_dec;\
    end\
    else name <= init;\
    end

`define FIFO_TEMPLATE(fifotype, w_type, r_type, name, depth, width)\
    w_type [width:0] name``_enq;\
    wire [width-1:0] name``_dout;\
    r_type name``_deq;\
    wire name``_notEmpty;\
    wire name``_notFull;\
    localparam name``_cntrwidth = `LOG2((depth));\
    fifotype#(.p1width(width),\
          .p2depth(depth),\
          .p3cntr_width(name``_cntrwidth)) name\
    (\
    .CLK(CLK),\
    .RST_N(RST_N),\
    .D_IN(name``_enq[width-1:0]),\
    .D_OUT(name``_dout),\
    .ENQ(name``_enq[width]),\
    .DEQ(name``_deq),\
    .EMPTY_N(name``_notEmpty),\
    .FULL_N(name``_notFull),\
    .CLR(1'b0)\
    );


`define LUTRAM_TEMPLATE(wtype, name, d, w) \
    localparam name``_aw = `LOG2(d); \
    reg [w-1:0] name [d-1:0]; \
    wtype [name``_aw+w:0] name``_wcmd; \
    wire name``_wen   = name``_wcmd[ w + name``_aw ]; \
    wire name``_waddr = name``_wcmd[ w + name``_aw - 1 : w ]; \
    integer name``_i;\
    initial for(name``_i=0; name``_i < d; name``_i=name``_i+1) name[name``_i] = 0; \
    always@(posedge CLK) begin \
        if(RST_N) begin \
        if(name``_wen) \
            name[ name``_waddr ] <= name``_wcmd[ w-1 : 0 ]; \
        end \
    end

`define LUTRAM_TEMPLATE_2W(wtype0, wtype1, name, d, w) \
    localparam name``_aw = `LOG2(d); \
    reg [w-1:0] name [d-1:0]; \
    wtype0 [name``_aw+w:0] name``_wcmd0; \
    wtype1 [name``_aw+w:0] name``_wcmd1; \
    wire name``_wen0   = name``_wcmd0[ w + name``_aw ]; \
    wire name``_wen1   = name``_wcmd1[ w + name``_aw ]; \
    wire name``_waddr0 = name``_wcmd0[ w + name``_aw - 1 : w ]; \
    wire name``_waddr1 = name``_wcmd1[ w + name``_aw - 1 : w ]; \
    integer name``_i;\
    initial for(name``_i=0; name``_i < d; name``_i=name``_i+1) name[name``_i] = 0; \
    always@(posedge CLK) begin \
        if(RST_N) begin \
        if(name``_wen0) \
            name[ name``_waddr0 ] <= name``_wcmd0[ w-1 : 0 ]; \
                if(name``_wen1) \
                    name[ name``_waddr1 ] <= name``_wcmd1[ w-1 : 0 ]; \
            end \
    end \

`define SEQ_ASSERT(cond,msg)\
    always@(negedge CLK) begin\
        if(RST_N && !(cond)) begin\
            $display(msg);\
            $finish(0);\
        end\
    end

`define COMB_ASSERT(cond,msg)\
    if(RST_N && !(cond)) begin\
        $display(msg);\
        $finish(0);\
    end


`define BRAM_TEMPLATE(wtype, name, d, w)                           \
    localparam name``_aw = `LOG2((d));                             \
    (* ram_style = "block" *)                                      \
    reg [(w)-1:0] name [(d)-1:0];                                  \
    wtype [1+name``_aw+(w):0] name``_acmd;                         \
    wtype [1+name``_aw+(w):0] name``_bcmd;                         \
    wire name``_en_a = name``_acmd[ 1 + (w) + name``_aw ];         \
    wire name``_en_b = name``_bcmd[ 1 + (w) + name``_aw ];         \
    wire name``_wen_a = name``_acmd[ (w) + name``_aw ];            \
    wire name``_wen_b = name``_bcmd[ (w) + name``_aw ];            \
    wire [name``_aw-1:0] name``_waddr_a = name``_acmd[ (w) + name``_aw - 1 : (w) ];\
    wire [name``_aw-1:0] name``_waddr_b = name``_bcmd[ (w) + name``_aw - 1 : (w) ];\
    reg [(w)-1:0] name``_aval;                                     \
    reg [(w)-1:0] name``_bval;                                     \
    always @(posedge CLK) begin                                    \
        if(RST_N) begin                                            \
            if(name``_en_a) begin                                  \
                if(name``_wen_a)                                   \
                name[ name``_waddr_a ] <= name``_acmd[ (w)-1 : 0 ];\
            end                                                    \
            name``_aval <= name[ name``_waddr_a ];             \
            if(name``_en_b) begin                                  \
                if(name``_wen_b)                                   \
                name[ name``_waddr_b ] <= name``_bcmd[ (w)-1 : 0 ];\
            end                                                    \
            name``_bval <= name[ name``_waddr_b ];             \
        end                                                        \
    end

*/

`endif
