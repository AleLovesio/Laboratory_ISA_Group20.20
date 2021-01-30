LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY sfu IS
	PORT (
			IN_A, IN_B : IN SIGNED (31 DOWNTO 0); --IN_B currently not used
			SFUOP : IN STD_LOGIC; -- 0: no op, 1: abs
			ZERO : OUT STD_LOGIC;
			OUTPUT : OUT SIGNED (31 DOWNTO 0)
		); 
END sfu;

ARCHITECTURE UltraBehavioral OF sfu IS
COMPONENT abs_val IS
	GENERIC (N : INTEGER := 32);
	PORT (
		INPUT : IN SIGNED (N-1 DOWNTO 0);
		OUTPUT : OUT SIGNED (N-1 DOWNTO 0)); 
END COMPONENT abs_val;
FOR ALL: abs_val USE ENTITY work.abs_val(UltraBehavioral);
SIGNAL OUTPUT_ABS, OUTPUT_INT : SIGNED (31 DOWNTO 0);
SIGNAL ZERO_INT : STD_LOGIC;
BEGIN  

abs_v:		abs_val 		GENERIC MAP (N => 32) 
							PORT MAP 	(
											INPUT 	=> IN_A,  
											OUTPUT 	=> OUTPUT_ABS
										);
	
	OUTPUT_INT <= OUTPUT_ABS WHEN SFUOP = '1' ELSE (OTHERS => '0');
	ZERO_INT <= '1' WHEN OUTPUT_INT = (31 DOWNTO 0 => '0') ELSE '0';
	ZERO <= ZERO_INT WHEN SFUOP /= '0' ELSE '0';
	OUTPUT <= OUTPUT_INT;
END UltraBehavioral;

ARCHITECTURE Behavioral OF sfu IS
COMPONENT abs_val IS
	GENERIC (N : INTEGER := 32);
	PORT (
		INPUT : IN SIGNED (N-1 DOWNTO 0);
		OUTPUT : OUT SIGNED (N-1 DOWNTO 0)); 
END COMPONENT abs_val;
FOR ALL: abs_val USE ENTITY work.abs_val(Behavioral);
SIGNAL OUTPUT_ABS, OUTPUT_INT : SIGNED (31 DOWNTO 0);
SIGNAL ZERO_INT : STD_LOGIC;
BEGIN  

abs_v:		abs_val 		GENERIC MAP (N => 32) 
							PORT MAP 	(
											INPUT 	=> IN_A,  
											OUTPUT 	=> OUTPUT_ABS
										);
	
	OUTPUT_INT <= OUTPUT_ABS WHEN SFUOP = '1' ELSE (OTHERS => '0');
	ZERO_INT <= '1' WHEN OUTPUT_INT = (31 DOWNTO 0 => '0') ELSE '0';
	ZERO <= ZERO_INT WHEN SFUOP /= '0' ELSE '0';
	OUTPUT <= OUTPUT_INT;
END Behavioral;

ARCHITECTURE Behavioral_codelike OF sfu IS
COMPONENT abs_val IS
	GENERIC (N : INTEGER := 32);
	PORT (
		INPUT : IN SIGNED (N-1 DOWNTO 0);
		OUTPUT : OUT SIGNED (N-1 DOWNTO 0)); 
END COMPONENT abs_val;
FOR ALL: abs_val USE ENTITY work.abs_val(Behavioral_codelike);
SIGNAL OUTPUT_ABS, OUTPUT_INT : SIGNED (31 DOWNTO 0);
SIGNAL ZERO_INT : STD_LOGIC;
BEGIN  

abs_v:		abs_val 		GENERIC MAP (N => 32) 
							PORT MAP 	(
											INPUT 	=> IN_A,  
											OUTPUT 	=> OUTPUT_ABS
										);
	
	OUTPUT_INT <= OUTPUT_ABS WHEN SFUOP = '1' ELSE (OTHERS => '0');
	ZERO_INT <= '1' WHEN OUTPUT_INT = (31 DOWNTO 0 => '0') ELSE '0';
	ZERO <= ZERO_INT WHEN SFUOP /= '0' ELSE '0';
	OUTPUT <= OUTPUT_INT;
END Behavioral_codelike;
