LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY registerFile IS
    PORT (
        clk, rst, enable, regWrite1, regWrite2 : IN STD_LOGIC;
        Rsrc1, Rsrc2, Rdst, RdstWrite1, RdstWrite2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        writeBackData1, writeBackData2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        Rsrc1Data, Rsrc2Data, RdstData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );

END ENTITY registerFile;

ARCHITECTURE regFileArch OF registerFile IS

    --3x8 decoder to select addresses of registers
    COMPONENT decoder3x8 IS
        PORT (
            S : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            en : IN STD_LOGIC;
            Output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;

    -- register and tri state buffer to control read/write from it
    COMPONENT regWithTSB IS
        PORT (
            regIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            regOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            writeEnable : IN STD_LOGIC;
            readEnable : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC
        );
    END COMPONENT regWithTSB;

    --register to store registers data
    COMPONENT reg IS
        PORT (
            clk, rst, enable : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT reg;

    SIGNAL decoderSrc1Out, decoderSrc2Out, decoderDstOut, decoderDst1WriteOut, decoderDst2WriteOut : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL reg0WriteEnable, reg1WriteEnable, reg2WriteEnable, reg3WriteEnable, reg4WriteEnable, reg5WriteEnable, reg6WriteEnable, reg7WriteEnable : STD_LOGIC;
    SIGNAL reg0ReadEnable, reg1ReadEnable, reg2ReadEnable, reg3ReadEnable, reg4ReadEnable, reg5ReadEnable, reg6ReadEnable, reg7ReadEnable : STD_LOGIC;
    SIGNAL reg0Out, reg1Out, reg2Out, reg3Out, reg4Out, reg5Out, reg6Out, reg7Out, d1, d2, d3 : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg0WriteData, reg1WriteData, reg2WriteData, reg3WriteData, reg4WriteData, reg5WriteData, reg6WriteData, reg7WriteData : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN

    -- decoder
    Rsrc1Decoder : decoder3x8 PORT MAP(Rsrc1, '1', decoderSrc1Out);
    Rsrc2Decoder : decoder3x8 PORT MAP(Rsrc2, '1', decoderSrc2Out);
    Rdst1Decoder : decoder3x8 PORT MAP(Rdst, '1', decoderDstOut);
    Rdst1WriteDecoder : decoder3x8 PORT MAP(RdstWrite1, '1', decoderDst1WriteOut);
    Rdst2WriteDecoder : decoder3x8 PORT MAP(RdstWrite2, '1', decoderDst2WriteOut);

    --reg0
    reg0ReadEnable <= ((decoderSrc1Out(0) OR decoderSrc2Out(0) OR decoderDstOut(0)) AND (NOT clk)) OR ('1'); --OR (enable);--and enable;
    reg0WriteEnable <= ((decoderDst1WriteOut(0) AND regWrite1) OR (decoderDst2WriteOut(0) AND regWrite2)) AND (NOT clk);
    reg0WriteData <= writeBackData1 WHEN (((decoderDst1WriteOut(0)) AND (regWrite1) AND (clk)) = '1') ELSE
        writeBackData2 WHEN (((decoderDst2WriteOut(0)) AND (regWrite2) AND (clk)) = '1');
    R0 : regWithTSB PORT MAP(reg0WriteData, reg0Out, reg0WriteEnable, reg0ReadEnable, clk, rst);

    --reg1
    reg1ReadEnable <= ((decoderSrc1Out(1) OR decoderSrc2Out(1) OR decoderDstOut(1)) AND (NOT clk)) OR ('1'); --OR (enable);-- and enable;
    reg1WriteEnable <= ((decoderDst1WriteOut(1)AND regWrite1) OR (decoderDst2WriteOut(1) AND regWrite2)) AND (NOT clk);
    reg1WriteData <= writeBackData1 WHEN (((decoderDst1WriteOut(1)) AND (regWrite1) AND (clk)) = '1') ELSE
        writeBackData2 WHEN (((decoderDst2WriteOut(1)) AND (regWrite2) AND (clk)) = '1');
    R1 : regWithTSB PORT MAP(reg1WriteData, reg1Out, reg1WriteEnable, reg1ReadEnable, clk, rst);

    --reg2
    reg2ReadEnable <= ((decoderSrc1Out(2) OR decoderSrc2Out(2) OR decoderDstOut(2)) AND (NOT clk)) OR ('1'); --OR (enable);--and enable;
    reg2WriteEnable <= ((decoderDst1WriteOut(2)AND regWrite1) OR (decoderDst2WriteOut(2) AND regWrite2)) AND (NOT clk);
    reg2WriteData <= writeBackData1 WHEN (((decoderDst1WriteOut(2)) AND (regWrite1) AND (clk)) = '1') ELSE
        writeBackData2 WHEN (((decoderDst2WriteOut(2)) AND (regWrite2) AND (clk)) = '1');
    R2 : regWithTSB PORT MAP(reg2WriteData, reg2Out, reg2WriteEnable, reg2ReadEnable, clk, rst);

    --reg3
    reg3ReadEnable <= ((decoderSrc1Out(3) OR decoderSrc2Out(3) OR decoderDstOut(3)) AND (NOT clk)) OR ('1'); --OR (enable);--and enable;
    reg3WriteEnable <= ((decoderDst1WriteOut(3)AND regWrite1) OR (decoderDst2WriteOut(3) AND regWrite2)) AND (NOT clk);
    reg3WriteData <= writeBackData1 WHEN (((decoderDst1WriteOut(3)) AND (regWrite1) AND (clk)) = '1') ELSE
        writeBackData2 WHEN (((decoderDst2WriteOut(3)) AND (regWrite2) AND (clk)) = '1');
    R3 : regWithTSB PORT MAP(reg3WriteData, reg3Out, reg3WriteEnable, reg3ReadEnable, clk, rst);

    --reg4
    reg4ReadEnable <= ((decoderSrc1Out(4) OR decoderSrc2Out(4) OR decoderDstOut(4)) AND (NOT clk)) OR ('1'); --OR (enable);--and enable;
    reg4WriteEnable <= ((decoderDst1WriteOut(4)AND regWrite1) OR (decoderDst2WriteOut(4) AND regWrite2)) AND (NOT clk);
    reg4WriteData <= writeBackData1 WHEN (((decoderDst1WriteOut(4)) AND (regWrite1) AND (clk)) = '1') ELSE
        writeBackData2 WHEN (((decoderDst2WriteOut(4)) AND (regWrite2) AND (clk)) = '1');
    R4 : regWithTSB PORT MAP(reg4WriteData, reg4Out, reg4WriteEnable, reg4ReadEnable, clk, rst);

    --reg5
    reg5ReadEnable <= ((decoderSrc1Out(5) OR decoderSrc2Out(5) OR decoderDstOut(5)) AND (NOT clk)) OR ('1'); --OR (enable);--and enable;
    reg5WriteEnable <= ((decoderDst1WriteOut(5)AND regWrite1) OR (decoderDst2WriteOut(5) AND regWrite2)) AND (NOT clk);
    reg5WriteData <= writeBackData1 WHEN (((decoderDst1WriteOut(5)) AND (regWrite1) AND (clk)) = '1') ELSE
        writeBackData2 WHEN (((decoderDst2WriteOut(5)) AND (regWrite2) AND (clk)) = '1');
    R5 : regWithTSB PORT MAP(reg5WriteData, reg5Out, reg5WriteEnable, reg5ReadEnable, clk, rst);

    --reg6
    reg6ReadEnable <= ((decoderSrc1Out(6) OR decoderSrc2Out(6) OR decoderDstOut(6)) AND (NOT clk)) OR ('1'); --OR (enable);--and enable;
    reg6WriteEnable <= ((decoderDst1WriteOut(6)AND regWrite1) OR (decoderDst2WriteOut(6) AND regWrite2)) AND (NOT clk);
    reg6WriteData <= writeBackData1 WHEN (((decoderDst1WriteOut(6)) AND (regWrite1) AND (clk)) = '1') ELSE
        writeBackData2 WHEN (((decoderDst2WriteOut(6)) AND (regWrite2) AND (clk)) = '1');
    R6 : regWithTSB PORT MAP(reg6WriteData, reg6Out, reg6WriteEnable, reg6ReadEnable, clk, rst);

    --reg7
    reg7ReadEnable <= ((decoderSrc1Out(7) OR decoderSrc2Out(7) OR decoderDstOut(7)) AND (NOT clk)) OR ('1'); --OR (enable); --and enable;
    reg7WriteEnable <= ((decoderDst1WriteOut(7)AND regWrite1) OR (decoderDst2WriteOut(7) AND regWrite2)) AND (NOT clk);
    reg7WriteData <= writeBackData1 WHEN (((decoderDst1WriteOut(7)) AND (regWrite1) AND (clk)) = '1') ELSE
        writeBackData2 WHEN (((decoderDst2WriteOut(7)) AND (regWrite2) AND (clk)) = '1');
    R7 : regWithTSB PORT MAP(reg7WriteData, reg7Out, reg7WriteEnable, reg7ReadEnable, clk, rst);

    --Rsrc1
    Rsrc1Data <= reg0Out WHEN (Rsrc1 = "000" AND (enable = '1')) ELSE
        reg1Out WHEN (Rsrc1 = "001" AND (enable = '1')) ELSE
        reg2Out WHEN (Rsrc1 = "010" AND (enable = '1')) ELSE
        reg3Out WHEN (Rsrc1 = "011" AND (enable = '1')) ELSE
        reg4Out WHEN (Rsrc1 = "100" AND (enable = '1')) ELSE
        reg5Out WHEN (Rsrc1 = "101" AND (enable = '1')) ELSE
        reg6Out WHEN (Rsrc1 = "110" AND (enable = '1')) ELSE
        reg7Out WHEN (Rsrc1 = "111" AND (enable = '1'));

    --Rsrc2
    Rsrc2Data <= reg0Out WHEN (Rsrc2 = "000" AND (enable = '1')) ELSE
        reg1Out WHEN (Rsrc2 = "001" AND (enable = '1')) ELSE
        reg2Out WHEN (Rsrc2 = "010" AND (enable = '1')) ELSE
        reg3Out WHEN (Rsrc2 = "011" AND (enable = '1')) ELSE
        reg4Out WHEN (Rsrc2 = "100" AND (enable = '1')) ELSE
        reg5Out WHEN (Rsrc2 = "101" AND (enable = '1')) ELSE
        reg6Out WHEN (Rsrc2 = "110" AND (enable = '1')) ELSE
        reg7Out WHEN (Rsrc2 = "111" AND (enable = '1'));

    --Rdst
    RdstData <= reg0Out WHEN (Rdst = "000" AND (enable = '1')) ELSE
        reg1Out WHEN (Rdst = "001" AND (enable = '1')) ELSE
        reg2Out WHEN (Rdst = "010" AND (enable = '1')) ELSE
        reg3Out WHEN (Rdst = "011" AND (enable = '1')) ELSE
        reg4Out WHEN (Rdst = "100" AND (enable = '1')) ELSE
        reg5Out WHEN (Rdst = "101" AND (enable = '1')) ELSE
        reg6Out WHEN (Rdst = "110" AND (enable = '1')) ELSE
        reg7Out WHEN (Rdst = "111" AND (enable = '1'));

    reg0 <= reg0Out;
    reg1 <= reg1Out;
    reg2 <= reg2Out;
    reg3 <= reg3Out;
    reg4 <= reg4Out;
    reg5 <= reg5Out;
    reg6 <= reg6Out;
    reg7 <= reg7Out;

END regFileArch;