#!/bin/bash
# \
exec vsim -64 -do "$0"

set TB_TEST $::env(TB_TEST)

set TB            tb
set VSIM_FLAGS    " "
set MEMLOAD       "SPI"
set RUNMODE       "STANDALONE"

source ./tcl_files/config/vsim.tcl
