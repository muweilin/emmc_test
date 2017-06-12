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
volatile int status = 0;

int main() {
       
    int_enable();      
	  init_pro(IM_DEPTH0, WEIGTH_DEPTH0, BIAS_DEPTH0, DMA_SRC_ADDR0, DMA_BLOCK_INFO0);   
	  IER |= (1<<16);

 	  while(1) {
  		if(count==1)
  		break;
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
       printf("Now init_ram is complete\n");
       npu_pro(NPU_DATAIN_DEPTH0, NPU_DATAOUT_DEPTH0, NPU_DMA_SRC_ADDR0,  NPU_DMA_DST_ADDR0, NPU_DMA_BLOCK_INFO0 );    
  	   int_enable();  
  		 IER |= (1<<16);   
  			// count++;
  	}
  	else if(a==2){
  		clear_int () ; 
  		ICP |= (1<<16);	
  		printf("Now computing is complete\n");	  
  		count++; 
  	}
}	
