`include "../ip/soc_components/sp_ram/rtl/sp_ram.sv"

module soc
#(
	parameter bit                 PMPEnable        = 1'b0,
    parameter int unsigned        PMPGranularity   = 0,
    parameter int unsigned        PMPNumRegions    = 4,
    parameter int unsigned        MHPMCounterNum   = 0,
    parameter int unsigned        MHPMCounterWidth = 40,
    parameter bit                 RV32E            = 1'b0,
    parameter ibex_pkg::rv32m_e   RV32M            = ibex_pkg::RV32MFast,
    parameter ibex_pkg::rv32b_e   RV32B            = ibex_pkg::RV32BNone,
    parameter ibex_pkg::regfile_e RegFile          = ibex_pkg::RegFileFF,
    parameter bit                 BranchTargetALU  = 1'b0,
    parameter bit                 WritebackStage   = 1'b0,
    parameter bit                 ICache           = 1'b0,
    parameter bit                 ICacheECC        = 1'b0,
    parameter bit                 BranchPredictor  = 1'b0,
    parameter bit                 DbgTriggerEn     = 1'b0,
    parameter int unsigned        DbgHwBreakNum    = 1,
    parameter bit                 SecureIbex       = 1'b0,
    parameter int unsigned        DmHaltAddr       = 32'h1A110800,
    parameter int unsigned        DmExceptionAddr  = 32'h1A110808
)(
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
	  
	/*
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
	*/
ibex_core #(
    .PMPEnable        ( 0                   ),
    .PMPGranularity   ( 0                   ),
    .PMPNumRegions    ( 4                   ),
    .MHPMCounterNum   ( 0                   ),
    .MHPMCounterWidth ( 40                  ),
    .RV32E            ( 0                   ),
    .RV32M            ( ibex_pkg::RV32MFast ),
    .RV32B            ( ibex_pkg::RV32BNone ),
    .RegFile          ( ibex_pkg::RegFileFF ),
    .ICache           ( 0                   ),
    .ICacheECC        ( 0                   ),
    .BranchPrediction ( 0                   ),
    .SecureIbex       ( 0                   ),
    .DbgTriggerEn     ( 0                   ),
    .DmHaltAddr       ( 32'h1A110800        ),
    .DmExceptionAddr  ( 32'h1A110808        )
) u_core (
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
    .crash_dump_o   (),

    // Special control signals
    .fetch_enable_i (fetch_enable_i),
    .alert_minor_o  (),
    .alert_major_o  (),
    .core_sleep_o   ()
);
	
endmodule
