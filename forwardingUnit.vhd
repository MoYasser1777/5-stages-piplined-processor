LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY forwardingUnit IS
    PORT (
        Rsrc1, Rsrc2, Rsrc1MEM, RdstMEM, Rsrc1WB, RdstWB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RW1MEM, RW2MEM, RW1WB, RW2WB : IN STD_LOGIC;
        mux1Signal, mux2Signal : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
    );
END forwardingUnit;

ARCHITECTURE ArchForwardingUnit OF forwardingUnit IS
BEGIN
    mux1Signal <= "001" WHEN(RW1MEM = '1' AND RdstMEM = Rsrc1)
        ELSE
        "010" WHEN (RW2MEM = '1' AND Rsrc1MEM = Rsrc1)
        ELSE
        "011" WHEN (RW1WB = '1' AND RdstWB = Rsrc1)
        ELSE
        "100" WHEN(RW2WB = '1' AND Rsrc1WB = Rsrc1)
        ELSE
        "000";

    mux2Signal <= "001" WHEN(RW1MEM = '1' AND RdstMEM = Rsrc2)
        ELSE
        "010" WHEN (RW2MEM = '1' AND Rsrc1MEM = Rsrc2)
        ELSE
        "011" WHEN(RW1WB = '1' AND RdstWB = Rsrc2)
        ELSE
        "100" WHEN(RW2WB = '1' AND Rsrc1WB = Rsrc2)
        ELSE
        "000";
END ArchForwardingUnit;