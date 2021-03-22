
`timescale 1 ps / 1 ps

module system_top
   (sys_clk,
    sys_rst,
    PSRAM_0_addr,
    PSRAM_0_adv_ldn,
    PSRAM_0_ben,
    PSRAM_0_ce_n,
    PSRAM_0_cre,
    PSRAM_0_dq_io,
    PSRAM_0_oen,
    PSRAM_0_wen,
    
    PhyMdc,
    PhyMdio,
    PhyCrs,
    PhyRxErr,
    PhyRxd,
    PhyTxEn,
    PhyTxd,
    PhyClk50Mhz,
    
    uart_rxd,
    uart_txd,
    
    an,
    seg,
    dp
    );
  input sys_clk;
  input sys_rst;
  
  output [22:0]PSRAM_0_addr;
  output PSRAM_0_adv_ldn;
  output [1:0]PSRAM_0_ben;
  output PSRAM_0_ce_n;
  output PSRAM_0_cre;
  inout [15:0]PSRAM_0_dq_io;
  output PSRAM_0_oen;
  output PSRAM_0_wen;
  input uart_rxd;
  output uart_txd;
  
  output PhyMdc;
  inout PhyMdio;
 
  input PhyCrs;
  input PhyRxErr;
  input [1:0]PhyRxd;
  output PhyTxEn;
  output [1:0]PhyTxd;
  output PhyClk50Mhz;
  
  output [7:0] an;
  output [6:0] seg;
  output dp;
  
  
  wire sys_clk;
  wire sys_rst;
  
  wire [31:0]emc_rtl_0_addr;
  wire emc_rtl_0_adv_ldn;
  wire [1:0]emc_rtl_0_ben;
  wire [0:0]emc_rtl_0_ce;
  wire [0:0]emc_rtl_0_ce_n;
  wire emc_rtl_0_clken;
  wire emc_rtl_0_cre;
  wire [15:0]emc_rtl_0_dq_io;
  wire emc_rtl_0_lbon;
  wire [0:0]emc_rtl_0_oen;
  wire [1:0]emc_rtl_0_qwen;
  wire emc_rtl_0_rnw;
  wire emc_rtl_0_rpn;
  wire [0:0]emc_rtl_0_wait;
  wire emc_rtl_0_wen;
  
  wire uart_rxd;
  wire uart_txd;
  
  wire ref_clk_50Mhz;
  
  BUFG CLK_BUFG (.I(ref_clk_50Mhz), .O(PhyClk50Mhz));
  
  system_wrapper i_system_wrapper (
       .sys_clk(sys_clk),
       .sys_rst(sys_rst),
       .PSRAM_0_addr(PSRAM_0_addr),
       .PSRAM_0_adv_ldn(PSRAM_0_adv_ldn),
       .PSRAM_0_ben(PSRAM_0_ben),
       .PSRAM_0_ce_n(PSRAM_0_ce_n),
       .PSRAM_0_cre(PSRAM_0_cre),
       .PSRAM_0_dq_io(PSRAM_0_dq_io),
       .PSRAM_0_oen(PSRAM_0_oen),
       .PSRAM_0_wen(PSRAM_0_wen),
       .uart_rxd(uart_rxd),
       .uart_txd(uart_txd),
       .anode(an),
       .cathode(seg),
       .dp(dp),
       .MDIO_0_mdc(PhyMdc),
       .MDIO_0_mdio_io(PhyMdio),
       .RMII_PHY_M_0_crs_dv(PhyCrs),
       .RMII_PHY_M_0_rx_er(PhyRxErr),
       .RMII_PHY_M_0_rxd(PhyRxd),
       .RMII_PHY_M_0_tx_en(PhyTxEn),
       .RMII_PHY_M_0_txd(PhyTxd),
       .ref_clk_50Mhz(ref_clk_50Mhz)
   );
  
endmodule
