library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY lab4_top IS
  Port (
      CLOCK_50 : in std_logic;
      KEY : in std_logic_vector(3 downto 0);  
      LEDR : out  std_logic_vector(9 downto 0);
      GPIO_0 : inout  std_logic_vector(35 downto 0)  
  );
End ENTITY lab4_top;

ARCHITECTURE rtl of lab4_top IS
  
  --Signal Declarations
  Signal Reset_n    : std_logic;
  Signal Key0_D1    : std_logic;
  Signal Key0_D2    : std_logic;
  Signal Key0_D3    : std_logic;
  Signal Write_En   : std_logic := '1'; --Signal set to all continuous sweep of servo
  Signal Address_0  : std_logic_vector(1 downto 0) := "00"; --Signal to access register 0
  Signal Write_Data : std_logic_vector(31 downto 0) := x"0000C350"; --50,000 (Min Angle Value)

  --Component Declaration for Servo Controller
  Component Servo_Controller IS
    Port (
          clk         : IN  STD_LOGIC;
          reset_n     : IN  STD_LOGIC;
          write       : IN  STD_LOGIC;
          write_data   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
          address_bit : IN  STD_LOGIC_VECTOR(1 downto 0);
          pwm_out    : OUT STD_LOGIC;
          irq         : OUT STD_LOGIC  
    );
  End Component Servo_Controller;  
  
BEGIN
  ----- Syncronize the reset
  synchReset_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      Key0_D1 <= KEY(0);
      Key0_D2 <= Key0_D1;
      Key0_D3 <= Key0_D2;
    end if;
    
  end process synchReset_proc;
  Reset_n <= Key0_D3;

  --Port Map of Servo Controller
  lab4_Servo_Controller: Servo_Controller
  Port Map (
            clk         => CLOCK_50, 
            reset_n     => Reset_n,
            write       => Write_en, 
            write_data   => Write_Data, 
            address_bit => Address_0,
            pwm_out    => GPIO_0(10),
            irq         => LEDR(9)
  );
  

End Architecture rtl;