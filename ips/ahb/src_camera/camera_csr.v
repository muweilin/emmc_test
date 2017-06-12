/****************************************************************
  ** Project: xxx
*****************************************************************
  ** File   : camera_csr.v
  ** Author : xxx
  ** C-Date : 2016-10-3
  ** M-Date : 2016-10-3
  
  ** Function Descriptoin : 
  	 	a.	camera_birdge configuration interface
  		b.	access these regisgers according sHADDR and sHTRANS(NONSEQ/SEQ).
  		    Note: sHSIZE(only 32 bits)¡¢ sHBURST(No Use)
****************************************************************/

module CAMERA_CSR(
	/**** AHB system ****/	
	//global
	HCLK			,
	HReset_N		,
	
	//Slave
	sHSEL			,
	sHWrite         ,
	sHTRANS         ,   //[0] unuse
	sHSIZE          ,	//unuse
	sHBURST         ,	//unuse
	sHADDR          ,	//[31:12][1:0] unuse
	sHWDATA         ,
	sHREADY         ,
	sHREADY_RESP    ,
	sHRESP          ,
	sHRDATA         ,
	
	/**** interrupt ****/
	Interrupt		,
	
	/**** configuratoin ***/
	BASE_ADDR_ZONE1	,
	BASE_ADDR_ZONE2	,
	BASE_ADDR_ZONE3	,
	
	DATAOK_ZONE1	,
	DATAOK_ZONE2	,
	DATAOK_ZONE3	,	
	
	RQOverFlow		,
	RQCNT			,
	CurrentZone		,
	ProtocolErr		,
	
	DATAOK_ZONE1_Set,
	DATAOK_ZONE2_Set,
	DATAOK_ZONE3_Set,
	
	HrefCtrl		,
	VsyncCtrl		,
	CaptureEn
);
	
	/**** AHB system ****/	
	//global
	input			HCLK			;
	input			HReset_N		;
	
	//Slave
	input			sHSEL			;
	input			sHWrite         ;
	input [ 1: 0]	sHTRANS         ;
	input [ 2: 0]	sHSIZE          ;	//unuse;      
	input [ 2: 0]	sHBURST         ;   //unuse;      
	input [31: 0]	sHADDR          ;   //[1:0] unuse;
	input [31: 0]	sHWDATA         ;
	input			sHREADY         ;
	output			sHREADY_RESP    ;	
	output[ 1: 0]	sHRESP          ;
	output[31: 0]	sHRDATA         ;

	/**** interrupt ****/
	output			Interrupt		;
	
	/**** configuratoin ***/
	output[31: 0]	BASE_ADDR_ZONE1	;
	output[31: 0]	BASE_ADDR_ZONE2	;
	output[31: 0]	BASE_ADDR_ZONE3	;
	
	output			DATAOK_ZONE1	;
	output			DATAOK_ZONE2	;
	output			DATAOK_ZONE3	;
	
	input			RQOverFlow		;
	input [ 3: 0]	RQCNT			;
	input [ 1: 0]	CurrentZone		;
	input [ 1: 0]	ProtocolErr		;
	
	input			DATAOK_ZONE1_Set;
	input			DATAOK_ZONE2_Set;
	input			DATAOK_ZONE3_Set;
	
	output			HrefCtrl		;
	output			VsyncCtrl		;
	output			CaptureEn       ;
	
	/*****************************************************/
	
	parameter		ADDR_BASE_ZONE1 = 12'h000	,
					ADDR_BASE_ZONE2 = 12'h004	,
					ADDR_BASE_ZONE3 = 12'h008	,
					ADDR_RQCNT      = 12'h00c	,
					ADDR_RQTH       = 12'h010	,
					ADDR_STATUS     = 12'h014	,
					ADDR_IntEn      = 12'h018	,
					ADDR_GCR     	= 12'h01c	;
	
	/*****************************************************/
	
	wire			dev_sel			;
	
	reg				r_Write			;
	reg   [11: 0]	r_WriteAddr		;
	
	reg   [31: 0]	r_sHRDATA       ;
	reg   [31: 0]	c_sHRDATA		;
	
	/*****************************************************/
	
	//NONSEQ or SEQ
	assign dev_sel     = sHREADY & sHSEL & sHTRANS[1] ;
	
	//only OKAY response,and no wait
	assign sHREADY_RESP= 1'b1;
	assign sHRESP      = 2'h0;
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r_Write		<= 1'b0;
			r_WriteAddr <=12'h0;
			
			r_sHRDATA	<=32'h0; 
		end
		else
		begin
			r_Write		<= dev_sel & sHWrite ;
			r_WriteAddr <=(dev_sel & sHWrite ) ? {sHADDR[11:2],2'b00} : r_WriteAddr ;
			r_sHRDATA	<=(dev_sel &~sHWrite ) ? c_sHRDATA : r_sHRDATA ; 
		end
	end
	
	assign sHRDATA = r_sHRDATA;
	
	//BASE_ADDR_ZONE: Read & Write	
	reg   [31: 0]	r_BASE_ADDR_ZONE1	;
	reg   [31: 0]	r_BASE_ADDR_ZONE2	;
	reg   [31: 0]	r_BASE_ADDR_ZONE3	;
		
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r_BASE_ADDR_ZONE1	<= 32'h0;
			r_BASE_ADDR_ZONE2   <= 32'h0;
			r_BASE_ADDR_ZONE3   <= 32'h0;
		end
		else
		begin
			if(r_Write & (r_WriteAddr==ADDR_BASE_ZONE1))
				r_BASE_ADDR_ZONE1	<= sHWDATA ;
			
			if(r_Write & (r_WriteAddr==ADDR_BASE_ZONE2))
				r_BASE_ADDR_ZONE2	<= sHWDATA ;
			
			if(r_Write & (r_WriteAddr==ADDR_BASE_ZONE3))
				r_BASE_ADDR_ZONE3	<= sHWDATA ;	
		end
	end
	
	assign	BASE_ADDR_ZONE1	= r_BASE_ADDR_ZONE1	;
	assign	BASE_ADDR_ZONE2	= r_BASE_ADDR_ZONE2	;
	assign	BASE_ADDR_ZONE3	= r_BASE_ADDR_ZONE3	;
	
	//RQCNT: Read only
	
	//RQTH: Read & Write	
	reg   [ 3: 0]	r_RQTH	;
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r_RQTH	<= 4'h5;
		end
		else
		begin
			if(r_Write & (r_WriteAddr==ADDR_RQTH))
				r_RQTH	<= sHWDATA[ 3: 0] ;			
		end
	end
		
	//STATUS: Read & Write(W1C)
	reg   [ 6: 0]	r_Status;
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r_Status	<= 7'h0;
		end
		else
		begin
			if(DATAOK_ZONE1_Set)
				r_Status[0]	<= 1'h1;
			else if(r_Write & (r_WriteAddr==ADDR_STATUS)&sHWDATA[0])
				r_Status[0]	<= 1'h0;
			else
				r_Status[0]	<= r_Status[0];
			
			if(DATAOK_ZONE2_Set)
				r_Status[1]	<= 1'h1;
			else if(r_Write & (r_WriteAddr==ADDR_STATUS)&sHWDATA[1])
				r_Status[1]	<= 1'h0;
			else
				r_Status[1]	<= r_Status[1];
			
			if(DATAOK_ZONE3_Set)
				r_Status[2]	<= 1'h1;
			else if(r_Write & (r_WriteAddr==ADDR_STATUS)&sHWDATA[2])
				r_Status[2]	<= 1'h0;
			else
				r_Status[2]	<= r_Status[2];
				
			if(RQCNT>=r_RQTH)
				r_Status[3]	<= 1'h1;
			else if(r_Write & (r_WriteAddr==ADDR_STATUS)&sHWDATA[3])
				r_Status[3]	<= 1'h0;
			else
				r_Status[3]	<= r_Status[3];
				
			if(RQOverFlow)
				r_Status[4]	<= 1'h1;
			else if(r_Write & (r_WriteAddr==ADDR_STATUS)&sHWDATA[4])
				r_Status[4]	<= 1'h0;
			else
				r_Status[4]	<= r_Status[4];	
			
			if(ProtocolErr[0])
				r_Status[5]	<= 1'h1;
			else if(r_Write & (r_WriteAddr==ADDR_STATUS)&sHWDATA[5])
				r_Status[5]	<= 1'h0;
			else
				r_Status[5]	<= r_Status[5];	
				
			if(ProtocolErr[1])
				r_Status[6]	<= 1'h1;
			else if(r_Write & (r_WriteAddr==ADDR_STATUS)&sHWDATA[6])
				r_Status[6]	<= 1'h0;
			else
				r_Status[6]	<= r_Status[6];		
		end
	end
	
	assign DATAOK_ZONE1 = r_Status[0];	
	assign DATAOK_ZONE2	= r_Status[1];
	assign DATAOK_ZONE3	= r_Status[2];
	
	//IntEn: Read & Write	
	reg   [ 6: 0]	r_IntEn	;
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r_IntEn	<= 7'h0;
		end
		else
		begin
			if(r_Write & (r_WriteAddr==ADDR_IntEn))
				r_IntEn	<= sHWDATA[ 6: 0] ;			
		end
	end
	
	assign Interrupt = |(r_IntEn & r_Status) ;
		
	//GCR: Read & Write	
	reg   [ 2: 0]	r_GCR	;
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r_GCR	<= 3'h0;
		end
		else
		begin
			if(r_Write & (r_WriteAddr==ADDR_GCR) & ~r_GCR[0])
			    r_GCR[ 2: 1]	<= sHWDATA[ 2: 1] ;
			
			if(r_Write & (r_WriteAddr==ADDR_GCR))
				r_GCR[0]	    <= sHWDATA[0] ;			
		end
	end
	
	assign	HrefCtrl	= r_GCR[2] ;
	assign	VsyncCtrl	= r_GCR[1] ;
	assign	CaptureEn   = r_GCR[0] ;
	
	always@*
	begin
		case({sHADDR[11:2],2'b00})
		ADDR_BASE_ZONE1 : c_sHRDATA = r_BASE_ADDR_ZONE1 ;
		ADDR_BASE_ZONE2 : c_sHRDATA = r_BASE_ADDR_ZONE2 ;
		ADDR_BASE_ZONE3 : c_sHRDATA = r_BASE_ADDR_ZONE3 ;
		ADDR_RQCNT      : c_sHRDATA = {28'h0,RQCNT}  ;
		ADDR_RQTH       : c_sHRDATA = {28'h0,r_RQTH} ;
		ADDR_STATUS     : c_sHRDATA = {23'h0,CurrentZone,r_Status} ;
		ADDR_IntEn      : c_sHRDATA = {25'h0,r_IntEn};
		ADDR_GCR     	: c_sHRDATA = {29'h0,r_GCR}  ;
		default			: c_sHRDATA = 32'h0  ;
		endcase
	end
 		
endmodule
