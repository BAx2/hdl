# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create rgb2dvi
adi_ip_files  rgb2dvi [list \
"src/ClockGen.vhd" \
"src/DVI_Constants.vhd" \
"src/OutputSERDES.vhd" \
"src/rgb2dvi_clocks.xdc" \
"src/rgb2dvi_ooc.xdc" \
"src/rgb2dvi.vhd" \
"src/rgb2dvi.xdc" \
"src/SyncAsyncReset.vhd" \
"src/SyncAsync.vhd" \
"src/TMDS_Encoder.vhd"]

adi_ip_properties_lite axi_rgbled

set cc [ipx::current_core]

ipx::save_core $cc