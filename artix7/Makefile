all: ips

.PHONY: ips
ips: clk mem ddr3 h2x ppu


.PHONY: clk
clk: ips/xilinx_clock_manager/ip/xilinx_clock_manager.dcp ips/xilinx_clock_2x/ip/xilinx_clock_2x.dcp ips/xilinx_axi_clock_convert/ip/xilinx_axi_clock_convert.dcp

ips/xilinx_clock_manager/ip/xilinx_clock_manager.dcp:
	make -C ips/xilinx_clock_manager/ clean all

ips/xilinx_clock_2x/ip/xilinx_clock_2x.dcp:
	make -C ips/xilinx_clock_2x/ clean all
	
ips/xilinx_axi_clock_convert/ip/xilinx_axi_clock_convert.dcp:
	make -C ips/xilinx_axi_clock_convert/ clean all
	
ips/xilinx_clock_div2/ip/xilinx_clock_div2.dcp:
	make -C ips/xilinx_clock_div2/ clean all

.PHONY: mem
mem: ips/xilinx_mem_16384x32/ip/xilinx_mem_16384x32.dcp ips/xilinx_mem_8192x32/ip/xilinx_mem_8192x32.dcp ips/xilinx_mem_512x32_dp/ip/xilinx_mem_512x32_dp.dcp ips/xilinx_mem_256x8/ip/xilinx_mem_256x8.dcp ips/xilinx_mem_128x8_dp/ip/xilinx_mem_128x8_dp.dcp ips/xilinx_mem_128x26_dp/ip/xilinx_mem_128x26_dp.dcp ips/xilinx_mem_1024x24/ip/xilinx_mem_1024x24.dcp

ips/xilinx_mem_16384x32/ip/xilinx_mem_16384x32.dcp:
	make -C ips/xilinx_mem_16384x32/ clean all

ips/xilinx_mem_8192x32/ip/xilinx_mem_8192x32.dcp:
	make -C ips/xilinx_mem_8192x32/ clean all

ips/xilinx_mem_512x32_dp/ip/xilinx_mem_512x32_dp.dcp:
	make -C ips/xilinx_mem_512x32_dp/ clean all

ips/xilinx_mem_256x8/ip/xilinx_mem_256x8.dcp:
	make -C ips/xilinx_mem_256x8/ clean all

ips/xilinx_mem_128x8_dp/ip/xilinx_mem_128x8_dp.dcp:
	make -C ips/xilinx_mem_128x8_dp/ clean all

ips/xilinx_mem_128x26_dp/ip/xilinx_mem_128x26_dp.dcp:
	make -C ips/xilinx_mem_128x26_dp/ clean all

ips/xilinx_mem_1024x24/ip/xilinx_mem_1024x24.dcp:
	make -C ips/xilinx_mem_1024x24/ clean all

.PHONY: ddr3
ddr3: ips/xilinx_ddr3_if/ip/xilinx_ddr3_if.dcp

ips/xilinx_ddr3_if/ip/xilinx_ddr3_if.dcp:
	make -C ips/xilinx_ddr3_if/ clean all

.PHONY: h2x
h2x: ips/xilinx_ahblite_axi_bridge/ip/h2x_bridge.dcp

ips/xilinx_ahblite_axi_bridge/ip/h2x_bridge.dcp:
	make -C ips/xilinx_ahblite_axi_bridge/ clean all

.PHONY: ppu
ppu: ips/ppu/fpga_top.bit

ips/ppu/fpga_top.bit:
	make -C ips/ppu/ clean all
	cp ips/ppu/fpga_top.bit fpga_top.bit

.PHONY: clean
clean:
	make -C ips/ppu/ clean
	rm *.bit

.PHONY: dist-clean
dist-clean:
	make -C ips/xilinx_clock_manager/ clean
	make -C ips/xilinx_clock_2x/ clean
	make -C ips/xilinx_clock_div2/ clean
	make -C ips/xilinx_ahblite_axi_bridge/ clean
	make -C ips/xilinx_ddr3_if/ clean
	make -C ips/xilinx_mem_16384x32/ clean
	make -C ips/xilinx_mem_8192x32/ clean 
	make -C ips/xilinx_mem_1024x24/ clean
	make -C ips/xilinx_mem_128x26_dp/ clean
	make -C ips/xilinx_mem_128x8_dp/ clean
	make -C ips/xilinx_mem_256x8/ clean 
	make -C ips/xilinx_mem_512x32_dp/ clean
	make -C ips/ppu/ clean
	rm *.bit
