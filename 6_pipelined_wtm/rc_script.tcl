#Change user_name as your hpc_user_account_name
#Change Roll_number with your rollnumber
#Change designTOP with your top_module name
#Change top.v to your top_module name with extension, similar with all submodules sub.v

set_attr lib_search_path /home/cadence/cadence_tools/genus_lib
#set_attr library /home/cadence/cadence_tools/genus_lib/slow_vdd1v0_basicCells.lib
set_attr library /home/cadence/cadence_tools/genus_lib/tcbn45gsbwpbc0d88_ccs.lib

set_attr hdl_search_path /home/hprcse/Desktop/work/genus/CED16I002/6_pipelined_wtm
read_hdl {Wtm_pp.v}
#read_sdc > /home/iiitdm/Desktop/work/Roll_number/designTOP.sdc

elaborate
synthesize -to_mapped -effort low

write_hdl > /home/hprcse/Desktop/work/genus/CED16I002/6_pipelined_wtm/wtmPL_netlist.v
#write_sdc > /home/iiitdm/Desktop/work/Roll_number/designTOP_sdc.sdc

#report timing
#report power
#report area

gui_show
