-- EX-MEM REGISTER

library ieee;
use ieee.std_logic_1164.all;

entity reg_ex_mem is
    port (  -- CONTROL IN
            ex_Branch:          in  std_logic;
            ex_MemRead:         in  std_logic;
            ex_MemWrite:        in  std_logic;
            ex_MemToReg:        in  std_logic;
            ex_RegWrite:        in  std_logic;
            -- DATA IN 
            ex_branch_addr:     in  std_logic_vector(31 downto 0);
            ex_branch_check:    in  std_logic;
            ex_result:          in  std_logic_vector(31 downto 0);
            ex_data_write_mem:  in  std_logic_vector(31 downto 0);
            ex_addr_write_reg:  in  std_logic_vector(4 downto 0);
            -- CONTROL OUT
            mem_Branch:         out  std_logic;
            mem_MemRead:        out  std_logic;
            mem_MemWrite:       out  std_logic;
            mem_MemToReg:       out  std_logic;
            mem_RegWrite:       out  std_logic;
            -- DATA OUT
            mem_branch_addr:    out  std_logic_vector(31 downto 0);
            mem_branch_check:   out  std_logic;
            mem_result:         out  std_logic_vector(31 downto 0);
            mem_data_write_mem: out  std_logic_vector(31 downto 0);
            mem_addr_write_reg: out  std_logic_vector(4 downto 0);
            -- OTHERS
            clk:            in  std_logic;
            rst:            in  std_logic  );
end reg_ex_mem;

architecture behav of reg_ex_mem is

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

    ff_Branch: ff
        port map (  D => ex_Branch,
                    Q => mem_Branch,
                    clk => clk,
                    rst => rst );

    ff_MemRead: ff
        port map (  D => ex_MemRead,
                    Q => mem_MemRead,
                    clk => clk,
                    rst => rst );

    ff_MemWrite: ff
        port map (  D => ex_MemWrite,
                    Q => mem_MemWrite,
                    clk => clk,
                    rst => rst );

    ff_MemToReg: ff
        port map (  D => ex_MemToReg,
                    Q => mem_MemToReg,
                    clk => clk,
                    rst => rst );

    ff_RegWrite: ff
        port map (  D => ex_RegWrite,
                    Q => mem_RegWrite,
                    clk => clk,
                    rst => rst );

    reg_branch_addr: reg
        generic map ( N => 32 )
        port map (  D => ex_branch_addr,
                    Q => mem_branch_addr,
                    clk => clk,
                    rst => rst );

    ff_branch_check: ff
        port map (  D => ex_branch_check,
                    Q => mem_branch_check,
                    clk => clk,
                    rst => rst );

    reg_ALU_result: reg
        generic map ( N => 32 )
        port map (  D => ex_result,
                    Q => mem_result,
                    clk => clk,
                    rst => rst );

    reg_data_write_mem: reg
        generic map ( N => 32 )
        port map (  D => ex_data_write_mem,
                    Q => mem_data_write_mem,
                    clk => clk,
                    rst => rst );

    reg_addr_write_reg: reg
        generic map ( N => 5 )
        port map (  D => ex_addr_write_reg,
                    Q => mem_addr_write_reg,
                    clk => clk,
                    rst => rst );

end behav;