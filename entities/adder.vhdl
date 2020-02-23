-- N bit ADDER

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	generic( N: natural );
	port(	add1:	in	std_logic_vector(N-1 downto 0);
			add2:	in	std_logic_vector(N-1 downto 0);
			sum:	out	std_logic_vector(N-1 downto 0) );
end adder;

architecture behav of adder is

begin
		
	process (add1,add2)
	begin
        sum <= std_logic_vector (unsigned (add1) + unsigned (add2));
	end process;

end behav;