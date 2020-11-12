LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY multiplier IS
	GENERIC (Nb : INTEGER :=10);
	PORT (	INA, INB	: IN STD_LOGIC_VECTOR (Nb-1 DOWNTO 0);
			OUTPUT	:	OUT STD_LOGIC_VECTOR (2*Nb-1 DOWNTO 0)
		);
END ENTITY multiplier;

ARCHITECTURE beh OF multiplier IS
SIGNAL OUTPUT_sig : SIGNED (2*Nb-1 DOWNTO 0);
BEGIN

OUTPUT_sig <= signed(INA) * signed(INB);

OUTPUT <= std_logic_vector(OUTPUT_sig);

END ARCHITECTURE beh;
