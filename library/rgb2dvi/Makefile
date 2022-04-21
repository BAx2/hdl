####################################################################################

LIBRARY_NAME := rgb2dvi

GENERIC_DEPS += src/ClockGen.vhd
GENERIC_DEPS += src/DVI_Constants.vhd
GENERIC_DEPS += src/OutputSERDES.vhd
GENERIC_DEPS += src/rgb2dvi_clocks.xdc
GENERIC_DEPS += src/rgb2dvi_ooc.xdc
GENERIC_DEPS += src/rgb2dvi.vhd
GENERIC_DEPS += src/rgb2dvi.xdc
GENERIC_DEPS += src/SyncAsyncReset.vhd
GENERIC_DEPS += src/SyncAsync.vhd
GENERIC_DEPS += src/TMDS_Encoder.vhd

XILINX_DEPS += rgb2dvi_ip.tcl

XILINX_DEPS += ../interfaces/tmds.xml
XILINX_DEPS += ../interfaces/tmds_rtl.xml

XILINX_INTERFACE_DEPS += interfaces

include ../scripts/library.mk
