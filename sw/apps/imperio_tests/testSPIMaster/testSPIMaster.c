// Copyright 2016 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

#include <stdio.h>
#include "uart.h"
#include "spi.h"

#define CMD_PP        0x02   // page program
#define CMD_RDSR1     0x05   // read status register 1
#define CMD_WREN      0x06   // write enable
#define CMD_P4E       0x20   // parameter 4 KB erase
#define CMD_SE        0xD8   // 
#define CMD_WRAR      0x71   //write to any register
#define CMD_RDCR      0x35   // read configuration register
#define CMD_4READ      0x13   // read with 4 byte address

void waste_time()
{
        for(int i = 0; i < 3; i++)
                asm volatile("nop");
}

int uart_getdata()
{
    int tmp[4];
    int data = 0;
    int i = 0;
    for(i = 0; i < 4; i++)
    {
        tmp[i] = uart_getchar();
        data |= (tmp[i] << (24 - i * 8));
    }
    return data;
}

void send_write_enable()
{
    //send write enable command
    spi_setup_cmd_addr(CMD_WREN, 8, 0, 0);
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);
}

int flash_get_cr1()
{
    int status;
    while((spi_get_status() & 0xFFFF) != 1)
    spi_setup_cmd_addr(CMD_RDCR, 8, 0, 0);
    spi_set_datalen(8);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&status, 8);
    return status;
}

int flash_get_wip()
{
    int status;
    while((spi_get_status() & 0xFFFF) != 1);
    spi_setup_cmd_addr(CMD_RDSR1, 8, 0, 0);
    spi_set_datalen(8);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&status, 8);
    return status & 0x1;
}

void flash_sector_erase_parameter(unsigned int address)
{
    //check if a write/erase is in process wait until it ends
    while(flash_get_wip());

    //send write enable command
   // send_write_enable();
    spi_setup_cmd_addr(CMD_WREN, 8, 0, 0);
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);

    //send page for erase
    spi_setup_cmd_addr(CMD_P4E, 8, (address << 8), 24);
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);
}

void flash_write(unsigned int address, int* buffer, unsigned int size)
{
   
    printf("stagein\n");
    while(flash_get_wip());
     printf("stage0\n");
    spi_setup_cmd_addr(CMD_WREN, 8, 0, 0);
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);
    
    printf("stage1\n");

    spi_setup_cmd_addr(CMD_PP, 8, address << 8, 24);
    spi_set_datalen(size * 32);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    spi_write_fifo(buffer, size * 32);
    while((spi_get_status() & 0xFFFF) != 1);
      printf("stage2\n");
}

void flash_read(unsigned int address, int* buffer, unsigned int size)
{
    while(flash_get_wip());
    while ((spi_get_status() & 0xFFFF) != 1);
    spi_setup_cmd_addr(CMD_4READ, 8, address, 32);
    spi_setup_dummy(0, 0);
    spi_set_datalen(size * 32);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(buffer, size * 32);
}

int main()
{
    printf("spi flash program\n");
  
    //read flash ID
    spi_setup_master(1);
    *(volatile int*)(SPI_REG_CLKDIV) = 0x4;
    int id = 0;

    spi_setup_cmd_addr(0x9F, 8, 0, 0);
    spi_set_datalen(32);
    spi_setup_dummy(0, 0);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&id, 32);

    printf("flash id is:%x\n", id);
  
    //send_write_enable();
    spi_setup_cmd_addr(CMD_WREN, 8, 0, 0);
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);
  
    //check flash parameter sectors
    int cr1 = flash_get_cr1();
    if((cr1 & (1 << 2)) != 0)
    {
        printf("error \n");
        return 0;
    }

    //send_write_enable();
    spi_setup_cmd_addr(CMD_WREN, 8, 0, 0);
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);
    
    //set page size : 512 byte per page
    spi_setup_cmd_addr(CMD_WRAR, 8, (0x800004 << 8) | 0x10, 32);
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);

    unsigned int flash_addr = 0;
    int buffer[5];
    int read_buffer[5];
 
    buffer[0] = 0x12345678;
    buffer[1] = 0x66666666;

    flash_sector_erase_parameter(flash_addr);
    printf("flash erase done\n");
 
    flash_write(flash_addr, buffer, 2);
    printf("flash write done\n");
  
    flash_read(flash_addr, read_buffer, 2);
    for( int i = 0; i < 2; i++)
    printf ("Content of flash memory is: %X\n", read_buffer[i]);

    return 0;
}  










