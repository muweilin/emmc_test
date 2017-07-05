#add smic mc ram 
set core [find instances -recursive -bydu core_region -nodu]

add wave -label "CPU_I_RAM_bank0" $core/instr_mem/sp_ram_wrap_i/sp_ram_0/sp_ram_smic/mem_array
add wave -label "CPU_I_RAM_bank1" $core/instr_mem/sp_ram_wrap_i/sp_ram_1/sp_ram_smic/mem_array

add wave -label "CPU_D_RAM_bank0" $core/data_mem/sp_ram_0/sp_ram_smic/mem_array
add wave -label "CPU_D_RAM_bank1" $core/data_mem/sp_ram_1/sp_ram_smic/mem_array

