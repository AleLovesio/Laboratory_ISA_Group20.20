set OPTYPE sfu

variable sim_time "1200 ns"

set arch_list "UltraBehavioral Behavioral Behavioral_codelike"	


vcom -93 -work ./work ../TB/clk_gen.vhd
vcom -93 -work ./work ../TB/data_maker.vhd
vcom -93 -work ./work ../TB/data_sink.vhd


foreach index $arch_list {
	
	#compiles verilog netlist and testbench
	vlog -reportprogress 300 -work work ../${OPTYPE}_$index/${OPTYPE}_netlist_$index.v
	vlog -reportprogress 300 -work work ../TB/tb_sfu.v
	

	#simulates 
	vsim -voptargs=+acc -L /software/dk/nangate45/verilog/msim6.5c -sdftyp /tb_sfu/UUT=../${OPTYPE}_$index/${OPTYPE}_$index.sdf work.tb_sfu -t 1ns

	add wave *

	#Generates the VCD file and add all the DUT signals
	vcd file ../${OPTYPE}_$index/${OPTYPE}_$index.vcd
	vcd add /tb_sfu/UUT/*
		
	run $sim_time

	#deletes existing files and moves (file rename) the new file to the correct directory
	if [file exists ../${OPTYPE}_$index/sfu_sim_out_$index.txt] {
		file delete ../${OPTYPE}_$index/sfu_sim_out_$index.txt
	}
	file rename sfu_sim_out.txt ../${OPTYPE}_$index/sfu_sim_out_$index.txt

}



