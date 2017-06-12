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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_hiu_ctl.v $ 
// $Revision: #3 $
//
// Abstract  : This module is the Control Logic of the HIU.  It provides
// Address FIFO controls and data, Data FIFO controls and data, and Read
// Buffer controls.  It also generates a burst request if the burst is
// terminated due to AHB master BUSY.
//
//============================================================================

// Naming Conventions
// ------------------
// h*:    AMBA AHB signal
// hiu_*: HIU output to MIU
// miu_*: MIU output to HIU
// i_*:   input
// o_*:   output
// a_*:   AHB address phase signal
// d_*:   AHB data    phase signal
// fd_*:  AHB data    phase signal (flip-flop)
// r_*:   HIU request phase signal
// fr_*:  HIU request phase signal (flip-flop)
// f_*:   flip-flop
// n_*:   D input to flop
// m_*:   wire
// S_*:   FSM state name
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl_hiu_ctl( hclk,                
                          hresetn,              
                          hsel_mem,            
                          hsel_reg,            
                          htrans,              
                          hwrite,              
                          hsize,               
                          hburst,              
                          hready,           
                          hready_resp,              
                          hresp,               
                          haddr,               
                          hwdata,              
                                               
                          hiu_burst_size,      
                          hiu_wrap_burst,
                          hiu_rw,
                          hiu_terminate,       

                          miu_burst_done,      
                          miu_push_n,          
                          miu_pop_n,           
                                               
                          o_two_to_one,
                          o_double,
                          big_endian,
                                               
                          o_af_push1_n,     
                          o_af_push2_n,     
                          o_af_data1,       
                          o_af_data2,       
                          i_af_ready,       
                          i_af_new_req,     
                          i_af_dummy_req,   
                                               
                          o_df_push_n,      
                          o_df_data,        
                          i_df_ready,       
                          i_df_uf_alert, 
                          i_df_wr_term,     
                                               
                          o_rb_start,        
                          o_rb_done,         
                          o_rb_busy,         
                          o_rb_pop_n,        
                          o_rb_sel_buf,      
                          i_rb_ready,        
                          i_rb_overflow );   

   //-------------------------------------------------------------------------
   // I/O
   //-------------------------------------------------------------------------
   
   input                        hclk;            // AMBA HCLK
   input                        hresetn;         // AMBA HRESETn
   input                        hsel_mem;        // AMBA HSELm (mem select)
   input                        hsel_reg;        // AMBA HSELr (reg select)
   input [1:0]                  htrans;          // AMBA HTRANS
   input                        hwrite;          // AMBA HWRITE
   input [2:0]                  hsize;           // AMBA HSIZE
   input [2:0]                  hburst;          // AMBA HBURST
   input                        hready;          // AMBA HREADY
   output                       hready_resp;     // AMBA HREADYOUT
   output [1:0]                 hresp;           // AMBA HRESP
   input [`H_ADDR_WIDTH-1:0]    haddr;           // AMBA HADDR
   input [`H_DATA_WIDTH-1:0]    hwdata;          // AMBA HWDATA
                                                
   input [5:0]                  hiu_burst_size;  // Burst size, 0: unspec.
   input                        hiu_wrap_burst;  // Wrapping burst flag
   input                        hiu_rw;          // Read/write, 0: write
   output                       hiu_terminate;   // Early burst termination
                                                
   input                        miu_burst_done;  // Mem/reg access done
   input                        miu_push_n;      // Push mem/reg read  data
   input                        miu_pop_n;       // Pop  mem/reg write data
                                                
   output                       o_two_to_one;    // 2:1 mode
   output                       o_double;        // Double push flag
   input                        big_endian;      // Big endian mode
                                                
   output                       o_af_push1_n;    // Addr FIFO push req
   output                       o_af_push2_n;    // Addr FIFO push req
   output [`AFIFO_IN_WIDTH-1:0] o_af_data1;      // Addr FIFO data1 to push
   output [`AFIFO_IN_WIDTH-1:0] o_af_data2;      // Addr FIFO data2 to push
   input                        i_af_ready;      // Addr FIFO ready
   input                        i_af_new_req;    // New mem/reg request
   input                        i_af_dummy_req;  // Dummy request
                                                
   output                       o_df_push_n;     // Data FIFO push request
   output [`DFIFO_IN_WIDTH-1:0] o_df_data;       // Data FIFO data to push
   input                        i_df_ready;      // Data FIFO ready
   input                        i_df_uf_alert;   // Data FIFO uflow alert
   input                        i_df_wr_term;    // Early write termination
                                                
   output                       o_rb_start;      // Read burst start
   output                       o_rb_done;       // Read burst done
   output                       o_rb_busy;       // AMBA BUSY
   output                       o_rb_pop_n;      // Read buffer pop request
   output                       o_rb_sel_buf;    // Read buffer data select
   input                        i_rb_ready;      // Read buffer ready
   input                        i_rb_overflow;   // Read buffer overflow

   //-------------------------------------------------------------------------
   // AMBA definitions - local parameters
   //-------------------------------------------------------------------------

   parameter                 IDLE   = 2'b00,      // AMBA HTRANS
                             BUSY   = 2'b01,
                             NONSEQ = 2'b10,
                             SEQ    = 2'b11;

   parameter                 SINGLE = 3'b000,     // AMBA HBURST
                             INCR   = 3'b001,
                             WRAP4  = 3'b010,
                             INCR4  = 3'b011,
                             WRAP8  = 3'b100,
                             INCR8  = 3'b101,
                             WRAP16 = 3'b110,
                             INCR16 = 3'b111;
   parameter                 BY_TE       = 3'b000, //   8 bits, AMBA HSIZE
                             HALFWORD   = 3'b001, //  16 bits
                             WORD       = 3'b010, //  32 bits
                             DOUBLEWORD = 3'b011, //  64 bits
                             FOURWORD   = 3'b100; // 128 bits

   parameter                 OKAY  = 2'b00,       // AMBA HRESP
                             ERROR = 2'b01,
                             RETRY = 2'b10,
                             SPLIT = 2'b11;

   //-------------------------------------------------------------------------
   // BUSY handling FSM - local parameters
   //-------------------------------------------------------------------------
   
   parameter                 S_BH_IDLE      = 3'h0, // idle
                             S_BH_BURST     = 3'h1, // burst is going
                             S_BH_UNDERFLOW = 3'h2, // underflow occurred
                             S_BH_OVERFLOW  = 3'h3, // overflow  occurred
                             S_BH_PASS_DATA = 3'h4; // wait for pass data

   //-------------------------------------------------------------------------
   // initial values - local parameters
   //-------------------------------------------------------------------------

   parameter INI_SDR_WIDTH = `S_DATA_WIDTH == 16 ? 2'b00 :
                             `S_DATA_WIDTH == 32 ? 2'b01 :
                             `S_DATA_WIDTH == 64 ? 2'b10 :
                           /*`S_DATA_WIDTH ==128*/ 2'b11;

   parameter INI_DDR_WIDTH = `S_DATA_WIDTH ==  8 ? 2'b00 :
                             `S_DATA_WIDTH == 16 ? 2'b01 :
                             `S_DATA_WIDTH == 32 ? 2'b10 :
                           /*`S_DATA_WIDTH == 64*/ 2'b11;

   parameter INI_AHB_WIDTH =  `H_DATA_WIDTH == 32 ? 2'b01 :
                              `H_DATA_WIDTH == 64 ? 2'b10 :
                            /*`H_DATA_WIDTH ==128*/ 2'b11;
    
   parameter INI_DATA_WIDTH = 
             `DYNAMIC_RAM_TYPE == 6 ? INI_AHB_WIDTH : // no DRAM
             `DYNAMIC_RAM_TYPE == 1 ? INI_DDR_WIDTH : // DDR
                                      INI_SDR_WIDTH;  // SDR,SF

   parameter INI_COL_WIDTH = `S_COL_ADDR_WIDTH - 1'b1;

   //-------------------------------------------------------------------------
   // AMBA aliases
   //-------------------------------------------------------------------------

   wire                      a_idle;          // AMBA IDLE
   wire                      a_busy;          // AMBA BUSY
   wire                      a_nonseq;        // AMBA NONSEQ
   wire                      a_seq;           // AMBA SEQ
   wire                      a_wrap;          // AMBA WRAPs
   wire                      a_incr;          // AMBA INCR
   reg                       fd_incr;         // (data phase)
   reg                       fd_non_single;   // (04/22/2004)
   reg [3:0]                 fd_haddr;        // AMBA HADDR[3:0] (data phase)

   // 01/20/03

   reg                       fd_hsel_mem;     // HSELmem (data phase)
   wire                      a_lost_hsel_mem; // lost HSELmem
   
   //-------------------------------------------------------------------------
   // AMBA burst
   //-------------------------------------------------------------------------

   wire                      a_new_mem_burst; // new AMBA mem burst
   wire                      a_new_ahb_burst; // new AMBA mem/reg burst
   wire                      a_cnt_ahb_burst; // cont. AMBA mem/reg burst
   wire                      a_act_reg_burst; // active AMBA reg burst
   wire                      a_act_ahb_burst; // active AMBA mem/reg burst
   
   //-------------------------------------------------------------------------
   // Addr FIFO signals
   //-------------------------------------------------------------------------

   wire [3:0]                a_offset;        // address offset
   reg [3:0]                 f_offset;        // (save for reburst)
   
   wire [2:0]                a_offset_inv_3b; // inverted a_offset
   wire [3:0]                a_offset_inv_4b;
   wire [4:0]                a_offset_inv_5b;

   wire [2:0]                a_wrap4_bsz;     // WRAP4  1st wrap burst size
   wire [3:0]                a_wrap8_bsz;     // WRAP8  1st wrap burst size
   wire [4:0]                a_wrap16_bsz;    // WRAP16 1st wrap burst size

   reg [4:0]                 a_amba_bsz;      // AMBA burst size
   reg [4:0]                 a_amba_bsz2;     // (for 2nd wrap)
   reg [4:0]                 f_amba_bsz2;     // (save for reburst)
   reg [3:0]                 fd_amba_bcnt;    // AMBA burst count (data phase)

   reg [`H_ADDR_WIDTH-1:0]   a_hiu_addr_in;   // Addr FIFO in, start addr
   reg [`H_ADDR_WIDTH-1:0]   a_hiu_addr_in2;  // (for 2nd wrap)
   wire [5:0]                a_hiu_bsz_in;    // Addr FIFO in, hiu_burst_size
   wire [5:0]                a_hiu_bsz_in2;   // (for 2nd wrap)
   wire                      a_hiu_wb_in;     // Addr FIFO in, hiu_wrap_burst
   wire                      a_hiu_rw_in;     // Addr FIFO in, hiu_rw
   wire [1:0]                a_hiu_req_in;    // Addr FIFO in, hiu_req

   wire                      a_double;        // double burst size flag
   reg                       fd_double;       // (data phase)

   //-------------------------------------------------------------------------
   // Data FIFO signals
   //-------------------------------------------------------------------------

   wire                      d_term;          // data termination
   wire                      d_last_data;     // last data flag (data phase)
   reg                       fd_df_push_n;    // Data FIFO push
   reg [`H_DATA_WIDTH-1:0]   d_hiu_hwdata_in; // Data FIFO hwdata in
   wire                      d_hiu_dpop_in;   // Data FIFO dp in
   wire                      d_hiu_term_in;   // Data FIFO tm in

   //-------------------------------------------------------------------------
   // Read Buf signals
   //-------------------------------------------------------------------------
   
   reg                       fd_rd_ready;     // master is ready to take data
   wire                      d_rd_term;       // read early termination
   reg                       f_sel_buf;       // select buffered data
   reg                       n_sel_buf;       // (next)

   //-------------------------------------------------------------------------
   // BUSY handling signals
   //-------------------------------------------------------------------------
   
   reg [2:0]                 f_bh_state;      // BUSY handling FSM state
   reg [2:0]                 n_bh_state;      // (next)
   reg                       m_bh_term;       // termination due to BUSY
   reg                       f_hiu_terminate; // hiu_terminate (registered)
   reg                       f_burst_done;    // delay copy of miu_burst_done
   reg                       f_burst_done2;   // delay copy of f_burst_done

   reg                       fd_zero_wait_ok; // zero wait OKAY response

   reg [5:0]                 fr_wr_bcnt;      // wr burst counter (req phase)
   wire                      r_last_wr_data;  // last write data flag
   reg                       fr_prv_1wrap;    // prev req was 1st wrap
   reg                       fr_prv_1wrap_tm; // & terminated
   wire                      r_uflow_alert;   // underflow alert (req phase)
   
   //-------------------------------------------------------------------------
   // Non HSEL qualified burst triggers
   //-------------------------------------------------------------------------

   wire                      a_use_full_bus;  // trans uses full AMBA bus
   wire                      a_nt;            // narrow transfer
   wire                      a_pb;            // WRAPs has no pageb
   wire                      a_wb;            // wrapping burst
   reg                       fd_wr_bz;        // write and BUSY
   reg                       fd_rd_bz;        // read  and BUSY
   wire                      a_term;          // termination flag (addr phase)

   //-------------------------------------------------------------------------
   // HSEL qualified burst triggers
   //-------------------------------------------------------------------------
   
   wire                      a_narrow_trans;  // narrow transfer
   reg                       fd_narrow_trans; // (data phase)
   wire                      a_wrap_burst;    // wrapping burst
   reg                       f_wrap_burst;    // (save)
   wire                      a_reg_access;    // register access
   reg                       fd_reg_access;   // (data phase)
   wire                      a_nw_burst_trig; // new burst trigger
   reg                       a_reburst;       // re-burst
   wire                      a_reburst_1wrap; // re-burst 1st wrapping burst

   wire                      a_reburst_due2_bz; // reburst due to BUSY

   //-------------------------------------------------------------------------
   // miu_data_width and miu_col_width
   //-------------------------------------------------------------------------
   
   wire                      a_wr_width;
   reg                       fd_wr_width;

   reg [1:0]                 d_data_width;   // SCONR[14:13]
   reg [1:0]                 f_data_width;

   reg [3:0]                 d_col_width;    // SCONR[12:9]
   reg [3:0]                 f_col_width;
   
   wire [1:0]                miu_data_width;    // SDRAM data   width
   reg [1:0]                 fd_miu_data_width; // SDRAM data   width (reg'd)
   wire [3:0]                miu_col_width;     // SDRAM column width
   reg [3:0]                 fd_miu_col_width;  // SDRAM column width (reg'd)
   wire                      a_two_to_one;
   reg                       o_two_to_one;

   wire [127:0]              hwdata128;
   reg                       disable_dw_write;

   //-------------------------------------------------------------------------
   // AMBA aliases
   //-------------------------------------------------------------------------

   assign a_idle   = htrans == IDLE;
   assign a_busy   = htrans == BUSY;
   assign a_nonseq = htrans == NONSEQ;
   assign a_seq    = htrans == SEQ;
   assign a_wrap   = hburst == WRAP4 || hburst == WRAP8 || hburst == WRAP16;
   assign a_incr   = hburst == INCR;

   //-------------------------------------------------------------------------
   // AMBA burst
   //-------------------------------------------------------------------------

   assign a_new_mem_burst = a_nonseq && hsel_mem;
   assign a_new_ahb_burst = a_nonseq && (hsel_mem || hsel_reg);
   assign a_cnt_ahb_burst = a_seq && (hsel_mem || hsel_reg);
   assign a_act_reg_burst = (a_nonseq || a_seq) && hsel_reg;
   assign a_act_ahb_burst = (a_nonseq || a_seq) && (hsel_mem || hsel_reg);

   //-------------------------------------------------------------------------
   // miu_data_width and miu_col_width:
   // To solve the latency problem, generate these signals, instead of taking 
   // them from the MIU.
   //-------------------------------------------------------------------------

   // trigger write enable if writing to SCONR[15:8]
   
   assign a_wr_width = a_reg_access && hwrite && 
          haddr[7:2] == `CONFIG_REG_ADDR && 
          (hsize == WORD                           || 
            hsize == HALFWORD && haddr[1]   == 1'b0 ||
            hsize == BY_TE     && haddr[1:0] == 2'b01);

   // take correct bits from the HWDATA

   assign hwdata128 = hwdata; // to avoid "index out of bounds" warning
   
   always @ (big_endian or hwdata128)
     if (`H_DATA_WIDTH == 32) begin
        if (big_endian) { d_data_width, d_col_width } = hwdata128[22:17];
        else              { d_data_width, d_col_width } = hwdata128[14:9];
     end else if (`H_DATA_WIDTH == 64) begin
        if (big_endian) { d_data_width, d_col_width } = hwdata128[54:49];
        else              { d_data_width, d_col_width } = hwdata128[14:9];
     end else begin // 128
        if (big_endian) { d_data_width, d_col_width } = hwdata128[118:113];
        else              { d_data_width, d_col_width } = hwdata128[14:9];
     end

   // register the miu_data_width and miu_col_width if write enabled
   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) begin // set default configuration values
        f_data_width <= `DYNAMIC_RAM_TYPE == 1 ? INI_DDR_WIDTH : // DDR
                                                 INI_SDR_WIDTH;  // SDR,SF,no
        f_col_width  <= INI_COL_WIDTH;
     end else begin
        if (fd_wr_width) begin
           if (! disable_dw_write) f_data_width <= d_data_width;
           f_col_width <= d_col_width;
        end
     end

  // Disable data width write checking for illegal data widths

  always @ (fd_wr_width or d_data_width)
    case (`H_DATA_WIDTH)
      32:      disable_dw_write = fd_wr_width && 
                                  (d_data_width == 2 || d_data_width == 3);
      64:      disable_dw_write = fd_wr_width && 
                                  (d_data_width == 0 || d_data_width == 3);
      default: disable_dw_write = fd_wr_width && 
                                  (d_data_width == 0 || d_data_width == 1);
    endcase

   // take early miu_data_width and miu_col_width while writing new values
   assign miu_data_width = `HARD_WIRE_SDRAM_PARAMETERS == 1 ? INI_DATA_WIDTH :
                           `DYNAMIC_RAM_TYPE == 6 ? INI_AHB_WIDTH : // no DRAM
                           (fd_wr_width ? d_data_width : f_data_width);

   assign miu_col_width = `DYNAMIC_RAM_TYPE == 6 ? 4'b0 : // no DRAM
          `HARD_WIRE_SDRAM_PARAMETERS == 1 ? INI_COL_WIDTH :
          (fd_wr_width ? d_col_width : f_col_width);
   
   //-------------------------------------------------------------------------
   // 2:1 Mode
   //-------------------------------------------------------------------------
   
   // o_two_to_one   - 0=1:1, 1=2:1 AMBA/SDRAM bus ratio
   // miu_data_width - SDRAM bus width, 0=16, 1=32, 2=64, 3=128 bits
   // No protection against error.
   //
   // H_DATA_WIDTH    miu_data_width
   // ------------    -------------------
   //           32    16 (00) or  32 (01)
   //           64    32 (01) or  64 (10)
   //          128    64 (10) or 128 (11)

   assign a_two_to_one = `H_DATA_WIDTH == 32 ? ! miu_data_width[0] :
                         `H_DATA_WIDTH == 64 ?   miu_data_width[0] :
                                     /* 128 */ ! miu_data_width[0];

   // synopsys translate_off
   // synopsys translate_on

   //-------------------------------------------------------------------------
   // Non HSEL qualified burst triggers
   //-------------------------------------------------------------------------

   assign a_use_full_bus = `H_DATA_WIDTH ==  32 && hsize == WORD       ||
                           `H_DATA_WIDTH ==  64 && hsize == DOUBLEWORD ||
                           `H_DATA_WIDTH == 128 && hsize == FOURWORD;

   assign a_nt = ! a_use_full_bus;

   // Page Boundary
   // -------------
   // Page boundary is possible only if SDRAM data width is 16 bits and
   // column address width is:
   //    SDR, SyncFlash, Bat RAM: 8-bit (miu_col_width=7)
   //    DDR: 8-bit (miu_col_width=7) or 9-bit (miu_col_width=8)
   // Otherwise, page boundary also crosses AMBA 1k address boundary 
   // (haddr[9]), which is not allowed.
   //
   // [9][8][7][6][5][4][3][2][1][0]
   // ------------------------------
   //  X  0  0  0  0  0  0  0  0  X
   //    <- col width is 8 bit ->  \___ SDR SDRAM data width is 16 bit
   //
   // [9][8][7][6][5][4][3][2][1][0]
   // ------------------------------
   //  X  0  0  0  0  0  0  0  0  0
   //       <- col width is 8 bit ->    DDR (data width 16-bit means 8-bit)
   //    <---- col width is 9 bit ->    DDR (data width 16-bit means 8-bit)
   //
   // Note that the page boundary termination happens only for full bus access
   // because partial transfer is always 1 by 1.
   // This means at least haddr[1:0] can be assumed to be 0.

   assign a_pb = 
          ! a_wrap       && // WRAPs hide page boundary
          a_use_full_bus && // narrow trans is always 1 by 1
          (`DYNAMIC_RAM_TYPE == 6 ? 1'b0 : // no DRAM -> no pb
            (`DYNAMIC_RAM_TYPE == 5 || `DYNAMIC_RAM_TYPE == 4) ? // SDR+SF
            (`H_DATA_WIDTH == 32 ? (~| haddr[7:2]) :
              `H_DATA_WIDTH == 64 ? (~| haddr[8:3]) :
            /*`H_DATA_WIDTH ==128*/ (~| haddr[8:4])) :
            `DYNAMIC_RAM_TYPE == 1 ?                            // DDR
            fd_miu_data_width == 2'h0 &&                        // 16 bits
            (fd_miu_col_width == 4'h7 && (~| haddr[7:2]) ||  // 8-bit
              fd_miu_col_width == 4'h8 && (~| haddr[8:2])) : // 9-bit
            fd_miu_data_width == 2'h0 &&                            // 16 bits
            fd_miu_col_width == 4'h7 && (~| haddr[8:2]));
   assign a_wb = (hburst == WRAP4  && a_offset[1:0] != 2'b0 ||
                   hburst == WRAP8  && a_offset[2:0] != 3'b0 ||
                   hburst == WRAP16 && a_offset[3:0] != 4'b0) && 
                 a_use_full_bus;

   // Check if the DW_memctl lost the HSEL.
   // This provides an extra precaution against illegal AHB transaction 
   // such as:
   //          __    __    __    __    __    __    __
   // HCLK    /  \__/  \__/  \__/  \__/  \__/  \__/  \__
   //         :______     :     :     :     :     :
   // HSELmem /      \__________________________________
   //         :     :     :     :     :     :     :
   // HTRANS    NSEQ  SEQ   XXX   XXX   XXX   XXX   XXX
   // 
   // Only HSELmem is checked because register access has no burst termination
   // (always single access and HSELreg is checked at every cycle).
   // Detect negative edge of HSELmem instead of just checking HSELmem to
   // prevent possible excessive termination.
   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) fd_hsel_mem <= 1'b0;
     else                   fd_hsel_mem <= hsel_mem;

   assign a_lost_hsel_mem = ! hsel_mem && fd_hsel_mem;

   assign a_term = a_idle || a_nonseq || a_pb || a_lost_hsel_mem;

   //-------------------------------------------------------------------------
   // HSEL qualified burst triggers
   //-------------------------------------------------------------------------
   
   assign a_narrow_trans  = a_act_ahb_burst && a_nt;
   assign a_wrap_burst    = a_new_mem_burst && a_wb;
   assign a_reg_access    = a_act_reg_burst;
   assign a_nw_burst_trig = 
          (a_nonseq || a_seq && (a_nt || a_pb)) && hsel_mem || 
          (a_nonseq || a_seq) && hsel_reg;
   assign a_reburst_due2_bz = a_seq && fd_wr_bz && hsel_mem;
   assign a_reburst_1wrap = (a_reburst || a_reburst_due2_bz) && 
          f_wrap_burst && (f_offset < a_offset);

   //-------------------------------------------------------------------------
   // Data Phase Pipeline Signals
   //-------------------------------------------------------------------------
   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) begin
        fd_incr           <= 1'b0;
        fd_non_single     <= 1'b0;
        fd_narrow_trans   <= 1'b0;
        fd_reg_access     <= 1'b0;
        fd_haddr          <= 4'b0;
        fd_double         <= 1'b0;
        fd_wr_width       <= 1'b0;
        o_two_to_one      <= 1'b0;
        fd_miu_data_width <= 2'b0;
        fd_miu_col_width  <= 4'b0;
     end else begin
        if (hready && ! a_busy) begin
           fd_incr           <= a_incr;
           fd_non_single     <= hburst != SINGLE;
           fd_narrow_trans   <= a_narrow_trans;
           fd_reg_access     <= a_reg_access;
           fd_haddr          <= haddr[3:0];
           fd_double         <= a_double;
           fd_wr_width       <= a_wr_width;
           o_two_to_one      <= a_two_to_one;
           fd_miu_data_width <= miu_data_width;
           fd_miu_col_width  <= miu_col_width;
        end 
     end

   assign o_double = fd_double;

   // Since burst is terminated as soon as a BUSY is seen, reburst is
   // necessary no matter what the HBURST is.   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0)
       fd_wr_bz    <= 1'b0;
     else begin
      if (a_busy && hwrite && (hsel_mem || hsel_reg))
        fd_wr_bz <= 1'b1;
      else if (! a_busy && hready)
        fd_wr_bz <= 1'b0;
     end

   // fd_rd_bz is asserted if BUSY happened to any read   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0)
       fd_rd_bz  <= 1'b0;
     else begin
      if (a_busy && ! hwrite  && (hsel_mem || hsel_reg))
        fd_rd_bz <= 1'b1;
      else if (! a_busy && hready)
        fd_rd_bz <= 1'b0;
     end

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) 
       fd_zero_wait_ok <= 1'b1;
     else
       fd_zero_wait_ok <= (a_idle || a_busy) && hready;

   //=========================================================================
   // Addr FIFO Control & Data
   //=========================================================================

   // Address Alignment
   // -----------------
   // Align start address with SDRAM bus width.  Invalid bytes will be masked.
   // If register access, always align to WORD (32 bits) --- V1.0 only
   //
   // Example: SDRAM 32 bits, Halfword access
   //
   // HADDR   : 0x80000002
   // hiu_addr: 0x80000000
   
   always @ (miu_data_width or haddr)
     if (miu_data_width == 2'b00) // 16 bit
       a_hiu_addr_in = { haddr[`H_ADDR_WIDTH-1:1], 1'b0 };
     else if (miu_data_width == 2'b01) // 32 bit
       a_hiu_addr_in = { haddr[`H_ADDR_WIDTH-1:2], 2'b0 };
     else if (miu_data_width == 2'b10) // 64 bit
       a_hiu_addr_in = { haddr[`H_ADDR_WIDTH-1:3], 3'b0 };
     else // 128 bit
       a_hiu_addr_in = { haddr[`H_ADDR_WIDTH-1:4], 4'b0 };

   // Address Offset
   // --------------
   // The a_offset is only used for WRAPs and only valid when whole data 
   // width is used.

   assign a_offset = `H_DATA_WIDTH == 32 ? haddr[5:2] :
                     `H_DATA_WIDTH == 64 ? haddr[6:3] : haddr[7:4]; // 128

   // Burst Size
   // ----------
   // If narrow transfer or register access, the burst size is always 1.
   // If page boundary or reburst the second wrapping burst, use remaining
   // count unless INCR (burst size is 0).
   // Otherwise, use burst specific size.
   //
   // The U_inc1, U_inc2, and U_inc3 implements the following.
   // a_wrap4_bsz  = { 1'b0, ~ a_offset[1:0] } + 1'b1
   // a_wrap8_bsz  = { 1'b0, ~ a_offset[2:0] } + 1'b1
   // a_wrap16_bsz = { 1'b0, ~ a_offset[3:0] } + 1'b1

   assign a_offset_inv_3b = { 1'b0, ~ a_offset[1:0] };
   assign a_offset_inv_4b = { 1'b0, ~ a_offset[2:0] };
   assign a_offset_inv_5b = { 1'b0, ~ a_offset[3:0] };

   DW01_inc #( 3 ) U_inc1 ( .A( a_offset_inv_3b ), .SUM( a_wrap4_bsz  ) );
   DW01_inc #( 4 ) U_inc2 ( .A( a_offset_inv_4b ), .SUM( a_wrap8_bsz  ) );
   DW01_inc #( 5 ) U_inc3 ( .A( a_offset_inv_5b ), .SUM( a_wrap16_bsz ) );

   always @ (a_nt            or
              hsel_reg        or
              a_pb            or
              a_seq           or
              a_reburst       or
              a_reburst_due2_bz or
              a_reburst_1wrap or
              a_incr          or
              fd_amba_bcnt    or
              hburst          or
              a_wrap4_bsz     or
              a_wrap8_bsz     or
              a_wrap16_bsz)
     if (a_nt || hsel_reg)
       a_amba_bsz = 5'd1;
     else if (a_pb && a_seq || 
               (a_reburst || a_reburst_due2_bz) && ! a_reburst_1wrap) begin
        if (a_incr) a_amba_bsz = 5'd0;
        else          a_amba_bsz = fd_amba_bcnt; // remaining count
     end else
       case (hburst) // synopsys infer_mux
         SINGLE: a_amba_bsz = 5'd1;
         INCR4:  a_amba_bsz = 5'd4;
         INCR8:  a_amba_bsz = 5'd8;
         INCR16: a_amba_bsz = 5'd16;
         INCR:   a_amba_bsz = 5'd0;
         WRAP4:  a_amba_bsz = a_wrap4_bsz;
         WRAP8:  a_amba_bsz = a_wrap8_bsz;
         default: a_amba_bsz = a_wrap16_bsz;    // WRAP16
       endcase

   // Second Wrapping Burst
   // ---------------------

   always @ (hburst or hsize or haddr or a_offset)
     case (hburst)
       WRAP4: begin
          case (hsize)
            BY_TE:       a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:2], 2'b0 };
            HALFWORD:   a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:3], 3'b0 };
            WORD:       a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:4], 4'b0 };
            DOUBLEWORD: a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:5], 5'b0 };
            default:    a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:6], 6'b0 };
          endcase
          a_amba_bsz2 = a_offset[1:0];
       end
       WRAP8: begin
          case (hsize)
            BY_TE:       a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:3], 3'b0 };
            HALFWORD:   a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:4], 4'b0 };
            WORD:       a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:5], 5'b0 };
            DOUBLEWORD: a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:6], 6'b0 };
            default:    a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:7], 7'b0 };
          endcase
          a_amba_bsz2 = a_offset[2:0];
       end
       default: begin // WRAP16, or others (don't care)
          case (hsize)
            BY_TE:       a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:4], 4'b0 };
            HALFWORD:   a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:5], 5'b0 };
            WORD:       a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:6], 6'b0 };
            DOUBLEWORD: a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:7], 7'b0 };
            default:    a_hiu_addr_in2 = { haddr[`H_ADDR_WIDTH-1:8], 8'b0 };
          endcase
          a_amba_bsz2 = a_offset[3:0];
       end
     endcase

   // Double the burst size only if,
   //  - 2:1 and
   //  - full transfer and
   //  - memory access, or AHB data bus width is 32 bit (in this case,
   //    register access also needs 2 bursts).

   assign a_double = a_two_to_one && ! a_narrow_trans && 
                     (! a_reg_access || `H_DATA_WIDTH == 32);
   
   assign a_hiu_bsz_in = a_double ? { a_amba_bsz, 1'b0 } : a_amba_bsz;

   // If a_reburst_1wrap, use saved 2nd burst size,
   // otherwise (if a_wrap_burst), use calculated 2nd burst size.

   assign a_hiu_bsz_in2 = (a_reburst_1wrap ? f_amba_bsz2 : a_amba_bsz2) 
                          << a_two_to_one;

   // Addr FIFO Data
   // --------------

   assign a_hiu_wb_in  = a_reburst_1wrap ? 1 : a_wrap_burst;
   assign a_hiu_rw_in  = ! hwrite;
   assign a_hiu_req_in = a_reg_access ? 0 : 1;
   assign o_af_data1   = { haddr[3:0], hsize, 
                           a_hiu_addr_in, a_hiu_bsz_in, a_hiu_wb_in, 
                           a_hiu_rw_in, a_hiu_req_in };
   assign o_af_data2   = { a_hiu_addr_in2[3:0], hsize, 
                           a_hiu_addr_in2, a_hiu_bsz_in2, 1'b0, 
                           a_hiu_rw_in, a_hiu_req_in }; // for 2nd wrap

   // AMBA Burst Counter (Data Phase)
   // -------------------------------
   // Initialize the counter at NONSEQ with beat - 1.
   // Decrement the counter when SEQ (and HREADY).

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) fd_amba_bcnt <= 4'd0;
     else begin
        if (a_new_ahb_burst && hready) // init the counter w/(beat-1)
          // turn off coverage to avoid MISSING_DEFAULT (all caseitems
          // are covered)
          //VCS coverage off
          case (hburst) 
            SINGLE: fd_amba_bcnt <= 4'd0;
            INCR4:  fd_amba_bcnt <= 4'd3;
            INCR8:  fd_amba_bcnt <= 4'd7;
            INCR16: fd_amba_bcnt <= 4'd15;
            INCR:   fd_amba_bcnt <= 4'd0; // unused
            WRAP4:  fd_amba_bcnt <= 4'd3;
            WRAP8:  fd_amba_bcnt <= 4'd7;
            default: fd_amba_bcnt <= 4'd15;     // WRAP16
          endcase
          //VCS coverage on
        else if (a_cnt_ahb_burst && hready)
          fd_amba_bcnt <= fd_amba_bcnt - 1'b1;
     end

   // Save Burst Info
   // ---------------
   // Every time a new burst is triggered, save some burst info. for future
   // use.
   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) begin
        f_offset     <= 4'b0;
        f_wrap_burst <= 1'b0;
        f_amba_bsz2  <= 5'b0;
     end else begin
        if (a_nw_burst_trig) begin
           f_offset     <= a_offset;
           f_wrap_burst <= a_wrap_burst;
           f_amba_bsz2  <= a_amba_bsz2; // save in case of reburst of 1st wrap
        end
     end
   
   // Addr FIFO Push
   // --------------

   assign o_af_push1_n = 
     ! ((a_nw_burst_trig || a_reburst || a_reburst_due2_bz) && hready);
   assign o_af_push2_n = ! ((a_wrap_burst || a_reburst_1wrap) && hready);

   //=========================================================================
   // Data FIFO Control & Data
   //=========================================================================

   // HWDATA
   // ------
   // Little Endian
   //
   // H_DATA_WIDTH  32     64         128
   // 
   // fd_haddr      FE DC  FEDC BA98  FEDCBA98 76543210
   //               BA 98  7654 3210  -------- --------
   //               76 54  ---- ----
   //               32 10
   //               -- --
   // Big Endian
   //
   // H_DATA_WIDTH  32     64         128
   //
   // fd_haddr      CD EF  89AB CDEF  01234567 89ABCDEF
   //               89 AB  0123 4567  -------- --------
   //               45 67  ---- ----
   //               01 23
   //               -- --

   always @ (o_two_to_one    or 
              fd_narrow_trans or
              fd_haddr        or
              big_endian      or
              hwdata)
     if (o_two_to_one) begin // 2:1
        if (fd_narrow_trans) begin // partial access
           if (`H_DATA_WIDTH == 32 && 
                (fd_haddr[1] == 1 && ! big_endian ||   // 2367ABEF
                  fd_haddr[1] == 0 &&   big_endian) || // 014589CD
                `H_DATA_WIDTH == 64 &&
                (fd_haddr[2] == 1 && ! big_endian ||   // 4567CDEF
                  fd_haddr[2] == 0 &&   big_endian) || // 012389AB
                `H_DATA_WIDTH == 128 &&
                (fd_haddr[3] == 1 && ! big_endian ||   // 89ABCDEF
                  fd_haddr[3] == 0 &&   big_endian))  // 01234567
             d_hiu_hwdata_in = { hwdata[`H_DATA_WIDTH-1:`H_DATA_WIDTH/2],
                                 hwdata[`H_DATA_WIDTH-1:`H_DATA_WIDTH/2] };
           else //               ^^^^^^ upper half is dummy to lighten load
             d_hiu_hwdata_in = hwdata; // only lower half is valid
        end else begin // not partial access
           if (big_endian) // swap upper and lower
             d_hiu_hwdata_in = { hwdata[`H_DATA_WIDTH/2-1:0],
                                 hwdata[`H_DATA_WIDTH-1:`H_DATA_WIDTH/2] };
           else
             d_hiu_hwdata_in = hwdata;
        end
     end else // 1:1
       d_hiu_hwdata_in = hwdata;

   // Double Pop Flag
   // ---------------
   // If the burst size is doubled at the address phase, need two pops.

   assign d_hiu_dpop_in = fd_double;

   // Last Data (Data Phase)
   // ----------------------
   // Data is the last if the AMBA counter is 0.
   // There are a few exceptions.
   // - The count of INCR burst is invalid.  Therefore it has to be always
   //   explicitly terminated.
   // - The count of WRAP[4|8|16] burst is total count, which means even the 
   //   first wrapping has full count of burst.
   
   assign d_last_data = ! fd_incr && fd_amba_bcnt == 4'd0;

   // Early Termination - Write (Data Phase)
   // --------------------------------------
   // - Each write data has a flag showing if the burst has to be early 
   //   termianted at this data.
   //   First, check if the current transfer is IDLE or NONSEQ, or at page 
   //   boundary (a_term).
   // - Then, check if the data is the last data in the burst (d_last_data).
   //   If the data is the last, no flag will be set.
   //   If INCR, always do early termination (burst counter has no meaning).
   // - If narrow transfer (fd_narrow_trans) or register access 
   //   (fd_reg_access), no flag is set because the burst count is always 1
   //   and no termination is necessary.
   // - In case of 2:1, only the second data will have the flag.
   //   This is assured by the Data FIFO.
   // - The write termination is not excecuted immediately.
   //   It will be executed when the corresponding data is popped.
   
   assign d_term = a_term            && 
                   ! d_last_data     && 
                   ! fd_narrow_trans && 
                   ! fd_reg_access;

   assign d_hiu_term_in = d_term || 
          a_busy && fd_non_single && ! fd_narrow_trans && ! fd_reg_access;

   // Data FIFO Push
   // --------------
   // Data is pushed at the next cycle (data phase) if the address phase is
   // ready (HREADY is high).

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0)                        fd_df_push_n <= 1'b1;
     else begin
        if (a_act_ahb_burst && hwrite && hready) fd_df_push_n <= 1'b0;
        else                                       fd_df_push_n <= 1'b1;
     end

   assign o_df_push_n = fd_df_push_n;
   assign o_df_data   = { d_hiu_hwdata_in, d_hiu_dpop_in, d_hiu_term_in };

   //=========================================================================
   // Read Buf Control
   //=========================================================================

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0)                 fd_rd_ready <= 1'b1;
     else begin
        if (hready) begin // update fd_rd_ready only when HREADY=1
           if (a_act_ahb_burst && ! hwrite) fd_rd_ready <= 1'b1; // mstr rdy
           else                               fd_rd_ready <= 1'b0;
        end
     end
   
   assign o_rb_start   = 
     (a_nw_burst_trig || a_reburst || a_reburst_due2_bz) && hready && 
     ! hwrite;
   assign o_rb_done    = a_term;
   assign o_rb_busy    = a_busy;
   assign o_rb_pop_n   = ! (fd_rd_ready && hready);
   assign o_rb_sel_buf = f_sel_buf;

   // Early Termination - Read (Data Phase)
   // - Unlike the write termination, the read termination is executed 
   //   immediately at the next cycle.
   assign d_rd_term = d_term && hready && 
          (! miu_push_n || fd_rd_bz && f_bh_state == S_BH_BURST);
   
   //=========================================================================
   // BUSY Handling
   //=========================================================================

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) begin
        fr_prv_1wrap    <= 1'b0;
        fr_prv_1wrap_tm <= 1'b0;
     end else begin
        fr_prv_1wrap    <= hiu_wrap_burst && ! i_af_dummy_req;
        fr_prv_1wrap_tm <= hiu_wrap_burst && ! i_af_dummy_req && 
                           hiu_terminate;
     end

   // Burst Counter (Request Phase)
   // -----------------------------
   // - If reset, or burst is early terminated, reset the counter.
   // - If new HIU request happens at the same time as the termination 
   //   load the new hiu_burst_size.
   // - If new HIU request happens, accumulate the hiu_burst_size on the 
   //   counter.
   // - If either pop or push happens, decrement the count.
   // - If the count reaches 0, do not decrement.

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) fr_wr_bcnt <= 6'd0;
     else begin

        // Terminate: Reset the counter.
        // Exception: If a new write request is asserted at the same time,
        // and the request is asserted not because of 1st wrap terminated,
        // then set the new burst size.
        
        if (f_hiu_terminate) begin
           if (i_af_new_req && ! hiu_rw && ! fr_prv_1wrap)
             fr_wr_bcnt <= hiu_burst_size; // take the new hiu_burst_size
           else // terminate only, or term + read req, or 1st wrap terminated
             fr_wr_bcnt <= 6'd0; // reset the counter
           
           // New Write Request: Add the burst count.
           // Exception: If pop is asserted at the same time, decrement too.
           
        end else if (i_af_new_req && ! hiu_rw) begin
           if (! miu_pop_n) begin // new write request + decrement

              // The following condition should not occur, because 
              // fr_wr_bcnt == 0 (and pop) means previous burst was either
              // - INCR: INCR should have f_hiu_terminate before i_af_new_req.
              // - other: fr_wr_bcnt becomes negative at this cycle due to 
              //          pop.

              //VCS coverage off
              if (fr_wr_bcnt == 6'd0 && hiu_burst_size == 6'd0)
                fr_wr_bcnt <= 6'd0; //   ~~~~~~~~~~~~~~~~~~~~~~ INCR
              else
                fr_wr_bcnt <= fr_wr_bcnt + hiu_burst_size - 1;
              //VCS coverage on
           end else // new write request only
             fr_wr_bcnt <= fr_wr_bcnt + hiu_burst_size; 
        end else if (! miu_pop_n) begin // decrement only
           if (fr_wr_bcnt == 6'd0) fr_wr_bcnt <= 6'd0;
           else                      fr_wr_bcnt <= fr_wr_bcnt - 1;
        end
     end

   assign r_last_wr_data = fr_wr_bcnt == 6'd1;

   // Write Burst Termination
   // -----------------------
   // - i_df_wr_term guarantees that the termination is necessary.
   //   (unnecessary termination was dropped at FIFO push time).
   // - On the other hand, underflow termination cannot be determined ahead of
   //   time (FIFO push time).
   //   The logic makes sure that the request is write and the data is not the
   //   last one.
   //   One exception is wrapping burst.  If the previous burst was the first
   //   wrapping, then do underflow process even though the data is the last
   //   (we need to terminate the second wrapping too).
   
   assign r_uflow_alert = i_df_uf_alert && ! miu_pop_n && ! hiu_rw &&
                          (! r_last_wr_data || fr_prv_1wrap);

   always @ (f_bh_state      or
              i_df_wr_term    or
              d_rd_term       or
              i_rb_overflow   or
              a_seq           or
              a_idle          or
              a_nonseq        or
              i_af_new_req    or
              fr_prv_1wrap_tm or
              r_uflow_alert   or
              miu_burst_done  or
              hiu_wrap_burst) begin
      m_bh_term  = 1'b0;
      a_reburst  = 1'b0;
      n_sel_buf  = 1'b0;
      n_bh_state = f_bh_state;

      // Early Termination
      // -----------------
      // If regular write/read early termination occurred, it takes precedence
      // over BUSY handling and goes back to S_BH_IDLE.
      
      if (i_df_wr_term || d_rd_term) n_bh_state = S_BH_IDLE;
      else 
        case (f_bh_state)
          
          S_BH_IDLE:
            // Overflow Termination
            // --------------------
            // Even though the BU receives the miu_burst_done, the read may be
            // continuing because the burst done is issued CAS latency cycles
            // ahead.
            // The following statements checks the overflow and terminates the
            // burst if necessary.
            // If the data is not the last, or the previous burst is a 1st 
            // wrapping, then teminate.       
            if (i_rb_overflow) begin
               n_sel_buf = 1'b1;
               m_bh_term = 1'b1;
               if (a_seq)
                 n_bh_state = S_BH_PASS_DATA;
               else if (a_idle || a_nonseq) ; // INCR ended with BUSY
               else
                 n_bh_state = S_BH_OVERFLOW;
            end else if (i_af_new_req) begin // new burst
               // Wrapping Burst Terminated at the First Burst (1)
               // ------------------------------------------------
               // If the first burst of wrapping burst has been terminated, 
               // the second burst request has to be ignored as well.
               // In this case, even though i_af_new_req is asserted by the
               // miu_burst_done at the previous cycle, it has to be ignored.
               // The following miu_burst_done corresponds to the second 
               // burst.
               if (fr_prv_1wrap_tm) ; // ignore the 2nd request
               // Wrapping Burst Terminated at the First Burst (2)
               // ------------------------------------------------
               // If the normal early termination of the first burst of the
               // wrapping burst and miu_burst_done happen to occur at the 
               // same time, the new requst for the second burst has to be
               // ignored.
               // Underflow Termination (1)
               // -------------------------
               // If the Data FIFO will become underflow at the next cycle 
               // (due to previous BUSY) and the new WRITE burst is requested,
               // it has to be terminated because of no data to write.
               // If the current transfer is SEQ, reburst immediately.
               // Otherwise go to S_BH_UNDERFLOW and wait for the SEQ.
               else if (r_uflow_alert) begin
                  m_bh_term = 1'b1;
                  if (a_seq) a_reburst  = 1'b1;
                  else         n_bh_state = S_BH_UNDERFLOW;
               end else if (! miu_burst_done) // if not SINGLE or 1-x WRAP
                 n_bh_state = S_BH_BURST;
            end
            
          S_BH_BURST:
            begin
               // Underflow Termination (2)
               // -------------------------
               // If the Data FIFO becomes underflow at the next cycle,
               // and the data is not the last, terminate the burst.
               // If the current transfer is SEQ, reburst immediately and goes 
               // back to S_BH_IDLE.
               // Otherwise go to S_BH_UNDERFLOW and wait for the SEQ.          
               if (r_uflow_alert) begin
                  m_bh_term = 1'b1;
                  if (a_seq) begin
                     a_reburst  = 1'b1;
                     n_bh_state = S_BH_IDLE;
                  end else 
                    n_bh_state = S_BH_UNDERFLOW;
               end else if (i_rb_overflow) begin
                  n_sel_buf = 1'b1;
                  m_bh_term = 1'b1;
                  if (a_seq)
                    n_bh_state = S_BH_PASS_DATA;
                  else if (a_idle || a_nonseq)
                    n_bh_state = S_BH_IDLE; // Early termination
                  else
                    n_bh_state = S_BH_OVERFLOW;
               end else if (miu_burst_done && (! hiu_wrap_burst)) 
                 // Don't go back to S_BH_IDLE if 2nd part of WRAP burst.
                 // This is to allow for early termination of 2nd part.
                 n_bh_state = S_BH_IDLE;
            end

          
          S_BH_UNDERFLOW: // underflow has occurred, wait for SEQ           
            if (a_seq) begin
               a_reburst  = 1'b1;
               n_bh_state = S_BH_IDLE;
            end 
            // The following condition should not occur, because
            //  1. To enter the S_BH_UNDERFLOW, r_uflow_alert must be asserted.
            //  2. r_uflow_alert is asserted only when the miu_pop_n is asserted
            //     (low).
            //  3. If INCR write ended with BUSY, the write data has termination
            //     flag.  (See d_hiu_term_in).
            //  4. Therefore, when the INCR write data is popped, the state goes
            //     to S_BH_IDLE (see the top of the FSM) instead of coming here
            //     (S_BH_UNDERFLOW).
            //  5. Because of the above reason, the following condition never
            //     reaches.
            else if (a_idle || a_nonseq) // INCR ended with BUSY
                    n_bh_state = S_BH_IDLE;

          S_BH_OVERFLOW: // overflow has occurred, wait for SEQ
            if (a_seq) begin
               n_sel_buf  = 1'b1;
               n_bh_state = S_BH_PASS_DATA;
            end else if (a_idle || a_nonseq)
              n_bh_state = S_BH_IDLE;
            else
              n_sel_buf = 1'b1;
            
          default: // S_BH_PASS_DATA:
            if (a_seq) begin // if another SEQ, reburst.
              a_reburst  = 1'b1;
              n_bh_state = S_BH_IDLE;
            end else if (a_idle || a_nonseq) // INCR read ended with BUSY
              n_bh_state = S_BH_IDLE;
            else // if BUSY, stay to see SEQ, NONSEQ, or IDLE
              n_sel_buf = 1'b1;

        endcase
   end

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) begin
        f_sel_buf  <= 1'b0;
        f_bh_state <= S_BH_IDLE;
     end else begin
        f_sel_buf  <= n_sel_buf;
        f_bh_state <= n_bh_state;
     end

   // BU Status
   // ---------
   // When a new burst is triggered, all the components have to be ready.
   // Read Buf is checked even for write to make sure the last read has
   // finished.
   // Even when IDLE, Read Buf needs to be ready to make sure the last read 
   // has finished.

   // Provide a zero wait state OKAY response to IDLE/BUSY transfers.
   
   assign hready_resp = i_af_ready && i_df_ready && i_rb_ready ||
                        fd_zero_wait_ok;
   assign hresp = OKAY; // always OKAY

   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) begin
        f_burst_done  <= 1'b0;
        f_burst_done2 <= 1'b0;
     end else begin
        f_burst_done  <= miu_burst_done;
        f_burst_done2 <= f_burst_done;
     end
   
   assign hiu_terminate = (d_rd_term || i_df_wr_term || m_bh_term) ? 1'b1 :
                          (f_burst_done || f_burst_done2) ? 1'b0 : 
                          f_hiu_terminate;
   
   always @ (posedge hclk or negedge hresetn)
     if (hresetn == 1'b0) f_hiu_terminate <= 1'b0;
     else                   f_hiu_terminate <= hiu_terminate;

endmodule // DW_memctl_hiu_ctl
