library ieee;
use ieee.std_logic_1164.all;

entity tb_sign_ext is
end tb_sign_ext;

architecture behav of tb_sign_ext is

	component sign_ext
        generic( N_in: natural;
                 N_out: natural );
        port(   val_in : in  std_logic_vector (N_in-1 downto 0);
                val_out: out std_logic_vector (N_out-1 downto 0));
    end component;
    
    constant N_in_test  : natural := 16;
    constant N_out_test : natural := 32;
    signal val_in_test  : std_logic_vector(N_in_test-1 downto 0);
    signal val_out_test : std_logic_vector(N_out_test-1 downto 0);

begin
		
    sign_ext_test: sign_ext
        generic map ( N_in => N_in_test, 
                      N_out => N_out_test )
        port map (	val_in => val_in_test,
                    val_out => val_out_test );

    data_gen: process
    begin
        val_in_test <= x"A04F";
        wait for 20 ns;
        val_in_test <= x"4FD1";
	    wait;
	end process;

end behav;