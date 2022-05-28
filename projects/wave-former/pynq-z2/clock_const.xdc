
create_clock -period 13.000 -name pixel_clock \
    [get_nets i_system_wrapper/system_i/pixel_clk]
create_clock -period 2.600 -name pixel_clock_5x \
    [get_nets i_system_wrapper/system_i/pixel_clk_5x]
