class ic_scb extends uvm_scoreboard;
`uvm_component_utils(ic_scb)

	uvm_analysis_imp#(ic_seq_item, ic_scb) scb_imp;
	 	 
	bit [47:0] int_enable;
	bit [47:0] int_pending;
//	bit [47:0] prev_ext_int;

	logic [7:0] high_lp;
	logic [7:0] high_lp_id;
	logic [7:0] ic_eoi_id_r;
	logic [5:0] current_active_id;      // ID currently being handled (after claim)

   	logic [7:0] zic_ack_id;             // value shown in ack register (0x0804)
   	logic [7:0] next_pending_id;	     // value shown in next pending reg (0x0800)

	logic [5:0] IRQ_ID[48];
	logic [7:0] int_lvl_pri_val[48];

	logic [7:0] latched_ack_id;
	logic       pending_ack_update;

//********MMR_Reg Implementations******
	//Configuration Register
	logic [1:0] NMBITS = 2'b00;
	logic [3:0] NLBITS = 4'b0011;
	logic	    NVBITS = 1'b1;
	logic [7:0] IC_CFG = {1'b0,NMBITS,NLBITS,NVBITS};

	//Information register
	logic [5:0] NUM_TRIG	= 6'd0	;
	logic [3:0] ZIC_INT_CTL	= 4'd6	;
	logic [3:0] ARCH_VER	= 4'd0	;
	logic [3:0] IMPL_VER	= 4'd0	;
	logic [12:0] NUM_IRQ 	= 13'd48;
	logic [31:0] IC_INFO	= {1'b0,NUM_TRIG,ZIC_INT_CTL,ARCH_VER,IMPL_VER,NUM_IRQ};

	//Constructor
	function new(string name="ic_scb", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	//Build_phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		scb_imp = new("scb_imp",this);
	endfunction

	//SCB Write Implementation
	virtual function void write (ic_seq_item item);

	logic 	     exp_interrupt_request	= 0    ;	 	 
	logic [ 7:0] exp_highest_pending_lvl_pr	= 8'h00;
	logic [ 7:0] exp_ack_int_id		= 8'h00;
	logic [31:0] exp_mmr_read_data		= 32'b0;	

	bit   [46:0] ext_int;
	int 	     index;
	logic [ 7:0] next_pending_id 		= 8'h00;   
	logic [ 7:0] next_lp 			= 8'h00;
	logic [ 5:0] next_id 			= 6'h00;

	//Interrupt IDs
	IRQ_ID='{16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63};
		
	//Interrupt Level and Priority values //zic_int_ctl[i]
	int_lvl_pri_val ='{8'b11111111, 8'b11111011, 8'b11110111, 8'b11110011, 8'b11101111, 8'b11101011, 8'b11100111, 8'b11011111, 8'b11011011, 8'b11010111,
	8'b11010011, 8'b11001111, 8'b11001011, 8'b11000111, 8'b10111111, 8'b10111011, 8'b10110111, 8'b10110011, 8'b10101111, 8'b10101011, 8'b10011111,
	8'b10011011, 8'b10010111, 8'b10010011, 8'b10001111, 8'b10001011, 8'b10000111, 8'b01111111, 8'b01111011, 8'b01110111, 8'b01110011, 8'b01101111,
	8'b01101011, 8'b01100111, 8'b01011111, 8'b01011011, 8'b01010111, 8'b01010011, 8'b01001111, 8'b01001011, 8'b01000111, 8'b00111111, 8'b00111011, 
	8'b00110111, 8'b00110011, 8'b00101111, 8'b00101011, 8'b00100111};

	//Ref. Model
	if(item.ic_rst==0) begin
		exp_ack_int_id		   ='0;		 
		exp_interrupt_request 	   = 0;	 	 
		exp_highest_pending_lvl_pr = 0;
			
		int_enable 	   = '0;
		int_pending 	   = '0;
		high_lp 	   = '0;
		high_lp_id         = 8'h00;
		ic_eoi_id_r	   = '0;
		current_active_id  = '0;
        	zic_ack_id         = '0;
	        next_pending_id    = 8'h10;
		latched_ack_id     = '0;
		pending_ack_update = 0;

	end else begin
		high_lp     = 8'h00;
	        high_lp_id  = 8'h00;

		//Update Enabling Interrupt
		for(int i=0; i<48; i++) begin
			int_enable[i] = (item.global_int_enable_valid_i	& item.global_int_enable_bit_i[i]);
		end
		`uvm_info("SCB",$sformatf("Int_Enabled:0x%h",int_enable),UVM_LOW)

		//Combine External Interrupts
		ext_int = '{/*item.ext_int47_i, */item.ext_int46_i, item.ext_int45_i, item.ext_int44_i, item.ext_int43_i, item.ext_int42_i, item.ext_int41_i,
		item.ext_int40_i,item.ext_int39_i,item.ext_int38_i,item.ext_int37_i,item.ext_int36_i,item.ext_int35_i,item.ext_int34_i,item.ext_int33_i,
		item.ext_int32_i,item.ext_int31_i,item.ext_int30_i,item.ext_int29_i,item.ext_int28_i,item.ext_int27_i,item.ext_int26_i,item.ext_int25_i,
		item.ext_int24_i,item.ext_int23_i,item.ext_int22_i,item.ext_int21_i,item.ext_int20_i,item.ext_int19_i,item.ext_int18_i,item.ext_int17_i,
		item.ext_int16_i,item.ext_int15_i,item.ext_int14_i,item.ext_int13_i,item.ext_int12_i,item.ext_int11_i,item.ext_int10_i,item.ext_int9_i,
		item.ext_int8_i,item.ext_int7_i,item.ext_int6_i,item.ext_int5_i,item.ext_int4_i,item.ext_int3_i,item.ext_int2_i,item.ext_int1_i,item.ext_int0_i};
		
		//Pending Interrupt
		for(int i=0; i<48; i++) begin
			int_pending[i] = (int_enable[i] &(!(item.ic_ack_read_valid_en && (exp_ack_int_id == IRQ_ID[i])))) ? ext_int[i]:1'b0;
//			if (int_enable[i] && ext_int[i]) begin int_pending[i] = 1; end
      		end

		`uvm_info("SCB",$sformatf("Int_Pending:0x%h",int_pending),UVM_LOW)


		//Clear on ACK read
		if (item.ic_ack_read_valid_en) begin
			//--------For Latching ack_id----------
			latched_ack_id     = zic_ack_id;	//what core reads
			pending_ack_update = 1;
			`uvm_info("SCB", $sformatf("Latched ack_id: 0x%h", latched_ack_id), UVM_MEDIUM)
			//-------------------------------------
	        	index = zic_ack_id - 16;   // or // index = high_lp_id - 16;
	         	if ((index >= 0) && (index < 48)) begin
			        int_pending[index] = 1'b0;
				current_active_id  = index[5:0];
		        	`uvm_info("SCB", $sformatf("Pending cleared on ACK for ID %0d (index %0d)", zic_ack_id, index), UVM_MEDIUM)
			end
		end
		//--------update Latched ack_id----------		
		if (pending_ack_update) begin
		      exp_ack_int_id     = latched_ack_id;
		      pending_ack_update = 0;                 
		      `uvm_info("SCB", $sformatf("Latched ack_id: 0x%h", exp_ack_int_id), UVM_MEDIUM)
		end 
		//---------------------------------------

		//Clear on EoI to Update End of Interrupt Register
		if(item.ic_eoi_valid_i) begin
			ic_eoi_id_r = item.ic_eoi_id_i;
			index 	    = item.ic_eoi_id_i - 16; 
		        if ((index >= 0) && (index < 48)) begin 
				int_pending[index] = 0;
				if (current_active_id == index[5:0]) begin
					current_active_id = '0;
				end
			end
		end
		`uvm_info("EOI",$sformatf("EoI_ID:0x%h",ic_eoi_id_r),UVM_LOW)


		//PR logic
		for(int i =0; i<48; i++) begin
			if(int_pending[i] && int_enable[i] && (IRQ_ID[i] != current_active_id)) begin
				logic [7:0]lp    = int_lvl_pri_val[i];
				logic [5:0]lp_id = IRQ_ID[i];
				$display("lp= %0d, id=%0d", lp, lp_id);
				$display("lp_val= %0d, irq_id=%0d", int_lvl_pri_val[i], IRQ_ID[i]);
				$display("--------------------------------");
				if ((lp[7:5]  > high_lp[7:5]) || 
				   ((lp[7:5] == high_lp[7:5]) && (lp[4:2]  > high_lp[4:2])) || 
				   ((lp[7:5] == high_lp[7:5]) && (lp[4:2] == high_lp[4:2])  && (lp_id > high_lp_id))) begin
					high_lp = lp; 
					high_lp_id = lp_id;
				end
			end
		end
		`uvm_info("PR",$sformatf("High_lp:0x%h, High_lp_ID:0x%h", high_lp, high_lp_id),UVM_LOW)
		
		zic_ack_id = high_lp_id;

		//Processor Acknowledgement
		if(item.ic_ack_read_valid_en==1) begin
		//	zic_ack_id = high_lp_id;
			//exp_ack_int_id = zic_ack_id;		
			//current_active_id = high_lp_id;		//remember claim
			current_active_id = zic_ack_id - 16;		//remember claim
		end
		`uvm_info("PRO_ACK",$sformatf("Current_ACK_Int_ID:0x%h", current_active_id),UVM_LOW)
		

/*		//Processor ack
		if (item.ic_ack_read_valid_en) begin
			latched_ack_id     = zic_ack_id;
			pending_ack_update = 1;
		end
*/			`uvm_info("SCB", $sformatf("Latched ack_id: 0x%h", latched_ack_id), UVM_MEDIUM)

/*		if (pending_ack_update && (latched_ack_id==high_lp_id)) begin
		      exp_ack_int_id     = latched_ack_id;
		      pending_ack_update = 0;                 // consume the update
		      `uvm_info("SCB", $sformatf("IF::Latched ack_id: 0x%h", exp_ack_int_id), UVM_MEDIUM)
		end else begin
			exp_ack_int_id     = high_lp_id;
		      	pending_ack_update = 0;                 // consume the update
		      	`uvm_info("SCB", $sformatf("ELSE::Latched ack_id: 0x%h", exp_ack_int_id), UVM_MEDIUM)
		end

*/
		//Clear on ACK read
/*		if (item.ic_ack_read_valid_en) begin
	        	index = zic_ack_id - 16;   // or // index = high_lp_id - 16;
	         	if ((index >= 0) && (index < 48)) begin
			        int_pending[index] = 1'b0;
				//current_active_id = index[5:0];
		        	`uvm_info("SCB", $sformatf("Pending cleared on ACK for ID %0d (index %0d)", zic_ack_id, index), UVM_MEDIUM)
			end
		end
*/
		// Next pending = highest excluding current active one		
		for (int i = 0; i < 48; i++) begin
			if (int_pending[i] && int_enable[i] && (IRQ_ID[i] != current_active_id)) begin
		               logic [7:0] lp    = int_lvl_pri_val[i];
		               logic [5:0] lp_id = IRQ_ID[i];
		
		               if ((lp[7:5]   > next_lp[7:5]) ||
		                   ((lp[7:5] == next_lp[7:5]) && (lp[4:2] >  next_lp[4:2])) ||
		                   ((lp[7:5] == next_lp[7:5]) && (lp[4:2] == next_lp[4:2]) && (lp_id > next_id)) ) begin
		                  next_lp = lp;
		                  next_id = lp_id;
		               end
		         end
		end

		next_pending_id = (next_id) ? next_id : 8'h10;
		`uvm_info("NXT_PEND",$sformatf("next_LP:0x%h, next_ID:0x%h, nxtp_id:0x%h",next_lp,next_id,next_pending_id),UVM_LOW)
		
		//IRG logic - IRQ request
		if(high_lp > item.active_lvl_pr_i) begin
			exp_interrupt_request      = 1;
			//exp_highest_pending_lvl_pr = high_lp;
			exp_highest_pending_lvl_pr = next_lp;
			exp_ack_int_id = next_id;
		end 
		else begin
			exp_interrupt_request 	   = 0;
			exp_highest_pending_lvl_pr = 0;
		end
		`uvm_info("IRG",$sformatf("IRQ_out:%b, High_Pending_lvl_pr:0x%h",exp_interrupt_request,exp_highest_pending_lvl_pr),UVM_LOW)

		//MMR_READ
		if(item.ic_mmr_read_en_i) begin
			case(item.ic_mmr_read_addr_i)
				16'h0000: exp_mmr_read_data = {24'b0, IC_CFG}	     ; 	//Config. reg
				16'h0004: exp_mmr_read_data = IC_INFO                ;	//Info. reg
				16'h0800: exp_mmr_read_data = {24'b0, next_pending_id};	//Next pending reg - high_lp_id
				16'h0804: exp_mmr_read_data = {24'b0, zic_ack_id}    ;	//Ack reg
				16'h0808: exp_mmr_read_data = {24'b0, ic_eoi_id_r}   ;	//EOI reg
				default: exp_mmr_read_data = 32'b0;
			endcase
		end
 
		//MMR_WRITE
		if(item.ic_mmr_write_en_i) begin

			case(item.ic_mmr_write_addr_i)
				16'h0800: begin next_pending_id = item.ic_mmr_write_data_i[7:0];
					`uvm_info("WRITE_SCB",$sformatf("High_nxtp_int_id:0x%h",next_pending_id), UVM_LOW)
					end
				16'h0804: begin //exp_mmr_read_data = {24'b0, zic_ack}	     ;	//Ack reg
					zic_ack_id = {24'b0, item.ic_mmr_write_data_i[7:0]};
					`uvm_info("WRITE_SCB",$sformatf("ZIC_ACk_REG:0x%h",zic_ack_id), UVM_LOW)
					end
				16'h0808: begin //exp_mmr_read_data = {24'b0, ic_eoi_id_r}   ;	//EOI reg
					ic_eoi_id_r = {24'b0, item.ic_mmr_write_data_i[7:0]};
					`uvm_info("WRITE_SCB",$sformatf("EoI_id:0x%h",ic_eoi_id_r), UVM_LOW)
					end
				default: begin exp_mmr_read_data = 32'b0;
						next_pending_id = 0;
						high_lp_id ='0;
						zic_ack_id ='0;
						ic_eoi_id_r = '0;
					end
			endcase
		end

	end


//################  Compare Logic ######################

//if (item.ic_ack_read_valid_en == 1) begin

//********** COMPARE MMR_READ_DATA *************************//
	if(item.ic_mmr_read_en_i && (item.ic_mmr_read_data_o !== exp_mmr_read_data)) begin
	`uvm_error("SCB",$sformatf("\n \033[1;31m %0t FAIL::***MMR READ RESULTS MISMATCHED***\nREAD_ADDR:0x%h,ACT_MMR_Read_out:%b,EXP_MMR_Read_out:%b \033[0m",
							$time, item.ic_mmr_read_addr_i,item.ic_mmr_read_data_o,exp_mmr_read_data))
	end
	else begin
	`uvm_info("SCB",$sformatf("\n \033[1;32m %0t PASS::***MMR READ RESULTS MATCHED*** \n READ_ADDR:0x%h, ACT_MMR_Read_out:%b, EXP_MMR_Read_out:%b \033[0m",
							$time, item.ic_mmr_read_addr_i,item.ic_mmr_read_data_o, exp_mmr_read_data),UVM_LOW)
	end


//********** COMPARE ACK_INT_ID *************************//
	if (item.ic_ack_read_valid_en == 1) begin	
		if(item.ic_ack_int_id_o	   !== exp_ack_int_id) begin
			`uvm_error("SCB",$sformatf("\n \033[1;31m %0t FAIL:: *** ACK_INT_ID:RESULTS NOT MATCHED *** \n ACT_IRQ_ID:%b, EXP_IRQ_ID:%b \033[0m",
							$time, item.ic_ack_int_id_o,exp_ack_int_id))

		end
		else begin 
			`uvm_info("SCB",$sformatf("\n \033[1;32m %0t PASS:: *** ACK_INT_ID:RESULTS MATCHED *** \n ACT_IRQ_ID:%b, EXP_IRQ_ID:%b \033[0m",
							$time, item.ic_ack_int_id_o, exp_ack_int_id),UVM_LOW)
		end
	end

//********** COMPARE INT_REQ *************************//
	if(item.interrupt_request_o!== exp_interrupt_request) begin
		`uvm_error("SCB",$sformatf("\n \033[1;31m %0t FAIL:: *** IRQ REQ:RESULTS NOT MATCHED *** \n ACT_IRQ:%b, EXP_IRQ:%b \033[0m",
							$time, item.interrupt_request_o, exp_interrupt_request))
	end
	else begin
		`uvm_info("SCB",$sformatf( "\n \033[1;32m %0t PASS:: *** IRQ REQ: RESULTS MATCHED *** \n ACT_IRQ:%b, EXP_IRQ:%b \033[0m",
							$time, item.interrupt_request_o, exp_interrupt_request),UVM_LOW)
	end
//********** COMPARE LVL_PR **********************//
	if(item.highest_pending_lvl_pr_o !== exp_highest_pending_lvl_pr) begin
		`uvm_error("SCB",$sformatf("\n \033[1;31m %0t FAIL:: *** HIGH_PEND_LVL_PR: RESULTS NOT MATCHED *** \n ACT_lvl_pri:0x%h, EXP_lvl_pri:0x%h \033[0m",
							$time, item.highest_pending_lvl_pr_o, exp_highest_pending_lvl_pr))
	end
	else begin 
		`uvm_info("SCB",$sformatf("\n \033[1;32m %0t PASS:: *** HIGH_PEND_LVL_PR: RESULTS MATCHED *** \n ACT_lvl_pri:0x%h, EXP_lvl_pri:0x%h \033[0m",
							$time, item.highest_pending_lvl_pr_o, exp_highest_pending_lvl_pr),UVM_LOW)
	end

//end

	endfunction
	
endclass















//##################################################################

/*	exp1_int_req.push_back(exp_interrupt_request);		 	 
	exp1_high_pend_lvl_pr.push_back(exp_highest_pending_lvl_pr);
	exp1_ack_int_id.push_back(exp_ack_int_id);	
	exp1_mmr_read_data.push_back(exp_mmr_read_data);

	temp = exp1_high_pend_lvl_pr.pop_front();
	$display("ehplp=%0d",temp);

	$display("int_req=%0b, LVL:0x%h, ack_int_id=ox%h, read_data=ox%h", exp1_int_req.pop_front(), exp1_high_pend_lvl_pr.pop_front(), exp1_ack_int_id.pop_front(), exp1_mmr_read_data.pop_front()); */


/*
	//Compare Logic
if (item.ic_ack_read_valid_en == 1) begin
	if(item.ic_mmr_read_en_i && (item.ic_mmr_read_data_o !== exp1_mmr_read_data.pop_front())) begin
		//`uvm_error(get_type_name(),"\n \033[1;31m FAIL::*** MMR READ DATA RESULTS NOT MATCHED *** \033[0m")
	`uvm_error("SCB",$sformatf("\n \033[1;31m %0t FAIL::***MMR READ RESULTS MISMATCHED***\nREAD_ADDR:0x%h,ACT_MMR_Read_out:%b,EXP_MMR_Read_out:%b \033[0m",
							$time, item.ic_mmr_read_addr_i,item.ic_mmr_read_data_o,exp1_mmr_read_data.pop_front()))
	end
	else begin
		//`uvm_info(get_type_name(),"\n \033[1;32m PASS:: *** MMR READ DATA RESULTS MATCHED *** \033[0m",UVM_LOW) 
	`uvm_info("SCB",$sformatf("\n \033[1;32m %0t PASS::***MMR READ RESULTS MATCHED*** \n READ_ADDR:0x%h, ACT_MMR_Read_out:%b, EXP_MMR_Read_out:%b \033[0m",
							$time, item.ic_mmr_read_addr_i,item.ic_mmr_read_data_o, exp1_mmr_read_data.pop_front()),UVM_LOW)
	end

//	if (item.ic_ack_read_valid_en == 1) begin	
		if(item.ic_ack_int_id_o	   !== exp1_ack_int_id.pop_front()) begin
//		if(item.ic_ack_int_id_o	   !== current_ack_int_id) begin
			//`uvm_error(get_type_name(),"\n \033[1;31m FAIL:: *** ACK_INT_ID: RESULTS NOT MATCHED*** \033[0m")
			`uvm_error("SCB",$sformatf("\n \033[1;31m %0t FAIL:: *** ACK_INT_ID:RESULTS NOT MATCHED *** \n ACT_IRQ_ID:%b, EXP_IRQ_ID:%b \033[0m",
							$time, item.ic_ack_int_id_o,exp1_ack_int_id.pop_front()))
//			`uvm_error("SCB",$sformatf("\n \033[1;31m %0t FAIL:: *** ACK_INT_ID:RESULTS NOT MATCHED *** \n ACT_IRQ_ID:%b, EXP_IRQ_ID:%b \033[0m",
//							$time, item.ic_ack_int_id_o,current_ack_int_id))

		end
		else begin 
			//`uvm_info(get_type_name(),"\n \033[1;32m PASS:: *** ACK_INT_ID: RESULTS MATCHED *** \033[0m",UVM_LOW)
			`uvm_info("SCB",$sformatf("\n \033[1;32m %0t PASS:: *** ACK_INT_ID:RESULTS MATCHED *** \n ACT_IRQ_ID:%b, EXP_IRQ_ID:%b \033[0m",
							$time, item.ic_ack_int_id_o, exp1_ack_int_id.pop_front()),UVM_LOW)
//			`uvm_info("SCB",$sformatf("\n \033[1;32m %0t PASS:: *** ACK_INT_ID:RESULTS MATCHED *** \n ACT_IRQ_ID:%b, EXP_IRQ_ID:%b \033[0m",
//							$time, item.ic_ack_int_id_o, current_ack_int_id),UVM_LOW)
		end
//	end

	if(item.interrupt_request_o!== exp1_int_req.pop_front()) begin
		//`uvm_error(get_type_name(),"\n \033[1;31m FAIL:: *** IRQ REQ: RESULTS NOT MATCHED *** \033[0m") 
		`uvm_error("SCB",$sformatf("\n \033[1;31m %0t FAIL:: *** IRQ REQ:RESULTS NOT MATCHED *** \n ACT_IRQ:%b, EXP_IRQ:%b \033[0m",
							$time, item.interrupt_request_o, exp1_int_req.pop_front()))
	end
	else begin
		//`uvm_info(get_type_name(),"\n \033[1;32m PASS:: *** IRQ REQ: RESULTS MATCHED *** \033[0m",UVM_LOW) 
		`uvm_info("SCB",$sformatf( "\n \033[1;32m %0t PASS:: *** IRQ REQ: RESULTS MATCHED *** \n ACT_IRQ:%b, EXP_IRQ:%b \033[0m",
							$time, item.interrupt_request_o, exp1_int_req.pop_front() ),UVM_LOW)
	end

	if(item.highest_pending_lvl_pr_o !== exp1_high_pend_lvl_pr.pop_front()) begin
		//`uvm_error(get_type_name(),"\n \033[1;31m FAIL:: *** HIGH_PEND_LVL_PR: RESULTS NOT MATCHED *** \033[0m")
		`uvm_error("SCB",$sformatf("\n \033[1;31m %0t FAIL:: *** HIGH_PEND_LVL_PR: RESULTS NOT MATCHED *** \n ACT_lvl_pri:0x%h, EXP_lvl_pri:0x%h \033[0m",
							$time, item.highest_pending_lvl_pr_o, exp1_high_pend_lvl_pr.pop_front()))
	end
	else begin 
		//`uvm_info(get_type_name(),"\n \033[1;32m PASS:: *** HIGH_PEND_LVL_PR: RESULTS MATCHED *** \033[0m",UVM_LOW)
		`uvm_info("SCB",$sformatf("\n \033[1;32m %0t PASS:: *** HIGH_PEND_LVL_PR: RESULTS MATCHED *** \n ACT_lvl_pri:0x%h, EXP_lvl_pri:0x%h \033[0m",
							$time, item.highest_pending_lvl_pr_o, exp1_high_pend_lvl_pr.pop_front()),UVM_LOW)
	end

end
*/
//#################################################################



