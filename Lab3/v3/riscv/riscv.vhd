LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY riscv IS
	PORT(
			CLK, RSTn, ASYNC_RSTn, EN : IN STD_LOGIC; --clock, sync reset (active low), sync reset (active low), enable
			ADDR_INSTR, ADDR_DATA : OUT UNSIGNED (31 DOWNTO 0); -- Instruction and data memories addresses
			MEM_INSTR, MEM_DATA_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0); --Instrcutions and data from memories
			MEM_DATA_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- Data to memory
			MEM_DATA_WRITE, MEM_DATA_READ : OUT STD_LOGIC -- Write/read enable for data memory
		); 
END ENTITY riscv;

ARCHITECTURE Structural OF riscv IS
-- SIGNAL GENERATED BEFORE THE PC
SIGNAL PC_PC : STD_LOGIC_VECTOR (31 DOWNTO 0); -- PROGRAM COUNTER NEXT COUNT

-- SIGNALS GENERATED IN IF STAGE
SIGNAL IF_PC : STD_LOGIC_VECTOR (31 DOWNTO 0); -- PROGRAM COUNTER COUNT
SIGNAL IF_PC_SIGNED : SIGNED (31 DOWNTO 0); -- PROGRAM COUNTER COUNT
SIGNAL IF_INSTRUCTION : STD_LOGIC_VECTOR (31 DOWNTO 0); --DATA FROM INSTRUCTION MEMORY
SIGNAL IF_PC_PLUS_4 : STD_LOGIC_VECTOR (31 DOWNTO 0); --PC INCREMENTED BY 4
SIGNAL IF_PC_PLUS_4_SIGNED : SIGNED (31 DOWNTO 0); --PC INCREMENTED BY 4
SIGNAL IF_CONSTANT_4_SIGNED : SIGNED (31 DOWNTO 0); -- CONSTANT 4
-- SIGNALS GENERATED IN ID STAGE
SIGNAL ID_PC, ID_PC_PLUS_4, ID_PC_PLUS_IMM, ID_IMMEDIATE_PC_ADD : STD_LOGIC_VECTOR (31 DOWNTO 0); -- PROGRAM COUNTER COUNT
SIGNAL ID_INSTRUCTION : STD_LOGIC_VECTOR (31 DOWNTO 0); --INSTRUCTION
SIGNAL ID_INSTRUCTION_ALU_CTRL : STD_LOGIC_VECTOR (1 DOWNTO 0); -- PART OF INSTRUCTION TO ALU CONTROL
SIGNAL ID_INSTRUCTION_REG_WRITE_ADDR : STD_LOGIC_VECTOR (4 DOWNTO 0); -- PART OF INSTRUCTION FOR ADDRESS WRITEBACK
SIGNAL ID_PC_SIGNED, ID_IMMEDIATE_PC_ADD_SIGNED, ID_PC_PLUS_IMM_SIGNED: SIGNED (31 DOWNTO 0); -- PROGRAM COUNTER COUNT, SIGNED    -- changed (new signals)
SIGNAL ID_RegWrite_CU, ID_MemRead_CU, ID_MemWrite_CU, ID_Branch_CU, ID_ALUSrc_CU, ID_Equal : STD_LOGIC; -- CONTROL SIGNALS FROM CONTROL UNIT
SIGNAL ID_RegWrite, ID_MemRead, ID_MemWrite, ID_ALUSrc : STD_LOGIC; -- CONTROL SIGNALS FROM CONTROL UNIT, AFTER HAZ DETECTION MUX     -- changed (missing signal)
SIGNAL ID_ALUOp_CU, ID_MemtoReg_CU : STD_LOGIC_VECTOR(1 DOWNTO 0); -- CONTROL SIGNALS FROM CONTROL UNIT
SIGNAL ID_ALUOp, ID_MemtoReg : STD_LOGIC_VECTOR(1 DOWNTO 0); -- CONTROL SIGNALS FROM CONTROL UNIT, AFTER HAZ DETECTION MUX
SIGNAL ID_REG_DATA_1, ID_REG_DATA_2 : STD_LOGIC_VECTOR (31 DOWNTO 0); -- DATA FROM REGISTER FILE
SIGNAL ID_IMMEDIATE : STD_LOGIC_VECTOR (31 DOWNTO 0); -- GENERATED IMMEDIATE
SIGNAL ID_CU_SIGNALS_PRE_HAZ, ID_CU_SIGNALS_POST_HAZ : STD_LOGIC_VECTOR (7 DOWNTO 0); -- SIGNAL OUT OF CU TO MUX
-- changed (missing line) 

-- SIGNALS GENERATED IN EX STAGE
SIGNAL EX_PC_PLUS_IMM : STD_LOGIC_VECTOR (31 DOWNTO 0); -- PROGRAM COUNTER COUNT, CALCULATED PC, VALUE TO BE ADDED TO PC   -- changed
SIGNAL EX_PC_PLUS_4 : STD_LOGIC_VECTOR (31 DOWNTO 0); --PC INCREMENTED BY 4
SIGNAL EX_INSTRUCTION_ALU_CTRL : STD_LOGIC_VECTOR (1 DOWNTO 0); -- PART OF INSTRUCTION TO ALU CONTROL
SIGNAL EX_INSTRUCTION_REG_WRITE_ADDR : STD_LOGIC_VECTOR (4 DOWNTO 0); -- PART OF INSTRUCTION FOR ADDRESS WRITEBACK
SIGNAL EX_REG_SOURCE_1, EX_REG_SOURCE_2 : STD_LOGIC_VECTOR (4 DOWNTO 0); -- ADDRESSES OF SOURCE REGISTERS OF PREVIOUS CYCLE
SIGNAL EX_RegWrite, EX_MemRead, EX_MemWrite, EX_ALUSrc : STD_LOGIC; -- CONTROL SIGNALS FROM CONTROL UNIT      -- changed (missing signal)
SIGNAL EX_ALUOp, EX_MemtoReg : STD_LOGIC_VECTOR(1 DOWNTO 0); -- CONTROL SIGNALS FROM CONTROL UNIT
SIGNAL EX_REG_DATA_1, EX_REG_DATA_2 : STD_LOGIC_VECTOR (31 DOWNTO 0); -- DATA FROM REGISTER FILE
SIGNAL EX_IMMEDIATE : STD_LOGIC_VECTOR (31 DOWNTO 0); -- GENERATED IMMEDIATE
SIGNAL EX_ALU_INPUT_1, EX_ALU_INPUT_2 : STD_LOGIC_VECTOR (31 DOWNTO 0); -- ALU INPUTS, OUTPUT OF MULTIPLEXERS
SIGNAL EX_ALUOP_CU : STD_LOGIC_VECTOR (2 DOWNTO 0); -- CONTROL SIGNAL FROM ALU CONTROL TO ALU
SIGNAL EX_SFUOP_CU : STD_LOGIC; -- CONTROL SIGNAL FROM ALU CONTROL TO SFU
SIGNAL EX_ALU_RESULT, EX_SFU_RESULT, EX_DATA_RESULT : STD_LOGIC_VECTOR (31 DOWNTO 0); -- ALU AND SFU RESULTS, FINAL RESULT AFTER MUX
SIGNAL EX_FWD_DATA : STD_LOGIC_VECTOR (31 DOWNTO 0); -- CHOSEN DATA BY THE FORWARDING UNIT
SIGNAL EX_FwdSel	: STD_LOGIC_VECTOR (1 DOWNTO 0);  --SIGNAL USED TO CHOOSE THE CORRECT DATA FOR THE FORWARDING
--SIGNAL EX_ALU_ZERO : STD_LOGIC; -- ALU ZERO FLAG
-- changed (missing signals)
SIGNAL EX_ALU_INPUT_2_SIGNED, EX_ALU_INPUT_1_SIGNED : SIGNED (31 DOWNTO 0); -- SECOND ALU INPUT, OUTPUT OF MUX, SIGNED
SIGNAL EX_ALU_RESULT_SIGNED, EX_SFU_RESULT_SIGNED : SIGNED (31 DOWNTO 0); -- ALU AND SFU RESULTS, SIGNED
SIGNAL EX_OP_MUX_SEL_OUT : STD_LOGIC; -- SELECTOR OF MULTIPLEXER AFTER SFU AND ALU
SIGNAL ForwardA, ForwardB : STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUX CONTROL SIGNALS FROM FORWARDING UNIT


-- SIGNALS GENERATED IN MEM STAGE
SIGNAL MEM_PC_PLUS_IMM : STD_LOGIC_VECTOR (31 DOWNTO 0); -- NEXT PROGRAM COUNTER VALUE
SIGNAL MEM_PC_PLUS_4 : STD_LOGIC_VECTOR (31 DOWNTO 0); --PC INCREMENTED BY 4
SIGNAL MEM_INSTRUCTION_REG_WRITE_ADDR : STD_LOGIC_VECTOR (4 DOWNTO 0); -- PART OF INSTRUCTION ADDRESS FOR WRITEBACK
SIGNAL MEM_DATA_RESULT : STD_LOGIC_VECTOR (31 DOWNTO 0); -- ALU RESULT
--SIGNAL MEM_ALU_ZERO : STD_LOGIC; -- ALU ZERO FLAG
SIGNAL MEM_RegWrite, MEM_MemRead, MEM_MemWrite : STD_LOGIC; -- CONTROL SIGNALS FROM CONTROL UNIT     -- changed (missing signal)
SIGNAL MEM_MemtoReg : STD_LOGIC_VECTOR(1 DOWNTO 0); -- CONTROL SIGNALS FROM CONTROL UNIT
-- changed (missing signal)
SIGNAL MEM_REG_DATA_2 : STD_LOGIC_VECTOR (31 DOWNTO 0); -- DATA FROM REGISTER FILE
SIGNAL MEM_DATA_MEM_DATA : STD_LOGIC_VECTOR (31 DOWNTO 0); -- DATA FROM DATA MEMORY

-- SIGNALS GENERATED IN WB STAGE
SIGNAL WB_PC_PLUS_IMM : STD_LOGIC_VECTOR (31 DOWNTO 0); -- NEXT PROGRAM COUNTER VALUE
SIGNAL WB_PC_PLUS_4 : STD_LOGIC_VECTOR (31 DOWNTO 0); --PC INCREMENTED BY 4
SIGNAL WB_INSTRUCTION_REG_WRITE_ADDR : STD_LOGIC_VECTOR (4 DOWNTO 0); -- PART OF INSTRUCTION FOR ADDRESS WRITEBACK
SIGNAL WB_REG_WRITE_DATA : STD_LOGIC_VECTOR (31 DOWNTO 0); -- DATA WRITEBACK TO REGISTER
SIGNAL WB_RegWrite : STD_LOGIC; -- CONTROL SIGNALS FROM CONTROL UNIT
SIGNAL WB_MemtoReg : STD_LOGIC_VECTOR(1 DOWNTO 0); -- CONTROL SIGNALS FROM CONTROL UNIT
SIGNAL WB_DATA_MEM_DATA : STD_LOGIC_VECTOR (31 DOWNTO 0); -- DATA FROM DATA MEMORY
SIGNAL WB_DATA_RESULT : STD_LOGIC_VECTOR (31 DOWNTO 0); -- ALU RESULT

-- SIGNALS GENERATED BY HAZARD DETECTION UNIT TO MULTIPLE STAGES
SIGNAL HAZ_En_Sel, HAZ_Rst_IF, HAZ_PCScr : STD_LOGIC; --ENABLE SIGNALS FOR REGISTER FROM HAZARD DETECTION UNIT         -- changed

--SIGNALS FOR REGISTERS
SIGNAL IF_ID_EN, PC_EN, Flush : STD_LOGIC; --ENABLE SIGNALS FOR REGISTER        -- changed

-- CONSTANTS
CONSTANT SEVEN_ZEROS : STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000"; 

COMPONENT mux2to1 IS
	GENERIC (N : INTEGER := 1); -- MUX X PARALLELISM
	PORT 	(	
				SEL		: IN STD_LOGIC; -- SELECTOR
				X0, X1	:IN STD_LOGIC_VECTOR (N-1 DOWNTO 0); -- INPUTS
				Y		: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0) -- OUTPUT
			);
END COMPONENT mux2to1;

COMPONENT generic_register IS   
	GENERIC (N : INTEGER := 32);
	PORT 	(	CLK, ASYNC_RSTn, RSTn, EN : IN  STD_LOGIC;  
				D   : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);  
				Q   : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)
			); 
END COMPONENT generic_register; 

COMPONENT ADDER IS
	GENERIC (N : INTEGER := 32);
	PORT (
		IN_A, IN_B : IN SIGNED (N-1 DOWNTO 0);
		OUTPUT : OUT SIGNED (N-1 DOWNTO 0)); 
END COMPONENT ADDER;

COMPONENT register_file IS   
	PORT 	(	WR_EN, CLK, RSTn, ASYNC_RSTn : IN  STD_LOGIC;  
				ADDR_READ_1, ADDR_READ_2, ADDR_WRITE : IN STD_LOGIC_VECTOR (4 DOWNTO 0);  
				DATA_WRITE : IN STD_LOGIC_VECTOR (31 DOWNTO 0); 
				DATA_READ_1, DATA_READ_2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			); 
END COMPONENT register_file; 

COMPONENT imm_gen IS
	PORT(
			INSTRUCTION : IN STD_LOGIC_VECTOR (31 DOWNTO 0); 
			IMMEDIATE : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		); 
END COMPONENT imm_gen;

COMPONENT hazard_unit IS   -- changed
	PORT(
			MemRead, Branch, Equal : IN STD_LOGIC; -- ID/EX MemRead
			Instruction : IN STD_LOGIC_VECTOR (24 DOWNTO 0); -- current instruction (IF/ID)
			DestRegID, DestRegEX, DestRegMEM : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- input address of destination register of previous instruction (ID/EX)
			En_Sel, Rst_IF, PCScr : OUT STD_LOGIC --output control signals   before: En_IFID, En_PC, CU_Sel
		); 
END COMPONENT hazard_unit;

COMPONENT control_unit IS
	PORT(
			
			INSTRUCTION : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- Instruction 
			RegWrite, MemRead, MemWrite, Branch, ALUSrc : OUT STD_LOGIC; -- control signals
			ALUOp, MemtoReg : OUT STD_LOGIC_VECTOR (1 DOWNTO 0) -- control signals
		); 
END COMPONENT control_unit;

COMPONENT register_1bit IS   
	PORT 	(	CLK, ASYNC_RSTn, RSTn, EN : IN  STD_LOGIC;  
				D   : IN STD_LOGIC;  
				Q   : OUT STD_LOGIC
			); 
END COMPONENT register_1bit; 

COMPONENT shift_left_1 IS   
	GENERIC (N : INTEGER := 32);
	PORT 	( 
				D_IN   : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);  
				D_OUT  : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)
			); 
END COMPONENT shift_left_1; 

COMPONENT mux3to1 IS
	GENERIC (N : INTEGER := 1); -- MUX X PARALLELISM
	PORT 	(	
				SEL		: IN STD_LOGIC_VECTOR; -- SELECTOR
				X0, X1, X2	:IN STD_LOGIC_VECTOR (N-1 DOWNTO 0); -- INPUTS
				Y		: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0) -- OUTPUT
			);
END COMPONENT mux3to1;

COMPONENT mux4to1 IS
	GENERIC (N : INTEGER := 1); -- MUX X PARALLELISM
	PORT 	(	
				SEL		: IN STD_LOGIC_VECTOR; -- SELECTOR
				X0, X1, X2, X3	:IN STD_LOGIC_VECTOR (N-1 DOWNTO 0); -- INPUTS
				Y		: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0) -- OUTPUT
			);
END COMPONENT mux4to1;

COMPONENT fwd_unit IS
	PORT(
			RegWrite_EXMEM, RegWrite_MEMWB, ALUSrc : IN STD_LOGIC; -- input control signals
			PrevMemToReg	: IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- signal to understand how to manage the mux to select the correct data to forward (throught the signal DataSel)
			SourceReg1, SourceReg2, DestReg_EXMEM, DestReg_MEMWB : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- input addresses of registers
			FwdA, FwdB, DataSel	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- output control signals for muxes
		); 
END COMPONENT fwd_unit;

COMPONENT alu_b IS
	PORT (
		IN_A, IN_B : IN SIGNED (31 DOWNTO 0);  --IN_B HAS MUX BEFORE
		ALUOP : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		ZERO, OVERFLOW : OUT STD_LOGIC;
		OUTPUT : OUT SIGNED (31 DOWNTO 0)); 
END COMPONENT alu_b;

COMPONENT sfu IS
	PORT (
			IN_A, IN_B : IN SIGNED (31 DOWNTO 0); --IN_B currently not used
			SFUOP : IN STD_LOGIC; -- 0: no op, 1: abs
			ZERO : OUT STD_LOGIC;
			OUTPUT : OUT SIGNED (31 DOWNTO 0)
		); 
END COMPONENT sfu;

COMPONENT alu_cu IS
	PORT (
		INSTR_MEM_OUT, ALUOP_CU : IN STD_LOGIC_VECTOR (1 DOWNTO 0); 
		ALUOP_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		SFUOP_OUT : OUT STD_LOGIC;
		OP_MUX_SEL_OUT : OUT STD_LOGIC); 
END COMPONENT alu_cu;


BEGIN
-- implementations from left to right

Flush <= RSTn AND HAZ_Rst_IF;  -- changed

PC_MUX:			mux2to1 			GENERIC MAP (N => 32) 
									PORT MAP 	(
													SEL 		=> HAZ_PCScr,
													X0 			=> IF_PC_PLUS_4, 
													X1 			=> ID_PC_PLUS_IMM,
													Y 			=> PC_PC 
												);
PC_EN 	<= 	EN AND HAZ_En_Sel;            -- changed	
PC_REG:			generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> PC_EN,
													D 			=> PC_PC,
													Q 			=> IF_PC
												);
ADDR_INSTR 				<= 	UNSIGNED(IF_PC);
IF_INSTRUCTION			<= 	MEM_INSTR;
IF_CONSTANT_4_SIGNED 	<= 	TO_SIGNED(4,32);
IF_PC_SIGNED 			<= 	SIGNED(IF_PC);
IF_PC_PLUS_4			<= 	STD_LOGIC_VECTOR(IF_PC_PLUS_4_SIGNED);
PC_ADDER:		adder				GENERIC MAP (N => 32) 
									PORT MAP 	(
													IN_A 		=> IF_PC_SIGNED,  
													IN_B 		=> IF_CONSTANT_4_SIGNED,
													OUTPUT 		=> IF_PC_PLUS_4_SIGNED
												);
IF_ID_EN	<= 	EN AND HAZ_En_Sel;					-- changed							
IF_ID_REG_1: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> Flush,  				-- changed
													EN 			=> IF_ID_EN,
													D 			=> IF_PC,
													Q 			=> ID_PC
												);
IF_ID_REG_2: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> Flush, 				-- changed
													EN 			=> IF_ID_EN,
													D 			=> IF_INSTRUCTION,
													Q 			=> ID_INSTRUCTION
												);
IF_ID_REG_3: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> Flush, 				-- changed
													EN 			=> IF_ID_EN,
													D 			=> IF_PC_PLUS_4,
													Q 			=> ID_PC_PLUS_4
												);
ID_REG_FILE: 	register_file   	PORT MAP	(	
													CLK 		=> CLK,	
													ASYNC_RSTn	=> ASYNC_RSTn,
													RSTn		=> RSTn,												
													WR_EN 		=> WB_RegWrite,  
													ADDR_READ_1 => ID_INSTRUCTION(19 DOWNTO 15),
													ADDR_READ_2 => ID_INSTRUCTION(24 DOWNTO 20), 
													ADDR_WRITE 	=> WB_INSTRUCTION_REG_WRITE_ADDR,   
													DATA_WRITE 	=> WB_REG_WRITE_DATA, 
													DATA_READ_1 => ID_REG_DATA_1,
													DATA_READ_2 => ID_REG_DATA_2
												);
ID_IMM_GEN:		imm_gen 			PORT MAP	(
													INSTRUCTION => ID_INSTRUCTION,
													IMMEDIATE 	=> ID_IMMEDIATE
												);
ID_SHIFT:		shift_left_1 		GENERIC MAP (N => 32)
									PORT MAP	( 
													D_IN 		=> ID_IMMEDIATE, 
													D_OUT 		=> ID_IMMEDIATE_PC_ADD
												); 
-- changed
ID_PC_SIGNED				<= SIGNED(ID_PC);
ID_IMMEDIATE_PC_ADD_SIGNED 	<= SIGNED(ID_IMMEDIATE);  --without shift
ID_PC_PLUS_IMM 				<= STD_LOGIC_VECTOR(ID_PC_PLUS_IMM_SIGNED);
ID_ADDER:		adder				GENERIC MAP (N => 32) 
									PORT MAP 	(
													IN_A 		=> ID_PC_SIGNED,  
													IN_B 		=> ID_IMMEDIATE_PC_ADD_SIGNED,
													OUTPUT 		=> ID_PC_PLUS_IMM_SIGNED
												);	
CU:				control_unit		PORT MAP	(
													INSTRUCTION => ID_INSTRUCTION, 
													RegWrite 	=> ID_RegWrite_CU,
													MemtoReg 	=> ID_MemtoReg_CU,
													MemRead 	=> ID_MemRead_CU,
													MemWrite 	=> ID_MemWrite_CU,
													Branch 		=> ID_Branch_CU,
													ALUSrc 		=> ID_ALUSrc_CU,
													ALUOp 		=> ID_ALUOp_CU 
												);
CU_MUX_1:			mux2to1 		GENERIC MAP (N => 8) 
									PORT MAP 	(
													SEL 		=> HAZ_En_Sel,        -- changed	
													X0 			=> SEVEN_ZEROS, 
													X1 			=> ID_CU_SIGNALS_PRE_HAZ,
													Y 			=> ID_CU_SIGNALS_POST_HAZ
												);
ID_CU_SIGNALS_PRE_HAZ(0) <= ID_RegWrite_CU;
ID_CU_SIGNALS_PRE_HAZ(2 DOWNTO 1) <= ID_MemtoReg_CU;
ID_CU_SIGNALS_PRE_HAZ(3) <= ID_MemRead_CU;
ID_CU_SIGNALS_PRE_HAZ(4) <= ID_MemWrite_CU;
--ID_CU_SIGNALS_PRE_HAZ(5) <= ID_Branch_CU;
ID_CU_SIGNALS_PRE_HAZ(5) <= ID_ALUSrc_CU;
ID_CU_SIGNALS_PRE_HAZ(7 DOWNTO 6) <= ID_ALUOp_CU;
ID_RegWrite <= ID_CU_SIGNALS_POST_HAZ(0);
ID_MemtoReg <= ID_CU_SIGNALS_POST_HAZ(2 DOWNTO 1);
ID_MemRead <= ID_CU_SIGNALS_POST_HAZ(3);
ID_MemWrite <= ID_CU_SIGNALS_POST_HAZ(4);

ID_ALUSrc <= ID_CU_SIGNALS_POST_HAZ(5);
ID_ALUOp <= ID_CU_SIGNALS_POST_HAZ(7 DOWNTO 6);

HAZ_UNIT: 		hazard_unit 		PORT MAP	(
													MemRead 	=> EX_MemRead,
													Instruction => ID_INSTRUCTION(24 DOWNTO 0),
													DestRegID	=> EX_INSTRUCTION_REG_WRITE_ADDR ,
													DestRegEX	=> MEM_INSTRUCTION_REG_WRITE_ADDR,
													DestRegMEM	=> WB_INSTRUCTION_REG_WRITE_ADDR ,
													Branch		=> ID_Branch_CU, 
													Equal		=> ID_Equal,     
													En_Sel		=> HAZ_En_Sel, 
													Rst_IF      => HAZ_Rst_IF,
													PCScr       => HAZ_PCScr
												); 
ID_COMPARATOR:  ID_Equal <= '1' WHEN ID_REG_DATA_1 = ID_REG_DATA_2 ELSE '0';
ID_EX_REG_1: 	register_1bit 		PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_RegWrite,
													Q 			=> EX_RegWrite
												);
ID_EX_REG_2: 	generic_register	GENERIC MAP (N => 2) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_MemtoReg,
													Q 			=> EX_MemtoReg
												);
ID_EX_REG_3: 	register_1bit		PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_MemRead,
													Q 			=> EX_MemRead
												);
ID_EX_REG_4: 	register_1bit 		PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_MemWrite,
													Q 			=> EX_MemWrite
												);
-- changed (missing branch reg)
ID_EX_REG_6: 	generic_register	GENERIC MAP (N => 2) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_ALUOp,
													Q 			=> EX_ALUOp
												);
ID_EX_REG_7: 	register_1bit 		PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_ALUSrc,
													Q 			=> EX_ALUSrc
												);
ID_EX_REG_8: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_PC_PLUS_IMM,   -- changed 
													Q 			=> EX_PC_PLUS_IMM    -- changed
												);
ID_EX_REG_9: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_REG_DATA_1,
													Q 			=> EX_REG_DATA_1
												);
ID_EX_REG_10: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_REG_DATA_2,
													Q 			=> EX_REG_DATA_2
												);
ID_EX_REG_11: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_IMMEDIATE,
													Q 			=> EX_IMMEDIATE
												);
ID_INSTRUCTION_ALU_CTRL	<= 	ID_INSTRUCTION(5 DOWNTO 4);
ID_EX_REG_12: 	generic_register	GENERIC MAP (N => 2)
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_INSTRUCTION_ALU_CTRL,
													Q 			=> EX_INSTRUCTION_ALU_CTRL
												);
ID_INSTRUCTION_REG_WRITE_ADDR 	<= 	ID_INSTRUCTION(11 DOWNTO 7);												
ID_EX_REG_13: 	generic_register	GENERIC MAP (N => 5) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_INSTRUCTION_REG_WRITE_ADDR,
													Q 			=> EX_INSTRUCTION_REG_WRITE_ADDR
												);
ID_EX_REG_14: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_PC_PLUS_4,
													Q 			=> EX_PC_PLUS_4
												);
ID_EX_REG_15: 	generic_register	GENERIC MAP (N => 5) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_INSTRUCTION(19 DOWNTO 15),
													Q 			=> EX_REG_SOURCE_1
												);
ID_EX_REG_16: 	generic_register	GENERIC MAP (N => 5) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> ID_INSTRUCTION(24 DOWNTO 20),
													Q 			=> EX_REG_SOURCE_2
												);													
												-- changed (missing shift_left_1, adder, signed / std_logic_vector conversions)  
EX_MUX1:		mux3to1 			GENERIC MAP (N => 32) 
									PORT MAP 	(
													SEL 		=> ForwardA,
													X0 			=> EX_FWD_DATA, 
													X1 			=> WB_REG_WRITE_DATA,
													X2 			=> EX_REG_DATA_1,
													Y 			=> EX_ALU_INPUT_1
												);	
EX_MUX2:		mux4to1 			GENERIC MAP (N => 32) 
									PORT MAP 	(
													SEL 		=> ForwardB,
													X0 			=> EX_FWD_DATA, 
													X1 			=> WB_REG_WRITE_DATA,
													X2 			=> EX_REG_DATA_2,
													X3 			=> EX_IMMEDIATE,
													Y 			=> EX_ALU_INPUT_2
												);	
												
EX_MUX3:		mux3to1 			GENERIC MAP (N => 32) 
									PORT MAP 	(
													SEL 		=> EX_FwdSel,
													X0 			=> MEM_DATA_RESULT, 
													X1 			=> MEM_PC_PLUS_IMM,
													X2 			=> MEM_PC_PLUS_4,
													Y 			=> EX_FWD_DATA
												);
												

EX_FWD: 		fwd_unit 			PORT MAP	(
													RegWrite_EXMEM => MEM_RegWrite, 
													RegWrite_MEMWB => WB_RegWrite, 
													ALUSrc => EX_ALUSrc, 
													PrevMemToReg => MEM_MemtoReg,
													SourceReg1 => EX_REG_SOURCE_1, 
													SourceReg2 => EX_REG_SOURCE_2, 
													DestReg_EXMEM => MEM_INSTRUCTION_REG_WRITE_ADDR, 
													DestReg_MEMWB => WB_INSTRUCTION_REG_WRITE_ADDR,
													FwdA => ForwardA,
													FwdB => ForwardB,
													DataSel => EX_FwdSel
												); 										
EX_ALU_INPUT_1_SIGNED <= SIGNED(EX_ALU_INPUT_1);
EX_ALU_INPUT_2_SIGNED <= SIGNED(EX_ALU_INPUT_2);
EX_ALU_RESULT <= STD_LOGIC_VECTOR(EX_ALU_RESULT_SIGNED);
EX_SFU_RESULT <= STD_LOGIC_VECTOR(EX_SFU_RESULT_SIGNED);
EX_ALU:			alu_b 				PORT MAP	(
													IN_A 		=> EX_ALU_INPUT_1_SIGNED, 
													IN_B 		=> EX_ALU_INPUT_2_SIGNED, 
													ALUOP 		=> EX_ALUOP_CU, 
												--	ZERO 		=> EX_ALU_ZERO, 
													OUTPUT 		=> EX_ALU_RESULT_SIGNED
												); 
EX_SFU:			sfu 				PORT MAP	(
													IN_A		=> EX_ALU_INPUT_1_SIGNED, 
													IN_B 		=> EX_ALU_INPUT_2_SIGNED,
													SFUOP 		=> EX_SFUOP_CU,
												--	ZERO 
													OUTPUT 		=> EX_SFU_RESULT_SIGNED
												); 
EX_OUT_MUX:		mux2to1 			GENERIC MAP (N => 32) 
									PORT MAP 	(
													SEL 		=> EX_OP_MUX_SEL_OUT,
													X0 			=> EX_ALU_RESULT, 
													X1 			=> EX_SFU_RESULT,
													Y 			=> EX_DATA_RESULT 
												);												

EX_ALU_CU:		alu_cu 				PORT MAP	(
													INSTR_MEM_OUT	=> EX_INSTRUCTION_ALU_CTRL,
													ALUOP_CU 		=> EX_ALUOp,
													ALUOP_OUT		=> EX_ALUOP_CU,
													SFUOP_OUT 		=> EX_SFUOP_CU,
													OP_MUX_SEL_OUT  => EX_OP_MUX_SEL_OUT
												);
EX_MEM_REG_1: 	register_1bit		PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> EX_RegWrite,
													Q 			=> MEM_RegWrite
												);
EX_MEM_REG_2: 	generic_register	GENERIC MAP (N => 2) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> EX_MemtoReg,
													Q 			=> MEM_MemtoReg
												);
-- changed (missing branch reg)
EX_MEM_REG_4: 	register_1bit		PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> EX_MemRead,
													Q 			=> MEM_MemRead
												);
EX_MEM_REG_5: 	register_1bit		PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> EX_MemWrite,
													Q 			=> MEM_MemWrite
												);
EX_MEM_REG_6: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> EX_PC_PLUS_IMM,
													Q 			=> MEM_PC_PLUS_IMM
												);
-- EX_MEM_REG_7: 	register_1bit		PORT MAP 	(
													-- CLK 		=> CLK,  
													-- ASYNC_RSTn 	=> ASYNC_RSTn,
													-- RSTn 		=> RSTn, 
													-- EN 			=> EN,
													-- D 			=> EX_ALU_ZERO,
													-- Q 			=> MEM_ALU_ZERO
												-- );
EX_MEM_REG_8: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> EX_DATA_RESULT,
													Q 			=> MEM_DATA_RESULT
												);
EX_MEM_REG_9: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> EX_REG_DATA_2,
													Q 			=> MEM_REG_DATA_2
												);
EX_MEM_REG_10: 	generic_register	GENERIC MAP (N => 5) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> EX_INSTRUCTION_REG_WRITE_ADDR,
													Q 			=> MEM_INSTRUCTION_REG_WRITE_ADDR
												);
EX_MEM_REG_11: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> EX_PC_PLUS_4,
													Q 			=> MEM_PC_PLUS_4
												);
-- changed (missing AND port branch/equal) 
ADDR_DATA 				<= 	UNSIGNED(MEM_DATA_RESULT);
--MEM_REG_DATA_2			<= 	MEM_DATA_IN ;
MEM_DATA_OUT 			<= 	MEM_REG_DATA_2;
MEM_DATA_MEM_DATA 		<= 	MEM_DATA_IN;
MEM_DATA_WRITE 			<= 	MEM_MemWrite;
MEM_DATA_READ 			<= 	MEM_MemRead;
MEM_WB_REG_1: 	register_1bit		PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> MEM_RegWrite,
													Q 			=> WB_RegWrite
												);
MEM_WB_REG_2: 	generic_register	GENERIC MAP (N => 2) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> MEM_MemtoReg,
													Q 			=> WB_MemtoReg
												);
MEM_WB_REG_3: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> MEM_DATA_MEM_DATA,
													Q 			=> WB_DATA_MEM_DATA
												);
MEM_WB_REG_4: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> MEM_DATA_RESULT,
													Q 			=> WB_DATA_RESULT
												);
MEM_WB_REG_5: 	generic_register	GENERIC MAP (N => 5) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> MEM_INSTRUCTION_REG_WRITE_ADDR,
													Q 			=> WB_INSTRUCTION_REG_WRITE_ADDR
												);
MEM_WB_REG_6: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> MEM_PC_PLUS_IMM,
													Q 			=> WB_PC_PLUS_IMM
												);
MEM_WB_REG_7: 	generic_register	GENERIC MAP (N => 32) 
									PORT MAP 	(
													CLK 		=> CLK,  
													ASYNC_RSTn 	=> ASYNC_RSTn,
													RSTn 		=> RSTn, 
													EN 			=> EN,
													D 			=> MEM_PC_PLUS_4,
													Q 			=> WB_PC_PLUS_4
												);
WB_MUX:			mux4to1 			GENERIC MAP (N => 32) 
									PORT MAP 	(
													SEL 		=> WB_MemtoReg,
													X0 			=> WB_DATA_RESULT, 
													X1 			=> WB_DATA_MEM_DATA,
													X2 			=> WB_PC_PLUS_IMM,
													X3 			=> WB_PC_PLUS_4,
													Y 			=> WB_REG_WRITE_DATA
												);											
END ARCHITECTURE Structural;

