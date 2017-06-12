module AXI_slave_monitor();    
   
    parameter i = 3;

    wire                      clock;
    wire [31:0]               aw_addr;
    wire [2:0]                aw_prot;
    wire [3:0]                aw_region;
    wire [7:0]                aw_len;
    wire [2:0]                aw_size;
    wire [1:0]                aw_burst;
    wire                      aw_lock;
    wire [3:0]                aw_cache;
    wire [3:0]                aw_qos;
    wire [3:0]                aw_id;
    wire                      aw_user;
    wire                      aw_ready;
    wire                      aw_valid;
    
    wire [31:0]               ar_addr;
    wire [2:0]                ar_prot;
    wire [3:0]                ar_region;
    wire [7:0]                ar_len;
    wire [2:0]                ar_size;
    wire [1:0]                ar_burst;
    wire                      ar_lock;
    wire [3:0]                ar_cache;
    wire [3:0]                ar_qos;
    wire [3:0]                ar_id;
    wire                      ar_user;
    wire                      ar_ready;
    wire                      ar_valid;
    
    wire                      w_valid;
    wire [31:0]               w_data;
    wire [3:0]                w_strb;
    wire                      w_user;
    wire                      w_last;
    wire                      w_ready;
    
    wire [31:0]               r_data;
    wire [1:0]                r_resp;
    wire                      r_last;
    wire [3:0]                r_id;
    wire                      r_user;
    wire                      r_ready;
    wire                      r_valid;
    
    wire [1:0]                b_resp;
    wire [3:0]                b_id;
    wire                      b_user;
    wire                      b_ready;
    wire                      b_valid;
    
    
       
    assign  clock                    = tb.top_i.ppu_top_i.clk_int    ;
// Write Address Channel
    assign  aw_ready                 = tb.top_i.ppu_top_i.slaves[i].aw_ready ;  
    assign  aw_valid                 = tb.top_i.ppu_top_i.slaves[i].aw_valid ;
    assign  aw_addr                  = tb.top_i.ppu_top_i.slaves[i].aw_addr  ;
    assign  aw_len                   = tb.top_i.ppu_top_i.slaves[i].aw_len   ;
    assign  aw_id                    = tb.top_i.ppu_top_i.slaves[i].aw_id    ;
// Write Data Channel                                                        
    assign  w_valid                  = tb.top_i.ppu_top_i.slaves[i].w_valid ;
    assign  w_ready                  = tb.top_i.ppu_top_i.slaves[i].w_ready ;
    assign  w_data                   = tb.top_i.ppu_top_i.slaves[i].w_data  ;
// Write Response Channel                                                                                               
    assign  b_valid                  = tb.top_i.ppu_top_i.slaves[i].b_valid  ;
    assign  b_id                     = tb.top_i.ppu_top_i.slaves[i].b_id     ;
    assign  b_resp                   = tb.top_i.ppu_top_i.slaves[i].b_resp   ;   
// Read Address Channel    
    assign  ar_ready                 = tb.top_i.ppu_top_i.slaves[i].ar_ready ;
    assign  ar_valid                 = tb.top_i.ppu_top_i.slaves[i].ar_valid ;
    assign  ar_id                    = tb.top_i.ppu_top_i.slaves[i].ar_id    ;
    assign  ar_len                   = tb.top_i.ppu_top_i.slaves[i].ar_len   ;
    assign  ar_addr                  = tb.top_i.ppu_top_i.slaves[i].ar_addr  ;  
// Read Data Channel
	assign  r_valid                  = tb.top_i.ppu_top_i.slaves[i].r_valid  ;
    assign  r_id                     = tb.top_i.ppu_top_i.slaves[i].r_id     ;
    assign  r_data                   = tb.top_i.ppu_top_i.slaves[i].r_data   ;
    assign  r_resp                   = tb.top_i.ppu_top_i.slaves[i].r_resp   ;
   
    integer fawinfo, fwdata, fbinfo, farinfo, frdata;
    initial fawinfo  = $fopen("axiSlave_fawinfo_monitor.txt");
    initial fwdata   = $fopen("axiSlave_fwdata_monitor.txt");
    initial fbinfo   = $fopen("axiSlave_fbinfo_monitor.txt");
    initial farinfo  = $fopen("axiSlave_farinfo_monitor.txt");
    initial frdata   = $fopen("axiSlave_frdata_monitor.txt");



    always @(posedge clock)
    begin
        if (~tb.top_i.ppu_top_i.rstn_int) begin
        // for intialization
        end
        else begin
            if(aw_ready && aw_valid) begin
                $fdisplay(fawinfo, "(%t) awinfo 0x%x 0x%x 0x%x", $time, aw_len, aw_id, aw_addr);
                $fflush(fawinfo);
            end
            if (w_valid && w_ready) begin
                $fdisplay(fwdata, "(%t) wdata 0x%x", $time, w_data);
                $fflush(fwdata);
            end
            if(b_valid) begin
                $fdisplay(fbinfo, "(%t) binfo 0x%x 0x%x", $time, b_id, b_resp);
                $fflush(fbinfo);
            end
            if(ar_ready && ar_valid) begin
                $fdisplay(farinfo, "(%t) arinfo 0x%x 0x%x 0x%x", $time, ar_len, ar_id, ar_addr);
                $fflush(farinfo);
            end
            if(r_valid) begin
                $fdisplay(frdata, "(%t) rdata 0x%x 0x%x 0x%x", $time, r_id, r_resp,r_data);
                $fflush(frdata);
            end
        end
    end
    
endmodule
