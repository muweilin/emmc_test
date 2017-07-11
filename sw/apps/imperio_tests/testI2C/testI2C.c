// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

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
 
    i2c_setup(I2C_PRESCALER, I2C_CTR_EN);

    i2c_send_data(0xA0);// write to EEprom with A0,A1=1 1010 B0 A1 A0 R/Wn

    i2c_send_command(I2C_START_WRITE);
    
    i2c_get_ack();
    
    i2c_send_data(0x00); //addr MSBs
    i2c_send_command(I2C_WRITE);//send data
    i2c_get_ack(); 

   // i2c_send_data(0x00);//addr LSBs
   // i2c_send_command(I2C_WRITE);//send data
   // i2c_get_ack();
    
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

     i2c_send_data(0xA0);// write to EEprom with A0,A1=1 1010 B0 A1 A0 R/Wn
     i2c_send_command(I2C_START_WRITE);//do a start bit and send data

     if(!i2c_get_ack())
     {
        printf("No ack received from EEPROM for readback command\n");
     }
     
     i2c_send_data(0x00); //addr MSBs
     i2c_send_command(I2C_WRITE);

     if(!i2c_get_ack())
     {
         printf("No ack received from EEPROM for readback command\n");
     }

    // i2c_send_data(0x00); //addr LSBs
    // i2c_send_command(I2C_WRITE);
    // 
    // if(!i2c_get_ack())
    // {
    //     printf("No ack received from EEPROM for readback command\n");
    // }

     i2c_send_command(I2C_STOP);
     while(i2c_busy());

     i2c_send_data(0xA1); // write to EEprom with A0,A1=1 1010 B0 A1 A0 R/Wn
     i2c_send_command(I2C_START_WRITE);//do a start bit and send data

     if(!i2c_get_ack())   
     {
        printf("No ack received from EEPROM before sending read\n");
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
                                                                       
