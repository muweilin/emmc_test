#include "pwm.h"
#include "gpio.h"
#include "uart.h"
#include "utils.h"


void set_pwm_channel(int pwm_ch, int full, int duty)
{
   switch( pwm_ch )
   {
     case 0: PPWM0_LOAD = full; PPWM0_CMP = duty; break;
     case 1: PPWM1_LOAD = full; PPWM1_CMP = duty; break;
     case 2: PPWM2_LOAD = full; PPWM2_CMP = duty; break;
     case 3: PPWM3_LOAD = full; PPWM3_CMP = duty; break;
     default: 
             uart_send("PWM Channel ID Err!!!\n", 22);
             exit(1);
   }  
}

void set_channel_prescaler(int pwm_ch, int prescaler)
{

   switch( pwm_ch )
   {
     case 0: PPWM0_CTRL = (PPWM0_CTRL & ~(0x7 << 3)) | (prescaler & 0x7) << 3; break;
     case 1: PPWM1_CTRL = (PPWM1_CTRL & ~(0x7 << 3)) | (prescaler & 0x7) << 3; break;
     case 2: PPWM2_CTRL = (PPWM2_CTRL & ~(0x7 << 3)) | (prescaler & 0x7) << 3; break;
     case 3: PPWM3_CTRL = (PPWM3_CTRL & ~(0x7 << 3)) | (prescaler & 0x7) << 3; break;
     default: 
             uart_send("PWM Channel ID Err!!!\n", 22);
             exit(1);
   }  

}

void start_pwm_channel(int pwm_ch)
{
   switch( pwm_ch )
   {
     case 0: PPWM0_TIMER = 0; PPWM0_CTRL = PPWM0_CTRL | 0x1; break;
     case 1: PPWM1_TIMER = 0; PPWM1_CTRL = PPWM1_CTRL | 0x1; break;
     case 2: PPWM2_TIMER = 0; PPWM2_CTRL = PPWM2_CTRL | 0x1; break;
     case 3: PPWM3_TIMER = 0; PPWM3_CTRL = PPWM3_CTRL | 0x1; break;
     default: 
             uart_send("PWM Channel ID Err!!!\n", 22);
             exit(1);
   } 
}

void stop_pwm_channel(int pwm_ch)
{
   switch( pwm_ch )
   {
     case 0: PPWM0_CTRL = PPWM0_CTRL & ~0x1; break;
     case 1: PPWM1_CTRL = PPWM1_CTRL & ~0x1; break;
     case 2: PPWM2_CTRL = PPWM2_CTRL & ~0x1; break;
     case 3: PPWM3_CTRL = PPWM3_CTRL & ~0x1; break;
     default: 
             uart_send("PWM Channel ID Err!!!\n", 22);
             exit(1);
   } 
}
