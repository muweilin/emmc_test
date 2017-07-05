/**
 *
 * GPIO lib
 * lei@ict
 *
 */

#ifndef _GPIO_H_
#define _GPIO_H_

#include <ppu.h>

#define PIN0      0
#define PIN1      1
#define PIN2      2
#define PIN3      3
#define PIN4      4
#define PIN5      5
#define PIN6      6
#define PIN7      7
#define PIN8      8
#define PIN9      9
#define PIN10     10
#define PIN11     11
#define PIN12     12
#define PIN13     13

#define FUNC_GPIO   1
#define FUNC_UART   2
#define FUNC_I2C    3
#define FUNC_SPI    4
#define FUNC_CAM    5
#define FUNC_PWM    6

#define DIR_IN  0
#define DIR_OUT 1

#define GPIO_REG_PADDIR               ( GPIO_BASE_ADDR + 0x00 )
#define GPIO_REG_PADIN                ( GPIO_BASE_ADDR + 0x04 )
#define GPIO_REG_PADOUT               ( GPIO_BASE_ADDR + 0x08 )
#define GPIO_REG_INTEN                ( GPIO_BASE_ADDR + 0x0C )
#define GPIO_REG_INTTYPE0             ( GPIO_BASE_ADDR + 0x10 )
#define GPIO_REG_INTTYPE1             ( GPIO_BASE_ADDR + 0x14 )
#define GPIO_REG_INTSTATUS            ( GPIO_BASE_ADDR + 0x18 )

#define IOMUX_FUNC_CFG0               ( SOC_CTRL_BASE_ADDR + 0x20 )
#define IOMUX_FUNC_CFG1               ( SOC_CTRL_BASE_ADDR + 0x24 )
#define IOMUX_FUNC_CFG2               ( SOC_CTRL_BASE_ADDR + 0x28 )
#define IOMUX_FUNC_CFG3               ( SOC_CTRL_BASE_ADDR + 0x2C )
//#define IOMUX_FUNC_CFG4               ( SOC_CTRL_BASE_ADDR + 0x30 )
//#define IOMUX_FUNC_CFG5               ( SOC_CTRL_BASE_ADDR + 0x34 )

#define PADDIR 				REGP(GPIO_REG_PADDIR)
#define PADIN 				REGP(GPIO_REG_PADIN)
#define PADOUT 				REGP(GPIO_REG_PADOUT)
#define INTEN 				REGP(GPIO_REG_INTEN)
#define INTTYPE0 			REGP(GPIO_REG_INTTYPE0)
#define INTTYPE1 			REGP(GPIO_REG_INTTYPE1)
#define INTSTATUS 			REGP(GPIO_REG_INTSTATUS)

#define IOCFG0 			    REGP(IOMUX_FUNC_CFG0)
#define IOCFG1 			    REGP(IOMUX_FUNC_CFG1)
#define IOCFG2 			    REGP(IOMUX_FUNC_CFG2)
#define IOCFG3 			    REGP(IOMUX_FUNC_CFG3)
//#define IOCFG4 			    REGP(IOMUX_FUNC_CFG4)
//#define IOCFG5 			    REGP(IOMUX_FUNC_CFG5)

#define GPIO_IRQ_FALL  0x3
#define GPIO_IRQ_RISE  0x2
#define GPIO_IRQ_LEV0  0x0
#define GPIO_IRQ_LEV1  0x1

void set_pin_function(int pinnumber, int function);
int  get_pin_function(int pinnumber);

int muxpin2gpiopin (int pinnumber);

void set_gpio_pin_direction(int pinnumber, int direction);
int  get_gpio_pin_direction(int pinnumber);

void set_gpio_pin_value(int pinnumber, int value);
int  get_gpio_pin_value(int pinnumber);

void set_gpio_pin_irq_type(int pinnumber, int type);
void set_gpio_pin_irq_en(int pinnumber, int enable);
int get_gpio_irq_status();

#endif // _GPIO_H_
