LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY instruction_memory IS
    PORT (
        read_address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END instruction_memory;

ARCHITECTURE instruction_memory_arch OF instruction_memory IS
    CONSTANT DATA_WIDTH : INTEGER := 16;
    CONSTANT MEMORY_SIZE : INTEGER := 2048;

    TYPE RAM_2048_X_16 IS ARRAY (0 TO MEMORY_SIZE - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

    IMPURE FUNCTION InitRamFromFile (RamFileName : IN STRING) RETURN RAM_2048_X_16 IS
        FILE RamFile : TEXT OPEN READ_MODE IS RamFileName;
        VARIABLE RamFileLine : LINE;
        VARIABLE RAM : RAM_2048_X_16;
    BEGIN
        FOR I IN RAM_2048_X_16'RANGE LOOP
            READLINE (RamFile, RamFileLine);
            READ (RamFileLine, RAM(I));
        END LOOP;
        RETURN RAM;
    END FUNCTION;

    SIGNAL instruction_memory_data : RAM_2048_X_16 := InitRamFromFile("asm.data");

BEGIN
    instruction <= instruction_memory_data(to_integer(unsigned(read_address)));
END instruction_memory_arch;