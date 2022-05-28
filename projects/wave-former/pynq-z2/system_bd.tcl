source $ad_hdl_dir/projects/common/pynq-z2/pynq-z2_system_bd.tcl
source $ad_hdl_dir/projects/common/pynq-z2/pynq-z2_system_ps7.tcl
source ../common/my_scripts.tcl
source ../common/wave-former.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

# my_group_bd_cell sysid_subsystem [list \
#     rom_sys_0 \
#     GND_32 \
#     axi_sysid_0 \
# ]

sysid_gen_sys_init_file
