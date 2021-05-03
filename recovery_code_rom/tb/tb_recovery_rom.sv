
module tb_recovery_code_rom;
  logic clk, req;
  logic [31:0] addr,rdata;

 recovery_code_rom r1 (
     .clk_i (clk),
     .req_i (req),
     .addr_i(addr),
     .rdata_o(rdata)
 );

  initial clk=0;
  always #1 clk = ~clk;

  initial begin
  	addr=0;
   	req =0;
    $display("#		time|  req   |  addr   |   rdata   | clk ");
    $monitor("#%d|  %d   |  %h   |   %h   |%d",$time,req,addr,rdata,clk);
    #3
    req = 1;
    #2;
    addr = 4;
    #2
    addr = 8;
    #2
    req  = 0;

    #100 $finish();
  end
endmodule

