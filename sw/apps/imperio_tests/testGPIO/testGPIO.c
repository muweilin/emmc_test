#include "utils.h"
#include "string_lib.h"
#include "bar.h"
#include "gpio.h"
#include "spi.h"
void waste_time() {
  int i;
  for(i = 0; i < 3000000; i++) asm volatile("nop");
//  for(i = 0; i < 300; i++) asm volatile("nop");
}
int main()
{
  int i;
  int dir=0;
  int delay = 30000;

 
 for(i=4;i<8;i++)
 {
     set_gpio_pin_direction(i, 1);
     
     dir = get_gpio_pin_direction(i) ;
     
     printf("gpio %d direction is %d\n",i,dir);
     
     set_gpio_pin_value(i, 0);
     printf("gpio %d v is %d\n",i,0);
     waste_time();
     
     set_gpio_pin_value(i, 1);
     printf("gpio %d v is %d\n",i,1);
     delay = 0xFFFFFFFF;
    waste_time() ;
     set_gpio_pin_value(i, 0);
      printf("gpio %d v is %d\n",i,0);
   //get_gpio_pin_value(i);
 }

  printf("Done!!!\n");

  return 0;
}  
