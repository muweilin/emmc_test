
logic [63:0]          lpddr_stim  [10000:0];
logic [31:0]          lpddr_data;
logic [31:0]          lpddr_addr;
logic [31:0]          lpddr_addr_old;
logic [31:0]          memdata_rb;

int    index = 0;
logic  more_entries = 1;

//backdoor write for sdram
task backdoor_write;
    input [31:0]    addr    ;   //must align of 4 Bytes
    input [31:0]    wrdata  ;

    reg  [13:0]     row_addr;
    reg  [ 1:0]     bank_addr;
    reg  [ 9:0]     col_addr_l;
    reg  [ 9:0]     col_addr_h;
    
begin
    // Write Data
    // write_mem({Bank_addr, Rows_addr, Cols_addr}, Dq_buf);
    
    col_addr_l ={addr[10: 2],1'b0};
    col_addr_h ={addr[10: 2],1'b1};
    bank_addr  = addr[12:11];
    row_addr   = addr[26:13];
    
    lpddr_i.write_mem({bank_addr,row_addr,col_addr_l},wrdata[15: 0]);
    lpddr_i.write_mem({bank_addr,row_addr,col_addr_h},wrdata[31:16]);    
    
end
endtask

//backdoor write for sdram
task backdoor_read;
    input [31:0]    addr    ;   //must align of 4 Bytes
    output[31:0]    rddata  ;

    reg  [13:0]     row_addr;
    reg  [ 1:0]     bank_addr;
    reg  [ 9:0]     col_addr_l;
    reg  [ 9:0]     col_addr_h;
    
begin
    // Data Buffer
    // read_mem({Bank_addr, Rows_addr, Cols_addr}, Dq_buf);
    
    col_addr_l ={addr[10: 2],1'b0}; 
    col_addr_h ={addr[10: 2],1'b1};
    bank_addr= addr[12:11];
    row_addr = addr[26:13];
    
    lpddr_i.read_mem({bank_addr,row_addr,col_addr_l},rddata[15: 0]);
    lpddr_i.read_mem({bank_addr,row_addr,col_addr_h},rddata[31:16]);
    
end
endtask

task lpddr_load;
    begin
      $readmemh("./slm_files/spi_stim.txt", lpddr_stim);  // read in the stimuli vectors  == address_value

      $display("[LPDDR] Loading DRAM (Instruction Section)");
      
      lpddr_addr  = lpddr_stim[index][63:32]; // assign address
      lpddr_addr_old = lpddr_addr - 32'h4;

      while (more_entries)                        // loop until we have no more stimuli)
      begin
        lpddr_addr  = lpddr_stim[index][63:32]; // assign address
        lpddr_data  = lpddr_stim[index][31:0];  // assign data

        if (lpddr_addr != (lpddr_addr_old + 32'h4))
        begin
          $display("[LPDDR] Prev address %h, Current address %h", lpddr_addr_old, lpddr_addr);
          $display("[LPDDE] Loading DRAM (Data Section)");
        end

        backdoor_write(lpddr_addr, lpddr_data);

        index = index + 1;             // increment stimuli
        lpddr_addr_old = lpddr_addr;
        if ( lpddr_stim[index] === 64'bx ) // make sure we have more stimuli
          more_entries = 0; 
      end                                   // end while loop
    end
  endtask

  task lpddr_check;
      begin
       index  = 0;
       more_entries = 1;
      
       $display("[LPDDR] Checking DRAM (Instruction Section)");
         
       lpddr_addr  = lpddr_stim[index][63:32]; // assign address
       lpddr_addr_old = lpddr_addr - 32'h4;
          
       while (more_entries)                        // loop until we have no more stimuli)
       begin
         lpddr_addr  = lpddr_stim[index][63:32]; // assign address
         lpddr_data  = lpddr_stim[index][31:0];  // assign data
 
         if (lpddr_addr != (lpddr_addr_old + 32'h4))
         begin
           $display("[LPDDR] Prev address %h, Current address %h", lpddr_addr_old, lpddr_addr);
           $display("[LPDDE] Checking DRAM (Data Section)");
         end
 
         backdoor_read(lpddr_addr, memdata_rb);

         if (memdata_rb != lpddr_data)
           $display("%t: [LPDDR] Readback failed, expected %X, got %X", $time, lpddr_data, memdata_rb);

         index = index + 1;             // increment stimuli
         lpddr_addr_old = lpddr_addr;
          if ( lpddr_stim[index] === 64'bx ) // make sure we have more stimuli
            more_entries = 0;
       end                                   // end while loop
      end
  endtask


