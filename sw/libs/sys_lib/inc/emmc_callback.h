/* ===================================================================================
 * Copyright (c) <2007-2009> Synopsys, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of 
 * this software annotated with this license and associated documentation files 
 * (the "Software"), to deal in the Software without restriction, including without 
 * limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit persons to whom the Software is 
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all 
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
 * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * =================================================================================== */

/** \file  
 *
 *
 *
 *
 *
 * \internal
 * 			REVISION HISTORY
 * ------------------------------------------------------------
 *
 * <user>	<date>		<comments>
 *
 *
 */


#include <string.h>
typedef unsigned int  u32;
typedef signed int  s32;
typedef unsigned char u8;
typedef unsigned long dma_addr_t;
typedef unsigned short  u16;

typedef int boolean ;
typedef unsigned int int_register ;

typedef void (*emmc_postproc_callback)(void *,u32 *) ;
typedef u32 (*emmc_term_function)(u8* buffer, u32 bytes_read);
typedef void* (*emmc_copy_function)(u32 *,u32 *,u32);

typedef void (*emmc_postproc_callback)(void *,u32 *) ;
typedef void (*emmc_preproc_callback)(u32,u32,u32*,u32*);
emmc_postproc_callback emmc_get_post_callback(u32);
emmc_preproc_callback emmc_get_pre_callback(u32);

#ifndef SYNOP_CALLBACKS_H
#define SYNOP_CALLBACKS_H 1

/* Status register bits */
#define STATUS_DAT_BUSY_BIT	    0x00000200

#define R4_RESP_ERROR_BIT	           0x00010000
#define CMD39_WRITE_REG		           0x00008000

/* Internal DMAC Status Register IDSTS Bit Definitions
 * Internal DMAC Interrupt Enable Register Bit Definitions */
#define  IDMAC_AI			        0x00000200   // Abnormal Interrupt Summary Enable/ Status                                       9
#define  IDMAC_NI    		   	        0x00000100   // Normal Interrupt Summary Enable/ Status                                         8
#define  IDMAC_CES				0x00000020   // Card Error Summary Interrupt Enable/ status                                     5
#define  IDMAC_DU				0x00000010   // Descriptor Unavailabe Interrupt Enable /Status                                  4
#define  IDMAC_FBE				0x00000004   // Fata Bus Error Enable/ Status                                                   2
#define  IDMAC_RI				0x00000002   // Rx Interrupt Enable/ Status                                                     1
#define  IDMAC_TI				0x00000001   // Tx Interrupt Enable/ Status                                                     0

/* Definitions for cmd status */
#define TSK_STAT_STARTED	1
#define TSK_STATE_READRESP	2
#define TSK_STATE_READDAT	3
#define TSK_STATE_WRITEDAT	4
#define TSK_COMMAND_DONE	5
#define TSK_COMMAND_ABORTING	6
#define TSK_STATE_POLLD   	7


#define TSK_STAT_ABSENT		0


#define DATA_RECV	0
#define DATA_SEND	1

/* Standard MMC commands (3.1)           type  argument     response */
/* class 1 */
#define CMD0    0   /* MMC_GO_IDLE_STATE        bc                    */
#define CMD1    1   /* MMC_SEND_OP_COND         bcr  [31:0]  OCR  R3  */
#define CMD2    2   /* MMC_ALL_SEND_CID         bcr               R2  */
#define CMD3    3   /* MMC_SET_RELATIVE_ADDR    ac   [31:16] RCA  R1  */
#define CMD4    4   /* MMC_SET_DSR              bc   [31:16] RCA      */

#define CMD5    5   /* SDIO_SEND_OCR            ??   ??               */

#define CMD6    6   /* HSMMC_SWITCH             ac                R1  */
                    /* For ACMD6:SET_BUS_WIDTH  ??   ??               */

#define CMD7    7   /* MMC_SELECT_CARD          ac   [31:16] RCA  R1  */
#define CMD8    8   /* HSMMC_SEND_EXT_CSD       adtc [31:16] RCA  R1  */
#define CMD9    9   /* MMC_SEND_CSD             ac   [31:16] RCA  R2  */
#define CMD10   10  /* MMC_SEND_CID             ac   [31:16] RCA  R2  */
#define CMD11   11  /* MMC_READ_DAT_UNTIL_STOP  adtc [31:0]  dadr R1  */
#define CMD12   12  /* MMC_STOP_TRANSMISSION    ac                R1b */
#define CMD13   13  /* MMC_SEND_STATUS          ac   [31:16] RCA  R1  */
#define ACMD13  13  /* SD_STATUS                ac   [31:2] Stuff,
                                                     [1:0]Buswidth  R1*/
#define CMD14   14  /* HSMMC_BUS_TESTING        adtc [31:16] stuff R1 */
#define CMD15   15  /* MMC_GO_INACTIVE_STATE    ac   [31:16] RCA  */
#define CMD19   19  /* HSMMC_BUS_TESTING        adtc [31:16] stuff R1 */

/* class 2 */
#define CMD16   16  /* MMC_SET_BLOCKLEN         ac   [31:0] blkln R1  */
#define CMD17   17  /* MMC_READ_SINGLE_BLOCK    adtc [31:0] dtadd R1  */
#define CMD18   18  /* MMC_READ_MULTIPLE_BLOCK  adtc [31:0] dtadd R1  */

/* class 3 */
#define CMD20   20  /* MMC_WRITE_DAT_UNTIL_STOP adtc [31:0] dtadd R1  */

/* class 4 */
#define CMD23   23  /* MMC_SET_BLOCK_COUNT      adtc [31:0] dtadd R1  */
#define CMD24   24  /* MMC_WRITE_BLOCK          adtc [31:0] dtadd R1  */
#define CMD25   25  /* MMC_WRITE_MULTIPLE_BLOCK adtc              R1  */
#define CMD26   26  /* MMC_PROGRAM_CID          adtc              R1  */
#define CMD27   27  /* MMC_PROGRAM_CSD          adtc              R1  */

/* class 6 */
#define CMD28   28  /* MMC_SET_WRITE_PROT       ac   [31:0] dtadd R1b */
#define CMD29   29  /* _CLR_WRITE_PROT          ac   [31:0] dtadd R1b */
#define CMD30   30  /* MMC_SEND_WRITE_PROT      adtc [31:0] wpdtaddr R1  */

/* class 5 */
#define CMD32   32  /* SD_ERASE_GROUP_START    ac   [31:0] dtadd  R1  */
#define CMD33   33  /* SD_ERASE_GROUP_END      ac   [31:0] dtaddr R1  */

#define CMD35   35  /* MMC_ERASE_GROUP_START    ac   [31:0] dtadd  R1  */
#define CMD36   36  /* MMC_ERASE_GROUP_END      ac   [31:0] dtaddr R1  */
#define CMD38   38  /* MMC_ERASE                ac                 R1b */

/* class 9 */
#define CMD39   39  /* MMC_FAST_IO              ac   <Complex>     R4  */
#define CMD40   40  /* MMC_GO_IRQ_STATE         bcr                R5  */

#define ACMD41  41  /* SD_SEND_OP_COND          ??                 R1  */

/* class 7 */
#define CMD42   42  /* MMC_LOCK_UNLOCK          adtc               R1b */

#define ACMD51  51  /* SEND_SCR                 adtc               R1  */

#define CMD52   52  /* SDIO_RW_DIRECT           ??                 R5  */
#define CMD53   53  /* SDIO_RW_EXTENDED         ??                 R5  */

/* class 8 */
#define CMD55   55  /* MMC_APP_CMD              ac   [31:16] RCA   R1  */
#define CMD56   56  /* MMC_GEN_CMD              adtc [0] RD/WR     R1b */

// For CE-ATA Drive
#define CMD60 60
#define CMD61 61

#define SDIO_RESET  100  //To differentiate CMD52 for IORESET and other rd/wrs.
#define SDIO_ABORT  101  //To differentiate CMD52 for IO ABORT and other rd/wrs.


#define UNADD_OFFSET  200
#define UNADD_CMD7      207
#define WCMC52        252
#define WCMD53        253
#define WCMD60        260
#define WCMD61        261
#define ACMD6         206
#define SD_CMD8       208  /*This is added to support SD 2.0 (SDHC) cards*/
#define SD_CMD11      211  /*This is added to support SDXC Voltage Switching*/


u32 emmc_last_com_status(void);
u32 *emmc_last_com_response(void);
u8 *emmc_last_com_data(void);
u32 emmc_last_cmd_status(void);
//emmc_postproc_callback emmc_get_post_callback(u32);
//emmc_preproc_callback emmc_get_pre_callback(u32);
void emmc_set_current_task_status(u32,u32 *, u8 *,
				      emmc_postproc_callback);
void emmc_remove_command(void);
void emmc_set_data_trans_params(u32 slot, u8 * data_buffer,
				    u32 num_of_blocks,
				    emmc_term_function
				    the_term_function,
				    emmc_copy_function the_copy_func,
				    u32 epoch_count,
				    u32 flag,u32 custom_blocksize);

u32 emmc_bus_corruption_present(void);

s32 emmc_is_it_data_command(u32 slot);

u32 emmc_get_slave_intmask_task_status(u32 slot);

#endif				/* End of file */

