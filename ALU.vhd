LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALU IS
    PORT (
        in1, in2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        operation : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        out1, out2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        zeroFlag, negativeFlag, carryFlag : OUT STD_LOGIC
    );
END ALU;
ARCHITECTURE ArchALU OF ALU IS
    SIGNAL temp_out1, temp_out2 : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL writeFlags : STD_LOGIC := '0';
    SIGNAL zeroFlagIN, negativeFlagIN, carryFlagIN : STD_LOGIC := '0';
    SIGNAL zeroFlagOUT, negativeFlagOUT, carryFlagOUT : STD_LOGIC := '0';
    COMPONENT flagsRegister IS
        PORT (
            enable, zf, nf, cf : IN STD_LOGIC;
            zfOut, nfOut, cfOut : OUT STD_LOGIC
        );
    END COMPONENT;
BEGIN
    flagsRegisterHW : flagsRegister PORT MAP(writeFlags, zeroFlagIN, negativeFlagIN, carryFlagIN, zeroFlagOUT, negativeFlagOUT, carryFlagOUT);
    PROCESS (in1, in2, operation)

    BEGIN
        writeFlags <= '0';
        -- Initialize variables
        CASE operation IS
            WHEN "0000" => --NOP
                -- No operation, do nothing
                writeFlags <= '0';
            WHEN "0001" => --NOT
                temp_out1 <= NOT in1;
                temp_out2 <= (OTHERS => '0');
                writeFlags <= '1';
                IF (unsigned(NOT in1) = 0) THEN
                    zeroFlagIN <= '1';
                ELSE
                    zeroFlagIN <= '0';
                END IF;
                IF (signed(NOT in1) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
            WHEN "0010" => --NEG
                temp_out1 <= STD_LOGIC_VECTOR(0 - signed(in1));
                temp_out2 <= (OTHERS => '0');
                writeFlags <= '1';
                IF (unsigned(0 - unsigned(in1)) = 0) THEN
                    zeroFlagIN <= '1';
                ELSE
                    zeroFlagIN <= '0';
                END IF;
                IF (signed(0 - signed(in1)) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
            WHEN "0011" => --INC
                temp_out1 <= STD_LOGIC_VECTOR(signed(in1) + 1);
                temp_out2 <= (OTHERS => '0');
                writeFlags <= '1';
                IF (unsigned(signed(in1) + 1) = 0) THEN
                    zeroFlagIN <= '1';
                ELSE
                    zeroFlagIN <= '0';
                END IF;
                IF (signed(signed(in1) + 1) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
            WHEN "0100" => --DEC
                temp_out1 <= STD_LOGIC_VECTOR(signed(in1) - 1);
                temp_out2 <= (OTHERS => '0');
                writeFlags <= '1';
                IF (unsigned(signed(in1) - 1) = 0) THEN
                    zeroFlagIN <= '1';
                ELSE
                    zeroFlagIN <= '0';
                END IF;
                IF (signed(signed(in1) - 1) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
            WHEN "0101" => --SWAP
                temp_out1 <= in2;
                temp_out2 <= in1;
                writeFlags <= '0';
            WHEN "0110" => --ADD
                temp_out1 <= STD_LOGIC_VECTOR(signed(in1) + signed(in2));
                temp_out2 <= (OTHERS => '0');
                writeFlags <= '1';
                IF (unsigned(signed(in1) + signed(in2)) = 0) THEN
                    zeroFlagIN <= '1';
                ELSE
                    zeroFlagIN <= '0';
                END IF;
                IF (signed(signed(in1) + signed(in2)) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
            WHEN "0111" => --SUB
                temp_out1 <= STD_LOGIC_VECTOR(signed(in1) - signed(in2));
                temp_out2 <= (OTHERS => '0');
                writeFlags <= '1';
                IF (unsigned(signed(in1) - signed(in2)) = 0) THEN
                    zeroFlagIN <= '1';
                ELSE
                    zeroFlagIN <= '0';
                END IF;
                IF (signed(signed(in1) - signed(in2)) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
            WHEN "1000" => --AND
                temp_out1 <= in1 AND in2;
                temp_out2 <= (OTHERS => '0');
                writeFlags <= '1';
                IF (unsigned(in1 AND in2) = 0) THEN
                    zeroFlagIN <= '1';
                ELSE
                    zeroFlagIN <= '0';
                END IF;
                IF (signed(in1 AND in2) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
            WHEN "1001" => --OR
                temp_out1 <= in1 OR in2;
                temp_out2 <= (OTHERS => '0');
                writeFlags <= '1';
                IF (unsigned(in1 OR in2) = 0) THEN
                    zeroFlagIN <= '1';
                ELSE
                    zeroFlagIN <= '0';
                END IF;
                IF (signed(in1 OR in2) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
            WHEN "1010" => --XOR
                temp_out1 <= in1 XOR in2;
                temp_out2 <= (OTHERS => '0');
                writeFlags <= '1';
                IF (unsigned(in1 XOR in2) = 0) THEN
                    zeroFlagIN <= '1';
                ELSE
                    zeroFlagIN <= '0';
                END IF;
                IF (signed(in1 XOR in2) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
            WHEN "1011" => --CMP
                IF ((signed(in1) - signed(in2)) = 0) THEN
                    zeroFlagIN <= '1';
                ELSE
                    zeroFlagIN <= '0';
                END IF;
                IF ((signed(in1) - signed(in2)) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
                writeFlags <= '1';
            WHEN "1100" => --BITSET
                temp_out1 <= in1(31 DOWNTO to_integer(unsigned(in2) + 1)) & '1' & in1(to_integer(unsigned(in2) - 1) DOWNTO 0);
                carryFlagIN <= in1(to_integer(unsigned(in2)));
                temp_out2 <= (OTHERS => '0');
                writeFlags <= '1';
                zeroFlagIN <= '0';
                IF (signed(in1(31 DOWNTO to_integer(unsigned(in2) + 1)) & '1' & in1(to_integer(unsigned(in2) - 1) DOWNTO 0)) < 0) THEN
                    negativeFlagIN <= '1';
                ELSE
                    negativeFlagIN <= '0';
                END IF;
            WHEN "1101" => --RCL
                IF (unsigned(in2) > 1) THEN
                    temp_out1 <= in1(to_integer(31 - unsigned(in2)) DOWNTO 0) & carryFlagOUT & in1(31 DOWNTO to_integer(32 - unsigned(in2) + 1));
                    writeFlags <= '1';
                    carryFlagIN <= in1(to_integer(32 - unsigned(in2)));
                    IF (unsigned(in1(to_integer(31 - unsigned(in2)) DOWNTO 0) & carryFlagOUT & in1(31 DOWNTO to_integer(32 - unsigned(in2) + 1))) = 0) THEN
                        zeroFlagIN <= '1';
                    ELSE
                        zeroFlagIN <= '0';
                    END IF;
                    IF (signed(in1(to_integer(31 - unsigned(in2)) DOWNTO 0) & carryFlagOUT & in1(31 DOWNTO to_integer(32 - unsigned(in2) + 1))) < 0) THEN
                        negativeFlagIN <= '1';
                    ELSE
                        negativeFlagIN <= '0';
                    END IF;
                ELSIF (unsigned(in2) = 1) THEN
                    temp_out1 <= in1(to_integer(31 - unsigned(in2)) DOWNTO 0) & carryFlagOUT;
                    writeFlags <= '1';
                    carryFlagIN <= in1(to_integer(32 - unsigned(in2)));
                    IF (unsigned(in1(to_integer(31 - unsigned(in2)) DOWNTO 0) & carryFlagOUT) = 0) THEN
                        zeroFlagIN <= '1';
                    ELSE
                        zeroFlagIN <= '0';
                    END IF;
                    IF (signed(in1(to_integer(31 - unsigned(in2)) DOWNTO 0) & carryFlagOUT) < 0) THEN
                        negativeFlagIN <= '1';
                    ELSE
                        negativeFlagIN <= '0';
                    END IF;
                END IF;
                temp_out2 <= (OTHERS => '0');
            WHEN "1110" => --RCR
                IF (unsigned(in2) > 1) THEN
                    temp_out1 <= in1(to_integer(unsigned(in2) - 2) DOWNTO 0) & carryFlagOUT & in1(31 DOWNTO to_integer(unsigned(in2)));
                    carryFlagIN <= in1(to_integer(unsigned(in2) - 1));
                    writeFlags <= '1';
                    IF (unsigned(in1(to_integer(unsigned(in2) - 2) DOWNTO 0) & carryFlagOUT & in1(31 DOWNTO to_integer(unsigned(in2)))) = 0) THEN
                        zeroFlagIN <= '1';
                    ELSE
                        zeroFlagIN <= '0';
                    END IF;
                    IF (signed(in1(to_integer(unsigned(in2) - 2) DOWNTO 0) & carryFlagOUT & in1(31 DOWNTO to_integer(unsigned(in2)))) < 0) THEN
                        negativeFlagIN <= '1';
                    ELSE
                        negativeFlagIN <= '0';
                    END IF;
                ELSIF (unsigned(in2) = 1) THEN
                    temp_out1 <= carryFlagOUT & in1(31 DOWNTO to_integer(unsigned(in2)));
                    carryFlagIN <= in1(to_integer(unsigned(in2) - 1));
                    writeFlags <= '1';
                    IF (unsigned(carryFlagOUT & in1(31 DOWNTO to_integer(unsigned(in2)))) = 0) THEN
                        zeroFlagIN <= '1';
                    ELSE
                        zeroFlagIN <= '0';
                    END IF;
                    IF (signed(carryFlagOUT & in1(31 DOWNTO to_integer(unsigned(in2)))) < 0) THEN
                        negativeFlagIN <= '1';
                    ELSE
                        negativeFlagIN <= '0';
                    END IF;
                END IF;
                temp_out2 <= (OTHERS => '0');
            WHEN OTHERS =>
                temp_out1 <= "00000000000000000000000000000000";
                temp_out2 <= "00000000000000000000000000000000";
        END CASE;

    END PROCESS;

    -- Assign output signals outside the process
    out1 <= temp_out1;
    out2 <= temp_out2;
    -- Update flags
    zeroFlag <= zeroFlagOUT;
    negativeFlag <= negativeFlagOUT;
    carryFlag <= carryFlagOUT;

END ArchALU;