library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY lab2 is
  port (
    CLOCK_50   : in   std_logic;
    HEX0       : out  std_logic_vector(6 downto 0);
    KEY    	: in   std_logic_vector(3 downto 0);
    SW      	: in   std_logic_vector(7 downto 0) 
	 );
end entity lab2;

architecture lab2_arch of lab2 is

  signal reset_n : std_logic;
  signal key0_d1 : std_logic;
  signal key0_d2 : std_logic;
  signal key0_d3 : std_logic;
  signal key1_d1 : std_logic_vector(3 downto 0);
  signal key1_d2 : std_logic_vector(3 downto 0);
  signal key1_d3 : std_logic_vector(3 downto 0);
  signal sw_d1   : std_logic_vector(7 downto 0);
  signal sw_d2   : std_logic_vector(7 downto 0);
	 
	component nios_system is
		port (
			clk_clk           : in  std_logic                    := 'X';             -- clk
			hex0_export       : out std_logic_vector(6 downto 0);                    -- export
			pushbuttons_export : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			reset_reset_n     : in  std_logic                    := 'X';             -- reset_n
			switches_export   : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component nios_system;

begin
  synchResetkey0_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      key0_d1 <= KEY(0);
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
    end if;
  end process synchResetkey0_proc;
  reset_n <= key0_d3;
  
  synchResetkey1_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      key1_d1 <= KEY;
      key1_d2 <= key1_d1;
      key1_d3 <= key1_d2;
    end if;
  end process synchResetkey1_proc;
  
  synchUserIn_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
	   if (reset_n = '0') then
		  sw_d1 <= "00000000";
		  sw_d2 <= "00000000";
		else
		  sw_d1 <= SW;
        sw_d2 <= sw_d1;
      end if;
    end if;
  end process synchUserIn_proc;

	u0 : component nios_system
		port map (
			clk_clk           => CLOCK_50,           --        clk.clk
			hex0_export       => HEX0,       --       hex0.export
			pushbuttons_export => KEY, -- pushbutton.export
			reset_reset_n     => reset_n,     --      reset.reset_n
			switches_export   => SW    --   switches.export
		);
end architecture lab2_arch;
