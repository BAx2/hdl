# create board design
# interface ports

# source ../../scripts/adi_env.tcl ; source ../../scripts/adi_board.tcl ; source ../../scripts/adi_pd.tcl ; set sys_zynq 0

# After delete everything reset counters
# report_property [get_ips clk_wiz] 
if 0 {
    set sys_cpu_interconnect_index 0
set sys_hp0_interconnect_index -1
set sys_hp1_interconnect_index -1
set sys_hp2_interconnect_index -1
set sys_hp3_interconnect_index -1
set sys_mem_interconnect_index -1
set sys_mem_clk_index 0

set xcvr_index -1
set xcvr_tx_index 0
set xcvr_rx_index 0
set xcvr_instance NONE
}

create_bd_port -dir I -type rst sys_rst
create_bd_port -dir I sys_clk
create_bd_port -dir O -type clk ref_clk_50Mhz

create_bd_port -dir O -from 7 -to 0 anode
create_bd_port -dir O -from 6 -to 0 cathode
create_bd_port -dir O dp

create_bd_port -dir O -from 1 -to 0 pwm_red
create_bd_port -dir O -from 1 -to 0 pwm_green
create_bd_port -dir O -from 1 -to 0 pwm_blue

create_bd_port -dir O PHY_RSTN

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 MDIO_0
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 RMII_PHY_M_0
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_leds
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_sw_btns

# Clock wizard

ad_ip_instance clk_wiz sys_cpu_clk_wiz
ad_ip_parameter sys_cpu_clk_wiz CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter sys_cpu_clk_wiz CONFIG.CLKOUT2_USED true
ad_ip_parameter sys_cpu_clk_wiz CONFIG.CLKOUT2_REQUESTED_OUT_FREQ 50.000
ad_ip_parameter sys_cpu_clk_wiz CONFIG.CLKOUT3_USED true
ad_ip_parameter sys_cpu_clk_wiz CONFIG.CLKOUT3_REQUESTED_OUT_FREQ 50.000
ad_ip_parameter sys_cpu_clk_wiz CONFIG.CLKOUT3_REQUESTED_PHASE 45.000



# instance: microblaze - processor

ad_ip_instance microblaze sys_mb
ad_ip_parameter sys_mb CONFIG.G_TEMPLATE_LIST 4
ad_ip_parameter sys_mb CONFIG.C_DCACHE_FORCE_TAG_LUTRAM 1

# instance: microblaze - local memory & bus

ad_ip_instance lmb_v10 sys_dlmb
ad_ip_instance lmb_v10 sys_ilmb

ad_ip_instance lmb_bram_if_cntlr sys_dlmb_cntlr
ad_ip_parameter sys_dlmb_cntlr CONFIG.C_ECC 0

ad_ip_instance lmb_bram_if_cntlr sys_ilmb_cntlr
ad_ip_parameter sys_ilmb_cntlr CONFIG.C_ECC 0

ad_ip_instance blk_mem_gen sys_lmb_bram
ad_ip_parameter sys_lmb_bram CONFIG.Memory_Type True_Dual_Port_RAM
ad_ip_parameter sys_lmb_bram CONFIG.use_bram_block BRAM_Controller

# instance: microblaze- mdm

ad_ip_instance mdm sys_mb_debug
ad_ip_parameter sys_mb_debug CONFIG.C_USE_UART 1

# instance: system reset/clocks

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1


# instance: default peripherals

ad_ip_instance axi_iic axi_iic_main
ad_ip_instance axi_ethernetlite axi_ethernet
ad_ip_instance mii_to_rmii eth_mii_to_rmii
ad_ip_instance axi_uartlite axi_uart
ad_ip_parameter axi_uart CONFIG.C_BAUDRATE 115200

ad_ip_instance axi_timer axi_timer

ad_ip_instance axi_sevenseg axi_sevenseg_0
ad_ip_instance axi_rgbled axi_rgbled_0

ad_ip_instance axi_gpio axi_gpio
ad_ip_parameter axi_gpio CONFIG.C_INTERRUPT_PRESENT 1
ad_ip_parameter axi_gpio CONFIG.C_IS_DUAL 1
ad_ip_parameter axi_gpio CONFIG.C_GPIO_WIDTH 16
ad_ip_parameter axi_gpio CONFIG.C_GPIO2_WIDTH 21
ad_ip_parameter axi_gpio CONFIG.C_ALL_OUTPUTS 1
ad_ip_parameter axi_gpio CONFIG.C_ALL_INPUTS_2 1

# instance: interrupt

ad_ip_instance axi_intc axi_intc
ad_ip_parameter axi_intc CONFIG.C_HAS_FAST 0

ad_ip_instance xlconcat sys_concat_intc
ad_ip_parameter sys_concat_intc CONFIG.NUM_PORTS 16

# connections

ad_connect  sys_rstgen/dcm_locked sys_cpu_clk_wiz/locked
ad_connect  sys_mb_debug/Debug_SYS_Rst sys_rstgen/mb_debug_sys_rst
ad_connect  sys_rstgen/mb_reset sys_mb/Reset
ad_connect  sys_rstgen/bus_struct_reset sys_dlmb/SYS_Rst
ad_connect  sys_rstgen/bus_struct_reset sys_ilmb/SYS_Rst
ad_connect  sys_rstgen/bus_struct_reset sys_dlmb_cntlr/LMB_Rst
ad_connect  sys_rstgen/bus_struct_reset sys_ilmb_cntlr/LMB_Rst


# microblaze local memory

ad_connect  sys_dlmb/LMB_Sl_0   sys_dlmb_cntlr/SLMB
ad_connect  sys_ilmb/LMB_Sl_0   sys_ilmb_cntlr/SLMB
ad_connect  sys_dlmb_cntlr/BRAM_PORT  sys_lmb_bram/BRAM_PORTA
ad_connect  sys_ilmb_cntlr/BRAM_PORT  sys_lmb_bram/BRAM_PORTB
ad_connect  sys_mb/DLMB   sys_dlmb/LMB_M
ad_connect  sys_mb/ILMB   sys_ilmb/LMB_M

# system id

ad_ip_instance axi_sysid axi_sysid_0
ad_ip_instance sysid_rom rom_sys_0

ad_connect  axi_sysid_0/rom_addr   	rom_sys_0/rom_addr
ad_connect  axi_sysid_0/sys_rom_data   	rom_sys_0/rom_data
ad_connect  sys_cpu_clk                 rom_sys_0/clk

ad_ip_instance xlconstant GND_0
set_property CONFIG.CONST_VAL {0} [get_bd_cells GND_0]
set_property CONFIG.CONST_WIDTH {32} [get_bd_cells GND_0]
ad_connect GND_0/dout axi_sysid_0/pr_rom_data

# microblaze debug & interrupt

ad_connect sys_mb_debug/MBDEBUG_0   sys_mb/DEBUG
ad_connect axi_intc/interrupt   sys_mb/INTERRUPT
ad_connect sys_concat_intc/dout   axi_intc/intr

# defaults (peripherals)

ad_connect sys_clk sys_cpu_clk_wiz/clk_in1
ad_connect sys_cpu_reset  sys_rstgen/peripheral_reset
ad_connect sys_cpu_clk    sys_cpu_clk_wiz/clk_out1
ad_connect sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect ref_clk_50Mhz  sys_cpu_clk_wiz/clk_out3

# generic system clocks pointers

set sys_cpu_clk      [get_bd_nets sys_cpu_clk]
set sys_cpu_reset    [get_bd_nets sys_cpu_reset]

ad_connect sys_cpu_clk  sys_rstgen/slowest_sync_clk
ad_connect sys_cpu_clk  sys_mb/Clk
ad_connect sys_cpu_clk  sys_dlmb/LMB_Clk
ad_connect sys_cpu_clk  sys_ilmb/LMB_Clk
ad_connect sys_cpu_clk  sys_dlmb_cntlr/LMB_Clk
ad_connect sys_cpu_clk  sys_ilmb_cntlr/LMB_Clk

# defaults (interrupts)

ad_connect sys_concat_intc/In0    axi_timer/interrupt
ad_connect sys_concat_intc/In1    axi_ethernet/ip2intc_irpt
ad_connect sys_concat_intc/In2    GND
ad_connect sys_concat_intc/In3    GND
ad_connect sys_concat_intc/In4    axi_uart/interrupt
ad_connect sys_concat_intc/In5    GND
ad_connect sys_concat_intc/In6    GND
ad_connect sys_concat_intc/In7    GND
ad_connect sys_concat_intc/In8    GND
ad_connect sys_concat_intc/In9    axi_iic_main/iic2intc_irpt
ad_connect sys_concat_intc/In10   GND
ad_connect sys_concat_intc/In11   axi_gpio/ip2intc_irpt
ad_connect sys_concat_intc/In12   GND
ad_connect sys_concat_intc/In13   GND
ad_connect sys_concat_intc/In14   GND
ad_connect sys_concat_intc/In15   GND

# defaults (external interface)

ad_connect  sys_rst sys_rstgen/ext_reset_in
ad_connect  sys_rst sys_cpu_clk_wiz/resetn
ad_connect  uart axi_uart/uart
ad_connect  axi_ethernet/MDIO MDIO_0
ad_connect  eth_mii_to_rmii/MII axi_ethernet/MII
ad_connect  eth_mii_to_rmii/RMII_PHY_M RMII_PHY_M_0
ad_connect  eth_mii_to_rmii/ref_clk sys_cpu_clk_wiz/clk_out2
#ad_connect  eth_mii_to_rmii/rst_n sys_rstgen/peripheral_aresetn
#ad_connect  eth_mii_to_rmii/rst_n PHY_RSTN
ad_connect  axi_ethernet/phy_rst_n PHY_RSTN
ad_connect  axi_ethernet/phy_rst_n eth_mii_to_rmii/rst_n
ad_connect  anode axi_sevenseg_0/anode 
ad_connect  cathode axi_sevenseg_0/cathode 
ad_connect  dp axi_sevenseg_0/dp 
ad_connect  pwm_red axi_rgbled_0/o_red
ad_connect  pwm_green axi_rgbled_0/o_green
ad_connect  pwm_blue axi_rgbled_0/o_blue
ad_connect  iic_main axi_iic_main/iic
ad_connect  gpio_leds axi_gpio/gpio
ad_connect  gpio_sw_btns axi_gpio/gpio2
# address mapping

ad_cpu_interconnect 0x41400000 sys_mb_debug
ad_cpu_interconnect 0x40E00000 axi_ethernet
ad_cpu_interconnect 0x41200000 axi_intc
ad_cpu_interconnect 0x41C00000 axi_timer
ad_cpu_interconnect 0x40000000 axi_gpio
ad_cpu_interconnect 0x40600000 axi_uart
ad_cpu_interconnect 0x41600000 axi_iic_main
ad_cpu_interconnect 0x45000000 axi_sysid_0
ad_cpu_interconnect 0x46000000 axi_sevenseg_0
ad_cpu_interconnect 0x46400000 axi_rgbled_0

if 0 {


#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file
}