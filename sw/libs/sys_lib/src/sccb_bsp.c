#include<stdio.h>
#include<i2c.h>
#include<utils.h>
#include<gpio.h>
//#include<bench.h>
#include<uart.h>
#include<sccb_bsp.h>

#define I2C_PRESCALER 0x63 //(soc_freq/(5*i2cfreq))-1 with i2cfreq = 100Khz

void SCCB_init()
{
   printf("i2c init for SCCB.\n");
   i2c_setup(I2C_PRESCALER, I2C_CTR_EN);
}

uint8_t SCCB_WriteByte(uint8_t WriteAddress, uint8_t SendByte)
{
   i2c_send_data(0x42);  //write ID R/Wn = 0
   i2c_send_command(I2C_START_WRITE);
   i2c_get_ack();  //can don't care
    
   i2c_send_data(WriteAddress);
   i2c_send_command(I2C_WRITE);
   i2c_get_ack();

   i2c_send_data(SendByte);
   i2c_send_command(I2C_WRITE);
   i2c_get_ack();

   i2c_send_command(I2C_STOP);
   while(i2c_busy());
   
   return 1;
}

uint8_t SCCB_ReadByte(uint8_t ReadAddress)
{
   int ver;
   i2c_send_data(0x42);  //write ID R/Wn = 0
   i2c_send_command(I2C_START_WRITE);
   i2c_get_ack();  //can don't care
    
   i2c_send_data(ReadAddress);
   i2c_send_command(I2C_WRITE);
   i2c_get_ack();

   i2c_send_command(I2C_STOP);
   while(i2c_busy());

   i2c_send_data(0x43);  //write ID R/Wn = 1
   i2c_send_command(I2C_START_WRITE);
   i2c_get_ack();  //can don't care

   i2c_send_command(I2C_READ);
   i2c_get_ack();
   ver = i2c_get_data();
   i2c_send_command(I2C_STOP_READ);
   //i2c_get_ack();
   return ver;
}



   
