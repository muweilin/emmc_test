/*
------------------------------------------------------------------------
--
--                  (C) COPYRIGHT 2001-2011 SYNOPSYS, INC.
--                             ALL RIGHTS RESERVED
--
--  This software and the associated documentation are confidential and
--  proprietary to Synopsys, Inc.  Your use or disclosure of this
--  software is subject to the terms and conditions of a written
--  license agreement between you, or your company, and Synopsys, Inc.
--
--  The entire notice above must be reproduced on all authorized copies.
--
-- File :                       DW_ahb_mux.v
-- Date :                       $Date: 2011/09/14 $ 
-- Version      :               $Revision: #3 $ 
-- Abstract     :
--
-- This block multiplexes Address, Control and Write Data from Masters
-- to Slaves. It also multiplexes Readback Data and Transfer Response 
-- information from Slaves to Masters. Instantiates the DW_ahb_bcm02
-- block to carry out the multiplexing of the address and control 
-- signals from the masters to the slaves. 
--
------------------------------------------------------------------------
*/
`include "DW_amba_constants.v" 
`include "DW_ahb_cc_constants.v"
`include "DW_ahb_constants.v"
module DW_ahb_mux (
  hclk,
  hresetn,
  bus_haddr,
  bus_hburst,
  hmaster,
  bus_hprot,
  bus_hsize,
  bus_htrans,
  bus_hwdata,
  bus_hwrite,
  hrdata_none,
  hready_resp_none,
  hresp_none,
  bus_hready,
  bus_hresp,
  bus_hrdata,
  hsel,
  hmaster_data,
  haddr,
  hburst,
  hprot,
  hsize,
  htrans, 
  hwdata,
  hwrite,
  hrdata,
  hready,
  hresp
);

  // physical parameters
  parameter haddr_width = `HADDR_WIDTH;       // 32, 64
  parameter ahb_data_width = `AHB_DATA_WIDTH; // 32, 64, 128, 256

  // derived parameters
  parameter addrbus_width = (`NUM_AHB_MASTERS+1)*haddr_width;
  parameter databus_width = (`NUM_INT_MASTERS)*ahb_data_width;
  parameter hrdatabus_width = (`NUM_INT_SLAVES)*ahb_data_width;

  input                          hclk;
  input                          hresetn;

// Aggregated bus of all haddr signals from masters
  input [addrbus_width-1:0]     bus_haddr;
// Aggregated bus of all hburst signals from masters
  input [`HBURSTBUS_WIDTH-1:0]   bus_hburst;
// AMBA Bus showing index of current bus master
  input [`HMASTER_WIDTH-1:0]     hmaster;
// Aggregated bus of all hprot signals from masters
  input [`HPROTBUS_WIDTH-1:0]    bus_hprot;
// Aggregated bus of all hsize signals from masters
  input [`HSIZEBUS_WIDTH-1:0]    bus_hsize;
// Aggregated bus of all htrans signals from masters
  input [`HTRANSBUS_WIDTH-1:0]   bus_htrans;
// Aggregated bus of all hwdata signals from masters
  input [databus_width-1:0]     bus_hwdata;
// Aggregated bus of all hwrite signals from masters
  input [`HWRITEBUS_WIDTH-1:0]   bus_hwrite;
// Read Data from Default Slave
  input [ahb_data_width-1:0]    hrdata_none;
// Bussed hrdata signals from slaves
  input [hrdatabus_width-1:0]   bus_hrdata;
// Transfer Response from Default Slave
  input                          hready_resp_none;
  input [`HRESP_WIDTH-1:0]       hresp_none;
// Bussed hready_resp signals from slaves
  input [`HREADY_WIDTH-1:0]      bus_hready;
// Bussed hresp signals from slaves
  input [`HRESPBUS_WIDTH-1:0]    bus_hresp;


// Bussed slave select signals
  input [`NUM_IAHB_SLAVES:0]      hsel;

// Address bus muxed to slaves
  output [haddr_width-1:0]      haddr;
// Burst type bus muxed to slaves
  output [`HBURST_WIDTH-1:0]     hburst;
// Protection info muxed to slaves
  output [`HPROT_WIDTH-1:0]      hprot;
// Size bus muxed to slaves
  output [`HSIZE_WIDTH-1:0]      hsize;
// Transfer type bus muxed to slaves
  output [`HTRANS_WIDTH-1:0]     htrans;
// Write Data bus muxed to slaves
  output [ahb_data_width-1:0]   hwdata;
// Read/Write signal muxed to slaves
  output                         hwrite;
// Bus showing current owner of system Data Bus
  output [`HMASTER_WIDTH-1:0]    hmaster_data;
// Readback data muxed to masters
  output [ahb_data_width-1:0]   hrdata;
// Transfer Response signal muxed to masters
  output                         hready;
// Transfer Response bus muxed to masters
  output [`HRESP_WIDTH-1:0]      hresp;

  reg                            hready;
  reg [ahb_data_width-1:0]      hrdata;
  reg [`HRESP_WIDTH-1:0]         hresp;

// Registered version of hmaster
  reg  [`HMASTER_WIDTH-1:0]      r_ihmaster_data;
  wire [`HMASTER_WIDTH-1:0]      ihmaster_data;
  wire [`HMASTER_WIDTH-1:0]      ihmaster;
// Registered version of HSEL select lines
  reg [`NUM_IAHB_SLAVES:0]       hsel_prev;


// Loop counters
   integer                        j;

//
// Instantiate Address and Control multiplexors
//

  DW_ahb_bcm02
   #(addrbus_width,`HMASTER_WIDTH,haddr_width) U_a 
  (
    .a   (bus_haddr),
    .sel (ihmaster),
    .mux (haddr)
  );

  DW_ahb_bcm02
   #(`HTRANSBUS_WIDTH,`HMASTER_WIDTH,`HTRANS_WIDTH) U_t 
  (
    .a   (bus_htrans),
    .sel (ihmaster),
    .mux (htrans)
  );

  DW_ahb_bcm02
   #(`HBURSTBUS_WIDTH,`HMASTER_WIDTH,`HBURST_WIDTH) U_b 
  (
    .a   (bus_hburst),
    .sel (ihmaster),
    .mux (hburst)
  );


  DW_ahb_bcm02
   #(`HSIZEBUS_WIDTH,`HMASTER_WIDTH,`HSIZE_WIDTH) U_s 
  (
    .a   (bus_hsize),
    .sel (ihmaster),
    .mux (hsize)
  );

  DW_ahb_bcm02
   #(`HPROTBUS_WIDTH,`HMASTER_WIDTH,`HPROT_WIDTH) U_p 
  (
    .a   (bus_hprot),
    .sel (ihmaster),
    .mux (hprot)
  );

  DW_ahb_bcm02
   #(`HWRITEBUS_WIDTH,`HMASTER_WIDTH,1) U_hw 
  (
    .a   (bus_hwrite),
    .sel (ihmaster),
    .mux (hwrite)
  );

//
// WriteData Mux (controlling hwdata).  This uses a registered version 
// of hmaster, as the address phase and data phases are not aligned, the
// address phase could be with a different master
//

  DW_ahb_bcm02
   #(databus_width,`HMASTER_WIDTH,ahb_data_width) U_dm 
  (
    .a   (bus_hwdata),
    .sel (hmaster_data),
    .mux (hwdata)
  );

  always @ (posedge hclk or negedge hresetn)
  begin : hmaster_data_PROC
    if (hresetn == 1'b0)
      r_ihmaster_data <= {`HMASTER_WIDTH{1'b0}};
    else begin
      if (hready == 1'b1)
        r_ihmaster_data <= hmaster;
    end
  end

  assign ihmaster_data[3] = (`NUM_AHB_MASTERS >= 8) ? r_ihmaster_data[3] : 1'b0;
  assign ihmaster_data[2] = (`NUM_AHB_MASTERS >= 4) ? r_ihmaster_data[2] : 1'b0;
  assign ihmaster_data[1] = (`NUM_AHB_MASTERS >= 2) ? r_ihmaster_data[1] : 1'b0;
  assign ihmaster_data[0] = r_ihmaster_data[0];

  assign hmaster_data = (`AHB_LITE == 1'b1) ? 4'b0001 : ihmaster_data;
  assign ihmaster     = (`AHB_LITE == 1'b1) ? 4'b0001 : hmaster;

//
// As HSEL is decoded from HADDR, it needs to be registered so that  
// data from Slave A will be muxed back into the data pipe when the 
// address changes to point to Slave B.  This situation arises due
// to the AMBA Address/Data pipeline/offset
//
// When there is no activity on the bus, hand the control of the
// return bus to the default slave. The hready will always be active.
// Allows for the a layer not to be affected by a slave which is
// held off by another layer when used in a multi-layer environment
//
// Do not have any hsel_prev active. Therefore the default is selected.

  // JS, 4/7/2008, now the slave responses are sent back to the master
  // even if the master is driving htrans=IDLE. Previous functionality
  // was to send back 0 on slave response signals, which though not
  // critical, violates the spec.
  always @ (posedge hclk or negedge hresetn)
  begin : hsel_prev_PROC
    if (hresetn == 1'b0)
      hsel_prev <= {`NUM_IAHB_SLAVES+1{1'b0}};
    else begin
      if (hready == 1'b1) begin
          hsel_prev <= hsel;
      end
    end
  end

// This block decodes hsel_prev to cause data from the correct 
// slave to be produced on the hrdata, hready and hresp outputs 
// of the block
//
  always @ (hsel_prev
             or bus_hrdata
             or bus_hready
             or bus_hresp
             or hresp_none
             or hrdata_none
             or hready_resp_none 
)
  begin : decodeFromSlaves_PROC
    hready = hready_resp_none; 
    hresp  = hresp_none;
    hrdata = hrdata_none;

    for (j=0;j<=`NUM_IAHB_SLAVES;j=j+1) begin
      if (hsel_prev[j]== 1'b1) begin
        hready = bus_hready[j];
        hresp  = bus_hresp  >> (j*`HRESP_WIDTH);
        hrdata = bus_hrdata >> (j*ahb_data_width);
      end
    end
  end
   
endmodule
