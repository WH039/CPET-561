vlib work

vcom -2008 -work work ../multiplier.vhd
vcom -2008 -work work ../high_pass_filter.vhd
vcom -2008 -work work ../hpf_tb.vhd

vsim -voptargs=+acc -msgmode both hpf_tb
do wave.do
run 300 us