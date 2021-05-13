onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -position insertpoint sim:/tb_recovery_code_rom/*
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {665 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 263
configure wave -valuecolwidth 82
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {613 ps} {901 ps}
