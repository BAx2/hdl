
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project exp-puf-001_nexys4
adi_project_files exp-puf-001 [list \
  "system_top.v" \
  "$ad_hdl_dir/projects/common/nexys4/nexys4_system_constr.xdc"
  ]

adi_project_run exp-puf-001_nexys4

