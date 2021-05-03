
module tb_dbg_mode_2;
    logic        clk;
    logic [31:0] data;
    logic [31:0] addr;
    logic        req;
	

 recovery_code_rom #(
		 .ROM_BASE (32'h00040080)
 )rec_rom (
     .clk_i (clk),
     .req_i (req),
     .addr_i(addr),
     .rdata_o(data)
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
		addr = 32'h0000000;
		req =0;
        $display("> time  |   addr  |   data  |  req      \n");
        $monitor(" %5t   |   %h      |   %h   |   %h    ",  $time, addr,data,req);
		#2;
		req=1;

        #1000 $finish; 
    end

endmodule
