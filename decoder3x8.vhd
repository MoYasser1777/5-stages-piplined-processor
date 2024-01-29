
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY decoder3x8 IS

PORT( S : IN std_logic_vector(2 DOWNTO 0);
      en: IN std_logic;
    Output : OUT std_logic_vector(7 DOWNTO 0));

END ENTITY decoder3x8;


ARCHITECTURE my_decoder_3_8 OF decoder3x8 IS

BEGIN

output <= "00000000"  when en='0'
else "00000001" when (S = "000")
else "00000010" when (S = "001")
else "00000100" when (S = "010")
else "00001000" when (S = "011")
else "00010000" when (S = "100")
else "00100000" when (S = "101")  
else "01000000" when (S = "110")
else "10000000" when (S = "111");

  
 

END my_decoder_3_8;
