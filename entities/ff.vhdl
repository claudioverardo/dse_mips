-- FLIP-FLOP D

library ieee;
use ieee.std_logic_1164.all;

entity ff is
	port(	D:  	in	std_logic;
			clk: 	in	std_logic;
			rst:	in 	std_logic;
			Q:		out	std_logic;
			Qn:		out std_logic );
end ff;

architecture behav of ff is

begin
		
	process (clk, rst)
	begin
		if (rst = '1') then
			Q  <= '0';
			Qn <= '1';
		elsif (clk 'event and clk = '1') then
			Q  <= D;
			Qn <= not (D);
		end if;
	end process;

end behav;