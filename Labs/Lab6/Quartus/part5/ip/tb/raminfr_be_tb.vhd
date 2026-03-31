-------------------------------------------------------------------------------
-- Ryan Karges
-- Lab 7 ram test, test bench
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use std.env.all;

entity raminfr_be_tb is
end raminfr_be_tb;

architecture arch of raminfr_be_tb is

component raminfr_be IS
  PORT(
    clk : IN std_logic;
    reset_n : IN std_logic;
    writebyteenable_n : IN std_logic_vector (3 downto 0);
    address : IN std_logic_vector(11 DOWNTO 0);
    writedata : IN std_logic_vector(31 DOWNTO 0);
    --
    readdata : OUT std_logic_vector(31 DOWNTO 0)
  );
END component;

signal toggle : boolean := true;

signal period            : time := 20 ns;                                              
signal clk               : std_logic := '0';
signal reset_n           : std_logic := '0';
signal writebyteenable_n : std_logic_vector (3 downto 0) := (others => '0');
signal address           : std_logic_vector(11 DOWNTO 0) := (others => '0');
signal writedata         : std_logic_vector(31 DOWNTO 0) := (others => '0');
signal readdata          : std_logic_vector(31 DOWNTO 0) := (others => '0');



TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF std_logic_vector (7 DOWNTO 0);
--4 instances of 4K x8 ram to make 4K x32
SIGNAL RAM_1 : ram_type; --(31 downto 24)
SIGNAL RAM_2 : ram_type; --(23 downto 16) 
SIGNAL RAM_3 : ram_type; --(15 downto 8)
SIGNAL RAM_4 : ram_type; --(7 downto 0)

SIGNAL read_addr : std_logic_vector(11 DOWNTO 0);


begin

clk_time : process
  begin
    clk <= not clk;
    wait for period/2;
  end process;

reset : process 
  begin
    wait for period;
    reset_n <= '1';
  end process reset;

ram_comp : raminfr_be
  port map(
    clk               => clk,
    reset_n           => reset_n,
    writebyteenable_n => writebyteenable_n,
    address           => address,
    writedata         => writedata,
    readdata          => readdata
  );

write_byte : process
  begin
    wait until reset_n = '1';
    wait for period;
    -- loops through all possible write options
    for i in 0 to 15 loop
      writebyteenable_n <= std_logic_vector(to_unsigned(i, writebyteenable_n'length));
        writedata <= writedata + x"08888888";
      for k in 0 to 4096 loop
        assert RAM_1(conv_integer(address)) = readdata(31 downto 24)
        report "Ram 1 is wrong. It should be " & integer'image(to_integer(unsigned(readdata(31 downto 24)))) & CR
        severity error;

        assert RAM_2(conv_integer(address)) = readdata(23 downto 16)
        report "Ram 2 is wrong. It should be " & integer'image(to_integer(unsigned(readdata(23 downto 16)))) & CR
        severity error;

        assert RAM_3(conv_integer(address)) = readdata(15 downto 8)
        report "Ram 3 is wrong. It should be " & integer'image(to_integer(unsigned(readdata(15 downto 8)))) & CR
        severity error;

        assert RAM_4(conv_integer(address)) = readdata(7 downto 0)
        report "Ram 4 is wrong. It should be " & integer'image(to_integer(unsigned(readdata(7 downto 0)))) & CR
        severity error;

        wait for period*2;
        address <= std_logic_vector(to_unsigned(k, address'length));

    end loop;
 
    end loop;
    Report "Simulation Complete";
    stop;
  end process write_byte;

Address_process : PROCESS(clk)
    BEGIN
      IF (clk'event AND clk = '1') THEN
        IF (reset_n = '0') THEN
          read_addr <= (OTHERS => '0');
        END IF;
        read_addr <= address;
      END IF;
  END PROCESS Address_process;
 


  RAM_1_Write : PROCESS(clk)
    BEGIN
      IF (clk'event AND clk = '1') THEN
		  IF (reset_n = '0') THEN
		   RAM_1 <= (others => (others => '0'));
        ELSIF (writebyteenable_n(3) = '0') THEN
          RAM_1(conv_integer(address)) <= writedata(31 downto 24);
        END IF;
      END IF;
  END PROCESS RAM_1_Write;
  
    
  RAM_2_Write : PROCESS(clk)
    BEGIN
      IF (clk'event AND clk = '1') THEN
        IF (reset_n = '0') THEN
          RAM_2 <= (others => (others => '0'));
        ELSIF (writebyteenable_n(2) = '0') THEN 
		      RAM_2(conv_integer(address)) <= writedata(23 downto 16);
        END IF;
      END IF;
  END PROCESS RAM_2_Write;
  
  RAM_3_Write : PROCESS(clk)
    BEGIN
      IF (clk'event AND clk = '1') THEN
        IF (reset_n = '0') THEN
		   RAM_3 <= (others => (others => '0'));
        ELSIF (writebyteenable_n(1) = '0') THEN  
			    RAM_3(conv_integer(address)) <= writedata(15 downto 8);
        END IF;
      END IF;
  END PROCESS RAM_3_Write;
  
  RAM_4_Write : PROCESS(clk)
    BEGIN
      IF (clk'event AND clk = '1') THEN
        IF (reset_n = '0') THEN
		   RAM_4 <= (others => (others => '0'));
        ELSIF (writebyteenable_n(0) = '0') THEN 
			    RAM_4(conv_integer(address)) <= writedata(7 downto 0); 
        END IF;
      END IF;
  END PROCESS RAM_4_Write;

end arch;