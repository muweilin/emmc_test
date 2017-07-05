#!/bin/tcsh

setenv VSIM_PATH      `pwd`
setenv TB_PATH        ${VSIM_PATH}/tb
setenv LIB_PATH        ${VSIM_PATH}/work

echo ""
echo " ======== Compiling ======== "
echo ""

rm -rf work
vlib work

vlog -work ${LIB_PATH} ${TB_PATH}/glbl.v || goto error
vlog -work ${LIB_PATH} ${VSIM_PATH}/../ips/ppu/fpga_top_funcsim.v || goto error
vlog -work ${LIB_PATH} +incdir+${TB_PATH} +define+x16+den1024Mb+FULL_MEM+sg5 ${TB_PATH}/mobile_ddr.v || goto error
vlog -sv -work ${LIB_PATH} ${TB_PATH}/uart.sv  || goto error
vlog -sv -work ${LIB_PATH} +incdir+${TB_PATH} ${TB_PATH}/tb.sv    || goto error

echo ""
echo " ======== Done ======== "
echo ""

echo ""
echo " ======== Start Simulation ======== "
echo ""

vsim -L unisims_ver -L unimacro_ver -L unifast_ver -L simprims_ver -novopt work.tb glbl

exit 0

error:
echo "Error"
exit 1
