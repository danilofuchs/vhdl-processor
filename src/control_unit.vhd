-- Author: Danilo Fuchs
-- Control unit

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
    port (
        clk : in std_logic;
        rst : in std_logic;

        op_code : in unsigned(3 downto 0);

        jump_en : out std_logic;
        pc_wr_en : out std_logic

        -- ula_op : out unsigned(1 downto 0);
        -- ula_src : out std_logic;
    );
end entity control_unit;

architecture a_control_unit of control_unit is

    component state_machine
        port (
            clk : in std_logic;
            rst : in std_logic;
            state : out std_logic
        );
    end component;

    signal state_s : std_logic;
begin
    state_machine_component : state_machine port map(
        clk => clk,
        rst => rst,
        state => state_s
    );

    pc_wr_en <=
        '1' when state_s = '1' else
        '0';

    jump_en <=
        '1' when op_code = "1111" else
        '0';

end architecture a_control_unit;