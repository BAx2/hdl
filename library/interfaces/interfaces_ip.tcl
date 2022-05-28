source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_if_define "tmds"
adi_if_ports output 1 clk_p
adi_if_ports output 1 clk_n
adi_if_ports output 3 data_p
adi_if_ports output 3 data_n
