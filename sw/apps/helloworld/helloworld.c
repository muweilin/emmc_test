#include<stdio.h>
#include<i2c.h>
#include<utils.h>
#include<gpio.h>
#include<bench.h>
#include<uart.h>

#define I2C_PRESCALER 0x63 //(soc_freq/(5*i2cfreq))-1 with i2cfreq = 100Khz
int main()
{
    printf("i2c read and wirte\n");
    
    set_pin_function(PIN3, FUNC_GPIO);
    set_gpio_pin_direction(PIN3, DIR_OUT);    
    set_gpio_pin_value(PIN3, 1);

    set_pin_function(PIN0, FUNC_I2C);

    printf("set pin function\n");
    set_pin_function(PIN1, FUNC_I2C);

    i2c_setup(I2C_PRESCALER, I2C_CTR_EN);

    i2c_send_data(0xA0);

    i2c_send_command(I2C_START_WRITE);
    
    i2c_get_ack();
    
    //8 bit address - 24AA02E48
    i2c_send_data(0x00);
    i2c_send_command(I2C_WRITE);
    i2c_get_ack();
    
    for(int i = 0; i < 16; i ++)
    {
        i2c_send_data(i);
        i2c_send_command(I2C_WRITE);
        i2c_get_ack();
    }

    i2c_send_command(I2C_STOP);
    while(i2c_busy());
    
    do{
        i2c_send_data(0xA0);
        i2c_send_command(I2C_START_WRITE);
    }while(!i2c_get_ack());

    i2c_send_command(I2C_STOP);
    while(i2c_busy());

//-------------------
// read back
//-------------------

     i2c_send_data(0xA0);
     i2c_send_command(I2C_START_WRITE);

     if(!i2c_get_ack())
     {
         printf("error\n");
     }
     
     i2c_send_data(0x00);
     i2c_send_command(I2C_WRITE);

     if(!i2c_get_ack())
     {
         printf("error\n");
     }
        
     i2c_send_command(I2C_STOP);
     while(i2c_busy());

     i2c_send_data(0xA1);
     i2c_send_command(I2C_START_WRITE);

     if(!i2c_get_ack())   
     {
         printf("error read\n");
     }
  
     int value = 0;
     for(int i = 0; i < 16; i ++)
     {
         if ( i == 15)
             i2c_send_command(I2C_STOP_READ);
         else
             i2c_send_command(I2C_READ);
     
         if(!i2c_get_ack())   
         {
             printf("error read\n");
         }

         value = i2c_get_data();
         printf("receive %d exception %d \n", value, i);

         if(value != i)
         {
             printf("meet error \n");
         }
     }
     return 0;
}
