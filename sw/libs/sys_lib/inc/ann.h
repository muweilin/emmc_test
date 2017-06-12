#ifndef _ANN_H_
#define _ANN_H_

#include <ppu.h>

#define INIT_START  0x06
#define NPU_START   0x05 
#define CLEAR_INT   0x08
#define STOP_EN     0x10


#define ANN_REG_CTR               ANN_BASE_ADDR
#define ANN_REG_INT_EN            ( ANN_BASE_ADDR + 0x04 )
#define ANN_REG_DMA_SRC_ADDR      ( ANN_BASE_ADDR + 0x08 )
#define ANN_REG_DMA_DST_ADDR      ( ANN_BASE_ADDR + 0x0C )
#define ANN_REG_DMA_BLOCK_INFO    ( ANN_BASE_ADDR + 0x10 )
#define ANN_REG_WEIGTH_DEPTH      ( ANN_BASE_ADDR + 0x14 )
#define ANN_REG_BIAS_DEPTH        ( ANN_BASE_ADDR + 0x18 )
#define ANN_REG_IM_DEPTH          ( ANN_BASE_ADDR + 0x1C )
#define ANN_REG_SIG_DEPTH         ( ANN_BASE_ADDR + 0x20 )
#define ANN_REG_NPU_DATAIN_DEPTH  ( ANN_BASE_ADDR + 0x24 )
#define ANN_REG_NPU_DATAOUT_DEPTH ( ANN_BASE_ADDR + 0x28 )
#define ANN_REG_STATUS_END        ( ANN_BASE_ADDR + 0x2C )
#define ANN_REG_STATUS_RUN        ( ANN_BASE_ADDR + 0x30 )

#define ANN_CTR 	             REG(ANN_REG_CTR)
#define ANN_INT_EN             REG(ANN_REG_INT_EN           )
#define ANN_DMA_SRC_ADDR       REG(ANN_REG_DMA_SRC_ADDR     )
#define ANN_DMA_DST_ADDR       REG(ANN_REG_DMA_DST_ADDR     )
#define ANN_DMA_BLOCK_INFO     REG(ANN_REG_DMA_BLOCK_INFO   )
#define ANN_WEIGTH_DEPTH       REG(ANN_REG_WEIGTH_DEPTH     )
#define ANN_BIAS_DEPTH         REG(ANN_REG_BIAS_DEPTH       )
#define ANN_IM_DEPTH           REG(ANN_REG_IM_DEPTH         )
#define ANN_SIG_DEPTH          REG(ANN_REG_SIG_DEPTH        )
#define ANN_NPU_DATAIN_DEPTH   REG(ANN_REG_NPU_DATAIN_DEPTH )
#define ANN_NPU_DATAOUT_DEPTH  REG(ANN_REG_NPU_DATAOUT_DEPTH)
#define ANN_STATUS_END         REG(ANN_REG_STATUS_END       )
#define ANN_STATUS_RUN         REG(ANN_REG_STATUS_RUN       )

void init_pro(int im_depth, int weight_depth, int bias_depth, int DMA_src_addr,  int block_size);

void npu_pro(int npu_datain_depth, int npu_detain_depth, int DMA_src_addr, int DMA_dst_addr,  int block_size );

void clear_int ();

void stop_en();

#endif