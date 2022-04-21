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

adi_ip_properties_lite rgb2dvi

set cc [ipx::current_core]

adi_add_bus "RGB" "slave" \
    "xilinx.com:interface:vid_io_rtl:1.0" \
    "xilinx.com:interface:vid_io:1.0" \
    { \
        { "vid_pData"  "DATA" } \
        { "vid_pVDE"   "ACTIVE_VIDEO" } \
        { "vid_pHSync" "HSYNC" } \
        { "vid_pVSync" "VSYNC" } \
    }

adi_add_bus_clock "PixelClk" "RGB" "aRst"

adi_add_bus "TMDS" "master" \
    "analog.com:interface:tmds_rtl:1.0" \
    "analog.com:interface:tmds:1.0" \
    { \
        { "TMDS_Clk_p"  "clk_p" } \
        { "TMDS_Clk_n"  "clk_n" } \
        { "TMDS_Data_p" "data_p" } \
        { "TMDS_Data_n" "data_n" } \
    }

ipx::save_core $cc