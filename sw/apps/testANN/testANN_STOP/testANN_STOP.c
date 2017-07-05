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
void Return_params();
void Npu_pro();
void Init_pro();

volatile int count = 0;
volatile int status = 0;
int  c = 0;
volatile int weight_depth = 0;
volatile int bia_depth = 0;
volatile int im_depth = 0;
volatile int sig_depth = 0;
volatile int data_input_depth = 0;
volatile int data_output_depth = 0;
volatile int dst_addr = 0;

void Init_pro()
{

//1      init_pro(80, 136, 132, 0x20010000, 0x80, 0x8);
//2oks   init_pro(26, 2048, 24, 0x20010000, 0x80, 0x8);
//3oks   init_pro(10, 2048, 12, 0x20010000, 0x80, 0x8);
//4oks   init_pro(10, 2048, 12, 0x20010000, 0x80, 0x8);  //2048
//5okss	 init_pro(56, 2048, 124, 0x20010000, 0x80, 0x8);   
//6   	 init_pro(80, 2048, 132, 0x20010000, 0x80, 0x8);   //2048
//7oks  init_pro(18, 16, 16, 0x20010000, 0x80, 0x8);
 //       init_pro(800, 2048, 1480, 0x20010000, 0x80, 0x8);
          init_pro(IM_DEPTH0, WEIGTH_DEPTH0, BIAS_DEPTH0, DMA_SRC_ADDR0, DMA_BLOCK_INFO0);
}

void Npu_pro()
{

//1    		 npu_pro(192000, 12000, 0x20020000,  0x20100000, 0x80,  0x8 );
//2oks       npu_pro(6148, 1024, 0x20020000,  0x200e0000, 0x80,  0x8 );
//3oks    	 npu_pro(1144, 2288, 0x20020000,  0x200e0000, 0x80,  0x8 );
//4oks	     npu_pro(1000, 1000, 0x20020000,  0x200e0000, 0x80,  0x8 );
//5okss		 npu_pro(45000, 5000, 0x20020000,  0x200e0000, 0x80,  0x8 );
//6ok 		 npu_pro(192000, 12000, 0x20020000,  0x200e0000, 0x80,  0x8 );
//7okss 	 npu_pro(230400, 38400, 0x20020000,  0x201e0000, 0x80,  0x8 );
//       	 npu_pro(392000, 1000, 0x20020000,  0x20f00000, 0x80,  0x8 );
    	     npu_pro(NPU_DATAIN_DEPTH0, NPU_DATAOUT_DEPTH0, NPU_DMA_SRC_ADDR0,  NPU_DMA_DST_ADDR0, NPU_DMA_BLOCK_INFO0 );
}

void Return_params()
{
   weight_depth = *(volatile int*) (ANN_REG_WEIGTH_DEPTH);
   bia_depth = *(volatile int*)(ANN_REG_BIAS_DEPTH);
   sig_depth = *(volatile int*)(ANN_REG_SIG_DEPTH);
   im_depth = *(volatile int*)(ANN_REG_IM_DEPTH);
   data_input_depth = *(volatile int *)(ANN_REG_NPU_DATAIN_DEPTH);
   data_output_depth = *(volatile int *)(ANN_REG_NPU_DATAOUT_DEPTH);

    printf("weight_depth = %d\n", weight_depth);
    printf("bia_depth = %d\n", bia_depth);
    printf("sig_depth = %d\n", sig_depth);
    printf("im_depth = %d\n", im_depth);
    printf("data_input_depth = %d\n", data_input_depth);
    printf("data_output_depth = %d\n", data_output_depth);

	 dst_addr = *(volatile *)(ANN_REG_DMA_DST_ADDR);
	 printf("Dst_addr = %x\n", dst_addr);

}

int main() {
       int_enable();
     
	   Init_pro();  // Init_pro .....

	   status = *(volatile int*)(ANN_REG_STATUS_RUN);
	   if (status & 0x01)   //init is running
	   {
		   printf("run_status = %x\n", status);
		   printf("init_pro is running\n");

		   *(volatile int*)(ANN_REG_CTR) |= (1<<4);  //stop init_pro
	       
		   status = *(volatile int*)(ANN_REG_STATUS_RUN);
		   printf("run_status = %x\n", status);

	       status = *(volatile int*)(ANN_REG_CTR);
		   printf("ctr_status = %x\n", status);
	   }

	   Init_pro();  // Init_pro .....

       status = *(volatile int*)(ANN_REG_CTR);
	   printf("ctr_status = %x\n", status);
       status = *(volatile int*)(ANN_REG_STATUS_RUN);
       printf("run_status = %x\n", status);
	  
	   IER |= (1<<16);

 	    while(1)  	    
            {
  			if(count==2)
  			break;
 	    }

   return 0;
}

void ISR_ANN_INT (void){ 
   
	int delay = 200;
	int a=0;
	a = *(volatile int*)(ANN_REG_STATUS_END);
   //clear_int () ; 
   //count++;
   //ICP |= (1<<16);
   c++;
   
	if(a==1)
	{
			 clear_int () ; 
			 ICP |= (1<<16); 
			 int_disable();  
			 
			 Npu_pro(); //Npu pro .....
		   
             Return_params();
	  		 status = *(volatile int*)(ANN_REG_STATUS_RUN);
	  		 if ((status & 0x02) && (c == 1))   // npu is running
	  		 {
		   		printf("npu__run_status = %x\n", status);
		   		printf("npu_pro is running\n");
	
				while(delay--);

				*(volatile int*)(ANN_REG_CTR) |= (1<<4);
	
				status = *(volatile int*)(ANN_REG_STATUS_RUN);
		   		printf("run_status = %x\n", status);
				status = *(volatile int*)(ANN_REG_CTR);
		  		printf("ctr_status = %x\n", status);
                Return_params();
		   		printf("npu_pro is stop\n");

				a = 0;
				c++;
				
				Init_pro();// Init pro .....
		        
				IER |= (1<<16);   
				Return_params();
	  		 }
			 else 
			 {
				 dst_addr = *(volatile *)(ANN_REG_DMA_DST_ADDR);
				 printf("Dst_addr = %x\n", dst_addr);

	        	 int_enable();  
				 IER |= (1<<16);   
			 	 count++;
			 }
	}
	else if(a==2)  // npu over
	{
		clear_int () ; 
		ICP |= (1<<16);
		count++; 
	}
}	

