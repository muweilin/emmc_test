/*
    Copyright (c) 2016 SMIC
    Filename:      ram_4096x32.v
    IP code :      S55NLLGSPH
    Version:       1.1.a
    CreateDate:    Oct 5, 2016

    Verilog Model for General Single-PORT SRAM
    SMIC 55nm LL Logic Process

    Configuration: -instname ram_4096x32 -rows 512 -bits 32 -mux 8 
    Redundancy: Off
    Bit-Write: On
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

module ram_4096x32(
                          Q,
			  CLK,
			  CEN,
			  WEN,
                      BWEN,
			  A,
			  D);

  parameter	Bits = 32;
  parameter	Word_Depth = 4096;
  parameter	Add_Width = 12;
  parameter     Wen_Width = 32;
  parameter     Word_Pt = 1;

  output [Bits-1:0]      	Q;
  input		   		CLK;
  input		   		CEN;
  input		   		WEN;
  input	[Wen_Width-1:0]         BWEN;
  input	[Add_Width-1:0] 	A;
  input	[Bits-1:0] 		D;


  wire [Bits-1:0] 	Q_int;
  wire [Add_Width-1:0] 	A_int;
  wire                 	CLK_int;
  wire                 	CEN_int;
  wire                 	WEN_int;
  wire [Wen_Width-1:0]  BWEN_int;
  wire [Bits-1:0] 	D_int;

  reg  [Bits-1:0] 	Q_latched;
  reg  [Add_Width-1:0] 	A_latched;
  reg  [Bits-1:0] 	D_latched;
  reg                  	CEN_latched;
  reg                   WEN_latched;
  reg                  	LAST_CLK;
  reg  [Wen_Width-1:0]      BWEN_latched;
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
  reg 			A10_flag;
  reg 			A11_flag;

  reg                	CEN_flag;
  reg                   WEN_flag;
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
  reg 			D24_flag;
  reg 			D25_flag;
  reg 			D26_flag;
  reg 			D27_flag;
  reg 			D28_flag;
  reg 			D29_flag;
  reg 			D30_flag;
  reg 			D31_flag;
 reg 			BWEN0_flag;
 reg 			BWEN1_flag;
 reg 			BWEN2_flag;
 reg 			BWEN3_flag;
 reg 			BWEN4_flag;
 reg 			BWEN5_flag;
 reg 			BWEN6_flag;
 reg 			BWEN7_flag;
 reg 			BWEN8_flag;
 reg 			BWEN9_flag;
 reg 			BWEN10_flag;
 reg 			BWEN11_flag;
 reg 			BWEN12_flag;
 reg 			BWEN13_flag;
 reg 			BWEN14_flag;
 reg 			BWEN15_flag;
 reg 			BWEN16_flag;
 reg 			BWEN17_flag;
 reg 			BWEN18_flag;
 reg 			BWEN19_flag;
 reg 			BWEN20_flag;
 reg 			BWEN21_flag;
 reg 			BWEN22_flag;
 reg 			BWEN23_flag;
 reg 			BWEN24_flag;
 reg 			BWEN25_flag;
 reg 			BWEN26_flag;
 reg 			BWEN27_flag;
 reg 			BWEN28_flag;
 reg 			BWEN29_flag;
 reg 			BWEN30_flag;
 reg 			BWEN31_flag;


  reg [Wen_Width-1:0]     BWEN_flag;
  reg [Add_Width-1:0]   A_flag;
  reg [Bits-1:0]        D_flag;
  reg                   LAST_CEN_flag;
  reg                   LAST_WEN_flag;
  reg [Wen_Width-1:0]   LAST_BWEN_flag;
  reg [Add_Width-1:0]   LAST_A_flag;
  reg [Bits-1:0]        LAST_D_flag;

  reg                   LAST_CLK_CYC_flag;
  reg                   LAST_CLK_H_flag;
  reg                   LAST_CLK_L_flag;

  reg [Bits-1:0]          data_tmp;

  wire                  CE_flag;
  wire                  WR0_flag;
  wire                  WR1_flag;
  wire                  WR2_flag;
  wire                  WR3_flag;
  wire                  WR4_flag;
  wire                  WR5_flag;
  wire                  WR6_flag;
  wire                  WR7_flag;
  wire                  WR8_flag;
  wire                  WR9_flag;
  wire                  WR10_flag;
  wire                  WR11_flag;
  wire                  WR12_flag;
  wire                  WR13_flag;
  wire                  WR14_flag;
  wire                  WR15_flag;
  wire                  WR16_flag;
  wire                  WR17_flag;
  wire                  WR18_flag;
  wire                  WR19_flag;
  wire                  WR20_flag;
  wire                  WR21_flag;
  wire                  WR22_flag;
  wire                  WR23_flag;
  wire                  WR24_flag;
  wire                  WR25_flag;
  wire                  WR26_flag;
  wire                  WR27_flag;
  wire                  WR28_flag;
  wire                  WR29_flag;
  wire                  WR30_flag;
  wire                  WR31_flag;
  reg    [Bits-1:0] 	mem_array[Word_Depth-1:0];

  integer      i,j,wenn,lb,hb;
  integer      n;

  buf dout_buf[Bits-1:0] (Q, Q_int);
  buf (CLK_int, CLK);
  buf (CEN_int, CEN);
  buf (WEN_int, WEN);
  buf wen_buf[Wen_Width-1:0] (BWEN_int, BWEN);
  buf a_buf[Add_Width-1:0] (A_int, A);
  buf din_buf[Bits-1:0] (D_int, D);   

  assign Q_int=Q_latched;
  assign CE_flag=!CEN_int;
  assign WR0_flag=(!CEN_int && !WEN_int && !BWEN_int[0]);
  assign WR1_flag=(!CEN_int && !WEN_int && !BWEN_int[1]);
  assign WR2_flag=(!CEN_int && !WEN_int && !BWEN_int[2]);
  assign WR3_flag=(!CEN_int && !WEN_int && !BWEN_int[3]);
  assign WR4_flag=(!CEN_int && !WEN_int && !BWEN_int[4]);
  assign WR5_flag=(!CEN_int && !WEN_int && !BWEN_int[5]);
  assign WR6_flag=(!CEN_int && !WEN_int && !BWEN_int[6]);
  assign WR7_flag=(!CEN_int && !WEN_int && !BWEN_int[7]);
  assign WR8_flag=(!CEN_int && !WEN_int && !BWEN_int[8]);
  assign WR9_flag=(!CEN_int && !WEN_int && !BWEN_int[9]);
  assign WR10_flag=(!CEN_int && !WEN_int && !BWEN_int[10]);
  assign WR11_flag=(!CEN_int && !WEN_int && !BWEN_int[11]);
  assign WR12_flag=(!CEN_int && !WEN_int && !BWEN_int[12]);
  assign WR13_flag=(!CEN_int && !WEN_int && !BWEN_int[13]);
  assign WR14_flag=(!CEN_int && !WEN_int && !BWEN_int[14]);
  assign WR15_flag=(!CEN_int && !WEN_int && !BWEN_int[15]);
  assign WR16_flag=(!CEN_int && !WEN_int && !BWEN_int[16]);
  assign WR17_flag=(!CEN_int && !WEN_int && !BWEN_int[17]);
  assign WR18_flag=(!CEN_int && !WEN_int && !BWEN_int[18]);
  assign WR19_flag=(!CEN_int && !WEN_int && !BWEN_int[19]);
  assign WR20_flag=(!CEN_int && !WEN_int && !BWEN_int[20]);
  assign WR21_flag=(!CEN_int && !WEN_int && !BWEN_int[21]);
  assign WR22_flag=(!CEN_int && !WEN_int && !BWEN_int[22]);
  assign WR23_flag=(!CEN_int && !WEN_int && !BWEN_int[23]);
  assign WR24_flag=(!CEN_int && !WEN_int && !BWEN_int[24]);
  assign WR25_flag=(!CEN_int && !WEN_int && !BWEN_int[25]);
  assign WR26_flag=(!CEN_int && !WEN_int && !BWEN_int[26]);
  assign WR27_flag=(!CEN_int && !WEN_int && !BWEN_int[27]);
  assign WR28_flag=(!CEN_int && !WEN_int && !BWEN_int[28]);
  assign WR29_flag=(!CEN_int && !WEN_int && !BWEN_int[29]);
  assign WR30_flag=(!CEN_int && !WEN_int && !BWEN_int[30]);
  assign WR31_flag=(!CEN_int && !WEN_int && !BWEN_int[31]);

  always @(CLK_int)
    begin
      casez({LAST_CLK, CLK_int})
        2'b01: begin
          CEN_latched = CEN_int;
          WEN_latched = WEN_int;
          BWEN_latched = BWEN_int;
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
		or BWEN0_flag
		or BWEN1_flag
		or BWEN2_flag
		or BWEN3_flag
		or BWEN4_flag
		or BWEN5_flag
		or BWEN6_flag
		or BWEN7_flag
		or BWEN8_flag
		or BWEN9_flag
		or BWEN10_flag
		or BWEN11_flag
		or BWEN12_flag
		or BWEN13_flag
		or BWEN14_flag
		or BWEN15_flag
		or BWEN16_flag
		or BWEN17_flag
		or BWEN18_flag
		or BWEN19_flag
		or BWEN20_flag
		or BWEN21_flag
		or BWEN22_flag
		or BWEN23_flag
		or BWEN24_flag
		or BWEN25_flag
		or BWEN26_flag
		or BWEN27_flag
		or BWEN28_flag
		or BWEN29_flag
		or BWEN30_flag
		or BWEN31_flag
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
		or A10_flag
		or A11_flag
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
		or D24_flag
		or D25_flag
		or D26_flag
		or D27_flag
		or D28_flag
		or D29_flag
		or D30_flag
		or D31_flag
           	or CLK_CYC_flag
           	or CLK_H_flag
           	or CLK_L_flag)
    begin
      update_flag_bus;
      CEN_latched = (CEN_flag!==LAST_CEN_flag) ? 1'bx : CEN_latched ;
      WEN_latched = (WEN_flag!==LAST_WEN_flag) ? 1'bx : WEN_latched ;
      for (n=0; n<Wen_Width; n=n+1)
      BWEN_latched[n] = (BWEN_flag[n]!==LAST_BWEN_flag[n]) ? 1'bx : BWEN_latched[n] ;
      for (n=0; n<Add_Width; n=n+1)
      A_latched[n] = (A_flag[n]!==LAST_A_flag[n]) ? 1'bx : A_latched[n] ;
      for (n=0; n<Bits; n=n+1)
      D_latched[n] = (D_flag[n]!==LAST_D_flag[n]) ? 1'bx : D_latched[n] ;
      LAST_CEN_flag = CEN_flag;
      LAST_WEN_flag = WEN_flag;
      LAST_BWEN_flag = BWEN_flag;
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
          if (WEN_latched==1'b1)
            begin
              if(^(A_latched)==1'bx)
                Q_latched={Bits{1'bx}};
              else
                Q_latched=mem_array[A_latched];
            end
          else if (WEN_latched==1'b0)
          begin
            for (wenn=0; wenn<Wen_Width; wenn=wenn+1)
              begin
                lb=wenn*Word_Pt;
                if ( (lb+Word_Pt) >= Bits) hb=Bits-1;
                else hb=lb+Word_Pt-1;
                if (BWEN_latched[wenn]==1'b1)
                  begin
                    if(^(A_latched)==1'bx)
                      for (i=lb; i<=hb; i=i+1) Q_latched[i]=1'bx;
                    else
                      begin
                      data_tmp=mem_array[A_latched];
                      for (i=lb; i<=hb; i=i+1) Q_latched[i]=data_tmp[i];
                      end
                  end
                else if (BWEN_latched[wenn]==1'b0)
                  begin
                    if (^(A_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmp=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmp[j]=1'bx;
                            mem_array[i]=data_tmp;
                          end
                        for (i=lb; i<=hb; i=i+1) Q_latched[i]=1'bx;
                      end
                    else
                      begin
                        data_tmp=mem_array[A_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmp[i]=D_latched[i];
                        mem_array[A_latched]=data_tmp;
                        for (i=lb; i<=hb; i=i+1) Q_latched[i]=data_tmp[i];
                      end
                  end
                else
                  begin
                    for (i=lb; i<=hb;i=i+1) Q_latched[i]=1'bx;
                    if (^(A_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmp=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmp[j]=1'bx;
                            mem_array[i]=data_tmp;
                          end
                      end
                    else
                      begin
                        data_tmp=mem_array[A_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmp[i]=1'bx;
                        mem_array[A_latched]=data_tmp;
                      end
                 end
               end
             end
           else
             begin
               for (wenn=0; wenn<Wen_Width; wenn=wenn+1)
               begin
                 lb=wenn*Word_Pt;
                 if ( (lb+Word_Pt) >= Bits) hb=Bits-1;
                 else hb=lb+Word_Pt-1;
                 if (BWEN_latched[wenn]==1'b1)
                  begin
                    if(^(A_latched)==1'bx)
                      for (i=lb; i<=hb; i=i+1) Q_latched[i]=1'bx;
                    else
                      begin
                      data_tmp=mem_array[A_latched];
                      for (i=lb; i<=hb; i=i+1) Q_latched[i]=data_tmp[i];
                      end
                  end
                else
                  begin
                    for (i=lb; i<=hb;i=i+1) Q_latched[i]=1'bx;
                    if (^(A_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmp=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmp[j]=1'bx;
                            mem_array[i]=data_tmp;
                          end
                      end
                    else
                      begin
                        data_tmp=mem_array[A_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmp[i]=1'bx;
                        mem_array[A_latched]=data_tmp;
                      end
                 end
               end
             end
           end
         else if (CEN_latched==1'bx)
           begin
             for (wenn=0;wenn<Wen_Width;wenn=wenn+1)
            begin
              lb=wenn*Word_Pt;
              if ((lb+Word_Pt)>=Bits) hb=Bits-1;
              else hb=lb+Word_Pt-1;
              if(WEN_latched==1'b1 || BWEN_latched[wenn]==1'b1)
                for (i=lb;i<=hb;i=i+1) Q_latched[i]=1'bx;
              else
                begin
                  for (i=lb;i<=hb;i=i+1) Q_latched[i]=1'bx;
                  if(^(A_latched)==1'bx)
                    begin
                      for (i=0;i<Word_Depth;i=i+1)
                        begin
                          data_tmp=mem_array[i];
                          for (j=lb;j<=hb;j=j+1) data_tmp[j]=1'bx;
                          mem_array[i]=data_tmp;
                        end
                    end
                  else
                    begin
                      data_tmp=mem_array[A_latched];
                      for (i=lb;i<=hb;i=i+1) data_tmp[i]=1'bx;
                      mem_array[A_latched]=data_tmp;
                    end
                end
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
 BWEN_flag = {

	    BWEN31_flag,
	    BWEN30_flag,
	    BWEN29_flag,
	    BWEN28_flag,
	    BWEN27_flag,
	    BWEN26_flag,
	    BWEN25_flag,
	    BWEN24_flag,
	    BWEN23_flag,
	    BWEN22_flag,
	    BWEN21_flag,
	    BWEN20_flag,
	    BWEN19_flag,
	    BWEN18_flag,
	    BWEN17_flag,
	    BWEN16_flag,
	    BWEN15_flag,
	    BWEN14_flag,
	    BWEN13_flag,
	    BWEN12_flag,
	    BWEN11_flag,
	    BWEN10_flag,
	    BWEN9_flag,
	    BWEN8_flag,
	    BWEN7_flag,
	    BWEN6_flag,
	    BWEN5_flag,
	    BWEN4_flag,
	    BWEN3_flag,
	    BWEN2_flag,
	    BWEN1_flag,
            BWEN0_flag};
    A_flag = {
		A11_flag,
		A10_flag,
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
		D31_flag,
		D30_flag,
		D29_flag,
		D28_flag,
		D27_flag,
		D26_flag,
		D25_flag,
		D24_flag,
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
    (posedge CLK => (Q[24] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[25] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[26] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[27] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[28] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[29] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[30] : 1'bx))=(1.000,1.000);
    (posedge CLK => (Q[31] : 1'bx))=(1.000,1.000);
/*    $setuphold(posedge CLK &&& CE_flag,posedge A[0],0.500,0.250,A0_flag);
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
    $setuphold(posedge CLK &&& CE_flag,posedge A[10],0.500,0.250,A10_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[10],0.500,0.250,A10_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge A[11],0.500,0.250,A11_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge A[11],0.500,0.250,A11_flag);
    $setuphold(posedge CLK,posedge CEN,0.500,0.250,CEN_flag);
    $setuphold(posedge CLK,negedge CEN,0.500,0.250,CEN_flag);
    $setuphold(posedge CLK,posedge WEN,0.500,0.250,WEN_flag);
    $setuphold(posedge CLK,negedge WEN,0.500,0.250,WEN_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[0],0.500,0.250,BWEN0_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[0],0.500,0.250,BWEN0_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[1],0.500,0.250,BWEN1_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[1],0.500,0.250,BWEN1_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[2],0.500,0.250,BWEN2_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[2],0.500,0.250,BWEN2_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[3],0.500,0.250,BWEN3_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[3],0.500,0.250,BWEN3_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[4],0.500,0.250,BWEN4_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[4],0.500,0.250,BWEN4_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[5],0.500,0.250,BWEN5_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[5],0.500,0.250,BWEN5_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[6],0.500,0.250,BWEN6_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[6],0.500,0.250,BWEN6_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[7],0.500,0.250,BWEN7_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[7],0.500,0.250,BWEN7_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[8],0.500,0.250,BWEN8_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[8],0.500,0.250,BWEN8_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[9],0.500,0.250,BWEN9_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[9],0.500,0.250,BWEN9_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[10],0.500,0.250,BWEN10_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[10],0.500,0.250,BWEN10_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[11],0.500,0.250,BWEN11_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[11],0.500,0.250,BWEN11_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[12],0.500,0.250,BWEN12_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[12],0.500,0.250,BWEN12_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[13],0.500,0.250,BWEN13_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[13],0.500,0.250,BWEN13_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[14],0.500,0.250,BWEN14_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[14],0.500,0.250,BWEN14_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[15],0.500,0.250,BWEN15_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[15],0.500,0.250,BWEN15_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[16],0.500,0.250,BWEN16_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[16],0.500,0.250,BWEN16_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[17],0.500,0.250,BWEN17_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[17],0.500,0.250,BWEN17_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[18],0.500,0.250,BWEN18_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[18],0.500,0.250,BWEN18_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[19],0.500,0.250,BWEN19_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[19],0.500,0.250,BWEN19_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[20],0.500,0.250,BWEN20_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[20],0.500,0.250,BWEN20_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[21],0.500,0.250,BWEN21_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[21],0.500,0.250,BWEN21_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[22],0.500,0.250,BWEN22_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[22],0.500,0.250,BWEN22_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[23],0.500,0.250,BWEN23_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[23],0.500,0.250,BWEN23_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[24],0.500,0.250,BWEN24_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[24],0.500,0.250,BWEN24_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[25],0.500,0.250,BWEN25_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[25],0.500,0.250,BWEN25_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[26],0.500,0.250,BWEN26_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[26],0.500,0.250,BWEN26_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[27],0.500,0.250,BWEN27_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[27],0.500,0.250,BWEN27_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[28],0.500,0.250,BWEN28_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[28],0.500,0.250,BWEN28_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[29],0.500,0.250,BWEN29_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[29],0.500,0.250,BWEN29_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[30],0.500,0.250,BWEN30_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[30],0.500,0.250,BWEN30_flag);
    $setuphold(posedge CLK &&& CE_flag,posedge BWEN[31],0.500,0.250,BWEN31_flag);
    $setuphold(posedge CLK &&& CE_flag,negedge BWEN[31],0.500,0.250,BWEN31_flag);
    $period(posedge CLK,2.582,CLK_CYC_flag);
    $width(posedge CLK,0.775,0,CLK_H_flag);
    $width(negedge CLK,0.775,0,CLK_L_flag);
    $setuphold(posedge CLK &&& WR0_flag,posedge D[0],0.500,0.250,D0_flag);
    $setuphold(posedge CLK &&& WR0_flag,negedge D[0],0.500,0.250,D0_flag);
    $setuphold(posedge CLK &&& WR1_flag,posedge D[1],0.500,0.250,D1_flag);
    $setuphold(posedge CLK &&& WR1_flag,negedge D[1],0.500,0.250,D1_flag);
    $setuphold(posedge CLK &&& WR2_flag,posedge D[2],0.500,0.250,D2_flag);
    $setuphold(posedge CLK &&& WR2_flag,negedge D[2],0.500,0.250,D2_flag);
    $setuphold(posedge CLK &&& WR3_flag,posedge D[3],0.500,0.250,D3_flag);
    $setuphold(posedge CLK &&& WR3_flag,negedge D[3],0.500,0.250,D3_flag);
    $setuphold(posedge CLK &&& WR4_flag,posedge D[4],0.500,0.250,D4_flag);
    $setuphold(posedge CLK &&& WR4_flag,negedge D[4],0.500,0.250,D4_flag);
    $setuphold(posedge CLK &&& WR5_flag,posedge D[5],0.500,0.250,D5_flag);
    $setuphold(posedge CLK &&& WR5_flag,negedge D[5],0.500,0.250,D5_flag);
    $setuphold(posedge CLK &&& WR6_flag,posedge D[6],0.500,0.250,D6_flag);
    $setuphold(posedge CLK &&& WR6_flag,negedge D[6],0.500,0.250,D6_flag);
    $setuphold(posedge CLK &&& WR7_flag,posedge D[7],0.500,0.250,D7_flag);
    $setuphold(posedge CLK &&& WR7_flag,negedge D[7],0.500,0.250,D7_flag);
    $setuphold(posedge CLK &&& WR8_flag,posedge D[8],0.500,0.250,D8_flag);
    $setuphold(posedge CLK &&& WR8_flag,negedge D[8],0.500,0.250,D8_flag);
    $setuphold(posedge CLK &&& WR9_flag,posedge D[9],0.500,0.250,D9_flag);
    $setuphold(posedge CLK &&& WR9_flag,negedge D[9],0.500,0.250,D9_flag);
    $setuphold(posedge CLK &&& WR10_flag,posedge D[10],0.500,0.250,D10_flag);
    $setuphold(posedge CLK &&& WR10_flag,negedge D[10],0.500,0.250,D10_flag);
    $setuphold(posedge CLK &&& WR11_flag,posedge D[11],0.500,0.250,D11_flag);
    $setuphold(posedge CLK &&& WR11_flag,negedge D[11],0.500,0.250,D11_flag);
    $setuphold(posedge CLK &&& WR12_flag,posedge D[12],0.500,0.250,D12_flag);
    $setuphold(posedge CLK &&& WR12_flag,negedge D[12],0.500,0.250,D12_flag);
    $setuphold(posedge CLK &&& WR13_flag,posedge D[13],0.500,0.250,D13_flag);
    $setuphold(posedge CLK &&& WR13_flag,negedge D[13],0.500,0.250,D13_flag);
    $setuphold(posedge CLK &&& WR14_flag,posedge D[14],0.500,0.250,D14_flag);
    $setuphold(posedge CLK &&& WR14_flag,negedge D[14],0.500,0.250,D14_flag);
    $setuphold(posedge CLK &&& WR15_flag,posedge D[15],0.500,0.250,D15_flag);
    $setuphold(posedge CLK &&& WR15_flag,negedge D[15],0.500,0.250,D15_flag);
    $setuphold(posedge CLK &&& WR16_flag,posedge D[16],0.500,0.250,D16_flag);
    $setuphold(posedge CLK &&& WR16_flag,negedge D[16],0.500,0.250,D16_flag);
    $setuphold(posedge CLK &&& WR17_flag,posedge D[17],0.500,0.250,D17_flag);
    $setuphold(posedge CLK &&& WR17_flag,negedge D[17],0.500,0.250,D17_flag);
    $setuphold(posedge CLK &&& WR18_flag,posedge D[18],0.500,0.250,D18_flag);
    $setuphold(posedge CLK &&& WR18_flag,negedge D[18],0.500,0.250,D18_flag);
    $setuphold(posedge CLK &&& WR19_flag,posedge D[19],0.500,0.250,D19_flag);
    $setuphold(posedge CLK &&& WR19_flag,negedge D[19],0.500,0.250,D19_flag);
    $setuphold(posedge CLK &&& WR20_flag,posedge D[20],0.500,0.250,D20_flag);
    $setuphold(posedge CLK &&& WR20_flag,negedge D[20],0.500,0.250,D20_flag);
    $setuphold(posedge CLK &&& WR21_flag,posedge D[21],0.500,0.250,D21_flag);
    $setuphold(posedge CLK &&& WR21_flag,negedge D[21],0.500,0.250,D21_flag);
    $setuphold(posedge CLK &&& WR22_flag,posedge D[22],0.500,0.250,D22_flag);
    $setuphold(posedge CLK &&& WR22_flag,negedge D[22],0.500,0.250,D22_flag);
    $setuphold(posedge CLK &&& WR23_flag,posedge D[23],0.500,0.250,D23_flag);
    $setuphold(posedge CLK &&& WR23_flag,negedge D[23],0.500,0.250,D23_flag);
    $setuphold(posedge CLK &&& WR24_flag,posedge D[24],0.500,0.250,D24_flag);
    $setuphold(posedge CLK &&& WR24_flag,negedge D[24],0.500,0.250,D24_flag);
    $setuphold(posedge CLK &&& WR25_flag,posedge D[25],0.500,0.250,D25_flag);
    $setuphold(posedge CLK &&& WR25_flag,negedge D[25],0.500,0.250,D25_flag);
    $setuphold(posedge CLK &&& WR26_flag,posedge D[26],0.500,0.250,D26_flag);
    $setuphold(posedge CLK &&& WR26_flag,negedge D[26],0.500,0.250,D26_flag);
    $setuphold(posedge CLK &&& WR27_flag,posedge D[27],0.500,0.250,D27_flag);
    $setuphold(posedge CLK &&& WR27_flag,negedge D[27],0.500,0.250,D27_flag);
    $setuphold(posedge CLK &&& WR28_flag,posedge D[28],0.500,0.250,D28_flag);
    $setuphold(posedge CLK &&& WR28_flag,negedge D[28],0.500,0.250,D28_flag);
    $setuphold(posedge CLK &&& WR29_flag,posedge D[29],0.500,0.250,D29_flag);
    $setuphold(posedge CLK &&& WR29_flag,negedge D[29],0.500,0.250,D29_flag);
    $setuphold(posedge CLK &&& WR30_flag,posedge D[30],0.500,0.250,D30_flag);
    $setuphold(posedge CLK &&& WR30_flag,negedge D[30],0.500,0.250,D30_flag);
    $setuphold(posedge CLK &&& WR31_flag,posedge D[31],0.500,0.250,D31_flag);
    $setuphold(posedge CLK &&& WR31_flag,negedge D[31],0.500,0.250,D31_flag);
*/
  endspecify

endmodule

`endcelldefine
