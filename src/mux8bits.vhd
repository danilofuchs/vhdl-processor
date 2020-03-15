library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux8bits is
    port (
        in0 : in unsigned(7 downto 0);
        in1 : in unsigned(7 downto 0);
        in2 : in unsigned(7 downto 0);
        in3 : in unsigned(7 downto 0);
        sel : in unsigned(1 downto 0);

        out0 : out unsigned(7 downto 0)
    );
end entity mux8bits;
architecture a_mux8bits of mux8bits is

begin
    out0 <=
        in0 when sel = "00" else
        in1 when sel = "01" else
        in2 when sel = "10" else
        in3 when sel = "11" else
        "00000000";

end architecture a_mux8bits;