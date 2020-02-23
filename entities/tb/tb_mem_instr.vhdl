library ieee;
use ieee.std_logic_1164.all;

entity tb_mem_instr is
end tb_mem_instr;

architecture behav of tb_mem_instr is

    component mem_instr
        generic (N : natural);
        port(   addr:   in  std_logic_vector (N-1 downto 0);
                instr:  out std_logic_vector (N-1 downto 0) );
    end component;
	
	constant N_test : natural := 32;
	signal addr_test, instr_test: std_logic_vector(N_test-1 downto 0);

begin

    mem_instr_test: mem_instr
        generic map ( N => N_test )
        port map (  addr => addr_test,
                    instr => instr_test );

    data_gen: process
    begin
        addr_test <= x"00000000"; -- 0
        wait for 20 ns; 
        addr_test <= x"00000002"; -- 2
        wait for 20 ns; 
        addr_test <= x"00000004"; -- 4
        wait for 20 ns;
        addr_test <= x"00000008"; -- 8
        wait for 20 ns;
        addr_test <= x"0000000C"; -- 12
        wait for 20 ns;
        addr_test <= x"0000001C"; -- 28
        wait;
    end process;

end behav;