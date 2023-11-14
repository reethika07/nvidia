#Synopsys Design Constraints

#Clock constraints
create_clock -period 2.0 -waveform {0 0.5} -name upf_clk [get_ports upf_clk]
set_clock_latency 0.1 [get_clocks *]
set_clock_transition 0.35 [get_clocks *] 
set_clock_uncertainty 0.5 [get_clocks *]

#Timing constraints
set_input_delay -clock upf_clk 1.2 [remove_from_collection [all_inputs] [get_ports upf_clk]]
set_input_transition 0.33 [all_inputs]

set_output_delay -clock upf_clk 0.6 [remove_from_collection [all_outputs] [get_ports upf_clk]]

#
set_load 0.05 [all_outputs]
set_drive 1.0 [remove_from_collection [all_inputs] [get_ports upf_clk]]
#set_driving_cell -lib_cell TNBUFFX1_HVT [all_inputs]



