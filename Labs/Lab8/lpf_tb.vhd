library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity lpf_tb is
end lpf_tb;

architecture sim of lpf_tb is

    component low_pass_filter is
        port (
            clk      : in  std_logic;
            reset_n  : in  std_logic;
            filter_en: in  std_logic;
            data_in  : in  std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(15 downto 0)
        );
    end component;

    signal clk       : std_logic := '0';
    signal reset_n   : std_logic := '0';
    signal filter_en : std_logic := '0';
    signal data_in   : std_logic_vector(15 downto 0) := (others => '0');
    signal data_out  : std_logic_vector(15 downto 0);

    signal sim_done  : boolean := false;

    constant CLK_PERIOD : time := 20 ns;

    type sample_array is array (0 to 39) of signed(15 downto 0);
    signal audioSampleArray : sample_array := (others => (others => '0'));

begin

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

    dut : low_pass_filter
        port map (
            clk       => clk,
            reset_n   => reset_n,
            filter_en => filter_en,
            data_in   => data_in,
            data_out  => data_out
        );

    stimulus : process is
        file read_file    : text open read_mode  is
            "C:\Users\a9284\Documents\GitHub\CPET-561\CPET-561\Labs\Lab8\one_cycle_200_8k.csv";
        file results_file : text open write_mode is
            "C:\Users\a9284\Documents\GitHub\CPET-561\CPET-561\Labs\Lab8\output_waveform_low.csv";

        variable lineIn    : line;
        variable lineOut   : line;
        variable readValue : integer;
        variable writeValue: integer;

    begin
        reset_n   <= '0';
        filter_en <= '0';
        data_in   <= (others => '0');
        wait for 100 ns;
        reset_n <= '1';

        for i in 0 to 39 loop
            readline(read_file, lineIn);
            read(lineIn, readValue);
            audioSampleArray(i) <= to_signed(readValue, 16);
            wait for 50 ns;   
        end loop;
        file_close(read_file);

        for i in 0 to 39 loop

            data_in <= std_logic_vector(audioSampleArray(i));

            wait until rising_edge(clk);
            filter_en <= '1';
            wait until rising_edge(clk);
            filter_en <= '0';

            wait for CLK_PERIOD * 2;

            writeValue := to_integer(signed(data_out));
            write(lineOut, writeValue);
            writeline(results_file, lineOut);

        end loop;

        file_close(results_file);

        sim_done <= true;
        wait for 100 ns;
        wait;   
    end process stimulus;

end sim;
