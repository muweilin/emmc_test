// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the ?°„License?°¿); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an ?°„AS IS?°¿ BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

#include "ann.h"
#include <utils.h>
#include <bench.h>
#include <stdio.h>
#include "int.h"
#include "uart.h"
#include "event.h"
#include "../testANN_single.h"
#define  NPU_DMA_CHK_ADDR0  0x33000000

volatile int count = 0;

int main() {
	    
      uart_set_cfg(0,49);
      uart_send("start..\n",8);
      uart_wait_tx_done();

      int * p =(volatile int *)0x30020000;
      printf("input data is %0x\n", *p );
      
      int tmp_input;
      for(int m=0;m<17;){
        tmp_input = *(p+m);
        m=m+1;
       printf("%08x_%08x\n",(p+m),tmp_input);
      }

   
        int_enable();      
     	  init_pro(IM_DEPTH0, WEIGTH_DEPTH0, BIAS_DEPTH0, DMA_SRC_ADDR0, DMA_BLOCK_INFO0);   
     	  IER |= (1<<16);      
      
      //  Return_init_params();      

          while(1) {
       		if(count==1)
       		break;
      	  }
     
   
    //  Return_pro_params();
 	    int tmp_value_RST;
      int tmp_value_CHK; 
 	   	int *j=(volatile int*)NPU_DMA_DST_ADDR0; 	
      int *i=(volatile int*)NPU_DMA_CHK_ADDR0; 
      int  ok=0; 	
 	   	for(int k=0; k < NPU_DATAOUT_DEPTH0; k= k+1){
 	   //     for(int k=0; k < 6; k= k+1){
          tmp_value_RST = *(j+k);
          tmp_value_CHK = *(i+k);
  
 	   		  if(tmp_value_RST != tmp_value_CHK)
 	   			   printf("error line is %0d expect 0X%0x ,but result is 0X%08x addr is 0x%0x\n ",k, tmp_value_CHK,tmp_value_RST,(j+k));
 	   		  else
          //  printf("Test OK........\n");
 	   		   ok++;
       
     // }
    }
 	     printf("ok num is %d\n",ok );      
     
      if(ok==NPU_DATAOUT_DEPTH0){
      //  printf("Test OK........\n");
       uart_send("Test OK..\n",10);
       uart_wait_tx_done();
       }
      else
      {
       // printf("Test not OK!!!!!!!!!\n");
        uart_send("Test not OK..\n",10);
        uart_wait_tx_done();  
      }
      return 0;
          
    
}

void ISR_ANN_INT (void){ 
	
  int a=0;
  int npu_on=0;
	//int delay = 200;
	a    = *(volatile int*)(ANN_REG_STATUS_END);

  clear_int();
  ICP |= (1<<16);
  
  printf(" finish_status is %d\n",a );
  //npu_on = *(volatile int*)(ANN_REG_STATUS_RUN);
  //printf(" npu_run status is %d\n",npu_on );
    
  if(a==1){		 
     //  clear_int () ;
       uart_send("Now init_ram is complete\n",25);
       uart_wait_tx_done();
      // count++;
       npu_pro(NPU_DATAIN_DEPTH0, NPU_DATAOUT_DEPTH0, NPU_DMA_SRC_ADDR0,  NPU_DMA_DST_ADDR0, NPU_DMA_BLOCK_INFO0 );    
      // uart_send("Now npu start.\n",15);
      // uart_wait_tx_done();

      // npu_on = *(volatile int*)(ANN_REG_STATUS_RUN);
      // if(npu_on == 2){
      //   uart_send("npu running\n",12);
      //   uart_wait_tx_done();
      //  }

    //   Return_pro_params();
       
  	}
  	else if(a==2){ 
   	//	clear_int () ;	
  		uart_send("Now computing is complete\n",26);
      uart_wait_tx_done();
  		count++; 
  	}
}	
