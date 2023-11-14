set_db timing_report_fields "delay arrival transition fanout load cell timing_point"
set top_design ece581_lp_top
source -echo -verbose ../../$top_design.design_config.tcl
puts "Design Config file completed"

set designs [get_db designs * ]
if { $designs != "" } {
  delete_obj $designs
}

#source ../scripts/genus-get-timlibslefs.tcl

set search_path  "/pkgs/synopsys/2016/libs/SAED32_EDK/lib/stdcell_hvt/db_nldm"
#set_db library "saed32hvt_ff0p85v125c.db saed32hvt_ff1p16v125c.db saed32hvt_dlvl_ff0p85v125c_i1p16v.db saed32hvt_ulvl_ff1p16v125c_i0p85v.db saed32hvt_pg_ff0p85v25c.db saed32hvt_pg_ff1p16v25c.db"
set link_library ""
foreach i $search_path {
  foreach k $synth_corners {
      foreach m $sub_lib_type {
        foreach j [glob -nocomplain $i/$m$k.lib ] {
          lappend link_library [file tail $j ]
        }
      }
  }
}

set_db init_lib_search_path $search_path

set_db library $link_library

set_db dft_opcg_domain_blocking true

set_db auto_ungroup none

# Analyzing the current FIFO design
read_hdl -language sv ../rtl/${top_design}_check.sv

# Elaborate the FIFO design
elaborate $top_design

#return -level 9 

if { [info exists enable_dft] &&  $enable_dft  } {

   if { [file exists ../../${top_design}.dft_eco.tcl] == 1 } {
      # Make eco changes like instantiating a PLL.
      source -echo -verbose ../../${top_design}.dft_eco.tcl
   } 
   # Setup DFT/OPCG dependencies.
   source -echo -verbose ../../${top_design}.dft_config.tcl
}

if { [ info exists add_ios ] && $add_ios } {
   #source -echo -verbose ../scripts/genus-add_ios.tcl
   # Source the design dependent code that will put IOs on different sides
   #source ../../$top_design.add_ios.tcl
}

# This needs to be after add_ios
update_names -map { {"." "_" }} -inst -force
update_names -map {{"[" "_"} {"]" "_"}} -inst -force
update_names -map {{"[" "_"} {"]" "_"}} -port_bus
update_names -map {{"[" "_"} {"]" "_"}} -hport_bus
update_names -inst -hnet -restricted {[} -convert_string "_"
update_names -inst -hnet -restricted {]} -convert_string "_"

create_opcond -name VDDH -voltage 1.16
create_opcond -name VDDL -voltage 0.85
create_opcond -name VDDH_A -voltage 1.16
create_opcond -name VDDH_B -voltage 1.16
create_opcond -name VDDL_C -voltage 0.85
create_opcond -name VDDL_D -voltage 0.85
create_opcond -name VSS -voltage 0.00

# Load the timing and design constraints
source -echo -verbose ../../constraints/${top_design}.sdc
read_power_intent -version 1801 ../rtl/ece581_lp_top_check.upf  -module ece581_lp_top

apply_power_intent
commit_power_intent
set_dont_use [get_lib_cells */DELLN* ]

syn_gen
# any additional non-design specific constraints
#set_max_transition 0.5 [current_design ]

# Duplicate any non-unique modules so details can be different inside for synthesis
uniquify $top_design

if { [info exists enable_dft] &&  $enable_dft  } {

   check_dft_rules
   # Need to have test_mode port defined to run this command. 
   fix_dft_violations -clock -async_set -async_reset -test_control test_mode  
   report dft_registers

}

#compile with ultra features and with scan FFs
syn_map

if { [info exists enable_dft] &&  $enable_dft  } {
   if { [file exists ../../${top_design}.reg_eco.tcl] == 1 } {
      # Make eco changes to registers.
      source -echo -verbose ../../${top_design}.reg_eco.tcl
   } 

   check_dft_rules
   # Connect the scan chain. 
   connect_scan_chains -auto_create_chains 
   report_scan_chains
}

syn_opt

# output reports
set stage genus
report_qor > ../reports/${top_design}.$stage.qorps1.rpt
#report_constraint -all_viol > ../reports/${top_design}.$stage.constraintps2.rpt
report_timing -max_path 1000 > ../reports/${top_design}.$stage.timing.maxps1.rpt
check_timing_intent -verbose  > ../reports/${top_design}.$stage.check_timingps1.rpt
check_design  > ../reports/${top_design}.$stage.check_designps1.rpt
write_power_intent -1801  -base_name   ../reports/${top_design}.$stage
#check_mv_design  > ../reports/${top_design}.$stage.mvrcps1.rpt

# output netlist
write_hdl $top_design > ../outputs/${top_design}.$stage.vg
if { [info exists enable_dft] &&  $enable_dft  } {
   # output scan def. 
   write_scandef $top_design > ../outputs/${top_design}.$stage.scan.def
   write_sdc $top_design > ../outputs/${top_design}.$stage.sdc
}

write_db -all_root_attributes -verbose ../outputs/${top_design}.$stage.db

