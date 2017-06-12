#!/bin/tcsh
source ${PPU_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=ahb_ann

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
set IP_PATH="${IPS_PATH}/ahb/src_ann"
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

echo "${Green}Compiling component: ${Brown} ahb2ann ${NC}"
echo "${Red}"
vlog -quiet -sv -work  ${LIB_PATH} +cover=bcefsx +incdir+${IP_PATH} +incdir+${RTL_PATH}/includes \
${IP_PATH}/ahb_ann.v         \
${IP_PATH}/ahb_master.v         \
${IP_PATH}/ahb_slave.v         \
${IP_PATH}/busreq_sm.v         \
${IP_PATH}/fifo.v         \
${IP_PATH}/npu_if_crl.v         \
${IP_PATH}/acc_fifo.v        \
${IP_PATH}/fifo_fwf_128x26.v \
${IP_PATH}/fifo_fwf_128x8.v  \
${IP_PATH}/ram_128x26.v 	 \
${IP_PATH}/ram_128x8.v		 \
${IP_PATH}/ram_512x32.v		 \
${IP_PATH}/ram_256x8.v 	 \
${IP_PATH}/ram512x8.v 	 \
${IP_PATH}/ram2048x8.v 	 \
${IP_PATH}/ram_1024x24.v 	 \
${IP_PATH}/ram1024x21.v 	 \
${IP_PATH}/fifo_fwf.v        \
${IP_PATH}/madd_ch_generic.v \
${IP_PATH}/madd_generic.v    \
${IP_PATH}/npu.v             \
${IP_PATH}/pe.v              \
${IP_PATH}/pu.v              \
${IP_PATH}/sigmoid_lut.v     \
${IP_PATH}/sigmoid.v        || goto error



echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
