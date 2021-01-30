LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_unit IS
	PORT(
			
			INSTRUCTION : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- Instruction 
			RegWrite, MemRead, MemWrite, Branch, ALUSrc : OUT STD_LOGIC; -- control signals
			ALUOp, MemtoReg: OUT STD_LOGIC_VECTOR (1 DOWNTO 0) -- control signals
		); 
END ENTITY control_unit;

ARCHITECTURE Behavioral OF control_unit IS

	-- ADD - R TYPE
	CONSTANT OPCODE_ADD 	: STD_LOGIC_VECTOR(6 DOWNTO 0)	:= "0110011";
	CONSTANT FUNCT3_ADD 	: STD_LOGIC_VECTOR(2 DOWNTO 0)	:= "000";
	-- ADDI - I TYPE
	CONSTANT OPCODE_ADDI 	: STD_LOGIC_VECTOR(6 DOWNTO 0)	:= "0010011";
	CONSTANT FUNCT3_ADDI 	: STD_LOGIC_VECTOR(2 DOWNTO 0)	:= "000";
	-- AUIPC - U TYPE
	CONSTANT OPCODE_AUIPC 	: STD_LOGIC_VECTOR(6 DOWNTO 0)	:= "0010111";
	-- LUI - U TYPE
	CONSTANT OPCODE_LUI 	: STD_LOGIC_VECTOR(6 DOWNTO 0)	:= "0110111";
	-- BEQ - B TYPE
	CONSTANT OPCODE_BEQ 	: STD_LOGIC_VECTOR(6 DOWNTO 0)	:= "1100011";
	CONSTANT FUNCT3_BEQ 	: STD_LOGIC_VECTOR(2 DOWNTO 0)	:= "000";
	-- LW - I TYPE
	CONSTANT OPCODE_LW 		: STD_LOGIC_VECTOR(6 DOWNTO 0)	:= "0000011";
	CONSTANT FUNCT3_LW 		: STD_LOGIC_VECTOR(2 DOWNTO 0)	:= "010";
	-- SRAI - R TYPE
	CONSTANT OPCODE_SRAI 	: STD_LOGIC_VECTOR(6 DOWNTO 0)	:= "0010011";
	CONSTANT FUNCT3_SRAI 	: STD_LOGIC_VECTOR(2 DOWNTO 0)	:= "101";
	-- ANDI - I TYPE
	CONSTANT OPCODE_ANDI 	: STD_LOGIC_VECTOR(6 DOWNTO 0) 	:= "0010011";
	CONSTANT FUNCT3_ANDI 	: STD_LOGIC_VECTOR(2 DOWNTO 0)	:= "111";
	-- XOR - R TYPE
	CONSTANT OPCODE_XOR 	: STD_LOGIC_VECTOR(6 DOWNTO 0) 	:= "0110011";
	CONSTANT FUNCT3_XOR 	: STD_LOGIC_VECTOR(2 DOWNTO 0)	:= "100";
	-- SLT - R TYPE
	CONSTANT OPCODE_SLT 	: STD_LOGIC_VECTOR(6 DOWNTO 0) 	:= "0110011";
	CONSTANT FUNCT3_SLT 	: STD_LOGIC_VECTOR(2 DOWNTO 0)	:= "010";
	-- JAL - J TYPE
	CONSTANT OPCODE_JAL 	: STD_LOGIC_VECTOR(6 DOWNTO 0)	:= "1101111";
	-- SW - S TYPE
	CONSTANT OPCODE_SW 		: STD_LOGIC_VECTOR(6 DOWNTO 0) 	:= "0100011";
	CONSTANT FUNCT3_SW	 	: STD_LOGIC_VECTOR(2 DOWNTO 0)	:= "010";
	-- ABS - I TYPE
	CONSTANT OPCODE_ABS 	: STD_LOGIC_VECTOR(6 DOWNTO 0) 	:= "0001011";
	CONSTANT FUNCT3_ABS	 	: STD_LOGIC_VECTOR(2 DOWNTO 0)	:= "000";
	
	SIGNAL 	 OPCODE			: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL   FUNCT3			: STD_LOGIC_VECTOR(14 DOWNTO 12);
	SIGNAL	 IS_ADD, IS_ADDI, IS_AUIPC, IS_LUI, IS_BEQ, IS_LW, IS_SRAI, IS_ANDI, IS_XOR, IS_SLT, IS_JAL, IS_SW, IS_ABS : STD_LOGIC;
BEGIN
	OPCODE 		<= INSTRUCTION(6 DOWNTO 0);
	FUNCT3 		<= INSTRUCTION(14 DOWNTO 12);
	IS_ADD 		<= '1' WHEN ((OPCODE = OPCODE_ADD) 	AND (FUNCT3 = FUNCT3_ADD)) 	ELSE '0';
	IS_ADDI 	<= '1' WHEN ((OPCODE = OPCODE_ADDI) AND (FUNCT3 = FUNCT3_ADDI)) ELSE '0';
	IS_AUIPC 	<= '1' WHEN  (OPCODE = OPCODE_AUIPC) 							ELSE '0';
	IS_LUI 		<= '1' WHEN  (OPCODE = OPCODE_LUI) 								ELSE '0';
	IS_BEQ 		<= '1' WHEN ((OPCODE = OPCODE_BEQ) 	AND (FUNCT3 = FUNCT3_BEQ)) 	ELSE '0';
	IS_LW 		<= '1' WHEN ((OPCODE = OPCODE_LW) 	AND (FUNCT3 = FUNCT3_LW)) 	ELSE '0';
	IS_SRAI 	<= '1' WHEN ((OPCODE = OPCODE_SRAI) AND (FUNCT3 = FUNCT3_SRAI)) ELSE '0';
	IS_ANDI 	<= '1' WHEN ((OPCODE = OPCODE_ANDI) AND (FUNCT3 = FUNCT3_ANDI)) ELSE '0';
	IS_XOR 		<= '1' WHEN ((OPCODE = OPCODE_XOR) 	AND (FUNCT3 = FUNCT3_XOR)) 	ELSE '0';
	IS_SLT 		<= '1' WHEN ((OPCODE = OPCODE_SLT) 	AND (FUNCT3 = FUNCT3_SLT)) 	ELSE '0';
	IS_JAL 		<= '1' WHEN  (OPCODE = OPCODE_JAL) 								ELSE '0';
	IS_SW 		<= '1' WHEN ((OPCODE = OPCODE_SW) 	AND (FUNCT3 = FUNCT3_SW)) 	ELSE '0';
	IS_ABS 		<= '1' WHEN ((OPCODE = OPCODE_ABS) 	AND (FUNCT3 = FUNCT3_ABS)) 	ELSE '0';
	
	RegWrite 	<= IS_ADD OR IS_ADDI OR IS_AUIPC OR IS_LUI OR  			IS_LW OR IS_SRAI OR IS_ANDI OR IS_XOR OR IS_SLT OR IS_JAL          OR IS_ABS;
	MemRead 	<=                                                      IS_LW                                                             			;
	MemWrite 	<=                                                                                                                   IS_SW   		;
	Branch 		<=                                            IS_BEQ OR                                                    IS_JAL         			;
	ALUSrc 		<=           IS_ADDI OR             IS_LUI OR           IS_LW OR IS_SRAI OR IS_ANDI OR                               IS_SW OR IS_ABS;
	ALUOp(0) 	<=                                                                          IS_ANDI OR IS_XOR OR IS_SLT OR IS_JAL          OR IS_ABS; --RIMUOVERE "OR IS_JAL" SE NON SERVE
	ALUOp(1) 	<=                                  IS_LUI OR                    IS_SRAI OR                      IS_SLT                   			; 
	MemtoReg(0)	<=                                                      IS_LW OR                                           IS_JAL         			;
	MemtoReg(1) <=                      IS_AUIPC OR                                                                        IS_JAL         			;
END ARCHITECTURE Behavioral;
