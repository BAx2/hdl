
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project hdmi-out_pynq-z2
adi_project_files hdmi-out [list \
  "system_top.v" \
  "system_constr.xdc" \
  "placer_constr.xdc"]

adi_project_run hdmi-out_pynq-z2
