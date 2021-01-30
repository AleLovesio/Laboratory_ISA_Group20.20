library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_cu is
	port (
		instr_mem_out, aluop_cu : in std_logic_vector (1 downto 0); 
		aluop_out : out std_logic_vector (2 downto 0)); 
end alu_cu;

architecture behavioural of alu_cu is
	signal coded_in : std_logic_vector	(3 downto 0);
begin
	coded_in <= aluop_cu & instr_mem_out;  --aluop[1] & aluop[0] & mem[5] & mem[4]
	op_gen:
	process (coded_in) is
	begin
		case coded_in is
			when "0001" => --andi
				aluop_out <= "000";
			when "0010" | "0011" => --xor, beq 
				aluop_out <= "001";
			when "1101" | "1110" | "1111" | "1010" | "1000" => --auipc, add, addi, sw, lw
				aluop_out <= "010";
			when "1011" => --lui
				aluop_out <= "011";
			when "0101" => --srai
				aluop_out <= "100";
			when "0111" => --slt
				aluop_out <= "101";
			when "0110" => --jal
				aluop_out <= "110";
			when others => 
				aluop_out <= "111";
		end case;
	end process;
end architecture behavioural;
