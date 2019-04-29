# Basic makefile for compiling and running Modelsim/Questa simulations
# Cevero Project - DCA/UFRN
# Author: Diego Cirilo (dvcirilo@gmail.com)
#
# This assumes that the top level module has the same name as the folder
# And that the testbench is named tb_*toplevel*.v
# e.g. directory "adder", toplevel module "adder", testbench file "tb_adder.v"

CC = vlog
SIM = vsim
TOP_LEVEL = $(shell basename `pwd` | tr '-' '_')
WORK = work

default: all

all: compile run

compile: 
# Checks if work library exists and creates one otherwise
	if [ ! -e $(WORK) ]; then \
        vlib $(WORK); \
        vmap $(WORK) $(WORK); \
    fi
# Compiles all verilog files in the "default" folders
	$(CC) -sv -mfcu ../ip/zero-riscy/include/*.sv ../ip/zero-riscy/*.sv \
		../soc_utils/*.sv rtl/*.sv tb/*.sv +incdir+../ip/zero-riscy/include

# Executes the simulation in batch mode using the commands on the script/run.do
# file.
run:
	$(SIM) -batch -do script/run.do work.tb_$(TOP_LEVEL)

# Removes all generated files
clean:
	rm -rf modelsim.ini transcript $(WORK) build/*

# Makes sure none of the make targets are not mistaken by input files
.PHONY: all run clean
