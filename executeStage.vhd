-- Import the IEEE standard logic 1164 package
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY executeStage IS
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
END executeStage;

ARCHITECTURE ArchExecuteStage OF executeStage IS
    --Input Signals
    SIGNAL controlSignals : STD_LOGIC_VECTOR(23 DOWNTO 0);
    SIGNAL EA_MST : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL immValue : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rsrc1Address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rsrc2Address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL RdstAddress : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rsrc1Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rsrc2Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RdstData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --Intermediate Signals
    SIGNAL mux1Out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL aluOut1, aluOut2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL zeroF, negativeF, carryF : STD_LOGIC := '0';
    SIGNAL muxIN1, muxIN2 : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL mux2Out, mux3Out : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL aluIN1, aluIN2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    COMPONENT ALU IS
        PORT (
            in1, in2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            operation : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            out1, out2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            zeroFlag, negativeFlag, carryFlag : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT mux4X1 IS
        PORT (
            in1, in2, in3, in4 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            sel1, sel2 : IN STD_LOGIC;
            outMux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
    END COMPONENT;

    COMPONENT outPort IS
        PORT (
            clk, writeEnable : IN STD_LOGIC;
            writeData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            outPortData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;

    COMPONENT forwardingUnit IS
        PORT (
            Rsrc1, Rsrc2, Rsrc1MEM, RdstMEM, Rsrc1WB, RdstWB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            RW1MEM, RW2MEM, RW1WB, RW2WB : IN STD_LOGIC;
            mux1Signal, mux2Signal : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux8X1 IS
        PORT (
            in1, in2, in3, in4, in5, in6, in7, in8 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            outMux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
    END COMPONENT;

BEGIN
    mux1HW : mux4X1 PORT MAP(Rsrc2Data, immValue, RdstData, (OTHERS => '0'), controlSignals(16), controlSignals(22), mux1Out);
    outPortHW : outPort PORT MAP(clk, controlSignals(12), Rsrc1Data, outPortData);
    forwardingUnitHW : forwardingUnit PORT MAP(Rsrc1Address, Rsrc2Address, Rsrc1MEM, RdstMEM, Rsrc1WB, RdstWB, RW1MEM, RW2MEM, RW1WB, RW2WB, muxIN1, muxIN2);
    mux2HW : mux8X1 PORT MAP(Rsrc1Data, Out1MEM, Out2MEM, Out1WB, Out2WB, (OTHERS => '0'), (OTHERS => '0'), (OTHERS => '0'), muxIN1, aluIN1);
    mux3HW : mux8X1 PORT MAP(mux1Out, Out1MEM, Out2MEM, Out1WB, Out2WB, (OTHERS => '0'), (OTHERS => '0'), (OTHERS => '0'), muxIN2, aluIN2);
    aluHW : ALU PORT MAP(aluIN1, aluIN2, controlSignals(3 DOWNTO 0), aluOut1, aluOut2, zeroF, negativeF, carryF);

    PROCESS (clk)
    BEGIN
        controlSignals <= decodeExecuteRegister(23 DOWNTO 0);
        EA_MST <= decodeExecuteRegister(27 DOWNTO 24);
        immValue <= decodeExecuteRegister(59 DOWNTO 28);
        Rsrc1Address <= decodeExecuteRegister(62 DOWNTO 60);
        Rsrc2Address <= decodeExecuteRegister(65 DOWNTO 63);
        RdstAddress <= decodeExecuteRegister(68 DOWNTO 66);
        Rsrc1Data <= decodeExecuteRegister(100 DOWNTO 69);
        Rsrc2Data <= decodeExecuteRegister(132 DOWNTO 101);
        RdstData <= decodeExecuteRegister(164 DOWNTO 133);
        PC <= decodeExecuteRegister(196 DOWNTO 165);
        Rdst_loadUse <= decodeExecuteRegister(68 DOWNTO 66);
        dataMemoryRead <= decodeExecuteRegister(6);
        IF rising_edge(clk) THEN
            executeMemoryRegister(13 DOWNTO 0) <= controlSignals(23) & controlSignals(21 DOWNTO 17) & controlSignals(14 DOWNTO 13) & controlSignals(11 DOWNTO 6);--Control Signals
            executeMemoryRegister(25 DOWNTO 14) <= immValue(11 DOWNTO 0);--EA
            executeMemoryRegister(95 DOWNTO 90) <= RdstAddress & Rsrc1Address;--Addresses of registers
            executeMemoryRegister(127 DOWNTO 96) <= RdstData;--Data of Rdst
            executeMemoryRegister(159 DOWNTO 128) <= PC;
            executeMemoryRegister(162 DOWNTO 160) <= carryF & negativeF & zeroF;

            --LDM Operation Case
            IF (controlSignals(2) = '1' AND controlSignals(22) = '1' AND controlSignals(3 DOWNTO 0) = "0000") THEN
                executeMemoryRegister(89 DOWNTO 26) <= aluOut2 & immValue;--Outputs of ALU
                -- ELSIF (controlSignals(11) = '1') THEN
                --     aluOut1 <= inPortData;
                --     executeMemoryRegister(89 DOWNTO 26) <= aluOut2 & inPortData;--Outputs of ALU
            ELSE
                executeMemoryRegister(89 DOWNTO 26) <= aluOut2 & aluOut1;--Outputs of ALU
            END IF;

            --Jump Zero Branching Case
            IF (controlSignals(5) = '1' AND zeroF = '1') THEN
                jumpZeroSignal <= '1';
            ELSE
                jumpZeroSignal <= '0';
            END IF;
        END IF;
    END PROCESS;
END ArchExecuteStage;