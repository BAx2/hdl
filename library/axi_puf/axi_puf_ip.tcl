# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_puf
adi_ip_files  axi_puf [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "lfsr/LFSR_CFG.vhd" \
  "axi_puf.v"]

adi_ip_properties axi_puf
set cc [ipx::current_core]

ipx::save_core $cc
