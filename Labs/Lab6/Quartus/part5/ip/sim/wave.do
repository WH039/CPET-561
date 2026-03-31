onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /raminfr_be_tb/uut/clk
add wave -noupdate /raminfr_be_tb/uut/reset_n
add wave -noupdate -radix binary /raminfr_be_tb/uut/writebyteenable_n
add wave -noupdate -radix hexadecimal /raminfr_be_tb/writedata_tb
add wave -noupdate -radix hexadecimal /raminfr_be_tb/checkdata
add wave -noupdate -radix hexadecimal -childformat {{/raminfr_be_tb/readdata_tb(31) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(30) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(29) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(28) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(27) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(26) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(25) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(24) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(23) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(22) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(21) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(20) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(19) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(18) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(17) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(16) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(15) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(14) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(13) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(12) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(11) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(10) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(9) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(8) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(7) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(6) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(5) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(4) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(3) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(2) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(1) -radix hexadecimal} {/raminfr_be_tb/readdata_tb(0) -radix hexadecimal}} -subitemconfig {/raminfr_be_tb/readdata_tb(31) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(30) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(29) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(28) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(27) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(26) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(25) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(24) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(23) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(22) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(21) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(20) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(19) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(18) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(17) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(16) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(15) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(14) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(13) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(12) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(11) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(10) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(9) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(8) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(7) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(6) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(5) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(4) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(3) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(2) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(1) {-height 15 -radix hexadecimal} /raminfr_be_tb/readdata_tb(0) {-height 15 -radix hexadecimal}} /raminfr_be_tb/readdata_tb
add wave -noupdate -radix unsigned /raminfr_be_tb/address_tb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {510 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 343
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
WaveRestoreZoom {0 ns} {3150 ns}