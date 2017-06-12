create_clock -period 5.000 -name clk [get_nets clk]

create_clock -period 100.000 -name clk [get_nets spi_sck]

create_generated_clock -name dly_dqs0 -source [get_pins top_i/pll_i/mmc_i/clk200_o] -divide_by 4 [get_nets top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DW_memctl_top/u_rddata_sample[0]/dly_dqs_proc]

create_generated_clock -name reg_bank_clk0 -source [get_pins top_i/pll_i/mmc_i/clk200_o] -divide_by 4 [get_nets top_i/ppu_top_i/peripherals_i/ahb_subsystem_i/DW_memctl_top/u_rddata_sample[0]/reg_bank_clk_proc]


