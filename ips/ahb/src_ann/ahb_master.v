
module ahb_master
(
     // AHB Master Interface
     hclk,
     hreset,

     hready_i,
     hresp_i,
     hgrant_i,

     hbusreq_o,
     htrans_o,
     hwrite_o,
     hsize_o,
     hburst_o,

     haddr_o,
     hwdata_o,
	   hrdata_i,

     // State Machine Interface
	   req_done,
	   rd_req,
	   wr_req,
	 
     // FIFO Interface
     dataout,
	   datain,
	   push,
	   pop,
	   //residue_mode,
	   npu_output_count,

     // From DMA Register          
     src_addr,
     dst_addr,          
	   block_size
	 //wait_inram_flag
  );

// AHB Interface

input           hclk;                // This clock times all bus transfers
input           hreset;             // AHB reset signal
input           hready_i;           // when active indicates that
                                    // a transfer has finished on the bus
input   [1:0]   hresp_i;            // transfer response from AHB Slave
                                    // (OKAY,ERROR,RETRY,SPLIT)
input           hgrant_i;           // bus grant from AHB Arbiter
//input           residue_mode;

output          hbusreq_o;          // bus request to AHB Arbiter
output  [1:0]   htrans_o;           // type of current transfer
output          hwrite_o;           // type of current transfer
                                    // (NONSEQ,SEQ,IDLE,BUSY)
output  [2:0]   hsize_o;            // size of current transfer
output  [2:0]   hburst_o;           // Burst type
output  [31:0]  haddr_o;            // Address out onto AHB for Rd/Wr

output [31:0]   hwdata_o;           // Write data out to AHB for Rx 
input  [31:0]   hrdata_i;           // Read data from AHB for Tx
input  [9:0]    npu_output_count;

	// State Machine Interface
output			req_done;
input	 		rd_req;
input			wr_req;

	// FIFO Interface
output	[31:0]  dataout;			// Data Out to Read FIFO
input	  [31:0]	datain;				// Data In from Write FIFO
output	 		push;
output			pop;
//input       full;

    // From DMA Register          
input	[31:0]  src_addr;
input	[31:0]  dst_addr;          
input	[4:0]	block_size;

//input wait_inram_flag;

wire              hbusreq_o;
reg               hwrite_o;
wire   [2:0]      hsize_o;
reg    [1:0]      htrans_o;
reg    [2:0]      hburst_o;
wire  [31:0]      haddr_o;
reg   [31:0]      hwdata_o;

wire			req_done;
reg		[4:0]	word_count;
wire			pop;
reg				push;
wire	[31:0]  dataout;			// Data Out to Read FIFO

// Internal register declarations
reg    [3:0]      ahb_master_state;     // AHB Master I/F S/M State bits
reg    [3:0]      state_prev_clk;       // AHB Master I/F S/M State bits
                                        // delayed by 1-clock

reg               latch_addr;           // used to latch address from fifo
                                        // into address incrementer
// reg               latch_prevaddr;       // used to restore the prev. addr
                                        // in case of RETRY/SPLIT
wire              lastbrstrd;           // Last Burst Read
wire              lastbrstwr;           // Last Burst Read
reg				  burstwrflag_last_n;
reg    [29:0]      haddr_reg;            // upper 30-bits of HADDR
wire   [29:0]      nextaddr;             // upper 30-bits of HADDR
reg    [29:0]      haddr_prev;           // lower address bits of the previous
                                        // transfer.  Used to restore address
                                        // in case of RETRY/SPLIT
reg               ahm_busreq_reg;       // AHB registered request signal
                                        // used with busreq_comb to generate
                                        // ahm_busreq O/P to AHB arbiter
reg               rddf_wren;            // enables/disables data fifo
                                        // write logic
reg               busreq_prev;          // AHB access request signal delayed
reg               busreq_comb;

// ******************************************************
// AHB Master Interface State Machine Encoding
// ******************************************************
parameter         AHM_IDLE       =  4'b0000;
parameter         AHM_BREQ       =  4'b0001;
parameter         AHM_NSEQWR     =  4'b0010;
parameter         AHM_SEQWR      =  4'b0011;
parameter         AHM_WRWAIT     =  4'b0101;
//parameter         AHM_RETRY      =  4'b0110;
parameter         AHM_LASTWR     =  4'b0111;
parameter         AHM_GOIDLE     =  4'b1000;
parameter         AHM_NSEQRD     =  4'b1001;
parameter         AHM_SEQRD      =  4'b1010;
parameter         AHM_RDWAIT     =  4'b1011;
parameter         AHM_LASTRD     =  4'b1101;


// ******************************************************
// Parameter Definition for AHB Transfer Type(HTRANS)
// ******************************************************
parameter         IDLE                = 2'b00;
parameter         BUSY                = 2'b01;
parameter         NONSEQ              = 2'b10;
parameter         SEQ                 = 2'b11;
  
// ******************************************************
// Parameter Definition for AHB Transfer Type(HBURST)
// ******************************************************
parameter         SINGLE              = 3'b000;
parameter         INCR                = 3'b001;
//parameter         INCR4               = 3'b011;
//parameter         INCR8               = 3'b101;
//parameter         INCR16              = 3'b111;
  
// ******************************************************
// Parameter Definition for AHB Transfer SIZE(HSIZE)
// ******************************************************
//parameter         BYTE                = 3'b000;
//parameter         HALFWORD            = 3'b001;
parameter         WORD                = 3'b010;
  
// ******************************************************
// Parameter Definition for AHB Response Type(hresp_i)
// ******************************************************
parameter         OKAY                = 2'b00;
parameter         ERROR               = 2'b01;
parameter         RETRY               = 2'b10;
parameter         SPLIT               = 2'b11;
  
// ******************************************************
// Parameter Definition for AHB Write/Read Command (HWRITE)
// ******************************************************
parameter         READ                = 1'b0;
parameter         WRITE               = 1'b1;

// **********************************************************

assign  dataout[31:0] = hrdata_i;


assign hsize_o = WORD;		   // Always WORD Transfer
assign req_done = (word_count == 5'b00001) && (push || pop);

always @(posedge hclk or negedge hreset)
begin

   if(!hreset) begin

      ahm_busreq_reg    <= 1'b0;
      hwrite_o          <= READ;
      latch_addr        <= 1'b0;
      hburst_o          <= SINGLE;
      rddf_wren         <= 1'b0;
//	  req_done			<= 1'b0;
      ahb_master_state  <= AHM_IDLE;
   end

   else begin
	
		
      case(ahb_master_state)   

         AHM_IDLE:  begin
               if(rd_req) begin			// DMA Read Cycle
                  ahm_busreq_reg    <= 1'b1;
                  hwrite_o          <= READ;
                  latch_addr        <= 1'b1;
                  ahb_master_state  <= AHM_BREQ;
               end
               else if(wr_req) begin	// DMA Write Cycle
                  ahm_busreq_reg    <= 1'b1;
                  hwrite_o          <= WRITE;
                  latch_addr        <= 1'b1;
                  ahb_master_state  <= AHM_BREQ;
               end
         end

         
         AHM_BREQ:  begin // wait until bus is granted
               latch_addr          <= 1'b0;
               if(hgrant_i & hready_i) begin
                  // write transfer
                  if(hwrite_o) begin
                     ahb_master_state  <= AHM_NSEQWR;
                     if(wr_req && (word_count == 5'b00001)) begin
                        ahm_busreq_reg <= 1'b0;
                        hburst_o       <= SINGLE;
                     end
                     else begin
                        hburst_o       <= INCR;
                     end
                  end
                  // read transfer
                  else begin
                     // read request is single
                     if (rd_req && (word_count == 5'b00001)) begin
                        hburst_o          <= SINGLE;
                        ahm_busreq_reg    <= 1'b0;
                     end
                     else begin
                        hburst_o          <= INCR;
                     end
                     // read request is single
                     ahb_master_state    <= AHM_NSEQRD;
                  end
               end
         end
         // first address phase of read transfer
         AHM_NSEQRD:  begin
				// Target is ready accept data
               if(hready_i) begin
                 
                  if(hburst_o == SINGLE) begin
                     ahb_master_state    <= AHM_RDWAIT;
                     //rddf_wren           <=  1'b1;
                  end
                  
                  else if(~hgrant_i) begin
                     ahb_master_state    <= AHM_LASTRD;
                     // rddf_wren           <=  1'b1;
                  end
                  // continue to read
                  else begin
                     if(lastbrstrd) begin
                        ahm_busreq_reg      <= 1'b0;
                     end
                     ahb_master_state    <= AHM_SEQRD;
                  end
                    // rddf_wren           <= #1 1'b1;
               end
         end
         // consecutive transfers of burst read
         AHM_SEQRD:  begin
               // target is ready to provide data
              // rddf_wren           <= rddf_wren_tmp; 
              // rddf_wren_tmp           <= 1'b1; 
              rddf_wren           <=  1'b1;
               if(hready_i & hresp_i == OKAY) begin
                  if(htrans_o == IDLE) begin
                     ahb_master_state    <= AHM_GOIDLE;//can't in this branch
                     ahm_busreq_reg      <= 1'b0;
                     rddf_wren           <= 1'b0; 
                  //   rddf_wren_tmp       <= 0;
                  end
                  // only one more data left from current read burst
                  else if(lastbrstrd) begin 
                     ahb_master_state    <= AHM_RDWAIT;
                     ahm_busreq_reg      <= 1'b0;
                  end
                  else if(~hgrant_i) begin
                     ahb_master_state    <= AHM_LASTRD;
                     if(~busreq_comb) begin
                        ahm_busreq_reg      <= 1'b0;
                     end
                  end
               end
               // system needs to be reset
              // else if(~hready_i & hresp_i == ERROR) begin
              //    rddf_wren           <= 1'b0;
              //    ahb_master_state    <= AHM_IDLE;
              //    ahm_busreq_reg      <= 1'b0;
              // end
               else begin
                  // enable as long as in SEQRD state
                     rddf_wren           <= 1'b1;
                  if(~busreq_comb) begin
                     ahm_busreq_reg      <= 1'b0;
                  end
               end
         end
        
         AHM_LASTRD:  begin
               // target is ready to accept data
               rddf_wren           <=  1'b1;
               if(hready_i & hresp_i == OKAY) begin
                  ahm_busreq_reg      <= 1'b1;
                  ahb_master_state    <= AHM_BREQ;
                  rddf_wren           <= 1'b0;
               end
              // else if(~hready_i & (hresp_i == RETRY | hresp_i == SPLIT) ) begin
              //    ahm_busreq_reg      <= 1'b1;
              //    ahb_master_state    <= AHM_BREQ;
              //    rddf_wren           <= 1'b0;
              // end
               
              // else if(~hready_i & hresp_i == ERROR) begin
              //    rddf_wren           <= 1'b0;
              //    ahb_master_state    <= AHM_IDLE;
              //    ahm_busreq_reg      <= 1'b0;
              // end
               else begin
                  rddf_wren           <= 1'b1;//maybe no use , can delete
               end
         end
         // first address phase of write transfer
         AHM_NSEQWR:  begin
               if(hready_i) begin
                  // If it is single write cycle go to WAIT as
                  // current data is last data phase
                  if (hburst_o == SINGLE) begin
                     ahb_master_state    <= AHM_WRWAIT;
                  end
                  else if(~hgrant_i) begin
                     ahb_master_state    <= AHM_LASTWR;
                  end
                  else begin
                     ahb_master_state    <= AHM_SEQWR;
                  end
               end
         end
         // data phase of either single read cycle
         // or last data phase of burst read cycle
         AHM_RDWAIT:  begin
               // target is ready
               rddf_wren           <=  1'b1;
               if(hready_i == 1'b1 & hresp_i == OKAY) begin
                  ahb_master_state    <= AHM_GOIDLE;
                  rddf_wren           <= 1'b0;
                  ahm_busreq_reg      <= 1'b0;
               end
              // else if(~hready_i & (hresp_i == RETRY | hresp_i == SPLIT) ) begin
              //       ahb_master_state    <= AHM_BREQ;
              //       ahm_busreq_reg      <= 1'b1;
              //       rddf_wren           <= 1'b0;
              // end
              //
              // else if(~hready_i & hresp_i == ERROR) begin
              //    ahb_master_state    <= AHM_IDLE;
              //    ahm_busreq_reg      <= 1'b0;
              // end
         end
         // last data phase of write transfer(single/burst)
         // if successful S/M goes to idle
         // if unsuccessful(RETRY/SPLIT) transfer is retried
         AHM_WRWAIT:  begin
               // target is ready
               if(hready_i == 1'b1 & hresp_i == OKAY) begin
                  ahb_master_state    <= AHM_GOIDLE;
                  ahm_busreq_reg      <= 1'b0;

               end
              // else if(~hready_i & (hresp_i == RETRY | hresp_i == SPLIT) ) begin
              //    ahb_master_state    <= AHM_BREQ;
              //    ahm_busreq_reg      <= 1'b1;
              //
              // end
              // // system needs to be reset
              // else if(~hready_i & hresp_i == ERROR) begin
              //    ahb_master_state    <= AHM_IDLE;
              //    ahm_busreq_reg      <= 1'b0;
              // end
         end

         AHM_SEQWR:                 // target is ready to accept data
               if(hready_i & hresp_i == OKAY) begin
                  //if(htrans_o == BUSY) begin // maybe delete this branch
                  //      hburst_o          <= INCR;
                  //   if(hgrant_i) begin
                  //      ahb_master_state    <= AHM_NSEQWR;
                  //   end
                  //   else begin
                  //      ahb_master_state    <= AHM_BREQ;
                  //   end
                  //end
                  //else 
                  if(htrans_o == IDLE) begin
                     ahb_master_state    <= AHM_GOIDLE;
                     // read the address fifo as it is last data phase
                     // so that application can strobe new cycle if any
                     ahm_busreq_reg      <= 1'b0;
                  end
				// Finish cycle when last word is written
                  else if(lastbrstwr) begin
                     ahm_busreq_reg      <= 1'b0;
                     ahb_master_state    <= AHM_LASTWR;
                  end  
                  // grant lost while waiting for transfer to finish
                  else if(~hgrant_i) begin
                     ahb_master_state    <= AHM_LASTWR;
                  end
			   end
              // else if(~hready_i & (hresp_i == RETRY | hresp_i == SPLIT) ) begin
              //    ahb_master_state    <= AHM_BREQ;
              //    ahm_busreq_reg      <= 1'b1;
              // end
              // // error indicated on AHB
              // // in current design it is unrecoverable
              // // system needs to be reset
              // else if(~hready_i & hresp_i == ERROR) begin
              //    ahb_master_state    <= AHM_IDLE;
              //    ahm_busreq_reg      <= 1'b0;
              // end
         
         AHM_LASTWR:  begin
               // target is ready to accept data
               if(hready_i & hresp_i == OKAY) begin
                  // if the current data is last data from current burst
                  // goto idle, emptying the address fifo
                  if(burstwrflag_last_n) begin
                     ahb_master_state    <= AHM_GOIDLE;
                     // read the address fifo as it is last data phase
                     // so that application can strobe new cycle if any
                     ahm_busreq_reg      <= 1'b0;
                  end
                  else begin
                     ahm_busreq_reg      <= 1'b1;
                     ahb_master_state    <= AHM_BREQ;
                  end
               end

              // else if(~hready_i & (hresp_i == RETRY | hresp_i == SPLIT) ) begin
              //    ahm_busreq_reg      <= 1'b1;
              //    ahb_master_state    <= AHM_BREQ;
              // end
              //
              // else if(~hready_i & hresp_i == ERROR) begin
              //    ahb_master_state    <= AHM_IDLE;
              //    ahm_busreq_reg      <= 1'b0;
              // end
         end
         
        // AHM_RETRY:  begin
        //          ahm_busreq_reg      <= 1'b1;
        //          ahb_master_state    <= AHM_BREQ;
        // end
         
         AHM_GOIDLE:  begin
               ahb_master_state    <= AHM_IDLE;
         end
      endcase
   end
end

// AHB write burst flag latching
always @(posedge hclk or negedge hreset)
begin
   if(!hreset) begin
      burstwrflag_last_n  <= 1'b1;
   end
   else begin 
      if(pop || (ahb_master_state == AHM_IDLE)) begin
         burstwrflag_last_n  <= (word_count == 5'b00001);
      end
   end
end

// latching state 
always @(posedge hclk or negedge hreset)
begin
   if(!hreset) begin
      state_prev_clk      <= AHM_IDLE;
   end
   else begin
      if(hready_i) begin
         state_prev_clk      <= ahb_master_state;
      end
   end
end

// address generation
always @(posedge hclk or negedge hreset)
begin
   if(!hreset) begin
      haddr_reg[29:0]      <= 30'h0000_0000;
      haddr_prev[29:0]     <= 30'h0000_0000;
   end
   else if(latch_addr && rd_req) begin
         haddr_reg[29:0]      <= src_addr[31:2]; 
         haddr_prev[29:0]     <= src_addr[31:2];
   end
   else if(latch_addr && wr_req) begin
         haddr_reg[29:0]      <= dst_addr[31:2]; 
         haddr_prev[29:0]     <= dst_addr[31:2]; 
   end
   else begin
        if( ahb_master_state == AHM_NSEQWR ||
             ahb_master_state == AHM_SEQWR ||
             ahb_master_state == AHM_NSEQRD || 
             ahb_master_state == AHM_SEQRD) begin
            if(hready_i && hresp_i == OKAY && htrans_o != BUSY ) begin 
               haddr_reg[29:0]      <= nextaddr[29:0];
               haddr_prev[29:0]     <= haddr_o[31:2];
            end
         end
   end
end
// address generation
always @(posedge hclk or negedge hreset)
begin
   if(!hreset) begin
         word_count			  <= 5'b00000; 
   end
   else if(latch_addr && rd_req) begin
         word_count			  <= block_size; 
   end
   else if(latch_addr && wr_req) begin
   			if(npu_output_count < 4'h8 )
         word_count			  <= 5'h1;
         else word_count  <= 5'h8; 
   end
   else if (push | pop) begin
         word_count			  <= word_count - 1; 
   end
end
// Final address that gets onto AHB for Read/Write transfers
assign haddr_o[31:0]    =  {haddr_reg[29:0], 2'b00};

// address of next transfer used by address incrementer
//assign nextaddr[29:0]  = haddr_reg[29:0] + 30'b1;
wire [15:0] lowaddr;
wire [14:0] highaddr;

assign lowaddr[15:0] = haddr_reg[14:0] + 16'b1;
assign highaddr[14:0] = haddr_reg[29:15] + 1;
assign nextaddr[29:0]  = lowaddr[15] ? {highaddr[14:0],lowaddr[14:0]} : {haddr_reg[29:15],lowaddr[14:0]};

assign  pop = (ahb_master_state == AHM_SEQWR | ahb_master_state == AHM_NSEQWR)
						&& hready_i && (hresp_i == OKAY);


always @(rddf_wren or hready_i or hresp_i)
begin
   if(hready_i == 1'b1 & hresp_i == OKAY & rddf_wren) begin
     // if(rddf_wren) begin
         push = 1'b1;
      end
      else begin
         push = 1'b0;
      end
  // end
  // else begin
  //    push = 1'b0;
  // end
end	 


always @(ahb_master_state or busreq_prev )
begin
   case (ahb_master_state)
      AHM_SEQWR : begin
               htrans_o = SEQ;
      end
      AHM_NSEQWR, AHM_NSEQRD : begin
         htrans_o = NONSEQ;
      end
      AHM_SEQRD : begin
        
            if(~busreq_prev) begin
               htrans_o = IDLE;
            end
            else  begin
               htrans_o = SEQ;
            end
        end
      default : begin
         htrans_o = IDLE;
      end
   endcase
   	
end


always @(ahb_master_state or htrans_o)
begin
   if(ahb_master_state == AHM_SEQWR) begin
      if( htrans_o == IDLE ) begin
         busreq_comb = 1'b0;
      end
      else begin
         busreq_comb = 1'b1;
      end
   end
   else if(ahb_master_state == AHM_SEQRD) begin
     
         if(htrans_o == IDLE) begin
            busreq_comb = 1'b0;
         end
         else begin
            busreq_comb = 1'b1;
         end
   end
   else begin
      busreq_comb = 1'b1;
   end
end


// final AHB access request signal to arbiter
assign hbusreq_o = ahm_busreq_reg;

// AHB write data generation
always @(posedge hclk or negedge hreset)
begin
   if(!hreset) begin
      hwdata_o[31:0]        <= 32'h0000_0000;
   end
   else if(pop) begin
   hwdata_o[31:0] <= datain[31:0] ;
   end
end

assign lastbrstrd   = push && (word_count == 5'b00010);
assign lastbrstwr   = pop && (word_count == 5'b00001);


always @(posedge hclk or negedge hreset)
begin
   if(!hreset)
      busreq_prev <= 1'b0;
   else
      busreq_prev <= hbusreq_o;
end

endmodule
