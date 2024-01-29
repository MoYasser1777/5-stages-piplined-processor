LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY reg IS
    PORT (
        clk, rst, enable : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END reg;

ARCHITECTURE regArch OF reg IS
BEGIN
    PROCESS (clk, rst, enable)
    BEGIN
        IF rst = '1' THEN
            q <= (OTHERS => '0');
        ELSIF ((clk = '0') AND enable = '1') THEN
            q <= d;
        END IF;
    END PROCESS;

END regArch;