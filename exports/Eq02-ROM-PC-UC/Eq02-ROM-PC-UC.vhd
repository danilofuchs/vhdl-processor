-- Author: Danilo Fuchs
-- Control unit

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
    port (
        clk : in std_logic;
        rst : in std_logic
    );
end entity control_unit;

architecture a_control_unit of control_unit is
    component rom
        port (
            clk : in std_logic;
            address : in unsigned(6 downto 0);
            data : out unsigned(11 downto 0)
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

    component state_machine
        port (
            clk : in std_logic;
            rst : in std_logic;
            state : out std_logic
        );
    end component;

    signal pc_in_s, pc_out_s : unsigned(15 downto 0) := "0000000000000000";

    signal data_s : unsigned(11 downto 0);
    signal state_s : std_logic;

    signal instruction : unsigned(11 downto 0);
    signal opcode : unsigned(3 downto 0);
    signal jump_en : std_logic;
    signal jump_address : unsigned(15 downto 0) := (others => '0');
    signal jump_address_int : integer;
begin

    pc : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1',
        data_in => pc_in_s,
        data_out => pc_out_s
    );

    rom_component : rom port map(
        clk => clk,
        address => pc_out_s (6 downto 0),
        data => data_s
    );

    state_machine_component : state_machine port map(
        clk => clk,
        rst => rst,
        state => state_s
    );

    process (state_s)
    begin
        if state_s = '0' then
            instruction <= data_s;
        elsif state_s = '1' then
            if jump_en = '1' then
                pc_in_s <= jump_address;
            else
                pc_in_s <= pc_out_s + 1;
            end if;
        end if;
    end process;

    opcode <= instruction(11 downto 8);
    jump_en <= '1' when opcode = "1111" else
        '0';

    jump_address(6 downto 0) <= instruction(6 downto 0);
end architecture a_control_unit;