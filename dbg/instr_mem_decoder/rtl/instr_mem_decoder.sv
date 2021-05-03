module instr_mem_decoder #(
	parameter ROM_BASE = 32'h00040080,
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
	input logic		 	 instr_err_i
);

localparam ROM_SIZE = 32'd32;	
logic [31:0] rom_data;

recovery_code_rom #(
	.ROM_BASE ( 32'h00040080)
)(
  .clk_i	(clk_i),
  .req_i	(core_instr_req_i),
  .addr_i	(core_instr_addr_i - ROM_BASE),
  .rdata_o  (rom_data)
);

always_comb begin
	if (core_instr_addr_i >= ROM_BASE && core_instr_addr_i < ROM_BASE + ROM_SIZE) begin
		core_instr_gnt_o 	<= core_instr_req_i;
		core_instr_rvalid_o <= core_instr_req_i ;
		core_instr_rdata_o <= rom_data;
		core_instr_err_o <= 0;
		instr_req_o <= 0;
		instr_addr_o <= 0;
	end
	else begin
		core_instr_gnt_o <= instr_gnt_i;
		core_instr_rvalid_o <= instr_rvalid_i;
		core_instr_rdata_o <= instr_rdata_i;
		core_instr_err_o <= instr_err_i;
		instr_req_o <= core_instr_req_i;
		instr_addr_o <= core_instr_addr_i;
	end

end


endmodule
