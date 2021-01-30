LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY fwd_unit IS
	PORT(
			RegWrite_EXMEM, RegWrite_MEMWB, ALUSrc : IN STD_LOGIC; -- input control signals
			SourceReg1, SourceReg2, DestReg_EXMEM, DestReg_MEMWB : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- input addresses of registers
			FwdA, FwdB	: OUT STD_LOGIC_VECTOR(1 DOWNTo 0) -- output control signals for muxes
		); 
END ENTITY fwd_unit;

ARCHITECTURE Behavioral OF fwd_unit IS
SIGNAL IS_EX_Reg1, IS_EX_Reg2, IS_MEM_Reg1, IS_MEM_Reg2 : STD_LOGIC := '0'; -- isgnals used to identify the correct data dependency

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


END ARCHITECTURE Behavioral;
