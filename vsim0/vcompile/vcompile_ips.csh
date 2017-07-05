#!/usr/bin/tcsh

echo ""
echo "${Green}--> Compiling PPU IPs libraries... ${NC}"
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_apb_gpio.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_axi_slice_dc.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_apb_event_unit.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_axi_node.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_riscv.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_apb_pulpino.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_axi_mem_if_DP.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_axi_slice.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_apb_uart.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_apb_spi_master.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_apb_timer.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_apb_pwm.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_axi2apb.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_axi_spi_slave.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_apb_i2c.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_adv_dbg_if.csh || exit 1
#tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_axi_spi_master.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_core2axi.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_apb_node.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_apb2per.csh || exit 1

tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_ahb_ann.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_ahb_common.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_ahb_mctl.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_ahb_camera.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_ahb_emmc.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_ahb_node.csh || exit 1
tcsh ${PPU_PATH}/./vsim/vcompile/ips/vcompile_axi2ahb.csh || exit 1

