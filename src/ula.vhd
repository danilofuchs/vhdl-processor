-- Author: Danilo Fuchs
-- ULA - Unidade Lógica Aritmética

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port (
        in_a : in unsigned(15 downto 0);
        in_b : in unsigned(15 downto 0);
        -- "00" -> sum: a + b
        -- "01" -> subtraction: a - b
        -- "10" -> less than: a < b
        -- "11" -> more than or equals to: a >= b
        op : in unsigned(1 downto 0);

        out_s : out unsigned(15 downto 0);
        flag : out unsigned
    );
end entity ula;

architecture a_ula of ula is
    signal result : unsigned(15 downto 0) := "0000000000000000";
begin

    result <=
        in_a + in_b when op = "00" else
        in_a - in_b when op = "01" else
        "0000000000000000";

    out_s <= result;
end architecture a_ula;