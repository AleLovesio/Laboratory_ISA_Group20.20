
#compilation of source files
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

vlog -sv ../tb/top.sv
vsim top
run 10us


