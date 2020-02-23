library ieee;
use ieee.std_logic_1164.all;

entity tb_mips_pipeline is
end tb_mips_pipeline;

architecture behav of tb_mips_pipeline is

    component mips_pipeline
        port (  clk: in  std_logic;
                rst: in  std_logic );
    end component;

    signal clk_test, rst_test: std_logic;

begin

    mips_pipeline_test: mips_pipeline
        port map (  clk => clk_test,
                    rst => rst_test );

    clock_gen: process
    begin
        clk_test <= '1';
        wait for 10 ns;
        clk_test <= '0';
        wait for 10 ns;
    end process;

    rst_gen: process
    begin
        rst_test <= '1';
        wait for 10 ns;
        rst_test <= '0';
        wait;
    end process;

end behav;