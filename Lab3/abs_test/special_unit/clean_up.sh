#!/bin/bash
shopt -s nocaseglob
rm -rf syn/work syn/command.log syn/default.svf syn/filenames.log
rm -rf modelsim/work modelsim/transcript modelsim/vsim.wlf
vlib modelsim/work
rm -f *.txt
if [[ $1 -eq 1 ]]; then
	for dir in */; do
		count=`ls -1 ${dir}*.ddc 2>/dev/null | wc -l`
        	if [[ $count != 0 ]]; then
        		rm -r $dir
        	fi
	done
fi
