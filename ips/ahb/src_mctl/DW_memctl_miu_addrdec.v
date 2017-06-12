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
// $File: //dwh/DW_ocb/DW_memctl/amba_dev/src/DW_memctl_miu_addrdec.v $ 
// $Revision: #3 $
//
// Abstract  : This subblock generates the chip selects and address for the
// SDRAM and STTAIC RAMs depending up on the base register, block size, and
// memory type register values.
//
//============================================================================
`include "DW_memctl_params.v"
`include "DW_memctl_bcm_params.v"
`include "DW_memctl_constants.v"
module  DW_memctl_miu_addrdec ( /*AUTOARG*/
  // Outputs
  sdram_req, syncflash_req, static_mem_req, flash_access, row_addr, col_addr, 
  bank_addr, sm_addr, sm_timing_select, sdram_chip_select, sdram_select,
  sf_row_addr, sf_col_addr, sf_bank_addr, syncflash_chip_select, syncflash_select,
  static_chip_select, sdram_type, data_mask,cr_data_mask,
  // Inputs
  hclk, hresetn, remap, hiu_mem_req, h_addr, col_addr_width_prog, hiu_haddr, 
  sf_col_addr_width_prog, sf_row_addr_width_prog, sf_bank_addr_width_prog,
  hiu_hsize, row_addr_width_prog, bank_addr_width_prog, s_data_width_prog, 
  big_endian, sm_data_width_prog, mem_block_size0, mem_block_size1, 
  mem_block_size2, mem_block_size3, mem_block_size4, mem_block_size5, 
  mem_block_size6, mem_block_size7, chip_sel_reg0, chip_sel_reg1, 
  chip_sel_reg2, chip_sel_reg3, chip_sel_reg4, chip_sel_reg5, 
  chip_sel_reg6, chip_sel_reg7, alias_reg0, alias_reg1, remap_reg0, 
  remap_reg1, do_initialize
  );  


  // INPUTS DECLARATION
  input                       hclk;                // AHB Clock
  input                       hresetn;             // AHB Asynchronous reset.
  input                       remap;               // Remap signal 
  input                       hiu_mem_req;         // Memory Request
  input  [`H_ADDR_WIDTH-1:0]  h_addr;              // address bus
  input  [3:0]                hiu_haddr;           // lowest 4-bit of AHB haddr
  input  [2:0]                hiu_hsize;           // AHB hsize  
  input                       big_endian;          // big endian mode
  input  [3:0]                col_addr_width_prog; // column addr. width Params
  input  [3:0]                row_addr_width_prog; // row addr. width parameter
  input  [1:0]                bank_addr_width_prog;// bank addr. width Params
  input  [3:0]                sf_col_addr_width_prog; // SyncFlash column addr
  input  [3:0]                sf_row_addr_width_prog; // SyncFlash row addr 
  input  [1:0]                sf_bank_addr_width_prog;// SyncFlash bank addr 
  input  [1:0]                s_data_width_prog;   // SDRAM data width - bytes
  input  [2:0]                sm_data_width_prog;  // STATIC data width - bytes
  input  [10:0]               mem_block_size0;     // Block Size - Chip Select0
  input  [10:0]               mem_block_size1;     // Block Size - Chip Select1
  input  [10:0]               mem_block_size2;     // Block Size - Chip Select2
  input  [10:0]               mem_block_size3;     // Block Size - Chip Select3
  input  [10:0]               mem_block_size4;     // Block Size - Chip Select4
  input  [10:0]               mem_block_size5;     // Block Size - Chip Select5
  input  [10:0]               mem_block_size6;     // Block Size - Chip Select6
  input  [10:0]               mem_block_size7;     // Block Size - Chip Select7
  input  [`H_ADDR_WIDTH-1:11] chip_sel_reg0;       // Base  Addr - Chip Select0
  input  [`H_ADDR_WIDTH-1:11] chip_sel_reg1;       // Base  Addr - Chip Select1
  input  [`H_ADDR_WIDTH-1:11] chip_sel_reg2;       // Base  Addr - Chip Select2
  input  [`H_ADDR_WIDTH-1:11] chip_sel_reg3;       // Base  Addr - Chip Select3
  input  [`H_ADDR_WIDTH-1:11] chip_sel_reg4;       // Base  Addr - Chip Select4
  input  [`H_ADDR_WIDTH-1:11] chip_sel_reg5;       // Base  Addr - Chip Select5
  input  [`H_ADDR_WIDTH-1:11] chip_sel_reg6;       // Base  Addr - Chip Select6
  input  [`H_ADDR_WIDTH-1:11] chip_sel_reg7;       // Base  Addr - Chip Select7
  input  [`H_ADDR_WIDTH-1:11] alias_reg0;          // Alias Addr - Chip Select0
  input  [`H_ADDR_WIDTH-1:11] alias_reg1;          // Alias Addr - Chip Select1
  input  [`H_ADDR_WIDTH-1:11] remap_reg0;          // Remap Addr - Chip Select0
  input  [`H_ADDR_WIDTH-1:11] remap_reg1;          // Remap Addr - Chip Select1 
  input                       do_initialize;       // SDRAM doing initialize
  
  // OUTPUTS DECLARATION
  output                              sdram_req;          // SDRAM Request
  output                              syncflash_req;      // SyncFlash Request
  output                              static_mem_req;     // STATIC RAM Request
  output                              flash_access;       // Flash Request
  output [`MAX_S_ADDR_WIDTH-1:0]      row_addr;           // SDRAM row Addr.
  output [`MAX_S_ADDR_WIDTH-1:0]      col_addr;           // SDRAM col Addr.
  output [`MAX_S_BANK_ADDR_WIDTH-1:0] bank_addr;          // SDRAM bank Addr.
  output [`MAX_S_ADDR_WIDTH-1:0]      sf_row_addr;        // SyncFlash row Addr.
  output [`MAX_S_ADDR_WIDTH-1:0]      sf_col_addr;        // SyncFlash col Addr.
  output [`MAX_S_BANK_ADDR_WIDTH-1:0] sf_bank_addr;       // SyncFlash bank Addr.
  output [`MAX_SM_ADDR_WIDTH-1:0]     sm_addr;            // STATIC RAM Addr.
  output [1:0]                        sm_timing_select;   // Timing set chosen
  output [`N_CS-1:0]                  sdram_chip_select;  // SDRAM Chip Select
  output [`N_CS-1:0]                  syncflash_chip_select;
  output [`N_CS-1:0]                  static_chip_select; // STATIC Chip Select
  output [`N_CS-1:0]                  sdram_type;         // Memory is SDRAM
  output [7:0]                        sdram_select;       // Memory is SDRAM
  output [7:0]                        syncflash_select;   // Memory is SyncFlash
  output [`H_DATA_WIDTH/8-1:0]        data_mask;          // Memory data mask
  output [`H_DATA_WIDTH/8-1:0]        cr_data_mask;       // Register data mask

  // AMBA definitions 
  parameter      BY_TE      = 3'b000, //   8 bits, AMBA HSIZE
                 HALFWORD   = 3'b001, //  16 bits
                 WORD       = 3'b010, //  32 bits
                 DOUBLEWORD = 3'b011, //  64 bits
                 FOURWORD   = 3'b100; // 128 bits 

  // Internal signals
  
  wire [`MAX_S_ADDR_WIDTH-1:0]      col_addr;
  wire [`MAX_SM_ADDR_WIDTH-1:0]     sm_addr;
  wire [15:0]                       row_addr_mask;

  reg  [1:0]                        s_data_width_prog_buf; //  buffered version
  reg  [4:0]                        bcawp;  // bank_addr_width + col_addr_width
  reg  [4:0]                        rcawp;  // row_addr_width  + col_addr_width
  reg  [15:0]                       row_addr_tmp;
  reg  [3:0]                        bank_addr_tmp;
  reg  [7:0]                        chip_sel_tmp;
  reg  [3:0]                        bank_addr_mask;
  reg  [4:0]                        row_addr_mask_hi;
  reg  [`H_DATA_WIDTH/8-1:0]        i_data_mask;
  reg  [`H_DATA_WIDTH/8-1:0]        i2_data_mask;

  // The following two variables are made 3 bits bigger than address so
  // that 32-bit and 64-bit address equations are same. These are temporary
  // STATIC-RAM and SDRAM addresses adjusted for the data size in bytes.
  reg  [`H_ADDR_WIDTH+2:0]          sm_addr_tmp;  // STAIC
  reg  [`H_ADDR_WIDTH+2:0]          si_addr;      // SDRAM
  
  // Request generation for SDRAM and STATIC Controller
  
  // Memory Type For each chipselct
  wire [2:0] mem_type0;
  wire [2:0] mem_type1;
  wire [2:0] mem_type2;
  wire [2:0] mem_type3;
  wire [2:0] mem_type4;
  wire [2:0] mem_type5;
  wire [2:0] mem_type6;
  wire [2:0] mem_type7;

  // Static SET0, SET1, or SET2 selction each chipselct
  wire [1:0] regset_select0;
  wire [1:0] regset_select1;
  wire [1:0] regset_select2;
  wire [1:0] regset_select3;
  wire [1:0] regset_select4;
  wire [1:0] regset_select5;
  wire [1:0] regset_select6;
  wire [1:0] regset_select7;

  // One Per chipselct, which is true when the memory type is set - static
  reg [7:0] rom_select;
  reg [7:0] sram_select;
  reg [7:0] flash_select;
  reg [7:0] sdram_select;

  reg [`H_ADDR_WIDTH-1:16] mask0;
  reg [`H_ADDR_WIDTH-1:16] mask1;
  reg [`H_ADDR_WIDTH-1:16] mask2;
  reg [`H_ADDR_WIDTH-1:16] mask3;
  reg [`H_ADDR_WIDTH-1:16] mask4;
  reg [`H_ADDR_WIDTH-1:16] mask5;
  reg [`H_ADDR_WIDTH-1:16] mask6;
  reg [`H_ADDR_WIDTH-1:16] mask7;
  reg [7:0] desel;

  // One Per chipselct, this is xxx_select qualified with address decode.
  wire [7:0] rom_select_all;
  wire [7:0] sram_select_all;
  wire [7:0] flash_select_all;
  wire [7:0] sdram_select_all;

  wire [7:0] chip_select;
  wire two_to_one;

  // Redundant SyncFlash outputs (legacy code)
  assign syncflash_req = 1'b0;
  assign sf_row_addr = {`MAX_S_ADDR_WIDTH{1'b0}};
  assign sf_col_addr = {`MAX_S_ADDR_WIDTH{1'b0}};
  assign sf_bank_addr = {`MAX_S_BANK_ADDR_WIDTH{1'b0}};
  assign syncflash_chip_select = {`N_CS{1'b0}};
  assign syncflash_select = 8'b0;

  // Assign to Internal Variables For Clarity
  assign mem_type0 = mem_block_size0[7:5];
  assign mem_type1 = mem_block_size1[7:5];
  assign mem_type2 = mem_block_size2[7:5];
  assign mem_type3 = mem_block_size3[7:5];
  assign mem_type4 = mem_block_size4[7:5];
  assign mem_type5 = mem_block_size5[7:5];
  assign mem_type6 = mem_block_size6[7:5];
  assign mem_type7 = mem_block_size7[7:5];
  
  assign regset_select0 = mem_block_size0[9:8];
  assign regset_select1 = mem_block_size1[9:8];
  assign regset_select2 = mem_block_size2[9:8];
  assign regset_select3 = mem_block_size3[9:8];
  assign regset_select4 = mem_block_size4[9:8];
  assign regset_select5 = mem_block_size5[9:8];
  assign regset_select6 = mem_block_size6[9:8];
  assign regset_select7 = mem_block_size7[9:8];
 
  always @ (posedge hclk or negedge hresetn)
    begin
      if(~hresetn)
        begin
          rom_select        <= 8'h00;
          sram_select       <= 8'h00;
          flash_select      <= 8'h00;
          sdram_select      <= 8'h00;
        end
      else
        begin 
          // ROM connected to Chipselect-x is requested
          rom_select[0] <= mem_type0==3'b011 ? 1'b1 :1'b0;
          rom_select[1] <= `N_CS>1 ? (mem_type1==3'b011 ? 1'b1 : 1'b0) : 1'b0; 
          rom_select[2] <= `N_CS>2 ? (mem_type2==3'b011 ? 1'b1 : 1'b0) : 1'b0;
          rom_select[3] <= `N_CS>3 ? (mem_type3==3'b011 ? 1'b1 : 1'b0) : 1'b0;
          rom_select[4] <= `N_CS>4 ? (mem_type4==3'b011 ? 1'b1 : 1'b0) : 1'b0;
          rom_select[5] <= `N_CS>5 ? (mem_type5==3'b011 ? 1'b1 : 1'b0) : 1'b0;
          rom_select[6] <= `N_CS>6 ? (mem_type6==3'b011 ? 1'b1 : 1'b0) : 1'b0;
          rom_select[7] <= `N_CS>7 ? (mem_type7==3'b011 ? 1'b1 : 1'b0) : 1'b0;
  
          // SRAM connected to Chipselect-x is requested
          sram_select[0] <= mem_type0==3'b001 ? 1'b1 : 1'b0;
          sram_select[1] <= `N_CS>1 ? (mem_type1==3'b001 ? 1'b1 : 1'b0) : 1'b0;
          sram_select[2] <= `N_CS>2 ? (mem_type2==3'b001 ? 1'b1 : 1'b0) : 1'b0;
          sram_select[3] <= `N_CS>3 ? (mem_type3==3'b001 ? 1'b1 : 1'b0) : 1'b0;
          sram_select[4] <= `N_CS>4 ? (mem_type4==3'b001 ? 1'b1 : 1'b0) : 1'b0;
          sram_select[5] <= `N_CS>5 ? (mem_type5==3'b001 ? 1'b1 : 1'b0) : 1'b0;
          sram_select[6] <= `N_CS>6 ? (mem_type6==3'b001 ? 1'b1 : 1'b0) : 1'b0;
          sram_select[7] <= `N_CS>7 ? (mem_type7==3'b001 ? 1'b1 : 1'b0) : 1'b0;
       
          // FLASH connected to Chipselect-x is requested
          flash_select[0] <= mem_type0==3'b010 ? 1'b1 : 1'b0;
          flash_select[1] <= `N_CS>1 ? (mem_type1==3'b010 ? 1'b1 : 1'b0) : 1'b0;
          flash_select[2] <= `N_CS>2 ? (mem_type2==3'b010 ? 1'b1 : 1'b0) : 1'b0;
          flash_select[3] <= `N_CS>3 ? (mem_type3==3'b010 ? 1'b1 : 1'b0) : 1'b0;
          flash_select[4] <= `N_CS>4 ? (mem_type4==3'b010 ? 1'b1 : 1'b0) : 1'b0;
          flash_select[5] <= `N_CS>5 ? (mem_type5==3'b010 ? 1'b1 : 1'b0) : 1'b0;
          flash_select[6] <= `N_CS>6 ? (mem_type6==3'b010 ? 1'b1 : 1'b0) : 1'b0;
          flash_select[7] <= `N_CS>7 ? (mem_type7==3'b010 ? 1'b1 : 1'b0) : 1'b0;
         
          // SDRAM connected to Chipselect-x is requested
          sdram_select[0] <=  mem_type0==3'b000 ? 1'b1 : 1'b0;
          sdram_select[1] <= `N_CS>1 ? (mem_type1==3'b000 ? 1'b1 : 1'b0) : 1'b0;
          sdram_select[2] <= `N_CS>2 ? (mem_type2==3'b000 ? 1'b1 : 1'b0) : 1'b0;
          sdram_select[3] <= `N_CS>3 ? (mem_type3==3'b000 ? 1'b1 : 1'b0) : 1'b0;
          sdram_select[4] <= `N_CS>4 ? (mem_type4==3'b000 ? 1'b1 : 1'b0) : 1'b0;
          sdram_select[5] <= `N_CS>5 ? (mem_type5==3'b000 ? 1'b1 : 1'b0) : 1'b0;
          sdram_select[6] <= `N_CS>6 ? (mem_type6==3'b000 ? 1'b1 : 1'b0) : 1'b0;
          sdram_select[7] <= `N_CS>7 ? (mem_type7==3'b000 ? 1'b1 : 1'b0) : 1'b0;
        end
    end 

  // chip-select - active low
  assign chip_select[0] = (`N_CS > 1)? chip_sel_tmp[0] : 1'b0;
  assign chip_select[1] = (`N_CS > 1)? chip_sel_tmp[1] : 1'b1;
  assign chip_select[2] = (`N_CS > 2)? chip_sel_tmp[2] : 1'b1;
  assign chip_select[3] = (`N_CS > 3)? chip_sel_tmp[3] : 1'b1;
  assign chip_select[4] = (`N_CS > 4)? chip_sel_tmp[4] : 1'b1;
  assign chip_select[5] = (`N_CS > 5)? chip_sel_tmp[5] : 1'b1;
  assign chip_select[6] = (`N_CS > 6)? chip_sel_tmp[6] : 1'b1;
  assign chip_select[7] = (`N_CS > 7)? chip_sel_tmp[7] : 1'b1;

  // SDRAM related signals
  assign sdram_type         = sdram_select[`N_CS-1:0];
  assign sdram_select_all   = sdram_select[7:0] & ~chip_select[7:0];

  // STATIC RAM related signals
  assign sram_select_all    = (sram_select[7:0]  & ~chip_select[7:0]);
  assign rom_select_all     = (rom_select[7:0]   & ~chip_select[7:0]);
  assign flash_select_all   = (flash_select[7:0] & ~chip_select[7:0]);

  // ----------------------------------------------------------------------
  // Conditional pipe after address decoding
  // ---------------------------------------------------------------------- 
  wire [`N_CS-1:0]                  sdram_chip_select;
  wire [`MAX_S_ADDR_WIDTH-1:0]      row_addr;
  wire [`MAX_S_BANK_ADDR_WIDTH-1:0] bank_addr;

  wire [`N_CS-1:0]                  static_chip_select;

  // leda W563 off
  assign sdram_req             = |sdram_select_all[`N_CS-1:0] & hiu_mem_req;
  assign sdram_chip_select     = ~sdram_select_all[`N_CS-1:0];
  assign row_addr              = row_addr_tmp[`MAX_S_ADDR_WIDTH-1:0];
  assign bank_addr             = bank_addr_tmp[`MAX_S_BANK_ADDR_WIDTH-1:0];

  assign static_chip_select    = ~(sram_select_all[`N_CS-1:0] |
                                 flash_select_all[`N_CS-1:0] |
                                 rom_select_all[`N_CS-1:0]);
  assign static_mem_req        = ((|rom_select_all[`N_CS-1:0]) |
                                 (|flash_select_all[`N_CS-1:0]) |
                                 (|sram_select_all[`N_CS-1:0])) & 
                                 hiu_mem_req & ~sdram_req;
  assign sm_timing_select      = (chip_select[0]? 2'b00 : regset_select0) |
                                 (chip_select[1]? 2'b00 : regset_select1) |
                                 (chip_select[2]? 2'b00 : regset_select2) |
                                 (chip_select[3]? 2'b00 : regset_select3) |
                                 (chip_select[4]? 2'b00 : regset_select4) |
                                 (chip_select[5]? 2'b00 : regset_select5) |
                                 (chip_select[6]? 2'b00 : regset_select6) |
                                 (chip_select[7]? 2'b00 : regset_select7);
  assign flash_access          = |flash_select_all[`N_CS-1:0];
  // leda W563 on

  assign data_mask             = i2_data_mask;

  assign col_addr     = si_addr[`MAX_S_ADDR_WIDTH-1:0];
  assign sm_addr      = sm_addr_tmp[`MAX_SM_ADDR_WIDTH-1:0];
  assign cr_data_mask = i_data_mask;

  // ----------------------------------------------------------------------
  // Memory Chipselect & Addrress Generation. Only Chip-Select0 and 
  // Chip-Select1 have the remap and alias capabilities.  The Alias feature
  // is commonly used for BIOS.
  // ----------------------------------------------------------------------

  always @ (/*AUTOSENSE*/ alias_reg0 or alias_reg1
            or chip_sel_reg0 or chip_sel_reg1 or chip_sel_reg2
            or chip_sel_reg3 or chip_sel_reg4 or chip_sel_reg5
            or chip_sel_reg6 or chip_sel_reg7 or h_addr or remap
            or remap_reg0 or remap_reg1 or s_data_width_prog_buf
            or sm_data_width_prog or mask0 or mask1 or mask2 or mask3 
            or mask4 or mask5 or mask6 or mask7 or desel)
    begin

    // Chip Select Generation 

    // leda W314 off
    chip_sel_tmp[0] = (cs_gene(mask0, desel[0], chip_sel_reg0, h_addr) |
                       (remap & (`CHIP_SEL0_REMAP_ENABLE==1))) & 
                      (cs_gene(mask0, desel[0], alias_reg0, h_addr) | 
                      ~(`CHIP_SEL0_ALIAS_ENABLE==1)) &
                      (cs_gene(mask0, desel[0], remap_reg0, h_addr) |
                      ~(`CHIP_SEL0_REMAP_ENABLE==1) | ~remap); 
    chip_sel_tmp[1] = (cs_gene(mask1, desel[1], chip_sel_reg1, h_addr) |
                       (remap & (`CHIP_SEL1_REMAP_ENABLE==1))) &
                      (cs_gene(mask1, desel[1], alias_reg1, h_addr) |
                      ~(`CHIP_SEL1_ALIAS_ENABLE==1)) &
                      (cs_gene(mask1, desel[1], remap_reg1, h_addr) |
                      ~(`CHIP_SEL1_REMAP_ENABLE==1) | ~remap); 
    // leda W314 on
    chip_sel_tmp[2] =  cs_gene(mask2, desel[2], chip_sel_reg2, h_addr); 
    chip_sel_tmp[3] =  cs_gene(mask3, desel[3], chip_sel_reg3, h_addr); 
    chip_sel_tmp[4] =  cs_gene(mask4, desel[4], chip_sel_reg4, h_addr); 
    chip_sel_tmp[5] =  cs_gene(mask5, desel[5], chip_sel_reg5, h_addr); 
    chip_sel_tmp[6] =  cs_gene(mask6, desel[6], chip_sel_reg6, h_addr); 
    chip_sel_tmp[7] =  cs_gene(mask7, desel[7], chip_sel_reg7, h_addr); 
  

    // SDRAM Address Conversion 
    if(`DYNAMIC_RAM_TYPE == 1)
      case (s_data_width_prog_buf)
        2'b00   : si_addr = {3'b000, h_addr[`H_ADDR_WIDTH-1:0]};      // 16-bit
        2'b01   : si_addr = {4'b0000, h_addr[`H_ADDR_WIDTH-1:1]};     // 32-bit
        2'b10   : si_addr = {5'b00000, h_addr[`H_ADDR_WIDTH-1:2]};    // 64-bit
        default : si_addr = {6'b000000, h_addr[`H_ADDR_WIDTH-1:3]};   // 128-bit
      endcase
    else 
      case (s_data_width_prog_buf)
        2'b00   : si_addr = {4'b0000, h_addr[`H_ADDR_WIDTH-1:1]};     // 16-bit
        2'b01   : si_addr = {5'b00000, h_addr[`H_ADDR_WIDTH-1:2]};    // 32-bit
        2'b10   : si_addr = {6'b000000, h_addr[`H_ADDR_WIDTH-1:3]};   // 64-bit
        default : si_addr = {7'b0000000, h_addr[`H_ADDR_WIDTH-1:4]};  // 128-bit
      endcase
  
  
    // Static Memory Address Conversion 
    case (sm_data_width_prog)
      3'b000   : sm_addr_tmp = {3'b000,   h_addr[`H_ADDR_WIDTH-1:0]}; // 8-bit
      3'b001   : sm_addr_tmp = {4'b0000,   h_addr[`H_ADDR_WIDTH-1:1]}; // 16-bit
      3'b010   : sm_addr_tmp = {5'b00000,  h_addr[`H_ADDR_WIDTH-1:2]}; // 32-bit
      3'b011   : sm_addr_tmp = {6'b000000, h_addr[`H_ADDR_WIDTH-1:3]}; // 64-bit
      default : sm_addr_tmp = {7'b0000000,h_addr[`H_ADDR_WIDTH-1:4]}; // 128-bit
    endcase
  end
 

  // ---------------------------------------------------------
  //  SDRAM RAS/CAS/BANK Address Generation
  // ---------------------------------------------------------

  // Unused Bank and Row address bits need to be masked for the page/bank miss
  // to work correctly (all bits are being compared). 

  assign row_addr_mask = {row_addr_mask_hi, 11'b111_1111_1111};

  always @ (posedge hclk or negedge hresetn)
    begin
      if(!hresetn)
        begin
          bcawp                 <= 5'h0;
          rcawp                 <= 5'h0;
          s_data_width_prog_buf <= 2'b00;
          row_addr_mask_hi      <= 5'b11111;
          bank_addr_mask        <= 4'hF;
        end
      else
        begin
          bcawp <= {1'b0, col_addr_width_prog} + {3'b000, bank_addr_width_prog};
          rcawp <=  {1'b0, col_addr_width_prog} + {1'b0, row_addr_width_prog};
          s_data_width_prog_buf <= s_data_width_prog;

          case(bank_addr_width_prog)
            2'b00  : bank_addr_mask <= 4'b0001;
            2'b01  : bank_addr_mask <= 4'b0011;
            2'b10  : bank_addr_mask <= 4'b0111;
            default: bank_addr_mask <= 4'b1111;
          endcase

          case(row_addr_width_prog)
            4'b1010: row_addr_mask_hi <= 5'b0000_0;
            4'b1011: row_addr_mask_hi <= 5'b0000_1;
            4'b1100: row_addr_mask_hi <= 5'b0001_1;
            4'b1101: row_addr_mask_hi <= 5'b0011_1;
            4'b1110: row_addr_mask_hi <= 5'b0111_1;
            default: row_addr_mask_hi <= 5'b1111_1;
          endcase
        end  
    end  

  // Select the Bank and row address bits depending on the memeory parameters
  always @ (col_addr_width_prog or bcawp or si_addr or bank_addr_mask or 
            row_addr_mask or rcawp)
    begin

    // Bank Address bits
    if(`HIGHER_ADDR_FOR_BANKS == 0)
      begin
      case (col_addr_width_prog)
        4'b0111 : bank_addr_tmp = si_addr[11:8]  & bank_addr_mask;
        4'b1000 : bank_addr_tmp = si_addr[12:9]  & bank_addr_mask;
        4'b1001 : bank_addr_tmp = si_addr[13:10] & bank_addr_mask;
        4'b1010 : bank_addr_tmp = si_addr[14:11] & bank_addr_mask;
        4'b1011 : bank_addr_tmp = si_addr[15:12] & bank_addr_mask;
        4'b1100 : bank_addr_tmp = si_addr[16:13] & bank_addr_mask;
        4'b1101 : bank_addr_tmp = si_addr[17:14] & bank_addr_mask;
        default : bank_addr_tmp = si_addr[18:15] & bank_addr_mask;
      endcase
      end
    else
      begin
      case (rcawp)
        5'b10001 : bank_addr_tmp = si_addr[22:19]  & bank_addr_mask;
        5'b10010 : bank_addr_tmp = si_addr[23:20]  & bank_addr_mask;
        5'b10011 : bank_addr_tmp = si_addr[24:21]  & bank_addr_mask;
        5'b10100 : bank_addr_tmp = si_addr[25:22]  & bank_addr_mask;
        5'b10101 : bank_addr_tmp = si_addr[26:23]  & bank_addr_mask;
        5'b10110 : bank_addr_tmp = si_addr[27:24]  & bank_addr_mask;
        5'b10111 : bank_addr_tmp = si_addr[28:25]  & bank_addr_mask;
        5'b11000 : bank_addr_tmp = si_addr[29:26]  & bank_addr_mask;
        5'b11001 : bank_addr_tmp = si_addr[30:27]  & bank_addr_mask;
        5'b11010 : bank_addr_tmp = si_addr[31:28]  & bank_addr_mask;
        5'b11011 : bank_addr_tmp = si_addr[32:29]  & bank_addr_mask;
        5'b11100 : bank_addr_tmp = si_addr[33:30]  & bank_addr_mask;
        default  : bank_addr_tmp = si_addr[34:31]  & bank_addr_mask;
      endcase
      end

 
    //  Row Address bits 
    if(`HIGHER_ADDR_FOR_BANKS == 0)
      begin
      case (bcawp)
        5'b00111 : row_addr_tmp = si_addr[24:9]  & row_addr_mask;
        5'b01000 : row_addr_tmp = si_addr[25:10] & row_addr_mask; 
        5'b01001 : row_addr_tmp = si_addr[26:11] & row_addr_mask;
        5'b01010 : row_addr_tmp = si_addr[27:12] & row_addr_mask;
        5'b01011 : row_addr_tmp = si_addr[28:13] & row_addr_mask;
        5'b01100 : row_addr_tmp = si_addr[29:14] & row_addr_mask;
        5'b01101 : row_addr_tmp = si_addr[30:15] & row_addr_mask;
        5'b01110 : row_addr_tmp = si_addr[31:16] & row_addr_mask;
        5'b01111 : row_addr_tmp = si_addr[32:17] & row_addr_mask;
        5'b10000 : row_addr_tmp = si_addr[33:18] & row_addr_mask;
        default  : row_addr_tmp = si_addr[34:19] & row_addr_mask;
      endcase      
      end
    else 
      begin
      case (col_addr_width_prog) 
        4'b0111 : row_addr_tmp = si_addr[23:8]  & row_addr_mask;
        4'b1000 : row_addr_tmp = si_addr[24:9]  & row_addr_mask;
        4'b1001 : row_addr_tmp = si_addr[25:10] & row_addr_mask;
        4'b1010 : row_addr_tmp = si_addr[26:11] & row_addr_mask;
        4'b1011 : row_addr_tmp = si_addr[27:12] & row_addr_mask;
        4'b1100 : row_addr_tmp = si_addr[28:13] & row_addr_mask;
        4'b1101 : row_addr_tmp = si_addr[29:14] & row_addr_mask;
        default : row_addr_tmp = si_addr[30:15] & row_addr_mask;
      endcase
      end
       
  end 


  // -------------------------
  // Data mask generation
  // -------------------------
  // leda W163 off
  always @(hiu_hsize or hiu_haddr or big_endian) begin
    if(~big_endian) begin // Little Endian
      if(`H_DATA_WIDTH == 32)
        case(hiu_hsize)
          BY_TE:    i_data_mask = 4'hF ^ (4'h1 << hiu_haddr[1:0]);
          HALFWORD: i_data_mask = 4'hF ^ (4'h3 << hiu_haddr[1:0]);
          default:  i_data_mask = 4'h0; // WORD
        endcase
      else if(`H_DATA_WIDTH == 64)
        case(hiu_hsize)
          BY_TE:    i_data_mask = 8'hFF ^ (8'h01 << hiu_haddr[2:0]);
          HALFWORD: i_data_mask = 8'hFF ^ (8'h03 << hiu_haddr[2:0]);
          WORD:     i_data_mask = 8'hFF ^ (8'h0F << hiu_haddr[2:0]);
          default:  i_data_mask = 8'h00; // DOUBLEWORD
        endcase
      else // if(`H_DATA_WIDTH == 128)
        case(hiu_hsize)
          BY_TE:      i_data_mask = 16'hFFFF ^ (16'h0001 << hiu_haddr[3:0]);
          HALFWORD:   i_data_mask = 16'hFFFF ^ (16'h0003 << hiu_haddr[3:0]);
          WORD:       i_data_mask = 16'hFFFF ^ (16'h000F << hiu_haddr[3:0]);
          DOUBLEWORD: i_data_mask = 16'hFFFF ^ (16'h00FF << hiu_haddr[3:0]);
          default:    i_data_mask = 16'h0000; // 4word
        endcase
    end
    else begin // Big Endian
      if(`H_DATA_WIDTH == 32)
        case(hiu_hsize)
          BY_TE:    i_data_mask = 4'hF ^ (4'h8 >> hiu_haddr[1:0]);
          HALFWORD: i_data_mask = 4'hF ^ (4'hC >> hiu_haddr[1:0]);
          default:  i_data_mask = 4'h0; // WORD
        endcase
      else if(`H_DATA_WIDTH == 64)
        case(hiu_hsize)
          BY_TE:    i_data_mask = 8'hFF ^ (8'h80 >> hiu_haddr[2:0]);
          HALFWORD: i_data_mask = 8'hFF ^ (8'hC0 >> hiu_haddr[2:0]);
          WORD:     i_data_mask = 8'hFF ^ (8'hF0 >> hiu_haddr[2:0]);
          default:  i_data_mask = 8'h00; // DOUBLEWORD
        endcase
      else // if(`H_DATA_WIDTH == 128)
        case (hiu_hsize)
          BY_TE:      i_data_mask = 16'hFFFF ^ (16'h8000 >> hiu_haddr[3:0]);
          HALFWORD:   i_data_mask = 16'hFFFF ^ (16'hC000 >> hiu_haddr[3:0]);
          WORD:       i_data_mask = 16'hFFFF ^ (16'hF000 >> hiu_haddr[3:0]);
          DOUBLEWORD: i_data_mask = 16'hFFFF ^ (16'hFF00 >> hiu_haddr[3:0]);
          default:    i_data_mask = 16'h0000; // 4word
        endcase
    end
  end   
  // leda W163 on

  assign two_to_one    = `H_DATA_WIDTH == 32 ? ! s_data_width_prog[0] :
                         `H_DATA_WIDTH == 64 ? s_data_width_prog[0] :
                                               ! s_data_width_prog[0];

  `define BYT_CNT `H_DATA_WIDTH/8
  `define WRD_CNT `H_DATA_WIDTH/16

  always @(hiu_haddr or big_endian or two_to_one or i_data_mask) begin
    if(~big_endian) begin // Little Endian
      if(`H_DATA_WIDTH == 32)
        i2_data_mask = !two_to_one  ? i_data_mask :
                       hiu_haddr[1] ? {2'b11, i_data_mask[`BYT_CNT-1:`WRD_CNT]} : 
                                      {2'b11, i_data_mask[`WRD_CNT-1:0]};
      else if(`H_DATA_WIDTH == 64)
        i2_data_mask = !two_to_one  ? i_data_mask :
                       hiu_haddr[2] ? {4'hF, i_data_mask[`BYT_CNT-1:`WRD_CNT]} :
                                      {4'hF, i_data_mask[`WRD_CNT-1:0]};
      else // if(`H_DATA_WIDTH == 128)
        i2_data_mask = !two_to_one  ? i_data_mask :
                       hiu_haddr[3] ? {8'hFF, i_data_mask[`BYT_CNT-1:`WRD_CNT]} : 
                                      {8'hFF, i_data_mask[`WRD_CNT-1:0]};
    end
    else begin // Big Endian
      if(`H_DATA_WIDTH == 32)
        i2_data_mask = !two_to_one  ? i_data_mask :
                       hiu_haddr[1] ? {2'b11, i_data_mask[`WRD_CNT-1:0]} : 
                                      {2'b11, i_data_mask[`BYT_CNT-1:`WRD_CNT]};
      else if(`H_DATA_WIDTH == 64)
        i2_data_mask = !two_to_one  ? i_data_mask :
                       hiu_haddr[2] ? {4'hF, i_data_mask[`WRD_CNT-1:0]} : 
                                      {4'hF, i_data_mask[`BYT_CNT-1:`WRD_CNT]};
      else // if(`H_DATA_WIDTH == 128)
        i2_data_mask = !two_to_one  ? i_data_mask :
                       hiu_haddr[3] ? {8'hFF, i_data_mask[`WRD_CNT-1:0]} :
                                      {8'hFF, i_data_mask[`BYT_CNT-1:`WRD_CNT]};
    end
  end


  // -------------------
  // FUNCTIONS 
  // -------------------

  // Mask Signals for the lower address bits depending on the block size.
  // MaskLowAddr will be almost a static signal and likely to be valid before
  // the address arrives and will help to improve chip-select timing

  function [31:16] MaskLowAddr;
    input [4:0] block_size;

    begin
    case (block_size)
      5'b00000 : MaskLowAddr = 16'hffff;              // Disabled - Don't Care
      5'b00001 : MaskLowAddr = 16'hffff;              //  64KB
      5'b00010 : MaskLowAddr = 16'hfffe;              //  128KB
      5'b00011 : MaskLowAddr = 16'hfffc;              //  256KB
      5'b00100 : MaskLowAddr = 16'hfff8;              //  512MB
      5'b00101 : MaskLowAddr = 16'hfff0;              //  1MB
      5'b00110 : MaskLowAddr = 16'hffe0;              //  2MB
      5'b00111 : MaskLowAddr = 16'hffc0;              //  4MB
      5'b01000 : MaskLowAddr = 16'hff80;              //  8MB
      5'b01001 : MaskLowAddr = 16'hff00;              //  16MB
      5'b01010 : MaskLowAddr = 16'hfe00;              //  32MB
      5'b01011 : MaskLowAddr = 16'hfc00;              //  64MB
      5'b01100 : MaskLowAddr = 16'hf800;              //  128MB
      5'b01101 : MaskLowAddr = 16'hf000;              //  256MB
      5'b01110 : MaskLowAddr = 16'he000;              //  512MB
      5'b01111 : MaskLowAddr = 16'hc000;              //  1GB
      5'b10000 : MaskLowAddr = 16'h8000;              //  2GB
      default  : MaskLowAddr = 16'h0000;              //  4GB
    endcase
    end
  endfunction // MaskLowAddr 


  always @ (posedge hclk or negedge hresetn)
    begin
      if(~hresetn)
        begin
          desel <= 8'h00;
          mask0 <= 0;
          mask1 <= 0;
          mask2 <= 0;
          mask3 <= 0;
          mask4 <= 0;
          mask5 <= 0;
          mask6 <= 0;
          mask7 <= 0;
        end
      else 
        begin
          desel <= {(mem_block_size7[4:0] == 5'b00000),
                    (mem_block_size6[4:0] == 5'b00000),
                    (mem_block_size5[4:0] == 5'b00000),
                    (mem_block_size4[4:0] == 5'b00000),
                    (mem_block_size3[4:0] == 5'b00000),
                    (mem_block_size2[4:0] == 5'b00000),
                    (mem_block_size1[4:0] == 5'b00000),
                    (mem_block_size0[4:0] == 5'b00000)};
          mask0 <= MaskLowAddr(mem_block_size0[4:0]);
          mask1 <= MaskLowAddr(mem_block_size1[4:0]);
          mask2 <= MaskLowAddr(mem_block_size2[4:0]);
          mask3 <= MaskLowAddr(mem_block_size3[4:0]);
          mask4 <= MaskLowAddr(mem_block_size4[4:0]);
          mask5 <= MaskLowAddr(mem_block_size5[4:0]);
          mask6 <= MaskLowAddr(mem_block_size6[4:0]);
          mask7 <= MaskLowAddr(mem_block_size7[4:0]);
        end
    end
 
 

  // ------------------------------------ 
  // Chip Select Generation Comparator
  // ------------------------------------ 

  function cs_gene;

   input [`H_ADDR_WIDTH-1:16] mask;         // host address mask
   input                      desel_bank; // desel bank select
   input [`H_ADDR_WIDTH-1:11] regi;         // chip select register
   input  [`H_ADDR_WIDTH-1:0] addr;         // host address

   begin
     cs_gene = desel_bank | (|((regi[`H_ADDR_WIDTH-1:16] & mask) ^
                               (addr[`H_ADDR_WIDTH-1:16] & mask)));
   end
  endfunction // Chip Select Generation

endmodule // DW_memctl_miu_addrdecoder
