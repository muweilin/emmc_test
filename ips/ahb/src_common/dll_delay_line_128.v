

module DLL_DELAY_LINE_128(
	o_DLLout	,
	i_DLLin		,
	sel_index
);

output 			o_DLLout	;
input 			i_DLLin		;
input[  6:0] 	sel_index	;

wire [127:0]	sel_n		;

//=================================

assign  sel_n = {128{1'b1}}>>(128-sel_index) ;

DLL_DELAY_LINE_128_CORE DLL_DELAY_LINE_128_CORE(
    .o_DLLout	    (o_DLLout	),
	.i_DLLin		(i_DLLin	),
	.sel_n          (sel_n      )
    );

endmodule

module DLL_DELAY_LINE_128_CORE(
	o_DLLout	,
	i_DLLin		,
	sel_n
);
    
    output 			o_DLLout	;
    input 			i_DLLin		;
    input[127: 0] 	sel_n	    ;
    
    wire [126:1] 	pass		;
    wire [126:1] 	ret			;
    wire			tmp1		;
    
    DLL_DELAY_ELEMENT delay[127:1](
		.pass		({tmp1			, pass		}),
		.out		({ret 			, o_DLLout	}),
		.ret		({1'b1			, ret		}),
		.in			({pass			, i_DLLin	}),
		.en			({sel_n[126:1]	, 1'b1		}),
		.sel_n		({sel_n[127:1]				})
		);
    
endmodule