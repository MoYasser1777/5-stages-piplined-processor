LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DataMemory IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC; --I think it is dummy
        addr : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- Address input from the processor
        data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Data input from the processor
        read_en : IN STD_LOGIC;
        write_en : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Data output to the processor
    );
END DataMemory;

ARCHITECTURE Behavioral OF DataMemory IS
    TYPE Memory IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0); -- 4 KB memory with 16-bit width
    SIGNAL memory_array : Memory := (OTHERS => (OTHERS => '0')); -- Initialize memory
BEGIN

    PROCESS (write_en, read_en, data_in, addr)
    BEGIN
        --if rising_edge(clk) then
        IF write_en = '1' THEN -- Write to memory when write_en is asserted
            IF addr <= "111111111111" THEN -- Ensure the address is within the memory range
                memory_array(to_integer(unsigned((addr)))) <= data_in(15 DOWNTO 0); -- Store lower 16 bits
                memory_array(to_integer(unsigned((addr))) + 1) <= data_in(31 DOWNTO 16); -- Store upper 16 bits
            END IF;
        END IF;

        IF read_en = '1' THEN -- Read from memory when read_en is asserted
            IF addr <= "111111111111" THEN -- Ensure the address is within the memory range
                data_out <= memory_array(to_integer(unsigned((addr))) + 1) & memory_array(to_integer(unsigned((addr)))); -- Concatenate upper and lower 16 bits for 32-bit output
            END IF;
        END IF;
        -- end if;
    END PROCESS;
END Behavioral;