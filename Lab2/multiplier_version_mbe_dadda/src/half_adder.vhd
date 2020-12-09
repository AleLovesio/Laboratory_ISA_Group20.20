LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY half_adder IS
   PORT( 
      A, B  		: IN     std_logic;
      SUM, COUT 	: OUT    std_logic
   );

END ENTITY half_adder;

ARCHITECTURE Behavioral OF half_adder IS
BEGIN
	SUM <= A XOR B;
	COUT <= A AND B;
END ARCHITECTURE Behavioral;
