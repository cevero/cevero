module tb_soc_multi_dp_ram;
	logic        clk_i;
	logic        rst_ni;
	logic        fetch_enable_i_1;
	logic        fetch_enable_i_2;
	logic [31:0] mem_flag;
	logic [31:0] mem_result;
	logic [31:0] instr_addr1;
	logic [31:0] instr_addr2;

	soc dut
	(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.fetch_enable_i_1(fetch_enable_i_1),
		.fetch_enable_i_2(fetch_enable_i_2),
		.mem_flag(mem_flag),
		.mem_result(mem_result),
		.instr_addr1(instr_addr1),
		.instr_addr2(instr_addr2)
	);

	initial clk_i = 1;
	always #5 clk_i = ~clk_i;
      
	initial begin
		$display("time | inst_addr1 | inst_addr2 | mem_flag | mem_result |\n");
		$monitor ("%4d | %10h | %10h | %8b | %10d |", $time, instr_addr1, instr_addr2, mem_flag, mem_result);
		 
		rst_ni = 0;
		fetch_enable_i_1 = 1;
		fetch_enable_i_2 = 1;
		#2;
		fetch_enable_i_1 = 1;
		fetch_enable_i_2 = 1;
		rst_ni = 1;
		
		#1000 $finish; // timeout if mem_flag never rises
	end
	
	//always @*
	//	if (mem_flag)
	//		#5 $finish;

endmodule
