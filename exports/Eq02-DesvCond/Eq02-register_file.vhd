-- Author: Danilo Fuchs
-- 8x16 register file

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_file is
    port (
        clk : in std_logic;
        rst : in std_logic;
        we3 : in std_logic;

        a1 : in unsigned(2 downto 0);
        a2 : in unsigned(2 downto 0);
        a3 : in unsigned(2 downto 0);

        wd3 : in unsigned(15 downto 0);
        rd1 : out unsigned(15 downto 0);
        rd2 : out unsigned(15 downto 0)
    );
end entity register_file;

architecture a_register_file of register_file is
    component reg16bits
        port (
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal wr_en_1, wr_en_2, wr_en_3, wr_en_4, wr_en_5, wr_en_6, wr_en_7 : std_logic := '0';
    signal data_in_s : unsigned(15 downto 0) := "0000000000000000";
    signal data_out_0, data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7 : unsigned(15 downto 0) := "0000000000000000";

begin
    data_in_s <= wd3;

    r0 : reg16bits port map(clk => clk, rst => '1', wr_en => '0', data_in => "0000000000000000", data_out => data_out_0); -- Always 0x0
    r1 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_1, data_in => data_in_s, data_out => data_out_1);
    r2 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_2, data_in => data_in_s, data_out => data_out_2);
    r3 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_3, data_in => data_in_s, data_out => data_out_3);
    r4 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_4, data_in => data_in_s, data_out => data_out_4);
    r5 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_5, data_in => data_in_s, data_out => data_out_5);
    r6 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_6, data_in => data_in_s, data_out => data_out_6);
    r7 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_7, data_in => data_in_s, data_out => data_out_7);

    rd1 <=
        data_out_0 when a1 = "000" else
        data_out_1 when a1 = "001" else
        data_out_2 when a1 = "010" else
        data_out_3 when a1 = "011" else
        data_out_4 when a1 = "100" else
        data_out_5 when a1 = "101" else
        data_out_6 when a1 = "110" else
        data_out_7 when a1 = "111" else
        "0000000000000000";

    rd2 <=
        data_out_0 when a2 = "000" else
        data_out_1 when a2 = "001" else
        data_out_2 when a2 = "010" else
        data_out_3 when a2 = "011" else
        data_out_4 when a2 = "100" else
        data_out_5 when a2 = "101" else
        data_out_6 when a2 = "110" else
        data_out_7 when a2 = "111" else
        "0000000000000000";

    wr_en_1 <=
        we3 when a3 = "001" else
        '0';

    wr_en_2 <=
        we3 when a3 = "010" else
        '0';

    wr_en_3 <=
        we3 when a3 = "011" else
        '0';

    wr_en_4 <=
        we3 when a3 = "100" else
        '0';

    wr_en_5 <=
        we3 when a3 = "101" else
        '0';

    wr_en_6 <=
        we3 when a3 = "110" else
        '0';

    wr_en_7 <=
        we3 when a3 = "111" else
        '0';
end architecture a_register_file;