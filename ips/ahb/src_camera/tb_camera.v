
module TB_CAMERA;

    parameter  HCLK_T = 2.5 ;
    parameter  pclk_T = 50  ;
    
    initial 
    begin
        $shm_open("tb.shm");
        $shm_probe("AS");
    end
    
    reg     HCLK        ;
    reg     HReset_N    ;
    
    initial
    begin
        HCLK = 1'b0;
        forever #HCLK_T HCLK = ~HCLK;
    end
    
    initial
    begin
       HReset_N = 1'b0;
       
       #500
       HReset_N = 1'b1; 
    end
    
    reg     pclk        ;
    
    initial
    begin
        pclk = 1'b0;
        forever #pclk_T pclk = ~pclk;
    end
    
    /*********************************/
    wire  [31: 0]	mHADDR			;
	wire  [ 1: 0]	mHTRANS     	;
	wire  			mHWRITE     	;
	wire  [ 2: 0]	mHSIZE      	;
	wire  [ 2: 0]	mHBURST     	;
	wire  [ 3: 0]	mHPORT      	;
	wire  [31: 0]	mHWDATA     	;
	wire  			mHREADY     	;
	wire   [ 1: 0]	mHRESP      	;
	reg   [31: 0]	mHRDATA     	;
	wire			mHBUSRREQ  		;
	wire			mHLOCK     		;
	reg  			mHGRANT    		;
    
    assign  mHREADY = 1'b1;
    assign  mHRESP  = 2'h0;
    
    reg  			sHSEL			;
    reg  			sHWrite         ;
    reg   [ 1: 0]	sHTRANS         ;
    reg   [ 2: 0]	sHSIZE          ;
    reg   [ 2: 0]	sHBURST         ;
    reg   [31: 0]	sHADDR          ;
    reg   [31: 0]	sHWDATA         ;
    reg  			sHREADY         ;
    wire 			sHREADY_RESP    ;
    wire [ 1: 0]	sHRESP          ;
    wire [31: 0]	sHRDATA         ;
    
    initial
    begin
        sHSEL   = 1'b0;
        sHREADY = 1'b1;
                       
        sHWrite = 1'b1;
        sHTRANS = 2'h0;
        sHSIZE  = 3'h2;
        sHBURST = 3'h0;
        
        #HCLK_T
        #HCLK_T
        
        #1000
        
        CfgIOW(12'h00,32'hffff);
        CfgIOW(12'h04,32'hff00);
        CfgIOW(12'h08,32'h00ff);
        CfgIOW(12'h0c,32'h00ff);
        CfgIOW(12'h10,32'h000c);
        CfgIOW(12'h14,32'h000c);
        CfgIOW(12'h18,32'h003f);
        CfgIOW(12'h1c,32'h0006);
        
        
        CfgIOR(12'h00);
        CfgIOR(12'h04);
        CfgIOR(12'h08);
        CfgIOR(12'h0c);
        CfgIOR(12'h10);
        CfgIOR(12'h14);
        CfgIOR(12'h18);
        CfgIOR(12'h1c);
        
        CfgIOR_INCR4(12'h00);
        CfgIOW_INCR4(12'h00,32'hf);
        
        
        repeat(100000)@(negedge pclk);  
        CfgIOW(12'h00,32'h20000000);
        CfgIOW(12'h04,32'h40000000);
        CfgIOW(12'h08,32'h60000000);
        CfgIOW(12'h10,32'h0005);
        CfgIOW(12'h18,32'h003f);
        CfgIOW(12'h1c,32'h0001);
        
        repeat(100000)@(negedge pclk);  
        $finish;
    end
    
    initial
    begin
        mHGRANT = 1'b1;
     
        #10164750
        mHGRANT = 1'b0;
        
        repeat(10)@(negedge HCLK);  
        mHGRANT = 1'b1;
        
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        mHGRANT = 1'b0;
        
        repeat(10)@(negedge HCLK);  
        mHGRANT = 1'b1;
        
        @(negedge HCLK);
        @(negedge HCLK);
        mHGRANT = 1'b0;
        
        repeat(10)@(negedge HCLK);  
        mHGRANT = 1'b1;
        
        @(negedge HCLK);
        mHGRANT = 1'b0;
        
        repeat(10)@(negedge HCLK);  
        mHGRANT = 1'b1;
        
        @(negedge HCLK);
        mHGRANT = 1'b0;
        
        repeat(10)@(negedge HCLK);  
        mHGRANT = 1'b1;

    end
    
    reg         vsync   ;
    reg         href    ;
    reg[ 7: 0]  data    ;
    
    initial
    begin
        vsync   = 1'b0;
        href    = 1'b0;
        
        //wait(CAMERA_Bridge.CAMERA_CSR.r_GCR[0]==1);
        
        repeat(10)@(negedge pclk);
        
        while(1)@(negedge pclk)
        begin
            //Frame1
            vsync   = 1'b1;
            repeat(100)@(negedge pclk);
            vsync   = 1'b0;
            repeat(100)@(negedge pclk);
            
            href    = 1'b1;
            repeat(64*2)@(negedge pclk);
            href    = 1'b0;
            repeat(10)@(negedge pclk);
            
            href    = 1'b1;
            repeat(64*2)@(negedge pclk);
            href    = 1'b0;
            repeat(10)@(negedge pclk);
            
            href    = 1'b1;
            repeat(64*2)@(negedge pclk);
            href    = 1'b0;
            repeat(10)@(negedge pclk);
            
            href    = 1'b1;
            repeat(64*2)@(negedge pclk);
            href    = 1'b0;
            repeat(10)@(negedge pclk);
            
            href    = 1'b1;
            repeat(64*2)@(negedge pclk);
            href    = 1'b0;
            repeat(10)@(negedge pclk);
            
            href    = 1'b1;
            repeat(64*2)@(negedge pclk);
            href    = 1'b0;
            repeat(10)@(negedge pclk);
            
            href    = 1'b1;
            repeat(64*2)@(negedge pclk);
            href    = 1'b0;
            repeat(10)@(negedge pclk);
            
            href    = 1'b1;
            repeat(64*2)@(negedge pclk);
            href    = 1'b0;
            repeat(10)@(negedge pclk);
            
            repeat(1000)@(negedge pclk);
        end
    end
    
    always@(posedge pclk)
        begin
            if(vsync)
                data <= 8'h0;
            else if(href)
                data <= 8'h1 + data;
        end
    
    
    
    task CfgIOR;
        input [11: 0]   Addr        ;
    
    begin    
        @(negedge HCLK); 
        begin
        sHSEL   = 1'b1;
        sHREADY = 1'b1;
        
        sHWrite = 1'b0;
        sHTRANS = 2'h2;
        sHSIZE  = 3'h2;
        sHBURST = 3'h0;
        sHADDR  = {20'h0,Addr};
        end
        @(negedge HCLK);
        begin
        sHSEL   = 1'b0;
        sHREADY = 1'b1;
        
        sHWrite = 1'b0;
        sHTRANS = 2'h2;
        sHSIZE  = 3'h2;
        sHBURST = 3'h0;
        sHADDR  = {20'hff,Addr};
        end
        
    end
    endtask
    
    task CfgIOR_INCR4;
        input [11: 0]   Addr        ;
    
    begin    
        @(negedge HCLK); 
        begin
        sHSEL   = 1'b1;
        sHREADY = 1'b1;
        
        sHWrite = 1'b0;
        sHTRANS = 2'h2;
        sHSIZE  = 3'h2;
        sHBURST = 3'h3;
        sHADDR  = {20'h0,Addr};
        end
        @(negedge HCLK);
        begin
        sHSEL   = 1'b1;
        sHREADY = 1'b1;
        
        sHWrite = 1'b0;
        sHTRANS = 2'h3;
        sHSIZE  = 3'h2;
        sHBURST = 3'h3;
        sHADDR  = {20'hff,Addr+4};
        end
        @(negedge HCLK);
        begin
        sHSEL   = 1'b1;
        sHREADY = 1'b1;
        
        sHWrite = 1'b0;
        sHTRANS = 2'h3;
        sHSIZE  = 3'h2;
        sHBURST = 3'h3;
        sHADDR  = {20'hff,Addr+8};
        end
        @(negedge HCLK);
        begin
        sHSEL   = 1'b1;
        sHREADY = 1'b1;
        
        sHWrite = 1'b0;
        sHTRANS = 2'h3;
        sHSIZE  = 3'h2;
        sHBURST = 3'h3;
        sHADDR  = {20'hff,Addr+12};
        end
        @(negedge HCLK);
        begin
        sHSEL   = 1'b0;
        sHREADY = 1'b1;
        
        sHWrite = 1'b0;
        sHTRANS = 2'h0;
        sHSIZE  = 3'h2;
        sHBURST = 3'h0;
        sHADDR  = {20'hff,Addr+4};
        end
    end
    endtask
    
    task CfgIOW;
        input [11: 0]   Addr        ;
        input [31: 0]   WriteData   ;
    
    begin    
        @(negedge HCLK); 
        begin
        sHSEL   = 1'b1;
        sHREADY = 1'b1;
        
        sHWrite = 1'b1;
        sHTRANS = 2'h2;
        sHSIZE  = 3'h2;
        sHBURST = 3'h0;
        sHADDR  = {20'h0,Addr};
        end
        @(negedge HCLK);
        begin
        sHSEL   = 1'b0;
        sHREADY = 1'b1;
        
        sHWrite = 1'b1;
        sHTRANS = 2'h2;
        sHSIZE  = 3'h2;
        sHBURST = 3'h0;
        sHADDR  = {20'hff,Addr};
        
        sHWDATA = WriteData ;
        end
        
    end
    endtask
    
    task CfgIOW_INCR4;
        input [11: 0]   Addr        ;
        input [31: 0]   WriteData   ;
    
    begin    
        @(negedge HCLK); 
        begin
        sHSEL   = 1'b1;
        sHREADY = 1'b1;
        
        sHWrite = 1'b1;
        sHTRANS = 2'h2;
        sHSIZE  = 3'h2;
        sHBURST = 3'h3;
        sHADDR  = {20'h0,Addr};
        end
        @(negedge HCLK);
        begin
        sHSEL   = 1'b1;
        sHREADY = 1'b1;
        
        sHWrite = 1'b1;
        sHTRANS = 2'h3;
        sHSIZE  = 3'h2;
        sHBURST = 3'h3;
        sHADDR  = {20'hff,Addr+4};
        
        sHWDATA = WriteData ;
        end
        @(negedge HCLK);
        begin
        sHSEL   = 1'b1;
        sHREADY = 1'b1;
        
        sHWrite = 1'b1;
        sHTRANS = 2'h3;
        sHSIZE  = 3'h2;
        sHBURST = 3'h3;
        sHADDR  = {20'hff,Addr+8};
        
        sHWDATA = {WriteData[27:0],4'h0} ;
        end
        @(negedge HCLK);
        begin
        sHSEL   = 1'b1;
        sHREADY = 1'b1;
        
        sHWrite = 1'b1;
        sHTRANS = 2'h3;
        sHSIZE  = 3'h2;
        sHBURST = 3'h3;
        sHADDR  = {20'hff,Addr+12};
        
        sHWDATA = {WriteData[23:0],8'h0} ;
        end
        @(negedge HCLK);
        begin
        sHSEL   = 1'b0;
        sHREADY = 1'b1;
        
        sHWrite = 1'b1;
        sHTRANS = 2'h2;
        sHSIZE  = 3'h2;
        sHBURST = 3'h3;
        sHADDR  = {20'hff,Addr};
        
        sHWDATA = {WriteData[19:0],12'h0} ;
        end
    end
    endtask
    
    
    
    CAMERA_Bridge   CAMERA_Bridge(
	    /***** pin *****/
	    .pclk			    (pclk       ),
	    .vsync			    (vsync      ),
	    .href			    (href       ),
	    .data			    (data       ),
	    	
	    /**** AHB system ****/	
	    //global
	    .HCLK			    (HCLK       ),
	    .HReset_N		    (HReset_N   ),
	    
	    //Master
	    .mHADDR			    (mHADDR			),
	    .mHTRANS     	    (mHTRANS     	),
	    .mHWRITE     	    (mHWRITE     	),
	    .mHSIZE      	    (mHSIZE      	),
	    .mHBURST     	    (mHBURST     	),
	    .mHPORT      	    (mHPORT      	),
	    .mHWDATA     	    (mHWDATA     	),
	    .mHREADY     	    (mHREADY     	),
	    .mHRESP      	    (mHRESP      	),
	    .mHRDATA     	    (mHRDATA     	),
	    .mHBUSRREQ  		(mHBUSRREQ  	),
	    .mHLOCK     		(mHLOCK     	),
	    .mHGRANT    		(mHGRANT    	),
        
	    //Slave
	    .sHSEL			    (sHSEL			),
	    .sHWrite            (sHWrite        ),
	    .sHTRANS            (sHTRANS        ),
	    .sHSIZE             (sHSIZE         ),
	    .sHBURST            (sHBURST        ),
	    .sHADDR             (sHADDR         ),
	    .sHWDATA            (sHWDATA        ),
	    .sHREADY            (sHREADY        ),
	    .sHREADY_RESP       (sHREADY_RESP   ),	
	    .sHRESP             (sHRESP         ),
	    .sHRDATA            (sHRDATA        ),
        
	    /**** interrupt ****/
	    .Interrupt          (Interrupt      )
        );
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
endmodule