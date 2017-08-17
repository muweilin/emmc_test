set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

launch_runs impl_1
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

# report area utilization
report_utilization -hierarchical -hierarchical_depth 1 -file fpga_top_utilization_summary.txt
report_utilization -hierarchical -hierarchical_depth 2 -cells top_i -file top_utilization.txt

report_timing_summary -file fpga_top_timing_summary.txt
report_timing         -file fpga_top_timing.txt         -max_paths 10

# output Verilog netlist + SDC for timing simulation
write_verilog -force -mode timesim -cell top_i simu/top_impl.v
write_sdf     -force -cell top_i simu/top_impl.sdf

