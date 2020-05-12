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
                            -- SUCCESSIONE DI FIBONACCI, calcolo di F(N)
                            "00001000", "00000000", "00000000", "00001010", --  0) R0 = R0 + 10 --> N-esimo numero da ricavare
                            "00001000", "00100001", "00000000", "00000001", --  4) R1 = R1 + 1  --> contatore
                            "00001000", "01000010", "00000000", "00000100", --  8) R2 = R2 + 4  --> indirizzo in cui salvare in memoria
                            "00001000", "01100011", "00000000", "00000000", -- 12) R3 = R3 + 0  --> F(0)
                            "00001000", "10000100", "00000000", "00000001", -- 16) R4 = R4 + 1  --> F(1)
                            "00000100", "01100100", "00101000", "00000010", -- 20) LOOP: R5 = R3 + R4
                            "00001000", "10000011", "00000000", "00000000", -- 24) R3 = R4 + 0
                            "00001000", "10100100", "00000000", "00000000", -- 28) R4 = R5 + 0
                            "00001000", "00100001", "00000000", "00000001", -- 32) R1 = R1 + 1
                            "00110000", "00100000", "11111111", "11111011", -- 36) BNE R1, R0 -5 (LOOP)
                            "00101000", "01000101", "00000000", "00000000", -- 40) END: STORE R5, 0(R2)

                            -- TEST HAZARD DETECTION + FORWARDING
                            -- "00001000", "00100001", "00000000", "00000100", -- R1 = R1 + 4
                            -- "00001000", "00100010", "00000000", "00001000", -- R2 = R1 + 8
                            -- "00000100", "00100010", "00011000", "00000010", -- R3 = R1 + R2
                            -- "00101000", "01100001", "00000000", "00000100", -- STORE R1, 4(R3)
                            -- "00100100", "01100100", "00000000", "00000100", -- LOAD R4, 4(R3)
                            -- "00001100", "10000001", "00000000", "00000010", -- R1 = R4 - 2
                            -- "00001000", "00100001", "00000000", "00000100", -- R1 = R1 + 4

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