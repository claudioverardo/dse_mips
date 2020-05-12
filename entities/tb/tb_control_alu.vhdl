library ieee;
use ieee.std_logic_1164.all;

entity tb_control_alu is
end tb_control_alu;

architecture behav of tb_control_alu is

    component control_alu is
        port (  ALUOp:        in  std_logic_vector (3 downto 0); -- first 4 bit of OPCode
                funct:        in  std_logic_vector (5 downto 0); -- field in R-instructions
                ALUCtrl:      out std_logic_vector (3 downto 0);
                ShiftCtrl:    out std_logic_vector (1 downto 0);
                ResSrc:       out std_logic );
    end component;
	
	signal ALUOp_test, ALUCtrl_test: std_logic_vector(3 downto 0);
    signal funct_test: std_logic_vector(5 downto 0);
    signal ShiftCtrl_test: std_logic_vector(1 downto 0);
	signal ResSrc_test: std_logic;

begin

    control_alu_test: control_alu
        port map ( ALUOp => ALUOp_test,
                   funct => funct_test,
                   ALUCtrl => ALUCtrl_test,
                   ShiftCtrl => ShiftCtrl_test,
                   ResSrc => ResSrc_test );

    data_gen: process
    begin
        ALUOp_test <= "0000"; -- NOP
        wait for 10 ns;
        ALUOp_test <= "0001";
        funct_test <= "000000"; -- shift ll
        wait for 10 ns;
        funct_test <= "000001"; -- shift lr
        wait for 10 ns;
        funct_test <= "000010"; -- sum
        wait for 10 ns;
        funct_test <= "000011"; -- sub
        wait for 10 ns;
        funct_test <= "000100"; -- and
        wait for 10 ns;
        funct_test <= "000101"; -- or
        wait for 10 ns;
        funct_test <= "000110"; -- nand
        wait for 10 ns;
        funct_test <= "000111"; -- nor
        wait for 10 ns;
        funct_test <= "001000"; -- slt
        wait for 10 ns;
        funct_test <= "001111"; -- ???????
        wait for 10 ns;
        ALUOp_test <= "0010"; -- sum imm
        wait for 10 ns;
        ALUOp_test <= "0011"; -- sub imm
        wait for 10 ns;
        ALUOp_test <= "0100"; -- and imm
        wait for 10 ns;
        ALUOp_test <= "0101"; -- or imm
        wait for 10 ns;
        ALUOp_test <= "0110"; -- nand imm
        wait for 10 ns;
        ALUOp_test <= "0111"; -- nor imm
        wait for 10 ns;
        ALUOp_test <= "1000"; -- slt imm
        wait for 10 ns;
        ALUOp_test <= "1001"; -- load (ALU sum)
        wait for 10 ns;
        ALUOp_test <= "1010"; -- store (ALU sum)
        wait for 10 ns;
        ALUOp_test <= "1011"; -- beq (ALU sub)
        wait for 10 ns;
        ALUOp_test <= "1100"; -- bne (ALU sub)
        wait for 10 ns;
        ALUOp_test <= "1111"; -- ???????
        wait;
    end process;

end behav;