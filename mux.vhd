

library ieee;
use ieee.std_logic_1164.all;

entity Mux is
port(src0, src1, src2, src3 : in std_logic_vector(31 downto 0);
	sel0 : in std_logic;
	sel1 : in std_logic;
	dataOut : out std_logic_vector(31 downto 0));
end Mux;

architecture Mux of Mux is
begin
	dataOut <= src0 when sel1 = '0' and sel0 = '0' else
		src1 when sel1 = '0' and sel0 = '1' else
		src2 when sel1 = '1' and sel0 = '0' else
			src3;
end Mux;
