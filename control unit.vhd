library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
	port (opCode : in std_logic_vector(5 downto 0);
		clk : in std_logic;
		pCWriteCond : out std_logic;
		bne  : out std_logic;
		pCWrite : out std_logic;
		iOrD : out std_logic;
		iRWrite : out std_logic;
		pCSource : out std_logic_vector(1 downto 0);
		aluOP : out std_logic_vector(1 downto 0);
		aluSrcB : out std_logic_vector(1 downto 0);
		aluSrcA : out std_logic;
		regWrite : out std_logic;
		regDst : out std_logic;
		memRead : out std_logic;
		memWrite : out std_logic;
		memToReg : out std_logic);
end ControlUnit;

architecture ControlUnit of ControlUnit is
type state is (idle, fetch, decode, execute, memory, writeBack);
signal currentState : state := idle;
signal nextState : state:= idle;
begin
	process (currentState)
	begin
		case currentState is
		when idle =>
			nextState <= fetch;
		when fetch =>
			regWrite <= '0';
			pCWriteCond <= '0';
			bne <= '0';

			memWrite <= '0';
			memRead <= '1';
			iRWrite <= '1';
			iOrD <= '0';	--select the PC as the source of the address
			aluSrcA <= '0'; --(sending thePC to the ALU
			aluSrcB <= "01";--sending 4 to the ALU
			aluOP <= "00";	--ALU add
			pCSource <= "00";--store the incremented instruction address back into the PC
			pCWrite <= '1';
			nextState <= decode;
		when decode =>
			memWrite <= '0';
			memRead <= '0';
			pCWrite <= '0';

			aluSrcA <= '0'; --PC is sent to the ALU
			aluSrcB <= "11";--sign-extended and shifted offset field is sent to the ALU
			aluOP <= "00"; 	--ALU add
			 
			nextState <= execute;
		when execute =>
			memWrite <= '0';
			memRead <= '0';
			if opCode = "100011" or opCode = "101011" then --lw or sw
				aluSrcA <= '1'; --first ALU input is register A
				aluSrcB <= "10";--output of the sign extension unit is used for the second ALU input
				aluOP <= "00";	-- ALU add
				nextState <= memory;
			elsif opCOde = "000000" then
				aluSrcA <= '1'; --first ALU input is register A
				aluSrcB <= "00";--second ALU input is register B
				aluOP <= "10";	-- funct code
				nextState <= memory;
			elsif opCode <= "000100" then --beq
				aluSrcA <= '1'; --first ALU input is register A
				aluSrcB <= "00";--second ALU input is register B
				aluOP <= "01";	-- ALU subtract
				pCWriteCond <= '1';
				pCSource <= "01";
				nextState <= fetch;

			elsif opCode <= "000101" then --bnq
				aluSrcA <= '1'; --first ALU input is register A
				aluSrcB <= "00";--second ALU input is register B
				aluOP <= "01";	-- ALU subtract
				bne <= '1';
				pCSource <= "01";
				nextState <= fetch;
			elsif opCode = "000010" then --jump
				pCSource <= "10"; -- PC <= jump address
				pCWrite <= '1';
				nextState <= fetch;
			end if;
			
		when memory =>
			pCWrite <= '0';
			pCWriteCond <= '0';
			bne <= '0';
			if opCode = "100011" then --lw
				memRead <= '1';
				memWrite <= '0';
				iOrD <= '1';
				nextState <= writeBack;
			elsif opCode = "101011" then --sw
				memRead <= '0';
				memWrite <= '1' after 2 ns;
				iOrD <= '1';
				nextState <= fetch;
			elsif opCode = "000000" then
				regDst <= '1';
				regWrite <= '1';
				memToReg <= '0';
				nextState <= fetch;
			end if;
		when writeBack =>
			memWrite <= '0';
			memRead <= '0';
			if opCode = "100011" then --lw
				memToReg <= '1';
				regWrite <= '1';
				regDst <= '0';
			end if;
			nextState <= fetch;
		end case;
	end process;

	process
	begin		
		wait until clk'event and clk = '1';
		currentState <= nextState;
	end process;
end ControlUnit;
