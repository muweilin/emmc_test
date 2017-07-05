/*
    Copyright (c) 2016 SMIC
    Filename:      ram_1024x24.v
    IP code :      S55NLLGSPH
    Version:       1.1.a
    CreateDate:    Dec 28, 2016

    Verilog Model for General Single-PORT SRAM
    SMIC 55nm LL Logic Process

    Configuration: -instname ram_1024x24 -rows 128 -bits 24 -mux 8 
    Redundancy: Off
    Bit-Write: Off
*/

/* DISCLAIMER                                                                      */
/*                                                                                 */  
/*   SMIC hereby provides the quality information to you but makes no claims,      */
/* promises or guarantees about the accuracy, completeness, or adequacy of the     */
/* information herein. The information contained herein is provided on an "AS IS"  */
/* basis without any warranty, and SMIC assumes no obligation to provide support   */
/* of any kind or otherwise maintain the information.                              */  
/*   SMIC disclaims any representation that the information does not infringe any  */
/* intellectual property rights or proprietary rights of any third parties. SMIC   */
/* makes no other warranty, whether express, implied or statutory as to any        */
/* matter whatsoever, including but not limited to the accuracy or sufficiency of  */
/* any information or the merchantability and fitness for a particular purpose.    */
/* Neither SMIC nor any of its representatives shall be liable for any cause of    */
/* action incurred to connect to this service.                                     */  
/*                                                                                 */
/* STATEMENT OF USE AND CONFIDENTIALITY                                            */  
/*                                                                                 */  
/*   The following/attached material contains confidential and proprietary         */  
/* information of SMIC. This material is based upon information which SMIC         */  
/* considers reliable, but SMIC neither represents nor warrants that such          */
/* information is accurate or complete, and it must not be relied upon as such.    */
/* This information was prepared for informational purposes and is for the use     */
/* by SMIC's customer only. SMIC reserves the right to make changes in the         */  
/* information at any time without notice.                                         */  
/*   No part of this information may be reproduced, transmitted, transcribed,      */  
/* stored in a retrieval system, or translated into any human or computer          */ 
/* language, in any form or by any means, electronic, mechanical, magnetic,        */  
/* optical, chemical, manual, or otherwise, without the prior written consent of   */
/* SMIC. Any unauthorized use or disclosure of this material is strictly           */  
/* prohibited and may be unlawful. By accepting this material, the receiving       */  
/* party shall be deemed to have acknowledged, accepted, and agreed to be bound    */
/* by the foregoing limitations and restrictions. Thank you.                       */  
/*                                                                                 */  

`timescale 1ns/1ps
`celldefine

module ram_1024x24(
                          Q,
			  CLK,
			  CEN,
			  WEN,
			  A,
			  D);

  parameter	Bits = 24;
  parameter	Word_Depth = 1024;
  parameter	Add_Width = 10;

  output [Bits-1:0]      	Q;
  input		   		CLK;
  input		   		CEN;
  input		   		WEN;
  input	[Add_Width-1:0] 	A;
  input	[Bits-1:0] 		D;

  wire [Bits-1:0] 	Q_int;
  wire [Add_Width-1:0] 	A_int;
  wire                 	CLK_int;
  wire                 	CEN_int;
  wire                 	WEN_int;
  wire [Bits-1:0] 	D_int;

  reg  [Bits-1:0] 	Q_latched;
  reg  [Add_Width-1:0] 	A_latched;
  reg  [Bits-1:0] 	D_latched;
  reg                  	CEN_latched;
  reg                  	LAST_CLK;
  reg                  	WEN_latched;

  reg 			A0_flag;
  reg 			A1_flag;
  reg 			A2_flag;
  reg 			A3_flag;
  reg 			A4_flag;
  reg 			A5_flag;
  reg 			A6_flag;
  reg 			A7_flag;
  reg 			A8_flag;
  reg 			A9_flag;

  reg                	CEN_flag;
  reg                   CLK_CYC_flag;
  reg                   CLK_H_flag;
  reg                   CLK_L_flag;

  reg 			D0_flag;
  reg 			D1_flag;
  reg 			D2_flag;
  reg 			D3_flag;
  reg 			D4_flag;
  reg 			D5_flag;
  reg 			D6_flag;
  reg 			D7_flag;
  reg 			D8_flag;
  reg 			D9_flag;
  reg 			D10_flag;
  reg 			D11_flag;
  reg 			D12_flag;
  reg 			D13_flag;
  reg 			D14_flag;
  reg 			D15_flag;
  reg 			D16_flag;
  reg 			D17_flag;
  reg 			D18_flag;
  reg 			D19_flag;
  reg 			D20_flag;
  reg 			D21_flag;
  reg 			D22_flag;
  reg 			D23_flag;

  reg                   WEN_flag; 
  reg [Add_Width-1:0]   A_flag;
  reg [Bits-1:0]        D_flag;
  reg                   LAST_CEN_flag;
  reg                   LAST_WEN_flag;
  reg [Add_Width-1:0]   LAST_A_flag;
  reg [Bits-1:0]        LAST_D_flag;

  reg                   LAST_CLK_CYC_flag;
  reg                   LAST_CLK_H_flag;
  reg                   LAST_CLK_L_flag;

  wire                  CE_flag;
  wire                  WR_flag;
  reg    [Bits-1:0] 	mem_array[Word_Depth-1:0];

  integer      i;
  integer      n;

  buf dout_buf[Bits-1:0] (Q, Q_int);
  buf (CLK_int, CLK);
  buf (CEN_int, CEN);
  buf (WEN_int, WEN);
  buf a_buf[Add_Width-1:0] (A_int, A);
  buf din_buf[Bits-1:0] (D_int, D);   

  assign Q_int=Q_latched;
  assign CE_flag=!CEN_int;
  assign WR_flag=(!CEN_int && !WEN_int);

  always @(CLK_int)
    begin
      casez({LAST_CLK, CLK_int})
        2'b01: begin
          CEN_latched = CEN_int;
          WEN_latched = WEN_int;
          A_latched = A_int;
          D_latched = D_int;
          rw_mem;
        end
        2'b10,
        2'bx?,
        2'b00,
        2'b11: ;
        2'b?x: begin
	  for(i=0;i<Word_Depth;i=i+1)
    	    mem_array[i]={Bits{1'bx}};
    	  Q_latched={Bits{1'bx}};
          rw_mem;
          end
      endcase
    LAST_CLK=CLK_int;
   end

  always @(CEN_flag
           	or WEN_flag
		or A0_flag
		or A1_flag
		or A2_flag
		or A3_flag
		or A4_flag
		or A5_flag
		or A6_flag
		or A7_flag
		or A8_flag
		or A9_flag
		or D0_flag
		or D1_flag
		or D2_flag
		or D3_flag
		or D4_flag
		or D5_flag
		or D6_flag
		or D7_flag
		or D8_flag
		or D9_flag
		or D10_flag
		or D11_flag
		or D12_flag
		or D13_flag
		or D14_flag
		or D15_flag
		or D16_flag
		or D17_flag
		or D18_flag
		or D19_flag
		or D20_flag
		or D21_flag
		or D22_flag
		or D23_flag
           	or CLK_CYC_flag
           	or CLK_H_flag
           	or CLK_L_flag)
    begin
      update_flag_bus;
      CEN_latched = (CEN_flag!==LAST_CEN_flag) ? 1'bx : CEN_latched ;
      WEN_latched = (WEN_flag!==LAST_WEN_flag) ? 1'bx : WEN_latched ;
      for (n=0; n<Add_Width; n=n+1)
      A_latched[n] = (A_flag[n]!==LAST_A_flag[n]) ? 1'bx : A_latched[n] ;
      for (n=0; n<Bits; n=n+1)
      D_latched[n] = (D_flag[n]!==LAST_D_flag[n]) ? 1'bx : D_latched[n] ;
      LAST_CEN_flag = CEN_flag;
      LAST_WEN_flag = WEN_flag;
      LAST_A_flag = A_flag;
      LAST_D_flag = D_flag;
      LAST_CLK_CYC_flag = CLK_CYC_flag;
      LAST_CLK_H_flag = CLK_H_flag;
      LAST_CLK_L_flag = CLK_L_flag;
      rw_mem;
   end
      
  task rw_mem;
    begin
      if(CEN_latched==1'b0)
        begin
	  if(WEN_latched==1'b1) 	
   	    begin
   	      if(^(A_latched)==1'bx)
   	        Q_latched={Bits{1'bx}};
   	      else
		Q_latched=mem_array[A_latched];
       	    end
          else if(WEN_latched==1'b0)
   	    begin
   	      if(^(A_latched)==1'bx)
   	        begin
                  x_mem;
   	          Q_latched={Bits{1'bx}};
   	        end   	        
   	      else
		begin
   	          mem_array[A_latched]=D_latched;
   	          Q_latched=mem_array[A_latched];
   	        end
   	    end
	  else 
     	    begin
   	      Q_latched={Bits{1'bx}};
   	      if(^(A_latched)===1'bx)
                for(i=0;i<Word_Depth;i=i+1)
   		  mem_array[i]={Bits{1'bx}};   	        
              else
		mem_array[A_latched]={Bits{1'bx}};
   	    end
	end  	    	    
      else if(CEN_latched===1'bx)
        begin
	  if(WEN_latched===1'b1)
   	    Q_latched={Bits{1'bx}};
	  else 
	    begin
   	      Q_latched={Bits{1'bx}};
	      if(^(A_latched)===1'bx)
                x_mem;
              else
		mem_array[A_latched]={Bits{1'bx}};
   	    end	      	    	  
        end
    end
  endtask
      
   task x_mem;
   begin
     for(i=0;i<Word_Depth;i=i+1)
     mem_array[i]={Bits{1'bx}};
   end
   endtask

  task update_flag_bus;
  begin
    A_flag = {
		A9_flag,
		A8_flag,
		A7_flag,
		A6_flag,
		A5_flag,
		A4_flag,
		A3_flag,
		A2_flag,
		A1_flag,
            A0_flag};
    D_flag = {
		D23_flag,
		D22_flag,
		D21_flag,
		D20_flag,
		D19_flag,
		D18_flag,
		D17_flag,
		D16_flag,
		D15_flag,
		D14_flag,
		D13_flag,
		D12_flag,
		D11_flag,
		D10_flag,
		D9_flag,
		D8_flag,
		D7_flag,
		D6_flag,
		D5_flag,
		D4_flag,
		D3_flag,
		D2_flag,
		D1_flag,
            D0_flag};
   end
   endtask

  specify
    (posedge CLK => (Q[0] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[1] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[2] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[3] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[4] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[5] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[6] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[7] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[8] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[9] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[10] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[11] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[12] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[13] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[14] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[15] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[16] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[17] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[18] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[19] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[20] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[21] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[22] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[23] : 1'bx))=(1.000,1.000);
   /* $setuphold(posedge CLK &&& CE_flag,posedge A[0],0.500,0.250,A0_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[0],0.500,0.250,A0_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge A[1],0.500,0.250,A1_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[1],0.500,0.250,A1_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge A[2],0.500,0.250,A2_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[2],0.500,0.250,A2_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge A[3],0.500,0.250,A3_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[3],0.500,0.250,A3_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge A[4],0.500,0.250,A4_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[4],0.500,0.250,A4_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge A[5],0.500,0.250,A5_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[5],0.500,0.250,A5_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge A[6],0.500,0.250,A6_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[6],0.500,0.250,A6_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge A[7],0.500,0.250,A7_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[7],0.500,0.250,A7_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge A[8],0.500,0.250,A8_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[8],0.500,0.250,A8_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge A[9],0.500,0.250,A9_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[9],0.500,0.250,A9_flag);
    $setuphold(posedge CLK,posedge CEN,0.500,0.250,CEN_flag);
    $setuphold(posedge CLK,negedge CEN,0.500,0.250,CEN_flag);
    $period(posedge CLK,1.926,CLK_CYC_flag);
    $width(posedge CLK,0.578,0,CLK_H_flag);
    $width(negedge CLK,0.578,0,CLK_L_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[0],0.500,0.250,D0_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[0],0.500,0.250,D0_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[1],0.500,0.250,D1_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[1],0.500,0.250,D1_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[2],0.500,0.250,D2_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[2],0.500,0.250,D2_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[3],0.500,0.250,D3_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[3],0.500,0.250,D3_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[4],0.500,0.250,D4_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[4],0.500,0.250,D4_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[5],0.500,0.250,D5_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[5],0.500,0.250,D5_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[6],0.500,0.250,D6_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[6],0.500,0.250,D6_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[7],0.500,0.250,D7_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[7],0.500,0.250,D7_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[8],0.500,0.250,D8_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[8],0.500,0.250,D8_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[9],0.500,0.250,D9_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[9],0.500,0.250,D9_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[10],0.500,0.250,D10_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[10],0.500,0.250,D10_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[11],0.500,0.250,D11_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[11],0.500,0.250,D11_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[12],0.500,0.250,D12_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[12],0.500,0.250,D12_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[13],0.500,0.250,D13_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[13],0.500,0.250,D13_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[14],0.500,0.250,D14_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[14],0.500,0.250,D14_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[15],0.500,0.250,D15_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[15],0.500,0.250,D15_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[16],0.500,0.250,D16_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[16],0.500,0.250,D16_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[17],0.500,0.250,D17_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[17],0.500,0.250,D17_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[18],0.500,0.250,D18_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[18],0.500,0.250,D18_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[19],0.500,0.250,D19_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[19],0.500,0.250,D19_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[20],0.500,0.250,D20_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[20],0.500,0.250,D20_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[21],0.500,0.250,D21_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[21],0.500,0.250,D21_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[22],0.500,0.250,D22_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[22],0.500,0.250,D22_flag);
    $setuphold(posedge CLK &&& WR_flag,posedge D[23],0.500,0.250,D23_flag);
    $setuphold(posedge CLK &&& WR_flag,negedge D[23],0.500,0.250,D23_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge WEN,0.500,0.250,WEN_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge WEN,0.500,0.250,WEN_flag);*/
  endspecify

endmodule

`endcelldefine
