-- Import the IEEE standard logic 1164 package
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux8X1 IS
    PORT (
        in1, in2, in3, in4, in5, in6, in7, in8 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        outMux : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END mux8X1;

ARCHITECTURE ArchMux8X1 OF mux8X1 IS
BEGIN
    outMux <= in1 WHEN sel = "000"
        ELSE
        in2 WHEN sel = "001"
        ELSE
        in3 WHEN sel = "010"
        ELSE
        in4 WHEN sel = "011"
        ELSE
        in5 WHEN sel = "100"
        ELSE
        in6 WHEN sel = "101"
        ELSE
        in7 WHEN sel = "110"
        ELSE
        in8 WHEN sel = "111";
END ArchMux8X1;