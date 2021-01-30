LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY fwd_unit IS
	PORT(
			RegWrite_EXMEM, RegWrite_MEMWB, ALUSrc : IN STD_LOGIC; -- input control signals
			PrevMemToReg	: IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- signal to understand how to manage the mux to select the correct data to forward (throught the signal DataSel)
			SourceReg1, SourceReg2, DestReg_EXMEM, DestReg_MEMWB : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- input addresses of registers
			FwdA, FwdB, DataSel	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- output control signals for muxes
		); 
END ENTITY fwd_unit;

ARCHITECTURE Behavioral OF fwd_unit IS
SIGNAL IS_EX_Reg1, IS_EX_Reg2, IS_MEM_Reg1, IS_MEM_Reg2 : STD_LOGIC; -- isgnals used to identify the correct data dependency

BEGIN


IS_EX_Reg1 		<= RegWrite_EXMEM WHEN (SourceReg1 = DestReg_EXMEM  AND DestReg_EXMEM /= "00000") ELSE '0';
IS_EX_Reg2 		<= RegWrite_EXMEM WHEN (SourceReg2 = DestReg_EXMEM  AND DestReg_EXMEM /= "00000")  ELSE '0';
IS_MEM_Reg1 	<= RegWrite_MEMWB WHEN (SourceReg1 = DestReg_MEMWB  AND DestReg_MEMWB /= "00000")  ELSE '0';
IS_MEM_Reg2 	<= RegWrite_MEMWB WHEN (SourceReg2 = DestReg_MEMWB  AND DestReg_MEMWB /= "00000")  ELSE '0';


-- output generation
FwdA(0) <=	(NOT IS_EX_Reg1 AND IS_MEM_Reg1);
FwdA(1) <=	(IS_EX_Reg1 NOR IS_MEM_Reg1);
FwdB(0) <=	(NOT IS_EX_Reg2 AND IS_MEM_Reg2) OR ALUSrc;
FwdB(1) <=	(IS_EX_Reg2 NOR IS_MEM_Reg2) OR ALUSrc;

DataSel(0) <= PrevMemToReg(0) XOR PrevMemToReg(1);
DataSel(1) <= PrevMemToReg(0) AND PrevMemToReg(1);


END ARCHITECTURE Behavioral;
