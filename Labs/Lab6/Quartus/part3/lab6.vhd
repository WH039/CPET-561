LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

entity lab6 is
	port(
		CLOCK_50 : in  std_logic;
		KEY      : in  std_logic_vector(3 downto 0);
		LEDR     : out std_logic_vector(9 downto 0)
	);
end entity lab6;

architecture rtl of lab6 is

	component nios_system is
		port (
			clk_clk           : in  std_logic                    := 'X'; -- clk
			leds_export       : out std_logic_vector(7 downto 0);        -- export
			pushbutton_export : in  std_logic_vector(3 downto 0);        -- export
			reset_reset_n     : in  std_logic                    := 'X'  -- reset_n
		);
	end component nios_system;
	
	signal reset_n                   : std_logic;
   signal key_d1, key_d2, key_d3 : std_logic;
	
	begin
	
	synchResetkey0_proc : process (CLOCK_50) begin
      if (rising_edge(CLOCK_50)) then
			key_d1 <= KEY(0);
			key_d2 <= key_d1;
			key_d3 <= key_d2;
		end if;
	end process synchResetkey0_proc;
	reset_n <= key_d3;

	u0 : component nios_system
		port map (
			clk_clk           => CLOCK_50,   --       clk.clk
			leds_export       => LEDR(7 downto 0),       --       leds.export
			pushbutton_export => KEY,     --       pushbutton.export
			reset_reset_n     => reset_n     --       reset.reset_n
		);
		
end architecture rtl;