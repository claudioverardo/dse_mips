library ieee;
use ieee.std_logic_1164.all;

entity tb_mux3 is
end tb_mux3;

architecture behav of tb_mux3 is

    component mux3
        generic ( N : natural);
        port (  port1:      in  std_logic_vector (N-1 downto 0);
                port2:      in  std_logic_vector (N-1 downto 0);
                port3:      in  std_logic_vector (N-1 downto 0);
                sel:        in  std_logic_vector (1 downto 0);
                port_out:   out std_logic_vector (N-1 downto 0) );
    end component;
    
    constant N_test: natural := 16;
    signal val_in1, val_in2, val_in3, val_out: std_logic_vector(N_test-1 downto 0);
    signal sel_test: std_logic_vector(1 downto 0);

begin

    mux3_test: mux3
        generic map( N => N_test )
        port map(   port1 => val_in1,
                    port2 => val_in2,
                    port3 => val_in3,
                    sel => sel_test,
                    port_out => val_out );

    data_gen: process
    begin
        sel_test <= "00";
        val_in1 <= x"A100";
        val_in2 <= x"8FF2";
        val_in3 <= x"0BB5";
        wait for 10 ns;
        sel_test <= "01";
        wait for 10 ns;
        sel_test <= "10";
        val_in1 <= x"1234";
        val_in2 <= x"6666";
        wait for 10 ns;
        sel_test <= "00";
	    wait;
    end process;
        
end behav;