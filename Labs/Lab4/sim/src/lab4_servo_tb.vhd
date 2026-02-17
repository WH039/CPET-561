library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab4_servo_tb is
end lab4_servo_tb;

architecture Behavioral of lab4_servo_tb is
    -- Component Declaration for the Unit Under Test (UUT)
   --- component servo_controller
   COMPONENT servo_controller is         port(
            clk         : in  std_logic;
            reset_n     : in  std_logic;
            addr        : in  std_logic;
            write_en    : in  std_logic;
            write_data  : in  std_logic_vector(31 downto 0);
            irq         : out std_logic;
            pwm_out     : out std_logic
        );
    end component;

    -- Signals to connect to UUT
    signal clk         : std_logic := '0';
    signal reset_n     : std_logic := '0';
    signal addr        : std_logic := '0';
    signal write_en    : std_logic := '0';
    signal write_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal irq         : std_logic;
    signal pwm_out     : std_logic;

    constant CLK_PERIOD : time := 20 ns;
    constant MIN_ANGLE_SIM : integer := 5000;
    constant MAX_ANGLE_SIM : integer := 10000;
    constant INCREMENT_SIM : integer := 1000;
    constant PWM_CYCLE_TIME : time := 40000 ns;  -- Adjusted time for one full PWM cycle

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: servo_controller port map (
        clk => clk,
        reset_n => reset_n,
        addr => addr,
        write_en => write_en,
        write_data => write_data,
        irq => irq,
        pwm_out => pwm_out
    );

    -- Clock generation
    clk_process :process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Reset the system
        reset_n <= '1';
        wait for 10 ns;
        reset_n <= '0';
 
		addr <= '1';
        write_data <= std_logic_vector(to_unsigned(MAX_ANGLE_SIM, 32));
        wait for 10 ns;
		write_en <= '1';
		wait for 20 ns;
        write_en <= '0';
		
        addr <= '0';
        write_data <= std_logic_vector(to_unsigned(MIN_ANGLE_SIM, 32));
        -- Write initial values to min and max angle registers
        wait for 10 ns;
		write_en <= '1';
		wait for 20 ns;
        write_en <= '0';
        
       -- INT RIGHT 
        wait for 100000 ns; --- let pwm cycle
		addr <= '0';
        write_data <= std_logic_vector(to_unsigned(MIN_ANGLE_SIM, 32));
        write_en <= '1';  --- go into sweep left
		wait for 20 ns;
        write_en <= '0';
        -- wait for 999900 ns;
        -- write_en <= '1';
        -- wait for 100 ns;
        -- write_en <= '0';

       -- Allow PWM to complete one cycle before setting write_en
        --wait for 1000000 ns;
        
        -- Finish simulation
        wait;
    end process;

end Behavioral;