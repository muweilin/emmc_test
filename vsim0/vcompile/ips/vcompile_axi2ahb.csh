#!/bin/tcsh
source ${PPU_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=ahb_x2h

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
set IP_PATH="${IPS_PATH}/ahb/src_x2h"
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

echo "${Green}Compiling component: ${Brown} ahb_axi2ahb ${NC}"
echo "${Red}"
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_cc_constants.v      || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_ahb_cgen.v          || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_ahb_cgen_logic.v    || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_ahb_cpipe.v         || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_ahb_fpipe.v         || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_ahb_if.v            || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_ahb_master.v        || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_arb.v               || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_cmd_queue.v         || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_power_ctrl.v        || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_read_data_buffer.v  || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_resp_buffer.v       || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_slave.v             || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_write_data_buffer.v || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_bcm57.v             || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_bcm21.v             || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_bcm07.v             || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_bcm06.v             || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_bcm05.v             || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h_trcnt.v             || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h.v                   || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_axi_x2h-undef.v             || goto error


echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
