-- N bit REGISTER

library ieee;
use ieee.std_logic_1164.all;

entity reg is
	generic( N: natural );
	port(	D:  	in	std_logic_vector(N-1 downto 0);
			clk: 	in	std_logic;
			rst:	in 	std_logic;
			Q:		out	std_logic_vector(N-1 downto 0);
			Qn:		out std_logic_vector(N-1 downto 0) );
end reg;

architecture behav of reg is

begin
		
	process (clk, rst)
	begin
		if (rst = '1') then
			Q  <= (others => '0');
			Qn <= (others => '1');
		elsif (clk 'event and clk = '1') then
			Q  <= D;
			Qn <= not (D);
		end if;
	end process;

end behav;