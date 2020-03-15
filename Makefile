ula:
	ghdl -a src/ula.vhd
	ghdl -e ula
	ghdl -a src/ula_tb.vhd
	ghdl -e ula_tb
	ghdl -r ula_tb --wave=src/ula_tb.ghw
	# gtkwave src/ula_tb.ghw

ports:
	ghdl -a src/ports.vhd
	ghdl -e ports
	ghdl -a src/ports_tb.vhd
	ghdl -e ports_tb
	# gtkwave src/ports_tb.ghw