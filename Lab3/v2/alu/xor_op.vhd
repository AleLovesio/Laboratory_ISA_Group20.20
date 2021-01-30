library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xor_op is
	port (
		in_a, in_b : in signed (31 downto 0);
		output : out signed (31 downto 0)); 
end xor_op;

architecture behavioural of xor_op is
begin
	output <= in_a xor in_b;
end behavioural;