//2016/11/29 
//Lei

#include <stdio.h>
//#include "memctl.h"
#include "camctl.h"
#include "int.h"
#include "event.h"
#include "gpio.h"
#include "uart.h"
#include "sccb_bsp.h"
#include "oled.h"
#include "bmp.h"
#include "camctl.h"
#include<i2c.h>

#define IMAGE_WIDTH	 320 
#define IMAGE_HEIGHT     240
#define IMAGE_LENGTH  IMAGE_WIDTH *IMAGE_HEIGHT
int send_img(volatile unsigned int* pix, int len);
volatile int Isr_Type;

int main()
{
  int i;
  int ver;
  Lcd_Init();
  printf("LCD inited\n");
  
  
 // LCD_Clear(0x07E0);
//  LCD_Clear(0xF800);
 /// LCD_Clear(0x001F);
   display_image((volatile unsigned short*)sy);
  
printf("LCD clear\n");
  
  SCCB_init();
  SCCB_WriteByte(0x12, 0x80);
  SCCB_WriteByte(0x11, 0x01); //2/ pre-scale
  SCCB_WriteByte(0x0d, 0x00); //PLL 0x
  SCCB_WriteByte(0x12, 0x46); //QVGA
  //SCCB_WriteByte(0x66, 0x20); //QVGA



  do{
        i2c_send_data(0x42); 
        i2c_send_command(I2C_START_WRITE);
    }while(!i2c_get_ack());
      
   i2c_send_command(I2C_STOP);
   while(i2c_busy());
  ver = SCCB_ReadByte(0x0d);
  printf("SCCB receive: %x\n", ver);
 ver = SCCB_ReadByte(0x11);
  printf("SCCB receive: %x\n", ver);
  ver = SCCB_ReadByte(0x12);
  printf("SCCB receive: %x\n", ver);

  Isr_Type = 0;
  camctl_init();
  printf("Camera init done!!!\n");

  int_enable();
  IER |= (1<< INT_CAM);	//enable camera interrupt
  EER |= (1<< INT_CAM);	//enable camera interrupt
  printf("INT_CAM init done!!!\n");

  camctl_start();

  while(1){
     if(Isr_Type != 0)
	{
	   printf("Get in ISR, Service Type: %d\n", Isr_Type);
           if(Isr_Type == 1) {
                display_image((volatile unsigned char*)FRAME1_ADDR);
		//send_img((volatile unsigned char*)FRAME1_ADDR, IMAGE_LENGTH*2);
		}
	   else if(Isr_Type == 2){
               display_image((volatile unsigned char*)FRAME2_ADDR);
		//send_img((volatile unsigned char*)FRAME2_ADDR, IMAGE_LENGTH*2);
		}
	   else if(Isr_Type == 3){
               display_image((volatile unsigned char*)FRAME3_ADDR);
		//send_img((volatile unsigned char*)FRAME3_ADDR, IMAGE_LENGTH*2);
		}
          Isr_Type = 0;
          camctl_int_enable(SET_FM1_INT, SET_FM2_INT, SET_FM3_INT, UNSET_RQFUL_INT, UNSET_RQOVF_INT, SET_PROERR_INT);
          printf("Status reg1:%d\n", *(volatile int*) (CAMCTL_STATUS));
          camctl_start();	//open the camera
	}
  }
  return 0;
}

void ISR_CAM(void)
{
  int val;
  
  //uart_send("Enter ISP\n", 10);
  //uart_wait_tx_done();

  camctl_stop();	//close the camera
  ICP = (1 << INT_CAM);
  //IER &= ~(1<< INT_CAM);
 // camctl_int_disable(UNSET_FM1_INT, UNSET_FM2_INT, UNSET_FM3_INT, UNSET_RQFUL_INT, UNSET_RQOVF_INT, UNSET_PROERR_INT);

  val = *(volatile int*) (CAMCTL_STATUS);

  if(DATAOK_FRAME1(val) == 1) {
    Isr_Type = 1;
    val = CLR_FRAME1_INT(val);
  }

  if(DATAOK_FRAME2(val) == 1) {
    Isr_Type = 2;
    val = CLR_FRAME2_INT(val);
  }

  if(DATAOK_FRAME3(val) == 1) {
    Isr_Type = 3;
    val = CLR_FRAME3_INT(val);
  }

  if(RQ_FUL(val) == 1) {
    Isr_Type = 4;
    val = CLR_RQFUL_INT(val);
  }

  if(RQ_OVF(val) == 1) {
    Isr_Type = 5;
    val = CLR_RQOVF_INT(val);
  }

  if(PROTOCAL_ERR0(val) == 1) {
    Isr_Type = 6;
    val = CLR_PROERR0_INT(val);
  }

  if(PROTOCAL_ERR1(val) == 1) {
    Isr_Type = 7;
    val = CLR_PROERR1_INT(val);
  }
  printf("val:%d\n", val);
  *(volatile int*) (CAMCTL_STATUS) = val;
  printf("Status reg:%d\n", *(volatile int*) (CAMCTL_STATUS));
  //camctl_int_enable(SET_FM1_INT, SET_FM2_INT, SET_FM3_INT, UNSET_RQFUL_INT, UNSET_RQOVF_INT, SET_PROERR_INT);

}
int send_img(volatile unsigned int* pix, int len)
{

  int i, j;
  int ht;  
  int ht_ver;  
  unsigned int tmp;
  unsigned int httmp;
  char ch[3];

  for(i = 0; i < IMAGE_HEIGHT; i++)
  {
    for(ht=0; ht< (IMAGE_WIDTH*2)/4; ht++)
    {
        httmp = *(pix+(i*IMAGE_WIDTH*2)/4+ht); //0 ~ 255
        for(ht_ver=0;ht_ver<4;ht_ver++)
        {
           tmp = httmp&(0xff<<(8*ht_ver));
           tmp = tmp>>((8*ht_ver)); 
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
  }
 uart_sendchar('\n');
 uart_wait_tx_done();
  uart_sendchar(' ');
          uart_wait_tx_done();
  //waste_time();
  }

  uart_sendchar('\n');
  uart_wait_tx_done();
  uart_sendchar('\n');
  uart_wait_tx_done();

  return 0;
}


