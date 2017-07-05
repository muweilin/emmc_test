
module xilin_ddr3_if_wrap
#(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 32,
    parameter AXI_ID_WIDTH   = 16
)
(
//input clock/reset from board
    input  logic              sys_clk_n,
    input  logic              sys_clk_p,
    input  logic              sys_rst_n,
    input  logic              clk_int,
    input  logic              rstn_i,
//input reset_n to interface logic
    input  logic              rstn,
//output clock/reset to other parts of SoC
    output logic              ui_clk,
    output logic              ui_rst,
    output logic              mmcm_locked,
//ddr3 sdram if
    output logic              init_calib_complete,

    inout  wire    [31:0]     ddr3_dq,
    inout  wire    [3:0]      ddr3_dqs_n,
    inout  wire    [3:0]      ddr3_dqs_p,
    output logic   [14:0]     ddr3_addr,
    output logic   [2:0]      ddr3_ba,
    output logic              ddr3_ras_n,
    output logic              ddr3_cas_n,
    output logic              ddr3_we_n,
    output logic              ddr3_reset_n,
    output logic              ddr3_ck_p,
    output logic              ddr3_ck_n,
    output logic              ddr3_cke,
    output logic              ddr3_cs_n,
    output logic   [3:0]      ddr3_dm,
    output logic              ddr3_odt,

    AXI_BUS.Slave             ddr3_axi_slave
);

wire [15 : 0] wire_aw_id    ;
wire [31 : 0] wire_aw_addr  ;
wire [7 : 0]  wire_aw_len   ;
wire [2 : 0]  wire_aw_size  ;
wire [1 : 0]  wire_aw_burst ;
wire   wire_aw_lock  ;
wire [3 : 0]  wire_aw_cache ;
wire [2 : 0]  wire_aw_prot  ;
wire [3 : 0]  wire_aw_region;
wire [3 : 0]  wire_aw_qos   ;
wire  wire_aw_valid ;
wire  wire_aw_ready ;
wire [31 : 0] wire_w_data   ;
wire [3 : 0]  wire_w_strb   ;
wire  wire_w_last   ;
wire  wire_w_valid  ;
wire  wire_w_ready  ;
wire [15 : 0] wire_b_id     ;
wire [1 : 0]  wire_b_resp   ;
wire  wire_b_valid  ;
wire  wire_b_ready  ;
wire [15 : 0] wire_ar_id    ;
wire [31 : 0] wire_ar_addr  ;
wire [7 : 0]  wire_ar_len   ;
wire [2 : 0]  wire_ar_size  ;
wire [1 : 0]  wire_ar_burst ;
wire   wire_ar_lock  ;
wire [3 : 0]  wire_ar_cache ;
wire [2 : 0]  wire_ar_prot  ;
wire [3 : 0]  wire_ar_region;
wire [3 : 0]  wire_ar_qos   ;
wire  wire_ar_valid ;
wire  wire_ar_ready ;
wire [15 : 0] wire_r_id     ;
wire [31 : 0] wire_r_data   ;
wire [1 : 0]  wire_r_resp   ;
wire  wire_r_last   ;
wire  wire_r_valid  ;
wire  wire_r_ready  ;

  //xilinx_axi_clock_convert
xilinx_axi_clock_converter xilinx_axi_clock_converter_inst (
  .s_axi_aclk(clk_int),          // input wire s_axi_aclk
  .s_axi_aresetn   (rstn_i    ),    // input wire s_axi_aresetn
  .s_axi_awid      (ddr3_axi_slave.aw_id       ),      // input wire [15 : 0] s_axi_awid
  .s_axi_awaddr    (ddr3_axi_slave.aw_addr     ),      // input wire [31 : 0] s_axi_awaddr
  .s_axi_awlen     (ddr3_axi_slave.aw_len      ),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize    (ddr3_axi_slave.aw_size     ),      // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst   (ddr3_axi_slave.aw_burst    ),      // input wire [1 : 0] s_axi_awburst
  .s_axi_awlock    (ddr3_axi_slave.aw_lock     ),      // input wire [0 : 0] s_axi_awlock
  .s_axi_awcache   (ddr3_axi_slave.aw_cache    ),      // input wire [3 : 0] s_axi_awcache
  .s_axi_awprot    (ddr3_axi_slave.aw_prot     ),      // input wire [2 : 0] s_axi_awprot
  .s_axi_awregion  (ddr3_axi_slave.aw_region   ),      // input wire [3 : 0] s_axi_awregion
  .s_axi_awqos     (ddr3_axi_slave.aw_qos      ),      // input wire [3 : 0] s_axi_awqos
  .s_axi_awvalid   (ddr3_axi_slave.aw_valid    ),    // input wire s_axi_awvalid
  .s_axi_awready   (ddr3_axi_slave.aw_ready    ),    // output wire s_axi_awready
  .s_axi_wdata     (ddr3_axi_slave.w_data      ),        // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb     (ddr3_axi_slave.w_strb      ),        // input wire [3 : 0] s_axi_wstrb
  .s_axi_wlast     (ddr3_axi_slave.w_last      ),        // input wire s_axi_wlast
  .s_axi_wvalid    (ddr3_axi_slave.w_valid     ),      // input wire s_axi_wvalid
  .s_axi_wready    (ddr3_axi_slave.w_ready     ),      // output wire s_axi_wready
  .s_axi_bid       (ddr3_axi_slave.b_id        ),        // output wire [15 : 0] s_axi_bid
  .s_axi_bresp     (ddr3_axi_slave.b_resp      ),        // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid    (ddr3_axi_slave.b_valid     ),      // output wire s_axi_bvalid
  .s_axi_bready    (ddr3_axi_slave.b_ready     ),      // input wire s_axi_bready
  .s_axi_arid      (ddr3_axi_slave.ar_id       ),      // input wire [15 : 0] s_axi_arid
  .s_axi_araddr    (ddr3_axi_slave.ar_addr     ),      // input wire [31 : 0] s_axi_araddr
  .s_axi_arlen     (ddr3_axi_slave.ar_len      ),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize    (ddr3_axi_slave.ar_size     ),      // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst   (ddr3_axi_slave.ar_burst    ),      // input wire [1 : 0] s_axi_arburst
  .s_axi_arlock    (ddr3_axi_slave.ar_lock     ),      // input wire [0 : 0] s_axi_arlock
  .s_axi_arcache   (ddr3_axi_slave.ar_cache    ),      // input wire [3 : 0] s_axi_arcache
  .s_axi_arprot    (ddr3_axi_slave.ar_prot     ),      // input wire [2 : 0] s_axi_arprot
  .s_axi_arregion  (ddr3_axi_slave.ar_region   ),      // input wire [3 : 0] s_axi_arregion
  .s_axi_arqos     (ddr3_axi_slave.ar_qos      ),      // input wire [3 : 0] s_axi_arqos
  .s_axi_arvalid   (ddr3_axi_slave.ar_valid    ),    // input wire s_axi_arvalid
  .s_axi_arready   (ddr3_axi_slave.ar_ready    ),    // output wire s_axi_arready
  .s_axi_rid       (ddr3_axi_slave.r_id        ),        // output wire [15 : 0] s_axi_rid
  .s_axi_rdata     (ddr3_axi_slave.r_data      ),        // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp     (ddr3_axi_slave.r_resp      ),        // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast     (ddr3_axi_slave.r_last      ),        // output wire s_axi_rlast
  .s_axi_rvalid    (ddr3_axi_slave.r_valid     ),      // output wire s_axi_rvalid
  .s_axi_rready    (ddr3_axi_slave.r_ready     ),      // input wire s_axi_rready
  .m_axi_aclk    (ui_clk),          // input wire m_axi_aclk
  .m_axi_aresetn (~ui_rst),    // input wire m_axi_aresetn
  .m_axi_awid    (wire_aw_id     ),          // output wire [15 : 0] m_axi_awid
  .m_axi_awaddr  (wire_aw_addr   ),      // output wire [31 : 0] m_axi_awaddr
  .m_axi_awlen   (wire_aw_len    ),        // output wire [7 : 0] m_axi_awlen
  .m_axi_awsize  (wire_aw_size   ),      // output wire [2 : 0] m_axi_awsize
  .m_axi_awburst (wire_aw_burst  ),    // output wire [1 : 0] m_axi_awburst
  .m_axi_awlock  (wire_aw_lock   ),      // output wire [0 : 0] m_axi_awlock
  .m_axi_awcache (wire_aw_cache  ),    // output wire [3 : 0] m_axi_awcache
  .m_axi_awprot  (wire_aw_prot   ),      // output wire [2 : 0] m_axi_awprot
  .m_axi_awregion( ),  // output wire [3 : 0] m_axi_awregion
  .m_axi_awqos   (wire_aw_qos    ),        // output wire [3 : 0] m_axi_awqos
  .m_axi_awvalid (wire_aw_valid  ),    // output wire m_axi_awvalid
  .m_axi_awready (wire_aw_ready  ),    // input wire m_axi_awready
  .m_axi_wdata   (wire_w_data   ),        // output wire [31 : 0] m_axi_wdata
  .m_axi_wstrb   (wire_w_strb   ),        // output wire [3 : 0] m_axi_wstrb
  .m_axi_wlast   (wire_w_last   ),        // output wire m_axi_wlast
  .m_axi_wvalid  (wire_w_valid  ),      // output wire m_axi_wvalid
  .m_axi_wready  (wire_w_ready  ),      // input wire m_axi_wready
  .m_axi_bid     (wire_b_id     ),            // input wire [15 : 0] m_axi_bid
  .m_axi_bresp   (wire_b_resp   ),        // input wire [1 : 0] m_axi_bresp
  .m_axi_bvalid  (wire_b_valid  ),      // input wire m_axi_bvalid
  .m_axi_bready  (wire_b_ready  ),      // output wire m_axi_bready
  .m_axi_arid    (wire_ar_id    ),          // output wire [15 : 0] m_axi_arid
  .m_axi_araddr  (wire_ar_addr  ),      // output wire [31 : 0] m_axi_araddr
  .m_axi_arlen   (wire_ar_len   ),        // output wire [7 : 0] m_axi_arlen
  .m_axi_arsize  (wire_ar_size  ),      // output wire [2 : 0] m_axi_arsize
  .m_axi_arburst (wire_ar_burst ),    // output wire [1 : 0] m_axi_arburst
  .m_axi_arlock  (wire_ar_lock  ),      // output wire [0 : 0] m_axi_arlock
  .m_axi_arcache (wire_ar_cache ),    // output wire [3 : 0] m_axi_arcache
  .m_axi_arprot  (wire_ar_prot  ),      // output wire [2 : 0] m_axi_arprot
  .m_axi_arregion(),  // output wire [3 : 0] m_axi_arregion
  .m_axi_arqos   (wire_ar_qos   ),        // output wire [3 : 0] m_axi_arqos
  .m_axi_arvalid (wire_ar_valid ),    // output wire m_axi_arvalid
  .m_axi_arready (wire_ar_ready ),    // input wire m_axi_arready
  .m_axi_rid     (wire_r_id    ),            // input wire [15 : 0] m_axi_rid
  .m_axi_rdata   (wire_r_data  ),        // input wire [31 : 0] m_axi_rdata
  .m_axi_rresp   (wire_r_resp  ),        // input wire [1 : 0] m_axi_rresp
  .m_axi_rlast   (wire_r_last  ),        // input wire m_axi_rlast
  .m_axi_rvalid  (wire_r_valid ),      // input wire m_axi_rvalid
  .m_axi_rready  (wire_r_ready )      // output wire m_axi_rready
);



  xilinx_ddr3_if xilinx_ddr3_if_inst (
    // Application interface ports
    .ui_clk                         (ui_clk                 ),  // output			ui_clk
    .ui_clk_sync_rst                (ui_rst                 ),  // output			ui_clk_sync_rst
    .mmcm_locked                    (mmcm_locked            ),  // output			mmcm_locked

    // Memory interface ports
    .ddr3_addr                      (ddr3_addr              ),  // output [14:0]		ddr3_addr
    .ddr3_ba                        (ddr3_ba                ),  // output [2:0]		ddr3_ba
    .ddr3_cas_n                     (ddr3_cas_n             ),  // output			ddr3_cas_n
    .ddr3_ck_n                      (ddr3_ck_n              ),  // output [0:0]		ddr3_ck_n
    .ddr3_ck_p                      (ddr3_ck_p              ),  // output [0:0]		ddr3_ck_p
    .ddr3_cke                       (ddr3_cke               ),  // output [0:0]		ddr3_cke
    .ddr3_ras_n                     (ddr3_ras_n             ),  // output			ddr3_ras_n
    .ddr3_reset_n                   (ddr3_reset_n           ),  // output			ddr3_reset_n
    .ddr3_we_n                      (ddr3_we_n              ),  // output			ddr3_we_n
    .ddr3_dq                        (ddr3_dq                ),  // inout [31:0]		ddr3_dq
    .ddr3_dqs_n                     (ddr3_dqs_n             ),  // inout [3:0]		ddr3_dqs_n
    .ddr3_dqs_p                     (ddr3_dqs_p             ),  // inout [3:0]		ddr3_dqs_p
    .ddr3_cs_n                      (ddr3_cs_n              ),  // output [0:0]		ddr3_cs_n
    .ddr3_dm                        (ddr3_dm                ),  // output [3:0]		ddr3_dm
    .ddr3_odt                       (ddr3_odt               ),  // output [0:0]		ddr3_odt

    .init_calib_complete            (init_calib_complete    ),  // output			init_calib_complete      

    .app_sr_req                     (1'b0                   ),  // input			app_sr_req
    .app_ref_req                    (1'b0                   ),  // input			app_ref_req
    .app_zq_req                     (1'b0                   ),  // input			app_zq_req
    .app_sr_active                  (  ),  // output			app_sr_active
    .app_ref_ack                    (  ),  // output			app_ref_ack
    .app_zq_ack                     (  ),  // output			app_zq_ack

    .aresetn                        (rstn                  ),  // input			axi resetn
    // Slave Interface Write Address Ports
    .s_axi_awid                     (wire_aw_id        ),  // input [15:0]			s_axi_awid
    .s_axi_awaddr                   (wire_aw_addr      ),  // input [29:0]			s_axi_awaddr
    .s_axi_awlen                    (wire_aw_len       ),  // input [7:0]			s_axi_awlen
    .s_axi_awsize                   (wire_aw_size      ),  // input [2:0]			s_axi_awsize
    .s_axi_awburst                  (wire_aw_burst     ),  // input [1:0]			s_axi_awburst
    .s_axi_awlock                   (wire_aw_lock      ),  // input [0:0]			s_axi_awlock
    .s_axi_awcache                  (wire_aw_cache     ),  // input [3:0]			s_axi_awcache
    .s_axi_awprot                   (wire_aw_prot      ),  // input [2:0]			s_axi_awprot
    .s_axi_awqos                    (wire_aw_qos      ),  // input [3:0]			s_axi_awqos
    .s_axi_awvalid                  (wire_aw_valid     ),  // input			s_axi_awvalid
    .s_axi_awready                  (wire_aw_ready     ),  // output			s_axi_awready
    // Slave Interface Write Data Por ts
    .s_axi_wdata                    (wire_w_data       ),  // input [31:0]			s_axi_wdata
    .s_axi_wstrb                    (wire_w_strb       ),  // input [3:0]			s_axi_wstrb
    .s_axi_wlast                    (wire_w_last       ),  // input			s_axi_wlast
    .s_axi_wvalid                   (wire_w_valid      ),  // input			s_axi_wvalid
    .s_axi_wready                   (wire_w_ready      ),  // output			s_axi_wready
    // Slave Interface Write Response Ports
    .s_axi_bid                      (wire_b_id      ),  // output [15:0]			s_axi_bid
    .s_axi_bresp                    (wire_b_resp    ),  // output [1:0]			s_axi_bresp
    .s_axi_bvalid                   (wire_b_valid   ),  // output			s_axi_bvalid
    .s_axi_bready                   (wire_b_ready   ),  // input			s_axi_bready
    // Slave Interface Read Address Ports
    .s_axi_arid                     (wire_ar_id    ),  // input [15:0]			s_axi_arid
    .s_axi_araddr                   (wire_ar_addr  ),  // input [29:0]			s_axi_araddr
    .s_axi_arlen                    (wire_ar_len   ),  // input [7:0]			s_axi_arlen
    .s_axi_arsize                   (wire_ar_size  ),  // input [2:0]			s_axi_arsize
    .s_axi_arburst                  (wire_ar_burst ),  // input [1:0]			s_axi_arburst
    .s_axi_arlock                   (wire_ar_lock  ),  // input [0:0]			s_axi_arlock
    .s_axi_arcache                  (wire_ar_cache ),  // input [3:0]			s_axi_arcache
    .s_axi_arprot                   (wire_ar_prot  ),  // input [2:0]			s_axi_arprot
    .s_axi_arqos                    (wire_ar_qos  ),  // input [3:0]			s_axi_arqos
    .s_axi_arvalid                  (wire_ar_valid ),  // input			s_axi_arvalid
    .s_axi_arready                  (wire_ar_ready ),  // output			s_axi_arready
    // Slave Interface Read Data Port s
    .s_axi_rid                      (wire_r_id      ),  // output [15:0]			s_axi_rid
    .s_axi_rdata                    (wire_r_data    ),  // output [31:0]			s_axi_rdata
    .s_axi_rresp                    (wire_r_resp    ),  // output [1:0]			s_axi_rresp
    .s_axi_rlast                    (wire_r_last    ),  // output			s_axi_rlast
    .s_axi_rvalid                   (wire_r_valid   ),  // output			s_axi_rvalid
    .s_axi_rready                   (wire_r_ready   ),  // input			s_axi_rready
    // System Clock Ports
    .sys_clk_p                      (sys_clk_p              ),  // input				sys_clk_p
    .sys_clk_n                      (sys_clk_n              ),  // input				sys_clk_n
    .sys_rst                        (sys_rst_n              )   // input sys_rst
    );

endmodule

