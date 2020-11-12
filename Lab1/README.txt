The project files are organized in two different folders:
	-iir_basic:
		Contains all the files about the basic version of the filter.
	-iir_LA
		Contains all the files about the advanced versione of the filter (after having apply the look ahead technique)
	
Both the previous folders are organized in the same way, in particular inside each of them we have the following subfolders:
	-doc:
		Contains:
			-all the MATLAB scripts needed for the initial analysis ('my_iir_filter.m', 'my_iir_design.m', 'lab1.m', 'thdcheck.m')
			-the C source file needed to implement the reference model for the filter
			-all the .txt file containing the input samples used for the simulation and the output results
			-the two files needed to correclty set the Innovus environement ('design.globals' and 'mmm_design.tcl')
	-innovus:
		Contains all the innovus related files and projects, including the generated netlist, power and timing reports and images.
	-netlist:
		Contains the verilog netlist, the SDF and the SDC files obtained after the synthesis process.
	-saif:
		Contains the SAIF file needed to obtain the correct power results. 
		It has been generated starting from the VCD file obtained with the simulation after synthesis.
	-sim:
		Contains the following scripts:
			-simulation.do : Modelsim script used to simulate the filter before the synthesis
			-forward.do : Modelsim script used to simulate the filter after the synthesis and generate te VCD file.
			-forward_postroute.do : Modelsim script used to simulate the filter after the place and route and generate te VCD file.
	-src:
		Contains all the source VHDL files to implement the filter structure.
	-syn:
		Contains the generated report after the synthesis process and the following scripts:
			-iir_syn.scr : Synopsis script to synthesize the filter, generate area and timing report and obtain VCD file.
			-backward.scr : Synopsis script to generate the power results starting from the SAIF file
			-vcd2saif.sh : bash script to automatize the conversion of the VCD file into the SAIF file
	-tb:
		Contains the VHDL and verilog files to implement the test bench.
	-vcd:
		Contains the two VCD files obtained by the simulation after the synthesys and the place and route process.
