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
IBEXDIR=../ip/zero-riscy/rtl
WORK = work
SVFILES=`ls ../ip/zero-riscy/rtl/*.sv | awk '!/ibex_pkg.sv/ {print $0}'`
#FILES=$(cat ../ip/zero-riscy/rtl/ibex_core.f | tr '\n' ' ')
#SVFILES=$(addprefix $(IBEXDIR),$(FILES))

default: all

all: compile run

compile: 
# Checks if work library exists and creates one otherwise
	if [ ! -e $(WORK) ]; then \
        vlib $(WORK); \
        vmap $(WORK) $(WORK); \
    fi
# Compiles all verilog files in the "default" folders
	$(CC) -sv -mfcu ../ip/zero-riscy/rtl/ibex_pkg.sv $(SVFILES)\
		../ip/soc_components/soc_utils/*.sv rtl/*.sv tb/*.sv \
		+incdir+../ip/zero-riscy/vendor/lowrisc_ip/ip/prim/rtl \
		+incdir+../ip/zero-riscy/dv/fcov \
		+incdir+dv/uvm/core_ibex/common/prim
#+incdir+../ip/zero-riscy/vendor/lowrisc_ip/ip/prim/rtl

# Executes the simulation in batch mode using the commands on the script/run.do
# file.
run:
	$(SIM) -batch -do script/run.do work.tb_$(TOP_LEVEL)

# Removes all generated files
clean:
	rm -rf modelsim.ini transcript $(WORK) build/*

# Makes sure none of the make targets are not mistaken by input files
.PHONY: all run clean
