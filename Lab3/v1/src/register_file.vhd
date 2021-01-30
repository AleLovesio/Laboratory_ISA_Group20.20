LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--riscv register file
ENTITY register_file IS   
	PORT 	(	WR_EN, CLK, RSTn, ASYNC_RSTn : IN  STD_LOGIC;  
				ADDR_READ_1, ADDR_READ_2, ADDR_WRITE : IN STD_LOGIC_VECTOR (4 DOWNTO 0);  
				DATA_WRITE : IN STD_LOGIC_VECTOR (31 DOWNTO 0); 
				DATA_READ_1, DATA_READ_2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			); 
END ENTITY register_file; 
 
ARCHITECTURE Behavioral OF register_file IS 
	TYPE REG_ARRAY IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL REG : REG_ARRAY;
BEGIN  
p1:	PROCESS (CLK)  
	BEGIN   
		IF (ASYNC_RSTn = '0') THEN --reset asincrono
			REG <= (OTHERS=>(OTHERS => '0')); -- valore di reset
		ELSIF (falling_edge(CLK)) THEN   --fronte di discesa
			IF ( RSTn = '0' ) THEN --reset sincrono
				REG <= (OTHERS=>(OTHERS => '0')); -- valore di reset
			ELSIF ( WR_EN = '1' ) THEN
				REG(TO_INTEGER(UNSIGNED(ADDR_WRITE))) <= DATA_WRITE;   
			END IF;
		END IF;  


	END PROCESS; 

	DATA_READ_1 <= REG(TO_INTEGER(UNSIGNED(ADDR_READ_1)));
	DATA_READ_2 <= REG(TO_INTEGER(UNSIGNED(ADDR_READ_2)));
END ARCHITECTURE Behavioral; 
 
