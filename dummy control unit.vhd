library ieee;
use ieee.std_logic_1164.all;

entity CU is
port (start, zero, clk : in std_logic;
	clr, add, shift : out std_logic);
end CU;

architecture CU of CU is
type state is (s_idle, s_add, s_shift);
signal current_state : state := s_idle;
signal next_state : state;
begin
	process (current_state, start, zero)
	begin
		case current_state is
		when s_idle =>
			clr <= '1';
			add <= '0';
			shift <= '0';
			if start = '1' then
				next_state <= s_add;
			end if;
		when s_add =>
			clr <= '0';
			add <= '1';
			shift <= '0';
			next_state <= s_shift;
		when s_shift =>
			clr <= '0';
			add <= '0';
			shift <= '1';
			if zero = '1' then
				next_state <= s_idle;
			elsif zero = '0' then
				next_state <= s_add;
			end if;
		end case;
	end process;

	process
	begin
		wait until clk'event and clk = '1';
		current_state <= next_state;
	end process;
end CU;