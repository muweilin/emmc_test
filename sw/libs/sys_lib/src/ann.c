#include <ann.h>

void init_pro(int im_depth, 
              int weight_depth, 
              int bias_depth, 
              int DMA_src_addr, 
              //int block_count, 
              int block_size)
{
	int ready = 1;
	ready = *(volatile int *) (ANN_REG_STATUS_RUN);
	if (!(ready & 0x03)) // not run ot init
	{
  		 *(volatile int*) (ANN_REG_IM_DEPTH      )  = im_depth;
  	 	 *(volatile int*) (ANN_REG_WEIGTH_DEPTH  )  = weight_depth;
   		 *(volatile int*) (ANN_REG_BIAS_DEPTH    )  = bias_depth;
   		 *(volatile int*) (ANN_REG_DMA_SRC_ADDR  )  = DMA_src_addr;
   		 *(volatile int*) (ANN_REG_DMA_BLOCK_INFO)  = block_size; 
   		 *(volatile int*) (ANN_REG_SIG_DEPTH     )  = 0x200;  
  		 // *(volatile int*) (ANN_REG_DMA_SRC_ADDR) = DMA_src_addr;
	   	 *(volatile int*) (ANN_REG_CTR) = 0x06 ;
	}
}

void npu_pro(int npu_datain_depth, 
             int npu_detaout_depth, 
             int DMA_src_addr, 
             int DMA_dst_addr, 
            
             int block_size )
{
	int ready = 1;
	ready = *(volatile int *) (ANN_REG_STATUS_RUN);
	if (!(ready & 0x03)) // not run ot init
	{
   		 *(volatile int*) (ANN_REG_NPU_DATAIN_DEPTH )  = npu_datain_depth;
   		 *(volatile int*) (ANN_REG_NPU_DATAOUT_DEPTH)  = npu_detaout_depth; 
   		 *(volatile int*) (ANN_REG_DMA_SRC_ADDR     )  = DMA_src_addr    ;
   		 *(volatile int*) (ANN_REG_DMA_DST_ADDR     )  = DMA_dst_addr    ;    
   		 *(volatile int*) (ANN_REG_DMA_BLOCK_INFO   )  =  block_size;
   		 *(volatile int*) (ANN_REG_CTR) = 0x05;      
	}
}

void clear_int ()
{
	  *(volatile int*) (ANN_REG_CTR) = 0x08;
}

void stop_en()
{
	  *(volatile int*) (ANN_REG_CTR) = STOP_EN; 
}
