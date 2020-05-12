library ieee;
use ieee.std_logic_1164.all;

entity tb_control is
end tb_control;


architecture behav of tb_control is

    component control is
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
	
	signal OPCode_test: std_logic_vector(5 downto 0);
    signal ALUOp_test: std_logic_vector(3 downto 0);
	signal ALUSrc_test, RegDst_test, BranchNE_test, Branch_test, MemRead_test, MemWrite_test, MemToReg_test, RegWrite_test: std_logic;

begin

    control_test: control
    port map (  OPCode => OPCode_test,
                ALUSrc => ALUSrc_test,
                RegDst => RegDst_test,
                ALUOp => ALUOp_test,
                BranchNE => BranchNE_test,
                Branch => Branch_test,
                MemRead => MemRead_test,
                MemWrite => MemWrite_test,
                MemToReg => MemToReg_test,
                RegWrite => RegWrite_test );

    data_gen: process
    begin
        OPCode_test <= "000000"; -- NOP
        wait for 10 ns;
        OPCode_test <= "000001"; -- R-instructions
        wait for 10 ns;
        OPCode_test <= "000010"; -- sum imm
        wait for 10 ns;
        OPCode_test <= "000011"; -- sub imm
        wait for 10 ns;
        OPCode_test <= "000100"; -- and imm
        wait for 10 ns;
        OPCode_test <= "000101"; -- or imm
        wait for 10 ns;
        OPCode_test <= "000110"; -- nand imm
        wait for 10 ns;
        OPCode_test <= "000111"; -- nor imm
        wait for 10 ns;
        OPCode_test <= "001000"; -- slt imm
        wait for 10 ns;
        OPCode_test <= "001001"; -- load
        wait for 10 ns;
        OPCode_test <= "001010"; -- store
        wait for 10 ns;
        OPCode_test <= "001011"; -- beq
        wait for 10 ns;
        OPCode_test <= "001100"; -- bne
        wait;
    end process;

end behav;