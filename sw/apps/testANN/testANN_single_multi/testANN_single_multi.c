// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the ¡°License¡±); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an ¡°AS IS¡± BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

#include "ann.h"
#include <utils.h>
#include <bench.h>
#include <stdio.h>
#include "int.h"
#include "event.h"
#include "../testANN_single.h"

volatile int count = 0; 
volatile int op_flag = 0;
volatile int status = 0;
void Init_pro();
void Npu_pro();

int main() {
       
    int_enable();      
	  init_pro(IM_DEPTH0, WEIGTH_DEPTH0, BIAS_DEPTH0, DMA_SRC_ADDR0, DMA_BLOCK_INFO0);   
	  IER |= (1<<16);

 	  while(1){
  		if(count==2)//run application number
  		break; 
  		if(op_flag == 1){   
  				 op_flag = 0;  				
             npu_pro(NPU_DATAIN_DEPTH0, NPU_DATAOUT_DEPTH0, NPU_DMA_SRC_ADDR0,  NPU_DMA_DST_ADDR0, NPU_DMA_BLOCK_INFO0 );    
		      
  				} 
  			else if(op_flag==2){
  					op_flag = 0;
  					IER |= (1<<16); 
  				  npu_pro(NPU_DATAIN_DEPTH0, NPU_DATAOUT_DEPTH0, NPU_DMA_SRC_ADDR0,  NPU_DMA_DST_ADDR0, NPU_DMA_BLOCK_INFO0 );    
  			}
 	  }
 	    
 	  for(int i=0; i < count; i++){
 	 	
 	   //if(i==0){
 	   	int *j=(volatile int*)NPU_DMA_DST_ADDR0; 	   	
 	   	for(int k=0; k < NPU_DATAOUT_DEPTH0; k= k+1){
 	   		printf("%x\n", *(j+k));
 	   		}
 	  // }
 	  // else if(i==1){	   	    
 	  // 	int *j=(volatile int*)NPU_DMA_DST_ADDR1;
 	  // 	for(int k=0; k < NPU_DATAOUT_DEPTH1; k= k+1){
 	  // 		printf("%x\n", *(j+k));
 	  // 		}
 	  // 	}
 	 	
 	 	}
    return 0;
}

void ISR_ANN_INT (void){ 
	int a=0;
	a = *(volatile int*)(ANN_REG_STATUS_END);
  
	if(a==1){
			clear_int () ; 
			ICP |= (1<<16); 
			int_disable();  
	    op_flag = 1;
	 		printf("Now init_ram is complete\n");
		  int_enable();
		  //count++;   
			IER |= (1<<16);   				
		}
	else if(a==2){
			clear_int () ; 
			ICP |= (1<<16);
			op_flag = 2; 			
			count++; 			   
			printf("Now the %dth computing is complete\n",count);   			
		}
}	
