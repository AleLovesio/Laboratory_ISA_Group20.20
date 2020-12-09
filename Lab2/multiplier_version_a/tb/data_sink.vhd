library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_sink is
  port (
    CLK   : in std_logic;
    FP_Z   : in std_logic_vector(31 downto 0);
	maker_end : in std_logic);
end data_sink;

architecture beh of data_sink is

begin  -- beh

  process (CLK)
    file res_fp : text open WRITE_MODE is "./fp_prod_sim.hex";
    variable line_out : line; 
	variable initial_delay : integer := 1;
	variable pipe_stages : integer := 4;
	variable final_delay : integer := 4;

  begin  -- process
    if CLK'event and CLK = '1' then  -- rising clock edge
		if (initial_delay > 0) then
	  		initial_delay := initial_delay - 1;
		elsif (pipe_stages > 0) then
	  		pipe_stages := pipe_stages - 1;
    	elsif (final_delay > 0) then
        	hwrite(line_out, FP_Z);
        	writeline(res_fp, line_out);
			if maker_end = '1' then
				final_delay := final_delay - 1;
			end if;
     	end if;
    end if;
  end process;

end beh;
