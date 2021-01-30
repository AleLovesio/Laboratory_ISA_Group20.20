library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is
  port (
	END_SIM 	: in std_logic;
    CLK, RSTn     : out std_logic);
end clk_gen;

architecture beh of clk_gen is

  constant Ts : time := 10 ns;
  
  signal CLK_i : std_logic;
  signal RSTn_i : std_logic := '0';
  
begin  -- beh
	
  --initial reset
  RSTn <= RSTn_i;
  RSTn_i <= '1' after 3*Ts/2;
	
  process
  begin  -- process
    if (CLK_i = 'U') then
      CLK_i <= '0';
    else
      CLK_i <= not(CLK_i);
    end if;
    wait for Ts/2;
  end process;

  --CLK <= CLK_i and not(END_SIM);
  CLK <= CLK_i;

end beh;
