/****************************************************************
  ** Project: xxx
*****************************************************************
  ** File   : camera_bridge.v
  ** Author : xxx
  ** C-Date : 2016-10-4
  ** M-Date : 2016-10-4
  
  ** Function Descriptoin : 
  	 	a.	Camera Bridge
  		b.	
****************************************************************/

module CAMERA_Bridge(
	/***** pin *****/
	pclk			,
	vsync			,
	href			,
	data			,
		
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
	mHRESP      	,
	mHRDATA     	,
	mHBUSRREQ  		,
	mHLOCK     		,
	mHGRANT    		,

	//Slave
	sHSEL			,
	sHWrite         ,
	sHTRANS         ,
	sHSIZE          ,
	sHBURST         ,
	sHADDR          ,
	sHWDATA         ,
	sHREADY         ,
	sHREADY_RESP    ,	
	sHRESP          ,
	sHRDATA         ,

	/**** interrupt ****/
	Interrupt
);
	/***** pin *****/
	input 			pclk			;
	input 			vsync			;
	input 			href			;
	input [ 7: 0]	data			;
		
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
	input [ 1: 0]	mHRESP      	;
	input [31: 0]	mHRDATA     	;
	output			mHBUSRREQ  		;
	output			mHLOCK     		;
	input			mHGRANT    		;

	//Slave
	input			sHSEL			;
	input			sHWrite         ;
	input [ 1: 0]	sHTRANS         ;
	input [ 2: 0]	sHSIZE          ;
	input [ 2: 0]	sHBURST         ;
	input [31: 0]	sHADDR          ;
	input [31: 0]	sHWDATA         ;
	input			sHREADY         ;
	output			sHREADY_RESP    ;	
	output[ 1: 0]	sHRESP          ;
	output[31: 0]	sHRDATA         ;

	/**** interrupt ****/
	output			Interrupt		;
	
	/*****************************************/
	
	wire  [31: 0]	BASE_ADDR_ZONE1		;
	wire  [31: 0]	BASE_ADDR_ZONE2		;
	wire  [31: 0]	BASE_ADDR_ZONE3		;
	                                	
	wire  			DATAOK_ZONE1		;
	wire  			DATAOK_ZONE2		;
	wire  			DATAOK_ZONE3		;
	                                	
	wire 			RQOverFlow			;
	wire  [ 3: 0]	RQCNT				;
	wire  [ 1: 0]	CurrentZone			;
	wire  [ 1: 0]	ProtocolErr			;
	                                	
	wire 			DATAOK_ZONE1_Set	;
	wire 			DATAOK_ZONE2_Set	;
	wire 			DATAOK_ZONE3_Set	;
	                                	
	wire  			HrefCtrl			;
	wire  			VsyncCtrl			;
	wire  			CaptureEn       	;
	
	wire			c_FIFOEmpty			;		    
	wire			c_FIFOReadEn		;
	wire   [127: 0]	c_FIFORdData		;
	wire			c_ZONE_ReStart		;
	
	/*****************************************/
	CAMERA_CSR	CAMERA_CSR(
		/**** AHB system ****/	
		//global
		.HCLK				(HCLK				),
		.HReset_N			(HReset_N			),
		                                    	
		//Slave                             	
		.sHSEL				(sHSEL				),
		.sHWrite         	(sHWrite        	),
		.sHTRANS         	(sHTRANS        	),
		.sHSIZE          	(sHSIZE         	),	//unuse;
		.sHBURST         	(sHBURST        	),	//unuse;
		.sHADDR          	(sHADDR         	),	//[1:0] unuse;
		.sHWDATA         	(sHWDATA        	),
		.sHREADY         	(sHREADY        	),
		.sHREADY_RESP    	(sHREADY_RESP   	),
		.sHRESP          	(sHRESP         	),
		.sHRDATA         	(sHRDATA        	),
		                                    	
		/**** interrupt ****/               	
		.Interrupt			(Interrupt			),
		
		/**** configuratoin ***/
		.BASE_ADDR_ZONE1	(BASE_ADDR_ZONE1	),
		.BASE_ADDR_ZONE2	(BASE_ADDR_ZONE2	),
		.BASE_ADDR_ZONE3	(BASE_ADDR_ZONE3	),
		                                        
		.DATAOK_ZONE1		(DATAOK_ZONE1		),
		.DATAOK_ZONE2		(DATAOK_ZONE2		),
		.DATAOK_ZONE3		(DATAOK_ZONE3		),	
		                                        
		.RQOverFlow			(RQOverFlow			),
		.RQCNT				(RQCNT				),
		.CurrentZone		(CurrentZone		),
		.ProtocolErr		(ProtocolErr		),
		                                        
		.DATAOK_ZONE1_Set	(DATAOK_ZONE1_Set	),
		.DATAOK_ZONE2_Set	(DATAOK_ZONE2_Set	),
		.DATAOK_ZONE3_Set	(DATAOK_ZONE3_Set	),
		                                        
		.HrefCtrl			(HrefCtrl			),
		.VsyncCtrl			(VsyncCtrl			),
		.CaptureEn			(CaptureEn			)
		);
	
	CAMERA_CAPTURE	CAMERA_CAPTURE(
		/***** pin *****/
		.pclk				(pclk				),
		.vsync				(vsync				),
		.href				(href				),
		.data				(data				),
		
		/**** configuratoin ***/                                     
		.RQOverFlow			(RQOverFlow			),
		.RQCNT				(RQCNT				),
		                                       
		.HrefCtrl			(HrefCtrl			),
		.VsyncCtrl			(VsyncCtrl			),
		.CaptureEn			(CaptureEn			),
		
		/**** RQ Read ****/	
		.HCLK				(HCLK				),
		.HReset_N			(HReset_N			),
	
		.o_FIFOEmpty		(c_FIFOEmpty		),
		.i_ReadEn			(c_FIFOReadEn		),
		.o_RdData			(c_FIFORdData		),
	
		.o_ZONE_ReStart		(c_ZONE_ReStart		)
		     
		);
	
	CAMERA_AHB_MASTER	CAMERA_AHB_MASTER(
		/**** AHB system ****/	
		//global
		.HCLK				(HCLK				),
		.HReset_N			(HReset_N			),
		
		//Master
		.mHADDR				(mHADDR				),
		.mHTRANS     		(mHTRANS    		),
		.mHWRITE     		(mHWRITE    		),
		.mHSIZE      		(mHSIZE     		),
		.mHBURST     		(mHBURST    		),
		.mHPORT      		(mHPORT     		),
		.mHWDATA     		(mHWDATA    		),
		.mHREADY     		(mHREADY    		),
		.mHRESP      		(mHRESP     		),
		.mHRDATA     		(mHRDATA    		),
		.mHBUSRREQ  		(mHBUSRREQ  		),
		.mHLOCK     		(mHLOCK     		),
		.mHGRANT			(mHGRANT			),
		
		/**** With Capture ****/
		.i_FIFOEmpty		(c_FIFOEmpty		),
		.o_ReadEn			(c_FIFOReadEn		),
		.i_RdData			(c_FIFORdData		),
		                                        
		.i_ZONE_ReStart		(c_ZONE_ReStart		),
    	
		/**** configuratoin ***/
		.BASE_ADDR_ZONE1	(BASE_ADDR_ZONE1	),
		.BASE_ADDR_ZONE2	(BASE_ADDR_ZONE2	),
		.BASE_ADDR_ZONE3	(BASE_ADDR_ZONE3	),
		                                        
		.DATAOK_ZONE1		(DATAOK_ZONE1		),
		.DATAOK_ZONE2		(DATAOK_ZONE2		),
		.DATAOK_ZONE3		(DATAOK_ZONE3		),	  	
		                                        
		.CurrentZone		(CurrentZone		),
		.ProtocolErr		(ProtocolErr		),
		                                        
		.DATAOK_ZONE1_Set	(DATAOK_ZONE1_Set	),
		.DATAOK_ZONE2_Set	(DATAOK_ZONE2_Set	),
		.DATAOK_ZONE3_Set	(DATAOK_ZONE3_Set	)		
		);
		
endmodule
