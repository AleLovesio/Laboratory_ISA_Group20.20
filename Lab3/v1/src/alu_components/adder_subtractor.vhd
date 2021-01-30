library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- overflow is ignored or handled by a separate unit
entity adder_subtractor is
	port (
		in_a, in_b : in signed (31 downto 0);
		cin : in std_logic;
		output : out signed (31 downto 0)); 
end adder_subtractor;

architecture behavioural of adder_subtractor is
	signal b_int : signed (31 downto 0);
	component adder is
		generic (N : integer := 32);
		port (
			in_a, in_b : in signed (N-1 downto 0);
			output : out signed (N-1 downto 0));
	end component adder;
begin  
	b_int <= in_b when cin = '0' else
			 -in_b;
	adder1: adder generic map (32) port map (in_a, b_int, output);
end behavioural;
