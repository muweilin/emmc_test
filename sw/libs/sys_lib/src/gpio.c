// Copyright 2016 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

#include <gpio.h>
#include <utils.h>
#include <uart.h>

int  get_pin_function(int pinnumber) {
  volatile int old_function;
  volatile int regno;
  volatile int index;

  switch( pinnumber )
  {
    case 0:
    case 1:
    case 2:
    case 3: 
        regno = IOMUX_FUNC_CFG0; 
        index = pinnumber;
        break;
    case 4:
    case 5:
    case 6:
    case 7:
        regno = IOMUX_FUNC_CFG1; 
        index = pinnumber - 4; 
        break;
    case 8:
    case 9:
    case 10:
    case 11:
        regno = IOMUX_FUNC_CFG2; 
        index = pinnumber - 8; 
        break;
    case 12:
    case 13:
        regno = IOMUX_FUNC_CFG3; 
        index = pinnumber - 12; 
        break;
    default: 
//        printf("Unknow PIN number!!!\n");
          uart_send("Unknow PIN number!!!\n", 21);
        exit(1);
  }

  index = index * 8;
  old_function = *(volatile int*) (regno);
  old_function = old_function & (1 << index) ;
  old_function = (old_function >> index) & 0x1;

/*
  printf("PIN %d: ", pinnumber);

  if(old_function == 0)
 {
  switch( pinnumber )
  {
    case 0:  printf("scl\n"); break;
    case 1:  printf("sda\n"); break;
    case 2:  printf("spi_master1_sdo0\n"); break;
    case 3:  printf("spi_master1_csn0\n"); break;
    case 4:  printf("spi_master1_sdi0\n"); break;
    case 5:  printf("pwm0\n"); break;
    case 6:  printf("pwm1\n"); break;
    case 7:  printf("pwm2\n"); break;
    case 8:  printf("pwm3\n"); break;
    case 9:  printf("gpio2\n"); break;
    case 10: printf("gpio3\n"); break;
    case 11: printf("gpio4\n"); break;
    case 12: printf("gpio5\n"); break;
    case 13: printf("gpio6\n"); break;
    default: 
        printf("Unknow PIN number!!!\n");
        exit(1);
  }
 }
  else
 {
  switch( pinnumber )
  {
    case 0:  printf("uart1tx\n"); break;
    case 1:  printf("uart1rx\n"); break;
    case 2:  printf("gpio0\n"); break;
    case 3:  printf("gpio1\n"); break;
    case 4:  printf("cam_vsync\n"); break;
    case 5:  printf("cam_href\n"); break;
    case 6:  printf("cam_data7\n"); break;
    case 7:  printf("cam_data6\n"); break;
    case 8:  printf("cam_data5\n"); break;
    case 9:  printf("cam_data4\n"); break;
    case 10: printf("cam_data3\n"); break;
    case 11: printf("cam_data2\n"); break;
    case 12: printf("cam_data1\n"); break;
    case 13: printf("cam_data0\n"); break;
    default: 
        printf("Unknow PIN number!!!\n");
        exit(1);
  }
 }
*/
  return old_function;
}

void set_pin_function(int pinnumber, int func) {
  volatile int old_function;
  volatile int mode;
  volatile int regno;
  volatile int index;

  switch( pinnumber )
  {
    case 0:
        if(func == FUNC_I2C) mode = 0;
        else if(func == FUNC_UART) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber); 
               uart_send("Mode Err!!!\n", 12);
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG0; 
        index = pinnumber;
        break;
    case 1:
        if(func == FUNC_I2C) mode = 0;
        else if(func == FUNC_UART) mode = 1;
        else {
//             printf("PIN%d Mode Err\n", pinnumber); 
               uart_send("Mode Err!!!\n", 12);
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG0; 
        index = pinnumber;
        break;
    case 2:
        if(func == FUNC_SPI) mode = 0;
        else if(func == FUNC_GPIO) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber); 
               uart_send("Mode Err!!!\n", 12);
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG0; 
        index = pinnumber;
        break;
    case 3:
        if(func == FUNC_SPI) mode = 0;
        else if(func == FUNC_GPIO) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber); 
               uart_send("Mode Err!!!\n", 12);
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG0; 
        index = pinnumber;
        break;
    case 4:
        if(func == FUNC_SPI) mode = 0;
        else if(func == FUNC_CAM) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber);
               uart_send("Mode Err!!!\n", 12);
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG1; 
        index = pinnumber - 4;
        break;
    case 5:
        if(func == FUNC_PWM) mode = 0;
        else if(func == FUNC_CAM) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber);
                uart_send("Mode Err!!!\n", 12); 
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG1; 
        index = pinnumber - 4;
        break;
    case 6:
        if(func == FUNC_PWM) mode = 0;
        else if(func == FUNC_CAM) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber);
               uart_send("Mode Err!!!\n", 12);
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG1; 
        index = pinnumber - 4;
        break;
    case 7:
        if(func == FUNC_PWM) mode = 0;
        else if(func == FUNC_CAM) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber);
               uart_send("Mode Err!!!\n", 12); 
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG1; 
        index = pinnumber - 4; 
        break;
    case 8:
        if(func == FUNC_PWM) mode = 0;
        else if(func == FUNC_CAM) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber);
               uart_send("Mode Err!!!\n", 12);
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG2; 
        index = pinnumber - 8; 
        break;
    case 9:
        if(func == FUNC_GPIO) mode = 0;
        else if(func == FUNC_CAM) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber);
               uart_send("Mode Err!!!\n", 12); 
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG2; 
        index = pinnumber - 8; 
        break;
    case 10:
        if(func == FUNC_GPIO) mode = 0;
        else if(func == FUNC_CAM) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber); 
               uart_send("Mode Err!!!\n", 12);
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG2; 
        index = pinnumber - 8; 
        break;
    case 11:
        if(func == FUNC_GPIO) mode = 0;
        else if(func == FUNC_CAM) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber); 
               uart_send("Mode Err!!!\n", 12);
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG2; 
        index = pinnumber - 8; 
        break;
    case 12:
        if(func == FUNC_GPIO) mode = 0;
        else if(func == FUNC_CAM) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber);
               uart_send("Mode Err!!!\n", 12); 
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG3; 
        index = pinnumber - 12; 
        break;
    case 13:
        if(func == FUNC_GPIO) mode = 0;
        else if(func == FUNC_CAM) mode = 1;
        else {
//              printf("PIN%d Mode Err\n", pinnumber);
               uart_send("Mode Err!!!\n", 12); 
              exit(1); 
             }
        regno = IOMUX_FUNC_CFG3; 
        index = pinnumber - 12; 
        break;
    default: 
//        printf("Unknow PIN number!!!\n");
          uart_send("Unknow PIN number!!!\n", 21);
        exit(1);
  }
  
  index = index * 8;
  old_function = *(volatile int*) (regno);

  old_function = old_function & (~(1 << index)); //clear bit
  old_function = old_function | (mode << index);

  *(volatile int*) (regno) = old_function;
}

int muxpin2gpiopin (int pinnumber) {
  volatile int gpio_pin;

  switch( pinnumber )
  {
    case 2:  gpio_pin = 0; break;
    case 3:  gpio_pin = 1; break;
    case 9:  gpio_pin = 2; break;
    case 10: gpio_pin = 3; break;
    case 11: gpio_pin = 4; break;
    case 12: gpio_pin = 5; break;
    case 13: gpio_pin = 6; break;
    default: 
//        printf("Not a GPIO PIN!!!\n");
          uart_send("Not a GPIO PIN!!!\n", 18);
          exit(1);
  }

  return gpio_pin;

}

void set_gpio_pin_direction(int pinnumber, int direction) {
  volatile int old_dir;
  volatile int gpio_pin;

  gpio_pin = muxpin2gpiopin(pinnumber);

  old_dir = *(volatile int*) (GPIO_REG_PADDIR);
  if (direction == DIR_IN)
    old_dir &= ~(1 << gpio_pin);
  else
    old_dir |= 1 << gpio_pin;

  *(volatile int*) (GPIO_REG_PADDIR) = old_dir;

}

int  get_gpio_pin_direction(int pinnumber) {
  volatile int old_dir;
  volatile int gpio_pin;

  gpio_pin = muxpin2gpiopin(pinnumber);

  old_dir = *(volatile int*) (GPIO_REG_PADDIR);
  old_dir = (old_dir >> (gpio_pin) & 0x01);

  return old_dir;
}

void set_gpio_pin_value(int pinnumber, int value) {
  volatile int v;
  volatile int gpio_pin;

  gpio_pin = muxpin2gpiopin(pinnumber);

  v = *(volatile int*) (GPIO_REG_PADOUT);
  if (value == 0)
    v &= ~(1 << gpio_pin);
  else
    v |= 1 << gpio_pin;
  *(volatile int*) (GPIO_REG_PADOUT) = v;
}

int  get_gpio_pin_value(int pinnumber) {
  volatile int v;
  volatile int gpio_pin;

  gpio_pin = muxpin2gpiopin(pinnumber);

  v = *(volatile int*) (GPIO_REG_PADIN);
  v = (v >> gpio_pin) & 0x01;
  return v;
}

void set_gpio_pin_irq_en(int pinnumber, int enable) {
  int v;
  volatile int gpio_pin;

  gpio_pin = muxpin2gpiopin(pinnumber);

  v = *(volatile int*) (GPIO_REG_INTEN);
  if (enable == 0)
    v &= ~(1 << gpio_pin);
  else
    v |= 1 << gpio_pin;
  *(volatile int*) (GPIO_REG_INTEN) = v;
}

void set_gpio_pin_irq_type(int pinnumber, int type) {
  int type0;
  int type1;
  volatile int gpio_pin;

  gpio_pin = muxpin2gpiopin(pinnumber);

  type0 = *(volatile int*) (GPIO_REG_INTTYPE0);
  type1 = *(volatile int*) (GPIO_REG_INTTYPE1);

  if ((type & 0x1) == 0)
    type0 &= ~(1 << gpio_pin);
  else
    type0 |= 1 << gpio_pin;

  if ((type & 0x2) == 0)
    type1 &= ~(1 << gpio_pin);
  else
    type1 |= 1 << gpio_pin;

  *(volatile int*) (GPIO_REG_INTTYPE0) = type0;
  *(volatile int*) (GPIO_REG_INTTYPE1) = type1;
}

int get_gpio_irq_status() {
  return *(volatile int*) (GPIO_REG_INTSTATUS);
}
