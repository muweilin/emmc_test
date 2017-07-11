#include "camctl.h"
#include "event.h"
#include <stdio.h>
#include "uart.h"


void camctl_int_enable(unsigned int fm1_int, unsigned int fm2_int, unsigned int fm3_int, unsigned int rqful_int, unsigned int rqovf_int, unsigned int err_int)
{
  int val = 0;

  if(fm1_int !=0)
    val = SET_FRAME1_INT_EN(val);

  if(fm2_int !=0)
    val = SET_FRAME2_INT_EN(val);

  if(fm3_int !=0)
    val = SET_FRAME3_INT_EN(val);

  if(rqful_int !=0)
    val = SET_RQFUL_INT_EN(val);

  if(rqovf_int !=0)
    val = SET_RQOVF_INT_EN(val);

  if(err_int !=0)
    val = SET_PROERR_INT_EN(val);

   *(volatile int*) (CAMCTL_INT_ENABLE) = val;
}

void camctl_int_disable(unsigned int fm1_int, unsigned int fm2_int, unsigned int fm3_int, unsigned int rqful_int, unsigned int rqovf_int, unsigned int err_int)
{
  int val;
  val = *(volatile int*) (CAMCTL_INT_ENABLE);

  if(fm1_int == UNSET_FM1_INT)
    val = UNSET_FRAME1_INT_EN(val);

  if(fm2_int == UNSET_FM2_INT)
    val = UNSET_FRAME2_INT_EN(val);

  if(fm3_int == UNSET_FM3_INT)
    val = UNSET_FRAME3_INT_EN(val);

  if(rqful_int == UNSET_RQFUL_INT)
    val = UNSET_RQFUL_INT_EN(val);

  if(rqovf_int == UNSET_RQOVF_INT)
    val = UNSET_RQOVF_INT_EN(val);

  if(err_int == UNSET_PROERR_INT)
    val = UNSET_PROERR_INT_EN(val);

  *(volatile int*) (CAMCTL_INT_ENABLE) = val;
}

void camctl_init()
{
  *(volatile int*) (CAMCTL_FRAME1_ADDR)   = FRAME1_ADDR;
  *(volatile int*) (CAMCTL_FRAME2_ADDR)   = FRAME2_ADDR;
  *(volatile int*) (CAMCTL_FRAME3_ADDR)   = FRAME3_ADDR;
  
  camctl_int_enable(SET_FM1_INT, SET_FM2_INT, SET_FM3_INT, UNSET_RQFUL_INT, UNSET_RQOVF_INT, SET_PROERR_INT);

}


void camctl_start()
{
  int val;
   
  val = *(volatile int*) (CAMCTL_CTRL_REG);

  val = ENABLE_CAPTURE(val);

  *(volatile int*) (CAMCTL_CTRL_REG) = val;
}


void camctl_stop()
{
  int val;

  camctl_int_disable(UNSET_FM1_INT, UNSET_FM2_INT, UNSET_FM3_INT, UNSET_RQFUL_INT, UNSET_RQOVF_INT, UNSET_PROERR_INT);
   
  val = *(volatile int*) (CAMCTL_CTRL_REG);

  val = DISABLE_CAPTURE(val);

  *(volatile int*) (CAMCTL_CTRL_REG) = val;
  
}

