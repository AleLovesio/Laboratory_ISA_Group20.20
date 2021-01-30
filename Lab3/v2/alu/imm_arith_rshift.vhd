library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imm_arith_rshift is
	port (
		input : in signed (31 downto 0);
		position : in unsigned (4 downto 0);
		output : out signed (31 downto 0)); 
end imm_arith_rshift;

architecture behavioural of imm_arith_rshift is
	signal position_int : integer;
begin
	position_int <= to_integer(position);
	output <= shift_right(input, position_int);
end behavioural;
