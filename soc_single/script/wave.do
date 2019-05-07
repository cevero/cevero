onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate :tb_soc_single:clk_i
add wave -noupdate :tb_soc_single:rst_ni
add wave -noupdate :tb_soc_single:fetch_en_i
add wave -noupdate -radix hexadecimal :tb_soc_single:mem_flag
add wave -noupdate -radix hexadecimal :tb_soc_single:mem_result
add wave -noupdate -radix hexadecimal :tb_soc_single:inst_addr
add wave -noupdate :tb_soc_single:debug_req_i
add wave -noupdate -radix hexadecimal :tb_soc_single:debug_addr_i
add wave -noupdate :tb_soc_single:debug_we_i
add wave -noupdate -radix hexadecimal :tb_soc_single:debug_wdata_i
add wave -noupdate :tb_soc_single:debug_halt_i
add wave -noupdate :tb_soc_single:debug_resume_i
add wave -noupdate :tb_soc_single:debug_gnt_o
add wave -noupdate :tb_soc_single:debug_rvalid_o
add wave -noupdate -radix decimal :tb_soc_single:debug_rdata_o
add wave -noupdate :tb_soc_single:debug_halted_o
add wave -noupdate :tb_soc_single:i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 237
configure wave -valuecolwidth 75
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {242 ps}
