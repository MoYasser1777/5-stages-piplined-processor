LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fetch_stage IS
    PORT (
        branch_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        writepc : IN STD_LOGIC;
        pcAdditionEnable : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        instruction_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        pc_output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        IF_ID : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        uncond : IN STD_LOGIC
    );
END fetch_stage;

ARCHITECTURE fetchStageArch OF fetch_stage IS
    SIGNAL pc_address : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL instruction_out_internal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL prev_instruction_out_internal : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL isIMM : STD_LOGIC := '0';

    COMPONENT instruction_memory
        PORT (
            read_address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    IM_inst : instruction_memory
    PORT MAP(
        read_address => pc_address(15 DOWNTO 0),
        instruction => instruction_out_internal
    );

    PROCESS (clk, writepc)
    BEGIN
        IF rising_edge(clk) THEN
            IF (reset = '1') THEN
                pc_address <= (OTHERS => '0');
            ELSIF (writepc = '0') THEN
                IF (pcAdditionEnable = '1') THEN
                    pc_address <= STD_LOGIC_VECTOR(unsigned(pc_address) + 1);
                    IF instruction_out_internal(0) = '1' AND isIMM = '0' THEN
                        isIMM <= '1';
                        instruction_out <= (OTHERS => '0');
                        IF_ID (31 DOWNTO 0) <= (OTHERS => '0');
                        prev_instruction_out_internal <= instruction_out_internal;
                    ELSIF isIMM = '1' THEN
                        isIMM <= '0';
                        instruction_out <= instruction_out_internal & prev_instruction_out_internal;
                        IF_ID (31 DOWNTO 0) <= instruction_out_internal & prev_instruction_out_internal;
                    ELSIF isIMM = '0' THEN
                        isIMM <= '0';
                        instruction_out <= "0000000000000000" & instruction_out_internal;
                        IF_ID (31 DOWNTO 0) <= "0000000000000000" & instruction_out_internal;
                    END IF;
                END IF;
            ELSIF ((writepc = '1') OR (uncond = '1')) THEN
                pc_address <= branch_address;
                IF instruction_out_internal(0) = '1' AND isIMM = '0' THEN
                    isIMM <= '1';
                    instruction_out <= (OTHERS => '0');
                    IF_ID (31 DOWNTO 0) <= (OTHERS => '0');
                    prev_instruction_out_internal <= instruction_out_internal;
                ELSIF isIMM = '1' THEN
                    isIMM <= '0';
                    instruction_out <= instruction_out_internal & prev_instruction_out_internal;
                    IF_ID (31 DOWNTO 0) <= instruction_out_internal & prev_instruction_out_internal;
                ELSIF isIMM = '0' THEN
                    isIMM <= '0';
                    instruction_out <= "0000000000000000" & instruction_out_internal;
                    IF_ID (31 DOWNTO 0) <= "0000000000000000" & instruction_out_internal;
                END IF;

            END IF;

        END IF;
    END PROCESS;

    pc_output <= pc_address;
    IF_ID (63 DOWNTO 32) <= pc_address;

END fetchStageArch;