#!/bin/tcsh
source ${PPU_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=ahb_emmc

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
set IP_PATH="${IPS_PATH}/ahb/src_emmc"
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

echo "${Green}Compiling component: ${Brown} ahb_emmc ${NC}"
echo "${Red}"
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}   ${IP_PATH}/DWC_mobile_storage_params.v            || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_derived_params.v    || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_clk_mux_4x1.v       || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_clk_mux_2x1.v       || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_clk_and.v           || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_clk_or.v            || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_ahb2apb.v           || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_regb.v              || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_dma.v               || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_cdet.v              || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_2clk_fifoctl.v      || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_biu.v               || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_b2c.v               || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_c2b.v               || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_2clk_dssram.v       || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_autostop.v          || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_rxfifowr.v          || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_txfiford.v          || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_crc7.v              || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_crc16.v             || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_c2b2clk.v           || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_intrcntl.v          || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_clkcntl.v           || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_clkmux_interleave.v || goto error

vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_muxdemux.v  || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_bcm21.v     || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_cmdpath.v   || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_datatx.v    || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_datarx.v    || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_datapath.v  || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_ciu.v       || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_dmac_if.v   || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_dmac_csr.v  || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_dmac_cntrl.v || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_ahb_ahm.v   || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_dmac_ahb.v  || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage.v           || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_top.v       || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage_clk_ctrl.v  || goto error
vlog -quiet -work ${LIB_PATH} +incdir+${IP_PATH}  ${IP_PATH}/DWC_mobile_storage-undef.v     || goto error
echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0                        
                              
##############################+incdir+${IP_PATH}################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
