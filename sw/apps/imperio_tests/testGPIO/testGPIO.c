// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

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
  set_pin_function(PIN9,  FUNC_GPIO); //gpio2
  set_pin_function(PIN10, FUNC_GPIO); //gpio3
  set_pin_function(PIN11, FUNC_GPIO); //gpio4
  set_pin_function(PIN12, FUNC_GPIO); //gpio5
  set_pin_function(PIN13, FUNC_GPIO); //gpio6

/*
  set_gpio_pin_direction(PIN2, DIR_IN);
  set_gpio_pin_direction(PIN3, DIR_IN);
  set_gpio_pin_direction(PIN9, DIR_IN);
  set_gpio_pin_direction(PIN10, DIR_IN);
  set_gpio_pin_direction(PIN11, DIR_IN);
  set_gpio_pin_direction(PIN12, DIR_IN);
  set_gpio_pin_direction(PIN13, DIR_IN);

  printf("Successfully set GPIO INPUT\n");

  printf("Get GPIO input values: \n");

  for(i = 0; i < 20; i=i+1) {
   printf("%d\t %d\t %d\t %d\t %d\t %d\t %d;\n", get_gpio_pin_value(PIN2),  get_gpio_pin_value(PIN3),  get_gpio_pin_value(PIN9),  get_gpio_pin_value(PIN10),  get_gpio_pin_value(PIN11),  get_gpio_pin_value(PIN12),  get_gpio_pin_value(PIN13));
  }

*/
  set_gpio_pin_direction(PIN2, DIR_OUT);//gpio0
  set_gpio_pin_direction(PIN3, DIR_OUT);//gpio1
  set_gpio_pin_direction(PIN9, DIR_OUT);//gpio2
  set_gpio_pin_direction(PIN10, DIR_OUT);//gpio3
  set_gpio_pin_direction(PIN11, DIR_OUT);//gpio4
  set_gpio_pin_direction(PIN12, DIR_OUT);//gpio5
  set_gpio_pin_direction(PIN13, DIR_OUT);//gpio6


  printf("Successfully set GPIO OUTPUT\n");

  for (int i = 0; i < 100; i++)
       asm volatile ("nop");

  set_gpio_pin_value(PIN2, 0);  
  set_gpio_pin_value(PIN3, 1);
  set_gpio_pin_value(PIN9, 0);
  set_gpio_pin_value(PIN10, 1);
  set_gpio_pin_value(PIN11, 0);
  set_gpio_pin_value(PIN12, 1);
  set_gpio_pin_value(PIN13, 0);


  for (int i = 0; i < 2000; i++)
       asm volatile ("nop");
  
  set_gpio_pin_value(PIN2, 1);  
  set_gpio_pin_value(PIN3, 0);
  set_gpio_pin_value(PIN9, 1);
  set_gpio_pin_value(PIN10, 0);
  set_gpio_pin_value(PIN11, 1);
  set_gpio_pin_value(PIN12, 0);
  set_gpio_pin_value(PIN13, 1);


  printf("Done!!!\n");

  return 0;
}
