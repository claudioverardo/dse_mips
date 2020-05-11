-- 3 bit MULTIPLEXER (N bit ports)

library ieee;
use ieee.std_logic_1164.all;

entity mux3 is
    generic ( N : natural);
    port (  port1:      in  std_logic_vector (N-1 downto 0);
            port2:      in  std_logic_vector (N-1 downto 0);
            port3:      in  std_logic_vector (N-1 downto 0);
            sel:        in  std_logic_vector (1 downto 0);
            port_out:   out std_logic_vector (N-1 downto 0) );
end mux3;

architecture behav of mux3 is

begin

    process (sel,port1,port2)
    begin
        case sel is
            when "00" => port_out <= port1;
            when "01" => port_out <= port2;
            when "10" => port_out <= port3;
            when others => port_out <= (others => 'X');
        end case;
    end process;
        
end behav;