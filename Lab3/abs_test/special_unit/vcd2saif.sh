#!/bin/bash
for dir in */; do 
	count=`ls -1 ${dir}*.vcd 2>/dev/null | wc -l`
	if [[ $count != 0 ]]; then
		vcd2saif -64 -input ${dir}*.vcd -output ${dir}${dir%?}.saif
	fi
done
