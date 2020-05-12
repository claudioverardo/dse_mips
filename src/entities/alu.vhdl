-- ALU

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    generic ( N: natural );
    port (  data1:    in     std_logic_vector (N-1 downto 0);
            data2:    in     std_logic_vector (N-1 downto 0);
            ALUCtrl:  in     std_logic_vector (3 downto 0);
            result:   buffer std_logic_vector (N-1 downto 0);
            zero:     out    std_logic );
end alu;

architecture behav of alu is

begin

    process (data1,data2,ALUCtrl,result)
    begin

        case ALUCtrl is

            when "0000" => result <= (others => '0');
            -- when "0001" => FREE
            when "0010" => result <= std_logic_vector(signed(data1) + signed(data2));
            when "0011" => result <= std_logic_vector(signed(data1) - signed(data2));
            when "0100" => result <= data1 and data2;
            when "0101" => result <= data1 or data2;
            when "0110" => result <= data1 nand data2;
            when "0111" => result <= data1 nor data2;
            when "1000" =>  if ( signed(data1) < signed(data2) ) then
                                result <= (N-1 downto 1 => '0') & '1';
                            else 
                                result <= (others => '0');
                            end if;
                            
            when others => result <= (others => 'U');

        end case;

        if ( signed(result) = 0 ) then
            zero <= '1';
        else 
            zero <= '0';
        end if;

    end process;

end behav;