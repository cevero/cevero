`include "../../ip/soc_components/sp_ram/rtl/sp_ram.sv"

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
	output logic [31:0] instr_addr_o_0
);

    //////////////////////////////////////////////////////////////////
    //                        ___        _                   _      //
    //   ___ ___  _ __ ___   / _ \   ___(_) __ _ _ __   __ _| |___  //
    //  / __/ _ \| '__/ _ \ | | | | / __| |/ _` | '_ \ / _` | / __| //
    // | (_| (_) | | |  __/ | |_| | \__ \ | (_| | | | | (_| | \__ \ //
    //  \___\___/|_|  \___|  \___/  |___/_|\__, |_| |_|\__,_|_|___/ //
    //                                     |___/                    //
    //////////////////////////////////////////////////////////////////
	
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
	logic           irq_0;
	logic [4:0]     irq_id_in_0;
	logic           irq_ack_0;
	logic [4:0]     irq_id_out_0;
	
	// Debug Interface
	logic           debug_req_0;
	logic           debug_gnt_0;
	logic           debug_rvalid_0;
	logic [14:0]    debug_addr_0;
	logic           debug_we_0;
	logic [31:0]    debug_wdata_0;
	logic [31:0]    debug_rdata_0;
	logic           debug_halted_0;
	logic           debug_halt_0;
	logic           debug_resume_0;

    //////////////////////////////////////////////////////////////
    //                       _       _                   _      //
    //   ___ ___  _ __ ___  / |  ___(_) __ _ _ __   __ _| |___  //
    //  / __/ _ \| '__/ _ \ | | / __| |/ _` | '_ \ / _` | / __| //
    // | (_| (_) | | |  __/ | | \__ \ | (_| | | | | (_| | \__ \ //
    //  \___\___/|_|  \___| |_| |___/_|\__, |_| |_|\__,_|_|___/ //
    //                                 |___/                    //
    //////////////////////////////////////////////////////////////

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
	logic           irq_1;
	logic [4:0]     irq_id_in_1;
	logic           irq_ack_1;
	logic [4:0]     irq_id_out_1;
	
	// Debug Interface
	logic           debug_req_1;
	logic           debug_gnt_1;
	logic           debug_rvalid_1;
	logic [14:0]    debug_addr_1;
	logic           debug_we_1;
	logic [31:0]    debug_wdata_1;
	logic [31:0]    debug_rdata_1;
	logic           debug_halted_1;
	logic           debug_halt_1;
	logic           debug_resume_1;

    ///////////////////////////////////////
    //                _                  //
    //   __ _ ___ ___(_) __ _ _ __  ___  //
    //  / _` / __/ __| |/ _` | '_ \/ __| //
    // | (_| \__ \__ \ | (_| | | | \__ \ //
    //  \__,_|___/___/_|\__, |_| |_|___/ //
    //                  |___/            //
    //                                   //
    ///////////////////////////////////////

    // assigns core 0
	assign instr_addr_o_0 = instr_addr_0;
    
    // --- assigns core 1 ---

    // instr memory
    assign instr_rdata_1 = instr_rdata_0;
    assign instr_gnt_1 = instr_gnt_0;
    assign instr_rvalid_1 = instr_rvalid_0;

    // data memory
    assign data_rvalid_1 = data_rvalid_0;
    assign data_gnt_1 = data_gnt_0;
    assign data_rdata_1 = data_rdata_0;

    ////////////////////////////////////////////////////////////////////
    //  _           _              _   _       _   _                  //
    // (_)_ __  ___| |_ __ _ _ __ | |_(_) __ _| |_(_) ___  _ __  ___  //     
    // | | '_ \/ __| __/ _` | '_ \| __| |/ _` | __| |/ _ \| '_ \/ __| //
    // | | | | \__ \ || (_| | | | | |_| | (_| | |_| | (_) | | | \__ \ //
    // |_|_| |_|___/\__\__,_|_| |_|\__|_|\__,_|\__|_|\___/|_| |_|___/ //
    //                                                                //
    ////////////////////////////////////////////////////////////////////

	sp_ram inst_mem
	(
		.clk                 ( clk_i               ),
		.rst_n               ( 1'b1                ),
		
		.port_req_i          ( instr_req_0         ),
		.port_gnt_o          ( instr_gnt_0         ),
		.port_rvalid_o       ( instr_rvalid_0      ),
		.port_addr_i         ( instr_addr_0        ),
		.port_we_i           ( 1'b0                ),
		.port_rdata_o        ( instr_rdata_0       ),
		.port_wdata_i        ( 32'b0               ),
		
		.mem_flag            (                     ),
		.mem_result          (                     )
	);
	
	sp_ram data_mem
	(
		.clk                 ( clk_i               ),
		.rst_n               ( 1'b1                ),
		
		.port_req_i          ( data_req_0          ),
		.port_gnt_o          ( data_gnt_0          ),
		.port_rvalid_o       ( data_rvalid_0       ),
		.port_addr_i         ( data_addr_0         ),
		.port_we_i           ( data_we_0           ),
		.port_rdata_o        ( data_rdata_0        ),
		.port_wdata_i        ( data_wdata_0        ),
		
		.mem_flag            ( mem_flag_o          ),
		.mem_result          ( mem_result_o        )
	);
	  
	zeroriscy_core 
	#(
		.N_EXT_PERF_COUNTERS ( N_EXT_PERF_COUNTERS ), 
		.RV32E               ( RV32E               ), 
		.RV32M               ( RV32M               )
	)core_0(
		.clk_i               ( clk_i               ),
		.rst_ni              ( rst_ni              ),
		
		.clock_en_i          ( clock_en_0          ),
		.test_en_i           ( test_en_0           ),
		
		.core_id_i           ( core_id_0           ),
		.cluster_id_i        ( cluster_id_0        ),
		.boot_addr_i         ( boot_addr_0         ),
		
		.instr_req_o         ( instr_req_0         ),
		.instr_gnt_i         ( instr_gnt_0         ),
		.instr_rvalid_i      ( instr_rvalid_0      ),
		.instr_addr_o        ( instr_addr_0        ),
		.instr_rdata_i       ( instr_rdata_0       ),
		
		.data_req_o          ( data_req_0          ),
		.data_gnt_i          ( data_gnt_0          ),
		.data_rvalid_i       ( data_rvalid_0       ),
		.data_we_o           ( data_we_0           ),
		.data_be_o           ( data_be_0           ),
		.data_addr_o         ( data_addr_0         ),
		.data_wdata_o        ( data_wdata_0        ),
		.data_rdata_i        ( data_rdata_0        ),
		.data_err_i          ( data_err_0          ),
		
		.irq_i               ( irq_0               ),
		.irq_id_i            ( irq_id_in_0         ),
		.irq_ack_o           ( irq_ack_0           ),
		.irq_id_o            ( irq_id_out_0        ),
		
		.debug_req_i         ( debug_req_0         ),
		.debug_gnt_o         ( debug_gnt_0         ),
		.debug_rvalid_o      ( debug_rvalid_0      ),
		.debug_addr_i        ( debug_addr_0        ),
		.debug_we_i          ( debug_we_0          ),
		.debug_wdata_i       ( debug_wdata_0       ),
		.debug_rdata_o       ( debug_rdata_0       ),
		.debug_halted_o      ( debug_halted_0      ),
		.debug_halt_i        ( debug_halt_0        ),
		.debug_resume_i      ( debug_resume_0      ),
		
		.fetch_enable_i      ( fetch_enable_i      ),
	
		.ext_perf_counters_i (                     )
	);

	zeroriscy_core 
	#(
		.N_EXT_PERF_COUNTERS ( N_EXT_PERF_COUNTERS ), 
		.RV32E               ( RV32E               ), 
		.RV32M               ( RV32M               )
	)core_1(
		.clk_i               ( clk_i               ),
		.rst_ni              ( rst_ni              ),
		
		.clock_en_i          ( clock_en_1          ),
		.test_en_i           ( test_en_1           ),
		
		.core_id_i           ( core_id_1           ),
		.cluster_id_i        ( cluster_id_1        ),
		.boot_addr_i         ( boot_addr_1         ),
		
		.instr_req_o         ( instr_req_1         ),
		.instr_gnt_i         ( instr_gnt_1         ),
		.instr_rvalid_i      ( instr_rvalid_1      ),
		.instr_addr_o        ( instr_addr_1        ),
		.instr_rdata_i       ( instr_rdata_1       ),
		
		.data_req_o          ( data_req_1          ),
		.data_gnt_i          ( data_gnt_1          ),
		.data_rvalid_i       ( data_rvalid_1       ),
		.data_we_o           ( data_we_1           ),
		.data_be_o           ( data_be_1           ),
		.data_addr_o         ( data_addr_1         ),
		.data_wdata_o        ( data_wdata_1        ),
		.data_rdata_i        ( data_rdata_1        ),
		.data_err_i          ( data_err_1          ),
		
		.irq_i               ( irq_1               ),
		.irq_id_i            ( irq_id_in_1         ),
		.irq_ack_o           ( irq_ack_1           ),
		.irq_id_o            ( irq_id_out_1 )      ,
		
		.debug_req_i         ( debug_req_1         ),
		.debug_gnt_o         ( debug_gnt_1         ),
		.debug_rvalid_o      ( debug_rvalid_1      ),
		.debug_addr_i        ( debug_addr_1        ),
		.debug_we_i          ( debug_we_1          ),
		.debug_wdata_i       ( debug_wdata_1       ),
		.debug_rdata_o       ( debug_rdata_1       ),
		.debug_halted_o      ( debug_halted_1      ),
		.debug_halt_i        ( debug_halt_1        ),
		.debug_resume_i      ( debug_resume_1      ),
		
		.fetch_enable_i      ( fetch_enable_i      ),
	
		.ext_perf_counters_i (                     )
	);
	
endmodule
