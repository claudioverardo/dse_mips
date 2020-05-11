-- CENTRAL CONTROL UNIT

library ieee;
use ieee.std_logic_1164.all;

entity control is
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
end control;

architecture behav of control is

begin

    process (OPCode)
    begin

        case OPCode is

            -- ARITHMETICS
            -- SHIFT LL, SHIFT RL, ADD, SUM, AND, OR, NAND, NOR, SLT
            when "000001" => 
                ALUSrc <= '0';
                RegDst <= '1';
                ALUOp <= OPCode(3 downto 0);
                BranchNE <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                RegWrite <= '1';
            
            -- IMMEDIATE ARITHMETICS
            -- ADD IM, SUM IM, AND IM, OR IM, NAND IM, NOR IM, SLT IM
            when "000010" | "000011" | "000100" | "000101" | "000110" | "000111" | "001000" =>
                ALUSrc <= '1';
                RegDst <= '0';
                ALUOp <= OPCode(3 downto 0);
                BranchNE <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                RegWrite <= '1';

            -- LOAD
            when "001001"  => 
                ALUSrc <= '1';
                RegDst <= '0';
                ALUOp <= OPCode(3 downto 0);
                BranchNE <= '0';
                Branch <= '0';
                MemRead <= '1';
                MemWrite <= '0';
                MemToReg <= '1';
                RegWrite <= '1';

            -- STORE
            when "001010" => 
                ALUSrc <= '1';
                RegDst <= '1'; -- DON'T CARE (see "instruction_set.xlsx")
                ALUOp <= OPCode(3 downto 0);
                BranchNE <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '1';
                MemToReg <= '0';
                RegWrite <= '0';

            -- BRANCH BEQ
            when "001011" =>
                ALUSrc <= '0';
                RegDst <= '1'; -- DON'T CARE (see "instruction_set.xlsx")
                ALUOp <= OPCode(3 downto 0);
                BranchNE <= '0';
                Branch <= '1';
                MemRead <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                RegWrite <= '0';
            
            -- BRANCH BNE
            when "001100" => 
                ALUSrc <= '0';
                RegDst <= '1'; -- DON'T CARE (see "instruction_set.xlsx")
                ALUOp <= OPCode(3 downto 0);
                BranchNE <= '1'; -- WARNING (See EX Stage)
                Branch <= '1';
                MemRead <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                RegWrite <= '0';

            -- NO OPERATION
            when others =>
                ALUSrc <= '0';
                RegDst <= '0';
                ALUOp <= "0000";
                BranchNE <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                RegWrite <= '0';

        end case;

    end process;

end behav;