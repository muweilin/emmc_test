
#include "memctl.h"
#include <stdio.h> 

void memctl_init() 
{
  int i;
  int val;
  
  while(1)
  {
    val = *(volatile int*) (MEMCTL_REG_SREFR);
    if(get_gpi(val) & 0x1)  //gpi[0] FstTestComplete
      break;
  }

//*********STMG0R MACROs*********//
  val = set_t_cas_latency(2) | set_t_ras_min(9) | set_t_rcd(2) | \
        set_t_rp(3) | set_t_wr(2) | set_t_rcar(14) | set_t_xsr(23) | set_t_rc(11);

  *(volatile int*) (MEMCTL_REG_STMG0R)   = val;

//*********STMG1R MACROs*********//
  val = set_t_init(3616) | set_num_init_ref(7) | set_t_wtr(1);

  *(volatile int*) (MEMCTL_REG_STMG1R) = val;

//*********SCTLR MACROs*********//
  val = *(volatile int*) (MEMCTL_REG_SCTLR);
  val = val | set_initialize(1);

  *(volatile int*) (MEMCTL_REG_SCTLR)    = val;
  
  for(i = 0; i < 3000; i++) asm volatile("nop");

//*********SCONR MACROs*********//
//  val = *(volatile int*) (MEMCTL_REG_SCONR);
//  printf("Old Bank Addr Width\t: %d\n", get_bank_addr_width(val));
//  printf("Old Row Addr Width\t: %d\n",  get_row_addr_width(val));
//  printf("Old Col Addr Width\t: %d\n",  get_col_addr_width(val));
//  printf("Old Data Width\t: %d\n",      get_data_width(val));

  val = set_bank_addr_width(1) | set_row_addr_width(13) | set_col_addr_width(9) |  set_data_width(1);

  *(volatile int*) (MEMCTL_REG_SCONR)    = val;
  
  for(i = 0; i < 300; i++) asm volatile("nop");

//*********SREFR MACROs*********//
  val = set_t_ref(1040) | set_gpo(1);
  //gpo[0] SampleEn

  *(volatile int*) (MEMCTL_REG_SREFR)  = val;

//wait a little bit
  for(i = 0; i < 100; i++) asm volatile("nop");

}

