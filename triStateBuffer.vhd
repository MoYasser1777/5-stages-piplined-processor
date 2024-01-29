
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY triStateBuffer IS
    PORT (
        dataIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        enable : IN STD_LOGIC;
        dataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END triStateBuffer;

ARCHITECTURE triStateArch OF triStateBuffer IS
BEGIN

    dataOut <= dataIn WHEN enable = '1'
        ELSE
        (OTHERS => 'Z');

END triStateArch;