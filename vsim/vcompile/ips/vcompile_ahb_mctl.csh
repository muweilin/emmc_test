#!/bin/tcsh
source ${PPU_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=ahb_memctl

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
set IP_PATH="${IPS_PATH}/ahb/src_mctl"
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

echo "${Green}Compiling component: ${Brown} ahb_memctrl ${NC}"
echo "${Red}"
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_params.v      || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_bcm_params.v  || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_constants.v   || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_bcm01.v       || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_hiu.v         || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_hiu_afifo.v   || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_fifo.v        || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_hiu_acore.v   || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_hiu_dfifo.v   || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_hiu_dcore.v   || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_hiu_ctl.v     || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_hiu_rbuf.v    || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_miu_ddrwr.v   || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_miu_dsdc.v    || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_miu_addrdec.v || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_miu_refctl.v  || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_miu_cr.v      || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_miu_dmc.v     || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl_miu.v         || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl.v             || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH} +incdir+${RTL_PATH}/includes ${IP_PATH}/DW_memctl_top.v         || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DW_memctl-undef.v       || goto error


echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
