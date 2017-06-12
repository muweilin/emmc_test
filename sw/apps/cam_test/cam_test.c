//2016/11/29 
//Lei

#include <stdio.h>
#include "memctl.h"
#include "camctl.h"
#include "int.h"
#include "event.h"
#include "gpio.h"
#include "uart.h"

#define IMAGE_WIDTH	 4 
#define IMAGE_HEIGHT     4
#define IMAGE_LENGTH  IMAGE_WIDTH *IMAGE_HEIGHT

int main()
{
  int i;
  
  set_pin_function(PIN4, FUNC_CAM);
  set_pin_function(PIN5, FUNC_CAM);
  set_pin_function(PIN6, FUNC_CAM);
  set_pin_function(PIN7, FUNC_CAM);
  set_pin_function(PIN8, FUNC_CAM);
  set_pin_function(PIN9, FUNC_CAM);
  set_pin_function(PIN10, FUNC_CAM);
  set_pin_function(PIN11, FUNC_CAM);
  set_pin_function(PIN12, FUNC_CAM);
  set_pin_function(PIN13, FUNC_CAM);

//  memctl_init();
//  printf("DRAM init done!!!\n");

  int_enable();
  IER |= (1<< INT_CAM);	//enable camera interrupt
  EER |= (1<< INT_CAM);	//enable camera interrupt
  printf("Enable global interrupt done!!!\n");

  camctl_init();
  printf("Camera init done!!!\n");
  camctl_start();

/*  for(i = 0; i < 50000; i = i+1) asm volatile("nop");

  int_disable();
  camctl_stop();
  printf("Camera stooooop!!!\n");
*/
  while(1){ asm volatile ("nop;nop");}

  return 0;
}


int send_img(volatile unsigned char* pix, int len)
{

  int i, j;
  unsigned int tmp;
  char ch[3];

  for(i = 0; i < len; i++)
  {
    tmp = *(pix+i); //0 ~ 255
 
    for(j = 0; j < 3; j++)
    {
      ch[j] = tmp % 10 + 48;
      tmp = tmp/10;
    }
   
    for(j = 2; j >= 0; j--){
      uart_sendchar(ch[j]);
      uart_wait_tx_done();
    }

    uart_sendchar(' ');
    uart_wait_tx_done();
  }

  uart_sendchar('\n');
  uart_wait_tx_done();
  uart_sendchar('\n');
  uart_wait_tx_done();

  return 0;
}

void ISR_CAM(void)
{
  int val;
  
  uart_send("Enter ISP\n", 10);
  uart_wait_tx_done();

  camctl_stop();	//close the camera

  ICP = (1 << INT_CAM);
   
  val = *(volatile int*) (CAMCTL_STATUS);

  if(DATAOK_FRAME1(val) == 1) {
    uart_send("Frame 1 in DRAM OK!!!\n", 22);
    uart_wait_tx_done();

    send_img((volatile unsigned char*)FRAME1_ADDR, IMAGE_LENGTH*2);
    val = CLR_FRAME1_INT(val);
  }

  if(DATAOK_FRAME2(val) == 1) {
//    printf("Frame 2 in DRAM OK!!!\n");
    val = CLR_FRAME2_INT(val);
  }

  if(DATAOK_FRAME3(val) == 1) {
//    printf("Frame 3 in DRAM OK!!!\n");
    val = CLR_FRAME3_INT(val);
  }

  if(RQ_FUL(val) == 1) {
//    printf("RQ Full!!!\n");
    val = CLR_RQFUL_INT(val);
  }

  if(RQ_OVF(val) == 1) {
//    printf("RQ Overflow!!!\n");
    val = CLR_RQOVF_INT(val);
  }

  if(PROTOCAL_ERR0(val) == 1) {
//    printf("No Framebuffer Available!!!\n");
    val = CLR_PROERR0_INT(val);
  }

  if(PROTOCAL_ERR1(val) == 1) {
//    printf("New Frame but RQ not Empry!!!\n");
    val = CLR_PROERR1_INT(val);
  }

  *(volatile int*) (CAMCTL_STATUS) = val;

  camctl_int_enable(SET_FM1_INT, SET_FM2_INT, SET_FM3_INT, UNSET_RQFUL_INT, UNSET_RQOVF_INT, SET_PROERR_INT);
  
  camctl_start();	//open the camera

}


