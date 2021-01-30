vcom -93 -work ./work ../src/alu_components/andi_op.vhd
vcom -93 -work ./work ../src/alu_components/xor_op.vhd
vcom -93 -work ./work ../src/alu_components/adder.vhd
vcom -93 -work ./work ../src/alu_components/adder_subtractor.vhd
vcom -93 -work ./work ../src/alu_components/eq_comparator.vhd
vcom -93 -work ./work ../src/alu_components/slt_comparator.vhd
vcom -93 -work ./work ../src/alu_components/imm_arith_rshift.vhd
vcom -93 -work ./work ../src/alu_components/alu_cu.vhd


vcom -93 -work ./work ../src/alu_b.vhd
vcom -93 -work ./work ../src/mux2to1.vhd
vcom -93 -work ./work ../src/mux3to1.vhd
vcom -93 -work ./work ../src/mux4to1.vhd
vcom -93 -work ./work ../src/shift_left_1.vhd
vcom -93 -work ./work ../src/register_1bit.vhd
vcom -93 -work ./work ../src/generic_register.vhd
vcom -93 -work ./work ../src/register_file.vhd
vcom -93 -work ./work ../src/control_unit.vhd
vcom -93 -work ./work ../src/imm_gen.vhd
vcom -93 -work ./work ../src/hazard_unit.vhd
vcom -93 -work ./work ../src/fwd_unit.vhd
vcom -93 -work ./work ../src/riscv.vhd


vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/instruction_mem.vhd
vcom -93 -work ./work ../tb/data_mem.vhd


vlog -work ./work ../tb/tb_riscv.v

vsim work.tb_riscv

add wave *
add wave DM/mem
#add wave RV/*
#add wave RV/ID_REG_FILE/REG
#add wave RV/EX_ALU/*

run 2500ns
