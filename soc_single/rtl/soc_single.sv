`include "../ip/soc_components/sp_ram/rtl/sp_ram.sv"

import ibex_pkg::*;

module soc(
	input logic         clk_i,
	input logic         rst_ni,
	input logic         fetch_enable_i,
	output logic [31:0] instr_addr_o
);

    ////////////////////////////////////////////////////////////
    //                            _                   _       //
    //    ___ ___  _ __ ___   ___(_) __ _ _ __   __ _| |___   //
    //   / __/ _ \| '__/ _ \ / __| |/ _` | '_ \ / _` | / __|  //
    //  | (_| (_) | | |  __/ \__ \ | (_| | | | | (_| | \__ \  //
    //   \___\___/|_|  \___| |___/_|\__, |_| |_|\__,_|_|___/  //
    //                              |___/                     //
    //                                                        //
    ////////////////////////////////////////////////////////////

	
	
	logic           clock_en  = 1;    // enable clock, otherwise it is gated
	logic           test_en = 0;     // enable all clock gates for testing
	
	// Core ID, Cluster ID and boot address are considered more or less static
	logic [ 3:0]    core_id = 0;
	logic [ 5:0]    cluster_id = 1;
	logic [31:0]    boot_addr = 0;
	
	// Instruction memory interface
	logic           instr_req_o;
	logic           instr_gnt;
	logic           instr_rvalid;
	logic [31:0]    instr_addr;
	logic [31:0]    instr_rdata;
	logic [31:0]    instr_err;
    
	
	// Data memory interface
	logic           data_req;
	logic           data_gnt;
	logic           data_rvalid;
	logic           data_we;
	logic [3:0]     data_be;
	logic [31:0]    data_addr;
	logic [31:0]    data_wdata;
	logic [31:0]    data_rdata;
	logic           data_err;
	
	// Debug Interface
	logic           debug_req;

    // --- assign ---
	assign instr_addr_o = instr_addr;

    //////////////////////////////////////////////////////////////////////
    //   _           _              _   _       _   _                   //
    //  (_)_ __  ___| |_ __ _ _ __ | |_(_) __ _| |_(_) ___  _ __  ___   //
    //  | | '_ \/ __| __/ _` | '_ \| __| |/ _` | __| |/ _ \| '_ \/ __|  //
    //  | | | | \__ \ || (_| | | | | |_| | (_| | |_| | (_) | | | \__ \  //
    //  |_|_| |_|___/\__\__,_|_| |_|\__|_|\__,_|\__|_|\___/|_| |_|___/  //
    //                                                                  //
    //////////////////////////////////////////////////////////////////////

	sp_ram
	#(
		.ADDR_WIDTH  (32), 
		.DATA_WIDTH (32), 
		.NUM_WORDS  (256)
    ) inst_mem (
		.clk      (clk_i         ),
		.rst_n    (rst_ni        ),
		
		.req_i    (instr_req     ),
		.gnt_o    (instr_gnt     ),
		.rvalid_o (instr_rvalid  ),
		.addr_i   (instr_addr    ),
		.we_i     (1'b0          ),
        .be_i     (4'b1111       ),
		.rdata_o  (instr_rdata   ),
		.wdata_i  (32'b0         )
	);
	
	sp_ram
	#(
		.ADDR_WIDTH  (32), 
		.DATA_WIDTH (32), 
		.NUM_WORDS  (256)
    ) data_mem (
		.clk      (clk_i        ),
		.rst_n    (rst_ni       ),
		
		.req_i    (data_req     ),
		.gnt_o    (data_gnt     ),
		.rvalid_o (data_rvalid  ),
		.addr_i   (data_addr    ),
		.we_i     (data_we      ),
        .be_i     (data_be      ),
		.rdata_o  (data_rdata   ),
		.wdata_i  (data_wdata   )
	);
	  
ibex_core u_core 
(
    // Clock and reset
    .clk_i          (clk_i),
    .rst_ni         (rst_ni),
    .test_en_i      (test_en),

    // Configuration
    .hart_id_i      (32'b0),
    .boot_addr_i    (boot_addr),

    // Instruction memory interface
    .instr_req_o    (instr_req),
    .instr_gnt_i    (instr_gnt),
    .instr_rvalid_i (instr_rvalid),
    .instr_addr_o   (instr_addr),
    .instr_rdata_i  (instr_rdata),
    .instr_err_i    (instr_err),

    // Data memory interface
    .data_req_o     (data_req),
    .data_gnt_i     (data_gnt),
    .data_rvalid_i  (data_rvalid),
    .data_we_o      (data_we),
    .data_be_o      (data_be),
    .data_addr_o    (data_addr),
    .data_wdata_o   (data_wdata),
    .data_rdata_i   (data_rdata),
    .data_err_i     (data_err),

    // Interrupt inputs
    .irq_software_i (1'b0),
    .irq_timer_i    (1'b0),
    .irq_external_i (1'b0),
    .irq_fast_i     (15'b0),
    .irq_nm_i       (1'b0),

    // Debug interface
    .debug_req_i    (debug_req),

    // Special control signals
    .fetch_enable_i (fetch_enable_i),
    .alert_minor_o  (),
    .alert_major_o  (),
    .core_sleep_o   ()
);
	
endmodule
