//============================================================================
//
//                   (C) COPYRIGHT 2001-2011 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc.  Your use or disclosure of this
// software is subject to the terms and conditions of a written
// license agreement between you, or your company, and Synopsys, Inc.
//
// The entire notice above must be reproduced on all authorized copies
//
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_params.v $ 
// $Revision: #9 $
//
// Abstract  : DW_memctl parameters. Includes reuse pragma annotation for
// specifying proper configuration intent when packaged as a coreKit.
//
//============================================================================

//********************************************************************
//*
//* Controller Configuration Parameters
//*
//********************************************************************


// Name:         USE_FOUNDATION
// Default:      true ([<functionof>])
// Values:       false (0), true (1)
// Enabled:      [<functionof> %item]
// 
// The component code utilizes DesignWare Foundation parts for optimal 
// Synthesis QoR. Customers with only a DesignWare license MUST use 
// Foundation parts. Customers with only a Source license, CANNOT use 
// Foundation parts. Customers with both Source and DesignWare licenses 
// have the option of using Foundation parts.
`define USE_FOUNDATION 1


`define MEMCTL_USE_FOUNDATION_IS_ONE



// Name:         VER_1_2A_COMPATIABLE_MODE
// Default:      0
// Values:       0, 1
// Enabled:      DYNAMIC_RAM_TYPE==0 || (ENABLE_STATIC && DYNAMIC_RAM_TYPE==6)
// 
// If you are configuring DW_memctl for the first time, you can disable 
//  this option. However, if you are already using DW_memctl1.2A in your  
//  simulation, it is highly recommended that you enable this in order to have 
//  full software compatibility. Please refer to the databook for more details.
`define VER_1_2A_COMPATIABLE_MODE 0



// Name:         H_DATA_WIDTH
// Default:      32
// Values:       32 64 128
// 
// Specifies the width of the AHB Data Bus.
`define H_DATA_WIDTH 32


// Name:         H_ADDR_WIDTH
// Default:      32
// Values:       32 64
// 
// This specifies the AHB Address Width
`define H_ADDR_WIDTH 32



// Name:         PIPE_ADDRESS_DECODER
// Default:      0
// Values:       0, 1
// 
// Address decoder logic has the most critical timing in DW_memctl. 
//  Setting this option will add registers at the address decoder 
//  outputs and will enable the design to meet in the excess of  
//  200Mhz. If you enable this option, then this will add an extra cycle  
//  for memory access. By default, this is not set. If you see that the 
//  DW_memctl has a problem in meeting timing with the library that you  
//  are using, you should enable this option
`define PIPE_ADDRESS_DECODER 0


// Name:         ADDR_FIFO_DEPTH
// Default:      4
// Values:       4, ..., 32
// 
// Specifies the depth of the address fifo in the Host Interface 
//  Unit. The start address of Memory/Register access is stored in 
//  this FIFO. The recommended Address FIFO depth should be  
//  selected using system-typical behavior knowledge. In general, 
//  the default 4-deep address FIFO should be enough to prevent  
//  unwanted AMBA wait cycles
`define ADDR_FIFO_DEPTH 8



// Name:         WRITE_FIFO_DEPTH
// Default:      8
// Values:       4, ..., 32
// 
// The Write Data FIFO stores the AMBA write data. The depth of  
//  Write Data FIFO can be between 4 and 32, with the default value  
//  being 8. The recommended Write Data FIFO depth should be selected 
//  using memory latency. If the AMBA/memory bus ratio is 2:1, it  
//  takes two cycles to read/write one AMBA datum. Therefore, a deeper  
//  FIFO depth is recommended. 
//  The width of the FIFO will correspond to the  
//  AMBA data width.
`define WRITE_FIFO_DEPTH 16



// Name:         EBI_INTERFACE
// Default:      0
// Values:       0, 1
// 
// Enabling this will activate the External Bus   
//  Interface Logic and signals.  This logic needs to be enabled 
//  only if you plan to share the memory controller I/O PADs with other 
//  devices in your chip.
`define EBI_INTERFACE 0


// Name:         DYNAMIC_RAM_TYPE
// Default:      SDR-SDRAM
// Values:       SDR-SDRAM (0), DDR-SDRAM (1), Mobile-SDRAM (3), Disabled (6)
// 
// Select any of the SDRAM memory controller type.
`define DYNAMIC_RAM_TYPE 1


// Name:         USE_MOBILE_DDR
// Default:      0
// Values:       0, 1
// 
// Enable/Disable Mobile-DDR controller. 
//  When enabled DYNAMIC_RAM_TYPE is equal to DDR-SDRAM
`define USE_MOBILE_DDR 1

`define MOBILE_DDR_SDRAM


// Name:         ENABLE_STATIC
// Default:      1
// Values:       0, 1
// 
// Enable/Disable Static Memory Controller.
`define ENABLE_STATIC 0


// Name:         N_CS
// Default:      5
// Values:       1 2 3 4 5 6 7 8
// 
// Specifies the total number of Chip selects to be enables. 
//  A maximum of 8 chip selects are available to be shared 
//  between the different types of memories.
`define N_CS 1


// Name:         ENABLE_DATABUS_SHARING
// Default:      0 (0)
// Values:       0, 1
// Enabled:      DYNAMIC_RAM_TYPE != 6 && DYNAMIC_RAM_TYPE != 1 && ENABLE_STATIC
// 
// This is for enabling the sharing of  the data bus between the Dynamic RAM 
//  and the Static Memory Interface. The data bus sharing feature cannot be 
//  used with DDR-SDRAMs, due to critical timing and different clock domains 
//  in the data path.
`define ENABLE_DATABUS_SHARING 0


// Name:         ENABLE_ADDRBUS_SHARING
// Default:      0 (0)
// Values:       0, 1
// Enabled:      DYNAMIC_RAM_TYPE != 6 && DYNAMIC_RAM_TYPE != 1 && ENABLE_STATIC
// 
// This enables sharing the Address bus between the Dynamic RAM 
//  and the Static Memory Interface.  
//  The Address bus sharing feature may not be used with DDR-SDRAM, since it  
//  has SSTL2 pads. If selected, one may need to use external SSTL2 to TTL/LVTTL  
//  converters outside the chip to interface to Static memories.
`define ENABLE_ADDRBUS_SHARING 0


// Name:         HARD_WIRE_SDRAM_PARAMETERS
// Default:      0 (0)
// Values:       0, 1
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// Setting this parameter to 1 will always drive the SDRAM  
//  parameters to constant values and will disable the programming 
//  feature to them. This parameter is intended for designs in which 
//  the SDRAM memory type is fixed. Setting this parameter will reduce  
//  area slightly and improve synthesis timing.  The parameters which 
//  are set constant by this parameter are: S_DATA_WIDTH, READ_PIPE,  
//  WRITE_PIPE, EXTENDED_MODE_REG, S_BANK_ADDR_WIDTH, S_ROW_ADDR_WIDTH, 
//  S_COL_ADDR_WIDTH, OPEN_BANKS, CAS_LATENCY, T_RAS_MIN, T_RCD, T_RP, 
//  T_WR, T_WTR, T_RCAR, T_XSR, T_RC, T_INIT, NUM_INIT_REF
`define HARD_WIRE_SDRAM_PARAMETERS 0


// Name:         HARD_WIRE_SYNCFLASH_PARAMETERS
// Default:      0 (0)
// Values:       0, 1
// Enabled:      DYNAMIC_RAM_TYPE==4 || DYNAMIC_RAM_TYPE==5
// 
// Setting this parameter to 1 will always drive the SyncFlash 
//  parameters to constant values and will disable the programming 
//  feature to them. This parameter is intended for designs in which 
//  the SyncFlash memory type is fixed. Setting this parameter will reduce 
//  area slightly and improve synthesis timing.  The parameters which 
//  are set constant by this parameter are:  
//  SF_BANK_ADDR_WIDTH, SF_ROW_ADDR_WIDTH, 
//  SF_COL_ADDR_WIDTH, SF_CAS_LATENCY, SF_T_RCD, SF_T_RC
`define HARD_WIRE_SYNCFLASH_PARAMETERS 0



// Name:         HARD_WIRE_STATIC_PARAMETERS
// Default:      0 (0)
// Values:       0, 1
// Enabled:      ENABLE_STATIC
// 
// Setting this parameter to 1 will always drive the Static memory timing 
//  parameters to constant values and will disable the programming 
//  feature to these.  This parameter is intended for designs in which 
//  the Static memory type is fixed. Setting this parameter will reduce 
//  area slightly and improve synthesis timing. The parameters which 
//  are set constant by this parameter are: SM_DATA_WIDTH, SM_READ_PIPE_SETn, 
//  SM_WRITE_PIPE, S_DATA_WIDTH, T_RPD, t_rc_setn, T_AS_SETn, T_WR_SETn, 
//  T_WP_SETn, T_BTA_SETn, T_PRC_SETn, PAGE_MODE_SETn, PAGE_SIZE_SETn, 
//  LOW_FREQ_DEV_SETn, READY_MODE_SETn
`define HARD_WIRE_STATIC_PARAMETERS 0



// Name:         HARD_WIRE_CIPSELECT_PARAMETRS
// Default:      0 (0)
// Values:       0, 1
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// Setting this parameter to 1 will always drive the Chip select  
//  parameters to constant values and will disable the programming 
//  feature to these. This parameter is intended for designs in which 
//  the memory address is fixed. Setting this parameter will reduce 
//  area slightly and improve synthesis timing.  The parameters which 
//  are set constant by this parameter are: CHIP_SELECTn_BASE_ADDRESS, 
//  BLOCK_SIZEn, CHIP_SELECTn_MEM, REG_SELECTn, CHIP_SELECTn_ALIAS_ADDRESS, 
//  CHIP_SELECTn_REMAP_ADDRESS
`define HARD_WIRE_CIPSELECT_PARAMETRS 0



// Name:         WRITE_PIPE
// Default:      0
// Values:       0 1 2 3
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// Specifies the delay in clock cycles due to register 
//  insertion on the SDRAM write data bus outside the MacroCell. 
//  This value, along with cas-latency and READ_PIPE, tells the  
//  memory controller when to expect the read-data.
`define WRITE_PIPE 0


// Name:         READ_PIPE
// Default:      2
// Values:       0 1 2 3 4 5 6 7
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// Specifies the delay in clock cycles due to register 
//  insertion on the SDRAM read data bus outside the MacroCell. 
//  This value alon,g with cas-latency and WRITE_PIPE, tells the  
//  memory controller when to expect the read-data.
`define READ_PIPE 2


// Name:         T_REF
// Default:      1040
// Values:       0, ..., 65535
// Enabled:      DYNAMIC_RAM_TYPE!=6 && DYNAMIC_RAM_TYPE!=2
// 
// The default value for the number of clock cycles between 
//  consecutive refresh cycles (this is typically 15.6us, or 7.8us in the case of 
//  the newer larger SDRAMS). The user can change this value 
//  later by programming the SREFR register.
`define T_REF 1040


// Name:         T_INIT
// Default:      8
// Values:       0, ..., 65535
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// The default value for the number of clock cycles to 
//  hold the SDRAM inputs stable after power up, before 
//  issuing any commands. The user can change this value 
//  later by programming the STMGR1 register. This is Power Up  
//  VDD and CLK stable time for the SDRAMs, which is typically  
//  around 100usec. If your system reset already satisfies this time,  
//  then this could be programmed to just "1".
`define T_INIT 8


// Name:         MAX_S_DATA_WIDTH
// Default:      16 ( ( DYNAMIC_RAM_TYPE == 1 ? H_DATA_WIDTH/2 : H_DATA_WIDTH ))
// Values:       8 16 32 64 128
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// This specifies the maximum value for SDRAM data width. 
//  For SDR-SDRAM and Mobile SDR-SDRAM, the typical values supported 
//  by DW_memctl are 16, 32, 64, or 128 in ratio 1:1 or 1:2 with H_DATA_WIDTH. 
//  For DDR-SDRAM and Mobile DDR-SDRAM the supported values are 8, 16, 32, or  
//  64 in ratio 1:2 or 1:4 with H_DATA_WIDTH
`define MAX_S_DATA_WIDTH 16


// Name:         S_DATA_WIDTH
// Default:      16 ( DYNAMIC_RAM_TYPE == 1 ? H_DATA_WIDTH/2 : H_DATA_WIDTH)
// Values:       8 16 32 64 128
// Enabled:      DYNAMIC_RAM_TYPE !=6
// 
// This specifies the default reset value for SDRAM data width. This corresponds 
//  to bits [41:13] of the SCORN register. For example, when designing a chip, one  
//  could select a 32-bit MAX_S_DATA_WIDTH, but later connect only a 16-bit SDRAM 
//  to it and program the SDRAM data width to 16-bits.  
//  For SDR-SDRAM and Mobile SDR-SDRAM, the typical values supported 
//  by DW_memctl are 16, 32, 64, or 128 in ratio 1:1 or 1:2 with H_DATA_WIDTH. 
//  For DDR-SDRAM and Mobile DDR-SDRAM the supported values are 8, 16, 32, or  
//  64 in ratio 1:2 or 1:4 with H_DATA_WIDTH
`define S_DATA_WIDTH 16


// Name:         MAX_S_ADDR_WIDTH
// Default:      16 (<functionof>= 16)
// Values:       11, ..., 16
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// Address width for SDRAM. The s_addr port will have this width.
`define MAX_S_ADDR_WIDTH 16

                                       

// Name:         MAX_S_BANK_ADDR_WIDTH
// Default:      2
// Values:       1 2 3 4
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// Maximum width of the SDRAM Bank Address bits. The s_bank_addr port will  
//  have this width. 
//  Values 1 to 4 addresses 2 to 16 banks.
`define MAX_S_BANK_ADDR_WIDTH 2


// Name:         HIGHER_ADDR_FOR_BANKS
// Default:      0 (0)
// Values:       0, 1
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// When enabled, higher AHB address bits are used for generating the SDRAM  
//  bank address.  [haddr = {chip-sel, bank, ras, cas, byte-addr} instead of 
//  haddr = {chip-sel, ras, bank, cas, byte-addr}]; a useful feature in  
//  Mobile SDR/DDR-SDRAM memory systems. Since Mobile SDR/DDR-SDRAM allows one to 
//  selectively switch off banks, using higher address bits for banks will  
//  provide contiguous system address space, even if some banks are switched off. 
//  Similarly, SyncFlash pages will be mapped to continuous system address space. 
//  Enabling this could reduce the page-hit ratio during cas address crossovers.
`define HIGHER_ADDR_FOR_BANKS 0


// Name:         HIGHER_ADDR_FOR_SF_BANKS
// Default:      0 (0)
// Values:       0, 1
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// When enabled, higher AHB address bits are used for generating the SDRAM  
//  bank address.  [haddr = {chip-sel, bank, ras, cas, byte-addr} instead of 
//  haddr = {chip-sel, ras, bank, cas, byte-addr}]; a useful feature in  
//  Mobile SDR/DDR-SDRAM memory systems.  
//  Enabling this could reduce the page-hit ratio during cas address crossovers.
`define HIGHER_ADDR_FOR_SF_BANKS 0


// Name:         NUM_DQS
// Default:      2 ( MAX_S_DATA_WIDTH/8)
// Values:       0, ..., 128
// Enabled:      DYNAMIC_RAM_TYPE == 1
// 
// Specifies the number of data strobe pins for DDR-SDRAMs.
`define NUM_DQS 2


// Name:         EXTENDED_MODE_REG
// Default:      0x0
// Values:       0x0, ..., 0xffffffff
// Enabled:      DYNAMIC_RAM_TYPE==1 || DYNAMIC_RAM_TYPE ==3
// 
// Default value for the Extended Mode register values for DDR-SDRAM or  
//  Mobile DDR/SDR-SDRAM. This goes in as the default value for bits 11:0 
//  of DW_memctl Extended Mode register EXN_MODE_REG (Address 0x0000_00B0).
`define EXTENDED_MODE_REG 32'h0


// Name:         SM_WRITE_PIPE
// Default:      0
// Values:       0 1 2 3
// Enabled:      ENABLE_STATIC
// 
// Specifies the delay in clock cycles due to register 
//  insertion on the Static memory write data bus outside the MacroCell. 
//  This parameter, along with read access time(T_RC) and SM_READ_PIPE, tells  
//  the memory controller when to expect the read data.
`define SM_WRITE_PIPE 0


// Name:         MEMCTL_REG_SM_READY
// Default:      false
// Values:       false (0), true (1)
// Enabled:      ENABLE_STATIC
// 
// Specifies whether the sm_ready signal is register when entering core.
// `define MEMCTL_REG_SM_READY


// Name:         MAX_SM_DATA_WIDTH
// Default:      32 (H_DATA_WIDTH)
// Values:       8 16 32 64 128
// Enabled:      ENABLE_STATIC
// 
// Maximum size of the Static Memory Data Bus. The Static memory data ports 
//  will have this width.
`define MAX_SM_DATA_WIDTH 32



// Name:         MAX_SM_ADDR_WIDTH
// Default:      23
// Values:       11, ..., 32
// Enabled:      ENABLE_STATIC
// 
// Maximum size of the Static Memory Address Bus. The sm_addr port will have 
//  this width.
`define MAX_SM_ADDR_WIDTH 23



// Name:         T_RPD
// Default:      200
// Values:       0, ..., 4095
// Enabled:      ENABLE_STATIC
// 
// The default value for the number of clock cycles between 
//  Flash sm_rp high to read/write delay. Values correspond to 
//  RP# high to read/write delay. This value can be 
//  dynamically changed by programming the FLASH_TRPDR register. 
//  If you are planning to boot from FLASH, you should ensure this 
//  value is set correctly.
`define T_RPD 200

//********************************************************************
//*
//* Controller ChipSelects Configuration Parameters
//*
//********************************************************************

// Name:         CHIP_SELECT0_MEM
// Default:      0
// Values:       -2147483648, ..., 2147483647
// 
// Specify the memory model you want to connect to chip select0. 
//  0: SDRAM 
//  1: SRAM  
//  2: FLASH 
//  3: ROM 
//  4: Combo
`define CHIP_SELECT0_MEM 0


// Name:         REG_SELECT0
// Default:      SET2
// Values:       SET0 (0), SET1 (1), SET2 (2)
// 
// This specifies the timing register set associated for the 
//  static memory connected to Chip select0.
`define REG_SELECT0 2


// Name:         CHIP_SELECT0_BASE_ADDRESS
// Default:      0x80000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      N_CS>1
// 
// This specifies the default value for the base address 
//  register corresponding to Chip Select0. This field is enabled 
//  only if the number of selected chip selects is greater than 1.
`define CHIP_SELECT0_BASE_ADDRESS 32'h80000000





// Name:         CHIP_SEL0_REMAP_ENABLE
// Default:      0 (0)
// Values:       0, 1
// 
// This is for enabling the remap logic for Chip Select0. When enabled, 
//  and when the remap input is logic 1, the chip select will be generated 
//  if there is a match between the 
//  host address for memory address and the value in the remap register 
//  for Chip Select0.
`define CHIP_SEL0_REMAP_ENABLE 0


// Name:         CHIP_SEL0_ALIAS_ENABLE
// Default:      0 (0)
// Values:       0, 1
// 
// This is for enabling the aliasing logic for Chip Select0. When enabled, 
//  Chip Select0 will be generated under two conditions:  (1) when the 
//  host memory address matches the value in the SCSLR0 register, and 
//  (2) when the host memory address matches the value in the ALIAS0 register.
`define CHIP_SEL0_ALIAS_ENABLE 0


// Name:         CHIP_SELECT0_ALIAS_ADDRESS
// Default:      0x80000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      CHIP_SEL0_ALIAS_ENABLE ==1
// 
// This specifies the default value for the Alias address 
//  register that corresponds to Chip Select0. This field is enabled 
//  only if the parameter CHIP_SEL0_ALIAS_ENABLE is set to 1.
`define CHIP_SELECT0_ALIAS_ADDRESS 32'h80000000


// Name:         CHIP_SELECT0_REMAP_ADDRESS
// Default:      0x80000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      CHIP_SEL0_REMAP_ENABLE ==1
// 
// This specifies the default value for the Remap address 
//  register that corresponds to Chip Select0. This field is enabled 
//  only if the parameter CHIP_SEL0_REMAP_ENABLE is set to 1.
`define CHIP_SELECT0_REMAP_ADDRESS 32'h80000000


// Name:         CHIP_SELECT1_MEM
// Default:      0
// Values:       -2147483648, ..., 2147483647
// 
// Specify the memory model you want to connect to chip select1. 
//  0: SDRAM 
//  1: SRAM  
//  2: FLASH 
//  3: ROM 
//  4: Combo
`define CHIP_SELECT1_MEM 0


// Name:         REG_SELECT1
// Default:      SET2
// Values:       SET0 (0), SET1 (1), SET2 (2)
// 
// This specifies the timing register set associated for the 
//  static memory connected to Chip select1.
`define REG_SELECT1 2



// Name:         CHIP_SELECT1_BASE_ADDRESS
// Default:      0x10000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      N_CS>1
// 
// This specifies the default value for the base address 
//  register that corresponds to Chip Select1. This field is enabled 
//  only if the number of  selected chip selects is greater than 1.
`define CHIP_SELECT1_BASE_ADDRESS 32'h10000000


// Name:         CHIP_SEL1_REMAP_ENABLE
// Default:      0 (0)
// Values:       0, 1
// Enabled:      N_CS>1
// 
// This enables the remap logic for Chip Select1. When enabled, 
//  and when the remap input is logic 1, the chip select will be generated 
//  if there is a match between the host address for memory address and 
//  the value in the remap register for Chip Select1.
`define CHIP_SEL1_REMAP_ENABLE 0


// Name:         CHIP_SEL1_ALIAS_ENABLE
// Default:      0 (0)
// Values:       0, 1
// Enabled:      N_CS>1
// 
// This enables the aliasing logic for Chip Select1. When enabled, 
//  Chip Select1 will be generated under two conditions:  (1) when the 
//  host memory address matches the value in the SCSLR0 register, and  
//  (2) when the host memory address matches the value in the ALIAS0 register.
`define CHIP_SEL1_ALIAS_ENABLE 0



// Name:         CHIP_SELECT1_ALIAS_ADDRESS
// Default:      0x18000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      CHIP_SEL1_ALIAS_ENABLE ==1 && N_CS>1
// 
// This specifies the default value for the alias address 
//  register that corresponds to Chip Select1. This field is enabled 
//  only if the parameter CHIP_SEL1_ALIAS_ENABLE is set to 1.
`define CHIP_SELECT1_ALIAS_ADDRESS 32'h18000000


// Name:         CHIP_SELECT1_REMAP_ADDRESS
// Default:      0x12000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      CHIP_SEL1_REMAP_ENABLE ==1 && N_CS>1
// 
// This specifies the default value for the remap address 
//  register that corresponds to Chip Select1. This field is enabled 
//  only if the parameter CHIP_SEL1_REMAP_ENABLE is set to 1.
`define CHIP_SELECT1_REMAP_ADDRESS 32'h12000000


// Name:         CHIP_SELECT2_MEM
// Default:      1
// Values:       -2147483648, ..., 2147483647
// 
// Specify the memory model you want to connect to chip select2. 
//  0: SDRAM 
//  1: SRAM  
//  2: FLASH 
//  3: ROM 
//  4: Combo
`define CHIP_SELECT2_MEM 1


// Name:         REG_SELECT2
// Default:      SET0
// Values:       SET0 (0), SET1 (1), SET2 (2)
// 
// This specifies the timing register set associated for the 
//  static memory connected to Chip select2.
`define REG_SELECT2 0
 

// Name:         CHIP_SELECT2_BASE_ADDRESS
// Default:      0x20000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      N_CS>2
// 
// This specifies the default value for the base address 
//  register that corresponds to Chip Select2. This field is enabled 
//  only if the number of selected chip selects is greater than 2.
`define CHIP_SELECT2_BASE_ADDRESS 32'h20000000


// Name:         CHIP_SELECT3_MEM
// Default:      2
// Values:       -2147483648, ..., 2147483647
// 
// Specify the memory model you want to connect to chip select3. 
//  0: SDRAM 
//  1: SRAM  
//  2: FLASH 
//  3: ROM 
//  4: Combo
`define CHIP_SELECT3_MEM 2


// Name:         REG_SELECT3
// Default:      SET1
// Values:       SET0 (0), SET1 (1), SET2 (2)
// 
// This specifies the timing register set associated for the 
//  static memory connected to Chip select3.
`define REG_SELECT3 1


// Name:         CHIP_SELECT3_BASE_ADDRESS
// Default:      0x30000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      N_CS>3
// 
// This specifies the default value for the base address 
//  register that corresponds to Chip Select3. This field is enabled 
//  only if the number of selected chip selects is greater than 3.
`define CHIP_SELECT3_BASE_ADDRESS 32'h30000000
 

// Name:         CHIP_SELECT4_MEM
// Default:      3
// Values:       -2147483648, ..., 2147483647
// 
// Specify the memory model you want to connect to chip select4. 
//  0: SDRAM 
//  1: SRAM  
//  2: FLASH 
//  3: ROM 
//  4: Combo
`define CHIP_SELECT4_MEM 3


// Name:         REG_SELECT4
// Default:      SET2
// Values:       SET0 (0), SET1 (1), SET2 (2)
// 
// This specifies the timing register set associated for the 
//  static memory connected to Chip select4.
`define REG_SELECT4 2


// Name:         CHIP_SELECT4_BASE_ADDRESS
// Default:      0x40000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      N_CS>4
// 
// This specifies the default value for the base address 
//  register that corresponds to Chip Select4. This field is enabled 
//  only if the number of selected chip selects is greater than 4.
`define CHIP_SELECT4_BASE_ADDRESS 32'h40000000
 

// Name:         CHIP_SELECT5_MEM
// Default:      0
// Values:       -2147483648, ..., 2147483647
// 
// Specify the memory model you want to connect to chip select5. 
//  0: SDRAM 
//  1: SRAM  
//  2: FLASH 
//  3: ROM 
//  4: Combo
`define CHIP_SELECT5_MEM 0


// Name:         REG_SELECT5
// Default:      SET1
// Values:       SET0 (0), SET1 (1), SET2 (2)
// 
// This specifies the timing register set associated for the 
//  static memory connected to Chip select5.
`define REG_SELECT5 1
 

// Name:         CHIP_SELECT5_BASE_ADDRESS
// Default:      0x50000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      N_CS>5
// 
// This specifies the default value for the base address 
//  register corresponding to Chip Select5. This field is enabled 
//  only if the number of selected chip selects is greater than 5.
`define CHIP_SELECT5_BASE_ADDRESS 32'h50000000
 

// Name:         CHIP_SELECT6_MEM
// Default:      0
// Values:       -2147483648, ..., 2147483647
// 
// Specify the memory model you want to connect to chip select6. 
//  0: SDRAM 
//  1: SRAM  
//  2: FLASH 
//  3: ROM 
//  4: Combo
`define CHIP_SELECT6_MEM 0


// Name:         REG_SELECT6
// Default:      SET1
// Values:       SET0 (0), SET1 (1), SET2 (2)
// 
// This specifies the timing register set associated for the 
//  static memory connected to Chip select6.
`define REG_SELECT6 1
 

// Name:         CHIP_SELECT6_BASE_ADDRESS
// Default:      0x60000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      N_CS>6
// 
// This specifies the default value for the base address 
//  register corresponding to Chip Select6. This field is enabled 
//  only if the number of selected chip selects is greater than 6.
`define CHIP_SELECT6_BASE_ADDRESS 32'h60000000


// Name:         CHIP_SELECT7_MEM
// Default:      0
// Values:       -2147483648, ..., 2147483647
// 
// Specify the memory model you want to connect to chip select7. 
//  0: SDRAM 
//  1: SRAM  
//  2: FLASH 
//  3: ROM 
//  4: Combo
`define CHIP_SELECT7_MEM 0


// Name:         REG_SELECT7
// Default:      SET1
// Values:       SET0 (0), SET1 (1), SET2 (2)
// 
// This specifies the timing register set associated for the 
//  static memory connected to Chip select7.
`define REG_SELECT7 1
 

// Name:         CHIP_SELECT7_BASE_ADDRESS
// Default:      0x70000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      N_CS>7
// 
// This specifies the default value for the base address 
//  register that corresponds to Chip Select7. This field is enabled 
//  only if the number of selected chip selects is greater than 7.
`define CHIP_SELECT7_BASE_ADDRESS 32'h70000000
 

//********************************************************************
//*
//* SDRAM-Specific Parameters
//*
//********************************************************************


// Name:         S_ROW_ADDR_WIDTH
// Default:      12 (<functionof>= 12)
// Values:       11 12 13 14 15 16
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// Width of the SDRAM row address bus. This directly 
//  controls the width of the SDRAM address bus. 
//  The supported SDRAM should have at least 2K rows. 
//  If the user is using DesignWare Memory Model, then 
//  this parameter will be automatically loaded.
`define S_ROW_ADDR_WIDTH 13


// Name:         S_COL_ADDR_WIDTH
// Default:      9 (<functionof>= 9)
// Values:       8 9 10 11 12 13 14 15
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// Width of the SDRAM column address bus. The supported 
//  SDRAM should have at least 256 columns. If the 
//  user is using the DesignWare Memory Model, then this parameter 
//  will be automatically loaded.
`define S_COL_ADDR_WIDTH 9


// Name:         S_BANK_ADDR_WIDTH
// Default:      2
// Values:       1 2 3 4
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// Width of the SDRAM bank address. DW_memctl supports 
//  a maximum of 16 banks. 
//  Values 1 to 4 address 2 to 16 banks. 
//  If the user is using the DesignWare Memory Model, then this 
//  parameter will be automatically loaded.
`define S_BANK_ADDR_WIDTH 2


// Name:         A8_FOR_PRECHARGE
// Default:      A10
// Values:       A10 (0), A8 (1)
// Enabled:      DYNAMIC_RAM_TYPE==1
// 
// Specifies the Precharge bit used by the DDR-SDRAM. Some 
//  Micron DDR-SDRAMs use the A8 bit for precharge, whereas 
//  several other vendors use the A10 bit for Precharge.
`define A8_FOR_PRECHARGE 0



// Name:         OPEN_BANKS
// Default:      4 ( (S_BANK_ADDR_WIDTH == 1? 2 : (S_BANK_ADDR_WIDTH == 2? 4: 
//               (S_BANK_ADDR_WIDTH == 3? 8:16))))
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// This specifies the number of active banks to be kept open at any time.  
//  The user can choose a value from 1 to 16 banks.
`define OPEN_BANKS 4



// Name:         CAS_LATENCY
// Default:      3 Clocks
// Values:       1 Clock (1), 2 Clocks (2), 3 Clocks (3), 4 Clocks (4), 1.5 Clocks 
//               (5), 2.5 Clocks (6)
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// The default value in clock cycles for the SDRAM Cas latency. 
//  This value can be changed later by programming 
//  the STMG1R timing register. If the user is using the DesignWare 
//  Memory Model, then this parameter will be automatically loaded.
`define CAS_LATENCY 3


// Name:         T_RAS_MIN
// Default:      6
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// The default value in clock cycles for the minimum delay between  
//  the ACTIVE and the PRECHARGE commands. 
//  The user can change this value later by programming 
//  the STMGR1 register. If the user is using DesignWare Memory 
//  Model, then this parameter will be automatically loaded.
`define T_RAS_MIN 6


// Name:         T_RCD
// Default:      3
// Values:       1 2 3 4 5 6 7 8
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// The default value in clock cycles for the minimum delay between 
//  the ACTIVE and READ/WRITE commands. 
//  The user can change this value later by programming 
//  the STMGR1 register. If the user is using the DesignWare Memory 
//  Model, then this parameter will be automatically loaded.
`define T_RCD 3


// Name:         T_RP
// Default:      3
// Values:       1 2 3 4 5 6 7 8
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// The default value in clock cycles for the Precharge period  
//  The user can change this value later by  
//  programming the STMGR1 register. If the user is using  
//  the DesignWare Memory Model, then this parameter will be automatically 
//  loaded.
`define T_RP 4


// Name:         T_WR
// Default:      3
// Values:       1 2 3 4
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// The default value in clock cycles for the delay from the last  
//  data in (in case of writes) to the next precharge command. 
//  The user can change this value later by 
//  programming the STMGR1 register. If the user is using the DesignWare 
//  Memory Model, then this parameter will be automatically loaded.
`define T_WR 2


// Name:         T_RCAR
// Default:      10
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
// Enabled:      DYNAMIC_RAM_TYPE!=6 && DYNAMIC_RAM_TYPE!=2
// 
// The default value in clock cycles for the Auto Refresh period. 
//  This is the minimum time between two auto refresh commands. 
//  The user can change this value later by 
//  programming the STMGR1 register. If the user is using the DesignWare 
//  Memory Model, then this parameter will be automatically loaded.
`define T_RCAR 10


// Name:         T_XSR
// Default:      250 ( (DYNAMIC_RAM_TYPE == 0) ? 11 : 250)
// Values:       1, ..., 512
// Enabled:      DYNAMIC_RAM_TYPE!=6 && DYNAMIC_RAM_TYPE!=2
// 
// The default value for the Exit self-refresh to Active or 
//  auto-refresh command time. This is the minimum time 
//  the controller should wait after taking the SDRAM out of 
//  the self_refresh mode, before issuing any Active- or Auto- 
//  refresh commands. The user can change this value later by 
//  programming the STMGR1 register. If the user is using DesignWare 
//  Memory Model, then this parameter will be automatically loaded.
`define T_XSR 16


// Name:         T_RC
// Default:      10
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// Active-to-Active command period. Values of 0-15 correspond to 
//  t_rc of 1 to 16 clocks. The user can change this value later 
//  by programming the STMGR1 register. If the user is using the DesignWare 
//  Memory Model, then this parameter will be automatically loaded.
`define T_RC 10


// Name:         T_XP
// Default:      5
// Values:       2 3 4 5 6 7
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// DDR and Mobile DDR Exit power down to next valid command delay. 
//  Valid values are 2 to 7 clocks. There is no corresponding timing register 
//  for this value and therefore it cannot be changed later.
`define T_XP 5


// Name:         NUM_INIT_REF
// Default:      8
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
// Enabled:      DYNAMIC_RAM_TYPE!=6 && DYNAMIC_RAM_TYPE!=2
// 
// The default value for the number of auto refreshes  
//  during initialization. Values 0-15 correspond to 1-16  
//  auto refresh. The user can change this value later by 
//  programming the STMGR2 register. Users have to manually  
//  specify this parameter, which is not automatically 
//  loaded, even if they use DesignWare Memory Model.
`define NUM_INIT_REF 8


// Name:         T_WTR
// Default:      1 Clock
// Values:       1 Clock (1), 2 Clocks (2), 3 Clocks (3), 4 Clocks (4)
// Enabled:      DYNAMIC_RAM_TYPE == 1
// 
// This is the internal write-to-read command delay for DDR-SDRAMs.
`define T_WTR 1


// Name:         S_READY_VALID
// Default:      0 (0)
// Values:       0, 1
// Enabled:      DYNAMIC_RAM_TYPE != 6
// 
// When enabled, indicates that the SDRAM read data should   
//  be sampled after the s_rd_ready input goes active. This goes   
//  in as the default value for bit 17 of the SCTLR register.
`define S_READY_VALID 0


// Name:         S_DOUT_VALID_LOW
// Default:      0 (0)
// Values:       0, 1
// Enabled:      DYNAMIC_RAM_TYPE!=6
// 
// s_dout_valid signal enables the output buffers DQS and DQ. Setting this parameter 
//  enables s_dout_valid to be driven to logic 0 (deasserted) when the controller is idle, 
//  e.g. during initialization, power-down, self-refresh.
`define S_DOUT_VALID_LOW 0


// `define S_DOUT_VALID_LOW_1

//********************************************************************
//*
//* SyncFlash-Specific Parameters (When used with SDRAM)
//*
//********************************************************************


// Name:         SF_ROW_ADDR_WIDTH
// Default:      12
// Values:       11 12 13 14 15 16
// Enabled:      DYNAMIC_RAM_TYPE==4 || DYNAMIC_RAM_TYPE==5
// 
// Width of the SyncFlash row address bus. This directly 
//  controls the width of the SyncFlash address bus. 
//  The supported SyncFlash should have at least 2K rows. 
//  If the user is using the DesignWare Memory Model, then 
//  this parameter will be automatically loaded.
`define SF_ROW_ADDR_WIDTH 12


// Name:         SF_COL_ADDR_WIDTH
// Default:      9
// Values:       8 9 10 11 12 13 14 15
// Enabled:      DYNAMIC_RAM_TYPE==4 || DYNAMIC_RAM_TYPE==5
// 
// Width of the SyncFlash column address bus. The supported 
//  SyncFlash should have at least 256 columns. If the 
//  user is using the DesignWare Memory Model, then this parameter 
//  will be automatically loaded.
`define SF_COL_ADDR_WIDTH 9


// Name:         SF_BANK_ADDR_WIDTH
// Default:      2
// Values:       1 2 3 4
// Enabled:      DYNAMIC_RAM_TYPE==4 || DYNAMIC_RAM_TYPE==5
// 
// Width of the SyncFlash bank address. DW_memctl supports 
//  a maximum of 16 banks. 
//  Values 1 to 4 address 2 to 16 banks. 
//  If the user is using the DesignWare Memory Model, then this 
//  parameter will be automatically loaded.
`define SF_BANK_ADDR_WIDTH 2


// Name:         SF_CAS_LATENCY
// Default:      3 Clocks
// Values:       1 Clock (1), 2 Clocks (2), 3 Clocks (3), 4 Clocks (4), 5 Clocks (5)
// Enabled:      DYNAMIC_RAM_TYPE==4 || DYNAMIC_RAM_TYPE==5
// 
// The default value in clock cycles for the SyncFlash Cas latency. 
//  This value can be changed later on by programming 
//  the SFTMGR timing register. If the user is using the DesignWare 
//  Memory Model, then this parameter will be automatically loaded.
`define SF_CAS_LATENCY 3



// Name:         SF_T_RCD
// Default:      3
// Values:       1 2 3 4 5 6 7 8
// Enabled:      DYNAMIC_RAM_TYPE==4 || DYNAMIC_RAM_TYPE==5
// 
// The default value in clock cycles for the minimum delay 
//  between the ACTIVE and READ/WRITE command. 
//  The user can change this value later by programming 
//  the SFTMGR register. If the user is using DesignWare Memory 
//  Model, then this parameter will be automatically loaded.
`define SF_T_RCD 3



// Name:         SF_T_RC
// Default:      10
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
// Enabled:      DYNAMIC_RAM_TYPE==4 || DYNAMIC_RAM_TYPE==5
// 
// Active-to -Active command period. Values of 0-15 correspond to 
//  t_rc of 1 to 16 clocks. The user can change this value later 
//  by programming the SFTMGR register. If the user is using the DesignWare 
//  Memory Model, then this parameter will be automatically loaded.
`define SF_T_RC 10




//********************************************************************
//*
//* Timing Parameters for Register Set0
//*
//********************************************************************


// Name:         T_RC_SET0
// Default:      2
// Values:       1, ..., 64
// Enabled:      ENABLE_STATIC
// 
// Specifies Read Cycle Time for the static memory associated  
//  with register set0. This is the minimum time the Address bus  
//  must be stable. This goes in as the default value of bits 5:0 of the 
//  Static Memory timing register SMTMGR_SET0. If the user is 
//  using the DesignWare Memory Model, then this parameter will be automatically 
//  loaded. 
//  The corresponding parameter for AMD Flash is "trc" 
//  Intel Flash  - "tavav" 
//  Samsung SRAM - "trc"
`define T_RC_SET0 2


// Name:         T_AS_SET0
// Default:      1
// Values:       0 1 2 3
// Enabled:      ENABLE_STATIC
// 
// Specifies the Write Address setup time for Static memory associated 
//  with register set0. This is the minimum time the address must be stable 
//  before Chip Enable or Write Enable is asserted. If the user is using  
//  the DesignWare Memory Model, then this parameter will be automatically loaded. 
//  This parameter goes in as the default value for bits 7:6 of the 
//  Static Memory Timing Register Set0 SMTMGR_SET0. 
//  The corresponding parameter for Intel Flash is -"telwl"; 
//  AMD-Flash - "max(tas,tcs)"; and, 
//  Samsung SRAM - "tas".
`define T_AS_SET0 1


// Name:         T_WR_SET0
// Default:      0
// Values:       0 1 2 3
// Enabled:      ENABLE_STATIC
// 
// Specifies the Write Recovery time for the Static memory associated 
//  with register set0. This is same as the minimum time Address/Data 
//  must be stable after a Chip Enable or Write Enable is de-asserted. 
//  This goes in as bits 9:8 of Static Memory Timing Register set0 
//  SMTMGR_SET0. If the user is using the DesignWare Memory Model, then this 
//  parameter is automatically loaded. 
//  The corresponding parameters for different memories are: 
//  Intel Flash  - max(twhax,twhdx); 
//  AMD-Flash    - tdh; and 
//  Samsung SRAM - tha.
`define T_WR_SET0 0


// Name:         T_WP_SET0
// Default:      2
// Values:       1, ..., 64
// Enabled:      ENABLE_STATIC
// 
// Specifies the Write Pulse Width for Static memory associated  
//  with register set0. This goes in as the default value for bits 
//  15:10 of Static Memory Timing register set0 SMTMGR_SET0. 
//  The corresponding parameters for different memories are: 
//  Intel Flash  -"twlwh"; 
//  AMD Flash    - "twp"; and 
//  Samsung SRAM - "tpwe". 
//  If the user is using the DesignWare Memory Model, then this parameter  
//  is automatically loaded.
`define T_WP_SET0 2


// Name:         T_BTA_SET0
// Default:      1
// Values:       0, ..., 7
// Enabled:      ENABLE_STATIC
// 
// Specifies the Data Bus turnaround time for Static memory 
//  associated with register set0. This goes in as the default 
//  value for bits 18:16 of the SMTMGR_SET0 register. 
//  The user has to manually enter this parameter. This parameter 
//  is not automatically loaded, even if you are using the 
//  DesignWare Memory Model.
`define T_BTA_SET0 1


// Name:         T_PRC_SET0
// Default:      1
// Values:       1, ..., 16
// Enabled:      ENABLE_STATIC
// 
// Specifies the Page Mode read cycle time for Static memory 
//  associated with register set0. This is the delay from the  
//  LSBs of the address bus to the corresponding Data Bus change. 
//  This goes in as the default value for bits 22:19 of SMTMGR_SET0. 
//  If you are using the DesignWare Memory Model, then this parameter will be 
//  automatically loaded. 
//  The corresponding parameters for different memories are: 
//  Intel Flash - tapa; and 
//  AMD-Flash - taccl.
`define T_PRC_SET0 1


// Name:         PAGE_MODE_SET0
// Default:      0 (0)
// Values:       0, 1
// Enabled:      ENABLE_STATIC
// 
// Specifies if the Static memory device associated with 
//  register set0 supports page mode or not. 
//  0 : Device does not support page mode 
//  1 : Device does support page mode 
//  This goes in as the default value for bit 23 of the 
//  SMTMGR_SET0 register.
`define PAGE_MODE_SET0 0


// Name:         PAGE_SIZE_SET0
// Default:      4 Word Page
// Values:       4 Word Page (0), 8 Word Page (1), 16 Word Page (2), 32 Word Page 
//               (3)
// Enabled:      ENABLE_STATIC && PAGE_MODE_SET0
// 
// Specifies the page size for the Static memory device associated 
//  with register set0. The user has to manually enter this parameter, 
//  which is not automatically set even if you use the DesignWare Memory Model. 
//  This goes in as the default value of bits 25:24 of the 
//  SMTMGR_SET0 register.
`define PAGE_SIZE_SET0 0


// Name:         READY_MODE_SET0
// Default:      0 (0)
// Values:       0, 1
// Enabled:      ENABLE_STATIC
// 
// Specifies if the device associated with register set0 needs a ready-mode   
//  handshake or not. This feature is meant for non-memory type of device interface. 
//  In ready mode, DW_memctl takes read data after sm_ready signal goes active. 
//  During write, the write cycle ends only after the sm_ready is sampled active. 
//  0 : Enable ready-mode operation 
//  1 : Disable ready-mode operation 
//  This goes in as the default value for bit 26 of the SMTMGR_SET0 
//  register. 
//  This parameter is NOT automatically set if the user is using  
//  the DesignWare Memory Model.
`define READY_MODE_SET0 0


// Name:         LOW_FREQ_DEV_SET0
// Default:      0 (0)
// Values:       0, 1
// Enabled:      ENABLE_STATIC
// 
// This bit is valid if register set0 is used to control 
//  a synchronous memory. When interfacing to a synchronous 
//  memory, the device frequency can be a sub-multiple of the 
//  AHB frequency (1, 1/2, 1/3, 1/4, or 1/5, and so on) . 
//  This bit indicates if the device 
//  operates on a lower frequency than the AHB Clock frequency.
`define LOW_FREQ_DEV_SET0 0


// Name:         SM_READ_PIPE_SET0
// Default:      0
// Values:       0 1 2 3
// Enabled:      ENABLE_STATIC
// 
// Specifies the delay in clock cycles due to register 
//  insertion on the memory read data bus, outside the MacroCell 
//  for the Static memory associated with Register set0. 
//  This parameter, along with read access time (T_RC) and SM_WRITE_PIPE, 
//  tells the memory controller when to expect the read data.
`define SM_READ_PIPE_SET0 0


// Name:         SM_DATA_WIDTH_SET0
// Default:      32 ( MAX_SM_DATA_WIDTH)
// Values:       8 16 32 64 128
// Enabled:      ENABLE_STATIC
// 
// This specifies the default reset value for Static Memory data width. 
//  This parameter is used only for simulation purpose. This controls 
//  "the sm_data_width_set0" port in the testbench. This defines the power-on 
//  reset value of bits [9:7] of SMCTLR register. For example when designing a 
//  chip one could select a 32-bit MAX_SM_DATA_WIDTH, but later connect only 
//  16-bit Static memory to it and strap the "sm_data_width_set0" port to "000" 
//  to select data width of 16-bits
`define SM_DATA_WIDTH_SET0 32


//********************************************************************
//*
//* Timing Parameters for Register Set1
//*
//********************************************************************
 

// Name:         T_RC_SET1
// Default:      28
// Values:       1, ..., 64
// Enabled:      ENABLE_STATIC
// 
// Specifies the Read Cycle Time for the Static memory associated  
//  with register set1. This is the minimum time the address bus  
//  must be stable. This goes in as the default value for bits 5:0 of 
//  Static memory timing register SMTMGR_SET1. If you are using 
//  the DesignWare Memory Model, then this parameter will be automatically 
//  loaded. 
//  The corresponding parameter for AMD Flash is "trc"; 
//  Intel Flash  - "tavav"; and 
//  Samsung SRAM - "trc".
`define T_RC_SET1 28


// Name:         T_AS_SET1
// Default:      1
// Values:       0 1 2 3
// Enabled:      ENABLE_STATIC
// 
// Specifies the Write Address Setup Time for Static memory associated 
//  with register set1. This is the minimum time the address must be stable 
//  before Chip Enable or Write Enable is asserted. If the user is using  
//  the DesignWare Memory Model, then this parameter will be automatically loaded. 
//  This parameter goes in as the default value for bits 7:6 of  
//  Static Memory Timing Register Set0 SMTMGR_SET0. 
//  The corresponding parameters for Intel Flash is -"telwl"; 
//  AMD-Flash    - "max(tas,tcs)"; and 
//  Samsung SRAM - "tas".
`define T_AS_SET1 1


// Name:         T_WR_SET1
// Default:      3
// Values:       0 1 2 3
// Enabled:      ENABLE_STATIC
// 
// Specifies the Write Recovery time for the Static memory associated 
//  with register set1. This is same as the minimum time Address/Data 
//  must be stable after Chip Enable or Write Enable is de-asserted. 
//  This goes in as bits 9:8 of Static Memory Timing Register set1 
//  SMTMGR_SET1. If the user is using the DesignWare Memory Model, then this 
//  parameter is automatically loaded. 
//  The corresponding parameters for different memories are: 
//  Intel Flash  - max(twhax,twhdx); 
//  AMD-Flash  - tdh; and 
//  Samsung SRAM - tha.
`define T_WR_SET1 3


// Name:         T_WP_SET1
// Default:      20
// Values:       1, ..., 64
// Enabled:      ENABLE_STATIC
// 
// Specifies the Write Pulse Width for the Static memory associated  
//  with register set1. This is the same as the minimum time Address/Data 
//  must be stable after Chip Enable or Write Enable is de-asserted. 
//  This goes in as bits 9:8 of Static Memory Timing Register set1 
//  SMTMGR_SET1. 
//  The corresponding parameters for different memories are: 
//  Intel Flash  - max(twhax,twhdx); 
//  AMD-Flash  - tdh; and 
//  Samsung SRAM - tha. 
//  If the user is using the DesignWare Memory Model, then this parameter  
//  is automatically loaded.
`define T_WP_SET1 20


// Name:         T_BTA_SET1
// Default:      4
// Values:       0, ..., 7
// Enabled:      ENABLE_STATIC
// 
// Specifies the Data Bus turnaround time for Static memory 
//  associated with register set1. This goes in as the default 
//  value for bits 18:16 of the SMTMGR_SET1 register. 
//  The user has to manually enter this parameter. This parameter 
//  is not automatically loaded, even if you are using the DesignWare  
//  Memory Model.
`define T_BTA_SET1 4


// Name:         T_PRC_SET1
// Default:      16
// Values:       1, ..., 16
// Enabled:      ENABLE_STATIC
// 
// Specifies the Page Mode read cycle time for Static memory 
//  associated with register set1. This is the delay from the 
//  LSBs of the address bus to the corresponding Data Bus change. 
//  This goes in as the default value for bits 22:19 of SMTMGR_SET1. 
//  If you are using the DesignWare Memory Model, then this parameter will be 
//  automatically loaded. 
//  The corresponding parameters for different memories are: 
//  Intel Flash - tapa; and 
//  AMD-Flash - taccl.
`define T_PRC_SET1 16


// Name:         PAGE_MODE_SET1
// Default:      0 (0)
// Values:       0, 1
// Enabled:      ENABLE_STATIC
// 
// Specifies if the Static memory device associated with 
//  register set1 supports page mode or not. 
//  0 : Device does not support page mode 
//  1 : Device does support page mode 
//  This goes in as the default value for bit 23 of the SMTMGR_SET1 
//  register.
`define PAGE_MODE_SET1 0


// Name:         PAGE_SIZE_SET1
// Default:      4 Word Page
// Values:       4 Word Page (0), 8 Word Page (1), 16 Word Page (2), 32 Word Page 
//               (3)
// Enabled:      ENABLE_STATIC && PAGE_MODE_SET1
// 
// Specifies the page size for the Static memory device associated 
//  with register set1. The user has to manually enter this parameter, 
//  which is not automatically set, even if you use the DesignWare Memory Model 
//  This goes in as the default value for bits 25:24 of register 
//  SMTMGR_SET1.
`define PAGE_SIZE_SET1 0


// Name:         READY_MODE_SET1
// Default:      0 (0)
// Values:       0, 1
// Enabled:      ENABLE_STATIC
// 
// Specifies if the device associated with Register Set1 needs a ready-mode   
//  handshake or not. This feature is meant for a non-memory type device interface. 
//  In ready mode, DW_memctl takes read data after the sm_ready signal goes active. 
//  During write, the write cycle ends only after the sm_ready is sampled active. 
//  0 : Enable ready-mode operation 
//  1 : Disable ready-mode operation 
//  This goes in as the default value for bit 26 of the SMTMGR_SET1 
//  register. 
//  This parameter is NOT automatically set if the user is using  
//  the DesignWare Memory Model.
`define READY_MODE_SET1 0


// Name:         LOW_FREQ_DEV_SET1
// Default:      0 (0)
// Values:       0, 1
// Enabled:      ENABLE_STATIC
// 
// This bit is valid if Register Set1 is used to control 
//  a synchronous memory. When interfacing to a synchronous 
//  memory, the device frequency can be a sub-multiple of the 
//  AHB frequency (1, 1/2, 1/3, 1/4, or 1/5, and so on). 
//  This bit indicates if the device 
//  operates on a lower frequency than the AHB Clock frequency.
`define LOW_FREQ_DEV_SET1 0


// Name:         SM_READ_PIPE_SET1
// Default:      0
// Values:       0 1 2 3
// Enabled:      ENABLE_STATIC
// 
// Specifies the delay in clock cycles due to register 
//  insertion on the memory read data bus, outside the MacroCell, 
//  for the Static memory associated with Register set1. 
//  This parameter, along with read access time(T_RC) and SM_WRITE_PIPE, 
//  tells the memory controller when to expect the read data.
`define SM_READ_PIPE_SET1 0


// Name:         SM_DATA_WIDTH_SET1
// Default:      32 ( MAX_SM_DATA_WIDTH)
// Values:       8 16 32 64 128
// Enabled:      ENABLE_STATIC
// 
// This specifies the default reset value for Static memory data width. This  
//  corresponds to bits [12:10] of the SMCTLR register. For example, when designing a   
//  chip, one could select a 32-bit MAX_SM_DATA_WIDTH, but later connect only  
//  16-bit Static memory to it and program the Static memory data width to 16-bits.
`define SM_DATA_WIDTH_SET1 32


//********************************************************************
//*
//* Timing Parameters for Register Set2
//*
//********************************************************************


// Name:         T_RC_SET2
// Default:      28
// Values:       1, ..., 64
// Enabled:      ENABLE_STATIC
// 
// Specifies Read Cycle Time for the Static memory associated  
//  with register set2. This is the minimum time the address bus  
//  must be stable. This goes in as the default value for bits 5:0 of 
//  Static Memory timing register SMTMGR_SET2. If you are using  
//  the DesignWare Memory Model, then this parameter will be automatically 
//  loaded. 
//  The corresponding parameter for AMD Flash is "trc"; 
//  Intel Flash  - "tavav"; and 
//  Samsung SRAM - "trc".
`define T_RC_SET2 28



// Name:         T_AS_SET2
// Default:      1
// Values:       0 1 2 3
// Enabled:      ENABLE_STATIC
// 
// Specifies the Write Address Setup Time for the Static memory associated 
//  with register set2. This is the minimum time the address must be stable 
//  before Chip Enable or Write Enable is asserted. If the user is using  
//  the DesignWare Memory Model, then this parameter will be automatically loaded. 
//  This parameter goes in as the default value for bits 7:6 of 
//  Static Memory Timing Register Set0 SMTMGR_SET0. 
//  The corresponding parameters for Intel Flash is -"telwl"; 
//  AMD-Flash  - "max(tas,tcs)"; and 
//  Samsung SRAM - "tas".
`define T_AS_SET2 1


// Name:         T_WR_SET2
// Default:      3
// Values:       0 1 2 3
// Enabled:      ENABLE_STATIC
// 
// Specifies the Write Recovery time for the Static memory associated 
//  with register set2. This is the same as the minimum time Address/Data 
//  must be stable after Chip Enable or Write Enable is de-asserted. 
//  This goes in as bits 9:8 of Static Memory Timing Register set2 
//  SMTMGR_SET2. If the user is using the DesignWare Memory Model, then this 
//  parameter is automatically loaded. 
//  The corresponding parameters for different memories are: 
//  Intel Flash  - max(twhax,twhdx); 
//  AMD-Flash  - tdh; and 
//  Samsung SRAM - tha.
`define T_WR_SET2 3


// Name:         T_WP_SET2
// Default:      20
// Values:       1, ..., 64
// Enabled:      ENABLE_STATIC
// 
// Specifies the Write Pulse Width for the Static memory associated  
//  with register set1. This is same as the minimum time Address/Data 
//  must be stable after Chip Enable or Write Enable is de-asserted. 
//  This goes in as bits 9:8 of Static Memory Timing Register set2 
//  SMTMGR_SET2. 
//  The corresponding parameters for different memories are: 
//  Intel Flash  - max(twhax,twhdx); 
//  AMD-Flash  - tdh; and 
//  Samsung SRAM - tha. 
//  If the user is using the DesignWare Memory Model, then this parameter 
//  is automatically loaded.
`define T_WP_SET2 20


// Name:         T_BTA_SET2
// Default:      4
// Values:       0, ..., 7
// Enabled:      ENABLE_STATIC
// 
// Specifies the Data Bus turnaround time for the Static memory 
//  associated with register set2. This goes in as the default 
//  value for bits 18:16 of the SMTMGR_SET2 register. 
//  The user has to manually enter this parameter, which 
//  is not automatically loaded, even if you are using  the DesignWare 
//  Memory Model.
`define T_BTA_SET2 4


// Name:         T_PRC_SET2
// Default:      4
// Values:       1, ..., 16
// Enabled:      ENABLE_STATIC
// 
// Specifies the Page Mode read cycle time for the Static memory 
//  associated with register set2. This is the delay from the 
//  LSBs of the address bus to the corresponding data bus change. 
//  This goes in as the default value for bits 22:19 of SMTMGR_SET1. 
//  If you are using the DesignWare Memory Model, then this parameter will be 
//  automatically loaded. 
//  The corresponding parameters for different memories are: 
//  Intel Flash - tapa; and 
//  AMD-Flash - taccl.
`define T_PRC_SET2 4


// Name:         PAGE_MODE_SET2
// Default:      0 (0)
// Values:       0, 1
// Enabled:      ENABLE_STATIC
// 
// Specifies if the Static memory device associated with 
//  register set2 supports page mode or not. 
//  0 : Device does not support page mode 
//  1 : Device does support page mode 
//  This goes in as the default value for bit 23 of the SMTMGR_SET2 
//  register.
`define PAGE_MODE_SET2 0


// Name:         PAGE_SIZE_SET2
// Default:      4 Word Page
// Values:       4 Word Page (0), 8 Word Page (1), 16 Word Page (2), 32 Word Page 
//               (3)
// Enabled:      ENABLE_STATIC && PAGE_MODE_SET2
// 
// Specifies the page size for the Static memory device associated 
//  with register set2. The user has to manually enter this parameter, 
//  which is not automatically set, even if you use the DesignWare Memory Model 
//  This goes in as the default value for bits 25:24 of the 
//  SMTMGR_SET2 register.
`define PAGE_SIZE_SET2 0


// Name:         READY_MODE_SET2
// Default:      0 (0)
// Values:       0, 1
// Enabled:      ENABLE_STATIC
// 
// Specifies if the device associated with Register Set2 needs a ready-mode   
//  handshake or not. This feature is meant for a non-memory type device interface. 
//  In ready mode, DW_memctl takes read data after sm_ready signal goes active. 
//  During write, the write cycle ends only after the sm_ready is sampled active. 
//  0 : Enable ready-mode operation 
//  1 : Disable ready-mode operation 
//  This goes in as the default value for bit 26 of the SMTMGR_SET2 
//  register. 
//  This parameter is NOT automatically set if the user is using  
//  the DesignWare Memory Model.
`define READY_MODE_SET2 0


// Name:         LOW_FREQ_DEV_SET2
// Default:      0 (0)
// Values:       0, 1
// Enabled:      ENABLE_STATIC
// 
// This bit is valid if register set2 is used to control 
//  a synchronous memory. When interfacing to a synchronous 
//  memory, the device frequency can be a sub-multiple of the 
//  AHB frequency (1, 1/2, 1/3, 1/4, or 1/5, and so on) . 
//  This bit indicates if the device 
//  operates on a lower frequency than the AHB clock frequency.
`define LOW_FREQ_DEV_SET2 0


// Name:         SM_READ_PIPE_SET2
// Default:      0
// Values:       0 1 2 3
// Enabled:      ENABLE_STATIC
// 
// Specifies the delay in clock cycles due to register 
//  insertion on the memory read data bus, outside the MacroCell, 
//  for the Static memory associated with Register Set2. 
//  This parameter, along with read access time(T_RC) and SM_WRITE_PIPE, tells 
//  the memory controller when to expect the read data.
`define SM_READ_PIPE_SET2 0


// Name:         SM_DATA_WIDTH_SET2
// Default:      32 ( MAX_SM_DATA_WIDTH)
// Values:       8 16 32 64 128
// Enabled:      ENABLE_STATIC
// 
// This specifies the default reset value for Static memory data width. This  
//  corresponds to bits [15:13] of the SMCTLR register. For example, when designing a   
//  chip, one could select a 32-bit MAX_SM_DATA_WIDTH, but later connect only  
//  16-bit Static memory to it and program the Static memory data width to 16-bits.
`define SM_DATA_WIDTH_SET2 32

// *************************************
// * Block size parameter calculation
// *************************************

// Name:         MODEL_SIZE_CS0
// Default:      64
// Values:       -2147483648, ..., 2147483647
// 
// Models size in Kbits 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_SIZE_CS0 524288


// Name:         MODEL_DWIDTH_CS0
// Default:      16
// Values:       -2147483648, ..., 2147483647
// 
// Models data width 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_DWIDTH_CS0 32


// Name:         MODEL_SIZE_CS1
// Default:      64
// Values:       -2147483648, ..., 2147483647
// 
// Models size in Kbits 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_SIZE_CS1 64


// Name:         MODEL_DWIDTH_CS1
// Default:      16
// Values:       -2147483648, ..., 2147483647
// 
// Models data width 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_DWIDTH_CS1 16


// Name:         MODEL_SIZE_CS2
// Default:      64
// Values:       -2147483648, ..., 2147483647
// 
// Models size in Kbits 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_SIZE_CS2 64


// Name:         MODEL_DWIDTH_CS2
// Default:      16
// Values:       -2147483648, ..., 2147483647
// 
// Models data width 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_DWIDTH_CS2 16


// Name:         MODEL_SIZE_CS3
// Default:      64
// Values:       -2147483648, ..., 2147483647
// 
// Models size in Kbits 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_SIZE_CS3 64


// Name:         MODEL_DWIDTH_CS3
// Default:      16
// Values:       -2147483648, ..., 2147483647
// 
// Models data width 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_DWIDTH_CS3 16


// Name:         MODEL_SIZE_CS4
// Default:      64
// Values:       -2147483648, ..., 2147483647
// 
// Models size in Kbits 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_SIZE_CS4 64


// Name:         MODEL_DWIDTH_CS4
// Default:      16
// Values:       -2147483648, ..., 2147483647
// 
// Models data width 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_DWIDTH_CS4 16


// Name:         MODEL_SIZE_CS5
// Default:      64
// Values:       -2147483648, ..., 2147483647
// 
// Models size in Kbits 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_SIZE_CS5 64


// Name:         MODEL_DWIDTH_CS5
// Default:      16
// Values:       -2147483648, ..., 2147483647
// 
// Models data width 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_DWIDTH_CS5 16


// Name:         MODEL_SIZE_CS6
// Default:      64
// Values:       -2147483648, ..., 2147483647
// 
// Models size in Kbits 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_SIZE_CS6 64


// Name:         MODEL_DWIDTH_CS6
// Default:      16
// Values:       -2147483648, ..., 2147483647
// 
// Models data width 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_DWIDTH_CS6 16


// Name:         MODEL_SIZE_CS7
// Default:      64
// Values:       -2147483648, ..., 2147483647
// 
// Models size in Kbits 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_SIZE_CS7 64


// Name:         MODEL_DWIDTH_CS7
// Default:      16
// Values:       -2147483648, ..., 2147483647
// 
// Models data width 
//  This parameter is calculated by Memory_Models_Proc.tcl
`define MODEL_DWIDTH_CS7 16




// Name:         BLOCK_SIZE0
// Default:      64KB ([<functionof> MODEL_SIZE_CS0 MODEL_DWIDTH_CS0 
//               CHIP_SELECT0_MEM S_DATA_WIDTH REG_SELECT0 SM_DATA_WIDTH_SET0 SM_DATA_WIDTH_SET1 
//               SM_DATA_WIDTH_SET2])
// Values:       None (0), 64KB (1), 128KB (2), 256KB (3), 512KB (4), 1MB (5), 2MB 
//               (6), 4MB (7), 8MB (8), 16MB (9), 32MB (10), 64MB (11), 128MB (12), 
//               256MB (13), 512MB (14), 1GB (15), 2GB (16), 4GB (17)
// 
// The default block size for memory connected to Chip Select0.
`define BLOCK_SIZE0 12


// Name:         BLOCK_SIZE1
// Default:      64KB ([<functionof> MODEL_SIZE_CS1 MODEL_DWIDTH_CS1 
//               CHIP_SELECT1_MEM S_DATA_WIDTH REG_SELECT1 SM_DATA_WIDTH_SET0 SM_DATA_WIDTH_SET1 
//               SM_DATA_WIDTH_SET2])
// Values:       None (0), 64KB (1), 128KB (2), 256KB (3), 512KB (4), 1MB (5), 2MB 
//               (6), 4MB (7), 8MB (8), 16MB (9), 32MB (10), 64MB (11), 128MB (12), 
//               256MB (13), 512MB (14), 1GB (15), 2GB (16), 4GB (17)
// Enabled:      N_CS>1
// 
// The default block size for memory connected to Chip Select1.
`define BLOCK_SIZE1 1


// Name:         BLOCK_SIZE2
// Default:      64KB ([<functionof> MODEL_SIZE_CS2 MODEL_DWIDTH_CS2 
//               CHIP_SELECT2_MEM S_DATA_WIDTH REG_SELECT2 SM_DATA_WIDTH_SET0 SM_DATA_WIDTH_SET1 
//               SM_DATA_WIDTH_SET2])
// Values:       None (0), 64KB (1), 128KB (2), 256KB (3), 512KB (4), 1MB (5), 2MB 
//               (6), 4MB (7), 8MB (8), 16MB (9), 32MB (10), 64MB (11), 128MB (12), 
//               256MB (13), 512MB (14), 1GB (15), 2GB (16), 4GB (17)
// Enabled:      N_CS>2
// 
// The default block size for memory connected to Chip Select2.
`define BLOCK_SIZE2 1


// Name:         BLOCK_SIZE3
// Default:      64KB ([<functionof> MODEL_SIZE_CS3 MODEL_DWIDTH_CS3 
//               CHIP_SELECT3_MEM S_DATA_WIDTH REG_SELECT3 SM_DATA_WIDTH_SET0 SM_DATA_WIDTH_SET1 
//               SM_DATA_WIDTH_SET2])
// Values:       None (0), 64KB (1), 128KB (2), 256KB (3), 512KB (4), 1MB (5), 2MB 
//               (6), 4MB (7), 8MB (8), 16MB (9), 32MB (10), 64MB (11), 128MB (12), 
//               256MB (13), 512MB (14), 1GB (15), 2GB (16), 4GB (17)
// Enabled:      N_CS>3
// 
// The default block size for memory connected to Chip Select3.
`define BLOCK_SIZE3 1


// Name:         BLOCK_SIZE4
// Default:      64KB ([<functionof> MODEL_SIZE_CS4 MODEL_DWIDTH_CS4 
//               CHIP_SELECT4_MEM S_DATA_WIDTH REG_SELECT4 SM_DATA_WIDTH_SET0 SM_DATA_WIDTH_SET1 
//               SM_DATA_WIDTH_SET2])
// Values:       None (0), 64KB (1), 128KB (2), 256KB (3), 512KB (4), 1MB (5), 2MB 
//               (6), 4MB (7), 8MB (8), 16MB (9), 32MB (10), 64MB (11), 128MB (12), 
//               256MB (13), 512MB (14), 1GB (15), 2GB (16), 4GB (17)
// Enabled:      N_CS>4
// 
// The default block size for memory connected to Chip Select4.
`define BLOCK_SIZE4 1


// Name:         BLOCK_SIZE5
// Default:      64KB ([<functionof> MODEL_SIZE_CS5 MODEL_DWIDTH_CS5 
//               CHIP_SELECT5_MEM S_DATA_WIDTH REG_SELECT5 SM_DATA_WIDTH_SET0 SM_DATA_WIDTH_SET1 
//               SM_DATA_WIDTH_SET2])
// Values:       None (0), 64KB (1), 128KB (2), 256KB (3), 512KB (4), 1MB (5), 2MB 
//               (6), 4MB (7), 8MB (8), 16MB (9), 32MB (10), 64MB (11), 128MB (12), 
//               256MB (13), 512MB (14), 1GB (15), 2GB (16), 4GB (17)
// Enabled:      N_CS>5
// 
// The default block size for memory connected to Chip Select5.
`define BLOCK_SIZE5 1


// Name:         BLOCK_SIZE6
// Default:      64KB ([<functionof> MODEL_SIZE_CS6 MODEL_DWIDTH_CS6 
//               CHIP_SELECT6_MEM S_DATA_WIDTH REG_SELECT6 SM_DATA_WIDTH_SET0 SM_DATA_WIDTH_SET1 
//               SM_DATA_WIDTH_SET2])
// Values:       None (0), 64KB (1), 128KB (2), 256KB (3), 512KB (4), 1MB (5), 2MB 
//               (6), 4MB (7), 8MB (8), 16MB (9), 32MB (10), 64MB (11), 128MB (12), 
//               256MB (13), 512MB (14), 1GB (15), 2GB (16), 4GB (17)
// Enabled:      N_CS>6
// 
// The default block size for memory connected to Chip Select6.
`define BLOCK_SIZE6 1


// Name:         BLOCK_SIZE7
// Default:      64KB ([<functionof> MODEL_SIZE_CS7 MODEL_DWIDTH_CS7 
//               CHIP_SELECT7_MEM S_DATA_WIDTH REG_SELECT7 SM_DATA_WIDTH_SET0 SM_DATA_WIDTH_SET1 
//               SM_DATA_WIDTH_SET2])
// Values:       None (0), 64KB (1), 128KB (2), 256KB (3), 512KB (4), 1MB (5), 2MB 
//               (6), 4MB (7), 8MB (8), 16MB (9), 32MB (10), 64MB (11), 128MB (12), 
//               256MB (13), 512MB (14), 1GB (15), 2GB (16), 4GB (17)
// Enabled:      N_CS>7
// 
// The default block size for memory connected to Chip Select7.
`define BLOCK_SIZE7 1

//********************************************************************
//*
//* Derived Parameters
//*
//********************************************************************


`define M_DATA_WIDTH 16


`define M_ADDR_WIDTH 16

`define HADDR_SIZE32

`define S_RD_DATA_WIDTH 32

`define DDR_SDRAM
`define USE_SIDEBAND_SAMPLE 0


`define INCLUDE_INTERNAL_TESTS 0


// Name:         ENCODED_S_COL_ADDR_WIDTH_1
// Default:      0x8 ([<functionof> S_COL_ADDR_WIDTH])
// Values:       0x0, ..., 0xf
// 
// Encoded S_COL_ADDR_WIDTH-1
`define ENCODED_S_COL_ADDR_WIDTH_1 4'h8


// Name:         ENCODED_S_ROW_ADDR_WIDTH_1
// Default:      0xc ([<functionof> S_ROW_ADDR_WIDTH])
// Values:       0x0, ..., 0xf
// 
// Encoded S_ROW_ADDR_WIDTH-1
`define ENCODED_S_ROW_ADDR_WIDTH_1 4'hc


// Name:         ENCODED_S_BANK_ADDR_WIDTH_1
// Default:      0x1 ([<functionof> S_BANK_ADDR_WIDTH])
// Values:       0x0, ..., 0x3
// 
// Encoded S_BANK_ADDR_WIDTH-1
`define ENCODED_S_BANK_ADDR_WIDTH_1 2'h1


// Name:         ENCODED_S_DATA_WIDTH
// Default:      0x0 ([ <functionof> DYNAMIC_RAM_TYPE S_DATA_WIDTH ])
// Values:       0x0, ..., 0x3
// 
// Encoded S_DATA_WIDTH
`define ENCODED_S_DATA_WIDTH 2'h0


// Name:         ENCODED_T_RC_1
// Default:      0x9 ([<functionof> T_RC])
// Values:       0x0, ..., 0xf
// 
// Encoded T_RC - 1
`define ENCODED_T_RC_1 4'h9


// Name:         ENCODED_EXT_T_XSR_1
// Default:      0x0 ([<functionof> T_XSR 1])
// Values:       0x0, ..., 0x1f
// 
// Encoded EXT_T_XSR - 1
`define ENCODED_EXT_T_XSR_1 5'h0


// Name:         ENCODED_LOW_T_XSR_1
// Default:      0xf ([<functionof> T_XSR 0])
// Values:       0x0, ..., 0xf
// 
// Encoded LOW_T_XSR - 1
`define ENCODED_LOW_T_XSR_1 4'hf


// Name:         ENCODED_T_XSR_1
// Default:      0xf ([<functionof> T_XSR])
// Values:       0x0, ..., 0x1ff
// 
// Encoded T_XSR - 1
`define ENCODED_T_XSR_1 9'hf


// Name:         ENCODED_T_RCAR_1
// Default:      0x9 ([<functionof> T_RCAR])
// Values:       0x0, ..., 0xf
// 
// Encoded T_RCAR - 1
`define ENCODED_T_RCAR_1 4'h9


// Name:         ENCODED_T_WR_1
// Default:      0x1 ([<functionof> T_WR])
// Values:       0x0, ..., 0x3
// 
// Encoded T_WR - 1
`define ENCODED_T_WR_1 2'h1


// Name:         ENCODED_T_RP_1
// Default:      0x3 ([<functionof> T_RP])
// Values:       0x0, ..., 0x7
// 
// Encoded T_RP - 1
`define ENCODED_T_RP_1 3'h3


// Name:         ENCODED_T_RCD_1
// Default:      0x2 ([<functionof> T_RCD])
// Values:       0x0, ..., 0x7
// 
// Encoded T_RCD - 1
`define ENCODED_T_RCD_1 3'h2


// Name:         ENCODED_T_RAS_MIN_1
// Default:      0x5 ([<functionof> T_RAS_MIN])
// Values:       0x0, ..., 0xf
// 
// Encoded T_RAS_MIN - 1
`define ENCODED_T_RAS_MIN_1 4'h5


// Name:         ENCODED_EXT_CAS_LATENCY_1
// Default:      0x0 ([<functionof> CAS_LATENCY 1])
// Values:       0x0, 0x1
// 
// Encoded EXT_CAS_LATENCY - 1
`define ENCODED_EXT_CAS_LATENCY_1 1'h0


// Name:         ENCODED_LOW_CAS_LATENCY_1
// Default:      0x2 ([<functionof> CAS_LATENCY 0])
// Values:       0x0, ..., 0x3
// 
// Encoded LOW_CAS_LATENCY - 1
`define ENCODED_LOW_CAS_LATENCY_1 2'h2


// Name:         ENCODED_CAS_LATENCY_1
// Default:      0x2 ([<functionof> CAS_LATENCY])
// Values:       0x0, ..., 0x7
// 
// Encoded CAS_LATENCY - 1
`define ENCODED_CAS_LATENCY_1 3'h2


// Name:         ENCODED_T_WTR_1
// Default:      0x0 ([<functionof> T_WTR])
// Values:       0x0, ..., 0x3
// 
// Encoded T_WTR - 1
`define ENCODED_T_WTR_1 2'h0


// Name:         ENCODED_NUM_INIT_REF_1
// Default:      0x7 ([<functionof> NUM_INIT_REF])
// Values:       0x0, ..., 0xf
// 
// Encoded NUM_INIT_REF - 1
`define ENCODED_NUM_INIT_REF_1 4'h7


// Name:         ENCODED_T_INIT
// Default:      0x8 (T_INIT)
// Values:       0x0, ..., 0xffff
// 
// Encoded T_INIT
`define ENCODED_T_INIT 16'h8


// Name:         ENCODED_S_READY_VALID
// Default:      0x0 (S_READY_VALID)
// Values:       0x0, 0x1
// 
// Encoded S_READY_VALID
`define ENCODED_S_READY_VALID 1'h0


// Name:         ENCODED_OPEN_BANKS_1
// Default:      0x3 ([<functionof> OPEN_BANKS])
// Values:       0x0, ..., 0x1f
// 
// Encoded OPEN_BANKS - 1
`define ENCODED_OPEN_BANKS_1 5'h3


// Name:         ENCODED_READ_PIPE
// Default:      0x2 (READ_PIPE)
// Values:       0x0, ..., 0x7
// 
// Encoded READ_PIPE
`define ENCODED_READ_PIPE 3'h2


// Name:         ENCODED_T_REF
// Default:      0x410 (T_REF)
// Values:       0x0, ..., 0xffff
// 
// Encoded T_REF
`define ENCODED_T_REF 16'h410


// Name:         ENCODED_REG_SELECT0
// Default:      0x2 (REG_SELECT0)
// Values:       0x0, ..., 0x7
// 
// Encoded REG_SELECT0
`define ENCODED_REG_SELECT0 3'h2


// Name:         ENCODED_CHIP_SELECT0_MEM
// Default:      0x0 (CHIP_SELECT0_MEM)
// Values:       0x0, ..., 0x7
// 
// Encoded CHIP_SELECT0_MEM
`define ENCODED_CHIP_SELECT0_MEM 3'h0


// Name:         ENCODED_BLOCK_SIZE0
// Default:      0xc (BLOCK_SIZE0)
// Values:       0x0, ..., 0x1f
// 
// Encoded BLOCK_SIZE0
`define ENCODED_BLOCK_SIZE0 5'hc


// Name:         ENCODED_REG_SELECT1
// Default:      0x2 (REG_SELECT1)
// Values:       0x0, ..., 0x7
// 
// Encoded REG_SELECT1
`define ENCODED_REG_SELECT1 3'h2


// Name:         ENCODED_CHIP_SELECT1_MEM
// Default:      0x0 (CHIP_SELECT1_MEM)
// Values:       0x0, ..., 0x7
// 
// Encoded CHIP_SELECT1_MEM
`define ENCODED_CHIP_SELECT1_MEM 3'h0


// Name:         ENCODED_BLOCK_SIZE1
// Default:      0x1 (BLOCK_SIZE1)
// Values:       0x0, ..., 0x1f
// 
// Encoded BLOCK_SIZE1
`define ENCODED_BLOCK_SIZE1 5'h1


// Name:         ENCODED_REG_SELECT2
// Default:      0x0 (REG_SELECT2)
// Values:       0x0, ..., 0x7
// 
// Encoded REG_SELECT2
`define ENCODED_REG_SELECT2 3'h0


// Name:         ENCODED_CHIP_SELECT2_MEM
// Default:      0x1 (CHIP_SELECT2_MEM)
// Values:       0x0, ..., 0x7
// 
// Encoded CHIP_SELECT2_MEM
`define ENCODED_CHIP_SELECT2_MEM 3'h1


// Name:         ENCODED_BLOCK_SIZE2
// Default:      0x1 (BLOCK_SIZE2)
// Values:       0x0, ..., 0x1f
// 
// Encoded BLOCK_SIZE2
`define ENCODED_BLOCK_SIZE2 5'h1


// Name:         ENCODED_REG_SELECT3
// Default:      0x1 (REG_SELECT3)
// Values:       0x0, ..., 0x7
// 
// Encoded REG_SELECT3
`define ENCODED_REG_SELECT3 3'h1


// Name:         ENCODED_CHIP_SELECT3_MEM
// Default:      0x2 (CHIP_SELECT3_MEM)
// Values:       0x0, ..., 0x7
// 
// Encoded CHIP_SELECT3_MEM
`define ENCODED_CHIP_SELECT3_MEM 3'h2


// Name:         ENCODED_BLOCK_SIZE3
// Default:      0x1 (BLOCK_SIZE3)
// Values:       0x0, ..., 0x1f
// 
// Encoded BLOCK_SIZE3
`define ENCODED_BLOCK_SIZE3 5'h1


// Name:         ENCODED_REG_SELECT4
// Default:      0x2 (REG_SELECT4)
// Values:       0x0, ..., 0x7
// 
// Encoded REG_SELECT4
`define ENCODED_REG_SELECT4 3'h2


// Name:         ENCODED_CHIP_SELECT4_MEM
// Default:      0x3 (CHIP_SELECT4_MEM)
// Values:       0x0, ..., 0x7
// 
// Encoded CHIP_SELECT4_MEM
`define ENCODED_CHIP_SELECT4_MEM 3'h3


// Name:         ENCODED_BLOCK_SIZE4
// Default:      0x1 (BLOCK_SIZE4)
// Values:       0x0, ..., 0x1f
// 
// Encoded BLOCK_SIZE4
`define ENCODED_BLOCK_SIZE4 5'h1


// Name:         ENCODED_REG_SELECT5
// Default:      0x1 (REG_SELECT5)
// Values:       0x0, ..., 0x7
// 
// Encoded REG_SELECT5
`define ENCODED_REG_SELECT5 3'h1


// Name:         ENCODED_CHIP_SELECT5_MEM
// Default:      0x0 (CHIP_SELECT5_MEM)
// Values:       0x0, ..., 0x7
// 
// Encoded CHIP_SELECT5_MEM
`define ENCODED_CHIP_SELECT5_MEM 3'h0


// Name:         ENCODED_BLOCK_SIZE5
// Default:      0x1 (BLOCK_SIZE5)
// Values:       0x0, ..., 0x1f
// 
// Encoded BLOCK_SIZE5
`define ENCODED_BLOCK_SIZE5 5'h1


// Name:         ENCODED_REG_SELECT6
// Default:      0x1 (REG_SELECT6)
// Values:       0x0, ..., 0x7
// 
// Encoded REG_SELECT6
`define ENCODED_REG_SELECT6 3'h1


// Name:         ENCODED_CHIP_SELECT6_MEM
// Default:      0x0 (CHIP_SELECT6_MEM)
// Values:       0x0, ..., 0x7
// 
// Encoded CHIP_SELECT6_MEM
`define ENCODED_CHIP_SELECT6_MEM 3'h0


// Name:         ENCODED_BLOCK_SIZE6
// Default:      0x1 (BLOCK_SIZE6)
// Values:       0x0, ..., 0x1f
// 
// Encoded BLOCK_SIZE6
`define ENCODED_BLOCK_SIZE6 5'h1


// Name:         ENCODED_REG_SELECT7
// Default:      0x1 (REG_SELECT7)
// Values:       0x0, ..., 0x7
// 
// Encoded REG_SELECT7
`define ENCODED_REG_SELECT7 3'h1


// Name:         ENCODED_CHIP_SELECT7_MEM
// Default:      0x0 (CHIP_SELECT7_MEM)
// Values:       0x0, ..., 0x7
// 
// Encoded CHIP_SELECT7_MEM
`define ENCODED_CHIP_SELECT7_MEM 3'h0


// Name:         ENCODED_BLOCK_SIZE7
// Default:      0x1 (BLOCK_SIZE7)
// Values:       0x0, ..., 0x1f
// 
// Encoded BLOCK_SIZE7
`define ENCODED_BLOCK_SIZE7 5'h1


// Name:         ENCODED_SM_READ_PIPE_SET0
// Default:      0x0 (SM_READ_PIPE_SET0)
// Values:       0x0, ..., 0x3
// 
// Encoded SM_READ_PIPE_SET0
`define ENCODED_SM_READ_PIPE_SET0 2'h0


// Name:         ENCODED_LOW_FREQ_DEV_SET0
// Default:      0x0 (LOW_FREQ_DEV_SET0)
// Values:       0x0, 0x1
// 
// Encoded LOW_FREQ_DEV_SET0
`define ENCODED_LOW_FREQ_DEV_SET0 1'h0


// Name:         ENCODED_READY_MODE_SET0
// Default:      0x0 (READY_MODE_SET0)
// Values:       0x0, 0x1
// 
// Encoded READY_MODE_SET0
`define ENCODED_READY_MODE_SET0 1'h0


// Name:         ENCODED_PAGE_SIZE_SET0
// Default:      0x0 (PAGE_SIZE_SET0)
// Values:       0x0, ..., 0x3
// 
// Encoded PAGE_SIZE_SET0
`define ENCODED_PAGE_SIZE_SET0 2'h0


// Name:         ENCODED_PAGE_MODE_SET0
// Default:      0x0 (PAGE_MODE_SET0)
// Values:       0x0, 0x1
// 
// Encoded PAGE_MODE_SET_SET0
`define ENCODED_PAGE_MODE_SET0 1'h0


// Name:         ENCODED_T_PRC_SET0_1
// Default:      0x0 ([<functionof> T_PRC_SET0])
// Values:       0x0, ..., 0xf
// 
// Encoded T_PRC_SET0 - 1
`define ENCODED_T_PRC_SET0_1 4'h0


// Name:         ENCODED_T_BTA_SET0
// Default:      0x1 (T_BTA_SET0)
// Values:       0x0, ..., 0x7
// 
// Encoded T_BTA_SET0
`define ENCODED_T_BTA_SET0 3'h1


// Name:         ENCODED_T_WP_SET0_1
// Default:      0x1 ([<functionof> T_WP_SET0])
// Values:       0x0, ..., 0x3f
// 
// Encoded T_WP_SET0 - 1
`define ENCODED_T_WP_SET0_1 6'h1


// Name:         ENCODED_T_WR_SET0
// Default:      0x0 (T_WR_SET0)
// Values:       0x0, ..., 0x3
// 
// Encoded T_WR_SET0
`define ENCODED_T_WR_SET0 2'h0


// Name:         ENCODED_T_AS_SET0
// Default:      0x1 (T_AS_SET0)
// Values:       0x0, ..., 0x3
// 
// Encoded T_AS_SET0
`define ENCODED_T_AS_SET0 2'h1


// Name:         ENCODED_T_RC_SET0_1
// Default:      0x1 ([<functionof> T_RC_SET0])
// Values:       0x0, ..., 0x3f
// 
// Encoded T_RC_SET0 - 1
`define ENCODED_T_RC_SET0_1 6'h1


// Name:         ENCODED_SM_READ_PIPE_SET1
// Default:      0x0 (SM_READ_PIPE_SET1)
// Values:       0x0, ..., 0x3
// 
// Encoded SM_READ_PIPE_SET1
`define ENCODED_SM_READ_PIPE_SET1 2'h0


// Name:         ENCODED_LOW_FREQ_DEV_SET1
// Default:      0x0 (LOW_FREQ_DEV_SET1)
// Values:       0x0, 0x1
// 
// Encoded LOW_FREQ_DEV_SET1
`define ENCODED_LOW_FREQ_DEV_SET1 1'h0


// Name:         ENCODED_READY_MODE_SET1
// Default:      0x0 (READY_MODE_SET1)
// Values:       0x0, 0x1
// 
// Encoded READY_MODE_SET1
`define ENCODED_READY_MODE_SET1 1'h0


// Name:         ENCODED_PAGE_SIZE_SET1
// Default:      0x0 (PAGE_SIZE_SET1)
// Values:       0x0, ..., 0x3
// 
// Encoded PAGE_SIZE_SET1
`define ENCODED_PAGE_SIZE_SET1 2'h0


// Name:         ENCODED_PAGE_MODE_SET1
// Default:      0x0 (PAGE_MODE_SET1)
// Values:       0x0, 0x1
// 
// Encoded PAGE_MODE_SET_SET1
`define ENCODED_PAGE_MODE_SET1 1'h0


// Name:         ENCODED_T_PRC_SET1_1
// Default:      0xf ([<functionof> T_PRC_SET1])
// Values:       0x0, ..., 0xf
// 
// Encoded T_PRC_SET1 - 1
`define ENCODED_T_PRC_SET1_1 4'hf


// Name:         ENCODED_T_BTA_SET1
// Default:      0x4 (T_BTA_SET1)
// Values:       0x0, ..., 0x7
// 
// Encoded T_BTA_SET1
`define ENCODED_T_BTA_SET1 3'h4


// Name:         ENCODED_T_WP_SET1_1
// Default:      0x13 ([<functionof> T_WP_SET1])
// Values:       0x0, ..., 0x3f
// 
// Encoded T_WP_SET1 - 1
`define ENCODED_T_WP_SET1_1 6'h13


// Name:         ENCODED_T_WR_SET1
// Default:      0x3 (T_WR_SET1)
// Values:       0x0, ..., 0x3
// 
// Encoded T_WR_SET1
`define ENCODED_T_WR_SET1 2'h3


// Name:         ENCODED_T_AS_SET1
// Default:      0x1 (T_AS_SET1)
// Values:       0x0, ..., 0x3
// 
// Encoded T_AS_SET1
`define ENCODED_T_AS_SET1 2'h1


// Name:         ENCODED_T_RC_SET1_1
// Default:      0x1b ([<functionof> T_RC_SET1])
// Values:       0x0, ..., 0x3f
// 
// Encoded T_RC_SET1 - 1
`define ENCODED_T_RC_SET1_1 6'h1b


// Name:         ENCODED_SM_READ_PIPE_SET2
// Default:      0x0 (SM_READ_PIPE_SET2)
// Values:       0x0, ..., 0x3
// 
// Encoded SM_READ_PIPE_SET2
`define ENCODED_SM_READ_PIPE_SET2 2'h0


// Name:         ENCODED_LOW_FREQ_DEV_SET2
// Default:      0x0 (LOW_FREQ_DEV_SET2)
// Values:       0x0, 0x1
// 
// Encoded LOW_FREQ_DEV_SET2
`define ENCODED_LOW_FREQ_DEV_SET2 1'h0


// Name:         ENCODED_READY_MODE_SET2
// Default:      0x0 (READY_MODE_SET2)
// Values:       0x0, 0x1
// 
// Encoded READY_MODE_SET2
`define ENCODED_READY_MODE_SET2 1'h0


// Name:         ENCODED_PAGE_SIZE_SET2
// Default:      0x0 (PAGE_SIZE_SET2)
// Values:       0x0, ..., 0x3
// 
// Encoded PAGE_SIZE_SET2
`define ENCODED_PAGE_SIZE_SET2 2'h0


// Name:         ENCODED_PAGE_MODE_SET2
// Default:      0x0 (PAGE_MODE_SET2)
// Values:       0x0, 0x1
// 
// Encoded PAGE_MODE_SET_SET2
`define ENCODED_PAGE_MODE_SET2 1'h0


// Name:         ENCODED_T_PRC_SET2_1
// Default:      0x3 ([<functionof> T_PRC_SET2])
// Values:       0x0, ..., 0xf
// 
// Encoded T_PRC_SET2 - 1
`define ENCODED_T_PRC_SET2_1 4'h3


// Name:         ENCODED_T_BTA_SET2
// Default:      0x4 (T_BTA_SET2)
// Values:       0x0, ..., 0x7
// 
// Encoded T_BTA_SET2
`define ENCODED_T_BTA_SET2 3'h4


// Name:         ENCODED_T_WP_SET2_1
// Default:      0x13 ([<functionof> T_WP_SET2])
// Values:       0x0, ..., 0x3f
// 
// Encoded T_WP_SET2 - 1
`define ENCODED_T_WP_SET2_1 6'h13


// Name:         ENCODED_T_WR_SET2
// Default:      0x3 (T_WR_SET2)
// Values:       0x0, ..., 0x3
// 
// Encoded T_WR_SET2
`define ENCODED_T_WR_SET2 2'h3


// Name:         ENCODED_T_AS_SET2
// Default:      0x1 (T_AS_SET2)
// Values:       0x0, ..., 0x3
// 
// Encoded T_AS_SET2
`define ENCODED_T_AS_SET2 2'h1


// Name:         ENCODED_T_RC_SET2_1
// Default:      0x1b ([<functionof> T_RC_SET2])
// Values:       0x0, ..., 0x3f
// 
// Encoded T_RC_SET2 - 1
`define ENCODED_T_RC_SET2_1 6'h1b


// Name:         ENCODED_T_RPD
// Default:      0xc8 (T_RPD)
// Values:       0x0, ..., 0xfff
// 
// Encoded T_RPD
`define ENCODED_T_RPD 12'hc8


// Name:         ENCODED_SM_DATA_WIDTH_SET2
// Default:      0x1 ([<functionof> SM_DATA_WIDTH_SET2])
// Values:       0x0, ..., 0x7
// 
// Encoded SM_DATA_WIDTH_SET2
`define ENCODED_SM_DATA_WIDTH_SET2 3'h1


// Name:         ENCODED_SM_DATA_WIDTH_SET1
// Default:      0x1 ([<functionof> SM_DATA_WIDTH_SET1])
// Values:       0x0, ..., 0x7
// 
// Encoded SM_DATA_WIDTH_SET1
`define ENCODED_SM_DATA_WIDTH_SET1 3'h1


// Name:         ENCODED_SM_DATA_WIDTH_SET0
// Default:      0x1 ([<functionof> SM_DATA_WIDTH_SET0])
// Values:       0x0, ..., 0x7
// 
// Encoded SM_DATA_WIDTH_SET0
`define ENCODED_SM_DATA_WIDTH_SET0 3'h1

// -----------------------------------------------------------
// -- Register reset value  macros
// -----------------------------------------------------------


// Name:         SCONR_IN
// Default:      0xe1188 ([<functionof> {{0b1} {0b1} {0b1} {0b00} {2 
//               ENCODED_S_DATA_WIDTH} {4 ENCODED_S_COL_ADDR_WIDTH_1} {4 ENCODED_S_ROW_ADDR_WIDTH_1} 
//               {2 ENCODED_S_BANK_ADDR_WIDTH_1} {0b000} }])
// Values:       0x0, ..., 0xfffff
// 
// SCONR register reset value
`define SCONR_IN 20'he1188


// Name:         STMG0R_IN
// Default:      0x27e5696 ([<functionof> {{5 ENCODED_EXT_T_XSR_1} {1 
//               ENCODED_EXT_CAS_LATENCY_1} {4 ENCODED_T_RC_1} {4 ENCODED_LOW_T_XSR_1} {4 
//               ENCODED_T_RCAR_1} {2 ENCODED_T_WR_1} {3 ENCODED_T_RP_1} {3 ENCODED_T_RCD_1} {4 
//               ENCODED_T_RAS_MIN_1} {2 ENCODED_LOW_CAS_LATENCY_1} }])
// Values:       0x0, ..., 0xffffffff
// 
// STMG0R register reset value
`define STMG0R_IN 32'h27e5696


// Name:         STMG1R_IN
// Default:      0x70008 ([<functionof> {{2 ENCODED_T_WTR_1} {4 
//               ENCODED_NUM_INIT_REF_1} {16 ENCODED_T_INIT} }])
// Values:       0x0, ..., 0x3fffff
// 
// STMG1R register reset value
`define STMG1R_IN 22'h70008


// Name:         SCTLR_IN
// Default:      0x3089 ([<functionof> {{0b0} {0b0} {0b0} {1 ENCODED_S_READY_VALID} 
//               {5 ENCODED_OPEN_BANKS_1} {0b0} {0b0} {0b0} {3 ENCODED_READ_PIPE} 
//               {0b0} {0b0} {0b1} {0b0} {0b0} {0b1} }])
// Values:       0x0, ..., 0x1fffff
// 
// SCTLR register reset value
`define SCTLR_IN 21'h3089


// Name:         SREFR_IN
// Default:      0x410 ([<functionof> {{0x0} {16 T_REF} }])
// Values:       0x0, ..., 0xffffff
// 
// SREFR register reset value
`define SREFR_IN 24'h410


// Name:         SMSKR0_IN
// Default:      0x20c ([<functionof> {{3 ENCODED_REG_SELECT0} {3 
//               ENCODED_CHIP_SELECT0_MEM} {5 ENCODED_BLOCK_SIZE0} }])
// Values:       0x0, ..., 0x7ff
// 
// SMSKR0 register reset value
`define SMSKR0_IN 11'h20c


// Name:         SMSKR1_IN
// Default:      0x201 ([<functionof> {{3 ENCODED_REG_SELECT1} {3 
//               ENCODED_CHIP_SELECT1_MEM} {5 ENCODED_BLOCK_SIZE1} }])
// Values:       0x0, ..., 0x7ff
// 
// SMSKR1 register reset value
`define SMSKR1_IN 11'h201


// Name:         SMSKR2_IN
// Default:      0x21 ([<functionof> {{3 ENCODED_REG_SELECT2} {3 
//               ENCODED_CHIP_SELECT2_MEM} {5 ENCODED_BLOCK_SIZE2} }])
// Values:       0x0, ..., 0x7ff
// 
// SMSKR2 register reset value
`define SMSKR2_IN 11'h21


// Name:         SMSKR3_IN
// Default:      0x141 ([<functionof> {{3 ENCODED_REG_SELECT3} {3 
//               ENCODED_CHIP_SELECT3_MEM} {5 ENCODED_BLOCK_SIZE3} }])
// Values:       0x0, ..., 0x7ff
// 
// SMSKR3 register reset value
`define SMSKR3_IN 11'h141


// Name:         SMSKR4_IN
// Default:      0x261 ([<functionof> {{3 ENCODED_REG_SELECT4} {3 
//               ENCODED_CHIP_SELECT4_MEM} {5 ENCODED_BLOCK_SIZE4} }])
// Values:       0x0, ..., 0x7ff
// 
// SMSKR4 register reset value
`define SMSKR4_IN 11'h261


// Name:         SMSKR5_IN
// Default:      0x101 ([<functionof> {{3 ENCODED_REG_SELECT5} {3 
//               ENCODED_CHIP_SELECT5_MEM} {5 ENCODED_BLOCK_SIZE5} }])
// Values:       0x0, ..., 0x7ff
// 
// SMSKR5 register reset value
`define SMSKR5_IN 11'h101


// Name:         SMSKR6_IN
// Default:      0x101 ([<functionof> {{3 ENCODED_REG_SELECT6} {3 
//               ENCODED_CHIP_SELECT6_MEM} {5 ENCODED_BLOCK_SIZE6} }])
// Values:       0x0, ..., 0x7ff
// 
// SMSKR6 register reset value
`define SMSKR6_IN 11'h101


// Name:         SMSKR7_IN
// Default:      0x101 ([<functionof> {{3 ENCODED_REG_SELECT7} {3 
//               ENCODED_CHIP_SELECT7_MEM} {5 ENCODED_BLOCK_SIZE7} }])
// Values:       0x0, ..., 0x7ff
// 
// SMSKR7 register reset value
`define SMSKR7_IN 11'h101


// Name:         SMTMGR_SET0_IN
// Default:      0x10441 ([<functionof> {{2 ENCODED_SM_READ_PIPE_SET0} {1 
//               ENCODED_LOW_FREQ_DEV_SET0} {1 ENCODED_READY_MODE_SET0} {2 
//               ENCODED_PAGE_SIZE_SET0} {1 ENCODED_PAGE_MODE_SET0} {4 ENCODED_T_PRC_SET0_1} {3 
//               ENCODED_T_BTA_SET0} {6 ENCODED_T_WP_SET0_1} {2 ENCODED_T_WR_SET0} {2 
//               ENCODED_T_AS_SET0} {6 ENCODED_T_RC_SET0_1} }])
// Values:       0x0, ..., 0x3fffffff
// 
// SMTMGR_SET0 register reset value
`define SMTMGR_SET0_IN 30'h10441


// Name:         SMTMGR_SET1_IN
// Default:      0x7c4f5b ([<functionof> {{2 ENCODED_SM_READ_PIPE_SET1} {1 
//               ENCODED_LOW_FREQ_DEV_SET1} {1 ENCODED_READY_MODE_SET1} {2 
//               ENCODED_PAGE_SIZE_SET1} {1 ENCODED_PAGE_MODE_SET1} {4 ENCODED_T_PRC_SET1_1} {3 
//               ENCODED_T_BTA_SET1} {6 ENCODED_T_WP_SET1_1} {2 ENCODED_T_WR_SET1} {2 
//               ENCODED_T_AS_SET1} {6 ENCODED_T_RC_SET1_1} }])
// Values:       0x0, ..., 0x3fffffff
// 
// SMTMGR_SET1 register reset value
`define SMTMGR_SET1_IN 30'h7c4f5b


// Name:         SMTMGR_SET2_IN
// Default:      0x1c4f5b ([<functionof> {{2 ENCODED_SM_READ_PIPE_SET2} {1 
//               ENCODED_LOW_FREQ_DEV_SET2} {1 ENCODED_READY_MODE_SET2} {2 
//               ENCODED_PAGE_SIZE_SET2} {1 ENCODED_PAGE_MODE_SET2} {4 ENCODED_T_PRC_SET2_1} {3 
//               ENCODED_T_BTA_SET2} {6 ENCODED_T_WP_SET2_1} {2 ENCODED_T_WR_SET2} {2 
//               ENCODED_T_AS_SET2} {6 ENCODED_T_RC_SET2_1} }])
// Values:       0x0, ..., 0x3fffffff
// 
// SMTMGR_SET2 register reset value
`define SMTMGR_SET2_IN 30'h1c4f5b


// Name:         SMCTLR_IN
// Default:      0x2481 ([<functionof> {{3 ENCODED_SM_DATA_WIDTH_SET2} {3 
//               ENCODED_SM_DATA_WIDTH_SET1} {3 ENCODED_SM_DATA_WIDTH_SET0} {0b000} {0b000} 
//               {0b1} }])
// Values:       0x0, ..., 0xffff
// 
// SMCTLR register reset value
`define SMCTLR_IN 16'h2481


// Name:         MEMCTL_COMP_VERSION
// Default:      0x3237392a
// Values:       0x0, ..., 0xffffffff
// 
// Each corekit has a component version. 
//  This is reflected in the ASCII version number which needs to get translated. 
//  0 => 0x30    6 => 0x36  
//  1 => 0x31    7 => 0x37 
//  2 => 0x32    8 => 0x38 
//  3 => 0x33    9 => 0x39 
//  4 => 0x34 
//  5 => 0x35    * => 0x2A 
//  Current Version is 2.79* => 32_37_39_2A
`define MEMCTL_COMP_VERSION 32'h3237392a


// Name:         MEMCTL_COMP_TYPE
// Default:      0x44572110
// Values:       0x0, ..., 0xffffffff
// 
// Component identifier 
//  This is reflected in the ASCII version number which needs to get translated. 
//  Comprised of two ASCII letters "DW", and a unique 16-bit unsigned number
`define MEMCTL_COMP_TYPE 32'h44572110


// Name:         VER__1_2A_COMPATIABLE_MODE_RST
// Default:      0x0 (VER_1_2A_COMPATIABLE_MODE)
// Values:       0x0, 0x1
// 
// Reset value for VER_1_2A_COMPATIABLE_MODE parameter
`define VER__1_2A_COMPATIABLE_MODE_RST 1'h0


// Name:         DYNAMIC__RAM_TYPE_RST
// Default:      0x1 (DYNAMIC_RAM_TYPE)
// Values:       0x0, ..., 0x7
// 
// Reset value for DYNAMIC_RAM_TYPE parameter
`define DYNAMIC__RAM_TYPE_RST 3'h1


// Name:         USE__MOBILE_DDR_RST
// Default:      0x1 (USE_MOBILE_DDR)
// Values:       0x0, 0x1
// 
// Reset value for USE_MOBILE_DDR parameter
`define USE__MOBILE_DDR_RST 1'h1


// Name:         ENABLE__STATIC_RST
// Default:      0x0 (ENABLE_STATIC)
// Values:       0x0, 0x1
// 
// Reset value for ENABLE_STATIC parameter
`define ENABLE__STATIC_RST 1'h0


// Name:         HARD__WIRE_SDRAM_PARAMETERS_RST
// Default:      0x0 (HARD_WIRE_SDRAM_PARAMETERS)
// Values:       0x0, 0x1
// 
// Reset value for HARD_WIRE_SDRAM_PARAMETERS parameter
`define HARD__WIRE_SDRAM_PARAMETERS_RST 1'h0


// Name:         HARD__WIRE_SYNCFLASH_PARAMETERS_RST
// Default:      0x0 (HARD_WIRE_SYNCFLASH_PARAMETERS)
// Values:       0x0, 0x1
// 
// Reset value for HARD_WIRE_SYNCFLASH_PARAMETERS parameter
`define HARD__WIRE_SYNCFLASH_PARAMETERS_RST 1'h0


// Name:         HARD__WIRE_STATIC_PARAMETERS_RST
// Default:      0x0 (HARD_WIRE_STATIC_PARAMETERS)
// Values:       0x0, 0x1
// 
// Reset value for HARD_WIRE_STATIC_PARAMETERS parameter
`define HARD__WIRE_STATIC_PARAMETERS_RST 1'h0


// Name:         HARD__WIRE_CIPSELECT_PARAMETRS_RST
// Default:      0x0 (HARD_WIRE_CIPSELECT_PARAMETRS)
// Values:       0x0, 0x1
// 
// Reset value for HARD_WIRE_CIPSELECT_PARAMETRS parameter
`define HARD__WIRE_CIPSELECT_PARAMETRS_RST 1'h0


// Name:         CHIP__SEL0_REMAP_ENABLE_RST
// Default:      0x0 (CHIP_SEL0_REMAP_ENABLE)
// Values:       0x0, 0x1
// 
// Reset value for CHIP_SEL0_REMAP_ENABLE parameter
`define CHIP__SEL0_REMAP_ENABLE_RST 1'h0


// Name:         CHIP__SEL0_ALIAS_ENABLE_RST
// Default:      0x0 (CHIP_SEL0_ALIAS_ENABLE)
// Values:       0x0, 0x1
// 
// Reset value for CHIP_SEL0_ALIAS_ENABLE parameter
`define CHIP__SEL0_ALIAS_ENABLE_RST 1'h0


// Name:         CHIP__SEL1_REMAP_ENABLE_RST
// Default:      0x0 (CHIP_SEL1_REMAP_ENABLE)
// Values:       0x0, 0x1
// 
// Reset value for CHIP_SEL1_REMAP_ENABLE parameter
`define CHIP__SEL1_REMAP_ENABLE_RST 1'h0


// Name:         CHIP__SEL1_ALIAS_ENABLE_RST
// Default:      0x0 (CHIP_SEL1_ALIAS_ENABLE)
// Values:       0x0, 0x1
// 
// Reset value for CHIP_SEL1_ALIAS_ENABLE parameter
`define CHIP__SEL1_ALIAS_ENABLE_RST 1'h0


// Name:         N__CS_RST
// Default:      0x0 (N_CS-1)
// Values:       0x0, ..., 0x7
// 
// Reset value for N_CS parameter
`define N__CS_RST 3'h0


// Name:         H__ADDR_WIDTH_RST
// Default:      0x0 ((H_ADDR_WIDTH == 64) ? 1 : 0)
// Values:       0x0, 0x1
// 
// Reset value for H_ADDR_WIDTH parameter
`define H__ADDR_WIDTH_RST 1'h0


// Name:         H__DATA_WIDTH_RST
// Default:      0x0 ((H_DATA_WIDTH == 128) ? 2 : (H_DATA_WIDTH == 64) ? 1 :0)
// Values:       0x0, ..., 0x3
// 
// Reset value for H_DATA_WIDTH parameter
`define H__DATA_WIDTH_RST 2'h0


// Name:         MAX__SM_DATA_WIDTH_RST
// Default:      0x2 ((MAX_SM_DATA_WIDTH == 128) ? 4 : (MAX_SM_DATA_WIDTH == 64) ? 3 
//               : (MAX_SM_DATA_WIDTH == 32) ? 2 : (MAX_SM_DATA_WIDTH == 16) ? 1 : 0)
// Values:       0x0, ..., 0x7
// 
// Reset value for MAX_SM_DATA_WIDTH parameter
`define MAX__SM_DATA_WIDTH_RST 3'h2


// Name:         MAX__SM_ADDR_WIDTH_RST
// Default:      0xc (MAX_SM_ADDR_WIDTH - 11)
// Values:       0x0, ..., 0x1f
// 
// Reset value for MAX_SM_ADDR_WIDTH parameter
`define MAX__SM_ADDR_WIDTH_RST 5'hc


// Name:         MAX__S_DATA_WIDTH_RST
// Default:      0x1 ((MAX_S_DATA_WIDTH == 128) ? 4 : (MAX_S_DATA_WIDTH == 64) ? 3 : 
//               (MAX_S_DATA_WIDTH == 32) ? 2 : (MAX_S_DATA_WIDTH == 16) ? 1 : 0)
// Values:       0x0, ..., 0x7
// 
// Reset value for MAX_S_DATA_WIDTH parameter
`define MAX__S_DATA_WIDTH_RST 3'h1


// Name:         MAX__S_BANK_ADDR_WIDTH_RST
// Default:      0x1 (MAX_S_BANK_ADDR_WIDTH - 1)
// Values:       0x0, ..., 0x3
// 
// Reset value for MAX_S_BANK_ADDR_WIDTH parameter
`define MAX__S_BANK_ADDR_WIDTH_RST 2'h1


// Name:         MAX__S_ADDR_WIDTH_RST
// Default:      0x5 (MAX_S_ADDR_WIDTH - 11)
// Values:       0x0, ..., 0x7
// 
// Reset value for MAX_S_ADDR_WIDTH parameter
`define MAX__S_ADDR_WIDTH_RST 3'h5


// Name:         COMP_PARAMS_1_RST
// Default:      0x100010 ([<functionof> {{0b00000000000} {1 USE__MOBILE_DDR_RST} {1 
//               CHIP__SEL1_REMAP_ENABLE_RST} {1 CHIP__SEL0_REMAP_ENABLE_RST} {1 
//               CHIP__SEL1_ALIAS_ENABLE_RST} {1 CHIP__SEL0_ALIAS_ENABLE_RST} {1 
//               HARD__WIRE_SYNCFLASH_PARAMETERS_RST} {1 HARD__WIRE_STATIC_PARAMETERS_RST} {1 
//               HARD__WIRE_SDRAM_PARAMETERS_RST} {1 
//               HARD__WIRE_CIPSELECT_PARAMETRS_RST} {1 VER__1_2A_COMPATIABLE_MODE_RST} {3 N__CS_RST} {1 
//               ENABLE__STATIC_RST} {3 DYNAMIC__RAM_TYPE_RST} {0b0} {1 H__ADDR_WIDTH_RST} {2 
//               H__DATA_WIDTH_RST} }])
// Values:       0x0, ..., 0xffffffff
// 
// Reset value for COMP_PARAMS_1 register
`define COMP_PARAMS_1_RST 32'h100010


// Name:         COMP_PARAMS_2_RST
// Default:      0x4c2d ([<functionof> {{0x0} {3 MAX__SM_DATA_WIDTH_RST} {5 
//               MAX__SM_ADDR_WIDTH_RST} {3 MAX__S_DATA_WIDTH_RST} {2 
//               MAX__S_BANK_ADDR_WIDTH_RST} {3 MAX__S_ADDR_WIDTH_RST} }])
// Values:       0x0, ..., 0xffffffff
// 
// Reset value for COMP_PARAMS_2 register
`define COMP_PARAMS_2_RST 32'h4c2d


// `define MEMCTL_ENCRYPT



