LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY main IS
    PORT (
        reset : IN STD_LOGIC;
        clk, enable : IN STD_LOGIC;
        in_port_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        outPortData : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        outPortEnable : OUT STD_LOGIC
    );
END main;

ARCHITECTURE main_arch OF main IS
    SIGNAL inst_out : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc_address_out : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL IF_ID_out : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL D_ERegister : STD_LOGIC_VECTOR(196 DOWNTO 0);
    SIGNAL E_MRegister : STD_LOGIC_VECTOR(162 DOWNTO 0);
    SIGNAL M_WB : STD_LOGIC_VECTOR(109 DOWNTO 0);
    SIGNAL regWrite1, regWrite2 : STD_LOGIC;
    SIGNAL RdstWrite1, RdstWrite2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL write1_data, write2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL stack_operation, stack_op_type : STD_LOGIC;
    SIGNAL branch_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pcAdditionEnable, writepc : STD_LOGIC;
    SIGNAL jumpZeroSignal : STD_LOGIC;
    SIGNAL Rsrc1MEM, RdstMEM, Rsrc1WB, RdstWB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL RW1MEM, RW2MEM, RW1WB, RW2WB : STD_LOGIC;
    SIGNAL Out1MEM, Out2MEM, Out1WB, Out2WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALU_out : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL Rsrc1_dest : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL dataMemoryRead, uncond : STD_LOGIC;
    SIGNAL Rdst_loadUse : STD_LOGIC_VECTOR(2 DOWNTO 0);

    COMPONENT fetch_stage
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
    END COMPONENT;

    COMPONENT decodeStage
        PORT (
            clk, rst, jumpZeroSignal, enable, regWrite1, regWrite2 : IN STD_LOGIC;
            RdstWrite1, RdstWrite2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Rdst_D_E : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            dataMemoryRead : IN STD_LOGIC;
            writeBackData1, writeBackData2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            F_DRegister : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
            D_ERegister : OUT STD_LOGIC_VECTOR(196 DOWNTO 0);
            reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            pcAdditionEnable, uncond : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT executeStage
        PORT (
            clk : IN STD_LOGIC;
            decodeExecuteRegister : IN STD_LOGIC_VECTOR (196 DOWNTO 0);
            executeMemoryRegister : OUT STD_LOGIC_VECTOR (162 DOWNTO 0);
            outPortData : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            jumpZeroSignal : OUT STD_LOGIC;
            Rsrc1MEM, RdstMEM, Rsrc1WB, RdstWB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            RW1MEM, RW2MEM, RW1WB, RW2WB : IN STD_LOGIC;
            Out1MEM, Out2MEM, Out1WB, Out2WB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            inPortData : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            dataMemoryRead : OUT STD_LOGIC;
            Rdst_loadUse : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Memory
        PORT (
            clk : IN STD_LOGIC;
            EX_M : IN STD_LOGIC_VECTOR(162 DOWNTO 0); -- Data output to the processor
            M_WB : OUT STD_LOGIC_VECTOR(109 DOWNTO 0); -- Data output to the processor
            ALU_out : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
            Rsrc1_dest : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            RW1MEM, RW2MEM : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT write_back_stage
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
    END COMPONENT;

BEGIN

    fetch_inst : fetch_stage
    PORT MAP(
        branch_address,
        jumpZeroSignal,
        pcAdditionEnable,
        reset,
        clk,
        inst_out,
        pc_address_out,
        IF_ID_out,
        uncond
    );

    -- Instantiate decodeStage
    decode_inst : decodeStage
    PORT MAP(
        clk, reset, jumpZeroSignal, enable, regWrite1, regWrite2,
        RdstWrite1, RdstWrite2,
        Rdst_loadUse,
        dataMemoryRead,
        write1_data,
        write2_data,
        IF_ID_out,
        D_ERegister,
        reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7,
        pcAdditionEnable,
        uncond
    );

    execute_inst : executeStage
    PORT MAP(
        clk,
        D_ERegister,
        E_MRegister,
        outPortData,
        jumpZeroSignal,
        Rsrc1_dest(2 DOWNTO 0), Rsrc1_dest(5 DOWNTO 3),
        RdstWrite1, RdstWrite2,
        RW1MEM, RW2MEM, regWrite1, regWrite2,
        ALU_out(31 DOWNTO 0), ALU_out(63 DOWNTO 32),
        write1_data, write2_data,
        in_port_data,
        dataMemoryRead,
        Rdst_loadUse
    );

    memory_inst : Memory
    PORT MAP(
        clk,
        E_MRegister,
        M_WB,
        ALU_out,
        Rsrc1_dest,
        RW1MEM, RW2MEM
    );

    wb_inst : write_back_stage
    PORT MAP(
        clk,
        in_port_data,
        M_WB,
        RdstWrite1,
        write1_data,
        RdstWrite2,
        write2_data,
        branch_address,
        regWrite1, --M_WB(0)
        regWrite2, --M_WB(1)
        stack_operation, --M_WB(4)
        stack_op_type --M_WB(5)
    );
END main_arch;