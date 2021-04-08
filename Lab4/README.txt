This folder contains multiple folders along with the report in pdf format. These folders are:
	-doc: 
		Contains the pdf files of the UVM description, the laboratory assignment and 
		a folder with the given UVM files.
	-Sum:
	-Dadda:
	-FP:
		Each of these folders is dedicated to a part of the assignment. The Sum folder 
		is dedicated to the first part where a simple adder is tested in multipler ways.
		The Dadda folder is dedicated to the testing of the MBE Dadda Multiplier.
		The FP folder is dedicated to the testing of the full Floating Point Multiplier
		All three folders have the same structure inside with the following folders:
			-sim: 
				Folder used for the QuestaSim sumulations, contains the 
				simulation scripts and the obtained transcripts for the various 
				test cases presented in the report. The work folder and other 
				files related to the simulations have been removed.
			-src:
				Folder that contains the files related to the Device Under Test 
				(Like the adder or the multipliers) and the related interface 
				files.
			-tb:
				Folder that contains the files strictly related to the UVM 
				verification environment.