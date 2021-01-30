LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--generic register
ENTITY shift_left_1 IS   
	GENERIC (N : INTEGER := 32);
	PORT 	( 
				D_IN   : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);  
				D_OUT  : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)
			); 
END ENTITY shift_left_1; 
 
ARCHITECTURE Behavioral OF shift_left_1 IS 
BEGIN  
	D_OUT <= D_IN(N-2 DOWNTO 0) & '0';
END ARCHITECTURE Behavioral; 