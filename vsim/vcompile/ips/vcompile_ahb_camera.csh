#!/bin/tcsh
source ${PPU_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=ahb_camera

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
set IP_PATH="${IPS_PATH}/ahb/src_camera"
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

echo "${Green}Compiling component: ${Brown} ahb_camera ${NC}"
echo "${Red}"
vlog -quiet -work ${LIB_PATH}   ${IP_PATH}/camera_ahb_master.v || goto error
vlog -quiet -work ${LIB_PATH}   ${IP_PATH}/camera_bridge.v     || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${IP_PATH}/camera_capture.v    || goto error
vlog -quiet -work ${LIB_PATH}   ${IP_PATH}/camera_csr.v        || goto error


echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
