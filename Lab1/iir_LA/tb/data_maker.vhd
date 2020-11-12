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
    RST_n   : in  std_logic;
    VOUT    : out std_logic;
    DOUT    : out std_logic_vector(13 downto 0);
    E2      : out std_logic_vector(13 downto 0);
    E3      : out std_logic_vector(13 downto 0);
    F0      : out std_logic_vector(13 downto 0);
    F1     : out std_logic_vector(13 downto 0);
	F2     : out std_logic_vector(13 downto 0);
	F3     : out std_logic_vector(13 downto 0);
    END_SIM : out std_logic);
end data_maker;

architecture beh of data_maker is

  constant tco : time := 1 ns;

  signal sEndSim : std_logic;
  signal END_SIM_i : std_logic_vector(0 to 10);  

begin  -- beh
  
  E2 <= conv_std_logic_vector(-32,14);
  E3 <= conv_std_logic_vector(-10,14);
  F0 <= conv_std_logic_vector(52,14);
  F1 <= conv_std_logic_vector(113,14);  
  F2 <= conv_std_logic_vector(71,14);
  F3 <= conv_std_logic_vector(9,14);
  process (CLK, RST_n)
    file fp_in : text open READ_MODE is "../doc/samples.txt";
    variable line_in : line;
    variable x : integer;
	variable clk_counter : integer := 0;
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      DOUT <= (others => '0') after tco;      
      VOUT <= '0' after tco;
      sEndSim <= '0' after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
	  clk_counter := clk_counter + 1;
      if not endfile(fp_in) then 
		if ((clk_counter mod 25) /= 0) and ((clk_counter mod 25) /= 1) then --adding some pauses every 25 clock cycles for 2 clock cycles
        	readline(fp_in, line_in);
        	read(line_in, x);
        	DOUT <= conv_std_logic_vector(x, 14) after tco;
        	VOUT <= '1' after tco;
        	sEndSim <= '0' after tco;
		else
			VOUT <= '0' after tco;
		end if;
      else
        VOUT <= '0' after tco;        
        sEndSim <= '1' after tco;
      end if;
    end if;
  end process;
  process (CLK, RST_n)
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim after tco;
      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9) after tco;
    end if;
  end process;

  END_SIM <= END_SIM_i(10);  

end beh;
