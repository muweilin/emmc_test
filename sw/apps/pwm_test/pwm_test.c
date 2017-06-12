//2016/11/29 
//Lei

#include <stdio.h>
#include "pwm.h"

int main()
{
  int i;

  set_pwm_channel(0, 2048, 100);
  set_pwm_channel(1, 2048, 100);
  set_pwm_channel(2, 2048, 100);
  set_pwm_channel(3, 2048, 100);

  set_channel_prescaler(0, 0);
  set_channel_prescaler(1, 1);
  set_channel_prescaler(2, 2);
  set_channel_prescaler(3, 3);

  printf("PWM setup done!!!\n");

  open_pwm_pin(0);
  open_pwm_pin(1);
  open_pwm_pin(2);
  open_pwm_pin(3);

  printf("Pin mux opened!!!\n");

  printf("Start PWM......\n");
  start_pwm_channel(0);
  start_pwm_channel(1);
  start_pwm_channel(2);
  start_pwm_channel(3);


  for(i = 0; i < 6000; i++) asm volatile("nop");
  set_pwm_channel(0, 2048, 200);

  for(i = 0; i < 6000; i++) asm volatile("nop");
  set_pwm_channel(0, 2048, 300);
  
  return 0;
}
