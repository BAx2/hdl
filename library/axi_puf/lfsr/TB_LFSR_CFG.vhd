--------------------------------------------------------------------------------
-- TestBench
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

use STD.textio.all;
use ieee.std_logic_textio.all;

 
ENTITY TB_LFSR_CFG IS
	Generic( N : integer := 32 );
END TB_LFSR_CFG;
 
ARCHITECTURE behavior OF TB_LFSR_CFG IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LFSR_CFG
    PORT(
         RST    : IN  std_logic;
         CLK    : IN  std_logic;
         Enable : IN  std_logic;
         Seed   : IN  std_logic;
         Poly   : IN  std_logic;
         Din    : IN  std_logic_vector( N-1 downto 0 );
         Q      : OUT std_logic_vector( N-1 downto 0 )
        );
    END COMPONENT;
    

   --Inputs
   signal RST    : std_logic := '0';
   signal CLK    : std_logic := '0';
   signal Enable : std_logic := '0';
   signal Seed   : std_logic := '0';
   signal Poly   : std_logic := '0';
   signal Din    : std_logic_vector( N-1 downto 0 ) := ( others => '0' );

 	--Outputs
   signal Q : std_logic_vector( N-1 downto 0 );

   -- Clock period definitions
   constant CLK_period : time := 10 ns;

	-- Log-file
	file file_lfsr_log : text;
	constant file_name : string := "lfsr_" & integer'image( N ) & ".txt";

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: LFSR_CFG PORT MAP (
          RST    => RST,
          CLK    => CLK,
          Enable => Enable,
          Seed   => Seed,
          Poly   => Poly,
          Din    => Din,
          Q      => Q
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	
	variable v_line : line;
   
	begin		
		file_open(file_lfsr_log, file_name, write_mode);
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RST <= '1';
		wait for 100 ns;	
		RST <= '0';
		
		
		-- N = 4
		-- Phi(x) = x^4 + x^1 + 1
		-- Din <= "1001";
		
		-- N = 8
		-- Phi(x) = x^8 + x^6 + x^5 + x^1 + 1
		-- Din <= "10110001";
		
		-- N = 10
		-- Phi(x) = x^10 + x^3 + 1
		-- Din <= "1000000100";
		
		-- N = 16
		-- Phi(x) = x^16 + x^5 + x^3 + x^2 + 1
		-- Din <= "1000000000010110";
		
		-- N = 20
		-- Phi(x) = x^20 + x^3 + 1
		-- Din <= "10000000000000000100";
		
		-- N = 24
		-- Phi(x) = x^24 + x^4 + x^3 + x^1 + 1
		-- Din <= "100000000000000000001101";

		-- N = 32
		-- Phi(x) = x^32 + x^28 + x^27 + x^1 + 1
		Din <= "10001100000000000000000000000001";

		
		wait for CLK_period*2;
		Poly <= '1';
		wait for CLK_period*2;
		Poly <= '0';
		
		wait for CLK_period*2;
		Enable <= '1';
		
		--for i in 0 to 2**N-1 loop
      for i in 0 to 2**20-1 loop
			write(v_line, Q);
			writeline(file_lfsr_log, v_line);
			wait for CLK_period;
		end loop;
		
		Enable <= '1';

		file_close(file_lfsr_log);
      -- insert stimulus here 
		report "Simulation ends" severity failure;
   end process;

END;
