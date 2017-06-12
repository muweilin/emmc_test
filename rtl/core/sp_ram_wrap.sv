// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "config.sv"

module sp_ram_wrap
  #(
    parameter RAM_SIZE   = 65536,              // in bytes
    parameter ADDR_WIDTH = $clog2(RAM_SIZE),   // 16
    parameter DATA_WIDTH = 32
  )(
    // Clock and Reset
    input  logic                    clk,
    input  logic                    rstn_i,
    input  logic                    en_i,
    input  logic [ADDR_WIDTH-1:0]   addr_i,
    input  logic [DATA_WIDTH-1:0]   wdata_i,
    output logic [DATA_WIDTH-1:0]   rdata_o,
    input  logic                    we_i,
    input  logic [DATA_WIDTH/8-1:0] be_i,
    input  logic                    bypass_en_i
  );

`ifdef HAPS 
  xilinx_mem_16384x32
  sp_blk_ram_i
  (
    .clka   ( clk                    ),
    .rsta   ( 1'b0                   ), // reset is active high

    .ena    ( en_i                   ),
    .addra  ( addr_i[ADDR_WIDTH-1:2] ),
    .dina   ( wdata_i                ),
    .douta  ( rdata_o                ),
    .wea    ( be_i & {4{we_i}}       )
  );

`else
  logic [DATA_WIDTH-1:0] rdata_o_0, rdata_o_1;
  logic [DATA_WIDTH-1:0] rdata_o_2, rdata_o_3;
  logic is_0, is_0_q;
  logic is_1, is_1_q;
  logic is_2, is_2_q;
  logic is_3, is_3_q;
 
  assign is_0 = (addr_i[ADDR_WIDTH-1 : ADDR_WIDTH-2] == 2'b00);
  assign is_1 = (addr_i[ADDR_WIDTH-1 : ADDR_WIDTH-2] == 2'b01);
  assign is_2 = (addr_i[ADDR_WIDTH-1 : ADDR_WIDTH-2] == 2'b10);
  assign is_3 = (addr_i[ADDR_WIDTH-1 : ADDR_WIDTH-2] == 2'b11);

  sp_ram
  #(
    .ADDR_WIDTH ( ADDR_WIDTH-2 ),
    .DATA_WIDTH ( DATA_WIDTH ),
    .NUM_WORDS  ( RAM_SIZE/4 )
  )
  sp_ram_0
  (
    .clk     ( clk       ),

    .en_i    ( en_i & is_0 ),
    .addr_i  ( addr_i[ADDR_WIDTH-3:0]  ),
    .wdata_i ( wdata_i  ),
    .rdata_o ( rdata_o_0  ),
    .we_i    ( we_i ),
    .be_i    ( be_i )
  );

  sp_ram
  #(
    .ADDR_WIDTH ( ADDR_WIDTH-2 ),
    .DATA_WIDTH ( DATA_WIDTH ),
    .NUM_WORDS  ( RAM_SIZE/4   )
   )
   sp_ram_1
   (
     .clk     ( clk       ),

     .en_i    ( en_i & is_1 ),
     .addr_i  ( addr_i[ADDR_WIDTH-3:0]  ),
     .wdata_i ( wdata_i ),
     .rdata_o ( rdata_o_1 ),
     .we_i    ( we_i ),
     .be_i    ( be_i  )
   );

  sp_ram
  #(
    .ADDR_WIDTH ( ADDR_WIDTH-2 ),
    .DATA_WIDTH ( DATA_WIDTH ),
    .NUM_WORDS  ( RAM_SIZE/4   )
   )
   sp_ram_2
   (
     .clk     ( clk       ),

     .en_i    ( en_i & is_2 ),
     .addr_i  ( addr_i[ADDR_WIDTH-3:0]  ),
     .wdata_i ( wdata_i ),
     .rdata_o ( rdata_o_2 ),
     .we_i    ( we_i ),
     .be_i    ( be_i  )
   );

  sp_ram
  #(
    .ADDR_WIDTH ( ADDR_WIDTH-2 ),
    .DATA_WIDTH ( DATA_WIDTH ),
    .NUM_WORDS  ( RAM_SIZE/4   )
   )
   sp_ram_3
   (
     .clk     ( clk       ),

     .en_i    ( en_i & is_3 ),
     .addr_i  ( addr_i[ADDR_WIDTH-3:0]  ),
     .wdata_i ( wdata_i ),
     .rdata_o ( rdata_o_3 ),
     .we_i    ( we_i ),
     .be_i    ( be_i  )
   );

   assign rdata_o = (is_0_q == 1'b1)? rdata_o_0 : (is_1_q == 1'b1)? rdata_o_1 : (is_2_q == 1'b1)? rdata_o_2 : rdata_o_3;

   always_ff @(posedge clk, negedge rstn_i)
   begin
     if (rstn_i == 1'b0)
      begin
       is_0_q <= 1'b0;
       is_1_q <= 1'b0;
       is_2_q <= 1'b0;
       is_3_q <= 1'b0;
      end
     else
      begin
       is_0_q <= is_0;
       is_1_q <= is_1;
       is_2_q <= is_2;
       is_3_q <= is_3;
      end
   end

`endif

endmodule
