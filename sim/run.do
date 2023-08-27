#compile
vlog \
+incdir+../../rtl/verilog \
+incdir+../top \
+incdir+../wb \
+incdir+../memory \
+incdir+../mii \
+incdir+../phy \
+incdir+../sbd \
+incdir+/hdd2/home/sreeniv/src \
../top/top_tb.sv

/* ....line 10 tell the location of the uvm_pkg.sv   .....*/





/* creating the log files for easier debug */

set testname   mac_100mbps_fd_tx_test          /*test name */
variable time    [format "%s" [clock format [clock seconds] -format %m%d_%H%M]]           /*time stamp */
set log_f "$testname\_$time\.log"





#elaboration
vsim -novopt -suppress 12110 -sv_lib /home/tools/mentor/MENTOR_SOURCE/QUESTA/questasim/uvm-1.2/linux_x86_64/uvm_dpi top_tb +UVM_TESTNAME=$testname -l $log_f

/* line 14 is equvalent to lines 18-20--> anything is fine ..........
line 14 is compulsory when we run uvm code in questasim
*/
/*
vsim -novopt -suppress 12110 \
-sv_lib /home/tools/mentor/MENTOR_SOURCE/QUESTA/questasim/uvm-1.2/linux_x86_64/uvm_dpi \
top_tb           
*/

#add wave
do wave.do
add log -r sim:/top_tb/*

#sim
run -all