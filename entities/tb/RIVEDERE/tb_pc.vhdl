library ieee;
use ieee.std_logic_1164.all;

entity tb_pc is
end tb_pc;

architecture behav of tb_pc is

    component pc
        port(	pc_next:    in	std_logic_vector(31 downto 0);
                pc:	        out	std_logic_vector(31 downto 0);
                clk: 	    in	std_logic;
                rst:	    in 	std_logic;
                wrt:        in  std_logic );
    end component;
	
	signal clk_test, rst_test, wrt_test: std_logic;
	signal in_test, out_test: std_logic_vector(31 downto 0);

begin

    pc_test: pc
        port map ( pc_next => in_test,
                   pc => out_test,
                   clk => clk_test,
                   rst => rst_test,
                   wrt => wrt_test );
    

    clock_gen: process
    begin
        clk_test <= '1';
        wait for 10 ns;
        clk_test <= '0';
        wait for 10 ns;
    end process;
                           
    reset_gen: process
    begin
        rst_test <= '1';
        wait for 10 ns;
        rst_test <= '0';
        wait for 40 ns;
        rst_test <= '1';
        wait for 20 ns;
        rst_test <= '0';
        wait;
    end process;

    data_gen: process
    begin
        in_test <= x"FF00ABCD";
        wait for 5 ns;
        in_test <= x"12345678";
        wait for 35 ns;
        in_test <= x"000E2200";
        wait for 40 ns;
        in_test <= x"AABB0021";
        wait;
    end process;
    
end behav;