//this code is used to check final elf files
//2016/10/27 
//Lei
//when using fpga simulation, malloc failed. Not clear why yet
#include <malloc.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include "memctl.h"
//#define COPY_SIZE 303 // The is the maximux size can be allocated 
#define COPY_SIZE 10 // The is the maximux size can be allocated 
#define ext_ram_addr 0x22000000

int main()
{
  int i;
  memctl_init();
//  int * p;

//  if ( (p = (int *) malloc(sizeof(int)*COPY_SIZE)) == NULL){ 
//      printf("Allocation p(%d) Failed. Exit\n", COPY_SIZE);
//      while(1);
//  }

  //int * q;
  //if ( (q = (int *) malloc(sizeof(int)*COPY_SIZE)) == NULL){ 
  //    printf("Allocation q(%d) Failed. Exit\n", COPY_SIZE);
  //    while(1);
  //}

  int * q = (volatile int*)ext_ram_addr;

//  printf("%x\n", *(volatile unsigned int*)ext_ram_addr);
  //  int * q = (int *) ext_ram_addr;

//  printf("0x%x\n", (int)p);
  printf("0x%x\n", (int)q);

  for(i = 0; i < COPY_SIZE; i++)
     *(q+i) =  0xdeadbeef;
  
//  for(i = 0; i < 32*1024; i++)
//     printf("%x\n", *(p+i));

  // memset(q, 'a', 40);
//  memcpy(q, p, 4*COPY_SIZE);
 
  for(i = 0; i < COPY_SIZE; i++)
     printf("%4d: %x\n", i, *(q+i));


//  while(1);

//  free(p);
  return 0;
}
