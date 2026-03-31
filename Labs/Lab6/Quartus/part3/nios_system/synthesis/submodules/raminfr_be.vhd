LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity raminfr_be is
    port(
        clk                 : in std_logic;
        reset_n             : in std_logic;
        writebyteenable_n   : in std_logic_vector(3 downto 0);
        address             : in std_logic_vector(11 downto 0);
        writedata           : in std_logic_vector(31 downto 0);
        readdata            : out std_logic_vector(31 downto 0)
    );
end entity raminfr_be;

architecture RTL of raminfr_be is
    
    Type ram_type is array (4095 downto 0) of std_logic_vector(7 downto 0);
    signal RAM_1       : ram_type;
    signal RAM_2       : ram_type;
    signal RAM_3       : ram_type;
    signal RAM_4       : ram_type;
    signal read_addr   : std_logic_vector(11 downto 0);

begin
    
    RamBlock_1  : process(clk)
    begin
        if(clk'event and clk = '1') then
            if (reset_n = '0') then
                read_addr <= (others => '0');
            elsif (writebyteenable_n(0) = '0') then
                RAM_1(CONV_INTEGER(address)) <= writedata(7 downto 0);
            end if;
            read_addr <= address;
        end if;
    end process RamBlock_1;

    RamBlock_2  : process(clk)
    begin
        if(clk'event and clk = '1') then
            if(writebyteenable_n(0) = '0') then
					RAM_2(CONV_INTEGER(address)) <= writedata(7 downto 0);
				end if;
        end if;
    end process RamBlock_2;

    RamBlock_3  : process(clk)
    begin
        if(clk'event and clk = '1') then
            if(writebyteenable_n(0) = '0') then
					RAM_3(CONV_INTEGER(address)) <= writedata(7 downto 0);
				end if;
        end if;
    end process RamBlock_3;

    RamBlock_4  : process(clk)
    begin
        if(clk'event and clk = '1') then
            if(writebyteenable_n(0) = '0') then
					RAM_4(CONV_INTEGER(address)) <= writedata(7 downto 0);
				end if;
        end if;
    end process RamBlock_4;

    readdata <= RAM_1(CONV_INTEGER(read_addr)) & RAM_2(CONV_INTEGER(read_addr)) & RAM_3(CONV_INTEGER(read_addr)) & RAM_4(CONV_INTEGER(read_addr));

end architecture RTL;