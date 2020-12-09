library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker is  
  port (
    CLK     : in  std_logic;
    FP_A    : out std_logic_vector(31 downto 0);
    FP_B    : out std_logic_vector(31 downto 0);
    END_SIM : out std_logic;
	maker_end : out std_logic);
end data_maker;

architecture beh of data_maker is

  constant tco : time := 1 ns;

  signal sEndSim : std_logic;
  signal END_SIM_i : std_logic_vector(0 to 10) := (others => '0');  

begin  -- beh

  process (CLK)
    file fp_in : text open READ_MODE is "../../doc/fp_samples.hex";
    variable line_in : line;
    variable x : std_logic_vector(31 downto 0);
	variable start : integer := 1;
  begin  -- process
    if start  = 1 then                 -- reset at start
      	FP_A <= (others => '0') after tco; 
		FP_B <= (others => '0') after tco;      
      	sEndSim <= '0' after tco;
		maker_end <= '0' after tco;
		start := 0;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      	if not endfile(fp_in) then
        	readline(fp_in, line_in);
        	hread(line_in, x);
        	FP_A <= x after tco;
			FP_B <= x after tco;
        	sEndSim <= '0' after tco;
      	else
        	sEndSim <= '1' after tco;
			maker_end <= '1' after tco;
      	end if;
    end if;
  end process;
  process (CLK)
  begin  -- process
    if CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim after tco;
      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9) after tco;
    end if;
  end process;

  END_SIM <= END_SIM_i(10);  

end beh;