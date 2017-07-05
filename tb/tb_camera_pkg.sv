
//=================Camera Stimulus=======
`define FRAME_WIDTH  32 
`define FRAME_HEIGHT 16

module camera_emu
(
  input  logic        cam_pclk,
  input  logic        cam_rstn,
  output logic        cam_vsync,
  output logic        cam_href,
  output logic [7:0]  cam_data
);

  initial
  begin
    cam_vsync   = 1'b0;
    cam_href    = 1'b0;
      
    repeat(1000)@(negedge cam_pclk);
    camera_create_data;
  end

  always_ff @(negedge cam_pclk, negedge cam_rstn)
  begin
    if(~cam_rstn)
      cam_data  =  8'b00000000;
    else
//      cam_data  =  {cam_data[6:0], cam_data[7]};
      cam_data  =  cam_data + 8'b00000001;
  end  

//camera: create data 640*480*2B/Frame
task camera_create_data;
begin
    while(1)@(negedge cam_pclk)
    begin
       camera_create_frame; 
    end
end
endtask

task camera_create_frame;
integer i;
begin
    //Frame start
    cam_vsync   = 1'b1;
    repeat(100)@(negedge cam_pclk);
    cam_vsync   = 1'b0;
    repeat(100)@(negedge cam_pclk);
    
    for(i = 0; i < (`FRAME_HEIGHT); i = i+1)@(negedge cam_pclk)
    begin
        cam_href    = 1'b1;
        repeat((`FRAME_WIDTH)*2)@(negedge cam_pclk);
        
        cam_href    = 1'b0;
        repeat(10)@(negedge cam_pclk);
    end
    //Frame start
end
endtask

endmodule

