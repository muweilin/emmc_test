reg [31:0] i;
reg [31:0] j;

`define MemBase0Addr 32'h20010000

//-- 1 -- : datamif0
/*
localparam IN_CNT0             = 32'd192000;
localparam IM_RAM_DEPTH0       = 32'd80;
localparam BIAS_RAM_DEPTH0     = 32'd132;
localparam WEIGHT_RAM_DEPTH0   = 32'd136;
localparam SIG_LUT_DEPTH0      = 32'd512;
localparam OUT_CNT0            = 32'd12000;
localparam INIT_SRC_ADDR0      = 32'd0 + `MemBase0Addr;
localparam NPU_SRC_ADDR0       = 32'd10000  + `MemBase0Addr;
localparam NPU_TAR_ADDR0       = 32'hc0000 + `MemBase0Addr;

parameter SIG_INIT0          = "../../../../tb/datamif0/sigmoid.mif";
parameter INSN_MEM_MIF0      = "../../../../tb/datamif0/meminit_insn.mif";
parameter WEIGHT_MIF0        = "../../../../tb/datamif0/meminit_w";
parameter BIAS_MIF0          = "../../../../tb/datamif0/meminit_offset.mif";
parameter INPUT_VECTORS0     = "../../../../tb/datamif0/meminit_input_vectors.mif";

*/
//-- 2 -- : mif-blackscholes-in6-out1
/*
localparam IN_CNT0             = 32'd6148; //6146
localparam IM_RAM_DEPTH0       = 32'd26;  // 26+2 = 28?
localparam BIAS_RAM_DEPTH0     = 32'd24;//21+3=24
localparam WEIGHT_RAM_DEPTH0   = 32'd2048;
localparam SIG_LUT_DEPTH0      = 32'd512;
localparam OUT_CNT0            = 32'd1024;//1025
localparam INIT_SRC_ADDR0      = 32'd0 + `MemBase0Addr;
localparam NPU_SRC_ADDR0       = 32'd10000  + `MemBase0Addr;
localparam NPU_TAR_ADDR0       = 32'hc0000 + `MemBase0Addr;

parameter SIG_INIT0          = "../../../../tb/all_case_mif/mif-blackscholes-in6-out1/sigmoid.mif";
parameter INSN_MEM_MIF0      = "../../../../tb/all_case_mif/mif-blackscholes-in6-out1/meminit_insn.mif";
parameter WEIGHT_MIF0        = "../../../../tb/all_case_mif/mif-blackscholes-in6-out1/meminit_w";
parameter BIAS_MIF0          = "../../../../tb/all_case_mif/mif-blackscholes-in6-out1/meminit_offset.mif";
parameter INPUT_VECTORS0     = "../../../../tb/all_case_mif/mif-blackscholes-in6-out1/meminit_input_vectors.mif";
*/

//-- 3 -- : mif-fft-in1-out2
/*
localparam IN_CNT0             = 32'd1144;
localparam IM_RAM_DEPTH0       = 32'd10;  //10+2 = 12
localparam BIAS_RAM_DEPTH0     = 32'd12;  // 10+2 =12?
localparam WEIGHT_RAM_DEPTH0   = 32'd2048;
localparam SIG_LUT_DEPTH0      = 32'd512;
localparam OUT_CNT0            = 32'd2288;
localparam INIT_SRC_ADDR0      = 32'd0 + `MemBase0Addr;
localparam NPU_SRC_ADDR0       = 32'd10000  + `MemBase0Addr;
localparam NPU_TAR_ADDR0       = 32'hc0000 + `MemBase0Addr;

parameter SIG_INIT0          = "../../../../tb/all_case_mif/mif_fft-in1-out2/sigmoid.mif";
parameter INSN_MEM_MIF0      = "../../../../tb/all_case_mif/mif_fft-in1-out2/meminit_insn.mif";
parameter WEIGHT_MIF0        = "../../../../tb/all_case_mif/mif_fft-in1-out2/meminit_w";
parameter BIAS_MIF0          = "../../../../tb/all_case_mif/mif_fft-in1-out2/meminit_offset.mif";
parameter INPUT_VECTORS0     = "../../../../tb/all_case_mif/mif_fft-in1-out2/meminit_input_vectors.mif";
*/

/*
//-- 4 -- : mif_inversek2j-in2-out2
/*
localparam IN_CNT0             = 32'd1000;
localparam IM_RAM_DEPTH0       = 32'd10;
localparam BIAS_RAM_DEPTH0     = 32'd12; //(10+2)/4=int ?
localparam WEIGHT_RAM_DEPTH0   = 32'd2048;
localparam SIG_LUT_DEPTH0      = 32'd512;
localparam OUT_CNT0            = 32'd1000;
localparam INIT_SRC_ADDR0      = 32'd0 + `MemBase0Addr;
localparam NPU_SRC_ADDR0       = 32'd10000  + `MemBase0Addr;
localparam NPU_TAR_ADDR0       = 32'hc0000 + `MemBase0Addr;

parameter SIG_INIT0          = "../../../../tb/all_case_mif/mif_inversek2j-in2-out2/sigmoid.mif";
parameter INSN_MEM_MIF0      = "../../../../tb/all_case_mif/mif_inversek2j-in2-out2/meminit_insn.mif";
parameter WEIGHT_MIF0        = "../../../../tb/all_case_mif/mif_inversek2j-in2-out2/meminit_w";
parameter BIAS_MIF0          = "../../../../tb/all_case_mif/mif_inversek2j-in2-out2/meminit_offset.mif";
parameter INPUT_VECTORS0     = "../../../../tb/all_case_mif/mif_inversek2j-in2-out2/meminit_input_vectors.mif";
*/

//-- 5 -- : mif-jmeint-in18-out2
/*
localparam IN_CNT0             = 32'd45000;
localparam IM_RAM_DEPTH0       = 32'd56;
localparam BIAS_RAM_DEPTH0     = 32'd124; // 122+2?
localparam WEIGHT_RAM_DEPTH0   = 32'd2048;
localparam SIG_LUT_DEPTH0      = 32'd512;
localparam OUT_CNT0            = 32'd5000;
localparam INIT_SRC_ADDR0      = 32'd0 + `MemBase0Addr;
localparam NPU_SRC_ADDR0       = 32'd10000  + `MemBase0Addr;
localparam NPU_TAR_ADDR0       = 32'hc0000 + `MemBase0Addr;

parameter SIG_INIT0          = "../../../../tb/all_case_mif/mif_jmeint-in18-out2/sigmoid.mif";
parameter INSN_MEM_MIF0      = "../../../../tb/all_case_mif/mif_jmeint-in18-out2/meminit_insn.mif";
parameter WEIGHT_MIF0        = "../../../../tb/all_case_mif/mif_jmeint-in18-out2/meminit_w";
parameter BIAS_MIF0          = "../../../../tb/all_case_mif/mif_jmeint-in18-out2/meminit_offset.mif";
parameter INPUT_VECTORS0     = "../../../../tb/all_case_mif/mif_jmeint-in18-out2/meminit_input_vectors.mif";
*/

//-- 6 -- : mif-jpeg-in64-out4
/*
localparam IN_CNT0             = 32'd192000;
localparam IM_RAM_DEPTH0       = 32'd80;
localparam BIAS_RAM_DEPTH0     = 32'd132; // ?
localparam WEIGHT_RAM_DEPTH0   = 32'd2048;
localparam SIG_LUT_DEPTH0      = 32'd512;
localparam OUT_CNT0            = 32'd12000;
localparam INIT_SRC_ADDR0      = 32'd0 + `MemBase0Addr;
localparam NPU_SRC_ADDR0       = 32'd10000  + `MemBase0Addr;
localparam NPU_TAR_ADDR0       = 32'hc0000 + `MemBase0Addr;

parameter SIG_INIT0          = "../../../../tb/all_case_mif/mif_jpeg_in64_out4/sigmoid.mif";
parameter INSN_MEM_MIF0      = "../../../../tb/all_case_mif/mif_jpeg_in64_out4/meminit_insn.mif";
parameter WEIGHT_MIF0        = "../../../../tb/all_case_mif/mif_jpeg_in64_out4/meminit_w";
parameter BIAS_MIF0          = "../../../../tb/all_case_mif/mif_jpeg_in64_out4/meminit_offset.mif";
parameter INPUT_VECTORS0     = "../../../../tb/all_case_mif/mif_jpeg_in64_out4/meminit_input_vectors.mif";
*/

//-- 7 -- : mif-kmeans-in6-out1
/*
localparam IN_CNT0             = 32'd230400;
localparam IM_RAM_DEPTH0       = 32'd18;
localparam BIAS_RAM_DEPTH0     = 32'd16; //13+3 ?
localparam WEIGHT_RAM_DEPTH0   = 32'd16;
localparam SIG_LUT_DEPTH0      = 32'd512;
localparam OUT_CNT0            = 32'd38400;
localparam INIT_SRC_ADDR0      = 32'd0 + `MemBase0Addr;
localparam NPU_SRC_ADDR0       = 32'd10000  + `MemBase0Addr;
localparam NPU_TAR_ADDR0       = 32'hc0000 + `MemBase0Addr;

parameter SIG_INIT0          = "../../../../tb/all_case_mif/mif_kmeans-in6-out1/sigmoid.mif";
parameter INSN_MEM_MIF0      = "../../../../tb/all_case_mif/mif_kmeans-in6-out1/meminit_insn.mif";
parameter WEIGHT_MIF0        = "../../../../tb/all_case_mif/mif_kmeans-in6-out1/meminit_w";
parameter BIAS_MIF0          = "../../../../tb/all_case_mif/mif_kmeans-in6-out1/meminit_offset.mif";
parameter INPUT_VECTORS0     = "../../../../tb/all_case_mif/mif_kmeans-in6-out1/meminit_input_vectors.mif";
*/

//-- 8 -- : mif_mnist_in764-out10
/*
localparam IN_CNT0             = 32'd392000;
localparam IM_RAM_DEPTH0       = 32'd800; //799
localparam BIAS_RAM_DEPTH0     = 32'd1480; // ?
localparam WEIGHT_RAM_DEPTH0   = 32'd2048;
localparam SIG_LUT_DEPTH0      = 32'd512;
localparam OUT_CNT0            = 32'd5000;
localparam INIT_SRC_ADDR0      = 32'd0 + `MemBase0Addr;
localparam NPU_SRC_ADDR0       = 32'd10000  + `MemBase0Addr;
localparam NPU_TAR_ADDR0       = 32'hfffff + `MemBase0Addr;

parameter SIG_INIT0          = "../../../../tb/all_case_mif/mif_mnist-in764-out10/sigmoid.mif";
parameter INSN_MEM_MIF0      = "../../../../tb/all_case_mif/mif_mnist-in764-out10/meminit_insn.mif";
parameter WEIGHT_MIF0        = "../../../../tb/all_case_mif/mif_mnist-in764-out10/meminit_w";
parameter BIAS_MIF0          = "../../../../tb/all_case_mif/mif_mnist-in764-out10/meminit_offset.mif";
parameter INPUT_VECTORS0     = "../../../../tb/all_case_mif/mif_mnist-in764-out10/meminit_input_vectors.mif";
*/

//-- 9 -- : mif_sobel-in9-out1
/**/
localparam IN_CNT0             = 32'd42132;
localparam IM_RAM_DEPTH0       = 32'd17;
localparam BIAS_RAM_DEPTH0     = 32'd20;//17+3 =20
localparam WEIGHT_RAM_DEPTH0   = 32'd2048;
localparam SIG_LUT_DEPTH0      = 32'd512;
localparam OUT_CNT0            = 32'd4681;
localparam INIT_SRC_ADDR0      = 32'd0 + `MemBase0Addr;
localparam NPU_SRC_ADDR0       = 32'd10000  + `MemBase0Addr;
localparam NPU_TAR_ADDR0       = 32'hc0000 + `MemBase0Addr;

parameter SIG_INIT0          = "../../../../tb/all_case_mif/mif_sobel-in9-out1/sigmoid.mif";
parameter INSN_MEM_MIF0      = "../../../../tb/all_case_mif/mif_sobel-in9-out1/meminit_insn.mif";
parameter WEIGHT_MIF0        = "../../../../tb/all_case_mif/mif_sobel-in9-out1/meminit_w";
parameter BIAS_MIF0          = "../../../../tb/all_case_mif/mif_sobel-in9-out1/meminit_offset.mif";
parameter INPUT_VECTORS0     = "../../../../tb/all_case_mif/mif_sobel-in9-out1/meminit_input_vectors.mif";
/**/

reg [7:0] sig_init0 [SIG_LUT_DEPTH0-1:0];
initial begin
$readmemh(SIG_INIT0, sig_init0, 0, SIG_LUT_DEPTH0-1); 
end
// instruction mem ram init.
reg [20:0] im_init0 [IM_RAM_DEPTH0-1:0];
initial begin
$readmemb(INSN_MEM_MIF0, im_init0, 0, IM_RAM_DEPTH0-1);
end
// weight ram init.
reg [128*8:0] mif_file0;
reg [7:0] weight_init0 [WEIGHT_RAM_DEPTH0*8-1:0];
reg [4:0] t0;
initial begin
  for (t0 = 0; t0 < 8; t0 = t0 + 1) begin
     $sformat(mif_file0, "%s%02d.mif", WEIGHT_MIF0, t0);
     $readmemh(mif_file0, weight_init0, WEIGHT_RAM_DEPTH0*t0, WEIGHT_RAM_DEPTH0*(t0+1)-1); 
  end
end
// bias ram init.
reg [7:0] bias_init0 [BIAS_RAM_DEPTH0-1:0];
initial begin
  $readmemh(BIAS_MIF0, bias_init0, 0, BIAS_RAM_DEPTH0-1); 
end
//input init. 
reg [63:0] input_init0 [IN_CNT0-1:0];
initial begin
  $readmemh(INPUT_VECTORS0, input_init0, 0, IN_CNT0-1); 
end


initial begin
$display("init starting......");

i = 0;
for (j=0 ;j < 0+IM_RAM_DEPTH0*4;j=j+32'h4) begin  
  backdoor_write(j+`MemBase0Addr,{11'b0,im_init0[i][20:0]});
  //$display("the instruction[%d] is %h",i,im_init0[i]);
  i=i+1;
end

i = 0;
for (j=0+IM_RAM_DEPTH0*4;j < 0 +(IM_RAM_DEPTH0*4 + WEIGHT_RAM_DEPTH0*8); j=j+32'h4) begin
  backdoor_write(j+`MemBase0Addr,{weight_init0[i+3],weight_init0[i+2],weight_init0[i+1],weight_init0[i]});
  //$display("the weight[%d] is %h",i,weight_init0[i]);
  i=i+4;
end

i = 0;
for (j=0+IM_RAM_DEPTH0*4 + WEIGHT_RAM_DEPTH0*8; j < 0+IM_RAM_DEPTH0*4 + WEIGHT_RAM_DEPTH0*8+BIAS_RAM_DEPTH0; j=j+32'h4) begin
  backdoor_write(j+`MemBase0Addr,{ bias_init0[i+3], bias_init0[i+2], bias_init0[i+1], bias_init0[i]});
  i=i+4;
end

i = 0;
for (j=0+IM_RAM_DEPTH0*4 + WEIGHT_RAM_DEPTH0*8 + BIAS_RAM_DEPTH0; j < 0+IM_RAM_DEPTH0*4 + WEIGHT_RAM_DEPTH0*8 + BIAS_RAM_DEPTH0 + SIG_LUT_DEPTH0; j=j+32'h4) begin
  backdoor_write(j+`MemBase0Addr,{ sig_init0[i+3], sig_init0[i+2], sig_init0[i+1], sig_init0[i]});
  i=i+4;
end

i = 0;
for (j=0+IM_RAM_DEPTH0*4 + WEIGHT_RAM_DEPTH0*8 + BIAS_RAM_DEPTH0 + SIG_LUT_DEPTH0; j < 32'he000; j=j+32'h4) begin
  backdoor_write(j+`MemBase0Addr, 32'b0);
  i=i+4;
end

i = 0;
for (j=32'h10000; j < 32'h10000 + IN_CNT0*4; j=j+32'h4) begin
  backdoor_write(j+`MemBase0Addr,input_init0[i][31:0]);
  //$display("the input_vector[%d] is %h",i,input_init0[i]);
  i=i+1;
end
end

