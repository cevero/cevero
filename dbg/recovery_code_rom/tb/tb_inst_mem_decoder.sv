module tb_dbg_mode_1;
    logic        clk;

	logic           instr_req;
	logic           instr_gnt;
	logic           instr_rvalid;
	logic [31:0]    instr_addr;
	logic [31:0]    instr_rdata;
	logic [31:0]    instr_err;
    
	logic           core_instr_req;
	logic           core_instr_gnt;
	logic           core_instr_rvalid;
	logic [31:0]    core_instr_addr;
	logic [31:0]    core_instr_rdata;
	logic [31:0]    core_instr_err;

	inst_mem_decoder #(
		.ROM_BASE (32'h00040080)
	)inst_mem_dec(
		 .clk_i(clk),
		 .rst_ni(),

		 .core_instr_req_i		(core_instr_req),
		 .core_instr_gnt_o		(core_instr_gnt),
		 .core_instr_rvalid_o	(core_instr_rvalid),
		 .core_instr_addr_i		(core_instr_addr),
		 .core_instr_rdata_o	(core_instr_rdata),
		 .core_instr_err_o		(core_instr_err),

		 .instr_req_o	(instr_req),
		 .instr_gnt_i	(instr_gnt),
		 .instr_rvalid_i(instr_rvalid),
		 .instr_addr_o	(instr_addr),
		 .instr_rdata_i	(instr_rdata),
		 .instr_err_i	(instr_err)
	 );
/*
    initial begin
        $readmemb("../ip/soc_components/soc_utils/fibonacci_byte.bin", dut.inst_mem.mem);
    end
	*/

	//Clock generator
    initial clk = 0;
    always #5 clk = ~clk;
      
    initial begin
		core_instr_req = 0;
		core_instr_addr = 32'h00040080;
        $display(" time  |   inst_addr  |   inst_rdata  |  req      \n");
        $monitor(" %5t   |   %h      |   %h   |   %h    ",  $time, core_instr_addr,core_instr_rdata,core_instr_req);
#1
		core_instr_req = 1;

        #1000 $finish; 
    end

endmodule
