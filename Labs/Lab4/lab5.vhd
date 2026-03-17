library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY lab5 IS
  Port (
      CLOCK_50 : in std_logic;
      KEY              : in std_logic_vector(3 downto 0);
		SW               : in std_logic_vector(7 downto 0);
		HEX0             : out std_logic_vector( 6 downto 0);
		HEX1             : out std_logic_vector( 6 downto 0);
		HEX2             : out std_logic_vector( 6 downto 0);
		HEX4             : out std_logic_vector( 6 downto 0);
		HEX5             : out std_logic_vector( 6 downto 0);
      LEDR             : out  std_logic_vector(9 downto 0);
      GPIO_0           : out  std_logic_vector(35 downto 0)  
  );
End ENTITY lab5;

ARCHITECTURE rtl of lab5 IS

  component nios_system is
  port (
			clk_clk                  : in  std_logic                    := 'X';             -- clk
			hex0_export              : out std_logic_vector(6 downto 0);                    -- export
			hex1_export              : out std_logic_vector(6 downto 0);                    -- export
			hex2_export              : out std_logic_vector(6 downto 0);                    -- export
			hex4_export              : out std_logic_vector(6 downto 0);                    -- export
			hex5_export              : out std_logic_vector(6 downto 0);                    -- export
			pushbuttons_export       : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			reset_reset_n            : in  std_logic                    := 'X';             -- reset_n
			switches_export          : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			servo_pwm_writeresponsevalid_n : out std_logic                                        -- writeresponsevalid_n
	);
	end component nios_system;

  
  --Signal Declarations
  Signal Reset_n    : std_logic;
  Signal Key_D1, Key_D2, Key_D3    : std_logic_vector(3 downto 0); 
  
  BEGIN
  ----- Syncronize the reset
  synchReset_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      Key_D1 <= KEY;
      Key_D2 <= Key_D1;
      Key_D3 <= Key_D2;
    end if;
    
  end process synchReset_proc;

  --Port Map of nios_system
  
  u0 : component nios_system
		port map (
			clk_clk                  => CLOCK_50,                  --         clk.clk
			hex0_export              => HEX0,              --        hex0.export
			hex1_export              => HEX1,              --        hex1.export
			hex2_export              => HEX2,              --        hex2.export
			hex4_export              => HEX4,              --        hex4.export
			hex5_export              => HEX5,              --        hex5.export
			pushbuttons_export       => Key_D3,       -- pushbuttons.export
			reset_reset_n            => Key_D3(0),            --       reset.reset_n
			switches_export          => SW,          --    switches.export
			servo_pwm_writeresponsevalid_n => GPIO_0(10)  --         pwm.writeresponsevalid_n
		);


End Architecture rtl;