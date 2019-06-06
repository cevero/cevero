module tb_soc_single;

    logic        clk_i;
    logic        rst_ni;
    logic        fetch_en_i;

    logic [31:0] mem_flag;
    logic [31:0] mem_result;
    logic [31:0] inst_addr;

    soc dut
    (
        .clk_i          (clk_i     ),
        .rst_ni         (rst_ni    ),
        .fetch_enable_i (fetch_en_i),
        .instr_addr_o     (inst_addr )
    );

    initial begin
        $readmemb("../ip/soc_components/soc_utils/fibonacci_byte.bin", dut.inst_mem.mem);
    end

    initial clk_i = 1;
    always #5 clk_i = ~clk_i;
    
    assign mem_flag = dut.data_mem.mem[0];
    assign mem_result = dut.data_mem.mem[1]; // word addr
      
    integer i;
    initial begin
        $display(" time  |   inst_addr  |   mem_flag    |    mem_result   |\n");
        $monitor ("%5t  |   %h   | %1d | %1d | %b | %b | %d | %h |", 
                                $time, inst_addr, mem_flag, mem_result,
                                  dut.data_be_o,
                                  dut.data_we_o,
                                  dut.data_wdata_o,
                                  dut.data_addr_o
                            );
         
        rst_ni = 0;
        fetch_en_i = 1;
        #5;
        rst_ni = 1;

        #1000 $finish; // timeout if mem_flag never rises
    end
    
    always @*
      if (mem_flag)
          #5 $finish;

endmodule
