library ieee;
use ieee.std_logic_1164.all;

entity tb_mem_data is
end tb_mem_data;

architecture behav of tb_mem_data is

    component mem_data
        generic (N : natural);
        port(   addr:       in  std_logic_vector (N-1 downto 0);
                data_write: in  std_logic_vector (N-1 downto 0);
                data_read:  out std_logic_vector (N-1 downto 0);
                MemWrite:   in  std_logic;
                MemRead:    in  std_logic );
    end component;
	
	constant N_test : natural := 32;
	signal MemWrite_test, MemRead_test: std_logic;
	signal addr_test, data_write_test, data_read_test: std_logic_vector(N_test-1 downto 0);

begin

    mem_data_test: mem_data
        generic map ( N => N_test )
        port map (  addr => addr_test,
                    data_write => data_write_test,
                    data_read => data_read_test,
                    MemWrite => MemWrite_test,
                    MemRead => MemRead_test );

    data_gen: process
    begin
        -- read test
        MemWrite_test <= '0';
        MemRead_test <= '1';
        addr_test <= x"00000004";
        wait for 10 ns;
        -- write test
        MemWrite_test <= '1';
        wait for 5 ns;
        MemRead_test <= '0';
        addr_test <= x"00000000";
        data_write_test <= x"FF00A3B0";
        wait for 15 ns;
        MemWrite_test <= '0';
        MemRead_test <= '1';
        wait for 25 ns;
        MemRead_test <= '0';
        wait for 20 ns;
        MemWrite_test <= '1';
        addr_test <= x"00000001";
        data_write_test <= x"12345678";
        wait for 20 ns;
        MemWrite_test <= '0';
        MemRead_test <= '1';
        addr_test <= x"00000002";
        wait;
    end process;
    
end behav;