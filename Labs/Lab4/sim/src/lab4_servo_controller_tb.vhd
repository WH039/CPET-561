LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY lab4_servo_controller_tb IS
END lab4_servo_controller_tb;


ARCHITECTURE test OF lab4_servo_controller_tb IS

   -- Component Declaration 
   COMPONENT servo_controller is 
  Port (
        clk         : IN  STD_LOGIC;
        reset_n     : IN  STD_LOGIC;
        write       : IN  STD_LOGIC;
        write_data   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        address_bit : IN  STD_LOGIC_VECTOR(1 downto 0);
        pwm_out    : OUT STD_LOGIC;
        irq         : OUT STD_LOGIC  
        );
   END COMPONENT;

   -- define signals for component ports
   SIGNAL clk_tb          : std_logic                     := '0';
   SIGNAL reset_n_tb      : std_logic                     := '0';
   SIGNAL write_tb        : std_logic                     := '0';
   SIGNAL write_addr_tb   : std_logic_vector(1 downto 0)  := "00";
   SIGNAL write_data_tb   : std_logic_vector(31 DOWNTO 0) := x"00000000";
 
   -- Outputs
  SIGNAL gpio_tb         : std_logic;
  SIGNAL irq_tb          : std_logic;     
   
   SIGNAL PERIOD_c : time    := 20 ns;  -- 50MHz

BEGIN  -- test

   -- component instantiation
   UUT : servo_controller
      PORT MAP (
      -- inputs
        clk           => clk_tb,
        reset_n       => reset_n_tb,
        write         => write_tb,
        address_bit   => write_addr_tb,
        write_data     => write_data_tb,
        -- outputs
        pwm_out      => gpio_tb,
        irq           => irq_tb
      );

    clk_process :process
    begin
        while true loop
            clk_tb <= '0';
            wait for PERIOD_C / 2;
            clk_tb <= '1';
            wait for PERIOD_C / 2;
        end loop;
        wait;
    end process;

  stimulus : PROCESS


   BEGIN

    reset_n_tb  <= '0';


    WAIT UNTIL clk_tb = '1';
    WAIT FOR PERIOD_c*2;

    -- de-assert reset
    reset_n_tb <= '1';
    WAIT FOR PERIOD_c*2;
 
    -- WRITE MIN
    WAIT FOR PERIOD_c*2;
    write_data_tb <= x"0000C350"; -- 50,000
    write_addr_tb <= "00"; 
    write_tb      <= '1';
    WAIT FOR PERIOD_c*2;
    write_tb      <= '0';
    wait until irq_tb = '1'; 
    
    -- WRITE MAX
    WAIT FOR PERIOD_c*2;
    write_data_tb <= x"000186A0"; -- 100,000
    write_addr_tb <= "01"; 
    write_tb      <= '1';
    WAIT FOR PERIOD_c*2;
    write_tb      <= '0';
    wait until irq_tb = '1'; 


    -- WRITE MIN
    WAIT FOR PERIOD_c*2;
    write_data_tb <= x"00011170"; --- 70,000
    write_addr_tb <= "00"; 
    write_tb      <= '1';
    WAIT FOR PERIOD_c*2;
    write_tb      <= '0';
    wait until irq_tb = '1'; 
    
    -- WRITE MAX
    WAIT FOR PERIOD_c*2;
    write_data_tb <= x"00015F90"; -- 90,000
    write_addr_tb <= "01"; 
    write_tb      <= '1';
    WAIT FOR PERIOD_c*2;
    write_tb      <= '0';
    wait until irq_tb = '1'; 
	
    -- WAIT FOR PERIOD_c*2;
    -- write_data_tb <= x"00015F90"; -- 90,000
    -- write_addr_tb <= "01"; 
    -- write_tb      <= '1';
    -- WAIT FOR PERIOD_c*2;
    -- write_tb      <= '0';
    -- wait until irq_tb = '1'; 
	
	
    -- WRITE MIN
    WAIT FOR PERIOD_c*2;
    write_data_tb <= x"0000EA60"; --- 70,000
    write_addr_tb <= "00"; 
    write_tb      <= '1';
    WAIT FOR PERIOD_c*2;
    write_tb      <= '0';
    wait until irq_tb = '1'; 
    
    -- WRITE MAX
    WAIT FOR PERIOD_c*2;
    write_data_tb <= x"00013880"; -- 90,000
    write_addr_tb <= "01"; 
    write_tb      <= '1';
    WAIT FOR PERIOD_c*2;
    write_tb      <= '0';
    wait until irq_tb = '1'; 
	
	
      WAIT FOR PERIOD_c*10000;
    wait;

   END PROCESS stimulus;

END test;