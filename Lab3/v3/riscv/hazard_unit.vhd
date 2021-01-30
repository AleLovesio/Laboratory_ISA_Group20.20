LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY hazard_unit IS
	PORT(
			MemRead, Branch, Equal : IN STD_LOGIC; -- ID/EX MemRead
			Instruction : IN STD_LOGIC_VECTOR (24 DOWNTO 0); -- current instruction (IF/ID)
			DestRegID, DestRegEX, DestRegMEM : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- input address of destination register of previous instruction (ID/EX)
			En_Sel, Rst_IF, Rst_PC, PCScr : OUT STD_LOGIC --output control signals   before: En_IFID, En_PC, CU_Sel
		); 
END ENTITY hazard_unit;

ARCHITECTURE Behavioral OF hazard_unit IS
	SIGNAL ld_use_cond, ld_use, beq, jal, Rst_IF_int, is_beq, is_SC1, is_SC2, is_SC : STD_LOGIC;
	SIGNAL rs1, rs2, rs1_beq, rs2_beq : STD_LOGIC_VECTOR (4 DOWNTO 0);
BEGIN

	-- Data Hazards
	rs1 <= Instruction(19 DOWNTO 15) WHEN Instruction(2 DOWNTO 0) = "011" ELSE "00000";   
	rs2 <= Instruction(24 DOWNTO 20) WHEN Instruction(6 DOWNTO 0) = "-1--011" ELSE "00000";
	ld_use_cond <= '1' WHEN (DestRegID = rs1 OR DestRegID = rs2) ELSE '0';
	ld_use <= MemRead AND ld_use_cond;
	En_Sel <= ld_use NOR is_SC;
--	En_Sel <= '1' WHEN ld_use = '0' ELSE '0';
--	En_PC 	<= '1' WHEN ld_use = '0' ELSE '0';
--	CU_Sel 	<= '1' WHEN ld_use = '0' ELSE '0';

	-- Control Hazards
	beq <= NOT (Branch AND Equal);
	jal <= '0' WHEN Instruction(3 DOWNTO 0) = "1111" ELSE '1'; 
	Rst_IF_int  <= beq AND jal;
	PCScr   <= NOT Rst_IF_int;
	Rst_PC <= Rst_IF_int OR is_SC;
	Rst_IF <= Rst_IF_int OR is_SC;
	
	-- Special case of beq
	is_beq <= '1' WHEN Instruction(6 DOWNTO 0) = "1100011" ELSE '0'; -- identify the beq instruction
	rs1_beq <= Instruction(19 DOWNTO 15);   -- can be avoided (should be ok also rs1)
	rs2_beq <= Instruction(24 DOWNTO 20);	-- can be avoided (should be ok also rs2)
	is_SC1 <= '1' WHEN (DestRegID = rs1_beq OR DestRegEX = rs1_beq OR DestRegMEM = rs1_beq) AND (rs1_beq /= "00000") ELSE '0';
	is_SC2 <= '1' WHEN (DestRegID = rs2_beq OR DestRegEX = rs2_beq OR DestRegMEM = rs2_beq) AND (rs2_beq /= "00000") ELSE '0';
	is_SC <= is_beq AND (is_SC1 OR is_SC2);

END ARCHITECTURE Behavioral;
