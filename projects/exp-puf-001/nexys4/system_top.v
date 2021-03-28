	
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
    PhyRstn,
    
    uart_rxd,
    uart_txd,
    
    led,
    sw,
    btnC,
    btnU,
    btnL,
    btnR,
    btnD,
    
    RGB1_Red,
    RGB1_Green,
    RGB1_Blue,
    
    RGB2_Red,
    RGB2_Green,
    RGB2_Blue,
    
    tmpSCL,
    tmpSDA,
    tmpInt,
    tmpCT,
    
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
  output PhyRstn;
  
  output [7:0] an;
  output [6:0] seg;
  output dp;
  
  output [15:0] led;
  input [15:0] sw;
  
  input btnC;
  input btnU;
  input btnL;
  input btnR;
  input btnD;
  
  output RGB1_Red;
  output RGB1_Green;
  output RGB1_Blue;
    
  output RGB2_Red;
  output RGB2_Green;
  output RGB2_Blue;
  
  inout tmpSCL;
  inout tmpSDA;
  input tmpInt;
  input tmpCT;
  
  wire sys_clk;
  wire sys_rst;
  
  wire uart_rxd;
  wire uart_txd;
  
  wire ref_clk_50Mhz;
  
  wire [4:0]pbtn;
  
  assign pbtn = {btnC, btnU, btnL, btnR, btnD};
  
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
       .gpio_leds_tri_o(led),
       .gpio_sw_btns_tri_i({sw, pbtn}),
       .pwm_blue({RGB1_Blue,RGB2_Blue}),
       .pwm_green({RGB1_Green,RGB2_Green}),
       .pwm_red({RGB1_Red,RGB2_Red}),
       .iic_main_scl_io(tmpSCL),
       .iic_main_sda_io(tmpSDA),
       .MDIO_0_mdc(PhyMdc),
       .MDIO_0_mdio_io(PhyMdio),
       .RMII_PHY_M_0_crs_dv(PhyCrs),
       .RMII_PHY_M_0_rx_er(PhyRxErr),
       .RMII_PHY_M_0_rxd(PhyRxd),
       .RMII_PHY_M_0_tx_en(PhyTxEn),
       .RMII_PHY_M_0_txd(PhyTxd),
       .PHY_RSTN(PhyRstn),
       .ref_clk_50Mhz(ref_clk_50Mhz)
   );
  
endmodule
