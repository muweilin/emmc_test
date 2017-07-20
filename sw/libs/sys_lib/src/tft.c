/*
This TFT driver lib is used for ILI9481 Control IC, other device may be vary. 
Author:pengfei zhai
*/

#include <stdio.h>
#include "uart.h"
#include "spi.h"
#include "tft.h"

#define CMD_PP        0x02   // page program
#define CMD_RDSR1     0x05   // read status register 1
#define CMD_WREN      0x06   // write enable
#define CMD_P4E       0x20   // parameter 4 KB erase
#define CMD_SE        0xD8   // 
#define CMD_WRAR      0x71   //write to any register
#define CMD_RDCR      0x35   // read configuration register
#define CMD_4READ      0x13   // read with 4 byte address

void tft_spi_init()
{
    *(volatile int*)(SPI_REG_CLKDIV) = 0x4;   
}

void tft_init()
{
    int id = 0;
    tft_spi_init();
    spi_setup_cmd_addr(0XBF, 8, 0, 0);
    spi_set_datalen(32);
    spi_setup_dummy(32, 0);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&id, 32);
   // id = spi_get_status();
    printf("SPI_statu: %d\n,id");
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);
    spi_setup_cmd_addr(0, 0, 0, 0);
    spi_set_datalen(32);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&id, 32);
    printf("TFT driver ID: %d\n,id");
}


