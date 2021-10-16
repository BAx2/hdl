
# create board design
# interface ports

# source ../../scripts/adi_env.tcl ; source ../../scripts/adi_board.tcl ; source ../../scripts/adi_pd.tcl

# instance: sys_ps7
# set_property board_part tul.com.tw:pynq-z2:part0:1.0 [current_project]

ad_ip_instance processing_system7 sys_ps7
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 \
   -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells sys_ps7]

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect  sys_cpu_clk sys_ps7/FCLK_CLK0
ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N

# generic system clocks pointers
set sys_cpu_clk           [get_bd_nets sys_cpu_clk]
set sys_cpu_reset         [get_bd_nets sys_cpu_reset]
set sys_cpu_resetn        [get_bd_nets sys_cpu_resetn]


# system id

ad_ip_instance axi_sysid axi_sysid_0
ad_ip_instance sysid_rom rom_sys_0

ad_connect  axi_sysid_0/rom_addr   	rom_sys_0/rom_addr
ad_connect  axi_sysid_0/sys_rom_data   	rom_sys_0/rom_data
ad_connect  sys_cpu_clk                 rom_sys_0/clk

# interconnects and address mapping

ad_cpu_interconnect 0x43c00000 axi_sysid_0
