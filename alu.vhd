library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;

entity Alu is
	port (srcA, srcB : in std_logic_vector(31 downto 0);
		operation : in std_logic_vector(2 downto 0);
		result : out std_logic_vector(31 downto 0);
		zero : out std_logic);

end Alu;


architecture Alu of Alu is 

begin

	result <= srcA and srcB when operation = "000" else
		srcA or srcB when operation = "001" else
		std_logic_vector(to_signed
			(to_integer(signed(srcA)) + 
			to_integer(signed(srcB)), 32)) when operation =  "010" else
		std_logic_vector(to_signed
			(to_integer(signed(srcA)) - 
			to_integer(signed(srcB)), 32)) when operation = "110" else
		X"00000000" ;
	
	zero <= '1' when srcA = srcB else
		'0';
end Alu;


