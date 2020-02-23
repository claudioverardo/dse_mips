-- REGISTER FILE
-- N_REG=2**N_ADDR registers with N_DATA bit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
    generic (N_ADDR: natural;
             N_DATA: natural );
    port (  addr_read1: in  std_logic_vector (N_ADDR-1 downto 0);
            addr_read2: in  std_logic_vector (N_ADDR-1 downto 0);
            addr_write: in  std_logic_vector (N_ADDR-1 downto 0);
            data_read1: out std_logic_vector (N_DATA-1 downto 0);
            data_read2: out std_logic_vector (N_DATA-1 downto 0);
            data_write: in  std_logic_vector (N_DATA-1 downto 0);
            RegWrite:   in  std_logic;
            rst:        in  std_logic );
end reg_file;

architecture behav of reg_file is

    -- number of registers
    constant N_REG : natural := 2**N_ADDR;
    
    -- struct for register file array
    type reg_file_struct is array (0 to N_REG-1) of std_logic_vector (N_DATA-1 downto 0);
    signal reg_file_array : reg_file_struct := (others => (others =>'0'));

begin

    process(rst, addr_read1, addr_read2, addr_write, data_write, RegWrite)
    begin
        if (rst = '1') then
            reg_file_array <= (others => (others =>'0'));
        else
            data_read1 <= reg_file_array(to_integer(unsigned(addr_read1)));
            data_read2 <= reg_file_array(to_integer(unsigned(addr_read2)));
            if (RegWrite = '1') then 
                reg_file_array(to_integer(unsigned(addr_write))) <= data_write;
            end if;
        end if;
    end process;

end behav;