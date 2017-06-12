set RTL ../../../rtl
set IPS ../../../ips
set FPGA_IPS ../../ips
set FPGA_RTL ../../rtl


# apb_gpio
set SRC_APB_GPIO " \
    $IPS/apb/apb_gpio/apb_gpio.sv \
"

# axi_slice_dc
set SRC_AXI_SLICE_DC " \
    $IPS/axi/axi_slice_dc/axi_slice_dc_master.sv \
    $IPS/axi/axi_slice_dc/axi_slice_dc_slave.sv \
    $IPS/axi/axi_slice_dc/dc_data_buffer.v \
    $IPS/axi/axi_slice_dc/dc_full_detector.v \
    $IPS/axi/axi_slice_dc/dc_synchronizer.v \
    $IPS/axi/axi_slice_dc/dc_token_ring_fifo_din.v \
    $IPS/axi/axi_slice_dc/dc_token_ring_fifo_dout.v \
    $IPS/axi/axi_slice_dc/dc_token_ring.v \
"

# apb_event_unit
set SRC_APB_EVENT_UNIT " \
    $IPS/apb/apb_event_unit/apb_event_unit.sv \
    $IPS/apb/apb_event_unit/generic_service_unit.sv \
    $IPS/apb/apb_event_unit/sleep_unit.sv \
"
set INC_APB_EVENT_UNIT " \
    $IPS/apb/apb_event_unit/./include/ \
"

# axi_node
set SRC_AXI_NODE " \
    $IPS/axi/axi_node/apb_regs_top.sv \
    $IPS/axi/axi_node/axi_address_decoder_AR.sv \
    $IPS/axi/axi_node/axi_address_decoder_AW.sv \
    $IPS/axi/axi_node/axi_address_decoder_BR.sv \
    $IPS/axi/axi_node/axi_address_decoder_BW.sv \
    $IPS/axi/axi_node/axi_address_decoder_DW.sv \
    $IPS/axi/axi_node/axi_AR_allocator.sv \
    $IPS/axi/axi_node/axi_ArbitrationTree.sv \
    $IPS/axi/axi_node/axi_AW_allocator.sv \
    $IPS/axi/axi_node/axi_BR_allocator.sv \
    $IPS/axi/axi_node/axi_BW_allocator.sv \
    $IPS/axi/axi_node/axi_DW_allocator.sv \
    $IPS/axi/axi_node/axi_FanInPrimitive_Req.sv \
    $IPS/axi/axi_node/axi_multiplexer.sv \
    $IPS/axi/axi_node/axi_node.sv \
    $IPS/axi/axi_node/axi_node_wrap.sv \
    $IPS/axi/axi_node/axi_node_wrap_with_slices.sv \
    $IPS/axi/axi_node/axi_regs_top.sv \
    $IPS/axi/axi_node/axi_request_block.sv \
    $IPS/axi/axi_node/axi_response_block.sv \
    $IPS/axi/axi_node/axi_RR_Flag_Req.sv \
"
set INC_AXI_NODE " \
    $IPS/axi/axi_node/. \
"

# riscv
set SRC_RISCV " \
    $IPS/riscv/include/riscv_defines.sv \
    $IPS/riscv/alu.sv \
    $IPS/riscv/alu_div.sv \
    $IPS/riscv/compressed_decoder.sv \
    $IPS/riscv/controller.sv \
    $IPS/riscv/cs_registers.sv \
    $IPS/riscv/debug_unit.sv \
    $IPS/riscv/decoder.sv \
    $IPS/riscv/exc_controller.sv \
    $IPS/riscv/ex_stage.sv \
    $IPS/riscv/hwloop_controller.sv \
    $IPS/riscv/hwloop_regs.sv \
    $IPS/riscv/id_stage.sv \
    $IPS/riscv/if_stage.sv \
    $IPS/riscv/load_store_unit.sv \
    $IPS/riscv/mult.sv \
    $IPS/riscv/prefetch_buffer.sv \
    $IPS/riscv/prefetch_L0_buffer.sv \
    $IPS/riscv/register_file_ff.sv \
    $IPS/riscv/riscv_core.sv \
"

set INC_RISCV " \
    $IPS/riscv/include \
"

# apb_pulpino
set SRC_APB_PULPINO " \
    $IPS/apb/apb_pulpino/apb_pulpino.sv \
"

# apb_pwm
set SRC_APB_PWM " \
    $IPS/apb/apb_pwm/apb_pwm.sv \
    $IPS/apb/apb_pwm/pwm_gen.sv \
"

# axi_mem_if_DP
set SRC_AXI_MEM_IF_DP " \
    $IPS/axi/axi_mem_if_DP/axi_mem_if_MP_Hybrid_multi_bank.sv \
    $IPS/axi/axi_mem_if_DP/axi_mem_if_multi_bank.sv \
    $IPS/axi/axi_mem_if_DP/axi_mem_if_DP_hybr.sv \
    $IPS/axi/axi_mem_if_DP/axi_mem_if_DP.sv \
    $IPS/axi/axi_mem_if_DP/axi_mem_if_SP.sv \
    $IPS/axi/axi_mem_if_DP/axi_read_only_ctrl.sv \
    $IPS/axi/axi_mem_if_DP/axi_write_only_ctrl.sv \
"

# axi_slice
set SRC_AXI_SLICE " \
    $IPS/axi/axi_slice/axi_ar_buffer.sv \
    $IPS/axi/axi_slice/axi_aw_buffer.sv \
    $IPS/axi/axi_slice/axi_b_buffer.sv \
    $IPS/axi/axi_slice/axi_buffer.sv \
    $IPS/axi/axi_slice/axi_r_buffer.sv \
    $IPS/axi/axi_slice/axi_slice.sv \
    $IPS/axi/axi_slice/axi_w_buffer.sv \
"

# apb_uart
set SRC_APB_UART " \
    $IPS/apb/apb_uart/apb_uart.vhd \
    $IPS/apb/apb_uart/slib_clock_div.vhd \
    $IPS/apb/apb_uart/slib_counter.vhd \
    $IPS/apb/apb_uart/slib_edge_detect.vhd \
    $IPS/apb/apb_uart/slib_fifo.vhd \
    $IPS/apb/apb_uart/slib_input_filter.vhd \
    $IPS/apb/apb_uart/slib_input_sync.vhd \
    $IPS/apb/apb_uart/slib_mv_filter.vhd \
    $IPS/apb/apb_uart/uart_baudgen.vhd \
    $IPS/apb/apb_uart/uart_interrupt.vhd \
    $IPS/apb/apb_uart/uart_receiver.vhd \
    $IPS/apb/apb_uart/uart_transmitter.vhd \
"

# apb_spi_master
set SRC_APB_SPI_MASTER " \
    $IPS/apb/apb_spi_master/apb_spi_master.sv \
    $IPS/apb/apb_spi_master/spi_master_apb_if.sv \
    $IPS/apb/apb_spi_master/spi_master_clkgen.sv \
    $IPS/apb/apb_spi_master/spi_master_controller.sv \
    $IPS/apb/apb_spi_master/spi_master_fifo.sv \
    $IPS/apb/apb_spi_master/spi_master_rx.sv \
    $IPS/apb/apb_spi_master/spi_master_tx.sv \
"

# apb_timer
set SRC_APB_TIMER " \
    $IPS/apb/apb_timer/apb_timer.sv \
    $IPS/apb/apb_timer/timer.sv \
"

# axi2apb
set SRC_AXI2APB " \
    $IPS/axi/axi2apb/AXI_2_APB.sv \
    $IPS/axi/axi2apb/AXI_2_APB_32.sv \
    $IPS/axi/axi2apb/axi2apb.sv \
    $IPS/axi/axi2apb/axi2apb32.sv \
"

# axi_spi_slave
set SRC_AXI_SPI_SLAVE " \
    $IPS/axi/axi_spi_slave/axi_spi_slave.sv \
    $IPS/axi/axi_spi_slave/spi_slave_axi_plug.sv \
    $IPS/axi/axi_spi_slave/spi_slave_cmd_parser.sv \
    $IPS/axi/axi_spi_slave/spi_slave_controller.sv \
    $IPS/axi/axi_spi_slave/spi_slave_dc_fifo.sv \
    $IPS/axi/axi_spi_slave/spi_slave_regs.sv \
    $IPS/axi/axi_spi_slave/spi_slave_rx.sv \
    $IPS/axi/axi_spi_slave/spi_slave_syncro.sv \
    $IPS/axi/axi_spi_slave/spi_slave_tx.sv \
"

# apb_i2c
set SRC_APB_I2C " \
    $IPS/apb/apb_i2c/apb_i2c.sv \
    $IPS/apb/apb_i2c/i2c_master_bit_ctrl.sv \
    $IPS/apb/apb_i2c/i2c_master_byte_ctrl.sv \
    $IPS/apb/apb_i2c/i2c_master_defines.sv \
"
set INC_APB_I2C " \
    $IPS/apb/apb_i2c/. \
"

# adv_dbg_if
set SRC_ADV_DBG_IF " \
    $IPS/adv_dbg_if/rtl/adbg_axi_biu.sv \
    $IPS/adv_dbg_if/rtl/adbg_axi_module.sv \
    $IPS/adv_dbg_if/rtl/adbg_crc32.v \
    $IPS/adv_dbg_if/rtl/adbg_or1k_biu.sv \
    $IPS/adv_dbg_if/rtl/adbg_or1k_module.sv \
    $IPS/adv_dbg_if/rtl/adbg_or1k_status_reg.sv \
    $IPS/adv_dbg_if/rtl/adbg_top.sv \
    $IPS/adv_dbg_if/rtl/bytefifo.v \
    $IPS/adv_dbg_if/rtl/syncflop.v \
    $IPS/adv_dbg_if/rtl/syncreg.v \
    $IPS/adv_dbg_if/rtl/adbg_tap_top.v \
    $IPS/adv_dbg_if/rtl/adv_dbg_if.sv \
    $IPS/adv_dbg_if/rtl/adbg_axionly_top.sv \
"
set INC_ADV_DBG_IF " \
    $IPS/adv_dbg_if/rtl \
"

# core2axi
set SRC_CORE2AXI " \
    $IPS/axi/core2axi/rtl/core2axi.sv \
"

# apb_node
set SRC_APB_NODE " \
    $IPS/apb/apb_node/apb_node.sv \
    $IPS/apb/apb_node/apb_node_wrap.sv \
"

# apb2per
set SRC_APB2PER " \
    $IPS/apb/apb2per/apb2per.sv \
"

# ahb_node
set SRC_AHB " \
    $IPS/ahb/src_ahb/DW_amba_constants.v \
    $IPS/ahb/src_ahb/DW_ahb_cc_constants.v \
    $IPS/ahb/src_ahb/DW_ahb_constants.v \
    $IPS/ahb/src_ahb/DW_ahb_bcm_params.v \
    $IPS/ahb/src_ahb/DW_ahb_bcm02.v \
    $IPS/ahb/src_ahb/DW_ahb_bcm01.v \
    $IPS/ahb/src_ahb/DW_ahb_bcm53.v \
    $IPS/ahb/src_ahb/DW_ahb_arbif.v \
    $IPS/ahb/src_ahb/DW_ahb_dcdr.v \
    $IPS/ahb/src_ahb/DW_ahb_dfltslv.v \
    $IPS/ahb/src_ahb/DW_ahb_ebt.v \
    $IPS/ahb/src_ahb/DW_ahb_gctrl.v \
    $IPS/ahb/src_ahb/DW_ahb_mask.v \
    $IPS/ahb/src_ahb/DW_ahb_mux.v \
    $IPS/ahb/src_ahb/DW_ahb_gating.v \
    $IPS/ahb/src_ahb/DW_ahb_arb.v \
    $IPS/ahb/src_ahb/DW_ahb.v \
    $IPS/ahb/src_ahb/DW_ahb-undef.v \
"

# ahb_ann
set SRC_ANN " \
    $IPS/ahb/src_ann/acc_fifo.v \
    $IPS/ahb/src_ann/busreq_sm.v \
    $IPS/ahb/src_ann/npu.v \
    $IPS/ahb/src_ann/ahb_ann.v \
    $IPS/ahb/src_ann/fifo_fwf_128x26.v \
    $IPS/ahb/src_ann/madd_ch_generic.v \
    $IPS/ahb/src_ann/ram512x8.v \
    $IPS/ahb/src_ann/ahb_master.v \
    $IPS/ahb/src_ann/fifo_fwf_128x8.v \
    $IPS/ahb/src_ann/madd_generic.v \
    $IPS/ahb/src_ann/pe.v \
    $IPS/ahb/src_ann/ahb_slave.v \
    $IPS/ahb/src_ann/fifo_fwf.v \
    $IPS/ahb/src_ann/npu_if_crl.v \
    $IPS/ahb/src_ann/pu.v \
    $IPS/ahb/src_ann/ram2048x8.v \
    $IPS/ahb/src_ann/sigmoid_lut.v \
    $IPS/ahb/src_ann/fifo.v \
    $IPS/ahb/src_ann/ram1024x21.v \
    $IPS/ahb/src_ann/sigmoid.v \
"
set INC_AHB_ANN " \
    $IPS/ahb/src_ann/. \
"

# ahb_camera
set SRC_CAMERA " \
    $IPS/ahb/src_camera/camera_ahb_master.v \
    $IPS/ahb/src_camera/camera_bridge.v \
    $IPS/ahb/src_camera/camera_capture.v \
    $IPS/ahb/src_camera/camera_csr.v \
"

# ahb_common
set SRC_AHB_COMMON " \
    $IPS/ahb/src_common/DW_minmax_fpga.v \
    $IPS/ahb/src_common/DW01_inc_fpga.v \
    $IPS/ahb/src_common/dll_delay_element.v \
    $IPS/ahb/src_common/dll_delay_line_128.v \
    $IPS/ahb/src_common/dll_delay_line_256.v \
    $IPS/ahb/src_common/dll_delay_line_512.v \
    $IPS/ahb/src_common/mdlr.v \
"

# ahb_emmc
set SRC_EMMC " \
    $IPS/ahb/src_emmc/DWC_mobile_storage_params.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_derived_params.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_clk_mux_4x1.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_clk_mux_2x1.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_clk_and.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_clk_or.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_ahb2apb.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_regb.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_dma.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_cdet.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_2clk_fifoctl.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_biu.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_b2c.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_c2b.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_2clk_dssram.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_autostop.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_rxfifowr.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_txfiford.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_crc7.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_crc16.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_c2b2clk.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_intrcntl.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_clkcntl.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_clkmux_interleave.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_muxdemux.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_bcm21.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_cmdpath.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_datatx.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_datarx.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_datapath.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_ciu.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_dmac_if.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_dmac_csr.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_dmac_cntrl.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_ahb_ahm.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_dmac_ahb.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_top.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage_clk_ctrl.v \
    $IPS/ahb/src_emmc/DWC_mobile_storage-undef.v \
"
set INC_EMMC " \
    $IPS/ahb/src_emmc/. \
"

# ahb_memctl
set SRC_MCTL " \
    $IPS/ahb/src_mctl/DW_memctl_params.v \
    $IPS/ahb/src_mctl/DW_memctl_bcm_params.v \
    $IPS/ahb/src_mctl/DW_memctl_constants.v \
    $IPS/ahb/src_mctl/DW_memctl_bcm01.v \
    $IPS/ahb/src_mctl/DW_memctl_hiu.v \
    $IPS/ahb/src_mctl/DW_memctl_hiu_afifo.v \
    $IPS/ahb/src_mctl/DW_memctl_fifo.v \
    $IPS/ahb/src_mctl/DW_memctl_hiu_acore.v \
    $IPS/ahb/src_mctl/DW_memctl_hiu_dfifo.v \
    $IPS/ahb/src_mctl/DW_memctl_hiu_dcore.v \
    $IPS/ahb/src_mctl/DW_memctl_hiu_ctl.v \
    $IPS/ahb/src_mctl/DW_memctl_hiu_rbuf.v \
    $IPS/ahb/src_mctl/DW_memctl_miu_ddrwr.v \
    $IPS/ahb/src_mctl/DW_memctl_miu_dsdc.v \
    $IPS/ahb/src_mctl/DW_memctl_miu_addrdec.v \
    $IPS/ahb/src_mctl/DW_memctl_miu_refctl.v \
    $IPS/ahb/src_mctl/DW_memctl_miu_cr.v \
    $IPS/ahb/src_mctl/DW_memctl_miu_dmc.v \
    $IPS/ahb/src_mctl/DW_memctl_miu.v \
    $IPS/ahb/src_mctl/DW_memctl.v \
    $IPS/ahb/src_mctl/DW_memctl_top.v \
    $IPS/ahb/src_mctl/DW_memctl-undef.v \
"
set INC_MCTL " \
    $IPS/ahb/src_mctl/. \
"

# axi2ahb
set SRC_X2H " \
    $IPS/ahb/src_x2h/DW_axi_x2h_cc_constants.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_ahb_cgen.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_ahb_cgen_logic.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_ahb_cpipe.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_ahb_fpipe.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_ahb_if.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_ahb_master.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_arb.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_cmd_queue.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_power_ctrl.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_read_data_buffer.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_resp_buffer.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_slave.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_write_data_buffer.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_bcm57.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_bcm21.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_bcm07.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_bcm06.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_bcm05.v \
    $IPS/ahb/src_x2h/DW_axi_x2h_trcnt.v \
    $IPS/ahb/src_x2h/DW_axi_x2h.v \
    $IPS/ahb/src_x2h/DW_axi_x2h-undef.v \
"
set INC_X2H " \
    $IPS/ahb/src_x2h/. \
"

# core
set SRC_CORE " \
   $RTL/core/ahb_subsystem.v \
   $RTL/core/periph_bus_wrap.sv \
   $RTL/core/clk_div2.v \
   $RTL/core/clk_rst_gen.sv \
   $RTL/core/pll.sv \
   $RTL/core/ppu_top.sv \
   $RTL/core/core_region.sv \
   $RTL/core/instr_ram_wrap.sv \
   $RTL/core/sp_ram_wrap.sv \
   $RTL/core/boot_code.sv \
   $RTL/core/boot_rom_wrap.sv \
   $RTL/core/peripherals.sv \
"

# core0
set SRC_CORE0 " \
   $RTL/core0/periph_bus_wrap0.sv \
   $RTL/core0/clk_rst_gen0.sv \
   $RTL/core0/pll0.sv \
   $RTL/core0/ppu0_top.sv \
   $RTL/core0/core_region0.sv \
   $RTL/core0/instr_ram_wrap0.sv \
   $RTL/core0/sp_ram_wrap0.sv \
   $RTL/core0/boot_code0.sv \
   $RTL/core0/boot_rom_wrap0.sv \
   $RTL/core0/peripherals0.sv \
"
# components
set SRC_COMPONENTS " \
   $RTL/components/cluster_clock_gating.sv \
   $RTL/components/cluster_clock_inverter.sv \
   $RTL/components/cluster_clock_mux2.sv \
   $RTL/components/iomux.sv \
   $RTL/components/rstgen_lock.sv \
   $RTL/components/generic_fifo.sv \
   $RTL/axi2apb_wrap.sv \
   $RTL/axi_mem_if_SP_wrap.sv \
   $RTL/axi_node_intf_wrap.sv \
   $RTL/axi_slice_wrap.sv \
   $RTL/axi_spi_slave_wrap.sv \
   $RTL/core2axi_wrap.sv \
   $RTL/iobuf.sv \
   $RTL/ram_mux.sv \
   $RTL/top.sv \
   $FPGA_RTL/fpga_top.v \   
"

add_files -norecurse -scan_for_includes $SRC_APB_GPIO
add_files -norecurse -scan_for_includes $SRC_AXI_SLICE_DC
add_files -norecurse -scan_for_includes $SRC_APB_EVENT_UNIT
add_files -norecurse -scan_for_includes $SRC_AXI_NODE
add_files -norecurse -scan_for_includes $SRC_RISCV
add_files -norecurse -scan_for_includes $SRC_APB_PULPINO
add_files -norecurse -scan_for_includes $SRC_APB_PWM
add_files -norecurse -scan_for_includes $SRC_AXI_MEM_IF_DP
add_files -norecurse -scan_for_includes $SRC_AXI_SLICE
add_files -norecurse -scan_for_includes $SRC_APB_UART
add_files -norecurse -scan_for_includes $SRC_APB_SPI_MASTER
add_files -norecurse -scan_for_includes $SRC_APB_TIMER
add_files -norecurse -scan_for_includes $SRC_AXI2APB
add_files -norecurse -scan_for_includes $SRC_AXI_SPI_SLAVE
add_files -norecurse -scan_for_includes $SRC_APB_I2C
add_files -norecurse -scan_for_includes $SRC_ADV_DBG_IF
add_files -norecurse -scan_for_includes $SRC_CORE2AXI
add_files -norecurse -scan_for_includes $SRC_APB_NODE
add_files -norecurse -scan_for_includes $SRC_APB2PER

add_files -norecurse -scan_for_includes $SRC_AHB
add_files -norecurse -scan_for_includes $SRC_CAMERA
add_files -norecurse -scan_for_includes $SRC_AHB_COMMON
add_files -norecurse -scan_for_includes $SRC_EMMC
add_files -norecurse -scan_for_includes $SRC_MCTL
add_files -norecurse -scan_for_includes $SRC_X2H
add_files -norecurse -scan_for_includes $SRC_ANN

add_files -norecurse -scan_for_includes $SRC_CORE
add_files -norecurse -scan_for_includes $SRC_CORE0

add_files -norecurse -scan_for_includes $SRC_COMPONENTS
