LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY adder IS
	GENERIC (Nb : INTEGER :=10);
	PORT (	INA, INB	: IN STD_LOGIC_VECTOR (Nb-1 DOWNTO 0);
			OUTPUT	:	OUT STD_LOGIC_VECTOR (Nb-1 DOWNTO 0)
		);
END ENTITY adder;

ARCHITECTURE beh OF adder IS
SIGNAL OUTPUT_sig : SIGNED (Nb-1 DOWNTO 0);
BEGIN

OUTPUT_sig <= signed(INA) + signed(INB);

OUTPUT <= std_logic_vector(OUTPUT_sig);

END ARCHITECTURE beh;
