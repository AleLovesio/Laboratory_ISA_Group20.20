library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slt_comparator is
	port (
		in_a, in_b : in signed (31 downto 0);
		cin : in std_logic;
		slt_reg : out signed (31 downto 0);
		output : out signed (31 downto 0));
end slt_comparator;

-- architecture behavioural of slt_comparator is
-- begin
	-- slt_reg <=  (31 downto 1 => '0') & '1' when in_a < in_b else
			    -- (others => '0');
-- end behavioural;

architecture semi_behavioural of slt_comparator is
	signal output_int : signed (31 downto 0);
	component adder_subtractor is
		port (
		in_a, in_b : in signed (31 downto 0);
		cin : in std_logic;
		output : out signed (31 downto 0)); 
	end component adder_subtractor;
begin
	add_sub: adder_subtractor port map (in_a, in_b, cin, output_int);
	slt_reg <= (31 downto 1 => '0') & output_int(31);
	output <= output_int;
end semi_behavioural;
	