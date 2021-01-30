library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- overflow is ignored or handled by a separate unit
entity adder is
	generic (N : integer := 32);
	port (
		in_a, in_b : in signed (N-1 downto 0);
		output : out signed (N-1 downto 0)); 
end adder;

architecture behavioural of adder is

begin  
	output <= in_a + in_b;
end behavioural;
