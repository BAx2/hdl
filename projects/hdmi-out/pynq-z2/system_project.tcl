
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set project_name hdmi-out_pynq-z2
set output_dir $project_name.output_files

# adi_project hdmi-out_pynq-z2
adi_project $project_name
adi_project_files hdmi-out [list \
  "system_top.v" \
  "system_constr.xdc" \
  "placer_constr.xdc"]

# adi_project_run hdmi-out_pynq-z2
adi_project_run $project_name


exec mkdir -p $output_dir
exec cp $project_name.sdk/system_top.xsa \
        $output_dir/$project_name.xsa
exec cp $project_name.gen/sources_1/bd/system/hw_handoff/system.hwh \
        $output_dir/$project_name.hwh
exec cp $project_name.runs/impl_1/system_top.bit \
        $output_dir/$project_name.bit
