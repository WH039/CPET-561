LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity raminfr_be_tb is 
end entity;

architecture beh of raminfr_be_tb is
    
    component raminfr_be is
        port(
            clk                 : in std_logic;
            reset_n             : in std_logic;
            writebyteenable_n   : in std_logic_vector(3 downto 0);
            address             : in std_logic_vector(11 downto 0);
            writedata           : in std_logic_vector(31 downto 0);
            readdata            : out std_logic_vector(31 downto 0)
        );
    end component raminfr_be;

    signal period                 : time := 20 ns;
    signal clk_tb                 : std_logic := '0';
    signal reset_n_tb             : std_logic := '0';

    signal address_tb             : std_logic_vector(11 downto 0)  := "000000000000";
    signal writebyteenable_n_tb   : std_logic_vector(3 downto 0)   := "0000";
    signal writedata_tb           : std_logic_vector(31 downto 0);
    signal readdata_tb            : std_logic_vector(31 downto 0);

    signal checkdata              : std_logic_vector(31 downto 0);

begin
    
    uut : raminfr_be
    port map(
        clk               => clk_tb,
        reset_n           => reset_n_tb,
        writebyteenable_n => writebyteenable_n_tb,
        writedata         => writedata_tb,
        address           => address_tb,
        readdata          => readdata_tb
    );

    clk_tb <= not clk_tb after period / 2;

    testing : process
    begin
        report "testbench start";
        writedata_tb <= x"12345678";
        checkdata    <= x"12345678";
        reset_n_tb <= '1';
        wait for 10 ns;

        for i in 0 to 6 loop
            case(i) is
            --case 1, full word
            when 0 =>
                for j in 0 to 4095 loop
                    writebyteenable_n_tb <= "0000";
                    writedata_tb         <= x"12345678";
                    checkdata            <= x"12345678";
                    wait for 40 ns;

                    assert checkdata = readdata_tb report "data is wrong" severity error;
                    address_tb <= address_tb + x"001";
                end loop;
                address_tb <= x"000";
            --case 2, half word, top half
            when 1 =>
                for j in 0 to 4095 loop
                    writebyteenable_n_tb <= "0011";
                    writedata_tb         <= x"BBBBBBBB";
                    checkdata            <= x"BBBB5678";
                    wait for 40 ns;

                    assert checkdata = readdata_tb report "data is wrong" severity error;
                    address_tb <= address_tb + x"001";
                end loop;
                address_tb <= x"000";
            --case 3, half word, bottom half
            when 2 =>
                for j in 0 to 4095 loop
                    writebyteenable_n_tb <= "1100";
                    writedata_tb         <= x"CCCCCCCC";
                    checkdata            <= x"1234CCCC";
                    wait for 40 ns;

                    assert checkdata = readdata_tb report "data is wrong" severity error;
                    address_tb <= address_tb + x"001";
                end loop;
                address_tb <= x"000";
            --case 4, byte, bit 2
            when 3 =>
                for j in 0 to 4095 loop
                    writebyteenable_n_tb <= "1101";
                    writedata_tb         <= x"DDDDDDDD";
                    checkdata            <= x"111122DD";
                    wait for 40 ns;

                    assert checkdata = readdata_tb report "data is wrong" severity error;
                    address_tb <= address_tb + x"001";
                end loop;
                address_tb <= x"000";
            --case 5, byte, bit 1
            when 4 =>
                for j in 0 to 4095 loop
                    writebyteenable_n_tb <= "1110";
                    writedata_tb         <= x"EEEEEEEE";
                    checkdata            <= x"1111EE22";
                    wait for 40 ns;

                    assert checkdata = readdata_tb report "data is wrong" severity error;
                    address_tb <= address_tb + x"001";
                end loop;
                address_tb <= x"000";
            --case 6, byte, bit 3
            when 5 =>
                for j in 0 to 4095 loop
                    writebyteenable_n_tb <= "1011";
                    writedata_tb         <= x"FFFFFFFF";
                    checkdata            <= x"11FF22DD";
                    wait for 40 ns;

                    assert checkdata = readdata_tb report "data is wrong" severity error;
                    address_tb <= address_tb + x"001";
                end loop;
                address_tb <= x"000";
            --case 7, byte, bit 4
            when 6 =>
                for j in 0 to 4095 loop
                    writebyteenable_n_tb <= "0111";
                    writedata_tb         <= x"AAAAAAAA";
                    checkdata            <= x"AA1122FF";
                    wait for 40 ns;

                    assert checkdata = readdata_tb report "data is wrong" severity error;
                    address_tb <= address_tb + x"001";
                end loop;
                address_tb <= x"000";
            end case;
            wait for period;
        end loop;
        report "test complete";
    end process;

end architecture beh;
