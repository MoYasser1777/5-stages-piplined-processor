library IEEE;
use IEEE.std_logic_1164.all;

entity genericReg is
    generic (
        n : integer := 32
    );
    port (
        clk, rst, writeEnable, readEnable : in std_logic;
        d : in std_logic_vector(n - 1 downto 0);
        q : out std_logic_vector(n - 1 downto 0)
    );
end genericReg;

architecture genericRegArch of genericReg is
begin
    process (clk, rst,writeEnable)
    variable dataIn : std_logic_vector(n - 1 downto 0) := (others => '0');
    begin
        if rst = '1' then
            dataIn := (others => '0');
        elsif (clk='1') then
            if writeEnable = '1' then
                dataIn := d;
            end if;
            if readEnable = '1' then
                q <= d;
            end if;
        end if;
    end process;


end genericRegArch;
