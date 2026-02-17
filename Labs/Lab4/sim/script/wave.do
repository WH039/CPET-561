onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab4_servo_controller_tb/UUT/clk
add wave -noupdate /lab4_servo_controller_tb/UUT/reset_n
add wave -noupdate /lab4_servo_controller_tb/UUT/address_bit
add wave -noupdate /lab4_servo_controller_tb/UUT/write
add wave -noupdate -radix decimal /lab4_servo_controller_tb/UUT/write_data
add wave -noupdate /lab4_servo_controller_tb/UUT/irq
add wave -noupdate -color Yellow /lab4_servo_controller_tb/UUT/pwm_out
add wave -noupdate -color green /lab4_servo_controller_tb/UUT/current_state
add wave -noupdate -color blue /lab4_servo_controller_tb/UUT/next_state
add wave -noupdate -color purple -radix decimal /lab4_servo_controller_tb/UUT/top_angle_ctr
add wave -noupdate -color purple -radix decimal /lab4_servo_controller_tb/UUT/bot_angle_ctr
add wave -noupdate -color purple -radix decimal /lab4_servo_controller_tb/UUT/period_ctr
add wave -noupdate -color orange -radix decimal /lab4_servo_controller_tb/UUT/current_bot_limit
add wave -noupdate -color orange -radix decimal /lab4_servo_controller_tb/UUT/current_top_limit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1398419860 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 112
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1050 ms}