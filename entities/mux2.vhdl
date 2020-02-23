-- 2 bit MULTIPLEXER (N bit ports)

library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
    generic ( N : natural);
    port (  port1:      in  std_logic_vector (N-1 downto 0);
            port2:      in  std_logic_vector (N-1 downto 0);
            sel:        in  std_logic;
            port_out:   out std_logic_vector (N-1 downto 0) );
end mux2;

architecture behav of mux2 is

begin

    process (sel,port1,port2)
    begin
        case sel is
            when '0' => port_out <= port1;
            when '1' => port_out <= port2;
            when others => port_out <= (others => 'X');
        end case;
    end process;
        
end behav;