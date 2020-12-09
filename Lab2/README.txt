This folder contains multiple folders. The multiplier_* folders all have a similar internal structure. These folders are:
	-doc:
		Contains:
			- The input HEX file used for the simulation stimuli (fp_samples.hex)
			- The correct output HEX file used for the simulation verification (fp_prod.hex)
			- A folder named 100rand containing 2 HEX files like the two mentioned above but with 100 additional
			  test numbers.
	-multiplier_version_a:
	-multiplier_version_b:
	-multiplier_version_c:
	-multiplier_version_mbe_dadda:
		They all have the same structure. The version_a has less folders and files as it wasn't synthetized. version_a
		is the folder for the initial architecture, unchanged from the one that was downloaded; version_b is for the 
		first set of architectures with a set of registers added at the input; version_c is of the second set of 
		architectures that require a set of registers after the internal multiplier; version_mbe_dadda is for the final
		architecture where the internal multiplier was implemented structurally and not behaviorally.
		These folders contain the following folders:
		-netlist:
			Contains the verilog netlist, the SDF and the SDC files obtained after the synthesis process.
		-sim:
			Contains the following scripts:
				-simulation.do : Modelsim script used to simulate the filter before the synthesis.
				-fp_prod_sim.hex : HEX file containing the results of the last simulation that was launched.
		-src:
			Contains all the source VHDL files to implement the multiplier.
		-syn:
			Contains the following files:
				-syn_*.scr : Synopsis script to synthesize the multiplier, generate area and timing report.
				-mult_*.ddc : Synopsis save file to reload the synthetized architectures.
				-.synopsys_dc.setup : Synopsys initialization file.
			Contains the following folder:
				-reports:
					Contains the following reports:
						-compile_*: compile log of the * architecture
						-elaborate_*: elaborate log of the * architecture
						-timing_*: timing report of the * architecture
						-area_*: area report of the * architecture
		-tb:
			Contains the VHDL and verilog files to implement the test bench.