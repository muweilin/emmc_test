/*
------------------------------------------------------------------------
--
--                    (C) COPYRIGHT 2004-2011 SYNOPSYS, INC.
--                            ALL RIGHTS RESERVED
--
--  This software and the associated documentation are confidential and
--  proprietary to Synopsys, Inc.  Your use or disclosure of this
--  software is subject to the terms and conditions of a written
--  license agreement between you, or your company, and Synopsys, Inc.
--
--  The entire notice above must be reproduced on all authorized copies.
--
-- File :                       DW_ahb_arbif.v
-- Author:                      Ray Beechinor 
-- Date :                       $Date: 2011/09/14 $ 
-- Version      :               $Revision: #3 $ 
-- Abstract     :
--
-- AHB Arbiter Slave Interface.   
--
*/

// AHB Arbiter Slave Memory Map Definitions
// Master Priority Registers
`include "DW_amba_constants.v" 
`include "DW_ahb_cc_constants.v"
`include "DW_ahb_constants.v"

`define PL1_OFFSET         10'h000
`define PL2_OFFSET         10'h004
`define PL3_OFFSET         10'h008
`define PL4_OFFSET         10'h00c
`define PL5_OFFSET         10'h010
`define PL6_OFFSET         10'h014
`define PL7_OFFSET         10'h018
`define PL8_OFFSET         10'h01c
`define PL9_OFFSET         10'h020
`define PL10_OFFSET        10'h024
`define PL11_OFFSET        10'h028
`define PL12_OFFSET        10'h02c
`define PL13_OFFSET        10'h030
`define PL14_OFFSET        10'h034
`define PL15_OFFSET        10'h038
`define EBTCOUNT_OFFSET    10'h03c
`define EBT_EN_OFFSET      10'h040
`define EBT_OFFSET         10'h044
`define DFLT_MASTER_OFFSET 10'h048
`define AHB_WTEN_OFFSET    10'h04c
`define AHB_TCL_OFFSET     10'h050
`define AHB_CCLM1_OFFSET   10'h054
`define AHB_CCLM2_OFFSET   10'h058
`define AHB_CCLM3_OFFSET   10'h05c
`define AHB_CCLM4_OFFSET   10'h060
`define AHB_CCLM5_OFFSET   10'h064
`define AHB_CCLM6_OFFSET   10'h068
`define AHB_CCLM7_OFFSET   10'h06c
`define AHB_CCLM8_OFFSET   10'h070
`define AHB_CCLM9_OFFSET   10'h074
`define AHB_CCLM10_OFFSET  10'h078
`define AHB_CCLM11_OFFSET  10'h07c
`define AHB_CCLM12_OFFSET  10'h080
`define AHB_CCLM13_OFFSET  10'h084
`define AHB_CCLM14_OFFSET  10'h088
`define AHB_CCLM15_OFFSET  10'h08c
`define AHB_VID_OFFSET     10'h090

module DW_ahb_arbif (
  hclk,
  hresetn,
  hsel,
  hready,
  hmaster,
  set_ebt,
  haddr,
  htrans,
  hsize,
  hwdata,
  hwrite,
  ahb_big_endian,
  
  hready_resp_s0,
  hresp_s0,
  hrdata_s0,
  clr_arbint,
  ebtcount,
  ebten,
  def_mst,
  bus_priority,
  maskmaster,
  wten,
  bus_ahb_icl,
  ahb_itcl
);

  // physical parameters
  parameter haddr_width = `HADDR_WIDTH;       // 32, 64
  parameter ahb_data_width = `AHB_DATA_WIDTH; // 32, 64, 128, 256
  parameter big_endian = `BIG_ENDIAN;         // 0, 1

  input                             hclk;     
  input                             hresetn;
  input                             hsel;
  input                             hready;
  input [`HMASTER_WIDTH-1:0]        hmaster;
  input                             set_ebt;
  input [haddr_width-1:0]           haddr;
  input [`HTRANS_WIDTH-1:0]         htrans;
  input [`HSIZE_WIDTH-1:0]          hsize;
  input [255:0]                     hwdata;
  input                             hwrite;
  input                             ahb_big_endian;
  
  output                            hready_resp_s0;
  output [`HRESP_WIDTH-1:0]         hresp_s0;
  output [ahb_data_width-1:0]       hrdata_s0;
  output [9:0]                      ebtcount;       // Maximum number of cycles a burst is allowed to take
  output                            ebten;          // When active, transfers can be terminated early
  output [`HMASTER_WIDTH-1:0]       def_mst;        // ID of the default master
  output                            clr_arbint;     // The interrupt is cleared when a read to the terminated address location is performed
  output [(4*(`NUM_INT_MASTERS))-1:0] bus_priority; // all master priorities are combined into single bus
  output [`NUM_AHB_MASTERS:0]       maskmaster;     // Which masters have been masked by priority registers
  output                            wten;           // The weighted token scheme is enabled
  output [`BUS_AHB_CCL_WIDTH-1:0]   bus_ahb_icl;    // 
  output [`AHB_TCL_WIDTH-1:0]       ahb_itcl;       //

  wire                           ahb_activity;      // There is a valid transfer on the bus
  wire                           ahb_owner;         // DW_ahb_arbif is in charge of the bus
  wire                           ahb_valid;         // Valid bus transaction is being carried out by DW_ahb_arbif
  wire                           wen_pl1,  wen_pl2,  wen_pl3,  wen_pl4,  wen_pl5;
  wire                           wen_pl6,  wen_pl7,  wen_pl8,  wen_pl9,  wen_pl10;
  wire                           wen_pl11, wen_pl12, wen_pl13, wen_pl14, wen_pl15;
  wire                           wen_ebtcount;      // Write enable for EBTCOUNT register
  wire                           wen_ebten;         // Write enable for EBTEN register
  wire                           wen_def_mst;       // Write enable for DEFAULT_MASTER register
  wire                           wvr;               // Delayed Write, Delayed Valid and Ready
  wire [255:0]                   int_hrdata_s0;     // Maximum size of internal Data Bus
  wire [15:0]                    int_maskmaster;    // Maximum number of internal mask master
  wire [63:0]                    int_bus_priority;  // Maximum number of priority bits for masters.

  wire [3:0]                     ipl1_next,  ipl2_next,  ipl3_next,  ipl4_next,  ipl5_next;
  wire [3:0]                     ipl6_next,  ipl7_next,  ipl8_next,  ipl9_next,  ipl10_next;
  wire [3:0]                     ipl11_next, ipl12_next, ipl13_next, ipl14_next, ipl15_next;
  wire [9:0]  haddr_mux;         // Address to be used in performing read from DW_ahb_arbif
  wire [9:0]  haddr_mux32;       // Has the lower two bits stripped off
  wire [9:0]  iebtcount_next;    // EBTCOUNT Write Data
  wire [`HMASTER_WIDTH-1:0]      def_mst_next; // Default Master Write Data
  wire                           ahb_act_d;    // Signal indicating that a NONSEQ  or SEQ transfer is in the AMBA Pipeline
  wire                           ahb_valid_d;       // Signal indicating that a valid transfer is in the AMBA Pipeline
  wire                           iebten_next;       // EBTEN Write Data

  reg  [3:0]                      ipl1, ipl2, ipl3, ipl4, ipl5, ipl6, ipl7, ipl8, ipl9, ipl10, ipl11, ipl12, ipl13, ipl14, ipl15;
  wire [3:0]                      pl1, pl2, pl3, pl4, pl5, pl6, pl7, pl8, pl9, pl10, pl11, pl12, pl13, pl14, pl15;

  reg  [9:0]                      iebtcount; // early burst termination counter register
  reg                             iebten;    // early burst termination enable register
  reg  [3:0]                      idef_mst;  // Default Master Register
  reg                             r_hready_resp_s0;   
  reg                             nxt_hready_resp;
  reg  [`HRESP_WIDTH-1:0]         r_hresp_s0;
  reg                             clr_arbint;
  reg                             r_hwrite_d;      
  reg                             r_hsel_arb_d;
  reg  [`HMASTER_WIDTH-1:0]       r_hmaster_d;
  reg  [haddr_width-1:0]          r_haddr_d;
  reg  [`HTRANS_WIDTH-1:0]        r_htrans_d;
  reg  [`HSIZE_WIDTH-1:0]         r_hsize_d;
  wire [haddr_width-1:0]          haddr_d;
  wire [`HTRANS_WIDTH-1:0]        htrans_d;
  wire [`HSIZE_WIDTH-1:0]         hsize_d;
  wire                            hwrite_d;      
  wire                            hsel_arb_d;
  wire [`HMASTER_WIDTH-1:0]       hmaster_d;

  wire [1:0]                      state;
  wire                            ebt;
  reg  [1:0]                      r_state;
  reg  [1:0]                      nxt_state;
  reg  [31:0]                     hwdata_lem; // Write Data in Little Endian form
  reg  [`AHB_MAX_ARBIF_WIDTH-1:0] min_ihrdata;
  reg  [31:0]                     pre_ihrdata;
  reg  [31:0]                     ihrdata;
  reg  [31:0]                     n_hrdata;
  reg  [31:0]                     ireg_hrdata;
  reg                             int_ebt;
  reg                             valid_haddr;// Address is within defined DW_ahb_arbif memory map
//
// The following are passed the value of ahb_ccl_m(x) when the relevant master
// is present. Otherwise they are set to zero.
//
  wire [`AHB_CCL_WIDTH-1:0]       int_ahb_ccl_m1,  int_ahb_ccl_m2,  int_ahb_ccl_m3,  int_ahb_ccl_m4,  int_ahb_ccl_m5;
  wire [`AHB_CCL_WIDTH-1:0]       int_ahb_ccl_m6,  int_ahb_ccl_m7,  int_ahb_ccl_m8,  int_ahb_ccl_m9,  int_ahb_ccl_m10;
  wire [`AHB_CCL_WIDTH-1:0]       int_ahb_ccl_m11, int_ahb_ccl_m12, int_ahb_ccl_m13, int_ahb_ccl_m14, int_ahb_ccl_m15;
//
// wten is the weighted token enable, the following are the register write
// enable, the next value to be written when the enable is high and also the
// internal register value
//
  wire                            wten;
  reg                             iwten;
  wire                            iwten_next;
  wire                            wen_wten;
//
// Regardless of the width of the token counter, they are expanded
// to 32-bits with leading zeroes so they can be read through the
// AHB interface.
//
  reg  [31:0]                     iint_ahb_ccl_m1,  iint_ahb_ccl_m2,  iint_ahb_ccl_m3,  iint_ahb_ccl_m4,  iint_ahb_ccl_m5;
  reg  [31:0]                     iint_ahb_ccl_m6,  iint_ahb_ccl_m7,  iint_ahb_ccl_m8,  iint_ahb_ccl_m9,  iint_ahb_ccl_m10;
  reg  [31:0]                     iint_ahb_ccl_m11, iint_ahb_ccl_m12, iint_ahb_ccl_m13, iint_ahb_ccl_m14, iint_ahb_ccl_m15;
//
// The overall period counter is used to load the master tokens into counters
//
  wire [31:0]                     iahb_tcl_next;
  wire [`AHB_TCL_WIDTH-1:0]       riahb_tcl;
  wire [`AHB_TCL_WIDTH-1:0]       iahb_tcl;
  reg  [31:0]                     fiahb_tcl;
  reg  [31:0]                     int_ahb_tcl;
  wire [31:0]                     rv_fiahb_tcl;
  wire                            wen_ahb_tcl;
//
// Configuration register for the number of clock tokens for a master.
//
  reg  [31:0]       fiahb_ccl_m1,  fiahb_ccl_m2,  fiahb_ccl_m3,  fiahb_ccl_m4,  fiahb_ccl_m5;
  reg  [31:0]       fiahb_ccl_m6,  fiahb_ccl_m7,  fiahb_ccl_m8,  fiahb_ccl_m9,  fiahb_ccl_m10;
  reg  [31:0]       fiahb_ccl_m11, fiahb_ccl_m12, fiahb_ccl_m13, fiahb_ccl_m14, fiahb_ccl_m15;
  wire [`AHB_CCL_WIDTH-1:0]       iahb_ccl_m1,   iahb_ccl_m2,   iahb_ccl_m3,   iahb_ccl_m4,   iahb_ccl_m5;
  wire [`AHB_CCL_WIDTH-1:0]       iahb_ccl_m6,   iahb_ccl_m7,   iahb_ccl_m8,   iahb_ccl_m9,   iahb_ccl_m10;
  wire [`AHB_CCL_WIDTH-1:0]       iahb_ccl_m11,  iahb_ccl_m12,  iahb_ccl_m13,  iahb_ccl_m14,  iahb_ccl_m15;
//
// Holds either the configuration value or the hardcoded value of the
// number of clock tokens for a master.
//
  wire [`AHB_CCL_WIDTH-1:0]       riahb_ccl_m1,  riahb_ccl_m2,  riahb_ccl_m3,  riahb_ccl_m4,  riahb_ccl_m5;
  wire [`AHB_CCL_WIDTH-1:0]       riahb_ccl_m6,  riahb_ccl_m7,  riahb_ccl_m8,  riahb_ccl_m9,  riahb_ccl_m10;
  wire [`AHB_CCL_WIDTH-1:0]       riahb_ccl_m11, riahb_ccl_m12, riahb_ccl_m13, riahb_ccl_m14, riahb_ccl_m15;
//
// The next value to be written into the configuration register.
//
  wire [31:0]       iahb_ccl_m1_next,  iahb_ccl_m2_next,  iahb_ccl_m3_next,  iahb_ccl_m4_next,  iahb_ccl_m5_next;
  wire [31:0]       iahb_ccl_m6_next,  iahb_ccl_m7_next,  iahb_ccl_m8_next,  iahb_ccl_m9_next,  iahb_ccl_m10_next;
  wire [31:0]       iahb_ccl_m11_next, iahb_ccl_m12_next, iahb_ccl_m13_next, iahb_ccl_m14_next, iahb_ccl_m15_next;

  wire                            wen_ccl_m1,  wen_ccl_m2,  wen_ccl_m3,  wen_ccl_m4,  wen_ccl_m5;
  wire                            wen_ccl_m6,  wen_ccl_m7,  wen_ccl_m8,  wen_ccl_m9,  wen_ccl_m10;
  wire                            wen_ccl_m11, wen_ccl_m12, wen_ccl_m13, wen_ccl_m14, wen_ccl_m15;
  wire                            ahb_little_endian;
  wire [31:0]                     iahb_version_id;
  wire [9:0]                      haddr32;
  wire [9:0]                      haddr_d32;
  reg  [3:0]                      byte_en_d;
  wire [31:0]                     rv_fiahb_ccl_m1,  rv_fiahb_ccl_m2,  rv_fiahb_ccl_m3,  rv_fiahb_ccl_m4,  rv_fiahb_ccl_m5;
  wire [31:0]                     rv_fiahb_ccl_m6,  rv_fiahb_ccl_m7,  rv_fiahb_ccl_m8,  rv_fiahb_ccl_m9,  rv_fiahb_ccl_m10;
  wire [31:0]                     rv_fiahb_ccl_m11, rv_fiahb_ccl_m12, rv_fiahb_ccl_m13, rv_fiahb_ccl_m14, rv_fiahb_ccl_m15;

  parameter   ST_NORM  = 2'b00;
  parameter   ST_READ  = 2'b01;
  parameter   ST_WRITE = 2'b10;
  parameter   ST_ERROR = 2'b11;

//
// The AHB slave must only respond to a valid transfer. When HREADY
// and HSEL are both active
//

  assign   ahb_activity = ((htrans != `IDLE) && (htrans != `BUSY));
  assign   ahb_owner = ((hsel == 1'b1)  && (hready == 1'b1));
  assign   ahb_valid = ((ahb_owner == 1'b1) && (ahb_activity == 1'b1));

//
// Need to bring along the address qualification to where the data is
// going to be so that the address can be written to or read from
// correctly.
//
  always @(posedge hclk or negedge hresetn)
  begin : hsel_arb_d_PROC
    if (hresetn == 1'b0) begin
      r_hsel_arb_d <= 1'b0;
    end else begin
      if (hready == 1'b1) begin
        r_hsel_arb_d <= hsel && (hsize <= `WORD);
      end
    end
  end

  always @(posedge hclk or negedge hresetn)
  begin : AC_PROC
    if (hresetn == 1'b0) begin
      r_haddr_d   <= {`HADDR_WIDTH{1'b0}};
      r_htrans_d  <= 2'b0;
      r_hwrite_d  <= 1'b0;
      r_hsize_d   <= 3'b0;
      r_hmaster_d <= 4'b0;
    end else begin
      if (hready == 1'b1) begin
        r_haddr_d   <= haddr;
        r_htrans_d  <= htrans;
        r_hwrite_d  <= hwrite;
        r_hsize_d   <= hsize;
        r_hmaster_d <= hmaster;
      end
    end
  end
  assign hsel_arb_d = (`AHB_HAS_ARBIF == 1) ? r_hsel_arb_d : 1'b0;
  assign hwrite_d   = (`AHB_HAS_ARBIF == 1) ? r_hwrite_d   : 1'b0;
  assign haddr_d    = (`AHB_HAS_ARBIF == 1) ? r_haddr_d    : {haddr_width{1'b0}};
  assign htrans_d   = (`AHB_HAS_ARBIF == 1) ? r_htrans_d   : {`HTRANS_WIDTH{1'b0}};
  assign hsize_d    = (`AHB_HAS_ARBIF == 1) ? r_hsize_d    : {`HMASTER_WIDTH{1'b0}};
  assign hmaster_d  = (`AHB_HAS_ARBIF == 1) ? r_hmaster_d  : {`HMASTER_WIDTH{1'b0}};

  assign ahb_act_d = ((htrans_d != `IDLE) && (htrans_d != `BUSY));
  assign ahb_valid_d = ((ahb_act_d == 1'b1) && (hsel_arb_d == 1'b1));

//
// Check that the current address is in the Arbiters address range
// Will only be in the map if the number of masters is valid
//
//#
//# As the address will not always be 32-bit aligned we strip off the lower two bits in the address decode.
//# In 8-bit accesses  we will generate the byte cotrol from haddr[1:0]
//# In 16-bit accesses we will generate the byte contrl from haddr[1]
//#
  assign haddr32 = {haddr[9:2], 2'b0};
  always @ (haddr32)
  begin : valid_haddr_PROC
    valid_haddr = 1'b0;
    case (haddr32[9:0])
      `PL1_OFFSET         : valid_haddr = 1'b1;
      `PL2_OFFSET         : if (`NUM_AHB_MASTERS > 1)  valid_haddr = 1'b1;
      `PL3_OFFSET         : if (`NUM_AHB_MASTERS > 2)  valid_haddr = 1'b1;
      `PL4_OFFSET         : if (`NUM_AHB_MASTERS > 3)  valid_haddr = 1'b1;
      `PL5_OFFSET         : if (`NUM_AHB_MASTERS > 4)  valid_haddr = 1'b1;
      `PL6_OFFSET         : if (`NUM_AHB_MASTERS > 5)  valid_haddr = 1'b1;
      `PL7_OFFSET         : if (`NUM_AHB_MASTERS > 6)  valid_haddr = 1'b1;
      `PL8_OFFSET         : if (`NUM_AHB_MASTERS > 7)  valid_haddr = 1'b1;
      `PL9_OFFSET         : if (`NUM_AHB_MASTERS > 8)  valid_haddr = 1'b1;
      `PL10_OFFSET        : if (`NUM_AHB_MASTERS > 9)  valid_haddr = 1'b1;
      `PL11_OFFSET        : if (`NUM_AHB_MASTERS > 10) valid_haddr = 1'b1;
      `PL12_OFFSET        : if (`NUM_AHB_MASTERS > 11) valid_haddr = 1'b1;
      `PL13_OFFSET        : if (`NUM_AHB_MASTERS > 12) valid_haddr = 1'b1;
      `PL14_OFFSET        : if (`NUM_AHB_MASTERS > 13) valid_haddr = 1'b1;
      `PL15_OFFSET        : if (`NUM_AHB_MASTERS > 14) valid_haddr = 1'b1;
      `EBTCOUNT_OFFSET    : if (`EBTEN == 1'b1) valid_haddr = 1'b1;
      `EBT_EN_OFFSET      : if (`EBTEN == 1'b1) valid_haddr = 1'b1;
      `EBT_OFFSET         : if (`EBTEN == 1'b1) valid_haddr = 1'b1;
      `DFLT_MASTER_OFFSET : valid_haddr = 1'b1;
      `AHB_WTEN_OFFSET    : if (`AHB_WTEN == 1'b1) valid_haddr = 1'b1;
      `AHB_TCL_OFFSET     : if (`AHB_WTEN == 1'b1) valid_haddr = 1'b1;
      `AHB_CCLM1_OFFSET   : if (`AHB_WTEN == 1'b1) valid_haddr = 1'b1; 
      `AHB_CCLM2_OFFSET   : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 1))  valid_haddr = 1'b1; 
      `AHB_CCLM3_OFFSET   : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 2))  valid_haddr = 1'b1; 
      `AHB_CCLM4_OFFSET   : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 3))  valid_haddr = 1'b1; 
      `AHB_CCLM5_OFFSET   : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 4))  valid_haddr = 1'b1; 
      `AHB_CCLM6_OFFSET   : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 5))  valid_haddr = 1'b1; 
      `AHB_CCLM7_OFFSET   : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 6))  valid_haddr = 1'b1; 
      `AHB_CCLM8_OFFSET   : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 7))  valid_haddr = 1'b1; 
      `AHB_CCLM9_OFFSET   : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 8))  valid_haddr = 1'b1; 
      `AHB_CCLM10_OFFSET  : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 9))  valid_haddr = 1'b1; 
      `AHB_CCLM11_OFFSET  : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 10)) valid_haddr = 1'b1; 
      `AHB_CCLM12_OFFSET  : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 11)) valid_haddr = 1'b1; 
      `AHB_CCLM13_OFFSET  : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 12)) valid_haddr = 1'b1; 
      `AHB_CCLM14_OFFSET  : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 13)) valid_haddr = 1'b1; 
      `AHB_CCLM15_OFFSET  : if ((`AHB_WTEN == 1'b1) && (`NUM_AHB_MASTERS > 14)) valid_haddr = 1'b1; 
      `AHB_VID_OFFSET     : valid_haddr = 1'b1;
      default             : valid_haddr = 1'b0;
    endcase
  end

//
// Need to send a response back to the master to indicate what one
// done with the transfer
//
  always @(posedge hclk or negedge hresetn)
  begin : r_hresp_s0_PROC
    if (hresetn == 1'b0) begin
      r_hresp_s0 <= `OKAY;
    end else begin
      if ((state == ST_ERROR) || (nxt_state == ST_ERROR))
        r_hresp_s0 <= `ERROR;
      else
        r_hresp_s0 <= `OKAY;
    end
  end
  assign hresp_s0 = (`AHB_HAS_ARBIF == 1'b1) ? r_hresp_s0 : {`HRESP_WIDTH{1'b0}};
//
// Deciding to stall the master if one reads from the same address that
// one is just after writing to. This may be unnecessary overhead in the
// design and one just should insert an IDLE if they want to do a write
// directly followed by a read of the same address. Then the slaves's
// hready response is always ready unless the first cycle of an ERROR
// response is happening when hready is pulled low.
//
  always @(posedge hclk or negedge hresetn)
  begin : hready_resp_s0_PROC
    if (hresetn == 1'b0)
      r_hready_resp_s0 <= 1'b1;
    else
      r_hready_resp_s0 <= nxt_hready_resp;
  end
  assign hready_resp_s0 = (`AHB_HAS_ARBIF == 1'b1) ? r_hready_resp_s0 : 1'b1;

  always @(state or nxt_state or haddr or haddr_d)
  begin : nxt_hready_resp_PROC
    if (((state == ST_WRITE) && 
          (nxt_state == ST_READ) &&
          (haddr[9:0] == haddr_d[9:0])) ||
         (nxt_state == ST_ERROR))
      nxt_hready_resp = 1'b0;
    else
      nxt_hready_resp = 1'b1;
  end

//
// Need to be able to say that in the previous cycle we were
// doing a read or a write. Each state has the same exit conditions
//
  always @(posedge hclk or negedge hresetn)
  begin : state_PROC
    if (hresetn == 1'b0)
      r_state <= ST_NORM;
    else
      r_state <= nxt_state;
  end
  assign state = (`AHB_HAS_ARBIF == 1'b1) ? r_state : ST_NORM;
  
  always @(state or ahb_valid or hwrite or valid_haddr or hsize)
  begin : nxt_state_PROC
    case (state)
      ST_NORM,
      ST_WRITE,
      ST_READ  : 
        if (ahb_valid == 1'b1)
          if ((valid_haddr == 1'b1) && ((hsize <= `WORD)))
            if (hwrite == 1'b1)
              nxt_state = ST_WRITE;
            else
              nxt_state = ST_READ;
          else
            nxt_state = ST_ERROR;
        else
          nxt_state = ST_NORM;
      default  : nxt_state = ST_NORM;
    endcase
  end

//
// Need to look at the previous control signals and one knows these
// are not going to change until hready is active and also when hready
// is active this is where the write data is going to be supplied.
//
//# The address haddr_d32 is a 32-bit aligned address. The lower two bits are forced as
//# zeroes. This ensures that the write enable will be active to the register regardless
//# of the width. There will be a seperate byte enable for the four bytes.
//#
  assign haddr_d32 = {haddr_d[9:2], 2'b0};
  assign wvr = ((hwrite_d == 1'b1) && (ahb_valid_d == 1'b1) && (hready == 1'b1));

//#
//# The write data is going to be in Little Endian Modified Format no need to translate the byte enables.
//#
  always @(haddr_d or hsize_d)
  begin : byte_en_d_PROC
//#
//# This is a 32-bit bus, but we can accept 8/16/32 bit transfers.
//#
    if (hsize_d == `BYTE)
      case(haddr_d[1:0])
        2'b00   : byte_en_d = 4'b0001;
        2'b01   : byte_en_d = 4'b0010;
        2'b10   : byte_en_d = 4'b0100;
        default : byte_en_d = 4'b1000;
      endcase
     else if (hsize_d == `HWORD)
       if(haddr_d[1])
         byte_en_d = 4'b1100;
       else
         byte_en_d = 4'b0011;
     else
       byte_en_d = 4'b1111;
  end

  assign wen_pl1      = ((haddr_d32[9:0] == `PL1_OFFSET)         && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl2      = ((haddr_d32[9:0] == `PL2_OFFSET)         && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl3      = ((haddr_d32[9:0] == `PL3_OFFSET)         && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl4      = ((haddr_d32[9:0] == `PL4_OFFSET)         && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl5      = ((haddr_d32[9:0] == `PL5_OFFSET)         && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl6      = ((haddr_d32[9:0] == `PL6_OFFSET)         && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl7      = ((haddr_d32[9:0] == `PL7_OFFSET)         && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl8      = ((haddr_d32[9:0] == `PL8_OFFSET)         && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl9      = ((haddr_d32[9:0] == `PL9_OFFSET)         && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl10     = ((haddr_d32[9:0] == `PL10_OFFSET)        && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl11     = ((haddr_d32[9:0] == `PL11_OFFSET)        && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl12     = ((haddr_d32[9:0] == `PL12_OFFSET)        && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl13     = ((haddr_d32[9:0] == `PL13_OFFSET)        && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl14     = ((haddr_d32[9:0] == `PL14_OFFSET)        && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_pl15     = ((haddr_d32[9:0] == `PL15_OFFSET)        && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_ebtcount = ((haddr_d32[9:0] == `EBTCOUNT_OFFSET)    && (wvr == 1'b1));
  assign wen_ebten    = ((haddr_d32[9:0] == `EBT_EN_OFFSET)      && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_def_mst  = ((haddr_d32[9:0] == `DFLT_MASTER_OFFSET) && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_wten     = ((haddr_d32[9:0] == `AHB_WTEN_OFFSET)    && (wvr == 1'b1) && (byte_en_d[0] == 1'b1));
  assign wen_ahb_tcl  = ((haddr_d32[9:0] == `AHB_TCL_OFFSET)     && (wvr == 1'b1));
  assign wen_ccl_m1   = ((haddr_d32[9:0] == `AHB_CCLM1_OFFSET)   && (wvr == 1'b1));
  assign wen_ccl_m2   = ((haddr_d32[9:0] == `AHB_CCLM2_OFFSET)   && (wvr == 1'b1));
  assign wen_ccl_m3   = ((haddr_d32[9:0] == `AHB_CCLM3_OFFSET)   && (wvr == 1'b1));
  assign wen_ccl_m4   = ((haddr_d32[9:0] == `AHB_CCLM4_OFFSET)   && (wvr == 1'b1));
  assign wen_ccl_m5   = ((haddr_d32[9:0] == `AHB_CCLM5_OFFSET)   && (wvr == 1'b1));
  assign wen_ccl_m6   = ((haddr_d32[9:0] == `AHB_CCLM6_OFFSET)   && (wvr == 1'b1));
  assign wen_ccl_m7   = ((haddr_d32[9:0] == `AHB_CCLM7_OFFSET)   && (wvr == 1'b1));
  assign wen_ccl_m8   = ((haddr_d32[9:0] == `AHB_CCLM8_OFFSET)   && (wvr == 1'b1));
  assign wen_ccl_m9   = ((haddr_d32[9:0] == `AHB_CCLM9_OFFSET)   && (wvr == 1'b1));
  assign wen_ccl_m10  = ((haddr_d32[9:0] == `AHB_CCLM10_OFFSET)  && (wvr == 1'b1));
  assign wen_ccl_m11  = ((haddr_d32[9:0] == `AHB_CCLM11_OFFSET)  && (wvr == 1'b1));
  assign wen_ccl_m12  = ((haddr_d32[9:0] == `AHB_CCLM12_OFFSET)  && (wvr == 1'b1));
  assign wen_ccl_m13  = ((haddr_d32[9:0] == `AHB_CCLM13_OFFSET)  && (wvr == 1'b1));
  assign wen_ccl_m14  = ((haddr_d32[9:0] == `AHB_CCLM14_OFFSET)  && (wvr == 1'b1));
  assign wen_ccl_m15  = ((haddr_d32[9:0] == `AHB_CCLM15_OFFSET)  && (wvr == 1'b1));

// Need to convert data on Write Data Bus to Little Endian Format

  assign ahb_little_endian = (`AHB_XENDIAN == 1'b1) ? (ahb_big_endian == 1'b0) : (big_endian == 1'b0);
  
  always @ (hwdata or haddr_d or ahb_little_endian)
  begin : hwdata_lem_PROC
    if (ahb_little_endian == 1'b1)
      if (ahb_data_width == 32)
        hwdata_lem = hwdata[31:0];
      else if (ahb_data_width == 8)
        hwdata_lem = {hwdata[7:0],hwdata[7:0],hwdata[7:0],hwdata[7:0]};
      else if (ahb_data_width == 16)
        hwdata_lem = {hwdata[15:0],hwdata[15:0]};
      else if (ahb_data_width == 64)
        if (haddr_d[2]) begin
          hwdata_lem = hwdata[63:32];
        end else begin
          hwdata_lem = hwdata[31:0]; 
        end
      else if (ahb_data_width == 128)
        case (haddr_d[3:2])
          2'h1    : hwdata_lem = hwdata[63:32];
          2'h2    : hwdata_lem = hwdata[95:64];
          2'h3    : hwdata_lem = hwdata[127:96];
          default : hwdata_lem = hwdata[31:0];
        endcase
      else
        case (haddr_d[4:2])
          3'h1    : hwdata_lem = hwdata[63:32];
          3'h2    : hwdata_lem = hwdata[95:64];
          3'h3    : hwdata_lem = hwdata[127:96];
          3'h4    : hwdata_lem = hwdata[159:128];
          3'h5    : hwdata_lem = hwdata[191:160];
          3'h6    : hwdata_lem = hwdata[223:192];
          3'h7    : hwdata_lem = hwdata[255:224];
          default : hwdata_lem = hwdata[31:0];
        endcase
    else
      if (ahb_data_width == 32)
        { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[31:0];
      else if (ahb_data_width == 8)
        { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = { hwdata[7:0],hwdata[7:0],hwdata[7:0],hwdata[7:0] };
      else if (ahb_data_width == 16)
        { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = { hwdata[15:0],hwdata[15:0] };
      else if (ahb_data_width == 64)
        if (haddr_d[2])
           { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[31:0];
        else
           { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[63:32];
      else if (ahb_data_width == 128)
        case (haddr_d[3:2])
          2'h1    : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[95:64];
          2'h2    : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[63:32];
          2'h3    : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[31:0];
          default : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[127:96];
        endcase
      else
        case (haddr_d[4:2])
          3'h1    : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[223:192];
          3'h2    : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[191:160];
          3'h3    : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[159:128];
          3'h4    : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[127:96];
          3'h5    : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[95:64];
          3'h6    : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[63:32];
          3'h7    : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[31:0];
          default : { hwdata_lem[7:0],hwdata_lem[15:8],hwdata_lem[23:16],hwdata_lem[31:24] } = hwdata[255:224];
    endcase
  end

//
// Do not update the priorities if they are been written to by
// the same master as the priority corresponds to, if the data
// been written to is all zeroes, which would disable the master
//
  assign ipl1_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl1_PROC
    if (hresetn == 1'b0) begin
      ipl1 <= `PRIORITY_1;
    end else begin
      if (wen_pl1 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd1) && (ipl1_next == 0)) begin
          ipl1 <= ipl1;
        end else begin
          ipl1 <= ipl1_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl1 = ((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_1 : ipl1;

  assign ipl2_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl2_PROC
    if (hresetn == 1'b0) begin
      ipl2 <= `PRIORITY_2;
    end else begin
      if (wen_pl2 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd2) && (ipl2_next == 0)) begin
          ipl2 <= ipl2;
        end else begin
          ipl2 <= ipl2_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl2 = (`NUM_AHB_MASTERS< 2) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_2 : ipl2);

  assign ipl3_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl3_PROC
    if (hresetn == 1'b0) begin
      ipl3 <= `PRIORITY_3;
    end else begin
      if (wen_pl3 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd3) && (ipl3_next == 0)) begin
          ipl3 <= ipl3;
        end else begin
          ipl3 <= ipl3_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl3 = (`NUM_AHB_MASTERS< 3) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_3 : ipl3);

  assign ipl4_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl4_PROC
    if (hresetn == 1'b0) begin
      ipl4 <= `PRIORITY_4;
    end else begin
      if (wen_pl4 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd4) && (ipl4_next == 0)) begin
          ipl4 <= ipl4;
        end else begin
          ipl4 <= ipl4_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl4 = (`NUM_AHB_MASTERS< 4) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_4 : ipl4);

  assign ipl5_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl5_PROC
    if (hresetn == 1'b0) begin
      ipl5 <= `PRIORITY_5;
    end else begin
      if (wen_pl5 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd5) && (ipl5_next == 0)) begin
          ipl5 <= ipl5;
        end else begin
          ipl5 <= ipl5_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl5 = (`NUM_AHB_MASTERS< 5) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_5 : ipl5);

  assign ipl6_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn) 
  begin : ipl6_PROC
    if (hresetn == 1'b0) begin
      ipl6 <= `PRIORITY_6;
    end else begin
      if (wen_pl6 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd6) && (ipl6_next == 0)) begin
          ipl6 <= ipl6;
        end else begin
          ipl6 <= ipl6_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl6 = (`NUM_AHB_MASTERS< 6) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_6 : ipl6);

  assign ipl7_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl7_PROC
    if (hresetn == 1'b0) begin
      ipl7 <= `PRIORITY_7;
    end else begin
      if (wen_pl7 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd7) && (ipl7_next == 0)) begin
          ipl7 <= ipl7;
        end else begin
          ipl7 <= ipl7_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl7 = (`NUM_AHB_MASTERS< 7) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_7 : ipl7);

  assign ipl8_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl8_PROC
    if (hresetn == 1'b0) begin
     ipl8 <= `PRIORITY_8;
    end else begin
      if (wen_pl8 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd8) && (ipl8_next == 0)) begin
          ipl8 <= ipl8;
        end else begin
          ipl8 <= ipl8_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl8 = (`NUM_AHB_MASTERS< 8) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_8 : ipl8);

  assign ipl9_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl9_PROC
    if (hresetn == 1'b0) begin
      ipl9 <= `PRIORITY_9;
    end else begin
      if (wen_pl9 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd9) && (ipl9_next == 0)) begin
          ipl9 <= ipl9;
        end else begin
          ipl9 <= ipl9_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl9 = (`NUM_AHB_MASTERS< 9) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_9 : ipl9);

  assign ipl10_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl10_PROC
    if (hresetn == 1'b0) begin
      ipl10 <= `PRIORITY_10;
    end else begin
      if (wen_pl10 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd10) && (ipl10_next == 0)) begin
          ipl10 <= ipl10;
        end else begin
          ipl10 <= ipl10_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl10 = (`NUM_AHB_MASTERS< 10) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_10 : ipl10);

  assign ipl11_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl11_PROC
    if (hresetn == 1'b0) begin
      ipl11 <= `PRIORITY_11;
    end else begin
      if (wen_pl11 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd11) && (ipl11_next == 0)) begin
          ipl11 <= ipl11;
        end else begin
          ipl11 <= ipl11_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl11 = (`NUM_AHB_MASTERS< 11) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_11 : ipl11);

  assign ipl12_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl12_PROC
    if (hresetn == 1'b0) begin
      ipl12 <= `PRIORITY_12;
    end else begin
      if (wen_pl12 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd12) && (ipl12_next == 0)) begin
          ipl12 <= ipl12;
        end else begin
          ipl12 <= ipl12_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl12 = (`NUM_AHB_MASTERS< 12) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_12 : ipl12);

  assign ipl13_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl13_PROC
    if (hresetn == 1'b0) begin
      ipl13 <= `PRIORITY_13;
    end else begin
      if (wen_pl13 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd13) && (ipl13_next == 0)) begin
          ipl13 <= ipl13;
        end else begin
          ipl13 <= ipl13_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl13 = (`NUM_AHB_MASTERS< 13) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_13 : ipl13);

  assign ipl14_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl14_PROC
    if (hresetn == 1'b0) begin
      ipl14 <= `PRIORITY_14;
    end else begin
      if (wen_pl14 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
        if ((hmaster_d == 4'd14) && (ipl14_next == 0)) begin
          ipl14 <= ipl14;
        end else begin
          ipl14 <= ipl14_next;
        end
	// leda W631 on
      end
    end
  end
  assign pl14 = (`NUM_AHB_MASTERS< 14) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_14 : ipl14);

  assign ipl15_next  = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : ipl15_PROC
    if (hresetn == 1'b0) begin
      ipl15 <= `PRIORITY_15;
    end else begin
      if (wen_pl15 == 1'b1) begin
	// leda W631 off
	// W631: Assigning to self. This is harmless but can reduce
	// simulation speed
	if ((hmaster_d == 4'd15) && (ipl15_next == 0)) begin
	  ipl15 <= ipl15;
	end else begin
	  ipl15 <= ipl15_next;
	end
	// leda W631 on
      end
    end
  end
  assign pl15 = (`NUM_AHB_MASTERS< 15) ? 4'b 0 :
               (((`AHB_HAS_ARBIF == 0) || (`HC_PRIORITIES == 1)) ? `PRIORITY_15 : ipl15);

//
// iebtcount is the maximum number of hclk cycles the early burst
// counter is allowed to take when early burst termination is enabled.
//

  assign iebtcount_next = hwdata_lem[9:0];
  always @(posedge hclk or negedge hresetn)
  begin : iebtcount_PROC
    if (hresetn == 1'b0) begin
      iebtcount <= 10'b0;
    end else begin
      if (wen_ebtcount == 1'b1) begin
        if (byte_en_d[1]) iebtcount[9:8] <= iebtcount_next[9:8];
        if (byte_en_d[0]) iebtcount[7:0] <= iebtcount_next[7:0];
      end
    end
  end

  assign iebten_next    = hwdata_lem[0];
  always @(posedge hclk or negedge hresetn)
  begin : iebten_PROC
    if (hresetn == 1'b0) begin
      iebten <= 1'b0;
    end else begin
      if (wen_ebten == 1'b1) begin
        iebten <= iebten_next;
      end
    end
  end

  assign ebtcount = ((`EBTEN == 1'b0) || (`AHB_HAS_ARBIF == 1'b0)) ? 10'b0 : iebtcount;
  assign ebten    = ((`EBTEN == 1'b0) || (`AHB_HAS_ARBIF == 1'b0)) ? 1'b0 : iebten;

  assign def_mst_next   = hwdata_lem[3:0];
  always @(posedge hclk or negedge hresetn)
  begin : def_mst_PROC
    if (hresetn == 1'b0) begin
      idef_mst <= `DFLT_MSTR_NUM;
    end else begin
      if (wen_def_mst == 1'b1) begin
        if (def_mst_next > `NUM_AHB_MASTERS) begin
          idef_mst <= {`HMASTER_WIDTH{1'b0}};
        end else begin
          idef_mst <= def_mst_next;
        end
      end
    end
  end
  assign def_mst = ((`HC_DFLT_MSTR == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `DFLT_MSTR_NUM : idef_mst;

  always @ (posedge hclk or negedge hresetn)
  begin : int_ebt_PROC
    if (hresetn == 1'b0)
      int_ebt <= 1'b0;
    else begin
      if (set_ebt == 1'b1)
        int_ebt <= 1'b1;
      else begin
        if (clr_arbint == 1'b1)
          int_ebt <= 1'b0;
      end 
    end
  end
  assign ebt = ((`EBTEN == 1'b1) && (`AHB_HAS_ARBIF == 1'b1)) ? int_ebt : 1'b0;

// The Interrupt Register for the Early Burst Termination feature is
// in DW_ahb_ebt.  It is cleared when the ebt register is 
// read

  always @ (haddr or ahb_valid or hwrite)
  begin : clr_arbint_PROC
    if ((ahb_valid == 1'b1) && 
        (hwrite    == 1'b0) &&
        (haddr[9:0] == `EBT_OFFSET))
      clr_arbint = 1'b1;
    else
      clr_arbint = 1'b0;
  end
   
//
// wten : Inidicates there is a weighted token scheme in place
//

  assign iwten_next = hwdata_lem[0];
  always @(posedge hclk or negedge hresetn)
  begin : iwten_PROC
    if (hresetn == 1'b0) begin
      iwten <= 1'b0;
    end else begin
      if (wen_wten == 1'b1) begin
        iwten <= iwten_next;
      end
    end
  end

  assign wten = ((`AHB_WTEN == 1'b1) && (`AHB_HAS_ARBIF == 1'b1)) ? iwten : 1'b0;

//
// ahb_itcl :
//

  assign iahb_tcl_next = hwdata_lem[`AHB_TCL_WIDTH-1:0];
  assign rv_fiahb_tcl = `AHB_TCL;
  always @(posedge hclk or negedge hresetn)
  begin : fiahb_tcl_PROC
    if (hresetn == 1'b0) begin
      fiahb_tcl <= rv_fiahb_tcl;
    end else begin
      if (wen_ahb_tcl == 1'b1) begin
        if (byte_en_d[3]) fiahb_tcl[31:24] <= iahb_tcl_next[31:24];
        if (byte_en_d[2]) fiahb_tcl[23:16] <= iahb_tcl_next[23:16];
        if (byte_en_d[1]) fiahb_tcl[15:8]  <= iahb_tcl_next[15:8];
        if (byte_en_d[0]) fiahb_tcl[7:0]   <= iahb_tcl_next[7:0];
      end
    end
  end
  assign iahb_tcl = fiahb_tcl[`AHB_TCL_WIDTH-1:0];
  assign riahb_tcl = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_TCL : iahb_tcl;
  assign ahb_itcl = riahb_tcl;
//
// To read back through interface this needs to be 32-bits wide.
//
  always @(riahb_tcl)
  begin
    int_ahb_tcl = 32'b0;
    int_ahb_tcl[`AHB_TCL_WIDTH-1:0] = riahb_tcl;
  end

//#
//# ahb_ccl_m1
//#

  assign iahb_ccl_m1_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m1 = `AHB_CL_M1;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m1_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m1 <= `AHB_CL_M1;
    end else begin
      if (wen_ccl_m1 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m1[31:24] <= iahb_ccl_m1_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m1[23:16] <= iahb_ccl_m1_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m1[15:8]  <= iahb_ccl_m1_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m1[7:0]   <= iahb_ccl_m1_next[7:0];
      end
    end
  end
  assign iahb_ccl_m1 = fiahb_ccl_m1[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m1 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M1 : iahb_ccl_m1;

//#
//# ahb_ccl_m2
//#

  assign iahb_ccl_m2_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m2 = `AHB_CL_M2;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m2_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m2 <= `AHB_CL_M2;
    end else begin
      if (wen_ccl_m2 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m2[31:24] <= iahb_ccl_m2_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m2[23:16] <= iahb_ccl_m2_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m2[15:8]  <= iahb_ccl_m2_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m2[7:0]   <= iahb_ccl_m2_next[7:0];
      end
    end
  end
  assign iahb_ccl_m2 = fiahb_ccl_m2[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m2 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M2 : iahb_ccl_m2;

//#
//# ahb_ccl_m3
//#

  assign iahb_ccl_m3_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m3 = `AHB_CL_M3;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m3_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m3 <= `AHB_CL_M3;
    end else begin
      if (wen_ccl_m3 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m3[31:24] <= iahb_ccl_m3_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m3[23:16] <= iahb_ccl_m3_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m3[15:8]  <= iahb_ccl_m3_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m3[7:0]   <= iahb_ccl_m3_next[7:0];
      end
    end
  end
  assign iahb_ccl_m3 = fiahb_ccl_m3[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m3 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M3 : iahb_ccl_m3;

//#
//# ahb_ccl_m4
//#

  assign iahb_ccl_m4_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m4 = `AHB_CL_M4;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m4_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m4 <= `AHB_CL_M4;
    end else begin
      if (wen_ccl_m4 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m4[31:24] <= iahb_ccl_m4_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m4[23:16] <= iahb_ccl_m4_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m4[15:8]  <= iahb_ccl_m4_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m4[7:0]   <= iahb_ccl_m4_next[7:0];
      end
    end
  end
  assign iahb_ccl_m4 = fiahb_ccl_m4[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m4 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M4 : iahb_ccl_m4;

//#
//# ahb_ccl_m5
//#

  assign iahb_ccl_m5_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m5 = `AHB_CL_M5;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m5_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m5 <= `AHB_CL_M5;
    end else begin
      if (wen_ccl_m5 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m5[31:24] <= iahb_ccl_m5_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m5[23:16] <= iahb_ccl_m5_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m5[15:8]  <= iahb_ccl_m5_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m5[7:0]   <= iahb_ccl_m5_next[7:0];
      end
    end
  end
  assign iahb_ccl_m5 = fiahb_ccl_m5[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m5 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M5 : iahb_ccl_m5;

//#
//# ahb_ccl_m6
//#

  assign iahb_ccl_m6_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m6 = `AHB_CL_M6;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m6_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m6 <= `AHB_CL_M6;
    end else begin
      if (wen_ccl_m6 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m6[31:24] <= iahb_ccl_m6_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m6[23:16] <= iahb_ccl_m6_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m6[15:8]  <= iahb_ccl_m6_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m6[7:0]   <= iahb_ccl_m6_next[7:0];
      end
    end
  end
  assign iahb_ccl_m6 = fiahb_ccl_m6[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m6 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M6 : iahb_ccl_m6;

//#
//# ahb_ccl_m7
//#

  assign iahb_ccl_m7_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m7 = `AHB_CL_M7;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m7_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m7 <= `AHB_CL_M7;
    end else begin
      if (wen_ccl_m7 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m7[31:24] <= iahb_ccl_m7_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m7[23:16] <= iahb_ccl_m7_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m7[15:8]  <= iahb_ccl_m7_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m7[7:0]   <= iahb_ccl_m7_next[7:0];
      end
    end
  end
  assign iahb_ccl_m7 = fiahb_ccl_m7[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m7 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M7 : iahb_ccl_m7;

//#
//# ahb_ccl_m8
//#

  assign iahb_ccl_m8_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m8 = `AHB_CL_M8;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m8_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m8 <= `AHB_CL_M8;
    end else begin
      if (wen_ccl_m8 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m8[31:24] <= iahb_ccl_m8_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m8[23:16] <= iahb_ccl_m8_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m8[15:8]  <= iahb_ccl_m8_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m8[7:0]   <= iahb_ccl_m8_next[7:0];
      end
    end
  end
  assign iahb_ccl_m8 = fiahb_ccl_m8[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m8 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M8 : iahb_ccl_m8;

//#
//# ahb_ccl_m9
//#

  assign iahb_ccl_m9_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m9 = `AHB_CL_M9;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m9_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m9 <= `AHB_CL_M9;
    end else begin
      if (wen_ccl_m9 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m9[31:24] <= iahb_ccl_m9_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m9[23:16] <= iahb_ccl_m9_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m9[15:8]  <= iahb_ccl_m9_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m9[7:0]   <= iahb_ccl_m9_next[7:0];
      end
    end
  end
  assign iahb_ccl_m9 = fiahb_ccl_m9[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m9 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M9 : iahb_ccl_m9;

//#
//# ahb_ccl_m10
//#

  assign iahb_ccl_m10_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m10 = `AHB_CL_M10;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m10_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m10 <= `AHB_CL_M10;
    end else begin
      if (wen_ccl_m10 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m10[31:24] <= iahb_ccl_m10_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m10[23:16] <= iahb_ccl_m10_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m10[15:8]  <= iahb_ccl_m10_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m10[7:0]   <= iahb_ccl_m10_next[7:0];
      end
    end
  end
  assign iahb_ccl_m10 = fiahb_ccl_m10[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m10 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M10 : iahb_ccl_m10;

//#
//# ahb_ccl_m11
//#

  assign iahb_ccl_m11_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m11 = `AHB_CL_M11;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m11_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m11 <= `AHB_CL_M11;
    end else begin
      if (wen_ccl_m11 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m11[31:24] <= iahb_ccl_m11_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m11[23:16] <= iahb_ccl_m11_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m11[15:8]  <= iahb_ccl_m11_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m11[7:0]   <= iahb_ccl_m11_next[7:0];
      end
    end
  end
  assign iahb_ccl_m11 = fiahb_ccl_m11[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m11 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M11 : iahb_ccl_m11;

//#
//# ahb_ccl_m12
//#

  assign iahb_ccl_m12_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m12 = `AHB_CL_M12;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m12_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m12 <= `AHB_CL_M12;
    end else begin
      if (wen_ccl_m12 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m12[31:24] <= iahb_ccl_m12_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m12[23:16] <= iahb_ccl_m12_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m12[15:8]  <= iahb_ccl_m12_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m12[7:0]   <= iahb_ccl_m12_next[7:0];
      end
    end
  end
  assign iahb_ccl_m12 = fiahb_ccl_m12[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m12 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M12 : iahb_ccl_m12;

//#
//# ahb_ccl_m13
//#

  assign iahb_ccl_m13_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m13 = `AHB_CL_M13;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m13_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m13 <= `AHB_CL_M13;
    end else begin
      if (wen_ccl_m13 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m13[31:24] <= iahb_ccl_m13_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m13[23:16] <= iahb_ccl_m13_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m13[15:8]  <= iahb_ccl_m13_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m13[7:0]   <= iahb_ccl_m13_next[7:0];
      end
    end
  end
  assign iahb_ccl_m13 = fiahb_ccl_m13[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m13 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M13 : iahb_ccl_m13;

//#
//# ahb_ccl_m14
//#

  assign iahb_ccl_m14_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m14 = `AHB_CL_M14;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m14_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m14 <= `AHB_CL_M14;
    end else begin
      if (wen_ccl_m14 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m14[31:24] <= iahb_ccl_m14_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m14[23:16] <= iahb_ccl_m14_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m14[15:8]  <= iahb_ccl_m14_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m14[7:0]   <= iahb_ccl_m14_next[7:0];
      end
    end
  end
  assign iahb_ccl_m14 = fiahb_ccl_m14[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m14 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M14 : iahb_ccl_m14;

//#
//# ahb_ccl_m15
//#

  assign iahb_ccl_m15_next = hwdata_lem[`AHB_CCL_WIDTH-1:0];
  assign rv_fiahb_ccl_m15 = `AHB_CL_M15;
  always @(posedge hclk or negedge hresetn)
  begin : iahb_ccl_m15_PROC
    if (hresetn == 1'b0) begin
      fiahb_ccl_m15 <= `AHB_CL_M15;
    end else begin
      if (wen_ccl_m15 == 1'b1) begin
        if (byte_en_d[3]) fiahb_ccl_m15[31:24] <= iahb_ccl_m15_next[31:24];
        if (byte_en_d[2]) fiahb_ccl_m15[23:16] <= iahb_ccl_m15_next[23:16];
        if (byte_en_d[1]) fiahb_ccl_m15[15:8]  <= iahb_ccl_m15_next[15:8];
        if (byte_en_d[0]) fiahb_ccl_m15[7:0]   <= iahb_ccl_m15_next[7:0];
      end
    end
  end
  assign iahb_ccl_m15 = fiahb_ccl_m15[`AHB_CCL_WIDTH-1:0];
  assign riahb_ccl_m15 = ((`AHB_HC_TOKENS == 1) || (`AHB_HAS_ARBIF == 1'b0)) ? `AHB_CL_M15 : iahb_ccl_m15;

//
//
//
  assign haddr_mux   = hready_resp_s0 ? haddr[9:0] : haddr_d[9:0];
  assign haddr_mux32 = {haddr_mux[9:2],2'b0};

//
// Whenever an invalid address is read then we will be generating an
// error or else have an error after the first phase of the two cycle
// error response.
// In this case make sure the data returned is always zero.
// Will only ever access a valid register when we sample haddr_mux.
// Do not need to worry about number of masters etc as this is covered
// with the valid_haddr which is used to generate the nxt_state.
//
  always @(posedge hclk or negedge hresetn)
  begin : ireg_hrdata_PROC
    if (hresetn == 1'b0) begin
      ireg_hrdata <= {`AHB_MAX_ARBIF_WIDTH{1'b0}};
    end else begin
      if ((state == ST_ERROR) || (nxt_state == ST_ERROR)) begin
        ireg_hrdata <= {`AHB_MAX_ARBIF_WIDTH{1'b0}};
      end else begin
        if (((ahb_valid == 1'b1)   && 
               (hwrite == 1'b0)      && 
               (nxt_hready_resp == 1'b1)) ||
             ((ahb_valid_d == 1'b1) && 
               (hwrite_d == 1'b0)    && 
               (hready_resp_s0 == 1'b0))) begin
           if (ahb_data_width == 8)
             case (haddr_mux[1:0])
               2'b00   : ireg_hrdata <= n_hrdata[7:0];
               2'b01   : ireg_hrdata <= n_hrdata[15:8];
               2'b10   : ireg_hrdata <= n_hrdata[23:16];
               default : ireg_hrdata <= n_hrdata[31:24];
             endcase
           else if (ahb_data_width == 16)
             if (haddr_mux[1] == 1'b0)
               if (ahb_little_endian) ireg_hrdata <= n_hrdata[15:0];
               else                   ireg_hrdata <= {n_hrdata[7:0],n_hrdata[15:8]};
             else
               if (ahb_little_endian) ireg_hrdata <= n_hrdata[31:16]; 
               else                   ireg_hrdata <= {n_hrdata[23:16],n_hrdata[31:24]};
           else
             if (ahb_little_endian) ireg_hrdata <= n_hrdata[31:0]; 
             else                   ireg_hrdata <= {n_hrdata[7:0],n_hrdata[15:8],n_hrdata[23:16],n_hrdata[31:24]};
        end
      end
    end
  end

  always @(haddr_mux32 or pl1 or pl2 or pl3 or pl4 or pl5 or pl6 or pl7 or pl8 or pl9 or pl10 or pl11 or pl12 or pl13 or pl14 or pl15 or ebtcount or ebten or ebt or def_mst or wten or int_ahb_tcl or iint_ahb_ccl_m1 or iint_ahb_ccl_m2 or iint_ahb_ccl_m3 or iint_ahb_ccl_m4 or iint_ahb_ccl_m5 or iint_ahb_ccl_m6 or iint_ahb_ccl_m7 or iint_ahb_ccl_m8 or iint_ahb_ccl_m9 or iint_ahb_ccl_m10 or iint_ahb_ccl_m11 or iint_ahb_ccl_m12 or iint_ahb_ccl_m13 or iint_ahb_ccl_m14 or iint_ahb_ccl_m15 or iahb_version_id)
  begin
    case (haddr_mux32)
      `PL1_OFFSET         : n_hrdata = {28'b0,pl1};
      `PL2_OFFSET         : n_hrdata = {28'b0,pl2};
      `PL3_OFFSET         : n_hrdata = {28'b0,pl3};
      `PL4_OFFSET         : n_hrdata = {28'b0,pl4};
      `PL5_OFFSET         : n_hrdata = {28'b0,pl5};
      `PL6_OFFSET         : n_hrdata = {28'b0,pl6};
      `PL7_OFFSET         : n_hrdata = {28'b0,pl7};
      `PL8_OFFSET         : n_hrdata = {28'b0,pl8};
      `PL9_OFFSET         : n_hrdata = {28'b0,pl9};
      `PL10_OFFSET        : n_hrdata = {28'b0,pl10};
      `PL11_OFFSET        : n_hrdata = {28'b0,pl11};
      `PL12_OFFSET        : n_hrdata = {28'b0,pl12};
      `PL13_OFFSET        : n_hrdata = {28'b0,pl13};
      `PL14_OFFSET        : n_hrdata = {28'b0,pl14};
      `PL15_OFFSET        : n_hrdata = {28'b0,pl15};
      `EBTCOUNT_OFFSET    : n_hrdata = {22'b0,ebtcount};
      `EBT_EN_OFFSET      : n_hrdata = {31'b0,ebten};
      `EBT_OFFSET         : n_hrdata = {31'b0,ebt};
      `DFLT_MASTER_OFFSET : n_hrdata = {24'b0,def_mst};
      `AHB_WTEN_OFFSET    : n_hrdata = {31'b0,wten};
      `AHB_TCL_OFFSET     : n_hrdata = (`AHB_WTEN == 1) ? int_ahb_tcl      : 32'b0;
      `AHB_CCLM1_OFFSET   : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m1  : 32'b0;
      `AHB_CCLM2_OFFSET   : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m2  : 32'b0;
      `AHB_CCLM3_OFFSET   : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m3  : 32'b0;
      `AHB_CCLM4_OFFSET   : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m4  : 32'b0;
      `AHB_CCLM5_OFFSET   : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m5  : 32'b0;
      `AHB_CCLM6_OFFSET   : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m6  : 32'b0;
      `AHB_CCLM7_OFFSET   : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m7  : 32'b0;
      `AHB_CCLM8_OFFSET   : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m8  : 32'b0;
      `AHB_CCLM9_OFFSET   : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m9  : 32'b0;
      `AHB_CCLM10_OFFSET  : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m10 : 32'b0;
      `AHB_CCLM11_OFFSET  : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m11 : 32'b0;
      `AHB_CCLM12_OFFSET  : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m12 : 32'b0;
      `AHB_CCLM13_OFFSET  : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m13 : 32'b0;
      `AHB_CCLM14_OFFSET  : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m14 : 32'b0;
      `AHB_CCLM15_OFFSET  : n_hrdata = (`AHB_WTEN == 1) ? iint_ahb_ccl_m15 : 32'b0;
      `AHB_VID_OFFSET     : n_hrdata = iahb_version_id;
      default             : n_hrdata = 32'b0;
    endcase
  end

  assign iahb_version_id = `AHB_VERSION_ID;

//#
//# Want to ensure only the required number of registers are instaniated
//# When there is no arbiter interface then registers are not required.
//# When the ahb_data_width is 8 bits    we want an  8-bit register
//# When the ahb_data_width is 16-bits   we want a  16-bit register
//# When the ahb_data_width is > 32-bits we want a  32-bit register
//# Any endianess conversion happens before the register
//#
  always @(*)
  begin : min_ihrdata_PROC
    min_ihrdata = {`AHB_MAX_ARBIF_WIDTH{1'b0}};
    if (`AHB_HAS_ARBIF == 1) begin
      min_ihrdata[`AHB_MAX_ARBIF_WIDTH-1:0] = ireg_hrdata[`AHB_MAX_ARBIF_WIDTH-1:0];
    end
  end
  always @(min_ihrdata)
  begin
    ihrdata = 32'b0;
    ihrdata[`AHB_MAX_ARBIF_WIDTH-1:0] = min_ihrdata;
  end

  assign int_hrdata_s0[31:0]    = ihrdata[31:0];
  assign int_hrdata_s0[63:32]   = int_hrdata_s0[31:0];
  assign int_hrdata_s0[95:64]   = int_hrdata_s0[31:0];
  assign int_hrdata_s0[127:96]  = int_hrdata_s0[31:0];
  assign int_hrdata_s0[159:128] = int_hrdata_s0[31:0];
  assign int_hrdata_s0[191:160] = int_hrdata_s0[31:0];
  assign int_hrdata_s0[223:192] = int_hrdata_s0[31:0];
  assign int_hrdata_s0[255:224] = int_hrdata_s0[31:0];

  assign hrdata_s0 = int_hrdata_s0[ahb_data_width-1:0];

//
// Priorities to DW_ahb_bcm53 are inverted as DW_ahb_bcm53 
// interprets a priority of 1 as higher than a priority 15, and 
// priority 0 is disabled.
//
      
  assign int_maskmaster[0]  = 1'b0;
  assign int_maskmaster[1]  = (pl1[3:0] == 4'b0);
  assign int_maskmaster[2]  = (`NUM_AHB_MASTERS >= 2)  ? (pl2[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[3]  = (`NUM_AHB_MASTERS >= 3)  ? (pl3[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[4]  = (`NUM_AHB_MASTERS >= 4)  ? (pl4[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[5]  = (`NUM_AHB_MASTERS >= 5)  ? (pl5[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[6]  = (`NUM_AHB_MASTERS >= 6)  ? (pl6[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[7]  = (`NUM_AHB_MASTERS >= 7)  ? (pl7[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[8]  = (`NUM_AHB_MASTERS >= 8)  ? (pl8[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[9]  = (`NUM_AHB_MASTERS >= 9)  ? (pl9[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[10] = (`NUM_AHB_MASTERS >= 10) ? (pl10[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[11] = (`NUM_AHB_MASTERS >= 11) ? (pl11[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[12] = (`NUM_AHB_MASTERS >= 12) ? (pl12[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[13] = (`NUM_AHB_MASTERS >= 13) ? (pl13[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[14] = (`NUM_AHB_MASTERS >= 14) ? (pl14[3:0] == 4'b0) : 1'b0;
  assign int_maskmaster[15] = (`NUM_AHB_MASTERS == 15) ? (pl15[3:0] == 4'b0) : 1'b0;

// Stripping off the unwanted bits

  assign maskmaster = int_maskmaster[`NUM_AHB_MASTERS:0];

  assign int_bus_priority[3:0]   = 4'hf;
  assign int_bus_priority[7:4]   = ~pl1[3:0];
  assign int_bus_priority[11:8]  = ~pl2[3:0];
  assign int_bus_priority[15:12] = ~pl3[3:0];
  assign int_bus_priority[19:16] = ~pl4[3:0];
  assign int_bus_priority[23:20] = ~pl5[3:0];
  assign int_bus_priority[27:24] = ~pl6[3:0];
  assign int_bus_priority[31:28] = ~pl7[3:0];
  assign int_bus_priority[35:32] = ~pl8[3:0];
  assign int_bus_priority[39:36] = ~pl9[3:0];
  assign int_bus_priority[43:40] = ~pl10[3:0];
  assign int_bus_priority[47:44] = ~pl11[3:0];
  assign int_bus_priority[51:48] = ~pl12[3:0];
  assign int_bus_priority[55:52] = ~pl13[3:0];
  assign int_bus_priority[59:56] = ~pl14[3:0];
  assign int_bus_priority[63:60] = ~pl15[3:0];

// Stripping off the unwanted bits

  assign bus_priority = int_bus_priority[(4*(`NUM_INT_MASTERS))-1:0];

//
// When a master is not used then when the value is read back it must be zero.
// Override the register or hard coded value for zero when not required.
//
  assign int_ahb_ccl_m1  =                            riahb_ccl_m1;
  assign int_ahb_ccl_m2  = (`NUM_AHB_MASTERS >= 2)  ? riahb_ccl_m2  : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m3  = (`NUM_AHB_MASTERS >= 3)  ? riahb_ccl_m3  : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m4  = (`NUM_AHB_MASTERS >= 4)  ? riahb_ccl_m4  : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m5  = (`NUM_AHB_MASTERS >= 5)  ? riahb_ccl_m5  : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m6  = (`NUM_AHB_MASTERS >= 6)  ? riahb_ccl_m6  : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m7  = (`NUM_AHB_MASTERS >= 7)  ? riahb_ccl_m7  : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m8  = (`NUM_AHB_MASTERS >= 8)  ? riahb_ccl_m8  : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m9  = (`NUM_AHB_MASTERS >= 9)  ? riahb_ccl_m9  : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m10 = (`NUM_AHB_MASTERS >= 10) ? riahb_ccl_m10 : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m11 = (`NUM_AHB_MASTERS >= 11) ? riahb_ccl_m11 : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m12 = (`NUM_AHB_MASTERS >= 12) ? riahb_ccl_m12 : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m13 = (`NUM_AHB_MASTERS >= 13) ? riahb_ccl_m13 : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m14 = (`NUM_AHB_MASTERS >= 14) ? riahb_ccl_m14 : {`AHB_CCL_WIDTH{1'b0}};
  assign int_ahb_ccl_m15 = (`NUM_AHB_MASTERS >= 15) ? riahb_ccl_m15 : {`AHB_CCL_WIDTH{1'b0}};

  always @(int_ahb_ccl_m1)
  begin : iint_ahb_ccl_m1_PROC
    iint_ahb_ccl_m1 = 32'b0;
    iint_ahb_ccl_m1[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m1;
  end

  always @(int_ahb_ccl_m2)
  begin : iint_ahb_ccl_m2_PROC
    iint_ahb_ccl_m2 = 32'b0;
    iint_ahb_ccl_m2[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m2;
  end

  always @(int_ahb_ccl_m3)
  begin : iint_ahb_ccl_m3_PROC
    iint_ahb_ccl_m3 = 32'b0;
    iint_ahb_ccl_m3[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m3;
  end

  always @(int_ahb_ccl_m4)
  begin : iint_ahb_ccl_m4_PROC
    iint_ahb_ccl_m4 = 32'b0;
    iint_ahb_ccl_m4[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m4;
  end

  always @(int_ahb_ccl_m5)
  begin : iint_ahb_ccl_m5_PROC
    iint_ahb_ccl_m5 = 32'b0;
    iint_ahb_ccl_m5[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m5;
  end

  always @(int_ahb_ccl_m6)
  begin : iint_ahb_ccl_m6_PROC
    iint_ahb_ccl_m6 = 32'b0;
    iint_ahb_ccl_m6[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m6;
  end

  always @(int_ahb_ccl_m7)
  begin : iint_ahb_ccl_m7_PROC
    iint_ahb_ccl_m7 = 32'b0;
    iint_ahb_ccl_m7[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m7;
  end

  always @(int_ahb_ccl_m8)
  begin : iint_ahb_ccl_m8_PROC
    iint_ahb_ccl_m8 = 32'b0;
    iint_ahb_ccl_m8[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m8;
  end

  always @(int_ahb_ccl_m9)
  begin : iint_ahb_ccl_m9_PROC
    iint_ahb_ccl_m9 = 32'b0;
    iint_ahb_ccl_m9[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m9;
  end

  always @(int_ahb_ccl_m10)
  begin : iint_ahb_ccl_m10_PROC
    iint_ahb_ccl_m10 = 32'b0;
    iint_ahb_ccl_m10[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m10;
  end

  always @(int_ahb_ccl_m11)
  begin : iint_ahb_ccl_m11_PROC
    iint_ahb_ccl_m11 = 32'b0;
    iint_ahb_ccl_m11[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m11;
  end

  always @(int_ahb_ccl_m12)
  begin : iint_ahb_ccl_m12_PROC
    iint_ahb_ccl_m12 = 32'b0;
    iint_ahb_ccl_m12[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m12;
  end

  always @(int_ahb_ccl_m13)
  begin : iint_ahb_ccl_m13_PROC
    iint_ahb_ccl_m13 = 32'b0;
    iint_ahb_ccl_m13[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m13;
  end

  always @(int_ahb_ccl_m14)
  begin : iint_ahb_ccl_m14_PROC
    iint_ahb_ccl_m14 = 32'b0;
    iint_ahb_ccl_m14[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m14;
  end

  always @(int_ahb_ccl_m15)
  begin : iint_ahb_ccl_m15_PROC
    iint_ahb_ccl_m15 = 32'b0;
    iint_ahb_ccl_m15[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m15;
  end

  assign bus_ahb_icl[`AHB_CCL_WIDTH-1:0] = int_ahb_ccl_m1;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*2)-1:`AHB_CCL_WIDTH]       = int_ahb_ccl_m2;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*3)-1:(`AHB_CCL_WIDTH*2)]   = int_ahb_ccl_m3;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*4)-1:(`AHB_CCL_WIDTH*3)]   = int_ahb_ccl_m4;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*5)-1:(`AHB_CCL_WIDTH*4)]   = int_ahb_ccl_m5;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*6)-1:(`AHB_CCL_WIDTH*5)]   = int_ahb_ccl_m6;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*7)-1:(`AHB_CCL_WIDTH*6)]   = int_ahb_ccl_m7;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*8)-1:(`AHB_CCL_WIDTH*7)]   = int_ahb_ccl_m8;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*9)-1:(`AHB_CCL_WIDTH*8)]   = int_ahb_ccl_m9;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*10)-1:(`AHB_CCL_WIDTH*9)]  = int_ahb_ccl_m10;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*11)-1:(`AHB_CCL_WIDTH*10)] = int_ahb_ccl_m11;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*12)-1:(`AHB_CCL_WIDTH*11)] = int_ahb_ccl_m12;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*13)-1:(`AHB_CCL_WIDTH*12)] = int_ahb_ccl_m13;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*14)-1:(`AHB_CCL_WIDTH*13)] = int_ahb_ccl_m14;
  assign bus_ahb_icl[(`AHB_CCL_WIDTH*15)-1:(`AHB_CCL_WIDTH*14)] = int_ahb_ccl_m15;

endmodule
