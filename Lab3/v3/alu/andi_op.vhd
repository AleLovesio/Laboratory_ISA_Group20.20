library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity andi_op is
	port (
		in_a, in_b : in signed (31 downto 0);
		output : out signed (31 downto 0)); 
end andi_op;

architecture behavioural of andi_op is
begin
	output <= in_a and in_b;
end behavioural;