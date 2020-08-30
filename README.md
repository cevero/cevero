# CEVERO
Chip multi-procEssor for Very Energy-efficient aeRospace missiOns


## Getting started
This repository contains two git submodules in folders `ip/soc_components` and `ip/zero-riscy`, therefore you should initialize and update the submodules.

You may clone the repository with
```shell
git clone --recurse-submodules https://github.com/cevero/cevero.git
```
Or, after cloning, inside the project folder execute
```shell
git submodule update --init --recursive
```

## Running the default example
The default example uses the questasim simulator (our default simulation tool, refer to the makefile inside the example folder). This example will execute the Fibonacci sequence generation code and output in the terminal the result 89, which is the 12th number in the sequence.

In folder `soc_single`, execute `make all`.
