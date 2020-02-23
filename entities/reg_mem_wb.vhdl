-- MEM-WB REGISTER

library ieee;
use ieee.std_logic_1164.all;

entity reg_mem_wb is
    port (  -- CONTROL IN
            mem_MemToReg:        in  std_logic;
            mem_RegWrite:        in  std_logic;
            -- DATA IN 
            mem_data_read_mem:   in  std_logic_vector(31 downto 0);
            mem_result:      in  std_logic_vector(31 downto 0);
            mem_addr_write_reg:  in  std_logic_vector(4 downto 0);
            -- CONTROL OUT
            wb_MemToReg:         out std_logic;
            wb_RegWrite:         out std_logic;
            -- DATA OUT
            wb_data_read_mem:    out std_logic_vector(31 downto 0);
            wb_result:       out std_logic_vector(31 downto 0);
            wb_addr_write_reg:   out std_logic_vector(4 downto 0);
            -- OTHERS
            clk:                 in  std_logic;
            rst:                 in  std_logic  );
end reg_mem_wb;

architecture behav of reg_mem_wb is

    component ff
        port(	D:  	in	std_logic;
                clk: 	in	std_logic;
                rst:	in 	std_logic;
                Q:		out	std_logic;
                Qn:		out std_logic );
    end component;

    component reg
        generic( N: natural );
        port(	D:  	in	std_logic_vector(N-1 downto 0);
                clk: 	in	std_logic;
                rst:	in 	std_logic;
                Q:		out	std_logic_vector(N-1 downto 0);
                Qn:		out std_logic_vector(N-1 downto 0) );
    end component;

begin

    ff_MemToReg: ff
        port map (  D => mem_MemToReg,
                    Q => wb_MemToReg,
                    clk => clk,
                    rst => rst );

    ff_RegWrite: ff
        port map (  D => mem_RegWrite,
                    Q => wb_RegWrite,
                    clk => clk,
                    rst => rst );

    reg_data_read_mem: reg
        generic map ( N => 32 )
        port map (  D => mem_data_read_mem,
                    Q => wb_data_read_mem,
                    clk => clk,
                    rst => rst );

    reg_result: reg
        generic map ( N => 32 )
        port map (  D => mem_result,
                    Q => wb_result,
                    clk => clk,
                    rst => rst );

    reg_addr_write_reg: reg
        generic map ( N => 5 )
        port map (  D => mem_addr_write_reg,
                    Q => wb_addr_write_reg,
                    clk => clk,
                    rst => rst );

end behav;