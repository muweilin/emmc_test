#!/bin/tcsh
source ${PPU_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=axi_ddr3_if

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
set IP_PATH="${IPS_PATH}/axi/axi_ddr3_if"
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

echo "${Green}Compiling component: ${Brown} axi_ddr3_if(Xilinx MIG) ${NC}"
echo "${Red}"
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_ctrl_addr_decode.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_ctrl_read.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_ctrl_reg.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_ctrl_reg_bank.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_ctrl_top.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_ctrl_write.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_ar_channel.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_aw_channel.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_b_channel.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_cmd_arbiter.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_cmd_fsm.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_cmd_translator.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_fifo.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_incr_cmd.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_r_channel.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_simple_fifo.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_w_channel.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_wr_cmd_fsm.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_axi_mc_wrap_cmd.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_a_upsizer.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_axi_register_slice.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_axi_upsizer.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_axic_register_slice.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_carry_and.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_carry_latch_and.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_carry_latch_or.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_carry_or.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_command_fifo.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_comparator.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_comparator_sel.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_comparator_sel_static.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_r_upsizer.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/axi/mig_7series_v4_0_ddr_w_upsizer.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/clocking/mig_7series_v4_0_clk_ibuf.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/clocking/mig_7series_v4_0_infrastructure.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/clocking/mig_7series_v4_0_iodelay_ctrl.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/clocking/mig_7series_v4_0_tempmon.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_arb_mux.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_arb_row_col.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_arb_select.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_bank_cntrl.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_bank_common.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_bank_compare.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_bank_mach.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_bank_queue.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_bank_state.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_col_mach.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_mc.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_rank_cntrl.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_rank_common.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_rank_mach.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/controller/mig_7series_v4_0_round_robin_arb.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ecc/mig_7series_v4_0_ecc_buf.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ecc/mig_7series_v4_0_ecc_dec_fix.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ecc/mig_7series_v4_0_ecc_gen.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ecc/mig_7series_v4_0_ecc_merge_enc.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ecc/mig_7series_v4_0_fi_xor.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ip_top/mig_7series_v4_0_mem_intfc.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ip_top/mig_7series_v4_0_memc_ui_top_axi.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_byte_group_io.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_byte_lane.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_calib_top.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_if_post_fifo.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_mc_phy.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_mc_phy_wrapper.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_of_pre_fifo.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_4lanes.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_ck_addr_cmd_delay.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_dqs_found_cal.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_dqs_found_cal_hr.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_init.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_ocd_cntlr.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_ocd_data.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_ocd_edge.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_ocd_lim.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_ocd_mux.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_ocd_po_cntlr.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_ocd_samp.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_oclkdelay_cal.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_prbs_rdlvl.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_rdlvl.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_tempmon.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_top.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_wrcal.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_wrlvl.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_phy_wrlvl_off_delay.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_prbs_gen.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_ddr_skip_calib_tap.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_poc_cc.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_poc_edge_store.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_poc_meta.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_poc_pd.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_poc_tap_base.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/phy/mig_7series_v4_0_poc_top.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ui/mig_7series_v4_0_ui_cmd.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ui/mig_7series_v4_0_ui_rd_data.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ui/mig_7series_v4_0_ui_top.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/ui/mig_7series_v4_0_ui_wr_data.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/xilinx_ddr3_if.v || goto error
vlog -quiet -sv -work ${LIB_PATH}     ${IP_PATH}/xilinx_ddr3_if_mig_sim.v || goto error

echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
