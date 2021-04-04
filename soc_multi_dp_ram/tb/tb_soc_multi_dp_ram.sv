module tb_soc_multi_dp_ram;
	logic        clk_i;
	logic        rst_ni;
	logic        fetch_enable_i_0;
	logic        fetch_enable_i_1;
	logic [31:0] mem_flag;
	logic [31:0] mem_result;
	logic [31:0] instr_addr0;
	logic [31:0] instr_addr1;

	soc dut
	(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.fetch_enable_i_0(fetch_enable_i_0),
		.fetch_enable_i_1(fetch_enable_i_1),
		.mem_flag(),
		.mem_result(),
		.instr_addr0(instr_addr0),
		.instr_addr1(instr_addr1)
	);


	initial clk_i = 1;
	always #5 clk_i = ~clk_i;

    assign mem_flag = dut.data_mem.mem[0];
    assign mem_result = dut.data_mem.mem[1]; // word addr
      
	initial begin
		dut.u_core0.instr_fetch_err <= 0;
		dut.u_core1.instr_fetch_err <= 0;
		$display("time | inst_addr0 | inst_addr1 | mem_flag | mem_result |\n");
		$monitor ("%4d | %10h | %10h | %8b | %10d |", $time, instr_addr0, instr_addr1, mem_flag, mem_result);
		 
		rst_ni = 0;
		fetch_enable_i_0 = 1;
		fetch_enable_i_1 = 1;
		#2;
		fetch_enable_i_0 = 1;
		fetch_enable_i_1 = 1;
		rst_ni = 1;
		
		#1000 $finish; // timeout if mem_flag never rises
	end
	
	always @*
		if (mem_flag)
			#5 $finish;

endmodule
