LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY hazard_unit IS
	PORT(
			MemRead : IN STD_LOGIC; -- input control signals
			Instruction : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- current instruction (SERVONO SOLO SR1 e SR2???)
			DestReg : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- input address of destination register of previous instr
			En_IFID, En_PC, CU_Sel : OUT STD_LOGIC --output control signals 
		); 
END ENTITY hazard_unit;

ARCHITECTURE Behavioral OF hazard_unit IS


BEGIN
	En_IFID <= '1';
	En_PC 	<= '1';
	CU_Sel 	<= '1';

END ARCHITECTURE Behavioral;
