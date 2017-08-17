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
#define CMD_WREN      0x06   // write enable
#define CMD_P4E       0x20   // parameter 4 KB erase
#define CMD_SE        0xD8   // sector erase
#define CMD_BE        0x60   // bulk erase
#define CMD_WRAR      0x71   // write to any register
#define CMD_RDAR      0x65   // read any register
#define CMD_4READ     0x13   // read with 4 byte address

#define CMD_RDSR1     0x05   // read status register 1
#define CMD_PDSR2     0x07   // read status register 2
#define CMD_RDCR      0x35   // read configuration register

void jump_and_start(volatile int *ptr);

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
    while((spi_get_status() & 0xFFFF) != 1);
    spi_setup_cmd_addr(CMD_RDCR, 8, 0, 0);
    spi_setup_dummy(0, 0);
    spi_set_datalen(16);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    //while((spi_get_status() & 0xFFFF) != 1);
    //printf("just waste time~~~~~~~~~~~~~~");
    spi_read_fifo(&status, 16);
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
    spi_setup_dummy(0, 0);
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

void flash_bulk_erase()
{
    //check if a write/erase is in process wait until it ends
   spi_setup_dummy(0, 0);
   while(flash_get_wip());

    //send write enable command
   // send_write_enable();
    spi_setup_cmd_addr(CMD_WREN, 8, 0, 0);
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);

    //send page for erase
    spi_setup_cmd_addr(CMD_BE, 8, 0, 0);
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

    spi_setup_cmd_addr(CMD_PP, 8, address, 32);
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
    //spi_setup_dummy(0, 0);
    //int id = 0;

    int id = 0;
    spi_setup_cmd_addr(0x9F, 8, 0, 0);
    spi_set_datalen(32);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&id, 32);
    printf("flash id is:%x\n", id);
    if ((id != 0x0120184D) && (id != 0x0102194D)) {
        uart_send("ERROR: Spansion SPI flash not found\n", 36);
        while (1);
    }

    uart_send("Loading image from SPI flash\n", 29);
    uart_wait_tx_done();
    //send_write_enable();
    
    int ver;

    while((spi_get_status() & 0xFFFF) != 1);             //SR1V reg bit[1] is the write enable control, should be 0
    spi_setup_cmd_addr(CMD_RDSR1, 8, 0, 0);
    spi_set_datalen(8);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&ver, 8);
    printf("rdsr1: %x \n", ver);

    spi_setup_cmd_addr(CMD_WREN, 8, 0, 0);               //write enable
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);
    printf("CMD_WREN \n");
    
    while((spi_get_status() & 0xFFFF) != 1);             //SR1V reg bit[1] should be 1
    spi_setup_cmd_addr(CMD_RDSR1, 8, 0, 0);
    spi_set_datalen(8);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&ver, 8);
    printf("rdsr1: %x \n", ver);

    spi_setup_cmd_addr(CMD_RDAR, 8, 0x800003, 24);      //RDAR CMD had a dummy of 8, if reset, CR2 should be 0x08, so read latency is 8 
    spi_setup_dummy(8, 0);
    spi_set_datalen(8);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&ver, 8);
    printf("CR2: %x \n", ver);

    spi_setup_cmd_addr(0xB7, 8, 0, 0);                  //all write CMD don't have dummy cycles, B7 is set 32 bit addr
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);
     printf("enter 32bit addr \n");

    spi_setup_cmd_addr(CMD_RDAR, 8, 0x800003, 32);      //bit[7] is 1, all addr become 32
    spi_setup_dummy(8, 0);
    spi_set_datalen(8);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&ver, 8);
    printf("CR2: %x \n", ver);


    spi_setup_cmd_addr(CMD_WREN, 8, 0, 0);              //write enable should add every write operate
    spi_set_datalen(0);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    while((spi_get_status() & 0xFFFF) != 1);
    printf("CMD_WREN \n");

    while((spi_get_status() & 0xFFFF) != 1);            //conferm write enable
    spi_setup_cmd_addr(CMD_RDSR1, 8, 0, 0);
    spi_set_datalen(8);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&ver, 8);
    printf("rdsr1: %x \n", ver);

    int temp[2];
    temp[0] = 0x10000000;
    //while(flash_get_wip());
    spi_setup_cmd_addr(CMD_WRAR, 8, 0x800004, 32);     //may because big_LITTLE endian, the most significant bit is sent first, attention all addr is 32bit
    spi_set_datalen(8);
    spi_write_fifo(temp, 8);
    spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
    printf("wrap at 512kb \n");

    spi_setup_cmd_addr(CMD_RDAR, 8, 0x800004, 32);     //now its wrap at 512 byte
    spi_setup_dummy(8, 0);
    spi_set_datalen(8);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(&ver, 8);
    printf("CR3: %x \n", ver);

    //------------------------------------------
    //uart receive
    //------------------------------------------
    unsigned int flash_addr = 0;
    int* data_r = (int *) 0x53000000;
    int read_check[512];
    int* read_buffer;
    unsigned int i = 0;
    int header[5];
	    

    printf("please input program.\n");
    int addr;
    addr = uart_getdata();
    int instr_ptr_t = addr;
    int addr_last = addr - 4;
    int data_ptr_t = 0;
    int instr_ptr_b = 0;
    while(addr != 0xffffffff)
    {
      *data_r = uart_getdata();
      data_r++;
      
      if(addr - addr_last != 0x04)
      {
          data_ptr_t = addr;
          instr_ptr_b = addr_last;
      }

      addr_last = addr;
      addr = uart_getdata();
    }
    
    int data_ptr_b = addr_last;
    int instr_size_r = (instr_ptr_b - instr_ptr_t) / 4 + 1;
    int data_size_r = (data_ptr_b - data_ptr_t) / 4 + 1;
  
    header[0] = 0x1000;         //program in flash location
    header[1] = instr_ptr_t;    //instruction load addr
    header[2] = instr_size_r;
    header[3] = data_ptr_t;     //data load addr
    header[4] = data_size_r;
    
    /*
    for(int i=0; i < 20000; i++)
       data_r[i] = i;

    header[0] = 0x1000;         //program in flash location
    header[1] = 0x5000000;    //instruction load addr
    header[2] = 10000;
    header[3] = 0x5100000;     //data load addr
    header[4] = 10000;
   */
    int total_size_r = header[2] + header[4];
    printf("program receive finish.\n");
    printf("instr_start:%x\n", header[0]);
    printf("instr:%x\n", header[1]);
    printf("instr_size:%x\n", header[2]);
    printf("data:%x\n", header[3]);
    printf("data_size:%x\n", header[4]);
    
    flash_bulk_erase();
    while(flash_get_wip());
    printf("flash erase done\n");
     
    flash_write(0, header, 5);
    data_r = (int *) 0x53000000;
    int page_num = total_size_r / 128;
    int remaind_num = total_size_r % 128;
    flash_addr = header[0];
    for(int i = 0; i < page_num ; i++)
    {
       flash_write(flash_addr, data_r, 128);
       flash_read(flash_addr, read_check, 128);
       for(int j = 0; j < 128; j++)
       { 
          printf("data_addr:%x, flash_addr:%x, data:%x \n",data_r, flash_addr, read_check[j] );
		if(*(data_r + j) != read_check[j])
         {
           printf("write check error..At:%x \n", (int)(data_r + j));
           printf("Write Data:%x Read Data:%x \n", *(data_r + j),  read_check[j]);
           return 0;
 		 }
	   }
	   data_r += 128;
       flash_addr += 512;
    }
    flash_write(flash_addr, data_r, remaind_num);
    flash_read(flash_addr, read_check, remaind_num);
       for(int j = 0; j < remaind_num; j++)
       { 
        printf("data_addr:%x, flash_addr:%x, data:%x \n",data_r, flash_addr, read_check[j] );
		if(*(data_r + j) != read_check[j])
        {
           printf("write check error..At:%x \n", (int)(data_r + j));
           printf("Write Data:%x Read Data:%x \n", *(data_r + j),  read_check[j]);
           return 0;
         }
	   }
    printf("Data is write proper! \n");
  //-----------------------------------------------------------
  // Read header
  //-----------------------------------------------------------
    int header_ptr[5];
    spi_setup_cmd_addr(0x13, 8, 0x00, 32);
    spi_set_datalen(5 * 32);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(header_ptr, 5 * 32);

    int instr_start = header_ptr[0];
    int *instr = (int *) 0x53100000;
    int instr_size =  header_ptr[2];
    int *data = (int *)  0x53200000;
    int data_size = header_ptr[4];
    
    printf("instr_start:%x\n", instr_start);
    printf("instr:%x\n", instr);
    printf("instr_size:%x\n", instr_size);
    printf("data:%x\n", data);
    printf("data_size:%x\n", data_size);

    if (instr_size == 0xFFFFFFFF)
    {
        uart_send("ERROR: There is no program in your flash\n", 41);
        while (1);
    } 
  //-----------------------------------------------------------
  // Read Instruction RAM
  //-----------------------------------------------------------

    uart_send("Loading code ...\n", 17);
    uart_wait_tx_done();

    addr = instr_start;
    int block_num = instr_size / 1024;
    int num = instr_size % 1024;
    for (int i = 0; i < block_num; i++)  //reads 4KB blocks
    {
        spi_setup_cmd_addr(0x13, 8, addr, 32);
        spi_set_datalen(1024 * 32);
        spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
        spi_read_fifo(instr, 1024 * 32);
        
//		flash_read(addr, instr, 1024);
        //for(int w = 0;w < 1024; w++)
       // {
       //    printf("%x \n",*instr)
       // }
        instr += 0x400;  // new address = old address + 1024 words
        addr  += 0x1000; // new address = old address + 4KB
    }
    spi_setup_cmd_addr(0x13, 8, addr, 32);
    spi_set_datalen(num * 32);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(instr, num * 32);

//      flash_read(addr, instr, num);
    while ((spi_get_status() & 0xFFFF) != 1);
  //-----------------------------------------------------------
  // Read Data RAM
  //-----------------------------------------------------------

    uart_send("Loading data ...\n", 17);
    uart_wait_tx_done();

    addr += num * 4;
    block_num = data_size / 1024;
    num = data_size % 1024;
    for (int i = 0; i < block_num; i++) 
    { 
        spi_setup_cmd_addr(0x13, 8, addr, 32);
        spi_set_datalen(1024 * 32);
        spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
        spi_read_fifo(data, 1024 * 32);

//        flash_read(addr, data, 1024);

        data += 0x400;  // new address = old address + 1024 words
        addr += 0x1000; // new address = old address + 4KB
    }
    spi_setup_cmd_addr(0x13, 8, addr, 32);
    spi_set_datalen(num * 32);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(data, num * 32);

//    flash_read(addr, data, num);
    printf("Simulation read finish ...\n");
    printf("Valid data ...\n");

   instr = (int *)  0x53100000;
   data_r = (int *) 0x53000000;
   for( int v = 0; v < instr_size; v++)
    {
     if(*data_r!=*instr){
        printf ("data_addr:%x, data:%x, flash_addr:%x, flash_data:%d\n", data_r, *data_r, instr, *instr);
        return 0;
      }
      data_r++;
      instr++;
    }
  printf ("data_r:%x \n", data_r);
   data = (int *) 0x53200000;
   for( int v = 0; v < data_size; v++)
    {
     if(*data_r!=*data){
        printf ("data_addr:%x, data:%x, flash_addr:%x, flash_data:%d\n", data_r, *data_r, data, *data);
        return 0;
      }
      data_r++;
      data++;
    }
   printf ("Two check pass!!!");
   return 0;
}  

void jump_and_start(volatile int *ptr)
{
  asm("jalr x0, %0\n"
      "nop\n"
      "nop\n"
      "nop\n"
      : : "r" (ptr) );
}









