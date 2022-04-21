source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_dynclk
adi_ip_files  axi_dynclk [list \
    "src/axi_dynclk_S00_AXI.vhd" \
    "src/axi_dynclk.vhd" \
    "src/mmcme2_drp.v"\
]

adi_ip_properties axi_dynclk


adi_add_bus "PXL_CLK_O" "master" \
    "xilinx.com:signal:clock_rtl:1.0" \
    "xilinx.com:signal:clock:1.0" \
    {
        {"PXL_CLK_O" "CLK"} \
    }

adi_add_bus "PXL_CLK_5X_O" "master" \
    "xilinx.com:signal:clock_rtl:1.0" \
    "xilinx.com:signal:clock:1.0" \
    {
        {"PXL_CLK_5X_O" "CLK"} \
    }

set cc [ipx::current_core]
set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

# Add BUFMR
set param [ipgui::add_param -name {ADD_BUFMR} -component $cc -parent $page0]
set_property -dict [list \
    "display_name"  "Add BUFMR on MMCM output" \
    "widget"        "checkBox" \
    "show_label"    "true" \
] $param

ipx::save_core $cc
