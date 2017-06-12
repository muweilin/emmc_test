
`include "config.sv"

module AHB_SUBSYSTEM(

`ifdef HAPS
//    OBS_PIN ,
    hclk_4x , 
`endif

	/*****************  pin  ***************/
	//camera
	pclk	            ,
	vsync	            ,
	href	            ,
	data	            ,
	
	//memctl
	s_scl	            ,		    
	s_sa                ,
	//s_sda		        ,   //双向，注：可以把双向控制器逻辑（目前在DW_memctl_top中）放到IOBuffer。
	s_sda_out           ,   
	s_sda_oe_n          ,
	s_sda_in            ,
	
	s_ck_p              ,   //s_ck_p,s_ck_n是差分时钟，来自hclk。注：这两个端口可以不作为AHB_SUBSYSTEM的端口
	s_ck_n              ,
	s_sel_n		        ,
	s_cke			    ,
	s_ras_n		        ,
	s_cas_n		        ,
	s_we_n			    ,
	s_addr			    ,
	s_bank_addr	        ,
	s_dqm			    ,
	//s_dqs			    ,   //双向，注：可以把双向控制器逻辑（目前在DW_memctl_top中）放到IOBuffer。
	//s_dq                ,   //双向，注：可以把双向控制器逻辑（目前在DW_memctl_top中）放到IOBuffer。
	s_dout_oe           ,
	s_dqs_wr            ,
	s_dqs_rd            ,
	s_dq_wr             ,
	s_dq_rd             ,
	                
	s_rd_dqs_mask       ,   //s_rd_dqs_mask和int_rd_dqs_mask用于延时匹配，与Mem读数据采样逻辑实现方式相关
	int_rd_dqs_mask     ,
	
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
	
	//interrupt
	ahb_intr            ,
	Camera_intr         ,
	ann_intr            ,
//	ann_err_int         ,
	emmc_intr
);

`ifdef HAPS
//    output[47: 0]   OBS_PIN ;
    input           hclk_4x ;
`endif
   
	/*****************  pin  ***************/
	//camera
	input           pclk	            ;
	input           vsync	            ;
	input           href	            ;
	input [ 7: 0]   data	            ;
	
	//memctl
	output          s_scl	            ;		    
	output[ 2: 0]   s_sa                ;
	//inout           s_sda		        ;   //双向，注：可以把双向控制器逻辑（目前在DW_memctl_top中）放到IOBuffer。
	output          s_sda_out           ;
	output          s_sda_oe_n          ;
	input           s_sda_in            ;
	
	output          s_ck_p              ;   //s_ck_p,s_ck_n是差分时钟，来自hclk。注：这两个端口可以不作为AHB_SUBSYSTEM的端口
	output          s_ck_n              ;
	output          s_sel_n		        ;
	output          s_cke			    ;
	output          s_ras_n		        ;
	output          s_cas_n		        ;
	output          s_we_n			    ;
	output[15: 0]   s_addr			    ;
	output[ 1: 0]   s_bank_addr	        ;
	output[ 1: 0]   s_dqm			    ;
	//inout [ 1: 0]   s_dqs			    ;   //双向，注：可以把双向控制器逻辑（目前在DW_memctl_top中）放到IOBuffer。
	//inout [15: 0]   s_dq                ;   //双向，注：可以把双向控制器逻辑（目前在DW_memctl_top中）放到IOBuffer。
	output[ 1: 0]   s_dout_oe           ;
	output[ 1: 0]   s_dqs_wr            ;
	input [ 1: 0]   s_dqs_rd            ;
	output[15: 0]   s_dq_wr             ;
	input [15: 0]   s_dq_rd             ;
	              
	output          s_rd_dqs_mask       ;   //s_rd_dqs_mask和int_rd_dqs_mask用于延时匹配，与Mem读数据采样逻辑实现方式相关
	input           int_rd_dqs_mask     ;
	
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
    
    wire                hsel_s3         ;
    wire                hready_resp_s3  ;
    wire[ 1: 0]         hresp_s3        ;
    wire[31: 0]         hrdata_s3       ;
    
    wire                hsel_s4         ;
    wire                hready_resp_s4  ;
    wire[ 1: 0]         hresp_s4        ;
    wire[31: 0]         hrdata_s4       ;
    
    wire                hsel_s5         ;
    wire                hready_resp_s5  ;
    wire[ 1: 0]         hresp_s5        ;
    wire[31: 0]         hrdata_s5       ;
    
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
    
    //Slave1 : Memctrl Memory
    //Slave2 : Memctrl Register
    //Slave3 : Camera
    //Slave4 : ANN
    //Slave5 : eMMC
	DW_ahb  DW_ahb(
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
        	
        //Note: Slave2 Alias with Slave1               	
        .hsel_s2			(hsel_s2        ),
        
        .hsel_s3			(hsel_s3		),
        .hready_resp_s3		(hready_resp_s3	),
        .hresp_s3			(hresp_s3		),
        .hrdata_s3			(hrdata_s3		),
        	
        .hsel_s4			(hsel_s4		),
        .hready_resp_s4		(hready_resp_s4	),
        .hresp_s4			(hresp_s4		),
        .hrdata_s4			(hrdata_s4		),
        	
        .hsel_s5			(hsel_s5		),
        .hready_resp_s5		(hready_resp_s5	),
        .hresp_s5			(hresp_s5		),
        .hrdata_s5			(hrdata_s5		),
        
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
	 	.awid				(awid[3:0]	    ),
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
        .bid				(bid[3:0]	    ),
        .bresp				(bresp		    ),  
        .bvalid				(bvalid		    ), 
        .bready				(bready		    ),  
	 	
	 	//Read Command Channel
	 	.arid				(arid[3:0]	    ),
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
	 	.rid				(rid[3:0]	    ), 
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
	
	//Master4;Slave3
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
	    .sHSEL			(hsel_s3        ),
	    .sHWrite        (hwrite         ),
	    .sHTRANS        (htrans         ),
	    .sHSIZE         (hsize          ),
	    .sHBURST        (hburst         ),
	    .sHADDR         (haddr          ),
	    .sHWDATA        (hwdata         ),
	    .sHREADY        (hready         ),
	    .sHREADY_RESP   (hready_resp_s3 ),	
	    .sHRESP         (hresp_s3       ),
	    .sHRDATA        (hrdata_s3      ),
        
	    /**** interrupt ****/
	    .Interrupt       (Camera_intr    )
        );
	
	
	/*======================================================*/
	/*==================== SDRAM MemCtl ====================*/
	/*======================================================*/
	
	//memory Slave1; Register Slave2

	DW_memctl_top	DW_memctl_top(

`ifdef HAPS
//        .OBS_PIN                (OBS_PIN        ),
        .hclk_4x                (hclk_4x        ),
`endif

		//AHB interface
		.hclk					(hclk           ), 
       	.hclk_2x				(hclk_2x        ),  //ueed for DDR only
        .hresetn				(hresetn        ), 	
		                		
		.hsel_mem				(hsel_s1        ), 
        .hsel_reg				(hsel_s2        ),         
        .hwrite					(hwrite         ), 
        .htrans					(htrans         ),
        .hsize					(hsize          ), 
        .hburst					(hburst         ),
        .hwdata					(hwdata         ),
        .haddr					(haddr          ),          
        .hready					(hready         ),
        .hready_resp			(hready_resp_s1 ), 
        .hresp					(hresp_s1       ), 
        .hrdata					(hrdata_s1      ), 
        
        //SPD pin
        .s_scl					(s_scl			),
        .s_sa					(s_sa			),
        //.s_sda                  (s_sda          ),
        .s_sda_out              (s_sda_out      ),
        .s_sda_oe_n             (s_sda_oe_n     ),
        .s_sda_in               (s_sda_in       ),
        
		//SDRAM pin
		.s_sel_n				(s_sel_n		), 
		.s_cke					(s_cke			), 
		.s_ras_n				(s_ras_n		), 
        .s_cas_n				(s_cas_n		),
        .s_we_n					(s_we_n			),
        .s_addr					(s_addr			),
        .s_bank_addr			(s_bank_addr	),
        .s_dqm					(s_dqm			), 
        //.s_dqs					(s_dqs			),
        //.s_dq                   (s_dq           ),
        .s_dout_valid           (s_dout_oe      ),
        .s_dqs_wr               (s_dqs_wr       ),
        .s_dqs_rd               (s_dqs_rd       ),
        .s_data_wr              (s_dq_wr        ),
        .s_data_rd              (s_dq_rd        ),
        
        .s_rd_dqs_mask			(s_rd_dqs_mask  ), 
        .int_s_rd_dqs_mask      (int_rd_dqs_mask)
        ); 
    
    assign  s_ck_p = hclk ;
    assign  s_ck_n =~hclk ;
            
    /*======================================================*/
	/*====================      ANN     ====================*/
	/*======================================================*/
	   
	//Master1; Slave4
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
        .ahbs_hsel              (hsel_s4        ),
        .ahbs_hready_in         (hready         ),
        .ahbs_haddr             (haddr          ),
        .ahbs_htrans             (htrans         ),
        .ahbs_hwrite            (hwrite         ),
        .ahbs_hsize             (hsize          ),
        .ahbs_hburst            (hburst         ),
        .ahbs_hwdata            (hwdata         ),
                                
        .ahbs_hready_out        (hready_resp_s4 ),
        .ahbs_hresp             (hresp_s4       ),
        .ahbs_hrdata            (hrdata_s4      ),
                                
        //interrupt
//        .err_int                (ann_err_int    ),             
        .interrupt              (ann_intr       )
        );    
	
	
	
	/*======================================================*/
	/*=====================eMMC & SDIO =====================*/
	/*======================================================*/

	//Master2;Slave5
	DWC_mobile_storage_top	DWC_mobile_storage_top(
  		// CLOCKS and RESET
  		.clk_2x                 (hclk_2x            ),  		
  		.clk				    (hclk               ),		//AHB Clock
        .reset_n			    (hresetn            ),
                                                    
        // AHB Slave                                
        .hsel				    (hsel_s5            ), 
       	.hready				    (hready             ),
       	.haddr				    (haddr              ),
        .hwrite				    (hwrite             ),
        .htrans				    (htrans             ),
        .hsize				    (hsize              ),
        .hburst				    (hburst             ),
        .hwdata				    (hwdata             ), 
                                                    
        .hready_resp		    (hready_resp_s5     ),
        .hresp				    (hresp_s5           ),
        .hrdata				    (hrdata_s5          ), 
                                                    
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
	
endmodule
