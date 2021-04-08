LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY full_adder IS
   PORT( 
      A, B, CIN 	: IN     std_logic;
      SUM, COUT 	: OUT    std_logic
   );

END ENTITY full_adder;

ARCHITECTURE Behavioral OF full_adder IS
	SIGNAL X : STD_LOGIC;
BEGIN
	X <= A XOR B;
	SUM <= CIN XOR X;
	COUT <= ((NOT X) AND B) OR (X AND CIN);
END ARCHITECTURE Behavioral;
