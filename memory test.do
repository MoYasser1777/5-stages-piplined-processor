force -freeze sim:/main/reset 1 0
force -freeze sim:/main/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/main/enable 1 0
force -freeze sim:/main/in_port_data 00001100110110101111111000011001 0
run
force -freeze sim:/main/reset 0 0
run
run
run
run
run
force -freeze sim:/main/in_port_data 00000000000000001111111111111111 0
run
force -freeze sim:/main/in_port_data 00000000000000001111001100100000 0