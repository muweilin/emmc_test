#!/bin/tcsh

if (! $?VSIM_PATH ) then
  setenv VSIM_PATH      `pwd`
endif

if (! $?PPU_PATH ) then
  setenv PPU_PATH      `pwd`/../../
endif

setenv MSIM_LIBS_PATH ${VSIM_PATH}/modelsim_libs

setenv IPS_PATH       ${PPU_PATH}/ips
setenv RTL_PATH       ${PPU_PATH}/rtl
setenv TB_PATH        ${PPU_PATH}/tb

source ${PPU_PATH}/vsim/vcompile/colors.csh
