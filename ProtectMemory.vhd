library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProtectMemory is
    Port (
        clk : in STD_LOGIC;
        addr : in STD_LOGIC_VECTOR(11 downto 0); -- Address input from the processor
        data_in : in STD_LOGIC; -- Data input from the processor
        read_en : in STD_LOGIC; --DUMMY
        write_en : in STD_LOGIC;
        data_out : out STD_LOGIC -- Data output to the processor
    );
end ProtectMemory;

architecture Behavioral of ProtectMemory is
    type Memory is array (0 to 4095) of STD_LOGIC; -- 4 KB memory with 1-bit width
    signal memory_array : Memory := (others => '0'); -- Initialize memory

begin
    process(write_en,addr,data_in)
    begin
            if write_en = '1' then -- Write to memory when write_en is asserted
                if addr <= "111111111111" then -- Ensure the address is within the memory range
                    memory_array(to_integer(unsigned((addr)))) <= data_in; -- Store 1 bit to lower address
                    
                end if;
            end if;
            if read_en = '1' then
            if addr <= "111111111111" then -- Ensure the address is within the memory range
                data_out <= memory_array(to_integer(unsigned((addr))));-- read 1 bit crosponding to lower address in datamemory
            end if;
        end if;
    end process;
end Behavioral;

