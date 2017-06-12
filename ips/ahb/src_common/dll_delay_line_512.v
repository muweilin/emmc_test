
module DLL_DELAY_LINE_512(
	o_DLLout	,
	i_DLLin		,
	sel_index
);

output 			o_DLLout	;
input 			i_DLLin		;
input[  8:0] 	sel_index	;

wire [511:0]	sel_n		;
wire [510:1] 	pass		;
wire [510:1] 	ret			;

wire			tmp1		;

//==================================

assign  sel_n = {512{1'b1}}>>(512-sel_index) ;

DLL_DELAY_ELEMENT delay[511:1](
		.pass		({tmp1			, pass		}),
		.out		({ret 			, o_DLLout	}),
		.ret		({1'b1			, ret		}),
		.in			({pass			, i_DLLin	}),
		.en			({sel_n[510:1]	, 1'b1		}),
		.sel_n		({sel_n[511:1]				})
		);

endmodule

