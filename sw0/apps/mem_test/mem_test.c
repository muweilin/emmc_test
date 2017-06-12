//this code is used to check final elf files
//2016/10/27 
//Lei
//when using fpga simulation, malloc failed. Not clear why yet
#include <malloc.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

//#define COPY_SIZE 303 // The is the maximux size can be allocated 
#define COPY_SIZE 10 // The is the maximux size can be allocated 

int main()
{
  int i;

  int * p;

  if ( (p = (int *) malloc(sizeof(int)*COPY_SIZE)) == NULL){ 
      printf("Allocation p(%d) Failed. Exit\n", COPY_SIZE);
      while(1);
  }

  int * q;
  if ( (q = (int *) malloc(sizeof(int)*COPY_SIZE)) == NULL){ 
      printf("Allocation q(%d) Failed. Exit\n", COPY_SIZE);
      while(1);
  }



  printf("0x%x\n", (int)p);
  printf("0x%x\n", (int)q);

  for(i = 0; i < COPY_SIZE; i++)
     *(q+i) =  0xdeadbeef;
  

  memcpy(p, q, 4*COPY_SIZE);
 
  for(i = 0; i < COPY_SIZE; i++)
     printf("%4d: %x\n", i, *(p+i));


//  while(1);

  free(p);
  return 0;
}
