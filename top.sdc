
create_clock -name clk -period 3.33 [get_ports clk]

#set_false_path -from [get_ports {rst}] -to [all_registers]
