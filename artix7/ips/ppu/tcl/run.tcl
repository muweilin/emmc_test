
if { ![info exists ::env(XILINX_PART)] } {
  set ::env(XILINX_PART) "xc7a100tfgg484-2"
}

# create project
create_project fpga_top . -part $::env(XILINX_PART)

set_property include_dirs {
    ../../.././rtl/includes \
    ../../.././ips/apb/apb_event_unit/./include/ \
    ../../.././ips/axi/axi_node/. \
    ../../.././ips/riscv/include \
    ../../.././ips/apb/apb_i2c/. \
    ../../.././ips/adv_dbg_if/rtl \
    ../../.././ips/ahb/src_mctl \
    ../../.././ips/ahb/src_x2h \
    ../../.././ips/ahb/src_emmc \
} [current_fileset] 

source tcl/src_files.tcl

# add memory cuts
add_files -norecurse $FPGA_IPS/xilinx_mem_16384x32/ip/xilinx_mem_16384x32.dcp
add_files -norecurse $FPGA_IPS/xilinx_mem_8192x32/ip/xilinx_mem_8192x32.dcp
add_files -norecurse $FPGA_IPS/xilinx_mem_128x26_dp/ip/xilinx_mem_128x26_dp.dcp
add_files -norecurse $FPGA_IPS/xilinx_mem_256x8/ip/xilinx_mem_256x8.dcp
add_files -norecurse $FPGA_IPS/xilinx_mem_128x8_dp/ip/xilinx_mem_128x8_dp.dcp
add_files -norecurse $FPGA_IPS/xilinx_mem_512x32_dp/ip/xilinx_mem_512x32_dp.dcp
add_files -norecurse $FPGA_IPS/xilinx_mem_1024x24/ip/xilinx_mem_1024x24.dcp
add_files -norecurse $FPGA_IPS/xilinx_clock_manager/ip/xilinx_clock_manager.dcp

# needed only if used in batch mode
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# set ppu_fpga_top as top
set_property top fpga_top [current_fileset]

add_files -fileset constrs_1 -norecurse constraints.xdc

# run synthesis
# first try will fail
catch {synth_design -rtl -name rtl_1 -verilog_define HAPS -verilog_define RISCV -flatten_hierarchy none -gated_clock_conversion off -constrset constrs_1}

update_compile_order -fileset sources_1

synth_design -rtl -name rtl_1 -verilog_define HAPS -verilog_define RISCV -flatten_hierarchy none -gated_clock_conversion on -constrset constrs_1

#set_property STEPS.SYNTH_DESIGN.ARGS.KEEP_EQUIVALENT_REGISTERS true [get_runs synth_1]
#set_property STEPS.SYNTH_DESIGN.ARGS.RESOURCE_SHARING off [get_runs synth_1]
#set_property STEPS.SYNTH_DESIGN.ARGS.NO_LC true [get_runs synth_1]
launch_runs synth_1
wait_on_run synth_1

# save EDIF netlist
open_run synth_1
write_edif -force fpga_top.edf
write_verilog -force -mode funcsim fpga_top_funcsim.v

source tcl/impl.tcl
