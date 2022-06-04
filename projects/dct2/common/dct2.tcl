ad_ip_instance axi_vdma vdma [list \
    c_num_fstores {3} \
    c_m_axis_mm2s_tdata_width {64} \
    c_mm2s_genlock_mode {0} \
    c_s2mm_genlock_mode {0} \
    c_mm2s_max_burst_length {32} \
    c_s2mm_max_burst_length {32} \
    c_include_s2mm_dre {1} \
    c_include_mm2s_dre {1} \
]

ad_ip_instance Dct2 dct

# clock
ad_connect  sys_cpu_clk     /vdma/m_axis_mm2s_aclk
ad_connect  sys_cpu_clk     /vdma/s_axis_s2mm_aclk
ad_connect  sys_cpu_clk     /dct/s_axis_aclk

# interconnect (cpu)
ad_cpu_interconnect 0x41200000      vdma

# interconnect (mem/vdma)
ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp0_interconnect sys_cpu_clk vdma/M_AXI_MM2S
ad_mem_hp0_interconnect sys_cpu_clk vdma/M_AXI_S2MM

# interrupts
ad_cpu_interrupt ps-0 mb-0 vdma/s2mm_introut
ad_cpu_interrupt ps-1 mb-1 vdma/mm2s_introut

# connections
ad_connect vdma/M_AXIS_MM2S dct/s_axis
ad_connect dct/m_axis       vdma/S_AXIS_S2MM

ad_connect sys_rstgen/peripheral_reset  dct/s_axis_areset
    