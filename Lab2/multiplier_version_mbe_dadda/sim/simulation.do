
#compliation of source files
vcom -93 -work ./work ../src/packfp_packfp.vhd
vcom -93 -work ./work ../src/unpackfp_unpackfp.vhd
vcom -93 -work ./work ../src/fpnormalize_fpnormalize.vhd
vcom -93 -work ./work ../src/fpround_fpround.vhd
vcom -93 -work ./work ../src/half_adder.vhd
vcom -93 -work ./work ../src/full_adder.vhd
vcom -93 -work ./work ../src/multiplier_mbe_dadda.vhd
vcom -93 -work ./work ../src/fpmul_stage1_struct.vhd
vcom -93 -work ./work ../src/fpmul_stage2_struct.vhd
vcom -93 -work ./work ../src/fpmul_stage3_struct.vhd
vcom -93 -work ./work ../src/fpmul_stage4_struct.vhd
vcom -93 -work ./work ../src/fpmul_pipeline.vhd

#compiling of test bench
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_maker.vhd
vcom -93 -work ./work ../tb/data_sink.vhd
vlog -work ./work ../tb/tb_fp_mult.v

#starting simulation
vsim work.tb_fp_mult
add wave tb_fp_mult/UUT/I2/mult1/*
add wave tb_fp_mult/UUT/I2/*
add wave tb_fp_mult/UUT/*
add wave tb_fp_mult/*
run 200ns


