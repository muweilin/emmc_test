module sp_ram
  #(
    parameter ADDR_WIDTH = 14,
    parameter DATA_WIDTH = 32,
    parameter NUM_WORDS  = 16384  //in bytes  
  )(
    // Clock and Reset
    input  logic                    clk,

    input  logic                    en_i,
    input  logic [ADDR_WIDTH-1:0]   addr_i,
    input  logic [DATA_WIDTH-1:0]   wdata_i,
    output logic [DATA_WIDTH-1:0]   rdata_o,
    input  logic                    we_i,
    input  logic [3:0] be_i 
  );

  logic [31:0] bitwe_n;
  logic [ADDR_WIDTH-3:0] addr;

  assign addr = addr_i[ADDR_WIDTH-1:2];
 
  genvar i;
  generate for(i =  0; i <  8; i++) begin
    assign bitwe_n[i     ] = ~be_i[0];
    assign bitwe_n[i +  8] = ~be_i[1];
    assign bitwe_n[i + 16] = ~be_i[2];
    assign bitwe_n[i + 24] = ~be_i[3];
  end
  endgenerate

 ram_4096x32 sp_ram_smic(
   .Q     (  rdata_o  ),
   .CLK   (  clk      ),
   .CEN   (  ~en_i    ),
   .WEN   (  ~we_i    ),
   .BWEN  (  bitwe_n  ),
   .A     (  addr     ),
   .D     (  wdata_i  )
  );

endmodule
