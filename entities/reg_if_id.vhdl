-- IF-ID REGISTER

library ieee;
use ieee.std_logic_1164.all;

entity reg_if_id is
	port(	if_pc:  	in	std_logic_vector(31 downto 0);
            if_instr: 	in	std_logic_vector(31 downto 0);
            id_pc:  	out	std_logic_vector(31 downto 0);
            id_instr: 	out	std_logic_vector(31 downto 0);
            clk:        in  std_logic;
            rst:        in  std_logic );
end reg_if_id;

architecture behav of reg_if_id is

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
        generic map ( N => 32 )
        port map (  D => if_pc,
                    Q => id_pc,
                    clk => clk,
                    rst => rst );

    reg_instr: reg
        generic map ( N => 32 )
        port map (  D => if_instr,
                    Q => id_instr,
                    clk => clk,
                    rst => rst );

end behav;