#!/bin/tcsh

if (! $?VSIM_PATH ) then
  setenv VSIM_PATH      `pwd`
endif

if (! $?PPU_PATH ) then
  setenv PPU_PATH      `pwd`/../
endif

setenv MSIM_LIBS_PATH ${VSIM_PATH}/modelsim_libs

setenv IPS_PATH       ${PPU_PATH}/ips
setenv RTL_PATH       ${PPU_PATH}/rtl
setenv TB_PATH        ${PPU_PATH}/tb

clear
source ${PPU_PATH}/vsim/vcompile/colors.csh

rm -rf modelsim_libs
vlib modelsim_libs

rm -rf work
vlib work

echo ""
echo "${Green}--> Compiling PPU SoC... ${NC}"
echo ""

# IP blocks
source ${PPU_PATH}/vsim/vcompile/vcompile_ips.csh  || exit 1

source ${PPU_PATH}/vsim/vcompile/rtl/vcompile_ppu.sh  || exit 1
source ${PPU_PATH}/vsim/vcompile/rtl/vcompile_tb.sh       || exit 1

echo ""
echo "${Green}-->>>>>>>>>>>>>>> PPU SoC compilation complete! ${NC}"
echo ""
