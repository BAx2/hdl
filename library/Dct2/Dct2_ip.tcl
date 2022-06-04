source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create Dct2

adi_ip_files  Dct2 [list \
    "src/rtl/Dct2.v" \
    "src/rtl/AxisReg.sv" \
    "src/rtl/Bram.sv" \
    "src/rtl/Dct1D.sv" \
    "src/rtl/Dct2D.sv" \
    "src/rtl/DctBuffer.sv" \
    "src/rtl/Dffren.sv" \
    "src/rtl/ParallelToSerial.sv" \
    "src/rtl/Rotate.sv" \
]
adi_ip_properties_lite Dct2

set cc [ipx::current_core]

adi_add_bus "s_axis" "slave" \
    "xilinx.com:interface:axis_rtl:1.0" \
    "xilinx.com:interface:axis:1.0" \
    {
        {"s_axis_tvalid" "TVALID"} \
        {"s_axis_tready" "TREADY"} \
        {"s_axis_tdata"  "TDATA"} \
        {"s_axis_tlast"  "TLAST"} \
        {"s_axis_tuser"  "TUSER"} \
    }

adi_add_bus "m_axis" "master" \
    "xilinx.com:interface:axis_rtl:1.0" \
    "xilinx.com:interface:axis:1.0" \
    {
        {"m_axis_tvalid" "TVALID"} \
        {"m_axis_tready" "TREADY"} \
        {"m_axis_tdata"  "TDATA"} \
        {"m_axis_tlast"  "TLAST"} \
        {"m_axis_tuser"  "TUSER"} \
    }

adi_add_bus_clock "s_axis_aclk" "s_axis" "s_axis_areset"
adi_add_bus_clock "s_axis_aclk" "m_axis" "s_axis_areset"

ipx::save_core $cc
