library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity signExtend is
    Port ( immediate : in  STD_LOGIC_VECTOR (15 downto 0);
           extended  : out STD_LOGIC_VECTOR (31 downto 0));
end signExtend;

architecture signExtendArch of signExtend is
begin
    
   extended <= ("0000000000000000" & immediate) when immediate(15)='0' 
   else        ("1111111111111111" & immediate);
   
end signExtendArch;