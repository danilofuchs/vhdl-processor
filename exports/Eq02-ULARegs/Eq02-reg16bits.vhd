-- Author: Danilo Fuchs
-- 16 bits register

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg16bits is
    port (
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity reg16bits;

architecture a_reg16bits of reg16bits is
    signal reg : unsigned(15 downto 0);
begin
    process (clk, rst, wr_en)
    begin
        if rst = '1' then
            reg <= "0000000000000000";
        elsif wr_en = '1' then
            if rising_edge(clk) then
                reg <= data_in;
            end if;
        end if;
    end process;

    data_out <= reg;
end architecture a_reg16bits;