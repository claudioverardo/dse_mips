-- PC register (N bit)

library ieee;
use ieee.std_logic_1164.all;

entity pc is
	port(	pc_next:    in	 std_logic_vector(31 downto 0);
			pc:	        out  std_logic_vector(31 downto 0);
			clk: 	    in	 std_logic;
			rst:	    in   std_logic );
end pc;

architecture behav of pc is

    component reg
        generic( N: natural );
        port(	D:  	in	std_logic_vector(N-1 downto 0);
                clk: 	in	std_logic;
                rst:	in 	std_logic;
                Q:		out	std_logic_vector(N-1 downto 0);
                Qn:		out std_logic_vector(N-1 downto 0) );
    end component;

begin
		
    reg_pc: reg
        generic map( N => 32 )
        port map ( D => pc_next,
                   clk => clk,
                   rst => rst,
                   Q => pc );

end behav;