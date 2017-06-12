
`timescale 10ps/1ps

module DLL_DELAY_ELEMENT(
	out     	,
	pass   		,
	ret     	,
	en      	,
	sel_n  		,
	in
);
	output 	out		;
	output 	pass	;
	input	ret		;
	input	en		;
	input	sel_n	;
	input	in		;
	
	wire 	r0_out	;
	wire 	r1_out	;
	wire 	p1_out	;
	
`ifdef	SIM
    assign #1 	r0_out	= ~(en     & sel_n );
	assign #1 	r1_out	= ~(in     & r0_out);	
	assign #1 	p1_out	= ~ r0_out ;                    
	assign #1 	out		= ~(ret    & r1_out);	
	assign #1 	pass	= ~(in     & p1_out);
`else
    assign #1 	r0_out	=~(en&sel_n);
	assign #1 	r1_out	=~(in&r0_out);	
	assign #1 	p1_out	=~(r0_out&r0_out);	            //应该与上述代码等价，但该版本在模拟时p1_out等于r0_out
	assign #1 	out		=~(ret&r1_out);	
	assign #1 	pass	=~(in&p1_out);
`endif
	
endmodule
