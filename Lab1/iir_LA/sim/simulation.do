
#compliation of source files
vcom -93 -work ./work ../src/adder.vhd
vcom -93 -work ./work ../src/multiplier.vhd
vcom -93 -work ./work ../src/myiir_adv.vhd

#compiling of test bench
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_maker.vhd
vcom -93 -work ./work ../tb/data_sink.vhd
vlog -work ./work ../tb/tb_iir.v

#starting simulation
vsim work.tb_iir
add wave tb_iir/UUT/*
add wave tb_iir/*
run 4.5us


