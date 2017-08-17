#include <stdio.h>
#include "emmc.h"

extern Card_info *the_card_info;

typedef struct {
	emmc_preproc_callback preproc;
	emmc_postproc_callback postproc;
} Callbacks;

typedef struct {
	u32 cmd_index;
	Callbacks the_callbacks;
} callback_search_table;

current_task_status current_task;


static u32 the_term_function(u8 * buff, u32 bytes_read)
{
//	PDEBUG("%s: BYTES_READ = %u\n", __FUNCTION__, bytes_read);
	if (bytes_read >= 512)
		return 1;
	return 0;
}

static void no_response_preproc(u32 card_num, u32 cmd_index,      //ly
				u32 * cmd_reg, u32 * arg_reg)
{

	UNSET_BITS(*cmd_reg, CMD_ABRT_CMD_BIT);
	UNSET_BITS(*cmd_reg, CMD_RESP_EXP_BIT);
	UNSET_BITS(*cmd_reg, CMD_RESP_LENGTH_BIT);
	SET_CARD_NUM(*cmd_reg, card_num);
	if (cmd_index > 200) {
		cmd_index -= 200;
	}
	SET_CMD_INDEX(*cmd_reg, cmd_index);
}

static void no_response_preproc_abrt(u32 card_num, u32 cmd_index,     //ly
				     u32 * cmd_reg, u32 * arg_reg)
{

	no_response_preproc(card_num, cmd_index, cmd_reg, arg_reg);
	SET_BITS(*cmd_reg, CMD_ABRT_CMD_BIT);

}
static void long_response_preproc(u32 card_num, u32 cmd_index,   //ly
				  u32 * cmd_reg, u32 * arg_reg)
{
	UNSET_BITS(*cmd_reg, CMD_ABRT_CMD_BIT);
	SET_BITS(*cmd_reg, CMD_RESP_EXP_BIT);
	SET_BITS(*cmd_reg, CMD_RESP_LENGTH_BIT);
	SET_CARD_NUM(*cmd_reg, card_num);
	if (cmd_index > 200) {
		cmd_index -= 200;
	}
	SET_CMD_INDEX(*cmd_reg, cmd_index);
}


static void short_response_preproc(u32 card_num, u32 cmd_index,    //ly
				   u32 * cmd_reg, u32 * arg_reg)
{
	SET_BITS(*cmd_reg, CMD_RESP_EXP_BIT);
	UNSET_BITS(*cmd_reg, CMD_RESP_LENGTH_BIT);
	if (cmd_index > 200) {
		cmd_index -= 200;
	}  
	SET_CMD_INDEX(*cmd_reg, cmd_index);
	SET_CARD_NUM(*cmd_reg, card_num);
}

static void short_response_preproc_abrt(u32 card_num, u32 cmd_index,    //ly
					u32 * cmd_reg, u32 * arg_reg)
{
	short_response_preproc(card_num, cmd_index, cmd_reg, arg_reg);
	SET_BITS(*cmd_reg, CMD_ABRT_CMD_BIT);
}


static void short_response_preproc_with_init(u32 card_num, u32 cmd_index,   //ly
					     u32 * cmd_reg, u32 * arg_reg)
{
	short_response_preproc(card_num, cmd_index, cmd_reg, arg_reg);
	SET_BITS(*cmd_reg, CMD_SEND_INIT_BIT);
}


#if 0
static void no_response_preproc_unadd(u32 card_num, u32 cmd_index,
				      u32 * cmd_reg, u32 * arg_reg)
{
	SET_CMD_INDEX(*cmd_reg, (cmd_index - UNADD_OFFSET));
	SET_CARD_NUM(*cmd_reg, card_num);
}
#endif



static void short_response_block_data_preproc(u32 card_num,     //ly
					      u32 cmd_index,
					      u32 * cmd_reg, u32 * arg_reg)
{
        short_response_preproc(card_num, cmd_index, cmd_reg, arg_reg);
        SET_BITS(*cmd_reg, CMD_DATA_EXP_BIT);
        /*
        Some of MMC/SD cards misbehave (block skip problem) when auto_stop_bit is set for
        a multi block read. So Driver should send the STOP CMD (CMD12) after multi block read
        is complete.
        */
        UNSET_BITS(*cmd_reg, CMD_SENT_AUTO_STOP_BIT);
        if(cmd_index == CMD17)
                UNSET_BITS(*cmd_reg, CMD_SENT_AUTO_STOP_BIT);
 
        SET_BITS(*cmd_reg, CMD_WAIT_PRV_DAT_BIT);
}


static void short_response_block_data_preproc_noac(u32 card_num,   //  ly 
						   u32 cmd_index,
						   u32 * cmd_reg,
						   u32 * arg_reg)
{
	short_response_block_data_preproc(card_num, cmd_index, cmd_reg,arg_reg);
	UNSET_BITS(*cmd_reg, CMD_SENT_AUTO_STOP_BIT);
}

#if 1     //ly
static void short_response_stream_data_preproc(u32 card_num,
					       u32 cmd_index,
					       u32 * cmd_reg,
					       u32 * arg_reg)
{
	short_response_block_data_preproc(card_num, cmd_index, cmd_reg,arg_reg);
	SET_BITS(*cmd_reg, CMD_TRANSMODE_BIT);
}
#endif       


static void short_response_stream_data_preproc_noac(u32 card_num,    
						    u32 cmd_index,
						    u32 * cmd_reg,
						    u32 * arg_reg)
{
	short_response_stream_data_preproc(card_num, cmd_index, cmd_reg,
					   arg_reg);
	UNSET_BITS(*cmd_reg, CMD_SENT_AUTO_STOP_BIT);
}

#if 0
static void short_response_block_data_preproc_noac(u32 card_num,
						   u32 cmd_index,
						   u32 * cmd_reg,
						   u32 * arg_reg)
{
	short_response_block_data_preproc(card_num, cmd_index, cmd_reg,
					  arg_reg);
	UNSET_BITS(*cmd_reg, CMD_SENT_AUTO_STOP_BIT);
}
#endif



static void short_response_block_write_preproc(u32 card_num,   //ly
					       u32 cmd_index,
					       u32 * cmd_reg,
					       u32 * arg_reg)
{
        short_response_preproc(card_num, cmd_index, cmd_reg, arg_reg);
        SET_BITS(*cmd_reg, CMD_DATA_EXP_BIT);
        SET_BITS(*cmd_reg, CMD_RW_BIT);
        /*
        Some of MMC/SD cards misbehave (block skip problem) when auto_stop_bit is set for
        a multi block write. So Driver should send the STOP CMD (CMD12) after multi block write
        is complete.
        */
//        UNSET_BITS(*cmd_reg, CMD_SENT_AUTO_STOP_BIT);//Just to check with CMD23 instead of autotstopcommand
        if((cmd_index == CMD24) || (cmd_index == CMD42))
                UNSET_BITS(*cmd_reg, CMD_SENT_AUTO_STOP_BIT);
    
        SET_BITS(*cmd_reg, CMD_WAIT_PRV_DAT_BIT);

}

#if 1
static void short_response_stream_write_preproc(u32 card_num,
						u32 cmd_index,
						u32 * cmd_reg,
						u32 * arg_reg)
{
	short_response_block_write_preproc(card_num, cmd_index, cmd_reg,arg_reg);
	SET_BITS(*cmd_reg, CMD_TRANSMODE_BIT);
}



static void short_response_block_write_preproc_noac(u32 card_num,
						    u32 cmd_index,
						    u32 * cmd_reg,
						    u32 * arg_reg)
{
	short_response_block_write_preproc(card_num, cmd_index, cmd_reg,arg_reg);
	UNSET_BITS(*cmd_reg, CMD_SENT_AUTO_STOP_BIT);
}
#endif 


#if 0
static void abort_preproc(u32 card_num, u32 cmd_index, u32 * cmd_reg,
			  u32 * arg_reg)
{
	SET_BITS(*cmd_reg, CMD_ABRT_CMD_BIT);
	SET_BITS(*cmd_reg, CMD_RESP_EXP_BIT);
	UNSET_BITS(*cmd_reg, CMD_RESP_LENGTH_BIT);
	SET_CMD_INDEX(*cmd_reg, cmd_index);
}
#endif


static void short_response_rca_preproc(u32 card_num, u32 cmd_index,    //ly
				       u32 * cmd_reg, u32 * arg_reg)
{
	short_response_preproc(card_num, cmd_index, cmd_reg, arg_reg);
	SET_RCA(*arg_reg, (the_card_info[card_num].the_rca));
}

#if 0
static void no_response_rca_preproc(u32 card_num, u32 cmd_index,
				    u32 * cmd_reg, u32 * arg_reg)
{
	no_response_preproc(card_num, cmd_index, cmd_reg, arg_reg);
	SET_RCA(*arg_reg, (the_card_info[card_num].the_rca));
}
#endif

#if 1   //ly
static void long_response_rca_preproc(u32 card_num, u32 cmd_index,
				      u32 * cmd_reg, u32 * arg_reg)
{
	long_response_preproc(card_num, cmd_index, cmd_reg, arg_reg);
	SET_RCA(*arg_reg, (the_card_info[card_num].the_rca));
}
#endif

void short_response_postproc(void *the_data, u32 * interrupt_status)   //ly
{
	current_task_status *the_task_status =  (current_task_status *) the_data;

	/* Handle standard interrupt handler */
//#ifdef IDMAC_SUPPORT	
if(current_task.idma_mode_on ==1)
        emmc_handle_standard_idsts(the_data , *interrupt_status);
//#else
else
	emmc_handle_standard_rinsts(the_data, *interrupt_status);
//#endif


	/* Read the short response and set the command status */
	if (the_task_status->resp_buffer) {
	//	printf("Entering short_response_buf ,%x\n",the_task_status->resp_buffer );
		the_task_status->resp_buffer[0] =  emmc_read_register(EMMC_REG_RESP0);
		printf(" the_task_status->resp_buffer,%x\n",the_task_status->resp_buffer[0]);
	}
}

#if 1   //ly
static void short_response_preproc_volt_switch_stage_1(u32 card_num, u32 cmd_index,u32 * cmd_reg, u32 * arg_reg)
{
	SET_BITS(*cmd_reg, CMD_RESP_EXP_BIT);
	SET_BITS(*cmd_reg, CMD_VOLT_SW_BIT);

	UNSET_BITS(*cmd_reg, CMD_RESP_LENGTH_BIT);
	if (cmd_index > 200) {
		cmd_index -= 200;
	}
	SET_CMD_INDEX(*cmd_reg, cmd_index);
	SET_CARD_NUM(*cmd_reg, card_num);
}
#endif

void short_response_postproc_volt_switch_stage_1(void * the_data, u32 * interrupt_status)   //ly
{
  	current_task_status *the_task_status =  (current_task_status *) the_data;

	/* Handle standard interrupt handler */
	emmc_handle_standard_rinsts(the_data, *interrupt_status);
    
    if(the_task_status->error_status == ERRUNDERWRITE){ 
        // The ERRUNDERWRITE is SET because of Voltage Switch Interrupt. Since this is not the error condition revert back the error status.
        the_task_status->error_status = ERRNOERROR;
		the_task_status->cmd_status = TSK_COMMAND_DONE; //This is required for us to return from ISR
    }
	/* Read the short response and set the command status */
	if (the_task_status->resp_buffer) {
		the_task_status->resp_buffer[0] =  emmc_read_register(EMMC_REG_RESP0);
	}
      
    return;
}


void long_response_postproc(void *the_data, u32 * interrupt_status)   //ly
{
	current_task_status *the_task_status =
	    (current_task_status *) the_data;

	/* Handle standard interrupt handler */
	emmc_handle_standard_rinsts(the_data, *interrupt_status);

	if (the_task_status->resp_buffer) {
		the_task_status->resp_buffer[0] =  emmc_read_register(EMMC_REG_RESP0);
		the_task_status->resp_buffer[1] =  emmc_read_register(EMMC_REG_RESP1);
		the_task_status->resp_buffer[2] =  emmc_read_register(EMMC_REG_RESP2);
		the_task_status->resp_buffer[3] =  emmc_read_register(EMMC_REG_RESP3);
	}
}


void no_response_postproc(void *the_data, u32 * interrupt_status)   //ly
{
	current_task_status *the_task_status = (current_task_status *) the_data;

	/* Handle standard interrupt handler */
	emmc_handle_standard_rinsts(the_data, *interrupt_status);

	/* Check if there is any error */
	if (the_task_status->error_status) {
		the_task_status->cmd_status = TSK_STAT_ABSENT;
		return;
	}
	return;
}


static void r1_r6_response_postproc(void *the_data, u32 * interrupt_status)    //ly
{
	u32 r1_check_val;
	current_task_status *the_task_status = (current_task_status *) the_data;

	short_response_postproc(the_data, interrupt_status);

	if (the_task_status->error_status) {
		the_task_status->bus_corruption_occured = 1;
		the_task_status->error_status = 0;
	}

	if (the_task_status->resp_buffer) {
		if ((SD_TYPE == the_card_info[the_task_status->slot_num].card_type) || 
            (SDCOMBO_TYPE == the_card_info[the_task_status->slot_num].card_type) || 
            (SD_MEM_2_0_TYPE == the_card_info[the_task_status->slot_num].card_type) ||
            (SD_MEM_3_0_TYPE == the_card_info[the_task_status->slot_num].card_type)) {
			r1_check_val =  the_task_status->resp_buffer[0] & 0x0000ffff;
		} 
        else if (SDIO_TYPE == the_card_info[the_task_status->slot_num].card_type) {
			r1_check_val =  the_task_status->resp_buffer[0] & 0xffff0000;
			if (r1_check_val & 0xe010) {
                the_task_status->error_status =   ERRHARDWARE;
			}
			return;
		} 
        else {
			r1_check_val = the_task_status->resp_buffer[0];
		}

		the_task_status->error_status = emmc_check_r1_resp(r1_check_val);
	}
	return;
}

#if 1 //ly
static void r5_response_postproc(void *the_data, u32 * interrupt_status)
{
	current_task_status *the_task_status =(current_task_status *) the_data;
	short_response_postproc(the_data, interrupt_status);
	if (the_task_status->error_status) {
		return;
	}
	if (the_task_status->resp_buffer) {
		the_task_status->error_status = emmc_check_r5_resp(the_task_status->resp_buffer[0]);
	}
	return;
}
#endif

static void r1_response_postproc(void *the_data, u32 * interrupt_status)    //ly
{
	current_task_status *the_task_status = (current_task_status *) the_data;
	short_response_postproc(the_data, interrupt_status);
	if (the_task_status->error_status) {
		return;
	}

	if (the_task_status->resp_buffer) {
		the_task_status->error_status = emmc_check_r1_resp(the_task_status->resp_buffer[0]);
	}
	return;
}

static void r1b_response_postproc(void *the_data, u32 * interrupt_status)    //ly
{
	r1_response_postproc(the_data,interrupt_status);
	while ((emmc_read_register(EMMC_REG_STATUS)) & STATUS_DAT_BUSY_BIT);
	return;
}

#if 1
static void r4_response_postproc(void *the_data, u32 * interrupt_status)
{
	current_task_status *the_task_status = (current_task_status *) the_data;
	short_response_postproc(the_data, interrupt_status);
	if (the_task_status->error_status) {
		return;
	}
	if (the_task_status->resp_buffer) {
		if (!(*(the_task_status->resp_buffer) | R4_RESP_ERROR_BIT)) {
			the_task_status->error_status = ERRHARDWARE;
		}
	}
	return;
}

static void r1_response_write_bstst_postproc(void *the_data,
					     u32 * interrupt_status)
{
	current_task_status *the_task_status = (current_task_status *) the_data;
	u32 cmd_status;

	//The following variables are required for IDMAC mode interrupt handling
	u32 status,buffer1,buffer1_virt,buffer2,buffer2_virt;

	r1_response_postproc(the_data, interrupt_status);

	if (ERRENDBITERR == the_task_status->error_status) {
		the_task_status->error_status = 0;
	}

	if (the_task_status->error_status) {
		if (TSK_STATE_WRITEDAT == the_task_status->cmd_status) {
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}
		return;
	}

	cmd_status = the_task_status->cmd_status;
	// The interrupts are interpreted as IDMAC interrupts for data transfer commands in IDMAC mode
	if(the_task_status->idma_mode_on == 1){
		// The data command is supposed to be handled by IDMAC 
		if(*interrupt_status & IDMAC_NI){ // Interrupt for this command
			printf("Relax: Normal Interrupt received for IDMAC\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_NI);
		}
		if(*interrupt_status & IDMAC_TI){ // Transmit Interrupt
			printf("Transmit Interrupt received in IDMAC mode\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_TI);
		}
            //Whether DMA operation is Successful or nor we need to set cmd_status to COMMAND_DONE
            //and get the qptr from the Descriptor list
		if(TSK_STATE_POLLD==the_task_status->cmd_status){
			//Dont give up the qptr
			the_task_status->error_status = 0;//Make error status zero as long as we are issuing poll demand
			the_task_status->cmd_status = TSK_STAT_STARTED;
		}
		else{
                	emmc_get_qptr(&status, &buffer1, &buffer1_virt, &buffer2, &buffer2_virt);
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}

  	}
	
	else{
		if (cmd_status != TSK_STATE_WRITEDAT) {
			the_task_status->cmd_status = TSK_STATE_WRITEDAT;
//			if (*interrupt_status & INTMSK_DAT_OVER) {
//				*interrupt_status &= (*interrupt_status & ~INTMSK_DAT_OVER);
//			}
		}
	
		if ((*interrupt_status & INTMSK_TXDR)) {
			emmc_write_out_data(the_task_status, INTMSK_TXDR);
		}

		if (*interrupt_status & INTMSK_DAT_OVER) {
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}

	}
	return;
}


static void r5_response_write_data_postproc(void *the_data,
					    u32 * interrupt_status)
{
	current_task_status *the_task_status = (current_task_status *) the_data;
	u32 cmd_status;

	//The following variables are required for IDMAC mode interrupt handling
	u32 status,buffer1,buffer1_virt,buffer2,buffer2_virt;

	r5_response_postproc(the_data, interrupt_status);

	printf("%s: The error status = %d\n", __FUNCTION__,the_task_status->error_status);

	if (ERRENDBITERR == the_task_status->error_status) {
		the_task_status->bus_corruption_occured = 1;
		the_task_status->error_status = 0;
	}
    
	if (the_task_status->error_status) {
		if (TSK_STATE_WRITEDAT == the_task_status->cmd_status) {
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}
		return;
	}

	cmd_status = the_task_status->cmd_status;

	if(the_task_status->idma_mode_on == 1){
		// The data command is supposed to be handled by IDMAC 
		if(*interrupt_status & IDMAC_NI){ // Interrupt for this command
			printf("Relax: Normal Interrupt received for IDMAC\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_NI);
		}
		if(*interrupt_status & IDMAC_TI){ // Transmit Interrupt
			printf("Transmit Interrupt received in IDMAC mode\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_TI);
		}
            //Whether DMA operation is Successful or nor we need to set cmd_status to COMMAND_DONE
            //and get the qptr from the Descriptor list
		if(TSK_STATE_POLLD==the_task_status->cmd_status){
			//Dont give up the qptr
			the_task_status->error_status = 0;//Make error status zero as long as we are issuing poll demand
			the_task_status->cmd_status = TSK_STAT_STARTED;
		}
		else{
                	emmc_get_qptr(&status, &buffer1, &buffer1_virt, &buffer2, &buffer2_virt);
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}


	}
	else{
		if (cmd_status != TSK_STATE_WRITEDAT) {
			the_task_status->cmd_status = TSK_STATE_WRITEDAT;
		} 
    	else if ((*interrupt_status & INTMSK_TXDR)) {
			emmc_write_out_data(the_task_status, INTMSK_TXDR);
		}

		if (*interrupt_status & INTMSK_DAT_OVER) {
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}
	}

	return;
}


static void r1b_response_write_data_postproc(void *the_data,
					    u32 * interrupt_status)
{
	current_task_status *the_task_status = (current_task_status *) the_data;
	u32 cmd_status;

	//The following variables are required for IDMAC mode interrupt handling
	u32 status,buffer1,buffer1_virt,buffer2,buffer2_virt;

	r1b_response_postproc(the_data, interrupt_status);

	printf("%s: The error status = %d\n", __FUNCTION__,the_task_status->error_status);

	if (ERRENDBITERR == the_task_status->error_status) {
		the_task_status->bus_corruption_occured = 1;
		the_task_status->error_status = 0;
	}

	if (the_task_status->error_status) {
		if (TSK_STATE_WRITEDAT == the_task_status->cmd_status) {
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}
		return;
	}

	cmd_status = the_task_status->cmd_status;

	if(the_task_status->idma_mode_on == 1){
		// The data command is supposed to be handled by IDMAC 
		if(*interrupt_status & IDMAC_NI){ // Interrupt for this command
			printf("Relax: Normal Interrupt received for IDMAC\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_NI);
		}
		if(*interrupt_status & IDMAC_TI){ // Transmit Interrupt
			printf("Transmit Interrupt received in IDMAC mode\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_TI);
		}
            //Whether DMA operation is Successful or nor we need to set cmd_status to COMMAND_DONE
            //and get the qptr from the Descriptor list
		if(TSK_STATE_POLLD==the_task_status->cmd_status){
			//Dont give up the qptr
			the_task_status->error_status = 0;//Make error status zero as long as we are issuing poll demand
			the_task_status->cmd_status = TSK_STAT_STARTED;
		}
		else{
                	emmc_get_qptr(&status, &buffer1, &buffer1_virt, &buffer2, &buffer2_virt);
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}


	}
	else{
		if (cmd_status != TSK_STATE_WRITEDAT) {
			the_task_status->cmd_status = TSK_STATE_WRITEDAT;
		} 
    	else if ((*interrupt_status & INTMSK_TXDR)) {
			emmc_write_out_data(the_task_status, INTMSK_TXDR);
		}

		if (*interrupt_status & INTMSK_DAT_OVER) {
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}
	}

	return;
}
#endif

static void r1_response_write_data_postproc(void *the_data,   //ly
					    u32 * interrupt_status)
{
	current_task_status *the_task_status = (current_task_status *) the_data;
	u32 cmd_status;

	//The following variables are required for IDMAC mode interrupt handling
	u32 status,buffer1,buffer1_virt,buffer2,buffer2_virt;

	r1_response_postproc(the_data, interrupt_status);
	printf("%s: The error status = %d\n", __FUNCTION__, the_task_status->error_status);

	if (ERRENDBITERR == the_task_status->error_status) {
		the_task_status->bus_corruption_occured = 1;
		the_task_status->error_status = 0;
	}
    /*enable data_command_task*/
	if (the_task_status->error_status) {
		//if (TSK_STATE_WRITEDAT == the_task_status->cmd_status) {
		//	emmc_enable_data_command_tasks();
		//	printf("enable data command task.");
		//}
		return;
	}

	cmd_status = the_task_status->cmd_status;
	// The interrupts are interpreted as IDMAC interrupts for data transfer commands in IDMAC mode
	if(the_task_status->idma_mode_on == 1){
		// The data command is supposed to be handled by IDMAC 
		if(*interrupt_status & IDMAC_NI){ // Interrupt for this command
			printf("Relax: Normal Interrupt received for IDMAC\n");
			emmc_set_register(EMMC_REG_IDSTS, IDMAC_NI);
		}
		if(*interrupt_status & IDMAC_TI){ // Transmit Interrupt
			printf("Transmit Interrupt received in IDMAC mode\n");
			emmc_set_register(EMMC_REG_IDSTS, IDMAC_TI);
		}
            //Whether DMA operation is Successful or nor we need to set cmd_status to COMMAND_DONE
            //and get the qptr from the Descriptor list
		if(TSK_STATE_POLLD==the_task_status->cmd_status){
			//Dont give up the qptr
			the_task_status->error_status = 0;//Make error status zero as long as we are issuing poll demand
			the_task_status->cmd_status = TSK_STAT_STARTED;
		}
		else{
                	emmc_get_qptr(&status, &buffer1, &buffer1_virt, &buffer2, &buffer2_virt);
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}

  	}
	else{
		if (cmd_status != TSK_STATE_WRITEDAT) {
			the_task_status->cmd_status = TSK_STATE_WRITEDAT;
		}	 
    		else if ((*interrupt_status & INTMSK_TXDR)) {
			emmc_write_out_data(the_task_status, INTMSK_TXDR);
		}

		if (*interrupt_status & INTMSK_DAT_OVER) {
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}
	}

	return;
}



#if 1 //ly
static void r1_response_read_bstst_postproc(void *the_data,
					    u32 * interrupt_status)
{
	current_task_status *the_task_status = (current_task_status *) the_data;
	u32 cmd_status;
	//The following variables are required for IDMAC mode interrupt handling
	u32 status,buffer1,buffer1_virt,buffer2,buffer2_virt;

	r1_response_postproc(the_data, interrupt_status);

	if ((ERRDCRC == the_task_status->error_status) || (ERRENDBITERR == the_task_status->error_status)) {
    		the_task_status->error_status = 0;
	}

	if (the_task_status->error_status) {
		return;
	}

	if (!(the_task_status->error_status)) {
		the_task_status->cmd_status = TSK_STATE_READDAT;
	}
	
	cmd_status = the_task_status->cmd_status;

	if(the_task_status->idma_mode_on == 1){
		// The data command is supposed to be handled by IDMAC 
		if(*interrupt_status & IDMAC_NI){ // Interrupt for this command
			printf("Relax: Normal Interrupt received for IDMAC\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_NI);
		}
		if(*interrupt_status & IDMAC_RI){ // Receive Interrupt;
			printf("Receive Interrupt received in IDMAC mode\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_RI);
		}
                //Whether DMA operation is Successful or nor we need to set cmd_status to COMMAND_DONE
                //and get the qptr from the Descriptor list. Only exception is when, Descriptor unavailable interrupt occured,
                //Dont get the qptr as ISR may retry using Poll demand
		if(TSK_STATE_POLLD==the_task_status->cmd_status){
			//Dont give up the qptr
			the_task_status->error_status = 0;//Make error status zero as long as we are issuing poll demand
			the_task_status->cmd_status = TSK_STAT_STARTED;
		}
		else{
                	emmc_get_qptr(&status, &buffer1, &buffer1_virt, &buffer2, &buffer2_virt);
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");
		}

	}
    else{
		if (TSK_STATE_READDAT == cmd_status) {
			if ((*interrupt_status & INTMSK_RXDR)) {
				emmc_read_in_data(the_task_status, INTMSK_RXDR);
			}

			if ((*interrupt_status & INTMSK_DAT_OVER)) {
				emmc_read_in_data(the_task_status, INTMSK_DAT_OVER);
			}
			if ((*interrupt_status & INTMSK_DAT_OVER) && !(the_task_status->error_status)) {
				the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");			}
		}
	}
	return;
}

static void r5_response_read_data_postproc(void *the_data,
					   u32 * interrupt_status)
{
	current_task_status *the_task_status = (current_task_status *) the_data;
	u32 cmd_status;
	//The following variables are required for IDMAC mode interrupt handling
	u32 status,buffer1,buffer1_virt,buffer2,buffer2_virt;

	r5_response_postproc(the_data, interrupt_status);

//	printf("%s: The error status = %d\n", __FUNCTION__,the_task_status->error_status);

	if (ERRILLEGALCOMMAND == the_task_status->error_status) {
		the_task_status->error_status = 0;
		the_task_status->bus_corruption_occured = 1;
	}

	the_task_status->cmd_status = TSK_STATE_READDAT;

	cmd_status = the_task_status->cmd_status;
	if(the_task_status->idma_mode_on == 1){
		// The data command is supposed to be handled by IDMAC 
		if(*interrupt_status & IDMAC_NI){ // Interrupt for this command
			printf("Relax: Normal Interrupt received for IDMAC\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_NI);
		}
		if(*interrupt_status & IDMAC_RI){ // Receive Interrupt;
			printf("Receive Interrupt received in IDMAC mode\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_RI);
		}
                //Whether DMA operation is Successful or nor we need to set cmd_status to COMMAND_DONE
                //and get the qptr from the Descriptor list. Only exception is when, Descriptor unavailable interrupt occured,
                //Dont get the qptr as ISR may retry using Poll demand
		if(TSK_STATE_POLLD==the_task_status->cmd_status){
			//Dont give up the qptr
			the_task_status->error_status = 0;             //Make error status zero as long as we are issuing poll demand
			the_task_status->cmd_status = TSK_STAT_STARTED;
		}
		else{
                	emmc_get_qptr(&status, &buffer1, &buffer1_virt, &buffer2, &buffer2_virt);
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");		}

	}
    else{
		if ((*interrupt_status & INTMSK_RXDR)) {
			emmc_read_in_data(the_task_status, INTMSK_RXDR);
		}

		if ((*interrupt_status & INTMSK_DAT_OVER)) {
			emmc_read_in_data(the_task_status, INTMSK_DAT_OVER);
		}

		if ((*interrupt_status & INTMSK_DAT_OVER) && (!(the_task_status->error_status))) {
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");		}
	}
	return;

}
#endif

static void r1_response_read_data_postproc(void *the_data,    //ly
					   u32 * interrupt_status)
{
	current_task_status *the_task_status = (current_task_status *) the_data;
        u32 cmd_status;
	//The following variables are required for IDMAC mode interrupt handling
	u32 status,buffer1,buffer1_virt,buffer2,buffer2_virt;

	r1_response_postproc(the_data, interrupt_status);

	if (ERRDCRC == the_task_status->error_status) {
		printf("ACMD51 bus set and err_statys = %x\n",the_task_status->error_status);
		the_task_status->bus_corruption_occured = 1;
		the_task_status->error_status = 0;
	}

    /* cmd_status = the_task_status->cmd_status;*/ /*should come only after cmd_status is updated */

	if ((!(the_task_status->error_status)) && (the_task_status->cmd_status != TSK_STATE_POLLD)) {
		the_task_status->cmd_status = TSK_STATE_READDAT;
	}

        cmd_status = the_task_status->cmd_status; /*should come here */

	if(the_task_status->idma_mode_on == 1){
		// The data command is supposed to be handled by IDMAC 
		if(*interrupt_status & IDMAC_NI){ // Interrupt for this command
			printf("Relax: Normal Interrupt received for IDMAC\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_NI);
		}
		if(*interrupt_status & IDMAC_RI){ // Receive Interrupt;
			printf("Receive Interrupt received in IDMAC mode\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_RI);
		}
                //Whether DMA operation is Successful or nor we need to set cmd_status to COMMAND_DONE
                //and get the qptr from the Descriptor list. Only exception is when, Descriptor unavailable interrupt occured,
                //Dont get the qptr as ISR may retry using Poll demand
		if(TSK_STATE_POLLD==the_task_status->cmd_status){
			//Dont give up the qptr
			the_task_status->error_status = 0;//Make error status zero as long as we are issuing poll demand
			the_task_status->cmd_status = TSK_STAT_STARTED;
		}
		else{
                	emmc_get_qptr(&status, &buffer1, &buffer1_virt, &buffer2, &buffer2_virt);
			the_task_status->cmd_status = TSK_COMMAND_DONE;
		//	emmc_enable_data_command_tasks();       ly
			printf("Need to enable data command ( Kernel )\n");
		}
	}
	else{ //Slave mode interrupt handling
		if (TSK_STATE_READDAT == cmd_status) {
			if ((*interrupt_status & INTMSK_RXDR)) {
				emmc_read_in_data(the_task_status, INTMSK_RXDR);
			}

			if ((*interrupt_status & INTMSK_DAT_OVER)) {
				emmc_read_in_data(the_task_status, INTMSK_DAT_OVER);
			}
			if ((*interrupt_status & INTMSK_DAT_OVER) && !(the_task_status->error_status)) {
				the_task_status->cmd_status = TSK_COMMAND_DONE;
		//		emmc_enable_data_command_tasks();   //ly
				printf("Need to enable data command ( Kernel )\n");
			}
		} 
	  	else {
			if (!(the_task_status->error_status)) {
				the_task_status->cmd_status = TSK_STATE_READDAT;
			}
		}
	}
	return;
}


static void r1_response_stream_read_data_postproc(void *the_data,
						  u32 * interrupt_status)
{
	current_task_status *the_task_status = (current_task_status *) the_data;
	u32 cmd_status;
	//The following variables are required for IDMAC mode interrupt handling
	u32 status,buffer1,buffer1_virt,buffer2,buffer2_virt;

	r1_response_postproc(the_data, interrupt_status);

	if (ERRDCRC == the_task_status->error_status) {
		the_task_status->bus_corruption_occured = 1;
		the_task_status->error_status = 0;
	}

	if (ERRUNDERRUN == the_task_status->error_status) {
		the_task_status->bus_corruption_occured = 1;
	}

	the_task_status->cmd_status = TSK_STATE_READDAT;
	
	cmd_status = the_task_status->cmd_status;
	if(the_task_status->idma_mode_on == 1){
		// The data command is supposed to be handled by IDMAC 
		if(*interrupt_status & IDMAC_NI){ // Interrupt for this command
			printf("Relax: Normal Interrupt received for IDMAC\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_NI);
		}
		if(*interrupt_status & IDMAC_RI){ // Receive Interrupt;
			printf("Receive Interrupt received in IDMAC mode\n");
			emmc_set_bits(EMMC_REG_IDSTS, IDMAC_RI);
		}
                //Whether DMA operation is Successful or nor we need to set cmd_status to COMMAND_DONE
                //and get the qptr from the Descriptor list. Only exception is when, Descriptor unavailable interrupt occured,
                //Dont get the qptr as ISR may retry using Poll demand
		if(TSK_STATE_POLLD==the_task_status->cmd_status){
			//Dont give up the qptr
			the_task_status->error_status = 0;//Make error status zero as long as we are issuing poll demand
			the_task_status->cmd_status = TSK_STAT_STARTED;
		}
		else{
                	emmc_get_qptr(&status, &buffer1, &buffer1_virt, &buffer2, &buffer2_virt);
			the_task_status->cmd_status = TSK_COMMAND_DONE;
		//		emmc_enable_data_command_tasks();   //ly
				printf("Need to enable data command ( Kernel )\n");
		}

	}
	else{ // Slave mode is handled here
		if (TSK_STATE_READDAT == cmd_status) {
			if ((*interrupt_status & INTMSK_RXDR)) {
				emmc_read_in_data(the_task_status, INTMSK_RXDR);
			}

			if ((*interrupt_status & INTMSK_DAT_OVER)) {
				emmc_read_in_data(the_task_status, INTMSK_DAT_OVER);
			}
			if ((*interrupt_status & INTMSK_DAT_OVER) && !(the_task_status->error_status)) {
				the_task_status->cmd_status = TSK_COMMAND_DONE;
			//		emmc_enable_data_command_tasks();   //ly
				printf("Need to enable data command ( Kernel )\n");
			}
		} 
	    else {
			if (!(the_task_status->error_status)) {
				the_task_status->cmd_status = TSK_STATE_READDAT;
			}
		}
	}
	return;
}

#if  1  //ly
static void short_response_sd_app_specific_data(u32 card_num,
						u32 cmd_index,
						u32 * cmd_reg,
						u32 * arg_reg)
{

	emmc_send_serial_command(card_num, CMD55, 0, NULL, NULL, 0, NULL, NULL);
	short_response_preproc(card_num, cmd_index, cmd_reg, arg_reg);
	SET_BITS(*cmd_reg, CMD_WAIT_PRV_DAT_BIT);

	return;
}

static void short_response_sd_data_app_specific_data(u32 card_num,
						     u32 cmd_index,
						     u32 * cmd_reg,
						     u32 * arg_reg)
{

	short_response_sd_app_specific_data(card_num, cmd_index, cmd_reg,arg_reg);
	SET_BITS(*cmd_reg, CMD_DATA_EXP_BIT);

	return;
}


#ifdef EMULATE_BOOT

void emmc_alt_boot_preproc(u32 card_num, u32 cmd_index, u32 * cmd_reg, u32 * arg_reg)
{
	SET_BITS(*cmd_reg, CMD_BOOT_MODE);              // Setting BOOT_MODE indicates Alternate boot mode operation
	SET_CMD_INDEX(*cmd_reg, cmd_index);		        // Set the CMD index as CMD0
	SET_CARD_NUM(*cmd_reg, card_num);		        // Set the Card number to appropriate value
	UNSET_BITS(*cmd_reg, CMD_DISABLE_BOOT);         // UnSet disable boot for Alternate booting

    SET_BITS(*cmd_reg, CMD_DATA_EXP_BIT);		    // Boot Mode expects the data so DATA expected bit is set
}

void emmc_alt_boot_with_ack_preproc(u32 card_num, u32 cmd_index, u32 * cmd_reg, u32 * arg_reg)
{
	SET_BITS(*cmd_reg, CMD_BOOT_MODE);              // Setting BOOT_MODE indicates Alternate boot mode operation
	SET_CMD_INDEX(*cmd_reg, cmd_index);		        // Set the CMD index as CMD0
	SET_CARD_NUM(*cmd_reg, card_num);		        // Set the Card number to appropriate value
	UNSET_BITS(*cmd_reg, CMD_DISABLE_BOOT);         // UnSet disable boot for Alternate booting
	SET_BITS(*cmd_reg, CMD_EXP_BOOT_ACK);           // Set Boot ACK expected in the command register

    SET_BITS(*cmd_reg, CMD_DATA_EXP_BIT);		    // Boot Mode expects the data so DATA expected bit is set
}


void emmc_boot_preproc(u32 card_num, u32 cmd_index, u32 * cmd_reg, u32 * arg_reg)
{
	SET_CMD_INDEX(*cmd_reg, cmd_index);		         // Set the CMD index as CMD0
	SET_CARD_NUM(*cmd_reg, card_num);	             // Set the Card number to appropriate value
	SET_BITS(*cmd_reg, CMD_ENABLE_BOOT);             // Set enable_boot for mandatory booting
	UNSET_BITS(*cmd_reg, CMD_DISABLE_BOOT);          // UnSet disable boot for mandatory booting

    SET_BITS(*cmd_reg, CMD_DATA_EXP_BIT);		     // Boot Mode expects the data so DATA expected bit is set
}

void emmc_boot_with_ack_preproc(u32 card_num, u32 cmd_index, u32 * cmd_reg, u32 * arg_reg)
{
	SET_CMD_INDEX(*cmd_reg, cmd_index);		         // Set the CMD index as CMD0
	SET_CARD_NUM(*cmd_reg, card_num);	             // Set the Card number to appropriate value
	SET_BITS(*cmd_reg, CMD_ENABLE_BOOT);             // Set enable_boot for mandatory booting
	UNSET_BITS(*cmd_reg, CMD_DISABLE_BOOT);          // UnSet disable boot for mandatory booting
	SET_BITS(*cmd_reg, CMD_EXP_BOOT_ACK);            // Set Boot ACK expected in the command register

    SET_BITS(*cmd_reg, CMD_DATA_EXP_BIT);		     // Boot Mode expects the data so DATA expected bit is set
}

void emmc_alt_boot_postproc(void * the_data, u32 * interrupt_status)
{
    //take the private data and cast it to current_task_status
	current_task_status *the_task_status = (current_task_status *) the_data;
	u32 cmd_status;

	/* The following reads the ISTSTS and populates the the_task_status->error_status*/
	r1_response_postproc(the_data, interrupt_status);
	
	if (ERRDCRC == the_task_status->error_status) {
		the_task_status->bus_corruption_occured = 1;
		the_task_status->error_status = 0;
	}

	/* Please note that ERRRESTIMEOUT will be set in r1_response_postproc if BAR interrupt has been received. 
	 * Since the ISR is not modified, for booting ERRRESPTIMEOUT error_status indicates that the core received BAR Received
	 */
	
	if(ERRRESPTIMEOUT == the_task_status->error_status){
	printf("BOOT ACK Received....\n");
	the_task_status->error_status = 0; // This is not the error condition for boot operation. The interrupt is due to Boot ack reception
	}

   /* cmd_status = the_task_status->cmd_status;*/ /*should come only after cmd_status is updated */

	if (!(the_task_status->error_status)) {
		the_task_status->cmd_status = TSK_STATE_READDAT; // Even in case of Booting the state is maintained 
                                                         // as TSK_STATE_READDAT. Same routine is used to read the data
	  }

	cmd_status = the_task_status->cmd_status; /*should come here */
	printf("COMMAND_STATUS is %d\n",cmd_status);

	if (TSK_STATE_READDAT == cmd_status) {
		if ((*interrupt_status & INTMSK_RXDR)) {
			emmc_read_in_data(the_task_status, INTMSK_RXDR);
		}

		if ((*interrupt_status & INTMSK_DAT_OVER)) {
			emmc_read_in_data(the_task_status,INTMSK_DAT_OVER);
		}
		if ((*interrupt_status & INTMSK_DAT_OVER) && !(the_task_status->error_status)) {
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");		}
	}
    else {
		if (!(the_task_status->error_status)) {
			the_task_status->cmd_status = TSK_STATE_READDAT;
		}
	}
	return;
}


void emmc_boot_postproc(void *the_data, u32 * interrupt_status)
{
    //take the private data and cast it to current_task_status
	current_task_status *the_task_status = (current_task_status *) the_data;
	u32 cmd_status;

	/* The following reads the ISTSTS and populates the the_task_status->error_status*/
	r1_response_postproc(the_data, interrupt_status);

	if (ERRDCRC == the_task_status->error_status) {
		the_task_status->bus_corruption_occured = 1;
		the_task_status->error_status = 0;
	}

    /* Please note that ERRRESTIMEOUT will be set in r1_response_postproc if BAR interrupt has 
     * been received. Since the ISR is not modified, for booting ERRRESPTIMEOUT error_status 
     * indicates that the core received BAR Received
     */
	
	if(ERRRESPTIMEOUT == the_task_status->error_status){
	printf("BOOT ACK Received....\n");
	the_task_status->error_status = 0; // This is not the error condition for boot operation. 
                                       // The interrupt is due to Boot ack reception
	}

/*	cmd_status = the_task_status->cmd_status;*/ /*should come only after cmd_status is updated */

	if (!(the_task_status->error_status)) {
		the_task_status->cmd_status = TSK_STATE_READDAT; // Even in case of Booting the state is maintained as
                                                         // TSK_STATE_READDAT. Same routine is used to read the data
	  }

	cmd_status = the_task_status->cmd_status; /*should come here */
	printf("COMMAND_STATUS is %d\n",cmd_status);

	if (TSK_STATE_READDAT == cmd_status) {
		if ((*interrupt_status & INTMSK_RXDR)) {
			emmc_read_in_data(the_task_status, INTMSK_RXDR);
		}

		if ((*interrupt_status & INTMSK_DAT_OVER)) {
			emmc_read_in_data(the_task_status,INTMSK_DAT_OVER);
		}
		if ((*interrupt_status & INTMSK_DAT_OVER) && !(the_task_status->error_status)) {
			the_task_status->cmd_status = TSK_COMMAND_DONE;
//			emmc_enable_data_command_tasks();   ly
			printf("Need to enable data command ( Kernel )\n");		}
	} 
    else {
		if (!(the_task_status->error_status)) {
			the_task_status->cmd_status = TSK_STATE_READDAT;
		}
	}
	return;
}
#endif
#endif

/**
  * Command Index callback table.
  * This is a table sorted by command index for the command indices and
  * their corresponding callbacks. This table allows easy manipulation of
  * new command addition and thier handling logic. 
  * \todo Use this table for a minimal perfect hashing rather than a 
  * binary search <i>(use gperf ?)</i>
  */
static callback_search_table the_callback_table[] = {
// callback_search_table the_callback_table[] = {
	{CMD0       , {no_response_preproc_abrt, no_response_postproc}},   //ly
	{CMD1       , {short_response_preproc_with_init, short_response_postproc}},    //
	{CMD2       , {long_response_preproc, long_response_postproc}},   //
	{CMD3       , {short_response_preproc, r1_r6_response_postproc}},    //
	{CMD5       , {short_response_preproc, short_response_postproc}},    //
	{CMD6       , {short_response_preproc, r1b_response_postproc}},          //select ly
	{CMD7       , {short_response_rca_preproc, r1b_response_postproc}},   //
//	{CMD8       , {short_response_block_data_preproc_noac, r1_response_read_data_postproc}},   //
	{CMD8       , {short_response_preproc, short_response_postproc}},
	{CMD9       , {long_response_rca_preproc, long_response_postproc}},   //SEND_CSD 
	{CMD11      , {short_response_stream_data_preproc, r1_response_stream_read_data_postproc}},  //VOLTAGE_SWITCH
	{CMD12      , {short_response_preproc_abrt, r1b_response_postproc}},   //
	{CMD13      , {short_response_rca_preproc, r1_response_postproc}},     //
	{CMD14      , {short_response_block_data_preproc_noac, r1_response_read_bstst_postproc}},
	{CMD15      , {no_response_preproc, no_response_postproc}},    //GO_INACTIVE_STATE
	{CMD16      , {short_response_preproc, r1_response_postproc}},    //
	{CMD17      , {short_response_block_data_preproc, r1_response_read_data_postproc}},
	{CMD18      , {short_response_block_data_preproc, r1_response_read_data_postproc}},    //
	{CMD19      , {short_response_block_write_preproc_noac, r1_response_write_bstst_postproc}},
	{CMD20      , {short_response_stream_write_preproc, r1_response_write_data_postproc}},
	{CMD23      , {short_response_preproc, r1_response_postproc}},   //
	{CMD24      , {short_response_block_write_preproc, r1_response_write_data_postproc}},
	{CMD25      , {short_response_block_write_preproc, r1_response_write_data_postproc}},   //
    {CMD32      , {short_response_preproc, r1_response_postproc}},   //
   	{CMD33      , {short_response_preproc, r1_response_postproc}},   //
   	{CMD35      , {short_response_preproc, r1_response_postproc}},
   	{CMD36      , {short_response_preproc, r1_response_postproc}},
   	{CMD38      , {short_response_preproc, r1b_response_postproc}},   //
	{CMD39      , {short_response_rca_preproc, r4_response_postproc}},
	{ACMD41     , {short_response_preproc, short_response_postproc}},   //
	{ACMD42     , {short_response_sd_app_specific_data, r1_response_postproc}},   // new add comment
	{CMD42      , {short_response_block_write_preproc, r1b_response_write_data_postproc}},   //delete
	{ACMD51     , {short_response_sd_data_app_specific_data, r1_response_read_data_postproc}},
	{CMD52      , {short_response_preproc, r5_response_postproc}},
	{CMD53      , {short_response_block_data_preproc_noac, r5_response_read_data_postproc}},
	{CMD55      , {short_response_rca_preproc, short_response_postproc}},   //
	{ACMD6      , {short_response_sd_app_specific_data, r1_response_postproc}},
	{UNADD_CMD7 , {no_response_preproc, no_response_postproc}},
	{SD_CMD8    , {short_response_preproc, short_response_postproc}},
	{SD_CMD11   , {short_response_preproc_volt_switch_stage_1, short_response_postproc_volt_switch_stage_1}},
	{WCMD53     , {short_response_block_write_preproc_noac, r5_response_write_data_postproc}}
};
//39 table


/**
  * Finds the set of callbacks for the command index.
  * Performs a binary search on the statically defined the_callback_table.
  * @param[in] cmd_index The command index.
  * \return Returns the pointer to the callbacks if found. Returns NULL if not
  * found.
  * \todo This function has to be converted to a minimal perfect hash table search.
  * \callgraph
  */
static Callbacks *emmc_lookup_callback_table(u32 cmd_index)
// Callbacks *emmc_lookup_callback_table(u32 cmd_index)
{
	u32 num_commands = (sizeof(the_callback_table) / sizeof(callback_search_table)) -1;
	u32 left, right;
	u32 present_index;

	left = 0;
	right = num_commands;

  //  printf("emmc_lookup_callback_table num :%x \n" ,num_commands );

	while (left <= right) {
		present_index = left + (right - left) / 2;
 //		 printf("%s: %u %u %u\n",__FUNCTION__,left,present_index,right);  
		if (the_callback_table[present_index].cmd_index ==  cmd_index) {
			//printf("in emmc_lookup_callback_table left = %x,right = %x  \n" ,left, right );
			//printf("emmc_lookup_callback_table adder :%x \n" ,&(the_callback_table[present_index].the_callbacks) );
			return &(the_callback_table[present_index].the_callbacks);
		} 
        else if (cmd_index >  the_callback_table[present_index].cmd_index) {
			left = present_index + 1;
		} 
        else {
			right = present_index - 1;
		}
	}
   // printf("emmc_lookup_callback_table left = %x,right = %x  \n" ,left, right );
	return NULL;   
}

/** Looks up the table for a post processing callback for the cmd.
  * This function looks up the has table of function pointers to locate the
  * appropriate postprocessing callback for the index.
  * @param[in] cmd_index	The command which is to be sent on the bus.
  * \return The function pointer to the post processing function.
  * \callgraph
  */
emmc_postproc_callback emmc_get_post_callback(u32 cmd_index)
{
	emmc_postproc_callback retval = NULL;
	Callbacks *the_callbacks;
	//printf("the callback value is start *ly \n");
	the_callbacks = emmc_lookup_callback_table(cmd_index);
	if (!the_callbacks) {
		printf("the callback post value is 0! ly \n");
		return retval;
	}

	retval = the_callbacks->postproc;
	printf("the callback postproc adders  %x  \n",retval);
	return retval;
}

/** Looks up the table for a pre processing callback for the cmd.
  * This function looks up the has table of function pointers to locate the
  * appropriate postprocessing callback for the index.
  * @param[in] cmd_index. The command which is to be sent on the bus.
  * \return The function pointer to the pre processing function.
  */
emmc_preproc_callback emmc_get_pre_callback(u32 cmd_index)
{
	emmc_preproc_callback retval = NULL;
	Callbacks *the_callbacks;
	the_callbacks = emmc_lookup_callback_table(cmd_index);
	if (!the_callbacks) {
		printf("the callback pre value is 0! ly \n");
		return retval;
	}

	retval = the_callbacks->preproc;
	return retval;
}
/**
  * This function updates the current_task structure just before issuing the command.
  * This function complements the emmc_set_data_trans_params() function. The differnce being this function is called
  * following the emmc_set_data_trans_params() for all data transfer commands, but for non-data transfer commands, only
  * this function is called but not the emmc_set_data_trans_params() function.
  * @param[in] slot number to which card is connected.
  * @param[in] pointer to response buffer.
  * @param[in] pointer to data buffer.
  * @param[in] function pointer to completion callback routine.
  * \return returns void.
  * \callgraph
  */

void emmc_set_current_task_status(u32 slot, u32 * resp_buffer,
				      u8 * data_buffer,
				      emmc_postproc_callback
				      the_completion_callback)
{
	current_task.postproc_callback = the_completion_callback;
	current_task.resp_buffer = resp_buffer;
	printf("current_task.resp_buffer is %x \n",current_task.resp_buffer);
	current_task.data_buffer = data_buffer;
	current_task.slot_num = slot;
	/* If the error status is not updated, it would mean that the command has 
	   timed out and no response has been actually received from the card.
	 */
	current_task.error_status = 0;
	current_task.aborted_command = 0;
	current_task.cmd_status = TSK_STAT_STARTED;
	current_task.bus_corruption_occured = 0;
	printf("set current_task_status  ly\n");
	return;
}

/**
  * This function indicates whehter it is data transfer command.
  * This function checks the validity (Non-zero) of data_buffer pointer in current_task.
  * The IDMAC flow makes use of this to chose the flow for IDMAC mode or slave mode.
  * @param[in] slot number to which card is connected.
  * \return returns true if it is data_bufer is not NULL.
  * \callgraph
  */
s32 emmc_is_it_data_command(u32 slot)
{
    /* if current_task.data_buffer is not NULL, it is a data command. 
     * In case of not NULL return 1 else return 0
     * */
     if(current_task.data_buffer != NULL)
             return 1;
     else
             return 0;
}

/**
  * This function reads the INTMSK and returns the same.
  * @param[in] slot number to which card is connected.
  * \return returns INTMSK register contents.
  * \callgraph
  */
u32 emmc_get_slave_intmask_task_status(u32 slot)
{
        return(current_task.slave_mode_int_mask);
}
/**
  * This function returns The number of bytes read as updated in current_task structure's field.
  * @param[in] void.
  * \return returns number of bytes read.
  * \callgraph
  */
u32 emmc_last_bytes_read(void)
{
	return current_task.num_bytes_read;
}

/**
  * This function returns error status at that instance.
  * @param[in] void.
  * \return returns error status.
  * \callgraph
  */

u32 emmc_last_com_status(void)
{
	return current_task.error_status;
}
/**
  * This function returns the pointer to response buffer.
  * @param[in] void.
  * \return returns u8 pointer to response buffer.
  * \callgraph
  */

u32 *emmc_last_com_response(void)
{
	return current_task.resp_buffer;
}
/**
  * This function returns the data pointer at that instance.
  * @param[in] void.
  * \return returns u8 pointer to data buffer.
  * \callgraph
  */

u8 *emmc_last_com_data(void)
{
	return current_task.data_buffer;
}

/**
  * This function returns the last command status.
  * @param[in] void.
  * \return returns command status.
  * \callgraph
  */
u32 emmc_last_cmd_status(void)
{
	return current_task.cmd_status;
}
/**
  * This function indicates is there any bus corruption happened on the MMC bus.
  * @param[in] void.
  * \return returns True if bus corruption happened.
  * \callgraph
  */

u32 emmc_bus_corruption_present(void)
{
	return current_task.bus_corruption_occured;
}
/**
  * This function clears the current_task commmand status.
  * By assigning the current_task's cmd_status to TSK_STAT_ABSENT, this function ensures there are no
  * command pending to be handled. Once this function is invoked, the ISR just discards all the interrupts
  * (just clear the interrupt but not take any action).
  * @param[in] The card slot number to which card is connected
  * \return returns void.
  * \callgraph
  */
void emmc_remove_command(void)
{
	emmc_clear_bits(EMMC_REG_CTRL, INT_ENABLE);
	current_task.cmd_status = TSK_STAT_ABSENT;
	emmc_set_bits(EMMC_REG_CTRL, INT_ENABLE);
}

/**
  * This function sets up the transfer parameters.
  * the much of the data other than slot and data_buffer used only in case of slave mode of operation. 
  * For IDMAC mode of operation they just maintained to make the flow same as that of slave mode.
  * The command specific paramters  are set in the current_task structure. 
  * The parameters set here are 
  *	- The epoch count indicating the number of bytes read (for read operation) before entering this function. For write operation,
  *        it indicates the number of bytes already written in to the FIFO.
  *     - num_of_blocks of data to be read or writen to FIFO.
  *     - Function pointer to copy_func. This is just a place holder if a different function to be used for data transfer.
          If any valid pointer is passed here, it should not block as this function will be invoked from ISR top half.
  *     - Function pointer to terminate function. This is just a place holder not used at present.
          If any valid pointer is passed here, it should not block as this function will be invoked from ISR top half.
  *	- The slot number to which the command is intended to. 
  *	- data buffer for data transfer commands. This variable is used by ISR to invoke IDMAC functions or slave mode functions.
  *     - Block size for the current data transfer command
  * This fucntion updates the current_task structure by disabling the device interrupts.
  * \return returns void.
  * \callgraph
  */
void emmc_set_data_trans_params(u32 slot, u8 * data_buffer,
				    u32 num_of_blocks,
				    emmc_term_function
				    the_term_func,
				    emmc_copy_function the_copy_func,
				    u32 epoch_count, u32 flag,
				    u32 custom_blocksize)
{
	emmc_clear_bits(EMMC_REG_CTRL, INT_ENABLE);
	printf("EPOCH COUNT = %u\n", epoch_count);
	current_task.num_of_blocks = num_of_blocks;
	current_task.the_copy_function = the_copy_func;
	current_task.the_term_function = the_term_func;
	current_task.slot_num = slot;
	current_task.data_buffer = data_buffer;
	current_task.num_bytes_read = epoch_count;
	current_task.blksize = custom_blocksize;
	emmc_set_bits(EMMC_REG_CTRL, INT_ENABLE);
}

