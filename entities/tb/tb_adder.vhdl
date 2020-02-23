library ieee;
use ieee.std_logic_1164.all;

entity tb_adder is
end tb_adder;

architecture behav of tb_adder is

	component adder
        generic( N: natural );
        port(	add1:	in	std_logic_vector(N-1 downto 0);
                add2:	in	std_logic_vector(N-1 downto 0);
                sum:	out	std_logic_vector(N-1 downto 0) );
    end component;
    
    constant N_test: natural := 32;
	signal add1_test, add2_test, sum_test: std_logic_vector(N_test-1 downto 0);

begin
		
    adder_test: adder
        generic map ( N => N_test)
        port map (	add1 => add1_test,
                    add2 => add2_test,
                    sum => sum_test );

    process
    begin
        add1_test <= x"00000010";	-- dec: 16 + 34 = 50 (x"32")
	 	add2_test <= x"00000022";		
        wait for 10 ns;
        add1_test <= x"F0000000";	-- ovf bin, no ovf c2
		add2_test <= x"10000000";	
        wait for 20 ns;
        add1_test <= x"70000000";	-- no ovf bin, ovf c2
		add2_test <= x"60000000";		
	    wait;
	end process;

end behav;