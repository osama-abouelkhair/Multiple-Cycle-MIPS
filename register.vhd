
library ieee;
use ieee.std_logic_1164.ALL;

entity Reg is
    Port ( input : in  std_logic_vector (31 downto 0);
           en, clk : in  std_logic;
           output : out  std_logic_vector (31 downto 0));
end Reg;

architecture Reg of Reg is

begin

process(clk, input, en)
  begin
     if rising_edge(clk) then
	if en = '1' then
		output <= input;
	end if;
    end	if;  
  end process;
  
end Reg;


