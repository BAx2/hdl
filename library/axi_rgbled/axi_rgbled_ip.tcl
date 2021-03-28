# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_rgbled
adi_ip_files  axi_rgbled [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "hdl/pwm.vhd" \
  "hdl/axi_rgbled.v"]

adi_ip_properties axi_rgbled
set cc [ipx::current_core]

ipx::save_core $cc
