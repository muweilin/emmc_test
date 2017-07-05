/*
------------------------------------------------------------------------
--
--                    (C) COPYRIGHT 2004-2011 SYNOPSYS, INC.
--                           ALL RIGHTS RESERVED
--
--  This software and the associated documentation are confidential and
--  proprietary to Synopsys, Inc.  Your use or disclosure of this
--  software is subject to the terms and conditions of a written
--  license agreement between you, or your company, and Synopsys, Inc.
--
--  The entire notice above must be reproduced on all authorized copies.
--
-- File :                      DW_ahb_cc_constants.v
-- Author:                     Peter Gillen 
-- Date :                      $Date: 2011/11/18 $ 
-- Version      :              $Revision: #7 $ 
-- Abstract     :              Parameter File for DW_ahb
--                             Contains all parameters used to configure
--                             AHB BusIP in coreConsultant
--
*/
//top-level parameters for DW_ahb


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
`define USE_FOUNDATION 0



// Name:         AHB_LITE
// Default:      false
// Values:       false (0), true (1)
// 
// If set to True (1), the system is configured with only 
// one master that never requests ownership of the bus, but is 
// always granted the bus. No dummy master is required, as the 
// slaves are not split-capable so the only master is always 
// the bus owner. The master will drive IDLE cycles when it  
// does not want the bus. 
//  
// In addition 
//   - Pause mode is not enabled 
//   - The default master number is changed to 1 
//   - The number of masters is changed to 1 
//   - The arbiter interface is removed 
//   - All slaves are made non split capable
`define AHB_LITE 0


// Name:         AHB_LITE_EDEF
// Default:      0 (AHB_LITE == 1 ? 1 : 0)
// Values:       0, 1
// Enabled:      0
// 
// Creates a define for whether bus is lite or not.
// `define AHB_LITE_EDEF



// Name:         NUM_AHB_MASTERS
// Default:      2 ([ <functionof> AHB_LITE ])
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_LITE == 0
// 
// The number of AHB Masters contained in the system. 
// When AMBA Lite is configured, then this is set to 1. 
// One can have a system which only has one master but is not AMBA Lite. 
// This allows the user to program the default master to be the dummy 
// master or the only existing master. The dummy master is the master  
// who owns the bus when no one wants it. 
// There can be up to 15 masters connected to the DW_ahb.
`define NUM_AHB_MASTERS 4


`define LOG2_NUM_INT_MASTERS 3


// Name:         HADDR_WIDTH
// Default:      32
// Values:       32 64
// 
// Chooses the address width for the AHB address bus; 
// 32-bit addressing or 64-bit addressing.
`define HADDR_WIDTH 32


// Name:         AHB_DATA_WIDTH
// Default:      32
// Values:       8 16 32 64 128 256
// 
// Selects the width of the AHB data bus. 
// The maximum 256-bit width is an arbitrary limitation enforced by coreConsultant.
`define AHB_DATA_WIDTH 32


// Name:         AHB_MAX_ARBIF_WIDTH
// Default:      32 ([ <functionof> AHB_DATA_WIDTH ])
// Values:       8 16 32
// Enabled:      0
// 
// Selects the max width of the read back register in the arbiter interface.
`define AHB_MAX_ARBIF_WIDTH 32


// Name:         AHB_XENDIAN
// Default:      false
// Values:       false (0), true (1)
// 
// If True (1), the endian type of the DW_ahb is 
// controlled by the external pin, ahb_big_endian. 
// ahb_big_endian = 1 => Big Endian 
// ahb_big_endian = 0 => Little Endian 
// If False (0), the endian type is set at configuration  
// by the BIG_ENDIAN parameter. 
// If controlled externally, the endian type is deemed bootable. 
// If controlled internally, there is no way to change the endian type after  
// the component has been configured.
`define AHB_XENDIAN 0


// Name:         BIG_ENDIAN
// Default:      Little-Endian
// Values:       Little-Endian (0), Big-Endian (1)
// Enabled:      AHB_XENDIAN == 0
// 
// By default, the DW_ahb is configured as a Little- 
// Endian system. The user can choose the endianness of the 
// system if endian control is not external. 
// The endian setting affects the byte-lane routing to or 
// from the arbiter slave.  This parameter is relevant only 
// when the internal arbiter slave is included within 
// the DW_ahb; that is, when AHB_HAS_ARBIF = 1 and when 
// the endian control is internal. 
//  
// This parameter can be used to derive the endianness for the rest 
// of the sub-system so it is changeable when there is no 
// arbiter slave interface.
`define BIG_ENDIAN 0


// Name:         AHB_HAS_XDCDR
// Default:      false
// Values:       false (0), true (1)
// 
// If True (1), the decoder is external to the DW_ahb. 
// If False (0), the decoder is internal to the DW_ahb. 
// For an internal decoder, the addresses need to be supplied  
// by the DW_ahb at configuration. 
// An external decoder allows users to connect any decoder with any 
// number of remap options.
`define AHB_HAS_XDCDR 0


// Name:         AHB_XDCDR
// Default:      0 (AHB_HAS_XDCDR == 1 ? 1 : 0)
// Values:       0, 1
// Enabled:      0
// 
// Creates a define for whether there is an external decoder or not.
// `define AHB_XDCDR


// Name:         REMAP
// Default:      false ([<functionof>])
// Values:       false (0), true (1)
// Enabled:      AHB_HAS_XDCDR==0
// 
// Allows the memory map to be swapped. When set, the 
// system supports the AMBA memory remap functionality. 
// Remap allows one set of addresses for boot, and another 
// for normal operation. This setting must be set if two 
// addressing modes are required. This parameter is relevant 
// only when there is an internal decoder; that is, 
// when AHB_HAS_XDCDR = 0.
`define REMAP 0


// Name:         PAUSE
// Default:      true ([ <functionof> AHB_LITE ])
// Values:       false (0), true (1)
// Enabled:      AHB_LITE==0
// 
// If set to True (1), the system supports the arbiter 
// pause mode. This setting allows the granting of the 
// bus to the Dummy master when the system is entering 
// low-power mode. When AHB_LITE = 1, pause mode is 
// disabled.
`define PAUSE 1


// Name:         AHB_DELAYED_PAUSE
// Default:      true ([ <functionof> AHB_LITE PAUSE ])
// Values:       false (0), true (1)
// Enabled:      (PAUSE==1) && (AHB_LITE==0)
// 
// When the delayed pause action is supported, the 
// pause signal, when set, will not take effect until hready 
// is high and htrans is IDLE. If delayed pause action is 
// not supported, the DW_ahb enters pause mode at the next hclk 
// edge once the pause signal is set. By delaying the action 
// on pause, any other transfers on the bus can be completed 
// before the system is paused.
`define AHB_DELAYED_PAUSE 1


// Name:         AHB_HAS_ARBIF
// Default:      true ([ <functionof> AHB_LITE ])
// Values:       false (0), true (1)
// Enabled:      AHB_LITE==0
// 
// If the user decides that there is no requirement 
// for the programmability features within the AHB arbiter 
// interface, this feature can be disabled (set to False). 
// The peripheral slot (s0) is not available to other slaves, 
// meaning it is unused.  
// There is no arbiter interface when the system is an AHB Lite system.
`define AHB_HAS_ARBIF 1


// Name:         AHB_WTEN
// Default:      false
// Values:       false (0), true (1)
// Enabled:      AHB_HAS_ARBIF == 1 && AHB_LITE == 0 && NUM_AHB_MASTERS > 1
// 
// Enables the inclusion of a weighted token 
// priority arbitration scheme. When the scheme is enabled, 
// it is a third tier of arbitration. Each master is given  
// a certain number of clock tokens for access to the bus. 
// The output hmaster indicates which master is the bus  
// owner. Each time a master is on the bus it uses up a token 
// and the corresponding token counter is decremented. 
// A master with clock tokens remaining, although of a lower 
// priority than a master with no clock tokens left to use 
// will be granted the bus. When masters have all clock tokens 
// used, the arbitration reverts to a two-tier arbitration.  
// When a master has used all of its tokens, it will be granted  
// the bus when masters with tokens are not requesting the bus.  
// The internal arbiter slave must be included in order to use  
// the weighted token arbitration mode and to generate outputs 
// which show the current count of each masters token counter. 
//  
// It is not possible to instantiate the weighted token priority 
// arbitration scheme when there is only one master.
`define AHB_WTEN 0


// Name:         AHB_WTEN_DEBUG
// Default:      false
// Values:       false (0), true (1)
// Enabled:      AHB_HAS_ARBIF == 1 && AHB_LITE == 0 && AHB_WTEN == 1
// 
// Enables the inclusion of weighted token clock 
// token counter outputs as top-level outputs that can help 
// fine tune the number of tokens that one can assign to 
// a master. These debug outputs show the number of tokens 
// a master has left.  This parameter is unavailable when 
// AHB_WTEN = False (0).By providing them as outputs allows 
// the system designer to trace them during development.
`define AHB_WTEN_DEBUG 0


// Name:         AHB_FULL_INCR
// Default:      false
// Values:       false (0), true (1)
// Enabled:      AHB_LITE == 0
// 
// When a burst of unspecified length is issued from 
// a master, the updating of the internal arbiter can 
// be controlled. By supporting full incrementing bursts, 
// the arbiter will not "early terminate" a burst transfer 
// that is of an unspecified length. The entire burst is 
// allowed to complete. Not supporting full incrementing 
// bursts (the default mode of operation) makes the arbiter 
// free to update the grants to the highest priority 
// master when a master issues a burst transfer of an 
// unspecified length. This, in effect, early terminates the 
// currently granted transfer on the bus. This will not override 
// the updating of the grants if a SPLIT or a RETRy is received.
`define AHB_FULL_INCR 1


// Name:         NUM_IAHB_SLAVES
// Default:      4
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// 
// This number is the total number of slave select 
// lines in the system. There may be slaves that are 
// visible in one of the modes. There is still a slave 
// select generated for the slave, so that in either 
// of the addressing modes there can be 15 assigned 
// slaves. If there is only one addressing mode, then 
// this is the number of slaves in the system.
`define NUM_IAHB_SLAVES 4


// Name:         NUM_NAHB_SLAVES
// Default:      4 (NUM_IAHB_SLAVES)
// Values:       0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      REMAP == 1 && [<functionof> AHB_HAS_XDCDR]
// 
// Specifies the number of slave select lines in the system 
// in Normal mode, which is controlled by the slave's 
// visibility. Slaves can be visible in both Normal and 
// Boot modes. This parameter option is active only if 
// you enable the Memory Remap Feature.
`define NUM_NAHB_SLAVES 4


// Name:         NUM_BAHB_SLAVES
// Default:      0 ([<functionof> REMAP])
// Values:       0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      REMAP == 1 && [<functionof> AHB_HAS_XDCDR]
// 
// Specifies the number of slave select lines contained 
// in the system in Boot mode, which is controlled by the 
// slave's visibility. Slaves can be visible in both Normal 
// and Boot modes. This parameter option is only active if 
// you enable the Memory Remap Feature.
`define NUM_BAHB_SLAVES 0


// Name:         R1_N_SA_0
// Default:      0x1000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_HAS_ARBIF == 1 && AHB_LITE == 0 && [<functionof> AHB_HAS_XDCDR]
// 
// Normal Mode start address for AHB Arbiter. The Arbiter 
// Slave Interface must be included in the design 
// (that is, when AHB_HAS_ARBIF = 1), and the decoder must 
// be configured as internal (when AHB_HAS_XDCDR = 0).
`define R1_N_SA_0 32'h1000000


// Name:         R1_N_EA_0
// Default:      0x10003ff
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_HAS_ARBIF == 1 && AHB_LITE == 0 && [<functionof> AHB_HAS_XDCDR]
// 
// Normal Mode end address for AHB Arbiter. The Arbiter 
// Slave Interface must be included in the design 
// (that is, when AHB_HAS_ARBIF = 1), and the decoder must 
// be configured as internal (when AHB_HAS_XDCDR = 0).
`define R1_N_EA_0 32'h10003ff


// Name:         R1_B_SA_0
// Default:      0x26000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      REMAP == 1 && NUM_BAHB_SLAVES >= 1 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0 && [<functionof> AHB_HAS_XDCDR]
// 
// Boot Mode start address for AHB Arbiter. This parameter 
// option is only active if you enable the Memory Remap 
// Feature (that is, when REMAP = 1) in the top-level parameter 
// options, include the Arbiter Slave Interface in the design, 
// (AHB_HAS_ARBIF = 1), and configure the decoder as internal 
// (AHB_HAS_XDCDR = 0).
`define R1_B_SA_0 32'h26000000


// Name:         R1_B_EA_0
// Default:      0x260003ff
// Values:       0x0, ..., 0xffffffff
// Enabled:      REMAP == 1 && NUM_BAHB_SLAVES>=1 && AHB_HAS_ARBIF == 1 && AHB_LITE 
//               == 0 && [<functionof> AHB_HAS_XDCDR]
// 
// Boot Mode start address for AHB Arbiter. This parameter 
// option is active only if you enable the Memory Remap 
// Feature (that is, when REMAP = 1) in the top-level 
// parameter options, include the Arbiter Slave Interface in 
// the design (AHB_HAS_ARBIF = 1), and configure the 
// decoder as internal (AHB_HAS_XDCDR = 0).
`define R1_B_EA_0 32'h260003ff


// Name:         HC_PRIORITIES
// Default:      false ([ <functionof> AHB_LITE AHB_HAS_ARBIF ])
// Values:       false (0), true (1)
// Enabled:      AHB_HAS_ARBIF == 1 && AHB_LITE == 0
// 
// If this parameter is set to Yes, the priorities will 
// be read only. If it is set to No, the priorities can be 
// programmed during runtime. If there is no Arbiter Slave 
// Interface, this parameter is dimmed and hardcoded to Yes.
`define HC_PRIORITIES 0


// Name:         DFLT_MSTR_NUM
// Default:      0 ([ <functionof> AHB_LITE ])
// Values:       0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_LITE == 0
// 
// Specifies the ID Number of the System Default Master. 
// A default master is required according to the 
// AMBA Specification (Rev. 2.0). You can set this to 
// 0 if you want the Dummy Master to act as the Default 
// Master. The value must be less than or equal to the 
// value of NUM_AHB_MASTERS. If weighted token arbitration 
// is enabled, then this value is hardcoded to 0.
`define DFLT_MSTR_NUM 0


// Name:         HC_DFLT_MSTR
// Default:      false ([ <functionof> AHB_LITE AHB_HAS_ARBIF ])
// Values:       false (0), true (1)
// Enabled:      AHB_HAS_ARBIF == 1 && AHB_LITE == 0
// 
// If you set this parameter to Yes, the ID of the 
// Default Master will be read only. If there is no 
// Arbiter Slave Interface, this parameter is dimmed 
// and hardcoded to Yes.
`define HC_DFLT_MSTR 0


// Name:         EBTEN
// Default:      true ([ <functionof> AHB_LITE AHB_HAS_ARBIF ])
// Values:       false (0), true (1)
// Enabled:      AHB_HAS_ARBIF == 1 && AHB_LITE == 0
// 
// The Early Burst Termination logic is included 
// when this parameter is set; otherwise the ahbarbint 
// signal is removed. If there is no Arbiter Slave 
// Interface, this parameter is dimmed and set to No. 
// This allows long transfers to be broken up by the arbiter. 
// If this is set to False (0) it will not prevent the 
// arbiter from breaking up a burst transfer cause by SPLIT 
// or RETRY. This should be used to break up long bursts. 
// It is not possible to terminate a locked transfer.
`define EBTEN 1

//xreuse-pragma attr Enabled {@AHB_HAS_ARBIF == 1 && @AHB_LITE == 0}

// Name:         GEN_HSEL0
// Default:      true
// Values:       false (0), true (1)
// Enabled:      0
// 
// Select line for the internal arbiter slave. When 
// there is an internal decoder, the select is 
// hsel_s0. When there is an external decoder, the 
// select is xhsel_s0. If there is no Arbiter Slave 
// Interface, this parameter is dimmed and set to No. 
// When the DW_ahb configured as AMBA Lite, then this 
// signal is removed from the I/O. 
// When there is an arbiter slave this will always exist on the interface
`define GEN_HSEL0 1


// Name:         PRIORITY_1
// Default:      0x1
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>1 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 1. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 1 (0x1).
`define PRIORITY_1 4'h1


// Name:         PRIORITY_2
// Default:      0x2
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>1 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 2. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 2 (0x2).
`define PRIORITY_2 4'h2


// Name:         PRIORITY_3
// Default:      0x3
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>2 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 3. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 3 (0x3).
`define PRIORITY_3 4'h3


// Name:         PRIORITY_4
// Default:      0x4
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>3 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 4. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 4 (0x4).
`define PRIORITY_4 4'h4


// Name:         PRIORITY_5
// Default:      0x5
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>4 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 5. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 5 (0x5).
`define PRIORITY_5 4'h5


// Name:         PRIORITY_6
// Default:      0x6
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>5 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 6. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 6 (0x6).
`define PRIORITY_6 4'h6


// Name:         PRIORITY_7
// Default:      0x7
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>6 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 7. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 7 (0x7).
`define PRIORITY_7 4'h7


// Name:         PRIORITY_8
// Default:      0x8
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>7 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 8. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 8 (0x8).
`define PRIORITY_8 4'h8


// Name:         PRIORITY_9
// Default:      0x9
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>8 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 9. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 9 (0x9).
`define PRIORITY_9 4'h9


// Name:         PRIORITY_10
// Default:      0xa
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>9 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 10. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 10 (0xa).
`define PRIORITY_10 4'ha


// Name:         PRIORITY_11
// Default:      0xb
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>10 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 11. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 11 (0xb).
`define PRIORITY_11 4'hb


// Name:         PRIORITY_12
// Default:      0xc
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>11 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 13. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 12 (0xd).
`define PRIORITY_12 4'hc


// Name:         PRIORITY_13
// Default:      0xd
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>12 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 13. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 13 (0xd).
`define PRIORITY_13 4'hd


// Name:         PRIORITY_14
// Default:      0xe
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>13 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 14. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 14 (0xe).
`define PRIORITY_14 4'he


// Name:         PRIORITY_15
// Default:      0xf
// Values:       0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 
//               0xe, 0xf
// Enabled:      NUM_AHB_MASTERS>14 && AHB_LITE == 0
// 
// Arbitration priority associated with Master 15. 
// Priority 1 (0x1) is the lowest and Priority 15 (0xf) 
// is the highest. It is not possible to configure a 
// priority of zero (0x0), which disables the master. 
// However, it is possible to program it, provided the 
// priority values are not hardcoded. The default value 
// is 15 (0xf).
`define PRIORITY_15 4'hf


// Name:         VISIBLE_1
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      REMAP == 1 && [<functionof> AHB_HAS_XDCDR]
// 
// Visibility of first Slave, which may be visible in 
// Boot Mode, Normal Mode, or both modes. The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature (REMAP = 1) 
// and have configured to use an internal decoder 
// (AHB_HAS_XDCDR = 0) in the top-level parameter options.
`define VISIBLE_1 1


// Name:         MR_N1
// Default:      1 Region
// Values:       1 Region (0), 2 Regions (1), 3 Regions (2), 4 Regions (3), 5 
//               Regions (4), 6 Regions (5), 7 Regions (6), 8 Regions (7)
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR]
// 
// The number of memory regions in Normal Mode for Slave #1. 
// This parameter option is available only for Slave #1 and 
// if the Slave Visibility Mode is set to "Normal" or "Normal 
// & Boot". Additionally, this option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N1 0


// Name:         MR_B1
// Default:      1 Region
// Values:       1 Region (0), 2 Regions (1), 3 Regions (2), 4 Regions (3), 5 
//               Regions (4), 6 Regions (5), 7 Regions (6), 8 Regions (7)
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1
// 
// Number of memory regions in Boot Mode for Slave #1. 
// This parameter option is available only for Slave #1 
// and if the Slave Visibility Mode is set to "Boot" or 
// "Normal & Boot". Additionally, this option applies 
// only if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B1 0


// Name:         HSEL_ONLY_S1
// Default:      false
// Values:       false (0), true (1)
// 
// Generates only hsel for this slave; requires an aliases 
// for data and response from another slave.
`define HSEL_ONLY_S1 0


// Name:         ALIAS_S1
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S1==1
// 
// Slave number that supplies the data and 
// response. The value must be less than, or equal 
// to the value of NUM_IAHB_SLAVES. The value of this 
// parameter cannot equal i, meaning you cannot alias 
// this slave to itself. This parameter option is 
// available only if the HSEL_ONLY_S1 is set to Yes.
`define ALIAS_S1 1


// Name:         SPLIT_CAPABLE_1
// Default:      false
// Values:       false (0), true (1)
// Enabled:      HSEL_ONLY_S1==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter 
// to True (1). When a slave is aliased, it takes its split 
// capability from the slave it is aliased to. Therefore, 
// this option will be dimmed if the HSEL_ONLY_S1 is set to Yes. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_1 0


// Name:         R1_N_SA_1
// Default:      0x2000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR]
// 
// Region 1, normal addressing mode, start address for Slave 1. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_1 32'h30010000


// Name:         R1_N_EA_1
// Default:      0x200ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR]
// 
// Region 1, normal addressing mode, end address for 
// Slave 1. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_1 32'h6fffffff


// Name:         R2_N_SA_1
// Default:      0x3000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 1
// 
// Region 2, normal addressing mode, start address for 
// Slave 1. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_1 32'h3000000


// Name:         R2_N_EA_1
// Default:      0x300ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 1
// 
// Region 2, normal addressing mode, end address for 
// Slave 1. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in 
// Normal Mode" is set to True (1) and if you have an 
// internal decoder (AHB_HAS_XDCDR = 0).
`define R2_N_EA_1 32'h300ffff


// Name:         R3_N_SA_1
// Default:      0x4000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 2
// 
// Region 3, normal addressing mode, start address for 
// Slave 1. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R3_N_SA_1 32'h4000000


// Name:         R3_N_EA_1
// Default:      0x400ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 2
// 
// Region 3, normal addressing mode, end address for 
// Slave 1. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in 
// Normal Mode" is set to True (1) and if you have an 
// internal decoder (AHB_HAS_XDCDR = 0).
`define R3_N_EA_1 32'h400ffff


// Name:         R4_N_SA_1
// Default:      0x5000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 3
// 
// Region 4, normal addressing mode, start address for 
// Slave 1. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R4_N_SA_1 32'h5000000


// Name:         R4_N_EA_1
// Default:      0x500ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 3
// 
// Region 4, normal addressing mode, end address for 
// Slave 1. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in 
// Normal Mode" is set to True (1) and if you have an 
// internal decoder (AHB_HAS_XDCDR = 0).
`define R4_N_EA_1 32'h500ffff


// Name:         R5_N_SA_1
// Default:      0x6000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 4
// 
// Region 5, normal addressing mode, start address for 
// Slave 1. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R5_N_SA_1 32'h6000000


// Name:         R5_N_EA_1
// Default:      0x600ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 4
// 
// Region 5, normal addressing mode, end address for 
// Slave 1. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in 
// Normal Mode" is set to True (1) and if you have an 
// internal decoder (AHB_HAS_XDCDR = 0).
`define R5_N_EA_1 32'h600ffff


// Name:         R6_N_SA_1
// Default:      0x7000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 5
// 
// Region 6, normal addressing mode, start address for 
// Slave 1. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R6_N_SA_1 32'h7000000


// Name:         R6_N_EA_1
// Default:      0x700ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 5
// 
// Region 6, normal addressing mode, end address for 
// Slave 1. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in 
// Normal Mode" is set to True (1) and if you have an 
// internal decoder (AHB_HAS_XDCDR = 0).
`define R6_N_EA_1 32'h700ffff


// Name:         R7_N_SA_1
// Default:      0x8000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 6
// 
// Region 7, normal addressing mode, start address for 
// Slave 1. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R7_N_SA_1 32'h8000000


// Name:         R7_N_EA_1
// Default:      0x800ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 6
// 
// Region 7, normal addressing mode, end address for 
// Slave 1. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in 
// Normal Mode" is set to True (1) and if you have an 
// internal decoder (AHB_HAS_XDCDR = 0).
`define R7_N_EA_1 32'h800ffff


// Name:         R8_N_SA_1
// Default:      0x9000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 7
// 
// Region 8, normal addressing mode, start address for 
// Slave 1. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R8_N_SA_1 32'h9000000


// Name:         R8_N_EA_1
// Default:      0x900ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 2 && [<functionof> AHB_HAS_XDCDR] &&  MR_N1 >= 7
// 
// Region 8, normal addressing mode, end address for 
// Slave 1. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in 
// Normal Mode" is set to True (1) and if you have an 
// internal decoder (AHB_HAS_XDCDR = 0).
`define R8_N_EA_1 32'h900ffff


// Name:         R1_B_SA_1
// Default:      0x27000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1
// 
// Region 1, boot addressing mode, start address for 
// Slave 1. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_1 32'h27000000


// Name:         R1_B_EA_1
// Default:      0x2700ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1
// 
// Region 1 boot, addressing mode, end address for 
// Slave 1. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_1 32'h2700ffff


// Name:         R2_B_SA_1
// Default:      0x28000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 1
// 
// Region 2, boot addressing mode, start address for 
// Slave 1. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_1 32'h28000000


// Name:         R2_B_EA_1
// Default:      0x2800ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 1
// 
// Region 2, boot addressing mode, end address for 
// Slave 1. This parameter option is available only 
// if "Support Multiple Memory Regions in Boot Mode" 
// is set to True (1), if you have an internal 
// decoder (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_1 32'h2800ffff


// Name:         R3_B_SA_1
// Default:      0x29000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 2
// 
// Region 3, boot addressing mode, start address for 
// Slave 1. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R3_B_SA_1 32'h29000000


// Name:         R3_B_EA_1
// Default:      0x2900ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 2
// 
// Region 3, boot addressing mode, end address for 
// Slave 1. This parameter option is available only 
// if "Support Multiple Memory Regions in Boot Mode" 
// is set to True (1), if you have an internal 
// decoder (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R3_B_EA_1 32'h2900ffff


// Name:         R4_B_SA_1
// Default:      0x2a000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 3
// 
// Region 4, boot addressing mode, start address for 
// Slave 1. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R4_B_SA_1 32'h2a000000


// Name:         R4_B_EA_1
// Default:      0x2a00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 3
// 
// Region 4, boot addressing mode, end address for 
// Slave 1. This parameter option is available only 
// if "Support Multiple Memory Regions in Boot Mode" 
// is set to True (1), if you have an internal 
// decoder (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R4_B_EA_1 32'h2a00ffff


// Name:         R5_B_SA_1
// Default:      0x2b000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 4
// 
// Region 5, boot addressing mode, start address for 
// Slave 1. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R5_B_SA_1 32'h2b000000


// Name:         R5_B_EA_1
// Default:      0x2b00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 4
// 
// Region 5, boot addressing mode, end address for 
// Slave 1. This parameter option is available only 
// if "Support Multiple Memory Regions in Boot Mode" 
// is set to True (1), if you have an internal 
// decoder (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R5_B_EA_1 32'h2b00ffff


// Name:         R6_B_SA_1
// Default:      0x2c000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 5
// 
// Region 6, boot addressing mode, start address for 
// Slave 1. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R6_B_SA_1 32'h2c000000


// Name:         R6_B_EA_1
// Default:      0x2c00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 5
// 
// Region 6, boot addressing mode, end address for 
// Slave 1. This parameter option is available only 
// if "Support Multiple Memory Regions in Boot Mode" 
// is set to True (1), if you have an internal 
// decoder (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R6_B_EA_1 32'h2c00ffff


// Name:         R7_B_SA_1
// Default:      0x2d000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 6
// 
// Region 7, boot addressing mode, start address for 
// Slave 1. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R7_B_SA_1 32'h2d000000


// Name:         R7_B_EA_1
// Default:      0x2d00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 6
// 
// Region 7, boot addressing mode, end address for 
// Slave 1. This parameter option is available only 
// if "Support Multiple Memory Regions in Boot Mode" 
// is set to True (1), if you have an internal 
// decoder (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R7_B_EA_1 32'h2d00ffff


// Name:         R8_B_SA_1
// Default:      0x2e000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 7
// 
// Region 8, boot addressing mode, start address for 
// Slave 1. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R8_B_SA_1 32'h2e000000


// Name:         R8_B_EA_1
// Default:      0x2e00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_1 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 &&  
//               MR_B1 >= 7
// 
// Region 8, boot addressing mode, end address for 
// Slave 1. This parameter option is available only 
// if "Support Multiple Memory Regions in Boot Mode" 
// is set to True (1), if you have an internal 
// decoder (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R8_B_EA_1 32'h2e00ffff


// Name:         VISIBLE_2
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>1 && REMAP==1
// 
// Visibility of second Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_2 1


// Name:         MR_N2
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_2 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>1
// 
// Number of regions in Normal Mode for Slave 2. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N2 0


// Name:         R1_N_SA_2
// Default:      0xa000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_2 != 2 && [<functionof> AHB_HAS_XDCDR] & NUM_IAHB_SLAVES>1
// 
// Region 1, normal addressing mode, start address for Slave 2. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_2 32'h28001000


// Name:         R1_N_EA_2
// Default:      0xa00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_2 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>1
// 
// Region 1, normal addressing mode, end address for 
// Slave 2. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_2 32'h28001fff


// Name:         R2_N_SA_2
// Default:      0xb000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_2 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N2 == 1 && 
//               NUM_IAHB_SLAVES>1
// 
// Region 2, normal addressing mode, start address for 
// Slave 2. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_2 32'hb000000


// Name:         R2_N_EA_2
// Default:      0xb00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_2 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N2 == 1 && 
//               NUM_IAHB_SLAVES>1
// 
// Region 2, normal addressing mode, end address for 
// Slave 2. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_2 32'hb00ffff


// Name:         MR_B2
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_2 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>1
// 
// Number of regions in Boot Mode for Slave 2. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B2 0


// Name:         R1_B_SA_2
// Default:      0x2f000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_2 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>1
// 
// Region 1, boot addressing mode, start address for 
// Slave 2. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_2 32'h2f000000


// Name:         R1_B_EA_2
// Default:      0x2f00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_2 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>1
// 
// Region 1 boot, addressing mode, end address for 
// Slave 2. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_2 32'h2f00ffff


// Name:         R2_B_SA_2
// Default:      0x30000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_2 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B2 == 1 && NUM_IAHB_SLAVES>1
// 
// Region 2, boot addressing mode, start address for 
// Slave 2. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_2 32'h30000000


// Name:         R2_B_EA_2
// Default:      0x3000ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_2 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B2 == 1 && NUM_IAHB_SLAVES>1
// 
// Region 2, boot addressing mode, end address for 
// Slave 2. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_2 32'h3000ffff


// Name:         HSEL_ONLY_S2
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>1
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data, 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S2 0


// Name:         ALIAS_S2
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S2==1 && NUM_IAHB_SLAVES>1
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 2, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S2 = 1.
`define ALIAS_S2 1


// Name:         SPLIT_CAPABLE_2
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>1 && HSEL_ONLY_S2==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S2 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_2 0


// Name:         VISIBLE_3
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>2 && REMAP==1
// 
// Visibility of third Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_3 1


// Name:         MR_N3
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_3 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>2
// 
// Number of regions in Normal Mode for Slave 3. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N3 0


// Name:         R1_N_SA_3
// Default:      0xc000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_3 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>2
// 
// Region 1, normal addressing mode, start address for Slave 3. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_3 32'h28002000


// Name:         R1_N_EA_3
// Default:      0xc00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_3 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>2
// 
// Region 1, normal addressing mode, end address for 
// Slave 3. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_3 32'h28002fff


// Name:         R2_N_SA_3
// Default:      0xd000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_3 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N3 == 1 && 
//               NUM_IAHB_SLAVES>2
// 
// Region 2, normal addressing mode, start address for 
// Slave 3. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_3 32'hd000000


// Name:         R2_N_EA_3
// Default:      0xd00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_3 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N3 == 1 && 
//               NUM_IAHB_SLAVES>2
// 
// Region 2, normal addressing mode, end address for 
// Slave 3. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_3 32'hd00ffff


// Name:         MR_B3
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_3 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>2
// 
// Number of regions in Boot Mode for Slave 3. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B3 0


// Name:         R1_B_SA_3
// Default:      0x31000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_3 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>2
// 
// Region 1, boot addressing mode, start address for 
// Slave 3. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_3 32'h31000000


// Name:         R1_B_EA_3
// Default:      0x3100ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_3 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1
// 
// Region 1 boot, addressing mode, end address for 
// Slave 3. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_3 32'h3100ffff


// Name:         R2_B_SA_3
// Default:      0x32000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_3 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B3 == 1 && NUM_IAHB_SLAVES>2
// 
// Region 2, boot addressing mode, start address for 
// Slave 3. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_3 32'h32000000


// Name:         R2_B_EA_3
// Default:      0x3200ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_3 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B3 == 1 && NUM_IAHB_SLAVES>2
// 
// Region 2, boot addressing mode, end address for 
// Slave 3. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_3 32'h3200ffff


// Name:         HSEL_ONLY_S3
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>2
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data, 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S3 0


// Name:         ALIAS_S3
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S3==1 && NUM_IAHB_SLAVES>2
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 3, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S3 = 1.
`define ALIAS_S3 1


// Name:         SPLIT_CAPABLE_3
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>2 && HSEL_ONLY_S3==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S3 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_3 0


// Name:         VISIBLE_4
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>3 && REMAP==1
// 
// Visibility of fourth Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_4 1


// Name:         MR_N4
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_4 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>3
// 
// Number of regions in Normal Mode for Slave 4. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N4 0


// Name:         R1_N_SA_4
// Default:      0xe000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_4 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>3
// 
// Region 1, normal addressing mode, start address for Slave 4. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_4 32'h28003000


// Name:         R1_N_EA_4
// Default:      0xe00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_4 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>3
// 
// Region 1, normal addressing mode, end address for 
// Slave 4. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_4 32'h28003fff


// Name:         R2_N_SA_4
// Default:      0xf000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_4 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N4 == 1 && 
//               NUM_IAHB_SLAVES>3
// 
// Region 2, normal addressing mode, start address for 
// Slave 4. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_4 32'hf000000


// Name:         R2_N_EA_4
// Default:      0xf00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_4 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N4 == 1 && 
//               NUM_IAHB_SLAVES>3
// 
// Region 2, normal addressing mode, end address for 
// Slave 4. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_4 32'hf00ffff


// Name:         MR_B4
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_4 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>3
// 
// Number of regions in Boot Mode for Slave 4. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B4 0


// Name:         R1_B_SA_4
// Default:      0x33000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_4 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>3
// 
// Region 1, boot addressing mode, start address for 
// Slave 4. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_4 32'h33000000


// Name:         R1_B_EA_4
// Default:      0x3300ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_4 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>3
// 
// Region 1 boot, addressing mode, end address for 
// Slave 4. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_4 32'h3300ffff


// Name:         R2_B_SA_4
// Default:      0x34000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_4 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B4 == 1 && NUM_IAHB_SLAVES>3
// 
// Region 2, boot addressing mode, start address for 
// Slave 4. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_4 32'h34000000


// Name:         R2_B_EA_4
// Default:      0x3400ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_4 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B4 == 1 && NUM_IAHB_SLAVES>3
// 
// Region 2, boot addressing mode, end address for 
// Slave 4. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_4 32'h3400ffff


// Name:         HSEL_ONLY_S4
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>3
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data, 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S4 0


// Name:         ALIAS_S4
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S4==1 && NUM_IAHB_SLAVES>3
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 4, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S4 = 1.
`define ALIAS_S4 1


// Name:         SPLIT_CAPABLE_4
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>3 && HSEL_ONLY_S4==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S4 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_4 0


// Name:         VISIBLE_5
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>4 && REMAP==1
// 
// Visibility of fifth Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_5 1


// Name:         MR_N5
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_5 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>4
// 
// Number of regions in Normal Mode for Slave 5. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N5 0


// Name:         R1_N_SA_5
// Default:      0x10000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_5 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>4
// 
// Region 1, normal addressing mode, start address for Slave 5. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_5 32'h10000000


// Name:         R1_N_EA_5
// Default:      0x1000ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_5 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>4
// 
// Region 1, normal addressing mode, end address for 
// Slave 5. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_5 32'h1000ffff


// Name:         R2_N_SA_5
// Default:      0x11000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_5 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N5 == 1 && 
//               NUM_IAHB_SLAVES>4
// 
// Region 2, normal addressing mode, start address for 
// Slave 5. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_5 32'h11000000


// Name:         R2_N_EA_5
// Default:      0x1100ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_5 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N5 == 1 && 
//               NUM_IAHB_SLAVES>4
// 
// Region 2, normal addressing mode, end address for 
// Slave 5. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_5 32'h1100ffff


// Name:         MR_B5
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_5 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>4
// 
// Number of regions in Boot Mode for Slave 5. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B5 0


// Name:         R1_B_SA_5
// Default:      0x35000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_5 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>4
// 
// Region 1, boot addressing mode, start address for 
// Slave 4. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_5 32'h35000000


// Name:         R1_B_EA_5
// Default:      0x3500ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_5 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>4
// 
// Region 1 boot, addressing mode, end address for 
// Slave 5. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_5 32'h3500ffff


// Name:         R2_B_SA_5
// Default:      0x36000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_5 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B5 == 1 && NUM_IAHB_SLAVES>4
// 
// Region 2, boot addressing mode, start address for 
// Slave 5. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_5 32'h36000000


// Name:         R2_B_EA_5
// Default:      0x3600ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_5 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B5 == 1 && NUM_IAHB_SLAVES>4
// 
// Region 2, boot addressing mode, end address for 
// Slave 5. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_5 32'h3600ffff


// Name:         HSEL_ONLY_S5
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>4
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data, 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S5 0


// Name:         ALIAS_S5
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S5==1 && NUM_IAHB_SLAVES>4
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 5, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S5 = 1.
`define ALIAS_S5 1


// Name:         SPLIT_CAPABLE_5
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>4 && HSEL_ONLY_S5==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S5 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_5 0


// Name:         VISIBLE_6
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>5 && REMAP==1
// 
// Visibility of sixth Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_6 1


// Name:         MR_N6
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_6 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>5
// 
// Number of regions in Normal Mode for Slave 6. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N6 0


// Name:         R1_N_SA_6
// Default:      0x12000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_6 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>5
// 
// Region 1, normal addressing mode, start address for Slave 6. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_6 32'h12000000


// Name:         R1_N_EA_6
// Default:      0x1200ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_6 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>5
// 
// Region 1, normal addressing mode, end address for 
// Slave 6. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_6 32'h1200ffff


// Name:         R2_N_SA_6
// Default:      0x13000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_6 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N6 == 1 && 
//               NUM_IAHB_SLAVES>5
// 
// Region 2, normal addressing mode, start address for 
// Slave 6. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_6 32'h13000000


// Name:         R2_N_EA_6
// Default:      0x1300ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_6 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N6 == 1 && 
//               NUM_IAHB_SLAVES>5
// 
// Region 2, normal addressing mode, end address for 
// Slave 6. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_6 32'h1300ffff


// Name:         MR_B6
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_6 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>5
// 
// Number of regions in Boot Mode for Slave 6. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B6 0


// Name:         R1_B_SA_6
// Default:      0x37000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_6 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>5
// 
// Region 1, boot addressing mode, start address for 
// Slave 6. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_6 32'h37000000


// Name:         R1_B_EA_6
// Default:      0x3700ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_6 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>5
// 
// Region 1 boot, addressing mode, end address for 
// Slave 6. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_6 32'h3700ffff


// Name:         R2_B_SA_6
// Default:      0x38000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_6 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B6 == 1 && NUM_IAHB_SLAVES>5
// 
// Region 2, boot addressing mode, start address for 
// Slave 6. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_6 32'h38000000


// Name:         R2_B_EA_6
// Default:      0x3800ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_6 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B6 == 1 && NUM_IAHB_SLAVES>5
// 
// Region 2, boot addressing mode, end address for 
// Slave 6. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_6 32'h3800ffff


// Name:         HSEL_ONLY_S6
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>5
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data, 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S6 0


// Name:         ALIAS_S6
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S6==1 && NUM_IAHB_SLAVES>5
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 6, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S6 = 1.
`define ALIAS_S6 1


// Name:         SPLIT_CAPABLE_6
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>5 && HSEL_ONLY_S6==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S6 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_6 0


// Name:         VISIBLE_7
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>6 && REMAP==1
// 
// Visibility of seventh Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_7 1


// Name:         MR_N7
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_7 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>6
// 
// Number of regions in Normal Mode for Slave 7. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N7 0


// Name:         R1_N_SA_7
// Default:      0x14000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_7 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>6
// 
// Region 1, normal addressing mode, start address for Slave 7. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_7 32'h14000000


// Name:         R1_N_EA_7
// Default:      0x1400ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_7 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>6
// 
// Region 1, normal addressing mode, end address for 
// Slave 7. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_7 32'h1400ffff


// Name:         R2_N_SA_7
// Default:      0x15000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_7 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N7 == 1 && 
//               NUM_IAHB_SLAVES>6
// 
// Region 2, normal addressing mode, start address for 
// Slave 7. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_7 32'h15000000


// Name:         R2_N_EA_7
// Default:      0x1500ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_7 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N7 == 1 && 
//               NUM_IAHB_SLAVES>6
// 
// Region 2, normal addressing mode, end address for 
// Slave 7. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_7 32'h1500ffff


// Name:         MR_B7
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_7 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>6
// 
// Number of regions in Boot Mode for Slave 7. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B7 0


// Name:         R1_B_SA_7
// Default:      0x39000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_7 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>6
// 
// Region 1, boot addressing mode, start address for 
// Slave 7. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_7 32'h39000000


// Name:         R1_B_EA_7
// Default:      0x3900ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_7 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>6
// 
// Region 1 boot, addressing mode, end address for 
// Slave 7. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_7 32'h3900ffff


// Name:         R2_B_SA_7
// Default:      0x3a000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_7 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B7 == 1 && NUM_IAHB_SLAVES>6
// 
// Region 2, boot addressing mode, start address for 
// Slave 7. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_7 32'h3a000000


// Name:         R2_B_EA_7
// Default:      0x3a00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_7 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B7 == 1 && NUM_IAHB_SLAVES>6
// 
// Region 2, boot addressing mode, end address for 
// Slave 7. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_7 32'h3a00ffff


// Name:         HSEL_ONLY_S7
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>6
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data, 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S7 0


// Name:         ALIAS_S7
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S7==1 && NUM_IAHB_SLAVES>6
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 7, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S7 = 1.
`define ALIAS_S7 1


// Name:         SPLIT_CAPABLE_7
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>6 && HSEL_ONLY_S7==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S7 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_7 0


// Name:         VISIBLE_8
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>7 && REMAP==1
// 
// Visibility of eighth Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_8 1


// Name:         MR_N8
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_8 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>7
// 
// Number of regions in Normal Mode for Slave 8. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N8 0


// Name:         R1_N_SA_8
// Default:      0x16000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_8 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>7
// 
// Region 1, normal addressing mode, start address for Slave 8. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_8 32'h16000000


// Name:         R1_N_EA_8
// Default:      0x1600ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_8 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>7
// 
// Region 1, normal addressing mode, end address for 
// Slave 8. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_8 32'h1600ffff


// Name:         R2_N_SA_8
// Default:      0x17000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_8 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N8 == 1 && 
//               NUM_IAHB_SLAVES>7
// 
// Region 2, normal addressing mode, start address for 
// Slave 8. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_8 32'h17000000


// Name:         R2_N_EA_8
// Default:      0x1700ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_8 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N8 == 1 && 
//               NUM_IAHB_SLAVES>7
// 
// Region 2, normal addressing mode, end address for 
// Slave 8. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_8 32'h1700ffff


// Name:         MR_B8
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_8 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>7
// 
// Number of regions in Boot Mode for Slave 8. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B8 0


// Name:         R1_B_SA_8
// Default:      0x3b000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_8 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>7
// 
// Region 1, boot addressing mode, start address for 
// Slave 8. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_8 32'h3b000000


// Name:         R1_B_EA_8
// Default:      0x3b00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_8 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>7
// 
// Region 1 boot, addressing mode, end address for 
// Slave 8. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_8 32'h3b00ffff


// Name:         R2_B_SA_8
// Default:      0x3c000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_8 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B8 == 1 && NUM_IAHB_SLAVES>7
// 
// Region 2, boot addressing mode, start address for 
// Slave 8. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_8 32'h3c000000


// Name:         R2_B_EA_8
// Default:      0x3c00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_8 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B8 == 1 && NUM_IAHB_SLAVES>7
// 
// Region 2, boot addressing mode, end address for 
// Slave 8. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_8 32'h3c00ffff


// Name:         HSEL_ONLY_S8
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>7
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data, 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S8 0


// Name:         ALIAS_S8
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S8==1 && NUM_IAHB_SLAVES>7
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 8, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S8 = 1.
`define ALIAS_S8 1


// Name:         SPLIT_CAPABLE_8
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>7 && HSEL_ONLY_S8==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S8 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_8 0


// Name:         VISIBLE_9
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>8 && REMAP==1
// 
// Visibility of ninth Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_9 1


// Name:         MR_N9
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_9 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>8
// 
// Number of regions in Normal Mode for Slave 9. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N9 0


// Name:         R1_N_SA_9
// Default:      0x18000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_9 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>8
// 
// Region 1, normal addressing mode, start address for Slave 9. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_9 32'h18000000


// Name:         R1_N_EA_9
// Default:      0x1800ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_9 != 2 && [<functionof> AHB_HAS_XDCDR] && NUM_IAHB_SLAVES>8
// 
// Region 1, normal addressing mode, end address for 
// Slave 9. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_9 32'h1800ffff


// Name:         R2_N_SA_9
// Default:      0x19000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_9 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N9 == 1 && 
//               NUM_IAHB_SLAVES>8
// 
// Region 2, normal addressing mode, start address for 
// Slave 9. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_9 32'h19000000


// Name:         R2_N_EA_9
// Default:      0x1900ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_9 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N9 == 1 && 
//               NUM_IAHB_SLAVES>8
// 
// Region 2, normal addressing mode, end address for 
// Slave 9. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_9 32'h1900ffff


// Name:         MR_B9
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_9 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>8
// 
// Number of regions in Boot Mode for Slave 9. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B9 0


// Name:         R1_B_SA_9
// Default:      0x3d000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_9 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>8
// 
// Region 1, boot addressing mode, start address for 
// Slave 9. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_9 32'h3d000000


// Name:         R1_B_EA_9
// Default:      0x3d00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_9 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>8
// 
// Region 1 boot, addressing mode, end address for 
// Slave 9. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_9 32'h3d00ffff


// Name:         R2_B_SA_9
// Default:      0x3e000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_9 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B9 == 1 && NUM_IAHB_SLAVES>8
// 
// Region 2, boot addressing mode, start address for 
// Slave 9. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_9 32'h3e000000


// Name:         R2_B_EA_9
// Default:      0x3e00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_9 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B9 == 1 && NUM_IAHB_SLAVES>8
// 
// Region 2, boot addressing mode, end address for 
// Slave 9. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_9 32'h3e00ffff


// Name:         HSEL_ONLY_S9
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>8
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data, 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S9 0


// Name:         ALIAS_S9
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S9==1 && NUM_IAHB_SLAVES>8
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 9, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S9 = 1.
`define ALIAS_S9 1


// Name:         SPLIT_CAPABLE_9
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>8 && HSEL_ONLY_S9==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S9 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_9 0


// Name:         VISIBLE_10
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>9 && REMAP==1
// 
// Visibility of tenth Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_10 1


// Name:         MR_N10
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_10 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>9
// 
// Number of regions in Normal Mode for Slave 10. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N10 0


// Name:         R1_N_SA_10
// Default:      0x1a000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_10 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>9
// 
// Region 1, normal addressing mode, start address for Slave 10. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_10 32'h1a000000


// Name:         R1_N_EA_10
// Default:      0x1a00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_10 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>9
// 
// Region 1, normal addressing mode, end address for 
// Slave 10. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_10 32'h1a00ffff


// Name:         R2_N_SA_10
// Default:      0x1b000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_10 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N10 == 1 && 
//               NUM_IAHB_SLAVES>9
// 
// Region 2, normal addressing mode, start address for 
// Slave 10. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_10 32'h1b000000


// Name:         R2_N_EA_10
// Default:      0x1b00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_10 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N10 == 1 && 
//               NUM_IAHB_SLAVES>9
// 
// Region 2, normal addressing mode, end address for 
// Slave 10. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_10 32'h1b00ffff


// Name:         MR_B10
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_10 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>9
// 
// Number of regions in Boot Mode for Slave 10. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B10 0


// Name:         R1_B_SA_10
// Default:      0x3f000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_10 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>9
// 
// Region 1, boot addressing mode, start address for 
// Slave 10. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_10 32'h3f000000


// Name:         R1_B_EA_10
// Default:      0x3f00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_10 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>9
// 
// Region 1 boot, addressing mode, end address for 
// Slave 10. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_10 32'h3f00ffff


// Name:         R2_B_SA_10
// Default:      0x40000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_10 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B10 == 1 && NUM_IAHB_SLAVES>9
// 
// Region 2, boot addressing mode, start address for 
// Slave 10. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_10 32'h40000000


// Name:         R2_B_EA_10
// Default:      0x4000ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_10 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B10 == 1 && NUM_IAHB_SLAVES>9
// 
// Region 2, boot addressing mode, end address for 
// Slave 10. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_10 32'h4000ffff


// Name:         HSEL_ONLY_S10
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>9
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S10 0


// Name:         ALIAS_S10
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S10==1 && NUM_IAHB_SLAVES>9
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 10, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S10 = 1.
`define ALIAS_S10 1


// Name:         SPLIT_CAPABLE_10
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>9 && HSEL_ONLY_S10==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S10 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_10 0


// Name:         VISIBLE_11
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>10 && REMAP==1
// 
// Visibility of eleventh Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_11 1


// Name:         MR_N11
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_11 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>10
// 
// Number of regions in Normal Mode for Slave 11. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N11 0


// Name:         R1_N_SA_11
// Default:      0x1c000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_11 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>10
// 
// Region 1, normal addressing mode, start address for Slave 11. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_11 32'h1c000000


// Name:         R1_N_EA_11
// Default:      0x1c00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_11 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>10
// 
// Region 1, normal addressing mode, end address for 
// Slave 11. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_11 32'h1c00ffff


// Name:         R2_N_SA_11
// Default:      0x1d000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_11 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N11 == 1 && 
//               NUM_IAHB_SLAVES>10
// 
// Region 2, normal addressing mode, start address for 
// Slave 11. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_11 32'h1d000000


// Name:         R2_N_EA_11
// Default:      0x1d00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_11 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N11 == 1 && 
//               NUM_IAHB_SLAVES>10
// 
// Region 2, normal addressing mode, end address for 
// Slave 11. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_11 32'h1d00ffff


// Name:         MR_B11
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_11 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>10
// 
// Number of regions in Boot Mode for Slave 11. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B11 0


// Name:         R1_B_SA_11
// Default:      0x41000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_11 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>10
// 
// Region 1, boot addressing mode, start address for 
// Slave 11. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_11 32'h41000000


// Name:         R1_B_EA_11
// Default:      0x4100ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_11 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>10
// 
// Region 1 boot, addressing mode, end address for 
// Slave 11. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_11 32'h4100ffff


// Name:         R2_B_SA_11
// Default:      0x42000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_11 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B11 == 1 && NUM_IAHB_SLAVES>10
// 
// Region 2, boot addressing mode, start address for 
// Slave 11. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_11 32'h42000000


// Name:         R2_B_EA_11
// Default:      0x4200ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_11 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B11 == 1 && NUM_IAHB_SLAVES>10
// 
// Region 2, boot addressing mode, end address for 
// Slave 11. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_11 32'h4200ffff


// Name:         HSEL_ONLY_S11
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>10
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S11 0


// Name:         ALIAS_S11
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S11==1 && NUM_IAHB_SLAVES>10
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 11, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S11 = 1.
`define ALIAS_S11 1


// Name:         SPLIT_CAPABLE_11
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>10 && HSEL_ONLY_S11==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S11 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_11 0


// Name:         VISIBLE_12
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>11 && REMAP==1
// 
// Visibility of twelveth Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_12 1


// Name:         MR_N12
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_12 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>11
// 
// Number of regions in Normal Mode for Slave 12. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N12 0


// Name:         R1_N_SA_12
// Default:      0x1e000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_12 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>11
// 
// Region 1, normal addressing mode, start address for Slave 12. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_12 32'h1e000000


// Name:         R1_N_EA_12
// Default:      0x1e00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_12 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>11
// 
// Region 1, normal addressing mode, end address for 
// Slave 12. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_12 32'h1e00ffff


// Name:         R2_N_SA_12
// Default:      0x1f000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_12 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N12 == 1 && 
//               NUM_IAHB_SLAVES>11
// 
// Region 2, normal addressing mode, start address for 
// Slave 12. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_12 32'h1f000000


// Name:         R2_N_EA_12
// Default:      0x1f00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_12 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N12 == 1 && 
//               NUM_IAHB_SLAVES>11
// 
// Region 2, normal addressing mode, end address for 
// Slave 12. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_12 32'h1f00ffff


// Name:         MR_B12
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_12 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>11
// 
// Number of regions in Boot Mode for Slave 12. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B12 0


// Name:         R1_B_SA_12
// Default:      0x43000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_12 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>11
// 
// Region 1, boot addressing mode, start address for 
// Slave 12. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_12 32'h43000000


// Name:         R1_B_EA_12
// Default:      0x4300ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_12 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>11
// 
// Region 1 boot, addressing mode, end address for 
// Slave 12. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_12 32'h4300ffff


// Name:         R2_B_SA_12
// Default:      0x44000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_12 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B12 == 1 && NUM_IAHB_SLAVES>11
// 
// Region 2, boot addressing mode, start address for 
// Slave 12. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_12 32'h44000000


// Name:         R2_B_EA_12
// Default:      0x4400ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_12 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B12 == 1 && NUM_IAHB_SLAVES>11
// 
// Region 2, boot addressing mode, end address for 
// Slave 12. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_12 32'h4400ffff


// Name:         HSEL_ONLY_S12
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>11
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S12 0


// Name:         ALIAS_S12
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S12==1 && NUM_IAHB_SLAVES>11
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 12, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S12 = 1.
`define ALIAS_S12 1


// Name:         SPLIT_CAPABLE_12
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>11 && HSEL_ONLY_S12==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S12 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_12 0


// Name:         VISIBLE_13
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>12 && REMAP==1
// 
// Visibility of thirteenth Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_13 1


// Name:         MR_N13
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_13 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>12
// 
// Number of regions in Normal Mode for Slave 13. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N13 0


// Name:         R1_N_SA_13
// Default:      0x20000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_13 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>12
// 
// Region 1, normal addressing mode, start address for Slave 13. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_13 32'h20000000


// Name:         R1_N_EA_13
// Default:      0x2000ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_13 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>12
// 
// Region 1, normal addressing mode, end address for 
// Slave 13. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_13 32'h2000ffff


// Name:         R2_N_SA_13
// Default:      0x21000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_13 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N13 == 1 && 
//               NUM_IAHB_SLAVES>12
// 
// Region 2, normal addressing mode, start address for 
// Slave 13. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_13 32'h21000000


// Name:         R2_N_EA_13
// Default:      0x2100ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_13 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N13 == 1 && 
//               NUM_IAHB_SLAVES>12
// 
// Region 2, normal addressing mode, end address for 
// Slave 13. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_13 32'h2100ffff


// Name:         MR_B13
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_13 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>12
// 
// Number of regions in Boot Mode for Slave 13. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B13 0


// Name:         R1_B_SA_13
// Default:      0x45000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_13 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>12
// 
// Region 1, boot addressing mode, start address for 
// Slave 13. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_13 32'h45000000


// Name:         R1_B_EA_13
// Default:      0x4500ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_13 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>12
// 
// Region 1 boot, addressing mode, end address for 
// Slave 13. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_13 32'h4500ffff


// Name:         R2_B_SA_13
// Default:      0x46000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_13 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B13 == 1 && NUM_IAHB_SLAVES>12
// 
// Region 2, boot addressing mode, start address for 
// Slave 13. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_13 32'h46000000


// Name:         R2_B_EA_13
// Default:      0x4600ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_13 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B13 == 1 && NUM_IAHB_SLAVES>12
// 
// Region 2, boot addressing mode, end address for 
// Slave 13. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_13 32'h4600ffff


// Name:         HSEL_ONLY_S13
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>12
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S13 0


// Name:         ALIAS_S13
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S13==1 && NUM_IAHB_SLAVES>12
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 13, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S13 = 1.
`define ALIAS_S13 1


// Name:         SPLIT_CAPABLE_13
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>12 && HSEL_ONLY_S13==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S13 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_13 0


// Name:         VISIBLE_14
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>13 && REMAP==1
// 
// Visibility of fourteenth Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_14 1


// Name:         MR_N14
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_14 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>13
// 
// Number of regions in Normal Mode for Slave 14. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N14 0


// Name:         R1_N_SA_14
// Default:      0x22000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_14 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>13
// 
// Region 1, normal addressing mode, start address for Slave 14. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_14 32'h22000000


// Name:         R1_N_EA_14
// Default:      0x2200ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_14 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>13
// 
// Region 1, normal addressing mode, end address for 
// Slave 14. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_14 32'h2200ffff


// Name:         R2_N_SA_14
// Default:      0x23000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_14 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N14 == 1 && 
//               NUM_IAHB_SLAVES>13
// 
// Region 2, normal addressing mode, start address for 
// Slave 14. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_14 32'h23000000


// Name:         R2_N_EA_14
// Default:      0x2300ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_14 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N14 == 1 && 
//               NUM_IAHB_SLAVES>13
// 
// Region 2, normal addressing mode, end address for 
// Slave 14. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_14 32'h2300ffff


// Name:         MR_B14
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_14 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>13
// 
// Number of regions in Boot Mode for Slave 14. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B14 0


// Name:         R1_B_SA_14
// Default:      0x47000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_14 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>13
// 
// Region 1, boot addressing mode, start address for 
// Slave 14. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_14 32'h47000000


// Name:         R1_B_EA_14
// Default:      0x4700ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_14 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>13
// 
// Region 1 boot, addressing mode, end address for 
// Slave 14. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_14 32'h4700ffff


// Name:         R2_B_SA_14
// Default:      0x48000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_14 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B14 == 1 && NUM_IAHB_SLAVES>13
// 
// Region 2, boot addressing mode, start address for 
// Slave 14. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_14 32'h48000000


// Name:         R2_B_EA_14
// Default:      0x4800ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_14 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B14 == 1 && NUM_IAHB_SLAVES>13
// 
// Region 2, boot addressing mode, end address for 
// Slave 14. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_14 32'h4800ffff


// Name:         HSEL_ONLY_S14
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>13
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S14 0


// Name:         ALIAS_S14
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S14==1 && NUM_IAHB_SLAVES>13
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 14, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S14 = 1.
`define ALIAS_S14 1


// Name:         SPLIT_CAPABLE_14
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>13 && HSEL_ONLY_S14==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S14 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_14 0


// Name:         VISIBLE_15
// Default:      Normal
// Values:       Normal (1), Boot (2), Normal & Boot (3)
// Enabled:      NUM_IAHB_SLAVES>14 && REMAP==1
// 
// Visibility of sixteenth Slave, which is visible in 
// Boot Mode, Normal Mode, or both modes.  The number of 
// slaves visible in the system may vary depending on the 
// operating mode. This parameter option is active only 
// if you enable the Memory Remap Feature and have 
// configured to use an internal decoder (AHB_HAS_XDCDR = 0) 
// in the top-level parameter options.
`define VISIBLE_15 1


// Name:         MR_N15
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_15 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>14
// 
// Number of regions in Normal Mode for Slave 15. 
// This parameter option is available only if the Slave 
// Visibility Mode is set to "Normal" or "Normal & Boot". 
// Additionally, this option only applies if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_N15 0


// Name:         R1_N_SA_15
// Default:      0x24000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_15 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>14
// 
// Region 1, normal addressing mode, start address for Slave 15. 
// This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_SA_15 32'h24000000


// Name:         R1_N_EA_15
// Default:      0x2400ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_15 != 2 && [<functionof> AHB_HAS_XDCDR] && 
//               NUM_IAHB_SLAVES>14
// 
// Region 1, normal addressing mode, end address for 
// Slave 15. This parameter option is available only if the 
// "Slave Visibility Mode" is set to "Normal" or "Normal & Boot" 
// and if you have an internal decoder (AHB_HAS_XDCDR = 0).
`define R1_N_EA_15 32'h2400ffff


// Name:         R2_N_SA_15
// Default:      0x25000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_15 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N15 == 1 && 
//               NUM_IAHB_SLAVES>14
// 
// Region 2, normal addressing mode, start address for 
// Slave 15. Specified if the peripheral address region is 
// spread over multiple regions. This parameter option is 
// available only if the "Multiple Memory Regions in Normal Mode" 
// is set to True (1) and if you have an internal decoder 
// (AHB_HAS_XDCDR = 0).
`define R2_N_SA_15 32'h25000000


// Name:         R2_N_EA_15
// Default:      0x2500ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_15 != 2 && [<functionof> AHB_HAS_XDCDR] && MR_N15 == 1 && 
//               NUM_IAHB_SLAVES>14
// 
// Region 2, normal addressing mode, end address for 
// Slave 15. Specified if the peripheral address region 
// is spread over multiple regions. This parameter option 
// is available only if the "Multiple Memory Regions in Normal 
// Mode" is set to True (1) and if you have an internal decoder 
// AHB_HAS_XDCDR = 0).
`define R2_N_EA_15 32'h2500ffff


// Name:         MR_B15
// Default:      false
// Values:       false (0), true (1)
// Enabled:      VISIBLE_15 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>14
// 
// Number of regions in Boot Mode for Slave 15. This parameter 
// option is available only if the Slave Visibility Mode is set to 
// "Boot" or "Normal & Boot". This option applies only if you have 
// an internal decoder (AHB_HAS_XDCDR = 0).
`define MR_B15 0


// Name:         R1_B_SA_15
// Default:      0x49000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_15 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>14
// 
// Region 1, boot addressing mode, start address for 
// Slave 15. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_SA_15 32'h49000000


// Name:         R1_B_EA_15
// Default:      0x4900ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_15 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               NUM_IAHB_SLAVES>14
// 
// Region 1 boot, addressing mode, end address for 
// Slave 15. This option is applicable only if you have an 
// internal decoder (AHB_HAS_XDCDR = 0) and if REMAP = 1.
`define R1_B_EA_15 32'h4900ffff


// Name:         R2_B_SA_15
// Default:      0x4a000000
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_15 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B15 == 1 && NUM_IAHB_SLAVES>14
// 
// Region 2, boot addressing mode, start address for 
// Slave 15. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_SA_15 32'h4a000000


// Name:         R2_B_EA_15
// Default:      0x4a00ffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      VISIBLE_15 != 1 && [<functionof> AHB_HAS_XDCDR] && REMAP == 1 && 
//               MR_B15 == 1 && NUM_IAHB_SLAVES>14
// 
// Region 2, boot addressing mode, end address for 
// Slave 15. This parameter option is available only if 
// "Support Multiple Memory Regions in Boot Mode" is set to 
// True (1), if you have an internal decoder 
// (AHB_HAS_XDCDR = 0), and if REMAP = 1.
`define R2_B_EA_15 32'h4a00ffff


// Name:         HSEL_ONLY_S15
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>14
// 
// When this is active, only the slave select port is 
// generated on the interface. The corresponding data 
// and response ports are taken from another slave, which is 
// specified by the "Number of slave which returns data 
// and response". Even with an external decoder, 
// the generation of select lines only is possible.
`define HSEL_ONLY_S15 0


// Name:         ALIAS_S15
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      HSEL_ONLY_S15==1 && NUM_IAHB_SLAVES>14
// 
// The value must be less than or equal to the value of 
// NUM_IAHB_SLAVES. The value of this parameter cannot equal 15, 
// meaning you cannot alias this slave to itself. This parameter 
// option is available only if the HSEL_ONLY_S15 = 1.
`define ALIAS_S15 1


// Name:         SPLIT_CAPABLE_15
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_IAHB_SLAVES>14 && HSEL_ONLY_S15==0 && AHB_LITE == 0
// 
// If the slave has an hsplit bus, then set this parameter to True(1). 
// When a slave is aliased, it takes its split capability 
// from the aliased slave number. Therefore, this option will be 
// dimmed if the HSEL_ONLY_S15 = 1. 
// This parameter is disabled if AHB lite mode is enabled (AHB_LITE == 1).
`define SPLIT_CAPABLE_15 0


// Name:         AHB_TPS_MODE
// Default:      Clock-Cycle
// Values:       Clock-Cycle (0), Bus-Cycle (1)
// Enabled:      AHB_WTEN == 1 && AHB_HAS_ARBIF == 1 && AHB_LITE == 0
// 
// The token counters can count on clock cycles or 
// on bus cycles to calculate the number of tokens a master is using. 
// Configured AHB is not an AMBA Lite AHB. Enabled if an Arbiter 
// Slave Interface is included and weighted token arbitration 
// has been enabled.
`define AHB_TPS_MODE 0


// Name:         AHB_TCL_WIDTH
// Default:      32
// Values:       4, ..., 32
// Enabled:      AHB_WTEN == 1 && AHB_HAS_ARBIF == 1 && AHB_LITE == 0
// 
// The width of the total counter is configurable and is 
// used to reduce the number of registers required when 
// the design is configured. The counter should be wide 
// enough to count the sum of all the individual master 
// tokens.  
// Enabled if the configured AHB is not an AMBA Lite AHB. 
// Enabled if an Arbiter Slave Interface is included and 
// weighted token arbitration has been enabled.
`define AHB_TCL_WIDTH 32


// Name:         AHB_CCL_WIDTH
// Default:      32
// Values:       4, ..., 32
// Enabled:      AHB_WTEN == 1 && AHB_HAS_ARBIF == 1 && AHB_LITE == 0
// 
// The width of the master counter is configurable and 
// is used to reduce the number of registers required 
// when the design is configured. Each master counter is 
// the same width and needs to be wide enough to count 
// the correct number of tokens for a master. Enabled 
// if the configured AHB is not an AMBA Lite AHB. 
// Enabled if an Arbiter Slave Interface is included and  
// weighted token arbitration has been enabled. 
// The number of bits in the arbitration counter must  
// not be less than the number of bits in the master  
// token counter.
`define AHB_CCL_WIDTH 32


// Name:         AHB_HC_TOKENS
// Default:      true
// Values:       false (0), true (1)
// Enabled:      AHB_WTEN == 1 && AHB_HAS_ARBIF == 1 && AHB_LITE == 0
// 
// Hardcoding programmable registers allows the register count to be reduced. 
// The length of the arbitration period can be hardcoded. 
// The number of tokens for each master can be hard coded. 
// Enabled if the configured AHB is not an AMBA Lite AHB. 
// Enabled if an Arbiter Slave Interface is included and weighted 
// token arbitration has been enabled.
`define AHB_HC_TOKENS 1


// Name:         AHB_TCL
// Default:      0xffff
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && AHB_HAS_ARBIF == 1 && AHB_LITE == 0
// 
// An arbitration period is defined over this number of 
// tokens. When a new arbitration period starts, the master 
// counters are reloaded. On the interface, the output 
// ahb_wt_aps gives a one cycle pulse when a new arbitration 
// period begins. Enabled if the configured AHB is not an AMBA Lite AHB. 
// Enabled if an Arbiter Slave Interface is included and weighted 
// token arbitration has been enabled. The maximum value is 
// controlled by the number of bits in the arbitration counter.
`define AHB_TCL 32'hffff


// Name:         AHB_CL_M1
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && AHB_HAS_ARBIF == 1 && AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M1 32'hf


// Name:         AHB_CL_M2
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>1 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M2 32'hf


// Name:         AHB_CL_M3
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>2 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M3 32'hf


// Name:         AHB_CL_M4
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>3 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M4 32'hf


// Name:         AHB_CL_M5
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>4 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M5 32'hf


// Name:         AHB_CL_M6
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>5 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M6 32'hf


// Name:         AHB_CL_M7
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>6 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M7 32'hf


// Name:         AHB_CL_M8
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>7 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M8 32'hf


// Name:         AHB_CL_M9
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>8 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M9 32'hf


// Name:         AHB_CL_M10
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>9 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M10 32'hf


// Name:         AHB_CL_M11
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>10 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M11 32'hf


// Name:         AHB_CL_M12
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>11 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M12 32'hf


// Name:         AHB_CL_M13
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>12 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M13 32'hf


// Name:         AHB_CL_M14
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>13 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M14 32'hf


// Name:         AHB_CL_M15
// Default:      0xf
// Values:       0x0, ..., 0xffffffff
// Enabled:      AHB_WTEN == 1 && NUM_AHB_MASTERS>14 && AHB_HAS_ARBIF == 1 && 
//               AHB_LITE == 0
// 
// Each master is assigned a number of clock tokens that it can 
// use and be guaranteed to get this number of cycles over 
// an arbitration period. Masters with tokens remaining have 
// priority over masters that have used all of their tokens. 
// User-configured token values are summed to ensure that they 
// do not exceed the total allocated number of tokens. A user 
// can specify any number of tokens for a master. The larger 
// the value, the more the number of tokens. To facilitate an 
// infinite number of tokens, the value of 0 represents infinite 
// tokens. Configured AHB is not an AMBA Lite AHB. Enabled if an 
// Arbiter Slave Interface is included and weighted token 
// arbitration has been enabled. The maximum value is controlled 
// by the number of bits in a master token counter.
`define AHB_CL_M15 32'hf


// Name:         AHB_REQGNT_ONLY_M1
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>1
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M1 0


// Name:         ALIAS_M1
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M1==1 && NUM_AHB_MASTERS>1
// 
// ID Number of master which supplies the address and control
`define ALIAS_M1 1


// Name:         AHB_REQGNT_ONLY_M2
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>1
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M2 0


// Name:         ALIAS_M2
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M2==1 && NUM_AHB_MASTERS>1
// 
// ID Number of master which supplies the address and control
`define ALIAS_M2 1


// Name:         AHB_REQGNT_ONLY_M3
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>2
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M3 0


// Name:         ALIAS_M3
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M3==1 && NUM_AHB_MASTERS>2
// 
// ID Number of master which supplies the address and control
`define ALIAS_M3 1


// Name:         AHB_REQGNT_ONLY_M4
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>3
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M4 0


// Name:         ALIAS_M4
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M4==1 && NUM_AHB_MASTERS>3
// 
// ID Number of master which supplies the address and control
`define ALIAS_M4 1


// Name:         AHB_REQGNT_ONLY_M5
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>4
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M5 0


// Name:         ALIAS_M5
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M5==1 && NUM_AHB_MASTERS>4
// 
// ID Number of master which supplies the address and control
`define ALIAS_M5 1


// Name:         AHB_REQGNT_ONLY_M6
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>5
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M6 0


// Name:         ALIAS_M6
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M6==1 && NUM_AHB_MASTERS>5
// 
// ID Number of master which supplies the address and control
`define ALIAS_M6 1


// Name:         AHB_REQGNT_ONLY_M7
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>6
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M7 0


// Name:         ALIAS_M7
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M7==1 && NUM_AHB_MASTERS>6
// 
// ID Number of master which supplies the address and control
`define ALIAS_M7 1


// Name:         AHB_REQGNT_ONLY_M8
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>7
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M8 0


// Name:         ALIAS_M8
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M8==1 && NUM_AHB_MASTERS>7
// 
// ID Number of master which supplies the address and control
`define ALIAS_M8 1


// Name:         AHB_REQGNT_ONLY_M9
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>8
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M9 0


// Name:         ALIAS_M9
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M9==1 && NUM_AHB_MASTERS>8
// 
// ID Number of master which supplies the address and control
`define ALIAS_M9 1


// Name:         AHB_REQGNT_ONLY_M10
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>9
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M10 0


// Name:         ALIAS_M10
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M10==1 && NUM_AHB_MASTERS>9
// 
// ID Number of master which supplies the address and control
`define ALIAS_M10 1


// Name:         AHB_REQGNT_ONLY_M11
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>10
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M11 0


// Name:         ALIAS_M11
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M11==1 && NUM_AHB_MASTERS>10
// 
// ID Number of master which supplies the address and control
`define ALIAS_M11 1


// Name:         AHB_REQGNT_ONLY_M12
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>11
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M12 0


// Name:         ALIAS_M12
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M12==1 && NUM_AHB_MASTERS>11
// 
// ID Number of master which supplies the address and control
`define ALIAS_M12 1


// Name:         AHB_REQGNT_ONLY_M13
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>12
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M13 0


// Name:         ALIAS_M13
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M13==1 && NUM_AHB_MASTERS>12
// 
// ID Number of master which supplies the address and control
`define ALIAS_M13 1


// Name:         AHB_REQGNT_ONLY_M14
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>13
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M14 0


// Name:         ALIAS_M14
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M14==1 && NUM_AHB_MASTERS>13
// 
// ID Number of master which supplies the address and control
`define ALIAS_M14 1


// Name:         AHB_REQGNT_ONLY_M15
// Default:      false
// Values:       false (0), true (1)
// Enabled:      NUM_AHB_MASTERS>14
// 
// Generate only hgrant and hbusreq for this master as the master has a number 
// of request and grant lines but only one set of control lines.
`define AHB_REQGNT_ONLY_M15 0


// Name:         ALIAS_M15
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
// Enabled:      AHB_REQGNT_ONLY_M15==1 && NUM_AHB_MASTERS>14
// 
// ID Number of master which supplies the address and control
`define ALIAS_M15 1


// Name:         AHB_SINGLE_CYCLE_ARBITRATION
// Default:      false
// Values:       false (0x0), true (0x1)
// Enabled:      AHB_LITE==0
// 
// Allows the arbiter to split on a cycle by cycle basis. 
// Does not split over locked transfers. 
// Will allow the arbitration be broken for fixed length bursts.
`define AHB_SINGLE_CYCLE_ARBITRATION 1'h0


// Name:         XDCDR_SUPPLIES_HSELS2AHB
// Default:      false (AHB_HAS_XDCDR)
// Values:       false (0), true (1)
// Enabled:      [<functionof> AHB_HAS_XDCDR]
// 
// If True (1), the decoder supplies hsels to the DW_ahb for rerouting 
// If False (0), the decoder routes the hsels to the slaves
`define XDCDR_SUPPLIES_HSELS2AHB 0


// Name:         AHB_HAS_SPLIT
// Default:      false ([<functionof> SPLIT_CAPABLE_1 SPLIT_CAPABLE_2 
//               SPLIT_CAPABLE_3 SPLIT_CAPABLE_4 SPLIT_CAPABLE_5 SPLIT_CAPABLE_6 SPLIT_CAPABLE_7 
//               SPLIT_CAPABLE_8 SPLIT_CAPABLE_9 SPLIT_CAPABLE_10 SPLIT_CAPABLE_11 
//               SPLIT_CAPABLE_12 SPLIT_CAPABLE_13 SPLIT_CAPABLE_14 SPLIT_CAPABLE_15 
//               NUM_IAHB_SLAVES ])
// Values:       false (0x0), true (0x1)
// Enabled:      0
// 
// If there are no split capable slaves in the system then there is no need to support splits. 
// We use this parameter to removed the code.
`define AHB_HAS_SPLIT 1'h0


// Name:         AHB_VERSION_ID
// Default:      0x3231302a
// Values:       0x0, ..., 0xffffffff
// 
// Each corekit has a version number. 
// This is reflected in the ascii version number which needs to get translated. 
//  0 => 48 -> 30 
//  1 => 49 -> 31 
//  2 => 50 -> 32 
//  A => 65 -> 41 
//  B => 66 -> 42 
//  C => 67 -> 43 
//  
// Current Version is 2.06* => 32_30_36_2A
`define AHB_VERSION_ID 32'h3231302a


// `define AHB_ENCRYPT

