
create_pblock hdmi_out_pblock
add_cells_to_pblock hdmi_out_pblock [get_cells i_system_wrapper/system_i/vdma]
add_cells_to_pblock hdmi_out_pblock [get_cells i_system_wrapper/system_i/dynclk]
add_cells_to_pblock hdmi_out_pblock [get_cells i_system_wrapper/system_i/vid_timing_ctl]
add_cells_to_pblock hdmi_out_pblock [get_cells i_system_wrapper/system_i/axis_to_vid_out]
add_cells_to_pblock hdmi_out_pblock [get_cells i_system_wrapper/system_i/hdmi_out]
resize_pblock [get_pblocks hdmi_out_pblock] -add {CLOCKREGION_X1Y2:CLOCKREGION_X1Y2}

#create_clock -period 13.000 -name pixel_clock -waveform {0.000 6.500} [get_nets -hierarchical system_i/pixel_clk]
#create_clock -period  2.600 -name pixel_clock_5x -waveform {0.000 1.300} [get_nets -hierarchical system_i/pixel_clk_5x]

