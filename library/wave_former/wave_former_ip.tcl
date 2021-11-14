# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create wave_former
adi_ip_files  wave_former [list \
    "$ad_hdl_dir/library/common/up_axi.v" \
    "axi_wave_former_regmap.sv" \
    "ctrl_unit.sv" \
    "rotate_cordic.sv" \
    "cdc_array_single.sv" \
    "delay_line.sv" \
    "vector_cordic.sv" \
    "coordinate_calc.sv" \
    "dffenr.sv" \
    "wave_decay.sv" \
    "coordinate_recalc.sv" \
    "fix_mult_sign_1_15.sv" \
    "wave_former.sv" \
    "cordic_stage.sv" \
    "horizontal_wave.sv" \
    "cordic.sv" \
    "cordic.svh" \
    "phase_generator.sv" ]
#"


adi_ip_properties wave_former
set cc [ipx::current_core]

set_property vendor {BAx2} [ipx::current_core]
set_property vendor_display_name {BAx2} [ipx::current_core]
set_property company_url {https://github.com/BAx2/} [ipx::current_core]

adi_add_bus "s_axis_video" "slave" \
    "xilinx.com:interface:axis_rtl:1.0" \
    "xilinx.com:interface:axis:1.0" \
    {
        {"s_axis_video_tvalid" "TVALID"} \
        {"s_axis_video_tready" "TREADY"} \
        {"s_axis_video_tdata"  "TDATA"} \
        {"s_axis_video_tlast"  "TLAST"} \
        {"s_axis_video_tuser"  "TUSER"} \
    }

adi_add_bus "m_axis_video" "master" \
    "xilinx.com:interface:axis_rtl:1.0" \
    "xilinx.com:interface:axis:1.0" \
    {
        {"m_axis_video_tvalid" "TVALID"} \
        {"m_axis_video_tready" "TREADY"} \
        {"m_axis_video_tdata"  "TDATA"} \
        {"m_axis_video_tlast"  "TLAST"} \
        {"m_axis_video_tuser"  "TUSER"} \
    }

adi_add_bus_clock "s_axis_video_aclk" "s_axis_video" "s_axis_video_areset"
adi_add_bus_clock "s_axis_video_aclk" "m_axis_video" "s_axis_video_areset"


ipx::save_core $cc
