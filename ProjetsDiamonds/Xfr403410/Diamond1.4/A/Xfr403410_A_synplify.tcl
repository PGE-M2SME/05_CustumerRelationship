#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology LATTICE-ECP3
set_option -part LFE3_70E
set_option -package FN672C
set_option -speed_grade -8

#compilation/mapping options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true

#use verilog 2001 standard option
set_option -vlog_std v2001

#map options
set_option -frequency 200
set_option -maxfan 1000
set_option -auto_constrain_io 0
set_option -disable_io_insertion false
set_option -retiming false; set_option -pipe true
set_option -force_gsr false
set_option -compiler_compatible 0
set_option -dup false

set_option -default_enum_encoding default

#simulation options


#timing analysis options



#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 1
set_option -update_models_cp 0
set_option -resolve_multiple_driver 0



#-- add_file options
add_file -vhdl {C:/lscc/diamond/3.11_x64/cae_library/synthesis/vhdl/ecp3.vhd}
add_file -vhdl -lib "work" {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/VHDL/CopyVideoTop.vhd}
add_file -vhdl -lib "work" {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/VHDL/I2cMasterCommands.vhd}
add_file -vhdl -lib "work" {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/VHDL/I2CMasterDevice.vhd}
add_file -vhdl -lib "work" {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/VHDL/SeqBlk1204.vhd}
add_file -vhdl -lib "work" {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/VHDL/Forth120719/VHDL/ep32Tss.vhd}
add_file -vhdl -lib "work" {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/VHDL/Forth120719/VHDL/Forth.vhd}
add_file -vhdl -lib "work" {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/VHDL/Forth120719/VHDL/Rx.vhd}
add_file -vhdl -lib "work" {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/VHDL/Forth120719/VHDL/Tx.vhd}
add_file -vhdl -lib "work" {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/VHDL/Forth120719/VHDL/UartTss.vhd}
add_file -vhdl -lib "work" {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/IpxLpc/Pll125to50.vhd}

#-- top module name
set_option -top_module CopyVideoTop

#-- set result format/file last
project -result_file {C:/Users/Cyprien/Documents/GIT/PGE/05_CustumerRelationship/Xfr403410/Diamond1.4/A/Xfr403410_A.edi}

#-- error message log file
project -log_file {Xfr403410_A.srf}

#-- set any command lines input by customer


#-- run Synplify with 'arrange HDL file'
project -run hdl_info_gen -fileorder
project -run
