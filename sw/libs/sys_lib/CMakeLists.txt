set(SOURCES
    src/exceptions.c
    src/gpio.c
    src/pwm.c
    src/int.c
    src/spi.c
    src/timer.c
    src/uart.c
    src/utils.c
    src/i2c.c
    src/ann.c
    src/camctl.c
    src/sccb_bsp.c
    src/oled.c
    src/emmc.c
    src/emmc_callback.c
    )

set(HEADERS
    inc/bar.h
    inc/gpio.h
    inc/pwm.h
    inc/int.h
    inc/ppu.h
    inc/spi.h
    inc/spr-defs.h
    inc/timer.h
    inc/uart.h
    inc/utils.h
    inc/i2c.h
    inc/ann.h
    inc/camctl.h
    inc/sccb_bsp.h
    inc/oled.h
    inc/bmp.h 
    inc/oledfont.h
    inc/emmc.h
    inc/emmc_callback.h
    )

include_directories(inc/)
include_directories(../string_lib/inc)

add_library(sys STATIC ${SOURCES} ${HEADERS})
