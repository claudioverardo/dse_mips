-- INSTRUCTION MEMORY
-- Byte-addressed memory
-- N=n*Byte parallelism

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_instr is
    -- N => bit parallelism and size of memory addresses (must be N % 8 == 0)
    -- in MIPS architecture they are the same
    generic (N : natural);
    port(   addr:   in  std_logic_vector (N-1 downto 0);
            instr:  out std_logic_vector (N-1 downto 0) );
end mem_instr;

architecture behav of mem_instr is
    
    -- bit parallelism
    constant WORD_SIZE : natural := N / 8;

    -- number of bytes in the memory (real)
    -- constant N_BYTE : natural := 2**N;
    
    -- number of bytes in the memory (to simulate, only 128 byte => ie 32 WORD)
    constant N_BYTE : natural := 2**7;

    -- struct for memory array
    type mem_instr_struct is array (0 to N_BYTE-1) of std_logic_vector (7 downto 0);
    signal mem_instr_array : mem_instr_struct := (others => (others =>'0'));

begin

    -- PROGRAM TO EXECUTE (32 bit instructions)
    -- per facilitare l'inserimento, gli indirizzi 0, 4, 8 ecc puntano al byte più significativo dell'istruzione
    -- si occupa poi il programma di estrarre dalla memoria i byte nel modo corretto
    mem_instr_array <= (    
                            "00001000", "00100001", "00000000", "00000100", -- R1 = R1 + 4
                            "00001000", "00100010", "00000000", "00001000", -- R2 = R1 + 8
                            "00000100", "00100010", "00011000", "00000010", -- R3 = R1 + R2
                            "00101000", "01100001", "00000000", "00000100", -- STORE R1, 4(R3)
                            "00100100", "01100100", "00000000", "00000100", -- LOAD R4, 4(R3)
                            "00001100", "10000001", "00000000", "00000010", -- R1 = R4 - 2
                            "00001000", "00100001", "00000000", "00000100", -- R1 = R1 + 4

                            --"00001000", "01100011", "00000000", "11100100", -- R3 = R3 + 228
                            --"00001000", "10000100", "00000000", "00011011", -- R4 = R4 + 27 
                            --"00000000", "00000000", "00000000", "00000000", -- NOP           
                            --"00000100", "00100010", "01000000", "00000010", -- R8 = R1 + R2  
                            --"00000100", "00100010", "01000000", "00000011", -- R8 = R1 - R2     
                            --"00000100", "00100010", "01000000", "00000100", -- R8 = R1 and R2     
                            --"00000100", "00100010", "01000000", "00000101", -- R8 = R1 or R2        
                            --"00000100", "00100010", "01000000", "00000110", -- R8 = R1 nand R2      
                            --"00000100", "00100010", "01000000", "00000111", -- R8 = R1 nor R2                   
                            --"00000100", "00100010", "01000000", "00001000", -- R8 = 1 if R1 < R2 else 0          
                            --"00000100", "01000001", "01000000", "00001000", -- R8 = 1 if R2 < R1 else 0                  
                            
                            --"00001000", "00100001", "00000000", "11111111", -- R1 = R1 + 255  --  0) PC = 0
                            --"00001000", "01000010", "00000000", "10100101", -- R2 = R2 + 165  --  1) PC = 4
                            --"00001000", "01100011", "00000000", "11100100", -- R3 = R3 + 228  --  2) PC = 8
                            --"00001000", "10000100", "00000000", "00011011", -- R4 = R4 + 27   --  3) PC = 12
                            --"00000100", "00000001", "00101001", "00000000", -- R5 = R1 << 4   --  4) PC = 16
                            ----"00000100", "00000001", "00101001", "00000001", -- R5 = R1 >> 4   --  4) PC = 16
                            --"00101000", "00000001", "00000000", "00000100", -- MEM(R0+4) = R1 --  5) PC = 20
                            --"00100100", "11100101", "00000000", "00000100", -- R5 = MEM(R7+4) --  6) PC = 24
                            ----"00101100", "01000011", "11111111", "11111000", -- BEQ R2 R3 -8   --  6) PC = 28
                            --"00110000", "01000011", "11111111", "11111000", -- BNE R2 R3 -8   --  7) PC = 28
                            --"00000000", "00000000", "00000000", "00000000", -- NOP            --  8) PC = 32
                            --"00000000", "00000000", "00000000", "00000000", -- NOP            --  9) PC = 36
                            --"00000000", "00000000", "00000000", "00000000", -- NOP            -- 10) PC = 40
                            others => "00000000" 
                        );

    process(addr)
    begin
        for i in 0 to WORD_SIZE-1 loop
            instr ((WORD_SIZE-i)*8-1 downto (WORD_SIZE-i-1)*8) <= mem_instr_array(to_integer(unsigned(addr)) + i);
            -- instr ((i+1)*8-1 downto i*8) <= mem_instr_array(to_integer(unsigned(addr)) + i); -- to reverse order
        end loop;
    end process;

end behav;