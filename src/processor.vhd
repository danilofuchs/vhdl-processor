library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processor is
    port (
        clk : in std_logic;
        rst : in std_logic
    );
end entity processor;
architecture a_processor of processor is

    component rom
        port (
            clk : in std_logic;
            address : in unsigned(6 downto 0);
            data : out unsigned(15 downto 0)
        );
    end component;

    component reg16bits
        port (
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component control_unit is
        port (
            clk : in std_logic;
            rst : in std_logic;

            op_code : in unsigned(3 downto 0);

            jump_en : out std_logic;
            pc_wr_en : out std_logic

            -- ula_op : out unsigned(1 downto 0);
            -- ula_src : out std_logic;
        );
    end component;

    signal pc_in_s, pc_out_s : unsigned(15 downto 0) := "0000000000000000";
    signal instruction_s : unsigned(15 downto 0) := "0000000000000000";
    signal jump_en_s, pc_wr_en_s : std_logic := '0';

begin
    pc_component : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => pc_wr_en_s,
        data_in => pc_in_s,

        data_out => pc_out_s
    );

    rom_component : rom port map(
        clk => clk,
        address => pc_out_s(6 downto 0),

        data => instruction_s
    );

    control_unit_component : control_unit port map(
        clk => clk,
        rst => rst,
        op_code => instruction_s(15 downto 12),

        jump_en => jump_en_s,
        pc_wr_en => pc_wr_en_s
    );

    pc_in_s <=
        "0000" & instruction_s(11 downto 0) when jump_en_s = '1' else
        pc_out_s + 1;

end architecture a_processor;