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
setenv TB_PATH        ${PPU_PATH}/tb0

clear
source ${PPU_PATH}/vsim0/vcompile/colors.csh

rm -rf modelsim_libs
vlib modelsim_libs

rm -rf work
vlib work

echo ""
echo "${Green}--> Compiling PPU0 SoC... ${NC}"
echo ""

# IP blocks
source ${PPU_PATH}/vsim0/vcompile/vcompile_ips.csh  || exit 1

source ${PPU_PATH}/vsim0/vcompile/rtl/vcompile_ppu.sh  || exit 1
source ${PPU_PATH}/vsim0/vcompile/rtl/vcompile_tb.sh       || exit 1

echo ""
echo "${Green}-->>>>>>>>>>>>>>>>>>>>>> PPU0000 SoC compilation complete! ${NC}"
echo ""
