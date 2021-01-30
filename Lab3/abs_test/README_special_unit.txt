This folder contains multiple folders and files. These files are:
	-abs_val.vhd	 : VHDL file with the 3 different architectures of the entity that produces the absolute value.
	-sfu.vhd	 : VHDL file that has the same structure of the ALU, but dedicated for the special functions.
	-clean_up.sh	 : Bash file used to clean up the modelsim and syn folders from useless files.
	-vcd2saif.sh	 : Bash file used to convert the vcd files present into the sfu_* folders into saif files. 
	-log_syn_sfu.txt : Synopsys synthetis log file.
	
While the folders are:
	-modelsim:
		Folder used for Modelsim simulations. Contains the following files:
		-forward.do     : Modelsim script used to simulate the special unit after the synthesis and generate 
				  the VCD file.
		-sfu_sim_in.txt : Text files containing the values given in input to the special unit.
	-syn:
		Contains the generated files after the synthesis process and the following scripts:
		-.synopsys_dc.setup : Synopsys initialization file.
		-init.scr 	    : Synopsis script to launch the main script file, sets some variables.
		-iir_syn.scr 	    : Synopsis script to synthesize the special unit, generate area and timing report and 
				      obtain VCD file.
		-backward.scr 	    : Synopsis script to generate the power results starting from the SAIF file
	-TB:
		Contains the VHDL and verilog files to implement the test bench used to run the program.
	-reports:
		Contains all the Area, Power, Timing, compile and problems reports for the three versions of the 
		abs_val entity.
	-sfu_Behavioral:
	-sfu_Behavioral_codelike:
	-sfu_UltraBehavioral:
		Each folder contains the Area, Power, Timing, compile and problems reports (which have also been copied 
		into the reports folder for easier access) as well as the synthtized netlist in verilog format, the sdf
		delay file, the vcd and saif activity files and the Synopsys ddc save file.
		