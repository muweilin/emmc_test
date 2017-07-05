// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Mon Jul  3 23:20:29 2017
// Host        : wusystem-server running 64-bit Ubuntu 14.04.5 LTS
// Command     : write_verilog -force -mode funcsim xilinx_axi_clock_converter_funcsim.v
// Design      : xilinx_axi_clock_converter
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tfgg484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "xilinx_axi_clock_converter,axi_clock_converter_v2_1_axi_clock_converter,{}" *) (* CORE_GENERATION_INFO = "xilinx_axi_clock_converter,axi_clock_converter_v2_1_axi_clock_converter,{x_ipProduct=Vivado 2015.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=axi_clock_converter,x_ipVersion=2.1,x_ipCoreRevision=4,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_FAMILY=artix7,C_AXI_ID_WIDTH=16,C_AXI_ADDR_WIDTH=32,C_AXI_DATA_WIDTH=32,C_S_AXI_ACLK_RATIO=1,C_M_AXI_ACLK_RATIO=2,C_AXI_IS_ACLK_ASYNC=1,C_AXI_PROTOCOL=0,C_AXI_SUPPORTS_USER_SIGNALS=0,C_AXI_AWUSER_WIDTH=1,C_AXI_ARUSER_WIDTH=1,C_AXI_WUSER_WIDTH=1,C_AXI_RUSER_WIDTH=1,C_AXI_BUSER_WIDTH=1,C_AXI_SUPPORTS_WRITE=1,C_AXI_SUPPORTS_READ=1,C_SYNCHRONIZER_STAGE=3}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* X_CORE_INFO = "axi_clock_converter_v2_1_axi_clock_converter,Vivado 2015.2" *) 
(* NotValidForBitStream *)
module xilinx_axi_clock_converter
   (s_axi_aclk,
    s_axi_aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awregion,
    s_axi_awqos,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arregion,
    s_axi_arqos,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    m_axi_aclk,
    m_axi_aresetn,
    m_axi_awid,
    m_axi_awaddr,
    m_axi_awlen,
    m_axi_awsize,
    m_axi_awburst,
    m_axi_awlock,
    m_axi_awcache,
    m_axi_awprot,
    m_axi_awregion,
    m_axi_awqos,
    m_axi_awvalid,
    m_axi_awready,
    m_axi_wdata,
    m_axi_wstrb,
    m_axi_wlast,
    m_axi_wvalid,
    m_axi_wready,
    m_axi_bid,
    m_axi_bresp,
    m_axi_bvalid,
    m_axi_bready,
    m_axi_arid,
    m_axi_araddr,
    m_axi_arlen,
    m_axi_arsize,
    m_axi_arburst,
    m_axi_arlock,
    m_axi_arcache,
    m_axi_arprot,
    m_axi_arregion,
    m_axi_arqos,
    m_axi_arvalid,
    m_axi_arready,
    m_axi_rid,
    m_axi_rdata,
    m_axi_rresp,
    m_axi_rlast,
    m_axi_rvalid,
    m_axi_rready);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 SI_CLK CLK" *) input s_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 SI_RST RST" *) input s_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWID" *) input [15:0]s_axi_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *) input [31:0]s_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWLEN" *) input [7:0]s_axi_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWSIZE" *) input [2:0]s_axi_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWBURST" *) input [1:0]s_axi_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWLOCK" *) input [0:0]s_axi_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWCACHE" *) input [3:0]s_axi_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWPROT" *) input [2:0]s_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREGION" *) input [3:0]s_axi_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWQOS" *) input [3:0]s_axi_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *) input s_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *) output s_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *) input [31:0]s_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *) input [3:0]s_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WLAST" *) input s_axi_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *) input s_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *) output s_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BID" *) output [15:0]s_axi_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *) output [1:0]s_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *) output s_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *) input s_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARID" *) input [15:0]s_axi_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *) input [31:0]s_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARLEN" *) input [7:0]s_axi_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARSIZE" *) input [2:0]s_axi_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARBURST" *) input [1:0]s_axi_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARLOCK" *) input [0:0]s_axi_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARCACHE" *) input [3:0]s_axi_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARPROT" *) input [2:0]s_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREGION" *) input [3:0]s_axi_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARQOS" *) input [3:0]s_axi_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *) input s_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *) output s_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RID" *) output [15:0]s_axi_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *) output [31:0]s_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *) output [1:0]s_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RLAST" *) output s_axi_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *) output s_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *) input s_axi_rready;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 MI_CLK CLK" *) input m_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 MI_RST RST" *) input m_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWID" *) output [15:0]m_axi_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWADDR" *) output [31:0]m_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWLEN" *) output [7:0]m_axi_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWSIZE" *) output [2:0]m_axi_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWBURST" *) output [1:0]m_axi_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWLOCK" *) output [0:0]m_axi_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWCACHE" *) output [3:0]m_axi_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWPROT" *) output [2:0]m_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWREGION" *) output [3:0]m_axi_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWQOS" *) output [3:0]m_axi_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWVALID" *) output m_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWREADY" *) input m_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WDATA" *) output [31:0]m_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WSTRB" *) output [3:0]m_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WLAST" *) output m_axi_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WVALID" *) output m_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WREADY" *) input m_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BID" *) input [15:0]m_axi_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BRESP" *) input [1:0]m_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BVALID" *) input m_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BREADY" *) output m_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARID" *) output [15:0]m_axi_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARADDR" *) output [31:0]m_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARLEN" *) output [7:0]m_axi_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARSIZE" *) output [2:0]m_axi_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARBURST" *) output [1:0]m_axi_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARLOCK" *) output [0:0]m_axi_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARCACHE" *) output [3:0]m_axi_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARPROT" *) output [2:0]m_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARREGION" *) output [3:0]m_axi_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARQOS" *) output [3:0]m_axi_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARVALID" *) output m_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARREADY" *) input m_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RID" *) input [15:0]m_axi_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RDATA" *) input [31:0]m_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RRESP" *) input [1:0]m_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RLAST" *) input m_axi_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RVALID" *) input m_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RREADY" *) output m_axi_rready;

  wire m_axi_aclk;
  wire [31:0]m_axi_araddr;
  wire [1:0]m_axi_arburst;
  wire [3:0]m_axi_arcache;
  wire m_axi_aresetn;
  wire [15:0]m_axi_arid;
  wire [7:0]m_axi_arlen;
  wire [0:0]m_axi_arlock;
  wire [2:0]m_axi_arprot;
  wire [3:0]m_axi_arqos;
  wire m_axi_arready;
  wire [3:0]m_axi_arregion;
  wire [2:0]m_axi_arsize;
  wire m_axi_arvalid;
  wire [31:0]m_axi_awaddr;
  wire [1:0]m_axi_awburst;
  wire [3:0]m_axi_awcache;
  wire [15:0]m_axi_awid;
  wire [7:0]m_axi_awlen;
  wire [0:0]m_axi_awlock;
  wire [2:0]m_axi_awprot;
  wire [3:0]m_axi_awqos;
  wire m_axi_awready;
  wire [3:0]m_axi_awregion;
  wire [2:0]m_axi_awsize;
  wire m_axi_awvalid;
  wire [15:0]m_axi_bid;
  wire m_axi_bready;
  wire [1:0]m_axi_bresp;
  wire m_axi_bvalid;
  wire [31:0]m_axi_rdata;
  wire [15:0]m_axi_rid;
  wire m_axi_rlast;
  wire m_axi_rready;
  wire [1:0]m_axi_rresp;
  wire m_axi_rvalid;
  wire [31:0]m_axi_wdata;
  wire m_axi_wlast;
  wire m_axi_wready;
  wire [3:0]m_axi_wstrb;
  wire m_axi_wvalid;
  wire s_axi_aclk;
  wire [31:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire [3:0]s_axi_arcache;
  wire s_axi_aresetn;
  wire [15:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire [0:0]s_axi_arlock;
  wire [2:0]s_axi_arprot;
  wire [3:0]s_axi_arqos;
  wire s_axi_arready;
  wire [3:0]s_axi_arregion;
  wire [2:0]s_axi_arsize;
  wire s_axi_arvalid;
  wire [31:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awcache;
  wire [15:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire [0:0]s_axi_awlock;
  wire [2:0]s_axi_awprot;
  wire [3:0]s_axi_awqos;
  wire s_axi_awready;
  wire [3:0]s_axi_awregion;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;
  wire [15:0]s_axi_bid;
  wire s_axi_bready;
  wire [1:0]s_axi_bresp;
  wire s_axi_bvalid;
  wire [31:0]s_axi_rdata;
  wire [15:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire [1:0]s_axi_rresp;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire [0:0]NLW_inst_m_axi_aruser_UNCONNECTED;
  wire [0:0]NLW_inst_m_axi_awuser_UNCONNECTED;
  wire [15:0]NLW_inst_m_axi_wid_UNCONNECTED;
  wire [0:0]NLW_inst_m_axi_wuser_UNCONNECTED;
  wire [0:0]NLW_inst_s_axi_buser_UNCONNECTED;
  wire [0:0]NLW_inst_s_axi_ruser_UNCONNECTED;

  (* C_ARADDR_RIGHT = "29" *) 
  (* C_ARADDR_WIDTH = "32" *) 
  (* C_ARBURST_RIGHT = "16" *) 
  (* C_ARBURST_WIDTH = "2" *) 
  (* C_ARCACHE_RIGHT = "11" *) 
  (* C_ARCACHE_WIDTH = "4" *) 
  (* C_ARID_RIGHT = "61" *) 
  (* C_ARID_WIDTH = "16" *) 
  (* C_ARLEN_RIGHT = "21" *) 
  (* C_ARLEN_WIDTH = "8" *) 
  (* C_ARLOCK_RIGHT = "15" *) 
  (* C_ARLOCK_WIDTH = "1" *) 
  (* C_ARPROT_RIGHT = "8" *) 
  (* C_ARPROT_WIDTH = "3" *) 
  (* C_ARQOS_RIGHT = "0" *) 
  (* C_ARQOS_WIDTH = "4" *) 
  (* C_ARREGION_RIGHT = "4" *) 
  (* C_ARREGION_WIDTH = "4" *) 
  (* C_ARSIZE_RIGHT = "18" *) 
  (* C_ARSIZE_WIDTH = "3" *) 
  (* C_ARUSER_RIGHT = "0" *) 
  (* C_ARUSER_WIDTH = "0" *) 
  (* C_AR_WIDTH = "77" *) 
  (* C_AWADDR_RIGHT = "29" *) 
  (* C_AWADDR_WIDTH = "32" *) 
  (* C_AWBURST_RIGHT = "16" *) 
  (* C_AWBURST_WIDTH = "2" *) 
  (* C_AWCACHE_RIGHT = "11" *) 
  (* C_AWCACHE_WIDTH = "4" *) 
  (* C_AWID_RIGHT = "61" *) 
  (* C_AWID_WIDTH = "16" *) 
  (* C_AWLEN_RIGHT = "21" *) 
  (* C_AWLEN_WIDTH = "8" *) 
  (* C_AWLOCK_RIGHT = "15" *) 
  (* C_AWLOCK_WIDTH = "1" *) 
  (* C_AWPROT_RIGHT = "8" *) 
  (* C_AWPROT_WIDTH = "3" *) 
  (* C_AWQOS_RIGHT = "0" *) 
  (* C_AWQOS_WIDTH = "4" *) 
  (* C_AWREGION_RIGHT = "4" *) 
  (* C_AWREGION_WIDTH = "4" *) 
  (* C_AWSIZE_RIGHT = "18" *) 
  (* C_AWSIZE_WIDTH = "3" *) 
  (* C_AWUSER_RIGHT = "0" *) 
  (* C_AWUSER_WIDTH = "0" *) 
  (* C_AW_WIDTH = "77" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "32" *) 
  (* C_AXI_ID_WIDTH = "16" *) 
  (* C_AXI_IS_ACLK_ASYNC = "1" *) 
  (* C_AXI_PROTOCOL = "0" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_SUPPORTS_READ = "1" *) 
  (* C_AXI_SUPPORTS_USER_SIGNALS = "0" *) 
  (* C_AXI_SUPPORTS_WRITE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_BID_RIGHT = "2" *) 
  (* C_BID_WIDTH = "16" *) 
  (* C_BRESP_RIGHT = "0" *) 
  (* C_BRESP_WIDTH = "2" *) 
  (* C_BUSER_RIGHT = "0" *) 
  (* C_BUSER_WIDTH = "0" *) 
  (* C_B_WIDTH = "18" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_FIFO_AR_WIDTH = "77" *) 
  (* C_FIFO_AW_WIDTH = "77" *) 
  (* C_FIFO_B_WIDTH = "18" *) 
  (* C_FIFO_R_WIDTH = "51" *) 
  (* C_FIFO_W_WIDTH = "37" *) 
  (* C_M_AXI_ACLK_RATIO = "2" *) 
  (* C_RDATA_RIGHT = "3" *) 
  (* C_RDATA_WIDTH = "32" *) 
  (* C_RID_RIGHT = "35" *) 
  (* C_RID_WIDTH = "16" *) 
  (* C_RLAST_RIGHT = "0" *) 
  (* C_RLAST_WIDTH = "1" *) 
  (* C_RRESP_RIGHT = "1" *) 
  (* C_RRESP_WIDTH = "2" *) 
  (* C_RUSER_RIGHT = "0" *) 
  (* C_RUSER_WIDTH = "0" *) 
  (* C_R_WIDTH = "51" *) 
  (* C_SYNCHRONIZER_STAGE = "3" *) 
  (* C_S_AXI_ACLK_RATIO = "1" *) 
  (* C_WDATA_RIGHT = "5" *) 
  (* C_WDATA_WIDTH = "32" *) 
  (* C_WID_RIGHT = "37" *) 
  (* C_WID_WIDTH = "0" *) 
  (* C_WLAST_RIGHT = "0" *) 
  (* C_WLAST_WIDTH = "1" *) 
  (* C_WSTRB_RIGHT = "1" *) 
  (* C_WSTRB_WIDTH = "4" *) 
  (* C_WUSER_RIGHT = "0" *) 
  (* C_WUSER_WIDTH = "0" *) 
  (* C_W_WIDTH = "37" *) 
  (* P_ACLK_RATIO = "2" *) 
  (* P_AXI3 = "1" *) 
  (* P_AXI4 = "0" *) 
  (* P_AXILITE = "2" *) 
  (* P_FULLY_REG = "1" *) 
  (* P_LIGHT_WT = "0" *) 
  (* P_LUTRAM_ASYNC = "12" *) 
  (* P_ROUNDING_OFFSET = "0" *) 
  (* P_SI_LT_MI = "1'b1" *) 
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  xilinx_axi_clock_converter_axi_clock_converter_v2_1_axi_clock_converter inst
       (.m_axi_aclk(m_axi_aclk),
        .m_axi_araddr(m_axi_araddr),
        .m_axi_arburst(m_axi_arburst),
        .m_axi_arcache(m_axi_arcache),
        .m_axi_aresetn(m_axi_aresetn),
        .m_axi_arid(m_axi_arid),
        .m_axi_arlen(m_axi_arlen),
        .m_axi_arlock(m_axi_arlock),
        .m_axi_arprot(m_axi_arprot),
        .m_axi_arqos(m_axi_arqos),
        .m_axi_arready(m_axi_arready),
        .m_axi_arregion(m_axi_arregion),
        .m_axi_arsize(m_axi_arsize),
        .m_axi_aruser(NLW_inst_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(m_axi_arvalid),
        .m_axi_awaddr(m_axi_awaddr),
        .m_axi_awburst(m_axi_awburst),
        .m_axi_awcache(m_axi_awcache),
        .m_axi_awid(m_axi_awid),
        .m_axi_awlen(m_axi_awlen),
        .m_axi_awlock(m_axi_awlock),
        .m_axi_awprot(m_axi_awprot),
        .m_axi_awqos(m_axi_awqos),
        .m_axi_awready(m_axi_awready),
        .m_axi_awregion(m_axi_awregion),
        .m_axi_awsize(m_axi_awsize),
        .m_axi_awuser(NLW_inst_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(m_axi_awvalid),
        .m_axi_bid(m_axi_bid),
        .m_axi_bready(m_axi_bready),
        .m_axi_bresp(m_axi_bresp),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_rdata(m_axi_rdata),
        .m_axi_rid(m_axi_rid),
        .m_axi_rlast(m_axi_rlast),
        .m_axi_rready(m_axi_rready),
        .m_axi_rresp(m_axi_rresp),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(m_axi_rvalid),
        .m_axi_wdata(m_axi_wdata),
        .m_axi_wid(NLW_inst_m_axi_wid_UNCONNECTED[15:0]),
        .m_axi_wlast(m_axi_wlast),
        .m_axi_wready(m_axi_wready),
        .m_axi_wstrb(m_axi_wstrb),
        .m_axi_wuser(NLW_inst_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(m_axi_wvalid),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_arcache(s_axi_arcache),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arlock(s_axi_arlock),
        .s_axi_arprot(s_axi_arprot),
        .s_axi_arqos(s_axi_arqos),
        .s_axi_arready(s_axi_arready),
        .s_axi_arregion(s_axi_arregion),
        .s_axi_arsize(s_axi_arsize),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awcache(s_axi_awcache),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awlock(s_axi_awlock),
        .s_axi_awprot(s_axi_awprot),
        .s_axi_awqos(s_axi_awqos),
        .s_axi_awready(s_axi_awready),
        .s_axi_awregion(s_axi_awregion),
        .s_axi_awsize(s_axi_awsize),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_buser(NLW_inst_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_ruser(NLW_inst_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* C_ARADDR_RIGHT = "29" *) (* C_ARADDR_WIDTH = "32" *) (* C_ARBURST_RIGHT = "16" *) 
(* C_ARBURST_WIDTH = "2" *) (* C_ARCACHE_RIGHT = "11" *) (* C_ARCACHE_WIDTH = "4" *) 
(* C_ARID_RIGHT = "61" *) (* C_ARID_WIDTH = "16" *) (* C_ARLEN_RIGHT = "21" *) 
(* C_ARLEN_WIDTH = "8" *) (* C_ARLOCK_RIGHT = "15" *) (* C_ARLOCK_WIDTH = "1" *) 
(* C_ARPROT_RIGHT = "8" *) (* C_ARPROT_WIDTH = "3" *) (* C_ARQOS_RIGHT = "0" *) 
(* C_ARQOS_WIDTH = "4" *) (* C_ARREGION_RIGHT = "4" *) (* C_ARREGION_WIDTH = "4" *) 
(* C_ARSIZE_RIGHT = "18" *) (* C_ARSIZE_WIDTH = "3" *) (* C_ARUSER_RIGHT = "0" *) 
(* C_ARUSER_WIDTH = "0" *) (* C_AR_WIDTH = "77" *) (* C_AWADDR_RIGHT = "29" *) 
(* C_AWADDR_WIDTH = "32" *) (* C_AWBURST_RIGHT = "16" *) (* C_AWBURST_WIDTH = "2" *) 
(* C_AWCACHE_RIGHT = "11" *) (* C_AWCACHE_WIDTH = "4" *) (* C_AWID_RIGHT = "61" *) 
(* C_AWID_WIDTH = "16" *) (* C_AWLEN_RIGHT = "21" *) (* C_AWLEN_WIDTH = "8" *) 
(* C_AWLOCK_RIGHT = "15" *) (* C_AWLOCK_WIDTH = "1" *) (* C_AWPROT_RIGHT = "8" *) 
(* C_AWPROT_WIDTH = "3" *) (* C_AWQOS_RIGHT = "0" *) (* C_AWQOS_WIDTH = "4" *) 
(* C_AWREGION_RIGHT = "4" *) (* C_AWREGION_WIDTH = "4" *) (* C_AWSIZE_RIGHT = "18" *) 
(* C_AWSIZE_WIDTH = "3" *) (* C_AWUSER_RIGHT = "0" *) (* C_AWUSER_WIDTH = "0" *) 
(* C_AW_WIDTH = "77" *) (* C_AXI_ADDR_WIDTH = "32" *) (* C_AXI_ARUSER_WIDTH = "1" *) 
(* C_AXI_AWUSER_WIDTH = "1" *) (* C_AXI_BUSER_WIDTH = "1" *) (* C_AXI_DATA_WIDTH = "32" *) 
(* C_AXI_ID_WIDTH = "16" *) (* C_AXI_IS_ACLK_ASYNC = "1" *) (* C_AXI_PROTOCOL = "0" *) 
(* C_AXI_RUSER_WIDTH = "1" *) (* C_AXI_SUPPORTS_READ = "1" *) (* C_AXI_SUPPORTS_USER_SIGNALS = "0" *) 
(* C_AXI_SUPPORTS_WRITE = "1" *) (* C_AXI_WUSER_WIDTH = "1" *) (* C_BID_RIGHT = "2" *) 
(* C_BID_WIDTH = "16" *) (* C_BRESP_RIGHT = "0" *) (* C_BRESP_WIDTH = "2" *) 
(* C_BUSER_RIGHT = "0" *) (* C_BUSER_WIDTH = "0" *) (* C_B_WIDTH = "18" *) 
(* C_FAMILY = "artix7" *) (* C_FIFO_AR_WIDTH = "77" *) (* C_FIFO_AW_WIDTH = "77" *) 
(* C_FIFO_B_WIDTH = "18" *) (* C_FIFO_R_WIDTH = "51" *) (* C_FIFO_W_WIDTH = "37" *) 
(* C_M_AXI_ACLK_RATIO = "2" *) (* C_RDATA_RIGHT = "3" *) (* C_RDATA_WIDTH = "32" *) 
(* C_RID_RIGHT = "35" *) (* C_RID_WIDTH = "16" *) (* C_RLAST_RIGHT = "0" *) 
(* C_RLAST_WIDTH = "1" *) (* C_RRESP_RIGHT = "1" *) (* C_RRESP_WIDTH = "2" *) 
(* C_RUSER_RIGHT = "0" *) (* C_RUSER_WIDTH = "0" *) (* C_R_WIDTH = "51" *) 
(* C_SYNCHRONIZER_STAGE = "3" *) (* C_S_AXI_ACLK_RATIO = "1" *) (* C_WDATA_RIGHT = "5" *) 
(* C_WDATA_WIDTH = "32" *) (* C_WID_RIGHT = "37" *) (* C_WID_WIDTH = "0" *) 
(* C_WLAST_RIGHT = "0" *) (* C_WLAST_WIDTH = "1" *) (* C_WSTRB_RIGHT = "1" *) 
(* C_WSTRB_WIDTH = "4" *) (* C_WUSER_RIGHT = "0" *) (* C_WUSER_WIDTH = "0" *) 
(* C_W_WIDTH = "37" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* ORIG_REF_NAME = "axi_clock_converter_v2_1_axi_clock_converter" *) 
(* P_ACLK_RATIO = "2" *) (* P_AXI3 = "1" *) (* P_AXI4 = "0" *) 
(* P_AXILITE = "2" *) (* P_FULLY_REG = "1" *) (* P_LIGHT_WT = "0" *) 
(* P_LUTRAM_ASYNC = "12" *) (* P_ROUNDING_OFFSET = "0" *) (* P_SI_LT_MI = "1'b1" *) 
module xilinx_axi_clock_converter_axi_clock_converter_v2_1_axi_clock_converter
   (s_axi_aclk,
    s_axi_aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awregion,
    s_axi_awqos,
    s_axi_awuser,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wid,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wuser,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_buser,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arregion,
    s_axi_arqos,
    s_axi_aruser,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_ruser,
    s_axi_rvalid,
    s_axi_rready,
    m_axi_aclk,
    m_axi_aresetn,
    m_axi_awid,
    m_axi_awaddr,
    m_axi_awlen,
    m_axi_awsize,
    m_axi_awburst,
    m_axi_awlock,
    m_axi_awcache,
    m_axi_awprot,
    m_axi_awregion,
    m_axi_awqos,
    m_axi_awuser,
    m_axi_awvalid,
    m_axi_awready,
    m_axi_wid,
    m_axi_wdata,
    m_axi_wstrb,
    m_axi_wlast,
    m_axi_wuser,
    m_axi_wvalid,
    m_axi_wready,
    m_axi_bid,
    m_axi_bresp,
    m_axi_buser,
    m_axi_bvalid,
    m_axi_bready,
    m_axi_arid,
    m_axi_araddr,
    m_axi_arlen,
    m_axi_arsize,
    m_axi_arburst,
    m_axi_arlock,
    m_axi_arcache,
    m_axi_arprot,
    m_axi_arregion,
    m_axi_arqos,
    m_axi_aruser,
    m_axi_arvalid,
    m_axi_arready,
    m_axi_rid,
    m_axi_rdata,
    m_axi_rresp,
    m_axi_rlast,
    m_axi_ruser,
    m_axi_rvalid,
    m_axi_rready);
  (* KEEP = "true" *) input s_axi_aclk;
  (* KEEP = "true" *) input s_axi_aresetn;
  input [15:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input [0:0]s_axi_awlock;
  input [3:0]s_axi_awcache;
  input [2:0]s_axi_awprot;
  input [3:0]s_axi_awregion;
  input [3:0]s_axi_awqos;
  input [0:0]s_axi_awuser;
  input s_axi_awvalid;
  output s_axi_awready;
  input [15:0]s_axi_wid;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input s_axi_wlast;
  input [0:0]s_axi_wuser;
  input s_axi_wvalid;
  output s_axi_wready;
  output [15:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output [0:0]s_axi_buser;
  output s_axi_bvalid;
  input s_axi_bready;
  input [15:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input [0:0]s_axi_arlock;
  input [3:0]s_axi_arcache;
  input [2:0]s_axi_arprot;
  input [3:0]s_axi_arregion;
  input [3:0]s_axi_arqos;
  input [0:0]s_axi_aruser;
  input s_axi_arvalid;
  output s_axi_arready;
  output [15:0]s_axi_rid;
  output [31:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output [0:0]s_axi_ruser;
  output s_axi_rvalid;
  input s_axi_rready;
  (* KEEP = "true" *) input m_axi_aclk;
  (* KEEP = "true" *) input m_axi_aresetn;
  output [15:0]m_axi_awid;
  output [31:0]m_axi_awaddr;
  output [7:0]m_axi_awlen;
  output [2:0]m_axi_awsize;
  output [1:0]m_axi_awburst;
  output [0:0]m_axi_awlock;
  output [3:0]m_axi_awcache;
  output [2:0]m_axi_awprot;
  output [3:0]m_axi_awregion;
  output [3:0]m_axi_awqos;
  output [0:0]m_axi_awuser;
  output m_axi_awvalid;
  input m_axi_awready;
  output [15:0]m_axi_wid;
  output [31:0]m_axi_wdata;
  output [3:0]m_axi_wstrb;
  output m_axi_wlast;
  output [0:0]m_axi_wuser;
  output m_axi_wvalid;
  input m_axi_wready;
  input [15:0]m_axi_bid;
  input [1:0]m_axi_bresp;
  input [0:0]m_axi_buser;
  input m_axi_bvalid;
  output m_axi_bready;
  output [15:0]m_axi_arid;
  output [31:0]m_axi_araddr;
  output [7:0]m_axi_arlen;
  output [2:0]m_axi_arsize;
  output [1:0]m_axi_arburst;
  output [0:0]m_axi_arlock;
  output [3:0]m_axi_arcache;
  output [2:0]m_axi_arprot;
  output [3:0]m_axi_arregion;
  output [3:0]m_axi_arqos;
  output [0:0]m_axi_aruser;
  output m_axi_arvalid;
  input m_axi_arready;
  input [15:0]m_axi_rid;
  input [31:0]m_axi_rdata;
  input [1:0]m_axi_rresp;
  input m_axi_rlast;
  input [0:0]m_axi_ruser;
  input m_axi_rvalid;
  output m_axi_rready;

  wire \<const0> ;
  wire async_conv_reset_n;
  (* RTL_KEEP = "true" *) wire m_axi_aclk;
  wire [31:0]m_axi_araddr;
  wire [1:0]m_axi_arburst;
  wire [3:0]m_axi_arcache;
  (* RTL_KEEP = "true" *) wire m_axi_aresetn;
  wire [15:0]m_axi_arid;
  wire [7:0]m_axi_arlen;
  wire [0:0]m_axi_arlock;
  wire [2:0]m_axi_arprot;
  wire [3:0]m_axi_arqos;
  wire m_axi_arready;
  wire [3:0]m_axi_arregion;
  wire [2:0]m_axi_arsize;
  wire m_axi_arvalid;
  wire [31:0]m_axi_awaddr;
  wire [1:0]m_axi_awburst;
  wire [3:0]m_axi_awcache;
  wire [15:0]m_axi_awid;
  wire [7:0]m_axi_awlen;
  wire [0:0]m_axi_awlock;
  wire [2:0]m_axi_awprot;
  wire [3:0]m_axi_awqos;
  wire m_axi_awready;
  wire [3:0]m_axi_awregion;
  wire [2:0]m_axi_awsize;
  wire m_axi_awvalid;
  wire [15:0]m_axi_bid;
  wire m_axi_bready;
  wire [1:0]m_axi_bresp;
  wire m_axi_bvalid;
  wire [31:0]m_axi_rdata;
  wire [15:0]m_axi_rid;
  wire m_axi_rlast;
  wire m_axi_rready;
  wire [1:0]m_axi_rresp;
  wire m_axi_rvalid;
  wire [31:0]m_axi_wdata;
  wire m_axi_wlast;
  wire m_axi_wready;
  wire [3:0]m_axi_wstrb;
  wire m_axi_wvalid;
  (* RTL_KEEP = "true" *) wire s_axi_aclk;
  wire [31:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire [3:0]s_axi_arcache;
  (* RTL_KEEP = "true" *) wire s_axi_aresetn;
  wire [15:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire [0:0]s_axi_arlock;
  wire [2:0]s_axi_arprot;
  wire [3:0]s_axi_arqos;
  wire s_axi_arready;
  wire [3:0]s_axi_arregion;
  wire [2:0]s_axi_arsize;
  wire s_axi_arvalid;
  wire [31:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awcache;
  wire [15:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire [0:0]s_axi_awlock;
  wire [2:0]s_axi_awprot;
  wire [3:0]s_axi_awqos;
  wire s_axi_awready;
  wire [3:0]s_axi_awregion;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;
  wire [15:0]s_axi_bid;
  wire s_axi_bready;
  wire [1:0]s_axi_bresp;
  wire s_axi_bvalid;
  wire [31:0]s_axi_rdata;
  wire [15:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire [1:0]s_axi_rresp;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_almost_empty_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_almost_full_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_dbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_overflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_prog_empty_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_prog_full_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_sbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_underflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_dbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_overflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_prog_empty_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_prog_full_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_sbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_underflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_dbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_overflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_prog_empty_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_prog_full_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_sbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_underflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_dbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_overflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_prog_empty_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_prog_full_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_sbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_underflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_dbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_overflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_prog_empty_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_prog_full_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_sbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_underflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_dbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_overflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_prog_empty_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_prog_full_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_sbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_underflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_dbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_empty_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_full_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tlast_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tvalid_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_overflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_prog_empty_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_prog_full_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_rd_rst_busy_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_s_axis_tready_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_sbiterr_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_underflow_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_valid_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_wr_ack_UNCONNECTED ;
  wire \NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_wr_rst_busy_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_rd_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_wr_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_rd_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_wr_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_rd_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_wr_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_rd_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_wr_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_rd_data_count_UNCONNECTED ;
  wire [4:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_wr_data_count_UNCONNECTED ;
  wire [10:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_data_count_UNCONNECTED ;
  wire [10:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_rd_data_count_UNCONNECTED ;
  wire [10:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_wr_data_count_UNCONNECTED ;
  wire [9:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_data_count_UNCONNECTED ;
  wire [17:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_dout_UNCONNECTED ;
  wire [0:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axi_aruser_UNCONNECTED ;
  wire [0:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axi_awuser_UNCONNECTED ;
  wire [15:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axi_wid_UNCONNECTED ;
  wire [0:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axi_wuser_UNCONNECTED ;
  wire [7:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tdata_UNCONNECTED ;
  wire [0:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tdest_UNCONNECTED ;
  wire [0:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tid_UNCONNECTED ;
  wire [0:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tkeep_UNCONNECTED ;
  wire [0:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tstrb_UNCONNECTED ;
  wire [3:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tuser_UNCONNECTED ;
  wire [9:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_rd_data_count_UNCONNECTED ;
  wire [0:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_s_axi_buser_UNCONNECTED ;
  wire [0:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_s_axi_ruser_UNCONNECTED ;
  wire [9:0]\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_wr_data_count_UNCONNECTED ;

  assign m_axi_aruser[0] = \<const0> ;
  assign m_axi_awuser[0] = \<const0> ;
  assign m_axi_wid[15] = \<const0> ;
  assign m_axi_wid[14] = \<const0> ;
  assign m_axi_wid[13] = \<const0> ;
  assign m_axi_wid[12] = \<const0> ;
  assign m_axi_wid[11] = \<const0> ;
  assign m_axi_wid[10] = \<const0> ;
  assign m_axi_wid[9] = \<const0> ;
  assign m_axi_wid[8] = \<const0> ;
  assign m_axi_wid[7] = \<const0> ;
  assign m_axi_wid[6] = \<const0> ;
  assign m_axi_wid[5] = \<const0> ;
  assign m_axi_wid[4] = \<const0> ;
  assign m_axi_wid[3] = \<const0> ;
  assign m_axi_wid[2] = \<const0> ;
  assign m_axi_wid[1] = \<const0> ;
  assign m_axi_wid[0] = \<const0> ;
  assign m_axi_wuser[0] = \<const0> ;
  assign s_axi_buser[0] = \<const0> ;
  assign s_axi_ruser[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "32" *) 
  (* C_AXI_ID_WIDTH = "16" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "0" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "10" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "18" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "77" *) 
  (* C_DIN_WIDTH_RDCH = "51" *) 
  (* C_DIN_WIDTH_WACH = "77" *) 
  (* C_DIN_WIDTH_WDCH = "37" *) 
  (* C_DIN_WIDTH_WRCH = "18" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "18" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_FULL_FLAGS_RST_VAL = "1" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "1" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "1" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "0" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "11" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "12" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "12" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "12" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "12" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "12" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "2" *) 
  (* C_MEMORY_TYPE = "1" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "1" *) 
  (* C_PRELOAD_REGS = "0" *) 
  (* C_PRIM_FIFO_TYPE = "4kx4" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1021" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "13" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "13" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "13" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "13" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "13" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "1022" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "15" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "15" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "15" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "15" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "15" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "1021" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "10" *) 
  (* C_RD_DEPTH = "1024" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "10" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "3" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "0" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "10" *) 
  (* C_WR_DEPTH = "1024" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "16" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "16" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "10" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "4" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "4" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* DONT_TOUCH *) 
  xilinx_axi_clock_converter_fifo_generator_v12_0 \gen_clock_conv.gen_async_conv.asyncfifo_axi 
       (.almost_empty(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_almost_empty_UNCONNECTED ),
        .almost_full(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_almost_full_UNCONNECTED ),
        .axi_ar_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_data_count_UNCONNECTED [4:0]),
        .axi_ar_dbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_dbiterr_UNCONNECTED ),
        .axi_ar_injectdbiterr(\<const0> ),
        .axi_ar_injectsbiterr(\<const0> ),
        .axi_ar_overflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_overflow_UNCONNECTED ),
        .axi_ar_prog_empty(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_prog_empty_UNCONNECTED ),
        .axi_ar_prog_empty_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axi_ar_prog_full(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_prog_full_UNCONNECTED ),
        .axi_ar_prog_full_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axi_ar_rd_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_rd_data_count_UNCONNECTED [4:0]),
        .axi_ar_sbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_sbiterr_UNCONNECTED ),
        .axi_ar_underflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_underflow_UNCONNECTED ),
        .axi_ar_wr_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_ar_wr_data_count_UNCONNECTED [4:0]),
        .axi_aw_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_data_count_UNCONNECTED [4:0]),
        .axi_aw_dbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_dbiterr_UNCONNECTED ),
        .axi_aw_injectdbiterr(\<const0> ),
        .axi_aw_injectsbiterr(\<const0> ),
        .axi_aw_overflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_overflow_UNCONNECTED ),
        .axi_aw_prog_empty(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_prog_empty_UNCONNECTED ),
        .axi_aw_prog_empty_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axi_aw_prog_full(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_prog_full_UNCONNECTED ),
        .axi_aw_prog_full_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axi_aw_rd_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_rd_data_count_UNCONNECTED [4:0]),
        .axi_aw_sbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_sbiterr_UNCONNECTED ),
        .axi_aw_underflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_underflow_UNCONNECTED ),
        .axi_aw_wr_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_aw_wr_data_count_UNCONNECTED [4:0]),
        .axi_b_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_data_count_UNCONNECTED [4:0]),
        .axi_b_dbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_dbiterr_UNCONNECTED ),
        .axi_b_injectdbiterr(\<const0> ),
        .axi_b_injectsbiterr(\<const0> ),
        .axi_b_overflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_overflow_UNCONNECTED ),
        .axi_b_prog_empty(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_prog_empty_UNCONNECTED ),
        .axi_b_prog_empty_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axi_b_prog_full(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_prog_full_UNCONNECTED ),
        .axi_b_prog_full_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axi_b_rd_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_rd_data_count_UNCONNECTED [4:0]),
        .axi_b_sbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_sbiterr_UNCONNECTED ),
        .axi_b_underflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_underflow_UNCONNECTED ),
        .axi_b_wr_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_b_wr_data_count_UNCONNECTED [4:0]),
        .axi_r_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_data_count_UNCONNECTED [4:0]),
        .axi_r_dbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_dbiterr_UNCONNECTED ),
        .axi_r_injectdbiterr(\<const0> ),
        .axi_r_injectsbiterr(\<const0> ),
        .axi_r_overflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_overflow_UNCONNECTED ),
        .axi_r_prog_empty(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_prog_empty_UNCONNECTED ),
        .axi_r_prog_empty_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axi_r_prog_full(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_prog_full_UNCONNECTED ),
        .axi_r_prog_full_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axi_r_rd_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_rd_data_count_UNCONNECTED [4:0]),
        .axi_r_sbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_sbiterr_UNCONNECTED ),
        .axi_r_underflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_underflow_UNCONNECTED ),
        .axi_r_wr_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_r_wr_data_count_UNCONNECTED [4:0]),
        .axi_w_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_data_count_UNCONNECTED [4:0]),
        .axi_w_dbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_dbiterr_UNCONNECTED ),
        .axi_w_injectdbiterr(\<const0> ),
        .axi_w_injectsbiterr(\<const0> ),
        .axi_w_overflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_overflow_UNCONNECTED ),
        .axi_w_prog_empty(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_prog_empty_UNCONNECTED ),
        .axi_w_prog_empty_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axi_w_prog_full(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_prog_full_UNCONNECTED ),
        .axi_w_prog_full_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axi_w_rd_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_rd_data_count_UNCONNECTED [4:0]),
        .axi_w_sbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_sbiterr_UNCONNECTED ),
        .axi_w_underflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_underflow_UNCONNECTED ),
        .axi_w_wr_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axi_w_wr_data_count_UNCONNECTED [4:0]),
        .axis_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_data_count_UNCONNECTED [10:0]),
        .axis_dbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_dbiterr_UNCONNECTED ),
        .axis_injectdbiterr(\<const0> ),
        .axis_injectsbiterr(\<const0> ),
        .axis_overflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_overflow_UNCONNECTED ),
        .axis_prog_empty(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_prog_empty_UNCONNECTED ),
        .axis_prog_empty_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axis_prog_full(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_prog_full_UNCONNECTED ),
        .axis_prog_full_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .axis_rd_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_rd_data_count_UNCONNECTED [10:0]),
        .axis_sbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_sbiterr_UNCONNECTED ),
        .axis_underflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_underflow_UNCONNECTED ),
        .axis_wr_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_axis_wr_data_count_UNCONNECTED [10:0]),
        .backup(\<const0> ),
        .backup_marker(\<const0> ),
        .clk(\<const0> ),
        .data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_data_count_UNCONNECTED [9:0]),
        .dbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_dbiterr_UNCONNECTED ),
        .din({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .dout(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_dout_UNCONNECTED [17:0]),
        .empty(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_empty_UNCONNECTED ),
        .full(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_full_UNCONNECTED ),
        .injectdbiterr(\<const0> ),
        .injectsbiterr(\<const0> ),
        .int_clk(\<const0> ),
        .m_aclk(m_axi_aclk),
        .m_aclk_en(1'b1),
        .m_axi_araddr(m_axi_araddr),
        .m_axi_arburst(m_axi_arburst),
        .m_axi_arcache(m_axi_arcache),
        .m_axi_arid(m_axi_arid),
        .m_axi_arlen(m_axi_arlen),
        .m_axi_arlock(m_axi_arlock),
        .m_axi_arprot(m_axi_arprot),
        .m_axi_arqos(m_axi_arqos),
        .m_axi_arready(m_axi_arready),
        .m_axi_arregion(m_axi_arregion),
        .m_axi_arsize(m_axi_arsize),
        .m_axi_aruser(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axi_aruser_UNCONNECTED [0]),
        .m_axi_arvalid(m_axi_arvalid),
        .m_axi_awaddr(m_axi_awaddr),
        .m_axi_awburst(m_axi_awburst),
        .m_axi_awcache(m_axi_awcache),
        .m_axi_awid(m_axi_awid),
        .m_axi_awlen(m_axi_awlen),
        .m_axi_awlock(m_axi_awlock),
        .m_axi_awprot(m_axi_awprot),
        .m_axi_awqos(m_axi_awqos),
        .m_axi_awready(m_axi_awready),
        .m_axi_awregion(m_axi_awregion),
        .m_axi_awsize(m_axi_awsize),
        .m_axi_awuser(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axi_awuser_UNCONNECTED [0]),
        .m_axi_awvalid(m_axi_awvalid),
        .m_axi_bid(m_axi_bid),
        .m_axi_bready(m_axi_bready),
        .m_axi_bresp(m_axi_bresp),
        .m_axi_buser(\<const0> ),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_rdata(m_axi_rdata),
        .m_axi_rid(m_axi_rid),
        .m_axi_rlast(m_axi_rlast),
        .m_axi_rready(m_axi_rready),
        .m_axi_rresp(m_axi_rresp),
        .m_axi_ruser(\<const0> ),
        .m_axi_rvalid(m_axi_rvalid),
        .m_axi_wdata(m_axi_wdata),
        .m_axi_wid(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axi_wid_UNCONNECTED [15:0]),
        .m_axi_wlast(m_axi_wlast),
        .m_axi_wready(m_axi_wready),
        .m_axi_wstrb(m_axi_wstrb),
        .m_axi_wuser(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axi_wuser_UNCONNECTED [0]),
        .m_axi_wvalid(m_axi_wvalid),
        .m_axis_tdata(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tdata_UNCONNECTED [7:0]),
        .m_axis_tdest(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tdest_UNCONNECTED [0]),
        .m_axis_tid(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tid_UNCONNECTED [0]),
        .m_axis_tkeep(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tkeep_UNCONNECTED [0]),
        .m_axis_tlast(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tlast_UNCONNECTED ),
        .m_axis_tready(\<const0> ),
        .m_axis_tstrb(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tstrb_UNCONNECTED [0]),
        .m_axis_tuser(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tuser_UNCONNECTED [3:0]),
        .m_axis_tvalid(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_m_axis_tvalid_UNCONNECTED ),
        .overflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_overflow_UNCONNECTED ),
        .prog_empty(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_prog_empty_UNCONNECTED ),
        .prog_empty_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .prog_empty_thresh_assert({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .prog_empty_thresh_negate({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .prog_full(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_prog_full_UNCONNECTED ),
        .prog_full_thresh({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .prog_full_thresh_assert({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .prog_full_thresh_negate({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .rd_clk(\<const0> ),
        .rd_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_rd_data_count_UNCONNECTED [9:0]),
        .rd_en(\<const0> ),
        .rd_rst(\<const0> ),
        .rd_rst_busy(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_rd_rst_busy_UNCONNECTED ),
        .rst(\<const0> ),
        .s_aclk(s_axi_aclk),
        .s_aclk_en(1'b1),
        .s_aresetn(async_conv_reset_n),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_arcache(s_axi_arcache),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arlock(s_axi_arlock),
        .s_axi_arprot(s_axi_arprot),
        .s_axi_arqos(s_axi_arqos),
        .s_axi_arready(s_axi_arready),
        .s_axi_arregion(s_axi_arregion),
        .s_axi_arsize(s_axi_arsize),
        .s_axi_aruser(\<const0> ),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awcache(s_axi_awcache),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awlock(s_axi_awlock),
        .s_axi_awprot(s_axi_awprot),
        .s_axi_awqos(s_axi_awqos),
        .s_axi_awready(s_axi_awready),
        .s_axi_awregion(s_axi_awregion),
        .s_axi_awsize(s_axi_awsize),
        .s_axi_awuser(\<const0> ),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_buser(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_s_axi_buser_UNCONNECTED [0]),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_ruser(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_s_axi_ruser_UNCONNECTED [0]),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wid({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wuser(\<const0> ),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axis_tdata({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .s_axis_tdest(\<const0> ),
        .s_axis_tid(\<const0> ),
        .s_axis_tkeep(\<const0> ),
        .s_axis_tlast(\<const0> ),
        .s_axis_tready(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_s_axis_tready_UNCONNECTED ),
        .s_axis_tstrb(\<const0> ),
        .s_axis_tuser({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .s_axis_tvalid(\<const0> ),
        .sbiterr(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_sbiterr_UNCONNECTED ),
        .sleep(\<const0> ),
        .srst(\<const0> ),
        .underflow(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_underflow_UNCONNECTED ),
        .valid(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_valid_UNCONNECTED ),
        .wr_ack(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_wr_ack_UNCONNECTED ),
        .wr_clk(\<const0> ),
        .wr_data_count(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_wr_data_count_UNCONNECTED [9:0]),
        .wr_en(\<const0> ),
        .wr_rst(\<const0> ),
        .wr_rst_busy(\NLW_gen_clock_conv.gen_async_conv.asyncfifo_axi_wr_rst_busy_UNCONNECTED ));
  LUT2 #(
    .INIT(4'h8)) 
    \gen_clock_conv.gen_async_conv.asyncfifo_axi_i_1 
       (.I0(s_axi_aresetn),
        .I1(m_axi_aresetn),
        .O(async_conv_reset_n));
endmodule

(* ORIG_REF_NAME = "clk_x_pntrs" *) 
module xilinx_axi_clock_converter_clk_x_pntrs
   (ram_full_fb_i_reg,
    Q,
    ram_empty_fb_i_reg,
    ram_empty_fb_i_reg_0,
    \gic0.gc0.count_d1_reg[2] ,
    \gc0.count_reg[2] ,
    \gic0.gc0.count_d2_reg[3] ,
    m_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ,
    s_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ,
    D);
  output ram_full_fb_i_reg;
  output [3:0]Q;
  output ram_empty_fb_i_reg;
  output [3:0]ram_empty_fb_i_reg_0;
  input [2:0]\gic0.gc0.count_d1_reg[2] ;
  input [2:0]\gc0.count_reg[2] ;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  input [3:0]D;

  wire [3:0]D;
  wire [3:0]Q;
  wire [2:0]\gc0.count_reg[2] ;
  wire [2:0]\gic0.gc0.count_d1_reg[2] ;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire \gsync_stage[3].rd_stg_inst_n_1 ;
  wire \gsync_stage[3].rd_stg_inst_n_2 ;
  wire \gsync_stage[3].rd_stg_inst_n_3 ;
  wire \gsync_stage[3].wr_stg_inst_n_1 ;
  wire \gsync_stage[3].wr_stg_inst_n_2 ;
  wire \gsync_stage[3].wr_stg_inst_n_3 ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire [2:0]p_0_in2_out;
  wire [3:3]p_0_out;
  wire [3:3]p_1_out;
  wire [3:0]p_2_out;
  wire [3:0]p_3_out;
  wire [3:0]p_4_out;
  wire [3:0]p_5_out;
  wire ram_empty_fb_i_reg;
  wire [3:0]ram_empty_fb_i_reg_0;
  wire ram_full_fb_i_reg;
  wire \rd_pntr_gc_reg_n_0_[0] ;
  wire \rd_pntr_gc_reg_n_0_[1] ;
  wire \rd_pntr_gc_reg_n_0_[2] ;
  wire \rd_pntr_gc_reg_n_0_[3] ;
  wire s_aclk;
  wire \wr_pntr_gc_reg_n_0_[0] ;
  wire \wr_pntr_gc_reg_n_0_[1] ;
  wire \wr_pntr_gc_reg_n_0_[2] ;
  wire \wr_pntr_gc_reg_n_0_[3] ;

  xilinx_axi_clock_converter_synchronizer_ff \gsync_stage[1].rd_stg_inst 
       (.D(p_5_out),
        .Q({\wr_pntr_gc_reg_n_0_[3] ,\wr_pntr_gc_reg_n_0_[2] ,\wr_pntr_gc_reg_n_0_[1] ,\wr_pntr_gc_reg_n_0_[0] }),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_synchronizer_ff_1 \gsync_stage[1].wr_stg_inst 
       (.D(p_4_out),
        .Q({\rd_pntr_gc_reg_n_0_[3] ,\rd_pntr_gc_reg_n_0_[2] ,\rd_pntr_gc_reg_n_0_[1] ,\rd_pntr_gc_reg_n_0_[0] }),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ));
  xilinx_axi_clock_converter_synchronizer_ff_2 \gsync_stage[2].rd_stg_inst 
       (.D(p_3_out),
        .\Q_reg_reg[3]_0 (p_5_out),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_synchronizer_ff_3 \gsync_stage[2].wr_stg_inst 
       (.D(p_2_out),
        .\Q_reg_reg[3]_0 (p_4_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ));
  xilinx_axi_clock_converter_synchronizer_ff_4 \gsync_stage[3].rd_stg_inst 
       (.D(p_3_out),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .out(p_1_out),
        .s_aclk(s_aclk),
        .\wr_pntr_bin_reg[2] ({\gsync_stage[3].rd_stg_inst_n_1 ,\gsync_stage[3].rd_stg_inst_n_2 ,\gsync_stage[3].rd_stg_inst_n_3 }));
  xilinx_axi_clock_converter_synchronizer_ff_5 \gsync_stage[3].wr_stg_inst 
       (.D(p_2_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .out(p_0_out),
        .\rd_pntr_bin_reg[2] ({\gsync_stage[3].wr_stg_inst_n_1 ,\gsync_stage[3].wr_stg_inst_n_2 ,\gsync_stage[3].wr_stg_inst_n_3 }));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    ram_empty_fb_i_i_4__2
       (.I0(ram_empty_fb_i_reg_0[2]),
        .I1(\gc0.count_reg[2] [2]),
        .I2(ram_empty_fb_i_reg_0[1]),
        .I3(\gc0.count_reg[2] [1]),
        .I4(\gc0.count_reg[2] [0]),
        .I5(ram_empty_fb_i_reg_0[0]),
        .O(ram_empty_fb_i_reg));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    ram_full_fb_i_i_5
       (.I0(Q[2]),
        .I1(\gic0.gc0.count_d1_reg[2] [2]),
        .I2(Q[1]),
        .I3(\gic0.gc0.count_d1_reg[2] [1]),
        .I4(\gic0.gc0.count_d1_reg[2] [0]),
        .I5(Q[0]),
        .O(ram_full_fb_i_reg));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_3 ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_2 ),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_1 ),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_out),
        .Q(Q[3]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[0]),
        .Q(\rd_pntr_gc_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[1]),
        .Q(\rd_pntr_gc_reg_n_0_[1] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[2]),
        .Q(\rd_pntr_gc_reg_n_0_[2] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[3]),
        .Q(\rd_pntr_gc_reg_n_0_[3] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_3 ),
        .Q(ram_empty_fb_i_reg_0[0]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_2 ),
        .Q(ram_empty_fb_i_reg_0[1]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_1 ),
        .Q(ram_empty_fb_i_reg_0[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(p_1_out),
        .Q(ram_empty_fb_i_reg_0[3]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[0]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [0]),
        .I1(\gic0.gc0.count_d2_reg[3] [1]),
        .O(p_0_in2_out[0]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[1]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [1]),
        .I1(\gic0.gc0.count_d2_reg[3] [2]),
        .O(p_0_in2_out[1]));
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[2]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [2]),
        .I1(\gic0.gc0.count_d2_reg[3] [3]),
        .O(p_0_in2_out[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[0]),
        .Q(\wr_pntr_gc_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[1]),
        .Q(\wr_pntr_gc_reg_n_0_[1] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[2]),
        .Q(\wr_pntr_gc_reg_n_0_[2] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gic0.gc0.count_d2_reg[3] [3]),
        .Q(\wr_pntr_gc_reg_n_0_[3] ));
endmodule

(* ORIG_REF_NAME = "clk_x_pntrs" *) 
module xilinx_axi_clock_converter_clk_x_pntrs_21
   (ram_empty_fb_i_reg,
    Q,
    ram_full_fb_i_reg,
    ram_full_fb_i_reg_0,
    \gc0.count_reg[2] ,
    \gic0.gc0.count_d1_reg[2] ,
    \gic0.gc0.count_d2_reg[3] ,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ,
    D);
  output ram_empty_fb_i_reg;
  output [3:0]Q;
  output ram_full_fb_i_reg;
  output [3:0]ram_full_fb_i_reg_0;
  input [2:0]\gc0.count_reg[2] ;
  input [2:0]\gic0.gc0.count_d1_reg[2] ;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  input [3:0]D;

  wire [3:0]D;
  wire [3:0]Q;
  wire [2:0]\gc0.count_reg[2] ;
  wire [2:0]\gic0.gc0.count_d1_reg[2] ;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire \gsync_stage[3].wr_stg_inst_n_1 ;
  wire \gsync_stage[3].wr_stg_inst_n_2 ;
  wire \gsync_stage[3].wr_stg_inst_n_3 ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire [2:0]p_0_in;
  wire [2:0]p_0_in2_out;
  wire [3:3]p_0_out;
  wire [3:3]p_1_out;
  wire [3:0]p_2_out;
  wire [3:0]p_3_out;
  wire [3:0]p_4_out;
  wire [3:0]p_5_out;
  wire ram_empty_fb_i_reg;
  wire ram_full_fb_i_reg;
  wire [3:0]ram_full_fb_i_reg_0;
  wire [3:0]rd_pntr_gc;
  wire s_aclk;
  wire [3:0]wr_pntr_gc;

  xilinx_axi_clock_converter_synchronizer_ff_30 \gsync_stage[1].rd_stg_inst 
       (.D(p_5_out),
        .Q(wr_pntr_gc),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ));
  xilinx_axi_clock_converter_synchronizer_ff_31 \gsync_stage[1].wr_stg_inst 
       (.D(p_4_out),
        .Q(rd_pntr_gc),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_synchronizer_ff_32 \gsync_stage[2].rd_stg_inst 
       (.D(p_3_out),
        .\Q_reg_reg[3]_0 (p_5_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ));
  xilinx_axi_clock_converter_synchronizer_ff_33 \gsync_stage[2].wr_stg_inst 
       (.D(p_2_out),
        .\Q_reg_reg[3]_0 (p_4_out),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_synchronizer_ff_34 \gsync_stage[3].rd_stg_inst 
       (.D(p_3_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .out(p_1_out),
        .\wr_pntr_bin_reg[2] (p_0_in));
  xilinx_axi_clock_converter_synchronizer_ff_35 \gsync_stage[3].wr_stg_inst 
       (.D(p_2_out),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .out(p_0_out),
        .\rd_pntr_bin_reg[2] ({\gsync_stage[3].wr_stg_inst_n_1 ,\gsync_stage[3].wr_stg_inst_n_2 ,\gsync_stage[3].wr_stg_inst_n_3 }),
        .s_aclk(s_aclk));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    ram_empty_fb_i_i_4
       (.I0(Q[2]),
        .I1(\gc0.count_reg[2] [2]),
        .I2(Q[1]),
        .I3(\gc0.count_reg[2] [1]),
        .I4(\gc0.count_reg[2] [0]),
        .I5(Q[0]),
        .O(ram_empty_fb_i_reg));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    ram_full_fb_i_i_5__1
       (.I0(ram_full_fb_i_reg_0[2]),
        .I1(\gic0.gc0.count_d1_reg[2] [2]),
        .I2(ram_full_fb_i_reg_0[1]),
        .I3(\gic0.gc0.count_d1_reg[2] [1]),
        .I4(\gic0.gc0.count_d1_reg[2] [0]),
        .I5(ram_full_fb_i_reg_0[0]),
        .O(ram_full_fb_i_reg));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_3 ),
        .Q(ram_full_fb_i_reg_0[0]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_2 ),
        .Q(ram_full_fb_i_reg_0[1]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_1 ),
        .Q(ram_full_fb_i_reg_0[2]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_out),
        .Q(ram_full_fb_i_reg_0[3]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[0]),
        .Q(rd_pntr_gc[0]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[1]),
        .Q(rd_pntr_gc[1]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[2]),
        .Q(rd_pntr_gc[2]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[3]),
        .Q(rd_pntr_gc[3]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(p_0_in[0]),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(p_0_in[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(p_0_in[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(p_1_out),
        .Q(Q[3]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[0]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [0]),
        .I1(\gic0.gc0.count_d2_reg[3] [1]),
        .O(p_0_in2_out[0]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[1]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [1]),
        .I1(\gic0.gc0.count_d2_reg[3] [2]),
        .O(p_0_in2_out[1]));
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[2]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [2]),
        .I1(\gic0.gc0.count_d2_reg[3] [3]),
        .O(p_0_in2_out[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[0]),
        .Q(wr_pntr_gc[0]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[1]),
        .Q(wr_pntr_gc[1]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[2]),
        .Q(wr_pntr_gc[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gic0.gc0.count_d2_reg[3] [3]),
        .Q(wr_pntr_gc[3]));
endmodule

(* ORIG_REF_NAME = "clk_x_pntrs" *) 
module xilinx_axi_clock_converter_clk_x_pntrs_36
   (ram_full_fb_i_reg,
    Q,
    ram_empty_fb_i_reg,
    ram_empty_fb_i_reg_0,
    \gic0.gc0.count_d1_reg[2] ,
    \gc0.count_reg[2] ,
    \gic0.gc0.count_d2_reg[3] ,
    m_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ,
    s_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ,
    D);
  output ram_full_fb_i_reg;
  output [3:0]Q;
  output ram_empty_fb_i_reg;
  output [3:0]ram_empty_fb_i_reg_0;
  input [2:0]\gic0.gc0.count_d1_reg[2] ;
  input [2:0]\gc0.count_reg[2] ;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  input [3:0]D;

  wire [3:0]D;
  wire [3:0]Q;
  wire [2:0]\gc0.count_reg[2] ;
  wire [2:0]\gic0.gc0.count_d1_reg[2] ;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire \gsync_stage[3].rd_stg_inst_n_1 ;
  wire \gsync_stage[3].rd_stg_inst_n_2 ;
  wire \gsync_stage[3].rd_stg_inst_n_3 ;
  wire \gsync_stage[3].wr_stg_inst_n_1 ;
  wire \gsync_stage[3].wr_stg_inst_n_2 ;
  wire \gsync_stage[3].wr_stg_inst_n_3 ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire [2:0]p_0_in2_out;
  wire [3:3]p_0_out;
  wire [3:3]p_1_out;
  wire [3:0]p_2_out;
  wire [3:0]p_3_out;
  wire [3:0]p_4_out;
  wire [3:0]p_5_out;
  wire ram_empty_fb_i_reg;
  wire [3:0]ram_empty_fb_i_reg_0;
  wire ram_full_fb_i_reg;
  wire \rd_pntr_gc_reg_n_0_[0] ;
  wire \rd_pntr_gc_reg_n_0_[1] ;
  wire \rd_pntr_gc_reg_n_0_[2] ;
  wire \rd_pntr_gc_reg_n_0_[3] ;
  wire s_aclk;
  wire \wr_pntr_gc_reg_n_0_[0] ;
  wire \wr_pntr_gc_reg_n_0_[1] ;
  wire \wr_pntr_gc_reg_n_0_[2] ;
  wire \wr_pntr_gc_reg_n_0_[3] ;

  xilinx_axi_clock_converter_synchronizer_ff_45 \gsync_stage[1].rd_stg_inst 
       (.D(p_5_out),
        .Q({\wr_pntr_gc_reg_n_0_[3] ,\wr_pntr_gc_reg_n_0_[2] ,\wr_pntr_gc_reg_n_0_[1] ,\wr_pntr_gc_reg_n_0_[0] }),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_synchronizer_ff_46 \gsync_stage[1].wr_stg_inst 
       (.D(p_4_out),
        .Q({\rd_pntr_gc_reg_n_0_[3] ,\rd_pntr_gc_reg_n_0_[2] ,\rd_pntr_gc_reg_n_0_[1] ,\rd_pntr_gc_reg_n_0_[0] }),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ));
  xilinx_axi_clock_converter_synchronizer_ff_47 \gsync_stage[2].rd_stg_inst 
       (.D(p_3_out),
        .\Q_reg_reg[3]_0 (p_5_out),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_synchronizer_ff_48 \gsync_stage[2].wr_stg_inst 
       (.D(p_2_out),
        .\Q_reg_reg[3]_0 (p_4_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ));
  xilinx_axi_clock_converter_synchronizer_ff_49 \gsync_stage[3].rd_stg_inst 
       (.D(p_3_out),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .out(p_1_out),
        .s_aclk(s_aclk),
        .\wr_pntr_bin_reg[2] ({\gsync_stage[3].rd_stg_inst_n_1 ,\gsync_stage[3].rd_stg_inst_n_2 ,\gsync_stage[3].rd_stg_inst_n_3 }));
  xilinx_axi_clock_converter_synchronizer_ff_50 \gsync_stage[3].wr_stg_inst 
       (.D(p_2_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .out(p_0_out),
        .\rd_pntr_bin_reg[2] ({\gsync_stage[3].wr_stg_inst_n_1 ,\gsync_stage[3].wr_stg_inst_n_2 ,\gsync_stage[3].wr_stg_inst_n_3 }));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    ram_empty_fb_i_i_4__3
       (.I0(ram_empty_fb_i_reg_0[2]),
        .I1(\gc0.count_reg[2] [2]),
        .I2(ram_empty_fb_i_reg_0[1]),
        .I3(\gc0.count_reg[2] [1]),
        .I4(\gc0.count_reg[2] [0]),
        .I5(ram_empty_fb_i_reg_0[0]),
        .O(ram_empty_fb_i_reg));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    ram_full_fb_i_i_5__0
       (.I0(Q[2]),
        .I1(\gic0.gc0.count_d1_reg[2] [2]),
        .I2(Q[1]),
        .I3(\gic0.gc0.count_d1_reg[2] [1]),
        .I4(\gic0.gc0.count_d1_reg[2] [0]),
        .I5(Q[0]),
        .O(ram_full_fb_i_reg));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_3 ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_2 ),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_1 ),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_out),
        .Q(Q[3]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[0]),
        .Q(\rd_pntr_gc_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[1]),
        .Q(\rd_pntr_gc_reg_n_0_[1] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[2]),
        .Q(\rd_pntr_gc_reg_n_0_[2] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[3]),
        .Q(\rd_pntr_gc_reg_n_0_[3] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_3 ),
        .Q(ram_empty_fb_i_reg_0[0]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_2 ),
        .Q(ram_empty_fb_i_reg_0[1]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_1 ),
        .Q(ram_empty_fb_i_reg_0[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(p_1_out),
        .Q(ram_empty_fb_i_reg_0[3]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[0]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [0]),
        .I1(\gic0.gc0.count_d2_reg[3] [1]),
        .O(p_0_in2_out[0]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[1]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [1]),
        .I1(\gic0.gc0.count_d2_reg[3] [2]),
        .O(p_0_in2_out[1]));
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[2]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [2]),
        .I1(\gic0.gc0.count_d2_reg[3] [3]),
        .O(p_0_in2_out[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[0]),
        .Q(\wr_pntr_gc_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[1]),
        .Q(\wr_pntr_gc_reg_n_0_[1] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[2]),
        .Q(\wr_pntr_gc_reg_n_0_[2] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gic0.gc0.count_d2_reg[3] [3]),
        .Q(\wr_pntr_gc_reg_n_0_[3] ));
endmodule

(* ORIG_REF_NAME = "clk_x_pntrs" *) 
module xilinx_axi_clock_converter_clk_x_pntrs_52
   (ram_empty_fb_i_reg,
    Q,
    ram_full_fb_i_reg,
    ram_full_fb_i_reg_0,
    \gc0.count_reg[2] ,
    \gic0.gc0.count_d1_reg[2] ,
    \gic0.gc0.count_d2_reg[3] ,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ,
    D);
  output ram_empty_fb_i_reg;
  output [3:0]Q;
  output ram_full_fb_i_reg;
  output [3:0]ram_full_fb_i_reg_0;
  input [2:0]\gc0.count_reg[2] ;
  input [2:0]\gic0.gc0.count_d1_reg[2] ;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  input [3:0]D;

  wire [3:0]D;
  wire [3:0]Q;
  wire [2:0]\gc0.count_reg[2] ;
  wire [2:0]\gic0.gc0.count_d1_reg[2] ;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire \gsync_stage[3].rd_stg_inst_n_1 ;
  wire \gsync_stage[3].rd_stg_inst_n_2 ;
  wire \gsync_stage[3].rd_stg_inst_n_3 ;
  wire \gsync_stage[3].wr_stg_inst_n_1 ;
  wire \gsync_stage[3].wr_stg_inst_n_2 ;
  wire \gsync_stage[3].wr_stg_inst_n_3 ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire [2:0]p_0_in2_out;
  wire [3:3]p_0_out;
  wire [3:3]p_1_out;
  wire [3:0]p_2_out;
  wire [3:0]p_3_out;
  wire [3:0]p_4_out;
  wire [3:0]p_5_out;
  wire ram_empty_fb_i_reg;
  wire ram_full_fb_i_reg;
  wire [3:0]ram_full_fb_i_reg_0;
  wire \rd_pntr_gc_reg_n_0_[0] ;
  wire \rd_pntr_gc_reg_n_0_[1] ;
  wire \rd_pntr_gc_reg_n_0_[2] ;
  wire \rd_pntr_gc_reg_n_0_[3] ;
  wire s_aclk;
  wire \wr_pntr_gc_reg_n_0_[0] ;
  wire \wr_pntr_gc_reg_n_0_[1] ;
  wire \wr_pntr_gc_reg_n_0_[2] ;
  wire \wr_pntr_gc_reg_n_0_[3] ;

  xilinx_axi_clock_converter_synchronizer_ff_63 \gsync_stage[1].rd_stg_inst 
       (.D(p_5_out),
        .Q({\wr_pntr_gc_reg_n_0_[3] ,\wr_pntr_gc_reg_n_0_[2] ,\wr_pntr_gc_reg_n_0_[1] ,\wr_pntr_gc_reg_n_0_[0] }),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ));
  xilinx_axi_clock_converter_synchronizer_ff_64 \gsync_stage[1].wr_stg_inst 
       (.D(p_4_out),
        .Q({\rd_pntr_gc_reg_n_0_[3] ,\rd_pntr_gc_reg_n_0_[2] ,\rd_pntr_gc_reg_n_0_[1] ,\rd_pntr_gc_reg_n_0_[0] }),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_synchronizer_ff_65 \gsync_stage[2].rd_stg_inst 
       (.D(p_3_out),
        .\Q_reg_reg[3]_0 (p_5_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ));
  xilinx_axi_clock_converter_synchronizer_ff_66 \gsync_stage[2].wr_stg_inst 
       (.D(p_2_out),
        .\Q_reg_reg[3]_0 (p_4_out),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_synchronizer_ff_67 \gsync_stage[3].rd_stg_inst 
       (.D(p_3_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .out(p_1_out),
        .\wr_pntr_bin_reg[2] ({\gsync_stage[3].rd_stg_inst_n_1 ,\gsync_stage[3].rd_stg_inst_n_2 ,\gsync_stage[3].rd_stg_inst_n_3 }));
  xilinx_axi_clock_converter_synchronizer_ff_68 \gsync_stage[3].wr_stg_inst 
       (.D(p_2_out),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .out(p_0_out),
        .\rd_pntr_bin_reg[2] ({\gsync_stage[3].wr_stg_inst_n_1 ,\gsync_stage[3].wr_stg_inst_n_2 ,\gsync_stage[3].wr_stg_inst_n_3 }),
        .s_aclk(s_aclk));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    ram_empty_fb_i_i_4__1
       (.I0(Q[2]),
        .I1(\gc0.count_reg[2] [2]),
        .I2(Q[1]),
        .I3(\gc0.count_reg[2] [1]),
        .I4(\gc0.count_reg[2] [0]),
        .I5(Q[0]),
        .O(ram_empty_fb_i_reg));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    ram_full_fb_i_i_5__3
       (.I0(ram_full_fb_i_reg_0[2]),
        .I1(\gic0.gc0.count_d1_reg[2] [2]),
        .I2(ram_full_fb_i_reg_0[1]),
        .I3(\gic0.gc0.count_d1_reg[2] [1]),
        .I4(\gic0.gc0.count_d1_reg[2] [0]),
        .I5(ram_full_fb_i_reg_0[0]),
        .O(ram_full_fb_i_reg));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_3 ),
        .Q(ram_full_fb_i_reg_0[0]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_2 ),
        .Q(ram_full_fb_i_reg_0[1]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_1 ),
        .Q(ram_full_fb_i_reg_0[2]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_out),
        .Q(ram_full_fb_i_reg_0[3]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[0]),
        .Q(\rd_pntr_gc_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[1]),
        .Q(\rd_pntr_gc_reg_n_0_[1] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[2]),
        .Q(\rd_pntr_gc_reg_n_0_[2] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[3]),
        .Q(\rd_pntr_gc_reg_n_0_[3] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_3 ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_2 ),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_1 ),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(p_1_out),
        .Q(Q[3]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[0]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [0]),
        .I1(\gic0.gc0.count_d2_reg[3] [1]),
        .O(p_0_in2_out[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[1]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [1]),
        .I1(\gic0.gc0.count_d2_reg[3] [2]),
        .O(p_0_in2_out[1]));
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[2]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [2]),
        .I1(\gic0.gc0.count_d2_reg[3] [3]),
        .O(p_0_in2_out[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[0]),
        .Q(\wr_pntr_gc_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[1]),
        .Q(\wr_pntr_gc_reg_n_0_[1] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[2]),
        .Q(\wr_pntr_gc_reg_n_0_[2] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gic0.gc0.count_d2_reg[3] [3]),
        .Q(\wr_pntr_gc_reg_n_0_[3] ));
endmodule

(* ORIG_REF_NAME = "clk_x_pntrs" *) 
module xilinx_axi_clock_converter_clk_x_pntrs_6
   (ram_empty_fb_i_reg,
    Q,
    ram_full_fb_i_reg,
    ram_full_fb_i_reg_0,
    \gc0.count_reg[2] ,
    \gic0.gc0.count_d1_reg[2] ,
    \gic0.gc0.count_d2_reg[3] ,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ,
    D);
  output ram_empty_fb_i_reg;
  output [3:0]Q;
  output ram_full_fb_i_reg;
  output [3:0]ram_full_fb_i_reg_0;
  input [2:0]\gc0.count_reg[2] ;
  input [2:0]\gic0.gc0.count_d1_reg[2] ;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  input [3:0]D;

  wire [3:0]D;
  wire [3:0]Q;
  wire [2:0]\gc0.count_reg[2] ;
  wire [2:0]\gic0.gc0.count_d1_reg[2] ;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire \gsync_stage[3].rd_stg_inst_n_1 ;
  wire \gsync_stage[3].rd_stg_inst_n_2 ;
  wire \gsync_stage[3].rd_stg_inst_n_3 ;
  wire \gsync_stage[3].wr_stg_inst_n_1 ;
  wire \gsync_stage[3].wr_stg_inst_n_2 ;
  wire \gsync_stage[3].wr_stg_inst_n_3 ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire [2:0]p_0_in2_out;
  wire [3:3]p_0_out;
  wire [3:3]p_1_out;
  wire [3:0]p_2_out;
  wire [3:0]p_3_out;
  wire [3:0]p_4_out;
  wire [3:0]p_5_out;
  wire ram_empty_fb_i_reg;
  wire ram_full_fb_i_reg;
  wire [3:0]ram_full_fb_i_reg_0;
  wire \rd_pntr_gc_reg_n_0_[0] ;
  wire \rd_pntr_gc_reg_n_0_[1] ;
  wire \rd_pntr_gc_reg_n_0_[2] ;
  wire \rd_pntr_gc_reg_n_0_[3] ;
  wire s_aclk;
  wire \wr_pntr_gc_reg_n_0_[0] ;
  wire \wr_pntr_gc_reg_n_0_[1] ;
  wire \wr_pntr_gc_reg_n_0_[2] ;
  wire \wr_pntr_gc_reg_n_0_[3] ;

  xilinx_axi_clock_converter_synchronizer_ff_15 \gsync_stage[1].rd_stg_inst 
       (.D(p_5_out),
        .Q({\wr_pntr_gc_reg_n_0_[3] ,\wr_pntr_gc_reg_n_0_[2] ,\wr_pntr_gc_reg_n_0_[1] ,\wr_pntr_gc_reg_n_0_[0] }),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ));
  xilinx_axi_clock_converter_synchronizer_ff_16 \gsync_stage[1].wr_stg_inst 
       (.D(p_4_out),
        .Q({\rd_pntr_gc_reg_n_0_[3] ,\rd_pntr_gc_reg_n_0_[2] ,\rd_pntr_gc_reg_n_0_[1] ,\rd_pntr_gc_reg_n_0_[0] }),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_synchronizer_ff_17 \gsync_stage[2].rd_stg_inst 
       (.D(p_3_out),
        .\Q_reg_reg[3]_0 (p_5_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ));
  xilinx_axi_clock_converter_synchronizer_ff_18 \gsync_stage[2].wr_stg_inst 
       (.D(p_2_out),
        .\Q_reg_reg[3]_0 (p_4_out),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_synchronizer_ff_19 \gsync_stage[3].rd_stg_inst 
       (.D(p_3_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .out(p_1_out),
        .\wr_pntr_bin_reg[2] ({\gsync_stage[3].rd_stg_inst_n_1 ,\gsync_stage[3].rd_stg_inst_n_2 ,\gsync_stage[3].rd_stg_inst_n_3 }));
  xilinx_axi_clock_converter_synchronizer_ff_20 \gsync_stage[3].wr_stg_inst 
       (.D(p_2_out),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .out(p_0_out),
        .\rd_pntr_bin_reg[2] ({\gsync_stage[3].wr_stg_inst_n_1 ,\gsync_stage[3].wr_stg_inst_n_2 ,\gsync_stage[3].wr_stg_inst_n_3 }),
        .s_aclk(s_aclk));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    ram_empty_fb_i_i_4__0
       (.I0(Q[2]),
        .I1(\gc0.count_reg[2] [2]),
        .I2(Q[1]),
        .I3(\gc0.count_reg[2] [1]),
        .I4(\gc0.count_reg[2] [0]),
        .I5(Q[0]),
        .O(ram_empty_fb_i_reg));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    ram_full_fb_i_i_5__2
       (.I0(ram_full_fb_i_reg_0[2]),
        .I1(\gic0.gc0.count_d1_reg[2] [2]),
        .I2(ram_full_fb_i_reg_0[1]),
        .I3(\gic0.gc0.count_d1_reg[2] [1]),
        .I4(\gic0.gc0.count_d1_reg[2] [0]),
        .I5(ram_full_fb_i_reg_0[0]),
        .O(ram_full_fb_i_reg));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_3 ),
        .Q(ram_full_fb_i_reg_0[0]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_2 ),
        .Q(ram_full_fb_i_reg_0[1]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gsync_stage[3].wr_stg_inst_n_1 ),
        .Q(ram_full_fb_i_reg_0[2]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_bin_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_out),
        .Q(ram_full_fb_i_reg_0[3]));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[0]),
        .Q(\rd_pntr_gc_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[1]),
        .Q(\rd_pntr_gc_reg_n_0_[1] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[2]),
        .Q(\rd_pntr_gc_reg_n_0_[2] ));
  FDCE #(
    .INIT(1'b0)) 
    \rd_pntr_gc_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[3]),
        .Q(\rd_pntr_gc_reg_n_0_[3] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_3 ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_2 ),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\gsync_stage[3].rd_stg_inst_n_1 ),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_bin_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(p_1_out),
        .Q(Q[3]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[0]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [0]),
        .I1(\gic0.gc0.count_d2_reg[3] [1]),
        .O(p_0_in2_out[0]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[1]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [1]),
        .I1(\gic0.gc0.count_d2_reg[3] [2]),
        .O(p_0_in2_out[1]));
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_gc[2]_i_1 
       (.I0(\gic0.gc0.count_d2_reg[3] [2]),
        .I1(\gic0.gc0.count_d2_reg[3] [3]),
        .O(p_0_in2_out[2]));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[0]),
        .Q(\wr_pntr_gc_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[1]),
        .Q(\wr_pntr_gc_reg_n_0_[1] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(p_0_in2_out[2]),
        .Q(\wr_pntr_gc_reg_n_0_[2] ));
  FDCE #(
    .INIT(1'b0)) 
    \wr_pntr_gc_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\gic0.gc0.count_d2_reg[3] [3]),
        .Q(\wr_pntr_gc_reg_n_0_[3] ));
endmodule

(* ORIG_REF_NAME = "dmem" *) 
module xilinx_axi_clock_converter_dmem
   (D,
    ram_rd_en_i,
    m_aclk,
    s_aclk,
    E,
    DI,
    ADDRA,
    \gic0.gc0.count_d2_reg[3] );
  output [76:0]D;
  input ram_rd_en_i;
  input m_aclk;
  input s_aclk;
  input [0:0]E;
  input [76:0]DI;
  input [3:0]ADDRA;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;

  wire [3:0]ADDRA;
  wire [76:0]D;
  wire [76:0]DI;
  wire [0:0]E;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire m_aclk;
  wire [76:0]p_0_out;
  wire ram_rd_en_i;
  wire s_aclk;
  wire [1:0]NLW_RAM_reg_0_15_0_5_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_12_17_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_18_23_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_24_29_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_30_35_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_36_41_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_42_47_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_48_53_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_54_59_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_60_65_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_66_71_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_6_11_DOD_UNCONNECTED;
  wire [1:1]NLW_RAM_reg_0_15_72_76_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_72_76_DOD_UNCONNECTED;

  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_0_5
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[1:0]),
        .DIB(DI[3:2]),
        .DIC(DI[5:4]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[1:0]),
        .DOB(p_0_out[3:2]),
        .DOC(p_0_out[5:4]),
        .DOD(NLW_RAM_reg_0_15_0_5_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_12_17
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[13:12]),
        .DIB(DI[15:14]),
        .DIC(DI[17:16]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[13:12]),
        .DOB(p_0_out[15:14]),
        .DOC(p_0_out[17:16]),
        .DOD(NLW_RAM_reg_0_15_12_17_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_18_23
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[19:18]),
        .DIB(DI[21:20]),
        .DIC(DI[23:22]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[19:18]),
        .DOB(p_0_out[21:20]),
        .DOC(p_0_out[23:22]),
        .DOD(NLW_RAM_reg_0_15_18_23_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_24_29
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[25:24]),
        .DIB(DI[27:26]),
        .DIC(DI[29:28]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[25:24]),
        .DOB(p_0_out[27:26]),
        .DOC(p_0_out[29:28]),
        .DOD(NLW_RAM_reg_0_15_24_29_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_30_35
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[31:30]),
        .DIB(DI[33:32]),
        .DIC(DI[35:34]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[31:30]),
        .DOB(p_0_out[33:32]),
        .DOC(p_0_out[35:34]),
        .DOD(NLW_RAM_reg_0_15_30_35_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_36_41
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[37:36]),
        .DIB(DI[39:38]),
        .DIC(DI[41:40]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[37:36]),
        .DOB(p_0_out[39:38]),
        .DOC(p_0_out[41:40]),
        .DOD(NLW_RAM_reg_0_15_36_41_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_42_47
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[43:42]),
        .DIB(DI[45:44]),
        .DIC(DI[47:46]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[43:42]),
        .DOB(p_0_out[45:44]),
        .DOC(p_0_out[47:46]),
        .DOD(NLW_RAM_reg_0_15_42_47_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_48_53
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[49:48]),
        .DIB(DI[51:50]),
        .DIC(DI[53:52]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[49:48]),
        .DOB(p_0_out[51:50]),
        .DOC(p_0_out[53:52]),
        .DOD(NLW_RAM_reg_0_15_48_53_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_54_59
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[55:54]),
        .DIB(DI[57:56]),
        .DIC(DI[59:58]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[55:54]),
        .DOB(p_0_out[57:56]),
        .DOC(p_0_out[59:58]),
        .DOD(NLW_RAM_reg_0_15_54_59_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_60_65
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[61:60]),
        .DIB(DI[63:62]),
        .DIC(DI[65:64]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[61:60]),
        .DOB(p_0_out[63:62]),
        .DOC(p_0_out[65:64]),
        .DOD(NLW_RAM_reg_0_15_60_65_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_66_71
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[67:66]),
        .DIB(DI[69:68]),
        .DIC(DI[71:70]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[67:66]),
        .DOB(p_0_out[69:68]),
        .DOC(p_0_out[71:70]),
        .DOD(NLW_RAM_reg_0_15_66_71_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_6_11
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[7:6]),
        .DIB(DI[9:8]),
        .DIC(DI[11:10]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[7:6]),
        .DOB(p_0_out[9:8]),
        .DOC(p_0_out[11:10]),
        .DOD(NLW_RAM_reg_0_15_6_11_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_72_76
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(DI[73:72]),
        .DIB(DI[75:74]),
        .DIC({1'b0,DI[76]}),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[73:72]),
        .DOB(p_0_out[75:74]),
        .DOC({NLW_RAM_reg_0_15_72_76_DOC_UNCONNECTED[1],p_0_out[76]}),
        .DOD(NLW_RAM_reg_0_15_72_76_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[0] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[0]),
        .Q(D[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[10] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[10]),
        .Q(D[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[11] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[11]),
        .Q(D[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[12] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[12]),
        .Q(D[12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[13] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[13]),
        .Q(D[13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[14] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[14]),
        .Q(D[14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[15] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[15]),
        .Q(D[15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[16] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[16]),
        .Q(D[16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[17] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[17]),
        .Q(D[17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[18] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[18]),
        .Q(D[18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[19] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[19]),
        .Q(D[19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[1] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[1]),
        .Q(D[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[20] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[20]),
        .Q(D[20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[21] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[21]),
        .Q(D[21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[22] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[22]),
        .Q(D[22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[23] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[23]),
        .Q(D[23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[24] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[24]),
        .Q(D[24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[25] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[25]),
        .Q(D[25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[26] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[26]),
        .Q(D[26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[27] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[27]),
        .Q(D[27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[28] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[28]),
        .Q(D[28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[29] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[29]),
        .Q(D[29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[2] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[2]),
        .Q(D[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[30] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[30]),
        .Q(D[30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[31] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[31]),
        .Q(D[31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[32] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[32]),
        .Q(D[32]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[33] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[33]),
        .Q(D[33]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[34] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[34]),
        .Q(D[34]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[35] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[35]),
        .Q(D[35]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[36] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[36]),
        .Q(D[36]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[37] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[37]),
        .Q(D[37]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[38] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[38]),
        .Q(D[38]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[39] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[39]),
        .Q(D[39]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[3] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[3]),
        .Q(D[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[40] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[40]),
        .Q(D[40]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[41] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[41]),
        .Q(D[41]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[42] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[42]),
        .Q(D[42]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[43] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[43]),
        .Q(D[43]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[44] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[44]),
        .Q(D[44]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[45] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[45]),
        .Q(D[45]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[46] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[46]),
        .Q(D[46]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[47] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[47]),
        .Q(D[47]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[48] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[48]),
        .Q(D[48]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[49] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[49]),
        .Q(D[49]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[4] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[4]),
        .Q(D[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[50] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[50]),
        .Q(D[50]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[51] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[51]),
        .Q(D[51]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[52] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[52]),
        .Q(D[52]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[53] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[53]),
        .Q(D[53]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[54] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[54]),
        .Q(D[54]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[55] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[55]),
        .Q(D[55]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[56] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[56]),
        .Q(D[56]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[57] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[57]),
        .Q(D[57]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[58] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[58]),
        .Q(D[58]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[59] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[59]),
        .Q(D[59]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[5] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[5]),
        .Q(D[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[60] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[60]),
        .Q(D[60]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[61] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[61]),
        .Q(D[61]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[62] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[62]),
        .Q(D[62]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[63] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[63]),
        .Q(D[63]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[64] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[64]),
        .Q(D[64]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[65] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[65]),
        .Q(D[65]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[66] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[66]),
        .Q(D[66]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[67] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[67]),
        .Q(D[67]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[68] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[68]),
        .Q(D[68]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[69] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[69]),
        .Q(D[69]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[6] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[6]),
        .Q(D[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[70] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[70]),
        .Q(D[70]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[71] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[71]),
        .Q(D[71]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[72] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[72]),
        .Q(D[72]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[73] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[73]),
        .Q(D[73]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[74] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[74]),
        .Q(D[74]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[75] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[75]),
        .Q(D[75]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[76] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[76]),
        .Q(D[76]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[7] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[7]),
        .Q(D[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[8] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[8]),
        .Q(D[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[9] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[9]),
        .Q(D[9]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "dmem" *) 
module xilinx_axi_clock_converter_dmem_57
   (D,
    ram_rd_en_i,
    m_aclk,
    s_aclk,
    E,
    I42,
    ADDRA,
    \gic0.gc0.count_d2_reg[3] );
  output [76:0]D;
  input ram_rd_en_i;
  input m_aclk;
  input s_aclk;
  input [0:0]E;
  input [76:0]I42;
  input [3:0]ADDRA;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;

  wire [3:0]ADDRA;
  wire [76:0]D;
  wire [0:0]E;
  wire [76:0]I42;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire m_aclk;
  wire [76:0]p_0_out;
  wire ram_rd_en_i;
  wire s_aclk;
  wire [1:0]NLW_RAM_reg_0_15_0_5_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_12_17_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_18_23_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_24_29_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_30_35_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_36_41_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_42_47_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_48_53_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_54_59_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_60_65_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_66_71_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_6_11_DOD_UNCONNECTED;
  wire [1:1]NLW_RAM_reg_0_15_72_76_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_72_76_DOD_UNCONNECTED;

  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_0_5
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[1:0]),
        .DIB(I42[3:2]),
        .DIC(I42[5:4]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[1:0]),
        .DOB(p_0_out[3:2]),
        .DOC(p_0_out[5:4]),
        .DOD(NLW_RAM_reg_0_15_0_5_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_12_17
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[13:12]),
        .DIB(I42[15:14]),
        .DIC(I42[17:16]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[13:12]),
        .DOB(p_0_out[15:14]),
        .DOC(p_0_out[17:16]),
        .DOD(NLW_RAM_reg_0_15_12_17_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_18_23
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[19:18]),
        .DIB(I42[21:20]),
        .DIC(I42[23:22]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[19:18]),
        .DOB(p_0_out[21:20]),
        .DOC(p_0_out[23:22]),
        .DOD(NLW_RAM_reg_0_15_18_23_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_24_29
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[25:24]),
        .DIB(I42[27:26]),
        .DIC(I42[29:28]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[25:24]),
        .DOB(p_0_out[27:26]),
        .DOC(p_0_out[29:28]),
        .DOD(NLW_RAM_reg_0_15_24_29_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_30_35
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[31:30]),
        .DIB(I42[33:32]),
        .DIC(I42[35:34]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[31:30]),
        .DOB(p_0_out[33:32]),
        .DOC(p_0_out[35:34]),
        .DOD(NLW_RAM_reg_0_15_30_35_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_36_41
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[37:36]),
        .DIB(I42[39:38]),
        .DIC(I42[41:40]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[37:36]),
        .DOB(p_0_out[39:38]),
        .DOC(p_0_out[41:40]),
        .DOD(NLW_RAM_reg_0_15_36_41_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_42_47
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[43:42]),
        .DIB(I42[45:44]),
        .DIC(I42[47:46]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[43:42]),
        .DOB(p_0_out[45:44]),
        .DOC(p_0_out[47:46]),
        .DOD(NLW_RAM_reg_0_15_42_47_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_48_53
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[49:48]),
        .DIB(I42[51:50]),
        .DIC(I42[53:52]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[49:48]),
        .DOB(p_0_out[51:50]),
        .DOC(p_0_out[53:52]),
        .DOD(NLW_RAM_reg_0_15_48_53_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_54_59
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[55:54]),
        .DIB(I42[57:56]),
        .DIC(I42[59:58]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[55:54]),
        .DOB(p_0_out[57:56]),
        .DOC(p_0_out[59:58]),
        .DOD(NLW_RAM_reg_0_15_54_59_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_60_65
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[61:60]),
        .DIB(I42[63:62]),
        .DIC(I42[65:64]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[61:60]),
        .DOB(p_0_out[63:62]),
        .DOC(p_0_out[65:64]),
        .DOD(NLW_RAM_reg_0_15_60_65_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_66_71
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[67:66]),
        .DIB(I42[69:68]),
        .DIC(I42[71:70]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[67:66]),
        .DOB(p_0_out[69:68]),
        .DOC(p_0_out[71:70]),
        .DOD(NLW_RAM_reg_0_15_66_71_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_6_11
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[7:6]),
        .DIB(I42[9:8]),
        .DIC(I42[11:10]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[7:6]),
        .DOB(p_0_out[9:8]),
        .DOC(p_0_out[11:10]),
        .DOD(NLW_RAM_reg_0_15_6_11_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_72_76
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I42[73:72]),
        .DIB(I42[75:74]),
        .DIC({1'b0,I42[76]}),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[73:72]),
        .DOB(p_0_out[75:74]),
        .DOC({NLW_RAM_reg_0_15_72_76_DOC_UNCONNECTED[1],p_0_out[76]}),
        .DOD(NLW_RAM_reg_0_15_72_76_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[0] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[0]),
        .Q(D[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[10] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[10]),
        .Q(D[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[11] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[11]),
        .Q(D[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[12] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[12]),
        .Q(D[12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[13] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[13]),
        .Q(D[13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[14] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[14]),
        .Q(D[14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[15] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[15]),
        .Q(D[15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[16] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[16]),
        .Q(D[16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[17] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[17]),
        .Q(D[17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[18] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[18]),
        .Q(D[18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[19] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[19]),
        .Q(D[19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[1] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[1]),
        .Q(D[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[20] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[20]),
        .Q(D[20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[21] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[21]),
        .Q(D[21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[22] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[22]),
        .Q(D[22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[23] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[23]),
        .Q(D[23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[24] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[24]),
        .Q(D[24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[25] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[25]),
        .Q(D[25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[26] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[26]),
        .Q(D[26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[27] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[27]),
        .Q(D[27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[28] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[28]),
        .Q(D[28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[29] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[29]),
        .Q(D[29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[2] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[2]),
        .Q(D[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[30] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[30]),
        .Q(D[30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[31] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[31]),
        .Q(D[31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[32] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[32]),
        .Q(D[32]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[33] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[33]),
        .Q(D[33]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[34] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[34]),
        .Q(D[34]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[35] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[35]),
        .Q(D[35]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[36] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[36]),
        .Q(D[36]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[37] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[37]),
        .Q(D[37]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[38] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[38]),
        .Q(D[38]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[39] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[39]),
        .Q(D[39]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[3] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[3]),
        .Q(D[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[40] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[40]),
        .Q(D[40]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[41] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[41]),
        .Q(D[41]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[42] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[42]),
        .Q(D[42]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[43] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[43]),
        .Q(D[43]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[44] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[44]),
        .Q(D[44]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[45] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[45]),
        .Q(D[45]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[46] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[46]),
        .Q(D[46]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[47] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[47]),
        .Q(D[47]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[48] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[48]),
        .Q(D[48]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[49] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[49]),
        .Q(D[49]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[4] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[4]),
        .Q(D[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[50] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[50]),
        .Q(D[50]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[51] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[51]),
        .Q(D[51]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[52] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[52]),
        .Q(D[52]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[53] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[53]),
        .Q(D[53]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[54] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[54]),
        .Q(D[54]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[55] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[55]),
        .Q(D[55]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[56] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[56]),
        .Q(D[56]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[57] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[57]),
        .Q(D[57]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[58] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[58]),
        .Q(D[58]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[59] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[59]),
        .Q(D[59]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[5] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[5]),
        .Q(D[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[60] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[60]),
        .Q(D[60]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[61] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[61]),
        .Q(D[61]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[62] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[62]),
        .Q(D[62]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[63] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[63]),
        .Q(D[63]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[64] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[64]),
        .Q(D[64]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[65] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[65]),
        .Q(D[65]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[66] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[66]),
        .Q(D[66]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[67] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[67]),
        .Q(D[67]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[68] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[68]),
        .Q(D[68]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[69] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[69]),
        .Q(D[69]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[6] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[6]),
        .Q(D[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[70] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[70]),
        .Q(D[70]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[71] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[71]),
        .Q(D[71]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[72] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[72]),
        .Q(D[72]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[73] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[73]),
        .Q(D[73]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[74] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[74]),
        .Q(D[74]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[75] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[75]),
        .Q(D[75]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[76] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[76]),
        .Q(D[76]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[7] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[7]),
        .Q(D[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[8] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[8]),
        .Q(D[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[9] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[9]),
        .Q(D[9]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "dmem" *) 
module xilinx_axi_clock_converter_dmem__parameterized0
   (D,
    ram_rd_en_i,
    m_aclk,
    s_aclk,
    E,
    I12,
    ADDRA,
    \gic0.gc0.count_d2_reg[3] );
  output [36:0]D;
  input ram_rd_en_i;
  input m_aclk;
  input s_aclk;
  input [0:0]E;
  input [36:0]I12;
  input [3:0]ADDRA;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;

  wire [3:0]ADDRA;
  wire [36:0]D;
  wire [0:0]E;
  wire [36:0]I12;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire m_aclk;
  wire [36:0]p_0_out;
  wire ram_rd_en_i;
  wire s_aclk;
  wire [1:0]NLW_RAM_reg_0_15_0_5_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_12_17_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_18_23_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_24_29_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_30_35_DOD_UNCONNECTED;
  wire [1:1]NLW_RAM_reg_0_15_36_36_DOA_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_36_36_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_36_36_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_36_36_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_6_11_DOD_UNCONNECTED;

  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_0_5
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I12[1:0]),
        .DIB(I12[3:2]),
        .DIC(I12[5:4]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[1:0]),
        .DOB(p_0_out[3:2]),
        .DOC(p_0_out[5:4]),
        .DOD(NLW_RAM_reg_0_15_0_5_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_12_17
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I12[13:12]),
        .DIB(I12[15:14]),
        .DIC(I12[17:16]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[13:12]),
        .DOB(p_0_out[15:14]),
        .DOC(p_0_out[17:16]),
        .DOD(NLW_RAM_reg_0_15_12_17_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_18_23
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I12[19:18]),
        .DIB(I12[21:20]),
        .DIC(I12[23:22]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[19:18]),
        .DOB(p_0_out[21:20]),
        .DOC(p_0_out[23:22]),
        .DOD(NLW_RAM_reg_0_15_18_23_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_24_29
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I12[25:24]),
        .DIB(I12[27:26]),
        .DIC(I12[29:28]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[25:24]),
        .DOB(p_0_out[27:26]),
        .DOC(p_0_out[29:28]),
        .DOD(NLW_RAM_reg_0_15_24_29_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_30_35
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I12[31:30]),
        .DIB(I12[33:32]),
        .DIC(I12[35:34]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[31:30]),
        .DOB(p_0_out[33:32]),
        .DOC(p_0_out[35:34]),
        .DOD(NLW_RAM_reg_0_15_30_35_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_36_36
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA({1'b0,I12[36]}),
        .DIB({1'b0,1'b0}),
        .DIC({1'b0,1'b0}),
        .DID({1'b0,1'b0}),
        .DOA({NLW_RAM_reg_0_15_36_36_DOA_UNCONNECTED[1],p_0_out[36]}),
        .DOB(NLW_RAM_reg_0_15_36_36_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM_reg_0_15_36_36_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM_reg_0_15_36_36_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_6_11
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I12[7:6]),
        .DIB(I12[9:8]),
        .DIC(I12[11:10]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[7:6]),
        .DOB(p_0_out[9:8]),
        .DOC(p_0_out[11:10]),
        .DOD(NLW_RAM_reg_0_15_6_11_DOD_UNCONNECTED[1:0]),
        .WCLK(s_aclk),
        .WE(E));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[0] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[0]),
        .Q(D[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[10] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[10]),
        .Q(D[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[11] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[11]),
        .Q(D[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[12] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[12]),
        .Q(D[12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[13] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[13]),
        .Q(D[13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[14] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[14]),
        .Q(D[14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[15] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[15]),
        .Q(D[15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[16] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[16]),
        .Q(D[16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[17] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[17]),
        .Q(D[17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[18] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[18]),
        .Q(D[18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[19] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[19]),
        .Q(D[19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[1] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[1]),
        .Q(D[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[20] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[20]),
        .Q(D[20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[21] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[21]),
        .Q(D[21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[22] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[22]),
        .Q(D[22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[23] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[23]),
        .Q(D[23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[24] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[24]),
        .Q(D[24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[25] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[25]),
        .Q(D[25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[26] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[26]),
        .Q(D[26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[27] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[27]),
        .Q(D[27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[28] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[28]),
        .Q(D[28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[29] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[29]),
        .Q(D[29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[2] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[2]),
        .Q(D[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[30] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[30]),
        .Q(D[30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[31] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[31]),
        .Q(D[31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[32] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[32]),
        .Q(D[32]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[33] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[33]),
        .Q(D[33]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[34] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[34]),
        .Q(D[34]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[35] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[35]),
        .Q(D[35]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[36] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[36]),
        .Q(D[36]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[3] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[3]),
        .Q(D[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[4] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[4]),
        .Q(D[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[5] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[5]),
        .Q(D[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[6] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[6]),
        .Q(D[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[7] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[7]),
        .Q(D[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[8] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[8]),
        .Q(D[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[9] 
       (.C(m_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[9]),
        .Q(D[9]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "dmem" *) 
module xilinx_axi_clock_converter_dmem__parameterized1
   (D,
    ram_rd_en_i,
    s_aclk,
    m_aclk,
    I26,
    I27,
    ADDRA,
    \gic0.gc0.count_d2_reg[3] );
  output [17:0]D;
  input ram_rd_en_i;
  input s_aclk;
  input m_aclk;
  input I26;
  input [17:0]I27;
  input [3:0]ADDRA;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;

  wire [3:0]ADDRA;
  wire [17:0]D;
  wire I26;
  wire [17:0]I27;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire m_aclk;
  wire [17:0]p_0_out;
  wire ram_rd_en_i;
  wire s_aclk;
  wire [1:0]NLW_RAM_reg_0_15_0_5_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_12_17_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_6_11_DOD_UNCONNECTED;

  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_0_5
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I27[1:0]),
        .DIB(I27[3:2]),
        .DIC(I27[5:4]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[1:0]),
        .DOB(p_0_out[3:2]),
        .DOC(p_0_out[5:4]),
        .DOD(NLW_RAM_reg_0_15_0_5_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(I26));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_12_17
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I27[13:12]),
        .DIB(I27[15:14]),
        .DIC(I27[17:16]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[13:12]),
        .DOB(p_0_out[15:14]),
        .DOC(p_0_out[17:16]),
        .DOD(NLW_RAM_reg_0_15_12_17_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(I26));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_6_11
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I27[7:6]),
        .DIB(I27[9:8]),
        .DIC(I27[11:10]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[7:6]),
        .DOB(p_0_out[9:8]),
        .DOC(p_0_out[11:10]),
        .DOD(NLW_RAM_reg_0_15_6_11_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(I26));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[0] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[0]),
        .Q(D[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[10] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[10]),
        .Q(D[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[11] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[11]),
        .Q(D[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[12] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[12]),
        .Q(D[12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[13] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[13]),
        .Q(D[13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[14] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[14]),
        .Q(D[14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[15] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[15]),
        .Q(D[15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[16] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[16]),
        .Q(D[16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[17] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[17]),
        .Q(D[17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[1] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[1]),
        .Q(D[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[2] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[2]),
        .Q(D[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[3] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[3]),
        .Q(D[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[4] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[4]),
        .Q(D[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[5] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[5]),
        .Q(D[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[6] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[6]),
        .Q(D[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[7] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[7]),
        .Q(D[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[8] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[8]),
        .Q(D[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[9] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[9]),
        .Q(D[9]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "dmem" *) 
module xilinx_axi_clock_converter_dmem__parameterized2
   (D,
    ram_rd_en_i,
    s_aclk,
    m_aclk,
    E,
    I57,
    ADDRA,
    \gic0.gc0.count_d2_reg[3] );
  output [50:0]D;
  input ram_rd_en_i;
  input s_aclk;
  input m_aclk;
  input [0:0]E;
  input [50:0]I57;
  input [3:0]ADDRA;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;

  wire [3:0]ADDRA;
  wire [50:0]D;
  wire [0:0]E;
  wire [50:0]I57;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire m_aclk;
  wire [50:0]p_0_out;
  wire ram_rd_en_i;
  wire s_aclk;
  wire [1:0]NLW_RAM_reg_0_15_0_5_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_12_17_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_18_23_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_24_29_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_30_35_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_36_41_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_42_47_DOD_UNCONNECTED;
  wire [1:1]NLW_RAM_reg_0_15_48_50_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_48_50_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_48_50_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_15_6_11_DOD_UNCONNECTED;

  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_0_5
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I57[1:0]),
        .DIB(I57[3:2]),
        .DIC(I57[5:4]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[1:0]),
        .DOB(p_0_out[3:2]),
        .DOC(p_0_out[5:4]),
        .DOD(NLW_RAM_reg_0_15_0_5_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_12_17
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I57[13:12]),
        .DIB(I57[15:14]),
        .DIC(I57[17:16]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[13:12]),
        .DOB(p_0_out[15:14]),
        .DOC(p_0_out[17:16]),
        .DOD(NLW_RAM_reg_0_15_12_17_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_18_23
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I57[19:18]),
        .DIB(I57[21:20]),
        .DIC(I57[23:22]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[19:18]),
        .DOB(p_0_out[21:20]),
        .DOC(p_0_out[23:22]),
        .DOD(NLW_RAM_reg_0_15_18_23_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_24_29
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I57[25:24]),
        .DIB(I57[27:26]),
        .DIC(I57[29:28]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[25:24]),
        .DOB(p_0_out[27:26]),
        .DOC(p_0_out[29:28]),
        .DOD(NLW_RAM_reg_0_15_24_29_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_30_35
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I57[31:30]),
        .DIB(I57[33:32]),
        .DIC(I57[35:34]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[31:30]),
        .DOB(p_0_out[33:32]),
        .DOC(p_0_out[35:34]),
        .DOD(NLW_RAM_reg_0_15_30_35_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_36_41
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I57[37:36]),
        .DIB(I57[39:38]),
        .DIC(I57[41:40]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[37:36]),
        .DOB(p_0_out[39:38]),
        .DOC(p_0_out[41:40]),
        .DOD(NLW_RAM_reg_0_15_36_41_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_42_47
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I57[43:42]),
        .DIB(I57[45:44]),
        .DIC(I57[47:46]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[43:42]),
        .DOB(p_0_out[45:44]),
        .DOC(p_0_out[47:46]),
        .DOD(NLW_RAM_reg_0_15_42_47_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_48_50
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I57[49:48]),
        .DIB({1'b0,I57[50]}),
        .DIC({1'b0,1'b0}),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[49:48]),
        .DOB({NLW_RAM_reg_0_15_48_50_DOB_UNCONNECTED[1],p_0_out[50]}),
        .DOC(NLW_RAM_reg_0_15_48_50_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM_reg_0_15_48_50_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(E));
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    RAM_reg_0_15_6_11
       (.ADDRA({1'b0,ADDRA}),
        .ADDRB({1'b0,ADDRA}),
        .ADDRC({1'b0,ADDRA}),
        .ADDRD({1'b0,\gic0.gc0.count_d2_reg[3] }),
        .DIA(I57[7:6]),
        .DIB(I57[9:8]),
        .DIC(I57[11:10]),
        .DID({1'b0,1'b0}),
        .DOA(p_0_out[7:6]),
        .DOB(p_0_out[9:8]),
        .DOC(p_0_out[11:10]),
        .DOD(NLW_RAM_reg_0_15_6_11_DOD_UNCONNECTED[1:0]),
        .WCLK(m_aclk),
        .WE(E));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[0] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[0]),
        .Q(D[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[10] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[10]),
        .Q(D[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[11] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[11]),
        .Q(D[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[12] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[12]),
        .Q(D[12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[13] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[13]),
        .Q(D[13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[14] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[14]),
        .Q(D[14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[15] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[15]),
        .Q(D[15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[16] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[16]),
        .Q(D[16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[17] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[17]),
        .Q(D[17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[18] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[18]),
        .Q(D[18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[19] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[19]),
        .Q(D[19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[1] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[1]),
        .Q(D[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[20] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[20]),
        .Q(D[20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[21] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[21]),
        .Q(D[21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[22] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[22]),
        .Q(D[22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[23] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[23]),
        .Q(D[23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[24] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[24]),
        .Q(D[24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[25] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[25]),
        .Q(D[25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[26] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[26]),
        .Q(D[26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[27] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[27]),
        .Q(D[27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[28] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[28]),
        .Q(D[28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[29] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[29]),
        .Q(D[29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[2] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[2]),
        .Q(D[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[30] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[30]),
        .Q(D[30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[31] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[31]),
        .Q(D[31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[32] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[32]),
        .Q(D[32]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[33] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[33]),
        .Q(D[33]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[34] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[34]),
        .Q(D[34]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[35] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[35]),
        .Q(D[35]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[36] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[36]),
        .Q(D[36]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[37] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[37]),
        .Q(D[37]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[38] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[38]),
        .Q(D[38]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[39] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[39]),
        .Q(D[39]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[3] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[3]),
        .Q(D[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[40] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[40]),
        .Q(D[40]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[41] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[41]),
        .Q(D[41]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[42] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[42]),
        .Q(D[42]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[43] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[43]),
        .Q(D[43]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[44] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[44]),
        .Q(D[44]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[45] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[45]),
        .Q(D[45]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[46] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[46]),
        .Q(D[46]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[47] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[47]),
        .Q(D[47]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[48] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[48]),
        .Q(D[48]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[49] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[49]),
        .Q(D[49]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[4] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[4]),
        .Q(D[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[50] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[50]),
        .Q(D[50]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[5] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[5]),
        .Q(D[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[6] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[6]),
        .Q(D[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[7] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[7]),
        .Q(D[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[8] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[8]),
        .Q(D[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[9] 
       (.C(s_aclk),
        .CE(ram_rd_en_i),
        .D(p_0_out[9]),
        .Q(D[9]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "fifo_generator_ramfifo" *) 
module xilinx_axi_clock_converter_fifo_generator_ramfifo
   (s_axi_awready,
    m_axi_awvalid,
    Q,
    s_aclk,
    inverted_reset,
    m_aclk,
    m_axi_awready,
    s_axi_awvalid,
    DI);
  output s_axi_awready;
  output m_axi_awvalid;
  output [76:0]Q;
  input s_aclk;
  input inverted_reset;
  input m_aclk;
  input m_axi_awready;
  input s_axi_awvalid;
  input [76:0]DI;

  wire [76:0]DI;
  wire [76:0]Q;
  wire RD_RST;
  wire RST;
  wire \gntv_or_sync_fifo.gcx.clkx_n_0 ;
  wire \gntv_or_sync_fifo.gcx.clkx_n_5 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_4 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_6 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_7 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_8 ;
  wire inverted_reset;
  wire m_aclk;
  wire m_axi_awready;
  wire m_axi_awvalid;
  wire [3:0]p_0_out;
  wire [3:0]p_1_out;
  wire [3:0]p_20_out;
  wire p_3_out;
  wire [2:0]p_8_out;
  wire [3:0]p_9_out;
  wire ram_rd_en_i;
  wire [2:0]rd_pntr_plus1;
  wire [0:0]rd_rst_i;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire rstblk_n_2;
  wire rstblk_n_6;
  wire s_aclk;
  wire s_axi_awready;
  wire s_axi_awvalid;

  xilinx_axi_clock_converter_clk_x_pntrs_21 \gntv_or_sync_fifo.gcx.clkx 
       (.D({p_20_out[3],\gntv_or_sync_fifo.gl0.rd_n_6 ,\gntv_or_sync_fifo.gl0.rd_n_7 ,\gntv_or_sync_fifo.gl0.rd_n_8 }),
        .Q(p_1_out),
        .\gc0.count_reg[2] (rd_pntr_plus1),
        .\gic0.gc0.count_d1_reg[2] (p_8_out),
        .\gic0.gc0.count_d2_reg[3] (p_9_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (RD_RST),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (rstblk_n_6),
        .ram_empty_fb_i_reg(\gntv_or_sync_fifo.gcx.clkx_n_0 ),
        .ram_full_fb_i_reg(\gntv_or_sync_fifo.gcx.clkx_n_5 ),
        .ram_full_fb_i_reg_0(p_0_out),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_rd_logic_22 \gntv_or_sync_fifo.gl0.rd 
       (.D({p_20_out[3],\gntv_or_sync_fifo.gl0.rd_n_6 ,\gntv_or_sync_fifo.gl0.rd_n_7 ,\gntv_or_sync_fifo.gl0.rd_n_8 }),
        .E(\gntv_or_sync_fifo.gl0.rd_n_4 ),
        .Q({rstblk_n_2,rd_rst_i}),
        .\gc0.count_d1_reg[2] (rd_pntr_plus1),
        .m_aclk(m_aclk),
        .m_axi_awready(m_axi_awready),
        .m_axi_awvalid(m_axi_awvalid),
        .ram_rd_en_i(ram_rd_en_i),
        .\rd_pntr_gc_reg[1] (p_20_out[2:0]),
        .\wr_pntr_bin_reg[2] (\gntv_or_sync_fifo.gcx.clkx_n_0 ),
        .\wr_pntr_bin_reg[3] (p_1_out));
  xilinx_axi_clock_converter_wr_logic_23 \gntv_or_sync_fifo.gl0.wr 
       (.E(p_3_out),
        .Q(p_8_out),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] (RST),
        .\rd_pntr_bin_reg[2] (\gntv_or_sync_fifo.gcx.clkx_n_5 ),
        .\rd_pntr_bin_reg[3] (p_0_out),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .\wr_pntr_gc_reg[3] (p_9_out));
  xilinx_axi_clock_converter_memory \gntv_or_sync_fifo.mem 
       (.ADDRA(p_20_out),
        .DI(DI),
        .E(p_3_out),
        .Q(Q),
        .\gic0.gc0.count_d2_reg[3] (p_9_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] (\gntv_or_sync_fifo.gl0.rd_n_4 ),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_reset_blk_ramfifo_24 rstblk
       (.Q({rstblk_n_2,RD_RST,rd_rst_i}),
        .\gic0.gc0.count_reg[0] ({RST,rstblk_n_6}),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk));
endmodule

(* ORIG_REF_NAME = "fifo_generator_ramfifo" *) 
module xilinx_axi_clock_converter_fifo_generator_ramfifo_51
   (s_axi_arready,
    m_axi_arvalid,
    \m_axi_arid[15] ,
    s_aclk,
    inverted_reset,
    m_aclk,
    m_axi_arready,
    s_axi_arvalid,
    I42);
  output s_axi_arready;
  output m_axi_arvalid;
  output [76:0]\m_axi_arid[15] ;
  input s_aclk;
  input inverted_reset;
  input m_aclk;
  input m_axi_arready;
  input s_axi_arvalid;
  input [76:0]I42;

  wire [76:0]I42;
  wire \gntv_or_sync_fifo.gcx.clkx_n_0 ;
  wire \gntv_or_sync_fifo.gcx.clkx_n_5 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_4 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_6 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_7 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_8 ;
  wire inverted_reset;
  wire m_aclk;
  wire [76:0]\m_axi_arid[15] ;
  wire m_axi_arready;
  wire m_axi_arvalid;
  wire [3:0]p_0_out;
  wire [3:0]p_1_out;
  wire [3:0]p_20_out;
  wire p_3_out;
  wire [2:0]p_8_out;
  wire [3:0]p_9_out;
  wire ram_rd_en_i;
  wire [2:0]rd_pntr_plus1;
  wire [0:0]rd_rst_i;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire rstblk_n_2;
  wire rstblk_n_3;
  wire rstblk_n_5;
  wire rstblk_n_6;
  wire s_aclk;
  wire s_axi_arready;
  wire s_axi_arvalid;

  xilinx_axi_clock_converter_clk_x_pntrs_52 \gntv_or_sync_fifo.gcx.clkx 
       (.D({p_20_out[3],\gntv_or_sync_fifo.gl0.rd_n_6 ,\gntv_or_sync_fifo.gl0.rd_n_7 ,\gntv_or_sync_fifo.gl0.rd_n_8 }),
        .Q(p_1_out),
        .\gc0.count_reg[2] (rd_pntr_plus1),
        .\gic0.gc0.count_d1_reg[2] (p_8_out),
        .\gic0.gc0.count_d2_reg[3] (p_9_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (rstblk_n_3),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (rstblk_n_6),
        .ram_empty_fb_i_reg(\gntv_or_sync_fifo.gcx.clkx_n_0 ),
        .ram_full_fb_i_reg(\gntv_or_sync_fifo.gcx.clkx_n_5 ),
        .ram_full_fb_i_reg_0(p_0_out),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_rd_logic_53 \gntv_or_sync_fifo.gl0.rd 
       (.D({p_20_out[3],\gntv_or_sync_fifo.gl0.rd_n_6 ,\gntv_or_sync_fifo.gl0.rd_n_7 ,\gntv_or_sync_fifo.gl0.rd_n_8 }),
        .E(\gntv_or_sync_fifo.gl0.rd_n_4 ),
        .Q({rstblk_n_2,rd_rst_i}),
        .\gc0.count_d1_reg[2] (rd_pntr_plus1),
        .m_aclk(m_aclk),
        .m_axi_arready(m_axi_arready),
        .m_axi_arvalid(m_axi_arvalid),
        .ram_rd_en_i(ram_rd_en_i),
        .\rd_pntr_gc_reg[1] (p_20_out[2:0]),
        .\wr_pntr_bin_reg[2] (\gntv_or_sync_fifo.gcx.clkx_n_0 ),
        .\wr_pntr_bin_reg[3] (p_1_out));
  xilinx_axi_clock_converter_wr_logic_54 \gntv_or_sync_fifo.gl0.wr 
       (.E(p_3_out),
        .Q(p_8_out),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] (rstblk_n_5),
        .\rd_pntr_bin_reg[2] (\gntv_or_sync_fifo.gcx.clkx_n_5 ),
        .\rd_pntr_bin_reg[3] (p_0_out),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .\wr_pntr_gc_reg[3] (p_9_out));
  xilinx_axi_clock_converter_memory_55 \gntv_or_sync_fifo.mem 
       (.ADDRA(p_20_out),
        .E(p_3_out),
        .I42(I42),
        .\gic0.gc0.count_d2_reg[3] (p_9_out),
        .m_aclk(m_aclk),
        .\m_axi_arid[15] (\m_axi_arid[15] ),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] (\gntv_or_sync_fifo.gl0.rd_n_4 ),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_reset_blk_ramfifo_56 rstblk
       (.Q({rstblk_n_2,rstblk_n_3,rd_rst_i}),
        .\gic0.gc0.count_d2_reg[0] ({rstblk_n_5,rstblk_n_6}),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk));
endmodule

(* ORIG_REF_NAME = "fifo_generator_ramfifo" *) 
module xilinx_axi_clock_converter_fifo_generator_ramfifo__parameterized0
   (s_axi_wready,
    m_axi_wvalid,
    \m_axi_wdata[31] ,
    s_aclk,
    inverted_reset,
    m_aclk,
    m_axi_wready,
    s_axi_wvalid,
    I12);
  output s_axi_wready;
  output m_axi_wvalid;
  output [36:0]\m_axi_wdata[31] ;
  input s_aclk;
  input inverted_reset;
  input m_aclk;
  input m_axi_wready;
  input s_axi_wvalid;
  input [36:0]I12;

  wire [36:0]I12;
  wire \gntv_or_sync_fifo.gcx.clkx_n_0 ;
  wire \gntv_or_sync_fifo.gcx.clkx_n_5 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_4 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_6 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_7 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_8 ;
  wire inverted_reset;
  wire m_aclk;
  wire [36:0]\m_axi_wdata[31] ;
  wire m_axi_wready;
  wire m_axi_wvalid;
  wire [3:0]p_0_out;
  wire [3:0]p_1_out;
  wire [3:0]p_20_out;
  wire p_3_out;
  wire [2:0]p_8_out;
  wire [3:0]p_9_out;
  wire ram_rd_en_i;
  wire [2:0]rd_pntr_plus1;
  wire [0:0]rd_rst_i;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire rstblk_n_2;
  wire rstblk_n_3;
  wire rstblk_n_5;
  wire rstblk_n_6;
  wire s_aclk;
  wire s_axi_wready;
  wire s_axi_wvalid;

  xilinx_axi_clock_converter_clk_x_pntrs_6 \gntv_or_sync_fifo.gcx.clkx 
       (.D({p_20_out[3],\gntv_or_sync_fifo.gl0.rd_n_6 ,\gntv_or_sync_fifo.gl0.rd_n_7 ,\gntv_or_sync_fifo.gl0.rd_n_8 }),
        .Q(p_1_out),
        .\gc0.count_reg[2] (rd_pntr_plus1),
        .\gic0.gc0.count_d1_reg[2] (p_8_out),
        .\gic0.gc0.count_d2_reg[3] (p_9_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (rstblk_n_3),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (rstblk_n_6),
        .ram_empty_fb_i_reg(\gntv_or_sync_fifo.gcx.clkx_n_0 ),
        .ram_full_fb_i_reg(\gntv_or_sync_fifo.gcx.clkx_n_5 ),
        .ram_full_fb_i_reg_0(p_0_out),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_rd_logic_7 \gntv_or_sync_fifo.gl0.rd 
       (.D({p_20_out[3],\gntv_or_sync_fifo.gl0.rd_n_6 ,\gntv_or_sync_fifo.gl0.rd_n_7 ,\gntv_or_sync_fifo.gl0.rd_n_8 }),
        .E(\gntv_or_sync_fifo.gl0.rd_n_4 ),
        .Q({rstblk_n_2,rd_rst_i}),
        .\gc0.count_d1_reg[2] (rd_pntr_plus1),
        .m_aclk(m_aclk),
        .m_axi_wready(m_axi_wready),
        .m_axi_wvalid(m_axi_wvalid),
        .ram_rd_en_i(ram_rd_en_i),
        .\rd_pntr_gc_reg[1] (p_20_out[2:0]),
        .\wr_pntr_bin_reg[2] (\gntv_or_sync_fifo.gcx.clkx_n_0 ),
        .\wr_pntr_bin_reg[3] (p_1_out));
  xilinx_axi_clock_converter_wr_logic_8 \gntv_or_sync_fifo.gl0.wr 
       (.E(p_3_out),
        .Q(p_8_out),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] (rstblk_n_5),
        .\rd_pntr_bin_reg[2] (\gntv_or_sync_fifo.gcx.clkx_n_5 ),
        .\rd_pntr_bin_reg[3] (p_0_out),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk),
        .s_axi_wready(s_axi_wready),
        .s_axi_wvalid(s_axi_wvalid),
        .\wr_pntr_gc_reg[3] (p_9_out));
  xilinx_axi_clock_converter_memory__parameterized0 \gntv_or_sync_fifo.mem 
       (.ADDRA(p_20_out),
        .E(p_3_out),
        .I12(I12),
        .\gic0.gc0.count_d2_reg[3] (p_9_out),
        .m_aclk(m_aclk),
        .\m_axi_wdata[31] (\m_axi_wdata[31] ),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] (\gntv_or_sync_fifo.gl0.rd_n_4 ),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_reset_blk_ramfifo_9 rstblk
       (.Q({rstblk_n_2,rstblk_n_3,rd_rst_i}),
        .\gic0.gc0.count_d2_reg[0] ({rstblk_n_5,rstblk_n_6}),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk));
endmodule

(* ORIG_REF_NAME = "fifo_generator_ramfifo" *) 
module xilinx_axi_clock_converter_fifo_generator_ramfifo__parameterized1
   (s_axi_bvalid,
    m_axi_bready,
    \s_axi_bid[15] ,
    m_aclk,
    inverted_reset,
    s_aclk,
    m_axi_bvalid,
    s_axi_bready,
    I27);
  output s_axi_bvalid;
  output m_axi_bready;
  output [17:0]\s_axi_bid[15] ;
  input m_aclk;
  input inverted_reset;
  input s_aclk;
  input m_axi_bvalid;
  input s_axi_bready;
  input [17:0]I27;

  wire [17:0]I27;
  wire \gntv_or_sync_fifo.gcx.clkx_n_0 ;
  wire \gntv_or_sync_fifo.gcx.clkx_n_5 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_4 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_6 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_7 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_8 ;
  wire inverted_reset;
  wire m_aclk;
  wire m_axi_bready;
  wire m_axi_bvalid;
  wire [3:0]p_0_out;
  wire [3:0]p_1_out;
  wire [3:0]p_20_out;
  wire p_3_out;
  wire [2:0]p_8_out;
  wire [3:0]p_9_out;
  wire ram_rd_en_i;
  wire [2:0]rd_pntr_plus1;
  wire [0:0]rd_rst_i;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire rstblk_n_2;
  wire rstblk_n_3;
  wire rstblk_n_5;
  wire rstblk_n_6;
  wire s_aclk;
  wire [17:0]\s_axi_bid[15] ;
  wire s_axi_bready;
  wire s_axi_bvalid;

  xilinx_axi_clock_converter_clk_x_pntrs \gntv_or_sync_fifo.gcx.clkx 
       (.D({p_20_out[3],\gntv_or_sync_fifo.gl0.rd_n_6 ,\gntv_or_sync_fifo.gl0.rd_n_7 ,\gntv_or_sync_fifo.gl0.rd_n_8 }),
        .Q(p_0_out),
        .\gc0.count_reg[2] (rd_pntr_plus1),
        .\gic0.gc0.count_d1_reg[2] (p_8_out),
        .\gic0.gc0.count_d2_reg[3] (p_9_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (rstblk_n_3),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (rstblk_n_6),
        .ram_empty_fb_i_reg(\gntv_or_sync_fifo.gcx.clkx_n_5 ),
        .ram_empty_fb_i_reg_0(p_1_out),
        .ram_full_fb_i_reg(\gntv_or_sync_fifo.gcx.clkx_n_0 ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_rd_logic \gntv_or_sync_fifo.gl0.rd 
       (.D({p_20_out[3],\gntv_or_sync_fifo.gl0.rd_n_6 ,\gntv_or_sync_fifo.gl0.rd_n_7 ,\gntv_or_sync_fifo.gl0.rd_n_8 }),
        .E(\gntv_or_sync_fifo.gl0.rd_n_4 ),
        .Q({rstblk_n_2,rd_rst_i}),
        .\gc0.count_d1_reg[2] (rd_pntr_plus1),
        .ram_rd_en_i(ram_rd_en_i),
        .\rd_pntr_gc_reg[1] (p_20_out[2:0]),
        .s_aclk(s_aclk),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .\wr_pntr_bin_reg[2] (\gntv_or_sync_fifo.gcx.clkx_n_5 ),
        .\wr_pntr_bin_reg[3] (p_1_out));
  xilinx_axi_clock_converter_wr_logic \gntv_or_sync_fifo.gl0.wr 
       (.E(p_3_out),
        .Q(p_0_out),
        .\gic0.gc0.count_d2_reg[2] (p_8_out),
        .m_aclk(m_aclk),
        .m_axi_bready(m_axi_bready),
        .m_axi_bvalid(m_axi_bvalid),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] (rstblk_n_5),
        .\rd_pntr_bin_reg[2] (\gntv_or_sync_fifo.gcx.clkx_n_0 ),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .\wr_pntr_gc_reg[3] (p_9_out));
  xilinx_axi_clock_converter_memory__parameterized1 \gntv_or_sync_fifo.mem 
       (.ADDRA(p_20_out),
        .E(\gntv_or_sync_fifo.gl0.rd_n_4 ),
        .I26(p_3_out),
        .I27(I27),
        .\gic0.gc0.count_d2_reg[3] (p_9_out),
        .m_aclk(m_aclk),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk),
        .\s_axi_bid[15] (\s_axi_bid[15] ));
  xilinx_axi_clock_converter_reset_blk_ramfifo rstblk
       (.Q({rstblk_n_2,rstblk_n_3,rd_rst_i}),
        .\gic0.gc0.count_d2_reg[0] ({rstblk_n_5,rstblk_n_6}),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk));
endmodule

(* ORIG_REF_NAME = "fifo_generator_ramfifo" *) 
module xilinx_axi_clock_converter_fifo_generator_ramfifo__parameterized2
   (\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg ,
    s_axi_rvalid,
    m_axi_rready,
    \s_axi_rid[15] ,
    m_aclk,
    s_aclk,
    m_axi_rvalid,
    s_axi_rready,
    s_aresetn,
    I57);
  output \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg ;
  output s_axi_rvalid;
  output m_axi_rready;
  output [50:0]\s_axi_rid[15] ;
  input m_aclk;
  input s_aclk;
  input m_axi_rvalid;
  input s_axi_rready;
  input s_aresetn;
  input [50:0]I57;

  wire [50:0]I57;
  wire \gntv_or_sync_fifo.gcx.clkx_n_0 ;
  wire \gntv_or_sync_fifo.gcx.clkx_n_5 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_4 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_6 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_7 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_8 ;
  wire m_aclk;
  wire m_axi_rready;
  wire m_axi_rvalid;
  wire \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg ;
  wire [3:0]p_0_out;
  wire [3:0]p_1_out;
  wire [3:0]p_20_out;
  wire p_3_out;
  wire [2:0]p_8_out;
  wire [3:0]p_9_out;
  wire ram_rd_en_i;
  wire [2:0]rd_pntr_plus1;
  wire [0:0]rd_rst_i;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire rstblk_n_3;
  wire rstblk_n_4;
  wire rstblk_n_6;
  wire rstblk_n_7;
  wire s_aclk;
  wire s_aresetn;
  wire [50:0]\s_axi_rid[15] ;
  wire s_axi_rready;
  wire s_axi_rvalid;

  xilinx_axi_clock_converter_clk_x_pntrs_36 \gntv_or_sync_fifo.gcx.clkx 
       (.D({p_20_out[3],\gntv_or_sync_fifo.gl0.rd_n_6 ,\gntv_or_sync_fifo.gl0.rd_n_7 ,\gntv_or_sync_fifo.gl0.rd_n_8 }),
        .Q(p_0_out),
        .\gc0.count_reg[2] (rd_pntr_plus1),
        .\gic0.gc0.count_d1_reg[2] (p_8_out),
        .\gic0.gc0.count_d2_reg[3] (p_9_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] (rstblk_n_4),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] (rstblk_n_7),
        .ram_empty_fb_i_reg(\gntv_or_sync_fifo.gcx.clkx_n_5 ),
        .ram_empty_fb_i_reg_0(p_1_out),
        .ram_full_fb_i_reg(\gntv_or_sync_fifo.gcx.clkx_n_0 ),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_rd_logic_37 \gntv_or_sync_fifo.gl0.rd 
       (.D({p_20_out[3],\gntv_or_sync_fifo.gl0.rd_n_6 ,\gntv_or_sync_fifo.gl0.rd_n_7 ,\gntv_or_sync_fifo.gl0.rd_n_8 }),
        .E(\gntv_or_sync_fifo.gl0.rd_n_4 ),
        .Q({rstblk_n_3,rd_rst_i}),
        .\gc0.count_d1_reg[2] (rd_pntr_plus1),
        .ram_rd_en_i(ram_rd_en_i),
        .\rd_pntr_gc_reg[1] (p_20_out[2:0]),
        .s_aclk(s_aclk),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid),
        .\wr_pntr_bin_reg[2] (\gntv_or_sync_fifo.gcx.clkx_n_5 ),
        .\wr_pntr_bin_reg[3] (p_1_out));
  xilinx_axi_clock_converter_wr_logic_38 \gntv_or_sync_fifo.gl0.wr 
       (.E(p_3_out),
        .Q(p_0_out),
        .\gic0.gc0.count_d2_reg[2] (p_8_out),
        .m_aclk(m_aclk),
        .m_axi_rready(m_axi_rready),
        .m_axi_rvalid(m_axi_rvalid),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] (rstblk_n_6),
        .\rd_pntr_bin_reg[2] (\gntv_or_sync_fifo.gcx.clkx_n_0 ),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .\wr_pntr_gc_reg[3] (p_9_out));
  xilinx_axi_clock_converter_memory__parameterized2 \gntv_or_sync_fifo.mem 
       (.ADDRA(p_20_out),
        .E(p_3_out),
        .I57(I57),
        .\gic0.gc0.count_d2_reg[3] (p_9_out),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] (\gntv_or_sync_fifo.gl0.rd_n_4 ),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk),
        .\s_axi_rid[15] (\s_axi_rid[15] ));
  xilinx_axi_clock_converter_reset_blk_ramfifo_39 rstblk
       (.Q({rstblk_n_3,rstblk_n_4,rd_rst_i}),
        .\gic0.gc0.count_d2_reg[0] ({rstblk_n_6,rstblk_n_7}),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 (\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg ),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn));
endmodule

(* ORIG_REF_NAME = "fifo_generator_top" *) 
module xilinx_axi_clock_converter_fifo_generator_top
   (s_axi_arready,
    m_axi_arvalid,
    \m_axi_arid[15] ,
    s_aclk,
    inverted_reset,
    m_aclk,
    m_axi_arready,
    s_axi_arvalid,
    I42);
  output s_axi_arready;
  output m_axi_arvalid;
  output [76:0]\m_axi_arid[15] ;
  input s_aclk;
  input inverted_reset;
  input m_aclk;
  input m_axi_arready;
  input s_axi_arvalid;
  input [76:0]I42;

  wire [76:0]I42;
  wire inverted_reset;
  wire m_aclk;
  wire [76:0]\m_axi_arid[15] ;
  wire m_axi_arready;
  wire m_axi_arvalid;
  wire s_aclk;
  wire s_axi_arready;
  wire s_axi_arvalid;

  xilinx_axi_clock_converter_fifo_generator_ramfifo_51 \grf.rf 
       (.I42(I42),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .\m_axi_arid[15] (\m_axi_arid[15] ),
        .m_axi_arready(m_axi_arready),
        .m_axi_arvalid(m_axi_arvalid),
        .s_aclk(s_aclk),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid));
endmodule

(* ORIG_REF_NAME = "fifo_generator_top" *) 
module xilinx_axi_clock_converter_fifo_generator_top_0
   (s_axi_awready,
    m_axi_awvalid,
    Q,
    s_aclk,
    inverted_reset,
    m_aclk,
    m_axi_awready,
    s_axi_awvalid,
    DI);
  output s_axi_awready;
  output m_axi_awvalid;
  output [76:0]Q;
  input s_aclk;
  input inverted_reset;
  input m_aclk;
  input m_axi_awready;
  input s_axi_awvalid;
  input [76:0]DI;

  wire [76:0]DI;
  wire [76:0]Q;
  wire inverted_reset;
  wire m_aclk;
  wire m_axi_awready;
  wire m_axi_awvalid;
  wire s_aclk;
  wire s_axi_awready;
  wire s_axi_awvalid;

  xilinx_axi_clock_converter_fifo_generator_ramfifo \grf.rf 
       (.DI(DI),
        .Q(Q),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .m_axi_awready(m_axi_awready),
        .m_axi_awvalid(m_axi_awvalid),
        .s_aclk(s_aclk),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid));
endmodule

(* ORIG_REF_NAME = "fifo_generator_top" *) 
module xilinx_axi_clock_converter_fifo_generator_top__parameterized0
   (s_axi_wready,
    m_axi_wvalid,
    \m_axi_wdata[31] ,
    s_aclk,
    inverted_reset,
    m_aclk,
    m_axi_wready,
    s_axi_wvalid,
    I12);
  output s_axi_wready;
  output m_axi_wvalid;
  output [36:0]\m_axi_wdata[31] ;
  input s_aclk;
  input inverted_reset;
  input m_aclk;
  input m_axi_wready;
  input s_axi_wvalid;
  input [36:0]I12;

  wire [36:0]I12;
  wire inverted_reset;
  wire m_aclk;
  wire [36:0]\m_axi_wdata[31] ;
  wire m_axi_wready;
  wire m_axi_wvalid;
  wire s_aclk;
  wire s_axi_wready;
  wire s_axi_wvalid;

  xilinx_axi_clock_converter_fifo_generator_ramfifo__parameterized0 \grf.rf 
       (.I12(I12),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .\m_axi_wdata[31] (\m_axi_wdata[31] ),
        .m_axi_wready(m_axi_wready),
        .m_axi_wvalid(m_axi_wvalid),
        .s_aclk(s_aclk),
        .s_axi_wready(s_axi_wready),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "fifo_generator_top" *) 
module xilinx_axi_clock_converter_fifo_generator_top__parameterized1
   (s_axi_bvalid,
    m_axi_bready,
    \s_axi_bid[15] ,
    m_aclk,
    inverted_reset,
    s_aclk,
    m_axi_bvalid,
    s_axi_bready,
    I27);
  output s_axi_bvalid;
  output m_axi_bready;
  output [17:0]\s_axi_bid[15] ;
  input m_aclk;
  input inverted_reset;
  input s_aclk;
  input m_axi_bvalid;
  input s_axi_bready;
  input [17:0]I27;

  wire [17:0]I27;
  wire inverted_reset;
  wire m_aclk;
  wire m_axi_bready;
  wire m_axi_bvalid;
  wire s_aclk;
  wire [17:0]\s_axi_bid[15] ;
  wire s_axi_bready;
  wire s_axi_bvalid;

  xilinx_axi_clock_converter_fifo_generator_ramfifo__parameterized1 \grf.rf 
       (.I27(I27),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .m_axi_bready(m_axi_bready),
        .m_axi_bvalid(m_axi_bvalid),
        .s_aclk(s_aclk),
        .\s_axi_bid[15] (\s_axi_bid[15] ),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid));
endmodule

(* ORIG_REF_NAME = "fifo_generator_top" *) 
module xilinx_axi_clock_converter_fifo_generator_top__parameterized2
   (inverted_reset,
    s_axi_rvalid,
    m_axi_rready,
    \s_axi_rid[15] ,
    m_aclk,
    s_aclk,
    m_axi_rvalid,
    s_axi_rready,
    s_aresetn,
    I57);
  output inverted_reset;
  output s_axi_rvalid;
  output m_axi_rready;
  output [50:0]\s_axi_rid[15] ;
  input m_aclk;
  input s_aclk;
  input m_axi_rvalid;
  input s_axi_rready;
  input s_aresetn;
  input [50:0]I57;

  wire [50:0]I57;
  wire inverted_reset;
  wire m_aclk;
  wire m_axi_rready;
  wire m_axi_rvalid;
  wire s_aclk;
  wire s_aresetn;
  wire [50:0]\s_axi_rid[15] ;
  wire s_axi_rready;
  wire s_axi_rvalid;

  xilinx_axi_clock_converter_fifo_generator_ramfifo__parameterized2 \grf.rf 
       (.I57(I57),
        .m_aclk(m_aclk),
        .m_axi_rready(m_axi_rready),
        .m_axi_rvalid(m_axi_rvalid),
        .\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg (inverted_reset),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .\s_axi_rid[15] (\s_axi_rid[15] ),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid));
endmodule

(* C_ADD_NGC_CONSTRAINT = "0" *) (* C_APPLICATION_TYPE_AXIS = "0" *) (* C_APPLICATION_TYPE_RACH = "0" *) 
(* C_APPLICATION_TYPE_RDCH = "0" *) (* C_APPLICATION_TYPE_WACH = "0" *) (* C_APPLICATION_TYPE_WDCH = "0" *) 
(* C_APPLICATION_TYPE_WRCH = "0" *) (* C_AXIS_TDATA_WIDTH = "8" *) (* C_AXIS_TDEST_WIDTH = "1" *) 
(* C_AXIS_TID_WIDTH = "1" *) (* C_AXIS_TKEEP_WIDTH = "1" *) (* C_AXIS_TSTRB_WIDTH = "1" *) 
(* C_AXIS_TUSER_WIDTH = "4" *) (* C_AXIS_TYPE = "0" *) (* C_AXI_ADDR_WIDTH = "32" *) 
(* C_AXI_ARUSER_WIDTH = "1" *) (* C_AXI_AWUSER_WIDTH = "1" *) (* C_AXI_BUSER_WIDTH = "1" *) 
(* C_AXI_DATA_WIDTH = "32" *) (* C_AXI_ID_WIDTH = "16" *) (* C_AXI_LEN_WIDTH = "8" *) 
(* C_AXI_LOCK_WIDTH = "1" *) (* C_AXI_RUSER_WIDTH = "1" *) (* C_AXI_TYPE = "1" *) 
(* C_AXI_WUSER_WIDTH = "1" *) (* C_COMMON_CLOCK = "0" *) (* C_COUNT_TYPE = "0" *) 
(* C_DATA_COUNT_WIDTH = "10" *) (* C_DEFAULT_VALUE = "BlankString" *) (* C_DIN_WIDTH = "18" *) 
(* C_DIN_WIDTH_AXIS = "1" *) (* C_DIN_WIDTH_RACH = "77" *) (* C_DIN_WIDTH_RDCH = "51" *) 
(* C_DIN_WIDTH_WACH = "77" *) (* C_DIN_WIDTH_WDCH = "37" *) (* C_DIN_WIDTH_WRCH = "18" *) 
(* C_DOUT_RST_VAL = "0" *) (* C_DOUT_WIDTH = "18" *) (* C_ENABLE_RLOCS = "0" *) 
(* C_ENABLE_RST_SYNC = "1" *) (* C_ERROR_INJECTION_TYPE = "0" *) (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
(* C_ERROR_INJECTION_TYPE_RACH = "0" *) (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
(* C_ERROR_INJECTION_TYPE_WDCH = "0" *) (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) (* C_FAMILY = "artix7" *) 
(* C_FULL_FLAGS_RST_VAL = "1" *) (* C_HAS_ALMOST_EMPTY = "0" *) (* C_HAS_ALMOST_FULL = "0" *) 
(* C_HAS_AXIS_TDATA = "1" *) (* C_HAS_AXIS_TDEST = "0" *) (* C_HAS_AXIS_TID = "0" *) 
(* C_HAS_AXIS_TKEEP = "0" *) (* C_HAS_AXIS_TLAST = "0" *) (* C_HAS_AXIS_TREADY = "1" *) 
(* C_HAS_AXIS_TSTRB = "0" *) (* C_HAS_AXIS_TUSER = "1" *) (* C_HAS_AXI_ARUSER = "0" *) 
(* C_HAS_AXI_AWUSER = "0" *) (* C_HAS_AXI_BUSER = "0" *) (* C_HAS_AXI_ID = "1" *) 
(* C_HAS_AXI_RD_CHANNEL = "1" *) (* C_HAS_AXI_RUSER = "0" *) (* C_HAS_AXI_WR_CHANNEL = "1" *) 
(* C_HAS_AXI_WUSER = "0" *) (* C_HAS_BACKUP = "0" *) (* C_HAS_DATA_COUNT = "0" *) 
(* C_HAS_DATA_COUNTS_AXIS = "0" *) (* C_HAS_DATA_COUNTS_RACH = "0" *) (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
(* C_HAS_DATA_COUNTS_WACH = "0" *) (* C_HAS_DATA_COUNTS_WDCH = "0" *) (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
(* C_HAS_INT_CLK = "0" *) (* C_HAS_MASTER_CE = "0" *) (* C_HAS_MEMINIT_FILE = "0" *) 
(* C_HAS_OVERFLOW = "0" *) (* C_HAS_PROG_FLAGS_AXIS = "0" *) (* C_HAS_PROG_FLAGS_RACH = "0" *) 
(* C_HAS_PROG_FLAGS_RDCH = "0" *) (* C_HAS_PROG_FLAGS_WACH = "0" *) (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
(* C_HAS_PROG_FLAGS_WRCH = "0" *) (* C_HAS_RD_DATA_COUNT = "0" *) (* C_HAS_RD_RST = "0" *) 
(* C_HAS_RST = "1" *) (* C_HAS_SLAVE_CE = "0" *) (* C_HAS_SRST = "0" *) 
(* C_HAS_UNDERFLOW = "0" *) (* C_HAS_VALID = "0" *) (* C_HAS_WR_ACK = "0" *) 
(* C_HAS_WR_DATA_COUNT = "0" *) (* C_HAS_WR_RST = "0" *) (* C_IMPLEMENTATION_TYPE = "0" *) 
(* C_IMPLEMENTATION_TYPE_AXIS = "11" *) (* C_IMPLEMENTATION_TYPE_RACH = "12" *) (* C_IMPLEMENTATION_TYPE_RDCH = "12" *) 
(* C_IMPLEMENTATION_TYPE_WACH = "12" *) (* C_IMPLEMENTATION_TYPE_WDCH = "12" *) (* C_IMPLEMENTATION_TYPE_WRCH = "12" *) 
(* C_INIT_WR_PNTR_VAL = "0" *) (* C_INTERFACE_TYPE = "2" *) (* C_MEMORY_TYPE = "1" *) 
(* C_MIF_FILE_NAME = "BlankString" *) (* C_MSGON_VAL = "1" *) (* C_OPTIMIZATION_MODE = "0" *) 
(* C_OVERFLOW_LOW = "0" *) (* C_POWER_SAVING_MODE = "0" *) (* C_PRELOAD_LATENCY = "1" *) 
(* C_PRELOAD_REGS = "0" *) (* C_PRIM_FIFO_TYPE = "4kx4" *) (* C_PRIM_FIFO_TYPE_AXIS = "512x36" *) 
(* C_PRIM_FIFO_TYPE_RACH = "512x36" *) (* C_PRIM_FIFO_TYPE_RDCH = "512x36" *) (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
(* C_PRIM_FIFO_TYPE_WDCH = "512x36" *) (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1021" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "13" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "13" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "13" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "13" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "13" *) 
(* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) (* C_PROG_EMPTY_TYPE = "0" *) (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
(* C_PROG_EMPTY_TYPE_RACH = "0" *) (* C_PROG_EMPTY_TYPE_RDCH = "0" *) (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
(* C_PROG_EMPTY_TYPE_WDCH = "0" *) (* C_PROG_EMPTY_TYPE_WRCH = "0" *) (* C_PROG_FULL_THRESH_ASSERT_VAL = "1022" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "15" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "15" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "15" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "15" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "15" *) 
(* C_PROG_FULL_THRESH_NEGATE_VAL = "1021" *) (* C_PROG_FULL_TYPE = "0" *) (* C_PROG_FULL_TYPE_AXIS = "0" *) 
(* C_PROG_FULL_TYPE_RACH = "0" *) (* C_PROG_FULL_TYPE_RDCH = "0" *) (* C_PROG_FULL_TYPE_WACH = "0" *) 
(* C_PROG_FULL_TYPE_WDCH = "0" *) (* C_PROG_FULL_TYPE_WRCH = "0" *) (* C_RACH_TYPE = "0" *) 
(* C_RDCH_TYPE = "0" *) (* C_RD_DATA_COUNT_WIDTH = "10" *) (* C_RD_DEPTH = "1024" *) 
(* C_RD_FREQ = "1" *) (* C_RD_PNTR_WIDTH = "10" *) (* C_REG_SLICE_MODE_AXIS = "0" *) 
(* C_REG_SLICE_MODE_RACH = "0" *) (* C_REG_SLICE_MODE_RDCH = "0" *) (* C_REG_SLICE_MODE_WACH = "0" *) 
(* C_REG_SLICE_MODE_WDCH = "0" *) (* C_REG_SLICE_MODE_WRCH = "0" *) (* C_SYNCHRONIZER_STAGE = "3" *) 
(* C_UNDERFLOW_LOW = "0" *) (* C_USE_COMMON_OVERFLOW = "0" *) (* C_USE_COMMON_UNDERFLOW = "0" *) 
(* C_USE_DEFAULT_SETTINGS = "0" *) (* C_USE_DOUT_RST = "1" *) (* C_USE_ECC = "0" *) 
(* C_USE_ECC_AXIS = "0" *) (* C_USE_ECC_RACH = "0" *) (* C_USE_ECC_RDCH = "0" *) 
(* C_USE_ECC_WACH = "0" *) (* C_USE_ECC_WDCH = "0" *) (* C_USE_ECC_WRCH = "0" *) 
(* C_USE_EMBEDDED_REG = "0" *) (* C_USE_FIFO16_FLAGS = "0" *) (* C_USE_FWFT_DATA_COUNT = "0" *) 
(* C_USE_PIPELINE_REG = "0" *) (* C_VALID_LOW = "0" *) (* C_WACH_TYPE = "0" *) 
(* C_WDCH_TYPE = "0" *) (* C_WRCH_TYPE = "0" *) (* C_WR_ACK_LOW = "0" *) 
(* C_WR_DATA_COUNT_WIDTH = "10" *) (* C_WR_DEPTH = "1024" *) (* C_WR_DEPTH_AXIS = "1024" *) 
(* C_WR_DEPTH_RACH = "16" *) (* C_WR_DEPTH_RDCH = "16" *) (* C_WR_DEPTH_WACH = "16" *) 
(* C_WR_DEPTH_WDCH = "16" *) (* C_WR_DEPTH_WRCH = "16" *) (* C_WR_FREQ = "1" *) 
(* C_WR_PNTR_WIDTH = "10" *) (* C_WR_PNTR_WIDTH_AXIS = "10" *) (* C_WR_PNTR_WIDTH_RACH = "4" *) 
(* C_WR_PNTR_WIDTH_RDCH = "4" *) (* C_WR_PNTR_WIDTH_WACH = "4" *) (* C_WR_PNTR_WIDTH_WDCH = "4" *) 
(* C_WR_PNTR_WIDTH_WRCH = "4" *) (* C_WR_RESPONSE_LATENCY = "1" *) (* ORIG_REF_NAME = "fifo_generator_v12_0" *) 
module xilinx_axi_clock_converter_fifo_generator_v12_0
   (backup,
    backup_marker,
    clk,
    rst,
    srst,
    wr_clk,
    wr_rst,
    rd_clk,
    rd_rst,
    din,
    wr_en,
    rd_en,
    prog_empty_thresh,
    prog_empty_thresh_assert,
    prog_empty_thresh_negate,
    prog_full_thresh,
    prog_full_thresh_assert,
    prog_full_thresh_negate,
    int_clk,
    injectdbiterr,
    injectsbiterr,
    sleep,
    dout,
    full,
    almost_full,
    wr_ack,
    overflow,
    empty,
    almost_empty,
    valid,
    underflow,
    data_count,
    rd_data_count,
    wr_data_count,
    prog_full,
    prog_empty,
    sbiterr,
    dbiterr,
    wr_rst_busy,
    rd_rst_busy,
    m_aclk,
    s_aclk,
    s_aresetn,
    m_aclk_en,
    s_aclk_en,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awqos,
    s_axi_awregion,
    s_axi_awuser,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wid,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wuser,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_buser,
    s_axi_bvalid,
    s_axi_bready,
    m_axi_awid,
    m_axi_awaddr,
    m_axi_awlen,
    m_axi_awsize,
    m_axi_awburst,
    m_axi_awlock,
    m_axi_awcache,
    m_axi_awprot,
    m_axi_awqos,
    m_axi_awregion,
    m_axi_awuser,
    m_axi_awvalid,
    m_axi_awready,
    m_axi_wid,
    m_axi_wdata,
    m_axi_wstrb,
    m_axi_wlast,
    m_axi_wuser,
    m_axi_wvalid,
    m_axi_wready,
    m_axi_bid,
    m_axi_bresp,
    m_axi_buser,
    m_axi_bvalid,
    m_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arqos,
    s_axi_arregion,
    s_axi_aruser,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_ruser,
    s_axi_rvalid,
    s_axi_rready,
    m_axi_arid,
    m_axi_araddr,
    m_axi_arlen,
    m_axi_arsize,
    m_axi_arburst,
    m_axi_arlock,
    m_axi_arcache,
    m_axi_arprot,
    m_axi_arqos,
    m_axi_arregion,
    m_axi_aruser,
    m_axi_arvalid,
    m_axi_arready,
    m_axi_rid,
    m_axi_rdata,
    m_axi_rresp,
    m_axi_rlast,
    m_axi_ruser,
    m_axi_rvalid,
    m_axi_rready,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tkeep,
    s_axis_tlast,
    s_axis_tid,
    s_axis_tdest,
    s_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tkeep,
    m_axis_tlast,
    m_axis_tid,
    m_axis_tdest,
    m_axis_tuser,
    axi_aw_injectsbiterr,
    axi_aw_injectdbiterr,
    axi_aw_prog_full_thresh,
    axi_aw_prog_empty_thresh,
    axi_aw_data_count,
    axi_aw_wr_data_count,
    axi_aw_rd_data_count,
    axi_aw_sbiterr,
    axi_aw_dbiterr,
    axi_aw_overflow,
    axi_aw_underflow,
    axi_aw_prog_full,
    axi_aw_prog_empty,
    axi_w_injectsbiterr,
    axi_w_injectdbiterr,
    axi_w_prog_full_thresh,
    axi_w_prog_empty_thresh,
    axi_w_data_count,
    axi_w_wr_data_count,
    axi_w_rd_data_count,
    axi_w_sbiterr,
    axi_w_dbiterr,
    axi_w_overflow,
    axi_w_underflow,
    axi_w_prog_full,
    axi_w_prog_empty,
    axi_b_injectsbiterr,
    axi_b_injectdbiterr,
    axi_b_prog_full_thresh,
    axi_b_prog_empty_thresh,
    axi_b_data_count,
    axi_b_wr_data_count,
    axi_b_rd_data_count,
    axi_b_sbiterr,
    axi_b_dbiterr,
    axi_b_overflow,
    axi_b_underflow,
    axi_b_prog_full,
    axi_b_prog_empty,
    axi_ar_injectsbiterr,
    axi_ar_injectdbiterr,
    axi_ar_prog_full_thresh,
    axi_ar_prog_empty_thresh,
    axi_ar_data_count,
    axi_ar_wr_data_count,
    axi_ar_rd_data_count,
    axi_ar_sbiterr,
    axi_ar_dbiterr,
    axi_ar_overflow,
    axi_ar_underflow,
    axi_ar_prog_full,
    axi_ar_prog_empty,
    axi_r_injectsbiterr,
    axi_r_injectdbiterr,
    axi_r_prog_full_thresh,
    axi_r_prog_empty_thresh,
    axi_r_data_count,
    axi_r_wr_data_count,
    axi_r_rd_data_count,
    axi_r_sbiterr,
    axi_r_dbiterr,
    axi_r_overflow,
    axi_r_underflow,
    axi_r_prog_full,
    axi_r_prog_empty,
    axis_injectsbiterr,
    axis_injectdbiterr,
    axis_prog_full_thresh,
    axis_prog_empty_thresh,
    axis_data_count,
    axis_wr_data_count,
    axis_rd_data_count,
    axis_sbiterr,
    axis_dbiterr,
    axis_overflow,
    axis_underflow,
    axis_prog_full,
    axis_prog_empty);
  input backup;
  input backup_marker;
  input clk;
  input rst;
  input srst;
  input wr_clk;
  input wr_rst;
  input rd_clk;
  input rd_rst;
  input [17:0]din;
  input wr_en;
  input rd_en;
  input [9:0]prog_empty_thresh;
  input [9:0]prog_empty_thresh_assert;
  input [9:0]prog_empty_thresh_negate;
  input [9:0]prog_full_thresh;
  input [9:0]prog_full_thresh_assert;
  input [9:0]prog_full_thresh_negate;
  input int_clk;
  input injectdbiterr;
  input injectsbiterr;
  input sleep;
  output [17:0]dout;
  output full;
  output almost_full;
  output wr_ack;
  output overflow;
  output empty;
  output almost_empty;
  output valid;
  output underflow;
  output [9:0]data_count;
  output [9:0]rd_data_count;
  output [9:0]wr_data_count;
  output prog_full;
  output prog_empty;
  output sbiterr;
  output dbiterr;
  output wr_rst_busy;
  output rd_rst_busy;
  input m_aclk;
  input s_aclk;
  input s_aresetn;
  input m_aclk_en;
  input s_aclk_en;
  input [15:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input [0:0]s_axi_awlock;
  input [3:0]s_axi_awcache;
  input [2:0]s_axi_awprot;
  input [3:0]s_axi_awqos;
  input [3:0]s_axi_awregion;
  input [0:0]s_axi_awuser;
  input s_axi_awvalid;
  output s_axi_awready;
  input [15:0]s_axi_wid;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input s_axi_wlast;
  input [0:0]s_axi_wuser;
  input s_axi_wvalid;
  output s_axi_wready;
  output [15:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output [0:0]s_axi_buser;
  output s_axi_bvalid;
  input s_axi_bready;
  output [15:0]m_axi_awid;
  output [31:0]m_axi_awaddr;
  output [7:0]m_axi_awlen;
  output [2:0]m_axi_awsize;
  output [1:0]m_axi_awburst;
  output [0:0]m_axi_awlock;
  output [3:0]m_axi_awcache;
  output [2:0]m_axi_awprot;
  output [3:0]m_axi_awqos;
  output [3:0]m_axi_awregion;
  output [0:0]m_axi_awuser;
  output m_axi_awvalid;
  input m_axi_awready;
  output [15:0]m_axi_wid;
  output [31:0]m_axi_wdata;
  output [3:0]m_axi_wstrb;
  output m_axi_wlast;
  output [0:0]m_axi_wuser;
  output m_axi_wvalid;
  input m_axi_wready;
  input [15:0]m_axi_bid;
  input [1:0]m_axi_bresp;
  input [0:0]m_axi_buser;
  input m_axi_bvalid;
  output m_axi_bready;
  input [15:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input [0:0]s_axi_arlock;
  input [3:0]s_axi_arcache;
  input [2:0]s_axi_arprot;
  input [3:0]s_axi_arqos;
  input [3:0]s_axi_arregion;
  input [0:0]s_axi_aruser;
  input s_axi_arvalid;
  output s_axi_arready;
  output [15:0]s_axi_rid;
  output [31:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output [0:0]s_axi_ruser;
  output s_axi_rvalid;
  input s_axi_rready;
  output [15:0]m_axi_arid;
  output [31:0]m_axi_araddr;
  output [7:0]m_axi_arlen;
  output [2:0]m_axi_arsize;
  output [1:0]m_axi_arburst;
  output [0:0]m_axi_arlock;
  output [3:0]m_axi_arcache;
  output [2:0]m_axi_arprot;
  output [3:0]m_axi_arqos;
  output [3:0]m_axi_arregion;
  output [0:0]m_axi_aruser;
  output m_axi_arvalid;
  input m_axi_arready;
  input [15:0]m_axi_rid;
  input [31:0]m_axi_rdata;
  input [1:0]m_axi_rresp;
  input m_axi_rlast;
  input [0:0]m_axi_ruser;
  input m_axi_rvalid;
  output m_axi_rready;
  input s_axis_tvalid;
  output s_axis_tready;
  input [7:0]s_axis_tdata;
  input [0:0]s_axis_tstrb;
  input [0:0]s_axis_tkeep;
  input s_axis_tlast;
  input [0:0]s_axis_tid;
  input [0:0]s_axis_tdest;
  input [3:0]s_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output [7:0]m_axis_tdata;
  output [0:0]m_axis_tstrb;
  output [0:0]m_axis_tkeep;
  output m_axis_tlast;
  output [0:0]m_axis_tid;
  output [0:0]m_axis_tdest;
  output [3:0]m_axis_tuser;
  input axi_aw_injectsbiterr;
  input axi_aw_injectdbiterr;
  input [3:0]axi_aw_prog_full_thresh;
  input [3:0]axi_aw_prog_empty_thresh;
  output [4:0]axi_aw_data_count;
  output [4:0]axi_aw_wr_data_count;
  output [4:0]axi_aw_rd_data_count;
  output axi_aw_sbiterr;
  output axi_aw_dbiterr;
  output axi_aw_overflow;
  output axi_aw_underflow;
  output axi_aw_prog_full;
  output axi_aw_prog_empty;
  input axi_w_injectsbiterr;
  input axi_w_injectdbiterr;
  input [3:0]axi_w_prog_full_thresh;
  input [3:0]axi_w_prog_empty_thresh;
  output [4:0]axi_w_data_count;
  output [4:0]axi_w_wr_data_count;
  output [4:0]axi_w_rd_data_count;
  output axi_w_sbiterr;
  output axi_w_dbiterr;
  output axi_w_overflow;
  output axi_w_underflow;
  output axi_w_prog_full;
  output axi_w_prog_empty;
  input axi_b_injectsbiterr;
  input axi_b_injectdbiterr;
  input [3:0]axi_b_prog_full_thresh;
  input [3:0]axi_b_prog_empty_thresh;
  output [4:0]axi_b_data_count;
  output [4:0]axi_b_wr_data_count;
  output [4:0]axi_b_rd_data_count;
  output axi_b_sbiterr;
  output axi_b_dbiterr;
  output axi_b_overflow;
  output axi_b_underflow;
  output axi_b_prog_full;
  output axi_b_prog_empty;
  input axi_ar_injectsbiterr;
  input axi_ar_injectdbiterr;
  input [3:0]axi_ar_prog_full_thresh;
  input [3:0]axi_ar_prog_empty_thresh;
  output [4:0]axi_ar_data_count;
  output [4:0]axi_ar_wr_data_count;
  output [4:0]axi_ar_rd_data_count;
  output axi_ar_sbiterr;
  output axi_ar_dbiterr;
  output axi_ar_overflow;
  output axi_ar_underflow;
  output axi_ar_prog_full;
  output axi_ar_prog_empty;
  input axi_r_injectsbiterr;
  input axi_r_injectdbiterr;
  input [3:0]axi_r_prog_full_thresh;
  input [3:0]axi_r_prog_empty_thresh;
  output [4:0]axi_r_data_count;
  output [4:0]axi_r_wr_data_count;
  output [4:0]axi_r_rd_data_count;
  output axi_r_sbiterr;
  output axi_r_dbiterr;
  output axi_r_overflow;
  output axi_r_underflow;
  output axi_r_prog_full;
  output axi_r_prog_empty;
  input axis_injectsbiterr;
  input axis_injectdbiterr;
  input [9:0]axis_prog_full_thresh;
  input [9:0]axis_prog_empty_thresh;
  output [10:0]axis_data_count;
  output [10:0]axis_wr_data_count;
  output [10:0]axis_rd_data_count;
  output axis_sbiterr;
  output axis_dbiterr;
  output axis_overflow;
  output axis_underflow;
  output axis_prog_full;
  output axis_prog_empty;

  wire \<const0> ;
  wire \<const1> ;
  wire axi_ar_injectdbiterr;
  wire axi_ar_injectsbiterr;
  wire [3:0]axi_ar_prog_empty_thresh;
  wire [3:0]axi_ar_prog_full_thresh;
  wire axi_aw_injectdbiterr;
  wire axi_aw_injectsbiterr;
  wire [3:0]axi_aw_prog_empty_thresh;
  wire [3:0]axi_aw_prog_full_thresh;
  wire axi_b_injectdbiterr;
  wire axi_b_injectsbiterr;
  wire [3:0]axi_b_prog_empty_thresh;
  wire [3:0]axi_b_prog_full_thresh;
  wire axi_r_injectdbiterr;
  wire axi_r_injectsbiterr;
  wire [3:0]axi_r_prog_empty_thresh;
  wire [3:0]axi_r_prog_full_thresh;
  wire axi_w_injectdbiterr;
  wire axi_w_injectsbiterr;
  wire [3:0]axi_w_prog_empty_thresh;
  wire [3:0]axi_w_prog_full_thresh;
  wire axis_injectdbiterr;
  wire axis_injectsbiterr;
  wire [9:0]axis_prog_empty_thresh;
  wire [9:0]axis_prog_full_thresh;
  wire backup;
  wire backup_marker;
  wire clk;
  wire [17:0]din;
  wire injectdbiterr;
  wire injectsbiterr;
  wire int_clk;
  wire m_aclk;
  wire m_aclk_en;
  wire [31:0]m_axi_araddr;
  wire [1:0]m_axi_arburst;
  wire [3:0]m_axi_arcache;
  wire [15:0]m_axi_arid;
  wire [7:0]m_axi_arlen;
  wire [0:0]m_axi_arlock;
  wire [2:0]m_axi_arprot;
  wire [3:0]m_axi_arqos;
  wire m_axi_arready;
  wire [3:0]m_axi_arregion;
  wire [2:0]m_axi_arsize;
  wire m_axi_arvalid;
  wire [31:0]m_axi_awaddr;
  wire [1:0]m_axi_awburst;
  wire [3:0]m_axi_awcache;
  wire [15:0]m_axi_awid;
  wire [7:0]m_axi_awlen;
  wire [0:0]m_axi_awlock;
  wire [2:0]m_axi_awprot;
  wire [3:0]m_axi_awqos;
  wire m_axi_awready;
  wire [3:0]m_axi_awregion;
  wire [2:0]m_axi_awsize;
  wire m_axi_awvalid;
  wire [15:0]m_axi_bid;
  wire m_axi_bready;
  wire [1:0]m_axi_bresp;
  wire [0:0]m_axi_buser;
  wire m_axi_bvalid;
  wire [31:0]m_axi_rdata;
  wire [15:0]m_axi_rid;
  wire m_axi_rlast;
  wire m_axi_rready;
  wire [1:0]m_axi_rresp;
  wire [0:0]m_axi_ruser;
  wire m_axi_rvalid;
  wire [31:0]m_axi_wdata;
  wire m_axi_wlast;
  wire m_axi_wready;
  wire [3:0]m_axi_wstrb;
  wire m_axi_wvalid;
  wire m_axis_tready;
  wire [9:0]prog_empty_thresh;
  wire [9:0]prog_empty_thresh_assert;
  wire [9:0]prog_empty_thresh_negate;
  wire [9:0]prog_full_thresh;
  wire [9:0]prog_full_thresh_assert;
  wire [9:0]prog_full_thresh_negate;
  wire rd_clk;
  wire rd_en;
  wire rd_rst;
  wire rst;
  wire s_aclk;
  wire s_aclk_en;
  wire s_aresetn;
  wire [31:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire [3:0]s_axi_arcache;
  wire [15:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire [0:0]s_axi_arlock;
  wire [2:0]s_axi_arprot;
  wire [3:0]s_axi_arqos;
  wire s_axi_arready;
  wire [3:0]s_axi_arregion;
  wire [2:0]s_axi_arsize;
  wire [0:0]s_axi_aruser;
  wire s_axi_arvalid;
  wire [31:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awcache;
  wire [15:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire [0:0]s_axi_awlock;
  wire [2:0]s_axi_awprot;
  wire [3:0]s_axi_awqos;
  wire s_axi_awready;
  wire [3:0]s_axi_awregion;
  wire [2:0]s_axi_awsize;
  wire [0:0]s_axi_awuser;
  wire s_axi_awvalid;
  wire [15:0]s_axi_bid;
  wire s_axi_bready;
  wire [1:0]s_axi_bresp;
  wire s_axi_bvalid;
  wire [31:0]s_axi_rdata;
  wire [15:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire [1:0]s_axi_rresp;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire [15:0]s_axi_wid;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire [0:0]s_axi_wuser;
  wire s_axi_wvalid;
  wire [7:0]s_axis_tdata;
  wire [0:0]s_axis_tdest;
  wire [0:0]s_axis_tid;
  wire [0:0]s_axis_tkeep;
  wire s_axis_tlast;
  wire [0:0]s_axis_tstrb;
  wire [3:0]s_axis_tuser;
  wire s_axis_tvalid;
  wire srst;
  wire wr_clk;
  wire wr_en;
  wire wr_rst;

  assign almost_empty = \<const1> ;
  assign almost_full = \<const0> ;
  assign axi_ar_data_count[4] = \<const0> ;
  assign axi_ar_data_count[3] = \<const0> ;
  assign axi_ar_data_count[2] = \<const0> ;
  assign axi_ar_data_count[1] = \<const0> ;
  assign axi_ar_data_count[0] = \<const0> ;
  assign axi_ar_dbiterr = \<const0> ;
  assign axi_ar_overflow = \<const0> ;
  assign axi_ar_prog_empty = \<const0> ;
  assign axi_ar_prog_full = \<const0> ;
  assign axi_ar_rd_data_count[4] = \<const0> ;
  assign axi_ar_rd_data_count[3] = \<const0> ;
  assign axi_ar_rd_data_count[2] = \<const0> ;
  assign axi_ar_rd_data_count[1] = \<const0> ;
  assign axi_ar_rd_data_count[0] = \<const0> ;
  assign axi_ar_sbiterr = \<const0> ;
  assign axi_ar_underflow = \<const0> ;
  assign axi_ar_wr_data_count[4] = \<const0> ;
  assign axi_ar_wr_data_count[3] = \<const0> ;
  assign axi_ar_wr_data_count[2] = \<const0> ;
  assign axi_ar_wr_data_count[1] = \<const0> ;
  assign axi_ar_wr_data_count[0] = \<const0> ;
  assign axi_aw_data_count[4] = \<const0> ;
  assign axi_aw_data_count[3] = \<const0> ;
  assign axi_aw_data_count[2] = \<const0> ;
  assign axi_aw_data_count[1] = \<const0> ;
  assign axi_aw_data_count[0] = \<const0> ;
  assign axi_aw_dbiterr = \<const0> ;
  assign axi_aw_overflow = \<const0> ;
  assign axi_aw_prog_empty = \<const0> ;
  assign axi_aw_prog_full = \<const0> ;
  assign axi_aw_rd_data_count[4] = \<const0> ;
  assign axi_aw_rd_data_count[3] = \<const0> ;
  assign axi_aw_rd_data_count[2] = \<const0> ;
  assign axi_aw_rd_data_count[1] = \<const0> ;
  assign axi_aw_rd_data_count[0] = \<const0> ;
  assign axi_aw_sbiterr = \<const0> ;
  assign axi_aw_underflow = \<const0> ;
  assign axi_aw_wr_data_count[4] = \<const0> ;
  assign axi_aw_wr_data_count[3] = \<const0> ;
  assign axi_aw_wr_data_count[2] = \<const0> ;
  assign axi_aw_wr_data_count[1] = \<const0> ;
  assign axi_aw_wr_data_count[0] = \<const0> ;
  assign axi_b_data_count[4] = \<const0> ;
  assign axi_b_data_count[3] = \<const0> ;
  assign axi_b_data_count[2] = \<const0> ;
  assign axi_b_data_count[1] = \<const0> ;
  assign axi_b_data_count[0] = \<const0> ;
  assign axi_b_dbiterr = \<const0> ;
  assign axi_b_overflow = \<const0> ;
  assign axi_b_prog_empty = \<const0> ;
  assign axi_b_prog_full = \<const0> ;
  assign axi_b_rd_data_count[4] = \<const0> ;
  assign axi_b_rd_data_count[3] = \<const0> ;
  assign axi_b_rd_data_count[2] = \<const0> ;
  assign axi_b_rd_data_count[1] = \<const0> ;
  assign axi_b_rd_data_count[0] = \<const0> ;
  assign axi_b_sbiterr = \<const0> ;
  assign axi_b_underflow = \<const0> ;
  assign axi_b_wr_data_count[4] = \<const0> ;
  assign axi_b_wr_data_count[3] = \<const0> ;
  assign axi_b_wr_data_count[2] = \<const0> ;
  assign axi_b_wr_data_count[1] = \<const0> ;
  assign axi_b_wr_data_count[0] = \<const0> ;
  assign axi_r_data_count[4] = \<const0> ;
  assign axi_r_data_count[3] = \<const0> ;
  assign axi_r_data_count[2] = \<const0> ;
  assign axi_r_data_count[1] = \<const0> ;
  assign axi_r_data_count[0] = \<const0> ;
  assign axi_r_dbiterr = \<const0> ;
  assign axi_r_overflow = \<const0> ;
  assign axi_r_prog_empty = \<const0> ;
  assign axi_r_prog_full = \<const0> ;
  assign axi_r_rd_data_count[4] = \<const0> ;
  assign axi_r_rd_data_count[3] = \<const0> ;
  assign axi_r_rd_data_count[2] = \<const0> ;
  assign axi_r_rd_data_count[1] = \<const0> ;
  assign axi_r_rd_data_count[0] = \<const0> ;
  assign axi_r_sbiterr = \<const0> ;
  assign axi_r_underflow = \<const0> ;
  assign axi_r_wr_data_count[4] = \<const0> ;
  assign axi_r_wr_data_count[3] = \<const0> ;
  assign axi_r_wr_data_count[2] = \<const0> ;
  assign axi_r_wr_data_count[1] = \<const0> ;
  assign axi_r_wr_data_count[0] = \<const0> ;
  assign axi_w_data_count[4] = \<const0> ;
  assign axi_w_data_count[3] = \<const0> ;
  assign axi_w_data_count[2] = \<const0> ;
  assign axi_w_data_count[1] = \<const0> ;
  assign axi_w_data_count[0] = \<const0> ;
  assign axi_w_dbiterr = \<const0> ;
  assign axi_w_overflow = \<const0> ;
  assign axi_w_prog_empty = \<const0> ;
  assign axi_w_prog_full = \<const0> ;
  assign axi_w_rd_data_count[4] = \<const0> ;
  assign axi_w_rd_data_count[3] = \<const0> ;
  assign axi_w_rd_data_count[2] = \<const0> ;
  assign axi_w_rd_data_count[1] = \<const0> ;
  assign axi_w_rd_data_count[0] = \<const0> ;
  assign axi_w_sbiterr = \<const0> ;
  assign axi_w_underflow = \<const0> ;
  assign axi_w_wr_data_count[4] = \<const0> ;
  assign axi_w_wr_data_count[3] = \<const0> ;
  assign axi_w_wr_data_count[2] = \<const0> ;
  assign axi_w_wr_data_count[1] = \<const0> ;
  assign axi_w_wr_data_count[0] = \<const0> ;
  assign axis_data_count[10] = \<const0> ;
  assign axis_data_count[9] = \<const0> ;
  assign axis_data_count[8] = \<const0> ;
  assign axis_data_count[7] = \<const0> ;
  assign axis_data_count[6] = \<const0> ;
  assign axis_data_count[5] = \<const0> ;
  assign axis_data_count[4] = \<const0> ;
  assign axis_data_count[3] = \<const0> ;
  assign axis_data_count[2] = \<const0> ;
  assign axis_data_count[1] = \<const0> ;
  assign axis_data_count[0] = \<const0> ;
  assign axis_dbiterr = \<const0> ;
  assign axis_overflow = \<const0> ;
  assign axis_prog_empty = \<const1> ;
  assign axis_prog_full = \<const0> ;
  assign axis_rd_data_count[10] = \<const0> ;
  assign axis_rd_data_count[9] = \<const0> ;
  assign axis_rd_data_count[8] = \<const0> ;
  assign axis_rd_data_count[7] = \<const0> ;
  assign axis_rd_data_count[6] = \<const0> ;
  assign axis_rd_data_count[5] = \<const0> ;
  assign axis_rd_data_count[4] = \<const0> ;
  assign axis_rd_data_count[3] = \<const0> ;
  assign axis_rd_data_count[2] = \<const0> ;
  assign axis_rd_data_count[1] = \<const0> ;
  assign axis_rd_data_count[0] = \<const0> ;
  assign axis_sbiterr = \<const0> ;
  assign axis_underflow = \<const0> ;
  assign axis_wr_data_count[10] = \<const0> ;
  assign axis_wr_data_count[9] = \<const0> ;
  assign axis_wr_data_count[8] = \<const0> ;
  assign axis_wr_data_count[7] = \<const0> ;
  assign axis_wr_data_count[6] = \<const0> ;
  assign axis_wr_data_count[5] = \<const0> ;
  assign axis_wr_data_count[4] = \<const0> ;
  assign axis_wr_data_count[3] = \<const0> ;
  assign axis_wr_data_count[2] = \<const0> ;
  assign axis_wr_data_count[1] = \<const0> ;
  assign axis_wr_data_count[0] = \<const0> ;
  assign data_count[9] = \<const0> ;
  assign data_count[8] = \<const0> ;
  assign data_count[7] = \<const0> ;
  assign data_count[6] = \<const0> ;
  assign data_count[5] = \<const0> ;
  assign data_count[4] = \<const0> ;
  assign data_count[3] = \<const0> ;
  assign data_count[2] = \<const0> ;
  assign data_count[1] = \<const0> ;
  assign data_count[0] = \<const0> ;
  assign dbiterr = \<const0> ;
  assign dout[17] = \<const0> ;
  assign dout[16] = \<const0> ;
  assign dout[15] = \<const0> ;
  assign dout[14] = \<const0> ;
  assign dout[13] = \<const0> ;
  assign dout[12] = \<const0> ;
  assign dout[11] = \<const0> ;
  assign dout[10] = \<const0> ;
  assign dout[9] = \<const0> ;
  assign dout[8] = \<const0> ;
  assign dout[7] = \<const0> ;
  assign dout[6] = \<const0> ;
  assign dout[5] = \<const0> ;
  assign dout[4] = \<const0> ;
  assign dout[3] = \<const0> ;
  assign dout[2] = \<const0> ;
  assign dout[1] = \<const0> ;
  assign dout[0] = \<const0> ;
  assign empty = \<const1> ;
  assign full = \<const0> ;
  assign m_axi_aruser[0] = \<const0> ;
  assign m_axi_awuser[0] = \<const0> ;
  assign m_axi_wid[15] = \<const0> ;
  assign m_axi_wid[14] = \<const0> ;
  assign m_axi_wid[13] = \<const0> ;
  assign m_axi_wid[12] = \<const0> ;
  assign m_axi_wid[11] = \<const0> ;
  assign m_axi_wid[10] = \<const0> ;
  assign m_axi_wid[9] = \<const0> ;
  assign m_axi_wid[8] = \<const0> ;
  assign m_axi_wid[7] = \<const0> ;
  assign m_axi_wid[6] = \<const0> ;
  assign m_axi_wid[5] = \<const0> ;
  assign m_axi_wid[4] = \<const0> ;
  assign m_axi_wid[3] = \<const0> ;
  assign m_axi_wid[2] = \<const0> ;
  assign m_axi_wid[1] = \<const0> ;
  assign m_axi_wid[0] = \<const0> ;
  assign m_axi_wuser[0] = \<const0> ;
  assign m_axis_tdata[7] = \<const0> ;
  assign m_axis_tdata[6] = \<const0> ;
  assign m_axis_tdata[5] = \<const0> ;
  assign m_axis_tdata[4] = \<const0> ;
  assign m_axis_tdata[3] = \<const0> ;
  assign m_axis_tdata[2] = \<const0> ;
  assign m_axis_tdata[1] = \<const0> ;
  assign m_axis_tdata[0] = \<const0> ;
  assign m_axis_tdest[0] = \<const0> ;
  assign m_axis_tid[0] = \<const0> ;
  assign m_axis_tkeep[0] = \<const0> ;
  assign m_axis_tlast = \<const0> ;
  assign m_axis_tstrb[0] = \<const0> ;
  assign m_axis_tuser[3] = \<const0> ;
  assign m_axis_tuser[2] = \<const0> ;
  assign m_axis_tuser[1] = \<const0> ;
  assign m_axis_tuser[0] = \<const0> ;
  assign m_axis_tvalid = \<const0> ;
  assign overflow = \<const0> ;
  assign prog_empty = \<const1> ;
  assign prog_full = \<const0> ;
  assign rd_data_count[9] = \<const0> ;
  assign rd_data_count[8] = \<const0> ;
  assign rd_data_count[7] = \<const0> ;
  assign rd_data_count[6] = \<const0> ;
  assign rd_data_count[5] = \<const0> ;
  assign rd_data_count[4] = \<const0> ;
  assign rd_data_count[3] = \<const0> ;
  assign rd_data_count[2] = \<const0> ;
  assign rd_data_count[1] = \<const0> ;
  assign rd_data_count[0] = \<const0> ;
  assign rd_rst_busy = \<const0> ;
  assign s_axi_buser[0] = \<const0> ;
  assign s_axi_ruser[0] = \<const0> ;
  assign s_axis_tready = \<const0> ;
  assign sbiterr = \<const0> ;
  assign underflow = \<const0> ;
  assign valid = \<const0> ;
  assign wr_ack = \<const0> ;
  assign wr_data_count[9] = \<const0> ;
  assign wr_data_count[8] = \<const0> ;
  assign wr_data_count[7] = \<const0> ;
  assign wr_data_count[6] = \<const0> ;
  assign wr_data_count[5] = \<const0> ;
  assign wr_data_count[4] = \<const0> ;
  assign wr_data_count[3] = \<const0> ;
  assign wr_data_count[2] = \<const0> ;
  assign wr_data_count[1] = \<const0> ;
  assign wr_data_count[0] = \<const0> ;
  assign wr_rst_busy = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  xilinx_axi_clock_converter_fifo_generator_v12_0_synth inst_fifo_gen
       (.DI({s_axi_awid,s_axi_awaddr,s_axi_awlen,s_axi_awsize,s_axi_awburst,s_axi_awlock,s_axi_awcache,s_axi_awprot,s_axi_awqos,s_axi_awregion}),
        .I12({s_axi_wdata,s_axi_wstrb,s_axi_wlast}),
        .I27({m_axi_bid,m_axi_bresp}),
        .I42({s_axi_arid,s_axi_araddr,s_axi_arlen,s_axi_arsize,s_axi_arburst,s_axi_arlock,s_axi_arcache,s_axi_arprot,s_axi_arqos,s_axi_arregion}),
        .I57({m_axi_rid,m_axi_rdata,m_axi_rresp,m_axi_rlast}),
        .Q({m_axi_awid,m_axi_awaddr,m_axi_awlen,m_axi_awsize,m_axi_awburst,m_axi_awlock,m_axi_awcache,m_axi_awprot,m_axi_awqos,m_axi_awregion}),
        .m_aclk(m_aclk),
        .\m_axi_arid[15] ({m_axi_arid,m_axi_araddr,m_axi_arlen,m_axi_arsize,m_axi_arburst,m_axi_arlock,m_axi_arcache,m_axi_arprot,m_axi_arqos,m_axi_arregion}),
        .m_axi_arready(m_axi_arready),
        .m_axi_arvalid(m_axi_arvalid),
        .m_axi_awready(m_axi_awready),
        .m_axi_awvalid(m_axi_awvalid),
        .m_axi_bready(m_axi_bready),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_rready(m_axi_rready),
        .m_axi_rvalid(m_axi_rvalid),
        .\m_axi_wdata[31] ({m_axi_wdata,m_axi_wstrb,m_axi_wlast}),
        .m_axi_wready(m_axi_wready),
        .m_axi_wvalid(m_axi_wvalid),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .\s_axi_bid[15] ({s_axi_bid,s_axi_bresp}),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .\s_axi_rid[15] ({s_axi_rid,s_axi_rdata,s_axi_rresp,s_axi_rlast}),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "fifo_generator_v12_0_synth" *) 
module xilinx_axi_clock_converter_fifo_generator_v12_0_synth
   (Q,
    \m_axi_wdata[31] ,
    \s_axi_bid[15] ,
    \m_axi_arid[15] ,
    \s_axi_rid[15] ,
    s_axi_awready,
    s_axi_wready,
    s_axi_bvalid,
    m_axi_awvalid,
    m_axi_wvalid,
    m_axi_bready,
    s_axi_arready,
    s_axi_rvalid,
    m_axi_arvalid,
    m_axi_rready,
    m_axi_awready,
    m_axi_wready,
    m_axi_bvalid,
    m_axi_arready,
    m_axi_rvalid,
    s_axi_awvalid,
    s_axi_wvalid,
    s_axi_bready,
    s_axi_arvalid,
    s_axi_rready,
    m_aclk,
    s_aclk,
    DI,
    I12,
    I27,
    I42,
    I57,
    s_aresetn);
  output [76:0]Q;
  output [36:0]\m_axi_wdata[31] ;
  output [17:0]\s_axi_bid[15] ;
  output [76:0]\m_axi_arid[15] ;
  output [50:0]\s_axi_rid[15] ;
  output s_axi_awready;
  output s_axi_wready;
  output s_axi_bvalid;
  output m_axi_awvalid;
  output m_axi_wvalid;
  output m_axi_bready;
  output s_axi_arready;
  output s_axi_rvalid;
  output m_axi_arvalid;
  output m_axi_rready;
  input m_axi_awready;
  input m_axi_wready;
  input m_axi_bvalid;
  input m_axi_arready;
  input m_axi_rvalid;
  input s_axi_awvalid;
  input s_axi_wvalid;
  input s_axi_bready;
  input s_axi_arvalid;
  input s_axi_rready;
  input m_aclk;
  input s_aclk;
  input [76:0]DI;
  input [36:0]I12;
  input [17:0]I27;
  input [76:0]I42;
  input [50:0]I57;
  input s_aresetn;

  wire [76:0]DI;
  wire [36:0]I12;
  wire [17:0]I27;
  wire [76:0]I42;
  wire [50:0]I57;
  wire [76:0]Q;
  wire inverted_reset;
  wire m_aclk;
  wire [76:0]\m_axi_arid[15] ;
  wire m_axi_arready;
  wire m_axi_arvalid;
  wire m_axi_awready;
  wire m_axi_awvalid;
  wire m_axi_bready;
  wire m_axi_bvalid;
  wire m_axi_rready;
  wire m_axi_rvalid;
  wire [36:0]\m_axi_wdata[31] ;
  wire m_axi_wready;
  wire m_axi_wvalid;
  wire s_aclk;
  wire s_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire [17:0]\s_axi_bid[15] ;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [50:0]\s_axi_rid[15] ;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire s_axi_wready;
  wire s_axi_wvalid;

  xilinx_axi_clock_converter_fifo_generator_top \gaxi_full_lite.gread_ch.grach2.axi_rach 
       (.I42(I42),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .\m_axi_arid[15] (\m_axi_arid[15] ),
        .m_axi_arready(m_axi_arready),
        .m_axi_arvalid(m_axi_arvalid),
        .s_aclk(s_aclk),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid));
  xilinx_axi_clock_converter_fifo_generator_top__parameterized2 \gaxi_full_lite.gread_ch.grdch2.axi_rdch 
       (.I57(I57),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .m_axi_rready(m_axi_rready),
        .m_axi_rvalid(m_axi_rvalid),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .\s_axi_rid[15] (\s_axi_rid[15] ),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid));
  xilinx_axi_clock_converter_fifo_generator_top_0 \gaxi_full_lite.gwrite_ch.gwach2.axi_wach 
       (.DI(DI),
        .Q(Q),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .m_axi_awready(m_axi_awready),
        .m_axi_awvalid(m_axi_awvalid),
        .s_aclk(s_aclk),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid));
  xilinx_axi_clock_converter_fifo_generator_top__parameterized0 \gaxi_full_lite.gwrite_ch.gwdch2.axi_wdch 
       (.I12(I12),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .\m_axi_wdata[31] (\m_axi_wdata[31] ),
        .m_axi_wready(m_axi_wready),
        .m_axi_wvalid(m_axi_wvalid),
        .s_aclk(s_aclk),
        .s_axi_wready(s_axi_wready),
        .s_axi_wvalid(s_axi_wvalid));
  xilinx_axi_clock_converter_fifo_generator_top__parameterized1 \gaxi_full_lite.gwrite_ch.gwrch2.axi_wrch 
       (.I27(I27),
        .inverted_reset(inverted_reset),
        .m_aclk(m_aclk),
        .m_axi_bready(m_axi_bready),
        .m_axi_bvalid(m_axi_bvalid),
        .s_aclk(s_aclk),
        .\s_axi_bid[15] (\s_axi_bid[15] ),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid));
endmodule

(* ORIG_REF_NAME = "memory" *) 
module xilinx_axi_clock_converter_memory
   (Q,
    ram_rd_en_i,
    m_aclk,
    s_aclk,
    E,
    DI,
    ADDRA,
    \gic0.gc0.count_d2_reg[3] ,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] );
  output [76:0]Q;
  input ram_rd_en_i;
  input m_aclk;
  input s_aclk;
  input [0:0]E;
  input [76:0]DI;
  input [3:0]ADDRA;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ;

  wire [3:0]ADDRA;
  wire [76:0]DI;
  wire [0:0]E;
  wire [76:0]Q;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ;
  wire [76:0]p_0_out;
  wire ram_rd_en_i;
  wire s_aclk;

  xilinx_axi_clock_converter_dmem \gdm.dm 
       (.ADDRA(ADDRA),
        .D(p_0_out),
        .DI(DI),
        .E(E),
        .\gic0.gc0.count_d2_reg[3] (\gic0.gc0.count_d2_reg[3] ),
        .m_aclk(m_aclk),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[0] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[0]),
        .Q(Q[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[10] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[10]),
        .Q(Q[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[11] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[11]),
        .Q(Q[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[12] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[12]),
        .Q(Q[12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[13] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[13]),
        .Q(Q[13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[14] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[14]),
        .Q(Q[14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[15] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[15]),
        .Q(Q[15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[16] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[16]),
        .Q(Q[16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[17] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[17]),
        .Q(Q[17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[18] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[18]),
        .Q(Q[18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[19] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[19]),
        .Q(Q[19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[1] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[1]),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[20] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[20]),
        .Q(Q[20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[21] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[21]),
        .Q(Q[21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[22] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[22]),
        .Q(Q[22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[23] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[23]),
        .Q(Q[23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[24] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[24]),
        .Q(Q[24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[25] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[25]),
        .Q(Q[25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[26] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[26]),
        .Q(Q[26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[27] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[27]),
        .Q(Q[27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[28] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[28]),
        .Q(Q[28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[29] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[29]),
        .Q(Q[29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[2] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[2]),
        .Q(Q[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[30] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[30]),
        .Q(Q[30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[31] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[31]),
        .Q(Q[31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[32] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[32]),
        .Q(Q[32]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[33] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[33]),
        .Q(Q[33]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[34] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[34]),
        .Q(Q[34]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[35] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[35]),
        .Q(Q[35]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[36] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[36]),
        .Q(Q[36]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[37] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[37]),
        .Q(Q[37]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[38] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[38]),
        .Q(Q[38]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[39] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[39]),
        .Q(Q[39]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[3] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[3]),
        .Q(Q[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[40] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[40]),
        .Q(Q[40]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[41] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[41]),
        .Q(Q[41]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[42] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[42]),
        .Q(Q[42]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[43] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[43]),
        .Q(Q[43]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[44] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[44]),
        .Q(Q[44]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[45] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[45]),
        .Q(Q[45]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[46] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[46]),
        .Q(Q[46]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[47] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[47]),
        .Q(Q[47]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[48] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[48]),
        .Q(Q[48]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[49] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[49]),
        .Q(Q[49]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[4] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[4]),
        .Q(Q[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[50] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[50]),
        .Q(Q[50]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[51] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[51]),
        .Q(Q[51]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[52] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[52]),
        .Q(Q[52]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[53] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[53]),
        .Q(Q[53]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[54] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[54]),
        .Q(Q[54]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[55] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[55]),
        .Q(Q[55]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[56] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[56]),
        .Q(Q[56]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[57] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[57]),
        .Q(Q[57]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[58] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[58]),
        .Q(Q[58]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[59] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[59]),
        .Q(Q[59]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[5] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[5]),
        .Q(Q[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[60] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[60]),
        .Q(Q[60]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[61] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[61]),
        .Q(Q[61]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[62] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[62]),
        .Q(Q[62]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[63] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[63]),
        .Q(Q[63]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[64] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[64]),
        .Q(Q[64]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[65] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[65]),
        .Q(Q[65]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[66] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[66]),
        .Q(Q[66]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[67] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[67]),
        .Q(Q[67]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[68] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[68]),
        .Q(Q[68]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[69] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[69]),
        .Q(Q[69]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[6] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[6]),
        .Q(Q[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[70] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[70]),
        .Q(Q[70]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[71] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[71]),
        .Q(Q[71]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[72] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[72]),
        .Q(Q[72]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[73] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[73]),
        .Q(Q[73]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[74] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[74]),
        .Q(Q[74]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[75] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[75]),
        .Q(Q[75]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[76] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[76]),
        .Q(Q[76]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[7] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[7]),
        .Q(Q[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[8] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[8]),
        .Q(Q[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[9] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[9]),
        .Q(Q[9]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "memory" *) 
module xilinx_axi_clock_converter_memory_55
   (\m_axi_arid[15] ,
    ram_rd_en_i,
    m_aclk,
    s_aclk,
    E,
    I42,
    ADDRA,
    \gic0.gc0.count_d2_reg[3] ,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] );
  output [76:0]\m_axi_arid[15] ;
  input ram_rd_en_i;
  input m_aclk;
  input s_aclk;
  input [0:0]E;
  input [76:0]I42;
  input [3:0]ADDRA;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ;

  wire [3:0]ADDRA;
  wire [0:0]E;
  wire [76:0]I42;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire m_aclk;
  wire [76:0]\m_axi_arid[15] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ;
  wire [76:0]p_0_out;
  wire ram_rd_en_i;
  wire s_aclk;

  xilinx_axi_clock_converter_dmem_57 \gdm.dm 
       (.ADDRA(ADDRA),
        .D(p_0_out),
        .E(E),
        .I42(I42),
        .\gic0.gc0.count_d2_reg[3] (\gic0.gc0.count_d2_reg[3] ),
        .m_aclk(m_aclk),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[0] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[0]),
        .Q(\m_axi_arid[15] [0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[10] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[10]),
        .Q(\m_axi_arid[15] [10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[11] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[11]),
        .Q(\m_axi_arid[15] [11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[12] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[12]),
        .Q(\m_axi_arid[15] [12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[13] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[13]),
        .Q(\m_axi_arid[15] [13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[14] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[14]),
        .Q(\m_axi_arid[15] [14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[15] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[15]),
        .Q(\m_axi_arid[15] [15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[16] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[16]),
        .Q(\m_axi_arid[15] [16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[17] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[17]),
        .Q(\m_axi_arid[15] [17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[18] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[18]),
        .Q(\m_axi_arid[15] [18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[19] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[19]),
        .Q(\m_axi_arid[15] [19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[1] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[1]),
        .Q(\m_axi_arid[15] [1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[20] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[20]),
        .Q(\m_axi_arid[15] [20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[21] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[21]),
        .Q(\m_axi_arid[15] [21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[22] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[22]),
        .Q(\m_axi_arid[15] [22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[23] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[23]),
        .Q(\m_axi_arid[15] [23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[24] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[24]),
        .Q(\m_axi_arid[15] [24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[25] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[25]),
        .Q(\m_axi_arid[15] [25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[26] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[26]),
        .Q(\m_axi_arid[15] [26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[27] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[27]),
        .Q(\m_axi_arid[15] [27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[28] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[28]),
        .Q(\m_axi_arid[15] [28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[29] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[29]),
        .Q(\m_axi_arid[15] [29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[2] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[2]),
        .Q(\m_axi_arid[15] [2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[30] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[30]),
        .Q(\m_axi_arid[15] [30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[31] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[31]),
        .Q(\m_axi_arid[15] [31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[32] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[32]),
        .Q(\m_axi_arid[15] [32]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[33] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[33]),
        .Q(\m_axi_arid[15] [33]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[34] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[34]),
        .Q(\m_axi_arid[15] [34]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[35] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[35]),
        .Q(\m_axi_arid[15] [35]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[36] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[36]),
        .Q(\m_axi_arid[15] [36]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[37] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[37]),
        .Q(\m_axi_arid[15] [37]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[38] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[38]),
        .Q(\m_axi_arid[15] [38]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[39] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[39]),
        .Q(\m_axi_arid[15] [39]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[3] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[3]),
        .Q(\m_axi_arid[15] [3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[40] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[40]),
        .Q(\m_axi_arid[15] [40]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[41] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[41]),
        .Q(\m_axi_arid[15] [41]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[42] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[42]),
        .Q(\m_axi_arid[15] [42]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[43] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[43]),
        .Q(\m_axi_arid[15] [43]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[44] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[44]),
        .Q(\m_axi_arid[15] [44]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[45] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[45]),
        .Q(\m_axi_arid[15] [45]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[46] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[46]),
        .Q(\m_axi_arid[15] [46]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[47] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[47]),
        .Q(\m_axi_arid[15] [47]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[48] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[48]),
        .Q(\m_axi_arid[15] [48]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[49] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[49]),
        .Q(\m_axi_arid[15] [49]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[4] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[4]),
        .Q(\m_axi_arid[15] [4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[50] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[50]),
        .Q(\m_axi_arid[15] [50]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[51] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[51]),
        .Q(\m_axi_arid[15] [51]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[52] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[52]),
        .Q(\m_axi_arid[15] [52]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[53] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[53]),
        .Q(\m_axi_arid[15] [53]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[54] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[54]),
        .Q(\m_axi_arid[15] [54]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[55] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[55]),
        .Q(\m_axi_arid[15] [55]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[56] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[56]),
        .Q(\m_axi_arid[15] [56]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[57] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[57]),
        .Q(\m_axi_arid[15] [57]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[58] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[58]),
        .Q(\m_axi_arid[15] [58]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[59] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[59]),
        .Q(\m_axi_arid[15] [59]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[5] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[5]),
        .Q(\m_axi_arid[15] [5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[60] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[60]),
        .Q(\m_axi_arid[15] [60]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[61] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[61]),
        .Q(\m_axi_arid[15] [61]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[62] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[62]),
        .Q(\m_axi_arid[15] [62]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[63] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[63]),
        .Q(\m_axi_arid[15] [63]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[64] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[64]),
        .Q(\m_axi_arid[15] [64]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[65] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[65]),
        .Q(\m_axi_arid[15] [65]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[66] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[66]),
        .Q(\m_axi_arid[15] [66]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[67] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[67]),
        .Q(\m_axi_arid[15] [67]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[68] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[68]),
        .Q(\m_axi_arid[15] [68]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[69] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[69]),
        .Q(\m_axi_arid[15] [69]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[6] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[6]),
        .Q(\m_axi_arid[15] [6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[70] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[70]),
        .Q(\m_axi_arid[15] [70]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[71] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[71]),
        .Q(\m_axi_arid[15] [71]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[72] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[72]),
        .Q(\m_axi_arid[15] [72]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[73] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[73]),
        .Q(\m_axi_arid[15] [73]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[74] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[74]),
        .Q(\m_axi_arid[15] [74]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[75] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[75]),
        .Q(\m_axi_arid[15] [75]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[76] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[76]),
        .Q(\m_axi_arid[15] [76]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[7] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[7]),
        .Q(\m_axi_arid[15] [7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[8] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[8]),
        .Q(\m_axi_arid[15] [8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[9] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[9]),
        .Q(\m_axi_arid[15] [9]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "memory" *) 
module xilinx_axi_clock_converter_memory__parameterized0
   (\m_axi_wdata[31] ,
    ram_rd_en_i,
    m_aclk,
    s_aclk,
    E,
    I12,
    ADDRA,
    \gic0.gc0.count_d2_reg[3] ,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] );
  output [36:0]\m_axi_wdata[31] ;
  input ram_rd_en_i;
  input m_aclk;
  input s_aclk;
  input [0:0]E;
  input [36:0]I12;
  input [3:0]ADDRA;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ;

  wire [3:0]ADDRA;
  wire [0:0]E;
  wire [36:0]I12;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire m_aclk;
  wire [36:0]\m_axi_wdata[31] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ;
  wire [36:0]p_0_out;
  wire ram_rd_en_i;
  wire s_aclk;

  xilinx_axi_clock_converter_dmem__parameterized0 \gdm.dm 
       (.ADDRA(ADDRA),
        .D(p_0_out),
        .E(E),
        .I12(I12),
        .\gic0.gc0.count_d2_reg[3] (\gic0.gc0.count_d2_reg[3] ),
        .m_aclk(m_aclk),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[0] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[0]),
        .Q(\m_axi_wdata[31] [0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[10] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[10]),
        .Q(\m_axi_wdata[31] [10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[11] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[11]),
        .Q(\m_axi_wdata[31] [11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[12] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[12]),
        .Q(\m_axi_wdata[31] [12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[13] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[13]),
        .Q(\m_axi_wdata[31] [13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[14] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[14]),
        .Q(\m_axi_wdata[31] [14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[15] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[15]),
        .Q(\m_axi_wdata[31] [15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[16] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[16]),
        .Q(\m_axi_wdata[31] [16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[17] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[17]),
        .Q(\m_axi_wdata[31] [17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[18] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[18]),
        .Q(\m_axi_wdata[31] [18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[19] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[19]),
        .Q(\m_axi_wdata[31] [19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[1] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[1]),
        .Q(\m_axi_wdata[31] [1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[20] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[20]),
        .Q(\m_axi_wdata[31] [20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[21] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[21]),
        .Q(\m_axi_wdata[31] [21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[22] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[22]),
        .Q(\m_axi_wdata[31] [22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[23] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[23]),
        .Q(\m_axi_wdata[31] [23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[24] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[24]),
        .Q(\m_axi_wdata[31] [24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[25] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[25]),
        .Q(\m_axi_wdata[31] [25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[26] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[26]),
        .Q(\m_axi_wdata[31] [26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[27] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[27]),
        .Q(\m_axi_wdata[31] [27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[28] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[28]),
        .Q(\m_axi_wdata[31] [28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[29] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[29]),
        .Q(\m_axi_wdata[31] [29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[2] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[2]),
        .Q(\m_axi_wdata[31] [2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[30] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[30]),
        .Q(\m_axi_wdata[31] [30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[31] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[31]),
        .Q(\m_axi_wdata[31] [31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[32] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[32]),
        .Q(\m_axi_wdata[31] [32]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[33] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[33]),
        .Q(\m_axi_wdata[31] [33]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[34] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[34]),
        .Q(\m_axi_wdata[31] [34]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[35] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[35]),
        .Q(\m_axi_wdata[31] [35]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[36] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[36]),
        .Q(\m_axi_wdata[31] [36]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[3] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[3]),
        .Q(\m_axi_wdata[31] [3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[4] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[4]),
        .Q(\m_axi_wdata[31] [4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[5] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[5]),
        .Q(\m_axi_wdata[31] [5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[6] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[6]),
        .Q(\m_axi_wdata[31] [6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[7] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[7]),
        .Q(\m_axi_wdata[31] [7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[8] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[8]),
        .Q(\m_axi_wdata[31] [8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[9] 
       (.C(m_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[9]),
        .Q(\m_axi_wdata[31] [9]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "memory" *) 
module xilinx_axi_clock_converter_memory__parameterized1
   (\s_axi_bid[15] ,
    ram_rd_en_i,
    s_aclk,
    m_aclk,
    I26,
    I27,
    ADDRA,
    \gic0.gc0.count_d2_reg[3] ,
    E);
  output [17:0]\s_axi_bid[15] ;
  input ram_rd_en_i;
  input s_aclk;
  input m_aclk;
  input I26;
  input [17:0]I27;
  input [3:0]ADDRA;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;
  input [0:0]E;

  wire [3:0]ADDRA;
  wire [0:0]E;
  wire I26;
  wire [17:0]I27;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire m_aclk;
  wire [17:0]p_0_out;
  wire ram_rd_en_i;
  wire s_aclk;
  wire [17:0]\s_axi_bid[15] ;

  xilinx_axi_clock_converter_dmem__parameterized1 \gdm.dm 
       (.ADDRA(ADDRA),
        .D(p_0_out),
        .I26(I26),
        .I27(I27),
        .\gic0.gc0.count_d2_reg[3] (\gic0.gc0.count_d2_reg[3] ),
        .m_aclk(m_aclk),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[0]),
        .Q(\s_axi_bid[15] [0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[10] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[10]),
        .Q(\s_axi_bid[15] [10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[11] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[11]),
        .Q(\s_axi_bid[15] [11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[12] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[12]),
        .Q(\s_axi_bid[15] [12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[13] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[13]),
        .Q(\s_axi_bid[15] [13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[14] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[14]),
        .Q(\s_axi_bid[15] [14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[15] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[15]),
        .Q(\s_axi_bid[15] [15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[16] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[16]),
        .Q(\s_axi_bid[15] [16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[17] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[17]),
        .Q(\s_axi_bid[15] [17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[1]),
        .Q(\s_axi_bid[15] [1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[2]),
        .Q(\s_axi_bid[15] [2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[3]),
        .Q(\s_axi_bid[15] [3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[4] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[4]),
        .Q(\s_axi_bid[15] [4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[5] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[5]),
        .Q(\s_axi_bid[15] [5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[6] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[6]),
        .Q(\s_axi_bid[15] [6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[7] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[7]),
        .Q(\s_axi_bid[15] [7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[8] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[8]),
        .Q(\s_axi_bid[15] [8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[9] 
       (.C(s_aclk),
        .CE(E),
        .D(p_0_out[9]),
        .Q(\s_axi_bid[15] [9]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "memory" *) 
module xilinx_axi_clock_converter_memory__parameterized2
   (\s_axi_rid[15] ,
    ram_rd_en_i,
    s_aclk,
    m_aclk,
    E,
    I57,
    ADDRA,
    \gic0.gc0.count_d2_reg[3] ,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] );
  output [50:0]\s_axi_rid[15] ;
  input ram_rd_en_i;
  input s_aclk;
  input m_aclk;
  input [0:0]E;
  input [50:0]I57;
  input [3:0]ADDRA;
  input [3:0]\gic0.gc0.count_d2_reg[3] ;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ;

  wire [3:0]ADDRA;
  wire [0:0]E;
  wire [50:0]I57;
  wire [3:0]\gic0.gc0.count_d2_reg[3] ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ;
  wire [50:0]p_0_out;
  wire ram_rd_en_i;
  wire s_aclk;
  wire [50:0]\s_axi_rid[15] ;

  xilinx_axi_clock_converter_dmem__parameterized2 \gdm.dm 
       (.ADDRA(ADDRA),
        .D(p_0_out),
        .E(E),
        .I57(I57),
        .\gic0.gc0.count_d2_reg[3] (\gic0.gc0.count_d2_reg[3] ),
        .m_aclk(m_aclk),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[0] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[0]),
        .Q(\s_axi_rid[15] [0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[10] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[10]),
        .Q(\s_axi_rid[15] [10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[11] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[11]),
        .Q(\s_axi_rid[15] [11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[12] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[12]),
        .Q(\s_axi_rid[15] [12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[13] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[13]),
        .Q(\s_axi_rid[15] [13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[14] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[14]),
        .Q(\s_axi_rid[15] [14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[15] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[15]),
        .Q(\s_axi_rid[15] [15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[16] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[16]),
        .Q(\s_axi_rid[15] [16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[17] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[17]),
        .Q(\s_axi_rid[15] [17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[18] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[18]),
        .Q(\s_axi_rid[15] [18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[19] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[19]),
        .Q(\s_axi_rid[15] [19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[1] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[1]),
        .Q(\s_axi_rid[15] [1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[20] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[20]),
        .Q(\s_axi_rid[15] [20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[21] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[21]),
        .Q(\s_axi_rid[15] [21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[22] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[22]),
        .Q(\s_axi_rid[15] [22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[23] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[23]),
        .Q(\s_axi_rid[15] [23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[24] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[24]),
        .Q(\s_axi_rid[15] [24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[25] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[25]),
        .Q(\s_axi_rid[15] [25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[26] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[26]),
        .Q(\s_axi_rid[15] [26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[27] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[27]),
        .Q(\s_axi_rid[15] [27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[28] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[28]),
        .Q(\s_axi_rid[15] [28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[29] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[29]),
        .Q(\s_axi_rid[15] [29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[2] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[2]),
        .Q(\s_axi_rid[15] [2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[30] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[30]),
        .Q(\s_axi_rid[15] [30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[31] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[31]),
        .Q(\s_axi_rid[15] [31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[32] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[32]),
        .Q(\s_axi_rid[15] [32]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[33] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[33]),
        .Q(\s_axi_rid[15] [33]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[34] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[34]),
        .Q(\s_axi_rid[15] [34]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[35] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[35]),
        .Q(\s_axi_rid[15] [35]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[36] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[36]),
        .Q(\s_axi_rid[15] [36]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[37] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[37]),
        .Q(\s_axi_rid[15] [37]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[38] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[38]),
        .Q(\s_axi_rid[15] [38]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[39] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[39]),
        .Q(\s_axi_rid[15] [39]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[3] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[3]),
        .Q(\s_axi_rid[15] [3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[40] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[40]),
        .Q(\s_axi_rid[15] [40]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[41] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[41]),
        .Q(\s_axi_rid[15] [41]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[42] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[42]),
        .Q(\s_axi_rid[15] [42]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[43] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[43]),
        .Q(\s_axi_rid[15] [43]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[44] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[44]),
        .Q(\s_axi_rid[15] [44]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[45] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[45]),
        .Q(\s_axi_rid[15] [45]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[46] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[46]),
        .Q(\s_axi_rid[15] [46]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[47] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[47]),
        .Q(\s_axi_rid[15] [47]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[48] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[48]),
        .Q(\s_axi_rid[15] [48]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[49] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[49]),
        .Q(\s_axi_rid[15] [49]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[4] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[4]),
        .Q(\s_axi_rid[15] [4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[50] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[50]),
        .Q(\s_axi_rid[15] [50]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[5] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[5]),
        .Q(\s_axi_rid[15] [5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[6] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[6]),
        .Q(\s_axi_rid[15] [6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[7] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[7]),
        .Q(\s_axi_rid[15] [7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[8] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[8]),
        .Q(\s_axi_rid[15] [8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[9] 
       (.C(s_aclk),
        .CE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(p_0_out[9]),
        .Q(\s_axi_rid[15] [9]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "rd_bin_cntr" *) 
module xilinx_axi_clock_converter_rd_bin_cntr
   (Q,
    ram_empty_fb_i_reg,
    D,
    \rd_pntr_gc_reg[1] ,
    \wr_pntr_bin_reg[2] ,
    \gpregsm1.curr_fwft_state_reg[1] ,
    \wr_pntr_bin_reg[3] ,
    E,
    s_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] );
  output [3:0]Q;
  output ram_empty_fb_i_reg;
  output [3:0]D;
  output [2:0]\rd_pntr_gc_reg[1] ;
  input \wr_pntr_bin_reg[2] ;
  input \gpregsm1.curr_fwft_state_reg[1] ;
  input [3:0]\wr_pntr_bin_reg[3] ;
  input [0:0]E;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;

  wire [3:0]D;
  wire [0:0]E;
  wire [3:0]Q;
  wire \gpregsm1.curr_fwft_state_reg[1] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;
  wire [3:0]plusOp__6;
  wire ram_empty_fb_i_i_2__2_n_0;
  wire ram_empty_fb_i_i_3__2_n_0;
  wire ram_empty_fb_i_reg;
  wire [2:0]\rd_pntr_gc_reg[1] ;
  wire s_aclk;
  wire \wr_pntr_bin_reg[2] ;
  wire [3:0]\wr_pntr_bin_reg[3] ;

  LUT1 #(
    .INIT(2'h1)) 
    \gc0.count[0]_i_1__2 
       (.I0(Q[0]),
        .O(plusOp__6[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gc0.count[1]_i_1__2 
       (.I0(Q[0]),
        .I1(Q[1]),
        .O(plusOp__6[1]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gc0.count[2]_i_1__2 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .O(plusOp__6[2]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gc0.count[3]_i_1__2 
       (.I0(Q[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(Q[3]),
        .O(plusOp__6[3]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[0]),
        .Q(\rd_pntr_gc_reg[1] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[1]),
        .Q(\rd_pntr_gc_reg[1] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[2]),
        .Q(\rd_pntr_gc_reg[1] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[3]),
        .Q(D[3]));
  FDPE #(
    .INIT(1'b1)) 
    \gc0.count_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .D(plusOp__6[0]),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__6[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__6[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__6[3]),
        .Q(Q[3]));
  LUT4 #(
    .INIT(16'hF888)) 
    ram_empty_fb_i_i_1__2
       (.I0(ram_empty_fb_i_i_2__2_n_0),
        .I1(ram_empty_fb_i_i_3__2_n_0),
        .I2(\wr_pntr_bin_reg[2] ),
        .I3(\gpregsm1.curr_fwft_state_reg[1] ),
        .O(ram_empty_fb_i_reg));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_fb_i_i_2__2
       (.I0(\rd_pntr_gc_reg[1] [2]),
        .I1(\wr_pntr_bin_reg[3] [2]),
        .I2(D[3]),
        .I3(\wr_pntr_bin_reg[3] [3]),
        .O(ram_empty_fb_i_i_2__2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_fb_i_i_3__2
       (.I0(\rd_pntr_gc_reg[1] [0]),
        .I1(\wr_pntr_bin_reg[3] [0]),
        .I2(\rd_pntr_gc_reg[1] [1]),
        .I3(\wr_pntr_bin_reg[3] [1]),
        .O(ram_empty_fb_i_i_3__2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[0]_i_1__2 
       (.I0(\rd_pntr_gc_reg[1] [0]),
        .I1(\rd_pntr_gc_reg[1] [1]),
        .O(D[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[1]_i_1__2 
       (.I0(\rd_pntr_gc_reg[1] [1]),
        .I1(\rd_pntr_gc_reg[1] [2]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[2]_i_1__2 
       (.I0(\rd_pntr_gc_reg[1] [2]),
        .I1(D[3]),
        .O(D[2]));
endmodule

(* ORIG_REF_NAME = "rd_bin_cntr" *) 
module xilinx_axi_clock_converter_rd_bin_cntr_14
   (Q,
    ram_empty_fb_i_reg,
    D,
    \rd_pntr_gc_reg[1] ,
    \wr_pntr_bin_reg[2] ,
    \gpregsm1.curr_fwft_state_reg[1] ,
    \wr_pntr_bin_reg[3] ,
    E,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] );
  output [3:0]Q;
  output ram_empty_fb_i_reg;
  output [3:0]D;
  output [2:0]\rd_pntr_gc_reg[1] ;
  input \wr_pntr_bin_reg[2] ;
  input \gpregsm1.curr_fwft_state_reg[1] ;
  input [3:0]\wr_pntr_bin_reg[3] ;
  input [0:0]E;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;

  wire [3:0]D;
  wire [0:0]E;
  wire [3:0]Q;
  wire \gpregsm1.curr_fwft_state_reg[1] ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;
  wire [3:0]plusOp__0;
  wire ram_empty_fb_i_i_2__0_n_0;
  wire ram_empty_fb_i_i_3__0_n_0;
  wire ram_empty_fb_i_reg;
  wire [2:0]\rd_pntr_gc_reg[1] ;
  wire \wr_pntr_bin_reg[2] ;
  wire [3:0]\wr_pntr_bin_reg[3] ;

  LUT1 #(
    .INIT(2'h1)) 
    \gc0.count[0]_i_1__0 
       (.I0(Q[0]),
        .O(plusOp__0[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gc0.count[1]_i_1__0 
       (.I0(Q[0]),
        .I1(Q[1]),
        .O(plusOp__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gc0.count[2]_i_1__0 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .O(plusOp__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gc0.count[3]_i_1__0 
       (.I0(Q[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(Q[3]),
        .O(plusOp__0[3]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[0]),
        .Q(\rd_pntr_gc_reg[1] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[1]),
        .Q(\rd_pntr_gc_reg[1] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[2]),
        .Q(\rd_pntr_gc_reg[1] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[3]),
        .Q(D[3]));
  FDPE #(
    .INIT(1'b1)) 
    \gc0.count_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .D(plusOp__0[0]),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__0[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__0[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__0[3]),
        .Q(Q[3]));
  LUT4 #(
    .INIT(16'hF888)) 
    ram_empty_fb_i_i_1__0
       (.I0(ram_empty_fb_i_i_2__0_n_0),
        .I1(ram_empty_fb_i_i_3__0_n_0),
        .I2(\wr_pntr_bin_reg[2] ),
        .I3(\gpregsm1.curr_fwft_state_reg[1] ),
        .O(ram_empty_fb_i_reg));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_fb_i_i_2__0
       (.I0(\rd_pntr_gc_reg[1] [2]),
        .I1(\wr_pntr_bin_reg[3] [2]),
        .I2(D[3]),
        .I3(\wr_pntr_bin_reg[3] [3]),
        .O(ram_empty_fb_i_i_2__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_fb_i_i_3__0
       (.I0(\rd_pntr_gc_reg[1] [0]),
        .I1(\wr_pntr_bin_reg[3] [0]),
        .I2(\rd_pntr_gc_reg[1] [1]),
        .I3(\wr_pntr_bin_reg[3] [1]),
        .O(ram_empty_fb_i_i_3__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[0]_i_1__0 
       (.I0(\rd_pntr_gc_reg[1] [0]),
        .I1(\rd_pntr_gc_reg[1] [1]),
        .O(D[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[1]_i_1__0 
       (.I0(\rd_pntr_gc_reg[1] [1]),
        .I1(\rd_pntr_gc_reg[1] [2]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[2]_i_1__0 
       (.I0(\rd_pntr_gc_reg[1] [2]),
        .I1(D[3]),
        .O(D[2]));
endmodule

(* ORIG_REF_NAME = "rd_bin_cntr" *) 
module xilinx_axi_clock_converter_rd_bin_cntr_29
   (Q,
    ram_empty_fb_i_reg,
    D,
    \rd_pntr_gc_reg[1] ,
    \wr_pntr_bin_reg[2] ,
    \gpregsm1.curr_fwft_state_reg[1] ,
    \wr_pntr_bin_reg[3] ,
    E,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] );
  output [3:0]Q;
  output ram_empty_fb_i_reg;
  output [3:0]D;
  output [2:0]\rd_pntr_gc_reg[1] ;
  input \wr_pntr_bin_reg[2] ;
  input \gpregsm1.curr_fwft_state_reg[1] ;
  input [3:0]\wr_pntr_bin_reg[3] ;
  input [0:0]E;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;

  wire [3:0]D;
  wire [0:0]E;
  wire [3:0]Q;
  wire \gpregsm1.curr_fwft_state_reg[1] ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;
  wire [3:0]plusOp;
  wire ram_empty_fb_i_i_2_n_0;
  wire ram_empty_fb_i_i_3_n_0;
  wire ram_empty_fb_i_reg;
  wire [2:0]\rd_pntr_gc_reg[1] ;
  wire \wr_pntr_bin_reg[2] ;
  wire [3:0]\wr_pntr_bin_reg[3] ;

  LUT1 #(
    .INIT(2'h1)) 
    \gc0.count[0]_i_1 
       (.I0(Q[0]),
        .O(plusOp[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gc0.count[1]_i_1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .O(plusOp[1]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gc0.count[2]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .O(plusOp[2]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gc0.count[3]_i_1 
       (.I0(Q[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(Q[3]),
        .O(plusOp[3]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[0]),
        .Q(\rd_pntr_gc_reg[1] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[1]),
        .Q(\rd_pntr_gc_reg[1] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[2]),
        .Q(\rd_pntr_gc_reg[1] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[3]),
        .Q(D[3]));
  FDPE #(
    .INIT(1'b1)) 
    \gc0.count_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .D(plusOp[0]),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp[3]),
        .Q(Q[3]));
  LUT4 #(
    .INIT(16'hF888)) 
    ram_empty_fb_i_i_1
       (.I0(ram_empty_fb_i_i_2_n_0),
        .I1(ram_empty_fb_i_i_3_n_0),
        .I2(\wr_pntr_bin_reg[2] ),
        .I3(\gpregsm1.curr_fwft_state_reg[1] ),
        .O(ram_empty_fb_i_reg));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_fb_i_i_2
       (.I0(\rd_pntr_gc_reg[1] [2]),
        .I1(\wr_pntr_bin_reg[3] [2]),
        .I2(D[3]),
        .I3(\wr_pntr_bin_reg[3] [3]),
        .O(ram_empty_fb_i_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_fb_i_i_3
       (.I0(\rd_pntr_gc_reg[1] [0]),
        .I1(\wr_pntr_bin_reg[3] [0]),
        .I2(\rd_pntr_gc_reg[1] [1]),
        .I3(\wr_pntr_bin_reg[3] [1]),
        .O(ram_empty_fb_i_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[0]_i_1 
       (.I0(\rd_pntr_gc_reg[1] [0]),
        .I1(\rd_pntr_gc_reg[1] [1]),
        .O(D[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[1]_i_1 
       (.I0(\rd_pntr_gc_reg[1] [1]),
        .I1(\rd_pntr_gc_reg[1] [2]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[2]_i_1 
       (.I0(\rd_pntr_gc_reg[1] [2]),
        .I1(D[3]),
        .O(D[2]));
endmodule

(* ORIG_REF_NAME = "rd_bin_cntr" *) 
module xilinx_axi_clock_converter_rd_bin_cntr_44
   (Q,
    ram_empty_fb_i_reg,
    D,
    \rd_pntr_gc_reg[1] ,
    \wr_pntr_bin_reg[2] ,
    \gpregsm1.curr_fwft_state_reg[1] ,
    \wr_pntr_bin_reg[3] ,
    E,
    s_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] );
  output [3:0]Q;
  output ram_empty_fb_i_reg;
  output [3:0]D;
  output [2:0]\rd_pntr_gc_reg[1] ;
  input \wr_pntr_bin_reg[2] ;
  input \gpregsm1.curr_fwft_state_reg[1] ;
  input [3:0]\wr_pntr_bin_reg[3] ;
  input [0:0]E;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;

  wire [3:0]D;
  wire [0:0]E;
  wire [3:0]Q;
  wire \gpregsm1.curr_fwft_state_reg[1] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;
  wire [3:0]plusOp__8;
  wire ram_empty_fb_i_i_2__3_n_0;
  wire ram_empty_fb_i_i_3__3_n_0;
  wire ram_empty_fb_i_reg;
  wire [2:0]\rd_pntr_gc_reg[1] ;
  wire s_aclk;
  wire \wr_pntr_bin_reg[2] ;
  wire [3:0]\wr_pntr_bin_reg[3] ;

  LUT1 #(
    .INIT(2'h1)) 
    \gc0.count[0]_i_1__3 
       (.I0(Q[0]),
        .O(plusOp__8[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gc0.count[1]_i_1__3 
       (.I0(Q[0]),
        .I1(Q[1]),
        .O(plusOp__8[1]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gc0.count[2]_i_1__3 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .O(plusOp__8[2]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gc0.count[3]_i_1__3 
       (.I0(Q[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(Q[3]),
        .O(plusOp__8[3]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[0]),
        .Q(\rd_pntr_gc_reg[1] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[1]),
        .Q(\rd_pntr_gc_reg[1] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[2]),
        .Q(\rd_pntr_gc_reg[1] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[3]),
        .Q(D[3]));
  FDPE #(
    .INIT(1'b1)) 
    \gc0.count_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .D(plusOp__8[0]),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__8[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__8[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__8[3]),
        .Q(Q[3]));
  LUT4 #(
    .INIT(16'hF888)) 
    ram_empty_fb_i_i_1__3
       (.I0(ram_empty_fb_i_i_2__3_n_0),
        .I1(ram_empty_fb_i_i_3__3_n_0),
        .I2(\wr_pntr_bin_reg[2] ),
        .I3(\gpregsm1.curr_fwft_state_reg[1] ),
        .O(ram_empty_fb_i_reg));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_fb_i_i_2__3
       (.I0(\rd_pntr_gc_reg[1] [2]),
        .I1(\wr_pntr_bin_reg[3] [2]),
        .I2(D[3]),
        .I3(\wr_pntr_bin_reg[3] [3]),
        .O(ram_empty_fb_i_i_2__3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_fb_i_i_3__3
       (.I0(\rd_pntr_gc_reg[1] [0]),
        .I1(\wr_pntr_bin_reg[3] [0]),
        .I2(\rd_pntr_gc_reg[1] [1]),
        .I3(\wr_pntr_bin_reg[3] [1]),
        .O(ram_empty_fb_i_i_3__3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[0]_i_1__3 
       (.I0(\rd_pntr_gc_reg[1] [0]),
        .I1(\rd_pntr_gc_reg[1] [1]),
        .O(D[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[1]_i_1__3 
       (.I0(\rd_pntr_gc_reg[1] [1]),
        .I1(\rd_pntr_gc_reg[1] [2]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[2]_i_1__3 
       (.I0(\rd_pntr_gc_reg[1] [2]),
        .I1(D[3]),
        .O(D[2]));
endmodule

(* ORIG_REF_NAME = "rd_bin_cntr" *) 
module xilinx_axi_clock_converter_rd_bin_cntr_62
   (Q,
    ram_empty_fb_i_reg,
    D,
    \rd_pntr_gc_reg[1] ,
    \wr_pntr_bin_reg[2] ,
    \gpregsm1.curr_fwft_state_reg[1] ,
    \wr_pntr_bin_reg[3] ,
    E,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] );
  output [3:0]Q;
  output ram_empty_fb_i_reg;
  output [3:0]D;
  output [2:0]\rd_pntr_gc_reg[1] ;
  input \wr_pntr_bin_reg[2] ;
  input \gpregsm1.curr_fwft_state_reg[1] ;
  input [3:0]\wr_pntr_bin_reg[3] ;
  input [0:0]E;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;

  wire [3:0]D;
  wire [0:0]E;
  wire [3:0]Q;
  wire \gpregsm1.curr_fwft_state_reg[1] ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;
  wire [3:0]plusOp__2;
  wire ram_empty_fb_i_i_2__1_n_0;
  wire ram_empty_fb_i_i_3__1_n_0;
  wire ram_empty_fb_i_reg;
  wire [2:0]\rd_pntr_gc_reg[1] ;
  wire \wr_pntr_bin_reg[2] ;
  wire [3:0]\wr_pntr_bin_reg[3] ;

  LUT1 #(
    .INIT(2'h1)) 
    \gc0.count[0]_i_1__1 
       (.I0(Q[0]),
        .O(plusOp__2[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gc0.count[1]_i_1__1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .O(plusOp__2[1]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gc0.count[2]_i_1__1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .O(plusOp__2[2]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gc0.count[3]_i_1__1 
       (.I0(Q[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(Q[3]),
        .O(plusOp__2[3]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[0]),
        .Q(\rd_pntr_gc_reg[1] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[1]),
        .Q(\rd_pntr_gc_reg[1] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[2]),
        .Q(\rd_pntr_gc_reg[1] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[3]),
        .Q(D[3]));
  FDPE #(
    .INIT(1'b1)) 
    \gc0.count_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .D(plusOp__2[0]),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__2[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__2[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp__2[3]),
        .Q(Q[3]));
  LUT4 #(
    .INIT(16'hF888)) 
    ram_empty_fb_i_i_1__1
       (.I0(ram_empty_fb_i_i_2__1_n_0),
        .I1(ram_empty_fb_i_i_3__1_n_0),
        .I2(\wr_pntr_bin_reg[2] ),
        .I3(\gpregsm1.curr_fwft_state_reg[1] ),
        .O(ram_empty_fb_i_reg));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_fb_i_i_2__1
       (.I0(\rd_pntr_gc_reg[1] [2]),
        .I1(\wr_pntr_bin_reg[3] [2]),
        .I2(D[3]),
        .I3(\wr_pntr_bin_reg[3] [3]),
        .O(ram_empty_fb_i_i_2__1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_fb_i_i_3__1
       (.I0(\rd_pntr_gc_reg[1] [0]),
        .I1(\wr_pntr_bin_reg[3] [0]),
        .I2(\rd_pntr_gc_reg[1] [1]),
        .I3(\wr_pntr_bin_reg[3] [1]),
        .O(ram_empty_fb_i_i_3__1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[0]_i_1__1 
       (.I0(\rd_pntr_gc_reg[1] [0]),
        .I1(\rd_pntr_gc_reg[1] [1]),
        .O(D[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[1]_i_1__1 
       (.I0(\rd_pntr_gc_reg[1] [1]),
        .I1(\rd_pntr_gc_reg[1] [2]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_gc[2]_i_1__1 
       (.I0(\rd_pntr_gc_reg[1] [2]),
        .I1(D[3]),
        .O(D[2]));
endmodule

(* ORIG_REF_NAME = "rd_fwft" *) 
module xilinx_axi_clock_converter_rd_fwft
   (ram_empty_fb_i_reg,
    E,
    ram_rd_en_i,
    \goreg_dm.dout_i_reg[17] ,
    s_axi_bvalid,
    s_aclk,
    Q,
    s_axi_bready,
    \gc0.count_reg[3] ,
    \wr_pntr_bin_reg[3] ,
    p_18_out);
  output ram_empty_fb_i_reg;
  output [0:0]E;
  output ram_rd_en_i;
  output [0:0]\goreg_dm.dout_i_reg[17] ;
  output s_axi_bvalid;
  input s_aclk;
  input [1:0]Q;
  input s_axi_bready;
  input [0:0]\gc0.count_reg[3] ;
  input [0:0]\wr_pntr_bin_reg[3] ;
  input p_18_out;

  wire [0:0]E;
  wire [1:0]Q;
  wire [0:0]curr_fwft_state;
  wire empty_fwft_fb;
  wire empty_fwft_i0;
  wire empty_fwft_i_reg_n_0;
  wire [0:0]\gc0.count_reg[3] ;
  wire [0:0]\goreg_dm.dout_i_reg[17] ;
  wire \gpregsm1.curr_fwft_state_reg_n_0_[1] ;
  wire [1:0]next_fwft_state;
  wire p_18_out;
  wire ram_empty_fb_i_reg;
  wire ram_rd_en_i;
  wire s_aclk;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [0:0]\wr_pntr_bin_reg[3] ;

  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT4 #(
    .INIT(16'hC0EC)) 
    empty_fwft_fb_i_1__2
       (.I0(s_axi_bready),
        .I1(empty_fwft_fb),
        .I2(curr_fwft_state),
        .I3(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .O(empty_fwft_i0));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_fb_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q[1]),
        .Q(empty_fwft_fb));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_i_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q[1]),
        .Q(empty_fwft_i_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \gc0.count_d1[3]_i_1__2 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(s_axi_bready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT4 #(
    .INIT(16'h4404)) 
    \goreg_dm.dout_i[17]_i_1 
       (.I0(Q[0]),
        .I1(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I2(curr_fwft_state),
        .I3(s_axi_bready),
        .O(\goreg_dm.dout_i_reg[17] ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \gpr1.dout_i[17]_i_1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(s_axi_bready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(ram_rd_en_i));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'hAE)) 
    \gpregsm1.curr_fwft_state[0]_i_1__2 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(curr_fwft_state),
        .I2(s_axi_bready),
        .O(next_fwft_state[0]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT4 #(
    .INIT(16'h20FF)) 
    \gpregsm1.curr_fwft_state[1]_i_1__2 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(s_axi_bready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(next_fwft_state[1]));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(Q[1]),
        .D(next_fwft_state[0]),
        .Q(curr_fwft_state));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(Q[1]),
        .D(next_fwft_state[1]),
        .Q(\gpregsm1.curr_fwft_state_reg_n_0_[1] ));
  LUT6 #(
    .INIT(64'h00000000DF0000DF)) 
    ram_empty_fb_i_i_5__2
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(s_axi_bready),
        .I2(curr_fwft_state),
        .I3(\gc0.count_reg[3] ),
        .I4(\wr_pntr_bin_reg[3] ),
        .I5(p_18_out),
        .O(ram_empty_fb_i_reg));
  LUT1 #(
    .INIT(2'h1)) 
    s_axi_bvalid_INST_0
       (.I0(empty_fwft_i_reg_n_0),
        .O(s_axi_bvalid));
endmodule

(* ORIG_REF_NAME = "rd_fwft" *) 
module xilinx_axi_clock_converter_rd_fwft_12
   (ram_empty_fb_i_reg,
    E,
    ram_rd_en_i,
    \goreg_dm.dout_i_reg[36] ,
    m_axi_wvalid,
    m_aclk,
    Q,
    m_axi_wready,
    \gc0.count_reg[3] ,
    \wr_pntr_bin_reg[3] ,
    p_18_out);
  output ram_empty_fb_i_reg;
  output [0:0]E;
  output ram_rd_en_i;
  output [0:0]\goreg_dm.dout_i_reg[36] ;
  output m_axi_wvalid;
  input m_aclk;
  input [1:0]Q;
  input m_axi_wready;
  input [0:0]\gc0.count_reg[3] ;
  input [0:0]\wr_pntr_bin_reg[3] ;
  input p_18_out;

  wire [0:0]E;
  wire [1:0]Q;
  wire [0:0]curr_fwft_state;
  wire empty_fwft_fb;
  wire empty_fwft_i0;
  wire empty_fwft_i_reg_n_0;
  wire [0:0]\gc0.count_reg[3] ;
  wire [0:0]\goreg_dm.dout_i_reg[36] ;
  wire \gpregsm1.curr_fwft_state_reg_n_0_[1] ;
  wire m_aclk;
  wire m_axi_wready;
  wire m_axi_wvalid;
  wire [1:0]next_fwft_state;
  wire p_18_out;
  wire ram_empty_fb_i_reg;
  wire ram_rd_en_i;
  wire [0:0]\wr_pntr_bin_reg[3] ;

  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT4 #(
    .INIT(16'hC0EC)) 
    empty_fwft_fb_i_1__0
       (.I0(m_axi_wready),
        .I1(empty_fwft_fb),
        .I2(curr_fwft_state),
        .I3(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .O(empty_fwft_i0));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_fb_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q[1]),
        .Q(empty_fwft_fb));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_i_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q[1]),
        .Q(empty_fwft_i_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \gc0.count_d1[3]_i_1__0 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_wready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT4 #(
    .INIT(16'h4404)) 
    \goreg_dm.dout_i[36]_i_1 
       (.I0(Q[0]),
        .I1(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I2(curr_fwft_state),
        .I3(m_axi_wready),
        .O(\goreg_dm.dout_i_reg[36] ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \gpr1.dout_i[36]_i_1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_wready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(ram_rd_en_i));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hAE)) 
    \gpregsm1.curr_fwft_state[0]_i_1__0 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(curr_fwft_state),
        .I2(m_axi_wready),
        .O(next_fwft_state[0]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT4 #(
    .INIT(16'h20FF)) 
    \gpregsm1.curr_fwft_state[1]_i_1__0 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_wready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(next_fwft_state[1]));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(Q[1]),
        .D(next_fwft_state[0]),
        .Q(curr_fwft_state));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(Q[1]),
        .D(next_fwft_state[1]),
        .Q(\gpregsm1.curr_fwft_state_reg_n_0_[1] ));
  LUT1 #(
    .INIT(2'h1)) 
    m_axi_wvalid_INST_0
       (.I0(empty_fwft_i_reg_n_0),
        .O(m_axi_wvalid));
  LUT6 #(
    .INIT(64'h00000000DF0000DF)) 
    ram_empty_fb_i_i_5__0
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_wready),
        .I2(curr_fwft_state),
        .I3(\gc0.count_reg[3] ),
        .I4(\wr_pntr_bin_reg[3] ),
        .I5(p_18_out),
        .O(ram_empty_fb_i_reg));
endmodule

(* ORIG_REF_NAME = "rd_fwft" *) 
module xilinx_axi_clock_converter_rd_fwft_27
   (ram_empty_fb_i_reg,
    E,
    ram_rd_en_i,
    \goreg_dm.dout_i_reg[76] ,
    m_axi_awvalid,
    m_aclk,
    Q,
    m_axi_awready,
    \gc0.count_reg[3] ,
    \wr_pntr_bin_reg[3] ,
    p_18_out);
  output ram_empty_fb_i_reg;
  output [0:0]E;
  output ram_rd_en_i;
  output [0:0]\goreg_dm.dout_i_reg[76] ;
  output m_axi_awvalid;
  input m_aclk;
  input [1:0]Q;
  input m_axi_awready;
  input [0:0]\gc0.count_reg[3] ;
  input [0:0]\wr_pntr_bin_reg[3] ;
  input p_18_out;

  wire [0:0]E;
  wire [1:0]Q;
  wire [0:0]curr_fwft_state;
  wire empty_fwft_fb;
  wire empty_fwft_i;
  wire empty_fwft_i0;
  wire [0:0]\gc0.count_reg[3] ;
  wire [0:0]\goreg_dm.dout_i_reg[76] ;
  wire \gpregsm1.curr_fwft_state_reg_n_0_[1] ;
  wire m_aclk;
  wire m_axi_awready;
  wire m_axi_awvalid;
  wire [1:0]next_fwft_state;
  wire p_18_out;
  wire ram_empty_fb_i_reg;
  wire ram_rd_en_i;
  wire [0:0]\wr_pntr_bin_reg[3] ;

  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'hC0EC)) 
    empty_fwft_fb_i_1
       (.I0(m_axi_awready),
        .I1(empty_fwft_fb),
        .I2(curr_fwft_state),
        .I3(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .O(empty_fwft_i0));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_fb_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q[1]),
        .Q(empty_fwft_fb));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_i_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q[1]),
        .Q(empty_fwft_i));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \gc0.count_d1[3]_i_1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_awready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'h4404)) 
    \goreg_dm.dout_i[76]_i_1 
       (.I0(Q[0]),
        .I1(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I2(curr_fwft_state),
        .I3(m_axi_awready),
        .O(\goreg_dm.dout_i_reg[76] ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \gpr1.dout_i[76]_i_1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_awready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(ram_rd_en_i));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hAE)) 
    \gpregsm1.curr_fwft_state[0]_i_1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(curr_fwft_state),
        .I2(m_axi_awready),
        .O(next_fwft_state[0]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'h20FF)) 
    \gpregsm1.curr_fwft_state[1]_i_1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_awready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(next_fwft_state[1]));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(Q[1]),
        .D(next_fwft_state[0]),
        .Q(curr_fwft_state));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(Q[1]),
        .D(next_fwft_state[1]),
        .Q(\gpregsm1.curr_fwft_state_reg_n_0_[1] ));
  LUT1 #(
    .INIT(2'h1)) 
    m_axi_awvalid_INST_0
       (.I0(empty_fwft_i),
        .O(m_axi_awvalid));
  LUT6 #(
    .INIT(64'h00000000DF0000DF)) 
    ram_empty_fb_i_i_5
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_awready),
        .I2(curr_fwft_state),
        .I3(\gc0.count_reg[3] ),
        .I4(\wr_pntr_bin_reg[3] ),
        .I5(p_18_out),
        .O(ram_empty_fb_i_reg));
endmodule

(* ORIG_REF_NAME = "rd_fwft" *) 
module xilinx_axi_clock_converter_rd_fwft_42
   (ram_empty_fb_i_reg,
    E,
    ram_rd_en_i,
    \goreg_dm.dout_i_reg[50] ,
    s_axi_rvalid,
    s_aclk,
    Q,
    s_axi_rready,
    \gc0.count_reg[3] ,
    \wr_pntr_bin_reg[3] ,
    p_18_out);
  output ram_empty_fb_i_reg;
  output [0:0]E;
  output ram_rd_en_i;
  output [0:0]\goreg_dm.dout_i_reg[50] ;
  output s_axi_rvalid;
  input s_aclk;
  input [1:0]Q;
  input s_axi_rready;
  input [0:0]\gc0.count_reg[3] ;
  input [0:0]\wr_pntr_bin_reg[3] ;
  input p_18_out;

  wire [0:0]E;
  wire [1:0]Q;
  wire [0:0]curr_fwft_state;
  wire empty_fwft_fb;
  wire empty_fwft_i0;
  wire empty_fwft_i_reg_n_0;
  wire [0:0]\gc0.count_reg[3] ;
  wire [0:0]\goreg_dm.dout_i_reg[50] ;
  wire \gpregsm1.curr_fwft_state_reg_n_0_[1] ;
  wire [1:0]next_fwft_state;
  wire p_18_out;
  wire ram_empty_fb_i_reg;
  wire ram_rd_en_i;
  wire s_aclk;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [0:0]\wr_pntr_bin_reg[3] ;

  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hC0EC)) 
    empty_fwft_fb_i_1__3
       (.I0(s_axi_rready),
        .I1(empty_fwft_fb),
        .I2(curr_fwft_state),
        .I3(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .O(empty_fwft_i0));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_fb_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q[1]),
        .Q(empty_fwft_fb));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_i_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q[1]),
        .Q(empty_fwft_i_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \gc0.count_d1[3]_i_1__3 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(s_axi_rready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h4404)) 
    \goreg_dm.dout_i[50]_i_1 
       (.I0(Q[0]),
        .I1(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I2(curr_fwft_state),
        .I3(s_axi_rready),
        .O(\goreg_dm.dout_i_reg[50] ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \gpr1.dout_i[50]_i_1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(s_axi_rready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(ram_rd_en_i));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hAE)) 
    \gpregsm1.curr_fwft_state[0]_i_1__3 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(curr_fwft_state),
        .I2(s_axi_rready),
        .O(next_fwft_state[0]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h20FF)) 
    \gpregsm1.curr_fwft_state[1]_i_1__3 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(s_axi_rready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(next_fwft_state[1]));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(Q[1]),
        .D(next_fwft_state[0]),
        .Q(curr_fwft_state));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(Q[1]),
        .D(next_fwft_state[1]),
        .Q(\gpregsm1.curr_fwft_state_reg_n_0_[1] ));
  LUT6 #(
    .INIT(64'h00000000DF0000DF)) 
    ram_empty_fb_i_i_5__3
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(s_axi_rready),
        .I2(curr_fwft_state),
        .I3(\gc0.count_reg[3] ),
        .I4(\wr_pntr_bin_reg[3] ),
        .I5(p_18_out),
        .O(ram_empty_fb_i_reg));
  LUT1 #(
    .INIT(2'h1)) 
    s_axi_rvalid_INST_0
       (.I0(empty_fwft_i_reg_n_0),
        .O(s_axi_rvalid));
endmodule

(* ORIG_REF_NAME = "rd_fwft" *) 
module xilinx_axi_clock_converter_rd_fwft_60
   (ram_empty_fb_i_reg,
    E,
    ram_rd_en_i,
    \goreg_dm.dout_i_reg[76] ,
    m_axi_arvalid,
    m_aclk,
    Q,
    m_axi_arready,
    \gc0.count_reg[3] ,
    \wr_pntr_bin_reg[3] ,
    p_18_out);
  output ram_empty_fb_i_reg;
  output [0:0]E;
  output ram_rd_en_i;
  output [0:0]\goreg_dm.dout_i_reg[76] ;
  output m_axi_arvalid;
  input m_aclk;
  input [1:0]Q;
  input m_axi_arready;
  input [0:0]\gc0.count_reg[3] ;
  input [0:0]\wr_pntr_bin_reg[3] ;
  input p_18_out;

  wire [0:0]E;
  wire [1:0]Q;
  wire [0:0]curr_fwft_state;
  wire empty_fwft_fb;
  wire empty_fwft_i0;
  wire empty_fwft_i_reg_n_0;
  wire [0:0]\gc0.count_reg[3] ;
  wire [0:0]\goreg_dm.dout_i_reg[76] ;
  wire \gpregsm1.curr_fwft_state_reg_n_0_[1] ;
  wire m_aclk;
  wire m_axi_arready;
  wire m_axi_arvalid;
  wire [1:0]next_fwft_state;
  wire p_18_out;
  wire ram_empty_fb_i_reg;
  wire ram_rd_en_i;
  wire [0:0]\wr_pntr_bin_reg[3] ;

  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hC0EC)) 
    empty_fwft_fb_i_1__1
       (.I0(m_axi_arready),
        .I1(empty_fwft_fb),
        .I2(curr_fwft_state),
        .I3(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .O(empty_fwft_i0));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_fb_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q[1]),
        .Q(empty_fwft_fb));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_i_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q[1]),
        .Q(empty_fwft_i_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \gc0.count_d1[3]_i_1__1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_arready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h4404)) 
    \goreg_dm.dout_i[76]_i_1__0 
       (.I0(Q[0]),
        .I1(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I2(curr_fwft_state),
        .I3(m_axi_arready),
        .O(\goreg_dm.dout_i_reg[76] ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h00DF)) 
    \gpr1.dout_i[76]_i_1__0 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_arready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(ram_rd_en_i));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hAE)) 
    \gpregsm1.curr_fwft_state[0]_i_1__1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(curr_fwft_state),
        .I2(m_axi_arready),
        .O(next_fwft_state[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h20FF)) 
    \gpregsm1.curr_fwft_state[1]_i_1__1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_arready),
        .I2(curr_fwft_state),
        .I3(p_18_out),
        .O(next_fwft_state[1]));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(Q[1]),
        .D(next_fwft_state[0]),
        .Q(curr_fwft_state));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(Q[1]),
        .D(next_fwft_state[1]),
        .Q(\gpregsm1.curr_fwft_state_reg_n_0_[1] ));
  LUT1 #(
    .INIT(2'h1)) 
    m_axi_arvalid_INST_0
       (.I0(empty_fwft_i_reg_n_0),
        .O(m_axi_arvalid));
  LUT6 #(
    .INIT(64'h00000000DF0000DF)) 
    ram_empty_fb_i_i_5__1
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(m_axi_arready),
        .I2(curr_fwft_state),
        .I3(\gc0.count_reg[3] ),
        .I4(\wr_pntr_bin_reg[3] ),
        .I5(p_18_out),
        .O(ram_empty_fb_i_reg));
endmodule

(* ORIG_REF_NAME = "rd_logic" *) 
module xilinx_axi_clock_converter_rd_logic
   (\gc0.count_d1_reg[2] ,
    ram_rd_en_i,
    E,
    D,
    \rd_pntr_gc_reg[1] ,
    s_axi_bvalid,
    s_aclk,
    Q,
    s_axi_bready,
    \wr_pntr_bin_reg[3] ,
    \wr_pntr_bin_reg[2] );
  output [2:0]\gc0.count_d1_reg[2] ;
  output ram_rd_en_i;
  output [0:0]E;
  output [3:0]D;
  output [2:0]\rd_pntr_gc_reg[1] ;
  output s_axi_bvalid;
  input s_aclk;
  input [1:0]Q;
  input s_axi_bready;
  input [3:0]\wr_pntr_bin_reg[3] ;
  input \wr_pntr_bin_reg[2] ;

  wire [3:0]D;
  wire [0:0]E;
  wire [1:0]Q;
  wire [2:0]\gc0.count_d1_reg[2] ;
  wire \gr1.rfwft_n_0 ;
  wire p_14_out;
  wire p_18_out;
  wire ram_rd_en_i;
  wire [2:0]\rd_pntr_gc_reg[1] ;
  wire [3:3]rd_pntr_plus1;
  wire rpntr_n_4;
  wire s_aclk;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire \wr_pntr_bin_reg[2] ;
  wire [3:0]\wr_pntr_bin_reg[3] ;

  xilinx_axi_clock_converter_rd_fwft \gr1.rfwft 
       (.E(p_14_out),
        .Q(Q),
        .\gc0.count_reg[3] (rd_pntr_plus1),
        .\goreg_dm.dout_i_reg[17] (E),
        .p_18_out(p_18_out),
        .ram_empty_fb_i_reg(\gr1.rfwft_n_0 ),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .\wr_pntr_bin_reg[3] (\wr_pntr_bin_reg[3] [3]));
  xilinx_axi_clock_converter_rd_status_flags_as \gras.rsts 
       (.Q(Q[1]),
        .\gc0.count_d1_reg[2] (rpntr_n_4),
        .p_18_out(p_18_out),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_rd_bin_cntr rpntr
       (.D(D),
        .E(p_14_out),
        .Q({rd_pntr_plus1,\gc0.count_d1_reg[2] }),
        .\gpregsm1.curr_fwft_state_reg[1] (\gr1.rfwft_n_0 ),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] (Q[1]),
        .ram_empty_fb_i_reg(rpntr_n_4),
        .\rd_pntr_gc_reg[1] (\rd_pntr_gc_reg[1] ),
        .s_aclk(s_aclk),
        .\wr_pntr_bin_reg[2] (\wr_pntr_bin_reg[2] ),
        .\wr_pntr_bin_reg[3] (\wr_pntr_bin_reg[3] ));
endmodule

(* ORIG_REF_NAME = "rd_logic" *) 
module xilinx_axi_clock_converter_rd_logic_22
   (\gc0.count_d1_reg[2] ,
    ram_rd_en_i,
    E,
    D,
    \rd_pntr_gc_reg[1] ,
    m_axi_awvalid,
    m_aclk,
    Q,
    m_axi_awready,
    \wr_pntr_bin_reg[3] ,
    \wr_pntr_bin_reg[2] );
  output [2:0]\gc0.count_d1_reg[2] ;
  output ram_rd_en_i;
  output [0:0]E;
  output [3:0]D;
  output [2:0]\rd_pntr_gc_reg[1] ;
  output m_axi_awvalid;
  input m_aclk;
  input [1:0]Q;
  input m_axi_awready;
  input [3:0]\wr_pntr_bin_reg[3] ;
  input \wr_pntr_bin_reg[2] ;

  wire [3:0]D;
  wire [0:0]E;
  wire [1:0]Q;
  wire [2:0]\gc0.count_d1_reg[2] ;
  wire \gr1.rfwft_n_0 ;
  wire m_aclk;
  wire m_axi_awready;
  wire m_axi_awvalid;
  wire p_14_out;
  wire p_18_out;
  wire ram_rd_en_i;
  wire [2:0]\rd_pntr_gc_reg[1] ;
  wire [3:3]rd_pntr_plus1;
  wire rpntr_n_4;
  wire \wr_pntr_bin_reg[2] ;
  wire [3:0]\wr_pntr_bin_reg[3] ;

  xilinx_axi_clock_converter_rd_fwft_27 \gr1.rfwft 
       (.E(p_14_out),
        .Q(Q),
        .\gc0.count_reg[3] (rd_pntr_plus1),
        .\goreg_dm.dout_i_reg[76] (E),
        .m_aclk(m_aclk),
        .m_axi_awready(m_axi_awready),
        .m_axi_awvalid(m_axi_awvalid),
        .p_18_out(p_18_out),
        .ram_empty_fb_i_reg(\gr1.rfwft_n_0 ),
        .ram_rd_en_i(ram_rd_en_i),
        .\wr_pntr_bin_reg[3] (\wr_pntr_bin_reg[3] [3]));
  xilinx_axi_clock_converter_rd_status_flags_as_28 \gras.rsts 
       (.Q(Q[1]),
        .\gc0.count_d1_reg[2] (rpntr_n_4),
        .m_aclk(m_aclk),
        .p_18_out(p_18_out));
  xilinx_axi_clock_converter_rd_bin_cntr_29 rpntr
       (.D(D),
        .E(p_14_out),
        .Q({rd_pntr_plus1,\gc0.count_d1_reg[2] }),
        .\gpregsm1.curr_fwft_state_reg[1] (\gr1.rfwft_n_0 ),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] (Q[1]),
        .ram_empty_fb_i_reg(rpntr_n_4),
        .\rd_pntr_gc_reg[1] (\rd_pntr_gc_reg[1] ),
        .\wr_pntr_bin_reg[2] (\wr_pntr_bin_reg[2] ),
        .\wr_pntr_bin_reg[3] (\wr_pntr_bin_reg[3] ));
endmodule

(* ORIG_REF_NAME = "rd_logic" *) 
module xilinx_axi_clock_converter_rd_logic_37
   (\gc0.count_d1_reg[2] ,
    ram_rd_en_i,
    E,
    D,
    \rd_pntr_gc_reg[1] ,
    s_axi_rvalid,
    s_aclk,
    Q,
    s_axi_rready,
    \wr_pntr_bin_reg[3] ,
    \wr_pntr_bin_reg[2] );
  output [2:0]\gc0.count_d1_reg[2] ;
  output ram_rd_en_i;
  output [0:0]E;
  output [3:0]D;
  output [2:0]\rd_pntr_gc_reg[1] ;
  output s_axi_rvalid;
  input s_aclk;
  input [1:0]Q;
  input s_axi_rready;
  input [3:0]\wr_pntr_bin_reg[3] ;
  input \wr_pntr_bin_reg[2] ;

  wire [3:0]D;
  wire [0:0]E;
  wire [1:0]Q;
  wire [2:0]\gc0.count_d1_reg[2] ;
  wire \gr1.rfwft_n_0 ;
  wire p_14_out;
  wire p_18_out;
  wire ram_rd_en_i;
  wire [2:0]\rd_pntr_gc_reg[1] ;
  wire [3:3]rd_pntr_plus1;
  wire rpntr_n_4;
  wire s_aclk;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire \wr_pntr_bin_reg[2] ;
  wire [3:0]\wr_pntr_bin_reg[3] ;

  xilinx_axi_clock_converter_rd_fwft_42 \gr1.rfwft 
       (.E(p_14_out),
        .Q(Q),
        .\gc0.count_reg[3] (rd_pntr_plus1),
        .\goreg_dm.dout_i_reg[50] (E),
        .p_18_out(p_18_out),
        .ram_empty_fb_i_reg(\gr1.rfwft_n_0 ),
        .ram_rd_en_i(ram_rd_en_i),
        .s_aclk(s_aclk),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid),
        .\wr_pntr_bin_reg[3] (\wr_pntr_bin_reg[3] [3]));
  xilinx_axi_clock_converter_rd_status_flags_as_43 \gras.rsts 
       (.Q(Q[1]),
        .\gc0.count_d1_reg[2] (rpntr_n_4),
        .p_18_out(p_18_out),
        .s_aclk(s_aclk));
  xilinx_axi_clock_converter_rd_bin_cntr_44 rpntr
       (.D(D),
        .E(p_14_out),
        .Q({rd_pntr_plus1,\gc0.count_d1_reg[2] }),
        .\gpregsm1.curr_fwft_state_reg[1] (\gr1.rfwft_n_0 ),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] (Q[1]),
        .ram_empty_fb_i_reg(rpntr_n_4),
        .\rd_pntr_gc_reg[1] (\rd_pntr_gc_reg[1] ),
        .s_aclk(s_aclk),
        .\wr_pntr_bin_reg[2] (\wr_pntr_bin_reg[2] ),
        .\wr_pntr_bin_reg[3] (\wr_pntr_bin_reg[3] ));
endmodule

(* ORIG_REF_NAME = "rd_logic" *) 
module xilinx_axi_clock_converter_rd_logic_53
   (\gc0.count_d1_reg[2] ,
    ram_rd_en_i,
    E,
    D,
    \rd_pntr_gc_reg[1] ,
    m_axi_arvalid,
    m_aclk,
    Q,
    m_axi_arready,
    \wr_pntr_bin_reg[3] ,
    \wr_pntr_bin_reg[2] );
  output [2:0]\gc0.count_d1_reg[2] ;
  output ram_rd_en_i;
  output [0:0]E;
  output [3:0]D;
  output [2:0]\rd_pntr_gc_reg[1] ;
  output m_axi_arvalid;
  input m_aclk;
  input [1:0]Q;
  input m_axi_arready;
  input [3:0]\wr_pntr_bin_reg[3] ;
  input \wr_pntr_bin_reg[2] ;

  wire [3:0]D;
  wire [0:0]E;
  wire [1:0]Q;
  wire [2:0]\gc0.count_d1_reg[2] ;
  wire \gr1.rfwft_n_0 ;
  wire m_aclk;
  wire m_axi_arready;
  wire m_axi_arvalid;
  wire p_14_out;
  wire p_18_out;
  wire ram_rd_en_i;
  wire [2:0]\rd_pntr_gc_reg[1] ;
  wire [3:3]rd_pntr_plus1;
  wire rpntr_n_4;
  wire \wr_pntr_bin_reg[2] ;
  wire [3:0]\wr_pntr_bin_reg[3] ;

  xilinx_axi_clock_converter_rd_fwft_60 \gr1.rfwft 
       (.E(p_14_out),
        .Q(Q),
        .\gc0.count_reg[3] (rd_pntr_plus1),
        .\goreg_dm.dout_i_reg[76] (E),
        .m_aclk(m_aclk),
        .m_axi_arready(m_axi_arready),
        .m_axi_arvalid(m_axi_arvalid),
        .p_18_out(p_18_out),
        .ram_empty_fb_i_reg(\gr1.rfwft_n_0 ),
        .ram_rd_en_i(ram_rd_en_i),
        .\wr_pntr_bin_reg[3] (\wr_pntr_bin_reg[3] [3]));
  xilinx_axi_clock_converter_rd_status_flags_as_61 \gras.rsts 
       (.Q(Q[1]),
        .\gc0.count_d1_reg[2] (rpntr_n_4),
        .m_aclk(m_aclk),
        .p_18_out(p_18_out));
  xilinx_axi_clock_converter_rd_bin_cntr_62 rpntr
       (.D(D),
        .E(p_14_out),
        .Q({rd_pntr_plus1,\gc0.count_d1_reg[2] }),
        .\gpregsm1.curr_fwft_state_reg[1] (\gr1.rfwft_n_0 ),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] (Q[1]),
        .ram_empty_fb_i_reg(rpntr_n_4),
        .\rd_pntr_gc_reg[1] (\rd_pntr_gc_reg[1] ),
        .\wr_pntr_bin_reg[2] (\wr_pntr_bin_reg[2] ),
        .\wr_pntr_bin_reg[3] (\wr_pntr_bin_reg[3] ));
endmodule

(* ORIG_REF_NAME = "rd_logic" *) 
module xilinx_axi_clock_converter_rd_logic_7
   (\gc0.count_d1_reg[2] ,
    ram_rd_en_i,
    E,
    D,
    \rd_pntr_gc_reg[1] ,
    m_axi_wvalid,
    m_aclk,
    Q,
    m_axi_wready,
    \wr_pntr_bin_reg[3] ,
    \wr_pntr_bin_reg[2] );
  output [2:0]\gc0.count_d1_reg[2] ;
  output ram_rd_en_i;
  output [0:0]E;
  output [3:0]D;
  output [2:0]\rd_pntr_gc_reg[1] ;
  output m_axi_wvalid;
  input m_aclk;
  input [1:0]Q;
  input m_axi_wready;
  input [3:0]\wr_pntr_bin_reg[3] ;
  input \wr_pntr_bin_reg[2] ;

  wire [3:0]D;
  wire [0:0]E;
  wire [1:0]Q;
  wire [2:0]\gc0.count_d1_reg[2] ;
  wire \gr1.rfwft_n_0 ;
  wire m_aclk;
  wire m_axi_wready;
  wire m_axi_wvalid;
  wire p_14_out;
  wire p_18_out;
  wire ram_rd_en_i;
  wire [2:0]\rd_pntr_gc_reg[1] ;
  wire [3:3]rd_pntr_plus1;
  wire rpntr_n_4;
  wire \wr_pntr_bin_reg[2] ;
  wire [3:0]\wr_pntr_bin_reg[3] ;

  xilinx_axi_clock_converter_rd_fwft_12 \gr1.rfwft 
       (.E(p_14_out),
        .Q(Q),
        .\gc0.count_reg[3] (rd_pntr_plus1),
        .\goreg_dm.dout_i_reg[36] (E),
        .m_aclk(m_aclk),
        .m_axi_wready(m_axi_wready),
        .m_axi_wvalid(m_axi_wvalid),
        .p_18_out(p_18_out),
        .ram_empty_fb_i_reg(\gr1.rfwft_n_0 ),
        .ram_rd_en_i(ram_rd_en_i),
        .\wr_pntr_bin_reg[3] (\wr_pntr_bin_reg[3] [3]));
  xilinx_axi_clock_converter_rd_status_flags_as_13 \gras.rsts 
       (.Q(Q[1]),
        .\gc0.count_d1_reg[2] (rpntr_n_4),
        .m_aclk(m_aclk),
        .p_18_out(p_18_out));
  xilinx_axi_clock_converter_rd_bin_cntr_14 rpntr
       (.D(D),
        .E(p_14_out),
        .Q({rd_pntr_plus1,\gc0.count_d1_reg[2] }),
        .\gpregsm1.curr_fwft_state_reg[1] (\gr1.rfwft_n_0 ),
        .m_aclk(m_aclk),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] (Q[1]),
        .ram_empty_fb_i_reg(rpntr_n_4),
        .\rd_pntr_gc_reg[1] (\rd_pntr_gc_reg[1] ),
        .\wr_pntr_bin_reg[2] (\wr_pntr_bin_reg[2] ),
        .\wr_pntr_bin_reg[3] (\wr_pntr_bin_reg[3] ));
endmodule

(* ORIG_REF_NAME = "rd_status_flags_as" *) 
module xilinx_axi_clock_converter_rd_status_flags_as
   (p_18_out,
    \gc0.count_d1_reg[2] ,
    s_aclk,
    Q);
  output p_18_out;
  input \gc0.count_d1_reg[2] ;
  input s_aclk;
  input [0:0]Q;

  wire [0:0]Q;
  wire \gc0.count_d1_reg[2] ;
  wire p_18_out;
  wire s_aclk;

  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_empty_fb_i_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(\gc0.count_d1_reg[2] ),
        .PRE(Q),
        .Q(p_18_out));
endmodule

(* ORIG_REF_NAME = "rd_status_flags_as" *) 
module xilinx_axi_clock_converter_rd_status_flags_as_13
   (p_18_out,
    \gc0.count_d1_reg[2] ,
    m_aclk,
    Q);
  output p_18_out;
  input \gc0.count_d1_reg[2] ;
  input m_aclk;
  input [0:0]Q;

  wire [0:0]Q;
  wire \gc0.count_d1_reg[2] ;
  wire m_aclk;
  wire p_18_out;

  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_empty_fb_i_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(\gc0.count_d1_reg[2] ),
        .PRE(Q),
        .Q(p_18_out));
endmodule

(* ORIG_REF_NAME = "rd_status_flags_as" *) 
module xilinx_axi_clock_converter_rd_status_flags_as_28
   (p_18_out,
    \gc0.count_d1_reg[2] ,
    m_aclk,
    Q);
  output p_18_out;
  input \gc0.count_d1_reg[2] ;
  input m_aclk;
  input [0:0]Q;

  wire [0:0]Q;
  wire \gc0.count_d1_reg[2] ;
  wire m_aclk;
  wire p_18_out;

  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_empty_fb_i_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(\gc0.count_d1_reg[2] ),
        .PRE(Q),
        .Q(p_18_out));
endmodule

(* ORIG_REF_NAME = "rd_status_flags_as" *) 
module xilinx_axi_clock_converter_rd_status_flags_as_43
   (p_18_out,
    \gc0.count_d1_reg[2] ,
    s_aclk,
    Q);
  output p_18_out;
  input \gc0.count_d1_reg[2] ;
  input s_aclk;
  input [0:0]Q;

  wire [0:0]Q;
  wire \gc0.count_d1_reg[2] ;
  wire p_18_out;
  wire s_aclk;

  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_empty_fb_i_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(\gc0.count_d1_reg[2] ),
        .PRE(Q),
        .Q(p_18_out));
endmodule

(* ORIG_REF_NAME = "rd_status_flags_as" *) 
module xilinx_axi_clock_converter_rd_status_flags_as_61
   (p_18_out,
    \gc0.count_d1_reg[2] ,
    m_aclk,
    Q);
  output p_18_out;
  input \gc0.count_d1_reg[2] ;
  input m_aclk;
  input [0:0]Q;

  wire [0:0]Q;
  wire \gc0.count_d1_reg[2] ;
  wire m_aclk;
  wire p_18_out;

  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_empty_fb_i_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(\gc0.count_d1_reg[2] ),
        .PRE(Q),
        .Q(p_18_out));
endmodule

(* ORIG_REF_NAME = "reset_blk_ramfifo" *) 
module xilinx_axi_clock_converter_reset_blk_ramfifo
   (rst_full_ff_i,
    rst_full_gen_i,
    Q,
    \gic0.gc0.count_d2_reg[0] ,
    m_aclk,
    inverted_reset,
    s_aclk);
  output rst_full_ff_i;
  output rst_full_gen_i;
  output [2:0]Q;
  output [1:0]\gic0.gc0.count_d2_reg[0] ;
  input m_aclk;
  input inverted_reset;
  input s_aclk;

  wire [2:0]Q;
  wire [1:0]\gic0.gc0.count_d2_reg[0] ;
  wire inverted_reset;
  wire m_aclk;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__1_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__1_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__1_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__1_n_0 ;
  wire rd_rst_asreg;
  wire rd_rst_asreg_d2;
  wire rst_d1;
  wire rst_d2;
  wire rst_d3;
  wire rst_full_gen_i;
  wire rst_rd_reg1;
  wire rst_rd_reg2;
  wire rst_wr_reg1;
  wire rst_wr_reg2;
  wire s_aclk;
  wire wr_rst_asreg;
  wire wr_rst_asreg_d2;

  assign rst_full_ff_i = rst_d2;
  FDCE #(
    .INIT(1'b0)) 
    \grstd1.grst_full.grst_f.RST_FULL_GEN_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(inverted_reset),
        .D(rst_d3),
        .Q(rst_full_gen_i));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_d1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rst_d1),
        .PRE(inverted_reset),
        .Q(rst_d2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d3_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rst_d2),
        .PRE(inverted_reset),
        .Q(rst_d3));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rd_rst_asreg),
        .Q(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .Q(rd_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__1 
       (.I0(rd_rst_asreg),
        .I1(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__1_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__1_n_0 ),
        .PRE(rst_rd_reg2),
        .Q(rd_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__1 
       (.I0(rd_rst_asreg),
        .I1(rd_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__1_n_0 ),
        .Q(Q[0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__1_n_0 ),
        .Q(Q[1]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__1_n_0 ),
        .Q(Q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_rd_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_rd_reg1),
        .PRE(inverted_reset),
        .Q(rst_rd_reg2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_wr_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rst_wr_reg1),
        .PRE(inverted_reset),
        .Q(rst_wr_reg2));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(wr_rst_asreg),
        .Q(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .Q(wr_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__1 
       (.I0(wr_rst_asreg),
        .I1(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__1_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__1_n_0 ),
        .PRE(rst_wr_reg2),
        .Q(wr_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__1 
       (.I0(wr_rst_asreg),
        .I1(wr_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__1_n_0 ),
        .Q(\gic0.gc0.count_d2_reg[0] [0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__1_n_0 ),
        .Q(\gic0.gc0.count_d2_reg[0] [1]));
endmodule

(* ORIG_REF_NAME = "reset_blk_ramfifo" *) 
module xilinx_axi_clock_converter_reset_blk_ramfifo_24
   (rst_full_ff_i,
    rst_full_gen_i,
    Q,
    \gic0.gc0.count_reg[0] ,
    s_aclk,
    inverted_reset,
    m_aclk);
  output rst_full_ff_i;
  output rst_full_gen_i;
  output [2:0]Q;
  output [1:0]\gic0.gc0.count_reg[0] ;
  input s_aclk;
  input inverted_reset;
  input m_aclk;

  wire [2:0]Q;
  wire [1:0]\gic0.gc0.count_reg[0] ;
  wire inverted_reset;
  wire m_aclk;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1_n_0 ;
  wire rd_rst_asreg;
  wire rd_rst_asreg_d1;
  wire rd_rst_asreg_d2;
  wire rst_d1;
  wire rst_d2;
  wire rst_d3;
  wire rst_full_gen_i;
  wire rst_rd_reg1;
  wire rst_rd_reg2;
  wire rst_wr_reg1;
  wire rst_wr_reg2;
  wire s_aclk;
  wire wr_rst_asreg;
  wire wr_rst_asreg_d1;
  wire wr_rst_asreg_d2;

  assign rst_full_ff_i = rst_d2;
  FDCE #(
    .INIT(1'b0)) 
    \grstd1.grst_full.grst_f.RST_FULL_GEN_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(inverted_reset),
        .D(rst_d3),
        .Q(rst_full_gen_i));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_d1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_d1),
        .PRE(inverted_reset),
        .Q(rst_d2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d3_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_d2),
        .PRE(inverted_reset),
        .Q(rst_d3));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rd_rst_asreg),
        .Q(rd_rst_asreg_d1),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rd_rst_asreg_d1),
        .Q(rd_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1 
       (.I0(rd_rst_asreg),
        .I1(rd_rst_asreg_d1),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1_n_0 ),
        .PRE(rst_rd_reg2),
        .Q(rd_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1 
       (.I0(rd_rst_asreg),
        .I1(rd_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1_n_0 ),
        .Q(Q[0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1_n_0 ),
        .Q(Q[1]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1_n_0 ),
        .Q(Q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_rd_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rst_rd_reg1),
        .PRE(inverted_reset),
        .Q(rst_rd_reg2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_wr_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_wr_reg1),
        .PRE(inverted_reset),
        .Q(rst_wr_reg2));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(wr_rst_asreg),
        .Q(wr_rst_asreg_d1),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(wr_rst_asreg_d1),
        .Q(wr_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1 
       (.I0(wr_rst_asreg),
        .I1(wr_rst_asreg_d1),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1_n_0 ),
        .PRE(rst_wr_reg2),
        .Q(wr_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1 
       (.I0(wr_rst_asreg),
        .I1(wr_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1_n_0 ),
        .Q(\gic0.gc0.count_reg[0] [0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1_n_0 ),
        .Q(\gic0.gc0.count_reg[0] [1]));
endmodule

(* ORIG_REF_NAME = "reset_blk_ramfifo" *) 
module xilinx_axi_clock_converter_reset_blk_ramfifo_39
   (rst_full_ff_i,
    \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ,
    rst_full_gen_i,
    Q,
    \gic0.gc0.count_d2_reg[0] ,
    m_aclk,
    s_aclk,
    s_aresetn);
  output rst_full_ff_i;
  output \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ;
  output rst_full_gen_i;
  output [2:0]Q;
  output [1:0]\gic0.gc0.count_d2_reg[0] ;
  input m_aclk;
  input s_aclk;
  input s_aresetn;

  wire [2:0]Q;
  wire [1:0]\gic0.gc0.count_d2_reg[0] ;
  wire m_aclk;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__3_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__3_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__3_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__3_n_0 ;
  wire rd_rst_asreg;
  wire rd_rst_asreg_d2;
  wire rst_d1;
  wire rst_d2;
  wire rst_d3;
  wire rst_full_gen_i;
  wire rst_rd_reg1;
  wire rst_rd_reg2;
  wire rst_wr_reg1;
  wire rst_wr_reg2;
  wire s_aclk;
  wire s_aresetn;
  wire wr_rst_asreg;
  wire wr_rst_asreg_d2;

  assign rst_full_ff_i = rst_d2;
  FDCE #(
    .INIT(1'b0)) 
    \grstd1.grst_full.grst_f.RST_FULL_GEN_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ),
        .D(rst_d3),
        .Q(rst_full_gen_i));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ),
        .Q(rst_d1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rst_d1),
        .PRE(\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ),
        .Q(rst_d2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d3_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rst_d2),
        .PRE(\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ),
        .Q(rst_d3));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rd_rst_asreg),
        .Q(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .Q(rd_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__3 
       (.I0(rd_rst_asreg),
        .I1(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__3_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__3_n_0 ),
        .PRE(rst_rd_reg2),
        .Q(rd_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__3 
       (.I0(rd_rst_asreg),
        .I1(rd_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__3_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__3_n_0 ),
        .Q(Q[0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__3_n_0 ),
        .Q(Q[1]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__3_n_0 ),
        .Q(Q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ),
        .Q(rst_rd_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_rd_reg1),
        .PRE(\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ),
        .Q(rst_rd_reg2));
  LUT1 #(
    .INIT(2'h1)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg1_i_1 
       (.I0(s_aresetn),
        .O(\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ),
        .Q(rst_wr_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rst_wr_reg1),
        .PRE(\ngwrdrst.grst.g7serrst.rst_wr_reg1_reg_0 ),
        .Q(rst_wr_reg2));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(wr_rst_asreg),
        .Q(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .Q(wr_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__3 
       (.I0(wr_rst_asreg),
        .I1(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__3_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__3_n_0 ),
        .PRE(rst_wr_reg2),
        .Q(wr_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__3 
       (.I0(wr_rst_asreg),
        .I1(wr_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__3_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__3_n_0 ),
        .Q(\gic0.gc0.count_d2_reg[0] [0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__3_n_0 ),
        .Q(\gic0.gc0.count_d2_reg[0] [1]));
endmodule

(* ORIG_REF_NAME = "reset_blk_ramfifo" *) 
module xilinx_axi_clock_converter_reset_blk_ramfifo_56
   (rst_full_ff_i,
    rst_full_gen_i,
    Q,
    \gic0.gc0.count_d2_reg[0] ,
    s_aclk,
    inverted_reset,
    m_aclk);
  output rst_full_ff_i;
  output rst_full_gen_i;
  output [2:0]Q;
  output [1:0]\gic0.gc0.count_d2_reg[0] ;
  input s_aclk;
  input inverted_reset;
  input m_aclk;

  wire [2:0]Q;
  wire [1:0]\gic0.gc0.count_d2_reg[0] ;
  wire inverted_reset;
  wire m_aclk;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__2_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__2_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__2_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__2_n_0 ;
  wire rd_rst_asreg;
  wire rd_rst_asreg_d2;
  wire rst_d1;
  wire rst_d2;
  wire rst_d3;
  wire rst_full_gen_i;
  wire rst_rd_reg1;
  wire rst_rd_reg2;
  wire rst_wr_reg1;
  wire rst_wr_reg2;
  wire s_aclk;
  wire wr_rst_asreg;
  wire wr_rst_asreg_d2;

  assign rst_full_ff_i = rst_d2;
  FDCE #(
    .INIT(1'b0)) 
    \grstd1.grst_full.grst_f.RST_FULL_GEN_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(inverted_reset),
        .D(rst_d3),
        .Q(rst_full_gen_i));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_d1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_d1),
        .PRE(inverted_reset),
        .Q(rst_d2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d3_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_d2),
        .PRE(inverted_reset),
        .Q(rst_d3));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rd_rst_asreg),
        .Q(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .Q(rd_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__2 
       (.I0(rd_rst_asreg),
        .I1(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__2_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__2_n_0 ),
        .PRE(rst_rd_reg2),
        .Q(rd_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__2 
       (.I0(rd_rst_asreg),
        .I1(rd_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__2_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__2_n_0 ),
        .Q(Q[0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__2_n_0 ),
        .Q(Q[1]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__2_n_0 ),
        .Q(Q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_rd_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rst_rd_reg1),
        .PRE(inverted_reset),
        .Q(rst_rd_reg2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_wr_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_wr_reg1),
        .PRE(inverted_reset),
        .Q(rst_wr_reg2));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(wr_rst_asreg),
        .Q(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .Q(wr_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__2 
       (.I0(wr_rst_asreg),
        .I1(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__2_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__2_n_0 ),
        .PRE(rst_wr_reg2),
        .Q(wr_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__2 
       (.I0(wr_rst_asreg),
        .I1(wr_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__2_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__2_n_0 ),
        .Q(\gic0.gc0.count_d2_reg[0] [0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__2_n_0 ),
        .Q(\gic0.gc0.count_d2_reg[0] [1]));
endmodule

(* ORIG_REF_NAME = "reset_blk_ramfifo" *) 
module xilinx_axi_clock_converter_reset_blk_ramfifo_9
   (rst_full_ff_i,
    rst_full_gen_i,
    Q,
    \gic0.gc0.count_d2_reg[0] ,
    s_aclk,
    inverted_reset,
    m_aclk);
  output rst_full_ff_i;
  output rst_full_gen_i;
  output [2:0]Q;
  output [1:0]\gic0.gc0.count_d2_reg[0] ;
  input s_aclk;
  input inverted_reset;
  input m_aclk;

  wire [2:0]Q;
  wire [1:0]\gic0.gc0.count_d2_reg[0] ;
  wire inverted_reset;
  wire m_aclk;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__0_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__0_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__0_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__0_n_0 ;
  wire rd_rst_asreg;
  wire rd_rst_asreg_d2;
  wire rst_d1;
  wire rst_d2;
  wire rst_d3;
  wire rst_full_gen_i;
  wire rst_rd_reg1;
  wire rst_rd_reg2;
  wire rst_wr_reg1;
  wire rst_wr_reg2;
  wire s_aclk;
  wire wr_rst_asreg;
  wire wr_rst_asreg_d2;

  assign rst_full_ff_i = rst_d2;
  FDCE #(
    .INIT(1'b0)) 
    \grstd1.grst_full.grst_f.RST_FULL_GEN_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(inverted_reset),
        .D(rst_d3),
        .Q(rst_full_gen_i));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_d1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_d1),
        .PRE(inverted_reset),
        .Q(rst_d2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d3_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_d2),
        .PRE(inverted_reset),
        .Q(rst_d3));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rd_rst_asreg),
        .Q(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .Q(rd_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__0 
       (.I0(rd_rst_asreg),
        .I1(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__0_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1__0_n_0 ),
        .PRE(rst_rd_reg2),
        .Q(rd_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__0 
       (.I0(rd_rst_asreg),
        .I1(rd_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__0_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__0_n_0 ),
        .Q(Q[0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__0_n_0 ),
        .Q(Q[1]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1__0_n_0 ),
        .Q(Q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg1_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_rd_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg2_reg 
       (.C(m_aclk),
        .CE(1'b1),
        .D(rst_rd_reg1),
        .PRE(inverted_reset),
        .Q(rst_rd_reg2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_wr_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_wr_reg1),
        .PRE(inverted_reset),
        .Q(rst_wr_reg2));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(wr_rst_asreg),
        .Q(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .Q(wr_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__0 
       (.I0(wr_rst_asreg),
        .I1(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__0_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1__0_n_0 ),
        .PRE(rst_wr_reg2),
        .Q(wr_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__0 
       (.I0(wr_rst_asreg),
        .I1(wr_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__0_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__0_n_0 ),
        .Q(\gic0.gc0.count_d2_reg[0] [0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1__0_n_0 ),
        .Q(\gic0.gc0.count_d2_reg[0] [1]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff
   (D,
    Q,
    s_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [3:0]D;
  input [3:0]Q;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]Q;
  wire [3:0]Q_reg;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire s_aclk;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_1
   (D,
    Q,
    m_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [3:0]D;
  input [3:0]Q;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]Q;
  wire [3:0]Q_reg;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_15
   (D,
    Q,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [3:0]D;
  input [3:0]Q;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]Q;
  wire [3:0]Q_reg;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_16
   (D,
    Q,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [3:0]D;
  input [3:0]Q;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]Q;
  wire [3:0]Q_reg;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire s_aclk;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_17
   (D,
    \Q_reg_reg[3]_0 ,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [3:0]D;
  input [3:0]\Q_reg_reg[3]_0 ;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]Q_reg;
  wire [3:0]\Q_reg_reg[3]_0 ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_18
   (D,
    \Q_reg_reg[3]_0 ,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [3:0]D;
  input [3:0]\Q_reg_reg[3]_0 ;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]Q_reg;
  wire [3:0]\Q_reg_reg[3]_0 ;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire s_aclk;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_19
   (out,
    \wr_pntr_bin_reg[2] ,
    D,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [0:0]out;
  output [2:0]\wr_pntr_bin_reg[2] ;
  input [3:0]D;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]D;
  wire [3:0]Q_reg;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire [2:0]\wr_pntr_bin_reg[2] ;

  assign out[0] = Q_reg[3];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[3]),
        .Q(Q_reg[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \wr_pntr_bin[0]_i_1__0 
       (.I0(Q_reg[1]),
        .I1(Q_reg[0]),
        .I2(Q_reg[3]),
        .I3(Q_reg[2]),
        .O(\wr_pntr_bin_reg[2] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \wr_pntr_bin[1]_i_1__0 
       (.I0(Q_reg[2]),
        .I1(Q_reg[1]),
        .I2(Q_reg[3]),
        .O(\wr_pntr_bin_reg[2] [1]));
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_bin[2]_i_1__0 
       (.I0(Q_reg[2]),
        .I1(Q_reg[3]),
        .O(\wr_pntr_bin_reg[2] [2]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_2
   (D,
    \Q_reg_reg[3]_0 ,
    s_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [3:0]D;
  input [3:0]\Q_reg_reg[3]_0 ;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]Q_reg;
  wire [3:0]\Q_reg_reg[3]_0 ;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire s_aclk;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_20
   (out,
    \rd_pntr_bin_reg[2] ,
    D,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [0:0]out;
  output [2:0]\rd_pntr_bin_reg[2] ;
  input [3:0]D;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]D;
  wire [3:0]Q_reg;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire [2:0]\rd_pntr_bin_reg[2] ;
  wire s_aclk;

  assign out[0] = Q_reg[3];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[3]),
        .Q(Q_reg[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \rd_pntr_bin[0]_i_1__0 
       (.I0(Q_reg[1]),
        .I1(Q_reg[0]),
        .I2(Q_reg[3]),
        .I3(Q_reg[2]),
        .O(\rd_pntr_bin_reg[2] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \rd_pntr_bin[1]_i_1__0 
       (.I0(Q_reg[2]),
        .I1(Q_reg[1]),
        .I2(Q_reg[3]),
        .O(\rd_pntr_bin_reg[2] [1]));
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_bin[2]_i_1__0 
       (.I0(Q_reg[2]),
        .I1(Q_reg[3]),
        .O(\rd_pntr_bin_reg[2] [2]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_3
   (D,
    \Q_reg_reg[3]_0 ,
    m_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [3:0]D;
  input [3:0]\Q_reg_reg[3]_0 ;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]Q_reg;
  wire [3:0]\Q_reg_reg[3]_0 ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_30
   (D,
    Q,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [3:0]D;
  input [3:0]Q;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]Q;
  wire [3:0]Q_reg;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_31
   (D,
    Q,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [3:0]D;
  input [3:0]Q;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]Q;
  wire [3:0]Q_reg;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire s_aclk;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_32
   (D,
    \Q_reg_reg[3]_0 ,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [3:0]D;
  input [3:0]\Q_reg_reg[3]_0 ;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]Q_reg;
  wire [3:0]\Q_reg_reg[3]_0 ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_33
   (D,
    \Q_reg_reg[3]_0 ,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [3:0]D;
  input [3:0]\Q_reg_reg[3]_0 ;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]Q_reg;
  wire [3:0]\Q_reg_reg[3]_0 ;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire s_aclk;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_34
   (out,
    \wr_pntr_bin_reg[2] ,
    D,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [0:0]out;
  output [2:0]\wr_pntr_bin_reg[2] ;
  input [3:0]D;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]D;
  wire [3:0]Q_reg;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire [2:0]\wr_pntr_bin_reg[2] ;

  assign out[0] = Q_reg[3];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[3]),
        .Q(Q_reg[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \wr_pntr_bin[0]_i_1 
       (.I0(Q_reg[1]),
        .I1(Q_reg[0]),
        .I2(Q_reg[3]),
        .I3(Q_reg[2]),
        .O(\wr_pntr_bin_reg[2] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \wr_pntr_bin[1]_i_1 
       (.I0(Q_reg[2]),
        .I1(Q_reg[1]),
        .I2(Q_reg[3]),
        .O(\wr_pntr_bin_reg[2] [1]));
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_bin[2]_i_1 
       (.I0(Q_reg[2]),
        .I1(Q_reg[3]),
        .O(\wr_pntr_bin_reg[2] [2]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_35
   (out,
    \rd_pntr_bin_reg[2] ,
    D,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [0:0]out;
  output [2:0]\rd_pntr_bin_reg[2] ;
  input [3:0]D;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]D;
  wire [3:0]Q_reg;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire [2:0]\rd_pntr_bin_reg[2] ;
  wire s_aclk;

  assign out[0] = Q_reg[3];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[3]),
        .Q(Q_reg[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \rd_pntr_bin[0]_i_1 
       (.I0(Q_reg[1]),
        .I1(Q_reg[0]),
        .I2(Q_reg[3]),
        .I3(Q_reg[2]),
        .O(\rd_pntr_bin_reg[2] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \rd_pntr_bin[1]_i_1 
       (.I0(Q_reg[2]),
        .I1(Q_reg[1]),
        .I2(Q_reg[3]),
        .O(\rd_pntr_bin_reg[2] [1]));
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_bin[2]_i_1 
       (.I0(Q_reg[2]),
        .I1(Q_reg[3]),
        .O(\rd_pntr_bin_reg[2] [2]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_4
   (out,
    \wr_pntr_bin_reg[2] ,
    D,
    s_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [0:0]out;
  output [2:0]\wr_pntr_bin_reg[2] ;
  input [3:0]D;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]D;
  wire [3:0]Q_reg;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire s_aclk;
  wire [2:0]\wr_pntr_bin_reg[2] ;

  assign out[0] = Q_reg[3];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[3]),
        .Q(Q_reg[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \wr_pntr_bin[0]_i_1__1 
       (.I0(Q_reg[1]),
        .I1(Q_reg[0]),
        .I2(Q_reg[3]),
        .I3(Q_reg[2]),
        .O(\wr_pntr_bin_reg[2] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \wr_pntr_bin[1]_i_1__1 
       (.I0(Q_reg[2]),
        .I1(Q_reg[1]),
        .I2(Q_reg[3]),
        .O(\wr_pntr_bin_reg[2] [1]));
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_bin[2]_i_1__1 
       (.I0(Q_reg[2]),
        .I1(Q_reg[3]),
        .O(\wr_pntr_bin_reg[2] [2]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_45
   (D,
    Q,
    s_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [3:0]D;
  input [3:0]Q;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]Q;
  wire [3:0]Q_reg;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire s_aclk;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_46
   (D,
    Q,
    m_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [3:0]D;
  input [3:0]Q;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]Q;
  wire [3:0]Q_reg;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_47
   (D,
    \Q_reg_reg[3]_0 ,
    s_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [3:0]D;
  input [3:0]\Q_reg_reg[3]_0 ;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]Q_reg;
  wire [3:0]\Q_reg_reg[3]_0 ;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire s_aclk;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_48
   (D,
    \Q_reg_reg[3]_0 ,
    m_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [3:0]D;
  input [3:0]\Q_reg_reg[3]_0 ;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]Q_reg;
  wire [3:0]\Q_reg_reg[3]_0 ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_49
   (out,
    \wr_pntr_bin_reg[2] ,
    D,
    s_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [0:0]out;
  output [2:0]\wr_pntr_bin_reg[2] ;
  input [3:0]D;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]D;
  wire [3:0]Q_reg;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire s_aclk;
  wire [2:0]\wr_pntr_bin_reg[2] ;

  assign out[0] = Q_reg[3];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[3]),
        .Q(Q_reg[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \wr_pntr_bin[0]_i_1__3 
       (.I0(Q_reg[1]),
        .I1(Q_reg[0]),
        .I2(Q_reg[3]),
        .I3(Q_reg[2]),
        .O(\wr_pntr_bin_reg[2] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \wr_pntr_bin[1]_i_1__3 
       (.I0(Q_reg[2]),
        .I1(Q_reg[1]),
        .I2(Q_reg[3]),
        .O(\wr_pntr_bin_reg[2] [1]));
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_bin[2]_i_1__3 
       (.I0(Q_reg[2]),
        .I1(Q_reg[3]),
        .O(\wr_pntr_bin_reg[2] [2]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_5
   (out,
    \rd_pntr_bin_reg[2] ,
    D,
    m_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [0:0]out;
  output [2:0]\rd_pntr_bin_reg[2] ;
  input [3:0]D;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]D;
  wire [3:0]Q_reg;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire [2:0]\rd_pntr_bin_reg[2] ;

  assign out[0] = Q_reg[3];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[3]),
        .Q(Q_reg[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \rd_pntr_bin[0]_i_1__1 
       (.I0(Q_reg[1]),
        .I1(Q_reg[0]),
        .I2(Q_reg[3]),
        .I3(Q_reg[2]),
        .O(\rd_pntr_bin_reg[2] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \rd_pntr_bin[1]_i_1__1 
       (.I0(Q_reg[2]),
        .I1(Q_reg[1]),
        .I2(Q_reg[3]),
        .O(\rd_pntr_bin_reg[2] [1]));
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_bin[2]_i_1__1 
       (.I0(Q_reg[2]),
        .I1(Q_reg[3]),
        .O(\rd_pntr_bin_reg[2] [2]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_50
   (out,
    \rd_pntr_bin_reg[2] ,
    D,
    m_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [0:0]out;
  output [2:0]\rd_pntr_bin_reg[2] ;
  input [3:0]D;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]D;
  wire [3:0]Q_reg;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire [2:0]\rd_pntr_bin_reg[2] ;

  assign out[0] = Q_reg[3];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[3]),
        .Q(Q_reg[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \rd_pntr_bin[0]_i_1__3 
       (.I0(Q_reg[1]),
        .I1(Q_reg[0]),
        .I2(Q_reg[3]),
        .I3(Q_reg[2]),
        .O(\rd_pntr_bin_reg[2] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \rd_pntr_bin[1]_i_1__3 
       (.I0(Q_reg[2]),
        .I1(Q_reg[1]),
        .I2(Q_reg[3]),
        .O(\rd_pntr_bin_reg[2] [1]));
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_bin[2]_i_1__3 
       (.I0(Q_reg[2]),
        .I1(Q_reg[3]),
        .O(\rd_pntr_bin_reg[2] [2]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_63
   (D,
    Q,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [3:0]D;
  input [3:0]Q;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]Q;
  wire [3:0]Q_reg;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(Q[3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_64
   (D,
    Q,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [3:0]D;
  input [3:0]Q;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]Q;
  wire [3:0]Q_reg;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire s_aclk;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(Q[3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_65
   (D,
    \Q_reg_reg[3]_0 ,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [3:0]D;
  input [3:0]\Q_reg_reg[3]_0 ;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]Q_reg;
  wire [3:0]\Q_reg_reg[3]_0 ;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(\Q_reg_reg[3]_0 [3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_66
   (D,
    \Q_reg_reg[3]_0 ,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [3:0]D;
  input [3:0]\Q_reg_reg[3]_0 ;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]Q_reg;
  wire [3:0]\Q_reg_reg[3]_0 ;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire s_aclk;

  assign D[3:0] = Q_reg;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(\Q_reg_reg[3]_0 [3]),
        .Q(Q_reg[3]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_67
   (out,
    \wr_pntr_bin_reg[2] ,
    D,
    m_aclk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] );
  output [0:0]out;
  output [2:0]\wr_pntr_bin_reg[2] ;
  input [3:0]D;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;

  wire [3:0]D;
  wire [3:0]Q_reg;
  wire m_aclk;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ;
  wire [2:0]\wr_pntr_bin_reg[2] ;

  assign out[0] = Q_reg[3];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(m_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[1] ),
        .D(D[3]),
        .Q(Q_reg[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \wr_pntr_bin[0]_i_1__2 
       (.I0(Q_reg[1]),
        .I1(Q_reg[0]),
        .I2(Q_reg[3]),
        .I3(Q_reg[2]),
        .O(\wr_pntr_bin_reg[2] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \wr_pntr_bin[1]_i_1__2 
       (.I0(Q_reg[2]),
        .I1(Q_reg[1]),
        .I2(Q_reg[3]),
        .O(\wr_pntr_bin_reg[2] [1]));
  LUT2 #(
    .INIT(4'h6)) 
    \wr_pntr_bin[2]_i_1__2 
       (.I0(Q_reg[2]),
        .I1(Q_reg[3]),
        .O(\wr_pntr_bin_reg[2] [2]));
endmodule

(* ORIG_REF_NAME = "synchronizer_ff" *) 
module xilinx_axi_clock_converter_synchronizer_ff_68
   (out,
    \rd_pntr_bin_reg[2] ,
    D,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] );
  output [0:0]out;
  output [2:0]\rd_pntr_bin_reg[2] ;
  input [3:0]D;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;

  wire [3:0]D;
  wire [3:0]Q_reg;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ;
  wire [2:0]\rd_pntr_bin_reg[2] ;
  wire s_aclk;

  assign out[0] = Q_reg[3];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[0]),
        .Q(Q_reg[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[1]),
        .Q(Q_reg[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[2]),
        .Q(Q_reg[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \Q_reg_reg[3] 
       (.C(s_aclk),
        .CE(1'b1),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[0] ),
        .D(D[3]),
        .Q(Q_reg[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \rd_pntr_bin[0]_i_1__2 
       (.I0(Q_reg[1]),
        .I1(Q_reg[0]),
        .I2(Q_reg[3]),
        .I3(Q_reg[2]),
        .O(\rd_pntr_bin_reg[2] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \rd_pntr_bin[1]_i_1__2 
       (.I0(Q_reg[2]),
        .I1(Q_reg[1]),
        .I2(Q_reg[3]),
        .O(\rd_pntr_bin_reg[2] [1]));
  LUT2 #(
    .INIT(4'h6)) 
    \rd_pntr_bin[2]_i_1__2 
       (.I0(Q_reg[2]),
        .I1(Q_reg[3]),
        .O(\rd_pntr_bin_reg[2] [2]));
endmodule

(* ORIG_REF_NAME = "wr_bin_cntr" *) 
module xilinx_axi_clock_converter_wr_bin_cntr
   (ram_full_i,
    \gic0.gc0.count_d2_reg[2]_0 ,
    \wr_pntr_gc_reg[3] ,
    Q,
    rst_full_gen_i,
    m_axi_bvalid,
    p_0_out,
    \rd_pntr_bin_reg[2] ,
    E,
    m_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] );
  output ram_full_i;
  output [2:0]\gic0.gc0.count_d2_reg[2]_0 ;
  output [3:0]\wr_pntr_gc_reg[3] ;
  input [3:0]Q;
  input rst_full_gen_i;
  input m_axi_bvalid;
  input p_0_out;
  input \rd_pntr_bin_reg[2] ;
  input [0:0]E;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;

  wire [0:0]E;
  wire [3:0]Q;
  wire [2:0]\gic0.gc0.count_d2_reg[2]_0 ;
  wire m_aclk;
  wire m_axi_bvalid;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;
  wire p_0_out;
  wire [3:3]p_8_out;
  wire [3:0]plusOp__1;
  wire ram_full_fb_i_i_2_n_0;
  wire ram_full_fb_i_i_3_n_0;
  wire ram_full_fb_i_i_4_n_0;
  wire ram_full_i;
  wire \rd_pntr_bin_reg[2] ;
  wire rst_full_gen_i;
  wire [3:0]\wr_pntr_gc_reg[3] ;
  wire [3:0]wr_pntr_plus2;

  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \gic0.gc0.count[0]_i_1 
       (.I0(wr_pntr_plus2[0]),
        .O(plusOp__1[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gic0.gc0.count[1]_i_1 
       (.I0(wr_pntr_plus2[0]),
        .I1(wr_pntr_plus2[1]),
        .O(plusOp__1[1]));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gic0.gc0.count[2]_i_1 
       (.I0(wr_pntr_plus2[1]),
        .I1(wr_pntr_plus2[0]),
        .I2(wr_pntr_plus2[2]),
        .O(plusOp__1[2]));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gic0.gc0.count[3]_i_1 
       (.I0(wr_pntr_plus2[2]),
        .I1(wr_pntr_plus2[0]),
        .I2(wr_pntr_plus2[1]),
        .I3(wr_pntr_plus2[3]),
        .O(plusOp__1[3]));
  FDPE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_d1_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .D(wr_pntr_plus2[0]),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .Q(\gic0.gc0.count_d2_reg[2]_0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[1]),
        .Q(\gic0.gc0.count_d2_reg[2]_0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[2]),
        .Q(\gic0.gc0.count_d2_reg[2]_0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[3]),
        .Q(p_8_out));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(\gic0.gc0.count_d2_reg[2]_0 [0]),
        .Q(\wr_pntr_gc_reg[3] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(\gic0.gc0.count_d2_reg[2]_0 [1]),
        .Q(\wr_pntr_gc_reg[3] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(\gic0.gc0.count_d2_reg[2]_0 [2]),
        .Q(\wr_pntr_gc_reg[3] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(p_8_out),
        .Q(\wr_pntr_gc_reg[3] [3]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__1[0]),
        .Q(wr_pntr_plus2[0]));
  FDPE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .D(plusOp__1[1]),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .Q(wr_pntr_plus2[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__1[2]),
        .Q(wr_pntr_plus2[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__1[3]),
        .Q(wr_pntr_plus2[3]));
  LUT6 #(
    .INIT(64'hFFFF800880088008)) 
    ram_full_fb_i_i_1
       (.I0(ram_full_fb_i_i_2_n_0),
        .I1(ram_full_fb_i_i_3_n_0),
        .I2(Q[1]),
        .I3(wr_pntr_plus2[1]),
        .I4(ram_full_fb_i_i_4_n_0),
        .I5(\rd_pntr_bin_reg[2] ),
        .O(ram_full_i));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_full_fb_i_i_2
       (.I0(wr_pntr_plus2[2]),
        .I1(Q[2]),
        .I2(wr_pntr_plus2[3]),
        .I3(Q[3]),
        .O(ram_full_fb_i_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'h00000900)) 
    ram_full_fb_i_i_3
       (.I0(wr_pntr_plus2[0]),
        .I1(Q[0]),
        .I2(rst_full_gen_i),
        .I3(m_axi_bvalid),
        .I4(p_0_out),
        .O(ram_full_fb_i_i_3_n_0));
  LUT3 #(
    .INIT(8'h09)) 
    ram_full_fb_i_i_4
       (.I0(p_8_out),
        .I1(Q[3]),
        .I2(rst_full_gen_i),
        .O(ram_full_fb_i_i_4_n_0));
endmodule

(* ORIG_REF_NAME = "wr_bin_cntr" *) 
module xilinx_axi_clock_converter_wr_bin_cntr_11
   (ram_full_i,
    Q,
    \wr_pntr_gc_reg[3] ,
    \rd_pntr_bin_reg[3] ,
    rst_full_gen_i,
    s_axi_wvalid,
    p_0_out,
    \rd_pntr_bin_reg[2] ,
    E,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] );
  output ram_full_i;
  output [2:0]Q;
  output [3:0]\wr_pntr_gc_reg[3] ;
  input [3:0]\rd_pntr_bin_reg[3] ;
  input rst_full_gen_i;
  input s_axi_wvalid;
  input p_0_out;
  input \rd_pntr_bin_reg[2] ;
  input [0:0]E;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;

  wire [0:0]E;
  wire [2:0]Q;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;
  wire p_0_out;
  wire [3:3]p_8_out;
  wire [3:0]plusOp__5;
  wire ram_full_fb_i_i_2__2_n_0;
  wire ram_full_fb_i_i_3__2_n_0;
  wire ram_full_fb_i_i_4__2_n_0;
  wire ram_full_i;
  wire \rd_pntr_bin_reg[2] ;
  wire [3:0]\rd_pntr_bin_reg[3] ;
  wire rst_full_gen_i;
  wire s_aclk;
  wire s_axi_wvalid;
  wire [3:0]\wr_pntr_gc_reg[3] ;
  wire [3:0]wr_pntr_plus2;

  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \gic0.gc0.count[0]_i_1__2 
       (.I0(wr_pntr_plus2[0]),
        .O(plusOp__5[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gic0.gc0.count[1]_i_1__2 
       (.I0(wr_pntr_plus2[0]),
        .I1(wr_pntr_plus2[1]),
        .O(plusOp__5[1]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gic0.gc0.count[2]_i_1__2 
       (.I0(wr_pntr_plus2[1]),
        .I1(wr_pntr_plus2[0]),
        .I2(wr_pntr_plus2[2]),
        .O(plusOp__5[2]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gic0.gc0.count[3]_i_1__2 
       (.I0(wr_pntr_plus2[2]),
        .I1(wr_pntr_plus2[0]),
        .I2(wr_pntr_plus2[1]),
        .I3(wr_pntr_plus2[3]),
        .O(plusOp__5[3]));
  FDPE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_d1_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .D(wr_pntr_plus2[0]),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[3]),
        .Q(p_8_out));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(Q[0]),
        .Q(\wr_pntr_gc_reg[3] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(Q[1]),
        .Q(\wr_pntr_gc_reg[3] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(Q[2]),
        .Q(\wr_pntr_gc_reg[3] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(p_8_out),
        .Q(\wr_pntr_gc_reg[3] [3]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__5[0]),
        .Q(wr_pntr_plus2[0]));
  FDPE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .D(plusOp__5[1]),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .Q(wr_pntr_plus2[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__5[2]),
        .Q(wr_pntr_plus2[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__5[3]),
        .Q(wr_pntr_plus2[3]));
  LUT6 #(
    .INIT(64'hFFFF800880088008)) 
    ram_full_fb_i_i_1__2
       (.I0(ram_full_fb_i_i_2__2_n_0),
        .I1(ram_full_fb_i_i_3__2_n_0),
        .I2(\rd_pntr_bin_reg[3] [1]),
        .I3(wr_pntr_plus2[1]),
        .I4(ram_full_fb_i_i_4__2_n_0),
        .I5(\rd_pntr_bin_reg[2] ),
        .O(ram_full_i));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_full_fb_i_i_2__2
       (.I0(wr_pntr_plus2[2]),
        .I1(\rd_pntr_bin_reg[3] [2]),
        .I2(wr_pntr_plus2[3]),
        .I3(\rd_pntr_bin_reg[3] [3]),
        .O(ram_full_fb_i_i_2__2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'h00000900)) 
    ram_full_fb_i_i_3__2
       (.I0(wr_pntr_plus2[0]),
        .I1(\rd_pntr_bin_reg[3] [0]),
        .I2(rst_full_gen_i),
        .I3(s_axi_wvalid),
        .I4(p_0_out),
        .O(ram_full_fb_i_i_3__2_n_0));
  LUT3 #(
    .INIT(8'h09)) 
    ram_full_fb_i_i_4__2
       (.I0(p_8_out),
        .I1(\rd_pntr_bin_reg[3] [3]),
        .I2(rst_full_gen_i),
        .O(ram_full_fb_i_i_4__2_n_0));
endmodule

(* ORIG_REF_NAME = "wr_bin_cntr" *) 
module xilinx_axi_clock_converter_wr_bin_cntr_26
   (ram_full_i,
    Q,
    \wr_pntr_gc_reg[3] ,
    \rd_pntr_bin_reg[3] ,
    rst_full_gen_i,
    s_axi_awvalid,
    p_0_out,
    \rd_pntr_bin_reg[2] ,
    E,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] );
  output ram_full_i;
  output [2:0]Q;
  output [3:0]\wr_pntr_gc_reg[3] ;
  input [3:0]\rd_pntr_bin_reg[3] ;
  input rst_full_gen_i;
  input s_axi_awvalid;
  input p_0_out;
  input \rd_pntr_bin_reg[2] ;
  input [0:0]E;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;

  wire [0:0]E;
  wire [2:0]Q;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;
  wire p_0_out;
  wire [3:3]p_8_out;
  wire [3:0]plusOp__4;
  wire ram_full_fb_i_i_2__1_n_0;
  wire ram_full_fb_i_i_3__1_n_0;
  wire ram_full_fb_i_i_4__1_n_0;
  wire ram_full_i;
  wire \rd_pntr_bin_reg[2] ;
  wire [3:0]\rd_pntr_bin_reg[3] ;
  wire rst_full_gen_i;
  wire s_aclk;
  wire s_axi_awvalid;
  wire [3:0]\wr_pntr_gc_reg[3] ;
  wire [3:0]wr_pntr_plus2;

  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \gic0.gc0.count[0]_i_1__1 
       (.I0(wr_pntr_plus2[0]),
        .O(plusOp__4[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gic0.gc0.count[1]_i_1__1 
       (.I0(wr_pntr_plus2[0]),
        .I1(wr_pntr_plus2[1]),
        .O(plusOp__4[1]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gic0.gc0.count[2]_i_1__1 
       (.I0(wr_pntr_plus2[1]),
        .I1(wr_pntr_plus2[0]),
        .I2(wr_pntr_plus2[2]),
        .O(plusOp__4[2]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gic0.gc0.count[3]_i_1__1 
       (.I0(wr_pntr_plus2[2]),
        .I1(wr_pntr_plus2[0]),
        .I2(wr_pntr_plus2[1]),
        .I3(wr_pntr_plus2[3]),
        .O(plusOp__4[3]));
  FDPE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_d1_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .D(wr_pntr_plus2[0]),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[3]),
        .Q(p_8_out));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(Q[0]),
        .Q(\wr_pntr_gc_reg[3] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(Q[1]),
        .Q(\wr_pntr_gc_reg[3] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(Q[2]),
        .Q(\wr_pntr_gc_reg[3] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(p_8_out),
        .Q(\wr_pntr_gc_reg[3] [3]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__4[0]),
        .Q(wr_pntr_plus2[0]));
  FDPE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .D(plusOp__4[1]),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .Q(wr_pntr_plus2[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__4[2]),
        .Q(wr_pntr_plus2[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__4[3]),
        .Q(wr_pntr_plus2[3]));
  LUT6 #(
    .INIT(64'hFFFF800880088008)) 
    ram_full_fb_i_i_1__1
       (.I0(ram_full_fb_i_i_2__1_n_0),
        .I1(ram_full_fb_i_i_3__1_n_0),
        .I2(\rd_pntr_bin_reg[3] [1]),
        .I3(wr_pntr_plus2[1]),
        .I4(ram_full_fb_i_i_4__1_n_0),
        .I5(\rd_pntr_bin_reg[2] ),
        .O(ram_full_i));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_full_fb_i_i_2__1
       (.I0(wr_pntr_plus2[2]),
        .I1(\rd_pntr_bin_reg[3] [2]),
        .I2(wr_pntr_plus2[3]),
        .I3(\rd_pntr_bin_reg[3] [3]),
        .O(ram_full_fb_i_i_2__1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h00000900)) 
    ram_full_fb_i_i_3__1
       (.I0(wr_pntr_plus2[0]),
        .I1(\rd_pntr_bin_reg[3] [0]),
        .I2(rst_full_gen_i),
        .I3(s_axi_awvalid),
        .I4(p_0_out),
        .O(ram_full_fb_i_i_3__1_n_0));
  LUT3 #(
    .INIT(8'h09)) 
    ram_full_fb_i_i_4__1
       (.I0(p_8_out),
        .I1(\rd_pntr_bin_reg[3] [3]),
        .I2(rst_full_gen_i),
        .O(ram_full_fb_i_i_4__1_n_0));
endmodule

(* ORIG_REF_NAME = "wr_bin_cntr" *) 
module xilinx_axi_clock_converter_wr_bin_cntr_41
   (ram_full_i,
    \gic0.gc0.count_d2_reg[2]_0 ,
    \wr_pntr_gc_reg[3] ,
    Q,
    rst_full_gen_i,
    m_axi_rvalid,
    p_0_out,
    \rd_pntr_bin_reg[2] ,
    E,
    m_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] );
  output ram_full_i;
  output [2:0]\gic0.gc0.count_d2_reg[2]_0 ;
  output [3:0]\wr_pntr_gc_reg[3] ;
  input [3:0]Q;
  input rst_full_gen_i;
  input m_axi_rvalid;
  input p_0_out;
  input \rd_pntr_bin_reg[2] ;
  input [0:0]E;
  input m_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;

  wire [0:0]E;
  wire [3:0]Q;
  wire [2:0]\gic0.gc0.count_d2_reg[2]_0 ;
  wire m_aclk;
  wire m_axi_rvalid;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;
  wire p_0_out;
  wire [3:3]p_8_out;
  wire [3:0]plusOp__3;
  wire ram_full_fb_i_i_2__0_n_0;
  wire ram_full_fb_i_i_3__0_n_0;
  wire ram_full_fb_i_i_4__0_n_0;
  wire ram_full_i;
  wire \rd_pntr_bin_reg[2] ;
  wire rst_full_gen_i;
  wire [3:0]\wr_pntr_gc_reg[3] ;
  wire [3:0]wr_pntr_plus2;

  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \gic0.gc0.count[0]_i_1__0 
       (.I0(wr_pntr_plus2[0]),
        .O(plusOp__3[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gic0.gc0.count[1]_i_1__0 
       (.I0(wr_pntr_plus2[0]),
        .I1(wr_pntr_plus2[1]),
        .O(plusOp__3[1]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gic0.gc0.count[2]_i_1__0 
       (.I0(wr_pntr_plus2[1]),
        .I1(wr_pntr_plus2[0]),
        .I2(wr_pntr_plus2[2]),
        .O(plusOp__3[2]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gic0.gc0.count[3]_i_1__0 
       (.I0(wr_pntr_plus2[2]),
        .I1(wr_pntr_plus2[0]),
        .I2(wr_pntr_plus2[1]),
        .I3(wr_pntr_plus2[3]),
        .O(plusOp__3[3]));
  FDPE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_d1_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .D(wr_pntr_plus2[0]),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .Q(\gic0.gc0.count_d2_reg[2]_0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[1]),
        .Q(\gic0.gc0.count_d2_reg[2]_0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[2]),
        .Q(\gic0.gc0.count_d2_reg[2]_0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[3]),
        .Q(p_8_out));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(\gic0.gc0.count_d2_reg[2]_0 [0]),
        .Q(\wr_pntr_gc_reg[3] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(\gic0.gc0.count_d2_reg[2]_0 [1]),
        .Q(\wr_pntr_gc_reg[3] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(\gic0.gc0.count_d2_reg[2]_0 [2]),
        .Q(\wr_pntr_gc_reg[3] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(p_8_out),
        .Q(\wr_pntr_gc_reg[3] [3]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[0] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__3[0]),
        .Q(wr_pntr_plus2[0]));
  FDPE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_reg[1] 
       (.C(m_aclk),
        .CE(E),
        .D(plusOp__3[1]),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .Q(wr_pntr_plus2[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[2] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__3[2]),
        .Q(wr_pntr_plus2[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[3] 
       (.C(m_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__3[3]),
        .Q(wr_pntr_plus2[3]));
  LUT6 #(
    .INIT(64'hFFFF800880088008)) 
    ram_full_fb_i_i_1__0
       (.I0(ram_full_fb_i_i_2__0_n_0),
        .I1(ram_full_fb_i_i_3__0_n_0),
        .I2(Q[1]),
        .I3(wr_pntr_plus2[1]),
        .I4(ram_full_fb_i_i_4__0_n_0),
        .I5(\rd_pntr_bin_reg[2] ),
        .O(ram_full_i));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_full_fb_i_i_2__0
       (.I0(wr_pntr_plus2[2]),
        .I1(Q[2]),
        .I2(wr_pntr_plus2[3]),
        .I3(Q[3]),
        .O(ram_full_fb_i_i_2__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'h00000900)) 
    ram_full_fb_i_i_3__0
       (.I0(wr_pntr_plus2[0]),
        .I1(Q[0]),
        .I2(rst_full_gen_i),
        .I3(m_axi_rvalid),
        .I4(p_0_out),
        .O(ram_full_fb_i_i_3__0_n_0));
  LUT3 #(
    .INIT(8'h09)) 
    ram_full_fb_i_i_4__0
       (.I0(p_8_out),
        .I1(Q[3]),
        .I2(rst_full_gen_i),
        .O(ram_full_fb_i_i_4__0_n_0));
endmodule

(* ORIG_REF_NAME = "wr_bin_cntr" *) 
module xilinx_axi_clock_converter_wr_bin_cntr_59
   (ram_full_i,
    Q,
    \wr_pntr_gc_reg[3] ,
    \rd_pntr_bin_reg[3] ,
    rst_full_gen_i,
    s_axi_arvalid,
    p_0_out,
    \rd_pntr_bin_reg[2] ,
    E,
    s_aclk,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] );
  output ram_full_i;
  output [2:0]Q;
  output [3:0]\wr_pntr_gc_reg[3] ;
  input [3:0]\rd_pntr_bin_reg[3] ;
  input rst_full_gen_i;
  input s_axi_arvalid;
  input p_0_out;
  input \rd_pntr_bin_reg[2] ;
  input [0:0]E;
  input s_aclk;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;

  wire [0:0]E;
  wire [2:0]Q;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;
  wire p_0_out;
  wire [3:3]p_8_out;
  wire [3:0]plusOp__7;
  wire ram_full_fb_i_i_2__3_n_0;
  wire ram_full_fb_i_i_3__3_n_0;
  wire ram_full_fb_i_i_4__3_n_0;
  wire ram_full_i;
  wire \rd_pntr_bin_reg[2] ;
  wire [3:0]\rd_pntr_bin_reg[3] ;
  wire rst_full_gen_i;
  wire s_aclk;
  wire s_axi_arvalid;
  wire [3:0]\wr_pntr_gc_reg[3] ;
  wire [3:0]wr_pntr_plus2;

  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \gic0.gc0.count[0]_i_1__3 
       (.I0(wr_pntr_plus2[0]),
        .O(plusOp__7[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gic0.gc0.count[1]_i_1__3 
       (.I0(wr_pntr_plus2[0]),
        .I1(wr_pntr_plus2[1]),
        .O(plusOp__7[1]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gic0.gc0.count[2]_i_1__3 
       (.I0(wr_pntr_plus2[1]),
        .I1(wr_pntr_plus2[0]),
        .I2(wr_pntr_plus2[2]),
        .O(plusOp__7[2]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gic0.gc0.count[3]_i_1__3 
       (.I0(wr_pntr_plus2[2]),
        .I1(wr_pntr_plus2[0]),
        .I2(wr_pntr_plus2[1]),
        .I3(wr_pntr_plus2[3]),
        .O(plusOp__7[3]));
  FDPE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_d1_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .D(wr_pntr_plus2[0]),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(wr_pntr_plus2[3]),
        .Q(p_8_out));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(Q[0]),
        .Q(\wr_pntr_gc_reg[3] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(Q[1]),
        .Q(\wr_pntr_gc_reg[3] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(Q[2]),
        .Q(\wr_pntr_gc_reg[3] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(p_8_out),
        .Q(\wr_pntr_gc_reg[3] [3]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__7[0]),
        .Q(wr_pntr_plus2[0]));
  FDPE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .D(plusOp__7[1]),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .Q(wr_pntr_plus2[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__7[2]),
        .Q(wr_pntr_plus2[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .CLR(\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .D(plusOp__7[3]),
        .Q(wr_pntr_plus2[3]));
  LUT6 #(
    .INIT(64'hFFFF800880088008)) 
    ram_full_fb_i_i_1__3
       (.I0(ram_full_fb_i_i_2__3_n_0),
        .I1(ram_full_fb_i_i_3__3_n_0),
        .I2(\rd_pntr_bin_reg[3] [1]),
        .I3(wr_pntr_plus2[1]),
        .I4(ram_full_fb_i_i_4__3_n_0),
        .I5(\rd_pntr_bin_reg[2] ),
        .O(ram_full_i));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_full_fb_i_i_2__3
       (.I0(wr_pntr_plus2[2]),
        .I1(\rd_pntr_bin_reg[3] [2]),
        .I2(wr_pntr_plus2[3]),
        .I3(\rd_pntr_bin_reg[3] [3]),
        .O(ram_full_fb_i_i_2__3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h00000900)) 
    ram_full_fb_i_i_3__3
       (.I0(wr_pntr_plus2[0]),
        .I1(\rd_pntr_bin_reg[3] [0]),
        .I2(rst_full_gen_i),
        .I3(s_axi_arvalid),
        .I4(p_0_out),
        .O(ram_full_fb_i_i_3__3_n_0));
  LUT3 #(
    .INIT(8'h09)) 
    ram_full_fb_i_i_4__3
       (.I0(p_8_out),
        .I1(\rd_pntr_bin_reg[3] [3]),
        .I2(rst_full_gen_i),
        .O(ram_full_fb_i_i_4__3_n_0));
endmodule

(* ORIG_REF_NAME = "wr_logic" *) 
module xilinx_axi_clock_converter_wr_logic
   (E,
    \gic0.gc0.count_d2_reg[2] ,
    m_axi_bready,
    \wr_pntr_gc_reg[3] ,
    m_aclk,
    rst_full_ff_i,
    Q,
    rst_full_gen_i,
    m_axi_bvalid,
    \rd_pntr_bin_reg[2] ,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] );
  output [0:0]E;
  output [2:0]\gic0.gc0.count_d2_reg[2] ;
  output m_axi_bready;
  output [3:0]\wr_pntr_gc_reg[3] ;
  input m_aclk;
  input rst_full_ff_i;
  input [3:0]Q;
  input rst_full_gen_i;
  input m_axi_bvalid;
  input \rd_pntr_bin_reg[2] ;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;

  wire [0:0]E;
  wire [3:0]Q;
  wire [2:0]\gic0.gc0.count_d2_reg[2] ;
  wire m_aclk;
  wire m_axi_bready;
  wire m_axi_bvalid;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;
  wire p_0_out;
  wire ram_full_i;
  wire \rd_pntr_bin_reg[2] ;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire [3:0]\wr_pntr_gc_reg[3] ;

  xilinx_axi_clock_converter_wr_status_flags_as \gwas.wsts 
       (.E(E),
        .m_aclk(m_aclk),
        .m_axi_bready(m_axi_bready),
        .m_axi_bvalid(m_axi_bvalid),
        .p_0_out(p_0_out),
        .ram_full_i(ram_full_i),
        .rst_full_ff_i(rst_full_ff_i));
  xilinx_axi_clock_converter_wr_bin_cntr wpntr
       (.E(E),
        .Q(Q),
        .\gic0.gc0.count_d2_reg[2]_0 (\gic0.gc0.count_d2_reg[2] ),
        .m_aclk(m_aclk),
        .m_axi_bvalid(m_axi_bvalid),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .p_0_out(p_0_out),
        .ram_full_i(ram_full_i),
        .\rd_pntr_bin_reg[2] (\rd_pntr_bin_reg[2] ),
        .rst_full_gen_i(rst_full_gen_i),
        .\wr_pntr_gc_reg[3] (\wr_pntr_gc_reg[3] ));
endmodule

(* ORIG_REF_NAME = "wr_logic" *) 
module xilinx_axi_clock_converter_wr_logic_23
   (E,
    Q,
    s_axi_awready,
    \wr_pntr_gc_reg[3] ,
    s_aclk,
    rst_full_ff_i,
    \rd_pntr_bin_reg[3] ,
    rst_full_gen_i,
    s_axi_awvalid,
    \rd_pntr_bin_reg[2] ,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] );
  output [0:0]E;
  output [2:0]Q;
  output s_axi_awready;
  output [3:0]\wr_pntr_gc_reg[3] ;
  input s_aclk;
  input rst_full_ff_i;
  input [3:0]\rd_pntr_bin_reg[3] ;
  input rst_full_gen_i;
  input s_axi_awvalid;
  input \rd_pntr_bin_reg[2] ;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;

  wire [0:0]E;
  wire [2:0]Q;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;
  wire p_0_out;
  wire ram_full_i;
  wire \rd_pntr_bin_reg[2] ;
  wire [3:0]\rd_pntr_bin_reg[3] ;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire s_aclk;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire [3:0]\wr_pntr_gc_reg[3] ;

  xilinx_axi_clock_converter_wr_status_flags_as_25 \gwas.wsts 
       (.E(E),
        .p_0_out(p_0_out),
        .ram_full_i(ram_full_i),
        .rst_full_ff_i(rst_full_ff_i),
        .s_aclk(s_aclk),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid));
  xilinx_axi_clock_converter_wr_bin_cntr_26 wpntr
       (.E(E),
        .Q(Q),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .p_0_out(p_0_out),
        .ram_full_i(ram_full_i),
        .\rd_pntr_bin_reg[2] (\rd_pntr_bin_reg[2] ),
        .\rd_pntr_bin_reg[3] (\rd_pntr_bin_reg[3] ),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk),
        .s_axi_awvalid(s_axi_awvalid),
        .\wr_pntr_gc_reg[3] (\wr_pntr_gc_reg[3] ));
endmodule

(* ORIG_REF_NAME = "wr_logic" *) 
module xilinx_axi_clock_converter_wr_logic_38
   (E,
    \gic0.gc0.count_d2_reg[2] ,
    m_axi_rready,
    \wr_pntr_gc_reg[3] ,
    m_aclk,
    rst_full_ff_i,
    Q,
    rst_full_gen_i,
    m_axi_rvalid,
    \rd_pntr_bin_reg[2] ,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] );
  output [0:0]E;
  output [2:0]\gic0.gc0.count_d2_reg[2] ;
  output m_axi_rready;
  output [3:0]\wr_pntr_gc_reg[3] ;
  input m_aclk;
  input rst_full_ff_i;
  input [3:0]Q;
  input rst_full_gen_i;
  input m_axi_rvalid;
  input \rd_pntr_bin_reg[2] ;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;

  wire [0:0]E;
  wire [3:0]Q;
  wire [2:0]\gic0.gc0.count_d2_reg[2] ;
  wire m_aclk;
  wire m_axi_rready;
  wire m_axi_rvalid;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;
  wire p_0_out;
  wire ram_full_i;
  wire \rd_pntr_bin_reg[2] ;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire [3:0]\wr_pntr_gc_reg[3] ;

  xilinx_axi_clock_converter_wr_status_flags_as_40 \gwas.wsts 
       (.E(E),
        .m_aclk(m_aclk),
        .m_axi_rready(m_axi_rready),
        .m_axi_rvalid(m_axi_rvalid),
        .p_0_out(p_0_out),
        .ram_full_i(ram_full_i),
        .rst_full_ff_i(rst_full_ff_i));
  xilinx_axi_clock_converter_wr_bin_cntr_41 wpntr
       (.E(E),
        .Q(Q),
        .\gic0.gc0.count_d2_reg[2]_0 (\gic0.gc0.count_d2_reg[2] ),
        .m_aclk(m_aclk),
        .m_axi_rvalid(m_axi_rvalid),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .p_0_out(p_0_out),
        .ram_full_i(ram_full_i),
        .\rd_pntr_bin_reg[2] (\rd_pntr_bin_reg[2] ),
        .rst_full_gen_i(rst_full_gen_i),
        .\wr_pntr_gc_reg[3] (\wr_pntr_gc_reg[3] ));
endmodule

(* ORIG_REF_NAME = "wr_logic" *) 
module xilinx_axi_clock_converter_wr_logic_54
   (E,
    Q,
    s_axi_arready,
    \wr_pntr_gc_reg[3] ,
    s_aclk,
    rst_full_ff_i,
    \rd_pntr_bin_reg[3] ,
    rst_full_gen_i,
    s_axi_arvalid,
    \rd_pntr_bin_reg[2] ,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] );
  output [0:0]E;
  output [2:0]Q;
  output s_axi_arready;
  output [3:0]\wr_pntr_gc_reg[3] ;
  input s_aclk;
  input rst_full_ff_i;
  input [3:0]\rd_pntr_bin_reg[3] ;
  input rst_full_gen_i;
  input s_axi_arvalid;
  input \rd_pntr_bin_reg[2] ;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;

  wire [0:0]E;
  wire [2:0]Q;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;
  wire p_0_out;
  wire ram_full_i;
  wire \rd_pntr_bin_reg[2] ;
  wire [3:0]\rd_pntr_bin_reg[3] ;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire s_aclk;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [3:0]\wr_pntr_gc_reg[3] ;

  xilinx_axi_clock_converter_wr_status_flags_as_58 \gwas.wsts 
       (.E(E),
        .p_0_out(p_0_out),
        .ram_full_i(ram_full_i),
        .rst_full_ff_i(rst_full_ff_i),
        .s_aclk(s_aclk),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid));
  xilinx_axi_clock_converter_wr_bin_cntr_59 wpntr
       (.E(E),
        .Q(Q),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .p_0_out(p_0_out),
        .ram_full_i(ram_full_i),
        .\rd_pntr_bin_reg[2] (\rd_pntr_bin_reg[2] ),
        .\rd_pntr_bin_reg[3] (\rd_pntr_bin_reg[3] ),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk),
        .s_axi_arvalid(s_axi_arvalid),
        .\wr_pntr_gc_reg[3] (\wr_pntr_gc_reg[3] ));
endmodule

(* ORIG_REF_NAME = "wr_logic" *) 
module xilinx_axi_clock_converter_wr_logic_8
   (E,
    Q,
    s_axi_wready,
    \wr_pntr_gc_reg[3] ,
    s_aclk,
    rst_full_ff_i,
    \rd_pntr_bin_reg[3] ,
    rst_full_gen_i,
    s_axi_wvalid,
    \rd_pntr_bin_reg[2] ,
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] );
  output [0:0]E;
  output [2:0]Q;
  output s_axi_wready;
  output [3:0]\wr_pntr_gc_reg[3] ;
  input s_aclk;
  input rst_full_ff_i;
  input [3:0]\rd_pntr_bin_reg[3] ;
  input rst_full_gen_i;
  input s_axi_wvalid;
  input \rd_pntr_bin_reg[2] ;
  input [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;

  wire [0:0]E;
  wire [2:0]Q;
  wire [0:0]\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ;
  wire p_0_out;
  wire ram_full_i;
  wire \rd_pntr_bin_reg[2] ;
  wire [3:0]\rd_pntr_bin_reg[3] ;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire s_aclk;
  wire s_axi_wready;
  wire s_axi_wvalid;
  wire [3:0]\wr_pntr_gc_reg[3] ;

  xilinx_axi_clock_converter_wr_status_flags_as_10 \gwas.wsts 
       (.E(E),
        .p_0_out(p_0_out),
        .ram_full_i(ram_full_i),
        .rst_full_ff_i(rst_full_ff_i),
        .s_aclk(s_aclk),
        .s_axi_wready(s_axi_wready),
        .s_axi_wvalid(s_axi_wvalid));
  xilinx_axi_clock_converter_wr_bin_cntr_11 wpntr
       (.E(E),
        .Q(Q),
        .\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] (\ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] ),
        .p_0_out(p_0_out),
        .ram_full_i(ram_full_i),
        .\rd_pntr_bin_reg[2] (\rd_pntr_bin_reg[2] ),
        .\rd_pntr_bin_reg[3] (\rd_pntr_bin_reg[3] ),
        .rst_full_gen_i(rst_full_gen_i),
        .s_aclk(s_aclk),
        .s_axi_wvalid(s_axi_wvalid),
        .\wr_pntr_gc_reg[3] (\wr_pntr_gc_reg[3] ));
endmodule

(* ORIG_REF_NAME = "wr_status_flags_as" *) 
module xilinx_axi_clock_converter_wr_status_flags_as
   (p_0_out,
    E,
    m_axi_bready,
    ram_full_i,
    m_aclk,
    rst_full_ff_i,
    m_axi_bvalid);
  output p_0_out;
  output [0:0]E;
  output m_axi_bready;
  input ram_full_i;
  input m_aclk;
  input rst_full_ff_i;
  input m_axi_bvalid;

  wire [0:0]E;
  wire m_aclk;
  wire m_axi_bready;
  wire m_axi_bvalid;
  wire p_0_out;
  wire ram_full_i;
  wire ram_full_i_reg_n_0;
  wire rst_full_ff_i;

  LUT2 #(
    .INIT(4'h2)) 
    \gic0.gc0.count_d1[3]_i_1 
       (.I0(m_axi_bvalid),
        .I1(p_0_out),
        .O(E));
  LUT1 #(
    .INIT(2'h1)) 
    m_axi_bready_INST_0
       (.I0(ram_full_i_reg_n_0),
        .O(m_axi_bready));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_fb_i_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(ram_full_i),
        .PRE(rst_full_ff_i),
        .Q(p_0_out));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_i_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(ram_full_i),
        .PRE(rst_full_ff_i),
        .Q(ram_full_i_reg_n_0));
endmodule

(* ORIG_REF_NAME = "wr_status_flags_as" *) 
module xilinx_axi_clock_converter_wr_status_flags_as_10
   (p_0_out,
    E,
    s_axi_wready,
    ram_full_i,
    s_aclk,
    rst_full_ff_i,
    s_axi_wvalid);
  output p_0_out;
  output [0:0]E;
  output s_axi_wready;
  input ram_full_i;
  input s_aclk;
  input rst_full_ff_i;
  input s_axi_wvalid;

  wire [0:0]E;
  wire p_0_out;
  wire ram_full_i;
  wire ram_full_i_reg_n_0;
  wire rst_full_ff_i;
  wire s_aclk;
  wire s_axi_wready;
  wire s_axi_wvalid;

  LUT2 #(
    .INIT(4'h2)) 
    \gic0.gc0.count_d1[3]_i_1__2 
       (.I0(s_axi_wvalid),
        .I1(p_0_out),
        .O(E));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_fb_i_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(ram_full_i),
        .PRE(rst_full_ff_i),
        .Q(p_0_out));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_i_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(ram_full_i),
        .PRE(rst_full_ff_i),
        .Q(ram_full_i_reg_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    s_axi_wready_INST_0
       (.I0(ram_full_i_reg_n_0),
        .O(s_axi_wready));
endmodule

(* ORIG_REF_NAME = "wr_status_flags_as" *) 
module xilinx_axi_clock_converter_wr_status_flags_as_25
   (p_0_out,
    E,
    s_axi_awready,
    ram_full_i,
    s_aclk,
    rst_full_ff_i,
    s_axi_awvalid);
  output p_0_out;
  output [0:0]E;
  output s_axi_awready;
  input ram_full_i;
  input s_aclk;
  input rst_full_ff_i;
  input s_axi_awvalid;

  wire [0:0]E;
  wire p_0_out;
  wire ram_full_i;
  wire ram_full_i__0;
  wire rst_full_ff_i;
  wire s_aclk;
  wire s_axi_awready;
  wire s_axi_awvalid;

  LUT2 #(
    .INIT(4'h2)) 
    \gic0.gc0.count_d1[3]_i_1__1 
       (.I0(s_axi_awvalid),
        .I1(p_0_out),
        .O(E));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_fb_i_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(ram_full_i),
        .PRE(rst_full_ff_i),
        .Q(p_0_out));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_i_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(ram_full_i),
        .PRE(rst_full_ff_i),
        .Q(ram_full_i__0));
  LUT1 #(
    .INIT(2'h1)) 
    s_axi_awready_INST_0
       (.I0(ram_full_i__0),
        .O(s_axi_awready));
endmodule

(* ORIG_REF_NAME = "wr_status_flags_as" *) 
module xilinx_axi_clock_converter_wr_status_flags_as_40
   (p_0_out,
    E,
    m_axi_rready,
    ram_full_i,
    m_aclk,
    rst_full_ff_i,
    m_axi_rvalid);
  output p_0_out;
  output [0:0]E;
  output m_axi_rready;
  input ram_full_i;
  input m_aclk;
  input rst_full_ff_i;
  input m_axi_rvalid;

  wire [0:0]E;
  wire m_aclk;
  wire m_axi_rready;
  wire m_axi_rvalid;
  wire p_0_out;
  wire ram_full_i;
  wire ram_full_i_reg_n_0;
  wire rst_full_ff_i;

  LUT2 #(
    .INIT(4'h2)) 
    \gic0.gc0.count_d1[3]_i_1__0 
       (.I0(m_axi_rvalid),
        .I1(p_0_out),
        .O(E));
  LUT1 #(
    .INIT(2'h1)) 
    m_axi_rready_INST_0
       (.I0(ram_full_i_reg_n_0),
        .O(m_axi_rready));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_fb_i_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(ram_full_i),
        .PRE(rst_full_ff_i),
        .Q(p_0_out));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_i_reg
       (.C(m_aclk),
        .CE(1'b1),
        .D(ram_full_i),
        .PRE(rst_full_ff_i),
        .Q(ram_full_i_reg_n_0));
endmodule

(* ORIG_REF_NAME = "wr_status_flags_as" *) 
module xilinx_axi_clock_converter_wr_status_flags_as_58
   (p_0_out,
    E,
    s_axi_arready,
    ram_full_i,
    s_aclk,
    rst_full_ff_i,
    s_axi_arvalid);
  output p_0_out;
  output [0:0]E;
  output s_axi_arready;
  input ram_full_i;
  input s_aclk;
  input rst_full_ff_i;
  input s_axi_arvalid;

  wire [0:0]E;
  wire p_0_out;
  wire ram_full_i;
  wire ram_full_i_reg_n_0;
  wire rst_full_ff_i;
  wire s_aclk;
  wire s_axi_arready;
  wire s_axi_arvalid;

  LUT2 #(
    .INIT(4'h2)) 
    \gic0.gc0.count_d1[3]_i_1__3 
       (.I0(s_axi_arvalid),
        .I1(p_0_out),
        .O(E));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_fb_i_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(ram_full_i),
        .PRE(rst_full_ff_i),
        .Q(p_0_out));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_i_reg
       (.C(s_aclk),
        .CE(1'b1),
        .D(ram_full_i),
        .PRE(rst_full_ff_i),
        .Q(ram_full_i_reg_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    s_axi_arready_INST_0
       (.I0(ram_full_i_reg_n_0),
        .O(s_axi_arready));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
