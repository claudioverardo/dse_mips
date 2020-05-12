library ieee;
use ieee.std_logic_1164.all;

entity tb_shift2 is
end tb_shift2;

architecture behav of tb_shift2 is

	component shift2
        generic( N: natural );
        port(	val_in:		in	std_logic_vector(N-1 downto 0);
                val_out:	out	std_logic_vector(N-1 downto 0) );
    end component;
    
    constant N_32  : natural := 32;
	signal val_in_32, val_out_32: std_logic_vector(N_32-1 downto 0);

begin
		
    shift2_test: shift2
        generic map ( N => N_32)
        port map (	val_in => val_in_32,
                    val_out => val_out_32 );

    data_gen: process
    begin
        val_in_32 <= x"C0000000";
        wait for 10 ns;
        val_in_32 <= x"00000003";
	    wait;
	end process;

end behav;