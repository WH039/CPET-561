vlib work
vcom -2008 -work work ../ram_be/raminfr_be.vhd
vcom -2008 -work work ../ram_be/raminfr_be_tb.vhd
vsim -voptargs=+acc raminfr_be_tb
do wave.do
run 1000 ms