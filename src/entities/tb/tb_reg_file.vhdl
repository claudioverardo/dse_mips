library ieee;
use ieee.std_logic_1164.all;

entity tb_reg_file is
end tb_reg_file;

architecture behav of tb_reg_file is

    component reg_file
        generic (   N_ADDR: natural;
                    N_DATA: natural );
        port (  addr_read1: in  std_logic_vector (N_ADDR-1 downto 0);
                addr_read2: in  std_logic_vector (N_ADDR-1 downto 0);
                addr_write: in  std_logic_vector (N_ADDR-1 downto 0);
                data_read1: out std_logic_vector (N_DATA-1 downto 0);
                data_read2: out std_logic_vector (N_DATA-1 downto 0);
                data_write: in  std_logic_vector (N_DATA-1 downto 0);
                RegWrite:   in  std_logic;
                rst:        in  std_logic );
    end component;
	
	constant N_ADDR_test : natural := 3;
	constant N_DATA_test : natural := 8;
	signal rst_test, RegWrite_test: std_logic;
	signal addr_read1_test, addr_read2_test, addr_write_test: std_logic_vector(N_ADDR_test-1 downto 0);
	signal data_read1_test, data_read2_test, data_write_test: std_logic_vector(N_DATA_test-1 downto 0);

begin

    reg_file_test: reg_file
    generic map ( N_ADDR => N_ADDR_test,
                  N_DATA => N_DATA_test )
    port map (  addr_read1 => addr_read1_test,
                addr_read2 => addr_read2_test,
                addr_write => addr_write_test,
                data_read1 => data_read1_test,
                data_read2 => data_read2_test,
                data_write => data_write_test,
                RegWrite => RegWrite_test,
                rst => rst_test );

    reset_gen: process
    begin
        rst_test <= '0';
        wait for 80 ns;
        rst_test <= '1';
        wait for 10 ns;
        rst_test <= '0';
        wait;
    end process;

    data_gen: process
    begin
        RegWrite_test <= '0';
        addr_read1_test <= "001";
        addr_read2_test <= "011";
        wait for 15 ns;
        RegWrite_test <= '1';
        addr_write_test <= "000";
        data_write_test <= x"FA";
        wait for 15 ns;
        addr_write_test <= "100";
        data_write_test <= x"B2";
        wait for 15 ns;
        RegWrite_test <= '0';
        data_write_test <= x"00";
        wait for 5 ns;
        addr_read1_test <= "000";
        addr_read2_test <= "100";
        data_write_test <= x"66";
        wait for 20 ns;
        RegWrite_test <= '1';  -- DATA HAZARD
        addr_read1_test <= "000";
        addr_read2_test <= "010";
        addr_write_test <= "010";
        wait;
    end process;   
    

end behav;