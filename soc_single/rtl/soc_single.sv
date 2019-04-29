`include "../sp_ram/rtl/sp_ram.sv"

module zeroriscy_soc
#(
	parameter N_EXT_PERF_COUNTERS = 0,
	parameter RV32E               = 0,
	parameter RV32M               = 0
)
(
	input logic         clk_i,
	input logic         rst_ni,
	input logic         fetch_enable_i,
	output logic [31:0] mem_flag,
	output logic [31:0] mem_result,
	output logic [31:0] instr_addr
);

	// Core
	
	logic           clock_en_i  = 1;    // enable clock, otherwise it is gated
	logic           test_en_i = 0;     // enable all clock gates for testing
	
	// Core ID, Cluster ID and boot address are considered more or less static
	logic [ 3:0]    core_id_i = 0;
	logic [ 5:0]    cluster_id_i = 1;
	logic [31:0]    boot_addr_i = 0;
	
	// Instruction memory interface
	logic           instr_req_o;
	logic           instr_gnt_i;
	logic           instr_rvalid_i;
	logic [31:0]    instr_addr_o;
	assign instr_addr = instr_addr_o;
	logic [31:0]    instr_rdata_i;
	
	// Data memory interface
	logic           data_req_o;
	logic           data_gnt_i;
	logic           data_rvalid_i;
	logic           data_we_o;
	logic [3:0]     data_be_o;
	logic [31:0]    data_addr_o;
	logic [31:0]    data_wdata_o;
	logic [31:0]    data_rdata_i;
	logic           data_err_i;
	
	// Interrupt /* inputs
	logic           irq_i;           // level sensitive IR lines
	logic [4:0]     irq_id_i;
	logic           irq_ack_o;       // irq ack
	logic [4:0]     irq_id_o;
	
	// Debug Interface
	logic           debug_req_i;
	logic           debug_gnt_o;
	logic           debug_rvalid_o;
	logic [14:0]    debug_addr_i;
	logic           debug_we_i;
	logic [31:0]    debug_wdata_i;
	logic [31:0]    debug_rdata_o;
	logic           debug_halted_o;
	logic           debug_halt_i;
	logic           debug_resume_i;

	sp_ram inst_mem
	(
		.clk(clk_i),
		.rst_n(1'b1),
		
		.port_req_i(instr_req_o),
		.port_gnt_o(instr_gnt_i),
		.port_rvalid_o(instr_rvalid_i),
		.port_addr_i(instr_addr_o),
		.port_we_i(1'b0),
		.port_rdata_o(instr_rdata_i),
		.port_wdata_i(32'b0),
		
		.mem_flag(),
		.mem_result()
	);
	
	sp_ram data_mem
	(
		.clk(clk_i),
		.rst_n(1'b1),
		
		.port_req_i(data_req_o),
		.port_gnt_o(data_gnt_i),
		.port_rvalid_o(data_rvalid_i),
		.port_addr_i(data_addr_o),
		.port_we_i(data_we_o),
		.port_rdata_o(data_rdata_i),
		.port_wdata_i(data_wdata_o),
		
		.mem_flag(mem_flag),
		.mem_result(mem_result)
	);
	  
	zeroriscy_core 
	#(
		.N_EXT_PERF_COUNTERS(N_EXT_PERF_COUNTERS), 
		.RV32E(RV32E), 
		.RV32M(RV32M)
	) 
	core
	(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		
		.clock_en_i(clock_en_i),    // enable clock, otherwise it is gated
		.test_en_i(test_en_i),     // enable all clock gates for testing
		
		.core_id_i(core_id_i),
		.cluster_id_i(cluster_id_i),
		.boot_addr_i(boot_addr_i),
		
		.instr_req_o(instr_req_o),
		.instr_gnt_i(instr_gnt_i),
		.instr_rvalid_i(instr_rvalid_i),
		.instr_addr_o(instr_addr_o),
		.instr_rdata_i(instr_rdata_i),
		
		
		.data_req_o(data_req_o),
		.data_gnt_i(data_gnt_i),
		.data_rvalid_i(data_rvalid_i),
		.data_we_o(data_we_o),
		.data_be_o(data_be_o),
		.data_addr_o(data_addr_o),
		.data_wdata_o(data_wdata_o),
		.data_rdata_i(data_rdata_i),
		.data_err_i(data_err_i),
		
		
		.irq_i(irq_i),                 // level sensitive IR lines
		.irq_id_i(irq_id_i),
		.irq_ack_o(irq_ack_o),             // irq ack
		.irq_id_o(irq_id_o),
		
		
		.debug_req_i(debug_req_i),
		.debug_gnt_o(debug_gnt_o),
		.debug_rvalid_o(debug_rvalid_o),
		.debug_addr_i(debug_addr_i),
		.debug_we_i(debug_we_i),
		.debug_wdata_i(debug_wdata_i),
		.debug_rdata_o(debug_rdata_o),
		.debug_halted_o(debug_halted_o),
		.debug_halt_i(debug_halt_i),
		.debug_resume_i(debug_resume_i),
		
		
		.fetch_enable_i(fetch_enable_i),
	
		.ext_perf_counters_i()
	);
	
endmodule
