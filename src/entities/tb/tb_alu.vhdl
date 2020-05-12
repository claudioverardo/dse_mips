library ieee;
use ieee.std_logic_1164.all;

entity tb_alu is
end tb_alu;

architecture behav of tb_alu is

    component alu 
        generic ( N: natural );
        port (  data1:    in     std_logic_vector (N-1 downto 0);
                data2:    in     std_logic_vector (N-1 downto 0);
                ALUCtrl:  in     std_logic_vector (3 downto 0);
                result:   buffer std_logic_vector (N-1 downto 0);
                zero:     out    std_logic );
    end component;
	
    constant N_test: natural := 32;
    signal ALUCtrl_test: std_logic_vector(3 downto 0);
	signal data1_test, data2_test, result_test: std_logic_vector(N_test-1 downto 0);
	signal zero_test: std_logic;

begin

    alu_test: alu
        generic map ( N => N_test )
        port map (  data1 => data1_test,
                    data2 => data2_test,
                    ALUCtrl => ALUCtrl_test,
                    result => result_test,
                    zero => zero_test );

    data_gen: process
    begin
        data1_test <= x"01010000";
        data2_test <= x"00010000";
        ALUCtrl_test <= "0000"; -- NOP
        wait for 10 ns;
        ALUCtrl_test <= "0010"; -- sum
        wait for 10 ns;
        data2_test <= x"0110F1A0";
        wait for 10 ns;
        ALUCtrl_test <= "0011"; -- sub
        wait for 10 ns;
        data1_test <= x"0110F1A0";
        wait for 10 ns;
        data1_test <= x"01010000";
        wait for 10 ns;
        ALUCtrl_test <= "0100"; -- and
        data1_test <= x"01010000";
        wait for 10 ns;
        ALUCtrl_test <= "0101"; -- or
        wait for 10 ns;
        ALUCtrl_test <= "0110"; -- nand
        wait for 10 ns;
        ALUCtrl_test <= "0111"; -- nor
        wait for 10 ns;
        ALUCtrl_test <= "1000"; -- slt
        wait for 10 ns;
        data1_test <= x"0FF10000";
        wait for 10 ns;
        data1_test <= x"F0C10000";
        wait;
    end process;


end behav;