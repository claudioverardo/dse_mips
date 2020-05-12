-- DATA MEMORY
-- Byte-addressed memory
-- N=n*Byte parallelism

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_data is
    -- N => bit parallelism and size of memory addresses (must be N % 8 == 0)
    -- in MIPS architecture they are the same
    generic (N : natural);
    port(   addr:       in  std_logic_vector (N-1 downto 0);
            data_write: in  std_logic_vector (N-1 downto 0);
            data_read:  out std_logic_vector (N-1 downto 0);
            MemWrite:   in  std_logic;
            MemRead:    in  std_logic );
end mem_data;

architecture behav of mem_data is
    
    -- bit parallelism
    constant WORD_SIZE : natural := N / 8;

    -- number of bytes in the memory (real)
    -- constant N_BYTE : natural := 2**N;
    
    -- number of bytes in the memory (to simulate, only 64 byte)
    constant N_BYTE : natural := 2**6;

    -- struct for memory array
    type mem_data_struct is array (0 to N_BYTE-1) of std_logic_vector (7 downto 0);
    signal mem_data_array : mem_data_struct := (others => (others =>'0'));
    
begin

    -- per facilitare la lettura, gli indirizzi 0, 4, 8 ecc puntano al byte più significativo del dato
    -- si occupa poi il programma di leggere/scrivere in memoria i byte nel modo corretto
    process(addr, MemWrite, MemRead)
    begin
        if (MemRead = '1' and MemWrite = '0') then 
            for i in 0 to WORD_SIZE-1 loop
                data_read ((WORD_SIZE-i)*8-1 downto (WORD_SIZE-i-1)*8) <= mem_data_array(to_integer(unsigned(addr)) + i);
                -- data_read ((i+1)*8-1 downto i*8) <= mem_data_array(to_integer(unsigned(addr)) + i); -- to reverse order
            end loop;
        elsif (MemRead = '0' and MemWrite = '1') then
            data_read <= (others => 'Z');
            for i in 0 to WORD_SIZE-1 loop
                mem_data_array(to_integer(unsigned(addr)) + i) <= data_write ((WORD_SIZE-i)*8-1 downto (WORD_SIZE-i-1)*8);
                -- mem_data_array(to_integer(unsigned(addr)) + i) <= data_write ((i+1)*8-1 downto i*8); -- to reverse order
            end loop;
        else
            data_read <= (others => 'Z');
        end if;
    end process;

end behav;