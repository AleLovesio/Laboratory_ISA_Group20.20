LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--generic register
ENTITY generic_register IS   
	GENERIC (N : INTEGER := 32);
	PORT 	(	CLK, ASYNC_RSTn, RSTn, EN : IN  STD_LOGIC;  
				D   : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);  
				Q   : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)
			); 
END ENTITY generic_register; 
 
ARCHITECTURE Behavioral OF generic_register IS 
BEGIN  
	--PRIORITY ORDER: ASYNC_RSTn, RST, EN
	PROCESS (CLK, ASYNC_RSTn)  
	BEGIN   
		IF (ASYNC_RSTn = '0') THEN --reset asincrono
			Q <= (OTHERS => '0'); -- valore di reset
		ELSIF (CLK'EVENT AND CLK = '1') THEN   --fronte di salita
			IF ( RSTn = '0' ) THEN --reset sincrono
				Q <= (OTHERS =>'0'); -- valore di reset
			ELSIF ( EN = '1' ) THEN
				Q <= D;   
			END IF;
		END IF;  
	END PROCESS; 
END ARCHITECTURE Behavioral; 
 
