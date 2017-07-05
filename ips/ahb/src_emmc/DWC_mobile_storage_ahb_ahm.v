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
// Date             :        $Date: 2013/02/21 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_ahb_ahm.v#10 $
//--                                                                        
//--------------------------------------------------------------------------
//-- MODULE: DWC_mobile_storage_ahb_ahm
//--
//-- DESCRIPTION: This is the AHB Interface of the Subsystem.
//--              This contains the AHB Master port interfacing with the DMAC.
//--
//--              The DMA gives a request with the start-address and number of 
//--              beats to be performed for the data. The AHB master port takes care
//--              of performing the AHB transfer cycles (retry, splitting the burst, etc)
//--              and transfers the data. When the entire number of requested 
//--              beats is over, it indicates the end of transfer to DMA. 
//--
//--              The DMA should ensure that it should be able to accept all the 
//--              data as when output by the AHB during Read data-transfers 
//--              for the entire number of beats. Similarly, it should supply the
//--              data during write transfer as and when requested. The DMAC can
//--              prematurely end the burst write transfers by asserting and EOD signal.
//--              Hence this AHB master IF is optimised for this behaviour and does not 
//--              insert any BUSY cycles or accept any latency delay from DMA during
//--              burst transfers
//--              
//----------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_ahb_ahm (

              // Inputs from the AHB.
              
                hclk_i,
                hreset_n,

                hgrant_i,
                hready_i,
                hresp_i,
              
                hrdata_i,

                sca_data_endianness,

              // Outputs to the AHB.
              
                hreq_o,
                haddr_o,
                htrans_o,
                hwrite_o,
                hsize_o,
                hburst_o,

                hwdata_o,
              
              // Inputs from the MDC DMA.
              
                mdc_start_xfer,
                mdc_addr,
                mdc_rd_wrn,
                mdc_burst_count,
                mdc_xfer_size,
                mdc_fixed_burst,
              
                mdc_wdata,
                mdc_eof,

              // Outputs to the MDC DMA.
              
                ahm_rdata,

                ahm_rdata_push,
                ahm_wdata_pop,
                ahm_xfer_done,
                ahm_error, 

              // Scan Mode
                scan_mode
              );
 
// --------------------------
// Port Declarations. ------------------
// --------------------------

// Inputs from the AHB.
input                      hclk_i;          // AHB Master clock
input                      hreset_n;        // AHB Master Reset

input                      hgrant_i;        // AHB arbiter grant to master
input                      hready_i;        // Ready signal from AHB bus 
input [1:0]                hresp_i;         // Response from the slave during data transfer
input [`H_DATA_WIDTH-1:0]  hrdata_i;     // Read data from AHB Slave of width 64/32/16-bit

// Sideband input signal for Endian Mode Selection
input  sca_data_endianness; // Selects the endian mode

// Outputs to the AHB.
output                   hreq_o;          // Bus request to the Arbiter
output [`M_ADDR_WIDTH-1:0] haddr_o;         // Address during transaction
output [1:0]             htrans_o;        // AHB Transfer type from the Master 
output                   hwrite_o;        // When high indicates a write operation
output [2:0]             hsize_o;         // Indicates the size of the tranfer.
                                          // Values supported are 16/32/64 transfers only
output [2:0]             hburst_o;        // Indicate the AHB Burst type 
                                          // Supported values are SINGLE, INCR, INCR4/8/16
output [`H_DATA_WIDTH-1:0]  hwdata_o;     // Write data from the AHB master of width 64/32/16.

// Inputs from the DMA.
input                    mdc_start_xfer;  // Start transfer request from MDC module. It
                                          // should be 'high pulse to request start of
                                          // AHB transaction. This signal validates
                                          // mdc_addr, mdc_rd_wrn, mdc_burst_count,
                                          // mdc_xfer_size and mdc_fixed_burst signals.

input [`M_ADDR_WIDTH-1:0] mdc_addr;        // Start Address of the AHB transfer.
                                          // Need not be updated during burst transfers

input                    mdc_rd_wrn;      // Indication of read(`H) or write (`L)operation.
                                          // Should not change the transaction is completed

input [7:0]              mdc_burst_count; // Number of data Beats in current Burst 
                                          // Varies from all-0 = 1 beat to
                                          //             all-1 = 256 beats

input                    mdc_xfer_size;   // 1 - Indicates 32-bit xfer, 
                                          // 0 - 16/32/64 (depending on data-bus width)

input [`H_DATA_WIDTH-1:0]   mdc_wdata;    // Write data from the DMA of width 64/32/16. 
input                    mdc_eof;         // End of frame tranfer to the Host indication
                                          // during burst write transfers. It is used to
                                          // indicate premature end to requested burst-size.

input                    mdc_fixed_burst; // Indicates transfer-type to be used during burst
                                          // 1 - use fixed-bursts (INCR4/8/16); 0 = use INCR

// Outputs to the MDC DMA.

output                   ahm_wdata_pop;   // use to indicate acceptance of data for write transfer
                                          // MDC should put the next data at the end of this clock cycle
output [`H_DATA_WIDTH-1:0]  ahm_rdata;    // Read data to the DMA of width 64/32/16
output                   ahm_rdata_push;  // indicates valid data on ahm_rdata. MDC should accept it
                                          // immediately.

output                   ahm_xfer_done;   // Transfer done indication from AHB Master. The MDC can
                                          // only then start another transfer by asserting mdc_start_xfer

output                   ahm_error;       // The current AHB transaction resulted in an ERROR
                                          // response from the AHB slave. Asserted along with
                                          // ahm_xfer_done

input                    scan_mode;       // Scan Mode
// --------------------------
// Register Declarations for ports. ------------------
// --------------------------
reg                      hwrite_o;
reg [1:0]                htrans_o;        

`ifdef H_DATA_WIDTH_64
reg [2:0]                hsize_o;
`else
wire [2:0]               hsize_o;
`endif

reg                      hreq_o;
reg [2:0]                hburst_o;

reg                      ahm_error;
reg                      ahm_xfer_done; 

reg [`H_DATA_WIDTH-1:0]     hwdata_o;
reg                      ahm_rdata_push;

// --------------------------
// Wire Declarations for ports. ------------------
// --------------------------
wire [`M_ADDR_WIDTH-1:0]  haddr_o; 
wire                     ahm_wdata_pop;
wire [`H_DATA_WIDTH-1:0]    ahm_rdata;

// --------------------------
// Internal Register Declarations ------------------
// --------------------------
reg [2:0]                ahm_dma_state;      // Current state of AHM_DMA FSM
reg [2:0]                next_ahm_dma_state; // Next state of AHM_DMA FSM
reg [7:0]                ahm_state;          // Current state of the AHM_FSM
reg [7:0]                next_ahm_state;     // Next state of AHM_FSM

reg [8:0]                addr_count;         // Counts the number of valid address
                                             // cycles output by the AHB Master

reg [7:0]                xfer_count;         // Transfer count for the burst 
reg [7:0]                burst_size;         // Burst size for the current tranfer
reg [`H_DATA_WIDTH-1:0]     wdata_in_d1;        // Temp register to store mdc_wdata
reg [`H_DATA_WIDTH-1:0]     ahm_rdata_reg;      // Read data signal registered

`ifdef H_DATA_WIDTH_64
reg [`M_ADDR_WIDTH-1:3]   mx_addr; // Host Address at start of burst
reg [6:0]                haddr_lo; // Lower 10 bits of haddr_o
`endif

`ifdef H_DATA_WIDTH_32
reg [`M_ADDR_WIDTH-1:2]   mx_addr;
reg [7:0]                haddr_lo;
`endif

`ifdef H_DATA_WIDTH_16
reg [`M_ADDR_WIDTH-1:1]   mx_addr;
reg [8:0]                haddr_lo;
`endif

//reg [21:0]              haddr_hi;           // Upper 22 bits of haddr_o 
reg [`M_ADDR_WIDTH-11:0]   haddr_hi;           // Upper 22 bits of haddr_o 

reg                      incomplete_xfer;    // Tranfer not completed due to 
                                             // Err. cond like RETRY/SPLIT
                                             // or losing the ownership of bus
                                             // (removal of grant)

reg                      wdata_sel;          // Select signal to chose the 
                                             // mdc_wdata or wdata_in_d1
reg                      wdata_pop;          // Control signal to 
                                             // generate ahm_wdata_pop

reg                      prefetch_wdata_pop; // Used for generating wdata_pop 
                                             // in advance even if AHB bus is
                                             // not granted

reg                      mdc_eof_lat;        // Latched mdc_eof. 
reg                      mx_done_r;          // Registered mx_done
reg                      lost_bus;           // High when AHM has lost the bus 
                                             // during a successful Write transfer

// --------------------------
// Internal Wire Declarations. ------------------
// --------------------------

wire                     mx_start;           // Indication to start the AHM FSM
wire                     resp_ok;            // Indicates an OKAY response from slave
wire                     premature_end;      // Indicates that the AHB burst can
                                             // ended prematurely (for INCR bursts)
                                             // due to mdc_eof

wire                     mx_done;            // Indicates that AHM FSM has completed requested
                                             // transfer 

wire                     ld_retry_cmd;       // slave retry resp indication
wire                     load_mx_addr;       // Loads the initial values on the output
                                             // signals & internal counters on receiving
                                             // the hgrant from AHB bus

wire                     incr_mx_addr;       // increment signal at completion of each 
                                             // address cycles on AHB bus

wire                     tnf_finish;         // finished the current burst requested by DMA
wire [7:0]               lessbrstsize;       // indicates the maximum burst size that can
                                             // be initiated for a data transfer.

wire [8:0]               beat_size;          // Burst size in range 1-256
wire [8:0]               xfer_count_tmp;     // Intermediate xfer_count

wire                     rdata_lat;          // signal to register the hrdata_i read from AHB 
wire                     wdata_d1_lat;       // Enable signal to register mdc_wdata in temp register
wire                     hready_del;         // High when hready_i is low during XFER/LOSE_BUS states
wire                     wdata_ahm_lat;      // Enable signal to register data into hwdata_o bus 

wire [`H_DATA_WIDTH-1:0]    rdata_in;           // Endian manipulated read data from AHB 
wire [`H_DATA_WIDTH-1:0]    wdata_in;           // Endian manipulated write data from MDC 
wire [`H_DATA_WIDTH-1:0]    wdata_out;          // Selected data from wdata_in or wdata_in_d1

`define SINGLE 3'b000
`define INCR   3'b001
`define WRAP4  3'b010
`define INCR4  3'b011
`define WRAP8  3'b100
`define INCR8  3'b101
`define WRAP16 3'b110
`define INCR16 3'b111

`define IDLE  2'b00
`define BUSY  2'b01
`define NSEQ  2'b10
`define SEQ   2'b11

`define OK    2'b00
`define ERROR 2'b01
`define RETRY 2'b10
`define SPLIT 2'b11

// --------------------------
// Parameter Declarations. ------------------
// --------------------------

`define   DMA_IDLE     0
`define   DMA_START    1
`define   DMA_CHK      2

`define   AHM_IDLE     0
`define   AHM_REQ      1
`define  AHM_START     2
`define   AHM_XFER     3
`define   AHM_DONE     4
`define   AHM_ERR      5
`define   AHM_RETRY    6
`define   AHM_LOSE_BUS 7

// --------------------------
// AHB DMA FSM Combinatorial Block. ------------------
// --------------------------
// This FSM splits the DMA request into multiple AHB transfer commands as
// required. This FSM will also take care that any AHB burst transfer will
// no cross the 1KB boundary.

  always @(ahm_dma_state or mdc_start_xfer or 
           mx_done or ahm_state or tnf_finish or
           mdc_eof_lat)
  begin
  
    next_ahm_dma_state = 3'b000;
  
    case (1'b1)
  
    ahm_dma_state[`DMA_IDLE] : begin
      if (mdc_start_xfer) 
        next_ahm_dma_state[`DMA_START] = 1'b1;
      else
        next_ahm_dma_state[`DMA_IDLE] = 1'b1;
    end
     
    ahm_dma_state[`DMA_START]: begin
      if (mx_done & ahm_state[`AHM_ERR]) 
        next_ahm_dma_state[`DMA_IDLE] = 1'b1;
      else if (mx_done) 
        next_ahm_dma_state[`DMA_CHK] = 1'b1;
      else
        next_ahm_dma_state[`DMA_START] = 1'b1;
    end
  
    ahm_dma_state[`DMA_CHK]: begin
      if (tnf_finish | mdc_eof_lat) 
        next_ahm_dma_state[`DMA_IDLE] = 1'b1;
      else
        next_ahm_dma_state[`DMA_START] = 1'b1;
    end
  
    endcase
  
  end
  
  assign mx_start      = ((ahm_dma_state[`DMA_IDLE] | ahm_dma_state[`DMA_CHK]) &
                           next_ahm_dma_state[`DMA_START]);

  // --------------------------
  // AHB DMA FSM Registered Block. ------------------
  // --------------------------
  
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n) 
      ahm_dma_state <= 3'b001;
    else
      ahm_dma_state <= next_ahm_dma_state;
  end
  
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n) 
      ahm_xfer_done <= 1'b0;
    else
      if((mx_done_r & ahm_state[`AHM_IDLE] & mdc_rd_wrn) |
          (mx_done & next_ahm_state[`AHM_IDLE] & ~mdc_rd_wrn))
        ahm_xfer_done <= 1'b1;
      else
        ahm_xfer_done <= 1'b0;
  end
  

  // --------------------------
  // AHB MASTER FSM Combinatorial Block. ------------------
  // --------------------------
  // This FSM Controls the actual transfers on the AHB bus. 
  
  assign resp_ok       = hready_i & hresp_i == `OK;
  assign premature_end = mdc_eof & !mdc_fixed_burst & !mdc_rd_wrn & !wdata_sel;

  always @(ahm_state or mx_start or hgrant_i or 
           hready_i or addr_count or hresp_i or 
           premature_end or resp_ok or mdc_eof_lat or
           xfer_count or burst_size)
  begin
  
    next_ahm_state = 8'h00;
  
    case (1'b1)
  
    ahm_state[`AHM_IDLE]: begin
      if (mx_start) 
        next_ahm_state[`AHM_REQ] = 1'b1;
      else
        next_ahm_state[`AHM_IDLE] = 1'b1;
    end
  
    ahm_state[`AHM_REQ]: begin
      if (hgrant_i & hready_i) 
        next_ahm_state[`AHM_START] = 1'b1;
      else 
        next_ahm_state[`AHM_REQ] = 1'b1;
    end
  
    ahm_state[`AHM_START]: begin
      if (addr_count == 9'h1 & hready_i) 
        next_ahm_state[`AHM_DONE] = 1'b1;
      else if (addr_count != 9'h1 & hready_i & hgrant_i) 
        next_ahm_state[`AHM_XFER] = 1'b1;
      else if (hready_i & !hgrant_i)
        next_ahm_state[`AHM_LOSE_BUS] = 1'b1;
      else
        next_ahm_state[`AHM_START] = 1'b1;
    end
  
    ahm_state[`AHM_XFER]: begin
      if (hresp_i == `ERROR)
        next_ahm_state[`AHM_ERR] = 1'b1;
      else if (hresp_i[1])                // RETRY | SPLIT 
        next_ahm_state[`AHM_RETRY] = 1'b1;
      else if ((addr_count == 9'h1 | premature_end) & resp_ok)
        next_ahm_state[`AHM_DONE] = 1'b1;
      else if (resp_ok & !hgrant_i)
        next_ahm_state[`AHM_LOSE_BUS] = 1'b1;
      else
        next_ahm_state[`AHM_XFER] = 1'b1;
    end
  
    ahm_state[`AHM_DONE]: begin
      if (hresp_i == `ERROR)
        next_ahm_state[`AHM_ERR] = 1'b1;
      else if (hresp_i[1])                // RETRY | SPLIT 
        next_ahm_state[`AHM_RETRY] = 1'b1;
      else if (resp_ok & !mdc_eof_lat & (xfer_count != burst_size))
        next_ahm_state[`AHM_REQ] = 1'b1;
      else if (resp_ok)
        next_ahm_state[`AHM_IDLE] = 1'b1;
      else
        next_ahm_state[`AHM_DONE] = 1'b1;
    end
  
    ahm_state[`AHM_RETRY]: begin
      if (hready_i)
        next_ahm_state[`AHM_REQ] = 1'b1;
      else
        next_ahm_state[`AHM_RETRY] = 1'b1;
    end
  
    ahm_state[`AHM_LOSE_BUS]: begin
      if (hresp_i == `ERROR)
        next_ahm_state[`AHM_ERR] = 1'b1;
      else if (hresp_i[1])                 // RETRY/SPLIT
        next_ahm_state[`AHM_RETRY] = 1'b1;
      else if (resp_ok)
        next_ahm_state[`AHM_REQ] = 1'b1;
      else
        next_ahm_state[`AHM_LOSE_BUS] = 1'b1;
    end
  
    ahm_state[`AHM_ERR]: begin
      if(hready_i)
        next_ahm_state[`AHM_IDLE] = 1'b1;
      else
        next_ahm_state[`AHM_ERR] = 1'b1;
    end
  
    endcase
  
  end
  
  // --------------------------
  // AHB MASTER FSM Registered Block. ------------------
  // --------------------------
  
  always @(posedge hclk_i or negedge hreset_n)
  begin 
    if (!hreset_n)
      ahm_state <= 8'h01;
    else 
      ahm_state <= next_ahm_state;
  end
  
  // --------------------------
  // AHB MASTER Internal Logic Combinatorial Block. ------------------
  // --------------------------
  // This block generates the various signals used by the FSMs & Output logic 
  
  assign mx_done      = (ahm_state[`AHM_ERR] & hready_i) | 
                        (ahm_state[`AHM_DONE] & resp_ok);

  assign ld_retry_cmd = (ahm_state[`AHM_RETRY] & hready_i);
  assign load_mx_addr = ahm_state[`AHM_REQ] & hgrant_i & hready_i;
  assign incr_mx_addr = (ahm_state[`AHM_START] & hready_i) |
                        (ahm_state[`AHM_XFER] & resp_ok);

  assign tnf_finish   =  ~(|xfer_count);                  // when xfer_count == 0


`ifdef H_DATA_WIDTH_64
  assign lessbrstsize = (~mx_addr[9:3] > xfer_count) ?
                                (xfer_count) : (~mx_addr[9:3]);

  always @(tnf_finish or mdc_fixed_burst or lessbrstsize or
           xfer_count or mx_addr)
  begin
    if (tnf_finish)
      burst_size = 8'h00;
    else if (!mdc_fixed_burst)
      burst_size = lessbrstsize;
    else if ((xfer_count >= 8'hF) & ((~mx_addr[9:3]) >= 8'hF))
      burst_size = 8'h0F;
    else if ((xfer_count >= 8'h7) & ((~mx_addr[9:3]) >= 8'h7))
      burst_size = 8'h07;
    else if ((xfer_count >= 8'h3) & ((~mx_addr[9:3]) >= 8'h3))
      burst_size = 8'h03;
    else
      burst_size = 8'h00;
  end
`endif

`ifdef H_DATA_WIDTH_32
  assign lessbrstsize = (~mx_addr[9:2] > {1'b0, xfer_count}) ? 
                                (xfer_count) : (~mx_addr[8:2]);                 
  
  always @(tnf_finish or mdc_fixed_burst or lessbrstsize or
           xfer_count or mx_addr)
  begin 
    if (tnf_finish)
      burst_size = 8'h00;
    else if (!mdc_fixed_burst)
      burst_size = lessbrstsize ;
    else if ((xfer_count >= 8'hF) & ((~mx_addr[9:2]) >= 8'hF))
      burst_size = 8'h0F;
    else if ((xfer_count >= 8'h7) & ((~mx_addr[9:2]) >= 8'h7))
      burst_size = 8'h07;
    else if ((xfer_count >= 8'h3) & ((~mx_addr[9:2]) >= 8'h3))
      burst_size = 8'h03;
    else
      burst_size = 8'h00;
  end
`endif

`ifdef H_DATA_WIDTH_16
  assign lessbrstsize = (~mx_addr[9:1] > {1'b0, xfer_count}) ? 
                                (xfer_count) : (~mx_addr[8:1]);                 
  
  always @(tnf_finish or mdc_fixed_burst or lessbrstsize or
           xfer_count or mx_addr)
  begin 
    if (tnf_finish)
      burst_size = 8'h00;
    else if (!mdc_fixed_burst)
      burst_size = lessbrstsize ;
    else if ((xfer_count >= 8'hF) & ((~mx_addr[9:1]) >= 8'hF))
      burst_size = 8'h0F;
    else if ((xfer_count >= 8'h7) & ((~mx_addr[9:1]) >= 8'h7))
      burst_size = 8'h07;
    else if ((xfer_count >= 8'h3) & ((~mx_addr[9:1]) >= 8'h3))
      burst_size = 8'h03;
    else
      burst_size = 8'h00;
  end
`endif


  assign beat_size = {1'b0,burst_size} + 1;
  
  // --------------------------
  // AHB MASTER Internal Logic Registered Block. ------------------
  // --------------------------
  
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      mx_done_r    <= 1'b0;
    else 
      mx_done_r    <= mx_done;
  end

  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      ahm_error    <= 1'b0;
    else if (ahm_state[`AHM_ERR])
      ahm_error    <= hready_i;
    else
      ahm_error    <= 1'b0;
  end

  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      lost_bus    <= 1'b0;
    else if (ahm_state[`AHM_LOSE_BUS])
      lost_bus    <= resp_ok & !mdc_rd_wrn;
    else
      lost_bus    <= 1'b0;
  end

  assign xfer_count_tmp = {1'b0,xfer_count} - beat_size;

  // This gives the number of beats to be completed by the AHM I/F
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      xfer_count <= 8'b0000_0000;
    else if (mdc_start_xfer & mdc_eof & !mdc_rd_wrn) 
      xfer_count <= 8'b0000_0000;
    else if (mdc_start_xfer)
      xfer_count <= mdc_burst_count;
    else if ((mx_done & xfer_count != 0) & (xfer_count == burst_size))
      xfer_count <= 8'b0000_0000;
    else if (mx_done & xfer_count != 0)
      xfer_count <= xfer_count_tmp[7:0];
  end
  
  // This gives the start address of every AHB transfer
`ifdef H_DATA_WIDTH_64
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      mx_addr[`M_ADDR_WIDTH-1:3] <= 0;
    else if (mdc_start_xfer)
      mx_addr <= mdc_addr[`M_ADDR_WIDTH-1:3];
    else if (mx_done)
      mx_addr <= haddr_o[`M_ADDR_WIDTH-1:3];
  end
`endif

`ifdef H_DATA_WIDTH_32
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      mx_addr[`M_ADDR_WIDTH-1:2] <= 0;
    else if (mdc_start_xfer)
      mx_addr <= mdc_addr[`M_ADDR_WIDTH-1:2];
    else if (mx_done)
      mx_addr <= haddr_o[`M_ADDR_WIDTH-1:2];
  end
`endif

`ifdef H_DATA_WIDTH_16
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      //mx_addr[31:1] <= 31'h00000000;
      mx_addr[`M_ADDR_WIDTH-1:1] <= 0;
    else if (mdc_start_xfer)
      mx_addr <= mdc_addr[`M_ADDR_WIDTH-1:1];
    else if (mx_done)
      mx_addr <= haddr_o[`M_ADDR_WIDTH-1:1];
  end
`endif

  // This gives the number of address phases to be completed in the transfer cycle.
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      addr_count <= 9'h00;
    else if (load_mx_addr & !incomplete_xfer)
      addr_count <= beat_size;
    else if (ld_retry_cmd)
      addr_count <= addr_count + 1'b1;
    else if (incr_mx_addr)  
      addr_count <= addr_count - 1'b1;
  end
  
  // This is set high whenever a burst/single transfer is not completed due
  // to RETRY response or losing the AHB bus due to removal of hgrant.
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      incomplete_xfer <= 1'b0;
    else if ((ahm_state[`AHM_LOSE_BUS] | ahm_state[`AHM_RETRY]) & hready_i)
      incomplete_xfer <= 1'b1;
    else if ((ahm_state[`AHM_START] & hready_i) | ahm_state[`AHM_IDLE])
      incomplete_xfer <= 1'b0;
  end
  
  // --------------------------
  // AHB MASTER Control Logic Registered Block. ------------------
  // --------------------------
  
  // Address incrementer 

  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
    
    `ifdef H_DATA_WIDTH_64
      haddr_lo  <= 7'h00; 
    `endif
    `ifdef H_DATA_WIDTH_32
      haddr_lo  <= 8'h00; 
    `endif
    `ifdef H_DATA_WIDTH_16
      haddr_lo  <= 9'h000; 
    `endif

    else if (load_mx_addr & !incomplete_xfer)

    `ifdef H_DATA_WIDTH_64
      haddr_lo  <= mx_addr[9:3]; //32-bit
    `endif
    `ifdef H_DATA_WIDTH_32
      haddr_lo  <= mx_addr[9:2]; //32-bit
    `endif
    `ifdef H_DATA_WIDTH_16
      haddr_lo  <= mx_addr[9:1]; //32-bit
    `endif

    else if (incr_mx_addr)
      haddr_lo  <= haddr_lo  + 1'b1;
    else if (ld_retry_cmd)
      haddr_lo  <= haddr_lo  - 1'b1;
  end

  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      haddr_hi  <= 0;  
    else if (load_mx_addr & !incomplete_xfer)
      haddr_hi  <= mx_addr[`M_ADDR_WIDTH-1:10];
    else if (incr_mx_addr & (&haddr_lo))
      haddr_hi  <= haddr_hi  + 1'b1;
    else if (ld_retry_cmd & !(|haddr_lo))
      haddr_hi  <= haddr_hi  - 1'b1;
  end

   `ifdef H_DATA_WIDTH_64
    assign haddr_o = {haddr_hi, haddr_lo, 3'b000}; //64-bit
   `endif
   `ifdef H_DATA_WIDTH_32
    assign haddr_o = {haddr_hi, haddr_lo, 2'b00}; //32-bit
   `endif
    `ifdef H_DATA_WIDTH_16
    assign haddr_o = {haddr_hi, haddr_lo, 1'b0}; //16-bit
   `endif
 
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      hwrite_o <= 1'b0;
    else if (mdc_start_xfer)
      hwrite_o <= !mdc_rd_wrn;
  end

  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      htrans_o <= `IDLE;
    else if (load_mx_addr)
      htrans_o <= `NSEQ;
    else if ((hresp_i != `OK & !ahm_state[`AHM_START]) | 
             (!hgrant_i & hready_i) |                   // ERR/RETRY/SPLIT/LOSE_BUS for data phases
             ((ahm_state[`AHM_START] | ahm_state[`AHM_XFER]) &
               next_ahm_state[`AHM_DONE]))               //Last Xfer 
      htrans_o <= `IDLE;
    else if (ahm_state[`AHM_START] & (addr_count > 8'h1) & hready_i)
      htrans_o <= `SEQ;
  end

  `ifdef H_DATA_WIDTH_16
  assign hsize_o = 3'b001;   // 16-bit data-bus
  `endif

  `ifdef H_DATA_WIDTH_32
  assign hsize_o = 3'b010;   // 32-bit data-bus
  `endif

  `ifdef H_DATA_WIDTH_64
  // For 64-bit bus
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      hsize_o <= 3'b011;
    else if (mdc_start_xfer & !mdc_xfer_size)
      hsize_o <= 3'b011;
    else if (mdc_start_xfer & mdc_xfer_size)
      hsize_o <= 3'b010; //32-bit
  end
  `endif

  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      hreq_o <= 1'b0;
    else if ((ahm_state[`AHM_REQ] & hgrant_i & hready_i & burst_size == 8'd0) |
             (ahm_state[`AHM_START] & hburst_o != `INCR) | next_ahm_state[`AHM_ERR])
      hreq_o <= 1'b0;
    else if ((ahm_state[`AHM_IDLE] | ahm_state[`AHM_RETRY] | 
              ahm_state[`AHM_DONE] | ahm_state[`AHM_LOSE_BUS]) & next_ahm_state[`AHM_REQ])
      hreq_o <= 1'b1;
    else if (ahm_state[`AHM_XFER] & !next_ahm_state[`AHM_XFER])   // only for htrans == `INCR
      hreq_o <= 1'b0;
  end
  
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      hburst_o <= 3'b000;
    else if (load_mx_addr & incomplete_xfer) begin
      if (addr_count == 8'h1)
        hburst_o <= `SINGLE;
      else 
        hburst_o <= `INCR;
    end
    else if (load_mx_addr & !mdc_fixed_burst) begin
      if (burst_size == 8'h0)
        hburst_o <= `SINGLE;
      else 
        hburst_o <= `INCR;
    end
    else if (load_mx_addr & mdc_fixed_burst) begin
      case(burst_size)
        8'b00000011 : hburst_o <= `INCR4;
        8'b00000111 : hburst_o <= `INCR8;
        8'b00001111 : hburst_o <= `INCR16;
        default  : hburst_o <= `SINGLE;
      endcase
    end
  end
  
  // --------------------------
  // AHB MASTER Data Path Logic Combo / Reg. Block. ------------------
  // --------------------------
  
  assign rdata_lat     = (ahm_state[`AHM_DONE] | ahm_state[`AHM_XFER] | 
                          ahm_state[`AHM_LOSE_BUS]) & resp_ok & mdc_rd_wrn;
  
  assign hready_del    = (ahm_state[`AHM_XFER] | ahm_state[`AHM_LOSE_BUS]) & 
                          !hready_i & ahm_wdata_pop;

  assign wdata_d1_lat  = (((ahm_state[`AHM_XFER] | ahm_state[`AHM_LOSE_BUS] |
                            ahm_state[`AHM_DONE]) & hresp_i[1]) |   // RETRY/SPLIT
                          hready_del | lost_bus) & !wdata_sel;     // hready low in XFER/LOST bus

  assign wdata_ahm_lat =  ((ahm_state[`AHM_START] & hready_i & !incomplete_xfer) |
                          ((ahm_state[`AHM_XFER] | ahm_state[`AHM_DONE] | ahm_state[`AHM_LOSE_BUS]) & 
                            ~next_ahm_state[`AHM_IDLE] & resp_ok )) & !mdc_rd_wrn;

  assign ahm_wdata_pop  = !mdc_eof_lat & wdata_pop;

  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n) 
      mdc_eof_lat <= 1'b0;
    else
      if ( mdc_eof  & wdata_pop & ~mdc_eof_lat)
        mdc_eof_lat <= 1'b1;
      else
        if (ahm_dma_state[`DMA_IDLE] )
          mdc_eof_lat <= 1'b0;
  end
  

  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      wdata_sel <= 1'b0;
    else if (ld_retry_cmd | hready_del | lost_bus)
      wdata_sel <= 1'b1;
    else if (((ahm_state[`AHM_XFER] | ahm_state[`AHM_LOSE_BUS] | 
               ahm_state[`AHM_DONE]) & resp_ok) | ahm_state[`AHM_IDLE])
      wdata_sel <= 1'b0;
  end
  
  // This signal does an advance wdata_pop for first transfer
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      prefetch_wdata_pop <= 1'b0;
    else if (ahm_state[`AHM_IDLE])
      prefetch_wdata_pop <= 1'b0;
    else if (load_mx_addr & !mdc_rd_wrn)
      prefetch_wdata_pop <= 1'b1;
  end
  
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      wdata_pop <= 1'b0;
    else if (load_mx_addr & !mdc_rd_wrn & !prefetch_wdata_pop)
      wdata_pop <= 1'b1;
    else 
      wdata_pop <= (xfer_count != 0) & ((wdata_ahm_lat & (addr_count != 8'h1)) |
                   (ahm_state[`AHM_DONE] & resp_ok & !mdc_rd_wrn & ~next_ahm_state[`AHM_IDLE]));
  end
  
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      ahm_rdata_push <= 1'b0;
    else 
      ahm_rdata_push <= rdata_lat;
  end

  `ifdef H_DATA_WIDTH_64
   
  assign rdata_in = (!sca_data_endianness)? hrdata_i :
                                           {hrdata_i[7:0], hrdata_i[15:8], 
                                            hrdata_i[23:16], hrdata_i[31:24],
                                            hrdata_i[39:32], hrdata_i[47:40], 
                                            hrdata_i[55:48], hrdata_i[63:56]};

  assign wdata_in = (!sca_data_endianness)? mdc_wdata :
                                           {mdc_wdata[7:0], mdc_wdata[15:8], 
                                            mdc_wdata[23:16], mdc_wdata[31:24],
                                            mdc_wdata[39:32], mdc_wdata[47:40], 
                                            mdc_wdata[55:48], mdc_wdata[63:56]};
  `endif

  `ifdef H_DATA_WIDTH_32
  assign rdata_in = (!sca_data_endianness)? hrdata_i : 
                                           {hrdata_i[7:0], hrdata_i[15:8], 
                                           hrdata_i[23:16], hrdata_i[31:24]};

  assign wdata_in = (!sca_data_endianness)? mdc_wdata : 
                                           {mdc_wdata[7:0], mdc_wdata[15:8], 
                                           mdc_wdata[23:16], mdc_wdata[31:24]};
  `endif

  `ifdef H_DATA_WIDTH_16
  assign rdata_in = (!sca_data_endianness)? hrdata_i : 
                                           {hrdata_i[7:0], hrdata_i[15:8]};

  assign wdata_in = (!sca_data_endianness)? mdc_wdata : 
                                           {mdc_wdata[7:0], mdc_wdata[15:8]}; 
  `endif

  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      ahm_rdata_reg <= {`H_DATA_WIDTH{1'b0}};
    else if (rdata_lat)
      ahm_rdata_reg <= rdata_in;
  end

  assign ahm_rdata = ahm_rdata_reg;
  
  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      wdata_in_d1 <= {`H_DATA_WIDTH{1'b0}};
    else if (wdata_d1_lat & !mdc_rd_wrn)
      wdata_in_d1 <= wdata_in;
  end
  
  assign wdata_out = wdata_sel ? wdata_in_d1 : wdata_in;

  always @(posedge hclk_i or negedge hreset_n)
  begin
    if (!hreset_n)
      hwdata_o <= {`H_DATA_WIDTH{1'b0}};
    else if (((wdata_ahm_lat & !ahm_state[`AHM_START]) | 
             (wdata_pop & ahm_state[`AHM_START])) & !mdc_rd_wrn)
      hwdata_o <= wdata_out;
  end
  
endmodule

