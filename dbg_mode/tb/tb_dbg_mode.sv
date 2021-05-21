module tb_dbg_mode;
    logic        clk;
    logic        rst_n;
    logic        fetch_en;
    logic        debug_req;
	logic [31:0] instr_addr;

	//CHANGE
    logic [31:0] mem_flag;
    logic [31:0] mem_result;
	//

	soc dut(
		.clk_i (clk),		
		.rst_ni (rst_n),		
		.fetch_enable_i (fetch_en),		
		.debug_req_i (debug_req),
		.instr_addr_o (instr_addr)
    );
	
	//CHANGE
    assign mem_flag = dut.data_mem.mem[0];
    assign mem_result = dut.data_mem.mem[1]; // word addr
	//

    initial begin
        $readmemb("../ip/soc_components/soc_utils/fibonacci_byte.bin", dut.inst_mem.mem);
    end

	//Clock generator
    initial clk <= 0;
    always #5 clk <= ~clk;
      
    initial begin
		dut.u_core.instr_fetch_err = 0;
        $display("DBG mode");
        $display(" time  |   inst_addr  |   inst     |   err      |\n");
        $monitor(" %5t   |   %h      |   %h   |  %d       | %d          |     %d      | %d |  %d ",  $time, dut.core_instr_addr, dut.core_instr_rdata, dut.u_core.instr_fetch_err, clk,debug_req,mem_flag,mem_result);
        rst_n = 0;

        #5;
        rst_n = 1;
        fetch_en = 1;

		#190
		debug_req = 1;

		#10
		debug_req = 0;

//#100;
        #1900 $finish; 
    end

    always @*
      if (mem_flag)
          #5 $finish;

endmodule
