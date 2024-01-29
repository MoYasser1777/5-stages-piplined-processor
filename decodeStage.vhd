LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY decodeStage IS
    PORT (
        clk, rst, jumpZeroSignal, enable, regWrite1, regWrite2 : IN STD_LOGIC;
        RdstWrite1, RdstWrite2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rdst_D_E : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        dataMemoryRead : IN STD_LOGIC;
        writeBackData1, writeBackData2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        F_DRegister : IN STD_LOGIC_VECTOR(63 DOWNTO 0); --IR(31:0) --> instruction code(15:14) , operation code (13:10)
        -- Rdst(9:7),Rsrc2(6:4),Rsrc1(3:1), 1 bit unused
        --PC(63:32)
        D_ERegister : OUT STD_LOGIC_VECTOR(196 DOWNTO 0); -- control sig(23:0) , EA_MSB(27:24) , imm(59:28) 
        -- Rdst Address (68:66), Rsrc2 Address (65:63) , Rsrc1 Address(62:60) 
        -- RdstData(164:133),Rsrc2Data(132:101),Rsrc1Data(100:69),PC(196:165)
        reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        pcAdditionEnable, uncond : OUT STD_LOGIC
    );
END ENTITY decodeStage;

ARCHITECTURE decodeArch OF decodeStage IS

    COMPONENT registerFile
        PORT (
            clk, rst, enable, regWrite1, regWrite2 : IN STD_LOGIC;
            Rsrc1, Rsrc2, Rdst, RdstWrite1, RdstWrite2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            writeBackData1, writeBackData2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Rsrc1Data, Rsrc2Data, RdstData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT signExtend
        PORT (
            immediate : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            extended : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    --SIGNAL Rsrc1Data, Rsrc2Data, RdstData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --SIGNAL controlSignal : STD_LOGIC_VECTOR(22 DOWNTO 0);
    SIGNAL signExtendedValue : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rsrc1Address, Rsrc2Address, RdstAddress : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL en : STD_LOGIC := '0';

BEGIN
    PROCESS (clk)
    BEGIN
        pcAdditionEnable <= '1';
        en <= '0';
        IF (falling_edge(clk)) THEN
            en <= '1';
            IF (jumpZeroSignal = '1') THEN
                D_ERegister(23 DOWNTO 0) <= "000000001000000000000000";
            ELSIF (((F_DRegister(3 DOWNTO 1) = Rdst_D_E) OR (F_DRegister(6 DOWNTO 4) = Rdst_D_E)) AND (dataMemoryRead = '1')) THEN
                D_ERegister(23 DOWNTO 0) <= "000000001000000000000000";
                pcAdditionEnable <= '0';
            ELSE
                CASE F_DRegister(15 DOWNTO 10) IS
                    WHEN "000000" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000000000000"; --NOP done
                    WHEN "000001" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000100000001"; --NOT done
                    WHEN "000010" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000100000010"; --NEG done
                    WHEN "000011" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000100000011"; --INC done
                    WHEN "000100" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000100000100"; --DEC done
                    WHEN "000101" =>
                        D_ERegister(23 DOWNTO 0) <= "000000000001000000000000"; --OUT done
                    WHEN "000110" =>
                        D_ERegister(23 DOWNTO 0) <= "000000000000100100000000"; --IN done
                    WHEN "010000" =>
                        D_ERegister(23 DOWNTO 0) <= "000000011000001100000101"; --swap
                    WHEN "010001" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000100000110"; --add
                    WHEN "010010" =>
                        D_ERegister(23 DOWNTO 0) <= "010000001000000100000110"; --addi
                    WHEN "010011" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000100000111"; --sub
                    WHEN "010100" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000100001000"; --and
                    WHEN "010101" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000100001001"; --or
                    WHEN "010110" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000100001010"; --xor
                    WHEN "010111" =>
                        D_ERegister(23 DOWNTO 0) <= "000000001000000000001011"; --cmp
                    WHEN "011000" =>
                        D_ERegister(23 DOWNTO 0) <= "010000001000000100001100"; --bit set
                    WHEN "011001" =>
                        D_ERegister(23 DOWNTO 0) <= "010000001000000100001101"; --rcl
                    WHEN "011010" =>
                        D_ERegister(23 DOWNTO 0) <= "010000001000000100001110"; --rcr
                    WHEN "100000" =>
                        D_ERegister(23 DOWNTO 0) <= "000000000010000010000000"; --push
                    WHEN "100001" =>
                        D_ERegister(23 DOWNTO 0) <= "000000000110010111000000"; --pop
                    WHEN "100010" =>
                        D_ERegister(23 DOWNTO 0) <= "010000000000000100000000"; --ldm
                    WHEN "100011" =>
                        D_ERegister(23 DOWNTO 0) <= "010000000000010101000000"; --ldd
                    WHEN "100100" =>
                        D_ERegister(23 DOWNTO 0) <= "010000000000000010000000"; --std
                    WHEN "100101" =>
                        D_ERegister(23 DOWNTO 0) <= "000001100000000000000000"; --protect
                    WHEN "100110" =>
                        D_ERegister(23 DOWNTO 0) <= "000000000000010010000000"; --free
                    WHEN "110000" =>
                        D_ERegister(23 DOWNTO 0) <= "000000000000000000100000"; --jz
                    WHEN "110001" =>
                        D_ERegister(23 DOWNTO 0) <= "000000000000000000010000"; --jump
                        uncond <= '1';
                    WHEN "110010" =>
                        D_ERegister(23 DOWNTO 0) <= "001001001000000000000000"; --call
                        uncond <= '1';
                    WHEN "110011" =>
                        D_ERegister(23 DOWNTO 0) <= "001010001000100001000000"; --ret
                    WHEN "110100" =>
                        D_ERegister(23 DOWNTO 0) <= "101010001000100001000000"; --rti
                    WHEN OTHERS =>
                        D_ERegister(23 DOWNTO 0) <= "000000000000000000000000"; --default
                END CASE;
            END IF;
            IF NOT (F_DRegister(15 DOWNTO 10) = "000000") THEN
                D_ERegister(196 DOWNTO 165) <= F_DRegister(63 DOWNTO 32); --PC
                D_ERegister(62 DOWNTO 60) <= F_DRegister(3 DOWNTO 1); --Rsrc1 address
                D_ERegister(65 DOWNTO 63) <= F_DRegister(6 DOWNTO 4); --Rsrc2 address
                D_ERegister(68 DOWNTO 66) <= F_DRegister(9 DOWNTO 7); --Rdst address
                D_ERegister(27 DOWNTO 24) <= F_DRegister(4 DOWNTO 1); --EA 4 bits MSB of IR
                D_ERegister(59 DOWNTO 28) <= signExtendedValue; --32 bits immediate value
            END IF;
        END IF;
    END PROCESS;

    -- Instantiate the registerFile component
    regFile : registerFile
    PORT MAP(clk, rst, en, regWrite1, regWrite2, F_DRegister(3 DOWNTO 1), F_DRegister(6 DOWNTO 4), F_DRegister(9 DOWNTO 7), RdstWrite1, RdstWrite2, writeBackData1, writeBackData2, D_ERegister(100 DOWNTO 69), D_ERegister(132 DOWNTO 101), D_ERegister(164 DOWNTO 133), reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7);

    --Sign Extend Component
    signExtendInstance : signExtend PORT MAP(F_DRegister(31 DOWNTO 16), signExtendedValue);

END decodeArch;