----------------------------------------------------------------------------------
-- Configurable LFSR (M-sequence generator)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFSR_CFG is
    Generic ( N : integer := 32);
    Port ( RST    : in  STD_LOGIC;
           CLK    : in  STD_LOGIC;
           Enable : in  STD_LOGIC;
           Seed   : in  STD_LOGIC;
           Poly   : in  STD_LOGIC;
           Din    : in  STD_LOGIC_VECTOR ( N-1 downto 0 );
           Q      : out STD_LOGIC_VECTOR ( N-1 downto 0 ) );
end LFSR_CFG;

architecture Behavioral of LFSR_CFG is
signal sreg, sdat, alpha : std_logic_vector( N-1 downto 0 );
signal feedback : std_logic;
begin

	PREG_ALPHA: process( RST, CLK, Enable, Poly, Seed, Din )
	begin
		if ( RST = '1' ) then
			alpha <= ( others => '0' );
		elsif ( rising_edge( CLK ) ) then
			if ( Enable = '0') then
				if ( Poly = '1' and Seed = '0') then
					alpha <= Din;
				end if;
			end if;
		end if;
	end process;
	
	PREG_SREG: process( RST, CLK, Enable, Seed, Poly, Enable, sdat )
	begin
		if ( RST = '1' ) then
			sreg <= ( 0 => '1', others => '0' );
		elsif ( rising_edge( CLK ) ) then
			if ( Enable = '0') then
				if ( Seed = '1' and Poly = '0' ) then
					sreg <= Din;
				end if;
			else
				sreg <= sdat;
			end if;
		end if;	
	end process;
	
	PCOM_FB: process( alpha, sreg )
	variable fb : std_logic;
	begin
		fb := '0';
		for i in N-1 downto 0 loop
			if ( alpha( i ) = '1' ) then
				fb := fb xor sreg( i );
			end if;
		end loop;
		feedback <= fb;
	end process;
	
	sdat <= sreg( N-2 downto 0 ) & feedback;

	Q <= sreg;

end Behavioral;

