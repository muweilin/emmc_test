
`include "config.sv"

module ahb_ann (

	  hclk,
	  hresetn,

    // AHB master signals
    ahbm_hresp,
    ahbm_hgrant,
    ahbm_hready_in, 
    ahbm_hbusreq,
    ahbm_htrans,
    ahbm_hwrite,
    ahbm_hsize,
    ahbm_hburst,
    ahbm_haddr,
    ahbm_hwdata,
	  ahbm_hrdata, 
	  ahbm_hprot,
	  ahbm_hlock,

    // AHB slave signals
	  ahbs_hsel,
	  ahbs_haddr,
	  ahbs_htrans,
	  ahbs_hwrite,
	  ahbs_hsize,
	  ahbs_hburst,
	  ahbs_hwdata,
	  ahbs_hrdata,
	  ahbs_hready_out,
	  ahbs_hresp,
	  ahbs_hready_in,

    /* Fabric IOs */ 
     interrupt
    

     );



// AHB & APB interface signals
input 			    hclk; 
input 			    hresetn;
output 	[31:0] 	ahbm_haddr;
output 	[1:0] 	ahbm_htrans;
output 			    ahbm_hwrite;
output 	[2:0] 	ahbm_hsize;
output 	[2:0] 	ahbm_hburst;
output 	[31:0] 	ahbm_hwdata;
input 	[31:0] 	ahbm_hrdata;
input 			    ahbm_hready_in;
input 			    ahbs_hready_in;
input 	[1:0] 	ahbm_hresp;
output 			    ahbm_hbusreq;
input 			    ahbm_hgrant ;
input 			    ahbs_hsel   ;
input 	[31:0] 	ahbs_haddr  ;
input 	[1:0] 	ahbs_htrans ;
input 			    ahbs_hwrite ;
input 	[2:0] 	ahbs_hsize  ;
input 	[2:0] 	ahbs_hburst ;
input 	[31:0] 	ahbs_hwdata ;
output 	[31:0] 	ahbs_hrdata ;
output 			    ahbs_hready_out ;
output 	[1:0] 	ahbs_hresp      ;
output          interrupt       ;
output  [3:0]   ahbm_hprot      ;
output          ahbm_hlock      ;


// AHB master
wire 	[3:0] 	ahbm_hprot;
wire          ahbm_hlock;
wire 	[3:0] 	ahbs_hprot;
wire          interrupt0;
wire          interrupt1;
wire  [9:0]   input_count ;
wire  [9:0]   output_count;



// Tied to Low (Unused Signals)
assign ahbm_hprot = 4'b0001;
assign ahbm_hlock = 0     ;


wire 			start;
wire      init_ram;
wire 			int_en;
wire 			dma_en;
wire 			int_clr;


// State Machine Interface (Bus Side)
wire			req_done;
wire	 		rd_req;
wire			wr_req;


// FIFO Interface
wire	[31:0]  dataout;			// Data Out to Read FIFO
wire	[31:0]	datain;				// Data In from Write FIFO
wire	 		ahb_push;
wire			ahb_pop;
wire			ahb_full;
wire			app_pop;
wire	 		app_empty;
wire	[31:0]	app_datain;			// Data In to Application

// From DMA Register          
wire	[31:0]  src_addr;
wire	[31:0]  dst_addr;          
wire	[4:0]	  block_size;			// Number of words per block


wire  [31:0] weight_depth      ; 
wire  [31:0] bias_depth        ;
wire  [31:0] im_depth          ;
wire  [31:0] sig_depth         ;
wire  [31:0] npu_datain_depth  ;
wire  [31:0] npu_dataout_depth ;

wire  [31:0]npu_din     ;  
wire        npu_enq     ;  
wire        npu_deq     ;  
wire  [31:0]npu_dout    ;  
wire  npu_dout_valid    ;
wire  npu_full          ;
wire  stop   ;
wire  clear;

wire  [20:0] ram_din    ;
wire  [13:0] ram_reg_adr;
wire  [5 :0] ram_mem_adr;
wire         ram_we     ;

wire wait_in         ;
wire disable_rdreq   ;
wire wrt_req_en      ;
wire rd_update       ;
wire wr_update       ;
wire int_en_init     ;
wire int_en_npu      ;
wire [31:0] residue_out_cnt ;


assign interrupt = interrupt0 || interrupt1;
//assign clear     = start || init_ram;
ahb_master ahb_master
   (
     // AHB Master Interface
	  .hclk(hclk),
	  .hreset(hresetn),

    .hready_i(ahbm_hready_in),
    .hresp_i(ahbm_hresp),
    .hgrant_i(ahbm_hgrant),

    .hbusreq_o(ahbm_hbusreq),
    .htrans_o(ahbm_htrans),
    .hwrite_o(ahbm_hwrite),
    .hsize_o(ahbm_hsize),
    .hburst_o(ahbm_hburst),

    .haddr_o(ahbm_haddr),
    .hwdata_o(ahbm_hwdata),
	  .hrdata_i(ahbm_hrdata),

	  // State Machine Interface
	  .req_done(req_done),
	  .rd_req(rd_req),
	  .wr_req(wr_req),

	  // FIFO Interface
    .dataout(dataout),
	  .datain(npu_dout),
	  .push(ahb_push),
	  .pop(ahb_pop),
	  .npu_output_count(output_count),
	 // .residue_mode(residue_mode),

    // From DMA Register          
    .src_addr(src_addr),
    .dst_addr(dst_addr),          
	  .block_size(block_size)
	
  );


busreq_sm busreq_sm (
	.hclk(hclk),
	.hreset(hresetn),
	.dma_en(dma_en),
	.req_done(req_done),
	.full(ahb_full),
	//.input_data_en (input_data_en),
	.wait_in(wait_in),
	.pre_ram(pre_ram),
	.disable_rdreq(disable_rdreq),
	.wrt_req_en(wrt_req_en),
	.rd_req(rd_req),
	.wr_req(wr_req),
	.rd_update(rd_update),
	.wr_update(wr_update)
);

fifo in_fifo (
	.clock(hclk),
	.reset(hresetn),
  .clear(clear),
	.push(pre_ram&&ahb_push&&dma_en),
	.pop(app_pop),
	.full(ahb_full),
	.empty(app_empty),
	.wait_in(wait_in),
	.block_size(block_size),
	
	.din(dataout),
	.dout(app_datain)
);




ahb_slave ahb_slave (
	.hclk(hclk),
	.hreset(hresetn),
	.ahbs_hsel(ahbs_hsel),
	.ahbs_haddr(ahbs_haddr),
	.ahbs_htrans(ahbs_htrans),
	.ahbs_hwrite(ahbs_hwrite),
	.ahbs_hsize(ahbs_hsize),
	.ahbs_hburst(ahbs_hburst),
	.ahbs_hprot(ahbs_hprot),
	.ahb_hready_in(ahbm_hready_in),
	.ahbs_hwdata(ahbs_hwdata),
	.ahbs_hrdata(ahbs_hrdata),
	.ahbs_hready_out(ahbs_hready_out),
	.ahbs_hresp(ahbs_hresp),

// DMA Registers
  .src_addr(src_addr),
  .dst_addr(dst_addr),       
	.block_size(block_size),
	.rd_update(rd_update),
	.wr_update(wr_update),
  
  .weight_depth      (weight_depth     ),
  .bias_depth        (bias_depth       ),
  .im_depth          (im_depth         ),
  .sig_depth         (sig_depth        ),
  .npu_datain_depth  (npu_datain_depth ),
  .npu_dataout_depth (npu_dataout_depth),
  .residue_out_cnt(residue_out_cnt),


// Application
	.start(start),
	.init_ram(init_ram),
	.stop(stop),
	.int_en_init(int_en_init),
	.int_en_npu (int_en_npu ),
	.dma_en(dma_en),
	.int_clr(int_clr),
	.interrupt0(interrupt0),
	.interrupt1(interrupt1)
	);
	
npu_if_crl npu_if_crl_en (
	.hreset(hresetn),
	.clk(hclk), 
	
	.fifo_empty(app_empty),
	.datain(app_datain), 
	.datain_ahb(dataout),
	.ahb_push(ahb_push&&dma_en),
	.pop(app_pop),
	.pre_ram(pre_ram),
//	.push(app_push),

	.disable_rdreq(disable_rdreq),
	.weight_depth     (weight_depth     ) ,   
	.bias_depth       (bias_depth       ) ,   
	.im_depth         (im_depth         ) ,   
	.sig_depth        (sig_depth        ) ,   
	.npu_datain_depth (npu_datain_depth ) ,   
	.npu_dataout_depth(npu_dataout_depth) , 
	.input_data_en_d (input_data_en),
	.init_ram(init_ram),
	.start(start),  
	.stop(stop),
	.int_en_init(int_en_init),
	.int_en_npu (int_en_npu ), 
  .int_clr(int_clr),
  .interrupt0(interrupt0), 
  .interrupt1(interrupt1), 
  .clear(clear),
  .wrt_req_en(wrt_req_en),
	/////////////////(/////////////////)/////
	.npu_en           (npu_en            ) ,                
	.npu_din          (npu_din          ) ,              
	.npu_enq          (npu_enq          ) ,              
	.npu_deq          (ahb_pop          ) ,
	.output_count     (output_count     ) ,            
	.residue_out_cnt   (residue_out_cnt),   
	.npu_full         (npu_full         ) ,             
   
	// ram-specific p// ram-specific ports 
	.ram_din          (ram_din          ) ,              
	.ram_reg_adr      (ram_reg_adr      ) ,          
	.ram_mem_adr      (ram_mem_adr      ) ,          
	.ram_we           (ram_we           )     
	
	);
	
	
	new_npu uut (
            .CLK(hclk),
            .RST_N(hresetn),
            .npu_en(npu_en),
            .npu_din       (npu_din       ),
            .npu_enq       (npu_enq       ),
            .npu_deq       (ahb_pop       ),
            .npu_dout      (npu_dout      ),
            .npu_dout_valid(npu_dout_valid),
            .npu_full      (npu_full      ),
            .input_data_en_d (input_data_en),
            .input_count   (input_count   ),
            .output_count  (output_count  ),
            // ram-specific ports
            .ram_din    (ram_din    ),
            .ram_reg_adr(ram_reg_adr),
            .ram_mem_adr(ram_mem_adr),
            .ram_we     (ram_we      )
        );


 
//integer finput;
//initial finput = $fopen("meminit_input_vector.txt");
//
//integer foutput;
//initial foutput = $fopen("meminit_output_vector.txt");
//
//integer framinput;
//initial framinput = $fopen("meminit_raminput_vector.txt");
//
//always @(posedge hclk)
//	begin
//		
//
//		if(ahb_pop)
//		begin
//			$fdisplay(foutput, "%x", npu_dout);
//				$fflush(foutput);
//		end
//		
//		if(npu_enq)
//		begin
//			$fdisplay(finput, "%x", npu_din);
//				$fflush(finput);
//		end
//
//		if (ram_we)
//		begin
//			$fdisplay(framinput,"%x %x %x", ram_din, ram_reg_adr, ram_mem_adr);
//				$fflush(framinput);
//		end
//	end


endmodule
      
