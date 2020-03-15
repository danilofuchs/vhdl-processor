library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux4x1 is
    port (
        sel0, sel1 : in std_logic;
        in0, in1, in2, in3 : in std_logic;

        out0 : out std_logic
    );
end entity mux4x1;

architecture a_mux4x1 of mux4x1 is
begin
    out0 <=
        in0 when sel1 = '0' and sel0 = '0' else
        in1 when sel1 = '0' and sel0 = '1' else
        in2 when sel1 = '1' and sel0 = '0' else
        in3 when sel1 = '1' and sel0 = '1' else
        '0';

end architecture a_mux4x1;