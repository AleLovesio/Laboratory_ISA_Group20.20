library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eq_comparator is
	port (
		in_a, in_b : in signed (31 downto 0);
		eq_flag : out std_logic);
end eq_comparator;

-- architecture behavioural of eq_comparator is
-- begin
	-- eq_flag <= '1' when in_a = in_b else 
			   -- '0';
-- end behavioural;

architecture semi_behavioural of eq_comparator is
	signal xor_res : signed (31 downto 0);
	component xor_op is
		port (
		in_a, in_b : in signed (31 downto 0);
		output : out signed (31 downto 0)); 
	end component xor_op;
begin
	xor1: xor_op port map (in_a, in_b, xor_res);
	eq_flag <= '1' when xor_res = (31 downto 0 => '0') else
			   '0';
end semi_behavioural;