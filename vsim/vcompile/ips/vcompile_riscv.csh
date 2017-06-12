#!/bin/tcsh
source ${PPU_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=riscv

##############################################################################
# Check settings
##############################################################################

# check if environment variables are defined
if (! $?MSIM_LIBS_PATH ) then
  echo "${Red} MSIM_LIBS_PATH is not defined ${NC}"
  exit 1
endif

if (! $?IPS_PATH ) then
  echo "${Red} IPS_PATH is not defined ${NC}"
  exit 1
endif

set LIB_NAME="${IP}_lib"
set LIB_PATH="${MSIM_LIBS_PATH}/${LIB_NAME}"
set IP_PATH="${IPS_PATH}/riscv"
set RTL_PATH="${RTL_PATH}"

##############################################################################
# Preparing library
##############################################################################

echo "${Green}--> Compiling ${IP}... ${NC}"

rm -rf $LIB_PATH

vlib $LIB_PATH
vmap $LIB_NAME $LIB_PATH

##############################################################################
# Compiling RTL
##############################################################################

echo "${Green}Compiling component: ${Brown} riscv ${NC}"
echo "${Red}"
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/include/riscv_defines.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/include/riscv_tracer_defines.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/alu.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/alu_div.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/compressed_decoder.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/controller.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/cs_registers.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/debug_unit.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/decoder.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/exc_controller.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/ex_stage.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/hwloop_controller.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/hwloop_regs.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/id_stage.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/if_stage.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/load_store_unit.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/mult.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/prefetch_buffer.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/prefetch_L0_buffer.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/riscv_core.sv || goto error

echo "${Green}Compiling component: ${Brown} riscv_regfile_ff_rtl ${NC}"
echo "${Red}"
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/register_file_ff.sv || goto error

echo "${Green}Compiling component: ${Brown} riscv_vip_rtl ${NC}"
echo "${Red}"
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/riscv_tracer.sv || goto error
vlog -quiet -sv -work ${LIB_PATH}   +incdir+${IP_PATH}/include ${IP_PATH}/riscv_simchecker.sv || goto error


echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
