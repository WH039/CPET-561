library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;   -- allows + on std_logic_vector

entity high_pass_filter is
    port (
        clk      : in  std_logic;                     -- CLOCK_50
        reset_n  : in  std_logic;                     -- active-low reset
        filter_en: in  std_logic;                     -- one-cycle pulse per audio sample
        data_in  : in  std_logic_vector(15 downto 0); -- Q1.15 audio sample
        data_out : out std_logic_vector(15 downto 0)  -- Q1.15 filtered output
    );
end high_pass_filter;

architecture rtl of high_pass_filter is

    component multiplier is
        port (
            dataa  : in  std_logic_vector(15 downto 0);
            datab  : in  std_logic_vector(15 downto 0);
            result : out std_logic_vector(31 downto 0)
        );
    end component;

    type coeff_array is array (0 to 16) of std_logic_vector(15 downto 0);
    constant HP_COEFF : coeff_array := (
        x"003E",  -- S(0)  =  0.0019
        x"FF9A",  -- S(1)  = -0.0031
        x"FE9E",  -- S(2)  = -0.0108
        x"0000",  -- S(3)  =  0.0
        x"0536",  -- S(4)  =  0.0407
        x"05B2",  -- S(5)  =  0.0445
        x"F5AC",  -- S(6)  = -0.0807
        x"DAB7",  -- S(7)  = -0.2913
        x"4C92",  -- S(8)  =  0.5982
        x"DAB7",  -- S(9)  = -0.2913
        x"F5AC",  -- S(10) = -0.0807
        x"05B2",  -- S(11) =  0.0445
        x"0536",  -- S(12) =  0.0407
        x"0000",  -- S(13) =  0.0
        x"FE9E",  -- S(14) = -0.0108
        x"FF9A",  -- S(15) = -0.0031
        x"003E"   -- S(16) =  0.0019
    );

    type reg_array is array (0 to 16) of std_logic_vector(15 downto 0);
    signal tap : reg_array := (others => (others => '0'));


    type mult_full_array  is array (0 to 16) of std_logic_vector(31 downto 0);
    type mult_trim_array  is array (0 to 16) of std_logic_vector(15 downto 0);
    signal mult_full : mult_full_array;
    signal mult_trim : mult_trim_array;
    signal acc : std_logic_vector(15 downto 0);

begin

    

    delay_regs : process(clk, reset_n)
    begin
        if reset_n = '0' then
            tap(0 to 16) <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if filter_en = '1' then
                tap(0) <= data_in;
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
                datab  => HP_COEFF(n),
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
