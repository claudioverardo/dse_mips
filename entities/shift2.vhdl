-- 2 bit LEFT SHIFTER

library ieee;
use ieee.std_logic_1164.all;

entity shift2 is
	generic( N: natural );
	port(	val_in:		in	std_logic_vector(N-1 downto 0);
			val_out:	out	std_logic_vector(N-1 downto 0) );
end shift2;

architecture behav of shift2 is

begin

	val_out <= val_in (N-3 downto 0) & "00";

end behav;