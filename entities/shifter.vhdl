-- SHIFTER MIPS

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
    port (  shamt:      in  std_logic_vector (4 downto 0);
            rt:         in  std_logic_vector (31 downto 0);
            ShiftCtrl:  in  std_logic_vector (1 downto 0);
            result:     out std_logic_vector (31 downto 0)  );
end shifter;

architecture behav of shifter is

begin

    process (shamt, rt, ShiftCtrl)
    begin
        
        case ShiftCtrl is
            
            when "00" | "11" => result <= rt;

            -- shift left l
            when "01" => result <= std_logic_vector(shift_left(unsigned(rt), to_integer(unsigned(shamt))));
            
            -- shift right l
            when "10" => result <= std_logic_vector(shift_right(unsigned(rt), to_integer(unsigned(shamt))));

            when others => result <= (others => 'U');
        
        end case;

    end process;

end behav;