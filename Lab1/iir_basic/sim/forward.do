vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_maker.vhd
vcom -93 -work ./work ../tb/data_sink.vhd

vlog -work ./work ../netlist/myiir.v
vlog -work ./work ../tb/tb_iir.v

vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_iir/UUT=../netlist/myiir.sdf work.tb_iir

vcd file ../vcd/myiir_syn.vcd
vcd add /tb_iir/UUT/*

run 4500ns
