library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity axi_psram is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		AXI_ID_WIDTH	: integer	:= 1;
		AXI_DATA_WIDTH	: integer	:= 32;
		AXI_ADDR_WIDTH	: integer	:= 24;
		AXI_AWUSER_WIDTH	: integer	:= 0;
		AXI_ARUSER_WIDTH	: integer	:= 0;
		AXI_WUSER_WIDTH	: integer	:= 0;
		AXI_RUSER_WIDTH	: integer	:= 0;
		AXI_BUSER_WIDTH	: integer	:= 0
	);
	port (
		-- Users to add ports here
            -- Pass physical PSRAM signals up and out		
            ADDR  : out std_logic_vector(22 downto 0);  -- To PSRAM address
            CE_N         : out STD_LOGIC;                    -- To PSRAM chip enable
            OEN         : out STD_LOGIC;                    -- To PSRAM output enable
            WEN         : out STD_LOGIC;                    -- To PSRAM write enable
            BEN         : out STD_LOGIC_vector(1 downto 0); -- To PSRAM low byte write enable
            ADV_LDN         : out STD_LOGIC;                    -- To PSRAM address valid line
            CRE         : out STD_LOGIC;                    -- 
            DQ_I      : in STD_LOGIC_VECTOR(15 downto 0); -- To PSRAM data bus
            DQ_O      : out STD_LOGIC_VECTOR(15 downto 0); -- To PSRAM data bus
            DQ_T      : out STD_LOGIC_VECTOR(15 downto 0); -- To PSRAM data bus
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s_axi_aclk	: in std_logic;
		s_axi_aresetn	: in std_logic;
		s_axi_awid	: in std_logic_vector(AXI_ID_WIDTH-1 downto 0);
		s_axi_awaddr	: in std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
		s_axi_awlen	: in std_logic_vector(7 downto 0);
		s_axi_awsize	: in std_logic_vector(2 downto 0);
		s_axi_awburst	: in std_logic_vector(1 downto 0);
		s_axi_awlock	: in std_logic;
		s_axi_awcache	: in std_logic_vector(3 downto 0);
		s_axi_awprot	: in std_logic_vector(2 downto 0);
		s_axi_awqos	: in std_logic_vector(3 downto 0);
		s_axi_awregion	: in std_logic_vector(3 downto 0);
		s_axi_awuser	: in std_logic_vector(AXI_AWUSER_WIDTH-1 downto 0);
		s_axi_awvalid	: in std_logic;
		s_axi_awready	: out std_logic;
		s_axi_wdata	: in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
		s_axi_wstrb	: in std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0);
		s_axi_wlast	: in std_logic;
		s_axi_wuser	: in std_logic_vector(AXI_WUSER_WIDTH-1 downto 0);
		s_axi_wvalid	: in std_logic;
		s_axi_wready	: out std_logic;
		s_axi_bid	: out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
		s_axi_bresp	: out std_logic_vector(1 downto 0);
		s_axi_buser	: out std_logic_vector(AXI_BUSER_WIDTH-1 downto 0);
		s_axi_bvalid	: out std_logic;
		s_axi_bready	: in std_logic;
		s_axi_arid	: in std_logic_vector(AXI_ID_WIDTH-1 downto 0);
		s_axi_araddr	: in std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
		s_axi_arlen	: in std_logic_vector(7 downto 0);
		s_axi_arsize	: in std_logic_vector(2 downto 0);
		s_axi_arburst	: in std_logic_vector(1 downto 0);
		s_axi_arlock	: in std_logic;
		s_axi_arcache	: in std_logic_vector(3 downto 0);
		s_axi_arprot	: in std_logic_vector(2 downto 0);
		s_axi_arqos	: in std_logic_vector(3 downto 0);
		s_axi_arregion	: in std_logic_vector(3 downto 0);
		s_axi_aruser	: in std_logic_vector(AXI_ARUSER_WIDTH-1 downto 0);
		s_axi_arvalid	: in std_logic;
		s_axi_arready	: out std_logic;
		s_axi_rid	: out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
		s_axi_rdata	: out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
		s_axi_rresp	: out std_logic_vector(1 downto 0);
		s_axi_rlast	: out std_logic;
		s_axi_ruser	: out std_logic_vector(AXI_RUSER_WIDTH-1 downto 0);
		s_axi_rvalid	: out std_logic;
		s_axi_rready	: in std_logic
	);
end axi_psram;

architecture arch_imp of axi_psram is

    signal lben : std_logic_vector(1 downto 0);

	-- component declaration
	component psram_ip_v1_1_S00_AXI is
		generic (
		C_S_AXI_ID_WIDTH	: integer	:= 1;
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 23;
		C_S_AXI_AWUSER_WIDTH	: integer	:= 0;
		C_S_AXI_ARUSER_WIDTH	: integer	:= 0;
		C_S_AXI_WUSER_WIDTH	: integer	:= 0;
		C_S_AXI_RUSER_WIDTH	: integer	:= 0;
		C_S_AXI_BUSER_WIDTH	: integer	:= 0
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWID	: in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWLEN	: in std_logic_vector(7 downto 0);
		S_AXI_AWSIZE	: in std_logic_vector(2 downto 0);
		S_AXI_AWBURST	: in std_logic_vector(1 downto 0);
		S_AXI_AWLOCK	: in std_logic;
		S_AXI_AWCACHE	: in std_logic_vector(3 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWQOS	: in std_logic_vector(3 downto 0);
		S_AXI_AWREGION	: in std_logic_vector(3 downto 0);
		S_AXI_AWUSER	: in std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WLAST	: in std_logic;
		S_AXI_WUSER	: in std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BID	: out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BUSER	: out std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARID	: in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARLEN	: in std_logic_vector(7 downto 0);
		S_AXI_ARSIZE	: in std_logic_vector(2 downto 0);
		S_AXI_ARBURST	: in std_logic_vector(1 downto 0);
		S_AXI_ARLOCK	: in std_logic;
		S_AXI_ARCACHE	: in std_logic_vector(3 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARQOS	: in std_logic_vector(3 downto 0);
		S_AXI_ARREGION	: in std_logic_vector(3 downto 0);
		S_AXI_ARUSER	: in std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RID	: out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RLAST	: out std_logic;
		S_AXI_RUSER	: out std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic;		
        MEM_ADDR_OUT  : out std_logic_vector(22 downto 0);  -- To PSRAM address
        MEM_CEN         : out STD_LOGIC;                    -- To PSRAM chip enable
        MEM_OEN         : out STD_LOGIC;                    -- To PSRAM output enable
        MEM_WEN         : out STD_LOGIC;                    -- To PSRAM write enable
        MEM_LBN         : out STD_LOGIC;                    -- To PSRAM low byte write enable
        MEM_UBN         : out STD_LOGIC;                    -- To PSRAM high byte write enable
        MEM_ADV         : out STD_LOGIC;                    -- To PSRAM address valid line
        MEM_CRE         : out STD_LOGIC;                    -- 
        MEM_DATA_I      : in STD_LOGIC_VECTOR(15 downto 0); -- To PSRAM data bus
        MEM_DATA_O      : out STD_LOGIC_VECTOR(15 downto 0);-- To PSRAM data bus
        MEM_DATA_T      : out STD_LOGIC_VECTOR(15 downto 0) -- To PSRAM data bus
		);
	end component psram_ip_v1_1_S00_AXI;

begin

-- Instantiation of Axi Bus Interface S00_AXI
psram_ip_v1_1_S00_AXI_inst : psram_ip_v1_1_S00_AXI
	generic map (
		C_S_AXI_ID_WIDTH	    => AXI_ID_WIDTH,
		C_S_AXI_DATA_WIDTH    	=> AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH      => AXI_ADDR_WIDTH,
		C_S_AXI_AWUSER_WIDTH	=> AXI_AWUSER_WIDTH,
		C_S_AXI_ARUSER_WIDTH	=> AXI_ARUSER_WIDTH,
		C_S_AXI_WUSER_WIDTH   	=> AXI_WUSER_WIDTH,
		C_S_AXI_RUSER_WIDTH	    => AXI_RUSER_WIDTH,
		C_S_AXI_BUSER_WIDTH	    => AXI_BUSER_WIDTH
	)
	port map (
		S_AXI_ACLK	    => s_axi_aclk,
		S_AXI_ARESETN	=> s_axi_aresetn,
		S_AXI_AWID    	=> s_axi_awid,
		S_AXI_AWADDR	=> s_axi_awaddr,
		S_AXI_AWLEN	    => s_axi_awlen,
		S_AXI_AWSIZE	=> s_axi_awsize,
		S_AXI_AWBURST	=> s_axi_awburst,
		S_AXI_AWLOCK	=> s_axi_awlock,
		S_AXI_AWCACHE	=> s_axi_awcache,
		S_AXI_AWPROT	=> s_axi_awprot,
		S_AXI_AWQOS    	=> s_axi_awqos,
		S_AXI_AWREGION	=> s_axi_awregion,
		S_AXI_AWUSER	=> s_axi_awuser,
		S_AXI_AWVALID	=> s_axi_awvalid,
		S_AXI_AWREADY	=> s_axi_awready,
		S_AXI_WDATA	    => s_axi_wdata,
		S_AXI_WSTRB	    => s_axi_wstrb,
		S_AXI_WLAST	    => s_axi_wlast,
		S_AXI_WUSER	    => s_axi_wuser,
		S_AXI_WVALID	=> s_axi_wvalid,
		S_AXI_WREADY	=> s_axi_wready,
		S_AXI_BID	    => s_axi_bid,
		S_AXI_BRESP	    => s_axi_bresp,
		S_AXI_BUSER	    => s_axi_buser,
		S_AXI_BVALID	=> s_axi_bvalid,
		S_AXI_BREADY	=> s_axi_bready,
		S_AXI_ARID	    => s_axi_arid,
		S_AXI_ARADDR	=> s_axi_araddr,
		S_AXI_ARLEN	    => s_axi_arlen,
		S_AXI_ARSIZE	=> s_axi_arsize,
		S_AXI_ARBURST	=> s_axi_arburst,
		S_AXI_ARLOCK	=> s_axi_arlock,
		S_AXI_ARCACHE	=> s_axi_arcache,
		S_AXI_ARPROT	=> s_axi_arprot,
		S_AXI_ARQOS    	=> s_axi_arqos,
		S_AXI_ARREGION	=> s_axi_arregion,
		S_AXI_ARUSER	=> s_axi_aruser,
		S_AXI_ARVALID	=> s_axi_arvalid,
		S_AXI_ARREADY	=> s_axi_arready,
		S_AXI_RID	    => s_axi_rid,
		S_AXI_RDATA	    => s_axi_rdata,
		S_AXI_RRESP   	=> s_axi_rresp,
		S_AXI_RLAST	    => s_axi_rlast,
		S_AXI_RUSER	    => s_axi_ruser,
		S_AXI_RVALID	=> s_axi_rvalid,
		S_AXI_RREADY	=> s_axi_rready,

        MEM_ADDR_OUT  => ADDR,
        MEM_CEN       => CE_N,
        MEM_OEN       => OEN,
        MEM_WEN       => WEN,
        MEM_LBN       => lben(0),
        MEM_UBN       => lben(1),
        MEM_ADV       => ADV_LDN,
        MEM_CRE       => CRE,
        MEM_DATA_I    => DQ_I,
        MEM_DATA_O    => DQ_O,
        MEM_DATA_T    => DQ_T
	);

	-- Add user logic here
BEN <= lben;
	-- User logic ends

end arch_imp;
