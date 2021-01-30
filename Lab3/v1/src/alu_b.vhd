library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_b is
	port (
		in_a, in_b : in signed (31 downto 0);  --in_b has mux before
		aluop : in std_logic_vector (2 downto 0);
		zero, overflow : out std_logic;
		output : out signed (31 downto 0)); 
end alu_b;

architecture behavioural of alu_b is
	signal output_int : signed (31 downto 0);
	signal position_int : integer;
begin
	out_gen: 
	process (in_a, in_b, aluop) is
	begin
		case aluop is
			when "000" =>   --andi
				output_int <= in_a and in_b;
			when "001" =>    --xor, beq
				output_int <= in_a xor in_b;
			when "010" =>  --auipc, add, addi, jal, sw, lw
				output_int <= in_a + in_b;
			when "011" => --lui
				output_int <= in_b; 
			when "100" =>  --srai
				position_int <= to_integer(in_b);
				output_int <= shift_right(in_a, position_int);
			when "101" =>  --slt
				if in_a < in_b then
					output_int <= (31 downto 1 => '0') & '1';
				else	
					output_int <= (others => '0');
				end if;
			when others =>
				output_int <= (others => '0');
		end case;
	end process;
	overflow <= '0';
	zero <= '1' when output_int = (31 downto 0 => '0') else
			'0';
	output <= output_int;
end behavioural;

architecture semi_behavioral of alu_b is
	signal output_int, slt_reg, add_sub_out, andi_out, xor_out, rshift_out : signed (31 downto 0);
	component imm_arith_rshift is
		port (
		input : in signed (31 downto 0);
		position : in unsigned (4 downto 0);
		output : out signed (31 downto 0)); 
	end component imm_arith_rshift;
	component andi_op is
		port (
		in_a, in_b : in signed (31 downto 0);
		output : out signed (31 downto 0)); 
	end component andi_op;
	component xor_op is 
		port (
		in_a, in_b : in signed (31 downto 0);
		output : out signed (31 downto 0));
	end component xor_op;
	component slt_comparator is
		port (
		in_a, in_b : in signed (31 downto 0);
		cin : in std_logic;
		slt_reg : out signed (31 downto 0);
		output : out signed (31 downto 0));
	end component slt_comparator;
begin
	slt_add_sub: slt_comparator port map (in_a, in_b, aluop(0), slt_reg, add_sub_out); --aluop(0) = cin, add_sub_out = sum/sub, slt_reg = 1 or 0
	rshifti: imm_arith_rshift port map (in_a, unsigned(in_b(4 downto 0)), rshift_out);
	andi1: andi_op port map (in_a, in_b, andi_out);
	xor1: xor_op port map (in_a, in_b, xor_out);
	overflow <= '0';
	zero <= '1' when output_int = (31 downto 0 => '0') else
			'0';
	output <= output_int;
	process (andi_out, xor_out, add_sub_out, in_b, rshift_out, slt_reg, aluop) is
	begin
		case aluop is
			when "000" =>   --andi
				output_int <= signed(andi_out);
			when "001" =>   --xor, beq
				output_int <= signed(xor_out);
			when "010" =>   --auipc, add, addi, jal, sw, lw
				output_int <= add_sub_out;
			when "011" =>   --lui
				output_int <= in_b;
			when "100" =>   --srai
				output_int <= signed(rshift_out);
			when "101" =>   --slt
				output_int <= slt_reg;
			when others =>
				output_int <= (others => '0');
		end case;
	end process;
end architecture semi_behavioral;
