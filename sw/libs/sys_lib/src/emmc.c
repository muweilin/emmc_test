
static char rcs_revision[] = "$Revision: #29 $";
static char rcs_datetime[] = "$DateTime: 2010/08/05 01:35:11 $";

#include <stdio.h>
#include "emmc.h"
#include "event.h"
#include "int.h"
#include "gpio.h"

 current_task_status current_task;
//current_task_status  *p =&current_task;
 Card_info *the_card_info;
 IP_status_info the_ip_status;


typedef void (*emmc_postproc_callback)(void *,u32 *) ;
typedef u32 (*emmc_term_function)(u8* buffer, u32 bytes_read);
typedef void* (*emmc_copy_function)(u32 *,u32 *,u32);


static u32 poll_demand_count = 0;


//////////interupt handler
u32 a;
//u32 cmd_tx_done=0;
int interrupt_already_done ;
int data_transfer_already_done;

u32 emmc_init_controller()
{
	u32 buffer_reg = 0;	/* multipurpose buffer register */
	u32 num_of_cards, fifo_thresh;
	s32 retval = 0;
	memset((void *) &the_ip_status, 0, sizeof(the_ip_status));

       //set cclk_in (ciu_clk)
	
        emmc_set_register(EMMC_REG_UHS_REG_EXT,0xC1020000);   //ext_clk_div 8, clk_2x = 100Mhz, clk_in = 25Mhz, clk_drv and clk_sample delay 4 clk_2x, 
        printf(" Value of EMMC_REG_UHS_REG_EXT : %x .\n", emmc_read_register(EMMC_REG_UHS_REG_EXT));
	    emmc_set_bits(EMMC_REG_GPIO,0x00000100);  //open cclk_in
    
        while(1){
    	   if(L_EMMC_REG_GPIO & 0X00000001 == 1)
                printf("clk_in open. \n");
    		break;
            };

	plat_delay(100);

	/*Befoer proceeding further lets reset the host controller IP
	  This can be achieved by writing 0x00000001 to CTRL register*/
	  buffer_reg = 0x00000001;    //controller_reset
	  emmc_set_bits(EMMC_REG_CTRL,buffer_reg);
	  
	  plat_delay(1000);

	  /* Now make CTYPE to default i.e, all the cards connected will work in 1 bit mode initially*/
	  //buffer_reg = 0xffffffff;
	  //emmc_set_bits(EMMC_REG_CTYPE,buffer_reg);     // 1_bit  mode  
	  
	  
	/* No. of cards supported by the IP */
	buffer_reg = emmc_read_register(EMMC_REG_HCON);     //hardware configuration register 
        the_ip_status.num_of_cards = 1;
	
	emmc_set_register(EMMC_REG_RINTSTS, 0xffffffff);	
	buffer_reg = INTMSK_ALL_ENABLED & ~INTMSK_ACD;
	emmc_set_register(EMMC_REG_INTMSK, buffer_reg);
	emmc_set_bits(EMMC_REG_CTRL, INT_ENABLE);           //open globle int enable

	/* Set Data and Response timeout to Maximum Value*/
	emmc_set_register(EMMC_REG_TMOUT, 0xffffffff);
    
	/* Enable the clocks to the all connected cards/drives
	   - Note this command is to CIU of host controller ip
	   - the command is not sent on the command bus
	   - it emplys the polling method to accomplish the task
	   - it also emplys wait prev data complete in CMD register	
        */
	u32 clock_val;
//	clock_val = (1 << the_ip_status.num_of_cards) - 1 ;	
        clock_val = 1;
        emmc_set_register(EMMC_REG_CLKSRC, 0);
        emmc_set_register(EMMC_REG_CLKDIV, 15);  //set clk_div 63, fout = 400k
        emmc_set_register(EMMC_REG_CLKENA, clock_val);
	printf("EMMC_REG_CLKDIV is %x\n",L_EMMC_REG_CLKDIV);
	emmc_send_clock_only_cmd();  //only update CLKDIV CLKSRC CLKENA

	printf("CLK updata complete.\n");

	/* Set the card Debounce to allow the CDETECT fluctuations to settle down*/	
	emmc_set_register(EMMC_REG_DEBNCE, DEFAULT_DEBNCE_VAL);

	/* update the global structure of the ip with the no of cards present at this point of time */
	the_ip_status.present_cdetect = emmc_read_register(EMMC_REG_CDETECT);
    printf("emmc_cdetect is %x \n",the_ip_status.present_cdetect);
	/* Update the watermark levels to half the fifo depth
	   - while reset bitsp[27..16] contains FIFO Depth
	   - Setup Tx Watermark
	   - Setup Rx Watermark
        */
	fifo_thresh = emmc_read_register(EMMC_REG_FIFOTH);
	printf("FIFOTH read from Hardware = %08x\n",fifo_thresh);
	fifo_thresh = GET_FIFO_DEPTH(fifo_thresh) / 2;
	the_ip_status.fifo_depth = fifo_thresh * 2;
	printf("FIFO depth = %x\n", the_ip_status.fifo_depth);
	the_ip_status.fifo_threshold = fifo_thresh;
	/* Tx Watermark */
	emmc_clear_bits(EMMC_REG_FIFOTH, 0xfff);
	emmc_set_bits(EMMC_REG_FIFOTH, fifo_thresh);
	/* Rx Watermark */
	emmc_clear_bits(EMMC_REG_FIFOTH, 0x0fff0000);
	emmc_set_bits(EMMC_REG_FIFOTH, (fifo_thresh-1) << 16);

	/* Enumerate the cards connected */
	emmc_enumerate_card_stack(num_of_cards);

	return retval;
}

u32 emmc_enumerate_card_stack(u32 num_of_cards)
{
	u32 counter;
	/* Lets start Enumerating every card connected at the power up time */
	for (counter = 0; counter < the_ip_status.num_of_cards; counter++) {
		printf("Enumerating slot %x\n", counter);
		/*
		Start enumeration of each card individually with initializing the card info with 
		card state empty (-1) for card_state and 
		card not connected state for enumeration state
		*/
		the_card_info[counter].card_state = CARD_STATE_EMPTY;  //-1
		the_card_info[counter].enum_status = ERRCARDNOTCONN;   //1
		
		emmc_enumerate_the_card(counter);
	}

	return 0;
}

/**
  * Enumerates the specified card.
  * This function determines the type of card in the specified slot and calls 
  * the respective enumeration function for the type of card.
  * @param[in] slot_num The slot number which has to be enumerated.
  * \return Returns 0 upon successful enumeration. Error status upon error.
  */
u32 emmc_enumerate_the_card(u32 slot_num)
{
	Card_Type type;
	u32 retval = 0;
	
	/*
	To start with, without knowing what kind of card/drive start enumeration with the lowest clk
	So configure the divider value accordingly. this is the function of cclk_in of host IP.
	*/
	//the_card_info[slot_num].divider_val = MMC_FOD_DIVIDER_VALUE;   //((CIU_CLK/(MMC_FOD_VALUE*2))+1)
    //	the_card_info[slot_num].divider_val = MMC_FOD_DIVIDER_VALUE;   //((CIU_CLK/(MMC_FOD_VALUE*2))+1)=201
    the_card_info[slot_num].divider_val = 15;

	/*Lets start with the single bit mode initially*/
	emmc_clear_bits(EMMC_REG_CTYPE, ((1<<slot_num) | (1<<(slot_num + 16)))); //1bit mode

    
	/*Get the card type by connected to this particular slot and update the card information
	  Lets make the enum_status zero just a hack since the function emmc_send_serial_command 
	  checks for enum_status */
	the_card_info[slot_num].enum_status = 0;

//	printf("before emmc_get_card_type the CTYPE value : %x \n",L_EMMC_REG_CTYPE );  //0
    
	type = emmc_get_card_type(slot_num);
	
	printf("MAHOO got card type as %x\n", type);
	the_card_info[slot_num].card_type = type;

	/*
	I dont understand why enum_status ERRCARDNOTCONN even after card detected???
	*/
	the_card_info[slot_num].enum_status = ERRCARDNOTCONN;      //????ly
	
	switch (type) {
	case SD_TYPE:
        printf("SD FOUND AT SLOT %x\n", slot_num);
		retval = emmc_reset_sd_card(slot_num);
		if(retval)
		printf("SD MEM reset returned the error %x\n", retval);
		break;
	case SD_MEM_2_0_TYPE:
		printf("SD2.0 FOUND AT SLOT %x\n", slot_num);
		retval =  emmc_reset_sd_2_0_card(slot_num);
		if(retval == ERRENUMERATE){
			printf("ERROR in SD2.0 Enumeration: Card could be a SDSC Card\n");
            //The Host controller is programmed to work in higher frequency. But enumeration should 
            //take place in 400KHZ. Modify the CLKDIV value to SD enumerate Frequency
            //emmc_set_clk_freq(SD_FOD_DIVIDER_VALUE);
		}
		if(retval)
		printf("SD_MEM_2_0 reset returned the error %x\n", retval);
		break;
	case SDIO_TYPE:
		printf("SDIO FOUND AT SLOT %x\n", slot_num);
		retval = emmc_reset_sdio_card(slot_num);
		if(retval)
		printf("SDIO reset returned the error %x\n",retval);
		break;

	case NONE_TYPE:
		printf("NO DEVICE AT SLOT %x\n", slot_num);
		retval = ERRNOTSUPPORTED;
		break;
	case ERRTYPE:
	default:
		printf("BAD CARD FOUND AT SLOT %x\n", slot_num);
		return ERRENUMERATE;
	}

	return retval;
} 
/**
  * Determine the card type in the slot.
  * This function determines emmc_set_sd_wide_busthe card type in the slot. The steps for doing so
  * are as follows:
  *	-# Send a CMD5 to the slot. If a response is received, it is a SDIO card
  *	-# Send ACMD41 + CMD55 combo to the slot. If a response is received, 
  *	it is a SD card.
  *	-# Get it to TRANS state and fire a CMD60. If a reply is got, it is a
  *	CE-ATA
  *	device
  *	-# If not, it is a MMC card.
  *
  *	@param[in] slot The index of the slot in which the card is in.
  *	\return Returns the card type found.
  */
Card_Type emmc_get_card_type(u32 slot)
{
	u32 buffer_reg, retval;
	u32 resp_buffer[4];
	
	/*Read the CDETECT bit 0 => card connected. Note this is not true for CEATA so you find a hack in the emmc_read_register() */
	buffer_reg = emmc_read_register(EMMC_REG_CDETECT);
	if ((buffer_reg & (1 << slot))) {    // 0 represent presence of card
		return NONE_TYPE;
	}
	/*
	Clear the CTYPE register bit for of IP. This bit indicates whether the card connected is 8/4/1 bit card
	*/
	emmc_clear_bits(EMMC_REG_CTYPE, (1 << slot));
	
	/*Send the CMD5 to see whether the card is SDIO type. If success declare a SDIO*/
  
	printf("Sending CMD5 to slot %x\n", slot);
	retval = emmc_send_serial_command(slot, CMD5, 0, NULL, NULL, 0, NULL, NULL);
   
	if (!retval) {
		/* Found an SDIO card */
		printf("2 SDIO_TYPE CArd in the slot \n" );
		return SDIO_TYPE;
	}

	printf("retval = %x\n", retval);//25  
	if (retval != ERRRESPTIMEOUT) {
		//return ERRTYPE;
		printf("3 ERRTYPE CArd in the slot \n" );

	}
	else {
		printf("CMD5 has timed out...\n");
	}
   
	/* If we have reached here the card is not SDIO type => so it is MEM type
	   Issue cmd0 before proceeding to detect SDmem as per SPEC. 
         */
    printf("Sending SD_CMD0 to slot %x\n", slot);
	//while(1)
	//{
	//	emmc_send_serial_command(slot, CMD0, 0, NULL, NULL, 0,  NULL, NULL);
	//}

	if ((retval = emmc_send_serial_command(slot, CMD0, 0, NULL, NULL, 0,  NULL, NULL))) {
	//	return ERRTYPE;
		printf("  After send cmd0 %d\n", retval);
	}
	

	/*
	 Before Sending ACMD41 send CMD8 SEND_IF_COND to the card to see if it is an SD2.0 type
	 Card checks the validity of operating condition by analyzing the argument of CMD8
	 Host checks the validity by analyzing the response of CMD8. Note that argumnet passed is
  	 VHS=1 => 2.7 to 3.3 volts and Check pattern = 0xAA 
	*/	
    
    

	printf("Sending CMD8 to slot %x\n", slot);
	retval = emmc_send_serial_command(slot, CMD8, 0x000001AA, resp_buffer, NULL, 0,  NULL, NULL);

	if (!retval) {
		 /* Found an SD_2.0 Card */
		printf("CMD8 received the response:%x\n",resp_buffer[0]);
		return SD_MEM_2_0_TYPE;
	}
	printf("retval = %x\n", retval);
	if (retval != ERRRESPTIMEOUT) {
		return ERRTYPE;
	}
	else {
		printf("CMD8 has timed out !!!!!!\n");
	}

	/*
	Since CMD8 has timed out it is not SD_MEM_2_0_TYPE..... Continue your card detection procedure..
	*/
	


	/* Lets Issue ACMD41 to see whether it is SDMEM. CMD55 should preced andy ACMD command
	   If nonzero response to CMD55 => the card is not an SD type so move to detect whether it is MMC?    
	*/
	
	printf("Sending CMD55 to slot %x\n", slot);
	if ((retval = emmc_send_serial_command(slot, CMD55, 0, NULL, NULL, 0, NULL, NULL))) {
		//goto CONT_MMC;
		//return ERRTYPE;   //ly
		printf("CMD55  failied!!!!!!!\n");
	}
   
	/*
	CMD55 is successful, so send ACMD41 to get the OCR from SD card. If success Declare a SD card
	*/
	printf("Sending ACMD41 to slot %x\n", slot);
	retval =  emmc_send_serial_command(slot, ACMD41, 0, NULL, NULL, 0, NULL, NULL);
	if (!retval) {
		/* Found an SD card */
		return SD_TYPE;
	}
	if (retval != ERRRESPTIMEOUT) {
		return ERRTYPE;
	}
	else {
		printf("ACMD41 has timed out...\n");
	}

}


void ISR_EMMC () 
{
		
static int data_flag_kludge = 0;
u32 cmd_status;
 
 //printf("Entering interrupt!!!! RINTSTS: %x \n",L_EMMC_REG_RINTSTS);
 printf("ISR.RINTSTS:0x%08x CMD_STATUS:%u ERROR_STATUS:%u\n",L_EMMC_REG_RINTSTS, current_task.cmd_status, current_task.error_status); 
		if (TSK_STAT_ABSENT != current_task.cmd_status) {
				   current_task.postproc_callback(&current_task, EMMC_REG_RINTSTS);
		    	printf("After_callback:CMD_STATUS:%u ERROR_STATUS:%u\n", current_task.cmd_status, current_task.error_status);

				    if (current_task.error_status) {
								interrupt_already_done = 1;
					       if(current_task.cmd_status == TSK_COMMAND_DONE){ //Command done has already came and error is set. So clean up the interrupt status
						        emmc_reset_fifo(); //FIFO is flushed to avoid RXDR and TXDR Interrupts in Slave mode of operation
							// goto FINISH;  //Wait Till Command Done Interrupt
							    //printf("RINTSTS now is : %08x\n",L_EMMC_REG_RINTSTS);
						        emmc_set_register(EMMC_REG_RINTSTS, 0xFFFFFFFF);
					        //	synopmob_set_register(EMMC_REG_IDSTS,  0xFFFFFFFF);
						    }
					}

					/* the interrupt could be for the read/write data */
				cmd_status = current_task.cmd_status;
		    	if ((!data_flag_kludge) && ((TSK_STATE_READDAT == cmd_status)||(TSK_STATE_WRITEDAT == cmd_status))) {
			    	data_flag_kludge = 1;
				}
					/*
		        		If command status is TSK_COMMAND_DONE then wake up the main thread which is waiting...
				        Make the command status TSK_STAT_ABSENT as nothing  needs  to be done 
		    			*/
			
			    if (TSK_COMMAND_DONE == current_task.cmd_status) {
				    		/* Schedule back the task waiting on  this interrupt */
						interrupt_already_done = 1;
						if (data_flag_kludge) {
							data_transfer_already_done = 1;
							data_flag_kludge = 0;
						}
					current_task.cmd_status = TSK_STAT_ABSENT;
						//emmc_enable_command_tasks();
			    }

		}
					
		else{
				//TSK_STAT_ABSENT but interrupts getting generated!!! One reason could be RXDR or TXDR interrupts Clear them and reset the fifo
				//printf("After_callback:MINTSTS:0x%08x CMD_STATUS:%u ERROR_STATUS:%u\n",L_EMMC_REG_RINTSTS, current_task.cmd_status, current_task.error_status);
				emmc_reset_fifo(); //FIFO is flushed to avoid RXDR and TXDR Interrupts in Slave mode of operation
				emmc_set_register(EMMC_REG_RINTSTS, 0xFFFFFFFF);			
				//#ifdef IDMAC_SUPPORT
			      //            synopmob_set_register(IDSTS, 0xFFFFFFFF); // Clear IDMAC interrupts
				//#endif
			}

   
 emmc_set_register(EMMC_REG_RINTSTS,0xFFFFFFFF);  //clear int
 ICP = (1 << 15);

}



/**
  * Set the particular bits of the specified register.
  * @param[in] reg	The particular register to which the bits are to be set
  * @param[in] val	The bitmask for the bits which are to be set.
  * \return 	The new value of the register
  */
u32 emmc_set_bits(u32 reg, u32 val)
{
	u32 *reg_addr ;
	reg_addr  = (u32 *)(reg) ;

	*reg_addr |= val ;
	return *reg_addr ;
}


/**
  * Clear the particular bits of the specified register.
  * @param[in] reg	The particular register to which the bits are to be cleared.
  * @param[in] val	The bitmask for the bits which are to be cleared.
  * \return 	The new value of the register
  */
u32 emmc_clear_bits(u32 reg, u32 val)
{
	u32 *reg_addr ;
	reg_addr  = (u32 *)(reg) ;

	*reg_addr &= (~val) ;
	return *reg_addr ;
}


u32 emmc_set_register(u32 reg, u32 val)
{
	
	u32  *reg_addr ;
	reg_addr  = (u32 *)(reg) ;

	*reg_addr = val ;
	
/*
	*(volatile u32*) (reg) = val ;
*/
	return 0 ;
}

/**
  * Read the value of the specified register.
  * @param[in] reg	The particular register which is to be read. 
  * \return 	The value of the register
  */

u32 emmc_read_register(u32 reg)
{
	
	 u32 *reg_addr ;
	u32 retval;
	
	reg_addr  = (u32 *)( reg) ;
	retval = *reg_addr;

	return retval ;

}


//////////////////////////////////////////////////////////////
void emmc_plat_disable_interrupts(u32 * buffer)
{

	/* We could disable all interrupts on the board or we could disable only the
	   host controller interrupt. Disabling the host control interrupt would be 
	   a better idea. 
	 */
	emmc_clear_bits(EMMC_REG_CTRL, INT_ENABLE);

}

/**
  * Enable the host controller interrupt.
  * @param[in] buffer Buffer pointer to restore the interrupt mask which might have been removed when plat_disable_interrupts was called.
  * \return Returns void.
  * 	
  */
void emmc_plat_enable_interrupts(u32 * buffer)
{
	emmc_set_bits(EMMC_REG_CTRL, INT_ENABLE);
}



void emmc_send_raw_command(u32 slot, u32 cmd, u32 arg)
{
	u32 buff_cmd;
	buff_cmd = cmd | CMD_DONE_BIT;
	SET_CARD_NUM(buff_cmd, slot);
	printf("SENDING RAW Command 0x%08x:0x%08x\n", buff_cmd, arg);
	emmc_execute_command(buff_cmd, arg);
	return;
}

u32 emmc_execute_command(u32 cmd_register, u32 arg_register)
{
	emmc_set_register(EMMC_REG_CMDARG, arg_register);
	emmc_set_register(EMMC_REG_CMD, cmd_register | CMD_HOLD_REG);     
	return (emmc_poll_cmd_register());
}

/*
This function is a blocking function. it reads the CMD register for CMD_MAX_RETRIES to
see if the CMD_DONE_BIT is set to 0 by CIU 
*/

u32 emmc_poll_cmd_register(void)
{
	while (1) {
	if ((L_EMMC_REG_CMD & CMD_DONE_BIT) == 0) {
            printf("CMD_DONE_BIT clear. value of EMMC_REG_CMD: %x \n", L_EMMC_REG_CMD);
			break;
	    }
        plat_delay(1000);
	 }
	
	return 0;

}
////////////////////////////////////////////////////////////////////
/** 
  * This function aborts any data transfer that might be happening. This 
  * function can be called from interrupt context also since it uses
  * emmc_send_raw_command to dispatch the command on the bus.
  * @param[in] slot The slot to which the command is to be sent.
  */
void emmc_abort_trans_work(u32 slot)
{
	/* Send a raw command */
	emmc_send_raw_command(slot, CMD12 | CMD_RESP_EXP_BIT | CMD_ABRT_CMD_BIT, 0);

}

/////////////////////////////////////////////////////////////////////
/**
  * Sends the clock only command.
  * This function loads the clock settings to the card. Does not pass
  * an messages to the card.
  *
  * \return 0 upon success. Error status upon failure.
  */
u32 emmc_send_clock_only_cmd(void)
{
	return emmc_execute_command(CLK_ONLY_CMD |
					CMD_WAIT_PRV_DAT_BIT | CMD_HOLD_REG, 0);
}

u32 emmc_send_clock_only_cmd_for_volt_switch(void)
{
	return emmc_execute_command(CLK_ONLY_CMD | CMD_VOLT_SW_BIT | CMD_HOLD_REG, 0);
}


/**
  * Disables all clocks to the controller.
  */
u32 emmc_disable_all_clocks(void)
{
	emmc_set_register(EMMC_REG_CLKENA, 0);
	return emmc_send_clock_only_cmd();    //CIU not return 0 so divsion is not complement    lly
	//return 0;    //ly
}

u32 emmc_enable_clocks_with_val(u32 val)
{
	emmc_set_register(EMMC_REG_CLKENA, val);
	return emmc_send_clock_only_cmd();
	//return 0;    //ly
}



/**
  * Sets the divider for the clock in CIU.
  * This function sets a particular divider to the clock.
  * @param[in] divider The divider value.
  * \return 0 upon success. Error code upon failure.
  */
u32 emmc_set_clk_freq(u32 divider)
{
	u32 orig_emmc_CLKENA;
	u32 retval;

	if (divider > MAX_DIVIDER_VALUE) {
		return 0xffffffff;
	}

	/* To make sure we dont disturb enable/disable settings of the cards*/
	orig_emmc_CLKENA = emmc_read_register(EMMC_REG_CLKENA);

	/* Disable all clocks before changing frequency the of card clocks */
	if ((retval = emmc_disable_all_clocks())) {
		return retval;
	}
	printf("disable ok..\n");
	/* Program the clock divider in our case it is divider 0 */
	emmc_clear_bits(EMMC_REG_CLKDIV, MAX_DIVIDER_VALUE);      
	emmc_set_bits(EMMC_REG_CLKDIV, divider);
	printf("EMMC_REG_CLKDIV is %x\n",L_EMMC_REG_CLKDIV);
	/*Send the command to CIU using emmc_send_clock_only_cmd and enable the clocks in emmc_CLKENA register */
	if ((retval = emmc_send_clock_only_cmd())) {         //////////////   
		emmc_enable_clocks_with_val(orig_emmc_CLKENA);
		return retval;
	}

	return emmc_enable_clocks_with_val(orig_emmc_CLKENA);
}


/**
  * This function dumps the DWC_Mobstor register for debugging.
  * This is useful for debugging. 
  * \param[in] void.
  * \return Returns Void
  */

void emmc_dump_registers(void)
{
	printf("CTRL     : %08x\n", emmc_read_register(EMMC_REG_CTRL));
	printf("PWREN    : %08x\n", emmc_read_register(EMMC_REG_PWREN));
	printf("CLKDIV   : %08x\n", emmc_read_register(EMMC_REG_CLKDIV));
	printf("CLKSRC   : %08x\n", emmc_read_register(EMMC_REG_CLKSRC));
	printf("CLKENA   : %08x\n", emmc_read_register(EMMC_REG_CLKENA));
	printf("TMOUT    : %08x\n", emmc_read_register(EMMC_REG_TMOUT));
	printf("CTYPE    : %08x\n", emmc_read_register(EMMC_REG_CTYPE));
	printf("BLKSIZ   : %08x\n", emmc_read_register(EMMC_REG_BLKSIZ));
	printf("BYTCNT   : %08x\n", emmc_read_register(EMMC_REG_BYTCNT));
	printf("INTMSK   : %08x\n", emmc_read_register(EMMC_REG_INTMSK));
	printf("RESP0    : %08x\n", emmc_read_register(EMMC_REG_RESP0));
	printf("RESP1    : %08x\n", emmc_read_register(EMMC_REG_RESP1));
	printf("RESP2    : %08x\n", emmc_read_register(EMMC_REG_RESP2));
	printf("RESP3    : %08x\n", emmc_read_register(EMMC_REG_RESP3));
	printf("MINTSTS  : %08x\n", emmc_read_register(EMMC_REG_MINTSTS));
	printf("RINTSTS  : %08x\n", emmc_read_register(EMMC_REG_RINTSTS));
	printf("STATUS   : %08x\n", emmc_read_register(EMMC_REG_STATUS));
	printf("FIFOTH   : %08x\n", emmc_read_register(EMMC_REG_FIFOTH));
	printf("CDETECT  : %08x\n", emmc_read_register(EMMC_REG_CDETECT));
	printf("WRTPRT   : %08x\n", emmc_read_register(EMMC_REG_WRTPRT));
	printf("GPIO     : %08x\n", emmc_read_register(EMMC_REG_GPIO));
	printf("TCBCNT   : %08x\n", emmc_read_register(EMMC_REG_TCBCNT));
	printf("TBBCNT   : %08x\n", emmc_read_register(EMMC_REG_TBBCNT));
	printf("DEBNCE   : %08x\n", emmc_read_register(EMMC_REG_DEBNCE));
	printf("USRID    : %08x\n", emmc_read_register(EMMC_REG_USRID));
	printf("VERID    : %08x\n", emmc_read_register(EMMC_REG_VERID));

	printf("BMOD     : %08x\n", emmc_read_register(EMMC_REG_BMOD));
	printf("PLDMND   : %08x\n", emmc_read_register(EMMC_REG_PLDMND));
	printf("DBADDR   : %08x\n", emmc_read_register(EMMC_REG_DBADDR));
	printf("IDSTS    : %08x\n", emmc_read_register(EMMC_REG_IDSTS));
	printf("IDINTEN  : %08x\n", emmc_read_register(EMMC_REG_IDINTEN));
	printf("DSCADDR  : %08x\n", emmc_read_register(EMMC_REG_DSCADDR));
	printf("BUFADDR  : %08x\n", emmc_read_register(EMMC_REG_BUFADDR));

	printf("HCON     : %08x\n", emmc_read_register(EMMC_REG_HCON));
}

void plat_delay(u32 delay_value)
{
    volatile u32 d;
    for(d = 0; d < delay_value; d++) asm volatile("nop");
}







void plat_disable_interrupts(int_register * buffer){

	/* We could disable all interrupts on the board or we could disable only the
	   host controller interrupt. Disabling the host control interrupt would be 
	   a better idea. 
	 */
	emmc_clear_bits(EMMC_REG_CTRL, INT_ENABLE);

}


/**
  * Enable the host controller interrupt.
  * @param[in] buffer Buffer pointer to restore the interrupt mask which might have been removed when plat_disable_interrupts was called.
  * \return Returns void.
  * 	
  */
void plat_enable_interrupts(int_register * buffer)
{
	emmc_set_bits(EMMC_REG_CTRL, INT_ENABLE);
}


u32 emmc_send_serial_command(u32 slot, u32 cmd_index, u32 arg,
			     u32 * response_buffer, u8 * data_buffer,
			     u32 flags,
			     emmc_preproc_callback custom_preproc,
			     emmc_postproc_callback custom_postproc)
{

	int_register reg;
	u32 status,buffer1,buffer1_virt,buffer2,buffer2_virt;
	u32 retval = 0, retval2 = 0;
	s32 delay_for_command_done_check = 10000;
	//printf("Entered %s Flags = %x\n", __FUNCTION__,flags);

	/*
	If card is not connected or the enum_status not zero return saying card not connected
	*/
	if (emmc_read_register(EMMC_REG_CDETECT) & (1 << slot)) {
		printf("Card not connected\n");
		return ERRCARDNOTCONN;
		
	}
	
	if (the_card_info[slot].enum_status) {
		printf("send serial command's responds is ERRCARDNOTCONN \n");  //not in
		return ERRCARDNOTCONN;		
	}


	/* Disable the host controller interrupt before sending the command on the line to the card
	   Enable the interrupts once the command sent to the card */
	plat_disable_interrupts(&reg);

//	printf("send emmc_form_n_send_cmd !\n");

	retval = emmc_form_n_send_cmd(slot, cmd_index, arg,
					  response_buffer, data_buffer,
					  flags, custom_postproc,
					  custom_preproc);

//	printf("emmc_form_n_send_cmd responds value is %x\n", retval );    //0
	plat_enable_interrupts(&reg);

	if (retval) {		//retval=0
		return retval;  
	}


	/* Put myself to be scheduled from either interrupt context or from the timeout.
	   I am following this paradigm since I am thinking in Unix space. I am however 
	   presuming that this will hold true for any other kernel.
	   Now this thread gets blocked till we receive an interrupt or timeouts
	 */
   
	if ((plat_reenable_upon_interrupt_timeout())) {     //timeout   lly
		printf("CMD%x did not receive any interrupt(1) even after %x seconds\n",cmd_index,CMD_RESP_TIMEOUT);
		retval = ERRTIMEROUT;  //37
	}

	/* If there is a size for the data supplied in the flags, wait for it
	   TODO: Calculate the latency of the transfer.
	 */
	

	if (flags && (!(emmc_last_com_status()))) {

		if ((ERRTIMEROUT == retval) && (the_card_info[slot].card_type != CEATA_TYPE)) {
			emmc_remove_command();/*Lets make the command status as TASK_STAT_ABSENT*/
			emmc_abort_trans_work(slot);
			plat_delay(200);/*This delay is required as the above function doesnot block*/
		}

	}
	
//	printf("%s: lastcom status After ISR = %x flags = %x\n", __FUNCTION__, emmc_last_com_status(), flags);


	/*
	   We have been scheduled back again. Now check the error status of the command. For non zero error status 
	   set command status as TSK_STAT_ABSENT 
	 */

	if ((retval2 = emmc_last_com_status())) {
		emmc_remove_command();
	}

	//plat_set_cmd_over();    //kener  cmd   互斥   lly 
	
	printf("Leaving (%x %x %d)\n", retval, retval2, cmd_index);

	return (retval ? retval : retval2);
}



/*
This function is used to form the command with the parameters sent to this
 - registers the post_callback
 - registers the pre_callback
 - calls the pre-callback
 - programs the clk divider for the host ip
 - handles the sending task to the function emmc_cmd_to_host
 @param[in] card_num 
 @param[in] cmd_index 
 @param[in] cmd_arg 
 @param[in] resp_buffer 
 @param[in] data_buffer 
 @param[in] flags 
 @param[in] custom_callback
 @param[in] custom_preproc
      
*/

u32 emmc_form_n_send_cmd(
				 u32  card_num,
			     u32  cmd_index,
			     u32  cmd_arg,
			     u32 *resp_buffer,
			     u8  *data_buffer,
			     u32  flags,
			     emmc_postproc_callback  custom_callback,
			     emmc_preproc_callback  custom_preproc)
{

	u32 cmd_register = 0;
	emmc_postproc_callback post_callback = NULL;
	emmc_preproc_callback preproc_fn = NULL;
	u32 arg_register = cmd_arg;
	/* First time make the previous divider a maximum value.*/
	static u32 previous_divider = 0xffffffff;
	/* whether post_callback is from table or custom_callback? */


	if (!custom_callback) {
	//	printf("1 custom_callback is null \n");
		post_callback = emmc_get_post_callback(cmd_index);
	} else {
		post_callback = custom_callback;

	}

	if (!post_callback) {
		printf("ERRNOTSUPPORTED! CMD%x Command is not supported!\n", cmd_index);
		return ERRNOTSUPPORTED;

	}

	/* whether preproc_callback is from table or custom_preproc? */
	if (!custom_preproc) {
	//	printf("2 custom_callback is null \n");
		preproc_fn = emmc_get_pre_callback(cmd_index);
	} else {
		preproc_fn = custom_preproc;
	}

	/*execute the preproc_fn to prepare the command: this function populates 
	  the cmd_register and arg_register*/
	if (preproc_fn) {
	//	printf("3 custom_callback is function *preproc_fn* function  \n");
		preproc_fn(card_num, cmd_index, &cmd_register, &arg_register);    
	} else {
		printf("CMD%x Command is not supported!\n", cmd_index);
		return ERRNOTSUPPORTED;
	}


	/* Set the frequency for the card and enable the clocks for appropriate cards */
	if (previous_divider != the_card_info[card_num].divider_val) {
		previous_divider = the_card_info[card_num].divider_val;
		printf("previous_divider is %x\n",previous_divider);
		emmc_set_clk_freq(the_card_info[card_num].divider_val);
	}
  
	//printf("clk not set ! ly \n");
	current_task.command_index = cmd_index; 
	return emmc_cmd_to_host(card_num, cmd_register, arg_register,resp_buffer, data_buffer,post_callback, flags);
}

/**
  * This sends the command after taking the lock. The lock is released from ISR.
  * This forms the CMD and CMDARG and calls emmc_execute_command which sends 
  * the command and polls for CMD_DONE_BIT to see if it is 0
  * For IDMAC mode of operation, setup the IDMAC related registers, and
  * setup the flag idma_mode_on to indicate the ISR that the present transfer
  * uses IDMAC flow rather than Slave mode flow.
  */

u32 emmc_cmd_to_host(u32 slot,
			 u32
			 cmd_register,
			 u32
			 arg_register,
			 u32 *
			 resp_buffer,
			 u8 *
			 data_buffer,
			 emmc_postproc_callback the_callback,
			 u32 flags)
{

	//printf("Need take the lock before sending the command on line **ly** plat_is_cmd_in_progress()\n");


	printf("Sending Command : 0x%08x:0x%08x\n", cmd_register, arg_register);

	/* update the task status with call back, response buffer, 
	   data buffer,error_status,cmd_status,bus_corruption_occured,...
	*/
	emmc_set_current_task_status(slot, resp_buffer, data_buffer, the_callback);
	
	/*Set the CMD_DONE_BIT to initiate the command sending, CIU clears this bit */
	SET_BITS(cmd_register, CMD_DONE_BIT);    //cmd start info
	
	printf("CMD: %08x CMDARG:%08x\n", cmd_register,arg_register);	
//	emmc_dump_registers();		
	/* Execute the command and wait for the command to execute */
//	printf("Left %s\n", __FUNCTION__);
	return emmc_execute_command(cmd_register, arg_register);
}



/**  Handler for standard interrupts.
  This function handles all non command related interrupts which
  are to be handled. This function will be invoked in interrupt 
  context.
 */
void emmc_handle_standard_rinsts(void *prv_data, u32 int_status)   //rintsts:Raw Interrupt status reg
{
	u32 raw_int_stat = int_status;
	current_task_status *the_task_stat =  (current_task_status *) prv_data;

//printf("Entering handle rinsts,the_task_stat->cmd_status  is %d,int_status is %x \n",the_task_stat->cmd_status,raw_int_stat);

	if (raw_int_stat & INTMSK_CMD_DONE) {
		the_task_stat->cmd_status = TSK_COMMAND_DONE;
	}

	/** It is important to place resptimeout first 
	    since there are a few commands for which a 
	    timeout is not an error condition
	 **/
	if (raw_int_stat & INTMSK_RTO) {                 //0x00000100
		the_task_stat->error_status = ERRRESPTIMEOUT;
	}

	if (raw_int_stat & INTMSK_EBE) {
		the_task_stat->error_status = ERRENDBITERR;
	}

	if (raw_int_stat & INTMSK_RESP_ERR) {
		/* We have a problem with the response reception */
		the_task_stat->error_status = ERRRESPRECEP;
	}

	if (raw_int_stat & INTMSK_RCRC) {
		/* We have a problem with the response reception */
		the_task_stat->error_status = ERRRESPRECEP;
	}

	/* Check the data and and fifo interrupts */
	if (raw_int_stat & INTMSK_FRUN) {
		the_task_stat->error_status = ERROVERREAD;
	}

	if (raw_int_stat & INTMSK_HTO) {
		the_task_stat->error_status = ERRUNDERWRITE;
	}

	if (raw_int_stat & INTMSK_DCRC) {
		the_task_stat->error_status = ERRDCRC;
	}

	if (raw_int_stat & INTMSK_SBE) {
		the_task_stat->error_status = ERRSTARTBIT;
	}

	return;
}

void emmc_handle_standard_idsts(void * prv_data, u32 int_status)   //idst:internal DMA status reg
{
	u32 idsts_stat = int_status;
	current_task_status *the_task_stat =  (current_task_status *) prv_data;

    if (idsts_stat & IDMAC_FBE) {
		the_task_stat->error_status = ERRIDMACFBE;   // Fatal Bus Error
        	emmc_set_bits(EMMC_REG_IDSTS, IDMAC_FBE);
		printf("FATAL BUS ERROR in IDMAC mode\n");
	}
    if (idsts_stat & IDMAC_DU) {
	        emmc_set_bits(EMMC_REG_IDSTS, IDMAC_DU);
		printf("Descriptor Unavailable\n");
#ifdef IDMAC_CHAIN_MODE
		emmc_dump_descriptors(CHAINMODE);
#else
		emmc_dump_descriptors(RINGMODE);
#endif
		emmc_dump_registers();
		if(poll_demand_count < 3)    //poll Demand reg is a write only reg ,when OWN bit is not set,the host needs to write any value to resume normal descriptor fetch operation   ly  
		{			
			the_task_stat->error_status = 0;   // Descriptor Unavailable but we are doing a Poll Demand
			the_task_stat->cmd_status = TSK_STATE_POLLD;   // Descriptor Unavailable
			emmc_set_bits(EMMC_REG_RINTSTS, 0xFFFFFFFF); //Clear all pending Slave Mode Interrupts
			emmc_set_bits(EMMC_REG_IDSTS, 0xFFFFFFFF); //Clear all pending IDMAC Mode Interrupts
			printf("error_status is %x and command_status is %x\n",the_task_stat->error_status,the_task_stat->cmd_status);
			printf("Issueing Poll-Demand %x th time\n",poll_demand_count);
			emmc_set_register(EMMC_REG_PLDMND,0x01); // Since we are getting descriptor Unavailable we are writing a value to 
							   // poll demand Register to release the IDMA from Suspend State.
			poll_demand_count++;
		}
		else{
			the_task_stat->error_status = ERRIDMACDU;   // Descriptor Unavailable
			the_task_stat->cmd_status   = TSK_STAT_STARTED;   // Descriptor Unavailable

			//Reset the CTRL[0]
		        emmc_set_bits(EMMC_REG_CTRL,CTRL_RESET);
	        	plat_delay(100);
			if((emmc_read_register(EMMC_REG_CTRL) & CTRL_RESET) != 0){
				printf("ERROR in resetting Controller\n");
			}
				//Reset the CTRL[2]
	        	emmc_set_bits(EMMC_REG_CTRL,DMA_RESET);
		        plat_delay(100);
			if((emmc_read_register(EMMC_REG_CTRL) & DMA_RESET ) != 0){
				printf("ERROR in resetting DMA\n");
			}
			//Reset the FIFO controller CTRL[1]
	        	emmc_set_bits(EMMC_REG_CTRL,FIFO_RESET);
		        plat_delay(100);
			if((emmc_read_register(EMMC_REG_CTRL) & FIFO_RESET) != 0){
				printf("ERROR in resetting FIFO_RESET\n");
			}
			//Reset the DMA engine BMOD[0]
	       		emmc_set_bits(EMMC_REG_BMOD,BMOD_SWR);
	     		plat_delay(100);
			if((emmc_read_register(EMMC_REG_BMOD) & BMOD_SWR) != 0){
				printf("ERROR in resetting BMOD\n");
			}
			emmc_set_bits(EMMC_REG_RINTSTS, 0xFFFFFFFF); //Clear all pending Slave Mode Interrupts
			emmc_set_bits(EMMC_REG_IDSTS, 0xFFFFFFFF); //Clear all pending IDMAC Mode Interrupts
	
		}
	}
    if (idsts_stat & IDMAC_CES) {                 // Card Error Summary 
		the_task_stat->error_status = ERRIDMACCBE;   // CBE set 
        	emmc_set_bits(EMMC_REG_IDSTS, IDMAC_CES);
		printf("Card Error Summary is Set\n");
	}
    if (idsts_stat & IDMAC_AI) {                   // Abnormal Interrupt
	        emmc_set_bits(EMMC_REG_IDSTS, IDMAC_AI);
		printf("Abnormal Interrupt received\n");
	}
}

/**
  * Checks a R1 response.
  *
  * @param[in] the_response	The response which is to be checked.
  *
  * \return The error status if an error is found in the response. Else 0.
  */

u32 emmc_check_r1_resp(u32 the_response)
{
	u32 retval = 0;
//	printf("%s: response = 0x%08x\n", __FUNCTION__, the_response);
	if (the_response & R1CS_ERROR_OCCURED_MAP) {
		if (the_response & R1CS_ADDRESS_OUT_OF_RANGE) {
			retval = ERRADDRESSRANGE;
		} else if (the_response & R1CS_ADDRESS_MISALIGN) {
			retval = ERRADDRESSMISALIGN;
		} else if (the_response & R1CS_BLOCK_LEN_ERR) {
			retval = ERRBLOCKLEN;
		} else if (the_response & R1CS_ERASE_SEQ_ERR) {
			retval = ERRERASESEQERR;
		} else if (the_response & R1CS_ERASE_PARAM) {
			retval = ERRERASEPARAM;
		} else if (the_response & R1CS_WP_VIOLATION) {
			retval = ERRPROT;
		} else if (the_response & R1CS_CARD_IS_LOCKED) {
			retval = ERRCARDLOCKED;
		} else if (the_response & R1CS_LCK_UNLCK_FAILED) {
			retval = ERRCARDLOCKED;
		} else if (the_response & R1CS_COM_CRC_ERROR) {
			retval = ERRCRC;
		} else if (the_response & R1CS_ILLEGAL_COMMAND) {
			retval = ERRILLEGALCOMMAND;
		} else if (the_response & R1CS_CARD_ECC_FAILED) {
			retval = ERRECCFAILED;
		} else if (the_response & R1CS_CC_ERROR) {
			retval = ERRCCERR;   //25
		} else if (the_response & R1CS_ERROR) {
			retval = ERRUNKNOWN;
		} else if (the_response & R1CS_UNDERRUN) {
			retval = ERRUNDERRUN;
		} else if (the_response & R1CS_OVERRUN) {
			retval = ERROVERRUN;
		} else if (the_response & R1CS_CSD_OVERWRITE) {
			retval = ERRCSDOVERWRITE;
		} else if (the_response & R1CS_WP_ERASE_SKIP) {
			retval = ERRPROT;
		} else if (the_response & R1CS_ERASE_RESET) {
			retval = ERRERASERESET;
		} else if (the_response & R1CS_SWITCH_ERROR) {
			retval = ERRFSMSTATE;
		}
	}
#ifdef DEBUG
	if (retval) {
		printf("0x%08x:%x\n", the_response, retval);
	}
#endif
	return retval;

}

//////////////// CARD RESET ///////////////////////////
///////////////////////////////////////////////
/**
  * Sets the voltage for the connected MMC card.
  * Sets the voltage level of the card. This will flag an error if the card is
  * not in the IDLE state It does the following --
  *	-# Check if any card is present in the slot
  *	-# Check if the card is in the idle state
  *	-# Set (CMD55 + ACMD41) the OCR to the MMC range.
  *	-# If there is a failure in the voltage setting, mark the card as
  *	inactive.
  * @param[in] slot The slot in which the card is
  * \return Returns 0 upon succes and error status upon failure
  */
u32 emmc_set_sd_voltage_range(u32 slot)
{
	u32 retval = 0, resp_buffer = 0, new_ocr = 0;
	int count = CMD1_RETRY_COUNT;

	/* Is the card connected ? */
	if (!(CARD_PRESENT(slot))) {
		printf("The card is not connected..\n");
		return ERRCARDNOTCONN;
	}

	/* Check if it is in the correct state */
	if (the_card_info[slot].card_state != CARD_STATE_IDLE) {
		return ERRFSMSTATE;
	}

	new_ocr = OCR_27TO36 | OCR_POWER_UP_STATUS;

	count = ACMD41_RETRY_COUNT;
	while (count) {
		if ((retval =
		     emmc_send_serial_command(slot, CMD55, 0, NULL, NULL, 0, NULL, NULL))) {
			return retval;
		}


		retval = emmc_send_serial_command(slot, ACMD41, new_ocr, &resp_buffer, NULL, 0, NULL, NULL);
		printf("GOT OCR AS = 0x%08x\n", resp_buffer);
		//if ((resp_buffer & OCR_POWER_UP_STATUS) && (!retval)) {
		if ((resp_buffer) && (!retval)) {
			/* The power up process for the card is over */
			break;
		}

		--count;
		plat_delay(1000); /*1 GB Kingston Micro SD card needs more time. so changed from 100 to 1000*/
	}

	if (0 == count) {
		printf("Giving up on trying to set voltage after %x retries\n", CMD1_RETRY_COUNT);
		the_card_info[slot].card_state = CARD_STATE_INA;
		return ERRHARDWARE;
	} else {
		if ((new_ocr & OCR_27TO36) != OCR_27TO36) {
			printf("Set voltage differs from OCR. Aborting");
			the_card_info[slot].card_state = CARD_STATE_INA;
			return ERRHARDWARE;
		}
		printf("SENT OCR = 0x%08x GOT OCR = 0x%08x\n", new_ocr, resp_buffer);
	}
	the_card_info[slot].card_state = CARD_STATE_READY;
	return retval;
}

/**
  * Reads the CID and puts the card to STBY state.
  * This function puts the card into standby state. It does so by reading
  * out the CID using CMD2. It stores the CID for later use and also printfs a
  * small informational message on the card details.
  * @param slot The slot number for the card
  * \return Returns 0 on success and error code upon return.
  */
u32 emmc_get_cid(u32 slot)
{
	u32 buffer_reg, retval = 0;
	int count;
	char product_name[7];
	int product_revision[2];
	int month, year;
	/* Check if the card is connected */
	buffer_reg = emmc_read_register(EMMC_REG_CDETECT);
	if (buffer_reg & (1 << slot)) {
		return ERRCARDNOTCONN;
	}


	if (CARD_STATE_READY != the_card_info[slot].card_state) {
		return ERRFSMSTATE;
	}

	count = CMD2_RETRY_COUNT;
	while (count) {
		retval =
		    emmc_send_serial_command(slot,
						 CMD2,
						 0,
						 (the_card_info
						  [slot].
						  the_cid), NULL, 0, NULL,
						 NULL);
		if (!retval) {
			break;
		}
		count--;
		plat_delay(100);
	}

	if (0 == count) {
		printf("FAILED TO GET CID OF THE CARD !!\n");
		return ERRHARDWARE;
	}

	else {
		printf
		    ("CID = 0x%08x  0x%08x  0x%08x  0x%08x\n",
		     the_card_info[slot].the_cid[0],
		     the_card_info[slot].the_cid[1],
		     the_card_info[slot].the_cid[2],
		     the_card_info[slot].the_cid[3]);
	}

	/* printf out some  informational message about the card
	   always makes for good eye candy
	 */
	for (count = 5; count > -1; count--) {
		product_name[5 - count] =
		    the_card_info[slot].the_cid_bytes[count + 7];
	}
	product_name[count] = 0;
	product_revision[0] = the_card_info[slot].the_cid_bytes[6] & 0x0f;
	product_revision[1] =
	    (the_card_info[slot].the_cid_bytes[6] & 0xf0) >> 4;
	month = (the_card_info[slot].the_cid_bytes[1] & 0xf0) >> 4;
	year = (the_card_info[slot].the_cid_bytes[1] & 0x0f) + 1997;
	printf("Found Card %s Rev %x.%x (%x/%x)\n", product_name, product_revision[1], product_revision[0], month, year);
	the_card_info[slot].card_state = CARD_STATE_IDENT;
	return 0;
}

/**
  * Extracts the RCA for a SD card and store it for later use.
  * This function sends out a CMD3 and extracts the RCA to use for the card and
  * stores it in the the_card_info structure for later use.
  * @param[in] slot The slot in which the SD card has been inserted.
  * \return Returns 0 upon success. The error code is returned upon error.
  */
u32 emmc_set_sd_rca(u32 slot)
{
	u32 buffer_reg, resp_buffer, retval = 0;



	/* Check if the card is connected */
	buffer_reg = emmc_read_register(EMMC_REG_CDETECT);
	if (buffer_reg & (1 << slot)) {
		return ERRCARDNOTCONN;
	}

	if (CARD_STATE_IDENT != the_card_info[slot].card_state) {
		return ERRFSMSTATE;
	}

	if ((retval =
	     emmc_send_serial_command(slot, CMD3, 0,
					  &resp_buffer, NULL, 0, NULL,
					  NULL))) {
		return retval;
	}
	printf("GOT RESP FOR CMD3 = 0x%08x\n", resp_buffer);
    
    the_card_info[slot].card_state = CARD_STATE_STBY;
	the_card_info[slot].the_rca = GET_R6_RCA(resp_buffer);
/*
    if ((retval =
	     emmc_send_serial_command(slot, CMD7, 0,
					  &resp_buffer, NULL, 0, NULL,
					  NULL))) {
		return retval;
	}
	printf("GOT RESP FOR CMD7 = 0x%08x\n", resp_buffer);
*/
	return 0;

}

/**
  * This function reads and stores the CSD.
  * This function is used by the initialization routines to evaluate the CSD. The CSD is read  
  * and the maximum NSAC and TAAC values are stored away in the the_card_info data structure  
  * for future use to calculate maximum read/write latency. Also the capacity of the card and  
  * the block sizes for the device are also calculated and stored away in the_card_info structure.  
  * @param[in] slot The specified slot.  
  * \return 0 upon success. The error status upon error.
  */
u32 emmc_process_csd(u32 slot)
{
	u32 buffer_reg, retval;
	u32 read_block_size, write_block_size;
	u32 card_size;
	u32 blocknr, blocklen;

	buffer_reg = emmc_read_register(EMMC_REG_CDETECT);
	if (buffer_reg & (1 << slot)) {
		return ERRCARDNOTCONN;
	}


	if (CARD_STATE_STBY != the_card_info[slot].card_state) {
		printf("This is in the wrong FSM state for CSD fetch %x\n",the_card_info[slot].card_state);
		return ERRFSMSTATE;
	}
	if ((retval = emmc_send_serial_command(slot, CMD9, 0, the_card_info[slot].the_csd, NULL, 0, NULL, NULL))) {
		return retval;
	}
	/* The CSD is in the bag */

	/* Store the largest TAAC and NSAC. We will use these for calculating the data timeout latency. */
	printf("**************CSD**********************\n");
	printf("0x%08x 0x%08x 0x%08x 0x%08x\n",
	       the_card_info[slot].the_csd[0],
	       the_card_info[slot].the_csd[1],
	       the_card_info[slot].the_csd[2],
	       the_card_info[slot].the_csd[3]);
	printf("**************CSD**********************\n");

	//TAAC :define the asynchronous part of the data access time
	//NSAC :define the worst case for the clock-dependant factor of the data access time
	if (CSD_TAAC(the_card_info[slot].the_csd) > the_ip_status.max_TAAC_value) {
		the_ip_status.max_TAAC_value =  CSD_TAAC(the_card_info[slot].the_csd);
	}

	if (CSD_NSAC(the_card_info[slot].the_csd) > the_ip_status.max_NSAC_value) {
		the_ip_status.max_NSAC_value = CSD_NSAC(the_card_info[slot].the_csd);
	}

	read_block_size  = 1 << (CSD_READ_BL_LEN((the_card_info[slot].the_csd)));
	write_block_size = 1 << (CSD_WRT_BL_LEN((the_card_info[slot].the_csd)));

	/* See section 5.3 of the 4.1 revision of the MMC specs for
	   an explanation for the calculation of these values
	 */          //P147    version 1.0
	blocknr = (CSD_C_SIZE(the_card_info[slot].the_csd) + 1) * (1 << (CSD_C_SIZE_MULT(the_card_info[slot].the_csd) + 2));
	blocklen = read_block_size;
	card_size = blocknr * blocklen;
	/* read/write block size */
	the_card_info[slot].card_write_blksize = (write_block_size > 512) ? 512 : write_block_size;
	the_card_info[slot].orig_card_read_blksize = read_block_size;
	the_card_info[slot].card_read_blksize = (read_block_size > 512) ? 512 : read_block_size;
	the_card_info[slot].orig_card_write_blksize = write_block_size;
	/* Set the card capacity */
	the_card_info[slot].card_size = blocknr;

/*
	printf("Card capacity = %x bytes\n", card_size);
	printf("Read Block size = %x bytes\n",the_card_info[slot].card_read_blksize);
	printf("Write Block size = %x bytes\n",the_card_info[slot].card_write_blksize);
*/
	printf("Card capacity = %x bytes\n", card_size);
	printf("Read Block size = %x bytes\n",the_card_info[slot].card_read_blksize);
	printf("Write Block size = %x bytes\n",the_card_info[slot].card_write_blksize);
	return 0;
}

u32 emmc_process_scr(u32 slot)
{
	u32 retval;
	u32 resp_buffer[4];
	u32 buff;

	u8 *the_data_buffer;

	the_data_buffer = the_card_info[slot].the_scr_bytes;
	the_card_info[slot].the_scr[0] = 0;
	the_card_info[slot].the_scr[1] = 0;
	printf("***************Before reading SCR************\n");
	printf("0x%08x 0x%08x\n", the_card_info[slot].the_scr[0],the_card_info[slot].the_scr[1]);
	
	if ((retval =  emmc_read_write_bytes(slot, resp_buffer,
				       the_data_buffer, 0, 64 / 8, 0,
				       NULL, NULL, 0,
				       ACMD51 | 4 <<
				       CUSTOM_BLKSIZE_SHIFT |
				       CUSTCOM_DONTSTDBY, NULL, NULL))) {
		return retval;
	}

//大端小端转换   ly
//	the_card_info[slot].the_scr[0] =  BE32_TO_CPU(the_card_info[slot].the_scr[0]);
//	the_card_info[slot].the_scr[1] =  BE32_TO_CPU(the_card_info[slot].the_scr[1]);
//	buff = the_card_info[slot].the_scr[0];
//	the_card_info[slot].the_scr[0] = the_card_info[slot].the_scr[1];
//	the_card_info[slot].the_scr[1] = buff;

	printf("***************SCR************\n");
	printf("0x%08x 0x%08x\n", the_card_info[slot].the_scr[0],the_card_info[slot].the_scr[1]);
	printf("***************SCR************\n");

	return 0;

}

/**
  * Set Wide bus for SD card.
  * This function sets the wide bus (4 bit wide) for a SD card.
  * Application specific command ACMD6 is used for this purpose.
  * CTYPE register of Host controller IP is programmed accordingly based on the success of ACMD6
  *     -# Check whether the feature is supported by the card (SCR bytes).
  *     -# Send the ACMD6 with argument indicating bus width as 2 for 4 bit wide bus.
  *     -# Program CTYPE register of host controller IP once ACMD6 is successful.
  * @param[in] slot The slot in which the card is placed.
  * @param[in] width 4 => 4 bit wide bus, 0=> 1 bit wide bus.
  * \return Returns 0 upon success and the error status upon failure.
  * \callgraph
  */

u32 emmc_set_sd_wide_bus(u32 slot, u32 width)
{
	u32 retval, arg;
	u32 resp;

//check SD_BUS_WIDTHS bit of SCR Register   //ly   if the reason not equal 0  : card support 1bit /4bit
	//if ((the_card_info[slot].the_scr_bytes[1] & 0x05) == 0) {  
	//    printf("return ERRNOTSUPPORTED \n"); 
	//	return ERRNOTSUPPORTED;
	//}

	if (4 == width) {
		arg = 2;
	} else if (0 == width) {
		arg = 0;
	} else {
		return ERRILLEGALCOMMAND;
	}

    /* Check if the card is in standby state and put in trans
		   state.
		 */
	if ((retval = emmc_put_in_trans_state(slot))) {
		printf("%x TRANS STATE FAILED\n", retval);
		return retval;
	}
    printf("Clr card detect on dat3. \n");
    if ((retval =
	     emmc_send_serial_command(slot, ACMD42, 0, &resp, NULL, 0, NULL, NULL))) {
             printf("WE HAVE RETVAL = %x\n", retval);
	     return retval;
	}

	if ((retval =
	     emmc_send_serial_command(slot, ACMD6, arg, &resp, NULL, 0, NULL, NULL))) {
             printf("WE HAVE RETVAL = %x\n", retval);
	     return retval;
	}

	/* now set the width of the bus */
	emmc_clear_bits(EMMC_REG_CTYPE, (1 << slot) || (1 << (slot + 16)));
	if (4 == width) {
		printf("Setting Host controller to operate in 4 bit mode\n");
		emmc_set_bits(EMMC_REG_CTYPE, (1 << slot));
	}

	return 0;
}

/**
  * Set SD to work in high speed (Default is 12.5 MBPS) 25MBPS interface speed
  * This function checks and switches the High speed mode.
  * Issue CMD6 in mode 0 to the card to check function.
  *     -# Check resulted in Error. If not proceed.
  * Issue CMD6 in mode 1 to the card to switch function.
  *     -# Check resulted in Error. If not proceed.
  * @param[in] slot The slot in which the card is placed.
  * \return Returns 0 upon success and the error status upon failure.
  * \callgraph
  */
u32 emmc_set_sd_high_speed(u32 slot)
{
        u32 retval;
        u32 *resp_buffer;
        u8 *the_data_buffer;

        resp_buffer = (u32 *)plat_alloc(sizeof(u32)*4);      //plat_alloc  change to  plat_alloc  ??? ly
        the_data_buffer = (u8 *)plat_alloc(sizeof(u32)*16); 

        memset((void *) (resp_buffer), 0, (sizeof(u32) * 4));
        memset((void *) (the_data_buffer), 0, (sizeof(u32) * 16));

        if ((the_card_info[slot].csd_union.csd_dwords[0x02] & 0x40000000) == 0) {    //CCC  P146 
                printf("This SD card doest not support switch commands which fall under Class-10\n");
                return ERRNOTSUPPORTED;
        }

        if ((retval =  emmc_read_write_bytes(slot, resp_buffer,the_data_buffer, 0, 64, 0x00ffff01,NULL, NULL, 0,
                                       CMD6 | 7 << CUSTOM_BLKSIZE_SHIFT | CUSTCOM_DONT_CMD16 | CUSTCOM_DONTSTDBY, NULL, NULL))) {
                printf("The return value is %x\n",retval);
                return retval;
        }
        
        printf("The response is  %08x %08x %08x %08x\n", resp_buffer[0],resp_buffer[1],resp_buffer[2],resp_buffer[3]);
        
        // Check whether the card supports High Speed Operation
        if((the_data_buffer[63-50] & 0x02) != 0x02)      //P67  High-Speed is not support if return value equel 0  ly
        {
        printf("Error:: Card Does not support High Speed Operation....\n");
        return ERRNOTSUPPORTED;
        }

        memset((void *) (resp_buffer), 0, (sizeof(u32) * 4));
        memset((void *) (the_data_buffer), 0, (sizeof(u32) * 16));
        
        plat_delay(100);
        
        // Send CMD6 in Mode 1 to switch the function.
        if ((retval =  emmc_read_write_bytes(slot, resp_buffer,the_data_buffer, 0, 64, 0x80ffff01,NULL, NULL, 0,
                                       CMD6 | 7 << CUSTOM_BLKSIZE_SHIFT | CUSTCOM_DONT_CMD16 | CUSTCOM_DONTSTDBY, NULL, NULL))) {
                printf("The return value is %x\n",retval);
                return retval;
        }
        
        printf("The response is  %08x %08x %08x %08x\n", resp_buffer[0],resp_buffer[1],resp_buffer[2],resp_buffer[3]);
	
        if((the_data_buffer[63-47] & 0x0F)  == 0x0F){ //Bits 379:376.  0xF indicates the function returned error     P68
            printf("Bits 379:376 reads %01x\n",the_data_buffer[47] & 0x0F);
			printf("ERROR: Access Mode could not be set to High Speed Operation\n");
			return ERRNOTSUPPORTED;
		}
	
	printf("Access Mode set to High Speed Operation\n");

        return 0;
}

/** 
  * Reads or writes a predetermined number of bytes at a particular address.
  * Flow:
  *	-# Check if the start and end addresses are block aligned.
  *	-# Put the card into trans state.
  *	-# Set the length of the block using CMD16.
  *	-# Reset the FIFO and interrupts.
  *	-# Setup the task status for the data transfer.
  *	-# Populate the BYTCNT and BLKSIZ registers with the appropriate values.
  *     -# For Idmac operation setupt the descriptor by obtaining the physical address
  *	-# Fire the CMD18/CMD25 with the start address. This command will wait for 
  * 	   the data transfer to complete. The data transfer will occur within interrupt
  *	   context. See emmc_read_in_data and emmc_write_out_data for details.
  *	-# Ensure that the card is back in trans state.
  *	-# Execute an unaddressed CMD7 to put the card into standby again.
  * data transfer method.
  *
  * @param[in] slot The slot in which the card is inserted.
  * @param[out] resp_buffer The buffer in which the latest response is stored
  * @param[out] data_buffer The buffer in which the read data will be put. 
  * It is the responsiblity of the calling function to ensure that the length
  * of the buffer is long enough for the size of data requested.  
  * @param[in] start Starting address.  
  * @param[in] end Ending address. If this address is equal to 
  *  the the start 
  * @param[in] argreg If a non zero value is specified, the value of the argument
  *  of the command is the specified value. 
  *  address, the transfer will be open ended.  
  * @param[in] the_copy_func The memcpy function. This allows the caller to
  * specify the memory copy function. If this is set to NULL, memcpy is 
  * used.  
  * @param[in] the_term_function This is the function which checks whether  
  * CMD12 is to be sent.  
  * @param[in] read_or_write 1 denotes a write operation, a 0 denotes a 
  * read operation  
  * @param[in] custom_command These 32 bits are used to flag any special conditions
  * which might be needed to be conveyed to the read/write command. The structure 
  * of these 32 bits are as follows. 
  *	- Bits 0-15 encapsulates an alternative read/write command index. The user
  *	might want a different command to be floated on the command line instead of 
  *	the normal read and write command lines
  *	- Bits 16-19 encapsulates the ln2 of the block size which is different from 
  *	the block size of the card which may be used.
  *	- Bits 30-31 are used as flags for executing certain commands. See
  *	 #CUSTCOM_DONTSTDBY, #CUSTCOM_DONT_CMD16, #CUSTCOM_DONT_TRANS for
  *	 details
  * @param[in] custom_pre The custom pre processing callback to be passed to
  * emmc_send_serial_command().
  * @param[in] custom_post The custom post processing callback to be passed to
  * emmc_send_serial_command().
  *		 
  * \return Returns 0 on successful read and error status 
     upon error. 
  * \pre The card should in the Trans or Standby state for correct 
     operation. 
  * \post The card will be put back into the Standby state after the 
     data transfer. 
  * \note Please ensure to adjust the DIS_STATE_TRIES value according the  
  * platform the driver is running on. This variable is the number
  * of retries which are going to be made to see if the card has come out of
  * the PRG state after a data write. The frequency of the CMD13 retries
  * will depend on  the speed of the of the  processor. Give the card
  * sufficient time to get out of the PRG state. One safe option would be to
  *  put it into an insanely high value.
  * \callgraph
  */
u32 emmc_read_write_bytes(u32 slot, u32 * resp_buffer,
			      u8 * data_buffer, u32 start, u32 end,
			      u32 argreg,
			      emmc_copy_function the_copy_func,
			      emmc_term_function
			      the_term_function, u32 read_or_write,
			      u32 custom_command,
			      emmc_preproc_callback custom_pre,
			      emmc_postproc_callback custom_post)
{
	u32 retval = 0, retval2 = 0;
	u32 num_of_blocks, command_to_send, num_of_primary_dwords = 0, the_block_size;
	u32 *src_buffer;
	int count;
	Card_state the_state;
	u32 arg_to_send;
        s32 desc_available_status;
        u32 dma_len1;
        dma_addr_t dma_addr1;
	printf("custom_command = 0x%08x\n", custom_command);
	/* Check if the card is inserted */
	if (emmc_read_register(EMMC_REG_CDETECT) & (1 << slot)) {
		return ERRCARDNOTCONN;
	}


	/* Set the block size pertinent to the type of operation
	 */
 
	if (CUSTCOM_STREAM_RW & custom_command) {  //CUSTCOM_STREAM_RW : the transfer is a stream transfer
		if (the_card_info[slot].card_type != SDIO_TYPE) {
			if ((start & 0x3) || (end & 0x3)) {//Check if the start and end addresses are aligned. 
				return ERRADDRESSMISALIGN;
			}
		}
		the_block_size = end - start;
	} else if (CUSTOM_BLKSIZE(custom_command)) {
		the_block_size =
		    1 << ((CUSTOM_BLKSIZE(custom_command) - 1));
		    printf("CUSTOM :the the_block_size %d\n",the_block_size);
	} else if (read_or_write) {
		the_block_size = the_card_info[slot].card_write_blksize;
		printf("write : the the_block_size %d\n",the_block_size);
	} else {
		the_block_size = the_card_info[slot].card_read_blksize;
		printf("read: the the_block_size %d\n",the_block_size);
	}



	if (!the_block_size) {
		retval = ERRADDRESSRANGE;
		goto HOUSEKEEP;
	}
if(CMD42 == (custom_command & 0x3f)){/*This hack is required as CMD42 block size is not equal to write_block_size*/
        the_block_size = CUSTOM_BLKSIZE(custom_command);
        printf("the block size for CMD42 is %x\n",the_block_size);
}

    //the_card_info[slot].card_size = 0x767000;
    //the_card_info[slot].card_write_blksize = 512;
    //the_card_info[slot].card_read_blksize = 512;
	printf
	    ("start = %x, end = %x, size = %x, block size = %x\n",
	     start, end, the_card_info[slot].card_size, the_block_size);

	if (!(custom_command & CUSTCOM_STREAM_RW)) {    //that is necessary??   ly
		if ((start % the_block_size)
		    || (end % the_block_size)) {
			printf("1 misalign start and end addr.\n");
			return ERRADDRESSRANGE;
		}
	}


	if (the_card_info[slot].card_type != SDIO_TYPE) {
		if ((end /
		     (read_or_write ? the_card_info[slot].
		      card_write_blksize : the_card_info[slot].
		      card_read_blksize)) >
		    the_card_info[slot].card_size) {
			return ERRADDRESSRANGE;
		}
	}

	if (start > end) {
		return ERRADDRESSRANGE;
	}

	num_of_blocks = (end - start) / the_block_size;

	printf("NUM OF BLOCKS = %x\n", num_of_blocks);
	if ((num_of_blocks & 0x0000ffff) != num_of_blocks) {
		return ERRADDRESSRANGE;
	}

	/* One cannot have an open ended transfer with 
	   no term function specified.
	 */
	if ((!the_term_function) && (start == end)) {   //if start == end and not send cmd12 ,return ERR  ly
		return ERRADDRESSRANGE;
	}

	if (!(CUSTCOM_DONT_TRANS & custom_command)) {
		/* Check if the card is in standby state and put in trans
		   state.
		 */
		if ((retval = emmc_put_in_trans_state(slot))) {
			printf("%x TRANS STATE FAILED\n", retval);
			goto HOUSEKEEP;
		}
	}
     
     //the_card_info[slot].divider_val = 3;
	/* Set the block len *///since we use a sdhc card, cmd16 is useless.
	if ((!(custom_command & CUSTCOM_DONT_CMD16))
	    && (!(custom_command & CUSTCOM_STREAM_RW))) {
		if ((retval =
		     emmc_send_serial_command(slot, CMD16,      //CMD16 : SET_BLOCKLEN command   ly
						  the_block_size,
						  resp_buffer,
						  NULL, 0, NULL, NULL))) {
			printf("send cmd16 retval error %d\n",retval );
			goto HOUSEKEEP;
		}
	}

	/* Reset internal FIFO */
	emmc_reset_fifo();

	/* Clear the interrupts */
	emmc_set_bits(EMMC_REG_RINTSTS, 0xfffe);


	if (!(custom_command & CUSTCOM_DONT_BLKSIZ)) {
		emmc_set_register(EMMC_REG_BLKSIZ, the_block_size);
	}

	emmc_set_register(EMMC_REG_BYTCNT, (end - start));

	/* Depending on a read or a write, CMD18/CMD25 will be sent out. 
	 * Also, the FIFO will be filled to its brim for the card to 
	 * read as soon as it receives the CMD25
	 */
	printf("READ OR WRITE = %x\n", read_or_write);
	if (read_or_write) {                  //write 
		command_to_send = CMD25;
               /*Some of MMC and SD cards won't allow Single block write using CMD25. So use CMD24 when number of blocks is equal to 1*/
                if(num_of_blocks == 0x01)
                        command_to_send = CMD24;    //P90 ly 

		if(the_ip_status.idmac_enabled == 1){
			// Don't have to fill the fifo in IDMA mode  
		}
		else{
			/* We also need to put in the intial data into the 
			   FIFO. For the first time we fill up the complete 
			   FIFO.	
			 */
			src_buffer = (u32 *) data_buffer;
			if (((end - start) / FIFO_WIDTH) >=
		    	the_ip_status.fifo_depth) {
				/* Write fifo_depth dwords */
				num_of_primary_dwords = the_ip_status.fifo_depth;
			} 
			else{
				/* Just write complete buffer out */
				num_of_primary_dwords = (end - start) / FIFO_WIDTH;
			}

			if (0 == (end - start)) {
				num_of_primary_dwords = the_ip_status.fifo_depth;
			} 
			else if ((end - start) && (0 == num_of_primary_dwords)) {
				num_of_primary_dwords = 1;
			}
			/* Now copy out the actual bytes */
			for (count = 0; count < num_of_primary_dwords; count++) {
				emmc_set_register(EMMC_REG_FIFODAT, *src_buffer++);
			}
		}
	} 
	else{
		command_to_send = CMD18;
		/*Some of MMC and SD cards won't allow Single block read using CMD18. So use CMD17 when number of blocks is equal to 1*/
                if(num_of_blocks == 0x01)
                        command_to_send = CMD17;
	}

	if (custom_command & CUSTCOM_COMMAND_MSK) {
		command_to_send = custom_command & CUSTCOM_COMMAND_MSK;    //extract the custom command 
	}


	/* The CMD23 is an optional feature which might be used for 
	   block sized data transfers. The auto stop bit and the 
	   BYTCNT size register however suffices for the host controller.
	 */     //use CMD23 to set the block number before firing the data command   ly
	if (custom_command & CUSTCOM_DO_CMD23) {
		/* Do a command 23 to set the num of blocks */
		if ((retval =
		     emmc_send_serial_command(slot, CMD23, (end - start)/the_block_size,
						  resp_buffer, NULL, 0, NULL, NULL))) {
			goto HOUSEKEEP;
		}
	}

	printf("num_of_primary_dwords = %x\n", num_of_primary_dwords);
	/* Set the transfer parameters */
	emmc_set_data_trans_params(slot, data_buffer,
				       num_of_blocks,
				       the_term_function,
				       the_copy_func,
				       num_of_primary_dwords *
				       FIFO_WIDTH, read_or_write,
				       the_block_size);

	if(the_ip_status.idmac_enabled == 1){

		// Setup the Descriptor for the Read Transfer
		// The platform dependent allocation of DMA-able memory
		dma_len1  = emmc_read_register(EMMC_REG_BYTCNT);// the number of bytes to be transmitted/received is already programmed in BYTCNT
		printf("BYTCNT read is %08x\n",dma_len1);
		if(dma_len1 >MAX_BUFF_SIZE_IDMAC){
				printf("Driver cannot handle the buffer lengths greater than %x\n",MAX_BUFF_SIZE_IDMAC);
				return ERRNOTSUPPORTED; //Driver cannot handle the memory greater than 8k bytes	(13 bits in lenght field)    	
		}
		dma_addr1  = plat_map_single((current_task.bus_device), data_buffer, dma_len1,BIDIRECTIONAL );
		desc_available_status = emmc_set_qptr(dma_addr1, dma_len1,(u32) data_buffer,0,0,0);
		if(desc_available_status < 0){
			printf("No Free Descriptor available\n");
			return ERRNOMEMORY;
		}
	}

	/* Before we kick off the floating of the data on the data lines
	   if it is a write function we check whether the card is ready 
	   to receive data 
	 */
	if (read_or_write && (the_card_info[slot].card_type != SDIO_TYPE)) {
		if ((retval = emmc_is_card_ready_for_data(slot))) {
			goto HOUSEKEEP;
		}
	}

	/* Now kick off the the data read/write command. This command will 
	 * will schedule this context back in again after the complete
	 * transfer.
	 */
	if (argreg) {
		arg_to_send = argreg;
	} else {
		arg_to_send = start;     
	}
	printf("command_to_send is %d\n",command_to_send );
	if ((retval =
	     emmc_send_serial_command(slot, command_to_send,    
					  arg_to_send, resp_buffer,
					  data_buffer, end - start,
					  custom_pre, custom_post))) {
		goto HOUSEKEEP;
	}


	/*
	   This generally occurs due to clocking issues. When the card 
	   might be running in non-highspeed mode, and the clock is being
	   driven at frequencies outside its reach, bus error might occur.
	 */
	if (emmc_bus_corruption_present()) {
		printf("BUS CORRUPTION HAD OCCURED !!!!!\n");
		if (read_or_write) {
			retval = ERRENDBITERR;
		} 
		else {
			retval = ERRDCRC;
		}
	}


	/* Wait till the busy bit in the status register gets
	   de-asserted for data writes
	 */

	if (read_or_write) {
		while ((L_EMMC_REG_STATUS) &  STATUS_DAT_BUSY_BIT);
	}

#if 1
/*This is required when we disable the auto_stop_bit in CMD register and send the CMD12 from the driver directly.
  Some of the MMC cards and SD card misbehave (block skip problem) when auto_stop_bit is set in the CMD register.
  So Auto_stop_bit is disabled and the CMD12 (Stop CMD is sent by Host/driver) as a work around for multiblock
  read and write operation.
*/
if((command_to_send == CMD25) || (command_to_send == CMD18))
{
        retval = emmc_send_serial_command(slot, CMD12, 0,resp_buffer,NULL,0,NULL,NULL);
}
#endif


     HOUSEKEEP:
	/* This value will have to be changed with the 
	   processor/bus speed. Configure it for the slowest 
	   frequency which might be used on the CMD line
	 */
#define DIS_STATE_TRIES 100
	if (!(custom_command & CUSTCOM_DONTSTDBY)) {   //not to go to standby state after the data transfer
		if (read_or_write) {
			/* If it was a write operation, it is possible
			   that the card might be in the programming state,
			   so we wait for some time for it to go into 
			   disconnect/trans state
			 */
			for (count = 0; count < DIS_STATE_TRIES; count++) {
				if ((retval2 = emmc_get_status_of_card(slot, &the_state))){
					return retval2;
				}
				if (CARD_STATE_PRG != the_state)
					break;
			}
			if (DIS_STATE_TRIES == count) {
				return ERRHARDWARE;
			}
		}

		retval2 = emmc_put_in_trans_state(slot);

		/* Hit the card with an unaddressed CMD7 */
		retval2 =  emmc_send_serial_command(slot, UNADD_CMD7,
						 0, resp_buffer,NULL, 0, NULL, NULL);

		if (retval2) {
			return retval2;
		}
	}

	the_card_info[slot].card_state = CARD_STATE_STBY;
	return retval;
}

/**
  * Resets the data FIFO for the host controller.
  */
void emmc_reset_fifo(void)
{
	emmc_set_bits(EMMC_REG_CTRL, FIFO_RESET);
	while (L_EMMC_REG_CTRL & FIFO_RESET);
	return;
}

/**
  * This function checks whether the internal buffer for the card is ready
  * to receive any data.
  * @param[in] slot The slot for the card
  */
u32 emmc_is_card_ready_for_data(u32 slot)
{
	u32 resp_buffer, retval = 0;
	int count;

	for (count = 0; count < READY_FOR_DATA_RETRIES; count++) {
		if ((retval =
		     emmc_send_serial_command(slot, CMD13, 0,     //CMD13: SET_STATUS
						  &resp_buffer,
						  NULL, 0, NULL, NULL))) {
			return retval;
		}

//		printf("%s: Got response as 0x%08x\n", __FUNCTION__,
//		       resp_buffer);
		if (resp_buffer & R1CS_READY_FOR_DATA) {
			break;
		}
		plat_delay(1);
	}

	if (READY_FOR_DATA_RETRIES == count) {
		return ERRCARDNOTREADY;
	}

	return 0;
}



#if   1
/** 
  * Reset the SD card to ready state. 
  * This function resets the card and then brings it up back to the ready state.
  * For the exact process in which this is to be done, refer to Figure 16 of the
  * SD Physical Layer specification 1.10 The steps followed in this function
  * are as follows
  *	-# Check if the card is present.
  *	-# Send a CMD0 to reset the card.
  *	-# Set the clock frequency to f<sub>OD</sub> (300-400KHz).
  *	-# Enable open drain pullup on the command line.
  *	-# Setup the OCR register for the card. This moves the card to ready.
  *	-# Poll for the CID  for the system. This moves the card to ident
  *	-# Extract the rca if the CID is retrieved. This pushes the card to
  *	stby.
  *	-# Read the SCR and store it.
  * @param[in] slot The slot in which the card is placed.
  * \return Returns 0 upon success and the error status upon failure.
  * \callgraph
  */
u32 emmc_reset_sd_card(u32 slot)
{

	u32 buffer_reg;
	u32 retval = 0;
	u32 clock_freq_to_set = SD_ONE_BIT_BUS_FREQ;
#ifdef SD_SET_HIGH_SPEED
        Card_state the_state;
        u32 resp_buffer;
#endif


	/* Check if the card is connected? */
	buffer_reg = emmc_read_register(EMMC_REG_CDETECT);
	if (buffer_reg & (1 << slot)) {
		return ERRCARDNOTCONN;
	}
//	printf("Entered %s\n", __FUNCTION__);
	
	/* Clear out the state information for the card status. We know the card is SD_TYPE*/
	memset((void *) (the_card_info + slot), 0, sizeof(Card_info));
	the_card_info[slot].card_type = SD_TYPE;


	/* Fod the clock and OD the bussince we start enumerating now */
	printf("Setting divider value to %x(%x)\n",SD_FOD_DIVIDER_VALUE, slot);
	emmc_set_bits(EMMC_REG_CTRL, ENABLE_OD_PULLUP);    //SD reset need enable open_drain pullup  ly
	the_card_info[slot].divider_val = SD_FOD_DIVIDER_VALUE;
	/* Reset the card. Since we really dont know as to from where the call has been made*/
	if ((retval = emmc_send_serial_command(slot, CMD0, 0, NULL, NULL, 0, NULL, NULL))) {
		goto HOUSEKEEP;                       //CMD0:GO_IDLE_STATE command ly 
	}

	/* CMD0 is successful => card is in idle state */
	the_card_info[slot].card_state = CARD_STATE_IDLE;
	/* Now in IDLE state. Set the sd voltage range on the card. Uses CMD55 and ACMD41 */
	if ((retval = emmc_set_sd_voltage_range(slot))) {
		goto HOUSEKEEP;
	}

	/* Now in READY state Now extract the CID this uses CMD2 */
	if ((retval = emmc_get_cid(slot))) {
		goto HOUSEKEEP;
	}

	/* Now in IDENT state. Set the RCA. this uses CMD3*/
	if ((retval = emmc_set_sd_rca(slot))) {
		goto HOUSEKEEP;
	}

	/*Clk freq is set to one bit freq. */
	the_card_info[slot].divider_val = clock_freq_to_set;
	emmc_clear_bits(EMMC_REG_CTRL, ENABLE_OD_PULLUP);

	/*Now in STBY stage. So we get the CSD Register and store it. this uses CMD9 */
	if ((retval = emmc_process_csd(slot))) {
		/* Switch off the card */
		goto HOUSEKEEP;
	}
//This is commented to ensure CMD24 is the first data command in IDMAC mode
#if 0
	if ((retval = emmc_process_scr(slot))) {
		/* Switch off the card */
		goto HOUSEKEEP;
	}
#endif
	/* If compiled with SD_SET_WIDE_BUS flag then do the needful*/
#if 0
	if ((retval = emmc_set_sd_wide_bus(slot, 4))) {
		retval = 0;
		goto HOUSEKEEP;
	}
#endif
#ifdef SD_SET_HIGH_SPEED
        if((retval = emmc_set_sd_high_speed(slot))){
                retval = 0;
                goto HOUSEKEEP;
        }

       /*get the status of the card*/
        if ((retval = emmc_get_status_of_card(slot, &the_state))) {
                printf("Getting status of card borked out !\n");
                return retval;
        }
        /* Now send the command to send to standby state */
        if ((retval = emmc_send_serial_command(slot, UNADD_CMD7, 0, &resp_buffer, NULL, 0, NULL, NULL))){
                return retval;
        }
        /*Now in STBY stage. So we get the CSD Register and store it. this uses CMD9 */
        if ((retval = emmc_process_csd(slot))) {
                goto HOUSEKEEP;
        }

#endif

      HOUSEKEEP:      //if return is 0 : command success   ly
	the_card_info[slot].divider_val = clock_freq_to_set;
	the_card_info[slot].enum_status = retval;
	emmc_set_clk_freq(clock_freq_to_set);
	emmc_clear_bits(EMMC_REG_CTRL, ENABLE_OD_PULLUP);
	return retval;
}

//////////////////////////////////
/**
  * Sets the voltage for the connected SD2.0 card.
  * The ACMD41 has added responsibility here. The command argument also carries 
  * HCS(Host Capacity Support) bit set for hosts supporting high capacity cards.
  * A high capacity cards sets CCS (Card Capacity Status) indicating whether a card
  * is an high capacity card or not. Please note that since this function is called for
  * a card which responds to CMD8 we are sure that the CCS field set to 1 indicating the 
  * card is an high capacity card. The command will flag an error if the card is
  * not in the IDLE state It does the following --
  *	-# Check if any card is present in the slot
  *	-# Check if the card is in the idle state
  *	-# Set (CMD55 + ACMD41) the OCR to the SD2.0 range. this also takes the HCS bit 
	   set to indicate the support of high capacity SD2.0 cards
  *	-# If there is a failure in the voltage setting, mark the card as
  *	inactive.
  * @param[in] slot The slot in which the card is
  * \return Returns 0 upon succes and error status upon failure
  */
u32 emmc_set_sd_2_0_voltage_range(u32 slot)
{
	u32 retval = 0, resp_buffer = 0, new_ocr = 0;
	int count = CMD1_RETRY_COUNT;

	/* Is the card connected ? */
	if (!(CARD_PRESENT(slot))) {
		return ERRCARDNOTCONN;
	}

	/* Check if it is in the correct state */
	if (the_card_info[slot].card_state != CARD_STATE_IDLE) {
		return ERRFSMSTATE;
	}

	new_ocr = OCR_27TO36 | OCR_POWER_UP_STATUS | OCR_HCS;   //OCR_HCS: card is High Capacity SD card ly
    
    // OCR_XPC is used to check on SDXC Power Control. OCR_S18R is used to check Voltage Switching Support
    new_ocr = new_ocr | OCR_XPC | OCR_S18R;

	count = ACMD41_RETRY_COUNT;
	while (count) {
		if ((retval =  emmc_send_serial_command(slot, CMD55, 0, NULL, NULL, 0, NULL, NULL))) {
			return retval;
		}
       //ACMD41 :send host capacity support info and ask card seed its OCR reg value   ly
		retval = emmc_send_serial_command(slot, ACMD41, new_ocr, &resp_buffer, NULL, 0, NULL, NULL);
		printf("GOT OCR AS = 0x%08x\n", resp_buffer);
		if ((resp_buffer & OCR_POWER_UP_STATUS) && (!retval)) {
			/* The power up process for the card is over */
			break;
		}

		--count;
		plat_delay(100);
	}

	if (0 == count) {
		printf("Giving up on trying to set voltage after %x retries\n", CMD1_RETRY_COUNT);
		the_card_info[slot].card_state = CARD_STATE_INA;
		return ERRHARDWARE;
	} else {
		if ((resp_buffer & OCR_27TO36) != OCR_27TO36) {
			printf("Set voltage differs from OCR. Aborting");
			the_card_info[slot].card_state = CARD_STATE_INA;
			return ERRHARDWARE;
		}
		printf("SENT OCR = 0x%08x GOT OCR = 0x%08x\n", new_ocr, resp_buffer);
	}
	if(resp_buffer & OCR_CCS){
	printf("The card responded with CCS set\n");
	}
	else{
		printf("The card responded with CCS Un-set... The card could be a SDSC card\n");
		return ERRENUMERATE;		
	}  
    // If it is SDHC card, check whether SD3.0 card by verifying the Voltage switching support.
	if(resp_buffer & OCR_S18R){
		printf("The card supports Voltage switching\n");
        printf("The Card Found is SD MEMORY 3.0 Type\n");
    	the_card_info[slot].card_type = SD_MEM_3_0_TYPE;
		the_card_info[slot].is_volt_switch_supported = 1; //Set a flag indicating that voltage switching supported.
    }

	the_card_info[slot].card_state = CARD_STATE_READY;
	return retval;

}



/** 
  * Reset the SD2.0 card to ready state. 
  * This function resets the card and then brings it up back to the ready state.
  * For the exact process in which this is to be done, refer to Figure 16 of the
  * SD Physical Layer specification 2.0 The steps followed in this function
  * are as follows
  *	-# Check if the card is present.
  *	-# Send a CMD0 to reset the card.
  *     -# Send a SD_CMD8 to check interface conditions.
  *	-# Set the clock frequency to f<sub>OD</sub> (300-400KHz).
  *	-# Enable open drain pullup on the command line.
  *	-# Setup the OCR register for the card. This moves the card to ready.
  *	-# Poll for the CID  for the system. This moves the card to ident
  *	-# Extract the rca if the CID is retrieved. This pushes the card to
  *	stby.
  *	-# Read the SCR and store it.
  * @param[in] slot The slot in which the card is placed.
  * \return Returns 0 upon success and the error status upon failure.
  * \callgraph
  */
u32 emmc_reset_sd_2_0_card(u32 slot)
{

	u32 buffer_reg;
	u32 retval = 0;
	u32 clock_freq_to_set = SD_ONE_BIT_BUS_FREQ;
	u32 resp_buffer[4];

	/* Check if the card is connected? */
	buffer_reg = emmc_read_register(EMMC_REG_CDETECT);
	if (buffer_reg & (1 << slot)) {
		return ERRCARDNOTCONN;
	}
//	printf("Entered %s\n", __FUNCTION__);
	
	/* Clear out the state information for the card status. We know the card is SD_2_0_TYPE*/
	memset((void *) (the_card_info + slot), 0, sizeof(Card_info));    //Q1:Should alloc inner space?? ly
	the_card_info[slot].card_type = SD_MEM_2_0_TYPE;


	/* Fod the clock and OD the bussince we start enumerating now */
	//printf("Setting divider value to %x(%x)\n",SD_FOD_DIVIDER_VALUE, slot);
    //emmc_set_bits(CTRL, ENABLE_OD_PULLUP); // This is not required for SD cards 
	the_card_info[slot].divider_val = 15;
	/* Reset the card. Since we really dont know as to from where the call has been made*/
	if ((retval = emmc_send_serial_command(slot, CMD0, 0, NULL, NULL, 0, NULL, NULL))) {
		goto HOUSEKEEP;                  //CMD0 : GO_IDLE_STATE
	}
	printf("Sending SD_CMD8 to slot %x\n", slot);
	retval = emmc_send_serial_command(slot, SD_CMD8, 0x000001AA, resp_buffer, NULL, 0,  NULL, NULL);
    
	if (!retval) {
		/* Found an SD_2.0 Card */
		printf("SD_CMD8 received the response:%x\n",resp_buffer[0]);
	}
	else {
		printf("SD_CMD8 has timed out...\n");
		return ERRTYPE;
	}


	/* CMD8 is successful => card is in idle state */
	the_card_info[slot].card_state = CARD_STATE_IDLE;
	/* Now in IDLE state. Set the SD2.0  voltage range on the card. Uses CMD55 and ACMD41 */
	if ((retval = emmc_set_sd_2_0_voltage_range(slot))) {
		goto HOUSEKEEP;
	}
    /*
	 * The voltage setting is complete for SD2.0 cards. If required, Voltage switching to be performed now. 	 
 	 */
#ifdef SWITCH_VOLTAGE_18
	if(the_card_info[slot].is_volt_switch_supported == 1){ //Voltage switching should be attempted only when the card supports Voltage switching
		printf("\n\nSD Card Supports Voltage Switching... Attempting to switch the voltage now...\n");
        // Initiate the voltage switching procedure
		if ((retval = emmc_switch_voltage_18(slot))){
			printf("Error in Voltage Switching.. Re-insert the card \n");
			printf("If Error Persists, Load driver without Voltage Switch support\n");
			goto HOUSEKEEP;
		}
		// By this time card is operating in 1.8V mode
	}
#endif
	/* Now in READY state Now extract the CID this uses CMD2. SD2.0 alos uses same cid command */
	if ((retval = emmc_get_cid(slot))) {
		goto HOUSEKEEP;
	}

	/* Now in IDENT state. Set the RCA. this uses CMD3. SD2.0 also used same rca setting command*/
	if ((retval = emmc_set_sd_rca(slot))) {
		goto HOUSEKEEP;
	}


	/*Clk freq is set to one bit freq. */
	the_card_info[slot].divider_val = clock_freq_to_set;
   //emmc_clear_bits(CTRL, ENABLE_OD_PULLUP); // Not required for SD cards

	/*Now in STBY stage. So we get the CSD Register and store it. this uses CMD9 */
	#if 1
	if ((retval = emmc_process_SD_2_0_csd(slot))) {
		/* Switch off the card */
		goto HOUSEKEEP;
	}
	#endif
#ifdef SWITCH_VOLTAGE_18
    // For any Data transfer command in UHS-1, bus width is 4. We shoudl switch the host controller 
    // to operate in 4 bit mode before proceeding

    // After CMD9 the card is in STANDBY state. Before sending ACMD6, Card should be brought to trans state
    // by sending CMD7
    printf("Sending CMD7 to bring the card to TRANS state\n");
	if ((retval =  emmc_send_serial_command(slot, CMD7, 0, &resp_buffer[0], NULL, 0, NULL, NULL))) {
		return retval;
	}
	/* This puts the card into trans */
	the_card_info[slot].card_state = CARD_STATE_TRAN;

    // Send ACMD6 to switch the bus width of the card. It is possible that card is already operating in 4 bit mode.
    // But it is no harm to send ACMD6 to explicitely switch the bus width.
	if ((retval = emmc_set_sd_wide_bus_VS(slot, 4))) {
		retval = 0;
		goto HOUSEKEEP;
	}

#endif

	/* If compiled with SD_SET_WIDE_BUS flag then do the needful*/
    printf("-> Get SCR \n");
	if ((retval = emmc_process_scr(slot))) {
		/* Switch off the card */
		goto HOUSEKEEP;
	}

	printf("-> Set sd wide bus \n");
	if ((retval = emmc_set_sd_wide_bus(slot, 4))) {
		retval = 0;
		goto HOUSEKEEP;
	}

    // If DDR operation is required, check for DDR support from the card.
    // If support exist program the host controller to operate in DDR mode.

#ifdef SD_SWITCH_DDR
    printf("CTYPE REGISTER before switching DDR is %08x\n",emmc_read_register(EMMC_REG_CTYPE));
	if((emmc_read_register(EMMC_REG_CTYPE) & (1 << slot)) == (1<<slot)){ // We can switch to DDR only in 4 bit wide bus 
        if((retval = emmc_set_sd_ddr(slot))){
        	retval = 0;
            goto HOUSEKEEP;
        }
	}
	else{
		printf("Error in setting wide bus mode the current SD card\n");
		printf("DDR operation is not possible\n");
		goto HOUSEKEEP;
	}

#endif


    HOUSEKEEP:
	//the_card_info[slot].divider_val = clock_freq_to_set;
	the_card_info[slot].enum_status = retval;
	//emmc_set_clk_freq(clock_freq_to_set);
	//emmc_clear_bits(EMMC_REG_CTRL, ENABLE_OD_PULLUP);
	return retval;

}



/*
This function is used to reset the SDIO card.
*/

u32 emmc_reset_sdio_card(u32 slot)
{

	u32 buffer_reg;
	u32 retval = 0;
	u32 clock_freq_to_set = SD_ONE_BIT_BUS_FREQ;
	u32 io, mem, mp, f;
	u32 resp;
	u32 new_ocr;
	u8 enable_data;
	int count;
	u8 dat = 0x08;

	io = mem = mp = f = 0;
	/* Check if the card is connected */
	buffer_reg = emmc_read_register(EMMC_REG_CDETECT);
	if (buffer_reg & (1 << slot)) {
		retval = ERRCARDNOTCONN;
		goto HOUSEKEEP;
	}

//	printf("Entered %s\n", __FUNCTION__);
	emmc_set_bits(EMMC_REG_CTRL, ENABLE_OD_PULLUP);
	the_card_info[slot].divider_val = SD_FOD_DIVIDER_VALUE;
	the_card_info[slot].enum_status = 0;

	/*
	Send the CMD5 with argument 0 to see whether the SDIO card responds?
	*/
	if ((retval =  emmc_send_serial_command(slot, CMD5, 0, &resp, NULL, 0, NULL, NULL))) {
		goto HOUSEKEEP;
	}

	/*
	Yes the card responded. Now send the OCR value to the card (to set new voltage). This 
	command is tried for CMD5_RETRY_COUNT(50) times. On PCI bus it fails So some 
	tweak in the delay incorporated.
	*/
	new_ocr = resp & IO_R4_OCR_MSK;    //P203   DesignWare

	count = CMD5_RETRY_COUNT;
	while (count) {
		if ((retval =  emmc_send_serial_command(slot, CMD5, new_ocr,  &resp, NULL, 0, NULL,  NULL))) {
			goto HOUSEKEEP;
		}
		if (resp & IO_R4_READY_BIT) {
			break;
		}
		plat_delay(100); /* changed from 10 */
		count--;
	}

	printf("The OCR from RESP is 0x%08x\n", resp);

	if (!count) {
		printf("Count not set voltage on the SDIO card\n");
		retval = ERRHARDWARE;
		goto HOUSEKEEP;
	}

	/*If memory present in the received R4 response set the mp flag 1 indication memory present */
	if (resp & IO_R4_MEM_PRESENT_BIT) {
		mp = 1;
	}
	/*Get the no of IO functions supported by the card from R4 response*/
	f = GET_IO_R4_NUM_FUNCS(resp);

	printf("The mp = %x and f= %x\n", mp, f);
	/*If no of functions not equal to '0' set io support flat to '1'*/
	if (f) {
		io = 1;
	}

	if (mp) {
		/* This has a memory function and hence we  initialise the memory module also */
		if ((retval = emmc_reset_sd_card(slot))) {
			goto HOUSEKEEP;
		}
	} else if (io) {
		/*Set the RCA using CMD3: please note that response for CMD3 is modified R6 response for 
		  SDIO cards please read the specs for details*/
		if ((retval =  emmc_send_serial_command(slot, CMD3, 0, &resp, NULL, 0, NULL,  NULL))) {
			goto HOUSEKEEP;
		}
		printf("GOT RESP FOR CMD3 for sdio = 0x%08x\n", resp);


		the_card_info[slot].card_state = CARD_STATE_STBY;
		the_card_info[slot].the_rca = GET_R6_RCA(resp);
	}

	emmc_clear_bits(EMMC_REG_CTRL, ENABLE_OD_PULLUP);
	the_card_info[slot].divider_val = ONE_BIT_BUS_FREQ;
	/* Put it in command mode */
	if ((retval = emmc_send_serial_command(slot, CMD7, 0, &resp, NULL, 0, NULL, NULL))) {
		return retval;
	}


	/* Enable all functions by default. You may actually  remove this code if you want to. */
	if (f) {
		/*Set CCCR ENABLE bit for all the functions*/
		dat = enable_data = (((1 << f) - 1)) << 1;
		if ((retval = emmc_io_rw_52(0, 0, CCCR_ENABLE, &enable_data, 1,0))) {
			goto HOUSEKEEP;
		}
		/* The functions have been enabled, now poll on the ready register to see
		   if they actually have been enabled or not
		 */
		count = 1000;/*to be consistent: all our polling are of 1000 iterations */
		dat = 0;
		while (count) {
			/*Read CCCR READY to make sure the SDIO is ready*/
			if ((retval = emmc_io_rw_52(0, 0, CCCR_READY, &dat, 0, 0))) {
				goto HOUSEKEEP;
			}

			if (enable_data & dat) {
				break;
			}
			plat_delay(100);/* changed from 50 */

			dat = 0;
			count--;
		}

		if (!count) {
			retval = ERRHARDWARE;
			goto HOUSEKEEP;
		}
	}


	/*If both memory present and io present it is SD combo type*/
	if (mp && io) {
		the_card_info[slot].card_type = SDCOMBO_TYPE;
	}


	/* read the CCCR. Now read 20 bytes */
	retval =
	    emmc_io_rw(slot, 0, CCCR_START,
			   the_card_info[slot].the_cccr_bytes, CCCR_LENGTH,
			   0, 0, NULL, NULL);
#ifdef SD_SET_WIDE_BUS
	retval = emmc_io_rw_52(slot, 0, CCCR_BUS_INT_CTRL, &dat, 0, 0);
	if (!retval) {
		dat |= 0x02;
		retval =
		    emmc_io_rw_52(slot, 0, CCCR_BUS_INT_CTRL, &dat, 1,
				      0);
		if (!retval) {
			dat = 0;
			retval =
			    emmc_io_rw_52(slot, 0, CCCR_BUS_INT_CTRL,
					      &dat, 0, 0);
			if ((!retval) && (dat & 0x02)) {
				emmc_clear_bits(EMMC_REG_CTYPE, (1 << slot)
						    || (1 << (slot + 16)));
				emmc_set_bits(EMMC_REG_CTYPE, (1 << slot));
			}

		}
	}
#endif

#ifdef SD_SET_HIGH_SPEED
        retval = 0;
        dat = 0;
        retval = emmc_io_rw_52(slot, 0, CCCR_HIGH_SPEED, &dat, 0, 0);
        if(!retval){
                printf("WE HAVE RETVAL = %x and dat = %x\n", retval,dat);
        dat &= 0x01;

                if(dat){
                printf("Trying to Enable High Speed mode................\n");
                dat = 0x02;
                retval = emmc_io_rw_52(slot, 0, CCCR_HIGH_SPEED, &dat, 1, 0);
                        if(!retval){
                        plat_delay(10);
                       /*Lets wait for some time. we need to provide 8 clocks before setting clocks to high speed*/
                        clock_freq_to_set =  SD_HIGH_SPEED_FREQ;
                        the_card_info[slot].divider_val = clock_freq_to_set;
                        }
                retval = emmc_io_rw_52(slot, 0, CCCR_HIGH_SPEED, &dat, 0, 0);
                if(!retval)
                        printf("WE HAVE RETVAL = %x and dat = %x\n", retval,dat);
                }
        }
#endif





      HOUSEKEEP:
	the_card_info[slot].divider_val = clock_freq_to_set;
	the_card_info[slot].enum_status = retval;
	emmc_clear_bits(EMMC_REG_CTRL, ENABLE_OD_PULLUP);
	emmc_set_clk_freq(clock_freq_to_set);
	return retval;
}

#endif

////////////////////

static void short_response_postproc_volt_switch_stage_2(void *the_data, u32 * interrupt_status)
{
	current_task_status *the_task_status = (current_task_status *) the_data;
    printf("The second stage of CMD11 interrupt received\n");
    
    /* Handle standard interrupt handler */
	emmc_handle_standard_rinsts(the_data, *interrupt_status);
    if(the_task_status->error_status == ERRUNDERWRITE){ 
            // this is actually set because of HTO/INTMSK_VSI interrupt
            // Undo the setting of the error
        printf("VOLT Switch interrupt received for second stage of Voltage Switch Command\n");
        the_task_status->error_status = ERRNOERROR;
		the_task_status->cmd_status = TSK_COMMAND_DONE; //This is required for us to return from ISR
    }
    
    return;
}
/**
  * This command Swithes the signaling voltage to 1.8V.
  * This command should be called when card indicates the voltage switching in the response of ACMD41.
  * Voltage switching is initiated by sending the CMD11. Card should be in ready state to respond to CMD11.
  * It is responsibility of the caller of this function to ensure the card in Ready state.
  * If Voltage switching fails, the caller should do a power cycle to the card.
  *	-# Check if any card is present in the slot
  *	-# Check if the card is in the idle state
  *	-# Swithc to High Power mode by programming cclk_low_power bit in CLKENA set to zero.
  *	-# If there is a failure in the voltage setting, mark the card as
  *	inactive.
  * @param[in] slot The slot in which the card is
  * \return Returns 0 upon succes and error status upon failure
  */

u32 emmc_switch_voltage_18(u32 slot)
{
	u32 resp_buffer = 0; //CMD11 returns R1 response
	u32 retval = 0;
	
	/* Is the card connected ? */
	if (!(CARD_PRESENT(slot))) {
		return ERRCARDNOTCONN;
	}

	/* Check if it is in the correct state */
	if (the_card_info[slot].card_state != CARD_STATE_READY) {
		return ERRFSMSTATE;
	}
	// Clear the cclk_low_power to switch to High power mode for corresponding card.
    printf("Clearing CLKENA bit to switch to High Power mode for Corresponding card]\n");
	emmc_clear_bits(EMMC_REG_CLKENA, (1 << (slot + 16)));
    
	if ((retval = emmc_send_clock_only_cmd())) {
        printf("ERROR in sending CLK ONLY CMD\n");
    }

	// As per the databook, software needs to enable 2ms timer. In this driver, software does not create explicit timer for 2sec, but the
	// CMD timeout, which is of 10sec duration is used. If voltage switching happens properly, VOLT_SWITCH_INT will bring the control back
	// otherwise a worst case of 10sec lapses software resumes with timeout.
    printf("Sending SD_CMD11 to the card\n");
	if ((retval =  emmc_send_serial_command(slot, SD_CMD11, 0, &resp_buffer, NULL, 0, NULL, NULL))) {
		printf("VOLTAGE SWITCHING Failied...Take the Card out and Reinsert again...\n");
		return retval;
	}

	// The CMD11 received the response.
	printf("Response received for CMD11 is %08x\n", resp_buffer);
	printf("STAGE 1 Voltage switching over Starting STAGE 2 Voltage Switching\n");

    //Prepare for the second stage of CMD11
    current_task.postproc_callback = short_response_postproc_volt_switch_stage_2;
	current_task.slot_num = slot;
	current_task.error_status = 0;
	current_task.aborted_command = 0;
	current_task.cmd_status = TSK_STAT_STARTED;
	current_task.bus_corruption_occured = 0;

	// Switch Off the clock to the card	
    printf("STOP the CLK to corresponding card\n");
	emmc_clear_bits(EMMC_REG_CLKENA, (1 << slot)); // Stop the clock to the card
	if ((retval = emmc_send_clock_only_cmd_for_volt_switch())) {
        printf("ERROR in sending CLK ONLY CMD\n");
    }
	// Program the VOLT_REG to appropriate values for the corresponding card
    printf("Setting UHSREG bit for setting 1.8V operation for corresponding card\n");
	emmc_set_bits(EMMC_REG_UHSREG, (1 << slot)); // Enable 1.8V operation for corresponding card
    printf("UHSREG after programming during voltage switching %08x\n",emmc_read_register(EMMC_REG_UHSREG));

	// Start a Timer for 1Sec (Value recommended should be greater than 5ms). By the end of 1s, Host voltage regulators are assumed to be stable.
	if ((plat_reenable_upon_interrupt_timeout())) {
		printf("1 Second Timer Lapsed... Proceed to Enable the clock\n");
	}
	
	// Program the CLKENA to enable the clock. Note that cclk_low_power bit is zero. So this forces the host controller to drive the clock at 1.8V.
	emmc_set_bits(EMMC_REG_CLKENA, (1 << slot));
	if ((retval = emmc_send_clock_only_cmd_for_volt_switch())) {
        printf("ERROR in sending CLK ONLY CMD\n");
    }

	// Start a Timer for 1Sec (Value recommended should be greater than 5ms). By the end of 1s, Host voltage regulators are assumed to be stable.
	if ((plat_reenable_upon_interrupt_timeout())) {
		printf("ERROR: 1 Second Timer Lapsed... No VOLT_SWITCH_INT received\n");
		printf("ERROR: Caller of this function should initiate a power cycle to recover....\n");
		// Clear the bit in VOLT_REG to fall back to 3.3V operating mode as no VOLT_SWITCH_INT received
		emmc_clear_bits(EMMC_REG_UHSREG, (1 << slot)); // Enable 1.8V operation for corresponding card
		return ERRHARDWARE;
	}
	
		emmc_remove_command();
        the_card_info[slot].volt_switch_done = 1; // Set the flag to indicate the Voltage switching done
        plat_delay(100);
     
        return retval;
}

/**
  * This function reads and stores the CSD for SD2.0.
  * This function is used by the initialization routines to evaluate the CSD. The CSD is read  
  * validates for SD2.0 card by verifying NSAC and TAAC fields and programs the_card_info data structure  
  * with maximum read/write latency. Also the capacity of the card and  
  * the block sizes for the device are also calculated and stored away in the_card_info structure.  
  * @param[in] slot The specified slot.  
  * \return 0 upon success. The error status upon error.
  */
u32 emmc_process_SD_2_0_csd(u32 slot)
{

	u32 buffer_reg, retval;
	u32 read_block_size, write_block_size;
	u32 card_size;
	u32 blocknr, blocklen;

	buffer_reg = emmc_read_register(EMMC_REG_CDETECT);
	if (buffer_reg & (1 << slot)) {
		return ERRCARDNOTCONN;
	}


	if (CARD_STATE_STBY != the_card_info[slot].card_state) {
		printf("This is in the wrong FSM state for CSD fetch %x\n",the_card_info[slot].card_state);
		return ERRFSMSTATE;
	}

	if ((retval = emmc_send_serial_command(slot, CMD9, 0, the_card_info[slot].the_csd, NULL, 0, NULL, NULL))) {
		return retval;
	}
	/* The CSD is in the bag */

	/* Store the largest TAAC and NSAC. We will use these for calculating the data timeout latency. */
	printf("**************CSD of SD2.0**********************\n");
	printf("0x%08x 0x%08x 0x%08x 0x%08x\n",
	       the_card_info[slot].the_csd[0],
	       the_card_info[slot].the_csd[1],
	       the_card_info[slot].the_csd[2],
	       the_card_info[slot].the_csd[3]);
	printf("**************CSD of SD2.0**********************\n");


	if (CSD_TAAC(the_card_info[slot].the_csd) != 0x0E)
	return ERRHARDWARE;		
	else {
	printf("This is SD2.0 CARD since TAAC is %x\n",CSD_TAAC(the_card_info[slot].the_csd));	
	}

	if (CSD_NSAC(the_card_info[slot].the_csd) != 0x00)
	return ERRHARDWARE;		
	else {
	printf("This is SD2.0 CARD since NSAC is %x\n",CSD_NSAC(the_card_info[slot].the_csd));	
	}
	
	if(CSD_READ_BL_LEN(the_card_info[slot].the_csd) != 0x09)
	return ERRHARDWARE;		
	else {
	printf("For SD2.0  READ_BL_LEN is 512\n");
	read_block_size  = 1 << (CSD_READ_BL_LEN((the_card_info[slot].the_csd)));
	}
	
	if(CSD_WRT_BL_LEN(the_card_info[slot].the_csd) != 0x09)
	return ERRHARDWARE;		
	else {
	printf("For SD2.0  WRITE_BL_LEN is 512\n");
	write_block_size = 1 << (CSD_WRT_BL_LEN((the_card_info[slot].the_csd)));
	}

	/* go through section 5.3.3 of Physical layer specifications of  SD2.0
		to compute the cared capacity 
	 */
	blocknr = ((CSD_C_SIZE_SD_2_0(the_card_info[slot].the_csd) & 0x3fffff) + 1);
	blocklen = read_block_size;
	card_size = blocknr * blocklen;
	
	/* read/write block size */
	the_card_info[slot].card_write_blksize = 512;
	the_card_info[slot].orig_card_read_blksize = 512;
	the_card_info[slot].card_read_blksize = 512;
	the_card_info[slot].orig_card_write_blksize = 512;
	/* Set the card capacity Note the capacity is in Kilo bytes*/
	the_card_info[slot].card_size = blocknr * 1024;

/*
	printf("Card capacity = %x Kbytes\n", card_size);
	printf("Read Block size = %x bytes\n",the_card_info[slot].card_read_blksize);
	printf("Write Block size = %xbytes\n",the_card_info[slot].card_write_blksize);
*/
	printf("Card capacity = %x Kbytes\n", card_size);
	printf("Read Block size = %x bytes\n",the_card_info[slot].card_read_blksize);
	printf("Write Block size = %xbytes\n",the_card_info[slot].card_write_blksize);
	return 0;
}

/**
  * Set Wide bus for SD card.
  * While in USH-1 operating mode, the bus width should be 4 bit for SD cards.
  * After Voltage switching the card will be in 4 bit mode.
  * Host controller can send the ACMD6 to switch the operating bus width.
  * This function sets the wide bus (4 bit wide) for a SD card.
  * Application specific command ACMD6 is used for this purpose.
  * CTYPE register of Host controller IP is programmed accordingly based on the success of ACMD6
  *     -# Send the ACMD6 with argument indicating bus width as 2 for 4 bit wide bus.
  *     -# Program CTYPE register of host controller IP once ACMD6 is successful.
  * @param[in] slot The slot in which the card is placed.
  * @param[in] width 4 => 4 bit wide bus, 0=> 1 bit wide bus.
  * \return Returns 0 upon success and the error status upon failure.
  * \callgraph
  */

u32 emmc_set_sd_wide_bus_VS(u32 slot, u32 width)
{
	u32 retval, arg;
	u32 resp;


	if (4 == width) {
		arg = 2;
	} else if (0 == width) {
		arg = 0;
	} else {
		return ERRILLEGALCOMMAND;
	}

	if ((retval =
	     emmc_send_serial_command(slot, ACMD6, arg, &resp, NULL, 0, NULL, NULL))) {
             printf("WE HAVE RETVAL = %x\n", retval);
	     return retval;
	}

	/* now set the width of the bus */
    printf("Bus Width is 4 bit Now.. Change CTYPE register accordingly\n");
	emmc_clear_bits(EMMC_REG_CTYPE, (1 << slot) || (1 << (slot + 16)));
	if (4 == width) {
		emmc_set_bits(EMMC_REG_CTYPE, (1 << slot));
	}

	return 0;
}

/**
  * Set SD card towork in DDR mode.
  * This function checks and switches to operate in DDR mode.
  * Issue CMD6 in mode 0 to check the Driver Strenght of the card [Function group 3].
  *     -# Check resulted in Error. If not proceed.
  * Issue CMD6 in mode 0 to check "Bus Speed Mode"  and "Current Limit" of the card [Function group 1 and 4].
  *     -# Check resulted in Error. If not proceed.
  * Issue CMD6 in mode 1 to switch to DDR operation [Function group 1].
  *     -# Check resulted in Error. If not proceed.
  *     
  * @param[in] slot The slot in which the card is placed.
  * \return Returns 0 upon success and the error status upon failure.
  * \callgraph
  */
u32 emmc_set_sd_ddr(u32 slot)
{
        u32 retval;
        u32 *resp_buffer;
        u8 *the_data_buffer;
        u16 the_data_16; //To hold 16 bit contents. A temporary variable

        resp_buffer = (u32 *)plat_alloc(sizeof(u32)*4);         //how to replace    lly
        the_data_buffer = (u8 *)plat_alloc(sizeof(u32)* 16);

        memset((void *) (resp_buffer), 0, (sizeof(u32) * 4));
        memset((void *) (the_data_buffer), 0, (sizeof(u32) * 16));

        if ((the_card_info[slot].csd_union.csd_dwords[0x02] & 0x40000000) == 0) {    //CCC P151
                printf("This SD card doest not support switch commands which fall under Class-10\n");
                return ERRNOTSUPPORTED;
        }

//As response of CMD6,the SD card will send R1 response on the CMD line and 512 bits of status on the DAT line   ly  
		//Check for Drive strength, Current Limit, UHS-1 Access mode using CMD6 in Mode 0
        if ((retval =  emmc_read_write_bytes(slot, resp_buffer,the_data_buffer, 0, 64, 0x00ff0000,NULL, NULL, 0,
                                       CMD6 | 7 << CUSTOM_BLKSIZE_SHIFT | CUSTCOM_DONT_CMD16 | CUSTCOM_DONTSTDBY, NULL, NULL))) {
                printf("The return value is %x\n",retval);
                return retval;
        }
        
        printf("The response Received in MODE 0 is  %08x %08x %08x %08x\n", resp_buffer[0],resp_buffer[1],resp_buffer[2],resp_buffer[3]);
        
        //Check for Maximum current consumption for default functions
        the_data_16 = ((the_data_buffer[63-63] << 8) | the_data_buffer[63-62]);
        if((the_data_16 & 0xFFFF) != 0 ){ // Bits 511:496 Should not be zero
			printf("Maximum Current Consumption is %x ma\n",the_data_16);
		}
		else{
			printf("ERROR: Maximum Current Consumption reads ZERO => Error\n");
			return ERRNOTSUPPORTED;
		}
//the format of the_data_buffer is a question for me ly
        the_data_16 = ((the_data_buffer[63-57] << 8) | the_data_buffer[63-56]); // Bits 463:448
		printf("The Current Limit supported      = %04x\n",the_data_16);
        the_data_16 = ((the_data_buffer[63-55] << 8) | the_data_buffer[63-54]); // Bits 447:432
		printf("The Drive Strength supported     = %04x\n",the_data_16);
        the_data_16 = ((the_data_buffer[63-51] << 8) | the_data_buffer[63-50]); // Bits 415:400
		printf("The UHS-1 Mode (Access)supported = %04x\n",the_data_16);

		/*Before issueing the CMD6 in Mode 1, the driver should check whether Current Limit of 400ma and Access mode DDR50 is supported by the card*/
		if(((((the_data_buffer[63-57] << 8) | the_data_buffer[63-56]) & 0x0002) != 0) && ((((the_data_buffer[63-51] << 8) | the_data_buffer[63-50]) & 0x0010) != 0)){
			printf("The card supports 400ma of current Limit Or DDR50 Access mode\n");
		}
		else{
			printf("ERROR: DDR support is not possible with this card\n");
			return ERRNOTSUPPORTED;
		}

		printf("Proceeding to issue the CMD6 in Mode 1\n");

		// Issue the CMD6 to change the Current Limit ot 400ma Accessmode to DDR50

        memset((void *) (resp_buffer), 0, (sizeof(u32) * 4));
        memset((void *) (the_data_buffer), 0, (sizeof(u32) * 16));
		
        plat_delay(100); // Just to introduce delay between mode 0 and mode 1.
		
        if ((retval =  emmc_read_write_bytes(slot, resp_buffer,the_data_buffer, 0, 64, 0x80ff1F04,NULL, NULL, 0,
                                       CMD6 | 7 << CUSTOM_BLKSIZE_SHIFT | CUSTCOM_DONT_CMD16 |CUSTCOM_DONTSTDBY, NULL, NULL))) {
                printf("The return value is %x\n",retval);
                return retval;
        }
        printf("The response in Mode 1 is  %08x %08x %08x %08x\n", resp_buffer[0],resp_buffer[1],resp_buffer[2],resp_buffer[3]);
    
        //Check for Maximum current consumption for default functions
         the_data_16 = ((the_data_buffer[63-63] << 8) | the_data_buffer[63-62]);
        if((the_data_16 & 0xFFFF) != 0 ){ // Bits 511:496 Should not be zero
			printf("Maximum Current Consumption is %x ma\n",the_data_16);
		}
		else{
			printf("ERROR: Maximum Current Consumption reads ZERO => Error\n");
			return ERRNOTSUPPORTED;
		}
    		
		if((the_data_buffer[63-48] & 0x0F) == 0x0F){ //Bits 395:392. 0xF indicates the function returned error
            printf("Bits 395:392 reads %01x\n",the_data_buffer[63-48] & 0x0F);
			printf("ERROR: Currnet Limit could not be set to 400ma\n");
			return ERRNOTSUPPORTED;
		}
		if((the_data_buffer[63-47] & 0x0F)  == 0x0F){ //Bits 379:376.  0xF indicates the function returned error
            printf("Bits 379:376 reads %01x\n",the_data_buffer[63-47] & 0x0F);
			printf("ERROR: Access Mode could not be set to DDR50\n");
			return ERRNOTSUPPORTED;
		}
	
		printf("Programming the UHS-1 register to enable DDR operation\n");
		// Program the CLKENA to operate in Low power mode
		emmc_set_bits(EMMC_REG_CLKENA, (1 << (slot + 16)));
    	if ((retval = emmc_send_clock_only_cmd())) {
            printf("ERROR in sending CLK ONLY CMD\n");
        }

		// Program the UHS-1 register to set DDR operation
		emmc_set_bits(EMMC_REG_UHSREG,(1 << (slot + 16)));

		plat_delay(100);

		// Program the CLKENA to operate in Low power mode
		emmc_clear_bits(EMMC_REG_CLKENA, (1 << (slot + 16)));
    	if ((retval = emmc_send_clock_only_cmd())) {
          printf("ERROR in sending CLK ONLY CMD\n");
       }

		printf("Successfully Switched to DDR mode of operation");

        return 0;
}

/**
  * This function does the single byte io read from a SDIO card. 
  * @param[in] slot The slot for the function
  * @param[in] func The function number on the card
  * @param[in] address The address from which to read or write from
  * @param[in,out] data The data for the exchange.
  * @param[in] read_or_write 1 = write, 0 = read
  * @param[in] op_flags The operation flags.
  * \return 0 upon success.
  */
u32 emmc_io_rw_52(u32 slot, u32 func, u32 address, u8 * data,
		      u32 read_or_write, u32 op_flags)
{
	u32 retval = 0;
	u32 cmd52_arg = 0;
	u32 resp, rinsts;
	current_task_status dummy_task = { 0 };


	if (emmc_read_register(EMMC_REG_CDETECT) & (1 << slot)) {
		retval = ERRCARDNOTCONN;
		goto HOUSEKEEP;
	}


	if (func > 7) {
		retval = ERRADDRESSMISALIGN;
		goto HOUSEKEEP;
	}

	/* We have case for extended IO */
	if (read_or_write) {
		SET_BITS(cmd52_arg, IO_RW_RW_FLG_MSK);
		cmd52_arg |= *data;
	}

	SET_FUNC_NUM(cmd52_arg, func);


	if (address > IO_RW_REG_MAX_VAL) {
		retval = ERRADDRESSMISALIGN;
		goto HOUSEKEEP;
	}

	SET_IO_RW_REG_ADD(cmd52_arg, address);

	if (op_flags & SDIO_USE_ASYNC_READ) {
		emmc_send_raw_command(slot,CMD52 | CMD_RESP_EXP_BIT, cmd52_arg);
		while (!(emmc_read_register(EMMC_REG_RINTSTS) & CMD_DONE_BIT));
		rinsts = emmc_read_register(EMMC_REG_RINTSTS);
		emmc_handle_standard_rinsts(&dummy_task, rinsts);
		if (dummy_task.error_status) {
			retval = dummy_task.error_status;
			goto HOUSEKEEP;
		}
		resp = emmc_read_register(EMMC_REG_RESP0);
	} else {

		if ((retval =
		     emmc_send_serial_command(slot, CMD52,
						  cmd52_arg, &resp,
						  NULL, 0, NULL, NULL))) {
			goto HOUSEKEEP;
		}
	}

	*data = (u8) (resp & IO_RW_DATA_MSK);

      HOUSEKEEP:
	return retval;
}

/**
  * This function does the multiple io read from a SDIO card. 
  * @param[in] slot The slot for the function
  * @param[in] func The function number on the card
  * @param[in] address The address from which to read or write from
  * @param[in,out] data The data for the exchange.
  * @param[in] length The length of the transfer in bytes.
  * @param[in] read_or_write 1 = write, 0 = read
  * @param[in] op_flags The operation flags.
  * @param[in] the_term_function The custom termination function
  * @param[in] the_copy_function The custom copy function.
  * \return 0 upon success.
  */
u32 emmc_io_rw(u32 slot, u32 func, u32 address, u8 * data,
		   u32 length, u32 read_or_write, u32 op_flags,
		   emmc_term_function the_term_function,
		   emmc_copy_function the_copy_function)
{
	u32 cmd53_arg = 0;
	u32 retval = 0;
	u32 resp_buff[4];
	u32 cmd_to_send;

//	printf
//	    ("%s: address = 0x%x length = %x read_or_write = %x function = %x\n",
//	     __FUNCTION__, address, length, read_or_write, func);
	if (emmc_read_register(EMMC_REG_CDETECT) & (1 << slot)) {
		retval = ERRCARDNOTCONN;
		goto HOUSEKEEP;
	}


	if (func > 7) {
		retval = ERRADDRESSMISALIGN;
		goto HOUSEKEEP;
	}

	if (read_or_write) {
		SET_BITS(cmd53_arg, IO_RW_RW_FLG_MSK);
	}

	SET_FUNC_NUM(cmd53_arg, func);

	if (op_flags & CMD53_USE_BLOCK_IO) {
		u32 length_to_set;
		length_to_set = (length / CMD53_GET_BLKSIZ(op_flags));
		SET_BITS(cmd53_arg, IO_RW53_BMODE_MSK);
		SET_BITS(cmd53_arg, length_to_set);
	} else {
		UNSET_BITS(cmd53_arg, IO_RW53_BMODE_MSK);
		SET_BITS(cmd53_arg, length);
	}

	/* If we are accesing a fifo inside the card
	 */
	if (op_flags & CMD53_FIFO_WRITE_FLAG) {
		UNSET_BITS(cmd53_arg, IO_RW53_OP_CODE_MSK);
	} else {
		SET_BITS(cmd53_arg, IO_RW53_OP_CODE_MSK);
	}

	if (address > IO_RW_REG_MAX_VAL) {
		retval = ERRADDRESSMISALIGN;
		goto HOUSEKEEP;
	}

	SET_IO_RW_REG_ADD(cmd53_arg, address);

	if (length > 0x1ff) {
		retval = ERRADDRESSMISALIGN;
		goto HOUSEKEEP;
	}

	cmd_to_send = (read_or_write) ? WCMD53 : CMD53;

	retval =
	    emmc_read_write_bytes(slot, resp_buff, data, 0,
				      length, cmd53_arg,
				      the_copy_function,
				      the_term_function,
				      read_or_write,
				      cmd_to_send | CUSTCOM_DONT_CMD16 |
				      CUSTCOM_DONTSTDBY |
				      CUSTCOM_STREAM_RW |
				      CUSTCOM_DONT_TRANS, NULL, NULL);
//	printf("%s:emmc_read_write_bytes returned %x\n", __FUNCTION__,
//	       retval);
      HOUSEKEEP:
	return retval;
}

/**
  * Read in data from the FIFO in interrupt context.
  * This function reads in the bytes from the fifo in interrupt context. This 
  * function is called for a RXDR interrupt or a transfer complete interrupt.
  * For the RXDR interrupt, the RX_watermark/2 + 1 dwords are read from the   //RXDR: Receive FIFO data request
  * FIFO. If there is a data transfer over interrupt, we know that all remaining 
data  * is languishing in the fifo. Hence we check the status register and find 
the exact  * amount of data to read and read the same. If there is any unalighen 
bytes that may  * be needed to be read, it is also taken care of during reading 
the last double word  * from the FIFO.
  *
  * @param[in,out] the_task_status The status of the data transfer task.
  * @param[in] the_interrupt_status the flags for which particular interrupts 
have occured.  * \return Returns 0 for successful copying. Returns the error 
code upon errors.  * \todo Employ the <i>the_copy_function</i> in the task 
status for a custom data  */
u32 emmc_read_in_data(current_task_status * the_task_status,
			  u32 the_interrupt_status)
{
	u32 buffer_reg;
	u32 u32s_to_read, u32s_left = 0;
        u32  u32s_to_read_temp;
	int task_bytes_left, last_word_check = 0, count;
	// u32 aligned_address; 
	u32 the_block_size = the_task_status->blksize;
        u32 data_read;
	u8 *u8_buffer;
    
    printf("Num_of_blocks = %x blk_size = %x bytes_read = %x\n",the_task_status->num_of_blocks,the_block_size,the_task_status->num_bytes_read);

    task_bytes_left =   the_task_status->num_of_blocks * the_block_size - the_task_status->num_bytes_read;
	printf("task_bytes_left = %x\n", task_bytes_left);

	buffer_reg = L_EMMC_REG_STATUS; //Read the FIFO status register
    printf("STATUS = 0x%08x\n", buffer_reg);

	if (the_interrupt_status & INTMSK_DAT_OVER) {//IF DATA TRANSMISSION is complete
		buffer_reg = L_EMMC_REG_STATUS; //read register status
        //if FIFO is FUll, then the no of words to read out of FIFO is FIFO DEPTH number of words from FIFO
        //else Read Only the number of words available in the FIFO
		if (buffer_reg & STATUS_FIFO_FULL) {            
			u32s_to_read = the_ip_status.fifo_depth;
		} else {
			u32s_left = (GET_FIFO_COUNT(buffer_reg));
			u32s_to_read = u32s_left;
            // If the number of bytes to be read out of FIFO is not a multiple of Wods last_word_check holds the
            // byte left to read from last word
			if (u32s_to_read * FIFO_WIDTH > task_bytes_left) {
				u32s_to_read--;//Need to read one word less of our initial computation  why   ly 
				last_word_check = task_bytes_left % FIFO_WIDTH;
			}
		}
	} 
    else {  //NOW RXDR is set but Transfer is not complete........
            // u32s_left gives the number of words to be read to accomplish successful transfer
    		if (the_task_status->num_of_blocks) {
	    		u32s_left = task_bytes_left / FIFO_WIDTH;
		} 
          	else{
	        	u32s_left = the_ip_status.fifo_threshold + 1;
		}

    		if(u32s_left < (the_ip_status.fifo_threshold)) {
			u32s_to_read = u32s_left;
		}
	        else{
			u32s_to_read = the_ip_status.fifo_threshold + 1;
		}
		    printf("Got u32s to read as = %x\n", u32s_to_read);
	    }

	// Check if the interrupt status says RX ready 
	if ((the_interrupt_status & INTMSK_RXDR) || (the_interrupt_status & INTMSK_DAT_OVER)) {
    		printf("dwords read = %x dwords to read = %x dwords left = %x\n",(the_task_status->num_bytes_read / FIFO_WIDTH),u32s_to_read, u32s_left);
	    	u8_buffer = (the_task_status->data_buffer +  the_task_status->num_bytes_read);
           u32s_to_read_temp = u32s_to_read; 
            for (count = 0; count < u32s_to_read_temp; count++) {
#if 0
			    aligned_address = emmc_read_register(FIFODAT);
			    if (task_bytes_left) {
				    memcpy((void *) (u8_buffer + count * FIFO_WIDTH),(void *) &aligned_address,FIFO_WIDTH);
			    }
#endif
			    if (task_bytes_left) {
			    //	printf("status is %x \n",L_EMMC_REG_STATUS);
                    if (GET_FIFO_COUNT( L_EMMC_REG_STATUS))    
                        {
                            data_read = emmc_read_register(EMMC_REG_FIFODAT);
                          //  printf("data_read is %x \n",data_read);

        		    *((u32 *) (u8_buffer +  count * 4)) = data_read;
                            //  emmc_read_register(FIFODAT);
                         }
                    else{
                            u32s_to_read--; //This was not read. So decrement u32s_to_read.
                            printf("NO more Read Possible as FIFO_COUNT is zero\n");
                    }
                        
			    }
		    }

//memcpy函数的功能是从源src所指的内存地址的起始位置开始拷贝n个字节到目标dest所指的内存地址的起始位置中。
//void *memcpy(void *dest, const void *src, size_t n);  
	    
            if (last_word_check && task_bytes_left) {
			// There is a dangling few bytes to be read in 
                printf("Few dangling bytes to be read!!!!\n");
	    		buffer_reg = emmc_read_register(EMMC_REG_FIFODAT);
		    	memcpy((void *) (the_task_status-> data_buffer + (u32s_to_read * FIFO_WIDTH)),(void *) (&buffer_reg), last_word_check);

		    }
		    
            if (task_bytes_left) {
			    the_task_status->num_bytes_read +=   u32s_to_read * 4 + last_word_check;
		    }
		    
            printf("The number of read bytes = %x\n",the_task_status->num_bytes_read);

		    // If there is a termination function registered,
		    //   call it after every transfer. Under this condition
		    //   we can stop open ended transfers
		 
	    	if (the_task_status->the_term_function) {
		    	if (the_task_status->the_term_function(the_task_status->data_buffer, the_task_status->num_bytes_read)) {
    				the_task_status->aborted_command = 1;
	    			emmc_abort_trans_work(the_task_status-> slot_num);
			    }
		    }
        	
    }
    else {
    		the_task_status->error_status = ERRUNKNOWN;
	    	return ERRUNKNOWN;
    }

	if ((the_interrupt_status & INTMSK_DAT_OVER) && (the_task_status->num_bytes_read !=	(the_task_status->num_of_blocks * the_block_size))
	    && (CEATA_TYPE != the_card_info[the_task_status->slot_num].card_type)) {
    		emmc_abort_trans_work(the_task_status->slot_num);
	    	return ERRHARDWARE;
    }
	return 0;
}

/**
  * Function to write out data to the data FIFO.
  * This function is called from interrupt context to write out the data into the 
  * FIFO when the TXDR  interrupt is asserted. This function writes out fifo   //TXDR: Transmit FIFO data request
  * threshold / 2 dwords into the fifo. It also checks whether the term function
  * signals a end of transfer signal. This is used in open ended transfers.
  * @param[in,out] the_task_status The status of the current transfer in progress.
  * @param[in] the_interrupt_status The value of the interrupt flags.
  * \todo Employ the copy function in the task status structures for copies.
  */
u32 emmc_write_out_data(current_task_status * the_task_status,
			    u32 the_interrupt_status)
{
	u32 pending_dwords, dangling_dwords = 0, dwords_to_write;
	u32 buffer = 0;
	u8 *src_buffer;
	int count;
	/* u32 aligned_address; */
	u32 the_block_size = the_task_status->blksize;


	/* For an open ended transfer, the number of blocks will be
	   set to 0. 
	 */
//	printf("Entered %s\n", __FUNCTION__);
	if (the_task_status->num_of_blocks) {
		pending_dwords =
		    (the_block_size
		     * the_task_status->num_of_blocks -
		     the_task_status->num_bytes_read) / FIFO_WIDTH;


		dangling_dwords =
		    (the_block_size
		     * the_task_status->num_of_blocks -
		     the_task_status->num_bytes_read) % FIFO_WIDTH;
	} else {
		pending_dwords =
		    the_ip_status.fifo_depth -
		    the_ip_status.fifo_threshold;
	}


	if (!(the_interrupt_status & INTMSK_TXDR)) {
		return ERRUNKNOWN;
	}


	if (pending_dwords >=
	    (the_ip_status.fifo_depth - the_ip_status.fifo_threshold)) {

		dwords_to_write =
		    (the_ip_status.fifo_depth -
		     the_ip_status.fifo_threshold);

		dangling_dwords = 0;
	} else {

		dwords_to_write = pending_dwords;
	}

	src_buffer =
	    (the_task_status->data_buffer +
	     the_task_status->num_bytes_read);

	for (count = 0; count < dwords_to_write; count++) {
#if 0
		if (pending_dwords) {
			memcpy((void *) &aligned_address,
			       (void *) (src_buffer + count * FIFO_WIDTH),
			       FIFO_WIDTH);
		}
		emmc_set_register(FIFODAT, aligned_address);
#endif
		emmc_set_register(EMMC_REG_FIFODAT,*((u32 *) (src_buffer + count * FIFO_WIDTH)));
	}

	if (dangling_dwords) {
		buffer = 0;
		memcpy((void *) &buffer, (void *) src_buffer,
		       dangling_dwords);
		emmc_set_register(EMMC_REG_FIFODAT, buffer);
	}


	printf
	    ("Number of bytes written out is %x (TBB = %x TCB = %x)\n",
	     the_task_status->num_bytes_read,
	     emmc_read_register(EMMC_REG_TBBCNT),
	     emmc_read_register(EMMC_REG_TCBCNT));

	if (pending_dwords) {
		the_task_status->num_bytes_read +=
		    (dangling_dwords + dwords_to_write * FIFO_WIDTH);
	}

	printf
	    ("Number of bytes written out is %x (TBB = %x TCB = %x)\n",
	     the_task_status->num_bytes_read,
	     emmc_read_register(EMMC_REG_TBBCNT),
	     emmc_read_register(EMMC_REG_TCBCNT));


	/* Now call the callback to check if we want to stop the transfer
	 * of the bytes.
	 */
	if (the_task_status->the_term_function) {
		if ((the_task_status->
		     the_term_function(the_task_status->
				       data_buffer,
				       the_task_status->num_bytes_read)) &&
		    (the_card_info[the_task_status->slot_num].card_type !=
		     CEATA_TYPE)) {
			emmc_abort_trans_work(the_task_status->
						  slot_num);
		}
	}


	return 0;
}

u32 emmc_check_r5_resp(u32 the_resp)
{
	u32 retval = 0;


//	printf("%s: response = 0x%08x\n", __FUNCTION__, the_resp);
	if (the_resp & R5_IO_ERR_BITS) {
		if (the_resp & R5_IO_CRC_ERR) {
			retval = ERRDCRC;
		} else if (the_resp & R5_IO_BAD_CMD) {
			retval = ERRILLEGALCOMMAND;
		} else if (the_resp & R5_IO_GEN_ERR) {
			retval = ERRUNKNOWN;
		} else if (the_resp & R5_IO_FUNC_ERR) {
			retval = ERRBADFUNC;
		} else if (the_resp & R5_IO_OUT_RANGE) {
			retval = ERRADDRESSRANGE;
		}
	}
	return retval;
}






////////////////////////////////////////////// IDMA 

u32 emmc_is_desc_owned_by_dma(DmaDesc *desc)
{
  if((desc->desc0 & DescOwnByDma) == DescOwnByDma) 
    return 1; //if OWN bit is set, Descriptor is owned by DMA
  else
    return 0; //if OWN bit is not set, Descriptor is not owned by DMA   
    
}

/**
  * This function checks whether this descriptor is the last descriptor.
  * The function returns true if it is last descriptor either in ring mode or in chain mode.
  * For Ring mode of operation, the function checks on the End Of Ring bit in DESC0 and for
  * Chain mode of operation, it checks whether buffer2 address is pointing to the head of the descriptor chain.
  * @param[in] Pointer to the Descriptor
  * \return returns true if it is last descriptor, false if not.
  * \note This function should not be called before initializing the descriptor using synopGMAC_desc_init().
  */
boolean emmc_is_last_desc(DmaDesc *desc)
{
  if(((desc->desc0 & DescEndOfRing) == DescEndOfRing) || (u32)current_task.desc_head == desc->desc3_virt)
    return 1;
  else 
    return 0;
}

/**
  * This function checks whether the descriptor is chained or not
  * The function checks the Desccriptor second address chained bit in the DESC0.
  * @param[in] Pointer to the Descriptor
  * \return Returns 1 if the descriptor is in chain mode else returns 0
  */
u32 emmc_is_desc_chained(DmaDesc *desc)
{
  if((desc->desc0 & DescSecAddrChained) == DescSecAddrChained)        
    return 1;
  else
    return 0;   
}

/**
  * This function initializes the individual descriptors for ring (dual-buffer) mode of operation
  * When the function is called with the last_ring_desc argument with boolean TRUE,
  * the descriptor control field is modified to indicate the current descriptor is the
  * last descriptor in the ring of descriptors.
  * @param[in] pointer to the descriptor  
  * @param[in] boolean type indicating whether the descriptor is last in the ring or not.
  * \return Returns void.
  */
void emmc_init_ring_desc(DmaDesc *desc, boolean last_ring_desc)
{
  desc->desc0      = last_ring_desc ? DescEndOfRing : 0;
  desc->desc1      = 0;
  desc->desc2      = 0;
  desc->desc3      = 0;
  desc->desc2_virt = 0;
  desc->desc3_virt = 0;
  return;
}

/**
  * This function initializes the individual descriptors for chain mode of operation
  * The second adddress chained bit in the Descriptor control field is set, indicating
  * the DESC3 field of descriptor points to the next descriptor in the chain of descriptors.
  * This function Does not disturb the DESC3 field. All other fields are initialized to zeros.
  * @param[in] pointer to the descriptor  
  * \return Returns void.
  */

void emmc_init_chain_desc(DmaDesc * desc)
{
  desc->desc0      = DescSecAddrChained;
  desc->desc1      = 0;
  desc->desc2      = 0;
  desc->desc2_virt = 0;
  return;
}

/**
  * This function checks whether the descriptor is owned by DMA or Processor
  * The function checks the ownership bit in the DESC0 to indicate the ownership.
  * @param[in] Pointer to the Descriptor
  * \return Returns 1 if owned by DMA else returns 0
  */
u32 emmc_is_desc_free(DmaDesc *desc)
{
	if((desc->desc0 & DescOwnByDma) == 0)
		return 1; //if OWN bit is not set Descriptor is free
	else
		return 0; //if OWN bit is still set Desccriptor is owned by DMA		
}

/**
  * Prepares the descriptor for the transfers.
  * The descriptor is allocated with the valid buffer addresses and the length fields and handed 
  * over to DMA by setting the ownership bit. After successful return from this function the
  * descriptor is added to the descriptor pool/queue.
  * This Api is same for both ring mode and chain mode.
  * @param[in] Dma-able buffer1 pointer.
  * @param[in] length of buffer1 (Max is 8192 bytes).
  * @param[in] Virtual address of buffer1 pointer.
  * @param[in] Dma-able buffer2 pointer.
  * @param[in] length of buffer2 (Max is 8192 bytes).
  * @param[in] Virtual address of buffer2 pointer.
  * \return returns valid descriptor index on success. Returns Negative value on error.
  */
s32 emmc_set_qptr(u32 Buffer1, u32 Length1, u32 Buffer1_Virt, u32 Buffer2, u32 Length2, 
				u32 Buffer2_Virt)
{
   	u32  next      = current_task.next;
	DmaDesc *desc  = current_task.desc_next;

	//Program the Descriptor base address
//	emmc_set_register(EMMC_REG_DBADDR,(u32)virt_to_phys(desc));
	emmc_set_register(EMMC_REG_DBADDR,0x20030000);

	if(!emmc_is_desc_free(desc))
		return -1;
    
	if(emmc_is_desc_chained(desc)){
		desc->desc1       = ((Length1 << DescBuf1SizeShift) & DescBuf1SizMsk);
		desc->desc2       = Buffer1;
		desc->desc2_virt  = Buffer1_Virt;
		desc->desc0      |= DescOwnByDma | DescFirstDesc | DescLastDesc; // We handle only one buffer per descriptor

		current_task.next      = emmc_is_last_desc(desc) ? 0 : next + 1;
	   	current_task.desc_next = (DmaDesc *)desc->desc3_virt; //desc3_virt contains the next descriptor address
	}
	else{
		desc->desc1       = (((Length1 << DescBuf1SizeShift) & DescBuf1SizMsk) | 
						     ((Length2 << DescBuf2SizeShift) & DescBuf2SizMsk));
		desc->desc2       = Buffer1;
		desc->desc2_virt  = Buffer1_Virt;
		desc->desc3       = Buffer2;
		desc->desc3_virt  = Buffer2_Virt;
		desc->desc0      |= DescOwnByDma | DescFirstDesc | DescLastDesc; // We handle only one buffer per descriptor

		current_task.next      = emmc_is_last_desc(desc) ? 0 : next + 1;
	   	current_task.desc_next = emmc_is_last_desc(desc) ?
				                 current_task.desc_head : desc + 1; // if last: assign head as next 
	}
	printf("%02d %08x %08x %08x %08x %08x %08x %08x\n",next,(u32)desc,desc->desc0,desc->desc1,desc->desc2,
					desc->desc3,desc->desc2_virt,desc->desc3_virt);
	
	return next;
}		

/**
  * Get back the descriptor from DMA after data has been received/transmitted.
  * When the DMA indicates that the data is received (interrupt is generated), this function should be
  * called to get the descriptor and hence the data buffers. This function unmaps the buffer pointers
  * which was mapped for the DMA operation. With successful return from this
  * function caller gets the descriptor fields for processing.
  * @param[out] pointer to hold the status of DMA.
  * @param[out] Dma-able buffer1 pointer.
  * @param[out] pointer to hold length of buffer1 (Max is 8192).
  * @param[out] virtual pointer for buffer1.
  * @param[out] Dma-able buffer2 pointer.
  * @param[out] pointer to hold length of buffer2 (Max is 8192).
  * @param[out] virtual pointer for buffer2.
  * \return returns present rx descriptor index on success. Returns Negative value if error.
  */
s32 emmc_get_qptr( u32 * Status, u32 * Buffer1, 
				u32 * Buffer1_Virt, u32 * Buffer2, u32 * Buffer2_Virt)
{
		
   	u32  busy             = current_task.busy;      // Index of Descriptor, DMA owned from the last processing
	DmaDesc *busy_desc    = current_task.desc_busy; // the descriptor to be handled
	
	if(emmc_is_desc_owned_by_dma(busy_desc))    // If Descriptor is owned by DMA, we have nothing to process
		return -1;
	
	if(Status != 0)
		*Status = busy_desc->desc0;                  // Desc0 contains the control and Status fielsds

	if(Buffer1 != 0)
		*Buffer1 =busy_desc->desc2;
	if(Buffer1_Virt != 0)
		*Buffer1_Virt = busy_desc->desc2_virt;

	if(Buffer2 != 0)
		*Buffer2 = busy_desc->desc3;
	if(Buffer2_Virt != 0)
		*Buffer2_Virt = busy_desc->desc3_virt;
							    
	current_task.busy = emmc_is_last_desc(busy_desc) ? 0 : busy + 1; 
	if(emmc_is_desc_chained(busy_desc)){
	   	current_task.desc_busy = (DmaDesc *)busy_desc->desc3_virt;
		if(*Buffer1_Virt != 0){
			plat_unmap_single((struct pci_dev *)current_task.bus_device, *Buffer1, 0,BIDIRECTIONAL);
			printf("(Chain mode) buffer1 %08x is given back\n",*Buffer1_Virt);
		}
	}
	else{
		current_task.desc_busy = emmc_is_last_desc(busy_desc) ? 
				                 current_task.desc_head : (busy_desc + 1);
		if(*Buffer1_Virt != 0){
			plat_unmap_single((struct pci_dev *)current_task.bus_device, *Buffer1, 0,BIDIRECTIONAL);
			printf("(Ring mode) buffer1 %08x is given back\n",*Buffer1_Virt);
		}
		if(*Buffer2_Virt != 0){
			plat_unmap_single((struct pci_dev *)current_task.bus_device, *Buffer2, 0,BIDIRECTIONAL);
			printf("(Ring mode) buffer2 %08x is given back\n",*Buffer2_Virt);
		}
	}
	printf("%02d %08x %08x %08x %08x %08x %08x\n",busy,(u32)busy_desc,busy_desc->desc0,
					busy_desc->desc2,busy_desc->desc3,busy_desc->desc2_virt,busy_desc->desc3_virt);
	if(current_task.busy != current_task.next){
		return -1;
	}
	return(busy);
}

/**
  * Get back the descriptor from DMA when data transfer didnot take place(After the timeout happened).
  * This function just increments the busy pointer and the busy index.
  * This also unmaps the buffer pointer which got mapped for DMA operation.
  * This mechanis is required when IDMAC interrupts not getting generated for some reason.
  * Function caller gets the descriptor fields for processing. 
  * @param[out] pointer to hold the status of DMA.
  * @param[out] Dma-able buffer1 pointer.
  * @param[out] pointer to hold length of buffer1 (Max is 8192).
  * @param[out] virtual pointer for buffer1.
  * @param[out] Dma-able buffer2 pointer.
  * @param[out] pointer to hold length of buffer2 (Max is 8192).
  * @param[out] virtual pointer for buffer2.
  * \return returns present rx descriptor index on success. Negative value if error.
  */
s32 emmc_get_qptr_force( u32 * Status, u32 * Buffer1, 
				u32 * Buffer1_Virt, u32 * Buffer2, u32 * Buffer2_Virt)
{
		
   	u32  busy             = current_task.busy;      // Index of Descriptor, DMA owned from the last processing
	DmaDesc *busy_desc    = current_task.desc_busy; // the descriptor to be handled
	
	// This function just increments the busy pointer and the busy index.
        // This is required when IDMAC interrupts not getting generated for any of the commands
	if(Status != 0)
		*Status = busy_desc->desc0;                  // Desc0 contains the control and Status fielsds

	if(Buffer1 != 0)
		*Buffer1 =busy_desc->desc2;
	if(Buffer1_Virt != 0)
		*Buffer1_Virt = busy_desc->desc2_virt;

	if(Buffer2 != 0)
		*Buffer2 = busy_desc->desc3;
	if(Buffer2_Virt != 0)
		*Buffer2_Virt = busy_desc->desc3_virt;

	current_task.busy = emmc_is_last_desc(busy_desc) ? 0 : busy + 1; 
	if(emmc_is_desc_chained(busy_desc)){
	   	current_task.desc_busy = (DmaDesc *)busy_desc->desc3_virt;
		if(*Buffer1_Virt != 0){
			plat_unmap_single((struct pci_dev *)current_task.bus_device, *Buffer1, 0,BIDIRECTIONAL);
			printf("(Chain mode) buffer1 %08x is given back\n",*Buffer1_Virt); 
		}

	}
	else{
		current_task.desc_busy = emmc_is_last_desc(busy_desc) ? 
				                 current_task.desc_head : (busy_desc + 1);
		if(*Buffer1_Virt != 0){
			plat_unmap_single((struct pci_dev *)current_task.bus_device, *Buffer1, 0,BIDIRECTIONAL);
			printf("(Ring mode) buffer1 %08x is given back\n",*Buffer1_Virt);
		}
		if(*Buffer2_Virt != 0){
			plat_unmap_single((struct pci_dev *)current_task.bus_device, *Buffer2, 0,BIDIRECTIONAL);
			printf("(Ring mode) buffer2 %08x is given back\n",*Buffer2_Virt);
		} 
	}
	printf("%02d %08x %08x %08x %08x %08x %08x\n",busy,(u32)busy_desc,busy_desc->desc0,
					busy_desc->desc2,busy_desc->desc3,busy_desc->desc2_virt,busy_desc->desc3_virt);

	if(current_task.busy != current_task.next){
		return -1;
	}
	return(busy);
}


/**
  * This function dumps descriptr fields of all the descriptors in the list/chain.
  * This function is intended for debugging purpose.
  * @param[in] The mode the descriptors are organized: RING or CHAIN
  * \return returns void.
  */

void emmc_dump_descriptors(u32 Mode)  
{
	u32 Dcount=0;
	DmaDesc *desc = current_task.desc_head; 
	if(Mode == RINGMODE){
		while (Dcount != NO_OF_DESCCRIPTORS){
			printf("Desc_No: %02d \t desc0: %08x  desc1: %08x desc2: %08x desc3: %08x desc2_virt: %08x desc3_virt: %08x\n",								   	   Dcount,desc->desc0,desc->desc1,desc->desc2,desc->desc3,desc->desc2_virt,desc->desc3_virt);
			Dcount++;
			desc=desc+1;
		}
	}
	else{
		while (Dcount != NO_OF_DESCCRIPTORS){
			printf("Desc_No: %02d \t desc0: %08x desc1: %08x desc2: %08x desc3: %08x desc2_virt: %08x desc3_virt: %08x \n",								    		Dcount,desc->desc0,desc->desc1,desc->desc2,desc->desc3,desc->desc2_virt,desc->desc3_virt);
			desc=(DmaDesc *)desc->desc3_virt;
			if(desc == current_task.desc_head)
				break;
			Dcount++;
		}
	}

	printf(" Next Descriptor points to %x \t desc_next = %08x \n",current_task.next,(u32)current_task.desc_next);
	printf(" Busy Descriptor points to %x \t desc_busy = %08x \n",current_task.busy,(u32)current_task.desc_busy);
	return;
}

/**
  * This function sets up the descriptors either in Ring mode (Dual Buffer) or in Chain mode.
  * When this function is called with desc_mode argument as RINGMODE,
  * the no_of_desc number of descriptor are created (Memory allocation for descriptors are consistent and
  * complete memory for the descriptors are allocated at once) and every descriptor in the pool of descriptors 
  * are arranged in RING. Only last descriptor's control field of this ring structure contains the End_of_Ring set,
  * If memory allocation for the descriptors fail, -1 is returned an descriptors are not created.
  *
  * When this function is called with desc_mode agrument as CHAINMODE,
  * the no_of_desc number of descriptors are created one by one. Every descriptor holds the address of next descriptor
  * in the DESC3 filed. The last descriptor in the chain holds the address of the first descriptor of the chain.

  * the DESC3 field of descriptor points to the next descriptor in the chain of descriptors.
  * This function Does not disturb the DESC3 field. All other fields are initialized to zeros.
  * if memory allocation for any of the descriptors fail, the -1 is returned as the error number, and cleaning up
  * the allocated memory is the responsibility of the calling function.
  * @param[in] Number of desccriptor to be in the RING or CHAIN
  * @param[in] The Descriptor structure intended. It should only have either RINGMODE or CHAINMODE as valid values
  * \return Returns -1 whenever memory allocation fails. Zero is returned for Success
  */
            
s32 emmc_setup_desc_list(u32 no_of_desc, u32 desc_mode)
{
    s32 i;
    DmaDesc *first_desc = NULL;
    DmaDesc *second_desc = NULL;
    dma_addr_t dma_addr;
    current_task.desc_count = 0;
    
    if(desc_mode == RINGMODE){ //if the mode is RING (Two buffer structure)
	    printf("Total size of memory required for Descriptors in Ring Mode = 0x%08x\n",
                        ((sizeof(DmaDesc) * no_of_desc)));
	current_task.desc_mode        = RINGMODE;
    	first_desc = plat_alloc_consistent_dmaable_memory (current_task.bus_device, sizeof(DmaDesc) * no_of_desc, &dma_addr);
	    if(first_desc == NULL){
	    	printf("Error in Descriptors memory allocation in Ring Mode\n");
		    return -1;
	    }
    	current_task.desc_count       = no_of_desc;
        current_task.desc_head        = first_desc;
    	current_task.desc_head_dma    = dma_addr;
	
	    for(i =0; i < current_task.desc_count; i++){
		    emmc_init_ring_desc(current_task.desc_head + i, i == current_task.desc_count-1);
    		printf("%02d %08x \n",i, (u32)(current_task.desc_head + i) );
	    }
    }
    else{
		printf("Allocating memroy required for descriptors in Chain Mode\n");
        	current_task.desc_mode        = CHAINMODE;
                first_desc = plat_alloc_consistent_dmaable_memory (current_task.bus_device, sizeof(DmaDesc),&dma_addr);
	        if(first_desc == NULL){
	    		printf("Error in Descriptors memory allocation in Chain mode\n");
		    	return -1;
	    }
	current_task.desc_head        = first_desc;
    	current_task.desc_head_dma    = dma_addr;
        current_task.desc_count       = 1;

    	for(i =0; i <(no_of_desc-1); i++){
		    second_desc = plat_alloc_consistent_dmaable_memory(current_task.bus_device, sizeof(DmaDesc),&dma_addr);
    		if(second_desc == NULL){	
	    		printf("Error in Descriptor Memory allocation in Chain mode\n");
		    	return -1;
		    }
    		first_desc->desc3             = dma_addr;
	    	first_desc->desc3_virt        = (u32)second_desc;
		
    		second_desc->desc3            = current_task.desc_head_dma;
	    	second_desc->desc3_virt       = (u32)current_task.desc_head;

	        emmc_init_chain_desc(first_desc);
    		printf("%02d %08x \n",i, (u32)(first_desc + i) );
    		current_task.desc_count += 1;
    		first_desc = second_desc;
	    }   
		    //smart  ly    
	        emmc_init_chain_desc(second_desc);
    }     
		 /* Here we need to update the the current_task with the next,busy,desc_next,desc_busy*/ 
		current_task.desc_next = current_task.desc_busy = current_task.desc_head;
		current_task.next = current_task.busy = 0;
		 
	return 0; 
}

/**
  * This function revert the setting to non IDMA mode of operation after completeing the presetn transfer in IDMA mode.
  * @param[in] The card slot number to which card is connected
  * \return returns void.
  */

void emmc_undo_idma_settings(u32 slot){
		printf(" Restoring INTMSK register content and idma_mode bit is made Zero \n");
		current_task.idma_mode_on = 0;
		emmc_set_register(EMMC_REG_IDINTEN,0x00000000);
		emmc_clear_bits(EMMC_REG_CTRL,CTRL_USE_IDMAC);
		emmc_clear_bits(EMMC_REG_BMOD,BMOD_DE);  
		emmc_set_register(EMMC_REG_INTMSK,emmc_get_slave_intmask_task_status(slot)); //Get back the slave mode iterrupt mask
		return;
	}





#if 0

//////////////////////////// Lock / Unlock ///////////////////////
/**
  * Read Write lock a MMC/SD card.
  * @param[in] slot The slot in which the device is situated.
  * @param[in] password The password to lock with. This has to be a null
  * terminated string. The null termination is not considered a part of the
  * password.
  * \return 0 upon success, the error code upon failure.
  */
u32 emmc_lock(u32 slot, u8 * password)
{
	u32 retval = 0;
	Lock_Struct the_lock_struct;
	u32 resp;


	if ((SD_TYPE != the_card_info[slot].card_type)
	    && (MMC_TYPE != the_card_info[slot].card_type)) {
		return ERRNOTSUPPORTED;
	}


	printf("password = %s %x\n", password, strlen(password));
	if (strlen(password) > (128 / 8)) {
		return ERRNOTSUPPORTED;
	}



	memset((void *) &the_lock_struct, 0, LCK_STRUCT_SIZE);
	strcpy(the_lock_struct.passwd, password);
	the_lock_struct.passwd_length = strlen(password);
	the_lock_struct.lock_cmd_type = LCK_SET_PWD | LCK_LCK;

	emmc_set_register(BLKSIZ, (the_lock_struct.passwd_length + 2));
	if ((retval = emmc_put_in_trans_state(slot))) {
		return retval;
	}

	if ((retval =
	     emmc_send_serial_command(slot, CMD16,
					  (the_lock_struct.
					   passwd_length + 2),
					  &resp, NULL, 0, NULL, NULL))) {
		return retval;
	}

	retval =
	    emmc_read_write_bytes(slot, &resp,
				      (u8 *) & the_lock_struct, 0,
				      the_lock_struct.
				      passwd_length + 2, 0, NULL,
				      NULL,
				      the_lock_struct.
				      passwd_length + 2,
				      CMD42 | CUSTCOM_DONT_CMD16 |
                              	      CUSTCOM_DONT_BLKSIZ | ((the_lock_struct.passwd_length + 2) <<
                                                             CUSTOM_BLKSIZE_SHIFT)
				      , NULL, NULL);



	printf("%s: Returning %x\n", __FUNCTION__, retval);
	return retval;
}





/**
  * Unlock a MMC/SD card.
  * @param[in] slot The slot in which the device is situated.
  * @param[in] password The password to unlock with. This has to be a null
  * terminated string. The null termination is not considered a part of the
  * password.
  * \return 0 upon success, the error code upon failure.
  */
u32 emmc_unlock(u32 slot, u8 * password)
{
	u32 retval = 0;
	Lock_Struct the_lock_struct;
	u32 resp;

	if ((SD_TYPE != the_card_info[slot].card_type)
	    && (MMC_TYPE != the_card_info[slot].card_type)) {
		return ERRNOTSUPPORTED;
	}


	if (strlen(password) > 128 / 8) {
		return ERRNOTSUPPORTED;
	}


	memset((void *) &the_lock_struct, 0, LCK_STRUCT_SIZE);
	strcpy(the_lock_struct.passwd, password);
	the_lock_struct.passwd_length = strlen(password);

	the_lock_struct.lock_cmd_type = LCK_CLR_PWD;


	emmc_set_register(BLKSIZ, (the_lock_struct.passwd_length + 2));
	if ((retval = emmc_put_in_trans_state(slot))) {
		return retval;
	}

	if ((retval =
	     emmc_send_serial_command(slot, CMD16,
					  (the_lock_struct.
					   passwd_length + 2),
					  &resp, NULL, 0, NULL, NULL))) {
		return retval;
	}

	retval =
	    emmc_read_write_bytes(slot, &resp,
				      (u8 *) & the_lock_struct, 0,
				      the_lock_struct.
				      passwd_length + 2, 0, NULL,
				      NULL,
				      the_lock_struct.
				      passwd_length + 2,
				      CMD42 | CUSTCOM_DONT_CMD16 |
                              	      CUSTCOM_DONT_BLKSIZ | ((the_lock_struct.passwd_length + 2) <<
                                                             CUSTOM_BLKSIZE_SHIFT)
				      , NULL, NULL);

	printf("%s: Returning %x\n", __FUNCTION__, retval);
	return retval;
}
#endif


/////////////////////////////kerkel/////////
void plat_set_cmd_over(void)
{
	printf("UNLOCKING --plat_set_cmd_over---\n");
	//up(&mutex_cmd_in_progress);
}

void plat_unmap_single(void * bus_device,dma_addr_t desc2 ,u32 dummy, u32 access_type)
{
	printf("UNLOCKING --plat_unmap_single---\n");
#if 0
   if(access_type == TO_DEVICE)
    pci_unmap_single((struct pci_dev *)(bus_device), desc2, 0,PCI_DMA_TODEVICE );
   if(access_type == FROM_DEVICE)
    pci_unmap_single((struct pci_dev *)(bus_device), desc2, 0,PCI_DMA_FROMDEVICE );
   if(access_type == BIDIRECTIONAL)
    pci_unmap_single((struct pci_dev *)(bus_device), desc2, 0,PCI_DMA_BIDIRECTIONAL);
#endif
}

dma_addr_t plat_map_single(void * bus_device, u8 * data_buffer, u32 len1, u32 access_type)
{
	printf("UNLOCKING --plat_map_single---\n");

   dma_addr_t dma_addr = 0;
#if 0
   if(access_type == TO_DEVICE)
    dma_addr =  pci_map_single((struct pci_dev *)(bus_device), data_buffer, len1,PCI_DMA_TODEVICE );
   if(access_type == FROM_DEVICE)
    dma_addr = pci_map_single((struct pci_dev *)(bus_device), data_buffer, len1,PCI_DMA_FROMDEVICE );
   if(access_type == BIDIRECTIONAL)
    dma_addr = pci_map_single((struct pci_dev *)(bus_device), data_buffer, len1,PCI_DMA_BIDIRECTIONAL);
#endif
   return dma_addr;
}

u32 plat_reenable_upon_interrupt_timeout()
{

u32 retval=1;
int_register i;


  while(1){
	//   	   printf("while value is %d\n",interrupt_already_done);
		    		if(interrupt_already_done)
		    		{	   
		    	        printf(" Enter if is %d\n",interrupt_already_done);
		    			retval=0;	 
		    		    break;
		            }
		            
	          }
	    plat_disable_interrupts(&i);
		interrupt_already_done = 0;
		plat_enable_interrupts(&i);

if (retval){
		return 1;
	    printf("interrupt_already_done is zero:%x\n",interrupt_already_done);
	    }
	else
		return 0;
}

void * plat_alloc_consistent_dmaable_memory (void * bus_device, u32 size, dma_addr_t * addr)
{
	printf("UNLOCKING --plat_alloc_consistent_dmaable_memory---\n");

//     return (pci_alloc_consistent((struct pci_dev *)(bus_device),size,addr));
	return 1;
}



//////////////////////////////////////////////////////////////////

/**
  * Erase the erase group starting from erase_group_start till erase_group_end
  * For MMC4.2 and SD2.0 the erase_group_start and erase_group_end are sector nos
  * where as for MMC4.1 and below cards and SD1.2 and below cards they are byte addresses
  * @param[in] slot The slot in which the device is situated.
  * @param[in] erase_group_start address/sector
  * @param[in] erase_group_end address/sector
  * \return 0 upon success, the error code upon failure.
  */
u32 emmc_erase(u32 slot, u32 erase_group_start, u32 erase_group_end)
{
        u32 retval = 0;
        u32 erase_grp_size = 0;
        u32 erase_grp_mult = 0;
        u32 size_of_erasable_unit = 0;
        u32 wp_grp_size = 0;
        u32 wp_grp_enable = 0;

        u32 erase_blk_en = 0;
        u32 sector_size = 0;
        u32 resp;


        if ((SD_TYPE != the_card_info[slot].card_type) && (MMC_TYPE != the_card_info[slot].card_type) &&
             (SD_MEM_2_0_TYPE != the_card_info[slot].card_type) && (MMC_4_2_TYPE != the_card_info[slot].card_type)) {
                return ERRNOTSUPPORTED;
        }

        if((SD_TYPE == the_card_info[slot].card_type) || (SD_MEM_2_0_TYPE == the_card_info[slot].card_type)){
        /*Put the commands relevant to SD card i.e CMD32 CMD33 CMD38*/
        erase_blk_en = CSD_ERASE_BLK_EN(the_card_info[slot].the_csd);
        sector_size = CSD_SECTOR_SIZE(the_card_info[slot].the_csd);

        printf("ERASE_BLK_EN = %x \n",erase_blk_en);
        printf("SECTOR_SIZE  = %x \n",sector_size);
        size_of_erasable_unit = sector_size + 1;     //ly  when sector_size = 0 means one write block
        printf("size_of_erasable_unit = %x (number of write blocks)\n",size_of_erasable_unit);

        printf("erase_group_start is %x and erase_group_end is %x\n",erase_group_start,erase_group_end);

       /*Put the card in trans state*/
        if ((retval = emmc_put_in_trans_state(slot))) {
                return retval;
        }
        if ((retval =  emmc_send_serial_command(slot, CMD32, erase_group_start, &resp, NULL, 0, NULL, NULL))) {
                return retval;
        }
        printf("Response of CMD32 is %x\n",resp);

        if ((retval =  emmc_send_serial_command(slot, CMD33, erase_group_end, &resp, NULL, 0, NULL, NULL))) {
                return retval;
        }
        printf("Response of CMD36 is %x\n",resp);

        if ((retval =  emmc_send_serial_command(slot, CMD38, 0, &resp, NULL, 0, NULL, NULL))) {
                return retval;
        }
        printf("Response of CMD38 is %x\n",resp);

//        printf("%s: Returning %x\n", __FUNCTION__, retval);
        return retval;

        }

        return retval;
}


/** 
  * Puts the card in the trans state.
  * Puts the specifed to card into the trans state. It first ascertains using
  * CMD13 as to whether the card is in standby. Once ascertianed, the card is 
  * send CMD7* to put into trans state.
  * @param[in] slot The specified card
  * \return Returns 0 upon success. Error status upon error.
  */
u32 emmc_put_in_trans_state(u32 slot)
{
	u32 retval = 0, resp_buffer;
	Card_state the_state;


	if (emmc_read_register(EMMC_REG_CDETECT) & (1 << slot)) {
		return ERRCARDNOTCONN;
	}

//send cmd13 to get the status	
#if 1					
	if ((retval = emmc_get_status_of_card(slot, &the_state))) {
		printf("Getting status of card borked out !\n");
		return retval;
	}

	/* If the card already is 
	   in the trans state, our work 
	   here is done 
	 */
	if (CARD_STATE_TRAN == the_state) {
		the_card_info[slot].card_state = CARD_STATE_TRAN;
		return 0;
	}

	if (CARD_STATE_STBY != the_state) {
		printf("The card state = %x, erroring out\n", the_state);
		return ERRFSMSTATE;
	}
#endif
	the_card_info[slot].card_state = CARD_STATE_STBY;

	printf("CMD13 pass and run CMD7 to change state...");
	/* Now send the command to send to standby state */
	if ((retval =
	     emmc_send_serial_command(slot, CMD7, 0,
	  //  emmc_send_serial_command(slot, CMD7, 0,
					  &resp_buffer, NULL, 0,
					  NULL, NULL))) {

		return retval;
	}

	/* This puts the card into trans */
	the_card_info[slot].card_state = CARD_STATE_TRAN;

	return retval;

}

/**
  * Determines the state in which the card is in.
  * It sends a CMD13 to the card and gets the status out of the R1 response.
  * @param[in] slot The slot for which the status is to be found,
  * @param[out] status The status of the card is populated in this argument.
  * \return Returns 0 on success. Error status upon error.
  */
u32 emmc_get_status_of_card(u32 slot, Card_state * status)
{
	u32 resp_buffer, retval = 0;

	/* Pick up the status from a R1 response */
	if ((retval =
	     emmc_send_serial_command(slot, CMD13, 0,
					  &resp_buffer, NULL, 0,
					  NULL, NULL))) {
		//      if (retval != ERRILLEGALCOMMAND)
		return retval;
	}

	/* We have R1 in the resp buffer , we now check the 
	   status of the card. If it is not in a a standby
	   state we exit. 
	 */
	*status = (Card_state) R1CS_CURRENT_STATE(resp_buffer);
	return 0;
}


/**
 * This function reads multiple blocks on the device for any memory/storage
 * device that might be attached to the host controller. This is the interface
 * any block device driver might use for accessing the devices on the other
 * side of the host controller.
 * @param[in] slot The slot number for the device.
 * @param[in] start_sect The start sector.
 * @param[in] num_of_sects The number of sectors to read.
 * @param[in,out] buffer The data buffer to transfer.
 * @param[in] read_or_write 1 = write operation, 0 = read operation.
 * @param[in] sect_size	The (ln2(sector size) + 1) 
 * \return Returns 0 upon success or error code upon error.
 * \note The size of the buffer should be enough for the requested transfer. 
 *  The caller of the function is responsible for the size.
 */
u32 emmc_read_write_multiple_blocks(u32 slot, u32 start_sect,
					u32 num_of_sects, u8 * buffer,
					u32 read_or_write, u32 sect_size)
{
	u32 retval = 0;
	u32 resp_buff[4];
	u32 read_or_write_to_send;
	u32 sect_size_in_bytes;
	sect_size_in_bytes = 1 << (sect_size - 1); //1<<9

	if (read_or_write) {
		read_or_write_to_send = sect_size_in_bytes * num_of_sects;
	} else {
		read_or_write_to_send = 0;
	}

	if (start_sect + num_of_sects > the_card_info[slot].card_size) {
		retval = ERRADDRESSRANGE;
		goto HOUSEKEEP;
	}
/*
   if((SD_MEM_2_0_TYPE == the_card_info[slot].card_type )|| (SD_MEM_3_0_TYPE == the_card_info[slot].card_type)) {
		retval = emmc_read_write_bytes_SD_2_0(slot,resp_buff,buffer,
					   start_sect,start_sect+num_of_sects,
					   0,NULL,NULL,read_or_write_to_send,
					   sect_size <<CUSTOM_BLKSIZE_SHIFT,NULL,NULL);

	}
	else if ((MMC_4_2_TYPE == the_card_info[slot].card_type) ||(MMC_4_3_TYPE == the_card_info[slot].card_type)||
	retval = emmc_read_write_bytes_MMC_4_2(slot,resp_buff,buffer,
					   start_sect,start_sect+num_of_sects,
					   0,NULL,NULL,read_or_write_to_send,
					   sect_size <<CUSTOM_BLKSIZE_SHIFT,NULL,NULL);
	
	
	else {*/
		retval =  emmc_read_write_bytes(slot, resp_buff, buffer,
					      start_sect * sect_size_in_bytes, //start 
					      start_sect * sect_size_in_bytes + sect_size_in_bytes * num_of_sects, //end
					      0, NULL, NULL,
					      read_or_write_to_send,
					      sect_size << CUSTOM_BLKSIZE_SHIFT, //10<<12=0xa000
					      NULL,
					      NULL);
#if 1
	{
		s32 i = 0;
		printf("read_or_write = %d\n",read_or_write_to_send);
			{
			for(i = 0; i< ((start_sect*sect_size_in_bytes+sect_size_in_bytes*num_of_sects)-(start_sect*sect_size_in_bytes)); i=i+32)
				printf("DATA[%04d . . .] = %08x %08x %08x %08x %08x %08x %08x %08x\n",
					i,*((u32*)(buffer+i)),*((u32*)(buffer+i+4)),*((u32*)(buffer+i+8)),*((u32*)(buffer+i+12)),
					  *((u32*)(buffer+i+16)),*((u32*)(buffer+i+20)),*((u32*)(buffer+i+24)),*((u32*)(buffer+i+28)));
			}
	}
#endif
//	}

      HOUSEKEEP:
	return retval;
}
