#
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:emc_rtl:1.0  PSRAM_0

# inctance PSRAM
# PSRAM hacks
ad_ip_instance axi_psram axi_psram_cntrl
#ad_connect axi_psram_cntrl/PSRAM PSRAM_0
ad_connect axi_psram_cntrl/emc_1 PSRAM_0

ad_ip_instance axi_interconnect axi_mem_interconnect
set_property CONFIG.NUM_SI {2} [get_bd_cells axi_mem_interconnect]
set_property CONFIG.NUM_MI {1} [get_bd_cells axi_mem_interconnect]

ad_connect sys_cpu_clk axi_mem_interconnect/ACLK
ad_connect axi_mem_interconnect/ARESETN sys_rstgen/peripheral_aresetn
ad_connect sys_cpu_clk axi_mem_interconnect/M00_ACLK
ad_connect axi_mem_interconnect/M00_ARESETN sys_rstgen/peripheral_aresetn
ad_connect sys_cpu_clk axi_mem_interconnect/S00_ACLK
ad_connect axi_mem_interconnect/S00_ARESETN sys_rstgen/peripheral_aresetn
ad_connect sys_cpu_clk axi_mem_interconnect/S01_ACLK
ad_connect axi_mem_interconnect/S01_ARESETN sys_rstgen/peripheral_aresetn

ad_connect sys_cpu_clk axi_psram_cntrl/s_axi_aclk
ad_connect axi_psram_cntrl/s_axi_aresetn sys_rstgen/peripheral_aresetn

ad_connect axi_psram_cntrl/s_axi axi_mem_interconnect/M00_AXI
ad_connect sys_mb/M_AXI_IC axi_mem_interconnect/S00_AXI
ad_connect sys_mb/M_AXI_DC axi_mem_interconnect/S01_AXI

create_bd_addr_seg -range 0x1000000 -offset 0x76000000 [get_bd_addr_spaces sys_mb/Data] \
  [get_bd_addr_segs axi_psram_cntrl/s_axi/axi] SEG_dsram_cntlr
create_bd_addr_seg -range 0x1000000 -offset 0x76000000 [get_bd_addr_spaces sys_mb/Instruction] \
  [get_bd_addr_segs axi_psram_cntrl/s_axi/axi] SEG_isram_cntlr


create_bd_addr_seg -range 0x4000 -offset 0x0 [get_bd_addr_spaces sys_mb/Data] \
  [get_bd_addr_segs sys_dlmb_cntlr/SLMB/Mem] SEG_dlmb_cntlr
create_bd_addr_seg -range 0x4000 -offset 0x0 [get_bd_addr_spaces sys_mb/Instruction] \
  [get_bd_addr_segs sys_ilmb_cntlr/SLMB/Mem] SEG_ilmb_cntlr





if 0 {
###
set interconnect_master_idx [ get_property CONFIG.NUM_SI [get_bd_cells axi_cpu_interconnect] ]
set_property CONFIG.NUM_SI [expr ($interconnect_master_idx + 2)] [get_bd_cells axi_cpu_interconnect]

set curr_idx  $interconnect_master_idx
ad_connect sys_mb/M_AXI_DC axi_cpu_interconnect/S0${curr_idx}_AXI
ad_connect sys_cpu_clk axi_cpu_interconnect/S0${curr_idx}_ACLK
ad_connect axi_cpu_interconnect/S0${curr_idx}_ARESETN sys_rstgen/peripheral_aresetn

set curr_idx  [expr ($interconnect_master_idx + 1)]
ad_connect sys_mb/M_AXI_IC axi_cpu_interconnect/S0${curr_idx}_AXI
ad_connect sys_cpu_clk axi_cpu_interconnect/S0${curr_idx}_ACLK
ad_connect axi_cpu_interconnect/S0${curr_idx}_ARESETN sys_rstgen/peripheral_aresetn
####

set interconnect_master_idx [ get_property CONFIG.NUM_MI [get_bd_cells axi_cpu_interconnect] ]
set_property CONFIG.NUM_MI [expr ($interconnect_master_idx + 1)] [get_bd_cells axi_cpu_interconnect]
set curr_idx  $interconnect_master_idx
ad_connect axi_psram_cntrl/s_axi axi_cpu_interconnect/M0${curr_idx}_AXI
ad_connect sys_cpu_clk axi_psram_cntrl/s_axi_clk
ad_connect axi_psram_cntrl/s_axi_resetn sys_rstgen/peripheral_aresetn
ad_connect sys_cpu_clk axi_cpu_interconnect/M0${curr_idx}_ACLK
ad_connect axi_cpu_interconnect/M0${curr_idx}_ARESETN sys_rstgen/peripheral_aresetn
}

#set_property -dict [list CONFIG.C_S00_AXI_ID_WIDTH {2}] [get_bd_cells axi_psram_cntrl]
#set D_size [expr ($interconnect_master_idx + 1)]
#set C_size [expr ($interconnect_master_idx + 2)]
#global sys_cpu_interconnect_index
#set sys_cpu_interconnect_index [ get_property CONFIG.NUM_MI [get_bd_cells axi_cpu_interconnect] ]

