
`include "config.sv"

module AHB_SUBSYSTEM(
	/*****************  pin  ***************/
	//camera
	pclk	            ,
	vsync	            ,
	href	            ,
	data	            ,
	
	//eMMC
	cclk_out		    ,	
	                    
	ccmd_in			    ,   //注：在IOBuffer实现双向的控制
	ccmd_out			,
	ccmd_out_en		    ,
	                    
	cdata_in			,
	cdata_out			,
	cdata_out_en		,
	                    
	card_detect_n	    ,
	card_write_prt	    ,
	                    
	card_power_en		,
	card_volt_a		    ,
	card_volt_b		    ,
	ccmd_od_pullup_en_n ,
	                    
	                    
	//SD3.0 Start                    
	biu_volt_reg        ,        
	//SD3.0 End                    
	                    
	//SDIO3.0 Start
	card_int_n          ,     
	back_end_power      ,
	//SDIO3.0 Start                    
	                    
	//MMC4.4 Start                    
	mmc_4_4_rst_n       ,       
	//MMC4.4 End                    
	                               
	//eMMC4.5 Start
	biu_volt_reg_1_2    ,
	//eMMC4.5 End
	
	/*****************  port  ***************/
	//global
	hclk                ,
	hclk_2x             ,
    hclk_cam            ,
    hclk_ann            ,
	hresetn             ,
	
    //AXI Slave
	//AXI: Write Command Channel
	awid		        ,
	awaddr		        ,
	awlen		        ,
	awsize		        ,
	awburst	            ,
	awlock		        ,
	awcache	            ,
	awprot		        ,
	awvalid	            ,
	awready	            ,
	
	//AXI: Write Data Channel
	wdata		        ,
	wstrb		        ,
	wlast		        ,
	wvalid		        ,
	wready		        ,
	
	//AXI: Write Response Channel
	bid		            ,
	bresp		        ,
	bvalid		        ,
	bready		        ,
	
	//AXI: Read Command Channel
	arid		        ,
	araddr		        ,
	arlen		        ,
	arsize		        ,
	arburst	            ,
	arlock		        ,
	arcache	            ,
	arprot		        ,
	arvalid	            ,
	arready	            ,
	
	//AXI: Read Response Channel
	rid		            ,
	rdata		        ,
	rresp		        ,
	rlast		        ,
	rvalid		        ,
	rready		        ,
	
    //AXI Master
    m_awid		        ,
    m_awaddr	        ,
    m_awlen		        ,
    m_awsize	        ,
    m_awburst	        ,
    m_awlock	        ,
    m_awcache	        ,
    m_awprot	        ,
    m_awvalid	        ,
    m_awready	        ,
	
	//AXI: Write Data Channel
    m_wdata	            ,
    m_wstrb	            ,
    m_wlast	            ,
    m_wvalid	        ,
    m_wready	        ,
	
	//AXI: Write Response Channel
    m_bid		        ,
    m_bresp		        ,
    m_bvalid	        ,
    m_bready	        ,
	
	//AXI: Read Command Channel
    m_arid		        ,
    m_araddr	        ,
    m_arlen		        ,
    m_arsize	        ,
    m_arburst	        ,
    m_arlock	        ,
    m_arcache	        ,
    m_arprot	        ,
    m_arvalid	        ,
    m_arready	        ,
	
	//AXI: Read Response Channel
    m_rid		        ,
    m_rdata		        ,
    m_rresp		        ,
    m_rlast		        ,
    m_rvalid  		    ,
    m_rready	   	    ,
    
	//interrupt
	ahb_intr            ,
	Camera_intr         ,
	ann_intr            ,
//	ann_err_int         ,
	emmc_intr
);


	/*****************  pin  ***************/
	//camera
	input           pclk	            ;
	input           vsync	            ;
	input           href	            ;
	input [ 7: 0]   data	            ;
	
	//eMMC
	output[ 1: 0]   cclk_out		    ;	
	                    
	input [ 1: 0]   ccmd_in			    ;   //注：在IOBuffer实现双向的控制
	output[ 1: 0]   ccmd_out			;
	output[ 1: 0]   ccmd_out_en		    ;
	                    
	input [15: 0]   cdata_in			;   //注1：在IOBuffer实现双向的控制；注2：封装时只选取低四位作为芯片引脚
	output[15: 0]   cdata_out			;
	output[15: 0]   cdata_out_en		;
	                    
	input [ 1: 0]   card_detect_n	    ;
	input [ 1: 0]   card_write_prt	    ;
	                    
	output[ 1: 0]   card_power_en		;
	output[ 3: 0]   card_volt_a		    ;
	output[ 3: 0]   card_volt_b		    ;
	output          ccmd_od_pullup_en_n ;
	                    
	//SD3.0 Start                    
	output[ 1: 0]   biu_volt_reg        ;        
	//SD3.0 End                    
	                    
	//SDIO3.0 Start
	input [ 1: 0]   card_int_n          ;     
	output[ 1: 0]   back_end_power      ;
	//SDIO3.0 Start                    
	                    
	//MMC4.4 Start                    
	output[ 1: 0]   mmc_4_4_rst_n       ;       
	//MMC4.4 End                    
	                               
	//eMMC4.5 Start
	output[ 1: 0]   biu_volt_reg_1_2    ;
	//eMMC4.5 End
	
	/*****************  port  ***************/
	//global
	input           hclk                ;
	input           hclk_2x             ;
	input           hclk_cam            ;
	input           hclk_ann            ;
	input           hresetn             ;

    // ========  AXI Slave	======== //
	//AXI: Write Command Channel
	input [15: 0]   awid		        ;
	input [31: 0]   awaddr		        ;
	input [ 7: 0]   awlen		        ;
	input [ 2: 0]   awsize		        ;
	input [ 1: 0]   awburst	            ;
	input           awlock		        ;
	input [ 3: 0]   awcache	            ;
	input [ 2: 0]   awprot		        ;
	input           awvalid	            ;
	output          awready	            ;
	
	//AXI: Write Data Channel
	input [31: 0]   wdata		        ;
	input [ 3: 0]   wstrb		        ;
	input           wlast		        ;
	input           wvalid		        ;
	output          wready		        ;
	
	//AXI: Write Response Channel
	output[15: 0]   bid		            ;
	output[ 1: 0]   bresp		        ;
	output          bvalid		        ;
	input           bready		        ;
	
	//AXI: Read Command Channel
	input [15: 0]   arid		        ;
	input [31: 0]   araddr		        ;
	input [ 7: 0]   arlen		        ;
	input [ 2: 0]   arsize		        ;
	input [ 1: 0]   arburst	            ;
	input           arlock		        ;
	input [ 3: 0]   arcache	            ;
	input [ 2: 0]   arprot		        ;
	input           arvalid	            ;
	output          arready	            ;
	
	//AXI: Read Response Channel
	output[15: 0]   rid		            ;
	output[31: 0]   rdata		        ;
	output[ 1: 0]   rresp		        ;
	output          rlast		        ;
	output          rvalid		        ;
	input           rready		        ;
	
    // ======== AXI master ======== //
	//AXI: Write Command Channel
	output [15: 0]   m_awid		        ;
	output [31: 0]   m_awaddr	        ;
	output [ 7: 0]   m_awlen		    ;
	output [ 2: 0]   m_awsize	        ;
	output [ 1: 0]   m_awburst	        ;
	output           m_awlock	        ;
	output [ 3: 0]   m_awcache	        ;
	output [ 2: 0]   m_awprot	        ;
	output           m_awvalid	        ;
	input            m_awready	        ;
	
	//AXI: Write Data Channel
	output [31: 0]   m_wdata	        ;
	output [ 3: 0]   m_wstrb	        ;
	output           m_wlast	        ;
	output           m_wvalid	        ;
	input            m_wready	        ;
	
	//AXI: Write Response Channel
	input[15: 0]     m_bid		        ;
	input[ 1: 0]     m_bresp		    ;
	input            m_bvalid	        ;
	output           m_bready	        ;
	
	//AXI: Read Command Channel
	output [15: 0]   m_arid		        ;
	output [31: 0]   m_araddr	        ;
	output [ 7: 0]   m_arlen		    ;
	output [ 2: 0]   m_arsize	        ;
	output [ 1: 0]   m_arburst	        ;
	output           m_arlock	        ;
	output [ 3: 0]   m_arcache	        ;
	output [ 2: 0]   m_arprot	        ;
	output           m_arvalid	        ;
	input            m_arready	        ;
	
	//AXI: Read Response Channel
	input[15: 0]   m_rid		        ;
	input[31: 0]   m_rdata		        ;
	input[ 1: 0]   m_rresp		        ;
	input          m_rlast		        ;
	input          m_rvalid  		    ;
	output         m_rready	    	    ;

	//interrupt
	output          ahb_intr            ;
	output          Camera_intr         ;
	output          ann_intr            ;
//	output          ann_err_int         ;
	output          emmc_intr           ;
    
    /*******************************************************/
    
    wire[31: 0]         haddr_m1   ;
    wire                hbusreq_m1 ;
    wire[ 2: 0]         hburst_m1  ;
    wire                hlock_m1   ;
    wire[ 3: 0]         hprot_m1   ;
    wire[ 2: 0]         hsize_m1   ;
    wire[ 1: 0]         htrans_m1  ;
    wire[31: 0]         hwdata_m1  ;
    wire                hwrite_m1  ;
    wire                hgrant_m1  ;
    
    wire[31: 0]         haddr_m2   ;
    wire                hbusreq_m2 ;
    wire[ 2: 0]         hburst_m2  ;
    wire                hlock_m2   ;
    wire[ 3: 0]         hprot_m2   ;
    wire[ 2: 0]         hsize_m2   ;
    wire[ 1: 0]         htrans_m2  ;
    wire[31: 0]         hwdata_m2  ;
    wire                hwrite_m2  ;
    wire                hgrant_m2  ;
    
    wire[31: 0]         haddr_m3   ;
    wire                hbusreq_m3 ;
    wire[ 2: 0]         hburst_m3  ;
    wire                hlock_m3   ;
    wire[ 3: 0]         hprot_m3   ;
    wire[ 2: 0]         hsize_m3   ;
    wire[ 1: 0]         htrans_m3  ;
    wire[31: 0]         hwdata_m3  ;
    wire                hwrite_m3  ;
    wire                hgrant_m3  ;
    
    wire[31: 0]         haddr_m4   ;
    wire                hbusreq_m4 ;
    wire[ 2: 0]         hburst_m4  ;
    wire                hlock_m4   ;
    wire[ 3: 0]         hprot_m4   ;
    wire[ 2: 0]         hsize_m4   ;
    wire[ 1: 0]         htrans_m4  ;
    wire[31: 0]         hwdata_m4  ;
    wire                hwrite_m4  ;
    wire                hgrant_m4  ;
    
    wire                hsel_s0         ;
    wire                hready_resp_s0  ;
    wire[ 1: 0]         hresp_s0        ;
    wire[31: 0]         hrdata_s0       ;  
    
    wire                hsel_s1         ;
    wire                hready_resp_s1  ;
    wire[ 1: 0]         hresp_s1        ;
    wire[31: 0]         hrdata_s1       ;  

    wire                hsel_s2         ;
    wire                hready_resp_s2  ;
    wire[ 1: 0]         hresp_s2        ;
    wire[31: 0]         hrdata_s2       ;  
    
    wire                hsel_s3         ;
    wire                hready_resp_s3  ;
    wire[ 1: 0]         hresp_s3        ;
    wire[31: 0]         hrdata_s3       ;
    
    wire                hsel_s4         ;
    wire                hready_resp_s4  ;
    wire[ 1: 0]         hresp_s4        ;
    wire[31: 0]         hrdata_s4       ;

    
    wire[31: 0]         haddr           ;
    wire[ 2: 0]         hburst          ;
    wire[ 3: 0]         hprot           ;
    wire[ 2: 0]         hsize           ;
    wire[ 1: 0]         htrans          ;
    wire[31: 0]         hwdata          ;
    wire                hwrite          ;
    
    wire                hready          ;
    wire[ 1: 0]         hresp           ; 
    wire[31: 0]         hrdata          ;
    
    wire[ 3: 0]         hmaster         ;
    wire[ 3: 0]         hmaster_data    ;
    wire                hmastlock       ;
    
	/*=======================================================*/
	/*======================= AHB BUS =======================*/
	/*=======================================================*/
    //Master1: ANN
    //Master2: eMMC
    //Master3: AXI2AHB
    //Master4: Camera

    //Slave1 : Camera
    //Slave2 : ANN
    //Slave3 : eMMC
    //Slave4 : AHBLite2AXI
DW_ahb DW_ahb (
  		.hclk				(hclk           ),
        .hresetn			(hresetn        ),

        .haddr_m1			(haddr_m1	    ),
        .hburst_m1			(hburst_m1	    ),
        .hbusreq_m1			(hbusreq_m1	    ),
        .hlock_m1			(hlock_m1	    ),
        .hprot_m1			(hprot_m1	    ),
        .hsize_m1			(hsize_m1	    ),
        .htrans_m1			(htrans_m1	    ),
        .hwdata_m1			(hwdata_m1	    ),
        .hwrite_m1			(hwrite_m1	    ),
        .hgrant_m1			(hgrant_m1	    ),
        	
        .haddr_m2			(haddr_m2	    ),
        .hburst_m2			(hburst_m2	    ),
        .hbusreq_m2			(hbusreq_m2	    ),
        .hlock_m2			(hlock_m2	    ),
        .hprot_m2			(hprot_m2	    ),
        .hsize_m2			(hsize_m2	    ),
        .htrans_m2			(htrans_m2	    ),
        .hwdata_m2			(hwdata_m2	    ),
        .hwrite_m2			(hwrite_m2	    ),
        .hgrant_m2			(hgrant_m2	    ),
               	
        .haddr_m3			(haddr_m3	    ),
        .hburst_m3			(hburst_m3	    ),
        .hbusreq_m3			(hbusreq_m3	    ),
        .hlock_m3			(hlock_m3	    ),
        .hprot_m3			(hprot_m3	    ),
        .hsize_m3			(hsize_m3	    ),
        .htrans_m3			(htrans_m3	    ),
        .hwdata_m3			(hwdata_m3	    ),
        .hwrite_m3			(hwrite_m3	    ),
        .hgrant_m3			(hgrant_m3	    ),
        	               	
        .haddr_m4			(haddr_m4		),
        .hburst_m4			(hburst_m4		),
        .hbusreq_m4			(hbusreq_m4		),
        .hlock_m4			(hlock_m4		),
        .hprot_m4			(hprot_m4		),
        .hsize_m4			(hsize_m4		),
        .htrans_m4			(htrans_m4		),
        .hwdata_m4			(hwdata_m4		),
        .hwrite_m4			(hwrite_m4		),
        .hgrant_m4			(hgrant_m4		),

		//how to connect? float?             	               	
        .hsel_s0			(hsel_s0		),	//output: When asserted, indicates that the arbiter slave has been selected.
        .hready_resp_s0		(hready_resp_s0	),	//output: Response from Arbiter Slave interface.
        .hresp_s0			(hresp_s0		),	//output: Transfer response from Arbiter Slave interface
        .hrdata_s0			(hrdata_s0		),	//output: Readback data from Arbiter Slave interface.

        .hsel_s1			(hsel_s1		),
        .hready_resp_s1		(hready_resp_s1	),
        .hresp_s1			(hresp_s1		),
        .hrdata_s1			(hrdata_s1		),
        	
        .hsel_s2			(hsel_s2		),
        .hready_resp_s2		(hready_resp_s2	),
        .hresp_s2			(hresp_s2		),
        .hrdata_s2			(hrdata_s2		),
        	
        .hsel_s3			(hsel_s3		),
        .hready_resp_s3		(hready_resp_s3	),
        .hresp_s3			(hresp_s3		),
        .hrdata_s3			(hrdata_s3		),

        .hsel_s4			(hsel_s4		),
        .hready_resp_s4		(hready_resp_s4	),
        .hresp_s4			(hresp_s4		),
        .hrdata_s4			(hrdata_s4		),

        .haddr				(haddr		    ),	//This is passed to all AHB slaves.
        .hburst				(hburst		    ),	//This is passed to all AHB slaves.
        .hprot				(hprot		    ),	//This is passed to all AHB slaves.
        .hsize				(hsize		    ),	//This is passed to all AHB slaves.
        .htrans				(htrans		    ),	//This is passed to all AHB slaves.
        .hwdata				(hwdata		    ),	//This is passed to all AHB slaves.
        .hwrite				(hwrite		    ),	//This is passed to all AHB slaves.
        .hready				(hready		    ),	//This signal is passed to all AHB masters and slaves.
        .hresp				(hresp		    ),	//This signal is passed to all AHB masters.
        .hrdata				(hrdata		    ),	//This signal is passed to all AHB masters.
        
        //how to connect? float?	
        .hmastlock			(hmastlock		),	//Output: Asserted to indicate that the transfer currently in progress is part of a locked transaction.
        .hmaster			(hmaster		),	//Output: Indicates which master currently has ownership of the address and control bus.
        .hmaster_data		(hmaster_data	),	//Output: Indicates which master currently has ownership of the data bus.
        
        .ahbarbint			(ahb_intr       )	//The arbiter will flag an interrupt when an Early Burst Termination occurs.
     );


	/*=======================================================*/
	/*======================= AXI2AHB =======================*/
	/*=======================================================*/
	
	//Master3
	DW_axi_x2h	 DW_axi_x2h (
	 	//clock & Reset
	 	.aclk				(hclk           ), 
        .aresetn			(hresetn        ),
	 	.mhclk				(hclk           ),
        .mhresetn			(hresetn        ),
	 	
	 	//=================AXI Slave==================//
	 	//Write Command Channel
	 	.awid				(awid	    ),
	 	.awaddr				(awaddr		    ), 
	 	.awlen				(awlen		    ), 
	 	.awsize				(awsize		    ),
	 	.awburst			(awburst	    ), 
        .awlock				(awlock		    ), 
	 	.awcache			(awcache	    ),	 
        .awprot				(awprot		    ),
        .awvalid			(awvalid	    ), 
        .awready			(awready	    ), 
            	
        //Write Data Channel
        //.wid				(wid[3:0]       ),	//Included only when X2H_INTERFACE_TYPE = AXI;  not used, included for interface consistency only
        .wdata				(wdata		    ),
        .wstrb				(wstrb		    ),
        .wlast				(wlast		    ),  	
        .wvalid				(wvalid		    ),
        .wready				(wready		    ),
                   	
        //Write Response Channel
        .bid				(bid	    ),
        .bresp				(bresp		    ),  
        .bvalid				(bvalid		    ), 
        .bready				(bready		    ),  
	 	
	 	//Read Command Channel
	 	.arid				(arid	    ),
	 	.araddr				(araddr		    ), 
        .arlen				(arlen		    ),
        .arsize				(arsize		    ), 
        .arburst			(arburst	    ), 
        .arlock				(arlock		    ), 
        .arcache			(arcache	    ),
        .arprot				(arprot		    ),
	 	.arvalid			(arvalid	    ),
	 	.arready			(arready	    ),
	 	
	 	//Read Response Channel
	 	.rid				(rid	    ), 
	 	.rdata				(rdata		    ), 
	 	.rresp				(rresp		    ),
	 	.rlast				(rlast		    ),
        .rvalid				(rvalid		    ),
        .rready				(rready		    ),
	 	
	 	//=================AHB Master==================//
        .mhaddr				(haddr_m3       ), 
        .mhburst			(hburst_m3      ),
        .mhlock				(hlock_m3       ), 
        .mhprot				(hprot_m3       ), 
        .mhsize				(hsize_m3       ), 
        .mhtrans			(htrans_m3      ), 
        .mhwdata			(hwdata_m3      ), 
        .mhwrite			(hwrite_m3      ),
        
        .mhbusreq			(hbusreq_m3     ),
        .mhgrant			(hgrant_m3      ),
        
        .mhready			(hready         ),
        .mhresp			    (hresp          ),
        .mhrdata			(hrdata         )
        );
	
	
	/*======================================================*/
	/*=====================   Camera   =====================*/
	/*======================================================*/
	
	//Master4; Slave1
	CAMERA_Bridge   CAMERA_Bridge(
	    /***** pin *****/
	    .pclk			(pclk	        ),
	    .vsync			(vsync	        ),
	    .href			(href	        ),
	    .data			(data	        ),
	    	
	    /**** AHB system ****/	
	    //global
	    .HCLK			(hclk_cam       ),
	    .HReset_N		(hresetn        ),
	    
	    //Master
	    .mHADDR			(haddr_m4       ),
	    .mHTRANS     	(htrans_m4      ),
	    .mHWRITE     	(hwrite_m4      ),
	    .mHSIZE      	(hsize_m4       ),
	    .mHBURST     	(hburst_m4      ),
	    .mHPORT      	(hprot_m4       ),
	    .mHWDATA     	(hwdata_m4      ),
	    .mHLOCK     	(hlock_m4       ),    
	    
	    .mHBUSRREQ  	(hbusreq_m4     ),
	    .mHGRANT    	(hgrant_m4      ),
	    
	    .mHREADY     	(hready         ),
	    .mHRESP      	(hresp          ),
	    .mHRDATA     	(hrdata         ),
	    	            
	    //Slave
	    .sHSEL			(hsel_s2        ),
	    .sHWrite        (hwrite         ),
	    .sHTRANS        (htrans         ),
	    .sHSIZE         (hsize          ),
	    .sHBURST        (hburst         ),
	    .sHADDR         (haddr          ),
	    .sHWDATA        (hwdata         ),
	    .sHREADY        (hready         ),
	    .sHREADY_RESP   (hready_resp_s2 ),	
	    .sHRESP         (hresp_s2       ),
	    .sHRDATA        (hrdata_s2      ),
        
	    /**** interrupt ****/
	    .Interrupt       (Camera_intr    )
        );
	
         
    /*======================================================*/
	/*====================      ANN     ====================*/
	/*======================================================*/
	   
	//Master1; Slave2
    ahb_ann ahb_ann(
        //global
        .hclk                   (hclk_ann       ),
        .hresetn                (hresetn        ),
                                
        //ahb-master            
        .ahbm_haddr             (haddr_m1       ),
        .ahbm_htrans            (htrans_m1      ),
        .ahbm_hwrite            (hwrite_m1      ),
        .ahbm_hsize             (hsize_m1       ),
        .ahbm_hburst            (hburst_m1      ),
        .ahbm_hwdata            (hwdata_m1      ),
        .ahbm_hprot             (hprot_m1       ),
        .ahbm_hlock             (hlock_m1       ),
                                                
        .ahbm_hbusreq           (hbusreq_m1     ),
        .ahbm_hgrant            (hgrant_m1      ),
                                                
        .ahbm_hready_in         (hready         ),
        .ahbm_hresp             (hresp          ),
        .ahbm_hrdata            (hrdata         ),
                                                
        //ahb-slave                             
        .ahbs_hsel              (hsel_s3        ),
        .ahbs_hready_in         (hready         ),
        .ahbs_haddr             (haddr          ),
        .ahbs_htrans             (htrans         ),
        .ahbs_hwrite            (hwrite         ),
        .ahbs_hsize             (hsize          ),
        .ahbs_hburst            (hburst         ),
        .ahbs_hwdata            (hwdata         ),
                                
        .ahbs_hready_out        (hready_resp_s3 ),
        .ahbs_hresp             (hresp_s3       ),
        .ahbs_hrdata            (hrdata_s3      ),
                                
        //interrupt
//        .err_int                (ann_err_int    ),             
        .interrupt              (ann_intr       )
        );    
	
	
	
	/*======================================================*/
	/*=====================eMMC & SDIO =====================*/
	/*======================================================*/

	//Master2;Slave3
	DWC_mobile_storage_top	DWC_mobile_storage_top(
  		// CLOCKS and RESET
  		.clk_2x                 (hclk_2x            ),  		
  		.clk				    (hclk               ),		//AHB Clock
        .reset_n			    (hresetn            ),
                                                    
        // AHB Slave                                
        .hsel				    (hsel_s4            ), 
       	.hready				    (hready             ),
       	.haddr				    (haddr              ),
        .hwrite				    (hwrite             ),
        .htrans				    (htrans             ),
        .hsize				    (hsize              ),
        .hburst				    (hburst             ),
        .hwdata				    (hwdata             ), 
                                                    
        .hready_resp		    (hready_resp_s4     ),
        .hresp				    (hresp_s4           ),
        .hrdata				    (hrdata_s4          ), 
                                                    
        // AHB Master                               
        .m_hreq				    (hbusreq_m2         ), 
        .m_hgrant			    (hgrant_m2          ),
        .m_haddr			    (haddr_m2           ),
        .m_htrans			    (htrans_m2          ),
        .m_hwrite			    (hwrite_m2          ),
        .m_hsize			    (hsize_m2           ),
        .m_hburst			    (hburst_m2          ), 
        .m_hwdata			    (hwdata_m2          ),
        .m_hready			    (hready             ), 
        .m_hresp			    (hresp              ),
        .m_hrdata			    (hrdata             ), 
                                                    
        // INTERRUPT SIGNALS                        
        .interrupt			    (emmc_intr          ), 
        
        // CARD-INTERFACE
        .cclk_out				(cclk_out			), 
                                                    
        .ccmd_in				(ccmd_in			), 
        .ccmd_out				(ccmd_out			),
        .ccmd_out_en			(ccmd_out_en		), 
                                                    
        .cdata_in				(cdata_in			), 
        .cdata_out				(cdata_out			),
        .cdata_out_en			(cdata_out_en		),
        
        .card_detect_n			(card_detect_n	    ),	//Card detect signals. A 0 represents presence of card.         
        .card_write_prt			(card_write_prt	    ), 	//Card write protect signals. A 1 represents write is protected.
        
        .card_power_en			(card_power_en		),	//output: Card power-enable control signal;
        .card_volt_a			(card_volt_a		),	//output: Card voltage regulator-A control.
        .card_volt_b			(card_volt_b		),	//output: Card voltage regulator-B control.
        .ccmd_od_pullup_en_n	(ccmd_od_pullup_en_n), 	//output: Card command open-drain pull-up enable; used in MMC mode.
        
        //SD_3.0 start
        //Voltage buffer inputs
        .biu_volt_reg			(biu_volt_reg       ),	//output Control signal to select between 3.3V and1.8 V used in voltage switching as defined by SD3.0.
        //SD_3.0 ends
        
        //SDIO3.0 start
        .card_int_n				(card_int_n         ),	//Card interrupt lines. These interrupt lines are connected to the eSDIO card interrupt lines; they are defined for only eSDIO.
        .back_end_power			(back_end_power     ),	//output: Back-end power supply for embedded device. One bit needed for each device to control back-end power supply for an embedded device;
        //SDIO3.0 ends
        
        //MMC4_4 start
        .rst_n					(mmc_4_4_rst_n      ),	//output Hardware reset (H/W Reset) for MMC4.41 mode.
        //MMC4_4 ends
        
        
        //eMMC 4.5 start
        //Voltage buffer inputs
        .biu_volt_reg_1_2		(biu_volt_reg_1_2	)	//output: Corresponds to MMC_VOLT_REG. And is used in combination with biu_volt_reg port to decode the required voltage.        
        //eMMC 4.5 ends
        );

    assign hlock_m2 = 1'b0;
	assign hprot_m2 = 4'h1;
	
	/*======================================================*/
	/*=================AHBLite2AXI Bridge ==================*/
	/*======================================================*/

	//Slave4
    h2x_bridge xlnx_ahblite2axi (

      //=================AHB slave==================//
      .s_ahb_hclk          (hclk           ),              // input wire s_ahb_hclk
      .s_ahb_hresetn       (hresetn        ),        // input wire s_ahb_hresetn
      .s_ahb_hsel          (hsel_s1        ),              // input wire s_ahb_hsel
      .s_ahb_haddr         (haddr          ),            // input wire [31 : 0] s_ahb_haddr
      .s_ahb_hprot         (hprot          ),            // input wire [3 : 0] s_ahb_hprot
      .s_ahb_htrans        (htrans         ),          // input wire [1 : 0] s_ahb_htrans
      .s_ahb_hsize         (hsize          ),            // input wire [2 : 0] s_ahb_hsize
      .s_ahb_hwrite        (hwrite         ),          // input wire s_ahb_hwrite
      .s_ahb_hburst        (hburst         ),          // input wire [2 : 0] s_ahb_hburst
      .s_ahb_hwdata        (hwdata         ),          // input wire [31 : 0] s_ahb_hwdata
      .s_ahb_hready_out    (hready_resp_s1 ),  // output wire s_ahb_hready_out
      .s_ahb_hready_in     (hready	       ),    // input wire s_ahb_hready_in
      .s_ahb_hrdata        (hrdata_s1      ),          // output wire [31 : 0] s_ahb_hrdata
      .s_ahb_hresp         (hresp_s1[0]       ),            // output wire s_ahb_hresp

      //=================AXI Master==================//
       //AXI: Write Command Channel
      .m_axi_awid          (m_awid         ),              // output wire [7 : 0] m_axi_awid
      .m_axi_awlen         (m_awlen        ),            // output wire [7 : 0] m_axi_awlen
      .m_axi_awsize        (m_awsize       ),          // output wire [2 : 0] m_axi_awsize
      .m_axi_awburst       (m_awburst      ),        // output wire [1 : 0] m_axi_awburst
      .m_axi_awcache       (m_awcache      ),        // output wire [3 : 0] m_axi_awcache
      .m_axi_awaddr        (m_awaddr       ),          // output wire [31 : 0] m_axi_awaddr
      .m_axi_awprot        (m_awprot       ),          // output wire [2 : 0] m_axi_awprot
      .m_axi_awvalid       (m_awvalid      ),        // output wire m_axi_awvalid
      .m_axi_awready       (m_awready      ),        // input wire m_axi_awready
      .m_axi_awlock        (m_awlock       ),          // output wire m_axi_awlock
      //AXI: Write Data Channel
      .m_axi_wdata         (m_wdata        ),            // output wire [31 : 0] m_axi_wdata
      .m_axi_wstrb         (m_wstrb        ),            // output wire [3 : 0] m_axi_wstrb
      .m_axi_wlast         (m_wlast        ),            // output wire m_axi_wlast
      .m_axi_wvalid        (m_wvalid       ),          // output wire m_axi_wvalid
      .m_axi_wready        (m_wready       ),          // input wire m_axi_wready
      //AXI: Write Response Channel
      .m_axi_bid           (m_bid          ),                // input wire [7 : 0] m_axi_bid
      .m_axi_bresp         (m_bresp        ),            // input wire [1 : 0] m_axi_bresp
      .m_axi_bvalid        (m_bvalid       ),          // input wire m_axi_bvalid
      .m_axi_bready        (m_bready       ),          // output wire m_axi_bready
      //AXI: Read Command Channel
      .m_axi_arid          (m_arid         ),              // output wire [7 : 0] m_axi_arid
      .m_axi_arlen         (m_arlen        ),            // output wire [7 : 0] m_axi_arlen
      .m_axi_arsize        (m_arsize       ),          // output wire [2 : 0] m_axi_arsize
      .m_axi_arburst       (m_arburst      ),        // output wire [1 : 0] m_axi_arburst
      .m_axi_arprot        (m_arprot       ),          // output wire [2 : 0] m_axi_arprot
      .m_axi_arcache       (m_arcache      ),        // output wire [3 : 0] m_axi_arcache
      .m_axi_arvalid       (m_arvalid      ),        // output wire m_axi_arvalid
      .m_axi_araddr        (m_araddr       ),          // output wire [31 : 0] m_axi_araddr
      .m_axi_arlock        (m_arlock       ),          // output wire m_axi_arlock
      .m_axi_arready       (m_arready      ),        // input wire m_axi_arready
      //AXI: Read Response Channel
      .m_axi_rid           (m_rid          ),                // input wire [7 : 0] m_axi_rid
      .m_axi_rdata         (m_rdata        ),            // input wire [31 : 0] m_axi_rdata
      .m_axi_rresp         (m_rresp        ),            // input wire [1 : 0] m_axi_rresp
      .m_axi_rvalid        (m_rvalid       ),          // input wire m_axi_rvalid
      .m_axi_rlast         (m_rlast        ),            // input wire m_axi_rlast
      .m_axi_rready        (m_rready       )          // output wire m_axi_rready
    );

endmodule
 
