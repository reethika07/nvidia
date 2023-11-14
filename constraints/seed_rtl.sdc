#Seed RTL SDC

# Create clock
set design_clk seed_clk
set design_clk_period 1.0

create_clock -period ${design_clk_period} -waveform {0 0.5} -name $design_clk [get_ports clk]
set_clock_transition 0.05 [get_clocks $design_clk]
set_clock_latency 0.2 [get_clocks $design_clk]
set_clock_uncertainty 0.05 -setup [get_clocks $design_clk]
set_clock_uncertainty 0.01 -hold [get_clocks $design_clk]

# 30% of clock period for input delay
set_input_delay -max [expr 0.3 * $design_clk_period] -clock $design_clk [get_ports {A B C D E}]  
set_input_delay -min [expr 0.3 * $design_clk_period] -clock $design_clk [get_ports {A B C D E}]  

#60% of clock periold for output delay
set_output_delay -max [expr 0.3 * $design_clk_period] -clock $design_clk [get_ports {P Q R S T V W X Y Z}]
set_output_delay -min [expr 0.3 * $design_clk_period] -clock $design_clk [get_ports {P Q R S T V W X Y Z}]

#
set_max_delay [expr 0.9 * $design_clk_period] -from [all_inputs] -to [get_ports {P Q X Z}] 
set_input_transition 0.01 [get_ports {A B C D E}] 
#set_drive 0.002 [get_ports {A B C D E}] 

set_load 0.05 [get_ports {P Q R S T V W X Y Z}]


if { [info exists synopsys_program_name ] && ($synopsys_program_name == "icc2_shell") } {
    puts " Creating ICC2 MCMM "
    create_mode func
    create_corner slow
    create_scenario -mode func -corner slow -name func_slow
    current_scenario func_slow
    set_operating_conditions ss0p75v125c
    read_parasitic_tech -tlup $tlu_dir/saed32nm_1p9m_Cmax.tluplus -layermap $tlu_dir/saed32nm_tf_itf_tluplus.map -name Cmax
    read_parasitic_tech -tlup $tlu_dir/saed32nm_1p9m_Cmin.tluplus -layermap $tlu_dir/saed32nm_tf_itf_tluplus.map -name Cmin
 
    set_parasitic_parameters -early_spec Cmax -early_temperature 125
    set_parasitic_parameters -late_spec Cmax -late_temperature 125
    set_scenario_status func_slow -active true -hold true -setup true
}
