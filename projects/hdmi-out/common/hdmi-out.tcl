# video out subsystem
ad_ip_instance axi_dynclk dynclk 

ad_ip_instance rgb2dvi hdmi_out [list \
    kGenerateSerialClk {false} \
]

ad_ip_instance v_axi4s_vid_out axis_to_vid_out [list \
    C_VTG_MASTER_SLAVE {1} \
]
ad_ip_instance v_tc vid_timing_ctl [list \
    enable_detection {false} \
]
ad_ip_instance axi_vdma vdma [list \
    c_m_axis_mm2s_tdata_width {24} \
    c_num_fstores {2} \
    c_mm2s_genlock_mode {0} \
    c_s2mm_genlock_mode {0} \
    c_include_s2mm {0} \
]
ad_ip_instance axi_gpio axi_gpio_hdmi_out [list \
    GPIO_BOARD_INTERFACE {hdmi_out_cec} \
    GPIO2_BOARD_INTERFACE {hdmi_out_hpd_led} \
]

# clock
ad_connect pixel_clk dynclk/PXL_CLK_O
set pixel_clk [get_bd_nets pixel_clk]

ad_connect pixel_clk_5x dynclk/PXL_CLK_5X_O
set pixel_clk_5x [get_bd_nets pixel_clk_5x]

# ref_clk must be from 60 MHz to 120 MHz
# ad_connect ref_clk sys_ps7/FCLK_CLK1
# set ref_clk [get_bd_nets ref_clk]

ad_connect pixel_clk vid_timing_ctl/clk
ad_connect pixel_clk vdma/m_axis_mm2s_aclk
ad_connect pixel_clk axis_to_vid_out/aclk
ad_connect pixel_clk hdmi_out/PixelClk

ad_connect pixel_clk_5x hdmi_out/SerialClk

ad_connect sys_cpu_clk dynclk/REF_CLK_I

# interconnect (cpu)
ad_cpu_interconnect 0x41200000 vdma
ad_cpu_interconnect 0x41210000 vid_timing_ctl
ad_cpu_interconnect 0x41220000 dynclk
ad_cpu_interconnect 0x41230000 axi_gpio_hdmi_out
# ad_cpu_interconnect 0x41240000
# ad_cpu_interconnect 0x41250000
# ad_cpu_interconnect 0x41260000

# interconnect (mem/vdma)
ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk vdma/M_AXI_MM2S

# connections
ad_connect vid_timing_ctl/vtiming_out axis_to_vid_out/vtiming_in
ad_connect vdma/M_AXIS_MM2S axis_to_vid_out/video_in
ad_connect axis_to_vid_out/vid_io_out hdmi_out/RGB

# create ports
create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 HDMI
# create_bd_port -dir O name

# connect ports
ad_connect hdmi_out/TMDS HDMI
make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_hdmi_out/GPIO]
make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_hdmi_out/GPIO2]

#outputs


