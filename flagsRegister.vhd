LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY flagsRegister IS
    PORT (
        enable, zf, nf, cf : IN STD_LOGIC;
        zfOut, nfOut, cfOut : OUT STD_LOGIC
    );
END flagsRegister;

ARCHITECTURE ArchFlagsRegister OF flagsRegister IS
BEGIN
    PROCESS (enable, zf, nf, cf)
    BEGIN
        IF (enable = '1') THEN
            zfOut <= zf;
            nfOut <= nf;
            cfOut <= cf;
        END IF;
    END PROCESS;

END ArchFlagsRegister;