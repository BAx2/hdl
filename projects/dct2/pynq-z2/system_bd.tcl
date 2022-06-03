source $ad_hdl_dir/projects/common/pynq-z2/pynq-z2_system_bd.tcl
source $ad_hdl_dir/projects/common/pynq-z2/pynq-z2_system_ps7.tcl
source ../common/dct2.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# board specific peripheral

# leds & buttons
ad_ip_instance PWM rgb_pwm [list \
    NUM_PWM {6}
]

ad_cpu_interconnect 0x41300000      rgb_pwm

create_bd_port -dir O -from 5 -to 0 rgb

ad_connect rgb_pwm/pwm rgb
