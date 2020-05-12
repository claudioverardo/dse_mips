-- HAZARD DETECTION UNIT

library ieee;
use ieee.std_logic_1164.all;

entity hazard_unit is
    port(	-- HAZARD CHECK DATA
            OPCode:         in  std_logic_vector(5 downto 0);
            rs:             in  std_logic_vector(4 downto 0);
            rt:             in  std_logic_vector(4 downto 0);
            ex_MemRead:     in  std_logic;
            ex_rt:          in  std_logic_vector(4 downto 0);
            ex_Branch:      in  std_logic;
            mem_Branch:     in  std_logic;
            wb_Branch:      in  std_logic;
            -- HAZARD CONTROL
            Bubble:         out std_logic;
            pc_wrt:         out std_logic;
            if_id_wrt:      out std_logic ); 
end hazard_unit;

architecture behav of hazard_unit is

begin
    
    process (OPCode, rs, rt, ex_MemRead, ex_rt, ex_Branch, mem_Branch, wb_Branch)
    begin

        -- DATA HAZARDS

        if (ex_MemRead = '1') then
    
            case OPCode is

                -- OPs that use both rs and rt as operands
                when "000001" | "001010" | "001011" | "001100" =>

                    if (rs = ex_rt or rt = ex_rt) then
                        Bubble <= '1';
                        pc_wrt <= '0';
                        if_id_wrt <= '0';
                    else
                        Bubble <= '0';
                        pc_wrt <= '1';
                        if_id_wrt <= '1';
                    end if;

                -- OPs that use only rs as operand
                when "000010" | "000011" | "000100" | "000101" | "000110" | "000111" | "001000" | "001001" =>

                    if (rs = ex_rt) then
                        Bubble <= '1';
                        pc_wrt <= '0';
                        if_id_wrt <= '0';
                    else
                        Bubble <= '0';
                        pc_wrt <= '1';
                        if_id_wrt <= '1';
                    end if;
                
            when others =>

                Bubble <= '0';
                pc_wrt <= '1';
                if_id_wrt <= '1';

            end case;

        else 

            Bubble <= '0';
            pc_wrt <= '1';
            if_id_wrt <= '1';

        end if;
        

        -- CONTROL HAZARDS

        if (ex_Branch = '1') then
            Bubble <= '1';
            pc_wrt <= '0';
            if_id_wrt <= '0';
        elsif (mem_Branch = '1') then
            Bubble <= '1';
            pc_wrt <= '1';
            if_id_wrt <= '0';
        elsif (wb_Branch = '1') then
            Bubble <= '1';
            pc_wrt <= '1';
            if_id_wrt <= '1';
        end if;
   
    end process;
    
end behav;