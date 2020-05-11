library ieee;
use ieee.std_logic_1164.all;

entity tb_forwarding_unit is
end tb_forwarding_unit;

architecture behav of tb_forwarding_unit is

    component forwarding_unit
        port(	-- ACTUAL SOURCES
                rs:             in  std_logic_vector(4 downto 0);
                rt:             in  std_logic_vector(4 downto 0);
                RegDst:         in  std_logic;
                -- FEEDBACK SOURCES
                mem_rd:         in  std_logic_vector(4 downto 0);
                mem_RegWrite:   in  std_logic;
                wb_rd:          in  std_logic_vector(4 downto 0);
                wb_RegWrite:    in  std_logic;
                -- FORWARDING CONTROL
                FwdSrc1:        out std_logic_vector(1 downto 0);
                FwdSrc2:        out std_logic_vector(1 downto 0) ); 
    end component;
    
    signal rs_test, rt_test, mem_rd_test, wb_rd_test: std_logic_vector(4 downto 0);
    signal RegDst_test, mem_RegWrite_test, wb_RegWrite_test: std_logic;
    signal FwdSrc1_test, FwdSrc2_test: std_logic_vector(1 downto 0);

begin
    
    forwarding_unit_test: forwarding_unit
        port map(   rs => rs_test,
                    rt => rt_test,
                    RegDst => RegDst_test,
                    mem_rd => mem_rd_test,
                    mem_RegWrite => mem_RegWrite_test,
                    wb_rd => wb_rd_test,
                    wb_RegWrite => wb_RegWrite_test,
                    FwdSrc1 => FwdSrc1_test,
                    FwdSrc2 => FwdSrc2_test );

    data_gen: process
    begin
        RegDst_test <= '1';
        mem_RegWrite_test <= '0';
        wb_RegWrite_test <= '0';
        rs_test <= "00011";
        rt_test <= "01000";
        mem_rd_test <= "00011";
        wb_rd_test <= "00011";
        wait for 10 ns;
        wb_RegWrite_test <= '1';
        wait for 10 ns;
        mem_RegWrite_test <= '1';
        wait for 10 ns;
        wb_rd_test <= "01000";
        wait for 10 ns;
        mem_rd_test <= "01000";
        wait for 10 ns;
        mem_RegWrite_test <= '0';
        wait for 10 ns;
        wb_rd_test <= "10101";
        wait for 10 ns;
        wb_RegWrite_test <= '0';
        wait for 10 ns;
        RegDst_test <= '0';
        mem_RegWrite_test <= '1';
        wb_RegWrite_test <= '1';
        rs_test <= "00011";
        rt_test <= "01000";
        mem_rd_test <= "00011";
        wb_rd_test <= "01000";
	    wait;
    end process;

end behav;