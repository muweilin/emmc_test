
#ifndef _MEMCTL_H
#define _MEMCTL_H

#include "ppu.h"

#define LPDDR_REGION_0            0x20010000
#define LPDDR_REGION_1            0x22000000
#define LPDDR_REGION_2            0x24000000
#define LPDDR_REGION_3            0x26000000

//*********STMG0R MACROs*********//
#define set_t_cas_latency(x)  (x & 0x3)
//0-3: 1-4 clocks, 
//dft: CAS_LATENCY-1

#define set_t_ras_min(x)      ((x << 2) & 0x3C)
//0-15: 1-16 clocks
//dft: T_RAS_MIN-1

#define set_t_rcd(x)          ((x << 6) & 0x1C0)
//0-7: 1-8 clocks
//dft: T_RCD-1

#define set_t_rp(x)           ((x << 9) & 0xE00)
//0-7: 1-8 clocks
//dft: T_RP-1

#define set_t_wr(x)           ((x << 12) & 0x3000)
//0-3: 1-4 clocks
//dft: T_WR-1

#define set_t_rcar(x)         ((x << 14) & 0x3C000)
//0-15: 1-16 clocks
//dft: T_RCAR-1

#define set_t_xsr(x)          ((((x & 0xF) << 18) & 0x3C0000) | ((((x >> 4) & 0x1F) << 27) & 0xF8000000))
//0-511: 1-512 clocks
//dft: T_XSR-1

#define set_t_rc(x)           ((x << 22) & 0x3C00000)
//0-15: 1-16 clocks
//dft: T_RC-1


//*********STMG1R MACROs*********//
#define set_t_init(x)         (x & 0xFFFF)
//dft: T_INIT

#define set_num_init_ref(x)   ((x << 16) & 0xF0000)
//0-15: 1-16 auto-refreshes
//dft: NUM_INIT_REF-1

#define set_t_wtr(x)          ((x << 20) & 0x300000)
//0-3: 1-4 clocks
//dft: T_WTR-1


//*********SCTLR MACROs*********//
#define set_initialize(x)     (x & 0x1)
//force memctl to initialize sdram


//*********SREFR MACROs*********//
#define set_t_ref(x)          (x & 0xFFFF)
//refresh cycles intervals

#define get_gpi(SREFR)        ((SREFR & 0xFF000000) >> 24)
//gpi

#define set_gpo(x)            ((x & 0xFF) << 16)
//gpo

//*********SCONR MACROs*********//
#define get_bank_addr_width(REG_SCONR)  ((REG_SCONR >> 3) & 0x3)
#define get_row_addr_width(REG_SCONR)   ((REG_SCONR >> 5) & 0xF)
#define get_col_addr_width(REG_SCONR)   ((REG_SCONR >> 9) & 0xF)
#define get_data_width(REG_SCONR)       ((REG_SCONR >> 13) & 0x3)

#define set_bank_addr_width(x)          ((x & 0x3) << 3)
#define set_row_addr_width(x)           ((x & 0xF) << 5)
#define set_col_addr_width(x)           ((x & 0xF) << 9) 
#define set_data_width(x)               ((x & 0x3) << 13)

////////////////////////////////////////////////////////////////////
void memctl_init();

#endif
                                                    
