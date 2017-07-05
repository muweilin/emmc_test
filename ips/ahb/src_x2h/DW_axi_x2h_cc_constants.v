// ---------------------------------------------------------------------
//
//  ------------------------------------------------------------------------
//
//                    (C) COPYRIGHT 2005 - 2014 SYNOPSYS, INC.
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

// 
// Release version :  2.01a
// File Version     :        $Revision: #22 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2h/amba_dev/src/DW_axi_x2h_cc_constants.v#22 $ 
//
// -------------------------------------------------------------------------

// ----------------------------------------
// parameters naming convention
// ----------------------------------------
// X2H_AXI_* : design parameters affecting the bridge AXI interface
// X2H_AHB_* : design parameters affection the bridge AHB interface 
// SIM_* : simulation parameters (do not affect HW)
// 
// ----------------------------------------------------
// design configuration parameters available in the cC
// ----------------------------------------------------


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

// AXI INTERFACE SETUP


// Name:         X2H_AXI_INTERFACE_TYPE
// Default:      AXI3
// Values:       AXI3 (0), AXI4 (1)
// Enabled:      [<functionof> %item]
// 
// Select AXI Interface Type as AXI3 or AXI4.
`define X2H_AXI_INTERFACE_TYPE 1

//Creates a define for AXI3 Interface.

// `define X2H_AXI3_INTERFACE

//Creates a define for AXI4 Interface.

`define X2H_AXI4_INTERFACE


//Width of the AXI Lock bus.
//2 bits in AXI3 and 1 bit in AXI4

`define X2H_AXI_LTW 1


// Name:         X2H_AXI_ADDR_WIDTH
// Default:      32
// Values:       32, ..., 64
// 
// Address bus width of the AXI system to 
// which the bridge is attached as an AXI slave.
`define X2H_AXI_ADDR_WIDTH 32


// Name:         X2H_AXI_DATA_WIDTH
// Default:      32
// Values:       32 64 128 256
// 
// Read and write data bus width of the AXI system to  
// which the bridge is attached as an AXI slave. 
// NOTE: Data bus width for the AXI slave interface must be  
//       greater than or equal to that of the AHB master interface
`define X2H_AXI_DATA_WIDTH 32


// Name:         X2H_AXI_ID_WIDTH
// Default:      16
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
// 
// Read and write ID width of the AXI system to  
// which the bridge is attached as an AXI slave.
`define X2H_AXI_ID_WIDTH 16


// Name:         X2H_AXI_BLW
// Default:      4
// Values:       4 5 6 7 8
// Enabled:      X2H_AXI_INTERFACE_TYPE==1
// 
// Width of the AXI AWLEN and ARLEN burst count fields.
`define X2H_AXI_BLW 8


// Name:         X2H_LOWPWR_HS_IF
// Default:      false
// Values:       false (0), true (1)
// 
// If true, the low-power handshaking interface-csysreq, csysack, and 
// cactive signals and associated control logic is implemented. 
// If false, no support for low-power handshaking interface is provided.
`define X2H_LOWPWR_HS_IF 0


// Name:         X2H_LOWPWR_NOPX_CNT
// Default:      0
// Values:       0, ..., 4294967295
// Enabled:      X2H_LOWPWR_HS_IF==1
// 
// Number of AXI clock cycles to wait before cactive signal de-asserts, 
// when there are no pending transactions. 
// Note that if csysreq de-asserts while waiting this number of cycles, cactive will 
// immediately de-assert. If a new transaction is initiated during the wait period, the 
// counting will be halted, cactive will not de-assert, and the counting will be 
// reinitiated when there are no pending transactions. 
// Available only if X2H_LOWPWR_HS_IF is true
`define X2H_LOWPWR_NOPX_CNT 32'd0

//Creates a define for enabling legacy low power interface

`define X2H_LOWPWR_NOPX_CNT_W 1

// Legacy low power interface selection

`define X2H_LOWPWR_LEGACY_IF 0

//Creates a define for enabling low power interface

// `define X2H_HAS_LOWPWR_HS_IF

//Creates a define for enabling legacy low power interface

// `define X2H_HAS_LOWPWR_LEGACY_IF

//Creates a define for enabling legacy low power interface

`define X2H_AXI_LOW_POWER 0

//Creates a define for calculating the maximum number of pending read transactions

// Name:         X2H_MAX_PENDTRANS_READ
// Default:      4
// Values:       1, ..., 32
// Enabled:      X2H_LOWPWR_HS_IF == 1 ? X2H_LOWPWR_LEGACY_IF == 0 : 0
// 
// Maximum number of AXI read transactions that may be outstanding 
// at any time 
// Available only if X2H_LOWPWR_HS_IF is true
`define X2H_MAX_PENDTRANS_READ 4

//Creates a define for calculating the maximum number of pending write transactions

// Name:         X2H_MAX_PENDTRANS_WRITE
// Default:      4
// Values:       1, ..., 32
// Enabled:      X2H_LOWPWR_HS_IF == 1 ? X2H_LOWPWR_LEGACY_IF == 0 : 0
// 
// Maximum number of AXI write transactions that may be outstanding 
// at any time 
// Available only if X2H_LOWPWR_HS_IF is true
`define X2H_MAX_PENDTRANS_WRITE 4

//Creates a define for calculating the width of the counter needed to 
//keep track of pending requests

`define X2H_CNT_PENDTRANS_READ_W 3

//Creates a define for calculating the width of the counter needed to 
//keep track of pending requests

`define X2H_CNT_PENDTRANS_WRITE_W 3



// Name:         X2H_WRITE_DATA_INTERLEAVING_DEPTH
// Default:      1
// Values:       1, 2
// Enabled:      0
// 
// Write Data Interleaving Depth (per AXI spec definition). 
// In the current version, this is limited to 1, meaning the 
// design does not support Write Data interleaving.
`define X2H_WRITE_DATA_INTERLEAVING_DEPTH 1


// Name:         X2H_EXCLUSIVE_ACCESS_DEPTH
// Default:      0
// Values:       0, ..., 4
// Enabled:      0
// 
// Number of Exclusive accesses supported 
// (The current version of the design does not support any Exclusive Accesses)
`define X2H_EXCLUSIVE_ACCESS_DEPTH 0


// Name:         X2H_AXI_ENDIANNESS
// Default:      Little-Endian
// Values:       Little-Endian (0), Big-Endian (1)
// Enabled:      0
// 
// Data bus endianness of the AXI system to which the 
// bridge is attached as an AXI slave. 
// (The current version only supports Little-Endian)
`define X2H_AXI_ENDIANNESS 0


// Clocking and FIFO setup


// Name:         X2H_CLK_MODE
// Default:      Two Asynchronous Clocks
// Values:       Two Asynchronous Clocks (0), Two Synchronous Clocks (1), Single 
//               Clock (2)
// 
// The bridge AXI slave interface is clocked by aclk 
// The bridge AHB master interface is clocked by mhclk 
// This parameter specifies the relationship between aclk and mhclk. This 
// determines what the bridge does to sychronize between the two domains. 
// 0: aclk and mhclk are different, and completely asynchronous 
// 1: aclk and mhclk are different, one is the multiple of the other 
// 2: aclk and mhclk will both be driven with the same clock signal
`define X2H_CLK_MODE 2

// Internal define for simulation.

`define X2H_CLK_MODE_2


// Name:         X2H_CMD_QUEUE_DEPTH
// Default:      4
// Values:       1 2 4 8 16 32
// 
// Number of locations in the common command queue.  
// The common command queue transfers AXI comands  
// from the bridge AXI slave to the bridge AHB.
`define X2H_CMD_QUEUE_DEPTH 4


// Name:         X2H_WRITE_BUFFER_DEPTH
// Default:      16
// Values:       1 2 4 8 16 32 64
// 
// Number of locations in the write data buffer. The write buffer 
// transfers write data from the bridge 
// AXI slave to the bridge AHB master.
`define X2H_WRITE_BUFFER_DEPTH 16


// Name:         X2H_WRITE_RESP_BUFFER_DEPTH
// Default:      2
// Values:       1 2 4 8 16
// 
// Number of locations in the write response buffer.  
// Contains responses from the AHB Master indicating 
// the AHB completion of the AXI write transfer.
`define X2H_WRITE_RESP_BUFFER_DEPTH 2


// Name:         X2H_READ_BUFFER_DEPTH
// Default:      8
// Values:       1 2 4 8 16 32
// 
// Number of locations in the read data buffer. The read buffer 
// transfers read data from the bridge 
// AHB master to the bridge AXI slave.
`define X2H_READ_BUFFER_DEPTH 8




// AHB INTERFACE SETUP


// Name:         X2H_AHB_ADDR_WIDTH
// Default:      32
// Values:       32 64
// 
// Address bus width of the AHB system to  
// which the bridge is attached as an AHB master.
`define X2H_AHB_ADDR_WIDTH 32


// Name:         X2H_AHB_DATA_WIDTH
// Default:      32
// Values:       32 64 128 256
// 
// Read and write data bus width of the AHB  
// system to which the bridge is attached as an AHB master. 
// NOTE: Data bus width for the AHB master interface must be 
//       less than or equal to that of the AXI slave interface
`define X2H_AHB_DATA_WIDTH 32


// Name:         X2H_AHB_LITE
// Default:      false
// Values:       false (0), true (1)
// 
// Configure the bridge for AHB or AHB-Lite operation.
`define X2H_AHB_LITE 0



// Name:         X2H_PASS_LOCK
// Default:      DO NOT Pass AXI Lock to AHB
// Values:       DO NOT Pass AXI Lock to AHB (0), Pass AXI Lock to AHB (1)
// Enabled:      X2H_AXI_INTERFACE_TYPE==0
// 
// Configure the bridge to get HLOCK on the AHB when performing 
// AXI "Locked access" transfers, in other words to "pass LOCK" 
// from AXI to AHB.
`define X2H_PASS_LOCK 0



// Name:         X2H_USE_DEFINED_ONLY
// Default:      Allow INCR
// Values:       Allow INCR (0), Prohibit INCR (1)
// 
// As AHB Master, the bridge can be allowed to use or prohibited 
// from using the undefined-length INCR burst (defined-length 
// bursts INCR4, INCR8, INCR16 are allowed in either case)
`define X2H_USE_DEFINED_ONLY 0



// Name:         X2H_AHB_BUFFER_POP_MODE
// Default:      Pipeline Both
// Values:       No Pipelining (0), Pipeline Interface AHB Paths (1), Pipeline 
//               Internal AHB Paths (2), Pipeline Both (3)
// 
// This option puts in (or leaves out) pipeline stages, which 
// eases critical timing paths in the AHB clock domain. 
// NO PIPELINE omits pipelining. This saves gates, but it may be hard 
//    to meet timing. 
// PIPELINE INTERFACE AHB PATHS adds pipelining to improve paths from 
//    the AHB bus signals (eg: mhready) to internal flip-flops. 
// PIPELINE INTERNAL AHB PATHS adds pipelining to improve register-to- 
//    register paths inside the DW_axi_x2h. 
// PIPELINE BOTH adds pipelining in both areas, to improve the paths  
//    from the AHB interface and the register-to-register paths.
`define X2H_AHB_BUFFER_POP_MODE 3



// Name:         X2H_AHB_ENDIANNESS
// Default:      Little-Endian
// Values:       Little-Endian (0), Big-Endian (1)
// Enabled:      0
// 
// Data bus endianness of the AHB system to which the 
// bridge is attached as an AHB master. 
// (The current version only supports Little-Endian)
`define X2H_AHB_ENDIANNESS 0





// -------------------------------------
// simulation parameters available in cC
// -------------------------------------

//This is a testbench parameter. The design does not depend on this
//parameter. This parameter specifies the clock period of the primary 
//AXI system (also called AXI system "A") used in the testbench to drive
//the Bridge slave interface. 

`define SIM_A_CLK_PERIOD 100

//This is a testbench parameter. The design does not depend from this
//parameter. This parameter specifies the clock period of the secondary 
//AHB system (also called AHB system "B") used in the testbench to drive
//the Bridge master interface. 

`define SIM_B_CLK_PERIOD 100

// --------------------------------------------------------
// simulation parameters available in cC but not in the GUI
// (used for regressions)
// do not change !
// --------------------------------------------------------

// the number of random sequences for each master to be generated in random test.
// This is a parameter for regressions. Set to 10 for short simulations. 50 is for
// medium simulations (2-3 min). 500 for long simulations (~30 min). 5000 for extra long.

`define SIM_NUM_SEQUENCES 50

// this enables tests to produce additional dump files with information about the 
// random transfers generated, the addresses values observed on the bus etc.

`define SIM_DEBUG_LEVEL 0

// this enables tests to use a variable seed (related with the OS time) to 
// initialize random generators.

`define SIM_USE_VARIABLE_SEED 0

// bus default master

`define SIM_B_DEF_MASTER 0

// ------------------------------------------
// simulation constants used in the testbench
// do not change !
// ------------------------------------------

// clock cycles in a time tick
`define SIM_A_TTICK_CLK_CYCLES 100000
`define SIM_B_TTICK_CLK_CYCLES 51

// primary bus memory map
`define SIM_A_START_ADDR_S1 32'h10000000  /* slave A1 */
`define SIM_A_END_ADDR_S1   32'h1fffffff
`define SIM_A_START_ADDR_S2 32'h20000000  /* bridge A->B */
`define SIM_A_END_ADDR_S2   32'h2fffffff
`define SIM_A_START_ADDR_S3 32'h30000000  /* slave A3 */
`define SIM_A_END_ADDR_S3   32'h3fffffff

// secondary bus memory map
`define SIM_B_START_ADDR_S1 32'h20000000  /* slave B1 */
`define SIM_B_END_ADDR_S1   32'h27ffffff
`define SIM_B_START_ADDR_S3 32'h28000000  /* slave B3 */
`define SIM_B_END_ADDR_S3   32'h2fffffff
`define SIM_B_START_ADDR_S2 32'h30000000  /* bridge A->B */
`define SIM_B_END_ADDR_S2   32'h3fffffff


//----------------------------------------------
// used for the axi to ahb bridge
//----------------------------------------------


`define X2H_SYNC_MODE 2
                        // used only when async clks are used


//----------------------------------------------
// used for the axi to ahb bridge
//----------------------------------------------

// This sets the number of transactions the random test will run

`define AXI_TEST_RAND_XACTNS 200

//----------------------------------------------
// used for the axi to ahb bridge
//----------------------------------------------

// used to allow random generation of default signal levels
// in the regression tests 
// bit 0 for default for RREADY
// bit 1                 BREADY
// 3:2   WSTRB inactive
//   0   low
//   1   prev
//   2   hign

`define AXI_TEST_INACTIVE_SIGNALS 2

/*****************************************/
/*                                       */
/*          BUS DEFINES                  */
/*                                       */
/*****************************************/

`define  X2H_AHB_HTRANS_IDLE    2'b00
`define  X2H_AHB_HTRANS_BUSY    2'b01
`define  X2H_AHB_HTRANS_NONSEQ  2'b10
`define  X2H_AHB_HTRANS_SEQ     2'b11

`define  X2H_AHB_HBURST_SINGLE  3'b000
`define  X2H_AHB_HBURST_INCR    3'b001
`define  X2H_AHB_HBURST_WRAP4   3'b010
`define  X2H_AHB_HBURST_INCR4   3'b011
`define  X2H_AHB_HBURST_WRAP8   3'b100
`define  X2H_AHB_HBURST_INCR8   3'b101
`define  X2H_AHB_HBURST_WRAP16  3'b110
`define  X2H_AHB_HBURST_INCR16  3'b111

`define  X2H_AMBA_SIZE_1BYTE    3'b000
`define  X2H_AMBA_SIZE_2BYTE    3'b001
`define  X2H_AMBA_SIZE_4BYTE    3'b010
`define  X2H_AMBA_SIZE_8BYTE    3'b011
`define  X2H_AMBA_SIZE_16BYTE   3'b100
`define  X2H_AMBA_SIZE_32BYTE   3'b101
`define  X2H_AMBA_SIZE_64BYTE   3'b110

`define  X2H_AXI_BURST_FIXED     2'b00
`define  X2H_AXI_BURST_INCR      2'b01
`define  X2H_AXI_BURST_WRAP      2'b10
`define  X2H_AXI_BURST_RESERVED  2'b11

`define  X2H_AXI_RESP_OKAY       2'b00
`define  X2H_AXI_RESP_EXOKAY     2'b01
`define  X2H_AXI_RESP_SLVERR     2'b10
`define  X2H_AXI_RESP_DECERR     2'b11

`define  X2H_AHB_RESP_OKAY       2'b00
`define  X2H_AHB_RESP_ERROR      2'b01
`define  X2H_AHB_RESP_RETRY      2'b10
`define  X2H_AHB_RESP_SPLIT      2'b11

/*****************************************/
/*                                       */
/*          Derived Values               */
/*                                       */
/*****************************************/
// the following are "derived defines"
// the following will be derived from the X2H_CLK_MODE


`define X2H_AXI_WSTRB_WIDTH  `X2H_AXI_DATA_WIDTH/8
`define X2H_AHB_WSTRB_WIDTH  `X2H_AHB_DATA_WIDTH/8

`define X2H_AXI_WDFIFO_WIDTH  `X2H_AXI_DATA_WIDTH + `X2H_AXI_WSTRB_WIDTH + 1

// Supposed to be lesser of AXI, AHB ADDR widths

`define X2H_CMD_ADDR_WIDTH 32

`define X2H_CMD_QUEUE_WIDTH  `X2H_CMD_ADDR_WIDTH + `X2H_AXI_ID_WIDTH + `X2H_AXI_BLW + 12


// `define X2H_ENCRYPT



`define RM_BCM05 0


`define RM_BCM06 0


`define RM_BCM07 0


`define RM_BCM21 0


`define RM_BCM57 0


`define X2H_PUSH_POP_SYNC_VAL 1


`define CMDQ_CW 3



`define CMDQ_EFF_DEPTH_S2 4


`define CMDQ_EFF_DEPTH 4


