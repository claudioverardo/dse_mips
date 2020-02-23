library ieee;
use ieee.std_logic_1164.all;

entity tb_mux2 is
end tb_mux2;

architecture behav of tb_mux2 is

    component mux2
        generic ( N : natural);
        port (  port1:      in  std_logic_vector (N-1 downto 0);
                port2:      in  std_logic_vector (N-1 downto 0);
                sel:        in  std_logic;
                port_out:   out std_logic_vector (N-1 downto 0) );
    end component;
    
    constant N_test: natural := 16;
    signal val_in1, val_in2, val_out: std_logic_vector(N_test-1 downto 0);
    signal sel_test: std_logic;

begin

    mux2_test: mux2
        generic map( N => N_test )
        port map(   port1 => val_in1,
                    port2 => val_in2,
                    sel => sel_test,
                    port_out => val_out );

    data_gen: process
    begin
        sel_test <= '0';
        val_in1 <= x"A100";
        val_in2 <= x"8FF2";
        wait for 10 ns;
        val_in1 <= x"FF23";
        val_in2 <= x"1000";
        wait for 10 ns;
        sel_test <= '1';
        wait for 20 ns;
        sel_test <= '0';
	    wait;
    end process;
        
end behav;