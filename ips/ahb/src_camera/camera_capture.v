/****************************************************************
  ** Project: xxx
*****************************************************************
  ** File   : camera_capture.v
  ** Author : xxx
  ** C-Date : 2016-10-3
  ** M-Date : 2016-10-3
  
  ** Function Descriptoin : 
  	 	a.	camera OV7725 interface
  		b.	
****************************************************************/
`include "config.sv"

module CAMERA_CAPTURE(
	/***** pin *****/
	pclk			,
	vsync			,
	href			,
	data			,
	
	/**** configuratoin ***/
	RQOverFlow		,
	RQCNT			,
	
	HrefCtrl		,
	VsyncCtrl		,
	CaptureEn		,
	
	/**** RQ Read ****/	
	HCLK			,
	HReset_N		,
	
	o_FIFOEmpty		,
	i_ReadEn		,
	o_RdData		,
	
	o_ZONE_ReStart
);
	/***** pin *****/
	input 			pclk			;
	input 			vsync			;
	input 			href			;
	input [ 7: 0]	data			;
	
	/**** configuratoin ***/
	output			RQOverFlow		;
	output [ 3: 0]	RQCNT			;
	
	input 			HrefCtrl		;
	input 			VsyncCtrl		;
	input 			CaptureEn       ;
	
	/**** RQ Read ****/
	input			HCLK			;
	input			HReset_N		;
	
	output			o_FIFOEmpty		;
	input			i_ReadEn		;
	output[127: 0]	o_RdData		;
	
	output			o_ZONE_ReStart	;
	
	
	/****************************************************/
		
	//reset(asyn reset and syn deassert)	
	reg	[ 2: 0]		r_ResetN_pclk;
	wire			Reset_N_pclk ;
	
	always@(posedge pclk or negedge HReset_N)
	begin
		if(~HReset_N)
			r_ResetN_pclk	<= 3'b000;
		else
			r_ResetN_pclk	<= {r_ResetN_pclk[1:0],1'b1};
	end
	
	assign Reset_N_pclk = r_ResetN_pclk[2] ;
	
	//Clock Domain Cross
	reg				r_HrefCtrl		;
	reg				r_VsyncCtrl		;
	reg				r_CaptureEn     ;
	
	reg				r1_HrefCtrl		;
	reg				r1_VsyncCtrl	;
	reg				r1_CaptureEn    ;
	
	reg             r_CaptureEnTrue ;
	
	always@(posedge pclk or negedge Reset_N_pclk)
	begin
		if(~Reset_N_pclk)
		begin
			r_HrefCtrl	<=  1'h0;
			r_VsyncCtrl	<=  1'h0;
			r_CaptureEn <=  1'h0;
			
			r1_HrefCtrl	<=  1'h0;
			r1_VsyncCtrl<=  1'h0;
			r1_CaptureEn<=  1'h0;
		end
		else
		begin
			r_HrefCtrl	<=  HrefCtrl	;
			r_VsyncCtrl	<=  VsyncCtrl	;
			r_CaptureEn <=  CaptureEn   ;
			
			r1_HrefCtrl	<=  r_HrefCtrl	;
			r1_VsyncCtrl<=  r_VsyncCtrl	;
			r1_CaptureEn<=  r_CaptureEn ;
		end	
	end
	
	
	//Receive Data
	wire			c_WrRcvDataEn	;		
	reg [  3: 0]	r_RcvCnt		;
	reg [127: 0]	r_RcvData		;
	
	always@(posedge pclk or negedge Reset_N_pclk)
	begin
		if(~Reset_N_pclk)
		begin
			r_RcvCnt	<=  4'h0;
			r_RcvData	<=128'h0;
		end
		else
		begin
			if(c_WrRcvDataEn)
			begin
				r_RcvCnt	<=  4'h1 + r_RcvCnt;
				case(r_RcvCnt)
				4'd00   :   r_RcvData[00*8+7:00*8] <= data ;
				4'd01   :   r_RcvData[01*8+7:01*8] <= data ;
				4'd02   :   r_RcvData[02*8+7:02*8] <= data ;
				4'd03   :   r_RcvData[03*8+7:03*8] <= data ;
				4'd04   :   r_RcvData[04*8+7:04*8] <= data ; 
				4'd05   :   r_RcvData[05*8+7:05*8] <= data ; 
				4'd06   :   r_RcvData[06*8+7:06*8] <= data ; 
				4'd07   :   r_RcvData[07*8+7:07*8] <= data ; 
				4'd08   :   r_RcvData[08*8+7:08*8] <= data ; 
				4'd09   :   r_RcvData[09*8+7:09*8] <= data ; 
				4'd10   :   r_RcvData[10*8+7:10*8] <= data ; 
				4'd11   :   r_RcvData[11*8+7:11*8] <= data ; 
				4'd12   :   r_RcvData[12*8+7:12*8] <= data ; 
				4'd13   :   r_RcvData[13*8+7:13*8] <= data ; 
				4'd14   :   r_RcvData[14*8+7:14*8] <= data ; 
				default :   r_RcvData[15*8+7:15*8] <= data ; 
				endcase
			end
		end	
	end
	
	//需要由硬件保证在切换上述控制时必须以帧为边界。
	//因为vsync、href的极性控制信号只有在采集使能为零时软件可配，所以硬件只要保证切换采样使能时必须以帧为边界即可。
	//1. 在数据采样使能默认关闭期间，vsync、href接口上已经在输出采集数据。当开启数据采样使能时，硬件保证正在传输的这帧数据被忽略，下一帧数据开始采集；
	//2. 同理，在关闭采样使能时，硬件保证正在传输的这帧数据被采集，下一帧数据开始忽略。
	assign c_WrRcvDataEn = r_CaptureEnTrue & ( r1_HrefCtrl ? ~href : href);
	
	
	//Write FIFO	
	reg			r_WriteFIFOEn		;
	reg [ 3: 0]	r_WriteAddrGray		;	//Gray Code
	wire[ 3: 0]	c_WriteAddrGrayNxt	;
	reg [ 3: 0] r_WriteAddr			;
	wire		c_FIFOFull			;
	wire		c_WriteTrue			;
	
	reg [ 3: 0] r1_WriteAddrGray    ;
	
	always@(posedge pclk or negedge Reset_N_pclk)
	begin
		if(~Reset_N_pclk)
		begin
			r_WriteFIFOEn	<= 1'b0;
			r_WriteAddrGray	<= 4'h0;
			r_WriteAddr		<= 4'h0;
			
			r1_WriteAddrGray<= 4'h0;
		end
		else
		begin
			r_WriteFIFOEn	<= c_WrRcvDataEn&(r_RcvCnt==4'hf);
			
			if(c_WriteTrue)
			begin
				r_WriteAddrGray	<=	c_WriteAddrGrayNxt	;
				r_WriteAddr		<=  r_WriteAddr + 4'h1  ;
			end
			
			r1_WriteAddrGray<= r_WriteAddrGray ;
		end
	end
	
	GRAYINC4BIT	m_grayinc4bit_wr(
		.o_dout	(	c_WriteAddrGrayNxt	),
		.i_din	(	r_WriteAddrGray		)
		);
	
	assign c_WriteTrue = r_WriteFIFOEn & ~c_FIFOFull ;
	assign RQOverFlow  = r_WriteFIFOEn &  c_FIFOFull ;
	
	//Read FIFO
	
	reg [ 3: 0]	r_ReadAddrGray		;	//Gray Code
	wire[ 3: 0]	c_ReadAddrGrayNxt	;
	reg [ 3: 0] r_ReadAddr			;
	wire		c_FIFOEmpty			;
	wire		c_ReadEn			;
	
	reg [ 3: 0]	r1_ReadAddrGray		;
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r_ReadAddrGray	<= 4'h0;
			r_ReadAddr		<= 4'h0;
			
			r1_ReadAddrGray <= 4'h0;
		end
		else
		begin
			if(c_ReadEn)
			begin
				r_ReadAddrGray	<=	c_ReadAddrGrayNxt	;
				r_ReadAddr		<=  r_ReadAddr + 4'h1  ;
			end
			
			r1_ReadAddrGray <= r_ReadAddrGray ;
		end
	end
	
	GRAYINC4BIT	m_grayinc4bit_rd(
		.o_dout	(	c_ReadAddrGrayNxt	),
		.i_din	(	r_ReadAddrGray		)
		);
	
	assign c_ReadEn = i_ReadEn & ~c_FIFOEmpty ;
	
	//Clock Domain Cross
	
	reg [ 3: 0]	 r_ReadAddrGray_pclk	;
	reg [ 3: 0]	r1_ReadAddrGray_pclk	;
	reg [ 3: 0]	r2_ReadAddrGray_pclk	;
	
	always@(posedge pclk or negedge Reset_N_pclk)
	begin
		if(~Reset_N_pclk)
		begin
			 r_ReadAddrGray_pclk	<= 4'b0;
			r1_ReadAddrGray_pclk	<= 4'h0;
			r2_ReadAddrGray_pclk	<= 4'h0;
		end
		else
		begin
			 r_ReadAddrGray_pclk	<=r1_ReadAddrGray;      //2016.12.20 使用r1判断满（影响满变不满）
			r1_ReadAddrGray_pclk	<= r_ReadAddrGray_pclk;
			r2_ReadAddrGray_pclk	<=r1_ReadAddrGray_pclk;
		end
	end
	
	assign	c_FIFOFull = ( r_WriteAddrGray == {~r2_ReadAddrGray_pclk[3:2],r2_ReadAddrGray_pclk[1:0]} );
	
	
	reg [ 3: 0]	 r_WriteAddrGray_HCLK	;
	reg [ 3: 0]	r1_WriteAddrGray_HCLK	;
	reg [ 3: 0]	r2_WriteAddrGray_HCLK	;
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			 r_WriteAddrGray_HCLK	<= 4'h0;
			r1_WriteAddrGray_HCLK	<= 4'h0;
			r2_WriteAddrGray_HCLK	<= 4'h0;
		end
		else
		begin
			 r_WriteAddrGray_HCLK	<=r1_WriteAddrGray;         //2016.12.20 使用r1判断空（影响空变不空）
			r1_WriteAddrGray_HCLK	<= r_WriteAddrGray_HCLK;
			r2_WriteAddrGray_HCLK	<=r1_WriteAddrGray_HCLK;
		end
	end
	
	assign c_FIFOEmpty		=	( r2_WriteAddrGray_HCLK == r_ReadAddrGray);
	
	assign o_FIFOEmpty = c_FIFOEmpty;
	
	//Latch Array
	ASYNFIFO_1R1W_8ITEM 	ASYNFIFO_1R1W_8ITEM(
		.i_RdAddr		(r_ReadAddr[2:0]	),
		.o_RdData		(o_RdData			),
		
		.WCLK			(pclk				),
		.Reset_N        (Reset_N_pclk       ),  //2016.12.29 add
		.i_WrEn			(c_WriteTrue		),
		.i_WrAddr		(r_WriteAddr[2:0]	),
		.i_WrData		(r_RcvData			)
		);
	
	//FIFO Counter
	//写操作在pclk时钟域，读操作在HCLK时钟域
	//该实现方式依赖于时钟的频率关系，本实现方式（异步交接）要求HCLK至少是pclk的两倍频
	
	reg				r1_WriteEnTrue_HCLK	;
	reg				r2_WriteEnTrue_HCLK	;
	reg				r3_WriteEnTrue_HCLK ;
	
	reg [ 3: 0]		r_ItemCnt		;
	reg [ 3: 0]		c_ItemCnt		;
	wire			c_ItemCntAdd	;
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r1_WriteEnTrue_HCLK		<= 1'h0;
			r2_WriteEnTrue_HCLK		<= 1'h0;
			r3_WriteEnTrue_HCLK		<= 1'h0;
			
			r_ItemCnt				<= 4'h0;
		end
		else
		begin
			r1_WriteEnTrue_HCLK		<= c_WriteTrue;
			r2_WriteEnTrue_HCLK		<=r1_WriteEnTrue_HCLK;
			r3_WriteEnTrue_HCLK		<=r2_WriteEnTrue_HCLK;
			
			r_ItemCnt				<= c_ItemCnt;
		end
	end
	
	assign c_ItemCntAdd = r2_WriteEnTrue_HCLK & ~r3_WriteEnTrue_HCLK ;
	
	always@*
	begin
		case({c_ItemCntAdd,c_ReadEn})
		2'b01  :	c_ItemCnt = r_ItemCnt - 4'h1;
		2'b10  :	c_ItemCnt = r_ItemCnt + 4'h1;
		default:	c_ItemCnt = r_ItemCnt ;
		endcase
	end
	
	assign RQCNT = r_ItemCnt ;
	
	//ZONE ReStart
	reg 			 r_Start_PreEn	;
	reg 			r1_Start_PreEn	;
	reg 			r2_Start_PreEn	;
	wire             c_UpdateEn     ;
	
	reg             r_Start         ;
	
	reg				r1_Start_HCLK	;
	reg				r2_Start_HCLK	;
	reg				r3_Start_HCLK	;
	
	
	always@(posedge pclk or negedge Reset_N_pclk)
	begin
		if(~Reset_N_pclk)
		begin
			 r_Start_PreEn	<= 1'b0;
			r1_Start_PreEn  <= 1'b0; 
			r2_Start_PreEn  <= 1'b0;
		end
		else
		begin
			 r_Start_PreEn	<= ~r1_VsyncCtrl ? vsync : ~vsync	;
			r1_Start_PreEn  <= r_Start_PreEn;
			r2_Start_PreEn  <=r1_Start_PreEn;
		end
	end
	
	assign  c_UpdateEn = r1_Start_PreEn & ~r2_Start_PreEn ;
	
	
	always@(posedge pclk or negedge Reset_N_pclk)
	begin
		if(~Reset_N_pclk)
		begin
			r_CaptureEnTrue	<= 1'b0;
		end
		else
		begin
	        if(c_UpdateEn)
	            r_CaptureEnTrue	<= r1_CaptureEn ;
		end
	end
	
	always@(posedge pclk or negedge Reset_N_pclk)
	begin
		if(~Reset_N_pclk)
		begin
			 r_Start	<= 1'b0;
		end
		else
		begin
			 r_Start	<= r2_Start_PreEn & r_CaptureEnTrue	;
		end
	end
	
	always@(posedge HCLK or negedge HReset_N)
	begin
		if(~HReset_N)
		begin
			r1_Start_HCLK		<= 1'h0;
			r2_Start_HCLK		<= 1'h0;
			r3_Start_HCLK		<= 1'h0;
		end
		else
		begin
			r1_Start_HCLK		<= r_Start;
			r2_Start_HCLK		<=r1_Start_HCLK;
			r3_Start_HCLK		<=r2_Start_HCLK;
		end
	end
	
	assign	o_ZONE_ReStart = r2_Start_HCLK & ~r3_Start_HCLK ;
	
endmodule


module	GRAYINC4BIT(
	o_dout	,
	i_din
);
	output	[3:0]	o_dout;
	input	[3:0]	i_din;

	assign	o_dout[3]	=	i_din[3] && ( |i_din[1:0] ) || i_din[2] && !( |i_din[1:0] );
	assign	o_dout[2]	=	!i_din[3] && !( !i_din[1] || i_din[0] ) || i_din[2] && ( !i_din[1] || i_din[0] ); 
	assign	o_dout[1]	=	( i_din[3] && i_din[2] || !i_din[3] && !i_din[2] ) && i_din[0] || i_din[1] && !i_din[0];
	assign	o_dout[0]	=	!i_din[3] && ( i_din[2] && i_din[1] || !i_din[2] && !i_din[1] )
					|| i_din[3] && ( i_din[2] ^ i_din[1]  );
endmodule

module    MDecoder8(
    ICode3,
    ODec8
);
//-------IO Declaration ----------
    input [2:0]   ICode3;
    output[7:0]   ODec8;
//------- ----------
    assign    ODec8={
            (  ICode3[2] &&  ICode3[1] &&  ICode3[0] ),
            (  ICode3[2] &&  ICode3[1] && !ICode3[0] ),
            (  ICode3[2] && !ICode3[1] &&  ICode3[0] ),
            (  ICode3[2] && !ICode3[1] && !ICode3[0] ),
            ( !ICode3[2] &&  ICode3[1] &&  ICode3[0] ),
            ( !ICode3[2] &&  ICode3[1] && !ICode3[0] ),
            ( !ICode3[2] && !ICode3[1] &&  ICode3[0] ),
            ( !ICode3[2] && !ICode3[1] && !ICode3[0] )
        };

endmodule

module	ASYNFIFO_1R1W_8ITEM (
	i_RdAddr	,
	o_RdData	,
	
	WCLK		,
	Reset_N     ,
	i_WrEn		,
	i_WrAddr	,
	i_WrData
);
	
	parameter	LENTH	=	128	;
	parameter   DEPTH   =     8 ;
	parameter   ADDR    =     3 ;
	
	input [ ADDR-1:0]	i_RdAddr	;
	output[LENTH-1:0]	o_RdData	;

	input				WCLK		;
	input               Reset_N     ;
	input				i_WrEn		;
	input [ ADDR-1:0]	i_WrAddr	;
	input [LENTH-1:0]	i_WrData	;
	
	/**************************************/
	
	reg	[LENTH-1:0]	ram_Data [DEPTH-1:0];
		
	//2016.12.20 修改为Latch实现方式	
	wire[DEPTH-1:0] c_WrWord    ;
	reg [DEPTH-1:0] r_WrWord    ;
	reg [LENTH-1:0] r_WrData    ;
		
	//写数据采用带使能的触发器实现，不会拍拍连续写，所以数据一定能包住写使能
	//所以，写使能可以使用触发器实现
	//如果写使能使用Elat实现（半拍，便于数据包住写使能，连续写时有意义），代码需描述为不带复位（Elat没有复位功能），否则等价性不过
	always @ ( posedge WCLK or negedge Reset_N)
	begin
		if(~Reset_N)
		begin
		    r_WrWord <= {DEPTH{1'b0}};
		end
		else
		begin
		    r_WrWord <= {DEPTH{i_WrEn}} & c_WrWord;
		end
	end
	
	MDecoder8	MDecoder8_Wr(
    	.ICode3		(i_WrAddr	),
    	.ODec8		(c_WrWord	)
		);
		
	//写数据采用带使能的触发器实现，不会拍拍连续写，所以数据一定能包住写使能
	always @ ( posedge WCLK)
	begin
		if(i_WrEn)
			r_WrData	<=	i_WrData;
	end
	

`ifdef HAPS
    always@(negedge WCLK)
    begin
        if( r_WrWord[ 7] )  ram_Data[ 7]  <= r_WrData;
        if( r_WrWord[ 6] )  ram_Data[ 6]  <= r_WrData;
        if( r_WrWord[ 5] )  ram_Data[ 5]  <= r_WrData;
        if( r_WrWord[ 4] )  ram_Data[ 4]  <= r_WrData;
        if( r_WrWord[ 3] )  ram_Data[ 3]  <= r_WrData;
        if( r_WrWord[ 2] )  ram_Data[ 2]  <= r_WrData;
        if( r_WrWord[ 1] )  ram_Data[ 1]  <= r_WrData;
        if( r_WrWord[ 0] )  ram_Data[ 0]  <= r_WrData;
    end
`else	
	//Latch阵列写入
	always @ *
	begin
        if( r_WrWord[ 7] )  ram_Data[ 7]  <= r_WrData;
        if( r_WrWord[ 6] )  ram_Data[ 6]  <= r_WrData;
        if( r_WrWord[ 5] )  ram_Data[ 5]  <= r_WrData;
        if( r_WrWord[ 4] )  ram_Data[ 4]  <= r_WrData;
        if( r_WrWord[ 3] )  ram_Data[ 3]  <= r_WrData;
        if( r_WrWord[ 2] )  ram_Data[ 2]  <= r_WrData;
        if( r_WrWord[ 1] )  ram_Data[ 1]  <= r_WrData;
        if( r_WrWord[ 0] )  ram_Data[ 0]  <= r_WrData;
	end
`endif	
		
	//===================================
	wire[DEPTH-1:0] c_RdWord ;
	
	MDecoder8	MDecoder8_Rd(
    	.ICode3		(i_RdAddr	),
    	.ODec8		(c_RdWord	)
		);
	
	assign	o_RdData	=	  { LENTH{ c_RdWord[ 0]}} & ram_Data[ 0]
							| { LENTH{ c_RdWord[ 1]}} & ram_Data[ 1]
							| { LENTH{ c_RdWord[ 2]}} & ram_Data[ 2]
							| { LENTH{ c_RdWord[ 3]}} & ram_Data[ 3]
							| { LENTH{ c_RdWord[ 4]}} & ram_Data[ 4]
							| { LENTH{ c_RdWord[ 5]}} & ram_Data[ 5]
							| { LENTH{ c_RdWord[ 6]}} & ram_Data[ 6]
							| { LENTH{ c_RdWord[ 7]}} & ram_Data[ 7];
	
endmodule
