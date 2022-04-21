source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create PWM
adi_ip_files  PWM [list \
  "hdl/PWM_AXI.sv" \
  "hdl/PWM.sv" \
]

adi_ip_properties PWM
set cc [ipx::current_core]

ipx::save_core $cc
