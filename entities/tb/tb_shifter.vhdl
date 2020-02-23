library ieee;
use ieee.std_logic_1164.all;

entity tb_shifter is
end tb_shifter;

architecture behav of tb_shifter is 

    component shifter
        port (  shamt:      in  std_logic_vector (4 downto 0);
                rt:         in  std_logic_vector (31 downto 0);
                ShiftCtrl:  in  std_logic_vector (1 downto 0);
                result:     out std_logic_vector (31 downto 0)  );
    end component;

    signal shamt_test: std_logic_vector (4 downto 0);
    signal rt_test, result_test: std_logic_vector (31 downto 0);
    signal ShiftCtrl_test: std_logic_vector (1 downto 0);

begin

    shifter_test: shifter
        port map (  shamt => shamt_test,
                    rt => rt_test,
                    ShiftCtrl => ShiftCtrl_test,
                    result => result_test );

    data_gen: process
    begin
        ShiftCtrl_test <= "00";
        shamt_test <= "00100";
        rt_test <= x"ABFF2300";
        wait for 20 ns;
        ShiftCtrl_test <= "01";
        wait for 20 ns;
        ShiftCtrl_test <= "10";
        wait for 20 ns;
        ShiftCtrl_test <= "11";
        wait;
    end process;

end behav;