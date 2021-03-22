# constraints

#set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33}  [get_ports sys_rst]
#set_property PACKAGE_PIN C12 [get_ports sys_rst]				
#set_property IOSTANDARD LVCMOS33 [get_ports sys_rst]

set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { sys_rst }]; 

# clocks

#set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]							
#create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports clk]

##Bank = 35, Pin name = IO_L12P_T1_MRCC_35,					Sch name = CLK100MHZ
set_property PACKAGE_PIN E3 [get_ports sys_clk]							
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports sys_clk]

# ethernet
	
# uart
set_property -dict { PACKAGE_PIN C4   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd }]; 
set_property -dict { PACKAGE_PIN D4   IOSTANDARD LVCMOS33 } [get_ports { uart_txd }]; 



#output [22:0]PSRAM_0_addr;
#  output PSRAM_0_adv_ldn;
#  output [1:0]PSRAM_0_ben;
#  output PSRAM_0_ce_n;
#  output PSRAM_0_cre;
#  inout [15:0]PSRAM_0_dq_io;
#  output PSRAM_0_oen;
#  output PSRAM_0_wen;
  
##Cellular RAM
##Bank = 14, Pin name = IO_L14N_T2_SRCC_14,					Sch name = CRAM_CLK
#set_property PACKAGE_PIN T15 [get_ports RamCLK]					
#set_property IOSTANDARD LVCMOS33 [get_ports RamCLK]
##Bank = 14, Pin name = IO_L23P_T3_A03_D19_14,				Sch name = CRAM_ADVN
set_property PACKAGE_PIN T13 [get_ports PSRAM_0_adv_ldn]					
set_property IOSTANDARD LVCMOS33 [get_ports PSRAM_0_adv_ldn]
##Bank = 14, Pin name = IO_L4P_T0_D04_14,					Sch name = CRAM_CEN
set_property PACKAGE_PIN L18 [get_ports PSRAM_0_ce_n]					
set_property IOSTANDARD LVCMOS33 [get_ports PSRAM_0_ce_n]
##Bank = 15, Pin name = IO_L19P_T3_A22_15,					Sch name = CRAM_CRE
set_property PACKAGE_PIN J14 [get_ports PSRAM_0_cre]					
set_property IOSTANDARD LVCMOS33 [get_ports PSRAM_0_cre]
##Bank = 15, Pin name = IO_L15P_T2_DQS_15,					Sch name = CRAM_OEN
set_property PACKAGE_PIN H14 [get_ports PSRAM_0_oen]					
set_property IOSTANDARD LVCMOS33 [get_ports PSRAM_0_oen]
##Bank = 14, Pin name = IO_0_14,								Sch name = CRAM_WEN
set_property PACKAGE_PIN R11 [get_ports PSRAM_0_wen]					
set_property IOSTANDARD LVCMOS33 [get_ports PSRAM_0_wen]
##Bank = 15, Pin name = IO_L24N_T3_RS0_15,					Sch name = CRAM_LBN
set_property PACKAGE_PIN J15 [get_ports PSRAM_0_ben[0]]					
set_property IOSTANDARD LVCMOS33 [get_ports PSRAM_0_ben[0]]
##Bank = 15, Pin name = IO_L17N_T2_A25_15,					Sch name = CRAM_UBN
set_property PACKAGE_PIN J13 [get_ports PSRAM_0_ben[1]]					
set_property IOSTANDARD LVCMOS33 [get_ports PSRAM_0_ben[1]]
##Bank = 14, Pin name = IO_L14P_T2_SRCC_14,					Sch name = CRAM_WAIT
#set_property PACKAGE_PIN T14 [get_ports RamWait]					
#set_property IOSTANDARD LVCMOS33 [get_ports RamWait]

##Bank = 14, Pin name = IO_L5P_T0_DQ06_14,					Sch name = CRAM_DQ0
set_property PACKAGE_PIN R12 [get_ports {PSRAM_0_dq_io[0]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[0]}]
##Bank = 14, Pin name = IO_L19P_T3_A10_D26_14,				Sch name = CRAM_DQ1
set_property PACKAGE_PIN T11 [get_ports {PSRAM_0_dq_io[1]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[1]}]
##Bank = 14, Pin name = IO_L20P_T3_A08)D24_14,				Sch name = CRAM_DQ2
set_property PACKAGE_PIN U12 [get_ports {PSRAM_0_dq_io[2]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[2]}]
##Bank = 14, Pin name = IO_L5N_T0_D07_14,					Sch name = CRAM_DQ3
set_property PACKAGE_PIN R13 [get_ports {PSRAM_0_dq_io[3]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[3]}]
##Bank = 14, Pin name = IO_L17N_T2_A13_D29_14,				Sch name = CRAM_DQ4
set_property PACKAGE_PIN U18 [get_ports {PSRAM_0_dq_io[4]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[4]}]
##Bank = 14, Pin name = IO_L12N_T1_MRCC_14,					Sch name = CRAM_DQ5
set_property PACKAGE_PIN R17 [get_ports {PSRAM_0_dq_io[5]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[5]}]
##Bank = 14, Pin name = IO_L7N_T1_D10_14,					Sch name = CRAM_DQ6
set_property PACKAGE_PIN T18 [get_ports {PSRAM_0_dq_io[6]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[6]}]
##Bank = 14, Pin name = IO_L7P_T1_D09_14,					Sch name = CRAM_DQ7
set_property PACKAGE_PIN R18 [get_ports {PSRAM_0_dq_io[7]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[7]}]
##Bank = 15, Pin name = IO_L22N_T3_A16_15,					Sch name = CRAM_DQ8
set_property PACKAGE_PIN F18 [get_ports {PSRAM_0_dq_io[8]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[8]}]
##Bank = 15, Pin name = IO_L22P_T3_A17_15,					Sch name = CRAM_DQ9
set_property PACKAGE_PIN G18 [get_ports {PSRAM_0_dq_io[9]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[9]}]
##Bank = 15, Pin name = IO_IO_L18N_T2_A23_15,				Sch name = CRAM_DQ10
set_property PACKAGE_PIN G17 [get_ports {PSRAM_0_dq_io[10]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[10]}]
##Bank = 14, Pin name = IO_L4N_T0_D05_14,					Sch name = CRAM_DQ11
set_property PACKAGE_PIN M18 [get_ports {PSRAM_0_dq_io[11]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[11]}]
##Bank = 14, Pin name = IO_L10N_T1_D15_14,					Sch name = CRAM_DQ12
set_property PACKAGE_PIN M17 [get_ports {PSRAM_0_dq_io[12]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[12]}]
##Bank = 14, Pin name = IO_L9N_T1_DQS_D13_14,				Sch name = CRAM_DQ13
set_property PACKAGE_PIN P18 [get_ports {PSRAM_0_dq_io[13]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[13]}]
##Bank = 14, Pin name = IO_L9P_T1_DQS_14,					Sch name = CRAM_DQ14
set_property PACKAGE_PIN N17 [get_ports {PSRAM_0_dq_io[14]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[14]}]
##Bank = 14, Pin name = IO_L12P_T1_MRCC_14,					Sch name = CRAM_DQ15
set_property PACKAGE_PIN P17 [get_ports {PSRAM_0_dq_io[15]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_dq_io[15]}]

##Bank = 15, Pin name = IO_L23N_T3_FWE_B_15,					Sch name = CRAM_A0
set_property PACKAGE_PIN J18 [get_ports {PSRAM_0_addr[0]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[0]}]
##Bank = 15, Pin name = IO_L18P_T2_A24_15,					Sch name = CRAM_A1
set_property PACKAGE_PIN H17 [get_ports {PSRAM_0_addr[1]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[1]}]
##Bank = 15, Pin name = IO_L19N_T3_A21_VREF_15,				Sch name = CRAM_A2
set_property PACKAGE_PIN H15 [get_ports {PSRAM_0_addr[2]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[2]}]
##Bank = 15, Pin name = IO_L23P_T3_FOE_B_15,					Sch name = CRAM_A3
set_property PACKAGE_PIN J17 [get_ports {PSRAM_0_addr[3]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[3]}]
##Bank = 15, Pin name = IO_L13P_T2_MRCC_15,					Sch name = CRAM_A4
set_property PACKAGE_PIN H16 [get_ports {PSRAM_0_addr[4]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[4]}]
##Bank = 15, Pin name = IO_L24P_T3_RS1_15,					Sch name = CRAM_A5
set_property PACKAGE_PIN K15 [get_ports {PSRAM_0_addr[5]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[5]}]
##Bank = 15, Pin name = IO_L17P_T2_A26_15,					Sch name = CRAM_A6
set_property PACKAGE_PIN K13 [get_ports {PSRAM_0_addr[6]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[6]}]
##Bank = 14, Pin name = IO_L11P_T1_SRCC_14,					Sch name = CRAM_A7
set_property PACKAGE_PIN N15 [get_ports {PSRAM_0_addr[7]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[7]}]
##Bank = 14, Pin name = IO_L16N_T2_SRCC-14,					Sch name = CRAM_A8
set_property PACKAGE_PIN V16 [get_ports {PSRAM_0_addr[8]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[8]}]
##Bank = 14, Pin name = IO_L22P_T3_A05_D21_14,				Sch name = CRAM_A9
set_property PACKAGE_PIN U14 [get_ports {PSRAM_0_addr[9]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[9]}]
##Bank = 14, Pin name = IO_L22N_T3_A04_D20_14,				Sch name = CRAM_A10
set_property PACKAGE_PIN V14 [get_ports {PSRAM_0_addr[10]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[10]}]
##Bank = 14, Pin name = IO_L20N_T3_A07_D23_14,				Sch name = CRAM_A11
set_property PACKAGE_PIN V12 [get_ports {PSRAM_0_addr[11]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[11]}]
##Bank = 14, Pin name = IO_L8N_T1_D12_14,					Sch name = CRAM_A12
set_property PACKAGE_PIN P14 [get_ports {PSRAM_0_addr[12]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[12]}]
##Bank = 14, Pin name = IO_L18P_T2_A12_D28_14,				Sch name = CRAM_A13
set_property PACKAGE_PIN U16 [get_ports {PSRAM_0_addr[13]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[13]}]
##Bank = 14, Pin name = IO_L13N_T2_MRCC_14,					Sch name = CRAM_A14
set_property PACKAGE_PIN R15 [get_ports {PSRAM_0_addr[14]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[14]}]
##Bank = 14, Pin name = IO_L8P_T1_D11_14,					Sch name = CRAM_A15
set_property PACKAGE_PIN N14 [get_ports {PSRAM_0_addr[15]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[15]}]
##Bank = 14, Pin name = IO_L11N_T1_SRCC_14,					Sch name = CRAM_A16
set_property PACKAGE_PIN N16 [get_ports {PSRAM_0_addr[16]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[16]}]
##Bank = 14, Pin name = IO_L6N_T0_D08_VREF_14,				Sch name = CRAM_A17
set_property PACKAGE_PIN M13 [get_ports {PSRAM_0_addr[17]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[17]}]
##Bank = 14, Pin name = IO_L18N_T2_A11_D27_14,				Sch name = CRAM_A18
set_property PACKAGE_PIN V17 [get_ports {PSRAM_0_addr[18]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[18]}]
##Bank = 14, Pin name = IO_L17P_T2_A14_D30_14,				Sch name = CRAM_A19
set_property PACKAGE_PIN U17 [get_ports {PSRAM_0_addr[19]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[19]}]
##Bank = 14, Pin name = IO_L24N_T3_A00_D16_14,				Sch name = CRAM_A20
set_property PACKAGE_PIN T10 [get_ports {PSRAM_0_addr[20]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[20]}]
##Bank = 14, Pin name = IO_L10P_T1_D14_14,					Sch name = CRAM_A21
set_property PACKAGE_PIN M16 [get_ports {PSRAM_0_addr[21]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[21]}]	
##Bank = 14, Pin name = IO_L23N_T3_A02_D18_14,				Sch name = CRAM_A22
set_property PACKAGE_PIN U13 [get_ports {PSRAM_0_addr[22]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PSRAM_0_addr[22]}]



##SMSC Ethernet PHY
##Bank = 16, Pin name = IO_L11P_T1_SRCC_16,					Sch name = ETH_MDC
set_property PACKAGE_PIN C9 [get_ports PhyMdc]						
set_property IOSTANDARD LVCMOS33 [get_ports PhyMdc]
##Bank = 16, Pin name = IO_L14N_T2_SRCC_16,					Sch name = ETH_MDIO
set_property PACKAGE_PIN A9 [get_ports PhyMdio]					
set_property IOSTANDARD LVCMOS33 [get_ports PhyMdio]
##Bank = 35, Pin name = IO_L10P_T1_AD15P_35,					Sch name = ETH_RSTN
#set_property PACKAGE_PIN B3 [get_ports PhyRstn]					
#set_property IOSTANDARD LVCMOS33 [get_ports PhyRstn]
##Bank = 16, Pin name = IO_L6N_T0_VREF_16,					Sch name = ETH_CRSDV
set_property PACKAGE_PIN D9 [get_ports PhyCrs]						
set_property IOSTANDARD LVCMOS33 [get_ports PhyCrs]
##Bank = 16, Pin name = IO_L13N_T2_MRCC_16,					Sch name = ETH_RXERR
set_property PACKAGE_PIN C10 [get_ports PhyRxErr]					
set_property IOSTANDARD LVCMOS33 [get_ports PhyRxErr]
##Bank = 16, Pin name = IO_L19N_T3_VREF_16,					Sch name = ETH_RXD0
set_property PACKAGE_PIN D10 [get_ports {PhyRxd[0]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PhyRxd[0]}]
##Bank = 16, Pin name = IO_L13P_T2_MRCC_16,					Sch name = ETH_RXD1
set_property PACKAGE_PIN C11 [get_ports {PhyRxd[1]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PhyRxd[1]}]
##Bank = 16, Pin name = IO_L11N_T1_SRCC_16,					Sch name = ETH_TXEN
set_property PACKAGE_PIN B9 [get_ports PhyTxEn]					
set_property IOSTANDARD LVCMOS33 [get_ports PhyTxEn]
##Bank = 16, Pin name = IO_L14P_T2_SRCC_16,					Sch name = ETH_TXD0
set_property PACKAGE_PIN A10 [get_ports {PhyTxd[0]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PhyTxd[0]}]
##Bank = 16, Pin name = IO_L12N_T1_MRCC_16,					Sch name = ETH_TXD1
set_property PACKAGE_PIN A8 [get_ports {PhyTxd[1]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {PhyTxd[1]}]
##Bank = 35, Pin name = IO_L11P_T1_SRCC_35,					Sch name = ETH_REFCLK
set_property PACKAGE_PIN D5 [get_ports PhyClk50Mhz]				
set_property IOSTANDARD LVCMOS33 [get_ports PhyClk50Mhz]
##Bank = 16, Pin name = IO_L12P_T1_MRCC_16,					Sch name = ETH_INTN
#set_property PACKAGE_PIN B8 [get_ports PhyIntn]					
#set_property IOSTANDARD LVCMOS33 [get_ports PhyIntn]



##7 segment display
##Bank = 34, Pin name = IO_L2N_T0_34,						Sch name = CA
set_property PACKAGE_PIN L3 [get_ports {seg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
##Bank = 34, Pin name = IO_L3N_T0_DQS_34,					Sch name = CB
set_property PACKAGE_PIN N1 [get_ports {seg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
##Bank = 34, Pin name = IO_L6N_T0_VREF_34,					Sch name = CC
set_property PACKAGE_PIN L5 [get_ports {seg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
##Bank = 34, Pin name = IO_L5N_T0_34,						Sch name = CD
set_property PACKAGE_PIN L4 [get_ports {seg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
##Bank = 34, Pin name = IO_L2P_T0_34,						Sch name = CE
set_property PACKAGE_PIN K3 [get_ports {seg[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
##Bank = 34, Pin name = IO_L4N_T0_34,						Sch name = CF
set_property PACKAGE_PIN M2 [get_ports {seg[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
##Bank = 34, Pin name = IO_L6P_T0_34,						Sch name = CG
set_property PACKAGE_PIN L6 [get_ports {seg[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

##Bank = 34, Pin name = IO_L16P_T2_34,						Sch name = DP
set_property PACKAGE_PIN M4 [get_ports dp]							
	set_property IOSTANDARD LVCMOS33 [get_ports dp]

##Bank = 34, Pin name = IO_L18N_T2_34,						Sch name = AN0
set_property PACKAGE_PIN N6 [get_ports {an[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
##Bank = 34, Pin name = IO_L18P_T2_34,						Sch name = AN1
set_property PACKAGE_PIN M6 [get_ports {an[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
##Bank = 34, Pin name = IO_L4P_T0_34,						Sch name = AN2
set_property PACKAGE_PIN M3 [get_ports {an[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
##Bank = 34, Pin name = IO_L13_T2_MRCC_34,					Sch name = AN3
set_property PACKAGE_PIN N5 [get_ports {an[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
##Bank = 34, Pin name = IO_L3P_T0_DQS_34,					Sch name = AN4
set_property PACKAGE_PIN N2 [get_ports {an[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[4]}]
##Bank = 34, Pin name = IO_L16N_T2_34,						Sch name = AN5
set_property PACKAGE_PIN N4 [get_ports {an[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[5]}]
##Bank = 34, Pin name = IO_L1P_T0_34,						Sch name = AN6
set_property PACKAGE_PIN L1 [get_ports {an[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[6]}]
##Bank = 34, Pin name = IO_L1N_T034,							Sch name = AN7
set_property PACKAGE_PIN M1 [get_ports {an[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[7]}]