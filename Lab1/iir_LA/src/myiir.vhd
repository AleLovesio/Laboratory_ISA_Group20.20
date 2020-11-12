LIBRARY ieee;
USE ieee.std_logic_1164.all;
--non pipelined and non retimed version of the lookahead iir
ENTITY myiir IS
	--GENERIC (Nb : INTEGER :=10);
	PORT (	CLK, RST_n, VIN	: IN STD_LOGIC;
			DIN, E2, E3, F0, F1, F2, F3:	IN STD_LOGIC_VECTOR (13 DOWNTO 0);
			VOUT	: OUT STD_LOGIC;
			DOUT	: OUT STD_LOGIC_VECTOR (13 DOWNTO 0)
		);
END ENTITY myiir;

ARCHITECTURE dolly OF myiir IS

--needed components
COMPONENT multiplier IS
	GENERIC (Nb : INTEGER :=10);
	PORT (	INA, INB	: IN STD_LOGIC_VECTOR (Nb-1 DOWNTO 0);
			OUTPUT	:	OUT STD_LOGIC_VECTOR (2*Nb-1 DOWNTO 0)
		);
END COMPONENT multiplier;

COMPONENT adder IS
	GENERIC (Nb : INTEGER :=10);
	PORT (	INA, INB	: IN STD_LOGIC_VECTOR (Nb-1 DOWNTO 0);
			OUTPUT	:	OUT STD_LOGIC_VECTOR (Nb-1 DOWNTO 0)
		);
END COMPONENT adder;

--needed internal signals
SIGNAL IN_reg, E2_reg, E3_reg, F0_reg, F1_reg, F2_reg, F3_reg	: STD_LOGIC_VECTOR (10 DOWNTO 0);
SIGNAL int_reg_0d, int_reg_1d, int_reg_2d, int_reg_3d	: STD_LOGIC_VECTOR (10 DOWNTO 0);
SIGNAL int_add_E0, int_add_E1, int_add_E2	: STD_LOGIC_VECTOR (10 DOWNTO 0);
SIGNAL int_mul_E2, int_mul_E3	: STD_LOGIC_VECTOR (21 DOWNTO 0);
SIGNAL int_add_F0, int_add_F1, int_add_F2	: STD_LOGIC_VECTOR (10 DOWNTO 0);
SIGNAL int_mul_F0, int_mul_F1, int_mul_F2, int_mul_F3	: STD_LOGIC_VECTOR (21 DOWNTO 0);
SIGNAL VIN_reg : STD_LOGIC;
--SIGNAL DOUT_int, DIN_int,  : INTEGER;

BEGIN

--process to sample the inputs
IN_proc:	PROCESS (CLK, RST_n)
			BEGIN
			IF (RST_n = '0') THEN
				IN_reg <= (others=>'0');
				E2_reg <= (others=>'0');
				E3_reg <= (others=>'0');
				F0_reg <= (others=>'0');
				F1_reg <= (others=>'0');
				F2_reg <= (others=>'0');
				F3_reg <= (others=>'0');
			ELSIF rising_edge(CLK) THEN
				VIN_reg <= VIN;
				IF VIN = '1' THEN
					IN_reg <= DIN(9 DOWNTO 0)&'0';
					E2_reg <= E2(10 DOWNTO 0);
					E3_reg <= E3(10 DOWNTO 0);
					F0_reg <= F0(10 DOWNTO 0);
					F1_reg <= F1(10 DOWNTO 0);
					F2_reg <= F2(10 DOWNTO 0);
					F3_reg <= F3(10 DOWNTO 0);
				END IF;
			END IF;
			END PROCESS IN_proc;

--filter structure

--process to istantiate the needed registers
proc_0d:	PROCESS (CLK)
			BEGIN
			IF (RST_n = '0') THEN
				int_reg_1d <= (others=>'0');
			ELSIF rising_edge(CLK) THEN
				IF VIN = '1' THEN
					int_reg_1d <= int_reg_0d;
				END IF;
			END IF;
			END PROCESS proc_0d;

proc_1d:	PROCESS (CLK)
			BEGIN
			IF (RST_n = '0') THEN
				int_reg_2d <= (others=>'0');
			ELSIF rising_edge(CLK) THEN
				IF VIN = '1' THEN
					int_reg_2d <= int_reg_1d;
				END IF;
			END IF;
			END PROCESS proc_1d;

proc_2d:	PROCESS (CLK)
			BEGIN
			IF (RST_n = '0') THEN
				int_reg_3d <= (others=>'0');
			ELSIF rising_edge(CLK) THEN
				IF VIN = '1' THEN
					int_reg_3d <= int_reg_2d;
				END IF;
			END IF;
			END PROCESS proc_2d;

--adders and multipliers istantiation
add_E0:	adder GENERIC MAP (11) PORT MAP(INA=>IN_reg, INB=>int_add_E1, OUTPUT=>int_add_E0);
add_E2:	adder GENERIC MAP (11) PORT MAP(INA=>int_mul_E2(20 DOWNTO 10), INB=>int_mul_E3(20 DOWNTO 10), OUTPUT=>int_add_E2);
mul_E2:	multiplier GENERIC MAP (11) PORT MAP(INA=>int_reg_2d, INB=>E2_reg, OUTPUT=>int_mul_E2);
mul_E3:	multiplier GENERIC MAP (11) PORT MAP(INA=>int_reg_3d, INB=>E3_reg, OUTPUT=>int_mul_E3);
add_F0:	adder GENERIC MAP (11) PORT MAP(INA=>int_mul_F0(20 DOWNTO 10), INB=>int_add_F1, OUTPUT=>int_add_F0);
add_F1:	adder GENERIC MAP (11) PORT MAP(INA=>int_mul_F1(20 DOWNTO 10), INB=>int_add_F2, OUTPUT=>int_add_F1);
add_F2:	adder GENERIC MAP (11) PORT MAP(INA=>int_mul_F2(20 DOWNTO 10), INB=>int_mul_F3(20 DOWNTO 10), OUTPUT=>int_add_F2);
mul_F0:	multiplier GENERIC MAP (11) PORT MAP(INA=>int_reg_0d, INB=>F0_reg, OUTPUT=>int_mul_F0);
mul_F1:	multiplier GENERIC MAP (11) PORT MAP(INA=>int_reg_1d, INB=>F1_reg, OUTPUT=>int_mul_F1);
mul_F2:	multiplier GENERIC MAP (11) PORT MAP(INA=>int_reg_2d, INB=>F2_reg, OUTPUT=>int_mul_F2);
mul_F3:	multiplier GENERIC MAP (11) PORT MAP(INA=>int_reg_3d, INB=>F3_reg, OUTPUT=>int_mul_F3);

int_reg_0d <= int_add_E0;
int_add_E1 <= int_add_E2;


--process to sample the output
OUT_proc:	PROCESS (CLK)
			BEGIN
			IF (RST_n = '0') THEN
				DOUT <= (others=>'0');
				VOUT <= '0';
			ELSIF rising_edge(CLK) THEN
				IF VIN_reg = '1' THEN
					DOUT <= int_add_F0(10)&int_add_F0(10)&int_add_F0(10)&int_add_F0(10)&int_add_F0(10 DOWNTO 1);
				END IF;
				VOUT <= VIN_reg;
			END IF;
			END PROCESS OUT_proc;
--DIN_int <= to_integer(signed(DIN));
--DOUT_int <= to_integer(signed(DOUT));
END ARCHITECTURE dolly;
