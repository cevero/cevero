`include "../../ip/soc_components/dp_ram/rtl/dp_ram.sv"

module soc
#(
	parameter N_EXT_PERF_COUNTERS = 0,
	parameter RV32E               = 0,
	parameter RV32M               = 0
)
(
	input  logic        clk_i,
	input  logic        rst_ni,
	input  logic        fetch_enable_i_0,
	input  logic        fetch_enable_i_1,
	output logic [31:0] mem_flag,
	output logic [31:0] mem_result,
	output logic [31:0] instr_addr0,
	output logic [31:0] instr_addr1
);
	//
	// Core 1 Signals
	//
	
	logic           clock_en_0  = 1;    // enable clock, otherwise it is gated
	logic           test_en_0 = 0;     // enable all clock gates for testing
	
	// Core ID, Cluster ID and boot address are considered more or less static
	logic [ 3:0]    core_id_0 = 0;
	logic [ 5:0]    cluster_id_0 = 1;
	logic [31:0]    boot_addr_0 = 0;
	
	// Instruction memory interface
	logic           instr_req_0;
	logic           instr_gnt_0;
	logic           instr_rvalid_0;
	logic [31:0]    instr_addr_0;
	logic [31:0]    instr_rdata_0;
	logic           instr_err_0;
	
	assign instr_addr0 = instr_addr_0;

	// Data memory interface
	logic           data_req_0;
	logic           data_gnt_0;
	logic           data_rvalid_0;
	logic           data_we_0;
	logic [3:0]     data_be_0;
	logic [31:0]    data_addr_0;
	logic [31:0]    data_wdata_0;
	logic [31:0]    data_rdata_0;
	logic           data_err_0;
	
	// Interrupt /* inputs
	logic           irq_0;           // level sensitive IR lines
	logic [4:0]     irq_id_0;
	logic           irq_ack_0;       // irq ack
	
	// Debug Interface
	logic           debug_req_0;
	
	//
	// Core 2 Signals
	//
	
	logic           clock_en_1  = 1;    // enable clock, otherwise it is gated
	logic           test_en_1 = 0;     // enable all clock gates for testing
	
	// Core ID, Cluster ID and boot address are considered more or less static
	logic [ 3:0]    core_id_1 = 1;
	logic [ 5:0]    cluster_id_1 = 1;
	logic [31:0]    boot_addr_1 = 0;
	
	// Instruction memory interface
	logic           instr_req_1;
	logic           instr_gnt_1;
	logic           instr_rvalid_1;
	logic [31:0]    instr_addr_1;
	logic [31:0]    instr_rdata_1;
	logic           instr_err_1;
	
	assign instr_addr1 = instr_addr_1;
	// Data memory interface
	logic           data_req_1;
	logic           data_gnt_1;
	logic           data_rvalid_1;
	logic           data_we_1;
	logic [3:0]     data_be_1;
	logic [31:0]    data_addr_1;
	logic [31:0]    data_wdata_1;
	logic [31:0]    data_rdata_1;
	logic           data_err_1;
	
	// Interrupt /* inputs
	logic           irq_1;           // level sensitive IR lines
	logic [4:0]     irq_id_1;
	logic           irq_ack_1;       // irq ack
	
	// Debug Interface
	logic           debug_req_1;
	
	dp_ram inst_mem
	(
		.clk(clk_i),
		.rst_n(1'b1),
		
		.port1_req_i(instr_req_0),
		.port1_gnt_o(instr_gnt_0),
		.port1_rvalid_o(instr_rvalid_0),
		.port1_addr_i(instr_addr_0),
		.port1_we_i(1'b0),
		.port1_rdata_o(instr_rdata_0),
		.port1_wdata_i(32'b0),
		
		.port2_req_i(instr_req_1),
		.port2_gnt_o(instr_gnt_1),
		.port2_rvalid_o(instr_rvalid_1),
		.port2_addr_i(instr_addr_1),
		.port2_we_i(1'b0),
		.port2_rdata_o(instr_rdata_1),
		.port2_wdata_i(32'b0),
		
		.mem_flag(),
		.mem_result()
	);
	
	dp_ram data_mem
	(
		.clk(clk_i),
		.rst_n(1'b1),
		
		.port1_req_i(data_req_0),
		.port1_gnt_o(data_gnt_0),
		.port1_rvalid_o(data_rvalid_0),
		.port1_addr_i(data_addr_0),
		.port1_we_i(data_we_0),
		.port1_rdata_o(data_rdata_0),
		.port1_wdata_i(data_wdata_0),
		
		.port2_req_i(data_req_1),
		.port2_gnt_o(data_gnt_1),
		.port2_rvalid_o(data_rvalid_1),
		.port2_addr_i(data_addr_1),
		.port2_we_i(data_we_1),
		.port2_rdata_o(data_rdata_1),
		.port2_wdata_i(data_wdata_1),
		
		.mem_flag(mem_flag),
		.mem_result(mem_result)
	);
	  
ibex_core u_core0
(
    // Clock and reset
    .clk_i          (clk_i),
    .rst_ni         (rst_ni),
    .test_en_i      (test_en_0),

    // Configuration
    .hart_id_i      (32'b0),
    .boot_addr_i    (boot_addr_0),

    // Instruction memory interface
    .instr_req_o    (instr_req_0),
    .instr_gnt_i    (instr_gnt_0),
    .instr_rvalid_i (instr_rvalid_0),
    .instr_addr_o   (instr_addr_0),
    .instr_rdata_i  (instr_rdata_0),
    .instr_err_i    (instr_err_0),

    // Data memory interface
    .data_req_o     (data_req_0),
    .data_gnt_i     (data_gnt_0),
    .data_rvalid_i  (data_rvalid_0),
    .data_we_o      (data_we_0),
    .data_be_o      (data_be_0),
    .data_addr_o    (data_addr_0),
    .data_wdata_o   (data_wdata_0),
    .data_rdata_i   (data_rdata_0),
    .data_err_i     (data_err_0),

    // Interrupt inputs
    .irq_software_i (1'b0),
    .irq_timer_i    (1'b0),
    .irq_external_i (1'b0),
    .irq_fast_i     (15'b0),
    .irq_nm_i       (1'b0),

    // Debug interface
    .debug_req_i    (debug_req_0),

    // Special control signals
    .fetch_enable_i (fetch_enable_i_0),
    .alert_minor_o  (),
    .alert_major_o  (),
    .core_sleep_o   ()
);  

ibex_core u_core1
(
    // Clock and reset
    .clk_i          (clk_i),
    .rst_ni         (rst_ni),
    .test_en_i      (test_en_1),

    // Configuration
    .hart_id_i      (32'b0),
    .boot_addr_i    (boot_addr_1),

    // Instruction memory interface
    .instr_req_o    (instr_req_1),
    .instr_gnt_i    (instr_gnt_1),
    .instr_rvalid_i (instr_rvalid_1),
    .instr_addr_o   (instr_addr_1),
    .instr_rdata_i  (instr_rdata_1),
    .instr_err_i    (instr_err_1),

    // Data memory interface
    .data_req_o     (data_req_1),
    .data_gnt_i     (data_gnt_1),
    .data_rvalid_i  (data_rvalid_1),
    .data_we_o      (data_we_1),
    .data_be_o      (data_be_1),
    .data_addr_o    (data_addr_1),
    .data_wdata_o   (data_wdata_1),
    .data_rdata_i   (data_rdata_1),
    .data_err_i     (data_err_1),

    // Interrupt inputs
    .irq_software_i (1'b0),
    .irq_timer_i    (1'b0),
    .irq_external_i (1'b0),
    .irq_fast_i     (15'b0),
    .irq_nm_i       (1'b0),

    // Debug interface
    .debug_req_i    (debug_req_1),

    // Special control signals
    .fetch_enable_i (fetch_enable_i_1),
    .alert_minor_o  (),
    .alert_major_o  (),
    .core_sleep_o   ()
);
	
endmodule
