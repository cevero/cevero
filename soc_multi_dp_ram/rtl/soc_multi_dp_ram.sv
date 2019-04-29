`include "../dp_ram/rtl/dp_ram.sv"

module soc
#(
	parameter N_EXT_PERF_COUNTERS = 0,
	parameter RV32E               = 0,
	parameter RV32M               = 0
)
(
	input  logic        clk_i,
	input  logic        rst_ni,
	input  logic        fetch_enable_i_1,
	input  logic        fetch_enable_i_2,
	output logic [31:0] mem_flag,
	output logic [31:0] mem_result,
	output logic [31:0] instr_addr1,
	output logic [31:0] instr_addr2
);
	//
	// Core 1 Signals
	//
	
	logic           clock_en_i_1  = 1;    // enable clock, otherwise it is gated
	logic           test_en_i_1 = 0;     // enable all clock gates for testing
	
	// Core ID, Cluster ID and boot address are considered more or less static
	logic [ 3:0]    core_id_i_1 = 0;
	logic [ 5:0]    cluster_id_i_1 = 1;
	logic [31:0]    boot_addr_i_1 = 0;
	
	// Instruction memory interface
	logic           instr_req_o_1;
	logic           instr_gnt_i_1;
	logic           instr_rvalid_i_1;
	logic [31:0]    instr_addr_o_1;
	assign instr_addr1 = instr_addr_o_1;
	logic [31:0]    instr_rdata_i_1;
	
	// Data memory interface
	logic           data_req_o_1;
	logic           data_gnt_i_1;
	logic           data_rvalid_i_1;
	logic           data_we_o_1;
	logic [3:0]     data_be_o_1;
	logic [31:0]    data_addr_o_1;
	logic [31:0]    data_wdata_o_1;
	logic [31:0]    data_rdata_i_1;
	logic           data_err_i_1;
	
	// Interrupt /* inputs
	logic           irq_i_1;           // level sensitive IR lines
	logic [4:0]     irq_id_i_1;
	logic           irq_ack_o_1;       // irq ack
	logic [4:0]     irq_id_o_1;
	
	// Debug Interface
	logic           debug_req_i_1;
	logic           debug_gnt_o_1;
	logic           debug_rvalid_o_1;
	logic [14:0]    debug_addr_i_1;
	logic           debug_we_i_1;
	logic [31:0]    debug_wdata_i_1;
	logic [31:0]    debug_rdata_o_1;
	logic           debug_halted_o_1;
	logic           debug_halt_i_1;
	logic           debug_resume_i_1;
	
	//
	// Core 2 Signals
	//
	
	logic           clock_en_i_2  = 1;    // enable clock, otherwise it is gated
	logic           test_en_i_2 = 0;     // enable all clock gates for testing
	
	// Core ID, Cluster ID and boot address are considered more or less static
	logic [ 3:0]    core_id_i_2 = 1;
	logic [ 5:0]    cluster_id_i_2 = 1;
	logic [31:0]    boot_addr_i_2 = 0;
	
	// Instruction memory interface
	logic           instr_req_o_2;
	logic           instr_gnt_i_2;
	logic           instr_rvalid_i_2;
	logic [31:0]    instr_addr_o_2;
	assign instr_addr2 = instr_addr_o_2;
	logic [31:0]    instr_rdata_i_2;
	
	// Data memory interface
	logic           data_req_o_2;
	logic           data_gnt_i_2;
	logic           data_rvalid_i_2;
	logic           data_we_o_2;
	logic [3:0]     data_be_o_2;
	logic [31:0]    data_addr_o_2;
	logic [31:0]    data_wdata_o_2;
	logic [31:0]    data_rdata_i_2;
	logic           data_err_i_2;
	
	// Interrupt /* inputs
	logic           irq_i_2;           // level sensitive IR lines
	logic [4:0]     irq_id_i_2;
	logic           irq_ack_o_2;       // irq ack
	logic [4:0]     irq_id_o_2;
	
	// Debug Interface
	logic           debug_req_i_2;
	logic           debug_gnt_o_2;
	logic           debug_rvalid_o_2;
	logic [14:0]    debug_addr_i_2;
	logic           debug_we_i_2;
	logic [31:0]    debug_wdata_i_2;
	logic [31:0]    debug_rdata_o_2;
	logic           debug_halted_o_2;
	logic           debug_halt_i_2;
	logic           debug_resume_i_2;
	
	dp_ram inst_mem
	(
		.clk(clk_i),
		.rst_n(1'b1),
		
		.port1_req_i(instr_req_o_1),
		.port1_gnt_o(instr_gnt_i_1),
		.port1_rvalid_o(instr_rvalid_i_1),
		.port1_addr_i(instr_addr_o_1),
		.port1_we_i(1'b0),
		.port1_rdata_o(instr_rdata_i_1),
		.port1_wdata_i(32'b0),
		
		.port2_req_i(instr_req_o_2),
		.port2_gnt_o(instr_gnt_i_2),
		.port2_rvalid_o(instr_rvalid_i_2),
		.port2_addr_i(instr_addr_o_2),
		.port2_we_i(1'b0),
		.port2_rdata_o(instr_rdata_i_2),
		.port2_wdata_i(32'b0),
		
		.mem_flag(),
		.mem_result()
	);
	
	dp_ram data_mem
	(
		.clk(clk_i),
		.rst_n(1'b1),
		
		.port1_req_i(data_req_o_1),
		.port1_gnt_o(data_gnt_i_1),
		.port1_rvalid_o(data_rvalid_i_1),
		.port1_addr_i(data_addr_o_1),
		.port1_we_i(data_we_o_1),
		.port1_rdata_o(data_rdata_i_1),
		.port1_wdata_i(data_wdata_o_1),
		
		.port2_req_i(data_req_o_2),
		.port2_gnt_o(data_gnt_i_2),
		.port2_rvalid_o(data_rvalid_i_2),
		.port2_addr_i(data_addr_o_2),
		.port2_we_i(data_we_o_2),
		.port2_rdata_o(data_rdata_i_2),
		.port2_wdata_i(data_wdata_o_2),
		
		.mem_flag(mem_flag),
		.mem_result(mem_result)
	);
	  
	zeroriscy_core 
	#(
		.N_EXT_PERF_COUNTERS(N_EXT_PERF_COUNTERS), 
		.RV32E(RV32E), 
		.RV32M(RV32M)
	) 
	core0
	(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		
		.clock_en_i(clock_en_i_1),    // enable clock, otherwise it is gated
		.test_en_i(test_en_i_1),     // enable all clock gates for testing
		
		.core_id_i(core_id_i_1),
		.cluster_id_i(cluster_id_i_1),
		.boot_addr_i(boot_addr_i_1),
		
		.instr_req_o(instr_req_o_1),
		.instr_gnt_i(instr_gnt_i_1),
		.instr_rvalid_i(instr_rvalid_i_1),
		.instr_addr_o(instr_addr_o_1),
		.instr_rdata_i(instr_rdata_i_1),
		
		
		.data_req_o(data_req_o_1),
		.data_gnt_i(data_gnt_i_1),
		.data_rvalid_i(data_rvalid_i_1),
		.data_we_o(data_we_o_1),
		.data_be_o(data_be_o_1),
		.data_addr_o(data_addr_o_1),
		.data_wdata_o(data_wdata_o_1),
		.data_rdata_i(data_rdata_i_1),
		.data_err_i(data_err_i_1),
		
		
		.irq_i(irq_i_1),                 // level sensitive IR lines
		.irq_id_i(irq_id_i_1),
		.irq_ack_o(irq_ack_o_1),             // irq ack
		.irq_id_o(irq_id_o_1),
		
		
		.debug_req_i(debug_req_i_1),
		.debug_gnt_o(debug_gnt_o_1),
		.debug_rvalid_o(debug_rvalid_o_1),
		.debug_addr_i(debug_addr_i_1),
		.debug_we_i(debug_we_i_1),
		.debug_wdata_i(debug_wdata_i_1),
		.debug_rdata_o(debug_rdata_o_1),
		.debug_halted_o(debug_halted_o_1),
		.debug_halt_i(debug_halt_i_1),
		.debug_resume_i(debug_resume_i_1),
		
		
		.fetch_enable_i(fetch_enable_i_1),
		
		.ext_perf_counters_i()
	);
	
	zeroriscy_core 
	#(
		.N_EXT_PERF_COUNTERS(N_EXT_PERF_COUNTERS), 
		.RV32E(RV32E), 
		.RV32M(RV32M)
	) 
	core1
	(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		
		.clock_en_i(clock_en_i_2),    // enable clock, otherwise it is gated
		.test_en_i(test_en_i_2),     // enable all clock gates for testing
		
		.core_id_i(core_id_i_2),
		.cluster_id_i(cluster_id_i_2),
		.boot_addr_i(boot_addr_i_2),
		
		.instr_req_o(instr_req_o_2),
		.instr_gnt_i(instr_gnt_i_2),
		.instr_rvalid_i(instr_rvalid_i_2),
		.instr_addr_o(instr_addr_o_2),
		.instr_rdata_i(instr_rdata_i_2),
		
		
		.data_req_o(data_req_o_2),
		.data_gnt_i(data_gnt_i_2),
		.data_rvalid_i(data_rvalid_i_2),
		.data_we_o(data_we_o_2),
		.data_be_o(data_be_o_2),
		.data_addr_o(data_addr_o_2),
		.data_wdata_o(data_wdata_o_2),
		.data_rdata_i(data_rdata_i_2),
		.data_err_i(data_err_i_2),
		
		
		.irq_i(irq_i_2),                 // level sensitive IR lines
		.irq_id_i(irq_id_i_2),
		.irq_ack_o(irq_ack_o_2),             // irq ack
		.irq_id_o(irq_id_o_2),
		
		
		.debug_req_i(debug_req_i_2),
		.debug_gnt_o(debug_gnt_o_2),
		.debug_rvalid_o(debug_rvalid_o_2),
		.debug_addr_i(debug_addr_i_2),
		.debug_we_i(debug_we_i_2),
		.debug_wdata_i(debug_wdata_i_2),
		.debug_rdata_o(debug_rdata_o_2),
		.debug_halted_o(debug_halted_o_2),
		.debug_halt_i(debug_halt_i_2),
		.debug_resume_i(debug_resume_i_2),
		
		
		.fetch_enable_i(fetch_enable_i_2),
		
		.ext_perf_counters_i()
	);
endmodule
