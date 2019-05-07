module tb_soc_single;

    logic        clk_i;
    logic        rst_ni;
    logic        fetch_en_i;

    logic [31:0] mem_flag;
    logic [31:0] mem_result;
    logic [31:0] inst_addr;

    logic           debug_req_i;
    logic [14:0]    debug_addr_i;
    logic           debug_we_i;
    logic [31:0]    debug_wdata_i;
    logic           debug_halt_i;
    logic           debug_resume_i;

    logic           debug_gnt_o;
    logic           debug_rvalid_o;
    logic [31:0]    debug_rdata_o;
    logic           debug_halted_o;

    soc dut
    (
        .clk_i          (clk_i     ),
        .rst_ni         (rst_ni    ),
        .fetch_enable_i (fetch_en_i),
        .mem_flag       (mem_flag  ),
        .mem_result     (mem_result),
        .instr_addr     (inst_addr ),

        .debug_req_i    (debug_req_i),
        .debug_addr_i   (debug_addr_i),
        .debug_we_i     (debug_we_i),
        .debug_wdata_i  (debug_wdata_i),
        .debug_halt_i   (debug_halt_i),
        .debug_resume_i (debug_resume_i),

        .debug_gnt_o    (debug_gnt_o),
        .debug_rvalid_o (debug_rvalid_o),
        .debug_rdata_o  (debug_rdata_o),
        .debug_halted_o (debug_halted_o)
    );

    initial begin
        for(int i = 0; i != 255; i = i + 1)
            dut.inst_mem.mem[i] = 32'bx;
        $readmemb("../ip/soc_components/soc_utils/fibonacci.bin", dut.inst_mem.mem);
    end

    initial clk_i = 1;
    always #5 clk_i = ~clk_i;
      
    int i;
    reg [31:0] gpr[32];
    initial begin
        $display(" time  | debug_addr_i |   mem_result   |\n");
        $monitor("%5t  |    %h   | %3d |   %h   | %b | %b | %b | %b | %b | %b |", 
                    $time, debug_addr_i, mem_result, debug_rdata_o,
                    debug_halted_o, debug_gnt_o, debug_rvalid_o, debug_we_i, debug_req_i, debug_resume_i);
        
        // reset procedure
        rst_ni = 0;
        @(posedge clk_i);
        fetch_en_i = 1;
        rst_ni = 1;
        debug_we_i = 0;
        debug_halt_i = 0;
        debug_resume_i = 0;
        debug_req_i = 0;
        debug_wdata_i = 0;
        debug_addr_i = 0;

        // enter debug mode
        #300
        @(posedge clk_i);
        debug_halt_i = 1'b1;
        @(posedge debug_halted_o) // wait until its halted
        debug_halt_i = 1'b0;

        @(posedge clk_i)

        // save all registers
        for (i = 0; i<32; i++) begin
            // read from GPR
            debug_req_i = 1'b1;
            debug_addr_i = 15'h400 + i*4; // reg addr + 0x400 offset
            gpr[i-1] = debug_rdata_o;
            @(posedge debug_rvalid_o)
            $display("%4t - %h - %h - %b", $time, debug_addr_i, debug_rdata_o, debug_rvalid_o);
            debug_req_i <= 1'b0;
            @(posedge clk_i);
        end

        for (i = 0; i<32; i++) begin
            $display("x%1d: %h",i,gpr[i]);
        end


        // write garbage to GPR
        for (i = 0; i<32; i++) begin
            debug_req_i = 1'b1;
            debug_addr_i = 15'h400 + i*4;
            debug_wdata_i = $urandom;
            debug_we_i = 1'b1;
            @(posedge clk_i);
            debug_we_i = 1'b0;
            debug_req_i = 1'b0;
            @(negedge debug_rvalid_o);
        end

        // read all registers
        for (i = 0; i<32; i++) begin
            // read from GPR
            debug_req_i = 1'b1;
            debug_addr_i = 15'h400 + i*4; // x7 addr + 0x400 offset
            @(debug_rvalid_o)
            debug_req_i = 1'b0;
            @(negedge debug_rvalid_o);
        end

        // restore all registers
        for (i = 0; i<32; i++) begin
            debug_req_i = 1'b1;
            debug_addr_i = 15'h400 + i*4;
            debug_wdata_i = gpr[i];
            debug_we_i = 1'b1;
            @(posedge clk_i);
            debug_we_i = 1'b0;
            debug_req_i = 1'b0;
            @(negedge debug_rvalid_o);
        end

        // read all registers
        for (i = 0; i<32; i++) begin
            // read from GPR
            debug_req_i = 1'b1;
            debug_addr_i = 15'h400 + i*4; // x7 addr + 0x400 offset
            if(gpr[i] != debug_rdata_o)
                $display("%5t - Data mismatch reg x%1d. Expect:%h - Got:%h",$time,i,gpr[i],debug_rdata_o);
            @(debug_rvalid_o)
            debug_req_i = 1'b0;
            @(negedge debug_rvalid_o);
        end

        // exit debug mode
        @(posedge clk_i);
        debug_resume_i = 1'b1;
        @(negedge debug_halted_o); // wait until not halted
        debug_resume_i = 1'b0;
        
        #1000 $finish; // timeout if mem_flag never rises
    end
    
    //always @*
      //if (mem_flag)
          //#5 $finish;

endmodule
