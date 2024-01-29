library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity StackPointer is
    Port (
        sp_in : in STD_LOGIC_VECTOR(31 downto 0); -- Input for setting stack pointer
        sp_out : out STD_LOGIC_VECTOR(31 downto 0) -- Output for reading stack pointer
    );
end StackPointer;

architecture Behavioral of StackPointer is
    signal stack_pointer : unsigned(31 downto 0); -- 32-bit stack pointer

begin
    -- Initialization block runs only once at the start of running
    initialize_sp : process
    begin
        stack_pointer <= to_unsigned(2**12 - 1, 32); -- Initialize stack pointer to (2^12 - 1)
        wait;
    end process initialize_sp;

    -- Set stack pointer using input port
    process(sp_in)
    begin
        stack_pointer <= unsigned(sp_in);
    end process;

    -- Output the current value of the stack pointer
    sp_out <= std_logic_vector(stack_pointer);

end Behavioral;
