#when fpga/haps simulation is used, add bram
add wave -group "I-RAM bank 0" \
-label "ram0" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[0].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram4" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[4].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram8" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[8].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram12" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[12].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}

add wave -group "I-RAM bank 1" \
-label "ram1" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[1].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram5" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[5].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram9" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[9].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram13" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[13].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}

add wave -group "I-RAM bank 2" \
-label "ram2" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[2].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram6" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[6].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram10" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[10].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram14" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[14].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}

add wave -group "I-RAM bank 3" \
-label "ram3" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[3].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram7" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[7].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram11" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[11].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram15" {sim:/tb/top_i/core_region_i/instr_mem/sp_ram_wrap_i/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[15].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}


add wave -group "D-RAM bank 0" \
-label "ram0" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[0].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram4" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[4].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram8" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[8].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram12" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[12].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}

add wave -group "D-RAM bank 1" \
-label "ram1" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[1].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram5" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[5].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram9" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[9].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram13" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[13].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}

add wave -group "D-RAM bank 2" \
-label "ram2" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[2].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram6" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[6].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram10" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[10].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram14" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[14].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}

add wave -group "D-RAM bank 3" \
-label "ram3" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[3].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram7" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[7].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram11" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[11].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram15" {sim:/tb/top_i/core_region_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[15].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}


add wave -group "ext-RAM bank 0" \
-label "ram0" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[0].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram4" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[4].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram8" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[8].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram12" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[12].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}

add wave -group "ext-RAM bank 1" \
-label "ram1" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[1].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram5" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[5].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram9" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[9].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram13" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[13].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}

add wave -group "ext-RAM bank 2" \
-label "ram2" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[2].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram6" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[6].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram10" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[10].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram14" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[14].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}

add wave -group "ext-RAM bank 3" \
-label "ram3" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[3].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram7" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[7].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram11" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[11].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem} \
-label "ram15" {sim:/tb/top_i/peripherals_i/data_mem/sp_blk_ram_i/U0/inst_blk_mem_gen/\gnativebmg.native_blk_mem_gen /\valid.cstr /\ramloop[15].ram.r /\prim_noinit.ram /\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram /genblk1/INT_RAMB_TDP/mem}

