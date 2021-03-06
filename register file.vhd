
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegFile is
	port(regA, regB, regC : in std_logic_vector(4 downto 0);
		writeData : in std_logic_vector(31 downto 0);
		regWrite, clk : in std_logic;
		dataOutA, dataOutB: out std_logic_vector(31 downto 0));
end RegFile;

architecture RegFile of RegFile is
	type regCon is array(0 to 31) of std_logic_vector(31 downto 0);
	signal registers : regCon;
begin
	process (regA, regB, regC, writeData, regWrite) is
	begin
		
			dataOutA <= registers(to_integer(unsigned(regA)));
			dataOutB <= registers(to_integer(unsigned(regB)));
			if regWrite = '1' then
				registers(to_integer(unsigned(regC))) <= writeData;
			end if;
		

	end process;
end RegFile;



