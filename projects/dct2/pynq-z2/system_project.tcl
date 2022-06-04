
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set board       pynq-z2
set project     dct2

set project_name ${project}_${board}
set output_dir $project_name.output_files

adi_project $project_name
adi_project_files $project [list \
    "system_top.v" \
    "system_constr.xdc" \
    "placer_constr.xdc" \
    "clock_const.xdc" \
]

adi_project_run $project_name

exec mkdir -p $output_dir
exec cp $project_name.sdk/system_top.xsa \
        $output_dir/$project_name.xsa
exec cp $project_name.gen/sources_1/bd/system/hw_handoff/system.hwh \
        $output_dir/$project_name.hwh
exec cp $project_name.runs/impl_1/system_top.bit \
        $output_dir/$project_name.bit
