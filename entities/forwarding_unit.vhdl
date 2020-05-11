-- FORWARDING UNIT

library ieee;
use ieee.std_logic_1164.all;

entity forwarding_unit is
    port(	-- ACTUAL SOURCES
            rs:             in  std_logic_vector(4 downto 0);
            rt:             in  std_logic_vector(4 downto 0);
            RegDst:         in  std_logic;
            -- FEEDBACK SOURCES
            mem_rd:         in  std_logic_vector(4 downto 0);
            mem_RegWrite:   in  std_logic;
            wb_rd:          in  std_logic_vector(4 downto 0);
            wb_RegWrite:    in  std_logic;
            -- FORWARDING CONTROL
            FwdSrc1:        out std_logic_vector(1 downto 0);
            FwdSrc2:        out std_logic_vector(1 downto 0) ); 
end forwarding_unit;

architecture behav of forwarding_unit is

begin

    process (rs, rt, RegDst, mem_rd, mem_RegWrite, wb_rd, wb_RegWrite)
    begin
        
        -- OPs that use both rs and rt as operands
        if (RegDst = '1') then

            -- FwdSrc1 (Rs)
            if (mem_RegWrite = '1' and mem_rd = rs) then
                FwdSrc1 <= "10";
            elsif (wb_RegWrite = '1' and wb_rd = rs) then
                FwdSrc1 <= "01";
            else 
                FwdSrc1 <= "00";
            end if;

            -- FwdSrc2 (Rt)
            if (mem_RegWrite = '1' and mem_rd = rt) then
                FwdSrc2 <= "10";
            elsif (wb_RegWrite = '1' and wb_rd = rt) then
                FwdSrc2 <= "01";
            else 
                FwdSrc2 <= "00";
            end if;

        -- OPs that use only rs as operand
        elsif (RegDst = '0') then

            -- FwdSrc1 (Rs)
            if (mem_RegWrite = '1' and mem_rd = rs) then
                FwdSrc1 <= "10";
            elsif (wb_RegWrite = '1' and wb_rd = rs) then
                FwdSrc1 <= "01";
            else 
                FwdSrc1 <= "00";
            end if;
            
            -- FwdSrc2 (Rt)
            FwdSrc2 <= "00";

		end if;

    end process;

end behav;