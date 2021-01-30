LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY instruction_mem IS
	generic (M : INTEGER := 32 );
	port(	--RSTn: in std_logic; --active low synchronous reset
			Address: in unsigned(M-1 downto 0); --cell address
			RE: in std_logic; --write enable and read enable
			Ready : out std_logic; --signal asserted when the initialization of the memory is complete
			Data_OUT: out std_logic_vector(31 downto 0)); --data contained in the cell address
END ENTITY instruction_mem;


ARCHITECTURE behavioral OF instruction_mem IS

	constant LOC : integer := 20000;
	type ram_array is array (0 to LOC) of std_logic_vector(7 downto 0);
	signal mem: ram_array;
	signal end_init : std_logic := '0';
	
	begin
	
	p0: process (RE, Address)
		variable line_v : line;
		file instruction_file : text;
		variable add : integer := 0;
		variable word : std_logic_vector(31 DOWNTO 0);
	begin --process
		--initilization (run only one time)
		if end_init = '0' then
			file_open(instruction_file, "./bin_code_nopA.txt", read_mode);
			while not endfile(instruction_file) loop
				readline(instruction_file, line_v);
				read(line_v, word);
				mem(add) <= word(31 downto 24);
				mem(add+1) <= word(23 downto 16);
				mem(add+2) <= word(15 downto 8);
				mem(add+3) <= word(7 downto 0); 
				add := add+4;
			end loop;
			end_init <= '1';
		end if;
		
		if RE = '1' then 
			Data_OUT(31 downto 24) <= mem(to_integer(Address)); -- -4194304
			Data_OUT(23 downto 16) <= mem(to_integer(Address)+1);
			Data_OUT(15 downto 8) <= mem(to_integer(Address)+2);
			Data_OUT(7 downto 0) <= mem(to_integer(Address)+3);
		end if;
		
	end process p0;	
	
	Ready <= end_init;
	
END ARCHITECTURE behavioral;
