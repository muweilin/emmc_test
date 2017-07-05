//  ------------------------------------------------------------------------
//
//                    (C) COPYRIGHT 2005 - 2013 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
//  This software and the associated documentation are confidential and
//  proprietary to Synopsys, Inc.  Your use or disclosure of this
//  software is subject to the terms and conditions of a written
//  license agreement between you, or your company, and Synopsys, Inc.
//
// The entire notice above must be reproduced on all authorized copies.
//
//  ------------------------------------------------------------------------

//--                                                                        
// Release version :  2.70a
// Date             :        $Date: 2013/02/27 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_params.v#26 $
//--                                                                        
//------------------------------------------------------------------------
// Filename    : DWC_mobile_storage_params.v
// Description : DWC_mobile_storage Parameter File
//------------------------------------------------------------------------


// Name:         CARD_TYPE
// Default:      SD_MMC_CE-ATA
// Values:       MMC_VER3.3_ONLY (0), SD_MMC_CE-ATA (1)
// 
// Configures the controller either as a Multimedia Card Ver3.3 only controller 
//  or as a SD/MMC/CE-ATA controller which supports SD Memory, SDIO, MMC Ver 3.3,  
//  MMC Ver 4.0 and CE-ATA simultaneously. The MMC_VER3.3_ONLY mode supports only  
//  the MMC Version 3.3 cards. In MMC Ver 3.3 mode, the cards and the controller are  
//  connected by a single shared bus (bus-topology). The SD_MMC_CE-ATA mode supports 
//  1-bit and 4-bit SD cards and 1-bit, 4-bit, and 8-bit MMC cards or CE-ATA devices.  
//  In SD_MMC_CE-ATA mode, separate bus is provided between the controller and  
//  each card in a star-topology.
`define CARD_TYPE 1


// Name:         NUM_CARDS
// Default:      3
// Values:       1, ..., 30
// 
// Configures the number of card supported by the controller. In MMC_VER3.3_ONLY  
//  mode, up to 30 physical cards are supported. In SD_MMC_CE-ATA mode, up to 16  
//  cards are supported.
`define NUM_CARDS 2


`define NUM_CARD_BUS 2


// Name:         H_BUS_TYPE
// Default:      AHB
// Values:       APB (0), AHB (1)
// 
// Configures the Host bus as either an AMBA APB or an AMBA AHB
`define H_BUS_TYPE 1


// Name:         H_DATA_WIDTH
// Default:      32
// Values:       16 32 64
// 
// Width of host data bus.
`define H_DATA_WIDTH 32


// Name:         H_ADDR_WIDTH
// Default:      20
// Values:       10, ..., 28
// 
// Width of host address bus. Address 0x00 to 0x1FF selects internal registers  
//  and address 0x200 and above selects the data FIFO
`define H_ADDR_WIDTH 20


// Name:         INTERNAL_DMAC
// Default:      YES
// Values:       NO (0), YES (1)
// 
// Determines whether an Internal DMA Controller is required.
`define INTERNAL_DMAC 1



// Name:         DMA_INTERFACE
// Default:      None
// Values:       None (0), DW-DMA (1), Generic-DMA (2), NON-DW-DMA (3)
// Enabled:      INTERNAL_DMAC==0
// 
// Configures the type for DMA interface. In addition to AMBA host interface, 
//  the data FIFO can be accesses by the optional DMA interface. The DMA type  
//  could be either DW-DMA, which provides hand shake signals to DW_ahb_dmac  
//  controller, or a generic DMA interface which provides a simpler  
//  request/acknowledgement protocol and dedicated DMA data-bus, or  
//  no DMA interface.
`define DMA_INTERFACE 0


// Name:         GE_DMA_DATA_WIDTH
// Default:      32
// Values:       16 32 64
// Enabled:      INTERNAL_DMAC==0 && DMA_INTERFACE==2
// 
// Width of 'Generic-DMA' data bus. This option is enabled only when  
//  DMA_INTERFACE is set to Generic-DMA.
`define GE_DMA_DATA_WIDTH 32


// Name:         FIFO_DEPTH
// Default:      16
// Values:       8 16 32 64 128 256 512 1024 2048 4096
// 
// Configures the depth of the combined transmit/receive FIFO buffer.  
//  The FIFO data width is set to either 32 or 64 depending upon your host  
//  and DMA configuration. Typically a smaller 16 to 32 deep FIFO is sufficient 
//  when DMA interface is selected. If processor is used to move data between 
//  FIFO and system memory, then a larger at least one block size of FIFO ram is  
//  recommended.
`define FIFO_DEPTH 128



`define R_ADDR_WIDTH 7


// Name:         FIFO_RAM_INSIDE
// Default:      Inside
// Values:       Outside (0), Inside (1)
// 
// Selects whether the FIFO RAM will be instantiated inside the core or  
//  it will be instantiated outside the core by the user. For smaller  
//  FIFO size, it is recommended to use "INSIDE" option, and the RAM gets  
//  synthesized automatically using Flops. When "OUTSIDE" option is chosen,  
//  ram interface ports are added to the DWC_mobile_storage.v. The user can then  
//  interface a vendor specific dual port synchronous ram to the ports.
`define FIFO_RAM_INSIDE 1


// Name:         NUM_CLK_DIVIDERS
// Default:      1
// Values:       1 2 3 4
// 
// Configures the number of clock dividers. DWC_mobile_storage supports 1 to 4 clock  
//  dividers. In MMC_VER3.3_ONLY mode, since there is only one "cclk_out", only one  
//  Clock Divider is supported.
`define NUM_CLK_DIVIDERS 2


// Name:         M_ADDR_WIDTH
// Default:      32
// Values:       32 64
// Enabled:      INTERNAL_DMAC==1
// 
// Width of Master Address Bus for IDMAC Configuration.'Generic-DMA' data bus. This option is enabled only when  
//  IDMAC configuration is enabled.
`define M_ADDR_WIDTH 32


// Name:         UID_REG
// Default:      0x7967797
// Values:       0x0, ..., 0xffffffff
// 
// Power on value of 'User Identification Register'. This register can be  
//  used as either a scratch pad or identification register by user.
`define UID_REG 32'h7967797


// Name:         SET_CLK_FALSE_PATH
// Default:      YES
// Values:       NO (0), YES (1)
// 
// When this parameter is set, in synthesis false path between  
//  "clk to cclk_in", "cclk_in to clk", and "reset_n to cclk_in" are set.  
//  If clk and  cclk_in are two different free running clocks then, it is  
//  recommended to set false path. If cclk and cclk_in have phase relationship  
//  (derived) then, it is recommended not to set false path so that  
//  metastability associated with signal synchronization can be avoided.  
//  If you are not setting false path, then clk and cclk_in frequencies  
//  should be integer multiple of each other
`define SET_CLK_FALSE_PATH 1


// Name:         AREA_OPTIMIZED
// Default:      NO
// Values:       NO (0), YES (1)
// 
// When this parameter is set, area is optimized by removing the following  
//  optional hardware features:  
//   1. General purpose input/output ports are removed  
//   2. User identification register(USRID) is not implemented  
//   3. "Transferred CIU card byte count" register(TCBCNT) can be only read  
//      after data transfer done and not during data transfer(will return 0).
`define AREA_OPTIMIZED 0


// Name:         IMPLEMENT_SCAN_MUX
// Default:      0
// Values:       0, 1
// 
// Implement scan_mux                                                                          
//  When this parameter is set, the negative-edge-triggered flip-flops 
//  are driven by a clock that is coming out of a scan MUX, which is 
//  instantiated only if IMPLEMENT_SCAN_MUX is set to 1
// `define IMPLEMENT_SCAN_MUX



//Instantiates the card hold-time registers

`define IMPLEMENT_HOLD_REG 1




//Defines for clock periods of hclk and cclk_in to be used for simulation.

`define HCLK_PERIOD 50


`define CCLKIN_PERIOD 100


`define CCLK_IN_DELAY 0


`define GTECH_default_delay 0




`define ENABLE_LONG_REGRESSION 0


`define ENABLE_ASSERTIONS 0
