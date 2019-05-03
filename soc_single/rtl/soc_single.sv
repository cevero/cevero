`include "../ip/soc_components/sp_ram/rtl/sp_ram.sv"

module soc
#(
	parameter N_EXT_PERF_COUNTERS = 0,
	parameter RV32E               = 0,
	parameter RV32M               = 0
)(
	input  logic        clk_i,
	input  logic        rst_ni,
	input  logic        fetch_enable_i,
	output logic [31:0] mem_flag_o,
	output logic [31:0] mem_result_o,
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
	
	// Interrupt /* inputs
	logic           irq;
	logic [4:0]     irq_id_in;
	logic           irq_ack;
	logic [4:0]     irq_id_out;
	
	// Debug Interface
	logic           debug_req;
	logic           debug_gnt;
	logic           debug_rvalid;
	logic [14:0]    debug_addr;
	logic           debug_we;
	logic [31:0]    debug_wdata;
	logic [31:0]    debug_rdata;
	logic           debug_halted;
	logic           debug_halt;
	logic           debug_resume;

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

	sp_ram inst_mem
	(
		.clk                 ( clk_i               ),
		.rst_n               ( 1'b1                ),
		
		.port_req_i          ( instr_req           ),
		.port_gnt_o          ( instr_gnt           ),
		.port_rvalid_o       ( instr_rvalid        ),
		.port_addr_i         ( instr_addr          ),
		.port_we_i           ( 1'b0                ),
		.port_rdata_o        ( instr_rdata         ),
		.port_wdata_i        ( 32'b0               ),
		
		.mem_flag            (                     ),
		.mem_result          (                     )
	);
	
	sp_ram data_mem
	(
		.clk                 ( clk_i               ),
		.rst_n               ( 1'b1                ),
		
		.port_req_i          ( data_req            ),
		.port_gnt_o          ( data_gnt            ),
		.port_rvalid_o       ( data_rvalid         ),
		.port_addr_i         ( data_addr           ),
		.port_we_i           ( data_we             ),
		.port_rdata_o        ( data_rdata          ),
		.port_wdata_i        ( data_wdata          ),
		
		.mem_flag            ( mem_flag_o          ),
		.mem_result          ( mem_result_o        )
	);
	  
	zeroriscy_core 
	#(
		.N_EXT_PERF_COUNTERS ( N_EXT_PERF_COUNTERS ), 
		.RV32E               ( RV32E               ), 
		.RV32M               ( RV32M               )
	)core(
		.clk_i               ( clk_i               ),
		.rst_ni              ( rst_ni              ),
		
		.clock_en_i          ( clock_en            ),
		.test_en_i           ( test_en             ),
		
		.core_id_i           ( core_id             ),
		.cluster_id_i        ( cluster_id          ),
		.boot_addr_i         ( boot_addr           ),
		
		.instr_req_o         ( instr_req           ),
		.instr_gnt_i         ( instr_gnt           ),
		.instr_rvalid_i      ( instr_rvalid        ),
		.instr_addr_o        ( instr_addr          ),
		.instr_rdata_i       ( instr_rdata         ),
		
		.data_req_o          ( data_req            ),
		.data_gnt_i          ( data_gnt            ),
		.data_rvalid_i       ( data_rvalid         ),
		.data_we_o           ( data_we             ),
		.data_be_o           ( data_be             ),
		.data_addr_o         ( data_addr           ),
		.data_wdata_o        ( data_wdata          ),
		.data_rdata_i        ( data_rdata          ),
		.data_err_i          ( data_err            ),
		
		.irq_i               ( irq                 ),
		.irq_id_i            ( irq_id_in           ),
		.irq_ack_o           ( irq_ack             ),
		.irq_id_o            ( irq_id_out          ),
		
		.debug_req_i         ( debug_req           ),
		.debug_gnt_o         ( debug_gnt           ),
		.debug_rvalid_o      ( debug_rvalid        ),
		.debug_addr_i        ( debug_addr          ),
		.debug_we_i          ( debug_we            ),
		.debug_wdata_i       ( debug_wdata         ),
		.debug_rdata_o       ( debug_rdata         ),
		.debug_halted_o      ( debug_halted        ),
		.debug_halt_i        ( debug_halt          ),
		.debug_resume_i      ( debug_resume        ),
		
		.fetch_enable_i      ( fetch_enable_i      ),
	
		.ext_perf_counters_i (                     )
	);
	
endmodule
