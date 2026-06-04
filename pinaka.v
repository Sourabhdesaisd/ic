module	 	pinaka 		(


//		GLOBAL CLOCKS AND RESET SIGNAL 

input 			clk 		,
input 			pclk 		,
input 			rst 		,


// 		I2C SERIAL DATA AND SERIAL CLOCK SIGNAL

inout 			I2C_sda 	,
output 			I2C_scl 	,
 

//		SPI MISO,MOSI,SLAVE SELECT AND SERIAL CLOCK SIGNALS

input 			SPI_MISO 	,
output 			SPI_MOSI 	,
output 			SPI_sclk	,
output 			SPI_ss 		,


//		UART TRANSMIT AND RECEIVE SIGNAL

input 			UART_rx 	,
output 			UART_tx 

							
				) 	;




//-------------------------PARAMETERS---------------------------


// 			MMU PARAMETER

parameter 		MMU_VPN_WIDTH 			= 	20 						;
parameter 		MMU_PPN_WIDTH 			= 	20 						;
parameter 		MMU_ASID_WIDTH 			= 	9 						;
parameter 		MMU_L1_ENTRIES 			= 	16 						;
parameter 		MMU_L2_ENTRIES 			= 	32 						;
parameter 		MMU_PTE_ADDRESS_WIDTH 		= 	32 						;


//			CSR TOP MODULE PARAETER

parameter 		CSR_ADDR_WIDTH    		= 	12 						;
parameter 		CSR_DATA_WIDTH        		= 	32 						;
parameter 		CSR_INSTRUCTION_WIDTH 		= 	32 						;
parameter 		CSR_PC_WIDTH          		= 	32 						;


//			AXI PARAMETER

parameter 		AXI_DATA_WIDTH			= 	32						;
parameter 		AXI_ADDR_WIDTH			=	32						;
parameter		STROBE_WIDTH			=	4						;


//			AXI-APB BRIDGE PARAMETER

parameter 		BRIDGE_FIFO_DEPTH  		= 	8 						;
parameter 		BRIDGE_FIFO_WIDTH  		= 	AXI_ADDR_WIDTH + AXI_DATA_WIDTH 		;

// 			I2C PARAMETER

parameter 		I2C_ADDR_WIDTH 			= 	8 						;
parameter 		I2C_DATA_WIDTH 			= 	32 						;


//			SPI PARAMETER

parameter 		SPI_ADDR_WIDTH 			= 	8 						;
parameter 		SPI_DATA_WIDTH 			= 	32 						;
parameter 		SPI_CLK_DIV			= 	4 						;


//			UART PARAMETER

parameter 		UART_CLK_FREQ 			= 	50_000_000					;
parameter 		UART_BAUD_RATE  		= 	115200 						;
parameter 		UART_DATA_IN_WIDTH		= 	8 						;
parameter 		UART_DATA_OUT_WIDTH		= 	32 						;
parameter 		UART_REG_WIDTH			=	8 						;
parameter 		UART_FIFO_DEPTH			= 	16 						;
parameter 		UART_ADDR_WIDTH 		= 	8 						;


//			MEMORY MAPPED ADDRESS RANGES

parameter 		I2C_MIN_ADDRESS 		= 	32'h2000_0000 					;
parameter 		I2C_MAX_ADDRESS 		= 	32'h2000_FFFF 					;
parameter 		SPI_MIN_ADDRESS 		= 	32'h3000_0000 					;
parameter 		SPI_MAX_ADDRESS 		= 	32'h3000_FFFF 					;
parameter 		UART_MIN_ADDRESS 		= 	32'h4000_0000 					;
parameter 		UART_MAX_ADDRESS 		= 	32'h4000_FFFF 					;
parameter 		DATA_MEMORY_MIN_ADDRESS		= 	32'h8000_0000					;
parameter 		DATA_MEMORY_MAX_ADDRESS		= 	32'h8000_FFFF					;

//			DATA MEMORY 

parameter 		DATA_MEMORY_ADDR_WIDTH 		= 	10 						;

//			INSTRUCTION MEMORY

parameter 		INST_MEMORY_ADDR_WIDTH 		= 	10 						;

//			PTE MEMORY

parameter 		PTE_MEMORY_ADDR_WIDTH 		= 	7 						;


//			APB TIME OUT IN BRIDGE


parameter 		APB_TIMEOUT_COUNT_WIDTH		= 	6						;
parameter 		APB_TIMEOUT_VALUE		=	50						;


//------------------------------------------------------------------------------------------------------------------



//---------------------------------------INTERNAL WIRES--------------------------------



//			VIRTUAL ADDRESSES OF INSTRUCTION AND DATA MEMORY BY CORE TO MMU

wire 	[31:0] 				virtual_address_inst_core		;
wire 	[31:0] 				virtual_address_mem_core 		;

//--------------------------------------------------------------


//				DATA MEMORY READ AND WRITE BY CORE

wire 					mem_read_en_core 			;
wire 					mem_write_en_core 			;

//--------------------------------------------------------


//				READ AND WRITE ENABLE OD THE DATA MEMORY

wire 					data_mem_read_en 			;
wire 					data_mem_write_en 			;

//--------------------------------------------------------


// 				PHYSICAL ADDRESSES HIT SIGNAL BY MMU

wire 					data_memory_hit_mmu 			;
wire 					instruction_hit_mmu 			;

//--------------------------------------------------------


//				PHYSICAL ADDRESSES HIT BY MMU

wire 	[31:0] 				physical_address_inst_mmu 		;
wire 	[31:0] 				physical_address_mem_mmu 		;

//--------------------------------------------------------


//			FINAL PHYSICAL ADDRESS HIT SIGNALS WITH MMU ENABLE SIGNAL

wire 					instruction_hit 			;
wire 					data_memory_hit 			;

//--------------------------------------------------------


//		20 BIT PHYSICAL PAGE NUMBER OF BOTH INSTRUCTION MEMORY AND DATA MEMORY BY MMU 

wire 	[MMU_PPN_WIDTH -1 :0] 		ppn_inst_mem_address 			;
wire 	[MMU_PPN_WIDTH -1 :0] 		ppn_data_mem_address 			;

//--------------------------------------------------------


//		FINAL PHYSICAL ADDRESS OF BOTH INSTRUCTION MEMORY AND DATA MEMORY

wire 	[31:0] 				physical_address_inst 			;
wire 	[31:0] 				physical_address_mem 			;

//--------------------------------------------------------


//				BRIDGE INTERFACE SIGNALS


// 				WRITE ADDRESS CHANNEL 
wire 					bridge_awvalid 				;
wire 	[AXI_ADDR_WIDTH -1:0] 		bridge_awaddr 				;
wire 					bridge_awready 				;


//				WRITEE DATA CHANNEL 

wire 					bridge_wvalid 				;
wire 	[AXI_DATA_WIDTH-1:0] 		bridge_wdata 				;
wire 	[STROBE_WIDTH-1:0] 		bridge_wstrb 				;
wire 					bridge_wready 				;


//				WRITE RESPONSE CHANNEL

wire 					bridge_bready 				;
wire 	[1:0]				bridge_bresp 				;
wire 					bridge_bvalid 				;


//				READ ADDRESS CHANNEL

wire 					bridge_arvalid 				;
wire 	[AXI_ADDR_WIDTH-1:0] 		bridge_araddr 				;
wire 					bridge_arready 				;


//				READ DATA CHANNEL

wire 					bridge_rready 				;
wire 					bridge_rvalid 				;
wire 	[AXI_DATA_WIDTH-1:0] 		bridge_rdata 				;
wire 	[1:0]				bridge_rresp 				;
wire					bridge_rlast				;


//----------------------------------DATA MEMORY AXI INTERFACE-------------------------------


// 				WRITE ADDRESS CHANNEL 
wire 					axi_data_mem_awvalid			;
wire 	[AXI_ADDR_WIDTH -1:0] 		axi_data_mem_awaddr 			;
wire 					axidata_mem_awready			;


//				WRITEE DATA CHANNEL 

wire 					axi_data_mem_wvalid 			;
wire 	[AXI_DATA_WIDTH-1:0] 		axi_data_mem_wdata 			;
wire 	[STROBE_WIDTH-1:0] 		axi_data_mem_wstrb 			;
wire 					axi_data_mem_wready 			;


//				WRITE RESPONSE CHANNEL

wire 					axi_data_mem_bready 			;
wire 	[1:0]				axi_data_mem_bresp 			;
wire 					axi_data_mem_bvalid 			;


//				READ ADDRESS CHANNEL

wire 					axi_data_mem_arvalid			;
wire 	[AXI_ADDR_WIDTH-1:0] 		axi_data_mem_araddr 			;
wire 					axi_data_mem_arready 			;


//				READ DATA CHANNEL

wire 					axi_data_mem_rready 			;
wire 					axi_data_mem_rvalid 			;
wire 	[AXI_DATA_WIDTH-1:0] 		axi_data_mem_rdata			;
wire 	[1:0]				axi_data_mem_rresp			;
wire					axi_data_mem_rlast			;



//------------------------------APB MASTER INTERFACE------------------

wire 					bridge_psel 				;
wire 	[AXI_ADDR_WIDTH-1:0] 		bridge_paddr 				;
wire 	[AXI_DATA_WIDTH-1:0] 		bridge_pwdata 				;
wire 					bridge_penable 				;
wire 					bridge_pwrite 				;
wire 					bridge_pready 				;
wire 	[AXI_DATA_WIDTH-1:0] 		bridge_prdata 				;
wire 					bridge_pslverr 				;

//--------------------------------------------------------


//------------------APB BRIDGE TO PERIPHERALS INTERFACE SIGNALS------------------------


//			APB BRIDGE TO UART INTERFACE SIGNALS

wire 					UART_psel 				;
wire 	[UART_DATA_OUT_WIDTH - 1:0] 	UART_prdata 				;
wire 					UART_pready 				;
wire 					UART_pslverr 				;


//			APB BRIDGE TO I2C INTERFACE SIGNALS

wire 					I2C_psel 				;
wire 	[I2C_DATA_WIDTH - 1 :0] 	I2C_prdata 				;
wire 					I2C_pready 				;
wire 					I2C_pslverr 				;


//			APB BRIDGE TO SPI INTERFACE SIGNALS

wire 					SPI_psel 				;
wire 	[SPI_DATA_WIDTH-1:0] 		SPI_prdata 				;
wire 					SPI_pready 				;
wire 					SPI_pslverr 				;


//-------------------------------------------------------------------------------------------------


//-------------------------------CORE AND CSR INTERFACE--------------------

wire 	[CSR_DATA_WIDTH-1:0] 		csr_read_data_to_core 			;
wire 					csr_read_en_from_core 			;
wire 					csr_write_en_from_core 			;
wire 	[CSR_ADDR_WIDTH -1:0]  		csr_addr_from_core			;
wire 	[CSR_DATA_WIDTH-1:0] 		csr_write_data_from_core 		;
wire 					csr_set_bit_from_core 			;
wire 					csr_clear_bit_from_core 		;
wire 					e_break_valid_from_core 		;
wire 					mret_valid_from_core 			;

//-------------------------------------------------------------------------------------------------


//-----------------------------AXI MASTER WRAPPER OF INSTRUCTION MEMORY SIGNALS--------------------


wire 	[1:0] 				inst_mem_rresp 				;	//	INSTRUCTION MEMORY READ RESPONSE SIGNAL
wire 					inst_mem_rvalid 			;	// 	INSTRCUTION MEMORY READ VALID SIGNAL
wire 					inst_mem_rready 			;	// 	INSTRUCTION MEMORY READ READY SIGNAL

//				INSTRUCTION MEMORY AXI INTERFACE


// 				WRITE ADDRESS CHANNEL 
wire 					axi_inst_mem_awvalid			;
wire 	[AXI_ADDR_WIDTH -1:0] 		axi_inst_mem_awaddr 			;
wire 					axi_inst_mem_awready			;


//				WRITEE DATA CHANNEL 

wire 					axi_inst_mem_wvalid 			;
wire 	[AXI_DATA_WIDTH-1:0] 		axi_inst_mem_wdata 			;
wire 	[STROBE_WIDTH-1:0] 		axi_inst_mem_wstrb 			;
wire 					axi_inst_mem_wready 			;


//				WRITE RESPONSE CHANNEL

wire 					axi_inst_mem_bready 			;
wire 	[1:0]				axi_inst_mem_bresp 			;
wire 					axi_inst_mem_bvalid 			;


//				READ ADDRESS CHANNEL

wire 					axi_inst_mem_arvalid			;
wire 	[AXI_ADDR_WIDTH-1:0] 		axi_inst_mem_araddr 			;
wire 					axi_inst_mem_arready 			;


//				READ DATA CHANNEL

wire 					axi_inst_mem_rready 			;
wire 					axi_inst_mem_rvalid 			;
wire 	[AXI_DATA_WIDTH-1:0] 		axi_inst_mem_rdata 			;
wire 	[1:0]				axi_inst_mem_rresp 			;
wire					axi_inst_mem_rlast			;

//-------------------------------------------------------------------------------------------------


wire 	[31:0] 				pte_address 				;	//	ADDRESS OF THE PAGE TABLE MEMORY BY MMU
wire 	[31:0] 				pte_data_out 				;	//	DATA OUT OF PTE WHICH CONTAINS PPN AND OTHER BITS	

wire 	[3:0] 				byte_enable 				;	//	BYTE ENABLE SIGNAL FROM CORE NEED TO CHANGE ACCORDING TO THE AXI INTERFACE
wire 	[31:0] 				instruction 				;	//	FINAL INSTRUCTION TO THE CORE

wire 	[31:0] 				mem_write_data_core 			;	//	WRIRE DATA TO THE TARGETED MEMORY ADDRESS
wire 	[31:0] 				data_from_memory_to_core 		;	//	DATA FROM THE REQUESTED MEMORY ADDRESS

wire					mmu_enable 				;	// 	MMU ENABLE BY CSR
wire 	[21:0]				base_ppn 				;	//	PAGE TABLE ENTRIES BASE PPN ADDRESS TO MMU BY CSR
wire 	[8:0]				current_asid 				;	//	CURRENT ASID TO MMU FROM CSR

wire 					stall_by_axi_data_mem_read 		;	//	STALL SIGNAL BY DATA MEMORY READ
wire					stall_by_axi_data_mem_write		;	//	STALL SIGNAL BY DATA MEMORY WRITE
wire					stall_by_load_store			;	//	STALL SIGNAL BY BOTH READ AND WRITE BY DATA MEMORY
wire					stall_by_axi_inst_read			;	//	STALL SIGNAL BY THE INSTRUCTION HALT DUE TO AXI READ
wire 					stall_the_pipeline				; 


wire 					axi_data_mem_valid			;	//	AXI MASTER WRAPPER OF DATA MEMORY INPUT VALID BIT
wire					axi_inst_mem_valid			;	//	AXI MASTER WRAPPER OF INSTRUCTION MEMORY INPUT VALID BIT


//				VALID,READY AND RESPONSE SIGNALS FROM THE AXI MASTER WRAPPER OF DATA MEMORY SIDE


wire	[1:0]				data_mem_rresp			;	//	READ RESPONSE SIGNAL
wire	[1:0]				data_mem_bresp			;	//	WRITE_RESPONSE SIGNAL
wire					data_mem_rvalid			;	//	READ VALID SIGNAL
wire 					data_mem_rready			;	//	READ READY SIGNAL
wire					data_mem_bready			;	//	WRITE RESPONSE READY SIGNAL
wire 					data_mem_bvalid			;	//	WRITE RESPONSE VALID SIGNAL
wire 					data_mem_rlast			;	//	READ DATA LAST SIGNAL



//--------------------------------------------TO DO LIST--------------------------------------------------

//	THIS IS THE VALID AND RESPONSE PIN FROM PTE MEMORY TO MMU, AS OF NOW WE ARE INTEGRATED AXI SO I HAD TIED TO CONSTANT

wire 					pte_resp_valid = 1'd1			;
wire 					pte_req_valid 				;

//	 		INSTRUCTION MEMORY INPUTS SIGNALS

wire 					instruction_write_en 			;
wire 	[31:0] 				instruction_write_data 			;
wire 	[INST_MEMORY_ADDR_WIDTH -1 :0] 	instruction_write_address 		;


// 			PAGE TABLE MEMORY INPUTS SIGNALS

wire  					pte_write_en 				;
wire 	[31:0] 				pte_write_data 				;


//			PERMISSION FAULTS SIGNALS GENERATED BY MMU

wire  					instruction_execute_permission_fault 	;
wire 					mem_read_permission_fault 		;
wire 					mem_write_permission_fault 		;


//			EXCEPTIONS OF THE DATA MEMORY SIDE

wire					mem_addr_decode_error 			;	//	DATA MEMORY ADDRESS DECODE ERROR
wire 					mem_addr_read_slverr			;	//	DATA MEMORY SLAVE ERROR DUE TO READ OPERATION
wire					mem_addr_write_slverr			;	//	DATA MEMORY SLAVE ERROR DUE TO WRITE OPERATION


//---------------------------------------------------------------------------------------------




//---------------------------------------GLUE LOGICS---------------------------------------------



//		STALL LOGIC FOR THE CORE TO STALL UNTIL LOAD AND STORE IS FINISH

assign 	stall_by_axi_data_mem_read 	= 	mem_read_en_core & ~( data_mem_rvalid & data_mem_rready & data_mem_rlast & (data_mem_rresp == 2'b00) ) ;
	
assign 	stall_by_axi_data_mem_write 	= 	mem_write_en_core & ~( data_mem_bvalid & data_mem_bready & (data_mem_bresp == 2'b00) )	;

assign 	stall_by_load_store 		= 	stall_by_axi_data_mem_read | stall_by_axi_data_mem_write ;


//			THIS STALL LOGIC WILL CHANGE AFTER AXI MASTER WRAPPER AT INSTRUCTION MEMORY

assign 	stall_by_axi_inst_read 		= 	~(inst_mem_rvalid & inst_mem_rready & (inst_mem_rresp == 2'b00)) ;		  


//			OVERALL STALL THE CORE BY INSTRUCTION OR DATA MEMORY ACCESS

assign 	stall_the_pipeline		=	stall_by_load_store | stall_by_axi_inst_read 			;


//			HIT SIGNAL LOGIC IF MMU ENABLE OR DISABLED

assign 	data_memory_hit 		= 	mmu_enable ? data_memory_hit_mmu : 1'b1 				;
assign 	instruction_hit 		= 	mmu_enable ? instruction_hit_mmu : 1'b1 				;


//			PHYSICAL ADDRESSES PROVIDED BY THE MMU

assign 	physical_address_inst_mmu 	= 	{ ppn_inst_mem_address, virtual_address_inst_core[11:0] } 		;
assign 	physical_address_mem_mmu 	= 	{ ppn_data_mem_address, virtual_address_mem_core[11:0] } 		;


//			FINAL PHYSICAL ADDRESS DEPENDING ON THE MMU ENABLE

assign 	physical_address_inst 		= 	mmu_enable ? physical_address_inst_mmu : virtual_address_inst_core 	;
assign 	physical_address_mem 		= 	mmu_enable ? physical_address_mem_mmu : virtual_address_mem_core 	;

//			THIS SIGNAL TELLS THE REQUESTED ADDRESS IS VALID OR NOT TO THE AXI WRAPPERS

assign 	axi_data_mem_valid		= 	data_memory_hit &  (mem_read_en_core | mem_write_en_core )		;
assign 	axi_inst_mem_valid		= 	instruction_hit								;

//			MEMORY READ AND WRITE SLAVE ERROR

assign 	data_mem_read_slverr		= 	data_mem_rvalid & data_mem_rready & (data_mem_rresp == 2'b10) 	;
assign 	data_mem_write_slverr		=	data_mem_bvalid & data_mem_bready & (data_mem_bresp == 2'b10) 	;


//-------------------------------------------------------------------------------------------------------------




//------------------------------------------MODULES INSTANTIATIONS---------------------------------------------------



//---------------------------------------------RISC V BASIC CORE INSTANCE---------------------------------------

rv32i_core 		basic_isa_instance 			(


    			.clk					(clk)					,
    			.rst					(rst)					,
			.stall_by_mmu				(stall_the_pipeline) 			,
    			.data_from_mem				(data_from_memory_to_core) 		,
			.instruction				(instruction) 				,
     			.pc					(virtual_address_inst_core)		,
   			.data_mem_address			(virtual_address_mem_core) 		, 
			.mem_write_en				(mem_write_en_core) 			,
			.mem_read_en				(mem_read_en_core) 			,
			.byte_enable				(byte_enable) 				,
			.mem_write_data				(mem_write_data_core) 			,
		
			//                              CSR signals
			                              
                        .csr_read_data_i			(csr_read_data_to_core)			,
                        .csr_read_en_o				(csr_read_en_from_core)			,
                        .csr_write_en_o				(csr_write_en_from_core)		,
                        .csr_addr_o				(csr_addr_from_core)			,
                        .csr_write_data_o			(csr_write_data_from_core)		,
                        .csr_set_bit_o				(csr_set_bit_from_core)			,
                        .csr_clear_bit_o			(csr_clear_bit_from_core)		,
                        .e_break_valid_o			(e_break_valid_from_core)		,
                        .sfence_flush_o				(tlb_flush)				,
                        .mret_valid_o				(mret_valid_from_core)


   						 		)					;


//----------------------------------------------CSR MODULE INSTANTIATION-----------------------------------------

//				SOME PINS ARE LEFT UNCONNECTED NEED TO CONNECT AFTER THE DEBUG AND INTERRUPT MODULE INTEGRATE

soc_csr_top 		 					#(


			.CSR_ADDR_WIDTH				(CSR_ADDR_WIDTH)			,
			.DATA_WIDTH				(CSR_DATA_WIDTH)			,
			.INSTRUCTION_WIDTH			(CSR_INSTRUCTION_WIDTH)			,
			.PC_WIDTH				(CSR_PC_WIDTH)

								)

			csr_top_instance			(


                        .csr_clk				(clk) 					,
                        .csr_rst				(~rst)					,
                        .csr_write_en_in			(csr_write_en_from_core)		,   		
                        .csr_addr_in				(csr_addr_from_core)			,
                        .csr_read_en_in				(csr_read_en_from_core)			,
                        .csr_read_data_o			(csr_read_data_to_core)			,	
                        .csr_write_data_in			(csr_write_data_from_core)		,		
                        .csr_set_bit_in				(csr_set_bit_from_core)			,		
                        .csr_clear_bit_in			(csr_clear_bit_from_core)		,		
                        .interrupt_valid_in			() 					,	 	
                        .interrupt_code_in			()					,		
                        .satp_mode_o				(mmu_enable)				,
                        .satp_asid_o				(current_asid)				,
                        .satp_ppn_o				(base_ppn)				,                            
                        .instr_misalign_valid_in		()					,
                        .mie_set				()					,	
                        .mie_clear				()					,	
                        .pc_in					()					,	
                        .csr_mepc_in				()					,
                        .csr_mepc_write_valid			() 					,
                        .stall_valid_i				()					,
                        .branch_valid_i				()					,
                        .interrupt_lvl_pr_i			()					,
                        .interrupt_id_write_valid_i		()					,
                        .mret_valid_i				(mret_valid_from_core) 			,
                        .interrupt_active_level_priority_o	()					,
                        .csr_mepc_o				()					,
                        .mstatus_mie_o				()					,
                        .csr_mtvec_o				()					,
                        .csr_mcause_o				()					,
                        .ebreak_valid_i				(e_break_valid_from_core)		,
                        .trigger_valid_i			()					,
                        .haltreq_valid_i			()					,
                        .single_step_valid_i			()					,
                        .reset_haltreq_valid_i			()					,
                        .dpc_o					()					,
                        .dbg_mode_valid_i			()					,      
                        .dbg_mode_write_en_i			()					, 
                        .dbg_mode_write_data_i			()					,
                        .dbg_mode_csr_addr_i			()					,
                        .dbg_mode_read_en_i			()					,
                        .dbg_mode_read_data_o			()					,
                        .dbg_csr_read_valid_o			()					,
                        .dbg_ndm_reset_i			()					,
                        .dbg_hart_reset_i			()					,
                        .branch_pc_i				()                        
   	

								)					;


//----------------------------------------------------MMU INSTANCE---------------------------------------

mmu_core 		 					#(


			.VPN_WIDTH				(MMU_VPN_WIDTH)				,
			.PPN_WIDTH				(MMU_PPN_WIDTH)				,
			.ASID_WIDTH				(MMU_ASID_WIDTH)			,
			.L1_ENTRIES				(MMU_L1_ENTRIES)			,
			.L2_ENTRIES				(MMU_L2_ENTRIES)			,
			.PTE_ADDR_WIDTH				(MMU_PTE_ADDRESS_WIDTH)


								)

			mmu_instance				(


			.clk					(clk) 					,
			.rst					(rst) 					,
			.base_ppn				(base_ppn) 				,
			.mmu_enable				(mmu_enable) 				,
			.mem_read_en				(mem_read_en_core) 			,
			.mem_write_en				(mem_write_en_core) 			,
			.i_if_vpn				(virtual_address_inst_core[31:12]) 	,
			.o_if_ppn				(ppn_inst_mem_address) 			,
			.o_if_hit				(instruction_hit_mmu) 			,
			.i_mem_vpn				(virtual_address_mem_core[31:12]) 	,
			.o_mem_ppn				(ppn_data_mem_address) 			,
			.o_mem_hit				(data_memory_hit_mmu) 			,
			.pte_req_valid				(pte_req_valid) 			,
			.pte_req_addr				(pte_address) 				,
			.pte_resp_ppn				(pte_data_out[31:12]) 			,
			.pte_resp_validbit			(pte_data_out[0]) 			,
			.execute_access_bit			(pte_data_out[3]) 			,
			.read_access_bit			(pte_data_out[1]) 			,
			.write_access_bit			(pte_data_out[2]) 			,
			.pte_resp_valid				(pte_resp_valid) 			,
			.tlb_flush				(tlb_flush) 				,
			.current_asid				(current_asid) 				,
			.instruction_execute_permission_fault	(instruction_execute_permission_fault) 	,
			.mem_read_permission_fault		(mem_read_permission_fault) 		,
			.mem_write_permission_fault		(mem_write_permission_fault)


								) ;



//---------------------------------------------PAGE TABLE MEMORY INSTANCE---------------------------------------

pte_memory 							#(
		
			.PTE_MEMORY_ADDR_WIDTH			(PTE_MEMORY_ADDR_WIDTH)

								)

			pte_memory_instance 			(
	

			.clk					(clk) 					,
			.write_en				(pte_write_en) 				,
			.address				(pte_address[PTE_MEMORY_ADDR_WIDTH -1:0])  			,
			.data_in				(pte_write_data) 			,
			.data_out				(pte_data_out)


								) 					;


//----------------------------AXI MASTER ONLY READ ONLY WRAPPER FOR THE INSTRUCTION MEMORY-------------------------------



axi_master_read_wrapper 	axi_read_instruction_mem_instance	(


			.clk					(clk)					,
			.rst_n					(~rst)					,
			
			.in_address				(physical_address_inst)			,
			.in_valid				(axi_inst_mem_valid)			,
			.reset_valid				(~stall_the_pipeline)			,
			.read_data_out				(instruction)				,
			.read_resp_out				(inst_mem_rresp)			,
			
			.read_valid				(inst_mem_rvalid)			,
			.read_ready				(inst_mem_rready)			,
			
			.M_AXI_ARADDR				(axi_inst_mem_araddr)			,
			.M_AXI_ARVALID				(axi_inst_mem_arvalid)			,
			.M_AXI_ARREADY				(axi_inst_mem_arready)			,
			
			.M_AXI_RDATA				(axi_inst_mem_rdata)			,
			.M_AXI_RRESP				(axi_inst_mem_rresp)			,
			.M_AXI_RVALID				(axi_inst_mem_rvalid)			,
			.M_AXI_RREADY				(axi_inst_mem_rready)

								)					;


//			AXI SLAVE WRAPPER WITH DATA MEMORY INSTANCE


axi_instmem_wrapper						#(

			.INST_MEMORY_ADDR_WIDTH				(INST_MEMORY_ADDR_WIDTH)	

								)
		

			axi_slave_wrapper_inst_mem_instance	(

			.ACLK					(clk)					,
			.ARESETN				(~rst)					,
			
			// Write Address Channel
			.AWADDR					(axi_inst_mem_awaddr)			,
			.AWVALID				(axi_inst_mem_awvalid)			,
			.AWREADY				(axi_inst_mem_awready)			,
			
			// Write Data Channel
			.WDATA					(axi_inst_mem_wdata)			,
			.WSTRB					(axi_inst_mem_wstrb)			,
			.WVALID					(axi_inst_mem_wvalid)			,
			.WREADY					(axi_inst_mem_wready)			,
			
			// Write Response Channel
			.BRESP					(axi_inst_mem_bresp)			,
			.BVALID					(axi_inst_mem_bvalid)			,
			.BREADY					(axi_inst_mem_bready)			,
			
			// Read Address Channel
			.ARADDR					(axi_inst_mem_araddr)			,
			.ARVALID				(axi_inst_mem_arvalid)			,
			.ARREADY				(axi_inst_mem_arready)			,
			
			// Read Data Channel
			.RDATA					(axi_inst_mem_rdata)			,
			.RRESP					(axi_inst_mem_rresp)			,
			.RVALID					(axi_inst_mem_rvalid)			,
			.RREADY					(axi_inst_mem_rready)
			

								);


//				AXI MASTER WRAPPER INSTANCE OF THE DATA MEMORY


axi_master_wrapper 						#(


			.UART_MIN_ADDRESS			(UART_MIN_ADDRESS)			,
			.UART_MAX_ADDRESS			(UART_MAX_ADDRESS)			,
			
			.SPI_MIN_ADDRESS			(SPI_MIN_ADDRESS)			,
			.SPI_MAX_ADDRESS			(SPI_MAX_ADDRESS)			,
			
			.I2C_MIN_ADDRESS			(I2C_MIN_ADDRESS)			,
			.I2C_MAX_ADDRESS			(I2C_MAX_ADDRESS)			,
			
			.MEM_MIN_ADDRESS			(DATA_MEMORY_MIN_ADDRESS)		,
			.MEM_MAX_ADDRESS			(DATA_MEMORY_MAX_ADDRESS)

								)	


			data_memory_axi_wrapper_instance	(


			.clk					(clk)					,
			.rst_n					(~rst)					,
			
						//core side signals
			
			.in_address				(physical_address_mem)			,
			.write_en				(mem_write_en_core)			,
			.read_en				(mem_read_en_core)			,
			.in_valid				(axi_data_mem_valid)			,
			.write_data				(mem_write_data_core)			,
			.byte_enable				(byte_enable)				,
			.read_data_out				(data_from_memory_to_core)		,
			.read_resp_out				(data_mem_rresp)			,
			.write_resp_out				(data_mem_bresp)			,
			.addr_error				(mem_addr_decode_error)			,

			.read_valid				(data_mem_rvalid) 			,
			.read_ready				(data_mem_rready) 			,
			.w_resp_ready				(data_mem_bready)			,
			.w_resp_valid				(data_mem_bvalid) 			,
			.rlast					(data_mem_rlast)			,


						//BRIDGE SIDE				

						//axi write in_address channel
			
			.bg_axi_awaddr				(bridge_awaddr)				,
			.bg_axi_awvalid				(bridge_awvalid)			,
			.bg_axi_awready				(bridge_awready)			,
			
						//axi write data channel
			
			.bg_axi_wdata				(bridge_wdata)				,
			.bg_axi_wstrb				(bridge_wstrb)				,
			.bg_axi_wvalid				(bridge_wvalid)				,
			.bg_axi_wready				(bridge_wready)				,
			
						//axi write responce channel
			
			.bg_axi_bresp				(bridge_bresp)				,
			.bg_axi_bvalid				(bridge_bvalid)				,
			.bg_axi_bready				(bridge_bready)				,
			
						//axi read in_address channel
			
			.bg_axi_araddr				(bridge_araddr)				,
			.bg_axi_arvalid				(bridge_arvalid)			,
			.bg_axi_arready				(bridge_arready)			,
			
						//axi read data channel
			
			.bg_axi_rdata				(bridge_rdata)				,
			.bg_axi_rresp				(bridge_rresp)				,
			.bg_axi_rvalid				(bridge_rvalid)				,
			.bg_axi_rready				(bridge_rready)				,
			.bg_axi_rlast				(bridge_rlast)				,


						//DATA MEMORY 

						//axi write in_address channel
			
			.dm_axi_awaddr				(axi_data_mem_awaddr)			,
			.dm_axi_awvalid				(axi_data_mem_awvalid)			,
			.dm_axi_awready				(axi_data_mem_awready)			,
			
						//axi write data channel
			
			.dm_axi_wdata				(axi_data_mem_wdata)			,
			.dm_axi_wstrb				(axi_data_mem_wstrb)			,
			.dm_axi_wvalid				(axi_data_mem_wvalid)			,
			.dm_axi_wready				(axi_data_mem_wready)			,
			
						//axi write responce channel
			
			.dm_axi_bresp				(axi_data_mem_bresp)			,
			.dm_axi_bvalid				(axi_data_mem_bvalid)			,
			.dm_axi_bready				(axi_data_mem_bready)			,
			
						//axi read in_address channel
			
			.dm_axi_araddr				(axi_data_mem_araddr)			,
			.dm_axi_arvalid				(axi_data_mem_arvalid)			,
			.dm_axi_arready				(axi_data_mem_arready)			,
			
						//axi read data channel
			
			.dm_axi_rdata				(axi_data_mem_rdata)			,
			.dm_axi_rresp				(axi_data_mem_rresp)			,
			.dm_axi_rvalid				(axi_data_mem_rvalid)			,
			.dm_axi_rready				(axi_data_mem_rready)				


								)					;


//			AXI SLAVE WRAPPER WITH DATA MEMORY INSTANCE


axi_datamem_wrapper						#(

			.DATA_MEMORY_ADDR_WIDTH				(DATA_MEMORY_ADDR_WIDTH)		

								)
		

			axi_slave_wrapper_data_mem_instance	(

			.ACLK					(clk)					,
			.ARESETN				(~rst)					,
			
			// Write Address Channel
			.AWADDR					(axi_data_mem_awaddr)			,
			.AWVALID				(axi_data_mem_awvalid)			,
			.AWREADY				(axi_data_mem_awready)			,
			
			// Write Data Channel
			.WDATA					(axi_data_mem_wdata)			,
			.WSTRB					(axi_data_mem_wstrb)			,
			.WVALID					(axi_data_mem_wvalid)			,
			.WREADY					(axi_data_mem_wready)			,
			
			// Write Response Channel
			.BRESP					(axi_data_mem_bresp)			,
			.BVALID					(axi_data_mem_bvalid)			,
			.BREADY					(axi_data_mem_bready)			,
			
			// Read Address Channel
			.ARADDR					(axi_data_mem_araddr)			,
			.ARVALID				(axi_data_mem_arvalid)			,
			.ARREADY				(axi_data_mem_arready)			,
			
			// Read Data Channel
			.RDATA					(axi_data_mem_rdata)			,
			.RRESP					(axi_data_mem_rresp)			,
			.RVALID					(axi_data_mem_rvalid)			,
			.RREADY					(axi_data_mem_rready)
			

								);


//---------------------------------------------AXI_TO_APB BRIDGE INSTANCE---------------------------------------

top_bridge 							#(

			.FIFO_DEPTH				(BRIDGE_FIFO_DEPTH)			,
			.ADDR_WIDTH				(AXI_ADDR_WIDTH)			,
			.DATA_WIDTH				(AXI_DATA_WIDTH)			,
			.STRB_WIDTH				(STROBE_WIDTH)				,
			.FIFO_WIDTH				(BRIDGE_FIFO_WIDTH) 			,
			.TIMEOUT_CNT_WIDTH			(APB_TIMEOUT_COUNT_WIDTH)		,
			.TIMEOUT_VALUE				(APB_TIMEOUT_VALUE)					)
	
			axi2apb_instance			(


			.pclk					(pclk)					,
			.aclk					(clk)					,
			.resetn					(~rst)					,
			
			    // -- Write address channel -----------------------------

			.awvalid				(bridge_awvalid)			,
			.awaddr					(bridge_awaddr)				,
			.awlen					(8'd0)					,
			.awsize					(3'b010)				,
			.awburst				(2'b01)					,
			.awready				(bridge_awready)			,
			
			    // -- Write data channel --------------------------------

			.wvalid					(bridge_wvalid)				,
			.wdata					(bridge_wdata)				,
			.wstrb					(bridge_wstrb)				,
			.wlast					(1'd1)					,
			.wready					(bridge_wready)				,
			
			    // -- Write response channel ----------------------------

			.bready					(bridge_bready)				,
			.bresp					(bridge_bresp)				,
			.bvalid					(bridge_bvalid)				,
			
			    // -- Read address channel ------------------------------

			.arvalid				(bridge_arvalid)			,
			.araddr					(bridge_araddr)				,
			.arlen					(8'd0)					,
			.arsize					(3'b010)				,
			.arburst				(2'b01)					,
			.arready				(bridge_arready)			,
			
			    // -- Read data / response channel ---------------------

			.rready					(bridge_rready)				,
			.rvalid					(bridge_rvalid)				,
			.rdata					(bridge_rdata)				,
			.rresp					(bridge_rresp)				,
			.rlast					(bridge_rlast)				,
			
			    // -- APB master bus ------------------------------------

			.psel					(bridge_psel)				,
			.paddr					(bridge_paddr)				,
			.pwdata					(bridge_pwdata)				,
			.penable				(bridge_penable)			,
			.pwrite					(bridge_pwrite)				,
			.pready					(bridge_pready)				,
			.prdata					(bridge_prdata)				,
			.pslverr				(bridge_pslverr)


								)					;


//---------------------------------------------PERIPHERAL PSEL WRAPPER INSTANCE---------------------------------------

apb_slave_psel_wrapper						#(

			.I2C_MIN_ADDRESS			(I2C_MIN_ADDRESS) 			,
			.I2C_MAX_ADDRESS			(I2C_MAX_ADDRESS) 			,
			.SPI_MIN_ADDRESS			(SPI_MIN_ADDRESS) 			,
			.SPI_MAX_ADDRESS			(SPI_MAX_ADDRESS) 			,
			.UART_MIN_ADDRESS			(UART_MAX_ADDRESS)			,
			.UART_MAX_ADDRESS			(UART_MIN_ADDRESS)

								)

			apb_wrapper_instence			(


			.paddr					(bridge_paddr) 				,
			.pready					(bridge_pready) 			,
			.psel					(bridge_psel)				,
			.pslverr				(bridge_pslverr) 			,
			.prdata					(bridge_prdata) 			,
			.I2C_prdata				(I2C_prdata) 				,
			.SPI_prdata				(SPI_prdata)				,
			.UART_prdata				(UART_prdata)				,
			.I2C_pready				(I2C_pready)				,
			.SPI_pready				(SPI_pready) 				,
			.UART_pready				(UART_pready)				,
			.I2C_pslverr				(I2C_pslverr) 				,
			.SPI_pslverr				(SPI_pslverr) 				,
			.UART_pslverr				(UART_pslverr) 				,
			.I2C_psel				(I2C_psel) 				,
			.SPI_psel				(SPI_psel) 				,
			.UART_psel				(UART_psel) 


								) 					;


//---------------------------------------------I2C WITH APB INTERFACE INSTANCE---------------------------------------

i2c_wrapper 							#(

			.ADDR_WIDTH				(I2C_ADDR_WIDTH)			,
  			.DATA_WIDTH				(I2C_DATA_WIDTH)

								)

			i2c_wrapper_instance			(		
						

					// APB Interface Signals

   			.pclk					(pclk)					,
    			.presetn				(~rst)					,
    			.paddr					(bridge_paddr[I2C_ADDR_WIDTH-1:0])	,
    		 	.psel					(I2C_psel)				,
                     	.penable				(bridge_penable)			,
   			.pwrite					(bridge_pwrite)				,
   			.pwdata					(bridge_pwdata[I2C_DATA_WIDTH-1:0])	,
   			.prdata					(I2C_prdata)				,
  		        .pready					(I2C_pready)				,
    			.pslverr				(I2C_pslverr)				,

					//I2C external interface signal

			.sda					(I2c_sda)				,
			.scl					(I2C_scl)

								);



//---------------------------------------------SPI WITH APB SLAVE INSTANCE---------------------------------------


spi_wrapper 							#(

			.ADDR_WIDTH				(SPI_ADDR_WIDTH)			,
			.DATA_WIDTH				(SPI_DATA_WIDTH)			,
			.CLK_DIV				(SPI_CLK_DIV)

								)

			spi_wrapper_instance			(


    						// APB Interface

			.pclk					(pclk)					,
			.presetn				(~rst)					,
			.paddr					(bridge_paddr[SPI_ADDR_WIDTH-1:0])	,
			.psel					(SPI_psel)				,
			.penable				(bridge_penable)			,
			.pwrite					(bridge_pwrite)				,
			.pwdata					(bridge_pwdata[SPI_DATA_WIDTH-1:0])	,
			.prdata					(SPI_prdata)				,
			.pready					(SPI_pready)				,
			.pslverr				(SPI_pslverr)				,

    			// External SPI Interface
			.miso					(SPI_MISO)				,
			.mosi					(SPI_MOSI)				,
			.sclk					(SPI_sclk)				,
			.ss					(SPI_ss)

								)					;



//---------------------------------------------UART WITH APB SLAVE INSTANCE---------------------------------------

uart_top 							#(


			.CLK_FREQ				(UART_CLK_FREQ)				,
			.BAUD_RATE				(UART_BAUD_RATE)			,
			.WIDTH					(UART_DATA_IN_WIDTH)			,
			.OUT_WIDTH				(UART_DATA_OUT_WIDTH) 			,
			.REG_WIDTH				(UART_REG_WIDTH)			,
 			.DEPTH					(UART_FIFO_DEPTH)			,
		 	.ADDR_WIDTH				(UART_ADDR_WIDTH)


								)

			uart_top_instance			(


			.pclk					(pclk)					,         
			.presetn				(~rst)					,
			.paddr					(bridge_paddr[UART_ADDR_WIDTH -1:0])	,
			.psel					(UART_psel)				,
			.penable				(bridge_penable) 			,
			.pwrite					(bridge_pwrite)				,
			.pwdata					(bridge_pwdata[UART_DATA_IN_WIDTH-1:0])	,
			.rx					(UART_rx)				,
			.tx_out					(UART_tx)				,
			.prdata					(UART_prdata)				,
			.pready					(UART_pready)				,
			.pslverr				(UART_pslverr)

								)					;



//---------------------------------------------INSTRUCTION MEMORY INSTANCE---------------------------------------
/*
inst_mem  							#(
		
			.ADDR_WIDTH				(INST_MEMORY_ADDR_WIDTH)

								)
					

			instruction_memory_instance 		(
	

			.clk					(clk)					,
			.pc					(physical_address_inst[INST_MEMORY_ADDR_WIDTH - 1:0])		,
			.instruction_read_en			(instruction_hit) 			,
			.write_en				(instruction_write_en)			,
			.write_addr				(instruction_write_address[INST_MEMORY_ADDR_WIDTH -1 :0])		,
			.write_data				(instruction_write_data)		,
    			.instruction				(instruction)
						

								)					;

*/

//---------------------------------------------DATA MEMORY INSTANCE---------------------------------------
/*
data_memory 							#(
		
			.ADDR_WIDTH				(DATA_MEMORY_ADDR_WIDTH)

								)

			data_memory_instance  			(


    			.clk					(clk)					,
    			.mem_read				(data_mem_read_en)			,
    			.mem_write				(data_mem_write_en)			,
    			.addr					(physical_address_mem[DATA_MEMORY_ADDR_WIDTH -1:0])		,          
    			.write_data				(mem_write_data_core)			,    
    			.byte_enable				(byte_enable)				,   
    			.mem_data_out				(data_from_mem)   


								)					;
*/
//---------------------------------------------------------------------------------------------------



endmodule
