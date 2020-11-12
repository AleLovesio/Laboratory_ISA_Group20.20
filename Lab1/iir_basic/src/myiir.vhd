LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY myiir IS
	--GENERIC (Nb : INTEGER :=10);
	PORT (	CLK, RST_n, VIN	: IN STD_LOGIC;
			DIN, A1, A2, B0, B1, B2 :	IN STD_LOGIC_VECTOR (13 DOWNTO 0);
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
SIGNAL IN_reg, A1_reg, A2_reg, B0_reg, B1_reg, B2_reg	: STD_LOGIC_VECTOR (9 DOWNTO 0);
SIGNAL int_reg_0d, int_reg_1d, int_reg_2d	: STD_LOGIC_VECTOR (9 DOWNTO 0);
SIGNAL int_add_A0, int_add_A1	: STD_LOGIC_VECTOR (9 DOWNTO 0);
SIGNAL int_mul_A1, int_mul_A2	: STD_LOGIC_VECTOR (19 DOWNTO 0);
SIGNAL int_add_B0, int_add_B1	: STD_LOGIC_VECTOR (9 DOWNTO 0);
SIGNAL int_mul_B0, int_mul_B1, int_mul_B2	: STD_LOGIC_VECTOR (19 DOWNTO 0);
SIGNAL VIN_reg : STD_LOGIC;
--SIGNAL DOUT_int, DIN_int,  : INTEGER;

BEGIN

--process to sample the inputs
IN_proc:	PROCESS (CLK, RST_n)
			BEGIN
			IF (RST_n = '0') THEN
				IN_reg <= (others=>'0');
				A1_reg <= (others=>'0');
				A2_reg <= (others=>'0');
				B0_reg <= (others=>'0');
				B1_reg <= (others=>'0');
				B2_reg <= (others=>'0');
			ELSIF rising_edge(CLK) THEN
				VIN_reg <= VIN;
				IF VIN = '1' THEN
					IN_reg <= DIN(9 DOWNTO 0);
					A1_reg <= A1(9 DOWNTO 0);
					A2_reg <= A2(9 DOWNTO 0);
					B0_reg <= B0(9 DOWNTO 0);
					B1_reg <= B1(9 DOWNTO 0);
					B2_reg <= B2(9 DOWNTO 0);
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

--adders and multipliers istantiation
add_A0:	adder GENERIC MAP (10) PORT MAP(INA=>IN_reg, INB=>int_add_A1, OUTPUT=>int_add_A0);
add_A1:	adder GENERIC MAP (10) PORT MAP(INA=>int_mul_A1(18 DOWNTO 9), INB=>int_mul_A2(18 DOWNTO 9), OUTPUT=>int_add_A1);
mul_A1:	multiplier GENERIC MAP (10) PORT MAP(INA=>int_reg_1d, INB=>A1_reg, OUTPUT=>int_mul_A1);
mul_A2:	multiplier GENERIC MAP (10) PORT MAP(INA=>int_reg_2d, INB=>A2_reg, OUTPUT=>int_mul_A2);
add_B0:	adder GENERIC MAP (10) PORT MAP(INA=>int_mul_B0(18 DOWNTO 9), INB=>int_add_B1, OUTPUT=>int_add_B0);
add_B1:	adder GENERIC MAP (10) PORT MAP(INA=>int_mul_B1(18 DOWNTO 9), INB=>int_mul_B2(18 DOWNTO 9), OUTPUT=>int_add_B1);
mul_B0:	multiplier GENERIC MAP (10) PORT MAP(INA=>int_reg_0d, INB=>B0_reg, OUTPUT=>int_mul_B0);
mul_B1:	multiplier GENERIC MAP (10) PORT MAP(INA=>int_reg_1d, INB=>B1_reg, OUTPUT=>int_mul_B1);
mul_B2:	multiplier GENERIC MAP (10) PORT MAP(INA=>int_reg_2d, INB=>B2_reg, OUTPUT=>int_mul_B2);

int_reg_0d <= int_add_A0;


--process to sample the output
OUT_proc:	PROCESS (CLK)
			BEGIN
			IF (RST_n = '0') THEN
				DOUT <= (others=>'0');
				VOUT <= '0';
			ELSIF rising_edge(CLK) THEN
				IF VIN_reg = '1' THEN
					DOUT <= int_add_B0(9)&int_add_B0(9)&int_add_B0(9)&int_add_B0(9)&int_add_B0;
				END IF;
				VOUT <= VIN_reg;
			END IF;
			END PROCESS OUT_proc;
--DIN_int <= to_integer(signed(DIN));
--DOUT_int <= to_integer(signed(DOUT));
END ARCHITECTURE dolly;
