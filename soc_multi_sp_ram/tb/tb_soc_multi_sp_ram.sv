module tb_soc_multi_sp_ram;

    logic        clk_i;
    logic        rst_ni;
    logic        fetch_en_i;

    logic        signal;
    logic [31:0] mem_flag;
    logic [31:0] mem_result;
    logic [31:0] instr_addr_1;
    logic [31:0] instr_addr_2;

    logic        we_1;
    logic        we_2;
    logic [31:0] addr_1;
    logic [31:0] addr_2;
    logic [31:0] data_1;
    logic [31:0] data_2;

    soc dut
    (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .fetch_enable_i(fetch_en_i),

        .signal(signal),
        .mem_flag(mem_flag),
        .mem_result(mem_result),
        .instr_addr_1(instr_addr_1),
        .instr_addr_2(instr_addr_2),

        .we_1(we_1),
        .we_2(we_2),
        .addr_1(addr_1),
        .addr_2(addr_2),
        .data_1(data_1),
        .data_2(data_2)
    );

    initial clk_i = 0;
    always #5 clk_i = ~clk_i;
      
    initial begin
        $display("time | inst_addr_1 | inst_addr_2 | mem_flag | mem_result || we_1 | we_2 | addr_1 | addr_2 | data_1 | data_2 | sig |\n");
        $monitor ("%4t | %11h | %11h | %8b | %10d || %4b | %4b | %6h | %6h | %6d | %6d | %3b |", $time, instr_addr_1, instr_addr_2, mem_flag, mem_result, we_1, we_2, addr_1, addr_2, data_1, data_2, signal);
         
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
