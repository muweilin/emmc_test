PROJECT:=fpga_top

all:
	vivado -mode batch -source tcl/run.tcl
	cp fpga_top.runs/impl_1/fpga_top.bit fpga_top.bit
	#cp fpga_top.runs/impl_1/debug_nets.ltx debug_nets.ltx

gui:
	vivado -mode gui -source tcl/run.tcl &

clean:
	rm -rf simu 
	rm -rf webtalk* 
	rm -rf *.bit 
	rm -rf *.ltx 
	rm -rf ${PROJECT}.xpr
	rm -rf ${PROJECT}.data
	rm -rf ${PROJECT}.runs
	rm -rf ${PROJECT}.srcs
	rm -rf ${PROJECT}.sim
	rm -rf ${PROJECT}.cache
	rm -rf ${PROJECT}.ioplanning
	rm -rf ${PROJECT}.hw
	rm -rf component.xml
	rm -rf vivado*
	rm -rf .Xil
	rm -rf xgui
	rm -rf ${PROJECT}.edf
	rm -rf ${PROJECT}_stub.v
	rm -rf ${PROJECT}_funcsim.v
	rm -rf *.edf 
	rm -rf *.txt 
