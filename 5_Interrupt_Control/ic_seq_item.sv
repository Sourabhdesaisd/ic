class ic_seq_item extends uvm_sequence_item;
	
	//Output Signals
	logic 	[31:0]	ic_mmr_read_data_o			;
	logic 	[ 7:0]	ic_ack_int_id_o				;
	logic 		interrupt_request_o			;	
	logic 	[ 7:0] 	highest_pending_lvl_pr_o		;
	
	//Input Signals
	rand logic		ic_rst				;
	rand logic		ic_mmr_write_en_i		;
	rand logic	[15:0]	ic_mmr_write_addr_i	    	;
	rand logic	[31:0]	ic_mmr_write_data_i	    	;
	rand logic		ic_mmr_read_en_i		;
	rand logic	[15:0]	ic_mmr_read_addr_i		;
	rand logic		ic_ack_read_valid_en	    	;
	rand logic		ic_eoi_valid_i			;
	rand logic  	[ 7:0] 	ic_eoi_id_i			;
	rand logic	[ 7:0] 	active_lvl_pr_i			;
	rand logic	[47:0]	global_int_enable_bit_i	    	;
	rand logic 	  	global_int_enable_valid_i	;
	rand logic		ext_int0_i			;
	rand logic		ext_int1_i			;
	rand logic		ext_int2_i			;
	rand logic	        ext_int3_i			;
	rand logic		ext_int4_i			;
	rand logic		ext_int5_i			;
	rand logic	        ext_int6_i			;
	rand logic	        ext_int7_i			;
	rand logic	        ext_int8_i			;
	rand logic 	        ext_int9_i			;
	rand logic 	        ext_int10_i			;
	rand logic 	        ext_int11_i			;
	rand logic 	        ext_int12_i			;
	rand logic 	        ext_int13_i			;
	rand logic 	        ext_int14_i			;
	rand logic 	        ext_int15_i			;
	rand logic 	        ext_int16_i			;
	rand logic 	        ext_int17_i			;
	rand logic 	        ext_int18_i			;
	rand logic 	        ext_int19_i			;
	rand logic 	        ext_int20_i			;
	rand logic 	        ext_int21_i			;
	rand logic 	        ext_int22_i			;
	rand logic 	        ext_int23_i			;
	rand logic 	        ext_int24_i			;
	rand logic 	        ext_int25_i			;
	rand logic 	        ext_int26_i			;
	rand logic 	        ext_int27_i			;
	rand logic 	        ext_int28_i			;
	rand logic 	        ext_int29_i			;
	rand logic 	        ext_int30_i			;
	rand logic 	        ext_int31_i			;
	rand logic 	        ext_int32_i			;
	rand logic 	        ext_int33_i			;
	rand logic 	        ext_int34_i			;
	rand logic 	        ext_int35_i			;
	rand logic 	        ext_int36_i			;
	rand logic 	        ext_int37_i			;
	rand logic 	        ext_int38_i			;
	rand logic 	        ext_int39_i			;
	rand logic 	        ext_int40_i			;
	rand logic 	        ext_int41_i			;
	rand logic 	        ext_int42_i			;
	rand logic 	        ext_int43_i			;
	rand logic 	        ext_int44_i			;
	rand logic 	        ext_int45_i			;
	rand logic 	        ext_int46_i			;
//	rand logic	        ext_int47_i			;
	rand logic 		dbg_mode_valid_i		;
	
	//Factory Registration
	`uvm_object_utils_begin(ic_seq_item)
	
		`uvm_field_int(ic_mmr_read_data_o	,UVM_ALL_ON)
		`uvm_field_int(ic_ack_int_id_o		,UVM_ALL_ON)
		`uvm_field_int(interrupt_request_o	,UVM_ALL_ON)	
		`uvm_field_int(highest_pending_lvl_pr_o	,UVM_ALL_ON)
		
		`uvm_field_int(ic_rst			,UVM_ALL_ON)
		`uvm_field_int(ic_mmr_write_en_i	,UVM_ALL_ON)
		`uvm_field_int(ic_mmr_write_addr_i	,UVM_ALL_ON)
		`uvm_field_int(ic_mmr_write_data_i	,UVM_ALL_ON)
		`uvm_field_int(ic_mmr_read_en_i		,UVM_ALL_ON)
		`uvm_field_int(ic_mmr_read_addr_i	,UVM_ALL_ON)
		`uvm_field_int(ic_ack_read_valid_en	,UVM_ALL_ON)
		`uvm_field_int(ic_eoi_valid_i		,UVM_ALL_ON)
		`uvm_field_int(ic_eoi_id_i		,UVM_ALL_ON)
		`uvm_field_int(active_lvl_pr_i		,UVM_ALL_ON)
		`uvm_field_int(global_int_enable_bit_i	,UVM_ALL_ON)
		`uvm_field_int(global_int_enable_valid_i,UVM_ALL_ON)
		`uvm_field_int(ext_int0_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int1_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int2_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int3_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int4_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int5_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int6_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int7_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int8_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int9_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int10_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int11_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int12_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int13_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int14_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int15_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int16_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int17_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int18_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int19_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int20_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int21_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int22_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int23_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int24_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int25_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int26_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int27_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int28_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int29_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int30_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int31_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int32_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int33_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int34_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int35_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int36_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int37_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int38_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int39_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int40_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int41_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int42_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int43_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int44_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int45_i		,UVM_ALL_ON)
		`uvm_field_int(ext_int46_i		,UVM_ALL_ON)
//		`uvm_field_int(ext_int47_i		,UVM_ALL_ON)
		`uvm_field_int(dbg_mode_valid_i		,UVM_ALL_ON)
	`uvm_object_utils_end
	
	//Construction
	function new(string name ="ic_seq_item");
		super.new(name);
	endfunction
	
/*	
	constraint def_val{soft	ic_rst			 == 0;
			   soft ic_mmr_write_en_i	 == 0;
			   soft ic_mmr_write_addr_i	 =='0;
			   soft ic_mmr_write_data_i	 =='0;
			   soft ic_mmr_read_en_i	 == 0;
			   soft ic_mmr_read_addr_i	 =='0;
			   soft ic_ack_read_valid_en	 == 0;
			   soft ic_eoi_valid_i		 == 0;
			   soft ic_eoi_id_i		 =='0;
			   soft active_lvl_pr_i		 =='0;
			   soft global_int_enable_bit_i	 =='0;
			   soft global_int_enable_valid_i== 0;
			   soft ext_int0_i		 == 0;
			   soft ext_int1_i		 == 0;
			   soft ext_int2_i		 == 0;
			   soft ext_int3_i		 == 0;
			   soft ext_int4_i		 == 0;
			   soft ext_int5_i		 == 0;
			   soft ext_int6_i		 == 0;
			   soft ext_int7_i		 == 0;
			   soft ext_int8_i		 == 0;
			   soft ext_int9_i		 == 0;
			   soft ext_int10_i		 == 0;
			   soft ext_int11_i		 == 0;
			   soft ext_int12_i		 == 0;
			   soft ext_int13_i		 == 0;
			   soft ext_int14_i		 == 0;
			   soft ext_int15_i		 == 0;
			   soft ext_int16_i		 == 0;
			   soft ext_int17_i		 == 0;
			   soft ext_int18_i		 == 0;
			   soft ext_int19_i		 == 0;
			   soft ext_int20_i		 == 0;
			   soft ext_int21_i		 == 0;
			   soft ext_int22_i		 == 0;
			   soft ext_int23_i		 == 0;
			   soft ext_int24_i		 == 0;
			   soft ext_int25_i		 == 0;
			   soft ext_int26_i		 == 0;
			   soft ext_int27_i		 == 0;
			   soft ext_int28_i		 == 0;
			   soft ext_int29_i		 == 0;
			   soft ext_int30_i		 == 0;
			   soft ext_int31_i		 == 0;
			   soft ext_int32_i		 == 0;
			   soft ext_int33_i		 == 0;
			   soft ext_int34_i		 == 0;
			   soft ext_int35_i		 == 0;
			   soft ext_int36_i		 == 0;
			   soft ext_int37_i		 == 0;
			   soft ext_int38_i		 == 0;
			   soft ext_int39_i		 == 0;
			   soft ext_int40_i		 == 0;
			   soft ext_int41_i		 == 0;
			   soft ext_int42_i		 == 0;
			   soft ext_int43_i		 == 0;
			   soft ext_int44_i		 == 0;
			   soft ext_int45_i		 == 0;
			   soft ext_int46_i		 == 0;
//			   soft ext_int47_i		 == 0;
			   soft dbg_mode_valid_i 	 == 0;
	}
*/
endclass

