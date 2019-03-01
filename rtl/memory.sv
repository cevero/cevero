module mem_mod(
  input logic            clk,
  input logic 		     rst_n,
  input logic            port_req_i,
  output logic           port_gnt_o,
  output logic           port_rvalid_o,
  input  logic [31:0]   port_addr_i,
  input  logic           port_we_i,
  //input  logic [IN1_WIDTH/8-1:0]  .port_be_i(be_i),
  output logic [31:0]    port_rdata_o,
  input  logic [31:0]    port_wdata_i
);

  logic [31:0] mem [0:255]; // instruction memory
//logic [15:0] RAM [0:128]; // data memory

initial begin
  for(int i = 0; i != 255; i = i + 1) begin
    mem[i] = 32'bz;
  end
  $readmemb("tb/instmem.bin",mem);

end
  
always_ff @(posedge clk) begin
    if (port_we_i) begin
        mem[port_addr_i] <= port_wdata_i;
    end else begin
        mem[port_addr_i] <= mem[port_addr_i];
    end
end
  
assign port_rdata_o = mem[port_addr_i];
  
always_comb
  begin
	if(port_req_i)
      port_gnt_o = 1'b1;
    else
      port_gnt_o = 1'b0;
end

always_ff @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
    begin
      port_rvalid_o <= 1'b0;
    end
    else
    begin
      port_rvalid_o <= port_gnt_o;
    end
end

endmodule
