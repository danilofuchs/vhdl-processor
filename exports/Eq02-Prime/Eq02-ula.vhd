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

        result : out unsigned(15 downto 0);
        zero_flag : out std_logic
    );
end entity ula;

architecture a_ula of ula is
    signal result_s : unsigned(15 downto 0) := "0000000000000000";
begin
    result_s <=
        -- SUM
        in_a + in_b when op = "00" else
        -- SUBTRACTION
        in_a - in_b when op = "01" else
        -- LT
        "0000000000000001" when op = "10" and in_a < in_b else
        -- GTE
        "0000000000000001" when op = "11" and in_a >= in_b else
        "0000000000000000";

    zero_flag <=
        '1' when result_s = "0000000000000000" else
        '0';

    result <= result_s;
end architecture a_ula;