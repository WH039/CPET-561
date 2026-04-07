library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;   -- allows + on std_logic_vector

entity low_pass_filter is
    port (
        clk      : in  std_logic;                     -- CLOCK_50
        reset_n  : in  std_logic;                     -- active-low reset
        filter_en: in  std_logic;                     -- one-cycle pulse per audio sample
        data_in  : in  std_logic_vector(15 downto 0); -- Q1.15 audio sample
        data_out : out std_logic_vector(15 downto 0)  -- Q1.15 filtered output
    );
end low_pass_filter;

architecture rtl of low_pass_filter is

    component multiplier is
        port (
            dataa  : in  std_logic_vector(15 downto 0);
            datab  : in  std_logic_vector(15 downto 0);
            result : out std_logic_vector(31 downto 0)
        );
    end component;

    type coeff_array is array (0 to 16) of std_logic_vector(15 downto 0);
    constant LP_COEFF : coeff_array := (
        x"0052",  -- S(0)  =  0.0025
        x"00BB",  -- S(1)  =  0.0057
        x"01E2",  -- S(2)  =  0.0147
        x"0408",  -- S(3)  =  0.0315
        x"071B",  -- S(4)  =  0.0555
        x"0AAD",  -- S(5)  =  0.0834
        x"0E11",  -- S(6)  =  0.1099
        x"1080",  -- S(7)  =  0.1289
        x"1162",  -- S(8)  =  0.1358
        x"1080",  -- S(9)  =  0.1289
        x"0E11",  -- S(10) =  0.1099
        x"0AAD",  -- S(11) =  0.0834
        x"071B",  -- S(12) =  0.0555
        x"0408",  -- S(13) =  0.0315
        x"01E2",  -- S(14) =  0.0147
        x"00BB",  -- S(15) =  0.0057
        x"0052"   -- S(16) =  0.0025
    );

    type reg_array is array (0 to 16) of std_logic_vector(15 downto 0);
    signal tap : reg_array := (others => (others => '0'));

    type mult_full_array  is array (0 to 16) of std_logic_vector(31 downto 0);
    type mult_trim_array  is array (0 to 16) of std_logic_vector(15 downto 0);
    signal mult_full : mult_full_array;
    signal mult_trim : mult_trim_array;
    signal acc : std_logic_vector(15 downto 0);

begin

    tap(0) <= data_in;

    delay_regs : process(clk, reset_n)
    begin
        if reset_n = '0' then
            tap(1 to 16) <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if filter_en = '1' then
                for k in 1 to 16 loop
                    tap(k) <= tap(k-1);
                end loop;
            end if;
        end if;
    end process delay_regs;

    mult_gen : for n in 0 to 16 generate
        mult_inst : multiplier
            port map (
                dataa  => tap(n),
                datab  => LP_COEFF(n),
                result => mult_full(n)
            );
        mult_trim(n) <= mult_full(n)(30 downto 15);
    end generate mult_gen;

    acc <= mult_trim(0)  + mult_trim(1)  + mult_trim(2)  + mult_trim(3)  +
           mult_trim(4)  + mult_trim(5)  + mult_trim(6)  + mult_trim(7)  +
           mult_trim(8)  + mult_trim(9)  + mult_trim(10) + mult_trim(11) +
           mult_trim(12) + mult_trim(13) + mult_trim(14) + mult_trim(15) +
           mult_trim(16);

    data_out <= acc;

end rtl;
