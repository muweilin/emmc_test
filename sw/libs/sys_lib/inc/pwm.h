
#ifndef __PWM_H__
#define __PWM_H__

#include "ppu.h"

#define PWM0_LOAD         0x00
#define PWM0_CMP          0x04
#define PWM0_CTRL         0x08
#define PWM0_TIMER        0x0C

#define PWM1_LOAD         0x10
#define PWM1_CMP          0x14
#define PWM1_CTRL         0x18
#define PWM1_TIMER        0x1C

#define PWM2_LOAD         0x20
#define PWM2_CMP          0x24
#define PWM2_CTRL         0x28
#define PWM2_TIMER        0x2C

#define PWM3_LOAD         0x30
#define PWM3_CMP          0x34
#define PWM3_CTRL         0x38
#define PWM3_TIMER        0x3C

/* pointer to PWM */
#define __PPWM__(a) *(volatile int*) (PWM_BASE_ADDR + a)

#define PPWM0_LOAD  __PPWM__(PWM0_LOAD)
#define PPWM0_CMP   __PPWM__(PWM0_CMP)
#define PPWM0_CTRL  __PPWM__(PWM0_CTRL)
#define PPWM0_TIMER __PPWM__(PWM0_TIMER)

#define PPWM1_LOAD  __PPWM__(PWM1_LOAD)
#define PPWM1_CMP   __PPWM__(PWM1_CMP)
#define PPWM1_CTRL  __PPWM__(PWM1_CTRL)
#define PPWM1_TIMER __PPWM__(PWM1_TIMER)

#define PPWM2_LOAD  __PPWM__(PWM2_LOAD)
#define PPWM2_CMP   __PPWM__(PWM2_CMP)
#define PPWM2_CTRL  __PPWM__(PWM2_CTRL)
#define PPWM2_TIMER __PPWM__(PWM2_TIMER)

#define PPWM3_LOAD  __PPWM__(PWM3_LOAD)
#define PPWM3_CMP   __PPWM__(PWM3_CMP)
#define PPWM3_CTRL  __PPWM__(PWM3_CTRL)
#define PPWM3_TIMER __PPWM__(PWM3_TIMER)

void open_pwm_pin(int pwm_ch);//set PIN mode

void set_pwm_channel(int pwm_ch, int full, int duty);

void set_channel_prescaler(int pwm_ch, int prescaler);

void start_pwm_channel(int pwm_ch);

void stop_pwm_channel(int pwm_ch);
#endif
