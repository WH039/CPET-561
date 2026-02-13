LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

entity Lab3 is
  port
  (
  
    CLOCK_50 : in std_logic;
	 
	 --input
	 SW       : in std_logic_vector(7 downto 0);
	 KEY      : in std_logic_vector(3 downto 0);
	 
	 --output
	 LEDR     : out std_logic_vector(9 downto 0);
	 HEX0     : out std_logic_vector(6 downto 0)
	);
end entity lab3;

architecture lab3_arch of lab3 is

  signal reset_n : std_logic;
  signal key0_d1 : std_logic;
  signal key0_d2 : std_logic;
  signal key0_d3 : std_logic;
  signal key1_d1 : std_logic;
  signal key1_d2 : std_logic;
  signal key1_d3 : std_logic;
  signal key_sig : std_logic_vector(3 downto 0);

  component nios_system is
    port
	 (
	   clk_clk            : in  std_logic                    := 'X';             -- clk
		reset_reset_n      : in  std_logic                    := 'X';             -- reset_n
		switches_export    : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
		leds_export        : out std_logic_vector(7 downto 0);                    -- export
		hex0_export        : out std_logic_vector(6 downto 0);                    -- export
		pushbuttons_export : in  std_logic_vector(3 downto 0) := (others => 'X')  -- export
	  );
  end component nios_system;
  
  BEGIN
  
  synchReset_proc : process (CLOCK_50)
  begin
    if(RISING_EDGE(CLOCK_50)) THEN
	   key0_d1 <= KEY(0);
		key0_d2 <= key0_d1;
		key0_d3 <= key0_d2;
		
		key1_d1 <= KEY(1);
		key1_d2 <= key1_d1;
		key1_d3 <= key1_d2;
	 end if;
	end process synchReset_proc;
	reset_n <= key0_d3;
	key_sig(1) <= key1_d3;
  
  u0 : component nios_system
    port map (
		clk_clk            => CLOCK_50,            --         clk.clk
		reset_reset_n      => KEY(0),      --       reset.reset_n
		switches_export    => SW,    --    switches.export
		leds_export        => LEDR(7 downto 0),        --        leds.export
		hex0_export        => HEX0,        --        hex0.export
		pushbuttons_export => KEY  -- pushbuttons.export
		);
end architecture lab3_arch;