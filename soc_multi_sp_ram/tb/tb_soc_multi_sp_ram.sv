module tb_soc_multi_sp_ram;

    logic        clk_i;
    logic        rst_ni;
    logic        fetch_en_i;
    logic [31:0] mem_flag;
    logic [31:0] mem_result;
    logic [31:0] instr_addr_0;

    soc dut
    (
        .clk_i          (clk_i       ),
        .rst_ni         (rst_ni      ),
        .fetch_enable_i (fetch_en_i  ),
        .mem_flag_o     (),
        .mem_result_o   (),
        .instr_addr_o_0 (instr_addr_0)
    );

    initial begin
        for(int i = 0; i != 255; i = i + 1)
            dut.inst_mem.mem[i] = 32'bx;
        $readmemb("../ip/soc_components/soc_utils/fibonacci_byte.bin", dut.inst_mem.mem);
    end

    initial clk_i = 0;
    always #5 clk_i = ~clk_i;

    assign mem_flag = dut.data_mem.mem[0];
    assign mem_result = dut.data_mem.mem[1]; // word addr
      
    initial begin
		dut.u_core0.instr_fetch_err <= 0;
		dut.u_core1.instr_fetch_err <= 0;
        $display("time | inst_addr_0 | mem_flag | mem_result |\n");
        $monitor ("%4t | %11h | %8b | %10d |", $time, instr_addr_0, mem_flag, mem_result);
         
        rst_ni = 0;
        fetch_en_i = 0;
        #20;
        rst_ni = 1;
        fetch_en_i = 1;
        #10;
        
        #1000 $finish; // timeout if mem_flag never rises
    end
    
    always @*
      if (mem_flag)
          #5 $finish;

endmodule
