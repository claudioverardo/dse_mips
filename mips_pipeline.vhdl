-- MIPS PIPELINE

library ieee;
use ieee.std_logic_1164.all;

entity mips_pipeline is
    port (  clk: in  std_logic;
            rst: in  std_logic );
end mips_pipeline;

architecture behav of mips_pipeline is
    
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    --%%              REGISTERS              %%
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    -- PC
    component pc
        port(	pc_next:    in	std_logic_vector(31 downto 0);
                pc:	        out std_logic_vector(31 downto 0);
                clk: 	    in	std_logic;
                rst:	    in  std_logic );
    end component;

    -- IF_ID REGISTER
    component reg_if_id
        port(	if_pc:  	in	std_logic_vector(31 downto 0);
                if_instr: 	in	std_logic_vector(31 downto 0);
                id_pc:  	out	std_logic_vector(31 downto 0);
                id_instr: 	out	std_logic_vector(31 downto 0);
                clk:        in  std_logic;
                rst:        in  std_logic );
    end component;

    -- ID_EX REGISTER
    component reg_id_ex is
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
                ex_rt: 	        out	std_logic_vector(4 downto 0);
                ex_rd: 	        out	std_logic_vector(4 downto 0);
                -- OTHERS
                clk:            in  std_logic;
                rst:            in  std_logic  );
    end component; 
    
    -- EX_MEM REGISTER
    component reg_ex_mem
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
                -- DATA IN 
                mem_branch_addr:    out  std_logic_vector(31 downto 0);
                mem_branch_check:   out  std_logic;
                mem_result:         out  std_logic_vector(31 downto 0);
                mem_data_write_mem: out  std_logic_vector(31 downto 0);
                mem_addr_write_reg: out  std_logic_vector(4 downto 0);
                -- OTHERS
                clk:            in  std_logic;
                rst:            in  std_logic  );
    end component;
    
    -- MEM_WB REGISTER
    component reg_mem_wb
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
    end component;
    
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    --%%               MEMORY               %%
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    -- INSTRUCTION MEMORY
    component mem_instr
        generic (N : natural);
        port(   addr:   in  std_logic_vector (N-1 downto 0);
                instr:  out std_logic_vector (N-1 downto 0) );
    end component;

    -- REGISTER FILE
    component reg_file
        generic (N_ADDR: natural;
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

    -- DATA MEMORY
    component mem_data
        generic (N : natural);
        port(   addr:       in  std_logic_vector (N-1 downto 0);
                data_write: in  std_logic_vector (N-1 downto 0);
                data_read:  out std_logic_vector (N-1 downto 0);
                MemWrite:   in  std_logic;
                MemRead:    in  std_logic );
    end component;
    
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    --%%             ARITHMETIC             %%
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    -- ADDER
    component adder 
        generic( N: natural );
        port(	add1:	in	std_logic_vector(N-1 downto 0);
                add2:	in	std_logic_vector(N-1 downto 0);
                sum:	out	std_logic_vector(N-1 downto 0) );
    end component;

    -- ALU
    component alu 
        generic ( N: natural );
        port (  data1:    in     std_logic_vector (N-1 downto 0);
                data2:    in     std_logic_vector (N-1 downto 0);
                ALUCtrl:  in     std_logic_vector (3 downto 0);
                result:   buffer std_logic_vector (N-1 downto 0);
                zero:     out    std_logic );
    end component;

    -- SHIFTER
    component shifter
        port (  shamt:      in  std_logic_vector (4 downto 0);
                rt:         in  std_logic_vector (31 downto 0);
                ShiftCtrl:  in  std_logic_vector (1 downto 0);
                result:     out std_logic_vector (31 downto 0)  );
    end component;

    -- SIGNAL EXTENSION
    component sign_ext
        generic( N_in: natural;
                 N_out: natural );
        port(   val_in : in  std_logic_vector (N_in-1 downto 0);
                val_out: out std_logic_vector (N_out-1 downto 0));
    end component;

    -- SHIFT2
    component shift2 
        generic( N: natural );
        port(	val_in:		in	std_logic_vector(N-1 downto 0);
                val_out:	out	std_logic_vector(N-1 downto 0) );
    end component;

    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    --%%               CONTROL               %%
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    -- CENTRAL CONTROL UNIT
    component control 
        port (  OPCode:     in   std_logic_vector(5 downto 0);
                ALUSrc:     out  std_logic;
                RegDst:     out  std_logic;
                ALUOp:      out  std_logic_vector(3 downto 0);
                BranchNE:   out  std_logic;
                Branch:     out  std_logic;
                MemRead:    out  std_logic;
                MemWrite:   out  std_logic;
                MemToReg:   out  std_logic;
                RegWrite:   out  std_logic );
    end component;

    -- ALU CONTROL UNIT
    component control_alu
        port (  ALUOp:        in  std_logic_vector (3 downto 0); 
                funct:        in  std_logic_vector (5 downto 0);
                ALUCtrl:      out std_logic_vector (3 downto 0);
                ShiftCtrl:    out std_logic_vector (1 downto 0);
                ResSrc:       out std_logic );
    end component;

    -- 2-MULTIPLEXER
    component mux2
        generic ( N : natural);
        port (  port1:      in  std_logic_vector (N-1 downto 0);
                port2:      in  std_logic_vector (N-1 downto 0);
                sel:        in  std_logic;
                port_out:   out std_logic_vector (N-1 downto 0) );
    end component;
    
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    --%%               SIGNALS               %%
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    -- SIGNALS IN FETCH STAGE
    signal if_pc_link, if_pc_next_link_adder, if_pc_next_link_mux, if_instr_link: std_logic_vector(31 downto 0);
    
    -- SIGNALS IN DECODE STAGE
    signal id_OPCode_link: std_logic_vector(5 downto 0);
    signal id_ALUSrc_link, id_RegDst_link, id_BranchNE_link, id_Branch_link, id_MemRead_link, id_MemWrite_link, id_MemToReg_link, id_RegWrite_link: std_logic;
    signal id_ALUOp_link: std_logic_vector(3 downto 0);
    signal id_pc_link, id_instr_link, id_data_read1_link, id_data_read2_link, id_imm_link: std_logic_vector(31 downto 0);

    -- SIGNALS IN EXECUTE STAGE
    signal ex_ALUSrc_link, ex_RegDst_link, ex_BranchNE_link, ex_Branch_link, ex_MemRead_link, ex_MemWrite_link, ex_MemToReg_link, ex_RegWrite_link, ex_zero_link, ex_branch_check_link, ex_ResSrc_link: std_logic;
    signal ex_ALUOp_link, ex_ALUCtrl_link: std_logic_vector(3 downto 0);
    signal ex_ShiftCtrl_link: std_logic_vector(1 downto 0);
    signal ex_pc_link, ex_data_read1_link, ex_data_read2_link, ex_imm_link, ex_imm_shift2_link, ex_ALU_data2_link, ex_branch_addr_link, ex_ALU_result_link, ex_shift_result_link, ex_result_link: std_logic_vector(31 downto 0);
    signal ex_rt_link, ex_rd_link, ex_addr_write_reg_link: std_logic_vector(4 downto 0);

    -- SIGNALS IN MEMORY STAGE
    signal mem_Branch_link, mem_MemRead_link, mem_MemWrite_link, mem_MemToReg_link, mem_RegWrite_link, mem_branch_check_link, mem_PCSrc_link: std_logic;
    signal mem_branch_addr_link, mem_result_link, mem_data_write_mem_link, mem_data_read_mem_link: std_logic_vector(31 downto 0);
    signal mem_addr_write_reg_link: std_logic_vector(4 downto 0);

    -- SIGNALS IN WRITE BACK STAGE
    signal wb_MemToReg_link, wb_RegWrite_link: std_logic; 
    signal wb_data_read_mem_link, wb_ALU_result_link, wb_data_write_reg_link: std_logic_vector(31 downto 0);
    signal wb_addr_write_reg_link: std_logic_vector(4 downto 0);

begin
    
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    --%%          INSTRUCTION FETCH          %%
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    -- PC REGISTER
    pc_mips: pc
        port map (  pc_next => if_pc_next_link_mux,
                    pc => if_pc_link,
                    clk => clk,
                    rst => rst );

    -- INSTRUCTION MEMORY
    mem_instr_mips: mem_instr
        generic map (N  => 32 )
        port map (  addr => if_pc_link,
                    instr => if_instr_link );

    -- NEXT PC ADDER
    adder_if_mips: adder
        generic map (N  => 32 )
        port map (	add1 => if_pc_link,
                    add2 => x"00000004",
                    sum => if_pc_next_link_adder );

    -- BRANCH UPDATE OF PC
    mux2_if_mips: mux2
        generic map ( N => 32 )
        port map (  port1 => if_pc_next_link_adder,
                    port2 => mem_branch_addr_link,  -- WARNING, branch feedback
                    sel => mem_PCSrc_link, 
                    port_out => if_pc_next_link_mux );
    
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    --%%          INSTRUCTION DECODE          %%
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    -- IF_ID REGISTER
    reg_if_id_mips: reg_if_id
        port map (  if_pc => if_pc_next_link_adder,
                    if_instr => if_instr_link,
                    id_pc => id_pc_link,
                    id_instr => id_instr_link,
                    clk => clk,
                    rst => rst );
    
    -- CENTRAL CONTROL UNIT
    control_mips: control 
        port map (  OPCode => id_instr_link(31 downto 26),
                    ALUSrc => id_ALUSrc_link,
                    RegDst => id_RegDst_link,
                    ALUOp => id_ALUOp_link,
                    BranchNE => id_BranchNE_link,
                    Branch => id_Branch_link,
                    MemRead => id_MemRead_link,
                    MemWrite => id_MemWrite_link,
                    MemToReg => id_MemToReg_link,
                    RegWrite => id_RegWrite_link );
    
    -- REGISTER FILE
    reg_file_mips: reg_file
        generic map (   N_ADDR => 5,
                        N_DATA => 32 )
        port map (  addr_read1 => id_instr_link(25 downto 21),
                    addr_read2 => id_instr_link(20 downto 16),
                    addr_write => wb_addr_write_reg_link, -- WARNING, WB FEEDBACK
                    data_read1 => id_data_read1_link,
                    data_read2 => id_data_read2_link,
                    data_write => wb_data_write_reg_link,
                    RegWrite => wb_RegWrite_link,
                    rst => rst );

    -- SIGNAL EXTENSION
    sign_ext_mips: sign_ext
        generic map(    N_in => 16,
                        N_out => 32 )
        port map(   val_in => id_instr_link(15 downto 0),
                    val_out => id_imm_link );   
    
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    --%%         INSTRUCTION EXECUTE         %%
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    -- ID_EX REGISTER
    reg_id_ex_mips: reg_id_ex 
        port map(	id_ALUSrc => id_ALUSrc_link,
                    id_RegDst => id_RegDst_link,
                    id_ALUOp => id_ALUOp_link,
                    id_BranchNE => id_BranchNE_link,
                    id_Branch => id_Branch_link,
                    id_MemRead => id_MemRead_link,
                    id_MemWrite => id_MemWrite_link,
                    id_MemToReg => id_MemToReg_link,
                    id_RegWrite => id_RegWrite_link,
                    id_pc => id_pc_link,
                    id_data_read1 => id_data_read1_link,
                    id_data_read2 => id_data_read2_link,
                    id_imm => id_imm_link,
                    id_rt => id_instr_link(20 downto 16),
                    id_rd => id_instr_link(15 downto 11),
                    ex_ALUSrc => ex_ALUSrc_link,
                    ex_RegDst => ex_RegDst_link,
                    ex_ALUOp => ex_ALUOp_link,
                    ex_BranchNE => ex_BranchNE_link,
                    ex_Branch => ex_Branch_link,
                    ex_MemRead => ex_MemRead_link,
                    ex_MemWrite => ex_MemWrite_link,
                    ex_MemToReg => ex_MemToReg_link,
                    ex_RegWrite => ex_RegWrite_link,
                    ex_pc => ex_pc_link,
                    ex_data_read1 => ex_data_read1_link,
                    ex_data_read2 => ex_data_read2_link,
                    ex_imm => ex_imm_link,
                    ex_rt => ex_rt_link,
                    ex_rd => ex_rd_link,
                    clk => clk,
                    rst => rst ); 
    
    -- SHIFT2
    shift2_mips: shift2 
        generic map ( N => 32 )
        port map(	val_in => ex_imm_link,
                    val_out => ex_imm_shift2_link );

    -- BRANCH ADDRESS ADDER
    adder_ex_mips: adder         
        generic map (N  => 32 )
        port map (	add1 => ex_pc_link,
                    add2 => ex_imm_shift2_link,
                    sum => ex_branch_addr_link );

    -- ALU 2nd operand
    mux2_ex_ALUSrc_mips: mux2
        generic map ( N => 32 )
        port map (  port1 => ex_data_read2_link,
                    port2 => ex_imm_link, 
                    sel => ex_ALUSrc_link,          
                    port_out => ex_ALU_data2_link );   

    -- ALU          
    alu_mips: alu 
        generic map ( N => 32 )
        port map (  data1 => ex_data_read1_link,
                    data2 => ex_ALU_data2_link,
                    ALUCtrl => ex_ALUCtrl_link,
                    result => ex_ALU_result_link,
                    zero => ex_zero_link );   

    -- SHIFTER
    shifter_mips: shifter
        port map (  shamt => ex_imm_link(10 downto 6),
                    rt => ex_data_read2_link,
                    ShiftCtrl => ex_ShiftCtrl_link,
                    result => ex_shift_result_link );
    
    -- ALU/SHIFTER CONTROL          
    control_alu_mips: control_alu
        port map (  ALUOp => ex_ALUOp_link,
                    funct => ex_imm_link(5 downto 0),
                    ALUCtrl => ex_ALUCtrl_link,
                    ShiftCtrl => ex_ShiftCtrl_link,
                    ResSrc => ex_ResSrc_link );

    -- CHECK BRANCH
    ex_branch_check_link <= ex_zero_link when ex_BranchNE_link = '0' else not(ex_zero_link);

    -- RESULT CHOICE
    mux2_ex_ResSrc_mips: mux2
        generic map ( N => 32 )
        port map (  port1 => ex_ALU_result_link,
                    port2 => ex_shift_result_link, 
                    sel => ex_ResSrc_link,          
                    port_out => ex_result_link );

    -- DESTINATION CHOICE  
    mux2_ex_RegDst_mips: mux2
        generic map ( N => 5 )
        port map (  port1 => ex_rt_link,
                    port2 => ex_rd_link, 
                    sel => ex_RegDst_link,          
                    port_out => ex_addr_write_reg_link );
    
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    --%%            MEMORY ACCESS            %%
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    -- EX_MEM REGISTER
    reg_ex_mem_mips: reg_ex_mem
        port map (  ex_Branch => ex_Branch_link,
                    ex_MemRead => ex_MemRead_link,
                    ex_MemWrite => ex_MemWrite_link,
                    ex_MemToReg => ex_MemToReg_link,
                    ex_RegWrite => ex_RegWrite_link,
                    ex_branch_addr => ex_branch_addr_link,
                    ex_branch_check => ex_branch_check_link,
                    ex_result => ex_result_link,
                    ex_data_write_mem => ex_data_read2_link,
                    ex_addr_write_reg => ex_addr_write_reg_link,
                    mem_Branch => mem_Branch_link,
                    mem_MemRead => mem_MemRead_link,
                    mem_MemWrite => mem_MemWrite_link,
                    mem_MemToReg => mem_MemToReg_link,
                    mem_RegWrite => mem_RegWrite_link,
                    mem_branch_addr => mem_branch_addr_link,
                    mem_branch_check => mem_branch_check_link,
                    mem_result => mem_result_link,
                    mem_data_write_mem => mem_data_write_mem_link,
                    mem_addr_write_reg => mem_addr_write_reg_link,
                    clk => clk,
                    rst => rst );

    -- BRANCH PC UPDATE CONTROL
    mem_PCSrc_link <= mem_Branch_link and mem_branch_check_link;
    
    -- DATA MEMORY
    mem_data_mips: mem_data
        generic map (N => 32 )
        port map (  addr => mem_result_link,
                    data_write => mem_data_write_mem_link,
                    data_read => mem_data_read_mem_link,
                    MemWrite => mem_MemWrite_link,
                    MemRead => mem_MemRead_link );
    
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    --%%             WRITE BACK             %%
    --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    -- MEM_WB REGISTER
    reg_mem_wb_mips: reg_mem_wb
        port map (  mem_MemToReg => mem_MemToReg_link,
                    mem_RegWrite => mem_RegWrite_link,
                    mem_data_read_mem => mem_data_read_mem_link,
                    mem_result => mem_result_link,
                    mem_addr_write_reg => mem_addr_write_reg_link,
                    wb_MemToReg => wb_MemToReg_link,
                    wb_RegWrite => wb_RegWrite_link,
                    wb_data_read_mem => wb_data_read_mem_link,
                    wb_result => wb_ALU_result_link,
                    wb_addr_write_reg => wb_addr_write_reg_link,
                    clk => clk,
                    rst => rst  );

    -- WB MULTIPLEXER
    mux2_wb_mips: mux2
        generic map ( N => 32 )
        port map (  port1 => wb_ALU_result_link,
                    port2 => wb_data_read_mem_link,
                    sel => wb_MemToReg_link, 
                    port_out => wb_data_write_reg_link );

end behav;