ghdl -a ports.vhd
ghdl -e ports

ghdl -a ports_tb.vhd
ghdl -e ports_tb

ghdl -r ports_tb --wave=ports_tb.ghw