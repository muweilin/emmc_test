

`define IDLE_ST  2'b00
`define RD_OP_ST 2'b01
`define WR_OP_ST 2'b10

//(* dont_touch = "yes" *) 
module ahb_slave (
	hclk,
	hreset,
// AHB Slave Signals
	ahbs_hsel,
	ahbs_haddr,
	ahbs_htrans,
	ahbs_hwrite,
	ahbs_hsize,   // unused inputm
	ahbs_hburst,  // unused input
	ahbs_hprot,   // unused input
	ahb_hready_in,
	ahbs_hwdata,
	ahbs_hrdata,
	ahbs_hready_out,
	ahbs_hresp,
// DMA Registers
    rd_update,
    wr_update,
    src_addr,
    dst_addr,          
	block_size,

// npu parameter
   weight_depth     ,
   bias_depth       ,
   im_depth         ,
   sig_depth        ,
   npu_datain_depth ,
   npu_dataout_depth,
   residue_out_cnt,


// control signals
	start,
	init_ram,
	//stop,
	int_en_init,
	int_en_npu ,
	dma_en,
	int_clr,
	stop,
	interrupt0,
	interrupt1
	);

input  			hclk;
input  			hreset;

input  			ahbs_hsel;
input  	 [31:0] ahbs_haddr;
input  	 [1:0] 	ahbs_htrans;
input  			    ahbs_hwrite;
input  	 [2:0] 	ahbs_hsize;
input  	 [2:0] 	ahbs_hburst;
input  	 [3:0] 	ahbs_hprot;
input  			ahb_hready_in;
input  	 [31:0] ahbs_hwdata;
output   [31:0] ahbs_hrdata;
output  		ahbs_hready_out;
output 	 [1:0] 	ahbs_hresp;

/***** Signals for User Application	*****/
// DMA Registers
input			rd_update;
input			wr_update;
input     interrupt0;
input     interrupt1;
input    [31:0] residue_out_cnt;
output   [31:0] src_addr;
output   [31:0] dst_addr;          
output   [4:0]	block_size;
output   [31:0] weight_depth      ;
output   [31:0] bias_depth        ;
output   [31:0] im_depth          ;
output   [31:0] sig_depth         ;
output   [31:0] npu_datain_depth  ;
output   [31:0] npu_dataout_depth ;


output      init_ram;
output			start;
output			int_en_init; 
output      int_en_npu ;
output			dma_en;			      // dma enable
output			int_clr;          // interrupt clear
output      stop;		      


wire 			hclk;
wire 			hreset;

wire 			    ahbs_hsel;
wire 	[31:0] 	ahbs_haddr;
wire 	[1:0] 	ahbs_htrans;
wire 			    ahbs_hwrite;
wire 	[2:0] 	ahbs_hsize;
wire 	[2:0] 	ahbs_hburst;
wire 	[3:0] 	ahbs_hprot;
wire 	[31:0] 	ahbs_hwdata;
reg 	[31:0] 	ahbs_hrdata;
wire  			  ahbs_hready_out;
wire 	[1:0] 	ahbs_hresp;

reg		 [31:0] src_addr;
reg		 [31:0] dst_addr; 
reg		 [31:0] weight_depth     ;
reg		 [31:0] bias_depth       ;
reg		 [31:0] im_depth         ;
reg		 [31:0] sig_depth        ;
reg		 [31:0] npu_datain_depth ;
reg		 [31:0] npu_dataout_depth;
         
reg		 [4:0]	block_size;

reg       init_ram;
reg 			start;
reg 			int_en_init;
reg       int_en_npu ;
reg 			dma_en;
reg 			int_clr;
reg       npu_end;
reg       init_end;
reg       npu_on;
reg       init_on;
reg       stop;
reg       align_cnt;
reg	      flag;



reg  	[1:0]       curr_state;	   // State Machine for Read and Write.
reg  	[1:0]       next_state;
reg  	            prevsel;
reg  	[13:0]      ahbs_haddr_reg;

// read/write registers and latches
reg 	  rd_enable;

// For this design ahbs_hready_out is always high.
assign 	ahbs_hready_out = 1;
assign  ahbs_hresp = 2'b00;

wire	  sel_ctrl;


assign  sel_ctrl  = (ahbs_hsel && ahbs_htrans[1]);


always @ (posedge hclk or negedge hreset)
   begin
      if (!hreset)
	    begin 
      		prevsel    <=  0;
			ahbs_haddr_reg <=  14'h0000;
		end
   else
		begin
      		prevsel    <=  sel_ctrl;
			ahbs_haddr_reg <=  ahbs_haddr[13:0];
		end
   end

// FSM for Register R/W begins

always @ (posedge hclk or negedge hreset)
   begin
      if (!hreset)
         curr_state <= `IDLE_ST;
      else
         curr_state <=  next_state;
end

always @ (ahbs_hsel or ahb_hready_in or ahbs_hwrite or curr_state or ahbs_htrans)
   begin
      case(curr_state)
      `IDLE_ST : begin
                   // if (ahbs_hsel  == 1'b1 && 
                   //     ahb_hready_in == 1'b1 && 
                   //     ahbs_hwrite    == 1'b0 && 
                   //     ahbs_htrans[1] == 1'b1)   // Read Operation starts in the next state.
                   //     
                   //     next_state = `RD_OP_ST;
                   // else 
                    if (ahbs_hsel  == 1'b1 && 
                             ahb_hready_in == 1'b1 && 
                             ahbs_hwrite    == 1'b1 && 
                             ahbs_htrans[1]  == 1'b1)    // Write Operation starts 
                                                   // if not goes for Read.
	                  			   next_state = `WR_OP_ST;
	                  else 	   next_state = `IDLE_ST;
                 end

     // `RD_OP_ST : begin          
     //               	if (ahbs_hsel  == 1'b1 && 
     //                    ahb_hready_in == 1'b1 && 
     //                    ahbs_hwrite    == 1'b1 && 
     //                    ahbs_htrans[1]  == 1'b1)         // Write Operation Starts
     //                    
	   //                    next_state = `WR_OP_ST;
     //               else if (ahbs_hsel  == 1'b1 && 
     //                        ahb_hready_in == 1'b1 && 
     //                        ahbs_hwrite    == 1'b0 && 
     //                        ahbs_htrans[1]  == 1'b1)     // Back to Back Read
     //                        
	   //                        next_state = `RD_OP_ST;
	   //               else     next_state = `IDLE_ST;
     //            end

      `WR_OP_ST : begin
	                  // if (ahbs_hsel    == 1'b1 && 
                    //           ahb_hready_in  == 1'b1 && 
                    //           ahbs_hwrite  == 1'b0 && 
                    //           ahbs_htrans[1] == 1'b1)       // Read Opeartion Starts 
	                  //       next_state = `RD_OP_ST;
                        //   else 
                           if (ahbs_hsel == 1'b1 && 
                                    ahb_hready_in  == 1'b1 && 
                                    ahbs_hwrite  == 1'b1 && 
                                    ahbs_htrans[1] == 1'b1)  // Back to Back Write
	                          next_state = `WR_OP_ST;
                           else 
                              next_state = `IDLE_ST;
                   end

      default : begin
                  next_state = `IDLE_ST;
                end

   endcase
end // FSM ends

always @ (posedge hclk or negedge hreset)
   begin
    if (!hreset)
       rd_enable <=  1'b0;
    else
       if (ahbs_hsel == 1'b1 && 
           ahb_hready_in == 1'b1 && 
           ahbs_hwrite == 1'b0)
          rd_enable <=  1'b1;
       else
          rd_enable <=  1'b0;
  end

always @ (*) 
   begin
   if ((rd_enable == 1'b1) &&  prevsel)
      begin
         case(ahbs_haddr_reg[5:2])		// Reading Data from internal memory
         	4'b0000 : ahbs_hrdata <=  {27'b0, stop, int_clr, dma_en, init_ram, start};
         	4'b0001 : ahbs_hrdata <=  {30'b0,int_en_init, int_en_npu};
         	4'b0010 : ahbs_hrdata <=  src_addr;
         	4'b0011 : ahbs_hrdata <=  dst_addr;
         	4'b0100 : ahbs_hrdata <=  {27'b0, block_size}; 
         	4'b0101 : ahbs_hrdata <=  weight_depth     ;
         	4'b0110 : ahbs_hrdata <=  bias_depth       ;
         	4'b0111 : ahbs_hrdata <=  im_depth         ;
         	4'b1000 : ahbs_hrdata <=  sig_depth        ;
         	4'b1001 : ahbs_hrdata <=  npu_datain_depth ;
         	4'b1010 : ahbs_hrdata <=  npu_dataout_depth;   
         	4'b1011 : ahbs_hrdata <=  {30'b0, npu_end, init_end}; 
         	4'b1100 : ahbs_hrdata <=  {30'b0, npu_on, init_on};       	
         	
            default  : ahbs_hrdata <=   32'b0;
         endcase
      end
    else
         ahbs_hrdata <= 32'b0;
   end

always @ (posedge hclk or negedge hreset)
begin
	if (~hreset) begin
     {stop, int_clr, dma_en, init_ram, start}  <=  5'b0;
     {int_en_init, int_en_npu}           <=  2'b11;
     {npu_end, init_end}                 <=  2'b0;
     {npu_on, init_on}                   <=  2'b0;
		 src_addr                            <=  32'b0;
		 dst_addr                            <=  32'b0;
		 {block_size}                        <=  5'b0;
		 weight_depth                        <=  32'b0;
		 bias_depth                          <=  32'b0;
		 im_depth                            <=  32'b0;
		 sig_depth                           <=  32'b0;
		 npu_datain_depth                    <=  32'b0;
		 npu_dataout_depth                   <=  32'b0;
		 align_cnt <=0;
	   flag <= 0;
	end else if(stop)
	begin
		{stop, int_clr, dma_en, init_ram, start}  <=  5'b0;
     {int_en_init, int_en_npu}     <=  2'b11;
     {npu_end, init_end}                 <=  2'b0;
     {npu_on, init_on}                   <=  2'b0;
		 src_addr                            <=  32'b0;
		 dst_addr                            <=  32'b0;
		 {block_size     }                   <=  5'b0;
		 weight_depth                        <=  32'b0;
		 bias_depth                          <=  32'b0;
		 im_depth                            <=  32'b0;
		 sig_depth                           <=  32'b0;
		 npu_datain_depth                    <=  32'b0;
		 npu_dataout_depth                   <=  32'b0;
		 align_cnt <=0;
	   flag <= 0;
	end
	else 
	begin
	   if(start == 1) begin
	   	  start <= 0;
	   	  npu_on <= 1;
	   	  align_cnt <=0;
	      flag <= 0;
	   end
	   if(init_ram == 1) begin
	   	  init_ram <= 0;
	   	  init_on  <= 1;
	   end
	   
	   if(int_clr == 1) begin
	   	  int_clr <= 0;
		    
	   end
	   
	   if(interrupt0) begin
	   	  init_end <= 1;
	   	  init_on  <= 0;
	   	  dma_en   <= 0;
	   end else if(interrupt1)
	   begin
	   	  npu_end  <= 1;
	   	  npu_on   <= 0;
	   	  dma_en   <= 0;
	   	end else begin
	   		npu_end <= 0;
	   		init_end <=0;
	   	end
	   		   	
	if ((curr_state == `WR_OP_ST) && prevsel) begin
        case(ahbs_haddr_reg[5:2])	// Writing Data to internal memory
           4'b0000 : {stop,int_clr, dma_en, init_ram, start} <= ahbs_hwdata[4:0];
           4'b0001 : {int_en_init, int_en_npu}    <= ahbs_hwdata[1:0];
           4'b0010 : src_addr                           <= ahbs_hwdata;
           4'b0011 : dst_addr                           <= ahbs_hwdata;         
           4'b0100 : {block_size}                       <= ahbs_hwdata[20:0];
           4'b0101 : weight_depth                       <= ahbs_hwdata;
           4'b0110 : bias_depth                         <= ahbs_hwdata;
           4'b0111 : im_depth                           <= ahbs_hwdata; 
           4'b1000 : sig_depth                          <= ahbs_hwdata; 
           4'b1001 : npu_datain_depth                   <= ahbs_hwdata;
           4'b1010 : npu_dataout_depth                  <= ahbs_hwdata;  
          /* 4'b1011 : begini
           						if(ahbs_hwdata[0])
           							init_end <= 0;
           						if(ahbs_hwdata[1])
                        npu_end  <= 0;   
                     end */         
            default : ;
		endcase
	end
	else begin 
	//align_cnt <=0;
	//flag <= 0;
		if (rd_update) begin
			src_addr    <=  src_addr + {block_size, 2'b0};
			
		end
		if (wr_update) begin
		  if(residue_out_cnt==8 ) align_cnt <=1;
		  if((residue_out_cnt<8 ) && !align_cnt) flag <= 1;
			if((residue_out_cnt<8 && (flag == 1 || align_cnt))|| npu_dataout_depth==8  || npu_dataout_depth<8) 
				dst_addr    <=  dst_addr + 6'b100;
			else 
				dst_addr    <=  dst_addr + 6'b100000;
		end
	end
	end
end



endmodule
