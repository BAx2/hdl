# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_psram
adi_ip_files  axi_psram [list \
	"hdl/psram_ip_v1_1_S00_AXI.vhd" \
 	"hdl/psram_ip_v1_0.vhd" \
	"hdl/AsyncPSRAM.vhd" ]

adi_ip_properties_lite axi_psram

ipx::infer_bus_interface {\
  s_axi_awvalid \
  s_axi_awid \
  s_axi_awburst \
  s_axi_awlock \
  s_axi_awcache \
  s_axi_awprot \
  s_axi_awqos \
  s_axi_awuser \
  s_axi_awlen \
  s_axi_awsize \
  s_axi_awaddr \
  s_axi_awready \
  s_axi_awregion \
  s_axi_wvalid \
  s_axi_wdata \
  s_axi_wstrb \
  s_axi_wlast \
  s_axi_wuser \
  s_axi_wready \
  s_axi_bvalid \
  s_axi_bid \
  s_axi_bresp \
  s_axi_buser \
  s_axi_bready \
  s_axi_arvalid \
  s_axi_arid \
  s_axi_arburst \
  s_axi_arlock \
  s_axi_arcache \
  s_axi_arprot \
  s_axi_arqos \
  s_axi_aruser \
  s_axi_arlen \
  s_axi_arsize \
  s_axi_araddr \
  s_axi_arready \
  s_axi_arregion \
  s_axi_rvalid \
  s_axi_rid \
  s_axi_ruser \
  s_axi_rresp \
  s_axi_rlast \
  s_axi_rdata \
  s_axi_rready} \
xilinx.com:interface:aximm_rtl:1.0 [ipx::current_core]


ipx::infer_bus_interface {\
  ADDR \  
  CE_N \       
  OEN  \       
  WEN  \
  ADV_LDN \
  CRE    \
  DQ_I \
  DQ_O \
  DQ_T \
  BEN} \
xilinx.com:interface:emc_rtl:1.0 [ipx::current_core]


ipx::infer_bus_interface s_axi_aclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface s_axi_aresetn xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]
ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF \
  -of_objects [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]]

ipx::remove_memory_map {s_axi} [ipx::current_core]
ipx::add_memory_map {s_axi} [ipx::current_core]
set_property slave_memory_map_ref {s_axi} [ipx::get_bus_interfaces s_axi -of_objects [ipx::current_core]]

ipx::add_address_block {axi} [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]

set_property range {16777216} [ipx::get_address_blocks axi -of_objects [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]]
set_property usage {memory} [ipx::get_address_blocks axi -of_objects [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]]
set_property display_name {PSRAM memory} [ipx::get_address_blocks axi -of_objects [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]]
set_property width {32} [ipx::get_address_blocks axi -of_objects [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]]

ipx::save_core [ipx::current_core]
