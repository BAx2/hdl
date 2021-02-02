# Requirements for HW build

* Vivado 2020.2
* GNU make

# Windows 

* Install cygwin
* Update ~/.bashrc (example):

export PATH=$PATH:/cygdrive/d/xilinx/Vivado/2020.2/bin
export PATH=$PATH:/cygdrive/d/xilinx/Vivado_HLS/2020.2/bin
export PATH=$PATH:/cygdrive/d/xilinx/SDK/2020.2/bin
export PATH=$PATH:/cygdrive/d/xilinx/SDK/2020.2/gnu/microblaze/nt/bin
export PATH=$PATH:/cygdrive/d/xilinx/SDK/2020.2/gnu/arm/nt/bin
export PATH=$PATH:/cygdrive/d/xilinx/SDK/2020.2/gnu/microblaze/linux_toolchain/nt64_be/bin
export PATH=$PATH:/cygdrive/d/xilinx/SDK/2020.2/gnu/microblaze/linux_toolchain/nt64_le/bin
export PATH=$PATH:/cygdrive/d/xilinx/SDk/2020.2/gnu/aarch32/nt/gcc-arm-none-eabi/bin


$ make all
