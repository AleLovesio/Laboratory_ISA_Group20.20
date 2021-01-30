vcom -93 -work ./work ../alu/andi_op.vhd
vcom -93 -work ./work ../alu/xor_op.vhd
vcom -93 -work ./work ../alu/adder.vhd
vcom -93 -work ./work ../alu/adder_subtractor.vhd
vcom -93 -work ./work ../alu/eq_comparator.vhd
vcom -93 -work ./work ../alu/slt_comparator.vhd
vcom -93 -work ./work ../alu/imm_arith_rshift.vhd
vcom -93 -work ./work ../alu/alu_cu.vhd
vcom -93 -work ./work ../alu/alu_b.vhd

vcom -93 -work ./work ../riscv/mux2to1.vhd
vcom -93 -work ./work ../riscv/mux3to1.vhd
vcom -93 -work ./work ../riscv/mux4to1.vhd
vcom -93 -work ./work ../riscv/shift_left_1.vhd
vcom -93 -work ./work ../riscv/register_1bit.vhd
vcom -93 -work ./work ../riscv/generic_register.vhd
vcom -93 -work ./work ../riscv/register_file.vhd
vcom -93 -work ./work ../riscv/control_unit.vhd
vcom -93 -work ./work ../riscv/imm_gen.vhd
vcom -93 -work ./work ../riscv/hazard_unit.vhd
vcom -93 -work ./work ../riscv/fwd_unit.vhd
vcom -93 -work ./work ../riscv/riscv.vhd


vcom -93 -work ./work ../TB/clk_gen.vhd
vcom -93 -work ./work ../TB/instruction_mem.vhd
vcom -93 -work ./work ../TB/data_mem.vhd


vlog -work ./work ../TB/tb_riscv.v

vsim work.tb_riscv

add wave *
add wave DM/mem
#add wave RV/*
#add wave RV/ID_REG_FILE/REG
#add wave RV/EX_ALU/*

run 2500ns
