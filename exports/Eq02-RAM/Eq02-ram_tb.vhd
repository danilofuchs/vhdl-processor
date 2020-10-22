-- Author: Danilo Fuchs
-- 128x16 RAM

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_tb is
end;

architecture a_ram_tb of ram_tb is
    component ram
        port (
            clk : in std_logic;
            wr_en : in std_logic;

            address : in unsigned(6 downto 0);
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal data_in_s : unsigned(15 downto 0) := "0000000000000000";
    signal data_out_s : unsigned(15 downto 0);
    signal address_s : unsigned(6 downto 0) := "0000000";
    signal clk_s, wr_en_s : std_logic := '0';
begin

    uut : ram port map(
        clk => clk_s,
        wr_en => wr_en_s,
        address => address_s,
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

    process
    begin
        wait for 100 ns;
        wr_en_s <= '1';
        data_in_s <= "1111111111111111";
        address_s <= "0000000";
        wait for 100 ns;
        assert data_out_s = "1111111111111111" report "should set value at address 0" severity error;

        wait for 100 ns;
        wr_en_s <= '0';
        data_in_s <= "1010101010101010";
        wait for 100 ns;
        assert data_out_s = "1111111111111111" report "wr_en_s = '0' should not set value" severity error;

        wait for 100 ns;
        wr_en_s <= '1';
        data_in_s <= "1111111111111111";
        address_s <= "1111111";
        wait for 100 ns;
        assert data_out_s = "1111111111111111" report "should set value at address 127" severity error;

        wait for 100 ns;
        wr_en_s <= '0';
        address_s <= "0000111";
        wait for 100 ns;
        assert data_out_s = "XXXXXXXXXXXXXXXX" report "should have default value of undefined" severity error;
        wait;
    end process;
end architecture a_ram_tb;