library ieee;
use ieee.std_logic_1164.all;

entity tb_reg is
end tb_reg;

architecture behav of tb_reg is

	component reg
		generic( N: natural );
		port(	D:  	in	std_logic_vector(N-1 downto 0);
				clk: 	in	std_logic;
				rst:	in 	std_logic;
				Q:		out	std_logic_vector(N-1 downto 0);
				Qn:		out std_logic_vector(N-1 downto 0) );
	end component;
	
	constant N_16  : natural := 16;
	signal clk_16, rst_16: std_logic;
	signal D_16, Q_16, Qn_16: std_logic_vector(N_16-1 downto 0);
	
begin
	
	register_16: reg 
		generic map ( N => 16 )
		port map ( 	D => D_16,
					clk => clk_16,
					rst => rst_16,
					Q => Q_16,
					Qn => Qn_16 );
					
	clock_gen: process
	begin
		clk_16 <= '1';
		wait for 10 ns;
		clk_16 <= '0';
		wait for 10 ns;
	end process;
		
	reset_gen: process
	begin
		rst_16 <= '0';
		wait for 85 ns;
		rst_16 <= '1';
		wait for 20 ns;
		rst_16 <= '0';
		wait;
	end process;
	
	data_gen: process
	begin
		D_16 <= x"FFFF";
		wait for 35 ns;
		D_16 <= x"AA00";
		wait for 20 ns;
		D_16 <= x"1111";
		wait for 5 ns;
		D_16 <= x"2121";
		wait for 45 ns;
		D_16 <= x"FFEE";
		wait for 5 ns;
		D_16 <= x"1111";
		wait;
	end process;
		
end behav;