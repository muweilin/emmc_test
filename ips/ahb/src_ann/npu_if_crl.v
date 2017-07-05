


//(* dont_touch = "yes" *) 
module npu_if_crl (
		hreset,
		clk, 
		datain,		
		pop,
		fifo_empty,
		disable_rdreq,
		wrt_req_en,
		datain_ahb,
		ahb_push,
		pre_ram,
		/////////////////////////////
		weight_depth      ,
		bias_depth        ,
		im_depth          ,
		sig_depth         ,
		npu_datain_depth  ,
		npu_dataout_depth ,
		input_data_en_d,
		start,
		stop,
		init_ram,	
		int_clr,
		int_en_init,
		int_en_npu,
		//err_int_en, 
		//err_int, 	
		interrupt0,
		interrupt1,
		clear,
		////////////////////////////
    npu_en,
    npu_din,
    npu_enq,
    npu_deq,
    output_count, 
    residue_out_cnt,  
    npu_full,  
    ram_din,
    ram_reg_adr,
    ram_mem_adr,
    ram_we
		);
// ******************************************************
// NPU Ram_mem Address 
// ****************************************************** 		
 parameter IM_RAM_ADR       = 6'b000001;   
 parameter SIG_RAM_ADR      = 6'b000010;   
 parameter BIAS_RAM_ADR     = 6'b000011;   
 parameter WEIGHT_RAM_ADR   = 6'b000100; 

// ******************************************************
// NPU Trans Interface State Machine Encoding
// ****************************************************** 
 parameter IDLE           = 4'b0000 ;
 parameter INC            = 4'b0001 ;
 parameter WEIGHT         = 4'b0010 ;
 parameter BIAS           = 4'b0011 ;
 parameter SIGMOID        = 4'b0100 ;
 parameter npu_on         = 4'b0101 ;
 parameter WEIGHT_ADR_ICR = 4'b0111 ;

input  [31:0]       weight_depth     ; 	
input  [31:0]       bias_depth       ;   
input  [31:0]       im_depth         ; 
input  [31:0]       sig_depth        ; 
input  [31:0]       npu_datain_depth ; 
input  [31:0]       npu_dataout_depth; 
input               start;
input               stop;
input               init_ram;
input               int_clr;
input               int_en_init ;
input               int_en_npu ;
input               fifo_empty;
//input               err_int_en;

// npu interface
output              npu_en;            
output  [31:0]      npu_din;
output              npu_enq;
input               npu_deq;
input               npu_full;
//input               npu_ofifo_full;
input   [9:0]       output_count;
// ram-specific ports
output  [20:0]      ram_din;
output  [13:0]      ram_reg_adr;
output  [5 :0]      ram_mem_adr;
output              ram_we;

//////////////////////////////
input 			        hreset;
input 			        clk;
input  	[31:0] 	    datain;   	// Data from FIFO
input   [31:0]      datain_ahb;
input               ahb_push;
output			        pop;		// read 
output              disable_rdreq;
output              wrt_req_en;
//output              err_int;
output              interrupt0  ;
output              interrupt1  ;
output              clear;  
output              input_data_en_d;
output              pre_ram; 
output          [31:0]    residue_out_cnt;
//output          reg residue_mode;

///////////////////////////////////////////
   
reg             complete_ann;
reg             complete_init; 
//reg             err_int; 
reg             interrupt0  ;
reg             interrupt1  ;
reg             wrt_req_en ;
reg             input_data_en;   
wire            input_data_en_d;
reg input_data_en_d11;
reg input_data_en_d22; 
reg input_data_en_d33;


reg             pre_ram          ;               
reg             wait_inram_flag  ;
reg   [31:0]    npu_datain_cnt   ;
reg   [31:0]    npu_dataout_cnt  ;  
reg   [31:0]    datain_tmp; 
reg   [31:0]    ram_count_in;
reg   [31:0]    ram_count_in_w;
reg   [3:0]     wait_cnt;      
reg   [3:0]     state           ;
reg   [3:0]     nextstate       ;
reg             cnt_clear       ; 
reg             clear ;


                      
reg   [31:0]    npu_din;
reg             npu_enq;
reg   [5 :0]    ram_mem_adr;
reg             ram_we; 
reg   [20:0]    ram_din;
reg   [5 :0]    pre_ram_mem_adr; 
reg             pop_disable;

wire  [31:0]     residue_out_cnt;

wire            change_state;
       

assign pop      =  ~fifo_empty && pre_ram && !wait_inram_flag  && !pop_disable && !change_state;

assign ram_reg_adr   =  ((state == WEIGHT) || ( state ==  WEIGHT_ADR_ICR)) ? (ram_count_in_w + ram_count_in[13:0]-1):ram_count_in[13:0]-1;
assign disable_rdreq =  ~input_data_en || wait_inram_flag || npu_full; 
assign npu_en         =  (state == npu_on ) ? 1 : 0;
assign residue_out_cnt = npu_dataout_depth - npu_dataout_cnt;
assign change_state  = (state == nextstate) ? 0 : 1;
//////////////////////////////////////////////////////////////////////
 
assign input_data_en_d = input_data_en || input_data_en_d33;

always @(posedge clk or negedge hreset)
begin
	if(!hreset) begin
		//initial 
		npu_enq           <= 0;		  
		npu_datain_cnt    <= 32'b0; 
		npu_dataout_cnt   <= 32'b0; 		
		wrt_req_en        <= 0;	
		npu_din <= 0;
		input_data_en_d33 <=0;
		input_data_en_d11<=0;
		input_data_en_d22<=0;
		//residue_mode <= 0;
	end else if(stop) begin
		npu_enq           <= 0;		  
		npu_datain_cnt    <= 32'b0; 
		npu_dataout_cnt   <= 32'b0; 		
		wrt_req_en        <= 0;	
		npu_din <= 0; 
		input_data_en_d33 <=0;
		input_data_en_d11<=0;
		input_data_en_d22<=0;
		//residue_mode <= 0;
	end
	else begin		   
        ////////////Npu Operational Data Input
        input_data_en_d11 <=input_data_en;
        input_data_en_d22 <=input_data_en_d11;
        input_data_en_d33 <=input_data_en_d22;
        npu_enq   <= 0;
	      if(state == IDLE)begin 
	      	npu_din <= 0;
	      	npu_datain_cnt <= 0;
	      	input_data_en_d11 <=0;
          input_data_en_d22 <=0;
          input_data_en_d33 <=0;
	      end else if(ahb_push & (!pre_ram) & input_data_en) begin		     				
					npu_din <= datain_ahb;
					npu_datain_cnt <= npu_datain_cnt + 1; 
					npu_enq   <= 1;
		    end
        ///////////// Write_req Control
		    if((residue_out_cnt < 4'h8 || residue_out_cnt == 4'h8) && residue_out_cnt) 
		   
		    begin
		    
		    	    if(npu_en&&output_count)
		    	    	wrt_req_en <= 1;
		    	    else wrt_req_en <= 0;
		    	   
		    	    
		    	
		    end else begin 
		   
		     if(output_count == 4'h8 || output_count > 4'h8)
		    		wrt_req_en <= 1;
		    	else wrt_req_en <= 0;
		    	end
         /////////////// Output Data counter
         if(state == IDLE)begin
         		npu_dataout_cnt <= 0;
         		//clear <= 1;
         end else if(npu_deq ) begin
		      	npu_dataout_cnt <= npu_dataout_cnt + 1;
		     end
		     
		     if(state == IDLE)begin
		     		clear <= 1;
		     end  else clear <= 0;   	        			   		     
		   
	end
end
/////////////////////////////////////////////////////////////////////////
/////////////////////////ram data input control

always @ (posedge clk or negedge hreset)
begin
	if(!hreset) begin
	//initial 
	wait_cnt          <= 4'b0; 
	ram_count_in      <= 0;
	ram_count_in_w    <= 0;
	ram_we            <= 0;
	pre_ram_mem_adr   <= 0;
	datain_tmp        <= 32'b0;
  ram_din           <= 21'b0; 
  wait_inram_flag   <= 0;
	
	end else if(stop) begin
		wait_cnt          <= 4'b0; 
	  ram_count_in      <= 0;
	  ram_count_in_w    <= 0;
	  ram_we            <= 0;
	  pre_ram_mem_adr   <= 0;
	  datain_tmp        <= 32'b0;
    ram_din           <= 21'b0; 
    wait_inram_flag   <= 0;
	end
	else begin
				// if(stage )
				 if(pop & pre_ram ) begin			
		    	 if(state == INC)
		    	 	ram_din <= datain;
		    	 else if(nextstate != WEIGHT_ADR_ICR) begin
		    	 	wait_inram_flag   <= 1;
		         ram_din <= {13'b0 , datain[7:0]};
		         datain_tmp <= datain;	     
		    	 end 
	      end
	 
	      if(wait_inram_flag == 1) begin
	      	case (wait_cnt)
		            0: ram_din <= {13'b0 , datain_tmp[15:8]};
		            1: ram_din <= {13'b0 , datain_tmp[23:16]};
		            2: ram_din <= {13'b0 , datain_tmp[31:24]};
	           endcase 
	        if(wait_cnt == 2)
		    	   wait_inram_flag   <= 0;		
	      end
	     // if(wait_cnt == 2)
	     // wait_cnt <= 0;
        ////////////////////////////////////////////////////////////////////////
		    ram_we <= 0; 
		    pre_ram_mem_adr <= ram_mem_adr;
		    if(pre_ram) begin		       
		       if(state == nextstate && state != WEIGHT_ADR_ICR)
		       if(wait_inram_flag == 1)
		       	  wait_cnt <= wait_cnt + 1;
		       	  else wait_cnt <= 0;
		       else wait_cnt <= wait_cnt;
		       
		       if(state == WEIGHT_ADR_ICR)
		          ram_count_in_w <= ram_count_in_w + 12'd2048;
		       else if(state != WEIGHT) ram_count_in_w <= 0;
		       
		       if(state != nextstate) begin
		          ram_count_in <= 0 ;		         
		       end else if(pop || wait_inram_flag) begin
	         		ram_we <= 1;
	            ram_count_in <= ram_count_in + 1;	               
	         end	
	      end else begin  
		    	wait_inram_flag   <= 0;
		    end	
	end
end

//////////////////////////////////////////state machine///////////////////////////////////
always @(posedge clk or negedge hreset)
	if (!hreset) begin
		state <= IDLE;
 	  end 
	else if(stop) begin 
		state <= IDLE;  
	end
	else begin
		state <= nextstate;
	end

always @ (*)
begin 	
	case(state)
		IDLE: begin
					  complete_ann  = 0;
					  complete_init = 0;
					  pre_ram       = 0; 	
					
					  input_data_en = 0;
					  pop_disable   = 0;
					  ram_mem_adr   = 0;   
					  if(init_ram == 1) begin
		           nextstate   = INC;			      		          
		        end else 	
		        if(start == 1) begin
		           nextstate   = npu_on;			      		           
		        end  else nextstate   = state;
		      end
		INC:  begin
						pop_disable = 0;
						input_data_en = 1;
					 // cnt_clear   = 0;
					  pre_ram     = 1; 
					  ram_mem_adr = IM_RAM_ADR;
					  complete_ann  = 0;
					  complete_init = 0;
					  if(ram_count_in == im_depth) begin
					  	nextstate   = WEIGHT;  						
					  	//cnt_clear   = 1;
					  end  else nextstate   = state;
		      end
		WEIGHT: begin
					   // cnt_clear   = 0;	
					   // pop_disable = 0;
					    input_data_en = 1; 
					    pre_ram     = 1; 
					    complete_ann  = 0;
					    complete_init = 0;
					    if(ram_count_in_w == 0 )	
					      ram_mem_adr = WEIGHT_RAM_ADR;	
					      else ram_mem_adr = pre_ram_mem_adr;		 
					    if(ram_count_in == weight_depth) 
					       if(ram_mem_adr != WEIGHT_RAM_ADR + 6'b000111) begin
					       	  nextstate = WEIGHT_ADR_ICR;				    	
					       	 // cnt_clear   = 1;
					       	  pop_disable = 1;
					       end else begin
					       	  nextstate = BIAS;	
					       	  pop_disable = 0;				    	
					       	 // cnt_clear = 1;
					       end	
					       else begin
					         pop_disable = 0;
					         //pre_ram     = 1;
					       	 nextstate   = state; 	
					       	end			   
		        end //else nextstate   = state; 
		        
		WEIGHT_ADR_ICR:begin
					      //     cnt_clear = 0;
					           complete_ann  = 0;
					           complete_init = 0;
					           input_data_en = 1; 
					           pre_ram     = 1; 
					           pop_disable = 1;  	
					           ram_mem_adr = pre_ram_mem_adr + 6'b1;	
					           nextstate = WEIGHT;
		               end
		BIAS:  begin
						 pop_disable = 0;
					 //  cnt_clear  = 0;
					   complete_ann  = 0;
					   complete_init = 0;
					   input_data_en = 1; 
					   pre_ram     = 1; 
					   ram_mem_adr = BIAS_RAM_ADR;
					   if(ram_count_in == bias_depth) begin
					   	 nextstate   = SIGMOID; 					  	 
					   //	 cnt_clear   = 1;
					   end  else nextstate   = state;
		       end
		SIGMOID: begin
							 pop_disable = 0;
					    // cnt_clear  = 0;
					     complete_ann  = 0;
					     //complete_init = 0;
					     pre_ram     = 1; 
					     input_data_en = 1; 
					     ram_mem_adr = SIG_RAM_ADR;
					     if(ram_count_in == sig_depth) begin
					     	 nextstate = IDLE;
					     //	 cnt_clear = 1;
					     	 complete_init = 1;				     	
					     end  else begin
					     			nextstate   = state;
					     			 complete_init = 0;		
					     			end
		         end
		npu_on: begin 	
								ram_mem_adr = 0; 
								pre_ram     = 0;
								pop_disable = 0;
								complete_init = 0;    
							 if(npu_datain_cnt == npu_datain_depth) 
							 	 input_data_en = 0;
               else input_data_en = 1;	 
							 if(npu_dataout_cnt == npu_dataout_depth)
							 begin
							 	 nextstate = IDLE;
							 	 complete_ann = 1;
							 	 end  else begin
							 	     nextstate   = state;
							 	     complete_ann = 0;
							 	 end
						 end
			default:	begin
			          nextstate = IDLE;
			           complete_ann  = 0;
					       complete_init = 0;
					       pre_ram       = 0; 	
					       
					       input_data_en = 0;
					       pop_disable   = 0;
					       ram_mem_adr   = 0; 
			          end
	  endcase
end

//////////////////////////////////////interrupt/////////////////////////////////

always @(posedge clk or negedge hreset) 
    begin 
      if(!hreset)  begin 
          interrupt0 <= 1'b0; 
          interrupt1 <= 1'b0; 
       //   err_int    <= 1'b0;
       end else if(stop) begin
          interrupt0 <= 1'b0; 
          interrupt1 <= 1'b0; 
        //  err_int    <= 1'b0;
       end
       else begin
           if (!interrupt0 && complete_init && int_en_init) begin                              
               interrupt0 <= 1'b1; 
           end else if (interrupt0 && int_clr) begin                 
                   interrupt0 <= 1'b0; // initial complete
                end 
                
           if (!interrupt1 && complete_ann && int_en_npu) begin                              
               interrupt1 <= 1'b1; 
           end else if (interrupt1 && int_clr) begin                 
                   interrupt1 <= 1'b0; // 
               end  
           
            
      end 
         
    end 

/////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////
endmodule







