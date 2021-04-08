vcom ../src/half_adder.vhd
vcom ../src/full_adder.vhd
vcom ../src/multiplier_mbe_dadda.vhd
vlog -sv ../tb/top.sv
vsim top
run 4us
