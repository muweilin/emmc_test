#!/bin/tcsh
source ${PPU_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=ahb_node

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
set IP_PATH="${IPS_PATH}/ahb/src_ahb"
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

echo "${Green}Compiling component: ${Brown} ahb_node ${NC}"
echo "${Red}"
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_amba_constants.v  || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_cc_constants.v || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_constants.v   || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_bcm_params.v  || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_bcm02.v       || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_bcm01.v       || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_bcm53.v       || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_arbif.v       || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_dcdr.v        || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_dfltslv.v     || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_ebt.v         || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_gctrl.v       || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_mask.v        || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_mux.v         || goto error    
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_gating.v      || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb-undef.v       || goto error  
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb_arb.v         || goto error 
vlog -quiet -sv -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DW_ahb.v             || goto error 
                                  
                                  
echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
