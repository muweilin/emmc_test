
module MDLR(
	Clock			,
	Reset_L			,
	TimerCfg		,
	TestFinsh		,
	TestType		,
	IPRD			,
	TPRD			,
	FstTestComplete	,
	MDLR_State
);
	input			Clock			;
	input			Reset_L			;
	input [4:0]		TimerCfg		;
	output			TestFinsh		;
	output			TestType		;
	output[7:0]		IPRD			;
	output[7:0]		TPRD			;
	output			FstTestComplete	;
	output[2:0]		MDLR_State		;

	parameter		MDLR_IDLE	=3'h0;
	parameter		MDLR_Start	=3'h1;
	parameter		MDLR_Mod	=3'h2;
	parameter		MDLR_Compare=3'h3;
	parameter		MDLR_Wait	=3'h4;
	
	parameter		DelayMax	=8'hff;
	
	//define var
	reg	[ 2:0]		r_CurrentState	;
	reg	[ 2:0]		c_NextState		;
	
	wire			c_FristTest		;
	reg				r1_StartEn		;
	reg				r2_StartEn		;
	reg				r3_StartEn		;
	reg				r4_StartEn		;
	
	wire			c_PeriodTest	;
	reg				r_PeriodTestEn	;
	reg [31:0]		r_PeriodTestCnt ;
	
	reg	[3:0]		r_ClrCnt		;
	reg	[3:0]		r_ModCnt		;	
	reg [2:0]		r_WaitCnt		;
	reg             r_CompareFlag   ;
	reg [7:0]		r_LoopCnt		;
	reg				r_Entest		;
	
	reg				r_TestFinsh		;
	reg				r_TestType		;
	reg [7:0]		r_IPRD			;
	reg [7:0]		r_TPRD			;
			
	wire			c_TestLoop		;
	wire			c_TestFinish 	;
	
	wire			c_Dff0in		;
	reg				r_Dff0out		;
	            	            	
	wire			c_DLLout		;
	reg				r_Dff1out		;
	reg				r_Dff2out		;
	            	            	
	wire			U1_out			;
	reg				r_Dff3out		;
	reg				r_Dff4out		;
	reg				r_Dff5out		;
	            	            	
	wire			U_add  			;
	wire			U3_out      	;
	wire			U4_out      	;
	reg				r_Dff6out		;
	
	//logic
	
	//fsm state
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
			r_CurrentState <= MDLR_IDLE;
		else
			r_CurrentState <= c_NextState;
	end
	
	//the first test
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
		begin
			r1_StartEn <= 1'h0;
			r2_StartEn <= 1'h0;
			r3_StartEn <= 1'h0;
			r4_StartEn <= 1'h0;
		end
		else
		begin
			r1_StartEn <= 1'b1;
			r2_StartEn <= r1_StartEn;
			r3_StartEn <= r2_StartEn;
			r4_StartEn <= r3_StartEn;
		end
	end
	
	assign c_FristTest = r3_StartEn &!r4_StartEn;
	
	//period test
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
		begin
			r_PeriodTestEn <= 1'h0;
		end
		else
		begin
			if(~r_PeriodTestEn&c_TestFinish)
				r_PeriodTestEn <= 1'b1;
		end
	end
	
	assign	FstTestComplete = r_PeriodTestEn ;
	
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
		begin
			r_PeriodTestCnt <= 32'h0;
		end
		else
		begin
			if(r_PeriodTestEn)
				r_PeriodTestCnt <= (r_PeriodTestCnt==(32'h1<<TimerCfg)) ? 32'h0 : r_PeriodTestCnt + 32'h1;
		end
	end
	
	assign c_PeriodTest = r_PeriodTestEn&(r_PeriodTestCnt==(32'h1<<TimerCfg));
	
		
	//counter for start state
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
			r_ClrCnt <= 4'h0;
		else if((r_CurrentState==MDLR_Start)&(r_ClrCnt!=4'hf))
			r_ClrCnt <= r_ClrCnt+4'h1;
		else if((r_CurrentState==MDLR_Mod)&(r_ClrCnt==4'hf))
			r_ClrCnt <= 4'h0;
	end
	
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
			r_ModCnt <= 4'h0;
		else if((r_CurrentState==MDLR_Mod)&(r_ModCnt!=4'hf))
			r_ModCnt <= r_ModCnt+4'h1;
		else if((r_CurrentState==MDLR_Compare)&(r_ModCnt==4'hf))
			r_ModCnt <= 4'h0;
	end
	
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
			r_WaitCnt <= 3'h0;
		else if((r_CurrentState==MDLR_Wait)&(r_WaitCnt!=3'h7))
			r_WaitCnt <= r_WaitCnt+3'h1;
		else if((r_CurrentState==MDLR_Wait)&(r_WaitCnt==3'h7))
			r_WaitCnt <= 3'h0;
	end
	
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
			r_CompareFlag <= 1'b0;
		else if((r_CurrentState==MDLR_Compare)&(r_CompareFlag==1'b0))
			r_CompareFlag <= 1'b1;
		else if((r_CurrentState==MDLR_Compare)&(r_CompareFlag==1'b1))
			r_CompareFlag <= 1'b0;
	end
	
	//default value is 1
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
			r_LoopCnt <= 8'h1;
		else if(c_TestLoop)
			r_LoopCnt <= r_LoopCnt+8'h1;
		else if(c_TestFinish)
			r_LoopCnt <= 8'h1;
	end
	
	//Test Enable
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
			r_Entest <= 1'h0;
		else if((r_CurrentState==MDLR_Start)&(r_ClrCnt==4'h8))
			r_Entest <= 1'h1;
	     else if(c_TestFinish)
			r_Entest <= 1'h0;
	end
	
	//IPRD TPRD, TPRD need be update at the first
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
		begin
			r_TestFinsh	<= 1'b0;
			r_TestType	<= 1'b0;
			r_IPRD 		<= 8'h1;
			r_TPRD		<= 8'h1;
		end
		else
		begin
			if(~r_PeriodTestEn&c_TestFinish)
				r_IPRD 	<= r_LoopCnt ;
			
			if(c_TestFinish)
				r_TPRD	<= r_LoopCnt;
				
			r_TestFinsh <= c_TestFinish;
			r_TestType  <= r_PeriodTestEn;
		end
	end
	
	assign TestFinsh= r_TestFinsh 	;
	assign TestType = r_TestType	;
	assign IPRD		= r_IPRD 		;	
	assign TPRD		= r_TPRD 		;
	
	always @*
	begin
		case(r_CurrentState)
		MDLR_Start:
			if(r_ClrCnt==4'hf)
				c_NextState = MDLR_Mod;
			else
				c_NextState = r_CurrentState;
		MDLR_Mod:
			if(r_ModCnt==4'hf)
				c_NextState = MDLR_Compare;
			else
				c_NextState = r_CurrentState;
		MDLR_Compare:
			if(c_TestLoop)
				c_NextState = MDLR_Mod;
			else if(c_TestFinish)
				c_NextState = MDLR_Wait;
			else
				c_NextState = r_CurrentState;
		MDLR_Wait:
			if(r_WaitCnt==3'h7)
				c_NextState = MDLR_IDLE;
			else
				c_NextState = r_CurrentState;
		default:
			if(c_FristTest|c_PeriodTest)
				c_NextState = MDLR_Start;
			else
				c_NextState = r_CurrentState;
		endcase
	end
	
	assign	MDLR_State  = r_CurrentState ;
	
	//finish include overflow
	assign c_TestLoop	= (r_CurrentState==MDLR_Compare)&r_CompareFlag& ~r_Dff6out&(r_LoopCnt!=DelayMax);
	assign c_TestFinish = (r_CurrentState==MDLR_Compare)&r_CompareFlag&( r_Dff6out|(r_LoopCnt==DelayMax));
	
	
	//the following logic need to custom
	assign c_Dff0in = ~(~r_Entest|r_Dff0out);
	
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
			r_Dff0out <= 1'h0;
		else
			r_Dff0out <= c_Dff0in;
	end
	
	always @(negedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
		begin
			r_Dff1out <= 1'h0;
			r_Dff2out <= 1'h0;
		end
		else
		begin
			r_Dff1out <= c_DLLout;
			r_Dff2out <= r_Dff0out;
		end
	end

	assign U1_out = r_Dff1out^r_Dff2out;
	
	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
		begin
			r_Dff3out <= 1'h0;
			r_Dff4out <= 1'h0;
			r_Dff5out <= 1'h0;
		end
		else
		begin
			r_Dff3out <= U1_out;
			r_Dff4out <= r_Dff3out;
			r_Dff5out <= r_Dff4out;
		end
	end

	assign U_add  = r_Dff5out&(r_CurrentState==MDLR_Compare);
	assign U3_out = U_add  | r_Dff6out ;
	assign U4_out = U3_out & r_Entest  ;

	always @(posedge Clock or negedge Reset_L)
	begin
		if(!Reset_L)
			r_Dff6out <= 1'h0;
		else
			r_Dff6out <= U4_out;
	end
	
	//the module need to custom
	DLL_DELAY_LINE_256	mdlr_line(
		.o_DLLout		(c_DLLout	),
		.i_DLLin		(r_Dff0out	),
		.sel_index      (r_LoopCnt	)
		);

endmodule
