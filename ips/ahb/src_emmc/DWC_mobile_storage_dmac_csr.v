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
// Date             :        $Date: 2013/05/27 $
// Revision: $Id: //dwh/mcards_iip/dev/sdmmc/DW_sd_mmc/ver/src/DWC_mobile_storage_dmac_csr.v#21 $
//--                                                                        
//--------------------------------------------------------------------------
//-- MODULE: DWC_mobile_storage_dmac_csr
//--
//-- DESCRIPTION: This is the CSR for the Internal DMAC
//--              This contains the status and control registers for DMAC.
//--
//--              The DMAC CSR consists of a native APB like interface to access
//--              the registers.
//--
//----------------------------------------------------------------------------
`include "DWC_mobile_storage_params.v"
`include "DWC_mobile_storage_derived_params.v"
module DWC_mobile_storage_dmac_csr(
  // Outputs
  dmac_intr_o, dmac_csr_rdata_o, dmac_csr_sel_o, dmac_en_o, fixed_burst_o,
  swr_rst_o, poll_dmnd_o, dsc_list_start_o, dsc_skp_len_o, card_err_sumry_o,
  dmac_debug_reg,

  // Inputs
  clk, reset_n, dmac_csr_psel_i, dmac_csr_penable_i, dmac_csr_paddr_i, 
  dmac_csr_pben_i, dmac_csr_pwrite_i, dmac_csr_wdata_i, pbl_i, fsm_state_i,
  fbe_code_i, fbe_i, desc_unavail_i, /*dir_bit_err_i,*/ rx_int_i, tx_int_i,
  curr_desc_addr_i, curr_buf_addr_i, card_err_sumry_i, update_status_i,
  scan_mode
  );

  // --------------------------------------
  // Input and Output Port Declaration
  // --------------------------------------         

  // Host Clock and Reset
  input                        clk;                // System Clock 
  input                        reset_n;            // System Reset - Active Low

  // Interface to DMAC_IF
  output   [`H_DATA_WIDTH-1:0] dmac_csr_rdata_o;   // Register Read Data
  output                       dmac_csr_sel_o;     // Select signal  

  // Interface to AHB2APB
  input                        dmac_csr_psel_i;    // Select
  input                        dmac_csr_penable_i; // Enable
  input    [`H_ADDR_WIDTH-1:0] dmac_csr_paddr_i;   // Register Address
  input  [`H_DATA_WIDTH/8-1:0] dmac_csr_pben_i;    // Byte Enable
  input                        dmac_csr_pwrite_i;  // Register Write/Read
  input    [`H_DATA_WIDTH-1:0] dmac_csr_wdata_i;   // Register Write Data

  // Interface to BIU 
  input                 [2:0]  pbl_i;              // Programmable Burst Length

  // Interface to DMAC CNTRL
  output                       dmac_en_o;          // DMAC Enable bit
  output                       fixed_burst_o;      // Fixed burst indication
  output                       swr_rst_o;          // Software reset
  output                       poll_dmnd_o;        // Poll Demand pulse
  output  [`M_ADDR_WIDTH-1:0]  dsc_list_start_o;   // Descriptor list start addr
  output                [4:0]  dsc_skp_len_o;      // Descriptor skip length
  output                       card_err_sumry_o;   // Card error summary output

  input                 [3:0]  fsm_state_i;        // FSM state for Debug
  input                 [2:0]  fbe_code_i;         // Fatal Bus Error code
  input                        fbe_i;              // Fatal Bus Error interrupt
  input                        desc_unavail_i;     // Desc unavailable interrupt
//input                        dir_bit_err_i;      // Direction bit error
  input                        rx_int_i;           // Receive interrupt
  input                        tx_int_i;           // Transmit interrupt
  input  [`M_ADDR_WIDTH-1:0]   curr_desc_addr_i;   // Current Descriptor address
  input  [`M_ADDR_WIDTH-1:0]   curr_buf_addr_i;    // Current Buffer Address
  input                        card_err_sumry_i;   // Card Error Summary
  input                        update_status_i;    // Update status register pulse

  // Interrupt
  output                       dmac_intr_o;        // Interrupt signal

  // Debug port
`ifdef M_ADDR_WIDTH_32
  output              [191:0]  dmac_debug_reg;     // Debug registers port
`else  //64-bit address bus
  output             [287:0] dmac_debug_reg;
`endif







  input                        scan_mode;          // Scan mode

  // --------------------------------------
  // Reg/Wire Declaration
  // --------------------------------------

  // Flip-Flops
  reg               [31:0] bus_mode_reg_r;        // Bus-mode Reg
  reg  [`M_ADDR_WIDTH-1:0] dsc_list_start_reg_r;  // Desc Start addr Reg
  reg               [31:0] status_reg_r;          // Status Reg
  reg               [31:0] intr_en_reg_r;         // Intr En Reg
  reg                      poll_dmnd_reg_r;       // Poll Demand Reg
  reg  [`H_DATA_WIDTH-1:0] dmac_csr_rdata_r;      // Read Data Reg

  //Reg Nets
  reg               [63:0] regb_wdata;            // Write data
  reg                [7:0] byte_en;               // Byte enable
  reg               [63:0] mux_rdata;             // Register Read before mux

  //Wires
  wire              [31:0] bus_mode_reg;          // Bus-mode Reg net 
  wire [`M_ADDR_WIDTH-1:0] desc_list_start_reg;   // Desc Start addr Reg net
  wire              [31:0] status_reg;            // Status Reg net
  wire              [31:0] intr_en_reg;           // Intr En Reg net
  wire [`M_ADDR_WIDTH-1:0] curr_desc_addr_reg;    // Curr Desc Addr
  wire [`M_ADDR_WIDTH-1:0] curr_buf_addr_reg;     // Curr Buffer Addr

  wire                     dmac_csr_write_cond;   //CSR Write
  //wire                     dmac_csr_read_cond;    //CSR Read Condition

  wire                     abnrml_intry_smry_cond; //Abnormal intr Condition
  wire                     nrml_intry_smry_cond;   //Normal intr Condition
  wire               [7:0] ipbe;                   // Byte enable
`ifdef M_ADDR_WIDTH_32
  wire             [191:0] dmac_debug_reg;
`else  //64-bit address bus
  wire             [287:0] dmac_debug_reg;
`endif
  //Outputs 

  assign dmac_intr_o   = |status_reg_r[5:0];

 `ifdef M_ADDR_WIDTH_32
 assign dmac_csr_sel_o =  dmac_csr_psel_i && !(|dmac_csr_paddr_i[`H_ADDR_WIDTH-1:8]) &&
                          dmac_csr_paddr_i[7:5] == 3'b100 &&
                          dmac_csr_paddr_i[4:2] != 3'b111;
 `else
 assign dmac_csr_sel_o = dmac_csr_psel_i && !(|dmac_csr_paddr_i[`H_ADDR_WIDTH-1:8]) &&
                          //(dmac_csr_paddr_i[7:5] == 3'b100 ||( dmac_csr_paddr_i[7:4] == 3'b1010) && dmac_csr_paddr_i[3]!=1'b1); //  &&
                           (dmac_csr_paddr_i[7:0] > 8'h7f && dmac_csr_paddr_i[7:0] < 8'hA8); 
                          // dmac_csr_paddr_i[4:2] != 3'b111;
 `endif

  assign dsc_list_start_o = dsc_list_start_reg_r;


  assign dmac_csr_rdata_o = dmac_csr_rdata_r;

  assign swr_rst_o     = bus_mode_reg_r[0];
  assign fixed_burst_o = bus_mode_reg_r[1];
  assign dsc_skp_len_o = bus_mode_reg_r[6:2];
  assign dmac_en_o     = bus_mode_reg_r[7];
  assign poll_dmnd_o   = poll_dmnd_reg_r;

  assign card_err_sumry_o = status_reg_r[5];

  assign dmac_debug_reg = {bus_mode_reg,
                           desc_list_start_reg,
                           status_reg,
                           intr_en_reg,
                           curr_desc_addr_reg,
                           curr_buf_addr_reg};
  //Write & Read conditions

  assign dmac_csr_write_cond = dmac_csr_psel_i & dmac_csr_penable_i &
                                    dmac_csr_pwrite_i;

  //assign dmac_csr_read_cond = dmac_csr_psel_i & dmac_csr_penable_i &
  //                                  ~dmac_csr_pwrite_i;

  // Register Read Data Corrected to H_DATA_WIDTH
  always @ (posedge clk or negedge reset_n)
    begin
      if(reset_n == 1'b0)
        dmac_csr_rdata_r <= {`H_DATA_WIDTH{1'b0}};
      else begin
        if(`H_DATA_WIDTH == 16) begin
          case(dmac_csr_paddr_i[2:1])
            2'b00   : dmac_csr_rdata_r <= mux_rdata[15:0];
            2'b01   : dmac_csr_rdata_r <= mux_rdata[31:16];
            2'b10   : dmac_csr_rdata_r <= mux_rdata[47:32];
            default : dmac_csr_rdata_r <= mux_rdata[63:48];
          endcase
        end
        else if(`H_DATA_WIDTH == 32) begin
          case(dmac_csr_paddr_i[2])
            1'b0    : dmac_csr_rdata_r <= mux_rdata[31:0];
            default : dmac_csr_rdata_r <= mux_rdata[63:32];
          endcase
        end
        else
          dmac_csr_rdata_r <= mux_rdata;
      end
  end

  // Register read data. Read-data is supplied in such a way that DC will
  // optimize unused register bits depending upon configuration 
  always @ ( dmac_csr_paddr_i
            or bus_mode_reg or status_reg 
            or desc_list_start_reg or curr_desc_addr_reg
            or intr_en_reg or curr_buf_addr_reg )
    begin
   `ifdef M_ADDR_WIDTH_32
      case(dmac_csr_paddr_i[7:3])
        5'h10  : mux_rdata  = {32'h0,bus_mode_reg};
        5'h11  : mux_rdata  = {status_reg,desc_list_start_reg};
        5'h12  : mux_rdata  = {curr_desc_addr_reg,intr_en_reg};
        default: mux_rdata  = {32'h0, curr_buf_addr_reg}; 
      endcase
    `else  // 64-bit configuration selected
      case(dmac_csr_paddr_i[7:3])
        5'h10  : mux_rdata  = {32'h0,bus_mode_reg};
        5'h11  : mux_rdata  = {desc_list_start_reg};
        5'h12  : mux_rdata  = {intr_en_reg,status_reg};
        5'h13  : mux_rdata  = {curr_desc_addr_reg};
        default: mux_rdata  = {curr_buf_addr_reg}; 
      endcase
     `endif
    end

  //Bus Mode register 
  assign bus_mode_reg = {21'h0,pbl_i,bus_mode_reg_r[7:0]};

  //Descriptor Start address list register
  assign desc_list_start_reg = dsc_list_start_reg_r;

  //Status register
  assign status_reg = {15'h0,fsm_state_i,status_reg_r[12:8],
                             2'b00,status_reg_r[5:0]};

  //Interrupt enable register
  assign intr_en_reg = {22'b0,intr_en_reg_r[9:0]};

  //Current Descriptor Address register
  assign curr_desc_addr_reg = curr_desc_addr_i;
  //Currrent Buffer address register
  assign curr_buf_addr_reg = curr_buf_addr_i;
                             

  assign nrml_intry_smry_cond = (tx_int_i & intr_en_reg_r[0]) |
                                (rx_int_i & intr_en_reg_r[1]); 
  
  assign abnrml_intry_smry_cond = (fbe_i & intr_en_reg_r[2])        |
  //                              (dir_bit_err_i & intr_en_reg_r[3]) |
                                  (desc_unavail_i & intr_en_reg_r[4]);

  assign ipbe = dmac_csr_pben_i;

 // Register Byte Enable Control & Register Write-Data
  always @ (ipbe or dmac_csr_paddr_i or dmac_csr_pben_i or dmac_csr_wdata_i)
    begin
      if(`H_DATA_WIDTH == 16) 
        begin
          case(dmac_csr_paddr_i[2:1])
            2'b00   : byte_en = 8'b0000_0011 & {4{dmac_csr_pben_i[1:0]}};
            2'b01   : byte_en = 8'b0000_1100 & {4{dmac_csr_pben_i[1:0]}};
            2'b10   : byte_en = 8'b0011_0000 & {4{dmac_csr_pben_i[1:0]}};
            default : byte_en = 8'b1100_0000 & {4{dmac_csr_pben_i[1:0]}};
          endcase
          regb_wdata = {4{dmac_csr_wdata_i[`H_DATA_WIDTH-1:0]}};
        end
      else if(`H_DATA_WIDTH == 32) 
        begin
          case(dmac_csr_paddr_i[2])
            1'b0    : byte_en = 8'b0000_1111 & {2{ipbe[3:0]}};
            default : byte_en = 8'b1111_0000 & {2{ipbe[3:0]}};
          endcase
          regb_wdata = {2{dmac_csr_wdata_i[`H_DATA_WIDTH-1:0]}};
        end

      else //  H_DATA_WIDTH = 64 
        begin
          byte_en = dmac_csr_pben_i;
          regb_wdata = dmac_csr_wdata_i[`H_DATA_WIDTH-1:0];
        end
    end
                                  

  // Register writes. Bus mode, Interrupt, Status , Descriptor list Registers
  // DC will optimize the unused bits
  always @ (posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          bus_mode_reg_r        <= 32'h0;
          poll_dmnd_reg_r       <= 1'b0;
          dsc_list_start_reg_r  <= {`M_ADDR_WIDTH{1'b0}};
          status_reg_r          <= 32'h0;
          intr_en_reg_r         <= 32'h0;
         end
      else
        begin

  //Internal writes
          if(bus_mode_reg_r[0])
            bus_mode_reg_r <= 1'b0;

          if(poll_dmnd_reg_r) 
            poll_dmnd_reg_r <= 1'b0;

          if(update_status_i) begin
            // TX interrupt
            if (tx_int_i & intr_en_reg_r[0])
              status_reg_r[0] <= 1'b1;
            // RX interrupt
            if (rx_int_i & intr_en_reg_r[1]) 
              status_reg_r[1] <= 1'b1;

            // FBE interrupt & FBE Code
            if (fbe_i & intr_en_reg_r[2]) begin
              status_reg_r[2] <= 1'b1;
              status_reg_r[12:10] <= fbe_code_i;
            end

            // Dir bit error interrupt
            //if (dir_bit_err_i & intr_en_reg_r[3])
            //  status_reg_r[3] <= 1'b1;
            // Descriptor Unavailable interrupt
            if (desc_unavail_i & intr_en_reg_r[4])
              status_reg_r[4] <= 1'b1;
            // Care error summary interrupt
            if (card_err_sumry_i & intr_en_reg_r[5])
              status_reg_r[5] <= 1'b1;
          end // if (update_status_i)

          // Normal interrupt summary
          if (nrml_intry_smry_cond & intr_en_reg_r[8]) 
            status_reg_r[8] <= 1'b1;

          // AbNormal interrupt summary
          if (abnrml_intry_smry_cond & intr_en_reg_r[9]) 
            status_reg_r[9] <= 1'b1;
          
 //Writes from AHB 
          if(dmac_csr_write_cond & !(|dmac_csr_paddr_i[`H_ADDR_WIDTH-1:8]) & dmac_csr_paddr_i[7]) begin
            case(dmac_csr_paddr_i[6:3])
              4'h0 : begin 

                if(|byte_en[7:4]) 
                  poll_dmnd_reg_r <= 1'b1;

                if(byte_en[0]) 
                  bus_mode_reg_r[7:0] <= regb_wdata[7:0]; 
              end 

//******************************************************************
//Addresses are different for 32-bit configuration and 64-bit configuration
//############# 32-bit Configuration:####################
//     		Register  : Offset  ADDR[7:3]
//      	BMOD      : 0x80    --> h10
//[W-only]      POLDMD    : 0x84
//		DBADDR    : 0x88    --> h11
//		IDSTS     : 0x8C
//		IDINTEN   : 0x90    --> h12
//[R-only]	DSCDADDR  : 0x94
//[R-only]	BUFADDR   : 0x98    --> h13
//
//
//
//############# 64 bit Configuration ######################
//     		Register  : Offset  ADDR[7:3]
//      	BMOD      : 0x80    --> h10
//[W-only]      POLDMD    : 0x84
//		DBADDRL   : 0x88    --> h11
//		DBADDRU   : 0x8C    
//		IDSTS     : 0x90    --> h12
//		IDINTEN   : 0x94    
//[R-only]	DSCDADDRL : 0x98    --> h13
//[R-only]	DSCDADDRU : 0x9C
//[R-only]	BUFADDRL  : 0xA0    --> h14
//[R-only]	BUFADDRU  : 0xA4   
//******************************************************************************

   `ifdef M_ADDR_WIDTH_32

              4'h1 : begin

    //If there is a simultaneous internal update and 
  //AHB access to status register, the internal 
  //update will get priority
                if (!update_status_i) begin
                  if(byte_en[7])
                    status_reg_r[31:24] <= regb_wdata[63:56];
                  if(byte_en[6])
                    status_reg_r[23:16] <= regb_wdata[55:48];
                  if(byte_en[5]) begin
                    status_reg_r[15:13] <= regb_wdata[47:43];
                    status_reg_r[9:8] <= status_reg_r[9:8] & ~(regb_wdata[41:40]); 
                  end
                  if(byte_en[4]) begin
                    status_reg_r[7:6] <= regb_wdata[39:38];
                    status_reg_r[5:0] <= status_reg_r[5:0] & ~(regb_wdata[37:32]); 
                  end
                end
                
                if(byte_en[3]) 
                  dsc_list_start_reg_r[31:24] <= regb_wdata[31:24]; 

                if(byte_en[2]) 
                  dsc_list_start_reg_r[23:16] <= regb_wdata[23:16]; 

                if(byte_en[1]) 
                  dsc_list_start_reg_r[15:8]  <= regb_wdata[15:8]; 

                if(byte_en[0]) 
                  dsc_list_start_reg_r[7:0]   <= regb_wdata[7:0]; 

              end 

              4'h2 : begin

                if(byte_en[3]) 
                  intr_en_reg_r[31:24] <= regb_wdata[31:24]; 
                if(byte_en[2]) 
                  intr_en_reg_r[23:16] <= regb_wdata[23:16]; 
                if(byte_en[1]) 
                  intr_en_reg_r[15:8] <= regb_wdata[15:8]; 
                if(byte_en[0]) 
                  intr_en_reg_r[7:0] <= regb_wdata[7:0]; 
              end 
            endcase

   `else
              4'h1 :
                begin
                  if(byte_en[7])
                    dsc_list_start_reg_r[63:56]   <= regb_wdata[63:56]; 
                  if(byte_en[6])
                    dsc_list_start_reg_r[55:48]   <= regb_wdata[55:48]; 
                  if(byte_en[5]) 
                    dsc_list_start_reg_r[47:40]   <= regb_wdata[47:40]; 
                  if(byte_en[4])
                    dsc_list_start_reg_r[39:32]   <= regb_wdata[39:32]; 

                  if(byte_en[3]) 
                    dsc_list_start_reg_r[31:24] <= regb_wdata[31:24]; 
                  if(byte_en[2]) 
                    dsc_list_start_reg_r[23:16] <= regb_wdata[23:16]; 
                  if(byte_en[1]) 
                    dsc_list_start_reg_r[15:8]  <= regb_wdata[15:8]; 
                  if(byte_en[0]) 
                    dsc_list_start_reg_r[7:0]   <= regb_wdata[7:0]; 

              end 
              4'h2 :
                begin
                  if(byte_en[7]) 
                    intr_en_reg_r[31:24] <= regb_wdata[63:56]; 
                  if(byte_en[6]) 
                    intr_en_reg_r[23:16] <= regb_wdata[55:48]; 
                  if(byte_en[5]) 
                    intr_en_reg_r[15:8] <= regb_wdata[47:40]; 
                  if(byte_en[4]) 
                    intr_en_reg_r[7:0] <= regb_wdata[39:32]; 

    //If there is a simultaneous internal update and 
  //AHB access to status register, the internal 
  //update will get priority
                if (!update_status_i) 
                  begin

                    if(byte_en[3])
                      status_reg_r[31:24] <= regb_wdata[31:24];
                    if(byte_en[2])
                      status_reg_r[23:16] <= regb_wdata[23:16];
                    if(byte_en[1]) 
                      begin
                        status_reg_r[15:13] <= regb_wdata[15:13];
                        status_reg_r[9:8] <= status_reg_r[9:8] & ~(regb_wdata[9:8]); 
                      end
                    if(byte_en[0])
                       begin
                         status_reg_r[7:6] <= regb_wdata[7:6];
                         status_reg_r[5:0] <= status_reg_r[5:0] & ~(regb_wdata[5:0]); 
                       end
                  end
                end
             endcase
     `endif
          end
        end
      end

endmodule // 



