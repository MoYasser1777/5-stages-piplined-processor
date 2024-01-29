
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity regwithTSB is  
    PORT (
    regIn : in std_logic_vector(31 downto 0);
    regOut: out std_logic_vector(31 downto 0);
	writeEnable: in std_logic;
    readEnable: in std_logic;
    clk :in std_logic;
    rst :in std_logic
    );
END ENTITY regwithTSB;

ARCHITECTURE regWithTSBArch OF regwithTSB IS

COMPONENT reg IS
port( 
    clk,rst,enable : in std_logic;
    d : in std_logic_vector(31 downto 0);
    q : out std_logic_vector(31 downto 0)
);
END COMPONENT ;

COMPONENT triStateBuffer IS
port( 
    dataIn : in std_logic_vector(31 downto 0);
    enable : in std_logic;
    dataOut : out std_logic_vector(31 downto 0)
);
END COMPONENT ;

signal bufferOut : std_logic_vector(31 downto 0);

BEGIN
reg1: reg port map(clk,rst,writeEnable,regIn,bufferOut);
buff: triStateBuffer port map (bufferOut,readEnable ,regOut);
END regWithTSBArch;