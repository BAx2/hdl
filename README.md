# HDL Designs

This repository contains HDL code (Verilog, SystemVerilog or VHDL) and the required Tcl scripts to create and build a specific FPGA design.

# Requirements for HW build

* Vivado 2021.1
* GNU make

# Linux

source /xilinx/Vivado/2021.1/settings64.sh

# Windows 

* Install cygwin with GNU make
* Update ~/.bashrc (example):
* export PATH=$PATH:/cygdrive/d/xilinx/Vivado/2021.1/bin
* export PATH=$PATH:/cygdrive/d/xilinx/Vivado_HLS/2021.1/bin
* export PATH=$PATH:/cygdrive/d/xilinx/SDK/2021.1/bin
* export PATH=$PATH:/cygdrive/d/xilinx/SDK/2021.1/gnu/microblaze/nt/bin
* export PATH=$PATH:/cygdrive/d/xilinx/SDK/2021.1/gnu/arm/nt/bin
* export PATH=$PATH:/cygdrive/d/xilinx/SDK/2021.1/gnu/microblaze/linux_toolchain/nt64_be/bin
* export PATH=$PATH:/cygdrive/d/xilinx/SDK/2021.1/gnu/microblaze/linux_toolchain/nt64_le/bin
* export PATH=$PATH:/cygdrive/d/xilinx/SDk/2021.1/gnu/aarch32/nt/gcc-arm-none-eabi/bin

# Copy board files to Vivado board_files directory
.\board_files d:\Xilinx\Vivado\2020.2\data\boards\board_files\

# Generate project files 

$ make proj.board

# References 
1. https://github.com/analogdevicesinc/hdl
2. https://github.com/Digilent/Nexys-4-OOB
3. https://github.com/Digilent/digilent-xdc
4. https://github.com/andrewsil1/NexysPsram/
5. https://github.com/andrewsil1/SevenSegController
