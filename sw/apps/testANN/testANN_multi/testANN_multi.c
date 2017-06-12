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
#include "testANN_multi.h"

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
  		if(count==8)//run application number
  		break; 
  		if(op_flag == 1){   
  				 op_flag = 0;
  				 if(count == 0) 
             npu_pro(NPU_DATAIN_DEPTH0, NPU_DATAOUT_DEPTH0, NPU_DMA_SRC_ADDR0,  NPU_DMA_DST_ADDR0, NPU_DMA_BLOCK_INFO0 );    
		       else if(count == 1)
		       	 npu_pro(NPU_DATAIN_DEPTH1, NPU_DATAOUT_DEPTH1, NPU_DMA_SRC_ADDR1,  NPU_DMA_DST_ADDR1, NPU_DMA_BLOCK_INFO1 );
		       else if(count == 2)
			       npu_pro(NPU_DATAIN_DEPTH2, NPU_DATAOUT_DEPTH2, NPU_DMA_SRC_ADDR2,  NPU_DMA_DST_ADDR2, NPU_DMA_BLOCK_INFO2 );
		       else if(count == 3)
			       npu_pro(NPU_DATAIN_DEPTH3, NPU_DATAOUT_DEPTH3, NPU_DMA_SRC_ADDR3,  NPU_DMA_DST_ADDR3, NPU_DMA_BLOCK_INFO3 );
		       else if(count == 4)
			       npu_pro(NPU_DATAIN_DEPTH4, NPU_DATAOUT_DEPTH4, NPU_DMA_SRC_ADDR4,  NPU_DMA_DST_ADDR4, NPU_DMA_BLOCK_INFO4 );
		       else if(count == 5)
			       npu_pro(NPU_DATAIN_DEPTH5, NPU_DATAOUT_DEPTH5, NPU_DMA_SRC_ADDR5,  NPU_DMA_DST_ADDR5, NPU_DMA_BLOCK_INFO5 );
		       else if(count == 6)
			       npu_pro(NPU_DATAIN_DEPTH6, NPU_DATAOUT_DEPTH6, NPU_DMA_SRC_ADDR6,  NPU_DMA_DST_ADDR6, NPU_DMA_BLOCK_INFO6 );
			       else if(count == 7)
			       npu_pro(NPU_DATAIN_DEPTH7, NPU_DATAOUT_DEPTH7, NPU_DMA_SRC_ADDR7,  NPU_DMA_DST_ADDR7, NPU_DMA_BLOCK_INFO7 );
		      // else if(count == 8)
			    //   npu_pro(NPU_DATAIN_DEPTH8, NPU_DATAOUT_DEPTH8, NPU_DMA_SRC_ADDR8,  NPU_DMA_DST_ADDR8, NPU_DMA_BLOCK_INFO8 ); 
  				} 
  			else if(op_flag==2){
  					op_flag = 0;
  					IER |= (1<<16); 
  				 if(count == 1)     
		         init_pro(IM_DEPTH1, WEIGTH_DEPTH1, BIAS_DEPTH1, DMA_SRC_ADDR1, DMA_BLOCK_INFO1);
		       else if(count == 2)
		       	init_pro(IM_DEPTH2, WEIGTH_DEPTH2, BIAS_DEPTH2, DMA_SRC_ADDR2, DMA_BLOCK_INFO2);
		       else if(count == 3)
		       	init_pro(IM_DEPTH3, WEIGTH_DEPTH3, BIAS_DEPTH3, DMA_SRC_ADDR3, DMA_BLOCK_INFO3);
		       else if(count == 4)
		       	init_pro(IM_DEPTH4, WEIGTH_DEPTH4, BIAS_DEPTH4, DMA_SRC_ADDR4, DMA_BLOCK_INFO4);
		       else if(count == 5)
		       	init_pro(IM_DEPTH5, WEIGTH_DEPTH5, BIAS_DEPTH5, DMA_SRC_ADDR5, DMA_BLOCK_INFO5);
		       else if(count == 6)
		       	init_pro(IM_DEPTH6, WEIGTH_DEPTH6, BIAS_DEPTH6, DMA_SRC_ADDR6, DMA_BLOCK_INFO6);
		       else if(count == 7)
		       	init_pro(IM_DEPTH7, WEIGTH_DEPTH7, BIAS_DEPTH7, DMA_SRC_ADDR7, DMA_BLOCK_INFO7);
		      // else if(count == 8)
		       	//init_pro(IM_DEPTH8, WEIGTH_DEPTH8, BIAS_DEPTH8, DMA_SRC_ADDR8, DMA_BLOCK_INFO8);
  			}
 	  }
 	    
 	 // for(int i=0; i < count; i++){
 	 //	
 	 //  if(i==0){
 	 //  	int *j=(volatile int*)NPU_DMA_DST_ADDR0; 	   	
 	 //  	for(int k=0; k < NPU_DATAOUT_DEPTH0; k= k+1){
 	 //  		printf("%x\n", *(j+k));
 	 //  		}
 	 //  }
 	 //  else if(i==1){	   	    
 	 //  	int *j=(volatile int*)NPU_DMA_DST_ADDR1;
 	 //  	for(int k=0; k < NPU_DATAOUT_DEPTH1; k= k+1){
 	 //  		printf("%x\n", *(j+k));
 	 //  		}
 	 //  	}
 	 //	
 	 //	}
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
