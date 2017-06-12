
module DLL_DELAY_LINE_256(
	o_DLLout	,
	i_DLLin		,
	sel_index
);

output 			o_DLLout	;
input 			i_DLLin		;
input[  7:0] 	sel_index	;

wire [255:0]	sel_n		;

//==================================

assign  sel_n = {256{1'b1}}>>(256-sel_index) ;

DLL_DELAY_LINE_256_CORE DLL_DELAY_LINE_256_CORE(
    .o_DLLout	    (o_DLLout	),
	.i_DLLin		(i_DLLin	),
	.sel_n          (sel_n      )
    );

endmodule

module DLL_DELAY_LINE_256_CORE(
	o_DLLout	,
	i_DLLin		,
	sel_n
);
    
    output 			o_DLLout	;
    input 			i_DLLin		;
    input[255: 0] 	sel_n	    ;
    
    wire [254:1] 	pass		;
    wire [254:1] 	ret			;
    wire			tmp1		;
    
    DLL_DELAY_ELEMENT delay[255:1](
		.pass		({tmp1			, pass		}),
		.out		({ret 			, o_DLLout	}),
		.ret		({1'b1			, ret		}),
		.in			({pass			, i_DLLin	}),
		.en			({sel_n[254:1]	, 1'b1		}),
		.sel_n		({sel_n[255:1]				})
		);
    
endmodule