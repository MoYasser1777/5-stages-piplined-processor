LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY write_back_stage IS
    PORT (
        clk : IN STD_LOGIC;
        in_port_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        M_WB : IN STD_LOGIC_VECTOR(109 DOWNTO 0);
        write1_address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        write1_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write2_address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        write2_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        branch_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        rw1 : OUT STD_LOGIC; --M_WB(0)
        rw2 : OUT STD_LOGIC; --M_WB(1)
        stack_operation : OUT STD_LOGIC; --M_WB(4)
        stack_op_type : OUT STD_LOGIC --M_WB(5)           
    );
END write_back_stage;

ARCHITECTURE write_back_stage_arch OF write_back_stage IS
    SIGNAL write1_address_internal : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL write1_data_internal : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

    PROCESS (clk)
    BEGIN
        IF ((rising_edge(clk))) THEN
            IF (M_WB(3) = '0' AND M_WB(2) = '0') THEN --ior AND mem2reg
                write1_data <= M_WB(39 DOWNTO 8); --alu_out1
            ELSIF M_WB(3) = '0' AND M_WB(2) = '1' THEN --ior AND mem2reg
                write1_data <= M_WB(103 DOWNTO 72); --read_memory_data
            ELSE
                write1_data <= in_port_data;
            END IF;
            --out data and address

            --branch
            branch_address <= (OTHERS => '0'); --to be updated
            write1_address <= M_WB(109 DOWNTO 107); --rdest_address
            write2_address <= M_WB(106 DOWNTO 104); --rsrc_address
            write2_data <= M_WB(71 DOWNTO 40); --alu_out2
            --out signals
            rw1 <= M_WB(0);
            rw2 <= M_WB(1);
            stack_operation <= M_WB(4);
            stack_op_type <= M_WB(5);
        END IF;

    END PROCESS;
    -- reset <= M_WB(7);   

END write_back_stage_arch;