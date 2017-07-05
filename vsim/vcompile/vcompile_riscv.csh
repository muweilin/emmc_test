#!/bin/tcsh

if (! $?VSIM_PATH ) then
  setenv VSIM_PATH      `pwd`
endif

if (! $?PPU_PATH ) then
  setenv PPU_PATH      `pwd`/..
endif

setenv MSIM_LIBS_PATH ${VSIM_PATH}/modelsim_libs

setenv IPS_PATH ${PPU_PATH}/ips

source ${PPU_PATH}/vsim/vcompile/colors.csh

echo ""
echo "${Green}--> Compiling riscv core... ${NC}"

source ${PPU_PATH}/vsim/vcompile/ips/vcompile_riscv.csh || exit 1

echo "${Green}--> RiscV core compilation Complete! ${NC}"
echo ""
