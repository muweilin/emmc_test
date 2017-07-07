// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the ?°„License?°¿); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an ?°„AS IS?°¿ BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

//#include "ann.h"
//#include <utils.h>
//#include <bench.h>
#include <stdio.h>
//#include "int.h"
//#include "event.h"
#include "../testANN_single.h"

//volatile int count = 0;
//volatile int status = 0;
// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the ?°„License?°¿); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an ?°„AS IS?°¿ BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


#include "para_inc/meminit_insn.h"
#include "para_inc/sigmoid.h"
#include "para_inc/meminit_offset.h"  
#include "para_inc/meminit_w00.h"
#include "para_inc/meminit_w01.h"
#include "para_inc/meminit_w02.h"
#include "para_inc/meminit_w03.h"
#include "para_inc/meminit_w04.h"
#include "para_inc/meminit_w05.h"
#include "para_inc/meminit_w06.h"
#include "para_inc/meminit_w07.h"   
//#include "para_inc/meminit_input_vectors.mif"
#include "para_inc/meminit_output_vectors.h"

//#define ext_ram_addr 0x42000000
#define  NPU_DMA_CHK_ADDR0  0x33000000
#define  MAX        10
//volatile int count = 0;
//volatile int status = 0; 
//int aaa[2048];

void array_convert(int *array_in, int *array_out, int length_array)
{
	    
      int length_array_real; 
      int tmp; 
      int i,j;   
      length_array_real = length_array/4;
      //printf("the string is 0x%x\n",length_array_real);   
      for(i=0; i<length_array_real; i++)
      { 
      	array_out[i] = 0;
      	for(j=3; j>=0; j--){ 
      		
      		tmp = array_out[i]<<8; 
      		array_out[i] = tmp + array_in[i*4+j]; 
      	  
      	 }     
      	 //printf("the string is %d 0x%x\n",i,array_out[i]);
      	}
	
	}
	
void main()
{	      
       	
       //FILE* stream1 = fopen("stimuli1.txt", "w");
        FILE* stream1 = fopen("../../../build/apps/testANN/testANN_single/slm_files/spi_stim.txt", "a+"); 
        
        FILE* stream2 = fopen("para_inc/meminit_input_vectors.txt","r"); 
       // FILE* stream3 = fopen("/home/anny/datacheck/alldata.txt","w");  
        

       	int length_array_weight_tmp;
       	length_array_weight_tmp = sizeof(w00)/sizeof(w00[0]);
       	
       	int length_array_offset_tmp;
       	length_array_offset_tmp = sizeof(offset)/sizeof(offset[0]);
       	
       	int length_array_sigmoid_tmp;
       	length_array_sigmoid_tmp = sizeof(sigmoid)/sizeof(sigmoid[0]);
       	
       	int length_array_insn;
       	length_array_insn = sizeof(insn)/sizeof(insn[0]);
       	
       
       	int length_array_sigmoid;
       	length_array_sigmoid = length_array_sigmoid_tmp/4;
       	
       	
       	int w00_hex[length_array_weight];
       	int w01_hex[length_array_weight];
       	int w02_hex[length_array_weight];
       	int w03_hex[length_array_weight];
       	int w04_hex[length_array_weight];
       	int w05_hex[length_array_weight];
       	int w06_hex[length_array_weight];
       	int w07_hex[length_array_weight]; 
       	int offset_hex[length_array_offset]; 
       	int sigmoid_hex[128];
       
/////////////////////////////////////////////////////	 
	     int insn_value;	
	     int aaa[6000]; 
	     // extern insn; 
	     // int *q = (volatile int*)DMA_SRC_ADDR0;
       int *q=aaa; 
       int addr=DMA_SRC_ADDR0;
	      int i,j;
       for( i=0; i< length_array_insn; i++)
       {
       		insn_value = strtol(insn[i], NULL, 2); 
       		*(q+i) =  insn_value;  
       		printf("the insn is %x\n",*(q+i));
          fprintf(stream1, "%08x_%08x\n", addr,insn_value);
        //  fprintf(stream3, "%08x_%08x\n", addr,insn_value);   
         // printf("the insn is 2\n");
          addr+=4;
       	}
////////////////////////////////////////////////////////       	      	
       	       	
        	array_convert(w00, w00_hex,length_array_weight_tmp);
        	array_convert(w01, w01_hex,length_array_weight_tmp);
        	array_convert(w02, w02_hex,length_array_weight_tmp);
        	array_convert(w03, w03_hex,length_array_weight_tmp);
        	array_convert(w04, w04_hex,length_array_weight_tmp);  
        	array_convert(w05, w05_hex,length_array_weight_tmp);
        	array_convert(w06, w06_hex,length_array_weight_tmp);
        	array_convert(w07, w07_hex,length_array_weight_tmp);
          array_convert(offset, offset_hex,length_array_offset_tmp);
          array_convert(sigmoid, sigmoid_hex,length_array_sigmoid_tmp);
       
  
       	j=0;
       	for(; i< length_array_insn + length_array_weight; i++)
       {
       		*(q+i) =  w00_hex[j];        
       		fprintf(stream1, "%08x_%08x\n", addr,w00_hex[j]);
        //  fprintf(stream3, "%08x_%08x\n", addr,w00_hex[j]);
          addr=addr+4;
       		printf("the w00 %08x_%08x\n", addr,w00_hex[j]);

       		j++; 
       	}
       	j=0;
       	for(; i< length_array_insn + 2*length_array_weight; i++)
       {
       		*(q+i) =  w01_hex[j]; 
          fprintf(stream1, "%08x_%08x\n", addr,w01_hex[j]);
       //   fprintf(stream3, "%08x_%08x\n", addr,w01_hex[j]);
          addr=addr+4; 
       		printf("the w01  %08x_%x\n",addr,w01_hex[j]);
       		j++;
       	}
       	j=0;
       	for(; i< length_array_insn + 3*length_array_weight; i++)
       {
       		*(q+i) =  w02_hex[j]; 
          fprintf(stream1, "%08x_%08x\n", addr,w02_hex[j]);
         // fprintf(stream3, "%08x_%08x\n", addr,w02_hex[j]);
          addr=addr+4;       		
       		printf("the w02 is %x\n",w02_hex[j]); 
       		j++;    
       	}
       	j=0;
       	for(; i< length_array_insn + 4*length_array_weight; i++)
       {
       		*(q+i) =  w03_hex[j]; 
       	fprintf(stream1, "%08x_%08x\n", addr,w03_hex[j]);
     //   fprintf(stream3, "%08x_%08x\n", addr,w03_hex[j]);
          addr=addr+4;
       	printf("the w03 is %x\n",w03_hex[j]);
       		j++;   
       	}
       	j=0;
       	for(; i< length_array_insn + 5*length_array_weight; i++)
       {
       		*(q+i) =  w04_hex[j]; 
       	fprintf(stream1, "%08x_%08x\n", addr,w04_hex[j]);
     //   fprintf(stream3, "%08x_%08x\n", addr,w04_hex[j]);
          addr=addr+4;	
       //	printf("the string is %x\n",w04_hex[j]);  
       		j++; 
       	}
       	j=0;
       	for(; i< length_array_insn + 6*length_array_weight; i++)
       {
       		*(q+i) =  w05_hex[j]; 
       	fprintf(stream1, "%08x_%08x\n", addr,w05_hex[j]);
     //   fprintf(stream3, "%08x_%08x\n", addr,w05_hex[j]);
          addr=addr+4;
       //		printf("the string is %x\n",w05_hex[j]); 
       		j++; 
       	}
       	j=0;
       	for(; i< length_array_insn + 7*length_array_weight; i++)
       {
       		*(q+i) =  w06_hex[j]; 
       	fprintf(stream1, "%08x_%08x\n", addr,w06_hex[j]);
      //  fprintf(stream3, "%08x_%08x\n", addr,w06_hex[j]);
          addr=addr+4;	
       	//	printf("the string is %x\n",w06_hex[j]); 
       		j++;  
       	}
       	j=0;
       	for(; i< length_array_insn + 8*length_array_weight; i++)
       {
       		*(q+i) =  w07_hex[j]; 
       	fprintf(stream1, "%08x_%08x\n", addr,w07_hex[j]);
       // fprintf(stream3, "%08x_%08x\n", addr,w07_hex[j]);
          addr=addr+4;
       	//	printf("the string is %x\n",w07_hex[j]);  
       		j++; 
       	}
       	j=0;
       	for(; i< length_array_insn + 8*length_array_weight + length_array_offset; i++)
       {
       		*(q+i) =  offset_hex[j];
          fprintf(stream1, "%08x_%08x\n", addr,offset_hex[j]);
         // fprintf(stream3, "%08x_%08x\n", addr,offset_hex[j]);
          addr=addr+4;
       	//	printf("the string is %x\n",offset_hex[j]);  
       		j++; 
       	//	printf("the string is %d\n",insn_value);
       	}
       	j=0;
       	for(; i< length_array_insn + 8*length_array_weight + length_array_offset + length_array_sigmoid; i++)
       {
       		*(q+i) =  sigmoid_hex[j];
         fprintf(stream1, "%08x_%08x\n",addr,sigmoid_hex[j]);
        // fprintf(stream3, "%08x_%08x\n",addr,sigmoid_hex[j]);
          addr=addr+4;
       	//	printf("the string is %x\n",sigmoid_hex[j]); 
       		j++; 
       	}
      j=0; 

        char words[MAX];
        int cnt_tmp=0;
         while(fscanf(stream2,"%s",words)==1)
         {
            if(cnt_tmp < NPU_DATAIN_DEPTH0)
            {
              fprintf(stream1, "%s\n",words);
            //  fprintf(stream3, "%s\n",words);
            }
          else break;
          cnt_tmp++;
         }

       
     int check_addr=NPU_DMA_CHK_ADDR0;
     int k;
     for( k=0;k<NPU_DATAOUT_DEPTH0;k++) 
     {
      fprintf(stream1, "%08x_%08x\n", check_addr,out_data[k]);
    //  fprintf(stream3, "%08x_%08x\n", check_addr,out_data[k]);
      check_addr+=4; 
     }
     
     fclose(stream1);
     fclose(stream2); 
   //  fclose(stream3);  	
	
	}	


