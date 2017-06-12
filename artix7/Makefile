all: ips

.PHONY: ips
ips: clk mem ppu


.PHONY: clk
clk: ips/xilinx_clock_manager/ip/xilinx_clock_manager.dcp

ips/xilinx_clock_manager/ip/xilinx_clock_manager.dcp:
	make -C ips/xilinx_clock_manager/ clean all


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
	make -C ips/xilinx_mem_16384x32/ clean
	make -C ips/xilinx_mem_8192x32/ clean 
	make -C ips/xilinx_mem_1024x24/ clean
	make -C ips/xilinx_mem_128x26_dp/ clean
	make -C ips/xilinx_mem_128x8_dp/ clean
	make -C ips/xilinx_mem_256x8/ clean 
	make -C ips/xilinx_mem_512x32_dp/ clean
	make -C ips/ppu/ clean
	rm *.bit
