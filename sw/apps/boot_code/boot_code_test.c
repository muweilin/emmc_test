#include <uart.h>
#include <utils.h>
#include <ppu.h>

void jump_and_start(volatile int *ptr);

#define COPY_SIZE 10 // The is the maximux size can be allocated 
#define ext_ram_addr 0x40000000


void waste_time() {
  int i;
  for(i = 0; i < 3; i++) asm volatile("nop");
//  for(i = 0; i < 300; i++) asm volatile("nop");
}

int main()
{
  int i,j;
  char ch;
  int dat = 0xaaaa1111;
  int tmp = 0xbbbb0000;

  uart_set_cfg(0, 49);//Lei

//  uart_send("Booting PPU...\n", 15);
//  uart_send("B\n", 2);

//  uart_send("Jumping to User App\n", 20);
  uart_send("J\n", 2);

  uart_wait_tx_done();

  int * q = (volatile int*)ext_ram_addr;

  for(i = 0; i < COPY_SIZE; i++)
  {
     *(q+i) =  dat;
     dat = dat + 0x11111111;
  }

  for(i = 0; i < COPY_SIZE; i++)
   {
    tmp = *(q+i);
    for(j = 0; j < 8; j++){
      ch = (tmp >> (28-j*4)) & 0xF;
      if(ch < 0xa )
        ch = ch + 48;
      else
        ch = ch + 87;
      uart_sendchar(ch);
    }
    uart_sendchar('\n');

    waste_time();
    uart_wait_tx_done();
   }

 for (i = 0; i < 5; i++) 
     asm volatile ("nop");

  BOOTREG = INSTR_RAM_BASE_ADDR;

  jump_and_start((volatile int *)(INSTR_RAM_START_ADDR));
}

void jump_and_start(volatile int *ptr)
{
  asm("jalr x0, %0\n"
      "nop\n"
      "nop\n"
      "nop\n"
      : : "r" (ptr) );
}


