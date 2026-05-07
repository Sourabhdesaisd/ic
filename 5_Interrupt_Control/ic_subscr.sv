class ic_subscr extends uvm_subscriber #(ic_seq_item);
`uvm_component_utils(ic_subscr)
	
	ic_seq_item item;
	uvm_analysis_imp#(ic_seq_item, ic_subscr) subscr_imp;

	//logic [15:0] addr_array[];
	
	covergroup cg;
		option.per_instance =1;

		//addr_array = new[5];
		//addr_array='{16'h0000,16'h0004,16'h0800,16'h0804,16'h0808};
		
		cp_rst	: coverpoint item.ic_rst			;
		cp_wr_en: coverpoint item.ic_mmr_write_en_i		;
		cp_wr_ad: coverpoint item.ic_mmr_write_addr_i{bins ad1={16'h0000,16'h0004,16'h0800,16'h0804,16'h0808};

							     }
		cp_wr_da: coverpoint item.ic_mmr_write_data_i	    	;
		cp_rd_en: coverpoint item.ic_mmr_read_en_i		;
		cp_rd_ad: coverpoint item.ic_mmr_read_addr_i		;
		cp_rd_vl: coverpoint item.ic_ack_read_valid_en	    	;
		cp_eoi_v: coverpoint item.ic_eoi_valid_i		;
		c_eoi_id: coverpoint item.ic_eoi_id_i			;
		c_act_lp: coverpoint item.active_lvl_pr_i		;
		c_g_en_b: coverpoint item.global_int_enable_bit_i	;
		c_g_en_v: coverpoint item.global_int_enable_valid_i	;
		cp_int00: coverpoint item.ext_int0_i			;
		cp_int01: coverpoint item.ext_int1_i			;
		cp_int02: coverpoint item.ext_int2_i			;
		cp_int03: coverpoint item.ext_int3_i			;
		cp_int04: coverpoint item.ext_int4_i			;
		cp_int05: coverpoint item.ext_int5_i			;
		cp_int06: coverpoint item.ext_int6_i			;
		cp_int07: coverpoint item.ext_int7_i			;
		cp_int08: coverpoint item.ext_int8_i			;
		cp_int09: coverpoint item.ext_int9_i			;
		cp_int10: coverpoint item.ext_int10_i			;
		cp_int11: coverpoint item.ext_int11_i			;
		cp_int12: coverpoint item.ext_int12_i			;
		cp_int13: coverpoint item.ext_int13_i			;
		cp_int14: coverpoint item.ext_int14_i			;
		cp_int15: coverpoint item.ext_int15_i			;
		cp_int16: coverpoint item.ext_int16_i			;
		cp_int17: coverpoint item.ext_int17_i			;
		cp_int18: coverpoint item.ext_int18_i			;
		cp_int19: coverpoint item.ext_int19_i			;
		cp_int20: coverpoint item.ext_int20_i			;
		cp_int21: coverpoint item.ext_int21_i			;
		cp_int22: coverpoint item.ext_int22_i			;
		cp_int23: coverpoint item.ext_int23_i			;
		cp_int24: coverpoint item.ext_int24_i			;
		cp_int25: coverpoint item.ext_int25_i			;
		cp_int26: coverpoint item.ext_int26_i			;
		cp_int27: coverpoint item.ext_int27_i			;
		cp_int28: coverpoint item.ext_int28_i			;
		cp_int29: coverpoint item.ext_int29_i			;
		cp_int30: coverpoint item.ext_int30_i			;
		cp_int31: coverpoint item.ext_int31_i			;
		cp_int32: coverpoint item.ext_int32_i			;
		cp_int33: coverpoint item.ext_int33_i			;
		cp_int34: coverpoint item.ext_int34_i			;
		cp_int35: coverpoint item.ext_int35_i			;
		cp_int36: coverpoint item.ext_int36_i			;
		cp_int37: coverpoint item.ext_int37_i			;
		cp_int38: coverpoint item.ext_int38_i			;
		cp_int39: coverpoint item.ext_int39_i			;
		cp_int40: coverpoint item.ext_int40_i			;
		cp_int41: coverpoint item.ext_int41_i			;
		cp_int42: coverpoint item.ext_int42_i			;
		cp_int43: coverpoint item.ext_int43_i			;
		cp_int44: coverpoint item.ext_int44_i			;
		cp_int45: coverpoint item.ext_int45_i			;
		cp_int46: coverpoint item.ext_int46_i			;
		//cp_int47: coverpoint item.ext_int47_i			;

	endgroup

	function new (string name ="ic_subscr", uvm_component parent);
		super.new(name,parent);
		cg = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		subscr_imp=new("subscr_imp",this);
	endfunction

	virtual function void write(ic_seq_item t);
		item = t;
		cg.sample();
	endfunction

endclass
