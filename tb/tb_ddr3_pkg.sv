
logic [63:0]          ddr3_stim  [10000:0];
int                   index = 0;
logic                 more_inst =1;
logic                 more_data =1;
logic [31:0]          memdata_rb;


//backdoor write for sdram
task backdoor_write;
    input [31:0]    addr   ; 
//    input [2 * BL_MAX * DQ_BITS - 1 : 0]    wrdata ; //BL_MAX = 8; DQ_BITS = 16
    input [255 : 0]    wrdata ; 

    reg  [2 : 0]  bank_addr;
    reg  [14: 0]  row_addr ;
    reg  [9 : 0]  col_addr ;
    
begin

//    bank_addr  = addr[ 27 : 25 ];
//    row_addr   = addr[ 24 : 10 ];
//    col_addr   = addr[ 9  : 0  ];

//    bank_addr  = addr[ 28 : 26 ];
//    row_addr   = addr[ 25 : 11 ];
//    col_addr   = addr[ 10  : 1 ];

//    bank_addr  = addr[ 26 : 24 ];
//    row_addr   = addr[ 23 : 9 ];
//    col_addr   = {addr[8 : 0], 1'b0};

    bank_addr  = addr[ 29 : 27 ];
    row_addr   = addr[ 26 : 12 ];
    col_addr   = {addr[11 : 5], 3'b0};

    
    ddr3_l.memory_write(bank_addr, row_addr, col_addr, wrdata[127 : 0]);
    ddr3_u.memory_write(bank_addr, row_addr, col_addr, wrdata[255 : 128]);

end
endtask

//backdoor write for sdram
task backdoor_read;
    input [31:0]    addr    ;   //must align of 4 Bytes
//    input [2 * BL_MAX * DQ_BITS - 1 : 0]    rddata  ;
    input [255 : 0]    rddata  ;

    reg  [2 : 0]  bank_addr;
    reg  [14: 0]  row_addr ;
    reg  [9 : 0]  col_addr ;
    
begin

//    bank_addr  = addr[ 27 : 25 ];
//    row_addr   = addr[ 24 : 10 ];
//    col_addr   = addr[ 9  : 0  ];

//    bank_addr  = addr[ 28 : 26 ];
//    row_addr   = addr[ 25 : 11 ];
//    col_addr   = addr[ 10  : 1 ];

//    bank_addr  = addr[ 26 : 24 ];
//    row_addr   = addr[ 23 : 9 ];
//    col_addr   = {addr[8 : 0], 1'b0};
    
//    bank_addr  = addr[ 29 : 27 ];
//    row_addr   = addr[ 26 : 12 ];
//    col_addr   = {addr[11 : 3], 1'b0};


    bank_addr  = addr[ 29 : 27 ];
    row_addr   = addr[ 26 : 12 ];
    col_addr   = {addr[11 : 5], 3'b0};

    
    ddr3_l.memory_read(bank_addr, row_addr, col_addr, rddata[127 : 0]);
    ddr3_u.memory_read(bank_addr, row_addr, col_addr, rddata[255 : 128]);
    
end
endtask


task ddr3_load;
//  reg [255 : 0]  wr_data; //8x32
  reg [31 : 0]  wr_data[8]; //8x32
  reg [31  : 0]  addr_last;
  reg [31  : 0]  addr_init;
  reg [31  : 0]  addr;
  reg [31  : 0]  data32;

  int i;
begin

  $readmemh("./slm_files/spi_stim.txt", ddr3_stim);  // read in the stimuli vectors  == address_value
  
  $display("[DDR3] Loading SDRAM (Instruction Section)");

  addr_last = ddr3_stim[index][63:32] - 32'h4;

  while(more_inst)
  begin
//    wr_data = 128'b0;
    for(i = 0; i < 8; i++) 
      wr_data[i] = 32'h0;

    addr_init = ddr3_stim[index][63:32];

    for(i = 0; i < 8; i++)
      begin
        addr = ddr3_stim[index+i][63:32];
        data32  = ddr3_stim[index+i][31:0]; 
        if(addr === addr_last + 32'h4)
          begin
//            wr_data[(32*(i+1)-1) : (i*32)] = data32;
            wr_data[i] = data32;
            addr_last = addr; 
          end //if
        else
          begin            
            $display("[DDR3] Prev address %h, Current address %h", addr_last, addr);
            $display("[DDR3] Loading SDRAM (Data Section)");
            more_inst = 0;
            break;
          end //else
      end//for
 
    backdoor_write(addr_init, {wr_data[7][31:16], wr_data[6][31:16], wr_data[5][31:16], wr_data[4][31:16], wr_data[3][31:16], wr_data[2][31:16], wr_data[1][31:16], wr_data[0][31:16], wr_data[7][15:0],  wr_data[6][15:0],  wr_data[5][15:0],  wr_data[4][15:0],  wr_data[3][15:0],  wr_data[2][15:0],  wr_data[1][15:0],  wr_data[0][15:0]} );
    index = index + i;
  end//while

  addr_last = ddr3_stim[index][63:32] - 32'h4;

  while(more_data)
  begin
//    wr_data = 128'b0;
    for(i = 0; i < 8; i++) 
      wr_data[i] = 32'h0;

    addr_init = ddr3_stim[index][63:32];

    for(i = 0; i < 8; i++)
      begin
        addr = ddr3_stim[index+i][63:32];
        data32  = ddr3_stim[index+i][31:0]; 
        if(addr === addr_last + 32'h4)
          begin
//            wr_data[(32*(i+1)-1) : (i*32)] = data32;
            wr_data[i] = data32;
            addr_last = addr; 
          end //if
        else
          begin            
            $display("[DDR3] Loading SDRAM (Complete)");
            more_data = 0;
            break;
          end //else
      end//for
 
    backdoor_write(addr_init, {wr_data[7][31:16], wr_data[6][31:16], wr_data[5][31:16], wr_data[4][31:16], wr_data[3][31:16], wr_data[2][31:16], wr_data[1][31:16], wr_data[0][31:16], wr_data[7][15:0],  wr_data[6][15:0],  wr_data[5][15:0],  wr_data[4][15:0],  wr_data[3][15:0],  wr_data[2][15:0],  wr_data[1][15:0],  wr_data[0][15:0]} );

    index = index + i;
  end//while
end
endtask


task ddr3_check;
//  reg [255 : 0]  rd_data; //8x32
  reg [31 : 0]  rd_data[8]; //8x32
  reg [255 : 0]  memdata_rb;
  reg [31  : 0]  addr_last;
  reg [31  : 0]  addr_init;
  reg [31  : 0]  addr;
  reg [31  : 0]  data32;

  int i;
begin
  index  = 0;
  more_inst =1;
  more_data =1;
  
  $display("[DDR3] Checking DRAM (Instruction Section)");

  addr_last = ddr3_stim[index][63:32] - 32'h4;

  while(more_inst)
  begin
//    rd_data = 128'b0;
    for(i = 0; i < 8; i++) 
      rd_data[i] = 32'h0;

    addr_init = ddr3_stim[index][63:32];

    for(i = 0; i < 8; i++)
      begin
        addr = ddr3_stim[index+i][63:32];
        data32  = ddr3_stim[index+i][31:0]; 
        if(addr === addr_last + 32'h4)
          begin
//            rd_data[(32*(i+1)-1) : (i*32)] = data32;
            rd_data[i] = data32;
            addr_last = addr; 
          end //if
        else
          begin            
           $display("[DDR3] Prev address %h, Current address %h", addr_last, addr);
           $display("[DDR3] Checking SDRAM (Data Section)");
            more_inst = 0;
            break;
          end //else
      end//for
 
    backdoor_read(addr_init, memdata_rb);

    if (memdata_rb !=  {rd_data[7][31:16], rd_data[6][31:16], rd_data[5][31:16], rd_data[4][31:16], rd_data[3][31:16], rd_data[2][31:16], rd_data[1][31:16], rd_data[0][31:16], rd_data[7][15:0],  rd_data[6][15:0],  rd_data[5][15:0],  rd_data[4][15:0],  rd_data[3][15:0],  rd_data[2][15:0],  rd_data[1][15:0],  rd_data[0][15:0]} )
      $display("%t: [DDR3] Readback failed, expected %X, got %X", $time, {rd_data[7][31:16], rd_data[6][31:16], rd_data[5][31:16], rd_data[4][31:16], rd_data[3][31:16], rd_data[2][31:16], rd_data[1][31:16], rd_data[0][31:16], rd_data[7][15:0], rd_data[6][15:0], rd_data[5][15:0], rd_data[4][15:0], rd_data[3][15:0], rd_data[2][15:0], rd_data[1][15:0], rd_data[0][15:0]}, memdata_rb);

    index = index + i;
  end//while

  addr_last = ddr3_stim[index][63:32] - 32'h4;

  while(more_data)
  begin
//    rd_data = 128'b0;
    for(i = 0; i < 8; i++) 
      rd_data[i] = 32'h0;

    addr_init = ddr3_stim[index][63:32];

    for(i = 0; i < 8; i++)
      begin
        addr = ddr3_stim[index+i][63:32];
        data32  = ddr3_stim[index+i][31:0]; 
        if(addr === addr_last + 32'h4)
          begin
//            rd_data[(32*(i+1)-1) : (i*32)] = data32;
            rd_data[i] = data32;
            addr_last = addr;
          end //if
        else
          begin            
            more_data = 0;
            break;
          end //else
      end//for
 
    backdoor_read(addr_init, memdata_rb);

    if (memdata_rb !=  {rd_data[7][31:16], rd_data[6][31:16], rd_data[5][31:16], rd_data[4][31:16], rd_data[3][31:16], rd_data[2][31:16], rd_data[1][31:16], rd_data[0][31:16], rd_data[7][15:0],  rd_data[6][15:0],  rd_data[5][15:0],  rd_data[4][15:0],  rd_data[3][15:0],  rd_data[2][15:0],  rd_data[1][15:0],  rd_data[0][15:0]} )
      $display("%t: [DDR3] Readback failed, expected %X, got %X", $time, {rd_data[7][31:16], rd_data[6][31:16], rd_data[5][31:16], rd_data[4][31:16], rd_data[3][31:16], rd_data[2][31:16], rd_data[1][31:16], rd_data[0][31:16], rd_data[7][15:0], rd_data[6][15:0], rd_data[5][15:0], rd_data[4][15:0], rd_data[3][15:0], rd_data[2][15:0], rd_data[1][15:0], rd_data[0][15:0]}, memdata_rb);

    index = index + i;
  end//while
end
endtask

