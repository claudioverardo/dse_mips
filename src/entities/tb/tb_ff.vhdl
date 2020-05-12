library ieee;
use ieee.std_logic_1164.all;

entity tb_ff is
end tb_ff;

architecture behav of tb_ff is

	component ff
		port(	D:  	in	std_logic;
				clk: 	in	std_logic;
				rst:	in 	std_logic;
				wrt:	in 	std_logic;
				Q:		out	std_logic;
				Qn:		out std_logic );
	end component;
	
	signal clk_test, rst_test, wrt_test: std_logic;
	signal D_test, Q_test, Qn_test: std_logic;
	
begin
	
	ff_test: ff
		port map ( 	D => D_test,
					clk => clk_test,
					rst => rst_test,
					wrt => wrt_test,
					Q => Q_test,
					Qn => Qn_test );
					
	clock_gen: process
	begin
		clk_test <= '1';
		wait for 10 ns;
		clk_test <= '0';
		wait for 10 ns;
	end process;
		
	reset_gen: process
	begin
		rst_test <= '0';
		wait for 85 ns;
		rst_test <= '1';
		wait for 20 ns;
		rst_test <= '0';
		wait;
	end process;
	
	data_gen: process
	begin
		wrt_test <= '1';
		D_test <= '1';
		wait for 35 ns;
		D_test <= '0';
		wait for 20 ns;
		D_test <= '1';
		wait for 50 ns;
		D_test <= '0';
		wait for 5 ns;
		D_test <= '1';
		wait for 20 ns;
		wrt_test <= '0';
		D_test <= '0';
		wait;
	end process;
		
end behav;