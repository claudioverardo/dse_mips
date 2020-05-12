-- ID-EX REGISTER

library ieee;
use ieee.std_logic_1164.all;

entity reg_id_ex is
    port(	-- CONTROL IN
            id_ALUSrc:      in  std_logic;
            id_RegDst:      in  std_logic;
            id_ALUOp:       in  std_logic_vector(3 downto 0);
            id_BranchNE:    in  std_logic;
            id_Branch:      in  std_logic;
            id_MemRead:     in  std_logic;
            id_MemWrite:    in  std_logic;
            id_MemToReg:    in  std_logic;
            id_RegWrite:    in  std_logic;
            -- DATA IN
            id_pc:  	    in	std_logic_vector(31 downto 0); 
            id_data_read1: 	in	std_logic_vector(31 downto 0);
            id_data_read2: 	in	std_logic_vector(31 downto 0);
            id_imm: 	    in	std_logic_vector(31 downto 0);
            id_rs: 	        in	std_logic_vector(4 downto 0);
            id_rt: 	        in	std_logic_vector(4 downto 0);
            id_rd: 	        in	std_logic_vector(4 downto 0);
            -- CONTROL OUT
            ex_ALUSrc:      out  std_logic;
            ex_RegDst:      out  std_logic;
            ex_ALUOp:       out  std_logic_vector(3 downto 0);
            ex_BranchNE:    out  std_logic;
            ex_Branch:      out  std_logic;
            ex_MemRead:     out  std_logic;
            ex_MemWrite:    out  std_logic;
            ex_MemToReg:    out  std_logic;
            ex_RegWrite:    out  std_logic;
            -- DATA OUT
            ex_pc:  	    out	std_logic_vector(31 downto 0);
            ex_data_read1: 	out	std_logic_vector(31 downto 0);
            ex_data_read2: 	out	std_logic_vector(31 downto 0);
            ex_imm: 	    out	std_logic_vector(31 downto 0);
            ex_rs: 	        out	std_logic_vector(4 downto 0);
            ex_rt: 	        out	std_logic_vector(4 downto 0);
            ex_rd: 	        out	std_logic_vector(4 downto 0);
            -- OTHERS
            clk:            in  std_logic;
            rst:            in  std_logic;
            wrt:            in  std_logic  );
end reg_id_ex;

architecture behav of reg_id_ex is

    component ff
        port(	D:  	in	std_logic;
                clk: 	in	std_logic;
                rst:	in 	std_logic;
                wrt:	in 	std_logic;
                Q:		out	std_logic;
                Qn:		out std_logic );
    end component;

    component reg
        generic( N: natural );
        port(	D:  	in	std_logic_vector(N-1 downto 0);
                clk: 	in	std_logic;
                rst:	in 	std_logic;
                wrt:	in 	std_logic;
                Q:		out	std_logic_vector(N-1 downto 0);
                Qn:		out std_logic_vector(N-1 downto 0) );
    end component;

begin

    -- CONTROL SIGNALS

    ff_ALUSrc: ff
        port map (  D => id_ALUSrc,
                    Q => ex_ALUSrc,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    ff_RegDst: ff
        port map (  D => id_RegDst,
                    Q => ex_RegDst,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    reg_ALUOp: reg
        generic map ( N => 4 )
        port map (  D => id_ALUOp,
                    Q => ex_ALUOp,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    ff_BranchNE: ff
        port map (  D => id_BranchNE,
                    Q => ex_BranchNE,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    ff_Branch: ff
        port map (  D => id_Branch,
                    Q => ex_Branch,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    ff_MemRead: ff
        port map (  D => id_MemRead,
                    Q => ex_MemRead,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    ff_MemWrite: ff
        port map (  D => id_MemWrite,
                    Q => ex_MemWrite,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    ff_MemToReg: ff
        port map (  D => id_MemToReg,
                    Q => ex_MemToReg,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    ff_RegWrite: ff
        port map (  D => id_RegWrite,
                    Q => ex_RegWrite,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    -- DATA SIGNALS

    reg_pc: reg
        generic map ( N => 32 )
        port map (  D => id_pc,
                    Q => ex_pc,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    reg_read1: reg
    generic map ( N => 32 )
    port map (  D => id_data_read1,
                Q => ex_data_read1,
                clk => clk,
                rst => rst,
                wrt => wrt );

    reg_read2: reg
        generic map ( N => 32 )
        port map (  D => id_data_read2,
                    Q => ex_data_read2,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    reg_imm: reg
        generic map ( N => 32 )
        port map (  D => id_imm,
                    Q => ex_imm,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    reg_rs: reg
        generic map ( N => 5 )
        port map (  D => id_rs,
                    Q => ex_rs,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    reg_rt: reg
        generic map ( N => 5 )
        port map (  D => id_rt,
                    Q => ex_rt,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

    reg_rd: reg
        generic map ( N => 5 )
        port map (  D => id_rd,
                    Q => ex_rd,
                    clk => clk,
                    rst => rst,
                    wrt => wrt );

end behav;