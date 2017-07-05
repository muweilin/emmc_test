
#include "utils.h"
#include "string_lib.h"
#include "bar.h"
#include "gpio.h"
#include "spi.h"

int main()
{
  int i;

  set_pin_function(PIN2, FUNC_GPIO); //gpio0
  set_pin_function(PIN3, FUNC_GPIO); //gpio1
  set_pin_function(PIN4, FUNC_GPIO); //gpio2
  set_pin_function(PIN5, FUNC_GPIO); //gpio3
  set_pin_function(PIN6, FUNC_GPIO); //gpio4
  set_pin_function(PIN7, FUNC_GPIO); //gpio5
/*
  set_gpio_pin_direction(PIN2, DIR_OUT);//gpio0
  set_gpio_pin_direction(PIN3, DIR_OUT);//gpio1
  set_gpio_pin_direction(PIN4, DIR_OUT);//gpio2
  set_gpio_pin_direction(PIN5, DIR_OUT);//gpio3
  set_gpio_pin_direction(PIN6, DIR_OUT);//gpio4
  set_gpio_pin_direction(PIN7, DIR_OUT);//gpio5

  printf("Successfully set GPIO OUTPUT\n");

  for (int i = 0; i < 100; i++)
       asm volatile ("nop");

  set_gpio_pin_value(PIN2, 1);  
  set_gpio_pin_value(PIN3, 0);  
  set_gpio_pin_value(PIN4, 1);
  set_gpio_pin_value(PIN5, 0);
  set_gpio_pin_value(PIN6, 1);
  set_gpio_pin_value(PIN7, 0);

  for (int i = 0; i < 1000; i++)
       asm volatile ("nop");
  
  set_gpio_pin_value(PIN2, 0);  
  set_gpio_pin_value(PIN3, 1);  
  set_gpio_pin_value(PIN4, 0);
  set_gpio_pin_value(PIN5, 1);
  set_gpio_pin_value(PIN6, 0);
  set_gpio_pin_value(PIN7, 1);

*/
  set_gpio_pin_direction(PIN2, DIR_IN);//gpio0
  set_gpio_pin_direction(PIN3, DIR_IN);//gpio1
  set_gpio_pin_direction(PIN4, DIR_IN);//gpio2
  set_gpio_pin_direction(PIN5, DIR_IN);//gpio3
  set_gpio_pin_direction(PIN6, DIR_IN);//gpio4
  set_gpio_pin_direction(PIN7, DIR_IN);//gpio5

  printf("Successfully set GPIO INPUT\n");

  for(int i = 0; i < 20; i++)
    printf("%d, %d, %d, %d, %d, %d\n", get_gpio_pin_value(PIN2), get_gpio_pin_value(PIN3), get_gpio_pin_value(PIN4), get_gpio_pin_value(PIN5), get_gpio_pin_value(PIN6), get_gpio_pin_value(PIN7));   

  printf("Done!!!\n");

  return 0;
}
