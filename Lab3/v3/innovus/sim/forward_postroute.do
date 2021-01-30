vcom -93 -work ./work ../../TB/clk_gen.vhd
vcom -93 -work ./work ../../TB/instruction_mem.vhd
vcom -93 -work ./work ../../TB/data_mem.vhd

vlog -work ./work ../riscv_postroute.v
vlog -work ./work ../../TB/tb_riscv.v

vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_riscv/RV=../riscv_postroute.sdf work.tb_riscv -t 1ns

# vcd file ../vcd/riscv_v2.vcd
# vcd add /tb_riscv/RV/*

add wave *
add wave DM/mem
add wave RV/*

run 2500ns