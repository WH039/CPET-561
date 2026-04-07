vlib work

vcom -2008 -work work ../multiplier.vhd
vcom -2008 -work work ../low_pass_filter.vhd
vcom -2008 -work work ../lpf_tb.vhd

vsim -voptargs=+acc -msgmode both lpf_tb
do wave.do
run 300 us