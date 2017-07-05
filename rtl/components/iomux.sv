module iomux
(
//chip side
    input  logic chip_in0,
    input  logic chip_in1,

    output logic chip_out0,
    output logic chip_out1,

    input  logic chip_dir0,
    input  logic chip_dir1,

    input  logic io_cfg,
//io side
    output logic io_out,
    input  logic io_in,
    output logic io_dir 
);

  always_comb
  begin
    if (io_cfg == 1'b0)
      begin
        io_out    = chip_in0;
        chip_out0 = io_in;
        chip_out1 = 1'b0;
        io_dir    = chip_dir0;
      end
    else
      begin
        io_out    = chip_in1;
        chip_out1 = io_in;
        chip_out0 = 1'b0;
        io_dir    = chip_dir1;
      end
  end

endmodule

