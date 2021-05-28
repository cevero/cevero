typedef logic [7:0] byte_t;
typedef byte_t [3:0] word;

module recovery_code_rom #(
	parameter unsigned ROM_SIZE = 32'd32
)(
	input  				clk_i,
	input  				req_i,
	input  		 [31:0] addr_i,
	output logic [31:0] rdata_o
);

  word [0:ROM_SIZE-1] mem_data; 
  assign mem_data = {
	32'h02a10113,
	32'h01610113,
	32'h00b10113,
	32'h7b200073, //dret
	32'h00000023, //nop
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013,
	32'h00000013
  };

	logic [31:0] addr_q;

	always @(posedge clk_i) begin
		if(req_i) begin
			addr_q <= addr_i[31:2];
		end
	end

  assign rdata_o = ( addr_q >= ROM_SIZE )? 32'h0 : mem_data[addr_q];

endmodule