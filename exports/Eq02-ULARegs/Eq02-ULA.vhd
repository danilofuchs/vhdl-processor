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
        flag : out std_logic
    );
end entity ula;

architecture a_ula of ula is
    signal result : unsigned(15 downto 0) := "0000000000000000";
    signal flag_result : std_logic := '0';
begin

    result <=
        -- SUM
        in_a + in_b when op = "00" else
        -- SUBTRACTION
        in_a - in_b when op = "01" else
        "0000000000000000";

    flag_result <=
        -- LESS THAN
        '1' when op = "10" and in_a < in_b else
        '0' when op = "10" and in_a >= in_b else
        -- GREATER THAN OR EQUAL TO
        '1' when op = "11" and in_a >= in_b else
        '0' when op = "11" and in_a < in_b else
        '0';

    out_s <= result;
    flag <= flag_result;
end architecture a_ula;