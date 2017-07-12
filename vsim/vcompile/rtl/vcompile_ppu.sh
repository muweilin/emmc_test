#!/bin/tcsh
source ${PPU_PATH}/vsim/vcompile/colors.csh

##############################################################################
# Settings
##############################################################################

set IP=ppu
set IP_NAME="PPU"


##############################################################################
# Check settings
##############################################################################

# check if environment variables are defined
if (! $?MSIM_LIBS_PATH ) then
  echo "${Red} MSIM_LIBS_PATH is not defined ${NC}"
  exit 1
endif

if (! $?RTL_PATH ) then
  echo "${Red} RTL_PATH is not defined ${NC}"
  exit 1
endif


set LIB_NAME="${IP}_lib"
set LIB_PATH="${MSIM_LIBS_PATH}/${LIB_NAME}"

set LIB_NAME2="ahblite_axi_bridge_v3_0_6"
set LIB_PATH2="${MSIM_LIBS_PATH}/${LIB_NAME2}"

##############################################################################
# Preparing library
##############################################################################

echo "${Green}--> Compiling ${IP_NAME}... ${NC}"

rm -rf $LIB_PATH

vlib $LIB_PATH   
vlib $LIB_PATH2 
vmap $LIB_NAME2 $LIB_PATH2
vmap $LIB_NAME $LIB_PATH

echo "${Green}Compiling component: ${Brown} ${IP_NAME} ${NC}"
echo "${Red}"

##############################################################################
# Compiling RTL
##############################################################################

# decide if we want to build for riscv or or1k
if ( ! $?PULP_CORE) then
  set PULP_CORE="riscv"
endif

if ( $PULP_CORE == "riscv" ) then
  set CORE_DEFINES=+define+RISCV
  echo "${Yellow} Compiling for RISCV core ${NC}"
else
  set CORE_DEFINES=+define+OR10N
  echo "${Yellow} Compiling for OR10N core ${NC}"
endif

# decide if we want to build for riscv or or1k
if ( ! $?ASIC_DEFINES) then
  set ASIC_DEFINES=""
endif

# components
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${RTL_PATH}/components/cluster_clock_gating.sv    || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${RTL_PATH}/components/cluster_clock_inverter.sv  || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${RTL_PATH}/components/cluster_clock_mux2.sv      || goto error
#vlog -quiet -sv -work ${LIB_PATH} ${RTL_PATH}/components/pulp_clock_inverter.sv     || goto error
#vlog -quiet -sv -work ${LIB_PATH} ${RTL_PATH}/components/pulp_clock_mux2.sv         || goto error
vlog -quiet -sv -work ${LIB_PATH} ${RTL_PATH}/components/generic_fifo.sv            || goto error
vlog -quiet -sv -work ${LIB_PATH} ${RTL_PATH}/components/rstgen_lock.sv             || goto error
vlog -quiet -sv -work ${LIB_PATH} ${RTL_PATH}/components/iomux.sv                   || goto error
# the following two RAMs are for simulation purpose
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/ram_4096x32.v              || goto error

vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_manager/xilinx_clock_manager.v
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_manager/mmcm_pll_drp_func_us_mmcm.vh
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_manager/mmcm_pll_drp_func_7s_mmcm.vh
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_manager/mmcm_pll_drp_func_us_pll.vh
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_manager/xilinx_clock_manager_clk_wiz.v
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_manager/mmcm_pll_drp_func_7s_pll.vh
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_2x/xilinx_clock_2x_clk_wiz.v
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_2x/mmcm_pll_drp_func_us_mmcm.vh
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_2x/xilinx_clock_2x.v
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_2x/mmcm_pll_drp_func_7s_mmcm.vh
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_2x/mmcm_pll_drp_func_us_pll.vh
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_2x/mmcm_pll_drp_func_7s_pll.vh
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_1024x24/blk_mem_gen_v8_3.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_1024x24/xilinx_mem_1024x24.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_128x26_dp/blk_mem_gen_v8_3.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_128x26_dp/xilinx_mem_128x26_dp.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_16384x32/xilinx_mem_16384x32.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_16384x32/blk_mem_gen_v8_3.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_512x32_dp/blk_mem_gen_v8_3.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_512x32_dp/xilinx_mem_512x32_dp.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_256x8/blk_mem_gen_v8_3.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_256x8/xilinx_mem_256x8.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_8192x32/blk_mem_gen_v8_3.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_8192x32/xilinx_mem_8192x32.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_128x8_dp/xilinx_mem_128x8_dp.v
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_128x8_dp/blk_mem_gen_v8_3.v
vcom -quiet -work ${LIB_PATH2} ${RTL_PATH}/components/xilinx_h2x/ahblite_axi_bridge_v3_0_6/ahblite_axi_bridge_pkg.vhd
vcom -quiet -work ${LIB_PATH2} ${RTL_PATH}/components/xilinx_h2x/ahblite_axi_bridge_v3_0_6/counter_f.vhd
vcom -quiet -work ${LIB_PATH2} ${RTL_PATH}/components/xilinx_h2x/ahblite_axi_bridge_v3_0_6/axi_wchannel.vhd
vcom -quiet -work ${LIB_PATH2} ${RTL_PATH}/components/xilinx_h2x/ahblite_axi_bridge_v3_0_6/ahb_data_counter.vhd
vcom -quiet -work ${LIB_PATH2} ${RTL_PATH}/components/xilinx_h2x/ahblite_axi_bridge_v3_0_6/time_out.vhd
vcom -quiet -work ${LIB_PATH2} ${RTL_PATH}/components/xilinx_h2x/ahblite_axi_bridge_v3_0_6/ahb_if.vhd
vcom -quiet -work ${LIB_PATH2} ${RTL_PATH}/components/xilinx_h2x/ahblite_axi_bridge_v3_0_6/ahblite_axi_control.vhd
vcom -quiet -work ${LIB_PATH2} ${RTL_PATH}/components/xilinx_h2x/ahblite_axi_bridge_v3_0_6/axi_rchannel.vhd
vcom -quiet -work ${LIB_PATH2} ${RTL_PATH}/components/xilinx_h2x/ahblite_axi_bridge_v3_0_6/ahblite_axi_bridge.vhd
vcom -quiet -work ${LIB_PATH2} ${RTL_PATH}/components/xilinx_h2x/ahblite_axi_bridge_v3_0_6/h2x_bridge.vhd

#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_16384x32_funcsim.v  || goto error
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_128x8_dp_funcsim.v  || goto error
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_128x26_dp_funcsim.v  || goto error
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_256x8_funcsim.v  || goto error
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_1024x24_funcsim.v  || goto error
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_512x32_dp_funcsim.v  || goto error
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_mem_8192x32_funcsim.v  || goto error
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_2x_funcsim.v  || goto error
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/funcsim/xilinx_ahblite_axi_bridge_funcsim.v  || goto error
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_clock_manager_funcsim.v || goto error   
vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/xilinx_axi_clock_converter_funcsim.v || goto error
#
#vlog -quiet -sv -work ${LIB_PATH} ${RTL_PATH}/components/sp_ram_smic55.sv           || goto error

# this PLL is for simulation purpose
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/S55NLLPLLGS_ZP1500A_V1.2.5.v || goto error
#vlog -quiet -work ${LIB_PATH} ${RTL_PATH}/components/SP55NLLD2RP_OV3_V0p2a.v      || goto error
# files depending on RISCV vs. OR1K
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/iobuf.sv        || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/random_stalls.sv      || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/ram_mux.sv            || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/axi_node_intf_wrap.sv || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/axi2apb_wrap.sv       || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/axi_spi_slave_wrap.sv || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/axi_mem_if_SP_wrap.sv || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/axi_slice_wrap.sv     || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core2axi_wrap.sv      || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/top.sv                || goto error

vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/core_region.sv        || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/boot_rom_wrap.sv      || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/boot_code.sv          || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/instr_ram_wrap.sv     || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/sp_ram_wrap.sv        || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/ppu_top.sv            || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/peripherals.sv        || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/periph_bus_wrap.sv    || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/clk_rst_gen.sv        || goto error
vlog -quiet     -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/ahb_subsystem.v       || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/xilinx_ddr3_if_wrap.sv || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core/clk_div2.v || goto error

vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core0/core_region0.sv        || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core0/boot_rom_wrap0.sv      || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core0/boot_code0.sv          || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core0/instr_ram_wrap0.sv     || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core0/sp_ram_wrap0.sv        || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core0/peripherals0.sv        || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core0/periph_bus_wrap0.sv    || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core0/clk_rst_gen0.sv    || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core0/pll0.sv    || goto error
vlog -quiet -sv -work ${LIB_PATH} +incdir+${RTL_PATH}/includes ${ASIC_DEFINES} ${CORE_DEFINES} ${RTL_PATH}/core0/ppu0_top.sv    || goto error

echo "${Cyan}--> ${IP_NAME} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
