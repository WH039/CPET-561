LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity servo_controller is 
    port(
        clk      : in std_logic;
        reset_n       : in std_logic;
        address_bit   : in std_logic_vector(1 downto 0);
        write         : in std_logic;
        write_data    : in std_logic_vector(31 downto 0);
        irq           : out std_logic;
        pwm_out       : out std_logic
    );
end servo_controller;

architecture servo_controller_arch of servo_controller is

    --constants
    constant PERIOD      : unsigned(31 downto 0) := x"000F4240"; --- 1,000,000 - 20 ms
    constant MIN_ANGLE   : unsigned(31 downto 0) := x"0000C350"; --- 50,000 - 1 ms
    constant MAX_ANGLE   : unsigned(31 downto 0) := x"000186A0"; --- 100,00 - 2 ms

    --states
    type states is(
        SWEEP_RIGHT,
        INT_RIGHT,
        SWEEP_LEFT,
        INT_LEFT
    );
    signal current_state, next_state : states;

    --counter
    signal period_ctr      : unsigned(31 downto 0) := (others => '0');
    signal bot_angle_ctr   : unsigned(31 downto 0) := MIN_ANGLE;
    signal top_angle_ctr   : unsigned(31 downto 0) := MAX_ANGLE;

    --angle limits
    signal current_bot_limit   : unsigned(31 downto 0) := MIN_ANGLE;
    signal current_top_limit   : unsigned(31 downto 0) := MAX_ANGLE;

begin
    --state register
    state_register: process(clk, reset_n)
    begin
        if(RISING_EDGE(clk)) then
            current_state <= SWEEP_RIGHT;
        elsif reset_n = '0' then
            current_state <= next_state;
        end if;
    end process;

    --state machine
    state_machine : process(current_state, current_bot_limit, current_top_limit, write, address_bit, top_angle_ctr, bot_angle_ctr)
    begin
        next_state <= current_state;
        irq <= '0';
        
        if(current_state = SWEEP_LEFT) then
            if (bot_angle_ctr >= current_bot_limit) then 
                irq <= '1';
                next_state <= INT_LEFT;
            end if;
        elsif(current_state = INT_LEFT) then
            irq <= '1';
            if write = '1' then 
                irq <= '0';
                next_state <= SWEEP_RIGHT;
            end if;
        elsif(current_state = SWEEP_RIGHT) then
            if (top_angle_ctr >= current_top_limit) then 
                irq <= '1';
                next_state <= INT_RIGHT;
            end if;
        elsif(current_state = INT_RIGHT) then
            irq <= '1';
            if write = '1' then 
                irq <= '0';
                next_state <= SWEEP_LEFT;
            end if;
        end if;
    end process;

    --counter
    counter_check : process(clk, reset_n)
    begin
        if reset_n = '0' then
            period_ctr <= (others => '0');
        elsif RISING_EDGE(clk) then
            if period_ctr = PERIOD then
                period_ctr <= (others => '0');
            else
                period_ctr <= period_ctr + 1;
            end if;
        end if;
    end process;

    --angle counter
    process(clk, reset_n)
    begin
        if reset_n = '0' then 
            top_angle_ctr <= MIN_ANGLE;
            bot_angle_ctr <= MAX_ANGLE;
        elsif RISING_EDGE(clk) then
            if current_state = SWEEP_LEFT then
                if period_ctr <= top_angle_ctr then 
                    pwm_out <= '1';
                else 
                    pwm_out <= '0';
                end if;
            elsif current_state = INT_LEFT then
                top_angle_ctr <= bot_angle_ctr;
            elsif current_state = SWEEP_RIGHT then
                if period_ctr <= bot_angle_ctr then 
                    pwm_out <= '1';
                else 
                    pwm_out <= '0';
                end if;
            elsif current_state = INT_RIGHT then
                bot_angle_ctr <= top_angle_ctr;
            end if;
        
            if period_ctr = PERIOD then 
                if top_angle_ctr < current_top_limit then
                    top_angle_ctr <= top_angle_ctr + x"000001f4";
                elsif bot_angle_ctr < current_bot_limit then
                    bot_angle_ctr <= bot_angle_ctr + x"000001f4";
                end if;
            end if;
        end if;
    end process;

    process(clk, reset_n)
    begin 
        if reset_n = '0' then
            current_bot_limit <= MIN_ANGLE;
            current_top_limit <= MAX_ANGLE;
        elsif RISING_EDGE(clk) then
            if write = '1' then 
                if address_bit = "00" then 
                    current_bot_limit <= unsigned(write_data);
                elsif address_bit = "01" then 
                    current_top_limit <= unsigned(write_data);
                end if;
            end if;
        end if;
    end process;
        
end architecture;