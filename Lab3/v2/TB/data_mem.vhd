LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY data_mem IS
	generic (M : INTEGER := 32 );
	port(	RSTn: in std_logic; --active low synchronous reset
			Address: in unsigned(M-1 downto 0); --cell address
			Data_IN: in std_logic_vector(31 downto 0); --data to write
			WE, RE: in std_logic; --write enable and read enable
			Ready : out std_logic; --signal asserted when the initialization of the memory is complete
			Data_OUT: out std_logic_vector(31 downto 0)); --data contained in the cell address
END ENTITY data_mem;

ARCHITECTURE behavioral OF data_mem IS

	constant LOC : integer := 200;
	type ram_array is array (0 to LOC) of std_logic_vector(7 downto 0);
	signal mem: ram_array;
	signal end_init : std_logic := '0';
	
BEGIN
		
	p0: process (WE, RE)
		variable line_v : line;
		file data_file : text;
		variable add : integer := 0;
		variable word : std_logic_vector(31 DOWNTO 0);
	begin --process
		--initilization (run only one time)
		if end_init = '0' then
			file_open(data_file, "./bin_data.txt", read_mode);
			while not endfile(data_file) loop
				readline(data_file, line_v);
				read(line_v, word);
				mem(add) <= word(31 downto 24);
				mem(add+1) <= word(23 downto 16);
				mem(add+2) <= word(15 downto 8);
				mem(add+3) <= word(7 downto 0); 
				add := add+4;
			end loop;
			end_init <= '1';
		end if;
		--if RSTn = '1' then 
			if RE = '1' then 
				Data_OUT(31 downto 24) <= mem(to_integer(Address)-8192); -- -268500992 -8192
				Data_OUT(23 downto 16) <= mem(to_integer(Address)+1-8192);
				Data_OUT(15 downto 8) <= mem(to_integer(Address)+2-8192);
				Data_OUT(7 downto 0) <= mem(to_integer(Address)+3-8192);
			--end if;
			--if WE = '1' then 
			elsif WE = '1' then 
				mem(to_integer(Address)-8192) <= Data_IN(31 downto 24);
				mem(to_integer(Address)+1-8192) <= Data_IN(23 downto 16);
				mem(to_integer(Address)+2-8192) <= Data_IN(15 downto 8);
				mem(to_integer(Address)+3-8192) <= Data_IN(7 downto 0);
			end if;
		--else --reset
		--	mem <= (others => (others => '0'));
		--end if;
	end process p0;	
	
	Ready <= end_init;
	
END ARCHITECTURE behavioral;
