`include "../recovery_code_rom/rtl/recovery_code_rom.sv"
`include "../ip/soc_components/sp_ram/rtl/sp_ram.sv"

module instr_mem_decoder #(
	parameter ROM_BASE = 32'h00040080
)(
	input logic			 clk_i,
	input logic		 	 rst_ni,

	input logic			 core_instr_req_i,
	output logic		 core_instr_gnt_o	,
	output logic		 core_instr_rvalid_o,
	input logic	 [31:0]	 core_instr_addr_i	,
	output logic [31:0]	 core_instr_rdata_o	,
	output logic		 core_instr_err_o	,

	output logic		 instr_req_o,
	input logic		 	 instr_gnt_i,
	input logic		   	 instr_rvalid_i,
	output logic [31:0]	 instr_addr_o,
	input logic	 [31:0]	 instr_rdata_i,
	input logic		 	 instr_err_i,
	output logic		 instr_rst_o
);

localparam ROM_SIZE = 32'd32;	
logic [31:0] rom_data;
logic rom_req;
logic rom_gnt;
logic rom_rvalid;
/*
recovery_code_rom rom
(
  .clk_i	(clk_i),
  .req_i	(rom_req),
  .addr_i	(core_instr_addr_i - ROM_BASE),
  .rdata_o  (rom_data)
);
*/

sp_ram
#(
	.ADDR_WIDTH  (32), 
	.DATA_WIDTH (32), 
	.NUM_WORDS  (32)
) rom (
	.clk      (clk_i         ),
	.rst_n    (~instr_rst_o),
	
	.req_i    (rom_req),
	.gnt_o    (rom_gnt     ),
	.rvalid_o (rom_rvalid  ),
	.addr_i   (core_instr_addr_i - ROM_BASE),
	.we_i     (1'b0          ),
	.be_i     (4'b1111       ),
	.rdata_o  (rom_data),
	.wdata_i  (32'b0         )
);


always_comb begin
	if (core_instr_addr_i >= ROM_BASE && core_instr_addr_i < ROM_BASE + 4*ROM_SIZE) begin
		rom_req 			<= core_instr_req_i;
		core_instr_gnt_o 	<= rom_gnt;
		core_instr_rvalid_o <= rom_rvalid;
		core_instr_rdata_o 	<= rom_data;
		core_instr_err_o 	<= 0;
		instr_req_o 		<= 0;
		instr_addr_o 		<= 0;
		instr_rst_o			<= 0;

	end
	else begin
		instr_rst_o			<= 1;
		rom_req 			<= 0;
		core_instr_gnt_o 	<= instr_gnt_i;
		core_instr_rvalid_o <= instr_rvalid_i;
		core_instr_rdata_o 	<= instr_rdata_i;
		core_instr_err_o 	<= 0;
		instr_req_o 		<= core_instr_req_i;
		instr_addr_o 		<= core_instr_addr_i;
	end
end
endmodule
