-- Import the IEEE standard logic 1164 package
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux4X1 IS
    PORT (
        in1, in2, in3, in4 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        sel1, sel2 : IN STD_LOGIC;
        outMux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END mux4X1;

ARCHITECTURE ArchMux4X1 OF mux4X1 IS
BEGIN
    outMux <= in1 WHEN sel1 = '0' AND sel2 = '0'
        ELSE
        in2 WHEN sel1 = '0' AND sel2 = '1'
        ELSE
        in3 WHEN sel1 = '1' AND sel2 = '0'
        ELSE
        in4;
END ArchMux4X1;