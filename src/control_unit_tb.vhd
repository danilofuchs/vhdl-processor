-- Author: Danilo Fuchs
-- Control unit

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit_tb is
end;

architecture a_control_unit_tb of control_unit_tb is
    component control_unit
        port (
            clk : in std_logic;
            rst : in std_logic;

            op_code : in unsigned(3 downto 0);

            jump_en : out std_logic;
            pc_wr_en : out std_logic;

            ula_op_sel : out unsigned(1 downto 0);
            ula_src_sel : out std_logic;

            -- Changes between rd and rt
            reg_dest_sel : out std_logic;
            reg_wr_en : out std_logic
        );
    end component;

    signal clk_s, rst_s : std_logic := '0';
    signal op_code_s : unsigned(3 downto 0) := "0000";
    signal jump_en_s, pc_wr_en_s, ula_en_s : std_logic := '0';

    signal ula_op_sel_s : unsigned(1 downto 0) := "00";
    signal ula_src_sel_s : std_logic := '0';

    signal reg_dest_sel_s, reg_wr_en_s : std_logic := '0';

begin

    uut : control_unit port map(
        clk => clk_s,
        rst => rst_s,
        op_code => op_code_s,

        jump_en => jump_en_s,
        pc_wr_en => pc_wr_en_s,

        ula_op_sel => ula_op_sel_s,
        ula_src_sel => ula_src_sel_s,

        reg_dest_sel => reg_dest_sel_s,
        reg_wr_en => reg_wr_en_s
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
        -- Reset
        rst_s <= '1';
        wait for 100 ns;
        rst_s <= '0';

        wait;
    end process;

    process
    begin
        wait for 100 ns;

        op_code_s <= "0000";
        wait for 50 ns;
        assert jump_en_s = '0' report "Jump should be 0 if op_code is 0000" severity error;
        assert ula_op_sel_s = "00" report "ULA op should be 00 if op_code is 0000" severity error;
        wait for 250 ns;

        op_code_s <= "1111";
        wait for 50 ns;
        assert jump_en_s = '1' report "Jump should be 1 if op_code is 1111" severity error;
        assert ula_op_sel_s = "00" report "ULA op should be 00 if op_code is 1111" severity error;
        wait for 250 ns;

        wait;
    end process;
end architecture a_control_unit_tb;