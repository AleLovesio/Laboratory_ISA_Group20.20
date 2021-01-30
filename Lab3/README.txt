This folder contains multiple folders along with the report in pdf format. These folders are:
	-abs_test:
		Folder that contains source, simulation and synthetis files and folders used to evaluate the best architecture 
		of the special unit.
		Contains the special_unit folder which in turn contains the actual files and folders as well as a 
		README_special_unit.txt file for the specific special_unit folder.
	-doc:
		Contains:
			- The original assembly code of the given program
			- The resulting binary code of the given program
			- Various versions of the binary code modified such that it works with a given riscv version.
			  The differences are the additions of nops and the changes due to addition of the special abs 
			  instruction in the final version
	
	-v1:
		Folder relative to the first implemented version which requires additional NOPs to work.
		Contains:
		-sim:
			Contains the following files:
				-simulation.do 	   : Modelsim script used to simulate the riscv program.
				-bin_data.txt  	   : File that contains the initial value of every memory location of the data 
						     memory of the riscv
				-bin_code_nopA.txt : File that contains the assembled program code. This version has additional 
						     NOPs so that it works without the hazard and forwarding units.
		-src:
			Contains all the source VHDL files to implement the riscv. The alu_components folder contains, in
			particular, all the entities used for the ALU.
		-tb:
			Contains the VHDL and verilog files to implement the test bench used to run the program.
	-v2:
	-v3:
		They both have the same structure. The v2 folder is for the fully working version of the baseline RISC-V processor.
		The v3 folder is for the advanced version with the special function unit. The only structure difference between 
		the two is that v3 contains an additional folder for the special unit.
		These folders contain the following folders:
		-netlist:
			Contains the verilog netlist, the SDF and the SDC files obtained after the synthesis process.
			The files are doubled but identical. They are produced by synopsys with a _v2 or _v3 extension that is 
			removed to match the internal entity name.
		-sim:
			Contains the following scripts:
				-simulation_v*.do  	: Modelsim script used to simulate the riscv processor before the synthesis.
							  It is specialized for the given version, v2 or v3.
				-forward.do       	: Modelsim script used to simulate the riscv processor after the synthesis for 
						          backannotation.
				-bin_data.txt  	   	: File that contains the initial value of every memory location of the data 
						     	  memory of the riscv
				-bin_code.txt      	: File that contains the assembled given program code. 
				-bin_code_special.txt   : File that contains the assembled given program code modified to use the
							  adavanced function instrcution that computes the absolute value. 
							  Used only for v3.
		-alu:
			Contains all the source VHDL files to implement the alu portion of the risc-v.
		-special_unit:
			Contains all the source VHDL files to implement the special_unit portion of the risc-v. 
			Applies only to v3.
		-riscv: 
			Contains all the higher level source VHDL files to implement the riscv processor.
		-TB:
			Contains the VHDL and verilog files to implement the test bench used to run the program.
		-syn:
			Contains the following files:
				-syn.scr 		: Synopsis script to synthesize the riscv, generate area and timing reports.
				-riscv_v*.ddc 		: Synopsis save file to reload the synthetized architectures.
				-.synopsys_dc.setup 	: Synopsys initialization file.
			Contains the following folder:
				-reports:
					Contains the following reports:
						-compile_v*: compile log of the v2 or v3 architecture
						-elaborate_v*: elaborate log of the v2 or v3 architecture
						-timing_v*: timing report of the v2 or v3 architecture
						-area_v*: area report of the v2 or v3 architecture
		-innovus:
			Contains all the innovus related files and projects, including the generated netlist and timing reports.
			It also includes the tcl scripts used for the placing and routing, as well as a sim folder used for the
			simulation of the obtained netlist and delay file. This sim folder, similarly to the previously described
			sim folder contains a forward_postroute.do Modelsim script file and the text file for the memories (data
			and instruction) initialization.
			