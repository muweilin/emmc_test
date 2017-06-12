#!/bin/bash
# \
exec vsim -64 -do "$0"

set TB            tb
set VSIM_FLAGS    "-gTEST=\"ANN\""
set MEMLOAD       "SPI"
set RUNMODE       "STANDALONE"

source ./tcl_files/config/vsim.tcl
