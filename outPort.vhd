LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY outPort IS
    PORT (
        clk, writeEnable : IN STD_LOGIC;
        writeData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        outPortData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END outPort;

ARCHITECTURE ArchOutPort OF outPort IS
    SIGNAL outPortDataSignal : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk)
    BEGIN
        IF ((clk = '1') AND writeEnable = '1')
            THEN
            outPortDataSignal <= writeData;
        END IF;
    END PROCESS;
    outPortData <= outPortDataSignal;
END ArchOutPort;