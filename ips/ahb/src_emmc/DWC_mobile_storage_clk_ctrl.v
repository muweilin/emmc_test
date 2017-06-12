`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_clk_ctrl(    
    //clock ready
    o_clk_ready         ,
    
    //clock output
    o_cclk_in           ,
	o_cclk_in_drv       ,
	o_cclk_in_sample    ,
	
	//ctrl
	ext_clk_mux_ctrl    ,   //from DWC_mobile_storage_core, IOR:UHS_REG_EXT
	clk_drv_phase_ctrl  ,   //from DWC_mobile_storage_core, IOR:UHS_REG_EXT
	clk_smpl_phase_ctrl ,   //from DWC_mobile_storage_core, IOR:UHS_REG_EXT	
	i_clk_enable        ,   //from DWC_mobile_storage_core, IOR:GPIO[CLK_ENABLE]
		
	//global
	ext_clk             ,   //high frequency clk, hclk_2x
    rst_n
);
    //clock ready
    output          o_clk_ready         ;
    
    //clock output
    output          o_cclk_in           ;
	output          o_cclk_in_drv       ;
	output          o_cclk_in_sample    ;
	
	//ctrl
	input [ 1: 0]   ext_clk_mux_ctrl    ;   //from DWC_mobile_storage_core, IOR:UHS_REG_EXT
	input [ 6: 0]   clk_drv_phase_ctrl  ;   //from DWC_mobile_storage_core, IOR:UHS_REG_EXT
	input [ 6: 0]   clk_smpl_phase_ctrl ;   //from DWC_mobile_storage_core, IOR:UHS_REG_EXT	
	input           i_clk_enable        ;   //from DWC_mobile_storage_core, IOR:GPIO[CLK_ENABLE]
		
	//global
	input           ext_clk             ;   //high frequency clk, hclk_2x
    input           rst_n               ;
    
    /*****************************************/
    parameter	CLK_OFF			= 2'b00,
				CLK_INF_CFG		= 2'b01,
				CLK_ON			= 2'b10,
				CLK_DOWN		= 2'b11;
                        
    reg             r_rst_cclk_0        , 
                    r_rst_cclk_1        , 
                    r_rst_cclk_2        , 
                    r_rst_cclk_3        ;
                                        
    wire            rst_cclk_n          , 
                    c_clk_start         , 
                    c_clk_end           ;
                    
    reg				r_clk_enable		;
	reg				r1_clk_enable		;
	reg				r2_clk_enable		;
	reg				r3_clk_enable	    ;
	reg             r4_clk_enable	    ;                    
                                        
    reg [ 1: 0]		r_fsm				;
	reg [ 1: 0]		c_fsm				;
	
	reg [ 5: 0]		r_cnt				;
	reg [ 5: 0]		c_cnt				;
	
	reg				r_clk_div			;
    reg [63: 0]		r_clk_div_shift		;
    
    reg				r_cclk				;
	reg				r_cclk_drv			;
	reg				r_cclk_sample		;

	reg				r_cclk_en			;
	reg				r_cclk_drv_en		;
	reg				r_cclk_sample_en	;

	reg				c_cclk_en			;
	reg				c_cclk_drv_en		;
	reg				c_cclk_sample_en	;
                 
        
    //复位信号的同步撤销
    always @ (posedge ext_clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            r_rst_cclk_0 <= 1'b0;
            r_rst_cclk_1 <= 1'b0;
            r_rst_cclk_2 <= 1'b0;
            r_rst_cclk_3 <= 1'b0;
        end
     else
        begin
            r_rst_cclk_0 <= 1'b1;
            r_rst_cclk_1 <= r_rst_cclk_0;
            r_rst_cclk_2 <= r_rst_cclk_1;
            r_rst_cclk_3 <= r_rst_cclk_2;
        end
    end
    
    assign rst_cclk_n =  r_rst_cclk_3;
    
    //Clock Enable        
    always @(posedge ext_clk or negedge rst_cclk_n)
	begin
		if(!rst_cclk_n)
		begin
			r_clk_enable  <= 1'b0;
			r1_clk_enable <= 1'b0;
			r2_clk_enable <= 1'b0;
			r3_clk_enable <= 1'b0;
			r4_clk_enable <= 1'b0;
		end
		else
		begin
			r_clk_enable  <= i_clk_enable;
			r1_clk_enable <= r_clk_enable;
			r2_clk_enable <= r1_clk_enable;
			r3_clk_enable <= r2_clk_enable;
			r4_clk_enable <= r3_clk_enable;
		end
	end
    
    assign c_clk_start =  r3_clk_enable & ~r4_clk_enable;
	assign c_clk_end   = ~r3_clk_enable &  r4_clk_enable;
    
    
    //状态机处理
    always @(posedge ext_clk or negedge rst_cclk_n)
	begin
		if(!rst_cclk_n)
			r_fsm <= CLK_OFF;
		else
			r_fsm <= c_fsm;
	end
    
    always @(*)
	begin
		case(r_fsm)
		CLK_OFF :
			if(c_clk_start)
				c_fsm = CLK_INF_CFG;
			else
			    c_fsm = r_fsm;
		
		CLK_INF_CFG :
			c_fsm = CLK_ON;
		
		CLK_ON :
			if(c_clk_end)
				c_fsm = CLK_DOWN;
			else
			    c_fsm = r_fsm;
		
		CLK_DOWN :
			if(~r_cclk_en & ~r_cclk_drv_en & ~r_cclk_sample_en)
				c_fsm = CLK_OFF;
			else
				c_fsm = r_fsm;

		default : 
		        c_fsm = r_fsm;
		endcase
	end
    
    assign o_clk_ready = (r_fsm == CLK_ON) || (r_fsm == CLK_DOWN) ;
    
    //控制信息    
    //ext_clk_mux_ctrl[1:0] cclk_in分频选择 0：2分频；1：4分频；2：6分频；3：8分频
    //clk_drv_phase_ctrl[6:0] [6:4]：DelayLine；[3:0]：Phase Shift
    //clk_smpl_phase_ctrl[6:0] [6:4]：DelayLine；[3:0]：Phase Shift        
    //只支持Phase Shift控制，Phase Shift是相对于ext_clk的节拍延时，配置值与ext_clk_mux_ctrl设置相关
    
    reg [ 1: 0]   r_ext_clk_mux_ctrl    ;
    reg [ 6: 0]   r_clk_drv_phase_ctrl  ;
    reg [ 6: 0]   r_clk_smpl_phase_ctrl ;
    
    always @(posedge ext_clk or negedge rst_cclk_n)
	begin
		if(!rst_cclk_n)
		begin
			r_ext_clk_mux_ctrl      <= 2'h0; 
			r_clk_drv_phase_ctrl    <= 7'h0;
			r_clk_smpl_phase_ctrl	<= 7'h0;		
	    end
		else if (c_fsm == CLK_INF_CFG)
		begin
			r_ext_clk_mux_ctrl      <= ext_clk_mux_ctrl    ;
			r_clk_drv_phase_ctrl    <= clk_drv_phase_ctrl  ;
			r_clk_smpl_phase_ctrl	<= clk_smpl_phase_ctrl ;					
		end
	end
    
    //分频计数器(cclk_in)
    always @(posedge ext_clk or negedge rst_cclk_n)
	begin
		if(!rst_cclk_n)
			r_cnt <= 6'b0;
		else
			r_cnt <= c_cnt;
	end
    
    always @(*)
	begin
		if( r_fsm == CLK_INF_CFG || r_fsm == CLK_OFF )
			c_cnt = 6'b0;
		else if( r_cnt == {4'h0,r_ext_clk_mux_ctrl} )
			c_cnt = 6'b0;
		else
			c_cnt = r_cnt + 1'b1;
	end
    
    //分频时钟        
    always @(posedge ext_clk or negedge rst_cclk_n)
	begin
		if(!rst_cclk_n)
			r_clk_div <= 1'b0;
		else  if (r_fsm == CLK_INF_CFG  || r_fsm == CLK_OFF)
			r_clk_div <= 1'b0;
		else  if ( r_cnt == {4'h0,r_ext_clk_mux_ctrl} )
			r_clk_div <= ~r_clk_div;
	end
    
    //延时控制
    always @(posedge ext_clk or negedge rst_cclk_n)
	begin
		if(!rst_cclk_n)
			r_clk_div_shift <= 64'b0;
		else if(r_fsm == CLK_INF_CFG  || r_fsm == CLK_OFF)
			r_clk_div_shift <= 64'b0;
		else
			r_clk_div_shift <= {r_clk_div_shift[62:0],r_clk_div};
	end
    
    //clock Enable
    always @(posedge ext_clk or negedge rst_cclk_n)
	begin
		if(!rst_cclk_n)
		begin
			r_cclk_en       <= 1'b0;
			r_cclk_drv_en   <= 1'b0;
			r_cclk_sample_en<= 1'b0;
		end
		else
		begin
			r_cclk_en       <= c_cclk_en;
			r_cclk_drv_en   <= c_cclk_drv_en;
			r_cclk_sample_en<= c_cclk_sample_en;
		end
	end
    
    always @(*)
	begin
	    if(r_fsm == CLK_ON)
	    begin
	    	c_cclk_en       = 1'b1;
	    	c_cclk_drv_en   = 1'b1;
	    	c_cclk_sample_en= 1'b1;
	    end
	    else if (r_fsm == CLK_DOWN)
	    begin
	    	if(~r_cclk | r_cclk & ~r_clk_div_shift[0])
	    		c_cclk_en = 1'b0;
	    	else
	    		c_cclk_en = r_cclk_en;
        
	    	if(~r_cclk_drv | r_cclk_drv & ~r_clk_div_shift[{2'h0,r_clk_drv_phase_ctrl[3:0]}])
	    		c_cclk_drv_en = 1'b0;
	    	else
	    		c_cclk_drv_en = r_cclk_drv_en;
        
	    	if(~r_cclk_sample | r_cclk_sample & ~r_clk_div_shift[{2'h0,r_clk_smpl_phase_ctrl[3:0]}])
	    		c_cclk_sample_en = 1'b0;
	    	else
	    		c_cclk_sample_en = r_cclk_sample_en;
	    end
	    else //if (r_fsm == CLK_OFF || r_fsm == CLK_INF_CFG)
	    begin
	    	c_cclk_en       = 1'b0;
	    	c_cclk_drv_en   = 1'b0;
	    	c_cclk_sample_en= 1'b0;
	    end
	end
    
    always @(posedge ext_clk or negedge rst_cclk_n)
	begin
		if(!rst_cclk_n)
		begin
			r_cclk          <= 1'b0;
			r_cclk_drv      <= 1'b0;
			r_cclk_sample   <= 1'b0;
		end
		else
		begin
			r_cclk          <= r_clk_div_shift[0]                   & c_cclk_en;
			r_cclk_drv      <= r_clk_div_shift[{2'h0,r_clk_drv_phase_ctrl[3:0]}]  & c_cclk_drv_en;
			r_cclk_sample   <= r_clk_div_shift[{2'h0,r_clk_smpl_phase_ctrl[3:0]}] & c_cclk_sample_en;
		end
	end
    
    assign o_cclk_in        = r_cclk;
	assign o_cclk_in_drv    = r_cclk_drv;
	assign o_cclk_in_sample = r_cclk_sample;
    
endmodule

