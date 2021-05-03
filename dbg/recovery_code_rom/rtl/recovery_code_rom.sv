module recovery_code_rom #(
		parameter ROM_BASE = 32'h80
)(
  input  logic         clk_i,
  input  logic         req_i,
  input  logic [31:0]  addr_i,
  output logic [31:0]  rdata_o
);

  localparam int unsigned RomSize = 32;

  logic [0:31][31:0] mem;
  assign mem = {
	32'h10000097,
	32'h0000a083,
	32'h0040a103,
	32'h0080a183,
	32'h7b200073, //dret
	32'h00c0a203,
	32'h0100a283,
	32'h0140a303,
	32'h0180a383,
	32'h01c0a403,
	32'h0200a483,
	32'h0240a583,
	32'h0280a603,
	32'h02c0a683,
	32'h0300a703,
	32'h0340a783,
	32'h0380a803,
	32'h03c0a883,
	32'h0400a903,
	32'h0440a983,
	32'h0480aa03,
	32'h04c0aa83,
	32'h0500ab03,
	32'h0540ab83,
	32'h0580ac03,
	32'h05c0ac83,
	32'h0600ad03,
	32'h0640ad83,
	32'h0680ae03,
	32'h06c0ae83,
	32'h0700af03,
	32'h0740af83
	//32'h7b200073 //dret
  };
//TODO: change the  PC

  logic [31:0] addr_q;

  always_ff @(posedge clk_i) begin
    if (req_i) begin
		addr_q <= addr_i;
    end
  end

  always_comb begin : p_outmux
    rdata_o = 32'h0;
    if (addr_q < 32) begin
        rdata_o = mem[addr_q];
    end
  end

endmodule

