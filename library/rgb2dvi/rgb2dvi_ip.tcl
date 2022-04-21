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
    "src/TMDS_Encoder.vhd"\
]

adi_ip_properties_lite rgb2dvi

adi_add_bus "RGB" "slave" \
    "xilinx.com:interface:vid_io_rtl:1.0" \
    "xilinx.com:interface:vid_io:1.0" \
    { \
        { "vid_pData"  "DATA" } \
        { "vid_pVDE"   "ACTIVE_VIDEO" } \
        { "vid_pHSync" "HSYNC" } \
        { "vid_pVSync" "VSYNC" } \
    }

adi_add_bus_clock "PixelClk" "RGB"

adi_add_bus "TMDS" "master" \
    "analog.com:interface:tmds_rtl:1.0" \
    "analog.com:interface:tmds:1.0" \
    { \
        { "TMDS_Clk_p"  "clk_p" } \
        { "TMDS_Clk_n"  "clk_n" } \
        { "TMDS_Data_p" "data_p" } \
        { "TMDS_Data_n" "data_n" } \
    }

set cc [ipx::current_core]
set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

# Generate SerialClk internally
set param [ipgui::add_param -name {kGenerateSerialClk} -component $cc -parent $page0]
set_property -dict [list \
    "display_name"  "Generate SerialClk internally from pixel clock" \
    "widget"        "checkBox" \
    "show_label"    "true" \
] $param

# Reset
set param [ipgui::add_param -name {kRstActiveHigh} -component $cc -parent $page0]
set_property -dict [list \
    "display_name"  "Reset active high" \
    "widget"        "checkBox" \
    "show_label"    "true" \
] $param

# MMCM/PLL
set param [ipgui::get_guiparamspec -name "kClkPrimitive" -component $cc]
ipgui::move_param -component $cc -order 2 $param -parent $page0
set_property -dict [list \
    "display_name"  "MMCM/PLL" \
    "tooltip"       "kClkPrimitive" \
    "widget"        "comboBox" \
] $param

set_property -dict [list \
    value_validation_type pairs \
    value_validation_pairs {PLL "PLL" MMCM "MMCM"} \
] [ipx::get_user_parameters $param -of_objects $cc]

# TMDS clock range
set param [ipgui::get_guiparamspec -name "kClkRange" -component $cc]
ipgui::move_param -component $cc -order 3 $param -parent $page0
set_property -dict [list \
    "display_name"  "TMDS clock range" \
    "tooltip"       "kClkRange" \
    "widget"        "comboBox" \
] $param

set_property -dict [list \
    value_validation_type pairs \
    value_validation_pairs {">=120MHz" 1 ">=60MHz" 2 ">=40MHz" 3} \
] [ipx::get_user_parameters $param -of_objects $cc]

ipx::save_core $cc
