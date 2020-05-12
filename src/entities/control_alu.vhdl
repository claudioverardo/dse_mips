-- ALU CONTROL

library ieee;
use ieee.std_logic_1164.all;

entity control_alu is
    port (ALUOp:        in  std_logic_vector (3 downto 0); -- first 4 bit of OPCode
          funct:        in  std_logic_vector (5 downto 0); -- field in R-instructions
          ALUCtrl:      out std_logic_vector (3 downto 0);
          ShiftCtrl:    out std_logic_vector (1 downto 0);
          ResSrc:       out std_logic );
end control_alu;

architecture behav of control_alu is

begin

    process (ALUOp, funct)
    begin

        case ALUOp is
            
            when "0001" =>
                case funct is
                    -- shift ll
                    when "000000" => 
                        ALUCtrl <= "0000"; 
                        ShiftCtrl <= "01";
                        ResSrc <= '1';
                    -- shift rl
                    when "000001" => 
                        ALUCtrl <= "0000"; 
                        ShiftCtrl <= "10";
                        ResSrc <= '1';
                    -- sum, sub, and, or, nand, nor, slt
                    when "000010" | "000011" | "000100" | "000101" | "000110" | "000111" | "001000"  => 
                        ALUCtrl <= funct(3 downto 0); 
                        ShiftCtrl <= "00";
                        ResSrc <= '0';
                    when others => 
                        ALUCtrl <= "0000"; -- NOP
                        ShiftCtrl <= "00";
                        ResSrc <= '0';
                    end case;
            
            -- sum imm, sub imm, and imm, or imm, nand imm, nor imm, slt imm
            when "0010" | "0011" | "0100" | "0101" | "0110" | "0111" | "1000" => 
                ALUCtrl <= ALUOp;
                ShiftCtrl <= "00";
                ResSrc <= '0';
            
            -- load, store (ALU sum)
            when "1001" | "1010" => 
                ALUCtrl <= "0010";
                ShiftCtrl <= "00";
                ResSrc <= '0';
            
            -- beq, bne (ALU sub)
            when "1011" | "1100" =>
                ALUCtrl <= "0011";
                ShiftCtrl <= "00";
                ResSrc <= '0';
                
            when others => 
                ALUCtrl <= "0000"; -- NOP
                ShiftCtrl <= "00";
                ResSrc <= '0';

        end case;

    end process;

end behav;