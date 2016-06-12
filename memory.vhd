library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
    Port ( address : in  std_logic_vector (31 downto 0);
		dataIn : in std_logic_vector(31 downto 0);
		memWrite, memRead : in std_logic;
		clk : in std_logic;         
		dataOut : out  std_logic_vector (31 downto 0));
end Memory;


architecture Memory of Memory is

type mem is array (0 to 2**22) of std_logic_vector(7 downto 0);
signal memContent: mem;
begin
	process (address, dataIn, memRead, memWrite)
	begin
		
		if(to_integer(unsigned(address))>= 0 and to_integer(unsigned(address)) <= 4194300) then
			if(memRead = '1' and memWrite ='0') then
				dataOut(31 downto 24) <= memContent(to_integer(unsigned(address)));
				dataOut(23 downto 16) <= memContent(to_integer(unsigned(address))+1);
				dataOut(15 downto 8) <= memContent(to_integer(unsigned(address))+2);
				dataOut(7 downto 0) <= memContent(to_integer(unsigned(address))+3);
	
			elsif (memRead = '0' and memWrite = '1') then
				memContent(to_integer(unsigned(address))) <= dataIn(31 downto 24);
				memContent(to_integer(unsigned(address))+1) <= dataIn(23 downto 16);
				memContent(to_integer(unsigned(address))+2) <= dataIn(15 downto 8);
				memContent(to_integer(unsigned(address))+3) <= dataIn(7 downto 0);				
			end if;
		end if;

	end process;	

end Memory;
