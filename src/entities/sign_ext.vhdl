-- N_in => N_out bit SIGN EXTENSION

library ieee;
use ieee.std_logic_1164.all;

entity sign_ext is
    generic( N_in: natural;
             N_out: natural );
    port(   val_in : in  std_logic_vector (N_in-1 downto 0);
            val_out: out std_logic_vector (N_out-1 downto 0));
end sign_ext;

architecture behav of sign_ext is

begin
      
    val_out <= (N_out-1 downto N_in => val_in (N_in-1) ) & val_in;
    
end behav;