source tcl_files/config/vsim_ips.tcl

set cmd "vsim -quiet $TB \
  glbl \
  -L ppu_lib \
  $VSIM_IP_LIBS \
  -L unisims_ver \
  -L unimacro_ver \
  -L unifast_ver \
  -L simprims_ver \
  -L secureip \
  +nowarnTRAN \
  +nowarnTSCALE \
  +nowarnTFMPC \
  +MEMLOAD=$MEMLOAD \
  +RUNMODE=$RUNMODE \
  -t ps -novopt \
  $VSIM_FLAGS"

eval $cmd

# check exit status in tb and quit the simulation accordingly
proc run_and_exit {} {
  run -all
  quit -code [examine -radix decimal sim:/tb/exit_status]
}
