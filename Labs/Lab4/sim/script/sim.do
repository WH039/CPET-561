vlib work
vcom -2008 -work work ../../src/servo_controller.vhd
vcom -2008 -work work ../src/lab4_servo_controller_tb.vhd
vsim -voptargs=+acc lab4_servo_controller_tb
do wave.do
run 1000 ms