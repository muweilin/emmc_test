
`include "config.sv"

module DW_memctl_top( 

`ifdef HAPS
//    OBS_PIN,
    hclk_4x,
`endif

                 // Outputs
                 hready_resp, 
                 hresp, 
                 hrdata, 
                 s_ras_n, 
                 s_cas_n, 
                 s_cke, 
                 s_addr, 
                 s_bank_addr, 
                 s_sel_n, 
                 s_dqm, 
                 s_we_n, 
                 s_sa, 
                 s_scl, 
                 s_rd_dqs_mask,
                                 
                 // Inputs
                 hclk, 
                 hclk_2x, 
                 hresetn, 
                 haddr, 
                 hsel_mem, 
                 hsel_reg, 
                 hwrite, 
                 htrans,
                 hsize, 
                 hburst, 
                 hready, 
                 hwdata, 
                 int_s_rd_dqs_mask,

                 // Inout
                 //s_dq,
                 //s_dqs,
                 //s_sda
                 
                s_dout_valid, // SDRAM Write Data/dqs En
               s_dqs_wr,   // SDRAM write dqs
               s_dqs_rd,   // SDRAM read dqs
               s_data_wr,  // SDRAM write data
               s_data_rd,  // SDRAM read data
  
                s_sda_out,    // Serial Presence Data Out
                s_sda_oe_n,   // Serial Presence Data Ena
                s_sda_in     // Serial Presence Data In
                 
                 ); 

`ifdef HAPS
//  output[47 : 0]    OBS_PIN;
  input             hclk_4x;
`endif

  input                                 hclk;         // System Clock
  input                                 hclk_2x;      // 2x Clock for DDR
  input                                 hresetn;      // System Reset
  input  [31:0]                         haddr;        // AHB Address Bus
  input                                 hsel_mem;     // AHB Select - Memory
  input                                 hsel_reg;     // AHB Select - Register
  input                                 hwrite;       // AHB Transfer Direction
  input  [1:0]                          htrans;       // AHB Transfer Type
  input  [2:0]                          hsize;        // AHB Transfer Size
  input  [2:0]                          hburst;       // AHB Burst Type
  output                                hready_resp;  // AHB Transfer Done - Out
  input                                 hready;       // AHB Transfer Done - In
  output [1:0]                          hresp;        // AHB Transfer Response
  input  [31:0]                         hwdata;       // AHB Write Data
  output [31:0]                         hrdata;       // AHB Read Data
  
  output                                s_ras_n;      // SDRAM row addr. select
  output                                s_cas_n;      // SDRAM column addr. sel
  output                                s_cke;        // SDRAM clock enable
  
  output [15:0]                         s_addr;       // SDRAM address
  output [1:0]                          s_bank_addr;  // SDRAM bank address
  output                                s_sel_n;      // SDRAM chip select
  output [1:0]                          s_dqm;        // SDRAM data mask
  
  output                                s_we_n;       // SDRAM write enable  
  
  output                                s_rd_dqs_mask;    // Read dqs mask
  input                                 int_s_rd_dqs_mask;// s_rd_dqs_mask routed outside to match the sclk and s_dqs path
  
  output [2:0]                          s_sa;         // Serial Presence Address
  output                                s_scl;        // Serial Presence Clock
  
  //inout
  //inout  [1:0]                          s_dqs;        // Data strobe to SDRAM
  //inout  [15:0]                         s_dq;         // SDRAM write/read data
  //inout                                 s_sda;        // Serial Presence Data In/out

  output[1:0]                           s_dout_valid; // SDRAM Write Data/dqs En
  output[1:0]                           s_dqs_wr;   // SDRAM write dqs
  input [1:0]                           s_dqs_rd;   // SDRAM read dqs
  output[15:0]                          s_data_wr;  // SDRAM write data
  input [15:0]                          s_data_rd;  // SDRAM read data
  
  output                                 s_sda_out;    // Serial Presence Data Out
  output                                 s_sda_oe_n;   // Serial Presence Data Ena
  input                                  s_sda_in;     // Serial Presence Data In
  
  // Internal Wires/Regs
  
  wire [31:0]                          s_rd_data;    // SDRAM read data
  //wire [15:0]                          s_wr_data;    // SDRAM write data
  

  wire                                 s_rd_start;   // Read burst start
  wire                                 s_rd_pop;     // Data pop signal for read data capture
  wire                                 s_rd_end;     // Read burst end
  
  //wire                                 s_sda_out;    // Serial Presence Data Out
  //wire                                 s_sda_oe_n;   // Serial Presence Data Ena
  //wire                                 s_sda_in;     // Serial Presence Data In

  wire [7:0]                           gpi;          // general purpose inputs
  wire [7:0]                           gpo;          // general purpose outputs

  wire                                 FstTestComplete;
  wire [7:0]                           IPRD;
  
  //wire [1:0]                           s_dqs_wr;  
    
    assign      gpi[0]      =  FstTestComplete;
    assign      gpi[7:1]    =  7'h0;


	//add 20161013
	//tri0 [1:0] s_dqs	;

    //assign      s_dqs[0]    =  s_dout_valid[0] ? {s_dqs_wr[0]} : {1'bz};
    //assign      s_dqs[1]    =  s_dout_valid[1] ? {s_dqs_wr[1]} : {1'bz};   
    
    //assign      s_dq[7:0]   =  s_dout_valid[0] ? {s_wr_data[7:0]}  : {8{1'bz}};
    //assign      s_dq[15:8]  =  s_dout_valid[1] ? {s_wr_data[15:8]} : {8{1'bz}};    
    
	//assign	s_sda_in = s_sda ;
	//assign	s_sda    =~s_sda_oe_n ? s_sda_out : 1'bz; 
	
	
    wire                                c_sel_n;      // SDRAM chip select
    wire                                c_cke;        // SDRAM clock enable
    wire                                c_ras_n;      // SDRAM row addr. select
    wire                                c_cas_n;      // SDRAM column addr. sel
    wire                                c_we_n;       // SDRAM write enable  
    wire [15:0]                         c_addr;       // SDRAM address
    wire [1:0]                          c_bank_addr;  // SDRAM bank address
	
	reg                                 r_sel_n     ;      // SDRAM chip select
    reg                                 r_cke       ;        // SDRAM clock enable
    reg                                 r_ras_n     ;      // SDRAM row addr. select
    reg                                 r_cas_n     ;      // SDRAM column addr. sel
    reg                                 r_we_n      ;       // SDRAM write enable  
    reg  [15:0]                         r_addr      ;       // SDRAM address
    reg  [1:0]                          r_bank_addr ;  // SDRAM bank address
	
	always@(negedge hclk or negedge hresetn)
	begin
	    if(~hresetn)
	    begin
	        r_sel_n     <= 1'b0;
	        r_cke       <= 1'b0;
	        r_ras_n     <= 1'b0;
	        r_cas_n     <= 1'b0;
	        r_we_n      <= 1'b0;
	        r_addr      <=16'b0;
	        r_bank_addr <= 2'b0;
	    end
	    else
	    begin
	        r_sel_n     <= c_sel_n     ;
	        r_cke       <= c_cke       ;
	        r_ras_n     <= c_ras_n     ;
	        r_cas_n     <= c_cas_n     ;
	        r_we_n      <= c_we_n      ;
	        r_addr      <= c_addr      ;
	        r_bank_addr <= c_bank_addr ;
	    end
	end
	
	assign s_sel_n     = r_sel_n     ;
	assign s_cke       = r_cke       ;
	assign s_ras_n     = r_ras_n     ;
	assign s_cas_n     = r_cas_n     ;
	assign s_we_n      = r_we_n      ;
	assign s_addr      = r_addr      ;
	assign s_bank_addr = r_bank_addr ;
	
	
	
`ifdef HAPS_DEBUG

wire [1:0]   dly_dqs_probe      ;
wire [1:0] reg_bank_clk_probe  ;  

    
`endif
	
	
	
  RdData_Sample u_rddata_sample[1:0](
  
`ifdef HAPS
//                .obs                    ({obs_sample1,obs_sample0}),
                .hclk_4x                     (hclk_4x),
            //    .hclk_2x(hclk_2x),
                
                
`endif 
`ifdef HAPS_DEBUG
                .dly_dqs_proc                ({dly_dqs_probe[1:0]}     ),     
                .reg_bank_clk_proc           ({reg_bank_clk_probe[1:0]}),
`endif
  
                // Outputs
                .s_rd_data              ({s_rd_data[31:24],s_rd_data[15:8],s_rd_data[23:16],s_rd_data[7:0]}),
                                 
                // Inputs
                .hclk                   (hclk),
                .hresetn                (hresetn),
                .IPRD                   (IPRD),
                .int_s_rd_dqs_mask      (s_rd_dqs_mask),
                .SampleEn               (gpo[0]),
                .s_rd_start             (s_rd_start),
                .s_rd_pop               (s_rd_pop),
                .s_rd_end               (s_rd_end),

                // Inout
                .int_s_dq               ({s_data_rd[15:0]}),
                .s_dqs                  ({s_dqs_rd[1:0]})
    );
        

  MDLR u_mdlr  (
	             .Clock                 (hclk),
	             .Reset_L               (hresetn),
	             .TimerCfg              (5'b11111),
	             .TestFinsh             (),
	             .TestType              (),
	             .IPRD                  (IPRD),
	             .TPRD                  (),
	             .FstTestComplete       (FstTestComplete),
	             .MDLR_State            ()
                );
  
  
  
  
  DW_memctl u_dw_memctl( 
                 // Outputs
                 .hready_resp           (hready_resp), 
                 .hresp                 (hresp), 
                 .hrdata                (hrdata), 
                 .s_ras_n               (c_ras_n), 
                 .s_cas_n               (c_cas_n), 
                 .s_cke                 (c_cke), 
                 .s_wr_data             (s_data_wr), 
                 .s_addr                (c_addr), 
                 .s_bank_addr           (c_bank_addr), 
                 .s_dout_valid          (s_dout_valid), 
                 .s_sel_n               (c_sel_n), 
                 .s_dqm                 (s_dqm), 
                 .s_we_n                (c_we_n), 
                 .s_dqs                 (s_dqs_wr), 
                 .s_sa                  (s_sa), 
                 .s_scl                 (s_scl), 
                 .s_rd_ready            (1'b0), 
                 .s_rd_start            (s_rd_start), 
                 .s_rd_pop              (s_rd_pop), 
                 .s_rd_end              (s_rd_end), 
                 .s_rd_dqs_mask         (s_rd_dqs_mask), 
                 .s_cas_latency         (), //not to be connected
                 .s_read_pipe           (), //not to be connected
                 .s_sda_out             (s_sda_out), 
                 .s_sda_oe_n            (s_sda_oe_n), 
                 .gpo                   (gpo),
                 
                 // Debug signals for testing / not to be connected
                 .debug_ad_bank_addr    (),
                 .debug_ad_row_addr     (),
                 .debug_ad_col_addr     (),
                 .debug_ad_sf_bank_addr (),
                 .debug_ad_sf_row_addr  (), 
                 .debug_ad_sf_col_addr  (),
                 .debug_hiu_addr        (),
                 .debug_sm_burst_done   (),
                 .debug_sm_pop_n        (),
                 .debug_sm_push_n       (),
                 .debug_smc_cs          (),
                 .debug_ref_req         (),                  
                 // Inputs
                 .hclk                  (hclk), 
                 .hclk_2x               (hclk_2x), 
                 .hresetn               (hresetn), 
                 .scan_mode             (1'b0), 
                 .haddr                 (haddr), 
                 .hsel_mem              (hsel_mem), 
                 .hsel_reg              (hsel_reg), 
                 .hwrite                (hwrite), 
                 .htrans                (htrans),
                 .hsize                 (hsize), 
                 .hburst                (hburst), 
                 .hready                (hready), 
                 .hwdata                (hwdata), 
                 .s_rd_data             (s_rd_data), 
                 .s_sda_in              (s_sda_in), 
                 .gpi                   (gpi), 
                 .remap                 (1'b0), 
                 .power_down            (1'b0), 
                 .clear_sr_dp           (1'b0),  
                 .big_endian            (1'b0)
                 ); 
                 
`ifdef HAPS_DEBUG

xilinx_ila_debug_ddr sig_debug_ddr
  (
    .clk     ( hclk_4x        ), 
    .probe0  ( dly_dqs_probe[0]  ), //push 
    .probe1  ( s_data_rd[7:0] ), // width = 8
    .probe2  ( dly_dqs_probe[1]  ),  
    .probe3  ( s_data_rd[15:8] ), // width = 8 
    .probe4  ( s_addr      ),   //width = 16
    .probe5  ( s_bank_addr ),  // width = 2
    .probe6  ( reg_bank_clk_probe[0] ),  // width = 1
    .probe7  ( reg_bank_clk_probe[1] ),  // width = 1
    .probe8  ( s_dqs_rd[0] ),  // width = 1 
    .probe9  ( s_dqs_rd[1] ),  // width = 1 
    .probe10 ( int_s_rd_dqs_mask ),  // width = 1 
    .probe11 ( {s_ras_n,s_cas_n,s_we_n} ),  // width = 1 
    .probe12 (hclk_2x),
    .probe13 (hclk)
       
  );

`endif

endmodule 

module RdData_Sample(

`ifdef HAPS
//        obs ,
        hclk_4x,
              
`endif

`ifdef HAPS_DEBUG
        dly_dqs_proc,     
        reg_bank_clk_proc,
`endif

                // Outputs
                s_rd_data,
                                 
                // Inputs
                hclk,
                hresetn,
                IPRD,
                int_s_rd_dqs_mask,
                SampleEn,
                s_rd_start,
                s_rd_pop,
                s_rd_end,

                // Inout
                int_s_dq,
                s_dqs
    );

`ifdef HAPS
//  output[17: 0] obs ;
  input         hclk_4x;
   
`endif

`ifdef HAPS_DEBUG
  output        dly_dqs_proc;
  output        reg_bank_clk_proc;
`endif

  input                                hclk;
  input                                hresetn;
  input   [7:0]                        IPRD;
  input                                int_s_rd_dqs_mask;
  input                                SampleEn;
  input                                s_rd_start;
  input                                s_rd_pop;
  input                                s_rd_end;
        
  output  [15:0]                       s_rd_data;

  input   [7:0]                        int_s_dq;
  input                                s_dqs;


  // Internal Wires/Regs
`ifdef HAPS
  reg   dly_dqs_tmp,     dly_dqs;
  reg   reg_bank_clk_tmp,reg_bank_clk_tmp1,reg_bank_clk,reg_bank_clk_tmp_h;
(* dont_touch = "yes" *)  wire  dly_dqs_proc;
(* dont_touch = "yes" *)  wire  reg_bank_clk_proc;
`else
  wire                                 dly_dqs,dly_dqs_proc;
  wire                                 reg_bank_clk,reg_bank_clk_proc;
`endif
    
  reg [1:0]                            sel; 
  reg [2:0]                            en;

  reg [7:0]                            r_int_s_dq;
  reg [15:0]                           int_s_rd_data;
  reg [15:0]                           rd_data0,rd_data1,rd_data2;  


    always @ (posedge hclk or negedge hresetn)
    begin
        if(~hresetn)
            sel[1:0] <= 2'b00;
        else 
        begin
            if(s_rd_end)
               sel[1:0] <= 2'b00;
            else if(s_rd_pop & (sel[1:0] == 2'b10))
                sel[1:0] <= 2'b00;
            else if(s_rd_pop)
                sel[1:0] <= sel[1:0] + 1;
        end
    end
    
    wire reg_rst_n = hresetn & (~s_rd_start);

    always @ (posedge reg_bank_clk or negedge reg_rst_n)
    begin
        if(~reg_rst_n)
            en[2:0] <= 3'b001;
        else
        begin
            if(en[2:0] == 3'b001)
                en[2:0] <= 3'b010;
            else if(en[2:0] == 3'b010)
                en[2:0] <= 3'b100;
            else if(en[2:0] == 3'b100)
                en[2:0] <= 3'b001;
        end
    end


`ifdef HAPS
    
    always@(negedge hclk_4x or negedge hresetn)
    begin
        if(~hresetn)
        begin
            dly_dqs_tmp         <= 1'b0;
            
            reg_bank_clk_tmp    <= 1'b1;
            reg_bank_clk        <= 1'b1;
        end
        else
        begin
            dly_dqs_tmp         <= s_dqs ;
            
            reg_bank_clk_tmp    <= !(s_dqs & int_s_rd_dqs_mask) ;
            reg_bank_clk        <= reg_bank_clk_tmp1;
        end
    end
    
    always@(posedge hclk_4x or negedge hresetn)
    begin
        if(~hresetn)
        begin
            dly_dqs         <= 1'b0;
            
            reg_bank_clk_tmp1    <= 1'b1;
            reg_bank_clk_tmp_h <=1'b1;
        end
        else
        begin
            dly_dqs         <= dly_dqs_tmp ;
            
            reg_bank_clk_tmp_h    <= reg_bank_clk_tmp ;
            reg_bank_clk_tmp1    <= reg_bank_clk_tmp_h ;
           // reg_bank_clk_tmp1    <= reg_bank_clk_tmp ;
        end
    end
    
    assign      dly_dqs_proc        = dly_dqs & SampleEn;
    assign      reg_bank_clk_proc   = reg_bank_clk & SampleEn;
    
`else
    
    assign      dly_dqs_proc        = SampleEn & dly_dqs ;
    assign      reg_bank_clk_proc   = SampleEn & reg_bank_clk ;
    	
	DLL_DELAY_LINE_256	u_dqs_delay(
                    .o_DLLout           (dly_dqs),
                    .i_DLLin            (),
                    .sel_index          (IPRD>>1)
		            );

    DLL_DELAY_LINE_256	u_dqs_mask_delay(
                    .o_DLLout           (reg_bank_clk),
                    .i_DLLin            (!(s_dqs && int_s_rd_dqs_mask)),
                    .sel_index          (IPRD)
		            );
`endif

    always @ (posedge dly_dqs_proc or negedge hresetn)
    begin
        if(~hresetn)
            r_int_s_dq <= 8'h0;
        else 
        begin
            r_int_s_dq <= int_s_dq;
        end
    end

    always @ (negedge dly_dqs_proc or negedge hresetn)
    begin
        if(~hresetn)
            int_s_rd_data <= 16'h0;
        else 
        begin
            int_s_rd_data <= {int_s_dq,r_int_s_dq};
        end
    end

    always @ (posedge reg_bank_clk_proc or negedge hresetn)
    begin
        if(~hresetn)
        begin
            rd_data0 <= 16'h0;
            rd_data1 <= 16'h0;
            rd_data2 <= 16'h0;
        end
        else 
        begin
            if(en[0])
                rd_data0 <= int_s_rd_data;
            if(en[1])
                rd_data1 <= int_s_rd_data;
            if(en[2])
                rd_data2 <= int_s_rd_data;
        end
    end
    
    
    assign      s_rd_data   = (sel[1:0]==2'b00) ? rd_data0 :
                              (sel[1:0]==2'b01) ? rd_data1 : 
                                                  rd_data2;


endmodule 
