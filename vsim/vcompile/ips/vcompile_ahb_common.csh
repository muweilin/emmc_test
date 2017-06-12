#!/bin/tcsh
source ${PPU_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=ahb_common

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
set IP_PATH="${IPS_PATH}/ahb/src_common"
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

echo "${Green}Compiling component: ${Brown} ahb_common ${NC}"
echo "${Red}"
vlog -quiet -work ${LIB_PATH}   ${IP_PATH}/DW_minmax.v         || goto error
vlog -quiet -work ${LIB_PATH}   ${IP_PATH}/DW01_inc.v           || goto error
vlog -quiet -work ${LIB_PATH}   ${IP_PATH}/dll_delay_element.v  || goto error
vlog -quiet -work ${LIB_PATH}   ${IP_PATH}/dll_delay_line_128.v || goto error
vlog -quiet -work ${LIB_PATH}   ${IP_PATH}/dll_delay_line_256.v || goto error
vlog -quiet -work ${LIB_PATH}   ${IP_PATH}/dll_delay_line_512.v || goto error
vlog -quiet -work ${LIB_PATH}   ${IP_PATH}/mdlr.v             || goto error

echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
