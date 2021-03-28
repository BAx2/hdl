# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_sevenseg
adi_ip_files  axi_sevenseg [list \
  "hdl/SevenSegController_v1_0.v" \
  "hdl/SevenSegController_v1_0_S00_AXI.v" \
  "hdl/binary_to_bcd.v"
  ]

adi_ip_properties axi_sevenseg
set cc [ipx::current_core]

ipx::save_core $cc
