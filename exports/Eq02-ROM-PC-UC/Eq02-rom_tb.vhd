-- Author: Danilo Fuchs
-- 128x12 ROM

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom_tb is
end;

architecture a_rom_tb of rom_tb is
    component rom
        port (
            clk : in std_logic;
            address : in unsigned(6 downto 0);
            data : out unsigned(11 downto 0)
        );
    end component;

    signal clk_s : std_logic := '0';
    signal address_s : unsigned(6 downto 0) := "0000000";
    signal data_s : unsigned(11 downto 0) := "000000000000";
begin

    uut : rom port map(
        clk => clk_s,
        address => address_s,
        data => data_s
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
        address_s <= "0000000";
        wait for 100 ns;
        assert data_s = "000000000010" report "incorrect data at address 0x0" severity error;

        wait for 100 ns;
        address_s <= "0000001";
        wait for 100 ns;
        assert data_s = "100000000000" report "incorrect data at address 0x1" severity error;
        wait;
    end process;
end architecture a_rom_tb;