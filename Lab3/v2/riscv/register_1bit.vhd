LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--generic register
ENTITY register_1bit IS   
	PORT 	(	CLK, ASYNC_RSTn, RSTn, EN : IN  STD_LOGIC;  
				D   : IN STD_LOGIC;  
				Q   : OUT STD_LOGIC
			); 
END ENTITY register_1bit; 
 
ARCHITECTURE Behavioral OF register_1bit IS 
BEGIN  
	--PRIORITY ORDER: ASYNC_RSTn, RST, EN
	PROCESS (CLK, ASYNC_RSTn)  
	BEGIN   
		IF (ASYNC_RSTn = '0') THEN --reset asincrono
			Q <= '0'; -- valore di reset
		ELSIF (CLK'EVENT AND CLK = '1') THEN   --fronte di salita
			IF ( RSTn = '0' ) THEN --reset sincrono
				Q <= '0'; -- valore di reset
			ELSIF ( EN = '1' ) THEN
				Q <= D;   
			END IF;
		END IF;  
	END PROCESS; 
END ARCHITECTURE Behavioral; 
 
