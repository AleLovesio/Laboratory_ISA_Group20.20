LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux4to1 IS
	GENERIC (N : INTEGER := 1); -- MUX X PARALLELISM
	PORT 	(	
				SEL		: IN STD_LOGIC_VECTOR; -- SELECTOR
				X0, X1, X2, X3	:IN STD_LOGIC_VECTOR (N-1 DOWNTO 0); -- INPUTS
				Y		: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0) -- OUTPUT
			);
END ENTITY mux4to1;

ARCHITECTURE Behavioral OF mux4to1 IS
BEGIN
	Y 	<= 	X0 WHEN SEL = "00" ELSE 
			X1 WHEN SEL = "01" ELSE
			X2 WHEN SEL = "10" ELSE
			X3;
END ARCHITECTURE Behavioral;