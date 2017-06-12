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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_hiu.v $ 
// $Revision: #3 $
//
// Abstract  : This module is the top level module of the Host Interface Unit
// (HIU).
//
//============================================================================

// Naming Conventions
// ------------------
// h*:    AMBA AHB signal
// hiu_*: HIU output to MIU
// miu_*: MIU output to HIU
// m_*:   other internal signal
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module DW_memctl_hiu( hclk,               
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
                      hrdata,             
                                          
                      hiu_req,            
                      hiu_burst_size,     
                      hiu_wrap_burst,  
                      hiu_rw,             
                      hiu_terminate,
                      hiu_addr,           
                      hiu_data,           
                      hiu_haddr,
		                  hiu_hsize,

                      miu_burst_done,     
                      miu_push_n,
                      miu_pop_n,          
                      miu_data,           
                      miu_data_width,
                      miu_col_width,
		      
		                  big_endian );

   //-------------------------------------------------------------------------
   // I/O
   //-------------------------------------------------------------------------
      
   input                            hclk;           // AMBA HCLK
   input                            hresetn;        // AMBA HRESETn
   input                            hsel_mem;       // AMBA HSELm (mem select)
   input                            hsel_reg;       // AMBA HSELr (reg select)
   input [1:0]                      htrans;         // AMBA HTRANS
   input                            hwrite;         // AMBA HWRITE
   input [2:0]                      hsize;          // AMBA HSIZE
   input [2:0]                      hburst;         // AMBA HBURST
   input                            hready;         // AMBA HREADY
   output                           hready_resp;    // AMBA HREADYOUT
   output [1:0]                     hresp;          // AMBA HRESP
   input  [`H_ADDR_WIDTH-1:0]       haddr;          // AMBA HADDR
   input  [`H_DATA_WIDTH-1:0]       hwdata;         // AMBA HWDATA
   output [`H_DATA_WIDTH-1:0]       hrdata;         // AMBA HRDATA
   output [1:0]                     hiu_req;        // Mem/reg access request
                                                    // [3:2]rsrv,[1]mem,[0]reg
   output [5:0]                     hiu_burst_size; // Burst size, 0:unspec
   output                           hiu_wrap_burst; // Wrapping burst flag
   output                           hiu_rw;         // 1:read, 0:write access
   output                           hiu_terminate;  // Early burst termination
   output [`H_ADDR_WIDTH-1:0]       hiu_addr;       // Burst start/reg address
   output [`S_RD_DATA_WIDTH-1:0]    hiu_data;       // Mem/reg write data
   output [3:0] 		                hiu_haddr;      // AMBA HADDR (req phase)
   output [2:0] 		                hiu_hsize;      // AMBA HSIZE (req phase)

   input                            miu_burst_done; // Mem/reg access done
   input                            miu_push_n;     // Push mem/reg read  data
   input                            miu_pop_n;      // Pop  mem/reg write data
   input [`S_RD_DATA_WIDTH-1:0]     miu_data;       // Mem/reg read data
   input [1:0]                      miu_data_width; // SDRAM data width
                                                    // 0=16,1=32,2=64,3=128
   input [3:0]                      miu_col_width;  // SDRAM column addr width

   input 			                      big_endian;     // Big endian mode 

   //-------------------------------------------------------------------------
   // Wires
   //-------------------------------------------------------------------------
   
   wire                             m_af_push1_n;   // Addr FIFO push req 1
   wire                             m_af_push2_n;   // Addr FIFO push req 2
   wire                             m_af_pop_n;     // Addr FIFO pop  req
   wire [`AFIFO_IN_WIDTH-1:0]       m_af_data1_in;  // Addr FIFO data 1 in
   wire [`AFIFO_IN_WIDTH-1:0]       m_af_data2_in;  // Addr FIFO data 2 in
   wire                             m_af_ready;     // Addr FIFO ready
   wire                             m_af_new_req;   // Addr FIFO new req
   wire                             m_af_dummy_req; // Addr FIFO dummy req
   wire [`AFIFO_OUT_WIDTH-1:0]      m_af_data_out;  // Addr FIFO data out
   
   wire                             m_df_push_n;    // Data FIFO push request
   wire [`DFIFO_IN_WIDTH-1:0]       m_df_data_in;   // Data FIFO data in
   wire [`DFIFO_OUT_WIDTH-1:0]      m_df_data_out;  // Data FIFO data out
   wire                             m_df_ready;     // Data FIFO ready
   wire                             m_df_uf_alert;  // Data FIFO underflow
   wire                             m_df_wr_term;   // Data FIFO write term
   
   wire                             m_rb_start;     // Read burst start
   wire                             m_rb_done;      // Read burst done
   wire                             m_rb_busy;      // AMBA BUSY
   wire                             m_rb_pop_n;     // Read Buf pop request
   wire                             m_rb_sel_buf;   // Select buf data
   wire                             m_rb_ready;     // Read Buf ready
   wire                             m_rb_overflow;  // Read Buf overflow
   
   wire                             m_two_to_one;   // 2:1 mode
   wire 			                      m_double;       // Double access flag


   //-------------------------------------------------------------------------
   // Addr FIFO
   //-------------------------------------------------------------------------
   
   assign m_af_pop_n = ! miu_burst_done;

   DW_memctl_hiu_afifo
    U_afifo(
     .hclk                    ( hclk           ),
     .hresetn                 ( hresetn        ),
     .i_push1_n               ( m_af_push1_n   ),
     .i_push2_n               ( m_af_push2_n   ),
     .i_pop_n                 ( m_af_pop_n     ),
     .i_data1                 ( m_af_data1_in  ),
     .i_data2                 ( m_af_data2_in  ),
     .o_ready                 ( m_af_ready     ),
     .hiu_req                 ( hiu_req        ),
     .o_new_req               ( m_af_new_req   ),
     .o_dummy_req             ( m_af_dummy_req ),
     .o_data                  ( m_af_data_out  ) );
      
   assign { hiu_haddr, hiu_hsize, hiu_addr, hiu_burst_size, hiu_wrap_burst, 
	    hiu_rw } = m_af_data_out;

   //-------------------------------------------------------------------------
   // Data FIFO
   //-------------------------------------------------------------------------

   DW_memctl_hiu_dfifo
    U_dfifo(
     .hclk                    ( hclk          ),
     .hresetn                 ( hresetn       ),
     .i_push_n                ( m_df_push_n   ),
     .i_pop_n                 ( miu_pop_n     ),
     .i_data                  ( m_df_data_in  ),
     .o_ready                 ( m_df_ready    ),
     .o_uflow_alert           ( m_df_uf_alert ),
     .o_wr_term               ( m_df_wr_term  ),
     .o_data                  ( m_df_data_out ),
     .big_endian              ( big_endian    ),
     .i_two_to_one            ( m_two_to_one  ) );

   assign hiu_data = m_df_data_out;

   //-------------------------------------------------------------------------
   // Read Buf
   //-------------------------------------------------------------------------

   DW_memctl_hiu_rbuf
    U_rbuf (
     .hclk                    ( hclk           ),
     .hresetn                 ( hresetn        ),
     .i_start                 ( m_rb_start     ),
     .i_done                  ( m_rb_done      ),
     .i_busy                  ( m_rb_busy      ),
     .i_push_n                ( miu_push_n     ),
     .i_pop_n                 ( m_rb_pop_n     ),
     .i_sel_buf               ( m_rb_sel_buf   ),
     .i_data                  ( miu_data       ),
     .i_two_to_one            ( m_two_to_one   ),
		 .i_double                ( m_double       ),
     .o_ready                 ( m_rb_ready     ),
     .o_overflow              ( m_rb_overflow  ),  
     .hrdata                  ( hrdata         ),
		 .big_endian              ( big_endian     ) );
   
   //-------------------------------------------------------------------------
   // Control
   //-------------------------------------------------------------------------

   DW_memctl_hiu_ctl
    U_ctl(
     .hclk                    ( hclk           ),
     .hresetn                 ( hresetn        ),
     .hsel_mem                ( hsel_mem       ),
     .hsel_reg                ( hsel_reg       ),
     .htrans                  ( htrans         ),
     .hwrite                  ( hwrite         ),
     .hsize                   ( hsize          ),
     .hburst                  ( hburst         ),
     .hready                  ( hready         ),
     .hready_resp             ( hready_resp    ),
     .hresp                   ( hresp          ),
     .haddr                   ( haddr          ),
     .hwdata                  ( hwdata         ),
     .hiu_burst_size          ( hiu_burst_size ),
     .hiu_wrap_burst          ( hiu_wrap_burst ),
		 .hiu_rw                  ( hiu_rw         ),
     .hiu_terminate           ( hiu_terminate  ),
     .miu_burst_done          ( miu_burst_done ),
     .miu_push_n              ( miu_push_n     ),
     .miu_pop_n               ( miu_pop_n      ),
     .o_two_to_one            ( m_two_to_one   ),
		 .o_double                ( m_double       ),
		 .big_endian              ( big_endian     ),
     .o_af_push1_n            ( m_af_push1_n   ),
     .o_af_push2_n            ( m_af_push2_n   ),
     .o_af_data1              ( m_af_data1_in  ),
     .o_af_data2              ( m_af_data2_in  ),
     .i_af_ready              ( m_af_ready     ),
     .i_af_new_req            ( m_af_new_req   ),
     .i_af_dummy_req          ( m_af_dummy_req ),                          
     .o_df_push_n             ( m_df_push_n    ),
     .o_df_data               ( m_df_data_in   ),
     .i_df_ready              ( m_df_ready     ),
     .i_df_uf_alert           ( m_df_uf_alert  ),
     .i_df_wr_term            ( m_df_wr_term   ),
     .o_rb_start              ( m_rb_start     ),
     .o_rb_done               ( m_rb_done      ),
     .o_rb_busy               ( m_rb_busy      ),
     .o_rb_pop_n              ( m_rb_pop_n     ),
     .o_rb_sel_buf            ( m_rb_sel_buf   ),
     .i_rb_ready              ( m_rb_ready     ),
     .i_rb_overflow           ( m_rb_overflow  ) );
   
endmodule // DW_memctl_hiu
