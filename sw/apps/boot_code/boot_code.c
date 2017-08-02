#include <uart.h>
#include <utils.h>
#include <spi.h>
#include <ppu.h>
#include <stdio.h>

#define COPY_SIZE 5 // The is the maximux size can be allocated 
#define ext_ram_addr 0x50000000

void waste_time() {
  int i;
  for(i = 0; i < 3000000; i++) asm volatile("nop");
//  for(i = 0; i < 300; i++) asm volatile("nop");
}

void jump_and_start(volatile int *ptr);

int uart_getdata(){
  int mid[4];
  int data = 0;
  for(int i = 0; i < 4; i++)
  {
    mid[i] = uart_getchar();
    data |= (mid[i] << (24 - i*8));
  }
  return data;
}

int main()
{
  int i, j;
  int tmp;
  char ch;
  int dat = 0x0;
  int q;
  uart_set_cfg(0, 49); //100M: 125000
   // divide sys clock by 4 
  *(volatile int*) (SPI_REG_CLKDIV) = 0x4;

  uart_send("Starting WuPu1.0 CORE ......\n", 29);
  uart_send("                 UU\n", 20);                                                      
  uart_send("            UUUUUUUUUUUU      UUUUUUUUUU    UUUUU  UUUUU\n", 57);
  uart_send("           UUU   UU   UUU       U      UU    U        U\n", 56);
  uart_send("          UUU    UU    UUU      U      U     U        U\n", 56);
  uart_send("          UU     UU     UU      UUUUUU       U        U\n", 56);
  uart_send("          UU     UU    UUU      U       IOT  U        U\n", 56);
  uart_send("           UUUUU UU UUUU        U     AI     U        U\n", 56);
  uart_send("              UUUUUUUU          U            UU      UU\n", 56);
  uart_send("                UUU    RISC-V   U      Chip   UU    UU\n", 55);
  uart_send("               UUUUU          UUUUUUU          UUUUUU\n\n\n", 56);
  uart_wait_tx_done();
 
  spi_setup_cmd_addr(0x9F, 8, 0, 0);
  spi_setup_dummy(0, 0);
  spi_set_datalen(32);
  spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
  spi_read_fifo(&q, 32);
    
  if ((q != 0x0120184D) && (q != 0x0102194D)) {
        uart_send("ERROR: Spansion SPI flash not found\n", 36);
        while (1);
    }

  //-----------------------------------------------------------
  // Read header
  //-----------------------------------------------------------
    int header_ptr[5];
    spi_setup_cmd_addr(0x13, 8, 0x00, 32);
    spi_set_datalen(5 * 32);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(header_ptr, 5 * 32);

    int instr_start = header_ptr[0];
    int *instr = (int *) header_ptr[1];
    int instr_size =  header_ptr[2];
    int *data = (int *) header_ptr[3];
    int data_size = header_ptr[4];
    
    if (instr_size == 0xFFFFFFFF)
    {
        uart_send("ERROR: There is no program in your flash\n", 41);
        while (1);
    } 
    
    uart_send("Loading image from SPI flash\n", 29);
    uart_wait_tx_done();
  //-----------------------------------------------------------
  // Read Instruction RAM
  //-----------------------------------------------------------

    uart_send("Loading code ...\n", 17);
    uart_wait_tx_done();

    int addr = instr_start;
    int block_num = instr_size / 1024;
    int num = instr_size % 1024;
    for (int i = 0; i < block_num; i++)  //reads 4KB blocks
    {
        spi_setup_cmd_addr(0x13, 8, addr, 32);
        spi_set_datalen(1024 * 32);
        spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
        spi_read_fifo(instr, 1024 * 32);
        
        instr += 0x400;  // new address = old address + 1024 words
        addr  += 0x1000; // new address = old address + 4KB
    }
    spi_setup_cmd_addr(0x13, 8, addr, 32);
    spi_set_datalen(num * 32);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(instr, num * 32);

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

        data += 0x400;  // new address = old address + 1024 words
        addr += 0x1000; // new address = old address + 4KB
    }
    spi_setup_cmd_addr(0x13, 8, addr, 32);
    spi_set_datalen(num * 32);
    spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    spi_read_fifo(data, num * 32);

    uart_send("Jumping to user image ...\n", 26);
    uart_wait_tx_done();
  //-----------------------------------------------------------
  // Set new boot address -> exceptions/interrupts/events rely
  // on that information
  //-----------------------------------------------------------

    BOOTREG = 0x00;

  //-----------------------------------------------------------
  // Done jump to main program
  //-----------------------------------------------------------

  //jump to program start address (instruction base address)
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
