`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_top(
    // CLOCKS and RESET     
    clk_2x                  ,
    clk				        ,
    reset_n			        ,
                            
    // AHB Slave            
    hsel				    ,
    hready				    ,
    haddr				    ,
    hwrite				    ,
    htrans				    ,
    hsize				    ,
    hburst				    ,
    hwdata				    ,
                           
    hready_resp		        ,
    hresp				    ,
    hrdata				    ,
                            
    // AHB Master           
    m_hreq				    ,
    m_hgrant			    ,
    m_haddr			        ,
    m_htrans			    ,
    m_hwrite			    ,
    m_hsize			        ,
    m_hburst			    ,
    m_hwdata			    ,
    m_hready			    ,
    m_hresp			        ,
    m_hrdata			    ,
                            
    // INTERRUPT SIGNALS    
    interrupt			    ,
                            
    // CARD-INTERFACE       
    cclk_out				,
                           
    ccmd_in				    ,
    ccmd_out				,
    ccmd_out_en			    ,
                           
    cdata_in				,
    cdata_out				,
    cdata_out_en			,
                           
    card_detect_n			,
    card_write_prt			,
                           
    card_power_en			,
    card_volt_a			    ,
    card_volt_b			    ,
    ccmd_od_pullup_en_n	    ,
                            
    //SD_3.0 start          
    //Voltage buffer inputs 
    biu_volt_reg			,
    //SD_3.0 ends           
                            
    //SDIO3.0 start         
    card_int_n				,
    back_end_power			,
    //SDIO3.0 ends          
                            
    //MMC4_4 start          
    rst_n					,
    //MMC4_4 ends           
                                                        
    //eMMC 4.5 start        
    //Voltage buffer inputs 
    biu_volt_reg_1_2		
    //eMMC 4.5 ends         
);  

    // CLOCKS and RESET     
    input           clk_2x                  ;
    input           clk				        ;
    input           reset_n			        ;
                            
    // AHB Slave            
    input           hsel				    ;
    input           hready				    ;
    input [31: 0]   haddr				    ;
    input           hwrite				    ;
    input [ 1: 0]   htrans				    ;
    input [ 2: 0]   hsize				    ;
    input [ 2: 0]   hburst				    ;
    input [31: 0]   hwdata				    ;
                           
    output          hready_resp		        ;
    output[ 1: 0]   hresp				    ;
    output[31: 0]   hrdata				    ;
                            
    // AHB Master           
    output          m_hreq				    ;
    input           m_hgrant			    ;
    output[31: 0]   m_haddr			        ;
    output[ 1: 0]   m_htrans			    ;
    output          m_hwrite			    ;
    output[ 2: 0]   m_hsize			        ;
    output[ 2: 0]   m_hburst			    ;
    output[31: 0]   m_hwdata			    ;
    input           m_hready			    ;
    input [ 1: 0]   m_hresp			        ;
    input [31: 0]   m_hrdata			    ;
                            
    // INTERRUPT SIGNALS    
    output          interrupt			    ;
                            
    // CARD-INTERFACE       
    output[ 1: 0]   cclk_out				;
                           
    input [ 1: 0]   ccmd_in				    ;
    output[ 1: 0]   ccmd_out				;
    output[ 1: 0]   ccmd_out_en			    ;
                           
    input [15: 0]   cdata_in				;
    output[15: 0]   cdata_out				;
    output[15: 0]   cdata_out_en			;
                           
    input [ 1: 0]   card_detect_n			;
    input [ 1: 0]   card_write_prt			;
                           
    output[ 1: 0]   card_power_en			;
    output[ 3: 0]   card_volt_a			    ;
    output[ 3: 0]   card_volt_b			    ;
    output          ccmd_od_pullup_en_n	    ;
                            
    //SD_3.0 start          
    //Voltage buffer inputs 
    output[ 1: 0]   biu_volt_reg			;
    //SD_3.0 ends           
                            
    //SDIO3.0 start         
    input [ 1: 0]   card_int_n				;
    output[ 1: 0]   back_end_power			;
    //SDIO3.0 ends          
                            
    //MMC4_4 start          
    output[ 1: 0]   rst_n					;
    //MMC4_4 ends           
                                                        
    //eMMC 4.5 start        
    //Voltage buffer inputs 
    output[ 1: 0]   biu_volt_reg_1_2		;
    //eMMC 4.5 ends         

    /************************************************/
    wire        c_clk_ready         ;   //gp_in[0]
    wire        cclk_in             ;
    wire        cclk_in_sample      ;
    wire        cclk_in_drv         ;
    
    wire[ 1: 0] ext_clk_mux_ctrl    ;
    wire[ 6: 0] clk_drv_phase_ctrl  ;
    wire[ 6: 0] clk_smpl_phase_ctrl ;
    
    wire[15: 0] gp_out              ;
    
    DWC_mobile_storage_clk_ctrl DWC_mobile_storage_clk_ctrl(    
        //clock ready
        .o_clk_ready            (c_clk_ready        ),
        
        //clock output
        .o_cclk_in              (cclk_in            ),
//	    .o_cclk_in_drv          (cclk_in_sample     ),
//	    .o_cclk_in_sample       (cclk_in_drv        ),
	    .o_cclk_in_drv          (cclk_in_drv        ), //20161219 modify
	    .o_cclk_in_sample       (cclk_in_sample     ), //20161219 modify
	    
	    //ctrl
	    .ext_clk_mux_ctrl       (ext_clk_mux_ctrl   ),   //from DWC_mobile_storage_core, IOR:UHS_REG_EXT
	    .clk_drv_phase_ctrl     (clk_drv_phase_ctrl ),   //from DWC_mobile_storage_core, IOR:UHS_REG_EXT
	    .clk_smpl_phase_ctrl    (clk_smpl_phase_ctrl),   //from DWC_mobile_storage_core, IOR:UHS_REG_EXT	
	    .i_clk_enable           (gp_out[0]          ),   //from DWC_mobile_storage_core, IOR:GPIO[CLK_ENABLE]
	    	
	    //global
	    .ext_clk                (clk_2x             ),   //high frequency clk, hclk_2x
        .rst_n                  (reset_n            )
        );
    
    DWC_mobile_storage	DWC_mobile_storage(
  		// CLOCKS and RESET  		
  		.clk				    (clk                ),		//AHB Clock
        .reset_n			    (reset_n            ),
        .cclk_in                (cclk_in            ),
        .cclk_in_sample         (cclk_in_sample     ),
        .cclk_in_drv            (cclk_in_drv        ),
                                                    
        // AHB Slave                                
        .hsel				    (hsel               ), 
       	.hready				    (hready             ),
       	.haddr				    ({8'h0,haddr[11:0]} ),  //20161025
        .hwrite				    (hwrite             ),
        .htrans				    (htrans             ),
        .hsize				    (hsize              ),
        .hburst				    (hburst             ),
        .hwdata				    (hwdata             ), 
                                                    
        .hready_resp		    (hready_resp        ),
        .hresp				    (hresp              ),
        .hrdata				    (hrdata             ),
        
        .hbig_endian            (1'b0               ),  //fixed 0  
                                                    
        // AHB Master                               
        .m_hreq				    (m_hreq             ), 
        .m_hgrant			    (m_hgrant           ),
        .m_haddr			    (m_haddr            ),
        .m_htrans			    (m_htrans           ),
        .m_hwrite			    (m_hwrite           ),
        .m_hsize			    (m_hsize            ),
        .m_hburst			    (m_hburst           ), 
        .m_hwdata			    (m_hwdata           ),
        .m_hready			    (m_hready           ), 
        .m_hresp			    (m_hresp            ),
        .m_hrdata			    (m_hrdata           ),
        
        .m_hbig_endian          (1'b0               ),  //fixed 0 
                                                    
        // INTERRUPT SIGNALS                        
        .interrupt			    (interrupt          ), 
        .raw_ints               (                   ),  //float  
        .int_mask_n             (                   ),  //float
        .int_enable             (                   ),  //float
        
        
        // GENERAL PURPOSE INPUT/OUTPUT
        .gp_out                 (gp_out             ), 
        .gp_in                  ({7'h0,c_clk_ready} ),
        
        // DEBUG & SCAN
        .debug_status           (                   ),  //float 
        .scan_mode              (1'b0               ),  //fixed 0
        
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
        .rst_n					(rst_n              ),	//output Hardware reset (H/W Reset) for MMC4.41 mode.
        //MMC4_4 ends
                
        //eMMC 4.5 start
        //Voltage buffer inputs
        .biu_volt_reg_1_2		(biu_volt_reg_1_2	),	//output: Corresponds to MMC_VOLT_REG. And is used in combination with biu_volt_reg port to decode the required voltage.        
        .ext_clk_mux_ctrl       (ext_clk_mux_ctrl   ),   
        .clk_drv_phase_ctrl     (clk_drv_phase_ctrl ), 
        .clk_smpl_phase_ctrl    (clk_smpl_phase_ctrl)        
        //eMMC 4.5 ends
        );
xilinx_ila_debug your_instance_name (
        .clk(clk), // input wire clk


        .probe0(cclk_in), // input wire [0:0]  probe0
        .probe1(cdata_in), // input wire [3:0]  probe1
        .probe2(cclk_in_sample) // input wire [0:0]  probe2
);


endmodule

