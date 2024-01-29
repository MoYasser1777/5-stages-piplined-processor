LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Memory IS
    PORT (
        clk : IN STD_LOGIC;
        EX_M : IN STD_LOGIC_VECTOR(162 DOWNTO 0); -- Data output to the processor
        M_WB : OUT STD_LOGIC_VECTOR(109 DOWNTO 0); -- Data output to the processor
        ALU_out : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        Rsrc1_dest : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        RW1MEM, RW2MEM : OUT STD_LOGIC
    );
END Memory;

ARCHITECTURE Behavioral OF Memory IS

    --Flags signals 
    --SIGNAL read_en_dm_flag : STD_LOGIC; -- Read enable for DataMemory
    --SIGNAL write_en_dm_flag : STD_LOGIC; -- Write enable for DataMemory
    --SIGNAL write_en_reg1 : STD_LOGIC; -- Read enable for DataMemory
    --SIGNAL write_en_reg2 : STD_LOGIC; -- Write enable for DataMemory
    --SIGNAL M_to_R : STD_LOGIC; -- Read enable for DataMemory
    --SIGNAL write_PC : STD_LOGIC; -- Write enable for DataMemory
    --SIGNAL in_out_read : STD_LOGIC; -- Read enable for DataMemory
    --SIGNAL stack_op : STD_LOGIC; -- Write enable for DataMemory
    --SIGNAL stack_op_type : STD_LOGIC; -- Read enable for DataMemory
    --SIGNAL in_out_write : STD_LOGIC; -- Write enable for DataMemory
    --SIGNAL uncondB : STD_LOGIC; -- Read enable for DataMemory
    --SIGNAL free_protect_en : STD_LOGIC; -- Write enable for DataMemory
    --SIGNAL free_protect_type : STD_LOGIC; -- Read enable for DataMemory
    --SIGNAL reset : STD_LOGIC; -- Write enable for DataMemory
    --SIGNAL int : STD_LOGIC; -- Write enable for DataMemory
    --dataMemory inputs
    SIGNAL reset_dm : STD_LOGIC; -- Reset signal for DataMemory
    SIGNAL addr_dm : STD_LOGIC_VECTOR(11 DOWNTO 0); -- Address for DataMemory
    SIGNAL data_in_dm : STD_LOGIC_VECTOR(31 DOWNTO 0); -- Data input for DataMemory
    SIGNAL read_en_dm : STD_LOGIC; -- Read enable for DataMemory
    SIGNAL write_en_dm : STD_LOGIC; -- Write enable for DataMemory
    SIGNAL data_out_dm : STD_LOGIC_VECTOR(31 DOWNTO 0); -- Data output from DataMemory

    --protect memory inputs
    SIGNAL addr_pm : STD_LOGIC_VECTOR(11 DOWNTO 0); -- Address for ProtectMemory
    SIGNAL data_in_pm : STD_LOGIC; -- Data input for ProtectMemory
    SIGNAL read_en_pm : STD_LOGIC := '1'; -- Read enable for ProtectMemory
    SIGNAL write_en_pm : STD_LOGIC; -- Write enable for ProtectMemory
    SIGNAL data_out_pm : STD_LOGIC; -- Data output from ProtectMemory

    -- Stackpointer inputs and outputs
    SIGNAL SP_sig : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111111111110"; -- Input for setting stack pointer
    SIGNAL out_sp : STD_LOGIC_VECTOR(31 DOWNTO 0); -- Output for reading stack pointer
    -- General signals purpose 
    --SIGNAL EA : STD_LOGIC_VECTOR(11 DOWNTO 0); --effective address
    --SIGNAL Rsrc1_addr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    --SIGNAL Rdst_addr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    --SIGNAL Rdst : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --SIGNAL PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --SIGNAL added_SP : STD_LOGIC_VECTOR(31 DOWNTO 0); -- out of mux of push op
    ---SIGNAL flags : STD_LOGIC_VECTOR(2 DOWNTO 0); -- zero , carry , negative flag

    --SIGNAL imm_addr : STD_LOGIC_VECTOR(11 DOWNTO 0); -- out of muc that become input for addres datamemoty
    --SIGNAL imm_addr_sp : STD_LOGIC_VECTOR(31 DOWNTO 0); -- out from mux of pop
    --SIGNAL sub_SP : STD_LOGIC;
    --SIGNAL add_SP : STD_LOGIC;

    --SIGNAL concatenated_int_uncondB : STD_LOGIC_VECTOR(1 DOWNTO 0);

    CONSTANT subtract_value : signed(31 DOWNTO 0) := to_signed(2, 32); -- Constant value 2
    CONSTANT add_value_PC : signed(31 DOWNTO 0) := to_signed(1, 32); -- Constant value 1
    COMPONENT DataMemory IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC; --I think it is dummy
            addr : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- Address input from the processor
            data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Data input from the processor
            read_en : IN STD_LOGIC;
            write_en : IN STD_LOGIC;
            data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Data output to the processor
        );
    END COMPONENT;

    COMPONENT ProtectMemory IS
        PORT (
            clk : IN STD_LOGIC;
            addr : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- Address input from the processor
            data_in : IN STD_LOGIC; -- Data input from the processor
            read_en : IN STD_LOGIC; --DUMMY
            write_en : IN STD_LOGIC;
            data_out : OUT STD_LOGIC -- Data output to the processor
        );
    END COMPONENT;

    COMPONENT StackPointer IS
        PORT (
            sp_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input for setting stack pointer
            sp_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Output for reading stack pointer
        );
    END COMPONENT;

BEGIN
    DataMemory_inst : DataMemory PORT MAP(
        clk => clk,
        reset => reset_dm,
        addr => addr_dm,
        data_in => data_in_dm,
        read_en => read_en_dm,
        write_en => write_en_dm,
        data_out => M_WB(103 DOWNTO 72)
    );

    ProtectMemory_inst : ProtectMemory PORT MAP(
        clk => clk,
        addr => addr_pm, -- Address input from the processor
        data_in => data_in_pm, -- Data input from the processor
        read_en => read_en_pm, --DUMMY
        write_en => write_en_pm,
        data_out => data_out_pm -- Data output to the processor
    );
    -- StackPointer_inst : StackPointer PORT MAP(
    --     sp_in => in_sp, -- Input for setting stack pointer
    --     sp_out => out_sp -- Output for reading stack pointer
    -- );

    PROCESS (clk)

        --control signals  variables
        VARIABLE read_en_dm_flag : STD_LOGIC;
        VARIABLE write_en_dm_flag : STD_LOGIC;
        VARIABLE write_en_reg1 : STD_LOGIC;
        VARIABLE write_en_reg2 : STD_LOGIC;
        VARIABLE M_to_R : STD_LOGIC;
        VARIABLE write_PC : STD_LOGIC;
        VARIABLE in_out_read : STD_LOGIC;
        VARIABLE stack_op : STD_LOGIC;
        VARIABLE stack_op_type : STD_LOGIC;
        VARIABLE in_out_write : STD_LOGIC;
        VARIABLE uncondB : STD_LOGIC;
        VARIABLE free_protect_en : STD_LOGIC;
        VARIABLE free_protect_type : STD_LOGIC;
        VARIABLE reset : STD_LOGIC;
        VARIABLE int : STD_LOGIC;
        --general varaiables
        VARIABLE EA : STD_LOGIC_VECTOR(11 DOWNTO 0);
        VARIABLE Rsrc1_addr : STD_LOGIC_VECTOR(2 DOWNTO 0);
        VARIABLE Rdst_addr : STD_LOGIC_VECTOR(2 DOWNTO 0);
        VARIABLE Rdst : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE added_SP : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
        VARIABLE restor_flags : STD_LOGIC;
        VARIABLE imm_addr : STD_LOGIC_VECTOR(11 DOWNTO 0);
        VARIABLE imm_addr_sp : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE sub_SP : STD_LOGIC;
        VARIABLE add_SP : STD_LOGIC;
        VARIABLE SP : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111111111111";
    BEGIN
        IF rising_edge(clk) THEN
            --pass values that don't modified in memory to M_WB register 
            M_WB(5 DOWNTO 0) <= EX_M(7 DOWNTO 2); -- 7 Signals
            M_WB(7 DOWNTO 6) <= EX_M(11 DOWNTO 10); --write_PC & reset signal
            M_WB(71 DOWNTO 8) <= EX_M(89 DOWNTO 26); -- 64 ALU OUTs ou1 & out2
            M_WB(109 DOWNTO 104) <= EX_M(95 DOWNTO 90); -- 6 bits Rsrc1 , Rdst
            --recieve values from register
            read_en_dm_flag := EX_M(0); -- read_en_datamemory directly
            write_en_dm_flag := EX_M(1);
            write_en_reg1 := EX_M(2);
            write_en_reg2 := EX_M(3);
            M_to_R := EX_M(4);
            in_out_read := EX_M(5);
            stack_op := EX_M(6);
            stack_op_type := EX_M(7);
            free_protect_en := EX_M(8);
            free_protect_type := EX_M(9); -- input data for protect memory directly if it 0 or 1 and ready for enable 
            write_PC := EX_M(10);
            reset := EX_M(11);
            int := Ex_M(12);
            restor_flags := EX_M(13);

            EA := EX_M(25 DOWNTO 14);

            Rsrc1_addr := EX_M(92 DOWNTO 90);
            Rdst_addr := EX_M(95 DOWNTO 93);
            Rdst := EX_M(127 DOWNTO 96);
            PC := Ex_M(159 DOWNTO 128);
            flags := EX_M(162 DOWNTO 160);

            --Flags that go to its values without logic 

            data_in_pm <= free_protect_type;
            read_en_dm <= read_en_dm_flag;

            --Multplixers 
            IF stack_op = '1' AND stack_op_type = '0' THEN
                SP := STD_LOGIC_VECTOR(unsigned(SP) - 2);
            END IF;

            CASE stack_op IS
                WHEN '0' =>
                    addr_dm <= EA;
                    imm_addr := EA;
                WHEN '1' =>
                    addr_dm <= SP;
                    imm_addr := SP;
                WHEN OTHERS =>
                    addr_dm <= (OTHERS => '0'); -- Default case
                    imm_addr := (OTHERS => '0'); -- Default case
            END CASE;

            --write_en_pm <= EX_M(8); -- enable for protect memory
            CASE free_protect_en IS
                WHEN '0' =>
                    addr_pm <= imm_addr;
                WHEN '1' =>
                    addr_pm <= Rdst(31 DOWNTO 20);
                WHEN OTHERS =>
                    addr_pm <= (OTHERS => '0'); -- Default case
            END CASE;
            write_en_pm <= free_protect_en;

            IF stack_op_type = '0' THEN --to handle if pop in ret then dont write PC again just pop and make its place = 0's
                CASE write_PC IS
                    WHEN '0' =>
                        data_in_dm <= Rdst;
                    WHEN '1' =>
                        data_in_dm <= STD_LOGIC_VECTOR((unsigned(PC) + 1));
                    WHEN OTHERS =>
                        data_in_dm <= (OTHERS => '0'); -- Default case
                END CASE;
            END IF;

            write_en_dm <= (NOT data_out_pm) AND write_en_dm_flag; -- write enable value after setting write data
            IF stack_op = '1' AND stack_op_type = '1' THEN
                data_in_dm <= (OTHERS => '0');
                SP := STD_LOGIC_VECTOR(unsigned(SP) + 2); -- take the added one that is pop operation
            END IF;

        END IF;
    END PROCESS;
    Rsrc1_dest <= EX_M(95 DOWNTO 90); -- hazards
    ALU_out <= EX_M(89 DOWNTO 26);
    RW1MEM <= EX_M(2);
    RW2MEM <= EX_M(3);
END Behavioral;