-- Author: Danilo Fuchs
-- ULA - Unidade Lógica Aritmética

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg16bits_tb is
end;

architecture a_reg16bits_tb of reg16bits_tb is
    component reg16bits
        port (
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal data_in_s, data_out_s : unsigned(15 downto 0);
    signal clk_s, rst_s, wr_en_s : std_logic;
begin

    uut : reg16bits port map(
        clk => clk_s,
        rst => rst_s,
        wr_en => wr_en_s,
        data_in => data_in_s,
        data_out => data_out_s
    );

    process -- clock process
    begin
        clk_s <= '0';
        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;
    end process;

    process -- reset process
    begin
        rst_s <= '1';
        wait for 100 ns;
        rst_s <= '0';
        wait;
    end process;

    process
    begin
        wait for 100 ns;
        wr_en_s <= '0';
        data_in_s <= "1111111111111111";
        wait for 100 ns;
        assert data_out_s = "0000000000000000" report "wr_en_s = '0' should not set register" severity error;

        wait for 100 ns;
        wr_en_s <= '1';
        data_in_s <= "1010101010101010";
        wait for 100 ns;
        assert data_out_s = "1010101010101010" report "wr_en_s = '1' should set register" severity error;

        wait;
    end process;
end architecture a_reg16bits_tb;