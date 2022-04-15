source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_dynclk
adi_ip_files  axi_dynclk [list \
  "src/axi_dynclk_S00_AXI.vhd" \
  "src/axi_dynclk.vhd" \
  "src/mmcme2_drp.v"]

adi_ip_properties axi_dynclk
set cc [ipx::current_core]

ipx::save_core $cc
