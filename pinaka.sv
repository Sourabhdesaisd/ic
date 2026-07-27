
import axi_typedef_pkg::*;

module	 	    pinaka 		            (


//		DEBUG MODULE CLOCKS AND RESET SIGNAL 

input           TCK                     ,
input           TRSTN                   ,

//      INPUT AND OUTPUT OF DEBUG MODULE

input           TMS                     ,
input           TDI                     ,
output          TDO                     ,

//      GPIO INOUT PINS

inout           GPIO0                   ,
inout           GPIO1                   ,
inout           GPIO2                   ,
inout           GPIO3                   ,
inout           GPIO4                   ,
inout           GPIO5                   ,
inout           GPIO6                   ,
inout           GPIO7                   ,
inout           GPIO8                   ,
inout           GPIO9                   ,
inout           GPIO10                  ,
inout           GPIO11                  ,
inout           GPIO12                  ,
inout           GPIO13                  ,
inout           GPIO14                  ,
inout           GPIO15                  ,
inout           GPIO16                  ,

//          EXTERNAL CLOCK

input           rc_clk                  ,
input           external_clk            ,
input           pll_clk                 ,

//          POWER ON RESET

input           power_on_rst            ,                                                                         
input           pll_lock_done                                                       

				) 	                    ;




//--------------------------------------PARAMETERS---------------------------


// 			                        MMU PARAMETER

parameter 		MMU_VPN_WIDTH 			    = 	20 						        ;
parameter 		MMU_PPN_WIDTH 			    = 	20 						        ;
parameter 		MMU_ACCESS_WIDTH 	    	= 	3 						        ;
parameter 		MMU_ASID_WIDTH 		    	= 	9 						        ;
parameter 		MMU_L1_ENTRIES 		    	= 	16 						        ;
parameter 		MMU_L2_ENTRIES 		    	= 	32 						        ;


//			                        CSR TOP MODULE PARAETER

parameter 		CSR_ADDR_WIDTH    		    = 	12 						        ;
parameter 		CSR_DATA_WIDTH        		= 	32 						        ;
parameter 		CSR_INSTRUCTION_WIDTH 		= 	32 						        ;
parameter 		CSR_PC_WIDTH          		= 	32 						        ;


//			                        AXI PARAMETER

parameter 		AXI_DATA_WIDTH		    	= 	32						        ;
parameter 		AXI_ADDR_WIDTH			    =	32						        ;
parameter		STROBE_WIDTH			    =	4						        ;


//			                        AXI-APB BRIDGE PARAMETER

parameter 		BRIDGE_FIFO_DEPTH  		    = 	8 						        ;
parameter 		BRIDGE_FIFO_WIDTH  		    = 	AXI_ADDR_WIDTH + AXI_DATA_WIDTH ;


//			                        APB TIME OUT IN BRIDGE


parameter 		APB_TIMEOUT_COUNT_WIDTH		= 	6						        ;
parameter 		APB_TIMEOUT_VALUE		    =   50						        ;


// 			                        I2C PARAMETER

parameter 		I2C_ADDR_WIDTH 			    = 	8 						        ;
parameter 		I2C_DATA_WIDTH 			    = 	32 						        ;


//			                        SPI PARAMETER

parameter 		SPI_ADDR_WIDTH 		    	= 	8 						        ;
parameter 		SPI_DATA_WIDTH 		    	= 	32 						        ;
parameter 		SPI_CLK_DIV			        = 	4 						        ;


//                                  CLK AND RST CTRL PARAMETER


parameter       CLK_RST_CTRL_RATION         =   2                               ;


//			                        DATA MEMORY 

parameter 		DATA_MEMORY_ADDR_WIDTH 		= 	16 						        ;

//			                        INSTRUCTION MEMORY

parameter 		INST_MEMORY_ADDR_WIDTH 		= 	16 						        ;


//			                        MEMORY MAPPED ADDRESS RANGES
			                        
parameter       TOP_REG_MIN_ADDRESS         =   32'h0008_0000                   ;
parameter       TOP_REG_MAX_ADDRESS         =   32'h0008_0FFF                   ;
parameter       CLK_RST_CTRL_MIN_ADDRESS    =   32'h0008_1000                   ;
parameter       CLK_RST_CTRL_MAX_ADDRESS    =   32'h0008_1FFF                   ;
parameter 		UART_MIN_ADDRESS 	    	= 	32'h0008_3000 					;
parameter 		UART_MAX_ADDRESS 		    = 	32'h0008_3FFF 					;
parameter 		I2C_MIN_ADDRESS 	    	= 	32'h0008_4000 					;
parameter 		I2C_MAX_ADDRESS 	    	= 	32'h0008_4FFF 					;
parameter 		SPI_MIN_ADDRESS 	    	= 	32'h0008_5000 					;
parameter 		SPI_MAX_ADDRESS 	    	= 	32'h0008_5FFF 					;
parameter       GPIO_REG_MIN_ADDRESS        =   32'h0008_6000                   ;
parameter       GPIO_REG_MAX_ADDRESS        =   32'h0008_6FFF                   ;
parameter 		WATCHDOG_MIN_ADDRESS		= 	32'h0008_7000					;
parameter 		WATCHDOG_MAX_ADDRESS		= 	32'h0008_7FFF					;


parameter 		PTE_MIN_ADDRESS			    = 	32'h0002_4000					;
parameter 		PTE_MAX_ADDRESS			    = 	32'h0002_4FFF					;
parameter 		DATA_MEMORY_MIN_ADDRESS		= 	32'h0001_0000					;
parameter 		DATA_MEMORY_MAX_ADDRESS		= 	DATA_MEMORY_MIN_ADDRESS + (2 ** DATA_MEMORY_ADDR_WIDTH) - 1			;
parameter 		INST_MEMORY_MIN_ADDRESS		= 	32'h0000_0000					;
parameter 		INST_MEMORY_MAX_ADDRESS		= 	INST_MEMORY_MIN_ADDRESS + (2 ** INST_MEMORY_ADDR_WIDTH) - 1			;



//------------------------------------------------------------------------------------------------------------------



//---------------------------------------INTERNAL WIRES--------------------------------



//			            VIRTUAL ADDRESSES OF INSTRUCTION AND DATA MEMORY BY CORE TO MMU

wire 	[31:0] 				            core_mmu_inst_mem_virtual_address	;
wire 	[31:0] 				            core_mmu_data_mem_virtual_address 	;

//--------------------------------------------------------------


//				                DATA MEMORY READ AND WRITE BY CORE

wire 					                core_mmu_axi_mem_read_en 			;
wire 					                core_mmu_axi_mem_write_en 			;
wire                                    core_mmu_inst_req                   ;
//--------------------------------------------------------


// 				            PHYSICAL ADDRESSES HIT SIGNAL BY MMU

wire 					                mmu_data_memory_hit 			    ;
wire 				                	mmu_instruction_hit 			    ;

//--------------------------------------------------------


//		                20 BIT PHYSICAL PAGE NUMBER OF BOTH INSTRUCTION MEMORY AND DATA MEMORY BY MMU 

wire 	[MMU_PPN_WIDTH -1 :0] 	    	mmu_ppn_inst_mem_address 			;
wire 	[MMU_PPN_WIDTH -1 :0] 	    	mmu_ppn_data_mem_address 			;

//--------------------------------------------------------


//		                FINAL PHYSICAL ADDRESS OF BOTH INSTRUCTION MEMORY AND DATA MEMORY

wire 	[31:0] 				            mmu_axi_physical_address_inst_mem 	;
wire 	[31:0] 				            mmu_axi_physical_address_data_mem 	;

//--------------------------------------------------------


//--------------------------AXI MASTER AND BRIDGE INTERFACE SIGNALS---------------------


// 				            WRITE ADDRESS CHANNEL 

wire 					                axi_bridge_awvalid 				    ;
wire 	[AXI_ADDR_WIDTH -1:0] 		    axi_bridge_awaddr 				    ;
wire 					                bridge_axi_awready 				    ;


//			            	WRITE DATA CHANNEL 

wire 					                axi_bridge_wvalid 				    ;
wire 	[AXI_DATA_WIDTH-1:0] 		    axi_bridge_wdata 				    ;
wire 	[STROBE_WIDTH-1:0] 		        axi_bridge_wstrb 				    ;
wire 					                bridge_axi_wready 				    ;


//				            WRITE RESPONSE CHANNEL

wire 					                axi_bridge_bready 				    ;
wire 	[1:0]				            bridge_axi_bresp 				    ;
wire 					                bridge_axi_bvalid 				    ;


//				            READ ADDRESS CHANNEL

wire 					                axi_bridge_arvalid 				    ;
wire 	[AXI_ADDR_WIDTH-1:0] 		    axi_bridge_araddr 				    ;
wire 					                bridge_axi_arready 				    ;


//				            READ DATA CHANNEL

wire 					                axi_bridge_rready 				    ;
wire 					                bridge_axi_rvalid 				    ;
wire 	[AXI_DATA_WIDTH-1:0] 		    bridge_axi_rdata 				    ;
wire 	[1:0]				            bridge_axi_rresp 				    ;


//--------------------------AXI AND DATA MEMORY INTERFACE -------------------------------


// 				            WRITE ADDRESS CHANNEL 

wire 					                axi_data_mem_awvalid			    ;
wire 	[AXI_ADDR_WIDTH -1:0] 		    axi_data_mem_awaddr 			    ;
wire 					                data_mem_axi_awready			    ;
wire	[2:0]				            common_awsize					    ;

//				            WRITE DATA CHANNEL 

wire 					                axi_data_mem_wvalid 			    ;
wire 	[AXI_DATA_WIDTH-1:0] 		    axi_data_mem_wdata 			        ;
wire 	[STROBE_WIDTH-1:0] 		        axi_data_mem_wstrb 			        ;
wire 					                data_mem_axi_wready 			    ;

//				            WRITE RESPONSE CHANNEL

wire 					                axi_data_mem_bready 			    ;
wire 	[1:0]				            data_mem_axi_bresp 			        ;
wire 					                data_mem_axi_bvalid 			    ;

//				            READ ADDRESS CHANNEL

wire 					                axi_data_mem_arvalid			    ;
wire 	[AXI_ADDR_WIDTH-1:0] 		    axi_data_mem_araddr 			    ;
wire 					                data_mem_axi_arready 			    ;

//				            READ DATA CHANNEL

wire 					                axi_data_mem_rready 			    ;
wire 					                data_mem_axi_rvalid 			    ;
wire 	[AXI_DATA_WIDTH-1:0] 		    data_mem_axi_rdata			        ;
wire 	[1:0]				            data_mem_axi_rrsep			        ;


//--------------------------APB MASTER INTERFACE------------------


wire 					                bridge_peripheral_psel 				;
wire 	[AXI_ADDR_WIDTH-1:0] 		    bridge_peripheral_paddr 			;
wire 	[AXI_DATA_WIDTH-1:0] 		    bridge_peripheral_pwdata 			;
wire 					                bridge_peripheral_penable 			;
wire 					                bridge_peripheral_pwrite 			;
wire 					                peripheral_bridge_pready 			;
wire 	[AXI_DATA_WIDTH-1:0] 		    peripheral_bridge_prdata 			;
wire 					                peripheral_bridge_pslverr 			;

//----------------------------------------------------------------------------


//------------------APB BRIDGE TO PERIPHERALS INTERFACE SIGNALS------------------------


//			APB BRIDGE TO UART INTERFACE SIGNALS

wire 					                uart_psel 				            ;
wire 	[31:0] 	                        uart_prdata 				        ;
wire 					                uart_pready 				        ;
wire 					                uart_pslverr 				        ;


//			APB BRIDGE TO I2C INTERFACE SIGNALS

wire 					                i2c_psel 				            ;
wire 	[I2C_DATA_WIDTH - 1 :0] 	    i2c_prdata 				            ;
wire 					                i2c_pready 				            ;
wire 					                i2c_pslverr 				        ;


//			APB BRIDGE TO SPI INTERFACE SIGNALS

wire 					                spi_psel 				            ;
wire 	[SPI_DATA_WIDTH-1:0] 		    spi_prdata 				            ;
wire 					                spi_pready 				            ;
wire 				                	spi_pslverr 				        ;

//			APB BRIDGE TO WATCHDOG TIMER INTERFACE SIGNALS

wire 					                watchdog_psel 				        ;
wire 	[31:0] 		                    watchdog_prdata 				    ;
wire 					                watchdog_pready 				    ;
wire 				                	watchdog_pslverr 				    ;

//			APB BRIDGE TO WATCHDOG TIMER INTERFACE SIGNALS

wire 					                clk_rst_ctrl_psel 				    ;
wire 	[31:0] 		                    clk_rst_ctrl_prdata 				;
wire 					                clk_rst_ctrl_pready 				;
wire 				                	clk_rst_ctrl_pslverr 				;

//			APB BRIDGE TO TOP REGISTER INTERFACE SIGNALS

wire 					                top_reg_psel 				        ;
wire 	[31:0] 		                    top_reg_prdata 				        ;
wire 					                top_reg_pready 				        ;
wire 				                	top_reg_pslverr 				    ;

//			APB BRIDGE TO GPIO REGISTER INTERFACE SIGNALS

wire 					                gpio_reg_psel 				        ;
wire 	[31:0] 		                    gpio_reg_prdata 				    ;
wire 					                gpio_reg_pready 				    ;
wire 				                	gpio_reg_pslverr 				    ;


//-------------------------------------------------------------------------------------------------


//-------------------------------CORE AND CSR INTERFACE--------------------

wire 	[CSR_DATA_WIDTH-1:0] 		    csr_core_read_data 			        ;
wire 					                core_csr_read_en 			        ;
wire 					                core_csr_write_en 			        ;
wire 	[11:0]  		                core_csr_addr			            ;
wire 	[CSR_DATA_WIDTH-1:0] 		    core_csr_write_data 		        ;
wire 					                core_csr_set_bit 			        ;
wire 					                core_csr_clear_bit 		            ;
wire 					                core_csr_e_break_valid 		        ;
wire 					                core_csr_mret_valid 			    ;
wire    [31:0]                          csr_core_mepc                       ;                                 
wire    [31:0]                          csr_core_dpc                        ;
wire    [31:0]                          core_csr_mepc_in                    ;                               
wire    [31:0]                          core_csr_branch_pc                  ;
wire                                    core_csr_branch_valid               ;

//-------------------------------------------------------------------------------------------------


//------------------------------DEBUG AXI AND INSTRUCTION MEMORY AXI INTERFACE---------------------


// 	                            WRITE ADDRESS CHANNEL 

wire 					                debug_axi_inst_mem_awvalid			;
wire 	[AXI_ADDR_WIDTH -1:0] 		    debug_axi_inst_mem_awaddr 			;
wire 					                debug_axi_inst_mem_awready			;

//				                WRITE DATA CHANNEL 

wire 					                inst_mem_debug_axi_wvalid 			;
wire 	[AXI_DATA_WIDTH-1:0] 		    inst_mem_debug_axi_wdata 			;
wire 	[STROBE_WIDTH-1:0] 		        debug_axi_inst_mem_wstrb 			;
wire 					                debug_axi_inst_mem_wready 			;

//				                WRITE RESPONSE CHANNEL

wire 					                debug_axi_inst_mem_bready 			;
wire 	[1:0]				            inst_mem_debug_axi_bresp 			;
wire 					                inst_mem_debug_axi_bvalid 			;

//				                READ ADDRESS CHANNEL

wire 					                debug_axi_inst_mem_arvalid			;
wire 	[AXI_ADDR_WIDTH-1:0] 		    debug_axi_inst_mem_araddr 			;
wire 					                inst_mem_debug_axi_arready 			;

//				                READ DATA CHANNEL

wire 					                debug_axi_inst_mem_rready 			;
wire 					                inst_mem_debug_axi_rvalid 			;
wire 	[AXI_DATA_WIDTH-1:0] 		    inst_mem_debug_axi_rdata 			;
wire 	[1:0]				            inst_mem_debug_axi_rresp 			;


//------------------------------CORE AND INSTRUCTION MEMORY AXI INTERFACE SIGNALS-------------------------------

//				                READ DATA CHANNEL

wire 					                core_axi_inst_mem_rready = 1'b1		;
wire 					                inst_mem_core_axi_rvalid 			;
wire 	[1:0]				            inst_mem_core_axi_rresp 			;


//-------------------------------------------------------------------------------------------------

//---------------------------JTAG AND AXI WRAPPER INTERFACE SIGNALS-----------------------------

wire    [31:0]                          debug_axi_address_in                ;
wire                                    debug_axi_read_en                   ;
wire                                    debug_axi_write_en                  ;
wire                                    debug_axi_req_valid                 ;
wire    [2:0]                           debug_axi_awsize = 3'b010           ;
wire    [31:0]                          debug_axi_write_data                ;
wire    [3:0]                           debug_axi_byte_en                   ;
wire    [31:0]                          axi_debug_read_data                 ;
wire    [1:0]                           axi_debug_read_resp                 ;
wire    [1:0]                           axi_debug_write_resp                ;
wire                                    axi_debug_read_valid                ;
wire                                    axi_debug_read_ready                ;
wire                                    axi_debug_write_valid               ;
wire                                    axi_debug_write_ready               ;


//--------------------------DEBUG AND CSR CONNECTION----------------------

wire                                    debug_csr_write_en                  ;
wire    [31:0]                          debug_csr_write_data                ;
wire    [31:0]                          csr_debug_read_data                 ;
wire                                    csr_debug_read_valid                ;
wire                                    debug_csr_ndm_reset                 ;

//-------------------------DEBUG TO CSR AND GPR COMMON SIGNAL

wire    [15:0]                          debug_csr_gpr_address               ;
wire                                    debug_csr_gpr_read_en               ;

//--------------------------------------------------------------------------------------------------


wire 	[3:0] 				            core_axi_wstrobe 				    ;	//	BYTE ENABLE SIGNAL FROM CORE NEED TO CHANGE ACCORDING TO THE AXI INTERFACE
wire 	[31:0] 				            instruction_to_core 				;	//	FINAL INSTRUCTION TO THE CORE
wire    [31:0]                          instruction_from_mem                ;   //  INSTRUCTION FROM THE INSTRUCTION MEMORY
wire                                    inst_mem_req_valid                  ;   //  INSTRUCTION REQUEST VALID FOR INSTRUCTION MEMORY
wire 	[31:0] 				            mem_write_data_core 			    ;	//	WRIRE DATA TO THE TARGETED MEMORY ADDRESS
wire 	[31:0] 				            axi_core_mem_read_data 		        ;	//	DATA FROM THE REQUESTED MEMORY ADDRESS

//-----------------------------------CSR AMD MMU CONNECTIONS----------------

wire					                mmu_enable 				            ;	// 	MMU ENABLE BY CSR
wire                                    mmu_busy                            ;
wire 	[21:0]				            csr_mmu_base_ppn 				    ;	//	PAGE TABLE ENTRIES BASE PPN ADDRESS TO MMU BY CSR
wire 	[8:0]				            csr_mmu_current_asid 				;	//	CURRENT ASID TO MMU FROM CSR


//-----------------------------AXI MASTER WRAPPER OF INSTRUCTION MEMORY SIGNALS USED FOR GLUE LOGICS--------------------


wire 	[1:0] 				            inst_mem_rresp 				        ;	//	INSTRUCTION MEMORY READ RESPONSE SIGNAL
wire 					                inst_mem_rvalid 			        ;	// 	INSTRCUTION MEMORY READ VALID SIGNAL
wire 					                inst_mem_rready 			        ;	// 	INSTRUCTION MEMORY READ READY SIGNAL

//---------------------------STALL SIGNAL USED FOR GLUE LOGIC---------------------------

wire 					                stall_by_axi_data_mem_read 		    ;	//	STALL SIGNAL BY DATA MEMORY READ
wire					                stall_by_axi_data_mem_write		    ;	//	STALL SIGNAL BY DATA MEMORY WRITE
wire					                stall_by_load_store			        ;	//	STALL SIGNAL BY BOTH READ AND WRITE BY DATA MEMORY
wire 					                stall_the_core_pipeline				; 

//--------------------------CORE TO AXI MASTER WRAPPER REQUEST VALID SIGNALS

wire 					                axi_data_mem_req_valid			    ;	//	AXI MASTER WRAPPER OF DATA MEMORY INPUT VALID BIT
wire					                axi_inst_mem_req_valid			    ;	//	AXI MASTER WRAPPER OF INSTRUCTION MEMORY INPUT VALID BIT
wire					                axi_master_select			        ;

//-------------------------VALID,READY AND RESPONSE SIGNALS FROM THE AXI MASTER WRAPPER OF DATA MEMORY SIDE


wire	[1:0]				            axi_core_rresp			            ;		//	READ RESPONSE SIGNAL
wire	[1:0]				            axi_core_bresp			            ;		//	WRITE_RESPONSE SIGNAL
wire					                axi_core_rvalid			            ;		//	READ VALID SIGNAL
wire 					                axi_core_rready			            ;		//	READ READY SIGNAL
wire					                axi_core_bready			            ;		//	WRITE RESPONSE READY SIGNAL
wire 					                axi_core_bvalid			            ;		//	WRITE RESPONSE VALID SIGNAL
wire	[2:0]				            core_axi_awsize			            ;

//----------------------------DEBUG MODULE TO PTE CONNNECTIONS----------------------------

wire                                    debug_pte_valid_in                  ;
wire    [31:0]                          debug_pte_address                   ;
wire                                    debug_pte_write_en                  ;
wire    [31:0]                          debug_pte_write_data                ;
wire    [1:0]                           pte_debug_write_resp                ;
wire                                    pte_debug_write_valid               ;
wire                                    debug_pte_read_en                   ;
wire    [31:0]                          pte_debug_read_data                 ;
wire    [1:0]                           pte_debug_read_resp                 ;
wire                                    pte_debug_read_valid                ;


//--------------------------------MMU TO PTE MEMORY CONNECTIONS------------------------------


wire                                    mmu_pte_req_valid                   ;
wire    [31:0]                          mmu_pte_req_address                 ;
wire                                    pte_mmu_resp_valid                  ;
wire    [31:0]                          pte_mmu_read_data                   ;


//-------------------------------DEBUG AND INSTRUCTION MEMORY CONNECTION USED BY BOOT LOADER----------------------

wire    [31:0]                          inst_mem_debug_read_data            ;
wire                                    debug_inst_mem_req_valid            ;
wire                                    debug_inst_mem_write_en             ;
wire    [31:0]                          debug_inst_mem_address_in           ;
wire    [31:0]                          debug_inst_mem_write_data           ;

//-------------------------------DEBUG AND DATA MEMORY CONNECTION USED BY BOOT LOADER----------------------

wire    [31:0]                          data_mem_debug_read_data            ;
wire                                    debug_data_mem_req_valid            ;
wire                                    debug_data_mem_write_en             ;
wire    [31:0]                          debug_data_mem_address_in           ;
wire    [31:0]                          debug_data_mem_write_data           ;

//----------------------------CLK RST BYPASS MODUELE SIGNALS--------------------

wire                                    boot_load_enable                    ;
wire                                    memory_clk                          ;
wire                                    debug_clk                           ;
wire                                    debug_rstn                          ;
wire                                    rst_for_clk_ctrl                    ;

//--------------------CLK RST CONTROLLER MODULE SIGNALS------------------------

wire                                    core_clk                            ;
wire                                    core_rstn                           ;
wire                                    pclk                                ;
wire                                    presetn                             ;
wire                                    ctrl_bypass_debug_rstn              ;
wire                                    clk_to_clk_rst_ctrl                 ;

//----------------------------I2C IO PAD SIGNALS--------------------

wire                                    i2c_sda_in                          ;
wire                                    i2c_sda_out                         ;
wire                                    i2c_sda_oe                          ;

//-----------------------------SPI TO PAD SIGNALS-------------------

wire                                    spi_mosi                            ;
wire                                    spi_miso                            ;
wire                                    spi_ss                              ;
wire                                    spi_sclk                            ;

//-----------------------------UART TO PAD SIGNALS----------------------

wire                                    uart_tx                             ;
wire                                    uart_rx                             ;

//--------------------------------------MMU AND TOP REGISTER SIGNALS-----------------------------

wire                                    mmu_prefetch_enable                 ;
wire                                    mmu_ptw_timeout_enable              ;
wire                                    mmu_ptw_timeout                     ;
wire  					                instruction_execute_permission_fault;
wire 					                mem_read_permission_fault 		    ; 
wire 					                mem_write_permission_fault 		    ;
wire					                inst_page_fault				        ;
wire					                mem_page_fault				        ;

//-----------------------------------EXCEPTIONS OF THE MEMORY TO TOP REGISTER-------------------------

wire					                req_data_mem_address_decode_error	;	//	DATA MEMORY ADDRESS DECODE ERROR
wire 					                data_mem_read_addr_slverr			;	//	DATA MEMORY SLAVE ERROR DUE TO READ OPERATION
wire					                data_mem_write_addr_slverr			;	//	DATA MEMORY SLAVE ERROR DUE TO WRITE OPERATION
wire                                    inst_mem_addr_decode_error          ;   //  INSTRUCTION MEMORY ADDRESS OUT OF RANGE INDICATION

//--------------------------------------GPIO TO CLK RST BYPASS SIGNALS----------------------------

wire                                    gpio_boot_gpio9                     ;
wire                                    gpio_boot_gpio11                    ;

//-------------------------------------DEBUG TO CORE SIGNALS------------------------------

wire                                    debug_core_pb_valid                 ;                        
wire    [31:0]                          debug_core_pb_instruction           ;
wire                                    debug_core_halt_request             ;
wire                                    debug_core_reset_halt               ;  
wire                                    debug_core_resume_req               ;

//------------------------------------CORE TO DEBUG SIGNALS--------------------------------

wire    [31:0]                          core_debug_read_data                ;                      
wire                                    core_debug_read_valid               ;          
wire                                    core_debug_hart_halted              ;                    
wire                                    core_debug_hart_reset               ;                     
wire                                    debug_mode_en                       ;

//-----------------------------------READ DATA AND VALID SIGNALS FROM CSR OR GPR TO DEBUG MODULE-------------------

wire    [31:0]                          csr_gpr_debug_read_data             ;
wire                                    csr_gpr_debug_read_valid            ;

//----------------------------------CORE TO WATCHDOG TIMER SIGNALS-------------------------

wire    [31:0]                          last_commited_pc                    ;

//---------------------------------WIRES USED FRO GLUE LOGICS

wire                                    axi_debug_read_valid_in             ;
wire                                    axi_debug_write_valid_in            ;


//--------------------------------------------TO DO LIST--------------------------------------------------


//                                  DEBUG TO WATCHDOG SIGNAL

wire                                    debug_watchdog_freeze = 1'b0        ;

//                                  CORE TO WATCHDOG TIMER SIGNAL

wire                                    core_watchdog_commit_valid = 1'b1   ;


//---------------------------------------------------------------------------------------------


//---------------------------------------GLUE LOGICS---------------------------------------------


//                                  INSTRUCTION PPN REQUESTING TO MMU GLUE LOGIC

assign  core_mmu_inst_req                       =   ~boot_load_enable & ~debug_mode_en & ~mmu_busy                          ;


//		            STALL LOGIC FOR THE CORE TO STALL UNTIL LOAD AND STORE IS COMPLETE

assign 	stall_by_axi_data_mem_read 	            = 	core_mmu_axi_mem_read_en & ~( axi_core_rvalid & axi_core_rready & (axi_core_rresp == 2'b00) ) ;
	
assign 	stall_by_axi_data_mem_write 	        = 	core_mmu_axi_mem_write_en & ~( axi_core_bvalid & axi_core_bready & ( axi_core_bresp == 2'b00) )	;

assign 	stall_by_load_store 		            = 	stall_by_axi_data_mem_read | stall_by_axi_data_mem_write ;


//			                OVERALL STALL THE CORE BY INSTRUCTION OR DATA MEMORY ACCESS

assign 	stall_the_core_pipeline		            =	 !mmu_instruction_hit |  ~inst_mem_core_axi_rvalid | stall_by_load_store	;


//			                    FINAL PHYSICAL ADDRESS DEPENDING ON THE MMU ENABLE

assign 	mmu_axi_physical_address_inst_mem 		= 	{ mmu_ppn_inst_mem_address, core_mmu_inst_mem_virtual_address[11:0] } 		;
assign 	mmu_axi_physical_address_data_mem 		= 	{ mmu_ppn_data_mem_address, core_mmu_data_mem_virtual_address[11:0] } 		;

assign  instruction_to_core                     =   ( (inst_mem_core_axi_rresp == 2'b00) && inst_mem_core_axi_rvalid ) ? instruction_from_mem : 32'd0 ;

//			        THIS SIGNAL TELLS THE REQUESTED ADDRESS IS VALID OR NOT TO THE AXI WRAPPERS

assign 	axi_data_mem_req_valid		            = 	mmu_data_memory_hit & ((core_mmu_axi_mem_read_en & ~ mem_read_permission_fault )|( core_mmu_axi_mem_write_en & ~mem_write_permission_fault)) & ~data_mem_read_addr_slverr & ~data_mem_write_addr_slverr ;

assign 	inst_mem_req_valid		                = 	mmu_instruction_hit &&  ~instruction_execute_permission_fault  && ( ( mmu_axi_physical_address_inst_mem <= INST_MEMORY_MAX_ADDRESS ) && ( mmu_axi_physical_address_inst_mem >= INST_MEMORY_MIN_ADDRESS ) );

assign 	inst_mem_addr_decode_error              = 	mmu_instruction_hit && ~( ( mmu_axi_physical_address_inst_mem <= INST_MEMORY_MAX_ADDRESS ) && ( mmu_axi_physical_address_inst_mem >= INST_MEMORY_MIN_ADDRESS ) );

//			                    MEMORY READ AND WRITE SLAVE ERROR

assign 	data_mem_read_addr_slverr		        = 	axi_core_rvalid & axi_core_rready & (axi_core_rresp == 2'b10) 	;
assign 	data_mem_write_addr_slverr		        =	axi_core_bvalid & axi_core_bready & (axi_core_bresp == 2'b10) 	;

//                  READ DATA AND VALID TO DEBUG MODULE FROM CSR OR GPR SELECTING ONE OD THE DATA AND VALID

assign  csr_gpr_debug_read_data                 =   (debug_csr_gpr_address[15:12] == 4'd0) ? csr_debug_read_data : core_debug_read_data ;
assign  csr_gpr_debug_read_valid                =   (debug_csr_gpr_address[15:12] == 4'd0) ? csr_debug_read_valid : core_debug_read_valid ;

//                      AXI MASTER SELECT LOGIC WHETHER IT IS A CORE MODE OR DEBUG MODE 

assign  axi_master_select                       =   debug_mode_en & ~core_mmu_axi_mem_write_en & ~core_mmu_axi_mem_read_en ;

//                      READ AND WRITE VALID SIGNALS TO DEBUG MODULE FROM AXI MASTER WRAPPER

assign  axi_debug_read_valid_in                 =   axi_debug_read_valid & axi_debug_read_ready             ;
assign  axi_debug_write_valid_in                =   axi_debug_write_valid & axi_debug_write_ready           ;
//-------------------------------------------------------------------------------------------------------------




//------------------------------------------MODULES INSTANTIATIONS---------------------------------------------------



//------------------------------------------RISC V BASIC CORE INSTANCE---------------------------------------

rv32i_core 	    basic_isa_instance 			    (


//                                  FROM THE CLK RST CONTROLLER MODULE

    		.clk					            (core_clk)					                    ,
    		.rst					            (~core_rstn)					                ,

//      STALL SIGNAL TO CORE WHEN THE CORE REQUESTING DATA FROM MEMORIES STALL UNTIL CORE GETS VALID LOAD OR STORE

			.stall_by_mmu				        (stall_the_core_pipeline) 			            ,

//                      FROM AXI SLAVE WRAPPER OF INSTRUCTION MEMORY MODULE AFTER GLUE LOGIC

			.instruction				        (instruction_to_core) 				            ,

//                                  TO THE MMU MODULE

     		.pc					                (core_mmu_inst_mem_virtual_address)		        ,
   			.data_mem_address			        (core_mmu_data_mem_virtual_address) 		    ,  
            .sfence_flush_o				        (csr_mmu_tlb_flush)				                ,

//                          TO THE MMU AND AXI MASTER WRAPPER MODULES

			.mem_write_en				        (core_mmu_axi_mem_write_en) 			        ,
			.mem_read_en				        (core_mmu_axi_mem_read_en) 			            ,

//                              TO AXI MASTER WRAPPER SIGNALS MODULE

			.byte_enable				        (core_axi_wstrobe) 				                ,
			.mem_write_data				        (mem_write_data_core) 			                ,
			.awsize					            (core_axi_awsize)			                    ,

//                              FROM THE AXI MASTER WRAPPPER MODULE 

    		.data_from_mem				        (axi_core_mem_read_data) 		                ,

//                              TO THE WATCHDOG TIMER MODULE

            .last_commited_pc                   (last_commited_pc)                              ,
		
//                                  FROM THE CSR MODULE             
			                              
            .csr_read_data_i			        (csr_core_read_data)			                ,
            .mepc_i                             (csr_core_mepc)                                 ,
            .dpc_i                              (csr_core_dpc)                                  ,

//                                  TO THE CSR MODULE

            .csr_read_en_o				        (core_csr_read_en)			                    ,
            .csr_write_en_o				        (core_csr_write_en)		                        ,
            .csr_addr_o				            (core_csr_addr)			                        ,
            .csr_write_data_o			        (core_csr_write_data)		                    ,
            .csr_set_bit_o				        (core_csr_set_bit)			                    ,
            .csr_clear_bit_o			        (core_csr_clear_bit)		                    ,
            .e_break_valid_o			        (core_csr_e_break_valid)		                ,
            .mret_valid_o				        (core_csr_mret_valid)                           ,
            .branch_pc_to_csr                   (core_csr_branch_pc)                            ,
            .branch_valid_o                     (core_csr_branch_valid)                         ,
            .core_to_int_o                      (core_csr_mepc_in)                              ,

//                                  FROM THE DEBUG MODULE   

            .pb_insn_valid_i                    (debug_core_pb_valid)                           ,
            .pb_insn_i                          (debug_core_pb_instruction)                     ,
            .dbg_reg_read_en_i                  (debug_csr_gpr_read_en)                             ,
            .dbg_reg_read_addr_i                (debug_csr_gpr_address)                             ,
            .halt_req_i                         (debug_core_halt_request)                       ,
            .reset_halt_i                       (debug_core_reset_halt)                         ,
            .resume_req_i                       (debug_core_resume_req)                         ,

//                                  TO THE DEBUG SIGNALS                             

            .dbg_reg_read_data_o                (core_debug_read_data)                          ,
            .dbg_reg_read_valid_o               (core_debug_read_valid)                         ,
            .hart_halted_o                      (core_debug_hart_halted)                        ,
            .hart_reset_o                       (core_debug_hart_reset)                         ,

//              TO THE CSR, CLK RST CONTROLLER, AXI SLAVE WRAPPER OF INSTRUCTION MEMORY AND WATCHDOG TIMER
            
            .dbg_mode_o                         (debug_mode_en)                                 


   						 		                )					                            ;

//----------------------------------------------CSR MODULE INSTANTIATION-----------------------------------------


//				SOME PINS ARE LEFT UNCONNECTED NEED TO CONNECT AFTER THE INTERRUPT MODULE INTEGRATE

soc_csr_top 		 					        #(


			.CSR_ADDR_WIDTH				        (CSR_ADDR_WIDTH)			                    ,
			.DATA_WIDTH				            (CSR_DATA_WIDTH)			                    ,
			.INSTRUCTION_WIDTH			        (CSR_INSTRUCTION_WIDTH)			                ,
			.PC_WIDTH				            (CSR_PC_WIDTH)

								                )

			csr_top_instance			        (

//                              FROM THE CLK RST CONTROLLER MODULE

           .csr_clk				                (core_clk) 					                    ,
           .csr_rstn				            (core_rstn)					                    ,

//                                      TO THE CSR MODULE

           .csr_write_en_in			            (core_csr_write_en)		                        ,   		
           .csr_addr_in				            (core_csr_addr)			                        ,
           .csr_read_en_in				        (core_csr_read_en)			                    ,
           .csr_write_data_in			        (core_csr_write_data)		                    ,		
           .csr_set_bit_in				        (core_csr_set_bit)			                    ,		
           .csr_clear_bit_in			        (core_csr_clear_bit)		                    ,
           .csr_read_data_o			            (csr_core_read_data)			                ,	
           .csr_mepc_in				            (core_csr_mepc_in)		                        ,
           .branch_valid_i				        (core_csr_branch_valid)		                    ,
           .mret_valid_i				        (core_csr_mret_valid) 			                ,
           .ebreak_valid_i				        (core_csr_e_break_valid)		                ,
           .branch_pc_i				            (core_csr_branch_pc)                            ,                      
           .dpc_o					            (csr_core_dpc)		                            ,
           .dbg_mode_valid_i			        (debug_mode_en)		                            ,      

//                                      TO THE MMU MODULE

           .satp_mode_o				            (mmu_enable)				                    ,
           .satp_asid_o				            (csr_mmu_current_asid)				            ,
           .satp_ppn_o				            (csr_mmu_base_ppn)				                ,

//                                      FROM THE DEBUG MODULE 

           .dbg_mode_write_en_i			        (debug_csr_write_en)					        ,    
           .dbg_mode_write_data_i			    (debug_csr_write_data)					        ,
           .dbg_mode_csr_addr_i			        (debug_csr_gpr_address)					            ,
           .dbg_mode_read_en_i			        (debug_csr_gpr_read_en)					            ,
           .dbg_ndm_reset_i			            (debug_csr_ndm_reset)		                    ,

//                                  TO THE DEBUG MODULE
                                 
           .dbg_mode_read_data_o			    (csr_debug_read_data)					        ,
           .dbg_csr_read_valid_o			    (csr_debug_read_valid)					        ,

//                                  UNCONNECTED PORTS

           .interrupt_valid_in			        () 		,	 	
           .interrupt_code_in			        ()	    ,
           .instr_misalign_valid_in		        ()		,
           .mie_set				                ()		,	
           .mie_clear				            ()		,	
           .pc_in					            ()		,	
           .csr_mepc_write_valid			    () 		,
           .stall_valid_i				        ()		,
           .interrupt_lvl_pr_i			        ()		,
           .interrupt_id_write_valid_i		    ()		,
           .int_active_level_priority_o	        ()		,
           .csr_mepc_o				            ()		,
           .mstatus_mie_o				        ()		,
           .csr_mtvec_o				            ()		,
           .csr_mcause_o				        ()		,
           .trigger_valid_i			            ()		,
           .haltreq_valid_i			            ()		,
           .single_step_valid_i			        ()		,
           .reset_haltreq_valid_i			    ()		,
           .dbg_hart_reset_i			        ()		

								                )					                            ;


//---------------------------------------------MMU INSTANCE---------------------------------------


mmu_core 		 					            #(


			.VPN_WIDTH				            (MMU_VPN_WIDTH)				                    ,
			.PPN_WIDTH				            (MMU_PPN_WIDTH)				                    ,
			.ASID_WIDTH				            (MMU_ASID_WIDTH)			                    ,
			.ACCESS_WIDTH				        (MMU_ACCESS_WIDTH)			                    ,
			.L1_ENTRIES				            (MMU_L1_ENTRIES)			                    ,
			.L2_ENTRIES				            (MMU_L2_ENTRIES)			

								                )

			mmu_instance				        (

//                              FROM THE CLK RST CONTROLLER MODULE

			.clk					            (core_clk) 					                    ,
			.rst					            (~core_rstn) 					                ,

//				                FROM THE CSR MODULE 

			.pt_base_ppn				        (csr_mmu_base_ppn) 				                ,
			.mmu_enable				            (mmu_enable) 				                    ,
			.current_asid				        (csr_mmu_current_asid) 				            ,

//                              FROM THE TOP REGISTER MODULE

			.prefetch_enable			        (mmu_prefetch_enable)                           ,
			.ptw_timeout_enable			        (mmu_ptw_timeout_enable)		                ,

//                              TO THE TOP REGISTER MODULE

			.ptw_timeout_event			        (mmu_ptw_timeout)		                        ,

//					            FROM THE CORE MODULE

			.mem_read_en				        (core_mmu_axi_mem_read_en) 			            ,
			.mem_write_en				        (core_mmu_axi_mem_write_en) 			        ,
			.tlb_flush				            (csr_mmu_tlb_flush) 				            ,
			.i_if_vpn				            (core_mmu_inst_mem_virtual_address[31:12]) 	    ,
			.i_mem_vpn				            (core_mmu_data_mem_virtual_address[31:12]) 	    ,

//                          TO THE AXI SLAVE WRAPPPER OF INSTRUCTION MEMORY MODULE

			.o_if_ppn				            (mmu_ppn_inst_mem_address) 			            ,
			.o_if_hit				            (mmu_instruction_hit) 			                ,

//                          TO THE AXI MASTER WRAPPER MODULE

			.o_mem_ppn				            (mmu_ppn_data_mem_address) 			            ,

//                  USED FOR GLUE LOIC OF ARVALID SIGNAL FOR THE AXI MASTER WRAPPER MODULE

			.o_mem_hit				            (mmu_data_memory_hit) 			                ,

//                      USED FOR GLUE LOGIC TO GIVE NEW REQUST FOR MMU

			.o_mmu_busy				            (mmu_busy)		                                ,

//                            TAKEN FROM THE GLUE LOGIC

			.inst_vpn_req				        (core_mmu_inst_req)				                ,


//				                TO THE PTE MEMORY WRAPPER MODULE
				
			.pte_req_valid				        (mmu_pte_req_valid) 		                    ,
			.pte_req_addr				        (mmu_pte_req_address)		                    ,

//                              FROM THE PTE MEMORY WRAPPER MODULE

			.mem_resp_valid				        (pte_mmu_resp_valid) 		                    ,
			.mem_resp_ppn				        (pte_mmu_read_data[31:12]) 		                ,
			.mem_resp_validbit			        (pte_mmu_read_data[0]) 		                    ,
			.mem_resp_access			        (pte_mmu_read_data[3:1])		                ,
			
//					            TO THE TOP REGISTER MODULE
	
			.inst_execute_permission_fault		(instruction_execute_permission_fault) 	        ,
			.mem_read_permission_fault		    (mem_read_permission_fault) 		            ,
			.mem_write_permission_fault		    (mem_write_permission_fault)		            ,
			.inst_page_fault			        (inst_page_fault)			                    ,
			.mem_page_fault				        (mem_page_fault)


								                )                                               ;

    
//--------------------------------PAGE TABLE MEMORY INSTANCE---------------------------------------

pte_wrapper     pte_wrapper_instance            (


//                              FROM THE CLK RST CONTROLLER MODULE

            .clk                                (core_clk)                                      ,
            .rst                                (~core_rstn)                                    ,

//                              FROM THE DEBUG MODULE                              
  
            .dbg_valid                          (debug_pte_valid_in)                            ,
            .dbg_addr                           (debug_pte_address)                             ,
            .dbg_write_en                       (debug_pte_write_en)                            ,
            .dbg_wdata                          (debug_pte_write_data)                          ,
            .dbg_read_en                        (debug_pte_read_en)                             ,

//                                  TO THE DEBUG MODULE

            .dbg_write_resp                     (pte_debug_write_resp)                          ,
            .dbg_write_valid                    (pte_debug_write_valid)                         ,
            .dbg_rdata                          (pte_debug_read_data)                           ,
            .dbg_read_resp                      (pte_debug_read_resp)                           ,
            .dbg_read_valid                     (pte_debug_read_valid)                          ,

//                                  FROM THE MMU MODULE

            .ptw_req_valid                      (mmu_pte_req_valid)                             ,
            .ptw_req_addr                       (mmu_pte_req_address)                           ,

//                                  TO THE MMU MODULE

            .ptw_rdata                          (pte_mmu_read_data)                             ,
            .ptw_resp_valid                     (pte_mmu_resp_valid)                            

                                                )                                               ;


//----------------------------AXI MASTER ONLY READ ONLY WRAPPER FOR THE INSTRUCTION MEMORY-------------------------------
/*


axi_master_read_wrapper 	axi_read_instruction_mem_instance	(


			.clk					            (core_clk)					                    ,
			.rst_n					            (~rst)					                        ,
			
			.in_address				            (mmu_axi_physical_address_inst_mem)			    ,
			.in_valid				            (axi_inst_mem_req_valid)			            ,
			.reset_valid				        (~stall_the_core_pipeline)			            ,
			.read_data_out				        (instruction_to_core)				            ,
			.read_resp_out				        (inst_mem_rresp)			                    ,
			.is_branch_jump				        (branch_jump_load_hazard)			            ,
			
			.read_valid				            (inst_mem_rvalid)			                    ,
			.read_ready				            (inst_mem_rready)			                    ,
			
			.M_AXI_ARADDR				        (core_axi_inst_mem_araddr)			            ,
			.M_AXI_ARVALID				        (core_axi_inst_mem_arvalid)			            ,
			.M_AXI_ARREADY				        (inst_mem_core_axi_arready)			            ,
			
			.M_AXI_RDATA				        (inst_mem_core_axi_rdata)			            ,
			.M_AXI_RRESP				        (inst_mem_core_axi_rresp)			            ,
			.M_AXI_RVALID				        (inst_mem_core_axi_rvalid)			            ,
			.M_AXI_RREADY				        (core_axi_inst_mem_rready)

								                )					                            ;

*/
//---------------------------------AXI SLAVE WRAPPER WITH DATA MEMORY INSTANCE---------------


axi_instmem_wrapper						        #(

			.INST_MEMORY_ADDR_WIDTH				(INST_MEMORY_ADDR_WIDTH)	

								                )
		

			axi_slave_wrapper_inst_mem_instance	(

//                          CLOCK SIGNAL FROM THE CLK RST BYPASS MODULE

			.ACLK					            (memory_clk)					                ,

//                          RESET FROM THE CLK RST CONTROLLER MODULE

			.ARESETN				            (core_rstn)					                    ,

//                              FROM THE CORE 

			.debug_mode_en				        (debug_mode_en)				                    ,


//------------------------------------------AXI MASTER INTERFACE---------------------------------


//	            		            WRITE ADDRESS CHANNEL

			.AWADDR					            (debug_axi_inst_mem_awaddr)			            ,
			.AWVALID				            (debug_axi_inst_mem_awvalid)		            ,
			.AWREADY				            (debug_axi_inst_mem_awready)		            ,
			
//			                        WRITE DATA CHANNEL

			.WDATA					            (inst_mem_debug_axi_wdata)			            ,
			.WSTRB					            (debug_axi_inst_mem_wstrb)			            ,
			.WVALID					            (inst_mem_debug_axi_wvalid)			            ,
			.WREADY					            (debug_axi_inst_mem_wready)			            ,
			
//		            	            WRITE RESPONSE CHANNEL

			.BRESP					            (inst_mem_debug_axi_bresp)			            ,
			.BVALID					            (inst_mem_debug_axi_bvalid)			            ,
			.BREADY					            (debug_axi_inst_mem_bready)			            ,
			
//	            		            READ ADDRESS CHANNEL

			.debug_ARADDR				        (debug_axi_inst_mem_araddr)			            ,
			.debug_ARVALID				        (debug_axi_inst_mem_arvalid)		            ,
			.debug_ARREADY				        (inst_mem_debug_axi_arready)		            ,
			
//	            		            READ DATA CHANNEL

			.debug_RDATA				        (inst_mem_debug_axi_rdata)			            ,
			.debug_RRESP				        (inst_mem_debug_axi_rresp)			            ,
			.debug_RVALID				        (inst_mem_debug_axi_rvalid)			            ,
			.debug_RREADY				        (debug_axi_inst_mem_rready)			            ,

//----------------------------------------------------------------------------------------------------


//------------------------------CORE READ ONLY INTERFACES----------------------------------------------

//	                                READ ADDRESS CHANNEL		                    

			.core_ARADDR				        (mmu_axi_physical_address_inst_mem)	            ,
			.core_ARVALID				        (inst_mem_req_valid)			                ,
			.core_ARREADY				        (inst_mem_core_axi_arready)			            ,
			
//			                        READ DATA CHANNEL

			.core_RDATA				            (instruction_from_mem)			                ,
			.core_RRESP				            (inst_mem_core_axi_rresp)			            ,
			.core_RVALID				        (inst_mem_core_axi_rvalid)			            ,
			.core_RREADY				        (core_axi_inst_mem_rready)		                ,

//---------------------------------------------------------------------------------------------------------

//                              FROM THE CLK RST BYASS MODULE

            .boot_en                            (boot_load_enable)                              ,

//                              FROM THE DEBUG MODULE       

            .imem_boot_valid                    (debug_inst_mem_req_valid)                      ,
            .imem_boot_we                       (debug_inst_mem_write_en)                       ,
            .imem_boot_addr                     (debug_inst_mem_address_in)                     ,
            .imem_boot_wr_data                  (debug_inst_mem_write_data)                     ,

//                                  TO THE DEBUG MODULE

            .imem_boot_rdata                    (inst_mem_debug_read_data)


			
								                )					                            ;
                                           

//------------------------------------CLOCK AND RESET BYBASS MODULE INSTANTIATION---------------------                                                

PINAKA_CLK_RST_BYPASS_TOP     clk_rst_bypass_top_instance     (


//                          FROM THE TOP MODULE INPUTS

            .rc_clk_in                          (rc_clk)                                        ,
            .xtal_clk_in                        (external_clk)                                  ,
            .pll_clk_in                         (pll_clk)                                       ,
            .por_in                             (power_on_rst)                                  ,
            .pll_lock_done_in                   (pll_lock_done)                                 ,

//                          FROM THE CLK RST CONTROLLER MODULE
            .debug_clk_in                       (core_clk)                                      ,
            .mem_clk_in                         (core_clk)                                      ,
            .debug_rst_in                       (ctrl_bypass_debug_rstn)                        ,

//                          FROM THE GPIO MODULE
            .gpio_11_in                         (gpio_boot_gpio11)                              ,
            .gpio_9_in                          (gpio_boot_gpio9)                               ,

//                          TO THE AXI SLAVE WRAPPERS MODULE

            .clk_for_mem_out                    (memory_clk)                                    ,

//                              TO THE DEBUG MODULE

            .clk_for_jtag                       (debug_clk)                                     ,
            .jtag_pulse_out                     (debug_rstn)                                    ,

//                          TO THE CLK RST CONTROLLER MODULE

            .clk_for_clk_rst_ctrl               (clk_to_clk_rst_ctrl)                           ,
            .pulse_for_clk_rst_ctrl             (rst_for_clk_ctrl)                              ,

//                          TO AXI SLAVE WRAPPERS, GPIO AND DEBUG MODULE

            .boot_en_out                        (boot_load_enable)                              
            
                                                )                                               ;

//-----------------------------------AXI MASTER WRAPPER INSTANCE OF THE DATA MEMORY------------------

axi_wrapper_top 						        #(


			.UART_START_ADDR			        (UART_MIN_ADDRESS)			                    ,
			.UART_END_ADDR				        (UART_MAX_ADDRESS)			                    ,
			
			.SPI_START_ADDR				        (SPI_MIN_ADDRESS)			                    ,
			.SPI_END_ADDR				        (SPI_MAX_ADDRESS)			                    ,
			
			.I2C_START_ADDR				        (I2C_MIN_ADDRESS)			                    ,
			.I2C_END_ADDR				        (I2C_MAX_ADDRESS)			                    ,

            .WATCHDOG_START_ADDR                (WATCHDOG_MIN_ADDRESS)                          ,
            .WATCHDOG_END_ADDR                  (WATCHDOG_MAX_ADDRESS)                          ,

            .CLK_RST_CTRL_START_ADDR            (CLK_RST_CTRL_MIN_ADDRESS)                      ,
            .CLK_RST_CTRL_END_ADDR              (CLK_RST_CTRL_MAX_ADDRESS)                      ,

			.DMEM_START_ADDR			        (DATA_MEMORY_MIN_ADDRESS)		                ,
			.DMEM_END_ADDR				        (DATA_MEMORY_MAX_ADDRESS)		                ,
	
			.IMEM_START_ADDR			        (INST_MEMORY_MIN_ADDRESS)		                ,
			.IMEM_END_ADDR				        (INST_MEMORY_MAX_ADDRESS)		                ,

            .GPIO_REG_START_ADDR                (GPIO_REG_MIN_ADDRESS)                          ,
            .GPIO_REG_END_ADDR                  (GPIO_REG_MAX_ADDRESS)                          ,

            .TOP_REG_START_ADDR                 (TOP_REG_MIN_ADDRESS)                           ,
            .TOP_REG_END_ADDR                   (TOP_REG_MAX_ADDRESS)   

								                )	


		axi_master_wrapper_data_mem_instance    (

//                          FROM THE CLK RST CONTROLLER MODULE

			.clk					            (core_clk)					                    ,
			.rst_n					            (core_rstn)					                    ,

//                      THIS SIGNAL SELECT THE MASTER, 0 FOR CORE AND 1 FOR THE DEBUG MODULE

			.master_select				        (axi_master_select)				                ,

//                              TO THE TOP REGISTER MODULE

            .illegal_address                    (req_data_mem_address_decode_error)             ,
			
//                          REQUEST VALID SIGNAL USING GLUE LOGIC

			.core_valid				            (axi_data_mem_req_valid)			            ,

//						        FROM THE MMU MODULE

			.core_addr				            (mmu_axi_physical_address_data_mem)			    ,

//                                  FROM THE CORE

			.core_write_en				        (core_mmu_axi_mem_write_en)			            ,
			.core_read_en				        (core_mmu_axi_mem_read_en)			            ,
			.core_awsize				        (core_axi_awsize)			                    ,
			.core_wdata				            (mem_write_data_core)			                ,
			.core_byte_en				        (core_axi_wstrobe)				                ,

//                              USED FOR THE GLUE LOGIC 

			.core_read_data				        (axi_core_mem_read_data)		                ,
			.core_read_resp				        (axi_core_rresp)			                    ,
			.core_read_valid_out			    (axi_core_rvalid) 			                    ,
			.core_read_ready_out			    (axi_core_rready) 			                    ,

			.core_write_ready_out			    (axi_core_bready)			                    ,
			.core_write_valid_out			    (axi_core_bvalid) 			                    ,
			.core_write_resp			        (axi_core_bresp)			                    ,

//                              FROM THE DEBUG MODULE   

  			.jtag_addr				            (debug_axi_address_in) 				            ,
   		 	.jtag_read_en				        (debug_axi_read_en)				                ,
   		 	.jtag_write_en				        (debug_axi_write_en) 			                ,   
   		 	.jtag_valid				            (debug_axi_req_valid)			                ,
			.jtag_awsize				        (debug_axi_awsize)				                ,
   		 	.jtag_wdata				            (debug_axi_write_data)			                ,
   		 	.jtag_byte_en				        (debug_axi_byte_en)				                ,

//                              TO THE DEBUG MODULE

   		 	.jtag_read_data				        (axi_debug_read_data)			                ,
   		 	.jtag_read_resp				        (axi_debug_read_resp)			                ,
   		 	.jtag_write_resp			        (axi_debug_write_resp)			                ,
   		 	.jtag_read_valid_out			    (axi_debug_read_valid)			                ,
   		 	.jtag_read_ready_out			    (axi_debug_read_ready)			                ,
   		 	.jtag_write_valid_out			    (axi_debug_write_valid)			                ,
   		 	.jtag_write_ready_out			    (axi_debug_write_ready)			                ,

			
//--------------------------------AXI-ABP BRIDGE INTERFACE-----------------------------------		


//						        WRITE ADDRESS CHANNEL
			
			.bg_axi_awaddr				        (axi_bridge_awaddr)				                ,
			.bg_axi_awvalid				        (axi_bridge_awvalid)		    	            ,
			.bg_axi_awready				        (bridge_axi_awready)			                ,
						
//						        WRITE DATA CHANNEL
			
			.bg_axi_wdata				        (axi_bridge_wdata)				                ,
			.bg_axi_wstrb				        (axi_bridge_wstrb)				                ,
			.bg_axi_wvalid				        (axi_bridge_wvalid)				                ,
			.bg_axi_wready				        (bridge_axi_wready)				                ,
			
//						        WRITE RESPONSE CHANNEL
			
			.bg_axi_bresp				        (bridge_axi_bresp)				                ,
			.bg_axi_bvalid				        (bridge_axi_bvalid)				                ,
			.bg_axi_bready				        (axi_bridge_bready)				                ,
			
//						        READ ADDRESS CHANNEL
			
			.bg_axi_araddr				        (axi_bridge_araddr)				                ,
			.bg_axi_arvalid				        (axi_bridge_arvalid)			                ,
			.bg_axi_arready				        (bridge_axi_arready)			                ,
			
//						        READ DATA CHANNEL
			
			.bg_axi_rdata				        (bridge_axi_rdata)				                ,
			.bg_axi_rresp				        (bridge_axi_rresp)				                ,
			.bg_axi_rvalid				        (bridge_axi_rvalid)				                ,
			.bg_axi_rready				        (axi_bridge_rready)				                ,


//-------------------------------AXI SLAVE WRAPPER OF DATA MEMORY INTERFACE--------------------

//						        WRITE ADDRESS CHANNEL
			
			.dm_axi_awaddr				        (axi_data_mem_awaddr)			                ,
			.dm_axi_awvalid				        (axi_data_mem_awvalid)			                ,
			.dm_axi_awready				        (data_mem_axi_awready)			                ,
			.dm_axi_awsize				        (common_awsize)				                    ,
			
//						        WRITE DATA CHANNEL
			
			.dm_axi_wdata				        (axi_data_mem_wdata)			                ,   
			.dm_axi_wstrb				        (axi_data_mem_wstrb)			                ,
			.dm_axi_wvalid				        (axi_data_mem_wvalid)			                ,
			.dm_axi_wready				        (data_mem_axi_wready)			                ,
			
//						        WRITE RESPONSE CHANNEL
			
			.dm_axi_bresp				        (data_mem_axi_bresp)			                ,
			.dm_axi_bvalid				        (data_mem_axi_bvalid)			                ,
			.dm_axi_bready				        (axi_data_mem_bready)			                ,
			
//					            READ ADDRESS CHANNEL
			
			.dm_axi_araddr				        (axi_data_mem_araddr)			                ,
			.dm_axi_arvalid				        (axi_data_mem_arvalid)			                ,
			.dm_axi_arready				        (data_mem_axi_arready)			                ,
			
//						        READ DATA CHANNEL
			
			.dm_axi_rdata				        (data_mem_axi_rdata)			                ,
			.dm_axi_rresp				        (data_mem_axi_rrsep)			                ,
			.dm_axi_rvalid				        (data_mem_axi_rvalid)			                ,
			.dm_axi_rready				        (axi_data_mem_rready)			                ,


//----------------------------AXI SLAVE WRAPPER OF INSTRUCTION MEMORY INTERFACE---------------------


//                              WRITE ADDRESS CHANNEL

			.im_axi_awaddr				        (debug_axi_inst_mem_awaddr)			            ,
			.im_axi_awvalid				        (debug_axi_inst_mem_awvalid)		            ,
			.im_axi_awready				        (debug_axi_inst_mem_awready)		            ,
						
//                              WRITE DATA CHANNEL

			.im_axi_wdata				        (inst_mem_debug_axi_wdata)			            ,
			.im_axi_wstrb				        (debug_axi_inst_mem_wstrb)			            ,
			.im_axi_wvalid				        (inst_mem_debug_axi_wvalid)			            ,
			.im_axi_wready				        (debug_axi_inst_mem_wready)			            ,
			
//          			        WRITE RESPONSE CHANNEL

			.im_axi_bresp				        (inst_mem_debug_axi_bresp)			            ,
			.im_axi_bvalid				        (inst_mem_debug_axi_bvalid)			            ,
			.im_axi_bready				        (debug_axi_inst_mem_bready)			            ,
			
//          	                READ ADDRESS CHANNEL

			.im_axi_araddr				        (debug_axi_inst_mem_araddr)			            ,
			.im_axi_arvalid				        (debug_axi_inst_mem_arvalid)		            ,
			.im_axi_arready				        (inst_mem_debug_axi_arready)		            ,
			
//          			        READ DATA CHANNEL

			.im_axi_rdata				        (inst_mem_debug_axi_rdata)			            ,
			.im_axi_rresp				        (inst_mem_debug_axi_rresp)			            ,
			.im_axi_rvalid				        (inst_mem_debug_axi_rvalid)			            ,
			.im_axi_rready				        (debug_axi_inst_mem_rready)			

	
								                )					                            ;


//-------------------------------AXI SLAVE WRAPPER WITH DATA MEMORY INSTANCE---------------------


axi_datamem_wrapper						        #(

			.DATA_MEMORY_ADDR_WIDTH				(DATA_MEMORY_ADDR_WIDTH)		

								                )
		

			axi_slave_wrapper_data_mem_instance	(


//                          FROM THE CLK RST BYPASS MODULE

			.ACLK					            (memory_clk)					                ,

//                          FROM THE CLK RST CONTROLLER MODULE

			.ARESETN				            (core_rstn)					                    ,
			
//----------------------------------AXI INTERFACE------------------------------------------------

//                          WRITE ADDRESS CANNEL

			.AWADDR					            (axi_data_mem_awaddr)			                ,
			.AWVALID				            (axi_data_mem_awvalid)			                ,
			.AWREADY				            (data_mem_axi_awready)			                ,
			
//			                WRITE DATA CHANNEL
    
			.WDATA					            (axi_data_mem_wdata)			                ,
			.WSTRB					            (axi_data_mem_wstrb)			                ,
			.WVALID					            (axi_data_mem_wvalid)			                ,
			.WREADY					            (data_mem_axi_wready)			                ,
			
//              		    WRITE RESPONSE CHANNEL

			.BRESP					            (data_mem_axi_bresp)			                ,
			.BVALID					            (data_mem_axi_bvalid)			                ,
			.BREADY					            (axi_data_mem_bready)			                ,
			
//              	        READ ADDRESS CHANNEL

			.ARADDR					            (axi_data_mem_araddr)			                ,
			.ARVALID				            (axi_data_mem_arvalid)			                ,
			.ARREADY				            (data_mem_axi_arready)			                ,
			
//              	        READ DATA CHANNEL

			.RDATA					            (data_mem_axi_rdata)			                ,
			.RRESP					            (data_mem_axi_rrsep)			                ,
			.RVALID					            (data_mem_axi_rvalid)			                ,
			.RREADY					            (axi_data_mem_rready)                           ,

//                          FROM THE CLK RST BYPASS MODULE

            .boot_en                            (boot_load_enable)                              ,

//                          FROM THE DEBUG MODULE

            .dmem_boot_valid                    (debug_data_mem_req_valid)                      ,
            .dmem_boot_we                       (debug_data_mem_write_en)                       ,
            .dmem_boot_addr                     (debug_data_mem_address_in)                     ,
            .dmem_boot_wr_data                  (debug_data_mem_write_data)                     ,
            .dmem_boot_rdata                    (data_mem_debug_read_data)                      
			

							                	)                                               ;


//--------------------------------------AXI_TO_APB BRIDGE INSTANCE---------------------------------------

top_bridge 							            #(

			.FIFO_DEPTH				            (BRIDGE_FIFO_DEPTH)			                    ,
			.ADDR_WIDTH				            (AXI_ADDR_WIDTH)			                    ,
			.DATA_WIDTH				            (AXI_DATA_WIDTH)			                    ,
			.STRB_WIDTH				            (STROBE_WIDTH)				                    ,
			.FIFO_WIDTH				            (BRIDGE_FIFO_WIDTH) 			                ,
			.TIMEOUT_CNT_WIDTH			        (APB_TIMEOUT_COUNT_WIDTH)		                ,
			.TIMEOUT_VALUE				        (APB_TIMEOUT_VALUE)			

								                )
	
			axi2apb_instance			        (

//                      FROM THE CLK RST CONTROLLER MODULE

			.pclk				            	(pclk)					                        ,
			.aclk					            (core_clk)					                    ,
			.resetn					            (core_rstn)					                    ,
			
//--------------------------------------AXI INTERFACE SIGNALS--------------------------------- 


//                              WRITE ADDRESS CHANNEL

			.awvalid				            (axi_bridge_awvalid)			                ,
			.awaddr					            (axi_bridge_awaddr)				                ,
			.awlen					            (8'd0)					                        ,
			.awsize					            (common_awsize)				                    ,
			.awburst				            (FIXED)					                        ,
			.awready				            (bridge_axi_awready)			                ,
			
//			                    WRITE DATA CHANNEL
			            
			.wvalid					            (axi_bridge_wvalid)				                ,
			.wdata					            (axi_bridge_wdata)				                ,
			.wstrb					            (axi_bridge_wstrb)				                ,
			.wlast					            (1'd1)					                        ,
			.wready					            (bridge_axi_wready)				                ,
			
//          			        WRITE RESPONSE CHANNEL 
    
			.bready					            (axi_bridge_bready)				                ,
			.bresp					            (bridge_axi_bresp)				                ,
			.bvalid					            (bridge_axi_bvalid)				                ,
			
//          			        READ ADDRESS CHANNEL

			.arvalid				            (axi_bridge_arvalid)			                ,
			.araddr					            (axi_bridge_araddr)				                ,
			.arlen					            (8'd0)					                        ,
			.arsize					            (3'b010)				                        ,
			.arburst				            (FIXED)					                        ,
			.arready				            (bridge_axi_arready)			                ,
			
//			                    READ DATA CHANNEL 

			.rready					            (axi_bridge_rready)				                ,
			.rvalid					            (bridge_axi_rvalid)				                ,
			.rdata					            (bridge_axi_rdata)				                ,
			.rresp					            (bridge_axi_rresp)				                ,
			.rlast					            ()				                                ,
			
//              	            APB INTERFACE 


			.pwdata					            (bridge_peripheral_pwdata)				        ,
			.penable				            (bridge_peripheral_penable)			            ,
			.pwrite					            (bridge_peripheral_pwrite)				        ,

//                              TO THE APB PSEL SLAVE WRAPPER MODULE

			.psel					            (bridge_peripheral_psel)				        ,
			.paddr					            (bridge_peripheral_paddr)				        ,

//                              FROM THE APB PSEL SLAVE WRAPPER MODULE

			.pready					            (peripheral_bridge_pready)				        ,
			.prdata					            (peripheral_bridge_prdata)				        ,
			.pslverr				            (peripheral_bridge_pslverr)


								                )					                            ;


//------------------------------------PERIPHERAL PSEL WRAPPER INSTANCE---------------------------------------

apb_slave_psel_wrapper						    #(

			.I2C_MIN_ADDRESS			        (I2C_MIN_ADDRESS) 			                    ,
			.I2C_MAX_ADDRESS			        (I2C_MAX_ADDRESS) 			                    ,
			.SPI_MIN_ADDRESS			        (SPI_MIN_ADDRESS) 			                    ,
			.SPI_MAX_ADDRESS			        (SPI_MAX_ADDRESS) 			                    ,
			.UART_MIN_ADDRESS			        (UART_MIN_ADDRESS)			                    ,
			.UART_MAX_ADDRESS			        (UART_MAX_ADDRESS)                              ,
            .WATCHDOG_MIN_ADDRESS               (WATCHDOG_MIN_ADDRESS)                          ,
            .WATCHDOG_MAX_ADDRESS               (WATCHDOG_MAX_ADDRESS)                          ,
            .CLK_RST_CTRL_MIN_ADDRESS           (CLK_RST_CTRL_MIN_ADDRESS)                      ,
            .CLK_RST_CTRL_MAX_ADDRESS           (CLK_RST_CTRL_MAX_ADDRESS)                      ,
            .TOP_REG_MAX_ADDRESS                (TOP_REG_MAX_ADDRESS)                           ,
            .TOP_REG_MIN_ADDRESS                (TOP_REG_MIN_ADDRESS)                           ,
            .GPIO_REG_MAX_ADDRESS               (GPIO_REG_MAX_ADDRESS)                          ,
            .GPIO_REG_MIN_ADDRESS               (GPIO_REG_MIN_ADDRESS)          


								                )

			apb_wrapper_instance			    (

//                          FROM THE AXI-APB BRIDGE MODULE

			.psel					            (bridge_peripheral_psel)				        ,
			.paddr					            (bridge_peripheral_paddr) 				        ,

//                          TO THE AXI_APB BRIDGE MODULE

			.pready					            (peripheral_bridge_pready) 			            ,
			.pslverr				            (peripheral_bridge_pslverr) 			        ,
			.prdata					            (peripheral_bridge_prdata) 			            ,

//                          PRDATA SIGNALS FROM DIFFERENT PERIPHERALS

			.I2C_prdata				            (i2c_prdata) 				                    ,
			.SPI_prdata				            (spi_prdata)				                    ,
			.UART_prdata				        (uart_prdata)				                    ,
            .watchdog_prdata                    (watchdog_prdata)                               ,
            .clk_rst_ctrl_prdata                (clk_rst_ctrl_prdata)                           ,
            .top_reg_prdata                     (top_reg_prdata)                                ,
            .gpio_reg_prdata                    (gpio_reg_prdata)                               ,

//                          PREADY SIGNALS FROM DIFFERENT PERIPHERALS    

			.I2C_pready				            (i2c_pready)				                    ,
			.SPI_pready				            (spi_pready) 				                    ,
			.UART_pready				        (uart_pready)				                    ,
            .watchdog_pready                    (watchdog_pready)                               ,
            .clk_rst_ctrl_pready                (clk_rst_ctrl_pready)                           ,
            .top_reg_pready                     (top_reg_pready)                                ,
            .gpio_reg_pready                    (gpio_reg_pready)                               ,

//                          PSLVERR SIGNALS FROM DIFFERENT PERIPHERALS     

			.I2C_pslverr				        (i2c_pslverr) 				                    ,
			.SPI_pslverr				        (spi_pslverr) 				                    ,
			.UART_pslverr				        (uart_pslverr) 				                    ,
            .watchdog_pslverr                   (watchdog_pslverr)                              ,
            .clk_rst_ctrl_pslverr               (clk_rst_ctrl_pslverr)                          ,
            .top_reg_pslverr                    (top_reg_pslverr)                               ,
            .gpio_reg_pslverr                   (gpio_reg_pslverr)                              ,

//                          PSEL SIGNALS TO DIFFERENT PERIPHERALS  

			.I2C_psel				            (i2c_psel) 				                        ,
			.SPI_psel				            (spi_psel) 				                        ,
			.UART_psel				            (uart_psel)                                     ,
            .watchdog_psel                      (watchdog_psel)                                 ,
            .clk_rst_ctrl_psel                  (clk_rst_ctrl_psel)                             ,
            .top_reg_psel                       (top_reg_psel)                                  ,
            .gpio_reg_psel                      (gpio_reg_psel)     


								                )	                                            ;


//------------------------------------I2C WITH APB INTERFACE INSTANCE---------------------------------------

i2c_wrapper 							        #(

			.ADDR_WIDTH				            (I2C_ADDR_WIDTH)			                    ,
  			.DATA_WIDTH				            (I2C_DATA_WIDTH)

								                )

			i2c_wrapper_instance			    (		
						

//              	        FROM THE CLK RST CONTROLLER MODULE

   			.pclk					            (pclk)					                        ,
    		.presetn				            (presetn)					                    ,

//                          FROM THE AXI-APB BRIDGE MODULE

    		.paddr					            (bridge_peripheral_paddr[I2C_ADDR_WIDTH-1:0])	,
            .penable				            (bridge_peripheral_penable)			            ,
   			.pwrite					            (bridge_peripheral_pwrite)				        ,
   			.pwdata					            (bridge_peripheral_pwdata[I2C_DATA_WIDTH-1:0])	,

//                         FROM THE APB PSEL SLAVE WRAPPER MODULE

    		.psel					            (i2c_psel)				                        ,

//                          TO THE APB PSEL SLAVE WRAPPER MODULE

   			.prdata					            (i2c_prdata)				                    ,
  		    .pready					            (i2c_pready)				                    ,
    		.pslverr				            (i2c_pslverr)				                    ,

//      			        FROM GPIO PINMUX MODULE
      				    
            .sda_in                             (i2c_sda_in)                                    ,

//                          TO GPIO PINMUX MODULE

            .scl					            (i2c_scl)                                       ,
		    .sda_out					        (i2c_sda_out)				                    , 
            .sda_en                             (i2c_sda_oe)    
			

								                )                                               ;


//--------------------------------------SPI WITH APB SLAVE INSTANCE---------------------------------------


spi_wrapper 							        #(

			.ADDR_WIDTH				            (SPI_ADDR_WIDTH)			                    ,
			.DATA_WIDTH				            (SPI_DATA_WIDTH)			                    ,
			.CLK_DIV				            (SPI_CLK_DIV)

								                )

			spi_wrapper_instance			    (


//          		            FROM THE CLK RST CONTROLLER MODULE

			.pclk					            (pclk)					                        ,
			.presetn				            (presetn)					                    ,

//                              FROM THE AXI-APB BRIDGE MODULE

			.paddr					            (bridge_peripheral_paddr[SPI_ADDR_WIDTH-1:0])	,
			.penable				            (bridge_peripheral_penable)			            ,
			.pwrite					            (bridge_peripheral_pwrite)				        ,
			.pwdata					            (bridge_peripheral_pwdata[SPI_DATA_WIDTH-1:0])	,

//                              FROM THE APB PSEL SLAVE WRAPPER MODULE

			.psel					            (spi_psel)				                        ,

//                              TO THE APB PSEL SLAVE WRAPPER MODULE

			.prdata					            (spi_prdata)				                    ,
			.pready					            (spi_pready)				                    ,
			.pslverr				            (spi_pslverr)				                    ,

//              			    FROM THE GPIO PINMUX MODULE
              			
			.miso					            (spi_miso)				                        ,

//                              TO THE GPIO PINMUX MODULE

			.mosi					            (spi_mosi)				                        ,
			.sclk					            (spi_sclk)				                        ,
			.ss					                (spi_ss)

								                )					                            ;


//---------------------------------UART WITH APB SLAVE INSTANCE---------------------------------------

uart_top 	uart_wrapper_instance			    (

//                          FROM THE CLK RST CONTROLLER MODULE

			.pclk					            (pclk)					                        ,         
			.presetn				            (presetn)					                    ,

//                          FROM THE AXI-APB BRIDGE MODULE

			.paddr					            (bridge_peripheral_paddr[7:0])	                ,
			.penable				            (bridge_peripheral_penable) 			        ,
			.pwrite					            (bridge_peripheral_pwrite)				        ,
			.pwdata					            (bridge_peripheral_pwdata[7:0])	                ,

//                          FROM THE APB PSEL SLAVE WRAPPER MODULE

			.psel					            (uart_psel)				                        ,

//                          TO THE APB PSEL SLAVE WRAPPER MODULE

			.prdata					            (uart_prdata)				                    ,
			.pready					            (uart_pready)				                    ,
			.pslverr				            (uart_pslverr)                                  ,

//                          FROM THE GPIO PINMUX MODULE

            .rx					                (uart_rx)				                        ,

//                          TO THE GPIO PINMUX MODULE

			.tx_out					            (uart_tx)				                        

								                )			                            		;


//----------------------------------WATCHDOG TIMER MODULE INSTANTIATION--------------------------  


watchdog_timer  watchdog_timer_instance         (
    

//                      FROM THE CLK RST CONTROLLER MODULE

            .pclk                               (pclk)                                          ,
            .presetn                            (presetn)                                       ,

//                      FROM THE AXI-APB BRIDGE MODULE

            .penable                            (bridge_peripheral_penable)                     ,
            .pwrite                             (bridge_peripheral_pwrite)                      ,
            .paddr                              (bridge_peripheral_paddr[7:0])                  ,
            .pwdata                             (bridge_peripheral_pwdata)                      ,

//                      FROM THE APB PSEL SLAVE WRAPPER MODULE

            .psel                               (watchdog_psel)                                 ,

//                      TO THE APB PSEL SLAVE WRAPPER MODULE

            .prdata                             (watchdog_prdata)                               ,
            .pready                             (watchdog_pready)                               ,
            .pslverr                            (watchdog_pslverr)                              ,

//                          WATCHDOG CLK AND RST SIGNALS

            .wdt_clk                            (rc_clk)      ,
            .wdt_rstn                           (core_rstn)      ,


//                              FROM THE CORE 

            .cpu_dbg_halt                       (debug_mode_en)                                 ,
            .cpu_commit_pc                      (last_commited_pc)                              ,

//                              TIED TO CONSTANT AS OF KNOW

            .dbg_freeze                         (debug_watchdog_freeze)                         ,
            .cpu_commit_valid                   (core_watchdog_commit_valid)                    ,

//                              UNCONNECTED OUTPUT PORTS

            .wdt_reset                          ()      ,    
            .wdt_timeout                        ()      ,
            .reset_scope                        ()

                                                )                                               ;
                       

//------------------------------------GPIO PINMUX INSTANTIATION--------------------------  


gpio_top_regfile    gpio_top_reg_instance       (
    
     
//                      FROM THE CLK RST CONTROLLER MODULE

            .pclk                               (pclk)                                          ,
            .presetn                            (boot_load_enable)                                       ,   

//                      FROM THE AXI-APB BRIDGE MODULE

            .paddr                              (bridge_peripheral_paddr[7:0])                  ,
            .pwrite                             (bridge_peripheral_pwrite)                      ,
            .pwdata                             (bridge_peripheral_pwdata)                      ,            
            .penable                            (bridge_peripheral_penable)                     ,

//                      FROM THE APB PSEL SLAVE WRAPPER MODULE

            .psel                               (gpio_reg_psel)                                 ,   

//                      TO THE APB PSEL SLAVE WRAPPEER MODULE

            .prdata                             (gpio_reg_prdata)                               ,
            .pready                             (gpio_reg_pready)                               ,
            .pslverr                            (gpio_reg_pslverr)                              ,

//                              GPIO PINS TO TOP INOUT PORTS

            .gpio_out0                          (GPIO0)                                         ,
            .gpio_out1                          (GPIO1)                                         , 
            .gpio_out2                          (GPIO2)                                         ,
            .gpio_out3                          (GPIO3)                                         ,
            .gpio_out4                          (GPIO4)                                         ,
            .gpio_out5                          (GPIO5)                                         ,
            .gpio_out6                          (GPIO6)                                         ,
            .gpio_out7                          (GPIO7)                                         ,
            .gpio_out8                          (GPIO8)                                         ,
            .gpio_out9                          (GPIO9)                                         ,
            .gpio_out10                         (GPIO10)                                        ,
            .gpio_out11                         (GPIO11)                                        ,
            .gpio_out12                         (GPIO12)                                        ,
            .gpio_out13                         (GPIO13)                                        ,
            .gpio_out14                         (GPIO14)                                        ,
            .gpio_out15                         (GPIO15)                                        ,
            .gpio_out16                         (GPIO16)                                        ,

//                          TO THE CLK RST CONTROLLER MODULE

            .pll_clk_fail_out                   (gpio_boot_gpio9)                               ,
            .rc_clk_fail_out                    ()      ,
            .boot_load_done_out                 (gpio_boot_gpio11)                              ,

//                          FROM THE UART PERIPHERAL 

            .uart_tx_w                          (uart_tx)                                       ,

//                          FROM THE SPI PERIPHERAL
            .spi_cs_w                           (spi_ss)                                        ,
            .spi_clk_w                          (spi_sclk)                                      ,
            .spi_mosi_w                         (spi_mosi)                                      ,
            
//                          FROM THE I2C PERIPHERAL

            .i2c_scl_w                          (i2c_scl)                                       ,
            .i2c_sda_out_w                      (i2c_sda_out)                                   ,
            .i2c_sda_oe_w                       (i2c_sda_oe)                                    ,

//                          TO THE UART PERIPHERAL

            .uart_rx_w                          (uart_rx)                                       ,

//                          TO THE SPI PERIPHERAL

            .spi_miso_w                         (spi_miso)                                      ,

//                          TO THE I2C PERIPHERAL

            .i2c_sda_in_w                       (i2c_sda_in)                                    ,

//                          UNCONNECTED PORTS

            .clk_out_w                          ()      ,     
            .debug_w                            ()      ,
            
            .atclk_w                            ()      ,
            .atvalid_w                          ()      ,
            .atready_w                          ()      ,
            .atsync_w                           ()      ,
            .atid_w                             ()      ,
            .atdata_w                           ()      ,

            .irq_in_w                           ()      ,
            
            .gpio_pullup_out_w                  ()      , 
            .gpio_pulldown_out_w                ()      ,
            .gpio_opendrain_out_w               ()      ,
                  
            .gpio_schmitt_out_w                 ()      ,
                   
            .gpio_drv0_out_w                    ()      ,
            .gpio_drv1_out_w                    ()      ,
                   
            .gpio_int_en_out_w                  ()      ,
            .gpio_int_status_out_w              ()      ,
                   
            .gpio_rise_en_out_w                 ()      ,
            .gpio_fall_en_out_w                 ()      ,
                   
            .gpio_high_en_out_w                 ()      ,
            .gpio_low_en_out_w                  ()      ,
                   
            .gpio_lock_out_w                    ()      ,
            .debug_sel_out_w                    () 
    
                                                )                                               ;


//------------------------------------TOP REGISTER INSTANTIATION-------------------------------


top_register        top_register_instance       (

//                              FROM THE CLK RST CONTROLLER MODULE

            .pclk                               (pclk)                                          ,
            .presetn                            (presetn)                                       ,

//                              FROM THE AXI-APB BRIDGE MODULE

            .paddr                              (bridge_peripheral_paddr[7:0])                  ,
            .penable                            (bridge_peripheral_penable)                     ,
            .pwrite                             (bridge_peripheral_pwrite)                      ,
            .pwdata                             (bridge_peripheral_pwdata)                      ,

//                              FROM THE APB PSEL SLAVE WRAPPER MODULE

            .psel                               (top_reg_psel)                                  ,

//                              TO THE APB PSEL SLAVE WRAPPER MODULE 

            .prdata                             (top_reg_prdata)                                ,
            .pready                             (top_reg_pready)                                ,
            .pslverr                            (top_reg_pslverr)                               ,

//                              FROM THE MMU MODULE

            .ptw_timeout_event                  (mmu_ptw_timeout)                               ,
            .instr_page_fault                   (inst_page_fault)                               ,
            .mem_page_fault                     (mem_page_fault)                                ,
            .instr_permission_fault             (instruction_execute_permission_fault)          ,
            .read_permission_fault              (mem_read_permission_fault)                     ,
            .write_permission_fault             (mem_write_permission_fault)                    ,
            .error_addr                         (mmu_axi_physical_address_data_mem)             ,
            .instr_error_pc                     (mmu_axi_physical_address_inst_mem)             , 

//                              TO THE MMU MODULE

            .pre_fetch_en                       (mmu_prefetch_enable)                           ,
            .mmu_timeout_enable                 (mmu_ptw_timeout_enable)                        ,
            
//                              MEMORIES FAULTS SIGNALS FROM GLUE LOGIC

            .instr_mem_addr_decode_error        (inst_mem_addr_decode_error)                    ,            
            .mem_addr_decode_error              (req_data_mem_address_decode_error)             ,
            .mem_addr_read_slverr               (data_mem_read_addr_slverr)                     ,
            .mem_addr_write_slverr              (data_mem_write_addr_slverr)                    


                                                )                                               ;


//---------------------------------CLOCK RESET CONTROLLER TOP INSTANTIATION-----------------------


top_clk_rst_ctrl                                #(

            .RATIO                              (CLK_RST_CTRL_RATION)   

                                                )
                                                
            clk_rst_ctrl_top_instance           (

//                      FROM THE CLK RST CONTROLLER MODULE

            .pclk_i                             (pclk)                                          ,
            .presetn_i                          (presetn)                                       ,

//                      FROM THE AXI-APB BRIDGE MODULE

            .paddr_i                            (bridge_peripheral_paddr[7:0])                  ,
            .penable_i                          (bridge_peripheral_penable)                     ,
            .pwrite_i                           (bridge_peripheral_pwrite)                      ,
            .pwdata_i                           (bridge_peripheral_pwdata)                      ,

//                      FROM THE APB PSEL SLAVE WRAPPER MODULE

            .psel_i                             (clk_rst_ctrl_psel)                             ,

//                      TO THE APB PSEL SLAVE WRAPPER MODULE

            .prdata_o                           (clk_rst_ctrl_prdata)                           ,
            .pready_o                           (clk_rst_ctrl_pready)                           ,
            .pslverr_o                          (clk_rst_ctrl_pslverr)                          ,

//                      FROM THE CLK RST BYPASS MODULE

            .sys_clk_i                          (clk_to_clk_rst_ctrl)                           ,
            .por_ni                             (rst_for_clk_ctrl)                              ,
            
//                          FROM THE CORE 

            .debug_clksel_i                     (debug_mode_en)                                 ,

            
//                  CLK AND RST TO THE CORE AND OTHER CORE RELATED MODULES  

            .clk_soc_o                          (core_clk)                                      ,
            .rstn_soc_sync_o                    (core_rstn)                                     ,

//                  CLK AND RST TO THE PERIPHERALS AND RELATED MODULES

            .clk_per_o                          (pclk)                                          ,                 
            .rstn_peripheral_sync_o             (presetn)                                       ,   

//                  TO THE CLK RST BYPASS MODULE

            .rstn_debug_sync_o                  (ctrl_bypass_debug_rstn)                        ,

//              DFT PURPOSE SIGNALS, AS OF KNOW TIED TO 0'S

            .test_mode_soc_rst_i                (1'd0)      ,   
            .test_mode_peripheral_rst_i         (1'd0)      ,   
            
            .test_mode_debug_rst_i              (1'd0)      ,   
            .test_mode_clk_peripheral_mux_i     (1'd0)      ,   
            .test_mode_clk_soc_mux_i            (1'd0)      ,   
            
            .test_mode_en_peripheral_mux_i      (1'd0)      ,   
            .test_mode_en_soc_mux_i             (1'd0)      ,   
            .test_mode_div_peripheral_i         (1'd0)      ,   
            
            .test_mode_div_debug_i              (1'd0)      


                                                )                                               ;
      
                                                
//----------------------------------DEBUG MODULE INSTANTIATION--------------------------------

debug_module		                            #(

            .PTE_START_ADDR                     (PTE_MIN_ADDRESS)                               ,
            .PTE_END_ADDR                       (PTE_MAX_ADDRESS)                               ,
            .IMEM_START_ADDR                    (INST_MEMORY_MIN_ADDRESS)                       ,
            .IMEM_END_ADDR                      (INST_MEMORY_MAX_ADDRESS)                       ,
            .DMEM_START_ADDR                    (DATA_MEMORY_MIN_ADDRESS)                       ,
            .DMEM_END_ADDR                      (DATA_MEMORY_MAX_ADDRESS)

                                                ) 

                    debug_module_instance		(

//                          FROM THE TOP INPUTS

			.tck					            (TCK)                                           ,
			.trst_n					            (TRSTN)                                         ,
			.tms					            (TMS)                                           ,
			.tdi					            (TDI)                                           ,

//                          TO THE TOP OUTPUT

			.tdo					            (TDO)                                           ,
			
//                      FROM THE CLK RST BYPASS MODULE

			.dbg_clk				            (debug_clk)                                     ,
            .boot_load_enable                   (boot_load_enable)                              ,

//                      FROM THE CLK RST CONTROLLER MODULE

			.clk					            (core_clk)                                      ,
			.rst_n					            (core_rstn)                                     ,
			.dbg_resetn				            (debug_rstn)                                    ,

//                      FROM THE PTE MEMORY WRAPPER MODULE 
                          
			.pte_read_data_out			        (pte_debug_read_data)                           ,
			.pte_read_resp				        (pte_debug_read_resp)                           ,
			.pte_write_resp				        (pte_debug_write_resp)                          , 
			.pte_read_valid                     (pte_debug_read_valid)                          ,
            .pte_write_valid                    (pte_debug_write_valid)                         ,

//                      TO THE PTE MEMORY WRAPPER MODULE

            .pte_valid                          (debug_pte_valid_in)                            ,
            .pte_write_en                       (debug_pte_write_en)                            ,
            .pte_read_en                        (debug_pte_read_en)                             ,
            .pte_address                        (debug_pte_address)                             ,
            .pte_write_data                     (debug_pte_write_data)                          ,

//                      FROM THE AXI MASTER WRAPPER MODULE
                      
            .axi_read_data_out			        (axi_debug_read_data)                           ,
			.axi_read_resp				        (axi_debug_read_resp)                           ,
			.axi_write_resp				        (axi_debug_write_resp)                          ,

//                              FROM THE GLUE LOGIC 

            .axi_read_valid                     (axi_debug_read_valid_in)                       ,
            .axi_write_valid                    (axi_debug_write_valid_in)                      ,

//                      TO THE AXI MASTER WRAPPER MODULE

            .axi_valid                          (debug_axi_req_valid)                           ,
            .axi_write_en                       (debug_axi_write_en)                            ,
            .axi_read_en                        (debug_axi_read_en)                             ,
            .axi_address                        (debug_axi_address_in)                          ,
            .axi_write_data                     (debug_axi_write_data)                          ,
            .axi_byte_enable                    (debug_axi_byte_en)                             ,

//                      FROM THE AXI SLAVE WRAPPER OF INSTRUCTION MEMORY MODULE
                      
            .imem_read_data                     (inst_mem_debug_read_data)                      ,

//                      TO THE AXI SLAVE WRAPPER OF INSTRUCTION MEMORY MODULE

            .imem_valid                         (debug_inst_mem_req_valid)                      ,
            .imem_write_en                      (debug_inst_mem_write_en)                       ,
            .imem_address                       (debug_inst_mem_address_in)                     ,
            .imem_write_data                    (debug_inst_mem_write_data)                     ,

//                      FROM THE AXI SLAVE WRAPPER OF DATA MEMORY MODULE
                      
            .dmem_read_data                     (data_mem_debug_read_data)                      ,

//                      TO THE AXI SLAVE WRAPPER OF DATA MEMORY MODULE

            .dmem_valid                         (debug_data_mem_req_valid)                      ,
            .dmem_write_en                      (debug_data_mem_write_en)                       ,
            .dmem_address                       (debug_data_mem_address_in)                     ,
            .dmem_write_data                    (debug_data_mem_write_data)                     ,

//                                  TO THE CORE

			.pb_insn_valid				        (debug_core_pb_valid)                           ,
			.pb_insn				            (debug_core_pb_instruction)                     ,
            .haltreq                            (debug_core_halt_request)                       ,
            .resethaltreq                       (debug_core_reset_halt)                         ,
            .resumereq                          (debug_core_resume_req)                         ,

//                                  FROM THE CORE 

			.hart_halted				        (core_debug_hart_halted)                        ,
			.hart_reset				            (core_debug_hart_reset)                         ,

//                                 TO THE CSR MODULE 

            .ndmreset                           (debug_csr_ndm_reset)                           ,
			.dbg_reg_write				        (debug_csr_write_en)                            ,
			.dbg_reg_wdata				        (debug_csr_write_data)                          ,

//                              TO THE CSR AND GPR(CORE) MODULE

			.dbg_reg_read				        (debug_csr_gpr_read_en)                         ,
			.dbg_reg_addr				        (debug_csr_gpr_address)                         ,

//                      FROM THE GLUE LOGIC SELECT WHICH VALID AND DATA FROM CSR AND GPR

			.dbg_reg_rdata				        (csr_gpr_debug_read_data)                       ,
			.dbg_reg_ready				        (csr_gpr_debug_read_valid)                      


                              
                         

                                                )                                               ;

endmodule
