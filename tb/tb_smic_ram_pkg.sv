  logic [31:0]     data_mem[];  // this variable holds the whole memory content
  logic [31:0]     instr_mem[]; // this variable holds the whole memory content
  event            event_mem_load;

`ifndef HAPS
  task mem_preload;
    integer      addr;
    integer      mem_addr;
    integer      bidx;
    integer      instr_size;
    integer      instr_width;
    integer      data_size;
    integer      data_width;
    logic [31:0] data;
    string       l2_imem_file;
    string       l2_dmem_file;
    begin
      $display("Preloading SMIC RAM memory");

      instr_size   = tb.top_i.ppu_top_i.core_region_i.instr_mem.sp_ram_wrap_i.RAM_SIZE;
      instr_width = tb.top_i.ppu_top_i.core_region_i.instr_mem.sp_ram_wrap_i.DATA_WIDTH;

      data_size   = tb.top_i.ppu_top_i.core_region_i.data_mem.RAM_SIZE;
      data_width = tb.top_i.ppu_top_i.core_region_i.data_mem.DATA_WIDTH;

      instr_mem = new [instr_size/4];
      data_mem  = new [data_size/4];

      if(!$value$plusargs("l2_imem=%s", l2_imem_file))
         l2_imem_file = "slm_files/l2_stim.slm";

      $display("Preloading instruction memory from %0s", l2_imem_file);
      $readmemh(l2_imem_file, instr_mem);

      if(!$value$plusargs("l2_dmem=%s", l2_dmem_file))
         l2_dmem_file = "slm_files/tcdm_bank0.slm";

      $display("Preloading data memory from %0s", l2_dmem_file);
      $readmemh(l2_dmem_file, data_mem);

      //[31:0] mem_array[4095:0]
      // preload data memory
      for(addr = 0; addr < data_size/16; addr = addr) begin
         mem_addr = addr / (data_width/32);
         data = data_mem[addr];
         tb.top_i.ppu_top_i.core_region_i.data_mem.sp_ram_0.sp_ram_smic.mem_array[mem_addr] = data;
         addr++;
      end

      for(addr = addr; addr < (2*data_size)/16; addr = addr) begin
         mem_addr = (addr / (data_width/32)) - (data_size/16);
         data = data_mem[addr];
         tb.top_i.ppu_top_i.core_region_i.data_mem.sp_ram_1.sp_ram_smic.mem_array[mem_addr] = data;
         addr++;
      end

      for(addr = addr; addr < (3*data_size)/16; addr = addr) begin
         mem_addr = (addr / (data_width/32)) - ((2*data_size)/16);
         data = data_mem[addr];
         tb.top_i.ppu_top_i.core_region_i.data_mem.sp_ram_2.sp_ram_smic.mem_array[mem_addr] = data;
         addr++;
      end

      for(addr = addr; addr < (4*data_size)/16; addr = addr) begin
         mem_addr = (addr / (data_width/32)) - ((3*data_size)/16);
         data = data_mem[addr];
         tb.top_i.ppu_top_i.core_region_i.data_mem.sp_ram_3.sp_ram_smic.mem_array[mem_addr] = data;
         addr++;
      end

      // preload instruction memory
      for(addr = 0; addr < instr_size/16; addr = addr) begin
         mem_addr = addr / (instr_width/32);
         data = instr_mem[addr];
         tb.top_i.ppu_top_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_0.sp_ram_smic.mem_array[mem_addr] = data;
         addr++;
      end

      for(addr = addr; addr < (2*instr_size)/16; addr = addr) begin
         mem_addr = (addr / (instr_width/32)) - (instr_size/16);
         data = instr_mem[addr];
         tb.top_i.ppu_top_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_1.sp_ram_smic.mem_array[mem_addr] = data;
         addr++;
      end

      for(addr = addr; addr < (3*instr_size)/16; addr = addr) begin
         mem_addr = (addr / (instr_width/32)) - ((2*instr_size)/16);
         data = instr_mem[addr];
         tb.top_i.ppu_top_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_2.sp_ram_smic.mem_array[mem_addr] = data;
         addr++;
      end

      for(addr = addr; addr < (4*instr_size)/16; addr = addr) begin
         mem_addr = (addr / (instr_width/32)) - ((3*instr_size)/16);
         data = instr_mem[addr];
         tb.top_i.ppu_top_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_3.sp_ram_smic.mem_array[mem_addr] = data;
         addr++;
      end
    end
 endtask
`else
  task mem_preload;
    begin
      $display("Using Xilinx Block RAM...");
      $display("SPI Load is used ...");
    end
  endtask
`endif
