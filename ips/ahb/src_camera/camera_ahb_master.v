

module CAMERA_AHB_MASTER(
	/**** AHB system ****/	
	//global
	HCLK			,
	HReset_N		,
	
	//Master
	mHADDR			,
	mHTRANS     	,
	mHWRITE     	,
	mHSIZE      	,
	mHBURST     	,
	mHPORT      	,
	mHWDATA     	,
	mHREADY     	,
	mHRESP      	,	//Unused
	mHRDATA     	,	//Unused
	mHBUSRREQ  		,
	mHLOCK     		,
	mHGRANT			,
	
	/**** With Capture ****/
	i_FIFOEmpty		,
	o_ReadEn		,
	i_RdData		,
	
	i_ZONE_ReStart	,

	/**** configuratoin ***/
	BASE_ADDR_ZONE1	,
	BASE_ADDR_ZONE2	,
	BASE_ADDR_ZONE3	,
	
	DATAOK_ZONE1	,
	DATAOK_ZONE2	,
	DATAOK_ZONE3	,	
	
	CurrentZone		,
	ProtocolErr		,
	
	DATAOK_ZONE1_Set,
	DATAOK_ZONE2_Set,
	DATAOK_ZONE3_Set		
);
	
	/**** AHB system ****/	
	//global
	input			HCLK			;
	input			HReset_N		;
	
	//Master
	output[31: 0]	mHADDR			;
	output[ 1: 0]	mHTRANS     	;
	output			mHWRITE     	;
	output[ 2: 0]	mHSIZE      	;
	output[ 2: 0]	mHBURST     	;
	output[ 3: 0]	mHPORT      	;
	output[31: 0]	mHWDATA     	;
	input			mHREADY     	;
	input [ 1: 0]	mHRESP      	;	//Unused
	input [31: 0]	mHRDATA     	;	//Unused
	output			mHBUSRREQ  		;
	output			mHLOCK     		;
	input			mHGRANT    		;
	
	/**** With Capture ****/
	input 			i_FIFOEmpty		;
	output			o_ReadEn		;
	input [127: 0]	i_RdData		;
	
	input 			i_ZONE_ReStart	;
	
	/**** configuratoin ***/
	input [31: 0]	BASE_ADDR_ZONE1	;
	input [31: 0]	BASE_ADDR_ZONE2	;
	input [31: 0]	BASE_ADDR_ZONE3	;
	
	input 			DATAOK_ZONE1	;
	input 			DATAOK_ZONE2	;
	input 			DATAOK_ZONE3	;
	
	output[ 1: 0]	CurrentZone		;
	output[ 1: 0]	ProtocolErr		;
	
	output			DATAOK_ZONE1_Set;
	output			DATAOK_ZONE2_Set;
	output			DATAOK_ZONE3_Set;
	
	/****************************************/
	
	//Current ZONE
	reg				r_ZONE_ReStart	;
	reg 			r_ZoneFstRecved	;
	reg [ 1: 0]		r_CurrentZone	;
	reg [ 1: 0]		c_CurrentZone	;
	reg				r_ProtocolErr	;
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r_ZONE_ReStart	<= 1'b0;
			r_CurrentZone	<= 2'h0;
			r_ProtocolErr	<= 1'b0;
			r_ZoneFstRecved	<= 1'b0;
		end
		else
		begin
			r_ZONE_ReStart	<= i_ZONE_ReStart;
			r_CurrentZone	<= c_CurrentZone ;
			
			if(r_ZONE_ReStart)
				r_ProtocolErr	<= DATAOK_ZONE1 & DATAOK_ZONE2 & DATAOK_ZONE3 | ~i_FIFOEmpty ;
			
			if(i_ZONE_ReStart)
				r_ZoneFstRecved	<= 1'b1;
		end
	end
	
	assign	DATAOK_ZONE1_Set = i_ZONE_ReStart & r_ZoneFstRecved & ~r_ProtocolErr & (r_CurrentZone==2'b00);
	assign	DATAOK_ZONE2_Set = i_ZONE_ReStart & r_ZoneFstRecved & ~r_ProtocolErr & (r_CurrentZone==2'b01);
	assign	DATAOK_ZONE3_Set = i_ZONE_ReStart & r_ZoneFstRecved & ~r_ProtocolErr & (r_CurrentZone==2'b10);
	
	always@*
	begin
		if(r_ZONE_ReStart & i_FIFOEmpty)
		begin
			if(~DATAOK_ZONE1)
				c_CurrentZone = 2'b00 ;
			else if(~DATAOK_ZONE2)
				c_CurrentZone = 2'b01 ;
			else if(~DATAOK_ZONE3)
				c_CurrentZone = 2'b10 ;
			else
				c_CurrentZone = r_CurrentZone ;	//protocol Error
		end
		else
		begin
			c_CurrentZone = r_CurrentZone ;
		end
	end
	
	assign	CurrentZone 	= r_CurrentZone  ;		
	assign	ProtocolErr[0]	= r_ZONE_ReStart & DATAOK_ZONE1 & DATAOK_ZONE2 & DATAOK_ZONE3 ;
	assign	ProtocolErr[1]	= r_ZONE_ReStart &~i_FIFOEmpty  ;
	
	//AHB Master
	parameter	AHB_IDLE   = 2'b00,
				AHB_REQBUS = 2'b01,
				AHB_REQSND = 2'b10,
				AHB_ENDDAT = 2'b11;
	
	reg	[ 1: 0]		r_AHBState	;
	reg [ 1: 0]		c_AHBState	;
	
	reg [ 3: 0]		r_FlitV		;
	reg [ 3: 0]		c_FlitV		;
		
	reg [19: 0]		r_IndexAddr	;
	reg [19: 0]		c_IndexAddr	;
	
	reg	[ 1: 0]		r_BurstType	;	//11: INCR4; 00: SINGLE; 01: INCR
	reg	[ 1: 0]		c_BurstType	;
	
	reg				r_FstFlit	;
	reg				c_FstFlit	;
	
	reg [ 3: 0]		c_LowAddr	;
	reg [ 1: 0]		c_DataMux	;
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r_AHBState	<= AHB_IDLE ;

			r_FlitV		<= 4'hf;
			r_IndexAddr	<=20'b0;
			
			r_BurstType	<= 2'h3;
			r_FstFlit	<= 1'b0;
		end
		else
		begin
			r_AHBState	<= c_AHBState 	;
			
			r_FlitV		<= c_FlitV		;
			r_IndexAddr	<= c_IndexAddr	;
			
			r_BurstType	<= c_BurstType	;
			r_FstFlit	<= c_FstFlit	;
		end
	end
	
	always@*
	begin
		case(r_AHBState)
		AHB_IDLE :
			begin
				if(~i_FIFOEmpty & ~r_ProtocolErr)
					c_AHBState = AHB_REQBUS ;
				else if(~i_FIFOEmpty & r_ProtocolErr)
					c_AHBState = r_AHBState ;
				else
					c_AHBState = r_AHBState ;
			end
		AHB_REQBUS:
			begin
				if(mHGRANT & mHREADY)
					c_AHBState = AHB_REQSND ;
				else
					c_AHBState = r_AHBState ;
			end
		AHB_REQSND:
			begin
				//r_FlitV为4'h8表示当前发送最后一个32比特，此时收到mHREADY则属于正常结束，状态机转入AHB_ENDDAT状态				
				if((r_FlitV==4'h8) & mHREADY)
					c_AHBState = AHB_ENDDAT ;
				//EBT条件：
				else if((r_FlitV!=4'h8) & mHREADY & ~mHGRANT)
					c_AHBState = AHB_ENDDAT ;
				else
					c_AHBState = r_AHBState ;
			end
		default:
			begin
				if(mHREADY)
					c_AHBState = AHB_IDLE ;
				else
					c_AHBState = r_AHBState ;
			end
		endcase
	end
	
	//FlitV
	always@*
	begin
		if((r_AHBState==AHB_REQSND)&mHREADY)
			c_FlitV = {r_FlitV[2:0],1'b0};
		else if((r_AHBState==AHB_ENDDAT) & (r_FlitV==4'h0) & mHREADY)
			c_FlitV = 4'hf;
		else
			c_FlitV = r_FlitV;
	end
	
	//BurstType
	always@*
	begin
		if((r_AHBState==AHB_ENDDAT) & (r_FlitV==4'h0) & mHREADY)
			c_BurstType = 2'b11;
		else if((r_AHBState==AHB_ENDDAT) & (r_FlitV==4'h8) & mHREADY)
			c_BurstType = 2'b00;
		else if((r_AHBState==AHB_ENDDAT) & (r_FlitV!=4'h0) & (r_FlitV!=4'h8) & mHREADY)
			c_BurstType = 2'b01;
		else
			c_BurstType = r_BurstType;
	end
	
	//c_FstFlit
	always@*
	begin
		if((r_AHBState==AHB_REQBUS) & (c_AHBState==AHB_REQSND))
			c_FstFlit = 1'b1;
		else if((r_AHBState==AHB_REQSND) & r_FstFlit & mHREADY)
			c_FstFlit = 1'b0;
		else
			c_FstFlit = r_FstFlit;
	end
	
	//c_IndexAddr，20位地址对应1MB（足够满足最大分辨率640*480下一帧的容量：640*480*2B即600KB）
	always@*
	begin
		if(r_ZONE_ReStart)
			c_IndexAddr	= 20'h0;
		else if(o_ReadEn)
			c_IndexAddr	= 20'h10 + r_IndexAddr;
		else
			c_IndexAddr	= r_IndexAddr;
	end
	
		
	//mHBUSRREQ & mHLOCK	
	assign	mHBUSRREQ	= (r_AHBState==AHB_REQBUS) | (r_AHBState==AHB_REQSND) & (r_BurstType!=2'b11) & (r_FlitV!=4'h8);
	assign	mHLOCK     	= 1'b0;
	
	//AHB Master
	
	//2'b00: IDLE; 2'b10: NONSEQ; 2'b11: SEQ
	assign	mHTRANS		= (r_AHBState==AHB_REQSND) ? (r_FstFlit ? 2'b10 : 2'b11) : 2'b00;
	assign	mHWRITE		= 1'b1;
	assign	mHSIZE		= 3'b010;	//32 bits
	assign	mHPORT		= 4'b0001;
		
	//3'b000: SINGLE; 3'b001: INCR; 3'b011: INCR4
	assign	mHBURST		= {1'b0,r_BurstType} ;
	
	//Addr
	always@*
	begin
		case(r_FlitV)
		4'hf   :	{c_LowAddr,c_DataMux}={4'h0,2'h0};
		4'he   :	{c_LowAddr,c_DataMux}={4'h4,2'h0};
		4'hc   :	{c_LowAddr,c_DataMux}={4'h8,2'h1};
		4'h8   :	{c_LowAddr,c_DataMux}={4'hc,2'h2};
		default:	{c_LowAddr,c_DataMux}={4'h0,2'h3};
		endcase
	end
			
	assign	mHADDR = ((r_CurrentZone==2'b00) ? BASE_ADDR_ZONE1 :
	     			  (r_CurrentZone==2'b01) ? BASE_ADDR_ZONE2 : BASE_ADDR_ZONE3) + r_IndexAddr + c_LowAddr ;  


	//Write Data      	     
	assign	mHWDATA = (c_DataMux==2'b00) ? i_RdData[ 31:  0] :
					  (c_DataMux==2'b01) ? i_RdData[ 63: 32] :
					  (c_DataMux==2'b10) ? i_RdData[ 95: 64] : i_RdData[127: 96] ;     
	
	
	//Read FIFO
	assign	o_ReadEn =  (r_AHBState==AHB_IDLE  ) & ~i_FIFOEmpty & r_ProtocolErr |
						(r_AHBState==AHB_ENDDAT) & (r_FlitV==4'h0) & mHREADY ;
	
	
endmodule
